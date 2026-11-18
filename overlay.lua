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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 1010.63, ["Fly"] = 1124.13, ["Ride"] = 901.06, ["Fly|Ride"] = 1025.07, ["Neon"] = 6529.89, ["Neon|Ride"] = 4915.63, ["Neon|Fly|Ride"] = 3933.99, ["Mega|Fly|Ride"] = 21174.57}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 393.75, ["Fly"] = 537.31, ["Ride"] = 418.69, ["Fly|Ride"] = 406.88, ["Neon|Fly|Ride"] = 2072.44, ["Mega"] = 9831.25, ["Mega|Fly|Ride"] = 8421.97}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 4331.25, ["Ride"] = 4462.5, ["Fly|Ride"] = 5293.32, ["Neon"] = 25987.37, ["Neon|Fly|Ride"] = 19830.26, ["Mega|Fly|Ride"] = 56175.17}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 120.75, ["Ride"] = 185.07, ["Fly|Ride"] = 582.89, ["Neon"] = 1090.27, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 702.55, ["Mega"] = 3512.67, ["Mega|Fly|Ride"] = 3111.04}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 493.5, ["Ride"] = 498.72, ["Fly|Ride"] = 525, ["Neon|Ride"] = 1845.35, ["Neon|Fly|Ride"] = 1508.07, ["Mega"] = 11089.79, ["Mega|Fly|Ride"] = 6318.59}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 8.34, ["Ride"] = 36.75, ["Fly|Ride"] = 141.19, ["Neon"] = 42.15, ["Neon|Ride"] = 139.81, ["Neon|Fly|Ride"] = 281.24, ["Mega"] = 262.5, ["Mega|Ride"] = 466.65, ["Mega|Fly|Ride"] = 414.75}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 3.59, ["Fly"] = 35.84, ["Ride"] = 23.19, ["Fly|Ride"] = 52.5, ["Neon"] = 21.39, ["Neon|Fly"] = 65.34, ["Neon|Ride"] = 40.04, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 111.57, ["Mega|Fly"] = 328.63, ["Mega|Ride"] = 153.8, ["Mega|Fly|Ride"] = 238.88}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 99.02, ["Fly"] = 116.6, ["Ride"] = 131.25, ["Fly|Ride"] = 139.91, ["Neon"] = 543.64, ["Neon|Ride"] = 418.1, ["Neon|Fly|Ride"] = 702.55, ["Mega"] = 1866.39, ["Mega|Fly|Ride"] = 1668.4}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 31.48, ["Fly"] = 156.22, ["Ride"] = 45.75, ["Fly|Ride"] = 136.66, ["Neon"] = 209.87, ["Neon|Ride"] = 189.6, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 2100, ["Mega|Ride"] = 1259.82, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 21.08, ["Fly"] = 94.5, ["Ride"] = 42.11, ["Fly|Ride"] = 49.51, ["Neon"] = 281.31, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 204.75, ["Mega|Ride"] = 694.12, ["Mega|Fly|Ride"] = 777.94}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 63.21, ["Ride"] = 65.63, ["Fly|Ride"] = 141.19, ["Neon"] = 262.5, ["Neon|Ride"] = 217.88, ["Neon|Fly|Ride"] = 190.32, ["Mega|Fly|Ride"] = 1122.19}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 65.31}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 398.83, ["Fly"] = 406.88, ["Ride"] = 300.57, ["Fly|Ride"] = 380.63, ["Neon"] = 1283.63, ["Neon|Ride"] = 1010.63, ["Neon|Fly|Ride"] = 1048.69, ["Mega|Fly|Ride"] = 4691.28}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 129.45, ["Fly"] = 176.29, ["Ride"] = 131.25, ["Fly|Ride"] = 137.81, ["Neon|Fly|Ride"] = 577.5, ["Mega|Fly|Ride"] = 2613.19}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 3.61, ["Ride"] = 33.72, ["Fly|Ride"] = 63.23, ["Neon"] = 17.07, ["Neon|Fly"] = 62.18, ["Neon|Ride"] = 70.59, ["Mega"] = 115.5, ["Mega|Ride"] = 189, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 131.25, ["Fly"] = 157.5, ["Ride"] = 118.12, ["Fly|Ride"] = 156.22, ["Neon"] = 702.72, ["Neon|Ride"] = 631.98, ["Neon|Fly|Ride"] = 484.8, ["Mega|Fly|Ride"] = 1837.38}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.51, ["Fly"] = 23.19, ["Ride"] = 23.63, ["Fly|Ride"] = 45.94, ["Neon"] = 26.24, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 105, ["Mega"] = 262.5, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 46.66, ["Fly"] = 141.19, ["Ride"] = 78.12, ["Fly|Ride"] = 118.43, ["Neon"] = 129.68, ["Neon|Ride"] = 182.44, ["Neon|Fly|Ride"] = 310.64, ["Mega"] = 980.06, ["Mega|Ride"] = 839.46, ["Mega|Fly|Ride"] = 933.2}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 44.99}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 57.75, ["Ride"] = 118.13, ["Neon"] = 279.57, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 2362.5, ["Mega"] = 3090.31, ["Mega|Fly|Ride"] = 3111.04}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 18.38, ["Fly"] = 393.75, ["Ride"] = 32.33, ["Fly|Ride"] = 84.29, ["Neon"] = 153.83, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 267.54, ["Mega"] = 622.93, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 1685.24}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 38.03, ["Fly"] = 61.93, ["Ride"] = 46.65, ["Fly|Ride"] = 114.19, ["Neon"] = 559.44, ["Neon|Ride"] = 155.59, ["Neon|Fly|Ride"] = 189.6, ["Mega"] = 1681.32, ["Mega|Fly|Ride"] = 940.8}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 46.66, ["Fly"] = 99.75, ["Ride"] = 46.65, ["Fly|Ride"] = 196.88, ["Neon"] = 188.98, ["Neon|Ride"] = 223.12, ["Neon|Fly|Ride"] = 315.94, ["Mega"] = 1679.11, ["Mega|Ride"] = 1250.24, ["Mega|Fly|Ride"] = 1262.88}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 35.97, ["Ride"] = 50.34, ["Fly|Ride"] = 158.17, ["Neon"] = 171.74, ["Neon|Ride"] = 279.97, ["Neon|Fly|Ride"] = 183.74, ["Mega"] = 1207.92, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 980.06}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 41.91, ["Fly"] = 45.94, ["Ride"] = 77.98, ["Fly|Ride"] = 131.25, ["Neon"] = 239.16, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 466.61, ["Mega|Ride"] = 945, ["Mega|Fly|Ride"] = 1207.06}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 5.25, ["Fly"] = 25.72, ["Ride"] = 22.32, ["Fly|Ride"] = 39.38, ["Neon"] = 31.4, ["Neon|Fly"] = 67.47, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 120.75, ["Mega|Fly"] = 28122.34, ["Mega|Ride"] = 139.08, ["Mega|Fly|Ride"] = 238.06}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 283.87, ["Fly"] = 241.5, ["Ride"] = 295, ["Fly|Ride"] = 362.25, ["Neon"] = 1601.37, ["Neon|Ride"] = 1474.59, ["Neon|Fly|Ride"] = 1666.88, ["Mega"] = 10532.72, ["Mega|Fly|Ride"] = 5250}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 13.54, ["Ride"] = 31.55, ["Fly|Ride"] = 137.52, ["Neon"] = 239.16, ["Neon|Ride"] = 304.5, ["Mega"] = 828.94, ["Mega|Fly|Ride"] = 562.46}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 7.77, ["Fly"] = 38.07, ["Ride"] = 21.82, ["Fly|Ride"] = 50.37, ["Neon"] = 39.38, ["Neon|Fly"] = 89.25, ["Neon|Ride"] = 62.93, ["Neon|Fly|Ride"] = 105, ["Mega"] = 370.77, ["Mega|Ride"] = 505.59, ["Mega|Fly|Ride"] = 339.54}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 98.91, ["Fly"] = 125.39, ["Ride"] = 99.05, ["Fly|Ride"] = 155.93, ["Neon"] = 420, ["Neon|Ride"] = 347.6, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 6181.22, ["Mega|Fly"] = 1460.46, ["Mega|Ride"] = 1474.02, ["Mega|Fly|Ride"] = 1343.99}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 15.74, ["Ride"] = 28.88, ["Fly|Ride"] = 59.04, ["Neon"] = 70.6, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 207.38, ["Mega"] = 699.9, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 622.5}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 223.13, ["Fly"] = 223.13, ["Ride"] = 233.17, ["Fly|Ride"] = 337.14, ["Neon"] = 787.5, ["Neon|Ride"] = 751.23, ["Neon|Fly|Ride"] = 770.44, ["Mega"] = 6319.64, ["Mega|Fly|Ride"] = 2784.86}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 27.86}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.94, ["Fly"] = 36.15, ["Ride"] = 27.57, ["Fly|Ride"] = 115.5, ["Neon"] = 19.69, ["Neon|Fly"] = 84.29, ["Neon|Ride"] = 58.78, ["Neon|Fly|Ride"] = 105.34, ["Mega"] = 131.25, ["Mega|Fly"] = 202.98, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 675.94, ["Ride"] = 745.5, ["Fly|Ride"] = 773.31, ["Neon"] = 3343.92, ["Neon|Ride"] = 3053.45, ["Neon|Fly|Ride"] = 3300.96, ["Mega"] = 12217.95, ["Mega|Ride"] = 52491.84, ["Mega|Fly|Ride"] = 11232.09}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 11.82, ["Fly"] = 34.99, ["Ride"] = 26.25, ["Fly|Ride"] = 90.62, ["Neon"] = 75.81, ["Neon|Ride"] = 139.86, ["Neon|Fly|Ride"] = 139.06, ["Mega"] = 511.88, ["Mega|Ride"] = 596.16, ["Mega|Fly|Ride"] = 664.63}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 94.5, ["Ride"] = 118.13, ["Fly|Ride"] = 228.38, ["Neon"] = 525, ["Neon|Ride"] = 562.46, ["Neon|Fly|Ride"] = 630, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 2322.91}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 40.04}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 17.84, ["Ride"] = 55.13, ["Fly|Ride"] = 62.97, ["Neon"] = 129.42, ["Neon|Ride"] = 112.72, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 699.9, ["Mega|Ride"] = 723.19}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.63}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 133.54, ["Fly"] = 168.57, ["Ride"] = 203.44, ["Fly|Ride"] = 353.07, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 701.5, ["Mega|Fly|Ride"] = 2034.94}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 137.81, ["Ride"] = 157.5, ["Fly|Ride"] = 242.82, ["Neon"] = 393.99, ["Neon|Ride"] = 400.26, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 1826.39, ["Mega|Ride"] = 1443.75, ["Mega|Fly|Ride"] = 1640.63}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 51.44}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 56.43, ["Fly"] = 78.75, ["Ride"] = 63.93, ["Fly|Ride"] = 72.19, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 295.32, ["Mega"] = 4212.05, ["Mega|Fly|Ride"] = 1179.68}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 6.89, ["Ride"] = 37.94, ["Fly|Ride"] = 159.1, ["Neon"] = 31.49, ["Neon|Ride"] = 141.16, ["Neon|Fly|Ride"] = 195.57, ["Mega"] = 136.5, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 263.33, ["Mega|Fly|Ride"] = 344.44}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 338.63, ["Fly"] = 515.28, ["Ride"] = 351.75, ["Fly|Ride"] = 393.75, ["Neon"] = 1340.11, ["Neon|Ride"] = 1539.35, ["Neon|Fly|Ride"] = 1307.25, ["Mega|Fly|Ride"] = 4491.16}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 70.3, ["Fly"] = 92.37, ["Ride"] = 78.75, ["Fly|Ride"] = 105, ["Neon"] = 315.37, ["Neon|Ride"] = 351.81, ["Neon|Fly|Ride"] = 262.5, ["Mega|Ride"] = 1882.21, ["Mega|Fly|Ride"] = 1674.7}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3368.38, ["Ride"] = 3724.23, ["Fly|Ride"] = 3017.43, ["Neon|Fly|Ride"] = 13691.48}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 39.38, ["Fly"] = 225.47, ["Ride"] = 42.15, ["Fly|Ride"] = 96.93, ["Neon"] = 984.01, ["Neon|Ride"] = 229.69, ["Neon|Fly|Ride"] = 263.82, ["Mega"] = 1895.91, ["Mega|Ride"] = 1895.91, ["Mega|Fly|Ride"] = 2022.29}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 77.42, ["Ride"] = 65.63, ["Fly|Ride"] = 139.91, ["Neon"] = 400.36, ["Neon|Ride"] = 389.62, ["Neon|Fly|Ride"] = 562.46, ["Mega"] = 6319.64, ["Mega|Fly|Ride"] = 1529.37}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 36.64, ["Fly"] = 76.01, ["Ride"] = 59.73, ["Fly|Ride"] = 118.13, ["Neon"] = 197.03, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 195.56, ["Mega"] = 2625, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 578.82}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 9.19}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 63, ["Ride"] = 56.9, ["Fly|Ride"] = 116.47, ["Neon"] = 442.5, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 500.33, ["Mega|Fly|Ride"] = 1711.25}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 40.69}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 216.57, ["Ride"] = 248.07, ["Fly|Ride"] = 337.14, ["Neon|Fly|Ride"] = 1460.9}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 721.87, ["Ride"] = 761.24, ["Fly|Ride"] = 798, ["Neon|Ride"] = 3229.34, ["Neon|Fly|Ride"] = 2559.38, ["Mega|Fly|Ride"] = 13997.83}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 7.87}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 30.19, ["Fly"] = 52.42, ["Ride"] = 51.19, ["Fly|Ride"] = 75.87, ["Neon"] = 267.62, ["Neon|Ride"] = 177.19, ["Neon|Fly|Ride"] = 196.05, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 658.5}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 9.19}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5139.75, ["Fly|Ride"] = 5145, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 40445.62}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 8.03, ["Fly"] = 42, ["Ride"] = 23.63, ["Fly|Ride"] = 42, ["Neon"] = 91.67, ["Neon|Fly"] = 281.31, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 105, ["Mega"] = 392.44, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 428.7}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 15.72, ["Fly"] = 62.99, ["Ride"] = 31.49, ["Fly|Ride"] = 115.42, ["Neon"] = 141.19, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 842.63, ["Mega|Ride"] = 514.01, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 83.94, ["Fly"] = 139.21, ["Ride"] = 75.87, ["Fly|Ride"] = 108.53, ["Neon"] = 1405.42, ["Neon|Fly|Ride"] = 420, ["Mega"] = 4213.1, ["Mega|Fly|Ride"] = 4354.24}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 11.44, ["Ride"] = 31.49, ["Fly|Ride"] = 139.65, ["Neon"] = 56.9, ["Neon|Ride"] = 75.86, ["Neon|Fly|Ride"] = 712.73, ["Mega"] = 498.32, ["Mega|Ride"] = 417.03, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 2126.25, ["Fly"] = 2528.48, ["Ride"] = 2428.13, ["Fly|Ride"] = 2060.63, ["Neon|Fly|Ride"] = 4526.82, ["Mega|Fly|Ride"] = 14119.41}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 34168.32, ["Ride"] = 33540.94, ["Fly|Ride"] = 24543.75, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 66005.34, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 196610.93}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 28.5, ["Fly"] = 393.75, ["Ride"] = 46.65, ["Fly|Ride"] = 90.27, ["Neon"] = 139.91, ["Neon|Ride"] = 178.38, ["Neon|Fly|Ride"] = 281.24, ["Mega"] = 393.75, ["Mega|Ride"] = 674.1, ["Mega|Fly|Ride"] = 695.1}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 3.84, ["Ride"] = 32.67, ["Fly|Ride"] = 109.58, ["Neon"] = 20.99, ["Neon|Fly"] = 129.42, ["Neon|Ride"] = 54.78, ["Neon|Fly|Ride"] = 111.67, ["Mega"] = 105, ["Mega|Ride"] = 201.2, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 23.45}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 7.66, ["Ride"] = 28.46, ["Fly|Ride"] = 111.57, ["Neon"] = 42.15, ["Neon|Ride"] = 93.34, ["Neon|Fly|Ride"] = 463.32, ["Mega"] = 350.47, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 407.64}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 708.75, ["Ride"] = 687.75, ["Fly|Ride"] = 746.82, ["Neon"] = 2954.79, ["Neon|Fly|Ride"] = 2791.18, ["Mega|Fly|Ride"] = 10886.82}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 882.48, ["Fly"] = 1076.25, ["Ride"] = 917.44, ["Fly|Ride"] = 1048.04, ["Mega|Fly|Ride"] = 10954.02}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 19.69, ["Fly"] = 116.6, ["Ride"] = 43.31, ["Fly|Ride"] = 126.44, ["Neon"] = 185.43, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 196.88, ["Mega|Fly|Ride"] = 758.37}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 30.19}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 56.35, ["Fly"] = 106.32, ["Ride"] = 73.45, ["Fly|Ride"] = 131.25, ["Neon"] = 466.32, ["Neon|Ride"] = 398.14, ["Neon|Fly|Ride"] = 410.82, ["Mega|Ride"] = 1684.19, ["Mega|Fly|Ride"] = 1524.1}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 63.21, ["Ride"] = 93.28, ["Fly|Ride"] = 183.07, ["Neon"] = 450.19, ["Neon|Ride"] = 518.22, ["Neon|Fly|Ride"] = 511.88, ["Mega"] = 2122.58, ["Mega|Fly|Ride"] = 2179.01}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 3.94, ["Fly"] = 32.78, ["Ride"] = 22.31, ["Fly|Ride"] = 56.43, ["Neon"] = 30.57, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 77.42, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 351.81, ["Mega|Ride"] = 281.24, ["Mega|Fly|Ride"] = 371.44}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 61.69, ["Fly"] = 85.32, ["Ride"] = 68.92, ["Fly|Ride"] = 141.19, ["Neon|Ride"] = 348.65, ["Neon|Fly|Ride"] = 275.63, ["Mega|Fly|Ride"] = 982.94}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 3.94, ["Fly"] = 42.15, ["Ride"] = 42, ["Fly|Ride"] = 73.6, ["Neon"] = 22.31, ["Neon|Fly"] = 267.62, ["Neon|Ride"] = 87.47, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 156.32, ["Mega|Fly"] = 983.77, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 392.44}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 19, ["Fly"] = 65.63, ["Ride"] = 31.8, ["Fly|Ride"] = 116.6, ["Neon"] = 132.77, ["Neon|Fly"] = 93.3, ["Neon|Ride"] = 119, ["Neon|Fly|Ride"] = 288.1, ["Mega|Fly|Ride"] = 728.44}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 28.32, ["Ride"] = 46.65, ["Fly|Ride"] = 281.31, ["Neon"] = 141.19, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 702.55, ["Mega"] = 702.55, ["Mega|Ride"] = 2106.56, ["Mega|Fly|Ride"] = 773.11}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 14.83, ["Fly"] = 44.84, ["Ride"] = 50.14, ["Fly|Ride"] = 56.9, ["Neon"] = 103.69, ["Neon|Fly"] = 421.42, ["Neon|Ride"] = 124.29, ["Neon|Fly|Ride"] = 249.38, ["Mega|Ride"] = 942.43, ["Mega|Fly|Ride"] = 913.21}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6104.78, ["Ride"] = 5906.25, ["Fly|Ride"] = 4462.49, ["Neon"] = 30905.22, ["Neon|Fly|Ride"] = 29085.15}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 199.5, ["Fly"] = 236.24, ["Ride"] = 223.36, ["Fly|Ride"] = 275.63, ["Neon|Ride"] = 576.16, ["Neon|Fly|Ride"] = 498.75, ["Mega|Fly|Ride"] = 2428.13}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 31.5, ["Fly"] = 77.54, ["Ride"] = 59.07, ["Fly|Ride"] = 97.39, ["Neon"] = 75.85, ["Neon|Fly"] = 241.5, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 153.76, ["Mega"] = 282.19, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 346.5}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 3.41, ["Fly"] = 40.82, ["Ride"] = 23.33, ["Fly|Ride"] = 99.05, ["Neon"] = 25.3, ["Neon|Ride"] = 56.69, ["Mega"] = 170.63}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 29.17, ["Fly"] = 124.76, ["Ride"] = 78.75, ["Fly|Ride"] = 146.19, ["Neon"] = 110.25, ["Neon|Fly"] = 335.04, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 239.11, ["Mega"] = 417.63, ["Mega|Ride"] = 438.18, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 18571.88, ["Ride"] = 14496.55, ["Fly|Ride"] = 10368.75, ["Neon|Fly|Ride"] = 23625, ["Mega|Fly|Ride"] = 105327.09}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 131.25, ["Ride"] = 191.21, ["Fly|Ride"] = 262.5, ["Neon"] = 1399.28, ["Neon|Ride"] = 746.58, ["Neon|Fly|Ride"] = 933.2}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 43.31, ["Fly"] = 436.41, ["Ride"] = 52.41, ["Fly|Ride"] = 104.99, ["Neon|Fly"] = 466.44, ["Neon|Ride"] = 288.75, ["Neon|Fly|Ride"] = 267.54, ["Mega|Fly|Ride"] = 1658.92}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 8.8, ["Ride"] = 25.3, ["Fly|Ride"] = 39.38, ["Neon"] = 65.63, ["Neon|Ride"] = 78.73, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 2527.86, ["Mega|Ride"] = 492.19, ["Mega|Fly|Ride"] = 842.63}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 430.5, ["Fly"] = 842.83, ["Ride"] = 446.25, ["Fly|Ride"] = 393.75, ["Neon"] = 1539.35, ["Neon|Ride"] = 1578.87, ["Neon|Fly|Ride"] = 1443.75, ["Mega"] = 5265.31, ["Mega|Fly|Ride"] = 4935}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 7.61, ["Ride"] = 33.72, ["Fly|Ride"] = 183.33, ["Neon"] = 29.54, ["Neon|Ride"] = 104.29, ["Neon|Fly|Ride"] = 140.62, ["Mega"] = 132.99, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 285.45}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 105, ["Fly"] = 156.22, ["Ride"] = 161.44, ["Fly|Ride"] = 233.17, ["Neon"] = 529.4, ["Neon|Ride"] = 422.63, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 2247.7, ["Mega|Ride"] = 3441.04, ["Mega|Fly|Ride"] = 1704.94}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 12.17, ["Fly"] = 22.32, ["Ride"] = 18.38, ["Fly|Ride"] = 36.66, ["Neon|Ride"] = 102.67, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 2527.86, ["Mega|Fly|Ride"] = 575.11}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 10.5}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 61.69, ["Ride"] = 112.74, ["Fly|Ride"] = 525, ["Neon"] = 210, ["Neon|Fly"] = 1685.65, ["Neon|Ride"] = 356.83, ["Neon|Fly|Ride"] = 406.08, ["Mega"] = 1123.85, ["Mega|Ride"] = 1399.79, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 11.82, ["Fly"] = 99.05, ["Ride"] = 31.54, ["Fly|Ride"] = 70.6, ["Neon"] = 87.94, ["Neon|Ride"] = 106.32, ["Neon|Fly|Ride"] = 205.41, ["Mega|Ride"] = 501.48, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 13.9}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 26.25, ["Fly"] = 210, ["Ride"] = 78.75, ["Fly|Ride"] = 279.8, ["Neon"] = 133.88, ["Neon|Ride"] = 202.73, ["Neon|Fly|Ride"] = 259.04, ["Mega"] = 1545.16, ["Mega|Ride"] = 729.75, ["Mega|Fly|Ride"] = 734.99}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.94, ["Ride"] = 31.49, ["Fly|Ride"] = 118.13, ["Neon"] = 19.06, ["Neon|Ride"] = 138, ["Neon|Fly|Ride"] = 281.24, ["Mega"] = 96.68, ["Mega|Ride"] = 337.05, ["Mega|Fly|Ride"] = 422.28}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 12.86, ["Fly"] = 42, ["Ride"] = 35.76, ["Fly|Ride"] = 91.88, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 131.25, ["Mega|Fly|Ride"] = 773.11}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 393.75, ["Fly"] = 437.75, ["Ride"] = 301.88, ["Fly|Ride"] = 466.36, ["Neon|Fly"] = 1368.54, ["Neon|Fly|Ride"] = 1784.26, ["Mega|Fly|Ride"] = 8847.49}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 42, ["Ride"] = 57.31, ["Fly|Ride"] = 131.25, ["Neon"] = 214.93, ["Neon|Ride"] = 203.58, ["Neon|Fly|Ride"] = 210.67, ["Mega"] = 704.96, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 983.77}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 44.02, ["Ride"] = 80.53, ["Fly|Ride"] = 126.44, ["Neon"] = 203.1, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 261.19, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 825.79}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 27.67, ["Fly"] = 78.75, ["Ride"] = 49.49, ["Fly|Ride"] = 108.47, ["Neon"] = 59.3, ["Neon|Ride"] = 91.01, ["Neon|Fly|Ride"] = 286.5, ["Mega"] = 288.62, ["Mega|Ride"] = 349.96, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 11191.35, ["Ride"] = 7415.63, ["Fly|Ride"] = 7609.88, ["Neon|Fly|Ride"] = 17244.94, ["Mega|Fly|Ride"] = 39372.9}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1640.63, ["Fly"] = 2564.69, ["Ride"] = 1693.13, ["Fly|Ride"] = 2029.12, ["Neon"] = 4593.75, ["Neon|Ride"] = 5519.15, ["Neon|Fly|Ride"] = 4423.13, ["Mega|Fly|Ride"] = 20081.25}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 378, ["Ride"] = 421.42, ["Fly|Ride"] = 446.25, ["Neon"] = 2107.07, ["Neon|Ride"] = 1723.17, ["Neon|Fly|Ride"] = 1418.78, ["Mega"] = 16852.35, ["Mega|Fly|Ride"] = 6460.77}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 12.58, ["Fly"] = 30.19, ["Ride"] = 27.41, ["Fly|Ride"] = 41.79, ["Neon"] = 65.63, ["Neon|Ride"] = 102.85, ["Neon|Fly|Ride"] = 167.49, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 6.24, ["Ride"] = 50.58, ["Fly|Ride"] = 153.56, ["Neon"] = 24.94, ["Neon|Ride"] = 78.75, ["Mega"] = 127.21, ["Mega|Ride"] = 175.24, ["Mega|Fly|Ride"] = 246.48}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 34.73, ["Fly"] = 53.82, ["Ride"] = 43.74, ["Fly|Ride"] = 94.5, ["Neon|Ride"] = 145.37, ["Neon|Fly|Ride"] = 137.81, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.72, ["Fly"] = 30.57, ["Ride"] = 20.9, ["Fly|Ride"] = 42.14, ["Neon"] = 26.24, ["Neon|Fly"] = 281.31, ["Neon|Ride"] = 42.15, ["Neon|Fly|Ride"] = 92.71, ["Mega"] = 281.24, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 217.22}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 311.36, ["Fly"] = 320.24, ["Ride"] = 325.5, ["Fly|Ride"] = 360.94, ["Neon"] = 1264.25, ["Neon|Ride"] = 1334.51, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 4588.06}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 24.94, ["Fly"] = 45.76, ["Ride"] = 36.74, ["Fly|Ride"] = 76.95, ["Neon"] = 183.33, ["Neon|Fly"] = 281.31, ["Neon|Ride"] = 156.96, ["Neon|Fly|Ride"] = 178.5, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 618.29}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 10.5, ["Fly"] = 21.11, ["Ride"] = 26.24, ["Fly|Ride"] = 42, ["Neon"] = 141.19, ["Neon|Fly"] = 136.5, ["Neon|Ride"] = 109.67, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 526.65, ["Mega|Ride"] = 580.37, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 392.44, ["Fly"] = 787.5, ["Ride"] = 472.5, ["Fly|Ride"] = 684.8, ["Mega|Fly|Ride"] = 8426.18}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1100.93, ["Ride"] = 1170.75, ["Fly|Ride"] = 1172.07, ["Neon"] = 4930.52, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 17110.02}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 74.81, ["Fly"] = 116.65, ["Ride"] = 86.46, ["Fly|Ride"] = 105.32, ["Neon"] = 501.5, ["Neon|Ride"] = 414.75, ["Neon|Fly|Ride"] = 525, ["Mega|Fly|Ride"] = 3890.24}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 160.78, ["Fly"] = 174.57, ["Ride"] = 183.33, ["Fly|Ride"] = 210, ["Neon"] = 702.72, ["Neon|Ride"] = 629.5, ["Neon|Fly|Ride"] = 615.56, ["Mega|Ride"] = 2949.17, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 24.91, ["Ride"] = 36.75, ["Neon"] = 199.5, ["Neon|Fly"] = 421.42, ["Neon|Ride"] = 272.99, ["Neon|Fly|Ride"] = 131.25, ["Mega|Ride"] = 933.2, ["Mega|Fly|Ride"] = 856.22}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 147.47, ["Ride"] = 141.19, ["Fly|Ride"] = 597.19, ["Neon"] = 1545.54, ["Neon|Ride"] = 1334.51, ["Neon|Fly|Ride"] = 997.5, ["Mega|Fly|Ride"] = 3019.74}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 1640.63, ["Fly"] = 2039.65, ["Ride"] = 2246.14, ["Fly|Ride"] = 1967.44, ["Neon|Fly|Ride"] = 6819.94, ["Mega|Fly|Ride"] = 48450.48}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 56.89, ["Ride"] = 51.19, ["Fly|Ride"] = 196.88, ["Neon"] = 289.74, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 350.48, ["Mega"] = 2100.24, ["Mega|Ride"] = 2317.22, ["Mega|Fly|Ride"] = 1757.91}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 573.55, ["Fly"] = 675.94, ["Ride"] = 583.95, ["Fly|Ride"] = 629.9, ["Neon|Ride"] = 1260, ["Neon|Fly|Ride"] = 1246.88, ["Mega|Fly|Ride"] = 2782.5}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 42, ["Fly"] = 81.23, ["Ride"] = 59.07, ["Fly|Ride"] = 90.62, ["Neon"] = 252.86, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 262.5, ["Mega|Fly|Ride"] = 989.73}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.73, ["Fly"] = 28.5, ["Ride"] = 19.19, ["Fly|Ride"] = 44.62, ["Neon"] = 23.13, ["Neon|Fly"] = 65.62, ["Neon|Ride"] = 36.87, ["Neon|Fly|Ride"] = 69.62, ["Mega"] = 140.51, ["Mega|Fly"] = 348.65, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 215.25}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 47.18, ["Ride"] = 52.45, ["Fly|Ride"] = 105.36, ["Neon"] = 702.72, ["Neon|Ride"] = 773.11, ["Neon|Fly|Ride"] = 311.48, ["Mega|Ride"] = 1123.85, ["Mega|Fly|Ride"] = 955.47}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 573.57, ["Fly"] = 660.57, ["Ride"] = 576.17, ["Fly|Ride"] = 590.63, ["Neon"] = 1903.13, ["Neon|Ride"] = 1771.88, ["Neon|Fly|Ride"] = 1968.75, ["Mega|Fly|Ride"] = 7126.88}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 485.63, ["Ride"] = 565.85, ["Fly|Ride"] = 714, ["Neon"] = 280800.74, ["Neon|Ride"] = 4068.75, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 13623.02}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 15.64, ["Fly"] = 42.15, ["Ride"] = 21, ["Fly|Ride"] = 41.1, ["Neon"] = 210.72, ["Neon|Ride"] = 156.32, ["Neon|Fly|Ride"] = 132.57, ["Mega|Fly|Ride"] = 466.61}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 6.57, ["Ride"] = 26.25, ["Fly|Ride"] = 77.44, ["Neon"] = 53.72, ["Neon|Ride"] = 78.2, ["Neon|Fly|Ride"] = 83.22, ["Mega"] = 1683.14, ["Mega|Ride"] = 443.87, ["Mega|Fly|Ride"] = 478.21}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 4.69, ["Ride"] = 31.49, ["Fly|Ride"] = 99.05, ["Neon"] = 16.86, ["Neon|Fly"] = 112.74, ["Neon|Ride"] = 45.82, ["Neon|Fly|Ride"] = 141.16, ["Mega"] = 129.56, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 251.85}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 37.28, ["Fly"] = 59.07, ["Ride"] = 53.7, ["Fly|Ride"] = 99.65, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 194.25, ["Mega|Fly|Ride"] = 779.44}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 40.04, ["Ride"] = 87.94, ["Fly|Ride"] = 140.63, ["Neon"] = 323.45, ["Neon|Ride"] = 344.44, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 1119.64, ["Mega|Ride"] = 1545.16, ["Mega|Fly|Ride"] = 1212.75}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 14.65, ["Fly"] = 57.14, ["Ride"] = 36.75, ["Fly|Ride"] = 103.69, ["Neon"] = 109.14, ["Neon|Ride"] = 93.14, ["Neon|Fly|Ride"] = 153.8, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 455.46}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 30.19, ["Fly"] = 99.05, ["Ride"] = 36.75, ["Fly|Ride"] = 87.33, ["Neon"] = 349.79, ["Neon|Ride"] = 196.97, ["Neon|Fly|Ride"] = 156.32, ["Mega"] = 2100, ["Mega|Ride"] = 1213.16, ["Mega|Fly|Ride"] = 1157.56}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.71, ["Fly"] = 31.49, ["Ride"] = 16.87, ["Fly|Ride"] = 42.15, ["Neon"] = 25.71, ["Neon|Ride"] = 37.94, ["Neon|Fly|Ride"] = 92.71, ["Mega"] = 177.19, ["Mega|Ride"] = 195.92, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 5.71, ["Fly"] = 56.9, ["Ride"] = 30.18, ["Fly|Ride"] = 1844.25, ["Neon"] = 28.87, ["Neon|Fly"] = 156.28, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 141.16, ["Mega"] = 195.19, ["Mega|Fly"] = 478.21, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 41.97, ["Fly"] = 82.19, ["Ride"] = 62.99, ["Fly|Ride"] = 78.12, ["Neon"] = 417.62, ["Neon|Ride"] = 232.46, ["Neon|Fly|Ride"] = 221.53, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1890, ["Fly"] = 1817.82, ["Ride"] = 1743, ["Fly|Ride"] = 1807.32, ["Neon|Fly|Ride"] = 4095, ["Mega|Fly|Ride"] = 14962.5}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 462, ["Fly"] = 664.79, ["Ride"] = 576.29, ["Fly|Ride"] = 498.75, ["Neon"] = 3109.86, ["Neon|Ride"] = 2247.7, ["Neon|Fly|Ride"] = 2345.65, ["Mega|Fly|Ride"] = 8707.4}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 229.69, ["Ride"] = 281.31, ["Fly|Ride"] = 357, ["Neon"] = 1313.74, ["Neon|Ride"] = 1415.88, ["Neon|Fly|Ride"] = 1545.16, ["Mega|Fly|Ride"] = 6023.68}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 42}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 39.38, ["Fly"] = 65.63, ["Ride"] = 44.63, ["Fly|Ride"] = 70.6, ["Neon"] = 288.75, ["Neon|Ride"] = 253.79, ["Neon|Fly|Ride"] = 316, ["Mega"] = 1157.56, ["Mega|Ride"] = 1545.16, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 33704.68, ["Fly"] = 23625, ["Ride"] = 34781.25, ["Fly|Ride"] = 17062.5, ["Neon|Fly|Ride"] = 36750, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 261.19, ["Fly"] = 337.14, ["Ride"] = 262.5, ["Fly|Ride"] = 354.38, ["Neon"] = 954.52, ["Neon|Fly"] = 1098.44, ["Neon|Ride"] = 630, ["Neon|Fly|Ride"] = 853.13, ["Mega"] = 3266.18, ["Mega|Ride"] = 6532.33, ["Mega|Fly|Ride"] = 2624.99}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 72.19, ["Fly"] = 413.44, ["Ride"] = 249.38, ["Fly|Ride"] = 154.88, ["Neon|Fly|Ride"] = 842.63, ["Mega|Fly|Ride"] = 4073.02}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 118.13, ["Ride"] = 105, ["Fly|Ride"] = 156.22, ["Neon|Ride"] = 737.3, ["Neon|Fly|Ride"] = 511.87, ["Mega"] = 14044.33, ["Mega|Fly|Ride"] = 1400.86}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 17.07, ["Fly"] = 94.5, ["Ride"] = 30.19, ["Fly|Ride"] = 98.44, ["Neon|Ride"] = 135.19, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 1181.25, ["Mega|Fly|Ride"] = 535.07}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 3937.39, ["Ride"] = 4410, ["Fly|Ride"] = 4583.25, ["Neon|Fly|Ride"] = 16832.82}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 21.84, ["Fly"] = 45.94, ["Ride"] = 32.82, ["Fly|Ride"] = 56.44, ["Neon"] = 333.94, ["Neon|Ride"] = 200.15, ["Neon|Fly|Ride"] = 156.32, ["Mega|Fly|Ride"] = 633.29}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 40.04, ["Fly"] = 141.19, ["Ride"] = 48.56, ["Fly|Ride"] = 104.08, ["Neon"] = 233.23, ["Neon|Fly"] = 1405.42, ["Neon|Ride"] = 280.18, ["Neon|Fly|Ride"] = 311.48, ["Mega|Fly|Ride"] = 842.63}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 564.38, ["Ride"] = 572.25, ["Fly|Ride"] = 639.45, ["Neon"] = 1597.25, ["Neon|Ride"] = 1378.13, ["Neon|Fly|Ride"] = 1311.45, ["Mega"] = 5265.31, ["Mega|Fly|Ride"] = 4160.63}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 14.43, ["Fly"] = 28.46, ["Ride"] = 24.44, ["Fly|Ride"] = 49.88, ["Neon"] = 98.44, ["Neon|Ride"] = 104.7, ["Neon|Fly|Ride"] = 119.44, ["Mega"] = 702.55, ["Mega|Fly|Ride"] = 485.63}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 15.84, ["Fly"] = 42.15, ["Ride"] = 34.13, ["Fly|Ride"] = 466.32, ["Neon"] = 62.18, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 138}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 93.3, ["Ride"] = 124.69, ["Fly|Ride"] = 245.44, ["Neon"] = 393.75, ["Neon|Ride"] = 671.95, ["Neon|Fly|Ride"] = 809.55, ["Mega|Ride"] = 2645.84, ["Mega|Fly|Ride"] = 2650.05}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 24.05, ["Ride"] = 91.88, ["Fly|Ride"] = 132.77, ["Neon"] = 77.44, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 220.5, ["Mega"] = 220.35, ["Mega|Fly"] = 708.75, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 383.25}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3346.88, ["Ride"] = 3278.63, ["Fly|Ride"] = 3209.06, ["Neon"] = 7612.5, ["Neon|Ride"] = 17905.61, ["Neon|Fly|Ride"] = 8489.25, ["Mega"] = 63196.26, ["Mega|Fly|Ride"] = 34468.88}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 39.38, ["Fly"] = 115.5, ["Ride"] = 140.63, ["Fly|Ride"] = 116.7, ["Neon"] = 168, ["Neon|Ride"] = 189.6, ["Neon|Fly|Ride"] = 362.88, ["Mega|Fly|Ride"] = 880.56}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 5906.25, ["Ride"] = 6883.76, ["Fly|Ride"] = 5775, ["Neon|Fly|Ride"] = 17062.5, ["Mega|Fly|Ride"] = 60386.15}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.56, ["Fly"] = 21.08, ["Ride"] = 18.38, ["Fly|Ride"] = 41.1, ["Neon"] = 20.03, ["Neon|Fly"] = 90.57, ["Neon|Ride"] = 32.67, ["Neon|Fly|Ride"] = 90.27, ["Mega"] = 131.25, ["Mega|Fly|Ride"] = 310.73}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 23.63, ["Fly"] = 35.44, ["Ride"] = 33.28, ["Fly|Ride"] = 49.73, ["Neon"] = 141.19, ["Neon|Ride"] = 281.24, ["Neon|Fly|Ride"] = 513.19, ["Mega|Ride"] = 1477.23, ["Mega|Fly|Ride"] = 927.94}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.14}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 10.5, ["Ride"] = 32.82, ["Fly|Ride"] = 123.41, ["Neon"] = 112.74, ["Neon|Ride"] = 127.24, ["Neon|Fly|Ride"] = 214.89, ["Mega|Ride"] = 870.01, ["Mega|Fly|Ride"] = 856.22}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 34.13, ["Fly"] = 84.29, ["Ride"] = 51.19, ["Fly|Ride"] = 141.19, ["Neon"] = 181.22, ["Neon|Ride"] = 181.18, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 840, ["Mega|Ride"] = 933.2, ["Mega|Fly|Ride"] = 931.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 15.82, ["Fly"] = 35.84, ["Ride"] = 21, ["Fly|Ride"] = 39.38, ["Neon"] = 141.61, ["Neon|Ride"] = 174.57, ["Neon|Fly|Ride"] = 158.82, ["Mega"] = 1124.9, ["Mega|Fly|Ride"] = 670.74}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 6562.5}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2999.73}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 27.57}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 294.93, ["Fly"] = 351.9, ["Ride"] = 323.45, ["Fly|Ride"] = 307.64}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 29.87, ["Fly"] = 107.47, ["Ride"] = 39.38, ["Fly|Ride"] = 105, ["Neon"] = 156.13, ["Neon|Ride"] = 141.75, ["Neon|Fly|Ride"] = 281.24, ["Mega"] = 807.87, ["Mega|Ride"] = 562.46, ["Mega|Fly|Ride"] = 778.32}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 8.44}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 6.3, ["Ride"] = 26.25, ["Neon|Ride"] = 84.28, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2467.5}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 202.92, ["Ride"] = 204.41, ["Fly|Ride"] = 419.31, ["Neon"] = 918.75, ["Neon|Ride"] = 837.51, ["Mega|Fly|Ride"] = 2378.3}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 111.99, ["Ride"] = 207.38, ["Fly|Ride"] = 280.2, ["Neon"] = 842.83, ["Neon|Ride"] = 778.07, ["Neon|Fly|Ride"] = 947.96, ["Mega"] = 3423.15, ["Mega|Fly|Ride"] = 3158.77}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 177.18, ["Ride"] = 180.7, ["Fly|Ride"] = 194.25, ["Neon"] = 799.32, ["Neon|Ride"] = 838, ["Neon|Fly|Ride"] = 855.8, ["Mega"] = 4634.41, ["Mega|Fly|Ride"] = 2937.38}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 984.38, ["Fly"] = 2528.48, ["Ride"] = 1076.25, ["Fly|Ride"] = 1115.63, ["Neon"] = 5338.24, ["Neon|Ride"] = 5599.14, ["Neon|Fly|Ride"] = 4593.75, ["Mega|Fly|Ride"] = 20011.11}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 17.21, ["Fly"] = 82.19, ["Ride"] = 39.38, ["Fly|Ride"] = 86.63, ["Neon"] = 39.38, ["Neon|Ride"] = 293.97, ["Neon|Fly|Ride"] = 437.07, ["Mega"] = 736.24, ["Mega|Fly|Ride"] = 840.53}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 654.93, ["Fly"] = 2100, ["Ride"] = 759.84, ["Fly|Ride"] = 1050}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 63.16}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 18.38, ["Fly"] = 393.75, ["Ride"] = 40.05, ["Fly|Ride"] = 98.44, ["Neon"] = 85.32, ["Neon|Ride"] = 104.89, ["Neon|Fly|Ride"] = 143.07, ["Mega"] = 363.57, ["Mega|Ride"] = 446.25, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 10.54, ["Fly"] = 32.82, ["Ride"] = 31.56, ["Fly|Ride"] = 94.5, ["Neon"] = 61.69, ["Neon|Ride"] = 83.61, ["Neon|Fly|Ride"] = 152.83, ["Mega"] = 918.75, ["Mega|Ride"] = 351.81, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 65.62}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 23.3, ["Fly"] = 108.92, ["Ride"] = 36.74, ["Fly|Ride"] = 63.23, ["Neon"] = 177.19, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 544.77, ["Mega"] = 816.31, ["Mega|Fly|Ride"] = 699.9}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 25.3, ["Fly"] = 42.15, ["Ride"] = 46.36, ["Fly|Ride"] = 39.38, ["Neon"] = 233.23, ["Neon|Fly"] = 242.54, ["Neon|Ride"] = 278.25, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 983.77, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 4987.5, ["Fly"] = 11237.99, ["Ride"] = 6181.06, ["Fly|Ride"] = 4725, ["Neon|Fly|Ride"] = 10078.69, ["Mega|Fly|Ride"] = 37758}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 10.4, ["Fly"] = 79.75, ["Ride"] = 39.38, ["Fly|Ride"] = 131.15, ["Neon"] = 79.48, ["Neon|Ride"] = 99.02, ["Neon|Fly|Ride"] = 141.16, ["Mega"] = 522.6, ["Mega|Ride"] = 281.24, ["Mega|Fly|Ride"] = 405.15}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 21.97}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 112.2, ["Fly"] = 372.98, ["Ride"] = 144.27, ["Fly|Ride"] = 288.75, ["Neon"] = 418.69, ["Neon|Ride"] = 483, ["Neon|Fly|Ride"] = 609.86, ["Mega|Ride"] = 4213.1, ["Mega|Fly|Ride"] = 1811.25}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 69.44, ["Ride"] = 111.57, ["Fly|Ride"] = 208.62, ["Neon"] = 327.6, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 288.75, ["Mega|Ride"] = 1398.75, ["Mega|Fly|Ride"] = 1487.24}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 22.32, ["Fly"] = 70.3, ["Ride"] = 31.46, ["Fly|Ride"] = 65.63, ["Neon"] = 183.33, ["Neon|Ride"] = 107.45, ["Neon|Fly|Ride"] = 164.07, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 4.72, ["Fly"] = 48.77, ["Ride"] = 33.71, ["Fly|Ride"] = 99.75, ["Neon"] = 24.72, ["Neon|Fly"] = 183.33, ["Neon|Ride"] = 41.97, ["Neon|Fly|Ride"] = 136.94, ["Mega"] = 152.83, ["Mega|Fly"] = 7034.11, ["Mega|Ride"] = 143.01, ["Mega|Fly|Ride"] = 204.75}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 13, ["Fly"] = 49.88, ["Ride"] = 26.25, ["Fly|Ride"] = 91.88, ["Neon"] = 70.32, ["Neon|Ride"] = 78.73, ["Neon|Fly|Ride"] = 209.67, ["Mega"] = 340.23, ["Mega|Ride"] = 499.28, ["Mega|Fly|Ride"] = 538.13}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 16.86, ["Fly"] = 25.65, ["Ride"] = 31.49, ["Fly|Ride"] = 48.55, ["Neon"] = 112.74, ["Neon|Ride"] = 141.75, ["Neon|Fly|Ride"] = 111.57, ["Mega|Fly|Ride"] = 637.88}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 212.63}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 24.94, ["Ride"] = 109.6, ["Fly|Ride"] = 141.19, ["Neon"] = 186.58, ["Neon|Ride"] = 421.32, ["Mega"] = 933.2, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 1360.84}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 118.9, ["Ride"] = 443.63, ["Fly|Ride"] = 262.49, ["Neon|Ride"] = 820.32, ["Neon|Fly|Ride"] = 761.53}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 39.87, ["Fly"] = 211.99, ["Ride"] = 78.15, ["Fly|Ride"] = 249.38, ["Neon"] = 310.8, ["Neon|Ride"] = 387.19, ["Neon|Fly|Ride"] = 475.04, ["Mega"] = 1179.68, ["Mega|Ride"] = 1108.19, ["Mega|Fly|Ride"] = 988.32}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 656.25, ["Fly"] = 780.94, ["Ride"] = 682.49, ["Fly|Ride"] = 702.19, ["Neon|Ride"] = 2949.17, ["Neon|Fly|Ride"] = 2275.08, ["Mega|Ride"] = 7899.54, ["Mega|Fly|Ride"] = 6429.94}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 262.5, ["Ride"] = 330.75, ["Fly|Ride"] = 341.25, ["Neon"] = 1152.64, ["Neon|Ride"] = 1157.56, ["Neon|Fly|Ride"] = 1516.73, ["Mega"] = 4212.05, ["Mega|Fly|Ride"] = 4212.05}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 82.67}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 10.4, ["Fly"] = 28.53, ["Ride"] = 24.81, ["Fly|Ride"] = 40.69, ["Neon"] = 80.07, ["Neon|Fly"] = 230.99, ["Neon|Ride"] = 97.5, ["Neon|Fly|Ride"] = 105, ["Mega"] = 405.87, ["Mega|Ride"] = 421.32, ["Mega|Fly|Ride"] = 405.57}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 305.82, ["Fly"] = 458.67, ["Ride"] = 324.19, ["Fly|Ride"] = 407.73, ["Neon"] = 958.73, ["Neon|Ride"] = 786.19, ["Neon|Fly|Ride"] = 983.32, ["Mega"] = 4213.1, ["Mega|Fly|Ride"] = 3381.13}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 14.43}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 122.07, ["Fly"] = 590.63, ["Ride"] = 162.75, ["Fly|Ride"] = 250.69, ["Neon"] = 507.82, ["Neon|Fly"] = 1405.42, ["Neon|Ride"] = 562.46, ["Neon|Fly|Ride"] = 510.57, ["Mega"] = 9268.81, ["Mega|Ride"] = 1983.03, ["Mega|Fly|Ride"] = 1739.07}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 105, ["Ride"] = 165.38, ["Fly|Ride"] = 250.57, ["Neon"] = 842.83, ["Neon|Ride"] = 997.5, ["Neon|Fly|Ride"] = 1011.15}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 6.3, ["Ride"] = 35.84, ["Fly|Ride"] = 141.19, ["Neon"] = 40, ["Neon|Ride"] = 86.34, ["Neon|Fly|Ride"] = 168.54, ["Mega"] = 222.7, ["Mega|Ride"] = 280.77, ["Mega|Fly|Ride"] = 410.62}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 15.65, ["Fly"] = 49.88, ["Ride"] = 33.72, ["Fly|Ride"] = 46.65, ["Neon"] = 132.97, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 239.11, ["Mega|Ride"] = 694.12, ["Mega|Fly|Ride"] = 572.25}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 26.17, ["Fly"] = 126.44, ["Ride"] = 31.49, ["Fly|Ride"] = 127.32, ["Neon"] = 156.19, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 211.32, ["Mega|Ride"] = 389.62, ["Mega|Fly|Ride"] = 568.78}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 5.8, ["Fly"] = 337.14, ["Ride"] = 32.82, ["Fly|Ride"] = 139.91, ["Neon"] = 26.14, ["Neon|Ride"] = 72.34, ["Neon|Fly|Ride"] = 120.08, ["Mega"] = 108.67, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 281.24, ["Fly"] = 364.54, ["Ride"] = 269.74, ["Fly|Ride"] = 421.42, ["Neon|Ride"] = 1214.07, ["Neon|Fly|Ride"] = 1236.55, ["Mega|Fly|Ride"] = 4314.21}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 90.57, ["Fly"] = 1050, ["Ride"] = 107.63, ["Fly|Ride"] = 137.82, ["Neon"] = 433.13, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 561.36, ["Mega"] = 1792.88, ["Mega|Ride"] = 1928.07, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 66.94, ["Fly"] = 167.45, ["Ride"] = 84, ["Fly|Ride"] = 131.24, ["Neon|Ride"] = 374.07, ["Neon|Fly|Ride"] = 418.69, ["Mega|Ride"] = 1664.58, ["Mega|Fly|Ride"] = 1515.94}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 12.66, ["Ride"] = 56.9, ["Fly|Ride"] = 281.31, ["Neon|Ride"] = 592.59, ["Neon|Fly|Ride"] = 490.84, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 17.07, ["Fly"] = 75.62, ["Ride"] = 42, ["Fly|Ride"] = 91.88, ["Neon"] = 72.32, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 181.13, ["Mega"] = 466.61, ["Mega|Fly"] = 525, ["Mega|Ride"] = 665.68, ["Mega|Fly|Ride"] = 444.94}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.7, ["Fly"] = 23.09, ["Ride"] = 21.87, ["Fly|Ride"] = 78.12, ["Neon"] = 15.85, ["Neon|Ride"] = 38.06, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 91.32, ["Mega|Ride"] = 167.48, ["Mega|Fly|Ride"] = 144}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 892.5, ["Fly"] = 1123.71, ["Ride"] = 912.19, ["Fly|Ride"] = 945, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2417.63, ["Mega|Fly|Ride"] = 8006.25}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 345.49, ["Ride"] = 379.29, ["Fly|Ride"] = 387.19, ["Neon|Ride"] = 1365, ["Neon|Fly|Ride"] = 1442.44, ["Mega"] = 10532.72, ["Mega|Fly|Ride"] = 4493.27}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 109.76, ["Ride"] = 109.83, ["Fly|Ride"] = 194.25, ["Neon"] = 385.6, ["Neon|Ride"] = 400.26, ["Neon|Fly|Ride"] = 372.75, ["Mega|Ride"] = 1826.39, ["Mega|Fly|Ride"] = 1378.13}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 209.69, ["Ride"] = 189, ["Fly|Ride"] = 236.25, ["Neon|Ride"] = 1058.02, ["Neon|Fly|Ride"] = 905.63, ["Mega"] = 10532.72, ["Mega|Fly|Ride"] = 4170.97}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 17.07, ["Fly"] = 52.5, ["Ride"] = 34.99, ["Fly|Ride"] = 84.29, ["Neon"] = 156.28, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 229.63, ["Mega|Ride"] = 778.07, ["Mega|Fly|Ride"] = 619.12}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 365.5, ["Ride"] = 562.59, ["Neon"] = 1584.98, ["Neon|Ride"] = 1895.91, ["Neon|Fly|Ride"] = 1378.13, ["Mega"] = 5250, ["Mega|Fly|Ride"] = 5546.54}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 105.34, ["Fly"] = 126, ["Ride"] = 91.67, ["Fly|Ride"] = 99.05, ["Neon"] = 421.42, ["Neon|Ride"] = 466.61, ["Neon|Fly|Ride"] = 631.98, ["Mega|Fly|Ride"] = 2022.7}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1307.25, ["Ride"] = 1292.7, ["Fly|Ride"] = 1312.5, ["Neon|Ride"] = 4423.76, ["Neon|Fly|Ride"] = 4331.25, ["Mega"] = 50557.02, ["Mega|Fly|Ride"] = 24577.04}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 14.44, ["Fly"] = 45.94, ["Ride"] = 43.74, ["Fly|Ride"] = 84, ["Neon"] = 44.37, ["Neon|Fly"] = 153.83, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 156.32, ["Mega"] = 176.02, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 83.21, ["Ride"] = 83.92, ["Fly|Ride"] = 202.85, ["Neon"] = 264.45, ["Neon|Ride"] = 316.32, ["Neon|Fly|Ride"] = 269.07, ["Mega|Ride"] = 1123.85, ["Mega|Fly|Ride"] = 975.34}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 78.64, ["Fly"] = 69.96, ["Ride"] = 78.75, ["Fly|Ride"] = 83.4, ["Neon|Ride"] = 393.94, ["Neon|Fly|Ride"] = 349.74, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 2795.4, ["Ride"] = 962.07, ["Fly|Ride"] = 825.57, ["Neon|Fly|Ride"] = 4549.3, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 421.32, ["Ride"] = 589.99, ["Fly|Ride"] = 556.28, ["Neon|Ride"] = 1826.39, ["Neon|Fly|Ride"] = 1978.07, ["Mega|Fly|Ride"] = 13997.83}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 105, ["Ride"] = 105, ["Fly|Ride"] = 234.94, ["Neon"] = 494.42, ["Neon|Fly"] = 437.24, ["Neon|Ride"] = 456.75, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 3987.36, ["Mega|Ride"] = 1706.25, ["Mega|Fly|Ride"] = 2018.08}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 10.4, ["Fly"] = 39.38, ["Ride"] = 28.46, ["Fly|Ride"] = 71.65, ["Neon"] = 73.95, ["Neon|Ride"] = 103.24, ["Neon|Fly|Ride"] = 168.49, ["Mega"] = 761.25, ["Mega|Ride"] = 508.59, ["Mega|Fly|Ride"] = 983.77}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 39.86, ["Fly"] = 70.6, ["Ride"] = 48.57, ["Fly|Ride"] = 65.63, ["Neon"] = 249.55, ["Neon|Fly"] = 407.73, ["Neon|Ride"] = 210.76, ["Neon|Fly|Ride"] = 280.19, ["Mega"] = 1826.39, ["Mega|Fly|Ride"] = 1049.99}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 798.39, ["Ride"] = 699.48, ["Fly|Ride"] = 837.74, ["Neon"] = 3301.77, ["Neon|Ride"] = 2828.44, ["Neon|Fly|Ride"] = 3325.67, ["Mega|Fly|Ride"] = 12111.58}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 767.82}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 4823.44, ["Ride"] = 4608.19, ["Fly|Ride"] = 4331.25, ["Neon|Ride"] = 30187.81, ["Neon|Fly|Ride"] = 20603.63, ["Mega|Fly|Ride"] = 89879.83}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 156.28, ["Fly"] = 168.57, ["Ride"] = 156.22, ["Fly|Ride"] = 407.73, ["Neon"] = 918.75, ["Neon|Ride"] = 899.38, ["Neon|Fly|Ride"] = 918.75, ["Mega"] = 5898.34, ["Mega|Fly|Ride"] = 5477.03}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 61.52, ["Fly"] = 281.31, ["Ride"] = 105.36, ["Fly|Ride"] = 336, ["Neon"] = 441, ["Neon|Ride"] = 468.72, ["Neon|Fly|Ride"] = 472.5, ["Mega|Fly|Ride"] = 2669.01}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 15.74, ["Fly"] = 125.93, ["Ride"] = 31.49, ["Fly|Ride"] = 91.88, ["Neon"] = 141.19, ["Neon|Ride"] = 103.24, ["Neon|Fly|Ride"] = 175.88, ["Mega"] = 419.22, ["Mega|Ride"] = 525.6, ["Mega|Fly|Ride"] = 478.21}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 18.34, ["Fly"] = 30.27, ["Ride"] = 22.32, ["Fly|Ride"] = 45.94, ["Neon"] = 139.95, ["Neon|Fly"] = 281.31, ["Neon|Ride"] = 311.48, ["Neon|Fly|Ride"] = 177.18, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 785.75}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 15.65, ["Fly"] = 70.9, ["Ride"] = 31.49, ["Fly|Ride"] = 91.14, ["Neon"] = 124.76, ["Neon|Ride"] = 97.13, ["Neon|Fly|Ride"] = 231, ["Mega|Ride"] = 859.69, ["Mega|Fly|Ride"] = 837.51}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 2.1, ["Fly"] = 77.98, ["Ride"] = 20.97, ["Fly|Ride"] = 55.74, ["Neon"] = 35.44, ["Neon|Fly"] = 347.68, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 109.67, ["Mega|Ride"] = 311.48, ["Mega|Fly|Ride"] = 357}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 26.25, ["Ride"] = 92.11, ["Fly|Ride"] = 167.52, ["Neon"] = 197.03, ["Neon|Fly"] = 842.83, ["Neon|Ride"] = 246.48, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 690.97, ["Mega|Ride"] = 716.24, ["Mega|Fly|Ride"] = 813.14}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 263.08, ["Fly"] = 329.49, ["Ride"] = 245.44, ["Fly|Ride"] = 288.75, ["Neon"] = 577.5, ["Neon|Ride"] = 977.82, ["Neon|Fly|Ride"] = 643.13, ["Mega"] = 6562.5, ["Mega|Ride"] = 4213.1, ["Mega|Fly|Ride"] = 4134.38}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 3.68, ["Fly"] = 16.87, ["Ride"] = 16.83, ["Fly|Ride"] = 31.8, ["Neon"] = 18.67, ["Neon|Ride"] = 31.44, ["Neon|Fly|Ride"] = 87.43, ["Mega"] = 838.43, ["Mega|Ride"] = 232.79, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 32.81, ["Fly"] = 55.13, ["Ride"] = 69.57, ["Fly|Ride"] = 118.13, ["Neon"] = 170.63, ["Neon|Fly"] = 281.31, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 431.81, ["Mega|Ride"] = 524.99, ["Mega|Fly|Ride"] = 556.5}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 932.89, ["Fly"] = 984.01, ["Ride"] = 729.42, ["Fly|Ride"] = 761.25, ["Neon|Ride"] = 1575, ["Neon|Fly|Ride"] = 1391.25, ["Mega|Fly|Ride"] = 3963.75}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 28.7, ["Fly"] = 155.53, ["Ride"] = 38.59, ["Fly|Ride"] = 64.32, ["Neon"] = 131.25, ["Neon|Fly"] = 466.44, ["Neon|Ride"] = 127.32, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 1575, ["Mega|Ride"] = 1123.85, ["Mega|Fly|Ride"] = 841.58}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 316, ["Fly"] = 316.41, ["Ride"] = 237.57, ["Fly|Ride"] = 295.32, ["Neon"] = 1405.42, ["Neon|Fly"] = 1485.49, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 4480.63}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 99.75, ["Fly"] = 157.5, ["Ride"] = 124.69, ["Fly|Ride"] = 165.72, ["Neon"] = 560.49, ["Neon|Fly"] = 492.01, ["Neon|Ride"] = 525.6, ["Neon|Fly|Ride"] = 512.95, ["Mega"] = 2949.17, ["Mega|Fly|Ride"] = 2205.57}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 492.69, ["Ride"] = 570.93, ["Fly|Ride"] = 682.5, ["Neon"] = 2513.74, ["Neon|Fly|Ride"] = 5336.94, ["Mega"] = 7899.54, ["Mega|Fly|Ride"] = 6561.19}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 24.71, ["Ride"] = 52.5, ["Fly|Ride"] = 99.05, ["Neon"] = 78.21, ["Neon|Fly"] = 279.87, ["Neon|Ride"] = 112.72, ["Neon|Fly|Ride"] = 163.28, ["Mega"] = 291.37, ["Mega|Ride"] = 407.64, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 3003, ["Fly"] = 3956.54, ["Ride"] = 3936.19, ["Fly|Ride"] = 3083.73, ["Neon|Fly|Ride"] = 6300, ["Mega|Fly|Ride"] = 23745.75}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 91.88, ["Fly"] = 105.36, ["Ride"] = 95.01, ["Fly|Ride"] = 135.63, ["Neon"] = 395.31, ["Neon|Ride"] = 420.27, ["Neon|Fly|Ride"] = 401.63, ["Mega|Fly|Ride"] = 1685.24}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 33.76, ["Ride"] = 19.69, ["Fly|Ride"] = 46.65, ["Neon"] = 19.69, ["Neon|Fly"] = 42.24, ["Neon|Ride"] = 36.22, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 105, ["Mega|Fly"] = 452.82, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.94, ["Ride"] = 28.88, ["Fly|Ride"] = 156.22, ["Neon"] = 21.08, ["Neon|Ride"] = 62.99, ["Neon|Fly|Ride"] = 266.44, ["Mega"] = 144.38, ["Mega|Ride"] = 179.44, ["Mega|Fly|Ride"] = 278.2}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 63.21, ["Fly"] = 65.63, ["Ride"] = 40.69, ["Fly|Ride"] = 57.75, ["Neon|Fly|Ride"] = 379.19, ["Mega|Fly|Ride"] = 1285.01}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 931.88, ["Ride"] = 918.75, ["Fly|Ride"] = 1232.44, ["Neon|Fly|Ride"] = 5618.16, ["Mega|Fly|Ride"] = 18958.9}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 4897.6, ["Ride"] = 6181.06, ["Fly|Ride"] = 5092.76}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 18.52, ["Fly"] = 26.25, ["Ride"] = 26.25, ["Fly|Ride"] = 48.57, ["Neon"] = 105, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 126.41, ["Mega"] = 2362.5, ["Mega|Fly|Ride"] = 577.37}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 16.59, ["Fly"] = 69.96, ["Ride"] = 36.89, ["Fly|Ride"] = 65.99, ["Neon"] = 91.88, ["Neon|Ride"] = 109.6, ["Neon|Fly|Ride"] = 167.49, ["Mega"] = 914.74, ["Mega|Ride"] = 536.6, ["Mega|Fly|Ride"] = 461.42}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 38.06, ["Fly"] = 157.49, ["Ride"] = 43.32, ["Fly|Ride"] = 64.32, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 242.82, ["Mega|Ride"] = 1154.41, ["Mega|Fly|Ride"] = 868.88}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 217.88, ["Ride"] = 232.68, ["Fly|Ride"] = 234.95, ["Neon|Ride"] = 976.5, ["Neon|Fly|Ride"] = 1122.8, ["Mega"] = 11043.13, ["Mega|Fly|Ride"] = 4011.78}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 5.25, ["Ride"] = 44.26, ["Fly|Ride"] = 105, ["Neon"] = 21, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 92.42, ["Neon|Fly|Ride"] = 210.67, ["Mega"] = 102.38, ["Mega|Ride"] = 198.19, ["Mega|Fly|Ride"] = 351.81}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 177.19, ["Fly"] = 265.8, ["Ride"] = 168.24, ["Fly|Ride"] = 262.5, ["Neon"] = 794.37, ["Neon|Ride"] = 744.19, ["Neon|Fly|Ride"] = 815.26, ["Mega|Fly|Ride"] = 3296.75}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 3.46, ["Fly"] = 24.12, ["Ride"] = 16.86, ["Fly|Ride"] = 41.94, ["Neon"] = 26.92, ["Neon|Fly"] = 121.79, ["Neon|Ride"] = 40.04, ["Neon|Fly|Ride"] = 104.99, ["Mega"] = 349.96, ["Mega|Ride"] = 421.32, ["Mega|Fly|Ride"] = 735.19}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 221.82, ["Fly"] = 249.37, ["Ride"] = 232.84, ["Fly|Ride"] = 275.63, ["Neon|Ride"] = 942.69, ["Neon|Fly|Ride"] = 933.21, ["Mega"] = 10532.72, ["Mega|Ride"] = 5618.16, ["Mega|Fly|Ride"] = 3933.99}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 8.28, ["Fly"] = 421.42, ["Ride"] = 26.17, ["Fly|Ride"] = 84.48, ["Neon"] = 70.6, ["Neon|Fly"] = 296.2, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 393.94, ["Mega"] = 462.76, ["Mega|Ride"] = 562.46, ["Mega|Fly|Ride"] = 369.71}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 7.86, ["Ride"] = 19.69, ["Neon"] = 14.44, ["Neon|Fly"] = 66.94, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 140.9, ["Mega"] = 76.11, ["Mega|Fly"] = 421.32, ["Mega|Ride"] = 85.22, ["Mega|Fly|Ride"] = 202.95}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.92, ["Mega"] = 18.36, ["Mega|Ride"] = 155.7}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 3.93, ["Ride"] = 35.84, ["Fly|Ride"] = 141.94, ["Neon"] = 10.48, ["Neon|Ride"] = 28.54, ["Neon|Fly|Ride"] = 214.89, ["Mega"] = 44.63, ["Mega|Fly"] = 155532.11, ["Mega|Ride"] = 78.73, ["Mega|Fly|Ride"] = 239.11}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 59.16, ["Fly"] = 78.75, ["Ride"] = 106.1, ["Fly|Ride"] = 191.21, ["Neon"] = 210, ["Neon|Ride"] = 328.63, ["Neon|Fly|Ride"] = 347.82, ["Mega|Ride"] = 1311.19, ["Mega|Fly|Ride"] = 1236.55}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 28.32, ["Ride"] = 18.25, ["Fly|Ride"] = 39.09, ["Neon"] = 3.89, ["Neon|Ride"] = 21.18, ["Neon|Fly|Ride"] = 116.67, ["Mega"] = 86.63, ["Mega|Ride"] = 98.34, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 186.59, ["Ride"] = 65.63, ["Neon"] = 168.57, ["Neon|Ride"] = 127.24, ["Mega"] = 393.75, ["Mega|Ride"] = 712.02, ["Mega|Fly|Ride"] = 580.37}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 77.6, ["Neon|Fly|Ride"] = 156.32, ["Mega"] = 15.75, ["Mega|Ride"] = 45.94, ["Mega|Fly|Ride"] = 238.24}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 20.96, ["Ride"] = 18, ["Fly|Ride"] = 35.84, ["Neon"] = 2.1, ["Neon|Fly"] = 16.87, ["Neon|Ride"] = 15.7, ["Neon|Fly|Ride"] = 42.15, ["Mega"] = 11.42, ["Mega|Fly"] = 27.57, ["Mega|Ride"] = 23.19, ["Mega|Fly|Ride"] = 39.38}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Ride"] = 14.44, ["Fly|Ride"] = 34.13, ["Neon"] = 3.93, ["Neon|Fly"] = 17.51, ["Neon|Ride"] = 16.75, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 18.67, ["Mega|Ride"] = 49.51, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Ride"] = 27.19, ["Fly|Ride"] = 125.73, ["Neon"] = 2.1, ["Neon|Ride"] = 70.59, ["Mega"] = 21, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 41.88, ["Ride"] = 17.07, ["Fly|Ride"] = 107.52, ["Neon"] = 3.81, ["Neon|Fly"] = 135.03, ["Neon|Ride"] = 70.59, ["Neon|Fly|Ride"] = 81.67, ["Mega"] = 28.3, ["Mega|Fly"] = 52.5, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 3.23, ["Neon|Fly|Ride"] = 99.02, ["Mega"] = 19.67, ["Mega|Ride"] = 93.19}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 2.1, ["Fly"] = 47.16, ["Ride"] = 20.96, ["Fly|Ride"] = 61.13, ["Neon"] = 5.81, ["Neon|Fly"] = 49.53, ["Neon|Ride"] = 27.4, ["Neon|Fly|Ride"] = 62.98, ["Mega"] = 48.7, ["Mega|Fly"] = 139.06, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 124.43}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 20.99, ["Neon"] = 2.1, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 310.59, ["Mega"] = 17.52, ["Mega|Ride"] = 53.82, ["Mega|Fly|Ride"] = 190.32}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Fly|Ride"] = 525, ["Neon"] = 28.46, ["Neon|Ride"] = 70.59, ["Mega"] = 141.16, ["Mega|Fly"] = 314.99, ["Mega|Ride"] = 281.24}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 23.34, ["Ride"] = 42.15, ["Neon"] = 16.88, ["Mega"] = 139.13}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 70.6, ["Neon"] = 6.23, ["Neon|Ride"] = 36.95, ["Neon|Fly|Ride"] = 75.86, ["Mega"] = 24.94, ["Mega|Ride"] = 173.6, ["Mega|Fly|Ride"] = 239.11}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 30.24, ["Ride"] = 17.73, ["Fly|Ride"] = 30.19, ["Neon"] = 2.1, ["Neon|Fly"] = 26.99, ["Neon|Ride"] = 15.78, ["Neon|Fly|Ride"] = 41.88, ["Mega"] = 13.12, ["Mega|Fly"] = 53.45, ["Mega|Ride"] = 17.07, ["Mega|Fly|Ride"] = 45.18}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.63, ["Fly"] = 72.19, ["Ride"] = 26.25, ["Neon"] = 31.5, ["Neon|Ride"] = 39.38, ["Mega"] = 252.8, ["Mega|Fly|Ride"] = 686.75}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.63, ["Ride"] = 37.91, ["Fly|Ride"] = 78.73, ["Neon"] = 10.5, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 41.97, ["Mega|Ride"] = 156.32, ["Mega|Fly|Ride"] = 153.78}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 6.33, ["Neon"] = 11.4, ["Neon|Fly|Ride"] = 141.16, ["Mega"] = 82.69, ["Mega|Ride"] = 233.63}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 3.93, ["Fly"] = 31.7, ["Ride"] = 32.71, ["Fly|Ride"] = 191.76, ["Neon"] = 52.5, ["Neon|Fly"] = 46.66, ["Neon|Ride"] = 31.61, ["Neon|Fly|Ride"] = 126.41, ["Mega"] = 209.77, ["Mega|Ride"] = 85.3, ["Mega|Fly|Ride"] = 281.24}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 15.82, ["Ride"] = 16.83, ["Fly|Ride"] = 26.25, ["Neon"] = 2.1, ["Neon|Fly"] = 14.44, ["Neon|Ride"] = 12.66, ["Neon|Fly|Ride"] = 35.25, ["Mega"] = 15.63, ["Mega|Fly"] = 40.04, ["Mega|Ride"] = 22.23, ["Mega|Fly|Ride"] = 44.83}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 3.52, ["Fly"] = 26.17, ["Ride"] = 19.65, ["Fly|Ride"] = 79.32, ["Neon"] = 52.5, ["Neon|Ride"] = 112, ["Mega"] = 128.63, ["Mega|Ride"] = 183.28, ["Mega|Fly|Ride"] = 265.44}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 3.83, ["Fly"] = 42.15, ["Fly|Ride"] = 141.19, ["Neon"] = 68.38, ["Neon|Ride"] = 124.29, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 200.71, ["Mega|Ride"] = 276.94, ["Mega|Fly|Ride"] = 437.73}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 22.16, ["Ride"] = 13.81, ["Fly|Ride"] = 35.84, ["Neon"] = 2.1, ["Neon|Fly"] = 22.44, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 42, ["Mega"] = 17.52, ["Mega|Fly"] = 156.19, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 95.71}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.63, ["Fly"] = 175.95, ["Neon"] = 8.95, ["Neon|Fly"] = 77.53, ["Neon|Ride"] = 36.74, ["Neon|Fly|Ride"] = 168.54, ["Mega"] = 39.38, ["Mega|Fly"] = 562.46, ["Mega|Ride"] = 103.69}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 28.46, ["Neon"] = 8.35, ["Neon|Fly"] = 118.13, ["Neon|Fly|Ride"] = 311.49, ["Mega"] = 45.94, ["Mega|Ride"] = 63, ["Mega|Fly|Ride"] = 281.24}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 44.26, ["Neon"] = 2.1, ["Neon|Fly"] = 40.69, ["Neon|Ride"] = 28.46, ["Neon|Fly|Ride"] = 3150, ["Mega"] = 13.9, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 116.93}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 88.51, ["Ride"] = 16.95, ["Fly|Ride"] = 59.07, ["Neon"] = 9.3, ["Neon|Fly"] = 46.36, ["Neon|Ride"] = 15.82, ["Neon|Fly|Ride"] = 100.7, ["Mega"] = 117.93, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 268.59}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.61, ["Ride"] = 31.48, ["Neon"] = 6.57, ["Neon|Ride"] = 45.94, ["Mega"] = 57.64, ["Mega|Ride"] = 167.93}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 32.33, ["Ride"] = 15.61, ["Fly|Ride"] = 109.66, ["Neon"] = 3.71, ["Neon|Fly"] = 70.6, ["Neon|Ride"] = 19.38, ["Neon|Fly|Ride"] = 77.6, ["Mega"] = 79.02, ["Mega|Fly"] = 126.41, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 2.1, ["Ride"] = 82.6, ["Mega|Fly|Ride"] = 842.63}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Ride"] = 21, ["Fly|Ride"] = 5362.53, ["Neon"] = 6.36, ["Neon|Fly"] = 58.78, ["Neon|Ride"] = 28.01, ["Neon|Fly|Ride"] = 112.77, ["Mega"] = 150.94, ["Mega|Ride"] = 239.11, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.1, ["Fly"] = 21.08, ["Ride"] = 20.76, ["Fly|Ride"] = 35.84, ["Neon"] = 18.38, ["Neon|Fly"] = 99.05, ["Neon|Ride"] = 31.52, ["Neon|Fly|Ride"] = 78.07, ["Mega|Ride"] = 136.5, ["Mega|Fly|Ride"] = 191.08}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 3.29, ["Fly"] = 79.47, ["Fly|Ride"] = 104.93, ["Neon"] = 15.44, ["Neon|Ride"] = 62.91, ["Mega"] = 315}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 11.07, ["Ride"] = 131.25, ["Neon"] = 99.05, ["Mega"] = 556.5, ["Mega|Fly|Ride"] = 794.07}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 3.94, ["Ride"] = 37.94, ["Fly|Ride"] = 70.6, ["Neon"] = 30.86, ["Neon|Ride"] = 105, ["Mega"] = 259.09, ["Mega|Ride"] = 367.5}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 8.54, ["Ride"] = 32.42, ["Neon"] = 42, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 141.16, ["Mega"] = 187.5, ["Mega|Ride"] = 249.36, ["Mega|Fly|Ride"] = 357.67}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.05, ["Neon"] = 3.82, ["Neon|Ride"] = 126.41, ["Mega"] = 19.67, ["Mega|Ride"] = 139.12, ["Mega|Fly|Ride"] = 148.29}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 53.82}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 8.9, ["Fly"] = 25.72, ["Ride"] = 24.92, ["Fly|Ride"] = 66.94, ["Neon"] = 49.23, ["Neon|Ride"] = 37.65, ["Neon|Fly|Ride"] = 103.35, ["Mega"] = 267.75, ["Mega|Ride"] = 311.48, ["Mega|Fly|Ride"] = 285.45}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 18.15, ["Fly|Ride"] = 70.56, ["Neon"] = 3.66, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 421.32, ["Mega"] = 26.25, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.6, ["Ride"] = 45.15, ["Fly|Ride"] = 389.38, ["Neon"] = 4.23, ["Neon|Ride"] = 30.18, ["Neon|Fly|Ride"] = 141.16, ["Mega"] = 36.74, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 19.69, ["Fly|Ride"] = 77.98, ["Neon"] = 15.33, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 87.28, ["Mega"] = 133.76, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 311.48}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 8.97, ["Fly"] = 65.63, ["Ride"] = 582.75, ["Neon"] = 75.87, ["Neon|Ride"] = 124.83, ["Neon|Fly|Ride"] = 157.4, ["Mega"] = 328.13, ["Mega|Fly|Ride"] = 411.84}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Neon"] = 3.56, ["Neon|Ride"] = 51.34, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 17.07, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 49.26, ["Mega|Fly|Ride"] = 141.1}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 18.98, ["Fly|Ride"] = 56.9, ["Neon"] = 3.77, ["Neon|Fly"] = 35.44, ["Neon|Ride"] = 28.25, ["Neon|Fly|Ride"] = 73.5, ["Mega"] = 46.36, ["Mega|Fly"] = 156.32, ["Mega|Ride"] = 57.16, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 21.05, ["Ride"] = 15.82, ["Fly|Ride"] = 48.38, ["Neon"] = 8.28, ["Neon|Fly"] = 70.6, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 56.65, ["Mega"] = 189.6, ["Mega|Fly"] = 107.63, ["Mega|Ride"] = 112.72, ["Mega|Fly|Ride"] = 139.99}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 210, ["Ride"] = 20.9, ["Fly|Ride"] = 45.94, ["Neon"] = 5.25, ["Neon|Ride"] = 35.82, ["Neon|Fly|Ride"] = 82.03, ["Mega"] = 24.94, ["Mega|Fly"] = 210.67, ["Mega|Ride"] = 39.67, ["Mega|Fly|Ride"] = 102.38}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.63, ["Neon"] = 3.84, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 150242.1, ["Mega"] = 17.07, ["Mega|Fly"] = 104.81, ["Mega|Ride"] = 67.04, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 26.36, ["Ride"] = 17.49, ["Fly|Ride"] = 77.44, ["Neon"] = 4.73, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 28.4, ["Neon|Fly|Ride"] = 68.16, ["Mega"] = 16.96, ["Mega|Ride"] = 40.85, ["Mega|Fly|Ride"] = 133.25}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 45.94, ["Mega"] = 21.87}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.91, ["Neon|Ride"] = 156.32, ["Neon|Fly|Ride"] = 281.24, ["Mega"] = 26.24, ["Mega|Fly"] = 116.67}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 24.25, ["Ride"] = 19.69, ["Neon"] = 6.19, ["Neon|Fly"] = 71.8, ["Neon|Ride"] = 21.08, ["Neon|Fly|Ride"] = 42, ["Mega"] = 61.69, ["Mega|Ride"] = 60.22, ["Mega|Fly|Ride"] = 116.67}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 17.51, ["Ride"] = 59.07, ["Neon"] = 94.5, ["Neon|Ride"] = 259.88, ["Mega"] = 398.35, ["Mega|Ride"] = 3111.04, ["Mega|Fly|Ride"] = 642.51}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 6.57, ["Fly"] = 6431.24, ["Ride"] = 68.16, ["Neon"] = 77.98, ["Neon|Fly|Ride"] = 105, ["Mega"] = 132.72, ["Mega|Ride"] = 313.04}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 2.63, ["Ride"] = 30.66, ["Fly|Ride"] = 45.02, ["Neon"] = 28.35, ["Neon|Ride"] = 99.02, ["Neon|Fly|Ride"] = 91.77, ["Mega"] = 124.29, ["Mega|Ride"] = 223.31, ["Mega|Fly|Ride"] = 338.63}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 15.74, ["Ride"] = 15.23, ["Fly|Ride"] = 19.9, ["Neon"] = 2.1, ["Neon|Fly"] = 19.59, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 31.23, ["Mega"] = 18.36, ["Mega|Fly"] = 24.94, ["Mega|Ride"] = 22.32, ["Mega|Fly|Ride"] = 55.28}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 6.55, ["Ride"] = 55.13, ["Neon"] = 32.24, ["Neon|Fly"] = 87.47, ["Neon|Ride"] = 32.75, ["Neon|Fly|Ride"] = 105, ["Mega"] = 63.21, ["Mega|Ride"] = 141.16, ["Mega|Fly|Ride"] = 179.07}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Ride"] = 59, ["Neon"] = 2.1, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 79.04, ["Mega"] = 15.54, ["Mega|Fly"] = 78.44, ["Mega|Ride"] = 101.07, ["Mega|Fly|Ride"] = 103.56}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Fly"] = 60.9, ["Mega"] = 13.13, ["Mega|Ride"] = 94.5, ["Mega|Fly|Ride"] = 209.24}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.63, ["Fly"] = 34.99, ["Ride"] = 18.85, ["Fly|Ride"] = 63.08, ["Neon"] = 12.66, ["Neon|Fly"] = 40.85, ["Neon|Ride"] = 39.67, ["Neon|Fly|Ride"] = 104.93, ["Mega"] = 143.21, ["Mega|Ride"] = 193.87, ["Mega|Fly|Ride"] = 176.79}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 189, ["Ride"] = 252, ["Fly|Ride"] = 329.44, ["Neon"] = 1541.07, ["Neon|Ride"] = 1050, ["Neon|Fly|Ride"] = 918.75, ["Mega"] = 8426.18, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Neon"] = 8.44, ["Neon|Fly"] = 57.23, ["Neon|Ride"] = 68.25, ["Mega"] = 65.34, ["Mega|Ride"] = 176.97, ["Mega|Fly|Ride"] = 421.32}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 2.63, ["Fly"] = 103.68, ["Ride"] = 24.12, ["Fly|Ride"] = 140.2, ["Neon"] = 30.57, ["Neon|Ride"] = 168.54, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 603.75, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 622.93}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 842.83, ["Ride"] = 17.51, ["Fly|Ride"] = 49.53, ["Neon"] = 8.23, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 25.68, ["Neon|Fly|Ride"] = 45.93, ["Mega"] = 49.88, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 124.29}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Ride"] = 24.94, ["Fly|Ride"] = 120.89, ["Neon"] = 6.33, ["Neon|Fly"] = 42.15, ["Neon|Ride"] = 53.52, ["Mega"] = 111.67, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 209.62}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 3.94, ["Fly"] = 23.19, ["Ride"] = 20.98, ["Fly|Ride"] = 46.36, ["Neon"] = 28.59, ["Neon|Ride"] = 45.93, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 205.41, ["Mega|Ride"] = 175.91, ["Mega|Fly|Ride"] = 142.21}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 6.57, ["Fly|Ride"] = 246.75, ["Neon"] = 65.63, ["Neon|Ride"] = 90.57, ["Neon|Fly|Ride"] = 625.67, ["Mega"] = 183.75, ["Mega|Ride"] = 268.59, ["Mega|Fly|Ride"] = 377.79}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.41, ["Fly"] = 20.03, ["Ride"] = 18.66, ["Fly|Ride"] = 32.82, ["Neon"] = 20.67, ["Neon|Fly"] = 70.32, ["Neon|Ride"] = 32.67, ["Neon|Fly|Ride"] = 68.25, ["Mega"] = 196.88, ["Mega|Ride"] = 281.51, ["Mega|Fly|Ride"] = 166.43}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 69.99, ["Fly"] = 103.26, ["Ride"] = 89.72, ["Fly|Ride"] = 131.25, ["Neon"] = 446.25, ["Neon|Fly"] = 345.85, ["Neon|Ride"] = 299.25, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 1378.13}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 227.07, ["Fly"] = 322.17, ["Ride"] = 236.25, ["Fly|Ride"] = 238.19, ["Neon|Ride"] = 1123.85, ["Neon|Fly|Ride"] = 1556.1, ["Mega"] = 10532.72, ["Mega|Fly|Ride"] = 8421.97}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 56.49, ["Fly"] = 116.53, ["Ride"] = 85.3, ["Fly|Ride"] = 110.25, ["Neon"] = 379.29, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 329.44, ["Mega|Fly|Ride"] = 1089.38}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 4.76, ["Ride"] = 23.33, ["Fly|Ride"] = 141.19, ["Neon"] = 34.99, ["Neon|Ride"] = 78.17, ["Neon|Fly|Ride"] = 143.26, ["Mega"] = 264.8, ["Mega|Ride"] = 169.32, ["Mega|Fly|Ride"] = 322.88}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 25.66, ["Fly"] = 68.14, ["Ride"] = 33.72, ["Fly|Ride"] = 78.75, ["Neon"] = 85.32, ["Neon|Ride"] = 140.86, ["Neon|Fly|Ride"] = 189.6, ["Mega"] = 484.11, ["Mega|Ride"] = 451.5, ["Mega|Fly|Ride"] = 669.58}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 25.36, ["Fly|Ride"] = 46.65, ["Neon"] = 6.23, ["Neon|Fly"] = 115.49, ["Neon|Ride"] = 21.08, ["Neon|Fly|Ride"] = 87.43, ["Mega"] = 62.98, ["Mega|Fly"] = 85.32, ["Mega|Ride"] = 99.02, ["Mega|Fly|Ride"] = 209.85}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 7.12, ["Fly"] = 72.1, ["Ride"] = 27.57, ["Fly|Ride"] = 105, ["Neon"] = 41.13, ["Neon|Ride"] = 69.28, ["Neon|Fly|Ride"] = 407.4, ["Mega"] = 701.5, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 419.78}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 28.77, ["Ride"] = 17.51, ["Fly|Ride"] = 45.1, ["Neon"] = 19.03, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 27.78, ["Neon|Fly|Ride"] = 97.13, ["Mega"] = 131.25, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 175.88}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 2.39, ["Ride"] = 27.36, ["Fly|Ride"] = 328.13, ["Neon"] = 30.33, ["Neon|Ride"] = 56.79, ["Neon|Fly|Ride"] = 156.32, ["Mega"] = 186.65, ["Mega|Ride"] = 209.2, ["Mega|Fly|Ride"] = 302.14}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 28.35, ["Neon"] = 2.1, ["Neon|Ride"] = 23.15, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 15.74, ["Mega|Ride"] = 51.63, ["Mega|Fly|Ride"] = 196.97}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 45.93, ["Ride"] = 18.98, ["Fly|Ride"] = 54.66, ["Neon"] = 13.09, ["Neon|Fly"] = 70.6, ["Neon|Ride"] = 56.89, ["Neon|Fly|Ride"] = 69.57, ["Mega"] = 108.81, ["Mega|Ride"] = 114.34, ["Mega|Fly|Ride"] = 191.31}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 3.94, ["Ride"] = 18.02, ["Fly|Ride"] = 56.9, ["Neon"] = 62.97, ["Neon|Fly"] = 141.19, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 562.46, ["Mega"] = 267.54, ["Mega|Ride"] = 206.07, ["Mega|Fly|Ride"] = 271.69}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 116.82, ["Fly"] = 210.72, ["Ride"] = 119.04, ["Fly|Ride"] = 210.72, ["Neon"] = 525, ["Neon|Fly"] = 667.95, ["Neon|Ride"] = 492.19, ["Neon|Fly|Ride"] = 558.21, ["Mega|Fly|Ride"] = 1929.38}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 3.94, ["Ride"] = 30.19, ["Fly|Ride"] = 197.03, ["Neon"] = 56.74, ["Neon|Ride"] = 112.72, ["Neon|Fly|Ride"] = 152.25, ["Mega"] = 281.24, ["Mega|Ride"] = 365.5, ["Mega|Fly|Ride"] = 407.64}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.52, ["Fly"] = 31.49, ["Ride"] = 20.98, ["Fly|Ride"] = 50.74, ["Neon"] = 24.39, ["Neon|Ride"] = 37.02, ["Neon|Fly|Ride"] = 124.83, ["Mega"] = 141.75, ["Mega|Ride"] = 277.03, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 28.29, ["Fly"] = 59.07, ["Ride"] = 85.31, ["Fly|Ride"] = 170.63, ["Neon"] = 82.69, ["Neon|Ride"] = 132.57, ["Neon|Fly|Ride"] = 294.54, ["Mega"] = 461.34, ["Mega|Ride"] = 562.46, ["Mega|Fly|Ride"] = 543.38}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 9.19}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 6.08, ["Ride"] = 32.67, ["Neon"] = 39.38, ["Neon|Ride"] = 46.68, ["Neon|Fly|Ride"] = 631.98, ["Mega"] = 315, ["Mega|Ride"] = 421.32, ["Mega|Fly|Ride"] = 546.67}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 22.32, ["Fly"] = 40.05, ["Ride"] = 34.13, ["Fly|Ride"] = 52.5, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 77.96, ["Neon|Fly|Ride"] = 176.74, ["Mega"] = 2106.56, ["Mega|Fly|Ride"] = 580.37}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Fly"] = 31.62, ["Ride"] = 26.25, ["Neon"] = 3.93, ["Neon|Ride"] = 28.35, ["Neon|Fly|Ride"] = 70.59, ["Mega"] = 33.9, ["Mega|Ride"] = 84.28, ["Mega|Fly|Ride"] = 158.82}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 3.71, ["Fly"] = 28.09, ["Ride"] = 20.6, ["Fly|Ride"] = 77.98, ["Neon"] = 30.58, ["Neon|Ride"] = 233.31, ["Mega"] = 264.48, ["Mega|Fly"] = 389.62, ["Mega|Ride"] = 162.23, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 3.93, ["Ride"] = 21, ["Fly|Ride"] = 77.68, ["Neon"] = 23.05, ["Neon|Ride"] = 32.67, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 118.13, ["Mega|Fly"] = 281.24, ["Mega|Ride"] = 122.07, ["Mega|Fly|Ride"] = 233.31}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.05, ["Ride"] = 23.63, ["Neon"] = 3.82, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 132.99, ["Mega"] = 24.24, ["Mega|Ride"] = 62.97, ["Mega|Fly|Ride"] = 130.62}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 28.71, ["Ride"] = 67.52, ["Fly|Ride"] = 281.31, ["Neon"] = 209.64, ["Neon|Ride"] = 280.19, ["Mega"] = 966.92, ["Mega|Ride"] = 753.38, ["Mega|Fly|Ride"] = 916.88}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 4.68, ["Ride"] = 48.38, ["Fly|Ride"] = 210, ["Neon"] = 47.25, ["Neon|Ride"] = 79.02, ["Mega"] = 141.16, ["Mega|Ride"] = 390.78, ["Mega|Fly|Ride"] = 702.55}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 11.82, ["Fly"] = 45.94, ["Ride"] = 51.7, ["Fly|Ride"] = 101.88, ["Neon"] = 38.48, ["Neon|Fly"] = 210.26, ["Neon|Ride"] = 54.05, ["Neon|Fly|Ride"] = 124.83, ["Mega"] = 377.99, ["Mega|Ride"] = 313.83, ["Mega|Fly|Ride"] = 419.95}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 62.98, ["Fly"] = 136.98, ["Ride"] = 103.69, ["Fly|Ride"] = 209.87, ["Neon"] = 291.53, ["Neon|Ride"] = 466.61, ["Mega|Ride"] = 1968.75, ["Mega|Fly|Ride"] = 3032.88}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 22.51, ["Ride"] = 39.38, ["Fly|Ride"] = 139.08, ["Neon"] = 105.25, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 121.14, ["Mega"] = 393.75, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 467.24}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 68.14, ["Ride"] = 101.43, ["Fly|Ride"] = 199.1, ["Neon"] = 200.82, ["Neon|Ride"] = 281.24, ["Neon|Fly|Ride"] = 354.38, ["Mega"] = 983.77, ["Mega|Ride"] = 826.87, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 25.1, ["Ride"] = 83.24, ["Fly|Ride"] = 162.75, ["Neon"] = 114.19, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 280.19, ["Mega"] = 434.7, ["Mega|Ride"] = 323.87, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 3.93, ["Fly"] = 69.5, ["Ride"] = 23.33, ["Neon"] = 65.63, ["Neon|Ride"] = 267.54, ["Neon|Fly|Ride"] = 112.72, ["Mega"] = 105, ["Mega|Ride"] = 1053.29, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 20.79, ["Ride"] = 70.6, ["Fly|Ride"] = 209.87, ["Neon"] = 109.62, ["Neon|Ride"] = 186.64, ["Neon|Fly|Ride"] = 525, ["Mega"] = 349.7, ["Mega|Ride"] = 349.65, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 10.5, ["Ride"] = 41.11, ["Fly|Ride"] = 104.89, ["Neon"] = 28, ["Neon|Fly"] = 112.74, ["Neon|Ride"] = 99.02, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 249.65, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.05, ["Neon"] = 2.1, ["Neon|Ride"] = 26.25, ["Mega"] = 15.75, ["Mega|Fly"] = 141.16, ["Mega|Ride"] = 66.94, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 5.25, ["Ride"] = 209.41, ["Neon"] = 17.07, ["Neon|Ride"] = 83.83, ["Mega"] = 105, ["Mega|Ride"] = 156.19, ["Mega|Fly|Ride"] = 311.31}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 3.93, ["Neon"] = 22.32, ["Neon|Ride"] = 103.69, ["Mega"] = 280.19}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 3.81, ["Ride"] = 31.44, ["Fly|Ride"] = 115.42, ["Neon"] = 17.77, ["Neon|Ride"] = 82.95, ["Neon|Fly|Ride"] = 280.19, ["Mega"] = 123.38, ["Mega|Ride"] = 152.97, ["Mega|Fly|Ride"] = 508.6}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 470.77, ["Fly"] = 632.14, ["Ride"] = 485.63, ["Fly|Ride"] = 498.75, ["Neon"] = 2620.14, ["Neon|Ride"] = 1784.26, ["Neon|Fly|Ride"] = 1443.75, ["Mega|Fly|Ride"] = 4593.75}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 6.57, ["Fly"] = 35.84, ["Ride"] = 25.15, ["Fly|Ride"] = 62.83, ["Neon"] = 28, ["Neon|Ride"] = 77.6, ["Neon|Fly|Ride"] = 124.83, ["Mega"] = 239.11, ["Mega|Ride"] = 281.24}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 9.18, ["Fly"] = 31.5, ["Ride"] = 25.1, ["Fly|Ride"] = 84.29, ["Neon"] = 68.81, ["Neon|Fly"] = 315, ["Neon|Ride"] = 64.32, ["Mega"] = 366.56, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 421.72}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 2.92, ["Fly"] = 28.46, ["Ride"] = 23.23, ["Fly|Ride"] = 112.74, ["Neon|Ride"] = 156.32, ["Mega"] = 223.13, ["Mega|Ride"] = 354.38, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.05, ["Fly"] = 65.63, ["Ride"] = 30.33, ["Fly|Ride"] = 78.12, ["Neon"] = 10.87, ["Neon|Fly"] = 70.6, ["Neon|Ride"] = 35.01, ["Neon|Fly|Ride"] = 112.35, ["Mega"] = 65.63, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 208.57}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Ride"] = 70.6, ["Neon"] = 3.72, ["Neon|Fly"] = 46.66, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 116.67, ["Mega"] = 20.98, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 141.16}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 853.13}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 5.24, ["Fly"] = 56.9, ["Ride"] = 38.04, ["Neon"] = 70.22, ["Neon|Fly"] = 141.19, ["Neon|Ride"] = 99.02, ["Neon|Fly|Ride"] = 631.98, ["Mega"] = 488.74, ["Mega|Ride"] = 806.81, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.52, ["Neon"] = 7.88, ["Neon|Ride"] = 42.15, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 84.96, ["Mega|Ride"] = 141.16, ["Mega|Fly|Ride"] = 233.31}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.1, ["Fly"] = 42.15, ["Ride"] = 42, ["Fly|Ride"] = 525, ["Neon"] = 11.27, ["Neon|Ride"] = 70.59, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 164.07, ["Mega|Ride"] = 154.88, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 393.75, ["Ride"] = 420, ["Fly|Ride"] = 499.38, ["Neon|Ride"] = 1509.38, ["Neon|Fly|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 8146.01}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 8.44, ["Fly"] = 196.88, ["Ride"] = 72.19, ["Neon"] = 24.94, ["Neon|Ride"] = 131.25, ["Mega"] = 393.75, ["Mega|Fly"] = 316, ["Mega|Ride"] = 399.2}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Ride"] = 36.89, ["Neon"] = 4.69, ["Neon|Ride"] = 45.51, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 30.35, ["Mega|Fly"] = 189, ["Mega|Ride"] = 62.99, ["Mega|Fly|Ride"] = 156.27}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 2.63, ["Neon|Ride"] = 23.35, ["Neon|Fly|Ride"] = 267.54, ["Mega"] = 20.9, ["Mega|Ride"] = 124.73, ["Mega|Fly|Ride"] = 192.94}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 12.66, ["Fly"] = 78.72, ["Ride"] = 36.89, ["Fly|Ride"] = 178.5, ["Neon"] = 65.63, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 311.78, ["Mega"] = 328.13, ["Mega|Ride"] = 281.24, ["Mega|Fly|Ride"] = 372.75}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 13.13, ["Ride"] = 116.6, ["Neon"] = 109.62, ["Neon|Fly|Ride"] = 124.83, ["Mega"] = 622.93, ["Mega|Ride"] = 560.35, ["Mega|Fly|Ride"] = 1072.98}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 5.97, ["Fly|Ride"] = 99.05, ["Neon"] = 141.19, ["Neon|Ride"] = 209.62, ["Mega"] = 582.75, ["Mega|Ride"] = 412.91, ["Mega|Fly|Ride"] = 1244.65}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 12.48, ["Ride"] = 43.32, ["Neon"] = 115.48, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 778.07, ["Mega"] = 653.24, ["Mega|Ride"] = 568.09, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 366.85, ["Ride"] = 341.25, ["Fly|Ride"] = 443.01, ["Neon"] = 1405.42, ["Neon|Ride"] = 1095.42, ["Neon|Fly|Ride"] = 1224.97, ["Mega|Ride"] = 3226.18, ["Mega|Fly|Ride"] = 3084.38}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 4.03, ["Fly"] = 28.3, ["Ride"] = 44.61, ["Fly|Ride"] = 59.07, ["Neon"] = 59.07, ["Neon|Ride"] = 99.02, ["Neon|Fly|Ride"] = 180.49, ["Mega"] = 529.78, ["Mega|Ride"] = 521.73, ["Mega|Fly|Ride"] = 530.86}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 5.55, ["Ride"] = 33.72, ["Fly|Ride"] = 281.31, ["Neon"] = 28.46, ["Mega"] = 281.24, ["Mega|Fly|Ride"] = 1685.24}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 14.3, ["Ride"] = 46.65, ["Fly|Ride"] = 141.19, ["Neon"] = 36.52, ["Neon|Ride"] = 56.48, ["Neon|Fly|Ride"] = 141.16, ["Mega"] = 183.74, ["Mega|Ride"] = 202.12, ["Mega|Fly|Ride"] = 305.82}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.1, ["Ride"] = 42, ["Fly|Ride"] = 108.53, ["Neon"] = 11.82, ["Neon|Fly"] = 35.84, ["Neon|Ride"] = 45.61, ["Mega"] = 38.03, ["Mega|Ride"] = 70.59, ["Mega|Fly|Ride"] = 202.98}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 36.75, ["Ride"] = 69.47, ["Neon"] = 262.5, ["Neon|Ride"] = 202.98, ["Neon|Fly|Ride"] = 280.19, ["Mega"] = 2527.86, ["Mega|Ride"] = 980.61, ["Mega|Fly|Ride"] = 875.27}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.5, ["Fly"] = 582.89, ["Ride"] = 31.49, ["Fly|Ride"] = 79.97, ["Neon"] = 8.44, ["Neon|Fly"] = 183.33, ["Neon|Ride"] = 54.78, ["Neon|Fly|Ride"] = 112.88, ["Mega"] = 61.69, ["Mega|Ride"] = 98, ["Mega|Fly|Ride"] = 223.31}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.5, ["Ride"] = 26.25, ["Fly|Ride"] = 148.25, ["Neon"] = 4.99, ["Neon|Fly"] = 70.6, ["Neon|Ride"] = 44.34, ["Neon|Fly|Ride"] = 140.33, ["Mega"] = 26.25, ["Mega|Fly"] = 91.65, ["Mega|Ride"] = 65.33, ["Mega|Fly|Ride"] = 140.44}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.5, ["Ride"] = 56.79, ["Fly|Ride"] = 262.5, ["Neon"] = 10.55, ["Neon|Ride"] = 158.06, ["Neon|Fly|Ride"] = 250.43, ["Mega"] = 116.82, ["Mega|Ride"] = 137.37, ["Mega|Fly|Ride"] = 311.07}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 55.95, ["Ride"] = 105.13, ["Fly|Ride"] = 109.6, ["Neon"] = 421.42, ["Neon|Ride"] = 311.48, ["Neon|Fly|Ride"] = 692.35, ["Mega|Fly|Ride"] = 1011.15}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 269.66, ["Ride"] = 309.75, ["Fly|Ride"] = 407.73, ["Neon|Ride"] = 918.74, ["Neon|Fly|Ride"] = 1263.93, ["Mega"] = 7022.17, ["Mega|Fly|Ride"] = 5727.7}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 4.87, ["Neon"] = 31.5, ["Mega"] = 78.75, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 412.95}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 10.55, ["Ride"] = 36.15, ["Neon"] = 18.67, ["Neon|Ride"] = 42.15, ["Mega"] = 91.88, ["Mega|Ride"] = 267.54, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 3.81, ["Fly"] = 155.57, ["Ride"] = 91.88, ["Neon"] = 39.38, ["Neon|Fly|Ride"] = 156.32, ["Mega"] = 504.67, ["Mega|Ride"] = 337.84}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 53.23, ["Ride"] = 21.08, ["Fly|Ride"] = 40.69, ["Neon"] = 2.1, ["Neon|Ride"] = 28.01, ["Neon|Fly|Ride"] = 182.62, ["Mega"] = 44.62, ["Mega|Fly"] = 126.41, ["Mega|Ride"] = 78.17, ["Mega|Fly|Ride"] = 178.5}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 58.97, ["Fly|Ride"] = 281.31, ["Neon"] = 6.34, ["Mega"] = 32.78, ["Mega|Fly"] = 141.16, ["Mega|Ride"] = 206.07}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 20.03, ["Fly|Ride"] = 41.91, ["Neon"] = 3.84, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 23.19, ["Neon|Fly|Ride"] = 105, ["Mega"] = 42.15, ["Mega|Fly"] = 10954.02, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 281.24}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 24.94, ["Fly|Ride"] = 45.94, ["Neon"] = 17.07, ["Neon|Fly"] = 46.66, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 91.65, ["Mega"] = 170.63, ["Mega|Ride"] = 183.28, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 48.46, ["Ride"] = 138.28, ["Fly|Ride"] = 105.36, ["Neon"] = 93.3, ["Neon|Ride"] = 155.9, ["Mega"] = 367.5, ["Mega|Fly"] = 446.25, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 61.5, ["Fly"] = 582.75, ["Ride"] = 94.5, ["Fly|Ride"] = 156.22, ["Neon"] = 490.95, ["Neon|Ride"] = 393.74, ["Neon|Fly|Ride"] = 471.19, ["Mega"] = 3111.04, ["Mega|Ride"] = 1826.39, ["Mega|Fly|Ride"] = 1516.73}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 23.23, ["Fly|Ride"] = 42.15, ["Neon"] = 5.64, ["Neon|Ride"] = 109.67, ["Neon|Fly|Ride"] = 141.16, ["Mega"] = 39.79, ["Mega|Ride"] = 91.65}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 16.35, ["Ride"] = 18.9, ["Fly|Ride"] = 30.15, ["Neon"] = 3.68, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 24.91, ["Neon|Fly|Ride"] = 63, ["Mega"] = 45.94, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 15.81, ["Ride"] = 42.15, ["Neon"] = 156.28, ["Neon|Ride"] = 349.7, ["Neon|Fly|Ride"] = 280.19, ["Mega"] = 617.24, ["Mega|Ride"] = 352.4, ["Mega|Fly|Ride"] = 472.38}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 209.84, ["Fly"] = 249.38, ["Ride"] = 252.86, ["Fly|Ride"] = 279.5, ["Neon|Ride"] = 1123.85, ["Neon|Fly|Ride"] = 1525.15, ["Mega|Fly|Ride"] = 5181.05}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 34.12, ["Fly"] = 209.9, ["Ride"] = 79, ["Fly|Ride"] = 105.36, ["Neon"] = 377.88, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 457.28, ["Mega"] = 966.69, ["Mega|Ride"] = 761.25, ["Mega|Fly|Ride"] = 971.25}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 12.66, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 44.25, ["Neon|Fly|Ride"] = 225.42, ["Mega"] = 94.5, ["Mega|Ride"] = 141.16, ["Mega|Fly|Ride"] = 253.32}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 4.11, ["Fly"] = 210.72, ["Ride"] = 38.06, ["Fly|Ride"] = 142.7, ["Neon"] = 4.23, ["Neon|Ride"] = 201.2, ["Mega"] = 484.52, ["Mega|Ride"] = 436.28}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 26.23, ["Fly"] = 77.65, ["Ride"] = 45.94, ["Fly|Ride"] = 63.23, ["Neon|Ride"] = 167.49, ["Neon|Fly|Ride"] = 195.92, ["Mega"] = 2527.86, ["Mega|Ride"] = 904.32, ["Mega|Fly|Ride"] = 1089.11}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 88.5, ["Ride"] = 105, ["Fly|Ride"] = 190.03, ["Neon"] = 426.57, ["Neon|Ride"] = 469.88, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 3090.31, ["Mega|Fly|Ride"] = 2179.01}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 237.57, ["Ride"] = 263.82, ["Fly|Ride"] = 562.59, ["Neon"] = 820.32, ["Neon|Ride"] = 1050, ["Neon|Fly|Ride"] = 984.38, ["Mega|Fly|Ride"] = 3167.19}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 13.12, ["Ride"] = 70.6, ["Fly|Ride"] = 66.39, ["Neon"] = 105, ["Neon|Ride"] = 156.32, ["Neon|Fly|Ride"] = 842.63, ["Mega"] = 388.5, ["Mega|Ride"] = 466.61, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 16.42, ["Ride"] = 16.92, ["Fly|Ride"] = 30.19, ["Neon"] = 15.81, ["Neon|Fly"] = 70.6, ["Neon|Ride"] = 20.05, ["Neon|Fly|Ride"] = 70.01, ["Mega"] = 91.5, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 3.92, ["Ride"] = 19.69, ["Fly|Ride"] = 70.27, ["Neon"] = 23.47, ["Neon|Ride"] = 36.71, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 250.79, ["Mega|Ride"] = 221.82, ["Mega|Fly|Ride"] = 259.87}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 269, ["Ride"] = 315, ["Fly|Ride"] = 358.21, ["Neon"] = 1334.83, ["Neon|Ride"] = 1243.12, ["Neon|Fly|Ride"] = 1740.01, ["Mega|Fly|Ride"] = 6635.62}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.5, ["Ride"] = 46.36, ["Neon"] = 8.9, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 28.46, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 300.97}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 4.23, ["Ride"] = 17.07, ["Fly|Ride"] = 36.91, ["Neon"] = 19.26, ["Neon|Ride"] = 31.52, ["Neon|Fly|Ride"] = 110.25, ["Mega"] = 184.33, ["Mega|Ride"] = 280.19, ["Mega|Fly|Ride"] = 249.17}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 19.5, ["Ride"] = 140.89, ["Neon"] = 88.1, ["Neon|Ride"] = 145.37, ["Neon|Fly|Ride"] = 539.3, ["Mega"] = 626.72, ["Mega|Ride"] = 502.48, ["Mega|Fly|Ride"] = 627.77}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 112.72, ["Fly"] = 280.26, ["Ride"] = 131.25, ["Fly|Ride"] = 147.51, ["Neon|Ride"] = 563.07, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 1919.08}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 17.07, ["Fly"] = 81.62, ["Ride"] = 25.72, ["Fly|Ride"] = 53.82, ["Neon"] = 69.96, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 491.9, ["Mega|Ride"] = 466.61, ["Mega|Fly|Ride"] = 414.75}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.05, ["Ride"] = 24.49, ["Neon"] = 2.1, ["Neon|Ride"] = 48.46, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 37.94, ["Mega|Fly|Ride"] = 451.44}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 72.19, ["Neon"] = 2.63, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 27.2, ["Neon|Fly|Ride"] = 69.18, ["Mega"] = 28.01, ["Mega|Fly"] = 138.83, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 100.73}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 14.02, ["Ride"] = 59.05, ["Fly|Ride"] = 94.5, ["Neon"] = 46.68, ["Neon|Fly"] = 264.71, ["Neon|Ride"] = 84.28, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 142.64, ["Mega|Ride"] = 219.21, ["Mega|Fly|Ride"] = 246.75}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1433.25, ["Ride"] = 1246.88, ["Fly|Ride"] = 1486.54, ["Neon"] = 7164, ["Neon|Ride"] = 7022.17, ["Neon|Fly|Ride"] = 6966.36, ["Mega|Fly|Ride"] = 14437.5}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 544.69, ["Ride"] = 573.57, ["Fly|Ride"] = 623.33, ["Neon|Ride"] = 3090.31, ["Neon|Fly|Ride"] = 2231.25, ["Mega"] = 13997.83, ["Mega|Fly|Ride"] = 7084.87}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 288.75, ["Fly"] = 421.42, ["Ride"] = 315, ["Fly|Ride"] = 422.63, ["Neon"] = 735, ["Neon|Ride"] = 832.1, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 5335.89, ["Mega|Fly|Ride"] = 2916.23}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 310.73, ["Fly"] = 366.07, ["Ride"] = 362.25, ["Fly|Ride"] = 446.25, ["Neon"] = 1166.07, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 871.5, ["Mega|Fly|Ride"] = 3019.74}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.63, ["Fly"] = 80.08, ["Ride"] = 19.69, ["Fly|Ride"] = 43.74, ["Neon"] = 5.33, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 77.65, ["Mega"] = 80.07, ["Mega|Ride"] = 77.96, ["Mega|Fly|Ride"] = 144.37}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 301.77, ["Fly"] = 590.62, ["Ride"] = 416.16, ["Fly|Ride"] = 582.89, ["Neon"] = 1081.99, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 1141.88, ["Mega"] = 4213.1, ["Mega|Ride"] = 4477.39, ["Mega|Fly|Ride"] = 3793.13}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 2.5, ["Fly"] = 183.75, ["Ride"] = 27.29, ["Neon"] = 9.17, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 112.72, ["Mega"] = 78.75, ["Mega|Ride"] = 101.07, ["Mega|Fly|Ride"] = 272.35}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 20.14, ["Ride"] = 23.33, ["Fly|Ride"] = 49.88, ["Neon"] = 7.86, ["Neon|Ride"] = 61.69, ["Neon|Fly|Ride"] = 62.99, ["Mega"] = 125.36, ["Mega|Ride"] = 134.84, ["Mega|Fly|Ride"] = 311.48}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Neon"] = 5.25, ["Neon|Fly"] = 78.1, ["Mega"] = 31.52, ["Mega|Fly"] = 70.59, ["Mega|Ride"] = 56.89, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 53.44, ["Ride"] = 65.63, ["Fly|Ride"] = 459.38, ["Neon"] = 244.13, ["Neon|Ride"] = 420, ["Mega"] = 1685.24, ["Mega|Fly|Ride"] = 983.77}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.63, ["Fly"] = 65.61, ["Ride"] = 23.56, ["Fly|Ride"] = 43.32, ["Neon"] = 24.25, ["Mega"] = 328.13, ["Mega|Ride"] = 316}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.12, ["Fly|Ride"] = 63, ["Neon"] = 3.84, ["Neon|Fly"] = 102.64, ["Neon|Ride"] = 36.26, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 24.94, ["Mega|Fly"] = 337.05, ["Mega|Ride"] = 64.22, ["Mega|Fly|Ride"] = 308.44}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.52, ["Fly"] = 31.47, ["Ride"] = 18.95, ["Fly|Ride"] = 52.59, ["Neon"] = 8.93, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 28.41, ["Neon|Fly|Ride"] = 71.99, ["Mega"] = 60.38, ["Mega|Fly"] = 135.32, ["Mega|Ride"] = 80.07, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 3.18, ["Fly"] = 46.96, ["Ride"] = 41.91, ["Fly|Ride"] = 32.82, ["Neon"] = 103.26, ["Neon|Fly"] = 139.95, ["Neon|Ride"] = 139.06, ["Neon|Fly|Ride"] = 251.85, ["Mega"] = 237.56, ["Mega|Fly|Ride"] = 1019.82}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 14.43, ["Ride"] = 42.15, ["Neon"] = 110.19, ["Mega"] = 389.61, ["Mega|Ride"] = 334.95, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 87.94, ["Neon"] = 42, ["Neon|Ride"] = 62.91, ["Neon|Fly|Ride"] = 699.9, ["Mega"] = 281.24, ["Mega|Ride"] = 466.61, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.05, ["Fly"] = 39.38, ["Ride"] = 19.67, ["Fly|Ride"] = 84, ["Neon"] = 3.14, ["Neon|Ride"] = 35.82, ["Mega"] = 40.69, ["Mega|Ride"] = 56.89, ["Mega|Fly|Ride"] = 316}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 216.99, ["Fly"] = 295, ["Ride"] = 219.19, ["Fly|Ride"] = 262.5, ["Neon"] = 1165.76, ["Neon|Ride"] = 1367.17, ["Neon|Fly|Ride"] = 1050, ["Mega"] = 10532.72, ["Mega|Fly|Ride"] = 4213.1}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 16.88, ["Fly|Ride"] = 37.79, ["Neon"] = 3.92, ["Neon|Ride"] = 23.37, ["Neon|Fly|Ride"] = 55.13, ["Mega"] = 53.53, ["Mega|Ride"] = 64.53, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 10.48, ["Ride"] = 98.44, ["Fly|Ride"] = 102.38, ["Neon"] = 46.18, ["Neon|Ride"] = 104.41, ["Mega"] = 315, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 466.61}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 44.99, ["Ride"] = 137.69, ["Neon"] = 183.75, ["Neon|Ride"] = 210.67, ["Mega"] = 701.5, ["Mega|Ride"] = 737.3, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 155.93, ["Fly"] = 291.38, ["Ride"] = 184.43, ["Fly|Ride"] = 278.15, ["Neon"] = 819.77, ["Neon|Ride"] = 648.38, ["Neon|Fly|Ride"] = 866.25, ["Mega|Ride"] = 2625, ["Mega|Fly|Ride"] = 3474.76}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 19, ["Neon"] = 78.75, ["Mega"] = 281.54, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 702.55}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 35.9, ["Ride"] = 261.19, ["Fly|Ride"] = 632.14, ["Neon"] = 221.26, ["Neon|Ride"] = 314.94, ["Neon|Fly|Ride"] = 842.63, ["Mega"] = 773.11, ["Mega|Fly|Ride"] = 2106.56}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 1181.25, ["Fly"] = 1321.14, ["Ride"] = 1124.13, ["Fly|Ride"] = 1275.75, ["Neon|Ride"] = 5618.16, ["Neon|Fly|Ride"] = 4315.24, ["Mega|Fly|Ride"] = 16987.17}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 10.5, ["Fly"] = 28, ["Ride"] = 20.03, ["Fly|Ride"] = 62.99, ["Neon"] = 52.5, ["Neon|Fly"] = 111.57, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 211.95, ["Mega|Ride"] = 237.01, ["Mega|Fly|Ride"] = 530.03}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 8.43, ["Fly"] = 39.38, ["Ride"] = 35.44, ["Neon"] = 42, ["Neon|Ride"] = 140.86, ["Neon|Fly|Ride"] = 144.74, ["Mega"] = 212.63, ["Mega|Ride"] = 217.88, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 3.72, ["Fly"] = 28.46, ["Ride"] = 31.49, ["Fly|Ride"] = 91.67, ["Neon"] = 15.75, ["Neon|Ride"] = 56.89, ["Neon|Fly|Ride"] = 311.48, ["Mega"] = 135.09, ["Mega|Ride"] = 267.54, ["Mega|Fly|Ride"] = 842.63}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 22.32, ["Fly"] = 702.72, ["Ride"] = 31.46, ["Fly|Ride"] = 82.69, ["Neon"] = 81.18, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 373.3, ["Mega|Ride"] = 310.73, ["Mega|Fly|Ride"] = 408.19}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 28.46, ["Fly|Ride"] = 45.48, ["Neon"] = 19.66, ["Neon|Fly"] = 41.94, ["Neon|Ride"] = 28.46, ["Neon|Fly|Ride"] = 84.28, ["Mega|Ride"] = 277.64, ["Mega|Fly|Ride"] = 199.06}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 3.93, ["Fly"] = 39.38, ["Ride"] = 45.94, ["Neon"] = 11.46, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 28.46, ["Neon|Fly|Ride"] = 842.63, ["Mega"] = 195.92, ["Mega|Ride"] = 172.09, ["Mega|Fly|Ride"] = 367.42}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 189.6, ["Ride"] = 333.38, ["Fly|Ride"] = 541.52, ["Neon|Ride"] = 1545.16, ["Neon|Fly|Ride"] = 1448.26, ["Mega|Fly|Ride"] = 4065.64}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.39, ["Ride"] = 27.78, ["Fly|Ride"] = 53.65, ["Neon"] = 10.56, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 94.39, ["Mega|Ride"] = 208.57, ["Mega|Fly|Ride"] = 233.31}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 2.15, ["Neon"] = 46.36, ["Neon|Ride"] = 313.69, ["Mega"] = 277.03, ["Mega|Ride"] = 842.63}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 2.41, ["Fly"] = 58.11, ["Ride"] = 34.13, ["Neon"] = 19.29, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 203.03, ["Mega"] = 74.06, ["Mega|Fly"] = 421.32, ["Mega|Ride"] = 130.62, ["Mega|Fly|Ride"] = 347.17}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 129.94, ["Fly"] = 310.8, ["Ride"] = 164.07, ["Fly|Ride"] = 351.9, ["Neon"] = 590.63, ["Neon|Ride"] = 523.95, ["Neon|Fly|Ride"] = 702.55, ["Mega|Ride"] = 5055.71, ["Mega|Fly|Ride"] = 1671.55}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 24.28, ["Fly"] = 61.62, ["Ride"] = 84.29, ["Fly|Ride"] = 109.58, ["Neon"] = 141.19, ["Neon|Ride"] = 116.93, ["Neon|Fly|Ride"] = 280.19, ["Mega"] = 685.7, ["Mega|Ride"] = 723.61, ["Mega|Fly|Ride"] = 656.2}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 22.31, ["Ride"] = 78.75, ["Fly|Ride"] = 1264.25, ["Neon"] = 118.13, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 267.54, ["Mega"] = 522.6, ["Mega|Ride"] = 369.57, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Fly"] = 42, ["Ride"] = 28.46, ["Neon"] = 3.89, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 99.02, ["Mega"] = 26.84, ["Mega|Ride"] = 70.3, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 77.42, ["Fly"] = 110.76, ["Ride"] = 116.6, ["Fly|Ride"] = 227.57, ["Neon"] = 375.38, ["Neon|Fly"] = 367.5, ["Neon|Ride"] = 354.38, ["Neon|Fly|Ride"] = 420, ["Mega|Fly|Ride"] = 1200.74}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 20.03, ["Neon"] = 5.03, ["Neon|Ride"] = 48.46, ["Neon|Fly|Ride"] = 588, ["Mega"] = 45.94, ["Mega|Ride"] = 223.13}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 19.25, ["Fly"] = 141.19, ["Ride"] = 30.57, ["Fly|Ride"] = 109.6, ["Neon"] = 81.84, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 139.99, ["Mega"] = 380.63, ["Mega|Ride"] = 409.45, ["Mega|Fly|Ride"] = 350.44}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 42, ["Fly"] = 109.58, ["Ride"] = 93.11, ["Fly|Ride"] = 138.6, ["Neon"] = 289.91, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 261.19, ["Mega|Ride"] = 1228.14, ["Mega|Fly|Ride"] = 1134}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 28.77, ["Ride"] = 15.81, ["Fly|Ride"] = 19.69, ["Neon"] = 2.1, ["Neon|Fly"] = 27.72, ["Neon|Ride"] = 19.59, ["Neon|Fly|Ride"] = 36.01, ["Mega"] = 18.67, ["Mega|Fly"] = 55.13, ["Mega|Ride"] = 42.15, ["Mega|Fly|Ride"] = 84}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 4.68, ["Ride"] = 32.18, ["Fly|Ride"] = 98.65, ["Neon"] = 36.89, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 144.38, ["Mega|Ride"] = 280.23, ["Mega|Fly|Ride"] = 521.73}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 16.7, ["Ride"] = 41.99, ["Neon"] = 135.87, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 174.85, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 673.05, ["Mega|Ride"] = 643.56, ["Mega|Fly|Ride"] = 622.93}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.05, ["Ride"] = 17.07, ["Neon"] = 2.1, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 136.94, ["Mega"] = 15.74, ["Mega|Ride"] = 108.5, ["Mega|Fly|Ride"] = 310.42}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 4.67, ["Fly"] = 210, ["Ride"] = 21.08, ["Fly|Ride"] = 51.31, ["Neon"] = 42.14, ["Neon|Ride"] = 98.65, ["Neon|Fly|Ride"] = 183.28, ["Mega"] = 501.38, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 15.57, ["Fly"] = 41.97, ["Ride"] = 21.08, ["Fly|Ride"] = 62.97, ["Neon"] = 44.37, ["Neon|Ride"] = 95.86, ["Neon|Fly|Ride"] = 63, ["Mega|Ride"] = 267.54, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 29.96, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 28.46, ["Neon|Fly|Ride"] = 200.82, ["Mega"] = 169.32, ["Mega|Ride"] = 160.13, ["Mega|Fly|Ride"] = 292.83}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 17.07, ["Fly"] = 2107.07, ["Ride"] = 54.8, ["Neon"] = 80.64, ["Neon|Fly"] = 210.72, ["Neon|Ride"] = 334.69, ["Neon|Fly|Ride"] = 6220.88, ["Mega"] = 458.99, ["Mega|Ride"] = 545.61, ["Mega|Fly|Ride"] = 816.31}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Ride"] = 82.49, ["Fly|Ride"] = 105.36, ["Neon"] = 8.99, ["Neon|Ride"] = 57.02, ["Neon|Fly|Ride"] = 99.08, ["Mega"] = 74.82, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 138, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Neon"] = 3.92, ["Neon|Ride"] = 42.15, ["Mega"] = 23.21, ["Mega|Ride"] = 138, ["Mega|Fly|Ride"] = 218.14}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 38.06}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 52.54, ["Fly"] = 102.38, ["Ride"] = 52.5, ["Fly|Ride"] = 116.95, ["Neon"] = 1050, ["Neon|Ride"] = 246.48, ["Neon|Fly|Ride"] = 1053.29, ["Mega"] = 1095.42, ["Mega|Ride"] = 981.66, ["Mega|Fly|Ride"] = 889.87}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Ride"] = 81.38, ["Fly|Ride"] = 101.07, ["Neon"] = 3.42, ["Neon|Ride"] = 26.84, ["Mega"] = 18.35, ["Mega|Fly"] = 137.82, ["Mega|Ride"] = 99.02, ["Mega|Fly|Ride"] = 116.82}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 551.25, ["Ride"] = 538.13, ["Fly|Ride"] = 642.5, ["Neon"] = 2625, ["Neon|Ride"] = 1903.13, ["Neon|Fly|Ride"] = 2387.78, ["Mega"] = 8426.18, ["Mega|Fly|Ride"] = 10532.72}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 2.57, ["Fly"] = 26.25, ["Ride"] = 40.94, ["Fly|Ride"] = 73.6, ["Neon"] = 32.16, ["Neon|Fly"] = 702.72, ["Neon|Ride"] = 104.29, ["Mega"] = 78.59, ["Mega|Ride"] = 141.16, ["Mega|Fly|Ride"] = 562.46}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 7.87, ["Fly"] = 44.26, ["Ride"] = 23.25, ["Fly|Ride"] = 46.65, ["Neon"] = 22.32, ["Neon|Ride"] = 35.37, ["Neon|Fly|Ride"] = 87.43, ["Mega"] = 261.22, ["Mega|Ride"] = 158.05, ["Mega|Fly|Ride"] = 182.44}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 15.65, ["Ride"] = 35.84, ["Fly|Ride"] = 106.32, ["Neon"] = 116.27, ["Neon|Ride"] = 181.13, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 1068.03, ["Mega|Ride"] = 969.03, ["Mega|Fly|Ride"] = 547.72}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 3.71, ["Fly"] = 39.38, ["Ride"] = 39.38, ["Fly|Ride"] = 139.08, ["Neon"] = 40.09, ["Mega"] = 292.83, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 9.53, ["Ride"] = 72.19, ["Fly|Ride"] = 157.5, ["Neon"] = 28.46, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 350.44, ["Mega"] = 363.57, ["Mega|Ride"] = 406.23, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 9.34, ["Fly"] = 97.64, ["Ride"] = 40.82, ["Fly|Ride"] = 39.38, ["Neon"] = 31.62, ["Neon|Ride"] = 91.77, ["Neon|Fly|Ride"] = 284.82, ["Mega"] = 166.43, ["Mega|Fly"] = 486.63, ["Mega|Ride"] = 195.57, ["Mega|Fly|Ride"] = 294}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 27.41, ["Ride"] = 15.78, ["Fly|Ride"] = 28.88, ["Neon"] = 2.1, ["Neon|Fly"] = 28.46, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 70.26, ["Mega"] = 16.41, ["Mega|Fly"] = 78.11, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 82.69}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 6.55, ["Ride"] = 39.38, ["Fly|Ride"] = 157.94, ["Neon"] = 31.49, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 311.48, ["Mega"] = 167.88, ["Mega|Ride"] = 217.88, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 259.87, ["Ride"] = 300.56, ["Fly|Ride"] = 393.75, ["Neon"] = 1480.5, ["Neon|Ride"] = 1036.43, ["Neon|Fly|Ride"] = 1426.69, ["Mega|Fly|Ride"] = 4081.88}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 89.24, ["Ride"] = 147, ["Fly|Ride"] = 7725.53, ["Neon"] = 455.14, ["Neon|Ride"] = 660.24, ["Neon|Fly|Ride"] = 698.25, ["Mega"] = 4213.1, ["Mega|Ride"] = 1529.37, ["Mega|Fly|Ride"] = 1595.77}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 23.19, ["Ride"] = 22.16, ["Fly|Ride"] = 38.06, ["Neon"] = 19.67, ["Neon|Ride"] = 33.53, ["Neon|Fly|Ride"] = 62.67, ["Mega|Fly"] = 209.62, ["Mega|Ride"] = 91.65, ["Mega|Fly|Ride"] = 141.16}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.05, ["Fly"] = 18.38, ["Ride"] = 15.75, ["Fly|Ride"] = 28.46, ["Neon"] = 9.19, ["Neon|Fly"] = 31.29, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 63.35, ["Mega"] = 65.63, ["Mega|Ride"] = 72.19, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 4.24, ["Ride"] = 18.97, ["Fly|Ride"] = 98.44, ["Neon"] = 39.38, ["Mega"] = 141.16}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 230.9, ["Ride"] = 272.47, ["Fly|Ride"] = 299.25, ["Neon|Ride"] = 1089.52, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Ride"] = 8426.18, ["Mega|Fly|Ride"] = 3543.75}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 4.57, ["Fly"] = 18.57, ["Ride"] = 18.38, ["Fly|Ride"] = 46.35, ["Neon"] = 28.46, ["Neon|Fly"] = 156.28, ["Neon|Ride"] = 32.67, ["Neon|Fly|Ride"] = 61.1, ["Mega"] = 286.02, ["Mega|Ride"] = 136.94, ["Mega|Fly|Ride"] = 229.69}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 5.22, ["Fly"] = 124.76, ["Ride"] = 39.38, ["Fly|Ride"] = 210.72, ["Neon"] = 31.5, ["Neon|Ride"] = 32.82, ["Mega"] = 251.35, ["Mega|Ride"] = 236.24, ["Mega|Fly|Ride"] = 416.06}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.05, ["Ride"] = 18.98, ["Neon"] = 4.08, ["Neon|Ride"] = 30.24, ["Neon|Fly|Ride"] = 84.28, ["Mega"] = 44.34, ["Mega|Ride"] = 95.7, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 18.34, ["Fly"] = 70.6, ["Ride"] = 23.33, ["Fly|Ride"] = 68.92, ["Neon"] = 87.05, ["Neon|Ride"] = 93.16, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 746.58, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 445.55}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 48.3, ["Ride"] = 96.47, ["Fly|Ride"] = 91.88, ["Neon"] = 90.56, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 164.69, ["Neon|Fly|Ride"] = 339.94, ["Mega"] = 420, ["Mega|Fly"] = 2211.88, ["Mega|Ride"] = 480.38, ["Mega|Fly|Ride"] = 588}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 20.06, ["Fly"] = 156.22, ["Ride"] = 43.32, ["Fly|Ride"] = 69.55, ["Neon"] = 131.25, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 141.16, ["Neon|Fly|Ride"] = 219.19, ["Mega|Ride"] = 783.12, ["Mega|Fly|Ride"] = 773.11}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 15.91, ["Ride"] = 18.66, ["Fly|Ride"] = 51.44, ["Neon"] = 2.1, ["Neon|Fly"] = 20.98, ["Neon|Ride"] = 18.88, ["Neon|Fly|Ride"] = 56.69, ["Mega"] = 17.49, ["Mega|Fly"] = 45.94, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 115.5}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 165.2, ["Fly"] = 252.86, ["Ride"] = 221.82, ["Fly|Ride"] = 313.69, ["Neon"] = 1123.5, ["Neon|Ride"] = 908.99, ["Neon|Fly|Ride"] = 935.31, ["Mega"] = 4106.71, ["Mega|Fly|Ride"] = 3651.71}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 24.25, ["Fly"] = 140.39, ["Ride"] = 43.63, ["Neon"] = 105, ["Neon|Ride"] = 141.16, ["Neon|Fly|Ride"] = 210, ["Mega"] = 419.95, ["Mega|Ride"] = 466.61, ["Mega|Fly|Ride"] = 562.46}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Ride"] = 28.46, ["Fly|Ride"] = 39.38, ["Neon"] = 6.15, ["Neon|Ride"] = 31.52, ["Mega"] = 40.04, ["Mega|Ride"] = 99.58, ["Mega|Fly|Ride"] = 280.19}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 25.3, ["Ride"] = 19.69, ["Fly|Ride"] = 70.82, ["Neon"] = 3.71, ["Neon|Fly"] = 46.61, ["Neon|Ride"] = 18.94, ["Neon|Fly|Ride"] = 97.23, ["Mega"] = 23.63, ["Mega|Fly"] = 138, ["Mega|Ride"] = 43.32, ["Mega|Fly|Ride"] = 109.67}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Ride"] = 23.55, ["Fly|Ride"] = 84.29, ["Neon"] = 11.6, ["Neon|Ride"] = 20.65, ["Neon|Fly|Ride"] = 7022.17, ["Mega"] = 92.93, ["Mega|Ride"] = 156.19, ["Mega|Fly|Ride"] = 281.24}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 12.49, ["Fly"] = 65.63, ["Ride"] = 23.16, ["Fly|Ride"] = 69.55, ["Neon"] = 42.15, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 93.28, ["Mega"] = 365.5, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 325.49}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 7.53, ["Ride"] = 31.49, ["Neon"] = 48.48, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 210, ["Mega|Ride"] = 265.44, ["Mega|Fly|Ride"] = 311.78}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 60.64, ["Fly|Ride"] = 70.6, ["Neon"] = 3.68, ["Neon|Ride"] = 42.15, ["Mega"] = 20.63, ["Mega|Ride"] = 62.98, ["Mega|Fly|Ride"] = 213.45}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 8.93, ["Ride"] = 27.57, ["Fly|Ride"] = 84.29, ["Neon"] = 24.94, ["Neon|Fly"] = 102.92, ["Neon|Ride"] = 52.48, ["Neon|Fly|Ride"] = 123.37, ["Mega"] = 141.16, ["Mega|Fly"] = 210.67, ["Mega|Ride"] = 188.55, ["Mega|Fly|Ride"] = 250.7}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 126.44, ["Neon"] = 4.67, ["Neon|Ride"] = 23.35, ["Neon|Fly|Ride"] = 156.32, ["Mega"] = 32.81, ["Mega|Ride"] = 91.34, ["Mega|Fly|Ride"] = 622.93}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.05, ["Fly"] = 26.54, ["Ride"] = 18.38, ["Fly|Ride"] = 45.94, ["Neon"] = 4.69, ["Neon|Fly"] = 42.15, ["Neon|Ride"] = 23.35, ["Neon|Fly|Ride"] = 124.69, ["Mega"] = 62.16, ["Mega|Fly"] = 99.02, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 774.38, ["Ride"] = 1048.69, ["Fly|Ride"] = 918.75, ["Neon|Fly|Ride"] = 4947.27, ["Mega|Fly|Ride"] = 15449.39}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 17.49, ["Fly|Ride"] = 32.75, ["Neon"] = 15.81, ["Neon|Fly"] = 44.61, ["Neon|Ride"] = 57.36, ["Neon|Fly|Ride"] = 56.59, ["Mega"] = 188.55, ["Mega|Ride"] = 210.67, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.8, ["Ride"] = 53.65, ["Fly|Ride"] = 132.57, ["Neon"] = 10.48, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 45.94, ["Mega|Ride"] = 104.9, ["Mega|Fly|Ride"] = 222.48}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 9.17, ["Fly"] = 35.84, ["Ride"] = 24.94, ["Fly|Ride"] = 48.3, ["Neon"] = 48.48, ["Neon|Fly"] = 112.74, ["Neon|Ride"] = 47.17, ["Neon|Fly|Ride"] = 116.82, ["Mega"] = 328.13, ["Mega|Ride"] = 287.7, ["Mega|Fly|Ride"] = 325.34}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 28.46, ["Ride"] = 16.87, ["Fly|Ride"] = 32.16, ["Neon"] = 6.83, ["Neon|Fly"] = 87.89, ["Neon|Ride"] = 21.84, ["Neon|Fly|Ride"] = 55.13, ["Mega"] = 77.96, ["Mega|Fly"] = 349.84, ["Mega|Ride"] = 91.65, ["Mega|Fly|Ride"] = 174.09}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 45.93, ["Neon"] = 334.87, ["Neon|Ride"] = 341.25, ["Mega"] = 896.44, ["Mega|Ride"] = 871.07, ["Mega|Fly|Ride"] = 983.77}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Fly"] = 33.72, ["Ride"] = 25.72, ["Fly|Ride"] = 702.72, ["Neon"] = 7.61, ["Neon|Ride"] = 36.87, ["Neon|Fly|Ride"] = 206.07, ["Mega"] = 73.6, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.63, ["Fly"] = 73.5, ["Ride"] = 20.57, ["Fly|Ride"] = 61.13, ["Neon"] = 13.05, ["Neon|Fly"] = 139.95, ["Neon|Ride"] = 31.61, ["Neon|Fly|Ride"] = 450.82, ["Mega"] = 131.25, ["Mega|Ride"] = 273, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly|Ride"] = 65.85, ["Neon"] = 15.72, ["Neon|Fly"] = 62.98, ["Mega"] = 112.23, ["Mega|Fly"] = 267.54}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.05, ["Fly"] = 16.87, ["Ride"] = 16.87, ["Fly|Ride"] = 70.6, ["Neon"] = 3.72, ["Neon|Fly"] = 28.88, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 92.42, ["Mega"] = 37.26, ["Mega|Fly"] = 420, ["Mega|Ride"] = 62.97, ["Mega|Fly|Ride"] = 163.7}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 17, ["Fly"] = 31.61, ["Ride"] = 23.62, ["Fly|Ride"] = 40.69, ["Neon"] = 137.82, ["Neon|Ride"] = 112.72, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 842.63, ["Mega|Ride"] = 521.38, ["Mega|Fly|Ride"] = 419.73}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 784.88, ["Ride"] = 787.5, ["Fly|Ride"] = 800.63, ["Neon"] = 1729.91, ["Neon|Ride"] = 2211.88, ["Neon|Fly|Ride"] = 1903.13, ["Mega"] = 7724.7, ["Mega|Ride"] = 4593.75, ["Mega|Fly|Ride"] = 5034.65}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 66.89, ["Ride"] = 16.87, ["Fly|Ride"] = 30.9, ["Neon"] = 7.88, ["Neon|Fly"] = 37.94, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 56.89, ["Mega"] = 37.94, ["Mega|Fly"] = 281.24, ["Mega|Ride"] = 78.07, ["Mega|Fly|Ride"] = 89.25}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 6.5, ["Ride"] = 32.87, ["Fly|Ride"] = 77.97, ["Neon"] = 52.5, ["Neon|Ride"] = 132.72, ["Neon|Fly|Ride"] = 337.05, ["Mega"] = 321.57, ["Mega|Ride"] = 351.75, ["Mega|Fly|Ride"] = 441}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 51.35, ["Ride"] = 83.24, ["Fly|Ride"] = 116.82, ["Neon|Ride"] = 379.19, ["Neon|Fly|Ride"] = 570.89, ["Mega"] = 2798.51, ["Mega|Fly|Ride"] = 2231.25}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 46.67, ["Fly"] = 141.19, ["Ride"] = 63.1, ["Fly|Ride"] = 301.88, ["Neon"] = 141.19, ["Neon|Ride"] = 177.19, ["Neon|Fly|Ride"] = 196.97, ["Mega"] = 828.94, ["Mega|Ride"] = 773.11, ["Mega|Fly|Ride"] = 800.49}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 15.33, ["Ride"] = 35.84, ["Neon"] = 70.6, ["Neon|Ride"] = 168.54, ["Neon|Fly|Ride"] = 281.24, ["Mega"] = 305.46, ["Mega|Ride"] = 407.64, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 61.77, ["Ride"] = 78.12, ["Neon"] = 80.05, ["Neon|Ride"] = 358.13, ["Mega"] = 325.29, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 421.32}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 26.22, ["Fly"] = 112.74, ["Ride"] = 315, ["Neon"] = 131.23, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 525, ["Mega"] = 652.98, ["Mega|Ride"] = 614.75, ["Mega|Fly|Ride"] = 836.73}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 21}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 4.68, ["Fly"] = 39.38, ["Ride"] = 21.08, ["Fly|Ride"] = 105, ["Neon"] = 57.75, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 70.59, ["Neon|Fly|Ride"] = 153.8, ["Mega"] = 216.18, ["Mega|Ride"] = 216.57, ["Mega|Fly|Ride"] = 320.25}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 3.49, ["Ride"] = 96.93, ["Neon"] = 27.01, ["Mega"] = 350.66, ["Mega|Fly|Ride"] = 947.96}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 43.79, ["Fly"] = 84, ["Ride"] = 77.44, ["Fly|Ride"] = 91.88, ["Neon"] = 311.85, ["Neon|Ride"] = 260.02, ["Neon|Fly|Ride"] = 227.07, ["Mega"] = 925.32, ["Mega|Ride"] = 773.07, ["Mega|Fly|Ride"] = 813.75}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.4, ["Fly"] = 24.83, ["Ride"] = 16.9, ["Fly|Ride"] = 30.87, ["Neon"] = 23.19, ["Neon|Fly"] = 60.8, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 82.17, ["Mega"] = 262.5, ["Mega|Fly"] = 238.06, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 220.39}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 6.22, ["Fly"] = 84.29, ["Ride"] = 19.69, ["Fly|Ride"] = 702.72, ["Neon"] = 22.91, ["Neon|Fly"] = 126.44, ["Neon|Ride"] = 51.19, ["Neon|Fly|Ride"] = 112.49, ["Mega"] = 162.23, ["Mega|Fly"] = 301.45, ["Mega|Ride"] = 156.32, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.05, ["Neon"] = 4.69, ["Neon|Ride"] = 199.48, ["Mega"] = 32.82, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 191.71}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 45.92, ["Fly"] = 84.29, ["Ride"] = 59, ["Fly|Ride"] = 77.15, ["Neon"] = 181.1, ["Neon|Ride"] = 238.06, ["Neon|Fly|Ride"] = 281.24, ["Mega"] = 1089.52, ["Mega|Ride"] = 825.82, ["Mega|Fly|Ride"] = 798.39}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 32.67, ["Fly|Ride"] = 139.08, ["Neon"] = 13.13, ["Neon|Fly"] = 145.69, ["Neon|Fly|Ride"] = 296.3, ["Mega"] = 141.16}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 11.79, ["Ride"] = 140.63, ["Neon"] = 81.03, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 294.93, ["Mega"] = 311.48, ["Mega|Ride"] = 466.61, ["Mega|Fly|Ride"] = 778.07}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 23.37, ["Ride"] = 18.69, ["Fly|Ride"] = 31.49, ["Neon"] = 21, ["Neon|Ride"] = 40.27, ["Neon|Fly|Ride"] = 93.19, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 314.35}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 3.92, ["Fly"] = 52.5, ["Ride"] = 24.94, ["Fly|Ride"] = 49.88, ["Neon"] = 52.5, ["Neon|Fly"] = 84.29, ["Neon|Ride"] = 126.41, ["Mega"] = 278.09, ["Mega|Ride"] = 184.33, ["Mega|Fly|Ride"] = 418.04}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 6.23, ["Ride"] = 139.08, ["Neon"] = 15.82, ["Neon|Ride"] = 111.57, ["Mega"] = 140.62, ["Mega|Ride"] = 547.98, ["Mega|Fly|Ride"] = 419.22}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 36.75, ["Ride"] = 101.43, ["Neon"] = 170.63, ["Neon|Ride"] = 316, ["Mega"] = 840, ["Mega|Fly|Ride"] = 958.13}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 17.49, ["Ride"] = 281.31, ["Neon"] = 182.6, ["Mega"] = 507.88, ["Mega|Ride"] = 563.07, ["Mega|Fly|Ride"] = 491.9}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 6.81, ["Ride"] = 105, ["Neon"] = 93.28, ["Neon|Ride"] = 393.75, ["Mega"] = 577.42, ["Mega|Ride"] = 555.09, ["Mega|Fly|Ride"] = 1685.24}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 24.9, ["Ride"] = 91.88, ["Fly|Ride"] = 419.78, ["Neon"] = 131.25, ["Neon|Ride"] = 631.98, ["Neon|Fly|Ride"] = 573.57, ["Mega"] = 766.8, ["Mega|Ride"] = 660.41, ["Mega|Fly|Ride"] = 702.55}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 3.62, ["Neon"] = 42.21, ["Neon|Ride"] = 421.32, ["Mega"] = 281.24, ["Mega|Fly|Ride"] = 311.48}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 25.3, ["Fly|Ride"] = 52.5, ["Neon"] = 8.44, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 137.82, ["Mega"] = 66.46, ["Mega|Fly"] = 210.67, ["Mega|Ride"] = 89.25, ["Mega|Fly|Ride"] = 258.57}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 13.13, ["Ride"] = 48.69, ["Fly|Ride"] = 91.32, ["Neon"] = 26.23, ["Neon|Ride"] = 89.25, ["Neon|Fly|Ride"] = 156.32, ["Mega"] = 154.81, ["Mega|Ride"] = 491.9, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 31.49, ["Ride"] = 23.62, ["Fly|Ride"] = 39.65, ["Neon"] = 5.25, ["Neon|Ride"] = 23.19, ["Neon|Fly|Ride"] = 84.28, ["Mega"] = 44.43, ["Mega|Fly"] = 116.67, ["Mega|Ride"] = 65.51, ["Mega|Fly|Ride"] = 194.81}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 3.91, ["Ride"] = 56.68, ["Fly|Ride"] = 42.15, ["Neon"] = 20.97, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 196.97, ["Mega"] = 210, ["Mega|Ride"] = 242.65, ["Mega|Fly|Ride"] = 466.61}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 2.61, ["Ride"] = 28.53, ["Fly|Ride"] = 99.75, ["Neon"] = 42.15, ["Neon|Ride"] = 97.76, ["Neon|Fly|Ride"] = 210.67, ["Mega"] = 466.61, ["Mega|Ride"] = 416.8, ["Mega|Fly|Ride"] = 933.2}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 4.96, ["Ride"] = 24.97, ["Fly|Ride"] = 70.6, ["Neon"] = 24.25, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 100.87, ["Mega"] = 303.36, ["Mega|Ride"] = 238.06, ["Mega|Fly|Ride"] = 306.85}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 3.94, ["Ride"] = 21.95, ["Fly|Ride"] = 62.98, ["Neon"] = 23.34, ["Neon|Fly"] = 84.29, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 105.34, ["Mega"] = 140.59, ["Mega|Ride"] = 141.16, ["Mega|Fly|Ride"] = 461.34}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 7.88, ["Fly"] = 301.88, ["Ride"] = 50.58, ["Fly|Ride"] = 86.28, ["Neon"] = 24.93, ["Neon|Fly"] = 131.24, ["Neon|Ride"] = 87.93, ["Neon|Fly|Ride"] = 197.14, ["Mega"] = 90.57, ["Mega|Ride"] = 305.82, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 13, ["Ride"] = 78.75, ["Fly|Ride"] = 275.63, ["Neon"] = 85.31, ["Neon|Fly"] = 218.07, ["Neon|Ride"] = 179.82, ["Neon|Fly|Ride"] = 233.16, ["Mega"] = 355.68, ["Mega|Fly"] = 1968.75, ["Mega|Ride"] = 431.82, ["Mega|Fly|Ride"] = 458.07}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 64.32, ["Fly"] = 202.85, ["Ride"] = 94.5, ["Fly|Ride"] = 281.31, ["Neon"] = 249.38, ["Neon|Ride"] = 195.57, ["Neon|Fly|Ride"] = 357.08, ["Mega"] = 918.75, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 975.18}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Ride"] = 21.08, ["Fly|Ride"] = 65.54, ["Neon"] = 3.68, ["Neon|Ride"] = 37.95, ["Neon|Fly|Ride"] = 58.35, ["Mega"] = 28.46, ["Mega|Ride"] = 71.14, ["Mega|Fly|Ride"] = 103.04}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 9.14, ["Ride"] = 337.14, ["Neon"] = 262.5, ["Mega"] = 419.22, ["Mega|Fly|Ride"] = 1263.93}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 45.75, ["Fly"] = 105, ["Ride"] = 116.6, ["Neon"] = 262.5, ["Neon|Ride"] = 341.25, ["Mega"] = 1090.16, ["Mega|Ride"] = 1095.42, ["Mega|Fly|Ride"] = 1263.93}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 7.35, ["Fly"] = 190.32, ["Ride"] = 32.82, ["Fly|Ride"] = 126, ["Neon"] = 48.86, ["Neon|Ride"] = 65.63, ["Mega"] = 123.06, ["Mega|Ride"] = 151.69, ["Mega|Fly|Ride"] = 419.35}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 2.1, ["Fly"] = 157.5, ["Ride"] = 31.49, ["Fly|Ride"] = 84.51, ["Neon"] = 3.93, ["Neon|Ride"] = 27.43, ["Mega"] = 23.35, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 40.67, ["Mega|Fly|Ride"] = 154.7}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 5.16, ["Fly"] = 39.38, ["Ride"] = 19.85, ["Fly|Ride"] = 47.25, ["Neon"] = 15.74, ["Neon|Fly"] = 421.42, ["Neon|Ride"] = 40.65, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 203.6, ["Mega|Fly"] = 351.12, ["Mega|Ride"] = 198.65, ["Mega|Fly|Ride"] = 231}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.05, ["Fly"] = 23, ["Ride"] = 18.66, ["Fly|Ride"] = 131.25, ["Neon"] = 2.63, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 42.15, ["Mega|Ride"] = 68.08, ["Mega|Fly|Ride"] = 111.57}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 15.82, ["Fly|Ride"] = 65.7, ["Neon"] = 2.63, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 71.37, ["Mega"] = 36.01, ["Mega|Fly"] = 168, ["Mega|Ride"] = 54.85, ["Mega|Fly|Ride"] = 172.66}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 2.1, ["Neon|Ride"] = 156.32, ["Mega"] = 21, ["Mega|Ride"] = 104.94, ["Mega|Fly|Ride"] = 257.01}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 4.35, ["Ride"] = 157.5, ["Fly|Ride"] = 358.21, ["Neon"] = 36.63, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 526.65, ["Mega"] = 196.97, ["Mega|Ride"] = 310.73, ["Mega|Fly|Ride"] = 624.1}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 6.46, ["Ride"] = 34.13, ["Fly|Ride"] = 310870.8, ["Neon"] = 84.29, ["Neon|Ride"] = 126.41, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 377.09, ["Mega|Ride"] = 418.67, ["Mega|Fly|Ride"] = 502.48}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 6.89, ["Fly"] = 20.03, ["Ride"] = 20.98, ["Fly|Ride"] = 44.01, ["Neon"] = 51.19, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 82.69, ["Mega|Ride"] = 323.36, ["Mega|Fly|Ride"] = 364.45}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 79.98, ["Ride"] = 91.87, ["Fly|Ride"] = 262.5, ["Neon"] = 538.13, ["Neon|Ride"] = 888.57, ["Mega"] = 3111.04, ["Mega|Fly|Ride"] = 1787.07}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 16.33, ["Fly"] = 72.43, ["Ride"] = 65.63, ["Fly|Ride"] = 112.74, ["Neon"] = 99.05, ["Mega"] = 617.53, ["Mega|Fly"] = 646.72, ["Mega|Ride"] = 603.75, ["Mega|Fly|Ride"] = 1029.67}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 17.93, ["Ride"] = 19.69, ["Fly|Ride"] = 30.19, ["Neon"] = 3.94, ["Neon|Fly"] = 33.72, ["Neon|Ride"] = 21.08, ["Neon|Fly|Ride"] = 69.47, ["Mega"] = 56, ["Mega|Ride"] = 107.45, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 15.86, ["Ride"] = 15.82, ["Fly|Ride"] = 28.46, ["Neon"] = 3.29, ["Neon|Fly"] = 26.17, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 42.31, ["Mega"] = 36.75, ["Mega|Fly"] = 70.59, ["Mega|Ride"] = 51.34, ["Mega|Fly|Ride"] = 72.13}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 311.27, ["Ride"] = 399, ["Fly|Ride"] = 564.38, ["Neon|Ride"] = 1443.75, ["Neon|Fly|Ride"] = 1522.5}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 24.66, ["Ride"] = 156.22, ["Fly|Ride"] = 141.19, ["Neon"] = 103.3, ["Neon|Fly|Ride"] = 400.26, ["Mega"] = 393.94, ["Mega|Ride"] = 450.82, ["Mega|Fly|Ride"] = 983.77}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 27.12, ["Ride"] = 16.02, ["Fly|Ride"] = 39.38, ["Neon"] = 5.2, ["Neon|Fly"] = 28.61, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 42.06, ["Mega"] = 42, ["Mega|Ride"] = 73.74, ["Mega|Fly|Ride"] = 89.59}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 70.86, ["Ride"] = 91.25, ["Fly|Ride"] = 281.31, ["Neon"] = 208.69, ["Neon|Ride"] = 316.31, ["Neon|Fly|Ride"] = 366.19, ["Mega"] = 734.99, ["Mega|Ride"] = 748.13, ["Mega|Fly|Ride"] = 824.73}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 4.04, ["Fly"] = 24.94, ["Ride"] = 21, ["Fly|Ride"] = 35.49, ["Neon"] = 11.7, ["Neon|Fly"] = 67.6, ["Neon|Ride"] = 25.3, ["Neon|Fly|Ride"] = 78.72, ["Mega"] = 145.37, ["Mega|Fly"] = 183.28, ["Mega|Ride"] = 115.27, ["Mega|Fly|Ride"] = 203.44}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 70.6, ["Ride"] = 39.38, ["Fly|Ride"] = 1312.5, ["Neon"] = 3.87, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 283.29, ["Mega"] = 17.8, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 62.99, ["Fly"] = 140.6, ["Ride"] = 105.36, ["Fly|Ride"] = 193.87, ["Neon"] = 126.44, ["Neon|Fly"] = 281.31, ["Neon|Ride"] = 201.2, ["Neon|Fly|Ride"] = 311.45, ["Mega"] = 557.19, ["Mega|Ride"] = 650.94, ["Mega|Fly|Ride"] = 809.82}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.63, ["Ride"] = 17.51, ["Fly|Ride"] = 39.38, ["Neon"] = 7.87, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 210.67, ["Mega"] = 92.54, ["Mega|Ride"] = 99.02, ["Mega|Fly|Ride"] = 160.13}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 35.32, ["Fly"] = 141.19, ["Ride"] = 82.04, ["Fly|Ride"] = 197.03, ["Neon"] = 168.57, ["Neon|Ride"] = 196.97, ["Neon|Fly|Ride"] = 330.74, ["Mega|Ride"] = 1571.5, ["Mega|Fly|Ride"] = 984.38}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 4.92, ["Ride"] = 109.6, ["Fly|Ride"] = 210.72, ["Neon"] = 28.38, ["Neon|Ride"] = 421.32, ["Mega"] = 147, ["Mega|Ride"] = 823.67, ["Mega|Fly|Ride"] = 544.04}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 3.29, ["Fly"] = 70.6, ["Ride"] = 70.6, ["Neon"] = 12.48, ["Neon|Fly"] = 63.23, ["Neon|Ride"] = 171.94, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 131.08, ["Mega|Ride"] = 569.63, ["Mega|Fly|Ride"] = 562.46}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 24.18, ["Ride"] = 55.69, ["Fly|Ride"] = 117.93, ["Neon|Ride"] = 210, ["Mega|Ride"] = 1040.65, ["Mega|Fly|Ride"] = 1040.65}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 131.67, ["Ride"] = 65.63, ["Fly|Ride"] = 908.98, ["Neon"] = 5.25, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 155.9, ["Mega"] = 47.57, ["Mega|Fly"] = 158.61, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 277.52}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 45.56, ["Ride"] = 19.59, ["Fly|Ride"] = 72.19, ["Neon"] = 6.2, ["Neon|Fly"] = 41.88, ["Neon|Ride"] = 28.46, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 105.59, ["Mega|Fly|Ride"] = 278.92}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 15.7, ["Ride"] = 39.65, ["Fly|Ride"] = 62.18, ["Neon"] = 68.25, ["Neon|Ride"] = 118.34, ["Mega"] = 262.5, ["Mega|Ride"] = 450.82, ["Mega|Fly|Ride"] = 377.99}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 28.88, ["Ride"] = 65.63, ["Fly|Ride"] = 197.88, ["Neon"] = 131.12, ["Neon|Ride"] = 148.42, ["Neon|Fly|Ride"] = 275.1, ["Mega"] = 570.93, ["Mega|Ride"] = 695.18, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 23.34, ["Fly"] = 30.17, ["Ride"] = 35.4, ["Fly|Ride"] = 77.44, ["Neon"] = 103.67, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 110.25, ["Neon|Fly|Ride"] = 222.89, ["Mega"] = 622.93, ["Mega|Ride"] = 525.6, ["Mega|Fly|Ride"] = 422.63}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 60.38, ["Fly"] = 196.88, ["Ride"] = 118.13, ["Fly|Ride"] = 144.38, ["Neon"] = 341.25, ["Neon|Ride"] = 288.75, ["Neon|Fly|Ride"] = 421.32, ["Mega"] = 1447.21, ["Mega|Ride"] = 1175.46, ["Mega|Fly|Ride"] = 1177.58}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 3.71, ["Ride"] = 39.64, ["Fly|Ride"] = 262.5, ["Neon"] = 33.59, ["Neon|Ride"] = 141.16, ["Neon|Fly|Ride"] = 305.76, ["Mega"] = 156.32, ["Mega|Ride"] = 280.19, ["Mega|Fly|Ride"] = 328.79}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 5.28, ["Ride"] = 21, ["Fly|Ride"] = 69.55, ["Neon"] = 18.38, ["Neon|Ride"] = 70.59, ["Neon|Fly|Ride"] = 196.97, ["Mega"] = 155.9, ["Mega|Ride"] = 175.88, ["Mega|Fly|Ride"] = 351.81}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 12.66, ["Fly"] = 105, ["Ride"] = 31.49, ["Fly|Ride"] = 109.6, ["Neon"] = 124.34, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 464.51, ["Mega|Fly|Ride"] = 773.11}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.74, ["Ride"] = 14.84, ["Fly|Ride"] = 36.89, ["Neon"] = 2.1, ["Neon|Fly"] = 17.07, ["Neon|Ride"] = 15.82, ["Neon|Fly|Ride"] = 41.79, ["Mega"] = 15.75, ["Mega|Fly"] = 70.59, ["Mega|Ride"] = 33.72, ["Mega|Fly|Ride"] = 78.17}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 47.5, ["Fly"] = 125.39, ["Ride"] = 124.76, ["Fly|Ride"] = 303.01, ["Neon"] = 223.13, ["Neon|Fly"] = 2388.36, ["Neon|Ride"] = 291.37, ["Neon|Fly|Ride"] = 460.78, ["Mega"] = 3090.31, ["Mega|Fly"] = 962.7, ["Mega|Ride"] = 956.53, ["Mega|Fly|Ride"] = 976.91}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 19.09, ["Fly|Ride"] = 109.58, ["Neon"] = 5.96, ["Neon|Ride"] = 42.2, ["Mega"] = 94.81, ["Mega|Fly|Ride"] = 210.67}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 28.3, ["Ride"] = 22.32, ["Fly|Ride"] = 69.55, ["Neon"] = 21.08, ["Neon|Fly"] = 141.19, ["Neon|Ride"] = 28.58, ["Neon|Fly|Ride"] = 63, ["Mega"] = 157.5, ["Mega|Ride"] = 265.44, ["Mega|Fly|Ride"] = 246.1}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 91.6, ["Ride"] = 122.07, ["Fly|Ride"] = 196.88, ["Neon"] = 275.52, ["Neon|Ride"] = 326.82, ["Neon|Fly|Ride"] = 511.88, ["Mega"] = 958.13, ["Mega|Ride"] = 917.44, ["Mega|Fly|Ride"] = 1010.63}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.05, ["Ride"] = 42.4, ["Neon"] = 4.36, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 106.16, ["Mega"] = 51.19, ["Mega|Ride"] = 109.6, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 55.01}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 65.63, ["Fly|Ride"] = 262.47, ["Neon"] = 6.57, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 141.16, ["Mega"] = 44.37, ["Mega|Ride"] = 115.5, ["Mega|Fly|Ride"] = 1034.24}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 123.38, ["Ride"] = 189.65, ["Fly|Ride"] = 323.45, ["Neon"] = 622.9, ["Neon|Ride"] = 589.85, ["Neon|Fly|Ride"] = 735, ["Mega|Fly|Ride"] = 2513.12}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 3.93, ["Ride"] = 28.32, ["Neon"] = 23.24, ["Neon|Ride"] = 61.69, ["Mega"] = 173.25, ["Mega|Ride"] = 238.22, ["Mega|Fly|Ride"] = 419.35}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 210.72, ["Neon"] = 3.93, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 31.49, ["Mega|Ride"] = 98.57, ["Mega|Fly|Ride"] = 312.9}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 4.41, ["Ride"] = 30.85, ["Neon"] = 51.1, ["Neon|Ride"] = 112.88, ["Neon|Fly|Ride"] = 156.32, ["Mega"] = 389.73, ["Mega|Ride"] = 562.46, ["Mega|Fly|Ride"] = 622.93}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 8.39, ["Fly"] = 74.52, ["Ride"] = 28.34, ["Fly|Ride"] = 157.5, ["Neon"] = 59.07, ["Neon|Ride"] = 73.74, ["Neon|Fly|Ride"] = 280.19, ["Mega"] = 452.17, ["Mega|Ride"] = 392.44, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 28.29, ["Ride"] = 76.07, ["Fly|Ride"] = 280.26, ["Neon"] = 155.93, ["Neon|Ride"] = 186.65, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 638.29, ["Mega|Ride"] = 570.89, ["Mega|Fly|Ride"] = 444.88}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 128.58, ["Fly"] = 237.83, ["Ride"] = 165.38, ["Fly|Ride"] = 296.13, ["Neon"] = 560.49, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 568.68, ["Mega|Fly|Ride"] = 2159.07}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 6.57, ["Fly"] = 18.38, ["Ride"] = 19.69, ["Fly|Ride"] = 41.91, ["Neon"] = 61.1, ["Neon|Fly"] = 421.42, ["Neon|Ride"] = 41.97, ["Neon|Fly|Ride"] = 73.74, ["Mega|Ride"] = 421.32, ["Mega|Fly|Ride"] = 281.24}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 3.94, ["Fly"] = 131.23, ["Ride"] = 18.98, ["Fly|Ride"] = 131.25, ["Neon"] = 22.05, ["Neon|Ride"] = 35.69, ["Neon|Fly|Ride"] = 251.95, ["Mega"] = 137.82, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 419.78}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 9.17, ["Fly"] = 233.17, ["Ride"] = 70.6, ["Neon"] = 99.05, ["Neon|Ride"] = 132.5, ["Mega"] = 349.7, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 503.73}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 45.44, ["Fly"] = 65.63, ["Ride"] = 65.63, ["Fly|Ride"] = 177.19, ["Neon"] = 221.26, ["Neon|Ride"] = 229.63, ["Neon|Fly|Ride"] = 156.32, ["Mega"] = 954.29, ["Mega|Fly"] = 1123.85, ["Mega|Ride"] = 744.68, ["Mega|Fly|Ride"] = 744.68}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 19.69, ["Ride"] = 80.21, ["Neon"] = 126.74, ["Neon|Ride"] = 126.62, ["Mega"] = 599.16, ["Mega|Ride"] = 702.55, ["Mega|Fly|Ride"] = 747.84}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 262.5, ["Ride"] = 364.54, ["Neon"] = 2388.36, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1685.24, ["Mega|Fly|Ride"] = 4094.07}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 30.19, ["Ride"] = 38.07, ["Fly|Ride"] = 77.98, ["Neon"] = 262.5, ["Neon|Ride"] = 210.67, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1181.25, ["Mega|Ride"] = 775.22, ["Mega|Fly|Ride"] = 761.25}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.05, ["Fly"] = 17.05, ["Ride"] = 17.07, ["Fly|Ride"] = 77.44, ["Neon"] = 2.1, ["Neon|Ride"] = 18.98, ["Neon|Fly|Ride"] = 51.19, ["Mega"] = 18, ["Mega|Fly"] = 99.02, ["Mega|Ride"] = 52.68, ["Mega|Fly|Ride"] = 98.83}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 5.53, ["Ride"] = 59.07, ["Neon"] = 15.82, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 126.97, ["Mega"] = 132.72, ["Mega|Ride"] = 89.25, ["Mega|Fly|Ride"] = 491.54}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 3.12, ["Ride"] = 39.37, ["Neon"] = 25.3, ["Neon|Ride"] = 77.8, ["Neon|Fly|Ride"] = 1181.25, ["Mega"] = 139.91, ["Mega|Fly"] = 239.11, ["Mega|Ride"] = 281.24, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 367.5, ["Fly"] = 622.54, ["Ride"] = 367.37, ["Fly|Ride"] = 465.94, ["Neon"] = 1401.21, ["Neon|Fly"] = 1826.84, ["Neon|Ride"] = 1405.08, ["Neon|Fly|Ride"] = 1405.08, ["Mega|Ride"] = 6319.64, ["Mega|Fly|Ride"] = 5033.44}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.63, ["Fly"] = 39.38, ["Ride"] = 18.27, ["Fly|Ride"] = 42.21, ["Neon"] = 141.19, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 71.18, ["Mega|Ride"] = 223.12, ["Mega|Fly|Ride"] = 685.13}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 3.83, ["Fly"] = 31.39, ["Ride"] = 19.69, ["Fly|Ride"] = 52.69, ["Neon|Ride"] = 56.64, ["Neon|Fly|Ride"] = 141.16, ["Mega|Ride"] = 702.55, ["Mega|Fly|Ride"] = 209.87}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 4.68, ["Fly"] = 26.24, ["Ride"] = 27.56, ["Fly|Ride"] = 74.82, ["Neon"] = 19.69, ["Neon|Fly"] = 105, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 129.41, ["Mega"] = 126.18, ["Mega|Ride"] = 110.83, ["Mega|Fly|Ride"] = 328.63}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 32.01, ["Fly"] = 210, ["Ride"] = 36.89, ["Fly|Ride"] = 65.63, ["Neon"] = 118.13, ["Neon|Ride"] = 252.8, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 459.38, ["Mega|Ride"] = 562.46, ["Mega|Fly|Ride"] = 601.43}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.63, ["Fly"] = 62.76, ["Ride"] = 28.4, ["Fly|Ride"] = 73.77, ["Neon"] = 18.12, ["Neon|Ride"] = 114.19, ["Neon|Fly|Ride"] = 210, ["Mega"] = 137.82, ["Mega|Ride"] = 140.01, ["Mega|Fly|Ride"] = 310.73}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 5.25, ["Fly"] = 104.15, ["Ride"] = 24.94, ["Fly|Ride"] = 78.75, ["Neon"] = 153.04, ["Neon|Ride"] = 106.32, ["Mega"] = 702.55, ["Mega|Ride"] = 311.48, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 49.53, ["Neon"] = 6.56, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 53.68, ["Mega|Ride"] = 46.59, ["Mega|Fly|Ride"] = 252.8}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 15.65, ["Ride"] = 69.57, ["Neon"] = 70.6, ["Mega"] = 317.61, ["Mega|Fly|Ride"] = 6319.64}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 15.82, ["Ride"] = 141.19, ["Neon"] = 105.13, ["Mega"] = 265.44, ["Mega|Ride"] = 373.3, ["Mega|Fly|Ride"] = 524.73}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 15.8, ["Fly"] = 32.16, ["Ride"] = 24.44, ["Fly|Ride"] = 53.82, ["Neon"] = 61.82, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 52.68, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 407.64, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 377.22}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 165.67, ["Fly"] = 205.24, ["Ride"] = 192.92, ["Fly|Ride"] = 236.25, ["Neon"] = 847.73, ["Neon|Ride"] = 918.04, ["Neon|Fly|Ride"] = 679.88, ["Mega|Fly|Ride"] = 4641}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 3.84, ["Ride"] = 16.94, ["Fly|Ride"] = 45.94, ["Neon"] = 15.82, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 111.25, ["Mega"] = 220.5, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 2.1, ["Ride"] = 26.83, ["Fly|Ride"] = 103.67, ["Neon"] = 11.82, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 166.69, ["Mega"] = 170.63, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 410.82}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 32.82, ["Ride"] = 83.94, ["Fly|Ride"] = 526.78, ["Neon"] = 65.63, ["Neon|Ride"] = 247.53, ["Neon|Fly|Ride"] = 421.32, ["Mega"] = 254.63, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 492.19}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 66.35, ["Fly"] = 168.57, ["Ride"] = 132.77, ["Fly|Ride"] = 167.16, ["Neon"] = 463.32, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 393.75, ["Mega|Ride"] = 1791.57, ["Mega|Fly|Ride"] = 1396.64}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 33.44, ["Ride"] = 90.57, ["Fly|Ride"] = 223.13, ["Neon"] = 85.32, ["Neon|Ride"] = 183.28, ["Neon|Fly|Ride"] = 210.67, ["Mega"] = 253.31, ["Mega|Ride"] = 319.59, ["Mega|Fly|Ride"] = 437.73}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 19.69, ["Fly|Ride"] = 58.7, ["Neon"] = 15.82, ["Mega"] = 124.85, ["Mega|Ride"] = 183.28, ["Mega|Fly|Ride"] = 351.81}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 25.3, ["Ride"] = 65.63, ["Fly|Ride"] = 9130.93, ["Neon"] = 68.23, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 141.16, ["Mega"] = 133.77, ["Mega|Ride"] = 156.16, ["Mega|Fly|Ride"] = 294.67}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 76.13, ["Ride"] = 138.03, ["Fly|Ride"] = 221.82, ["Neon"] = 167.21, ["Neon|Ride"] = 242.81, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 486.94, ["Mega|Ride"] = 446.25, ["Mega|Fly|Ride"] = 597.19}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.3, ["Ride"] = 72.18, ["Neon"] = 7.45, ["Neon|Fly"] = 37.94, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 150.56, ["Mega"] = 36.75, ["Mega|Fly"] = 155.9, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 10.49, ["Ride"] = 281.31, ["Fly|Ride"] = 59.07, ["Neon"] = 81.78, ["Neon|Ride"] = 162.23, ["Mega"] = 343.39, ["Mega|Ride"] = 419.22, ["Mega|Fly|Ride"] = 674.1}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 997.49, ["Fly"] = 1351.68, ["Ride"] = 945, ["Fly|Ride"] = 958.13, ["Neon"] = 3343.92, ["Neon|Ride"] = 3368.38, ["Neon|Fly|Ride"] = 2525.25, ["Mega|Fly|Ride"] = 10368.75}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 29.61, ["Ride"] = 111.56, ["Fly|Ride"] = 223.36, ["Neon"] = 155.61, ["Neon|Ride"] = 310.73, ["Neon|Fly|Ride"] = 421.32, ["Mega"] = 618.29, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 8.07, ["Fly"] = 42.15, ["Ride"] = 33.72, ["Fly|Ride"] = 419.73, ["Neon"] = 9.34, ["Neon|Fly"] = 192.82, ["Neon|Ride"] = 53.67, ["Neon|Fly|Ride"] = 126.41, ["Mega"] = 93.4, ["Mega|Ride"] = 145.37, ["Mega|Fly|Ride"] = 219.19}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 21.08, ["Ride"] = 131.22, ["Neon"] = 104.94, ["Mega"] = 365.5, ["Mega|Ride"] = 407.64, ["Mega|Fly|Ride"] = 778.07}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 30.57, ["Fly|Ride"] = 421.42, ["Neon"] = 2.63, ["Neon|Ride"] = 28.34, ["Neon|Fly|Ride"] = 78.11, ["Mega"] = 18.35, ["Mega|Fly"] = 125.36, ["Mega|Ride"] = 54.78, ["Mega|Fly|Ride"] = 141.16}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 97.13, ["Ride"] = 164.36, ["Fly|Ride"] = 334.6, ["Neon"] = 210, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 476.44, ["Mega"] = 1045.59, ["Mega|Ride"] = 1092.12, ["Mega|Fly|Ride"] = 1023.74}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 4.82, ["Fly"] = 101.07, ["Ride"] = 82.31, ["Fly|Ride"] = 69.54, ["Neon"] = 28.46, ["Neon|Ride"] = 84.28, ["Mega"] = 349.7, ["Mega|Ride"] = 262.39, ["Mega|Fly|Ride"] = 296.63}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 3.52, ["Ride"] = 27.41, ["Neon"] = 15.54, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 141.16, ["Mega"] = 147, ["Mega|Ride"] = 239.11, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 52.5, ["Fly"] = 105.94, ["Ride"] = 124.69, ["Fly|Ride"] = 150.03, ["Neon"] = 152.25, ["Neon|Fly"] = 281.31, ["Neon|Ride"] = 218.14, ["Neon|Fly|Ride"] = 466.61, ["Mega"] = 523.69, ["Mega|Ride"] = 466.61, ["Mega|Fly|Ride"] = 536.82}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 15.74, ["Ride"] = 52.5, ["Fly|Ride"] = 121.75, ["Neon"] = 115.5, ["Neon|Ride"] = 139.06, ["Neon|Fly|Ride"] = 315, ["Mega"] = 519.41, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 65.63, ["Ride"] = 140.63, ["Neon"] = 774.38, ["Neon|Ride"] = 842.63, ["Neon|Fly|Ride"] = 928.6, ["Mega"] = 2527.86, ["Mega|Ride"] = 1405.08, ["Mega|Fly|Ride"] = 2062.32}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 9.19, ["Ride"] = 56.43, ["Neon"] = 16.86, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 91.65, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 273.87}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 9.22, ["Fly"] = 196.88, ["Ride"] = 19.69, ["Fly|Ride"] = 56.44, ["Neon"] = 141.12, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 277.03, ["Mega"] = 354.36, ["Mega|Ride"] = 392.44, ["Mega|Fly|Ride"] = 702.55}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 115.5, ["Ride"] = 164.07, ["Fly|Ride"] = 223.13, ["Neon"] = 562.59, ["Neon|Ride"] = 532.86, ["Neon|Fly|Ride"] = 631.98, ["Mega|Fly"] = 2809.09, ["Mega|Ride"] = 2361.19, ["Mega|Fly|Ride"] = 1903.13}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 3.92, ["Fly"] = 39.38, ["Ride"] = 17.07, ["Fly|Ride"] = 35.2, ["Neon"] = 11.46, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 24.44, ["Neon|Fly|Ride"] = 77.35, ["Mega|Ride"] = 136.39, ["Mega|Fly|Ride"] = 208.17}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 5.25, ["Fly"] = 87.94, ["Ride"] = 31.5, ["Fly|Ride"] = 84, ["Neon"] = 23.62, ["Neon|Ride"] = 49.61, ["Neon|Fly|Ride"] = 78.17, ["Mega"] = 220.5, ["Mega|Ride"] = 183.43, ["Mega|Fly|Ride"] = 243.32}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 16.79, ["Fly|Ride"] = 35.95, ["Neon"] = 2.1, ["Neon|Fly"] = 35.6, ["Neon|Ride"] = 17.12, ["Neon|Fly|Ride"] = 48.49, ["Mega"] = 13.71, ["Mega|Fly"] = 32.67, ["Mega|Ride"] = 31.49, ["Mega|Fly|Ride"] = 96.87}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 31.62, ["Neon"] = 3.94, ["Neon|Fly"] = 42.15, ["Mega"] = 24.22, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 62.92, ["Mega|Fly|Ride"] = 138.8}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 3.82, ["Fly"] = 132.12, ["Ride"] = 71.37, ["Fly|Ride"] = 492.01, ["Neon"] = 28.46, ["Neon|Ride"] = 66.38, ["Mega"] = 126.41, ["Mega|Ride"] = 152.3}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 55.95, ["Ride"] = 315, ["Neon"] = 229.64, ["Neon|Ride"] = 452.82, ["Neon|Fly|Ride"] = 630, ["Mega"] = 534.02, ["Mega|Ride"] = 562.46, ["Mega|Fly|Ride"] = 542.46}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 3.15, ["Fly"] = 23.94, ["Ride"] = 18.54, ["Fly|Ride"] = 35.17, ["Neon"] = 18.36, ["Neon|Fly"] = 42.15, ["Neon|Ride"] = 26.13, ["Neon|Fly|Ride"] = 56.43, ["Mega"] = 111.57, ["Mega|Fly"] = 164.06, ["Mega|Ride"] = 168.54, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 3.2, ["Fly"] = 37.09, ["Ride"] = 24.9, ["Fly|Ride"] = 49.88, ["Neon"] = 23.19, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 27.2, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 125.98, ["Mega|Fly"] = 281.24, ["Mega|Ride"] = 113.12, ["Mega|Fly|Ride"] = 182.76}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Ride"] = 18.06, ["Fly|Ride"] = 78.75, ["Neon"] = 9.19, ["Neon|Fly"] = 46.66, ["Neon|Ride"] = 27.4, ["Neon|Fly|Ride"] = 107.04, ["Mega"] = 54.85, ["Mega|Fly"] = 144.48, ["Mega|Ride"] = 65.62, ["Mega|Fly|Ride"] = 156.32}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 12.49, ["Fly"] = 280.26, ["Ride"] = 26.24, ["Neon"] = 31.42, ["Neon|Ride"] = 83.22, ["Neon|Fly|Ride"] = 155.16, ["Mega"] = 233.31, ["Mega|Fly"] = 291.63, ["Mega|Ride"] = 240.16, ["Mega|Fly|Ride"] = 622.93}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 2.61, ["Fly"] = 153.83, ["Neon"] = 46.92, ["Neon|Ride"] = 49.51, ["Mega"] = 437.07, ["Mega|Ride"] = 562.46, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 3.84, ["Fly"] = 34.73, ["Ride"] = 20.98, ["Fly|Ride"] = 54.8, ["Neon"] = 27.01, ["Neon|Fly"] = 196.65, ["Neon|Ride"] = 46.68, ["Neon|Fly|Ride"] = 105, ["Mega"] = 173.78, ["Mega|Ride"] = 279.95, ["Mega|Fly|Ride"] = 338.63}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.63, ["Ride"] = 16.79, ["Fly|Ride"] = 35.84, ["Neon"] = 15.25, ["Neon|Fly"] = 84.29, ["Neon|Ride"] = 30.34, ["Neon|Fly|Ride"] = 63.37, ["Mega"] = 141.16, ["Mega|Ride"] = 234.71, ["Mega|Fly|Ride"] = 223.6}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 196.24, ["Fly"] = 393.75, ["Ride"] = 210, ["Fly|Ride"] = 421.42, ["Neon"] = 942.93, ["Neon|Ride"] = 933.2, ["Neon|Fly|Ride"] = 1179.94, ["Mega"] = 3512.67, ["Mega|Fly|Ride"] = 3665.4}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 5.4, ["Ride"] = 30.33, ["Neon"] = 30.19, ["Neon|Fly|Ride"] = 281.24, ["Mega"] = 123.38, ["Mega|Ride"] = 209.9, ["Mega|Fly|Ride"] = 491.9}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 5.23, ["Ride"] = 24.23, ["Fly|Ride"] = 105, ["Neon"] = 22.42, ["Neon|Ride"] = 48.46, ["Neon|Fly|Ride"] = 139.65, ["Mega"] = 203.44, ["Mega|Ride"] = 233.31, ["Mega|Fly|Ride"] = 1166.5}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 3.89, ["Fly|Ride"] = 156.22, ["Neon"] = 31.46, ["Neon|Fly|Ride"] = 631.98, ["Mega"] = 421.32, ["Mega|Ride"] = 411.84, ["Mega|Fly|Ride"] = 1007.35}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.91, ["Fly|Ride"] = 35.66, ["Neon"] = 2.1, ["Neon|Fly"] = 19.69, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 35.44, ["Mega"] = 18.38, ["Mega|Ride"] = 31.52, ["Mega|Fly|Ride"] = 67.29}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.63, ["Fly"] = 56.16, ["Ride"] = 19.69, ["Fly|Ride"] = 49.53, ["Neon"] = 11.78, ["Neon|Ride"] = 27.91, ["Neon|Fly|Ride"] = 99.49, ["Mega"] = 131.25, ["Mega|Ride"] = 142.96, ["Mega|Fly|Ride"] = 258.57}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 3.94, ["Ride"] = 35.84, ["Neon"] = 12.9, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 52.5, ["Mega|Ride"] = 141.16, ["Mega|Fly|Ride"] = 450.19}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 82.17, ["Fly"] = 185.43, ["Ride"] = 88.77, ["Fly|Ride"] = 154.87, ["Neon"] = 296.2, ["Neon|Ride"] = 410.81, ["Neon|Fly|Ride"] = 618.29, ["Mega|Ride"] = 3512.67, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 3.19, ["Fly"] = 85.32, ["Ride"] = 42, ["Fly|Ride"] = 65.54, ["Neon"] = 22.32, ["Neon|Ride"] = 54.78, ["Neon|Fly|Ride"] = 311.48, ["Mega"] = 208.81, ["Mega|Fly|Ride"] = 233.31}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 31.62, ["Ride"] = 52.5, ["Fly|Ride"] = 164.36, ["Neon"] = 5.8, ["Neon|Ride"] = 56.89, ["Neon|Fly|Ride"] = 167.89, ["Mega"] = 65.33, ["Mega|Fly"] = 410.79, ["Mega|Ride"] = 99.02, ["Mega|Fly|Ride"] = 225.42}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 58.8, ["Fly"] = 124.69, ["Ride"] = 109.58, ["Fly|Ride"] = 209.99, ["Neon"] = 131.25, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 332.07, ["Mega"] = 576.19, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 786.19}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 15.82, ["Ride"] = 15.82, ["Fly|Ride"] = 36.75, ["Neon"] = 2.1, ["Neon|Fly"] = 20.98, ["Neon|Ride"] = 16.78, ["Neon|Fly|Ride"] = 36.75, ["Mega"] = 19.67, ["Mega|Fly"] = 43.24, ["Mega|Ride"] = 31.77, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 36.89, ["Fly|Ride"] = 56.9, ["Neon"] = 4.23, ["Neon|Ride"] = 42.15, ["Neon|Fly|Ride"] = 99.02, ["Mega"] = 25.59, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 3.82, ["Ride"] = 156.22, ["Neon"] = 6.34, ["Neon|Ride"] = 56.89, ["Neon|Fly|Ride"] = 196.97, ["Mega"] = 56.43, ["Mega|Ride"] = 100.57}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 7.87, ["Fly"] = 133.82, ["Ride"] = 52.5, ["Fly|Ride"] = 126.44, ["Neon"] = 28.46, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 177.18, ["Mega"] = 139.99, ["Mega|Fly"] = 202.98, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 265.22}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 15.74, ["Ride"] = 15.75, ["Fly|Ride"] = 34.13, ["Neon"] = 2.1, ["Neon|Ride"] = 35.18, ["Neon|Fly|Ride"] = 62.16, ["Mega"] = 19.66, ["Mega|Ride"] = 31.5, ["Mega|Fly|Ride"] = 103.69}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 11.42, ["Ride"] = 41.99, ["Fly|Ride"] = 190.32, ["Neon"] = 60.65, ["Neon|Fly|Ride"] = 189.67, ["Mega"] = 239.11, ["Mega|Ride"] = 450.82, ["Mega|Fly|Ride"] = 283.5}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2887.5, ["Fly"] = 3150, ["Ride"] = 2737.49, ["Fly|Ride"] = 2690.63, ["Neon|Fly|Ride"] = 5512.5}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.05, ["Fly"] = 52.49, ["Ride"] = 18.94, ["Fly|Ride"] = 41.97, ["Neon"] = 5.24, ["Neon|Fly"] = 68.16, ["Neon|Ride"] = 27.4, ["Neon|Fly|Ride"] = 65.31, ["Mega"] = 78.17, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 142.38}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 6.57, ["Ride"] = 35.84, ["Neon"] = 11.24, ["Mega"] = 126, ["Mega|Ride"] = 437.07, ["Mega|Fly|Ride"] = 631.98}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 17.07, ["Ride"] = 32.82, ["Fly|Ride"] = 141.19, ["Neon"] = 103.69, ["Neon|Ride"] = 141.1, ["Neon|Fly|Ride"] = 141.16, ["Mega"] = 556.15, ["Mega|Ride"] = 446.6, ["Mega|Fly|Ride"] = 505.59}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 42.21, ["Ride"] = 78.75, ["Neon"] = 93.34, ["Mega"] = 737.3, ["Mega|Ride"] = 722.07, ["Mega|Fly|Ride"] = 727.83}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 138.76, ["Fly"] = 281.31, ["Ride"] = 156.22, ["Fly|Ride"] = 255.94, ["Neon"] = 1312.5, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 774.38, ["Neon|Fly|Ride"] = 800.63, ["Mega"] = 6319.64, ["Mega|Ride"] = 3019.74, ["Mega|Fly|Ride"] = 3391.4}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 5.44, ["Ride"] = 56.44, ["Fly|Ride"] = 675.94, ["Neon"] = 20.03, ["Neon|Fly"] = 70.6, ["Neon|Ride"] = 126.41, ["Neon|Fly|Ride"] = 104.94, ["Mega"] = 223.13, ["Mega|Fly"] = 139.99, ["Mega|Ride"] = 180.12, ["Mega|Fly|Ride"] = 253.32}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Neon"] = 14.43, ["Neon|Fly"] = 99.05, ["Neon|Ride"] = 42.15, ["Mega"] = 126.41, ["Mega|Ride"] = 261.03, ["Mega|Fly|Ride"] = 829.38}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.63, ["Fly"] = 101.94, ["Ride"] = 40.03, ["Fly|Ride"] = 118.13, ["Neon"] = 6.45, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 124.83, ["Mega"] = 67.43, ["Mega|Ride"] = 112.72, ["Mega|Fly|Ride"] = 252.8}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 12.92, ["Neon"] = 105.36, ["Neon|Ride"] = 1545.16, ["Neon|Fly|Ride"] = 294.93, ["Mega"] = 459.38, ["Mega|Ride"] = 420.27, ["Mega|Fly|Ride"] = 372.87}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 70.56, ["Neon"] = 2.1, ["Neon|Ride"] = 32.71, ["Mega"] = 15.75, ["Mega|Ride"] = 133.88, ["Mega|Fly|Ride"] = 252.8}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 82.69, ["Ride"] = 126.44, ["Fly|Ride"] = 130.59, ["Neon"] = 354.38, ["Neon|Ride"] = 353.07, ["Neon|Fly|Ride"] = 466.61, ["Mega|Ride"] = 1685.24, ["Mega|Fly|Ride"] = 1397.7}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 32.65, ["Neon"] = 6.36, ["Mega"] = 99.02, ["Mega|Ride"] = 112.29}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 37.8, ["Fly"] = 218.02, ["Ride"] = 76.13, ["Fly|Ride"] = 144.38, ["Neon"] = 265.92, ["Neon|Ride"] = 365.44, ["Neon|Fly|Ride"] = 421.62, ["Mega"] = 2625, ["Mega|Ride"] = 2809.09, ["Mega|Fly|Ride"] = 1156.32}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 33.72, ["Ride"] = 52.5, ["Fly|Ride"] = 49.88, ["Neon"] = 3.93, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 52.5, ["Mega|Ride"] = 65.62, ["Mega|Fly|Ride"] = 211.98}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.71, ["Ride"] = 27.41, ["Neon"] = 13.13, ["Neon|Ride"] = 109.55, ["Mega"] = 72.19, ["Mega|Ride"] = 166.49, ["Mega|Fly|Ride"] = 524.67}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 14.44, ["Ride"] = 210, ["Fly|Ride"] = 157.5, ["Neon"] = 62.92, ["Neon|Fly"] = 291.38, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 688.86, ["Mega"] = 233.31, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 920.57}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 333.52, ["Ride"] = 380.63, ["Fly|Ride"] = 472.5, ["Neon"] = 1048.69, ["Neon|Ride"] = 1141.88, ["Neon|Fly|Ride"] = 1181.25, ["Mega"] = 4059.81, ["Mega|Ride"] = 3806.25, ["Mega|Fly|Ride"] = 2520}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 34.13, ["Fly"] = 53.74, ["Ride"] = 39.38, ["Fly|Ride"] = 112.74, ["Neon"] = 233.23, ["Neon|Fly"] = 311.35, ["Neon|Ride"] = 158.1, ["Neon|Fly|Ride"] = 205.41, ["Mega|Ride"] = 694.12, ["Mega|Fly|Ride"] = 905.63}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 34.13, ["Ride"] = 17.51, ["Fly|Ride"] = 72.19, ["Neon"] = 7.28, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 83.94, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 281.24}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 15.54, ["Fly"] = 109.13, ["Ride"] = 36.12, ["Fly|Ride"] = 94.49, ["Neon"] = 35.4, ["Neon|Fly"] = 196.24, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 164.33, ["Mega"] = 215.25, ["Mega|Fly"] = 389.44, ["Mega|Ride"] = 263.33, ["Mega|Fly|Ride"] = 310.73}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 7.46, ["Ride"] = 31.62, ["Fly|Ride"] = 70.44, ["Neon"] = 105, ["Neon|Ride"] = 94.37, ["Mega|Ride"] = 466.46, ["Mega|Fly|Ride"] = 505.59}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 6.57, ["Neon"] = 18.96, ["Neon|Ride"] = 31.52, ["Mega"] = 62.88, ["Mega|Ride"] = 105}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.1, ["Fly"] = 86.63, ["Ride"] = 19.69, ["Fly|Ride"] = 66.12, ["Neon"] = 26.25, ["Neon|Ride"] = 28.46, ["Neon|Fly|Ride"] = 214.1, ["Mega"] = 544.77, ["Mega|Ride"] = 419.37, ["Mega|Fly|Ride"] = 491.9}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 98.44, ["Fly"] = 131.25, ["Ride"] = 122.13, ["Fly|Ride"] = 306.59, ["Neon"] = 984.01, ["Neon|Ride"] = 511.88, ["Neon|Fly|Ride"] = 666.32, ["Mega"] = 2387.78, ["Mega|Ride"] = 2556.3, ["Mega|Fly|Ride"] = 2696.39}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 23.63, ["Fly"] = 78.12, ["Ride"] = 62.97, ["Fly|Ride"] = 144, ["Neon"] = 157.5, ["Neon|Ride"] = 189.68, ["Mega"] = 695.18, ["Mega|Ride"] = 638.09, ["Mega|Fly|Ride"] = 730.98}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2668.36, ["Fly"] = 2349.23, ["Ride"] = 2809.77, ["Fly|Ride"] = 2413.68, ["Neon"] = 12642.34, ["Neon|Fly|Ride"] = 7583.57, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 2.1, ["Fly"] = 65625, ["Ride"] = 28.35, ["Fly|Ride"] = 170.63, ["Neon"] = 12.59, ["Neon|Ride"] = 35.69, ["Neon|Fly|Ride"] = 196.97, ["Mega"] = 104.97, ["Mega|Ride"] = 169.32, ["Mega|Fly|Ride"] = 369}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 18.98, ["Ride"] = 85.32, ["Fly|Ride"] = 141.75, ["Neon"] = 59.68, ["Mega"] = 150.94, ["Mega|Ride"] = 305.34, ["Mega|Fly|Ride"] = 466.6}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 918.75, ["Fly"] = 1301.01, ["Ride"] = 918.75, ["Fly|Ride"] = 1018.49, ["Neon"] = 4781.98, ["Neon|Ride"] = 4634.41, ["Neon|Fly|Ride"] = 4704.66, ["Mega|Fly|Ride"] = 15747.56}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 45.94, ["Ride"] = 66.09, ["Fly|Ride"] = 210.72, ["Neon"] = 232.84, ["Neon|Fly|Ride"] = 379.19, ["Mega"] = 840, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 702.55}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 2.1, ["Ride"] = 28.46, ["Fly|Ride"] = 128.09, ["Neon"] = 17.22, ["Neon|Ride"] = 73.48, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 194.92, ["Mega|Ride"] = 348.65, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 111.19, ["Neon"] = 4.23, ["Neon|Ride"] = 52.5, ["Mega"] = 26.38, ["Mega|Ride"] = 68.25, ["Mega|Fly|Ride"] = 126.41}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 91.76, ["Ride"] = 125.99, ["Neon"] = 702.72, ["Neon|Ride"] = 842.63, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 5250, ["Mega|Fly|Ride"] = 2527.86}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 5.23, ["Ride"] = 141.19, ["Fly|Ride"] = 91.88, ["Neon"] = 19.67, ["Neon|Ride"] = 93.34, ["Neon|Fly|Ride"] = 129.56, ["Mega"] = 202.98, ["Mega|Ride"] = 183.72, ["Mega|Fly|Ride"] = 311.07}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 57.75, ["Ride"] = 291.38, ["Neon"] = 513.09, ["Neon|Ride"] = 525, ["Mega"] = 2106.56, ["Mega|Fly|Ride"] = 1756.88}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 4.7, ["Fly"] = 105, ["Fly|Ride"] = 91.88, ["Neon"] = 32.82, ["Neon|Fly|Ride"] = 315, ["Mega"] = 223.31}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 237.57, ["Ride"] = 255.94, ["Fly|Ride"] = 341.25, ["Neon"] = 1089.11, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 1034.98, ["Mega|Fly|Ride"] = 3904.48}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 3.68, ["Fly"] = 28.32, ["Ride"] = 19.69, ["Fly|Ride"] = 105, ["Neon"] = 41.15, ["Neon|Ride"] = 48.57, ["Neon|Fly|Ride"] = 109.67, ["Mega"] = 250.04, ["Mega|Ride"] = 311.48, ["Mega|Fly|Ride"] = 419.83}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 18.15, ["Ride"] = 16.49, ["Fly|Ride"] = 41.99, ["Neon"] = 3.94, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 23.35, ["Neon|Fly|Ride"] = 45.62, ["Mega"] = 53.67, ["Mega|Fly"] = 98.44, ["Mega|Ride"] = 73.5, ["Mega|Fly|Ride"] = 120.08}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 790.52, ["Fly"] = 1110.44, ["Ride"] = 903, ["Fly|Ride"] = 787.5, ["Neon|Ride"] = 7724.7, ["Neon|Fly|Ride"] = 4213.1, ["Mega"] = 27995.65}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 7.88, ["Fly"] = 980.19, ["Ride"] = 42, ["Neon"] = 41.98, ["Neon|Ride"] = 69.84, ["Mega"] = 104.99, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 291.38}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 11.59, ["Fly"] = 47.25, ["Ride"] = 51.44, ["Fly|Ride"] = 84.29, ["Neon"] = 28.88, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 145.85, ["Mega"] = 144.37, ["Mega|Ride"] = 175.91, ["Mega|Fly|Ride"] = 288.62}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 51.18, ["Fly"] = 44.44, ["Ride"] = 46.34, ["Fly|Ride"] = 70.6, ["Neon|Ride"] = 142.21, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 2106.56, ["Mega|Fly|Ride"] = 861}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 15.09, ["Fly"] = 79.03, ["Ride"] = 31.49, ["Fly|Ride"] = 116.95, ["Neon"] = 59.06, ["Neon|Ride"] = 112.6, ["Neon|Fly|Ride"] = 163.32, ["Mega"] = 393.75, ["Mega|Ride"] = 278.81, ["Mega|Fly|Ride"] = 442.31}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 27.27, ["Ride"] = 65.63, ["Fly|Ride"] = 105, ["Neon"] = 108.81, ["Neon|Ride"] = 204.36, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 699.38, ["Mega|Ride"] = 496.11, ["Mega|Fly|Ride"] = 416.06}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 116.59, ["Fly|Ride"] = 233.17, ["Neon"] = 4.23, ["Neon|Ride"] = 31.61, ["Mega"] = 15.78, ["Mega|Ride"] = 141.16}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 28.67, ["Fly"] = 48.57, ["Ride"] = 47.2, ["Fly|Ride"] = 77.44, ["Neon"] = 270.26, ["Neon|Ride"] = 232.32, ["Neon|Fly|Ride"] = 242.82, ["Mega"] = 3370.48, ["Mega|Ride"] = 1053.29, ["Mega|Fly|Ride"] = 1103.85}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.1, ["Fly"] = 89.66, ["Ride"] = 27.56, ["Fly|Ride"] = 112.29, ["Neon"] = 42, ["Neon|Ride"] = 189.6, ["Neon|Fly|Ride"] = 141.16, ["Mega"] = 773.07, ["Mega|Ride"] = 271.69, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.63, ["Fly"] = 26.16, ["Ride"] = 20.2, ["Fly|Ride"] = 53.74, ["Neon"] = 35.35, ["Neon|Ride"] = 42.06, ["Neon|Fly|Ride"] = 124.83, ["Mega|Ride"] = 281.24, ["Mega|Fly|Ride"] = 203.44}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 2.9, ["Ride"] = 126, ["Neon"] = 26.25, ["Neon|Fly|Ride"] = 104.95, ["Mega"] = 294.93, ["Mega|Ride"] = 196.88}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 20.25, ["Fly"] = 262.13, ["Ride"] = 44.09, ["Fly|Ride"] = 196.88, ["Neon"] = 103.52, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 227.53, ["Mega"] = 773.11, ["Mega|Ride"] = 757.32, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 6.46, ["Neon"] = 21.84, ["Neon|Ride"] = 63.1, ["Mega"] = 104.82, ["Mega|Fly"] = 702.55, ["Mega|Fly|Ride"] = 311.48}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 27.41, ["Neon"] = 2.61, ["Neon|Ride"] = 31.52, ["Mega"] = 15.43, ["Mega|Ride"] = 51.19, ["Mega|Fly|Ride"] = 202.79}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Ride"] = 26.17, ["Neon"] = 2.63, ["Neon|Fly"] = 393.59, ["Neon|Ride"] = 26.25, ["Mega"] = 17.52, ["Mega|Fly"] = 73.86, ["Mega|Ride"] = 48.28, ["Mega|Fly|Ride"] = 141.16}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 36.75, ["Ride"] = 21.25, ["Fly|Ride"] = 39.38, ["Neon"] = 11.67, ["Neon|Fly"] = 141.19, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 84, ["Mega"] = 103.69, ["Mega|Ride"] = 112.72, ["Mega|Fly|Ride"] = 156.32}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.63, ["Ride"] = 26.25, ["Fly|Ride"] = 56.67, ["Neon"] = 19.69, ["Neon|Ride"] = 70.59, ["Mega"] = 140.63, ["Mega|Ride"] = 147.47, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.63, ["Fly"] = 26.18, ["Ride"] = 16.95, ["Fly|Ride"] = 31.5, ["Neon"] = 16.89, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 80.07, ["Mega"] = 281.54, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 361.59}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 62.92, ["Ride"] = 126.44, ["Fly|Ride"] = 394.03, ["Neon"] = 155.92, ["Neon|Ride"] = 407.64, ["Neon|Fly|Ride"] = 1053.29, ["Mega"] = 958.49, ["Mega|Fly"] = 942.69, ["Mega|Ride"] = 891.19, ["Mega|Fly|Ride"] = 866.25}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 26.3, ["Ride"] = 16.72, ["Fly|Ride"] = 31.62, ["Neon"] = 2.1, ["Neon|Fly"] = 28.49, ["Neon|Ride"] = 16.86, ["Neon|Fly|Ride"] = 56.89, ["Mega"] = 39.67, ["Mega|Ride"] = 46.68, ["Mega|Fly|Ride"] = 156.32}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 13.13, ["Fly"] = 31.44, ["Ride"] = 39.51, ["Fly|Ride"] = 56.79, ["Neon"] = 39.38, ["Neon|Fly"] = 98.6, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 105.34, ["Mega"] = 590.63, ["Mega|Ride"] = 313.83, ["Mega|Fly|Ride"] = 546.23}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 15.61, ["Fly"] = 62.98, ["Ride"] = 27.56, ["Fly|Ride"] = 48.48, ["Neon"] = 72.13, ["Neon|Ride"] = 73.5, ["Neon|Fly|Ride"] = 116.82, ["Mega"] = 1250.24, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 417.12}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 2.52, ["Fly"] = 140.38, ["Ride"] = 46.65, ["Neon"] = 19.45, ["Mega"] = 196.87, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 351.81}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 15.82, ["Fly|Ride"] = 140.65, ["Neon"] = 3.72, ["Neon|Fly"] = 59.07, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 64.32, ["Mega"] = 37.34, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 3.92, ["Ride"] = 26.24, ["Fly|Ride"] = 141.39, ["Neon"] = 11.96, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 100.08, ["Neon|Fly|Ride"] = 158.01, ["Mega"] = 99.02, ["Mega|Fly"] = 735, ["Mega|Ride"] = 142.21, ["Mega|Fly|Ride"] = 383.4}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 918.75, ["Fly"] = 1250.55, ["Ride"] = 918.75, ["Fly|Ride"] = 1023.75, ["Neon"] = 2718.12, ["Neon|Ride"] = 2228.63, ["Neon|Fly|Ride"] = 2278.5, ["Mega|Fly|Ride"] = 7434}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 65.62, ["Ride"] = 84.29, ["Fly|Ride"] = 118.13, ["Neon"] = 260.24, ["Neon|Ride"] = 316.31, ["Neon|Fly|Ride"] = 299.14, ["Mega"] = 2812.69, ["Mega|Ride"] = 1334.51, ["Mega|Fly|Ride"] = 1036.88}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Fly"] = 63.23, ["Neon"] = 5.25, ["Neon|Ride"] = 74.46, ["Neon|Fly|Ride"] = 99.02, ["Mega"] = 51.35, ["Mega|Fly|Ride"] = 156.32}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 30.87, ["Ride"] = 36.75, ["Fly|Ride"] = 252.86, ["Neon"] = 181.92, ["Neon|Ride"] = 192.94, ["Neon|Fly|Ride"] = 233.42, ["Mega"] = 1023.75, ["Mega|Ride"] = 993.25, ["Mega|Fly|Ride"] = 879.61}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 7.85, ["Ride"] = 27.01, ["Fly|Ride"] = 280.26, ["Neon"] = 40.05, ["Neon|Ride"] = 282.09, ["Neon|Fly|Ride"] = 63, ["Mega"] = 252, ["Mega|Fly|Ride"] = 1053.29}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 274.32, ["Fly"] = 301.88, ["Ride"] = 296.63, ["Fly|Ride"] = 561.75, ["Neon|Ride"] = 1263.93, ["Neon|Fly|Ride"] = 1111.69, ["Mega|Fly|Ride"] = 4354.24}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.59, ["Fly"] = 102.38, ["Ride"] = 22.32, ["Fly|Ride"] = 129.93, ["Neon"] = 19.29, ["Neon|Ride"] = 74.81, ["Mega"] = 393.75, ["Mega|Fly"] = 281.24}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Fly|Ride"] = 702.72, ["Neon"] = 31.62, ["Neon|Ride"] = 141.16, ["Mega"] = 281.24, ["Mega|Ride"] = 337.05}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 40.27, ["Ride"] = 104.31, ["Fly|Ride"] = 282.96, ["Neon"] = 131.25, ["Neon|Ride"] = 310.73, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 698.33, ["Mega|Ride"] = 713.35, ["Mega|Fly|Ride"] = 793.38}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 3.93, ["Ride"] = 48.49, ["Neon"] = 23.63, ["Mega"] = 223.31, ["Mega|Ride"] = 275.98}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 18, ["Ride"] = 16.87, ["Fly|Ride"] = 30.97, ["Neon"] = 2.63, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 33.72, ["Neon|Fly|Ride"] = 64.84, ["Mega"] = 42.08, ["Mega|Fly"] = 31.52, ["Mega|Ride"] = 40.43, ["Mega|Fly|Ride"] = 89.22}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4199.9, ["Ride"] = 4318.13, ["Fly|Ride"] = 3937.5, ["Neon"] = 15784.47, ["Neon|Ride"] = 26752.19, ["Neon|Fly|Ride"] = 19163.82, ["Mega|Fly|Ride"] = 87070.76}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["Ride"] = 35.84, ["Neon"] = 112.74, ["Neon|Ride"] = 141.16, ["Mega"] = 279.13, ["Mega|Ride"] = 389.62, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Ride"] = 19.67, ["Fly|Ride"] = 35.84, ["Neon"] = 15.74, ["Neon|Ride"] = 32.67, ["Neon|Fly|Ride"] = 70.14, ["Mega"] = 252.8, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 188.51}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 402.94, ["Fly"] = 521.52, ["Ride"] = 393.75, ["Fly|Ride"] = 488.85, ["Neon"] = 1259.16, ["Neon|Fly"] = 1455.57, ["Neon|Ride"] = 1594.69, ["Neon|Fly|Ride"] = 1538.99, ["Mega|Fly|Ride"] = 6039.47}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 4.99, ["Ride"] = 52.5, ["Neon"] = 17.07, ["Neon|Ride"] = 158.06, ["Mega"] = 141.16, ["Mega|Fly|Ride"] = 688.86}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 4.76, ["Fly"] = 99.37, ["Ride"] = 28.46, ["Fly|Ride"] = 105.36, ["Neon"] = 91.83, ["Neon|Ride"] = 281.24, ["Neon|Fly|Ride"] = 142.21, ["Mega"] = 354.38, ["Mega|Ride"] = 401.63}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 52.33, ["Ride"] = 28.35, ["Fly|Ride"] = 82.55, ["Neon"] = 7.66, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 64.32, ["Mega"] = 37.32, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 141.16}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 619.5, ["Ride"] = 582.75, ["Fly|Ride"] = 654.93, ["Neon|Fly|Ride"] = 1967.44, ["Mega|Fly|Ride"] = 8751.75}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 5.25, ["Ride"] = 52.5, ["Neon"] = 24.41, ["Neon|Ride"] = 108.94, ["Neon|Fly|Ride"] = 648.38, ["Mega"] = 150.94, ["Mega|Ride"] = 196.97, ["Mega|Fly|Ride"] = 257.01}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 11.6, ["Fly"] = 78.12, ["Ride"] = 68.25, ["Neon"] = 38.06, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 3890.24, ["Mega"] = 210, ["Mega|Ride"] = 214.89, ["Mega|Fly|Ride"] = 321.99}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.63, ["Fly"] = 23.19, ["Ride"] = 19.69, ["Neon"] = 17.07, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 87.94, ["Mega"] = 170.63, ["Mega|Ride"] = 158.82, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 40.32, ["Ride"] = 62.97, ["Neon"] = 99.05, ["Neon|Ride"] = 126.41, ["Neon|Fly|Ride"] = 296.3, ["Mega"] = 559.3, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 525.87}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Ride"] = 39.37, ["Neon"] = 3.93, ["Neon|Ride"] = 69.54, ["Neon|Fly|Ride"] = 2041.36, ["Mega"] = 19.67, ["Mega|Ride"] = 87.76, ["Mega|Fly|Ride"] = 177.19}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 439.41, ["Ride"] = 485.63, ["Fly|Ride"] = 618.43, ["Neon"] = 2080.73, ["Neon|Ride"] = 2087.59, ["Neon|Fly|Ride"] = 2331.5, ["Mega|Ride"] = 9098.59, ["Mega|Fly|Ride"] = 7848.75}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 56.9, ["Neon"] = 6.34, ["Neon|Ride"] = 99.02, ["Neon|Fly|Ride"] = 210.67, ["Mega"] = 59.07, ["Mega|Ride"] = 129.49, ["Mega|Fly|Ride"] = 168.54}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.05, ["Ride"] = 27.41, ["Neon"] = 3.93, ["Neon|Ride"] = 209.95, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 39.38, ["Mega|Ride"] = 83.22, ["Mega|Fly|Ride"] = 264.39}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 60.37, ["Neon"] = 3.71, ["Neon|Ride"] = 45.91, ["Mega"] = 36.09, ["Mega|Fly"] = 155.9, ["Mega|Ride"] = 105.34, ["Mega|Fly|Ride"] = 196.97}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 3.61, ["Ride"] = 131.25, ["Neon"] = 17.07, ["Mega"] = 110.83, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 38.59, ["Fly"] = 86.63, ["Ride"] = 66.39, ["Fly|Ride"] = 157.5, ["Neon"] = 223.13, ["Neon|Fly"] = 702.72, ["Neon|Ride"] = 246.48, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 657.25, ["Mega|Ride"] = 607.53, ["Mega|Fly|Ride"] = 518.22}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 15, ["Fly"] = 69.57, ["Ride"] = 63, ["Neon"] = 85.32, ["Neon|Ride"] = 140.51, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 262.5, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 16.92, ["Fly|Ride"] = 35.43, ["Neon"] = 27.57, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 76.13, ["Mega"] = 307.79, ["Mega|Ride"] = 357.08, ["Mega|Fly|Ride"] = 246.48}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 12.69, ["Ride"] = 52.47, ["Neon"] = 172.58, ["Neon|Ride"] = 158.82, ["Mega|Ride"] = 778.07, ["Mega|Fly|Ride"] = 543.51}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Ride"] = 32.67, ["Fly|Ride"] = 362.25, ["Neon"] = 17.07, ["Neon|Ride"] = 103.24, ["Mega"] = 94.81, ["Mega|Ride"] = 155.9, ["Mega|Fly|Ride"] = 243.32}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 17.07, ["Fly"] = 69.57, ["Ride"] = 31.46, ["Fly|Ride"] = 56.44, ["Neon"] = 249.62, ["Neon|Ride"] = 120.08, ["Neon|Fly|Ride"] = 125.93, ["Mega"] = 946.91, ["Mega|Ride"] = 933.2, ["Mega|Fly|Ride"] = 699.57}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 70.59, ["Fly"] = 874.13, ["Ride"] = 141.19, ["Neon"] = 131.25, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 42, ["Fly"] = 115.5, ["Ride"] = 93.09, ["Fly|Ride"] = 134.92, ["Neon"] = 284.76, ["Neon|Fly"] = 348.04, ["Neon|Ride"] = 299.23, ["Neon|Fly|Ride"] = 391.65, ["Mega"] = 1081.73, ["Mega|Ride"] = 1323.24, ["Mega|Fly|Ride"] = 1148.07}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 49.88, ["Fly"] = 141.19, ["Ride"] = 99.05, ["Neon"] = 191.76, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 288.62, ["Mega"] = 653.24, ["Mega|Ride"] = 667.79, ["Mega|Fly|Ride"] = 612.94}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 19.26, ["Ride"] = 65.62, ["Neon"] = 157.5, ["Neon|Ride"] = 223.13, ["Mega"] = 557.19, ["Mega|Ride"] = 1081.73, ["Mega|Fly|Ride"] = 1262.88}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 6.35, ["Fly"] = 27.41, ["Ride"] = 31.49, ["Fly|Ride"] = 96.55, ["Neon"] = 42.15, ["Neon|Fly"] = 168.57, ["Neon|Ride"] = 99.02, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 467.77, ["Mega|Ride"] = 319.85, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 28.46, ["Ride"] = 16.87, ["Fly|Ride"] = 41.98, ["Neon"] = 4.6, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 25.3, ["Neon|Fly|Ride"] = 57.75, ["Mega"] = 42.15, ["Mega|Fly"] = 702.55, ["Mega|Ride"] = 63, ["Mega|Fly|Ride"] = 184.33}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 917.44}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 27.2, ["Ride"] = 118.13, ["Fly|Ride"] = 196.88, ["Neon"] = 129.6, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 419.95, ["Mega"] = 562.46, ["Mega|Ride"] = 544.69, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 39.63, ["Neon"] = 3.29, ["Neon|Ride"] = 36.74, ["Neon|Fly|Ride"] = 293.86, ["Mega"] = 33.03, ["Mega|Ride"] = 84.96, ["Mega|Fly|Ride"] = 535.43}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 27.57, ["Ride"] = 65.63, ["Fly|Ride"] = 273.93, ["Neon"] = 131.25, ["Neon|Ride"] = 526.65, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 630, ["Mega|Ride"] = 815.26, ["Mega|Fly|Ride"] = 557.82}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 5.25, ["Neon|Ride"] = 19.69, ["Mega"] = 32.67}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 4.67, ["Neon|Ride"] = 156.32, ["Mega"] = 21.05, ["Mega|Ride"] = 120.08, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 90.57, ["Ride"] = 141.19, ["Fly|Ride"] = 214.93, ["Neon"] = 597.19, ["Neon|Ride"] = 560.35, ["Neon|Fly|Ride"] = 630.75, ["Mega|Ride"] = 6415.68, ["Mega|Fly|Ride"] = 2034.38}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.63, ["Fly"] = 64.32, ["Ride"] = 23.03, ["Neon"] = 11.43, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 91.88, ["Mega|Ride"] = 91.65, ["Mega|Fly|Ride"] = 255.48}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 34.33, ["Fly|Ride"] = 86.63, ["Neon"] = 3.94, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 419.99, ["Mega"] = 36.75, ["Mega|Ride"] = 93.11, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Fly"] = 42, ["Ride"] = 28.46, ["Neon"] = 3.89, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 99.02, ["Mega"] = 26.84, ["Mega|Ride"] = 70.3, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.05, ["Ride"] = 18.98, ["Neon"] = 4.08, ["Neon|Ride"] = 30.24, ["Neon|Fly|Ride"] = 84.28, ["Mega"] = 44.34, ["Mega|Ride"] = 95.7, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 40.04, ["Ride"] = 87.94, ["Fly|Ride"] = 140.63, ["Neon"] = 323.45, ["Neon|Ride"] = 344.44, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 1119.64, ["Mega|Ride"] = 1545.16, ["Mega|Fly|Ride"] = 1212.75}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 6.23, ["Ride"] = 139.08, ["Neon"] = 15.82, ["Neon|Ride"] = 111.57, ["Mega"] = 140.62, ["Mega|Ride"] = 547.98, ["Mega|Fly|Ride"] = 419.22}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 366.85, ["Ride"] = 341.25, ["Fly|Ride"] = 443.01, ["Neon"] = 1405.42, ["Neon|Ride"] = 1095.42, ["Neon|Fly|Ride"] = 1224.97, ["Mega|Ride"] = 3226.18, ["Mega|Fly|Ride"] = 3084.38}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 68.25}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 43.31}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 15.74}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 20.88}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 46.66}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 31.5}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 10.36}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 5.25}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 213.94}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 22.3}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 32.16}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 7.8}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 3.61}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 262.19}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 5.2}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 6.55}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 4.47}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 5.07}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 23.45}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 446.25}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 661.86}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 16.9}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1111.69}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 115.5}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 10.47}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.63}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 14.39}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.63}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 19.05}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 71.99}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 43.3}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 22.32}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.63}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 5.25}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 13.09}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 3.93}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 11.79}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.1}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 21.87}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 17.07}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 6.51}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 1049.99}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 158.09}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 308.23}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 3.92}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 9.93}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 54.18}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 45.36}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 115.5}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 9.19}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 12.86}},
    ["rbxassetid://1265129435"] = {name = "Gold Snowboard", prices = {["default"] = 170.63}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.63}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 162.09}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 19.69}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 5.87}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 30.19}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 11.82}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 3.45}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 101.06}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 25.15}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 7.87}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.63}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 21}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 196.88}},
    ["rbxassetid://1265129203"] = {name = "Ice Snowboard", prices = {["default"] = 236.25}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 3.82}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 32.81}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 108.94}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 152.24}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.63}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 6.57}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 16.51}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 27.57}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 59.07}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 52.48}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.63}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22155.8}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 167.89}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 39.38}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 45.75}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 34.8}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 56.89}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 37.38}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 36.75}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 78.73}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 52.5}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 28.46}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 27.57}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 25.72}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 40.47}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 40.69}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 9.14}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 6.36}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.61}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 6.46}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 26.36}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 48.3}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.1}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 7.88}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.52}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 6.19}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 6.57}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 656.25}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 9.09}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 501.38}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 19.69}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.63}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 236.25}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 51.44}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 93.19}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 44.35}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 41.94}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 225.75}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 30.56}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 4.73}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 14.1}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.63}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 3.93}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 3.92}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 30.87}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 2.41}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 3.93}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 43.32}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 17.05}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 86.63}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 61.53}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.1}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 1052.24}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 7.27}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 10.17}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 6.43}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 21}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 33.71}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 11.46}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.63}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 11.6}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 16.02}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 15.65}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 91.88}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 40.31}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.3}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 12.66}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 6.02}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 3.72}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 9.32}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 6.56}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 3.54}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 3.84}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 4.5}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 4.67}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.35}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 7680.47}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 45.94}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 2.86}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 7.82}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 4.41}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 4.23}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 52.5}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 9.19}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 3.84}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 6.98}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 14.44}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 105}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 15.69}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 3.94}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 9.09}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 3.56}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 5.92}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 3.81}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 3.56}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 3229.34}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 4.55}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 45.05}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.52}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 6.86}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 72.19}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.43}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 3.82}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 140.59}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.63}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 3.42}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 2.41}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.52}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 4.68}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 42.62}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 23.84}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.56}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 13.13}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 5.24}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 4.13}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 3.83}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 14.2}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.63}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.41}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 4.99}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 4.23}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 6.18}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 26.13}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.63}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 17.07}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 7.87}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 115.19}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 2.57}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 56.69}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 7.87}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 983.07}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 11.67}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.51}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 5.25}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 3.94}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 27.28}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.63}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 3.62}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 3.82}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 5.84}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 18.17}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 5.77}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 22.17}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 14.44}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.52}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 3.84}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 3.83}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 15.33}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 3.47}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.52}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.15}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 10.5}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 15.75}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 6.56}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 127.05}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 10.65}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.37}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 6.51}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 28.82}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.63}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 11.39}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 2.1}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 38.66}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 24.15}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 3.82}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.52}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 91.65}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 7.77}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 9.18}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 17.07}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.63}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 8.45}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 5.24}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 7.87}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 2.63}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 13.13}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 78.75}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 3.83}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 106.13}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 4.68}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1242.94}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.63}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 213.67}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 8.33}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 5.25}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.24}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.24}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.43}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 17.51}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 47.25}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 9.19}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 4.6}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 56.76}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 7.44}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 2.52}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.35}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 3.4}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.24}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.63}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.52}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 7.44}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 5.07}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 49.55}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 3.61}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 51.19}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 3.35}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 17}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 4.55}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 6.13}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 21}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 102.89}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 4.6}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 3.73}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 65.63}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 5.07}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 3.63}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 11.4}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 65.54}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 54.51}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 57.75}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 315}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 3.68}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 39.37}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 78.15}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.24}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 2.52}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 23}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 59.91}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 3.94}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 23.62}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 6.3}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 7.29}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 6.6}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 24.44}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 3.45}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 2.63}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 2.15}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.5}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 153.57}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 57.79}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 3.93}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 5.07}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 44.1}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 6.28}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 7.59}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 52.46}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 70.56}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 44.37}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1424.04}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 30.7}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 5.25}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 29.03}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 232.73}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 14.42}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 6.57}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.15}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 13.71}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 7.87}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 3.84}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 128.07}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 43.32}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 48.15}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 15.54}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.6}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 70.79}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 85.32}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 97.11}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 918.75}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 188.35}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 7.61}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 1254.46}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 525}},
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