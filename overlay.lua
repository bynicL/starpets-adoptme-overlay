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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 915.17, ["Ride"] = 1000, ["Fly|Ride"] = 1231.25, ["Neon"] = 6481.25, ["Neon|Ride"] = 6250, ["Neon|Fly|Ride"] = 3990.04, ["Mega|Fly|Ride"] = 19253.2}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 488.75, ["Ride"] = 537.5, ["Fly|Ride"] = 589.3, ["Neon|Fly|Ride"] = 2355.2, ["Mega|Fly|Ride"] = 6482.19}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 4712.5, ["Ride"] = 5000, ["Fly|Ride"] = 4466.25, ["Neon|Fly|Ride"] = 19905.21, ["Mega|Fly|Ride"] = 65476.89}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 157.04, ["Ride"] = 239.65, ["Fly|Ride"] = 262.5, ["Neon"] = 917.34, ["Neon|Ride"] = 785.73, ["Neon|Fly|Ride"] = 977.25, ["Mega|Ride"] = 3704.26, ["Mega|Fly|Ride"] = 3749.99}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 602.5, ["Fly"] = 783.88, ["Ride"] = 585.87, ["Fly|Ride"] = 574.9, ["Neon|Fly|Ride"] = 1662.49, ["Mega|Fly|Ride"] = 6220.03}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 9.39, ["Ride"] = 39.3, ["Neon"] = 55.68, ["Neon|Ride"] = 131.62, ["Neon|Fly|Ride"] = 385, ["Mega"] = 336.89, ["Mega|Ride"] = 250, ["Mega|Fly|Ride"] = 549.82}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 6.25, ["Fly"] = 40.64, ["Ride"] = 27.4, ["Fly|Ride"] = 65.1, ["Neon"] = 26.25, ["Neon|Fly"] = 100.03, ["Neon|Ride"] = 48.61, ["Neon|Fly|Ride"] = 99.89, ["Mega"] = 147.4, ["Mega|Ride"] = 266.59, ["Mega|Fly|Ride"] = 271.85}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 87.5, ["Fly"] = 196.44, ["Ride"] = 145.01, ["Fly|Ride"] = 228.75, ["Neon"] = 415.64, ["Neon|Ride"] = 470, ["Neon|Fly|Ride"] = 655.1}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 43.12, ["Fly"] = 100, ["Ride"] = 49.12, ["Fly|Ride"] = 129.66, ["Neon"] = 275, ["Neon|Ride"] = 300, ["Neon|Fly|Ride"] = 318.75, ["Mega"] = 2000, ["Mega|Fly|Ride"] = 1185.15}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 22.5, ["Fly"] = 66.16, ["Ride"] = 33.44, ["Fly|Ride"] = 66.19, ["Neon"] = 262.24, ["Neon|Ride"] = 271.08, ["Neon|Fly|Ride"] = 296.57}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 55, ["Fly"] = 196.25, ["Ride"] = 80, ["Fly|Ride"] = 166.25, ["Neon"] = 415.64, ["Neon|Ride"] = 287.5, ["Neon|Fly|Ride"] = 396.25}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 64}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 357.95, ["Ride"] = 311.25, ["Fly|Ride"] = 376.19, ["Neon|Fly|Ride"] = 1000, ["Mega|Fly|Ride"] = 4651.47}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 133.75, ["Fly"] = 175.6, ["Ride"] = 129.32, ["Fly|Ride"] = 187.5, ["Neon|Fly|Ride"] = 770.85, ["Mega|Fly|Ride"] = 2881.63}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.5, ["Ride"] = 52.41, ["Fly|Ride"] = 125, ["Neon"] = 21.25, ["Neon|Fly"] = 92.33, ["Neon|Ride"] = 125, ["Mega"] = 125, ["Mega|Fly"] = 375, ["Mega|Ride"] = 296.62, ["Mega|Fly|Ride"] = 289.75}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 180.9, ["Fly"] = 194.71, ["Ride"] = 201.45, ["Fly|Ride"] = 223.75, ["Neon|Fly|Ride"] = 562.5, ["Mega|Fly|Ride"] = 2600}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.74, ["Fly"] = 23.38, ["Ride"] = 19.66, ["Fly|Ride"] = 25, ["Neon"] = 41.25, ["Neon|Ride"] = 86.44, ["Neon|Fly|Ride"] = 103.77, ["Mega|Ride"] = 311.25, ["Mega|Fly|Ride"] = 392.87}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 92.5, ["Fly"] = 444.53, ["Ride"] = 123.75, ["Fly|Ride"] = 170.91, ["Neon"] = 367.34, ["Neon|Ride"] = 392.87, ["Neon|Fly|Ride"] = 498.75, ["Mega"] = 1629.44, ["Mega|Ride"] = 1473.24, ["Mega|Fly|Ride"] = 1551.8}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 35.99}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 58.8, ["Ride"] = 96.26, ["Fly|Ride"] = 226.89, ["Neon"] = 550, ["Neon|Fly|Ride"] = 750}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 15, ["Fly"] = 375, ["Ride"] = 33.03, ["Fly|Ride"] = 123.76, ["Neon"] = 151.59, ["Neon|Ride"] = 199.99, ["Neon|Fly|Ride"] = 350, ["Mega|Ride"] = 1562.5, ["Mega|Fly|Ride"] = 1571.45}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 61.25, ["Fly"] = 150, ["Ride"] = 56.25, ["Fly|Ride"] = 97.5, ["Neon"] = 262.24, ["Neon|Ride"] = 275.46, ["Neon|Fly|Ride"] = 301.53, ["Mega"] = 1555.01, ["Mega|Ride"] = 1310.2, ["Mega|Fly|Ride"] = 812.5}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 37.38, ["Fly"] = 62.5, ["Ride"] = 150, ["Fly|Ride"] = 131.62, ["Neon"] = 200, ["Neon|Ride"] = 392.87, ["Neon|Fly|Ride"] = 445, ["Mega|Fly|Ride"] = 1200.19}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 28.46, ["Ride"] = 42.5, ["Fly|Ride"] = 131.62, ["Neon"] = 455, ["Neon|Ride"] = 300, ["Neon|Fly|Ride"] = 296.57, ["Mega|Ride"] = 2000, ["Mega|Fly|Ride"] = 975}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 41.33, ["Fly"] = 130.23, ["Ride"] = 54.97, ["Fly|Ride"] = 187.5, ["Neon"] = 407.6, ["Neon|Ride"] = 387.96, ["Neon|Fly|Ride"] = 307.5, ["Mega|Ride"] = 1071.25, ["Mega|Fly|Ride"] = 898.75}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 6.25, ["Fly"] = 25.23, ["Ride"] = 21.24, ["Fly|Ride"] = 55, ["Neon"] = 34.99, ["Neon|Fly"] = 96.25, ["Neon|Ride"] = 44.91, ["Neon|Fly|Ride"] = 91.25, ["Mega"] = 180.75, ["Mega|Fly"] = 287.5, ["Mega|Ride"] = 162.5, ["Mega|Fly|Ride"] = 245}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 375, ["Ride"] = 465.14, ["Fly|Ride"] = 510.73, ["Neon|Ride"] = 1767.88, ["Neon|Fly|Ride"] = 1871.25, ["Mega|Fly|Ride"] = 6547.99}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 17.57, ["Ride"] = 31.25, ["Neon"] = 196.51, ["Neon|Fly|Ride"] = 262.24, ["Mega|Fly|Ride"] = 639.67}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 7.5, ["Fly"] = 32.96, ["Ride"] = 21.12, ["Fly|Ride"] = 41.25, ["Neon"] = 67.75, ["Neon|Ride"] = 84.47, ["Neon|Fly|Ride"] = 113.75, ["Mega"] = 392.87, ["Mega|Ride"] = 425}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 86.91, ["Fly"] = 102.93, ["Ride"] = 85.73, ["Fly|Ride"] = 125, ["Neon"] = 348.96, ["Neon|Fly"] = 391.89, ["Neon|Ride"] = 367.34, ["Neon|Fly|Ride"] = 471.45, ["Mega|Fly|Ride"] = 1984.86}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 12.47, ["Ride"] = 33.33, ["Fly|Ride"] = 112.5, ["Neon"] = 131.62, ["Neon|Ride"] = 78.58, ["Neon|Fly|Ride"] = 196.44, ["Mega"] = 524.47, ["Mega|Ride"] = 749.39, ["Mega|Fly|Ride"] = 785.73}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 222.5, ["Fly"] = 331.98, ["Ride"] = 217.5, ["Fly|Ride"] = 284.53, ["Neon"] = 625, ["Neon|Ride"] = 786.25, ["Mega"] = 5892.9, ["Mega|Fly|Ride"] = 3012.26}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 131.62}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 5, ["Fly"] = 29.93, ["Ride"] = 22.01, ["Fly|Ride"] = 58.94, ["Neon"] = 20.19, ["Neon|Fly"] = 4910.75, ["Neon|Ride"] = 49.98, ["Neon|Fly|Ride"] = 170.91, ["Mega"] = 157.15, ["Mega|Fly"] = 201.46, ["Mega|Ride"] = 262.24, ["Mega|Fly|Ride"] = 616.25}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 874.97, ["Fly"] = 2500, ["Ride"] = 943.89, ["Fly|Ride"] = 1003.08, ["Neon"] = 3719.4, ["Neon|Ride"] = 5762.28, ["Neon|Fly|Ride"] = 4075, ["Mega|Ride"] = 49982.33, ["Mega|Fly|Ride"] = 44428.74}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 11.88, ["Fly"] = 65.82, ["Ride"] = 19.26, ["Fly|Ride"] = 87.5, ["Neon"] = 131.62, ["Neon|Ride"] = 111.08, ["Neon|Fly|Ride"] = 217.07, ["Mega|Ride"] = 917.34, ["Mega|Fly|Ride"] = 781.25}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 177.5, ["Ride"] = 183.9, ["Fly|Ride"] = 225, ["Neon"] = 1703.05, ["Neon|Ride"] = 774.9, ["Neon|Fly|Ride"] = 912.5, ["Mega|Ride"] = 5785, ["Mega|Fly|Ride"] = 3000}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 42.33}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 15.42, ["Ride"] = 62.41, ["Fly|Ride"] = 131.62, ["Neon"] = 99.89, ["Neon|Ride"] = 155.19, ["Neon|Fly|Ride"] = 450, ["Mega"] = 655.1, ["Mega|Ride"] = 1036.18, ["Mega|Fly|Ride"] = 549.82}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.5}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 176.38, ["Ride"] = 196.44, ["Fly|Ride"] = 225, ["Neon|Ride"] = 502.87, ["Mega|Fly|Ride"] = 2593.49}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 125.69, ["Ride"] = 183.75, ["Fly|Ride"] = 261.24, ["Neon"] = 300, ["Neon|Ride"] = 593.45, ["Neon|Fly|Ride"] = 500, ["Mega|Ride"] = 1437.5, ["Mega|Fly|Ride"] = 1743.32}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 35.2}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 50, ["Fly"] = 58.42, ["Ride"] = 52.91, ["Fly|Ride"] = 97.25, ["Neon|Ride"] = 350.08, ["Neon|Fly|Ride"] = 363.31, ["Mega|Fly|Ride"] = 1777.16}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 5.74, ["Fly"] = 65.82, ["Ride"] = 33.69, ["Fly|Ride"] = 190.04, ["Neon"] = 196.44, ["Neon|Ride"] = 135, ["Neon|Fly|Ride"] = 220.99, ["Mega"] = 226.89, ["Mega|Fly"] = 255, ["Mega|Ride"] = 309.39, ["Mega|Fly|Ride"] = 570}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 425, ["Fly"] = 525, ["Ride"] = 425, ["Fly|Ride"] = 506.14, ["Neon|Ride"] = 3535.75, ["Neon|Fly|Ride"] = 1571.06, ["Mega|Fly|Ride"] = 7025}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 106.25, ["Fly"] = 196.44, ["Ride"] = 112.49, ["Fly|Ride"] = 183.67, ["Neon"] = 437.5, ["Neon|Ride"] = 720.91, ["Neon|Fly|Ride"] = 437.5, ["Mega|Fly|Ride"] = 2814.57}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3125, ["Ride"] = 3772.5, ["Fly|Ride"] = 3500}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 46.09, ["Fly"] = 131.31, ["Ride"] = 43.75, ["Fly|Ride"] = 122.31, ["Neon|Ride"] = 306.24, ["Mega|Ride"] = 1964.31, ["Mega|Fly|Ride"] = 1178.59}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 148.49, ["Ride"] = 96.25, ["Fly|Ride"] = 132.87, ["Neon"] = 548.33, ["Neon|Ride"] = 625, ["Neon|Fly|Ride"] = 676.98, ["Mega|Ride"] = 2095.91, ["Mega|Fly|Ride"] = 3227.11}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 35.47, ["Fly"] = 40, ["Ride"] = 55.01, ["Fly|Ride"] = 101.25, ["Neon"] = 250, ["Neon|Ride"] = 130.83, ["Neon|Fly|Ride"] = 214.15, ["Mega"] = 2500, ["Mega|Ride"] = 733.67, ["Mega|Fly|Ride"] = 624.9}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 5.88}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 52.92, ["Fly"] = 375, ["Ride"] = 87.81, ["Fly|Ride"] = 62.5, ["Neon|Ride"] = 500}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 43.11}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 212.49, ["Ride"] = 225, ["Fly|Ride"] = 303.75, ["Neon|Ride"] = 1037.97}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 937.5, ["Ride"] = 898.75, ["Neon|Fly|Ride"] = 3138.95}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 9.69}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 29.04, ["Fly"] = 37.47, ["Ride"] = 41.25, ["Fly|Ride"] = 62.26, ["Neon"] = 156.25, ["Neon|Ride"] = 158.75, ["Neon|Fly|Ride"] = 296.57, ["Mega|Fly|Ride"] = 885.84}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 17.21}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5000, ["Fly|Ride"] = 5233.75, ["Neon|Fly|Ride"] = 10312, ["Mega|Fly|Ride"] = 38801.84}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 12.4, ["Fly"] = 50, ["Ride"] = 23.89, ["Fly|Ride"] = 50.27, ["Neon"] = 95.24, ["Neon|Ride"] = 115, ["Neon|Fly|Ride"] = 237.5, ["Mega"] = 750, ["Mega|Ride"] = 524.47, ["Mega|Fly|Ride"] = 750}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 13.75, ["Ride"] = 34.91, ["Fly|Ride"] = 296.73, ["Neon"] = 68.75, ["Neon|Ride"] = 116.25, ["Neon|Fly|Ride"] = 250, ["Mega"] = 692.5, ["Mega|Ride"] = 635.46, ["Mega|Fly|Ride"] = 1500}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 390, ["Ride"] = 106.76, ["Fly|Ride"] = 125, ["Neon|Ride"] = 364.38, ["Neon|Fly|Ride"] = 458.05, ["Mega"] = 3928.6}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 9.29, ["Ride"] = 39.3, ["Fly|Ride"] = 126.32, ["Neon"] = 103.75, ["Neon|Ride"] = 247.51, ["Neon|Fly|Ride"] = 477.5, ["Mega|Ride"] = 696.43, ["Mega|Fly|Ride"] = 775}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1500, ["Fly"] = 2169.35, ["Ride"] = 1625, ["Fly|Ride"] = 1680, ["Neon|Fly|Ride"] = 3373.65, ["Mega|Fly|Ride"] = 11875}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 24998.75, ["Fly"] = 31428.76, ["Ride"] = 50000, ["Fly|Ride"] = 26308.65, ["Neon|Ride"] = 62500, ["Neon|Fly|Ride"] = 67828.25, ["Mega"] = 200000, ["Mega|Fly|Ride"] = 175000}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 16.18, ["Fly"] = 375, ["Ride"] = 50, ["Fly|Ride"] = 882.96, ["Neon"] = 262.24, ["Neon|Ride"] = 262.24, ["Neon|Fly|Ride"] = 524.47, ["Mega"] = 1033.23, ["Mega|Ride"] = 1250, ["Mega|Fly|Ride"] = 1428.05}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 3.13, ["Fly"] = 69.41, ["Ride"] = 30.17, ["Fly|Ride"] = 138.47, ["Neon"] = 19.49, ["Neon|Fly"] = 200, ["Neon|Ride"] = 59.48, ["Neon|Fly|Ride"] = 125, ["Mega"] = 128.35, ["Mega|Ride"] = 212.5, ["Mega|Fly|Ride"] = 314.25}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 23.58}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 8.87, ["Ride"] = 34.79, ["Fly|Ride"] = 125, ["Neon"] = 72.68, ["Neon|Ride"] = 100, ["Mega"] = 292.06, ["Mega|Ride"] = 375, ["Mega|Fly|Ride"] = 596.25}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 876.96, ["Ride"] = 750, ["Fly|Ride"] = 850, ["Neon|Fly|Ride"] = 2379.5, ["Mega|Fly|Ride"] = 7997.19}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 875, ["Fly"] = 875, ["Ride"] = 812.5, ["Fly|Ride"] = 1087.5, ["Neon|Ride"] = 3038.78, ["Neon|Fly|Ride"] = 2961.25, ["Mega|Fly|Ride"] = 9953.11}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 37.5, ["Fly"] = 111.14, ["Ride"] = 37.33, ["Fly|Ride"] = 62.49, ["Neon"] = 68.75, ["Neon|Ride"] = 120, ["Neon|Fly|Ride"] = 261.26, ["Mega"] = 1146.79, ["Mega|Ride"] = 890, ["Mega|Fly|Ride"] = 1500}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 30.85}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 57.5, ["Fly"] = 116.61, ["Ride"] = 77.5, ["Fly|Ride"] = 126.25, ["Neon|Ride"] = 300, ["Neon|Fly|Ride"] = 400, ["Mega|Ride"] = 1923.06, ["Mega|Fly|Ride"] = 1585}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 93.15, ["Ride"] = 75, ["Fly|Ride"] = 200.05, ["Neon"] = 428.75, ["Neon|Ride"] = 352.66, ["Neon|Fly|Ride"] = 527.5, ["Mega"] = 1278.16, ["Mega|Fly|Ride"] = 1772.5}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 4.63, ["Fly"] = 40, ["Ride"] = 18.9, ["Fly|Ride"] = 47.51, ["Neon"] = 39.6, ["Neon|Fly"] = 499.98, ["Neon|Ride"] = 53.04, ["Neon|Fly|Ride"] = 119.83, ["Mega|Fly|Ride"] = 655.1}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 133.43, ["Fly"] = 137.5, ["Ride"] = 165.28, ["Fly|Ride"] = 200.64, ["Neon|Ride"] = 493.74, ["Neon|Fly|Ride"] = 495, ["Mega|Fly|Ride"] = 1830}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 3.93, ["Ride"] = 48.75, ["Fly|Ride"] = 131.62, ["Neon"] = 39.3, ["Neon|Ride"] = 300, ["Neon|Fly|Ride"] = 785.73, ["Mega"] = 162.5, ["Mega|Ride"] = 452.01}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 15, ["Fly"] = 39.55, ["Ride"] = 30.86, ["Fly|Ride"] = 72.68, ["Neon"] = 117.87, ["Neon|Ride"] = 124.99, ["Mega|Fly|Ride"] = 970}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 19.6, ["Ride"] = 53.04, ["Fly|Ride"] = 148.75, ["Neon"] = 233.77, ["Neon|Ride"] = 296.73, ["Mega"] = 3200, ["Mega|Ride"] = 1106.25}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 18.75, ["Fly"] = 196.44, ["Ride"] = 37.79, ["Fly|Ride"] = 64.17, ["Neon"] = 87.5, ["Neon|Ride"] = 109.13, ["Neon|Fly|Ride"] = 195.46, ["Mega|Fly|Ride"] = 1039.12}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6945, ["Ride"] = 6243.75, ["Fly|Ride"] = 5234.99, ["Neon"] = 32738.94, ["Neon|Ride"] = 22500, ["Neon|Fly|Ride"] = 23375.13, ["Mega|Fly|Ride"] = 88857.47}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 213.73, ["Fly"] = 289.06, ["Ride"] = 232.5, ["Fly|Ride"] = 286.04, ["Neon|Fly|Ride"] = 537.5, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 43.75, ["Fly"] = 300, ["Ride"] = 85.4, ["Fly|Ride"] = 171.63, ["Neon"] = 131.62, ["Neon|Fly"] = 230, ["Neon|Ride"] = 175.12, ["Neon|Fly|Ride"] = 263.75, ["Mega"] = 433.6, ["Mega|Ride"] = 397.5, ["Mega|Fly|Ride"] = 500}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 3.5, ["Fly"] = 82.24, ["Ride"] = 74.47, ["Fly|Ride"] = 50, ["Neon"] = 19.66, ["Neon|Ride"] = 62.5, ["Neon|Fly|Ride"] = 178.76, ["Mega"] = 325, ["Mega|Ride"] = 179.99, ["Mega|Fly|Ride"] = 332.11}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 63.3, ["Fly"] = 5037.55, ["Ride"] = 90.58, ["Fly|Ride"] = 235.73, ["Neon"] = 131.62, ["Neon|Fly"] = 250, ["Neon|Ride"] = 252.52, ["Neon|Fly|Ride"] = 437.06, ["Mega"] = 537.5, ["Mega|Ride"] = 552.81, ["Mega|Fly|Ride"] = 579.4}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 15700, ["Ride"] = 12750, ["Fly|Ride"] = 11373.75, ["Neon|Fly|Ride"] = 21750}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 212.5, ["Ride"] = 237.5, ["Fly|Ride"] = 437.5, ["Neon"] = 1449.15, ["Neon|Fly|Ride"] = 1500, ["Mega|Fly|Ride"] = 5631.65}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 66.86, ["Fly"] = 87.5, ["Ride"] = 54.45, ["Fly|Ride"] = 90, ["Neon"] = 1000, ["Neon|Ride"] = 312.5, ["Neon|Fly|Ride"] = 392.87, ["Mega|Fly|Ride"] = 3275.48}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 15, ["Fly"] = 42.24, ["Ride"] = 26.52, ["Fly|Ride"] = 71.16, ["Neon"] = 65.82, ["Neon|Ride"] = 75, ["Neon|Fly|Ride"] = 150, ["Mega|Fly|Ride"] = 437.5}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 360, ["Ride"] = 374.99, ["Fly|Ride"] = 476.56, ["Neon"] = 1687.5, ["Neon|Ride"] = 1600, ["Neon|Fly|Ride"] = 1500, ["Mega|Fly|Ride"] = 4772.5}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 6.03, ["Ride"] = 36.95, ["Fly|Ride"] = 106.06, ["Neon"] = 25, ["Neon|Ride"] = 98.75, ["Neon|Fly|Ride"] = 157.15, ["Mega"] = 161.25, ["Mega|Ride"] = 209.37, ["Mega|Fly|Ride"] = 327.5}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 119.55, ["Fly"] = 222.44, ["Ride"] = 156.25, ["Fly|Ride"] = 262.24, ["Neon"] = 521.53, ["Neon|Ride"] = 500, ["Neon|Fly|Ride"] = 531.25, ["Mega|Fly|Ride"] = 2500}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 11.93, ["Fly"] = 17.85, ["Ride"] = 17.9, ["Fly|Ride"] = 35.84, ["Neon|Ride"] = 92.33, ["Neon|Fly|Ride"] = 85.73, ["Mega"] = 2357.17}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 8.75}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 75, ["Ride"] = 55.67, ["Fly|Ride"] = 131.62, ["Neon"] = 401.25, ["Neon|Fly"] = 1571.45, ["Neon|Ride"] = 500, ["Neon|Fly|Ride"] = 2946.45, ["Mega|Ride"] = 1250}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 16.25, ["Fly"] = 97.25, ["Ride"] = 32.5, ["Fly|Ride"] = 88.75, ["Neon"] = 102.5, ["Neon|Ride"] = 157.15, ["Neon|Fly|Ride"] = 229.47, ["Mega|Fly|Ride"] = 785.73}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 25}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 52.73, ["Fly"] = 200, ["Ride"] = 87.5, ["Fly|Ride"] = 237.5, ["Neon"] = 207.82, ["Neon|Ride"] = 300, ["Neon|Fly|Ride"] = 490.1, ["Mega"] = 1473.24, ["Mega|Ride"] = 1992.5, ["Mega|Fly|Ride"] = 1187.5}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 4.44, ["Neon"] = 23.75, ["Neon|Ride"] = 96.7, ["Neon|Fly|Ride"] = 262.24, ["Mega"] = 118.75, ["Mega|Ride"] = 203.25}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 11.93, ["Fly"] = 50, ["Ride"] = 26.9, ["Fly|Ride"] = 74.47, ["Neon|Ride"] = 145.36, ["Neon|Fly|Ride"] = 196.44, ["Mega|Ride"] = 597.15, ["Mega|Fly|Ride"] = 740.86}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 425, ["Ride"] = 466.93, ["Fly|Ride"] = 589.3, ["Neon|Fly|Ride"] = 5238.8, ["Mega|Fly|Ride"] = 15000}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 55, ["Ride"] = 61.72, ["Fly|Ride"] = 289.75, ["Neon|Ride"] = 250, ["Mega|Ride"] = 649, ["Mega|Fly|Ride"] = 2600}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 57.9, ["Fly"] = 114.18, ["Ride"] = 65.82, ["Fly|Ride"] = 145.36, ["Neon|Ride"] = 392.87, ["Neon|Fly|Ride"] = 436.28, ["Mega|Fly|Ride"] = 868.23}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 33.32, ["Fly"] = 74.47, ["Ride"] = 56.24, ["Fly|Ride"] = 118.01, ["Neon"] = 88.51, ["Neon|Ride"] = 161.09, ["Neon|Fly|Ride"] = 398.75, ["Mega"] = 433.14, ["Mega|Ride"] = 424.3, ["Mega|Fly|Ride"] = 575}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 8125, ["Ride"] = 12743.32, ["Fly|Ride"] = 7750, ["Neon|Fly|Ride"] = 16125, ["Mega|Fly|Ride"] = 37000}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1331.24, ["Ride"] = 1375, ["Fly|Ride"] = 1464.5, ["Neon|Fly|Ride"] = 4750, ["Mega|Fly|Ride"] = 13750}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 625, ["Ride"] = 812.5, ["Fly|Ride"] = 750, ["Neon"] = 2430.89, ["Mega|Fly|Ride"] = 6547.99}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 10.11, ["Fly"] = 19.71, ["Ride"] = 21.11, ["Fly|Ride"] = 38.57, ["Neon|Ride"] = 68.75, ["Neon|Fly|Ride"] = 157.15, ["Mega|Fly|Ride"] = 545}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 7.5, ["Fly"] = 74.99, ["Ride"] = 28.19, ["Neon"] = 23.75, ["Neon|Ride"] = 52.41, ["Mega"] = 139.88, ["Mega|Ride"] = 164.4, ["Mega|Fly|Ride"] = 312.5}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 49.01, ["Fly"] = 69.74, ["Ride"] = 60, ["Fly|Ride"] = 96.43, ["Neon"] = 255.37, ["Neon|Ride"] = 190.55, ["Neon|Fly|Ride"] = 180.9, ["Mega|Fly|Ride"] = 555}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.75, ["Fly"] = 26.18, ["Ride"] = 19.36, ["Fly|Ride"] = 37.5, ["Neon"] = 29.98, ["Neon|Fly"] = 73.25, ["Neon|Ride"] = 50, ["Neon|Fly|Ride"] = 74.91, ["Mega"] = 248.75, ["Mega|Ride"] = 252.14}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 262.5, ["Fly"] = 362.5, ["Ride"] = 379.99, ["Fly|Ride"] = 399.38, ["Neon|Fly|Ride"] = 1571.45}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 21.95, ["Fly"] = 55.57, ["Ride"] = 30, ["Fly|Ride"] = 100, ["Neon"] = 199, ["Neon|Fly"] = 131.62, ["Neon|Ride"] = 170.91, ["Neon|Fly|Ride"] = 281.25, ["Mega|Ride"] = 749.9, ["Mega|Fly|Ride"] = 687.5}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 10.05, ["Fly"] = 23.75, ["Ride"] = 19.66, ["Fly|Ride"] = 43.75, ["Neon"] = 131.62, ["Neon|Fly"] = 126.7, ["Neon|Ride"] = 77.5, ["Neon|Fly|Ride"] = 112.5, ["Mega"] = 1500, ["Mega|Ride"] = 588.75, ["Mega|Fly|Ride"] = 406.25}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 653.56, ["Fly"] = 750, ["Ride"] = 495.38, ["Fly|Ride"] = 785.73, ["Neon|Fly|Ride"] = 1964.31, ["Mega|Fly|Ride"] = 9330.05}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1167.2, ["Ride"] = 1200, ["Fly|Ride"] = 1280, ["Neon"] = 4583.7, ["Neon|Ride"] = 3928.6, ["Neon|Fly|Ride"] = 3400, ["Mega|Fly|Ride"] = 13126}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 117.37, ["Fly"] = 127.69, ["Ride"] = 127.82, ["Fly|Ride"] = 115.91, ["Neon"] = 925, ["Neon|Ride"] = 557.58, ["Neon|Fly|Ride"] = 562.5, ["Mega|Fly|Ride"] = 2962.3}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 163.24, ["Fly"] = 149.99, ["Ride"] = 163.52, ["Fly|Ride"] = 220.06, ["Neon"] = 811.17, ["Neon|Ride"] = 600, ["Neon|Fly|Ride"] = 591.48, ["Mega|Ride"] = 2881.63, ["Mega|Fly|Ride"] = 2659.58}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 29.8, ["Ride"] = 51.16, ["Fly|Ride"] = 113.36, ["Neon"] = 367.34, ["Neon|Ride"] = 259.99, ["Mega|Ride"] = 1964.31, ["Mega|Fly|Ride"] = 980.2}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 150, ["Ride"] = 300, ["Fly|Ride"] = 568.75, ["Neon|Fly|Ride"] = 1244.02, ["Mega|Fly|Ride"] = 5892.9}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2130.16, ["Fly"] = 2111.49, ["Ride"] = 2365, ["Fly|Ride"] = 2226.54, ["Neon|Fly|Ride"] = 9821.49, ["Mega|Fly|Ride"] = 26657.25}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 51.13, ["Fly"] = 196.44, ["Ride"] = 77.6, ["Fly|Ride"] = 187.5, ["Neon"] = 487.5, ["Neon|Ride"] = 432.5, ["Neon|Fly|Ride"] = 327.5, ["Mega|Ride"] = 1047.97, ["Mega|Fly|Ride"] = 1332.88}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 600, ["Ride"] = 650, ["Fly|Ride"] = 681.03, ["Neon|Fly|Ride"] = 1256.2, ["Mega|Fly|Ride"] = 3287.48}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 37.69, ["Fly"] = 64.28, ["Ride"] = 43.75, ["Fly|Ride"] = 91.5, ["Neon|Ride"] = 253.41, ["Neon|Fly|Ride"] = 273.75, ["Mega|Fly|Ride"] = 1047.97}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 2.95, ["Fly"] = 41.23, ["Ride"] = 20.17, ["Fly|Ride"] = 58.07, ["Neon"] = 21.25, ["Neon|Fly"] = 132.5, ["Neon|Ride"] = 43.75, ["Neon|Fly|Ride"] = 74.47, ["Mega"] = 159.21, ["Mega|Fly"] = 237.5, ["Mega|Ride"] = 173.43, ["Mega|Fly|Ride"] = 283.75}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 47.9, ["Ride"] = 131.62, ["Fly|Ride"] = 241.25, ["Neon"] = 324.12, ["Neon|Ride"] = 300, ["Neon|Fly|Ride"] = 655.1, ["Mega|Fly|Ride"] = 1361.1}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 787.49, ["Ride"] = 787.5, ["Fly|Ride"] = 856.59, ["Neon|Ride"] = 2475, ["Neon|Fly|Ride"] = 2455.38, ["Mega|Fly|Ride"] = 7500}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 687.5, ["Ride"] = 1037.97, ["Fly|Ride"] = 7409.06, ["Mega|Fly|Ride"] = 14272.59}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 12.99, ["Fly"] = 26.47, ["Ride"] = 22.9, ["Fly|Ride"] = 44.8, ["Neon"] = 75, ["Neon|Ride"] = 117.87, ["Neon|Fly|Ride"] = 193.27, ["Mega|Fly|Ride"] = 666.44}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 7.39, ["Ride"] = 25, ["Fly|Ride"] = 65.82, ["Neon"] = 131.62, ["Neon|Ride"] = 75, ["Neon|Fly|Ride"] = 238.13, ["Mega"] = 493.75, ["Mega|Ride"] = 392.87, ["Mega|Fly|Ride"] = 612.5}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 3.75, ["Ride"] = 23.56, ["Fly|Ride"] = 97.5, ["Neon"] = 20.65, ["Neon|Fly"] = 296.73, ["Neon|Ride"] = 51.87, ["Neon|Fly|Ride"] = 162.44, ["Mega"] = 126.68, ["Mega|Fly"] = 125, ["Mega|Ride"] = 282.13, ["Mega|Fly|Ride"] = 318.75}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 40, ["Fly"] = 70.56, ["Ride"] = 49.75, ["Fly|Ride"] = 96.54, ["Neon"] = 237.5, ["Neon|Ride"] = 193.75, ["Neon|Fly|Ride"] = 260, ["Mega|Fly|Ride"] = 888.59}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 49.81, ["Ride"] = 128.75, ["Fly|Ride"] = 593.45, ["Neon"] = 403.87, ["Neon|Ride"] = 491.09, ["Neon|Fly|Ride"] = 662.5, ["Mega|Ride"] = 1473.24, ["Mega|Fly|Ride"] = 1440.82}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 16.25, ["Fly"] = 48.75, ["Ride"] = 33.75, ["Fly|Ride"] = 78.97, ["Neon"] = 78.75, ["Neon|Ride"] = 112.49, ["Neon|Fly|Ride"] = 183.67, ["Mega"] = 588.32, ["Mega|Ride"] = 408.59, ["Mega|Fly|Ride"] = 456.89}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 36.87, ["Ride"] = 43.56, ["Fly|Ride"] = 90.03, ["Neon"] = 308.4, ["Neon|Fly"] = 1310.2, ["Neon|Ride"] = 125, ["Neon|Fly|Ride"] = 187.39, ["Mega"] = 2000, ["Mega|Ride"] = 979.21, ["Mega|Fly|Ride"] = 749.99}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 5.89, ["Fly"] = 19.88, ["Ride"] = 15, ["Fly|Ride"] = 40, ["Neon"] = 27.8, ["Neon|Ride"] = 57.5, ["Neon|Fly|Ride"] = 113.75, ["Mega"] = 687.51, ["Mega|Ride"] = 345.73, ["Mega|Fly|Ride"] = 524.47}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 7.25, ["Fly"] = 41.99, ["Ride"] = 33.4, ["Fly|Ride"] = 30119.55, ["Neon"] = 30.21, ["Neon|Fly"] = 110.03, ["Neon|Ride"] = 86.25, ["Neon|Fly|Ride"] = 196.44, ["Mega"] = 292.5, ["Mega|Ride"] = 298.13}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 73.5, ["Fly"] = 62.5, ["Ride"] = 48.75, ["Fly|Ride"] = 90, ["Neon"] = 385.63, ["Neon|Ride"] = 196.44, ["Neon|Fly|Ride"] = 248.74, ["Mega|Fly|Ride"] = 1022.91}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1500, ["Fly"] = 1499.99, ["Ride"] = 1602.48, ["Fly|Ride"] = 1600, ["Neon|Fly|Ride"] = 3674.99, ["Mega|Fly|Ride"] = 12381.27}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 425, ["Fly"] = 456.96, ["Ride"] = 437.5, ["Fly|Ride"] = 500, ["Mega|Fly|Ride"] = 9167.38}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 288.84, ["Ride"] = 315.57, ["Fly|Ride"] = 1178.59, ["Neon"] = 937.5, ["Mega|Fly|Ride"] = 6250}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 45}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 25, ["Ride"] = 42.23, ["Fly|Ride"] = 93.75, ["Neon|Ride"] = 490.1, ["Neon|Fly|Ride"] = 392.87, ["Mega|Ride"] = 1428.05, ["Mega|Fly|Ride"] = 988.75}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 32661.74, ["Fly"] = 62500, ["Ride"] = 33339.08, ["Fly|Ride"] = 16125, ["Neon|Fly|Ride"] = 36250, ["Mega|Fly|Ride"] = 85000}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 279.74, ["Fly"] = 9821.49, ["Ride"] = 350, ["Fly|Ride"] = 362.02, ["Neon"] = 1308.23, ["Neon|Ride"] = 1027.33, ["Neon|Fly|Ride"] = 987.5, ["Mega"] = 4451.1, ["Mega|Fly|Ride"] = 3687.5}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 261.63, ["Fly"] = 500, ["Ride"] = 131.62, ["Fly|Ride"] = 193.75}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 187.5, ["Fly"] = 262.24, ["Ride"] = 168.75, ["Fly|Ride"] = 206.25, ["Neon|Ride"] = 720.91, ["Neon|Fly|Ride"] = 607.5, ["Mega|Fly|Ride"] = 2875}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 13.53, ["Fly"] = 90, ["Ride"] = 29.92, ["Fly|Ride"] = 117.87, ["Neon|Ride"] = 131.62, ["Neon|Fly|Ride"] = 915.37, ["Mega"] = 664.22, ["Mega|Ride"] = 524.47, ["Mega|Fly|Ride"] = 655.1}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 4964.82, ["Ride"] = 4905.84, ["Fly|Ride"] = 4430.27, ["Neon"] = 25535.87, ["Neon|Fly|Ride"] = 25928.72}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 28.75, ["Fly"] = 131.31, ["Ride"] = 29.96, ["Fly|Ride"] = 64.83, ["Neon"] = 321.25, ["Neon|Ride"] = 327.5, ["Neon|Fly|Ride"] = 330, ["Mega|Fly|Ride"] = 715.02}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 42.14, ["Ride"] = 52.7, ["Fly|Ride"] = 90.28, ["Neon"] = 384.72, ["Neon|Fly"] = 1310.2, ["Neon|Ride"] = 465.55, ["Neon|Fly|Ride"] = 375, ["Mega|Fly|Ride"] = 1307.5}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 654.99, ["Fly"] = 879.03, ["Ride"] = 681.23, ["Fly|Ride"] = 925, ["Neon"] = 2277.61, ["Neon|Ride"] = 1875, ["Neon|Fly|Ride"] = 1850, ["Mega"] = 7660.76, ["Mega|Fly"] = 7660.76, ["Mega|Fly|Ride"] = 7651.93}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 16.25, ["Fly"] = 29.92, ["Ride"] = 25.21, ["Fly|Ride"] = 37.5, ["Neon"] = 109.99, ["Neon|Ride"] = 131.62, ["Neon|Fly|Ride"] = 183.67, ["Mega|Fly|Ride"] = 610}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 12.05, ["Fly"] = 262.24, ["Ride"] = 26.25, ["Fly|Ride"] = 74.47, ["Neon"] = 125.58, ["Neon|Ride"] = 111.14, ["Neon|Fly|Ride"] = 235.73}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 103.75, ["Ride"] = 131.62, ["Fly|Ride"] = 262.24, ["Neon|Ride"] = 505, ["Neon|Fly|Ride"] = 785.73, ["Mega|Fly|Ride"] = 2750.02}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 21.57, ["Fly"] = 131.62, ["Ride"] = 55.09, ["Fly|Ride"] = 145.36, ["Neon"] = 96.25, ["Neon|Ride"] = 131.62, ["Neon|Fly|Ride"] = 234.28, ["Mega"] = 298.75, ["Mega|Fly"] = 681.62, ["Mega|Ride"] = 287.5, ["Mega|Fly|Ride"] = 362.5}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 4106.97, ["Ride"] = 3875, ["Fly|Ride"] = 3812.5, ["Neon|Ride"] = 11250, ["Neon|Fly|Ride"] = 10498.75, ["Mega"] = 34441.01, ["Mega|Fly|Ride"] = 33765.84}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 35, ["Ride"] = 76.25, ["Fly|Ride"] = 182.27, ["Neon"] = 1506.63, ["Neon|Ride"] = 181.25, ["Neon|Fly|Ride"] = 651.25, ["Mega|Ride"] = 1629.44, ["Mega|Fly|Ride"] = 745}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 6925, ["Fly"] = 7203.09, ["Ride"] = 6531.25, ["Fly|Ride"] = 6749.67, ["Neon|Ride"] = 18071.54, ["Neon|Fly|Ride"] = 17000, ["Mega|Fly|Ride"] = 77028.93}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 3.75, ["Fly"] = 20.9, ["Ride"] = 17.61, ["Fly|Ride"] = 27.9, ["Neon"] = 21.88, ["Neon|Fly"] = 59.63, ["Neon|Ride"] = 60, ["Neon|Fly|Ride"] = 83.75, ["Mega"] = 429.86, ["Mega|Fly|Ride"] = 325.1}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 13.75, ["Fly"] = 27.34, ["Ride"] = 23.93, ["Fly|Ride"] = 51.03, ["Neon"] = 183.67, ["Neon|Fly"] = 217.07, ["Neon|Ride"] = 524.47, ["Neon|Fly|Ride"] = 153.75, ["Mega|Fly|Ride"] = 891.25}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.94}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 25, ["Ride"] = 31.25, ["Fly|Ride"] = 110.49, ["Neon"] = 257.18, ["Neon|Ride"] = 150.17, ["Mega|Ride"] = 824.04, ["Mega|Fly|Ride"] = 1185.15}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 27.48, ["Fly"] = 181.3, ["Ride"] = 41.26, ["Fly|Ride"] = 95, ["Neon"] = 198.4, ["Neon|Ride"] = 225, ["Mega"] = 900, ["Mega|Fly|Ride"] = 1047.5}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 11.22, ["Fly"] = 18.42, ["Ride"] = 20.25, ["Fly|Ride"] = 33.4, ["Neon|Ride"] = 230, ["Neon|Fly|Ride"] = 171, ["Mega"] = 2357.17, ["Mega|Ride"] = 554.26, ["Mega|Fly|Ride"] = 509.74}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 7955.42}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2801.09}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 22.69}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 264.69, ["Ride"] = 235.73, ["Fly|Ride"] = 212.5, ["Mega|Fly|Ride"] = 5315.4}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 26.47, ["Fly"] = 123.76, ["Ride"] = 36.95, ["Fly|Ride"] = 132.5, ["Neon"] = 171.88, ["Neon|Ride"] = 148.85, ["Neon|Fly|Ride"] = 252.5, ["Mega|Ride"] = 510.73, ["Mega|Fly|Ride"] = 915.37}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 12.5}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 5.94, ["Ride"] = 28.49, ["Fly|Ride"] = 78.58, ["Neon|Ride"] = 170.91, ["Mega|Fly|Ride"] = 785.73}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2962.52}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 184.66, ["Fly"] = 392.87, ["Ride"] = 262.24, ["Fly|Ride"] = 312.5, ["Neon"] = 1037.97, ["Neon|Ride"] = 737.5, ["Neon|Fly|Ride"] = 785.73}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 131.31, ["Ride"] = 141.25, ["Fly|Ride"] = 196.44, ["Neon"] = 524.47, ["Neon|Ride"] = 549.03, ["Neon|Fly|Ride"] = 573.14, ["Mega|Fly|Ride"] = 1750}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 163.14, ["Fly"] = 328.05, ["Ride"] = 192.29, ["Fly|Ride"] = 250, ["Neon"] = 855, ["Neon|Ride"] = 1006.32, ["Neon|Fly|Ride"] = 1178.59, ["Mega|Fly|Ride"] = 4321.46}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1725, ["Fly"] = 1250, ["Ride"] = 2107.17, ["Fly|Ride"] = 2086.38, ["Neon"] = 7779.12, ["Neon|Fly|Ride"] = 6125, ["Mega|Fly|Ride"] = 16875}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 15, ["Ride"] = 65.82, ["Fly|Ride"] = 95, ["Neon"] = 121.25, ["Neon|Ride"] = 193.38, ["Neon|Fly|Ride"] = 415.45, ["Mega"] = 882.96, ["Mega|Ride"] = 963, ["Mega|Fly|Ride"] = 875}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 759.38, ["Fly"] = 2000, ["Ride"] = 699.9, ["Fly|Ride"] = 903.58, ["Neon|Fly|Ride"] = 3850.87, ["Mega|Fly|Ride"] = 17771.51}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 49.27}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 16.63, ["Ride"] = 40, ["Fly|Ride"] = 781.8, ["Neon"] = 88.91, ["Neon|Ride"] = 131.62, ["Neon|Fly|Ride"] = 296.57, ["Mega"] = 380.06, ["Mega|Ride"] = 495, ["Mega|Fly|Ride"] = 667.5}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 8.75, ["Fly"] = 250, ["Ride"] = 26.25, ["Fly|Ride"] = 92.16, ["Neon"] = 50.6, ["Neon|Ride"] = 62.5, ["Neon|Fly|Ride"] = 200, ["Mega|Ride"] = 392.87}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 84.59}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 19.44, ["Ride"] = 22.57, ["Fly|Ride"] = 76.62, ["Neon"] = 88.91, ["Neon|Ride"] = 235.73, ["Neon|Fly|Ride"] = 458.67, ["Mega|Fly|Ride"] = 1834.67}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["Ride"] = 43.75, ["Fly|Ride"] = 46.25, ["Neon|Ride"] = 392.87, ["Neon|Fly|Ride"] = 312.33, ["Mega|Ride"] = 1666.09, ["Mega|Fly|Ride"] = 915.37}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6248.75, ["Fly"] = 10476.59, ["Ride"] = 7409.06, ["Fly|Ride"] = 4986.25, ["Neon|Fly|Ride"] = 11655.16, ["Mega|Fly|Ride"] = 33750}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 9.9, ["Fly"] = 62.5, ["Ride"] = 31.68, ["Fly|Ride"] = 71.13, ["Neon"] = 78.58, ["Neon|Ride"] = 125, ["Neon|Fly|Ride"] = 207.72, ["Mega"] = 392.87, ["Mega|Ride"] = 565.72, ["Mega|Fly|Ride"] = 662.25}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 24.09}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 100, ["Fly"] = 347.7, ["Ride"] = 128.75, ["Fly|Ride"] = 221.98, ["Neon"] = 500, ["Neon|Ride"] = 375, ["Neon|Fly|Ride"] = 666.44, ["Mega"] = 2742.46, ["Mega|Fly|Ride"] = 2074.83}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 49.06, ["Fly"] = 132.98, ["Ride"] = 96.26, ["Fly|Ride"] = 181.25, ["Neon"] = 327.85, ["Neon|Ride"] = 289.75, ["Neon|Fly|Ride"] = 375, ["Mega"] = 2221.45, ["Mega|Ride"] = 2651.81, ["Mega|Fly|Ride"] = 1824.92}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 22.6, ["Fly"] = 67.11, ["Ride"] = 26.25, ["Fly|Ride"] = 77.5, ["Neon|Fly"] = 222.96, ["Neon|Ride"] = 151.26, ["Neon|Fly|Ride"] = 181.23, ["Mega"] = 967.81, ["Mega|Ride"] = 815.27, ["Mega|Fly|Ride"] = 700}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 9.67, ["Fly"] = 62.32, ["Ride"] = 28.9, ["Fly|Ride"] = 89.69, ["Neon"] = 36.08, ["Neon|Fly"] = 62.5, ["Neon|Ride"] = 46.52, ["Neon|Fly|Ride"] = 150, ["Mega"] = 206.15, ["Mega|Fly"] = 242.5, ["Mega|Ride"] = 169.9, ["Mega|Fly|Ride"] = 293.13}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 13.23, ["Ride"] = 30, ["Fly|Ride"] = 70, ["Neon"] = 82.12, ["Neon|Ride"] = 131.62, ["Neon|Fly|Ride"] = 152.5, ["Mega"] = 577.58, ["Mega|Ride"] = 504.28, ["Mega|Fly|Ride"] = 556.25}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 18.65, ["Fly"] = 28.75, ["Ride"] = 25.88, ["Fly|Ride"] = 50.16, ["Neon"] = 147.33, ["Neon|Ride"] = 138.75, ["Neon|Fly|Ride"] = 137.5, ["Mega|Fly|Ride"] = 666.44}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 205.47}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 52.92, ["Ride"] = 93.75, ["Neon"] = 187.5, ["Neon|Fly|Ride"] = 538.23, ["Mega"] = 1047.97, ["Mega|Fly|Ride"] = 750}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 198.75, ["Ride"] = 422.5, ["Fly|Ride"] = 1482.49}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 43.45, ["Fly"] = 202.19, ["Ride"] = 101.41, ["Fly|Ride"] = 217.07, ["Neon"] = 487.16, ["Neon|Ride"] = 250, ["Neon|Fly|Ride"] = 462.5, ["Mega"] = 1178.59, ["Mega|Ride"] = 1125, ["Mega|Fly|Ride"] = 1206.09}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 874.99, ["Fly"] = 1270.92, ["Ride"] = 854.98, ["Fly|Ride"] = 1018.52, ["Neon|Fly"] = 3845.12, ["Neon|Ride"] = 3125, ["Neon|Fly|Ride"] = 3000, ["Mega|Fly|Ride"] = 12310.26}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 382.5, ["Fly"] = 655.1, ["Ride"] = 393.75, ["Fly|Ride"] = 524.47, ["Neon"] = 2750.02, ["Neon|Ride"] = 1964.31, ["Neon|Fly|Ride"] = 2118.16, ["Mega|Fly|Ride"] = 7562.5}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 67.92}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 3.75}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 10, ["Fly"] = 75, ["Ride"] = 22.91, ["Fly|Ride"] = 65.82, ["Neon"] = 75, ["Neon|Fly"] = 157.15, ["Neon|Ride"] = 112.5, ["Neon|Fly|Ride"] = 150, ["Mega|Ride"] = 655.1, ["Mega|Fly|Ride"] = 487.5}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 248.75, ["Ride"] = 299.62, ["Fly|Ride"] = 362.5, ["Neon"] = 1045.02, ["Neon|Ride"] = 958.5, ["Neon|Fly|Ride"] = 873.75, ["Mega|Fly|Ride"] = 3038.78}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 18.75}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 131.31, ["Ride"] = 245.55, ["Fly|Ride"] = 279.23, ["Neon"] = 1473.24, ["Neon|Fly"] = 552.96, ["Neon|Ride"] = 500, ["Neon|Fly|Ride"] = 624.9, ["Mega"] = 9428.64, ["Mega|Ride"] = 11172.93, ["Mega|Fly|Ride"] = 2879.67}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 121.25, ["Fly"] = 100, ["Ride"] = 124.81, ["Fly|Ride"] = 192.51, ["Neon"] = 655.1, ["Neon|Ride"] = 2160.74, ["Neon|Fly|Ride"] = 870, ["Mega|Ride"] = 3275.48}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 5.89, ["Ride"] = 29.38, ["Fly|Ride"] = 160.1, ["Neon"] = 30.02, ["Neon|Ride"] = 82.43, ["Neon|Fly|Ride"] = 219.93, ["Mega"] = 153.07, ["Mega|Ride"] = 200, ["Mega|Fly|Ride"] = 784.74}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 15.82, ["Fly"] = 60.02, ["Ride"] = 25.83, ["Fly|Ride"] = 70.47, ["Neon"] = 168.75, ["Neon|Ride"] = 156.25, ["Neon|Fly|Ride"] = 296.57, ["Mega|Ride"] = 1310.2, ["Mega|Fly|Ride"] = 587.5}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 16.25, ["Fly"] = 97.46, ["Ride"] = 50.1, ["Fly|Ride"] = 99.61, ["Neon"] = 100, ["Neon|Ride"] = 125.72, ["Neon|Fly|Ride"] = 244.35, ["Mega"] = 475, ["Mega|Ride"] = 444.3, ["Mega|Fly|Ride"] = 694.39}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 7.85, ["Fly"] = 124.98, ["Ride"] = 49.59, ["Fly|Ride"] = 196.44, ["Neon"] = 28.04, ["Neon|Ride"] = 67.22, ["Neon|Fly|Ride"] = 164.27, ["Mega"] = 148.27, ["Mega|Ride"] = 162.5, ["Mega|Fly|Ride"] = 260}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 260, ["Ride"] = 276.22, ["Fly|Ride"] = 337.5, ["Neon"] = 1545.92, ["Neon|Ride"] = 1264, ["Neon|Fly|Ride"] = 1250}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 156.89, ["Fly"] = 523.24, ["Ride"] = 196.44, ["Fly|Ride"] = 308.4, ["Neon"] = 1571.45, ["Neon|Ride"] = 3665.38, ["Neon|Fly|Ride"] = 1117.4, ["Mega"] = 2370.28, ["Mega|Fly|Ride"] = 6776.83}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 71.25, ["Ride"] = 68.75, ["Fly|Ride"] = 167.96, ["Neon"] = 375, ["Neon|Ride"] = 498.73, ["Neon|Fly|Ride"] = 396.25}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 11.88, ["Ride"] = 65.82, ["Fly|Ride"] = 262.24, ["Neon|Ride"] = 564.55, ["Neon|Fly|Ride"] = 458.67, ["Mega|Ride"] = 589.3}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 15, ["Fly"] = 72.02, ["Ride"] = 37.79, ["Fly|Ride"] = 72.37, ["Neon"] = 73.71, ["Neon|Fly"] = 262.24, ["Neon|Ride"] = 117.87, ["Neon|Fly|Ride"] = 187.6, ["Mega"] = 353.75, ["Mega|Fly"] = 500, ["Mega|Ride"] = 408.59, ["Mega|Fly|Ride"] = 510.73}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.57, ["Fly"] = 49.95, ["Ride"] = 21.61, ["Fly|Ride"] = 41.95, ["Neon"] = 23.75, ["Neon|Fly"] = 62.45, ["Neon|Ride"] = 33.57, ["Neon|Fly|Ride"] = 112.47, ["Mega"] = 152.24, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 367.34}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 868.75, ["Fly"] = 1031.16, ["Ride"] = 919.5, ["Fly|Ride"] = 906.24, ["Neon|Ride"] = 2995.56, ["Neon|Fly|Ride"] = 2499.88, ["Mega|Fly|Ride"] = 9656.5}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["Ride"] = 340.29, ["Fly|Ride"] = 431.25, ["Neon|Ride"] = 1125, ["Neon|Fly|Ride"] = 1629.44, ["Mega"] = 9821.49, ["Mega|Fly|Ride"] = 5500.04}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 87.5, ["Fly"] = 131.62, ["Ride"] = 98.7, ["Fly|Ride"] = 181.25, ["Neon"] = 323.75, ["Neon|Ride"] = 295.29, ["Neon|Fly|Ride"] = 785.73, ["Mega|Ride"] = 1571.45, ["Mega|Fly|Ride"] = 3928.6}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 251.25, ["Fly"] = 497.95, ["Ride"] = 353.58, ["Fly|Ride"] = 348.75, ["Neon|Fly|Ride"] = 1178.59, ["Mega|Fly|Ride"] = 6250}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 16.98, ["Fly"] = 50, ["Ride"] = 26.25, ["Fly|Ride"] = 62.5, ["Neon"] = 161.25, ["Neon|Ride"] = 187.5, ["Neon|Fly|Ride"] = 262.24, ["Mega|Fly|Ride"] = 740.86}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 224.9, ["Ride"] = 476.76, ["Fly|Ride"] = 450, ["Neon"] = 775.26, ["Neon|Ride"] = 897.5, ["Neon|Fly|Ride"] = 675, ["Mega|Ride"] = 4321.46, ["Mega|Fly|Ride"] = 3636.48}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 40, ["Fly"] = 119.98, ["Ride"] = 66.14, ["Fly|Ride"] = 117.87, ["Neon|Ride"] = 559.81, ["Neon|Fly|Ride"] = 524.47, ["Mega|Fly|Ride"] = 1650}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1781.25, ["Ride"] = 2125, ["Fly|Ride"] = 1500, ["Neon|Ride"] = 10367.45, ["Neon|Fly|Ride"] = 6547.99, ["Mega"] = 47143.13, ["Mega|Fly|Ride"] = 21174.15}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 12.68, ["Fly"] = 111.32, ["Ride"] = 37.33, ["Fly|Ride"] = 88.32, ["Neon"] = 49.41, ["Neon|Ride"] = 72.68, ["Neon|Fly|Ride"] = 375, ["Mega"] = 327.67, ["Mega|Ride"] = 620, ["Mega|Fly|Ride"] = 441.6}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 50.46, ["Ride"] = 183.67, ["Fly|Ride"] = 128.67, ["Neon"] = 180, ["Neon|Ride"] = 328.05, ["Mega|Fly|Ride"] = 1308.23}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 100, ["Fly"] = 74.95, ["Ride"] = 72.5, ["Fly|Ride"] = 92.5, ["Neon"] = 500, ["Neon|Fly|Ride"] = 362.5, ["Mega|Fly|Ride"] = 1754.64}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 3267.75, ["Fly"] = 1482.49, ["Ride"] = 1022.5, ["Fly|Ride"] = 1000, ["Mega|Fly|Ride"] = 15000}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 12500, ["Fly|Ride"] = 625}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 79.43, ["Fly"] = 295.87, ["Ride"] = 131.25, ["Fly|Ride"] = 205.67, ["Neon"] = 423.13, ["Neon|Ride"] = 443.75, ["Neon|Fly|Ride"] = 512.5, ["Mega|Ride"] = 3928.6, ["Mega|Fly|Ride"] = 3275.48}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 9.67, ["Ride"] = 21.25, ["Fly|Ride"] = 131.62, ["Neon"] = 65.84, ["Neon|Fly"] = 131.62, ["Neon|Ride"] = 91.25, ["Neon|Fly|Ride"] = 187.5}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 36.35, ["Fly"] = 261.63, ["Ride"] = 51.97, ["Fly|Ride"] = 113.94, ["Neon"] = 250, ["Neon|Fly"] = 308.4, ["Neon|Ride"] = 500, ["Neon|Fly|Ride"] = 353.58, ["Mega|Fly|Ride"] = 999.99}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 721.25, ["Ride"] = 832.5, ["Fly|Ride"] = 781.25, ["Neon|Ride"] = 2250, ["Neon|Fly|Ride"] = 2059.44, ["Mega|Fly|Ride"] = 9260}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 693.37}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 4687.5, ["Fly|Ride"] = 5304.36, ["Neon"] = 40000, ["Neon|Ride"] = 28149.36, ["Neon|Fly|Ride"] = 21875, ["Mega|Fly|Ride"] = 83810.66}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 300.82, ["Fly"] = 653.56, ["Neon"] = 1571.45, ["Neon|Ride"] = 1964.31, ["Neon|Fly|Ride"] = 2062.52, ["Mega"] = 5891.91}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 81.25, ["Fly"] = 261.63, ["Ride"] = 116.25, ["Fly|Ride"] = 320, ["Neon"] = 593.45, ["Neon|Ride"] = 1571.45, ["Neon|Fly|Ride"] = 1567.52, ["Mega|Fly|Ride"] = 2037.86}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 12.58, ["Fly"] = 39.21, ["Ride"] = 36.17, ["Fly|Ride"] = 150, ["Neon"] = 106.25, ["Neon|Fly"] = 1185.77, ["Neon|Ride"] = 118.34, ["Neon|Fly|Ride"] = 229.83, ["Mega|Ride"] = 785.73, ["Mega|Fly|Ride"] = 655.1}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 12.5, ["Fly"] = 24.99, ["Ride"] = 19.21, ["Fly|Ride"] = 45, ["Neon"] = 196.44, ["Neon|Ride"] = 296.57, ["Neon|Fly|Ride"] = 197.71, ["Mega"] = 1250, ["Mega|Fly|Ride"] = 2095.91}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 15.58, ["Ride"] = 33.4, ["Fly|Ride"] = 133.37, ["Neon"] = 97.5, ["Neon|Ride"] = 133.75, ["Neon|Fly|Ride"] = 220, ["Mega"] = 638.75, ["Mega|Ride"] = 627.5, ["Mega|Fly|Ride"] = 623.75}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 6.25, ["Ride"] = 21.25, ["Fly|Ride"] = 46.16, ["Neon"] = 33.75, ["Neon|Ride"] = 53.04, ["Neon|Fly|Ride"] = 123.76, ["Mega"] = 262.24, ["Mega|Ride"] = 223.75, ["Mega|Fly|Ride"] = 296.57}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 22.25, ["Fly"] = 86.25, ["Ride"] = 55, ["Fly|Ride"] = 132.5, ["Neon"] = 212.5, ["Neon|Fly"] = 785.73, ["Neon|Ride"] = 237.49, ["Neon|Fly|Ride"] = 388.75, ["Mega"] = 600, ["Mega|Ride"] = 1200}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 375, ["Fly"] = 512.5, ["Ride"] = 413.68, ["Fly|Ride"] = 474.27, ["Neon|Ride"] = 1310.2, ["Neon|Fly|Ride"] = 1225.65, ["Mega"] = 7500, ["Mega|Fly|Ride"] = 5105.22}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 3.93, ["Fly"] = 17.9, ["Ride"] = 13.75, ["Fly|Ride"] = 37.33, ["Neon"] = 25.55, ["Neon|Ride"] = 33.75, ["Neon|Fly|Ride"] = 100, ["Mega"] = 785.73, ["Mega|Ride"] = 296.57, ["Mega|Fly|Ride"] = 248.75}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 48.28, ["Fly"] = 92.42, ["Ride"] = 78.07, ["Fly|Ride"] = 156.59, ["Neon"] = 218.74, ["Neon|Fly"] = 371.19, ["Neon|Ride"] = 200.35, ["Neon|Fly|Ride"] = 257.34, ["Mega"] = 634.76, ["Mega|Ride"] = 555, ["Mega|Fly|Ride"] = 607.92}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 756.25, ["Ride"] = 674.9, ["Fly|Ride"] = 825, ["Neon|Ride"] = 1527.5, ["Neon|Fly|Ride"] = 1450, ["Mega|Fly|Ride"] = 3747.48}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 34.91, ["Fly"] = 157.49, ["Ride"] = 51.23, ["Fly|Ride"] = 86.39, ["Neon|Ride"] = 215.01, ["Neon|Fly|Ride"] = 237.5, ["Mega"] = 1500, ["Mega|Fly|Ride"] = 767.99}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 325, ["Fly"] = 362.57, ["Ride"] = 276.91, ["Fly|Ride"] = 328.75, ["Neon|Ride"] = 1482.49, ["Neon|Fly|Ride"] = 1375.01}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 156.25, ["Fly"] = 256.73, ["Ride"] = 187.13, ["Fly|Ride"] = 225, ["Neon|Ride"] = 675, ["Neon|Fly|Ride"] = 776.89, ["Mega|Fly|Ride"] = 4419.67}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 750, ["Ride"] = 718.75, ["Fly|Ride"] = 748.75, ["Neon|Fly|Ride"] = 2866.9, ["Mega|Fly|Ride"] = 7248.75}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 20.63, ["Ride"] = 42.5, ["Fly|Ride"] = 117.81, ["Neon"] = 116.25, ["Neon|Fly"] = 266.72, ["Neon|Ride"] = 73.75, ["Neon|Fly|Ride"] = 257.7, ["Mega"] = 337.5, ["Mega|Ride"] = 371.26, ["Mega|Fly|Ride"] = 495}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 3889.98, ["Ride"] = 3748.75, ["Fly|Ride"] = 2999.53, ["Neon"] = 13095.97, ["Neon|Fly|Ride"] = 6678.62, ["Mega|Fly|Ride"] = 23865}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 112.5, ["Fly"] = 158.36, ["Ride"] = 137.5, ["Fly|Ride"] = 187.38, ["Neon"] = 524.73, ["Neon|Ride"] = 625, ["Neon|Fly|Ride"] = 565, ["Mega|Fly|Ride"] = 2954.52}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.5, ["Fly"] = 26.47, ["Ride"] = 17.9, ["Fly|Ride"] = 35, ["Neon"] = 23.75, ["Neon|Fly"] = 62.5, ["Neon|Ride"] = 37.5, ["Neon|Fly|Ride"] = 75, ["Mega"] = 112.5, ["Mega|Fly"] = 425, ["Mega|Ride"] = 340.82, ["Mega|Fly|Ride"] = 232.5}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.68, ["Ride"] = 23.38, ["Fly|Ride"] = 54.96, ["Neon"] = 20, ["Neon|Ride"] = 37.5, ["Neon|Fly|Ride"] = 253.75, ["Mega"] = 153.8, ["Mega|Ride"] = 190, ["Mega|Fly|Ride"] = 351.62}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 25, ["Ride"] = 37.39, ["Fly|Ride"] = 53.65, ["Neon|Fly|Ride"] = 327.67}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 1125, ["Ride"] = 1310.2, ["Fly|Ride"] = 1236.25}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 6375, ["Fly|Ride"] = 6125}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 26.47, ["Fly"] = 34.28, ["Ride"] = 24.5, ["Fly|Ride"] = 45, ["Neon"] = 430.6, ["Neon|Ride"] = 262.24, ["Neon|Fly|Ride"] = 164.76, ["Mega"] = 2357.17, ["Mega|Fly|Ride"] = 625}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 15, ["Fly"] = 39.21, ["Ride"] = 23.67, ["Fly|Ride"] = 70.88, ["Neon"] = 93.32, ["Neon|Ride"] = 104.41, ["Neon|Fly|Ride"] = 205.28, ["Mega"] = 630.63, ["Mega|Ride"] = 740.86, ["Mega|Fly|Ride"] = 500}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 68.75, ["Fly"] = 200.37, ["Ride"] = 87.5, ["Fly|Ride"] = 107.8, ["Neon|Ride"] = 524.47, ["Neon|Fly|Ride"] = 420.64, ["Mega|Fly|Ride"] = 1505.99}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 254.99, ["Ride"] = 248.75, ["Fly|Ride"] = 301.25, ["Neon|Ride"] = 931.22, ["Neon|Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 4295.16}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 6.25, ["Ride"] = 28.9, ["Fly|Ride"] = 88.75, ["Neon"] = 30.02, ["Neon|Fly"] = 625, ["Neon|Ride"] = 97.25, ["Mega"] = 138.13, ["Mega|Ride"] = 182.12, ["Mega|Fly|Ride"] = 1308.23}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 175, ["Ride"] = 218.75, ["Fly|Ride"] = 271.03, ["Neon"] = 719.61, ["Neon|Ride"] = 1250, ["Neon|Fly|Ride"] = 803.75, ["Mega|Fly|Ride"] = 5062.5}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 3.25, ["Fly"] = 39.21, ["Ride"] = 15.64, ["Fly|Ride"] = 51.09, ["Neon"] = 21.2, ["Neon|Fly"] = 117.87, ["Neon|Ride"] = 41.25, ["Neon|Fly|Ride"] = 103.75, ["Mega"] = 251.04, ["Mega|Ride"] = 212.49, ["Mega|Fly|Ride"] = 314.3}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 212.5, ["Fly"] = 291.44, ["Ride"] = 212.5, ["Fly|Ride"] = 220.52, ["Neon|Fly|Ride"] = 671.6, ["Mega"] = 9821.49, ["Mega|Fly|Ride"] = 4580.75}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 14.71, ["Fly"] = 100, ["Ride"] = 27.5, ["Fly|Ride"] = 65, ["Neon"] = 92.89, ["Neon|Fly"] = 282.28, ["Neon|Ride"] = 145.36, ["Neon|Fly|Ride"] = 187.5, ["Mega"] = 457.69, ["Mega|Ride"] = 589.3, ["Mega|Fly|Ride"] = 428.09}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 3.75, ["Ride"] = 26.68, ["Fly|Ride"] = 62.41, ["Neon"] = 11.45, ["Neon|Fly"] = 162.33, ["Neon|Ride"] = 35, ["Neon|Fly|Ride"] = 168.75, ["Mega"] = 75, ["Mega|Ride"] = 109.54, ["Mega|Fly|Ride"] = 186.25}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2, ["Neon"] = 3.55, ["Mega"] = 21.12, ["Mega|Ride"] = 141.44}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 3.63, ["Fly"] = 49.99, ["Ride"] = 37.5, ["Fly|Ride"] = 103.01, ["Neon"] = 11.13, ["Neon|Ride"] = 41.36, ["Neon|Fly|Ride"] = 125, ["Mega"] = 72.5, ["Mega|Fly"] = 148096.52, ["Mega|Ride"] = 94.14, ["Mega|Fly|Ride"] = 196.18}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 66.25, ["Fly"] = 500, ["Ride"] = 93.27, ["Fly|Ride"] = 156.25, ["Neon"] = 324.38, ["Neon|Fly"] = 373.23, ["Neon|Ride"] = 281.24, ["Neon|Fly|Ride"] = 339.55, ["Mega|Fly|Ride"] = 1116.91}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2, ["Fly"] = 32.24, ["Ride"] = 14.98, ["Fly|Ride"] = 104.11, ["Neon"] = 8.13, ["Neon|Ride"] = 38.75, ["Neon|Fly|Ride"] = 50, ["Mega"] = 123.75, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 298.42}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 14.93, ["Neon"] = 150.03, ["Neon|Ride"] = 285, ["Mega"] = 437.5}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2, ["Neon"] = 2, ["Neon|Ride"] = 49.65, ["Mega"] = 16.56, ["Mega|Ride"] = 61.72}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2, ["Fly"] = 57.62, ["Ride"] = 16.68, ["Fly|Ride"] = 33.4, ["Neon"] = 2, ["Neon|Fly"] = 17.5, ["Neon|Ride"] = 14.09, ["Neon|Fly|Ride"] = 53.04, ["Mega"] = 13.75, ["Mega|Fly"] = 29.88, ["Mega|Ride"] = 18.75, ["Mega|Fly|Ride"] = 63.33}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2, ["Fly"] = 17.28, ["Ride"] = 12.1, ["Fly|Ride"] = 77.5, ["Neon"] = 3.13, ["Neon|Fly"] = 37.5, ["Neon|Ride"] = 14.75, ["Neon|Fly|Ride"] = 50, ["Mega"] = 24.5, ["Mega|Ride"] = 56.25}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2, ["Neon"] = 2, ["Mega"] = 88.75, ["Mega|Ride"] = 104.41}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.5, ["Fly"] = 87.46, ["Ride"] = 19.94, ["Fly|Ride"] = 102.5, ["Neon"] = 6.25, ["Neon|Fly"] = 160, ["Neon|Ride"] = 18.75, ["Neon|Fly|Ride"] = 86.25, ["Mega"] = 22.5, ["Mega|Fly"] = 87.5, ["Mega|Ride"] = 41.25, ["Mega|Fly|Ride"] = 175}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2, ["Neon"] = 3.75, ["Neon|Fly|Ride"] = 391.89, ["Mega"] = 18.45, ["Mega|Ride"] = 66.25, ["Mega|Fly|Ride"] = 196.44}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 6.25, ["Fly"] = 65.82, ["Ride"] = 25, ["Fly|Ride"] = 148.24, ["Neon"] = 11.42, ["Neon|Fly"] = 65.98, ["Neon|Ride"] = 30, ["Neon|Fly|Ride"] = 111.31, ["Mega"] = 123.75, ["Mega|Fly"] = 328.05, ["Mega|Ride"] = 118.7, ["Mega|Fly|Ride"] = 187.5}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2, ["Ride"] = 48.51, ["Neon"] = 2, ["Neon|Ride"] = 75, ["Neon|Fly|Ride"] = 246.25, ["Mega"] = 14.5, ["Mega|Fly"] = 137.5, ["Mega|Ride"] = 58.21, ["Mega|Fly|Ride"] = 176.79}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.5, ["Fly|Ride"] = 499.99, ["Neon"] = 15.43, ["Mega"] = 181.24, ["Mega|Fly"] = 300}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.03, ["Ride"] = 26.52, ["Neon"] = 15.9, ["Mega"] = 100, ["Mega|Ride"] = 75, ["Mega|Fly|Ride"] = 524.47}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2, ["Ride"] = 23.75, ["Neon"] = 3.44, ["Neon|Ride"] = 25.55, ["Neon|Fly|Ride"] = 131.62, ["Mega"] = 20, ["Mega|Ride"] = 38.87}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2, ["Fly"] = 18.75, ["Ride"] = 10.73, ["Fly|Ride"] = 31.25, ["Neon"] = 2, ["Neon|Fly"] = 15.77, ["Neon|Ride"] = 14.75, ["Neon|Fly|Ride"] = 30.89, ["Mega"] = 15, ["Mega|Fly"] = 37.33, ["Mega|Ride"] = 18.34, ["Mega|Fly|Ride"] = 47.58}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2, ["Fly"] = 68.75, ["Ride"] = 218.74, ["Fly|Ride"] = 112.48, ["Neon"] = 35, ["Neon|Ride"] = 134.23, ["Mega|Ride"] = 228.75}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2, ["Ride"] = 22.28, ["Neon"] = 3.75, ["Neon|Ride"] = 22.5, ["Neon|Fly|Ride"] = 100, ["Mega"] = 25, ["Mega|Ride"] = 51.91, ["Mega|Fly|Ride"] = 130.2}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 2.74, ["Neon"] = 10.89, ["Neon|Fly|Ride"] = 131.62, ["Mega"] = 90, ["Mega|Ride"] = 157.15, ["Mega|Fly|Ride"] = 227.49}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2, ["Fly"] = 87.5, ["Ride"] = 43.22, ["Fly|Ride"] = 178.76, ["Neon"] = 62.5, ["Neon|Ride"] = 53.04, ["Neon|Fly|Ride"] = 100, ["Mega"] = 118.75, ["Mega|Ride"] = 136.24, ["Mega|Fly|Ride"] = 184.2}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2, ["Fly"] = 11.12, ["Ride"] = 10.68, ["Fly|Ride"] = 19.18, ["Neon"] = 2, ["Neon|Fly"] = 14.75, ["Neon|Ride"] = 12.85, ["Neon|Fly|Ride"] = 29.48, ["Mega"] = 13.29, ["Mega|Fly"] = 35.37, ["Mega|Ride"] = 22.88, ["Mega|Fly|Ride"] = 51.49}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2, ["Fly"] = 26.52, ["Ride"] = 26.09, ["Fly|Ride"] = 125, ["Neon"] = 22.23, ["Neon|Ride"] = 62.5, ["Neon|Fly|Ride"] = 187.5, ["Mega"] = 100, ["Mega|Ride"] = 148.85, ["Mega|Fly|Ride"] = 187.5}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 12.5, ["Ride"] = 21.16, ["Fly|Ride"] = 56.24, ["Neon"] = 73.56, ["Neon|Ride"] = 64.26, ["Neon|Fly|Ride"] = 250, ["Mega"] = 224.99, ["Mega|Ride"] = 314.3, ["Mega|Fly|Ride"] = 444.3}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2, ["Fly"] = 30.8, ["Ride"] = 11.74, ["Fly|Ride"] = 41.13, ["Neon"] = 2, ["Neon|Fly"] = 22.5, ["Neon|Ride"] = 13.73, ["Neon|Fly|Ride"] = 33.74, ["Mega"] = 25.55, ["Mega|Ride"] = 30, ["Mega|Fly|Ride"] = 100}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.5, ["Fly"] = 164.03, ["Ride"] = 27.36, ["Neon"] = 7.44, ["Neon|Ride"] = 26.52, ["Neon|Fly|Ride"] = 187.5, ["Mega"] = 62.5, ["Mega|Fly"] = 157.15, ["Mega|Ride"] = 112.5}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2, ["Ride"] = 33.75, ["Neon"] = 4.6, ["Neon|Fly"] = 112.5, ["Neon|Ride"] = 31.25, ["Neon|Fly|Ride"] = 131.62, ["Mega"] = 33.32, ["Mega|Fly"] = 131.62, ["Mega|Ride"] = 131.62, ["Mega|Fly|Ride"] = 187.5}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2, ["Ride"] = 17.13, ["Neon"] = 2, ["Neon|Fly"] = 39.3, ["Neon|Ride"] = 32.5, ["Neon|Fly|Ride"] = 125, ["Mega"] = 18.75, ["Mega|Ride"] = 38.74}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.13, ["Fly"] = 87.5, ["Ride"] = 14.23, ["Fly|Ride"] = 40.01, ["Neon"] = 7.87, ["Neon|Ride"] = 33.75, ["Neon|Fly|Ride"] = 54.91, ["Mega"] = 86.7, ["Mega|Ride"] = 81.53}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2, ["Ride"] = 50.72, ["Neon"] = 4.68, ["Neon|Ride"] = 59.1, ["Mega"] = 38.75, ["Mega|Fly|Ride"] = 292.69}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2, ["Fly"] = 19, ["Ride"] = 16.72, ["Fly|Ride"] = 68.75, ["Neon"] = 23.75, ["Neon|Ride"] = 37.77, ["Neon|Fly|Ride"] = 80, ["Mega"] = 98.75, ["Mega|Ride"] = 86.25, ["Mega|Fly|Ride"] = 294.66}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 2.5, ["Fly"] = 40, ["Ride"] = 34.53, ["Neon"] = 40, ["Neon|Fly|Ride"] = 311.71, ["Mega"] = 93.75, ["Mega|Ride"] = 160.36}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2, ["Ride"] = 14.99, ["Fly|Ride"] = 54.74, ["Neon"] = 32.09, ["Neon|Fly"] = 53.04, ["Neon|Ride"] = 31.25, ["Neon|Fly|Ride"] = 131.62, ["Mega"] = 300, ["Mega|Fly"] = 400, ["Mega|Fly|Ride"] = 212.16}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2, ["Fly"] = 18.88, ["Ride"] = 18.75, ["Fly|Ride"] = 46.88, ["Neon"] = 21.12, ["Neon|Fly"] = 80, ["Neon|Ride"] = 44.46, ["Neon|Fly|Ride"] = 62.5, ["Mega"] = 262.24, ["Mega|Fly"] = 183.67, ["Mega|Ride"] = 392.87, ["Mega|Fly|Ride"] = 217.07}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 4.07, ["Fly"] = 104.11, ["Fly|Ride"] = 68.75, ["Neon"] = 67.91, ["Mega"] = 220.63, ["Mega|Ride"] = 224.99}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 14.05, ["Ride"] = 53.75, ["Neon"] = 250, ["Neon|Ride"] = 222.15, ["Mega|Ride"] = 655.1}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 3.43, ["Ride"] = 37.5, ["Neon"] = 37.5, ["Neon|Ride"] = 117.87, ["Mega"] = 243.59, ["Mega|Ride"] = 294.66}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 8.79, ["Ride"] = 43.75, ["Fly|Ride"] = 115, ["Neon"] = 50.8, ["Neon|Ride"] = 78.58, ["Mega"] = 444.3, ["Mega|Ride"] = 262.24, ["Mega|Fly|Ride"] = 343.13}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2, ["Neon"] = 3.71, ["Neon|Ride"] = 61.89, ["Mega"] = 31.25, ["Mega|Fly"] = 117.87, ["Mega|Ride"] = 117.87}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 37.75}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 5.89, ["Fly"] = 18.96, ["Ride"] = 16.17, ["Fly|Ride"] = 37.91, ["Neon"] = 41.25, ["Neon|Fly"] = 179.5, ["Neon|Ride"] = 56.98, ["Neon|Fly|Ride"] = 84.45, ["Mega"] = 356.49, ["Mega|Ride"] = 198.74, ["Mega|Fly|Ride"] = 277.9}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.5, ["Fly"] = 88.2, ["Ride"] = 18.75, ["Neon"] = 3.94, ["Neon|Fly"] = 30.02, ["Neon|Ride"] = 25.55, ["Neon|Fly|Ride"] = 146.63, ["Mega"] = 50, ["Mega|Ride"] = 100, ["Mega|Fly|Ride"] = 93.75}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2, ["Ride"] = 45.19, ["Neon"] = 8.91, ["Neon|Ride"] = 31.52, ["Mega"] = 42.24, ["Mega|Ride"] = 68.62, ["Mega|Fly|Ride"] = 127.5}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.5, ["Fly"] = 46.17, ["Ride"] = 15.73, ["Fly|Ride"] = 53, ["Neon"] = 14.75, ["Neon|Ride"] = 21.61, ["Neon|Fly|Ride"] = 110.7, ["Mega"] = 135, ["Mega|Ride"] = 148.85, ["Mega|Fly|Ride"] = 178.76}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 13.75, ["Ride"] = 34.91, ["Fly|Ride"] = 55, ["Neon"] = 40, ["Neon|Ride"] = 47.15, ["Neon|Fly|Ride"] = 206.25, ["Mega"] = 328.05, ["Mega|Ride"] = 262.32}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.48, ["Fly"] = 78.4, ["Ride"] = 25, ["Neon"] = 3.75, ["Mega"] = 19.98, ["Mega|Fly"] = 112.5, ["Mega|Ride"] = 57.5, ["Mega|Fly|Ride"] = 314.3}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2, ["Fly"] = 20.63, ["Ride"] = 14.59, ["Fly|Ride"] = 261906.55, ["Neon"] = 3, ["Neon|Fly"] = 104.11, ["Neon|Ride"] = 20, ["Neon|Fly|Ride"] = 95, ["Mega"] = 33.75, ["Mega|Ride"] = 41.35, ["Mega|Fly|Ride"] = 148.85}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2, ["Fly"] = 26.52, ["Ride"] = 12.49, ["Fly|Ride"] = 31.25, ["Neon"] = 3.75, ["Neon|Fly"] = 65.82, ["Neon|Ride"] = 17.28, ["Neon|Fly|Ride"] = 43.75, ["Mega"] = 45.66, ["Mega|Fly"] = 131.62, ["Mega|Ride"] = 53.75, ["Mega|Fly|Ride"] = 68.75}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2, ["Fly"] = 87.49, ["Ride"] = 49.86, ["Fly|Ride"] = 112.5, ["Neon"] = 3.75, ["Neon|Ride"] = 26.53, ["Neon|Fly|Ride"] = 148.85, ["Mega"] = 30.81, ["Mega|Ride"] = 75.79, ["Mega|Fly|Ride"] = 200}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2, ["Neon"] = 4.9, ["Neon|Ride"] = 157.15, ["Neon|Fly|Ride"] = 143059.42, ["Mega"] = 17.89, ["Mega|Fly"] = 101.38, ["Mega|Ride"] = 105.03, ["Mega|Fly|Ride"] = 390.9}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2, ["Fly"] = 43.68, ["Ride"] = 19.99, ["Fly|Ride"] = 47.8, ["Neon"] = 3.75, ["Neon|Fly"] = 43.75, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 79.99, ["Mega"] = 21.25, ["Mega|Fly"] = 58.94, ["Mega|Ride"] = 38.75, ["Mega|Fly|Ride"] = 112.5}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2, ["Ride"] = 27.5, ["Neon"] = 3.75, ["Neon|Ride"] = 34.98, ["Mega"] = 29.48, ["Mega|Ride"] = 159.38}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.5, ["Neon"] = 4.17, ["Neon|Ride"] = 282.28, ["Neon|Fly|Ride"] = 400, ["Mega"] = 24.32}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2, ["Fly"] = 25, ["Ride"] = 17.88, ["Fly|Ride"] = 47.49, ["Neon"] = 5, ["Neon|Ride"] = 22.6, ["Neon|Fly|Ride"] = 130, ["Mega"] = 117.87, ["Mega|Ride"] = 45.76, ["Mega|Fly|Ride"] = 89.99}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 13.18, ["Ride"] = 82.5, ["Neon"] = 491.09, ["Mega"] = 588.32, ["Mega|Ride"] = 863.32, ["Mega|Fly|Ride"] = 655.1}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 6.25, ["Fly"] = 6250, ["Ride"] = 78.58, ["Neon"] = 40}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 2, ["Ride"] = 28.88, ["Fly|Ride"] = 168.94, ["Neon"] = 65.82, ["Neon|Fly|Ride"] = 249.47, ["Mega"] = 379, ["Mega|Ride"] = 335.91, ["Mega|Fly|Ride"] = 357.4}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2, ["Fly"] = 12.35, ["Ride"] = 14.75, ["Fly|Ride"] = 21.76, ["Neon"] = 2.5, ["Neon|Fly"] = 13.89, ["Neon|Ride"] = 12.12, ["Neon|Fly|Ride"] = 24.57, ["Mega"] = 14.38, ["Mega|Fly"] = 21.71, ["Mega|Ride"] = 19.53, ["Mega|Fly|Ride"] = 48.55}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2, ["Fly"] = 112.49, ["Ride"] = 62.5, ["Neon"] = 3.94, ["Neon|Fly"] = 64.53, ["Neon|Ride"] = 30.46, ["Neon|Fly|Ride"] = 655.1, ["Mega"] = 81.24, ["Mega|Ride"] = 112.4}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2, ["Neon"] = 2.13, ["Neon|Fly"] = 29.48, ["Neon|Ride"] = 22.5, ["Neon|Fly|Ride"] = 78.58, ["Mega"] = 13.63, ["Mega|Ride"] = 66.23, ["Mega|Fly|Ride"] = 124.75}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2, ["Neon"] = 3.63, ["Neon|Fly"] = 57.99, ["Neon|Ride"] = 121.25, ["Mega"] = 16.72, ["Mega|Fly|Ride"] = 157.15}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2, ["Fly"] = 39.91, ["Ride"] = 15.89, ["Fly|Ride"] = 55.01, ["Neon"] = 9.9, ["Neon|Ride"] = 39.3, ["Neon|Fly|Ride"] = 85.34, ["Mega"] = 199, ["Mega|Ride"] = 373.23, ["Mega|Fly|Ride"] = 247.5}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 164.01, ["Ride"] = 202.5, ["Fly|Ride"] = 225, ["Mega"] = 7857.2, ["Mega|Fly|Ride"] = 3704.26}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.5, ["Ride"] = 16.68, ["Neon"] = 10, ["Neon|Ride"] = 78.58, ["Mega"] = 87.5, ["Mega|Ride"] = 157.15, ["Mega|Fly|Ride"] = 740.86}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 3.41, ["Fly"] = 61.87, ["Ride"] = 24.45, ["Fly|Ride"] = 54.56, ["Neon"] = 23.74, ["Neon|Ride"] = 88.87, ["Neon|Fly|Ride"] = 157.15, ["Mega"] = 343.75, ["Mega|Ride"] = 537.5, ["Mega|Fly|Ride"] = 388.95}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2, ["Fly"] = 14.39, ["Ride"] = 11.78, ["Fly|Ride"] = 34.31, ["Neon"] = 7.5, ["Neon|Fly"] = 26.52, ["Neon|Ride"] = 28.14, ["Neon|Fly|Ride"] = 53.04, ["Mega"] = 47.3, ["Mega|Ride"] = 77.5}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.35, ["Fly"] = 48.75, ["Ride"] = 22.64, ["Fly|Ride"] = 88.16, ["Neon"] = 5.94, ["Neon|Ride"] = 76.25, ["Neon|Fly|Ride"] = 112.5, ["Mega"] = 131.62, ["Mega|Ride"] = 176.79}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 6.03, ["Fly"] = 22.28, ["Ride"] = 16.68, ["Fly|Ride"] = 42.5, ["Neon"] = 44.46, ["Neon|Fly"] = 94.14, ["Neon|Ride"] = 31.25, ["Neon|Fly|Ride"] = 129.66, ["Mega|Ride"] = 258.32, ["Mega|Fly|Ride"] = 250}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 4.41, ["Ride"] = 39.13, ["Fly|Ride"] = 237.69, ["Neon"] = 74.7, ["Neon|Ride"] = 133.65, ["Neon|Fly|Ride"] = 583.41, ["Mega"] = 392.87, ["Mega|Ride"] = 332.7, ["Mega|Fly|Ride"] = 982.16}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 4.34, ["Fly"] = 22.01, ["Ride"] = 16.72, ["Fly|Ride"] = 33.44, ["Neon"] = 29.06, ["Neon|Fly"] = 72.5, ["Neon|Ride"] = 26.94, ["Neon|Fly|Ride"] = 49.91, ["Mega"] = 131.62, ["Mega|Fly|Ride"] = 296.57}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 52.8, ["Fly"] = 104.85, ["Ride"] = 84.77, ["Fly|Ride"] = 138.65, ["Neon"] = 312.5, ["Neon|Fly"] = 416.25, ["Neon|Ride"] = 325, ["Neon|Fly|Ride"] = 387.5, ["Mega|Fly|Ride"] = 1185.15}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 212.49, ["Fly"] = 314.3, ["Ride"] = 237.5, ["Fly|Ride"] = 325, ["Neon|Ride"] = 2455.38, ["Neon|Fly|Ride"] = 1332.88, ["Mega"] = 9821.49, ["Mega|Fly|Ride"] = 4583.7}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 64.91, ["Fly"] = 131.62, ["Ride"] = 71.37, ["Fly|Ride"] = 112.4, ["Neon"] = 666.79, ["Neon|Ride"] = 276.51, ["Neon|Fly|Ride"] = 392.87, ["Mega|Fly|Ride"] = 1172.6}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 6.25, ["Fly"] = 274.68, ["Ride"] = 32.41, ["Fly|Ride"] = 131.62, ["Neon"] = 25.55, ["Neon|Ride"] = 113.94, ["Neon|Fly|Ride"] = 187.5, ["Mega"] = 294.97, ["Mega|Ride"] = 373.75, ["Mega|Fly|Ride"] = 400}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 12.23, ["Fly"] = 65.82, ["Ride"] = 31.3, ["Fly|Ride"] = 92.33, ["Neon"] = 77.49, ["Neon|Ride"] = 120.24, ["Neon|Fly|Ride"] = 262.24, ["Mega"] = 336.25, ["Mega|Ride"] = 437.5, ["Mega|Fly|Ride"] = 1178.59}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2, ["Fly"] = 18.75, ["Ride"] = 16.68, ["Fly|Ride"] = 42.5, ["Neon"] = 3.13, ["Neon|Ride"] = 18.97, ["Neon|Fly|Ride"] = 57.19, ["Mega"] = 47.4, ["Mega|Fly"] = 147.5, ["Mega|Ride"] = 131.62, ["Mega|Fly|Ride"] = 80.43}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 7.5, ["Fly"] = 68.68, ["Ride"] = 17.5, ["Fly|Ride"] = 77.5, ["Neon"] = 105.1, ["Neon|Ride"] = 187.5, ["Neon|Fly|Ride"] = 143.41, ["Mega"] = 393.75, ["Mega|Ride"] = 970, ["Mega|Fly|Ride"] = 697.5}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2, ["Fly"] = 40, ["Ride"] = 14.48, ["Fly|Ride"] = 33.75, ["Neon"] = 11.25, ["Neon|Fly"] = 138.75, ["Neon|Ride"] = 27.29, ["Neon|Fly|Ride"] = 104.41, ["Mega"] = 170.91, ["Mega|Ride"] = 262.24, ["Mega|Fly|Ride"] = 165}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 2, ["Ride"] = 20.17, ["Fly|Ride"] = 312.5, ["Neon"] = 21.21, ["Neon|Ride"] = 62.5, ["Mega"] = 197.5, ["Mega|Ride"] = 325, ["Mega|Fly|Ride"] = 353.58}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2, ["Fly"] = 32.71, ["Ride"] = 18.27, ["Neon"] = 2, ["Neon|Ride"] = 18.71, ["Neon|Fly|Ride"] = 54.98, ["Mega"] = 14.99, ["Mega|Ride"] = 39.3, ["Mega|Fly|Ride"] = 100}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 3.75, ["Fly"] = 18.75, ["Ride"] = 17.5, ["Fly|Ride"] = 39.3, ["Neon"] = 14.99, ["Neon|Fly"] = 98.23, ["Neon|Ride"] = 28.49, ["Neon|Fly|Ride"] = 140, ["Mega"] = 103.75, ["Mega|Fly|Ride"] = 194.38}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.5, ["Fly"] = 23.75, ["Ride"] = 18.75, ["Fly|Ride"] = 58.2, ["Neon"] = 40.55, ["Neon|Ride"] = 45, ["Neon|Fly|Ride"] = 524.47, ["Mega"] = 249.47, ["Mega|Ride"] = 186.62, ["Mega|Fly|Ride"] = 262.24}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 257.71, ["Fly"] = 171.25, ["Ride"] = 249.99, ["Fly|Ride"] = 314.3, ["Neon"] = 1000, ["Neon|Ride"] = 500, ["Neon|Fly|Ride"] = 707.07, ["Mega"] = 3928.6, ["Mega|Ride"] = 2488.78, ["Mega|Fly|Ride"] = 1874.9}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 7.42, ["Ride"] = 117.87, ["Fly|Ride"] = 118.91, ["Neon"] = 111.98, ["Neon|Ride"] = 93.74, ["Neon|Fly|Ride"] = 358.62, ["Mega"] = 423.75, ["Mega|Ride"] = 375, ["Mega|Fly|Ride"] = 375}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2, ["Fly"] = 39.58, ["Ride"] = 14.66, ["Fly|Ride"] = 43.35, ["Neon"] = 11.86, ["Neon|Ride"] = 26.52, ["Neon|Fly|Ride"] = 114.99, ["Mega"] = 222.15, ["Mega|Fly|Ride"] = 296.57}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 21.82, ["Ride"] = 55.25, ["Fly|Ride"] = 162.5, ["Neon"] = 200, ["Neon|Fly|Ride"] = 503.67, ["Mega"] = 642.34, ["Mega|Fly"] = 785.73, ["Mega|Ride"] = 537.5, ["Mega|Fly|Ride"] = 586.74}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 5}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 2.4, ["Ride"] = 29.86, ["Neon"] = 50, ["Neon|Fly|Ride"] = 328.05, ["Mega"] = 540.19, ["Mega|Ride"] = 785.73, ["Mega|Fly|Ride"] = 858.41}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 24.86, ["Fly"] = 78.4, ["Ride"] = 28.44, ["Fly|Ride"] = 46.91, ["Neon|Fly"] = 96969.69, ["Neon|Ride"] = 154.88, ["Neon|Fly|Ride"] = 437.5, ["Mega"] = 1964.31, ["Mega|Fly|Ride"] = 1964.31}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2, ["Fly"] = 25, ["Ride"] = 22.6, ["Neon"] = 2, ["Neon|Ride"] = 65.82, ["Neon|Fly|Ride"] = 101.2, ["Mega"] = 30.9, ["Mega|Fly"] = 262.24, ["Mega|Ride"] = 61.54, ["Mega|Fly|Ride"] = 261.26}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 16.63, ["Fly"] = 26.47, ["Ride"] = 23.58, ["Fly|Ride"] = 58.94, ["Neon"] = 43.57, ["Neon|Ride"] = 222.27, ["Mega|Fly"] = 370.99, ["Mega|Ride"] = 196.44}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2, ["Fly"] = 31.25, ["Ride"] = 17.61, ["Fly|Ride"] = 43.38, ["Neon"] = 8.75, ["Neon|Fly"] = 178, ["Neon|Ride"] = 33.43, ["Neon|Fly|Ride"] = 75, ["Mega"] = 196.44, ["Mega|Ride"] = 173.55, ["Mega|Fly|Ride"] = 257.5}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2, ["Ride"] = 30.88, ["Fly|Ride"] = 196.44, ["Neon"] = 2.5, ["Neon|Ride"] = 22.27, ["Neon|Fly|Ride"] = 196.44, ["Mega"] = 26.25, ["Mega|Ride"] = 105.1, ["Mega|Fly|Ride"] = 296.57}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 92.12, ["Ride"] = 68.05, ["Fly|Ride"] = 170.91, ["Neon"] = 212.5, ["Neon|Fly|Ride"] = 548.75, ["Mega"] = 812.92, ["Mega|Fly|Ride"] = 913.89}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.48, ["Ride"] = 125, ["Fly|Ride"] = 200, ["Neon"] = 87.86, ["Neon|Ride"] = 131.62, ["Mega|Ride"] = 499.99}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 3.75, ["Fly"] = 198, ["Ride"] = 17.55, ["Fly|Ride"] = 64.54, ["Neon"] = 17.15, ["Neon|Fly"] = 300, ["Neon|Ride"] = 39.6, ["Neon|Fly|Ride"] = 156.25, ["Mega"] = 181.88, ["Mega|Fly|Ride"] = 375}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 68.74, ["Fly"] = 412.49, ["Ride"] = 374.98, ["Fly|Ride"] = 249.96, ["Neon"] = 312.5, ["Neon|Ride"] = 510.73, ["Mega|Ride"] = 2062.5, ["Mega|Fly|Ride"] = 1748.75}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 10.54, ["Fly"] = 31.14, ["Ride"] = 21.1, ["Fly|Ride"] = 54.91, ["Neon"] = 42.88, ["Neon|Ride"] = 55.01, ["Neon|Fly|Ride"] = 262.24, ["Mega"] = 206.25, ["Mega|Ride"] = 392.87, ["Mega|Fly|Ride"] = 608.3}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 66.25, ["Fly"] = 145.36, ["Ride"] = 99.99, ["Neon"] = 258.11, ["Neon|Ride"] = 212.49, ["Mega"] = 1060.73, ["Mega|Ride"] = 858.83, ["Mega|Fly|Ride"] = 1003.48}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 23.71, ["Ride"] = 57.5, ["Fly|Ride"] = 131.62, ["Neon"] = 77.91, ["Neon|Ride"] = 137.5, ["Neon|Fly|Ride"] = 214.65, ["Mega"] = 562.5, ["Mega|Ride"] = 348.75, ["Mega|Fly|Ride"] = 524.47}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 4.85, ["Fly"] = 87.73, ["Ride"] = 26.52, ["Fly|Ride"] = 58.94, ["Neon"] = 131.62, ["Neon|Ride"] = 86.23, ["Neon|Fly|Ride"] = 353.22, ["Mega|Ride"] = 1473.24, ["Mega|Fly|Ride"] = 655.1}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 16.65, ["Ride"] = 62.86, ["Fly|Ride"] = 154.8, ["Neon"] = 62.5, ["Neon|Ride"] = 81.25, ["Neon|Fly|Ride"] = 417.5, ["Mega"] = 270.3, ["Mega|Ride"] = 283.27, ["Mega|Fly|Ride"] = 375}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 9.93, ["Ride"] = 18.74, ["Neon"] = 29.66, ["Neon|Ride"] = 51.74, ["Neon|Fly|Ride"] = 176.79, ["Mega"] = 233.75, ["Mega|Ride"] = 433.14, ["Mega|Fly|Ride"] = 460}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2, ["Neon"] = 2, ["Neon|Ride"] = 54.47, ["Mega"] = 25.55, ["Mega|Ride"] = 117.87, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 6.23, ["Ride"] = 27.06, ["Neon"] = 21.61, ["Neon|Ride"] = 150, ["Neon|Fly|Ride"] = 193.12, ["Mega"] = 168.9, ["Mega|Ride"] = 243.59, ["Mega|Fly|Ride"] = 390.9}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.5, ["Fly"] = 116.89, ["Neon"] = 25, ["Mega"] = 161.88, ["Mega|Fly|Ride"] = 1125}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 6.25, ["Ride"] = 31.25, ["Fly|Ride"] = 111.14, ["Neon"] = 31.25, ["Neon|Ride"] = 79, ["Mega"] = 118.75, ["Mega|Ride"] = 262.24, ["Mega|Fly|Ride"] = 3928.6}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 537.92, ["Ride"] = 538.95, ["Fly|Ride"] = 650, ["Neon|Ride"] = 1964.31, ["Neon|Fly|Ride"] = 1875, ["Mega|Fly|Ride"] = 5600}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 8.75, ["Fly"] = 26.47, ["Ride"] = 18.28, ["Fly|Ride"] = 60.02, ["Neon"] = 38.31, ["Neon|Ride"] = 92.33, ["Neon|Fly|Ride"] = 325, ["Mega"] = 148.85, ["Mega|Ride"] = 341, ["Mega|Fly|Ride"] = 445.91}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 11.42, ["Fly"] = 499.7, ["Ride"] = 31.25, ["Fly|Ride"] = 53.66, ["Neon"] = 72.5, ["Neon|Fly"] = 300, ["Neon|Ride"] = 84.47, ["Neon|Fly|Ride"] = 153.23, ["Mega"] = 316.04, ["Mega|Ride"] = 392.87, ["Mega|Fly|Ride"] = 471.45}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 7.5, ["Fly"] = 14.75, ["Ride"] = 25.59, ["Fly|Ride"] = 294.66, ["Neon"] = 12.5, ["Neon|Ride"] = 187.5, ["Neon|Fly|Ride"] = 125, ["Mega"] = 252.14}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2, ["Fly"] = 62.45, ["Ride"] = 20.58, ["Fly|Ride"] = 86.25, ["Neon"] = 7.5, ["Neon|Ride"] = 35, ["Neon|Fly|Ride"] = 166.97, ["Mega"] = 93.32, ["Mega|Fly"] = 201.69, ["Mega|Ride"] = 96.24, ["Mega|Fly|Ride"] = 200.47}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2, ["Fly"] = 65.82, ["Ride"] = 19.66, ["Neon"] = 2.5, ["Neon|Ride"] = 23.17, ["Neon|Fly|Ride"] = 112.5, ["Mega"] = 22.5, ["Mega|Ride"] = 61.3, ["Mega|Fly|Ride"] = 208.22}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1056.23}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 15, ["Ride"] = 37.49, ["Fly|Ride"] = 306.45, ["Neon"] = 55, ["Neon|Ride"] = 100, ["Mega"] = 524.47, ["Mega|Ride"] = 537.25, ["Mega|Fly|Ride"] = 809.31}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2, ["Ride"] = 26.91, ["Neon"] = 6.67, ["Neon|Ride"] = 70.73, ["Neon|Fly|Ride"] = 935.33, ["Mega"] = 37.49, ["Mega|Ride"] = 135.09, ["Mega|Fly|Ride"] = 252.14}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.03, ["Fly"] = 39.3, ["Ride"] = 18.75, ["Fly|Ride"] = 392.87, ["Neon"] = 25.55, ["Neon|Ride"] = 133.58, ["Neon|Fly|Ride"] = 250, ["Mega"] = 175, ["Mega|Ride"] = 444.3, ["Mega|Fly|Ride"] = 982.16}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 465, ["Ride"] = 473.27, ["Fly|Ride"] = 530, ["Neon|Ride"] = 2064.95, ["Neon|Fly|Ride"] = 1625, ["Mega|Fly|Ride"] = 6250}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 7.85, ["Fly"] = 187.5, ["Fly|Ride"] = 392.87, ["Neon"] = 31.25, ["Neon|Ride"] = 77.5, ["Mega"] = 458.67, ["Mega|Ride"] = 444.3, ["Mega|Fly|Ride"] = 637.56}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2, ["Fly"] = 84.29, ["Ride"] = 23.74, ["Fly|Ride"] = 112.5, ["Neon"] = 3.64, ["Neon|Ride"] = 34.07, ["Neon|Fly|Ride"] = 106.25, ["Mega"] = 40.47, ["Mega|Ride"] = 68.75, ["Mega|Fly|Ride"] = 168.75}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2, ["Neon"] = 3.75, ["Neon|Ride"] = 27.03, ["Neon|Fly|Ride"] = 392.87, ["Mega"] = 31.25, ["Mega|Ride"] = 128.36, ["Mega|Fly|Ride"] = 375}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 15.9, ["Fly"] = 102.5, ["Ride"] = 76.23, ["Fly|Ride"] = 83.12, ["Neon"] = 121.48, ["Neon|Ride"] = 123.75, ["Neon|Fly|Ride"] = 350, ["Mega|Fly|Ride"] = 567.5}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 7.56, ["Neon"] = 91.88, ["Neon|Ride"] = 148.85, ["Neon|Fly|Ride"] = 875, ["Mega"] = 375, ["Mega|Ride"] = 455, ["Mega|Fly|Ride"] = 589.3}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 6.66, ["Ride"] = 29.89, ["Fly|Ride"] = 392.87, ["Neon"] = 296.73, ["Neon|Ride"] = 167.73, ["Mega"] = 607.57, ["Mega|Fly|Ride"] = 1178.59}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 11.01, ["Ride"] = 22.04, ["Fly|Ride"] = 250, ["Neon"] = 159.4, ["Neon|Ride"] = 173.75, ["Neon|Fly|Ride"] = 196.44, ["Mega"] = 587.33, ["Mega|Ride"] = 1238.75, ["Mega|Fly|Ride"] = 655.1}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 330, ["Ride"] = 458.67, ["Neon"] = 875, ["Neon|Ride"] = 1310.2, ["Neon|Fly|Ride"] = 1250, ["Mega|Fly|Ride"] = 3928.6}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 9.81, ["Fly"] = 74.99, ["Ride"] = 19.05, ["Fly|Ride"] = 96.26, ["Neon"] = 123.65, ["Neon|Ride"] = 195.46, ["Mega"] = 785.73, ["Mega|Ride"] = 694.38, ["Mega|Fly|Ride"] = 811.26}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 7.96, ["Ride"] = 120, ["Neon"] = 50.1, ["Neon|Ride"] = 211.25, ["Mega"] = 208.22, ["Mega|Ride"] = 328.05, ["Mega|Fly|Ride"] = 982.16}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 20, ["Ride"] = 66.25, ["Neon"] = 86.61, ["Neon|Ride"] = 125, ["Neon|Fly|Ride"] = 248.36, ["Mega"] = 262.5, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 318.65}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.5, ["Ride"] = 74.65, ["Neon"] = 10, ["Neon|Ride"] = 150, ["Mega"] = 51.25, ["Mega|Ride"] = 121.93, ["Mega|Fly|Ride"] = 281.25}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 41.37, ["Ride"] = 96.26, ["Neon"] = 458.67, ["Neon|Ride"] = 212.5, ["Mega"] = 2357.17, ["Mega|Ride"] = 2600.74, ["Mega|Fly|Ride"] = 1468.38}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2, ["Fly"] = 554.05, ["Ride"] = 25, ["Neon"] = 10, ["Neon|Fly"] = 170.91, ["Neon|Ride"] = 74.72, ["Neon|Fly|Ride"] = 162.5, ["Mega"] = 100, ["Mega|Ride"] = 100.3, ["Mega|Fly|Ride"] = 373.13}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2, ["Fly"] = 85.46, ["Ride"] = 30.02, ["Fly|Ride"] = 150, ["Neon"] = 7.5, ["Neon|Ride"] = 44.91, ["Neon|Fly|Ride"] = 93.22, ["Mega"] = 37.84, ["Mega|Fly"] = 96.64, ["Mega|Ride"] = 70, ["Mega|Fly|Ride"] = 162.34}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2, ["Ride"] = 36.25, ["Fly|Ride"] = 121.44, ["Neon"] = 13.75, ["Neon|Ride"] = 56.98, ["Neon|Fly|Ride"] = 168.75, ["Mega"] = 104.41, ["Mega|Ride"] = 137.5, ["Mega|Fly|Ride"] = 296.57}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 34.83, ["Fly"] = 88.91, ["Ride"] = 57.38, ["Fly|Ride"] = 253.41, ["Neon"] = 277.5, ["Neon|Ride"] = 286.07, ["Neon|Fly|Ride"] = 444.3, ["Mega|Fly|Ride"] = 998.75}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 261.63, ["Ride"] = 289.75, ["Fly|Ride"] = 391.89, ["Neon"] = 1365.19, ["Neon|Ride"] = 1047.97, ["Neon|Fly|Ride"] = 1332.88, ["Mega|Fly|Ride"] = 4200}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 14.71, ["Neon"] = 34.39, ["Neon|Fly"] = 333.75, ["Neon|Fly|Ride"] = 100, ["Mega"] = 99.9, ["Mega|Fly|Ride"] = 375}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.5, ["Fly"] = 131.31, ["Ride"] = 31.25, ["Neon"] = 7.85, ["Neon|Ride"] = 43.75, ["Mega"] = 53.9, ["Mega|Fly"] = 200, ["Mega|Ride"] = 97.49, ["Mega|Fly|Ride"] = 230}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 4.43, ["Fly"] = 148.93, ["Ride"] = 26.25, ["Fly|Ride"] = 91.25, ["Neon"] = 31.24, ["Neon|Ride"] = 65.82, ["Mega|Ride"] = 331.64}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 3.75, ["Fly"] = 66.66, ["Ride"] = 37.33, ["Fly|Ride"] = 349.65, ["Neon"] = 10.61, ["Neon|Ride"] = 44.24, ["Neon|Fly|Ride"] = 145.36, ["Mega"] = 118.28, ["Mega|Fly|Ride"] = 250}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2, ["Ride"] = 86.44, ["Neon"] = 8.13, ["Neon|Fly|Ride"] = 179.74, ["Mega"] = 37.84, ["Mega|Fly|Ride"] = 259.3}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2, ["Fly"] = 62.41, ["Ride"] = 17.05, ["Fly|Ride"] = 49.99, ["Neon"] = 6.67, ["Neon|Fly"] = 74.47, ["Neon|Ride"] = 21.61, ["Neon|Fly|Ride"] = 392.87, ["Mega|Ride"] = 91.16, ["Mega|Fly|Ride"] = 212.5}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 3.75, ["Fly"] = 131.31, ["Ride"] = 15.13, ["Fly|Ride"] = 58.94, ["Neon"] = 28.72, ["Neon|Fly"] = 61.87, ["Neon|Ride"] = 25.3, ["Neon|Fly|Ride"] = 88.87, ["Mega"] = 148.71, ["Mega|Ride"] = 168.75, ["Mega|Fly|Ride"] = 416.15}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 26.24, ["Ride"] = 29.87, ["Fly|Ride"] = 74.98, ["Neon|Fly|Ride"] = 301.42, ["Mega"] = 593.13, ["Mega|Ride"] = 500, ["Mega|Fly|Ride"] = 522.65}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 79.87, ["Ride"] = 74.9, ["Fly|Ride"] = 118.59, ["Neon"] = 487.5, ["Neon|Fly"] = 410.13, ["Neon|Ride"] = 375, ["Neon|Fly|Ride"] = 375, ["Mega"] = 3186.8, ["Mega|Fly|Ride"] = 1846.44}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2, ["Ride"] = 17.02, ["Fly|Ride"] = 125, ["Neon"] = 3.75, ["Neon|Fly"] = 75, ["Neon|Ride"] = 26.24, ["Mega"] = 36.11, ["Mega|Fly"] = 640, ["Mega|Ride"] = 85.46}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2, ["Fly"] = 11.77, ["Ride"] = 13.5, ["Fly|Ride"] = 37.49, ["Neon"] = 3.75, ["Neon|Fly"] = 37.5, ["Neon|Ride"] = 23.75, ["Neon|Fly|Ride"] = 58.74, ["Mega"] = 58.64, ["Mega|Fly"] = 124.96, ["Mega|Ride"] = 62.5, ["Mega|Fly|Ride"] = 123.75}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 10.77, ["Ride"] = 70, ["Neon"] = 38.75, ["Neon|Ride"] = 133.3, ["Neon|Fly|Ride"] = 262.24, ["Mega|Ride"] = 458.67, ["Mega|Fly|Ride"] = 593.13}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 375, ["Fly"] = 493.75, ["Ride"] = 450, ["Fly|Ride"] = 741.25, ["Mega|Fly|Ride"] = 7405.17}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 22.87, ["Fly"] = 96.5, ["Ride"] = 80.91, ["Fly|Ride"] = 93.75, ["Neon"] = 225, ["Neon|Ride"] = 200.7, ["Neon|Fly|Ride"] = 435.42, ["Mega|Ride"] = 1178.59, ["Mega|Fly|Ride"] = 874.14}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2, ["Ride"] = 24.61, ["Fly|Ride"] = 267.89, ["Neon"] = 9, ["Neon|Ride"] = 37.5, ["Neon|Fly|Ride"] = 105.1, ["Mega"] = 73.75, ["Mega|Ride"] = 124.99, ["Mega|Fly|Ride"] = 270.11}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.5, ["Fly"] = 87.5, ["Ride"] = 62.48, ["Fly|Ride"] = 136.23, ["Neon"] = 12.48}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 52.92, ["Fly"] = 187.5, ["Ride"] = 75, ["Fly|Ride"] = 62.5, ["Neon"] = 185, ["Neon|Ride"] = 444.3, ["Neon|Fly|Ride"] = 458.67, ["Mega"] = 2357.17, ["Mega|Ride"] = 2000, ["Mega|Fly|Ride"] = 1178.59}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 97.02, ["Ride"] = 103.75, ["Fly|Ride"] = 392.87, ["Neon"] = 413.74, ["Neon|Fly|Ride"] = 581.25, ["Mega"] = 7857.2, ["Mega|Fly|Ride"] = 5892.9}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 225, ["Ride"] = 251.65, ["Fly|Ride"] = 490.1, ["Neon"] = 1000, ["Neon|Ride"] = 1300, ["Neon|Fly|Ride"] = 1276.8, ["Mega|Fly|Ride"] = 3405.12}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 12.03, ["Fly"] = 49.34, ["Ride"] = 58.74, ["Fly|Ride"] = 111.98, ["Neon"] = 73.5, ["Neon|Ride"] = 112.5, ["Mega"] = 415.57, ["Mega|Ride"] = 373.75, ["Mega|Fly|Ride"] = 487.9}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2, ["Fly"] = 16.47, ["Ride"] = 13.13, ["Fly|Ride"] = 39.91, ["Neon"] = 14.75, ["Neon|Ride"] = 22.03, ["Neon|Fly|Ride"] = 85.46, ["Mega"] = 131.62, ["Mega|Ride"] = 87.5, ["Mega|Fly|Ride"] = 162.31}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 4.44, ["Fly"] = 37.24, ["Ride"] = 15.12, ["Fly|Ride"] = 55.57, ["Neon"] = 42.24, ["Neon|Ride"] = 42.39, ["Neon|Fly|Ride"] = 115.52, ["Mega|Ride"] = 250, ["Mega|Fly|Ride"] = 348.75}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 287.5, ["Fly"] = 457.59, ["Ride"] = 320.28, ["Fly|Ride"] = 581.44, ["Neon"] = 1875, ["Neon|Ride"] = 2047.95, ["Mega"] = 9428.64, ["Mega|Fly|Ride"] = 7108.6}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2, ["Neon"] = 5.88, ["Neon|Fly|Ride"] = 112500, ["Mega"] = 33.4, ["Mega|Ride"] = 162.84}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 5.89, ["Ride"] = 14.97, ["Fly|Ride"] = 52.5, ["Neon"] = 21.34, ["Neon|Ride"] = 45, ["Neon|Fly|Ride"] = 74.99, ["Mega"] = 217.07, ["Mega|Ride"] = 170.91, ["Mega|Fly|Ride"] = 280}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 17.57, ["Ride"] = 44.46, ["Neon"] = 99.99, ["Neon|Ride"] = 224.99, ["Mega"] = 502.57, ["Mega|Ride"] = 618.75, ["Mega|Fly|Ride"] = 655.1}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 151.25, ["Fly"] = 199.9, ["Ride"] = 119.9, ["Fly|Ride"] = 158.75, ["Neon|Ride"] = 733.47, ["Neon|Fly|Ride"] = 623.75, ["Mega|Fly|Ride"] = 2265}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 18.2, ["Fly"] = 41.34, ["Ride"] = 21.68, ["Fly|Ride"] = 55.52, ["Neon"] = 99.27, ["Neon|Ride"] = 106.25, ["Neon|Fly|Ride"] = 125, ["Mega"] = 655.1, ["Mega|Ride"] = 437.5, ["Mega|Fly|Ride"] = 642.34}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2, ["Ride"] = 19.66, ["Neon"] = 2.5, ["Mega"] = 22.5, ["Mega|Fly|Ride"] = 262.24}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2, ["Ride"] = 18.75, ["Fly|Ride"] = 68.75, ["Neon"] = 2.5, ["Neon|Ride"] = 20.01, ["Neon|Fly|Ride"] = 73.89, ["Mega"] = 25.36, ["Mega|Fly"] = 92.49, ["Mega|Ride"] = 47.51, ["Mega|Fly|Ride"] = 106.45}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 9.44, ["Ride"] = 72.68, ["Fly|Ride"] = 124.93, ["Neon"] = 32.19, ["Neon|Fly"] = 137.5, ["Neon|Ride"] = 75, ["Neon|Fly|Ride"] = 173.23, ["Mega"] = 153.55, ["Mega|Ride"] = 208.5, ["Mega|Fly|Ride"] = 304.47}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1529.16, ["Ride"] = 1287.5, ["Fly|Ride"] = 1247.49, ["Neon|Ride"] = 3662.5, ["Neon|Fly|Ride"] = 3614.54, ["Mega|Fly|Ride"] = 11990}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 389.37, ["Fly"] = 875, ["Ride"] = 452.15, ["Fly|Ride"] = 608.82, ["Neon"] = 2306.1, ["Neon|Ride"] = 2449.49, ["Neon|Fly|Ride"] = 2250, ["Mega"] = 15714.39}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 292.5, ["Ride"] = 342.74, ["Fly|Ride"] = 454.99, ["Neon"] = 625, ["Neon|Ride"] = 687.5, ["Neon|Fly|Ride"] = 748.75, ["Mega|Fly|Ride"] = 2777.37}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 333.15, ["Fly"] = 524.47, ["Ride"] = 326.17, ["Fly|Ride"] = 450, ["Neon|Fly"] = 900, ["Neon|Ride"] = 4442.88, ["Neon|Fly|Ride"] = 1037.42}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.5, ["Fly"] = 61.25, ["Ride"] = 14.88, ["Fly|Ride"] = 36.85, ["Neon"] = 7.5, ["Neon|Ride"] = 36.25, ["Neon|Fly|Ride"] = 100, ["Mega"] = 56.25, ["Mega|Ride"] = 131.62, ["Mega|Fly|Ride"] = 191.25}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 562.5, ["Fly"] = 1310.2, ["Ride"] = 537.5, ["Fly|Ride"] = 741.25, ["Neon"] = 1625, ["Neon|Ride"] = 1300, ["Neon|Fly|Ride"] = 1310.2, ["Mega|Ride"] = 6285.76, ["Mega|Fly|Ride"] = 4125}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 14.71, ["Fly"] = 175, ["Ride"] = 33.4, ["Fly|Ride"] = 151.49, ["Neon"] = 24.12, ["Neon|Ride"] = 196.44, ["Mega"] = 130.9, ["Mega|Ride"] = 195, ["Mega|Fly|Ride"] = 475}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2, ["Fly"] = 37.5, ["Ride"] = 19.66, ["Fly|Ride"] = 37.5, ["Neon"] = 7.5, ["Neon|Ride"] = 26.52, ["Neon|Fly|Ride"] = 131.62, ["Mega|Ride"] = 183.74}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2, ["Fly"] = 55, ["Neon"] = 3.61, ["Neon|Ride"] = 37.5, ["Mega"] = 39.3, ["Mega|Ride"] = 187.4}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 31.11, ["Fly|Ride"] = 437.5, ["Neon"] = 260, ["Neon|Ride"] = 334.56, ["Mega"] = 1000, ["Mega|Ride"] = 465, ["Mega|Fly|Ride"] = 736.25}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.5, ["Fly"] = 39.3, ["Ride"] = 25.55, ["Fly|Ride"] = 65, ["Neon"] = 70, ["Mega|Fly|Ride"] = 392.87}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2, ["Ride"] = 52.5, ["Neon"] = 3.35, ["Neon|Ride"] = 39.3, ["Neon|Fly|Ride"] = 131.62, ["Mega"] = 23.76, ["Mega|Ride"] = 64.69, ["Mega|Fly|Ride"] = 143.75}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 5.89, ["Fly"] = 32.5, ["Ride"] = 16.41, ["Fly|Ride"] = 74.9, ["Neon"] = 17.45, ["Neon|Fly"] = 108.47, ["Neon|Ride"] = 43.75, ["Neon|Fly|Ride"] = 72.91, ["Mega"] = 105.9, ["Mega|Fly"] = 266.59, ["Mega|Ride"] = 122.5, ["Mega|Fly|Ride"] = 187.5}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 4.38, ["Fly"] = 87.5, ["Ride"] = 21.25, ["Fly|Ride"] = 50, ["Neon"] = 145.36, ["Neon|Ride"] = 131.62, ["Neon|Fly|Ride"] = 187.5, ["Mega"] = 226.25, ["Mega|Ride"] = 286.21, ["Mega|Fly|Ride"] = 1258.75}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 9.03, ["Ride"] = 16.68, ["Neon"] = 110, ["Mega"] = 482.06, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 406.25}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 6.2, ["Fly"] = 5927.7, ["Ride"] = 26.52, ["Neon"] = 178.75, ["Neon|Fly"] = 37.5, ["Neon|Ride"] = 300, ["Neon|Fly|Ride"] = 666.44, ["Mega"] = 287.5, ["Mega|Ride"] = 458.67, ["Mega|Fly|Ride"] = 625}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2, ["Fly"] = 61.2, ["Ride"] = 17.5, ["Fly|Ride"] = 43.75, ["Neon"] = 5, ["Neon|Fly"] = 78.55, ["Neon|Ride"] = 24.92, ["Mega"] = 56.98, ["Mega|Ride"] = 167.73, ["Mega|Fly|Ride"] = 294.66}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 148.54, ["Ride"] = 170, ["Fly|Ride"] = 250, ["Neon|Ride"] = 844.66, ["Neon|Fly|Ride"] = 987.49, ["Mega"] = 7857.2, ["Mega|Ride"] = 3928.6, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2, ["Fly"] = 17.48, ["Ride"] = 12.89, ["Fly|Ride"] = 27.13, ["Neon"] = 2.49, ["Neon|Ride"] = 26.52, ["Neon|Fly|Ride"] = 53.57, ["Mega"] = 42.5, ["Mega|Ride"] = 50.24, ["Mega|Fly|Ride"] = 185}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 6.18, ["Ride"] = 40.34, ["Fly|Ride"] = 175, ["Neon"] = 92.33, ["Neon|Ride"] = 175.51, ["Mega"] = 444.3, ["Mega|Fly"] = 740.86, ["Mega|Fly|Ride"] = 982.16}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 32.48, ["Ride"] = 262.24, ["Fly|Ride"] = 162.5, ["Neon"] = 180.55, ["Neon|Ride"] = 257.34, ["Mega"] = 917.34, ["Mega|Ride"] = 976.33, ["Mega|Fly|Ride"] = 1105.18}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 163.75, ["Ride"] = 241.38, ["Fly|Ride"] = 294.56, ["Neon"] = 832.5, ["Neon|Fly|Ride"] = 1047.97, ["Mega|Fly|Ride"] = 3465.45}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 17.94, ["Fly|Ride"] = 131.62, ["Neon"] = 148.93, ["Mega|Ride"] = 387.5, ["Mega|Fly|Ride"] = 655.1}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 29.93, ["Fly|Ride"] = 170.91, ["Neon"] = 392.87, ["Neon|Ride"] = 189.52, ["Mega|Ride"] = 785.73, ["Mega|Fly|Ride"] = 917.34}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 1437.42, ["Ride"] = 993.75, ["Fly|Ride"] = 1191.46, ["Neon|Ride"] = 4562.5, ["Neon|Fly|Ride"] = 4580.75, ["Mega|Fly|Ride"] = 18586.78}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 32.5, ["Fly"] = 18.74, ["Ride"] = 18.86, ["Fly|Ride"] = 86.69, ["Neon"] = 47.5, ["Neon|Fly"] = 92.22, ["Neon|Ride"] = 87.5, ["Neon|Fly|Ride"] = 196.44, ["Mega|Fly|Ride"] = 392.87}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 5, ["Fly"] = 48.75, ["Ride"] = 33.75, ["Fly|Ride"] = 128.75, ["Neon"] = 32.91, ["Neon|Ride"] = 57.77, ["Mega"] = 190.55, ["Mega|Fly"] = 1200, ["Mega|Ride"] = 236.53}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2, ["Fly"] = 86.25, ["Ride"] = 24.13, ["Fly|Ride"] = 85.46, ["Neon"] = 10.69, ["Neon|Ride"] = 44.91, ["Mega"] = 105.1, ["Mega|Ride"] = 229.16, ["Mega|Fly|Ride"] = 875}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 14.95, ["Ride"] = 28.75, ["Fly|Ride"] = 78.8, ["Neon"] = 68.75, ["Neon|Ride"] = 87.5, ["Neon|Fly|Ride"] = 186.92, ["Mega"] = 416.25, ["Mega|Ride"] = 411.25, ["Mega|Fly|Ride"] = 425}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 7.81, ["Fly"] = 31.25, ["Ride"] = 19.56, ["Fly|Ride"] = 48.66, ["Neon"] = 21.13, ["Neon|Ride"] = 33.4, ["Neon|Fly|Ride"] = 103.75, ["Mega|Fly"] = 235.73, ["Mega|Ride"] = 162.5, ["Mega|Fly|Ride"] = 276.97}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2, ["Ride"] = 98.23, ["Neon"] = 40.01, ["Neon|Fly"] = 12500, ["Neon|Ride"] = 50.1, ["Neon|Fly|Ride"] = 187.5, ["Mega"] = 168.94, ["Mega|Ride"] = 187.5, ["Mega|Fly|Ride"] = 328.05}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 443.24, ["Ride"] = 220, ["Fly|Ride"] = 1964.31, ["Neon|Fly|Ride"] = 1310.2}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 5.89, ["Fly"] = 31.25, ["Ride"] = 21.61, ["Fly|Ride"] = 102.16, ["Neon"] = 9.69, ["Neon|Ride"] = 30.6, ["Neon|Fly|Ride"] = 141.08, ["Mega"] = 131.62, ["Mega|Fly"] = 392.87, ["Mega|Ride"] = 117, ["Mega|Fly|Ride"] = 262.24}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 8.24, ["Fly|Ride"] = 84.63, ["Neon"] = 131.62, ["Neon|Ride"] = 179.3, ["Mega|Ride"] = 226.25}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 2, ["Fly"] = 92.33, ["Ride"] = 25, ["Neon"] = 19.36, ["Neon|Ride"] = 48.74, ["Mega"] = 95, ["Mega|Ride"] = 135, ["Mega|Fly|Ride"] = 460.96}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 125, ["Fly|Ride"] = 785.73, ["Mega|Ride"] = 4714.33, ["Mega|Fly|Ride"] = 4125}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["Ride"] = 130.63, ["Fly|Ride"] = 491.09, ["Neon"] = 142.38, ["Neon|Fly|Ride"] = 375, ["Mega"] = 2946.45, ["Mega|Ride"] = 821.94, ["Mega|Fly|Ride"] = 851.53}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 19.71, ["Fly"] = 71.13, ["Ride"] = 40.47, ["Fly|Ride"] = 86.25, ["Neon"] = 93.01, ["Neon|Ride"] = 157.15, ["Neon|Fly|Ride"] = 250, ["Mega"] = 460.96, ["Mega|Ride"] = 401.25, ["Mega|Fly|Ride"] = 514.61}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2, ["Neon"] = 4.03, ["Neon|Fly"] = 250, ["Neon|Ride"] = 200, ["Mega"] = 50}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 54.42, ["Fly"] = 131.62, ["Ride"] = 73.74, ["Fly|Ride"] = 173.52, ["Neon"] = 249.98, ["Neon|Fly"] = 328.05, ["Neon|Ride"] = 339.83, ["Neon|Fly|Ride"] = 284.6, ["Mega|Fly|Ride"] = 1113.77}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2, ["Ride"] = 18.54, ["Fly|Ride"] = 30.62, ["Neon"] = 6.25, ["Neon|Ride"] = 53.04, ["Neon|Fly|Ride"] = 116.89, ["Mega"] = 56.09}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 17.5, ["Fly"] = 131.31, ["Ride"] = 27.24, ["Fly|Ride"] = 92.33, ["Neon"] = 85.46, ["Neon|Ride"] = 119.19, ["Neon|Fly|Ride"] = 235.73, ["Mega"] = 262.24, ["Mega|Fly"] = 925, ["Mega|Ride"] = 392.87, ["Mega|Fly|Ride"] = 398.75}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 46.56, ["Fly"] = 105.1, ["Ride"] = 77.64, ["Neon"] = 175, ["Neon|Ride"] = 296.73, ["Neon|Fly|Ride"] = 392.87, ["Mega|Ride"] = 1834.67, ["Mega|Fly|Ride"] = 1168.2}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2, ["Fly"] = 28.9, ["Ride"] = 13.2, ["Fly|Ride"] = 33.75, ["Neon"] = 2.5, ["Neon|Fly"] = 22.6, ["Neon|Ride"] = 16.72, ["Neon|Fly|Ride"] = 31.15, ["Mega"] = 37.33, ["Mega|Ride"] = 29.58, ["Mega|Fly|Ride"] = 82.5}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 2.33, ["Ride"] = 49.99, ["Fly|Ride"] = 123.76, ["Neon"] = 16.17, ["Neon|Ride"] = 58.94, ["Neon|Fly|Ride"] = 392.87, ["Mega"] = 217.07, ["Mega|Ride"] = 261.88, ["Mega|Fly|Ride"] = 400}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 16.81, ["Ride"] = 56.25, ["Neon"] = 106.25, ["Neon|Ride"] = 524.47, ["Mega"] = 511.25, ["Mega|Ride"] = 437.49, ["Mega|Fly|Ride"] = 750}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2, ["Ride"] = 25.55, ["Neon"] = 2, ["Neon|Ride"] = 27.48, ["Neon|Fly|Ride"] = 91.23, ["Mega"] = 18.57, ["Mega|Ride"] = 62.41}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 17.5, ["Fly"] = 200, ["Ride"] = 66.25, ["Fly|Ride"] = 156.25, ["Neon"] = 70.91, ["Neon|Ride"] = 115.2, ["Neon|Fly|Ride"] = 391.89, ["Mega"] = 511.09, ["Mega|Fly"] = 750, ["Mega|Ride"] = 400, ["Mega|Fly|Ride"] = 703.26}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 103.87, ["Fly"] = 98.75, ["Ride"] = 27.5, ["Fly|Ride"] = 93.75, ["Neon"] = 410, ["Neon|Ride"] = 118.75, ["Neon|Fly|Ride"] = 123.75, ["Mega|Fly|Ride"] = 625}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 15, ["Ride"] = 17.25, ["Neon"] = 29.8, ["Neon|Fly"] = 666.25, ["Neon|Ride"] = 73.75, ["Neon|Fly|Ride"] = 123.99, ["Mega"] = 222.49, ["Mega|Ride"] = 228.75, ["Mega|Fly|Ride"] = 384.04}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 11.25, ["Fly"] = 1964.31, ["Ride"] = 79.99, ["Neon"] = 195.6, ["Neon|Ride"] = 187.5, ["Neon|Fly|Ride"] = 5923.47, ["Mega|Ride"] = 421.25}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2, ["Ride"] = 15.48, ["Fly|Ride"] = 187.5, ["Neon"] = 6.25, ["Neon|Ride"] = 30.88, ["Mega"] = 66.13, ["Mega|Fly"] = 250, ["Mega|Ride"] = 145.36, ["Mega|Fly|Ride"] = 262.24}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2, ["Ride"] = 52.88, ["Neon"] = 3.72, ["Mega"] = 26.25, ["Mega|Ride"] = 131.62, ["Mega|Fly|Ride"] = 248.72}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 22.01}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 34.47, ["Fly"] = 75, ["Ride"] = 37.5, ["Neon"] = 223.94, ["Neon|Fly|Ride"] = 298.75, ["Mega"] = 1571.45, ["Mega|Ride"] = 750, ["Mega|Fly|Ride"] = 847.5}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2, ["Neon"] = 3.5, ["Neon|Ride"] = 104.11, ["Mega"] = 20.46, ["Mega|Ride"] = 113.9, ["Mega|Fly|Ride"] = 285}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 425, ["Fly"] = 475, ["Ride"] = 593.45, ["Fly|Ride"] = 611.25, ["Neon"] = 2619.41, ["Mega"] = 15714.39, ["Mega|Fly|Ride"] = 10000}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 2.66, ["Fly"] = 24.99, ["Ride"] = 23.52, ["Neon"] = 29.5, ["Neon|Fly|Ride"] = 123.75, ["Mega"] = 91.28, ["Mega|Ride"] = 125, ["Mega|Fly|Ride"] = 524.47}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 3.75, ["Fly"] = 50, ["Ride"] = 19.99, ["Fly|Ride"] = 66.02, ["Neon"] = 23.76, ["Neon|Ride"] = 37.49, ["Neon|Fly|Ride"] = 95, ["Mega"] = 142.18, ["Mega|Ride"] = 170.91, ["Mega|Fly|Ride"] = 223.51}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 172.87, ["Fly"] = 65.66, ["Ride"] = 48.03, ["Fly|Ride"] = 101.25, ["Neon"] = 97.88, ["Neon|Ride"] = 160.1, ["Mega"] = 785.73, ["Mega|Ride"] = 837.5}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 6.25, ["Ride"] = 26.52, ["Fly|Ride"] = 687.5, ["Neon"] = 28.49, ["Neon|Ride"] = 112.5, ["Mega"] = 250}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 14.71, ["Fly"] = 131.62, ["Ride"] = 40, ["Fly|Ride"] = 164.99, ["Neon"] = 131.62, ["Neon|Ride"] = 168.94, ["Neon|Fly|Ride"] = 342.18, ["Mega|Ride"] = 385.63, ["Mega|Fly|Ride"] = 760.19}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 5.92, ["Ride"] = 50.46, ["Fly|Ride"] = 127.5, ["Neon"] = 37.33, ["Neon|Ride"] = 72.68, ["Neon|Fly|Ride"] = 195, ["Mega"] = 306.45, ["Mega|Fly"] = 524.47, ["Mega|Ride"] = 392.87, ["Mega|Fly|Ride"] = 342.39}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2, ["Fly"] = 44.46, ["Ride"] = 11.25, ["Fly|Ride"] = 65.82, ["Neon"] = 2, ["Neon|Fly"] = 56, ["Neon|Ride"] = 14.74, ["Neon|Fly|Ride"] = 131.62, ["Mega"] = 15.63, ["Mega|Ride"] = 30.46, ["Mega|Fly|Ride"] = 133.13}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 6.14, ["Fly"] = 49.98, ["Ride"] = 37.5, ["Fly|Ride"] = 98.23, ["Neon"] = 38.63, ["Neon|Ride"] = 83.75, ["Neon|Fly|Ride"] = 210.19, ["Mega"] = 187.47, ["Mega|Ride"] = 207.5, ["Mega|Fly|Ride"] = 446.88}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 297.09, ["Ride"] = 284.62, ["Fly|Ride"] = 412.5, ["Neon"] = 1250, ["Neon|Ride"] = 1337.5, ["Neon|Fly|Ride"] = 1192.49, ["Mega|Ride"] = 8619.19, ["Mega|Fly|Ride"] = 4844.75}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 110.4, ["Ride"] = 131.62, ["Fly|Ride"] = 7202.1, ["Neon"] = 510.92, ["Neon|Ride"] = 500, ["Neon|Fly|Ride"] = 547.05, ["Mega"] = 2095.91, ["Mega|Ride"] = 1437.5, ["Mega|Fly|Ride"] = 1623.75}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2, ["Fly"] = 11.79, ["Ride"] = 14.59, ["Fly|Ride"] = 39.3, ["Neon"] = 129.66, ["Neon|Fly"] = 65.82, ["Neon|Ride"] = 30, ["Neon|Fly|Ride"] = 73.32, ["Mega|Fly"] = 195.46, ["Mega|Ride"] = 148.85, ["Mega|Fly|Ride"] = 246.88}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2, ["Fly"] = 29.93, ["Ride"] = 12.37, ["Fly|Ride"] = 31.13, ["Neon"] = 10.81, ["Neon|Fly"] = 39.3, ["Neon|Ride"] = 22.01, ["Neon|Fly|Ride"] = 52.41, ["Mega"] = 92.33, ["Mega|Ride"] = 111.25, ["Mega|Fly|Ride"] = 230}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 3.16, ["Ride"] = 21.25, ["Fly|Ride"] = 93.75, ["Neon"] = 43.66, ["Mega"] = 196.44, ["Mega|Ride"] = 392.87}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 245, ["Fly"] = 400, ["Ride"] = 306.45, ["Fly|Ride"] = 350, ["Neon|Ride"] = 997.87, ["Neon|Fly|Ride"] = 1453.59, ["Mega|Ride"] = 7857.2, ["Mega|Fly|Ride"] = 3500}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 3.93, ["Fly"] = 18.89, ["Ride"] = 13.32, ["Fly|Ride"] = 33.87, ["Neon"] = 16.25, ["Neon|Fly"] = 100, ["Neon|Ride"] = 38.5, ["Neon|Fly|Ride"] = 133.3, ["Mega"] = 243.75, ["Mega|Ride"] = 312.5, ["Mega|Fly|Ride"] = 343.76}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 5.96, ["Ride"] = 93.75, ["Fly|Ride"] = 196.44, ["Neon"] = 53.9, ["Neon|Ride"] = 212.5, ["Neon|Fly|Ride"] = 262.24, ["Mega"] = 285, ["Mega|Ride"] = 274.9, ["Mega|Fly|Ride"] = 420.36}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2, ["Ride"] = 26.52, ["Neon"] = 6.25, ["Neon|Ride"] = 148.75, ["Mega"] = 78.3, ["Mega|Ride"] = 196.44}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 14.03, ["Fly"] = 56, ["Ride"] = 18.61, ["Fly|Ride"] = 71.24, ["Neon"] = 76.91, ["Neon|Ride"] = 100, ["Neon|Fly|Ride"] = 237.5, ["Mega"] = 560.81, ["Mega|Ride"] = 417.5}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 43.26, ["Ride"] = 102.5, ["Fly|Ride"] = 282.68, ["Neon"] = 145.36, ["Neon|Fly"] = 375, ["Neon|Ride"] = 125, ["Neon|Fly|Ride"] = 336.25, ["Mega"] = 443.59, ["Mega|Fly"] = 2062.52, ["Mega|Ride"] = 495.62, ["Mega|Fly|Ride"] = 557.56}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 19.99, ["Ride"] = 53.04, ["Fly|Ride"] = 87.5, ["Neon"] = 148.93, ["Neon|Fly"] = 276.25, ["Neon|Ride"] = 200.37, ["Neon|Fly|Ride"] = 294.66, ["Mega|Ride"] = 888.59, ["Mega|Fly|Ride"] = 825}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2, ["Fly"] = 19.61, ["Ride"] = 14.19, ["Fly|Ride"] = 25, ["Neon"] = 2, ["Neon|Fly"] = 22.69, ["Neon|Ride"] = 14.59, ["Neon|Fly|Ride"] = 57.95, ["Mega"] = 16.43, ["Mega|Fly"] = 392.87, ["Mega|Ride"] = 45.19, ["Mega|Fly|Ride"] = 93.75}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 225, ["Ride"] = 267.5, ["Fly|Ride"] = 441, ["Neon"] = 1811.88, ["Neon|Fly|Ride"] = 1370, ["Mega|Fly|Ride"] = 3875}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 12.29, ["Fly"] = 96.37, ["Ride"] = 40.35, ["Fly|Ride"] = 100, ["Neon"] = 190.04, ["Neon|Ride"] = 177.73, ["Neon|Fly|Ride"] = 312.49}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2, ["Fly"] = 29.21, ["Ride"] = 16.25, ["Fly|Ride"] = 56.25, ["Neon"] = 5.63, ["Neon|Ride"] = 26.04, ["Neon|Fly|Ride"] = 104.11, ["Mega"] = 56.25, ["Mega|Fly"] = 262.24, ["Mega|Ride"] = 137.5, ["Mega|Fly|Ride"] = 201.69}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2, ["Fly"] = 29.48, ["Ride"] = 14.8, ["Fly|Ride"] = 41.21, ["Neon"] = 2.5, ["Neon|Fly"] = 62.5, ["Neon|Ride"] = 26.52, ["Neon|Fly|Ride"] = 110.52, ["Mega"] = 23.8, ["Mega|Fly"] = 131.62, ["Mega|Ride"] = 60, ["Mega|Fly|Ride"] = 173.13}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 3.5, ["Ride"] = 27.37, ["Fly|Ride"] = 65.99, ["Neon"] = 8.04, ["Neon|Fly"] = 666.79, ["Neon|Ride"] = 60, ["Mega"] = 122.29, ["Mega|Fly|Ride"] = 355.44}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 8.92, ["Fly"] = 62.5, ["Ride"] = 25.52, ["Fly|Ride"] = 56.24, ["Neon"] = 53.04, ["Neon|Fly"] = 249.47, ["Neon|Ride"] = 43.75, ["Neon|Fly|Ride"] = 88.75, ["Mega"] = 442.08, ["Mega|Ride"] = 312.5, ["Mega|Fly|Ride"] = 385}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 8.75, ["Ride"] = 17.5, ["Neon"] = 65.82, ["Mega"] = 262.5, ["Mega|Ride"] = 392.87, ["Mega|Fly|Ride"] = 441}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2, ["Ride"] = 41.24, ["Neon"] = 2, ["Neon|Ride"] = 29.9, ["Neon|Fly|Ride"] = 95.85, ["Mega"] = 30, ["Mega|Ride"] = 67.91, ["Mega|Fly|Ride"] = 166.27}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 8.58, ["Ride"] = 23.95, ["Fly|Ride"] = 125, ["Neon"] = 27.5, ["Neon|Fly"] = 98.01, ["Neon|Ride"] = 75, ["Neon|Fly|Ride"] = 100.19, ["Mega"] = 200, ["Mega|Ride"] = 191.25, ["Mega|Fly|Ride"] = 370.99}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2, ["Ride"] = 200, ["Neon"] = 5.9, ["Neon|Ride"] = 125, ["Neon|Fly|Ride"] = 148.85, ["Mega"] = 29.48, ["Mega|Ride"] = 96.26, ["Mega|Fly|Ride"] = 131.62}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2, ["Fly"] = 39.48, ["Ride"] = 15.89, ["Fly|Ride"] = 37.5, ["Neon"] = 6.25, ["Neon|Ride"] = 19.88, ["Neon|Fly|Ride"] = 118.86, ["Mega"] = 49.91, ["Mega|Fly"] = 131.62, ["Mega|Ride"] = 80.34, ["Mega|Fly|Ride"] = 203.33}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 687.5, ["Ride"] = 781.25, ["Fly|Ride"] = 870, ["Neon|Ride"] = 3406.58, ["Neon|Fly|Ride"] = 3228.33}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2, ["Fly"] = 18.3, ["Ride"] = 12.89, ["Fly|Ride"] = 38.75, ["Neon"] = 17.48, ["Neon|Fly"] = 131.62, ["Neon|Ride"] = 34.08, ["Neon|Fly|Ride"] = 68.76, ["Mega|Fly|Ride"] = 328.05}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2, ["Ride"] = 42.5, ["Neon"] = 13.33, ["Neon|Fly"] = 687.51, ["Neon|Ride"] = 115.9, ["Neon|Fly|Ride"] = 375, ["Mega"] = 52.47, ["Mega|Ride"] = 127.64, ["Mega|Fly|Ride"] = 392.87}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 10.92, ["Fly"] = 44.46, ["Ride"] = 22.76, ["Fly|Ride"] = 51.34, ["Neon"] = 62.5, ["Neon|Fly"] = 180.36, ["Neon|Ride"] = 55.43, ["Neon|Fly|Ride"] = 124.75, ["Mega|Ride"] = 293.75, ["Mega|Fly|Ride"] = 441}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2, ["Fly"] = 19.15, ["Ride"] = 14.75, ["Fly|Ride"] = 42.24, ["Neon"] = 8.61, ["Neon|Fly"] = 120.35, ["Neon|Ride"] = 22.49, ["Neon|Fly|Ride"] = 65.94, ["Mega"] = 61.91, ["Mega|Fly"] = 125, ["Mega|Ride"] = 100.3, ["Mega|Fly|Ride"] = 150}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 34.14, ["Ride"] = 68.75, ["Fly|Ride"] = 262.24, ["Neon"] = 314.3, ["Neon|Ride"] = 251.04}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2, ["Ride"] = 22.88, ["Fly|Ride"] = 61, ["Neon"] = 7.5, ["Neon|Fly"] = 135, ["Neon|Ride"] = 28.97, ["Neon|Fly|Ride"] = 135.54, ["Mega"] = 58.94, ["Mega|Ride"] = 111, ["Mega|Fly|Ride"] = 262.24}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 3.61, ["Fly"] = 118.57, ["Ride"] = 18.91, ["Fly|Ride"] = 51.09, ["Neon"] = 8.5, ["Neon|Ride"] = 39.89, ["Neon|Fly|Ride"] = 105.1, ["Mega"] = 108.75, ["Mega|Ride"] = 189.13, ["Mega|Fly|Ride"] = 451.79}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2, ["Fly"] = 25, ["Neon"] = 34.28, ["Mega|Ride"] = 137.5, ["Mega|Fly|Ride"] = 357.5}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2, ["Fly"] = 40, ["Ride"] = 14.97, ["Neon"] = 6.63, ["Neon|Ride"] = 25, ["Neon|Fly|Ride"] = 94.68, ["Mega"] = 42.95, ["Mega|Fly"] = 275.02, ["Mega|Ride"] = 60.8, ["Mega|Fly|Ride"] = 157.15}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 37.24, ["Fly"] = 16.48, ["Ride"] = 18.86, ["Fly|Ride"] = 40.47, ["Neon"] = 296.73, ["Neon|Ride"] = 125, ["Neon|Fly|Ride"] = 93.74, ["Mega|Ride"] = 387.96}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 806.25, ["Ride"] = 875, ["Fly|Ride"] = 883.79, ["Neon"] = 1647.55, ["Neon|Ride"] = 1873.75, ["Neon|Fly|Ride"] = 2060, ["Mega"] = 7857.2, ["Mega|Fly|Ride"] = 7108.6}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2, ["Fly"] = 17.5, ["Ride"] = 14.62, ["Fly|Ride"] = 36.25, ["Neon"] = 6.25, ["Neon|Ride"] = 21.61, ["Neon|Fly|Ride"] = 49.41, ["Mega"] = 53.04, ["Mega|Ride"] = 54.91, ["Mega|Fly|Ride"] = 129.93}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 5.99, ["Ride"] = 34.97, ["Fly|Ride"] = 192.3, ["Neon"] = 37.5, ["Neon|Ride"] = 120.13, ["Neon|Fly|Ride"] = 200, ["Mega|Ride"] = 250, ["Mega|Fly|Ride"] = 458.67}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 43.55, ["Ride"] = 76.09, ["Fly|Ride"] = 105, ["Neon|Ride"] = 444.3, ["Neon|Fly|Ride"] = 475, ["Mega|Fly|Ride"] = 2612.53}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 34.74, ["Ride"] = 30, ["Fly|Ride"] = 99.89, ["Neon|Ride"] = 196.44, ["Neon|Fly|Ride"] = 655.1, ["Mega"] = 1834.67, ["Mega|Ride"] = 853.75, ["Mega|Fly|Ride"] = 963.5}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 6.36, ["Ride"] = 24.98, ["Fly|Ride"] = 133.05, ["Neon"] = 56.25, ["Neon|Ride"] = 86.25, ["Neon|Fly|Ride"] = 262.24, ["Mega"] = 392.87, ["Mega|Fly|Ride"] = 524.47}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["Ride"] = 53.04, ["Neon"] = 262.24, ["Neon|Ride"] = 341.18, ["Mega"] = 321.88, ["Mega|Fly"] = 482.06, ["Mega|Ride"] = 367.34, ["Mega|Fly|Ride"] = 790.63}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 63.75, ["Fly"] = 120.84, ["Neon"] = 400, ["Neon|Ride"] = 312.5, ["Neon|Fly|Ride"] = 500, ["Mega"] = 880, ["Mega|Fly|Ride"] = 642.34}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 17.39}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 5.31, ["Fly"] = 124998.75, ["Ride"] = 15.82, ["Fly|Ride"] = 81.25, ["Neon"] = 31.25, ["Neon|Ride"] = 98.23, ["Neon|Fly|Ride"] = 170.91, ["Mega"] = 181.22, ["Mega|Fly"] = 443.94, ["Mega|Ride"] = 204.3, ["Mega|Fly|Ride"] = 444.3}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 3.73, ["Ride"] = 44.61, ["Neon"] = 11.25, ["Mega"] = 131.62}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 65.66, ["Fly"] = 392.87, ["Ride"] = 53.04, ["Fly|Ride"] = 89.74, ["Neon"] = 296.73, ["Neon|Ride"] = 180, ["Neon|Fly|Ride"] = 888.59, ["Mega|Ride"] = 1571.45, ["Mega|Fly|Ride"] = 1021.45}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 10, ["Fly"] = 16.72, ["Ride"] = 14.51, ["Fly|Ride"] = 35.41, ["Neon"] = 24.21, ["Neon|Fly"] = 89.38, ["Neon|Ride"] = 29.75, ["Neon|Fly|Ride"] = 70, ["Mega"] = 123.75, ["Mega|Ride"] = 186.25, ["Mega|Fly|Ride"] = 239.27}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 6.22, ["Fly"] = 139.14, ["Ride"] = 26.11, ["Fly|Ride"] = 53.04, ["Neon"] = 19.66, ["Neon|Ride"] = 56.98, ["Neon|Fly|Ride"] = 122.5, ["Mega"] = 125, ["Mega|Ride"] = 161.19, ["Mega|Fly|Ride"] = 249.97}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2, ["Neon"] = 6.25, ["Mega"] = 42.24, ["Mega|Ride"] = 186.5}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 31.98, ["Fly"] = 73.49, ["Ride"] = 62.5, ["Fly|Ride"] = 115, ["Neon"] = 200, ["Neon|Ride"] = 237.5, ["Neon|Fly|Ride"] = 294.66, ["Mega|Ride"] = 13095.97}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2, ["Ride"] = 37.48, ["Fly|Ride"] = 62.5, ["Neon"] = 5.63, ["Neon|Ride"] = 63.36, ["Mega"] = 71.14, ["Mega|Ride"] = 112.49, ["Mega|Fly|Ride"] = 440.19}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 10.98, ["Fly"] = 50, ["Ride"] = 74.47, ["Fly|Ride"] = 261.26, ["Neon"] = 100.03, ["Neon|Ride"] = 125, ["Neon|Fly|Ride"] = 375, ["Mega"] = 625, ["Mega|Fly|Ride"] = 524.47}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.5, ["Fly"] = 18.67, ["Ride"] = 14.23, ["Fly|Ride"] = 38.69, ["Neon"] = 86.23, ["Neon|Ride"] = 34.09, ["Neon|Fly|Ride"] = 72.25, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 237.71}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 4.9, ["Fly"] = 49.99, ["Ride"] = 18.38, ["Fly|Ride"] = 67.96, ["Neon"] = 25, ["Neon|Ride"] = 43.75, ["Mega|Ride"] = 392.87, ["Mega|Fly|Ride"] = 392.87}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 3.74, ["Ride"] = 78.58, ["Neon"] = 100.19, ["Neon|Ride"] = 150.04, ["Mega"] = 446.88, ["Mega|Ride"] = 888.59}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 40, ["Ride"] = 98.23, ["Neon"] = 222.5, ["Neon|Fly|Ride"] = 544.12, ["Mega|Fly|Ride"] = 1750}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 15.05, ["Ride"] = 262.24, ["Neon"] = 94.3, ["Neon|Ride"] = 250, ["Mega"] = 431.34, ["Mega|Fly|Ride"] = 437.5}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 5, ["Ride"] = 137.5, ["Neon"] = 155, ["Mega|Ride"] = 784.74}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 16.44, ["Ride"] = 221.25, ["Fly|Ride"] = 349.96, ["Neon"] = 138.6, ["Neon|Ride"] = 687.51, ["Neon|Fly|Ride"] = 312.5, ["Mega"] = 587.5, ["Mega|Fly"] = 1964.31, ["Mega|Fly|Ride"] = 1037.42}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 2.46, ["Neon"] = 19.66, ["Mega"] = 125}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2, ["Fly"] = 122.5, ["Ride"] = 13.24, ["Fly|Ride"] = 60, ["Neon"] = 3.75, ["Neon|Fly"] = 40.97, ["Neon|Ride"] = 37.5, ["Neon|Fly|Ride"] = 121.8, ["Mega"] = 78.58, ["Mega|Ride"] = 117.87, ["Mega|Fly|Ride"] = 287.5}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 3.75, ["Ride"] = 262.24, ["Fly|Ride"] = 62.5, ["Neon"] = 37.5, ["Neon|Ride"] = 39.3, ["Neon|Fly|Ride"] = 156.25, ["Mega"] = 101.09, ["Mega|Ride"] = 148.85, ["Mega|Fly|Ride"] = 225.9}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2, ["Fly"] = 19.66, ["Ride"] = 14.72, ["Fly|Ride"] = 53.57, ["Neon"] = 8.75, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 74.43, ["Mega"] = 52.49, ["Mega|Fly"] = 157.15, ["Mega|Ride"] = 72.91, ["Mega|Fly|Ride"] = 262.24}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 3.3, ["Fly"] = 62.5, ["Ride"] = 25, ["Fly|Ride"] = 112.5, ["Neon"] = 23.58, ["Neon|Ride"] = 93.75, ["Neon|Fly|Ride"] = 244.56, ["Mega"] = 312.5, ["Mega|Ride"] = 310.37, ["Mega|Fly|Ride"] = 444.3}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.75, ["Fly"] = 62.5, ["Ride"] = 18.75, ["Fly|Ride"] = 98.75, ["Neon"] = 30.46, ["Neon|Fly"] = 444.53, ["Neon|Ride"] = 75, ["Neon|Fly|Ride"] = 187.5, ["Mega|Fly|Ride"] = 1178.59}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 12.19, ["Fly"] = 125, ["Ride"] = 23.47, ["Fly|Ride"] = 72.68, ["Neon"] = 25, ["Neon|Fly"] = 106.23, ["Neon|Ride"] = 41.35, ["Neon|Fly|Ride"] = 112.5, ["Mega"] = 217.11, ["Mega|Ride"] = 296.57, ["Mega|Fly|Ride"] = 377.5}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 3.75, ["Fly"] = 34.16, ["Ride"] = 18.27, ["Fly|Ride"] = 49.31, ["Neon"] = 25.55, ["Neon|Fly"] = 78.58, ["Neon|Ride"] = 73.67, ["Neon|Fly|Ride"] = 187.5, ["Mega|Ride"] = 437.5, ["Mega|Fly|Ride"] = 242.04}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 4.44, ["Fly"] = 54.91, ["Ride"] = 41.22, ["Fly|Ride"] = 125, ["Neon"] = 16.77, ["Neon|Ride"] = 90, ["Neon|Fly|Ride"] = 122.32, ["Mega"] = 93.49, ["Mega|Fly"] = 148.85, ["Mega|Ride"] = 183.67, ["Mega|Fly|Ride"] = 284.84}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 23.67, ["Fly"] = 195.98, ["Ride"] = 100, ["Fly|Ride"] = 446.25, ["Neon"] = 105.1, ["Neon|Fly"] = 412.5, ["Neon|Ride"] = 298.75, ["Neon|Fly|Ride"] = 494.27, ["Mega"] = 475, ["Mega|Ride"] = 606.97, ["Mega|Fly|Ride"] = 637.5}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 56.25, ["Fly"] = 156.25, ["Ride"] = 86.22, ["Fly|Ride"] = 457.87, ["Neon"] = 256.24, ["Neon|Ride"] = 312.5, ["Neon|Fly|Ride"] = 457.62, ["Mega"] = 1439.84, ["Mega|Ride"] = 1011.25, ["Mega|Fly|Ride"] = 1163.75}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2, ["Fly"] = 48.53, ["Ride"] = 18.58, ["Fly|Ride"] = 61.89, ["Neon"] = 2.5, ["Neon|Ride"] = 31.25, ["Mega"] = 37.5, ["Mega|Ride"] = 67.75, ["Mega|Fly|Ride"] = 141.25}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 61.16, ["Mega|Fly|Ride"] = 917.34}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 47.9, ["Ride"] = 87.51, ["Neon"] = 391.89, ["Neon|Ride"] = 325, ["Neon|Fly|Ride"] = 784.74, ["Mega"] = 1609.75}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 9.67, ["Fly"] = 181.25, ["Ride"] = 51.09, ["Fly|Ride"] = 127.5, ["Neon"] = 38.75, ["Neon|Ride"] = 78.58, ["Mega"] = 137.5, ["Mega|Ride"] = 237.5, ["Mega|Fly|Ride"] = 367.34}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 4.44, ["Ride"] = 58.9, ["Fly|Ride"] = 135, ["Neon"] = 10, ["Neon|Ride"] = 62.5, ["Mega"] = 61.58, ["Mega|Fly"] = 325, ["Mega|Ride"] = 66.25, ["Mega|Fly|Ride"] = 334.43}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.5, ["Fly"] = 26.23, ["Ride"] = 21.61, ["Fly|Ride"] = 35.99, ["Neon"] = 11.02, ["Neon|Ride"] = 38.46, ["Neon|Fly|Ride"] = 87.5, ["Mega"] = 258.32, ["Mega|Fly"] = 328.05, ["Mega|Ride"] = 195.46}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2, ["Fly"] = 17.5, ["Ride"] = 13.66, ["Fly|Ride"] = 39.3, ["Neon"] = 2.5, ["Neon|Ride"] = 23.75, ["Neon|Fly|Ride"] = 35, ["Mega"] = 20, ["Mega|Ride"] = 78.58}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2, ["Ride"] = 14.75, ["Fly|Ride"] = 31.15, ["Neon"] = 3.75, ["Neon|Ride"] = 33.4, ["Neon|Fly|Ride"] = 118.75, ["Mega"] = 72.68, ["Mega|Ride"] = 53.75, ["Mega|Fly|Ride"] = 262.24}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2, ["Ride"] = 49.98, ["Neon"] = 2.49, ["Neon|Ride"] = 138.17, ["Mega"] = 24.51, ["Mega|Ride"] = 96.25, ["Mega|Fly|Ride"] = 300.55}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 10, ["Ride"] = 150, ["Neon"] = 44.46, ["Neon|Ride"] = 300, ["Neon|Fly|Ride"] = 589.3, ["Mega"] = 222.15, ["Mega|Ride"] = 256.64, ["Mega|Fly|Ride"] = 296.57}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 5, ["Ride"] = 30.11, ["Fly|Ride"] = 196.44, ["Neon"] = 47.5, ["Neon|Ride"] = 193.38, ["Neon|Fly|Ride"] = 275, ["Mega"] = 280.05, ["Mega|Ride"] = 392.87, ["Mega|Fly|Ride"] = 968.41}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 8.79, ["Fly"] = 39.14, ["Ride"] = 20.01, ["Fly|Ride"] = 44.87, ["Neon"] = 25, ["Neon|Fly"] = 65.82, ["Neon|Ride"] = 41.79, ["Neon|Fly|Ride"] = 95.68, ["Mega|Ride"] = 259.92, ["Mega|Fly|Ride"] = 343.22}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 58.75, ["Fly|Ride"] = 250, ["Neon|Ride"] = 424.9}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 50, ["Fly"] = 78.73, ["Ride"] = 62.5, ["Neon"] = 269.24, ["Neon|Fly|Ride"] = 600, ["Mega|Ride"] = 825.63, ["Mega|Fly|Ride"] = 994.38}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2, ["Fly"] = 37.5, ["Ride"] = 13.75, ["Fly|Ride"] = 31.24, ["Neon"] = 2.5, ["Neon|Fly"] = 39.3, ["Neon|Ride"] = 16.25, ["Neon|Fly|Ride"] = 65.82, ["Mega|Fly|Ride"] = 179.98}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2, ["Fly"] = 14.5, ["Ride"] = 12.1, ["Fly|Ride"] = 33.4, ["Neon"] = 5, ["Neon|Fly"] = 25.7, ["Neon|Ride"] = 17.23, ["Neon|Fly|Ride"] = 45, ["Mega"] = 49.12, ["Mega|Fly"] = 78.58, ["Mega|Ride"] = 53.63, ["Mega|Fly|Ride"] = 125}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 587.91, ["Ride"] = 508.75, ["Fly|Ride"] = 573, ["Neon|Fly|Ride"] = 1794.37}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 23.75, ["Ride"] = 53.57, ["Neon"] = 44, ["Neon|Ride"] = 78.58, ["Mega"] = 340.82, ["Mega|Ride"] = 642.34, ["Mega|Fly|Ride"] = 261906.55}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2, ["Fly"] = 15, ["Ride"] = 14.69, ["Fly|Ride"] = 25, ["Neon"] = 3.75, ["Neon|Fly"] = 25.55, ["Neon|Ride"] = 17.5, ["Neon|Fly|Ride"] = 40, ["Mega"] = 131.62, ["Mega|Ride"] = 70.58, ["Mega|Fly|Ride"] = 100.41}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 60, ["Ride"] = 96.26, ["Fly|Ride"] = 491.09, ["Neon"] = 248.64, ["Neon|Ride"] = 269.1, ["Neon|Fly|Ride"] = 1080.37, ["Mega"] = 946.8, ["Mega|Ride"] = 999, ["Mega|Fly|Ride"] = 800}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 3.93, ["Fly"] = 35.37, ["Ride"] = 16.64, ["Fly|Ride"] = 53.04, ["Neon"] = 10, ["Neon|Fly"] = 49.88, ["Neon|Ride"] = 18.75, ["Neon|Fly|Ride"] = 67.48, ["Mega"] = 100, ["Mega|Ride"] = 296.57, ["Mega|Fly|Ride"] = 204.94}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2, ["Fly"] = 66.25, ["Ride"] = 41.07, ["Neon"] = 4, ["Neon|Ride"] = 33.74, ["Neon|Fly|Ride"] = 93.75, ["Mega"] = 20, ["Mega|Ride"] = 50, ["Mega|Fly|Ride"] = 181.79}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 42.37, ["Fly"] = 196.44, ["Ride"] = 85.46, ["Fly|Ride"] = 185.58, ["Neon"] = 176.04, ["Neon|Ride"] = 182.15, ["Neon|Fly|Ride"] = 250, ["Mega"] = 785.73, ["Mega|Ride"] = 675, ["Mega|Fly|Ride"] = 1027.33}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2, ["Fly"] = 16.25, ["Ride"] = 21.61, ["Neon"] = 6.49, ["Neon|Ride"] = 38.08, ["Mega"] = 117.87, ["Mega|Ride"] = 190, ["Mega|Fly|Ride"] = 212.5}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 32.84, ["Ride"] = 66.13, ["Fly|Ride"] = 131.62, ["Neon"] = 314.3, ["Neon|Fly|Ride"] = 444.3, ["Mega|Ride"] = 1571.45, ["Mega|Fly|Ride"] = 1414.31}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 5.89, ["Neon"] = 16.14, ["Neon|Ride"] = 44.44, ["Neon|Fly|Ride"] = 145.36, ["Mega|Ride"] = 575}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.5, ["Fly"] = 65.82, ["Ride"] = 69.28, ["Fly|Ride"] = 65.82, ["Neon"] = 7.5, ["Neon|Ride"] = 37.5, ["Neon|Fly|Ride"] = 387.5, ["Mega"] = 175, ["Mega|Ride"] = 1037.42, ["Mega|Fly|Ride"] = 524.47}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 38.9, ["Ride"] = 56.25, ["Fly|Ride"] = 491.09, ["Mega|Ride"] = 2651.81, ["Mega|Fly|Ride"] = 1569.48}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2, ["Fly"] = 265.64, ["Ride"] = 18.94, ["Fly|Ride"] = 865.69, ["Neon"] = 5.03, ["Neon|Ride"] = 37.33, ["Neon|Fly|Ride"] = 137.5, ["Mega"] = 47.51, ["Mega|Fly"] = 250, ["Mega|Ride"] = 90.03, ["Mega|Fly|Ride"] = 173.25}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2, ["Fly"] = 13.76, ["Ride"] = 18.75, ["Fly|Ride"] = 96.97, ["Neon"] = 12.5, ["Neon|Fly"] = 50, ["Neon|Ride"] = 23.75, ["Neon|Fly|Ride"] = 187.5, ["Mega|Fly|Ride"] = 262.24}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 10.63, ["Fly"] = 55.71, ["Ride"] = 31.12, ["Fly|Ride"] = 177.82, ["Neon"] = 77.88, ["Neon|Ride"] = 100, ["Neon|Fly|Ride"] = 392.87, ["Mega|Ride"] = 385.43, ["Mega|Fly|Ride"] = 444.3}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 14.05, ["Ride"] = 62.5, ["Fly|Ride"] = 67.91, ["Neon"] = 131.62, ["Neon|Fly"] = 131.62, ["Neon|Ride"] = 78.58, ["Neon|Fly|Ride"] = 4910.75, ["Mega"] = 859.39, ["Mega|Ride"] = 437.5, ["Mega|Fly|Ride"] = 450.23}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 22.01, ["Fly"] = 48.75, ["Ride"] = 25, ["Fly|Ride"] = 60.02, ["Neon"] = 53.36, ["Neon|Ride"] = 68.75, ["Neon|Fly|Ride"] = 211.04, ["Mega"] = 524.47, ["Mega|Ride"] = 287.5, ["Mega|Fly|Ride"] = 659.78}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 65.49, ["Fly"] = 132.72, ["Ride"] = 112.5, ["Fly|Ride"] = 235.73, ["Neon"] = 331.25, ["Neon|Ride"] = 445.91, ["Neon|Fly|Ride"] = 671.8, ["Mega"] = 1332.88, ["Mega|Ride"] = 1777.16, ["Mega|Fly|Ride"] = 1237.5}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 7.5, ["Ride"] = 53.04, ["Neon"] = 22.5, ["Neon|Ride"] = 491.09, ["Mega"] = 212.5, ["Mega|Fly|Ride"] = 367.34}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 3.75, ["Ride"] = 25.9, ["Fly|Ride"] = 74.99, ["Neon"] = 117.87, ["Neon|Ride"] = 78.58, ["Neon|Fly|Ride"] = 117.87, ["Mega"] = 196.44, ["Mega|Ride"] = 257.5, ["Mega|Fly|Ride"] = 444.3}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 15, ["Fly"] = 261.63, ["Ride"] = 22.88, ["Fly|Ride"] = 103.55, ["Neon"] = 44.8, ["Neon|Ride"] = 196.44, ["Neon|Fly|Ride"] = 222.15, ["Mega"] = 433.14, ["Mega|Ride"] = 607.57}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2, ["Fly"] = 14.6, ["Ride"] = 11.95, ["Fly|Ride"] = 31.25, ["Neon"] = 2, ["Neon|Fly"] = 37.5, ["Neon|Ride"] = 12.68, ["Neon|Fly|Ride"] = 35.88, ["Mega"] = 14.19, ["Mega|Ride"] = 26.22, ["Mega|Fly|Ride"] = 89.35}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 53.13, ["Ride"] = 75, ["Fly|Ride"] = 262.24, ["Neon"] = 388.97, ["Neon|Fly"] = 2226.54, ["Neon|Ride"] = 280, ["Neon|Fly|Ride"] = 464.99, ["Mega"] = 2946.45, ["Mega|Ride"] = 900, ["Mega|Fly|Ride"] = 825}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2, ["Ride"] = 19.66, ["Fly|Ride"] = 33.4, ["Neon"] = 2.74, ["Neon|Ride"] = 26.13, ["Neon|Fly|Ride"] = 123.74, ["Mega"] = 248.5, ["Mega|Ride"] = 131.62, ["Mega|Fly|Ride"] = 400}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.5, ["Fly"] = 26.52, ["Ride"] = 14.99, ["Fly|Ride"] = 49.23, ["Neon"] = 29.48, ["Neon|Ride"] = 34.39, ["Neon|Fly|Ride"] = 113.94, ["Mega|Ride"] = 131.62, ["Mega|Fly|Ride"] = 225}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 91.68, ["Fly"] = 150, ["Ride"] = 125, ["Fly|Ride"] = 246.24, ["Neon|Ride"] = 643.31, ["Mega"] = 1964.31, ["Mega|Ride"] = 2619.41, ["Mega|Fly|Ride"] = 1633.75}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2, ["Ride"] = 24.05, ["Neon"] = 6.25, ["Neon|Ride"] = 18.75, ["Mega"] = 61.13, ["Mega|Ride"] = 1047.97, ["Mega|Fly|Ride"] = 223.75}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 11.94}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2, ["Ride"] = 30.5, ["Neon"] = 7.5, ["Neon|Ride"] = 53.04, ["Neon|Fly|Ride"] = 250, ["Mega"] = 44.98, ["Mega|Ride"] = 62.5, ["Mega|Fly|Ride"] = 200}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 137.5, ["Ride"] = 207.5, ["Fly|Ride"] = 430.08, ["Neon"] = 796.25, ["Neon|Ride"] = 652.34, ["Neon|Fly|Ride"] = 873.75, ["Mega"] = 3142.89, ["Mega|Ride"] = 2250, ["Mega|Fly|Ride"] = 2700}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 2.36, ["Ride"] = 36.25, ["Neon"] = 18.64, ["Neon|Ride"] = 61.25, ["Mega"] = 175, ["Mega|Ride"] = 201.25, ["Mega|Fly|Ride"] = 601.67}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 25, ["Ride"] = 94.9, ["Neon"] = 6.25, ["Neon|Ride"] = 25, ["Neon|Fly|Ride"] = 261.75, ["Mega"] = 31.23, ["Mega|Ride"] = 96.26, ["Mega|Fly|Ride"] = 131.62}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 13.75, ["Ride"] = 17.93, ["Neon"] = 46.16, ["Neon|Ride"] = 105.1, ["Neon|Fly|Ride"] = 156.25, ["Mega"] = 458.67, ["Mega|Ride"] = 524.47, ["Mega|Fly|Ride"] = 629.79}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 10.54, ["Fly"] = 25, ["Ride"] = 25.55, ["Fly|Ride"] = 53.1, ["Neon"] = 125.72, ["Neon|Ride"] = 125, ["Mega|Ride"] = 528.75, ["Mega|Fly|Ride"] = 458.75}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 16.8, ["Ride"] = 71.25, ["Neon"] = 138.75, ["Neon|Ride"] = 262.24, ["Neon|Fly|Ride"] = 1500, ["Mega"] = 533.75, ["Mega|Fly|Ride"] = 844.66}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 137.49, ["Fly"] = 262.24, ["Ride"] = 193.75, ["Fly|Ride"] = 206.25, ["Neon"] = 564.89, ["Neon|Ride"] = 561.9, ["Neon|Fly|Ride"] = 606.25, ["Mega|Fly|Ride"] = 2932.31}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 43.01, ["Fly"] = 262.24, ["Ride"] = 248.42, ["Fly|Ride"] = 326.14, ["Neon"] = 448.71, ["Neon|Ride"] = 521.86, ["Neon|Fly|Ride"] = 630.55}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2, ["Fly"] = 124.98, ["Ride"] = 18.75, ["Fly|Ride"] = 87.5, ["Neon"] = 14.86, ["Neon|Ride"] = 24.99, ["Neon|Fly|Ride"] = 187.5, ["Mega"] = 131.62, ["Mega|Fly|Ride"] = 283.75}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 65.66, ["Fly"] = 222.27, ["Fly|Ride"] = 168.94, ["Neon"] = 163.05, ["Neon|Ride"] = 105.1, ["Mega"] = 247.5, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 50, ["Fly"] = 133.37, ["Ride"] = 71.49, ["Fly|Ride"] = 150, ["Neon"] = 231.17, ["Neon|Ride"] = 262.32, ["Neon|Fly|Ride"] = 383.05, ["Mega|Ride"] = 1558.68, ["Mega|Fly|Ride"] = 1125}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 17.65, ["Ride"] = 64.83, ["Neon"] = 100, ["Neon|Ride"] = 524.47, ["Neon|Fly|Ride"] = 433.14, ["Mega"] = 1000, ["Mega|Ride"] = 1840}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 311.8, ["Ride"] = 586.25, ["Neon|Ride"] = 2962.3, ["Neon|Fly|Ride"] = 1311.25}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 29.78, ["Ride"] = 32.4, ["Fly|Ride"] = 70.38, ["Neon"] = 392.87, ["Neon|Ride"] = 218.75, ["Neon|Fly|Ride"] = 424.3, ["Mega"] = 1139.3, ["Mega|Ride"] = 877.5, ["Mega|Fly|Ride"] = 1025}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2, ["Fly"] = 36.7, ["Ride"] = 11.25, ["Fly|Ride"] = 113.94, ["Neon"] = 3.75, ["Neon|Ride"] = 15, ["Neon|Fly|Ride"] = 68.75, ["Mega"] = 18.33, ["Mega|Fly"] = 104.11, ["Mega|Ride"] = 32.99, ["Mega|Fly|Ride"] = 99.92}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 7.5, ["Neon"] = 18.47, ["Neon|Ride"] = 60.9, ["Neon|Fly|Ride"] = 247.51, ["Mega"] = 137.51, ["Mega|Ride"] = 301.53, ["Mega|Fly|Ride"] = 392.87}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 2.5, ["Ride"] = 28.49, ["Fly|Ride"] = 137.32, ["Neon"] = 17.14, ["Neon|Fly|Ride"] = 917.34, ["Mega"] = 102.9, ["Mega|Fly"] = 474.86, ["Mega|Fly|Ride"] = 326.25}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 415, ["Ride"] = 418.75, ["Fly|Ride"] = 500, ["Neon"] = 1356.56, ["Neon|Ride"] = 2775, ["Neon|Fly|Ride"] = 1955.98, ["Mega|Fly|Ride"] = 4787.5}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 4.44, ["Fly"] = 65.82, ["Ride"] = 16.25, ["Fly|Ride"] = 40, ["Neon"] = 38.91, ["Neon|Ride"] = 65.82, ["Neon|Fly|Ride"] = 98.23, ["Mega"] = 160, ["Mega|Ride"] = 262.24, ["Mega|Fly|Ride"] = 444.3}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 8.87, ["Fly"] = 21.25, ["Ride"] = 16.08, ["Fly|Ride"] = 31.25, ["Neon"] = 25.55, ["Neon|Fly"] = 149, ["Neon|Fly|Ride"] = 112.5, ["Mega|Ride"] = 655.1, ["Mega|Fly|Ride"] = 272.74}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 8.73, ["Fly"] = 42.24, ["Ride"] = 27.5, ["Neon"] = 10.12, ["Neon|Fly"] = 90, ["Neon|Ride"] = 52.32, ["Neon|Fly|Ride"] = 112.5, ["Mega"] = 250, ["Mega|Ride"] = 255.37, ["Mega|Fly|Ride"] = 289.75}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 110.82, ["Fly"] = 43.35, ["Ride"] = 39.89, ["Fly|Ride"] = 92.33, ["Neon"] = 209.8, ["Neon|Ride"] = 196.44, ["Neon|Fly|Ride"] = 293.67, ["Mega"] = 1250, ["Mega|Ride"] = 1555.01, ["Mega|Fly|Ride"] = 628.75}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2, ["Fly"] = 37.49, ["Ride"] = 25.87, ["Fly|Ride"] = 47.8, ["Neon"] = 11.97, ["Neon|Ride"] = 108.75, ["Neon|Fly|Ride"] = 200, ["Mega|Ride"] = 436}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 8.25, ["Fly"] = 750, ["Ride"] = 33.4, ["Fly|Ride"] = 87.5, ["Neon"] = 176.87, ["Neon|Ride"] = 200, ["Mega"] = 1571.45, ["Mega|Fly|Ride"] = 806.25}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2, ["Ride"] = 18.63, ["Neon"] = 5, ["Neon|Ride"] = 33.42, ["Mega"] = 51.26, ["Mega|Ride"] = 105.61, ["Mega|Fly|Ride"] = 237.5}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 52.92, ["Neon"] = 64.08}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 60, ["Neon"] = 75.03, ["Neon|Ride"] = 444.3, ["Neon|Fly|Ride"] = 392.87, ["Mega"] = 262.24, ["Mega|Fly|Ride"] = 485}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 11.42, ["Fly"] = 27.32, ["Ride"] = 29.48, ["Fly|Ride"] = 68.75, ["Neon"] = 50, ["Neon|Fly"] = 65.82, ["Neon|Ride"] = 52.19, ["Neon|Fly|Ride"] = 113.75, ["Mega"] = 551.98, ["Mega|Fly|Ride"] = 344.63}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 321.25, ["Fly"] = 550.11, ["Ride"] = 318.75, ["Fly|Ride"] = 459.99, ["Neon"] = 1562.5, ["Neon|Ride"] = 1362.25, ["Neon|Fly|Ride"] = 1400, ["Mega|Fly|Ride"] = 3981.94}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2, ["Ride"] = 14.89, ["Fly|Ride"] = 25, ["Neon"] = 12.5, ["Neon|Fly"] = 74.47, ["Neon|Ride"] = 32.5, ["Neon|Fly|Ride"] = 249.99, ["Mega|Ride"] = 187.4}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 9.07, ["Fly"] = 105.1, ["Ride"] = 43.75, ["Fly|Ride"] = 131.62, ["Neon"] = 41.13, ["Neon|Ride"] = 147.33, ["Neon|Fly|Ride"] = 387.5, ["Mega"] = 187.5, ["Mega|Fly"] = 655.1, ["Mega|Ride"] = 375}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 25.26, ["Ride"] = 94.14, ["Neon"] = 137.5, ["Neon|Ride"] = 126.18, ["Neon|Fly|Ride"] = 385.43, ["Mega"] = 333.75, ["Mega|Ride"] = 380.91}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 312.5, ["Fly"] = 392.87, ["Fly|Ride"] = 424.3, ["Neon"] = 2667.13, ["Neon|Ride"] = 1375.01, ["Neon|Fly|Ride"] = 1037.42, ["Mega|Ride"] = 6042.32}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 54.34, ["Fly"] = 115.9, ["Ride"] = 61.89, ["Fly|Ride"] = 117.35, ["Neon"] = 130, ["Neon|Ride"] = 112.6, ["Neon|Fly|Ride"] = 343.75, ["Mega"] = 325, ["Mega|Ride"] = 487.5, ["Mega|Fly|Ride"] = 412.52}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.5, ["Ride"] = 18.75, ["Fly|Ride"] = 55.66, ["Neon"] = 11.87, ["Neon|Ride"] = 31.93, ["Neon|Fly|Ride"] = 65.82, ["Mega|Ride"] = 135.52, ["Mega|Fly|Ride"] = 187.5}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 9.81, ["Ride"] = 32.07, ["Neon"] = 25.88, ["Neon|Ride"] = 89.77, ["Neon|Fly|Ride"] = 166.25, ["Mega"] = 161.25}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 50.91, ["Fly"] = 187.5, ["Ride"] = 66.69, ["Fly|Ride"] = 189.33, ["Neon"] = 212.5, ["Neon|Ride"] = 312.5, ["Neon|Fly|Ride"] = 383.05, ["Mega"] = 785.73, ["Mega|Ride"] = 483.42, ["Mega|Fly|Ride"] = 583.75}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 3.75, ["Ride"] = 125, ["Neon"] = 46.25, ["Neon|Ride"] = 237.71, ["Neon|Fly|Ride"] = 192.5, ["Mega"] = 53.57, ["Mega|Ride"] = 161.87, ["Mega|Fly|Ride"] = 385.01}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 28.75, ["Neon"] = 104.82, ["Neon|Ride"] = 381.93, ["Mega"] = 475.37, ["Mega|Fly|Ride"] = 650}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 975, ["Fly"] = 1964.31, ["Ride"] = 937.4, ["Fly|Ride"] = 1078.54, ["Neon|Ride"] = 2500, ["Neon|Fly|Ride"] = 2751.05, ["Mega|Fly|Ride"] = 14405.18}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 18.44, ["Ride"] = 53.04, ["Fly|Ride"] = 185, ["Neon"] = 200, ["Neon|Fly"] = 654.12, ["Neon|Ride"] = 150, ["Mega"] = 391.89, ["Mega|Fly|Ride"] = 750}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 5, ["Fly"] = 25, ["Ride"] = 21.61, ["Fly|Ride"] = 62.5, ["Neon"] = 14.09, ["Neon|Ride"] = 34.99, ["Neon|Fly|Ride"] = 98.23, ["Mega"] = 75.5, ["Mega|Ride"] = 148.85, ["Mega|Fly|Ride"] = 210.37}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 11.45, ["Ride"] = 125, ["Fly|Ride"] = 131.62, ["Neon"] = 90.63, ["Mega|Ride"] = 524.47, ["Mega|Fly|Ride"] = 880}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2, ["Ride"] = 18.08, ["Fly|Ride"] = 56.98, ["Neon"] = 2.5, ["Neon|Ride"] = 25, ["Neon|Fly|Ride"] = 87.29, ["Mega"] = 18.67, ["Mega|Fly"] = 117.87, ["Mega|Ride"] = 36.58, ["Mega|Fly|Ride"] = 136.36}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 62.41, ["Ride"] = 106.45, ["Neon"] = 262.45, ["Neon|Ride"] = 283.27, ["Mega"] = 1312.5, ["Mega|Ride"] = 969.51, ["Mega|Fly|Ride"] = 1250}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 6.09, ["Ride"] = 62.5, ["Fly|Ride"] = 262.24, ["Neon"] = 57.9, ["Neon|Ride"] = 42.5, ["Mega"] = 650, ["Mega|Ride"] = 450, ["Mega|Fly|Ride"] = 522.52}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 3.75, ["Ride"] = 25.55, ["Neon"] = 16.25, ["Neon|Ride"] = 31.25, ["Mega"] = 87.5, ["Mega|Ride"] = 245.74}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 70, ["Fly"] = 50, ["Ride"] = 31.25, ["Fly|Ride"] = 109.68, ["Neon"] = 250, ["Neon|Ride"] = 82.9, ["Neon|Fly|Ride"] = 133.06, ["Mega"] = 989.99, ["Mega|Ride"] = 625, ["Mega|Fly|Ride"] = 655.1}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 12.5, ["Ride"] = 28.77, ["Neon"] = 42.13, ["Neon|Ride"] = 237.5, ["Neon|Fly|Ride"] = 300, ["Mega"] = 458.67, ["Mega|Ride"] = 493.54, ["Mega|Fly|Ride"] = 500}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 58.8, ["Ride"] = 293.13, ["Neon|Ride"] = 175, ["Mega|Ride"] = 1571.45, ["Mega|Fly|Ride"] = 1566.53}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 7.5, ["Neon"] = 131.05, ["Neon|Ride"] = 84.47, ["Neon|Fly|Ride"] = 161.25, ["Mega"] = 131.62, ["Mega|Ride"] = 294.66, ["Mega|Fly|Ride"] = 215.63}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 6.96, ["Ride"] = 18.75, ["Fly|Ride"] = 86.44, ["Neon"] = 92.33, ["Neon|Ride"] = 131.62, ["Neon|Fly|Ride"] = 129.66, ["Mega"] = 333.75, ["Mega|Ride"] = 383.75, ["Mega|Fly|Ride"] = 654.12}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 183.23, ["Fly"] = 363.85, ["Ride"] = 152.49, ["Fly|Ride"] = 198, ["Neon"] = 741.25, ["Neon|Ride"] = 593.45, ["Neon|Fly|Ride"] = 688.75, ["Mega"] = 2216.25, ["Mega|Fly|Ride"] = 1852.5}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2, ["Fly"] = 35, ["Ride"] = 32.24, ["Fly|Ride"] = 32.89, ["Neon"] = 10.27, ["Neon|Fly"] = 54.79, ["Neon|Ride"] = 31.68, ["Neon|Fly|Ride"] = 65.63, ["Mega|Ride"] = 222.15, ["Mega|Fly|Ride"] = 533.16}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 10.5, ["Fly"] = 191.82, ["Ride"] = 33.75, ["Fly|Ride"] = 65, ["Neon"] = 92.39, ["Neon|Ride"] = 78.89, ["Neon|Fly|Ride"] = 196.44, ["Mega"] = 501.42, ["Mega|Ride"] = 437.1, ["Mega|Fly|Ride"] = 375}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2, ["Fly"] = 17.99, ["Ride"] = 13.98, ["Fly|Ride"] = 49.91, ["Neon"] = 2, ["Neon|Fly"] = 24.92, ["Neon|Ride"] = 14.32, ["Neon|Fly|Ride"] = 43.11, ["Mega"] = 15, ["Mega|Ride"] = 30.68, ["Mega|Fly|Ride"] = 73.56}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2, ["Fly|Ride"] = 37.5, ["Neon"] = 2.5, ["Neon|Ride"] = 39.3, ["Neon|Fly|Ride"] = 121.8, ["Mega"] = 18.25, ["Mega|Fly"] = 99.99, ["Mega|Ride"] = 62.5, ["Mega|Fly|Ride"] = 152.24}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 3.75, ["Fly"] = 33.4, ["Ride"] = 18.74, ["Fly|Ride"] = 98.04, ["Neon"] = 25, ["Neon|Ride"] = 78.58, ["Mega"] = 148.85, ["Mega|Ride"] = 249.47, ["Mega|Fly|Ride"] = 231.25}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 28.74, ["Ride"] = 49.97, ["Fly|Ride"] = 125, ["Neon"] = 112.5, ["Neon|Ride"] = 333.4, ["Neon|Fly|Ride"] = 412.5, ["Mega"] = 1124.99, ["Mega|Ride"] = 667.87, ["Mega|Fly|Ride"] = 917.34}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.5, ["Fly"] = 15, ["Ride"] = 16.02, ["Fly|Ride"] = 28.75, ["Neon"] = 13.75, ["Neon|Fly"] = 24.91, ["Neon|Ride"] = 22.86, ["Neon|Fly|Ride"] = 61.91, ["Mega"] = 99.9, ["Mega|Fly"] = 162.49, ["Mega|Ride"] = 391.89, ["Mega|Fly|Ride"] = 168.75}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 11.18, ["Fly"] = 17.5, ["Ride"] = 23.75, ["Fly|Ride"] = 63.74, ["Neon"] = 20.27, ["Neon|Fly"] = 53.1, ["Neon|Ride"] = 34.91, ["Neon|Fly|Ride"] = 112.5, ["Mega"] = 198.36, ["Mega|Fly"] = 392.87, ["Mega|Ride"] = 201.98, ["Mega|Fly|Ride"] = 270}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.38, ["Fly"] = 21.25, ["Ride"] = 17.22, ["Fly|Ride"] = 57.95, ["Neon"] = 14.75, ["Neon|Fly"] = 93.75, ["Neon|Ride"] = 23.58, ["Neon|Fly|Ride"] = 131.62, ["Mega"] = 73.67, ["Mega|Fly"] = 162.5, ["Mega|Ride"] = 84.47, ["Mega|Fly|Ride"] = 154.32}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 125, ["Fly"] = 161.25, ["Ride"] = 22.41, ["Fly|Ride"] = 187.5, ["Neon"] = 28.75, ["Neon|Ride"] = 90, ["Neon|Fly|Ride"] = 785.73, ["Mega"] = 266.59, ["Mega|Fly"] = 381.25, ["Mega|Ride"] = 352.61, ["Mega|Fly|Ride"] = 375}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 9.67, ["Ride"] = 131.62, ["Neon"] = 65.99, ["Neon|Ride"] = 250, ["Mega"] = 524.47, ["Mega|Fly|Ride"] = 625}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 12.5, ["Fly"] = 40.2, ["Ride"] = 17.57, ["Fly|Ride"] = 42.23, ["Neon"] = 13.75, ["Neon|Fly"] = 187.39, ["Neon|Ride"] = 50, ["Neon|Fly|Ride"] = 106.32, ["Mega"] = 349, ["Mega|Ride"] = 300, ["Mega|Fly|Ride"] = 398.36}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2, ["Fly"] = 20.27, ["Ride"] = 17.69, ["Fly|Ride"] = 33.35, ["Neon"] = 15, ["Neon|Fly"] = 44.46, ["Neon|Ride"] = 33.4, ["Neon|Fly|Ride"] = 75, ["Mega|Ride"] = 266.17, ["Mega|Fly|Ride"] = 221.25}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 250, ["Fly"] = 375, ["Ride"] = 296.73, ["Fly|Ride"] = 550.02, ["Neon"] = 1139.3, ["Neon|Ride"] = 1299.55, ["Neon|Fly|Ride"] = 1125, ["Mega|Fly|Ride"] = 3750}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 7.85, ["Neon"] = 145.36, ["Mega"] = 116.25, ["Mega|Ride"] = 593.13, ["Mega|Fly|Ride"] = 458.67}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 2.89, ["Fly"] = 98.23, ["Ride"] = 20.96, ["Fly|Ride"] = 77.6, ["Neon"] = 20.69, ["Neon|Ride"] = 56.24, ["Neon|Fly|Ride"] = 249.99, ["Mega"] = 194.61, ["Mega|Ride"] = 306.45, ["Mega|Fly|Ride"] = 301.53}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 9.55, ["Neon"] = 58, ["Neon|Ride"] = 208.22, ["Neon|Fly|Ride"] = 187.5, ["Mega"] = 574.99, ["Mega|Ride"] = 375, ["Mega|Fly|Ride"] = 526.49}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2, ["Fly"] = 14.71, ["Ride"] = 12.91, ["Fly|Ride"] = 25, ["Neon"] = 2, ["Neon|Fly"] = 27.49, ["Neon|Ride"] = 14.9, ["Neon|Fly|Ride"] = 37.5, ["Mega"] = 17.49, ["Mega|Fly"] = 65.82, ["Mega|Ride"] = 124.75, ["Mega|Fly|Ride"] = 93.75}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 3.75, ["Fly"] = 31.25, ["Ride"] = 16.25, ["Fly|Ride"] = 105.1, ["Neon"] = 11.77, ["Neon|Ride"] = 22.47, ["Neon|Fly|Ride"] = 95, ["Mega"] = 81.24, ["Mega|Ride"] = 133.75, ["Mega|Fly|Ride"] = 210.15}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 3.75, ["Ride"] = 137.5, ["Neon"] = 14.86, ["Neon|Ride"] = 262.24, ["Neon|Fly|Ride"] = 375, ["Mega"] = 177.73, ["Mega|Ride"] = 392.87, ["Mega|Fly|Ride"] = 312.5}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 78.7, ["Fly"] = 155.59, ["Ride"] = 90, ["Fly|Ride"] = 200, ["Neon"] = 529.99, ["Neon|Ride"] = 413.75, ["Neon|Fly|Ride"] = 593.13, ["Mega|Ride"] = 3275.48, ["Mega|Fly|Ride"] = 1625}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 5.79, ["Fly"] = 92.33, ["Ride"] = 27.5, ["Fly|Ride"] = 16891.8, ["Neon"] = 21.65, ["Neon|Ride"] = 160.1, ["Neon|Fly|Ride"] = 392.87, ["Mega"] = 203.5, ["Mega|Ride"] = 252.14, ["Mega|Fly|Ride"] = 529.38}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2, ["Fly"] = 19.99, ["Ride"] = 53.04, ["Neon"] = 22.49, ["Neon|Ride"] = 59.99, ["Neon|Fly|Ride"] = 498.73, ["Mega"] = 66.8, ["Mega|Fly"] = 299.99, ["Mega|Fly|Ride"] = 875.26}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 62.5, ["Fly"] = 200, ["Ride"] = 100.3, ["Fly|Ride"] = 215.1, ["Neon"] = 168.75, ["Neon|Ride"] = 200, ["Neon|Fly|Ride"] = 377.5, ["Mega"] = 593.13, ["Mega|Ride"] = 406.25, ["Mega|Fly|Ride"] = 550}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2, ["Ride"] = 12.1, ["Fly|Ride"] = 21.71, ["Neon"] = 2, ["Neon|Fly"] = 16.31, ["Neon|Ride"] = 16.72, ["Neon|Fly|Ride"] = 31.25, ["Mega"] = 18.14, ["Mega|Fly"] = 47.49, ["Mega|Ride"] = 33.75, ["Mega|Fly|Ride"] = 77.62}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2, ["Neon"] = 3.75, ["Neon|Fly"] = 30.46, ["Neon|Ride"] = 65.82, ["Neon|Fly|Ride"] = 199.39, ["Mega"] = 46.17, ["Mega|Ride"] = 100, ["Mega|Fly|Ride"] = 167.5}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.5, ["Ride"] = 44.03, ["Neon"] = 9.43, ["Neon|Fly|Ride"] = 175.82, ["Mega"] = 110.99, ["Mega|Fly"] = 170.91, ["Mega|Ride"] = 128.75, ["Mega|Fly|Ride"] = 222.5}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 14.71, ["Fly"] = 72.68, ["Ride"] = 41.55, ["Fly|Ride"] = 196.25, ["Neon"] = 22.01, ["Neon|Fly"] = 87.19, ["Neon|Ride"] = 72.91, ["Neon|Fly|Ride"] = 175, ["Mega"] = 104.89, ["Mega|Fly"] = 210.19, ["Mega|Ride"] = 175, ["Mega|Fly|Ride"] = 265.28}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2, ["Fly"] = 53.04, ["Ride"] = 14.75, ["Fly|Ride"] = 86.99, ["Neon"] = 2.5, ["Neon|Fly"] = 24.43, ["Neon|Ride"] = 37.49, ["Neon|Fly|Ride"] = 56.98, ["Mega"] = 26.67, ["Mega|Ride"] = 50, ["Mega|Fly|Ride"] = 112.49}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 25.5, ["Fly"] = 125, ["Ride"] = 119.13, ["Neon"] = 123.75, ["Neon|Ride"] = 174.99, ["Neon|Fly|Ride"] = 625, ["Mega|Ride"] = 537.25}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2486.23, ["Ride"] = 2374.98, ["Fly|Ride"] = 2475, ["Mega|Fly|Ride"] = 34374.22}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2, ["Fly"] = 18.75, ["Ride"] = 15, ["Fly|Ride"] = 39.44, ["Neon"] = 7.38, ["Neon|Fly"] = 60.02, ["Neon|Ride"] = 22.88, ["Neon|Fly|Ride"] = 64.83, ["Mega"] = 115.9, ["Mega|Ride"] = 131.62, ["Mega|Fly|Ride"] = 169.79}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 3.75, ["Neon"] = 8.91, ["Mega"] = 133.68, ["Mega|Fly"] = 420, ["Mega|Ride"] = 148.85, ["Mega|Fly|Ride"] = 222.15}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 19.32, ["Fly"] = 105.1, ["Ride"] = 30, ["Fly|Ride"] = 150, ["Neon"] = 83.58, ["Neon|Ride"] = 98.84, ["Neon|Fly|Ride"] = 278.44, ["Mega"] = 437.5, ["Mega|Ride"] = 982.16}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 33.75, ["Ride"] = 41.64, ["Neon"] = 178.75, ["Mega"] = 1178.59, ["Mega|Ride"] = 785.73, ["Mega|Fly|Ride"] = 612.5}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 125, ["Fly"] = 1310.2, ["Ride"] = 188.45, ["Fly|Ride"] = 239.98, ["Neon"] = 1250, ["Neon|Ride"] = 667.05, ["Neon|Fly|Ride"] = 785.73, ["Mega"] = 5892.9, ["Mega|Fly|Ride"] = 2665.74}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 8.87, ["Ride"] = 27.5, ["Fly|Ride"] = 643.75, ["Neon"] = 14.9, ["Neon|Ride"] = 148.85, ["Mega"] = 148.75, ["Mega|Ride"] = 289.75, ["Mega|Fly|Ride"] = 687.51}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 3.75, ["Fly|Ride"] = 65.82, ["Neon"] = 17.5, ["Mega"] = 133.75, ["Mega|Fly|Ride"] = 789.73}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.5, ["Ride"] = 27.5, ["Fly|Ride"] = 125, ["Neon"] = 7.62, ["Neon|Ride"] = 45.19, ["Mega"] = 131.62, ["Mega|Ride"] = 87.5, ["Mega|Fly|Ride"] = 275}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 12.5, ["Ride"] = 96.26, ["Neon"] = 195, ["Neon|Ride"] = 1114.06, ["Mega"] = 356.25, ["Mega|Ride"] = 435.11}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2, ["Ride"] = 39.3, ["Neon"] = 2.5, ["Neon|Ride"] = 45.4, ["Mega"] = 17.5, ["Mega|Fly"] = 111.08, ["Mega|Ride"] = 148.85, ["Mega|Fly|Ride"] = 262.24}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 84.19, ["Fly"] = 196.44, ["Ride"] = 83.75, ["Fly|Ride"] = 294.66, ["Neon"] = 491.09, ["Neon|Ride"] = 381.96, ["Neon|Fly|Ride"] = 785.73, ["Mega|Fly|Ride"] = 2372.5}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2, ["Ride"] = 87.44, ["Neon"] = 9.9, ["Neon|Ride"] = 135.54, ["Neon|Fly|Ride"] = 196.44, ["Mega"] = 66.66, ["Mega|Ride"] = 263.13}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 42.57, ["Fly"] = 207.82, ["Ride"] = 71.12, ["Fly|Ride"] = 149.98, ["Neon"] = 281.25, ["Neon|Ride"] = 396.67, ["Neon|Fly|Ride"] = 380.1, ["Mega"] = 2500, ["Mega|Fly|Ride"] = 2467.5}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2, ["Fly"] = 57.95, ["Ride"] = 30.46, ["Fly|Ride"] = 48.29, ["Neon"] = 5, ["Neon|Fly"] = 83.28, ["Neon|Ride"] = 37.49, ["Neon|Fly|Ride"] = 79.99, ["Mega"] = 52.5, ["Mega|Ride"] = 112.5, ["Mega|Fly|Ride"] = 168.7}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.5, ["Neon"] = 6.25, ["Neon|Ride"] = 93.75, ["Mega"] = 67.5, ["Mega|Ride"] = 145, ["Mega|Fly|Ride"] = 655.1}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 6.25, ["Fly"] = 73.74, ["Ride"] = 37.5, ["Fly|Ride"] = 196.44, ["Neon"] = 64, ["Neon|Ride"] = 105.1, ["Mega"] = 250, ["Mega|Fly|Ride"] = 524.47}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 403.75, ["Ride"] = 416.9, ["Fly|Ride"] = 510.23, ["Neon"] = 1000, ["Neon|Ride"] = 1375, ["Neon|Fly|Ride"] = 1332.88, ["Mega|Ride"] = 4500, ["Mega|Fly|Ride"] = 5480.3}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 40, ["Fly"] = 78.4, ["Ride"] = 51.91, ["Fly|Ride"] = 93.46, ["Neon"] = 1125, ["Neon|Ride"] = 237.5, ["Neon|Fly|Ride"] = 296.57, ["Mega|Fly|Ride"] = 936.25}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.5, ["Fly"] = 45.12, ["Ride"] = 16.48, ["Fly|Ride"] = 55, ["Neon"] = 8.47, ["Neon|Fly"] = 81.25, ["Neon|Ride"] = 22.63, ["Neon|Fly|Ride"] = 124.9, ["Mega"] = 106.25, ["Mega|Ride"] = 100, ["Mega|Fly|Ride"] = 218.75}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 19.09, ["Fly"] = 106.25, ["Ride"] = 41.36, ["Fly|Ride"] = 106.25, ["Neon"] = 62.5, ["Neon|Ride"] = 110, ["Neon|Fly|Ride"] = 173.43, ["Mega"] = 299.9, ["Mega|Fly"] = 914.13, ["Mega|Ride"] = 338.88, ["Mega|Fly|Ride"] = 387.49}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 15, ["Ride"] = 19.76, ["Fly|Ride"] = 78.58, ["Neon"] = 131.62, ["Neon|Ride"] = 87.49, ["Mega|Ride"] = 627.61, ["Mega|Fly|Ride"] = 537.5}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.75, ["Neon"] = 13.75, ["Mega"] = 67.5, ["Mega|Ride"] = 125}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 6.66, ["Fly"] = 37.5, ["Ride"] = 18.75, ["Fly|Ride"] = 55.01, ["Neon"] = 37.5, ["Neon|Ride"] = 31.22, ["Neon|Fly|Ride"] = 257.33, ["Mega"] = 518.71, ["Mega|Ride"] = 463.75, ["Mega|Fly|Ride"] = 1250}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 81.58, ["Ride"] = 111.9, ["Fly|Ride"] = 205.19, ["Neon|Ride"] = 554.9, ["Neon|Fly|Ride"] = 740.86, ["Mega|Fly|Ride"] = 2804.04}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 26.49, ["Ride"] = 71.22, ["Fly|Ride"] = 112.5, ["Neon"] = 136.14, ["Neon|Ride"] = 196.44, ["Neon|Fly|Ride"] = 371.17, ["Mega"] = 982.16, ["Mega|Ride"] = 852.51, ["Mega|Fly|Ride"] = 785.73}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 1900, ["Fly"] = 3397.09, ["Ride"] = 2434.76, ["Fly|Ride"] = 2283.17, ["Neon"] = 10476.59, ["Neon|Fly|Ride"] = 6118.75, ["Mega|Fly|Ride"] = 25000}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 3.73, ["Fly"] = 62500, ["Ride"] = 111.14, ["Neon"] = 12.5, ["Neon|Fly|Ride"] = 100, ["Mega"] = 91.63, ["Mega|Fly"] = 748.75, ["Mega|Ride"] = 159.38}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 4.75, ["Ride"] = 46.95, ["Neon"] = 42.24, ["Neon|Ride"] = 113.3, ["Mega"] = 518.71, ["Mega|Ride"] = 188.75, ["Mega|Fly|Ride"] = 982.16}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 1063.77, ["Fly"] = 903.37, ["Ride"] = 837.4, ["Fly|Ride"] = 940, ["Neon"] = 2646.25, ["Neon|Ride"] = 2487.5, ["Neon|Fly|Ride"] = 2375, ["Mega|Fly|Ride"] = 10607.21}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 34.3, ["Ride"] = 49.99, ["Fly|Ride"] = 200.05, ["Neon"] = 173.59, ["Neon|Ride"] = 396.88, ["Neon|Fly|Ride"] = 351, ["Mega"] = 800, ["Mega|Ride"] = 766.24, ["Mega|Fly|Ride"] = 1571.45}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 2.5, ["Ride"] = 22.45, ["Fly|Ride"] = 122.04, ["Neon"] = 14.67, ["Neon|Ride"] = 75, ["Neon|Fly|Ride"] = 312.5, ["Mega"] = 167.5, ["Mega|Ride"] = 256.17, ["Mega|Fly|Ride"] = 524.47}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2, ["Fly"] = 106.25, ["Ride"] = 131.62, ["Neon"] = 2.69, ["Neon|Ride"] = 52.9, ["Neon|Fly|Ride"] = 74.65, ["Mega"] = 30, ["Mega|Ride"] = 239.65, ["Mega|Fly|Ride"] = 262.24}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 87.5, ["Ride"] = 123.75, ["Fly|Ride"] = 196.44, ["Neon"] = 392.87, ["Neon|Fly|Ride"] = 575, ["Mega|Fly|Ride"] = 5097.09}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 2.92, ["Fly|Ride"] = 69.63, ["Neon"] = 13.33, ["Neon|Ride"] = 49.54, ["Neon|Fly|Ride"] = 262.24, ["Mega"] = 208.22, ["Mega|Ride"] = 250, ["Mega|Fly|Ride"] = 291.25}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 72.91, ["Ride"] = 145.36, ["Fly|Ride"] = 222.96, ["Neon"] = 576.53, ["Neon|Ride"] = 391.89, ["Neon|Fly|Ride"] = 482.25}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 3.19, ["Fly"] = 100, ["Fly|Ride"] = 105.1, ["Neon"] = 24.95, ["Neon|Fly|Ride"] = 300, ["Mega|Ride"] = 156.25}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 260.09, ["Ride"] = 284.14, ["Fly|Ride"] = 322.46, ["Neon"] = 1427.5, ["Neon|Ride"] = 1276.8, ["Neon|Fly|Ride"] = 971.16, ["Mega|Fly|Ride"] = 3713.86}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 14.85, ["Fly"] = 83.75, ["Ride"] = 18.69, ["Fly|Ride"] = 98.99, ["Neon"] = 148.93, ["Neon|Fly"] = 148.93, ["Neon|Ride"] = 54.28, ["Neon|Fly|Ride"] = 131.62, ["Mega"] = 200, ["Mega|Ride"] = 618.74}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2, ["Fly"] = 19.38, ["Ride"] = 11.76, ["Fly|Ride"] = 34.31, ["Neon"] = 6.25, ["Neon|Fly"] = 29.89, ["Neon|Ride"] = 19.37, ["Neon|Fly|Ride"] = 46.25, ["Mega"] = 50.16, ["Mega|Fly"] = 135.54, ["Mega|Ride"] = 110, ["Mega|Fly|Ride"] = 269.12}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 1173.84, ["Ride"] = 1000, ["Fly|Ride"] = 1355, ["Neon|Ride"] = 7203.09, ["Neon|Fly|Ride"] = 5696.47}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 11.93, ["Fly"] = 917.34, ["Ride"] = 77.6, ["Neon"] = 40.74, ["Neon|Ride"] = 123.76, ["Mega"] = 293.73, ["Mega|Ride"] = 357.52, ["Mega|Fly|Ride"] = 655.1}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 7.85, ["Fly"] = 65, ["Ride"] = 40.01, ["Fly|Ride"] = 102.05, ["Neon"] = 29.48, ["Neon|Fly"] = 117.87, ["Neon|Ride"] = 71.13, ["Neon|Fly|Ride"] = 262.24, ["Mega"] = 196.44, ["Mega|Ride"] = 194.43, ["Mega|Fly|Ride"] = 282.43}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 34.1, ["Fly"] = 31.67, ["Ride"] = 37.5, ["Fly|Ride"] = 71.57, ["Neon|Ride"] = 199.8, ["Neon|Fly|Ride"] = 187.5, ["Mega|Fly|Ride"] = 760}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 14.87, ["Ride"] = 26.52, ["Fly|Ride"] = 65.82, ["Neon"] = 43.75, ["Neon|Ride"] = 61.25, ["Neon|Fly|Ride"] = 171.23, ["Mega"] = 350, ["Mega|Ride"] = 358.75, ["Mega|Fly|Ride"] = 524.47}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 30.93, ["Ride"] = 104.47, ["Fly|Ride"] = 606.25, ["Neon"] = 172.5, ["Neon|Ride"] = 358.75, ["Mega|Ride"] = 623.75, ["Mega|Fly|Ride"] = 550}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2, ["Ride"] = 111.05, ["Fly|Ride"] = 74.47, ["Neon"] = 2.5, ["Neon|Fly"] = 53.04, ["Neon|Ride"] = 104.47, ["Neon|Fly|Ride"] = 100.15, ["Mega"] = 17.19, ["Mega|Ride"] = 75.48}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 72.5, ["Fly"] = 110.99, ["Ride"] = 67.91, ["Fly|Ride"] = 133.62, ["Neon"] = 551.25, ["Neon|Ride"] = 374.99, ["Neon|Fly|Ride"] = 435, ["Mega"] = 3142.89, ["Mega|Fly|Ride"] = 1444.29}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 4.44, ["Fly"] = 87.04, ["Ride"] = 22.25, ["Fly|Ride"] = 121.25, ["Neon"] = 56.16, ["Mega|Ride"] = 370.99}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2, ["Fly"] = 31.25, ["Ride"] = 17.5, ["Fly|Ride"] = 40, ["Neon"] = 15.6, ["Neon|Fly"] = 74.47, ["Neon|Ride"] = 53.04, ["Neon|Fly|Ride"] = 117, ["Mega|Ride"] = 258.32, ["Mega|Fly|Ride"] = 250}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 3.75, ["Ride"] = 120, ["Neon"] = 19.17, ["Neon|Fly"] = 129.66, ["Neon|Fly|Ride"] = 195.46, ["Mega|Fly|Ride"] = 444.3}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 57.9, ["Ride"] = 148.93, ["Fly|Ride"] = 250, ["Neon"] = 200, ["Neon|Ride"] = 487.5, ["Neon|Fly|Ride"] = 524.47, ["Mega|Ride"] = 1385.65, ["Mega|Fly|Ride"] = 1156.67}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 7.23, ["Neon"] = 23.76, ["Mega"] = 116.24}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2, ["Ride"] = 37.5, ["Neon"] = 2, ["Neon|Ride"] = 108.45, ["Mega"] = 16.25, ["Mega|Ride"] = 38.36, ["Mega|Fly|Ride"] = 491.09}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2, ["Fly"] = 98.03, ["Ride"] = 33.4, ["Fly|Ride"] = 37.43, ["Neon"] = 3.42, ["Neon|Ride"] = 27.5, ["Neon|Fly|Ride"] = 157.15, ["Mega"] = 18.09, ["Mega|Ride"] = 49.41, ["Mega|Fly|Ride"] = 130.62}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2, ["Fly"] = 29.41, ["Ride"] = 18.73, ["Fly|Ride"] = 46.91, ["Neon"] = 6.25, ["Neon|Ride"] = 26.91, ["Neon|Fly|Ride"] = 82.51, ["Mega"] = 60, ["Mega|Ride"] = 62.5, ["Mega|Fly|Ride"] = 175}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.12, ["Ride"] = 27.5, ["Fly|Ride"] = 105.1, ["Neon"] = 37.49, ["Mega|Ride"] = 101.23}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2, ["Fly"] = 36.22, ["Ride"] = 14.67, ["Fly|Ride"] = 50.1, ["Neon"] = 14.97, ["Neon|Fly"] = 196.44, ["Neon|Ride"] = 39.3, ["Neon|Fly|Ride"] = 74.99}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 56.92, ["Ride"] = 102.5, ["Fly|Ride"] = 210.19, ["Neon"] = 255.37, ["Neon|Ride"] = 301.53, ["Neon|Fly|Ride"] = 982.16, ["Mega"] = 917.34, ["Mega|Ride"] = 844.66, ["Mega|Fly|Ride"] = 1046.98}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2, ["Fly"] = 16.72, ["Ride"] = 14.31, ["Fly|Ride"] = 33.74, ["Neon"] = 2.5, ["Neon|Fly"] = 31.23, ["Neon|Ride"] = 16.25, ["Neon|Fly|Ride"] = 41.28, ["Mega"] = 23.75, ["Mega|Fly|Ride"] = 99.68}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 6.79, ["Fly"] = 76.62, ["Ride"] = 22.41, ["Fly|Ride"] = 96.26, ["Neon"] = 30.02, ["Neon|Fly"] = 87.5, ["Neon|Ride"] = 56.16, ["Neon|Fly|Ride"] = 217.71, ["Mega"] = 392.87, ["Mega|Ride"] = 300, ["Mega|Fly|Ride"] = 458.67}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 17.5, ["Fly"] = 38.31, ["Ride"] = 26.25, ["Fly|Ride"] = 80.45, ["Neon"] = 118.24, ["Neon|Ride"] = 137.49, ["Neon|Fly|Ride"] = 212.5, ["Mega"] = 750, ["Mega|Ride"] = 562.5, ["Mega|Fly|Ride"] = 582.5}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 6.25, ["Fly"] = 187.5, ["Ride"] = 42.5, ["Neon"] = 43.57, ["Neon|Ride"] = 68.34, ["Mega"] = 348.75, ["Mega|Ride"] = 998.75, ["Mega|Fly|Ride"] = 392.87}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2, ["Fly"] = 26.52, ["Ride"] = 14.32, ["Fly|Ride"] = 49.12, ["Neon"] = 4.38, ["Neon|Fly"] = 23.58, ["Neon|Ride"] = 18.75, ["Neon|Fly|Ride"] = 63.7, ["Mega"] = 40.9, ["Mega|Ride"] = 133.66, ["Mega|Fly|Ride"] = 116.25}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 3.75, ["Fly"] = 72.68, ["Ride"] = 36.25, ["Neon"] = 20.59, ["Neon|Fly"] = 112.5, ["Neon|Ride"] = 131.62, ["Mega"] = 196.44, ["Mega|Fly"] = 700, ["Mega|Ride"] = 250, ["Mega|Fly|Ride"] = 392.87}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 1000, ["Ride"] = 1019.87, ["Fly|Ride"] = 1103.23, ["Neon"] = 3852.9, ["Neon|Ride"] = 2613.75, ["Neon|Fly|Ride"] = 2250, ["Mega|Fly|Ride"] = 6600}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 100.85, ["Ride"] = 150, ["Fly|Ride"] = 362.5, ["Neon"] = 550.02, ["Neon|Ride"] = 486.25, ["Neon|Fly|Ride"] = 705, ["Mega"] = 5892.9, ["Mega|Ride"] = 2488.78, ["Mega|Fly|Ride"] = 1975.84}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.5, ["Fly"] = 52.92, ["Neon"] = 5.84, ["Neon|Ride"] = 49.91, ["Neon|Fly|Ride"] = 196.44, ["Mega"] = 85, ["Mega|Fly|Ride"] = 1047.97}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 75, ["Ride"] = 125, ["Fly|Ride"] = 187.5, ["Neon"] = 325, ["Neon|Ride"] = 349.99, ["Neon|Fly|Ride"] = 525, ["Mega"] = 1703.05, ["Mega|Ride"] = 1625, ["Mega|Fly|Ride"] = 1500}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 3.75, ["Ride"] = 18.21, ["Fly|Ride"] = 85.46, ["Neon"] = 18.75, ["Neon|Fly"] = 52.24, ["Neon|Ride"] = 45.42, ["Neon|Fly|Ride"] = 262.24, ["Mega"] = 277.7, ["Mega|Ride"] = 301.25, ["Mega|Fly|Ride"] = 380.1}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 299.29, ["Fly"] = 313.55, ["Ride"] = 324.12, ["Fly|Ride"] = 410, ["Neon|Ride"] = 1244.4, ["Neon|Fly|Ride"] = 1362.25, ["Mega|Fly|Ride"] = 4312.5}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2, ["Fly"] = 72.76, ["Ride"] = 50, ["Fly|Ride"] = 202.94, ["Neon"] = 29.89, ["Neon|Ride"] = 51.78, ["Mega|Fly"] = 306.45, ["Mega|Ride"] = 593.13}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2, ["Neon"] = 26.67, ["Mega"] = 314.3, ["Mega|Ride"] = 336.89}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 61.25, ["Ride"] = 262.24, ["Fly|Ride"] = 187.5, ["Neon"] = 157.15, ["Neon|Ride"] = 118.65, ["Mega"] = 1047.97, ["Mega|Ride"] = 789, ["Mega|Fly|Ride"] = 1000}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.19, ["Ride"] = 47.36, ["Neon"] = 26.52, ["Neon|Ride"] = 135.15, ["Mega"] = 222.15, ["Mega|Ride"] = 241.23, ["Mega|Fly|Ride"] = 434.3}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2, ["Fly"] = 14.4, ["Ride"] = 12.38, ["Fly|Ride"] = 37.47, ["Neon"] = 2, ["Neon|Fly"] = 22.5, ["Neon|Ride"] = 25, ["Neon|Fly|Ride"] = 35.75, ["Mega"] = 157.15, ["Mega|Ride"] = 31.25, ["Mega|Fly|Ride"] = 76.79}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4375, ["Ride"] = 4875, ["Fly|Ride"] = 4302.5, ["Neon"] = 29464.45, ["Neon|Fly|Ride"] = 17537.5, ["Mega|Fly|Ride"] = 122768.54}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 7.5, ["Ride"] = 39.59, ["Neon"] = 49.91, ["Neon|Ride"] = 100, ["Mega"] = 261.26, ["Mega|Ride"] = 296.57, ["Mega|Fly|Ride"] = 392.87}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2, ["Fly"] = 23.52, ["Ride"] = 15.7, ["Fly|Ride"] = 48.75, ["Neon"] = 11.26, ["Neon|Fly"] = 43.72, ["Neon|Ride"] = 35, ["Neon|Fly|Ride"] = 79.24, ["Mega"] = 137.5, ["Mega|Ride"] = 165.01, ["Mega|Fly|Ride"] = 230.64}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 412.31, ["Fly"] = 569.66, ["Ride"] = 507.24, ["Fly|Ride"] = 529.08, ["Neon"] = 2000, ["Neon|Ride"] = 1481.71, ["Neon|Fly|Ride"] = 1661.36, ["Mega|Fly|Ride"] = 5631.65}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 6.25, ["Ride"] = 31.06, ["Neon"] = 33.4, ["Mega"] = 179, ["Mega|Fly|Ride"] = 655.1}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 3.75, ["Fly"] = 3919.34, ["Ride"] = 44.46, ["Neon"] = 125, ["Neon|Ride"] = 59.99, ["Neon|Fly|Ride"] = 267.15, ["Mega|Ride"] = 382.5}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2, ["Ride"] = 19.39, ["Neon"] = 4.88, ["Neon|Fly"] = 118.75, ["Neon|Ride"] = 22.18, ["Neon|Fly|Ride"] = 87.37, ["Mega"] = 60.91, ["Mega|Ride"] = 74.36, ["Mega|Fly|Ride"] = 247.5}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 1045.49, ["Ride"] = 971.35, ["Fly|Ride"] = 1310.2, ["Neon|Ride"] = 3125, ["Neon|Fly|Ride"] = 2338.77}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 8.6, ["Ride"] = 53.04, ["Neon"] = 34.06, ["Neon|Ride"] = 92.33, ["Neon|Fly|Ride"] = 617.5, ["Mega"] = 130, ["Mega|Ride"] = 218.75, ["Mega|Fly|Ride"] = 337.5}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 6.25, ["Fly"] = 225, ["Ride"] = 28.75, ["Fly|Ride"] = 62.5, ["Neon"] = 23.51, ["Neon|Ride"] = 55.13, ["Neon|Fly|Ride"] = 206.26, ["Mega"] = 202.33, ["Mega|Fly"] = 740.86, ["Mega|Ride"] = 212.01, ["Mega|Fly|Ride"] = 250}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 4.44, ["Fly"] = 32.5, ["Ride"] = 15.86, ["Neon"] = 14.75, ["Neon|Fly"] = 190, ["Neon|Ride"] = 29.58, ["Neon|Fly|Ride"] = 77.48, ["Mega"] = 262.24, ["Mega|Ride"] = 186.25, ["Mega|Fly|Ride"] = 204.94}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 23.52, ["Ride"] = 36.25, ["Fly|Ride"] = 53.04, ["Neon"] = 111.98, ["Neon|Fly|Ride"] = 294.66, ["Mega|Ride"] = 431.25, ["Mega|Fly|Ride"] = 707.16}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2, ["Fly|Ride"] = 78.58, ["Neon"] = 6.5, ["Neon|Ride"] = 43.07, ["Neon|Fly|Ride"] = 150, ["Mega"] = 51.24, ["Mega|Ride"] = 100, ["Mega|Fly|Ride"] = 375}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 587.5, ["Ride"] = 512.49, ["Fly|Ride"] = 655.1, ["Neon"] = 2466.25, ["Neon|Fly|Ride"] = 2665.74, ["Mega|Fly|Ride"] = 7487.5}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.5, ["Fly"] = 98, ["Ride"] = 76.14, ["Neon"] = 15, ["Neon|Ride"] = 88.75, ["Neon|Fly|Ride"] = 444.3, ["Mega"] = 93.75, ["Mega|Ride"] = 229.83}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2, ["Ride"] = 50, ["Neon"] = 7.48, ["Neon|Fly"] = 222.96, ["Neon|Ride"] = 200.05, ["Neon|Fly|Ride"] = 125, ["Mega"] = 78.58, ["Mega|Ride"] = 131.62, ["Mega|Fly|Ride"] = 331.98}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2, ["Ride"] = 47.08, ["Neon"] = 6.25, ["Neon|Ride"] = 42.87, ["Mega"] = 96.26, ["Mega|Fly"] = 145.36, ["Mega|Ride"] = 94.9, ["Mega|Fly|Ride"] = 138.74}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 3.75, ["Ride"] = 33.03, ["Neon"] = 14.75, ["Mega|Ride"] = 312.5}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 31.61, ["Fly"] = 93.75, ["Ride"] = 112.5, ["Fly|Ride"] = 262.24, ["Neon"] = 145.36, ["Neon|Ride"] = 137.24, ["Neon|Fly|Ride"] = 318.74, ["Mega"] = 785.73, ["Mega|Ride"] = 921.25, ["Mega|Fly|Ride"] = 785.73}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 19.32, ["Ride"] = 54.61, ["Neon"] = 85.88, ["Neon|Ride"] = 176.79, ["Neon|Fly|Ride"] = 262.24, ["Mega"] = 454.5, ["Mega|Ride"] = 512.79, ["Mega|Fly|Ride"] = 545}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 4.44, ["Fly"] = 18.75, ["Ride"] = 13.68, ["Fly|Ride"] = 30, ["Neon"] = 27.28, ["Neon|Ride"] = 42.5, ["Neon|Fly|Ride"] = 82.51, ["Mega"] = 285.63, ["Mega|Ride"] = 262.24, ["Mega|Fly|Ride"] = 333.23}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 8.74, ["Ride"] = 96.7, ["Neon"] = 68.75, ["Neon|Ride"] = 129.66}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2, ["Ride"] = 19.64, ["Fly|Ride"] = 106.24, ["Neon"] = 14.75, ["Neon|Ride"] = 61.89, ["Neon|Fly|Ride"] = 146.63, ["Mega"] = 100, ["Mega|Ride"] = 148.85, ["Mega|Fly|Ride"] = 250}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 33.25, ["Ride"] = 25, ["Fly|Ride"] = 73.73, ["Neon"] = 392.87, ["Neon|Ride"] = 133.75, ["Neon|Fly|Ride"] = 186.62, ["Mega"] = 882.96, ["Mega|Fly|Ride"] = 776.89}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 33.6, ["Fly"] = 832.5, ["Neon"] = 249.47, ["Mega"] = 493.04, ["Mega|Ride"] = 562.5, ["Mega|Fly|Ride"] = 725.63}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 48.63, ["Ride"] = 73.5, ["Fly|Ride"] = 176.79, ["Neon"] = 175, ["Neon|Ride"] = 523.5, ["Neon|Fly|Ride"] = 347.05, ["Mega|Ride"] = 1570.57, ["Mega|Fly|Ride"] = 1680.47}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 35.42, ["Fly"] = 78.58, ["Ride"] = 73.07, ["Fly|Ride"] = 191.53, ["Neon"] = 182.69, ["Neon|Ride"] = 193.75, ["Neon|Fly|Ride"] = 549.82, ["Mega"] = 815.27, ["Mega|Fly|Ride"] = 609.53}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 18.14, ["Ride"] = 68.76, ["Fly|Ride"] = 196.44, ["Neon"] = 157.15, ["Neon|Ride"] = 271.25, ["Mega"] = 999.99, ["Mega|Ride"] = 740.86, ["Mega|Fly|Ride"] = 785.73}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 18.75, ["Ride"] = 54.48, ["Fly|Ride"] = 100, ["Neon"] = 123.18, ["Neon|Fly"] = 400, ["Neon|Ride"] = 131.62, ["Neon|Fly|Ride"] = 266.59, ["Mega"] = 512.23, ["Mega|Ride"] = 503.49, ["Mega|Fly|Ride"] = 679.99}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2, ["Fly"] = 16.89, ["Ride"] = 14.53, ["Fly|Ride"] = 31.18, ["Neon"] = 5.88, ["Neon|Fly"] = 31.25, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 39.51, ["Mega"] = 44.44, ["Mega|Ride"] = 76.25, ["Mega|Fly|Ride"] = 380.1}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1800}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 57.5, ["Ride"] = 87.5, ["Fly|Ride"] = 392.87, ["Neon"] = 328, ["Neon|Ride"] = 312.5, ["Neon|Fly|Ride"] = 312.5, ["Mega|Ride"] = 1079.39, ["Mega|Fly|Ride"] = 1178.59}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2, ["Ride"] = 75.93, ["Neon"] = 6.25, ["Neon|Ride"] = 41.12, ["Neon|Fly|Ride"] = 275.02, ["Mega"] = 26.68, ["Mega|Ride"] = 80.89}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 35.12, ["Ride"] = 105.1, ["Fly|Ride"] = 159.12, ["Neon"] = 196.44, ["Neon|Ride"] = 266.3, ["Neon|Fly|Ride"] = 518.75, ["Mega"] = 733.08, ["Mega|Ride"] = 740.86, ["Mega|Fly|Ride"] = 1178.59}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2, ["Neon"] = 3.75, ["Mega"] = 22.54}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2, ["Neon"] = 5, ["Mega"] = 38.75, ["Mega|Ride"] = 144.2}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 108.83, ["Fly"] = 333.15, ["Ride"] = 145.15, ["Fly|Ride"] = 275.02, ["Neon"] = 2516, ["Neon|Ride"] = 560, ["Neon|Fly|Ride"] = 785.73, ["Mega|Ride"] = 2422.97, ["Mega|Fly|Ride"] = 1906.25}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2, ["Fly"] = 62.5, ["Ride"] = 33.4, ["Fly|Ride"] = 90.48, ["Neon"] = 8.75, ["Neon|Ride"] = 23.75, ["Neon|Fly|Ride"] = 108.75, ["Mega"] = 87.5, ["Mega|Ride"] = 92.33, ["Mega|Fly|Ride"] = 268.29}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2, ["Fly"] = 36.25, ["Ride"] = 61.07, ["Fly|Ride"] = 82.5, ["Neon"] = 6.25, ["Neon|Ride"] = 38.91, ["Neon|Fly|Ride"] = 131.62, ["Mega"] = 35, ["Mega|Ride"] = 117.87, ["Mega|Fly|Ride"] = 655.1}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2, ["Neon"] = 4.03, ["Neon|Fly"] = 250, ["Neon|Ride"] = 200, ["Mega"] = 50}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2, ["Ride"] = 26.52, ["Neon"] = 6.25, ["Neon|Ride"] = 148.75, ["Mega"] = 78.3, ["Mega|Ride"] = 196.44}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 49.81, ["Ride"] = 128.75, ["Fly|Ride"] = 593.45, ["Neon"] = 403.87, ["Neon|Ride"] = 491.09, ["Neon|Fly|Ride"] = 662.5, ["Mega|Ride"] = 1473.24, ["Mega|Fly|Ride"] = 1440.82}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 3.74, ["Ride"] = 78.58, ["Neon"] = 100.19, ["Neon|Ride"] = 150.04, ["Mega"] = 446.88, ["Mega|Ride"] = 888.59}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 330, ["Ride"] = 458.67, ["Neon"] = 875, ["Neon|Ride"] = 1310.2, ["Neon|Fly|Ride"] = 1250, ["Mega|Fly|Ride"] = 3928.6}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 83.75}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 48.75}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 31.24}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 16.85}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 116.81}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 91.23}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 13.19}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 6.66}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 247.5}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 25}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 38.82}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 5.63}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 31.23}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 197.93}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 8.89}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 5.07}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 7.5}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 7.23}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 11.97}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 428.59}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 8.74}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 989.97}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.5}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 43.75}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 7.13}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 30.41}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.5}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 3.75}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 23.27}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 32.46}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 50.03}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 17.65}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 25}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 16.7}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 6.25}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 17.48}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 16.25}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 125.45}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 5.7}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 5.9}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 1875}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.5}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 131.62}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 287.5}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 5.73}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 4.46}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 8.54}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 6.35}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 44.82}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 183.97}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 5.75}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 10.39}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 1125}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 29.86}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 5.72}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 51.09}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 5.79}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 32.23}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 96.25}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 21.94}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 12.32}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 3.4}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 24.16}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 296.59}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 12.5}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 31.13}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 75}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 212.35}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 3.94}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 7.27}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 295.87}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 26.25}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 103.75}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 19.8}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.5}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 21106.68}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 156.25}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 71.14}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 39.89}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 41.56}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 44.44}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 29.66}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 41.16}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 77}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 74.99}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 56.98}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 53.8}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 108.62}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 45.17}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 6580.41}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 6.14}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 5.84}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 4.76}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 8.81}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 74.43}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 105.38}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.04}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 4.2}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 3.75}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 7.5}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 12.38}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 950}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 14.9}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 562.5}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 13.42}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.5}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.5}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 576.21}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 38.75}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 131.31}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 23.89}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 53.04}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 43.75}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 11.85}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 11.11}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 7.22}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 15}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 2.73}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 27.5}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 6.25}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 2.35}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 3.55}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 22.83}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 785.73}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 50}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 6.88}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 998.75}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 8.95}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 3}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 7.5}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 22.34}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 12.9}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 2.93}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 11.45}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 4.53}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 5.97}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 37.1}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 19.85}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 4.52}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 2.96}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 4.46}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 8.8}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 5.75}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 4.53}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 4.03}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.49}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 3.42}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 10}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 7578.03}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 7.85}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 17.74}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 2.23}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 8.57}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 7.5}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 13.48}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 12.5}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 2.35}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 7.12}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.19}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 2}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 50}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 6.19}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 3.53}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 3.17}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 3.18}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 2}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 5.89}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4099.9}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 7.83}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.5}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 31.84}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 6.06}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 3.75}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 60.59}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 98}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 10}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 123.65}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.5}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 12.48}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 5.89}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 6.25}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 7.03}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 131.31}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.5}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 4.44}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.5}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.5}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.75}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 5.89}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 14.98}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 3.16}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 3.75}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.03}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.5}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 10}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.31}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.5}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 2}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 31.25}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 3.54}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 3.3}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 8.63}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 115.64}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.37}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 59.23}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 5.77}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 3.75}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 991.9}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.03}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 44.22}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.49}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 7.85}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 10.91}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.5}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 10}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.5}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 5.18}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 5.82}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 6.83}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 13.48}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.5}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 17.57}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 13.75}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.03}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 6.66}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 4.2}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 2.83}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 11.88}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 9.79}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 17.94}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 3.75}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 4.23}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 2.19}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 17}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 49.1}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 3.22}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 5.89}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 28.3}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 58.75}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 17.5}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 9.81}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 5.89}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 45}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 5.92}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 27.3}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.03}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 3.82}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 3.6}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 26.6}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 4.09}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 130.9}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 5.89}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 136.81}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 4.3}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1131.15}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 3.93}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 235.17}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 3.65}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.5}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.5}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.5}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 189.99}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 61.25}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 3.18}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 2.5}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 13.53}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 131.31}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 16.7}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 7.5}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 3.23}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.48}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 4.32}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 3.56}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 8.75}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 63.77}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 2.09}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 58.39}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 3.69}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 26.47}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.5}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 8.87}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 7.85}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 22.4}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 146.51}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 3.92}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 5.78}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 71.28}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 12.5}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 3.53}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 739.1}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 480.13}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 47.7}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 61.36}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 383.75}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 8.87}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.5}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 143.94}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.65}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 3.48}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 7.2}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 27.82}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 61.27}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 3.75}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 50}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 2.34}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 2.25}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 73.42}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 14.62}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 58.3}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 32.24}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 2}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 63}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 51.25}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 5.57}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 7.85}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 29.78}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 3.74}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.03}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 11.25}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 46.16}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 41}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 25}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1921.41}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 8.75}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 7.88}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 162.66}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.5}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 312.5}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 17.08}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 14.71}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.5}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 9.83}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 6.25}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 10.24}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 303.75}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 49.68}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 43.75}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 52.92}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.5}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 6.25}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 69.22}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 157.4}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 70.63}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 1100}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 6.73}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 2221.29}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 524.99}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 3.75}},
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