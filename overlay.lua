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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 1011.93, ["Fly"] = 1118.94, ["Ride"] = 1019.82, ["Fly|Ride"] = 1025.07, ["Neon|Ride"] = 4475.21, ["Neon|Fly|Ride"] = 3426.41, ["Mega|Fly|Ride"] = 12723.95}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 482.1, ["Fly"] = 575.05, ["Ride"] = 557.62, ["Fly|Ride"] = 627.12, ["Neon"] = 2296.88, ["Neon|Fly|Ride"] = 3098.57, ["Mega|Fly|Ride"] = 8372.52}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 5872.53, ["Ride"] = 4790.63, ["Fly|Ride"] = 4390.32, ["Neon"] = 25870.55, ["Neon|Fly|Ride"] = 19766.58, ["Mega|Fly|Ride"] = 62927.47}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 125.99, ["Ride"] = 182.47, ["Fly|Ride"] = 280.04, ["Neon"] = 1090.27, ["Neon|Ride"] = 820.32, ["Neon|Fly|Ride"] = 658.88, ["Mega"] = 3497.74, ["Mega|Fly|Ride"] = 3098.57}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 525, ["Ride"] = 601.95, ["Fly|Ride"] = 585.38, ["Neon|Fly|Ride"] = 1706.25, ["Mega|Fly|Ride"] = 8904.25}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 11.22, ["Ride"] = 46.49, ["Fly|Ride"] = 133.21, ["Neon"] = 35.7, ["Neon|Ride"] = 56.65, ["Neon|Fly|Ride"] = 310.22, ["Mega"] = 262.5, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 409.5}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 3.94, ["Fly"] = 36.71, ["Ride"] = 30.18, ["Fly|Ride"] = 77.97, ["Neon"] = 23, ["Neon|Fly"] = 64.32, ["Neon|Ride"] = 47.83, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 136.36, ["Mega|Fly"] = 303.19, ["Mega|Ride"] = 195.16, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 189.37, ["Ride"] = 290.07, ["Fly|Ride"] = 251.72, ["Neon"] = 458.07, ["Neon|Fly"] = 459.38, ["Neon|Fly|Ride"] = 629.29, ["Mega"] = 1858.92, ["Mega|Ride"] = 1887.84, ["Mega|Fly|Ride"] = 1858.92}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 26.62, ["Fly"] = 65.63, ["Ride"] = 49.39, ["Fly|Ride"] = 118.13, ["Neon|Ride"] = 192.87, ["Neon|Fly|Ride"] = 210, ["Mega"] = 2100, ["Mega|Ride"] = 783.46, ["Mega|Fly|Ride"] = 755.14}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 28.88, ["Fly"] = 57.75, ["Ride"] = 39.38, ["Fly|Ride"] = 82.86, ["Neon"] = 280.04, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 204.75, ["Mega|Ride"] = 691.17, ["Mega|Fly|Ride"] = 774.95}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 56.44, ["Ride"] = 59.07, ["Fly|Ride"] = 161.6, ["Neon|Ride"] = 238.11, ["Neon|Fly|Ride"] = 258.56, ["Mega|Ride"] = 1068.74, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 69.25}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 379.32, ["Fly"] = 315, ["Ride"] = 367.5, ["Fly|Ride"] = 418.69, ["Neon"] = 1283.63, ["Neon|Fly|Ride"] = 1430.63, ["Mega|Fly|Ride"] = 4055.69}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 125.86, ["Fly"] = 146.83, ["Ride"] = 120.94, ["Fly|Ride"] = 157.39, ["Neon|Fly|Ride"] = 556.92, ["Mega|Fly|Ride"] = 2515.02}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 3.26, ["Fly"] = 31.47, ["Ride"] = 56.64, ["Fly|Ride"] = 91.25, ["Neon"] = 11.82, ["Neon|Fly"] = 61.89, ["Neon|Ride"] = 78.75, ["Mega"] = 123.78, ["Mega|Ride"] = 189, ["Mega|Fly|Ride"] = 384.58}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 140.54, ["Fly"] = 140.64, ["Ride"] = 129.94, ["Fly|Ride"] = 194.6, ["Neon"] = 477.21, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 544.69, ["Mega|Fly|Ride"] = 1967.44}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.93, ["Fly"] = 27.02, ["Ride"] = 21.3, ["Fly|Ride"] = 60.84, ["Neon"] = 23.63, ["Neon|Fly"] = 104.89, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 787.5, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 43.32, ["Ride"] = 77.84, ["Fly|Ride"] = 148.93, ["Neon"] = 155.66, ["Neon|Ride"] = 199.27, ["Neon|Fly|Ride"] = 251.69, ["Mega"] = 809.69, ["Mega|Ride"] = 725.78, ["Mega|Fly|Ride"] = 768.13}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 50.8}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 51.19, ["Ride"] = 170.63, ["Neon"] = 301.02, ["Mega"] = 2936.62, ["Mega|Fly|Ride"] = 3098.57}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 16.78, ["Fly"] = 393.75, ["Ride"] = 30.4, ["Fly|Ride"] = 525, ["Neon"] = 138.44, ["Neon|Ride"] = 232.38, ["Neon|Fly|Ride"] = 203.44, ["Mega|Ride"] = 589.05, ["Mega|Fly|Ride"] = 1678.08}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 42.84, ["Fly"] = 99.75, ["Ride"] = 59.07, ["Fly|Ride"] = 118.53, ["Neon"] = 385.97, ["Neon|Ride"] = 199.49, ["Neon|Fly|Ride"] = 261.18, ["Mega"] = 1681.32, ["Mega|Fly|Ride"] = 918.69}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 66.94, ["Ride"] = 155.76, ["Fly|Ride"] = 196.88, ["Neon"] = 196.88, ["Neon|Ride"] = 209.99, ["Neon|Fly|Ride"] = 405.57, ["Mega"] = 1101.38, ["Mega|Ride"] = 1254.38, ["Mega|Fly|Ride"] = 1237.59}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 14.42, ["Ride"] = 52.45, ["Fly|Ride"] = 137.16, ["Neon"] = 140.55, ["Neon|Ride"] = 217.27, ["Neon|Fly|Ride"] = 290.48, ["Mega"] = 699.57, ["Mega|Ride"] = 2040.94, ["Mega|Fly|Ride"] = 958.61}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 40.74, ["Ride"] = 112.22, ["Fly|Ride"] = 131.25, ["Neon"] = 251.72, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 310.22, ["Mega|Ride"] = 2493.75, ["Mega|Fly|Ride"] = 938.68}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 4.19, ["Fly"] = 30.18, ["Ride"] = 23.08, ["Fly|Ride"] = 49.29, ["Neon"] = 28.32, ["Neon|Fly"] = 64.97, ["Neon|Ride"] = 54.55, ["Neon|Fly|Ride"] = 89.77, ["Mega"] = 142.14, ["Mega|Fly"] = 28002.73, ["Mega|Ride"] = 131.24, ["Mega|Fly|Ride"] = 346.5}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 280.01, ["Ride"] = 310.43, ["Fly|Ride"] = 282.19, ["Neon"] = 1115.63, ["Neon|Ride"] = 1468.31, ["Neon|Fly|Ride"] = 1818.62, ["Mega"] = 10487.92, ["Mega|Fly|Ride"] = 5873.24}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 15.74, ["Ride"] = 33.57, ["Fly|Ride"] = 137.52, ["Neon"] = 238.09, ["Neon|Ride"] = 209.77, ["Mega"] = 825.41, ["Mega|Fly|Ride"] = 787.66}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 6.57, ["Fly"] = 32.82, ["Ride"] = 24.94, ["Fly|Ride"] = 48.57, ["Neon"] = 49.23, ["Neon|Fly"] = 89.25, ["Neon|Ride"] = 37.41, ["Neon|Fly|Ride"] = 105, ["Mega|Ride"] = 560.07, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 104.88, ["Fly"] = 137.09, ["Ride"] = 135.19, ["Fly|Ride"] = 209.75, ["Neon"] = 357, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 419.53, ["Mega"] = 6156.46, ["Mega|Ride"] = 3098.57, ["Mega|Fly|Ride"] = 1540.88}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 13.17, ["Ride"] = 31.38, ["Fly|Ride"] = 62.93, ["Neon"] = 81.82, ["Neon|Ride"] = 145.69, ["Neon|Fly|Ride"] = 207.38, ["Mega"] = 1575, ["Mega|Fly|Ride"] = 524.42}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 283.16, ["Fly"] = 356.65, ["Ride"] = 300.57, ["Fly|Ride"] = 313.69, ["Neon"] = 656.25, ["Neon|Ride"] = 597.19, ["Neon|Fly|Ride"] = 825.41, ["Mega"] = 6292.76, ["Mega|Fly|Ride"] = 2565.35}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 31.39}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.91, ["Fly"] = 31.4, ["Ride"] = 31.47, ["Fly|Ride"] = 67.13, ["Neon"] = 21, ["Neon|Fly"] = 5243.97, ["Neon|Ride"] = 28.33, ["Neon|Fly|Ride"] = 104.87, ["Mega"] = 118.13, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 598.5, ["Ride"] = 735, ["Fly|Ride"] = 656.25, ["Neon"] = 3076.79, ["Neon|Ride"] = 3636.18, ["Neon|Fly|Ride"] = 2966.25, ["Mega"] = 11887.01, ["Mega|Ride"] = 52281.55, ["Mega|Fly|Ride"] = 9745.38}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 11.82, ["Ride"] = 36.71, ["Fly|Ride"] = 91.26, ["Neon"] = 70.28, ["Neon|Ride"] = 102.78, ["Neon|Fly|Ride"] = 175.17, ["Mega"] = 787.5, ["Mega|Ride"] = 606.21, ["Mega|Fly|Ride"] = 661.81}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 150.94, ["Ride"] = 157.5, ["Fly|Ride"] = 207.38, ["Neon"] = 603.07, ["Neon|Ride"] = 514.5, ["Neon|Fly|Ride"] = 909.32, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 2641.92}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 159.42}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 25.18, ["Ride"] = 55.13, ["Fly|Ride"] = 196.88, ["Neon"] = 167.83, ["Neon|Ride"] = 250.67, ["Neon|Fly|Ride"] = 288.15, ["Mega"] = 587.33, ["Mega|Ride"] = 620.42, ["Mega|Fly|Ride"] = 774.95}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.41}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 178.92, ["Ride"] = 167.99, ["Neon|Ride"] = 590.63, ["Neon|Fly|Ride"] = 929.48, ["Mega|Fly|Ride"] = 1944.47}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 131.25, ["Ride"] = 209.75, ["Fly|Ride"] = 296.79, ["Neon"] = 524.42, ["Neon|Ride"] = 419.53, ["Neon|Fly|Ride"] = 483, ["Mega|Ride"] = 1286.25, ["Mega|Fly|Ride"] = 1396.5}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 74.38}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 93.66, ["Fly"] = 93.49, ["Ride"] = 61.68, ["Fly|Ride"] = 77.44, ["Neon|Ride"] = 347.17, ["Neon|Fly|Ride"] = 334.69, ["Mega"] = 4195.17, ["Mega|Fly|Ride"] = 1258.41}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 3.94, ["Ride"] = 74.82, ["Fly|Ride"] = 131.25, ["Neon"] = 39.38, ["Neon|Ride"] = 155.24, ["Mega"] = 196.88, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 209.77, ["Mega|Fly|Ride"] = 342.98}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 339.56, ["Fly"] = 462.47, ["Ride"] = 362.25, ["Fly|Ride"] = 354.38, ["Neon|Ride"] = 1959.16, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 6970.88}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 64.32, ["Fly"] = 99.75, ["Ride"] = 85.32, ["Fly|Ride"] = 171.94, ["Neon"] = 325.33, ["Neon|Fly"] = 314.65, ["Neon|Ride"] = 350.32, ["Neon|Fly|Ride"] = 369.02, ["Mega|Fly|Ride"] = 1561.88}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3593.79, ["Ride"] = 3018.75, ["Fly|Ride"] = 3412.78, ["Neon|Fly|Ride"] = 13982.5}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 39.38, ["Fly"] = 224.43, ["Ride"] = 50.92, ["Fly|Ride"] = 85.32, ["Neon"] = 371.8, ["Neon|Ride"] = 408.19, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1887.84, ["Mega|Ride"] = 1887.84, ["Mega|Fly|Ride"] = 1395.95}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 57.75, ["Ride"] = 81.81, ["Fly|Ride"] = 155.23, ["Neon"] = 393.75, ["Neon|Ride"] = 318.35, ["Neon|Fly|Ride"] = 525, ["Mega"] = 6292.76, ["Mega|Fly|Ride"] = 1496.64}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 28.33, ["Fly"] = 76.13, ["Ride"] = 65.63, ["Fly|Ride"] = 130.89, ["Neon"] = 186.35, ["Neon|Ride"] = 125.98, ["Neon|Fly|Ride"] = 199.49, ["Mega"] = 2598.75, ["Mega|Fly|Ride"] = 627.37}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 11.58}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 65.63, ["Ride"] = 78.75, ["Fly|Ride"] = 131.25, ["Neon"] = 436.31, ["Neon|Fly|Ride"] = 498.19}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 41.85}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 215.71, ["Ride"] = 245.4, ["Fly|Ride"] = 367.5, ["Neon|Ride"] = 1399.11, ["Neon|Fly|Ride"] = 2097.59}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 761.24, ["Ride"] = 643.13, ["Fly|Ride"] = 656.25, ["Neon|Fly|Ride"] = 2231.24, ["Mega|Fly|Ride"] = 11812.5}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 3.92}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 30.07, ["Fly"] = 52.5, ["Ride"] = 38.19, ["Fly|Ride"] = 57.81, ["Neon"] = 266.41, ["Neon|Fly"] = 310.22, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 203.44, ["Mega|Ride"] = 797.09, ["Mega|Fly|Ride"] = 697.1}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 9.3}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5118.75, ["Fly|Ride"] = 4725, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 40273.58}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 9.87, ["Fly"] = 41.96, ["Ride"] = 20.98, ["Fly|Ride"] = 58.74, ["Neon"] = 56.65, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 105, ["Mega"] = 388.06, ["Mega|Ride"] = 374.07, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 13.13, ["Fly"] = 78.67, ["Ride"] = 39.38, ["Fly|Ride"] = 115.02, ["Neon"] = 140.55, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 699.57, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 86.63, ["Ride"] = 128.63, ["Fly|Ride"] = 132.15, ["Neon|Fly|Ride"] = 525}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 11.22, ["Ride"] = 35.44, ["Fly|Ride"] = 139.65, ["Neon"] = 56.69, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 140.55, ["Mega"] = 360.8, ["Mega|Ride"] = 553.79, ["Mega|Fly|Ride"] = 620.42}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 2100, ["Fly"] = 2310, ["Ride"] = 2796.8, ["Fly|Ride"] = 2231.24, ["Neon|Fly|Ride"] = 4364.07, ["Mega|Fly|Ride"] = 11892.57}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 32440.41, ["Ride"] = 24207.75, ["Fly|Ride"] = 24281.15, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 69919.77, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 195774.69}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 25.83, ["Fly"] = 393.75, ["Ride"] = 56.64, ["Fly|Ride"] = 87.14, ["Neon"] = 236.25, ["Neon|Ride"] = 178.38, ["Neon|Fly|Ride"] = 266.41, ["Mega"] = 1470, ["Mega|Ride"] = 734.16, ["Mega|Fly|Ride"] = 695.63}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 3.42, ["Fly"] = 43.32, ["Ride"] = 31.39, ["Fly|Ride"] = 121.67, ["Neon"] = 17.43, ["Neon|Fly"] = 129.34, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 113.72, ["Mega"] = 112.24, ["Mega|Fly"] = 140.55, ["Mega|Ride"] = 178.31, ["Mega|Fly|Ride"] = 246.74}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 22.19}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 7.3, ["Ride"] = 26.25, ["Fly|Ride"] = 280.01, ["Neon"] = 35.68, ["Neon|Ride"] = 124.34, ["Neon|Fly|Ride"] = 463.32, ["Mega"] = 279.57, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 402.74}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 708.75, ["Ride"] = 682.5, ["Fly|Ride"] = 693, ["Neon|Fly|Ride"] = 2797.15, ["Mega"] = 11187.47, ["Mega|Fly|Ride"] = 10801.52}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 1032.92, ["Fly"] = 1076.25, ["Ride"] = 1115.63, ["Fly|Ride"] = 1116.94, ["Neon|Fly|Ride"] = 3917.25, ["Mega|Fly|Ride"] = 15383.68}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 22.32, ["Fly"] = 56.64, ["Ride"] = 60.38, ["Fly|Ride"] = 125.86, ["Neon"] = 202.17, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 209.77, ["Mega|Ride"] = 489.8, ["Mega|Fly|Ride"] = 685.93}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 39.38}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 55.13, ["Fly"] = 123.38, ["Ride"] = 81.38, ["Fly|Ride"] = 132.56, ["Neon"] = 280.04, ["Neon|Ride"] = 419.53, ["Neon|Fly|Ride"] = 420, ["Mega|Fly|Ride"] = 1496.64}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 88.3, ["Ride"] = 118.13, ["Fly|Ride"] = 170.63, ["Neon"] = 450.19, ["Neon|Fly"] = 503.44, ["Neon|Ride"] = 620.42, ["Neon|Fly|Ride"] = 15491.62, ["Mega"] = 2113.55, ["Mega|Fly|Ride"] = 1948.67}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 3.91, ["Fly"] = 48.57, ["Ride"] = 25.18, ["Fly|Ride"] = 61.69, ["Neon"] = 33.47, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 125.87, ["Mega"] = 560.07, ["Mega|Fly|Ride"] = 450.19}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 75.68, ["Fly"] = 84, ["Ride"] = 86.03, ["Fly|Ride"] = 155.23, ["Neon|Ride"] = 342.75, ["Neon|Fly|Ride"] = 301.88, ["Mega|Fly|Ride"] = 1190.44}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 3.87, ["Ride"] = 39.87, ["Fly|Ride"] = 69.91, ["Neon"] = 28.33, ["Neon|Fly"] = 98.6, ["Neon|Ride"] = 28.33, ["Neon|Fly|Ride"] = 156.19, ["Mega"] = 121.68, ["Mega|Fly"] = 1119.07, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 392.44}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 17.38, ["Fly"] = 65.62, ["Ride"] = 32.82, ["Fly|Ride"] = 104.88, ["Neon"] = 33.57, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 139.65, ["Mega"] = 1050, ["Mega|Fly|Ride"] = 628.24}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 35.44, ["Ride"] = 116.17, ["Fly|Ride"] = 272.7, ["Neon"] = 190.32, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 2097.59}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 14.9, ["Fly"] = 85.71, ["Ride"] = 39.87, ["Fly|Ride"] = 82.69, ["Neon"] = 103.69, ["Neon|Ride"] = 171.97, ["Neon|Fly|Ride"] = 167.83, ["Mega"] = 629.29, ["Mega|Fly|Ride"] = 938.68}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 5579.44, ["Ride"] = 5512.5, ["Fly|Ride"] = 4373.25, ["Neon"] = 30766.3, ["Neon|Fly|Ride"] = 25171, ["Mega|Fly|Ride"] = 99884.77}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 256.75, ["Fly"] = 290.43, ["Ride"] = 262.5, ["Fly|Ride"] = 304.49, ["Neon|Ride"] = 629.29, ["Neon|Fly|Ride"] = 590.63, ["Mega"] = 2099.99, ["Mega|Fly|Ride"] = 2202.47}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 28.34, ["Fly"] = 98.59, ["Ride"] = 55.13, ["Fly|Ride"] = 122.07, ["Neon"] = 75.86, ["Neon|Fly"] = 241.5, ["Neon|Ride"] = 103.73, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 342.83, ["Mega|Fly"] = 524.42, ["Mega|Ride"] = 360.8, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 3.26, ["Fly"] = 40.68, ["Ride"] = 28.32, ["Fly|Ride"] = 98.6, ["Neon"] = 26.23, ["Neon|Ride"] = 56.69, ["Mega"] = 140.44}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 36.38, ["Fly"] = 5265.86, ["Ride"] = 65.63, ["Fly|Ride"] = 160.13, ["Neon"] = 105, ["Neon|Fly"] = 309.41, ["Neon|Ride"] = 209.77, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 479.07, ["Mega|Ride"] = 448.02, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 18571.88, ["Ride"] = 14583.19, ["Fly|Ride"] = 11156.25, ["Neon|Fly|Ride"] = 23625}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 137.39, ["Ride"] = 196.88, ["Fly|Ride"] = 280.01, ["Neon"] = 2097.59, ["Neon|Fly|Ride"] = 1090.76, ["Mega|Fly|Ride"] = 6817.16}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 42.84, ["Fly"] = 459.38, ["Ride"] = 49.6, ["Fly|Ride"] = 98.6, ["Neon|Fly"] = 464.75, ["Neon|Ride"] = 251.76, ["Neon|Fly|Ride"] = 266.37, ["Mega|Fly|Ride"] = 1277.45}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 12.79, ["Ride"] = 39.38, ["Fly|Ride"] = 57.75, ["Neon"] = 68.57, ["Neon|Ride"] = 111.55, ["Neon|Fly|Ride"] = 173.38, ["Mega"] = 2517.12, ["Mega|Ride"] = 492.19, ["Mega|Fly|Ride"] = 734.16}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 426.57, ["Fly"] = 838.94, ["Ride"] = 446.22, ["Fly|Ride"] = 484.31, ["Neon"] = 1441.06, ["Neon|Ride"] = 1323, ["Neon|Fly|Ride"] = 1417.5, ["Mega|Fly|Ride"] = 5579.59}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 7.25, ["Fly"] = 51.12, ["Ride"] = 42, ["Fly|Ride"] = 140.55, ["Neon"] = 18.6, ["Neon|Ride"] = 101.17, ["Neon|Fly|Ride"] = 140.54, ["Mega"] = 105, ["Mega|Ride"] = 178.5, ["Mega|Fly|Ride"] = 253.87}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 117.29, ["Fly"] = 393.75, ["Ride"] = 164.07, ["Fly|Ride"] = 223.12, ["Neon"] = 524.42, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 503.44, ["Neon|Fly|Ride"] = 459.37, ["Mega"] = 2797.15, ["Mega|Fly|Ride"] = 1944.47}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 17.43, ["Fly"] = 19.69, ["Ride"] = 22.93, ["Fly|Ride"] = 39.38, ["Neon|Ride"] = 102.26, ["Neon|Fly|Ride"] = 111.19, ["Mega"] = 2517.12, ["Mega|Fly|Ride"] = 570.55}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 7.87}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 65.63, ["Ride"] = 167.81, ["Fly|Ride"] = 525, ["Neon"] = 393.75, ["Neon|Fly"] = 1678.08, ["Neon|Ride"] = 331.44, ["Neon|Fly|Ride"] = 350.47, ["Mega|Ride"] = 2231.25, ["Mega|Fly|Ride"] = 1533.6}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 14.88, ["Ride"] = 31.42, ["Fly|Ride"] = 68.25, ["Neon"] = 104.89, ["Neon|Ride"] = 125.99, ["Neon|Fly|Ride"] = 220.19, ["Mega"] = 622.99, ["Mega|Ride"] = 462.53, ["Mega|Fly|Ride"] = 942.78}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 14.01}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 30.22, ["Fly"] = 210, ["Ride"] = 77.84, ["Fly|Ride"] = 94.41, ["Neon"] = 133.88, ["Neon|Ride"] = 79.72, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1538.59, ["Mega|Ride"] = 741.51, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.92, ["Ride"] = 24.13, ["Fly|Ride"] = 118.13, ["Neon"] = 19.04, ["Neon|Ride"] = 137.41, ["Neon|Fly|Ride"] = 321.57, ["Mega"] = 111.19, ["Mega|Ride"] = 335.64, ["Mega|Fly|Ride"] = 419.53}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 14.44, ["Fly"] = 56.64, ["Ride"] = 30.18, ["Fly|Ride"] = 91.87, ["Neon"] = 140.55, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 140.55, ["Mega"] = 698.52, ["Mega|Ride"] = 620.42, ["Mega|Fly|Ride"] = 699.57}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 393.75, ["Fly"] = 437.75, ["Ride"] = 322.88, ["Fly|Ride"] = 387.19, ["Neon|Fly|Ride"] = 1734.72, ["Mega|Fly|Ride"] = 8670.37}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 43.32, ["Ride"] = 109.22, ["Fly|Ride"] = 70.27, ["Neon"] = 253.32, ["Neon|Ride"] = 236.25, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 901.98}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 65.63, ["Ride"] = 78.7, ["Fly|Ride"] = 144.06, ["Neon|Ride"] = 177.19, ["Neon|Fly|Ride"] = 630, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1338.27}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 17.8, ["Fly"] = 83.91, ["Ride"] = 70.88, ["Fly|Ride"] = 131.24, ["Neon"] = 92.99, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 309.41, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 532.87}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 11152.04, ["Ride"] = 11152.04, ["Fly|Ride"] = 8103.33, ["Neon|Fly|Ride"] = 16918.02, ["Mega|Fly|Ride"] = 39372.9}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1706.25, ["Fly"] = 2633.52, ["Ride"] = 2001.57, ["Fly|Ride"] = 1922.82, ["Neon"] = 4593.75, ["Neon|Fly|Ride"] = 5209.32, ["Mega|Fly|Ride"] = 15093.75}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 419.48, ["Ride"] = 328.13, ["Fly|Ride"] = 545.31, ["Neon"] = 1399.11, ["Neon|Ride"] = 1397.82, ["Neon|Fly|Ride"] = 1399.11, ["Mega"] = 16780.67, ["Mega|Fly|Ride"] = 6397.64}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 13.75, ["Fly"] = 35.66, ["Ride"] = 27.27, ["Fly|Ride"] = 51.19, ["Neon"] = 116.2, ["Neon|Ride"] = 98.6, ["Neon|Fly|Ride"] = 167.78, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 5.86, ["Ride"] = 61.69, ["Fly|Ride"] = 153.57, ["Neon"] = 24.9, ["Neon|Ride"] = 65.63, ["Mega"] = 125.87, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 49.32, ["Fly"] = 39.37, ["Ride"] = 45.94, ["Fly|Ride"] = 98.44, ["Neon"] = 137.41, ["Neon|Ride"] = 207.67, ["Neon|Fly|Ride"] = 196.88, ["Mega|Fly|Ride"] = 699.57}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.5, ["Fly"] = 24.94, ["Ride"] = 19.69, ["Fly|Ride"] = 43.32, ["Neon"] = 23.08, ["Neon|Fly"] = 70.28, ["Neon|Ride"] = 35.68, ["Neon|Fly|Ride"] = 71.91, ["Mega"] = 472.5, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 335.57, ["Fly"] = 314.99, ["Ride"] = 317.01, ["Fly|Ride"] = 414.24, ["Neon"] = 909.32, ["Neon|Ride"] = 1350.86, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 3917.25}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 20.98, ["Fly"] = 62.34, ["Ride"] = 45.11, ["Fly|Ride"] = 87.94, ["Neon"] = 278.99, ["Neon|Fly"] = 464.75, ["Neon|Ride"] = 148.97, ["Neon|Fly|Ride"] = 236.25, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 1006.86}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 15.74, ["Fly"] = 18.9, ["Ride"] = 28.32, ["Fly|Ride"] = 46.16, ["Neon"] = 62.75, ["Neon|Fly"] = 136.5, ["Neon|Ride"] = 109.23, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 524.42, ["Mega|Ride"] = 577.89, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 393.75, ["Fly"] = 787.5, ["Ride"] = 527.63, ["Fly|Ride"] = 681.73, ["Mega|Fly|Ride"] = 8111.37}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1061.82, ["Ride"] = 1290.19, ["Fly|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 17041.47}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 84, ["Fly"] = 116.19, ["Ride"] = 79.8, ["Fly|Ride"] = 103.77, ["Neon"] = 499.24, ["Neon|Ride"] = 416.06, ["Neon|Fly|Ride"] = 525, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 195.57, ["Fly"] = 328.13, ["Ride"] = 248.61, ["Fly|Ride"] = 281.14, ["Neon"] = 1085.16, ["Neon|Ride"] = 774.95, ["Neon|Fly|Ride"] = 652.31, ["Mega|Ride"] = 7290.94, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 26.25, ["Ride"] = 62.75, ["Neon"] = 274.8, ["Neon|Ride"] = 280.04, ["Neon|Fly|Ride"] = 839.05, ["Mega|Ride"] = 929.48, ["Mega|Fly|Ride"] = 1039.84}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 145.78, ["Ride"] = 576.78, ["Fly|Ride"] = 597.19, ["Neon"] = 1538.59, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 2993.27}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 1771.88, ["Fly"] = 2516.8, ["Ride"] = 2097.34, ["Fly|Ride"] = 1967.44, ["Neon|Fly|Ride"] = 6790.94, ["Mega|Fly|Ride"] = 31911.51}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 55.12, ["Ride"] = 61.69, ["Fly|Ride"] = 262.58, ["Neon"] = 288.43, ["Neon|Fly|Ride"] = 309.37, ["Mega"] = 1959.16, ["Mega|Ride"] = 2307.36, ["Mega|Fly|Ride"] = 1963.36}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 630, ["Fly"] = 675.94, ["Ride"] = 643.13, ["Fly|Ride"] = 630, ["Neon|Ride"] = 1455.56, ["Neon|Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 2782.5}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 48.27, ["Fly"] = 81.23, ["Ride"] = 42, ["Fly|Ride"] = 131.25, ["Neon"] = 209.77, ["Neon|Ride"] = 513.45, ["Neon|Fly|Ride"] = 223.13, ["Mega|Fly|Ride"] = 921.9}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 2.63, ["Fly"] = 23.63, ["Ride"] = 20.98, ["Fly|Ride"] = 39.52, ["Neon"] = 19.69, ["Neon|Fly"] = 65.6, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 137.41, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 41.89, ["Ride"] = 65.03, ["Fly|Ride"] = 252, ["Neon"] = 1258.57, ["Neon|Ride"] = 769.82, ["Neon|Fly|Ride"] = 310.22, ["Mega"] = 1394.18, ["Mega|Ride"] = 1119.07, ["Mega|Fly|Ride"] = 6992.3}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 629.22, ["Fly"] = 608.24, ["Ride"] = 614.53, ["Fly|Ride"] = 638.4, ["Neon"] = 1816.53, ["Neon|Ride"] = 2756.25, ["Neon|Fly|Ride"] = 1968.75, ["Mega|Fly|Ride"] = 5775}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 507.97, ["Ride"] = 577.83, ["Fly|Ride"] = 656.25, ["Neon"] = 8390.34, ["Neon|Ride"] = 4068.75, ["Neon|Fly|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 12585.5}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 13.71, ["Fly"] = 32.82, ["Ride"] = 18.94, ["Fly|Ride"] = 39.35, ["Neon|Ride"] = 155.67, ["Neon|Fly|Ride"] = 125.9, ["Mega|Fly|Ride"] = 419.53}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 11.82, ["Ride"] = 26.25, ["Fly|Ride"] = 62.94, ["Neon"] = 69.75, ["Neon|Ride"] = 92.96, ["Neon|Fly|Ride"] = 155.67, ["Mega"] = 1968.75, ["Mega|Ride"] = 464.75, ["Mega|Fly|Ride"] = 477.21}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 3.65, ["Ride"] = 28.32, ["Fly|Ride"] = 91.25, ["Neon"] = 19.69, ["Neon|Fly"] = 112.24, ["Neon|Ride"] = 46.49, ["Neon|Fly|Ride"] = 280.04, ["Mega"] = 154.88, ["Mega|Ride"] = 186.38, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 41.06, ["Fly"] = 62.75, ["Ride"] = 41.97, ["Fly|Ride"] = 136.36, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 249.38, ["Mega|Fly|Ride"] = 734.16}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 39.38, ["Ride"] = 86.63, ["Fly|Ride"] = 620.42, ["Neon"] = 336.99, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 976.44, ["Mega|Ride"] = 1048.81, ["Mega|Fly|Ride"] = 1258.57}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 18.38, ["Fly"] = 57.14, ["Ride"] = 36.75, ["Fly|Ride"] = 72.19, ["Neon"] = 98.44, ["Neon|Ride"] = 92.93, ["Neon|Fly|Ride"] = 123.48, ["Mega|Ride"] = 377.58, ["Mega|Fly|Ride"] = 519.17}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 37.41, ["Fly"] = 87.68, ["Ride"] = 40.69, ["Fly|Ride"] = 109.22, ["Neon"] = 348.22, ["Neon|Ride"] = 174.09, ["Neon|Fly|Ride"] = 266.41, ["Mega"] = 2100, ["Mega|Fly|Ride"] = 1126.28}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 5.16, ["Fly"] = 41.96, ["Ride"] = 16.99, ["Fly|Ride"] = 42.4, ["Neon"] = 31.38, ["Neon|Ride"] = 45.32, ["Neon|Fly|Ride"] = 104.89, ["Mega"] = 177.19, ["Mega|Ride"] = 182.52, ["Mega|Fly|Ride"] = 397.5}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 5.16, ["Fly"] = 65.63, ["Ride"] = 27.89, ["Fly|Ride"] = 1838.01, ["Neon"] = 25.75, ["Neon|Fly"] = 155.69, ["Neon|Ride"] = 41.97, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 232.38, ["Mega|Ride"] = 140.55, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 36.74, ["Fly"] = 79.72, ["Ride"] = 60.38, ["Fly|Ride"] = 136.34, ["Neon"] = 560.07, ["Neon|Ride"] = 232.38, ["Neon|Fly|Ride"] = 216.46, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 2307.08, ["Fly"] = 2479.02, ["Ride"] = 1968.74, ["Fly|Ride"] = 1855.88, ["Neon|Ride"] = 5453.74, ["Neon|Fly|Ride"] = 4200, ["Mega|Fly|Ride"] = 14437.5}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 350.44, ["Fly"] = 685.84, ["Ride"] = 350.27, ["Fly|Ride"] = 393.75, ["Neon"] = 3098.57, ["Neon|Ride"] = 2496.14, ["Neon|Fly|Ride"] = 1798.13, ["Mega|Fly|Ride"] = 8249.8}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 280.01, ["Fly"] = 590.63, ["Ride"] = 285.26, ["Fly|Ride"] = 399, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1611.45, ["Mega|Fly|Ride"] = 5906.25}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 48.25}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 43.32, ["Fly"] = 65.63, ["Ride"] = 54.63, ["Fly|Ride"] = 69.23, ["Neon"] = 288.75, ["Neon|Ride"] = 224.46, ["Neon|Fly|Ride"] = 317.92, ["Mega|Ride"] = 1468.31, ["Mega|Fly|Ride"] = 1454.69}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 33557.23, ["Fly"] = 23625, ["Ride"] = 34781.25, ["Fly|Ride"] = 15881.25, ["Neon|Fly|Ride"] = 36749.9, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 253.32, ["Fly"] = 348.52, ["Ride"] = 296.19, ["Fly|Ride"] = 349.13, ["Neon"] = 915.6, ["Neon|Fly"] = 1094.44, ["Neon|Ride"] = 933.19, ["Neon|Fly|Ride"] = 735, ["Mega"] = 3497.74, ["Mega|Ride"] = 5062.53, ["Mega|Fly|Ride"] = 2488.49}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 5250, ["Ride"] = 249.38, ["Fly|Ride"] = 257.25, ["Neon|Fly|Ride"] = 839.05, ["Mega|Fly|Ride"] = 4055.69}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 78.75, ["Ride"] = 97.13, ["Fly|Ride"] = 193.26, ["Neon|Ride"] = 524.42, ["Neon|Fly|Ride"] = 566.36, ["Mega"] = 13984.6, ["Mega|Fly|Ride"] = 3146.39}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 13.13, ["Fly"] = 94.5, ["Ride"] = 40.69, ["Fly|Ride"] = 87.15, ["Neon|Ride"] = 83.92, ["Neon|Fly|Ride"] = 262.5, ["Mega|Fly|Ride"] = 560.07}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 3911.15, ["Ride"] = 3675, ["Fly|Ride"] = 4265.44, ["Neon|Fly|Ride"] = 15750}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 28.39, ["Fly"] = 45.94, ["Ride"] = 37.77, ["Fly|Ride"] = 64.3, ["Neon"] = 144.38, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 236.25, ["Mega|Fly|Ride"] = 632.63}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 45.3, ["Fly"] = 140.54, ["Ride"] = 53.62, ["Fly|Ride"] = 87.28, ["Neon"] = 155.69, ["Neon|Ride"] = 280.04, ["Neon|Fly|Ride"] = 367.5, ["Mega|Fly|Ride"] = 836.95}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 582.73, ["Fly"] = 656.25, ["Ride"] = 589.32, ["Fly|Ride"] = 713.98, ["Neon"] = 1312.5, ["Neon|Ride"] = 1677.03, ["Neon|Fly|Ride"] = 1312.5, ["Mega"] = 4755.23, ["Mega|Fly|Ride"] = 4146.19}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 16.21, ["Fly"] = 28.04, ["Ride"] = 26.25, ["Fly|Ride"] = 49.88, ["Neon|Fly"] = 188.81, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 137.81, ["Mega"] = 699.57, ["Mega|Fly|Ride"] = 523.68}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 15.74, ["Ride"] = 140.44, ["Fly|Ride"] = 464.75, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 232.38}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 98.44, ["Ride"] = 140.54, ["Fly|Ride"] = 167.83, ["Neon"] = 699.57, ["Neon|Ride"] = 620.42, ["Neon|Fly|Ride"] = 809.82, ["Mega|Ride"] = 2357.71, ["Mega|Fly|Ride"] = 2360.85}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 17.46, ["Ride"] = 77.6, ["Fly|Ride"] = 140.55, ["Neon"] = 86.03, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 232.38, ["Mega"] = 262.5, ["Mega|Fly"] = 654.94, ["Mega|Ride"] = 293.01, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 4236.62, ["Ride"] = 3281.25, ["Fly|Ride"] = 3150, ["Neon"] = 9313.27, ["Neon|Ride"] = 17041.47, ["Neon|Fly|Ride"] = 7875, ["Mega"] = 62927.47, ["Mega|Fly|Ride"] = 38727.86}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 36.91, ["Ride"] = 85.32, ["Fly|Ride"] = 104.89, ["Neon"] = 271.88, ["Neon|Ride"] = 271.88, ["Neon|Fly|Ride"] = 328.13, ["Mega|Fly|Ride"] = 839.05}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 9088.77, ["Ride"] = 7743.7, ["Fly|Ride"] = 5879.99, ["Neon|Ride"] = 19828.66, ["Neon|Fly|Ride"] = 17062.5, ["Mega|Fly|Ride"] = 62858.25}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.63, ["Fly"] = 27.27, ["Ride"] = 18.88, ["Fly|Ride"] = 36.16, ["Neon"] = 20.99, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 83.92, ["Mega"] = 449.64, ["Mega|Fly|Ride"] = 224.46}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 20.92, ["Fly"] = 35.69, ["Ride"] = 29.92, ["Fly|Ride"] = 48.57, ["Neon"] = 140.55, ["Neon|Ride"] = 280.04, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 1401.1, ["Mega|Fly|Ride"] = 927.14}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 2.63}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 10.49, ["Ride"] = 34.13, ["Fly|Ride"] = 140.54, ["Neon"] = 112.22, ["Neon|Ride"] = 153.57, ["Neon|Fly|Ride"] = 170.63, ["Mega|Ride"] = 698.52, ["Mega|Fly|Ride"] = 852.78}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 36.75, ["Fly"] = 70.27, ["Ride"] = 70.27, ["Neon"] = 178.31, ["Neon|Ride"] = 182.44, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 840, ["Mega|Ride"] = 929.48, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 10.97, ["Fly"] = 24.13, ["Ride"] = 26.25, ["Fly|Ride"] = 44.63, ["Neon"] = 54.55, ["Neon|Ride"] = 174.57, ["Neon|Fly|Ride"] = 162.67, ["Mega"] = 1120.12, ["Mega|Fly|Ride"] = 945}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8968.11}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2824.5}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 35.67}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 593.56, ["Fly"] = 560, ["Ride"] = 140.54, ["Fly|Ride"] = 656.25, ["Neon|Ride"] = 1706.25, ["Neon|Fly|Ride"] = 2223.45, ["Mega|Fly|Ride"] = 5594.27}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 27.56, ["Fly"] = 132.15, ["Ride"] = 49.3, ["Fly|Ride"] = 131.25, ["Neon"] = 209.77, ["Neon|Ride"] = 406.88, ["Mega|Ride"] = 628.24, ["Mega|Fly|Ride"] = 734.16}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 9.19}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 9.17, ["Ride"] = 56.64, ["Neon"] = 70.88, ["Neon|Ride"] = 249.38}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2572.5}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 156.19, ["Ride"] = 309.75, ["Fly|Ride"] = 291.59, ["Neon"] = 697.1, ["Neon|Ride"] = 699.65, ["Neon|Fly|Ride"] = 839.05, ["Mega|Fly|Ride"] = 2154.24}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 139.41, ["Ride"] = 195.07, ["Fly|Ride"] = 525, ["Neon"] = 503.44, ["Neon|Ride"] = 519.17, ["Neon|Fly|Ride"] = 560.07, ["Mega|Ride"] = 1575, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 174.57, ["Ride"] = 174.56, ["Fly|Ride"] = 204.75, ["Neon"] = 945.74, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 915.5, ["Mega"] = 6153.28, ["Mega|Fly|Ride"] = 2937.38}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1090.69, ["Fly"] = 2516.8, ["Ride"] = 1116.94, ["Fly|Ride"] = 1102.5, ["Neon|Fly|Ride"] = 4593.75, ["Mega|Fly|Ride"] = 20975.83}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 14.81, ["Fly"] = 81.82, ["Ride"] = 46.16, ["Fly|Ride"] = 86.63, ["Neon"] = 140.55, ["Neon|Ride"] = 140.55, ["Neon|Fly|Ride"] = 419.53, ["Mega"] = 733.11, ["Mega|Fly|Ride"] = 909.32}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 656.25, ["Fly"] = 2100, ["Ride"] = 699.48, ["Fly|Ride"] = 839.05, ["Neon|Fly|Ride"] = 4028.01}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 52.5}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 15.28, ["Fly"] = 144.38, ["Ride"] = 39.38, ["Fly|Ride"] = 98.44, ["Neon"] = 73.5, ["Neon|Ride"] = 155.69, ["Neon|Fly|Ride"] = 489.8, ["Mega"] = 347.82, ["Mega|Ride"] = 458.07, ["Mega|Fly|Ride"] = 485.63}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 9.45, ["Fly"] = 36.71, ["Ride"] = 28.88, ["Fly|Ride"] = 65.63, ["Neon"] = 70.28, ["Neon|Ride"] = 115.5, ["Neon|Fly|Ride"] = 200.16, ["Mega|Ride"] = 398.55, ["Mega|Fly|Ride"] = 619.5}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 96.5}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 26.99, ["Fly"] = 108.92, ["Ride"] = 38.06, ["Fly|Ride"] = 65.54, ["Neon"] = 177.19, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 278.99, ["Mega"] = 812.83, ["Mega|Ride"] = 839.05, ["Mega|Fly|Ride"] = 657.6}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["Fly"] = 39.37, ["Ride"] = 62, ["Fly|Ride"] = 67.13, ["Neon"] = 155.69, ["Neon|Fly"] = 241.66, ["Neon|Ride"] = 418.48, ["Neon|Fly|Ride"] = 274.32, ["Mega"] = 1397, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 5223.75, ["Fly"] = 11186.11, ["Ride"] = 6152.52, ["Fly|Ride"] = 5092.5, ["Neon|Ride"] = 12166, ["Neon|Fly|Ride"] = 10078.69, ["Mega|Fly|Ride"] = 34648.69}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 9.93, ["Ride"] = 34.88, ["Fly|Ride"] = 110.39, ["Neon"] = 70.28, ["Neon|Fly"] = 133.21, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 125.87, ["Mega"] = 462.53, ["Mega|Ride"] = 388.06, ["Mega|Fly|Ride"] = 434.53}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 31.49}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 99.3, ["Fly"] = 371.24, ["Ride"] = 139.39, ["Fly|Ride"] = 183.75, ["Neon"] = 418.69, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 572.65, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 72.19, ["Fly"] = 183.75, ["Ride"] = 98.44, ["Fly|Ride"] = 168, ["Neon"] = 280.04, ["Neon|Ride"] = 380.63, ["Neon|Fly|Ride"] = 403.17, ["Mega|Ride"] = 1321.49, ["Mega|Fly|Ride"] = 1300.51}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 26.25, ["Fly"] = 70.86, ["Ride"] = 34.13, ["Fly|Ride"] = 57.75, ["Neon"] = 182.52, ["Neon|Ride"] = 147.58, ["Neon|Fly|Ride"] = 175.88, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 5.24, ["Fly"] = 49.87, ["Ride"] = 33.71, ["Fly|Ride"] = 101.07, ["Neon"] = 22.1, ["Neon|Fly"] = 182.52, ["Neon|Ride"] = 69.7, ["Neon|Fly|Ride"] = 130.12, ["Mega"] = 124.69, ["Mega|Fly"] = 7034.11, ["Mega|Ride"] = 171.94, ["Mega|Fly|Ride"] = 256.4}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 12.73, ["Fly"] = 74.37, ["Ride"] = 30.19, ["Fly|Ride"] = 96.49, ["Neon"] = 62.94, ["Neon|Ride"] = 96.48, ["Neon|Fly|Ride"] = 202.17, ["Mega|Ride"] = 419.99, ["Mega|Fly|Ride"] = 538.13}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 15.74, ["Fly"] = 33.69, ["Ride"] = 27.43, ["Fly|Ride"] = 48.4, ["Neon"] = 140.55, ["Neon|Fly"] = 209.77, ["Neon|Ride"] = 188.81, ["Neon|Fly|Ride"] = 118.13, ["Mega|Fly"] = 699.57, ["Mega|Fly|Ride"] = 611.46}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 236.25}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 23.09, ["Ride"] = 103.85, ["Neon"] = 104.89, ["Mega"] = 489.8, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 896.74}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 196.88, ["Ride"] = 209.75, ["Fly|Ride"] = 262.49, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 758.29}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 40.69, ["Ride"] = 97.67, ["Fly|Ride"] = 249.38, ["Neon"] = 266.41, ["Neon|Ride"] = 303.38, ["Neon|Fly|Ride"] = 464.75, ["Mega"] = 1069.79, ["Mega|Ride"] = 1257.52, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 654.94, ["Fly"] = 656.25, ["Ride"] = 754.69, ["Fly|Ride"] = 774.35, ["Neon"] = 1575, ["Neon|Ride"] = 2100, ["Neon|Fly|Ride"] = 1890, ["Mega|Fly|Ride"] = 6429.94}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 262.5, ["Ride"] = 346.5, ["Fly|Ride"] = 362.25, ["Neon"] = 1286.87, ["Neon|Ride"] = 2097.59, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 4056.68}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 84}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 10.5, ["Fly"] = 209.73, ["Ride"] = 25.74, ["Fly|Ride"] = 41.97, ["Neon"] = 80.07, ["Neon|Fly"] = 230.99, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 127.32, ["Mega|Ride"] = 419.53, ["Mega|Fly|Ride"] = 405.57}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 308.42, ["Fly"] = 629.22, ["Ride"] = 334.16, ["Fly|Ride"] = 459.38, ["Neon"] = 2780.36, ["Neon|Ride"] = 1017.19, ["Neon|Fly|Ride"] = 971.25, ["Mega"] = 4195.17, ["Mega|Fly|Ride"] = 3216.66}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 15.74}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 98.44, ["Fly"] = 590.63, ["Ride"] = 129.94, ["Fly|Ride"] = 232.38, ["Neon"] = 446.23, ["Neon|Fly"] = 1399.11, ["Neon|Ride"] = 545.39, ["Neon|Fly|Ride"] = 577.5, ["Mega"] = 2517.12, ["Mega|Fly|Ride"] = 1704.94}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 140.44, ["Ride"] = 157.5, ["Fly|Ride"] = 216.12, ["Neon"] = 896.93, ["Neon|Ride"] = 997.5, ["Neon|Fly|Ride"] = 699.57}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 7.88, ["Ride"] = 38.85, ["Fly|Ride"] = 104.88, ["Neon"] = 27.43, ["Neon|Ride"] = 46.47, ["Neon|Fly|Ride"] = 167.83, ["Mega"] = 196.14, ["Mega|Ride"] = 203.46, ["Mega|Fly|Ride"] = 406.95}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 14.44, ["Fly"] = 49.88, ["Ride"] = 35.44, ["Fly|Ride"] = 65.63, ["Neon"] = 112.24, ["Neon|Ride"] = 155.24, ["Neon|Fly|Ride"] = 260.12}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 21.93, ["Fly"] = 140.54, ["Ride"] = 41.96, ["Fly|Ride"] = 140.54, ["Neon"] = 220.71, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 270.38, ["Mega|Ride"] = 489.8, ["Mega|Fly|Ride"] = 553.79}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 5.24, ["Fly"] = 335.58, ["Ride"] = 52.5, ["Fly|Ride"] = 139.42, ["Neon"] = 22.3, ["Neon|Ride"] = 74.48, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 123.38, ["Mega|Fly"] = 183.74, ["Mega|Ride"] = 135.87, ["Mega|Fly|Ride"] = 195.57}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 324.19, ["Fly"] = 918.75, ["Ride"] = 335.58, ["Fly|Ride"] = 313.69, ["Neon"] = 1678.08, ["Neon|Ride"] = 1394.18, ["Neon|Fly|Ride"] = 1378.13}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 83.84, ["Fly"] = 1050, ["Ride"] = 133.88, ["Fly|Ride"] = 249.38, ["Neon"] = 433.13, ["Neon|Ride"] = 448.88, ["Neon|Fly|Ride"] = 557.82, ["Mega"] = 2447.89, ["Mega|Ride"] = 2056.69, ["Mega|Fly|Ride"] = 2080.82}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 81.38, ["Fly"] = 203.46, ["Ride"] = 98.44, ["Fly|Ride"] = 141.75, ["Neon|Ride"] = 288.75, ["Neon|Fly|Ride"] = 462.53, ["Mega|Fly|Ride"] = 1515.94}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 15.65, ["Ride"] = 56.64, ["Fly|Ride"] = 280.04, ["Neon"] = 209.77, ["Neon|Ride"] = 590.21, ["Neon|Fly|Ride"] = 489.8, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 12.08, ["Fly"] = 70.27, ["Ride"] = 48.57, ["Fly|Ride"] = 102.38, ["Neon"] = 94.6, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 167.83, ["Mega"] = 504.24, ["Mega|Fly"] = 525, ["Mega|Ride"] = 472.5, ["Mega|Fly|Ride"] = 444.94}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.54, ["Fly"] = 41.96, ["Ride"] = 21, ["Fly|Ride"] = 138.46, ["Neon"] = 19.69, ["Neon|Ride"] = 30.55, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 133.66, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 213.94}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 1063.13, ["Fly"] = 1140.97, ["Ride"] = 984.38, ["Fly|Ride"] = 984.38, ["Neon"] = 2625, ["Neon|Fly"] = 2831.75, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2401.88, ["Mega"] = 11887.01, ["Mega|Fly|Ride"] = 7481.25}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 310.17, ["Ride"] = 321.57, ["Fly|Ride"] = 328.13, ["Neon"] = 1048.81, ["Neon|Ride"] = 1036.88, ["Neon|Fly|Ride"] = 1020.49, ["Mega"] = 10487.92, ["Mega|Fly|Ride"] = 4068.75}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 144.73, ["Ride"] = 145.69, ["Fly|Ride"] = 310.19, ["Neon"] = 384.57, ["Neon|Ride"] = 320.25, ["Neon|Fly|Ride"] = 335.64, ["Mega"] = 1443.75, ["Mega|Ride"] = 1678.08, ["Mega|Fly|Ride"] = 1524.58}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 203.39, ["Ride"] = 209.97, ["Fly|Ride"] = 304.13, ["Neon"] = 699.57, ["Neon|Ride"] = 905.63, ["Neon|Fly|Ride"] = 1021.54, ["Mega"] = 10487.92, ["Mega|Fly|Ride"] = 2934.53}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 21, ["Fly"] = 48.25, ["Ride"] = 39.38, ["Fly|Ride"] = 70.27, ["Neon"] = 155.69, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 157.5, ["Mega|Ride"] = 699.57, ["Mega|Fly|Ride"] = 619.12}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 346.5, ["Ride"] = 419.48, ["Fly|Ride"] = 560, ["Neon"] = 1584.98, ["Neon|Ride"] = 1115.63, ["Neon|Fly|Ride"] = 1378.13, ["Mega"] = 5250, ["Mega|Fly|Ride"] = 4878.99}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 118.52, ["Fly"] = 126, ["Ride"] = 70.27, ["Neon|Ride"] = 367.5, ["Mega|Fly|Ride"] = 2014.6}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1307.25, ["Ride"] = 1510.08, ["Fly|Ride"] = 1480.91, ["Neon|Ride"] = 4404.93, ["Neon|Fly|Ride"] = 3675, ["Mega"] = 50341.99, ["Mega|Fly|Ride"] = 24469.36}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 10.19, ["Fly"] = 41.96, ["Ride"] = 39.38, ["Fly|Ride"] = 112.24, ["Neon"] = 63.66, ["Neon|Fly"] = 167.32, ["Neon|Ride"] = 83.98, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 305.75, ["Mega|Ride"] = 280.04, ["Mega|Fly|Ride"] = 563.77}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 125.89, ["Ride"] = 155.68, ["Fly|Ride"] = 209.77, ["Neon"] = 315, ["Neon|Ride"] = 218.17, ["Neon|Fly|Ride"] = 419.53, ["Mega|Fly|Ride"] = 973.29}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 78.64, ["Fly"] = 78.75, ["Ride"] = 81.03, ["Fly|Ride"] = 104.87, ["Neon|Ride"] = 392.26, ["Neon|Fly|Ride"] = 393.73, ["Mega|Fly|Ride"] = 1469.99}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 2515.76, ["Ride"] = 958.13, ["Fly|Ride"] = 1076.25, ["Neon|Fly|Ride"] = 4199.99, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 470.16, ["Ride"] = 433.13, ["Fly|Ride"] = 525, ["Neon|Ride"] = 1749.4, ["Neon|Fly|Ride"] = 1468.31, ["Mega|Fly|Ride"] = 9139.99}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 128.36, ["Fly"] = 209.75, ["Ride"] = 164.07, ["Fly|Ride"] = 250.97, ["Neon"] = 419.53, ["Neon|Ride"] = 456.75, ["Neon|Fly|Ride"] = 519.49, ["Mega"] = 3985.43, ["Mega|Ride"] = 1704.94, ["Mega|Fly|Ride"] = 1852.18}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 11.17, ["Ride"] = 20.98, ["Fly|Ride"] = 87.94, ["Neon"] = 101.07, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 233.63, ["Mega"] = 280.04, ["Mega|Fly|Ride"] = 979.58}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 41.97, ["Fly"] = 95.82, ["Ride"] = 64.32, ["Fly|Ride"] = 91.25, ["Neon"] = 249.38, ["Neon|Fly"] = 405.9, ["Neon|Ride"] = 246.48, ["Neon|Fly|Ride"] = 313.61, ["Mega"] = 1818.62, ["Mega|Fly|Ride"] = 1049.99}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 720.57, ["Ride"] = 871.5, ["Fly|Ride"] = 943.69, ["Neon"] = 3286.92, ["Neon|Ride"] = 2828.44, ["Neon|Fly|Ride"] = 3045.7, ["Mega|Fly|Ride"] = 17480.22}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 758.63}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 4068.75, ["Ride"] = 4692.78, ["Fly|Ride"] = 4003.13, ["Neon|Ride"] = 30059.42, ["Neon|Fly|Ride"] = 15491.62, ["Mega|Fly|Ride"] = 89497.55}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 150.94, ["Fly"] = 408.19, ["Ride"] = 350.27, ["Fly|Ride"] = 405.9, ["Neon"] = 629.29, ["Neon|Ride"] = 643.97, ["Neon|Fly|Ride"] = 918.75, ["Mega"] = 5873.24, ["Mega|Fly|Ride"] = 6292.76}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 77.44, ["Ride"] = 98.59, ["Fly|Ride"] = 336, ["Neon"] = 441, ["Neon|Ride"] = 466.73, ["Neon|Fly|Ride"] = 645.02}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 12.89, ["Fly"] = 131.25, ["Ride"] = 32.92, ["Fly|Ride"] = 91.88, ["Neon"] = 69.22, ["Neon|Ride"] = 116.44, ["Neon|Fly|Ride"] = 155.25, ["Mega|Ride"] = 839.05, ["Mega|Fly|Ride"] = 616.93}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 15.74, ["Fly"] = 29.81, ["Ride"] = 30.19, ["Fly|Ride"] = 53.82, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 2223.45}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 19.69, ["Fly"] = 70.9, ["Ride"] = 47.25, ["Fly|Ride"] = 105, ["Neon"] = 109.23, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 187.69, ["Mega|Ride"] = 859.69, ["Mega|Fly|Ride"] = 685.93}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 6.57, ["Fly"] = 28.32, ["Ride"] = 28.32, ["Fly|Ride"] = 41.97, ["Neon"] = 21, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 310.22, ["Mega|Ride"] = 310.22, ["Mega|Fly|Ride"] = 357}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 32.82, ["Fly|Ride"] = 165.38, ["Neon"] = 144.08, ["Neon|Ride"] = 310.22, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 671.25, ["Mega|Ride"] = 787.66, ["Mega|Fly|Ride"] = 734.16}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 256.86, ["Fly"] = 348.34, ["Ride"] = 262.5, ["Fly|Ride"] = 313.69, ["Neon"] = 725.78, ["Neon|Ride"] = 713.2, ["Neon|Fly|Ride"] = 732.38, ["Mega"] = 6562.5, ["Mega|Ride"] = 4195.17, ["Mega|Fly|Ride"] = 3806.24}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 3.54, ["Fly"] = 16.79, ["Ride"] = 18.32, ["Fly|Ride"] = 39.38, ["Neon"] = 18.96, ["Neon|Fly"] = 92.96, ["Neon|Ride"] = 32.52, ["Neon|Fly|Ride"] = 76.06, ["Mega"] = 839.05, ["Mega|Ride"] = 209.77, ["Mega|Fly|Ride"] = 267.75}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 34.61, ["Fly"] = 105, ["Ride"] = 52.5, ["Fly|Ride"] = 128.63, ["Neon"] = 185.07, ["Neon|Fly"] = 288.75, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 234.63, ["Mega"] = 485.63, ["Mega|Ride"] = 548.42, ["Mega|Fly|Ride"] = 511.86}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 761.25, ["Ride"] = 761.25, ["Fly|Ride"] = 707.44, ["Neon|Ride"] = 1959.16, ["Neon|Fly|Ride"] = 1574.99, ["Mega|Fly|Ride"] = 3937.5}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 24.93, ["Fly"] = 69.71, ["Ride"] = 34.92, ["Fly|Ride"] = 70.3, ["Neon"] = 125.87, ["Neon|Fly"] = 464.75, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 178.29, ["Mega"] = 1575, ["Mega|Ride"] = 979.58, ["Mega|Fly|Ride"] = 839.05}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 317.62, ["Fly"] = 316.32, ["Ride"] = 274.32, ["Fly|Ride"] = 328.13, ["Neon"] = 1399.11, ["Neon|Fly|Ride"] = 1311.19, ["Mega|Fly|Ride"] = 4457.37}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 126, ["Fly"] = 129.94, ["Ride"] = 129.89, ["Fly|Ride"] = 124.69, ["Neon|Fly"] = 637.68, ["Neon|Ride"] = 560.07, ["Neon|Fly|Ride"] = 560.07, ["Mega"] = 2936.62, ["Mega|Fly|Ride"] = 1916.16}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 731.98, ["Ride"] = 525, ["Fly|Ride"] = 748.13, ["Neon"] = 2652.43, ["Neon|Ride"] = 2377.62, ["Neon|Fly|Ride"] = 2412.23, ["Mega|Fly|Ride"] = 7677.16}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 26.76, ["Ride"] = 52.5, ["Fly|Ride"] = 95.44, ["Neon"] = 61.69, ["Neon|Fly"] = 278.84, ["Neon|Ride"] = 104.57, ["Neon|Fly|Ride"] = 224.46, ["Mega"] = 418.48, ["Mega|Ride"] = 414.29, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 3739.37, ["Fly"] = 3956.54, ["Ride"] = 3936.19, ["Fly|Ride"] = 3149.9, ["Neon"] = 13948.94, ["Neon|Fly|Ride"] = 6992.3, ["Mega|Fly|Ride"] = 23745.75}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 78.75, ["Fly"] = 120.62, ["Ride"] = 103.69, ["Fly|Ride"] = 158.37, ["Neon"] = 394.78, ["Neon|Ride"] = 446.25, ["Neon|Fly|Ride"] = 401.63, ["Mega|Fly|Ride"] = 1704.4}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.63, ["Fly"] = 28.32, ["Ride"] = 19.69, ["Fly|Ride"] = 44.63, ["Neon"] = 19.67, ["Neon|Fly"] = 44.63, ["Neon|Ride"] = 56.64, ["Neon|Fly|Ride"] = 104.9, ["Mega"] = 118.53, ["Mega|Fly"] = 452.82, ["Mega|Ride"] = 203.48, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.61, ["Ride"] = 28.88, ["Fly|Ride"] = 65.63, ["Neon"] = 22.32, ["Neon|Ride"] = 103.42, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 147, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 278.2}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 60.59, ["Fly"] = 39.38, ["Ride"] = 40.69, ["Fly|Ride"] = 78.75, ["Neon|Ride"] = 699.57, ["Neon|Fly|Ride"] = 278.81, ["Mega|Fly|Ride"] = 1244.93}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 853.13, ["Ride"] = 1185.18, ["Fly|Ride"] = 1181.24, ["Neon"] = 3771.47, ["Neon|Fly|Ride"] = 3748.39, ["Mega|Fly|Ride"] = 20542.69}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 5174.12, ["Ride"] = 4978.02, ["Fly|Ride"] = 4916.75}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 17.45, ["Fly"] = 45.94, ["Ride"] = 28.32, ["Fly|Ride"] = 47.25, ["Neon"] = 142.65, ["Neon|Ride"] = 144.8, ["Neon|Fly|Ride"] = 139.01, ["Mega"] = 2517.12, ["Mega|Fly|Ride"] = 556.92}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 18.51, ["Fly"] = 45.11, ["Ride"] = 35.66, ["Fly|Ride"] = 83.95, ["Neon"] = 94.47, ["Neon|Ride"] = 106.63, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 929.48, ["Mega|Ride"] = 774.95, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 38.06, ["Fly"] = 157.5, ["Ride"] = 40.69, ["Fly|Ride"] = 91.88, ["Neon"] = 393.75, ["Neon|Ride"] = 245.44, ["Neon|Fly|Ride"] = 249.38, ["Mega|Fly|Ride"] = 866.24}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 217.88, ["Ride"] = 236.25, ["Fly|Ride"] = 294, ["Neon|Ride"] = 1354.5, ["Neon|Fly|Ride"] = 1147.39, ["Mega"] = 10487.92, ["Mega|Fly|Ride"] = 3098.57}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.94, ["Neon"] = 20.97, ["Neon|Fly"] = 70.95, ["Neon|Fly|Ride"] = 155.69, ["Mega"] = 158.81, ["Mega|Ride"] = 270.6, ["Mega|Fly|Ride"] = 309.41}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 190.44, ["Fly"] = 280.01, ["Ride"] = 226.53, ["Fly|Ride"] = 282.19, ["Neon"] = 736.28, ["Neon|Ride"] = 813.28, ["Neon|Fly|Ride"] = 733.68, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 3.42, ["Fly"] = 73.5, ["Ride"] = 16.93, ["Fly|Ride"] = 46.16, ["Neon"] = 464.75, ["Neon|Fly|Ride"] = 105, ["Mega"] = 280.04, ["Mega|Ride"] = 419.53, ["Mega|Fly|Ride"] = 392.26}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 243.28, ["Fly"] = 170.63, ["Ride"] = 245.43, ["Fly|Ride"] = 275.63, ["Neon|Fly|Ride"] = 896.74, ["Mega"] = 10487.92, ["Mega|Ride"] = 4195.17, ["Mega|Fly|Ride"] = 3775.67}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 12.8, ["Fly"] = 419.48, ["Ride"] = 28.88, ["Fly|Ride"] = 87.15, ["Neon"] = 63, ["Neon|Fly"] = 295.11, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 392.26, ["Mega"] = 462.53, ["Mega|Ride"] = 587.33, ["Mega|Fly|Ride"] = 510.78}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 3.68, ["Ride"] = 27.27, ["Fly|Ride"] = 157.5, ["Neon"] = 14.96, ["Neon|Fly"] = 170.63, ["Neon|Ride"] = 60.84, ["Neon|Fly|Ride"] = 163.8, ["Mega"] = 76.13, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 213.42}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 6.27, ["Mega"] = 70.28}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 2.1, ["Ride"] = 41.96, ["Fly|Ride"] = 218.17, ["Neon"] = 11.82, ["Neon|Ride"] = 48.26, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 77.62, ["Mega|Fly"] = 154909.04, ["Mega|Ride"] = 90.57}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 65.63, ["Fly"] = 138.44, ["Ride"] = 100.99, ["Fly|Ride"] = 158.45, ["Neon"] = 183.75, ["Neon|Ride"] = 321.99, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 1223.96, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 1466.22}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 46.15, ["Ride"] = 17.46, ["Fly|Ride"] = 53.81, ["Neon"] = 3.94, ["Neon|Ride"] = 21.11, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 129.94, ["Mega|Ride"] = 136.36, ["Mega|Fly|Ride"] = 261.45}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 16.21, ["Ride"] = 98.58, ["Neon"] = 112.24, ["Neon|Ride"] = 112.24, ["Mega"] = 419.53, ["Mega|Ride"] = 560.07}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 77.63, ["Neon|Fly|Ride"] = 155.69, ["Mega"] = 15.58, ["Mega|Ride"] = 82.87, ["Mega|Fly|Ride"] = 280.03}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 17.05, ["Ride"] = 15.75, ["Fly|Ride"] = 35.68, ["Neon"] = 2.1, ["Neon|Ride"] = 15.74, ["Neon|Fly|Ride"] = 77.17, ["Mega"] = 17.45, ["Mega|Ride"] = 25.99, ["Mega|Fly|Ride"] = 56.42}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Ride"] = 14.44, ["Fly|Ride"] = 45.86, ["Neon"] = 2.1, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 140.55, ["Mega"] = 18.59, ["Mega|Ride"] = 41.97, ["Mega|Fly|Ride"] = 123.78}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Mega"] = 36.71, ["Mega|Ride"] = 131.25}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 41.51, ["Ride"] = 17.46, ["Fly|Ride"] = 107.63, ["Neon"] = 3.97, ["Neon|Fly"] = 135.05, ["Neon|Ride"] = 92.3, ["Neon|Fly|Ride"] = 81.38, ["Mega"] = 220.77, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 96.5, ["Mega|Fly|Ride"] = 190.32}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 3.92, ["Neon|Fly|Ride"] = 140.55, ["Mega"] = 15.74, ["Mega|Ride"] = 78.75}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 2.3, ["Fly"] = 47.16, ["Ride"] = 19.34, ["Fly|Ride"] = 56.65, ["Neon"] = 6.23, ["Neon|Fly"] = 37.96, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 66.2, ["Mega"] = 98.44, ["Mega|Fly"] = 78.75, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 181.69}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 26.17, ["Mega"] = 14.96, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 120.75}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.1, ["Fly|Ride"] = 525, ["Neon"] = 15.74, ["Neon|Ride"] = 70.28, ["Mega"] = 140.44, ["Mega|Ride"] = 157.5}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 4.99, ["Neon"] = 16.88}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Neon"] = 6.56, ["Neon|Ride"] = 36.95, ["Neon|Fly|Ride"] = 75.53, ["Mega"] = 21, ["Mega|Ride"] = 173.13}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 30.22, ["Ride"] = 18.38, ["Fly|Ride"] = 41.97, ["Neon"] = 2.1, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 18.89, ["Neon|Fly|Ride"] = 32.82, ["Mega"] = 15.74, ["Mega|Ride"] = 28.33, ["Mega|Fly|Ride"] = 43.32}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.63, ["Fly"] = 72.19, ["Ride"] = 218.19, ["Fly|Ride"] = 99.65, ["Neon"] = 131.25, ["Mega"] = 251.72, ["Mega|Ride"] = 350.32}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.63, ["Ride"] = 42, ["Fly|Ride"] = 78.73, ["Neon"] = 7.87, ["Neon|Ride"] = 41.97, ["Mega"] = 45.94, ["Mega|Ride"] = 209.77, ["Mega|Fly|Ride"] = 140.55}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 6.32, ["Neon"] = 11.81, ["Neon|Fly|Ride"] = 140.55, ["Mega"] = 78.75, ["Mega|Ride"] = 197.19}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 4.22, ["Fly"] = 31.7, ["Ride"] = 32.71, ["Fly|Ride"] = 190.86, ["Neon"] = 12.6, ["Neon|Fly"] = 91.81, ["Neon|Ride"] = 49.31, ["Mega"] = 209.77, ["Mega|Ride"] = 85.3, ["Mega|Fly|Ride"] = 280.04}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 11.82, ["Ride"] = 19.94, ["Fly|Ride"] = 27.57, ["Neon"] = 2.1, ["Neon|Fly"] = 20.99, ["Neon|Ride"] = 15.74, ["Neon|Fly|Ride"] = 29.61, ["Mega"] = 17.45, ["Mega|Ride"] = 21, ["Mega|Fly|Ride"] = 50.51}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 3.92, ["Fly"] = 15.74, ["Ride"] = 19.65, ["Fly|Ride"] = 138.46, ["Neon"] = 15.74, ["Neon|Ride"] = 111.55, ["Mega"] = 90.21, ["Mega|Ride"] = 125.87, ["Mega|Fly|Ride"] = 204.42}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 3.77, ["Fly|Ride"] = 140.55, ["Neon"] = 73.76, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 309.41, ["Mega|Ride"] = 277.55, ["Mega|Fly|Ride"] = 448.9}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 22.13, ["Ride"] = 18.88, ["Fly|Ride"] = 35.68, ["Neon"] = 2.63, ["Neon|Fly"] = 23.39, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 32.82, ["Mega"] = 17.43, ["Mega|Fly"] = 156.19, ["Mega|Ride"] = 28.88, ["Mega|Fly|Ride"] = 98.43}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.1, ["Neon"] = 6.2, ["Neon|Fly"] = 77.63, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 105, ["Mega"] = 59.96, ["Mega|Ride"] = 62.94}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 28.49, ["Neon"] = 7.76, ["Neon|Fly"] = 155.24, ["Neon|Fly|Ride"] = 310.22, ["Mega"] = 28.88, ["Mega|Ride"] = 66.08, ["Mega|Fly|Ride"] = 280.04}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Ride"] = 27.57, ["Neon"] = 2.1, ["Neon|Fly"] = 40.69, ["Neon|Ride"] = 48.26, ["Neon|Fly|Ride"] = 82.69, ["Mega"] = 15.75, ["Mega|Ride"] = 69.71}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 41.96, ["Ride"] = 17, ["Fly|Ride"] = 41.97, ["Neon"] = 6.56, ["Neon|Fly"] = 46.16, ["Neon|Ride"] = 27.28, ["Neon|Fly|Ride"] = 70.28, ["Mega"] = 94.5, ["Mega|Ride"] = 105}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.63, ["Ride"] = 41.95, ["Neon"] = 9.18, ["Neon|Ride"] = 32.82, ["Mega"] = 65.62, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 174.57}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 28.32, ["Ride"] = 19.94, ["Fly|Ride"] = 108.94, ["Neon"] = 6.03, ["Neon|Ride"] = 28.33, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 65.63, ["Mega|Fly"] = 126.48, ["Mega|Ride"] = 103.84, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 16.99, ["Fly"] = 35.66, ["Ride"] = 80.99, ["Mega"] = 296.63, ["Mega|Fly|Ride"] = 844.06}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Ride"] = 20.94, ["Fly|Ride"] = 5344.35, ["Neon"] = 11.8, ["Neon|Fly"] = 58.78, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 102.38, ["Mega"] = 315, ["Mega|Fly|Ride"] = 560.07}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 3.92, ["Fly"] = 149.1, ["Fly|Ride"] = 141.75, ["Neon"] = 20.98, ["Neon|Fly"] = 56.65, ["Neon|Ride"] = 28.33, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 196.88, ["Mega|Ride"] = 136.5, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.63, ["Fly"] = 79.47, ["Fly|Ride"] = 104.57, ["Neon"] = 71.37, ["Mega"] = 315}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 157.5, ["Mega"] = 699.57, ["Mega|Fly|Ride"] = 794.07}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 3.94, ["Ride"] = 45.11, ["Fly|Ride"] = 70.28, ["Neon"] = 15.74, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 125.87, ["Mega"] = 258.02}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 5.97, ["Ride"] = 70.27, ["Neon"] = 39.38, ["Neon|Ride"] = 98.6, ["Neon|Fly|Ride"] = 140.55, ["Mega"] = 189, ["Mega|Ride"] = 231.05, ["Mega|Fly|Ride"] = 314.65}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 120.63, ["Mega"] = 21, ["Mega|Ride"] = 139.13, ["Mega|Fly|Ride"] = 141.75}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 53.81}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 6.41, ["Fly"] = 26.25, ["Ride"] = 27.27, ["Fly|Ride"] = 40.68, ["Neon"] = 41.97, ["Neon|Fly"] = 70.28, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 104.89, ["Mega"] = 210, ["Mega|Ride"] = 232.38, ["Mega|Fly|Ride"] = 372.35}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 18.36, ["Fly|Ride"] = 70.62, ["Neon"] = 6.18, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 171.97, ["Mega"] = 20.97, ["Mega|Ride"] = 94.5, ["Mega|Fly|Ride"] = 263.26}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 164.07, ["Neon"] = 6.29, ["Neon|Ride"] = 40.92, ["Mega"] = 52.5, ["Mega|Ride"] = 50.36, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.63, ["Fly"] = 45.94, ["Ride"] = 23.55, ["Neon"] = 20.98, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 96.5, ["Mega"] = 133.76, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 310.22}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 3.93, ["Neon"] = 44.06, ["Neon|Fly|Ride"] = 191.52, ["Mega"] = 393.75, ["Mega|Fly|Ride"] = 418.48}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Neon"] = 3.67, ["Neon|Ride"] = 51.14, ["Mega"] = 17.07, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 35.68, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Ride"] = 56.64, ["Fly|Ride"] = 279677.97, ["Neon"] = 4.2, ["Neon|Fly"] = 30.18, ["Neon|Ride"] = 30.22, ["Neon|Fly|Ride"] = 70.28, ["Mega"] = 18.89, ["Mega|Fly"] = 100.7, ["Mega|Ride"] = 74.47, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 28.25, ["Ride"] = 20.98, ["Fly|Ride"] = 48.15, ["Neon"] = 8.54, ["Neon|Fly"] = 70.28, ["Neon|Ride"] = 23.37, ["Neon|Fly|Ride"] = 140.55, ["Mega"] = 62.75, ["Mega|Ride"] = 135.45, ["Mega|Fly|Ride"] = 138.46}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Ride"] = 280.01, ["Neon"] = 4.6, ["Neon|Ride"] = 48.26, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 25.14, ["Mega|Ride"] = 63, ["Mega|Fly|Ride"] = 102.38}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 3.81, ["Neon|Ride"] = 38.06, ["Neon|Fly|Ride"] = 125.87, ["Mega"] = 19.67, ["Mega|Fly"] = 105, ["Mega|Ride"] = 83.71, ["Mega|Fly|Ride"] = 162.42}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 26.36, ["Ride"] = 21, ["Fly|Ride"] = 79.73, ["Neon"] = 3.93, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 28.33, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 26.23, ["Mega|Ride"] = 66.08, ["Mega|Fly|Ride"] = 139.42}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Ride"] = 46.49, ["Neon"] = 2.63, ["Neon|Fly|Ride"] = 125.87, ["Mega"] = 17.07, ["Mega|Ride"] = 205.57}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 4.2, ["Neon|Ride"] = 77.86, ["Neon|Fly|Ride"] = 420, ["Mega"] = 559.02, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 18.38, ["Neon"] = 8.21, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 58.75, ["Mega|Ride"] = 55.12, ["Mega|Fly|Ride"] = 124.34}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 11.82, ["Ride"] = 59.07, ["Neon"] = 167.83, ["Mega"] = 448.9, ["Mega|Ride"] = 489.8, ["Mega|Fly|Ride"] = 692.22}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.1, ["Fly"] = 6562.5, ["Ride"] = 19.69, ["Neon"] = 20.98, ["Neon|Fly|Ride"] = 110.25, ["Mega"] = 419.53, ["Mega|Ride"] = 288.75}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 9.19, ["Ride"] = 42, ["Fly|Ride"] = 419.48, ["Neon"] = 31.47, ["Neon|Ride"] = 280.04, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 265.13, ["Mega|Fly|Ride"] = 560.07}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 16.67, ["Ride"] = 15.65, ["Fly|Ride"] = 28.33, ["Neon"] = 2.1, ["Neon|Fly"] = 19.69, ["Neon|Ride"] = 15.74, ["Neon|Fly|Ride"] = 42, ["Mega"] = 16.79, ["Mega|Fly"] = 24.94, ["Mega|Ride"] = 23.08, ["Mega|Fly|Ride"] = 54.87}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 51.19, ["Neon"] = 15.74, ["Neon|Fly"] = 140.55, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 45.94, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 31.38, ["Neon|Ride"] = 31.47, ["Neon|Fly|Ride"] = 70.27, ["Mega"] = 18.38, ["Mega|Fly"] = 78.44, ["Mega|Ride"] = 36.71, ["Mega|Fly|Ride"] = 337.98}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 3.87, ["Neon|Fly"] = 60.9, ["Mega"] = 20.98, ["Mega|Fly|Ride"] = 185.91}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Ride"] = 24.13, ["Fly|Ride"] = 39.38, ["Neon"] = 11.64, ["Neon|Fly"] = 140.55, ["Neon|Ride"] = 41.11, ["Neon|Fly|Ride"] = 102.93, ["Mega"] = 140.55, ["Mega|Ride"] = 98.44, ["Mega|Fly|Ride"] = 411.3}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 245.44, ["Ride"] = 419.48, ["Fly|Ride"] = 838.94, ["Neon"] = 1537.54, ["Neon|Ride"] = 1059.19, ["Neon|Fly|Ride"] = 881, ["Mega"] = 8390.34, ["Mega|Fly|Ride"] = 4337.82}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Fly|Ride"] = 52.5, ["Neon"] = 8.3, ["Neon|Ride"] = 68.25, ["Mega"] = 62.75, ["Mega|Ride"] = 174.12, ["Mega|Fly|Ride"] = 552.74}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 9.3, ["Fly"] = 103.68, ["Ride"] = 31.82, ["Fly|Ride"] = 140.2, ["Neon"] = 72.19, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 603.75, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 1048.81}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 838.94, ["Ride"] = 15.53, ["Fly|Ride"] = 33.08, ["Neon"] = 3.91, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 61.69, ["Mega"] = 49.88, ["Mega|Ride"] = 77.86, ["Mega|Fly|Ride"] = 140.44}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Ride"] = 24.94, ["Fly|Ride"] = 121.67, ["Neon"] = 11.54, ["Neon|Fly"] = 41.97, ["Neon|Ride"] = 41.97, ["Mega"] = 125.87, ["Mega|Ride"] = 136.36, ["Mega|Fly|Ride"] = 208.72}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 3.13, ["Fly"] = 32.82, ["Ride"] = 22.32, ["Fly|Ride"] = 45.12, ["Neon"] = 28.59, ["Neon|Ride"] = 45.93, ["Neon|Fly|Ride"] = 87.28, ["Mega"] = 204.52, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 208.72}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 6.04, ["Ride"] = 23.63, ["Fly|Ride"] = 246.75, ["Neon"] = 57.75, ["Neon|Ride"] = 90.57, ["Neon|Fly|Ride"] = 622.99, ["Mega"] = 328.13, ["Mega|Ride"] = 419.53, ["Mega|Fly|Ride"] = 419.53}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.1, ["Fly"] = 28.32, ["Ride"] = 17.95, ["Fly|Ride"] = 45.94, ["Neon"] = 28.32, ["Neon|Fly"] = 70.32, ["Neon|Ride"] = 45.71, ["Neon|Fly|Ride"] = 52.49, ["Mega"] = 196.88, ["Mega|Ride"] = 419.53, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 78.72, ["Fly"] = 141.75, ["Ride"] = 109.6, ["Fly|Ride"] = 155.69, ["Neon"] = 523.95, ["Neon|Fly"] = 394.42, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 389.03, ["Mega|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 1565.82}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 209.75, ["Fly"] = 314.62, ["Ride"] = 222.33, ["Fly|Ride"] = 280.88, ["Neon"] = 1006.86, ["Neon|Ride"] = 1119.07, ["Neon|Fly|Ride"] = 1028.89, ["Mega"] = 10487.92, ["Mega|Fly|Ride"] = 4890.53}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 69.6, ["Fly"] = 118.13, ["Ride"] = 87.09, ["Fly|Ride"] = 118.12, ["Neon"] = 418.48, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 328.13, ["Mega|Fly|Ride"] = 1273.13}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 4.57, ["Ride"] = 40.91, ["Neon"] = 37.77, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 196.14, ["Mega"] = 586.28, ["Mega|Ride"] = 217.3, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 13.11, ["Fly"] = 41.96, ["Ride"] = 31.49, ["Fly|Ride"] = 78.73, ["Neon"] = 83.69, ["Neon|Ride"] = 140.55, ["Neon|Fly|Ride"] = 209.77, ["Mega"] = 482.16, ["Mega|Ride"] = 388.5, ["Mega|Fly|Ride"] = 607.69}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 31.49, ["Ride"] = 21, ["Fly|Ride"] = 46.49, ["Neon"] = 6.57, ["Neon|Fly"] = 51.18, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 34.47, ["Mega|Fly"] = 116.2, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 178.94}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 9.19, ["Fly"] = 288.4, ["Ride"] = 26.25, ["Fly|Ride"] = 104.88, ["Neon"] = 41.11, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 407.4, ["Mega"] = 497.27, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 309.41}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 18.38, ["Fly|Ride"] = 38.07, ["Neon"] = 13.71, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 32.52, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 131.24, ["Mega|Ride"] = 230.13, ["Mega|Fly|Ride"] = 218.17}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 4.99, ["Ride"] = 30.19, ["Fly|Ride"] = 328.13, ["Neon"] = 24.13, ["Neon|Ride"] = 81.82, ["Mega"] = 157.5}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 28.32, ["Neon"] = 2.1, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 15.74, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 209126.14}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 45.93, ["Ride"] = 31.47, ["Fly|Ride"] = 56.44, ["Neon"] = 17.45, ["Neon|Fly"] = 70.28, ["Neon|Ride"] = 56.9, ["Neon|Fly|Ride"] = 87.15, ["Mega"] = 155.69, ["Mega|Ride"] = 110.25, ["Mega|Fly|Ride"] = 147.58}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.1, ["Ride"] = 18.37, ["Neon"] = 62.75, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 560.07, ["Mega"] = 182.52, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 271.69}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 128.63, ["Fly"] = 245.37, ["Ride"] = 149.62, ["Fly|Ride"] = 228.38, ["Neon"] = 524.99, ["Neon|Ride"] = 741.51, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 1966.5, ["Mega|Fly|Ride"] = 1903.13}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 12.47, ["Ride"] = 240.91, ["Fly|Ride"] = 204.52, ["Neon"] = 116.44, ["Neon|Ride"] = 155.69, ["Neon|Fly|Ride"] = 152.25, ["Mega"] = 309.41, ["Mega|Ride"] = 419.53, ["Mega|Fly|Ride"] = 495.8}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 69.71, ["Ride"] = 26.24, ["Fly|Ride"] = 112.88, ["Neon"] = 7.35, ["Neon|Ride"] = 28.33, ["Neon|Fly|Ride"] = 83.92, ["Mega"] = 308.44, ["Mega|Ride"] = 260.12, ["Mega|Fly|Ride"] = 280.04}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 26.23, ["Ride"] = 85.31, ["Fly|Ride"] = 131.25, ["Neon"] = 90.57, ["Neon|Ride"] = 138.46, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 524.42, ["Mega|Ride"] = 587.33, ["Mega|Fly|Ride"] = 587.33}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 6.25}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 4.66, ["Ride"] = 27.57, ["Neon"] = 72.19, ["Neon|Fly|Ride"] = 629.29, ["Mega"] = 315, ["Mega|Ride"] = 419.53, ["Mega|Fly|Ride"] = 1258.57}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 66.77, ["Fly"] = 56.52, ["Ride"] = 35.66, ["Fly|Ride"] = 54.63, ["Neon"] = 419.53, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 125.87, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 2097.59, ["Mega|Fly|Ride"] = 1064.24}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 6.57, ["Neon|Ride"] = 39.87, ["Mega"] = 20.37, ["Mega|Ride"] = 77.64, ["Mega|Fly|Ride"] = 238.09}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 3.92, ["Fly"] = 34.13, ["Ride"] = 28.32, ["Fly|Ride"] = 77.62, ["Neon"] = 39.38, ["Neon|Ride"] = 232.38, ["Mega"] = 145.81, ["Mega|Fly"] = 388.06, ["Mega|Ride"] = 161.47, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 17.45, ["Ride"] = 15.28, ["Fly|Ride"] = 61.73, ["Neon"] = 19.69, ["Neon|Ride"] = 36.03, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 116.82, ["Mega|Fly"] = 138.46, ["Mega|Ride"] = 120.75, ["Mega|Fly|Ride"] = 234.86}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Neon"] = 3.92, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 112.88, ["Mega"] = 62.99, ["Mega|Ride"] = 67.5, ["Mega|Fly|Ride"] = 207.67}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 30.18, ["Ride"] = 82.69, ["Neon"] = 208.71, ["Neon|Ride"] = 262.5, ["Mega"] = 797.09, ["Mega|Ride"] = 813.75, ["Mega|Fly|Ride"] = 979.58}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 4.17, ["Ride"] = 36.75, ["Fly|Ride"] = 209.99, ["Neon"] = 69.55, ["Neon|Ride"] = 77.63, ["Mega"] = 105, ["Mega|Ride"] = 511.88}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 48.72, ["Fly"] = 96.96, ["Ride"] = 42.71, ["Fly|Ride"] = 92.96, ["Neon"] = 39.37, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 84.69, ["Neon|Fly|Ride"] = 98.6, ["Mega"] = 320.25, ["Mega|Ride"] = 348.55, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 74.48, ["Fly"] = 140.54, ["Ride"] = 105, ["Fly|Ride"] = 350.27, ["Neon"] = 290.48, ["Neon|Ride"] = 455.19, ["Mega|Fly|Ride"] = 2097.59}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 26.19, ["Ride"] = 49.3, ["Fly|Ride"] = 254.31, ["Neon"] = 74.82, ["Neon|Ride"] = 98.59, ["Neon|Fly|Ride"] = 839.05, ["Mega"] = 380.62, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 467.25}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 81.48, ["Ride"] = 101.08, ["Fly|Ride"] = 199.5, ["Neon"] = 262.5, ["Neon|Ride"] = 350.32, ["Neon|Fly|Ride"] = 351.75, ["Mega"] = 2013.43, ["Mega|Ride"] = 1085.16, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 34.13, ["Ride"] = 47.25, ["Fly|Ride"] = 232.38, ["Neon"] = 102.37, ["Neon|Fly"] = 249.38, ["Neon|Ride"] = 147.58, ["Neon|Fly|Ride"] = 209.77, ["Mega"] = 314.65, ["Mega|Ride"] = 373.07, ["Mega|Fly|Ride"] = 538.78}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 4.87, ["Fly"] = 52.5, ["Ride"] = 27.27, ["Neon"] = 37.41, ["Neon|Ride"] = 266.41, ["Neon|Fly|Ride"] = 125.87, ["Mega"] = 329.97, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 39.45, ["Ride"] = 125.84, ["Fly|Ride"] = 195.57, ["Neon"] = 105.72, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 208.72, ["Mega"] = 238.06, ["Mega|Ride"] = 419.53, ["Mega|Fly|Ride"] = 588}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 13.1, ["Ride"] = 65.03, ["Fly|Ride"] = 104.87, ["Neon"] = 35.68, ["Neon|Fly"] = 112.24, ["Neon|Ride"] = 60.38, ["Neon|Fly|Ride"] = 280.04, ["Mega"] = 264.44, ["Mega|Ride"] = 280.83, ["Mega|Fly|Ride"] = 377.53}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 26.25, ["Mega"] = 18.88, ["Mega|Fly"] = 140.55, ["Mega|Ride"] = 66.94, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 3.13, ["Ride"] = 104.88, ["Neon"] = 15.74, ["Neon|Ride"] = 83.83, ["Mega"] = 99.6, ["Mega|Ride"] = 157.34, ["Mega|Fly|Ride"] = 310.22}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.63, ["Neon"] = 22.23, ["Neon|Ride"] = 103.69, ["Mega"] = 336}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 6.15, ["Ride"] = 31.47, ["Fly|Ride"] = 116.2, ["Neon"] = 27.5, ["Neon|Ride"] = 82.95, ["Neon|Fly|Ride"] = 278.99, ["Mega"] = 123.38, ["Mega|Ride"] = 377.58, ["Mega|Fly|Ride"] = 508.6}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 548.63, ["Ride"] = 492.18, ["Fly|Ride"] = 560.07, ["Neon|Ride"] = 1677.03, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 4593.75}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 8.39, ["Fly"] = 56.64, ["Ride"] = 29.61, ["Fly|Ride"] = 72.05, ["Neon"] = 37.77, ["Neon|Ride"] = 83.92, ["Mega|Ride"] = 280.04}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 6.28, ["Fly"] = 31.5, ["Ride"] = 43.32, ["Neon"] = 52.45, ["Neon|Fly"] = 315, ["Neon|Ride"] = 140.54, ["Neon|Fly|Ride"] = 109.23, ["Mega"] = 464.75, ["Mega|Ride"] = 335.64, ["Mega|Fly|Ride"] = 464.75}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 2.1, ["Fly"] = 28.32, ["Ride"] = 23.21, ["Fly|Ride"] = 314.65, ["Neon|Ride"] = 152.21, ["Mega"] = 223.13, ["Mega|Ride"] = 354.38, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 29.3, ["Fly|Ride"] = 941.48, ["Neon"] = 8.12, ["Neon|Ride"] = 39.26, ["Neon|Fly|Ride"] = 125.87, ["Mega"] = 59.07, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 233.63}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Ride"] = 70.26, ["Neon"] = 3.14, ["Neon|Ride"] = 58.1, ["Neon|Fly|Ride"] = 116.2, ["Mega"] = 21, ["Mega|Ride"] = 112.24, ["Mega|Fly|Ride"] = 209.77}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1239.52}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 6.72, ["Fly"] = 56.64, ["Ride"] = 28.66, ["Fly|Ride"] = 139.42, ["Neon"] = 56.65, ["Neon|Fly"] = 140.55, ["Neon|Ride"] = 155.67, ["Mega"] = 497.14, ["Mega|Ride"] = 531.23, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 45.36, ["Neon"] = 13.13, ["Neon|Ride"] = 74.37, ["Mega"] = 54.55, ["Mega|Ride"] = 90.21, ["Mega|Fly|Ride"] = 232.38}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.6, ["Fly"] = 42.16, ["Ride"] = 27.43, ["Fly|Ride"] = 525, ["Neon"] = 10.5, ["Neon|Ride"] = 70.28, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 155.24, ["Mega|Ride"] = 154.88, ["Mega|Fly|Ride"] = 140.55}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 393.75, ["Ride"] = 419.48, ["Fly|Ride"] = 556.5, ["Neon"] = 1258.57, ["Neon|Ride"] = 1509.38, ["Neon|Fly|Ride"] = 1468.31, ["Mega|Fly|Ride"] = 7691.84}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 10.19, ["Fly"] = 196.88, ["Ride"] = 72.19, ["Neon"] = 44.14, ["Mega"] = 399, ["Mega|Ride"] = 380.63}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Neon"] = 3.81, ["Neon|Ride"] = 40.68, ["Mega"] = 34.92, ["Mega|Fly"] = 155.69, ["Mega|Ride"] = 77.64, ["Mega|Fly|Ride"] = 197.14}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 3.94, ["Neon|Ride"] = 59.07, ["Mega"] = 24.94, ["Mega|Ride"] = 83.66, ["Mega|Fly|Ride"] = 195.57}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 13.26, ["Fly"] = 78.69, ["Ride"] = 39.38, ["Neon"] = 47.78, ["Neon|Ride"] = 207.38, ["Neon|Fly|Ride"] = 310.46, ["Mega"] = 328.13, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 314.65}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 10.5, ["Ride"] = 140.54, ["Fly|Ride"] = 131.25, ["Neon"] = 65.63, ["Neon|Ride"] = 56.65, ["Neon|Fly|Ride"] = 839.05, ["Mega"] = 1258.57, ["Mega|Ride"] = 497.27, ["Mega|Fly|Ride"] = 1066.42}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 5.25, ["Fly|Ride"] = 140.54, ["Neon"] = 280.03, ["Neon|Ride"] = 208.72, ["Mega"] = 582.75, ["Mega|Fly|Ride"] = 1227.19}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 16.79, ["Ride"] = 65.03, ["Neon"] = 140.55, ["Neon|Ride"] = 132.46, ["Neon|Fly|Ride"] = 774.95, ["Mega"] = 660.19, ["Mega|Ride"] = 489.91, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 347.82, ["Ride"] = 367.5, ["Fly|Ride"] = 441.45, ["Neon"] = 2936.62, ["Neon|Ride"] = 1086.57, ["Neon|Fly|Ride"] = 1048.81, ["Mega|Fly|Ride"] = 3150}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 6.25, ["Ride"] = 44.63, ["Fly|Ride"] = 82.5, ["Neon"] = 59.07, ["Neon|Ride"] = 98.6, ["Neon|Fly|Ride"] = 140.55, ["Mega|Ride"] = 498.19, ["Mega|Fly|Ride"] = 759.34}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 5.24, ["Ride"] = 41.96, ["Fly|Ride"] = 155.23, ["Mega"] = 1258.57, ["Mega|Fly|Ride"] = 560.07}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 9.19, ["Ride"] = 56.64, ["Fly|Ride"] = 162.75, ["Neon"] = 28.35, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 168, ["Mega"] = 170.63, ["Mega|Ride"] = 229.71, ["Mega|Fly|Ride"] = 357.67}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.1, ["Ride"] = 31.5, ["Fly|Ride"] = 108.03, ["Neon"] = 11.81, ["Neon|Ride"] = 42.47, ["Mega"] = 39.37, ["Mega|Ride"] = 98.6, ["Mega|Fly|Ride"] = 155.69}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 61.69, ["Ride"] = 70.88, ["Neon"] = 261.18, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 464.75, ["Mega"] = 1119.07, ["Mega|Ride"] = 1001.61, ["Mega|Fly|Ride"] = 1072.94}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 3.89, ["Fly"] = 580.85, ["Ride"] = 32.52, ["Fly|Ride"] = 65.63, ["Neon"] = 13.13, ["Neon|Fly"] = 182.52, ["Neon|Ride"] = 54.55, ["Mega"] = 61.09, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 308.44}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 28.32, ["Ride"] = 30.22, ["Fly|Ride"] = 148.25, ["Neon"] = 4.67, ["Neon|Ride"] = 40.92, ["Neon|Fly|Ride"] = 140.38, ["Mega"] = 77.84, ["Mega|Fly"] = 91.26, ["Mega|Ride"] = 51.7, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Fly"] = 1519.88, ["Ride"] = 24.94, ["Fly|Ride"] = 262.5, ["Neon"] = 11.82, ["Neon|Ride"] = 158.06, ["Neon|Fly|Ride"] = 295.32, ["Mega"] = 116.45, ["Mega|Ride"] = 190.32, ["Mega|Fly|Ride"] = 205.57}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 53.82, ["Fly"] = 92.3, ["Ride"] = 97.13, ["Fly|Ride"] = 155.68, ["Neon"] = 309.41, ["Neon|Ride"] = 335.64, ["Neon|Fly|Ride"] = 692.35, ["Mega|Fly|Ride"] = 901.69}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 314.22, ["Ride"] = 317.77, ["Fly|Ride"] = 459.38, ["Neon|Ride"] = 1099.88, ["Neon|Fly|Ride"] = 1338.27, ["Mega"] = 6992.3, ["Mega|Fly|Ride"] = 5659.29}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 3.93, ["Neon"] = 26.25, ["Mega"] = 109.23, ["Mega|Ride"] = 236.73, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 6.32, ["Neon"] = 11.82, ["Mega"] = 139.13, ["Mega|Ride"] = 278.25, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 3.81, ["Fly"] = 155.57, ["Neon"] = 132.16, ["Mega"] = 488.92}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 53.23, ["Ride"] = 34.13, ["Fly|Ride"] = 59.07, ["Neon"] = 6.56, ["Neon|Ride"] = 27.43, ["Neon|Fly|Ride"] = 182.52, ["Mega"] = 62.94, ["Mega|Ride"] = 87.07, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 59.07, ["Neon"] = 8.4, ["Mega"] = 28.88, ["Mega|Ride"] = 206.07}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 65.54, ["Ride"] = 19.94, ["Fly|Ride"] = 59.07, ["Neon"] = 5.24, ["Neon|Ride"] = 44.16, ["Neon|Fly|Ride"] = 105, ["Mega"] = 34.13, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 155.24}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 27.89, ["Fly|Ride"] = 60.38, ["Neon"] = 17.07, ["Neon|Fly"] = 98.6, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 90.21, ["Mega"] = 109.23, ["Mega|Ride"] = 200.33, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 49.87, ["Ride"] = 70.88, ["Neon"] = 116.44, ["Neon|Ride"] = 155.69, ["Mega"] = 367.5, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 503.44}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 62.34, ["Fly"] = 582.75, ["Ride"] = 98.44, ["Fly|Ride"] = 167.83, ["Neon"] = 419.53, ["Neon|Ride"] = 559.99, ["Mega"] = 3098.57, ["Mega|Ride"] = 1749.4, ["Mega|Fly|Ride"] = 1704.4}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 33.57, ["Fly|Ride"] = 41.96, ["Neon"] = 3.92, ["Neon|Ride"] = 56.65, ["Neon|Fly|Ride"] = 359.63, ["Mega"] = 56.35, ["Mega|Ride"] = 125.87, ["Mega|Fly|Ride"] = 318.35}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 16.77, ["Ride"] = 19.66, ["Fly|Ride"] = 49.32, ["Neon"] = 3.93, ["Neon|Ride"] = 24.86, ["Neon|Fly|Ride"] = 50.67, ["Mega"] = 38.06, ["Mega|Fly"] = 157.5, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 125.87}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 11.82, ["Ride"] = 41.96, ["Neon"] = 125.87, ["Neon|Ride"] = 138.46, ["Neon|Fly|Ride"] = 278.99, ["Mega"] = 615.65, ["Mega|Ride"] = 629.29, ["Mega|Fly|Ride"] = 471.19}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 251.74, ["Fly"] = 346.07, ["Ride"] = 223.13, ["Fly|Ride"] = 280.08, ["Neon"] = 1006.86, ["Neon|Ride"] = 1468.31, ["Neon|Fly|Ride"] = 1518.67, ["Mega|Fly|Ride"] = 5576.71}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 27.66, ["Fly"] = 209.9, ["Ride"] = 55.13, ["Fly|Ride"] = 166.77, ["Neon"] = 278.25, ["Neon|Ride"] = 297.96, ["Neon|Fly|Ride"] = 381.94, ["Mega"] = 938.68, ["Mega|Ride"] = 979.58, ["Mega|Fly|Ride"] = 826.88}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 31.49, ["Fly|Ride"] = 98.59, ["Neon"] = 8.97, ["Neon|Ride"] = 42, ["Mega"] = 101.07, ["Mega|Ride"] = 110.25, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 3.93, ["Fly"] = 209.75, ["Ride"] = 83.91, ["Fly|Ride"] = 142.7, ["Neon"] = 18.21, ["Neon|Ride"] = 188.81, ["Mega"] = 211.32, ["Mega|Ride"] = 434.53}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 25.57, ["Fly"] = 77.62, ["Ride"] = 47.25, ["Fly|Ride"] = 65.63, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 2517.12, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 1039.37}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 92.96, ["Ride"] = 105, ["Fly|Ride"] = 209.75, ["Neon"] = 523.37, ["Neon|Ride"] = 469.88, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 3077.17, ["Mega|Fly|Ride"] = 6292.76}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 206.98, ["Fly"] = 499.17, ["Ride"] = 300.98, ["Fly|Ride"] = 350.32, ["Neon"] = 979.58, ["Neon|Ride"] = 993.23, ["Neon|Fly|Ride"] = 916.13, ["Mega|Fly|Ride"] = 3074.03}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 16.51, ["Ride"] = 41.96, ["Fly|Ride"] = 207.67, ["Neon"] = 111.56, ["Neon|Ride"] = 115.49, ["Mega"] = 388.5, ["Mega|Ride"] = 436.31, ["Mega|Fly|Ride"] = 511.82}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 28.32, ["Ride"] = 17.07, ["Fly|Ride"] = 47.25, ["Neon"] = 15.73, ["Neon|Ride"] = 41.97, ["Neon|Fly|Ride"] = 75.52, ["Mega"] = 112.28, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 2.1, ["Ride"] = 27.57, ["Fly|Ride"] = 56.65, ["Neon"] = 23.08, ["Neon|Ride"] = 44.05, ["Neon|Fly|Ride"] = 109.23, ["Mega"] = 250.79, ["Mega|Ride"] = 241.5, ["Mega|Fly|Ride"] = 259.87}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 255.94, ["Ride"] = 405.85, ["Fly|Ride"] = 487.91, ["Neon"] = 1399.11, ["Neon|Ride"] = 1468.31, ["Neon|Fly|Ride"] = 1496.64}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 46.16, ["Neon"] = 11.64, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 32.82, ["Mega|Ride"] = 157.34}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 3.93, ["Ride"] = 19.69, ["Fly|Ride"] = 65.07, ["Neon"] = 24.08, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 110.25, ["Mega"] = 142.93, ["Mega|Ride"] = 280.04, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 23.24, ["Ride"] = 98.59, ["Neon"] = 136.5, ["Neon|Ride"] = 209.77, ["Neon|Fly|Ride"] = 537, ["Mega"] = 519.17, ["Mega|Ride"] = 524.42, ["Mega|Fly|Ride"] = 514.5}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 98.44, ["Fly"] = 278.96, ["Ride"] = 118.13, ["Fly|Ride"] = 147.95, ["Neon|Ride"] = 699.57, ["Neon|Fly|Ride"] = 448.9, ["Mega|Fly|Ride"] = 1730.53}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 24.1, ["Fly"] = 81.34, ["Ride"] = 33.7, ["Fly|Ride"] = 69.71, ["Neon"] = 85.32, ["Neon|Ride"] = 89.25, ["Neon|Fly|Ride"] = 115.5, ["Mega"] = 699.57, ["Mega|Ride"] = 419.53, ["Mega|Fly|Ride"] = 696.41}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 56.64, ["Neon"] = 3.54, ["Neon|Ride"] = 48.26, ["Neon|Fly|Ride"] = 178.27, ["Mega"] = 21, ["Mega|Ride"] = 167.83, ["Mega|Fly|Ride"] = 419.53}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Ride"] = 34.13, ["Fly|Ride"] = 52.5, ["Neon"] = 3.92, ["Neon|Fly"] = 31.38, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 69.18, ["Mega"] = 23.25, ["Mega|Ride"] = 70.28, ["Mega|Fly|Ride"] = 140.55}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 11.82, ["Ride"] = 69.71, ["Fly|Ride"] = 165.37, ["Neon"] = 39.38, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 70.3, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 152.24, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1433.25, ["Ride"] = 1299.38, ["Fly|Ride"] = 1534.36, ["Neon"] = 6712.28, ["Neon|Fly|Ride"] = 4879.63, ["Mega|Fly|Ride"] = 13650}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 512.46, ["Ride"] = 641.82, ["Fly|Ride"] = 660.19, ["Neon|Ride"] = 2479.32, ["Neon|Fly|Ride"] = 2502.94, ["Mega"] = 16780.67, ["Mega|Fly|Ride"] = 6822.38}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 356.56, ["Fly"] = 531.68, ["Ride"] = 328.13, ["Fly|Ride"] = 472.5, ["Neon"] = 735, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 787.5, ["Mega|Fly|Ride"] = 2479.36}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 328.13, ["Fly"] = 419.44, ["Ride"] = 361.59, ["Fly|Ride"] = 466.72, ["Neon"] = 881, ["Neon|Fly"] = 918.75, ["Neon|Ride"] = 1048.81, ["Neon|Fly|Ride"] = 1085.16, ["Mega|Ride"] = 3675, ["Mega|Fly|Ride"] = 2930.33}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 79.72, ["Ride"] = 19.69, ["Fly|Ride"] = 44.62, ["Neon"] = 5.25, ["Neon|Ride"] = 30.09, ["Neon|Fly|Ride"] = 146.41, ["Mega"] = 67.15, ["Mega|Ride"] = 112.88, ["Mega|Fly|Ride"] = 185.91}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 322.88, ["Fly"] = 590.62, ["Ride"] = 367.5, ["Fly|Ride"] = 523.85, ["Neon"] = 938.68, ["Neon|Ride"] = 787.49, ["Neon|Fly|Ride"] = 1048.69, ["Mega"] = 8250.85, ["Mega|Ride"] = 3408.77, ["Mega|Fly|Ride"] = 3543.75}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 3.87, ["Fly"] = 183.75, ["Ride"] = 140.54, ["Neon"] = 12.78, ["Neon|Ride"] = 53.59, ["Neon|Fly|Ride"] = 112.72, ["Mega"] = 67.95, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 272.35}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 20.35, ["Ride"] = 31.49, ["Fly|Ride"] = 49.88, ["Neon"] = 7.86, ["Neon|Ride"] = 61.69, ["Neon|Fly|Ride"] = 110.25, ["Mega"] = 124.82, ["Mega|Ride"] = 137.41, ["Mega|Fly|Ride"] = 202.13}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Neon"] = 3.94, ["Mega"] = 23.63, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 82.86, ["Ride"] = 65.63, ["Fly|Ride"] = 459.38, ["Neon"] = 244.13, ["Neon|Ride"] = 310.22, ["Mega"] = 2097.59, ["Mega|Ride"] = 897.75, ["Mega|Fly|Ride"] = 979.58}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 4.65, ["Fly"] = 65.61, ["Ride"] = 19.67, ["Neon"] = 104.57, ["Mega"] = 328.13, ["Mega|Ride"] = 316.75}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 53.82, ["Neon"] = 3.4, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 19.69, ["Mega|Fly"] = 124.34, ["Mega|Ride"] = 155.69, ["Mega|Fly|Ride"] = 308.44}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 49.88, ["Neon"] = 8.71, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 27.27, ["Neon|Fly|Ride"] = 91.28, ["Mega"] = 102.26, ["Mega|Fly"] = 232.38, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 217.45}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 5.23, ["Fly"] = 16.79, ["Ride"] = 54.1, ["Fly|Ride"] = 55.26, ["Neon"] = 91.26, ["Neon|Fly"] = 44.17, ["Neon|Ride"] = 139.1, ["Neon|Fly|Ride"] = 251.72, ["Mega"] = 237.57, ["Mega|Ride"] = 140.55, ["Mega|Fly|Ride"] = 1019.82}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 15.73, ["Ride"] = 27.57, ["Mega"] = 464.75, ["Mega|Ride"] = 333.54, ["Mega|Fly|Ride"] = 519.17}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Fly|Ride"] = 87.94, ["Neon"] = 20.99, ["Neon|Ride"] = 80.31, ["Neon|Fly|Ride"] = 697.1, ["Mega"] = 276.9, ["Mega|Ride"] = 464.75, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Ride"] = 19.94, ["Fly|Ride"] = 83.92, ["Neon"] = 3.93, ["Neon|Ride"] = 28.33, ["Neon|Fly|Ride"] = 167.83, ["Mega"] = 40.69, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 314.65}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 196.87, ["Fly"] = 293.64, ["Ride"] = 241.21, ["Fly|Ride"] = 282.19, ["Neon"] = 1161.83, ["Neon|Fly"] = 1328.84, ["Neon|Ride"] = 1239.67, ["Neon|Fly|Ride"] = 1244.93, ["Mega"] = 8390.34, ["Mega|Fly|Ride"] = 3717.81}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 17.75, ["Fly|Ride"] = 31.47, ["Neon"] = 3.92, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 61.89, ["Mega"] = 40.69, ["Mega|Ride"] = 70.3, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 14.44, ["Ride"] = 98.44, ["Fly|Ride"] = 105, ["Neon"] = 78.75, ["Neon|Ride"] = 104.41, ["Mega"] = 301.88, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 464.68}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 37.17, ["Ride"] = 109.22, ["Neon"] = 155.4, ["Neon|Ride"] = 309.06, ["Mega"] = 393.75, ["Mega|Ride"] = 796.05, ["Mega|Fly|Ride"] = 1022.9}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 175.88, ["Fly"] = 262.5, ["Ride"] = 220.5, ["Fly|Ride"] = 278.78, ["Neon"] = 775.69, ["Neon|Ride"] = 742.88, ["Neon|Fly|Ride"] = 763.53, ["Mega|Fly|Ride"] = 3406.49}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 21, ["Neon"] = 73.5, ["Mega"] = 415.42, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 699.57}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 38.66, ["Ride"] = 131.24, ["Fly|Ride"] = 629.29, ["Neon"] = 205.57, ["Neon|Ride"] = 313.61, ["Neon|Fly|Ride"] = 839.05, ["Mega"] = 759.34, ["Mega|Ride"] = 838, ["Mega|Fly|Ride"] = 2097.59}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 1141.88, ["Fly"] = 1441.13, ["Ride"] = 1179.94, ["Fly|Ride"] = 1181.25, ["Neon|Ride"] = 6292.76, ["Neon|Fly|Ride"] = 4315.49, ["Mega|Fly|Ride"] = 13941.76}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 6.22, ["Fly"] = 43.32, ["Ride"] = 21.59, ["Fly|Ride"] = 41.97, ["Neon"] = 76.78, ["Neon|Fly"] = 111.57, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 105, ["Mega"] = 196.88, ["Mega|Ride"] = 253.3, ["Mega|Fly|Ride"] = 398.55}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 5.07, ["Fly"] = 13842.36, ["Ride"] = 34.13, ["Neon"] = 39.52, ["Neon|Ride"] = 165.73, ["Neon|Fly|Ride"] = 144.74, ["Mega"] = 212.63, ["Mega|Ride"] = 217.88, ["Mega|Fly|Ride"] = 283.5}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Ride"] = 23.08, ["Fly|Ride"] = 91.26, ["Neon"] = 15.74, ["Neon|Ride"] = 77.86, ["Neon|Fly|Ride"] = 310.22, ["Mega"] = 140.55, ["Mega|Ride"] = 253.82, ["Mega|Fly|Ride"] = 699.57}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 18, ["Ride"] = 40.68, ["Fly|Ride"] = 63, ["Neon"] = 53.82, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 209.77, ["Mega"] = 354.38, ["Mega|Ride"] = 383.25, ["Mega|Fly|Ride"] = 576.85}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 3.93, ["Fly"] = 35.67, ["Ride"] = 31.39, ["Fly|Ride"] = 65.63, ["Neon"] = 27.28, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 105, ["Mega"] = 348.22, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 6.56, ["Ride"] = 43.63, ["Neon"] = 110.25, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 46.03, ["Mega"] = 111.56, ["Mega|Ride"] = 242.8, ["Mega|Fly|Ride"] = 350.32}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 140.54, ["Ride"] = 291.55, ["Fly|Ride"] = 539.02, ["Neon"] = 840, ["Neon|Ride"] = 1693.13, ["Neon|Fly|Ride"] = 1394.18, ["Mega|Fly|Ride"] = 3762.03}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Ride"] = 25.57, ["Fly|Ride"] = 54.29, ["Neon"] = 6.18, ["Neon|Fly"] = 77.86, ["Neon|Ride"] = 41.88, ["Neon|Fly|Ride"] = 125.87, ["Mega"] = 91.88, ["Mega|Ride"] = 147.52, ["Mega|Fly|Ride"] = 209.77}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 15.61, ["Neon"] = 77.42, ["Mega"] = 257.25}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 4.15, ["Fly"] = 58.12, ["Ride"] = 40.69, ["Neon"] = 15.73, ["Neon|Ride"] = 28.32, ["Mega"] = 145.69, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 347.17}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 124.69, ["Fly"] = 262.5, ["Ride"] = 281.96, ["Fly|Ride"] = 685.84, ["Neon"] = 459.38, ["Neon|Ride"] = 619.5, ["Neon|Fly|Ride"] = 698.52, ["Mega"] = 3565.9, ["Mega|Ride"] = 2503.49, ["Mega|Fly|Ride"] = 2097.59}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 31.22, ["Ride"] = 56.64, ["Fly|Ride"] = 524.42, ["Neon"] = 140.59, ["Neon|Ride"] = 138.46, ["Neon|Fly|Ride"] = 280.04, ["Mega"] = 628.24, ["Mega|Ride"] = 661.5, ["Mega|Fly|Ride"] = 699.57}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 23.62, ["Ride"] = 39.38, ["Neon"] = 116.44, ["Neon|Ride"] = 147.48, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 512.37, ["Mega|Ride"] = 489.86, ["Mega|Fly|Ride"] = 538.12}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 83.91, ["Neon"] = 3.93, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 35.44, ["Mega"] = 20.99, ["Mega|Ride"] = 74.82, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 95.42, ["Fly"] = 137.69, ["Ride"] = 131.25, ["Fly|Ride"] = 209.77, ["Neon"] = 315, ["Neon|Ride"] = 361.31, ["Neon|Fly|Ride"] = 560.27, ["Mega|Fly|Ride"] = 917.44}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 20.98, ["Neon"] = 4.57, ["Neon|Fly|Ride"] = 588, ["Mega"] = 62.94}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 45.94, ["Fly"] = 140.54, ["Ride"] = 44.07, ["Fly|Ride"] = 109.23, ["Neon"] = 98.6, ["Neon|Ride"] = 72.17, ["Neon|Fly|Ride"] = 112.88, ["Mega"] = 398.55, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 524.16}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 49.39, ["Ride"] = 105, ["Fly|Ride"] = 157.5, ["Neon|Ride"] = 371.8, ["Neon|Fly|Ride"] = 774.95, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 15.74, ["Fly|Ride"] = 48.25, ["Neon"] = 2.63, ["Neon|Fly"] = 27.72, ["Neon|Ride"] = 19.43, ["Neon|Fly|Ride"] = 36.03, ["Mega"] = 21, ["Mega|Fly"] = 56.65, ["Mega|Ride"] = 45.09, ["Mega|Fly|Ride"] = 95.28}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 4.98, ["Ride"] = 83.91, ["Fly|Ride"] = 1346.59, ["Neon"] = 18.24, ["Neon|Ride"] = 95.88, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 164.07, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 515.17}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 23.08, ["Ride"] = 62.75, ["Neon"] = 281.17, ["Neon|Ride"] = 310.22, ["Neon|Fly|Ride"] = 620.42, ["Mega"] = 560.07, ["Mega|Ride"] = 576.85, ["Mega|Fly|Ride"] = 623.44}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 23.08, ["Neon"] = 2.1, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 125.87, ["Mega"] = 18.88, ["Mega|Ride"] = 140.55, ["Mega|Fly|Ride"] = 410.17}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 4.94, ["Fly"] = 210, ["Ride"] = 34.88, ["Fly|Ride"] = 98.44, ["Neon"] = 40.69, ["Neon|Ride"] = 98.6, ["Neon|Fly|Ride"] = 182.52, ["Mega"] = 207.67, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 375.76}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 27.27, ["Fly"] = 41.96, ["Ride"] = 31.38, ["Fly|Ride"] = 62.75, ["Neon|Ride"] = 101.73, ["Neon|Fly|Ride"] = 328.13, ["Mega|Fly|Ride"] = 469.82}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 3.92, ["Ride"] = 91.87, ["Neon"] = 20.99, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 200.82, ["Mega"] = 169.32, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 293.67}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 31.47, ["Fly"] = 72.19, ["Ride"] = 94.4, ["Neon"] = 84, ["Neon|Ride"] = 497.27, ["Neon|Fly|Ride"] = 6195.96, ["Mega"] = 598.88, ["Mega|Ride"] = 531.76, ["Mega|Fly|Ride"] = 699.57}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Ride"] = 41.96, ["Fly|Ride"] = 126.48, ["Neon"] = 7.62, ["Neon|Ride"] = 39.38, ["Mega"] = 70.52, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 408.19, ["Mega|Fly|Ride"] = 288.74}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 28.32, ["Neon"] = 3.93, ["Neon|Ride"] = 41.97, ["Mega"] = 28.88, ["Mega|Ride"] = 137.41, ["Mega|Fly|Ride"] = 155.24}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 39.38}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 70.27, ["Fly"] = 92.3, ["Ride"] = 73.42, ["Fly|Ride"] = 204.52, ["Neon"] = 1050, ["Neon|Fly|Ride"] = 1048.81, ["Mega"] = 979.58, ["Mega|Ride"] = 977.49, ["Mega|Fly|Ride"] = 889.88}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 140.54, ["Neon"] = 3.82, ["Neon|Ride"] = 26.73, ["Mega"] = 21, ["Mega|Ride"] = 104.89, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 615.58, ["Ride"] = 774.38, ["Fly|Ride"] = 656.25, ["Neon"] = 4195.17, ["Mega"] = 16780.67, ["Mega|Fly|Ride"] = 10487.92}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 6.99, ["Fly"] = 49.88, ["Ride"] = 40.94, ["Fly|Ride"] = 54.63, ["Neon"] = 44.06, ["Mega|Fly|Ride"] = 560.07}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 3.51, ["Ride"] = 20.98, ["Fly|Ride"] = 54.54, ["Neon"] = 31.38, ["Neon|Ride"] = 35.48, ["Neon|Fly|Ride"] = 91.26, ["Mega"] = 178.31, ["Mega|Ride"] = 174.57, ["Mega|Fly|Ride"] = 182.44}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 15.28, ["Ride"] = 49.3, ["Fly|Ride"] = 106.32, ["Neon"] = 94.5, ["Neon|Ride"] = 249.62, ["Neon|Fly|Ride"] = 140.55, ["Mega"] = 1036.23, ["Mega|Ride"] = 909.32, ["Mega|Fly|Ride"] = 1258.57}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 2.61, ["Fly"] = 39.38, ["Ride"] = 31.5, ["Fly|Ride"] = 393.75, ["Neon"] = 140.55, ["Mega"] = 291.59, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 14.34, ["Ride"] = 210, ["Fly|Ride"] = 155.23, ["Neon"] = 125.99, ["Neon|Fly|Ride"] = 350.44, ["Mega"] = 417.43, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 452.82}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 7.62, ["Fly"] = 105, ["Ride"] = 45.11, ["Fly|Ride"] = 131.25, ["Neon"] = 15.74, ["Neon|Ride"] = 92.31, ["Neon|Fly|Ride"] = 284.82, ["Mega"] = 231, ["Mega|Ride"] = 208.69, ["Mega|Fly|Ride"] = 294}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 46.49, ["Ride"] = 18.89, ["Fly|Ride"] = 28.33, ["Neon"] = 2.1, ["Neon|Fly"] = 28.46, ["Neon|Ride"] = 19.94, ["Neon|Fly|Ride"] = 63.27, ["Mega"] = 15.74, ["Mega|Fly"] = 77.86, ["Mega|Ride"] = 63, ["Mega|Fly|Ride"] = 77.44}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 15.74, ["Ride"] = 39.38, ["Fly|Ride"] = 157.94, ["Neon"] = 44.63, ["Neon|Fly"] = 388.06, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 232.38, ["Mega"] = 140.55, ["Mega|Ride"] = 217.88, ["Mega|Fly|Ride"] = 260.12}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 262.5, ["Ride"] = 301.88, ["Fly|Ride"] = 368.66, ["Neon"] = 2097.59, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 4081.88}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 137.66, ["Ride"] = 147, ["Fly|Ride"] = 7690.79, ["Neon"] = 685.93, ["Neon|Ride"] = 839.05, ["Neon|Fly|Ride"] = 698.25, ["Mega"] = 4195.17, ["Mega|Ride"] = 1992.73, ["Mega|Fly|Ride"] = 2097.59}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 24.94, ["Fly|Ride"] = 38.06, ["Neon"] = 11.82, ["Neon|Fly"] = 24.94, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 65.63, ["Mega|Fly"] = 208.72, ["Mega|Ride"] = 91.26, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 17.38, ["Ride"] = 15.91, ["Fly|Ride"] = 36.6, ["Neon"] = 10.5, ["Neon|Fly"] = 54.63, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 52.01, ["Mega"] = 62.75, ["Mega|Ride"] = 77.63, ["Mega|Fly|Ride"] = 139.13}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.61, ["Ride"] = 18.98, ["Fly|Ride"] = 98.44, ["Neon"] = 8.4, ["Mega"] = 140.55}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 377.53, ["Ride"] = 418.69, ["Fly|Ride"] = 413.48, ["Neon|Ride"] = 1959.16, ["Neon|Fly|Ride"] = 1766.81, ["Mega|Ride"] = 8390.34, ["Mega|Fly|Ride"] = 4881.09}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 3.91, ["Fly"] = 22.78, ["Ride"] = 15.74, ["Fly|Ride"] = 45.74, ["Neon"] = 28.33, ["Neon|Fly"] = 155.69, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 78.73, ["Mega"] = 266.41, ["Mega|Ride"] = 209.77, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 4.07, ["Fly"] = 124.31, ["Ride"] = 39.51, ["Fly|Ride"] = 209.75, ["Neon"] = 31.38, ["Neon|Ride"] = 223.13, ["Mega"] = 209.99, ["Mega|Ride"] = 204.75, ["Mega|Fly|Ride"] = 397.35}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 91.88, ["Neon"] = 4.2, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 140.55, ["Mega"] = 40.91, ["Mega|Ride"] = 94.5, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 19.69, ["Fly"] = 83.91, ["Ride"] = 31.39, ["Fly|Ride"] = 209.75, ["Neon"] = 85.71, ["Neon|Ride"] = 93.19, ["Neon|Fly|Ride"] = 114.58, ["Mega"] = 741.57, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 363.95}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 50.81, ["Ride"] = 91.88, ["Fly|Ride"] = 216.57, ["Neon"] = 131.25, ["Neon|Fly"] = 388.06, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 301.02, ["Mega"] = 477.75, ["Mega|Fly"] = 622.99, ["Mega|Ride"] = 538.13, ["Mega|Fly|Ride"] = 589.05}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 27.04, ["Fly"] = 131.25, ["Ride"] = 49.88, ["Fly|Ride"] = 130.05, ["Neon"] = 131.25, ["Neon|Ride"] = 140.55, ["Neon|Fly|Ride"] = 236.25, ["Mega|Ride"] = 783.12, ["Mega|Fly|Ride"] = 2062.23}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 20.89, ["Ride"] = 72.02, ["Fly|Ride"] = 51.45, ["Neon"] = 2.1, ["Neon|Fly"] = 28.33, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 63, ["Mega"] = 23.25, ["Mega|Fly"] = 56.65, ["Mega|Ride"] = 70.28, ["Mega|Fly|Ride"] = 115.5}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 215.25, ["Ride"] = 266.07, ["Fly|Ride"] = 313.69, ["Neon|Ride"] = 1835.68, ["Neon|Fly|Ride"] = 1317.75, ["Mega"] = 3459.98, ["Mega|Fly|Ride"] = 3618.35}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 13.54, ["Fly"] = 140.39, ["Ride"] = 45.93, ["Neon"] = 91.88, ["Neon|Ride"] = 156.19, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 629.29, ["Mega|Ride"] = 560.07, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 24.94, ["Ride"] = 28.32, ["Fly|Ride"] = 39.38, ["Neon"] = 4.65, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 61.68, ["Mega|Ride"] = 140.55, ["Mega|Fly|Ride"] = 280.04}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 140.54, ["Ride"] = 18.38, ["Neon"] = 2.23, ["Neon|Ride"] = 22.41, ["Neon|Fly|Ride"] = 95.71, ["Mega"] = 26.25, ["Mega|Fly"] = 144.38, ["Mega|Ride"] = 6041.43, ["Mega|Fly|Ride"] = 105.89}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 3.93, ["Ride"] = 26.25, ["Fly|Ride"] = 70.28, ["Neon"] = 6.56, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 6992.3, ["Mega"] = 86.03, ["Mega|Ride"] = 131.23, ["Mega|Fly|Ride"] = 419.53}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 9.87, ["Fly"] = 65.63, ["Ride"] = 23.25, ["Fly|Ride"] = 73.21, ["Neon"] = 75.49, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 120.85, ["Mega"] = 497.27, ["Mega|Ride"] = 263.26, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 9.17, ["Neon"] = 101.07, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 208.72, ["Mega|Ride"] = 360.19, ["Mega|Fly|Ride"] = 446.8}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 52.45, ["Fly|Ride"] = 91.25, ["Neon"] = 2.1, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 93.19, ["Mega"] = 28.33, ["Mega|Ride"] = 81.38, ["Mega|Fly|Ride"] = 127.32}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 12.79, ["Ride"] = 28.32, ["Fly|Ride"] = 94.41, ["Neon"] = 35.68, ["Neon|Fly"] = 102.92, ["Neon|Ride"] = 56.65, ["Neon|Fly|Ride"] = 123.36, ["Mega"] = 147.56, ["Mega|Fly"] = 140.55, ["Mega|Ride"] = 255.91, ["Mega|Fly|Ride"] = 209.77}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 210, ["Neon"] = 6.99, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 155.69, ["Mega"] = 34.1, ["Mega|Ride"] = 98.6, ["Mega|Fly|Ride"] = 620.42}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 40.05, ["Ride"] = 19.69, ["Fly|Ride"] = 118.13, ["Neon"] = 5.98, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 116.44, ["Mega"] = 52.49, ["Mega|Ride"] = 91.77, ["Mega|Fly|Ride"] = 195.2}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 1349.64, ["Ride"] = 1677.88, ["Fly|Ride"] = 1362.57, ["Neon|Fly|Ride"] = 4883.64, ["Mega|Fly|Ride"] = 15383.68}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 20.92, ["Fly|Ride"] = 44.06, ["Neon"] = 20.98, ["Neon|Fly"] = 40.99, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 61.93, ["Mega"] = 187.76, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.61, ["Ride"] = 56.64, ["Neon"] = 5.25, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 31.89, ["Mega|Ride"] = 112.22, ["Mega|Fly|Ride"] = 220.38}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 9.81, ["Fly"] = 41.84, ["Ride"] = 22.09, ["Fly|Ride"] = 62.75, ["Neon"] = 35.44, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 93, ["Mega|Ride"] = 326.55, ["Mega|Fly|Ride"] = 336}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 40.91, ["Ride"] = 17.45, ["Fly|Ride"] = 37.31, ["Neon"] = 6.56, ["Neon|Fly"] = 89.24, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 62.99, ["Mega"] = 73.48, ["Mega|Ride"] = 140.55, ["Mega|Fly|Ride"] = 155.69}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 62.75, ["Neon"] = 350.32, ["Neon|Ride"] = 338.63, ["Neon|Fly|Ride"] = 560.07, ["Mega"] = 769.13, ["Mega|Ride"] = 979.58, ["Mega|Fly|Ride"] = 763.53}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Neon"] = 4.66, ["Neon|Ride"] = 140.55, ["Mega"] = 78.69, ["Mega|Ride"] = 107.63, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 3.29, ["Fly"] = 73.5, ["Ride"] = 31.37, ["Fly|Ride"] = 65.63, ["Neon"] = 13.13, ["Neon|Fly"] = 146.84, ["Neon|Ride"] = 70.09, ["Neon|Fly|Ride"] = 140.55, ["Mega"] = 209.77, ["Mega|Ride"] = 341.93, ["Mega|Fly|Ride"] = 419.53}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.63, ["Fly|Ride"] = 65.76, ["Neon"] = 15.74, ["Neon|Fly"] = 62.75, ["Mega"] = 259.23}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Ride"] = 23.36, ["Fly|Ride"] = 98.44, ["Neon"] = 3.77, ["Neon|Ride"] = 23.94, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 28.33, ["Mega|Fly"] = 419.53, ["Mega|Ride"] = 70.28, ["Mega|Fly|Ride"] = 204.5}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 19.47, ["Fly"] = 30.19, ["Ride"] = 27.91, ["Fly|Ride"] = 46.49, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 839.05, ["Mega|Ride"] = 519.17, ["Mega|Fly|Ride"] = 383.87}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 838.69, ["Ride"] = 787.49, ["Fly|Ride"] = 931.88, ["Neon"] = 2100, ["Neon|Ride"] = 2139.38, ["Neon|Fly|Ride"] = 2099.74, ["Mega"] = 6992.3, ["Mega|Ride"] = 5643.75, ["Mega|Fly|Ride"] = 5250}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 66.89, ["Ride"] = 18.45, ["Fly|Ride"] = 44.06, ["Neon"] = 5.72, ["Neon|Fly"] = 28.33, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 81.38, ["Mega"] = 36.75, ["Mega|Fly"] = 109.1, ["Mega|Ride"] = 193.39, ["Mega|Fly|Ride"] = 138.28}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 4.19, ["Ride"] = 38.66, ["Neon"] = 56.2, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 335.64, ["Mega"] = 275.63, ["Mega|Ride"] = 251.72, ["Mega|Fly|Ride"] = 441}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 77.62, ["Neon|Fly|Ride"] = 734.16, ["Mega"] = 2944.05, ["Mega|Fly|Ride"] = 2231.25}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 49.88, ["Ride"] = 52.5, ["Fly|Ride"] = 301.88, ["Neon"] = 155.69, ["Neon|Ride"] = 177.19, ["Mega"] = 839.05, ["Mega|Ride"] = 732.06, ["Mega|Fly|Ride"] = 929.48}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 15.59, ["Ride"] = 39.29, ["Neon"] = 78.75, ["Neon|Ride"] = 392.44, ["Neon|Fly|Ride"] = 209.83, ["Mega"] = 210, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 464.79}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 35.67, ["Ride"] = 131.25, ["Neon"] = 104.89, ["Neon|Ride"] = 356.69, ["Mega"] = 356.61, ["Mega|Ride"] = 267.75, ["Mega|Fly|Ride"] = 432.48}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 39.87, ["Fly"] = 105, ["Ride"] = 315, ["Neon"] = 224.44, ["Neon|Ride"] = 314.65, ["Neon|Fly|Ride"] = 525, ["Mega"] = 656.25, ["Mega|Fly"] = 182.52, ["Mega|Ride"] = 586.28, ["Mega|Fly|Ride"] = 808.64}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 12.47}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 11.54, ["Fly"] = 39.38, ["Ride"] = 31.38, ["Neon"] = 67.41, ["Neon|Ride"] = 74.8, ["Neon|Fly|Ride"] = 493.5, ["Mega"] = 245.43, ["Mega|Ride"] = 216.57, ["Mega|Fly|Ride"] = 527.93}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 3.93, ["Neon"] = 35.67, ["Mega"] = 867.89, ["Mega|Fly|Ride"] = 943.92}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 68.25, ["Fly"] = 418.43, ["Ride"] = 91.28, ["Fly|Ride"] = 98.44, ["Neon"] = 193.31, ["Neon|Ride"] = 208.22, ["Neon|Fly|Ride"] = 314.65, ["Mega|Ride"] = 681.19, ["Mega|Fly|Ride"] = 811.13}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.54, ["Fly"] = 23.63, ["Ride"] = 16.9, ["Fly|Ride"] = 44.18, ["Neon"] = 28.33, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 96.5, ["Mega"] = 183.75, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 6.51, ["Fly"] = 98.59, ["Ride"] = 33.7, ["Fly|Ride"] = 100.69, ["Neon"] = 19.69, ["Neon|Ride"] = 95.44, ["Neon|Fly|Ride"] = 103.92, ["Mega"] = 208.72, ["Mega|Fly"] = 301.45, ["Mega|Ride"] = 163.42, ["Mega|Fly|Ride"] = 356.69}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 7.62, ["Neon|Ride"] = 198.68, ["Mega"] = 31.35, ["Mega|Ride"] = 95.45, ["Mega|Fly|Ride"] = 190.89}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 56.44, ["Ride"] = 70.27, ["Fly|Ride"] = 78.72, ["Neon"] = 261.19, ["Neon|Ride"] = 182.52, ["Neon|Fly|Ride"] = 280.04, ["Mega"] = 1085.16, ["Mega|Ride"] = 734.08, ["Mega|Fly|Ride"] = 797.09}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Neon"] = 17.46, ["Neon|Fly"] = 145.69, ["Mega"] = 121.68}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 8.29, ["Ride"] = 140.63, ["Neon|Ride"] = 104.89, ["Neon|Fly|Ride"] = 293.67, ["Mega"] = 320.95, ["Mega|Ride"] = 392.44, ["Mega|Fly|Ride"] = 968.05}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 23.24, ["Ride"] = 17.07, ["Fly|Ride"] = 56.65, ["Neon"] = 24.91, ["Neon|Ride"] = 19.94, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 70.28, ["Mega|Ride"] = 196.23, ["Mega|Fly|Ride"] = 313.61}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 3.52, ["Fly"] = 52.5, ["Ride"] = 17.43, ["Fly|Ride"] = 49.88, ["Neon"] = 52.5, ["Neon|Ride"] = 125.87, ["Mega"] = 310.22, ["Mega|Ride"] = 418.48, ["Mega|Fly|Ride"] = 327.24}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 2.61, ["Ride"] = 139.47, ["Neon"] = 22.32, ["Neon|Ride"] = 111.57, ["Mega"] = 140.59, ["Mega|Ride"] = 547.98, ["Mega|Fly|Ride"] = 417.43}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 36.75, ["Fly"] = 131.25, ["Ride"] = 91.88, ["Fly|Ride"] = 131.25, ["Neon"] = 190.32, ["Neon|Ride"] = 208.72, ["Mega|Ride"] = 1258.57, ["Mega|Fly|Ride"] = 832.13}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 23.24, ["Ride"] = 251.69, ["Neon"] = 116.82, ["Mega"] = 393.75, ["Mega|Ride"] = 774.95, ["Mega|Fly|Ride"] = 453.09}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 23.63, ["Ride"] = 105, ["Neon"] = 116.2, ["Neon|Ride"] = 393.75, ["Mega"] = 203.44, ["Mega|Ride"] = 1551.03, ["Mega|Fly|Ride"] = 1678.08}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 131.24, ["Ride"] = 105, ["Fly|Ride"] = 422.03, ["Neon"] = 151.96, ["Mega"] = 766.5, ["Mega|Ride"] = 708.75, ["Mega|Fly|Ride"] = 678.59}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 3.67, ["Neon"] = 45.03, ["Mega"] = 839.05}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 28.32, ["Ride"] = 20.92, ["Fly|Ride"] = 50.36, ["Neon"] = 6.56, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 22.1, ["Neon|Fly|Ride"] = 137.82, ["Mega"] = 62.94, ["Mega|Ride"] = 112.24, ["Mega|Fly|Ride"] = 258.56}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 3.93, ["Ride"] = 91.88, ["Fly|Ride"] = 91.26, ["Neon"] = 35.44, ["Neon|Ride"] = 89.25, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 280.04, ["Mega|Ride"] = 488.76}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 32.45, ["Ride"] = 20.98, ["Fly|Ride"] = 53.82, ["Neon"] = 6.18, ["Neon|Ride"] = 30.45, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 42.2, ["Mega|Ride"] = 80.56, ["Mega|Fly|Ride"] = 260.12}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.61, ["Ride"] = 26.25, ["Fly|Ride"] = 98.6, ["Neon"] = 12.6, ["Neon|Ride"] = 92.96, ["Neon|Fly|Ride"] = 260.12, ["Mega"] = 249.38, ["Mega|Ride"] = 150.94, ["Mega|Fly|Ride"] = 464.75}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.78, ["Ride"] = 31.47, ["Fly|Ride"] = 99.75, ["Neon"] = 62.75, ["Neon|Ride"] = 112.24, ["Mega"] = 419.53, ["Mega|Ride"] = 419.53, ["Mega|Fly|Ride"] = 1258.57}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 3.89, ["Fly"] = 41.96, ["Ride"] = 22.42, ["Neon"] = 18.38, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 105, ["Mega"] = 280.04, ["Mega|Ride"] = 242.28, ["Mega|Fly|Ride"] = 249.62}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 3.82, ["Fly"] = 34.07, ["Ride"] = 23.25, ["Fly|Ride"] = 58.74, ["Neon"] = 22.1, ["Neon|Ride"] = 82.5, ["Neon|Fly|Ride"] = 109.23, ["Mega"] = 166.66, ["Mega|Ride"] = 173.25, ["Mega|Fly|Ride"] = 455.19}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 9, ["Ride"] = 27.57, ["Neon"] = 24.78, ["Neon|Fly"] = 140.55, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 458.93, ["Mega"] = 73.75, ["Mega|Ride"] = 305.82, ["Mega|Fly|Ride"] = 314.65}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 12.6, ["Ride"] = 92.96, ["Fly|Ride"] = 196.12, ["Neon"] = 78.75, ["Neon|Ride"] = 155.7, ["Neon|Fly|Ride"] = 375.27, ["Mega"] = 442.32, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 59.06, ["Fly"] = 202.14, ["Ride"] = 92.3, ["Fly|Ride"] = 262.49, ["Neon"] = 236.25, ["Neon|Ride"] = 202.18, ["Neon|Fly|Ride"] = 293.67, ["Mega"] = 1678.08, ["Mega|Ride"] = 1063.13, ["Mega|Fly|Ride"] = 1085.64}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 65.63, ["Neon"] = 3.94, ["Neon|Ride"] = 37.91, ["Mega"] = 39.38, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 90.41}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 15.74, ["Ride"] = 131.25, ["Neon"] = 54.55, ["Mega"] = 312.38, ["Mega|Ride"] = 363.95, ["Mega|Fly|Ride"] = 1244.93}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 67.13, ["Fly"] = 105, ["Ride"] = 115.5, ["Neon|Ride"] = 1119.07, ["Mega"] = 1085.52, ["Mega|Ride"] = 1099.14, ["Mega|Fly|Ride"] = 1147.39}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 6.98, ["Fly"] = 190.32, ["Ride"] = 46.47, ["Fly|Ride"] = 126, ["Neon"] = 49.86, ["Neon|Ride"] = 59.07, ["Mega"] = 167.83, ["Mega|Ride"] = 173.25, ["Mega|Fly|Ride"] = 209.77}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 2.1, ["Fly"] = 157.5, ["Ride"] = 62.87, ["Fly|Ride"] = 116.44, ["Neon"] = 3.91, ["Neon|Ride"] = 27.53, ["Mega"] = 33.9, ["Mega|Ride"] = 54.39, ["Mega|Fly|Ride"] = 209.77}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 34.13, ["Ride"] = 20.98, ["Fly|Ride"] = 51.14, ["Neon"] = 15.75, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 125.87, ["Mega"] = 203.6, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 231}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 18.89, ["Ride"] = 18.04, ["Fly|Ride"] = 40.92, ["Neon"] = 3.93, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 31.38, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 16.89, ["Fly|Ride"] = 65.7, ["Neon"] = 3.93, ["Neon|Ride"] = 29.27, ["Neon|Fly|Ride"] = 83.92, ["Mega"] = 39.38, ["Mega|Fly"] = 168, ["Mega|Ride"] = 73.44, ["Mega|Fly|Ride"] = 167.99}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 28.32, ["Neon"] = 2.1, ["Neon|Ride"] = 155.69, ["Mega"] = 17.43, ["Mega|Ride"] = 104.89, ["Mega|Fly|Ride"] = 258.02}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 46.49, ["Ride"] = 31.38, ["Fly|Ride"] = 356.61, ["Neon"] = 34.54, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 629.29, ["Mega"] = 213.94, ["Mega|Ride"] = 309.41, ["Mega|Fly|Ride"] = 1118.02}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 8.4, ["Ride"] = 41.94, ["Neon"] = 124.43, ["Neon|Ride"] = 202.13, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 222.36, ["Mega|Ride"] = 398.55, ["Mega|Fly|Ride"] = 356.61}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 7.29, ["Fly"] = 23.08, ["Ride"] = 20.92, ["Fly|Ride"] = 54.94, ["Neon"] = 36.03, ["Neon|Fly"] = 124.34, ["Neon|Ride"] = 41.97, ["Neon|Fly|Ride"] = 103.69, ["Mega|Ride"] = 310.46, ["Mega|Fly|Ride"] = 513.84}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 70.27, ["Ride"] = 91.88, ["Fly|Ride"] = 262.5, ["Neon"] = 419.53, ["Neon|Ride"] = 524.42}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 18.47, ["Ride"] = 65.63, ["Neon"] = 72.19, ["Mega"] = 613.59, ["Mega|Fly"] = 643.97, ["Mega|Ride"] = 603.75, ["Mega|Fly|Ride"] = 1029.67}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 17.78, ["Fly|Ride"] = 40.68, ["Neon"] = 3.93, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 39.52, ["Mega|Ride"] = 107.63, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 15.43, ["Ride"] = 17.07, ["Fly|Ride"] = 39.79, ["Neon"] = 3.91, ["Neon|Fly"] = 26.17, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 53.81, ["Mega"] = 39.38, ["Mega|Fly"] = 70.28, ["Mega|Ride"] = 58.1, ["Mega|Fly|Ride"] = 148.97}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 588.52, ["Ride"] = 459.38, ["Fly|Ride"] = 551.25, ["Neon|Fly|Ride"] = 1522.5}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 14.18, ["Ride"] = 140.54, ["Neon"] = 105, ["Neon|Fly|Ride"] = 398.55, ["Mega"] = 495.48, ["Mega|Ride"] = 514.98, ["Mega|Fly|Ride"] = 350.32}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 28.32, ["Ride"] = 17.07, ["Fly|Ride"] = 36.03, ["Neon"] = 6.18, ["Neon|Ride"] = 20.93, ["Neon|Fly|Ride"] = 64.24, ["Mega"] = 155.69, ["Mega|Fly"] = 46.49, ["Mega|Ride"] = 72.05, ["Mega|Fly|Ride"] = 309.41}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 80.22, ["Ride"] = 123.75, ["Fly|Ride"] = 167.81, ["Neon"] = 223.12, ["Neon|Ride"] = 288.75, ["Neon|Fly|Ride"] = 476.16, ["Mega"] = 737.63, ["Mega|Ride"] = 748.13, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 12.79, ["Fly|Ride"] = 43.31, ["Neon"] = 8.4, ["Neon|Fly"] = 77.85, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 83.98, ["Mega"] = 128.63, ["Mega|Fly"] = 182.52, ["Mega|Ride"] = 115.27, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Ride"] = 98.59, ["Fly|Ride"] = 1312.5, ["Neon"] = 3.91, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 283.4, ["Mega"] = 17.43, ["Mega|Ride"] = 112.24, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 64.51, ["Ride"] = 131.25, ["Neon"] = 193.28, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 825.41, ["Mega|Ride"] = 792.9, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Ride"] = 19.94, ["Neon"] = 19.69, ["Neon|Ride"] = 53.5, ["Mega"] = 97.61, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 39.89, ["Fly"] = 140.54, ["Ride"] = 60.38, ["Fly|Ride"] = 280.01, ["Neon"] = 187.76, ["Neon|Ride"] = 196.14, ["Neon|Fly|Ride"] = 260.12, ["Mega|Ride"] = 1675.98, ["Mega|Fly|Ride"] = 1048.81}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 9.31, ["Ride"] = 115.02, ["Neon"] = 78.75, ["Neon|Ride"] = 419.53, ["Mega"] = 196.88, ["Mega|Ride"] = 822.94, ["Mega|Fly|Ride"] = 544.04}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.1, ["Fly"] = 70.27, ["Ride"] = 70.9, ["Neon"] = 11.54, ["Neon|Fly"] = 62.94, ["Neon|Ride"] = 56.65, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 133.21, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 560.07}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 27.57, ["Ride"] = 40.99, ["Fly|Ride"] = 91.88, ["Neon|Ride"] = 131.25, ["Mega|Ride"] = 2611.88, ["Mega|Fly|Ride"] = 1239.67}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 131.62, ["Ride"] = 89.25, ["Neon"] = 4.47, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 83.92, ["Neon|Fly|Ride"] = 168, ["Mega"] = 47.25, ["Mega|Fly"] = 158.61, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 307.96}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 46.49, ["Ride"] = 23.62, ["Fly|Ride"] = 72.17, ["Neon"] = 8.39, ["Neon|Fly"] = 41.88, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 105.59, ["Mega|Ride"] = 153.15, ["Mega|Fly|Ride"] = 284.17}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 12.46, ["Ride"] = 36.71, ["Neon"] = 44.63, ["Neon|Ride"] = 112.24, ["Mega"] = 254.63, ["Mega|Ride"] = 503.44, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 25.45, ["Ride"] = 116.82, ["Fly|Ride"] = 182.48, ["Neon"] = 153.34, ["Neon|Fly"] = 280.04, ["Neon|Ride"] = 169.64, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 551.24, ["Mega|Ride"] = 518.44, ["Mega|Fly|Ride"] = 689.07}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 29.4, ["Fly"] = 30.17, ["Ride"] = 41.96, ["Fly|Ride"] = 79.72, ["Neon"] = 103.69, ["Neon|Ride"] = 83.92, ["Neon|Fly|Ride"] = 222.89, ["Mega"] = 620.42, ["Mega|Ride"] = 354.38, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 68.23, ["Ride"] = 115.5, ["Fly|Ride"] = 237.57, ["Neon"] = 341.25, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 551.25, ["Mega"] = 1443.75, ["Mega|Ride"] = 1302, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 3.93, ["Ride"] = 32.01, ["Fly|Ride"] = 262.5, ["Neon"] = 19.69, ["Neon|Ride"] = 140.55, ["Neon|Fly|Ride"] = 314.65, ["Mega"] = 155.69, ["Mega|Ride"] = 251.72, ["Mega|Fly|Ride"] = 328.79}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 5.25, ["Ride"] = 28.32, ["Fly|Ride"] = 109.07, ["Neon"] = 25.57, ["Neon|Ride"] = 70.28, ["Mega"] = 237.03, ["Mega|Ride"] = 220.61, ["Mega|Fly|Ride"] = 310.22}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 17.82, ["Fly"] = 105, ["Ride"] = 46.57, ["Fly|Ride"] = 157.5, ["Neon"] = 123.78, ["Neon|Ride"] = 140.55, ["Neon|Fly|Ride"] = 168.6, ["Mega"] = 366.19, ["Mega|Fly|Ride"] = 458.07}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 15.74, ["Fly|Ride"] = 45.11, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 17.45, ["Neon|Fly|Ride"] = 62.75, ["Mega"] = 15.74, ["Mega|Fly"] = 77.86, ["Mega|Ride"] = 30.43, ["Mega|Fly|Ride"] = 98.44}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 65.61, ["Fly"] = 220.5, ["Ride"] = 419.48, ["Neon"] = 301.02, ["Neon|Fly"] = 2377.62, ["Neon|Ride"] = 266.53, ["Mega"] = 933.19, ["Mega|Fly"] = 958.61, ["Mega|Ride"] = 1004.76, ["Mega|Fly|Ride"] = 962}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 23.25, ["Fly|Ride"] = 89.25, ["Neon"] = 3.94, ["Neon|Ride"] = 19.69, ["Mega"] = 106.99, ["Mega|Fly|Ride"] = 210.76}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 28.32, ["Ride"] = 30.03, ["Fly|Ride"] = 62.93, ["Neon"] = 40.69, ["Neon|Ride"] = 32.44, ["Neon|Fly|Ride"] = 98.6, ["Mega"] = 209.77, ["Mega|Ride"] = 209.77, ["Mega|Fly|Ride"] = 416.73}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 84.62, ["Fly"] = 209.75, ["Ride"] = 226.99, ["Fly|Ride"] = 426.87, ["Neon"] = 262.5, ["Neon|Ride"] = 264.8, ["Neon|Fly|Ride"] = 587.33, ["Mega"] = 972.24, ["Mega|Ride"] = 912.19, ["Mega|Fly|Ride"] = 1010.63}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 56.64, ["Neon"] = 6.48, ["Neon|Ride"] = 1398.92, ["Mega"] = 51.14, ["Mega|Ride"] = 91.2, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 24.94}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 20235.17, ["Fly|Ride"] = 104.99, ["Neon"] = 6.56, ["Neon|Ride"] = 38.06, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 42.39, ["Mega|Fly"] = 95.45, ["Mega|Ride"] = 115.5, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 157.5, ["Ride"] = 167.81, ["Fly|Ride"] = 449.64, ["Neon"] = 653.41, ["Neon|Ride"] = 556.92, ["Neon|Fly|Ride"] = 735, ["Mega|Fly|Ride"] = 2086.88}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 3.93, ["Ride"] = 41.99, ["Neon"] = 21.84, ["Neon|Ride"] = 40.69, ["Mega"] = 280.04, ["Mega|Fly|Ride"] = 405.9}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 209.75, ["Neon"] = 6.57, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 39.52, ["Mega|Ride"] = 83.92, ["Mega|Fly|Ride"] = 312.9}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 3.93, ["Ride"] = 30.85, ["Neon"] = 52.49, ["Neon|Ride"] = 140.55, ["Neon|Fly|Ride"] = 156.42, ["Mega"] = 389.11, ["Mega|Ride"] = 280.04, ["Mega|Fly|Ride"] = 620.42}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 8.29, ["Fly"] = 74.47, ["Ride"] = 26.24, ["Neon"] = 145.69, ["Neon|Fly|Ride"] = 274.8, ["Mega"] = 350.07, ["Mega|Ride"] = 392.43, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 28.87, ["Ride"] = 62.42, ["Fly|Ride"] = 167.83, ["Neon"] = 151.05, ["Neon|Ride"] = 182.57, ["Neon|Fly|Ride"] = 280.04, ["Mega"] = 602.02, ["Mega|Ride"] = 635.58, ["Mega|Fly|Ride"] = 616.87}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 140.7, ["Fly"] = 236.99, ["Ride"] = 175.88, ["Fly|Ride"] = 308.44, ["Neon"] = 419.53, ["Neon|Ride"] = 548.63, ["Neon|Fly|Ride"] = 589.32, ["Mega|Fly|Ride"] = 2286.38}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 6.56, ["Fly"] = 23.63, ["Ride"] = 17.43, ["Fly|Ride"] = 37.41, ["Neon"] = 36.75, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 94.48, ["Mega|Ride"] = 699.57, ["Mega|Fly|Ride"] = 385.37}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 3.91, ["Fly"] = 131.23, ["Fly|Ride"] = 131.25, ["Neon"] = 20.99, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 192.95, ["Mega"] = 140.55, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 464.75}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 9.74, ["Fly"] = 232.35, ["Fly|Ride"] = 140.55, ["Neon|Ride"] = 132.7, ["Mega"] = 503.44, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 503.62}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 38.17, ["Ride"] = 77.62, ["Fly|Ride"] = 98.64, ["Neon"] = 155.24, ["Neon|Ride"] = 224.46, ["Neon|Fly|Ride"] = 280.03, ["Mega|Fly"] = 979.58, ["Mega|Ride"] = 839.26, ["Mega|Fly|Ride"] = 880.69}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 19.69, ["Fly"] = 65.63, ["Ride"] = 81.38, ["Neon"] = 118.12, ["Neon|Ride"] = 209.77, ["Mega"] = 669.38, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 524.42}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 262.5, ["Ride"] = 413.44, ["Neon"] = 2167.87, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1678.08, ["Mega|Ride"] = 3937.5, ["Mega|Fly|Ride"] = 4119.25}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 31.47, ["Ride"] = 42, ["Fly|Ride"] = 98.6, ["Neon"] = 280.04, ["Neon|Ride"] = 203.44, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 1195.69, ["Mega|Ride"] = 629.29, ["Mega|Fly|Ride"] = 699.57}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 28.32, ["Ride"] = 15.74, ["Neon"] = 2.18, ["Neon|Ride"] = 19.94, ["Neon|Fly|Ride"] = 55.13, ["Mega"] = 18.88, ["Mega|Fly"] = 65.63, ["Mega|Ride"] = 53.5, ["Mega|Fly|Ride"] = 136.18}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 7.87, ["Ride"] = 59.07, ["Neon"] = 14.44, ["Neon|Ride"] = 39.38, ["Mega"] = 130.07, ["Mega|Ride"] = 155.69, ["Mega|Fly|Ride"] = 491.54}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 6.56, ["Ride"] = 39.37, ["Neon"] = 18.32, ["Neon|Ride"] = 77.86, ["Neon|Fly|Ride"] = 1181.25, ["Mega"] = 124.68, ["Mega|Fly"] = 224.46, ["Mega|Ride"] = 280.04, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 393.75, ["Fly"] = 620.36, ["Ride"] = 420, ["Fly|Ride"] = 461.34, ["Neon"] = 1538.59, ["Neon|Ride"] = 1386.52, ["Neon|Fly|Ride"] = 1345.32, ["Mega|Fly|Ride"] = 4824.45}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.5, ["Fly"] = 41.96, ["Ride"] = 17.45, ["Fly|Ride"] = 56.44, ["Neon"] = 46.49, ["Neon|Ride"] = 69.57, ["Neon|Fly|Ride"] = 71.18, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 839.05}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 7.77, ["Fly"] = 31.77, ["Ride"] = 24.13, ["Fly|Ride"] = 53.01, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 208.72, ["Mega"] = 419.53, ["Mega|Ride"] = 699.57, ["Mega|Fly|Ride"] = 839.05}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 5.55, ["Fly"] = 83.91, ["Ride"] = 26.25, ["Neon"] = 19.67, ["Neon|Fly"] = 105, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 123.38, ["Mega"] = 147, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 464.75}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 38.66, ["Fly"] = 210, ["Ride"] = 61.88, ["Neon"] = 118.13, ["Neon|Ride"] = 251.72, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 393.75, ["Mega|Ride"] = 838, ["Mega|Fly|Ride"] = 640.49}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 315, ["Ride"] = 62.91, ["Neon"] = 14.44, ["Neon|Ride"] = 109.23, ["Neon|Fly|Ride"] = 210, ["Mega|Ride"] = 109.23, ["Mega|Fly|Ride"] = 620.17}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 5.92, ["Fly"] = 104.15, ["Ride"] = 24.93, ["Fly|Ride"] = 91.88, ["Neon"] = 310.22, ["Neon|Ride"] = 141.75, ["Mega"] = 699.57, ["Mega|Ride"] = 310.22, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 35.66, ["Neon"] = 6.55, ["Neon|Ride"] = 41.97, ["Mega"] = 131.25, ["Mega|Ride"] = 58.75, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 12.58, ["Ride"] = 69.57, ["Neon"] = 77.86, ["Mega"] = 196.88, ["Mega|Ride"] = 338.63, ["Mega|Fly|Ride"] = 629.29}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 11.81, ["Ride"] = 278.96, ["Neon"] = 189, ["Mega"] = 419.53, ["Mega|Ride"] = 266.41, ["Mega|Fly|Ride"] = 1048.81}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 17.05, ["Fly"] = 32.8, ["Ride"] = 22.44, ["Fly|Ride"] = 50.09, ["Neon"] = 52.5, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 49.87, ["Neon|Fly|Ride"] = 119.68, ["Mega"] = 405.9, ["Mega|Ride"] = 342.75, ["Mega|Fly|Ride"] = 464.28}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 195.57, ["Fly"] = 498.75, ["Ride"] = 186.35, ["Fly|Ride"] = 280.03, ["Neon"] = 865.44, ["Neon|Ride"] = 924, ["Neon|Fly|Ride"] = 850.84, ["Mega|Fly|Ride"] = 2741.55}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 17.07, ["Fly|Ride"] = 65.02, ["Neon"] = 20.99, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 108.29, ["Mega"] = 220.5, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 2.1, ["Ride"] = 34.13, ["Fly|Ride"] = 77.63, ["Neon"] = 15.74, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 334.69, ["Mega"] = 137.82, ["Mega|Ride"] = 419.53, ["Mega|Fly|Ride"] = 410.82}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 30.44, ["Fly|Ride"] = 511.88, ["Neon"] = 143.07, ["Neon|Ride"] = 238.06, ["Neon|Fly|Ride"] = 629.22, ["Mega"] = 418.42, ["Mega|Ride"] = 378, ["Mega|Fly|Ride"] = 467.25}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 77.64, ["Fly"] = 393.75, ["Ride"] = 98.59, ["Fly|Ride"] = 202.17, ["Neon"] = 317.62, ["Neon|Ride"] = 437.07, ["Neon|Fly|Ride"] = 629.29, ["Mega|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 1399.11}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 26.25, ["Ride"] = 91.88, ["Fly|Ride"] = 272.7, ["Neon"] = 97.89, ["Neon|Ride"] = 162.58, ["Neon|Fly|Ride"] = 183.65, ["Mega"] = 214.45, ["Mega|Ride"] = 283.02, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 23.08, ["Fly|Ride"] = 39.29, ["Neon"] = 15.74, ["Mega"] = 124.34, ["Mega|Ride"] = 280.04, ["Mega|Fly|Ride"] = 350.32}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 18.9, ["Ride"] = 65.62, ["Neon"] = 59.07, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 307.13, ["Mega"] = 264.31, ["Mega|Ride"] = 309.41, ["Mega|Fly|Ride"] = 390.22}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 71.38, ["Ride"] = 116.19, ["Fly|Ride"] = 262.5, ["Neon"] = 223.13, ["Neon|Ride"] = 288.74, ["Neon|Fly|Ride"] = 392.26, ["Mega"] = 523.68, ["Mega|Ride"] = 535.5, ["Mega|Fly|Ride"] = 602.43}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.1, ["Ride"] = 72.19, ["Neon"] = 4.36, ["Neon|Ride"] = 104.74, ["Neon|Fly|Ride"] = 157.34, ["Mega"] = 36.63, ["Mega|Fly"] = 115.5, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 11.44, ["Ride"] = 288.75, ["Neon"] = 51.19, ["Neon|Ride"] = 155.24, ["Mega"] = 236.25, ["Mega|Fly|Ride"] = 520.22}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 997.49, ["Fly"] = 1365, ["Ride"] = 983.07, ["Fly|Ride"] = 1179.94, ["Neon"] = 3328.88, ["Neon|Ride"] = 3670.78, ["Neon|Fly|Ride"] = 3281.25, ["Mega|Fly|Ride"] = 10762.5}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 24.94, ["Ride"] = 136.34, ["Fly|Ride"] = 222.36, ["Neon"] = 178.31, ["Neon|Ride"] = 266.41, ["Mega"] = 590.63, ["Mega|Ride"] = 551.25, ["Mega|Fly|Ride"] = 629.29}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 6.45, ["Fly"] = 47.35, ["Ride"] = 39.38, ["Fly|Ride"] = 262.5, ["Neon"] = 22.09, ["Neon|Fly"] = 191.63, ["Neon|Ride"] = 52.48, ["Neon|Fly|Ride"] = 140.55, ["Mega"] = 103.69, ["Mega|Ride"] = 154.88, ["Mega|Fly|Ride"] = 258.57}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 11.68, ["Ride"] = 131.22, ["Neon"] = 78.75, ["Neon|Fly|Ride"] = 408.19, ["Mega"] = 268.51, ["Mega|Ride"] = 194.25, ["Mega|Fly|Ride"] = 774.95}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Fly|Ride"] = 419.53, ["Neon"] = 2.61, ["Neon|Ride"] = 36.58, ["Neon|Fly|Ride"] = 100.7, ["Mega"] = 16.28, ["Mega|Ride"] = 62.99, ["Mega|Fly|Ride"] = 125.87}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 98.8, ["Ride"] = 397.95, ["Fly|Ride"] = 209.99, ["Neon"] = 315, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 807.87, ["Mega"] = 1312.5, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1197}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 7.74, ["Fly"] = 101.07, ["Ride"] = 49.3, ["Fly|Ride"] = 69.57, ["Neon"] = 34.96, ["Neon|Ride"] = 74.48, ["Mega"] = 348.22, ["Mega|Ride"] = 255.5, ["Mega|Fly|Ride"] = 325.14}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 3.24, ["Ride"] = 31.47, ["Neon"] = 11.8, ["Neon|Ride"] = 32.82, ["Mega"] = 140.44, ["Mega|Ride"] = 248.64, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 42, ["Fly"] = 108.03, ["Ride"] = 78.75, ["Fly|Ride"] = 183.74, ["Neon"] = 157.12, ["Neon|Fly"] = 280.04, ["Neon|Ride"] = 290.48, ["Neon|Fly|Ride"] = 414.29, ["Mega"] = 418.68, ["Mega|Ride"] = 556.92, ["Mega|Fly|Ride"] = 458.07}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 13.62, ["Fly"] = 183.75, ["Ride"] = 70.27, ["Fly|Ride"] = 95.28, ["Neon"] = 91.88, ["Neon|Fly"] = 185.91, ["Neon|Ride"] = 196.14, ["Neon|Fly|Ride"] = 309.41, ["Mega"] = 417.43, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 84, ["Ride"] = 111.19, ["Neon"] = 560.07, ["Neon|Ride"] = 933.19, ["Neon|Fly|Ride"] = 919.42, ["Mega"] = 1468.31, ["Mega|Ride"] = 1818.62, ["Mega|Fly|Ride"] = 1363.45}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 6.56, ["Neon"] = 18.68, ["Neon|Ride"] = 109.25, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 121.7, ["Mega|Ride"] = 144.76, ["Mega|Fly|Ride"] = 308.44}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 8.39, ["Fly"] = 196.88, ["Ride"] = 30.44, ["Neon"] = 72.19, ["Neon|Ride"] = 70.28, ["Neon|Fly|Ride"] = 280.88, ["Mega"] = 354.37, ["Mega|Ride"] = 392.44, ["Mega|Fly|Ride"] = 702.85}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 150.94, ["Ride"] = 199.35, ["Fly|Ride"] = 242.82, ["Neon"] = 544.69, ["Neon|Ride"] = 577.5, ["Neon|Fly|Ride"] = 546, ["Mega"] = 2362.5, ["Mega|Ride"] = 2361.19, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 39.29, ["Ride"] = 21.93, ["Fly|Ride"] = 35.44, ["Neon"] = 16.62, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 83.92, ["Mega|Ride"] = 160.13, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 6.57, ["Fly"] = 87.94, ["Ride"] = 32.42, ["Fly|Ride"] = 65.63, ["Neon"] = 20.96, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 119.58, ["Mega"] = 220.5, ["Mega|Fly"] = 232.85, ["Mega|Ride"] = 262.22, ["Mega|Fly|Ride"] = 447.96}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 28.32, ["Ride"] = 15.74, ["Fly|Ride"] = 35.94, ["Neon"] = 2.1, ["Neon|Fly"] = 31.38, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 40.68, ["Mega"] = 15.74, ["Mega|Ride"] = 32.52, ["Mega|Fly|Ride"] = 92.59}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 31.47, ["Neon"] = 3.94, ["Mega"] = 19.94, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 54.63, ["Mega|Fly|Ride"] = 140.55}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 3.26, ["Fly"] = 131.51, ["Ride"] = 71.37, ["Neon"] = 22.32, ["Neon|Ride"] = 64.98, ["Mega"] = 266.41, ["Mega|Ride"] = 207.67, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 52.5, ["Ride"] = 315, ["Neon"] = 226.55, ["Neon|Ride"] = 452.82, ["Neon|Fly|Ride"] = 630, ["Mega"] = 774.38, ["Mega|Ride"] = 560.07, ["Mega|Fly|Ride"] = 799.19}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.1, ["Fly"] = 18.6, ["Ride"] = 19.69, ["Fly|Ride"] = 56.64, ["Neon"] = 17.45, ["Neon|Fly"] = 37.19, ["Neon|Ride"] = 32.54, ["Neon|Fly|Ride"] = 70.88, ["Mega"] = 195.09, ["Mega|Fly"] = 238.09, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 162.72}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 2.1, ["Fly"] = 28.33, ["Ride"] = 23.08, ["Fly|Ride"] = 70.28, ["Neon"] = 14.94, ["Neon|Fly"] = 33.55, ["Neon|Ride"] = 30.22, ["Neon|Fly|Ride"] = 98.59, ["Mega"] = 125.35, ["Mega|Fly"] = 280.04, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 223.27}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 3.91, ["Ride"] = 24.94, ["Fly|Ride"] = 115.71, ["Neon"] = 5.25, ["Neon|Fly"] = 98.44, ["Neon|Ride"] = 35.68, ["Neon|Fly|Ride"] = 106.32, ["Mega"] = 51.16, ["Mega|Fly"] = 408.19, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 15.74, ["Ride"] = 61.88, ["Neon"] = 28.33, ["Neon|Ride"] = 28.33, ["Neon|Fly|Ride"] = 188.81, ["Mega"] = 272.7, ["Mega|Ride"] = 302.07, ["Mega|Fly|Ride"] = 489.8}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 9.19, ["Fly"] = 153.83, ["Neon"] = 13.13, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 161.53, ["Mega"] = 420, ["Mega|Ride"] = 415.34, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 3.61, ["Fly"] = 35.44, ["Ride"] = 28.88, ["Fly|Ride"] = 139.42, ["Neon"] = 26.24, ["Neon|Fly"] = 196.65, ["Neon|Ride"] = 116.19, ["Neon|Fly|Ride"] = 105, ["Mega"] = 209.77, ["Mega|Ride"] = 207.72, ["Mega|Fly|Ride"] = 351.36}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.6, ["Ride"] = 16.86, ["Fly|Ride"] = 42.88, ["Neon"] = 15.22, ["Neon|Fly"] = 86, ["Neon|Ride"] = 50.36, ["Neon|Fly|Ride"] = 70.88, ["Mega"] = 98.6, ["Mega|Ride"] = 155.69, ["Mega|Fly|Ride"] = 223.91}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 213.21, ["Fly"] = 393.75, ["Ride"] = 294.73, ["Neon"] = 905.13, ["Neon|Ride"] = 929.48, ["Neon|Fly|Ride"] = 951.26, ["Mega"] = 5594.27, ["Mega|Fly|Ride"] = 3650.7}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 5.1, ["Ride"] = 61.76, ["Neon"] = 26.25, ["Neon|Fly|Ride"] = 280.04, ["Mega"] = 155.24, ["Mega|Ride"] = 140.55, ["Mega|Fly|Ride"] = 979.58}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 2.99, ["Fly"] = 65.63, ["Ride"] = 28.32, ["Fly|Ride"] = 118.13, ["Neon"] = 37.54, ["Neon|Ride"] = 58.1, ["Neon|Fly|Ride"] = 139.65, ["Mega"] = 203.44, ["Mega|Ride"] = 459.38}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 6.32, ["Neon"] = 40.66, ["Neon|Fly|Ride"] = 629.29, ["Mega"] = 65.63, ["Mega|Ride"] = 410.09, ["Mega|Fly|Ride"] = 419.53}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 23.63, ["Fly|Ride"] = 33.79, ["Neon"] = 2.1, ["Neon|Fly"] = 28.76, ["Neon|Ride"] = 20.99, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 17.95, ["Mega|Fly|Ride"] = 69.71}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.1, ["Fly"] = 56.44, ["Ride"] = 19.56, ["Fly|Ride"] = 40.93, ["Neon"] = 16.96, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 28.32, ["Neon|Fly|Ride"] = 78.75}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 3.14, ["Ride"] = 28.32, ["Neon"] = 12.59, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 133.41, ["Mega|Ride"] = 148.73, ["Mega|Fly|Ride"] = 450.19}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 68.25, ["Fly"] = 184.57, ["Ride"] = 99.64, ["Fly|Ride"] = 155.69, ["Neon"] = 341.25, ["Neon|Ride"] = 383.25, ["Neon|Fly|Ride"] = 446.25, ["Mega|Ride"] = 3497.74, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 6.17, ["Fly"] = 85.32, ["Ride"] = 65.03, ["Fly|Ride"] = 65.54, ["Neon"] = 15.73, ["Neon|Ride"] = 69.23, ["Neon|Fly|Ride"] = 310.22, ["Mega|Fly|Ride"] = 321.99}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Fly|Ride"] = 155.23, ["Neon"] = 13.96, ["Neon|Ride"] = 125.87, ["Neon|Fly|Ride"] = 167.83, ["Mega"] = 67.4, ["Mega|Fly"] = 409.04, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 915.52}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 59.07, ["Fly"] = 124.69, ["Ride"] = 95.82, ["Neon"] = 177.19, ["Neon|Ride"] = 221.82, ["Neon|Fly|Ride"] = 330.74, ["Mega"] = 590.63, ["Mega|Ride"] = 519.75, ["Mega|Fly|Ride"] = 648.17}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Ride"] = 23.08, ["Fly|Ride"] = 58.74, ["Neon"] = 2.63, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 23.08, ["Neon|Fly|Ride"] = 46.16, ["Mega"] = 18.38, ["Mega|Ride"] = 55.13, ["Mega|Fly|Ride"] = 87.15}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 140.55, ["Neon|Fly|Ride"] = 140.55, ["Mega"] = 26.17, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 10.76, ["Neon|Ride"] = 56.48, ["Neon|Fly|Ride"] = 192.94, ["Mega"] = 120.75, ["Mega|Ride"] = 155.67, ["Mega|Fly|Ride"] = 307.13}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 7.86, ["Fly"] = 81.81, ["Ride"] = 53.38, ["Fly|Ride"] = 161.64, ["Neon"] = 26.92, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 83.92, ["Neon|Fly|Ride"] = 155.69, ["Mega"] = 171.97, ["Mega|Ride"] = 185.06, ["Mega|Fly|Ride"] = 295.74}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 18.88, ["Fly|Ride"] = 36.03, ["Neon"] = 2.1, ["Neon|Fly"] = 23.08, ["Neon|Ride"] = 31.38, ["Neon|Fly|Ride"] = 74.82, ["Mega"] = 22.1, ["Mega|Ride"] = 31.38, ["Mega|Fly|Ride"] = 147}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 13.71, ["Ride"] = 42, ["Fly|Ride"] = 104.89, ["Neon"] = 60.85, ["Neon|Fly|Ride"] = 189.67, ["Mega|Ride"] = 419.53}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 3018.75, ["Ride"] = 3543.75, ["Fly|Ride"] = 3346.88, ["Neon|Fly|Ride"] = 9509.4}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 52.49, ["Ride"] = 23.04, ["Fly|Ride"] = 60.84, ["Neon"] = 14.44, ["Neon|Fly"] = 68.43, ["Neon|Ride"] = 25.47, ["Neon|Fly|Ride"] = 62.95, ["Mega"] = 102.79, ["Mega|Ride"] = 94.75, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.1, ["Neon"] = 22.42, ["Mega"] = 126, ["Mega|Ride"] = 419.53, ["Mega|Fly|Ride"] = 314.65}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 23.26, ["Ride"] = 31.49, ["Fly|Ride"] = 157.5, ["Neon"] = 93.66, ["Neon|Ride"] = 78.68, ["Neon|Fly|Ride"] = 140.55, ["Mega"] = 419.53, ["Mega|Ride"] = 497.18, ["Mega|Fly|Ride"] = 699.57}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 45.94, ["Ride"] = 78.75, ["Fly|Ride"] = 140.54, ["Neon"] = 92.96, ["Mega"] = 1258.57, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 629.29}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 131.25, ["Fly"] = 1398.93, ["Ride"] = 172.07, ["Fly|Ride"] = 251.77, ["Neon"] = 748.13, ["Neon|Ride"] = 672, ["Neon|Fly|Ride"] = 800.63, ["Mega"] = 6292.76, ["Mega|Ride"] = 3006.9, ["Mega|Fly|Ride"] = 3543.75}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 5.94, ["Ride"] = 39.38, ["Fly|Ride"] = 112.22, ["Neon"] = 27.48, ["Neon|Ride"] = 139.42, ["Neon|Fly|Ride"] = 140.55, ["Mega"] = 278.25, ["Mega|Fly|Ride"] = 253.32}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 27.27, ["Neon"] = 20.98, ["Neon|Fly"] = 96.5, ["Neon|Ride"] = 37.77, ["Mega"] = 90.57, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 825.57}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 3.31, ["Fly"] = 101.99, ["Ride"] = 70.27, ["Fly|Ride"] = 118.13, ["Neon"] = 7.87, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 251.72, ["Mega"] = 72.32, ["Mega|Ride"] = 142.65, ["Mega|Fly|Ride"] = 287.44}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 15.68, ["Neon"] = 115.03, ["Neon|Ride"] = 209.77, ["Mega"] = 393.75, ["Mega|Ride"] = 464.75, ["Mega|Fly|Ride"] = 350.32}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 70.27, ["Neon"] = 2.1, ["Mega"] = 15.75, ["Mega|Ride"] = 133.88, ["Mega|Fly|Ride"] = 152.21}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 91.88, ["Fly"] = 435.22, ["Ride"] = 116.41, ["Fly|Ride"] = 155.23, ["Neon"] = 464.75, ["Neon|Ride"] = 462.42, ["Neon|Fly|Ride"] = 459.39, ["Mega|Ride"] = 1678.08, ["Mega|Fly|Ride"] = 2014.6}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 32.52, ["Neon"] = 10.31, ["Mega|Ride"] = 112.88}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 43.2, ["Fly"] = 217.25, ["Ride"] = 92.95, ["Fly|Ride"] = 179.33, ["Neon"] = 271.71, ["Neon|Ride"] = 390.12, ["Neon|Fly|Ride"] = 419.43, ["Mega"] = 2625, ["Mega|Ride"] = 2797.15, ["Mega|Fly|Ride"] = 1258.72}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 52.5, ["Fly|Ride"] = 70.28, ["Neon"] = 3.93, ["Neon|Ride"] = 35.68, ["Neon|Fly|Ride"] = 86.89, ["Mega"] = 52.5, ["Mega|Ride"] = 65.62, ["Mega|Fly|Ride"] = 211.98}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.63, ["Ride"] = 26.23, ["Neon"] = 12.46, ["Mega"] = 105, ["Mega|Ride"] = 138.46, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 13.07, ["Ride"] = 35.6, ["Neon"] = 62.75, ["Neon|Fly"] = 291.38, ["Neon|Ride"] = 131.25, ["Mega"] = 178.31, ["Mega|Ride"] = 262.22, ["Mega|Fly|Ride"] = 623.44}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 420.13, ["Ride"] = 446.24, ["Fly|Ride"] = 630, ["Neon"] = 1179.94, ["Neon|Ride"] = 1128.75, ["Neon|Fly|Ride"] = 1258.69, ["Mega"] = 3355.1, ["Mega|Ride"] = 3219.57, ["Mega|Fly|Ride"] = 3412.78}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 39.37, ["Ride"] = 69.57, ["Fly|Ride"] = 78.75, ["Neon"] = 181.12, ["Neon|Fly"] = 310.22, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 282.07, ["Mega"] = 799.19, ["Mega|Fly|Ride"] = 905.63}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 34.13, ["Ride"] = 32.82, ["Fly|Ride"] = 91.88, ["Neon"] = 7.23, ["Neon|Fly"] = 136.36, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 67.13, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 232.38}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 13.1, ["Fly"] = 70.3, ["Ride"] = 40.93, ["Fly|Ride"] = 91.88, ["Neon"] = 41.99, ["Neon|Fly"] = 124.34, ["Neon|Ride"] = 82.93, ["Neon|Fly|Ride"] = 309.75, ["Mega"] = 210.42, ["Mega|Fly"] = 375.48, ["Mega|Ride"] = 245.43, ["Mega|Fly|Ride"] = 383.24}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 7.5, ["Ride"] = 39.38, ["Fly|Ride"] = 70.62, ["Neon"] = 105, ["Neon|Ride"] = 68.25, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 448.9, ["Mega|Ride"] = 448.9, ["Mega|Fly|Ride"] = 510.78}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 9.76, ["Neon"] = 20.98, ["Mega"] = 52.5, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 185.91}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.1, ["Fly"] = 86.63, ["Ride"] = 19.69, ["Fly|Ride"] = 59.05, ["Neon"] = 26.24, ["Neon|Ride"] = 3216.66, ["Neon|Fly|Ride"] = 280.04, ["Mega"] = 542.59, ["Mega|Ride"] = 486.94}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 97.26, ["Fly"] = 161.52, ["Ride"] = 118.13, ["Fly|Ride"] = 236.25, ["Neon"] = 565.31, ["Neon|Ride"] = 545.39, ["Neon|Fly|Ride"] = 766.68, ["Mega|Ride"] = 2545.44, ["Mega|Fly|Ride"] = 2323.63}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 26.24, ["Ride"] = 78.75, ["Fly|Ride"] = 144, ["Neon"] = 155.24, ["Neon|Ride"] = 280.04, ["Mega"] = 697.1, ["Mega|Ride"] = 670.2, ["Mega|Fly|Ride"] = 699.57}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2552.82, ["Ride"] = 2598.75, ["Fly|Ride"] = 2756.25, ["Neon"] = 12585.5, ["Neon|Fly|Ride"] = 8706.63, ["Mega|Fly|Ride"] = 23236.24}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 5.24, ["Fly"] = 65625, ["Ride"] = 22.1, ["Fly|Ride"] = 170.63, ["Neon"] = 6.57, ["Neon|Ride"] = 41.97, ["Mega"] = 62.94, ["Mega|Ride"] = 169.32}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 8.8, ["Neon"] = 51.18, ["Neon|Ride"] = 280.04, ["Neon|Fly|Ride"] = 350.32, ["Mega"] = 131.25, ["Mega|Ride"] = 270.6, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 997.5, ["Ride"] = 1023.75, ["Fly|Ride"] = 1141.88, ["Neon"] = 4037.86, ["Neon|Ride"] = 4038.9, ["Neon|Fly|Ride"] = 3543.75, ["Mega|Ride"] = 14683.09, ["Mega|Fly|Ride"] = 13518.74}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 47.2, ["Fly|Ride"] = 262.5, ["Neon"] = 258.02, ["Mega|Ride"] = 1394.18, ["Mega|Fly|Ride"] = 752.07}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 3.93, ["Ride"] = 46.16, ["Neon"] = 19.67, ["Neon|Ride"] = 62.75, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 190.98, ["Mega|Ride"] = 347.17, ["Mega|Fly|Ride"] = 274.98}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 111.19, ["Neon"] = 3.93, ["Neon|Ride"] = 52.49, ["Mega"] = 31.49, ["Mega|Ride"] = 68.25, ["Mega|Fly|Ride"] = 125.87}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 87.94, ["Ride"] = 278.96, ["Neon"] = 699.57, ["Neon|Ride"] = 406.04, ["Mega"] = 5250, ["Mega|Fly|Ride"] = 2517.12}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 6.56, ["Ride"] = 157.5, ["Neon"] = 35.66, ["Neon|Ride"] = 103.84, ["Mega"] = 96.5, ["Mega|Ride"] = 155.69, ["Mega|Fly|Ride"] = 417.43}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 133.2, ["Ride"] = 140.54, ["Neon"] = 620.42, ["Neon|Ride"] = 525, ["Mega"] = 2097.59, ["Mega|Fly|Ride"] = 1810.24}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 6.97, ["Fly"] = 105, ["Neon"] = 19.94, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 315, ["Mega"] = 224.44}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 261.19, ["Ride"] = 321.57, ["Fly|Ride"] = 360.94, ["Neon"] = 1766.63, ["Neon|Ride"] = 950.21, ["Neon|Fly|Ride"] = 1023.75, ["Mega|Fly|Ride"] = 4010.58}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 3.91, ["Fly"] = 70.27, ["Ride"] = 23.62, ["Fly|Ride"] = 83.91, ["Neon"] = 34.13, ["Neon|Ride"] = 56.65, ["Neon|Fly|Ride"] = 146.84, ["Mega"] = 250.04, ["Mega|Ride"] = 310.22, ["Mega|Fly|Ride"] = 350.44}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 26.73, ["Ride"] = 15.89, ["Fly|Ride"] = 43.63, ["Neon"] = 4.17, ["Neon|Fly"] = 39.14, ["Neon|Ride"] = 19.67, ["Neon|Fly|Ride"] = 46.55, ["Mega"] = 45.11, ["Mega|Ride"] = 43.32, ["Mega|Fly|Ride"] = 99.65}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 787.5, ["Fly"] = 1105.31, ["Ride"] = 903, ["Fly|Ride"] = 984.35, ["Neon|Fly|Ride"] = 3669.73, ["Mega"] = 29366.16, ["Mega|Fly|Ride"] = 27968.12}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 9.18, ["Fly"] = 980.19, ["Ride"] = 210, ["Neon"] = 48.25, ["Neon|Ride"] = 69.84, ["Mega"] = 116.2, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 291.38}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 7.87, ["Fly"] = 41.96, ["Ride"] = 39.51, ["Fly|Ride"] = 91.26, ["Neon"] = 26.73, ["Neon|Fly"] = 76.7, ["Neon|Ride"] = 62.94, ["Neon|Fly|Ride"] = 280.04, ["Mega"] = 182.53, ["Mega|Ride"] = 196.87, ["Mega|Fly|Ride"] = 461.05}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 32.82, ["Fly"] = 32.82, ["Ride"] = 33.57, ["Fly|Ride"] = 83.91, ["Neon|Ride"] = 176.21, ["Neon|Fly|Ride"] = 202, ["Mega"] = 2097.59, ["Mega|Fly|Ride"] = 885.94}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 17.84, ["Fly"] = 78.67, ["Ride"] = 37.19, ["Fly|Ride"] = 101.09, ["Neon"] = 72.19, ["Neon|Ride"] = 82.89, ["Neon|Fly|Ride"] = 185.91, ["Mega"] = 560.07, ["Mega|Ride"] = 303.19, ["Mega|Fly|Ride"] = 442.31}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 24.07, ["Ride"] = 62.75, ["Fly|Ride"] = 636.57, ["Neon"] = 86.63, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 435.26, ["Mega|Ride"] = 494, ["Mega|Fly|Ride"] = 453.09}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 116.59, ["Neon"] = 2.63, ["Neon|Ride"] = 91.81, ["Mega"] = 24.14, ["Mega|Ride"] = 89.25}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 33.66, ["Fly"] = 56.64, ["Ride"] = 46.83, ["Fly|Ride"] = 77.44, ["Neon"] = 269.58, ["Neon|Fly"] = 310.21, ["Neon|Ride"] = 232.32, ["Neon|Fly|Ride"] = 338.78, ["Mega"] = 3356.15, ["Mega|Fly|Ride"] = 1059.29}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.1, ["Fly"] = 133.54, ["Ride"] = 27.55, ["Fly|Ride"] = 127.32, ["Neon"] = 15.74, ["Neon|Ride"] = 141.07, ["Mega"] = 41.97, ["Mega|Ride"] = 271.69, ["Mega|Fly|Ride"] = 671.25}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 25.18, ["Ride"] = 18.38, ["Fly|Ride"] = 70.27, ["Neon"] = 39.38, ["Neon|Fly|Ride"] = 109.23, ["Mega"] = 1036.23, ["Mega|Ride"] = 275.85, ["Mega|Fly|Ride"] = 202.13}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 4.66, ["Neon"] = 14.43, ["Neon|Fly|Ride"] = 104.89, ["Mega"] = 196.88, ["Mega|Ride"] = 196.88}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 26.02, ["Fly"] = 262.5, ["Ride"] = 41.96, ["Fly|Ride"] = 78.75, ["Neon"] = 116.79, ["Neon|Ride"] = 109.1, ["Neon|Fly|Ride"] = 280.04, ["Mega"] = 1119.07, ["Mega|Ride"] = 735, ["Mega|Fly|Ride"] = 769.82}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 7.88, ["Neon"] = 23.55, ["Neon|Ride"] = 62.93, ["Mega"] = 104.78, ["Mega|Fly|Ride"] = 310.22}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 27.28, ["Neon"] = 2.63, ["Neon|Ride"] = 91.88, ["Mega"] = 27.27, ["Mega|Ride"] = 41.97, ["Mega|Fly|Ride"] = 200.17}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Ride"] = 26.13, ["Neon"] = 2.1, ["Neon|Fly"] = 393.65, ["Neon|Ride"] = 33.57, ["Mega"] = 21, ["Mega|Fly"] = 73.86, ["Mega|Ride"] = 112.24, ["Mega|Fly|Ride"] = 140.44}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 31.49, ["Ride"] = 23.63, ["Fly|Ride"] = 40.05, ["Neon"] = 10.47, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 28.33, ["Neon|Fly|Ride"] = 140.55, ["Mega"] = 86.63, ["Mega|Ride"] = 132.16, ["Mega|Fly|Ride"] = 246.1}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.24, ["Ride"] = 26.25, ["Fly|Ride"] = 5228.18, ["Neon"] = 20.99, ["Neon|Ride"] = 1312.5, ["Mega"] = 140.55, ["Mega|Ride"] = 146.88}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 39.77, ["Ride"] = 16.95, ["Fly|Ride"] = 39.87, ["Neon"] = 18.6, ["Neon|Ride"] = 23.25, ["Neon|Fly|Ride"] = 80.07, ["Mega"] = 223.13, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 363.56}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 71.29, ["Fly|Ride"] = 392.26, ["Neon|Ride"] = 248.07, ["Neon|Fly|Ride"] = 1048.81, ["Mega"] = 954.41, ["Mega|Ride"] = 1049.99, ["Mega|Fly|Ride"] = 941.83}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 26.23, ["Ride"] = 16.75, ["Fly|Ride"] = 37.19, ["Neon"] = 2.1, ["Neon|Fly"] = 27.2, ["Neon|Ride"] = 25.18, ["Neon|Fly|Ride"] = 66.94, ["Mega"] = 39.37, ["Mega|Ride"] = 31.38, ["Mega|Fly|Ride"] = 136.14}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 10.5, ["Fly"] = 32.47, ["Ride"] = 34.23, ["Fly|Ride"] = 77.86, ["Neon"] = 40.69, ["Neon|Ride"] = 56.07, ["Neon|Fly|Ride"] = 150.94, ["Mega"] = 525, ["Mega|Ride"] = 288.15, ["Mega|Fly|Ride"] = 417.43}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 15.74, ["Fly"] = 56.65, ["Ride"] = 27.57, ["Fly|Ride"] = 81.41, ["Neon"] = 92.96, ["Neon|Ride"] = 96.76, ["Neon|Fly|Ride"] = 112.24, ["Mega"] = 839.05, ["Mega|Ride"] = 552.74, ["Mega|Fly|Ride"] = 419.53}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 3.93, ["Fly"] = 140.38, ["Ride"] = 46.4, ["Neon"] = 38.53, ["Mega"] = 280.04, ["Mega|Ride"] = 241.5, ["Mega|Fly|Ride"] = 280.04}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Ride"] = 17.36, ["Neon"] = 3.92, ["Neon|Fly"] = 81.38, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 109.23, ["Mega"] = 41.97, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 61.57, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 3.86, ["Ride"] = 28.32, ["Neon"] = 15.67, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 99.64, ["Mega"] = 109.1, ["Mega|Fly"] = 735, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 381.77}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 1048.68, ["Ride"] = 1049.99, ["Fly|Ride"] = 1101.19, ["Neon"] = 2718.12, ["Neon|Ride"] = 3043.97, ["Neon|Fly|Ride"] = 2273.25, ["Mega|Fly|Ride"] = 7434}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 55.13, ["Ride"] = 112.22, ["Fly|Ride"] = 131.25, ["Neon"] = 210, ["Neon|Ride"] = 266.41, ["Neon|Fly|Ride"] = 487.97, ["Mega"] = 2812.69, ["Mega|Ride"] = 1258.57, ["Mega|Fly|Ride"] = 1177.52}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Fly"] = 62.93, ["Neon"] = 4.66, ["Neon|Ride"] = 74.48, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 52.5, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 145.81}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 39.9, ["Ride"] = 59.07, ["Fly|Ride"] = 262.5, ["Neon"] = 250.69, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 300.57, ["Mega"] = 1216.43, ["Mega|Ride"] = 759.94, ["Mega|Fly|Ride"] = 1132.7}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 6.03, ["Ride"] = 36.71, ["Neon"] = 60.38, ["Neon|Ride"] = 131.25, ["Mega"] = 434.53, ["Mega|Ride"] = 232.38, ["Mega|Fly|Ride"] = 1048.81}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 335.58, ["Fly"] = 929.35, ["Ride"] = 409.15, ["Fly|Ride"] = 664.57, ["Neon"] = 1236.54, ["Neon|Ride"] = 1050, ["Neon|Fly|Ride"] = 1119.07, ["Mega|Fly|Ride"] = 6175.76}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.59, ["Fly"] = 102.38, ["Ride"] = 22.32, ["Fly|Ride"] = 114.19, ["Neon"] = 11.82, ["Neon|Ride"] = 73.5, ["Mega"] = 393.75}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Neon"] = 83.92, ["Neon|Ride"] = 140.55}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 28.88, ["Ride"] = 78.75, ["Neon"] = 155.69, ["Neon|Ride"] = 309.41, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 699.57, ["Mega|Ride"] = 713.35, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 3.92, ["Ride"] = 70.86, ["Fly|Ride"] = 140.54, ["Neon"] = 15.74, ["Mega"] = 222.36, ["Mega|Ride"] = 260.12, ["Mega|Fly|Ride"] = 419.53}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 23.63, ["Ride"] = 14.8, ["Fly|Ride"] = 32.82, ["Neon"] = 3.89, ["Neon|Fly"] = 31.38, ["Neon|Ride"] = 22.92, ["Neon|Fly|Ride"] = 42, ["Mega"] = 39.86, ["Mega|Ride"] = 40.69, ["Mega|Fly|Ride"] = 93.19}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 5258.66, ["Ride"] = 4315.5, ["Fly|Ride"] = 3281.25, ["Neon"] = 25171, ["Neon|Fly|Ride"] = 25870.55, ["Mega|Fly|Ride"] = 78449.58}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 12.47, ["Ride"] = 56.44, ["Neon"] = 140.55, ["Neon|Ride"] = 85.32, ["Mega"] = 262.5, ["Mega|Ride"] = 392.26, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Ride"] = 23.25, ["Fly|Ride"] = 57.75, ["Neon"] = 13.13, ["Neon|Fly"] = 46.49, ["Neon|Ride"] = 35.68, ["Neon|Fly|Ride"] = 137.11, ["Mega"] = 155.69, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 309.67}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 418.69, ["Fly"] = 840, ["Ride"] = 472.5, ["Fly|Ride"] = 551.25, ["Neon"] = 1678.08, ["Neon|Ride"] = 1538.59, ["Neon|Fly|Ride"] = 1200.61, ["Mega|Fly|Ride"] = 5978.13}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 3.94, ["Ride"] = 62.93, ["Neon"] = 20.98, ["Neon|Ride"] = 291.38, ["Mega"] = 144.38, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 685.93}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 4.19, ["Fly"] = 99.75, ["Ride"] = 77.84, ["Neon"] = 140.55, ["Neon|Ride"] = 280.04, ["Neon|Fly|Ride"] = 13984.6, ["Mega"] = 280.04, ["Mega|Ride"] = 275.63}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 60.38, ["Ride"] = 23.63, ["Neon"] = 5.25, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 33.71, ["Mega"] = 42, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 240.33}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 616.88, ["Ride"] = 620.34, ["Fly|Ride"] = 761.25, ["Neon"] = 2447.89, ["Neon|Ride"] = 2100, ["Neon|Fly|Ride"] = 2215.06, ["Mega|Fly|Ride"] = 8751.75}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 7.28, ["Ride"] = 65.37, ["Neon"] = 22.32, ["Neon|Fly"] = 92.96, ["Neon|Ride"] = 91.26, ["Neon|Fly|Ride"] = 228.65, ["Mega"] = 140.89, ["Mega|Ride"] = 251.72, ["Mega|Fly|Ride"] = 348.6}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 10.5, ["Fly"] = 167.81, ["Ride"] = 59.27, ["Fly|Ride"] = 182.52, ["Neon"] = 36.75, ["Neon|Ride"] = 109.23, ["Neon|Fly|Ride"] = 3874.66, ["Mega"] = 242.81, ["Mega|Ride"] = 227.67, ["Mega|Fly|Ride"] = 348.55}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 40.68, ["Ride"] = 20.98, ["Fly|Ride"] = 51.19, ["Neon"] = 13.13, ["Neon|Ride"] = 31.38, ["Neon|Fly|Ride"] = 86.63, ["Mega"] = 129.94, ["Mega|Ride"] = 158.82, ["Mega|Fly|Ride"] = 266.44}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 22.94, ["Ride"] = 62.75, ["Fly|Ride"] = 116.2, ["Neon"] = 106.95, ["Neon|Ride"] = 139.42, ["Mega"] = 531.76, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 525.87}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Ride"] = 39.37, ["Neon"] = 3.94, ["Neon|Ride"] = 56.65, ["Neon|Fly|Ride"] = 2033.18, ["Mega"] = 28.33, ["Mega|Ride"] = 104.57, ["Mega|Fly|Ride"] = 166.16}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 523.69, ["Ride"] = 461.34, ["Fly|Ride"] = 558.05, ["Neon"] = 2071.38, ["Neon|Ride"] = 2078.72, ["Neon|Fly|Ride"] = 2056.69, ["Mega|Fly|Ride"] = 7848.75}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 69.22, ["Neon"] = 6.48, ["Neon|Ride"] = 83.98, ["Neon|Fly|Ride"] = 209.77, ["Mega"] = 40.69, ["Mega|Ride"] = 119.6, ["Mega|Fly|Ride"] = 328.91}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 39.86, ["Neon"] = 3.93, ["Neon|Fly"] = 140.55, ["Neon|Ride"] = 171.97, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 35.59, ["Mega|Ride"] = 82.87, ["Mega|Fly|Ride"] = 263.26}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Neon"] = 3.92, ["Neon|Ride"] = 45.92, ["Mega"] = 32.82, ["Mega|Ride"] = 77.84, ["Mega|Fly|Ride"] = 204.52}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.1, ["Ride"] = 124.69, ["Neon"] = 20.99, ["Mega"] = 224.46, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 36.71, ["Fly"] = 36.03, ["Ride"] = 62.93, ["Fly|Ride"] = 156.19, ["Neon"] = 185.91, ["Neon|Ride"] = 209.77, ["Neon|Fly|Ride"] = 465.29, ["Mega"] = 497.44, ["Mega|Ride"] = 524.98, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 23.25, ["Ride"] = 82.69, ["Fly|Ride"] = 276.94, ["Neon"] = 81.03, ["Neon|Ride"] = 112.24, ["Neon|Fly|Ride"] = 280.04, ["Mega"] = 476.11, ["Mega|Ride"] = 524.42, ["Mega|Fly|Ride"] = 488.24}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 18.52, ["Fly|Ride"] = 46.49, ["Neon"] = 31.47, ["Neon|Ride"] = 35.07, ["Neon|Fly|Ride"] = 82.69, ["Mega"] = 307.79, ["Mega|Ride"] = 206.07, ["Mega|Fly|Ride"] = 238.88}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 12.6, ["Ride"] = 39.38, ["Neon"] = 280.04, ["Neon|Ride"] = 158.82, ["Neon|Fly|Ride"] = 210, ["Mega"] = 459.38, ["Mega|Fly|Ride"] = 520.22}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 28.33, ["Fly|Ride"] = 362.25, ["Neon"] = 7.87, ["Neon|Ride"] = 41.55, ["Mega"] = 82.69, ["Mega|Ride"] = 146.84, ["Mega|Fly|Ride"] = 209.77}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 27.27, ["Ride"] = 31.49, ["Fly|Ride"] = 69.71, ["Neon"] = 209.77, ["Neon|Ride"] = 83.92, ["Neon|Fly|Ride"] = 224.48, ["Mega"] = 942.87, ["Mega|Ride"] = 929.48, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 96.43, ["Fly"] = 874.13, ["Neon"] = 310.22, ["Neon|Ride"] = 328.13, ["Mega|Ride"] = 590.63}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 49.87, ["Fly"] = 115.5, ["Ride"] = 78.73, ["Fly|Ride"] = 524.42, ["Neon"] = 464.75, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 405.9, ["Mega|Ride"] = 1642.81, ["Mega|Fly|Ride"] = 1316.44}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 50.93, ["Fly"] = 126.1, ["Ride"] = 105, ["Neon"] = 185.91, ["Neon|Ride"] = 99.93, ["Neon|Fly|Ride"] = 281.09, ["Mega"] = 564.64, ["Mega|Ride"] = 960.42, ["Mega|Fly|Ride"] = 938.68}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 25.7, ["Ride"] = 34.13, ["Neon"] = 415.34, ["Neon|Ride"] = 223.13, ["Mega"] = 556.92, ["Mega|Ride"] = 797.09, ["Mega|Fly|Ride"] = 1258.57}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 5.94, ["Fly"] = 52.5, ["Ride"] = 32.52, ["Fly|Ride"] = 85.32, ["Neon"] = 47.38, ["Neon|Fly"] = 167.83, ["Neon|Ride"] = 98.6, ["Neon|Fly|Ride"] = 118.44, ["Mega"] = 489.8, ["Mega|Ride"] = 345.18, ["Mega|Fly|Ride"] = 414.29}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 28.32, ["Ride"] = 16.7, ["Fly|Ride"] = 41.55, ["Neon"] = 3.92, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 21.1, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 40.69, ["Mega|Ride"] = 86.02, ["Mega|Fly|Ride"] = 186.38}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 917.44}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 36.74, ["Ride"] = 124.8, ["Fly|Ride"] = 262.5, ["Neon"] = 123.78, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 419.53, ["Mega"] = 560.07, ["Mega|Ride"] = 573.7, ["Mega|Fly|Ride"] = 699.57}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 56.64, ["Neon"] = 3.89, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 293.67, ["Mega"] = 35.44, ["Mega|Ride"] = 75.8, ["Mega|Fly|Ride"] = 217.88}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 31.39, ["Neon"] = 169.32, ["Neon|Ride"] = 350.32, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 711.38, ["Mega|Ride"] = 733.11, ["Mega|Fly|Ride"] = 590.62}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Mega"] = 23.08}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 3.89, ["Neon|Ride"] = 87.15, ["Mega"] = 26.25, ["Mega|Ride"] = 83.92, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 209.75, ["Ride"] = 150.57, ["Fly|Ride"] = 196.12, ["Neon"] = 597.16, ["Neon|Ride"] = 590.63, ["Neon|Fly|Ride"] = 767.72, ["Mega|Ride"] = 6389.98, ["Mega|Fly|Ride"] = 2034.37}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 26.25, ["Fly|Ride"] = 88.11, ["Neon"] = 11.42, ["Neon|Fly"] = 62.94, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 155.24, ["Mega"] = 91.87, ["Mega|Ride"] = 123.38, ["Mega|Fly|Ride"] = 419.53}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 48.25, ["Fly|Ride"] = 86.63, ["Neon"] = 8.39, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 419.99, ["Mega"] = 43.32, ["Mega|Fly"] = 41.97, ["Mega|Ride"] = 102.83}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 83.91, ["Neon"] = 3.93, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 35.44, ["Mega"] = 20.99, ["Mega|Ride"] = 74.82, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 91.88, ["Neon"] = 4.2, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 140.55, ["Mega"] = 40.91, ["Mega|Ride"] = 94.5, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 39.38, ["Ride"] = 86.63, ["Fly|Ride"] = 620.42, ["Neon"] = 336.99, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 976.44, ["Mega|Ride"] = 1048.81, ["Mega|Fly|Ride"] = 1258.57}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 2.61, ["Ride"] = 139.47, ["Neon"] = 22.32, ["Neon|Ride"] = 111.57, ["Mega"] = 140.59, ["Mega|Ride"] = 547.98, ["Mega|Fly|Ride"] = 417.43}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 347.82, ["Ride"] = 367.5, ["Fly|Ride"] = 441.45, ["Neon"] = 2936.62, ["Neon|Ride"] = 1086.57, ["Neon|Fly|Ride"] = 1048.81, ["Mega|Fly|Ride"] = 3150}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 67.2}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 39.38}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 13.17}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 24.13}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 34.13}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 53.5}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 10.4}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 7.83}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 213.94}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 22.3}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 42}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 9}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 7.08}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 256.92}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 7.19}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 7.07}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 10.48}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 23.02}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 465.94}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 734.08}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 19.69}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1111.69}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 525}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 14.44}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 14.3}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.23}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 19.47}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 116.94}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 51.16}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 17.09}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 20.98}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 18.27}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 10.49}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 11.82}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.63}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 28.04}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 14.26}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 6.46}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 8.25}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 1575}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 116.7}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 301.87}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 12.78}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 12.5}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 40.43}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 23.23}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 153.56}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 10.4}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 12.44}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 177.06}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 31.13}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 6.57}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.63}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 26.24}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 8.33}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 6.3}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 110.25}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 18.06}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 10.48}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 3.82}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 23.25}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.43}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 7.87}},
    ["rbxassetid://1265129203"] = {name = "Ice Snowboard", prices = {["default"] = 215.69}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 2.1}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 20.79}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 112.22}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 118.13}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.59}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 9.19}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 19.09}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 27.56}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 57.74}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 52.45}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 131.25}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 32.82}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 45.41}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 34.23}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 272.66}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 25.77}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 35.17}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 74.8}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 155.68}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 49.12}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 39.38}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 28.88}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 40.68}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 350.83}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 7.46}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 14.21}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 3.6}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 6.14}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 24.55}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 36.11}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.57}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 5.23}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.63}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 3.94}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 4.65}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 7.86}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 8.54}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 669.38}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 26.25}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 4.22}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.63}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 375.43}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.61}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 280.01}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 37.65}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 32.82}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 132.57}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 30.19}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 5.1}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 12.66}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 3.93}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 3.93}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 3.91}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 40.53}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 3.82}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 3.87}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 4.92}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 9.18}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 137.79}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 65.63}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.51}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.1}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 967.93}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 10.39}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 9.4}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 7.07}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 18.38}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 23.62}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 14.18}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 4.65}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 14.6}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 18.15}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 161.52}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 46.91}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 5.91}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 5.91}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 8.39}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 5.85}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 3.51}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 5.25}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 45.94}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.6}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.24}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 4.41}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 3.96}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.61}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 8074.71}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 19.83}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 2.57}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 9.3}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 31.86}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 10.42}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 4.22}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 3.68}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 4.59}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 14.42}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 118.13}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.26}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 15.38}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 9.31}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 5.77}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 5.24}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 5.9}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 3.72}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 3.44}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4338.86}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 4.54}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.61}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 49.09}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.63}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 6.22}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 81.38}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 4.19}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 2.61}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 182.28}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.63}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 3.94}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 4.11}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.63}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 6.57}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 24.67}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 28.86}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 3.89}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.63}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.46}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.5}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 46.49}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 6.46}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 4.19}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 8.4}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 4.76}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.61}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 3.76}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 5.25}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 6.57}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 6.99}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 3.75}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 28.62}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.63}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 6.17}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 17}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 131.25}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 2.13}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 36.75}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 6.2}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1118.94}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 24.93}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 3.94}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 4.15}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.37}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 22.2}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 6.32}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 3.89}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 5.25}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 15.74}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 3.4}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 27.01}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 21.81}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 39.38}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 4.72}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 3.72}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 13.47}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 12.5}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 5.75}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 4.72}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 92.19}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.63}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.37}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 40.27}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.63}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 11.39}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 2.1}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 25.68}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 24.02}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 3.82}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 3.93}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 98.44}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 4.19}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 27.15}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 5.13}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.63}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 3.94}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 5.18}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 5.92}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 7.41}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 86.63}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 6.32}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.5}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 105}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 9.19}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1502.82}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 4.2}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 213.7}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 6.32}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.63}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 18.88}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 37.68}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 3.92}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 4.2}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 65.63}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 8.6}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 3.93}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 3.62}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.61}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 3.89}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 90.2}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 64.3}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 8.91}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 55.13}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 5.25}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 2.18}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 4.19}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 41.99}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 118.52}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 3.66}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 2.84}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.56}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 59.07}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 6.12}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 3.93}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.63}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 5.25}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 64.29}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 45.83}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 86.63}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 371.75}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 3.1}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 59.79}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.63}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 104.88}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 4.98}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 20.98}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 83.91}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 3.91}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 23.63}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 404.22}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 11.54}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 26.25}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.37}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 23.15}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 3.82}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 4.22}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 62.73}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.21}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 39.87}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 65.63}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 3.93}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 2.6}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 40.61}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 5.6}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 6.32}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 52.39}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 71.32}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 62.95}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1384.25}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 30.01}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 5.76}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 53.5}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 249.25}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 28.25}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 12.05}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 12.36}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 12.58}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 4.65}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 208.68}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 49.87}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 5.16}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 61.85}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 279.03}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 91.76}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 892.5}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 170.63}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 9.18}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 1117.89}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 525}},
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