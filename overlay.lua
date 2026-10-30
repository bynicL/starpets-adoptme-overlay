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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 999.85, ["Ride"] = 853.13, ["Fly|Ride"] = 1050, ["Neon"] = 9187.5, ["Neon|Fly|Ride"] = 3921.75}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 367.5, ["Fly"] = 577.66, ["Ride"] = 471.2, ["Fly|Ride"] = 608.85, ["Neon|Ride"] = 2100, ["Neon|Fly|Ride"] = 2886.19, ["Mega"] = 10315.13}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 5979.62, ["Ride"] = 5197.5, ["Fly|Ride"] = 4461.19, ["Neon|Fly|Ride"] = 19943.26, ["Mega|Fly|Ride"] = 68767.81}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 164.71, ["Ride"] = 182.44, ["Fly|Ride"] = 252, ["Neon"] = 775.98, ["Neon|Ride"] = 688.03, ["Neon|Fly|Ride"] = 1100.64, ["Mega"] = 4126.06, ["Mega|Fly|Ride"] = 3150.26}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 590.63, ["Fly"] = 825.23, ["Ride"] = 577.5, ["Fly|Ride"] = 580.59, ["Neon|Ride"] = 1952.67, ["Neon|Fly|Ride"] = 1653.37, ["Mega|Fly|Ride"] = 6513.81}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 9.19, ["Ride"] = 27.68, ["Fly|Ride"] = 152.67, ["Neon"] = 72.19, ["Neon|Ride"] = 109.37, ["Neon|Fly|Ride"] = 275.43, ["Mega"] = 288.35, ["Mega|Ride"] = 262.49, ["Mega|Fly|Ride"] = 303.19}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 4.67, ["Fly"] = 40.65, ["Ride"] = 26.91, ["Fly|Ride"] = 76.7, ["Neon"] = 32.82, ["Neon|Fly"] = 107.04, ["Neon|Ride"] = 43.31, ["Neon|Fly|Ride"] = 105, ["Mega"] = 131.03, ["Mega|Ride"] = 200.82, ["Mega|Fly|Ride"] = 286.7}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 98.76, ["Ride"] = 146.24, ["Fly|Ride"] = 233.63, ["Neon"] = 547.75, ["Neon|Ride"] = 617.89, ["Neon|Fly|Ride"] = 618.93, ["Mega|Ride"] = 2338.45, ["Mega|Fly|Ride"] = 2652.03}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 27.82, ["Fly"] = 138.25, ["Ride"] = 46.55, ["Fly|Ride"] = 82.55, ["Neon"] = 225.92, ["Neon|Ride"] = 301.86, ["Neon|Fly|Ride"] = 279.18, ["Mega"] = 2100, ["Mega|Ride"] = 2730, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 23.25, ["Fly"] = 49.88, ["Ride"] = 36.75, ["Fly|Ride"] = 65.63, ["Neon"] = 138.25, ["Neon|Ride"] = 200.12, ["Neon|Fly|Ride"] = 262.5, ["Mega|Ride"] = 1339.95, ["Mega|Fly|Ride"] = 1019.82}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 68.25, ["Fly"] = 91.88, ["Ride"] = 80.76, ["Fly|Ride"] = 131.25, ["Neon"] = 262.5, ["Neon|Fly"] = 371.37, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 288.75}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 60.9}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 333.57, ["Fly"] = 395.01, ["Ride"] = 344.12, ["Fly|Ride"] = 392.19, ["Neon"] = 1376.05, ["Neon|Ride"] = 1264.62, ["Neon|Fly|Ride"] = 1152.57, ["Mega|Fly|Ride"] = 4855.34}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 103.95, ["Fly"] = 122.76, ["Ride"] = 123.38, ["Fly|Ride"] = 124.38, ["Neon|Ride"] = 564.38, ["Neon|Fly|Ride"] = 621.14, ["Mega|Fly|Ride"] = 2630.37}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.63, ["Fly"] = 114.52, ["Ride"] = 51.85, ["Fly|Ride"] = 206.32, ["Neon"] = 19.69, ["Neon|Fly"] = 96.41, ["Neon|Ride"] = 138.25, ["Neon|Fly|Ride"] = 138.25, ["Mega"] = 137.46, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 206.32, ["Mega|Fly|Ride"] = 385.02}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 155.93, ["Fly"] = 242.42, ["Ride"] = 150.93, ["Fly|Ride"] = 227.54, ["Neon"] = 930.69, ["Neon|Ride"] = 577.5, ["Neon|Fly|Ride"] = 622.68, ["Mega|Fly|Ride"] = 2165.63}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.62, ["Fly"] = 21.38, ["Ride"] = 18.38, ["Fly|Ride"] = 39.37, ["Neon"] = 25.03, ["Neon|Ride"] = 90.79, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 334.69, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 101.08, ["Fly"] = 262.5, ["Ride"] = 124.49, ["Fly|Ride"] = 190.32, ["Neon"] = 344.54, ["Neon|Fly"] = 465.36, ["Neon|Ride"] = 288.75, ["Neon|Fly|Ride"] = 426.57, ["Mega"] = 1499.84, ["Mega|Ride"] = 1153.59, ["Mega|Fly|Ride"] = 1102.5}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 33.78}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 57.12, ["Ride"] = 123.38, ["Fly|Ride"] = 164.07, ["Neon"] = 577.5, ["Neon|Fly|Ride"] = 2362.5}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 15.65, ["Fly"] = 393.75, ["Ride"] = 35.44, ["Fly|Ride"] = 223.13, ["Neon"] = 65.63, ["Neon|Ride"] = 165.06, ["Neon|Fly|Ride"] = 247.58, ["Mega|Ride"] = 580.76, ["Mega|Fly|Ride"] = 1650.44}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 42.3, ["Fly"] = 77.97, ["Ride"] = 55.08, ["Fly|Ride"] = 115.46, ["Neon"] = 241.34, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 288.74, ["Mega"] = 1628.47, ["Mega|Fly|Ride"] = 819.51}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 34.13, ["Ride"] = 124.49, ["Fly|Ride"] = 136.5, ["Neon"] = 204.75, ["Neon|Fly"] = 386.26, ["Neon|Ride"] = 296.06, ["Neon|Fly|Ride"] = 344.54, ["Mega"] = 1071.75, ["Mega|Ride"] = 1233.7, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 18.38, ["Ride"] = 41.1, ["Fly|Ride"] = 131.25, ["Neon"] = 344.54, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 315, ["Mega"] = 771.59, ["Mega|Ride"] = 2060.97, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 40.67, ["Fly"] = 136.75, ["Ride"] = 59.06, ["Fly|Ride"] = 144.38, ["Neon"] = 210, ["Neon|Fly"] = 551.87, ["Neon|Ride"] = 310.64, ["Neon|Fly|Ride"] = 525, ["Mega|Ride"] = 1124.82, ["Mega|Fly|Ride"] = 859.13}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 7.48, ["Fly"] = 26.25, ["Ride"] = 21, ["Fly|Ride"] = 52.49, ["Neon"] = 30.94, ["Neon|Fly"] = 104.99, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 91.85, ["Mega"] = 129.94, ["Mega|Fly"] = 27541.38, ["Mega|Ride"] = 178.5, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 410.97, ["Ride"] = 412.62, ["Fly|Ride"] = 441.23, ["Neon"] = 1861.37, ["Neon|Ride"] = 1689.18, ["Neon|Fly|Ride"] = 1680, ["Mega|Fly|Ride"] = 7286.62}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 15.75, ["Ride"] = 31.43, ["Fly|Ride"] = 107.34, ["Neon"] = 219.18, ["Neon|Ride"] = 177.44, ["Neon|Fly|Ride"] = 420.88, ["Mega|Fly|Ride"] = 915.99}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 6.06, ["Fly"] = 40.69, ["Ride"] = 22.19, ["Fly|Ride"] = 39.38, ["Neon"] = 51.18, ["Neon|Fly"] = 90.79, ["Neon|Ride"] = 70.88, ["Neon|Fly|Ride"] = 123.38, ["Mega|Ride"] = 261.48, ["Mega|Fly|Ride"] = 391.74}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 78.07, ["Fly"] = 77.44, ["Ride"] = 67.49, ["Fly|Ride"] = 143.63, ["Neon"] = 210, ["Neon|Ride"] = 385.75, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 3026.47, ["Mega|Ride"] = 7290.94, ["Mega|Fly|Ride"] = 2016.97}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 15.45, ["Ride"] = 30.96, ["Fly|Ride"] = 74.55, ["Neon"] = 155.91, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 160.79, ["Mega"] = 697.92, ["Mega|Ride"] = 782.93, ["Mega|Fly|Ride"] = 483}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 182.44, ["Fly"] = 348.67, ["Ride"] = 208.69, ["Fly|Ride"] = 264.89, ["Neon"] = 814.36, ["Neon|Ride"] = 735, ["Neon|Fly|Ride"] = 990.27, ["Mega"] = 6189.08, ["Mega|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 2869.13}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 30.18}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 4.6, ["Fly"] = 29.4, ["Ride"] = 24.94, ["Fly|Ride"] = 49.89, ["Neon"] = 27.75, ["Neon|Fly"] = 69.13, ["Neon|Ride"] = 51.59, ["Neon|Fly|Ride"] = 152.67, ["Mega"] = 234.94, ["Mega|Fly"] = 344.54, ["Mega|Ride"] = 274.37, ["Mega|Fly|Ride"] = 275.43}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 1050, ["Fly"] = 2625, ["Ride"] = 1181.25, ["Fly|Ride"] = 1265.67, ["Neon"] = 7158.38, ["Neon|Ride"] = 5906.25, ["Neon|Fly|Ride"] = 4003.13, ["Mega|Ride"] = 52342.95, ["Mega|Fly|Ride"] = 21181.08}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 15.49, ["Fly"] = 65.63, ["Ride"] = 32.8, ["Fly|Ride"] = 65.63, ["Neon"] = 77.38, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 103.17, ["Neon|Fly|Ride"] = 218.7, ["Mega"] = 534.34, ["Mega|Ride"] = 674.63, ["Mega|Fly|Ride"] = 820.31}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 157.5, ["Ride"] = 168, ["Fly|Ride"] = 279.22, ["Neon"] = 811.81, ["Neon|Ride"] = 616.77, ["Neon|Fly|Ride"] = 1020.17, ["Mega|Ride"] = 2016.97, ["Mega|Fly|Ride"] = 2746.93}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 40.69}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 18.38, ["Fly"] = 68.84, ["Ride"] = 52.29, ["Fly|Ride"] = 138.25, ["Neon"] = 82.41, ["Neon|Ride"] = 155.91, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 688.03, ["Mega|Fly|Ride"] = 729.32}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 114.28, ["Ride"] = 206.32, ["Neon"] = 729.29, ["Neon|Ride"] = 510.61, ["Neon|Fly|Ride"] = 688.03, ["Mega|Fly|Ride"] = 2231.25}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 98.44, ["Ride"] = 152.25, ["Fly|Ride"] = 246.75, ["Neon"] = 389.45, ["Neon|Ride"] = 364.88, ["Neon|Fly|Ride"] = 576.19, ["Mega"] = 1547.28, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1926.88}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 59.06}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 52.46, ["Fly"] = 59.16, ["Ride"] = 54.93, ["Fly|Ride"] = 81.35, ["Neon|Ride"] = 479.33, ["Neon|Fly|Ride"] = 308.74, ["Mega"] = 4126.06, ["Mega|Fly|Ride"] = 1551.38}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 7.23, ["Fly"] = 55.71, ["Ride"] = 73.24, ["Fly|Ride"] = 131.25, ["Neon"] = 39.22, ["Neon|Ride"] = 123.65, ["Neon|Fly|Ride"] = 330.1, ["Mega"] = 131.25, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 274.93, ["Mega|Fly|Ride"] = 409.5}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 420, ["Fly"] = 426.57, ["Ride"] = 392.34, ["Fly|Ride"] = 419.99, ["Neon|Ride"] = 1698.57, ["Neon|Fly|Ride"] = 1506.75, ["Mega|Fly|Ride"] = 6298.95}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 78.75, ["Fly"] = 138.25, ["Ride"] = 104.99, ["Fly|Ride"] = 170.63, ["Neon"] = 446.25, ["Neon|Ride"] = 536.41, ["Neon|Fly|Ride"] = 531.24, ["Mega|Ride"] = 2462.23, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3722.72, ["Ride"] = 3433.5, ["Fly|Ride"] = 3673.69, ["Neon|Fly|Ride"] = 14440.15}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 41.99, ["Fly"] = 110.39, ["Ride"] = 46.87, ["Fly|Ride"] = 96.97, ["Neon"] = 393.75, ["Neon|Ride"] = 272.9, ["Neon|Fly|Ride"] = 344.54, ["Mega|Ride"] = 1184.19, ["Mega|Fly|Ride"] = 1376.05}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 68.25, ["Ride"] = 78.74, ["Fly|Ride"] = 195.57, ["Neon"] = 580.53, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 446.25, ["Mega"] = 2751.06, ["Mega|Fly|Ride"] = 2326.36}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 30.19, ["Fly"] = 61.9, ["Ride"] = 58.77, ["Fly|Ride"] = 109.26, ["Neon"] = 217.56, ["Neon|Ride"] = 138.25, ["Neon|Fly|Ride"] = 191.05, ["Mega"] = 2625, ["Mega|Ride"] = 674.63, ["Mega|Fly|Ride"] = 586.69}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 9.32}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 45.4, ["Fly"] = 393.75, ["Ride"] = 47.25, ["Fly|Ride"] = 71.61, ["Neon"] = 328.13, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 406.88, ["Mega|Fly|Ride"] = 1493.63}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 43.21}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 200.12, ["Ride"] = 210, ["Fly|Ride"] = 275.42, ["Neon|Ride"] = 1376.05, ["Neon|Fly|Ride"] = 930.56, ["Mega|Fly|Ride"] = 4963.29}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 931.88, ["Ride"] = 938.44, ["Fly|Ride"] = 1050, ["Neon|Ride"] = 3713.46, ["Neon|Fly|Ride"] = 3018.75, ["Mega|Fly|Ride"] = 15472.69}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 6.3}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 26.25, ["Fly"] = 40.73, ["Ride"] = 39.1, ["Fly|Ride"] = 69.13, ["Neon"] = 183.62, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 190.31, ["Mega|Ride"] = 656.15, ["Mega|Fly|Ride"] = 877.05}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 11.82}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 6312.87, ["Fly|Ride"] = 4723.69, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 40323.85}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 15.75, ["Fly"] = 74.7, ["Ride"] = 21, ["Fly|Ride"] = 59.06, ["Neon"] = 98.23, ["Neon|Ride"] = 120.74, ["Neon|Fly|Ride"] = 217.53, ["Mega"] = 651.93, ["Mega|Ride"] = 609.65, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 11.82, ["Fly"] = 41.28, ["Ride"] = 39.22, ["Fly|Ride"] = 110.39, ["Neon"] = 93.89, ["Neon|Ride"] = 132.7, ["Neon|Fly|Ride"] = 231, ["Mega"] = 1035.25, ["Mega|Ride"] = 366.19, ["Mega|Fly|Ride"] = 688.03}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 94.91, ["Fly"] = 263, ["Ride"] = 55.65, ["Fly|Ride"] = 89.25, ["Neon|Fly|Ride"] = 963.45, ["Mega"] = 4126.06}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 10.19, ["Ride"] = 26.25, ["Fly|Ride"] = 107.29, ["Neon"] = 55.71, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 501.37, ["Mega"] = 1376.05, ["Mega|Ride"] = 501.42, ["Mega|Fly|Ride"] = 775.85}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1968.64, ["Fly"] = 1837.5, ["Ride"] = 1754.16, ["Fly|Ride"] = 1837.5, ["Neon|Fly|Ride"] = 3888.11, ["Mega|Fly|Ride"] = 13125}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 29400, ["Fly"] = 26250, ["Ride"] = 34384.43, ["Fly|Ride"] = 23625, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 65330.81, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 183750}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 15.75, ["Fly"] = 393.74, ["Ride"] = 52.5, ["Fly|Ride"] = 124.69, ["Neon"] = 253.77, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 96.97, ["Mega"] = 825.23, ["Mega|Ride"] = 682.5, ["Mega|Fly|Ride"] = 821.09}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 2.63, ["Fly"] = 73.31, ["Ride"] = 47.13, ["Fly|Ride"] = 206.32, ["Neon"] = 19.52, ["Neon|Fly"] = 134.4, ["Neon|Ride"] = 57.74, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 129.18, ["Mega|Ride"] = 140.13, ["Mega|Fly|Ride"] = 338.63}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 23.58}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 10.49, ["Ride"] = 36.75, ["Fly|Ride"] = 124.66, ["Neon"] = 55.71, ["Neon|Ride"] = 125.32, ["Neon|Fly|Ride"] = 463.21, ["Mega"] = 210, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 538.13}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 688.03, ["Ride"] = 588, ["Fly|Ride"] = 787.5, ["Neon|Ride"] = 2908.49, ["Neon|Fly|Ride"] = 2326.36, ["Mega|Fly|Ride"] = 10857.1}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 932.86, ["Fly"] = 962.07, ["Ride"] = 904.32, ["Fly|Ride"] = 944.99, ["Neon"] = 4126.06, ["Neon|Fly|Ride"] = 2978.07, ["Mega|Fly|Ride"] = 11276.5}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 27.02, ["Fly"] = 116.36, ["Ride"] = 41.28, ["Fly|Ride"] = 65.63, ["Neon"] = 92.86, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 206.32, ["Mega"] = 1030.12, ["Mega|Ride"] = 685.13, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 29.93}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 65.63, ["Fly"] = 111.57, ["Ride"] = 80.07, ["Fly|Ride"] = 105.7, ["Neon|Ride"] = 383.74, ["Neon|Fly|Ride"] = 367.5, ["Mega|Ride"] = 2019.71, ["Mega|Fly|Ride"] = 1664.25}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 56.72, ["Ride"] = 77.21, ["Fly|Ride"] = 228.38, ["Neon"] = 356.92, ["Neon|Ride"] = 391.99, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 2078.74, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 5.25, ["Fly"] = 41.28, ["Ride"] = 20, ["Fly|Ride"] = 51.32, ["Neon"] = 32.82, ["Neon|Fly"] = 525, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 108.94, ["Mega"] = 315, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 103.68, ["Fly"] = 106.32, ["Ride"] = 105, ["Fly|Ride"] = 145.68, ["Neon"] = 807.7, ["Neon|Ride"] = 399.2, ["Neon|Fly|Ride"] = 353.07, ["Mega|Fly|Ride"] = 1419.98}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 4.72, ["Ride"] = 47.51, ["Fly|Ride"] = 111.57, ["Neon"] = 53.82, ["Neon|Ride"] = 91.86, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 210, ["Mega|Fly"] = 275.43, ["Mega|Ride"] = 288.84, ["Mega|Fly|Ride"] = 496.33}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 15.75, ["Fly"] = 41.11, ["Ride"] = 31.5, ["Fly|Ride"] = 82.55, ["Neon"] = 109.37, ["Neon|Ride"] = 109.19, ["Neon|Fly|Ride"] = 176.4, ["Mega"] = 729.29, ["Mega|Fly|Ride"] = 755.08}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 23.63, ["Ride"] = 74.72, ["Fly|Ride"] = 156.19, ["Neon"] = 263.05, ["Neon|Ride"] = 325.98, ["Mega"] = 694.25, ["Mega|Ride"] = 775.85, ["Mega|Fly|Ride"] = 866.49}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 16.47, ["Fly"] = 124.8, ["Ride"] = 35.09, ["Fly|Ride"] = 72.19, ["Neon"] = 91.88, ["Neon|Ride"] = 109.37, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 715.88, ["Mega|Fly|Ride"] = 947.63}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 7014.29, ["Ride"] = 6332.82, ["Fly|Ride"] = 6542.9, ["Neon"] = 30945.36, ["Neon|Fly|Ride"] = 27371.17}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 247.58, ["Fly"] = 258.48, ["Ride"] = 247.58, ["Fly|Ride"] = 282.19, ["Neon|Fly|Ride"] = 559.46, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 31.49, ["Fly"] = 131.73, ["Ride"] = 82.61, ["Fly|Ride"] = 146.4, ["Neon"] = 90.57, ["Neon|Fly"] = 205.28, ["Neon|Ride"] = 126, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 380.62, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 482.12}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 3.94, ["Fly"] = 86.1, ["Ride"] = 23.63, ["Fly|Ride"] = 96.97, ["Neon"] = 23.03, ["Neon|Ride"] = 55.71, ["Neon|Fly|Ride"] = 187.76, ["Mega"] = 262.5, ["Mega|Ride"] = 187.69}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 39.38, ["Fly"] = 5273.46, ["Ride"] = 84.48, ["Fly|Ride"] = 193.59, ["Neon"] = 184.42, ["Neon|Fly"] = 236.25, ["Neon|Ride"] = 201.71, ["Neon|Fly|Ride"] = 316.68, ["Mega"] = 414.41, ["Mega|Ride"] = 546.95, ["Mega|Fly|Ride"] = 584.73}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 13991.25, ["Ride"] = 13125, ["Fly|Ride"] = 12258.75, ["Neon|Fly|Ride"] = 27562.5}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 128.62, ["Ride"] = 164.06, ["Fly|Ride"] = 262.5, ["Neon"] = 1376.05, ["Neon|Ride"] = 1444.13, ["Neon|Fly|Ride"] = 1504.99, ["Mega|Fly|Ride"] = 4264.29}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 60.38, ["Fly"] = 101.88, ["Ride"] = 59.07, ["Fly|Ride"] = 86.63, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 407.84, ["Mega|Fly|Ride"] = 2525.16}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 10.5, ["Fly"] = 28.53, ["Ride"] = 24.55, ["Fly|Ride"] = 59.84, ["Neon"] = 85.32, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 229.69, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 341.25, ["Fly"] = 825.23, ["Ride"] = 409.28, ["Fly|Ride"] = 466.44, ["Neon"] = 1639.32, ["Neon|Ride"] = 1650.44, ["Neon|Fly|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 5011.13}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 6.22, ["Ride"] = 36.75, ["Fly|Ride"] = 59.07, ["Neon"] = 26.25, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 217.53, ["Mega"] = 129.94, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 138.25, ["Fly"] = 264.09, ["Ride"] = 192.91, ["Fly|Ride"] = 265.27, ["Neon"] = 758.51, ["Neon|Ride"] = 687.93, ["Neon|Fly|Ride"] = 733.42, ["Mega|Fly|Ride"] = 3567.47}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 9.19, ["Fly"] = 15.75, ["Ride"] = 17.07, ["Fly|Ride"] = 35.05, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 786.19, ["Mega|Fly|Ride"] = 686.44}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 12.39}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 65.61, ["Ride"] = 86.63, ["Fly|Ride"] = 279.57, ["Neon"] = 411.58, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 367.5, ["Mega|Ride"] = 1237.83, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 14.44, ["Fly"] = 102.14, ["Ride"] = 45.4, ["Fly|Ride"] = 86.63, ["Neon"] = 96.97, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 245.44, ["Mega"] = 514.75, ["Mega|Ride"] = 548.79, ["Mega|Fly|Ride"] = 546}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 21}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 42.88, ["Fly"] = 131.25, ["Ride"] = 65.63, ["Fly|Ride"] = 275.43, ["Neon"] = 237.57, ["Neon|Ride"] = 258.54, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 918.06, ["Mega|Ride"] = 930.56, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.94, ["Ride"] = 29.23, ["Fly|Ride"] = 132.54, ["Neon"] = 21.68, ["Neon|Ride"] = 104.72, ["Neon|Fly|Ride"] = 241.39, ["Mega"] = 135.18, ["Mega|Fly|Ride"] = 357.12}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 13.13, ["Fly"] = 47.25, ["Ride"] = 32, ["Fly|Ride"] = 65.63, ["Neon|Ride"] = 136.18, ["Neon|Fly|Ride"] = 267.54, ["Mega|Ride"] = 547.75, ["Mega|Fly|Ride"] = 804.59}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 363.83, ["Ride"] = 384.23, ["Fly|Ride"] = 346.5, ["Neon|Fly|Ride"] = 2613.86, ["Mega|Fly|Ride"] = 8664.72}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 42, ["Fly"] = 55.71, ["Ride"] = 53.82, ["Fly|Ride"] = 103.68, ["Neon"] = 184.98, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 234.17, ["Mega"] = 713.83, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 741.57}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 45.93, ["Fly"] = 109.01, ["Ride"] = 72.19, ["Fly|Ride"] = 138.25, ["Neon"] = 412.62, ["Neon|Ride"] = 220.75, ["Neon|Fly|Ride"] = 315, ["Mega|Fly|Ride"] = 1266.71}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 27.56, ["Fly"] = 84.23, ["Ride"] = 65.63, ["Fly|Ride"] = 145.4, ["Neon"] = 111.57, ["Neon|Ride"] = 177.44, ["Neon|Fly|Ride"] = 206.32, ["Mega"] = 393.75, ["Mega|Ride"] = 396.38, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 26250, ["Ride"] = 13273.32, ["Fly|Ride"] = 8091.57, ["Neon|Fly|Ride"] = 13453.13, ["Mega|Fly|Ride"] = 39373.95}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1509.38, ["Ride"] = 1443.65, ["Fly|Ride"] = 1522.5, ["Neon"] = 5502.1, ["Neon|Fly|Ride"] = 4199.99, ["Mega"] = 20905.66, ["Mega|Fly|Ride"] = 14962.5}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 525, ["Ride"] = 505.32, ["Fly|Ride"] = 621.25, ["Neon"] = 2270, ["Neon|Fly|Ride"] = 2269.34, ["Mega|Fly|Ride"] = 6431.25}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 15.39, ["Fly"] = 26.84, ["Ride"] = 19.69, ["Fly|Ride"] = 51.59, ["Neon"] = 110.39, ["Neon|Ride"] = 82.55, ["Neon|Fly|Ride"] = 138.11, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 6.2, ["Fly"] = 78.74, ["Ride"] = 30.76, ["Fly|Ride"] = 123.8, ["Neon"] = 27.87, ["Neon|Ride"] = 68.1, ["Neon|Fly|Ride"] = 73.29, ["Mega"] = 156.85, ["Mega|Ride"] = 179.25, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 41.28, ["Fly"] = 68.25, ["Ride"] = 54.46, ["Fly|Ride"] = 96.42, ["Neon"] = 275.43, ["Neon|Ride"] = 193.59, ["Neon|Fly|Ride"] = 169.41, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.94, ["Fly"] = 20.56, ["Ride"] = 17.07, ["Fly|Ride"] = 44.37, ["Neon"] = 23.71, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 89.25, ["Mega"] = 361.04, ["Mega|Ride"] = 206.07, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 315, ["Fly"] = 320.25, ["Ride"] = 249.38, ["Fly|Ride"] = 373.05, ["Neon"] = 1004.41, ["Neon|Ride"] = 1334.8, ["Neon|Fly|Ride"] = 1169.44}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 20.65, ["Fly"] = 60.09, ["Ride"] = 40.24, ["Fly|Ride"] = 77.32, ["Neon"] = 204.75, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 229.69, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 12.39, ["Fly"] = 26.56, ["Ride"] = 19.49, ["Fly|Ride"] = 43.34, ["Neon"] = 69.13, ["Neon|Fly"] = 132.64, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 1575, ["Mega|Ride"] = 618.19, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 392.44, ["Fly"] = 787.5, ["Ride"] = 435.74, ["Fly|Ride"] = 646.77, ["Neon|Fly|Ride"] = 2791.64, ["Mega|Fly|Ride"] = 8619.19}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1148.33, ["Fly"] = 1396.03, ["Ride"] = 1154.99, ["Fly|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 13716.15}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 109.36, ["Fly"] = 128.63, ["Ride"] = 99.75, ["Fly|Ride"] = 118.13, ["Neon"] = 971.25, ["Neon|Ride"] = 585.46, ["Neon|Fly|Ride"] = 262.5, ["Mega|Ride"] = 2338.45, ["Mega|Fly|Ride"] = 3879.21}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 136.5, ["Fly"] = 179.5, ["Ride"] = 190.33, ["Fly|Ride"] = 247.58, ["Neon"] = 556.5, ["Neon|Ride"] = 668.43, ["Neon|Fly|Ride"] = 604.99, ["Mega|Ride"] = 8603.44, ["Mega|Fly|Ride"] = 2482.24}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 24.77, ["Ride"] = 65.63, ["Fly|Ride"] = 275.43, ["Neon"] = 232.74, ["Neon|Ride"] = 272.99, ["Neon|Fly|Ride"] = 385.08, ["Mega"] = 656.25, ["Mega|Ride"] = 1861.1, ["Mega|Fly|Ride"] = 796.35}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 128.63, ["Ride"] = 273, ["Fly|Ride"] = 412.62, ["Neon|Fly|Ride"] = 1302.77, ["Mega|Fly|Ride"] = 3300.86}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2042.65, ["Ride"] = 2483.25, ["Fly|Ride"] = 2475.64, ["Neon|Fly|Ride"] = 8252.11, ["Mega|Fly|Ride"] = 24815.22}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 61.92, ["Ride"] = 65.63, ["Fly|Ride"] = 196.87, ["Neon"] = 350.73, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 343.87, ["Mega"] = 1926.88, ["Mega|Ride"] = 2269.34, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 656.25, ["Fly"] = 798.4, ["Ride"] = 642.77, ["Fly|Ride"] = 656.25, ["Neon|Ride"] = 1525.21, ["Neon|Fly|Ride"] = 1168.13, ["Mega|Fly|Ride"] = 3107.9}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 42, ["Fly"] = 59.07, ["Ride"] = 52.5, ["Fly|Ride"] = 84.44, ["Neon|Fly"] = 291.38, ["Neon|Ride"] = 360.67, ["Neon|Fly|Ride"] = 225.75, ["Mega|Fly|Ride"] = 1181.24}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.82, ["Fly"] = 31.55, ["Ride"] = 20.65, ["Fly|Ride"] = 41.27, ["Neon"] = 29.93, ["Neon|Fly"] = 93.09, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 141.38, ["Mega|Fly"] = 249.26, ["Mega|Ride"] = 185.46, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 35.09, ["Ride"] = 105, ["Fly|Ride"] = 252, ["Neon"] = 259.88, ["Neon|Ride"] = 411.58, ["Neon|Fly|Ride"] = 621.14, ["Mega|Ride"] = 1376.05, ["Mega|Fly|Ride"] = 824.2}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 656.25, ["Fly"] = 1017.95, ["Ride"] = 721.88, ["Fly|Ride"] = 771.75, ["Neon|Ride"] = 2436.15, ["Neon|Fly|Ride"] = 2131.54, ["Mega|Fly|Ride"] = 8804.25}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 608.99, ["Ride"] = 598.5, ["Fly|Ride"] = 859.69, ["Neon"] = 5157.57, ["Neon|Fly|Ride"] = 3646.4, ["Mega|Fly|Ride"] = 15266.39}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 12.91, ["Fly"] = 32.82, ["Ride"] = 23.63, ["Fly|Ride"] = 39.38, ["Neon"] = 206.32, ["Neon|Ride"] = 82.55, ["Neon|Fly|Ride"] = 169.18, ["Mega"] = 786.19, ["Mega|Fly|Ride"] = 713.83}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 10.5, ["Ride"] = 22.16, ["Fly|Ride"] = 65, ["Neon"] = 72.02, ["Neon|Fly"] = 82.55, ["Neon|Ride"] = 91.92, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 963.45, ["Mega|Ride"] = 481.73, ["Mega|Fly|Ride"] = 378.67}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 4.09, ["Ride"] = 26.95, ["Fly|Ride"] = 111.56, ["Neon"] = 20.87, ["Neon|Fly"] = 310.64, ["Neon|Ride"] = 53.36, ["Neon|Fly|Ride"] = 138.25, ["Mega"] = 158, ["Mega|Ride"] = 244.13, ["Mega|Fly|Ride"] = 302.54}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 43.77, ["Fly"] = 77.38, ["Ride"] = 59.07, ["Fly|Ride"] = 110.39, ["Neon"] = 288.84, ["Neon|Ride"] = 216.56, ["Neon|Fly|Ride"] = 231, ["Mega|Ride"] = 1052.16, ["Mega|Fly|Ride"] = 944.9}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 65.63, ["Ride"] = 103.69, ["Fly|Ride"] = 449.61, ["Neon"] = 415.63, ["Neon|Ride"] = 493.08, ["Neon|Fly|Ride"] = 412.62, ["Mega"] = 1547.28, ["Mega|Ride"] = 1547.28, ["Mega|Fly|Ride"] = 1327.57}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 14.44, ["Fly"] = 54.55, ["Ride"] = 39.57, ["Fly|Ride"] = 78.75, ["Neon"] = 72.19, ["Neon|Ride"] = 108.92, ["Neon|Fly|Ride"] = 201.15, ["Mega"] = 344.54, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 463.32}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 38.24, ["Ride"] = 47.25, ["Fly|Ride"] = 78.75, ["Neon"] = 550.85, ["Neon|Ride"] = 275.43, ["Neon|Fly|Ride"] = 269.07, ["Mega"] = 2100, ["Mega|Ride"] = 963.45, ["Mega|Fly|Ride"] = 787.4}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 2.63, ["Fly"] = 23.73, ["Ride"] = 19.68, ["Fly|Ride"] = 40.67, ["Neon"] = 26.25, ["Neon|Ride"] = 34.86, ["Neon|Fly|Ride"] = 91.71, ["Mega"] = 525, ["Mega|Ride"] = 275.43, ["Mega|Fly|Ride"] = 315.67}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 5.25, ["Fly"] = 32.49, ["Ride"] = 30.96, ["Fly|Ride"] = 80.88, ["Neon"] = 27.57, ["Neon|Fly"] = 82.55, ["Neon|Ride"] = 73.41, ["Neon|Fly|Ride"] = 165.06, ["Mega"] = 206.32, ["Mega|Ride"] = 369.3, ["Mega|Fly|Ride"] = 334.69}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 44.63, ["Fly"] = 65.62, ["Ride"] = 51.17, ["Fly|Ride"] = 87.94, ["Neon"] = 275.43, ["Neon|Ride"] = 186.51, ["Neon|Fly|Ride"] = 267.75, ["Mega|Fly|Ride"] = 926.56}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1569.02, ["Fly"] = 1548.75, ["Ride"] = 1509.38, ["Fly|Ride"] = 1505.44, ["Neon|Fly"] = 4944.42, ["Neon|Ride"] = 4649.04, ["Neon|Fly|Ride"] = 3732.75, ["Mega|Fly|Ride"] = 16503.17}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 523.69, ["Fly"] = 549.12, ["Ride"] = 456.75, ["Fly|Ride"] = 610.66, ["Neon|Ride"] = 2613.86, ["Neon|Fly|Ride"] = 1968.75, ["Mega|Fly|Ride"] = 9626.08}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 241.5, ["Fly"] = 371.37, ["Ride"] = 247.58, ["Fly|Ride"] = 328.13, ["Neon"] = 1513.24, ["Neon|Ride"] = 930.72, ["Neon|Fly|Ride"] = 1442.51, ["Mega|Fly|Ride"] = 6574.87}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 40.37}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 30.19, ["Ride"] = 41.85, ["Fly|Ride"] = 96.97, ["Neon"] = 330.41, ["Neon|Fly"] = 412.62, ["Neon|Ride"] = 344.54, ["Neon|Fly|Ride"] = 1968.75, ["Mega"] = 928.37, ["Mega|Ride"] = 963.45, ["Mega|Fly|Ride"] = 1038.19}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 41260.48, ["Fly"] = 20998.69, ["Ride"] = 34781.25, ["Fly|Ride"] = 17587.5, ["Neon|Fly|Ride"] = 38062.5, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 371.37, ["Fly"] = 854.44, ["Ride"] = 410.82, ["Fly|Ride"] = 485.86, ["Neon"] = 1115.63, ["Neon|Ride"] = 1207.5, ["Neon|Fly|Ride"] = 1312.5, ["Mega"] = 6051.89, ["Mega|Fly|Ride"] = 3845.63}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 171.93, ["Fly"] = 525, ["Ride"] = 136.5, ["Fly|Ride"] = 173.7, ["Mega|Fly|Ride"] = 4126.06}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 123.36, ["Fly"] = 262.5, ["Ride"] = 118.13, ["Fly|Ride"] = 179.82, ["Neon"] = 618.93, ["Neon|Ride"] = 509.73, ["Neon|Fly|Ride"] = 550.85, ["Mega|Fly|Ride"] = 2474.61}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 18.38, ["Fly"] = 94.5, ["Ride"] = 31.43, ["Fly|Ride"] = 102.54, ["Neon"] = 52.62, ["Neon|Ride"] = 138.25, ["Neon|Fly|Ride"] = 205.28, ["Mega"] = 687.01, ["Mega|Ride"] = 525}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 4868.75, ["Ride"] = 4951.27, ["Fly|Ride"] = 3806.25, ["Neon|Ride"] = 17880.23, ["Neon|Fly|Ride"] = 17604.83}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 27.87, ["Fly"] = 40.62, ["Ride"] = 36.08, ["Fly|Ride"] = 53.82, ["Neon"] = 337.32, ["Neon|Ride"] = 232.7, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 1100.64, ["Mega|Fly|Ride"] = 859.69}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 39.34, ["Fly"] = 138.25, ["Ride"] = 42, ["Fly|Ride"] = 110.25, ["Neon|Ride"] = 381.94, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 1551.69, ["Mega|Fly|Ride"] = 1512.21}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 629.99, ["Fly"] = 825.23, ["Ride"] = 752.85, ["Fly|Ride"] = 826.88, ["Neon"] = 1771.88, ["Neon|Ride"] = 1811.25, ["Neon|Fly|Ride"] = 1706.25, ["Mega|Ride"] = 7530.05, ["Mega|Fly|Ride"] = 5775}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 14.44, ["Fly"] = 24.77, ["Ride"] = 23.63, ["Fly|Ride"] = 45.94, ["Neon"] = 124.68, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 151.26, ["Mega|Ride"] = 584.89, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 12.03, ["Fly"] = 88.73, ["Ride"] = 34.12, ["Neon"] = 80.06, ["Neon|Ride"] = 143.07, ["Neon|Fly|Ride"] = 249.38, ["Mega|Ride"] = 522.99, ["Mega|Fly|Ride"] = 550.85}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 102.36, ["Ride"] = 115.5, ["Fly|Ride"] = 262.5, ["Neon"] = 535.37, ["Neon|Ride"] = 525.35, ["Neon|Fly|Ride"] = 618.93, ["Mega|Fly|Ride"] = 2338.45}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 26.25, ["Fly"] = 111.69, ["Ride"] = 84.55, ["Fly|Ride"] = 155.77, ["Neon"] = 85.32, ["Neon|Fly"] = 129.98, ["Neon|Ride"] = 103.17, ["Neon|Fly|Ride"] = 256.09, ["Mega"] = 210, ["Mega|Fly"] = 738.64, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3881.84, ["Fly"] = 5053.39, ["Ride"] = 3937.49, ["Fly|Ride"] = 3675, ["Neon"] = 10315.13, ["Neon|Ride"] = 11519.93, ["Neon|Fly|Ride"] = 8977.14, ["Mega"] = 61890.71, ["Mega|Fly|Ride"] = 34262.53}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 36.75, ["Ride"] = 59.07, ["Fly|Ride"] = 129.98, ["Neon"] = 139.64, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 274.4, ["Mega|Ride"] = 1030.49, ["Mega|Fly|Ride"] = 1211.01}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 5891.82, ["Fly"] = 7875, ["Ride"] = 7702.31, ["Fly|Ride"] = 5775, ["Neon|Fly|Ride"] = 16079.15, ["Mega|Fly|Ride"] = 68240.08}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.63, ["Fly"] = 20.89, ["Ride"] = 16.52, ["Fly|Ride"] = 35.13, ["Neon"] = 19.68, ["Neon|Fly"] = 62.62, ["Neon|Ride"] = 45.48, ["Neon|Fly|Ride"] = 86.51, ["Mega"] = 450.16, ["Mega|Ride"] = 192.91, ["Mega|Fly|Ride"] = 304.32}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 19.62, ["Fly"] = 28.87, ["Ride"] = 26.56, ["Fly|Ride"] = 55.71, ["Neon"] = 110.39, ["Neon|Ride"] = 164.03, ["Neon|Fly|Ride"] = 179.5, ["Mega|Fly|Ride"] = 930.56}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.68}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 16.52, ["Ride"] = 39.36, ["Fly|Ride"] = 116.03, ["Neon"] = 142.36, ["Neon|Ride"] = 175.88, ["Neon|Fly|Ride"] = 602.42, ["Mega"] = 775.85, ["Mega|Ride"] = 963.45, ["Mega|Fly|Ride"] = 748.13}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 27.87, ["Fly"] = 190.37, ["Ride"] = 40.24, ["Fly|Ride"] = 138.25, ["Neon"] = 182.44, ["Neon|Ride"] = 185.88, ["Neon|Fly|Ride"] = 310.57, ["Mega"] = 840, ["Mega|Fly|Ride"] = 1099.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 12.83, ["Fly"] = 21.53, ["Ride"] = 23.28, ["Fly|Ride"] = 44.38, ["Neon"] = 89.76, ["Neon|Ride"] = 114.52, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 786.19, ["Mega|Ride"] = 580.44, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8936.73}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2715.57}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 26.24}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 171.25, ["Fly"] = 174.57, ["Ride"] = 174.57, ["Fly|Ride"] = 183.74, ["Neon|Fly|Ride"] = 1031.52}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 18.38, ["Fly"] = 123.8, ["Ride"] = 44.23, ["Fly|Ride"] = 111.57, ["Neon"] = 82.55, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 205.28, ["Mega|Ride"] = 930.56, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 11.15}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 6.57, ["Ride"] = 29.93, ["Fly|Ride"] = 69.13, ["Neon"] = 49.53, ["Neon|Ride"] = 55.71, ["Mega|Fly|Ride"] = 825.23}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2966.25}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 152.16, ["Fly"] = 282.65, ["Ride"] = 196.88, ["Fly|Ride"] = 480.71, ["Neon"] = 701.37, ["Neon|Ride"] = 846.83, ["Neon|Fly|Ride"] = 757.15, ["Mega|Ride"] = 3019.26, ["Mega|Fly|Ride"] = 3026.47}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 157.5, ["Ride"] = 196.87, ["Fly|Ride"] = 211.32, ["Neon"] = 607.35, ["Neon|Ride"] = 619.84, ["Neon|Fly|Ride"] = 1435.35, ["Mega|Ride"] = 2751.06, ["Mega|Fly|Ride"] = 2751.06}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 168, ["Fly"] = 186.38, ["Ride"] = 196.88, ["Fly|Ride"] = 236.25, ["Neon"] = 897.75, ["Neon|Fly"] = 960.36, ["Neon|Ride"] = 840, ["Neon|Fly|Ride"] = 813.75, ["Mega|Fly|Ride"] = 3712.44}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1640.52, ["Fly"] = 2475.64, ["Ride"] = 1574.99, ["Fly|Ride"] = 1677.33, ["Neon"] = 6825.37, ["Neon|Ride"] = 5878.6, ["Neon|Fly|Ride"] = 4265.63, ["Mega|Fly|Ride"] = 30945.36}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 15.75, ["Fly"] = 80.48, ["Ride"] = 39.41, ["Fly|Ride"] = 93.89, ["Neon"] = 155.77, ["Neon|Ride"] = 192.91, ["Neon|Fly|Ride"] = 322.88, ["Mega"] = 930.56, ["Mega|Ride"] = 894.33, ["Mega|Fly|Ride"] = 1084.14}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 786.19, ["Fly"] = 2100, ["Ride"] = 678.43, ["Fly|Ride"] = 887.11, ["Neon|Fly|Ride"] = 4032.75}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 36.73}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 14.43, ["Ride"] = 42, ["Fly|Ride"] = 681.8, ["Neon"] = 98.44, ["Neon|Ride"] = 123.53, ["Neon|Fly|Ride"] = 274.4, ["Mega"] = 459.27, ["Mega|Ride"] = 497.85, ["Mega|Fly|Ride"] = 549.94}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 7.76, ["Fly"] = 48.49, ["Ride"] = 26.75, ["Fly|Ride"] = 94.8, ["Neon"] = 52.5, ["Neon|Ride"] = 77.38, ["Neon|Fly|Ride"] = 262.5, ["Mega|Ride"] = 206.32, ["Mega|Fly|Ride"] = 621.14}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 57.06}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 19.68, ["Fly"] = 108.92, ["Ride"] = 31.28, ["Fly|Ride"] = 55.71, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 192.91, ["Mega"] = 918.75, ["Mega|Ride"] = 1241.13, ["Mega|Fly|Ride"] = 825.23}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 101.22, ["Fly"] = 39.38, ["Ride"] = 32.82, ["Fly|Ride"] = 52.06, ["Neon|Ride"] = 218.74, ["Neon|Fly|Ride"] = 309.47, ["Mega"] = 823.16, ["Mega|Ride"] = 1744.78, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6205.31, ["Fly"] = 10954.13, ["Ride"] = 4987.5, ["Fly|Ride"] = 4882.5, ["Neon|Fly|Ride"] = 10500, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 7.77, ["Fly"] = 46.4, ["Ride"] = 35.34, ["Fly|Ride"] = 88.06, ["Neon"] = 66.08, ["Neon|Ride"] = 77.44, ["Mega"] = 521.12, ["Mega|Ride"] = 512.98, ["Mega|Fly|Ride"] = 412.62}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 29.93}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 99.75, ["Fly"] = 365.17, ["Ride"] = 138.25, ["Fly|Ride"] = 144.38, ["Neon"] = 485.63, ["Neon|Ride"] = 517.13, ["Neon|Fly|Ride"] = 511.88, ["Mega|Fly|Ride"] = 1850.37}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 59.04, ["Fly"] = 96.48, ["Ride"] = 81.38, ["Fly|Ride"] = 152.25, ["Neon"] = 310.63, ["Neon|Ride"] = 282.19, ["Neon|Fly|Ride"] = 463.32, ["Mega"] = 2326.36, ["Mega|Ride"] = 2785.1, ["Mega|Fly|Ride"] = 1444.13}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 21.23, ["Fly"] = 70.45, ["Ride"] = 30.22, ["Fly|Ride"] = 45.94, ["Neon"] = 196.88, ["Neon|Ride"] = 160.94, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 737.55, ["Mega|Fly|Ride"] = 656.23}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 3.74, ["Fly"] = 55.71, ["Ride"] = 27.57, ["Fly|Ride"] = 82.55, ["Neon"] = 27.57, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 124.68, ["Mega"] = 157.49, ["Mega|Fly"] = 6877.11, ["Mega|Ride"] = 217.67, ["Mega|Fly|Ride"] = 297.94}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 11.21, ["Ride"] = 26.13, ["Fly|Ride"] = 96.97, ["Neon"] = 93.89, ["Neon|Ride"] = 136.18, ["Neon|Fly|Ride"] = 146.57, ["Mega"] = 486.89, ["Mega|Ride"] = 510.61, ["Mega|Fly|Ride"] = 561.75}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 20.99, ["Fly"] = 27.87, ["Ride"] = 27.57, ["Fly|Ride"] = 50.13, ["Neon"] = 204.26, ["Neon|Ride"] = 145.69, ["Neon|Fly|Ride"] = 131.25, ["Mega|Fly|Ride"] = 480.38}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 206.05}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 15.49, ["Ride"] = 128.63, ["Neon"] = 177.19, ["Mega"] = 525, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 629.43}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 206.32, ["Fly"] = 264.09, ["Ride"] = 443.63, ["Neon"] = 1100.64}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 39.38, ["Fly"] = 212, ["Ride"] = 82.55, ["Fly|Ride"] = 170.63, ["Neon"] = 249.36, ["Neon|Ride"] = 382.87, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 1306.94, ["Mega|Ride"] = 1293.53, ["Mega|Fly|Ride"] = 1217.21}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 917.44, ["Fly"] = 1152.97, ["Ride"] = 897.75, ["Fly|Ride"] = 918.75, ["Neon|Ride"] = 3163.65, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 11025}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 288.74, ["Fly"] = 465.35, ["Ride"] = 350.42, ["Fly|Ride"] = 393.73, ["Neon"] = 1181.25, ["Neon|Ride"] = 2017.33, ["Neon|Fly|Ride"] = 1926.88, ["Mega"] = 8132.25, ["Mega|Fly|Ride"] = 5773.69}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 61.91}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 3.94}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 14.44, ["Fly"] = 27.76, ["Ride"] = 18.38, ["Fly|Ride"] = 43.32, ["Neon"] = 78.73, ["Neon|Fly"] = 116.36, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 166.69, ["Mega"] = 437.26, ["Mega|Ride"] = 687.01, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 288.74, ["Fly"] = 762.36, ["Ride"] = 295.32, ["Fly|Ride"] = 387.21, ["Neon"] = 963.45, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 982.09, ["Mega|Ride"] = 3300.86, ["Mega|Fly|Ride"] = 2756.25}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 30.19}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 110.39, ["Fly"] = 266.14, ["Ride"] = 210, ["Fly|Ride"] = 311.3, ["Neon"] = 784.88, ["Neon|Fly"] = 1650.44, ["Neon|Ride"] = 820.32, ["Neon|Fly|Ride"] = 1031.52, ["Mega"] = 9902.52, ["Mega|Ride"] = 2947.5, ["Mega|Fly|Ride"] = 2572.5}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 131.25, ["Fly"] = 192.91, ["Ride"] = 131.25, ["Fly|Ride"] = 157.5, ["Neon"] = 674.63, ["Neon|Ride"] = 1005.38, ["Neon|Fly|Ride"] = 928.37}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 5.18, ["Ride"] = 27.87, ["Fly|Ride"] = 73.31, ["Neon"] = 30.18, ["Neon|Ride"] = 85.31, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 264.75, ["Mega|Ride"] = 220.5, ["Mega|Fly|Ride"] = 804.59}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 15.74, ["Fly"] = 63, ["Ride"] = 29.29, ["Fly|Ride"] = 76.27, ["Neon"] = 177.19, ["Neon|Ride"] = 110.39, ["Neon|Fly|Ride"] = 258.2, ["Mega|Ride"] = 802.53, ["Mega|Fly|Ride"] = 577.31}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 19.62, ["Fly"] = 102.31, ["Ride"] = 40.69, ["Fly|Ride"] = 128.84, ["Neon"] = 138.25, ["Neon|Ride"] = 130.87, ["Neon|Fly|Ride"] = 185.46, ["Mega"] = 462.95, ["Mega|Ride"] = 478.84, ["Mega|Fly|Ride"] = 685.82}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 4.99, ["Fly"] = 78.75, ["Ride"] = 49.87, ["Fly|Ride"] = 170.93, ["Neon"] = 24.04, ["Neon|Fly"] = 232.68, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 155.27, ["Mega"] = 153.57, ["Mega|Fly"] = 239.32, ["Mega|Ride"] = 184.16, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 241.5, ["Ride"] = 301.88, ["Fly|Ride"] = 262.5, ["Neon"] = 1595.77, ["Neon|Ride"] = 1458.91, ["Neon|Fly|Ride"] = 1286.38, ["Mega|Fly|Ride"] = 5226.68}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 101.1, ["Fly"] = 1050, ["Ride"] = 182.44, ["Fly|Ride"] = 287.93, ["Neon"] = 753.38, ["Neon|Ride"] = 630, ["Neon|Fly|Ride"] = 785.29, ["Mega"] = 2625, ["Mega|Ride"] = 3026.47, ["Mega|Fly|Ride"] = 2511.11}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 72.19, ["Fly"] = 167.45, ["Ride"] = 72.19, ["Fly|Ride"] = 185.69, ["Neon"] = 361.04, ["Neon|Ride"] = 407.47, ["Neon|Fly|Ride"] = 477.53, ["Mega|Fly|Ride"] = 1509.67}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 13.02, ["Ride"] = 58.24, ["Fly|Ride"] = 247.58, ["Neon|Ride"] = 591.02, ["Neon|Fly|Ride"] = 481.73, ["Mega|Ride"] = 618.93, ["Mega|Fly|Ride"] = 1650.44}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 15.6, ["Fly"] = 75.63, ["Ride"] = 34.9, ["Fly|Ride"] = 105, ["Neon"] = 77.44, ["Neon|Fly"] = 206.32, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 346.5, ["Mega|Fly"] = 525, ["Mega|Ride"] = 275.43, ["Mega|Fly|Ride"] = 450.21}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.69, ["Fly"] = 47.46, ["Ride"] = 18.18, ["Fly|Ride"] = 96.97, ["Neon"] = 19.37, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 130.71, ["Mega"] = 129.94, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 216.46}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 1078.7, ["Fly"] = 1082.72, ["Ride"] = 826.88, ["Fly|Ride"] = 971.25, ["Neon"] = 3047.98, ["Neon|Fly"] = 3413.41, ["Neon|Ride"] = 2852.62, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 7376.25}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 364.24, ["Ride"] = 393.75, ["Fly|Ride"] = 522.38, ["Neon|Ride"] = 2751.06, ["Neon|Fly|Ride"] = 1922.33, ["Mega"] = 10315.13, ["Mega|Fly|Ride"] = 8840.15}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 87.53, ["Fly"] = 138.25, ["Ride"] = 103.69, ["Fly|Ride"] = 183.62, ["Neon"] = 344.54, ["Neon|Ride"] = 288.84, ["Neon|Fly|Ride"] = 407.47, ["Mega"] = 1581.93, ["Mega|Ride"] = 2140.25, ["Mega|Fly|Ride"] = 1697.89}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 273, ["Ride"] = 300.18, ["Fly|Ride"] = 308.26, ["Neon|Fly|Ride"] = 1372.56, ["Mega"] = 10315.13, ["Mega|Fly|Ride"] = 4951.27}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 17.07, ["Fly"] = 138.25, ["Ride"] = 31.49, ["Fly|Ride"] = 71.5, ["Neon"] = 169.32, ["Neon|Ride"] = 103.17, ["Neon|Fly|Ride"] = 229.68, ["Mega|Fly|Ride"] = 775.85}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 220.88, ["Ride"] = 278.64, ["Fly|Ride"] = 547.84, ["Neon"] = 861.33, ["Neon|Ride"] = 881.95, ["Neon|Fly|Ride"] = 915.6, ["Mega"] = 4105.71, ["Mega|Ride"] = 4264.29, ["Mega|Fly|Ride"] = 3852.71}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 53.82, ["Fly"] = 76.13, ["Ride"] = 32.82, ["Fly|Ride"] = 122.14, ["Neon|Ride"] = 575.89, ["Neon|Fly|Ride"] = 550.85, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1674.75, ["Ride"] = 1673.16, ["Fly|Ride"] = 1648.37, ["Neon|Ride"] = 10859.09, ["Neon|Fly|Ride"] = 4400.44, ["Mega"] = 49512.58, ["Mega|Fly|Ride"] = 21868.06}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 18.38, ["Fly"] = 65, ["Ride"] = 38.07, ["Fly|Ride"] = 90.79, ["Neon"] = 61.69, ["Neon|Fly"] = 179.45, ["Neon|Ride"] = 93.09, ["Neon|Fly|Ride"] = 202.41, ["Mega"] = 249.63, ["Mega|Fly"] = 561.75, ["Mega|Ride"] = 279.57, ["Mega|Fly|Ride"] = 433.93}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 36.39, ["Fly"] = 119.1, ["Ride"] = 72.19, ["Fly|Ride"] = 160.13, ["Neon"] = 262.5, ["Neon|Ride"] = 279.56, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 821.09, ["Mega|Ride"] = 1009.86, ["Mega|Fly|Ride"] = 775.85}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 82.69, ["Fly"] = 91.85, ["Ride"] = 91.88, ["Fly|Ride"] = 103.91, ["Neon|Ride"] = 454.91, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 3437.01, ["Fly"] = 1312.5, ["Ride"] = 2316.57, ["Fly|Ride"] = 1312.49, ["Neon|Fly|Ride"] = 5583.26, ["Mega|Fly|Ride"] = 23263.53}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 480.77, ["Fly"] = 823.16, ["Ride"] = 597.27, ["Fly|Ride"] = 688.03, ["Neon"] = 2173.15, ["Neon|Fly|Ride"] = 2714.86, ["Mega|Fly|Ride"] = 13958.13}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 91.86, ["Ride"] = 152.25, ["Fly|Ride"] = 206.07, ["Neon"] = 444.29, ["Neon|Fly"] = 618.93, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 627.56, ["Mega"] = 4126.06, ["Mega|Ride"] = 2613.86, ["Mega|Fly|Ride"] = 2063.03}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 7.88, ["Fly"] = 41.28, ["Ride"] = 27.57, ["Fly|Ride"] = 52.5, ["Neon"] = 72.21, ["Neon|Fly"] = 138.25, ["Neon|Ride"] = 93.56, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 747.53, ["Mega|Fly|Ride"] = 1236.8}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 39.63, ["Ride"] = 48.43, ["Fly|Ride"] = 103.17, ["Neon"] = 204.75, ["Neon|Fly"] = 412.62, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 288.75, ["Mega|Ride"] = 1339.95, ["Mega|Fly|Ride"] = 1010.63}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 714.66, ["Ride"] = 820.32, ["Fly|Ride"] = 785.53, ["Neon"] = 3024.41, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2508.42, ["Mega|Fly|Ride"] = 15130.22}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 787.49}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 5250, ["Ride"] = 5584.08, ["Fly|Ride"] = 4423.13, ["Neon"] = 42000, ["Neon|Ride"] = 29564.17, ["Neon|Fly|Ride"] = 21181.08, ["Mega|Fly|Ride"] = 88023.04}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 181.13, ["Fly"] = 406.82, ["Ride"] = 247.58, ["Fly|Ride"] = 367.5, ["Neon"] = 1246.88, ["Neon|Fly|Ride"] = 2063.03, ["Mega"] = 5776.49, ["Mega|Fly|Ride"] = 5914.71}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 83.6, ["Ride"] = 82.55, ["Fly|Ride"] = 336, ["Neon"] = 412.62, ["Neon|Ride"] = 592.11, ["Neon|Fly|Ride"] = 1237.83, ["Mega|Fly|Ride"] = 2099.99}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 17.07, ["Fly"] = 96.87, ["Ride"] = 36.11, ["Fly|Ride"] = 118.63, ["Neon"] = 147, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 239.32, ["Mega"] = 659.15, ["Mega|Ride"] = 618.93, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 19.62, ["Fly"] = 39.38, ["Ride"] = 26.97, ["Fly|Ride"] = 49.88, ["Neon"] = 202.67, ["Neon|Fly"] = 275.43, ["Neon|Ride"] = 275.43, ["Neon|Fly|Ride"] = 138.25, ["Mega"] = 1312.5, ["Mega|Ride"] = 1590.6, ["Mega|Fly|Ride"] = 2186.82}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 17.07, ["Fly"] = 275.43, ["Ride"] = 37.23, ["Fly|Ride"] = 131.25, ["Neon"] = 105, ["Neon|Ride"] = 155.91, ["Neon|Fly|Ride"] = 181.56, ["Mega"] = 549.94, ["Mega|Ride"] = 511.88, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 3.94, ["Fly"] = 55.71, ["Ride"] = 19.69, ["Fly|Ride"] = 57.75, ["Neon"] = 22.32, ["Neon|Fly"] = 340.41, ["Neon|Ride"] = 46.5, ["Neon|Fly|Ride"] = 186.12, ["Mega"] = 210, ["Mega|Ride"] = 218.7, ["Mega|Fly|Ride"] = 357}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 23.62, ["Ride"] = 49.53, ["Fly|Ride"] = 183.75, ["Neon"] = 247.58, ["Neon|Fly"] = 825.23, ["Neon|Ride"] = 155.91, ["Neon|Fly|Ride"] = 307.4, ["Mega"] = 659.15, ["Mega|Ride"] = 1239, ["Mega|Fly|Ride"] = 943.85}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 313.6, ["Fly"] = 437.43, ["Ride"] = 341.44, ["Fly|Ride"] = 411.75, ["Neon"] = 1050, ["Neon|Fly"] = 1460.64, ["Neon|Ride"] = 1180.86, ["Neon|Fly|Ride"] = 1100.64, ["Mega"] = 7875, ["Mega|Fly"] = 4331.34, ["Mega|Ride"] = 3852.71, ["Mega|Fly|Ride"] = 3937.5}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 15.49, ["Fly|Ride"] = 45.4, ["Neon"] = 18.5, ["Neon|Ride"] = 32, ["Neon|Fly|Ride"] = 69.35, ["Mega"] = 131.25, ["Mega|Ride"] = 206.32, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 36.75, ["Fly"] = 88.25, ["Ride"] = 34.13, ["Fly|Ride"] = 127.92, ["Neon"] = 173.25, ["Neon|Fly"] = 388.57, ["Neon|Ride"] = 202.13, ["Neon|Fly|Ride"] = 247.88, ["Mega"] = 510.57, ["Mega|Fly"] = 825.23, ["Mega|Ride"] = 544.69, ["Mega|Fly|Ride"] = 609.79}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 759.72, ["Fly"] = 953.96, ["Ride"] = 767.81, ["Fly|Ride"] = 810.84, ["Neon|Ride"] = 1603.87, ["Neon|Fly|Ride"] = 1442.44, ["Mega|Fly|Ride"] = 4085.46}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 32.41, ["Fly"] = 91.88, ["Ride"] = 44.1, ["Fly|Ride"] = 72.11, ["Neon|Ride"] = 173.25, ["Neon|Fly|Ride"] = 266.54, ["Mega"] = 1575, ["Mega|Fly|Ride"] = 748.13}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 343.88, ["Fly"] = 380.61, ["Ride"] = 263.18, ["Fly|Ride"] = 321.71, ["Neon|Fly|Ride"] = 1091.36, ["Mega|Fly|Ride"] = 6877.11}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 145.67, ["Fly"] = 205.28, ["Ride"] = 154.21, ["Fly|Ride"] = 168.91, ["Neon"] = 627.29, ["Neon|Ride"] = 715.88, ["Neon|Fly|Ride"] = 633.36, ["Mega"] = 3879.21, ["Mega|Fly|Ride"] = 3150}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 649.69, ["Ride"] = 656.25, ["Fly|Ride"] = 767.96, ["Neon|Ride"] = 2599.43, ["Neon|Fly|Ride"] = 2422, ["Mega|Fly|Ride"] = 5906.25}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 19.69, ["Ride"] = 40.65, ["Fly|Ride"] = 91.92, ["Neon"] = 78.07, ["Neon|Fly"] = 279.23, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 267.54, ["Mega"] = 307.4, ["Mega|Ride"] = 310.57, ["Mega|Fly|Ride"] = 491.02}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 4084.49, ["Ride"] = 3018.75, ["Fly|Ride"] = 2992.5, ["Neon"] = 13185.39, ["Neon|Fly|Ride"] = 6562.5, ["Mega|Fly|Ride"] = 25058.25}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 110.25, ["Fly"] = 118.13, ["Ride"] = 126, ["Fly|Ride"] = 161.44, ["Neon"] = 380.63, ["Neon|Ride"] = 519.9, ["Neon|Fly|Ride"] = 419.47, ["Mega|Fly|Ride"] = 2407.56}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.63, ["Fly"] = 26.25, ["Ride"] = 18.4, ["Fly|Ride"] = 42.88, ["Neon"] = 20.65, ["Neon|Fly"] = 82.55, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 138.25, ["Mega"] = 196.88, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.82, ["Ride"] = 27.87, ["Fly|Ride"] = 58.19, ["Neon"] = 19.69, ["Neon|Ride"] = 53.82, ["Neon|Fly|Ride"] = 210, ["Mega"] = 161.44, ["Mega|Ride"] = 199.48, ["Mega|Fly|Ride"] = 238.56}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 72.21, ["Fly"] = 152.67, ["Ride"] = 39.38, ["Fly|Ride"] = 55.13, ["Neon"] = 272.24, ["Neon|Ride"] = 288.84, ["Neon|Fly|Ride"] = 236.25, ["Mega|Fly|Ride"] = 1128.75}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 984.38, ["Ride"] = 1087.23, ["Fly|Ride"] = 984.38}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 6221.24, ["Ride"] = 6980.1, ["Fly|Ride"] = 6299.99}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 22.32, ["Fly"] = 36.08, ["Ride"] = 26.24, ["Fly|Ride"] = 52.68, ["Neon|Ride"] = 144.8, ["Neon|Fly|Ride"] = 171.25, ["Mega"] = 2428.13, ["Mega|Fly|Ride"] = 761.25}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 15.59, ["Fly"] = 45.94, ["Ride"] = 32.9, ["Fly|Ride"] = 69.13, ["Neon"] = 94.4, ["Neon|Ride"] = 91.28, ["Neon|Fly|Ride"] = 150.93, ["Mega"] = 900.53, ["Mega|Ride"] = 613.01, ["Mega|Fly|Ride"] = 485.63}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 69.51, ["Fly"] = 96.97, ["Ride"] = 62.9, ["Fly|Ride"] = 104.98, ["Neon"] = 459.37, ["Neon|Ride"] = 330.1, ["Neon|Fly|Ride"] = 303.19, ["Mega|Ride"] = 1794.85, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 236.25, ["Fly"] = 310.63, ["Ride"] = 216.57, ["Fly|Ride"] = 304.32, ["Neon|Ride"] = 977.79, ["Neon|Fly|Ride"] = 1082.82, ["Mega"] = 10315.13, ["Mega|Fly|Ride"] = 3547.38}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.92, ["Ride"] = 32, ["Fly|Ride"] = 86.63, ["Neon"] = 20.79, ["Neon|Fly"] = 656.24, ["Neon|Ride"] = 92.86, ["Mega"] = 158.82, ["Mega|Ride"] = 163, ["Mega|Fly|Ride"] = 310.57}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 168.36, ["Fly"] = 259.44, ["Ride"] = 236.25, ["Fly|Ride"] = 328.13, ["Neon"] = 868.55, ["Neon|Ride"] = 825.23, ["Neon|Fly|Ride"] = 948.11, ["Mega|Fly|Ride"] = 3572.15}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 3.13, ["Fly"] = 26.25, ["Ride"] = 16.8, ["Fly|Ride"] = 49.53, ["Neon"] = 21.12, ["Neon|Fly"] = 123.03, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 465.28, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 247.11}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 203.44, ["Fly"] = 244.32, ["Ride"] = 246.64, ["Fly|Ride"] = 241.5, ["Neon|Ride"] = 1030.49, ["Neon|Fly|Ride"] = 1115.63, ["Mega"] = 10315.13, ["Mega|Ride"] = 4126.06, ["Mega|Fly|Ride"] = 4099.25}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 11.82, ["Fly"] = 70.4, ["Ride"] = 24.94, ["Fly|Ride"] = 61.9, ["Neon"] = 56.56, ["Neon|Fly"] = 295.51, ["Neon|Ride"] = 98.01, ["Neon|Fly|Ride"] = 194.91, ["Mega"] = 515.3, ["Mega|Ride"] = 577.66, ["Mega|Fly|Ride"] = 449.5}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.61, ["Ride"] = 21, ["Fly|Ride"] = 87.26, ["Neon"] = 7.88, ["Neon|Fly"] = 170.45, ["Neon|Ride"] = 44.26, ["Neon|Fly|Ride"] = 176.77, ["Mega"] = 78.75, ["Mega|Ride"] = 99.38, ["Mega|Fly|Ride"] = 202.19}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 32, ["Mega"] = 41.28, ["Mega|Ride"] = 136.4}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 3.82, ["Fly"] = 52.48, ["Ride"] = 26.25, ["Fly|Ride"] = 206.57, ["Neon"] = 6.13, ["Neon|Ride"] = 48.49, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 68.16, ["Mega|Fly"] = 155090.96, ["Mega|Ride"] = 96.89, ["Mega|Fly|Ride"] = 159.41}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 63, ["Fly"] = 137.29, ["Ride"] = 104.39, ["Fly|Ride"] = 175.08, ["Neon"] = 366.21, ["Neon|Ride"] = 384.46, ["Neon|Fly|Ride"] = 309.74, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 33.54, ["Ride"] = 15.65, ["Fly|Ride"] = 93.38, ["Neon"] = 8.27, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 129.94, ["Mega|Ride"] = 122.75, ["Mega|Fly|Ride"] = 257.24}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 24.93, ["Ride"] = 1050, ["Neon"] = 126.9, ["Neon|Ride"] = 248.07, ["Mega"] = 443.63, ["Mega|Ride"] = 581.6, ["Mega|Fly|Ride"] = 646.77}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.1, ["Neon|Ride"] = 44.5, ["Mega"] = 16.52, ["Mega|Ride"] = 53.66, ["Mega|Fly|Ride"] = 85.32}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 69.13, ["Ride"] = 14.6, ["Fly|Ride"] = 33.44, ["Neon"] = 2.1, ["Neon|Fly"] = 14.43, ["Neon|Ride"] = 11.36, ["Neon|Fly|Ride"] = 77.38, ["Mega"] = 13.13, ["Mega|Fly"] = 39.38, ["Mega|Ride"] = 17.57, ["Mega|Fly|Ride"] = 39.38}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Ride"] = 15.49, ["Fly|Ride"] = 41.28, ["Neon"] = 2.63, ["Neon|Fly"] = 20.65, ["Neon|Ride"] = 15.79, ["Neon|Fly|Ride"] = 40.69, ["Mega"] = 28.23, ["Mega|Fly"] = 155.32, ["Mega|Ride"] = 27.87, ["Mega|Fly|Ride"] = 97.13}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Ride"] = 33.64, ["Neon"] = 2.63, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 82.55, ["Mega"] = 13.13, ["Mega|Ride"] = 146.57}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 118.13, ["Ride"] = 18.38, ["Fly|Ride"] = 107.63, ["Neon"] = 3.94, ["Neon|Fly"] = 137.85, ["Neon|Ride"] = 20.99, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 21, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 41.28, ["Mega|Fly|Ride"] = 180.08}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 4.13, ["Neon|Fly|Ride"] = 204.26, ["Mega"] = 76.35, ["Mega|Ride"] = 96.97, ["Mega|Fly|Ride"] = 154.71}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 3.9, ["Fly"] = 65.24, ["Ride"] = 19.69, ["Fly|Ride"] = 61.9, ["Neon"] = 10.31, ["Neon|Fly"] = 59.06, ["Neon|Ride"] = 24.19, ["Neon|Fly|Ride"] = 74.46, ["Mega"] = 91.87, ["Mega|Fly"] = 186.24, ["Mega|Ride"] = 81.37, ["Mega|Fly|Ride"] = 151.23}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 47.46, ["Neon"] = 2.1, ["Neon|Ride"] = 78.66, ["Neon|Fly|Ride"] = 157.37, ["Mega"] = 14.42, ["Mega|Ride"] = 35.09, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 3.92, ["Fly|Ride"] = 524.99, ["Neon"] = 15.74, ["Mega"] = 138.25, ["Mega|Fly"] = 315, ["Mega|Ride"] = 344.54}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Ride"] = 27.76, ["Neon"] = 9.64, ["Neon|Ride"] = 26.75, ["Mega"] = 103.69, ["Mega|Fly|Ride"] = 537.62}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 3.93, ["Neon|Fly"] = 27.87, ["Neon|Ride"] = 26.77, ["Neon|Fly|Ride"] = 138.25, ["Mega"] = 20.16, ["Mega|Ride"] = 54.51, ["Mega|Fly|Ride"] = 131.14}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.68, ["Ride"] = 15.36, ["Fly|Ride"] = 30.15, ["Neon"] = 2.1, ["Neon|Fly"] = 35.44, ["Neon|Ride"] = 14.8, ["Neon|Fly|Ride"] = 30.92, ["Mega"] = 14.18, ["Mega|Fly"] = 36.75, ["Mega|Ride"] = 23.63, ["Mega|Fly|Ride"] = 59.84}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 3.94, ["Fly"] = 72.19, ["Ride"] = 229.69, ["Neon"] = 31.49, ["Neon|Ride"] = 140.95}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.24, ["Fly"] = 23.63, ["Ride"] = 18.38, ["Fly|Ride"] = 82.55, ["Neon"] = 2.62, ["Neon|Ride"] = 32, ["Neon|Fly|Ride"] = 105, ["Mega"] = 26.24, ["Mega|Fly"] = 78.75, ["Mega|Ride"] = 55.13, ["Mega|Fly|Ride"] = 131.02}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 3.94, ["Neon"] = 11.82, ["Neon|Fly|Ride"] = 138.25, ["Mega"] = 82.51, ["Mega|Ride"] = 148.99, ["Mega|Fly|Ride"] = 238.87}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.62, ["Fly"] = 262.49, ["Ride"] = 32.82, ["Fly|Ride"] = 187.76, ["Neon"] = 15.31, ["Neon|Fly|Ride"] = 138.25, ["Mega"] = 45.94, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 188.99}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 39.29, ["Ride"] = 15.49, ["Fly|Ride"] = 26.17, ["Neon"] = 2.1, ["Neon|Fly"] = 15.75, ["Neon|Ride"] = 12.8, ["Neon|Fly|Ride"] = 26.25, ["Mega"] = 15.75, ["Mega|Fly"] = 28.18, ["Mega|Ride"] = 22.32, ["Mega|Fly|Ride"] = 49.88}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 27.46, ["Ride"] = 19.69, ["Fly|Ride"] = 136.18, ["Neon"] = 14.33, ["Neon|Ride"] = 111.7, ["Neon|Fly|Ride"] = 101.1, ["Mega"] = 78.75, ["Mega|Ride"] = 154.16, ["Mega|Fly|Ride"] = 275.43}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 5.25, ["Fly"] = 41.28, ["Ride"] = 32.82, ["Fly|Ride"] = 58.46, ["Neon"] = 72.81, ["Neon|Ride"] = 48.09, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 236.25, ["Mega|Ride"] = 288.46, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 30.91, ["Ride"] = 12.9, ["Fly|Ride"] = 26.17, ["Neon"] = 3.93, ["Neon|Fly"] = 23.62, ["Neon|Ride"] = 15.49, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 25.6, ["Mega|Fly"] = 1312.5, ["Mega|Ride"] = 48.49, ["Mega|Fly|Ride"] = 98.44}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 3.91, ["Fly"] = 172.29, ["Ride"] = 31.5, ["Neon"] = 5.24, ["Neon|Ride"] = 41.28, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 38.66, ["Mega|Fly"] = 165.06, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 262.47}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.63, ["Ride"] = 26.81, ["Fly|Ride"] = 82.55, ["Neon"] = 5.16, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 310.57, ["Mega"] = 34.91, ["Mega|Ride"] = 138.25, ["Mega|Fly|Ride"] = 155.89}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 16.72, ["Neon"] = 2.39, ["Neon|Fly"] = 41.03, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 96.97, ["Mega"] = 14.43, ["Mega|Ride"] = 34.13, ["Mega|Fly|Ride"] = 121.74}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 96.97, ["Ride"] = 19.69, ["Fly|Ride"] = 42, ["Neon"] = 7.87, ["Neon|Fly"] = 52.02, ["Neon|Ride"] = 19.07, ["Neon|Fly|Ride"] = 73.5, ["Mega"] = 78.33, ["Mega|Ride"] = 81.38}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 68.25, ["Neon"] = 3.89, ["Neon|Ride"] = 43.31, ["Mega"] = 39.38, ["Mega|Fly|Ride"] = 249.37}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 28.77, ["Ride"] = 17.55, ["Fly|Ride"] = 47.25, ["Neon"] = 6.56, ["Neon|Fly"] = 79.98, ["Neon|Ride"] = 19.84, ["Neon|Fly|Ride"] = 83.98, ["Mega"] = 91.87, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 123.38}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 8.65, ["Ride"] = 39.38, ["Neon"] = 36.21, ["Mega"] = 133.88, ["Mega|Ride"] = 205.92, ["Mega|Fly|Ride"] = 825.23}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Fly"] = 25.77, ["Ride"] = 16.4, ["Fly|Ride"] = 82.55, ["Neon"] = 17.07, ["Neon|Fly"] = 104.16, ["Neon|Ride"] = 26.76, ["Neon|Fly|Ride"] = 65.62, ["Mega"] = 157.5, ["Mega|Ride"] = 145.48, ["Mega|Fly|Ride"] = 334.22}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 3.94, ["Fly"] = 22.45, ["Ride"] = 19.62, ["Fly|Ride"] = 36.75, ["Neon"] = 15.65, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 234.02, ["Mega|Fly"] = 411.58, ["Mega|Ride"] = 154.88, ["Mega|Fly|Ride"] = 195.53}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 110.93, ["Fly|Ride"] = 137.7, ["Neon"] = 55.1, ["Mega"] = 152.67, ["Mega|Ride"] = 176.4}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 14.44, ["Ride"] = 131.25, ["Neon"] = 103.17, ["Mega|Fly|Ride"] = 794.07}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 4.2, ["Ride"] = 64.89, ["Neon"] = 41.11, ["Neon|Ride"] = 125.71, ["Mega"] = 222.81, ["Mega|Ride"] = 273.67}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 5.25, ["Ride"] = 34.97, ["Fly|Ride"] = 152.67, ["Neon"] = 41.99, ["Neon|Ride"] = 64.62, ["Mega"] = 246.54, ["Mega|Ride"] = 280.23, ["Mega|Fly|Ride"] = 355.04}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.63, ["Neon|Ride"] = 64.98, ["Mega"] = 21, ["Mega|Ride"] = 138.25, ["Mega|Fly|Ride"] = 144.42}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 47.13}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 17.07, ["Fly"] = 21.95, ["Ride"] = 23.12, ["Fly|Ride"] = 41.6, ["Neon"] = 74.81, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 102.74, ["Mega"] = 294, ["Mega|Fly"] = 330.1, ["Mega|Ride"] = 516.47, ["Mega|Fly|Ride"] = 252.94}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 16.52, ["Neon"] = 2.88, ["Neon|Ride"] = 26.61, ["Mega"] = 27.8, ["Mega|Ride"] = 55.13, ["Mega|Fly|Ride"] = 129.94}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 23.73, ["Fly|Ride"] = 275.43, ["Neon"] = 6.57, ["Neon|Ride"] = 35.32, ["Neon|Fly|Ride"] = 404.88, ["Mega"] = 39.38, ["Mega|Ride"] = 57.75, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 5.25, ["Fly"] = 45.94, ["Ride"] = 19.62, ["Fly|Ride"] = 47.46, ["Neon"] = 7.16, ["Neon|Ride"] = 47.66, ["Neon|Fly|Ride"] = 115.88, ["Mega"] = 125.23, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 161.65}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 3.83, ["Ride"] = 40.44, ["Fly|Ride"] = 58.82, ["Neon"] = 28.87, ["Neon|Ride"] = 82.55, ["Neon|Fly|Ride"] = 192.91, ["Mega"] = 325.98, ["Mega|Ride"] = 292.97, ["Mega|Fly|Ride"] = 412.62}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Ride"] = 32.81, ["Neon"] = 3.67, ["Neon|Ride"] = 48.49, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 14.44, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 55.13, ["Mega|Fly|Ride"] = 90.79}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 18.58, ["Ride"] = 16.05, ["Fly|Ride"] = 275070.15, ["Neon"] = 6.19, ["Neon|Fly"] = 69.01, ["Neon|Ride"] = 27.93, ["Neon|Fly|Ride"] = 69.35, ["Mega"] = 26.84, ["Mega|Fly"] = 143.16, ["Mega|Ride"] = 45.94, ["Mega|Fly|Ride"] = 104.9}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 27.37, ["Ride"] = 15.75, ["Fly|Ride"] = 34.13, ["Neon"] = 7.85, ["Neon|Fly"] = 69.13, ["Neon|Ride"] = 15.64, ["Neon|Fly|Ride"] = 52.48, ["Mega"] = 26.24, ["Mega|Ride"] = 51.34, ["Mega|Fly|Ride"] = 158.29}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 210, ["Ride"] = 51.18, ["Fly|Ride"] = 138.45, ["Neon"] = 3.9, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 110.39, ["Mega"] = 17.46, ["Mega|Fly"] = 103.17, ["Mega|Ride"] = 70.17, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 3.83, ["Neon|Ride"] = 164.38, ["Neon|Fly|Ride"] = 122.76, ["Mega"] = 82.55, ["Mega|Fly"] = 106.32, ["Mega|Ride"] = 86.63, ["Mega|Fly|Ride"] = 200.12}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 32.44, ["Ride"] = 18.17, ["Fly|Ride"] = 77.38, ["Neon"] = 3.93, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 20.15, ["Neon|Fly|Ride"] = 76.78, ["Mega"] = 32.82, ["Mega|Ride"] = 36.14, ["Mega|Fly|Ride"] = 118.02}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 2.37, ["Mega"] = 21, ["Mega|Ride"] = 124.37}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.34, ["Neon|Ride"] = 155.6, ["Neon|Fly|Ride"] = 420, ["Mega"] = 23.45, ["Mega|Ride"] = 122.76, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 27.57, ["Ride"] = 15.49, ["Fly|Ride"] = 49.87, ["Neon"] = 4.03, ["Neon|Ride"] = 19.62, ["Neon|Fly|Ride"] = 136.49, ["Mega"] = 26.23, ["Mega|Ride"] = 52.6}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 18.5, ["Ride"] = 137.54, ["Neon"] = 123.8, ["Neon|Fly|Ride"] = 257.08, ["Mega"] = 547.75, ["Mega|Ride"] = 426.57, ["Mega|Fly|Ride"] = 550.85}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 6.04, ["Fly"] = 6562.5, ["Ride"] = 68.25, ["Neon"] = 49.26, ["Neon|Ride"] = 204.26, ["Mega"] = 1571, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 7.59, ["Ride"] = 26.24, ["Fly|Ride"] = 410.92, ["Neon"] = 34.79, ["Mega"] = 295.25, ["Mega|Ride"] = 109.35, ["Mega|Fly|Ride"] = 365.3}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 12.55, ["Ride"] = 12.85, ["Fly|Ride"] = 23.63, ["Neon"] = 2.1, ["Neon|Fly"] = 14.58, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 32.82, ["Mega"] = 14.44, ["Mega|Fly"] = 32.87, ["Mega|Ride"] = 22.32, ["Mega|Fly|Ride"] = 51.19}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Fly"] = 118.12, ["Ride"] = 65.63, ["Neon"] = 10.34, ["Neon|Fly"] = 89.46, ["Neon|Ride"] = 32, ["Neon|Fly|Ride"] = 688.03, ["Mega"] = 85.31, ["Mega|Ride"] = 114.52, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Ride"] = 31.49, ["Neon"] = 2.1, ["Neon|Fly"] = 30.83, ["Neon|Ride"] = 20.69, ["Neon|Fly|Ride"] = 77.38, ["Mega"] = 15.74, ["Mega|Fly"] = 82.32, ["Mega|Fly|Ride"] = 103.69}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Ride"] = 91.92, ["Neon"] = 3.29, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 103.17, ["Mega"] = 20.48, ["Mega|Ride"] = 96.97, ["Mega|Fly|Ride"] = 152.67}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 34.08, ["Ride"] = 19.19, ["Fly|Ride"] = 45.92, ["Neon"] = 9.32, ["Neon|Ride"] = 41.28, ["Neon|Fly|Ride"] = 88.73, ["Mega"] = 183.65, ["Mega|Ride"] = 192.91, ["Mega|Fly|Ride"] = 348.96}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 205.5, ["Ride"] = 262.5, ["Fly|Ride"] = 825.23, ["Neon"] = 1050, ["Neon|Ride"] = 822.94, ["Mega"] = 8252.11, ["Mega|Fly|Ride"] = 3256.92}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Ride"] = 27.87, ["Neon"] = 8.52, ["Neon|Fly"] = 41.28, ["Neon|Ride"] = 82.55, ["Mega"] = 61.68, ["Mega|Ride"] = 93.08, ["Mega|Fly|Ride"] = 825.23}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 6.49, ["Fly"] = 62.39, ["Ride"] = 24.8, ["Neon"] = 20.65, ["Neon|Ride"] = 164.29, ["Neon|Fly|Ride"] = 155.77, ["Mega"] = 354.38, ["Mega|Fly|Ride"] = 399.2}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 825.23, ["Ride"] = 15.26, ["Fly|Ride"] = 30.19, ["Neon"] = 9.19, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 30.18, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 49.66, ["Mega|Ride"] = 78.16, ["Mega|Fly|Ride"] = 171.25}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 51.19, ["Ride"] = 19.68, ["Fly|Ride"] = 92.54, ["Neon"] = 5.25, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 95.82, ["Mega|Ride"] = 136.5, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 3.5, ["Fly"] = 17.75, ["Ride"] = 16.45, ["Fly|Ride"] = 35.42, ["Neon"] = 22.71, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 71.1, ["Mega|Ride"] = 262.02, ["Mega|Fly|Ride"] = 412.62}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 3.61, ["Ride"] = 34.01, ["Fly|Ride"] = 249.58, ["Neon"] = 45.94, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 612.73, ["Mega"] = 249.38, ["Mega|Ride"] = 307.4, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 3.15, ["Fly"] = 19.55, ["Ride"] = 15.16, ["Fly|Ride"] = 31.5, ["Neon"] = 18.17, ["Neon|Fly"] = 68.72, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 73.5, ["Mega|Fly|Ride"] = 201.71}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 65.63, ["Fly"] = 169.18, ["Ride"] = 102.38, ["Fly|Ride"] = 150.94, ["Neon"] = 441.51, ["Neon|Fly"] = 410.82, ["Neon|Ride"] = 405.57, ["Neon|Fly|Ride"] = 383.25, ["Mega|Fly|Ride"] = 1644.57}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 196.88, ["Fly"] = 329.53, ["Ride"] = 231.25, ["Fly|Ride"] = 275.43, ["Neon"] = 1008.63, ["Neon|Ride"] = 1444.13, ["Neon|Fly|Ride"] = 963.45, ["Mega"] = 10315.13, ["Mega|Fly|Ride"] = 3975.46}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 69.13, ["Fly"] = 137.67, ["Ride"] = 77.97, ["Fly|Ride"] = 118.13, ["Neon"] = 412.11, ["Neon|Ride"] = 328.01, ["Neon|Fly|Ride"] = 354.38, ["Mega|Fly|Ride"] = 1821.54}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 3.94, ["Fly"] = 26.25, ["Ride"] = 25.88, ["Fly|Ride"] = 138.25, ["Neon"] = 24.93, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 140.44, ["Mega"] = 234.17, ["Mega|Ride"] = 374.07, ["Mega|Fly|Ride"] = 506.48}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 10.5, ["Fly"] = 69.13, ["Ride"] = 19.57, ["Fly|Ride"] = 89.25, ["Neon"] = 31.5, ["Neon|Ride"] = 136.18, ["Neon|Fly|Ride"] = 179.5, ["Mega"] = 334.22, ["Mega|Ride"] = 364.53, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 31.49, ["Ride"] = 18.38, ["Fly|Ride"] = 40.22, ["Neon"] = 2.63, ["Neon|Fly"] = 70.85, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 65.62, ["Mega"] = 87.94, ["Mega|Fly"] = 154.88, ["Mega|Ride"] = 74.28, ["Mega|Fly|Ride"] = 177.44}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 10.47, ["Fly"] = 27.87, ["Ride"] = 27.87, ["Fly|Ride"] = 300.03, ["Neon"] = 55.71, ["Neon|Ride"] = 158.82, ["Neon|Fly|Ride"] = 136.28, ["Mega"] = 917.03, ["Mega|Ride"] = 614.8, ["Mega|Fly|Ride"] = 864.94}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 41.1, ["Ride"] = 16.46, ["Fly|Ride"] = 55.71, ["Neon"] = 13.13, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 30.96, ["Neon|Fly|Ride"] = 103.63, ["Mega"] = 131.25, ["Mega|Ride"] = 200.79, ["Mega|Fly|Ride"] = 202.41}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 2.63, ["Ride"] = 23.26, ["Fly|Ride"] = 328.13, ["Neon"] = 29.93, ["Neon|Ride"] = 55.71, ["Mega"] = 207.37, ["Mega|Ride"] = 192.91, ["Mega|Fly|Ride"] = 371.98}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 34.35, ["Ride"] = 36.11, ["Neon"] = 2.1, ["Neon|Ride"] = 19.66, ["Neon|Fly|Ride"] = 47.38, ["Mega"] = 18.38, ["Mega|Ride"] = 50.55, ["Mega|Fly|Ride"] = 209371.75}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 3.75, ["Fly"] = 19.59, ["Ride"] = 17.75, ["Fly|Ride"] = 39.38, ["Neon"] = 12.9, ["Neon|Fly"] = 103.17, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 69.13, ["Mega"] = 84, ["Mega|Ride"] = 107.98, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.39, ["Fly"] = 24.93, ["Ride"] = 18.48, ["Fly|Ride"] = 45.94, ["Neon"] = 24.94, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 110.39, ["Mega"] = 283.5, ["Mega|Ride"] = 206.32, ["Mega|Fly|Ride"] = 222.17}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 164.41, ["Fly"] = 232.68, ["Ride"] = 196.88, ["Fly|Ride"] = 248.25, ["Neon"] = 794.58, ["Neon|Ride"] = 708.67, ["Neon|Fly|Ride"] = 720.57, ["Mega|Fly|Ride"] = 2745.6}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 7.83, ["Ride"] = 30.19, ["Fly|Ride"] = 205.28, ["Neon"] = 49.88, ["Neon|Ride"] = 160.13, ["Neon|Fly|Ride"] = 376.56, ["Mega"] = 341.44, ["Mega|Ride"] = 323.37, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.63, ["Fly"] = 15.49, ["Ride"] = 15.75, ["Fly|Ride"] = 43.32, ["Neon"] = 30.17, ["Neon|Ride"] = 35.09, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 288.75, ["Mega|Ride"] = 213.94, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 18.38, ["Ride"] = 41.32, ["Fly|Ride"] = 170.63, ["Neon"] = 121.66, ["Neon|Ride"] = 148.32, ["Neon|Fly|Ride"] = 441.27, ["Mega"] = 453.14, ["Mega|Fly"] = 825.23, ["Mega|Ride"] = 469.88, ["Mega|Fly|Ride"] = 709.55}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 5.96}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 3.29, ["Ride"] = 25.57, ["Neon"] = 25.31, ["Neon|Ride"] = 275.42, ["Neon|Fly|Ride"] = 618.93, ["Mega"] = 386.84, ["Mega|Ride"] = 296.63, ["Mega|Fly|Ride"] = 823.16}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 23.63, ["Fly"] = 77.67, ["Ride"] = 28.87, ["Fly|Ride"] = 56.43, ["Neon"] = 179.5, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 162.63, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 2063.03, ["Mega|Fly|Ride"] = 1373.99}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Fly|Ride"] = 78.75, ["Neon"] = 3.84, ["Neon|Ride"] = 39.36, ["Neon|Fly|Ride"] = 106.24, ["Mega"] = 31.49, ["Mega|Ride"] = 68.86, ["Mega|Fly|Ride"] = 205.28}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 4.2, ["Fly"] = 27.69, ["Ride"] = 26.77, ["Fly|Ride"] = 61.9, ["Neon"] = 45.34, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 232.7, ["Mega"] = 231.48, ["Mega|Fly"] = 388.52, ["Mega|Ride"] = 165.38, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 15.75, ["Fly|Ride"] = 27.87, ["Neon"] = 11.81, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 30.65, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 137.82, ["Mega|Ride"] = 138.27, ["Mega|Fly|Ride"] = 209.84}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 36.11, ["Neon"] = 3.74, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 30.96, ["Neon|Fly|Ride"] = 412.62, ["Mega"] = 30.18, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 198.07}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 37.9, ["Ride"] = 105.24, ["Neon"] = 251.7, ["Neon|Ride"] = 295.52, ["Neon|Fly|Ride"] = 581.63, ["Mega"] = 935.82, ["Mega|Ride"] = 1039.78, ["Mega|Fly|Ride"] = 833.44}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.95, ["Ride"] = 59.07, ["Fly|Ride"] = 210, ["Neon"] = 80.29, ["Mega|Ride"] = 524.99}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 7.59, ["Fly"] = 96.97, ["Ride"] = 33, ["Fly|Ride"] = 62.48, ["Neon"] = 73.5, ["Neon|Fly"] = 465.36, ["Neon|Ride"] = 103.01, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 576.62, ["Mega|Ride"] = 309.47, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 57.66, ["Fly"] = 433.13, ["Ride"] = 172.29, ["Fly|Ride"] = 262.44, ["Neon"] = 436.27, ["Neon|Ride"] = 412.62, ["Neon|Fly|Ride"] = 688.03, ["Mega"] = 1747.39, ["Mega|Ride"] = 2034.38, ["Mega|Fly|Ride"] = 1739.15}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 10.49, ["Fly"] = 45.94, ["Ride"] = 30.58, ["Fly|Ride"] = 62.84, ["Neon"] = 53.82, ["Neon|Ride"] = 67.59, ["Neon|Fly|Ride"] = 138.25, ["Mega"] = 209.9, ["Mega|Ride"] = 239.04, ["Mega|Fly|Ride"] = 273.76}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 70.88, ["Fly"] = 143.07, ["Ride"] = 104.19, ["Neon"] = 183.75, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 407.47, ["Mega"] = 992.66, ["Mega|Ride"] = 1019.16, ["Mega|Fly|Ride"] = 935.55}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 18.69, ["Ride"] = 55.71, ["Fly|Ride"] = 131.24, ["Neon"] = 82.69, ["Neon|Ride"] = 148.67, ["Neon|Fly|Ride"] = 264.06, ["Mega"] = 343.88, ["Mega|Fly"] = 330.1, ["Mega|Ride"] = 304.5, ["Mega|Fly|Ride"] = 407.88}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 10.01, ["Ride"] = 27.57, ["Fly|Ride"] = 41.28, ["Neon"] = 69.13, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 369.9, ["Mega"] = 416.96, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 18.24, ["Ride"] = 109.15, ["Fly|Ride"] = 154.76, ["Neon"] = 90.55, ["Neon|Ride"] = 110.59, ["Neon|Fly|Ride"] = 275.43, ["Mega"] = 255.2, ["Mega|Fly"] = 498.24, ["Mega|Ride"] = 302.34, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 7.12, ["Ride"] = 26.25, ["Fly|Ride"] = 136.18, ["Neon"] = 26.24, ["Neon|Ride"] = 69.56, ["Mega"] = 411.89, ["Mega|Ride"] = 299.51, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 53.66, ["Neon|Ride"] = 56.44, ["Mega"] = 17.73, ["Mega|Fly"] = 138.25, ["Mega|Ride"] = 103.17, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 3.71, ["Ride"] = 27.26, ["Neon"] = 18.76, ["Neon|Fly"] = 123.8, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 202.78, ["Mega"] = 95.71, ["Mega|Ride"] = 160.94, ["Mega|Fly|Ride"] = 262.02}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.63, ["Fly"] = 62.84, ["Neon"] = 23.63, ["Mega"] = 183.81, ["Mega|Ride"] = 138.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 5.16, ["Ride"] = 32.79, ["Fly|Ride"] = 115.18, ["Neon"] = 17.76, ["Neon|Ride"] = 81.51, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 200.12, ["Mega|Ride"] = 274.32, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 564.37, ["Ride"] = 576.18, ["Fly|Ride"] = 616.88, ["Neon"] = 1710.27, ["Neon|Fly"] = 1803.26, ["Neon|Ride"] = 1498.29, ["Neon|Fly|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 5890.5}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 7.79, ["Fly"] = 27.75, ["Ride"] = 23.28, ["Fly|Ride"] = 59.84, ["Neon"] = 26.25, ["Neon|Ride"] = 96.97, ["Neon|Fly|Ride"] = 210, ["Mega|Ride"] = 412.62, ["Mega|Fly|Ride"] = 483.89}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 9.05, ["Fly"] = 39.38, ["Ride"] = 15.75, ["Fly|Ride"] = 51.35, ["Neon"] = 76.12, ["Neon|Fly"] = 315, ["Neon|Ride"] = 54.7, ["Mega"] = 307.4, ["Mega|Ride"] = 303.8, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 2.35, ["Ride"] = 22.71, ["Fly|Ride"] = 309.47, ["Neon|Ride"] = 138.25, ["Mega"] = 253.58, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 64.97, ["Ride"] = 24.35, ["Fly|Ride"] = 90.57, ["Neon"] = 7.87, ["Neon|Ride"] = 41.28, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 68.62, ["Mega|Fly"] = 170.63, ["Mega|Ride"] = 111.99, ["Mega|Fly|Ride"] = 205.28}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 69.13, ["Ride"] = 18.58, ["Neon"] = 2.63, ["Neon|Ride"] = 24.05, ["Neon|Fly|Ride"] = 73.25, ["Mega"] = 23.62, ["Mega|Ride"] = 77.44, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1107.75}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 7.69, ["Ride"] = 41.28, ["Fly|Ride"] = 69.13, ["Neon"] = 65, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 179.5, ["Mega"] = 399.2, ["Mega|Ride"] = 412.62, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 28.26, ["Neon"] = 5.15, ["Neon|Ride"] = 40.69, ["Mega"] = 38.75, ["Mega|Ride"] = 154.74, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.63, ["Fly"] = 27.57, ["Ride"] = 58.49, ["Fly|Ride"] = 575.6, ["Neon"] = 10.5, ["Neon|Fly"] = 123.8, ["Neon|Ride"] = 109.78, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 152.67, ["Mega|Ride"] = 251.7, ["Mega|Fly|Ride"] = 310.57}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 459.38, ["Ride"] = 484.12, ["Fly|Ride"] = 534.19, ["Neon|Ride"] = 1311.18, ["Neon|Fly|Ride"] = 1254.88, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 5.82, ["Fly"] = 196.88, ["Neon"] = 110.39, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 206.32, ["Mega"] = 470.38, ["Mega|Ride"] = 442.02}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 30.96, ["Fly|Ride"] = 152.67, ["Neon"] = 5.99, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 145.69, ["Mega"] = 40.69, ["Mega|Fly"] = 189, ["Mega|Ride"] = 110.25, ["Mega|Fly|Ride"] = 191.88}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 109.85, ["Neon|Fly|Ride"] = 262.02, ["Mega"] = 23.73, ["Mega|Ride"] = 113.67, ["Mega|Fly|Ride"] = 218.67}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 11.81, ["Fly"] = 107.63, ["Ride"] = 61.69, ["Fly|Ride"] = 178.5, ["Neon"] = 101.75, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 330.1, ["Mega"] = 450.16, ["Mega|Ride"] = 399.2, ["Mega|Fly|Ride"] = 595.88}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 7.88, ["Neon"] = 109.37, ["Neon|Ride"] = 123.8, ["Neon|Fly|Ride"] = 200.08, ["Mega"] = 412.62, ["Mega|Ride"] = 482.34, ["Mega|Fly|Ride"] = 1100.64}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 7.87, ["Fly|Ride"] = 138.25, ["Neon"] = 118.13, ["Neon|Ride"] = 175.69, ["Mega"] = 636.27, ["Mega|Ride"] = 959.05, ["Mega|Fly|Ride"] = 1237.83}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 13.02, ["Ride"] = 26.84, ["Neon"] = 118.13, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 206.32, ["Mega"] = 524.99, ["Mega|Ride"] = 618.93, ["Mega|Fly|Ride"] = 665.44}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 313.69, ["Fly"] = 465.35, ["Ride"] = 428.09, ["Fly|Ride"] = 616.88, ["Neon"] = 1648.37, ["Neon|Ride"] = 1443.75, ["Neon|Fly|Ride"] = 1155, ["Mega|Ride"] = 3573.18, ["Mega|Fly|Ride"] = 3852.71}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 9.33, ["Fly"] = 69.65, ["Ride"] = 23.63, ["Fly|Ride"] = 96.97, ["Neon"] = 106.01, ["Neon|Ride"] = 138.25, ["Neon|Fly|Ride"] = 158.87, ["Mega"] = 688.03, ["Mega|Ride"] = 410.55, ["Mega|Fly|Ride"] = 849.98}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 3.83, ["Fly|Ride"] = 78.75, ["Neon"] = 35.17, ["Neon|Ride"] = 221.82, ["Mega"] = 131.25, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 775.85}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 15.74, ["Ride"] = 60.88, ["Fly|Ride"] = 257.11, ["Neon"] = 52.49, ["Neon|Ride"] = 122.85, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 272.35, ["Mega|Fly"] = 688.03, ["Mega|Ride"] = 281.63, ["Mega|Fly|Ride"] = 342.03}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.24, ["Fly"] = 40.69, ["Ride"] = 42, ["Fly|Ride"] = 138.25, ["Neon"] = 6.35, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 138.25, ["Mega"] = 44.62, ["Mega|Fly"] = 105, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 303.19}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 38.07, ["Ride"] = 91.88, ["Fly|Ride"] = 157.5, ["Neon"] = 308.44, ["Neon|Ride"] = 304.32, ["Neon|Fly|Ride"] = 464.2, ["Mega"] = 1788.66, ["Mega|Ride"] = 1293.53, ["Mega|Fly|Ride"] = 1043.07}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.63, ["Fly"] = 56.44, ["Ride"] = 28.25, ["Neon"] = 10.5, ["Neon|Fly"] = 156.97, ["Neon|Ride"] = 41.11, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 68.77, ["Mega|Ride"] = 101.07, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 20.65, ["Ride"] = 29.89, ["Fly|Ride"] = 148.25, ["Neon"] = 4.49, ["Neon|Fly"] = 49.39, ["Neon|Ride"] = 49.53, ["Neon|Fly|Ride"] = 132.05, ["Mega"] = 41.28, ["Mega|Ride"] = 73.5, ["Mega|Fly|Ride"] = 180.28}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Fly"] = 1519.88, ["Ride"] = 27.87, ["Fly|Ride"] = 123.33, ["Neon"] = 13.13, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 78.75, ["Mega|Fly"] = 459.38, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 270.38}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 62.9, ["Ride"] = 78.74, ["Neon"] = 291.38, ["Neon|Ride"] = 509.25, ["Mega|Ride"] = 1031.52, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 288.84, ["Ride"] = 309.74, ["Fly|Ride"] = 393.75, ["Neon"] = 1433.82, ["Neon|Ride"] = 1139.14, ["Neon|Fly|Ride"] = 1036.88, ["Mega"] = 6189.08, ["Mega|Fly|Ride"] = 5211.22}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 5.1, ["Fly|Ride"] = 184.25, ["Neon"] = 26.25, ["Mega"] = 103.35, ["Mega|Ride"] = 179.47, ["Mega|Fly|Ride"] = 307.4}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 3.93, ["Ride"] = 28.46, ["Neon"] = 17.47, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 138.25, ["Mega"] = 47.25, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 337.33}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 2.63, ["Fly"] = 30.26, ["Ride"] = 27.56, ["Fly|Ride"] = 175.38, ["Neon"] = 36.75, ["Mega|Ride"] = 341.29, ["Mega|Fly|Ride"] = 346.5}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 4.25, ["Fly"] = 58.92, ["Ride"] = 34.26, ["Neon"] = 7.67, ["Neon|Ride"] = 36.19, ["Neon|Fly|Ride"] = 137.91, ["Mega"] = 84.36, ["Mega|Fly"] = 146.49, ["Mega|Ride"] = 107.52, ["Mega|Fly|Ride"] = 236.24}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 67.93, ["Neon"] = 8.89, ["Mega"] = 36.75, ["Mega|Fly|Ride"] = 272.33}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 65.54, ["Ride"] = 16.71, ["Fly|Ride"] = 41.99, ["Neon"] = 6.57, ["Neon|Ride"] = 23.62, ["Neon|Fly|Ride"] = 98.01, ["Mega"] = 44.18, ["Mega|Ride"] = 77.38, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 138.25, ["Ride"] = 20.65, ["Fly|Ride"] = 54.49, ["Neon"] = 8.97, ["Neon|Fly"] = 62.39, ["Neon|Ride"] = 31.43, ["Neon|Fly|Ride"] = 62.83, ["Mega"] = 156.15, ["Mega|Ride"] = 232.11, ["Mega|Fly|Ride"] = 437.07}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 26.17, ["Ride"] = 52.42, ["Fly|Ride"] = 77.16, ["Neon"] = 179.5, ["Neon|Fly|Ride"] = 288.48, ["Mega"] = 576.62, ["Mega|Ride"] = 472.5, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 62.99, ["Fly"] = 123.8, ["Ride"] = 78.75, ["Fly|Ride"] = 127.92, ["Neon"] = 412.62, ["Neon|Ride"] = 389.82, ["Neon|Fly|Ride"] = 465.28, ["Mega"] = 1470, ["Mega|Ride"] = 1512.21, ["Mega|Fly|Ride"] = 1499.84}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Fly"] = 34.92, ["Ride"] = 20.65, ["Fly|Ride"] = 131.25, ["Neon"] = 6.56, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 138.25, ["Mega"] = 38.75, ["Mega|Fly"] = 672, ["Mega|Ride"] = 65.49, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 16.46, ["Ride"] = 15.72, ["Fly|Ride"] = 20.65, ["Neon"] = 5.16, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 17.52, ["Neon|Fly|Ride"] = 55.71, ["Mega"] = 51.85, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 2.1, ["Ride"] = 73.48, ["Fly|Ride"] = 131.25, ["Neon"] = 247.58, ["Neon|Ride"] = 39.57, ["Neon|Fly|Ride"] = 274.4, ["Mega"] = 275.09, ["Mega|Ride"] = 412.62, ["Mega|Fly|Ride"] = 636.57}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 387.19, ["Fly"] = 393.75, ["Ride"] = 543.62, ["Fly|Ride"] = 498.75, ["Neon|Ride"] = 1788.66, ["Neon|Fly|Ride"] = 1115.63, ["Mega|Fly|Ride"] = 6824.37}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 24.94, ["Fly"] = 93.89, ["Ride"] = 53.52, ["Fly|Ride"] = 124.49, ["Neon"] = 82.55, ["Neon|Ride"] = 166.76, ["Neon|Fly|Ride"] = 305.78, ["Mega|Ride"] = 1030.49, ["Mega|Fly|Ride"] = 944.98}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 281.29, ["Neon"] = 9.18, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 169.31, ["Mega"] = 89.14, ["Mega|Ride"] = 133.62, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 205.82, ["Ride"] = 65.63, ["Fly|Ride"] = 142.7, ["Neon"] = 20.65}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 26.76, ["Fly"] = 76.35, ["Ride"] = 43.28, ["Fly|Ride"] = 82.55, ["Neon|Ride"] = 138.25, ["Neon|Fly|Ride"] = 527.63, ["Mega"] = 2475.64, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1241.13}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 96.5, ["Ride"] = 92.73, ["Fly|Ride"] = 152.67, ["Neon"] = 544.66, ["Neon|Ride"] = 470.38, ["Neon|Fly|Ride"] = 481.73, ["Mega"] = 8252.11, ["Mega|Fly|Ride"] = 1877.37}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 195.57, ["Fly"] = 308.44, ["Ride"] = 275.43, ["Fly|Ride"] = 504.92, ["Neon"] = 825.23, ["Neon|Ride"] = 811.81, ["Neon|Fly|Ride"] = 1100.64, ["Mega|Fly|Ride"] = 3420.51}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 14.44, ["Ride"] = 41.28, ["Fly|Ride"] = 150.94, ["Neon"] = 73.5, ["Neon|Ride"] = 119.17, ["Neon|Fly|Ride"] = 224.88, ["Mega"] = 383.29, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 418.24}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 27.87, ["Ride"] = 14.49, ["Fly|Ride"] = 40.62, ["Neon"] = 7.55, ["Neon|Ride"] = 21.62, ["Neon|Fly|Ride"] = 63, ["Mega"] = 86.09, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 165.38}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 6.35, ["Fly"] = 19.69, ["Ride"] = 19.36, ["Fly|Ride"] = 51.59, ["Neon"] = 30.75, ["Neon|Fly"] = 144.42, ["Neon|Ride"] = 51.59, ["Neon|Fly|Ride"] = 118.65, ["Mega"] = 334.22, ["Mega|Ride"] = 321.84, ["Mega|Fly|Ride"] = 411.58}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 328.13, ["Fly"] = 481.73, ["Ride"] = 326.82, ["Fly|Ride"] = 412.62, ["Neon"] = 1312.5, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1649.82, ["Mega|Fly|Ride"] = 5739.13}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 60.74, ["Neon"] = 9.19, ["Neon|Ride"] = 55.71, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 48.06, ["Mega|Ride"] = 234.17}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 5.16, ["Ride"] = 14.44, ["Fly|Ride"] = 26.25, ["Neon"] = 21.18, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 77.96, ["Mega"] = 179.5, ["Mega|Fly"] = 204.9, ["Mega|Ride"] = 186.12, ["Mega|Fly|Ride"] = 247.58}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 13.13, ["Ride"] = 117.6, ["Neon"] = 84, ["Neon|Fly"] = 412.62, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 388.52, ["Mega"] = 475.08, ["Mega|Ride"] = 547.75, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 127.32, ["Fly"] = 157.5, ["Ride"] = 118.9, ["Fly|Ride"] = 154.88, ["Neon|Ride"] = 698.06, ["Neon|Fly|Ride"] = 611.02, ["Mega|Fly|Ride"] = 2172.83}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 15.64, ["Fly"] = 48.49, ["Ride"] = 27.57, ["Fly|Ride"] = 59.06, ["Neon"] = 85.32, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 205.97, ["Mega"] = 633.36, ["Mega|Ride"] = 507.66, ["Mega|Fly|Ride"] = 488.38}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 49.53, ["Neon"] = 2.5, ["Neon|Ride"] = 310.64, ["Neon|Fly|Ride"] = 688.03, ["Mega"] = 20.79, ["Mega|Ride"] = 272.33, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 52.5, ["Neon"] = 2.63, ["Neon|Ride"] = 20.65, ["Neon|Fly|Ride"] = 69.21, ["Mega"] = 24.94, ["Mega|Fly"] = 87.25, ["Mega|Ride"] = 51.19, ["Mega|Fly|Ride"] = 122.76}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 11.01, ["Fly"] = 412.62, ["Ride"] = 64.87, ["Fly|Ride"] = 165.06, ["Neon"] = 38.07, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 187.69, ["Mega"] = 151.33, ["Mega|Fly"] = 275.43, ["Mega|Ride"] = 188.98, ["Mega|Fly|Ride"] = 324.18}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1446.38, ["Ride"] = 1311.54, ["Fly|Ride"] = 1291.5, ["Neon"] = 4200, ["Neon|Ride"] = 3675, ["Neon|Fly|Ride"] = 3675, ["Mega|Fly|Ride"] = 11353.13}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 446.25, ["Ride"] = 481.69, ["Fly|Ride"] = 518.44, ["Neon"] = 1788.66, ["Neon|Ride"] = 1706.15, ["Neon|Fly|Ride"] = 2046.53, ["Mega"] = 16504.21, ["Mega|Fly|Ride"] = 9201.1}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 330.14, ["Ride"] = 357, ["Fly|Ride"] = 410.82, ["Neon"] = 654.78, ["Neon|Fly"] = 1241.3, ["Neon|Ride"] = 643.1, ["Neon|Fly|Ride"] = 786.19, ["Mega|Fly|Ride"] = 2362.4}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 318.94, ["Fly"] = 410.68, ["Ride"] = 301.88, ["Fly|Ride"] = 433.13, ["Neon"] = 1072.79, ["Neon|Fly"] = 1376.05, ["Neon|Ride"] = 968.63, ["Neon|Fly|Ride"] = 1054.44, ["Mega|Fly|Ride"] = 4536.6}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 57.16, ["Ride"] = 18.27, ["Fly|Ride"] = 31.5, ["Neon"] = 5.79, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 82.55, ["Mega"] = 62.66, ["Mega|Ride"] = 108.86, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 360.94, ["Ride"] = 443.63, ["Fly|Ride"] = 403.7, ["Neon"] = 1680, ["Neon|Ride"] = 1509.38, ["Neon|Fly|Ride"] = 1968.75, ["Mega|Ride"] = 5815.9, ["Mega|Fly|Ride"] = 4331.25}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 2.61, ["Fly"] = 183.75, ["Ride"] = 27.87, ["Neon"] = 10.32, ["Neon|Ride"] = 65, ["Neon|Fly|Ride"] = 155.81, ["Mega"] = 74.82, ["Mega|Ride"] = 91.68, ["Mega|Fly|Ride"] = 272.33}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 26.84, ["Ride"] = 20.65, ["Fly|Ride"] = 39.38, ["Neon"] = 7.88, ["Neon|Ride"] = 52.62, ["Neon|Fly|Ride"] = 104.97, ["Mega"] = 104.9, ["Mega|Ride"] = 192.93}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 39.37, ["Mega"] = 18.38, ["Mega|Ride"] = 196.88}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 33.69, ["Ride"] = 109.24, ["Fly|Ride"] = 459.38, ["Neon"] = 210, ["Neon|Ride"] = 420, ["Mega|Ride"] = 930.56}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 7756.05, ["Ride"] = 21, ["Fly|Ride"] = 60.44, ["Neon"] = 26.25, ["Neon|Ride"] = 77.97, ["Mega"] = 328.13, ["Mega|Ride"] = 304.32, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.13, ["Neon"] = 3.94, ["Neon|Fly"] = 118.55, ["Neon|Ride"] = 35.11, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 22.19, ["Mega|Ride"] = 155.3, ["Mega|Fly|Ride"] = 114.54}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 3.82, ["Fly"] = 36.01, ["Ride"] = 22.71, ["Fly|Ride"] = 62.84, ["Neon"] = 8.07, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 30.96, ["Neon|Fly|Ride"] = 82.67, ["Mega"] = 82.43, ["Mega|Fly"] = 172.29, ["Mega|Ride"] = 116.58, ["Mega|Fly|Ride"] = 170.93}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 3.42, ["Fly"] = 55.71, ["Ride"] = 27.93, ["Fly|Ride"] = 70.08, ["Neon"] = 27.57, ["Neon|Fly"] = 96.97, ["Neon|Ride"] = 138.25, ["Neon|Fly|Ride"] = 246.11, ["Mega"] = 237.57, ["Mega|Ride"] = 300.51, ["Mega|Fly|Ride"] = 310.57}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 10.31, ["Ride"] = 52.5, ["Neon"] = 56.44, ["Neon|Fly|Ride"] = 264.06, ["Mega"] = 371.37, ["Mega|Ride"] = 426.89, ["Mega|Fly|Ride"] = 412.62}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 7.88, ["Fly"] = 6205.31, ["Ride"] = 26.84, ["Neon"] = 34.94, ["Neon|Ride"] = 138.18, ["Neon|Fly|Ride"] = 275.43, ["Mega"] = 439.03, ["Mega|Ride"] = 714, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 15.74, ["Ride"] = 18.38, ["Fly|Ride"] = 45.94, ["Neon"] = 5.44, ["Neon|Fly"] = 27.87, ["Neon|Ride"] = 15.49, ["Mega"] = 80.49, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 155.71, ["Fly"] = 227.98, ["Ride"] = 197.04, ["Fly|Ride"] = 223.13, ["Neon|Ride"] = 2578.79, ["Neon|Fly|Ride"] = 1086.42, ["Mega"] = 8252.11, ["Mega|Fly|Ride"] = 4198.58}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 15.02, ["Ride"] = 14.44, ["Fly|Ride"] = 32, ["Neon"] = 6.2, ["Neon|Fly"] = 27.87, ["Neon|Ride"] = 18.27, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 31.42, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 122.07}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 13.13, ["Ride"] = 69.46, ["Fly|Ride"] = 183.73, ["Neon"] = 83.77, ["Neon|Ride"] = 123.27, ["Mega"] = 465.28, ["Mega|Ride"] = 399.2, ["Mega|Fly|Ride"] = 528.14}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 32.82, ["Fly"] = 210, ["Ride"] = 191.94, ["Fly|Ride"] = 167.23, ["Neon"] = 185.69, ["Neon|Ride"] = 273.41, ["Mega"] = 825.23, ["Mega|Ride"] = 853.08}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 208.69, ["Ride"] = 236.15, ["Fly|Ride"] = 262.5, ["Neon"] = 708.73, ["Neon|Fly"] = 1163.4, ["Neon|Ride"] = 757.38, ["Neon|Fly|Ride"] = 740.64, ["Mega|Fly|Ride"] = 3018.65}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 13.12, ["Ride"] = 37.43, ["Fly|Ride"] = 139.62, ["Neon"] = 123.38, ["Neon|Ride"] = 275.43, ["Mega"] = 287.44, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 1237.83}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 119.6, ["Ride"] = 118.33, ["Fly|Ride"] = 525, ["Neon"] = 131.25, ["Neon|Ride"] = 199.5, ["Mega"] = 463.68, ["Mega|Ride"] = 550.85, ["Mega|Fly|Ride"] = 932.5}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 1186.27, ["Ride"] = 1048.69, ["Fly|Ride"] = 1211.97, ["Neon"] = 4814.09, ["Neon|Ride"] = 5906.25, ["Neon|Fly|Ride"] = 4413.38, ["Mega|Fly|Ride"] = 17191.18}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 7.88, ["Fly"] = 29.4, ["Ride"] = 19.56, ["Fly|Ride"] = 42, ["Neon"] = 20.56, ["Neon|Fly"] = 79.91, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 206.32, ["Mega"] = 272.21, ["Mega|Ride"] = 230.04, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 5.25, ["Fly"] = 65.63, ["Ride"] = 41.28, ["Neon"] = 30.24, ["Neon|Ride"] = 91.92, ["Mega"] = 218.28, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 238.88, ["Mega|Fly|Ride"] = 268.21}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.63, ["Fly"] = 81.51, ["Ride"] = 18.58, ["Fly|Ride"] = 69.57, ["Neon"] = 15.49, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 39.22, ["Mega"] = 91.85, ["Mega|Ride"] = 136.89, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 15.75, ["Fly"] = 55.71, ["Ride"] = 37.24, ["Fly|Ride"] = 116.12, ["Neon"] = 65.63, ["Neon|Ride"] = 82.55, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 321.84, ["Mega|Ride"] = 310.57, ["Mega|Fly|Ride"] = 467.76}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 3.15, ["Fly"] = 21, ["Ride"] = 18.47, ["Fly|Ride"] = 28.88, ["Neon"] = 19.64, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 31.29, ["Neon|Fly|Ride"] = 88.7, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.62, ["Ride"] = 36.11, ["Neon"] = 9.19, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 56.25, ["Neon|Fly|Ride"] = 825.23, ["Mega"] = 105, ["Mega|Fly"] = 275.43, ["Mega|Ride"] = 185.69, ["Mega|Fly|Ride"] = 328.04}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 258.79, ["Ride"] = 418.82, ["Fly|Ride"] = 550.85, ["Neon|Fly|Ride"] = 984.38}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 3.73, ["Fly"] = 25.46, ["Ride"] = 18.38, ["Fly|Ride"] = 72.19, ["Neon"] = 9.28, ["Neon|Fly"] = 82.55, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 119.84, ["Mega"] = 78.75, ["Mega|Ride"] = 110.25, ["Mega|Fly|Ride"] = 242.01}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 5.21, ["Ride"] = 27.87, ["Fly|Ride"] = 88.87, ["Neon"] = 77.42, ["Neon|Fly"] = 196.88, ["Mega|Ride"] = 330.1, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 3.3, ["Fly"] = 91.25, ["Ride"] = 26.17, ["Neon"] = 11.71, ["Neon|Ride"] = 27.87, ["Neon|Fly|Ride"] = 275.43, ["Mega"] = 85.32, ["Mega|Fly"] = 138.25, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 356.9}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 314.2, ["Ride"] = 325.76, ["Fly|Ride"] = 1036.23, ["Neon"] = 853.92, ["Neon|Ride"] = 816.38, ["Neon|Fly|Ride"] = 1146.91, ["Mega"] = 4652.72, ["Mega|Ride"] = 4951.27, ["Mega|Fly|Ride"] = 2789.41}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 22.32, ["Fly"] = 60.88, ["Ride"] = 148.56, ["Fly|Ride"] = 146.49, ["Neon"] = 123.64, ["Neon|Ride"] = 179.5, ["Neon|Fly|Ride"] = 393.75, ["Mega|Ride"] = 630, ["Mega|Fly|Ride"] = 838.69}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 19.63, ["Ride"] = 26.25, ["Fly|Ride"] = 138.25, ["Neon"] = 83.91, ["Neon|Ride"] = 123.38, ["Neon|Fly|Ride"] = 258.92, ["Mega"] = 502.37, ["Mega|Ride"] = 497.05, ["Mega|Fly|Ride"] = 451.5}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 3.84, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 44.18, ["Mega"] = 35.82, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 224.88}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 61.05, ["Fly"] = 87.47, ["Ride"] = 84, ["Fly|Ride"] = 157.5, ["Neon"] = 262.48, ["Neon|Fly"] = 303.14, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 328.1, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 18.38, ["Neon"] = 5.25, ["Neon|Ride"] = 55.71, ["Neon|Fly|Ride"] = 588, ["Mega"] = 48.98, ["Mega|Fly|Ride"] = 411.58}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 16.78, ["Fly"] = 124.49, ["Ride"] = 30.96, ["Fly|Ride"] = 79.77, ["Neon"] = 42, ["Neon|Ride"] = 109.24, ["Neon|Fly|Ride"] = 247.58, ["Mega"] = 393.75, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 46.33, ["Fly"] = 110.06, ["Ride"] = 79.94, ["Fly|Ride"] = 110.39, ["Neon"] = 182.6, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 377.91, ["Mega|Ride"] = 1319.32, ["Mega|Fly|Ride"] = 1134.7}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 13.88, ["Fly|Ride"] = 35.42, ["Neon"] = 2.1, ["Neon|Fly"] = 23.97, ["Neon|Ride"] = 16.52, ["Neon|Fly|Ride"] = 40.51, ["Mega"] = 18.37, ["Mega|Fly"] = 116.32, ["Mega|Ride"] = 31.5, ["Mega|Fly|Ride"] = 76.8}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 3.94, ["Fly"] = 32.82, ["Ride"] = 35.09, ["Fly|Ride"] = 131.25, ["Neon"] = 14.11, ["Neon|Ride"] = 59.84, ["Neon|Fly|Ride"] = 168, ["Mega"] = 157.5, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 418.04}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 15.74, ["Fly"] = 138.25, ["Ride"] = 36.75, ["Fly|Ride"] = 62.84, ["Neon"] = 140.77, ["Neon|Ride"] = 133.88, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 547.75, ["Mega|Ride"] = 551.15, ["Mega|Fly|Ride"] = 814.92}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 26.78, ["Neon"] = 2.63, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 95.8, ["Mega"] = 20.64, ["Mega|Ride"] = 48.49, ["Mega|Fly|Ride"] = 206.32}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 14.44, ["Fly"] = 210, ["Ride"] = 55.55, ["Fly|Ride"] = 124.49, ["Neon"] = 29.93, ["Neon|Ride"] = 137.45, ["Neon|Fly|Ride"] = 186.12, ["Mega"] = 550.85, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 344.54}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 10.48, ["Fly"] = 27.83, ["Ride"] = 21, ["Fly|Ride"] = 98.44, ["Neon"] = 224.88, ["Neon|Ride"] = 118.78, ["Neon|Fly|Ride"] = 117.6, ["Mega|Ride"] = 354.38, ["Mega|Fly|Ride"] = 435.05}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 3.84, ["Ride"] = 52.5, ["Neon"] = 26.25, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 68.98, ["Mega"] = 170.63, ["Mega|Ride"] = 232.32, ["Mega|Fly|Ride"] = 372.23}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 21.31, ["Fly"] = 2063.03, ["Ride"] = 66.92, ["Fly|Ride"] = 196.83, ["Neon"] = 62.67, ["Neon|Ride"] = 110.39, ["Neon|Fly|Ride"] = 6203.24, ["Mega"] = 295.32, ["Mega|Ride"] = 544.69, ["Mega|Fly|Ride"] = 575.79}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.58, ["Fly"] = 41.28, ["Ride"] = 138.25, ["Fly|Ride"] = 196.87, ["Neon"] = 6.45, ["Neon|Fly"] = 55.71, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 103.17, ["Mega"] = 65.63, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 138.25}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 69.13, ["Neon"] = 2.63, ["Neon|Ride"] = 89.17, ["Mega"] = 30.09, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 215.67}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 47.46}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 40.68, ["Fly"] = 78.75, ["Ride"] = 70.88, ["Neon"] = 179.5, ["Neon|Ride"] = 204.53, ["Neon|Fly|Ride"] = 550.15, ["Mega"] = 1229.59, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 889.88}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Mega"] = 22.31, ["Mega|Ride"] = 165.06, ["Mega|Fly|Ride"] = 309.47}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 388.5, ["Fly"] = 563.22, ["Ride"] = 446.25, ["Fly|Ride"] = 641.82, ["Neon"] = 2625, ["Neon|Fly|Ride"] = 2251.08, ["Mega"] = 16504.21, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 6.56, ["Fly"] = 25.99, ["Ride"] = 39.37, ["Fly|Ride"] = 66.26, ["Neon"] = 25.1, ["Neon|Ride"] = 275.43, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 69.13, ["Mega|Fly"] = 148.56, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 550.85}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.63, ["Fly"] = 26.25, ["Ride"] = 21.26, ["Fly|Ride"] = 63, ["Neon"] = 16.21, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 99.65, ["Mega"] = 163, ["Mega|Ride"] = 176.4, ["Mega|Fly|Ride"] = 411.9}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 14.83, ["Fly"] = 77.38, ["Ride"] = 69.82, ["Fly|Ride"] = 106.32, ["Neon"] = 65, ["Neon|Ride"] = 179.18, ["Mega"] = 757.15, ["Mega|Ride"] = 437.07, ["Mega|Fly|Ride"] = 572.51}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 3.39, ["Fly"] = 316.68, ["Ride"] = 32.48, ["Fly|Ride"] = 721.88, ["Mega"] = 255.94}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 13.77, ["Fly"] = 139.53, ["Ride"] = 105, ["Fly|Ride"] = 157.49, ["Neon"] = 82.47, ["Neon|Ride"] = 103.17, ["Mega"] = 342.85, ["Mega|Ride"] = 400.98, ["Mega|Fly|Ride"] = 468.33}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 7.66, ["Fly"] = 105, ["Ride"] = 32.82, ["Fly|Ride"] = 185.69, ["Neon"] = 41.28, ["Neon|Ride"] = 100.7, ["Neon|Fly|Ride"] = 138.25, ["Mega"] = 216.57, ["Mega|Fly"] = 480.71, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 39.57, ["Ride"] = 15.31, ["Fly|Ride"] = 66.94, ["Neon"] = 2.1, ["Neon|Fly"] = 41.99, ["Neon|Ride"] = 15.26, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 13.13, ["Mega|Fly"] = 61.9, ["Mega|Ride"] = 35.39, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 8.65, ["Fly"] = 275.43, ["Ride"] = 27.57, ["Fly|Ride"] = 48.49, ["Neon"] = 28.65, ["Neon|Ride"] = 69.13, ["Neon|Fly|Ride"] = 110.52, ["Mega"] = 194.25, ["Mega|Ride"] = 206.32, ["Mega|Fly|Ride"] = 412.62}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 261.19, ["Fly"] = 298.86, ["Ride"] = 328.12, ["Fly|Ride"] = 421.31, ["Neon"] = 1456.51, ["Neon|Ride"] = 1404.38, ["Neon|Fly|Ride"] = 1048.69, ["Mega|Fly|Ride"] = 4219.93}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 86.63, ["Ride"] = 164.03, ["Fly|Ride"] = 295.51, ["Neon"] = 315, ["Neon|Ride"] = 380.63, ["Neon|Fly|Ride"] = 480.96, ["Mega"] = 1628.47, ["Mega|Ride"] = 1437.95, ["Mega|Fly|Ride"] = 1551.69}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 17.04, ["Ride"] = 22.12, ["Fly|Ride"] = 28.51, ["Neon"] = 15.49, ["Neon|Fly"] = 69.13, ["Neon|Ride"] = 33.03, ["Neon|Fly|Ride"] = 62.56, ["Mega"] = 138.25, ["Mega|Fly"] = 205.28, ["Mega|Ride"] = 123.8, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 18.88, ["Ride"] = 13.88, ["Fly|Ride"] = 31.5, ["Neon"] = 4.14, ["Neon|Fly"] = 39.15, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 49.87, ["Mega"] = 69.56, ["Mega|Fly"] = 344.03, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.63, ["Ride"] = 22.32, ["Fly|Ride"] = 98.44, ["Neon"] = 38.07, ["Neon|Fly|Ride"] = 412.62, ["Mega"] = 138.25, ["Mega|Ride"] = 247.58, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 248.07, ["Fly"] = 420, ["Ride"] = 298.43, ["Fly|Ride"] = 375.38, ["Neon|Ride"] = 1788.66, ["Neon|Fly|Ride"] = 1306.94, ["Mega|Ride"] = 8252.11, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 3.78, ["Fly"] = 24.77, ["Ride"] = 15.65, ["Fly|Ride"] = 43.34, ["Neon"] = 21.26, ["Neon|Fly"] = 77.44, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 101, ["Mega"] = 255.94, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 3.82, ["Fly"] = 155.91, ["Ride"] = 98.44, ["Fly|Ride"] = 206.32, ["Neon"] = 19.62, ["Neon|Ride"] = 139.13, ["Mega"] = 247.58, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 311.85}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 3.92, ["Neon|Ride"] = 137.71, ["Mega"] = 62.89, ["Mega|Ride"] = 93.08}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 12.55, ["Fly"] = 36.11, ["Ride"] = 26.25, ["Fly|Ride"] = 57.23, ["Neon"] = 79.28, ["Neon|Ride"] = 109.15, ["Neon|Fly|Ride"] = 231, ["Mega"] = 728.44, ["Mega|Ride"] = 354.38, ["Mega|Fly|Ride"] = 656.15}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 54.56, ["Fly"] = 155.91, ["Ride"] = 92.58, ["Fly|Ride"] = 196.87, ["Neon"] = 118.12, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 207.86, ["Neon|Fly|Ride"] = 309.47, ["Mega"] = 446.25, ["Mega|Fly"] = 2166.2, ["Mega|Ride"] = 456.07, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 27.43, ["Fly"] = 69.13, ["Ride"] = 48.09, ["Fly|Ride"] = 100.08, ["Neon"] = 157.4, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 185.88, ["Neon|Fly|Ride"] = 197.38, ["Mega|Ride"] = 742.71, ["Mega|Fly|Ride"] = 930.56}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 20.52, ["Ride"] = 14.89, ["Fly|Ride"] = 27.57, ["Neon"] = 2.63, ["Neon|Fly"] = 23.63, ["Neon|Ride"] = 17.06, ["Neon|Fly|Ride"] = 36.75, ["Mega"] = 19.67, ["Mega|Fly"] = 412.51, ["Mega|Ride"] = 48.42, ["Mega|Fly|Ride"] = 107.29}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 233, ["Ride"] = 287.76, ["Fly|Ride"] = 309.47, ["Neon"] = 1376.05, ["Neon|Ride"] = 1004.71, ["Neon|Fly|Ride"] = 1048.26, ["Mega|Fly|Ride"] = 4401.48}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 14.44, ["Fly"] = 82.55, ["Ride"] = 55.71, ["Fly|Ride"] = 131.02, ["Neon"] = 96.55, ["Neon|Ride"] = 116.36, ["Neon|Fly|Ride"] = 328.12, ["Mega"] = 412.62, ["Mega|Ride"] = 441.51, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 34, ["Ride"] = 15.6, ["Fly|Ride"] = 39.38, ["Neon"] = 10.47, ["Neon|Fly"] = 36.75, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 109.36, ["Mega"] = 59.33, ["Mega|Fly"] = 275.43, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 139.59}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 30.96, ["Ride"] = 18.58, ["Fly|Ride"] = 43.72, ["Neon"] = 2.62, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 24.93, ["Neon|Fly|Ride"] = 102.8, ["Mega"] = 24.93, ["Mega|Fly"] = 138.25, ["Mega|Ride"] = 46.27, ["Mega|Fly|Ride"] = 155.89}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 3.7, ["Ride"] = 27.28, ["Fly|Ride"] = 69.29, ["Neon"] = 9.38, ["Neon|Ride"] = 62.84, ["Neon|Fly|Ride"] = 6866.86, ["Mega"] = 104.9, ["Mega|Ride"] = 128.63, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 12.55, ["Fly"] = 38.74, ["Ride"] = 22.23, ["Fly|Ride"] = 70.5, ["Neon"] = 49.23, ["Neon|Fly"] = 262.02, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 123.38, ["Mega"] = 331.27, ["Mega|Ride"] = 321.57, ["Mega|Fly|Ride"] = 385.27}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 6.92, ["Fly"] = 55.71, ["Ride"] = 39.38, ["Fly|Ride"] = 72.19, ["Neon"] = 52.5, ["Neon|Ride"] = 136.18, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 268.21, ["Mega|Ride"] = 337.33, ["Mega|Fly|Ride"] = 372.23}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 6.15, ["Neon|Ride"] = 41.66, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 18.38, ["Mega|Ride"] = 68.16, ["Mega|Fly|Ride"] = 127.32}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 9.07, ["Ride"] = 28.88, ["Fly|Ride"] = 65.63, ["Neon"] = 35.09, ["Neon|Fly"] = 102.8, ["Neon|Ride"] = 64.31, ["Neon|Fly|Ride"] = 135.33, ["Mega"] = 157.5, ["Mega|Ride"] = 212.62, ["Mega|Fly|Ride"] = 299.16}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 111.99, ["Neon"] = 3.94, ["Neon|Fly"] = 96.97, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 102.3, ["Mega"] = 17.46, ["Mega|Ride"] = 91.35, ["Mega|Fly|Ride"] = 310.57}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 38.83, ["Ride"] = 20.65, ["Fly|Ride"] = 61.85, ["Neon"] = 5.16, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 87.33, ["Mega"] = 48.05, ["Mega|Ride"] = 82.69, ["Mega|Fly|Ride"] = 234.94}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 672, ["Ride"] = 754.69, ["Fly|Ride"] = 787.5, ["Neon|Ride"] = 3150, ["Neon|Fly|Ride"] = 3113.79, ["Mega|Fly|Ride"] = 12653.58}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 15.73, ["Ride"] = 14.44, ["Fly|Ride"] = 34.99, ["Neon"] = 46.55, ["Neon|Fly"] = 55.73, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 61.69, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 3.94, ["Ride"] = 36.75, ["Fly|Ride"] = 210, ["Neon"] = 14.44, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 62.91, ["Neon|Fly|Ride"] = 138.25, ["Mega"] = 39.38, ["Mega|Ride"] = 116.82, ["Mega|Fly|Ride"] = 303.7}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 10.18, ["Fly"] = 32.71, ["Ride"] = 24.04, ["Fly|Ride"] = 47.25, ["Neon"] = 47.25, ["Neon|Fly"] = 123.8, ["Neon|Ride"] = 60.8, ["Neon|Fly|Ride"] = 107.06, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 376.69}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 19.59, ["Ride"] = 13.13, ["Fly|Ride"] = 30.19, ["Neon"] = 9.19, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 24.77, ["Neon|Fly|Ride"] = 45.48, ["Mega"] = 70.88, ["Mega|Ride"] = 88.13, ["Mega|Fly|Ride"] = 164.91}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 104.99, ["Ride"] = 63, ["Fly|Ride"] = 206.32, ["Neon"] = 255.94, ["Neon|Ride"] = 257.44, ["Mega"] = 1169.75, ["Mega|Fly|Ride"] = 1100.64}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 18.58, ["Neon"] = 10.5, ["Neon|Fly"] = 132.64, ["Neon|Ride"] = 27.87, ["Neon|Fly|Ride"] = 119.43, ["Mega"] = 57.74, ["Mega|Ride"] = 119.44, ["Mega|Fly|Ride"] = 357.12}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 3.56, ["Fly"] = 73.5, ["Ride"] = 22.32, ["Fly|Ride"] = 60.88, ["Neon"] = 11.96, ["Neon|Fly"] = 138.25, ["Neon|Ride"] = 42, ["Mega"] = 123.38, ["Mega|Ride"] = 225.61, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.63, ["Fly|Ride"] = 59.07, ["Neon"] = 9.18, ["Neon|Fly"] = 62.84, ["Neon|Ride"] = 78.75, ["Mega"] = 93.5, ["Mega|Fly"] = 412.62, ["Mega|Ride"] = 172.16, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 18.38, ["Fly|Ride"] = 97.84, ["Neon"] = 5.25, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 23.47, ["Neon|Fly|Ride"] = 65.01, ["Mega"] = 44.63, ["Mega|Fly"] = 220.5, ["Mega|Ride"] = 52.41, ["Mega|Fly|Ride"] = 179.5}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 12.32, ["Fly"] = 23.63, ["Ride"] = 20.65, ["Fly|Ride"] = 45.4, ["Neon"] = 137.82, ["Neon|Ride"] = 68.24, ["Neon|Fly|Ride"] = 96.15, ["Mega"] = 825.23, ["Mega|Ride"] = 514.75, ["Mega|Fly|Ride"] = 456.37}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 695.62, ["Ride"] = 758.63, ["Fly|Ride"] = 837.44, ["Neon"] = 2028.53, ["Neon|Ride"] = 1745.63, ["Neon|Fly|Ride"] = 1903.13, ["Mega"] = 7977.74, ["Mega|Ride"] = 7217.44, ["Mega|Fly|Ride"] = 6247.5}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 16.05, ["Ride"] = 15.49, ["Fly|Ride"] = 47.24, ["Neon"] = 3.7, ["Neon|Fly"] = 138.25, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 60.36, ["Mega"] = 49.88, ["Mega|Ride"] = 134.11, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 6.15, ["Ride"] = 27.87, ["Fly|Ride"] = 77.44, ["Neon|Fly"] = 138.25, ["Neon|Ride"] = 107.04, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 287.05, ["Mega|Ride"] = 315}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 60.53, ["Ride"] = 74.15, ["Fly|Ride"] = 105, ["Neon"] = 295.32, ["Neon|Ride"] = 375.85, ["Neon|Fly|Ride"] = 433.25, ["Mega"] = 3150.32, ["Mega|Fly|Ride"] = 2332.32}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 31.5, ["Fly"] = 124.49, ["Ride"] = 56.44, ["Fly|Ride"] = 102.79, ["Neon"] = 105, ["Neon|Ride"] = 148.56, ["Mega"] = 1926.88, ["Mega|Ride"] = 669.38, ["Mega|Fly|Ride"] = 729.39}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 12.78, ["Ride"] = 22.12, ["Fly|Ride"] = 123.59, ["Neon"] = 77.44, ["Neon|Ride"] = 136.35, ["Neon|Fly|Ride"] = 206.32, ["Mega"] = 412.62, ["Mega|Ride"] = 395.08, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 20.4, ["Ride"] = 93.09, ["Neon"] = 107.6, ["Neon|Ride"] = 357.17, ["Neon|Fly|Ride"] = 165.06, ["Mega"] = 258.24, ["Mega|Fly"] = 504.83, ["Mega|Ride"] = 355.94, ["Mega|Fly|Ride"] = 454.91}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 15.75, ["Ride"] = 77.95, ["Neon"] = 185.85, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 304.32, ["Neon|Fly|Ride"] = 485.63, ["Mega"] = 525, ["Mega|Ride"] = 633.36, ["Mega|Fly|Ride"] = 555.19}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 6.57}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 5.25, ["Fly"] = 26.84, ["Ride"] = 27.87, ["Fly|Ride"] = 78.75, ["Neon"] = 34.13, ["Neon|Ride"] = 215.24, ["Neon|Fly|Ride"] = 205.92, ["Mega"] = 204.75, ["Mega|Fly"] = 466.26, ["Mega|Ride"] = 198.07, ["Mega|Fly|Ride"] = 304.32}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.63, ["Neon"] = 42, ["Mega"] = 138.25, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 72.16, ["Fly"] = 410.74, ["Ride"] = 82.55, ["Fly|Ride"] = 97.67, ["Neon"] = 302.49, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 262.02, ["Mega|Ride"] = 908.77, ["Mega|Fly|Ride"] = 848.17}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 5.25, ["Fly"] = 18.38, ["Ride"] = 17.06, ["Fly|Ride"] = 39.38, ["Neon"] = 23.24, ["Neon|Fly"] = 47.46, ["Neon|Ride"] = 35.12, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 165.06, ["Mega|Fly"] = 411.58, ["Mega|Ride"] = 179.16, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 6.72, ["Fly"] = 82.55, ["Ride"] = 26.25, ["Fly|Ride"] = 76.79, ["Neon"] = 26.24, ["Neon|Ride"] = 54.81, ["Neon|Fly|Ride"] = 138.25, ["Mega"] = 118.13, ["Mega|Ride"] = 152.67, ["Mega|Fly|Ride"] = 300.18}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 4.67, ["Neon|Ride"] = 226.88, ["Mega"] = 42, ["Mega|Ride"] = 96.6, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 45.94, ["Fly"] = 58.7, ["Ride"] = 66.04, ["Fly|Ride"] = 123.8, ["Neon"] = 153.57, ["Neon|Ride"] = 148.04, ["Neon|Fly|Ride"] = 275.43, ["Mega"] = 1100.64, ["Mega|Ride"] = 715.88, ["Mega|Fly|Ride"] = 741.57}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 27.75, ["Neon"] = 6.2, ["Neon|Fly"] = 291.38, ["Neon|Ride"] = 84.59, ["Mega"] = 101.1, ["Mega|Ride"] = 92.01, ["Mega|Fly|Ride"] = 309.68}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 9.09, ["Ride"] = 55.71, ["Fly|Ride"] = 272.33, ["Neon"] = 122.76, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 389.82, ["Mega"] = 374.07, ["Mega|Ride"] = 874.13, ["Mega|Fly|Ride"] = 633.36}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 23.63, ["Ride"] = 15.64, ["Fly|Ride"] = 36.2, ["Neon"] = 30.96, ["Neon|Ride"] = 30.96, ["Neon|Fly|Ride"] = 59.89, ["Mega"] = 157.5, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 3.94, ["Fly"] = 52.49, ["Ride"] = 19.29, ["Fly|Ride"] = 59.03, ["Neon"] = 157.5, ["Neon|Ride"] = 20.65, ["Mega"] = 378.58, ["Mega|Ride"] = 389.92, ["Mega|Fly|Ride"] = 410.17}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 3.52, ["Ride"] = 56.95, ["Fly|Ride"] = 131.25, ["Neon"] = 46.55, ["Neon|Ride"] = 155.91, ["Mega"] = 364.58, ["Mega|Ride"] = 840.67}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 36.81, ["Ride"] = 105, ["Fly|Ride"] = 165.06, ["Neon"] = 196.87, ["Neon|Ride"] = 168, ["Neon|Fly|Ride"] = 367.5, ["Mega|Ride"] = 1637.03, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 13.12, ["Ride"] = 85.79, ["Neon"] = 103.17, ["Neon|Ride"] = 179.5, ["Neon|Fly|Ride"] = 144.42, ["Mega"] = 411.7, ["Mega|Ride"] = 330.1, ["Mega|Fly|Ride"] = 498.1}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 6.57, ["Ride"] = 105, ["Fly|Ride"] = 41.28, ["Neon"] = 39.38, ["Neon|Ride"] = 138.25, ["Mega"] = 757.15, ["Mega|Ride"] = 976.85, ["Mega|Fly|Ride"] = 1650.44}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 15.75, ["Ride"] = 45.94, ["Fly|Ride"] = 367.46, ["Neon"] = 103.9, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 825.23, ["Mega|Ride"] = 792.74, ["Mega|Fly|Ride"] = 1086.42}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 2.62, ["Neon"] = 26.77, ["Neon|Ride"] = 275.43, ["Mega"] = 157.5, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 310.57}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 17.68, ["Fly|Ride"] = 38.19, ["Neon"] = 3.89, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 35.09, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 68.24, ["Mega|Ride"] = 63.97, ["Mega|Fly|Ride"] = 172.11}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 6.46, ["Ride"] = 55.71, ["Fly|Ride"] = 72.19, ["Neon"] = 20.65, ["Neon|Ride"] = 45.4, ["Neon|Fly|Ride"] = 109.94, ["Mega"] = 412.62, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 29.85, ["Ride"] = 18.26, ["Fly|Ride"] = 55.95, ["Neon"] = 6.24, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 45.85, ["Mega|Ride"] = 74.78, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 3.68, ["Fly"] = 39.38, ["Ride"] = 27.87, ["Fly|Ride"] = 69.13, ["Neon"] = 18.58, ["Neon|Ride"] = 96.97, ["Neon|Fly|Ride"] = 138.25, ["Mega"] = 249.38, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 465.28}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.39, ["Fly"] = 65.63, ["Ride"] = 35.09, ["Fly|Ride"] = 102.38, ["Neon"] = 27.87, ["Neon|Fly"] = 465.36, ["Neon|Ride"] = 69.13, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 302.45, ["Mega|Ride"] = 412.62, ["Mega|Fly|Ride"] = 1031.52}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 3.84, ["Fly"] = 131.25, ["Ride"] = 27.87, ["Fly|Ride"] = 55.71, ["Neon"] = 24.66, ["Neon|Fly"] = 111.54, ["Neon|Ride"] = 37.25, ["Neon|Fly|Ride"] = 62.83, ["Mega"] = 144.38, ["Mega|Ride"] = 254.67, ["Mega|Fly|Ride"] = 313.29}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 35.14, ["Ride"] = 18.38, ["Fly|Ride"] = 51.68, ["Neon"] = 22.32, ["Neon|Fly"] = 82.55, ["Neon|Ride"] = 46.55, ["Neon|Fly|Ride"] = 101.21, ["Mega"] = 157.5, ["Mega|Ride"] = 227.98, ["Mega|Fly|Ride"] = 412.62}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 5.23, ["Fly"] = 301.88, ["Ride"] = 39.41, ["Fly|Ride"] = 1312.5, ["Neon"] = 23.73, ["Neon|Fly"] = 123.05, ["Neon|Ride"] = 44.73, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 109.87, ["Mega|Ride"] = 124.69, ["Mega|Fly|Ride"] = 292.77}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 7.85, ["Fly"] = 138.25, ["Ride"] = 105, ["Fly|Ride"] = 525, ["Neon"] = 95.82, ["Neon|Ride"] = 218.7, ["Neon|Fly|Ride"] = 354.12, ["Mega"] = 446.25, ["Mega|Fly"] = 688.03, ["Mega|Ride"] = 551.25, ["Mega|Fly|Ride"] = 643.18}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 57.29, ["Ride"] = 97.13, ["Fly|Ride"] = 191.88, ["Neon"] = 274.61, ["Neon|Ride"] = 271.69, ["Neon|Fly|Ride"] = 408.5, ["Mega"] = 1241.13, ["Mega|Ride"] = 1116.94, ["Mega|Fly|Ride"] = 1206.59}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 50.96, ["Ride"] = 22.71, ["Fly|Ride"] = 49.53, ["Neon"] = 3.62, ["Neon|Ride"] = 41.28, ["Neon|Fly|Ride"] = 132.62, ["Mega"] = 41.27, ["Mega|Ride"] = 54.51, ["Mega|Fly|Ride"] = 131.15}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 63.66, ["Neon|Ride"] = 205.28, ["Mega"] = 963.45, ["Mega|Ride"] = 824.19, ["Mega|Fly|Ride"] = 1237.83}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 53.82, ["Fly"] = 105, ["Ride"] = 59.06, ["Neon"] = 290.84, ["Neon|Ride"] = 247.58, ["Mega"] = 1683.45, ["Mega|Ride"] = 1215.14, ["Mega|Fly|Ride"] = 963.45}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 6.57, ["Fly"] = 190.32, ["Ride"] = 31.43, ["Fly|Ride"] = 126, ["Neon"] = 49.87, ["Neon|Ride"] = 65.54, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 208.6, ["Mega|Ride"] = 195.57, ["Mega|Fly|Ride"] = 344.54}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 2.63, ["Ride"] = 82.55, ["Fly|Ride"] = 137.69, ["Neon"] = 7.07, ["Neon|Ride"] = 41.28, ["Mega"] = 61.69, ["Mega|Fly"] = 341.25, ["Mega|Ride"] = 88.34, ["Mega|Fly|Ride"] = 154.88}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.63, ["Fly"] = 21, ["Ride"] = 14.44, ["Fly|Ride"] = 55.71, ["Neon"] = 12.22, ["Neon|Ride"] = 35.09, ["Neon|Fly|Ride"] = 110.39, ["Mega"] = 192.91, ["Mega|Fly"] = 344.54, ["Mega|Ride"] = 114.52, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 16.73, ["Ride"] = 14.06, ["Neon"] = 2.59, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 27.87, ["Neon|Fly|Ride"] = 57.78, ["Mega"] = 27.03, ["Mega|Ride"] = 69.56, ["Mega|Fly|Ride"] = 204.26}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 21, ["Fly|Ride"] = 74.27, ["Neon"] = 6.2, ["Neon|Ride"] = 24.93, ["Neon|Fly|Ride"] = 89.76, ["Mega"] = 42, ["Mega|Fly"] = 168, ["Mega|Ride"] = 76.71, ["Mega|Fly|Ride"] = 173.25}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Fly|Ride"] = 155.91, ["Neon"] = 2.63, ["Neon|Ride"] = 47.46, ["Mega"] = 20.65, ["Mega|Fly|Ride"] = 303.19}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 5.25, ["Ride"] = 44.38, ["Neon"] = 15.49, ["Neon|Ride"] = 83.77, ["Neon|Fly|Ride"] = 618.93, ["Mega"] = 139.13, ["Mega|Ride"] = 231, ["Mega|Fly|Ride"] = 250.23}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 15.39, ["Ride"] = 26.79, ["Fly|Ride"] = 189.96, ["Neon"] = 51.19, ["Neon|Ride"] = 103.17, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 410.55, ["Mega|Ride"] = 550.85, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 4.72, ["Fly"] = 20.96, ["Ride"] = 20.55, ["Fly|Ride"] = 44.63, ["Neon"] = 39.38, ["Neon|Fly"] = 65.54, ["Neon|Ride"] = 41.37, ["Neon|Fly|Ride"] = 88.64, ["Mega|Ride"] = 342.57, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 65.63, ["Ride"] = 263.05, ["Fly|Ride"] = 262.5, ["Neon"] = 275.43, ["Neon|Ride"] = 597.19, ["Mega|Fly|Ride"] = 1771.88}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 18.38, ["Fly"] = 71.73, ["Ride"] = 31.5, ["Fly|Ride"] = 150.62, ["Neon"] = 65.63, ["Neon|Fly|Ride"] = 630, ["Mega"] = 621.14, ["Mega|Ride"] = 827.54, ["Mega|Fly|Ride"] = 820.98}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 16.37, ["Fly|Ride"] = 39.05, ["Neon"] = 3.91, ["Neon|Fly"] = 41.11, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 53.82, ["Mega"] = 39.22, ["Mega|Ride"] = 48.57, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 15.49, ["Ride"] = 14.44, ["Fly|Ride"] = 25.55, ["Neon"] = 5.11, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 20.22, ["Neon|Fly|Ride"] = 45.72, ["Mega"] = 44.29, ["Mega|Fly"] = 82.55, ["Mega|Ride"] = 56.44, ["Mega|Fly|Ride"] = 94.5}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 393.75, ["Ride"] = 499.73, ["Fly|Ride"] = 472.49, ["Neon|Fly|Ride"] = 1500.73}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 13.13, ["Ride"] = 69.13, ["Neon"] = 48.57, ["Neon|Ride"] = 62.76, ["Mega"] = 357.27, ["Mega|Ride"] = 396.38, ["Mega|Fly|Ride"] = 1237.83}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 48.49, ["Ride"] = 14.43, ["Fly|Ride"] = 36.08, ["Neon"] = 5.24, ["Neon|Fly"] = 69.13, ["Neon|Ride"] = 16.96, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 43.32, ["Mega|Ride"] = 74.81, ["Mega|Fly|Ride"] = 105.44}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 59.74, ["Ride"] = 115.49, ["Fly|Ride"] = 150.94, ["Neon"] = 236.24, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 515.82, ["Mega"] = 737.62, ["Mega|Ride"] = 735, ["Mega|Fly|Ride"] = 934.5}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 23.63, ["Ride"] = 16.45, ["Fly|Ride"] = 31.68, ["Neon"] = 13.13, ["Neon|Fly"] = 41.37, ["Neon|Ride"] = 27.8, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 84, ["Mega|Fly"] = 179.5, ["Mega|Ride"] = 93.89, ["Mega|Fly|Ride"] = 195.21}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 69.13, ["Ride"] = 36.11, ["Fly|Ride"] = 1312.5, ["Neon"] = 3.33, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 32, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 22.31, ["Mega|Fly"] = 270.27, ["Mega|Ride"] = 79.29, ["Mega|Fly|Ride"] = 208.95}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 35.43, ["Fly"] = 143.13, ["Ride"] = 86.62, ["Fly|Ride"] = 124.69, ["Neon"] = 173.25, ["Neon|Ride"] = 191.26, ["Neon|Fly|Ride"] = 421.09, ["Mega"] = 721.88, ["Mega|Ride"] = 630, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Ride"] = 14.44, ["Fly|Ride"] = 52.5, ["Neon"] = 4.37, ["Neon|Ride"] = 39.99, ["Mega"] = 40.72, ["Mega|Ride"] = 183.65, ["Mega|Fly|Ride"] = 223.12}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 34.13, ["Ride"] = 78.75, ["Fly|Ride"] = 138.25, ["Neon"] = 313.6, ["Neon|Ride"] = 248.84, ["Neon|Fly|Ride"] = 359.63, ["Mega"] = 1629.8, ["Mega|Ride"] = 1650.44, ["Mega|Fly|Ride"] = 1179.94}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 2.63, ["Ride"] = 55.8, ["Fly|Ride"] = 156.8, ["Neon"] = 21.56, ["Neon|Ride"] = 275.43, ["Mega"] = 144.38, ["Mega|Ride"] = 282.19, ["Mega|Fly|Ride"] = 517.78}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.63, ["Fly"] = 69.13, ["Ride"] = 26.25, ["Fly|Ride"] = 66.04, ["Neon"] = 9.32, ["Neon|Fly"] = 82.55, ["Neon|Ride"] = 110.39, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 110.39, ["Mega|Ride"] = 138.25, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 30.19, ["Ride"] = 55.64, ["Fly|Ride"] = 393.74, ["Neon"] = 144.38, ["Neon|Ride"] = 205.28, ["Neon|Fly|Ride"] = 323.91, ["Mega"] = 2060.97, ["Mega|Ride"] = 2598.75, ["Mega|Fly|Ride"] = 1128.49}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 230.31, ["Ride"] = 32, ["Fly|Ride"] = 908.98, ["Neon"] = 5.25, ["Neon|Ride"] = 37.23, ["Neon|Fly|Ride"] = 152.39, ["Mega"] = 47.25, ["Mega|Fly"] = 247.11, ["Mega|Ride"] = 109.36, ["Mega|Fly|Ride"] = 247.58}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 33.03, ["Ride"] = 15.49, ["Fly|Ride"] = 102.88, ["Neon"] = 15.46, ["Neon|Fly"] = 47.77, ["Neon|Ride"] = 18.58, ["Neon|Fly|Ride"] = 116.32, ["Mega"] = 206.32, ["Mega|Fly|Ride"] = 205.78}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 9.09, ["Fly"] = 45.4, ["Ride"] = 31.69, ["Fly|Ride"] = 81.51, ["Neon"] = 69.56, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 138.25, ["Mega"] = 430.5, ["Mega|Ride"] = 464.2, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 24.94, ["Fly"] = 41.28, ["Ride"] = 29.3, ["Neon"] = 286.78, ["Neon|Ride"] = 117.6, ["Neon|Fly|Ride"] = 206.32, ["Mega"] = 1059.37, ["Mega|Ride"] = 1856.73, ["Mega|Fly|Ride"] = 621.14}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 18.26, ["Fly"] = 51.18, ["Ride"] = 24.94, ["Fly|Ride"] = 74.1, ["Neon"] = 63.97, ["Neon|Ride"] = 110.39, ["Neon|Fly|Ride"] = 275.43, ["Mega"] = 550.85, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 403.65}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 49.88, ["Fly"] = 262.5, ["Ride"] = 112.88, ["Fly|Ride"] = 307.14, ["Neon"] = 262.5, ["Neon|Ride"] = 404.25, ["Neon|Fly|Ride"] = 548.79, ["Mega|Ride"] = 1302.68, ["Mega|Fly|Ride"] = 1258.69}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 3.6, ["Ride"] = 44.54, ["Neon"] = 38.07, ["Neon|Ride"] = 77.97, ["Neon|Fly|Ride"] = 305.82, ["Mega"] = 201.41, ["Mega|Ride"] = 300.18, ["Mega|Fly|Ride"] = 335.35}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 6.46, ["Ride"] = 26.46, ["Fly|Ride"] = 78.74, ["Neon"] = 18.37, ["Neon|Ride"] = 77.38, ["Neon|Fly|Ride"] = 122.75, ["Mega"] = 131.25, ["Mega|Ride"] = 275.43, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 12.5, ["Fly"] = 65.63, ["Ride"] = 40.24, ["Fly|Ride"] = 93.09, ["Neon"] = 61.9, ["Neon|Ride"] = 69.13, ["Mega"] = 430.5, ["Mega|Ride"] = 639.19, ["Mega|Fly|Ride"] = 479.07}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 12.36, ["Fly|Ride"] = 30.96, ["Neon"] = 2.1, ["Neon|Fly"] = 39.37, ["Neon|Ride"] = 16.96, ["Neon|Fly|Ride"] = 53.82, ["Mega"] = 15.75, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 93.82}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 52.5, ["Fly"] = 164.07, ["Ride"] = 85.32, ["Fly|Ride"] = 297.83, ["Neon"] = 262.64, ["Neon|Fly"] = 2338.45, ["Neon|Ride"] = 224.44, ["Neon|Fly|Ride"] = 488.14, ["Mega"] = 1395.83, ["Mega|Ride"] = 1344.65, ["Mega|Fly|Ride"] = 947.91}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 18.64, ["Fly|Ride"] = 107.29, ["Neon"] = 3.84, ["Neon|Ride"] = 45.94, ["Mega"] = 31.42, ["Mega|Ride"] = 65, ["Mega|Fly|Ride"] = 306.66}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 27.87, ["Ride"] = 15.16, ["Fly|Ride"] = 45.93, ["Neon"] = 22.32, ["Neon|Fly"] = 138.25, ["Neon|Ride"] = 32, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 262.5, ["Mega|Ride"] = 122.07, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 77.96, ["Ride"] = 119.75, ["Fly|Ride"] = 223.13, ["Neon"] = 408.5, ["Neon|Ride"] = 385.62, ["Neon|Fly|Ride"] = 605.51, ["Mega"] = 1181.25, ["Mega|Ride"] = 1706.25, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 22.71, ["Neon"] = 5.16, ["Neon|Ride"] = 65.63, ["Mega"] = 64.32, ["Mega|Ride"] = 120.99, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 9.19}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 292.97, ["Neon"] = 6.54, ["Neon|Ride"] = 41.81, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 47.46, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 437.07}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 99.75, ["Ride"] = 200.12, ["Fly|Ride"] = 295.51, ["Neon"] = 420, ["Neon|Ride"] = 682.92, ["Neon|Fly|Ride"] = 735, ["Mega"] = 3567.47, ["Mega|Ride"] = 2475.64, ["Mega|Fly|Ride"] = 2559}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 4.15, ["Ride"] = 36.82, ["Neon"] = 43.35, ["Neon|Ride"] = 63.97, ["Neon|Fly|Ride"] = 193.93, ["Mega"] = 159.94, ["Mega|Ride"] = 202.85, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 27.87, ["Neon"] = 4.39, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 41.25, ["Mega|Ride"] = 99.65, ["Mega|Fly|Ride"] = 124.09}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 4.66, ["Ride"] = 26.84, ["Neon"] = 51.18, ["Neon|Ride"] = 110.07, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 258.92, ["Mega|Fly|Ride"] = 614.75}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 8.63, ["Fly"] = 24.2, ["Ride"] = 15.75, ["Fly|Ride"] = 54.32, ["Neon"] = 80.22, ["Neon|Ride"] = 117.5, ["Neon|Fly|Ride"] = 165.06, ["Mega"] = 550.85, ["Mega|Ride"] = 405.57, ["Mega|Fly|Ride"] = 466.26}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 18.37, ["Ride"] = 55.13, ["Fly|Ride"] = 97.91, ["Neon"] = 142.67, ["Neon|Ride"] = 197.04, ["Neon|Fly|Ride"] = 621.14, ["Mega"] = 656.25, ["Mega|Ride"] = 472.5, ["Mega|Fly|Ride"] = 771.1}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 131.25, ["Fly"] = 279.22, ["Ride"] = 188.98, ["Fly|Ride"] = 226.15, ["Neon"] = 590.45, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 611.63, ["Mega|Fly|Ride"] = 2329.69}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 23.61, ["Fly"] = 36.75, ["Ride"] = 25.75, ["Fly|Ride"] = 49.25, ["Neon"] = 133.46, ["Neon|Fly"] = 138.25, ["Neon|Ride"] = 123.14, ["Neon|Fly|Ride"] = 177.44, ["Mega|Ride"] = 715.88, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.1, ["Fly"] = 131.23, ["Ride"] = 20.65, ["Fly|Ride"] = 90.79, ["Neon"] = 26.25, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 117.6, ["Mega"] = 127.32, ["Mega|Ride"] = 132.62, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 8.71, ["Fly"] = 232.68, ["Ride"] = 39.38, ["Fly|Ride"] = 131.25, ["Neon"] = 82.21, ["Neon|Fly|Ride"] = 191.88, ["Mega"] = 376.82, ["Mega|Ride"] = 433.13}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 42, ["Ride"] = 90.04, ["Fly|Ride"] = 216.2, ["Neon"] = 220.49, ["Neon|Ride"] = 214.57, ["Neon|Fly|Ride"] = 341.16, ["Mega|Ride"] = 1165.5, ["Mega|Fly|Ride"] = 943.69}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 16.44, ["Ride"] = 105, ["Neon"] = 123.8, ["Neon|Ride"] = 238.26, ["Neon|Fly|Ride"] = 454.91, ["Mega"] = 660.19, ["Mega|Ride"] = 825.23, ["Mega|Fly|Ride"] = 775.85}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 315, ["Ride"] = 412.62, ["Neon|Ride"] = 1968.75, ["Neon|Fly|Ride"] = 1510.98, ["Mega|Fly|Ride"] = 6189.08}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 41.28, ["Ride"] = 73.5, ["Fly|Ride"] = 93.09, ["Neon"] = 212.87, ["Neon|Ride"] = 295.52, ["Neon|Fly|Ride"] = 315, ["Mega"] = 1034.25, ["Mega|Ride"] = 909.57, ["Mega|Fly|Ride"] = 895.26}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 36.66, ["Ride"] = 15.21, ["Fly|Ride"] = 98.44, ["Neon"] = 2.63, ["Neon|Ride"] = 17.57, ["Neon|Fly|Ride"] = 64.28, ["Mega"] = 20.98, ["Mega|Fly"] = 103.17, ["Mega|Ride"] = 41.06, ["Mega|Fly|Ride"] = 108.94}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 3.31, ["Neon"] = 15.73, ["Neon|Ride"] = 40.85, ["Neon|Fly|Ride"] = 259.89, ["Mega"] = 165.06, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 407.47}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 5.25, ["Ride"] = 41.28, ["Fly|Ride"] = 144.17, ["Neon"] = 18.38, ["Neon|Fly"] = 87.94, ["Neon|Ride"] = 122.76, ["Neon|Fly|Ride"] = 174.57, ["Mega"] = 118.98, ["Mega|Fly"] = 143.09, ["Mega|Ride"] = 239.69, ["Mega|Fly|Ride"] = 328.12}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 341.25, ["Fly"] = 621.25, ["Ride"] = 357.95, ["Fly|Ride"] = 642.66, ["Neon"] = 1493.64, ["Neon|Ride"] = 1376.05, ["Neon|Fly|Ride"] = 1370.25, ["Mega|Ride"] = 5769.38, ["Mega|Fly|Ride"] = 5033.44}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 3.15, ["Fly"] = 37.68, ["Ride"] = 17.06, ["Fly|Ride"] = 68.25, ["Neon"] = 15.74, ["Neon|Ride"] = 41.77, ["Neon|Fly|Ride"] = 77.32, ["Mega"] = 168, ["Mega|Ride"] = 275.18, ["Mega|Fly|Ride"] = 195.57}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 7.07, ["Fly"] = 22.32, ["Ride"] = 17.06, ["Fly|Ride"] = 44.63, ["Neon"] = 28.07, ["Neon|Fly"] = 156.45, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 688.03, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 7.87, ["Fly"] = 39.57, ["Ride"] = 27.56, ["Neon"] = 13.13, ["Neon|Fly"] = 152.42, ["Neon|Ride"] = 46.55, ["Neon|Fly|Ride"] = 138.25, ["Mega"] = 103.49, ["Mega|Ride"] = 138.25, ["Mega|Fly|Ride"] = 206.32}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 35.43, ["Fly"] = 138.25, ["Ride"] = 52.5, ["Fly|Ride"] = 65.63, ["Neon"] = 119.44, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 210, ["Mega|Ride"] = 1628.47, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 41.28, ["Fly|Ride"] = 68.65, ["Neon"] = 10.5, ["Neon|Ride"] = 114.19, ["Neon|Fly|Ride"] = 210, ["Mega"] = 165.06, ["Mega|Ride"] = 412.62}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 5.25, ["Fly"] = 787.5, ["Ride"] = 23.63, ["Fly|Ride"] = 85.31, ["Neon"] = 124.4, ["Neon|Ride"] = 155.71, ["Mega"] = 674.63, ["Mega|Fly|Ride"] = 826.88}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 19.17, ["Neon"] = 6.04, ["Neon|Ride"] = 28.76, ["Mega"] = 45.45, ["Mega|Ride"] = 138.25, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 15.64, ["Ride"] = 135.14, ["Neon"] = 94.5, ["Neon|Ride"] = 205.28, ["Mega"] = 165.38, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 13.13, ["Ride"] = 78.41, ["Neon"] = 139.32, ["Neon|Ride"] = 102.14, ["Neon|Fly|Ride"] = 412.62, ["Mega"] = 481.73, ["Mega|Ride"] = 343.16, ["Mega|Fly|Ride"] = 534.34}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 15.49, ["Fly"] = 35.09, ["Ride"] = 25.72, ["Fly|Ride"] = 55.55, ["Neon"] = 52.49, ["Neon|Fly"] = 116.36, ["Neon|Ride"] = 57.75, ["Neon|Fly|Ride"] = 138.25, ["Mega"] = 579.73, ["Mega|Ride"] = 371.37, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 262.5, ["Fly"] = 410.27, ["Ride"] = 282.08, ["Fly|Ride"] = 389.81, ["Neon"] = 1470.95, ["Neon|Ride"] = 681.22, ["Neon|Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 5053.39}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 15.62, ["Fly|Ride"] = 56.8, ["Neon"] = 9.98, ["Neon|Fly"] = 77.97, ["Neon|Ride"] = 33.76, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 220.77, ["Mega|Ride"] = 155.89, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 4.92, ["Fly"] = 27.86, ["Ride"] = 27.82, ["Fly|Ride"] = 114.19, ["Neon"] = 35.33, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 282.92, ["Mega|Ride"] = 271.87, ["Mega|Fly|Ride"] = 412.62}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 43.32, ["Ride"] = 96.77, ["Neon"] = 115.5, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 275.43, ["Mega"] = 393.75, ["Mega|Ride"] = 359.41, ["Mega|Fly|Ride"] = 480.38}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 117.73, ["Ride"] = 164.03, ["Fly|Ride"] = 283.67, ["Neon"] = 480.71, ["Neon|Fly"] = 1045.97, ["Neon|Ride"] = 451.5, ["Neon|Fly|Ride"] = 1168.13, ["Mega"] = 2326.36, ["Mega|Ride"] = 1794.19, ["Mega|Fly|Ride"] = 2235.19}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 40.69, ["Fly"] = 110.39, ["Ride"] = 210, ["Neon"] = 101.1, ["Neon|Ride"] = 138.25, ["Neon|Fly|Ride"] = 261.19, ["Mega"] = 236.25, ["Mega|Ride"] = 252, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Ride"] = 16.59, ["Fly|Ride"] = 58.47, ["Neon"] = 9.19, ["Neon|Fly|Ride"] = 58.97, ["Mega"] = 53.66, ["Mega|Ride"] = 194.27, ["Mega|Fly|Ride"] = 192.94}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 10.96, ["Ride"] = 38.81, ["Fly|Ride"] = 81.51, ["Neon"] = 41.28, ["Neon|Ride"] = 101.07, ["Neon|Fly|Ride"] = 308.44, ["Mega"] = 210, ["Mega|Ride"] = 442.98, ["Mega|Fly|Ride"] = 329.83}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 68.1, ["Fly"] = 196.88, ["Ride"] = 135.19, ["Fly|Ride"] = 216.57, ["Neon"] = 141.74, ["Neon|Ride"] = 170.62, ["Neon|Fly|Ride"] = 314.9, ["Mega"] = 433.13, ["Mega|Ride"] = 419.99, ["Mega|Fly|Ride"] = 576.18}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.63, ["Neon"] = 6.56, ["Neon|Ride"] = 248.98, ["Neon|Fly|Ride"] = 190.3, ["Mega"] = 63, ["Mega|Fly"] = 116.82, ["Mega|Ride"] = 138.25, ["Mega|Fly|Ride"] = 153.57}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 10.34, ["Fly|Ride"] = 274.4, ["Neon"] = 82.69, ["Neon|Ride"] = 401.03, ["Mega"] = 484.82, ["Mega|Fly|Ride"] = 763.33}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 969.94, ["Fly"] = 1259.91, ["Ride"] = 1007.99, ["Fly|Ride"] = 1098.67, ["Neon|Ride"] = 3879.92, ["Neon|Fly|Ride"] = 2624.98, ["Mega|Fly|Ride"] = 13754.2}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 20.98, ["Fly"] = 116.36, ["Ride"] = 109.36, ["Fly|Ride"] = 194.25, ["Neon"] = 123.37, ["Neon|Fly"] = 892.5, ["Neon|Ride"] = 204.26, ["Mega"] = 963.45, ["Mega|Ride"] = 534.34, ["Mega|Fly|Ride"] = 688.03}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 3.5, ["Fly"] = 49.25, ["Ride"] = 20.65, ["Fly|Ride"] = 80.88, ["Neon"] = 13.13, ["Neon|Ride"] = 33.03, ["Neon|Fly|Ride"] = 116.59, ["Mega"] = 78.66, ["Mega|Ride"] = 106.99, ["Mega|Fly|Ride"] = 183.65}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 15.31, ["Ride"] = 131.22, ["Neon"] = 110.39, ["Neon|Fly|Ride"] = 138.25, ["Mega"] = 227.22, ["Mega|Ride"] = 318.94, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 23.73, ["Fly|Ride"] = 52.5, ["Neon"] = 2.63, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 91.87, ["Mega"] = 17.07, ["Mega|Fly"] = 123.8, ["Mega|Ride"] = 44.49, ["Mega|Fly|Ride"] = 127.93}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 61.57, ["Ride"] = 118.13, ["Fly|Ride"] = 210, ["Neon"] = 248.07, ["Neon|Ride"] = 337.35, ["Neon|Fly|Ride"] = 474.51, ["Mega"] = 1279.51, ["Mega|Ride"] = 1168.13, ["Mega|Fly|Ride"] = 1222.3}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 7.66, ["Fly"] = 174.57, ["Ride"] = 18.38, ["Fly|Ride"] = 69.13, ["Neon"] = 20.9, ["Neon|Ride"] = 78.75, ["Mega"] = 464.13, ["Mega|Ride"] = 396.12, ["Mega|Fly|Ride"] = 464.63}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 3.66, ["Fly"] = 97.69, ["Ride"] = 24.77, ["Neon"] = 11.68, ["Neon|Ride"] = 55.71, ["Mega"] = 93.08, ["Mega|Ride"] = 157.49, ["Mega|Fly|Ride"] = 371.37}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 61.9, ["Ride"] = 78.63, ["Fly|Ride"] = 118.13, ["Neon"] = 109.36, ["Neon|Fly"] = 268.21, ["Neon|Ride"] = 155.91, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 497.53, ["Mega|Ride"] = 543.21, ["Mega|Fly|Ride"] = 575.79}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 30.19, ["Ride"] = 84, ["Fly|Ride"] = 62.99, ["Neon"] = 105.24, ["Neon|Ride"] = 175.38, ["Neon|Fly|Ride"] = 171.25, ["Mega"] = 341.97, ["Mega|Ride"] = 495.14, ["Mega|Fly|Ride"] = 825.23}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 59.07, ["Neon"] = 357.16, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 433.25, ["Mega"] = 1539.19, ["Mega|Ride"] = 1650.44, ["Mega|Fly|Ride"] = 1579.03}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 11.36, ["Ride"] = 42, ["Neon"] = 28.02, ["Neon|Ride"] = 84.81, ["Neon|Fly|Ride"] = 621.14, ["Mega"] = 99.62, ["Mega|Ride"] = 129.93, ["Mega|Fly|Ride"] = 230.04}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 7.77, ["Fly"] = 27.87, ["Ride"] = 18.59, ["Fly|Ride"] = 52.48, ["Neon"] = 44.63, ["Neon|Ride"] = 58.24, ["Neon|Fly|Ride"] = 126.36, ["Mega"] = 399, ["Mega|Ride"] = 342.77, ["Mega|Fly|Ride"] = 321.84}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 120.75, ["Ride"] = 156.19, ["Fly|Ride"] = 246.84, ["Neon"] = 618.93, ["Neon|Ride"] = 485.63, ["Neon|Fly|Ride"] = 558.94, ["Mega"] = 3154.37, ["Mega|Ride"] = 2335.15, ["Mega|Fly|Ride"] = 1887.38}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.63, ["Fly"] = 23, ["Ride"] = 17.07, ["Fly|Ride"] = 105000, ["Neon"] = 11.45, ["Neon|Fly"] = 64.31, ["Neon|Ride"] = 27.87, ["Neon|Fly|Ride"] = 96.97, ["Mega"] = 139.55, ["Mega|Ride"] = 148.79, ["Mega|Fly|Ride"] = 206.32}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 7.94, ["Fly"] = 41.09, ["Ride"] = 26.25, ["Fly|Ride"] = 91.88, ["Neon"] = 65.63, ["Neon|Fly"] = 310.64, ["Neon|Ride"] = 77.97, ["Neon|Fly|Ride"] = 138.25, ["Mega"] = 367.71, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 17.61, ["Ride"] = 14.33, ["Fly|Ride"] = 41.28, ["Neon"] = 2.1, ["Neon|Fly"] = 24.09, ["Neon|Ride"] = 16.7, ["Neon|Fly|Ride"] = 41.28, ["Mega"] = 14.44, ["Mega|Fly"] = 48.86, ["Mega|Ride"] = 27.3, ["Mega|Fly|Ride"] = 82.67}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 53.66, ["Neon"] = 2.58, ["Neon|Ride"] = 39.22, ["Mega"] = 21, ["Mega|Fly"] = 118.12, ["Mega|Ride"] = 64.32, ["Mega|Fly|Ride"] = 110.39}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 3.82, ["Fly"] = 35.09, ["Ride"] = 19.69, ["Fly|Ride"] = 79.47, ["Neon"] = 17.07, ["Neon|Ride"] = 41.28, ["Mega"] = 155.89, ["Mega|Ride"] = 165.06, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 39.27, ["Ride"] = 77.38, ["Neon"] = 326.82, ["Neon|Ride"] = 412.62, ["Neon|Fly|Ride"] = 630, ["Mega"] = 550.85, ["Mega|Ride"] = 392.44, ["Mega|Fly|Ride"] = 668.43}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 17.06, ["Fly|Ride"] = 40, ["Neon"] = 7.88, ["Neon|Fly"] = 34.44, ["Neon|Ride"] = 26.07, ["Neon|Fly|Ride"] = 53.52, ["Mega"] = 118.13, ["Mega|Fly"] = 170.6, ["Mega|Ride"] = 115.5, ["Mega|Fly|Ride"] = 172.81}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 4.87, ["Fly"] = 30.96, ["Ride"] = 23.63, ["Fly|Ride"] = 63.54, ["Neon"] = 20.99, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 35.09, ["Neon|Fly|Ride"] = 93.12, ["Mega"] = 182.43, ["Mega|Fly"] = 433.13, ["Mega|Ride"] = 172.75, ["Mega|Fly|Ride"] = 213.94}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.37, ["Fly"] = 19.69, ["Ride"] = 18.06, ["Fly|Ride"] = 49.88, ["Neon"] = 9.32, ["Neon|Fly"] = 98.43, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 62.58, ["Mega|Fly"] = 96.97, ["Mega|Ride"] = 138.25, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 9.05, ["Fly"] = 36.11, ["Ride"] = 45.93, ["Neon"] = 86.1, ["Neon|Ride"] = 93.09, ["Neon|Fly|Ride"] = 192.91, ["Mega"] = 220.23, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 272.33, ["Mega|Fly|Ride"] = 618.93}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 11.38, ["Fly"] = 171.25, ["Ride"] = 122.72, ["Fly|Ride"] = 221.05, ["Neon"] = 63, ["Neon|Ride"] = 252.03, ["Neon|Fly|Ride"] = 344.54, ["Mega"] = 234.17, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 2.63, ["Fly"] = 41.88, ["Ride"] = 18.84, ["Fly|Ride"] = 65.54, ["Neon"] = 24.22, ["Neon|Fly"] = 196.66, ["Neon|Ride"] = 55.71, ["Neon|Fly|Ride"] = 109.35, ["Mega"] = 310.57, ["Mega|Ride"] = 232.64, ["Mega|Fly|Ride"] = 371.37}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 20.89, ["Ride"] = 18.48, ["Fly|Ride"] = 34.95, ["Neon"] = 10.44, ["Neon|Fly"] = 68.33, ["Neon|Ride"] = 27.87, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 131.25, ["Mega|Ride"] = 136.18, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 189, ["Fly"] = 370.69, ["Ride"] = 265.27, ["Fly|Ride"] = 275.43, ["Neon"] = 946.95, ["Neon|Ride"] = 1237.83, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 6.44, ["Ride"] = 61.76, ["Neon"] = 42.95, ["Neon|Fly|Ride"] = 412.62, ["Mega"] = 119.62, ["Mega|Ride"] = 412.11, ["Mega|Fly|Ride"] = 472.49}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 2.63, ["Fly"] = 23.63, ["Ride"] = 15.74, ["Fly|Ride"] = 76.35, ["Neon"] = 23.14, ["Neon|Fly"] = 206.32, ["Neon|Ride"] = 33.03, ["Neon|Fly|Ride"] = 201.8, ["Mega"] = 197.51, ["Mega|Ride"] = 274.4, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 6.57, ["Ride"] = 24.77, ["Neon"] = 52.5, ["Neon|Ride"] = 213.44, ["Neon|Fly|Ride"] = 618.93, ["Mega"] = 461.77, ["Mega|Ride"] = 310.57, ["Mega|Fly|Ride"] = 547.98}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 15.49, ["Ride"] = 15.49, ["Fly|Ride"] = 27.87, ["Neon"] = 2.1, ["Neon|Fly"] = 20.65, ["Neon|Ride"] = 16.43, ["Neon|Fly|Ride"] = 44.62, ["Mega"] = 18.27, ["Mega|Ride"] = 32, ["Mega|Fly|Ride"] = 95.55}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 6.57, ["Fly"] = 41.28, ["Ride"] = 17.06, ["Fly|Ride"] = 45.94, ["Neon"] = 9.08, ["Neon|Ride"] = 32, ["Neon|Fly|Ride"] = 94.76, ["Mega"] = 102.38, ["Mega|Ride"] = 143.07, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.24, ["Ride"] = 60.88, ["Neon"] = 24.77, ["Neon|Ride"] = 206.32, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 59.07, ["Mega|Ride"] = 196, ["Mega|Fly|Ride"] = 308.95}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 65.51, ["Fly"] = 105, ["Ride"] = 105, ["Fly|Ride"] = 138.07, ["Neon"] = 513.06, ["Neon|Ride"] = 427.14, ["Neon|Fly|Ride"] = 446.25, ["Mega"] = 2063.03, ["Mega|Ride"] = 3440.11, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 3.84, ["Fly"] = 91.88, ["Ride"] = 23.63, ["Fly|Ride"] = 65.63, ["Neon"] = 22.32, ["Neon|Ride"] = 54.7, ["Neon|Fly|Ride"] = 92.79, ["Mega"] = 209.42, ["Mega|Ride"] = 288.84, ["Mega|Fly|Ride"] = 399.2}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 20.99, ["Ride"] = 47.39, ["Fly|Ride"] = 118.13, ["Neon"] = 15.23, ["Neon|Ride"] = 27.87, ["Neon|Fly|Ride"] = 519.43, ["Mega"] = 52.49, ["Mega|Fly"] = 402.3, ["Mega|Ride"] = 122.76, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 53.66, ["Fly"] = 210, ["Ride"] = 91.88, ["Fly|Ride"] = 205.28, ["Neon"] = 124.69, ["Neon|Ride"] = 198.07, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 587.97, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 670.5}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 14.39, ["Ride"] = 15.49, ["Fly|Ride"] = 26.25, ["Neon"] = 2.1, ["Neon|Fly"] = 18.58, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 35.34, ["Mega"] = 19.05, ["Mega|Fly"] = 48.87, ["Mega|Ride"] = 37.15, ["Mega|Fly|Ride"] = 82.21}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Neon"] = 3.91, ["Neon|Ride"] = 35.09, ["Neon|Fly|Ride"] = 93, ["Mega"] = 20.65, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 204.75}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 4.73, ["Ride"] = 107.63, ["Neon"] = 11.81, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 181.56, ["Mega"] = 74.82, ["Mega|Fly"] = 179.5, ["Mega|Ride"] = 107.63, ["Mega|Fly|Ride"] = 196.06}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 9.45, ["Fly"] = 89.76, ["Ride"] = 38.06, ["Fly|Ride"] = 111.56, ["Neon"] = 26.25, ["Neon|Fly"] = 137.29, ["Neon|Ride"] = 72.53, ["Neon|Fly|Ride"] = 225.67, ["Mega"] = 110.24, ["Mega|Fly"] = 220.5, ["Mega|Ride"] = 147.58, ["Mega|Fly|Ride"] = 249.27}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 19.62, ["Ride"] = 13, ["Fly|Ride"] = 36.11, ["Neon"] = 2.43, ["Neon|Fly"] = 20.96, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 47.25, ["Mega"] = 22.04, ["Mega|Fly"] = 39.38, ["Mega|Ride"] = 32.81, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 14.43, ["Fly"] = 72.19, ["Ride"] = 41.28, ["Neon"] = 118.13, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 963.45, ["Mega"] = 497.85, ["Mega|Ride"] = 438.38, ["Mega|Fly|Ride"] = 687.01}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2467.5, ["Ride"] = 2834.61, ["Fly|Ride"] = 2521.32, ["Neon|Fly|Ride"] = 9600.3, ["Mega|Fly|Ride"] = 34658.81}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 23.73, ["Ride"] = 18.37, ["Fly|Ride"] = 27.87, ["Neon"] = 9.19, ["Neon|Fly"] = 62.29, ["Neon|Ride"] = 26.6, ["Neon|Fly|Ride"] = 57.29, ["Mega"] = 78.75, ["Mega|Fly"] = 441.51, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 149.27}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.1, ["Neon"] = 13.98, ["Mega"] = 126, ["Mega|Fly"] = 441, ["Mega|Ride"] = 138.25, ["Mega|Fly|Ride"] = 618.93}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 23.62, ["Fly"] = 41.28, ["Ride"] = 48.49, ["Fly|Ride"] = 157.5, ["Neon"] = 116.82, ["Neon|Ride"] = 92.86, ["Neon|Fly|Ride"] = 245.22, ["Mega"] = 393.65, ["Mega|Ride"] = 397.68, ["Mega|Fly|Ride"] = 439.44}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 32.07, ["Ride"] = 58.82, ["Neon"] = 155.07, ["Neon|Ride"] = 217.56, ["Mega"] = 540.75, ["Mega|Ride"] = 816.97, ["Mega|Fly|Ride"] = 807.26}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 157.5, ["Fly"] = 1376.05, ["Ride"] = 177.06, ["Fly|Ride"] = 310.63, ["Neon"] = 688.03, ["Neon|Ride"] = 721.04, ["Neon|Fly|Ride"] = 810.78, ["Mega"] = 6189.08, ["Mega|Ride"] = 3487.22, ["Mega|Fly|Ride"] = 3281.25}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 7.76, ["Fly"] = 27.87, ["Ride"] = 28.88, ["Fly|Ride"] = 675.94, ["Neon"] = 15.75, ["Neon|Ride"] = 128.7, ["Mega"] = 78.75, ["Mega|Fly"] = 13125, ["Mega|Ride"] = 163.03, ["Mega|Fly|Ride"] = 350.73}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.63, ["Ride"] = 69.13, ["Neon"] = 14.8, ["Neon|Fly"] = 103.17, ["Neon|Fly|Ride"] = 515.76, ["Mega"] = 114.76, ["Mega|Ride"] = 320.15, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 3.94, ["Fly"] = 102, ["Ride"] = 40.73, ["Fly|Ride"] = 196.88, ["Neon"] = 8.97, ["Neon|Ride"] = 49.88, ["Mega"] = 78.75, ["Mega|Ride"] = 112.53, ["Mega|Fly|Ride"] = 287.7}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 11.38, ["Ride"] = 98.44, ["Neon"] = 129.94, ["Neon|Ride"] = 1165.82, ["Mega"] = 510.61, ["Mega|Ride"] = 605.51, ["Mega|Fly|Ride"] = 720.01}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Neon"] = 2.18, ["Neon|Ride"] = 93.69, ["Mega"] = 16.94, ["Mega|Fly"] = 115.59, ["Mega|Ride"] = 155.89}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 84, ["Fly"] = 138.25, ["Ride"] = 97.13, ["Fly|Ride"] = 155.91, ["Neon"] = 412.62, ["Neon|Ride"] = 410.55, ["Neon|Fly|Ride"] = 412.62, ["Mega"] = 1365, ["Mega|Fly|Ride"] = 1724.14}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 91.81, ["Neon"] = 9.98, ["Neon|Ride"] = 138.25, ["Mega"] = 62.83, ["Mega|Ride"] = 179.5, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 40.63, ["Fly"] = 217.56, ["Ride"] = 74.68, ["Fly|Ride"] = 131.24, ["Neon"] = 236.25, ["Neon|Ride"] = 328.02, ["Neon|Fly|Ride"] = 424.07, ["Mega"] = 2625, ["Mega|Ride"] = 1856.73, ["Mega|Fly|Ride"] = 1601.25}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 19.62, ["Fly|Ride"] = 50.8, ["Neon"] = 6.57, ["Neon|Fly"] = 87.44, ["Neon|Ride"] = 58.47, ["Neon|Fly|Ride"] = 83.98, ["Mega"] = 43.8, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 165.14}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Neon"] = 9.06, ["Neon|Ride"] = 118.13, ["Mega"] = 72.19, ["Mega|Ride"] = 136.86, ["Mega|Fly|Ride"] = 605.07}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 11.82, ["Ride"] = 45.39, ["Fly|Ride"] = 157.5, ["Neon"] = 30.96, ["Neon|Ride"] = 89.76, ["Neon|Fly|Ride"] = 206.32, ["Mega"] = 155.28, ["Mega|Ride"] = 345.57, ["Mega|Fly|Ride"] = 921.24}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 406.88, ["Fly"] = 550.85, ["Ride"] = 458.07, ["Fly|Ride"] = 577.04, ["Neon"] = 1291.49, ["Neon|Ride"] = 1114.32, ["Neon|Fly|Ride"] = 1308.57, ["Mega"] = 5363.88, ["Mega|Ride"] = 4725, ["Mega|Fly|Ride"] = 4410}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 32.69, ["Ride"] = 59.07, ["Fly|Ride"] = 78.75, ["Neon"] = 206.32, ["Neon|Ride"] = 193.14, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 1376.05, ["Mega|Ride"] = 1217.2, ["Mega|Fly|Ride"] = 1072.79}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 19.69, ["Fly|Ride"] = 91.88, ["Neon"] = 7.27, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 69.13, ["Mega"] = 49.88, ["Mega|Ride"] = 69.13, ["Mega|Fly|Ride"] = 183.74}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 13, ["Fly"] = 361.04, ["Ride"] = 59.15, ["Fly|Ride"] = 105, ["Neon"] = 44.89, ["Neon|Fly"] = 105, ["Neon|Ride"] = 90.57, ["Neon|Fly|Ride"] = 218.7, ["Mega"] = 249.38, ["Mega|Fly"] = 957.31, ["Mega|Ride"] = 237.67, ["Mega|Fly|Ride"] = 342.47}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 6.15, ["Ride"] = 20.65, ["Fly|Ride"] = 263.05, ["Neon"] = 139.27, ["Neon|Ride"] = 69.13, ["Mega"] = 412.62, ["Mega|Ride"] = 682.26, ["Mega|Fly|Ride"] = 400.56}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.91, ["Ride"] = 27.87, ["Neon"] = 15.74, ["Mega"] = 72.1, ["Mega|Ride"] = 122.07, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.76, ["Fly"] = 86.62, ["Ride"] = 18.38, ["Fly|Ride"] = 41.28, ["Neon"] = 24.94, ["Neon|Ride"] = 32.79, ["Neon|Fly|Ride"] = 210.08, ["Mega"] = 543.21, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 960.36}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 106.4, ["Ride"] = 131.24, ["Fly|Ride"] = 220.89, ["Neon|Ride"] = 616.88, ["Neon|Fly|Ride"] = 697.92, ["Mega|Fly|Ride"] = 2598.4}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 26.25, ["Fly"] = 95.82, ["Ride"] = 52.5, ["Fly|Ride"] = 138.25, ["Neon"] = 192.94, ["Neon|Ride"] = 192.14, ["Mega"] = 682.5, ["Mega|Ride"] = 718.86, ["Mega|Fly|Ride"] = 687.01}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2216.81, ["Fly"] = 2362.5, ["Ride"] = 2100, ["Fly|Ride"] = 2231.25, ["Neon"] = 11003.14, ["Neon|Fly|Ride"] = 7875, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 2.57, ["Fly"] = 65625, ["Ride"] = 107.63, ["Fly|Ride"] = 183.75, ["Neon"] = 13.13, ["Neon|Ride"] = 90.79, ["Neon|Fly|Ride"] = 192.91, ["Mega"] = 118.13, ["Mega|Fly"] = 786.19, ["Mega|Ride"] = 164.07, ["Mega|Fly|Ride"] = 577.66}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 9.19, ["Ride"] = 49.53, ["Neon"] = 38.53, ["Neon|Ride"] = 96.99, ["Neon|Fly|Ride"] = 232.32, ["Mega"] = 191.29, ["Mega|Ride"] = 196.92, ["Mega|Fly|Ride"] = 522.99}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 862.79, ["Fly"] = 1191.28, ["Ride"] = 994.88, ["Fly|Ride"] = 996.96, ["Neon"] = 2598.75, ["Neon|Ride"] = 2931.76, ["Neon|Fly|Ride"] = 2480.63, ["Mega|Fly|Ride"] = 9186.19}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 35.09, ["Ride"] = 56.44, ["Fly|Ride"] = 135.14, ["Neon"] = 310.63, ["Neon|Ride"] = 294.67, ["Neon|Fly|Ride"] = 371.37, ["Mega"] = 779, ["Mega|Ride"] = 672.56, ["Mega|Fly|Ride"] = 839.67}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 3.23, ["Ride"] = 22.89, ["Fly|Ride"] = 128.09, ["Neon"] = 15.49, ["Neon|Ride"] = 41.28, ["Neon|Fly|Ride"] = 328.12, ["Mega"] = 196.88, ["Mega|Ride"] = 123.38, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 52.41, ["Ride"] = 138, ["Neon"] = 3.68, ["Neon|Fly"] = 41.28, ["Neon|Ride"] = 55.23, ["Neon|Fly|Ride"] = 77.96, ["Mega"] = 27.87, ["Mega|Ride"] = 106.32, ["Mega|Fly|Ride"] = 275.43}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 82.69, ["Ride"] = 127.32, ["Fly|Ride"] = 310.63, ["Neon"] = 459.38, ["Neon|Ride"] = 435.12, ["Neon|Fly|Ride"] = 420, ["Mega"] = 4323.08, ["Mega|Fly|Ride"] = 2493.75}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 7.33, ["Neon"] = 21, ["Neon|Ride"] = 61.9, ["Mega"] = 145.45, ["Mega|Ride"] = 186.12, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 69.13, ["Ride"] = 134.11, ["Neon"] = 385.88, ["Neon|Ride"] = 463.32, ["Neon|Fly|Ride"] = 494.32, ["Mega"] = 2475.64, ["Mega|Fly|Ride"] = 2475.64}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 7.77, ["Fly"] = 105, ["Fly|Ride"] = 110.39, ["Neon"] = 39.38, ["Neon|Fly|Ride"] = 196.87, ["Mega"] = 310.57, ["Mega|Ride"] = 309.02, ["Mega|Fly|Ride"] = 275.43}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 249.36, ["Ride"] = 270.38, ["Fly|Ride"] = 337.74, ["Neon"] = 1125.35, ["Neon|Ride"] = 836.06, ["Neon|Fly|Ride"] = 879.01, ["Mega|Fly|Ride"] = 4229.22}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 5.25, ["Fly"] = 87.94, ["Ride"] = 27.87, ["Fly|Ride"] = 40.65, ["Neon"] = 39.38, ["Neon|Ride"] = 64.89, ["Neon|Fly|Ride"] = 114.15, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 335.63}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 20.9, ["Ride"] = 15.75, ["Fly|Ride"] = 39.38, ["Neon"] = 4.58, ["Neon|Fly"] = 30.91, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 52.46, ["Mega"] = 54.17, ["Mega|Fly"] = 95.04, ["Mega|Ride"] = 65, ["Mega|Fly|Ride"] = 146.91}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 892.4, ["Ride"] = 1050, ["Fly|Ride"] = 1050, ["Neon|Ride"] = 7565.12, ["Neon|Fly|Ride"] = 5226.68, ["Mega"] = 26132.34, ["Mega|Fly|Ride"] = 27507.34}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 10.39, ["Fly"] = 963.45, ["Ride"] = 210, ["Neon"] = 57.1, ["Neon|Ride"] = 311.74, ["Mega"] = 236.25, ["Mega|Ride"] = 336.29, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 9.19, ["Fly"] = 46.09, ["Ride"] = 41.27, ["Fly|Ride"] = 97.13, ["Neon"] = 21, ["Neon|Fly"] = 93.01, ["Neon|Ride"] = 55.71, ["Neon|Fly|Ride"] = 138.25, ["Mega"] = 173.76, ["Mega|Fly"] = 205.28, ["Mega|Ride"] = 166.58, ["Mega|Fly|Ride"] = 295.32}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 37.7, ["Fly"] = 40.68, ["Ride"] = 28.87, ["Fly|Ride"] = 70.85, ["Neon"] = 162.89, ["Neon|Ride"] = 200.17, ["Neon|Fly|Ride"] = 183.66, ["Mega"] = 2063.03, ["Mega|Ride"] = 729.32, ["Mega|Fly|Ride"] = 860.9}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 13, ["Fly"] = 77.38, ["Ride"] = 32, ["Fly|Ride"] = 87.94, ["Neon"] = 65.63, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 76.15, ["Neon|Fly|Ride"] = 146.57, ["Mega"] = 367.5, ["Mega|Fly"] = 367.5, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 462.13}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 29.85, ["Ride"] = 209.99, ["Fly|Ride"] = 137.82, ["Neon"] = 105.09, ["Neon|Ride"] = 275.43, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 485.86, ["Mega|Ride"] = 575.6, ["Mega|Fly|Ride"] = 618.15}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 65.63, ["Fly|Ride"] = 232.68, ["Neon"] = 2.63, ["Neon|Ride"] = 108.61, ["Neon|Fly|Ride"] = 310.57, ["Mega"] = 15.74, ["Mega|Fly"] = 68.25, ["Mega|Ride"] = 82.55}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 45.93, ["Fly"] = 68.25, ["Ride"] = 65.61, ["Fly|Ride"] = 130.97, ["Neon"] = 403.7, ["Neon|Fly"] = 433.25, ["Neon|Ride"] = 304.32, ["Neon|Fly|Ride"] = 385.81, ["Mega"] = 3300.86, ["Mega|Fly|Ride"] = 956.82}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 5.83, ["Fly"] = 27.87, ["Ride"] = 18.25, ["Fly|Ride"] = 81.58, ["Neon"] = 31.5, ["Neon|Ride"] = 139.25, ["Mega"] = 773.07, ["Mega|Ride"] = 328.06, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 24.77, ["Ride"] = 20.65, ["Fly|Ride"] = 38.07, ["Neon"] = 15.75, ["Neon|Ride"] = 52.62, ["Neon|Fly|Ride"] = 122.85, ["Mega|Ride"] = 265.9, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 6.35, ["Ride"] = 172.29, ["Neon"] = 105, ["Neon|Ride"] = 825.23, ["Neon|Fly|Ride"] = 184.33, ["Mega"] = 247.58, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 26.25, ["Ride"] = 80.48, ["Fly|Ride"] = 138.25, ["Neon"] = 105, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 304.32, ["Mega"] = 787.5, ["Mega|Ride"] = 840, ["Mega|Fly|Ride"] = 798}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 8.29, ["Ride"] = 196.88, ["Neon"] = 20.88, ["Neon|Fly|Ride"] = 138.25, ["Mega"] = 91.76, ["Mega|Fly"] = 304.32, ["Mega|Ride"] = 110.39, ["Mega|Fly|Ride"] = 310.46}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 33.78, ["Neon"] = 2.63, ["Neon|Ride"] = 20.6, ["Mega"] = 15.73, ["Mega|Ride"] = 55.6, ["Mega|Fly|Ride"] = 206.3}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 69.13, ["Ride"] = 25.1, ["Fly|Ride"] = 81.51, ["Neon"] = 2.57, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 118.12, ["Mega"] = 19.69, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 109.36}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 27.25, ["Ride"] = 17.51, ["Fly|Ride"] = 40.05, ["Neon"] = 7.88, ["Neon|Fly"] = 123.38, ["Neon|Ride"] = 31.43, ["Neon|Fly|Ride"] = 69.13, ["Mega"] = 96.97, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 178.5}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 27.87, ["Fly|Ride"] = 65.63, ["Neon"] = 22.32, ["Neon|Ride"] = 1312.5, ["Mega"] = 118.09, ["Mega|Ride"] = 106.3, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 15.42, ["Fly|Ride"] = 47.24, ["Neon"] = 14.44, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 77.58, ["Mega|Ride"] = 275.43, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 64.22, ["Ride"] = 155.23, ["Fly|Ride"] = 361.04, ["Neon"] = 173.24, ["Neon|Ride"] = 275.43, ["Neon|Fly|Ride"] = 1031.52, ["Mega"] = 1262.59, ["Mega|Ride"] = 890.22, ["Mega|Fly|Ride"] = 1017.09}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 15.42, ["Ride"] = 15.49, ["Fly|Ride"] = 35.44, ["Neon"] = 2.62, ["Neon|Fly"] = 24.77, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 38.91, ["Mega"] = 27.87, ["Mega|Ride"] = 54.53, ["Mega|Fly|Ride"] = 124.52}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 8.73, ["Fly"] = 61.9, ["Ride"] = 39.22, ["Fly|Ride"] = 82.55, ["Neon"] = 39.22, ["Neon|Fly"] = 91.76, ["Neon|Ride"] = 57.75, ["Neon|Fly|Ride"] = 114.19, ["Mega"] = 262.5, ["Mega|Ride"] = 241.5, ["Mega|Fly|Ride"] = 257.28}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 15.65, ["Fly"] = 51.48, ["Ride"] = 31.64, ["Fly|Ride"] = 74.31, ["Neon"] = 109.26, ["Neon|Ride"] = 114.52, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 1112.01, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 565.05}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 3.53, ["Fly"] = 196.88, ["Neon"] = 45.94, ["Mega"] = 288.75, ["Mega|Ride"] = 246.88, ["Mega|Fly|Ride"] = 407.47}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.49, ["Fly|Ride"] = 38.75, ["Neon"] = 5.24, ["Neon|Fly"] = 40.09, ["Neon|Ride"] = 24.77, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 41.34, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 76.12, ["Mega|Fly|Ride"] = 121.96}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 3.84, ["Fly"] = 26.25, ["Ride"] = 27.87, ["Neon"] = 10.5, ["Neon|Fly"] = 31.43, ["Neon|Ride"] = 96.53, ["Mega"] = 136.5, ["Mega|Fly"] = 735, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 385.81}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 971.25, ["Fly"] = 984.38, ["Ride"] = 1000.13, ["Fly|Ride"] = 1063.53, ["Neon"] = 2869.99, ["Neon|Ride"] = 2126.25, ["Neon|Fly|Ride"] = 2152.5, ["Mega|Fly|Ride"] = 6891.05}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 82.55, ["Ride"] = 137.82, ["Fly|Ride"] = 155.91, ["Neon"] = 400.32, ["Neon|Ride"] = 458.07, ["Neon|Fly|Ride"] = 605.51, ["Mega"] = 2791.64, ["Mega|Ride"] = 1926.88, ["Mega|Fly|Ride"] = 1644.25}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.63, ["Ride"] = 39.38, ["Neon"] = 5.25, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 206.32, ["Mega"] = 74.23, ["Mega|Fly|Ride"] = 206.32}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 57.66, ["Fly"] = 152.67, ["Ride"] = 78.75, ["Fly|Ride"] = 210, ["Neon"] = 288.84, ["Neon|Ride"] = 344.54, ["Neon|Fly|Ride"] = 399.2, ["Mega"] = 1023.75, ["Mega|Ride"] = 1199.66, ["Mega|Fly|Ride"] = 1128.75}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 4.55, ["Ride"] = 15.75, ["Neon"] = 61.9, ["Neon|Ride"] = 49.45, ["Neon|Fly|Ride"] = 274.4, ["Mega"] = 268.55, ["Mega|Ride"] = 346.6, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 262.5, ["Fly"] = 412.62, ["Ride"] = 262.5, ["Fly|Ride"] = 352.79, ["Neon|Ride"] = 1339.95, ["Neon|Fly|Ride"] = 1400.81, ["Mega|Fly|Ride"] = 4187.45}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 75.64, ["Ride"] = 26.25, ["Fly|Ride"] = 202.64, ["Neon"] = 24.67, ["Neon|Ride"] = 54.28, ["Mega"] = 138.25, ["Mega|Fly"] = 321.84, ["Mega|Ride"] = 186.12}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.63, ["Ride"] = 26.17, ["Neon"] = 35.18, ["Mega"] = 330.1}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 39.37, ["Ride"] = 96.97, ["Fly|Ride"] = 525, ["Neon"] = 581.68, ["Neon|Ride"] = 191.88, ["Neon|Fly|Ride"] = 217.53, ["Mega"] = 590.63, ["Mega|Ride"] = 718.86, ["Mega|Fly|Ride"] = 682.8}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 49.54, ["Neon"] = 23.47, ["Mega"] = 183.75, ["Mega|Ride"] = 250.74, ["Mega|Fly|Ride"] = 454.81}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 14.94, ["Fly|Ride"] = 32.82, ["Neon"] = 2.63, ["Neon|Fly"] = 31.29, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 27.57, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 138.25}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4331.24, ["Ride"] = 4446.75, ["Fly|Ride"] = 4331.25, ["Neon"] = 30945.36, ["Neon|Fly|Ride"] = 21455.46, ["Mega|Fly|Ride"] = 85272}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 9.19, ["Fly"] = 39.38, ["Ride"] = 56.43, ["Neon"] = 52.41, ["Neon|Ride"] = 106.32, ["Mega"] = 272.33, ["Mega|Ride"] = 213.29, ["Mega|Fly|Ride"] = 310.57}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 21.15, ["Ride"] = 21, ["Fly|Ride"] = 41.58, ["Neon"] = 10.47, ["Neon|Fly"] = 69.13, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 78.54, ["Mega"] = 144.38, ["Mega|Ride"] = 154.88, ["Mega|Fly|Ride"] = 191.02}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 479.07, ["Fly"] = 537.48, ["Ride"] = 485.57, ["Fly|Ride"] = 579.34, ["Neon"] = 1372.81, ["Neon|Ride"] = 1553.47, ["Neon|Fly|Ride"] = 1483.13, ["Mega|Fly|Ride"] = 5260.73}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 7.76, ["Ride"] = 25.81, ["Neon"] = 17.07, ["Neon|Ride"] = 145.69, ["Mega"] = 138.87, ["Mega|Fly|Ride"] = 688.03}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 3.82, ["Fly"] = 138.25, ["Ride"] = 46.55, ["Neon"] = 27.87, ["Neon|Fly"] = 47.46, ["Neon|Ride"] = 275.43, ["Neon|Fly|Ride"] = 275.43, ["Mega"] = 410.55, ["Mega|Ride"] = 401.63}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 52.45, ["Ride"] = 27.09, ["Neon"] = 4.45, ["Neon|Fly"] = 124.68, ["Neon|Ride"] = 24.76, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 44.63, ["Mega|Ride"] = 74.72}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 815.94, ["Ride"] = 708.75, ["Fly|Ride"] = 719.25, ["Neon"] = 2362.5, ["Neon|Ride"] = 2037.62, ["Neon|Fly|Ride"] = 2164.57, ["Mega|Fly|Ride"] = 9628.15}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 7.88, ["Fly"] = 61.9, ["Ride"] = 72.72, ["Neon"] = 30.96, ["Neon|Ride"] = 69.19, ["Neon|Fly|Ride"] = 179.15, ["Mega"] = 155.38, ["Mega|Ride"] = 179.5, ["Mega|Fly|Ride"] = 304.32}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 18.5, ["Fly"] = 235.34, ["Ride"] = 63.57, ["Neon"] = 138.25, ["Neon|Ride"] = 82.55, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 183.75, ["Mega|Ride"] = 191.71, ["Mega|Fly|Ride"] = 283.81}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.63, ["Fly"] = 34.11, ["Ride"] = 15.75, ["Fly|Ride"] = 47.25, ["Neon"] = 14.13, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 67.45, ["Mega"] = 288.48, ["Mega|Fly|Ride"] = 185.22}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 21, ["Ride"] = 46.55, ["Fly|Ride"] = 155.91, ["Neon"] = 117.59, ["Neon|Fly"] = 82.55, ["Neon|Ride"] = 138.25, ["Mega|Fly|Ride"] = 825.23}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Neon"] = 5.23, ["Neon|Ride"] = 36.08, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 26.76, ["Mega|Fly"] = 110.39, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 482.73}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 459.38, ["Ride"] = 446.25, ["Fly|Ride"] = 699.38, ["Neon"] = 2888.25, ["Neon|Ride"] = 2715.37, ["Neon|Fly|Ride"] = 2343.78, ["Mega|Fly|Ride"] = 6877.11}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 3.94, ["Ride"] = 61.66, ["Fly|Ride"] = 179.17, ["Neon"] = 10.34, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 192.91, ["Mega"] = 65.63, ["Mega|Ride"] = 158.46, ["Mega|Fly|Ride"] = 279.57}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 41.21, ["Neon"] = 5.24, ["Neon|Fly"] = 138.25, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 53.66, ["Mega|Fly"] = 110.39, ["Mega|Ride"] = 138.25, ["Mega|Fly|Ride"] = 255.83}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 24.45, ["Neon"] = 5.03, ["Neon|Ride"] = 41.31, ["Neon|Fly|Ride"] = 138.25, ["Mega"] = 41.35, ["Mega|Fly"] = 152.67, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 192.91}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 5.25, ["Ride"] = 131.25, ["Neon"] = 15.5, ["Neon|Ride"] = 39.57, ["Mega"] = 192.91}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 31.49, ["Fly"] = 98.44, ["Ride"] = 137.82, ["Fly|Ride"] = 232.18, ["Neon"] = 109.37, ["Neon|Ride"] = 190.32, ["Neon|Fly|Ride"] = 328.04, ["Mega"] = 632.71, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 684.32}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 14.34, ["Ride"] = 53.65, ["Fly|Ride"] = 116.6, ["Neon"] = 97.13, ["Neon|Ride"] = 131.13, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 464.19, ["Mega|Ride"] = 385.9, ["Mega|Fly|Ride"] = 560.79}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 15.68, ["Fly|Ride"] = 36.04, ["Neon"] = 23.28, ["Neon|Ride"] = 31.19, ["Neon|Fly|Ride"] = 77.96, ["Mega"] = 299.92, ["Mega|Ride"] = 136.54, ["Mega|Fly|Ride"] = 201.89}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 18.27, ["Ride"] = 64.32, ["Neon"] = 92.86, ["Mega"] = 262.5, ["Mega|Fly|Ride"] = 963.45}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.15, ["Fly"] = 131.25, ["Ride"] = 24.93, ["Fly|Ride"] = 44.63, ["Neon"] = 15.49, ["Neon|Ride"] = 31.19, ["Neon|Fly|Ride"] = 207.06, ["Mega"] = 84, ["Mega|Fly"] = 152.67, ["Mega|Ride"] = 152.25, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 15.74, ["Fly"] = 62.84, ["Ride"] = 23.61, ["Fly|Ride"] = 155.91, ["Neon"] = 232.68, ["Neon|Ride"] = 177.72, ["Neon|Fly|Ride"] = 241.39, ["Mega"] = 927.34, ["Mega|Ride"] = 930.56, ["Mega|Fly|Ride"] = 740.64}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 15.65, ["Fly"] = 874.13, ["Neon"] = 106.32, ["Neon|Ride"] = 138.25, ["Mega"] = 310.57, ["Mega|Ride"] = 275.43, ["Mega|Fly|Ride"] = 853.08}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 55.11, ["Fly"] = 85.32, ["Ride"] = 72.35, ["Fly|Ride"] = 183.83, ["Neon"] = 308.44, ["Neon|Ride"] = 275.43, ["Neon|Fly|Ride"] = 346.63, ["Mega|Ride"] = 1644.75, ["Mega|Fly|Ride"] = 1395.83}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 47.64, ["Fly"] = 93.09, ["Ride"] = 61.86, ["Fly|Ride"] = 656.25, ["Neon"] = 105, ["Neon|Ride"] = 187.76, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 576.35, ["Mega|Ride"] = 707.23, ["Mega|Fly|Ride"] = 620.82}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 16.58, ["Ride"] = 46.55, ["Neon"] = 127.32, ["Neon|Ride"] = 123.38, ["Mega"] = 1050, ["Mega|Fly|Ride"] = 1237.83}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 15.74, ["Fly"] = 428.26, ["Ride"] = 40.46, ["Fly|Ride"] = 204.26, ["Neon"] = 86.1, ["Neon|Fly"] = 420, ["Neon|Ride"] = 120.74, ["Neon|Fly|Ride"] = 199.87, ["Mega"] = 457.47, ["Mega|Ride"] = 388.17, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 17.74, ["Ride"] = 14.41, ["Fly|Ride"] = 35.01, ["Neon"] = 5.24, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 20.65, ["Neon|Fly|Ride"] = 62.83, ["Mega"] = 44.61, ["Mega|Fly"] = 206.32, ["Mega|Ride"] = 48.86, ["Mega|Fly|Ride"] = 202.79}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1888.69}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 39.38, ["Ride"] = 103.69, ["Fly|Ride"] = 249.38, ["Neon"] = 236.25, ["Neon|Ride"] = 232.7, ["Neon|Fly|Ride"] = 304.32, ["Mega"] = 717.95, ["Mega|Ride"] = 610.67, ["Mega|Fly|Ride"] = 617.89}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.24, ["Ride"] = 55.71, ["Neon"] = 3.94, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 28.88, ["Mega|Ride"] = 80.48, ["Mega|Fly|Ride"] = 138.25}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 41.28, ["Ride"] = 52.5, ["Neon"] = 128.37, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 525, ["Mega|Ride"] = 770.55, ["Mega|Fly|Ride"] = 760.73}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 3.82, ["Neon|Ride"] = 105, ["Mega"] = 15.64}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 5.25, ["Neon|Ride"] = 47.25, ["Mega"] = 24.23, ["Mega|Ride"] = 106.81, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 115.67, ["Ride"] = 131.25, ["Fly|Ride"] = 275.43, ["Neon"] = 498.75, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 684.94, ["Mega|Ride"] = 6397.49, ["Mega|Fly|Ride"] = 2611.81}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 26.17, ["Ride"] = 17.07, ["Fly|Ride"] = 92.67, ["Neon"] = 11.65, ["Neon|Ride"] = 26.84, ["Neon|Fly|Ride"] = 84, ["Mega"] = 90.56, ["Mega|Ride"] = 155.89, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 38.07, ["Fly|Ride"] = 86.63, ["Neon"] = 3.84, ["Neon|Fly"] = 61.9, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 103.17, ["Mega"] = 35.43, ["Mega|Ride"] = 122.78, ["Mega|Fly|Ride"] = 220.5}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 3.84, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 44.18, ["Mega"] = 35.82, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 224.88}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 3.92, ["Neon|Ride"] = 137.71, ["Mega"] = 62.89, ["Mega|Ride"] = 93.08}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 65.63, ["Ride"] = 103.69, ["Fly|Ride"] = 449.61, ["Neon"] = 415.63, ["Neon|Ride"] = 493.08, ["Neon|Fly|Ride"] = 412.62, ["Mega"] = 1547.28, ["Mega|Ride"] = 1547.28, ["Mega|Fly|Ride"] = 1327.57}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 3.52, ["Ride"] = 56.95, ["Fly|Ride"] = 131.25, ["Neon"] = 46.55, ["Neon|Ride"] = 155.91, ["Mega"] = 364.58, ["Mega|Ride"] = 840.67}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 313.69, ["Fly"] = 465.35, ["Ride"] = 428.09, ["Fly|Ride"] = 616.88, ["Neon"] = 1648.37, ["Neon|Ride"] = 1443.75, ["Neon|Fly|Ride"] = 1155, ["Mega|Ride"] = 3573.18, ["Mega|Fly|Ride"] = 3852.71}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 86.63}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 46.23}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 23.37}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 32.82}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 61.69}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 51.14}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 18.38}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 11.36}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 245.43}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 15.75}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 30.19}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 6.28}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 4.38}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 206.32}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 2.1}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 3.83}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 6.57}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 5.25}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 8.9}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 393.75}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 715.88}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 11.76}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1704.84}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.63}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 36.2}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 6.57}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 20.4}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.63}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 28.88}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 39.38}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 49.88}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 19.69}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 10.5}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 14.18}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 3.73}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 16.71}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.62}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 14.69}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 9.19}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 5.25}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 3.29}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 1788.66}},
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
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 6.2}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 34.8}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 193.17}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 6.46}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 7.88}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 2058.92}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 23.63}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 3.71}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.63}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 14.95}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 31.5}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 13.13}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 178.5}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 28.85}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 11.33}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.63}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 27.12}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.63}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 5.86}},
    ["rbxassetid://1265129203"] = {name = "Ice Snowboard", prices = {["default"] = 1953}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 3.62}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 26.25}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 105}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 190.32}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 3.55}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 13.95}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 22.32}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 24.94}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 77.33}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 16.7}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22164.92}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 312.56}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 37.97}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 134.3}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 48.57}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 137.71}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 420}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 28.88}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 65.63}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 65.94}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 55.08}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 32.82}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 62.39}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 47.75}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 177.38}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 417.46}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 6.12}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 7.86}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.63}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 5.25}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 24.92}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 85.32}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.1}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 4.14}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.63}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 5.1}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 9.76}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 264.08}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 748.13}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 7.88}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 577.5}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 23.29}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.63}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.1}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 605.1}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 45.94}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 115.5}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 49.88}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 44.38}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 65.63}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 14.44}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 3.6}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 15.75}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.1}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 4.6}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 10.5}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 34.93}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 7}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 2.63}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 5.25}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 16.8}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 152.25}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 84}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.42}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.63}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 1048.69}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 8.27}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 6.22}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 6.2}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 16.96}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 30.19}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 5.39}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.63}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 6.46}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 78.64}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 11.9}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 72.19}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 29.38}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 10.94}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 157.5}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 9.32}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 4.67}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 5.25}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 6.45}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 138.25}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 3.92}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 2.43}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.51}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 3.72}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 6240.23}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.5}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 12.5}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 3.19}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 10.13}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 4.86}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 3.94}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 4.98}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 7.76}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 3.71}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 9.19}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 95.82}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 23.73}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 2.43}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 3.93}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 5.79}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 3.83}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 89.81}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 6.21}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4346.19}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 5.25}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 39.38}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 4.75}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 2.41}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 39.38}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 3.69}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 4.72}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 275.43}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 2.14}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 7}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 15.49}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 5.25}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 5.04}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 26.25}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.54}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 10.31}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 2.5}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.16}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 3.21}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 5.13}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.24}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 18.59}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.63}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 6300}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.37}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 7.88}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 84.74}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.48}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 49.12}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 3.82}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 3.71}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1039.5}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 32.69}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 15.49}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 26.17}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 4.67}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 77.43}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 5.36}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 11.46}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 3.46}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 15.75}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 15.75}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 5.15}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 3.14}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 15.75}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 3.63}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.51}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 19.45}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 6.57}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 3.02}},
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
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.63}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.52}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 15.65}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 43.26}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 18.14}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 3.73}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 4.14}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 275.43}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 27.46}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.63}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.63}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.63}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 4.39}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 2.12}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 5.97}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 2.15}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 6.23}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 315}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 5.8}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 137.97}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1115.63}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 213.7}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 4.6}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.63}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 26.84}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 57.75}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 2.96}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 32.69}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 8.93}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 8.97}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.62}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 3.71}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 3.08}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 68.16}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 9.19}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 55.89}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 2.93}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 87.29}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 5.25}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 32.82}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 124.74}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 6.57}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 2.63}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 71.98}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 7.88}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 3.39}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 5.25}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 65.62}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 47.25}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 91.88}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 284.82}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 3.89}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 155.95}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 130.01}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.9}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 5.25}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 28.88}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 60.37}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 3.94}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 41.99}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 6.04}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 77.98}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 21.11}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 22.32}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 35.15}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 4.94}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 31.49}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 16.1}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 155.95}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 7.7}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 5.25}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 131.25}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 3.67}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 10.5}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 45.71}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.25}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 74.82}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 137.8}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1758.75}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 7.48}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 7.65}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 40.24}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 361.83}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 138.25}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 10.5}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 314.9}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 16.41}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 6.02}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 275.63}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 32.71}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 51.29}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 7.66}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.2}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 105}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 115.5}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 55.13}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 1050}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 194.35}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 11.82}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 2063.03}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 498.75}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 2.63}},
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