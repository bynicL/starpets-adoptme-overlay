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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 823.49, ["Ride"] = 1048.69, ["Fly|Ride"] = 1237.67, ["Neon"] = 6805.32, ["Neon|Ride"] = 6562.5, ["Neon|Fly|Ride"] = 4189.55, ["Mega|Fly|Ride"] = 20112}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 513.19, ["Ride"] = 564.18, ["Fly|Ride"] = 622.65, ["Neon|Fly|Ride"] = 2424.8, ["Mega"] = 11657.31, ["Mega|Fly|Ride"] = 6807.14}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 4948.13, ["Ride"] = 5117.44, ["Fly|Ride"] = 4689.57, ["Neon|Fly|Ride"] = 20627.69, ["Mega|Fly|Ride"] = 68759.28}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 167.05, ["Ride"] = 246.52, ["Fly|Ride"] = 275.63, ["Neon"] = 894.23, ["Neon|Ride"] = 825.12, ["Neon|Fly|Ride"] = 825.12, ["Mega|Fly|Ride"] = 3937.49}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 632.62, ["Ride"] = 538.13, ["Fly|Ride"] = 595.88, ["Neon|Fly|Ride"] = 1745.62, ["Mega|Fly|Ride"] = 6528.11}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 9.83, ["Ride"] = 29.25, ["Fly|Ride"] = 156.26, ["Neon"] = 39.38, ["Neon|Ride"] = 84.13, ["Neon|Fly|Ride"] = 404.25, ["Mega"] = 352.03, ["Mega|Ride"] = 262.49, ["Mega|Fly|Ride"] = 577.05}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 3.94, ["Fly"] = 42.24, ["Ride"] = 23.43, ["Fly|Ride"] = 68.09, ["Neon"] = 27.57, ["Neon|Fly"] = 78.14, ["Neon|Ride"] = 51.58, ["Neon|Fly|Ride"] = 104.81, ["Mega"] = 153.57, ["Mega|Ride"] = 213.94, ["Mega|Fly|Ride"] = 277.35}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 104.99, ["Fly"] = 206.29, ["Ride"] = 152.27, ["Fly|Ride"] = 240.19, ["Neon"] = 459.38, ["Neon|Ride"] = 493.5, ["Neon|Fly|Ride"] = 1650.23, ["Mega|Fly|Ride"] = 3439.68}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 31.5, ["Fly"] = 97.75, ["Ride"] = 48.97, ["Fly|Ride"] = 105.99, ["Neon"] = 288.81, ["Neon|Ride"] = 237.93, ["Neon|Fly|Ride"] = 334.69, ["Mega"] = 2100}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 27.57, ["Fly"] = 69.47, ["Ride"] = 26.25, ["Fly|Ride"] = 66.94, ["Neon"] = 143.37, ["Neon|Ride"] = 284.68, ["Neon|Fly|Ride"] = 307.37, ["Mega|Fly|Ride"] = 618.84}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 57.64, ["Fly"] = 206.07, ["Ride"] = 90.78, ["Fly|Ride"] = 169.99, ["Neon"] = 436.1, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 416.07, ["Mega|Fly|Ride"] = 1237.67}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 67.26}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 313.48, ["Fly"] = 399, ["Ride"] = 323.18, ["Fly|Ride"] = 374.06, ["Neon|Ride"] = 1023.75, ["Neon|Fly|Ride"] = 1049.99, ["Mega|Fly|Ride"] = 4879.49}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 140.44, ["Fly"] = 179.64, ["Ride"] = 124.78, ["Fly|Ride"] = 196.88, ["Neon|Fly|Ride"] = 686.93, ["Mega|Fly|Ride"] = 3026.1}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 3.92, ["Ride"] = 55.04, ["Fly|Ride"] = 131.24, ["Neon"] = 19.68, ["Neon|Fly"] = 96.96, ["Neon|Ride"] = 47.72, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 131.25, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 311.5, ["Mega|Fly|Ride"] = 304.27}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 189.89, ["Fly"] = 204.45, ["Ride"] = 204.23, ["Fly|Ride"] = 210, ["Neon"] = 777.74, ["Neon|Fly|Ride"] = 590.63, ["Mega"] = 3575.83, ["Mega|Fly|Ride"] = 2730}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.15, ["Fly"] = 275.39, ["Ride"] = 17.43, ["Fly|Ride"] = 42, ["Neon"] = 35, ["Neon|Ride"] = 90.78, ["Neon|Fly|Ride"] = 108.96, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 412.56}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 98.41, ["Fly"] = 466.39, ["Ride"] = 124.69, ["Fly|Ride"] = 203.4, ["Neon"] = 330.05, ["Neon|Fly"] = 466.41, ["Neon|Ride"] = 412.55, ["Neon|Fly|Ride"] = 523.69, ["Mega"] = 1710.14, ["Mega|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 1614.38}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 37.43}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 66.52, ["Ride"] = 101.09, ["Fly|Ride"] = 238.26, ["Neon"] = 577.5, ["Neon|Fly|Ride"] = 787.5}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 14.2, ["Fly"] = 393.75, ["Ride"] = 32.15, ["Fly|Ride"] = 129.97, ["Neon"] = 159.17, ["Neon|Ride"] = 209.99, ["Neon|Fly|Ride"] = 367.5, ["Mega|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 1650.23}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 41.36, ["Fly"] = 157.49, ["Ride"] = 48.57, ["Fly|Ride"] = 102.38, ["Neon"] = 275.39, ["Neon|Ride"] = 309.74, ["Neon|Fly|Ride"] = 275.33, ["Mega"] = 1632.04, ["Mega|Ride"] = 1375.88, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 48.2, ["Fly"] = 65.63, ["Ride"] = 157.5, ["Fly|Ride"] = 138.22, ["Neon"] = 209.9, ["Neon|Ride"] = 344.5, ["Neon|Fly|Ride"] = 467.25, ["Mega"] = 1967.44, ["Mega|Fly|Ride"] = 1260.36}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 29.79, ["Ride"] = 44.63, ["Fly|Ride"] = 138.22, ["Neon"] = 477.75, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 311.29, ["Mega"] = 823.07, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 40.59, ["Fly"] = 633.28, ["Ride"] = 65.63, ["Fly|Ride"] = 123.78, ["Neon"] = 428.05, ["Neon|Ride"] = 378.11, ["Neon|Fly|Ride"] = 322.88, ["Mega|Ride"] = 1124.82, ["Mega|Fly|Ride"] = 943.69}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 4.69, ["Fly"] = 26.99, ["Ride"] = 22.31, ["Fly|Ride"] = 58.22, ["Neon"] = 36.74, ["Neon|Fly"] = 101.04, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 96.67, ["Mega"] = 190.32, ["Mega|Fly"] = 298.12, ["Mega|Ride"] = 182.42, ["Mega|Fly|Ride"] = 288.08}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 393.75, ["Ride"] = 467.43, ["Fly|Ride"] = 536.33, ["Neon|Ride"] = 1788.44, ["Neon|Fly|Ride"] = 1964.82, ["Mega|Fly|Ride"] = 6862.85}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 12.92, ["Ride"] = 32.22, ["Neon"] = 204.27, ["Neon|Fly|Ride"] = 275.39, ["Mega|Fly|Ride"] = 671.66}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 7.87, ["Fly"] = 34.61, ["Ride"] = 19.32, ["Fly|Ride"] = 42, ["Neon"] = 71.14, ["Neon|Ride"] = 82.53, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 412.56, ["Mega|Ride"] = 543.56, ["Mega|Fly|Ride"] = 421.25}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 87.94, ["Fly"] = 106.24, ["Ride"] = 94.33, ["Fly|Ride"] = 131.25, ["Neon"] = 385.75, ["Neon|Fly"] = 376.72, ["Neon|Ride"] = 385.75, ["Neon|Fly|Ride"] = 433.13, ["Mega"] = 3713, ["Mega|Ride"] = 7874.99, ["Mega|Fly|Ride"] = 1636.83}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 13.1, ["Ride"] = 41.1, ["Fly|Ride"] = 118.13, ["Neon"] = 114.51, ["Neon|Ride"] = 82.53, ["Neon|Fly|Ride"] = 192.88, ["Mega"] = 550.77, ["Mega|Ride"] = 786.96, ["Mega|Fly|Ride"] = 825.12}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 223.13, ["Fly"] = 348.63, ["Ride"] = 261.99, ["Fly|Ride"] = 298.31, ["Neon"] = 656.25, ["Neon|Ride"] = 825.57, ["Neon|Fly|Ride"] = 981.89, ["Mega"] = 6188.32, ["Mega|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 3018.75}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 26.25}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.92, ["Fly"] = 31.4, ["Ride"] = 23.52, ["Fly|Ride"] = 115.5, ["Neon"] = 21, ["Neon|Fly"] = 5156.93, ["Neon|Ride"] = 52.48, ["Neon|Fly|Ride"] = 179.48, ["Mega"] = 161.44, ["Mega|Ride"] = 160.91, ["Mega|Fly|Ride"] = 274.85}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 889.11, ["Fly"] = 2625, ["Ride"] = 992.25, ["Fly|Ride"] = 1053.24, ["Neon"] = 3905.86, ["Neon|Ride"] = 6051.14, ["Neon|Fly|Ride"] = 4125.55, ["Mega|Ride"] = 52457.87, ["Mega|Fly|Ride"] = 17083.5}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 13.11, ["Fly"] = 69.12, ["Ride"] = 20.23, ["Fly|Ride"] = 109.61, ["Neon"] = 138.22, ["Neon|Ride"] = 116.61, ["Neon|Fly|Ride"] = 165.04, ["Mega"] = 787.5, ["Mega|Ride"] = 963.33, ["Mega|Fly|Ride"] = 820.31}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 186.38, ["Ride"] = 193.39, ["Fly|Ride"] = 304.27, ["Neon"] = 1788.44, ["Neon|Ride"] = 810.15, ["Neon|Fly|Ride"] = 958.13, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 3150}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 44.45}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 10.31, ["Ride"] = 65.63, ["Fly|Ride"] = 138.22, ["Neon"] = 104.89, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 289.14, ["Mega"] = 684.53, ["Mega|Ride"] = 1088.12, ["Mega|Fly|Ride"] = 577.05}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 127.32, ["Ride"] = 164.06, ["Fly|Ride"] = 236.25, ["Neon|Ride"] = 446.92, ["Neon|Fly|Ride"] = 687.94, ["Mega|Fly|Ride"] = 2716.88}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 275.39, ["Fly"] = 157.49, ["Ride"] = 192.94, ["Fly|Ride"] = 274.31, ["Neon"] = 315, ["Neon|Ride"] = 386.78, ["Neon|Fly|Ride"] = 523.69, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1466.06}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 30.18}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 52.5, ["Fly"] = 60.12, ["Ride"] = 57.75, ["Fly|Ride"] = 73.35, ["Neon|Ride"] = 412.56, ["Neon|Fly|Ride"] = 381.53, ["Mega|Fly|Ride"] = 1592.07}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 7.88, ["Ride"] = 55.71, ["Fly|Ride"] = 157.49, ["Neon"] = 41.9, ["Neon|Ride"] = 125.63, ["Neon|Fly|Ride"] = 232.08, ["Mega"] = 238.26, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 324.9, ["Mega|Fly|Ride"] = 412.56}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 446.25, ["Fly"] = 525, ["Ride"] = 446.25, ["Fly|Ride"] = 511.87, ["Neon|Ride"] = 3713, ["Neon|Fly|Ride"] = 1641.6, ["Mega|Fly|Ride"] = 7376.25}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 102.38, ["Fly"] = 150.6, ["Ride"] = 118.12, ["Fly|Ride"] = 187.18, ["Neon"] = 459.38, ["Neon|Ride"] = 757.05, ["Neon|Fly|Ride"] = 420, ["Mega|Fly|Ride"] = 2452.65}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3281.25, ["Ride"] = 3596.25, ["Fly|Ride"] = 3674.99}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 47.8, ["Fly"] = 112.1, ["Ride"] = 45.94, ["Fly|Ride"] = 128.43, ["Neon|Ride"] = 321.56, ["Neon|Fly|Ride"] = 536.33, ["Mega"] = 1328.44, ["Mega|Ride"] = 1760.59, ["Mega|Fly|Ride"] = 1330.5}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 82.53, ["Ride"] = 101.07, ["Fly|Ride"] = 141.1, ["Neon"] = 575.75, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 710.83, ["Mega|Ride"] = 2200.99, ["Mega|Fly|Ride"] = 3354.58}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 31.6, ["Fly"] = 57.78, ["Ride"] = 46.45, ["Fly|Ride"] = 98.86, ["Neon"] = 262.5, ["Neon|Fly"] = 185.67, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 222.5, ["Mega"] = 2625, ["Mega|Ride"] = 770.45, ["Mega|Fly|Ride"] = 656.04}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 9.17}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 78.75, ["Ride"] = 89.25, ["Fly|Ride"] = 65.63, ["Neon|Ride"] = 525, ["Mega|Fly|Ride"] = 1865.18}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 38.06}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 223.13, ["Ride"] = 236.25, ["Fly|Ride"] = 301.88, ["Neon|Ride"] = 1088.91, ["Neon|Fly|Ride"] = 1375.88}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 984.38, ["Ride"] = 943.69, ["Fly|Ride"] = 951.57, ["Neon"] = 2887.5, ["Neon|Ride"] = 3026.1, ["Neon|Fly|Ride"] = 3141.39, ["Mega|Fly|Ride"] = 11358.25}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 5.25}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 23.87, ["Fly"] = 39.35, ["Ride"] = 43.32, ["Fly|Ride"] = 64.32, ["Neon"] = 164.07, ["Neon|Ride"] = 166.69, ["Neon|Fly|Ride"] = 196.88, ["Mega|Fly|Ride"] = 904.38}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 17.99}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5250, ["Fly"] = 6326.53, ["Ride"] = 6497.74, ["Fly|Ride"] = 5053.01, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 40723.64}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 11.8, ["Fly"] = 74.72, ["Ride"] = 25.09, ["Fly|Ride"] = 52.24, ["Neon"] = 102.08, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 219.18, ["Mega"] = 693, ["Mega|Ride"] = 550.77, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 12.99, ["Fly"] = 139.89, ["Ride"] = 36.66, ["Fly|Ride"] = 311.34, ["Neon"] = 72.1, ["Neon|Ride"] = 122.07, ["Neon|Fly|Ride"] = 192.5, ["Mega"] = 727.13, ["Mega|Ride"] = 667.32, ["Mega|Fly|Ride"] = 1028.3}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 90.97, ["Ride"] = 112.11, ["Fly|Ride"] = 131.25, ["Neon|Ride"] = 382.66, ["Neon|Fly|Ride"] = 476.14, ["Mega"] = 4125.55}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 9.76, ["Ride"] = 29.93, ["Fly|Ride"] = 125.99, ["Neon"] = 110.37, ["Neon|Ride"] = 133.08, ["Neon|Fly|Ride"] = 501.38, ["Mega|Ride"] = 344.5, ["Mega|Fly|Ride"] = 813.75}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1706.22, ["Fly"] = 3026.1, ["Ride"] = 1706.25, ["Fly|Ride"] = 1764, ["Neon|Ride"] = 4290.57, ["Neon|Fly|Ride"] = 3542.34, ["Mega|Fly|Ride"] = 12468.75}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 26248.69, ["Fly"] = 33004.3, ["Ride"] = 52500, ["Fly|Ride"] = 28874.9, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 71194.67, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 183750}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 16.8, ["Fly"] = 393.74, ["Ride"] = 52.5, ["Fly|Ride"] = 927.23, ["Neon"] = 275.39, ["Neon|Ride"] = 275.39, ["Neon|Fly|Ride"] = 412.56, ["Mega"] = 1085.03, ["Mega|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 821}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 3.42, ["Ride"] = 31.68, ["Fly|Ride"] = 131.25, ["Neon"] = 19.68, ["Neon|Fly"] = 210, ["Neon|Ride"] = 55.6, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 129.92, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 357.9}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 15.74}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 6.57, ["Ride"] = 28.88, ["Fly|Ride"] = 124.68, ["Neon"] = 76.23, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 499, ["Mega"] = 294.7, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 626.07}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 923.11, ["Ride"] = 787.5, ["Fly|Ride"] = 892.5, ["Neon|Fly|Ride"] = 2402.71, ["Mega|Fly|Ride"] = 8801.84}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 905.61, ["Fly"] = 918.75, ["Ride"] = 947.81, ["Fly|Ride"] = 983.07, ["Neon|Ride"] = 3184.78, ["Neon|Fly|Ride"] = 3109.21, ["Mega|Fly|Ride"] = 10551.19}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 17.51, ["Fly"] = 116.62, ["Ride"] = 35.26, ["Fly|Ride"] = 65.61, ["Neon"] = 72.19, ["Neon|Ride"] = 126, ["Neon|Fly|Ride"] = 274.37, ["Mega"] = 1204.13, ["Mega|Ride"] = 934.48, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 22.32}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 45.66, ["Fly"] = 111.29, ["Ride"] = 77.34, ["Fly|Ride"] = 123.4, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 455.44, ["Mega|Ride"] = 2019.47, ["Mega|Fly|Ride"] = 1664.25}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 97.8, ["Ride"] = 117.59, ["Fly|Ride"] = 209.9, ["Neon"] = 357.9, ["Neon|Ride"] = 314.52, ["Neon|Fly|Ride"] = 550.77, ["Mega"] = 1342.24, ["Mega|Ride"] = 1926.64, ["Mega|Fly|Ride"] = 1861.13}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 3.68, ["Fly"] = 32.82, ["Ride"] = 19.59, ["Fly|Ride"] = 38.66, ["Neon"] = 41.58, ["Neon|Fly"] = 524.98, ["Neon|Ride"] = 55.71, ["Neon|Fly|Ride"] = 218.03, ["Mega"] = 344.5, ["Mega|Fly|Ride"] = 687.94}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 140.32, ["Fly"] = 173.15, ["Ride"] = 144.25, ["Fly|Ride"] = 219.07, ["Neon"] = 698.45, ["Neon|Ride"] = 518.43, ["Neon|Fly|Ride"] = 519.65, ["Mega|Fly|Ride"] = 1921.5}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 6.57, ["Ride"] = 35.22, ["Fly|Ride"] = 138.22, ["Neon"] = 42.51, ["Neon|Ride"] = 127.91, ["Neon|Fly|Ride"] = 825.12, ["Mega"] = 248.07, ["Mega|Ride"] = 474.62}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 14.8, ["Fly"] = 41.43, ["Ride"] = 31.34, ["Fly|Ride"] = 76.34, ["Neon"] = 90.72, ["Neon|Ride"] = 110.32, ["Neon|Fly|Ride"] = 305.3, ["Mega|Fly|Ride"] = 1018.5}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 20.58, ["Ride"] = 55.74, ["Fly|Ride"] = 156.19, ["Neon"] = 245.46, ["Neon|Ride"] = 275.39, ["Mega"] = 1398.89, ["Mega|Ride"] = 1161.57, ["Mega|Fly|Ride"] = 1114.31}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 15.87, ["Fly"] = 178.76, ["Ride"] = 26.25, ["Fly|Ride"] = 70.87, ["Neon"] = 91.87, ["Neon|Ride"] = 114.59, ["Neon|Fly|Ride"] = 205.26, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6739.08, ["Ride"] = 6555.94, ["Fly|Ride"] = 5496.74, ["Neon"] = 34380.15, ["Neon|Ride"] = 23625, ["Neon|Fly|Ride"] = 24546.95, ["Mega|Fly|Ride"] = 93258.42}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 224.42, ["Fly"] = 271.57, ["Ride"] = 244.13, ["Fly|Ride"] = 287.44, ["Neon|Fly|Ride"] = 564.38, ["Mega|Fly|Ride"] = 2067.19}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 45.93, ["Fly"] = 139.13, ["Ride"] = 89.67, ["Fly|Ride"] = 186.38, ["Neon"] = 144.38, ["Neon|Fly"] = 241.4, ["Neon|Ride"] = 178.99, ["Neon|Fly|Ride"] = 276.47, ["Mega"] = 455.28, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.63, ["Fly"] = 86.29, ["Ride"] = 34.21, ["Fly|Ride"] = 52.5, ["Neon"] = 23.73, ["Neon|Fly"] = 59.84, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 187.72, ["Mega"] = 341.25, ["Mega|Ride"] = 187.69, ["Mega|Fly|Ride"] = 348.56}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 51.18, ["Fly"] = 5285.44, ["Ride"] = 94.4, ["Fly|Ride"] = 249.54, ["Neon"] = 216.18, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 266.35, ["Neon|Fly|Ride"] = 360.29, ["Mega"] = 564.38, ["Mega|Ride"] = 580.46, ["Mega|Fly|Ride"] = 607.52}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 16485, ["Ride"] = 13387.5, ["Fly|Ride"] = 11878.13, ["Neon|Fly|Ride"] = 22837.5}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 183.75, ["Ride"] = 301.58, ["Fly|Ride"] = 459.38, ["Neon"] = 1520.47, ["Neon|Ride"] = 1375.88, ["Neon|Fly|Ride"] = 2062.78, ["Mega|Fly|Ride"] = 5906.75}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 70.21, ["Fly"] = 78.77, ["Ride"] = 57.18, ["Fly|Ride"] = 118.13, ["Neon"] = 391.94, ["Neon|Ride"] = 281.31, ["Neon|Fly|Ride"] = 411.54, ["Mega|Fly|Ride"] = 3439.68}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 10.6, ["Fly"] = 44.33, ["Ride"] = 27.87, ["Fly|Ride"] = 72.12, ["Neon"] = 69.12, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 468.26, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 379.1, ["Ride"] = 393.74, ["Fly|Ride"] = 493.77, ["Neon"] = 1650.23, ["Neon|Ride"] = 1582.17, ["Neon|Fly|Ride"] = 1575, ["Mega|Fly|Ride"] = 4331.25}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 6.39, ["Fly"] = 48.57, ["Ride"] = 37.7, ["Fly|Ride"] = 104.9, ["Neon"] = 26.25, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 179.48, ["Mega"] = 137.81, ["Mega|Fly"] = 278.37, ["Mega|Ride"] = 214.36, ["Mega|Fly|Ride"] = 343.88}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 107.41, ["Fly"] = 134.87, ["Ride"] = 144.38, ["Fly|Ride"] = 242.54, ["Neon"] = 547.68, ["Neon|Ride"] = 524.9, ["Neon|Fly|Ride"] = 557.82, ["Mega|Fly|Ride"] = 2179.16}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 12.53, ["Fly"] = 18.15, ["Ride"] = 19.42, ["Fly|Ride"] = 28.69, ["Neon|Ride"] = 96.96, ["Neon|Fly|Ride"] = 90.02, ["Mega"] = 2475.34}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 9.18}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 62.91, ["Ride"] = 81.5, ["Fly|Ride"] = 412.56, ["Neon"] = 421.32, ["Neon|Fly"] = 1650.23, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 3094.17, ["Mega|Ride"] = 1237.67, ["Mega|Fly|Ride"] = 1784.89}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 17.07, ["Fly"] = 138.22, ["Ride"] = 34.99, ["Fly|Ride"] = 93.19, ["Neon"] = 78.75, ["Neon|Ride"] = 152.66, ["Neon|Fly|Ride"] = 240.09, ["Mega|Fly|Ride"] = 825.12}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 28.88}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 55.13, ["Fly"] = 210, ["Ride"] = 91.88, ["Fly|Ride"] = 249.38, ["Neon"] = 218.06, ["Neon|Ride"] = 334.61, ["Neon|Fly|Ride"] = 514.67, ["Mega"] = 1547.1, ["Mega|Ride"] = 2092.13, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 4.8, ["Ride"] = 29.24, ["Neon"] = 23.63, ["Neon|Ride"] = 101.43, ["Neon|Fly|Ride"] = 275.39, ["Mega"] = 124.69, ["Mega|Ride"] = 264.64, ["Mega|Fly|Ride"] = 358.98}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 10.5, ["Fly"] = 52.5, ["Ride"] = 27.57, ["Fly|Ride"] = 78.14, ["Neon|Ride"] = 152.66, ["Neon|Fly|Ride"] = 206.29, ["Mega|Ride"] = 627.1, ["Mega|Fly|Ride"] = 590.28}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 438.38, ["Ride"] = 495.24, ["Fly|Ride"] = 472.5, ["Neon|Fly|Ride"] = 2750.72, ["Mega|Fly|Ride"] = 12434.86}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 32.62, ["Ride"] = 55.71, ["Fly|Ride"] = 304.27, ["Neon"] = 235.1, ["Neon|Ride"] = 262.5, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 1375.88}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 60.8, ["Fly"] = 119.89, ["Ride"] = 70.87, ["Fly|Ride"] = 152.66, ["Neon"] = 275.39, ["Neon|Ride"] = 165.04, ["Neon|Fly|Ride"] = 458.1, ["Mega|Fly|Ride"] = 911.76}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 21, ["Fly"] = 78.14, ["Ride"] = 56.44, ["Fly|Ride"] = 123.92, ["Neon"] = 92.75, ["Neon|Ride"] = 177.64, ["Neon|Fly|Ride"] = 418.69, ["Mega"] = 411.75, ["Mega|Ride"] = 411.54, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Ride"] = 13370.4, ["Fly|Ride"] = 8137.5, ["Neon|Fly|Ride"] = 16931.25, ["Mega|Fly|Ride"] = 38850}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1397.81, ["Ride"] = 1509.38, ["Fly|Ride"] = 1509.38, ["Neon|Fly|Ride"] = 4987.5, ["Mega|Fly|Ride"] = 14437.5}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 522.93, ["Ride"] = 560.39, ["Fly|Ride"] = 614.73, ["Neon"] = 2552.44, ["Neon|Fly|Ride"] = 2062.55, ["Mega|Fly|Ride"] = 6862.85}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 10.5, ["Fly"] = 20.7, ["Ride"] = 20.9, ["Fly|Ride"] = 40.5, ["Neon"] = 101.07, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 154.72, ["Mega|Fly|Ride"] = 550.77}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 3.94, ["Fly"] = 78.74, ["Ride"] = 28.28, ["Neon"] = 24.76, ["Neon|Ride"] = 55.13, ["Mega"] = 146.89, ["Mega|Ride"] = 172.55, ["Mega|Fly|Ride"] = 257.27}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 41.27, ["Fly"] = 63.09, ["Ride"] = 59.14, ["Fly|Ride"] = 97.13, ["Neon"] = 268.17, ["Neon|Ride"] = 169.31, ["Neon|Fly|Ride"] = 189.95, ["Mega|Fly|Ride"] = 582.65}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.6, ["Fly"] = 35.09, ["Ride"] = 17.07, ["Fly|Ride"] = 33.55, ["Neon"] = 31.48, ["Neon|Fly"] = 76.92, ["Neon|Ride"] = 43.64, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 261.19, ["Mega|Ride"] = 264.64}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 301.67, ["Fly"] = 369.49, ["Ride"] = 332.07, ["Fly|Ride"] = 402.94, ["Neon|Fly|Ride"] = 1513.05}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 22.52, ["Fly"] = 58.32, ["Ride"] = 31.4, ["Fly|Ride"] = 101.09, ["Neon"] = 188.75, ["Neon|Fly"] = 138.22, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 234.14, ["Mega|Ride"] = 787.4, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 10.89, ["Fly"] = 27.87, ["Ride"] = 19.69, ["Fly|Ride"] = 43.34, ["Neon"] = 137.94, ["Neon|Fly"] = 132.95, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 1575, ["Mega|Ride"] = 742.61, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 639.48, ["Fly"] = 787.5, ["Ride"] = 514.67, ["Fly|Ride"] = 537.71, ["Neon|Fly|Ride"] = 2062.78, ["Mega|Fly|Ride"] = 8939.02}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1228.62, ["Ride"] = 1260, ["Fly|Ride"] = 1344, ["Neon"] = 4813.48, ["Neon|Ride"] = 4125.55, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 13782.3}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 123.24, ["Fly"] = 134.09, ["Ride"] = 134.1, ["Fly|Ride"] = 129.84, ["Neon"] = 971.25, ["Neon|Ride"] = 585.46, ["Neon|Fly|Ride"] = 590.63, ["Mega|Fly|Ride"] = 3109.02}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 171.84, ["Fly"] = 157.49, ["Ride"] = 171.2, ["Fly|Ride"] = 231.07, ["Neon"] = 836.47, ["Neon|Fly"] = 687.94, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 623.89, ["Mega|Ride"] = 3026.1, ["Mega|Fly|Ride"] = 2792.56}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 26.25, ["Ride"] = 55.13, ["Fly|Ride"] = 118.95, ["Neon"] = 385.75, ["Neon|Ride"] = 272.98, ["Mega|Ride"] = 866.38, ["Mega|Fly|Ride"] = 908.66}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 157.5, ["Ride"] = 412.56, ["Fly|Ride"] = 550.77, ["Neon|Fly|Ride"] = 1305.76, ["Mega|Fly|Ride"] = 3852.23}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2242.24, ["Fly"] = 2215.4, ["Ride"] = 2483.25, ["Fly|Ride"] = 2333.51, ["Neon|Fly|Ride"] = 10313.85, ["Mega|Fly|Ride"] = 27977.54}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 53.8, ["Fly"] = 206.29, ["Ride"] = 51.83, ["Fly|Ride"] = 196.88, ["Neon"] = 511.88, ["Neon|Ride"] = 328.12, ["Neon|Fly|Ride"] = 343.87, ["Mega|Ride"] = 1100.5, ["Mega|Fly|Ride"] = 1398.89}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 656.25, ["Ride"] = 682.5, ["Fly|Ride"] = 714, ["Neon|Fly|Ride"] = 1319.01, ["Mega|Fly|Ride"] = 3451.86}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 39.26, ["Fly"] = 67.65, ["Ride"] = 45.94, ["Fly|Ride"] = 96.96, ["Neon|Ride"] = 266.09, ["Neon|Fly|Ride"] = 278.65, ["Mega|Fly|Ride"] = 1100.5}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.11, ["Fly"] = 39.38, ["Ride"] = 22.99, ["Fly|Ride"] = 52.5, ["Neon"] = 22.32, ["Neon|Fly"] = 139.02, ["Neon|Ride"] = 41.27, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 144.35, ["Mega|Fly"] = 249.26, ["Mega|Ride"] = 182.1, ["Mega|Fly|Ride"] = 303.87}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 50.47, ["Ride"] = 128.34, ["Fly|Ride"] = 253.32, ["Neon"] = 311.34, ["Neon|Ride"] = 309.23, ["Neon|Fly|Ride"] = 687.94, ["Mega"] = 1507.9, ["Mega|Fly|Ride"] = 1429.16}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 826.87, ["Fly"] = 984.38, ["Ride"] = 826.88, ["Fly|Ride"] = 899.42, ["Neon|Ride"] = 2598.75, ["Neon|Fly|Ride"] = 2572.92, ["Mega|Fly|Ride"] = 9563.02}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 714.65, ["Ride"] = 1070.6, ["Fly|Ride"] = 957.13, ["Mega|Fly|Ride"] = 14988.08}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 13.64, ["Fly"] = 26.25, ["Ride"] = 24.04, ["Fly|Ride"] = 38, ["Neon"] = 78.75, ["Neon|Ride"] = 110.37, ["Neon|Fly|Ride"] = 167.22, ["Mega|Ride"] = 687.94, ["Mega|Fly|Ride"] = 687.94}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 8.53, ["Ride"] = 26.25, ["Fly|Ride"] = 69.12, ["Neon"] = 125.69, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 518.44, ["Mega|Ride"] = 412.56, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 4.69, ["Ride"] = 24.94, ["Fly|Ride"] = 102.38, ["Neon"] = 19.69, ["Neon|Fly"] = 310.85, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 170.57, ["Mega"] = 155.74, ["Mega|Fly"] = 529.26, ["Mega|Ride"] = 273.95, ["Mega|Fly|Ride"] = 334.69}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 42, ["Ride"] = 48.56, ["Fly|Ride"] = 101.37, ["Neon"] = 249.38, ["Neon|Ride"] = 216.56, ["Neon|Fly|Ride"] = 273, ["Mega|Fly|Ride"] = 932.59}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 49.77, ["Ride"] = 135.19, ["Fly|Ride"] = 622.65, ["Neon"] = 424.07, ["Neon|Ride"] = 550.77, ["Neon|Fly|Ride"] = 963.33, ["Mega|Ride"] = 1547.1, ["Mega|Fly|Ride"] = 1513.05}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 14.44, ["Fly"] = 43.31, ["Ride"] = 35.44, ["Fly|Ride"] = 88.22, ["Neon"] = 105, ["Neon|Ride"] = 118.02, ["Neon|Fly|Ride"] = 156.19, ["Mega"] = 617.43, ["Mega|Ride"] = 352.96, ["Mega|Fly|Ride"] = 502.69}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 37.88, ["Ride"] = 45.73, ["Fly|Ride"] = 86.92, ["Neon"] = 323.88, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 196.76, ["Mega"] = 2100, ["Mega|Ride"] = 963.33, ["Mega|Fly|Ride"] = 839.98}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 2.63, ["Fly"] = 27.87, ["Ride"] = 15.82, ["Fly|Ride"] = 55.13, ["Neon"] = 26.25, ["Neon|Ride"] = 45.93, ["Neon|Fly|Ride"] = 91.75, ["Mega"] = 721.98, ["Mega|Ride"] = 363.07, ["Mega|Fly|Ride"] = 549.68}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 6.57, ["Fly"] = 44.08, ["Ride"] = 35.09, ["Fly|Ride"] = 31629.46, ["Neon"] = 31.71, ["Neon|Fly"] = 115.54, ["Neon|Ride"] = 81.89, ["Neon|Fly|Ride"] = 162.98, ["Mega"] = 288.81, ["Mega|Ride"] = 306.48}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 48.65, ["Fly"] = 65.63, ["Ride"] = 52.31, ["Fly|Ride"] = 93.19, ["Neon"] = 404.62, ["Neon|Ride"] = 206.29, ["Neon|Fly|Ride"] = 164.07, ["Mega|Fly|Ride"] = 1074.06}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1575, ["Fly"] = 1903.13, ["Ride"] = 1509.38, ["Fly|Ride"] = 1578.94, ["Neon|Fly|Ride"] = 3858.74, ["Mega|Fly|Ride"] = 12742.37}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 446.25, ["Fly"] = 479.75, ["Ride"] = 459.38, ["Fly|Ride"] = 553.77, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 9626.95}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 284.82, ["Ride"] = 364.88, ["Fly|Ride"] = 472.5, ["Neon"] = 918.75, ["Neon|Fly|Ride"] = 1720.36, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 44.58}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 26.17, ["Ride"] = 41.19, ["Fly|Ride"] = 98.43, ["Neon|Ride"] = 356.04, ["Neon|Fly|Ride"] = 412.56, ["Mega|Ride"] = 1499.66, ["Mega|Fly|Ride"] = 1038.19}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 34380.15, ["Ride"] = 34979.88, ["Fly|Ride"] = 15330, ["Neon|Fly|Ride"] = 38062.5, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 283.5, ["Fly"] = 611.63, ["Ride"] = 287.31, ["Fly|Ride"] = 382.04, ["Neon"] = 1373.81, ["Neon|Fly"] = 1244.13, ["Neon|Ride"] = 1078.84, ["Neon|Fly|Ride"] = 1036.88, ["Mega"] = 4674.24, ["Mega|Ride"] = 4124.52, ["Mega|Fly|Ride"] = 3871.88}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 275.39, ["Fly"] = 525, ["Ride"] = 138.22, ["Fly|Ride"] = 203.44}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 196.88, ["Fly"] = 275.39, ["Ride"] = 172.58, ["Fly|Ride"] = 216.57, ["Neon|Ride"] = 757.05, ["Neon|Fly|Ride"] = 637.88, ["Mega|Fly|Ride"] = 3018.75}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 11.82, ["Fly"] = 94.5, ["Ride"] = 28.88, ["Fly|Ride"] = 110.37, ["Neon|Ride"] = 136.16, ["Neon|Fly|Ride"] = 961.27, ["Mega"] = 697.12, ["Mega|Ride"] = 550.77, ["Mega|Fly|Ride"] = 683.83}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 5291.27, ["Ride"] = 5151.78, ["Fly|Ride"] = 5187.95, ["Neon"] = 26815.99, ["Neon|Fly|Ride"] = 27228.54}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 27.57, ["Fly"] = 138.22, ["Ride"] = 31.5, ["Fly|Ride"] = 68.09, ["Neon"] = 206.29, ["Neon|Ride"] = 343.88, ["Neon|Fly|Ride"] = 202.86, ["Mega|Fly|Ride"] = 750.86}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 35.44, ["Ride"] = 57.78, ["Fly|Ride"] = 95.82, ["Neon"] = 400.19, ["Neon|Ride"] = 488.9, ["Neon|Fly|Ride"] = 359.63, ["Mega|Fly|Ride"] = 1372.86}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 680.76, ["Fly"] = 920.07, ["Ride"] = 715.3, ["Fly|Ride"] = 938.44, ["Neon"] = 2268.95, ["Neon|Ride"] = 1968.75, ["Neon|Fly|Ride"] = 1942.5, ["Mega|Ride"] = 6876.26, ["Mega|Fly|Ride"] = 7153.13}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 14.8, ["Fly"] = 31.43, ["Ride"] = 24.65, ["Fly|Ride"] = 40.68, ["Neon"] = 115.49, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 181.99, ["Mega|Fly|Ride"] = 640.5}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 12.49, ["Fly"] = 275.39, ["Ride"] = 34.54, ["Fly|Ride"] = 78.14, ["Neon"] = 107.28, ["Neon|Ride"] = 116.61, ["Neon|Fly|Ride"] = 129.94, ["Mega|Fly|Ride"] = 550.77}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 97.13, ["Ride"] = 128.63, ["Fly|Ride"] = 262.5, ["Neon"] = 1010.63, ["Neon|Ride"] = 530.25, ["Neon|Fly|Ride"] = 605.43, ["Mega|Fly|Ride"] = 2737.3}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 22.18, ["Fly"] = 138.22, ["Ride"] = 68.15, ["Fly|Ride"] = 131.15, ["Neon"] = 78.75, ["Neon|Ride"] = 96.96, ["Neon|Fly|Ride"] = 236.15, ["Mega"] = 313.69, ["Mega|Fly"] = 715.79, ["Mega|Ride"] = 276.29, ["Mega|Fly|Ride"] = 409.47}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 4277.59, ["Ride"] = 4068.75, ["Fly|Ride"] = 4160.61, ["Neon|Ride"] = 11812.5, ["Neon|Fly|Ride"] = 10995.54, ["Mega"] = 61883.04, ["Mega|Fly|Ride"] = 35438.22}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 31.5, ["Ride"] = 65.33, ["Fly|Ride"] = 191.24, ["Neon"] = 550.77, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 412.56, ["Mega|Ride"] = 1023.15, ["Mega|Fly|Ride"] = 721.87}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 7271.25, ["Fly"] = 7564.18, ["Ride"] = 6857.82, ["Fly|Ride"] = 7027.9, ["Neon|Ride"] = 18977.47, ["Neon|Fly|Ride"] = 17587.5, ["Mega|Fly|Ride"] = 63726.98}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.61, ["Fly"] = 20.5, ["Ride"] = 20.65, ["Fly|Ride"] = 29.3, ["Neon"] = 18.38, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 87.94, ["Mega"] = 451.16, ["Mega|Fly|Ride"] = 341.4}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 15.21, ["Fly"] = 28.71, ["Ride"] = 25.13, ["Fly|Ride"] = 53.6, ["Neon"] = 138.22, ["Neon|Fly"] = 227.95, ["Neon|Ride"] = 549.68, ["Neon|Fly|Ride"] = 161.44, ["Mega|Ride"] = 985.04, ["Mega|Fly|Ride"] = 935.82}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.68}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 10.5, ["Ride"] = 32.71, ["Fly|Ride"] = 116.03, ["Neon"] = 103.16, ["Neon|Ride"] = 139.25, ["Mega"] = 777.55, ["Mega|Ride"] = 865.35, ["Mega|Fly|Ride"] = 1231.8}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 26.25, ["Fly"] = 190.37, ["Ride"] = 41.19, ["Fly|Ride"] = 99.75, ["Neon"] = 208.36, ["Neon|Ride"] = 192.88, ["Neon|Fly|Ride"] = 317.05, ["Mega"] = 945, ["Mega|Fly|Ride"] = 1099.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 11.33, ["Fly"] = 26.25, ["Ride"] = 20.65, ["Fly|Ride"] = 35.07, ["Neon|Fly"] = 110.37, ["Neon|Ride"] = 114.51, ["Neon|Fly|Ride"] = 179.55, ["Mega"] = 2475.34, ["Mega|Ride"] = 581.72, ["Mega|Fly|Ride"] = 522.93}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8354.21}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2624.98}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 21}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 232.32, ["Ride"] = 247.51, ["Fly|Ride"] = 223.12, ["Mega|Fly|Ride"] = 5129.22}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 18.66, ["Fly"] = 129.97, ["Ride"] = 48.49, ["Fly|Ride"] = 139.13, ["Neon"] = 180.51, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 265.13, ["Mega|Ride"] = 514.11, ["Mega|Fly|Ride"] = 961.27}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 12.48}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 5.16, ["Ride"] = 29.93, ["Fly|Ride"] = 82.53, ["Neon"] = 105, ["Neon|Ride"] = 96.96, ["Mega|Fly|Ride"] = 825.12}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 3051.63}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 181.58, ["Fly"] = 412.56, ["Ride"] = 262.49, ["Fly|Ride"] = 328.13, ["Neon"] = 757.05, ["Neon|Ride"] = 774.38, ["Neon|Fly|Ride"] = 825.12, ["Mega|Ride"] = 3163.28, ["Mega|Fly|Ride"] = 3439.68}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 82.69, ["Ride"] = 156.26, ["Fly|Ride"] = 206.29, ["Neon"] = 550.77, ["Neon|Ride"] = 502.51, ["Neon|Fly|Ride"] = 601.58, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 206.29, ["Fly"] = 192.88, ["Ride"] = 186.57, ["Fly|Ride"] = 262.5, ["Neon"] = 897.75, ["Neon|Ride"] = 1056.27, ["Neon|Fly|Ride"] = 777.63, ["Mega|Fly|Ride"] = 4524.7}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1824.38, ["Fly"] = 3163.28, ["Ride"] = 2212.53, ["Fly|Ride"] = 2163.83, ["Neon"] = 8161.98, ["Neon|Fly|Ride"] = 6431.25, ["Mega|Fly|Ride"] = 17718.75}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 15.75, ["Fly"] = 96.96, ["Ride"] = 57.75, ["Fly|Ride"] = 99.74, ["Neon"] = 127.32, ["Neon|Ride"] = 202.86, ["Neon|Fly|Ride"] = 192.88, ["Mega"] = 927.23, ["Mega|Ride"] = 1010.7, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 686.44, ["Fly"] = 2100, ["Ride"] = 727.65, ["Fly|Ride"] = 948.89, ["Neon|Fly|Ride"] = 4041.99, ["Mega|Fly|Ride"] = 18651.69}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 41.56}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 14.43, ["Ride"] = 42, ["Fly|Ride"] = 647.98, ["Neon"] = 81.38, ["Neon|Ride"] = 138.22, ["Neon|Fly|Ride"] = 311.29, ["Mega"] = 1512.03, ["Mega|Ride"] = 514.56, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 9.09, ["Fly"] = 262.5, ["Ride"] = 27.57, ["Fly|Ride"] = 96.77, ["Neon"] = 39.19, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 210, ["Mega"] = 918.75, ["Mega|Ride"] = 357.9, ["Mega|Fly|Ride"] = 371.32}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 88.82}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 20.41, ["Ride"] = 23.7, ["Fly|Ride"] = 80.47, ["Neon"] = 93.3, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 481.67, ["Mega|Ride"] = 825.12, ["Mega|Fly|Ride"] = 1926.64}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["Ride"] = 45.94, ["Fly|Ride"] = 48.57, ["Neon|Ride"] = 412.56, ["Neon|Fly|Ride"] = 327.99, ["Mega"] = 963.33, ["Mega|Ride"] = 1748.61, ["Mega|Fly|Ride"] = 961.27}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6561.19, ["Fly"] = 11001.78, ["Ride"] = 6793.5, ["Fly|Ride"] = 5223.75, ["Neon|Fly|Ride"] = 12211.6, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 10.5, ["Fly"] = 65.63, ["Ride"] = 33.27, ["Fly|Ride"] = 109.61, ["Neon"] = 69.12, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 275.39, ["Mega"] = 412.56, ["Mega|Ride"] = 408.44, ["Mega|Fly|Ride"] = 695.37}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 21}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 131.25, ["Fly"] = 365.12, ["Ride"] = 135.19, ["Fly|Ride"] = 233.1, ["Neon"] = 481.67, ["Neon|Ride"] = 540.46, ["Neon|Fly|Ride"] = 687.94, ["Mega"] = 2879.59, ["Mega|Fly|Ride"] = 1926.64}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 51.51, ["Fly"] = 140.9, ["Ride"] = 67.5, ["Fly|Ride"] = 157.5, ["Neon"] = 255.93, ["Neon|Ride"] = 265.13, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 2331.48, ["Mega|Ride"] = 2784.74, ["Mega|Fly|Ride"] = 1915.31}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 23.43, ["Fly"] = 70.47, ["Ride"] = 29.54, ["Fly|Ride"] = 81.38, ["Neon|Fly"] = 234.14, ["Neon|Ride"] = 139.84, ["Neon|Fly|Ride"] = 190.3, ["Mega"] = 1016.21, ["Mega|Ride"] = 855.66, ["Mega|Fly|Ride"] = 735}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 9.18, ["Fly"] = 65.54, ["Ride"] = 22.32, ["Fly|Ride"] = 82.53, ["Neon"] = 36.17, ["Neon|Ride"] = 45, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 179.04, ["Mega|Fly"] = 254.63, ["Mega|Fly|Ride"] = 305.17}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 10.34, ["Ride"] = 27.46, ["Fly|Ride"] = 73.5, ["Neon"] = 85.32, ["Neon|Ride"] = 122.75, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 722.77, ["Mega|Ride"] = 528.94, ["Mega|Fly|Ride"] = 584.07}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 18.8, ["Fly"] = 30.19, ["Ride"] = 27.72, ["Fly|Ride"] = 49.9, ["Neon|Ride"] = 261.99, ["Neon|Fly|Ride"] = 144.38, ["Mega|Fly|Ride"] = 699.45}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 215.67}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 24.94, ["Ride"] = 94.5, ["Neon"] = 196.88, ["Neon|Fly|Ride"] = 565.22, ["Mega"] = 1100.5, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 208.69, ["Ride"] = 443.63, ["Fly|Ride"] = 1555.45}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 47.24, ["Fly"] = 212.3, ["Ride"] = 123.78, ["Fly|Ride"] = 227.95, ["Neon"] = 346.5, ["Neon|Ride"] = 295.32, ["Neon|Fly|Ride"] = 485.63, ["Mega"] = 908.25, ["Mega|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 1237.67}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 918.73, ["Fly"] = 1334.63, ["Ride"] = 944.9, ["Fly|Ride"] = 1030.32, ["Neon|Fly"] = 4034.37, ["Neon|Ride"] = 3281.25, ["Neon|Fly|Ride"] = 3150, ["Mega|Fly|Ride"] = 12927.38}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 418.69, ["Fly"] = 525, ["Ride"] = 441, ["Fly|Ride"] = 543.56, ["Neon"] = 2887.89, ["Neon|Ride"] = 2062.78, ["Neon|Fly|Ride"] = 2223.29, ["Mega|Fly|Ride"] = 7564.18}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 71.31}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 9.19, ["Fly"] = 78.75, ["Ride"] = 18.76, ["Fly|Ride"] = 69.12, ["Neon"] = 78.73, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 157.5, ["Mega|Ride"] = 687.94, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 311.34, ["Fly"] = 392.03, ["Ride"] = 315.91, ["Fly|Ride"] = 441, ["Neon"] = 1097.41, ["Neon|Ride"] = 984.38, ["Neon|Fly|Ride"] = 917.44, ["Mega|Fly|Ride"] = 3189.05}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 15.74}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 156.26, ["Ride"] = 187.35, ["Fly|Ride"] = 303.01, ["Neon"] = 585.36, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 825.12, ["Mega"] = 2493.75, ["Mega|Ride"] = 2722.88, ["Mega|Fly|Ride"] = 2756.25}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 123.54, ["Ride"] = 104.13, ["Fly|Ride"] = 202.17, ["Neon"] = 687.94, ["Neon|Ride"] = 1005.38, ["Neon|Fly|Ride"] = 913.5, ["Mega|Ride"] = 3439.68}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 3.84, ["Ride"] = 26.17, ["Fly|Ride"] = 168.13, ["Neon"] = 30.85, ["Neon|Ride"] = 99.02, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 304.27, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 823.07}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 13.34, ["Fly"] = 63.03, ["Ride"] = 26.17, ["Fly|Ride"] = 73.25, ["Neon"] = 177.19, ["Neon|Ride"] = 164.07, ["Neon|Fly|Ride"] = 393.75, ["Mega|Ride"] = 803.46, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 15.2, ["Fly"] = 131.25, ["Ride"] = 48.49, ["Fly|Ride"] = 82.37, ["Neon"] = 105, ["Neon|Ride"] = 132.04, ["Neon|Fly|Ride"] = 256.57, ["Mega"] = 498.75, ["Mega|Ride"] = 466.31, ["Mega|Fly|Ride"] = 729.21}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 3.96, ["Fly"] = 123.78, ["Ride"] = 55.43, ["Fly|Ride"] = 155.92, ["Neon"] = 26.25, ["Neon|Fly"] = 233.21, ["Neon|Ride"] = 64.19, ["Neon|Fly|Ride"] = 172.49, ["Mega"] = 171.94, ["Mega|Ride"] = 177.07, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 269.07, ["Ride"] = 290.04, ["Fly|Ride"] = 354.38, ["Neon"] = 1623.41, ["Neon|Ride"] = 1399.04, ["Neon|Fly|Ride"] = 1299.38, ["Mega|Fly|Ride"] = 5226.03}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 152.66, ["Fly"] = 550.77, ["Ride"] = 206.29, ["Fly|Ride"] = 241.48, ["Neon"] = 1575, ["Neon|Ride"] = 731, ["Neon|Fly|Ride"] = 1173.27, ["Mega|Fly|Ride"] = 2474.31}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 70.88, ["Fly"] = 167.45, ["Ride"] = 69.33, ["Fly|Ride"] = 176.37, ["Neon"] = 393.75, ["Neon|Ride"] = 510.56, ["Neon|Fly|Ride"] = 416.07, ["Mega|Fly|Ride"] = 1801.11}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 11.38, ["Ride"] = 69.12, ["Fly|Ride"] = 275.39, ["Neon|Ride"] = 592.27, ["Neon|Fly|Ride"] = 481.67, ["Mega|Ride"] = 618.84, ["Mega|Fly|Ride"] = 1856.51}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 11.82, ["Fly"] = 75.63, ["Ride"] = 35.09, ["Fly|Ride"] = 75.9, ["Neon"] = 77.4, ["Neon|Ride"] = 123.78, ["Neon|Fly|Ride"] = 197.02, ["Mega"] = 371.44, ["Mega|Fly"] = 525, ["Mega|Ride"] = 360.94, ["Mega|Fly|Ride"] = 522.93}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.84, ["Fly"] = 52.45, ["Ride"] = 17.85, ["Fly|Ride"] = 98.44, ["Neon"] = 20.64, ["Neon|Fly"] = 64.92, ["Neon|Ride"] = 35.17, ["Neon|Fly|Ride"] = 118.09, ["Mega"] = 136.5, ["Mega|Ride"] = 137.82, ["Mega|Fly|Ride"] = 253.61}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 853.02, ["Fly"] = 1082.72, ["Ride"] = 868.88, ["Fly|Ride"] = 948.94, ["Neon|Fly"] = 3421.05, ["Neon|Ride"] = 3145.74, ["Neon|Fly|Ride"] = 2623.69, ["Mega|Fly|Ride"] = 10136.45}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 341.25, ["Ride"] = 393.75, ["Fly|Ride"] = 472.02, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1621.35, ["Mega"] = 10313.85, ["Mega|Fly|Ride"] = 5775.76}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 82.53, ["Fly"] = 138.22, ["Ride"] = 82.53, ["Fly|Ride"] = 206.29, ["Neon"] = 283.07, ["Neon|Ride"] = 304.27, ["Neon|Fly|Ride"] = 344.5, ["Mega|Fly|Ride"] = 3988.38}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 309.43, ["Fly"] = 522.93, ["Ride"] = 248.47, ["Fly|Ride"] = 350.69, ["Neon|Fly|Ride"] = 1237.67, ["Mega|Fly|Ride"] = 5501.42}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 16.49, ["Fly"] = 52.5, ["Ride"] = 26.23, ["Fly|Ride"] = 65.63, ["Neon"] = 157.5, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 236.25, ["Mega|Fly|Ride"] = 777.55}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 253.32, ["Ride"] = 300.15, ["Fly|Ride"] = 472.5, ["Neon"] = 825.12, ["Neon|Ride"] = 825.12, ["Neon|Fly|Ride"] = 708.75, ["Mega"] = 4105.21, ["Mega|Ride"] = 4538.1, ["Mega|Fly|Ride"] = 3818.31}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 41.91, ["Fly"] = 125.98, ["Ride"] = 79.41, ["Fly|Ride"] = 94.5, ["Neon|Ride"] = 587.61, ["Neon|Fly|Ride"] = 550.77, ["Mega|Fly|Ride"] = 1732.5}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1870.32, ["Ride"] = 1837.49, ["Fly|Ride"] = 2015.68, ["Neon|Ride"] = 10882.02, ["Neon|Fly|Ride"] = 11001.78, ["Mega"] = 49506.43, ["Mega|Fly|Ride"] = 22235.61}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 13.13, ["Fly"] = 85.93, ["Ride"] = 40.24, ["Fly|Ride"] = 93.83, ["Neon"] = 51.9, ["Neon|Fly"] = 187.72, ["Neon|Ride"] = 76.34, ["Neon|Fly|Ride"] = 137.94, ["Mega"] = 343.42, ["Mega|Ride"] = 347.7, ["Mega|Fly|Ride"] = 446.24}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 53.26, ["Ride"] = 84.59, ["Fly|Ride"] = 126, ["Neon"] = 160.13, ["Neon|Ride"] = 344.5, ["Neon|Fly|Ride"] = 304.27, ["Mega"] = 1632.04, ["Mega|Fly|Ride"] = 1306.78}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 90.57, ["Fly"] = 78.7, ["Ride"] = 76.13, ["Fly|Ride"] = 97.12, ["Neon"] = 525, ["Neon|Ride"] = 481.67, ["Neon|Fly|Ride"] = 380.63, ["Mega|Fly|Ride"] = 1842.37}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 3439.68, ["Fly"] = 1555.44, ["Ride"] = 1069.68, ["Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 479.07, ["Ride"] = 679.7, ["Fly|Ride"] = 656.25, ["Neon|Fly|Ride"] = 3109.32}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 91.88, ["Fly"] = 202.9, ["Ride"] = 137.82, ["Neon"] = 408.19, ["Neon|Ride"] = 399.16, ["Neon|Fly|Ride"] = 538.13, ["Mega|Ride"] = 4125.55, ["Mega|Fly|Ride"] = 2037}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 6.35, ["Ride"] = 21.76, ["Fly|Ride"] = 138.22, ["Neon"] = 52.5, ["Neon|Ride"] = 95.82, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 762.72}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 38.17, ["Fly"] = 275.39, ["Ride"] = 49.67, ["Fly|Ride"] = 104.66, ["Neon"] = 262.5, ["Neon|Fly"] = 323.88, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 371.32, ["Mega"] = 853.13, ["Mega|Fly|Ride"] = 1049.99}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 757.32, ["Ride"] = 784.88, ["Fly|Ride"] = 860.98, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2162.42, ["Mega|Fly|Ride"] = 11002.18}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 728.04}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 4921.87, ["Ride"] = 6161.51, ["Fly|Ride"] = 5446.88, ["Neon"] = 42000, ["Neon|Ride"] = 29560.51, ["Neon|Fly|Ride"] = 22968.75, ["Mega|Fly|Ride"] = 88012.12}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 313.38, ["Fly"] = 414.77, ["Ride"] = 393.75, ["Neon"] = 1650.23, ["Neon|Ride"] = 2062.78, ["Neon|Fly|Ride"] = 2165.92, ["Mega"] = 6187.29, ["Mega|Fly|Ride"] = 6218.02}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 85.32, ["Fly"] = 275.39, ["Ride"] = 122.07, ["Fly|Ride"] = 336, ["Neon"] = 622.65, ["Neon|Ride"] = 687.94, ["Neon|Fly|Ride"] = 1646.11, ["Mega|Fly|Ride"] = 2119.51}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 10.71, ["Fly"] = 92.85, ["Ride"] = 37.69, ["Fly|Ride"] = 85.32, ["Neon"] = 113.3, ["Neon|Fly"] = 1244.13, ["Neon|Ride"] = 82.55, ["Neon|Fly|Ride"] = 241.37, ["Mega|Ride"] = 825.12, ["Mega|Fly|Ride"] = 687.94}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 7.76, ["Fly"] = 41.27, ["Ride"] = 20.18, ["Fly|Ride"] = 39.21, ["Neon"] = 206.29, ["Neon|Ride"] = 311.29, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 2186.55}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 16.26, ["Ride"] = 27.56, ["Fly|Ride"] = 140.44, ["Neon"] = 103.49, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 228.99, ["Mega"] = 670.69, ["Mega|Ride"] = 618.84, ["Mega|Fly|Ride"] = 687.94}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 4.19, ["Ride"] = 22.23, ["Fly|Ride"] = 48.57, ["Neon"] = 31.38, ["Neon|Ride"] = 55.71, ["Neon|Fly|Ride"] = 129.97, ["Mega"] = 275.39, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 311.27}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 23.63, ["Fly"] = 90.57, ["Ride"] = 34.13, ["Fly|Ride"] = 139.13, ["Neon"] = 223.13, ["Neon|Fly"] = 825.12, ["Neon|Ride"] = 249.37, ["Neon|Fly|Ride"] = 395.04, ["Mega"] = 630, ["Mega|Ride"] = 687.94}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 369.24, ["Fly"] = 538.12, ["Ride"] = 433.98, ["Fly|Ride"] = 496.86, ["Neon"] = 1567.72, ["Neon|Ride"] = 1375.88, ["Neon|Fly|Ride"] = 1286.94, ["Mega"] = 7875, ["Mega|Fly|Ride"] = 5361.16}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 4.13, ["Fly"] = 18.38, ["Ride"] = 15.06, ["Fly|Ride"] = 26.25, ["Neon"] = 19.06, ["Neon|Ride"] = 33.12, ["Neon|Fly|Ride"] = 82.53, ["Mega"] = 825.12, ["Mega|Ride"] = 311.27, ["Mega|Fly|Ride"] = 245.48}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 44.63, ["Fly"] = 78.75, ["Ride"] = 81.97, ["Fly|Ride"] = 144.38, ["Neon"] = 229.68, ["Neon|Fly"] = 389.45, ["Neon|Ride"] = 210.27, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 575.05, ["Mega|Ride"] = 577.5, ["Mega|Fly|Ride"] = 590.62}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 794.07, ["Ride"] = 824.15, ["Fly|Ride"] = 761.24, ["Neon|Ride"] = 1603.88, ["Neon|Fly|Ride"] = 1575, ["Mega|Fly|Ride"] = 3934.86}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 36.54, ["Fly"] = 165.37, ["Ride"] = 51.74, ["Fly|Ride"] = 91.88, ["Neon"] = 220.73, ["Neon|Ride"] = 220.29, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 1575, ["Mega|Fly|Ride"] = 797.24}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 341.25, ["Fly"] = 380.7, ["Ride"] = 290.76, ["Fly|Ride"] = 345.19, ["Neon|Ride"] = 1555.25, ["Neon|Fly|Ride"] = 1120.71}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 170.63, ["Fly"] = 270.23, ["Ride"] = 196.27, ["Fly|Ride"] = 209.9, ["Neon"] = 633.63, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 840.7, ["Mega|Fly|Ride"] = 3473.01}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 787.5, ["Ride"] = 754.69, ["Fly|Ride"] = 786.19, ["Neon|Fly|Ride"] = 2998.25, ["Mega|Fly|Ride"] = 7611.19}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 21.66, ["Ride"] = 44.63, ["Fly|Ride"] = 111.55, ["Neon"] = 92.55, ["Neon|Fly"] = 279.86, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 270.48, ["Mega"] = 354.38, ["Mega|Ride"] = 389.88, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 4084.48, ["Ride"] = 3936.19, ["Fly|Ride"] = 3136.88, ["Neon"] = 13752.48, ["Neon|Fly|Ride"] = 7007.24, ["Mega|Fly|Ride"] = 24555.2}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 123.78, ["Fly"] = 169.68, ["Ride"] = 144.38, ["Fly|Ride"] = 195.85, ["Neon"] = 550.97, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 593.25, ["Mega|Fly|Ride"] = 2387.44}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.63, ["Fly"] = 27.32, ["Ride"] = 19.61, ["Fly|Ride"] = 38.07, ["Neon"] = 22.32, ["Neon|Fly"] = 65.62, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 118.13, ["Mega|Fly"] = 446.25, ["Mega|Ride"] = 357.66, ["Mega|Fly|Ride"] = 244.13}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.72, ["Ride"] = 24.55, ["Fly|Ride"] = 57.7, ["Neon"] = 15.75, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 266.44, ["Mega"] = 161.49, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 356.1}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 25.72, ["Ride"] = 39.26, ["Fly|Ride"] = 56.34, ["Neon|Fly|Ride"] = 343.94, ["Mega|Fly|Ride"] = 1155.16}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 1181.25, ["Ride"] = 1306.78, ["Fly|Ride"] = 1295.44}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 6693.75, ["Fly|Ride"] = 6876.26}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 20.45, ["Fly"] = 35.6, ["Ride"] = 24.94, ["Fly|Ride"] = 47.25, ["Neon"] = 452.13, ["Neon|Ride"] = 186.56, ["Neon|Fly|Ride"] = 206.29, ["Mega"] = 2475.34, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 15.67, ["Fly"] = 41.09, ["Ride"] = 24.85, ["Fly|Ride"] = 74.42, ["Neon"] = 89.24, ["Neon|Ride"] = 109.6, ["Neon|Fly|Ride"] = 179.21, ["Mega"] = 655.54, ["Mega|Ride"] = 777.55, ["Mega|Fly|Ride"] = 524.16}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 72.18, ["Fly"] = 157.5, ["Ride"] = 91.87, ["Fly|Ride"] = 112.88, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 441.68, ["Mega|Fly|Ride"] = 1581.49}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 258.57, ["Ride"] = 261.19, ["Fly|Ride"] = 316.32, ["Neon|Ride"] = 977.79, ["Neon|Fly|Ride"] = 984.38, ["Mega|Fly|Ride"] = 5501.42}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.66, ["Ride"] = 30.33, ["Fly|Ride"] = 86.56, ["Neon"] = 23.89, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 102.13, ["Mega"] = 143.75, ["Mega|Ride"] = 191.23, ["Mega|Fly|Ride"] = 1373.81}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 183.65, ["Ride"] = 229.69, ["Fly|Ride"] = 284.59, ["Neon"] = 740.64, ["Neon|Ride"] = 886.06, ["Neon|Fly|Ride"] = 843.93, ["Mega|Fly|Ride"] = 5315.63}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 3.46, ["Fly"] = 78.14, ["Ride"] = 16.68, ["Fly|Ride"] = 50.81, ["Neon"] = 20.79, ["Neon|Fly"] = 123.78, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 210, ["Mega|Ride"] = 223.12, ["Mega|Fly|Ride"] = 327.99}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 220.89, ["Ride"] = 311.34, ["Fly|Ride"] = 274.37, ["Neon|Fly|Ride"] = 879.38, ["Mega"] = 10313.85, ["Mega|Fly|Ride"] = 4125.55}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 15.39, ["Ride"] = 27.09, ["Fly|Ride"] = 68.25, ["Neon"] = 73.5, ["Neon|Fly"] = 296.18, ["Neon|Ride"] = 152.66, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 480.64, ["Mega|Ride"] = 618.84, ["Mega|Fly|Ride"] = 449.5}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.43, ["Ride"] = 23.34, ["Fly|Ride"] = 65.54, ["Neon"] = 11.3, ["Neon|Fly"] = 170.45, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 177.08, ["Mega"] = 69.57, ["Mega|Ride"] = 115.02, ["Mega|Fly|Ride"] = 195.57}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.63, ["Neon"] = 3.84, ["Mega"] = 20.65, ["Mega|Ride"] = 148.53}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 3.7, ["Fly"] = 52.49, ["Ride"] = 39.38, ["Fly|Ride"] = 116.82, ["Neon"] = 7.44, ["Neon|Ride"] = 38.63, ["Neon|Fly|Ride"] = 131.23, ["Mega"] = 55.13, ["Mega|Fly"] = 155431.48, ["Mega|Ride"] = 98.51, ["Mega|Fly|Ride"] = 202.32}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 72.01, ["Fly"] = 135.4, ["Ride"] = 97.94, ["Fly|Ride"] = 169.99, ["Neon"] = 236.8, ["Neon|Fly"] = 391.94, ["Neon|Ride"] = 292.69, ["Neon|Fly|Ride"] = 308.21, ["Mega|Fly|Ride"] = 1172.76}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 33.84, ["Ride"] = 15.73, ["Fly|Ride"] = 109.34, ["Neon"] = 8.12, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 129.94, ["Mega|Ride"] = 165.38, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 15.72, ["Ride"] = 162.87, ["Neon"] = 87.94, ["Neon|Ride"] = 299.25, ["Mega"] = 459.38}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 51.72, ["Neon|Fly|Ride"] = 275.39, ["Mega"] = 17.07, ["Mega|Ride"] = 45.75, ["Mega|Fly|Ride"] = 322.13}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 40.86, ["Ride"] = 15.54, ["Fly|Ride"] = 35.09, ["Neon"] = 2.1, ["Neon|Fly"] = 18.38, ["Neon|Ride"] = 14.34, ["Neon|Fly|Ride"] = 55.71, ["Mega"] = 12.64, ["Mega|Fly"] = 31.38, ["Mega|Ride"] = 19.67, ["Mega|Fly|Ride"] = 64.31}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 18.15, ["Ride"] = 12.71, ["Fly|Ride"] = 33.03, ["Neon"] = 3.89, ["Neon|Fly"] = 39.16, ["Neon|Ride"] = 15.65, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 122.3, ["Mega|Ride"] = 55.71}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 105, ["Mega"] = 90.53, ["Mega|Ride"] = 91.47}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.63, ["Fly"] = 91.84, ["Ride"] = 20.94, ["Fly|Ride"] = 107.63, ["Neon"] = 6.57, ["Neon|Fly"] = 167.96, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 90.57, ["Mega"] = 23.63, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 138.22, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 3.84, ["Neon|Fly|Ride"] = 411.54, ["Mega"] = 17.67, ["Mega|Ride"] = 69.57, ["Mega|Fly|Ride"] = 206.29}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 2.1, ["Fly"] = 69.12, ["Ride"] = 26.25, ["Fly|Ride"] = 155.66, ["Neon"] = 11.46, ["Neon|Fly"] = 69.12, ["Neon|Ride"] = 44.22, ["Neon|Fly|Ride"] = 116.7, ["Mega"] = 129.93, ["Mega|Fly"] = 344.46, ["Mega|Ride"] = 110.65, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 50.94, ["Neon"] = 2.1, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 258.55, ["Mega"] = 13.64, ["Mega|Fly"] = 144.38, ["Mega|Ride"] = 50.74, ["Mega|Fly|Ride"] = 185.67}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.63, ["Fly|Ride"] = 524.99, ["Neon"] = 16.21, ["Mega"] = 188.4, ["Mega|Fly"] = 315, ["Mega|Ride"] = 712.48}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.14, ["Ride"] = 27.57, ["Neon"] = 16.7, ["Neon|Ride"] = 70.49, ["Mega"] = 103.94, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 550.77}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 24.94, ["Neon"] = 4.6, ["Neon|Ride"] = 26.83, ["Neon|Fly|Ride"] = 138.22, ["Mega"] = 19.63, ["Mega|Ride"] = 40.82, ["Mega|Fly|Ride"] = 150.35}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 11.78, ["Fly|Ride"] = 32.71, ["Neon"] = 2.1, ["Neon|Fly"] = 16.56, ["Neon|Ride"] = 13.13, ["Neon|Fly|Ride"] = 32.34, ["Mega"] = 13.9, ["Mega|Fly"] = 39.2, ["Mega|Ride"] = 19.26, ["Mega|Fly|Ride"] = 49.26}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 3.94, ["Fly"] = 72.19, ["Ride"] = 229.68, ["Fly|Ride"] = 118.11, ["Neon"] = 34.92, ["Neon|Ride"] = 140.95, ["Mega|Ride"] = 240.19}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 23.16, ["Neon"] = 3.94, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 105, ["Mega"] = 26.23, ["Mega|Ride"] = 49.9, ["Mega|Fly|Ride"] = 114.19}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 2.24, ["Neon"] = 11.44, ["Neon|Fly|Ride"] = 138.22, ["Mega"] = 103.16, ["Mega|Ride"] = 165.04, ["Mega|Fly|Ride"] = 238.87}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.63, ["Fly"] = 91.88, ["Ride"] = 45.29, ["Fly|Ride"] = 187.72, ["Neon"] = 65.51, ["Neon|Ride"] = 55.71, ["Neon|Fly|Ride"] = 105, ["Mega"] = 124.69, ["Mega|Ride"] = 143.06, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 11.34, ["Ride"] = 11.02, ["Fly|Ride"] = 18.69, ["Neon"] = 2.1, ["Neon|Fly"] = 13.52, ["Neon|Ride"] = 13.1, ["Neon|Fly|Ride"] = 30.96, ["Mega"] = 13.95, ["Mega|Fly"] = 37.14, ["Mega|Ride"] = 23.63, ["Mega|Fly|Ride"] = 51.07}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 27.87, ["Ride"] = 27.39, ["Fly|Ride"] = 131.25, ["Neon"] = 17.43, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 196.47, ["Mega"] = 105, ["Mega|Ride"] = 156.22, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 10.24, ["Fly"] = 112.03, ["Ride"] = 21.99, ["Fly|Ride"] = 59.06, ["Neon"] = 77.24, ["Neon|Ride"] = 67.48, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 236.24, ["Mega|Ride"] = 288.46, ["Mega|Fly|Ride"] = 410.17}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 32.13, ["Ride"] = 12.33, ["Fly|Ride"] = 36.66, ["Neon"] = 2.1, ["Neon|Fly"] = 23.63, ["Neon|Ride"] = 14.41, ["Neon|Fly|Ride"] = 34.13, ["Mega"] = 20.99, ["Mega|Ride"] = 35.44, ["Mega|Fly|Ride"] = 98.44}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 3.94, ["Fly"] = 172.26, ["Ride"] = 30.23, ["Neon"] = 11.67, ["Neon|Ride"] = 27.87, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 85.32, ["Mega|Fly"] = 165.04, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 35.44, ["Neon"] = 6.03, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 138.22, ["Mega"] = 35.11, ["Mega|Fly"] = 137.94, ["Mega|Ride"] = 129.97, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 32.66, ["Ride"] = 17.99, ["Neon"] = 2.1, ["Neon|Fly"] = 41.27, ["Neon|Ride"] = 34.12, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 15.49, ["Mega|Ride"] = 55.71, ["Mega|Fly|Ride"] = 165.04}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 91.88, ["Ride"] = 14.95, ["Fly|Ride"] = 42.02, ["Neon"] = 5.25, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 57.75, ["Mega"] = 65.54, ["Mega|Ride"] = 85.62}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 52.73, ["Neon"] = 3.56, ["Neon|Ride"] = 52.5, ["Mega"] = 35.01, ["Mega|Ride"] = 133.6, ["Mega|Fly|Ride"] = 307.37}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 20.65, ["Ride"] = 17.56, ["Fly|Ride"] = 72.19, ["Neon"] = 6.3, ["Neon|Ride"] = 16.99, ["Neon|Fly|Ride"] = 83.91, ["Mega"] = 76.95, ["Mega|Ride"] = 90.56, ["Mega|Fly|Ride"] = 309.32}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 13.13, ["Fly"] = 42, ["Ride"] = 36.26, ["Neon"] = 30.49, ["Neon|Fly"] = 188.89, ["Neon|Fly|Ride"] = 327.3, ["Mega"] = 98.18, ["Mega|Fly|Ride"] = 825.12}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Ride"] = 15.65, ["Fly|Ride"] = 57.48, ["Neon"] = 20.54, ["Neon|Fly"] = 55.71, ["Neon|Ride"] = 28.4, ["Neon|Fly|Ride"] = 137.45, ["Mega"] = 315, ["Mega|Fly"] = 420}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 9.19, ["Fly"] = 21.26, ["Ride"] = 16.86, ["Fly|Ride"] = 45.93, ["Neon"] = 34.13, ["Neon|Fly"] = 84, ["Neon|Ride"] = 46.55, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 192.77, ["Mega|Fly"] = 192.88, ["Mega|Ride"] = 412.56, ["Mega|Fly|Ride"] = 550.77}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 110.93, ["Fly|Ride"] = 72.19, ["Neon"] = 71.14, ["Mega"] = 215.92, ["Mega|Ride"] = 236.24}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 10.5, ["Ride"] = 56.44, ["Neon"] = 262.39, ["Neon|Ride"] = 233.19, ["Mega|Ride"] = 687.94}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 2.19, ["Ride"] = 39.38, ["Neon"] = 41.27, ["Neon|Ride"] = 123.78, ["Mega"] = 255.8, ["Mega|Ride"] = 306.48}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 9.26, ["Ride"] = 45.94, ["Fly|Ride"] = 120.75, ["Neon"] = 33.11, ["Neon|Ride"] = 82.53, ["Mega"] = 466.31, ["Mega|Ride"] = 275.39, ["Mega|Fly|Ride"] = 361.6}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.9, ["Neon|Ride"] = 64.99, ["Mega"] = 24.76, ["Mega|Fly"] = 123.78, ["Mega|Ride"] = 123.78, ["Mega|Fly|Ride"] = 123.6}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 39.38}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 3.81, ["Fly"] = 19.91, ["Ride"] = 16.7, ["Fly|Ride"] = 35.19, ["Neon"] = 39.38, ["Neon|Fly"] = 188.48, ["Neon|Ride"] = 40.84, ["Neon|Fly|Ride"] = 86.73, ["Mega"] = 374.32, ["Mega|Ride"] = 208.68, ["Mega|Fly|Ride"] = 292.73}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 3.94, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 25.09, ["Neon|Fly|Ride"] = 153.9, ["Mega"] = 52.5, ["Mega|Fly"] = 138.22, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 90.96}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 47.46, ["Neon"] = 6.14, ["Neon|Ride"] = 33.11, ["Mega"] = 43.33, ["Mega|Ride"] = 71.31, ["Mega|Fly|Ride"] = 133.88}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.63, ["Fly"] = 48.49, ["Ride"] = 16.52, ["Fly|Ride"] = 55.65, ["Neon"] = 15.43, ["Neon|Ride"] = 22.71, ["Neon|Fly|Ride"] = 116.24, ["Mega"] = 122.51, ["Mega|Ride"] = 156.22, ["Mega|Fly|Ride"] = 164.96}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 14.33, ["Ride"] = 36.66, ["Fly|Ride"] = 57.75, ["Neon"] = 42, ["Neon|Ride"] = 49.51, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 344.5, ["Mega|Ride"] = 275.45}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Ride"] = 31.82, ["Neon"] = 2.63, ["Mega"] = 20.74, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 60.38, ["Mega|Fly|Ride"] = 330.05}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 21.66, ["Ride"] = 15.22, ["Fly|Ride"] = 275036.02, ["Neon"] = 3.05, ["Neon|Fly"] = 109.1, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 65.62, ["Mega"] = 35.44, ["Mega|Fly"] = 143.15, ["Mega|Ride"] = 43.43, ["Mega|Fly|Ride"] = 156.22}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 27.87, ["Ride"] = 13.12, ["Fly|Ride"] = 32.82, ["Neon"] = 3.83, ["Neon|Fly"] = 69.12, ["Neon|Ride"] = 18.14, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 47.95, ["Mega|Fly"] = 138.22, ["Mega|Ride"] = 56.44, ["Mega|Fly|Ride"] = 104.93}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 27.87, ["Ride"] = 46.78, ["Fly|Ride"] = 118.13, ["Neon"] = 5.25, ["Neon|Ride"] = 27.29, ["Neon|Fly|Ride"] = 111.77, ["Mega"] = 29.75, ["Mega|Ride"] = 79.48, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 165.04, ["Neon|Fly|Ride"] = 150159.68, ["Mega"] = 22.32, ["Mega|Fly"] = 106.45, ["Mega|Ride"] = 123.78, ["Mega|Fly|Ride"] = 410.51}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 45.87, ["Ride"] = 20.99, ["Fly|Ride"] = 45.94, ["Neon"] = 3.84, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 83.95, ["Mega"] = 22.32, ["Mega|Fly"] = 61.89, ["Mega|Ride"] = 40.69, ["Mega|Fly|Ride"] = 116.45}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Neon"] = 2.62, ["Neon|Ride"] = 36.66, ["Mega|Ride"] = 167.35, ["Mega|Fly|Ride"] = 161.24}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.7, ["Neon|Ride"] = 311.29, ["Neon|Fly|Ride"] = 420, ["Mega"] = 23.62, ["Mega|Ride"] = 158.89, ["Mega|Fly|Ride"] = 187.99}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 18.78, ["Fly|Ride"] = 41.27, ["Neon"] = 3.94, ["Neon|Ride"] = 17.01, ["Neon|Fly|Ride"] = 136.5, ["Mega"] = 123.78, ["Mega|Ride"] = 48.05, ["Mega|Fly|Ride"] = 93.56}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 11.57, ["Ride"] = 186.58, ["Neon"] = 515.71, ["Mega"] = 494.82, ["Mega|Ride"] = 906.6}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 3.93, ["Fly"] = 6562.5, ["Ride"] = 82.53, ["Neon"] = 41.91}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 7.88, ["Ride"] = 30.33, ["Fly|Ride"] = 412.56, ["Neon"] = 30.43, ["Neon|Fly|Ride"] = 261.99, ["Mega"] = 397.94, ["Mega|Ride"] = 352.74, ["Mega|Fly|Ride"] = 375.26}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 12.96, ["Ride"] = 11.68, ["Fly|Ride"] = 22.84, ["Neon"] = 2.1, ["Neon|Fly"] = 14.59, ["Neon|Ride"] = 11.82, ["Neon|Fly|Ride"] = 26.25, ["Mega"] = 14.66, ["Mega|Fly"] = 22.81, ["Mega|Ride"] = 22.32, ["Mega|Fly|Ride"] = 49.79}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 5.25, ["Fly"] = 118.12, ["Ride"] = 65.63, ["Neon"] = 5.1, ["Neon|Fly"] = 67.76, ["Neon|Ride"] = 31.99, ["Neon|Fly|Ride"] = 687.94, ["Mega"] = 85.31, ["Mega|Ride"] = 118.02}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Ride"] = 30.91, ["Neon"] = 2.1, ["Neon|Fly"] = 30.96, ["Neon|Ride"] = 22.14, ["Neon|Fly|Ride"] = 69.12, ["Mega"] = 14.3, ["Mega|Fly|Ride"] = 130.91}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Fly"] = 60.89, ["Neon|Ride"] = 127.31, ["Mega"] = 17.49, ["Mega|Ride"] = 111.4, ["Mega|Fly|Ride"] = 165.04}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 41.91, ["Ride"] = 14.3, ["Fly|Ride"] = 53.34, ["Neon"] = 9.64, ["Neon|Ride"] = 40.24, ["Neon|Fly|Ride"] = 102.13, ["Mega"] = 208.95, ["Mega|Ride"] = 391.94, ["Mega|Fly|Ride"] = 259.86}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 169.66, ["Ride"] = 230.02, ["Fly|Ride"] = 236.25, ["Neon|Ride"] = 757.32, ["Mega"] = 8251.08, ["Mega|Fly|Ride"] = 3887.72}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Ride"] = 17.51, ["Neon"] = 8.05, ["Neon|Ride"] = 82.5, ["Mega"] = 91.87, ["Mega|Ride"] = 165.04, ["Mega|Fly|Ride"] = 624.88}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 2.1, ["Fly"] = 103.68, ["Ride"] = 25.64, ["Fly|Ride"] = 56.72, ["Neon"] = 24.93, ["Neon|Ride"] = 93.29, ["Neon|Fly|Ride"] = 165.04, ["Mega"] = 360.94, ["Mega|Ride"] = 564.37, ["Mega|Fly|Ride"] = 407.64}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 28.74, ["Ride"] = 12.23, ["Fly|Ride"] = 32.45, ["Neon"] = 7.12, ["Neon|Fly"] = 27.87, ["Neon|Ride"] = 29.34, ["Neon|Fly|Ride"] = 55.71, ["Mega"] = 49.68, ["Mega|Ride"] = 81.38, ["Mega|Fly|Ride"] = 433.12}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 51.19, ["Ride"] = 19.68, ["Fly|Ride"] = 92.56, ["Neon"] = 6.24, ["Neon|Ride"] = 80.07, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 69.57, ["Mega|Ride"] = 185.67}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 2.1, ["Fly"] = 23.4, ["Ride"] = 15.06, ["Fly|Ride"] = 35.63, ["Neon"] = 46.66, ["Neon|Fly"] = 98.85, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 135.97, ["Mega|Ride"] = 271.27, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 4.52, ["Ride"] = 40.85, ["Fly|Ride"] = 249.61, ["Neon"] = 77.44, ["Neon|Fly|Ride"] = 612.66, ["Mega"] = 412.56, ["Mega|Ride"] = 342.38, ["Mega|Fly|Ride"] = 1031.4}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.1, ["Fly"] = 22.31, ["Ride"] = 14.44, ["Fly|Ride"] = 27.85, ["Neon"] = 20.26, ["Neon|Fly"] = 76.13, ["Neon|Ride"] = 28.29, ["Neon|Fly|Ride"] = 76.13, ["Mega"] = 138.22, ["Mega|Ride"] = 239.3, ["Mega|Fly|Ride"] = 311.27}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 55.54, ["Ride"] = 84, ["Fly|Ride"] = 148.32, ["Neon"] = 328.13, ["Neon|Fly"] = 437.07, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 406.88, ["Mega|Fly|Ride"] = 1555.1}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 223.11, ["Fly"] = 329.41, ["Ride"] = 224.93, ["Fly|Ride"] = 341.25, ["Neon|Ride"] = 2578.47, ["Neon|Fly|Ride"] = 977.78, ["Mega"] = 10313.85, ["Mega|Fly|Ride"] = 4676.31}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 56.43, ["Fly"] = 195.9, ["Ride"] = 75.77, ["Fly|Ride"] = 108.94, ["Neon"] = 699.61, ["Neon|Ride"] = 328.12, ["Neon|Fly|Ride"] = 412.56, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 6.46, ["Fly"] = 287.88, ["Ride"] = 34.04, ["Fly|Ride"] = 81.5, ["Neon"] = 26.71, ["Neon|Ride"] = 100.29, ["Neon|Fly|Ride"] = 196.77, ["Mega"] = 309.72, ["Mega|Ride"] = 392.44, ["Mega|Fly|Ride"] = 414.1}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 8.27, ["Fly"] = 69.12, ["Ride"] = 32.87, ["Fly|Ride"] = 59.04, ["Neon"] = 81.37, ["Neon|Ride"] = 126.26, ["Neon|Fly|Ride"] = 275.39, ["Mega"] = 312.36, ["Mega|Ride"] = 383.34, ["Mega|Fly|Ride"] = 1155.16}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 19.04, ["Ride"] = 18.58, ["Fly|Ride"] = 44.51, ["Neon"] = 3.51, ["Neon|Ride"] = 19.92, ["Neon|Fly|Ride"] = 58.22, ["Mega"] = 49.88, ["Mega|Fly"] = 154.88, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 5.71, ["Fly"] = 72.12, ["Ride"] = 20.74, ["Fly|Ride"] = 81.38, ["Neon"] = 110.37, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 150.6, ["Mega"] = 413.44, ["Mega|Ride"] = 821, ["Mega|Fly|Ride"] = 732.38}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.27, ["Fly"] = 41.9, ["Ride"] = 15.09, ["Fly|Ride"] = 39.74, ["Neon"] = 11.69, ["Neon|Fly"] = 96.96, ["Neon|Ride"] = 28.65, ["Neon|Fly|Ride"] = 92.59, ["Mega"] = 179.48, ["Mega|Ride"] = 211.18, ["Mega|Fly|Ride"] = 171.52}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 3.66, ["Ride"] = 21.18, ["Fly|Ride"] = 328.13, ["Neon"] = 19.69, ["Neon|Ride"] = 65.63, ["Mega"] = 207.38, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 371.32}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 34.35, ["Ride"] = 131.25, ["Neon"] = 2.1, ["Neon|Ride"] = 19.65, ["Neon|Fly|Ride"] = 57.73, ["Mega"] = 15.7, ["Mega|Ride"] = 36.11, ["Mega|Fly|Ride"] = 209831.44}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 3.94, ["Fly"] = 18.19, ["Ride"] = 18.38, ["Fly|Ride"] = 41.27, ["Neon"] = 14.34, ["Neon|Fly"] = 36.75, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 147, ["Mega"] = 108.94, ["Mega|Ride"] = 138.22, ["Mega|Fly|Ride"] = 209.35}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 3.05, ["Fly"] = 24.94, ["Ride"] = 19.69, ["Fly|Ride"] = 61.11, ["Neon"] = 78.75, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 550.77, ["Mega"] = 131.17, ["Mega|Ride"] = 195.98, ["Mega|Fly|Ride"] = 275.39}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 122.07, ["Fly"] = 179.82, ["Ride"] = 157.5, ["Fly|Ride"] = 227.95, ["Neon"] = 1050, ["Neon|Ride"] = 560.44, ["Neon|Fly|Ride"] = 742.43, ["Mega"] = 4125.55, ["Mega|Fly|Ride"] = 2035.47}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 7.77, ["Ride"] = 31.99, ["Fly|Ride"] = 124.78, ["Neon"] = 116.82, ["Neon|Ride"] = 98.42, ["Neon|Fly|Ride"] = 376.56, ["Mega"] = 417.38, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 41.1, ["Ride"] = 15.4, ["Fly|Ride"] = 45.28, ["Neon"] = 9.19, ["Neon|Ride"] = 26.82, ["Neon|Fly|Ride"] = 120.74, ["Mega"] = 322.88, ["Mega|Fly|Ride"] = 308.44}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 22.92, ["Ride"] = 41.32, ["Fly|Ride"] = 170.63, ["Neon"] = 131.25, ["Neon|Ride"] = 215.25, ["Neon|Fly|Ride"] = 523.57, ["Mega"] = 674.55, ["Mega|Fly"] = 825.12, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 616.17}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 3.94}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 2.1, ["Ride"] = 28.5, ["Fly|Ride"] = 126.83, ["Neon"] = 40.3, ["Neon|Ride"] = 91.83, ["Neon|Fly|Ride"] = 344.5, ["Mega"] = 566.51, ["Mega|Ride"] = 528.08, ["Mega|Fly|Ride"] = 899.66}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 23.48, ["Ride"] = 29.84, ["Fly|Ride"] = 59.07, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 162.63, ["Neon|Fly|Ride"] = 168.87, ["Mega"] = 2062.78, ["Mega|Fly|Ride"] = 670.73}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 18.66, ["Neon"] = 3.29, ["Neon|Fly"] = 65.62, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 106.26, ["Mega"] = 31.49, ["Mega|Fly"] = 275.39, ["Mega|Ride"] = 64.52, ["Mega|Fly|Ride"] = 227.75}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 10.4, ["Fly"] = 28.28, ["Ride"] = 23.73, ["Fly|Ride"] = 61.89, ["Neon"] = 10.4, ["Neon|Ride"] = 233.19, ["Mega"] = 233.17, ["Mega|Fly"] = 389.37, ["Mega|Ride"] = 204.23, ["Mega|Fly|Ride"] = 377.5}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.14, ["Fly"] = 32.82, ["Ride"] = 18.5, ["Fly|Ride"] = 45.09, ["Neon"] = 8.71, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 35.11, ["Neon|Fly|Ride"] = 64.37, ["Mega"] = 183.6, ["Mega|Ride"] = 138.21, ["Mega|Fly|Ride"] = 344.5}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 206.29, ["Neon"] = 3.94, ["Neon|Ride"] = 23.15, ["Neon|Fly|Ride"] = 206.29, ["Mega"] = 24.05, ["Mega|Ride"] = 55.04, ["Mega|Fly|Ride"] = 311.27}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 30.19, ["Ride"] = 87.94, ["Fly|Ride"] = 179.48, ["Neon"] = 223.13, ["Neon|Ride"] = 275.39, ["Neon|Fly|Ride"] = 576.19, ["Mega"] = 1004.59, ["Mega|Ride"] = 932.59, ["Mega|Fly|Ride"] = 962.64}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 2.1, ["Ride"] = 68.25, ["Fly|Ride"] = 210, ["Neon"] = 93.19, ["Neon|Ride"] = 138.22, ["Mega|Ride"] = 524.99}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 3.94, ["Fly"] = 36.11, ["Ride"] = 18.43, ["Fly|Ride"] = 67.77, ["Neon"] = 17.91, ["Neon|Fly"] = 315, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 343.39, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 61.69, ["Fly"] = 433.12, ["Ride"] = 393.73, ["Fly|Ride"] = 262.46, ["Neon"] = 328.13, ["Neon|Ride"] = 536.33, ["Mega|Ride"] = 2165.63, ["Mega|Fly|Ride"] = 1836.19}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 6.16, ["Fly"] = 52.5, ["Ride"] = 27.87, ["Fly|Ride"] = 55.99, ["Neon"] = 45.94, ["Neon|Ride"] = 52.92, ["Neon|Fly|Ride"] = 210.41, ["Mega"] = 296.03, ["Mega|Ride"] = 412.56, ["Mega|Fly|Ride"] = 638.72}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 69.57, ["Fly"] = 152.66, ["Ride"] = 84, ["Fly|Ride"] = 183.6, ["Neon"] = 262.5, ["Neon|Ride"] = 223.12, ["Mega"] = 1113.91, ["Mega|Ride"] = 901.78, ["Mega|Fly|Ride"] = 1054.96}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 19.97, ["Ride"] = 52.15, ["Fly|Ride"] = 202.9, ["Neon"] = 79.54, ["Neon|Ride"] = 103.85, ["Neon|Fly|Ride"] = 225.39, ["Mega"] = 590.63, ["Mega|Ride"] = 313.94, ["Mega|Fly|Ride"] = 439.04}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 3.46, ["Fly"] = 104.13, ["Ride"] = 27.74, ["Fly|Ride"] = 61.89, ["Neon"] = 136.83, ["Neon|Ride"] = 90.2, ["Neon|Fly|Ride"] = 370.75, ["Mega"] = 412.56, ["Mega|Ride"] = 1547.1, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 14.02, ["Ride"] = 47.16, ["Neon"] = 65.63, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 354.38, ["Mega"] = 283.82, ["Mega|Ride"] = 297.47, ["Mega|Fly|Ride"] = 392.44}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 10.34, ["Ride"] = 19.59, ["Fly|Ride"] = 65.19, ["Neon"] = 37.14, ["Neon|Ride"] = 56.6, ["Neon|Fly|Ride"] = 141.16, ["Mega"] = 244.13, ["Mega|Ride"] = 567, ["Mega|Fly|Ride"] = 411.98}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 57.2, ["Mega"] = 26.83, ["Mega|Ride"] = 123.78, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 5.25, ["Ride"] = 28.42, ["Neon"] = 22.46, ["Neon|Fly"] = 123.78, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 202.78, ["Mega"] = 177.36, ["Mega|Ride"] = 206.29, ["Mega|Fly|Ride"] = 410.51}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 3.94, ["Neon"] = 25.83, ["Mega"] = 229.04, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 3.72, ["Ride"] = 32.79, ["Fly|Ride"] = 116.62, ["Neon"] = 32.82, ["Neon|Ride"] = 82.95, ["Mega"] = 123.38, ["Mega|Ride"] = 275.39, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 610.32, ["Ride"] = 565.76, ["Fly|Ride"] = 685.13, ["Neon|Ride"] = 2062.78, ["Neon|Fly|Ride"] = 1788.44, ["Mega|Fly|Ride"] = 5880}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 4.46, ["Ride"] = 19.2, ["Fly|Ride"] = 62.87, ["Neon"] = 40.24, ["Neon|Ride"] = 96.96, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 155.91, ["Mega|Ride"] = 356.73, ["Mega|Fly|Ride"] = 468.26}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 6.55, ["Fly"] = 524.69, ["Ride"] = 21.29, ["Fly|Ride"] = 51.54, ["Neon"] = 39.36, ["Neon|Fly"] = 315, ["Neon|Ride"] = 88.7, ["Neon|Fly|Ride"] = 160.91, ["Mega"] = 331.84, ["Mega|Ride"] = 489.92, ["Mega|Fly|Ride"] = 481.67}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 2.1, ["Fly"] = 15.49, ["Ride"] = 26.66, ["Fly|Ride"] = 309.43, ["Neon"] = 13.12, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 264.64, ["Mega|Ride"] = 275.39}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.58, ["Ride"] = 21, ["Fly|Ride"] = 90.57, ["Neon"] = 7.44, ["Neon|Ride"] = 29.9, ["Neon|Fly|Ride"] = 103.83, ["Mega"] = 75.23, ["Mega|Fly"] = 211.78, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 69.12, ["Ride"] = 20.65, ["Neon"] = 2.37, ["Neon|Ride"] = 23.6, ["Neon|Fly|Ride"] = 118.12, ["Mega"] = 19.63, ["Mega|Ride"] = 62.91, ["Mega|Fly|Ride"] = 218.67}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1109.05}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 15.47, ["Ride"] = 39.37, ["Fly|Ride"] = 323.65, ["Neon"] = 57.74, ["Neon|Ride"] = 104.99, ["Mega"] = 550.77, ["Mega|Ride"] = 550.77, ["Mega|Fly|Ride"] = 849.87}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 25.58, ["Neon"] = 4.29, ["Neon|Ride"] = 74.27, ["Neon|Fly|Ride"] = 982.1, ["Mega"] = 39.37, ["Mega|Ride"] = 141.85, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.1, ["Fly"] = 41.1, ["Ride"] = 19.69, ["Fly|Ride"] = 412.56, ["Neon"] = 19.48, ["Neon|Ride"] = 138.22, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 183.74, ["Mega|Ride"] = 366.06, ["Mega|Fly|Ride"] = 1031.4}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 448.04, ["Ride"] = 525, ["Fly|Ride"] = 556.5, ["Neon|Ride"] = 2146.52, ["Neon|Fly|Ride"] = 1706.25, ["Mega"] = 8549.48, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 3.94, ["Fly"] = 196.88, ["Ride"] = 59.07, ["Fly|Ride"] = 412.56, ["Neon"] = 36.06, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 186.56, ["Mega"] = 481.67, ["Mega|Ride"] = 466.31, ["Mega|Fly|Ride"] = 669.15}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Fly"] = 90.96, ["Ride"] = 24.93, ["Fly|Ride"] = 118.13, ["Neon"] = 2.63, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 109.34, ["Mega"] = 35.84, ["Mega|Ride"] = 70.82, ["Mega|Fly|Ride"] = 177.09}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 412.56, ["Mega"] = 31.5, ["Mega|Ride"] = 136.5, ["Mega|Fly|Ride"] = 374.07}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 15.75, ["Fly"] = 107.9, ["Ride"] = 69.02, ["Fly|Ride"] = 118.62, ["Neon"] = 127.45, ["Neon|Ride"] = 128.52, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 495.08, ["Mega|Ride"] = 605.43, ["Mega|Fly|Ride"] = 594.57}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 7.94, ["Ride"] = 71.31, ["Neon"] = 96.48, ["Neon|Ride"] = 123.78, ["Neon|Fly|Ride"] = 918.75, ["Mega"] = 393.75, ["Mega|Ride"] = 477.75, ["Mega|Fly|Ride"] = 567.28}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 6.57, ["Ride"] = 31.39, ["Fly|Ride"] = 131.25, ["Neon"] = 311.22, ["Neon|Ride"] = 176.06, ["Mega"] = 637.67, ["Mega|Fly|Ride"] = 1237.67}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 11.45, ["Ride"] = 23.15, ["Fly|Ride"] = 262.5, ["Neon"] = 167.37, ["Neon|Ride"] = 182.44, ["Neon|Fly|Ride"] = 206.29, ["Mega"] = 610.32, ["Mega|Ride"] = 649.04, ["Mega|Fly|Ride"] = 665.44}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 410.51, ["Ride"] = 481.67, ["Fly|Ride"] = 750.92, ["Neon"] = 918.75, ["Neon|Ride"] = 1306.78, ["Neon|Fly|Ride"] = 1243.97, ["Mega|Fly|Ride"] = 4125.55}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 7.88, ["Fly"] = 78.73, ["Ride"] = 20.01, ["Fly|Ride"] = 236.25, ["Neon"] = 129.84, ["Neon|Ride"] = 159.12, ["Mega"] = 825.12, ["Mega|Ride"] = 1011.29, ["Mega|Fly|Ride"] = 851.93}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 3.63, ["Ride"] = 126, ["Neon"] = 52.08, ["Neon|Ride"] = 136.5, ["Mega"] = 218.67, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 1031.4}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 20.9, ["Ride"] = 69.57, ["Neon"] = 79.91, ["Neon|Ride"] = 128.36, ["Neon|Fly|Ride"] = 260.78, ["Mega"] = 275.63, ["Mega|Fly"] = 687.94, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 428.74}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.63, ["Ride"] = 78.4, ["Fly|Ride"] = 138.22, ["Neon"] = 6.47, ["Neon|Ride"] = 31.5, ["Mega"] = 47.13, ["Mega|Ride"] = 125.57, ["Mega|Fly|Ride"] = 295.32}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 41.19, ["Ride"] = 55.71, ["Neon"] = 330.05, ["Neon|Ride"] = 406.88, ["Mega"] = 1632.04, ["Mega|Ride"] = 1398.89, ["Mega|Fly|Ride"] = 1499.66}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Ride"] = 25.2, ["Neon"] = 10.5, ["Neon|Fly"] = 179.48, ["Neon|Ride"] = 96.95, ["Neon|Fly|Ride"] = 112.02, ["Mega"] = 90.57, ["Mega|Ride"] = 107.63, ["Mega|Fly|Ride"] = 212.96}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 89.75, ["Ride"] = 30.19, ["Fly|Ride"] = 157.5, ["Neon"] = 5.15, ["Neon|Fly"] = 49.39, ["Neon|Ride"] = 47.15, ["Neon|Fly|Ride"] = 97.89, ["Mega"] = 39.38, ["Mega|Fly"] = 101.43, ["Mega|Ride"] = 73.5, ["Mega|Fly|Ride"] = 170.36}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Ride"] = 37.97, ["Fly|Ride"] = 127.52, ["Neon"] = 14.44, ["Neon|Ride"] = 59.76, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 109.51, ["Mega|Fly"] = 459.38, ["Mega|Ride"] = 122.07, ["Mega|Fly|Ride"] = 311.27}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 36.75, ["Fly"] = 93.29, ["Ride"] = 60.24, ["Neon"] = 291.38, ["Neon|Ride"] = 300.38, ["Neon|Fly|Ride"] = 412.56, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 222.2, ["Ride"] = 304.27, ["Fly|Ride"] = 412.56, ["Neon"] = 1433.64, ["Neon|Ride"] = 1100.5, ["Neon|Fly|Ride"] = 1297.57, ["Mega"] = 9325.86, ["Mega|Fly|Ride"] = 4410}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 9.19, ["Neon"] = 51.1, ["Neon|Fly"] = 350.44, ["Neon|Ride"] = 105.29, ["Neon|Fly|Ride"] = 105, ["Mega"] = 104.9, ["Mega|Fly"] = 227.95, ["Mega|Ride"] = 311.27, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.63, ["Ride"] = 32.82, ["Neon"] = 8.15, ["Neon|Ride"] = 45.94, ["Mega"] = 64.32, ["Mega|Fly"] = 210, ["Mega|Ride"] = 102.37, ["Mega|Fly|Ride"] = 241.5}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 2.55, ["Fly"] = 155.57, ["Ride"] = 27.57, ["Neon"] = 32.81, ["Neon|Ride"] = 69.12, ["Mega"] = 132.76, ["Mega|Ride"] = 348.23}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 69.29, ["Ride"] = 26.25, ["Neon"] = 8.6, ["Neon|Ride"] = 46.34, ["Neon|Fly|Ride"] = 152.66, ["Mega"] = 124.2, ["Mega|Ride"] = 156.77, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 90.77, ["Neon"] = 7.87, ["Neon|Fly|Ride"] = 188.75, ["Mega"] = 43.32, ["Mega|Fly"] = 140.3, ["Mega|Fly|Ride"] = 272.3}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 65.54, ["Ride"] = 17.07, ["Fly|Ride"] = 49.88, ["Neon"] = 7.01, ["Neon|Fly"] = 78.14, ["Neon|Ride"] = 27.87, ["Neon|Fly|Ride"] = 412.56, ["Mega|Ride"] = 95.72, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 3.75, ["Fly"] = 137.61, ["Ride"] = 15.88, ["Fly|Ride"] = 61.69, ["Neon"] = 30.16, ["Neon|Fly"] = 64.97, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 93.29, ["Mega"] = 156.15, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 437.07}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 45.94, ["Ride"] = 31.37, ["Fly|Ride"] = 78.73, ["Neon"] = 139.94, ["Neon|Fly|Ride"] = 466.36, ["Mega"] = 1134.54, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 548.79}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 63, ["Ride"] = 84.31, ["Fly|Ride"] = 124.52, ["Neon"] = 511.52, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 3346.14, ["Mega|Ride"] = 3254.99, ["Mega|Fly|Ride"] = 1939.01}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 17.88, ["Fly|Ride"] = 131.25, ["Neon"] = 3.94, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 128.47, ["Mega"] = 27.77, ["Mega|Fly"] = 88.71, ["Mega|Ride"] = 92.8}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 12.35, ["Ride"] = 13.73, ["Fly|Ride"] = 36.66, ["Neon"] = 3.93, ["Neon|Fly"] = 28.37, ["Neon|Ride"] = 23.75, ["Neon|Fly|Ride"] = 61.68, ["Mega"] = 39.37, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 65.62, ["Mega|Fly|Ride"] = 129.94}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 11.31, ["Ride"] = 73.49, ["Neon"] = 35.65, ["Neon|Ride"] = 124.68, ["Neon|Fly|Ride"] = 275.39, ["Mega"] = 527.63, ["Mega|Ride"] = 481.67, ["Mega|Fly|Ride"] = 622.51}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 388.63, ["Ride"] = 472.5, ["Fly|Ride"] = 577.5, ["Mega|Fly|Ride"] = 7771.94}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 23.63, ["Fly"] = 101.33, ["Ride"] = 50.58, ["Fly|Ride"] = 98.44, ["Neon"] = 236.25, ["Neon|Ride"] = 206.29, ["Neon|Fly|Ride"] = 199.07, ["Mega|Ride"] = 1135.43, ["Mega|Fly|Ride"] = 917.44}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 25.85, ["Fly|Ride"] = 281.29, ["Neon"] = 9.45, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 110.37, ["Mega"] = 76.04, ["Mega|Ride"] = 126.99, ["Mega|Fly|Ride"] = 283.65}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.63, ["Fly"] = 91.88, ["Ride"] = 65.61, ["Fly|Ride"] = 143.05, ["Neon"] = 12.5}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 40.69, ["Fly"] = 169.3, ["Ride"] = 46.81, ["Fly|Ride"] = 65.63, ["Neon"] = 194.25, ["Neon|Ride"] = 466.36, ["Neon|Fly|Ride"] = 264.99, ["Mega"] = 2475.34, ["Mega|Ride"] = 1133.5, ["Mega|Fly|Ride"] = 1237.67}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 77.59, ["Ride"] = 107.85, ["Fly|Ride"] = 412.56, ["Neon"] = 434.43, ["Neon|Fly|Ride"] = 610.32, ["Mega"] = 8251.08, ["Mega|Fly|Ride"] = 2227.8}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 181.92, ["Ride"] = 268.83, ["Fly|Ride"] = 513.65, ["Neon"] = 1050, ["Neon|Ride"] = 1365, ["Neon|Fly|Ride"] = 1237.67, ["Mega|Fly|Ride"] = 3575.83}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 11.44, ["Fly"] = 51.81, ["Ride"] = 55.44, ["Fly|Ride"] = 117.59, ["Neon"] = 76.4, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 233.19, ["Mega"] = 388.49, ["Mega|Ride"] = 392.44, ["Mega|Fly|Ride"] = 493.82}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.63, ["Fly"] = 17.1, ["Ride"] = 13.79, ["Fly|Ride"] = 41.91, ["Neon"] = 5.2, ["Neon|Ride"] = 21.54, ["Neon|Fly|Ride"] = 89.75, ["Mega"] = 84.28, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 170.35}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 3.13, ["Fly"] = 39, ["Ride"] = 15.88, ["Fly|Ride"] = 58.32, ["Neon"] = 42, ["Neon|Fly"] = 105, ["Neon|Ride"] = 44.41, ["Neon|Fly|Ride"] = 109.34, ["Mega|Ride"] = 422.01, ["Mega|Fly|Ride"] = 366.19}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 301.88, ["Fly"] = 481.67, ["Ride"] = 332.93, ["Fly|Ride"] = 436.1, ["Neon"] = 1575, ["Neon|Ride"] = 2150.35, ["Mega"] = 9901.31, ["Mega|Fly|Ride"] = 5687.07}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 32.62, ["Neon"] = 6.28, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 31.5, ["Mega|Ride"] = 170.99}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 6.57, ["Ride"] = 13.78, ["Fly|Ride"] = 126, ["Neon"] = 20.9, ["Neon|Ride"] = 37.93, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 224.86, ["Mega|Ride"] = 179.47, ["Mega|Fly|Ride"] = 220.73}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 14.44, ["Ride"] = 46.18, ["Neon"] = 104.81, ["Neon|Ride"] = 236.24, ["Mega"] = 527.69, ["Mega|Ride"] = 649.68, ["Mega|Fly|Ride"] = 567.11}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 127.04, ["Fly"] = 157.5, ["Ride"] = 121.71, ["Fly|Ride"] = 166.68, ["Neon"] = 638.44, ["Neon|Ride"] = 699.53, ["Neon|Fly|Ride"] = 586.34, ["Mega|Fly|Ride"] = 2378.25}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 16.49, ["Fly"] = 42.95, ["Ride"] = 22.76, ["Fly|Ride"] = 48.49, ["Neon"] = 104.24, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 206.29, ["Mega"] = 687.94, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 545.4}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 20.65, ["Neon"] = 2.63, ["Neon|Ride"] = 138.22, ["Mega"] = 23.62, ["Mega|Ride"] = 275.39}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 70.17, ["Neon"] = 2.1, ["Neon|Ride"] = 19.85, ["Neon|Fly|Ride"] = 74.46, ["Mega"] = 29.93, ["Mega|Fly"] = 87.64, ["Mega|Ride"] = 39.16, ["Mega|Fly|Ride"] = 112.71}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 9.58, ["Ride"] = 72.35, ["Fly|Ride"] = 131.18, ["Neon"] = 27.57, ["Neon|Fly"] = 144.38, ["Neon|Ride"] = 65.54, ["Neon|Fly|Ride"] = 181.29, ["Mega"] = 161.24, ["Mega|Fly"] = 292.92, ["Mega|Ride"] = 219.17, ["Mega|Fly|Ride"] = 304.27}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1168.12, ["Ride"] = 1298.08, ["Fly|Ride"] = 1507.58, ["Neon"] = 4200, ["Neon|Ride"] = 3701.25, ["Neon|Fly|Ride"] = 3701.25, ["Mega|Fly|Ride"] = 12589.5}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 443.63, ["Fly"] = 918.75, ["Ride"] = 474.84, ["Fly|Ride"] = 620.91, ["Neon"] = 2421.7, ["Neon|Ride"] = 2572.28, ["Neon|Fly|Ride"] = 2362.5, ["Mega"] = 16502.15, ["Mega|Fly|Ride"] = 9351.57}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 324.19, ["Fly"] = 411.54, ["Ride"] = 360.15, ["Fly|Ride"] = 429.18, ["Neon"] = 656.25, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 774.38, ["Mega|Fly|Ride"] = 2916.23}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 395.29, ["Fly"] = 550.77, ["Ride"] = 428.05, ["Fly|Ride"] = 510.56, ["Neon|Ride"] = 812.93}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 64.31, ["Ride"] = 15.63, ["Fly|Ride"] = 38.07, ["Neon"] = 7.76, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 105, ["Mega"] = 57.86, ["Mega|Fly"] = 96.96, ["Mega|Ride"] = 138.22, ["Mega|Fly|Ride"] = 200.82}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 317.36, ["Fly"] = 1375.88, ["Ride"] = 358.43, ["Fly|Ride"] = 597.19, ["Neon"] = 1706.24, ["Neon|Ride"] = 1365, ["Neon|Fly|Ride"] = 1926.64, ["Mega|Ride"] = 6600.87, ["Mega|Fly|Ride"] = 4331.25}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 15.48, ["Fly"] = 157.5, ["Ride"] = 35.09, ["Fly|Ride"] = 156.26, ["Neon"] = 20.99, ["Neon|Ride"] = 206.29, ["Neon|Fly|Ride"] = 252, ["Mega"] = 137.36, ["Mega|Ride"] = 202.79, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 20.65, ["Fly|Ride"] = 31.97, ["Neon"] = 7.88, ["Neon|Ride"] = 27.72, ["Neon|Fly|Ride"] = 138.22, ["Mega"] = 105, ["Mega|Ride"] = 192.93}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 54.35, ["Neon"] = 3.46, ["Neon|Ride"] = 39.37, ["Mega"] = 28.7, ["Mega|Ride"] = 196.88}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 26.17, ["Ride"] = 55.49, ["Fly|Ride"] = 459.37, ["Neon"] = 235.75, ["Neon|Ride"] = 351.29, ["Mega"] = 1050, ["Mega|Ride"] = 488.25}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.63, ["Fly"] = 41.27, ["Ride"] = 26.83, ["Fly|Ride"] = 68.24, ["Neon"] = 73.5, ["Mega|Ride"] = 424.34, ["Mega|Fly|Ride"] = 412.56}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.13, ["Neon"] = 2.63, ["Neon|Ride"] = 40.32, ["Neon|Fly|Ride"] = 88.41, ["Mega"] = 24.66, ["Mega|Ride"] = 90.78, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.1, ["Fly"] = 34.04, ["Ride"] = 16.4, ["Fly|Ride"] = 78.65, ["Neon"] = 15.49, ["Neon|Fly"] = 96.96, ["Neon|Ride"] = 44, ["Neon|Fly|Ride"] = 76.04, ["Mega"] = 110.87, ["Mega|Fly"] = 279.79, ["Mega|Ride"] = 128.63, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 4.2, ["Fly"] = 91.88, ["Ride"] = 19.23, ["Fly|Ride"] = 52.5, ["Neon"] = 30.96, ["Neon|Ride"] = 138.22, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 237.57, ["Mega|Ride"] = 300.53, ["Mega|Fly|Ride"] = 311.27}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 8.7, ["Ride"] = 46.57, ["Neon"] = 76.34, ["Mega"] = 505.94, ["Mega|Ride"] = 413.44, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.1, ["Fly"] = 6219.4, ["Ride"] = 27.87, ["Neon"] = 187.58, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 183.72, ["Neon|Fly|Ride"] = 699.53, ["Mega"] = 301.88, ["Mega|Ride"] = 481.67, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 64.16, ["Ride"] = 18.38, ["Fly|Ride"] = 45.94, ["Neon"] = 3.94, ["Neon|Fly"] = 82.48, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 55.71, ["Mega"] = 59.84, ["Mega|Ride"] = 176.04, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 154.98, ["Ride"] = 178.5, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 887, ["Neon|Fly|Ride"] = 1036.87, ["Mega"] = 8251.08, ["Mega|Ride"] = 4125.55, ["Mega|Fly|Ride"] = 2756.25}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 18.35, ["Ride"] = 13.54, ["Fly|Ride"] = 28.24, ["Neon"] = 2.62, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 56.35, ["Mega"] = 44.62, ["Mega|Ride"] = 52.65, ["Mega|Fly|Ride"] = 109.45}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 6.28, ["Fly"] = 138.22, ["Ride"] = 42.36, ["Fly|Ride"] = 183.75, ["Neon"] = 96.96, ["Neon|Ride"] = 184.22, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 466.31, ["Mega|Fly"] = 777.55, ["Mega|Fly|Ride"] = 1031.4}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 34.08, ["Ride"] = 93.3, ["Fly|Ride"] = 170.63, ["Neon"] = 189.58, ["Neon|Ride"] = 275.39, ["Mega"] = 963.33, ["Mega|Ride"] = 819.37, ["Mega|Fly|Ride"] = 1030.37}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 171.89, ["Ride"] = 253.45, ["Fly|Ride"] = 302.92, ["Neon"] = 761.25, ["Neon|Fly|Ride"] = 982.66, ["Mega|Fly|Ride"] = 3816.14}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 16.4, ["Fly|Ride"] = 138.22, ["Neon"] = 91.87, ["Mega"] = 284.57, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 695.63}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 7.11, ["Fly|Ride"] = 179.47, ["Neon"] = 412.56, ["Neon|Ride"] = 199, ["Neon|Fly|Ride"] = 218.03, ["Mega"] = 771.75, ["Mega|Ride"] = 825.12, ["Mega|Fly|Ride"] = 963.33}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 1237.67, ["Ride"] = 1050, ["Fly|Ride"] = 1251.03, ["Neon"] = 4676.31, ["Neon|Ride"] = 4790.63, ["Neon|Fly|Ride"] = 4641.25, ["Mega|Fly|Ride"] = 18111.11}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 34.12, ["Fly"] = 19.68, ["Ride"] = 19.79, ["Fly|Ride"] = 52.5, ["Neon"] = 26.25, ["Neon|Fly"] = 94.89, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 206.27, ["Mega"] = 233.17, ["Mega|Fly|Ride"] = 347.82}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 5.24, ["Fly"] = 51.19, ["Ride"] = 35.44, ["Fly|Ride"] = 135.19, ["Neon"] = 33.54, ["Neon|Ride"] = 60.64, ["Mega"] = 199.7, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 248.36}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Fly"] = 90.46, ["Ride"] = 24.96, ["Fly|Ride"] = 89.74, ["Neon"] = 10.14, ["Neon|Ride"] = 47.16, ["Mega"] = 105, ["Mega|Ride"] = 240.62, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 14.44, ["Ride"] = 30.19, ["Fly|Ride"] = 81.09, ["Neon"] = 72.19, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 141.56, ["Mega"] = 437.07, ["Mega|Ride"] = 427.49, ["Mega|Fly|Ride"] = 592.04}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 8.19, ["Fly"] = 32.82, ["Ride"] = 20.54, ["Fly|Ride"] = 51.19, ["Neon"] = 21.95, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 35.09, ["Neon|Fly|Ride"] = 94.49, ["Mega|Fly"] = 280.98, ["Mega|Fly|Ride"] = 412.56}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.63, ["Ride"] = 103.16, ["Neon"] = 12.21, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 56.25, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 131, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 344.5}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 349.13, ["Ride"] = 236.25, ["Fly|Ride"] = 2062.78, ["Neon|Fly|Ride"] = 984.38}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 4.68, ["Fly"] = 32.82, ["Ride"] = 22.71, ["Fly|Ride"] = 107.28, ["Neon"] = 7.48, ["Neon|Ride"] = 32.13, ["Neon|Fly|Ride"] = 119.84, ["Mega"] = 85.22, ["Mega|Fly"] = 412.56, ["Mega|Ride"] = 122.88, ["Mega|Fly|Ride"] = 267.15}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 2.63, ["Fly|Ride"] = 88.86, ["Neon"] = 31.5, ["Neon|Ride"] = 188.27, ["Mega"] = 124.69, ["Mega|Ride"] = 237.57}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 3.15, ["Fly"] = 96.96, ["Ride"] = 26.25, ["Neon"] = 20.33, ["Neon|Ride"] = 51.17, ["Mega"] = 99.75, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 482.9}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 246.75, ["Fly|Ride"] = 825.12, ["Neon"] = 1100.5, ["Neon|Ride"] = 1650.12, ["Mega|Ride"] = 4950.66, ["Mega|Fly|Ride"] = 3018.75}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 24.96, ["Ride"] = 59.84, ["Fly|Ride"] = 206.29, ["Neon"] = 149.5, ["Neon|Fly|Ride"] = 374.07, ["Mega"] = 498.75, ["Mega|Fly|Ride"] = 859.69}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 18.77, ["Fly"] = 74.63, ["Ride"] = 30.85, ["Fly|Ride"] = 90.57, ["Neon"] = 97.67, ["Neon|Ride"] = 165.04, ["Neon|Fly|Ride"] = 192.4, ["Mega"] = 548.03, ["Mega|Ride"] = 421.22, ["Mega|Fly|Ride"] = 548.82}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 4.03, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 209.99, ["Mega"] = 52.5, ["Mega|Fly|Ride"] = 237.23}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 48.57, ["Fly"] = 138.22, ["Ride"] = 95.1, ["Fly|Ride"] = 182.31, ["Neon"] = 262.48, ["Neon|Fly"] = 258.79, ["Neon|Ride"] = 218.21, ["Neon|Fly|Ride"] = 356.88, ["Mega|Fly|Ride"] = 1169.61}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 19.47, ["Fly|Ride"] = 32.15, ["Neon"] = 5, ["Neon|Ride"] = 55.71, ["Neon|Fly|Ride"] = 122.75, ["Mega"] = 58.9, ["Mega|Fly|Ride"] = 412.56}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 18.09, ["Ride"] = 28.61, ["Fly|Ride"] = 88.71, ["Neon"] = 66.2, ["Neon|Ride"] = 125.15, ["Neon|Fly|Ride"] = 247.54, ["Mega"] = 275.39, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 412.56, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 37.66, ["Fly"] = 110.15, ["Ride"] = 81.43, ["Fly|Ride"] = 192.88, ["Neon"] = 274.76, ["Neon|Ride"] = 301.87, ["Neon|Fly|Ride"] = 411.54, ["Mega|Ride"] = 1926.64, ["Mega|Fly|Ride"] = 1226.76}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 13.85, ["Fly|Ride"] = 35.44, ["Neon"] = 2.1, ["Neon|Fly"] = 23.73, ["Neon|Ride"] = 17.56, ["Neon|Fly|Ride"] = 30.19, ["Mega"] = 17.07, ["Mega|Fly"] = 118.56, ["Mega|Ride"] = 28.77, ["Mega|Fly|Ride"] = 86.63}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 2.62, ["Ride"] = 52.49, ["Fly|Ride"] = 129.97, ["Neon"] = 16.2, ["Neon|Ride"] = 60.86, ["Neon|Fly|Ride"] = 412.56, ["Mega"] = 227.95, ["Mega|Ride"] = 386.54, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 17.06, ["Ride"] = 45.94, ["Neon"] = 150.94, ["Neon|Ride"] = 157.05, ["Mega"] = 536.82, ["Mega|Ride"] = 459.37, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 26.83, ["Neon"] = 2.1, ["Neon|Ride"] = 28.86, ["Neon|Fly|Ride"] = 95.8, ["Mega"] = 18.38, ["Mega|Ride"] = 65.63}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 10.5, ["Fly"] = 187.6, ["Ride"] = 86.63, ["Fly|Ride"] = 164.05, ["Neon"] = 107.52, ["Neon|Ride"] = 172.56, ["Neon|Fly|Ride"] = 411.54, ["Mega"] = 536.65, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 721.64}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 10.5, ["Fly"] = 103.69, ["Ride"] = 26.48, ["Fly|Ride"] = 98.44, ["Neon"] = 388.52, ["Neon|Ride"] = 110.92, ["Neon|Fly|Ride"] = 129.94, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 4.14, ["Ride"] = 18.12, ["Fly|Ride"] = 138.22, ["Neon"] = 31.29, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 130.19, ["Mega"] = 233.62, ["Mega|Ride"] = 237.72, ["Mega|Fly|Ride"] = 403.29}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 11.81, ["Fly"] = 2062.78, ["Ride"] = 83.99, ["Fly|Ride"] = 238.64, ["Neon"] = 54.52, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 6217.46, ["Mega"] = 466.31, ["Mega|Ride"] = 585.21}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Ride"] = 16.01, ["Fly|Ride"] = 196.88, ["Neon"] = 6.57, ["Neon|Ride"] = 32.43, ["Mega"] = 74.81, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 152.66, ["Mega|Fly|Ride"] = 275.39}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 55.53, ["Neon"] = 3.5, ["Mega"] = 27.57, ["Mega|Ride"] = 138.22, ["Mega|Fly|Ride"] = 234.65}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 19.68}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 36.2, ["Fly"] = 78.75, ["Ride"] = 37.8, ["Fly|Ride"] = 83.61, ["Neon"] = 235.17, ["Neon|Ride"] = 271.8, ["Neon|Fly|Ride"] = 313.68, ["Mega"] = 1650.23, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 889.88}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 3.68, ["Mega"] = 25.62, ["Mega|Ride"] = 119.7, ["Mega|Fly|Ride"] = 309.43}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 446.25, ["Fly"] = 498.75, ["Ride"] = 605.43, ["Fly|Ride"] = 774.23, ["Neon"] = 2058.66, ["Neon|Fly|Ride"] = 2273.82, ["Mega"] = 16502.15, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 2.17, ["Fly"] = 26.24, ["Ride"] = 24.19, ["Fly|Ride"] = 66.26, ["Neon"] = 30.98, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 95.85, ["Mega|Fly"] = 154.72, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 550.77}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.1, ["Fly"] = 95.55, ["Ride"] = 20.86, ["Fly|Ride"] = 69.33, ["Neon"] = 23.63, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 164.07, ["Mega|Ride"] = 179.47, ["Mega|Fly|Ride"] = 234.69}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 18.38, ["Fly"] = 77.38, ["Ride"] = 50.3, ["Fly|Ride"] = 106.32, ["Neon"] = 102.77, ["Neon|Ride"] = 168.13, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 825.12, ["Mega|Ride"] = 468.26, ["Mega|Fly|Ride"] = 550.77}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 2.1, ["Ride"] = 27.87, ["Fly|Ride"] = 721.88, ["Neon"] = 25.26, ["Neon|Ride"] = 118.12, ["Mega"] = 261.19}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 9.55, ["Fly"] = 138.22, ["Ride"] = 42, ["Fly|Ride"] = 173.23, ["Neon"] = 118.13, ["Neon|Ride"] = 175.35, ["Neon|Fly|Ride"] = 371.32, ["Mega|Ride"] = 617.54, ["Mega|Fly|Ride"] = 798.31}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 6.57, ["Ride"] = 40.86, ["Fly|Ride"] = 133.88, ["Neon"] = 37.49, ["Neon|Ride"] = 76.34, ["Neon|Fly|Ride"] = 204.75, ["Mega"] = 550.76, ["Mega|Fly"] = 550.77, ["Mega|Ride"] = 311.27, ["Mega|Fly|Ride"] = 370.41}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 46.66, ["Ride"] = 11.61, ["Fly|Ride"] = 69.12, ["Neon"] = 2.1, ["Neon|Fly"] = 58.8, ["Neon|Ride"] = 15.48, ["Neon|Fly|Ride"] = 123.78, ["Mega"] = 14.86, ["Mega|Ride"] = 31.99, ["Mega|Fly|Ride"] = 150.29}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 6.57, ["Fly"] = 52.62, ["Ride"] = 32.7, ["Fly|Ride"] = 103.16, ["Neon"] = 40.57, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 220.73, ["Mega"] = 196.84, ["Mega|Ride"] = 217.88, ["Mega|Fly|Ride"] = 714.67}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 294.84, ["Ride"] = 298.85, ["Fly|Ride"] = 393.75, ["Neon"] = 1244.13, ["Neon|Ride"] = 1404.38, ["Neon|Fly|Ride"] = 1252.13, ["Mega|Ride"] = 5053.79, ["Mega|Fly|Ride"] = 5074.42}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 80.34, ["Ride"] = 138.22, ["Fly|Ride"] = 7563.15, ["Neon"] = 536.47, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 585.38, ["Mega"] = 2200.99, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1704.94}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 12.33, ["Ride"] = 15.32, ["Fly|Ride"] = 41.27, ["Neon"] = 8.4, ["Neon|Fly"] = 69.12, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 63.31, ["Mega|Fly"] = 205.26, ["Mega|Ride"] = 156, ["Mega|Fly|Ride"] = 256.6}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 27.87, ["Ride"] = 14.44, ["Fly|Ride"] = 32.82, ["Neon"] = 5.25, ["Neon|Fly"] = 41.27, ["Neon|Ride"] = 23.12, ["Neon|Fly|Ride"] = 55.13, ["Mega"] = 91.88, ["Mega|Fly"] = 344.03, ["Mega|Ride"] = 116.82, ["Mega|Fly|Ride"] = 212.48}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.1, ["Ride"] = 22.32, ["Fly|Ride"] = 98.44, ["Neon"] = 45.85, ["Mega"] = 206.29, ["Mega|Ride"] = 412.56}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 239, ["Ride"] = 250.78, ["Fly|Ride"] = 367.5, ["Neon"] = 1375.88, ["Neon|Ride"] = 1047.9, ["Neon|Fly|Ride"] = 1526.46, ["Mega|Ride"] = 8251.08, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 3.15, ["Fly"] = 19.84, ["Ride"] = 15.72, ["Fly|Ride"] = 31.49, ["Neon"] = 17.07, ["Neon|Fly"] = 104.97, ["Neon|Ride"] = 39.25, ["Neon|Fly|Ride"] = 247.54, ["Mega"] = 253.74, ["Mega|Ride"] = 288.81, ["Mega|Fly|Ride"] = 361.01}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 6.14, ["Ride"] = 98.44, ["Fly|Ride"] = 206.29, ["Neon"] = 69.12, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 275.39, ["Mega"] = 299.25, ["Mega|Ride"] = 288.65, ["Mega|Fly|Ride"] = 396.06}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 27.85, ["Neon"] = 5.39, ["Neon|Ride"] = 156.19, ["Mega"] = 82.23, ["Mega|Ride"] = 206.29}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 14.3, ["Fly"] = 55.71, ["Ride"] = 19.55, ["Fly|Ride"] = 74.81, ["Neon"] = 80.75, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 588.93, ["Mega|Ride"] = 438.38, ["Mega|Fly|Ride"] = 782.83}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 39.38, ["Ride"] = 85.32, ["Fly|Ride"] = 196.88, ["Neon"] = 131.25, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 195.85, ["Neon|Fly|Ride"] = 342.57, ["Mega"] = 622.51, ["Mega|Fly"] = 2165.92, ["Mega|Ride"] = 510.56, ["Mega|Fly|Ride"] = 637.16}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 22.31, ["Ride"] = 61.89, ["Fly|Ride"] = 91.88, ["Neon"] = 154.72, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 210.41, ["Neon|Fly|Ride"] = 309.43, ["Mega"] = 687.94, ["Mega|Ride"] = 825.12, ["Mega|Fly|Ride"] = 866.25}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 20.65, ["Ride"] = 11.82, ["Fly|Ride"] = 42.33, ["Neon"] = 2.1, ["Neon|Fly"] = 23.82, ["Neon|Ride"] = 15.32, ["Neon|Fly|Ride"] = 47.15, ["Mega"] = 17.05, ["Mega|Fly"] = 411.75, ["Mega|Ride"] = 40.36, ["Mega|Fly|Ride"] = 98.44}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 234.94, ["Ride"] = 280.88, ["Fly|Ride"] = 379.1, ["Neon"] = 974.53, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1237.67}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 11.45, ["Fly"] = 101.19, ["Ride"] = 42.37, ["Fly|Ride"] = 105, ["Neon"] = 131, ["Neon|Ride"] = 186.56, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 510.56, ["Mega|Fly|Ride"] = 777.55}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 30.68, ["Ride"] = 16.96, ["Fly|Ride"] = 42.09, ["Neon"] = 5.92, ["Neon|Fly"] = 35.33, ["Neon|Ride"] = 20.65, ["Neon|Fly|Ride"] = 109.34, ["Mega"] = 59.07, ["Mega|Fly"] = 275.39, ["Mega|Ride"] = 69.33, ["Mega|Fly|Ride"] = 292.61}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 30.96, ["Ride"] = 15.65, ["Fly|Ride"] = 43.28, ["Neon"] = 2.63, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 27.87, ["Neon|Fly|Ride"] = 124.76, ["Mega"] = 24.94, ["Mega|Fly"] = 138.22, ["Mega|Ride"] = 45.4, ["Mega|Fly|Ride"] = 177.85}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 3.68, ["Ride"] = 28.74, ["Fly|Ride"] = 69.29, ["Neon"] = 8.55, ["Neon|Fly"] = 699.61, ["Neon|Ride"] = 69.98, ["Mega"] = 127.98, ["Mega|Ride"] = 194.09, ["Mega|Fly|Ride"] = 373.06}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 9.37, ["Fly"] = 47.25, ["Ride"] = 22.61, ["Fly|Ride"] = 59.76, ["Neon"] = 52.5, ["Neon|Fly"] = 261.99, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 120.1, ["Mega"] = 428.05, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 9.19, ["Ride"] = 18.38, ["Neon"] = 69.12, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 275.63, ["Mega|Ride"] = 275.39, ["Mega|Fly|Ride"] = 410.51}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 43.31, ["Fly|Ride"] = 275.39, ["Neon"] = 3.84, ["Neon|Ride"] = 31.39, ["Neon|Fly|Ride"] = 100.64, ["Mega"] = 31.49, ["Mega|Ride"] = 70.88, ["Mega|Fly|Ride"] = 174.61}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 8.64, ["Ride"] = 24.71, ["Fly|Ride"] = 131.25, ["Neon"] = 28.87, ["Neon|Fly"] = 102.8, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 316.65, ["Mega"] = 208.64, ["Mega|Ride"] = 200.82, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 210, ["Neon"] = 2.91, ["Neon|Ride"] = 45.77, ["Neon|Fly|Ride"] = 102.3, ["Mega"] = 27.57, ["Mega|Ride"] = 101.09, ["Mega|Fly|Ride"] = 131}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 41.04, ["Ride"] = 16.69, ["Fly|Ride"] = 39.38, ["Neon"] = 5.91, ["Neon|Ride"] = 20.88, ["Neon|Fly|Ride"] = 95.47, ["Mega"] = 52.41, ["Mega|Fly"] = 138.22, ["Mega|Ride"] = 86.65, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 656.12, ["Ride"] = 820.32, ["Fly|Ride"] = 825.57, ["Neon|Ride"] = 3575.65, ["Neon|Fly|Ride"] = 3300.45, ["Mega|Fly|Ride"] = 12832.39}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 19.22, ["Ride"] = 13.54, ["Fly|Ride"] = 31.54, ["Neon"] = 11.7, ["Neon|Fly"] = 138.22, ["Neon|Ride"] = 35.79, ["Neon|Fly|Ride"] = 72.21, ["Mega"] = 184.64, ["Mega|Fly|Ride"] = 344.5}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.1, ["Ride"] = 40.85, ["Fly|Ride"] = 275.39, ["Neon"] = 8.23, ["Neon|Fly"] = 721.98, ["Neon|Ride"] = 88.55, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 53.82, ["Mega|Ride"] = 130.53, ["Mega|Fly|Ride"] = 240.66}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 9.29, ["Fly"] = 147, ["Ride"] = 22.32, ["Fly|Ride"] = 48.64, ["Neon"] = 53.44, ["Neon|Fly"] = 189.38, ["Neon|Ride"] = 82.53, ["Neon|Fly|Ride"] = 107.62, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 328.11}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 20.11, ["Ride"] = 15.49, ["Fly|Ride"] = 32.82, ["Neon"] = 7.88, ["Neon|Fly"] = 144.41, ["Neon|Ride"] = 23.61, ["Neon|Fly|Ride"] = 68.51, ["Mega"] = 65.01, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 99.75, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 26.17, ["Ride"] = 72.19, ["Fly|Ride"] = 275.39, ["Neon"] = 316.65, ["Neon|Ride"] = 263.5, ["Mega"] = 918.75}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 19.68, ["Fly|Ride"] = 64.46, ["Neon"] = 9.34, ["Neon|Fly"] = 141.75, ["Neon|Ride"] = 31.4, ["Neon|Fly|Ride"] = 142.35, ["Mega"] = 61.89, ["Mega|Ride"] = 116.55, ["Mega|Fly|Ride"] = 264.64}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 3.24, ["Ride"] = 19.36, ["Fly|Ride"] = 53.65, ["Neon"] = 8.8, ["Neon|Ride"] = 41.89, ["Neon|Fly|Ride"] = 156.23, ["Mega"] = 114.19, ["Mega|Ride"] = 198.59, ["Mega|Fly|Ride"] = 474.45}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.63, ["Fly|Ride"] = 65.63, ["Neon"] = 15.49, ["Mega"] = 92.11, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 42, ["Ride"] = 15.73, ["Fly|Ride"] = 49.86, ["Neon"] = 5.25, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 98.34, ["Mega"] = 42, ["Mega|Fly"] = 229.68, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 165.04}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 38.64, ["Fly"] = 17.31, ["Ride"] = 19.69, ["Fly|Ride"] = 42.51, ["Neon"] = 311.34, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 98.43, ["Mega"] = 825.12, ["Mega|Ride"] = 385.75, ["Mega|Fly|Ride"] = 687.94}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 703.5, ["Ride"] = 787.49, ["Fly|Ride"] = 918.75, ["Neon"] = 1712.63, ["Neon|Ride"] = 1909.69, ["Neon|Fly|Ride"] = 2157.67, ["Mega|Fly|Ride"] = 7743.75}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 18.36, ["Ride"] = 15.36, ["Fly|Ride"] = 33.17, ["Neon"] = 2.85, ["Neon|Ride"] = 16.42, ["Neon|Fly|Ride"] = 55.71, ["Mega"] = 33.73, ["Mega|Ride"] = 57.66, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 5.25, ["Ride"] = 36.72, ["Fly|Ride"] = 201.92, ["Neon"] = 39.36, ["Neon|Ride"] = 112.51, ["Neon|Fly|Ride"] = 196.87, ["Mega"] = 366.18, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 474.45}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 45.72, ["Ride"] = 59.07, ["Fly|Ride"] = 110.25, ["Neon|Ride"] = 389.82, ["Neon|Fly|Ride"] = 498.75, ["Mega"] = 3163.28, ["Mega|Fly|Ride"] = 2332.32}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 31.63, ["Ride"] = 32.71, ["Fly|Ride"] = 104.89, ["Neon"] = 291.38, ["Neon|Ride"] = 179.48, ["Neon|Fly|Ride"] = 687.94, ["Mega"] = 983.89, ["Mega|Ride"] = 896.44, ["Mega|Fly|Ride"] = 816.38}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 6.57, ["Ride"] = 26.22, ["Fly|Ride"] = 139.71, ["Neon"] = 58.97, ["Neon|Ride"] = 76.34, ["Neon|Fly|Ride"] = 121.42, ["Mega"] = 285.87, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 22.33, ["Ride"] = 56.55, ["Neon"] = 138.22, ["Neon|Ride"] = 357.93, ["Mega"] = 382.6, ["Mega|Fly"] = 505.94, ["Mega|Ride"] = 385.75, ["Mega|Fly|Ride"] = 508.6}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 20.04, ["Fly"] = 126.89, ["Neon"] = 420, ["Neon|Ride"] = 317.01, ["Neon|Fly|Ride"] = 525, ["Mega"] = 924, ["Mega|Ride"] = 728.44, ["Mega|Fly|Ride"] = 563.21}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 15.65}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 3.69, ["Ride"] = 16.62, ["Fly|Ride"] = 58.8, ["Neon"] = 31.2, ["Neon|Ride"] = 62.87, ["Neon|Fly|Ride"] = 179.48, ["Mega"] = 190.31, ["Mega|Fly"] = 463.87, ["Mega|Ride"] = 186.54, ["Mega|Fly|Ride"] = 466.31}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.17, ["Ride"] = 46.85, ["Neon"] = 11.81, ["Mega"] = 137.94}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 46.2, ["Fly"] = 59.07, ["Ride"] = 39.38, ["Fly|Ride"] = 91.77, ["Neon"] = 266.12, ["Neon|Ride"] = 189, ["Neon|Fly|Ride"] = 932.7, ["Mega|Ride"] = 706.19, ["Mega|Fly|Ride"] = 1072.65}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.29, ["Fly"] = 24.03, ["Ride"] = 14.96, ["Fly|Ride"] = 36.95, ["Neon"] = 25.2, ["Neon|Fly"] = 69.12, ["Neon|Ride"] = 31.34, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 116.82, ["Mega|Ride"] = 195.57, ["Mega|Fly|Ride"] = 251.27}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 6.45, ["Fly"] = 146.47, ["Ride"] = 21.61, ["Fly|Ride"] = 137.61, ["Neon"] = 14.43, ["Neon|Ride"] = 55.71, ["Neon|Fly|Ride"] = 118.11, ["Mega"] = 129.94, ["Mega|Ride"] = 165.04, ["Mega|Fly|Ride"] = 262.47}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 6.57, ["Mega"] = 42.51, ["Mega|Ride"] = 196.38}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 28.88, ["Ride"] = 65.63, ["Fly|Ride"] = 120.75, ["Neon"] = 210, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 284.68, ["Mega|Ride"] = 13752.48}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 38.56, ["Fly|Ride"] = 65.63, ["Neon"] = 5.16, ["Neon|Fly"] = 291.38, ["Neon|Ride"] = 31.99, ["Mega"] = 72.19, ["Mega|Ride"] = 118.12, ["Mega|Fly|Ride"] = 462.2}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 11.53, ["Fly"] = 52.5, ["Ride"] = 78.14, ["Fly|Ride"] = 274.37, ["Neon"] = 104.95, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 656.25, ["Mega|Ride"] = 444.94, ["Mega|Fly|Ride"] = 550.77}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 45.89, ["Ride"] = 17.07, ["Fly|Ride"] = 40.63, ["Neon"] = 18.59, ["Neon|Ride"] = 35.8, ["Neon|Fly|Ride"] = 75.87, ["Mega|Ride"] = 208.04, ["Mega|Fly|Ride"] = 249.47}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 4.14, ["Fly"] = 52.5, ["Ride"] = 19.3, ["Fly|Ride"] = 71.36, ["Neon"] = 26.25, ["Neon|Ride"] = 45.94, ["Mega|Ride"] = 412.56, ["Mega|Fly|Ride"] = 410.17}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 6.54, ["Ride"] = 82.53, ["Neon"] = 77.9, ["Neon|Ride"] = 157.55, ["Mega"] = 465.15, ["Mega|Ride"] = 894.23, ["Mega|Fly|Ride"] = 545.74}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 39.37, ["Ride"] = 103.16, ["Neon"] = 183.75, ["Neon|Fly|Ride"] = 687.94, ["Mega|Ride"] = 1650.23, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 15.63, ["Ride"] = 138.22, ["Neon"] = 99.02, ["Neon|Ride"] = 262.5, ["Mega"] = 412.56, ["Mega|Fly|Ride"] = 547.98}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 10.5, ["Ride"] = 105, ["Neon"] = 162.75, ["Neon|Fly"] = 206.29, ["Mega|Ride"] = 824.1}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 17.16, ["Ride"] = 232.32, ["Fly|Ride"] = 367.46, ["Neon"] = 145.53, ["Neon|Ride"] = 721.98, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 616.88, ["Mega|Fly"] = 2062.78, ["Mega|Fly|Ride"] = 1088.81}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 2.49, ["Neon"] = 20.65, ["Mega"] = 131.25, ["Mega|Fly|Ride"] = 311.27}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 19.68, ["Fly|Ride"] = 63, ["Neon"] = 3.09, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 25.26, ["Neon|Fly|Ride"] = 93.19, ["Mega"] = 138.22, ["Mega|Ride"] = 119.45, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 5.04, ["Ride"] = 275.29, ["Neon"] = 11.82, ["Neon|Ride"] = 41.27, ["Neon|Fly|Ride"] = 163.96, ["Mega"] = 102.56, ["Mega|Ride"] = 160.93, ["Mega|Fly|Ride"] = 237.23}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 20.6, ["Ride"] = 15.46, ["Fly|Ride"] = 56.16, ["Neon"] = 7.88, ["Neon|Ride"] = 27.46, ["Neon|Fly|Ride"] = 69.98, ["Mega"] = 55.12, ["Mega|Ride"] = 76.56, ["Mega|Fly|Ride"] = 275.39}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 26.25, ["Fly|Ride"] = 118.13, ["Neon"] = 24.76, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 256.83, ["Mega"] = 328.02, ["Mega|Ride"] = 325.94, ["Mega|Fly|Ride"] = 466.31}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.94, ["Fly"] = 65.63, ["Ride"] = 19.69, ["Fly|Ride"] = 103.69, ["Neon"] = 26.15, ["Neon|Fly"] = 466.41, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 287.46, ["Mega|Fly|Ride"] = 1237.67}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 2.45, ["Fly"] = 131.25, ["Ride"] = 24.65, ["Fly|Ride"] = 76.34, ["Neon"] = 26.17, ["Neon|Fly"] = 111.55, ["Neon|Ride"] = 36.11, ["Neon|Fly|Ride"] = 126, ["Mega|Ride"] = 313.86, ["Mega|Fly|Ride"] = 394.42}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 3.94, ["Fly"] = 35.87, ["Ride"] = 15.65, ["Fly|Ride"] = 51.69, ["Neon"] = 26.56, ["Neon|Fly"] = 82.53, ["Neon|Ride"] = 67.39, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 252.82, ["Mega|Ride"] = 347.17, ["Mega|Fly|Ride"] = 247.54}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 6.57, ["Fly"] = 57.75, ["Ride"] = 43.18, ["Fly|Ride"] = 131.25, ["Neon"] = 14.42, ["Neon|Fly"] = 418.76, ["Neon|Ride"] = 64.1, ["Neon|Fly|Ride"] = 128.44, ["Mega"] = 94.4, ["Mega|Fly"] = 156.35, ["Mega|Ride"] = 412.56, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 22.71, ["Fly"] = 206.29, ["Ride"] = 103.94, ["Fly|Ride"] = 468.57, ["Neon"] = 103.93, ["Neon|Fly"] = 433.13, ["Neon|Ride"] = 234.94, ["Neon|Fly|Ride"] = 419.72, ["Mega"] = 525, ["Mega|Ride"] = 618.84, ["Mega|Fly|Ride"] = 669.38}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 54.52, ["Fly"] = 164.07, ["Ride"] = 90.55, ["Fly|Ride"] = 480.4, ["Neon"] = 269.06, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 480.34, ["Mega"] = 1513.05, ["Mega|Ride"] = 1061.82, ["Mega|Fly|Ride"] = 1221.93}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 50.96, ["Ride"] = 19.51, ["Fly|Ride"] = 65, ["Neon"] = 2.25, ["Neon|Ride"] = 40.86, ["Mega"] = 39.38, ["Mega|Ride"] = 71.04, ["Mega|Fly|Ride"] = 148.32}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 11.46, ["Neon"] = 156.26, ["Mega|Fly|Ride"] = 963.33}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 39.38, ["Ride"] = 91.89, ["Neon"] = 371.21, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 824.1, ["Mega"] = 1690.45, ["Mega|Ride"] = 1237.67, ["Mega|Fly|Ride"] = 1443.95}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 8, ["Fly"] = 190.32, ["Ride"] = 53.4, ["Fly|Ride"] = 126, ["Neon"] = 36.62, ["Neon|Ride"] = 65.63, ["Mega"] = 185.19, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 383.92}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 2.63, ["Ride"] = 62.08, ["Fly|Ride"] = 138.22, ["Neon"] = 6.57, ["Mega"] = 61.69, ["Mega|Fly"] = 341.25, ["Mega|Ride"] = 127.98, ["Mega|Fly|Ride"] = 351.16}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 21.18, ["Ride"] = 14.44, ["Fly|Ride"] = 37.69, ["Neon"] = 11.95, ["Neon|Ride"] = 40.39, ["Neon|Fly|Ride"] = 84, ["Mega"] = 271.27, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 205.26, ["Mega|Fly|Ride"] = 225.88}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 14.34, ["Fly|Ride"] = 40.85, ["Neon"] = 2.49, ["Neon|Fly"] = 17.77, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 36.75, ["Mega"] = 40.81, ["Mega|Ride"] = 69.55, ["Mega|Fly|Ride"] = 201.13}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 19.04, ["Fly|Ride"] = 32.71, ["Neon"] = 2.63, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 124.69, ["Mega"] = 74.27, ["Mega|Ride"] = 121.71, ["Mega|Fly|Ride"] = 175.88}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.48, ["Neon"] = 2.1, ["Neon|Ride"] = 145.08, ["Mega"] = 25.74, ["Mega|Fly|Ride"] = 315.61}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 7.16, ["Ride"] = 104.98, ["Neon"] = 65.62, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 618.84, ["Mega"] = 233.17, ["Mega|Ride"] = 269.48, ["Mega|Fly|Ride"] = 311.27}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 9.34, ["Ride"] = 31.61, ["Fly|Ride"] = 206.29, ["Neon"] = 49.88, ["Neon|Ride"] = 202.9, ["Neon|Fly|Ride"] = 181.55, ["Mega|Ride"] = 412.56, ["Mega|Fly|Ride"] = 468.26}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 6.57, ["Fly"] = 25.8, ["Ride"] = 26.83, ["Fly|Ride"] = 46.93, ["Neon"] = 26.25, ["Neon|Fly"] = 69.12, ["Neon|Ride"] = 38.17, ["Neon|Fly|Ride"] = 82.36, ["Mega|Ride"] = 272.79, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 131.25, ["Ride"] = 45.94, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 446.15}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 35.09, ["Fly"] = 82.67, ["Ride"] = 65.63, ["Neon"] = 282.71, ["Neon|Fly|Ride"] = 630, ["Mega"] = 622.51, ["Mega|Ride"] = 827.54, ["Mega|Fly|Ride"] = 1020.48}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 14.44, ["Fly|Ride"] = 32.81, ["Neon"] = 2.63, ["Neon|Fly"] = 41.27, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 61.51, ["Mega|Fly|Ride"] = 87.94}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 15.12, ["Ride"] = 12.71, ["Fly|Ride"] = 27.2, ["Neon"] = 3.93, ["Neon|Fly"] = 26.99, ["Neon|Ride"] = 18.1, ["Neon|Fly|Ride"] = 48.49, ["Mega"] = 44.63, ["Mega|Fly"] = 82.53, ["Mega|Ride"] = 56.32, ["Mega|Fly|Ride"] = 102.38}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 428.92, ["Ride"] = 534.18, ["Fly|Ride"] = 551.25, ["Neon|Fly|Ride"] = 1884.09}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 24.94, ["Ride"] = 55.71, ["Fly|Ride"] = 59.07, ["Neon"] = 41.27, ["Neon|Ride"] = 82.53, ["Mega"] = 357.2, ["Mega|Ride"] = 674.55, ["Mega|Fly|Ride"] = 275036.02}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 15.27, ["Fly|Ride"] = 26.25, ["Neon"] = 3.92, ["Neon|Fly"] = 26.83, ["Neon|Ride"] = 15.49, ["Neon|Fly|Ride"] = 44.63, ["Mega"] = 138.22, ["Mega|Ride"] = 74.01, ["Mega|Fly|Ride"] = 105.44}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 63, ["Ride"] = 100.87, ["Fly|Ride"] = 514.4, ["Neon"] = 260.98, ["Neon|Ride"] = 264.49, ["Neon|Fly|Ride"] = 825.12, ["Mega"] = 719.25, ["Mega|Ride"] = 963.33, ["Mega|Fly|Ride"] = 878.35}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 3.94, ["Fly"] = 36.98, ["Ride"] = 17.48, ["Fly|Ride"] = 47.76, ["Neon"] = 14.43, ["Neon|Fly"] = 52.52, ["Neon|Ride"] = 19.59, ["Neon|Fly|Ride"] = 66.94, ["Mega"] = 91.68, ["Mega|Ride"] = 129.83, ["Mega|Fly|Ride"] = 206.06}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 69.57, ["Ride"] = 43.13, ["Neon"] = 2.1, ["Neon|Ride"] = 35.09, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 19.69, ["Mega|Ride"] = 61.28, ["Mega|Fly|Ride"] = 190.87}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 36.66, ["Fly"] = 108.03, ["Ride"] = 89.62, ["Fly|Ride"] = 194.86, ["Neon"] = 184.85, ["Neon|Ride"] = 191.26, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 787.5, ["Mega|Ride"] = 708.75, ["Mega|Fly|Ride"] = 1070.6}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Ride"] = 22.68, ["Neon"] = 6.82, ["Neon|Ride"] = 39.99, ["Mega"] = 123.27, ["Mega|Ride"] = 189, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 34.13, ["Ride"] = 69.44, ["Fly|Ride"] = 138.22, ["Neon"] = 233.21, ["Neon|Ride"] = 274.37, ["Neon|Fly|Ride"] = 359.63, ["Mega"] = 1629.6, ["Mega|Ride"] = 1650.23, ["Mega|Fly|Ride"] = 1505.83}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 2.1, ["Ride"] = 183.74, ["Neon"] = 16.95, ["Neon|Ride"] = 46.66, ["Neon|Fly|Ride"] = 481.61, ["Mega"] = 150.94, ["Mega|Ride"] = 131.25}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.1, ["Fly"] = 69.12, ["Ride"] = 39.38, ["Fly|Ride"] = 66.03, ["Neon"] = 6.89, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 183.75, ["Mega|Ride"] = 728.44, ["Mega|Fly|Ride"] = 550.77}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 36.05, ["Ride"] = 122.42, ["Fly|Ride"] = 515.71, ["Neon|Ride"] = 700.88, ["Mega|Ride"] = 2784.74, ["Mega|Fly|Ride"] = 1648.16}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 273.37, ["Ride"] = 20.94, ["Fly|Ride"] = 908.98, ["Neon"] = 5.23, ["Neon|Ride"] = 36.18, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 49.9, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 86.31, ["Mega|Fly|Ride"] = 181.79}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.16, ["Fly"] = 14.45, ["Ride"] = 12.48, ["Fly|Ride"] = 101.82, ["Neon"] = 13.13, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 196.88, ["Mega|Fly|Ride"] = 275.39}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 8.54, ["Fly"] = 58.49, ["Ride"] = 31.5, ["Fly|Ride"] = 75.78, ["Neon"] = 81.78, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 430.5, ["Mega|Ride"] = 399.16, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 14.43, ["Fly"] = 57.11, ["Ride"] = 51.57, ["Fly|Ride"] = 71.3, ["Neon"] = 72.17, ["Neon|Fly"] = 138.22, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 5156.93, ["Mega"] = 900.58, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 485.01}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 19.69, ["Fly"] = 61.89, ["Ride"] = 26.25, ["Fly|Ride"] = 62.87, ["Neon"] = 56.03, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 156.23, ["Mega"] = 548.03, ["Mega|Ride"] = 298.86, ["Mega|Fly|Ride"] = 424.94}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 73.14, ["Ride"] = 120.1, ["Fly|Ride"] = 247.54, ["Neon"] = 315, ["Neon|Ride"] = 406.87, ["Neon|Fly|Ride"] = 656.25, ["Mega|Ride"] = 1513.05, ["Mega|Fly|Ride"] = 1299.38}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 3.55, ["Fly"] = 138.22, ["Ride"] = 55.71, ["Neon"] = 23.63, ["Neon|Ride"] = 116.55, ["Neon|Fly|Ride"] = 311.29, ["Mega"] = 223.12, ["Mega|Fly|Ride"] = 382.6}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 3.78, ["Ride"] = 27.09, ["Fly|Ride"] = 78.74, ["Neon"] = 25.67, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 123.78, ["Mega"] = 173.29, ["Mega|Ride"] = 183.74, ["Mega|Fly|Ride"] = 246.62}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 10.49, ["Fly"] = 275.39, ["Ride"] = 24.02, ["Fly|Ride"] = 108.73, ["Neon"] = 47.04, ["Neon|Ride"] = 205.7, ["Neon|Fly|Ride"] = 232.73, ["Mega"] = 454.85, ["Mega|Ride"] = 618.84}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.23, ["Ride"] = 12.55, ["Fly|Ride"] = 30.23, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 13.3, ["Neon|Fly|Ride"] = 37.68, ["Mega"] = 14.47, ["Mega|Ride"] = 33.03, ["Mega|Fly|Ride"] = 93.82}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 48.45, ["Ride"] = 78.75, ["Fly|Ride"] = 275.39, ["Neon"] = 412.55, ["Neon|Fly"] = 2338.17, ["Neon|Ride"] = 291.06, ["Neon|Fly|Ride"] = 488.15, ["Mega"] = 3094.17, ["Mega|Ride"] = 945, ["Mega|Fly|Ride"] = 866.25}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 20.65, ["Fly|Ride"] = 35.09, ["Neon"] = 2.88, ["Neon|Ride"] = 27.44, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 258.89, ["Mega|Ride"] = 78.66, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 27.8, ["Ride"] = 15.74, ["Fly|Ride"] = 51.7, ["Neon"] = 26.17, ["Neon|Ride"] = 87.84, ["Neon|Fly|Ride"] = 119.66, ["Mega|Ride"] = 134.87, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 84, ["Ride"] = 120.61, ["Fly|Ride"] = 258.57, ["Neon"] = 450.19, ["Neon|Ride"] = 675.57, ["Neon|Fly|Ride"] = 1237.67, ["Mega"] = 1748.25, ["Mega|Ride"] = 1758.75, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 25.26, ["Neon"] = 6.09, ["Neon|Ride"] = 63.96, ["Mega"] = 63.95, ["Mega|Ride"] = 111.92, ["Mega|Fly|Ride"] = 234.94}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 7.76}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 32.02, ["Neon"] = 6.08, ["Neon|Ride"] = 41.28, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 61.69, ["Mega|Ride"] = 108.09, ["Mega|Fly|Ride"] = 217.88}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 163.25, ["Ride"] = 217.88, ["Fly|Ride"] = 296.18, ["Neon"] = 674.55, ["Neon|Ride"] = 675.57, ["Neon|Fly|Ride"] = 917.44, ["Mega|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 2835}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 2.63, ["Ride"] = 37.97, ["Neon"] = 19.57, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 124.69, ["Mega"] = 183.65, ["Mega|Ride"] = 156.22, ["Mega|Fly|Ride"] = 363.07}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.21, ["Fly"] = 26.25, ["Ride"] = 82.53, ["Neon"] = 3.83, ["Neon|Ride"] = 19.4, ["Neon|Fly|Ride"] = 275.39, ["Mega"] = 32.8, ["Mega|Ride"] = 101.09, ["Mega|Fly|Ride"] = 138.21}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 7.88, ["Ride"] = 18.8, ["Neon"] = 48.07, ["Neon|Ride"] = 110.25, ["Neon|Fly|Ride"] = 156, ["Mega"] = 481.67, ["Mega|Ride"] = 550.77, ["Mega|Fly|Ride"] = 614.76}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 7.66, ["Fly"] = 26.25, ["Ride"] = 20.99, ["Fly|Ride"] = 55.76, ["Neon"] = 132.04, ["Neon|Ride"] = 131.15, ["Neon|Fly|Ride"] = 255.29, ["Mega"] = 597.19, ["Mega|Ride"] = 555.19, ["Mega|Fly|Ride"] = 481.69}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 16.49, ["Ride"] = 61.69, ["Fly|Ride"] = 206.29, ["Neon|Ride"] = 275.39, ["Neon|Fly|Ride"] = 1575, ["Mega"] = 560.44, ["Mega|Ride"] = 825.12, ["Mega|Fly|Ride"] = 687.94}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 143.07, ["Fly"] = 275.39, ["Ride"] = 192.88, ["Fly|Ride"] = 228.38, ["Neon"] = 593.14, ["Neon|Ride"] = 590, ["Neon|Fly|Ride"] = 630, ["Mega|Fly|Ride"] = 2357.38}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 102.62, ["Ride"] = 98.44, ["Fly|Ride"] = 200.1, ["Neon"] = 454.85, ["Neon|Ride"] = 825.12, ["Neon|Fly|Ride"] = 466.36}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 3.93, ["Fly"] = 131.23, ["Ride"] = 19.68, ["Fly|Ride"] = 91.88, ["Neon"] = 15.61, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 135.13, ["Mega|Fly|Ride"] = 311.27}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 16.43, ["Fly"] = 233.21, ["Fly|Ride"] = 393.75, ["Neon"] = 144.37, ["Neon|Ride"] = 110.35, ["Mega"] = 249.38, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 51.19, ["Fly"] = 139.94, ["Ride"] = 75.07, ["Fly|Ride"] = 210.41, ["Neon"] = 288.75, ["Neon|Ride"] = 275.44, ["Mega|Ride"] = 1165.5, ["Mega|Fly|Ride"] = 1181.24}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 11.82, ["Ride"] = 67.39, ["Neon"] = 105, ["Neon|Ride"] = 550.77, ["Neon|Fly|Ride"] = 454.85, ["Mega"] = 676.5, ["Mega|Ride"] = 714.67}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 327.39, ["Ride"] = 550.77, ["Neon|Ride"] = 3109.32, ["Neon|Fly|Ride"] = 1376.82}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 25.85, ["Ride"] = 32.45, ["Fly|Ride"] = 75.7, ["Neon|Ride"] = 138.22, ["Neon|Fly|Ride"] = 253.74, ["Mega"] = 1196.43, ["Mega|Ride"] = 922.62, ["Mega|Fly|Ride"] = 1076.25}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 38.21, ["Ride"] = 14.8, ["Fly|Ride"] = 119.13, ["Neon"] = 2.1, ["Neon|Ride"] = 14.39, ["Neon|Fly|Ride"] = 74.27, ["Mega"] = 18.12, ["Mega|Fly"] = 109.34, ["Mega|Ride"] = 28.88, ["Mega|Fly|Ride"] = 120.1}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 3.15, ["Neon"] = 19.4, ["Neon|Ride"] = 69.57, ["Neon|Fly|Ride"] = 259.92, ["Mega"] = 196.88, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 412.56}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 3.83, ["Ride"] = 29.93, ["Fly|Ride"] = 60.52, ["Neon"] = 19.11, ["Neon|Fly|Ride"] = 963.33, ["Mega"] = 108.04, ["Mega|Fly"] = 498.61, ["Mega|Ride"] = 274.37, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 393.75, ["Fly"] = 498.6, ["Ride"] = 439.69, ["Fly|Ride"] = 525, ["Neon"] = 1424.39, ["Neon|Ride"] = 2913.75, ["Neon|Fly|Ride"] = 1536.94, ["Mega|Fly|Ride"] = 5026.88}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.1, ["Fly"] = 69.12, ["Ride"] = 17.05, ["Fly|Ride"] = 41.99, ["Neon"] = 39.27, ["Neon|Ride"] = 69.12, ["Neon|Fly|Ride"] = 87.44, ["Mega"] = 168, ["Mega|Ride"] = 275.39, ["Mega|Fly|Ride"] = 466.31}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 10.4, ["Fly"] = 23.73, ["Ride"] = 16.53, ["Fly|Ride"] = 32.82, ["Neon"] = 43.25, ["Neon|Fly"] = 156.45, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 687.94, ["Mega|Fly|Ride"] = 286.38}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 8.26, ["Fly"] = 44.36, ["Ride"] = 28.88, ["Fly|Ride"] = 78.75, ["Neon"] = 10.4, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 54.94, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 262.5, ["Mega|Ride"] = 268.17, ["Mega|Fly|Ride"] = 304.27}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 116.62, ["Fly"] = 42, ["Ride"] = 40.2, ["Fly|Ride"] = 57.46, ["Neon"] = 220.29, ["Neon|Ride"] = 206.29, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 825.12, ["Mega|Ride"] = 824.1, ["Mega|Fly|Ride"] = 660.19}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.63, ["Fly"] = 39.37, ["Ride"] = 27.74, ["Fly|Ride"] = 50.3, ["Neon"] = 11.7, ["Neon|Ride"] = 114.19, ["Neon|Fly|Ride"] = 210, ["Mega"] = 162.08, ["Mega|Ride"] = 457.79, ["Mega|Fly|Ride"] = 761.92}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 6.47, ["Ride"] = 24.71, ["Fly|Ride"] = 85.62, ["Neon"] = 185.72, ["Neon|Ride"] = 210, ["Mega"] = 1650.23, ["Mega|Fly|Ride"] = 846.57}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 19.57, ["Neon"] = 5.25, ["Neon|Ride"] = 28.87, ["Mega"] = 53.83, ["Mega|Ride"] = 109.59, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 6.57, ["Ride"] = 262.5, ["Neon"] = 84}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 15.49, ["Neon"] = 78.66, ["Neon|Ride"] = 466.36, ["Neon|Fly|Ride"] = 412.56, ["Mega"] = 275.39, ["Mega|Ride"] = 543.47, ["Mega|Fly|Ride"] = 509.25}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 10.07, ["Fly"] = 27.57, ["Ride"] = 27.87, ["Fly|Ride"] = 82.53, ["Neon"] = 52.39, ["Neon|Fly"] = 68.09, ["Neon|Ride"] = 54.51, ["Neon|Fly|Ride"] = 119.44, ["Mega"] = 579.66, ["Mega|Ride"] = 326.42, ["Mega|Fly|Ride"] = 361.87}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 320.09, ["Fly"] = 577.18, ["Ride"] = 334.59, ["Fly|Ride"] = 474.85, ["Neon"] = 1399.21, ["Neon|Ride"] = 1303.12, ["Neon|Fly|Ride"] = 1470, ["Mega|Fly|Ride"] = 4179.15}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 15.62, ["Fly|Ride"] = 26.25, ["Neon"] = 12.64, ["Neon|Fly"] = 78.14, ["Neon|Ride"] = 32.28, ["Neon|Fly|Ride"] = 145.04, ["Mega"] = 213.34, ["Mega|Ride"] = 196.77}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 2.59, ["Fly"] = 110.37, ["Ride"] = 45.94, ["Fly|Ride"] = 110.34, ["Neon"] = 42.95, ["Neon|Ride"] = 146.9, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 196.88, ["Mega|Fly"] = 687.94, ["Mega|Ride"] = 389.82}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 25.97, ["Ride"] = 98.62, ["Fly|Ride"] = 315, ["Neon"] = 156.26, ["Neon|Ride"] = 131.16, ["Neon|Fly|Ride"] = 404.56, ["Mega"] = 466.1, ["Mega|Ride"] = 412.56}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 125.09, ["Fly"] = 155.94, ["Ride"] = 275.39, ["Fly|Ride"] = 443.58, ["Neon"] = 1375.88, ["Neon|Ride"] = 1443.95, ["Neon|Fly|Ride"] = 1088.91, ["Mega|Ride"] = 6341.58, ["Mega|Fly|Ride"] = 3439.68}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 27.87, ["Fly"] = 121.71, ["Ride"] = 102.13, ["Fly|Ride"] = 130.91, ["Neon"] = 124.76, ["Neon|Ride"] = 156.26, ["Neon|Fly|Ride"] = 160.13, ["Mega"] = 347.81, ["Mega|Ride"] = 511.88, ["Mega|Fly|Ride"] = 456.91}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.63, ["Fly"] = 28.87, ["Ride"] = 19.58, ["Fly|Ride"] = 52.5, ["Neon"] = 12.46, ["Neon|Ride"] = 33.53, ["Neon|Fly|Ride"] = 68.87, ["Mega"] = 65.59, ["Mega|Ride"] = 152.66, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 3.72, ["Ride"] = 29.88, ["Neon"] = 27.57, ["Neon|Ride"] = 94.25, ["Neon|Fly|Ride"] = 172.81, ["Mega"] = 169.32, ["Mega|Ride"] = 160.75}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 55.38, ["Fly"] = 196.88, ["Ride"] = 144.38, ["Fly|Ride"] = 198.19, ["Neon"] = 150.94, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 335.21, ["Mega"] = 511.88, ["Mega|Ride"] = 622.51, ["Mega|Fly|Ride"] = 616.79}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.63, ["Ride"] = 131.24, ["Neon"] = 11.81, ["Neon|Ride"] = 206.29, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 57.75, ["Mega|Ride"] = 160.4, ["Mega|Fly|Ride"] = 399.16}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 31.99, ["Neon"] = 110.07, ["Neon|Ride"] = 401.03, ["Mega"] = 499.21, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 1023.75, ["Fly"] = 2062.78, ["Ride"] = 1036.88, ["Fly|Ride"] = 1097.67, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2887.89, ["Mega|Fly|Ride"] = 10932.68}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 17.22, ["Fly"] = 106.47, ["Ride"] = 81.38, ["Fly|Ride"] = 191.63, ["Neon"] = 202.13, ["Neon|Fly"] = 686.93, ["Neon|Ride"] = 157.5, ["Mega"] = 471.45, ["Mega|Fly|Ride"] = 687.94}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 21.42, ["Fly|Ride"] = 65.63, ["Neon"] = 13.88, ["Neon|Ride"] = 33.03, ["Neon|Fly|Ride"] = 103.16, ["Mega"] = 82.59, ["Mega|Ride"] = 156.24, ["Mega|Fly|Ride"] = 220.89}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 10.97, ["Ride"] = 47.25, ["Fly|Ride"] = 138.22, ["Neon"] = 95.17, ["Mega"] = 312.53, ["Mega|Ride"] = 421.93, ["Mega|Fly|Ride"] = 924}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 18.99, ["Fly|Ride"] = 59.84, ["Neon"] = 2.1, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 91.66, ["Mega"] = 14.44, ["Mega|Fly"] = 123.78, ["Mega|Ride"] = 43.99, ["Mega|Fly|Ride"] = 141.77}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 61.68, ["Fly"] = 105, ["Ride"] = 87.94, ["Fly|Ride"] = 229.69, ["Neon"] = 260.73, ["Neon|Ride"] = 298.38, ["Neon|Fly|Ride"] = 610.59, ["Mega"] = 1117.44, ["Mega|Ride"] = 914.76, ["Mega|Fly|Ride"] = 1035.57}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 6.39, ["Ride"] = 44.36, ["Fly|Ride"] = 159.43, ["Neon"] = 60.74, ["Neon|Ride"] = 44.63, ["Mega"] = 682.5, ["Mega|Ride"] = 472.5, ["Mega|Fly|Ride"] = 548.71}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2.1, ["Ride"] = 26.83, ["Neon"] = 13.02, ["Neon|Ride"] = 32.82, ["Mega"] = 91.88, ["Mega|Ride"] = 157.49}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 73.41, ["Fly"] = 69.12, ["Ride"] = 48.46, ["Fly|Ride"] = 114.01, ["Neon"] = 130.91, ["Neon|Ride"] = 97.13, ["Neon|Fly|Ride"] = 139.72, ["Mega"] = 687.95, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 674.55}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 13.13, ["Ride"] = 30.21, ["Neon"] = 43.68, ["Neon|Ride"] = 136.83, ["Neon|Fly|Ride"] = 315, ["Mega"] = 480.8, ["Mega|Ride"] = 518.22, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 56.56, ["Ride"] = 84, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 1247.55, ["Mega"] = 2058.69, ["Mega|Ride"] = 1650.23, ["Mega|Fly|Ride"] = 1645.07}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 5.25, ["Neon"] = 38.07, ["Neon|Ride"] = 88.71, ["Neon|Fly|Ride"] = 169.32, ["Mega"] = 138.22, ["Mega|Ride"] = 275.39, ["Mega|Fly|Ride"] = 256.67}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 3.92, ["Ride"] = 19.68, ["Fly|Ride"] = 78.75, ["Neon"] = 63, ["Neon|Ride"] = 138.21, ["Neon|Fly|Ride"] = 136.16, ["Mega"] = 350.44, ["Mega|Ride"] = 381.63, ["Mega|Fly|Ride"] = 686.93}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 137.82, ["Fly"] = 382.05, ["Ride"] = 160.12, ["Fly|Ride"] = 275.39, ["Neon"] = 590.76, ["Neon|Ride"] = 559.17, ["Neon|Fly|Ride"] = 723.19, ["Mega"] = 2327.07, ["Mega|Fly|Ride"] = 1945.13}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 3.94, ["Fly"] = 36.75, ["Ride"] = 17.72, ["Fly|Ride"] = 48.49, ["Neon"] = 10.5, ["Neon|Fly"] = 57.53, ["Neon|Ride"] = 33.12, ["Neon|Fly|Ride"] = 73.5, ["Mega"] = 124.69, ["Mega|Ride"] = 233.17, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 11.5, ["Fly"] = 195.43, ["Ride"] = 34.35, ["Fly|Ride"] = 67.57, ["Neon"] = 82.24, ["Neon|Ride"] = 101.09, ["Neon|Fly|Ride"] = 206.29, ["Mega"] = 506.24, ["Mega|Ride"] = 453.75, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 18.89, ["Ride"] = 14.67, ["Fly|Ride"] = 70.16, ["Neon"] = 2.1, ["Neon|Fly"] = 26.56, ["Neon|Ride"] = 14.34, ["Neon|Fly|Ride"] = 44.63, ["Mega"] = 15.16, ["Mega|Ride"] = 27.87, ["Mega|Fly|Ride"] = 77.24}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Fly|Ride"] = 39.38, ["Neon"] = 2.43, ["Neon|Ride"] = 41.27, ["Mega"] = 19.19, ["Mega|Fly"] = 104.98, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 159.88}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.1, ["Fly"] = 35.09, ["Ride"] = 18.38, ["Fly|Ride"] = 96.87, ["Neon"] = 15.65, ["Neon|Ride"] = 64.98, ["Mega"] = 156.22, ["Mega|Ride"] = 261.47, ["Mega|Fly|Ride"] = 242.82}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 26.24, ["Ride"] = 52.49, ["Fly|Ride"] = 131.25, ["Neon"] = 118.02, ["Neon|Ride"] = 349.77, ["Neon|Fly|Ride"] = 433.13, ["Mega"] = 423.01, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 668.35}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.1, ["Fly"] = 15.6, ["Ride"] = 15.75, ["Fly|Ride"] = 34.13, ["Neon"] = 11.67, ["Neon|Fly"] = 25.83, ["Neon|Ride"] = 29.94, ["Neon|Fly|Ride"] = 54.51, ["Mega"] = 104.9, ["Mega|Fly"] = 170.62, ["Mega|Ride"] = 411.54, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 5.25, ["Fly"] = 39.37, ["Ride"] = 24.43, ["Fly|Ride"] = 66.93, ["Neon"] = 21.29, ["Neon|Fly"] = 55.86, ["Neon|Ride"] = 31.4, ["Neon|Fly|Ride"] = 118.02, ["Mega"] = 238.38, ["Mega|Fly"] = 412.56, ["Mega|Ride"] = 212.08, ["Mega|Fly|Ride"] = 272.32}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.63, ["Fly"] = 22.23, ["Ride"] = 18.09, ["Fly|Ride"] = 82.53, ["Neon"] = 8.86, ["Neon|Fly"] = 98.43, ["Neon|Ride"] = 24.76, ["Neon|Fly|Ride"] = 89.23, ["Mega"] = 76.19, ["Mega|Fly"] = 220.5, ["Mega|Ride"] = 86.65, ["Mega|Fly|Ride"] = 151.52}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 10.5, ["Fly"] = 169.32, ["Ride"] = 23.54, ["Fly|Ride"] = 196.88, ["Neon"] = 30.19, ["Neon|Ride"] = 89.78, ["Neon|Fly|Ride"] = 275.39, ["Mega"] = 255.8, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 5.25, ["Ride"] = 137.94, ["Neon"] = 65.63, ["Neon|Ride"] = 262.4, ["Mega"] = 446.25, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 2.61, ["Fly"] = 42, ["Ride"] = 15.75, ["Fly|Ride"] = 44.91, ["Neon"] = 26.23, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 111.63, ["Mega"] = 249.38, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 418.28}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 23.12, ["Ride"] = 17.06, ["Fly|Ride"] = 34.83, ["Neon"] = 15.31, ["Neon|Fly"] = 46.66, ["Neon|Ride"] = 31.43, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 233.17, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 232.32}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 196.87, ["Fly"] = 393.75, ["Ride"] = 311.34, ["Fly|Ride"] = 466.41, ["Neon"] = 1195.39, ["Neon|Ride"] = 1364.05, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 3937.5}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 4.27, ["Ride"] = 106.23, ["Neon"] = 109.51, ["Mega"] = 118.13, ["Mega|Ride"] = 420.6, ["Mega|Fly|Ride"] = 481.67}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 2.63, ["Fly"] = 103.16, ["Ride"] = 15.75, ["Fly|Ride"] = 79.07, ["Neon"] = 21.25, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 204.35, ["Mega|Ride"] = 321.81, ["Mega|Fly|Ride"] = 316.65}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 5.71, ["Neon"] = 36.63, ["Neon|Ride"] = 218.67, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 603.74, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 549.29}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 15.41, ["Ride"] = 13.42, ["Fly|Ride"] = 26.17, ["Neon"] = 2.63, ["Neon|Fly"] = 28.87, ["Neon|Ride"] = 15.65, ["Neon|Fly|Ride"] = 34.65, ["Mega"] = 18.26, ["Mega|Fly"] = 162.75, ["Mega|Ride"] = 131, ["Mega|Fly|Ride"] = 98.43}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 3.93, ["Fly"] = 32.82, ["Ride"] = 30.7, ["Fly|Ride"] = 110.25, ["Neon"] = 11.82, ["Neon|Ride"] = 23.5, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 97.46, ["Mega|Ride"] = 135.8, ["Mega|Fly|Ride"] = 211.83}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 3.82, ["Ride"] = 144.38, ["Neon"] = 15.61, ["Neon|Ride"] = 275.39, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 124.74, ["Mega|Ride"] = 412.56, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 82.69, ["Ride"] = 94.5, ["Fly|Ride"] = 157.5, ["Neon"] = 622.65, ["Neon|Ride"] = 434.44, ["Neon|Fly|Ride"] = 618.84, ["Mega"] = 2062.78, ["Mega|Ride"] = 3439.68, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 2.1, ["Fly"] = 96.96, ["Ride"] = 28.88, ["Fly|Ride"] = 262.49, ["Neon"] = 22.32, ["Neon|Fly|Ride"] = 412.56, ["Mega"] = 157.49, ["Mega|Ride"] = 264.64, ["Mega|Fly|Ride"] = 555.93}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.14, ["Fly"] = 20.99, ["Ride"] = 55.7, ["Neon"] = 23.61, ["Neon|Ride"] = 62.97, ["Neon|Fly|Ride"] = 523.43, ["Mega"] = 66.94, ["Mega|Fly"] = 314.99, ["Mega|Fly|Ride"] = 918.62}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 76.34, ["Fly"] = 210, ["Ride"] = 104.9, ["Fly|Ride"] = 206.29, ["Neon"] = 165.04, ["Neon|Ride"] = 165.04, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 636.57, ["Mega|Ride"] = 422.63, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 10.5, ["Ride"] = 14.43, ["Fly|Ride"] = 22.8, ["Neon"] = 2.1, ["Neon|Fly"] = 30.95, ["Neon|Ride"] = 17.56, ["Neon|Fly|Ride"] = 32.82, ["Mega"] = 17.8, ["Mega|Fly"] = 49.87, ["Mega|Ride"] = 35.43, ["Mega|Fly|Ride"] = 112.77}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Neon"] = 3.81, ["Neon|Fly"] = 31.99, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 209.36, ["Mega"] = 48.26, ["Mega|Ride"] = 102.13, ["Mega|Fly|Ride"] = 198.91}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.35, ["Ride"] = 107.63, ["Neon"] = 10.5, ["Neon|Fly"] = 45.93, ["Neon|Ride"] = 136.83, ["Neon|Fly|Ride"] = 181.55, ["Mega"] = 91.88, ["Mega|Fly"] = 179.48, ["Mega|Ride"] = 123.8, ["Mega|Fly|Ride"] = 185.07}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 6.6, ["Fly"] = 77.17, ["Ride"] = 35.09, ["Fly|Ride"] = 236.25, ["Neon"] = 23.12, ["Neon|Fly"] = 91.55, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 141.45, ["Mega"] = 110.14, ["Mega|Fly"] = 206.29, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 254.63}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 55.71, ["Ride"] = 15.49, ["Fly|Ride"] = 26.92, ["Neon"] = 2.1, ["Neon|Fly"] = 25.65, ["Neon|Ride"] = 24.96, ["Neon|Fly|Ride"] = 59.76, ["Mega"] = 18.04, ["Mega|Ride"] = 52.41, ["Mega|Fly|Ride"] = 118.12}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 23.31, ["Fly"] = 131.25, ["Ride"] = 123.78, ["Neon"] = 129.94, ["Neon|Fly"] = 412.56, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 656.25, ["Mega|Ride"] = 525}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2610.56, ["Ride"] = 2493.74, ["Fly|Ride"] = 2598.75, ["Neon|Fly|Ride"] = 9688.21, ["Mega|Fly|Ride"] = 36097.41}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.75, ["Fly|Ride"] = 43.43, ["Neon"] = 7.87, ["Neon|Fly"] = 56.83, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 69.71, ["Mega"] = 73.41, ["Mega|Ride"] = 124.69, ["Mega|Fly|Ride"] = 177.19}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 3.93, ["Neon"] = 5.24, ["Mega"] = 140.37, ["Mega|Fly"] = 441, ["Mega|Ride"] = 156.22, ["Mega|Fly|Ride"] = 192.31}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 14.77, ["Fly"] = 110.37, ["Ride"] = 30.34, ["Fly|Ride"] = 68.09, ["Neon"] = 84.08, ["Neon|Ride"] = 138.22, ["Neon|Fly|Ride"] = 292.37, ["Mega"] = 459.38, ["Mega|Ride"] = 687.94}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 24.93, ["Ride"] = 43.29, ["Neon"] = 187.69, ["Mega"] = 1237.57, ["Mega|Ride"] = 757.05, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 150.82, ["Fly"] = 1375.88, ["Ride"] = 197.88, ["Fly|Ride"] = 251.98, ["Neon"] = 1312.5, ["Neon|Ride"] = 700.41, ["Neon|Fly|Ride"] = 825.12, ["Mega"] = 6188.32, ["Mega|Fly|Ride"] = 2797.76}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 4.2, ["Ride"] = 28.88, ["Fly|Ride"] = 675.94, ["Neon"] = 15.75, ["Neon|Ride"] = 156.23, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 156.19, ["Mega|Ride"] = 247.54, ["Mega|Fly|Ride"] = 582.75}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Fly|Ride"] = 69.12, ["Neon"] = 18.38, ["Neon|Ride"] = 114.85, ["Mega"] = 140.44, ["Mega|Fly|Ride"] = 828.85}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 131.25, ["Neon"] = 6.69, ["Neon|Fly"] = 84.13, ["Neon|Ride"] = 47.46, ["Mega"] = 137.82, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 13.12, ["Ride"] = 101.09, ["Neon"] = 180.07, ["Neon|Ride"] = 1169.35, ["Mega"] = 374.07, ["Mega|Ride"] = 453.96, ["Mega|Fly|Ride"] = 809.17}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 41.27, ["Neon"] = 2.1, ["Neon|Ride"] = 28.29, ["Mega"] = 15.75, ["Mega|Fly"] = 116.43, ["Mega|Ride"] = 94.8, ["Mega|Fly|Ride"] = 275.39}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 91.77, ["Fly"] = 206.29, ["Ride"] = 87.94, ["Fly|Ride"] = 309.41, ["Neon"] = 515.71, ["Neon|Ride"] = 401.06, ["Neon|Fly|Ride"] = 514.15, ["Mega"] = 2062.78, ["Mega|Fly|Ride"] = 2491.13}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 91.82, ["Neon"] = 10.4, ["Neon|Ride"] = 142.35, ["Neon|Fly|Ride"] = 206.29, ["Mega"] = 69.96, ["Mega|Ride"] = 386.54}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 43.28, ["Fly"] = 218.06, ["Ride"] = 81.27, ["Fly|Ride"] = 157.46, ["Neon"] = 295.32, ["Neon|Ride"] = 416.5, ["Neon|Fly|Ride"] = 381.63, ["Mega"] = 2625, ["Mega|Fly|Ride"] = 2590.88}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 60.86, ["Ride"] = 31.99, ["Fly|Ride"] = 50.7, ["Neon"] = 5.25, ["Neon|Fly"] = 87.45, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 83.99, ["Mega"] = 54.57, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 177.14}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 4.14, ["Neon"] = 10.32, ["Neon|Ride"] = 98.44, ["Mega"] = 65.51, ["Mega|Ride"] = 152.25, ["Mega|Fly|Ride"] = 461.45}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 6.18, ["Fly"] = 77.43, ["Ride"] = 39.38, ["Fly|Ride"] = 206.29, ["Neon"] = 66.89, ["Neon|Ride"] = 103.16, ["Mega"] = 232.89, ["Mega|Fly|Ride"] = 550.77}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 370.13, ["Ride"] = 437.75, ["Fly|Ride"] = 535.42, ["Neon"] = 1050, ["Neon|Ride"] = 1050, ["Neon|Fly|Ride"] = 1443.75, ["Mega|Ride"] = 4593.75, ["Mega|Fly|Ride"] = 4289.25}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 37.9, ["Ride"] = 54.52, ["Fly|Ride"] = 97.93, ["Neon"] = 190.2, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 288.81, ["Mega|Fly|Ride"] = 1995}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.63, ["Fly"] = 47.38, ["Ride"] = 17.31, ["Fly|Ride"] = 57.75, ["Neon"] = 6.03, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 53.81, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 111.57, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 229.69}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 12.47, ["Fly"] = 111.57, ["Ride"] = 43.43, ["Fly|Ride"] = 111.57, ["Neon"] = 65.63, ["Neon|Fly"] = 466.41, ["Neon|Ride"] = 115.49, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 311.84, ["Mega|Fly"] = 959.42, ["Mega|Ride"] = 341.81, ["Mega|Fly|Ride"] = 400.94}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 5.25, ["Ride"] = 20.75, ["Fly|Ride"] = 82.53, ["Neon"] = 137.94, ["Neon|Ride"] = 91.87, ["Neon|Fly|Ride"] = 264.66, ["Mega"] = 275.39, ["Mega|Ride"] = 659.08, ["Mega|Fly|Ride"] = 550.77}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.81, ["Neon"] = 13.12, ["Mega"] = 65.63, ["Mega|Ride"] = 131.25}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 17.51, ["Fly|Ride"] = 57.78, ["Neon"] = 65.63, ["Neon|Ride"] = 32.79, ["Neon|Fly|Ride"] = 270.23, ["Mega"] = 544.41, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 90.18, ["Ride"] = 117.5, ["Fly|Ride"] = 224.43, ["Neon"] = 729.21, ["Neon|Ride"] = 582.65, ["Neon|Fly|Ride"] = 568.5, ["Mega"] = 3439.68, ["Mega|Fly|Ride"] = 2928.11}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 25.35, ["Ride"] = 78.14, ["Fly|Ride"] = 85.32, ["Neon"] = 142.95, ["Neon|Ride"] = 206.29, ["Neon|Fly|Ride"] = 389.73, ["Mega"] = 1031.4, ["Mega|Ride"] = 895.27, ["Mega|Fly|Ride"] = 665.44}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2231.25, ["Ride"] = 2475.34, ["Fly|Ride"] = 2327.93, ["Neon"] = 11001.78, ["Neon|Fly|Ride"] = 6424.69, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 3.56, ["Fly"] = 65625, ["Ride"] = 115.12, ["Fly|Ride"] = 196.87, ["Neon"] = 13.13, ["Neon|Fly|Ride"] = 105, ["Mega"] = 95.82, ["Mega|Fly"] = 786.19, ["Mega|Ride"] = 167.35, ["Mega|Fly|Ride"] = 451.16}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 4.41, ["Ride"] = 31.5, ["Fly|Ride"] = 127.91, ["Neon"] = 32.82, ["Neon|Ride"] = 118.94, ["Neon|Fly|Ride"] = 232.32, ["Mega"] = 544.41, ["Mega|Ride"] = 198.19, ["Mega|Fly|Ride"] = 1031.4}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 1047.81, ["Ride"] = 879.27, ["Fly|Ride"] = 987, ["Neon"] = 2778.57, ["Neon|Ride"] = 2611.88, ["Neon|Fly|Ride"] = 3110.63, ["Mega"] = 11826.89, ["Mega|Fly|Ride"] = 11138.95}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 30.19, ["Ride"] = 52.49, ["Fly|Ride"] = 173.35, ["Neon"] = 182.27, ["Neon|Ride"] = 206.29, ["Mega"] = 840, ["Mega|Ride"] = 636.48, ["Mega|Fly|Ride"] = 1649.2}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 2.63, ["Ride"] = 23.58, ["Fly|Ride"] = 128.14, ["Neon"] = 15.41, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 175.88, ["Mega|Ride"] = 307.37, ["Mega|Fly|Ride"] = 550.77}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 111.45, ["Ride"] = 138.22, ["Neon"] = 2.83, ["Neon|Ride"] = 55.44, ["Neon|Fly|Ride"] = 78.4, ["Mega"] = 39.38, ["Mega|Ride"] = 251.68, ["Mega|Fly|Ride"] = 275.39}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 85.24, ["Ride"] = 129.94, ["Fly|Ride"] = 170.63, ["Neon"] = 412.56, ["Neon|Fly|Ride"] = 603.75, ["Mega"] = 8251.08, ["Mega|Fly|Ride"] = 5349.54}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 2.52, ["Fly|Ride"] = 73.12, ["Neon"] = 12.5, ["Neon|Ride"] = 52.02, ["Neon|Fly|Ride"] = 275.39, ["Mega"] = 159.41, ["Mega|Ride"] = 262.48, ["Mega|Fly|Ride"] = 305.82}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 76.04, ["Ride"] = 152.66, ["Neon"] = 393.75, ["Neon|Ride"] = 411.54, ["Neon|Fly|Ride"] = 506.42}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 2.96, ["Fly"] = 105, ["Fly|Ride"] = 110.37, ["Neon"] = 26.2, ["Neon|Fly|Ride"] = 315, ["Mega"] = 161.47, ["Mega|Ride"] = 164.07}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 262.48, ["Ride"] = 307.13, ["Fly|Ride"] = 334.69, ["Neon"] = 1498.88, ["Neon|Ride"] = 853.13, ["Neon|Fly|Ride"] = 879.03, ["Mega|Fly|Ride"] = 3899.56}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 2.1, ["Fly"] = 91.88, ["Ride"] = 19.62, ["Fly|Ride"] = 103.94, ["Neon"] = 156.26, ["Neon|Fly"] = 156.26, ["Neon|Ride"] = 57.75, ["Neon|Fly|Ride"] = 100.16, ["Mega"] = 210, ["Mega|Ride"] = 649.67, ["Mega|Fly|Ride"] = 390.32}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 12.35, ["Fly|Ride"] = 28.24, ["Neon"] = 4.2, ["Neon|Fly"] = 31.39, ["Neon|Ride"] = 21.38, ["Neon|Fly|Ride"] = 48.57, ["Mega"] = 52.5, ["Mega|Fly"] = 136.14, ["Mega|Ride"] = 115.49, ["Mega|Fly|Ride"] = 179.23}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 1235.52, ["Ride"] = 1050, ["Fly|Ride"] = 1254.19, ["Neon|Ride"] = 7564.18, ["Neon|Fly|Ride"] = 5913.97, ["Mega"] = 22848.32}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 7.06, ["Fly"] = 963.33, ["Ride"] = 72.19, ["Neon"] = 42.77, ["Neon|Ride"] = 311.76, ["Mega"] = 308.42, ["Mega|Ride"] = 412.56, ["Mega|Fly|Ride"] = 614.36}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 7.88, ["Fly"] = 49.51, ["Ride"] = 45.28, ["Fly|Ride"] = 79.49, ["Neon"] = 25.73, ["Neon|Fly"] = 156.26, ["Neon|Ride"] = 57.28, ["Neon|Fly|Ride"] = 162.98, ["Mega"] = 179.82, ["Mega|Ride"] = 203.34, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 34.12, ["Fly"] = 32.82, ["Ride"] = 39.38, ["Fly|Ride"] = 82.69, ["Neon|Ride"] = 196.85, ["Neon|Fly|Ride"] = 189.63, ["Mega|Fly|Ride"] = 798}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 11.45, ["Fly"] = 82.53, ["Ride"] = 24.86, ["Fly|Ride"] = 89.56, ["Neon"] = 52.41, ["Neon|Ride"] = 78.12, ["Neon|Fly|Ride"] = 179.79, ["Mega"] = 367.5, ["Mega|Fly"] = 470.33, ["Mega|Ride"] = 357.9, ["Mega|Fly|Ride"] = 495.08}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 39.38, ["Ride"] = 109.61, ["Fly|Ride"] = 408.44, ["Neon"] = 128.63, ["Neon|Ride"] = 376.69, ["Mega"] = 622.51, ["Mega|Ride"] = 654.94, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 116.61, ["Fly|Ride"] = 78.14, ["Neon"] = 2.1, ["Neon|Fly"] = 55.71, ["Neon|Ride"] = 109.61, ["Mega"] = 18.05, ["Mega|Ride"] = 79.36, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 57.74, ["Fly"] = 116.55, ["Ride"] = 71.33, ["Fly|Ride"] = 140.31, ["Neon"] = 446.22, ["Neon|Fly"] = 663.58, ["Neon|Ride"] = 393.74, ["Neon|Fly|Ride"] = 456.75, ["Mega"] = 3300.45, ["Mega|Ride"] = 1697.67, ["Mega|Fly|Ride"] = 1505.83}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 3.49, ["Fly"] = 91.4, ["Ride"] = 23.63, ["Fly|Ride"] = 110.37, ["Neon"] = 65.63, ["Mega"] = 773.06, ["Mega|Ride"] = 386.54}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 20.95, ["Ride"] = 15.65, ["Fly|Ride"] = 36.26, ["Neon"] = 16.38, ["Neon|Fly"] = 78.14, ["Neon|Ride"] = 55.71, ["Neon|Fly|Ride"] = 122.85, ["Mega|Ride"] = 271.27, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 3.93, ["Ride"] = 125.99, ["Neon"] = 20.13, ["Neon|Fly"] = 136.16, ["Neon|Fly|Ride"] = 184.64, ["Mega"] = 327.99, ["Mega|Fly|Ride"] = 466.31}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 57.75, ["Ride"] = 154.72, ["Fly|Ride"] = 262.5, ["Neon"] = 262.49, ["Neon|Ride"] = 414.78, ["Neon|Fly|Ride"] = 550.77, ["Mega|Ride"] = 1454.94, ["Mega|Fly|Ride"] = 1199.69}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 3.84, ["Neon"] = 23.63, ["Neon|Ride"] = 77.38, ["Mega"] = 122.05, ["Mega|Fly|Ride"] = 290.15}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Neon"] = 2.1, ["Neon|Ride"] = 52.5, ["Mega"] = 17.07, ["Mega|Ride"] = 40.28, ["Mega|Fly|Ride"] = 412.55}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 102.94, ["Ride"] = 35.09, ["Fly|Ride"] = 39.41, ["Neon"] = 2.61, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 165.04, ["Mega"] = 17.46, ["Mega|Ride"] = 51.59, ["Mega|Fly|Ride"] = 137.06}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 19.67, ["Fly|Ride"] = 49.43, ["Neon"] = 5.25, ["Neon|Ride"] = 26.81, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 63, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 183.74}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.23, ["Ride"] = 28.88, ["Fly|Ride"] = 65.63, ["Neon"] = 39.37, ["Mega"] = 118.09, ["Mega|Ride"] = 106.3, ["Mega|Fly|Ride"] = 279.79}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 38.04, ["Ride"] = 15.41, ["Fly|Ride"] = 32.37, ["Neon"] = 14.6, ["Neon|Fly"] = 206.19, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 209.35, ["Mega|Fly|Ride"] = 451.5}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 57.66, ["Ride"] = 91.62, ["Fly|Ride"] = 220.73, ["Neon"] = 196.88, ["Neon|Ride"] = 275.39, ["Neon|Fly|Ride"] = 1031.4, ["Mega"] = 694.32, ["Mega|Ride"] = 971.25, ["Mega|Fly|Ride"] = 1079.88}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 14.44, ["Ride"] = 14.55, ["Fly|Ride"] = 35.43, ["Neon"] = 2.52, ["Neon|Fly"] = 32.8, ["Neon|Ride"] = 17.05, ["Neon|Fly|Ride"] = 46.2, ["Mega"] = 24.94, ["Mega|Fly|Ride"] = 104.67}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 6.4, ["Fly"] = 80.47, ["Ride"] = 23.52, ["Fly|Ride"] = 68.37, ["Neon"] = 26.19, ["Neon|Fly"] = 82.91, ["Neon|Ride"] = 48.57, ["Neon|Fly|Ride"] = 119.66, ["Mega"] = 397.87, ["Mega|Ride"] = 278.11, ["Mega|Fly|Ride"] = 478.57}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 14.2, ["Fly"] = 44.7, ["Ride"] = 28.59, ["Fly|Ride"] = 83.91, ["Neon"] = 118.13, ["Neon|Fly"] = 174.49, ["Neon|Ride"] = 144.37, ["Neon|Fly|Ride"] = 195.57, ["Mega"] = 787.5, ["Mega|Ride"] = 590.52, ["Mega|Fly|Ride"] = 618.84}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 13.12, ["Fly"] = 196.88, ["Neon"] = 42, ["Mega"] = 366.19, ["Mega|Ride"] = 399.16, ["Mega|Fly|Ride"] = 412.56}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 27.84, ["Ride"] = 14.49, ["Fly|Ride"] = 51.58, ["Neon"] = 2.63, ["Neon|Fly"] = 24.76, ["Neon|Ride"] = 19.59, ["Neon|Fly|Ride"] = 66.89, ["Mega"] = 67.97, ["Mega|Ride"] = 140.35, ["Mega|Fly|Ride"] = 122.07}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 3.5, ["Fly"] = 76.34, ["Ride"] = 38.07, ["Neon"] = 21.39, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 129.97, ["Mega"] = 247.54, ["Mega|Fly"] = 735, ["Mega|Ride"] = 224.1, ["Mega|Fly|Ride"] = 385.75}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 977.82, ["Fly"] = 1322.25, ["Ride"] = 976.5, ["Fly|Ride"] = 1107.75, ["Neon|Ride"] = 2231.25, ["Neon|Fly|Ride"] = 2067.19, ["Mega|Fly|Ride"] = 6929.9}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 94.9, ["Ride"] = 157.5, ["Fly|Ride"] = 380.63, ["Neon"] = 571.1, ["Neon|Ride"] = 506.42, ["Neon|Fly|Ride"] = 811.72, ["Mega"] = 6188.32, ["Mega|Ride"] = 2613.55, ["Mega|Fly|Ride"] = 2074.64}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Neon"] = 6.14, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 206.29, ["Mega"] = 89.25, ["Mega|Fly|Ride"] = 1100.5}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 79.96, ["Ride"] = 139.94, ["Fly|Ride"] = 196.88, ["Neon"] = 367.5, ["Neon|Ride"] = 367.49, ["Neon|Fly|Ride"] = 551.25, ["Mega"] = 1575, ["Mega|Ride"] = 1706.25, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 2.62, ["Ride"] = 19.13, ["Fly|Ride"] = 89.75, ["Neon"] = 18.36, ["Neon|Fly"] = 54.81, ["Neon|Ride"] = 47.31, ["Neon|Fly|Ride"] = 275.39, ["Mega"] = 274.02, ["Mega|Ride"] = 306.9, ["Mega|Fly|Ride"] = 399.16}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 296.63, ["Fly"] = 412.56, ["Ride"] = 328.13, ["Fly|Ride"] = 378, ["Neon|Ride"] = 1224.27, ["Neon|Fly|Ride"] = 1430.55, ["Mega|Fly|Ride"] = 4528.13}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 76.4, ["Ride"] = 52.5, ["Fly|Ride"] = 210.96, ["Neon"] = 31.39, ["Neon|Ride"] = 54.37, ["Mega"] = 412.29, ["Mega|Fly"] = 321.81, ["Mega|Ride"] = 622.51}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Neon"] = 27.72, ["Mega"] = 330.05, ["Mega|Ride"] = 353.78}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 18.38, ["Ride"] = 275.39, ["Fly|Ride"] = 196.88, ["Neon"] = 152.66, ["Neon|Ride"] = 124.59, ["Mega"] = 945, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.63, ["Ride"] = 49.73, ["Neon"] = 25.25, ["Neon|Ride"] = 141.91, ["Mega"] = 241.37, ["Mega|Ride"] = 253.3, ["Mega|Fly|Ride"] = 455.82}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 15.11, ["Ride"] = 13, ["Fly|Ride"] = 39.35, ["Neon"] = 2.63, ["Neon|Fly"] = 23.63, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 37.54, ["Mega"] = 164.73, ["Mega|Ride"] = 32.82, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4593.75, ["Ride"] = 5118.75, ["Fly|Ride"] = 4516.32, ["Neon"] = 30941.52, ["Neon|Fly|Ride"] = 18414.38, ["Mega|Fly|Ride"] = 128922.97}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 7.33, ["Ride"] = 41.57, ["Neon"] = 52.5, ["Neon|Ride"] = 106.32, ["Mega"] = 311.27, ["Mega|Ride"] = 302.57, ["Mega|Fly|Ride"] = 412.56}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 24.7, ["Ride"] = 16.49, ["Fly|Ride"] = 51.19, ["Neon"] = 17.07, ["Neon|Fly"] = 45.91, ["Neon|Ride"] = 34.18, ["Neon|Fly|Ride"] = 80.53, ["Mega"] = 144.38, ["Mega|Ride"] = 173.29, ["Mega|Fly|Ride"] = 242.18}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 501.44, ["Fly"] = 598.22, ["Ride"] = 654.94, ["Fly|Ride"] = 559.13, ["Neon"] = 2099.99, ["Neon|Ride"] = 1512.03, ["Neon|Fly|Ride"] = 1744.43, ["Mega|Fly|Ride"] = 5899.52}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 4.64, ["Ride"] = 32.62, ["Neon"] = 19.14, ["Neon|Ride"] = 145.69, ["Mega"] = 185.97, ["Mega|Fly|Ride"] = 687.94}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 3.4, ["Fly"] = 4292.53, ["Ride"] = 46.66, ["Neon"] = 23.26, ["Neon|Ride"] = 62.97, ["Neon|Fly|Ride"] = 280.54, ["Mega"] = 410.51, ["Mega|Ride"] = 401.62, ["Mega|Fly|Ride"] = 275.39}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 52.47, ["Ride"] = 18.53, ["Neon"] = 3.81, ["Neon|Fly"] = 124.69, ["Neon|Ride"] = 20.99, ["Neon|Fly|Ride"] = 91.74, ["Mega"] = 76.95, ["Mega|Ride"] = 78.07, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 909.57, ["Ride"] = 918.75, ["Fly|Ride"] = 918.75, ["Neon|Ride"] = 3281.25, ["Neon|Fly|Ride"] = 2455.63}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 6.74, ["Ride"] = 73.92, ["Fly|Ride"] = 412.56, ["Neon"] = 35.43, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 275.39, ["Mega"] = 156.19, ["Mega|Ride"] = 192.88, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 15.73, ["Fly"] = 236.15, ["Ride"] = 30.18, ["Fly|Ride"] = 110.37, ["Neon"] = 27.84, ["Neon|Ride"] = 54.8, ["Neon|Fly|Ride"] = 216.61, ["Mega"] = 198.93, ["Mega|Fly"] = 777.55, ["Mega|Ride"] = 223.57, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 34.1, ["Ride"] = 16.49, ["Fly|Ride"] = 59.07, ["Neon"] = 6.57, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 30.75, ["Neon|Fly|Ride"] = 74.82, ["Mega"] = 275.39, ["Mega|Ride"] = 192.88, ["Mega|Fly|Ride"] = 215.1}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 20.1, ["Ride"] = 34.12, ["Fly|Ride"] = 52.5, ["Neon"] = 118.13, ["Neon|Fly|Ride"] = 309.43, ["Mega"] = 557.82, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 742.61}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Fly|Ride"] = 412.56, ["Neon"] = 3.94, ["Neon|Ride"] = 45.23, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 53.81, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 548.63, ["Fly"] = 662.17, ["Ride"] = 538.12, ["Fly|Ride"] = 687.94, ["Neon"] = 2589.57, ["Neon|Fly|Ride"] = 2367.46, ["Mega|Fly|Ride"] = 7861.88}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.63, ["Fly"] = 103.16, ["Ride"] = 96.96, ["Fly|Ride"] = 311.34, ["Neon"] = 15.53, ["Neon|Ride"] = 84.4, ["Neon|Fly|Ride"] = 150.6, ["Mega"] = 97.13, ["Mega|Ride"] = 241.37, ["Mega|Fly|Ride"] = 357.9}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 14.44, ["Neon"] = 6.35, ["Neon|Fly"] = 234.14, ["Neon|Ride"] = 209.87, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 87.45, ["Mega|Ride"] = 137.82, ["Mega|Fly|Ride"] = 348.63}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 49.44, ["Fly|Ride"] = 76.34, ["Neon"] = 3.93, ["Neon|Ride"] = 44.12, ["Neon|Fly|Ride"] = 138.22, ["Mega"] = 101.07, ["Mega|Fly"] = 152.66, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 145.68}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Neon"] = 15.49, ["Mega"] = 206.29, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 33.26, ["Fly"] = 98.44, ["Ride"] = 59.84, ["Fly|Ride"] = 138.22, ["Neon"] = 129.94, ["Neon|Ride"] = 137.22, ["Neon|Fly|Ride"] = 274.37, ["Mega"] = 1513.05, ["Mega|Ride"] = 967.32, ["Mega|Fly|Ride"] = 825.12}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 16.95, ["Ride"] = 57.35, ["Fly|Ride"] = 190.32, ["Neon"] = 90.18, ["Neon|Ride"] = 141.75, ["Neon|Fly|Ride"] = 247.54, ["Mega"] = 477.23, ["Mega|Fly"] = 550.77, ["Mega|Ride"] = 462.81, ["Mega|Fly|Ride"] = 572.25}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly"] = 19.59, ["Ride"] = 14.11, ["Fly|Ride"] = 31.49, ["Neon"] = 26.83, ["Neon|Ride"] = 36.68, ["Neon|Fly|Ride"] = 70.88, ["Mega"] = 299.92, ["Mega|Ride"] = 275.39, ["Mega|Fly|Ride"] = 235.17}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 9.18, ["Ride"] = 101.46, ["Neon"] = 89.25, ["Neon|Ride"] = 136.16, ["Mega"] = 311.27, ["Mega|Ride"] = 309.43}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Ride"] = 20.63, ["Fly|Ride"] = 111.55, ["Neon"] = 12.94, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 153.9, ["Mega"] = 103.95, ["Mega|Ride"] = 115.49, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 19.31, ["Ride"] = 19.69, ["Fly|Ride"] = 77.42, ["Neon"] = 209.99, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 189.67, ["Mega"] = 927.23, ["Mega|Fly|Ride"] = 815.84}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 34.7, ["Fly"] = 874.13, ["Neon"] = 261.99, ["Mega"] = 517.77, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 622.79}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 56.59, ["Fly"] = 115.39, ["Ride"] = 77.16, ["Fly|Ride"] = 138.22, ["Neon"] = 183.75, ["Neon|Ride"] = 313.69, ["Neon|Fly|Ride"] = 364.41, ["Mega|Ride"] = 1648.36, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 42.08, ["Fly"] = 291.38, ["Ride"] = 76.56, ["Fly|Ride"] = 201.13, ["Neon"] = 138.22, ["Neon|Ride"] = 203.44, ["Neon|Fly|Ride"] = 577.11, ["Mega"] = 855.66, ["Mega|Ride"] = 550.77, ["Mega|Fly|Ride"] = 620.82}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 19.05, ["Ride"] = 56.44, ["Fly|Ride"] = 206.29, ["Neon"] = 152.66, ["Neon|Ride"] = 284.82, ["Mega"] = 1050, ["Mega|Ride"] = 777.55}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 12.93, ["Fly"] = 428.29, ["Ride"] = 57.21, ["Fly|Ride"] = 192.94, ["Neon"] = 126.37, ["Neon|Fly"] = 420, ["Neon|Ride"] = 134.09, ["Neon|Fly|Ride"] = 279.82, ["Mega"] = 531.74, ["Mega|Ride"] = 525.08, ["Mega|Fly|Ride"] = 714.08}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 17.91, ["Ride"] = 15.26, ["Fly|Ride"] = 32.72, ["Neon"] = 3.94, ["Neon|Fly"] = 26.75, ["Neon|Ride"] = 19.62, ["Neon|Fly|Ride"] = 43.67, ["Mega"] = 65.63, ["Mega|Fly"] = 156.22, ["Mega|Ride"] = 78.12, ["Mega|Fly|Ride"] = 395.73}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1890}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 58.95, ["Ride"] = 117.59, ["Fly|Ride"] = 315, ["Neon"] = 315.61, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 1513.05, ["Mega|Ride"] = 1088.81, ["Mega|Fly|Ride"] = 1210.85}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 79.73, ["Neon"] = 6.57, ["Neon|Ride"] = 43.18, ["Neon|Fly|Ride"] = 288.81, ["Mega"] = 39.38, ["Mega|Ride"] = 84.93, ["Mega|Fly|Ride"] = 197.02}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 27.48, ["Ride"] = 110.37, ["Fly|Ride"] = 138.22, ["Neon"] = 206.29, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 711.38, ["Mega|Ride"] = 652.82, ["Mega|Fly|Ride"] = 1236.64}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Ride"] = 65.63, ["Neon"] = 3.94, ["Mega"] = 23.63}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 3.72, ["Mega"] = 40.68, ["Mega|Ride"] = 151.41}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 110.37, ["Fly"] = 350.69, ["Ride"] = 118.13, ["Fly|Ride"] = 288.81, ["Neon"] = 582.75, ["Neon|Ride"] = 687.94, ["Neon|Fly|Ride"] = 771.49, ["Mega|Ride"] = 2544.44, ["Mega|Fly|Ride"] = 1903.89}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 35.07, ["Fly|Ride"] = 93.3, ["Neon"] = 9.19, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 99.74, ["Mega"] = 90.57, ["Mega|Ride"] = 96.95, ["Mega|Fly|Ride"] = 281.71}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 64.13, ["Fly|Ride"] = 86.63, ["Neon"] = 5.16, ["Neon|Ride"] = 40.63, ["Neon|Fly|Ride"] = 138.22, ["Mega"] = 32.82, ["Mega|Ride"] = 123.78}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 4.03, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 209.99, ["Mega"] = 52.5, ["Mega|Fly|Ride"] = 237.23}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 27.85, ["Neon"] = 5.39, ["Neon|Ride"] = 156.19, ["Mega"] = 82.23, ["Mega|Ride"] = 206.29}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 49.77, ["Ride"] = 135.19, ["Fly|Ride"] = 622.65, ["Neon"] = 424.07, ["Neon|Ride"] = 550.77, ["Neon|Fly|Ride"] = 963.33, ["Mega|Ride"] = 1547.1, ["Mega|Fly|Ride"] = 1513.05}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 6.54, ["Ride"] = 82.53, ["Neon"] = 77.9, ["Neon|Ride"] = 157.55, ["Mega"] = 465.15, ["Mega|Ride"] = 894.23, ["Mega|Fly|Ride"] = 545.74}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 410.51, ["Ride"] = 481.67, ["Fly|Ride"] = 750.92, ["Neon"] = 918.75, ["Neon|Ride"] = 1306.78, ["Neon|Fly|Ride"] = 1243.97, ["Mega|Fly|Ride"] = 4125.55}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 86.62}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 52.5}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 25.66}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 15.73}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 122.66}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 95.81}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 11.15}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 6.07}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 259.88}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 25.8}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 46.65}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 5.81}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 32.79}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 577.49}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 9.33}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 19.61}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 3.61}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 5.8}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 8.09}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 450.02}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 17.51}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1039.46}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.63}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 45.94}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 7.44}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 21.26}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.62}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 24.42}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 34.08}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 46.15}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 18.52}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 20.47}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 17.32}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 6.23}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 18.06}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.1}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 16.7}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 14.47}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 15.49}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 5.01}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 1968.75}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 33.66}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 275.63}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 3.46}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 5.24}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 8.96}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 6.57}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 46.49}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 193.17}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 7.87}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 6.55}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 1181.25}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 31.85}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 5.99}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 53.82}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 4.96}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 6.56}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 216.61}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 23.04}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 8.15}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.61}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 110.37}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 196.87}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 3.9}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 31.76}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.63}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 78.75}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 210}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 3.93}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 7.62}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 98.44}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 24.57}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 123.38}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 20.06}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.63}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22209.76}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 164.07}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 74.7}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 41.89}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 43.64}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 46.66}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 31.15}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 31.17}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 80.85}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 78.74}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 43.31}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 56.49}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 109.49}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 32.81}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 6910.29}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 6.13}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 7.86}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 11.81}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 23.56}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 44.36}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 109.61}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.1}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 3.57}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 3.92}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 8.67}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 755.54}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 9.8}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 583.75}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 12.55}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.6}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 606.33}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 30.84}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 115.31}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 19.69}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 45.05}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 11.81}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 13}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 7.59}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.1}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 4.2}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 2.67}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 28.88}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 5.23}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 2.47}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 10.34}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 26.25}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 263.82}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 48.49}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 3.97}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 1048.48}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 8.51}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 4.87}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 7.77}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 21.66}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 13.44}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 4.19}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 12.03}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 5.17}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 5.92}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 43.31}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 20.99}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 4.28}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 3.02}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 4.72}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 9.24}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 6.56}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 2.57}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 3.14}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.51}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 3.6}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 3.52}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 7838.53}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 8.27}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 17.67}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 2.14}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 6.56}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 9.11}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 9.19}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 2.46}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 7.34}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.3}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 30.18}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 6.5}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 3.61}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 2.2}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 2.35}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 6.2}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4314.18}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 8.02}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 32.1}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 3.31}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 2.1}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 58.15}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 65.63}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 4.01}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 105}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 10.69}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 3.44}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.1}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 2.1}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 7.07}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 38.93}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.55}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 15.54}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 2.46}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 2.82}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.14}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.62}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 4.87}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.43}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 28.29}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 3.51}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 3.94}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 8.56}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 78.66}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.51}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 61.85}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 4.11}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 2.15}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1041.29}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 27.46}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.51}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 5.01}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 4.45}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 7.88}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 5.24}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 3.82}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 10.31}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.63}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 8.99}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 20.65}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 6.99}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 3.5}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 2.3}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 6.45}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 6.85}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 18.59}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 3.19}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 3.94}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 6.57}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 17.75}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 47.88}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 3.39}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 3.84}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 26.17}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 61.69}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 18.38}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 6.2}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 43.55}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 26.4}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 3.91}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 2.15}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 4.72}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 3.03}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 3.48}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 74.42}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 142.95}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 3.89}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1187.71}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 3.61}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 247.54}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 196.88}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 58.28}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 3.24}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 2.35}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 3.47}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 32.61}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 15.31}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 7.7}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.43}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.63}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 3.83}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 5.37}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 66.32}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 2.16}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 61.01}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.62}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 20.77}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 6.28}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 20.9}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 153.59}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 6.07}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 74.85}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 5.24}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 3.5}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.52}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 4.53}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 57.73}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 45.39}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 64.43}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 227.95}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 3.66}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 151.1}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.51}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 3.94}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 6.47}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 22.32}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 63.95}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 3.63}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 51.58}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 2.15}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 46.55}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 13.34}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 56.84}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 24.9}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 62.84}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 47.43}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 5.24}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 26.11}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 3.93}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 10.39}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 47.16}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 43.05}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 34.55}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1783.42}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 9.16}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 6.12}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 19.65}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 327.31}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 17.94}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 38.07}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 10.21}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 6.28}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 8.38}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 275.62}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 50.61}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 41.42}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 5.25}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.14}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 6.2}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 525}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 165.27}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 63}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 1155}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 7.07}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 2338.17}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 551.24}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 4.6}},
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