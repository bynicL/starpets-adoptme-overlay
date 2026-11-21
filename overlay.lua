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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 1011.94, ["Fly"] = 1119.35, ["Ride"] = 901.06, ["Fly|Ride"] = 1025.07, ["Neon|Ride"] = 4476.3, ["Neon|Fly|Ride"] = 3846.88}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 513.59, ["Fly"] = 535.03, ["Ride"] = 512.5, ["Fly|Ride"] = 627.34, ["Neon|Fly|Ride"] = 3099.32, ["Mega|Fly|Ride"] = 8373.53}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 6294.29, ["Ride"] = 4790.63, ["Fly|Ride"] = 4390.32, ["Neon"] = 25876.86, ["Neon|Fly|Ride"] = 19774.55, ["Mega|Fly|Ride"] = 62935.15}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 131.25, ["Ride"] = 182.55, ["Fly|Ride"] = 280.11, ["Neon"] = 1189.63, ["Neon|Ride"] = 821.63, ["Neon|Fly|Ride"] = 683.82, ["Mega"] = 3498.16, ["Mega|Fly|Ride"] = 3098.95}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 525, ["Ride"] = 602.09, ["Fly|Ride"] = 657.56, ["Neon|Fly|Ride"] = 1706.25, ["Mega|Fly|Ride"] = 8923.17}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 11.82, ["Ride"] = 46.5, ["Fly|Ride"] = 133.25, ["Neon"] = 35.7, ["Neon|Ride"] = 103.85, ["Neon|Fly|Ride"] = 310.3, ["Mega"] = 280.88, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 409.5}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 4.19, ["Fly"] = 37.78, ["Ride"] = 31.24, ["Fly|Ride"] = 77.64, ["Neon"] = 23.25, ["Neon|Fly"] = 64.32, ["Neon|Ride"] = 49.32, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 136.37, ["Mega|Fly"] = 303.19, ["Mega|Ride"] = 195.12, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 163.65, ["Ride"] = 202.21, ["Fly|Ride"] = 251.78, ["Neon"] = 602.43, ["Neon|Fly|Ride"] = 629.45, ["Mega"] = 1859.13, ["Mega|Ride"] = 1888.07, ["Mega|Fly|Ride"] = 1859.13}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 28.04, ["Fly"] = 65.63, ["Ride"] = 63, ["Fly|Ride"] = 120.64, ["Neon"] = 301.88, ["Neon|Ride"] = 180.45, ["Neon|Fly|Ride"] = 210, ["Mega"] = 2100, ["Mega|Ride"] = 783.56, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 27.57, ["Fly"] = 57.75, ["Ride"] = 39.38, ["Fly|Ride"] = 82.87, ["Neon"] = 280.11, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 131.25, ["Mega|Ride"] = 691.25, ["Mega|Fly|Ride"] = 620.49}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 56.44, ["Ride"] = 65.63, ["Fly|Ride"] = 161.6, ["Neon|Ride"] = 280.11, ["Neon|Fly|Ride"] = 258.57, ["Mega|Ride"] = 1068.86, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 74.82}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 379.32, ["Fly"] = 315, ["Ride"] = 367.5, ["Fly|Ride"] = 418.69, ["Neon"] = 1283.63, ["Neon|Fly|Ride"] = 1430.63, ["Mega|Fly|Ride"] = 4146.39}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 130.08, ["Fly"] = 146.88, ["Ride"] = 124.69, ["Fly|Ride"] = 157.39, ["Neon|Fly|Ride"] = 610.56, ["Mega|Fly|Ride"] = 2616.03}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 3.28, ["Fly"] = 31.49, ["Ride"] = 56.66, ["Fly|Ride"] = 91.28, ["Neon"] = 16.8, ["Neon|Fly"] = 61.9, ["Neon|Ride"] = 91.28, ["Mega"] = 124.84, ["Mega|Ride"] = 189, ["Mega|Fly|Ride"] = 384.62}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 140.58, ["Fly"] = 140.65, ["Ride"] = 134.16, ["Fly|Ride"] = 194.6, ["Neon"] = 615.81, ["Neon|Fly|Ride"] = 603.46, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.93, ["Fly"] = 27.02, ["Ride"] = 21.3, ["Fly|Ride"] = 45.94, ["Neon"] = 23.63, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 125.9, ["Mega"] = 787.5, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 43.32, ["Ride"] = 81.84, ["Fly|Ride"] = 148.98, ["Neon"] = 155.74, ["Neon|Ride"] = 209.83, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 818.18, ["Mega|Ride"] = 765.72, ["Mega|Fly|Ride"] = 755.42}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 65.63}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 49.65, ["Ride"] = 459.38, ["Neon"] = 301.09, ["Mega"] = 2936.99, ["Mega|Fly|Ride"] = 3098.95}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 14.96, ["Fly"] = 393.75, ["Ride"] = 32.02, ["Fly|Ride"] = 223.13, ["Neon"] = 140.44, ["Neon|Ride"] = 232.43, ["Neon|Fly|Ride"] = 203.44, ["Mega"] = 469.93, ["Mega|Ride"] = 589.13, ["Mega|Fly|Ride"] = 1678.29}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 45.94, ["Fly"] = 99.75, ["Ride"] = 56.65, ["Fly|Ride"] = 103.87, ["Neon"] = 386.06, ["Neon|Ride"] = 203.34, ["Neon|Fly|Ride"] = 258, ["Mega"] = 1681.32, ["Mega|Fly|Ride"] = 918.72}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 66.94, ["Ride"] = 67.16, ["Fly|Ride"] = 196.88, ["Neon"] = 208.68, ["Neon|Ride"] = 209.99, ["Neon|Fly|Ride"] = 405.57, ["Mega"] = 1101.38, ["Mega|Ride"] = 1254.51, ["Mega|Fly|Ride"] = 1240.88}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 23.51, ["Ride"] = 52.45, ["Fly|Ride"] = 137.17, ["Neon"] = 171.02, ["Neon|Ride"] = 217.32, ["Neon|Fly|Ride"] = 290.53, ["Mega"] = 1207.92, ["Mega|Ride"] = 2040.94, ["Mega|Fly|Ride"] = 958.73}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 42, ["Ride"] = 108.05, ["Fly|Ride"] = 131.25, ["Neon"] = 251.78, ["Neon|Ride"] = 251.9, ["Neon|Fly|Ride"] = 310.3, ["Mega|Ride"] = 2493.75, ["Mega|Fly|Ride"] = 938.79}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 4.19, ["Fly"] = 30.18, ["Ride"] = 23.63, ["Fly|Ride"] = 45.94, ["Neon"] = 19.67, ["Neon|Fly"] = 73.76, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 140.58, ["Mega|Fly"] = 28006.15, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 280.08, ["Ride"] = 236.25, ["Fly|Ride"] = 288.75, ["Neon"] = 1468.68, ["Neon|Ride"] = 1468.68, ["Neon|Fly|Ride"] = 1819.06, ["Mega"] = 10489.2, ["Mega|Fly|Ride"] = 5887.64}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 15.75, ["Ride"] = 33.59, ["Neon"] = 238.16, ["Neon|Ride"] = 209.83, ["Neon|Fly|Ride"] = 196.2, ["Mega"] = 825.51, ["Mega|Fly|Ride"] = 787.76}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 4.98, ["Fly"] = 37.94, ["Ride"] = 24.94, ["Fly|Ride"] = 48.57, ["Neon"] = 49.23, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 419.58, ["Mega|Ride"] = 560.14, ["Mega|Fly|Ride"] = 371.43}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 109.24, ["Fly"] = 137.15, ["Ride"] = 135.19, ["Fly|Ride"] = 209.83, ["Neon"] = 357, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 419.64, ["Mega"] = 6157.2, ["Mega|Ride"] = 7290.94, ["Mega|Fly|Ride"] = 1540.88}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 14, ["Ride"] = 26.25, ["Fly|Ride"] = 62.95, ["Neon"] = 77.88, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 207.38, ["Mega"] = 1575, ["Mega|Fly|Ride"] = 602.1}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 224.48, ["Fly"] = 297.51, ["Ride"] = 350.36, ["Fly|Ride"] = 350.4, ["Neon"] = 656.25, ["Neon|Ride"] = 597.19, ["Neon|Fly|Ride"] = 811.98, ["Mega"] = 6293.53, ["Mega|Fly|Ride"] = 2763.92}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 33.71}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.92, ["Fly"] = 31.42, ["Ride"] = 31.39, ["Fly|Ride"] = 67.16, ["Neon"] = 21, ["Neon|Fly"] = 5245.25, ["Neon|Ride"] = 51.19, ["Neon|Fly|Ride"] = 112.26, ["Mega"] = 118.13, ["Mega|Ride"] = 167.84, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 665.2, ["Ride"] = 735, ["Fly|Ride"] = 776.31, ["Neon"] = 3077.91, ["Neon|Ride"] = 3637.06, ["Neon|Fly|Ride"] = 2966.25, ["Mega"] = 11888.46, ["Mega|Ride"] = 52287.89, ["Mega|Fly|Ride"] = 9790.62}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 11.82, ["Fly"] = 39.38, ["Ride"] = 35.68, ["Fly|Ride"] = 91.28, ["Neon"] = 73.45, ["Neon|Ride"] = 139.85, ["Neon|Fly|Ride"] = 125.95, ["Mega"] = 787.5, ["Mega|Ride"] = 606.3, ["Mega|Fly|Ride"] = 661.89}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 114.19, ["Ride"] = 157.5, ["Fly|Ride"] = 234.23, ["Neon"] = 627.34, ["Neon|Ride"] = 514.5, ["Neon|Fly|Ride"] = 909.54, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 2642.24}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 60.19}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 31.5, ["Ride"] = 55.13, ["Fly|Ride"] = 196.88, ["Neon"] = 167.87, ["Neon|Ride"] = 250.73, ["Neon|Fly|Ride"] = 288.18, ["Mega"] = 653.49, ["Mega|Ride"] = 620.49, ["Mega|Fly|Ride"] = 775.04}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.37}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 178.92, ["Ride"] = 168, ["Neon|Ride"] = 590.63, ["Neon|Fly|Ride"] = 929.69, ["Mega|Fly|Ride"] = 1944.71}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 155.26, ["Ride"] = 144.38, ["Fly|Ride"] = 262.5, ["Neon"] = 928.53, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 485.63, ["Mega|Ride"] = 1286.25, ["Mega|Fly|Ride"] = 1396.5}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 79.03}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 60.38, ["Fly"] = 93.49, ["Ride"] = 59.8, ["Fly|Ride"] = 78.52, ["Neon|Ride"] = 347.25, ["Neon|Fly|Ride"] = 334.69, ["Mega"] = 4195.69, ["Mega|Fly|Ride"] = 1574.56}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 10.49, ["Ride"] = 56.66, ["Fly|Ride"] = 158.42, ["Neon"] = 39.38, ["Neon|Ride"] = 155.27, ["Mega"] = 196.88, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 209.81, ["Mega|Fly|Ride"] = 343.01}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 339.56, ["Fly"] = 462.58, ["Ride"] = 367.5, ["Fly|Ride"] = 367.5, ["Neon|Ride"] = 1959.64, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 6971.73}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 73.5, ["Fly"] = 94.5, ["Ride"] = 85.32, ["Fly|Ride"] = 157.5, ["Neon"] = 325.41, ["Neon|Fly"] = 314.73, ["Neon|Ride"] = 350.4, ["Neon|Fly|Ride"] = 364.04, ["Mega|Ride"] = 1818.85, ["Mega|Fly|Ride"] = 1561.88}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3594.67, ["Ride"] = 3018.75, ["Fly|Ride"] = 3543.75, ["Neon|Fly|Ride"] = 13985.91}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 41.97, ["Fly"] = 224.51, ["Ride"] = 53.62, ["Fly|Ride"] = 85.32, ["Neon"] = 979.82, ["Neon|Ride"] = 280.11, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1888.07, ["Mega|Ride"] = 1888.07, ["Mega|Fly|Ride"] = 1396.12}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 57.18, ["Ride"] = 77.64, ["Fly|Ride"] = 137.44, ["Neon"] = 393.75, ["Neon|Ride"] = 217.32, ["Neon|Fly|Ride"] = 525, ["Mega"] = 6293.53, ["Mega|Fly|Ride"] = 1496.82}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 31.82, ["Fly"] = 76.13, ["Ride"] = 44.56, ["Fly|Ride"] = 130.92, ["Neon"] = 155.74, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 203.44, ["Mega"] = 2598.75, ["Mega|Fly|Ride"] = 602.23}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 11.82}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 70.3, ["Ride"] = 78.75, ["Fly|Ride"] = 131.25, ["Neon"] = 440.62, ["Neon|Fly|Ride"] = 498.25}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 44.63}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 227.07, ["Ride"] = 245.49, ["Fly|Ride"] = 367.5, ["Neon|Ride"] = 1678.49, ["Neon|Fly|Ride"] = 2098.11}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 761.25, ["Ride"] = 643.13, ["Fly|Ride"] = 656.25, ["Neon|Fly|Ride"] = 2296.87, ["Mega|Ride"] = 10908.77, ["Mega|Fly|Ride"] = 11812.5}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 3.93}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 30.08, ["Fly"] = 61.9, ["Ride"] = 38.19, ["Fly|Ride"] = 59.07, ["Neon"] = 266.47, ["Neon|Ride"] = 162.63, ["Neon|Fly|Ride"] = 203.44, ["Mega|Ride"] = 825.51, ["Mega|Fly|Ride"] = 813.38}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 10.48}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5118.75, ["Fly|Ride"] = 4725, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 40278.5}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 11.82, ["Fly"] = 41.98, ["Ride"] = 25.99, ["Fly|Ride"] = 56.66, ["Neon"] = 91.88, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 210, ["Mega"] = 620.49, ["Mega|Ride"] = 374.07, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 15.74, ["Fly"] = 78.69, ["Ride"] = 39.38, ["Fly|Ride"] = 115.06, ["Neon"] = 140.59, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 699.65, ["Mega|Ride"] = 511.89, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 86.63, ["Ride"] = 128.63, ["Fly|Ride"] = 132.2, ["Neon|Fly|Ride"] = 573.85}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 9.31, ["Ride"] = 35.44, ["Fly|Ride"] = 139.65, ["Neon"] = 47.25, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 306.34, ["Mega"] = 360.85, ["Mega|Ride"] = 553.84, ["Mega|Fly|Ride"] = 620.49}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 2100, ["Fly"] = 2310, ["Ride"] = 3077.91, ["Fly|Ride"] = 2275.87, ["Neon|Fly|Ride"] = 5118.75, ["Mega|Fly|Ride"] = 11188.84}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 32586.79, ["Ride"] = 33540.94, ["Fly|Ride"] = 24281.25, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 69656.73, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 195798.59}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 27.48, ["Fly"] = 393.75, ["Ride"] = 56.66, ["Fly|Ride"] = 87.17, ["Neon"] = 236.25, ["Neon|Ride"] = 178.38, ["Neon|Fly|Ride"] = 266.44, ["Mega"] = 1470, ["Mega|Ride"] = 734.26, ["Mega|Fly|Ride"] = 695.63}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 2.1, ["Fly"] = 43.32, ["Ride"] = 30.19, ["Fly|Ride"] = 121.7, ["Neon"] = 16.28, ["Neon|Fly"] = 129.35, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 107.78, ["Mega"] = 119.8, ["Mega|Fly"] = 140.58, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 246.74}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 22.19}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 7.3, ["Ride"] = 41.97, ["Fly|Ride"] = 107.63, ["Neon"] = 81.38, ["Neon|Ride"] = 124.36, ["Neon|Fly|Ride"] = 463.32, ["Mega"] = 279.57, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 467.25}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 925.22, ["Ride"] = 687.75, ["Fly|Ride"] = 761.25, ["Neon|Fly|Ride"] = 3147.15, ["Mega"] = 11188.84, ["Mega|Fly|Ride"] = 10845.69}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 1032.94, ["Fly"] = 1076.25, ["Ride"] = 1174.94, ["Fly|Ride"] = 1116.94, ["Neon|Fly|Ride"] = 3753.51, ["Mega|Fly|Ride"] = 18880.55}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 22.32, ["Fly"] = 56.66, ["Ride"] = 60.38, ["Fly|Ride"] = 112.88, ["Neon"] = 202.21, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 209.83, ["Mega|Fly|Ride"] = 686.01}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 44.07}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 56.32, ["Fly"] = 123.38, ["Ride"] = 82.9, ["Fly|Ride"] = 131.25, ["Neon|Ride"] = 419.64, ["Neon|Fly|Ride"] = 481.52, ["Mega|Ride"] = 1677.24, ["Mega|Fly|Ride"] = 1525.14}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 88.33, ["Ride"] = 118.13, ["Fly|Ride"] = 170.63, ["Neon"] = 450.19, ["Neon|Ride"] = 620.58, ["Neon|Fly|Ride"] = 15495.4, ["Mega"] = 2113.81, ["Mega|Fly|Ride"] = 2018.14}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 3.14, ["Fly"] = 48.57, ["Ride"] = 25.19, ["Fly|Ride"] = 58.59, ["Neon"] = 22.32, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 699.65, ["Mega|Fly|Ride"] = 450.19}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 75.68, ["Fly"] = 84, ["Ride"] = 90.57, ["Fly|Ride"] = 148.55, ["Neon|Ride"] = 335.71, ["Neon|Fly|Ride"] = 301.88, ["Mega|Fly|Ride"] = 1190.44}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 3.91, ["Ride"] = 39.37, ["Fly|Ride"] = 73.6, ["Neon"] = 27.28, ["Neon|Fly"] = 266.47, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 156.19, ["Mega"] = 123.79, ["Mega|Fly"] = 1119.22, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 417.5}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 18.32, ["Fly"] = 65.62, ["Ride"] = 32.82, ["Fly|Ride"] = 104.92, ["Neon"] = 35.68, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 185.74, ["Mega"] = 1050, ["Mega|Fly|Ride"] = 685.13}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 28.33, ["Ride"] = 92.98, ["Fly|Ride"] = 272.77, ["Neon"] = 190.32, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 2097.85, ["Mega|Fly|Ride"] = 769.93}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 15.69, ["Fly"] = 44.84, ["Ride"] = 39.53, ["Fly|Ride"] = 82.69, ["Neon"] = 103.69, ["Neon|Ride"] = 172.01, ["Neon|Fly|Ride"] = 167.87, ["Mega"] = 629.37, ["Mega|Fly|Ride"] = 938.79}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 5579.44, ["Ride"] = 5643.75, ["Fly|Ride"] = 5263.13, ["Neon"] = 30773.81, ["Neon|Fly|Ride"] = 26250, ["Mega|Fly|Ride"] = 99896.96}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 231.82, ["Fly"] = 290.53, ["Ride"] = 209.83, ["Fly|Ride"] = 293.74, ["Neon|Ride"] = 590.63, ["Neon|Fly|Ride"] = 590.63, ["Mega"] = 2099.99, ["Mega|Fly|Ride"] = 2202.75}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 26.24, ["Fly"] = 99.68, ["Ride"] = 55.13, ["Fly|Ride"] = 131.25, ["Neon"] = 75.87, ["Neon|Fly"] = 241.5, ["Neon|Ride"] = 106.94, ["Neon|Fly|Ride"] = 263.09, ["Mega"] = 346.5, ["Mega|Ride"] = 360.85, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 3.29, ["Fly"] = 40.69, ["Ride"] = 28.33, ["Fly|Ride"] = 98.63, ["Neon"] = 26.24, ["Neon|Ride"] = 56.69, ["Mega"] = 140.44}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 40.69, ["Fly"] = 41.98, ["Ride"] = 65.63, ["Fly|Ride"] = 160.13, ["Neon"] = 105, ["Neon|Ride"] = 209.79, ["Neon|Fly|Ride"] = 310.28, ["Mega"] = 479.07, ["Mega|Ride"] = 436.36, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 18571.88, ["Ride"] = 15495.4, ["Fly|Ride"] = 12225.94, ["Neon|Fly|Ride"] = 23625}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 125.89, ["Ride"] = 203.54, ["Fly|Ride"] = 280.11, ["Neon"] = 838.21, ["Neon|Fly|Ride"] = 840}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 39.46, ["Fly"] = 459.38, ["Ride"] = 52.31, ["Fly|Ride"] = 98.6, ["Neon|Fly"] = 464.85, ["Neon|Ride"] = 251.76, ["Neon|Fly|Ride"] = 266.47, ["Mega|Fly|Ride"] = 1362.57}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 10.49, ["Ride"] = 27.57, ["Fly|Ride"] = 91.28, ["Neon"] = 72.19, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 182.53, ["Mega"] = 2517.42, ["Mega|Ride"] = 492.19, ["Mega|Fly|Ride"] = 734.26}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 426.57, ["Fly"] = 839.26, ["Ride"] = 446.24, ["Fly|Ride"] = 484.32, ["Neon"] = 1395.26, ["Neon|Ride"] = 1323, ["Neon|Fly|Ride"] = 1417.5, ["Mega|Fly|Ride"] = 5590.76}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 7.25, ["Fly"] = 51.15, ["Ride"] = 42, ["Fly|Ride"] = 140.59, ["Neon"] = 18.04, ["Neon|Ride"] = 101.17, ["Neon|Fly|Ride"] = 140.59, ["Mega"] = 139.12, ["Mega|Ride"] = 178.5, ["Mega|Fly|Ride"] = 203.56}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 136.22, ["Fly"] = 393.75, ["Ride"] = 128.04, ["Fly|Ride"] = 223.13, ["Neon"] = 560.2, ["Neon|Ride"] = 503.56, ["Neon|Fly|Ride"] = 459.37, ["Mega|Fly|Ride"] = 1874.43}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 10.34, ["Fly"] = 21.32, ["Ride"] = 24.14, ["Fly|Ride"] = 35.44, ["Neon|Ride"] = 102.29, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 2517.42, ["Mega|Fly|Ride"] = 570.63}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 12.08}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 65.63, ["Ride"] = 167.87, ["Fly|Ride"] = 525, ["Neon"] = 393.75, ["Neon|Fly"] = 1678.49, ["Neon|Ride"] = 377.67, ["Neon|Fly|Ride"] = 350.36, ["Mega|Ride"] = 2231.25, ["Mega|Fly|Ride"] = 1531.83}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 15.67, ["Ride"] = 31.42, ["Fly|Ride"] = 62.79, ["Neon"] = 77.64, ["Neon|Ride"] = 125.99, ["Neon|Fly|Ride"] = 231.84, ["Mega|Ride"] = 570.63, ["Mega|Fly|Ride"] = 956.64}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 14.32}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 33.57, ["Fly"] = 210, ["Ride"] = 77.88, ["Fly|Ride"] = 83.94, ["Neon"] = 133.88, ["Neon|Ride"] = 79.72, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1538.78, ["Mega|Ride"] = 775.04, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.93, ["Ride"] = 31.39, ["Neon"] = 19.04, ["Neon|Ride"] = 137.44, ["Neon|Fly|Ride"] = 280.11, ["Mega"] = 138.48, ["Mega|Ride"] = 335.67, ["Mega|Fly|Ride"] = 440.35}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 14.49, ["Fly"] = 42, ["Ride"] = 30.19, ["Fly|Ride"] = 91.87, ["Neon"] = 140.59, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 222.42, ["Mega"] = 698.6, ["Mega|Ride"] = 620.49, ["Mega|Fly|Ride"] = 730.06}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 393.75, ["Fly"] = 437.75, ["Ride"] = 322.88, ["Fly|Ride"] = 393.75, ["Neon|Fly|Ride"] = 1735.14, ["Mega|Fly|Ride"] = 8671.43}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 53.5, ["Ride"] = 109.24, ["Fly|Ride"] = 131.25, ["Neon"] = 253.32, ["Neon|Ride"] = 236.25, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 902.08}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 53.82, ["Ride"] = 91.28, ["Fly|Ride"] = 144.12, ["Neon|Ride"] = 177.19, ["Neon|Fly|Ride"] = 630, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1370.96}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 20.31, ["Fly"] = 83.94, ["Ride"] = 62.76, ["Fly|Ride"] = 86.63, ["Neon"] = 92.99, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 278.92, ["Mega"] = 419.58, ["Mega|Ride"] = 374.07, ["Mega|Fly|Ride"] = 532.87}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 11156.14, ["Ride"] = 11156.14, ["Fly|Ride"] = 8529.94, ["Neon|Fly|Ride"] = 16918.13, ["Mega|Fly|Ride"] = 39372.9}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 2232.57, ["Fly"] = 2634.49, ["Ride"] = 2307.92, ["Fly|Ride"] = 2336.25, ["Neon"] = 4593.75, ["Neon|Fly|Ride"] = 5209.32, ["Mega|Fly|Ride"] = 14700}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 419.58, ["Ride"] = 367.5, ["Fly|Ride"] = 620.58, ["Neon"] = 1399.44, ["Neon|Ride"] = 1397.82, ["Neon|Fly|Ride"] = 1399.44, ["Mega"] = 16782.71, ["Mega|Fly|Ride"] = 6398.42}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 13.77, ["Fly"] = 30.19, ["Ride"] = 27.28, ["Fly|Ride"] = 49.88, ["Neon"] = 116.22, ["Neon|Ride"] = 78.69, ["Neon|Fly|Ride"] = 167.78, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 6.22, ["Ride"] = 61.69, ["Fly|Ride"] = 153.57, ["Neon"] = 24.92, ["Neon|Ride"] = 65.63, ["Mega"] = 140.58, ["Mega|Ride"] = 291.9, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 49.88, ["Fly"] = 39.89, ["Ride"] = 40.69, ["Fly|Ride"] = 111.57, ["Neon|Ride"] = 207.73, ["Neon|Fly|Ride"] = 199.34, ["Mega|Fly"] = 328.13, ["Mega|Fly|Ride"] = 775.31}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.51, ["Fly"] = 30.43, ["Ride"] = 19.69, ["Fly|Ride"] = 44.63, ["Neon"] = 19.94, ["Neon|Fly"] = 280.11, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 87.94, ["Mega"] = 472.5, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 341.25, ["Fly"] = 320.23, ["Ride"] = 326.82, ["Fly|Ride"] = 414.75, ["Neon"] = 1258.88, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 1351.19, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 4191.5}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 20.98, ["Fly"] = 45.76, ["Ride"] = 41.88, ["Fly|Ride"] = 87.94, ["Neon"] = 280.11, ["Neon|Fly"] = 464.85, ["Neon|Ride"] = 176.34, ["Neon|Fly|Ride"] = 236.25, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 1258.72}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 15.74, ["Fly"] = 18.9, ["Ride"] = 28.33, ["Fly|Ride"] = 32.82, ["Neon"] = 62.76, ["Neon|Fly"] = 136.5, ["Neon|Ride"] = 109.26, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 524.48, ["Mega|Ride"] = 577.97, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 505.89, ["Fly"] = 787.5, ["Ride"] = 567, ["Fly|Ride"] = 681.9, ["Mega|Fly|Ride"] = 8112.36}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1061.82, ["Ride"] = 1290.19, ["Fly|Ride"] = 1260, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 17043.54}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 84, ["Fly"] = 116.22, ["Ride"] = 83.53, ["Fly|Ride"] = 78.75, ["Neon"] = 499.36, ["Neon|Ride"] = 416.06, ["Neon|Fly|Ride"] = 525, ["Mega|Fly|Ride"] = 2099.99}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 219.85, ["Fly"] = 234.76, ["Ride"] = 224.51, ["Fly|Ride"] = 281.25, ["Neon"] = 1085.41, ["Neon|Ride"] = 836.72, ["Neon|Fly|Ride"] = 652.31, ["Mega|Ride"] = 7290.94, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 34.88, ["Ride"] = 56.66, ["Neon"] = 274.83, ["Neon|Ride"] = 153.41, ["Neon|Fly|Ride"] = 839.15, ["Mega|Ride"] = 929.58, ["Mega|Fly|Ride"] = 1039.97}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 145.82, ["Ride"] = 576.99, ["Fly|Ride"] = 597.19, ["Neon"] = 1538.97, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 2993.63}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 1754.16, ["Fly"] = 2517.74, ["Ride"] = 2098.11, ["Fly|Ride"] = 1848.3, ["Neon|Fly|Ride"] = 6792.59, ["Mega|Fly|Ride"] = 31915.38}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 55.13, ["Ride"] = 61.69, ["Fly|Ride"] = 262.65, ["Neon"] = 288.5, ["Neon|Fly|Ride"] = 309.44, ["Mega"] = 1959.4, ["Mega|Ride"] = 2307.64, ["Mega|Fly|Ride"] = 1963.6}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 656.25, ["Fly"] = 675.94, ["Ride"] = 652.32, ["Fly|Ride"] = 643.13, ["Neon|Ride"] = 1456.09, ["Neon|Fly|Ride"] = 1246.88, ["Mega|Fly|Ride"] = 2782.5}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 48.26, ["Fly"] = 81.23, ["Ride"] = 58.73, ["Fly|Ride"] = 107.63, ["Neon"] = 209.83, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 262.5, ["Mega|Fly|Ride"] = 979.71}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.14, ["Fly"] = 26.25, ["Ride"] = 21.19, ["Fly|Ride"] = 45.94, ["Neon"] = 19.66, ["Neon|Fly"] = 65.61, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 140.58, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 41.89, ["Ride"] = 65.05, ["Fly|Ride"] = 253.32, ["Neon"] = 1258.88, ["Neon|Ride"] = 770.02, ["Neon|Fly|Ride"] = 310.3, ["Mega"] = 1394.36, ["Mega|Ride"] = 1119.22, ["Mega|Fly|Ride"] = 6993.16}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 636.71, ["Fly"] = 899.07, ["Ride"] = 608.47, ["Fly|Ride"] = 670.69, ["Neon"] = 1816.97, ["Neon|Ride"] = 1871.51, ["Neon|Fly|Ride"] = 1968.75, ["Mega|Fly|Ride"] = 5775}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 507.97, ["Ride"] = 629.37, ["Fly|Ride"] = 699.74, ["Neon"] = 8392.39, ["Neon|Ride"] = 4068.75, ["Neon|Fly|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 12587.04}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 14.43, ["Fly"] = 32.82, ["Ride"] = 22.09, ["Fly|Ride"] = 39.37, ["Neon|Ride"] = 155.74, ["Neon|Fly|Ride"] = 125.9, ["Mega|Fly|Ride"] = 419.58}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 7.01, ["Ride"] = 26.25, ["Fly|Ride"] = 62.95, ["Neon"] = 53.48, ["Neon|Ride"] = 83.94, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 1682.73, ["Mega|Ride"] = 464.8, ["Mega|Fly|Ride"] = 477.27}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 3.14, ["Ride"] = 28.33, ["Fly|Ride"] = 84.32, ["Neon"] = 19.69, ["Neon|Fly"] = 112.26, ["Neon|Ride"] = 49.32, ["Neon|Fly|Ride"] = 342.8, ["Mega"] = 154.87, ["Mega|Ride"] = 186.38, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 43.22, ["Fly"] = 70.19, ["Ride"] = 52.5, ["Fly|Ride"] = 99.64, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 253.3, ["Mega|Fly|Ride"] = 762.58}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 35.43, ["Ride"] = 86.63, ["Fly|Ride"] = 620.42, ["Neon"] = 336.99, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 976.57, ["Mega|Ride"] = 1538.78, ["Mega|Fly|Ride"] = 1538.22}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 16.79, ["Fly"] = 57.14, ["Ride"] = 36.75, ["Fly|Ride"] = 72.19, ["Neon"] = 98.44, ["Neon|Ride"] = 92.98, ["Neon|Fly|Ride"] = 127.32, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 642.6}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 40.69, ["Fly"] = 92.33, ["Ride"] = 45.94, ["Fly|Ride"] = 99.68, ["Neon"] = 348.3, ["Neon|Ride"] = 203.44, ["Neon|Fly|Ride"] = 280.11, ["Mega"] = 2100, ["Mega|Fly|Ride"] = 1119.35}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 2.5, ["Fly"] = 38.06, ["Ride"] = 16.99, ["Fly|Ride"] = 42.4, ["Neon"] = 31.39, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 104.92, ["Mega"] = 177.19, ["Mega|Ride"] = 182.53, ["Mega|Fly|Ride"] = 397.56}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 5.61, ["Fly"] = 65.63, ["Ride"] = 34.9, ["Fly|Ride"] = 1838.22, ["Neon"] = 26.55, ["Neon|Fly"] = 155.74, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 232.4, ["Mega|Ride"] = 140.58, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 36.74, ["Fly"] = 79.74, ["Ride"] = 60.38, ["Fly|Ride"] = 140.44, ["Neon"] = 560.2, ["Neon|Ride"] = 232.43, ["Neon|Fly|Ride"] = 216.57, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 2324.44, ["Fly"] = 2479.93, ["Ride"] = 2231.24, ["Fly|Ride"] = 1984.5, ["Neon|Ride"] = 5455.06, ["Neon|Fly|Ride"] = 4651.5, ["Mega|Fly|Ride"] = 14437.5}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 503.5, ["Fly"] = 686.09, ["Ride"] = 531.88, ["Fly|Ride"] = 560.2, ["Neon"] = 1749.82, ["Neon|Ride"] = 2496.75, ["Neon|Fly|Ride"] = 1798.13, ["Mega|Fly|Ride"] = 8456.4}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 262.5, ["Fly"] = 590.63, ["Ride"] = 459.54, ["Fly|Ride"] = 401.63, ["Neon"] = 1537.92, ["Neon|Fly|Ride"] = 1611.84, ["Mega|Fly|Ride"] = 5906.25}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 52.5}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 43.32, ["Fly"] = 65.63, ["Ride"] = 54.63, ["Fly|Ride"] = 69.25, ["Neon|Ride"] = 310.3, ["Neon|Fly|Ride"] = 317.92, ["Mega|Ride"] = 1468.5, ["Mega|Fly|Ride"] = 1468.5}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 33569.52, ["Fly"] = 23625, ["Ride"] = 34781.25, ["Fly|Ride"] = 16012.5, ["Neon|Fly|Ride"] = 36750, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 254.63, ["Fly"] = 362.98, ["Ride"] = 318.43, ["Fly|Ride"] = 378, ["Neon"] = 924.23, ["Neon|Fly"] = 1094.7, ["Neon|Ride"] = 933.19, ["Neon|Fly|Ride"] = 748.13, ["Mega"] = 6293.53, ["Mega|Ride"] = 6154.02, ["Mega|Fly|Ride"] = 2488.49}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 96.51, ["Ride"] = 350.36, ["Fly|Ride"] = 155.74, ["Neon|Fly|Ride"] = 838.21, ["Mega|Fly|Ride"] = 4056.19}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 95.82, ["Ride"] = 120.75, ["Fly|Ride"] = 207.38, ["Neon"] = 420, ["Neon|Ride"] = 558.1, ["Neon|Fly|Ride"] = 566.5, ["Mega"] = 13986.3, ["Mega|Fly|Ride"] = 1391.93}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 14.97, ["Fly"] = 94.5, ["Ride"] = 39.53, ["Fly|Ride"] = 65.63, ["Neon|Ride"] = 104.92, ["Neon|Fly|Ride"] = 262.5}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 4530.28, ["Ride"] = 3675, ["Fly|Ride"] = 4462.5, ["Neon|Fly|Ride"] = 15750}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 29.27, ["Fly"] = 45.94, ["Ride"] = 28.88, ["Fly|Ride"] = 65.62, ["Neon"] = 144.38, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 125.9, ["Mega|Fly|Ride"] = 632.63}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 35.68, ["Fly"] = 140.59, ["Ride"] = 56.44, ["Fly|Ride"] = 91.88, ["Neon"] = 172.01, ["Neon|Ride"] = 280.11, ["Neon|Fly|Ride"] = 498.75, ["Mega|Fly|Ride"] = 837.04}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 534.72, ["Fly"] = 656.25, ["Ride"] = 590.63, ["Fly|Ride"] = 721.87, ["Neon"] = 1563.18, ["Neon|Ride"] = 1677.44, ["Neon|Fly|Ride"] = 1490.08, ["Mega"] = 4752.67, ["Mega|Fly|Ride"] = 4147.5}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 17.71, ["Fly"] = 28.88, ["Ride"] = 26.25, ["Fly|Ride"] = 53.82, ["Neon|Fly"] = 188.84, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 137.82, ["Mega"] = 699.65, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 15.74, ["Ride"] = 140.44, ["Fly|Ride"] = 56.66, ["Neon"] = 69.55, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 232.43}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 98.44, ["Ride"] = 140.59, ["Fly|Ride"] = 167.87, ["Neon"] = 506.7, ["Neon|Ride"] = 419.64, ["Neon|Fly|Ride"] = 1007.1, ["Mega|Ride"] = 2357.99, ["Mega|Fly|Ride"] = 2361.13}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 16.79, ["Fly"] = 91.28, ["Ride"] = 77.44, ["Fly|Ride"] = 131.25, ["Neon"] = 91.88, ["Neon|Ride"] = 132.57, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 209.81, ["Mega|Fly"] = 654.94, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 4237.65, ["Ride"] = 3150, ["Fly|Ride"] = 3209.07, ["Neon"] = 12396.08, ["Neon|Ride"] = 17045.63, ["Neon|Fly|Ride"] = 7875, ["Mega"] = 62935.15, ["Mega|Fly|Ride"] = 38732.56}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 39.46, ["Ride"] = 85.32, ["Fly|Ride"] = 92.33, ["Neon"] = 271.95, ["Neon|Ride"] = 271.9, ["Neon|Fly|Ride"] = 328.13, ["Mega|Fly|Ride"] = 881.11}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 9092.11, ["Ride"] = 7746.55, ["Fly|Ride"] = 5971.88, ["Neon|Fly|Ride"] = 17062.5, ["Mega|Fly|Ride"] = 62865.93}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 3.67, ["Fly"] = 27.28, ["Ride"] = 18.88, ["Fly|Ride"] = 36.75, ["Neon"] = 19.69, ["Neon|Fly"] = 140.59, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 83.93, ["Mega"] = 131.25, ["Mega|Fly|Ride"] = 236.02}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 23.09, ["Fly"] = 35.69, ["Ride"] = 28.33, ["Fly|Ride"] = 51.15, ["Neon"] = 140.59, ["Neon|Ride"] = 280.11, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 1401.1, ["Mega|Fly|Ride"] = 927.25}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 2.88}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 10.49, ["Ride"] = 30.19, ["Fly|Ride"] = 140.59, ["Neon"] = 112.25, ["Neon|Ride"] = 153.57, ["Neon|Fly|Ride"] = 170.63, ["Mega|Ride"] = 698.6, ["Mega|Fly|Ride"] = 852.89}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 30.4, ["Fly"] = 70.3, ["Ride"] = 71.35, ["Neon"] = 178.36, ["Neon|Ride"] = 182.55, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 840, ["Mega|Ride"] = 929.58, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 11.58, ["Fly"] = 28.33, ["Ride"] = 24.94, ["Fly|Ride"] = 44.63, ["Neon"] = 70.3, ["Neon|Ride"] = 174.57, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 1120.26, ["Mega|Fly|Ride"] = 945}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8970.3}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2836.3}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 41.97}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 393.74, ["Fly"] = 560.2, ["Fly|Ride"] = 1029.13, ["Neon|Fly|Ride"] = 2224, ["Mega|Fly|Ride"] = 5594.95}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 28.35, ["Fly"] = 132.2, ["Ride"] = 62.35, ["Fly|Ride"] = 131.25, ["Neon"] = 244.06, ["Neon|Ride"] = 406.88, ["Mega|Ride"] = 929.58, ["Mega|Fly|Ride"] = 741.57}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 10.5}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 9.19, ["Ride"] = 21, ["Neon|Ride"] = 252}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2572.5}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 155.72, ["Ride"] = 309.75, ["Fly|Ride"] = 291.64, ["Neon"] = 770.02, ["Neon|Ride"] = 699.65, ["Neon|Fly|Ride"] = 839.26, ["Mega|Fly|Ride"] = 2231.08}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 139.13, ["Ride"] = 131.25, ["Fly|Ride"] = 525, ["Neon"] = 776.31, ["Neon|Ride"] = 519.29, ["Neon|Fly|Ride"] = 787.5, ["Mega|Fly|Ride"] = 1888.07}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 183.75, ["Fly"] = 208.78, ["Ride"] = 174.56, ["Fly|Ride"] = 204.75, ["Neon"] = 945.96, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 853.13, ["Mega"] = 6154.02, ["Mega|Fly|Ride"] = 2937.38}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1091.48, ["Fly"] = 2517.74, ["Ride"] = 1116.94, ["Fly|Ride"] = 1115.63, ["Neon|Fly|Ride"] = 4593.75, ["Mega|Fly|Ride"] = 20978.39}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 24.19, ["Fly"] = 81.84, ["Ride"] = 46.17, ["Fly|Ride"] = 86.63, ["Neon"] = 140.59, ["Neon|Ride"] = 140.59, ["Neon|Fly|Ride"] = 437.07, ["Mega"] = 733.22, ["Mega|Fly|Ride"] = 929.58}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 656.25, ["Fly"] = 2100, ["Ride"] = 671.41, ["Fly|Ride"] = 839.26, ["Neon|Fly|Ride"] = 4028.51}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 60.85}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 15.28, ["Fly"] = 144.38, ["Ride"] = 40.69, ["Fly|Ride"] = 98.44, ["Neon"] = 82.89, ["Neon|Ride"] = 140.59, ["Neon|Fly|Ride"] = 180.52, ["Mega"] = 347.82, ["Mega|Ride"] = 458.07, ["Mega|Fly|Ride"] = 485.63}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 9.97, ["Fly"] = 36.73, ["Ride"] = 28.88, ["Fly|Ride"] = 91.88, ["Neon"] = 70.3, ["Neon|Ride"] = 115.5, ["Neon|Fly|Ride"] = 200.16, ["Mega|Ride"] = 398.61, ["Mega|Fly|Ride"] = 619.5}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 98.61}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 29.3, ["Fly"] = 108.92, ["Ride"] = 39.37, ["Fly|Ride"] = 61.94, ["Neon"] = 177.19, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 279.06, ["Mega"] = 812.93, ["Mega|Fly|Ride"] = 657.68}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 34.13, ["Fly"] = 39.37, ["Ride"] = 50.37, ["Fly|Ride"] = 67.16, ["Neon"] = 155.74, ["Neon|Fly"] = 241.73, ["Neon|Ride"] = 418.59, ["Neon|Fly|Ride"] = 274.32, ["Mega|Fly|Ride"] = 917.44}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 5223.75, ["Fly"] = 11190.2, ["Ride"] = 6154.77, ["Fly|Ride"] = 4802.44, ["Neon|Ride"] = 12168.97, ["Neon|Fly|Ride"] = 10078.69, ["Mega|Fly|Ride"] = 34650}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 9.93, ["Ride"] = 35.68, ["Fly|Ride"] = 77.44, ["Neon"] = 79.48, ["Neon|Fly"] = 133.25, ["Neon|Ride"] = 85.31, ["Neon|Fly|Ride"] = 155.27, ["Mega"] = 462.59, ["Mega|Ride"] = 388.12, ["Mega|Fly|Ride"] = 434.64}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 31.49}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 108.21, ["Fly"] = 371.38, ["Ride"] = 139.47, ["Fly|Ride"] = 229.69, ["Neon"] = 418.69, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 560.2, ["Mega|Fly|Ride"] = 1771.88}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 88.52, ["Fly"] = 183.75, ["Ride"] = 121.7, ["Fly|Ride"] = 168, ["Neon"] = 327.6, ["Neon|Ride"] = 380.63, ["Neon|Fly|Ride"] = 403.22, ["Mega|Ride"] = 1317.45, ["Mega|Fly|Ride"] = 1329}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 28.46, ["Fly"] = 70.86, ["Ride"] = 34.13, ["Fly|Ride"] = 59.07, ["Neon"] = 182.55, ["Neon|Ride"] = 140.59, ["Neon|Fly|Ride"] = 178.36, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 5.24, ["Fly"] = 49.87, ["Ride"] = 33.71, ["Fly|Ride"] = 101.11, ["Neon"] = 31.39, ["Neon|Fly"] = 182.55, ["Neon|Ride"] = 71.35, ["Neon|Fly|Ride"] = 130.08, ["Mega"] = 124.69, ["Mega|Fly"] = 7034.11, ["Mega|Ride"] = 171.94, ["Mega|Fly|Ride"] = 236.8}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 15.21, ["Fly"] = 74.39, ["Ride"] = 31.49, ["Fly|Ride"] = 110.92, ["Neon"] = 62.95, ["Neon|Ride"] = 96.47, ["Neon|Fly|Ride"] = 202.21, ["Mega|Ride"] = 419.99, ["Mega|Fly|Ride"] = 518.44}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 21.19, ["Fly"] = 35.68, ["Ride"] = 28.32, ["Fly|Ride"] = 48.42, ["Neon"] = 140.59, ["Neon|Fly"] = 209.83, ["Neon|Ride"] = 188.84, ["Neon|Fly|Ride"] = 112.26, ["Mega|Fly|Ride"] = 625.16}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 225.75}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 16.79, ["Ride"] = 103.87, ["Neon"] = 104.92, ["Mega"] = 489.86, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 896.84}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 266.44, ["Ride"] = 209.83, ["Fly|Ride"] = 262.49, ["Neon|Ride"] = 708.75, ["Neon|Fly|Ride"] = 758.47}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 39.38, ["Ride"] = 97.67, ["Fly|Ride"] = 280.11, ["Neon"] = 280.11, ["Neon|Ride"] = 316.21, ["Neon|Fly|Ride"] = 498.75, ["Mega"] = 1076.2, ["Mega|Ride"] = 1257.67, ["Mega|Fly|Ride"] = 1299.38}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 654.94, ["Fly"] = 780.94, ["Ride"] = 775.13, ["Fly|Ride"] = 780.93, ["Neon|Ride"] = 2100, ["Neon|Fly|Ride"] = 1890, ["Mega|Fly|Ride"] = 6429.94}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 262.5, ["Ride"] = 346.5, ["Fly|Ride"] = 363.99, ["Neon"] = 1342.8, ["Neon|Ride"] = 2098.11, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 4056.68}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 94.5}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 7.87, ["Fly"] = 209.83, ["Ride"] = 26.24, ["Fly|Ride"] = 58.11, ["Neon"] = 80.07, ["Neon|Fly"] = 230.99, ["Neon|Ride"] = 138.3, ["Neon|Fly|Ride"] = 125.9, ["Mega|Ride"] = 419.58, ["Mega|Fly|Ride"] = 405.57}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 288.75, ["Fly"] = 724.23, ["Ride"] = 341.25, ["Fly|Ride"] = 411.38, ["Neon"] = 2781.03, ["Neon|Ride"] = 1023.75, ["Neon|Fly|Ride"] = 1023.75, ["Mega"] = 4195.69, ["Mega|Fly|Ride"] = 3287.33}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 15.74}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 79.73, ["Fly"] = 590.63, ["Ride"] = 167.87, ["Fly|Ride"] = 251.78, ["Neon"] = 446.24, ["Neon|Fly"] = 1399.44, ["Neon|Ride"] = 560.2, ["Neon|Fly|Ride"] = 643.13, ["Mega"] = 2569.87, ["Mega|Fly|Ride"] = 1704.94}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 140.59, ["Ride"] = 162.74, ["Fly|Ride"] = 216.17, ["Neon"] = 897.16, ["Neon|Ride"] = 997.5, ["Neon|Fly|Ride"] = 1007.1}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 8.66, ["Ride"] = 36.73, ["Fly|Ride"] = 104.92, ["Neon"] = 28.88, ["Neon|Ride"] = 46.49, ["Neon|Fly|Ride"] = 167.87, ["Mega"] = 199.31, ["Mega|Ride"] = 203.49, ["Mega|Fly|Ride"] = 407}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 19.09, ["Fly"] = 49.88, ["Ride"] = 35.44, ["Fly|Ride"] = 65.63, ["Neon"] = 116.46, ["Neon|Ride"] = 209.83, ["Neon|Fly|Ride"] = 260.17}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 23.63, ["Fly"] = 140.59, ["Ride"] = 41.98, ["Fly|Ride"] = 140.59, ["Neon"] = 220.81, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 270.38, ["Mega|Ride"] = 489.86, ["Mega|Fly|Ride"] = 553.84}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 5.24, ["Fly"] = 335.71, ["Ride"] = 42, ["Fly|Ride"] = 139.47, ["Neon"] = 28.01, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 146.77, ["Mega"] = 139.44, ["Mega|Fly"] = 189, ["Mega|Ride"] = 149.63, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 209.81, ["Fly"] = 918.75, ["Ride"] = 358.79, ["Fly|Ride"] = 406.88, ["Neon"] = 1678.49, ["Neon|Ride"] = 1394.53, ["Neon|Fly|Ride"] = 1378.13, ["Mega|Fly|Ride"] = 4291.13}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 83.87, ["Fly"] = 104.92, ["Ride"] = 125.9, ["Fly|Ride"] = 232.43, ["Neon"] = 433.13, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 560.2, ["Mega"] = 2097.85, ["Mega|Ride"] = 1928.07, ["Mega|Fly|Ride"] = 2091.55}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 78.93, ["Fly"] = 203.54, ["Ride"] = 102.83, ["Fly|Ride"] = 141.75, ["Neon|Ride"] = 334.69, ["Neon|Fly|Ride"] = 528.74, ["Mega|Fly|Ride"] = 1538.78}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 15.75, ["Ride"] = 58.24, ["Fly|Ride"] = 280.11, ["Neon|Ride"] = 590.36, ["Neon|Fly|Ride"] = 489.91, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 14.9, ["Fly"] = 70.3, ["Ride"] = 46.5, ["Fly|Ride"] = 102.38, ["Neon"] = 94.63, ["Neon|Ride"] = 89.25, ["Neon|Fly|Ride"] = 181.13, ["Mega"] = 504.3, ["Mega|Fly"] = 525, ["Mega|Ride"] = 472.5, ["Mega|Fly|Ride"] = 444.94}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 2.63, ["Fly"] = 41.98, ["Ride"] = 27.28, ["Fly|Ride"] = 138.49, ["Neon"] = 19.69, ["Neon|Ride"] = 38.19, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 133.68, ["Mega|Ride"] = 199.43, ["Mega|Fly|Ride"] = 213.94}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 979.13, ["Ride"] = 984.38, ["Fly|Ride"] = 1021.05, ["Neon"] = 2832.44, ["Neon|Fly"] = 2832.44, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2401.88, ["Mega"] = 11888.46, ["Mega|Fly|Ride"] = 7612.5}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 310.25, ["Ride"] = 321.57, ["Fly|Ride"] = 350.4, ["Neon"] = 1049.06, ["Neon|Ride"] = 1036.88, ["Neon|Fly|Ride"] = 1043.82, ["Mega"] = 10489.2, ["Mega|Fly|Ride"] = 4068.75}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 105, ["Ride"] = 146.88, ["Fly|Ride"] = 310.3, ["Neon"] = 384.57, ["Neon|Ride"] = 320.25, ["Neon|Fly|Ride"] = 372.75, ["Mega"] = 1640.63, ["Mega|Ride"] = 1678.29, ["Mega|Fly|Ride"] = 1508.36}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 203.39, ["Ride"] = 209.98, ["Fly|Ride"] = 253.32, ["Neon|Ride"] = 979.82, ["Neon|Fly|Ride"] = 1040.67, ["Mega"] = 10489.2, ["Mega|Fly|Ride"] = 3041.89}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 23.24, ["Fly"] = 48.27, ["Ride"] = 33.71, ["Fly|Ride"] = 56.66, ["Neon"] = 155.74, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 209.81, ["Mega|Ride"] = 775.04, ["Mega|Fly|Ride"] = 619.12}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 354.38, ["Ride"] = 462.66, ["Fly|Ride"] = 560.2, ["Neon"] = 1584.98, ["Neon|Ride"] = 1115.63, ["Neon|Fly|Ride"] = 1378.13, ["Mega"] = 5250, ["Mega|Fly|Ride"] = 4867}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 123.79, ["Fly"] = 126, ["Ride"] = 140.59, ["Neon|Ride"] = 367.5, ["Mega|Fly|Ride"] = 2014.84}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1307.25, ["Ride"] = 1552.6, ["Fly|Ride"] = 1399.44, ["Neon|Ride"] = 4406, ["Neon|Fly|Ride"] = 4331.25, ["Mega"] = 50348.12, ["Mega|Fly|Ride"] = 24475.49}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 10.19, ["Fly"] = 41.97, ["Ride"] = 39.51, ["Fly|Ride"] = 78.69, ["Neon"] = 63.66, ["Neon|Fly"] = 167.35, ["Neon|Ride"] = 83.98, ["Neon|Fly|Ride"] = 140.04, ["Mega"] = 304.5, ["Mega|Ride"] = 314.7, ["Mega|Fly|Ride"] = 563.77}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 125.9, ["Ride"] = 155.74, ["Fly|Ride"] = 216.12, ["Neon"] = 315, ["Neon|Ride"] = 224.48, ["Neon|Fly|Ride"] = 419.64, ["Mega|Ride"] = 1119.22, ["Mega|Fly|Ride"] = 973.41}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 78.64, ["Fly"] = 77.44, ["Ride"] = 85.32, ["Fly|Ride"] = 92.98, ["Neon|Fly"] = 364.04, ["Neon|Ride"] = 392.36, ["Neon|Fly|Ride"] = 392.43, ["Mega|Fly|Ride"] = 1469.99}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 2516.37, ["Ride"] = 958.13, ["Fly|Ride"] = 1081.58, ["Neon|Fly|Ride"] = 4199.99, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 470.16, ["Ride"] = 420, ["Fly|Ride"] = 587.48, ["Neon|Ride"] = 1749.82, ["Neon|Fly|Ride"] = 1563.1, ["Mega|Fly|Ride"] = 9141.09}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 128.4, ["Ride"] = 144.38, ["Fly|Ride"] = 394.43, ["Neon"] = 462.58, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 519.49, ["Mega"] = 3985.91, ["Mega|Ride"] = 1704.94, ["Mega|Fly|Ride"] = 1916.4}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 11.19, ["Ride"] = 26.25, ["Fly|Ride"] = 140.59, ["Neon"] = 101.07, ["Neon|Ride"] = 102.83, ["Neon|Fly|Ride"] = 233.63, ["Mega"] = 761.25, ["Mega|Fly|Ride"] = 1048.93}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 41.97, ["Ride"] = 44.63, ["Fly|Ride"] = 91.28, ["Neon"] = 249.38, ["Neon|Fly"] = 406, ["Neon|Ride"] = 279.06, ["Neon|Fly|Ride"] = 314.73, ["Mega"] = 1818.85, ["Mega|Fly|Ride"] = 1049.99}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 852.26, ["Ride"] = 874.13, ["Fly|Ride"] = 917.44, ["Neon"] = 3287.73, ["Neon|Ride"] = 2828.44, ["Neon|Fly|Ride"] = 3175.48, ["Mega|Fly|Ride"] = 17482.35}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 758.63}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 4593.75, ["Ride"] = 4756.4, ["Fly|Ride"] = 4557, ["Neon|Ride"] = 30066.74, ["Neon|Fly|Ride"] = 16922.19, ["Mega|Fly|Ride"] = 89508.47}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 167.84, ["Fly"] = 167.87, ["Ride"] = 350.4, ["Fly|Ride"] = 406, ["Neon"] = 629.45, ["Neon|Ride"] = 644.13, ["Neon|Fly|Ride"] = 918.75, ["Mega"] = 5873.97, ["Mega|Fly|Ride"] = 6293.53}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 77.44, ["Ride"] = 109.26, ["Fly|Ride"] = 336, ["Neon"] = 441, ["Neon|Ride"] = 466.85, ["Neon|Fly|Ride"] = 645.18}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 14, ["Fly"] = 131.25, ["Ride"] = 34.13, ["Fly|Ride"] = 91.88, ["Neon"] = 83.94, ["Neon|Ride"] = 116.46, ["Neon|Fly|Ride"] = 155.25, ["Mega|Ride"] = 839.15, ["Mega|Fly|Ride"] = 617.02}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 15.75, ["Fly"] = 31.39, ["Ride"] = 30.19, ["Fly|Ride"] = 61.89, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 2223.73}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 22.32, ["Fly"] = 70.9, ["Ride"] = 48.57, ["Fly|Ride"] = 105, ["Neon"] = 83.94, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 187.69, ["Mega|Ride"] = 859.69, ["Mega|Fly|Ride"] = 692.3}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 6.57, ["Fly"] = 28.33, ["Ride"] = 22.32, ["Fly|Ride"] = 41.98, ["Neon"] = 21, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 133.85, ["Mega|Ride"] = 310.25, ["Mega|Fly|Ride"] = 357}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 33.58, ["Fly|Ride"] = 183.75, ["Neon"] = 144.12, ["Neon|Ride"] = 310.3, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 671.48, ["Mega|Ride"] = 1351.88, ["Mega|Fly|Ride"] = 727.96}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 264.8, ["Fly"] = 359.84, ["Ride"] = 297.95, ["Fly|Ride"] = 322.07, ["Neon"] = 728.65, ["Neon|Ride"] = 741.69, ["Neon|Fly|Ride"] = 732.38, ["Mega"] = 6562.5, ["Mega|Ride"] = 4195.69, ["Mega|Fly|Ride"] = 3806.24}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 3.56, ["Fly"] = 16.8, ["Ride"] = 19.34, ["Fly|Ride"] = 40.94, ["Neon"] = 19.34, ["Neon|Fly"] = 92.98, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 76.06, ["Mega"] = 839.15, ["Mega|Ride"] = 738.46, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 34.61, ["Fly"] = 105, ["Ride"] = 64.98, ["Fly|Ride"] = 131.25, ["Neon"] = 185.07, ["Neon|Fly"] = 288.75, ["Neon|Ride"] = 175.88, ["Neon|Fly|Ride"] = 251.78, ["Mega"] = 485.63, ["Mega|Ride"] = 446.25, ["Mega|Fly|Ride"] = 521.07}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 761.25, ["Ride"] = 780.94, ["Fly|Ride"] = 787.5, ["Neon|Fly|Ride"] = 1574.99, ["Mega|Fly|Ride"] = 3937.5}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 24.93, ["Fly"] = 69.75, ["Ride"] = 36.74, ["Fly|Ride"] = 72.19, ["Neon"] = 133.25, ["Neon|Fly"] = 464.85, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 187.69, ["Mega"] = 1575, ["Mega|Ride"] = 979.71, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 320.24, ["Fly"] = 293.74, ["Ride"] = 274.32, ["Fly|Ride"] = 328.13, ["Neon"] = 1399.44, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 4457.92}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 118.13, ["Fly"] = 157.49, ["Ride"] = 129.92, ["Fly|Ride"] = 136.35, ["Neon|Fly"] = 489.91, ["Neon|Ride"] = 542.71, ["Neon|Fly|Ride"] = 575.17, ["Mega"] = 2936.99, ["Mega|Fly|Ride"] = 2028.63}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 759.42, ["Ride"] = 570.93, ["Fly|Ride"] = 702.19, ["Neon"] = 2653.08, ["Neon|Fly|Ride"] = 2412.82, ["Mega|Fly|Ride"] = 7678.11}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 26.76, ["Ride"] = 39.38, ["Fly|Ride"] = 91.28, ["Neon"] = 62.95, ["Neon|Fly"] = 278.92, ["Neon|Ride"] = 118.6, ["Neon|Fly|Ride"] = 224.51, ["Mega"] = 432.17, ["Mega|Ride"] = 430.17, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 3936.19, ["Fly"] = 3776.58, ["Ride"] = 3936.19, ["Fly|Ride"] = 3150, ["Neon"] = 13952.34, ["Neon|Fly|Ride"] = 7133.54, ["Mega|Fly|Ride"] = 23745.75}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 78.75, ["Fly"] = 116.64, ["Ride"] = 85.32, ["Fly|Ride"] = 158.39, ["Neon"] = 394.78, ["Neon|Ride"] = 464.85, ["Neon|Fly|Ride"] = 401.63, ["Mega|Fly|Ride"] = 1550.07}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.63, ["Fly"] = 25.18, ["Ride"] = 18.38, ["Fly|Ride"] = 44.63, ["Neon"] = 15.74, ["Neon|Fly"] = 31.39, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 104.9, ["Mega"] = 133.23, ["Mega|Fly"] = 452.82, ["Mega|Ride"] = 207.69, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.62, ["Ride"] = 28.88, ["Neon"] = 13.13, ["Neon|Ride"] = 103.44, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 147, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 309.44}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 60.59, ["Fly"] = 45.94, ["Ride"] = 40.69, ["Fly|Ride"] = 78.75, ["Neon|Ride"] = 699.74, ["Neon|Fly|Ride"] = 278.92, ["Mega|Fly|Ride"] = 1256.62}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 977.62, ["Ride"] = 1185.19, ["Fly|Ride"] = 1181.24, ["Neon"] = 3776.58, ["Neon|Fly|Ride"] = 4196.2, ["Mega|Fly|Ride"] = 20977.36}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 5385.17, ["Ride"] = 5094.18, ["Fly|Ride"] = 5355}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 22.32, ["Fly"] = 35.68, ["Ride"] = 31.47, ["Fly|Ride"] = 49.32, ["Neon"] = 142.69, ["Neon|Ride"] = 140.59, ["Neon|Fly|Ride"] = 146.78, ["Mega"] = 2517.42, ["Mega|Fly|Ride"] = 560.14}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 24.18, ["Fly"] = 45.12, ["Ride"] = 36.04, ["Fly|Ride"] = 83.95, ["Neon"] = 94.47, ["Neon|Ride"] = 116.46, ["Neon|Fly|Ride"] = 171.98, ["Mega"] = 929.58, ["Mega|Ride"] = 775.04, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 38.06, ["Fly"] = 157.49, ["Ride"] = 45.94, ["Fly|Ride"] = 91.88, ["Neon"] = 393.75, ["Neon|Ride"] = 240.19, ["Neon|Fly|Ride"] = 249.38, ["Mega|Fly|Ride"] = 866.24}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 217.88, ["Ride"] = 258.57, ["Fly|Ride"] = 236.25, ["Neon|Ride"] = 1020.73, ["Neon|Fly|Ride"] = 1157.62, ["Mega"] = 10489.2, ["Mega|Fly|Ride"] = 3253.48}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 5.24, ["Neon"] = 20.98, ["Neon|Fly"] = 70.95, ["Neon|Fly|Ride"] = 155.74, ["Mega"] = 158.82, ["Mega|Ride"] = 272.73, ["Mega|Fly|Ride"] = 309.44}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 202.42, ["Fly"] = 280.11, ["Ride"] = 222.42, ["Fly|Ride"] = 282.19, ["Neon"] = 755.32, ["Neon|Ride"] = 837.16, ["Neon|Fly|Ride"] = 733.69, ["Mega|Fly|Ride"] = 3077.54}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 2.63, ["Fly"] = 27.28, ["Ride"] = 16.94, ["Fly|Ride"] = 46.17, ["Neon"] = 26.92, ["Neon|Fly|Ride"] = 105, ["Mega"] = 280.08, ["Mega|Ride"] = 419.58, ["Mega|Fly|Ride"] = 419.58}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 250.81, ["Fly"] = 183.74, ["Ride"] = 245.49, ["Fly|Ride"] = 275.63, ["Neon|Ride"] = 1119.35, ["Neon|Fly|Ride"] = 896.96, ["Mega"] = 10489.2, ["Mega|Ride"] = 4195.69, ["Mega|Fly|Ride"] = 3776.13}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 12.8, ["Fly"] = 419.64, ["Ride"] = 28.33, ["Fly|Ride"] = 87.17, ["Neon"] = 70.3, ["Neon|Fly"] = 295.18, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 392.36, ["Mega"] = 462.59, ["Mega|Ride"] = 587.41, ["Mega|Fly|Ride"] = 502.57}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 3.68, ["Ride"] = 27.27, ["Neon"] = 16.21, ["Neon|Fly"] = 170.63, ["Neon|Ride"] = 60.85, ["Neon|Fly|Ride"] = 163.8, ["Mega"] = 72.32, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 213.94}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 6.27, ["Mega"] = 28.32}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 3.87, ["Ride"] = 41.98, ["Fly|Ride"] = 218.22, ["Neon"] = 10.5, ["Neon|Ride"] = 53.51, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 77.64, ["Mega|Fly"] = 154927.87, ["Mega|Ride"] = 92.87}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 56.07, ["Fly"] = 138.49, ["Ride"] = 106.32, ["Fly|Ride"] = 196.06, ["Neon"] = 262.5, ["Neon|Ride"] = 325.41, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 1224.11, ["Mega|Ride"] = 1311.19, ["Mega|Fly|Ride"] = 1466.41}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 46.15, ["Ride"] = 18.38, ["Fly|Ride"] = 53.82, ["Neon"] = 8.85, ["Neon|Ride"] = 21.13, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 129.94, ["Mega|Ride"] = 136.37, ["Mega|Fly|Ride"] = 261.45}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 21, ["Ride"] = 98.6, ["Neon"] = 131.25, ["Neon|Ride"] = 218.22, ["Mega"] = 401.63, ["Mega|Ride"] = 560.14}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 155.74, ["Mega"] = 15.49, ["Mega|Ride"] = 45.94, ["Mega|Fly|Ride"] = 280.08}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 17.05, ["Ride"] = 17.07, ["Fly|Ride"] = 35.68, ["Neon"] = 2.1, ["Neon|Ride"] = 13.13, ["Neon|Fly|Ride"] = 77.17, ["Mega"] = 14.43, ["Mega|Ride"] = 26.25, ["Mega|Fly|Ride"] = 56.43}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Ride"] = 140.59, ["Fly|Ride"] = 45.74, ["Neon"] = 3.86, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 59.81, ["Mega"] = 18.59, ["Mega|Ride"] = 40.92, ["Mega|Fly|Ride"] = 147.46}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 2.63, ["Mega"] = 15.74, ["Mega|Ride"] = 131.25}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 41.62, ["Ride"] = 17.46, ["Fly|Ride"] = 107.63, ["Neon"] = 3.94, ["Neon|Fly"] = 135.05, ["Neon|Ride"] = 70.13, ["Neon|Fly|Ride"] = 81.67, ["Mega"] = 41.85, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 190.32}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Fly|Ride"] = 204.75, ["Mega"] = 23.08, ["Mega|Ride"] = 78.75}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 2.28, ["Fly"] = 47.16, ["Ride"] = 19.31, ["Fly|Ride"] = 56.65, ["Neon"] = 6.23, ["Neon|Fly"] = 37.96, ["Neon|Ride"] = 28.33, ["Neon|Fly|Ride"] = 66.5, ["Mega"] = 81.35, ["Mega|Fly"] = 78.75, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 182.2}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 26.17, ["Mega"] = 16.1, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 120.75}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Fly|Ride"] = 525, ["Neon"] = 18.89, ["Neon|Fly"] = 20.99, ["Neon|Ride"] = 70.3, ["Mega"] = 140.44, ["Mega|Ride"] = 157.5}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 4.99, ["Neon"] = 16.88, ["Mega"] = 314.7}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Neon"] = 6.57, ["Neon|Ride"] = 103.95, ["Mega"] = 20.99, ["Mega|Ride"] = 173.14}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 30.23, ["Ride"] = 18.2, ["Neon"] = 2.1, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 18.89, ["Neon|Fly|Ride"] = 41.88, ["Mega"] = 14.44, ["Mega|Ride"] = 19.9, ["Mega|Fly|Ride"] = 43.32}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.63, ["Fly"] = 72.19, ["Ride"] = 42, ["Neon"] = 31.39, ["Neon|Ride"] = 39.38, ["Mega"] = 251.76, ["Mega|Ride"] = 350.36}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 18.38, ["Fly|Ride"] = 78.73, ["Neon"] = 7.87, ["Neon|Ride"] = 41.98, ["Mega"] = 45.94, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 160.13}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 4.19, ["Neon"] = 11.82, ["Neon|Fly|Ride"] = 140.58, ["Mega"] = 78.75, ["Mega|Ride"] = 233.63}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 4.2, ["Fly"] = 31.7, ["Ride"] = 32.71, ["Fly|Ride"] = 190.94, ["Neon"] = 9.19, ["Neon|Fly"] = 91.82, ["Neon|Ride"] = 49.32, ["Mega"] = 209.77, ["Mega|Ride"] = 85.3, ["Mega|Fly|Ride"] = 280.08}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 39.29, ["Ride"] = 18.89, ["Neon"] = 2.1, ["Neon|Fly"] = 20.99, ["Neon|Ride"] = 15.08, ["Neon|Fly|Ride"] = 31.82, ["Mega"] = 15.74, ["Mega|Ride"] = 20.37, ["Mega|Fly|Ride"] = 52.07}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 3.93, ["Fly"] = 26.25, ["Ride"] = 19.65, ["Fly|Ride"] = 138.5, ["Neon"] = 15.75, ["Neon|Ride"] = 111.58, ["Mega"] = 90.22, ["Mega|Ride"] = 125.89, ["Mega|Fly|Ride"] = 208.76}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 3.78, ["Fly|Ride"] = 140.59, ["Neon"] = 26.25, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 218.19, ["Mega|Ride"] = 276.94, ["Mega|Fly|Ride"] = 519.23}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 22.13, ["Ride"] = 13.13, ["Fly|Ride"] = 35.68, ["Neon"] = 2.63, ["Neon|Fly"] = 23.63, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 37.22, ["Mega"] = 17.43, ["Mega|Fly"] = 156.19, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 98.43}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.52, ["Fly|Ride"] = 91.88, ["Neon"] = 6.33, ["Neon|Fly"] = 77.64, ["Neon|Ride"] = 40.68, ["Neon|Fly|Ride"] = 105, ["Mega"] = 59.96, ["Mega|Ride"] = 118.13}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 28.49, ["Neon"] = 7.85, ["Neon|Fly"] = 155.27, ["Neon|Fly|Ride"] = 310.3, ["Mega"] = 26.25, ["Mega|Ride"] = 66.09, ["Mega|Fly|Ride"] = 280.08}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 40.69, ["Neon|Ride"] = 48.27, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 16.79, ["Mega|Ride"] = 69.74}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 88.13, ["Ride"] = 17.03, ["Fly|Ride"] = 41.97, ["Neon"] = 4.24, ["Neon|Ride"] = 27.28, ["Neon|Fly|Ride"] = 70.3, ["Mega"] = 94.5, ["Mega|Ride"] = 140.44}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.63, ["Ride"] = 41.95, ["Neon"] = 9.19, ["Neon|Ride"] = 148.32, ["Mega"] = 65.62, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 174.57}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 19.9, ["Fly|Ride"] = 99.68, ["Neon"] = 6.57, ["Neon|Ride"] = 39.53, ["Neon|Fly|Ride"] = 85.32, ["Mega|Fly"] = 126.48, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 17.09, ["Ride"] = 80.99, ["Mega"] = 296.63, ["Mega|Fly|Ride"] = 844.06}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Ride"] = 20.93, ["Fly|Ride"] = 5345.66, ["Neon"] = 10.5, ["Neon|Fly"] = 58.78, ["Neon|Ride"] = 28.33, ["Neon|Fly|Ride"] = 102.38, ["Mega"] = 196.17, ["Mega|Fly|Ride"] = 560.14}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 3.92, ["Fly"] = 149.1, ["Ride"] = 29.61, ["Fly|Ride"] = 141.75, ["Neon"] = 20.98, ["Neon|Fly"] = 56.66, ["Neon|Ride"] = 23.09, ["Neon|Fly|Ride"] = 78.75, ["Mega|Ride"] = 136.5, ["Mega|Fly|Ride"] = 235.73}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.63, ["Fly"] = 79.47, ["Fly|Ride"] = 104.61, ["Neon"] = 71.37, ["Neon|Ride"] = 52.5, ["Mega"] = 315}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 17.43, ["Neon"] = 98.63, ["Mega"] = 656.25, ["Mega|Fly|Ride"] = 794.07}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 9.19, ["Ride"] = 262.5, ["Fly|Ride"] = 70.3, ["Neon"] = 18.89, ["Neon|Ride"] = 41.98, ["Neon|Fly|Ride"] = 125.9, ["Mega"] = 258.05}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 6.29, ["Ride"] = 124.36, ["Neon"] = 35.44, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 102.83, ["Neon|Fly|Ride"] = 140.59, ["Mega"] = 189, ["Mega|Ride"] = 231.05, ["Mega|Fly|Ride"] = 306.3}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 4.66, ["Neon|Ride"] = 120.65, ["Mega"] = 20.48, ["Mega|Ride"] = 139.13, ["Mega|Fly|Ride"] = 141.75}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 51.19}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 6.45, ["Fly"] = 26.25, ["Ride"] = 24.82, ["Fly|Ride"] = 41.85, ["Neon"] = 42, ["Neon|Fly"] = 328.13, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 98.63, ["Mega"] = 210, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 372.38}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 18.36, ["Fly|Ride"] = 70.62, ["Neon"] = 4.22, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 449.74, ["Mega"] = 30.17, ["Mega|Ride"] = 94.5, ["Mega|Fly|Ride"] = 263.82}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 164.07, ["Fly|Ride"] = 388.16, ["Neon"] = 6.28, ["Neon|Ride"] = 40.92, ["Mega"] = 49.31, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 3.56, ["Fly"] = 45.94, ["Ride"] = 23.63, ["Fly|Ride"] = 77.64, ["Neon"] = 20.98, ["Neon|Ride"] = 57.75, ["Neon|Fly|Ride"] = 104.92, ["Mega"] = 133.76, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 310.25}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 4.07, ["Fly"] = 65.63, ["Ride"] = 49.32, ["Neon"] = 75.55, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 191.63, ["Mega"] = 393.75, ["Mega|Fly|Ride"] = 560.14}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Neon"] = 3.68, ["Neon|Ride"] = 51.15, ["Mega"] = 15.27, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 54.56, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Ride"] = 19.94, ["Fly|Ride"] = 56.99, ["Neon"] = 6.57, ["Neon|Fly"] = 30.18, ["Neon|Ride"] = 41.97, ["Neon|Fly|Ride"] = 99.68, ["Mega"] = 35.44, ["Mega|Fly"] = 98.61, ["Mega|Ride"] = 74.5, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 28.25, ["Ride"] = 20.99, ["Fly|Ride"] = 41.98, ["Neon"] = 7.87, ["Neon|Fly"] = 70.3, ["Neon|Ride"] = 23.37, ["Neon|Fly|Ride"] = 56.65, ["Mega"] = 70.3, ["Mega|Ride"] = 135.45, ["Mega|Fly|Ride"] = 138.48}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Ride"] = 21, ["Neon"] = 3.93, ["Neon|Ride"] = 48.27, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 13.13, ["Mega|Ride"] = 62.99, ["Mega|Fly|Ride"] = 102.38}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 3.81, ["Neon|Ride"] = 38.06, ["Neon|Fly|Ride"] = 125.89, ["Mega"] = 20.37, ["Mega|Fly"] = 105, ["Mega|Ride"] = 83.73, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 26.36, ["Ride"] = 21, ["Neon"] = 4.41, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 28.33, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 26.25, ["Mega|Ride"] = 60.43, ["Mega|Fly|Ride"] = 125.89}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Fly|Ride"] = 125.9, ["Mega"] = 18.38, ["Mega|Ride"] = 205.59}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 8.39, ["Neon|Ride"] = 77.88, ["Neon|Fly|Ride"] = 420, ["Mega"] = 20.98, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 24.14, ["Ride"] = 18.38, ["Neon"] = 8.34, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 59.8, ["Mega|Ride"] = 55.13, ["Mega|Fly|Ride"] = 129.07}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 7.34, ["Ride"] = 52.5, ["Fly|Ride"] = 116.46, ["Neon"] = 85.32, ["Neon|Ride"] = 78.75, ["Mega"] = 515.03, ["Mega|Ride"] = 350.36, ["Mega|Fly|Ride"] = 699.65}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.61, ["Fly"] = 6562.5, ["Ride"] = 19.69, ["Neon"] = 20.99, ["Neon|Fly|Ride"] = 110.25, ["Mega"] = 419.58, ["Mega|Ride"] = 313.04}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 9.3, ["Ride"] = 42, ["Fly|Ride"] = 419.64, ["Neon"] = 31.39, ["Neon|Ride"] = 280.11, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 265.13, ["Mega|Fly|Ride"] = 390.22}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 16.67, ["Ride"] = 7.87, ["Fly|Ride"] = 28.33, ["Neon"] = 2.1, ["Neon|Fly"] = 19.69, ["Neon|Ride"] = 15.27, ["Neon|Fly|Ride"] = 28.88, ["Mega"] = 13.96, ["Mega|Fly"] = 27.28, ["Mega|Ride"] = 23.24, ["Mega|Fly|Ride"] = 56.42}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 51.19, ["Neon"] = 15.74, ["Neon|Fly"] = 140.59, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 45.12, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 31.39, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 70.27, ["Mega"] = 18.38, ["Mega|Fly"] = 78.44, ["Mega|Ride"] = 36.73, ["Mega|Fly|Ride"] = 337.97}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 3.92, ["Neon|Fly"] = 60.9, ["Mega"] = 20.98, ["Mega|Fly|Ride"] = 280.03}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Ride"] = 24.13, ["Fly|Ride"] = 262.5, ["Neon"] = 14.44, ["Neon|Fly"] = 140.59, ["Neon|Ride"] = 41.98, ["Neon|Fly|Ride"] = 102.93, ["Mega"] = 140.6, ["Mega|Ride"] = 173.5, ["Mega|Fly|Ride"] = 411.34}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 245.44, ["Ride"] = 251.99, ["Fly|Ride"] = 839.26, ["Neon"] = 1537.92, ["Neon|Ride"] = 1059.19, ["Neon|Fly|Ride"] = 1215.69, ["Mega"] = 8391.36, ["Mega|Fly|Ride"] = 4339.91}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Fly|Ride"] = 52.5, ["Neon"] = 8.3, ["Neon|Ride"] = 68.25, ["Mega"] = 69.85, ["Mega|Ride"] = 174.13, ["Mega|Fly|Ride"] = 552.79}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 9.3, ["Fly"] = 103.68, ["Ride"] = 31.82, ["Fly|Ride"] = 140.2, ["Neon"] = 72.19, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 140.58, ["Mega|Ride"] = 699.57, ["Mega|Fly|Ride"] = 1048.93}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 839.26, ["Ride"] = 16.54, ["Fly|Ride"] = 33.08, ["Neon"] = 6.25, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 20.99, ["Neon|Fly|Ride"] = 61.69, ["Mega"] = 49.88, ["Mega|Ride"] = 77.87, ["Mega|Fly|Ride"] = 140.44}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Ride"] = 24.94, ["Fly|Ride"] = 121.7, ["Neon"] = 10.5, ["Neon|Fly"] = 41.98, ["Neon|Ride"] = 103.73, ["Mega"] = 125.89, ["Mega|Ride"] = 136.37, ["Mega|Fly|Ride"] = 208.76}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 3.75, ["Fly"] = 32.82, ["Ride"] = 22.32, ["Fly|Ride"] = 45.12, ["Neon"] = 28.59, ["Neon|Ride"] = 39.53, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 204.56, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 154.88}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 6.04, ["Ride"] = 42, ["Fly|Ride"] = 246.75, ["Neon"] = 57.75, ["Neon|Ride"] = 90.57, ["Neon|Fly|Ride"] = 623.15, ["Mega"] = 138.48, ["Mega|Ride"] = 419.58, ["Mega|Fly|Ride"] = 512.54}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 19.09, ["Fly|Ride"] = 39.38, ["Neon"] = 21.11, ["Neon|Fly"] = 70.32, ["Neon|Ride"] = 45.71, ["Neon|Fly|Ride"] = 52.49, ["Mega"] = 196.88, ["Mega|Ride"] = 419.58, ["Mega|Fly|Ride"] = 256.81}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 78.75, ["Fly"] = 78.75, ["Ride"] = 109.6, ["Fly|Ride"] = 140.59, ["Neon"] = 523.95, ["Neon|Fly"] = 394.42, ["Neon|Ride"] = 367.19, ["Neon|Fly|Ride"] = 409.5, ["Mega|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 1541.93}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 238.11, ["Fly"] = 314.73, ["Ride"] = 240.19, ["Fly|Ride"] = 280.14, ["Neon"] = 1007.1, ["Neon|Ride"] = 1119.35, ["Neon|Fly|Ride"] = 979.82, ["Mega"] = 10489.2, ["Mega|Fly|Ride"] = 4891.13}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 73.5, ["Fly"] = 116.22, ["Ride"] = 92.58, ["Fly|Ride"] = 118.12, ["Neon"] = 418.59, ["Neon|Ride"] = 305.59, ["Neon|Fly|Ride"] = 375.38, ["Mega|Fly|Ride"] = 1273.13}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 2.1, ["Ride"] = 40.93, ["Neon"] = 124.35, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 196.2, ["Mega"] = 586.36, ["Mega|Ride"] = 217.3, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 13.12, ["Ride"] = 31.49, ["Fly|Ride"] = 78.73, ["Neon"] = 83.69, ["Neon|Ride"] = 140.59, ["Neon|Fly|Ride"] = 209.83, ["Mega"] = 482.23, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 608.39}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 31.49, ["Ride"] = 22.32, ["Fly|Ride"] = 46.5, ["Neon"] = 8.42, ["Neon|Fly"] = 51.18, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 36.75, ["Mega|Fly"] = 116.21, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 180.44}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 9.19, ["Fly"] = 288.5, ["Ride"] = 19.69, ["Fly|Ride"] = 104.92, ["Neon"] = 41.11, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 407.4, ["Mega"] = 512.44, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 419.58}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 18.88, ["Fly|Ride"] = 38.07, ["Neon"] = 13.71, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 32.52, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 131.24, ["Mega|Ride"] = 230.21, ["Mega|Fly|Ride"] = 218.19}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 4.99, ["Ride"] = 26.25, ["Fly|Ride"] = 328.13, ["Neon"] = 18.95, ["Neon|Ride"] = 56.65, ["Mega"] = 157.5}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 28.35, ["Neon"] = 2.1, ["Neon|Ride"] = 23.09, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 17.07, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 209151.56}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 3.82, ["Fly"] = 45.93, ["Ride"] = 31.49, ["Fly|Ride"] = 56.44, ["Neon"] = 19.95, ["Neon|Fly"] = 70.3, ["Neon|Ride"] = 56.91, ["Neon|Fly|Ride"] = 87.17, ["Mega"] = 155.72, ["Mega|Ride"] = 110.25, ["Mega|Fly|Ride"] = 155.72}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 3.12, ["Ride"] = 18.02, ["Neon"] = 62.76, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 560.2, ["Mega"] = 182.53, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 271.69}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 118.13, ["Fly"] = 245.37, ["Ride"] = 157.5, ["Fly|Ride"] = 258.57, ["Neon"] = 525, ["Neon|Ride"] = 586.43, ["Neon|Fly|Ride"] = 558.16, ["Mega|Fly|Ride"] = 1903.13}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 6.78, ["Ride"] = 240.91, ["Fly|Ride"] = 204.59, ["Neon"] = 39.53, ["Neon|Ride"] = 291.38, ["Neon|Fly|Ride"] = 152.25, ["Mega"] = 414.75, ["Mega|Ride"] = 392.32, ["Mega|Fly|Ride"] = 662.85}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 6.04, ["Ride"] = 26.24, ["Fly|Ride"] = 50.37, ["Neon"] = 21, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 91.28, ["Mega"] = 141.75, ["Mega|Ride"] = 248.67, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 26.24, ["Ride"] = 139.54, ["Fly|Ride"] = 131.25, ["Neon"] = 90.57, ["Neon|Ride"] = 138.49, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 524.48, ["Mega|Ride"] = 453.15, ["Mega|Fly|Ride"] = 576.19}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 6.25}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 4.99, ["Ride"] = 27.57, ["Neon"] = 72.19, ["Neon|Fly|Ride"] = 629.45, ["Mega"] = 839.15, ["Mega|Ride"] = 419.58, ["Mega|Fly|Ride"] = 532.14}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 31.49, ["Fly"] = 56.66, ["Ride"] = 42.88, ["Fly|Ride"] = 56.69, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 125.9, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 2097.85, ["Mega|Fly|Ride"] = 653.49}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 4.2, ["Neon|Ride"] = 28.35, ["Mega"] = 28.01, ["Mega|Ride"] = 77.64, ["Mega|Fly|Ride"] = 238.11}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 3.93, ["Fly"] = 34.13, ["Ride"] = 28.33, ["Fly|Ride"] = 77.64, ["Neon"] = 39.38, ["Neon|Ride"] = 232.43, ["Mega"] = 145.82, ["Mega|Fly"] = 388.12, ["Mega|Ride"] = 161.47, ["Mega|Fly|Ride"] = 196.17}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 70.3, ["Ride"] = 20.37, ["Fly|Ride"] = 61.73, ["Neon"] = 19.69, ["Neon|Ride"] = 36.01, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 116.82, ["Mega|Fly"] = 138.48, ["Mega|Ride"] = 120.75, ["Mega|Fly|Ride"] = 234.86}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Neon"] = 4.2, ["Neon|Ride"] = 39.38, ["Mega"] = 33.57, ["Mega|Ride"] = 636.57, ["Mega|Fly|Ride"] = 207.69}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 31.82, ["Ride"] = 87.08, ["Neon"] = 208.74, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 216.12, ["Mega"] = 825.51, ["Mega|Ride"] = 818.18, ["Mega|Fly|Ride"] = 903}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 4.19, ["Ride"] = 36.75, ["Fly|Ride"] = 209.99, ["Neon"] = 46.38, ["Neon|Ride"] = 77.64}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 10.5, ["Fly"] = 96.96, ["Ride"] = 42.72, ["Fly|Ride"] = 171.94, ["Neon"] = 39.38, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 84.69, ["Neon|Fly|Ride"] = 140.59, ["Mega"] = 321.56, ["Mega|Ride"] = 419.63, ["Mega|Fly|Ride"] = 434.59}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 74.49, ["Fly"] = 140.59, ["Ride"] = 105, ["Fly|Ride"] = 350.4, ["Neon"] = 426.57, ["Neon|Ride"] = 464.85, ["Mega|Fly|Ride"] = 2097.85}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 11.54, ["Ride"] = 56.66, ["Fly|Ride"] = 254.37, ["Neon"] = 85.32, ["Neon|Ride"] = 98.6, ["Neon|Fly|Ride"] = 419.64, ["Mega"] = 400.31, ["Mega|Ride"] = 418.69, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 93.6, ["Ride"] = 123.12, ["Fly|Ride"] = 199.5, ["Neon"] = 262.5, ["Neon|Ride"] = 408.18, ["Neon|Fly|Ride"] = 351.75, ["Mega"] = 909.43, ["Mega|Ride"] = 1085.27, ["Mega|Fly|Ride"] = 1026.9}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 35.22, ["Ride"] = 48.28, ["Fly|Ride"] = 232.4, ["Neon"] = 102.38, ["Neon|Ride"] = 104.92, ["Neon|Fly|Ride"] = 209.83, ["Mega"] = 462.47, ["Mega|Ride"] = 430.38, ["Mega|Fly|Ride"] = 538.78}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 8.93, ["Fly"] = 52.5, ["Ride"] = 27.28, ["Neon"] = 37.41, ["Neon|Ride"] = 93.35, ["Neon|Fly|Ride"] = 125.9, ["Mega"] = 330.01, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 39.48, ["Fly|Ride"] = 131.25, ["Neon"] = 105, ["Neon|Ride"] = 139.47, ["Neon|Fly|Ride"] = 198.18, ["Mega"] = 260.17, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 588}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 13.12, ["Ride"] = 65.06, ["Fly|Ride"] = 95.53, ["Neon|Fly"] = 112.26, ["Neon|Ride"] = 73.5, ["Neon|Fly|Ride"] = 280.08, ["Mega"] = 264.34, ["Mega|Ride"] = 567, ["Mega|Fly|Ride"] = 371.33}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 26.25, ["Mega"] = 15.74, ["Mega|Fly"] = 140.58, ["Mega|Ride"] = 66.94, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 3.14, ["Ride"] = 104.92, ["Neon"] = 13.64, ["Neon|Ride"] = 83.83, ["Mega"] = 99.62, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 419.58}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.63, ["Neon"] = 22.23, ["Neon|Ride"] = 103.69, ["Mega"] = 336}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 6.36, ["Ride"] = 31.49, ["Fly|Ride"] = 116.22, ["Neon"] = 27.54, ["Neon|Ride"] = 82.95, ["Neon|Fly|Ride"] = 279.06, ["Mega"] = 123.38, ["Mega|Ride"] = 377.63, ["Mega|Fly|Ride"] = 508.6}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 548.63, ["Ride"] = 587.48, ["Fly|Ride"] = 610.32, ["Neon|Ride"] = 1777.1, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 5878.95}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 8.4, ["Fly"] = 56.65, ["Ride"] = 30.55, ["Fly|Ride"] = 72.07, ["Neon"] = 37.78, ["Neon|Ride"] = 83.94, ["Mega|Ride"] = 280.08}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 6.29, ["Fly"] = 31.5, ["Ride"] = 43.32, ["Neon"] = 419.64, ["Neon|Fly"] = 315, ["Neon|Ride"] = 64.32, ["Mega"] = 365.04, ["Mega|Ride"] = 310.25, ["Mega|Fly|Ride"] = 464.8}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 2.1, ["Fly"] = 28.33, ["Ride"] = 23.21, ["Fly|Ride"] = 314.73, ["Neon|Ride"] = 155.74, ["Mega"] = 223.13, ["Mega|Ride"] = 354.38, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 25.93, ["Fly|Ride"] = 941.48, ["Neon"] = 8.17, ["Neon|Ride"] = 39.26, ["Neon|Fly|Ride"] = 125.9, ["Mega"] = 65.63, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 233.63}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Ride"] = 17.07, ["Neon"] = 3.26, ["Neon|Ride"] = 57.75, ["Neon|Fly|Ride"] = 116.21, ["Mega"] = 20.93, ["Mega|Ride"] = 81.38, ["Mega|Fly|Ride"] = 209.81}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1239.82}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 28.35, ["Fly"] = 56.66, ["Ride"] = 41.27, ["Fly|Ride"] = 139.47, ["Neon"] = 58.76, ["Neon|Fly"] = 140.59, ["Neon|Ride"] = 140.59, ["Neon|Fly|Ride"] = 419.64, ["Mega"] = 497.2, ["Mega|Ride"] = 557.46, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 45.36, ["Neon"] = 13.13, ["Neon|Ride"] = 74.39, ["Mega"] = 54.56, ["Mega|Ride"] = 90.22, ["Mega|Fly|Ride"] = 232.4}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.63, ["Ride"] = 27.43, ["Fly|Ride"] = 525, ["Neon"] = 10.5, ["Neon|Ride"] = 70.3, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 155.26, ["Mega|Ride"] = 154.88, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 393.75, ["Ride"] = 515.09, ["Fly|Ride"] = 552.86, ["Neon|Ride"] = 1573.59, ["Neon|Fly|Ride"] = 1468.68, ["Mega|Fly|Ride"] = 7692.79}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 11.21, ["Fly"] = 196.88, ["Ride"] = 72.19, ["Neon"] = 57.75, ["Mega"] = 399}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Neon"] = 4.82, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 99.68, ["Mega"] = 31.49, ["Mega|Fly"] = 155.72, ["Mega|Ride"] = 77.64, ["Mega|Fly|Ride"] = 197.14}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 4.22, ["Neon|Ride"] = 59.07, ["Mega"] = 24.94, ["Mega|Ride"] = 83.66, ["Mega|Fly|Ride"] = 391.65}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 13.99, ["Fly"] = 78.69, ["Ride"] = 111.57, ["Fly|Ride"] = 83.94, ["Neon"] = 41.13, ["Neon|Ride"] = 207.38, ["Neon|Fly|Ride"] = 310.53, ["Mega"] = 328.13, ["Mega|Ride"] = 280.08, ["Mega|Fly|Ride"] = 363.99}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 10.5, ["Ride"] = 140.59, ["Fly|Ride"] = 131.25, ["Neon"] = 91.7, ["Neon|Ride"] = 62.95, ["Neon|Fly|Ride"] = 839.26, ["Mega"] = 1258.72, ["Mega|Ride"] = 497.33, ["Mega|Fly|Ride"] = 1066.42}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 5.94, ["Fly|Ride"] = 140.59, ["Neon"] = 280.11, ["Neon|Ride"] = 208.78, ["Mega"] = 582.75, ["Mega|Fly|Ride"] = 1231.44}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 48.57, ["Ride"] = 65.06, ["Neon"] = 140.59, ["Neon|Ride"] = 132.49, ["Neon|Fly|Ride"] = 775.13, ["Mega|Ride"] = 523.43, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 347.82, ["Ride"] = 367.5, ["Fly|Ride"] = 441.61, ["Neon"] = 2937.35, ["Neon|Ride"] = 1119.35, ["Neon|Fly|Ride"] = 1168.5, ["Mega"] = 3532.78, ["Mega|Fly|Ride"] = 3150}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 6.28, ["Ride"] = 44.63, ["Fly|Ride"] = 82.53, ["Neon"] = 59.07, ["Neon|Ride"] = 98.63, ["Neon|Fly|Ride"] = 140.59, ["Mega|Ride"] = 503.5, ["Mega|Fly|Ride"] = 762.58}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 5.25, ["Ride"] = 41.97, ["Mega"] = 1258.72, ["Mega|Fly|Ride"] = 560.14}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 10.87, ["Fly"] = 26.25, ["Ride"] = 28.33, ["Fly|Ride"] = 79.74, ["Neon"] = 28.35, ["Neon|Ride"] = 90.66, ["Mega"] = 170.63, ["Mega|Ride"] = 231.82, ["Mega|Fly|Ride"] = 357.67}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.1, ["Ride"] = 31.5, ["Fly|Ride"] = 108.07, ["Neon"] = 11.81, ["Neon|Ride"] = 44.23, ["Mega"] = 38.06, ["Mega|Ride"] = 98.61, ["Mega|Fly|Ride"] = 155.72}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 45.83, ["Ride"] = 72.19, ["Neon"] = 261.18, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 464.85, ["Mega"] = 2493.75, ["Mega|Ride"] = 1001.73, ["Mega|Fly|Ride"] = 1073.05}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 581.05, ["Ride"] = 32.54, ["Fly|Ride"] = 65.63, ["Neon"] = 12.55, ["Neon|Fly"] = 182.55, ["Neon|Ride"] = 54.55, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 78.91, ["Mega|Ride"] = 120.75, ["Mega|Fly|Ride"] = 308.16}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 28.33, ["Ride"] = 30.23, ["Fly|Ride"] = 148.25, ["Neon"] = 7.87, ["Neon|Ride"] = 41.98, ["Neon|Fly|Ride"] = 140.38, ["Mega"] = 42.75, ["Mega|Fly"] = 91.27, ["Mega|Ride"] = 60.38, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Fly"] = 1519.88, ["Ride"] = 24.94, ["Fly|Ride"] = 262.5, ["Neon"] = 15.74, ["Neon|Ride"] = 31.39, ["Neon|Fly|Ride"] = 140.59, ["Mega"] = 118.54, ["Mega|Ride"] = 190.32, ["Mega|Fly|Ride"] = 250.71}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 56.65, ["Fly"] = 81.38, ["Ride"] = 97.13, ["Fly|Ride"] = 109.26, ["Neon"] = 309.48, ["Neon|Ride"] = 335.71, ["Neon|Fly|Ride"] = 692.35, ["Mega|Ride"] = 910.48, ["Mega|Fly|Ride"] = 901.69}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 271.69, ["Ride"] = 343.88, ["Fly|Ride"] = 462.66, ["Neon|Ride"] = 1099.88, ["Neon|Fly|Ride"] = 1341.85, ["Mega"] = 6993.16, ["Mega|Fly|Ride"] = 5704.04}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 3.81, ["Neon"] = 31.4, ["Mega"] = 83.93, ["Mega|Ride"] = 186.94, ["Mega|Fly|Ride"] = 388.49}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 5.24, ["Neon"] = 26.52, ["Mega"] = 139.13, ["Mega|Ride"] = 278.25, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 3.81, ["Fly"] = 155.57, ["Neon"] = 42, ["Mega"] = 488.92}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 53.23, ["Ride"] = 34.13, ["Fly|Ride"] = 32.82, ["Neon"] = 6.57, ["Neon|Ride"] = 25.41, ["Neon|Fly|Ride"] = 182.55, ["Mega"] = 51.07, ["Mega|Ride"] = 139.46, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 36.71, ["Neon"] = 10.5, ["Mega"] = 28.32, ["Mega|Ride"] = 206.07}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 65.54, ["Ride"] = 19.94, ["Fly|Ride"] = 59.07, ["Neon"] = 5.25, ["Neon|Ride"] = 44.18, ["Neon|Fly|Ride"] = 105, ["Mega"] = 34.13, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 155.26}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 27.9, ["Fly|Ride"] = 54.64, ["Neon"] = 17.07, ["Neon|Fly"] = 98.63, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 90.23, ["Mega"] = 139.46, ["Mega|Ride"] = 200.36, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 49.88, ["Ride"] = 70.88, ["Neon"] = 119.61, ["Neon|Ride"] = 155.74, ["Mega"] = 367.5, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 615.8}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 61.01, ["Fly"] = 582.75, ["Ride"] = 98.44, ["Fly|Ride"] = 182.55, ["Neon"] = 419.64, ["Neon|Ride"] = 414.39, ["Mega"] = 3098.95, ["Mega|Ride"] = 1804.16, ["Mega|Fly|Ride"] = 1704.61}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 33.59, ["Fly|Ride"] = 41.98, ["Neon"] = 3.93, ["Neon|Ride"] = 70.3, ["Neon|Fly|Ride"] = 359.63, ["Mega"] = 41.97, ["Mega|Ride"] = 125.89, ["Mega|Fly|Ride"] = 318.4}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 16.77, ["Ride"] = 18.88, ["Fly|Ride"] = 49.32, ["Neon"] = 3.94, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 50.67, ["Mega"] = 38.06, ["Mega|Fly"] = 157.5, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 3.82, ["Ride"] = 41.97, ["Neon"] = 125.9, ["Neon|Ride"] = 138.49, ["Neon|Fly|Ride"] = 274.86, ["Mega"] = 615.72, ["Mega|Ride"] = 629.37, ["Mega|Fly|Ride"] = 471.19}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 251.76, ["Fly"] = 346.2, ["Ride"] = 402.85, ["Fly|Ride"] = 280.11, ["Neon"] = 1007.1, ["Neon|Ride"] = 1049.06, ["Neon|Fly|Ride"] = 1519.03, ["Mega|Fly|Ride"] = 5577.39}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 29.16, ["Fly"] = 209.9, ["Ride"] = 72.19, ["Fly|Ride"] = 94.42, ["Neon"] = 278.25, ["Neon|Ride"] = 321.02, ["Neon|Fly|Ride"] = 393.75, ["Mega|Ride"] = 979.71, ["Mega|Fly|Ride"] = 826.88}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 31.44, ["Neon"] = 12.44, ["Neon|Ride"] = 44.07, ["Neon|Fly|Ride"] = 77.88, ["Mega"] = 101.07, ["Mega|Ride"] = 140.58, ["Mega|Fly|Ride"] = 209.81}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 3.93, ["Fly"] = 209.83, ["Ride"] = 83.94, ["Fly|Ride"] = 142.7, ["Neon"] = 19.65, ["Neon|Ride"] = 188.84, ["Mega"] = 211.32, ["Mega|Ride"] = 434.59}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 26.13, ["Fly"] = 77.64, ["Ride"] = 53.37, ["Fly|Ride"] = 65.63, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 2517.42, ["Mega|Ride"] = 904.32, ["Mega|Fly|Ride"] = 1081.44}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 87.07, ["Ride"] = 105, ["Fly|Ride"] = 280.11, ["Neon"] = 523.48, ["Neon|Ride"] = 469.88, ["Neon|Fly|Ride"] = 610.32, ["Mega"] = 3077.54, ["Mega|Fly|Ride"] = 6293.53}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 217.88, ["Fly"] = 499.36, ["Ride"] = 292.69, ["Fly|Ride"] = 350.4, ["Neon"] = 1029.13, ["Neon|Fly|Ride"] = 916.13, ["Mega|Fly|Ride"] = 3149.92}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 16.53, ["Ride"] = 41.98, ["Fly|Ride"] = 207.73, ["Neon"] = 111.57, ["Neon|Ride"] = 115.5, ["Mega"] = 421.32, ["Mega|Ride"] = 435.75, ["Mega|Fly|Ride"] = 519.23}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 28.33, ["Ride"] = 17.07, ["Fly|Ride"] = 47.25, ["Neon"] = 5.25, ["Neon|Ride"] = 41.98, ["Neon|Fly|Ride"] = 75.55, ["Mega"] = 112.28, ["Mega|Ride"] = 83.98, ["Mega|Fly|Ride"] = 167.84}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 2.1, ["Ride"] = 26.75, ["Fly|Ride"] = 56.65, ["Neon"] = 23.09, ["Neon|Ride"] = 46.98, ["Neon|Fly|Ride"] = 109.26, ["Mega"] = 250.79, ["Mega|Ride"] = 241.5, ["Mega|Fly|Ride"] = 259.87}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 296.63, ["Ride"] = 443.93, ["Fly|Ride"] = 485.72, ["Neon|Ride"] = 1468.31, ["Neon|Fly|Ride"] = 1525.34}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 46.17, ["Neon"] = 11.64, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 32.82, ["Mega|Ride"] = 157.36}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 3.93, ["Fly"] = 10.5, ["Ride"] = 22.32, ["Fly|Ride"] = 65.09, ["Neon"] = 24.08, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 110.25, ["Mega"] = 172.4, ["Mega|Ride"] = 222.38, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 23.26, ["Ride"] = 98.63, ["Neon"] = 140.59, ["Neon|Fly|Ride"] = 537.13, ["Mega"] = 519.23, ["Mega|Ride"] = 524.48, ["Mega|Fly|Ride"] = 566.44}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 65.63, ["Fly"] = 98.44, ["Ride"] = 118.13, ["Fly|Ride"] = 155.74, ["Neon|Ride"] = 699.74, ["Neon|Fly|Ride"] = 670.69, ["Mega|Fly|Ride"] = 1749.62}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 24.13, ["Fly"] = 81.36, ["Ride"] = 28.67, ["Fly|Ride"] = 59.81, ["Neon"] = 66.94, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 699.65, ["Mega|Ride"] = 419.58, ["Mega|Fly|Ride"] = 531.57}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 56.66, ["Neon"] = 3.82, ["Neon|Ride"] = 48.27, ["Neon|Fly|Ride"] = 178.27, ["Mega"] = 18.38, ["Mega|Ride"] = 309.44, ["Mega|Fly|Ride"] = 419.58}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Fly|Ride"] = 52.5, ["Neon"] = 3.93, ["Neon|Fly"] = 31.39, ["Neon|Ride"] = 28.33, ["Neon|Fly|Ride"] = 69.18, ["Mega"] = 24.94, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 145.82}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 12.73, ["Ride"] = 74.82, ["Fly|Ride"] = 165.38, ["Neon"] = 31.49, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 70.3, ["Neon|Fly|Ride"] = 162.71, ["Mega"] = 152.24, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1433.25, ["Ride"] = 1443.75, ["Fly|Ride"] = 1631.28, ["Neon"] = 5245.25, ["Neon|Fly|Ride"] = 5538.99, ["Mega|Fly|Ride"] = 13650}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 539.44, ["Ride"] = 525, ["Fly|Ride"] = 838.21, ["Neon|Ride"] = 2479.93, ["Neon|Fly|Ride"] = 2502.94, ["Mega"] = 16782.71, ["Mega|Fly|Ride"] = 6971.73}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 343.14, ["Fly"] = 531.88, ["Ride"] = 357, ["Fly|Ride"] = 461.93, ["Neon"] = 735, ["Neon|Ride"] = 834.01, ["Neon|Fly|Ride"] = 838.69, ["Mega|Fly|Ride"] = 2559.38}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 167.84, ["Fly"] = 419.44, ["Ride"] = 380.63, ["Fly|Ride"] = 466.73, ["Neon"] = 945, ["Neon|Fly"] = 1119.35, ["Neon|Ride"] = 1049.06, ["Neon|Fly|Ride"] = 1085.41, ["Mega|Ride"] = 3675, ["Mega|Fly|Ride"] = 2961.11}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 79.74, ["Ride"] = 20.94, ["Fly|Ride"] = 44.62, ["Neon"] = 6.98, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 77.64, ["Mega"] = 70.3, ["Mega|Ride"] = 112.88, ["Mega|Fly|Ride"] = 185.93}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 318.28, ["Fly"] = 590.62, ["Ride"] = 404.25, ["Fly|Ride"] = 525, ["Neon"] = 944.15, ["Neon|Ride"] = 787.49, ["Neon|Fly|Ride"] = 1049.99, ["Mega"] = 8251.86, ["Mega|Ride"] = 6562.5, ["Mega|Fly|Ride"] = 3543.75}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 3.93, ["Fly"] = 183.75, ["Ride"] = 140.59, ["Neon"] = 13.13, ["Neon|Ride"] = 53.59, ["Neon|Fly|Ride"] = 112.72, ["Mega"] = 67.95, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 272.35}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 20.35, ["Ride"] = 31.49, ["Fly|Ride"] = 28.87, ["Neon"] = 7.86, ["Neon|Ride"] = 61.69, ["Neon|Fly|Ride"] = 110.25, ["Mega"] = 124.84, ["Mega|Ride"] = 137.42, ["Mega|Fly|Ride"] = 203.51}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Neon"] = 5.25, ["Mega"] = 23.63, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 53.82, ["Ride"] = 65.63, ["Fly|Ride"] = 459.38, ["Neon"] = 244.13, ["Neon|Ride"] = 310.3, ["Mega"] = 2097.85, ["Mega|Ride"] = 929.58, ["Mega|Fly|Ride"] = 944.05}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 6.3, ["Fly"] = 65.61, ["Ride"] = 19.69, ["Neon"] = 104.61, ["Mega"] = 328.13, ["Mega|Ride"] = 316.79}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 53.82, ["Neon"] = 3.42, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 19.69, ["Mega|Fly"] = 155.72, ["Mega|Ride"] = 155.72, ["Mega|Fly|Ride"] = 140.44}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.37, ["Ride"] = 22.32, ["Fly|Ride"] = 49.88, ["Neon"] = 7.87, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 28.33, ["Neon|Fly|Ride"] = 71.99, ["Mega"] = 102.3, ["Mega|Fly"] = 232.4, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 171.98}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 5.25, ["Fly"] = 46.96, ["Ride"] = 56.96, ["Fly|Ride"] = 55.26, ["Neon"] = 101.11, ["Neon|Fly"] = 44.18, ["Neon|Ride"] = 140.59, ["Neon|Fly|Ride"] = 251.78, ["Mega"] = 237.57, ["Mega|Ride"] = 140.58, ["Mega|Fly|Ride"] = 1019.82}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 15.73, ["Ride"] = 52.41, ["Mega"] = 464.8, ["Mega|Ride"] = 333.57, ["Mega|Fly|Ride"] = 519.23}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 4.19, ["Ride"] = 52.5, ["Fly|Ride"] = 87.94, ["Neon"] = 36.73, ["Neon|Ride"] = 155.74, ["Neon|Fly|Ride"] = 697.27, ["Mega"] = 279.57, ["Mega|Ride"] = 464.8, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 100.73, ["Ride"] = 19.94, ["Fly|Ride"] = 84, ["Neon"] = 3.93, ["Neon|Ride"] = 28.33, ["Mega"] = 40.69, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 314.7}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 209.85, ["Fly"] = 293.74, ["Ride"] = 202.21, ["Fly|Ride"] = 284.81, ["Neon"] = 1161.83, ["Neon|Fly"] = 1329.16, ["Neon|Ride"] = 1239.97, ["Neon|Fly|Ride"] = 1245.23, ["Mega"] = 8391.36, ["Mega|Fly|Ride"] = 3776.13}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Ride"] = 18.32, ["Fly|Ride"] = 32.54, ["Neon"] = 4.66, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 61.89, ["Mega"] = 40.69, ["Mega|Ride"] = 74.59, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 12.39, ["Ride"] = 98.44, ["Fly|Ride"] = 94.5, ["Neon"] = 65.06, ["Neon|Ride"] = 104.41, ["Mega"] = 315, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 413.44}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 44.37, ["Ride"] = 109.26, ["Neon"] = 155.67, ["Neon|Ride"] = 309.12, ["Mega"] = 753.63, ["Mega|Ride"] = 796.15, ["Mega|Fly|Ride"] = 858.03}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 175.88, ["Ride"] = 210, ["Fly|Ride"] = 288.96, ["Neon"] = 775.69, ["Neon|Ride"] = 808.5, ["Neon|Fly|Ride"] = 805.68, ["Mega|Fly|Ride"] = 3406.91}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 14.44, ["Neon"] = 123.38, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 415.42, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 699.65}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 27.5, ["Ride"] = 118.12, ["Fly|Ride"] = 629.45, ["Neon"] = 205.64, ["Neon|Ride"] = 313.68, ["Neon|Fly|Ride"] = 839.26, ["Mega"] = 867.47, ["Mega|Ride"] = 838.1, ["Mega|Fly|Ride"] = 2097.85}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 1148.44, ["Fly"] = 1441.13, ["Ride"] = 1115.63, ["Fly|Ride"] = 1246.88, ["Neon"] = 4336.77, ["Neon|Ride"] = 5906.25, ["Neon|Fly|Ride"] = 4315.49, ["Mega|Fly|Ride"] = 16321.19}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 6.36, ["Fly"] = 43.32, ["Ride"] = 21.6, ["Fly|Ride"] = 62.35, ["Neon"] = 49.32, ["Neon|Fly"] = 75.06, ["Neon|Ride"] = 41.98, ["Neon|Fly|Ride"] = 105, ["Mega"] = 246.79, ["Mega|Ride"] = 253.32, ["Mega|Fly|Ride"] = 402.8}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 5.09, ["Fly"] = 13847.44, ["Ride"] = 34.13, ["Neon"] = 41.98, ["Neon|Ride"] = 165.77, ["Neon|Fly|Ride"] = 144.74, ["Mega"] = 212.63, ["Mega|Ride"] = 217.88, ["Mega|Fly|Ride"] = 320.25}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Ride"] = 26.24, ["Fly|Ride"] = 91.28, ["Neon"] = 15.75, ["Neon|Ride"] = 77.88, ["Neon|Fly|Ride"] = 310.3, ["Mega"] = 193.02, ["Mega|Ride"] = 253.85, ["Mega|Fly|Ride"] = 699.65}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 21.15, ["Fly"] = 40.69, ["Ride"] = 40.69, ["Fly|Ride"] = 88.13, ["Neon"] = 65.63, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 209.83, ["Mega"] = 380.63, ["Mega|Ride"] = 383.25, ["Mega|Fly|Ride"] = 608.39}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 3.93, ["Fly"] = 35.68, ["Ride"] = 31.39, ["Fly|Ride"] = 65.63, ["Neon"] = 36.04, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 83.98, ["Mega"] = 348.25, ["Mega|Fly|Ride"] = 211.45}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Ride"] = 45.94, ["Neon"] = 10.5, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 95.47, ["Mega"] = 111.56, ["Mega|Ride"] = 242.8, ["Mega|Fly|Ride"] = 350.36}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 140.58, ["Ride"] = 291.64, ["Fly|Ride"] = 539.23, ["Neon"] = 840, ["Neon|Ride"] = 1693.13, ["Neon|Fly|Ride"] = 1394.53, ["Mega|Fly|Ride"] = 3821.23}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 3.29, ["Ride"] = 25.58, ["Fly|Ride"] = 54.29, ["Neon"] = 10.49, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 41.89, ["Mega"] = 91.88, ["Mega|Ride"] = 147.52, ["Mega|Fly|Ride"] = 209.81}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 15.63, ["Neon"] = 77.42, ["Mega"] = 140.58}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 4.19, ["Fly"] = 58.12, ["Ride"] = 40.69, ["Neon"] = 15.74, ["Neon|Ride"] = 28.32, ["Mega"] = 104.95, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 346.5}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 131.24, ["Fly"] = 354.9, ["Ride"] = 281.96, ["Fly|Ride"] = 686.09, ["Neon"] = 459.38, ["Neon|Ride"] = 629.45, ["Neon|Fly|Ride"] = 698.69, ["Mega"] = 3566.34, ["Mega|Fly|Ride"] = 2517.42}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 33.12, ["Ride"] = 56.66, ["Fly|Ride"] = 524.53, ["Neon"] = 140.6, ["Neon|Ride"] = 138.49, ["Neon|Fly|Ride"] = 285.89, ["Mega"] = 629.37, ["Mega|Ride"] = 667.13, ["Mega|Fly|Ride"] = 713.28}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 25.18, ["Ride"] = 39.38, ["Neon"] = 118.56, ["Neon|Ride"] = 155.27, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 671.4, ["Mega|Ride"] = 489.86, ["Mega|Fly|Ride"] = 501.38}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 35.44, ["Mega"] = 24.13, ["Mega|Ride"] = 74.8, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 70.01, ["Fly"] = 108.15, ["Ride"] = 131.25, ["Fly|Ride"] = 254.63, ["Neon"] = 341.25, ["Neon|Fly"] = 301.88, ["Neon|Ride"] = 380.34, ["Neon|Fly|Ride"] = 452.82, ["Mega|Fly|Ride"] = 948.94}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 20.03, ["Neon"] = 4.6, ["Neon|Fly|Ride"] = 588, ["Mega"] = 45.94}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 45.94, ["Fly"] = 140.59, ["Ride"] = 45.94, ["Fly|Ride"] = 109.26, ["Neon"] = 98.6, ["Neon|Ride"] = 72.17, ["Neon|Fly|Ride"] = 112.88, ["Mega"] = 398.61, ["Mega|Ride"] = 397.56, ["Mega|Fly|Ride"] = 350.44}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 38.19, ["Ride"] = 52.5, ["Fly|Ride"] = 115.5, ["Neon|Ride"] = 419.64, ["Neon|Fly|Ride"] = 311.07, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 15.75, ["Fly|Ride"] = 48.27, ["Neon"] = 2.63, ["Neon|Fly"] = 41.98, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 62.93, ["Mega"] = 21, ["Mega|Fly"] = 56.65, ["Mega|Ride"] = 45.09, ["Mega|Fly|Ride"] = 103.94}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 5.25, ["Ride"] = 83.94, ["Fly|Ride"] = 1346.59, ["Neon"] = 18.35, ["Neon|Ride"] = 101.11, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 164.07, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 515.17}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 27.9, ["Ride"] = 72.19, ["Neon"] = 412.18, ["Neon|Ride"] = 207.73, ["Neon|Fly|Ride"] = 620.58, ["Mega"] = 512.44, ["Mega|Ride"] = 581.12, ["Mega|Fly|Ride"] = 619.92}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 23.09, ["Neon"] = 3.29, ["Neon|Ride"] = 70.3, ["Neon|Fly|Ride"] = 125.89, ["Mega"] = 27.28, ["Mega|Ride"] = 140.58, ["Mega|Fly|Ride"] = 410.17}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 4.99, ["Fly"] = 210, ["Ride"] = 23.63, ["Fly|Ride"] = 98.44, ["Neon"] = 47.25, ["Neon|Ride"] = 98.63, ["Neon|Fly|Ride"] = 182.55, ["Mega"] = 207.69, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 375.89}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 18.38, ["Fly"] = 41.98, ["Ride"] = 31.39, ["Fly|Ride"] = 62.76, ["Neon|Ride"] = 101.73, ["Mega|Fly|Ride"] = 469.93}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 3.94, ["Ride"] = 91.87, ["Neon"] = 28.33, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 200.82, ["Mega"] = 169.32, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 293.71}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 52.5, ["Fly"] = 2098.11, ["Neon"] = 84, ["Neon|Ride"] = 620.58, ["Neon|Fly|Ride"] = 6197.47, ["Mega"] = 539.16, ["Mega|Ride"] = 799.98, ["Mega|Fly|Ride"] = 692.3}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Ride"] = 140.58, ["Fly|Ride"] = 126.48, ["Neon"] = 7.87, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 99.08, ["Mega"] = 74.82, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 140.58, ["Mega|Fly|Ride"] = 288.74}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 28.33, ["Neon"] = 5.25, ["Neon|Ride"] = 41.98, ["Mega"] = 26.25, ["Mega|Ride"] = 137.42, ["Mega|Fly|Ride"] = 162.6}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 41.97}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 70.27, ["Fly"] = 92.33, ["Ride"] = 52.5, ["Fly|Ride"] = 116.46, ["Neon"] = 1050, ["Neon|Fly|Ride"] = 1049.06, ["Mega"] = 979.71, ["Mega|Ride"] = 977.62, ["Mega|Fly|Ride"] = 839.15}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 140.59, ["Neon"] = 3.82, ["Neon|Ride"] = 26.75, ["Mega"] = 23.63, ["Mega|Ride"] = 104.89, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 503.5, ["Ride"] = 775.13, ["Fly|Ride"] = 656.25, ["Neon"] = 2625, ["Mega"] = 16782.71, ["Mega|Fly|Ride"] = 10489.2}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 262.5, ["Fly"] = 49.88, ["Ride"] = 40.94, ["Fly|Ride"] = 54.64, ["Mega|Fly|Ride"] = 560.14}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 3.82, ["Ride"] = 23.82, ["Fly|Ride"] = 54.56, ["Neon"] = 32.54, ["Neon|Ride"] = 35.48, ["Neon|Fly|Ride"] = 57.75, ["Mega"] = 196.17, ["Mega|Ride"] = 174.57, ["Mega|Fly|Ride"] = 182.44}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 16.9, ["Ride"] = 76.13, ["Fly|Ride"] = 106.32, ["Neon"] = 115.59, ["Neon|Ride"] = 249.68, ["Neon|Fly|Ride"] = 140.59, ["Mega"] = 1036.34, ["Mega|Ride"] = 909.43, ["Mega|Fly|Ride"] = 1258.72}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 2.61, ["Fly"] = 39.38, ["Ride"] = 31.5, ["Fly|Ride"] = 393.75, ["Neon"] = 140.59, ["Mega"] = 291.62, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 14.37, ["Ride"] = 210, ["Fly|Ride"] = 155.27, ["Neon"] = 131.25, ["Neon|Fly|Ride"] = 350.44, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 452.82}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 7.62, ["Fly"] = 105, ["Ride"] = 45.12, ["Fly|Ride"] = 131.25, ["Neon"] = 24.94, ["Neon|Ride"] = 92.33, ["Neon|Fly|Ride"] = 284.82, ["Mega"] = 231, ["Mega|Ride"] = 208.69}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 46.5, ["Ride"] = 18.89, ["Fly|Ride"] = 75.55, ["Neon"] = 2.1, ["Neon|Fly"] = 28.46, ["Neon|Ride"] = 20.98, ["Neon|Fly|Ride"] = 66.61, ["Mega"] = 15.75, ["Mega|Fly"] = 77.87, ["Mega|Ride"] = 34.13, ["Mega|Fly|Ride"] = 77.44}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 9.17, ["Ride"] = 39.38, ["Fly|Ride"] = 157.94, ["Neon"] = 40.69, ["Neon|Fly"] = 388.16, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 232.43, ["Mega"] = 140.58, ["Mega|Ride"] = 217.88, ["Mega|Fly|Ride"] = 260.15}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 262.5, ["Ride"] = 315, ["Fly|Ride"] = 377.67, ["Neon"] = 2098.11, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1447.7, ["Mega|Fly|Ride"] = 4081.88}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 110.25, ["Ride"] = 147, ["Fly|Ride"] = 7692.68, ["Neon|Ride"] = 866.25, ["Neon|Fly|Ride"] = 945, ["Mega"] = 4195.69, ["Mega|Ride"] = 3360, ["Mega|Fly|Ride"] = 1627.5}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 24.94, ["Fly|Ride"] = 38.06, ["Neon"] = 11.82, ["Neon|Fly"] = 24.94, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 65.63, ["Mega|Fly"] = 208.76, ["Mega|Ride"] = 91.27, ["Mega|Fly|Ride"] = 153.77}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 17.38, ["Ride"] = 15.94, ["Fly|Ride"] = 36.6, ["Neon"] = 6.57, ["Neon|Fly"] = 36.73, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 54.76, ["Mega"] = 59.07, ["Mega|Ride"] = 77.64, ["Mega|Fly|Ride"] = 168}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.63, ["Ride"] = 18.98, ["Fly|Ride"] = 98.44, ["Neon"] = 18.89, ["Mega"] = 140.58}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 419.58, ["Ride"] = 196.88, ["Fly|Ride"] = 699.74, ["Neon|Ride"] = 1959.64, ["Neon|Fly|Ride"] = 1766.81, ["Mega"] = 6293.53, ["Mega|Ride"] = 8391.36, ["Mega|Fly|Ride"] = 4895.33}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 3.68, ["Fly"] = 23.99, ["Ride"] = 17.07, ["Fly|Ride"] = 45.74, ["Neon"] = 28.33, ["Neon|Fly"] = 155.74, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 78.73, ["Mega"] = 266.44, ["Mega|Ride"] = 140.58, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 4.09, ["Fly"] = 124.36, ["Ride"] = 39.38, ["Fly|Ride"] = 209.83, ["Neon"] = 30.19, ["Neon|Ride"] = 32.82, ["Mega"] = 209.99, ["Mega|Ride"] = 204.75, ["Mega|Fly|Ride"] = 397.4}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 91.88, ["Neon"] = 4.67, ["Neon|Ride"] = 156.19, ["Neon|Fly|Ride"] = 140.59, ["Mega"] = 35.68, ["Mega|Ride"] = 94.5, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 20.88, ["Fly"] = 83.94, ["Ride"] = 31.39, ["Fly|Ride"] = 209.79, ["Neon"] = 85.73, ["Neon|Ride"] = 91.28, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 741.57, ["Mega|Ride"] = 496.36, ["Mega|Fly|Ride"] = 371.33}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 50.93, ["Ride"] = 91.88, ["Fly|Ride"] = 216.57, ["Neon"] = 131.25, ["Neon|Fly"] = 464.85, ["Neon|Ride"] = 207.73, ["Neon|Fly|Ride"] = 315, ["Mega"] = 545.52, ["Mega|Fly"] = 623.06, ["Mega|Ride"] = 538.13, ["Mega|Fly|Ride"] = 622.13}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 24.94, ["Ride"] = 49.88, ["Fly|Ride"] = 130.09, ["Neon"] = 131.25, ["Neon|Ride"] = 161.57, ["Neon|Fly|Ride"] = 236.25, ["Mega|Ride"] = 783.12, ["Mega|Fly|Ride"] = 2062.48}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 20.89, ["Ride"] = 77.44, ["Fly|Ride"] = 51.45, ["Neon"] = 2.37, ["Neon|Fly"] = 15.75, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 65.04, ["Mega"] = 24.13, ["Mega|Ride"] = 70.3, ["Mega|Fly|Ride"] = 115.5}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 188.83, ["Ride"] = 251.78, ["Fly|Ride"] = 313.69, ["Neon|Ride"] = 1836.12, ["Neon|Fly|Ride"] = 1317.75, ["Mega|Fly|Ride"] = 3618.79}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 15.75, ["Fly"] = 140.39, ["Ride"] = 45.94, ["Neon"] = 52.5, ["Neon|Ride"] = 156.19, ["Mega"] = 699.65, ["Mega|Ride"] = 577.97, ["Mega|Fly|Ride"] = 559.13}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 24.94, ["Ride"] = 28.33, ["Fly|Ride"] = 39.38, ["Neon"] = 6.56, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 31.39, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 61.68, ["Mega|Ride"] = 140.58, ["Mega|Fly|Ride"] = 280.08}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 140.59, ["Ride"] = 27.28, ["Fly|Ride"] = 39.38, ["Neon"] = 2.61, ["Neon|Ride"] = 22.44, ["Neon|Fly|Ride"] = 129.03, ["Mega"] = 26.25, ["Mega|Fly"] = 144.38, ["Mega|Ride"] = 35.44, ["Mega|Fly|Ride"] = 106.97}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 3.68, ["Ride"] = 23.55, ["Fly|Ride"] = 70.3, ["Neon"] = 15.74, ["Neon|Fly|Ride"] = 49.88, ["Mega"] = 87.25, ["Mega|Ride"] = 131.23, ["Mega|Fly|Ride"] = 419.58}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 13.39, ["Fly"] = 65.63, ["Ride"] = 23.25, ["Fly|Ride"] = 73.23, ["Neon"] = 75.54, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 497.33, ["Mega|Ride"] = 335.67, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 8.39, ["Neon"] = 101.07, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 208.76, ["Mega|Ride"] = 192.9, ["Mega|Fly|Ride"] = 448.95}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 52.46, ["Fly|Ride"] = 91.28, ["Neon"] = 3.68, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 93.19, ["Mega"] = 23.15, ["Mega|Ride"] = 56.65, ["Mega|Fly|Ride"] = 127.32}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 8.4, ["Ride"] = 28.33, ["Fly|Ride"] = 94.42, ["Neon"] = 35.68, ["Neon|Fly"] = 102.92, ["Neon|Ride"] = 56.66, ["Neon|Fly|Ride"] = 123.37, ["Mega"] = 147.58, ["Mega|Fly"] = 140.58, ["Mega|Ride"] = 255.95, ["Mega|Fly|Ride"] = 231.82}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 210, ["Neon"] = 8.42, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 155.74, ["Mega"] = 34.11, ["Mega|Ride"] = 144.75, ["Mega|Fly|Ride"] = 620.49}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 40.05, ["Ride"] = 19.69, ["Fly|Ride"] = 54.64, ["Neon"] = 5.98, ["Neon|Ride"] = 25.19, ["Neon|Fly|Ride"] = 116.46, ["Mega"] = 52.49, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 180.44}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 1363.62, ["Ride"] = 1295.44, ["Fly|Ride"] = 1362.57, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 4128.02, ["Mega|Fly|Ride"] = 15385.56}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 20.98, ["Fly|Ride"] = 44.07, ["Neon"] = 20.98, ["Neon|Fly"] = 41.41, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 61.93, ["Mega"] = 187.78, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.63, ["Ride"] = 53.48, ["Neon"] = 6.04, ["Neon|Ride"] = 140.59, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 34.61, ["Mega|Ride"] = 171.67, ["Mega|Fly|Ride"] = 224.04}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 10.49, ["Fly"] = 41.85, ["Ride"] = 26.25, ["Fly|Ride"] = 66.11, ["Neon"] = 37.32, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 93, ["Mega|Ride"] = 326.55, ["Mega|Fly|Ride"] = 353.07}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 19.67, ["Ride"] = 18.57, ["Fly|Ride"] = 32.82, ["Neon"] = 7.87, ["Neon|Fly"] = 89.24, ["Neon|Ride"] = 21.19, ["Neon|Fly|Ride"] = 62.99, ["Mega"] = 65.63, ["Mega|Ride"] = 175.19, ["Mega|Fly|Ride"] = 155.72}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 41.96, ["Ride"] = 56.44, ["Neon"] = 327.31, ["Neon|Ride"] = 105, ["Mega"] = 769.13, ["Mega|Ride"] = 979.71, ["Mega|Fly|Ride"] = 763.63}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Neon"] = 6.57, ["Neon|Ride"] = 140.59, ["Mega"] = 87.17, ["Mega|Ride"] = 107.63, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 3.91, ["Fly"] = 73.5, ["Ride"] = 31.37, ["Fly|Ride"] = 65.63, ["Neon"] = 13.13, ["Neon|Fly"] = 146.88, ["Neon|Ride"] = 70.09, ["Neon|Fly|Ride"] = 140.59, ["Mega"] = 78.75, ["Mega|Ride"] = 341.96, ["Mega|Fly|Ride"] = 193.02}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.63, ["Fly|Ride"] = 65.85, ["Neon"] = 15.74, ["Neon|Fly"] = 62.76, ["Mega"] = 259.23}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 2593.49, ["Ride"] = 23.36, ["Fly|Ride"] = 98.44, ["Neon"] = 3.93, ["Neon|Ride"] = 25.47, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 37.78, ["Mega|Fly"] = 419.58, ["Mega|Ride"] = 71.34, ["Mega|Fly|Ride"] = 204.52}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 19.48, ["Fly"] = 30.19, ["Ride"] = 25.19, ["Fly|Ride"] = 48.57, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 839.15, ["Mega|Ride"] = 376.58, ["Mega|Fly|Ride"] = 390.22}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 859.68, ["Ride"] = 885.94, ["Fly|Ride"] = 896.96, ["Neon"] = 2100, ["Neon|Ride"] = 2139.38, ["Neon|Fly|Ride"] = 2099.74, ["Mega"] = 6993.16, ["Mega|Ride"] = 5643.75, ["Mega|Fly|Ride"] = 5312.4}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 66.89, ["Ride"] = 18.45, ["Fly|Ride"] = 44.07, ["Neon"] = 6.12, ["Neon|Fly"] = 28.33, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 35.44, ["Mega|Fly"] = 111.2, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 140.44}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 4.19, ["Ride"] = 36.73, ["Neon"] = 56.21, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 335.71, ["Mega"] = 278.25, ["Mega|Ride"] = 251.76, ["Mega|Fly|Ride"] = 441}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 70.3, ["Ride"] = 85.32, ["Fly|Ride"] = 209.83, ["Neon|Fly|Ride"] = 734.35, ["Mega"] = 2944.4, ["Mega|Fly|Ride"] = 2231.25}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 48.38, ["Ride"] = 52.5, ["Fly|Ride"] = 301.88, ["Neon"] = 155.74, ["Neon|Ride"] = 177.19, ["Mega"] = 839.15, ["Mega|Ride"] = 734.26, ["Mega|Fly|Ride"] = 829.7}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 15.68, ["Ride"] = 39.38, ["Neon"] = 94.42, ["Neon|Ride"] = 392.44, ["Neon|Fly|Ride"] = 209.81, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 699.65}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 70.3, ["Ride"] = 53.48, ["Neon"] = 142.95, ["Neon|Ride"] = 356.77, ["Mega"] = 363.99, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 432.48}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 41.97, ["Fly"] = 105, ["Ride"] = 315, ["Neon"] = 224.44, ["Neon|Ride"] = 314.73, ["Neon|Fly|Ride"] = 525, ["Mega"] = 656.25, ["Mega|Ride"] = 586.36, ["Mega|Fly|Ride"] = 836.73}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 13.7}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 6.57, ["Fly"] = 39.38, ["Ride"] = 31.39, ["Neon"] = 72.19, ["Neon|Ride"] = 74.8, ["Neon|Fly|Ride"] = 493.5, ["Mega"] = 245.46, ["Mega|Ride"] = 251.76, ["Mega|Fly|Ride"] = 535.5}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 3.93, ["Neon"] = 35.68, ["Mega"] = 868, ["Mega|Fly|Ride"] = 944.05}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 77.44, ["Fly"] = 83.98, ["Ride"] = 61.68, ["Fly|Ride"] = 111.57, ["Neon"] = 203.54, ["Neon|Ride"] = 208.22, ["Neon|Fly|Ride"] = 929.69, ["Mega|Ride"] = 694.32, ["Mega|Fly|Ride"] = 811.13}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.56, ["Fly"] = 23.63, ["Ride"] = 18.59, ["Fly|Ride"] = 44.63, ["Neon"] = 28.53, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 45.1, ["Neon|Fly|Ride"] = 98.63, ["Mega"] = 280.08, ["Mega|Ride"] = 137.42, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 6.56, ["Fly"] = 98.63, ["Ride"] = 27.57, ["Fly|Ride"] = 100.73, ["Neon"] = 19.69, ["Neon|Ride"] = 95.47, ["Neon|Fly|Ride"] = 83.94, ["Mega"] = 171.94, ["Mega|Fly"] = 301.45, ["Mega|Ride"] = 226.58, ["Mega|Fly|Ride"] = 267.49}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 7.62, ["Neon|Ride"] = 198.74, ["Mega"] = 33.58, ["Mega|Ride"] = 95.46, ["Mega|Fly|Ride"] = 190.92}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 56.44, ["Ride"] = 77.64, ["Fly|Ride"] = 78.72, ["Neon"] = 288.75, ["Neon|Ride"] = 208.79, ["Neon|Fly|Ride"] = 280.11, ["Mega"] = 1085.27, ["Mega|Ride"] = 732.17, ["Mega|Fly|Ride"] = 808.5}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Neon"] = 17.49, ["Neon|Fly"] = 145.69, ["Mega"] = 121.69}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 10.49, ["Ride"] = 140.63, ["Neon"] = 73.45, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 293.74, ["Mega"] = 320.99, ["Mega|Ride"] = 419.58, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 23.24, ["Ride"] = 18.62, ["Fly|Ride"] = 47.24, ["Neon"] = 24.94, ["Neon|Ride"] = 40.27, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 77.64, ["Mega|Ride"] = 196.23, ["Mega|Fly|Ride"] = 313.65}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 3.56, ["Fly"] = 52.5, ["Ride"] = 24.94, ["Fly|Ride"] = 49.88, ["Neon"] = 157.5, ["Neon|Ride"] = 125.9, ["Mega"] = 310.25, ["Mega|Ride"] = 419.58, ["Mega|Fly|Ride"] = 418.04}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 2.63, ["Ride"] = 139.47, ["Neon"] = 32.82, ["Neon|Ride"] = 111.57, ["Mega"] = 140.6, ["Mega|Ride"] = 547.98}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 46.5, ["Fly"] = 131.25, ["Ride"] = 118.13, ["Fly|Ride"] = 131.25, ["Neon"] = 190.32, ["Mega|Ride"] = 1258.72, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 21, ["Ride"] = 251.78, ["Neon"] = 237.07, ["Mega"] = 502.8, ["Mega|Ride"] = 775.04, ["Mega|Fly|Ride"] = 453.15}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 6.56, ["Ride"] = 105, ["Neon"] = 93.28, ["Mega"] = 264.34, ["Mega|Ride"] = 272.73, ["Mega|Fly|Ride"] = 1678.29}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 32.82, ["Ride"] = 105, ["Fly|Ride"] = 422.03, ["Neon"] = 200.64, ["Mega"] = 766.5, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 686.01}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 3.7, ["Neon"] = 45.03, ["Mega"] = 839.15, ["Mega|Fly|Ride"] = 310.25}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 28.33, ["Fly|Ride"] = 50.37, ["Neon"] = 6.56, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 137.82, ["Mega"] = 62.95, ["Mega|Ride"] = 89.25, ["Mega|Fly|Ride"] = 258.56}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 7.38, ["Ride"] = 91.88, ["Fly|Ride"] = 91.25, ["Neon"] = 15.75, ["Neon|Ride"] = 89.25, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 190.92, ["Mega|Ride"] = 488.82}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 32.54, ["Ride"] = 20.99, ["Fly|Ride"] = 53.82, ["Neon"] = 5.25, ["Neon|Fly"] = 41.98, ["Neon|Ride"] = 30.45, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 44.45, ["Mega|Ride"] = 79.57, ["Mega|Fly|Ride"] = 260.14}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.63, ["Ride"] = 26.25, ["Fly|Ride"] = 98.63, ["Neon"] = 15.75, ["Neon|Ride"] = 92.98, ["Neon|Fly|Ride"] = 260.17, ["Mega"] = 249.38, ["Mega|Ride"] = 154.88, ["Mega|Fly|Ride"] = 464.8}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.81, ["Ride"] = 31.49, ["Fly|Ride"] = 99.75, ["Neon"] = 327.31, ["Neon|Ride"] = 104.92, ["Mega"] = 140.58, ["Mega|Ride"] = 419.58, ["Mega|Fly|Ride"] = 1258.72}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 8.39, ["Ride"] = 22.42, ["Neon"] = 31.5, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 101.07, ["Mega"] = 221.95, ["Mega|Ride"] = 252, ["Mega|Fly|Ride"] = 302.1}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 3.82, ["Fly"] = 34.07, ["Ride"] = 23.25, ["Fly|Ride"] = 67.13, ["Neon"] = 32.54, ["Neon|Fly|Ride"] = 109.26, ["Mega"] = 166.66, ["Mega|Ride"] = 175.19, ["Mega|Fly|Ride"] = 455.25}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 11.82, ["Ride"] = 27.57, ["Neon"] = 24.93, ["Neon|Fly"] = 437.07, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 459.04, ["Mega"] = 77.64, ["Mega|Ride"] = 305.82, ["Mega|Fly|Ride"] = 322.23}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 12.17, ["Ride"] = 78.75, ["Fly|Ride"] = 196.2, ["Neon"] = 85.2, ["Neon|Ride"] = 187.69, ["Neon|Fly|Ride"] = 375.27, ["Mega"] = 444.94, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 437.07, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 59.06, ["Fly"] = 202.21, ["Ride"] = 112.26, ["Fly|Ride"] = 291.38, ["Neon"] = 232.43, ["Neon|Ride"] = 202.18, ["Neon|Fly|Ride"] = 314.76, ["Mega"] = 1678.29, ["Mega|Ride"] = 1185.2, ["Mega|Fly|Ride"] = 1171.27}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Ride"] = 21, ["Fly|Ride"] = 65.63, ["Neon"] = 3.94, ["Neon|Ride"] = 37.91, ["Mega"] = 28.33, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 119.59}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 15.75, ["Ride"] = 131.25, ["Neon"] = 54.56, ["Mega"] = 312.6, ["Mega|Ride"] = 363.99, ["Mega|Fly|Ride"] = 1245.08}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 34.61, ["Fly"] = 105, ["Ride"] = 115.5, ["Neon|Ride"] = 1119.35, ["Mega"] = 1085.65, ["Mega|Ride"] = 1097.18, ["Mega|Fly|Ride"] = 1258.72}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 7.01, ["Fly"] = 190.32, ["Ride"] = 46.47, ["Fly|Ride"] = 126, ["Neon"] = 49.88, ["Neon|Ride"] = 59.06, ["Mega"] = 78.75, ["Mega|Ride"] = 194.25, ["Mega|Fly|Ride"] = 280.08}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 2.1, ["Fly"] = 157.5, ["Ride"] = 62.87, ["Fly|Ride"] = 116.46, ["Neon"] = 3.92, ["Neon|Ride"] = 27.54, ["Mega"] = 48.57, ["Mega|Ride"] = 53.82, ["Mega|Fly|Ride"] = 183.58}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 35.68, ["Ride"] = 20.99, ["Fly|Ride"] = 45.1, ["Neon"] = 15.75, ["Neon|Ride"] = 45.1, ["Neon|Fly|Ride"] = 125.9, ["Mega"] = 203.6, ["Mega|Ride"] = 154.25, ["Mega|Fly|Ride"] = 231}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 23.07, ["Ride"] = 23.63, ["Fly|Ride"] = 40.93, ["Neon"] = 3.93, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 2944.4, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 24.94, ["Fly|Ride"] = 65.7, ["Neon"] = 5.25, ["Neon|Ride"] = 31.47, ["Neon|Fly|Ride"] = 83.93, ["Mega"] = 35.43, ["Mega|Fly"] = 168, ["Mega|Ride"] = 54.63, ["Mega|Fly|Ride"] = 147}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 28.33, ["Neon"] = 2.63, ["Neon|Ride"] = 155.74, ["Mega"] = 21, ["Mega|Ride"] = 104.91, ["Mega|Fly|Ride"] = 258.05}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 6.85, ["Ride"] = 39.53, ["Fly|Ride"] = 356.69, ["Neon"] = 34.54, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 629.45, ["Mega"] = 208.76, ["Mega|Ride"] = 309.44, ["Mega|Fly|Ride"] = 1118.17}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 10.5, ["Ride"] = 41.94, ["Neon"] = 124.43, ["Neon|Ride"] = 202.13, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 276.34, ["Mega|Ride"] = 418.52, ["Mega|Fly|Ride"] = 356.65}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 7.71, ["Fly"] = 23.09, ["Ride"] = 22.11, ["Fly|Ride"] = 54.94, ["Neon|Fly"] = 124.36, ["Neon|Ride"] = 41.97, ["Neon|Fly|Ride"] = 103.69, ["Mega|Ride"] = 310.49, ["Mega|Fly|Ride"] = 446.2}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 79.98, ["Ride"] = 52.5, ["Fly|Ride"] = 262.5, ["Neon"] = 538.13, ["Neon|Ride"] = 524.53}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 18.47, ["Ride"] = 65.63, ["Neon"] = 95.47, ["Mega"] = 613.59, ["Mega|Fly"] = 644.05, ["Mega|Ride"] = 603.75, ["Mega|Fly|Ride"] = 1029.67}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 18.38, ["Fly|Ride"] = 44.07, ["Neon"] = 3.93, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 20.99, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 36.04, ["Mega|Ride"] = 107.63, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 15.59, ["Ride"] = 17.07, ["Fly|Ride"] = 39.88, ["Neon"] = 3.93, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 20.1, ["Neon|Fly|Ride"] = 53.81, ["Mega"] = 39.38, ["Mega|Fly"] = 70.3, ["Mega|Ride"] = 76.71, ["Mega|Fly|Ride"] = 148.97}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 392.44, ["Ride"] = 399, ["Fly|Ride"] = 551.25, ["Neon|Fly|Ride"] = 1522.5}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 13.11, ["Ride"] = 140.59, ["Neon"] = 70.3, ["Neon|Fly|Ride"] = 398.66, ["Mega"] = 495.48, ["Mega|Ride"] = 515.03, ["Mega|Fly|Ride"] = 776.22}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 28.33, ["Ride"] = 17.07, ["Fly|Ride"] = 41.85, ["Neon"] = 5.99, ["Neon|Ride"] = 20.93, ["Neon|Fly|Ride"] = 44.04, ["Mega"] = 42, ["Mega|Fly"] = 46.5, ["Mega|Ride"] = 72.07, ["Mega|Fly|Ride"] = 309.44}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 85.3, ["Ride"] = 123.8, ["Fly|Ride"] = 167.87, ["Neon"] = 223.13, ["Neon|Ride"] = 288.75, ["Neon|Fly|Ride"] = 476.28, ["Mega"] = 1048.93, ["Mega|Ride"] = 813.75, ["Mega|Fly|Ride"] = 1102.5}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 18.36, ["Fly|Ride"] = 43.31, ["Neon"] = 10.19, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 76.36, ["Mega"] = 128.63, ["Mega|Fly"] = 182.53, ["Mega|Ride"] = 115.27, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Ride"] = 98.63, ["Fly|Ride"] = 1312.5, ["Neon"] = 3.93, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 283.5, ["Mega"] = 16.79, ["Mega|Ride"] = 130.08, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 78.93, ["Ride"] = 131.25, ["Neon"] = 209.2, ["Neon|Ride"] = 209.83, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 825.51, ["Mega|Ride"] = 1100.33, ["Mega|Fly|Ride"] = 813.75}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Neon"] = 19.69, ["Neon|Ride"] = 53.51, ["Mega"] = 97.62, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 37.8, ["Fly"] = 140.59, ["Ride"] = 60.38, ["Fly|Ride"] = 280.11, ["Neon"] = 187.8, ["Neon|Ride"] = 196.2, ["Neon|Fly|Ride"] = 260.17, ["Mega|Ride"] = 1676.19, ["Mega|Fly|Ride"] = 1153.83}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 4.14, ["Ride"] = 115.06, ["Neon"] = 92.98, ["Neon|Ride"] = 419.64, ["Mega"] = 196.88, ["Mega|Ride"] = 822.94, ["Mega|Fly|Ride"] = 544.04}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.55, ["Fly"] = 70.3, ["Ride"] = 70.9, ["Neon"] = 12.6, ["Neon|Fly"] = 62.95, ["Neon|Ride"] = 56.66, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 77.44, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 560.14}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 27.57, ["Ride"] = 775.13, ["Fly|Ride"] = 91.88, ["Neon|Ride"] = 210, ["Mega"] = 1258.72, ["Mega|Ride"] = 2611.88, ["Mega|Fly|Ride"] = 1239.82}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 131.62, ["Ride"] = 89.25, ["Neon"] = 4.66, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 83.92, ["Neon|Fly|Ride"] = 168, ["Mega"] = 53.47, ["Mega|Fly"] = 158.61, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 308.48}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 46.5, ["Ride"] = 19.58, ["Fly|Ride"] = 72.17, ["Neon"] = 8.4, ["Neon|Fly"] = 41.88, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 105.59, ["Mega|Ride"] = 153.16, ["Mega|Fly|Ride"] = 284.17}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 15.62, ["Ride"] = 36.73, ["Neon"] = 59.07, ["Neon|Ride"] = 107.02, ["Mega"] = 319.49, ["Mega|Ride"] = 503.5, ["Mega|Fly|Ride"] = 377.99}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 25.45, ["Ride"] = 81.84, ["Fly|Ride"] = 157.5, ["Neon"] = 161.43, ["Neon|Fly"] = 280.11, ["Neon|Ride"] = 202.13, ["Neon|Fly|Ride"] = 295.32, ["Mega"] = 556.49, ["Mega|Ride"] = 479.07, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 29.4, ["Fly"] = 30.17, ["Ride"] = 45.12, ["Fly|Ride"] = 79.74, ["Neon"] = 103.69, ["Neon|Ride"] = 83.94, ["Neon|Fly|Ride"] = 222.89, ["Mega"] = 620.49, ["Mega|Ride"] = 620.49, ["Mega|Fly|Ride"] = 418.52}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 76.13, ["Ride"] = 150.94, ["Fly|Ride"] = 105, ["Neon"] = 341.25, ["Neon|Ride"] = 385.88, ["Neon|Fly|Ride"] = 551.25, ["Mega"] = 1483.18, ["Mega|Ride"] = 1302, ["Mega|Fly|Ride"] = 1275.5}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 3.66, ["Ride"] = 32.01, ["Fly|Ride"] = 262.5, ["Neon"] = 23.09, ["Neon|Ride"] = 140.59, ["Neon|Fly|Ride"] = 314.73, ["Mega"] = 155.72, ["Mega|Ride"] = 265.13, ["Mega|Fly|Ride"] = 328.79}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 5.92, ["Ride"] = 28.33, ["Fly|Ride"] = 109.12, ["Neon"] = 34.89, ["Neon|Ride"] = 70.3, ["Neon|Fly|Ride"] = 209.83, ["Mega"] = 172.26, ["Mega|Ride"] = 219.61, ["Mega|Fly|Ride"] = 209.81}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 13.64, ["Fly"] = 105, ["Ride"] = 46.57, ["Fly|Ride"] = 157.5, ["Neon"] = 124.95, ["Neon|Ride"] = 140.59, ["Neon|Fly|Ride"] = 168.6, ["Mega"] = 367.5, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 13.13, ["Fly|Ride"] = 45.12, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 18.89, ["Neon|Fly|Ride"] = 62.76, ["Mega"] = 15.75, ["Mega|Fly"] = 77.87, ["Mega|Ride"] = 32.52, ["Mega|Fly|Ride"] = 98.44}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 52.5, ["Fly"] = 140.59, ["Ride"] = 130.09, ["Neon"] = 304.24, ["Neon|Fly"] = 2378.2, ["Neon|Ride"] = 266.47, ["Mega"] = 933.19, ["Mega|Fly"] = 958.73, ["Mega|Ride"] = 1006.98, ["Mega|Fly|Ride"] = 958.13}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 23.25, ["Fly|Ride"] = 89.25, ["Neon"] = 3.15, ["Neon|Ride"] = 19.69, ["Mega"] = 107.01, ["Mega|Fly|Ride"] = 210.76}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 28.33, ["Ride"] = 21.18, ["Fly|Ride"] = 62.95, ["Neon"] = 41.97, ["Neon|Ride"] = 32.44, ["Neon|Fly|Ride"] = 98.63, ["Mega|Ride"] = 419.58, ["Mega|Fly|Ride"] = 280.08}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 87.26, ["Fly"] = 209.83, ["Ride"] = 254.63, ["Fly|Ride"] = 426.98, ["Neon"] = 262.5, ["Neon|Ride"] = 314.45, ["Neon|Fly|Ride"] = 620.58, ["Mega"] = 918.75, ["Mega|Ride"] = 912.19, ["Mega|Fly|Ride"] = 1010.63}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 56.66, ["Neon"] = 6.23, ["Neon|Ride"] = 1398.76, ["Mega"] = 51.16, ["Mega|Ride"] = 94.03, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 24.19}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 20235.17, ["Fly|Ride"] = 105, ["Neon"] = 4.07, ["Neon|Ride"] = 38.06, ["Neon|Fly|Ride"] = 140.59, ["Mega"] = 46.17, ["Mega|Fly"] = 98.61, ["Mega|Ride"] = 115.5, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 137.82, ["Ride"] = 182.44, ["Fly|Ride"] = 449.74, ["Neon"] = 653.57, ["Neon|Ride"] = 557.06, ["Neon|Fly|Ride"] = 735, ["Mega|Fly|Ride"] = 2449.13}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 4.97, ["Ride"] = 42, ["Neon"] = 23.24, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 140.59, ["Mega"] = 280.08, ["Mega|Fly|Ride"] = 409.1}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.63, ["Fly"] = 209.83, ["Neon"] = 2.63, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 45.42, ["Mega|Ride"] = 83.93, ["Mega|Fly|Ride"] = 312.9}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 3.94, ["Ride"] = 30.85, ["Neon"] = 52.49, ["Neon|Ride"] = 140.59, ["Neon|Fly|Ride"] = 156.42, ["Mega"] = 389.17, ["Mega|Ride"] = 629.37, ["Mega|Fly|Ride"] = 620.49}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 8.32, ["Fly"] = 74.47, ["Ride"] = 26.24, ["Neon"] = 26.25, ["Neon|Fly|Ride"] = 274.86, ["Mega"] = 350.07, ["Mega|Ride"] = 392.43, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 28.88, ["Ride"] = 65.71, ["Fly|Ride"] = 167.87, ["Neon"] = 157.71, ["Neon|Ride"] = 293.74, ["Neon|Fly|Ride"] = 377.67, ["Mega"] = 602.1, ["Mega|Ride"] = 635.66, ["Mega|Fly|Ride"] = 616.87}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 140.7, ["Fly"] = 237.07, ["Ride"] = 175.88, ["Fly|Ride"] = 329.41, ["Neon"] = 558.1, ["Neon|Ride"] = 548.63, ["Neon|Fly|Ride"] = 589.31, ["Mega|Fly|Ride"] = 2159.07}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 8.71, ["Fly"] = 23.62, ["Ride"] = 22.11, ["Fly|Ride"] = 37.41, ["Neon"] = 36.75, ["Neon|Ride"] = 59.06, ["Neon|Fly|Ride"] = 84, ["Mega|Ride"] = 293.71, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 3.91, ["Fly"] = 131.23, ["Ride"] = 52.5, ["Fly|Ride"] = 131.25, ["Neon"] = 28.33, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 192.95, ["Mega"] = 140.58, ["Mega|Ride"] = 77.64, ["Mega|Fly|Ride"] = 464.8}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 10.48, ["Fly"] = 232.43, ["Ride"] = 78.75, ["Fly|Ride"] = 193.04, ["Neon"] = 118.13, ["Neon|Ride"] = 132.71, ["Mega"] = 519.29, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 503.62}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 39.46, ["Ride"] = 65.63, ["Fly|Ride"] = 98.63, ["Neon"] = 208.78, ["Neon|Ride"] = 180.45, ["Neon|Fly|Ride"] = 182.06, ["Mega"] = 734.26, ["Mega|Fly"] = 979.71, ["Mega|Ride"] = 866.62, ["Mega|Fly|Ride"] = 880.69}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 19.69, ["Ride"] = 81.86, ["Neon"] = 118.13, ["Neon|Ride"] = 209.83, ["Mega"] = 669.38, ["Mega|Ride"] = 511.88, ["Mega|Fly|Ride"] = 623.06}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 288.74, ["Ride"] = 413.44, ["Neon"] = 2378.2, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1678.29, ["Mega|Ride"] = 3937.5, ["Mega|Fly|Ride"] = 4119.25}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 34.91, ["Ride"] = 42, ["Fly|Ride"] = 91.28, ["Neon"] = 280.11, ["Neon|Ride"] = 184.49, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 1195.69, ["Mega|Ride"] = 724.82, ["Mega|Fly|Ride"] = 748.95}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 28.33, ["Ride"] = 15.74, ["Neon"] = 2.5, ["Neon|Ride"] = 19.94, ["Neon|Fly|Ride"] = 55.13, ["Mega"] = 18.38, ["Mega|Fly"] = 65.63, ["Mega|Ride"] = 33.59, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 7.46, ["Ride"] = 59.07, ["Neon"] = 14.44, ["Neon|Ride"] = 39.38, ["Mega"] = 132.18, ["Mega|Ride"] = 264.34, ["Mega|Fly|Ride"] = 491.54}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 3.82, ["Ride"] = 39.37, ["Neon"] = 18.35, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 1181.25, ["Mega"] = 131.25, ["Mega|Fly"] = 224.48, ["Mega|Ride"] = 280.08, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 393.75, ["Ride"] = 420, ["Fly|Ride"] = 485.63, ["Neon"] = 2098.11, ["Neon|Ride"] = 1384.76, ["Neon|Fly|Ride"] = 1345.32, ["Mega|Fly|Ride"] = 4917.94}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.37, ["Fly"] = 19.69, ["Ride"] = 18.38, ["Fly|Ride"] = 56.44, ["Neon"] = 70.11, ["Neon|Ride"] = 70.3, ["Neon|Fly|Ride"] = 71.18, ["Mega|Ride"] = 165.72, ["Mega|Fly|Ride"] = 839.15}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 7.88, ["Fly"] = 31.77, ["Ride"] = 24.14, ["Fly|Ride"] = 53.01, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 208.78, ["Mega"] = 419.58, ["Mega|Ride"] = 699.65, ["Mega|Fly|Ride"] = 839.15}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 5.66, ["Fly"] = 83.94, ["Ride"] = 26.25, ["Neon"] = 17.07, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 123.38, ["Mega"] = 155.26, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 464.8}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 38.66, ["Fly"] = 210, ["Ride"] = 28.33, ["Fly|Ride"] = 70.3, ["Neon"] = 118.13, ["Neon|Ride"] = 251.78, ["Mega"] = 525, ["Mega|Ride"] = 350.36, ["Mega|Fly|Ride"] = 640.49}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 62.74, ["Ride"] = 62.99, ["Neon"] = 14.44, ["Neon|Ride"] = 109.26, ["Neon|Fly|Ride"] = 210, ["Mega|Ride"] = 109.24, ["Mega|Fly|Ride"] = 620.17}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 5.92, ["Fly"] = 104.15, ["Ride"] = 24.93, ["Fly|Ride"] = 91.88, ["Neon"] = 310.3, ["Mega"] = 699.65, ["Mega|Ride"] = 310.25, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.63, ["Ride"] = 35.68, ["Neon"] = 6.55, ["Neon|Ride"] = 41.98, ["Mega"] = 98.67, ["Mega|Ride"] = 112.28, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 12.6, ["Ride"] = 69.57, ["Neon"] = 89.25, ["Mega"] = 196.88, ["Mega|Ride"] = 338.63, ["Mega|Fly|Ride"] = 629.37}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 9.44, ["Ride"] = 279.06, ["Mega"] = 264.34, ["Mega|Ride"] = 263.29, ["Mega|Fly|Ride"] = 1048.93}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 9.18, ["Fly"] = 32.81, ["Ride"] = 26.6, ["Fly|Ride"] = 58.76, ["Neon"] = 52.5, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 405.95, ["Mega|Ride"] = 342.8, ["Mega|Fly|Ride"] = 413.93}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 195.57, ["Fly"] = 498.75, ["Ride"] = 203.54, ["Fly|Ride"] = 237.11, ["Neon"] = 973.53, ["Neon|Ride"] = 929.69, ["Neon|Fly|Ride"] = 850.91, ["Mega|Fly|Ride"] = 2860.43}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Fly"] = 21.2, ["Ride"] = 16.94, ["Fly|Ride"] = 65.02, ["Neon"] = 20.99, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 108.29, ["Mega"] = 220.5, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 3.29, ["Fly"] = 26.25, ["Ride"] = 31.82, ["Fly|Ride"] = 103.64, ["Neon"] = 19.93, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 334.69, ["Mega"] = 137.82, ["Mega|Ride"] = 159.45, ["Mega|Fly|Ride"] = 410.82}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 30.44, ["Fly|Ride"] = 524.53, ["Neon"] = 82.67, ["Neon|Ride"] = 238.16, ["Neon|Fly|Ride"] = 629.45, ["Mega"] = 414.33, ["Mega|Ride"] = 503.5, ["Mega|Fly|Ride"] = 471.19}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 82.57, ["Fly"] = 393.75, ["Ride"] = 125.9, ["Fly|Ride"] = 206.73, ["Neon"] = 317.63, ["Neon|Ride"] = 393.7, ["Neon|Fly|Ride"] = 380.63, ["Mega|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 1472.21}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 31.49, ["Ride"] = 98.63, ["Fly|Ride"] = 272.77, ["Neon"] = 103.04, ["Neon|Ride"] = 165.74, ["Neon|Fly|Ride"] = 202.13, ["Mega"] = 253.31, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 412.06}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.63, ["Fly"] = 26.25, ["Ride"] = 23.09, ["Fly|Ride"] = 39.38, ["Neon"] = 15.75, ["Mega"] = 124.35, ["Mega|Ride"] = 280.08, ["Mega|Fly|Ride"] = 350.36}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 18.9, ["Ride"] = 65.62, ["Neon"] = 59.07, ["Neon|Ride"] = 105, ["Mega"] = 255.95, ["Mega|Ride"] = 309.51, ["Mega|Fly|Ride"] = 390.22}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 75.37, ["Ride"] = 152.78, ["Fly|Ride"] = 262.5, ["Neon"] = 237.57, ["Neon|Ride"] = 288.75, ["Neon|Fly|Ride"] = 392.36, ["Mega"] = 708.09, ["Mega|Ride"] = 536.82, ["Mega|Fly|Ride"] = 602.43}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.63, ["Ride"] = 72.19, ["Neon"] = 9.93, ["Neon|Ride"] = 104.74, ["Neon|Fly|Ride"] = 157.37, ["Mega"] = 48.26, ["Mega|Fly"] = 116.81, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 10.45, ["Ride"] = 229.69, ["Neon"] = 60.38, ["Neon|Ride"] = 155.27, ["Mega"] = 315, ["Mega|Ride"] = 414.33, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 1161.97, ["Fly"] = 1567.13, ["Ride"] = 1050, ["Fly|Ride"] = 1181.25, ["Neon"] = 3329.69, ["Neon|Fly|Ride"] = 2913.75, ["Mega|Fly|Ride"] = 10762.5}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 16.28, ["Ride"] = 118.56, ["Fly|Ride"] = 222.42, ["Neon"] = 118.13, ["Neon|Ride"] = 280.11, ["Mega"] = 590.63, ["Mega|Ride"] = 560.14, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 7.51, ["Fly"] = 49.18, ["Ride"] = 39.38, ["Fly|Ride"] = 262.5, ["Neon"] = 23.63, ["Neon|Fly"] = 191.63, ["Neon|Ride"] = 46.5, ["Neon|Fly|Ride"] = 140.59, ["Mega"] = 78.75, ["Mega|Ride"] = 154.88, ["Mega|Fly|Ride"] = 224.62}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 11.68, ["Ride"] = 131.22, ["Neon"] = 78.75, ["Mega"] = 392.32, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 699.65}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Fly|Ride"] = 419.64, ["Neon"] = 2.63, ["Neon|Ride"] = 36.58, ["Neon|Fly|Ride"] = 100.73, ["Mega"] = 16.79, ["Mega|Ride"] = 63, ["Mega|Fly|Ride"] = 140.58}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 107.89, ["Ride"] = 397.95, ["Fly|Ride"] = 272.99, ["Neon"] = 315, ["Neon|Ride"] = 353.07, ["Neon|Fly|Ride"] = 420, ["Mega"] = 1100.14, ["Mega|Ride"] = 1048.69, ["Mega|Fly|Ride"] = 1197}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 7.87, ["Fly"] = 101.07, ["Ride"] = 26.25, ["Fly|Ride"] = 813.48, ["Neon"] = 28.88, ["Neon|Ride"] = 84, ["Mega"] = 348.25, ["Mega|Ride"] = 255.5, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 3.14, ["Ride"] = 31.49, ["Neon"] = 11.81, ["Neon|Ride"] = 32.82, ["Mega"] = 140.44, ["Mega|Ride"] = 248.67, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 48.57, ["Fly"] = 108.07, ["Ride"] = 91.88, ["Fly|Ride"] = 183.74, ["Neon"] = 140.59, ["Neon|Fly"] = 280.11, ["Neon|Ride"] = 476.28, ["Neon|Fly|Ride"] = 415.44, ["Mega"] = 418.68, ["Mega|Ride"] = 560.14, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 13.62, ["Fly|Ride"] = 95.3, ["Neon"] = 91.88, ["Neon|Fly"] = 185.95, ["Neon|Ride"] = 196.2, ["Neon|Fly|Ride"] = 309.48, ["Mega"] = 979.71, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 67.41, ["Ride"] = 111.19, ["Neon"] = 560.2, ["Neon|Ride"] = 933.19, ["Neon|Fly|Ride"] = 919.42, ["Mega"] = 1538.78, ["Mega|Ride"] = 1818.85, ["Mega|Fly|Ride"] = 1523.04}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 8.45, ["Ride"] = 44.18, ["Neon"] = 22.94, ["Neon|Ride"] = 109.26, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 118.65, ["Mega|Ride"] = 177.03, ["Mega|Fly|Ride"] = 242.82}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 9.08, ["Fly"] = 196.88, ["Ride"] = 30.58, ["Neon"] = 72.17, ["Neon|Ride"] = 74.8, ["Neon|Fly|Ride"] = 280.88, ["Mega"] = 354.37, ["Mega|Ride"] = 384.98, ["Mega|Fly|Ride"] = 464.8}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 150.94, ["Ride"] = 200.82, ["Fly|Ride"] = 245.49, ["Neon"] = 544.69, ["Neon|Ride"] = 577.5, ["Neon|Fly|Ride"] = 546, ["Mega"] = 2362.5, ["Mega|Ride"] = 2361.19, ["Mega|Fly|Ride"] = 2097.85}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 18.38, ["Fly|Ride"] = 35.44, ["Neon"] = 14.97, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 77.44, ["Mega|Ride"] = 160.13, ["Mega|Fly|Ride"] = 174.57}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 7.76, ["Fly"] = 87.94, ["Ride"] = 25.19, ["Fly|Ride"] = 65.63, ["Neon"] = 27.28, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 119.59, ["Mega"] = 220.5, ["Mega|Fly"] = 232.87, ["Mega|Ride"] = 262.24, ["Mega|Fly|Ride"] = 397.69}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 28.33, ["Ride"] = 15.75, ["Fly|Ride"] = 35.94, ["Neon"] = 2.1, ["Neon|Fly"] = 31.39, ["Neon|Ride"] = 17.42, ["Neon|Fly|Ride"] = 41.98, ["Mega"] = 15.73, ["Mega|Ride"] = 35.68, ["Mega|Fly|Ride"] = 93.96}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 31.49, ["Neon"] = 3.94, ["Mega"] = 19.94, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 140.58}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 3.68, ["Fly"] = 131.55, ["Ride"] = 71.37, ["Neon"] = 22.32, ["Neon|Ride"] = 64.98, ["Mega"] = 266.44, ["Mega|Ride"] = 207.69, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 57.11, ["Ride"] = 315, ["Neon"] = 226.61, ["Neon|Ride"] = 452.82, ["Neon|Fly|Ride"] = 630, ["Mega"] = 774.38, ["Mega|Ride"] = 560.14}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 19.69, ["Fly|Ride"] = 47.25, ["Neon"] = 18.38, ["Neon|Fly"] = 41.98, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 43.32, ["Mega"] = 195.12, ["Mega|Fly"] = 238.11, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 162.74}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 2.1, ["Fly"] = 28.33, ["Ride"] = 27.28, ["Fly|Ride"] = 47.38, ["Neon"] = 13.02, ["Neon|Fly"] = 52.39, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 98.63, ["Mega"] = 125.35, ["Mega|Fly"] = 280.08, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 3.93, ["Ride"] = 24.94, ["Fly|Ride"] = 115.71, ["Neon"] = 6.57, ["Neon|Fly"] = 98.44, ["Neon|Ride"] = 35.68, ["Neon|Fly|Ride"] = 106.32, ["Mega"] = 51.16, ["Mega|Fly"] = 408.19, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 155.72}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 15.74, ["Ride"] = 26.24, ["Neon"] = 46.5, ["Neon|Ride"] = 80.55, ["Neon|Fly|Ride"] = 188.84, ["Mega"] = 266.44, ["Mega|Fly"] = 290.5, ["Mega|Ride"] = 302.1, ["Mega|Fly|Ride"] = 524.48}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 6.55, ["Fly|Ride"] = 56.66, ["Neon"] = 52.5, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 209.83, ["Mega"] = 420, ["Mega|Ride"] = 415.38, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 3.61, ["Fly"] = 31.4, ["Ride"] = 28.88, ["Fly|Ride"] = 77.64, ["Neon"] = 25.2, ["Neon|Fly"] = 196.65, ["Neon|Ride"] = 110.93, ["Neon|Fly|Ride"] = 105, ["Mega"] = 173.78, ["Mega|Ride"] = 209.81, ["Mega|Fly|Ride"] = 351.41}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.5, ["Fly"] = 26.25, ["Ride"] = 16.86, ["Fly|Ride"] = 41.99, ["Neon"] = 14.44, ["Neon|Fly"] = 86.01, ["Neon|Ride"] = 50.37, ["Neon|Fly|Ride"] = 70.88, ["Mega"] = 98.61, ["Mega|Ride"] = 155.72, ["Mega|Fly|Ride"] = 223.91}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 236.25, ["Fly"] = 393.75, ["Ride"] = 210, ["Neon"] = 908.5, ["Neon|Ride"] = 929.69, ["Neon|Fly|Ride"] = 951.39, ["Mega"] = 5594.95, ["Mega|Fly|Ride"] = 3650.7}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 5.13, ["Ride"] = 61.76, ["Neon"] = 30.19, ["Neon|Fly|Ride"] = 280.11, ["Mega"] = 155.26, ["Mega|Ride"] = 140.58, ["Mega|Fly|Ride"] = 979.71}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 3.03, ["Fly"] = 65.63, ["Ride"] = 25.58, ["Fly|Ride"] = 118.13, ["Neon"] = 37.77, ["Neon|Ride"] = 58.11, ["Neon|Fly|Ride"] = 139.65, ["Mega"] = 203.44, ["Mega|Ride"] = 459.38}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 7.87, ["Neon"] = 40.66, ["Neon|Fly|Ride"] = 629.45, ["Mega"] = 87.94, ["Mega|Ride"] = 410.13, ["Mega|Fly|Ride"] = 560.14}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 17.07, ["Fly|Ride"] = 33.79, ["Neon"] = 2.1, ["Neon|Fly"] = 28.76, ["Neon|Ride"] = 22.11, ["Neon|Fly|Ride"] = 38.93, ["Mega"] = 20.93, ["Mega|Ride"] = 27.57, ["Mega|Fly|Ride"] = 70.3}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.49, ["Fly"] = 56.44, ["Ride"] = 26.87, ["Fly|Ride"] = 41.98, ["Neon"] = 17.07, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 28.33, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 131.25, ["Mega|Fly|Ride"] = 278.88}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 3.14, ["Ride"] = 28.33, ["Neon"] = 12.59, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 57.75, ["Mega|Ride"] = 140.58, ["Mega|Fly|Ride"] = 450.19}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 84, ["Ride"] = 96.66, ["Fly|Ride"] = 153.18, ["Neon"] = 560.2, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 446.25, ["Mega|Ride"] = 3498.16, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 6.17, ["Fly"] = 85.32, ["Ride"] = 65.63, ["Fly|Ride"] = 65.54, ["Neon"] = 15.75, ["Neon|Ride"] = 62.95, ["Neon|Fly|Ride"] = 310.3, ["Mega"] = 280.08, ["Mega|Fly|Ride"] = 320.99}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Fly|Ride"] = 155.27, ["Neon"] = 15.74, ["Neon|Ride"] = 125.9, ["Neon|Fly|Ride"] = 167.87, ["Mega"] = 61.9, ["Mega|Fly"] = 409.1, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 915.64}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 60.85, ["Fly"] = 124.69, ["Ride"] = 95.82, ["Fly|Ride"] = 209.99, ["Neon"] = 203.44, ["Neon|Ride"] = 221.82, ["Neon|Fly|Ride"] = 330.75, ["Mega"] = 692.3, ["Mega|Ride"] = 519.75, ["Mega|Fly|Ride"] = 629.37}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Ride"] = 23.09, ["Fly|Ride"] = 58.76, ["Neon"] = 2.63, ["Neon|Fly"] = 21, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 16.86, ["Mega|Ride"] = 55.13, ["Mega|Fly|Ride"] = 87.17}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Neon"] = 4.19, ["Neon|Ride"] = 140.59, ["Neon|Fly|Ride"] = 140.59, ["Mega"] = 26.25, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 4.94, ["Ride"] = 32.82, ["Neon"] = 10.86, ["Neon|Ride"] = 56.48, ["Neon|Fly|Ride"] = 192.94, ["Mega"] = 56.43, ["Mega|Ride"] = 155.72, ["Mega|Fly|Ride"] = 307.13}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 12.73, ["Fly"] = 82.89, ["Ride"] = 58.67, ["Fly|Ride"] = 161.64, ["Neon"] = 15.74, ["Neon|Fly"] = 129.04, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 112.26, ["Mega"] = 209.99, ["Mega|Ride"] = 185.07, ["Mega|Fly|Ride"] = 297.91}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 15.74, ["Ride"] = 13.12, ["Fly|Ride"] = 36.04, ["Neon"] = 2.63, ["Neon|Fly"] = 23.09, ["Neon|Ride"] = 35.17, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 23.25, ["Mega|Ride"] = 31.39, ["Mega|Fly|Ride"] = 103.69}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 15.74, ["Ride"] = 42, ["Fly|Ride"] = 104.92, ["Neon"] = 60.85, ["Neon|Fly|Ride"] = 189.67, ["Mega|Ride"] = 388.12, ["Mega|Fly|Ride"] = 350.36}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 3018.75, ["Ride"] = 3543.75, ["Fly|Ride"] = 3409.61, ["Neon|Fly|Ride"] = 9511.72}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 52.49, ["Ride"] = 23.04, ["Fly|Ride"] = 41.99, ["Neon"] = 8.66, ["Neon|Fly"] = 68.46, ["Neon|Ride"] = 26.46, ["Neon|Fly|Ride"] = 62.95, ["Mega"] = 98.61, ["Mega|Ride"] = 99.74, ["Mega|Fly|Ride"] = 250.66}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 5.24, ["Neon"] = 22.44, ["Mega"] = 126, ["Mega|Ride"] = 419.58, ["Mega|Fly|Ride"] = 629.37}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 22.53, ["Ride"] = 28.88, ["Fly|Ride"] = 157.5, ["Neon"] = 96.5, ["Neon|Ride"] = 78.69, ["Neon|Fly|Ride"] = 140.59, ["Mega"] = 419.58, ["Mega|Ride"] = 523.43, ["Mega|Fly|Ride"] = 719.27}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 51.16, ["Ride"] = 78.75, ["Fly|Ride"] = 105, ["Mega"] = 1258.72, ["Mega|Ride"] = 623.06, ["Mega|Fly|Ride"] = 720.88}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 140.44, ["Fly"] = 1399.44, ["Ride"] = 164.07, ["Fly|Ride"] = 309.48, ["Neon"] = 1678.49, ["Neon|Ride"] = 805.88, ["Neon|Fly|Ride"] = 728.44, ["Mega"] = 6293.53, ["Mega|Ride"] = 3007.27, ["Mega|Fly|Ride"] = 3543.75}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 6.04, ["Ride"] = 39.38, ["Fly|Ride"] = 675.94, ["Neon"] = 16.28, ["Neon|Ride"] = 139.47, ["Neon|Fly|Ride"] = 140.58, ["Mega"] = 278.25, ["Mega|Fly|Ride"] = 253.32}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 27.28, ["Neon"] = 20.99, ["Neon|Fly"] = 96.52, ["Neon|Ride"] = 37.78, ["Mega"] = 62.95, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 825.57}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 3.82, ["Fly"] = 101.99, ["Ride"] = 36.72, ["Fly|Ride"] = 118.13, ["Neon"] = 9.19, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 251.78, ["Mega"] = 66.77, ["Mega|Ride"] = 98.44, ["Mega|Fly|Ride"] = 287.44}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 15.69, ["Neon|Ride"] = 209.83, ["Mega"] = 513.24, ["Mega|Ride"] = 464.8, ["Mega|Fly|Ride"] = 317.84}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 2.63, ["Mega"] = 15.75, ["Mega|Ride"] = 133.88, ["Mega|Fly|Ride"] = 140.58}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 91.88, ["Fly"] = 435.38, ["Ride"] = 116.46, ["Fly|Ride"] = 155.27, ["Neon"] = 464.85, ["Neon|Ride"] = 462.53, ["Neon|Fly|Ride"] = 459.5, ["Mega|Ride"] = 1678.29, ["Mega|Fly|Ride"] = 1704.61}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 32.54, ["Neon"] = 10.31, ["Mega|Ride"] = 112.88}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 39.38, ["Fly"] = 217.32, ["Ride"] = 100.73, ["Fly|Ride"] = 131.25, ["Neon"] = 271.95, ["Neon|Ride"] = 155.74, ["Neon|Fly|Ride"] = 419.43, ["Mega"] = 2625, ["Mega|Ride"] = 2797.49, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 52.5, ["Fly|Ride"] = 70.3, ["Neon"] = 3.94, ["Neon|Ride"] = 91.82, ["Neon|Fly|Ride"] = 86.89, ["Mega"] = 45.94, ["Mega|Ride"] = 65.62, ["Mega|Fly|Ride"] = 211.98}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 3.28, ["Neon"] = 13.6, ["Mega"] = 84, ["Mega|Ride"] = 216.09, ["Mega|Fly|Ride"] = 434.44}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 13.12, ["Ride"] = 52.5, ["Fly|Ride"] = 140.59, ["Neon"] = 63, ["Neon|Fly"] = 291.38, ["Neon|Ride"] = 115.5, ["Mega"] = 182.53, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 944.05}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 420.13, ["Ride"] = 446.25, ["Fly|Ride"] = 635.29, ["Neon"] = 1179.94, ["Neon|Ride"] = 1219.32, ["Neon|Fly|Ride"] = 1258.69, ["Mega"] = 2788.71, ["Mega|Ride"] = 3018.75, ["Mega|Fly|Ride"] = 3480.32}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 39.38, ["Ride"] = 56.43, ["Fly|Ride"] = 78.75, ["Neon"] = 181.12, ["Neon|Fly"] = 310.3, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 217.48, ["Mega"] = 799.29, ["Mega|Fly|Ride"] = 1548.75}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 34.13, ["Ride"] = 32.82, ["Fly|Ride"] = 91.88, ["Neon"] = 10.49, ["Neon|Fly"] = 136.4, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 39.38, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 232.4}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 14.32, ["Fly"] = 60.85, ["Ride"] = 40.94, ["Fly|Ride"] = 91.88, ["Neon"] = 42, ["Neon|Fly"] = 140.59, ["Neon|Ride"] = 82.93, ["Neon|Fly|Ride"] = 176.19, ["Mega"] = 240.52, ["Mega|Fly"] = 375.53, ["Mega|Ride"] = 280.08, ["Mega|Fly|Ride"] = 383.24}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 8.45, ["Ride"] = 39.38, ["Fly|Ride"] = 70.62, ["Neon"] = 105, ["Neon|Ride"] = 73.5, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 469.93, ["Mega|Ride"] = 448.95, ["Mega|Fly|Ride"] = 510.84}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 10.19, ["Neon"] = 18.38, ["Mega"] = 52.5, ["Mega|Ride"] = 139.12, ["Mega|Fly|Ride"] = 217.3}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.1, ["Fly"] = 86.63, ["Ride"] = 19.69, ["Fly|Ride"] = 59.06, ["Neon"] = 26.24, ["Neon|Ride"] = 70.3, ["Neon|Fly|Ride"] = 280.11, ["Mega"] = 542.64, ["Mega|Ride"] = 486.94}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 105, ["Fly"] = 161.57, ["Ride"] = 122.13, ["Fly|Ride"] = 236.25, ["Neon"] = 419.64, ["Neon|Ride"] = 725.07, ["Neon|Fly|Ride"] = 620.58, ["Mega|Ride"] = 2545.75, ["Mega|Fly|Ride"] = 2649.6}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 26.24, ["Ride"] = 78.75, ["Fly|Ride"] = 144, ["Neon"] = 155.27, ["Neon|Ride"] = 280.11, ["Mega"] = 697.18, ["Mega|Ride"] = 670.28, ["Mega|Fly|Ride"] = 692.3}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2552.82, ["Ride"] = 2769.5, ["Fly|Ride"] = 2756.25, ["Neon"] = 12588.58, ["Neon|Fly|Ride"] = 8708.77, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 6.57, ["Fly"] = 65625, ["Ride"] = 22.1, ["Fly|Ride"] = 170.63, ["Neon"] = 13.13, ["Neon|Ride"] = 41.97, ["Mega"] = 97.13, ["Mega|Ride"] = 169.32}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 8.91, ["Neon"] = 61.05, ["Neon|Ride"] = 280.11, ["Neon|Fly|Ride"] = 350.4, ["Mega"] = 146.87, ["Mega|Ride"] = 280.08, ["Mega|Fly|Ride"] = 560.14}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 1050, ["Fly"] = 1399.44, ["Ride"] = 1019.82, ["Fly|Ride"] = 1311.19, ["Neon"] = 3564.17, ["Neon|Ride"] = 4039.89, ["Neon|Fly|Ride"] = 3543.75, ["Mega|Ride"] = 14684.87, ["Mega|Fly|Ride"] = 13649.99}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 47.23, ["Fly|Ride"] = 112.26, ["Neon"] = 258.07, ["Mega"] = 840, ["Mega|Ride"] = 1394.36, ["Mega|Fly|Ride"] = 752.07}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 3.94, ["Ride"] = 46.17, ["Neon"] = 19.69, ["Neon|Ride"] = 70.3, ["Neon|Fly|Ride"] = 104.92, ["Mega"] = 190.98, ["Mega|Ride"] = 347.2, ["Mega|Fly|Ride"] = 274.98}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 111.19, ["Neon"] = 3.93, ["Neon|Ride"] = 52.49, ["Mega"] = 29.69, ["Mega|Ride"] = 68.25, ["Mega|Fly|Ride"] = 125.89}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 87.94, ["Ride"] = 279.06, ["Neon"] = 699.74, ["Neon|Ride"] = 406.04, ["Mega"] = 5250, ["Mega|Fly|Ride"] = 2517.42}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 7.12, ["Ride"] = 157.5, ["Neon"] = 36.04, ["Neon|Ride"] = 103.87, ["Mega"] = 196.88, ["Mega|Ride"] = 155.72, ["Mega|Fly|Ride"] = 419.58}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 74.8, ["Ride"] = 140.59, ["Neon"] = 620.58, ["Mega|Fly|Ride"] = 1810.45}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 6.98, ["Fly"] = 105, ["Neon"] = 20.99, ["Neon|Fly|Ride"] = 315, ["Mega"] = 224.44}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 282.19, ["Ride"] = 329.33, ["Fly|Ride"] = 335.71, ["Neon"] = 1766.63, ["Neon|Ride"] = 950.45, ["Neon|Fly|Ride"] = 1023.75, ["Mega|Fly|Ride"] = 4011.08}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 4.99, ["Fly"] = 70.3, ["Ride"] = 22.32, ["Fly|Ride"] = 83.94, ["Neon"] = 41.98, ["Neon|Ride"] = 56.66, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 241.5, ["Mega|Ride"] = 310.25, ["Mega|Fly|Ride"] = 350.44}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 26.75, ["Ride"] = 16.49, ["Fly|Ride"] = 36.74, ["Neon"] = 4.19, ["Neon|Fly"] = 27.28, ["Neon|Ride"] = 25.39, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 26.25, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 125.89}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 787.5, ["Fly"] = 1105.71, ["Ride"] = 903, ["Fly|Ride"] = 984.35, ["Neon|Ride"] = 7693.73, ["Neon|Fly|Ride"] = 4196.2, ["Mega"] = 29369.74}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 9.19, ["Fly"] = 980.19, ["Ride"] = 210, ["Neon"] = 50.35, ["Neon|Ride"] = 69.84, ["Mega"] = 150.94, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 291.38}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 7.87, ["Fly"] = 70.3, ["Ride"] = 44.63, ["Fly|Ride"] = 91.28, ["Neon"] = 36.73, ["Neon|Fly"] = 76.71, ["Neon|Ride"] = 70.3, ["Neon|Fly|Ride"] = 280.11, ["Mega"] = 171.98, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 314.7}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 37.91, ["Fly"] = 32.82, ["Ride"] = 45.45, ["Fly|Ride"] = 62.82, ["Neon|Ride"] = 185.94, ["Neon|Fly|Ride"] = 202.13, ["Mega"] = 2097.85, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 21.39, ["Fly"] = 78.69, ["Ride"] = 41.97, ["Fly|Ride"] = 109.12, ["Neon"] = 56.66, ["Neon|Ride"] = 82.89, ["Neon|Fly|Ride"] = 185.95, ["Mega"] = 464.8, ["Mega|Ride"] = 303.19, ["Mega|Fly|Ride"] = 442.31}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 24.83, ["Ride"] = 62.76, ["Fly|Ride"] = 636.57, ["Neon"] = 140.59, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 435.31, ["Mega|Ride"] = 494.06, ["Mega|Fly|Ride"] = 453.15}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 116.59, ["Neon"] = 2.63, ["Neon|Ride"] = 65.63, ["Mega"] = 24.13, ["Mega|Ride"] = 89.25}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 36.04, ["Fly"] = 66.11, ["Ride"] = 50.37, ["Fly|Ride"] = 77.44, ["Neon"] = 270.72, ["Neon|Fly"] = 310.21, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 338.86, ["Mega"] = 3356.56, ["Mega|Fly|Ride"] = 1063.62}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.1, ["Fly"] = 140.59, ["Ride"] = 27.55, ["Fly|Ride"] = 127.32, ["Neon|Ride"] = 141.07, ["Mega"] = 140.58, ["Mega|Ride"] = 271.69}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 25.19, ["Ride"] = 18.38, ["Fly|Ride"] = 70.3, ["Neon"] = 39.38, ["Neon|Fly|Ride"] = 109.26, ["Mega"] = 1036.34, ["Mega|Ride"] = 280.08, ["Mega|Fly|Ride"] = 202.13}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 2.91, ["Neon"] = 14.44, ["Neon|Fly|Ride"] = 104.92, ["Mega"] = 294}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 27.41, ["Fly"] = 262.5, ["Ride"] = 41.98, ["Fly|Ride"] = 105, ["Neon"] = 116.8, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 231.84, ["Mega"] = 1119.22, ["Mega|Ride"] = 735, ["Mega|Fly|Ride"] = 766.9}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 9.18, ["Neon"] = 23.63, ["Neon|Ride"] = 62.93, ["Mega"] = 104.78, ["Mega|Fly|Ride"] = 310.25}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 27.28, ["Neon"] = 2.63, ["Neon|Ride"] = 91.88, ["Mega"] = 17.07, ["Mega|Ride"] = 41.97, ["Mega|Fly|Ride"] = 200.17}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Ride"] = 28.33, ["Neon"] = 3.29, ["Neon|Fly"] = 393.65, ["Neon|Ride"] = 33.59, ["Mega"] = 15.22, ["Mega|Fly"] = 73.86, ["Mega|Ride"] = 49.31, ["Mega|Fly|Ride"] = 140.44}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 31.49, ["Ride"] = 23.63, ["Fly|Ride"] = 40.05, ["Neon"] = 11.05, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 28.33, ["Neon|Fly|Ride"] = 88.13, ["Mega"] = 86.63, ["Mega|Ride"] = 132.18, ["Mega|Fly|Ride"] = 246.1}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.63, ["Ride"] = 27.28, ["Fly|Ride"] = 5229.45, ["Neon"] = 20.99, ["Neon|Ride"] = 1312.5, ["Mega"] = 140.58, ["Mega|Ride"] = 146.88}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 39.77, ["Ride"] = 16.95, ["Fly|Ride"] = 45.94, ["Neon"] = 25.19, ["Neon|Ride"] = 31.38, ["Neon|Fly|Ride"] = 80.07, ["Mega"] = 492.85, ["Mega|Ride"] = 128.63, ["Mega|Fly|Ride"] = 361.59}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 84, ["Ride"] = 167.87, ["Fly|Ride"] = 392.36, ["Neon|Ride"] = 248.07, ["Neon|Fly|Ride"] = 1049.06, ["Mega"] = 954.76, ["Mega|Ride"] = 1049.99, ["Mega|Fly|Ride"] = 941.95}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 26.23, ["Ride"] = 17.82, ["Fly|Ride"] = 133.88, ["Neon"] = 3.94, ["Neon|Fly"] = 27.28, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 67.16, ["Mega"] = 36.75, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 144.77}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 8.39, ["Fly"] = 32.47, ["Ride"] = 32.82, ["Fly|Ride"] = 80.07, ["Neon"] = 19.69, ["Neon|Ride"] = 59.06, ["Neon|Fly|Ride"] = 152.25, ["Mega"] = 525, ["Mega|Ride"] = 288.18, ["Mega|Fly|Ride"] = 464.8}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 9.56, ["Fly"] = 56.65, ["Ride"] = 32.82, ["Fly|Ride"] = 82.89, ["Neon"] = 98.44, ["Neon|Ride"] = 96.79, ["Neon|Fly|Ride"] = 112.26, ["Mega"] = 839.15, ["Mega|Ride"] = 1260.82, ["Mega|Fly|Ride"] = 440.56}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 3.94, ["Fly"] = 140.38, ["Ride"] = 46.4, ["Neon"] = 38.53, ["Mega"] = 280.08, ["Mega|Ride"] = 243.37}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 17.38, ["Fly|Ride"] = 56.44, ["Neon"] = 3.93, ["Neon|Fly"] = 81.38, ["Neon|Ride"] = 22.1, ["Neon|Fly|Ride"] = 109.26, ["Mega"] = 46.17, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 61.57, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 3.89, ["Ride"] = 28.33, ["Neon"] = 15.68, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 62.46, ["Neon|Fly|Ride"] = 157.37, ["Mega"] = 109.11, ["Mega|Fly"] = 735, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 280.08}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 956.82, ["Ride"] = 1049.99, ["Fly|Ride"] = 1085.41, ["Neon"] = 2718.12, ["Neon|Ride"] = 2832.44, ["Neon|Fly|Ride"] = 2275.88, ["Mega|Fly|Ride"] = 7434}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 60.85, ["Ride"] = 112.24, ["Fly|Ride"] = 131.25, ["Neon"] = 210, ["Neon|Ride"] = 266.47, ["Neon|Fly|Ride"] = 488.1, ["Mega"] = 2812.69, ["Mega|Ride"] = 1258.72, ["Mega|Fly|Ride"] = 1162.22}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Fly"] = 62.95, ["Neon"] = 6.57, ["Neon|Ride"] = 74.5, ["Neon|Fly|Ride"] = 315, ["Mega"] = 61.93, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 145.82}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 34.13, ["Ride"] = 52.45, ["Fly|Ride"] = 262.5, ["Neon"] = 188.84, ["Neon|Ride"] = 209.83, ["Neon|Fly|Ride"] = 699.74, ["Mega"] = 1239.82, ["Mega|Ride"] = 773.07, ["Mega|Fly|Ride"] = 1145.43}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 6.04, ["Ride"] = 36.73, ["Neon"] = 60.38, ["Neon|Ride"] = 131.25, ["Mega"] = 232.4, ["Mega|Ride"] = 232.4, ["Mega|Fly|Ride"] = 1048.93}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 280.08, ["Fly"] = 929.69, ["Ride"] = 409.15, ["Fly|Ride"] = 420, ["Neon"] = 1236.84, ["Neon|Ride"] = 1258.88, ["Neon|Fly|Ride"] = 1166.55, ["Mega|Fly|Ride"] = 4895.33}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.59, ["Fly"] = 102.38, ["Ride"] = 22.32, ["Fly|Ride"] = 129.93, ["Neon"] = 11.82, ["Neon|Ride"] = 73.5, ["Mega"] = 393.75}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Neon"] = 31.61, ["Neon|Ride"] = 91.88, ["Mega"] = 111.2}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 35.68, ["Ride"] = 87.94, ["Neon"] = 140.59, ["Neon|Ride"] = 187.8, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 699.65, ["Mega|Ride"] = 713.35, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 3.93, ["Ride"] = 70.73, ["Fly|Ride"] = 140.59, ["Neon"] = 15.75, ["Mega"] = 222.38, ["Mega|Ride"] = 260.15, ["Mega|Fly|Ride"] = 419.58}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 23.63, ["Ride"] = 15.27, ["Fly|Ride"] = 32.82, ["Neon"] = 3.93, ["Neon|Fly"] = 31.39, ["Neon|Ride"] = 22.92, ["Neon|Fly|Ride"] = 64.84, ["Mega"] = 39.86, ["Mega|Ride"] = 40.69, ["Mega|Fly|Ride"] = 99.65}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 5788.99, ["Ride"] = 4331.25, ["Fly|Ride"] = 4198.69, ["Neon"] = 25177.15, ["Neon|Fly|Ride"] = 25876.86, ["Mega|Fly|Ride"] = 78575.59}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 12.47, ["Ride"] = 50.37, ["Neon"] = 155.74, ["Neon|Ride"] = 85.32, ["Mega"] = 196.88, ["Mega|Ride"] = 392.32, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Ride"] = 27.28, ["Fly|Ride"] = 39.38, ["Neon"] = 15.63, ["Neon|Fly"] = 41.98, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 92.98, ["Mega"] = 140.58, ["Mega|Ride"] = 419.58, ["Mega|Fly|Ride"] = 203.51}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 419.58, ["Fly"] = 840, ["Ride"] = 487.19, ["Fly|Ride"] = 551.25, ["Neon"] = 1678.49, ["Neon|Ride"] = 1538.97, ["Neon|Fly|Ride"] = 1237.89, ["Mega|Fly|Ride"] = 4199.99}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 4.19, ["Ride"] = 52.5, ["Neon"] = 20.98, ["Neon|Ride"] = 209.83, ["Mega"] = 144.38, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 686.01}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 4.19, ["Fly"] = 99.49, ["Ride"] = 77.88, ["Neon"] = 26.24, ["Neon|Ride"] = 280.11, ["Neon|Fly|Ride"] = 13988, ["Mega"] = 280.08, ["Mega|Ride"] = 401.63}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 60.38, ["Ride"] = 23.63, ["Neon"] = 5.25, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 33.71, ["Mega"] = 42, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 213.99}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 618.19, ["Ride"] = 755.32, ["Fly|Ride"] = 775.13, ["Neon|Fly|Ride"] = 2470.52, ["Mega|Fly|Ride"] = 8751.75}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 7.38, ["Ride"] = 34.13, ["Neon"] = 21, ["Neon|Ride"] = 98.63, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 141.75, ["Mega|Ride"] = 249.66, ["Mega|Fly|Ride"] = 355.93}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 7.83, ["Fly"] = 167.87, ["Ride"] = 30.19, ["Neon"] = 36.15, ["Neon|Ride"] = 109.26, ["Neon|Fly|Ride"] = 120.86, ["Mega"] = 242.82, ["Mega|Ride"] = 227.07, ["Mega|Fly|Ride"] = 348.6}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 28.54, ["Ride"] = 19.69, ["Fly|Ride"] = 51.18, ["Neon"] = 17.07, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 86.63, ["Mega"] = 129.94, ["Mega|Ride"] = 158.82, ["Mega|Fly|Ride"] = 266.44}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 31.49, ["Ride"] = 62.76, ["Neon"] = 106.95, ["Neon|Ride"] = 139.47, ["Mega"] = 545.45, ["Mega|Ride"] = 618.87, ["Mega|Fly|Ride"] = 525.87}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Ride"] = 39.37, ["Neon"] = 5.25, ["Neon|Ride"] = 56.66, ["Neon|Fly|Ride"] = 2033.68, ["Mega"] = 32.52, ["Mega|Ride"] = 92.97, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 557, ["Ride"] = 566.5, ["Fly|Ride"] = 587.48, ["Neon"] = 2071.89, ["Neon|Ride"] = 2079.23, ["Neon|Fly|Ride"] = 2093.65, ["Mega|Fly|Ride"] = 9930.13}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 31.5, ["Neon"] = 6.57, ["Neon|Ride"] = 91.28, ["Neon|Fly|Ride"] = 209.83, ["Mega"] = 41.97, ["Mega|Ride"] = 119.59, ["Mega|Fly|Ride"] = 328.91}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 3.94, ["Neon|Fly"] = 140.59, ["Neon|Ride"] = 182.55, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 35.68, ["Mega|Ride"] = 82.88, ["Mega|Fly|Ride"] = 263.29}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Ride"] = 45.92, ["Mega"] = 40.68, ["Mega|Ride"] = 77.87, ["Mega|Fly|Ride"] = 204.56}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.1, ["Ride"] = 124.69, ["Neon"] = 20.99, ["Mega"] = 224.48}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 48.57, ["Ride"] = 93, ["Fly|Ride"] = 156.19, ["Neon"] = 208.78, ["Neon|Ride"] = 203.54, ["Neon|Fly|Ride"] = 465.29, ["Mega"] = 699.65, ["Mega|Ride"] = 433.13, ["Mega|Fly|Ride"] = 681.19}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 140.6, ["Ride"] = 82.69, ["Fly|Ride"] = 105, ["Neon"] = 85.31, ["Neon|Ride"] = 188.84, ["Mega"] = 418.52, ["Mega|Ride"] = 560.14, ["Mega|Fly|Ride"] = 488.24}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 19.09, ["Fly|Ride"] = 35.02, ["Neon"] = 17.42, ["Neon|Ride"] = 35.07, ["Neon|Fly|Ride"] = 82.69, ["Mega"] = 307.79, ["Mega|Ride"] = 206.07, ["Mega|Fly|Ride"] = 238.88}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 12.6, ["Ride"] = 39.38, ["Neon"] = 280.11, ["Neon|Ride"] = 158.82, ["Mega"] = 459.38, ["Mega|Fly|Ride"] = 520.29}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 28.33, ["Fly|Ride"] = 362.25, ["Neon"] = 11.82, ["Neon|Ride"] = 41.98, ["Mega"] = 82.69, ["Mega|Ride"] = 146.87, ["Mega|Fly|Ride"] = 245.46}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 20.26, ["Ride"] = 31.5, ["Fly|Ride"] = 56.44, ["Neon"] = 209.83, ["Neon|Ride"] = 104.92, ["Neon|Fly|Ride"] = 224.48, ["Mega"] = 943, ["Mega|Ride"] = 929.58, ["Mega|Fly|Ride"] = 629.99}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 96.46, ["Fly"] = 874.13, ["Neon"] = 310.3, ["Neon|Ride"] = 328.13}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 43.31, ["Fly"] = 115.5, ["Ride"] = 77.44, ["Fly|Ride"] = 155.74, ["Neon"] = 288.75, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 406, ["Mega|Ride"] = 1643.02, ["Mega|Fly|Ride"] = 1316.44}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 70.3, ["Fly"] = 126.1, ["Ride"] = 98.63, ["Neon"] = 175.21, ["Neon|Ride"] = 167.87, ["Neon|Fly|Ride"] = 280.11, ["Mega"] = 1048.93, ["Mega|Ride"] = 775.04, ["Mega|Fly|Ride"] = 929.58}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 25.72, ["Ride"] = 34.13, ["Neon"] = 157.5, ["Neon|Ride"] = 223.13, ["Mega"] = 839.15, ["Mega|Ride"] = 793, ["Mega|Fly|Ride"] = 1258.72}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 6.36, ["Fly"] = 52.5, ["Ride"] = 36.73, ["Fly|Ride"] = 85.32, ["Neon"] = 39.37, ["Neon|Fly"] = 167.87, ["Neon|Ride"] = 95.3, ["Neon|Fly|Ride"] = 125.9, ["Mega"] = 492.82, ["Mega|Ride"] = 345.18, ["Mega|Fly|Ride"] = 523.43}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 28.33, ["Ride"] = 16.94, ["Fly|Ride"] = 41.56, ["Neon"] = 2.63, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 21.1, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 40.69, ["Mega|Ride"] = 86.03, ["Mega|Fly|Ride"] = 186.38}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 917.44}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 40.68, ["Ride"] = 124.82, ["Fly|Ride"] = 262.5, ["Neon"] = 125.9, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 418.38, ["Mega"] = 560.14, ["Mega|Ride"] = 573.78, ["Mega|Fly|Ride"] = 699.65}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 56.66, ["Neon"] = 3.93, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 293.74, ["Mega"] = 30.23, ["Mega|Ride"] = 58.75, ["Mega|Fly|Ride"] = 217.88}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 27.57, ["Neon"] = 261.19, ["Neon|Ride"] = 350.4, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 734.26, ["Mega|Ride"] = 733.22, ["Mega|Fly|Ride"] = 590.62}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Mega"] = 30.19}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 3.89, ["Neon|Ride"] = 87.17, ["Mega"] = 26.25, ["Mega|Ride"] = 83.93, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 144.38, ["Ride"] = 243.16, ["Fly|Ride"] = 263.82, ["Neon"] = 597.19, ["Neon|Ride"] = 590.63, ["Neon|Fly|Ride"] = 770.02, ["Mega|Ride"] = 6390.76, ["Mega|Fly|Ride"] = 2034.37}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 22.88, ["Fly|Ride"] = 88.13, ["Neon"] = 11.43, ["Neon|Fly"] = 62.95, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 155.27, ["Mega"] = 107.62, ["Mega|Ride"] = 123.38, ["Mega|Fly|Ride"] = 489.86}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 48.27, ["Fly|Ride"] = 86.63, ["Neon"] = 10.5, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 419.99, ["Mega"] = 51.19, ["Mega|Ride"] = 103.87, ["Mega|Fly|Ride"] = 208}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 35.44, ["Mega"] = 24.13, ["Mega|Ride"] = 74.8, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 91.88, ["Neon"] = 4.67, ["Neon|Ride"] = 156.19, ["Neon|Fly|Ride"] = 140.59, ["Mega"] = 35.68, ["Mega|Ride"] = 94.5, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 35.43, ["Ride"] = 86.63, ["Fly|Ride"] = 620.42, ["Neon"] = 336.99, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 976.57, ["Mega|Ride"] = 1538.78, ["Mega|Fly|Ride"] = 1538.22}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 2.63, ["Ride"] = 139.47, ["Neon"] = 32.82, ["Neon|Ride"] = 111.57, ["Mega"] = 140.6, ["Mega|Ride"] = 547.98}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 347.82, ["Ride"] = 367.5, ["Fly|Ride"] = 441.61, ["Neon"] = 2937.35, ["Neon|Ride"] = 1119.35, ["Neon|Fly|Ride"] = 1168.5, ["Mega"] = 3532.78, ["Mega|Fly|Ride"] = 3150}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 66.94}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 38.07}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 14.02}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 28.04}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 524.48}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 53.52}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 10.97}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 7.83}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 213.94}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 22.3}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 42.87}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 17.45}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 7.46}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 259.53}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 6.04}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 7.48}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 10.49}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 23.26}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 465.94}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.35}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 741.6}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 11.82}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1111.69}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 525}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.57}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 14.44}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 12.96}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.5}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 19.47}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 101.84}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 51.18}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 18.38}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 9.19}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 13.1}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 63}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 11.82}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.63}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 28.3}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 15.16}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 5.24}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.61}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 1575}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 116.7}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 301.88}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 9.19}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.5}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 12.6}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 43.12}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 23.24}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 153.6}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 12.79}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 13.11}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 938.06}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 45.32}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 6.57}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.5}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 26.24}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 9.17}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 6.62}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 110.25}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 19.42}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 10.5}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 20.11}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.47}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 10.97}},
    ["rbxassetid://1265129203"] = {name = "Ice Snowboard", prices = {["default"] = 215.69}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 6.23}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 21.99}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 131.25}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 131.25}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.3}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 6.36}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 20.11}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 27.57}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 58.7}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 52.45}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 166.31}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 116.45}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 45.92}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 36.15}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 272.73}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 27.43}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 37.76}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 76.11}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 155.72}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 49.17}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 34.13}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 26.13}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 40.69}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 354.38}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 8.17}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 14.21}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 3.93}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 6.4}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 21}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 32.82}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.6}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 3.93}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.63}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.63}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 4.81}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 4.6}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 8.54}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 669.38}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 27.13}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 3.94}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.63}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 375.53}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.59}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 35.43}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 37.65}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 41.52}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 132.57}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 28.88}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 5.25}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 12.65}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 4.6}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 3.93}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 3.91}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 28.59}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 2.1}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 3.91}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 11.8}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 9.19}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 137.82}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.63}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 1046.84}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 10.45}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 9.34}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 7.62}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 18.16}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 23.62}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 14.18}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 5.13}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 15.1}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 18.36}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 124.36}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 60.8}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 5.91}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 6.98}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.21}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 8.39}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 6.19}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 3.54}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 196.88}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 60.95}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 6.23}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.24}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 4.45}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 4.2}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 8112.36}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 17.46}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 9.31}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 33.89}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 11.24}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 14.44}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 3.82}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 19.58}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 14.99}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 699.65}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.35}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 15.54}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 3.93}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 6.36}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 3.56}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 5.92}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 3.76}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 3.5}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4339.91}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 4.65}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.63}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 47.61}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 7.82}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 81.38}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.61}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 4.47}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 182.28}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.63}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 3.94}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 4.19}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.63}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 3.94}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 26.25}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 41.97}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 3.93}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.63}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.46}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.5}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 46.5}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 6.57}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 4.2}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 3.89}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 5.08}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.37}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 3.82}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 5.25}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 6.57}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.63}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 3.82}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 28.62}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.61}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 6.18}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.61}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 17}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 117.55}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 2.23}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 38.93}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 6.57}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1394.35}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 26.25}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 3.93}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 6.18}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.37}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 22.2}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 4.99}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 3.92}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 14.44}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.63}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 15.74}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 3.93}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 27.02}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 22.98}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 3.15}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 4.73}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 3.72}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 13.89}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 5.25}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 12.77}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 5.66}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 4.7}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 120.94}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.63}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.37}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 42.39}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.63}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 11.39}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 2.1}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 25.95}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 24.02}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 3.82}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 3.93}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 104.92}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 6.18}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 28.01}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 6.36}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 3.94}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 6.3}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 5.25}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 5.23}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 5.92}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 10.5}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 52.5}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 86.63}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 5.13}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 3.15}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.5}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 105}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 9.19}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1510.46}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.63}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 210}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 6.34}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.35}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.63}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.63}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 18.88}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 38.19}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 7.87}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.63}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 95.49}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 8.6}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 3.68}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.37}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 3.81}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 3.93}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 90.22}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 4.61}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 60.88}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 10.16}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 63.94}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 2.63}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 2.24}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 6.3}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 42}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 122.21}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 3.93}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 2.84}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.57}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 60.46}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 45.71}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 3.93}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.63}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 7.87}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 64.32}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 50.93}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 97.13}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 383.93}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 3.29}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 38.94}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.63}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 104.91}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.81}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 7.51}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 27.91}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 148.97}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 3.92}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 23.63}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 404.25}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 11.81}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 28.33}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.37}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 23.39}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 3.82}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 4.97}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 62.76}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.24}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 53.51}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 76.65}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 3.93}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 43.19}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 6.03}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 6.5}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 52.5}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 3.94}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 69.25}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 275.63}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1384.59}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 30.19}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 6.36}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 187.69}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 249.25}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 28.33}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 12.71}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 13.44}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 12.6}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 4.73}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 208.69}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 51.19}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 52.49}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 9.18}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 63.79}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 280.08}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 91.76}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 918.75}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 197.78}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 9.19}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 1187.82}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 525}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 3.93}},
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