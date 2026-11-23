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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 810.99, ["Fly"] = 1117.98, ["Ride"] = 1047.65, ["Fly|Ride"] = 808.79, ["Neon"] = 6461.69, ["Neon|Ride"] = 4470.84, ["Neon|Fly|Ride"] = 3423.07}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 419.12, ["Fly"] = 500.63, ["Ride"] = 531.17, ["Fly|Ride"] = 578.02, ["Neon|Fly|Ride"] = 2861.61, ["Mega|Fly|Ride"] = 8364.34}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 5419.32, ["Ride"] = 4790.63, ["Fly|Ride"] = 4850.99, ["Neon"] = 25845.29, ["Neon|Fly|Ride"] = 20192.76, ["Mega|Fly|Ride"] = 62866.04}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 125.99, ["Ride"] = 157.5, ["Fly|Ride"] = 576.84, ["Neon"] = 972.65, ["Neon|Ride"] = 820.32, ["Neon|Fly|Ride"] = 1188.17, ["Mega"] = 3494.32, ["Mega|Fly|Ride"] = 6154.33}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 472.5, ["Ride"] = 525, ["Fly|Ride"] = 524.99, ["Neon|Fly|Ride"] = 1785, ["Mega|Fly|Ride"] = 6922.74}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 7.97, ["Ride"] = 39.38, ["Fly|Ride"] = 119.44, ["Neon"] = 32.82, ["Neon|Ride"] = 108.48, ["Neon|Fly|Ride"] = 286.15, ["Mega"] = 262.5, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 409.5}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 4.98, ["Fly"] = 21.63, ["Ride"] = 19.92, ["Fly|Ride"] = 52.5, ["Neon"] = 23.63, ["Neon|Fly"] = 64.32, ["Neon|Ride"] = 42.29, ["Neon|Fly|Ride"] = 90.5, ["Mega"] = 119.68, ["Mega|Fly"] = 303.19, ["Mega|Ride"] = 168.6, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 115.5, ["Ride"] = 290.07, ["Neon"] = 548.1, ["Neon|Fly"] = 392.44, ["Neon|Fly|Ride"] = 1676.45, ["Mega"] = 1846.07, ["Mega|Ride"] = 1885.99, ["Mega|Fly|Ride"] = 1846.07}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 33.44, ["Fly"] = 62.22, ["Ride"] = 45.94, ["Fly|Ride"] = 112.35, ["Neon"] = 275.79, ["Neon|Ride"] = 209.45, ["Neon|Fly|Ride"] = 162.07, ["Mega"] = 2100, ["Mega|Ride"] = 692.29, ["Mega|Fly|Ride"] = 719.98}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 24.82, ["Fly"] = 56.59, ["Ride"] = 27.29, ["Fly|Ride"] = 61.82, ["Neon"] = 230.78, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 251.48, ["Mega|Ride"] = 769.08, ["Mega|Fly|Ride"] = 825.66}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 46.09, ["Ride"] = 59.06, ["Fly|Ride"] = 149.2, ["Neon|Ride"] = 209.57, ["Neon|Fly|Ride"] = 299.99, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 61.57}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 415.28, ["Ride"] = 367.5, ["Fly|Ride"] = 444.94, ["Neon"] = 1443.75, ["Neon|Ride"] = 1676.45, ["Neon|Fly|Ride"] = 1385.94, ["Mega|Fly|Ride"] = 3485.94}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 118.13, ["Fly"] = 175.88, ["Ride"] = 127.32, ["Fly|Ride"] = 140.43, ["Neon|Fly|Ride"] = 540.75, ["Mega|Fly|Ride"] = 2307.59}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.63, ["Fly"] = 31.45, ["Ride"] = 23.08, ["Fly|Ride"] = 91.17, ["Neon"] = 15.63, ["Neon|Fly"] = 61.83, ["Neon|Ride"] = 66.7, ["Mega"] = 136.23, ["Mega|Ride"] = 184.63, ["Mega|Fly|Ride"] = 381.92}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 131.25, ["Fly"] = 144.64, ["Ride"] = 123.44, ["Fly|Ride"] = 144.38, ["Neon"] = 615.05, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 543.37, ["Mega|Fly|Ride"] = 1967.44}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.91, ["Fly"] = 31.45, ["Ride"] = 18.23, ["Fly|Ride"] = 46.16, ["Neon"] = 19.92, ["Neon|Fly"] = 104.79, ["Neon|Ride"] = 62.89, ["Neon|Fly|Ride"] = 91.85, ["Mega"] = 787.5, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 38.06, ["Ride"] = 70.2, ["Fly|Ride"] = 140.39, ["Neon"] = 106.88, ["Neon|Ride"] = 149.63, ["Neon|Fly|Ride"] = 251.48, ["Mega"] = 790.01, ["Mega|Ride"] = 769.6, ["Mega|Fly|Ride"] = 788.58}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 27.43}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 41.88, ["Ride"] = 170.63, ["Neon"] = 279.57, ["Neon|Ride"] = 346.18, ["Mega"] = 2933.77, ["Mega|Fly|Ride"] = 3077.17}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 11.43, ["Fly"] = 49.88, ["Ride"] = 27.43, ["Fly|Ride"] = 525, ["Neon"] = 138.13, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 258.27, ["Mega"] = 2653.73, ["Mega|Ride"] = 571.14, ["Mega|Fly|Ride"] = 616.13}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 29.67, ["Fly"] = 99.75, ["Ride"] = 49.88, ["Fly|Ride"] = 111.57, ["Neon"] = 385.59, ["Neon|Ride"] = 155.09, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 1681.32, ["Mega|Fly|Ride"] = 861.9}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 66.03, ["Ride"] = 155.76, ["Fly|Ride"] = 196.88, ["Neon"] = 209.99, ["Neon|Ride"] = 419.12, ["Neon|Fly|Ride"] = 525, ["Mega"] = 1101.38, ["Mega|Ride"] = 1253.14, ["Mega|Fly|Ride"] = 1201.81}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 26.25, ["Fly"] = 62.3, ["Ride"] = 45.94, ["Fly|Ride"] = 137.17, ["Neon"] = 170.8, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 408.19, ["Mega"] = 698.87, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 957.68}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 45.94, ["Fly"] = 125.74, ["Ride"] = 56.44, ["Fly|Ride"] = 160.31, ["Neon"] = 91.88, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 307.97, ["Mega|Ride"] = 2493.75, ["Mega|Fly|Ride"] = 937.77}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 3.94, ["Fly"] = 28.49, ["Ride"] = 17.32, ["Fly|Ride"] = 52.39, ["Neon"] = 28.32, ["Neon|Fly"] = 44.63, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 80.99, ["Mega"] = 128.63, ["Mega|Fly"] = 419.12, ["Mega|Ride"] = 170.57, ["Mega|Fly|Ride"] = 221.82}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 320.31, ["Ride"] = 291.38, ["Fly|Ride"] = 370.89, ["Neon"] = 1050, ["Neon|Ride"] = 2933.77, ["Neon|Fly|Ride"] = 1816.84, ["Mega"] = 10477.68, ["Mega|Fly|Ride"] = 5384.75}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 32.82, ["Ride"] = 33.54, ["Neon"] = 237.86, ["Neon|Ride"] = 209.57, ["Neon|Fly|Ride"] = 391.88, ["Mega"] = 824.61, ["Mega|Fly|Ride"] = 737.65}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 3.94, ["Fly"] = 37.94, ["Ride"] = 20.93, ["Fly|Ride"] = 41.42, ["Neon"] = 56.59, ["Neon|Ride"] = 46.17, ["Neon|Fly|Ride"] = 105, ["Mega|Ride"] = 559.53, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 102.38, ["Fly"] = 5250, ["Ride"] = 119.18, ["Fly|Ride"] = 152.98, ["Neon"] = 357, ["Neon|Fly"] = 419.12, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 323.09, ["Mega"] = 6113.93, ["Mega|Ride"] = 3077.17, ["Mega|Fly|Ride"] = 1491}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 13.13, ["Ride"] = 31.13, ["Fly|Ride"] = 118.13, ["Neon"] = 154.63, ["Neon|Ride"] = 104.79, ["Neon|Fly|Ride"] = 207.38, ["Mega"] = 695.73, ["Mega|Ride"] = 349.97, ["Mega|Fly|Ride"] = 419.12}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 203.44, ["Fly"] = 354.15, ["Ride"] = 226.1, ["Fly|Ride"] = 216.57, ["Neon"] = 692.34, ["Neon|Ride"] = 769.64, ["Neon|Fly|Ride"] = 837.38, ["Mega"] = 6286.62, ["Mega|Fly|Ride"] = 2556.57}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 27.56}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.82, ["Fly"] = 31.39, ["Ride"] = 33.47, ["Fly|Ride"] = 61.82, ["Neon"] = 18.38, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 59.73, ["Neon|Fly|Ride"] = 140.42, ["Mega"] = 118.13, ["Mega|Fly"] = 224.24, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 203.28}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 557.37, ["Ride"] = 631.08, ["Fly|Ride"] = 646.07, ["Neon"] = 3045.88, ["Neon|Ride"] = 3632.63, ["Neon|Fly|Ride"] = 2966.25, ["Mega"] = 11875.41, ["Mega|Ride"] = 51920.47, ["Mega|Fly|Ride"] = 9779.88}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 8.35, ["Fly"] = 45, ["Ride"] = 28.88, ["Fly|Ride"] = 83.83, ["Neon"] = 56.59, ["Neon|Fly"] = 140.42, ["Neon|Ride"] = 102.1, ["Neon|Fly|Ride"] = 174.99, ["Mega"] = 787.5, ["Mega|Ride"] = 597.23, ["Mega|Fly|Ride"] = 661.15}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 103.69, ["Ride"] = 147, ["Fly|Ride"] = 190.32, ["Neon"] = 574.19, ["Neon|Ride"] = 514.5, ["Neon|Fly|Ride"] = 691.55, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 2538.35}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 62.3}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 24.34, ["Ride"] = 74.41, ["Fly|Ride"] = 196.88, ["Neon"] = 86.56, ["Neon|Ride"] = 209.57, ["Neon|Fly|Ride"] = 271.83, ["Mega"] = 594.09, ["Mega|Ride"] = 616.13, ["Mega|Fly|Ride"] = 723.43}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.2}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 137.16, ["Ride"] = 166.57, ["Neon"] = 559.53, ["Neon|Ride"] = 577.5, ["Neon|Fly|Ride"] = 656.25, ["Mega|Fly|Ride"] = 2352}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 141.75, ["Ride"] = 123.44, ["Fly|Ride"] = 196.88, ["Neon"] = 523.29, ["Neon|Ride"] = 408.19, ["Neon|Fly|Ride"] = 483, ["Mega|Ride"] = 1712.06, ["Mega|Fly|Ride"] = 1468.69}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 57.75}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 62.4, ["Fly"] = 93.49, ["Ride"] = 52.49, ["Fly|Ride"] = 65.63, ["Neon|Ride"] = 314.34, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 4191.09, ["Mega|Fly|Ride"] = 1258.69}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 6.24, ["Ride"] = 53.74, ["Fly|Ride"] = 131.25, ["Neon"] = 39.38, ["Neon|Ride"] = 155.09, ["Mega"] = 183.01, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 251.48, ["Mega|Fly|Ride"] = 329.02}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 339.56, ["Fly"] = 578.82, ["Ride"] = 341.25, ["Fly|Ride"] = 341.25, ["Neon|Ride"] = 1957.25, ["Neon|Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 4769.78}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 68.25, ["Fly"] = 99.75, ["Ride"] = 85.32, ["Fly|Ride"] = 147, ["Neon"] = 292.35, ["Neon|Fly"] = 314.34, ["Neon|Ride"] = 293.4, ["Neon|Fly|Ride"] = 413.88, ["Mega|Fly|Ride"] = 1550.7}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 7124.83, ["Ride"] = 3018.75, ["Fly|Ride"] = 3429.99, ["Neon|Fly|Ride"] = 13968.84}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 33.66, ["Fly"] = 224.24, ["Ride"] = 56.18, ["Fly|Ride"] = 124.61, ["Neon"] = 340.4, ["Neon|Ride"] = 276.94, ["Neon|Fly|Ride"] = 224.24, ["Mega"] = 1885.99, ["Mega|Ride"] = 1885.99, ["Mega|Fly|Ride"] = 1327.53}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 72.19, ["Ride"] = 70.22, ["Fly|Ride"] = 140.39, ["Neon"] = 393.75, ["Neon|Ride"] = 266.57, ["Neon|Fly|Ride"] = 419.12, ["Mega"] = 6286.62, ["Mega|Ride"] = 1846.07, ["Mega|Fly|Ride"] = 1521.37}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 30.85, ["Fly"] = 74.4, ["Ride"] = 43.32, ["Fly|Ride"] = 115.5, ["Neon"] = 138.49, ["Neon|Fly"] = 273, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 203.44, ["Mega"] = 2598.75, ["Mega|Fly|Ride"] = 627.38}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 8.32}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 62.71, ["Ride"] = 76.13, ["Fly|Ride"] = 105, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 502.94, ["Mega|Fly|Ride"] = 1692.63}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 36.75}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 215.71, ["Ride"] = 308.01, ["Fly|Ride"] = 341.25, ["Neon|Ride"] = 838.23, ["Neon|Fly|Ride"] = 2095.55}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 656.25, ["Ride"] = 753.38, ["Fly|Ride"] = 656.25, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2198.44, ["Mega|Fly|Ride"] = 12307.47}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 4.62}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 22.32, ["Fly"] = 52.5, ["Ride"] = 35.38, ["Fly|Ride"] = 62.31, ["Neon"] = 318.53, ["Neon|Fly"] = 308.11, ["Neon|Ride"] = 196.86, ["Neon|Fly|Ride"] = 183.75, ["Mega|Ride"] = 649.63, ["Mega|Fly|Ride"] = 685.33}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 9.08}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5040, ["Fly"] = 4593.75, ["Fly|Ride"] = 5144.99, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 40374.67}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 6.57, ["Ride"] = 24.68, ["Fly|Ride"] = 60.78, ["Neon"] = 59.07, ["Neon|Ride"] = 108.94, ["Neon|Fly|Ride"] = 208.78, ["Mega"] = 308.07, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 14.44, ["Fly"] = 78.6, ["Ride"] = 39.38, ["Fly|Ride"] = 97.13, ["Neon"] = 140.42, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 698.87, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 540.67}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 73.24, ["Ride"] = 128.63, ["Fly|Ride"] = 125.73, ["Neon|Fly|Ride"] = 420}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 9.93, ["Ride"] = 38.06, ["Fly|Ride"] = 139.65, ["Neon"] = 78.75, ["Neon|Ride"] = 85.4, ["Neon|Fly|Ride"] = 305.96, ["Mega"] = 360.45, ["Mega|Ride"] = 553.24, ["Mega|Fly|Ride"] = 1019.82}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 3074.16, ["Fly"] = 2310, ["Ride"] = 2592.23, ["Fly|Ride"] = 2100, ["Neon|Fly|Ride"] = 4331.25, ["Mega|Fly|Ride"] = 11812.5}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 32412.69, ["Ride"] = 23537.07, ["Fly|Ride"] = 22968.75, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 60072.69, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 195583.56}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 19.69, ["Fly"] = 393.75, ["Ride"] = 57.75, ["Fly|Ride"] = 85.39, ["Neon"] = 108.42, ["Neon|Ride"] = 178.38, ["Neon|Fly|Ride"] = 419.12, ["Mega"] = 1117.98, ["Mega|Ride"] = 784.6, ["Mega|Fly|Ride"] = 950.34}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 2.63, ["Fly"] = 41.86, ["Ride"] = 31.49, ["Fly|Ride"] = 112.11, ["Neon"] = 13.13, ["Neon|Fly"] = 129.34, ["Neon|Ride"] = 35.63, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 99.75, ["Mega|Ride"] = 193.02, ["Mega|Fly|Ride"] = 246.75}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 24.94}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 4.7, ["Ride"] = 38.07, ["Fly|Ride"] = 279.74, ["Neon"] = 45.8, ["Neon|Ride"] = 124.36, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 217.95, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 402.36}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 708.75, ["Ride"] = 836.04, ["Fly|Ride"] = 787.5, ["Neon|Ride"] = 2754.3, ["Neon|Fly|Ride"] = 2642.07, ["Mega"] = 11176.54, ["Mega|Fly|Ride"] = 10853.84}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 912.18, ["Fly"] = 1076.25, ["Ride"] = 1023.75, ["Fly|Ride"] = 1050, ["Neon|Ride"] = 2923.92, ["Neon|Fly|Ride"] = 3863.13, ["Mega|Fly|Ride"] = 15363.42}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 19.67, ["Fly"] = 56.59, ["Ride"] = 51.18, ["Fly|Ride"] = 83.83, ["Neon"] = 200.68, ["Neon|Ride"] = 154.63, ["Neon|Fly|Ride"] = 209.57, ["Mega|Fly|Ride"] = 698.87}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 34.01}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 52.38, ["Fly"] = 99.22, ["Ride"] = 70.2, ["Fly|Ride"] = 140.39, ["Neon|Ride"] = 461.56, ["Neon|Fly|Ride"] = 380.63, ["Mega|Fly|Ride"] = 1487.84}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 82.79, ["Fly"] = 209.57, ["Ride"] = 112.49, ["Fly|Ride"] = 170.63, ["Neon"] = 441, ["Neon|Ride"] = 559.58, ["Neon|Fly|Ride"] = 15385.73, ["Mega"] = 2111.5, ["Mega|Ride"] = 1676.45, ["Mega|Fly|Ride"] = 1649.2}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 3.93, ["Fly"] = 43.31, ["Ride"] = 23.07, ["Fly|Ride"] = 54.49, ["Neon"] = 30.01, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 559.53, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 400.26}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 69.54, ["Fly"] = 93.19, ["Ride"] = 65.63, ["Fly|Ride"] = 126.67, ["Neon|Ride"] = 362.25, ["Neon|Fly|Ride"] = 283.5, ["Mega|Fly|Ride"] = 1153.69}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 3.68, ["Fly"] = 45.94, ["Ride"] = 31.16, ["Fly|Ride"] = 69.91, ["Neon"] = 24.94, ["Neon|Fly"] = 266.14, ["Neon|Ride"] = 91.65, ["Neon|Fly|Ride"] = 559.53, ["Mega"] = 212.1, ["Mega|Fly"] = 1117.98, ["Mega|Ride"] = 283.84, ["Mega|Fly|Ride"] = 392.44}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 15.63, ["Fly"] = 65.63, ["Ride"] = 39.38, ["Fly|Ride"] = 104.78, ["Neon"] = 262.5, ["Neon|Ride"] = 154.63, ["Neon|Fly|Ride"] = 137.16, ["Mega"] = 1050, ["Mega|Fly|Ride"] = 620.29}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 35.44, ["Ride"] = 291.38, ["Fly|Ride"] = 272.4, ["Neon"] = 178.14, ["Neon|Ride"] = 341.56, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 2095.55, ["Mega|Fly|Ride"] = 838.23}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 15.64, ["Fly"] = 85.6, ["Ride"] = 35.64, ["Fly|Ride"] = 82.69, ["Neon"] = 96.41, ["Neon|Ride"] = 123.65, ["Neon|Fly|Ride"] = 167.66, ["Mega"] = 628.67, ["Mega|Ride"] = 908.42, ["Mega|Fly|Ride"] = 923.05}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6921.11, ["Fly"] = 5448.4, ["Ride"] = 5250, ["Fly|Ride"] = 4922.7, ["Neon"] = 30736.26, ["Neon|Fly|Ride"] = 25705.94, ["Mega|Fly|Ride"] = 97777.63}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 223.13, ["Fly"] = 250.43, ["Ride"] = 246.74, ["Fly|Ride"] = 292.69, ["Neon|Fly|Ride"] = 655.05, ["Mega|Fly|Ride"] = 2057.83}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 26.24, ["Fly"] = 89.57, ["Ride"] = 44.3, ["Fly|Ride"] = 119.44, ["Neon"] = 70.22, ["Neon|Fly"] = 140.42, ["Neon|Ride"] = 93.56, ["Neon|Fly|Ride"] = 200.82, ["Mega"] = 301.88, ["Mega|Fly"] = 510.27, ["Mega|Ride"] = 290.07, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 3.28, ["Fly"] = 40.39, ["Ride"] = 21, ["Fly|Ride"] = 98.49, ["Neon"] = 15.75, ["Neon|Ride"] = 52.5, ["Mega"] = 140.44}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 26.25, ["Fly"] = 5228.9, ["Ride"] = 46.25, ["Fly|Ride"] = 140.39, ["Neon"] = 118.44, ["Neon|Fly"] = 331.17, ["Neon|Ride"] = 174.57, ["Neon|Fly|Ride"] = 229.69, ["Mega"] = 419.12, ["Mega|Ride"] = 448.02, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 18571.88, ["Ride"] = 11519.82, ["Fly|Ride"] = 11615.63, ["Neon|Fly|Ride"] = 23625}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 129.94, ["Ride"] = 178.5, ["Fly|Ride"] = 356.21, ["Neon"] = 2095.55, ["Neon|Fly|Ride"] = 838.23, ["Mega|Fly|Ride"] = 4615.17}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 42.84, ["Fly"] = 459.38, ["Ride"] = 49.59, ["Fly|Ride"] = 100.59, ["Neon|Fly"] = 461.56, ["Neon|Ride"] = 264.06, ["Neon|Fly|Ride"] = 341.25, ["Mega|Fly|Ride"] = 1113.79}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 13.13, ["Ride"] = 35.64, ["Fly|Ride"] = 57.75, ["Neon"] = 61.87, ["Neon|Ride"] = 106.88, ["Neon|Fly|Ride"] = 139.36, ["Mega"] = 2514.65, ["Mega|Ride"] = 492.19, ["Mega|Fly|Ride"] = 1047.78}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 380.63, ["Fly"] = 838.23, ["Ride"] = 426.57, ["Fly|Ride"] = 459.38, ["Neon"] = 1537.09, ["Neon|Ride"] = 1323, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 5603.48}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 3.89, ["Fly"] = 46.16, ["Ride"] = 42, ["Fly|Ride"] = 140.39, ["Neon"] = 19.69, ["Neon|Ride"] = 98.51, ["Neon|Fly|Ride"] = 139.13, ["Mega"] = 105, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 178.5, ["Mega|Fly|Ride"] = 251.45}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 84, ["Fly"] = 157.5, ["Ride"] = 128.63, ["Fly|Ride"] = 196.88, ["Neon"] = 490.83, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 451.6, ["Neon|Fly|Ride"] = 459.38, ["Mega|Fly|Ride"] = 1809.51}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 14.44, ["Fly"] = 14.15, ["Ride"] = 18.68, ["Fly|Ride"] = 35.4, ["Neon|Ride"] = 101.43, ["Neon|Fly|Ride"] = 81.38, ["Mega"] = 2514.65, ["Mega|Fly|Ride"] = 570}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 7.88}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 64.32, ["Ride"] = 112.11, ["Fly|Ride"] = 525, ["Neon"] = 393.75, ["Neon|Fly"] = 1676.45, ["Neon|Ride"] = 419.12, ["Neon|Fly|Ride"] = 418.07, ["Mega|Ride"] = 1384.57, ["Mega|Fly|Ride"] = 1523.02}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 10.5, ["Ride"] = 31.12, ["Fly|Ride"] = 77.55, ["Neon"] = 82.79, ["Neon|Ride"] = 112.12, ["Neon|Fly|Ride"] = 231.57, ["Mega|Fly|Ride"] = 921.78}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 16.56}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 29.8, ["Fly"] = 210, ["Ride"] = 78.6, ["Fly|Ride"] = 301.88, ["Neon"] = 133.88, ["Neon|Ride"] = 116.31, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 690.5, ["Mega|Ride"] = 698.87, ["Mega|Fly|Ride"] = 656.24}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.83, ["Ride"] = 31.16, ["Fly|Ride"] = 118.13, ["Neon"] = 18.87, ["Neon|Ride"] = 137.28, ["Neon|Fly|Ride"] = 321.57, ["Mega"] = 137.28, ["Mega|Ride"] = 279.78, ["Mega|Fly|Ride"] = 405.5}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 11.82, ["Fly"] = 56.59, ["Ride"] = 31.86, ["Fly|Ride"] = 91.87, ["Neon"] = 140.42, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 152.99, ["Mega|Ride"] = 616.13, ["Mega|Fly|Ride"] = 689.45}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 393.75, ["Fly"] = 437.75, ["Ride"] = 262.5, ["Fly|Ride"] = 387.19, ["Neon|Fly|Ride"] = 1670.16, ["Mega|Fly|Ride"] = 8801.26}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 37.91, ["Ride"] = 103.73, ["Fly|Ride"] = 136.5, ["Neon"] = 209.57, ["Neon|Ride"] = 209.57, ["Neon|Fly|Ride"] = 335.3, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 836.13}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 53.82, ["Ride"] = 52.5, ["Fly|Ride"] = 91.88, ["Neon"] = 838.23, ["Neon|Ride"] = 838.23, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1336.97}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 15.74, ["Fly"] = 78.75, ["Ride"] = 52.5, ["Fly|Ride"] = 131.23, ["Neon"] = 94.5, ["Neon|Ride"] = 123.47, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 262.5, ["Mega|Ride"] = 336, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 11073.77, ["Ride"] = 11075.17, ["Fly|Ride"] = 8136.19, ["Neon|Fly|Ride"] = 16864.32, ["Mega|Fly|Ride"] = 39372.9}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1988.44, ["Ride"] = 2034.38, ["Fly|Ride"] = 2034.38, ["Neon"] = 4593.75, ["Neon|Fly|Ride"] = 4462.5, ["Mega|Fly|Ride"] = 18460.62}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 417.03, ["Ride"] = 419.12, ["Fly|Ride"] = 616.07, ["Neon"] = 1885.99, ["Neon|Ride"] = 1384.69, ["Neon|Fly|Ride"] = 1414.5, ["Mega"] = 16764.28, ["Mega|Fly|Ride"] = 6391.4}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 11.82, ["Fly"] = 26.25, ["Ride"] = 19.69, ["Fly|Ride"] = 50.77, ["Neon"] = 125.74, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 167.66, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 3.89, ["Fly"] = 131.25, ["Ride"] = 61.69, ["Fly|Ride"] = 153.57, ["Neon"] = 24.86, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 118.13, ["Mega|Ride"] = 207.47, ["Mega|Fly|Ride"] = 232.32}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 39.38, ["Fly"] = 42, ["Ride"] = 53.82, ["Fly|Ride"] = 93.56, ["Neon"] = 125.74, ["Neon|Fly"] = 138.49, ["Neon|Ride"] = 167.66, ["Neon|Fly|Ride"] = 154.34, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.41, ["Fly"] = 25.36, ["Ride"] = 15.73, ["Fly|Ride"] = 34.13, ["Neon"] = 25.4, ["Neon|Ride"] = 36.68, ["Neon|Fly|Ride"] = 97.13, ["Mega"] = 229.62, ["Mega|Ride"] = 220.05, ["Mega|Fly|Ride"] = 255.94}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 308.01, ["Fly"] = 317.63, ["Ride"] = 282.19, ["Fly|Ride"] = 295.32, ["Neon"] = 1152.56, ["Neon|Ride"] = 1384.66, ["Neon|Fly|Ride"] = 1252.1, ["Mega|Fly|Ride"] = 3516.32}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 26.14, ["Fly"] = 56.59, ["Ride"] = 45.94, ["Fly|Ride"] = 85.32, ["Neon"] = 105, ["Neon|Fly"] = 461.56, ["Neon|Ride"] = 140.42, ["Neon|Fly|Ride"] = 236.25, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 838.23}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 11.8, ["Fly"] = 19.9, ["Ride"] = 18.38, ["Fly|Ride"] = 46.11, ["Neon"] = 62.33, ["Neon|Fly"] = 136.5, ["Neon|Ride"] = 108.48, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 523.89, ["Mega|Ride"] = 577.34, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 249.38, ["Fly"] = 787.5, ["Ride"] = 465.94, ["Fly|Ride"] = 680.98, ["Mega|Fly|Ride"] = 8103.44}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1047.37, ["Ride"] = 1255.08, ["Fly|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 17684.23}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 84, ["Fly"] = 107.93, ["Ride"] = 87.94, ["Fly|Ride"] = 90.57, ["Neon"] = 498.75, ["Neon|Ride"] = 416.06, ["Neon|Fly|Ride"] = 525, ["Mega|Fly|Ride"] = 1955.15}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 207.27, ["Fly"] = 251.48, ["Ride"] = 223.95, ["Fly|Ride"] = 196.88, ["Neon"] = 1077.72, ["Neon|Ride"] = 769.64, ["Neon|Fly|Ride"] = 585.57, ["Mega|Ride"] = 7290.94, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 19.69, ["Ride"] = 56.59, ["Neon"] = 261.95, ["Neon|Ride"] = 279.78, ["Neon|Fly|Ride"] = 838.23, ["Mega|Ride"] = 923.05, ["Mega|Fly|Ride"] = 1032.65}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 151.13, ["Ride"] = 576.21, ["Fly|Ride"] = 597.19, ["Neon"] = 1537.09, ["Neon|Ride"] = 1257.33, ["Neon|Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 2990.35}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 1575, ["Fly"] = 2514.65, ["Ride"] = 2026.4, ["Fly|Ride"] = 1967.44, ["Mega|Fly|Ride"] = 48197.3}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 83.84, ["Ride"] = 57.75, ["Fly|Ride"] = 260.74, ["Neon"] = 279.78, ["Neon|Ride"] = 419.12, ["Neon|Fly|Ride"] = 229.69, ["Mega"] = 1957.25, ["Mega|Ride"] = 2305.1, ["Mega|Fly|Ride"] = 1961.44}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 630, ["Fly"] = 675.94, ["Ride"] = 557.82, ["Fly|Ride"] = 586.03, ["Neon|Ride"] = 1454.31, ["Neon|Fly|Ride"] = 1245.62, ["Mega|Fly|Ride"] = 2782.5}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 42, ["Fly"] = 62.89, ["Ride"] = 47.25, ["Fly|Ride"] = 118.39, ["Neon"] = 208.52, ["Neon|Ride"] = 161.56, ["Neon|Fly|Ride"] = 264.06, ["Mega|Fly|Ride"] = 895.85}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.15, ["Fly"] = 21, ["Ride"] = 23.62, ["Fly|Ride"] = 44.01, ["Neon"] = 19.62, ["Neon|Fly"] = 52.47, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 122.96, ["Mega|Ride"] = 138.32, ["Mega|Fly|Ride"] = 215.25}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 37.4, ["Ride"] = 62.3, ["Fly|Ride"] = 252, ["Neon"] = 698.87, ["Neon|Ride"] = 769.08, ["Mega"] = 1384.57, ["Mega|Ride"] = 1117.98, ["Mega|Fly|Ride"] = 6985.49}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 523.69, ["Fly"] = 1131.62, ["Ride"] = 551.25, ["Fly|Ride"] = 624.75, ["Neon"] = 2307.76, ["Neon|Ride"] = 2235.95, ["Neon|Fly|Ride"] = 1907.07, ["Mega|Fly|Ride"] = 6958.24}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 459.38, ["Ride"] = 603.75, ["Fly|Ride"] = 656.25, ["Neon"] = 8382.14, ["Neon|Ride"] = 4068.75, ["Neon|Fly|Ride"] = 2441.25, ["Mega|Fly|Ride"] = 17777.48}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 12.58, ["Fly"] = 32.82, ["Ride"] = 23.13, ["Fly|Ride"] = 40.68, ["Neon"] = 209.57, ["Neon|Ride"] = 86.56, ["Neon|Fly|Ride"] = 132.57, ["Mega|Fly|Ride"] = 615.44}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 7.83, ["Ride"] = 22.32, ["Fly|Ride"] = 77.44, ["Neon"] = 52.49, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 182.33, ["Mega"] = 458.93, ["Mega|Ride"] = 458.93, ["Mega|Fly|Ride"] = 476.76}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 3.93, ["Ride"] = 26.25, ["Fly|Ride"] = 90.12, ["Neon"] = 18.87, ["Neon|Fly"] = 110.5, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 279.77, ["Mega"] = 138.31, ["Mega|Ride"] = 186.38, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 31.5, ["Fly"] = 56.59, ["Ride"] = 41.97, ["Fly|Ride"] = 103.73, ["Neon"] = 249.25, ["Neon|Ride"] = 209.57, ["Neon|Fly|Ride"] = 196.88, ["Mega|Fly|Ride"] = 720.5}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 24.94, ["Ride"] = 86.63, ["Fly|Ride"] = 616.07, ["Neon"] = 279.78, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1047.78, ["Mega|Ride"] = 1047.78, ["Mega|Fly|Ride"] = 1255.24}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 15.69, ["Fly"] = 57.11, ["Ride"] = 32.82, ["Fly|Ride"] = 91.17, ["Neon"] = 38.07, ["Neon|Ride"] = 92.93, ["Neon|Fly|Ride"] = 140.42, ["Mega|Ride"] = 349.97, ["Mega|Fly|Ride"] = 472.56}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 29.93, ["Fly"] = 83.84, ["Ride"] = 36.75, ["Fly|Ride"] = 92.22, ["Neon"] = 347.88, ["Neon|Ride"] = 182.36, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 2100, ["Mega|Fly|Ride"] = 1011.72}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.93, ["Fly"] = 38.07, ["Ride"] = 17.19, ["Fly|Ride"] = 40.69, ["Neon"] = 34.29, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 1676.45, ["Mega|Ride"] = 461.53, ["Mega|Fly|Ride"] = 397.13}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 3.93, ["Fly"] = 65.63, ["Ride"] = 26.18, ["Fly|Ride"] = 81.9, ["Neon"] = 19.47, ["Neon|Fly"] = 154.63, ["Neon|Ride"] = 41.68, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 416.07, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 35.44, ["Fly"] = 79.15, ["Ride"] = 53.82, ["Fly|Ride"] = 90.57, ["Neon"] = 417.03, ["Neon|Ride"] = 230.78, ["Neon|Fly|Ride"] = 216.57, ["Mega|Fly|Ride"] = 852.9}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 2386.13, ["Fly"] = 1837.5, ["Ride"] = 2034.38, ["Fly|Ride"] = 1938.57, ["Neon|Fly|Ride"] = 3937.5, ["Mega|Fly|Ride"] = 14437.5}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 462, ["Fly"] = 577.34, ["Ride"] = 502.88, ["Fly|Ride"] = 508.78, ["Neon"] = 3077.4, ["Neon|Ride"] = 2375.3, ["Neon|Fly|Ride"] = 1706.25, ["Mega|Fly|Ride"] = 7875}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 296.65, ["Ride"] = 315, ["Fly|Ride"] = 420, ["Neon"] = 1571.67, ["Neon|Ride"] = 1571.67, ["Neon|Fly|Ride"] = 1986.57, ["Mega|Fly|Ride"] = 5775}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 34.92}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 26.24, ["Fly"] = 65.63, ["Ride"] = 57.75, ["Fly|Ride"] = 78.75, ["Neon"] = 288.75, ["Neon|Ride"] = 266.14, ["Neon|Fly|Ride"] = 418.98, ["Mega|Ride"] = 1466.9, ["Mega|Fly|Ride"] = 1231.11}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 30736.26, ["Fly"] = 23625, ["Ride"] = 34609.88, ["Fly|Ride"] = 15354.94, ["Neon|Fly|Ride"] = 33528.56, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 249.38, ["Fly"] = 472.56, ["Ride"] = 246.74, ["Fly|Ride"] = 286.78, ["Neon"] = 792.12, ["Neon|Fly"] = 1086.96, ["Neon|Ride"] = 838.32, ["Neon|Fly|Ride"] = 623.88, ["Mega"] = 3479.65, ["Mega|Ride"] = 4919.28, ["Mega|Fly|Ride"] = 2425.5}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 94.5, ["Ride"] = 124.69, ["Fly|Ride"] = 257.25, ["Neon|Fly|Ride"] = 1692.63, ["Mega|Fly|Ride"] = 4051.72}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 102.38, ["Ride"] = 112.11, ["Fly|Ride"] = 169.32, ["Neon|Ride"] = 523.89, ["Neon|Fly|Ride"] = 559.53, ["Mega"] = 13970.94, ["Mega|Fly|Ride"] = 3124.89}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 10.5, ["Fly"] = 94.5, ["Ride"] = 28.32, ["Fly|Ride"] = 83.83, ["Neon|Ride"] = 135.19, ["Neon|Fly|Ride"] = 291.38, ["Mega"] = 616.13, ["Mega|Ride"] = 595.37}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 3281.25, ["Ride"] = 3353.44, ["Fly|Ride"] = 4254.36, ["Neon|Fly|Ride"] = 16485.58}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 26.13, ["Fly"] = 140.42, ["Ride"] = 32.82, ["Fly|Ride"] = 65.63, ["Neon"] = 131.25, ["Neon|Ride"] = 138.49, ["Neon|Fly|Ride"] = 168, ["Mega|Fly|Ride"] = 624.75}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 33.66, ["Fly"] = 51.35, ["Ride"] = 49.7, ["Fly|Ride"] = 104.95, ["Neon"] = 147.71, ["Neon|Ride"] = 278.73, ["Neon|Fly|Ride"] = 217.95, ["Mega|Fly|Ride"] = 923.09}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 519.74, ["Fly"] = 656.25, ["Ride"] = 563.06, ["Fly|Ride"] = 702.19, ["Neon"] = 1676.63, ["Neon|Ride"] = 1610.44, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Ride"] = 8906.03, ["Mega|Fly|Ride"] = 3937.5}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 15.73, ["Fly"] = 23.63, ["Ride"] = 24.94, ["Fly|Ride"] = 67.99, ["Neon|Fly"] = 188.61, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 125.95, ["Mega"] = 698.87, ["Mega|Fly|Ride"] = 461.64}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 12.48, ["Ride"] = 59.07, ["Fly|Ride"] = 136.2, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 131.25}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 103.69, ["Fly"] = 140.42, ["Ride"] = 115.5, ["Fly|Ride"] = 167.64, ["Neon"] = 698.87, ["Neon|Ride"] = 616.19, ["Neon|Fly|Ride"] = 551.25, ["Mega|Ride"] = 2355.4}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 23.63, ["Fly"] = 91.88, ["Ride"] = 77.16, ["Fly|Ride"] = 136.2, ["Neon"] = 87.94, ["Neon|Ride"] = 108.48, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 207.38, ["Mega|Fly"] = 807.19, ["Mega|Ride"] = 187.03, ["Mega|Fly|Ride"] = 444.29}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3821.32, ["Ride"] = 3281.25, ["Fly|Ride"] = 3148.69, ["Neon"] = 12308.36, ["Neon|Ride"] = 16925.01, ["Neon|Fly|Ride"] = 7290.94, ["Mega"] = 62866.04, ["Mega|Fly|Ride"] = 27940.82}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 40.69, ["Fly"] = 210, ["Ride"] = 77.31, ["Fly|Ride"] = 104.78, ["Neon"] = 154.63, ["Neon|Ride"] = 207.47, ["Neon|Fly|Ride"] = 367.5, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 7334.39, ["Ride"] = 8305.33, ["Fly|Ride"] = 5629.32, ["Neon|Fly|Ride"] = 15748.69, ["Mega|Fly|Ride"] = 62796.89}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.63, ["Fly"] = 19.69, ["Ride"] = 18.38, ["Fly|Ride"] = 34.13, ["Neon"] = 20.97, ["Neon|Fly"] = 104.79, ["Neon|Ride"] = 33.54, ["Neon|Fly|Ride"] = 77.33, ["Mega"] = 140.42, ["Mega|Fly|Ride"] = 224.24}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 13.1, ["Fly"] = 35.44, ["Ride"] = 31.45, ["Fly|Ride"] = 69.57, ["Neon"] = 140.42, ["Neon|Ride"] = 279.78, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 1401.1, ["Mega|Fly|Ride"] = 920.74}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 13.13, ["Ride"] = 28.88, ["Fly|Ride"] = 140.39, ["Neon"] = 63, ["Neon|Ride"] = 153.57, ["Neon|Fly|Ride"] = 188.61, ["Mega|Ride"] = 698.87, ["Mega|Fly|Ride"] = 838.23}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 39.38, ["Fly"] = 56.59, ["Ride"] = 50.91, ["Fly|Ride"] = 77.32, ["Neon"] = 177.09, ["Neon|Ride"] = 179.18, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 840, ["Mega|Ride"] = 616.88, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 11.5, ["Fly"] = 30, ["Ride"] = 20.78, ["Fly|Ride"] = 39.22, ["Neon"] = 54.5, ["Neon|Ride"] = 96.41, ["Neon|Fly|Ride"] = 138.32, ["Mega"] = 1119.03, ["Mega|Fly|Ride"] = 616.13}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 7998.48}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2811.38}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 23.55}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 313.29, ["Fly"] = 559.53, ["Ride"] = 229.69, ["Fly|Ride"] = 656.25, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 1788.55, ["Mega|Fly|Ride"] = 5588.8}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 19.69, ["Fly"] = 132.04, ["Ride"] = 52.5, ["Fly|Ride"] = 138.45, ["Neon"] = 200.15, ["Neon|Ride"] = 406.88, ["Mega|Ride"] = 627.63, ["Mega|Fly|Ride"] = 674.78}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 10.5}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 7.86, ["Neon"] = 98.51, ["Neon|Ride"] = 249.38}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2572.5}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 141.74, ["Ride"] = 108.46, ["Fly|Ride"] = 288.11, ["Neon"] = 733.46, ["Neon|Ride"] = 698.87, ["Neon|Fly|Ride"] = 838.23, ["Mega|Fly|Ride"] = 2040.02}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 109.81, ["Ride"] = 140.39, ["Fly|Ride"] = 419.07, ["Neon"] = 469.42, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 656.25, ["Mega|Ride"] = 1575, ["Mega|Fly|Ride"] = 1692.63}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 145.69, ["Fly"] = 279.78, ["Ride"] = 194.25, ["Fly|Ride"] = 199.5, ["Neon"] = 830.81, ["Neon|Ride"] = 775.36, ["Neon|Fly|Ride"] = 755.5, ["Mega|Fly|Ride"] = 2937.38}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1089.38, ["Fly"] = 2514.65, ["Ride"] = 1048.69, ["Fly|Ride"] = 1097.97, ["Neon|Fly|Ride"] = 4593.75, ["Mega|Fly|Ride"] = 20955.35}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 12.99, ["Fly"] = 81.75, ["Ride"] = 46.11, ["Fly|Ride"] = 78.75, ["Neon"] = 131.25, ["Neon|Ride"] = 140.42, ["Neon|Fly|Ride"] = 437.07, ["Mega"] = 923.05, ["Mega|Fly|Ride"] = 908.42}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 656.25, ["Fly"] = 2100, ["Ride"] = 682.5, ["Fly|Ride"] = 838.13, ["Neon|Fly|Ride"] = 4000.2}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 47.38}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 14.44, ["Fly"] = 144.38, ["Ride"] = 39.38, ["Fly|Ride"] = 98.44, ["Neon"] = 67.08, ["Neon|Ride"] = 154.63, ["Neon|Fly|Ride"] = 489.33, ["Mega"] = 393.75, ["Mega|Ride"] = 458.07, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 5.77, ["Fly"] = 346.06, ["Ride"] = 28.88, ["Fly|Ride"] = 91.88, ["Neon"] = 53.45, ["Neon|Ride"] = 98.51, ["Neon|Fly|Ride"] = 123.87, ["Mega|Ride"] = 389.79, ["Mega|Fly|Ride"] = 419.12}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 78.72}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 26.25, ["Ride"] = 26.25, ["Fly|Ride"] = 65.54, ["Neon"] = 177.19, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 278.73, ["Mega"] = 812.03, ["Mega|Ride"] = 838.23, ["Mega|Fly|Ride"] = 695.73}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 39.83, ["Fly"] = 39.38, ["Ride"] = 36.69, ["Fly|Ride"] = 64.97, ["Neon"] = 154.63, ["Neon|Fly"] = 240.02, ["Neon|Ride"] = 274.54, ["Neon|Fly|Ride"] = 274.32, ["Mega"] = 1395.63, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 5974.5, ["Fly"] = 11176.54, ["Ride"] = 6241.86, ["Fly|Ride"] = 5092.5, ["Neon|Fly|Ride"] = 9778.13, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 6.57, ["Fly"] = 79.65, ["Ride"] = 31.16, ["Fly|Ride"] = 98.58, ["Neon"] = 65.63, ["Neon|Fly"] = 119.45, ["Neon|Ride"] = 85.31, ["Neon|Fly|Ride"] = 276.93, ["Mega"] = 531.24, ["Mega|Ride"] = 385.39, ["Mega|Fly|Ride"] = 460.88}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 24.94}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 104.61, ["Fly"] = 370.93, ["Ride"] = 140.44, ["Fly|Ride"] = 245.17, ["Neon"] = 418.69, ["Neon|Ride"] = 433.13, ["Neon|Fly|Ride"] = 559.53, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 51.19, ["Fly"] = 183.75, ["Ride"] = 104.78, ["Fly|Ride"] = 168, ["Neon"] = 236.25, ["Neon|Ride"] = 380.63, ["Neon|Fly|Ride"] = 525, ["Mega|Ride"] = 1338.42, ["Mega|Fly|Ride"] = 1240.57}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 25.92, ["Fly"] = 70.86, ["Ride"] = 27.54, ["Fly|Ride"] = 74.82, ["Neon"] = 182.33, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 175.88, ["Mega|Fly|Ride"] = 533.02}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 6.27, ["Fly"] = 49.49, ["Ride"] = 22.32, ["Fly|Ride"] = 78.75, ["Neon"] = 20.72, ["Neon|Fly"] = 182.33, ["Neon|Ride"] = 41.99, ["Neon|Fly|Ride"] = 132.04, ["Mega"] = 118.13, ["Mega|Fly"] = 7034.11, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 247.21}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 6.56, ["Ride"] = 32.49, ["Fly|Ride"] = 98.49, ["Neon"] = 51.85, ["Neon|Ride"] = 91.82, ["Neon|Fly|Ride"] = 149.63, ["Mega"] = 315, ["Mega|Ride"] = 419.99, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 23.61, ["Fly"] = 27.54, ["Ride"] = 31.49, ["Fly|Ride"] = 56.44, ["Neon"] = 207.62, ["Neon|Fly"] = 209.57, ["Neon|Ride"] = 188.61, ["Neon|Fly|Ride"] = 131.25, ["Mega|Fly"] = 698.87, ["Mega|Fly|Ride"] = 586.77}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 250.69}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 27.26, ["Fly"] = 123.44, ["Ride"] = 103.85, ["Neon"] = 86.56, ["Mega"] = 488.25, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 896.44}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 137.82, ["Ride"] = 140.39, ["Fly|Ride"] = 262.49, ["Neon|Fly|Ride"] = 737.65}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 36.75, ["Ride"] = 69.37, ["Fly|Ride"] = 279.74, ["Neon"] = 249.38, ["Neon|Ride"] = 327.08, ["Neon|Fly|Ride"] = 525, ["Mega"] = 1128.75, ["Mega|Ride"] = 1692.63, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 656.25, ["Fly"] = 780.94, ["Ride"] = 754.69, ["Fly|Ride"] = 623.44, ["Neon|Ride"] = 2100, ["Neon|Fly|Ride"] = 2086.88, ["Mega|Fly|Ride"] = 8531.25}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 190.32, ["Ride"] = 346.5, ["Fly|Ride"] = 288.75, ["Neon"] = 1201.81, ["Neon|Ride"] = 1539.28, ["Neon|Fly|Ride"] = 1256.29, ["Mega"] = 8242.8, ["Mega|Ride"] = 4038.27, ["Mega|Fly|Ride"] = 3538.68}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 90.57}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 7.86, ["Fly"] = 23.09, ["Ride"] = 23.63, ["Fly|Ride"] = 45.94, ["Neon"] = 80.07, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 127.32, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 405.57}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 312.37, ["Fly"] = 597.23, ["Ride"] = 293.01, ["Fly|Ride"] = 431.82, ["Neon"] = 1257.33, ["Neon|Ride"] = 945, ["Neon|Fly|Ride"] = 981.75, ["Mega|Fly|Ride"] = 3232.22}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 13.13}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 90.45, ["Fly"] = 590.63, ["Ride"] = 157.5, ["Fly|Ride"] = 246.75, ["Neon"] = 444.93, ["Neon|Fly"] = 1397.74, ["Neon|Ride"] = 599.82, ["Neon|Fly|Ride"] = 577.5, ["Mega"] = 2794.4, ["Mega|Fly|Ride"] = 1705.2}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 156.19, ["Ride"] = 131.25, ["Fly|Ride"] = 214.59, ["Neon|Ride"] = 997.5}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 5.1, ["Ride"] = 38.85, ["Fly|Ride"] = 123.45, ["Neon"] = 18.69, ["Neon|Ride"] = 48.21, ["Neon|Fly|Ride"] = 167.66, ["Mega"] = 195.96, ["Mega|Ride"] = 202.08, ["Mega|Fly|Ride"] = 398.18}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 14.23, ["Fly"] = 49.88, ["Ride"] = 35.44, ["Fly|Ride"] = 76.13, ["Neon"] = 98.51, ["Neon|Ride"] = 95.37, ["Neon|Fly|Ride"] = 195.96, ["Mega|Ride"] = 740.75, ["Mega|Fly|Ride"] = 769.6}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 22.32, ["Fly"] = 140.42, ["Ride"] = 56.59, ["Fly|Ride"] = 105, ["Neon"] = 133.07, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 279.78, ["Mega"] = 508.83, ["Mega|Ride"] = 489.33, ["Mega|Fly|Ride"] = 552.19}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 6.13, ["Fly"] = 335.3, ["Ride"] = 39.38, ["Fly|Ride"] = 105, ["Neon"] = 17.05, ["Neon|Ride"] = 51.18, ["Neon|Fly|Ride"] = 139.55, ["Mega"] = 116.82, ["Mega|Fly"] = 189, ["Mega|Ride"] = 156.19, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 322.84, ["Fly"] = 918.75, ["Ride"] = 341.25, ["Fly|Ride"] = 414.88, ["Neon"] = 1466.9, ["Neon|Ride"] = 1571.67, ["Neon|Fly|Ride"] = 1378.13}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 102.38, ["Fly"] = 1050, ["Ride"] = 128.43, ["Fly|Ride"] = 231.56, ["Neon"] = 433.12, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 525, ["Mega"] = 2794.4, ["Mega|Ride"] = 10058.58, ["Mega|Fly|Ride"] = 2165.63}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 65.63, ["Fly"] = 155.09, ["Ride"] = 96.92, ["Fly|Ride"] = 131.25, ["Neon|Ride"] = 391.88, ["Neon|Fly|Ride"] = 420, ["Mega|Fly|Ride"] = 1515.94}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 15.74, ["Ride"] = 58.24, ["Fly|Ride"] = 279.74, ["Neon"] = 209.57, ["Neon|Ride"] = 586.18, ["Neon|Fly|Ride"] = 489.33, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 15.73, ["Ride"] = 39.24, ["Fly|Ride"] = 102.38, ["Neon"] = 111.57, ["Neon|Ride"] = 115.23, ["Neon|Fly|Ride"] = 157.33, ["Mega"] = 481.99, ["Mega|Fly"] = 525, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 616.13}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.5, ["Fly"] = 41.92, ["Ride"] = 26.55, ["Fly|Ride"] = 77.32, ["Neon"] = 17.04, ["Neon|Ride"] = 39.83, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 121.55, ["Mega|Ride"] = 132.04, ["Mega|Fly|Ride"] = 213.94}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 1023.75, ["Ride"] = 945, ["Fly|Ride"] = 984.38, ["Neon|Fly"] = 2828.99, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2415, ["Mega"] = 11875.41, ["Mega|Fly|Ride"] = 7481.25}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 304.54, ["Ride"] = 262.5, ["Fly|Ride"] = 393.75, ["Neon"] = 1047.78, ["Neon|Ride"] = 1036.88, ["Neon|Fly|Ride"] = 1004.82, ["Mega"] = 10477.68, ["Mega|Ride"] = 5846.26, ["Mega|Fly|Ride"] = 3937.5}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 136.49, ["Ride"] = 132.01, ["Fly|Ride"] = 308.04, ["Neon"] = 384.57, ["Neon|Ride"] = 419.12, ["Neon|Fly|Ride"] = 377.21, ["Mega"] = 1640.63, ["Mega|Ride"] = 1676.45, ["Mega|Fly|Ride"] = 1537.28}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 197.11, ["Ride"] = 196.88, ["Fly|Ride"] = 288.75, ["Neon|Ride"] = 905.63, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 10477.68, ["Mega|Fly|Ride"] = 2931.67}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 20.99, ["Fly"] = 48.21, ["Ride"] = 35.97, ["Fly|Ride"] = 69.23, ["Neon"] = 154.45, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 157.5, ["Mega|Ride"] = 692.29, ["Mega|Fly|Ride"] = 769.6}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 286.76, ["Ride"] = 398.16, ["Neon"] = 1257.33, ["Neon|Ride"] = 1355.83, ["Neon|Fly|Ride"] = 1927.9, ["Mega"] = 5250, ["Mega|Fly|Ride"] = 4331.24}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 118.41, ["Fly"] = 126, ["Ride"] = 140.39, ["Neon|Ride"] = 279.78, ["Mega|Fly|Ride"] = 2000.69}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1246.88, ["Ride"] = 1383.06, ["Fly|Ride"] = 1312.49, ["Neon|Ride"] = 4051.72, ["Neon|Fly|Ride"] = 3923.17, ["Mega"] = 50292.83, ["Mega|Fly|Ride"] = 24448.61}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 15.73, ["Fly"] = 57.75, ["Ride"] = 39.51, ["Fly|Ride"] = 100.59, ["Neon"] = 35.33, ["Neon|Fly"] = 166.18, ["Neon|Ride"] = 59.05, ["Neon|Fly|Ride"] = 188.74, ["Mega"] = 196.88, ["Mega|Ride"] = 231, ["Mega|Fly|Ride"] = 559.53}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 64.78, ["Ride"] = 104.16, ["Fly|Ride"] = 125.73, ["Neon"] = 315, ["Neon|Ride"] = 316.32, ["Neon|Fly|Ride"] = 438.45, ["Mega"] = 1016.51, ["Mega|Fly|Ride"] = 1034.96}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 70.23, ["Fly"] = 78.75, ["Ride"] = 69.83, ["Fly|Ride"] = 80.07, ["Neon|Ride"] = 410.82, ["Neon|Fly|Ride"] = 299.25, ["Mega|Fly|Ride"] = 1469.99}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 2513.61, ["Ride"] = 958.13, ["Fly|Ride"] = 1050, ["Neon|Fly|Ride"] = 4505.41, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 452.65, ["Ride"] = 656.25, ["Fly|Ride"] = 525, ["Neon|Ride"] = 1747.7, ["Neon|Fly|Ride"] = 1456.41, ["Mega|Fly|Ride"] = 9076.88}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 86.63, ["Fly"] = 209.57, ["Ride"] = 164.07, ["Fly|Ride"] = 182.31, ["Neon"] = 460.04, ["Neon|Ride"] = 454.65, ["Neon|Fly|Ride"] = 519.49, ["Mega"] = 4191.09, ["Mega|Ride"] = 1443.75, ["Mega|Fly|Ride"] = 1655.49}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 7.85, ["Ride"] = 28.3, ["Fly|Ride"] = 87.94, ["Neon"] = 101.07, ["Neon|Ride"] = 104.79, ["Neon|Fly|Ride"] = 233.63, ["Mega"] = 274.97, ["Mega|Ride"] = 508.59, ["Mega|Fly|Ride"] = 976.54}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 33.86, ["Fly"] = 62.89, ["Ride"] = 49.26, ["Fly|Ride"] = 87.7, ["Neon"] = 249.38, ["Neon|Fly"] = 293.4, ["Neon|Ride"] = 237.86, ["Neon|Fly|Ride"] = 313.29, ["Mega"] = 1816.84, ["Mega|Fly|Ride"] = 1049.99}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 813.75, ["Ride"] = 918.75, ["Fly|Ride"] = 1085.05, ["Neon|Fly|Ride"] = 2931.67, ["Mega|Fly|Ride"] = 17319.61}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 983.07}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 3346.88, ["Ride"] = 3395.99, ["Fly|Ride"] = 3463.69, ["Neon|Ride"] = 30030.07, ["Neon|Fly|Ride"] = 15750, ["Mega|Fly|Ride"] = 89410.17}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 167.66, ["Fly"] = 408.19, ["Ride"] = 349.93, ["Fly|Ride"] = 391.83, ["Neon"] = 628.67, ["Neon|Ride"] = 1231.2, ["Neon|Fly|Ride"] = 851.82, ["Mega"] = 5867.51, ["Mega|Fly|Ride"] = 6147.26}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 73.63, ["Ride"] = 108.44, ["Fly|Ride"] = 336, ["Neon|Ride"] = 489.33, ["Neon|Fly|Ride"] = 644.39}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 9.98, ["Fly"] = 131.25, ["Ride"] = 28.29, ["Fly|Ride"] = 90.12, ["Neon"] = 274.32, ["Neon|Ride"] = 115.5, ["Neon|Fly|Ride"] = 195.57, ["Mega|Ride"] = 838.23, ["Mega|Fly|Ride"] = 518.65}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 17.03, ["Fly"] = 29.59, ["Ride"] = 22.32, ["Fly|Ride"] = 45.94, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 2221.28}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 12.46, ["Fly"] = 70.9, ["Ride"] = 32.8, ["Fly|Ride"] = 83.83, ["Neon"] = 134.13, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 187.69, ["Mega|Ride"] = 859.69, ["Mega|Fly|Ride"] = 691.55}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 3.92, ["Ride"] = 27.69, ["Fly|Ride"] = 252, ["Neon"] = 21, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 166.68, ["Mega|Fly|Ride"] = 357}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 24.94, ["Ride"] = 49.26, ["Fly|Ride"] = 118.13, ["Neon"] = 143.07, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 670.59, ["Mega|Ride"] = 628.69}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 273, ["Fly"] = 329.44, ["Ride"] = 257.25, ["Fly|Ride"] = 314.31, ["Neon"] = 769.64, ["Neon|Ride"] = 590.63, ["Neon|Fly|Ride"] = 623.44, ["Mega"] = 6562.5, ["Mega|Ride"] = 4191.09, ["Mega|Fly|Ride"] = 2766.12}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.63, ["Fly"] = 16.78, ["Ride"] = 13.13, ["Fly|Ride"] = 39.38, ["Neon"] = 18.96, ["Neon|Fly"] = 92.32, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 197.01, ["Mega|Ride"] = 737.65, ["Mega|Fly|Ride"] = 259.86}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 30.17, ["Fly"] = 115.5, ["Ride"] = 52.5, ["Fly|Ride"] = 98.44, ["Neon"] = 140.89, ["Neon|Fly"] = 288.75, ["Neon|Ride"] = 169.31, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 472.5, ["Mega|Ride"] = 520.99, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 761.25, ["Ride"] = 762.57, ["Fly|Ride"] = 656.25, ["Neon|Ride"] = 1816.5, ["Neon|Fly|Ride"] = 1575, ["Mega|Fly|Ride"] = 4200}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 24.92, ["Fly"] = 64.32, ["Ride"] = 32.81, ["Fly|Ride"] = 78.75, ["Neon"] = 240.02, ["Neon|Fly"] = 461.56, ["Neon|Ride"] = 154.34, ["Neon|Fly|Ride"] = 187.69, ["Mega"] = 1575, ["Mega|Ride"] = 978.63, ["Mega|Fly|Ride"] = 834.04}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 317.63, ["Fly"] = 316.32, ["Ride"] = 262.5, ["Fly|Ride"] = 262.5, ["Neon"] = 1397.74, ["Neon|Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 4190.03}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 125.74, ["Fly"] = 139.13, ["Ride"] = 123.36, ["Fly|Ride"] = 165.55, ["Neon|Fly"] = 637.06, ["Neon|Ride"] = 559.53, ["Neon|Fly|Ride"] = 559.53, ["Mega"] = 2933.77, ["Mega|Fly|Ride"] = 1804.53}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 649.69, ["Ride"] = 570.93, ["Fly|Ride"] = 551.25, ["Neon"] = 2633.14, ["Neon|Fly|Ride"] = 2514.65, ["Mega|Fly|Ride"] = 9010.81}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 19.59, ["Ride"] = 52.5, ["Neon"] = 91.62, ["Neon|Fly"] = 182.33, ["Neon|Ride"] = 118.6, ["Neon|Fly|Ride"] = 140.42, ["Mega"] = 315, ["Mega|Ride"] = 461.53, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 3732.75, ["Fly"] = 3915.06, ["Ride"] = 3555.7, ["Fly|Ride"] = 3149.99, ["Neon"] = 13935.32, ["Neon|Fly|Ride"] = 6771.76, ["Mega|Fly|Ride"] = 25058.25}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 81.75, ["Fly"] = 120.5, ["Ride"] = 91.88, ["Fly|Ride"] = 152.98, ["Neon"] = 394.78, ["Neon|Ride"] = 446.25, ["Neon|Fly|Ride"] = 401.63, ["Mega|Fly|Ride"] = 1777.02}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.42, ["Fly"] = 27.26, ["Ride"] = 19.69, ["Fly|Ride"] = 84, ["Neon"] = 12.7, ["Neon|Fly"] = 44.63, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 112.12, ["Mega"] = 112.12, ["Mega|Fly"] = 452.82, ["Mega|Ride"] = 152.99, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.91, ["Ride"] = 39.38, ["Neon"] = 15.74, ["Neon|Ride"] = 70.22, ["Neon|Fly|Ride"] = 266.44, ["Mega"] = 147, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 278.2}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 140.42, ["Fly"] = 65.63, ["Ride"] = 44.88, ["Fly|Ride"] = 70.2, ["Neon|Ride"] = 698.87, ["Neon|Fly|Ride"] = 240.19, ["Mega|Fly|Ride"] = 1207.5}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 888.53, ["Ride"] = 1028.95, ["Fly|Ride"] = 984.38, ["Neon|Fly|Ride"] = 4725, ["Mega"] = 16153.05, ["Mega|Fly|Ride"] = 25146.42}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 4960.14, ["Ride"] = 4844.78, ["Fly|Ride"] = 4856.25}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 19.92, ["Fly"] = 33.33, ["Ride"] = 23.08, ["Fly|Ride"] = 43.31, ["Neon|Ride"] = 140.42, ["Neon|Fly|Ride"] = 136.9, ["Mega"] = 2514.65, ["Mega|Fly|Ride"] = 616.13}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 14.44, ["Fly"] = 44.63, ["Ride"] = 32.82, ["Fly|Ride"] = 91.88, ["Neon"] = 99.56, ["Neon|Ride"] = 75.64, ["Neon|Fly|Ride"] = 154.62, ["Mega"] = 923.05, ["Mega|Ride"] = 628.67, ["Mega|Fly|Ride"] = 496.13}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 38.07, ["Fly"] = 140.44, ["Ride"] = 52.5, ["Fly|Ride"] = 84, ["Neon"] = 393.75, ["Neon|Ride"] = 245.44, ["Neon|Fly|Ride"] = 320.77, ["Mega|Fly|Ride"] = 859.68}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 217.88, ["Ride"] = 255.93, ["Fly|Ride"] = 343.64, ["Neon|Ride"] = 1218.5, ["Neon|Fly|Ride"] = 1114.83, ["Mega"] = 10477.68, ["Mega|Fly|Ride"] = 4610.38}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.94, ["Neon"] = 19.67, ["Neon|Fly"] = 70.95, ["Neon|Fly|Ride"] = 140.42, ["Mega"] = 110.25, ["Mega|Ride"] = 270.35, ["Mega|Fly|Ride"] = 293.4}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 208.69, ["Ride"] = 187.03, ["Fly|Ride"] = 282.19, ["Neon"] = 783.75, ["Neon|Fly"] = 815.81, ["Neon|Ride"] = 692.34, ["Neon|Fly|Ride"] = 733.69, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 2.63, ["Fly"] = 73.5, ["Ride"] = 10.5, ["Fly|Ride"] = 43.55, ["Neon"] = 27.86, ["Neon|Ride"] = 145.69, ["Neon|Fly|Ride"] = 105, ["Mega"] = 461.53, ["Mega|Ride"] = 419.12, ["Mega|Fly|Ride"] = 321.67}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 203.7, ["Fly"] = 322.22, ["Ride"] = 203.44, ["Fly|Ride"] = 275.63, ["Neon|Fly|Ride"] = 895.85, ["Mega"] = 10477.68, ["Mega|Fly|Ride"] = 3771.97}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 10.4, ["Fly"] = 419.12, ["Ride"] = 28.25, ["Fly|Ride"] = 83.83, ["Neon"] = 70.22, ["Neon|Fly"] = 293.09, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 391.88, ["Mega"] = 510.27, ["Mega|Ride"] = 586.77, ["Mega|Fly|Ride"] = 448.41}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 3.94, ["Ride"] = 28.88, ["Fly|Ride"] = 131.25, ["Neon"] = 19.69, ["Neon|Fly"] = 170.63, ["Neon|Ride"] = 55.13, ["Neon|Fly|Ride"] = 183.69, ["Mega"] = 76.13, ["Mega|Fly"] = 419.12, ["Mega|Ride"] = 125.74, ["Mega|Fly|Ride"] = 213.94}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Ride"] = 65.19, ["Mega"] = 25.89, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 166.61}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 2.1, ["Ride"] = 40.87, ["Fly|Ride"] = 217.93, ["Neon"] = 10.5, ["Neon|Ride"] = 41.52, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 69.83, ["Mega|Fly"] = 153839.18, ["Mega|Ride"] = 94.32}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 66.92, ["Fly"] = 140.42, ["Ride"] = 99.75, ["Fly|Ride"] = 170.77, ["Neon"] = 275.63, ["Neon|Ride"] = 314.34, ["Neon|Fly|Ride"] = 406.55, ["Mega"] = 1222.76, ["Mega|Ride"] = 1311.19, ["Mega|Fly|Ride"] = 1257.33}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 45.85, ["Ride"] = 18.38, ["Fly|Ride"] = 51.11, ["Neon"] = 12.52, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 129.94, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 6.56, ["Ride"] = 91.88, ["Fly|Ride"] = 129.94, ["Neon"] = 124.69, ["Neon|Ride"] = 315, ["Mega"] = 380.63, ["Mega|Ride"] = 559.53}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.05, ["Neon"] = 2.1, ["Neon|Ride"] = 77.56, ["Neon|Fly|Ride"] = 154.62, ["Mega"] = 18.38, ["Mega|Ride"] = 82.79, ["Mega|Fly|Ride"] = 170.29}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 17.04, ["Ride"] = 17.07, ["Fly|Ride"] = 35.63, ["Neon"] = 2.1, ["Neon|Fly"] = 15.75, ["Neon|Ride"] = 11.82, ["Neon|Fly|Ride"] = 77.17, ["Mega"] = 14.7, ["Mega|Fly"] = 41.92, ["Mega|Ride"] = 25.16, ["Mega|Fly|Ride"] = 52.5}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 15.73, ["Ride"] = 17.33, ["Fly|Ride"] = 45.52, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 54.25, ["Mega"] = 15.74, ["Mega|Ride"] = 48.48, ["Mega|Fly|Ride"] = 102.69}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.05, ["Ride"] = 27.26, ["Neon"] = 2.63, ["Mega"] = 20.97, ["Mega|Ride"] = 131.25}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 31.44, ["Ride"] = 17.45, ["Fly|Ride"] = 107.63, ["Neon"] = 6.3, ["Neon|Fly"] = 135.05, ["Neon|Ride"] = 35.64, ["Neon|Fly|Ride"] = 77.31, ["Mega"] = 35.79, ["Mega|Fly"] = 91.88, ["Mega|Fly|Ride"] = 161.44}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 3.92, ["Neon|Fly|Ride"] = 204.75, ["Mega"] = 19.69, ["Mega|Ride"] = 102.38}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 2.5, ["Fly"] = 46.78, ["Ride"] = 15.39, ["Fly|Ride"] = 53.08, ["Neon"] = 7.87, ["Neon|Fly"] = 37.96, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 74.41, ["Mega"] = 70.22, ["Mega|Fly"] = 349.97, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 151.76}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 26.17, ["Mega"] = 13.12, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.97, ["Ride"] = 141.44, ["Fly|Ride"] = 525, ["Neon"] = 21.5, ["Mega"] = 140.44, ["Mega|Ride"] = 157.5}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 4.77, ["Ride"] = 79.64}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Neon"] = 6.56, ["Neon|Ride"] = 36.95, ["Neon|Fly|Ride"] = 70.22, ["Mega"] = 26.25, ["Mega|Ride"] = 171.93, ["Mega|Fly|Ride"] = 279.78}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.05, ["Fly"] = 30, ["Ride"] = 16.78, ["Fly|Ride"] = 42.97, ["Neon"] = 2.1, ["Neon|Fly"] = 35.64, ["Neon|Ride"] = 15.73, ["Neon|Fly|Ride"] = 32.61, ["Mega"] = 14.44, ["Mega|Ride"] = 26.55, ["Mega|Fly|Ride"] = 46.17}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.5, ["Fly"] = 72.19, ["Ride"] = 42, ["Neon"] = 41.92, ["Neon|Ride"] = 39.38, ["Mega|Ride"] = 344.76}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.63, ["Ride"] = 42, ["Fly|Ride"] = 78.73, ["Neon"] = 4.19, ["Neon|Ride"] = 41.92, ["Neon|Fly|Ride"] = 88.03, ["Mega"] = 43.32, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 2.1, ["Ride"] = 70.88, ["Neon"] = 13.36, ["Neon|Fly|Ride"] = 140.42, ["Mega"] = 73.37, ["Mega|Ride"] = 233.63}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 4.22, ["Fly"] = 656.25, ["Ride"] = 31.46, ["Fly|Ride"] = 190.68, ["Neon"] = 52.5, ["Neon|Fly"] = 91.18, ["Neon|Ride"] = 41.92, ["Mega"] = 209.77, ["Mega|Ride"] = 85.3, ["Mega|Fly|Ride"] = 276.92}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.05, ["Fly"] = 38.07, ["Ride"] = 22.32, ["Neon"] = 2.1, ["Neon|Fly"] = 20.84, ["Neon|Ride"] = 16.78, ["Neon|Fly|Ride"] = 34.13, ["Mega"] = 17.33, ["Mega|Ride"] = 19.66, ["Mega|Fly|Ride"] = 45.94}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 3.82, ["Fly"] = 26.25, ["Ride"] = 19.65, ["Fly|Ride"] = 138.3, ["Neon"] = 15.73, ["Neon|Ride"] = 110.79, ["Mega"] = 128.63, ["Mega|Fly|Ride"] = 201.37}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 3.68, ["Fly"] = 112.12, ["Fly|Ride"] = 140.39, ["Neon"] = 66.7, ["Neon|Ride"] = 385.41, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 276.85, ["Mega|Ride"] = 277.55, ["Mega|Fly|Ride"] = 440.08}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 22.93, ["Ride"] = 15.74, ["Fly|Ride"] = 52.4, ["Neon"] = 2.1, ["Neon|Fly"] = 22.44, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 17.07, ["Mega|Fly"] = 156.19, ["Mega|Ride"] = 46.17, ["Mega|Fly|Ride"] = 130.99}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.1, ["Neon"] = 11.54, ["Neon|Fly"] = 77.56, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 105, ["Mega"] = 62.31, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 308.07}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 61.69, ["Neon"] = 6.18, ["Neon|Fly"] = 155.09, ["Neon|Fly|Ride"] = 308.11, ["Mega"] = 38.06, ["Mega|Ride"] = 66.03, ["Mega|Fly|Ride"] = 209.57}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 119.45, ["Neon"] = 2.1, ["Neon|Fly"] = 40.69, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 84, ["Mega"] = 15.65, ["Mega|Ride"] = 27.72}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 41.92, ["Ride"] = 22.31, ["Fly|Ride"] = 59.07, ["Neon"] = 9.18, ["Neon|Fly"] = 41.92, ["Neon|Ride"] = 17.33, ["Neon|Fly|Ride"] = 140.42, ["Mega"] = 94.5, ["Mega|Ride"] = 105}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 41.95, ["Neon"] = 10.4, ["Mega"] = 71.27, ["Mega|Ride"] = 91.88}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 28.3, ["Ride"] = 20.84, ["Fly|Ride"] = 56.59, ["Neon"] = 5.71, ["Neon|Fly"] = 70.22, ["Neon|Ride"] = 19.59, ["Neon|Fly|Ride"] = 90.57, ["Mega|Ride"] = 138.48, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 16.94, ["Ride"] = 80.99, ["Neon"] = 84, ["Mega"] = 296.63, ["Mega|Fly|Ride"] = 844.06}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Ride"] = 21, ["Fly|Ride"] = 5306.86, ["Neon"] = 18.47, ["Neon|Fly"] = 58.78, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 154.63, ["Mega"] = 140.42, ["Mega|Fly|Ride"] = 556.38}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 26.25, ["Fly"] = 131.25, ["Ride"] = 26.24, ["Fly|Ride"] = 141.75, ["Neon"] = 18.38, ["Neon|Fly"] = 56.59, ["Neon|Ride"] = 56.59, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 196.88, ["Mega|Fly|Ride"] = 154.62}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.24, ["Fly"] = 79.47, ["Fly|Ride"] = 103.84, ["Neon"] = 96.41, ["Neon|Ride"] = 36.75}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 16.54, ["Mega"] = 590.63, ["Mega|Fly|Ride"] = 794.07}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 3.94, ["Ride"] = 262.5, ["Fly|Ride"] = 70.2, ["Neon"] = 42, ["Neon|Ride"] = 140.42, ["Neon|Fly|Ride"] = 112.12, ["Mega"] = 255.88, ["Mega|Fly|Ride"] = 209.57}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 105, ["Neon"] = 36.46, ["Neon|Ride"] = 291.38, ["Mega"] = 419.12, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.81, ["Neon|Ride"] = 120.5, ["Mega"] = 18.87, ["Mega|Fly|Ride"] = 148.32}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 65.63}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 5.25, ["Fly"] = 21.92, ["Ride"] = 19.69, ["Fly|Ride"] = 52.47, ["Neon"] = 39.38, ["Neon|Ride"] = 48.21, ["Neon|Fly|Ride"] = 105, ["Mega"] = 279.78, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 368.83}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 18.38, ["Fly|Ride"] = 70.62, ["Neon"] = 5.25, ["Neon|Ride"] = 37.73, ["Neon|Fly|Ride"] = 446.57, ["Mega"] = 19.66, ["Mega|Ride"] = 70.22, ["Mega|Fly|Ride"] = 199.1}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.43, ["Ride"] = 164.07, ["Fly|Ride"] = 384.46, ["Neon"] = 3.93, ["Neon|Ride"] = 48.48, ["Mega"] = 56.58, ["Mega|Ride"] = 78.6, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 23.55, ["Neon|Ride"] = 57.75, ["Neon|Fly|Ride"] = 45.94, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 308.07}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 5.24, ["Neon"] = 62.89, ["Neon|Fly|Ride"] = 155.3, ["Mega"] = 346.83, ["Mega|Fly|Ride"] = 305.96}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 50.72, ["Mega"] = 18.38, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 35.64, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Ride"] = 19.79, ["Fly|Ride"] = 279370.79, ["Neon"] = 8.4, ["Neon|Fly"] = 68.83, ["Neon|Ride"] = 28.3, ["Neon|Fly|Ride"] = 66.03, ["Mega"] = 26.17, ["Mega|Fly"] = 100.61, ["Mega|Ride"] = 95.78, ["Mega|Fly|Ride"] = 150.01}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 28.25, ["Ride"] = 17.07, ["Fly|Ride"] = 104.78, ["Neon"] = 8.27, ["Neon|Fly"] = 70.22, ["Neon|Ride"] = 20.97, ["Neon|Fly|Ride"] = 140.42, ["Mega"] = 70.22, ["Mega|Fly"] = 107.63, ["Mega|Fly|Ride"] = 113.17}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Ride"] = 279.74, ["Neon"] = 3.94, ["Neon|Ride"] = 39.2, ["Neon|Fly|Ride"] = 82.03, ["Mega"] = 23.04, ["Mega|Ride"] = 56.59, ["Mega|Fly|Ride"] = 102.38}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 50.31, ["Neon|Fly|Ride"] = 120.5, ["Mega"] = 20.82, ["Mega|Fly"] = 105, ["Mega|Ride"] = 79.52, ["Mega|Fly|Ride"] = 162.42}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 26.36, ["Ride"] = 25.14, ["Fly|Ride"] = 79.64, ["Neon"] = 2.1, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 86.63, ["Mega"] = 23.12, ["Mega|Ride"] = 37.41, ["Mega|Fly|Ride"] = 138.48}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Neon"] = 2.29, ["Mega"] = 13.13, ["Mega|Ride"] = 205.38}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 6.57, ["Neon|Ride"] = 77.33, ["Neon|Fly|Ride"] = 420, ["Mega"] = 41.92}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 18.38, ["Fly|Ride"] = 105, ["Neon"] = 5.87, ["Neon|Ride"] = 20.97, ["Neon|Fly|Ride"] = 77.44, ["Mega"] = 35.44, ["Mega|Fly"] = 68.25, ["Mega|Ride"] = 48.51, ["Mega|Fly|Ride"] = 146.71}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 13.12, ["Ride"] = 59.07, ["Neon"] = 134.13, ["Mega"] = 414.1, ["Mega|Ride"] = 419.12, ["Mega|Fly|Ride"] = 519.7}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.1, ["Ride"] = 68.23, ["Neon"] = 35.64, ["Neon|Fly|Ride"] = 110.25, ["Mega"] = 1586.33, ["Mega|Ride"] = 313.04}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 2.1, ["Ride"] = 41.92, ["Fly|Ride"] = 419.07, ["Neon"] = 98.44, ["Neon|Ride"] = 277.57, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 446.46, ["Mega|Fly|Ride"] = 559.53}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 16.67, ["Ride"] = 15.63, ["Fly|Ride"] = 39.38, ["Neon"] = 2.1, ["Neon|Fly"] = 10.5, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 39.24, ["Mega"] = 15.68, ["Mega|Fly"] = 23.62, ["Mega|Ride"] = 19.69, ["Mega|Fly|Ride"] = 45.94}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 5.25, ["Ride"] = 55.13, ["Neon"] = 15.23, ["Neon|Fly"] = 140.42, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 64.97, ["Mega|Ride"] = 154.62}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Ride"] = 31.5, ["Neon"] = 2.1, ["Neon|Fly"] = 31.18, ["Neon|Ride"] = 31.45, ["Neon|Fly|Ride"] = 70.27, ["Mega"] = 14.39, ["Mega|Fly"] = 46.17, ["Mega|Ride"] = 35.64, ["Mega|Fly|Ride"] = 337.98}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 3.78, ["Neon|Fly"] = 60.9, ["Mega"] = 14.43, ["Mega|Fly|Ride"] = 272.44}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Ride"] = 20.97, ["Fly|Ride"] = 262.5, ["Neon"] = 11.24, ["Neon|Fly"] = 77.33, ["Neon|Ride"] = 31.16, ["Neon|Fly|Ride"] = 70.22, ["Mega"] = 140.42, ["Mega|Ride"] = 108.47, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 242.82, ["Fly|Ride"] = 393.75, ["Neon"] = 1201.81, ["Neon|Ride"] = 1050, ["Neon|Fly|Ride"] = 1414.5, ["Mega"] = 8382.14, ["Mega|Fly|Ride"] = 5309.05}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Fly|Ride"] = 52.5, ["Neon"] = 7.88, ["Neon|Ride"] = 68.25, ["Mega"] = 73.37, ["Mega|Ride"] = 173.95, ["Mega|Fly|Ride"] = 552.19}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 10.49, ["Fly"] = 103.68, ["Ride"] = 24.1, ["Fly|Ride"] = 140.2, ["Neon"] = 72.19, ["Neon|Ride"] = 166.69, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 116.31, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 616.13}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 12.47, ["Ride"] = 15.06, ["Fly|Ride"] = 33.08, ["Neon"] = 3.91, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 61.69, ["Mega"] = 49.88, ["Mega|Fly"] = 92.32, ["Mega|Ride"] = 69.25, ["Mega|Fly|Ride"] = 140.44}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 24.92, ["Fly|Ride"] = 121.54, ["Neon"] = 9.21, ["Neon|Fly"] = 41.92, ["Neon|Ride"] = 41.92, ["Mega"] = 123.65, ["Mega|Ride"] = 136.23}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 7.88, ["Fly"] = 32.82, ["Ride"] = 19.69, ["Fly|Ride"] = 48.15, ["Neon"] = 28.59, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 82.9, ["Mega"] = 204.33, ["Mega|Ride"] = 167.66, ["Mega|Fly|Ride"] = 308.07}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 5.25, ["Ride"] = 40.99, ["Fly|Ride"] = 246.75, ["Neon"] = 57.75, ["Neon|Ride"] = 104.79, ["Neon|Fly|Ride"] = 622.39, ["Mega"] = 298.85, ["Mega|Ride"] = 266.14, ["Mega|Fly|Ride"] = 508.6}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.63, ["Fly"] = 21.94, ["Ride"] = 14.44, ["Fly|Ride"] = 38.07, ["Neon"] = 28.32, ["Neon|Fly"] = 49.26, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 66.94, ["Mega"] = 196.88, ["Mega|Ride"] = 419.12, ["Mega|Fly|Ride"] = 559.53}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 72.19, ["Fly"] = 141.75, ["Ride"] = 95.36, ["Fly|Ride"] = 131.25, ["Neon"] = 444.27, ["Neon|Fly"] = 544.86, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 443.89, ["Mega|Fly|Ride"] = 1565.82}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 241, ["Fly"] = 385.29, ["Ride"] = 209.95, ["Fly|Ride"] = 252, ["Neon|Ride"] = 1117.98, ["Neon|Fly|Ride"] = 1089.69, ["Mega"] = 10477.68, ["Mega|Fly|Ride"] = 5231.28}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 57.75, ["Fly"] = 115.35, ["Ride"] = 85.32, ["Fly|Ride"] = 111.57, ["Neon"] = 301.88, ["Neon|Ride"] = 262.22, ["Neon|Fly|Ride"] = 309.1, ["Mega|Fly|Ride"] = 1168.13}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 6.24, ["Ride"] = 26.25, ["Fly|Ride"] = 64.97, ["Neon"] = 27.66, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 182.33, ["Mega"] = 230.77, ["Mega|Ride"] = 237.69, ["Mega|Fly|Ride"] = 392.44}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 13.01, ["Fly"] = 41.92, ["Ride"] = 33.48, ["Fly|Ride"] = 65.63, ["Neon"] = 83.69, ["Neon|Ride"] = 136.23, ["Mega"] = 478.84, ["Mega|Ride"] = 388.5, ["Mega|Fly|Ride"] = 553.83}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 31.49, ["Ride"] = 15.75, ["Fly|Ride"] = 65.77, ["Neon"] = 5.25, ["Neon|Fly"] = 31.45, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 56.44, ["Mega"] = 40.4, ["Mega|Fly"] = 115.4, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 209.57}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 7.87, ["Fly"] = 66.94, ["Ride"] = 27.57, ["Fly|Ride"] = 103.69, ["Neon"] = 23, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 140.42, ["Mega"] = 461.53, ["Mega|Ride"] = 174.99, ["Mega|Fly|Ride"] = 279.78}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 17.36, ["Fly|Ride"] = 45.1, ["Neon"] = 11.84, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 31.45, ["Neon|Fly|Ride"] = 132.04, ["Mega"] = 131.24, ["Mega|Ride"] = 219.22, ["Mega|Fly|Ride"] = 222.14}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 3.68, ["Ride"] = 30.19, ["Fly|Ride"] = 328.13, ["Neon"] = 21.63, ["Neon|Ride"] = 56.59, ["Mega"] = 179.21}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 28.3, ["Neon"] = 2.1, ["Neon|Ride"] = 31.45, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 15.63, ["Mega|Ride"] = 49.26, ["Mega|Fly|Ride"] = 166.61}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 45.93, ["Ride"] = 28.3, ["Fly|Ride"] = 56.44, ["Neon"] = 16.67, ["Neon|Fly"] = 70.22, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 86.56, ["Mega"] = 154.62, ["Mega|Fly|Ride"] = 192.29}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.1, ["Ride"] = 18.37, ["Neon"] = 62.31, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 559.53, ["Mega"] = 182.33, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 271.68}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 148.32, ["Fly"] = 209.57, ["Ride"] = 162.75, ["Fly|Ride"] = 243.13, ["Neon"] = 615.05, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 551.25, ["Mega|Fly|Ride"] = 1884.75}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 7.04, ["Ride"] = 240.91, ["Fly|Ride"] = 206.07, ["Neon"] = 55.13, ["Neon|Ride"] = 154.63, ["Neon|Fly|Ride"] = 152.25, ["Mega"] = 414.75, ["Mega|Ride"] = 335.3, ["Mega|Fly|Ride"] = 495.8}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.4, ["Fly"] = 69.22, ["Ride"] = 26.55, ["Fly|Ride"] = 112.88, ["Neon"] = 24.93, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 125.74, ["Mega"] = 308.44, ["Mega|Ride"] = 279.78, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 19.62, ["Ride"] = 139.23, ["Fly|Ride"] = 131.25, ["Neon"] = 73.5, ["Neon|Ride"] = 138.32, ["Neon|Fly|Ride"] = 294.54, ["Mega"] = 522.85, ["Mega|Ride"] = 489.33, ["Mega|Fly|Ride"] = 534.19}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 5.17}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 3.94, ["Ride"] = 27.57, ["Neon"] = 72.19, ["Neon|Fly|Ride"] = 628.67, ["Mega"] = 288.75, ["Mega|Ride"] = 405.5, ["Mega|Fly|Ride"] = 1257.33}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 26.09, ["Fly"] = 56.25, ["Ride"] = 39.38, ["Fly|Ride"] = 52.5, ["Neon"] = 279.78, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 139.79, ["Neon|Fly|Ride"] = 124.69, ["Mega"] = 2095.55, ["Mega|Fly|Ride"] = 669.22}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 3.82, ["Neon|Ride"] = 34.59, ["Neon|Fly|Ride"] = 70.22, ["Mega"] = 24.94, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 171.94}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 2.1, ["Fly"] = 34.13, ["Ride"] = 28.3, ["Fly|Ride"] = 73.21, ["Neon"] = 47.92, ["Neon|Ride"] = 230.78, ["Mega"] = 277.6, ["Mega|Fly"] = 385.39, ["Mega|Ride"] = 161.47, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 61.73, ["Neon"] = 19.69, ["Neon|Ride"] = 28.3, ["Neon|Fly|Ride"] = 70.22, ["Mega"] = 140.41, ["Mega|Fly"] = 138.32, ["Mega|Ride"] = 124.08, ["Mega|Fly|Ride"] = 234.86}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 112.88, ["Mega"] = 54.87, ["Mega|Ride"] = 88.03, ["Mega|Fly|Ride"] = 201.2}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 23.67, ["Ride"] = 77.18, ["Neon"] = 208.3, ["Mega"] = 769.6, ["Mega|Ride"] = 813.75, ["Mega|Fly|Ride"] = 957.96}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.92, ["Ride"] = 48.21, ["Fly|Ride"] = 209.99, ["Neon"] = 262.5, ["Neon|Ride"] = 78.6, ["Mega"] = 229.62, ["Mega|Ride"] = 511.88}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 6.57, ["Fly"] = 83.12, ["Ride"] = 42.71, ["Fly|Ride"] = 167.64, ["Neon"] = 64.32, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 80.07, ["Neon|Fly|Ride"] = 181.06, ["Mega"] = 229.69, ["Mega|Ride"] = 346.12, ["Mega|Fly|Ride"] = 413.88}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 56.44, ["Fly"] = 433.13, ["Ride"] = 105, ["Fly|Ride"] = 349.93, ["Neon"] = 18316.2, ["Neon|Ride"] = 454.74, ["Mega|Ride"] = 1788.55, ["Mega|Fly|Ride"] = 1816.84}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 19.69, ["Ride"] = 45.99, ["Fly|Ride"] = 134.79, ["Neon"] = 73.5, ["Neon|Ride"] = 93.19, ["Neon|Fly|Ride"] = 551.25, ["Mega"] = 341.1, ["Mega|Ride"] = 392.44, ["Mega|Fly|Ride"] = 467.25}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 85.32, ["Ride"] = 109.41, ["Fly|Ride"] = 199.5, ["Neon"] = 243.07, ["Neon|Ride"] = 263.05, ["Neon|Fly|Ride"] = 300.57, ["Mega"] = 1999.53, ["Mega|Ride"] = 1152.56, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 26.24, ["Ride"] = 32.82, ["Fly|Ride"] = 116.55, ["Neon"] = 87.94, ["Neon|Ride"] = 148.29, ["Neon|Fly|Ride"] = 209.77, ["Mega"] = 343.85, ["Mega|Ride"] = 326.76, ["Mega|Fly|Ride"] = 519.1}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 16.78, ["Fly"] = 52.5, ["Ride"] = 27.25, ["Fly|Ride"] = 65.63, ["Neon"] = 59.85, ["Neon|Ride"] = 93.35, ["Neon|Fly|Ride"] = 98.51, ["Mega"] = 327.69, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 23.6, ["Fly"] = 111.57, ["Ride"] = 104.16, ["Fly|Ride"] = 167.64, ["Neon"] = 89.77, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 203.44, ["Mega"] = 235.34, ["Mega|Ride"] = 371.57, ["Mega|Fly|Ride"] = 572.25}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 8.97, ["Ride"] = 46.14, ["Neon"] = 184.64, ["Neon|Ride"] = 133.23, ["Neon|Fly|Ride"] = 199.06, ["Mega"] = 416.59, ["Mega|Ride"] = 300.72, ["Mega|Fly|Ride"] = 400.38}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 26.25, ["Mega"] = 32.49, ["Mega|Fly"] = 140.42, ["Mega|Ride"] = 66.94, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 2.63, ["Ride"] = 104.79, ["Neon"] = 13.12, ["Neon|Ride"] = 83.83, ["Mega"] = 99.62, ["Mega|Ride"] = 156.4, ["Mega|Fly|Ride"] = 188.61}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.63, ["Neon"] = 22.23, ["Neon|Ride"] = 125.74, ["Mega"] = 336, ["Mega|Ride"] = 391.88}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 5.25, ["Ride"] = 31.14, ["Fly|Ride"] = 115.39, ["Neon"] = 27.57, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 278.73, ["Mega"] = 123.38, ["Mega|Ride"] = 377.21, ["Mega|Fly|Ride"] = 508.6}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 493.5, ["Ride"] = 523.69, ["Fly|Ride"] = 525, ["Neon"] = 1676.45, ["Neon|Ride"] = 1774.94, ["Neon|Fly|Ride"] = 1575, ["Mega|Fly|Ride"] = 4593.75}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 5.25, ["Fly"] = 56.26, ["Ride"] = 28.3, ["Fly|Ride"] = 71.54, ["Neon"] = 37.73, ["Neon|Ride"] = 83.84, ["Neon|Fly|Ride"] = 123.47, ["Mega"] = 224.24, ["Mega|Ride"] = 279.78, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 7.85, ["Fly"] = 31.5, ["Ride"] = 43.32, ["Fly|Ride"] = 70.88, ["Neon"] = 64.32, ["Neon|Fly"] = 315, ["Neon|Ride"] = 154.63, ["Neon|Fly|Ride"] = 105, ["Mega"] = 307.13, ["Mega|Ride"] = 318.14, ["Mega|Fly|Ride"] = 391.88}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 11.55, ["Ride"] = 23.21, ["Fly|Ride"] = 314.31, ["Neon|Ride"] = 86.63, ["Mega"] = 223.13, ["Mega|Ride"] = 335.3, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 41.92, ["Ride"] = 42, ["Neon"] = 5.25, ["Neon|Ride"] = 32.33, ["Neon|Fly|Ride"] = 139.37, ["Mega"] = 59.07, ["Mega|Ride"] = 107.52, ["Mega|Fly|Ride"] = 201.97}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Ride"] = 69.21, ["Neon"] = 3.14, ["Neon|Ride"] = 57.7, ["Neon|Fly|Ride"] = 115.4, ["Mega"] = 21.18, ["Mega|Ride"] = 77.56, ["Mega|Fly|Ride"] = 209.57}},
    ["rbxassetid://3261465951"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 5.24, ["Fly"] = 65.63, ["Ride"] = 41.27, ["Neon"] = 118.13, ["Neon|Fly"] = 140.42, ["Neon|Ride"] = 108.94, ["Mega"] = 564.38, ["Mega|Ride"] = 405.5, ["Mega|Fly|Ride"] = 718.78}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.61, ["Ride"] = 45.36, ["Neon"] = 7.87, ["Neon|Ride"] = 73.86, ["Mega"] = 54.5, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 230.35}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 3.36, ["Fly"] = 41.92, ["Ride"] = 19.69, ["Fly|Ride"] = 525, ["Neon"] = 8.39, ["Neon|Ride"] = 70.22, ["Neon|Fly|Ride"] = 105, ["Mega"] = 124.69, ["Mega|Ride"] = 154.88, ["Mega|Fly|Ride"] = 197.01}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 459.85, ["Fly"] = 459.38, ["Ride"] = 469.88, ["Fly|Ride"] = 523.84, ["Neon|Ride"] = 1509.38, ["Neon|Fly|Ride"] = 1691.6, ["Mega|Fly|Ride"] = 7684.34}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 6.56, ["Fly"] = 196.88, ["Ride"] = 72.19, ["Neon"] = 64.97, ["Neon|Ride"] = 131.25, ["Mega"] = 399, ["Mega|Ride"] = 408.45, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Neon"] = 6.34, ["Neon|Ride"] = 41.92, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 47.25, ["Mega|Fly"] = 154.62, ["Mega|Ride"] = 100.62, ["Mega|Fly|Ride"] = 198.28}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Ride"] = 838.23, ["Fly|Ride"] = 140.39, ["Neon"] = 3.42, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 23.63, ["Mega|Ride"] = 83.08, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 10.33, ["Fly"] = 78.6, ["Ride"] = 39.38, ["Neon"] = 35.64, ["Neon|Ride"] = 104.78, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 328.13, ["Mega|Ride"] = 195.55, ["Mega|Fly|Ride"] = 306.92}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 13.12, ["Ride"] = 140.42, ["Fly|Ride"] = 131.25, ["Neon"] = 92.32, ["Neon|Fly|Ride"] = 838.22, ["Mega"] = 943.01, ["Mega|Ride"] = 461.53, ["Mega|Fly|Ride"] = 1066.42}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["Fly|Ride"] = 140.39, ["Neon"] = 195.96, ["Neon|Ride"] = 208.52, ["Mega"] = 391.88, ["Mega|Fly|Ride"] = 1227.19}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 10.49, ["Ride"] = 64.97, ["Fly|Ride"] = 138.45, ["Neon|Ride"] = 131.56, ["Neon|Fly|Ride"] = 769.64, ["Mega"] = 660.19, ["Mega|Ride"] = 484.09, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 328.13, ["Ride"] = 462.03, ["Fly|Ride"] = 605.55, ["Neon"] = 787.5, ["Neon|Ride"] = 978.63, ["Neon|Fly|Ride"] = 1125.31, ["Mega|Fly|Ride"] = 3150}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 3.92, ["Fly"] = 24.94, ["Ride"] = 44.63, ["Fly|Ride"] = 81.93, ["Neon"] = 39.38, ["Neon|Ride"] = 98.51, ["Neon|Fly|Ride"] = 140.41, ["Mega"] = 559.53, ["Mega|Ride"] = 497.7, ["Mega|Fly|Ride"] = 698.87}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 8.4, ["Ride"] = 41.68, ["Mega"] = 1257.33, ["Mega|Fly|Ride"] = 559.53}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 5.91, ["Ride"] = 46.11, ["Fly|Ride"] = 162.75, ["Neon"] = 35.44, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 168, ["Mega"] = 208.52, ["Mega|Ride"] = 230.77, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.1, ["Ride"] = 31.49, ["Fly|Ride"] = 107.92, ["Neon"] = 5.92, ["Neon|Ride"] = 39.95, ["Mega"] = 39.37, ["Mega|Ride"] = 62.89, ["Mega|Fly|Ride"] = 215.78}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 36.74, ["Ride"] = 61.82, ["Neon"] = 229.69, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 461.53, ["Mega"] = 1117.98, ["Mega|Ride"] = 1033.11, ["Mega|Fly|Ride"] = 943.01}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 576.77, ["Ride"] = 32.49, ["Fly|Ride"] = 65.63, ["Neon"] = 9.91, ["Neon|Fly"] = 182.33, ["Neon|Ride"] = 50.3, ["Mega"] = 54.86, ["Mega|Ride"] = 106.99, ["Mega|Fly|Ride"] = 252.69}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 27.57, ["Ride"] = 83.35, ["Fly|Ride"] = 148.25, ["Neon"] = 7.87, ["Neon|Ride"] = 36.69, ["Neon|Fly|Ride"] = 140.38, ["Mega"] = 44.61, ["Mega|Ride"] = 279.78, ["Mega|Fly|Ride"] = 268.25}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Fly"] = 1519.88, ["Ride"] = 28.3, ["Fly|Ride"] = 65.63, ["Neon"] = 13.13, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 295.32, ["Mega"] = 113.17, ["Mega|Ride"] = 189.24, ["Mega|Fly|Ride"] = 200.79}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 62.99, ["Fly"] = 92.22, ["Ride"] = 97.13, ["Fly|Ride"] = 154.61, ["Neon"] = 309.1, ["Neon|Ride"] = 314.34, ["Neon|Fly|Ride"] = 672.67, ["Mega|Fly|Ride"] = 901.69}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 248.12, ["Ride"] = 326.82, ["Fly|Ride"] = 419.07, ["Neon|Ride"] = 1099.88, ["Neon|Fly|Ride"] = 1421.59, ["Mega"] = 6985.49, ["Mega|Fly|Ride"] = 5655.87}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 8.34, ["Neon"] = 27.56, ["Neon|Fly|Ride"] = 219.19, ["Mega"] = 104.89, ["Mega|Ride"] = 193.33, ["Mega|Fly|Ride"] = 500.84}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 4.08, ["Neon"] = 12.7, ["Mega"] = 124.69, ["Mega|Ride"] = 167.66, ["Mega|Fly|Ride"] = 446.53}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 3.94, ["Fly"] = 155.57, ["Mega"] = 488.92}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.45, ["Fly"] = 53.23, ["Ride"] = 34.13, ["Neon"] = 6.57, ["Neon|Ride"] = 30.86, ["Neon|Fly|Ride"] = 182.33, ["Mega"] = 67.08, ["Mega|Ride"] = 138.48, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 59.07, ["Neon"] = 5.8, ["Mega"] = 32.82, ["Mega|Ride"] = 206.07}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 65.54, ["Ride"] = 27.25, ["Fly|Ride"] = 46.16, ["Neon"] = 3.94, ["Neon|Ride"] = 43.86, ["Neon|Fly|Ride"] = 104.79, ["Mega"] = 49.26, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 146.55}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 27.69, ["Fly|Ride"] = 60.38, ["Neon"] = 24.11, ["Neon|Fly"] = 98.51, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 85.39, ["Mega"] = 170.63, ["Mega|Ride"] = 195.96, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 19.69, ["Fly"] = 99.22, ["Ride"] = 65.63, ["Fly|Ride"] = 136.2, ["Neon"] = 186.93, ["Neon|Ride"] = 147, ["Neon|Fly|Ride"] = 167.66, ["Mega"] = 367.5, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 59.07, ["Fly"] = 582.75, ["Ride"] = 98.44, ["Fly|Ride"] = 159.26, ["Neon"] = 419.12, ["Neon|Ride"] = 383.25, ["Neon|Fly|Ride"] = 572.56, ["Mega"] = 3077.17, ["Mega|Ride"] = 1725.68, ["Mega|Fly|Ride"] = 1516.52}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Fly|Ride"] = 131.25, ["Neon"] = 5.25, ["Neon|Ride"] = 70.22, ["Neon|Fly|Ride"] = 359.63, ["Mega"] = 56.35, ["Mega|Ride"] = 125.74, ["Mega|Fly|Ride"] = 230.77}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 24.1, ["Ride"] = 13.13, ["Fly|Ride"] = 46.16, ["Neon"] = 3.94, ["Neon|Ride"] = 24.86, ["Neon|Fly|Ride"] = 51.98, ["Mega"] = 38.07, ["Mega|Fly"] = 157.5, ["Mega|Ride"] = 52.4, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 6.3, ["Ride"] = 37.73, ["Neon"] = 91.18, ["Neon|Ride"] = 419.12, ["Neon|Fly|Ride"] = 278.73, ["Mega"] = 611, ["Mega|Ride"] = 628.67, ["Mega|Fly|Ride"] = 471.19}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 251.74, ["Fly"] = 345.78, ["Ride"] = 264.02, ["Fly|Ride"] = 372.98, ["Neon"] = 978.63, ["Neon|Ride"] = 1466.9, ["Neon|Fly|Ride"] = 1517.18, ["Mega|Fly|Ride"] = 5231.28}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 28.88, ["Fly"] = 209.9, ["Ride"] = 52.48, ["Fly|Ride"] = 155.07, ["Neon"] = 310.15, ["Neon|Ride"] = 225.52, ["Neon|Fly|Ride"] = 381.94, ["Mega"] = 908.42, ["Mega|Ride"] = 978.63, ["Mega|Fly|Ride"] = 796.32}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 98.49, ["Neon"] = 7.87, ["Neon|Ride"] = 49.26, ["Neon|Fly|Ride"] = 98.51, ["Mega"] = 125.45, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 225.17}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 209.57, ["Ride"] = 83.83, ["Neon"] = 17.33, ["Neon|Ride"] = 65.63, ["Mega"] = 211.32, ["Mega|Ride"] = 431.53}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 19.95, ["Fly"] = 255.67, ["Ride"] = 39.38, ["Fly|Ride"] = 59.07, ["Neon|Ride"] = 137.28, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 2514.65, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 1038.35}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 78.75, ["Ride"] = 237.83, ["Fly|Ride"] = 416.07, ["Neon"] = 519.75, ["Neon|Ride"] = 469.88, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 3074.16, ["Mega|Fly|Ride"] = 2155.29}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 277.39, ["Fly"] = 498.75, ["Ride"] = 279.74, ["Fly|Ride"] = 662.47, ["Neon"] = 820.32, ["Neon|Ride"] = 1035.21, ["Neon|Fly|Ride"] = 918.75, ["Mega|Fly|Ride"] = 3210.38}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 13.11, ["Ride"] = 41.92, ["Fly|Ride"] = 98.49, ["Neon"] = 78.73, ["Neon|Ride"] = 109.72, ["Neon|Fly|Ride"] = 769.6, ["Mega"] = 513.45, ["Mega|Ride"] = 380.63, ["Mega|Fly|Ride"] = 514.46}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 21, ["Fly|Ride"] = 47.25, ["Neon"] = 15.62, ["Neon|Fly"] = 70.22, ["Neon|Ride"] = 31.45, ["Neon|Fly|Ride"] = 75.46, ["Mega"] = 112.28, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 160.13}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 3.94, ["Ride"] = 25.39, ["Fly|Ride"] = 52.4, ["Neon"] = 9.19, ["Neon|Ride"] = 34.07, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 250.79, ["Mega|Ride"] = 230.77, ["Mega|Fly|Ride"] = 291.73}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 316.82, ["Ride"] = 393.75, ["Fly|Ride"] = 484.02, ["Neon|Ride"] = 1676.45, ["Neon|Fly|Ride"] = 1843.9}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 46.11, ["Neon"] = 11.54, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 32.82, ["Mega|Ride"] = 157.18, ["Mega|Fly|Ride"] = 293.08}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 5.93, ["Ride"] = 17.07, ["Fly|Ride"] = 77.32, ["Neon"] = 24.09, ["Neon|Ride"] = 36.74, ["Neon|Fly|Ride"] = 116.17, ["Mega"] = 343.09, ["Mega|Ride"] = 278.73, ["Mega|Fly|Ride"] = 293.4}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 17.46, ["Ride"] = 98.49, ["Neon"] = 103.68, ["Neon|Ride"] = 195.96, ["Neon|Fly|Ride"] = 536.48, ["Mega"] = 518.65, ["Mega|Ride"] = 451.5, ["Mega|Fly|Ride"] = 494.57}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 91.88, ["Fly"] = 278.73, ["Ride"] = 118.13, ["Fly|Ride"] = 140.39, ["Neon|Ride"] = 380.63, ["Neon|Fly|Ride"] = 670.69, ["Mega|Fly|Ride"] = 1699.49}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 22.42, ["Fly"] = 77.31, ["Ride"] = 28.22, ["Fly|Ride"] = 62.89, ["Neon"] = 65.63, ["Neon|Ride"] = 92.32, ["Neon|Fly|Ride"] = 133.07, ["Mega"] = 698.87, ["Mega|Ride"] = 419.12, ["Mega|Fly|Ride"] = 512.4}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 41.92, ["Neon"] = 2.63, ["Neon|Ride"] = 48.21, ["Neon|Fly|Ride"] = 140.42, ["Mega"] = 18.38, ["Mega|Ride"] = 167.66, ["Mega|Fly|Ride"] = 77.32}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Ride"] = 35.44, ["Fly|Ride"] = 73.36, ["Neon"] = 2.1, ["Neon|Fly"] = 31.18, ["Neon|Ride"] = 28.3, ["Neon|Fly|Ride"] = 69.18, ["Mega"] = 19.95, ["Mega|Ride"] = 64.97, ["Mega|Fly|Ride"] = 112.63}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 7.65, ["Ride"] = 62.89, ["Fly|Ride"] = 157.5, ["Neon"] = 29.51, ["Neon|Fly"] = 261.94, ["Neon|Ride"] = 83.84, ["Neon|Fly|Ride"] = 140.38, ["Mega"] = 139.13, ["Mega|Ride"] = 204.33, ["Mega|Fly|Ride"] = 246.75}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1446.38, ["Ride"] = 1443.75, ["Fly|Ride"] = 1639.71, ["Neon"] = 6705.72, ["Neon|Fly|Ride"] = 4610.2, ["Mega|Fly|Ride"] = 13636.88}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 616.88, ["Ride"] = 635.24, ["Fly|Ride"] = 748.8, ["Neon"] = 2243.33, ["Neon|Ride"] = 2409.88, ["Neon|Fly|Ride"] = 1397.74, ["Mega"] = 13845.47, ["Mega|Fly|Ride"] = 4987.5}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 300.57, ["Fly"] = 559.53, ["Ride"] = 315, ["Fly|Ride"] = 393.75, ["Neon"] = 735, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 656.25, ["Mega|Fly|Ride"] = 2428.13}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 301.88, ["Fly"] = 354.38, ["Ride"] = 371.94, ["Fly|Ride"] = 420, ["Neon"] = 918.75, ["Neon|Ride"] = 984.37, ["Neon|Fly|Ride"] = 945, ["Mega|Fly|Ride"] = 2933.77}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 79.65, ["Ride"] = 13.13, ["Fly|Ride"] = 44.63, ["Neon"] = 6.18, ["Neon|Ride"] = 29.82, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 69.25, ["Mega|Ride"] = 112.88, ["Mega|Fly|Ride"] = 159.28}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 287.44, ["Fly"] = 405.72, ["Ride"] = 323.04, ["Fly|Ride"] = 488.21, ["Neon"] = 958.73, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 1049.99, ["Mega"] = 4923.22, ["Mega|Ride"] = 3937.5, ["Mega|Fly|Ride"] = 3474.18}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 2.1, ["Fly"] = 183.75, ["Ride"] = 27.57, ["Neon"] = 10.21, ["Neon|Ride"] = 44.02, ["Mega"] = 67.95, ["Mega|Ride"] = 140.41, ["Mega|Fly|Ride"] = 264.48}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 31.5, ["Fly|Ride"] = 41.92, ["Neon"] = 9.24, ["Neon|Ride"] = 61.69, ["Neon|Fly|Ride"] = 110.25, ["Mega"] = 65.29, ["Mega|Ride"] = 136.6, ["Mega|Fly|Ride"] = 202.13}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Neon"] = 3.94, ["Mega"] = 21.9, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 57.7, ["Ride"] = 70.2, ["Fly|Ride"] = 459.38, ["Neon"] = 184.64, ["Neon|Ride"] = 308.11, ["Mega"] = 2095.55, ["Mega|Ride"] = 923.05, ["Mega|Fly|Ride"] = 972.57}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 65.61, ["Ride"] = 19.29, ["Neon"] = 28.12, ["Mega"] = 328.13, ["Mega|Ride"] = 316.44}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 53.82, ["Neon"] = 3.24, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 19.69, ["Mega|Fly"] = 123.47, ["Mega|Ride"] = 154.62, ["Mega|Fly|Ride"] = 308.44}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 69.17, ["Neon"] = 7.88, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 23.08, ["Neon|Fly|Ride"] = 95.37, ["Mega"] = 69.83, ["Mega|Fly"] = 207.69, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 173.25}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 2.1, ["Fly"] = 46.1, ["Ride"] = 31.16, ["Fly|Ride"] = 55.26, ["Neon"] = 59.73, ["Neon|Fly"] = 39.24, ["Neon|Ride"] = 107.14, ["Neon|Fly|Ride"] = 251.48, ["Mega"] = 237.57, ["Mega|Fly|Ride"] = 1019.82}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 15.73, ["Ride"] = 27.57, ["Mega"] = 461.53, ["Mega|Ride"] = 333.21, ["Mega|Fly|Ride"] = 518.65}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.63, ["Ride"] = 52.5, ["Fly|Ride"] = 87.94, ["Neon"] = 41.92, ["Neon|Fly|Ride"] = 692.34, ["Mega"] = 251.48, ["Mega|Ride"] = 489.33}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 17.33, ["Fly|Ride"] = 83.83, ["Neon"] = 3.56, ["Neon|Ride"] = 28.3, ["Neon|Fly|Ride"] = 167.66, ["Mega"] = 39.38, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 314.34}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 207.37, ["Fly"] = 217.95, ["Ride"] = 223.13, ["Fly|Ride"] = 275.63, ["Neon"] = 1153.88, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 1131.61, ["Neon|Fly|Ride"] = 1152.56, ["Mega"] = 8382.14, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 18.38, ["Neon"] = 5.65, ["Neon|Ride"] = 26.16, ["Neon|Fly|Ride"] = 61.89, ["Mega"] = 31.45, ["Mega|Ride"] = 73.5, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 7.72, ["Ride"] = 98.44, ["Fly|Ride"] = 105, ["Neon"] = 83.84, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 325.41, ["Mega"] = 315, ["Mega|Ride"] = 325.5, ["Mega|Fly|Ride"] = 460.67}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 35.41, ["Ride"] = 108.42, ["Neon"] = 153.57, ["Neon|Ride"] = 219.22, ["Mega"] = 753.63, ["Mega|Ride"] = 807.68, ["Mega|Fly|Ride"] = 822.6}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 154.55, ["Fly"] = 262.5, ["Ride"] = 223.13, ["Fly|Ride"] = 290.07, ["Neon|Ride"] = 742.88, ["Neon|Fly|Ride"] = 866.25, ["Mega|Fly|Ride"] = 3453.45}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 20.62, ["Neon"] = 100.61, ["Mega"] = 415.42, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 698.87}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 25.12, ["Ride"] = 314.31, ["Fly|Ride"] = 628.6, ["Neon"] = 184.64, ["Neon|Ride"] = 628.67, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 658.01, ["Mega|Ride"] = 889.59, ["Mega|Fly|Ride"] = 1047.78}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 1147.82, ["Ride"] = 1030.32, ["Fly|Ride"] = 1115.63, ["Neon|Ride"] = 6286.62, ["Neon|Fly|Ride"] = 4315.5, ["Mega|Fly|Ride"] = 16498.13}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 9.19, ["Fly"] = 43.32, ["Ride"] = 21.59, ["Fly|Ride"] = 62.35, ["Neon"] = 49.24, ["Neon|Fly"] = 111.57, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 65.62, ["Mega"] = 131.24, ["Mega|Fly"] = 559.53, ["Mega|Ride"] = 267.2, ["Mega|Fly|Ride"] = 384.55}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 11.71, ["Fly"] = 13830.54, ["Ride"] = 39.38, ["Neon"] = 84, ["Neon|Ride"] = 165.56, ["Neon|Fly|Ride"] = 144.74, ["Mega"] = 212.63, ["Mega|Ride"] = 217.88, ["Mega|Fly|Ride"] = 419.12}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Ride"] = 26.24, ["Fly|Ride"] = 91.17, ["Neon"] = 11.81, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 308.11, ["Mega"] = 133.07, ["Mega|Ride"] = 247.29, ["Mega|Fly|Ride"] = 698.87}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 13.02, ["Ride"] = 34.13, ["Fly|Ride"] = 83.83, ["Neon"] = 62.98, ["Neon|Ride"] = 69.25, ["Neon|Fly|Ride"] = 204.32, ["Mega"] = 354.38, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 2.6, ["Fly"] = 36.69, ["Ride"] = 34.13, ["Fly|Ride"] = 65.63, ["Neon"] = 22.32, ["Neon|Ride"] = 62.33, ["Neon|Fly|Ride"] = 83.84, ["Mega"] = 347.88, ["Mega|Ride"] = 170.8, ["Mega|Fly|Ride"] = 198.74}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Ride"] = 27.69, ["Neon"] = 15.73, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 140.42, ["Mega"] = 111.56, ["Mega|Ride"] = 154.62, ["Mega|Fly|Ride"] = 237.86}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 151.13, ["Ride"] = 291.25, ["Fly|Ride"] = 475.64, ["Neon"] = 766.98, ["Neon|Ride"] = 1693.13, ["Neon|Fly|Ride"] = 1117.98, ["Mega|Fly|Ride"] = 3709.11}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Ride"] = 25.39, ["Neon"] = 11.82, ["Neon|Fly"] = 77.33, ["Neon|Ride"] = 45.07, ["Neon|Fly|Ride"] = 154.62, ["Mega"] = 100.61, ["Mega|Ride"] = 139.13, ["Mega|Fly|Ride"] = 209.57}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 4.61, ["Fly"] = 408.19, ["Neon"] = 77.42, ["Mega"] = 249.38, ["Mega|Ride"] = 308.07}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 2.1, ["Fly"] = 81.56, ["Ride"] = 34.13, ["Neon"] = 11.81, ["Neon|Ride"] = 52.5, ["Mega"] = 125.74, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 404.92}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 126.72, ["Fly"] = 262.5, ["Ride"] = 220.5, ["Fly|Ride"] = 416.97, ["Neon"] = 393.75, ["Neon|Ride"] = 590.63, ["Neon|Fly|Ride"] = 626.58, ["Mega"] = 3562.42, ["Mega|Ride"] = 2472.74, ["Mega|Fly|Ride"] = 1785}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 18.83, ["Ride"] = 84, ["Fly|Ride"] = 108.97, ["Neon"] = 78.75, ["Neon|Ride"] = 115.5, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 601.43, ["Mega|Ride"] = 656.96, ["Mega|Fly|Ride"] = 634.96}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 17.64, ["Ride"] = 41.92, ["Neon"] = 124.69, ["Neon|Ride"] = 186.57, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 489.33, ["Mega|Ride"] = 527.66, ["Mega|Fly|Ride"] = 634.98}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 83.83, ["Neon"] = 5.13, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 35.44, ["Mega"] = 33.54, ["Mega|Ride"] = 74.82, ["Mega|Fly|Ride"] = 190.32}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 87.94, ["Fly"] = 125.74, ["Ride"] = 129.94, ["Fly|Ride"] = 170.52, ["Neon"] = 347.88, ["Neon|Ride"] = 380.63, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 905.63}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.05, ["Ride"] = 20.97, ["Neon"] = 5.25, ["Neon|Fly|Ride"] = 588, ["Mega"] = 60.78}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 19.57, ["Fly"] = 140.38, ["Ride"] = 39.73, ["Fly|Ride"] = 108.33, ["Neon"] = 98.54, ["Neon|Ride"] = 108.98, ["Neon|Fly|Ride"] = 112.88, ["Mega"] = 391.88, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 462.5}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 46.78, ["Ride"] = 91.88, ["Fly|Ride"] = 157.5, ["Neon"] = 279.78, ["Neon|Ride"] = 314.34, ["Neon|Fly|Ride"] = 423.82, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 28.3, ["Ride"] = 15.75, ["Fly|Ride"] = 47.25, ["Neon"] = 3.93, ["Neon|Fly"] = 27.72, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 19.92, ["Mega|Ride"] = 45.09, ["Mega|Fly|Ride"] = 103.94}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 3.94, ["Ride"] = 36.75, ["Fly|Ride"] = 98.65, ["Neon"] = 17.33, ["Neon|Ride"] = 64.97, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 164.07, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 513.19}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 12.39, ["Ride"] = 62.21, ["Fly|Ride"] = 105, ["Neon"] = 189.94, ["Neon|Ride"] = 308.11, ["Neon|Fly|Ride"] = 616.19, ["Mega"] = 559.53, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 628.69}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 23.04, ["Neon"] = 2.1, ["Neon|Ride"] = 28.13, ["Neon|Fly|Ride"] = 125.74, ["Mega"] = 15.62, ["Mega|Ride"] = 138.32, ["Mega|Fly|Ride"] = 410.17}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 3.66, ["Fly"] = 210, ["Ride"] = 53.44, ["Fly|Ride"] = 111.57, ["Neon"] = 40.69, ["Neon|Ride"] = 98.51, ["Neon|Fly|Ride"] = 181.22, ["Mega"] = 205.38, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 419.11}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 12.7, ["Fly"] = 41.92, ["Ride"] = 28.29, ["Fly|Ride"] = 46.16, ["Neon"] = 140.42, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 698.87, ["Mega|Fly|Ride"] = 466.55}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 3.54, ["Ride"] = 23.04, ["Neon"] = 6.3, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 200.82, ["Mega"] = 169.32, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 289.2}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 16.93, ["Fly"] = 2095.55, ["Neon"] = 119.05, ["Neon|Ride"] = 493.87, ["Neon|Fly|Ride"] = 6153.16, ["Mega"] = 482.37, ["Mega|Ride"] = 654.29, ["Mega|Fly|Ride"] = 662.17}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 3.94, ["Ride"] = 24.11, ["Fly|Ride"] = 126.48, ["Neon"] = 7.49, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 70.22, ["Mega"] = 79.65, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 408.19, ["Mega|Fly|Ride"] = 288.74}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 28.3, ["Neon"] = 3.28, ["Mega"] = 26.25, ["Mega|Ride"] = 128.94, ["Mega|Fly|Ride"] = 419.12}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 27.06}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 56.21, ["Fly"] = 92.22, ["Ride"] = 78.73, ["Fly|Ride"] = 204.3, ["Neon"] = 1050, ["Neon|Fly|Ride"] = 1047.78, ["Mega|Ride"] = 976.54, ["Mega|Fly|Ride"] = 889.88}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 140.39, ["Neon"] = 2.24, ["Mega"] = 18.87, ["Mega|Ride"] = 103.73, ["Mega|Fly|Ride"] = 140.42}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 614.01, ["Ride"] = 698.79, ["Fly|Ride"] = 654.93, ["Neon"] = 4191.09, ["Neon|Fly|Ride"] = 2375.3, ["Mega"] = 16764.28, ["Mega|Fly|Ride"] = 6985.49}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 2.1, ["Fly"] = 49.88, ["Ride"] = 40.88, ["Fly|Ride"] = 54.24, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 559.53, ["Mega|Fly|Ride"] = 559.53}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 3.28, ["Ride"] = 21.19, ["Fly|Ride"] = 37.73, ["Neon"] = 26.24, ["Neon|Ride"] = 35.47, ["Neon|Fly|Ride"] = 86.99, ["Mega"] = 163.47, ["Mega|Ride"] = 179.82, ["Mega|Fly|Ride"] = 531.24}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 18.38, ["Ride"] = 49.25, ["Fly|Ride"] = 523.84, ["Neon"] = 93.56, ["Neon|Ride"] = 419.12, ["Mega"] = 1035.21, ["Mega|Ride"] = 501.89, ["Mega|Fly|Ride"] = 834.04}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 3.65, ["Fly"] = 136.23, ["Ride"] = 31.5, ["Fly|Ride"] = 393.75, ["Neon"] = 140.42, ["Mega"] = 291.3, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 7.86, ["Ride"] = 60.38, ["Fly|Ride"] = 70.2, ["Neon"] = 64.93, ["Neon|Fly|Ride"] = 350.44, ["Mega"] = 414.58, ["Mega|Ride"] = 473.61, ["Mega|Fly|Ride"] = 626.73}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 7.76, ["Fly"] = 105, ["Ride"] = 28.3, ["Fly|Ride"] = 131.25, ["Neon"] = 31.16, ["Neon|Ride"] = 92.22, ["Neon|Fly|Ride"] = 138.32, ["Mega"] = 183.75, ["Mega|Ride"] = 401.63, ["Mega|Fly|Ride"] = 294}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 46.16, ["Ride"] = 18.87, ["Fly|Ride"] = 75.45, ["Neon"] = 2.1, ["Neon|Fly"] = 28.46, ["Neon|Ride"] = 20.94, ["Neon|Fly|Ride"] = 60.1, ["Mega"] = 15.69, ["Mega|Fly"] = 77.32, ["Mega|Ride"] = 37.73, ["Mega|Fly|Ride"] = 65.63}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 6.3, ["Ride"] = 39.38, ["Fly|Ride"] = 157.94, ["Neon"] = 42.37, ["Neon|Fly"] = 385.41, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 230.77, ["Mega"] = 132.04, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 279.78}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 259.87, ["Ride"] = 315, ["Fly|Ride"] = 335.41, ["Neon"] = 1480.5, ["Neon|Ride"] = 1362.12, ["Neon|Fly|Ride"] = 1327.53, ["Mega|Fly|Ride"] = 5675.5}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 106.6, ["Ride"] = 158.36, ["Fly|Ride"] = 249.38, ["Neon"] = 561.36, ["Neon|Ride"] = 538.86, ["Neon|Fly|Ride"] = 945, ["Mega"] = 4191.09, ["Mega|Ride"] = 1990.78, ["Mega|Fly|Ride"] = 1625.38}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 24.94, ["Fly|Ride"] = 39.37, ["Neon"] = 19.57, ["Neon|Ride"] = 23.09, ["Neon|Fly|Ride"] = 53.45, ["Mega|Fly"] = 208.52, ["Mega|Ride"] = 91.18, ["Mega|Fly|Ride"] = 153.57}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 18.88, ["Ride"] = 15.67, ["Fly|Ride"] = 31.17, ["Neon"] = 7.87, ["Neon|Fly"] = 54.25, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 64.32, ["Mega"] = 131.78, ["Mega|Ride"] = 140.42, ["Mega|Fly|Ride"] = 162.75}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.63, ["Ride"] = 18.98, ["Fly|Ride"] = 98.44, ["Neon"] = 39.38, ["Mega"] = 140.42}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 354.38, ["Ride"] = 334.17, ["Fly|Ride"] = 576.21, ["Neon|Ride"] = 1539.28, ["Neon|Fly|Ride"] = 1814.75, ["Mega|Ride"] = 8382.14, ["Mega|Fly|Ride"] = 4769.78}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.1, ["Fly"] = 23.99, ["Ride"] = 18.38, ["Fly|Ride"] = 42, ["Neon"] = 12.33, ["Neon|Fly"] = 154.63, ["Neon|Ride"] = 59.19, ["Neon|Fly|Ride"] = 77.33, ["Mega"] = 266.14, ["Mega|Ride"] = 209.57, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 3.87, ["Fly"] = 123.44, ["Ride"] = 39.45, ["Fly|Ride"] = 209.54, ["Neon"] = 36.69, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 224.24, ["Mega"] = 224.23, ["Mega|Ride"] = 204.75, ["Mega|Fly|Ride"] = 306.92}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 91.88, ["Neon"] = 3.93, ["Neon|Ride"] = 25.09, ["Neon|Fly|Ride"] = 140.42, ["Mega"] = 39.83, ["Mega|Ride"] = 94.5, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 18.38, ["Fly"] = 83.84, ["Ride"] = 27.67, ["Fly|Ride"] = 60.78, ["Neon"] = 145.66, ["Neon|Ride"] = 91.02, ["Neon|Fly|Ride"] = 127.32, ["Mega"] = 571.14, ["Mega|Ride"] = 405.5, ["Mega|Fly|Ride"] = 769.08}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 38.06, ["Ride"] = 77.22, ["Fly|Ride"] = 128.07, ["Neon"] = 137.92, ["Neon|Fly"] = 308.11, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 218.19, ["Mega"] = 418.95, ["Mega|Fly"] = 586.77, ["Mega|Ride"] = 518.65, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 23.08, ["Fly"] = 131.25, ["Ride"] = 44.01, ["Fly|Ride"] = 91.16, ["Neon"] = 131.25, ["Neon|Ride"] = 167.66, ["Neon|Fly|Ride"] = 230.14, ["Mega|Ride"] = 783.12, ["Mega|Fly|Ride"] = 740.79}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 15.7, ["Ride"] = 71.46, ["Fly|Ride"] = 51.45, ["Neon"] = 2.1, ["Neon|Fly"] = 20.97, ["Neon|Ride"] = 18.87, ["Neon|Fly|Ride"] = 56.59, ["Mega"] = 18.38, ["Mega|Fly"] = 52.4, ["Mega|Ride"] = 62.89, ["Mega|Fly|Ride"] = 115.5}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 203.04, ["Fly"] = 223.13, ["Ride"] = 262.5, ["Fly|Ride"] = 313.69, ["Neon"] = 908.42, ["Neon|Ride"] = 906.94, ["Neon|Fly|Ride"] = 1317.75, ["Mega|Fly|Ride"] = 3576.76}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 12.48, ["Fly"] = 140.39, ["Ride"] = 39.37, ["Neon"] = 118.13, ["Neon|Ride"] = 156.19, ["Mega"] = 628.67, ["Mega|Ride"] = 523.89, ["Mega|Fly|Ride"] = 519.7}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 24.94, ["Ride"] = 28.25, ["Fly|Ride"] = 52.5, ["Neon"] = 5.25, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 55.47, ["Mega|Fly"] = 111.57, ["Mega|Ride"] = 140.42, ["Mega|Fly|Ride"] = 279.77}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 140.42, ["Ride"] = 17.07, ["Neon"] = 2.63, ["Neon|Ride"] = 22.44, ["Neon|Fly|Ride"] = 104.79, ["Mega"] = 19.69, ["Mega|Fly"] = 137.28, ["Mega|Ride"] = 5999.72, ["Mega|Fly|Ride"] = 105.89}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 3.89, ["Ride"] = 26.25, ["Fly|Ride"] = 78.6, ["Neon"] = 38.07, ["Neon|Fly|Ride"] = 182.33, ["Mega"] = 86.03, ["Mega|Ride"] = 116.79, ["Mega|Fly|Ride"] = 419.12}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 9.19, ["Fly"] = 32.29, ["Ride"] = 27.04, ["Fly|Ride"] = 67.02, ["Neon"] = 41.47, ["Neon|Ride"] = 59.73, ["Neon|Fly|Ride"] = 140.42, ["Mega"] = 539.62, ["Mega|Ride"] = 360.99, ["Mega|Fly|Ride"] = 445.6}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 7.86, ["Ride"] = 26.25, ["Neon"] = 101.07, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 210, ["Mega|Ride"] = 357.7, ["Mega|Fly|Ride"] = 446.36}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 52.39, ["Fly|Ride"] = 49.25, ["Neon"] = 3.65, ["Neon|Ride"] = 45.94, ["Mega"] = 15.74, ["Mega|Ride"] = 90.13, ["Mega|Fly|Ride"] = 127.32}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 9.14, ["Ride"] = 27.57, ["Fly|Ride"] = 94.31, ["Neon"] = 35.36, ["Neon|Fly"] = 102.92, ["Neon|Ride"] = 56.59, ["Neon|Fly|Ride"] = 119.45, ["Mega"] = 146.55, ["Mega|Ride"] = 261.95, ["Mega|Fly|Ride"] = 283.5}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 210, ["Neon"] = 6.95, ["Neon|Ride"] = 91.88, ["Mega"] = 31.5, ["Mega|Ride"] = 94.32, ["Mega|Fly|Ride"] = 616.13}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 40.05, ["Ride"] = 24.94, ["Fly|Ride"] = 67.1, ["Neon"] = 6.56, ["Neon|Ride"] = 27.26, ["Neon|Fly|Ride"] = 116.31, ["Mega"] = 91.88, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 195.8}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 1265.73, ["Ride"] = 1181.25, ["Fly|Ride"] = 1649, ["Neon|Fly|Ride"] = 4744.78, ["Mega|Fly|Ride"] = 13845.47}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 19.69, ["Fly|Ride"] = 44.01, ["Neon"] = 15.75, ["Neon|Fly"] = 28.88, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 111.07, ["Mega"] = 187.57, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.61, ["Ride"] = 41.92, ["Fly|Ride"] = 59.07, ["Neon"] = 2.63, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 34.61, ["Mega|Ride"] = 104.98, ["Mega|Fly|Ride"] = 203.41}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 7.87, ["Fly"] = 46.11, ["Ride"] = 19.69, ["Fly|Ride"] = 56.39, ["Neon"] = 39.38, ["Neon|Fly"] = 56.59, ["Neon|Ride"] = 39.35, ["Neon|Fly|Ride"] = 93, ["Mega|Ride"] = 441.13, ["Mega|Fly|Ride"] = 306.92}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 16.87, ["Fly|Ride"] = 31.5, ["Neon"] = 7.8, ["Neon|Fly"] = 89.24, ["Neon|Ride"] = 23.06, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 73.37, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 199.5}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 44.62, ["Neon"] = 317.48, ["Neon|Ride"] = 338.63, ["Mega"] = 769.13, ["Mega|Ride"] = 1032.65}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 30.19, ["Neon"] = 7.69, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 108.48, ["Mega"] = 87.02, ["Mega|Ride"] = 140.42, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 3.87, ["Fly"] = 73.5, ["Ride"] = 31.16, ["Fly|Ride"] = 65.63, ["Neon"] = 13.12, ["Neon|Fly"] = 146.71, ["Neon|Ride"] = 54.5, ["Neon|Fly|Ride"] = 140.42, ["Mega"] = 125.74, ["Mega|Ride"] = 293.4, ["Mega|Fly|Ride"] = 419.12}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly|Ride"] = 65.23, ["Neon"] = 20.74, ["Neon|Fly"] = 62.33, ["Mega"] = 78.75, ["Mega|Ride"] = 154.62}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 2593.49, ["Ride"] = 23.36, ["Fly|Ride"] = 98.44, ["Neon"] = 3.87, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 92.32, ["Mega"] = 19.69, ["Mega|Fly"] = 108.98, ["Mega|Ride"] = 83.84, ["Mega|Fly|Ride"] = 138.48}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 17.3, ["Fly"] = 37.57, ["Ride"] = 26.25, ["Fly|Ride"] = 53.82, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 78.73, ["Mega"] = 838.23, ["Mega|Ride"] = 518.65, ["Mega|Fly|Ride"] = 456.09}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 820.31, ["Ride"] = 845.38, ["Fly|Ride"] = 978.51, ["Neon"] = 2100, ["Neon|Ride"] = 2305.1, ["Neon|Fly|Ride"] = 2162.61, ["Mega"] = 6985.49, ["Mega|Ride"] = 5643.75, ["Mega|Fly|Ride"] = 5144.99}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 66.94, ["Ride"] = 20.9, ["Fly|Ride"] = 45.06, ["Neon"] = 5.24, ["Neon|Fly"] = 28.3, ["Neon|Ride"] = 27.55, ["Neon|Fly|Ride"] = 69.17, ["Mega"] = 27.57, ["Mega|Fly"] = 108.98, ["Mega|Ride"] = 77.32, ["Mega|Fly|Ride"] = 101.07}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 7.87, ["Ride"] = 38.66, ["Neon"] = 39.37, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 335.3, ["Mega"] = 274.32, ["Mega|Ride"] = 259.86, ["Mega|Fly|Ride"] = 441}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 92.3, ["Fly"] = 144.38, ["Ride"] = 104.99, ["Fly|Ride"] = 138.3, ["Neon|Ride"] = 462.09, ["Neon|Fly|Ride"] = 727.16, ["Mega"] = 2923.72, ["Mega|Fly|Ride"] = 3062.07}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 35.44, ["Ride"] = 70.32, ["Fly|Ride"] = 301.88, ["Neon"] = 279.77, ["Neon|Ride"] = 177.19, ["Mega"] = 824.61, ["Mega|Ride"] = 731.36, ["Mega|Fly|Ride"] = 707.25}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 12.86, ["Fly|Ride"] = 317.45, ["Neon"] = 83.35, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 223.86, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 492.47}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 56.59, ["Ride"] = 112.35, ["Neon"] = 133.07, ["Neon|Ride"] = 354.25, ["Mega"] = 279.78, ["Mega|Ride"] = 340.74, ["Mega|Fly|Ride"] = 431.17}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 28.11, ["Ride"] = 315, ["Neon"] = 183.75, ["Neon|Ride"] = 314.34, ["Neon|Fly|Ride"] = 525, ["Mega"] = 721.88, ["Mega|Ride"] = 778.28, ["Mega|Fly|Ride"] = 772.42}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 7.82}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 4.59, ["Ride"] = 128.63, ["Neon"] = 59.12, ["Neon|Ride"] = 83.84, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 223.36, ["Mega|Ride"] = 216.57, ["Mega|Fly|Ride"] = 417.03}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 3.82, ["Neon"] = 33.54, ["Mega"] = 861.9, ["Mega|Fly|Ride"] = 943.01}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 52.5, ["Fly"] = 62.99, ["Ride"] = 66.93, ["Fly|Ride"] = 116.81, ["Neon"] = 209.57, ["Neon|Ride"] = 208.22, ["Neon|Fly|Ride"] = 413.86, ["Mega|Ride"] = 681.19, ["Mega|Fly|Ride"] = 784.88}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.46, ["Fly"] = 18.47, ["Ride"] = 17.07, ["Fly|Ride"] = 38.07, ["Neon"] = 27.83, ["Neon|Fly"] = 41.92, ["Neon|Ride"] = 31.34, ["Neon|Fly|Ride"] = 76.17, ["Mega"] = 308.07, ["Mega|Ride"] = 137.82, ["Mega|Fly|Ride"] = 241.5}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 6.56, ["Fly"] = 98.51, ["Ride"] = 28.12, ["Fly|Ride"] = 91.88, ["Neon"] = 45, ["Neon|Ride"] = 56.59, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 157.49, ["Mega|Fly"] = 301.45, ["Mega|Ride"] = 200.19, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 7.62, ["Neon|Ride"] = 197.33, ["Mega"] = 45.05}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 33.45, ["Ride"] = 77.55, ["Fly|Ride"] = 78.72, ["Neon"] = 182.33, ["Neon|Ride"] = 310.15, ["Neon|Fly|Ride"] = 279.78, ["Mega"] = 1077.65, ["Mega|Ride"] = 819.2, ["Mega|Fly|Ride"] = 736.72}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Neon"] = 11.47, ["Neon|Fly"] = 145.69, ["Mega"] = 125.74, ["Mega|Ride"] = 208.52}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 7.76, ["Ride"] = 140.63, ["Neon"] = 65.63, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 293.4, ["Mega"] = 293.4, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 607.72}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 23.08, ["Ride"] = 18.47, ["Fly|Ride"] = 61.69, ["Neon"] = 27.26, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 68.09, ["Mega|Ride"] = 196.23, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 4.64, ["Fly"] = 52.5, ["Ride"] = 24.94, ["Fly|Ride"] = 49.88, ["Neon"] = 52.5, ["Neon|Ride"] = 125.74, ["Mega"] = 308.07, ["Mega|Ride"] = 418.07, ["Mega|Fly|Ride"] = 324.82}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 3.13, ["Ride"] = 103.73, ["Neon"] = 20.96, ["Neon|Ride"] = 111.57, ["Mega"] = 140.6, ["Mega|Ride"] = 534.85, ["Mega|Fly|Ride"] = 417.03}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 28.88, ["Ride"] = 143.07, ["Neon"] = 190.32, ["Neon|Ride"] = 356.26, ["Mega"] = 904.23, ["Mega|Ride"] = 1257.33, ["Mega|Fly|Ride"] = 870.19}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 18.34, ["Ride"] = 246.21, ["Neon"] = 116.82, ["Neon|Fly|Ride"] = 385.41, ["Mega"] = 359.63, ["Mega|Ride"] = 448.46}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 11.68, ["Ride"] = 105, ["Neon"] = 91.62, ["Neon|Ride"] = 393.75, ["Mega"] = 279.78, ["Mega|Ride"] = 1540.32, ["Mega|Fly|Ride"] = 1676.45}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 39.37, ["Ride"] = 105, ["Fly|Ride"] = 422.03, ["Neon"] = 461.46, ["Mega"] = 766.5, ["Mega|Ride"] = 708.75, ["Mega|Fly|Ride"] = 671.35}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 2.1, ["Neon"] = 44.63, ["Mega"] = 249.38, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 28.3, ["Ride"] = 20.77, ["Fly|Ride"] = 50.3, ["Neon"] = 6.57, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 137.82, ["Mega"] = 95.37, ["Mega|Ride"] = 104.79, ["Mega|Fly|Ride"] = 256.6}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 9.13, ["Ride"] = 91.88, ["Fly|Ride"] = 91.17, ["Neon"] = 28.88, ["Neon|Ride"] = 89.61, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 198, ["Mega|Ride"] = 262.78}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 32.07, ["Ride"] = 23.06, ["Fly|Ride"] = 55.13, ["Neon"] = 6.57, ["Neon|Ride"] = 28.3, ["Neon|Fly|Ride"] = 88.03, ["Mega"] = 40.08, ["Mega|Ride"] = 96.15, ["Mega|Fly|Ride"] = 140.42}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 3.94, ["Ride"] = 19.69, ["Fly|Ride"] = 108.46, ["Neon"] = 13.13, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 259.86, ["Mega"] = 249.38, ["Mega|Ride"] = 150.94, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.54, ["Ride"] = 31.44, ["Fly|Ride"] = 83.83, ["Neon"] = 62.33, ["Neon|Ride"] = 112.12, ["Mega"] = 419.12, ["Mega|Fly|Ride"] = 698.87}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 13.13, ["Fly"] = 41.92, ["Ride"] = 22.32, ["Fly|Ride"] = 56.59, ["Neon"] = 27.56, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 45.92, ["Neon|Fly|Ride"] = 105, ["Mega"] = 231.57, ["Mega|Fly"] = 187.57, ["Mega|Ride"] = 118.12, ["Mega|Fly|Ride"] = 201.2}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 34.07, ["Ride"] = 23.16, ["Fly|Ride"] = 67.06, ["Neon"] = 23.09, ["Neon|Ride"] = 50.31, ["Neon|Fly|Ride"] = 108.48, ["Mega"] = 166.68, ["Mega|Ride"] = 140.42, ["Mega|Fly|Ride"] = 489.33}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 3.73, ["Ride"] = 347.26, ["Neon"] = 9.19, ["Neon|Fly"] = 63.19, ["Neon|Ride"] = 98.51, ["Neon|Fly|Ride"] = 455.79, ["Mega"] = 63.32, ["Mega|Ride"] = 305.82, ["Mega|Fly|Ride"] = 292.04}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 6.3, ["Ride"] = 32.82, ["Fly|Ride"] = 272.4, ["Neon"] = 39.82, ["Neon|Ride"] = 122.07, ["Mega"] = 367.5, ["Mega|Fly"] = 656.25, ["Mega|Ride"] = 496.65, ["Mega|Fly|Ride"] = 486.19}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 37.41, ["Fly"] = 196.1, ["Ride"] = 87.28, ["Fly|Ride"] = 291.38, ["Neon"] = 279.57, ["Neon|Ride"] = 232.32, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 1676.45, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1000.35}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Ride"] = 19.92, ["Neon"] = 2.63, ["Neon|Ride"] = 37.46, ["Mega"] = 30.19, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 94.5}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 9.22, ["Ride"] = 131.25, ["Neon"] = 56.59, ["Mega"] = 312.38, ["Mega|Ride"] = 405.5, ["Mega|Fly|Ride"] = 1243.71}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 53.68, ["Ride"] = 115.5, ["Neon"] = 482.37, ["Neon|Ride"] = 1117.98, ["Mega|Ride"] = 1102.26, ["Mega|Fly|Ride"] = 1207.43}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 6.29, ["Fly"] = 190.32, ["Ride"] = 38.9, ["Fly|Ride"] = 126, ["Neon"] = 39.37, ["Neon|Ride"] = 99.52, ["Neon|Fly|Ride"] = 140.42, ["Mega"] = 157.5, ["Mega|Ride"] = 182.33, ["Mega|Fly|Ride"] = 279.78}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 2.1, ["Fly"] = 157.5, ["Ride"] = 62.87, ["Fly|Ride"] = 116.3, ["Neon"] = 5.25, ["Neon|Ride"] = 27.53, ["Mega"] = 26.87, ["Mega|Ride"] = 53.82, ["Mega|Fly|Ride"] = 172.17}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 16.78, ["Fly|Ride"] = 107.62, ["Neon"] = 18.38, ["Neon|Ride"] = 35.28, ["Neon|Fly|Ride"] = 125.74, ["Mega"] = 286.15, ["Mega|Ride"] = 103.69, ["Mega|Fly|Ride"] = 231}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 18.87, ["Ride"] = 18.79, ["Neon"] = 3.94, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 23.63, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 91.88}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 24.94, ["Fly|Ride"] = 65.7, ["Neon"] = 3.94, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 83.32, ["Mega"] = 34.92, ["Mega|Fly"] = 168, ["Mega|Ride"] = 66.03, ["Mega|Fly|Ride"] = 149.63}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Neon"] = 2.37, ["Neon|Ride"] = 41.92, ["Mega"] = 31.16, ["Mega|Ride"] = 104.79, ["Mega|Fly|Ride"] = 257.76}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 13.13, ["Ride"] = 157.5, ["Fly|Ride"] = 356.21, ["Neon"] = 34.23, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 628.67, ["Mega"] = 213.94, ["Mega|Ride"] = 293.08, ["Mega|Fly|Ride"] = 1116.93}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 4.6, ["Ride"] = 41.94, ["Fly|Ride"] = 140.39, ["Neon"] = 124.43, ["Neon|Ride"] = 167.66, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 222.14, ["Mega|Ride"] = 405.5, ["Mega|Fly|Ride"] = 698.87}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 6.3, ["Fly"] = 24.93, ["Ride"] = 19.67, ["Fly|Ride"] = 59.07, ["Neon"] = 59.73, ["Neon|Fly"] = 123.47, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 89.25, ["Mega"] = 317.63, ["Mega|Ride"] = 349.97, ["Mega|Fly|Ride"] = 377.27}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 62.99, ["Ride"] = 91.88, ["Fly|Ride"] = 182.47, ["Neon"] = 414.93, ["Neon|Ride"] = 523.89, ["Mega"] = 3077.17, ["Mega|Ride"] = 2095.55, ["Mega|Fly|Ride"] = 1539.18}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 13.12, ["Ride"] = 41.36, ["Neon"] = 44.63, ["Neon|Fly"] = 125.74, ["Mega"] = 613.59, ["Mega|Fly"] = 643.34, ["Mega|Ride"] = 600.48, ["Mega|Fly|Ride"] = 1029.67}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 20.97, ["Ride"] = 22.93, ["Fly|Ride"] = 56.59, ["Neon"] = 3.29, ["Neon|Fly"] = 41.92, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 38.99, ["Mega|Ride"] = 107.63, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 15.43, ["Ride"] = 16.78, ["Fly|Ride"] = 39.58, ["Neon"] = 7.62, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 23.06, ["Neon|Fly|Ride"] = 41.92, ["Mega"] = 38.07, ["Mega|Ride"] = 70.22, ["Mega|Fly|Ride"] = 114.51}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 485.63, ["Fly"] = 523.89, ["Ride"] = 447.2, ["Fly|Ride"] = 511.88, ["Neon|Fly|Ride"] = 1890.03}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 13.13, ["Ride"] = 139.6, ["Neon"] = 81.36, ["Neon|Ride"] = 279.78, ["Neon|Fly|Ride"] = 398.18, ["Mega"] = 495.48, ["Mega|Ride"] = 496.65, ["Mega|Fly|Ride"] = 784.6}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 26.88, ["Ride"] = 17.07, ["Fly|Ride"] = 41.92, ["Neon"] = 5.25, ["Neon|Ride"] = 20.82, ["Neon|Fly|Ride"] = 66.99, ["Mega|Ride"] = 71.55, ["Mega|Fly|Ride"] = 83.84}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 73.5, ["Ride"] = 111.43, ["Fly|Ride"] = 315, ["Neon"] = 211.95, ["Neon|Ride"] = 292.64, ["Neon|Fly|Ride"] = 475.71, ["Mega"] = 1041.38, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 1015.4}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 45.07, ["Ride"] = 17.07, ["Fly|Ride"] = 81.74, ["Neon"] = 7.86, ["Neon|Fly"] = 91.18, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 118.12, ["Mega|Ride"] = 115.5, ["Mega|Fly|Ride"] = 206.09}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.05, ["Ride"] = 97.13, ["Fly|Ride"] = 1312.5, ["Neon"] = 2.42, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 280.65, ["Mega"] = 17.05, ["Mega|Ride"] = 83.99, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 45.93, ["Ride"] = 118.02, ["Neon"] = 162.07, ["Neon|Fly"] = 454.74, ["Neon|Ride"] = 209.57, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 766.5, ["Mega|Ride"] = 824.25, ["Mega|Fly|Ride"] = 786.19}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Neon"] = 10.43, ["Neon|Ride"] = 50.31, ["Mega"] = 96.94, ["Mega|Ride"] = 92.32, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 40.69, ["Fly"] = 140.42, ["Ride"] = 66.93, ["Fly|Ride"] = 207.44, ["Neon"] = 187.57, ["Neon|Ride"] = 201.2, ["Neon|Fly|Ride"] = 259.86, ["Mega|Ride"] = 1674.36}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 7.88, ["Ride"] = 31.45, ["Neon"] = 18.87, ["Neon|Ride"] = 419.12, ["Mega"] = 170.63, ["Mega|Ride"] = 822.94, ["Mega|Fly|Ride"] = 486.29}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.1, ["Fly"] = 70.22, ["Ride"] = 70.9, ["Neon"] = 6.57, ["Neon|Fly"] = 62.89, ["Neon|Ride"] = 171.94, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 420, ["Mega|Ride"] = 569.63, ["Mega|Fly|Ride"] = 559.53}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 27.57, ["Ride"] = 46.16, ["Fly|Ride"] = 140.39, ["Neon"] = 559.53, ["Mega|Ride"] = 1100.17, ["Mega|Fly|Ride"] = 1231.11}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.63, ["Fly"] = 131.62, ["Ride"] = 89.25, ["Fly|Ride"] = 239.97, ["Neon"] = 6.57, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 83.84, ["Neon|Fly|Ride"] = 140.42, ["Mega"] = 45.94, ["Mega|Fly"] = 158.61, ["Mega|Ride"] = 82.85, ["Mega|Fly|Ride"] = 268.57}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 27.26, ["Ride"] = 23.6, ["Fly|Ride"] = 72.17, ["Neon"] = 64.89, ["Neon|Fly"] = 41.88, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 209.57, ["Mega|Fly|Ride"] = 284.17}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 9.19, ["Ride"] = 28.3, ["Neon"] = 39.38, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 100.41, ["Mega"] = 254.63, ["Mega|Ride"] = 419.12, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 26.25, ["Ride"] = 60.38, ["Fly|Ride"] = 369.2, ["Neon"] = 145.63, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 513.19, ["Mega|Ride"] = 669.38, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 20.77, ["Fly"] = 30.17, ["Ride"] = 41.92, ["Fly|Ride"] = 78.11, ["Neon"] = 103.69, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 237.86, ["Mega"] = 406.55, ["Mega|Ride"] = 462.09, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 64.84, ["Fly"] = 196.88, ["Ride"] = 111.57, ["Fly|Ride"] = 268.37, ["Neon"] = 342.27, ["Neon|Ride"] = 371.44, ["Neon|Fly|Ride"] = 374.07, ["Mega"] = 1260, ["Mega|Ride"] = 1302, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 3.93, ["Ride"] = 32.01, ["Fly|Ride"] = 262.5, ["Neon"] = 15.73, ["Neon|Ride"] = 140.41, ["Neon|Fly|Ride"] = 314.34, ["Mega"] = 134.39, ["Mega|Ride"] = 154.62, ["Mega|Fly|Ride"] = 327.48}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 4.64, ["Ride"] = 39.82, ["Fly|Ride"] = 108.97, ["Neon"] = 21.9, ["Neon|Ride"] = 69.17, ["Mega"] = 105, ["Mega|Ride"] = 200.5}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 15.68, ["Fly"] = 105, ["Ride"] = 28.72, ["Fly|Ride"] = 157.5, ["Neon"] = 121.84, ["Neon|Ride"] = 136.23, ["Mega"] = 366.19, ["Mega|Ride"] = 559.53, ["Mega|Fly|Ride"] = 458.07}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.05, ["Fly"] = 15.75, ["Ride"] = 15.64, ["Fly|Ride"] = 37.73, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 17.33, ["Neon|Fly|Ride"] = 62.33, ["Mega"] = 14.34, ["Mega|Fly"] = 77.32, ["Mega|Ride"] = 25.16, ["Mega|Fly|Ride"] = 98.44}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 43.32, ["Fly"] = 140.42, ["Ride"] = 419.07, ["Neon"] = 369.25, ["Neon|Fly"] = 2375.3, ["Neon|Ride"] = 291.37, ["Neon|Fly|Ride"] = 419.12, ["Mega"] = 1146.28, ["Mega|Fly"] = 957.68, ["Mega|Ride"] = 976.54, ["Mega|Fly|Ride"] = 936.57}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 23.08, ["Fly|Ride"] = 89.24, ["Neon"] = 6.43, ["Neon|Ride"] = 52.5, ["Mega"] = 106.88, ["Mega|Fly"] = 112.12, ["Mega|Fly|Ride"] = 210.76}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 28.3, ["Ride"] = 23.05, ["Fly|Ride"] = 62.87, ["Neon"] = 20.31, ["Neon|Ride"] = 31.23, ["Neon|Fly|Ride"] = 70.22, ["Mega|Ride"] = 209.57, ["Mega|Fly|Ride"] = 279.78}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 65.63, ["Fly"] = 209.57, ["Ride"] = 105.67, ["Fly|Ride"] = 349.93, ["Neon"] = 196.88, ["Neon|Ride"] = 211.97, ["Neon|Fly|Ride"] = 598.29, ["Mega"] = 958.13, ["Mega|Ride"] = 912.19, ["Mega|Fly|Ride"] = 1010.63}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 56.59, ["Neon"] = 7.9, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 105.02, ["Mega"] = 50.88, ["Mega|Ride"] = 75.47, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 19.58}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 30.19, ["Fly|Ride"] = 146.74, ["Neon"] = 5.24, ["Neon|Ride"] = 49.26, ["Neon|Fly|Ride"] = 140.42, ["Mega"] = 40.69, ["Mega|Ride"] = 115.5, ["Mega|Fly|Ride"] = 397.91}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 118.13, ["Ride"] = 196.88, ["Fly|Ride"] = 209.54, ["Neon"] = 626.58, ["Neon|Ride"] = 702.19, ["Neon|Fly|Ride"] = 735, ["Mega"] = 4191.09, ["Mega|Fly|Ride"] = 2493.75}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 6.46, ["Ride"] = 25.16, ["Neon"] = 18.38, ["Neon|Ride"] = 61.69, ["Mega"] = 279.78, ["Mega|Ride"] = 294.23, ["Mega|Fly|Ride"] = 400.26}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 209.57, ["Neon"] = 6.57, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 26.25, ["Mega|Fly|Ride"] = 312.9}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 7.88, ["Ride"] = 30.85, ["Neon"] = 42, ["Neon|Ride"] = 140.42, ["Neon|Fly|Ride"] = 154.62, ["Mega"] = 388.74, ["Mega|Ride"] = 601.43, ["Mega|Fly|Ride"] = 616.13}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 12.59, ["Fly"] = 74.41, ["Ride"] = 24.94, ["Neon"] = 145.69, ["Neon|Fly|Ride"] = 270.35, ["Mega"] = 349.97, ["Mega|Ride"] = 469.42, ["Mega|Fly|Ride"] = 559.53}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 19.36, ["Ride"] = 65.71, ["Neon"] = 145.9, ["Neon|Ride"] = 195.57, ["Neon|Fly|Ride"] = 266.13, ["Mega"] = 586.77, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 140.43, ["Fly"] = 208.52, ["Ride"] = 135.92, ["Fly|Ride"] = 195.57, ["Neon"] = 628.67, ["Neon|Ride"] = 548.63, ["Neon|Fly|Ride"] = 695.73, ["Mega|Fly|Ride"] = 3057.39}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 7.01, ["Fly"] = 17.31, ["Ride"] = 19.51, ["Fly|Ride"] = 39.38, ["Neon"] = 35.44, ["Neon|Ride"] = 59.06, ["Neon|Fly|Ride"] = 73.48, ["Mega|Ride"] = 698.87, ["Mega|Fly|Ride"] = 360.94}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.63, ["Fly"] = 105, ["Ride"] = 43.98, ["Neon"] = 18.87, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 124.69, ["Mega"] = 136.17, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 349.97}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 7.76, ["Fly"] = 230.71, ["Ride"] = 71.22, ["Fly|Ride"] = 78.75, ["Neon"] = 70.11, ["Neon|Ride"] = 308.11, ["Mega"] = 499.87, ["Mega|Ride"] = 461.53, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 35.44, ["Ride"] = 47.25, ["Fly|Ride"] = 124.69, ["Neon"] = 154.75, ["Neon|Ride"] = 209.57, ["Neon|Fly|Ride"] = 294, ["Mega"] = 845.56, ["Mega|Fly"] = 978.63, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 866.19}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 16.94, ["Fly"] = 65.63, ["Ride"] = 81.84, ["Neon"] = 131.25, ["Neon|Ride"] = 209.57, ["Mega"] = 656.25, ["Mega|Ride"] = 733.46, ["Mega|Fly|Ride"] = 523.89}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 288.74, ["Ride"] = 413.44, ["Fly|Ride"] = 459.38, ["Neon"] = 1998.11, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1570.62, ["Mega|Ride"] = 3937.5, ["Mega|Fly|Ride"] = 5656.9}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 19.69, ["Fly"] = 140.42, ["Ride"] = 32.82, ["Fly|Ride"] = 83.83, ["Neon"] = 279.78, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 1195.69, ["Mega|Ride"] = 531.24, ["Mega|Fly|Ride"] = 689.45}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 28.3, ["Ride"] = 16.78, ["Fly|Ride"] = 32.82, ["Neon"] = 2.1, ["Neon|Ride"] = 19.94, ["Neon|Fly|Ride"] = 61.69, ["Mega"] = 21, ["Mega|Fly"] = 17.07, ["Mega|Ride"] = 64.97, ["Mega|Fly|Ride"] = 129.36}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 3.94, ["Ride"] = 211.02, ["Neon"] = 14.44, ["Neon|Ride"] = 39.38, ["Mega"] = 125.93, ["Mega|Ride"] = 264.06, ["Mega|Fly|Ride"] = 460.04}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 2.63, ["Ride"] = 102.37, ["Neon"] = 34.63, ["Neon|Ride"] = 77.33, ["Neon|Fly|Ride"] = 1181.25, ["Mega"] = 71.06, ["Mega|Fly"] = 224.24, ["Mega|Ride"] = 279.78, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 392.44, ["Fly"] = 576.77, ["Ride"] = 412.13, ["Fly|Ride"] = 435.16, ["Neon"] = 1462.71, ["Neon|Ride"] = 1362.12, ["Neon|Fly|Ride"] = 1345.32, ["Mega|Fly|Ride"] = 4819.75}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 3.93, ["Fly"] = 70.22, ["Ride"] = 15.74, ["Fly|Ride"] = 56.44, ["Neon"] = 44.02, ["Neon|Ride"] = 69.57, ["Neon|Fly|Ride"] = 70.22, ["Mega|Ride"] = 312.69, ["Mega|Fly|Ride"] = 460.67}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 8.4, ["Fly"] = 31.77, ["Ride"] = 19.67, ["Fly|Ride"] = 45.94, ["Neon|Ride"] = 56.59, ["Neon|Fly|Ride"] = 98.51, ["Mega"] = 417.03, ["Mega|Ride"] = 698.87, ["Mega|Fly|Ride"] = 329.02}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 5.24, ["Fly"] = 83.84, ["Ride"] = 28.29, ["Fly|Ride"] = 103.84, ["Neon"] = 13.09, ["Neon|Fly"] = 70.22, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 128.09, ["Mega"] = 138.48, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 486.19}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 53.45, ["Fly"] = 210, ["Fly|Ride"] = 70.2, ["Neon"] = 118.13, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 837.18, ["Mega|Fly|Ride"] = 613.83}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 315, ["Ride"] = 62.35, ["Fly|Ride"] = 41.92, ["Neon"] = 15.75, ["Neon|Ride"] = 77.33, ["Neon|Fly|Ride"] = 210, ["Mega|Ride"] = 108.47, ["Mega|Fly|Ride"] = 620.17}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 3.93, ["Fly"] = 104.15, ["Ride"] = 27.25, ["Fly|Ride"] = 91.88, ["Neon"] = 154.63, ["Neon|Ride"] = 141.75, ["Mega"] = 698.87, ["Mega|Ride"] = 349.97, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 5.08, ["Neon|Ride"] = 32.49, ["Mega"] = 85.32, ["Mega|Ride"] = 2555.52, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 12.39, ["Neon"] = 78.6, ["Mega"] = 224.24, ["Mega|Ride"] = 338.63, ["Mega|Fly|Ride"] = 628.67}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 10.48, ["Ride"] = 70.22, ["Neon"] = 154.35, ["Neon|Fly|Ride"] = 209.57, ["Mega"] = 309.1, ["Mega|Ride"] = 279.78, ["Mega|Fly|Ride"] = 1039.4}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 13.62, ["Fly"] = 27.57, ["Ride"] = 23.3, ["Fly|Ride"] = 52.5, ["Neon"] = 50.31, ["Neon|Ride"] = 77.27, ["Neon|Fly|Ride"] = 108.3, ["Mega"] = 405.5, ["Mega|Ride"] = 375.38, ["Mega|Fly|Ride"] = 470.4}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 209.77, ["Fly"] = 498.75, ["Ride"] = 211.32, ["Fly|Ride"] = 280.72, ["Neon"] = 945.1, ["Neon|Ride"] = 923.11, ["Neon|Fly|Ride"] = 842.45, ["Mega|Fly|Ride"] = 4191.09}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Fly"] = 21.2, ["Ride"] = 15.73, ["Fly|Ride"] = 64.97, ["Neon"] = 20.97, ["Neon|Ride"] = 36.69, ["Neon|Fly|Ride"] = 108.29, ["Mega"] = 209.57, ["Mega|Ride"] = 321.67, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 3.24, ["Fly"] = 32.82, ["Ride"] = 23.63, ["Fly|Ride"] = 77.7, ["Neon"] = 17.31, ["Neon|Ride"] = 56.59, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 137.82, ["Mega|Ride"] = 769.6, ["Mega|Fly|Ride"] = 410.82}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 31.5, ["Ride"] = 98.44, ["Fly|Ride"] = 157.5, ["Neon"] = 131.25, ["Neon|Ride"] = 216.43, ["Neon|Fly|Ride"] = 559.53, ["Mega"] = 414.75, ["Mega|Ride"] = 341.64, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 57.74, ["Ride"] = 92.21, ["Fly|Ride"] = 204.3, ["Neon"] = 283.74, ["Neon|Ride"] = 461.56, ["Neon|Fly|Ride"] = 479.74, ["Mega"] = 1361.07, ["Mega|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 1357.92}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 19.67, ["Ride"] = 68.25, ["Fly|Ride"] = 209.54, ["Neon"] = 81.73, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 279.78, ["Mega"] = 179.54, ["Mega|Ride"] = 282.19, ["Mega|Fly|Ride"] = 349.13}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 22.01, ["Fly|Ride"] = 38.93, ["Neon"] = 15.73, ["Mega"] = 123.47, ["Mega|Fly|Ride"] = 349.97}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 11.82, ["Fly"] = 31.5, ["Fly|Ride"] = 82.79, ["Neon"] = 50.3, ["Neon|Ride"] = 138.32, ["Neon|Fly|Ride"] = 419.11, ["Mega"] = 209.43, ["Mega|Ride"] = 280.61, ["Mega|Fly|Ride"] = 329.44}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 75.48, ["Ride"] = 111.57, ["Fly|Ride"] = 183.75, ["Neon"] = 196.88, ["Neon|Ride"] = 284.82, ["Neon|Fly|Ride"] = 419.11, ["Mega"] = 570.94, ["Mega|Ride"] = 479.98, ["Mega|Fly|Ride"] = 554.86}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.1, ["Fly|Ride"] = 91.88, ["Neon"] = 7.87, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 39.38, ["Mega|Fly"] = 98.44, ["Mega|Ride"] = 104.15, ["Mega|Fly|Ride"] = 218.4}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 7.45, ["Ride"] = 288.75, ["Neon"] = 35.64, ["Neon|Ride"] = 653.63, ["Mega"] = 300.72, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 935.13, ["Fly"] = 2095.55, ["Ride"] = 1049.9, ["Fly|Ride"] = 1050, ["Neon|Ride"] = 3075.19, ["Neon|Fly|Ride"] = 3376.99, ["Mega|Fly|Ride"] = 11025}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 31.5, ["Ride"] = 98.49, ["Fly|Ride"] = 222.12, ["Neon"] = 154.63, ["Neon|Ride"] = 337.4, ["Mega"] = 590.63, ["Mega|Ride"] = 508.83, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 6.55, ["Fly"] = 49.18, ["Ride"] = 26.25, ["Fly|Ride"] = 209.54, ["Neon"] = 19.69, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 107.93, ["Mega"] = 89.25, ["Mega|Ride"] = 115.4, ["Mega|Fly|Ride"] = 285.79}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 17.33, ["Ride"] = 131.22, ["Neon"] = 78.75, ["Mega|Ride"] = 329.02, ["Mega|Fly|Ride"] = 769.6}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 49.26, ["Fly|Ride"] = 419.07, ["Neon"] = 2.61, ["Neon|Ride"] = 36.33, ["Neon|Fly|Ride"] = 100.61, ["Mega"] = 16.11, ["Mega|Ride"] = 62.99, ["Mega|Fly|Ride"] = 150.01}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 95.38, ["Ride"] = 161.4, ["Fly|Ride"] = 314.31, ["Neon"] = 341.25, ["Neon|Ride"] = 403.2, ["Neon|Fly|Ride"] = 527.42, ["Mega"] = 1214.35, ["Mega|Ride"] = 1369.45, ["Mega|Fly|Ride"] = 1245.57}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 3.94, ["Fly"] = 101.07, ["Ride"] = 41.92, ["Fly|Ride"] = 807.57, ["Neon"] = 27.23, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 154.63, ["Mega"] = 347.88, ["Mega|Ride"] = 252.79, ["Mega|Fly|Ride"] = 279.78}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 3.91, ["Ride"] = 31.44, ["Neon"] = 14.43, ["Neon|Ride"] = 39.38, ["Mega"] = 170.63, ["Mega|Ride"] = 246.93, ["Mega|Fly|Ride"] = 385.39}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 45.91, ["Fly"] = 107.93, ["Ride"] = 72.18, ["Fly|Ride"] = 131.25, ["Neon"] = 208.16, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 351.02, ["Mega"] = 531.24, ["Mega|Ride"] = 472.5, ["Mega|Fly|Ride"] = 450.19}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 10.47, ["Fly"] = 183.75, ["Neon"] = 85.32, ["Neon|Fly"] = 182.33, ["Neon|Ride"] = 146.71, ["Neon|Fly|Ride"] = 203.44, ["Mega"] = 393.75, ["Mega|Ride"] = 540.67, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 72.17, ["Ride"] = 279.78, ["Neon"] = 514.46, ["Neon|Ride"] = 933.19, ["Neon|Fly|Ride"] = 919.42, ["Mega"] = 1466.9, ["Mega|Ride"] = 1384.57, ["Mega|Fly|Ride"] = 1307.62}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 7.86, ["Ride"] = 83.84, ["Fly|Ride"] = 167.64, ["Neon"] = 38.07, ["Neon|Ride"] = 95.8, ["Neon|Fly|Ride"] = 90.57, ["Mega"] = 164.07, ["Mega|Ride"] = 182.33, ["Mega|Fly|Ride"] = 263}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 9.17, ["Fly"] = 196.88, ["Ride"] = 30.19, ["Fly|Ride"] = 41.92, ["Neon"] = 65.62, ["Neon|Ride"] = 79.65, ["Neon|Fly|Ride"] = 280.88, ["Mega"] = 317.48, ["Mega|Ride"] = 384.55, ["Mega|Fly|Ride"] = 419.12}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 131.23, ["Ride"] = 201.16, ["Fly|Ride"] = 253.14, ["Neon"] = 543.38, ["Neon|Ride"] = 532.88, ["Neon|Fly|Ride"] = 628.67, ["Mega"] = 2362.5, ["Mega|Ride"] = 2361.19, ["Mega|Fly|Ride"] = 1836.19}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.63, ["Fly"] = 39.38, ["Ride"] = 20.93, ["Fly|Ride"] = 56.59, ["Neon"] = 22.02, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 71.24, ["Mega"] = 180.23, ["Mega|Ride"] = 160.13, ["Mega|Fly|Ride"] = 146.88}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 6.57, ["Fly"] = 87.94, ["Ride"] = 22.32, ["Fly|Ride"] = 57.75, ["Neon"] = 18.72, ["Neon|Ride"] = 53.82, ["Neon|Fly|Ride"] = 140.41, ["Mega"] = 212.1, ["Mega|Ride"] = 211.95, ["Mega|Fly|Ride"] = 289.2}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 28.3, ["Ride"] = 18.87, ["Fly|Ride"] = 49.25, ["Neon"] = 2.1, ["Neon|Fly"] = 21.94, ["Neon|Ride"] = 20.94, ["Neon|Fly|Ride"] = 41.36, ["Mega"] = 15.72, ["Mega|Ride"] = 31.86, ["Mega|Fly|Ride"] = 64.31}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 31.44, ["Neon"] = 3.94, ["Neon|Ride"] = 41.92, ["Mega"] = 15.73, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 154.62}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.61, ["Fly"] = 131.4, ["Ride"] = 42, ["Neon"] = 31.18, ["Neon|Ride"] = 64.98, ["Mega"] = 154.62, ["Mega|Ride"] = 207.47}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 52.5, ["Ride"] = 315, ["Neon"] = 522.38, ["Neon|Ride"] = 452.82, ["Neon|Fly|Ride"] = 630, ["Mega"] = 599.99, ["Mega|Fly|Ride"] = 613.83}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 4.64, ["Fly"] = 22.32, ["Ride"] = 18.06, ["Fly|Ride"] = 41.54, ["Neon"] = 11.54, ["Neon|Fly"] = 31.14, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 65.62, ["Mega"] = 140.42, ["Mega|Fly"] = 179.18, ["Mega|Ride"] = 152.25, ["Mega|Fly|Ride"] = 215.02}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 2.6, ["Fly"] = 26.25, ["Ride"] = 26.24, ["Fly|Ride"] = 77.32, ["Neon"] = 12.02, ["Neon|Fly"] = 68.09, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 84, ["Mega"] = 137.82, ["Mega|Fly"] = 279.78, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 115.5, ["Neon"] = 7.88, ["Neon|Fly"] = 98.44, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 106.32, ["Mega"] = 49.83, ["Mega|Fly"] = 408.19, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 7.83, ["Ride"] = 45.94, ["Neon"] = 26.24, ["Neon|Ride"] = 112.12, ["Neon|Fly|Ride"] = 189, ["Mega"] = 236.81, ["Mega|Ride"] = 299.92, ["Mega|Fly|Ride"] = 446.53}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 6.57, ["Fly"] = 152.99, ["Neon"] = 138.32, ["Neon|Ride"] = 262.5, ["Mega"] = 377.21, ["Mega|Ride"] = 412.13, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 3.87, ["Fly"] = 35.44, ["Ride"] = 28.3, ["Fly|Ride"] = 77.55, ["Neon"] = 26.25, ["Neon|Fly"] = 196.65, ["Neon|Ride"] = 75.46, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 200.15, ["Mega|Fly"] = 209.57, ["Mega|Ride"] = 195.96, ["Mega|Fly|Ride"] = 31427.8}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 24.11, ["Ride"] = 16.86, ["Fly|Ride"] = 38.96, ["Neon"] = 14.43, ["Neon|Fly"] = 85.4, ["Neon|Ride"] = 50.31, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 419.12, ["Mega|Ride"] = 154.62, ["Mega|Fly|Ride"] = 223.91}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 189, ["Fly"] = 393.75, ["Ride"] = 265.58, ["Fly|Ride"] = 419.07, ["Neon"] = 904.23, ["Neon|Ride"] = 923.11, ["Neon|Fly|Ride"] = 899.07, ["Mega"] = 5588.8, ["Mega|Fly|Ride"] = 3661.88}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 3.91, ["Ride"] = 42, ["Neon"] = 30.19, ["Neon|Fly|Ride"] = 279.78, ["Mega"] = 155.09, ["Mega|Ride"] = 154.62, ["Mega|Fly|Ride"] = 978.63}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 2.1, ["Fly"] = 35.44, ["Ride"] = 20.77, ["Fly|Ride"] = 96.41, ["Neon"] = 31.45, ["Neon|Ride"] = 57.7, ["Neon|Fly|Ride"] = 139.65, ["Mega"] = 203.44, ["Mega|Ride"] = 459.38}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 9.09, ["Neon"] = 28.04, ["Neon|Fly|Ride"] = 628.67, ["Mega"] = 413.88, ["Mega|Ride"] = 335.3, ["Mega|Fly|Ride"] = 419.12}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.05, ["Fly"] = 26.25, ["Ride"] = 19.9, ["Fly|Ride"] = 33.79, ["Neon"] = 2.1, ["Neon|Fly"] = 28.46, ["Neon|Ride"] = 22.11, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 18.38, ["Mega|Fly|Ride"] = 73.5}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 6.3, ["Fly"] = 56.47, ["Ride"] = 26.25, ["Fly|Ride"] = 83.83, ["Neon"] = 17.07, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 28.32, ["Mega"] = 184.42, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.63, ["Ride"] = 65.63, ["Neon"] = 11.82, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 56.44, ["Mega|Ride"] = 110.25, ["Mega|Fly|Ride"] = 450.19}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 59.07, ["Ride"] = 98.49, ["Fly|Ride"] = 167.64, ["Neon"] = 341.25, ["Neon|Ride"] = 463.32, ["Neon|Fly|Ride"] = 437.07, ["Mega|Ride"] = 3494.32, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 3.94, ["Fly"] = 85.32, ["Ride"] = 59.05, ["Fly|Ride"] = 65.54, ["Neon"] = 23.63, ["Neon|Ride"] = 62.89, ["Neon|Fly|Ride"] = 308.07, ["Mega"] = 283.5, ["Mega|Fly|Ride"] = 215.85}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Ride"] = 56.59, ["Fly|Ride"] = 155.07, ["Neon"] = 5.25, ["Neon|Ride"] = 177.07, ["Neon|Fly|Ride"] = 518.1, ["Mega"] = 66.94, ["Mega|Fly"] = 408.64, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 209.57}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 54.6, ["Fly"] = 173.04, ["Ride"] = 129.51, ["Fly|Ride"] = 223.83, ["Neon"] = 89.77, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 330.74, ["Mega"] = 582.75, ["Mega|Ride"] = 519.75, ["Mega|Fly|Ride"] = 649.69}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 15.73, ["Ride"] = 16.79, ["Fly|Ride"] = 58.33, ["Neon"] = 2.63, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 16.64, ["Mega|Ride"] = 41.92, ["Mega|Fly|Ride"] = 86.56}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Neon"] = 3.78, ["Neon|Ride"] = 66.94, ["Neon|Fly|Ride"] = 140.42, ["Mega"] = 18.38, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 3.94, ["Ride"] = 24.94, ["Neon"] = 13.13, ["Neon|Ride"] = 58.02, ["Neon|Fly|Ride"] = 192.94, ["Mega"] = 94.32, ["Mega|Fly"] = 140.42, ["Mega|Ride"] = 134.67, ["Mega|Fly|Ride"] = 441.92}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 3.7, ["Fly"] = 82.69, ["Ride"] = 39.38, ["Fly|Ride"] = 135.23, ["Neon"] = 26.25, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 69.57, ["Neon|Fly|Ride"] = 166.69, ["Mega"] = 137.28, ["Mega|Fly"] = 209.57, ["Mega|Ride"] = 124.63, ["Mega|Fly|Ride"] = 280.24}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.05, ["Fly"] = 15.73, ["Ride"] = 15.73, ["Fly|Ride"] = 91.34, ["Neon"] = 2.1, ["Neon|Fly"] = 23.06, ["Neon|Ride"] = 30.18, ["Neon|Fly|Ride"] = 53.74, ["Mega"] = 19.83, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 35.79, ["Mega|Fly|Ride"] = 140.42}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 10.47, ["Fly"] = 41.92, ["Ride"] = 39.38, ["Fly|Ride"] = 99.54, ["Neon"] = 52.5, ["Neon|Fly|Ride"] = 176.54, ["Mega|Ride"] = 419.12}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 3136.88, ["Ride"] = 3090.94, ["Fly|Ride"] = 3538.29, ["Neon|Fly|Ride"] = 10500}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 52.49, ["Ride"] = 16.65, ["Fly|Ride"] = 41.67, ["Neon"] = 6.56, ["Neon|Fly"] = 69.17, ["Neon|Ride"] = 22.91, ["Neon|Fly|Ride"] = 69.55, ["Mega"] = 82.79, ["Mega|Ride"] = 99.73, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 6.57, ["Neon"] = 12.47, ["Mega"] = 131.25, ["Mega|Ride"] = 419.12, ["Mega|Fly|Ride"] = 207.47}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 19.73, ["Ride"] = 43.85, ["Fly|Ride"] = 157.5, ["Neon"] = 66.68, ["Neon|Ride"] = 121.55, ["Neon|Fly|Ride"] = 140.42, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 712.49}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 39.34, ["Ride"] = 78.75, ["Fly|Ride"] = 140.39, ["Neon"] = 346.18, ["Neon|Fly|Ride"] = 419.12, ["Mega"] = 1257.33, ["Mega|Ride"] = 623.44, ["Mega|Fly|Ride"] = 643.34}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 140.44, ["Fly"] = 237.86, ["Ride"] = 172.06, ["Fly|Ride"] = 241.5, ["Neon"] = 769.64, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 774.38, ["Neon|Fly|Ride"] = 975.49, ["Mega"] = 6286.62, ["Mega|Ride"] = 3003.97, ["Mega|Fly|Ride"] = 3517.5}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 9.26, ["Ride"] = 39.38, ["Fly|Ride"] = 112.11, ["Neon"] = 23.06, ["Neon|Ride"] = 138.49, ["Neon|Fly|Ride"] = 140.42, ["Mega"] = 807.68, ["Mega|Fly|Ride"] = 253.32}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 27.26, ["Neon"] = 20.97, ["Neon|Fly"] = 96.41, ["Neon|Ride"] = 34.13, ["Mega"] = 89.99, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 820.36}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.61, ["Fly"] = 101.99, ["Ride"] = 70.2, ["Fly|Ride"] = 118.13, ["Neon"] = 8.4, ["Neon|Ride"] = 31.49, ["Mega"] = 133.07, ["Mega|Ride"] = 123.47, ["Mega|Fly|Ride"] = 287.44}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 11.55, ["Ride"] = 70.22, ["Neon"] = 144.61, ["Neon|Ride"] = 209.57, ["Mega"] = 518.44, ["Mega|Ride"] = 461.53, ["Mega|Fly|Ride"] = 419.12}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 69.78, ["Neon"] = 2.1, ["Neon|Ride"] = 41.92, ["Mega"] = 14.43, ["Mega|Ride"] = 133.88, ["Mega|Fly|Ride"] = 151.16}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 91.82, ["Fly"] = 340.31, ["Ride"] = 419.07, ["Fly|Ride"] = 163.45, ["Neon"] = 366.19, ["Neon|Ride"] = 409.5, ["Neon|Fly|Ride"] = 458.93, ["Mega|Fly|Ride"] = 1924.54}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 32.29, ["Neon"] = 6.57, ["Mega"] = 98.51, ["Mega|Ride"] = 112.88}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 45.94, ["Fly"] = 215.72, ["Ride"] = 91.88, ["Fly|Ride"] = 215.82, ["Neon"] = 265.92, ["Neon|Ride"] = 389.84, ["Neon|Fly|Ride"] = 419.12, ["Mega"] = 2625, ["Mega|Ride"] = 2794.4, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 23.06, ["Fly|Ride"] = 70.2, ["Neon"] = 5.13, ["Neon|Ride"] = 28.3, ["Neon|Fly|Ride"] = 112.12, ["Mega"] = 52.5, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 210.67}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.63, ["Neon"] = 9.16, ["Mega"] = 88.03, ["Mega|Ride"] = 175.5, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 7.8, ["Ride"] = 52.5, ["Fly|Ride"] = 140.39, ["Neon"] = 60.78, ["Neon|Fly"] = 291.38, ["Neon|Ride"] = 78.75, ["Mega"] = 131.25, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 452.82}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 393.75, ["Ride"] = 372.82, ["Fly|Ride"] = 523.69, ["Neon"] = 1048.69, ["Neon|Ride"] = 1115.63, ["Neon|Fly|Ride"] = 1179.84, ["Mega"] = 3352.88, ["Mega|Ride"] = 3124.49, ["Mega|Fly|Ride"] = 3123.75}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 39.51, ["Ride"] = 45.94, ["Fly|Ride"] = 103.73, ["Neon"] = 181.12, ["Neon|Fly"] = 308.11, ["Neon|Ride"] = 186.38, ["Neon|Fly|Ride"] = 267.2, ["Mega|Fly|Ride"] = 905.63}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 19.92, ["Fly|Ride"] = 91.88, ["Neon"] = 7.09, ["Neon|Fly"] = 136.23, ["Neon|Ride"] = 23.97, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 63, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 245.19}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 6.54, ["Fly"] = 107.92, ["Ride"] = 31.16, ["Fly|Ride"] = 91.88, ["Neon"] = 24.94, ["Neon|Fly"] = 140.42, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 199.5, ["Mega|Fly"] = 370.93, ["Mega|Ride"] = 262.78, ["Mega|Fly|Ride"] = 354.16}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 7.45, ["Ride"] = 25.99, ["Neon"] = 105, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 137.28, ["Mega"] = 405.5, ["Mega|Ride"] = 377.21, ["Mega|Fly|Ride"] = 481.99}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.93, ["Neon"] = 15.73, ["Mega"] = 36.75, ["Mega|Ride"] = 87.94}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.1, ["Fly"] = 86.63, ["Ride"] = 22.32, ["Fly|Ride"] = 78.75, ["Neon"] = 26.25, ["Neon|Ride"] = 70.22, ["Neon|Fly|Ride"] = 279.78, ["Mega"] = 538.83, ["Mega|Ride"] = 486.94}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 111.57, ["Fly"] = 161.37, ["Ride"] = 150.88, ["Fly|Ride"] = 210, ["Neon"] = 733.46, ["Neon|Ride"] = 720.03, ["Neon|Fly|Ride"] = 764.88, ["Mega|Ride"] = 2409.88, ["Mega|Fly|Ride"] = 2296.88}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 27.2, ["Ride"] = 78.75, ["Fly|Ride"] = 144, ["Neon"] = 106.88, ["Neon|Ride"] = 279.78, ["Mega"] = 692.29, ["Mega|Ride"] = 654.21, ["Mega|Fly|Ride"] = 709.47}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2821.87, ["Fly"] = 3352.88, ["Ride"] = 2362.5, ["Fly|Ride"] = 2231.25, ["Neon"] = 12573.22, ["Neon|Fly|Ride"] = 6405.19, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 2.1, ["Fly"] = 65625, ["Ride"] = 22.1, ["Fly|Ride"] = 170.63, ["Neon"] = 11.82, ["Neon|Ride"] = 35.64, ["Mega"] = 62.89, ["Mega|Ride"] = 207.03, ["Mega|Fly|Ride"] = 422.63}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 10.5, ["Ride"] = 28.3, ["Fly|Ride"] = 209.54, ["Neon"] = 52.4, ["Neon|Ride"] = 60.38, ["Mega"] = 223.13, ["Mega|Ride"] = 266.14, ["Mega|Fly|Ride"] = 328.12}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 1050, ["Fly"] = 1397.74, ["Ride"] = 1025.07, ["Fly|Ride"] = 1023.75, ["Neon"] = 4034.97, ["Neon|Ride"] = 4034.97, ["Neon|Fly|Ride"] = 2887.5, ["Mega|Ride"] = 14390.06, ["Mega|Fly|Ride"] = 12420.24}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 43.26, ["Neon"] = 523.89, ["Mega"] = 923.05, ["Mega|Ride"] = 1384.57, ["Mega|Fly|Ride"] = 980.44}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 3.93, ["Ride"] = 35.44, ["Neon"] = 11.81, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 190.98, ["Mega|Ride"] = 346.83, ["Mega|Fly|Ride"] = 274.98}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Neon"] = 3.92, ["Mega"] = 28.3, ["Mega|Ride"] = 68.25, ["Mega|Fly|Ride"] = 119.45}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 95.68, ["Ride"] = 278.69, ["Fly|Ride"] = 656.25, ["Neon"] = 698.87, ["Neon|Ride"] = 406.04, ["Mega"] = 5250, ["Mega|Fly|Ride"] = 2514.65}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 5.18, ["Ride"] = 140.48, ["Neon"] = 17.46, ["Neon|Ride"] = 56.59, ["Mega"] = 187.03, ["Mega|Ride"] = 253.57, ["Mega|Fly|Ride"] = 263.82}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 168, ["Ride"] = 209.54, ["Neon"] = 603.75, ["Neon|Ride"] = 314.34, ["Mega"] = 2095.55, ["Mega|Fly|Ride"] = 2514.65}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 6.57, ["Fly"] = 105, ["Neon"] = 31.18, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 315, ["Mega"] = 224.44}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 262.5, ["Ride"] = 321.57, ["Fly|Ride"] = 393.75, ["Neon"] = 1766.63, ["Neon|Ride"] = 949.3, ["Neon|Fly|Ride"] = 905.63, ["Mega|Fly|Ride"] = 4003.54}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 3.68, ["Fly"] = 91.88, ["Ride"] = 23.63, ["Fly|Ride"] = 69.25, ["Neon"] = 50.3, ["Neon|Ride"] = 45.89, ["Neon|Fly|Ride"] = 116.82, ["Mega"] = 250.04, ["Mega|Ride"] = 308.07, ["Mega|Fly|Ride"] = 350.44}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 31.45, ["Ride"] = 13.13, ["Fly|Ride"] = 39.38, ["Neon"] = 3.93, ["Neon|Fly"] = 39.12, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 61.83, ["Mega"] = 39.38, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 136.43}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 1050, ["Fly"] = 978.63, ["Ride"] = 903, ["Fly|Ride"] = 951.57, ["Neon|Ride"] = 3865.49, ["Neon|Fly|Ride"] = 3562.42, ["Mega"] = 27690.93, ["Mega|Fly|Ride"] = 27940.82}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 9.14, ["Fly"] = 980.19, ["Ride"] = 40.69, ["Neon"] = 40.48, ["Mega"] = 150.94, ["Mega|Ride"] = 207.47, ["Mega|Fly|Ride"] = 403.6}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 7.76, ["Fly"] = 45.94, ["Ride"] = 39.51, ["Fly|Ride"] = 96.92, ["Neon"] = 17.07, ["Neon|Ride"] = 60.38, ["Neon|Fly|Ride"] = 140.42, ["Mega"] = 157.5, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 37.85, ["Fly"] = 52.4, ["Ride"] = 43.31, ["Fly|Ride"] = 89.25, ["Neon|Ride"] = 209.53, ["Neon|Fly|Ride"] = 170.39, ["Mega"] = 2095.55, ["Mega|Fly|Ride"] = 844.6}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 14.94, ["Fly"] = 78.6, ["Ride"] = 37.28, ["Fly|Ride"] = 92.31, ["Neon"] = 65.63, ["Neon|Ride"] = 82.89, ["Neon|Fly|Ride"] = 184.64, ["Mega"] = 559.53, ["Mega|Ride"] = 735, ["Mega|Fly|Ride"] = 442.31}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 42, ["Ride"] = 54.24, ["Fly|Ride"] = 636.57, ["Neon"] = 91.88, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 434.84, ["Mega|Ride"] = 494.82, ["Mega|Fly|Ride"] = 419.12}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Fly"] = 62.89, ["Ride"] = 105, ["Neon"] = 2.63, ["Neon|Ride"] = 91.18, ["Mega"] = 17.73, ["Mega|Ride"] = 59.07}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 40.69, ["Fly"] = 65.84, ["Ride"] = 52.39, ["Fly|Ride"] = 91.88, ["Neon"] = 578.82, ["Neon|Fly"] = 310.21, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 277.1, ["Mega"] = 3352.88, ["Mega|Fly|Ride"] = 1038.35}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.1, ["Fly"] = 87.68, ["Ride"] = 27.55, ["Fly|Ride"] = 127.32, ["Neon|Ride"] = 141.07, ["Mega"] = 773.07, ["Mega|Ride"] = 271.69}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.63, ["Fly"] = 25.15, ["Ride"] = 18.38, ["Fly|Ride"] = 70.2, ["Neon"] = 39.38, ["Mega"] = 1035.21, ["Mega|Ride"] = 275.58, ["Mega|Fly|Ride"] = 202.13}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 10.49, ["Neon"] = 35.64, ["Mega"] = 294, ["Mega|Ride"] = 196.88}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 22.42, ["Fly"] = 262.5, ["Ride"] = 39.38, ["Fly|Ride"] = 196.88, ["Neon"] = 116.74, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 209.57, ["Mega"] = 708.44, ["Mega|Ride"] = 1047.78, ["Mega|Fly|Ride"] = 769.6}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 8.99, ["Neon"] = 22.32, ["Mega"] = 93.74, ["Mega|Fly|Ride"] = 308.07}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 27.24, ["Neon"] = 2.1, ["Neon|Ride"] = 91.88, ["Mega"] = 18.35, ["Mega|Ride"] = 51.19, ["Mega|Fly|Ride"] = 200.17}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Ride"] = 26.13, ["Neon"] = 2.1, ["Neon|Fly"] = 393.65, ["Neon|Ride"] = 33.33, ["Mega"] = 18.38, ["Mega|Fly"] = 73.86, ["Mega|Ride"] = 47.25, ["Mega|Fly|Ride"] = 119.44}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 31.49, ["Ride"] = 20.97, ["Fly|Ride"] = 43.4, ["Neon"] = 8.28, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 36.69, ["Neon|Fly|Ride"] = 140.42, ["Mega"] = 86.63, ["Mega|Ride"] = 132.04, ["Mega|Fly|Ride"] = 237.86}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 5191.5, ["Neon"] = 20.97, ["Neon|Ride"] = 1312.5, ["Mega"] = 140.42, ["Mega|Ride"] = 158.33}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.63, ["Fly"] = 39.58, ["Ride"] = 15.62, ["Fly|Ride"] = 35.63, ["Neon"] = 2.1, ["Neon|Ride"] = 31.13, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 419.12, ["Mega|Ride"] = 276.29, ["Mega|Fly|Ride"] = 363.57}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 62.85, ["Fly|Ride"] = 391.83, ["Neon"] = 237.86, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 321.67, ["Mega"] = 698.87, ["Mega|Fly"] = 838.23, ["Mega|Ride"] = 787.49, ["Mega|Fly|Ride"] = 1038.35}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.05, ["Fly"] = 26.21, ["Ride"] = 18.38, ["Fly|Ride"] = 37.17, ["Neon"] = 3.93, ["Neon|Fly"] = 20.84, ["Neon|Ride"] = 23.09, ["Neon|Fly|Ride"] = 51.19, ["Mega"] = 35.44, ["Mega|Fly"] = 279.78, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 117.49}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 11.44, ["Fly"] = 62.3, ["Ride"] = 39.35, ["Fly|Ride"] = 80.07, ["Neon"] = 52.5, ["Neon|Fly"] = 54.25, ["Neon|Ride"] = 53.28, ["Neon|Fly|Ride"] = 139.41, ["Mega"] = 276.92, ["Mega|Ride"] = 308.07, ["Mega|Fly|Ride"] = 308.07}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 10.48, ["Fly"] = 52.5, ["Ride"] = 26.21, ["Fly|Ride"] = 82.79, ["Neon"] = 76.13, ["Neon|Ride"] = 76.1, ["Neon|Fly|Ride"] = 110.25, ["Mega"] = 1047.78, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 435.75}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 3.56, ["Fly"] = 140.38, ["Ride"] = 45.49, ["Neon"] = 38.55, ["Neon|Ride"] = 70.22, ["Mega"] = 279.78, ["Mega|Ride"] = 241.5}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 17.38, ["Neon"] = 2.63, ["Neon|Fly"] = 81.38, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 99.25, ["Mega"] = 40.69, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 61.57, ["Mega|Fly|Ride"] = 204.1}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 3.89, ["Ride"] = 27.57, ["Neon"] = 15.73, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 62.46, ["Mega"] = 90.57, ["Mega|Fly"] = 735, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 371.97}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 971.25, ["Fly"] = 1278.3, ["Ride"] = 1050, ["Fly|Ride"] = 1218, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2278.5, ["Mega|Fly|Ride"] = 7434}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 72.19, ["Ride"] = 112.24, ["Neon"] = 196.88, ["Neon|Ride"] = 251.55, ["Mega"] = 2812.69, ["Mega|Ride"] = 1257.33, ["Mega|Fly|Ride"] = 1172.07}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Fly"] = 62.89, ["Neon"] = 9.19, ["Neon|Ride"] = 74.41, ["Neon|Fly|Ride"] = 315, ["Mega"] = 61.93, ["Mega|Ride"] = 393.75}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 31.44, ["Ride"] = 55.74, ["Fly|Ride"] = 262.5, ["Neon"] = 231.57, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 300.57, ["Mega"] = 1231.11, ["Mega|Ride"] = 746.82, ["Mega|Fly|Ride"] = 950.25}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 6.13, ["Ride"] = 36.46, ["Neon"] = 56.38, ["Neon|Ride"] = 131.25, ["Mega"] = 376.69, ["Mega|Ride"] = 138.32, ["Mega|Fly|Ride"] = 1047.78}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 303.19, ["Fly"] = 922.83, ["Ride"] = 345.38, ["Fly|Ride"] = 556.32, ["Neon"] = 1047.78, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 1783.31, ["Mega|Fly|Ride"] = 4462.5}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 102.38, ["Ride"] = 22.32, ["Fly|Ride"] = 129.93, ["Neon"] = 23.06, ["Neon|Ride"] = 74.41, ["Mega"] = 393.75, ["Mega|Fly"] = 279.78}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Ride"] = 24.11, ["Neon"] = 104.99, ["Neon|Ride"] = 140.42}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 20.94, ["Fly"] = 70.22, ["Ride"] = 103.69, ["Fly|Ride"] = 209.54, ["Neon"] = 161.42, ["Neon|Ride"] = 308.11, ["Mega"] = 656.96, ["Mega|Ride"] = 981.1, ["Mega|Fly|Ride"] = 733.46}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 3.36, ["Ride"] = 70.86, ["Fly|Ride"] = 140.39, ["Neon"] = 11.54, ["Mega"] = 203.28, ["Mega|Ride"] = 233.67, ["Mega|Fly|Ride"] = 419.12}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 23.63, ["Ride"] = 15.74, ["Fly|Ride"] = 32.82, ["Neon"] = 3.82, ["Neon|Fly"] = 31.18, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 41.14, ["Mega"] = 28.3, ["Mega|Ride"] = 35.64, ["Mega|Fly|Ride"] = 99.65}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4567.92, ["Ride"] = 4198.69, ["Fly|Ride"] = 4198.69, ["Neon"] = 25146.42, ["Neon|Fly|Ride"] = 19163.82, ["Mega|Fly|Ride"] = 78371.94}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 12.53, ["Ride"] = 56.44, ["Neon"] = 42, ["Neon|Ride"] = 125.74, ["Mega"] = 262.5, ["Mega|Ride"] = 387.69, ["Mega|Fly|Ride"] = 496.65}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Ride"] = 25.14, ["Fly|Ride"] = 54.44, ["Neon"] = 15.64, ["Neon|Fly"] = 41.92, ["Neon|Ride"] = 33.45, ["Neon|Fly|Ride"] = 90.13, ["Mega"] = 154.62, ["Mega|Ride"] = 209.57, ["Mega|Fly|Ride"] = 208.04}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 420, ["Fly"] = 489.33, ["Ride"] = 419.16, ["Fly|Ride"] = 518.6, ["Neon"] = 1676.45, ["Neon|Ride"] = 1397.74, ["Neon|Fly|Ride"] = 1219.47, ["Mega|Fly|Ride"] = 5477.05}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 2.1, ["Neon"] = 20.97, ["Neon|Ride"] = 70.22, ["Mega"] = 144.38, ["Mega|Fly|Ride"] = 685.26}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 3.93, ["Fly"] = 85.52, ["Ride"] = 77.32, ["Neon"] = 140.42, ["Neon|Ride"] = 279.78, ["Neon|Fly|Ride"] = 13970.94, ["Mega"] = 279.78, ["Mega|Ride"] = 401.63}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.63, ["Fly"] = 52.5, ["Ride"] = 19.69, ["Fly|Ride"] = 39.38, ["Neon"] = 7.35, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 35.64, ["Mega"] = 53.45, ["Mega|Ride"] = 77.05, ["Mega|Fly|Ride"] = 214.03}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 603.75, ["Ride"] = 656.25, ["Fly|Ride"] = 729.75, ["Neon|Ride"] = 1957.25, ["Neon|Fly|Ride"] = 2069.36, ["Mega|Fly|Ride"] = 8751.75}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 5.2, ["Ride"] = 59.07, ["Neon"] = 21.94, ["Neon|Fly"] = 98.51, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 238.9, ["Mega"] = 114.59, ["Mega|Ride"] = 237.85, ["Mega|Fly|Ride"] = 353.07}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 6.54, ["Fly"] = 167.66, ["Ride"] = 52.5, ["Fly|Ride"] = 176.02, ["Neon"] = 40.69, ["Neon|Ride"] = 89.25, ["Neon|Fly|Ride"] = 3241.81, ["Mega"] = 251.51, ["Mega|Ride"] = 246.75, ["Mega|Fly|Ride"] = 321.67}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 23.08, ["Fly|Ride"] = 43.32, ["Neon"] = 13.13, ["Neon|Ride"] = 28.3, ["Neon|Fly|Ride"] = 98.51, ["Mega"] = 144.38, ["Mega|Ride"] = 158.82, ["Mega|Fly|Ride"] = 154.88}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 20.97, ["Ride"] = 62.31, ["Fly|Ride"] = 115.39, ["Neon"] = 138.49, ["Mega"] = 543.81, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 526.32}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Neon"] = 5.23, ["Neon|Fly|Ride"] = 2019.29, ["Mega"] = 50.3, ["Mega|Ride"] = 92.29, ["Mega|Fly|Ride"] = 168}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 511.88, ["Ride"] = 459.38, ["Fly|Ride"] = 682.5, ["Neon"] = 2069.36, ["Neon|Ride"] = 1964.58, ["Neon|Fly|Ride"] = 1911.14, ["Mega|Ride"] = 8999.57, ["Mega|Fly|Ride"] = 7848.75}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 40.62, ["Neon"] = 11.54, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 108.47, ["Mega"] = 49.26, ["Mega|Ride"] = 131.4, ["Mega|Fly|Ride"] = 306.86}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 52.43, ["Neon"] = 2.63, ["Neon|Ride"] = 170.79, ["Mega"] = 35.64, ["Mega|Ride"] = 78.6, ["Mega|Fly|Ride"] = 263}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Neon"] = 4.61, ["Neon|Ride"] = 45.92, ["Mega"] = 32.16, ["Mega|Fly"] = 155.09, ["Mega|Ride"] = 79.65, ["Mega|Fly|Ride"] = 167.66}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 3.93, ["Ride"] = 68.25, ["Neon"] = 15.73}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 26.25, ["Ride"] = 70.2, ["Fly|Ride"] = 156.19, ["Neon"] = 117.27, ["Neon|Ride"] = 224.24, ["Neon|Fly|Ride"] = 342.64, ["Mega"] = 669.38, ["Mega|Ride"] = 625.95, ["Mega|Fly|Ride"] = 654.94}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 20.82, ["Ride"] = 146.53, ["Fly|Ride"] = 276.94, ["Neon"] = 108.98, ["Neon|Ride"] = 188.61, ["Mega"] = 375.41, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 488.24}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.63, ["Fly"] = 26.25, ["Ride"] = 15.1, ["Fly|Ride"] = 54.89, ["Neon"] = 31.44, ["Neon|Ride"] = 35.07, ["Neon|Fly|Ride"] = 92.32, ["Mega"] = 299.92, ["Mega|Ride"] = 206.07, ["Mega|Fly|Ride"] = 238.88}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 6.93, ["Ride"] = 39.38, ["Neon"] = 279.78, ["Neon|Ride"] = 158.82, ["Mega"] = 349.97, ["Mega|Fly|Ride"] = 515.51}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Fly"] = 31.45, ["Ride"] = 28.3, ["Fly|Ride"] = 362.25, ["Neon"] = 11.54, ["Neon|Ride"] = 78.6, ["Mega"] = 103.74, ["Mega|Ride"] = 138.48, ["Mega|Fly|Ride"] = 209.57}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 20.97, ["Ride"] = 19.69, ["Fly|Ride"] = 66.01, ["Neon"] = 166.61, ["Neon|Ride"] = 112.12, ["Neon|Fly|Ride"] = 140.42, ["Mega"] = 941.96, ["Mega|Ride"] = 923.05, ["Mega|Fly|Ride"] = 695.63}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 70.22, ["Fly"] = 874.13, ["Neon"] = 308.11, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 328.13, ["Mega|Fly|Ride"] = 769.08}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 53.8, ["Fly"] = 115.5, ["Ride"] = 77.41, ["Fly|Ride"] = 164.22, ["Neon"] = 290.07, ["Neon|Ride"] = 299.25, ["Neon|Fly|Ride"] = 356.26, ["Mega|Ride"] = 1631.47, ["Mega|Fly|Ride"] = 1814.75}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 41.94, ["Fly"] = 126.1, ["Ride"] = 104.19, ["Neon"] = 171.75, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 364.88, ["Mega"] = 656.25, ["Mega|Ride"] = 723.19, ["Mega|Fly|Ride"] = 736.6}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 23.14, ["Ride"] = 65.62, ["Neon"] = 419.12, ["Neon|Ride"] = 252, ["Mega"] = 1050, ["Mega|Ride"] = 782.7, ["Mega|Fly|Ride"] = 1256.29}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 6.55, ["Ride"] = 23.63, ["Fly|Ride"] = 52.5, ["Neon"] = 42.39, ["Neon|Fly"] = 167.66, ["Neon|Ride"] = 94.5, ["Neon|Fly|Ride"] = 224.44, ["Mega"] = 494.57, ["Mega|Ride"] = 345.19, ["Mega|Fly|Ride"] = 360.45}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 28.3, ["Ride"] = 16.78, ["Fly|Ride"] = 41.26, ["Neon"] = 2.63, ["Neon|Ride"] = 41.56, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 40.69, ["Mega|Ride"] = 85.94, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1152.56}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 20.98, ["Ride"] = 83.83, ["Fly|Ride"] = 262.5, ["Neon"] = 92.32, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 345.02, ["Mega"] = 559.53, ["Mega|Ride"] = 518.44, ["Mega|Fly|Ride"] = 698.87}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 56.59, ["Neon"] = 3.86, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 293.4, ["Mega"] = 39.38, ["Mega|Fly|Ride"] = 140.42}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 26.22, ["Ride"] = 83.83, ["Neon"] = 261.19, ["Neon|Ride"] = 347.71, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 698.87, ["Mega|Ride"] = 732.41, ["Mega|Fly|Ride"] = 590.62}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Mega"] = 19.69}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 86.56, ["Mega"] = 24.94, ["Mega|Ride"] = 83.84, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 162.42, ["Ride"] = 183.75, ["Neon"] = 660.12, ["Neon|Ride"] = 590.63, ["Neon|Fly|Ride"] = 626.58, ["Mega|Ride"] = 6345.85, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.63, ["Fly"] = 65.63, ["Ride"] = 23.63, ["Fly|Ride"] = 88.02, ["Neon"] = 11.42, ["Neon|Fly"] = 62.89, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 140.42, ["Mega"] = 107.62, ["Mega|Ride"] = 116.82, ["Mega|Fly|Ride"] = 418.07}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 36.69, ["Fly|Ride"] = 86.63, ["Neon"] = 6.13, ["Neon|Ride"] = 56.59, ["Neon|Fly|Ride"] = 419.99, ["Mega"] = 45.07, ["Mega|Ride"] = 98.51}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 83.83, ["Neon"] = 5.13, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 35.44, ["Mega"] = 33.54, ["Mega|Ride"] = 74.82, ["Mega|Fly|Ride"] = 190.32}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 91.88, ["Neon"] = 3.93, ["Neon|Ride"] = 25.09, ["Neon|Fly|Ride"] = 140.42, ["Mega"] = 39.83, ["Mega|Ride"] = 94.5, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 24.94, ["Ride"] = 86.63, ["Fly|Ride"] = 616.07, ["Neon"] = 279.78, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1047.78, ["Mega|Ride"] = 1047.78, ["Mega|Fly|Ride"] = 1255.24}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 3.13, ["Ride"] = 103.73, ["Neon"] = 20.96, ["Neon|Ride"] = 111.57, ["Mega"] = 140.6, ["Mega|Ride"] = 534.85, ["Mega|Fly|Ride"] = 417.03}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.05}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.05}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 328.13, ["Ride"] = 462.03, ["Fly|Ride"] = 605.55, ["Neon"] = 787.5, ["Neon|Ride"] = 978.63, ["Neon|Fly|Ride"] = 1125.31, ["Mega|Fly|Ride"] = 3150}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.05}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 62.85}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 36.75}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 15.73}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 23.63}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 43.32}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 53.82}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 12.37}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 7.19}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 216.57}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 22.3}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.05}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 39.38}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 19.67}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 6.55}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 256.82}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.05}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 10.5}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 4.46}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 6.56}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 23.02}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 465.94}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 698.87}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 6.56}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1064.44}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 250.69}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 15.73}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 3.97}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 14.3}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 37.73}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 86.63}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 32.81}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 13.13}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 6.56}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 18.87}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 7.86}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 210}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.1}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 27.57}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 27.26}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 5.24}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 1259.99}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 116.66}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 295.31}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 3.92}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 6.57}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 6.23}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 144.37}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 10.49}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 15.73}},
    ["rbxassetid://1265129435"] = {name = "Gold Snowboard", prices = {["default"] = 210}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 159.6}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 13.11}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 3.93}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 13.13}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 5.24}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 3.42}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 154.59}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 13.13}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 6.3}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.05}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 19.66}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.35}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 7.86}},
    ["rbxassetid://1265129203"] = {name = "Ice Snowboard", prices = {["default"] = 196.88}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 2.63}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 21}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 137.96}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 98.41}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 6.57}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 7.86}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 15.49}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 27.57}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 73.47}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 39.3}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 21916.8}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 177.19}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 27.23}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 26.24}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 30.66}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 272.44}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 25.75}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 31.49}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 74.13}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 116.82}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 271.09}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 34.13}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 26.24}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 39.37}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 40.66}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 262.5}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 7.87}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 8.91}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 6.24}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 31.12}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 44.63}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.1}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 2.61}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.42}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 2.63}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 5.86}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 741.57}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 6.55}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 643.34}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 17.03}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.1}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 262.5}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 30.15}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 45.94}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 32.81}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 132.57}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 31.27}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 2.63}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 14.44}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.1}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 6.95}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 3.94}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 40}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 5.39}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 3.68}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 3.93}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 12.73}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.05}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 190.12}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 39.32}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.05}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.63}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.1}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 206.07}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 10.49}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 9.4}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 5.61}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 13.12}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 203.44}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 14.44}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 13.13}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 18.2}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 111.55}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 28.87}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 10.49}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 5.23}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 8.39}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 11.54}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 3.47}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 5.24}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 23.68}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 4.41}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 3.93}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.63}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 7390.97}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 18.38}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 10.49}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 5.13}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 26.94}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 5.23}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 56.37}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 27.57}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 14.42}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.05}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 118.01}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 11.82}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 9.22}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 4.6}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.6}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 5.9}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 3.65}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 3.45}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4308.4}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 4.64}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.05}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 44.63}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 3.93}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 78.06}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 4.66}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 182.28}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.05}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.63}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 3.94}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 3.91}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.63}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 2.1}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 14.18}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 27.55}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 3.93}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.45}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 3.19}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 11.82}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 5.7}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 3.94}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 5.25}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.5}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.61}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 5.24}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 3.71}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.63}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 2.59}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 28.35}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 5.96}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 16.46}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 116.82}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 34.9}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 4.82}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1231.78}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 19.93}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 2.6}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.05}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 28.87}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 3.93}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 6.3}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 10.31}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 15.62}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 26.98}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 18.35}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 4.7}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 3.71}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 10.5}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 4.19}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.63}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 12.78}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 4.66}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 11.54}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 18.24}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 11.81}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.05}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 399}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.63}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 230.73}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 4.75}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 26.21}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 23.63}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 2.05}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.63}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 89.25}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 3.44}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 17.05}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 5.25}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.63}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 3.93}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 5.1}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 5.82}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 14.37}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 86.63}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 96.85}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 6.29}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1351.88}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.63}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 213.7}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 3.89}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.63}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.63}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 18.36}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 45.94}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 3.84}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 5.25}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 6.95}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 65.61}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 7.87}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 3.5}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.63}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 3.72}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 11.53}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 5.13}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 74.46}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 3.63}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 54.74}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.37}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 6.56}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.63}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 8.4}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 27.45}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 122.2}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.63}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 2.63}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.57}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 60.12}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 2.63}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.05}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 3.94}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.05}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 5.25}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 64.23}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 41.79}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 86.62}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 458.84}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 47.2}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 104.15}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 8.35}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 18.34}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 74.53}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 3.84}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 15.72}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 3.92}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 9.17}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 22.32}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 23.12}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 3.94}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 3.93}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 6.57}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 35.64}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 65.63}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 4.64}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 28.88}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 4.73}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 3.93}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 39.37}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 59.07}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 39.38}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1397.74}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 17.8}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 8.67}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 39.38}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 249.25}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 23.08}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 7.86}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 11.82}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 10.39}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 2.6}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 208.69}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 52.98}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 62.99}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 5.55}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 57.49}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 118.13}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 90.57}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 945}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 197.78}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 7.85}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 1036.88}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 519.75}},
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