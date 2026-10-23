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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 978.04, ["Ride"] = 1050, ["Fly|Ride"] = 1237.37, ["Neon"] = 6805.32, ["Neon|Ride"] = 6562.5, ["Neon|Fly|Ride"] = 4189.55, ["Mega|Fly|Ride"] = 20216.93}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 513.19, ["Ride"] = 564.04, ["Fly|Ride"] = 618.7, ["Neon|Fly|Ride"] = 2424.2, ["Mega"] = 11663.16, ["Mega|Fly|Ride"] = 6805.45}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 4948.13, ["Ride"] = 5117.44, ["Fly|Ride"] = 4689.57, ["Neon|Fly|Ride"] = 20897.88, ["Mega|Fly|Ride"] = 68742.21}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 164.9, ["Ride"] = 251.62, ["Fly|Ride"] = 275.63, ["Neon"] = 894.01, ["Neon|Ride"] = 824.92, ["Neon|Fly|Ride"] = 1025.99, ["Mega|Ride"] = 3889.68, ["Mega|Fly|Ride"] = 3937.49}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 632.63, ["Fly"] = 825.02, ["Ride"] = 615.09, ["Fly|Ride"] = 603.54, ["Neon|Fly|Ride"] = 1745.62, ["Mega|Fly|Ride"] = 6531.39}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 9.75, ["Ride"] = 41.27, ["Fly|Ride"] = 156.3, ["Neon"] = 39.38, ["Neon|Ride"] = 84.13, ["Neon|Fly|Ride"] = 404.25, ["Mega"] = 353.7, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 577.34}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 6.57, ["Fly"] = 42.24, ["Ride"] = 23.43, ["Fly|Ride"] = 68.36, ["Neon"] = 27.57, ["Neon|Fly"] = 78.16, ["Neon|Ride"] = 50.95, ["Neon|Fly|Ride"] = 111.37, ["Mega"] = 154.77, ["Mega|Ride"] = 279.93, ["Mega|Fly|Ride"] = 285.45}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 105, ["Fly"] = 206.27, ["Ride"] = 152.27, ["Fly|Ride"] = 240.19, ["Neon"] = 412.47, ["Neon|Ride"] = 493.5, ["Neon|Fly|Ride"] = 687.78}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 31.48, ["Fly"] = 97.75, ["Ride"] = 48.97, ["Fly|Ride"] = 99.06, ["Neon"] = 288.73, ["Neon|Ride"] = 237.93, ["Neon|Fly|Ride"] = 334.69, ["Mega"] = 2100, ["Mega|Fly|Ride"] = 1244.48}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 18.38, ["Fly"] = 69.47, ["Ride"] = 35.12, ["Fly|Ride"] = 69.5, ["Neon"] = 143.34, ["Neon|Ride"] = 284.61, ["Neon|Fly|Ride"] = 311.42, ["Mega|Fly|Ride"] = 754.81}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 57.74, ["Fly"] = 206.07, ["Ride"] = 90.53, ["Fly|Ride"] = 174.46, ["Neon"] = 436.21, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 416.07, ["Mega|Fly|Ride"] = 1237.37}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 67.2}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 350.34, ["Ride"] = 326.81, ["Fly|Ride"] = 395.03, ["Neon|Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 4878.28}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 138.21, ["Fly"] = 184.42, ["Ride"] = 135.77, ["Fly|Ride"] = 192.84, ["Neon|Fly|Ride"] = 656.15, ["Mega|Fly|Ride"] = 3025.34}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 3.72, ["Ride"] = 55.04, ["Fly|Ride"] = 131.25, ["Neon"] = 19.61, ["Neon|Fly"] = 96.94, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 131.25, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 311.41, ["Mega|Fly|Ride"] = 304.2}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 189.95, ["Fly"] = 204.45, ["Ride"] = 189.95, ["Fly|Ride"] = 234.94, ["Neon"] = 777.93, ["Neon|Fly|Ride"] = 590.63, ["Mega"] = 3574.93, ["Mega|Fly|Ride"] = 2730}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 2.98, ["Fly"] = 24.55, ["Ride"] = 20.65, ["Fly|Ride"] = 42, ["Neon"] = 35.07, ["Neon|Ride"] = 90.76, ["Neon|Fly|Ride"] = 108.96, ["Mega"] = 206.24, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 412.47}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 81.25, ["Fly"] = 223.13, ["Ride"] = 131.25, ["Fly|Ride"] = 199.34, ["Neon"] = 329.97, ["Neon|Ride"] = 396.57, ["Neon|Fly|Ride"] = 523.69, ["Mega"] = 1711, ["Mega|Ride"] = 1375.55, ["Mega|Fly|Ride"] = 1629.2}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 37.79}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 67.09, ["Ride"] = 101.07, ["Fly|Ride"] = 238.2, ["Neon"] = 577.5, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 1375.55}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 17.07, ["Fly"] = 393.75, ["Ride"] = 34.69, ["Fly|Ride"] = 129.93, ["Neon"] = 159.17, ["Neon|Ride"] = 209.99, ["Neon|Fly|Ride"] = 367.5, ["Mega|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 1649.82}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 41.9, ["Fly"] = 157.5, ["Ride"] = 59.07, ["Fly|Ride"] = 102.38, ["Neon"] = 255.94, ["Neon|Ride"] = 289.27, ["Neon|Fly|Ride"] = 301.87, ["Mega"] = 1632.86, ["Mega|Ride"] = 1375.55, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 39.25, ["Fly"] = 65.63, ["Ride"] = 157.5, ["Fly|Ride"] = 138.18, ["Neon"] = 209.9, ["Neon|Ride"] = 412.47, ["Neon|Fly|Ride"] = 467.25, ["Mega"] = 2047.5, ["Mega|Fly|Ride"] = 1260.05}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 22.31, ["Ride"] = 44.54, ["Fly|Ride"] = 138.18, ["Neon"] = 477.75, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 311.42, ["Mega"] = 822.86, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 40.59, ["Fly"] = 136.75, ["Ride"] = 57.72, ["Fly|Ride"] = 196.88, ["Neon"] = 427.93, ["Neon|Ride"] = 407.31, ["Neon|Fly|Ride"] = 322.88, ["Mega|Ride"] = 1124.82, ["Mega|Fly|Ride"] = 943.69}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 3.6, ["Fly"] = 24.15, ["Ride"] = 19.26, ["Fly|Ride"] = 57.75, ["Neon"] = 36.74, ["Neon|Fly"] = 101.07, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 190.32, ["Mega|Fly"] = 298.12, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 279.09}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 393.75, ["Ride"] = 467.33, ["Fly|Ride"] = 536.2, ["Neon|Ride"] = 1856.05, ["Neon|Fly|Ride"] = 1964.82, ["Mega|Fly|Ride"] = 6874.54}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 15.48, ["Ride"] = 32.22, ["Neon"] = 206.34, ["Neon|Fly|Ride"] = 275.34, ["Mega|Fly|Ride"] = 671.66}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 3.93, ["Fly"] = 34.55, ["Ride"] = 19.32, ["Fly|Ride"] = 43.3, ["Neon"] = 71.13, ["Neon|Ride"] = 88.69, ["Neon|Fly|Ride"] = 119.44, ["Mega"] = 206.24, ["Mega|Ride"] = 446.25}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 91.26, ["Fly"] = 108.08, ["Ride"] = 90.02, ["Fly|Ride"] = 131.25, ["Neon"] = 366.23, ["Neon|Fly"] = 468.15, ["Neon|Ride"] = 385.66, ["Neon|Fly|Ride"] = 433.13, ["Mega"] = 3712.07, ["Mega|Fly|Ride"] = 1636.41}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 13.1, ["Ride"] = 35, ["Fly|Ride"] = 118.13, ["Neon"] = 114.47, ["Neon|Ride"] = 82.5, ["Neon|Fly|Ride"] = 206.24, ["Mega"] = 550.65, ["Mega|Ride"] = 786.77, ["Mega|Fly|Ride"] = 824.92}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 205.94, ["Fly"] = 348.58, ["Ride"] = 244.14, ["Fly|Ride"] = 298.32, ["Neon"] = 656.25, ["Neon|Ride"] = 824.92, ["Mega"] = 6186.78, ["Mega|Fly|Ride"] = 3157.33}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 138.21}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 4.19, ["Fly"] = 31.4, ["Ride"] = 23.1, ["Fly|Ride"] = 61.88, ["Neon"] = 21.2, ["Neon|Fly"] = 5155.65, ["Neon|Ride"] = 52.48, ["Neon|Fly|Ride"] = 179.43, ["Mega"] = 164.99, ["Mega|Fly"] = 211.54, ["Mega|Ride"] = 155.01, ["Mega|Fly|Ride"] = 296.26}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 918.72, ["Fly"] = 2625, ["Ride"] = 990.96, ["Fly|Ride"] = 1053.24, ["Neon"] = 3904.89, ["Neon|Ride"] = 6049.64, ["Neon|Fly|Ride"] = 4278.75, ["Mega|Ride"] = 52484.22, ["Mega|Fly|Ride"] = 17083.5}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 7.87, ["Fly"] = 69.12, ["Ride"] = 20.23, ["Fly|Ride"] = 91.88, ["Neon"] = 138.18, ["Neon|Ride"] = 116.64, ["Neon|Fly|Ride"] = 227.89, ["Mega"] = 787.5, ["Mega|Ride"] = 963.09, ["Mega|Fly|Ride"] = 820.32}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 186.38, ["Ride"] = 193.1, ["Fly|Ride"] = 236.25, ["Neon"] = 1787.99, ["Neon|Ride"] = 819.69, ["Neon|Fly|Ride"] = 958.13, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 3150}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 44.45}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 15.14, ["Fly"] = 127.73, ["Ride"] = 65.54, ["Fly|Ride"] = 138.18, ["Neon"] = 104.89, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 687.78, ["Mega|Ride"] = 1087.86, ["Mega|Fly|Ride"] = 577.34}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.63}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 139.13, ["Ride"] = 206.27, ["Fly|Ride"] = 236.25, ["Neon|Ride"] = 515.58, ["Neon|Fly|Ride"] = 687.78, ["Mega|Fly|Ride"] = 2723.17}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 131.98, ["Ride"] = 192.94, ["Fly|Ride"] = 274.31, ["Neon"] = 315, ["Neon|Ride"] = 412.47, ["Neon|Fly|Ride"] = 525, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1830.27}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 36.96}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 52.5, ["Fly"] = 61.35, ["Ride"] = 55.56, ["Fly|Ride"] = 73.35, ["Neon|Ride"] = 367.4, ["Neon|Fly|Ride"] = 412.47, ["Mega|Fly|Ride"] = 1679.51}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 5.85, ["Ride"] = 35.38, ["Fly|Ride"] = 157.49, ["Neon"] = 138.18, ["Neon|Ride"] = 125.64, ["Neon|Fly|Ride"] = 232.02, ["Mega"] = 238.2, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 324.81, ["Mega|Fly|Ride"] = 598.5}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 446.25, ["Fly"] = 551.25, ["Ride"] = 446.25, ["Fly|Ride"] = 531.57, ["Neon|Ride"] = 3712.07, ["Neon|Fly|Ride"] = 1649.62, ["Mega|Fly|Ride"] = 7376.25}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 95.81, ["Fly"] = 206.27, ["Ride"] = 118.12, ["Fly|Ride"] = 192.84, ["Neon"] = 459.38, ["Neon|Ride"] = 756.86, ["Neon|Fly|Ride"] = 459.38, ["Mega|Fly|Ride"] = 2452.03}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3281.25, ["Ride"] = 3961.13, ["Fly|Ride"] = 3574.93}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 47.8, ["Fly"] = 112.1, ["Ride"] = 45.94, ["Fly|Ride"] = 128.43, ["Neon|Ride"] = 308.2, ["Mega"] = 1328.11, ["Mega|Ride"] = 2062.28, ["Mega|Fly|Ride"] = 1235.31}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 82.51, ["Ride"] = 101.07, ["Fly|Ride"] = 139.52, ["Neon"] = 575.75, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 710.83, ["Mega|Ride"] = 2200.44, ["Mega|Fly|Ride"] = 3388.47}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 38.8, ["Fly"] = 41.58, ["Ride"] = 57.65, ["Fly|Ride"] = 119.44, ["Neon"] = 262.5, ["Neon|Ride"] = 137.38, ["Neon|Fly|Ride"] = 202.93, ["Mega"] = 2625, ["Mega|Ride"] = 770.27, ["Mega|Fly|Ride"] = 656.15}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 6.18}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 78.75, ["Ride"] = 92.22, ["Fly|Ride"] = 65.63, ["Neon|Ride"] = 525, ["Mega|Fly|Ride"] = 1866.12}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 45.27}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 223.13, ["Ride"] = 236.25, ["Fly|Ride"] = 318.94, ["Neon|Ride"] = 1089.36, ["Neon|Fly|Ride"] = 1375.55}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 984.38, ["Ride"] = 943.69, ["Neon|Fly|Ride"] = 3295.49}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 6.55}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 23.87, ["Fly"] = 39.35, ["Ride"] = 43.32, ["Fly|Ride"] = 65.38, ["Neon"] = 164.07, ["Neon|Ride"] = 159.91, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 918.65, ["Mega|Fly|Ride"] = 904.16}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 18.08}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5250, ["Fly"] = 6325.74, ["Fly|Ride"] = 4921.88, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 40744.09}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 11.21, ["Fly"] = 52.5, ["Ride"] = 25.09, ["Fly|Ride"] = 52.78, ["Neon"] = 95.82, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 787.5, ["Mega|Ride"] = 550.65, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 12.99, ["Ride"] = 36.66, ["Fly|Ride"] = 311.41, ["Neon"] = 72.19, ["Neon|Ride"] = 122.07, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 727.13, ["Mega|Ride"] = 770.2, ["Mega|Fly|Ride"] = 1028.05}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 70.87, ["Fly"] = 275.36, ["Ride"] = 74.46, ["Fly|Ride"] = 131.25, ["Neon|Ride"] = 382.57, ["Neon|Fly|Ride"] = 480.96, ["Mega"] = 4124.53}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 9.76, ["Ride"] = 25.93, ["Fly|Ride"] = 132.64, ["Neon"] = 108.94, ["Neon|Ride"] = 259.86, ["Neon|Fly|Ride"] = 501.38, ["Mega|Ride"] = 731.3, ["Mega|Fly|Ride"] = 813.75}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1575, ["Fly"] = 2283.21, ["Ride"] = 1706.25, ["Fly|Ride"] = 1752.19, ["Neon|Ride"] = 4289.51, ["Neon|Fly|Ride"] = 3542.34, ["Mega|Fly|Ride"] = 12468.75}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 26248.69, ["Fly"] = 33000.2, ["Ride"] = 52500, ["Fly|Ride"] = 27624.09, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 71223.42, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 183750}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 16.99, ["Fly"] = 393.75, ["Ride"] = 52.5, ["Fly|Ride"] = 927, ["Neon"] = 275.34, ["Neon|Ride"] = 275.34, ["Neon|Fly|Ride"] = 550.65, ["Mega"] = 1084.77, ["Mega|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 820.8}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 3.56, ["Fly"] = 72.89, ["Ride"] = 38.07, ["Fly|Ride"] = 145.4, ["Neon"] = 22.53, ["Neon|Fly"] = 210, ["Neon|Ride"] = 55.7, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 133.49, ["Mega|Ride"] = 222.92, ["Mega|Fly|Ride"] = 329.97}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 15.63}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 6.24, ["Ride"] = 36.53, ["Fly|Ride"] = 131.25, ["Neon"] = 76.32, ["Neon|Ride"] = 105, ["Mega"] = 294.62, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 626.07}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 922.99, ["Ride"] = 787.5, ["Fly|Ride"] = 892.5, ["Neon|Fly|Ride"] = 2402.12, ["Mega|Fly|Ride"] = 8397.48}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 918.75, ["Fly"] = 918.75, ["Ride"] = 984.27, ["Fly|Ride"] = 1141.88, ["Neon|Ride"] = 3190.32, ["Neon|Fly|Ride"] = 3109.32, ["Mega|Fly|Ride"] = 10551.19}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 39.38, ["Fly"] = 116.72, ["Ride"] = 39.38, ["Fly|Ride"] = 65.62, ["Neon"] = 72.19, ["Neon|Ride"] = 126, ["Neon|Fly|Ride"] = 274.3, ["Mega"] = 1204.13, ["Mega|Ride"] = 1522.5, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 40.69}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 45.75, ["Fly"] = 122.74, ["Ride"] = 77.15, ["Fly|Ride"] = 133.41, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 455.44, ["Mega|Fly|Ride"] = 1664.25}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 97.8, ["Ride"] = 117.58, ["Fly|Ride"] = 209.94, ["Neon"] = 357.81, ["Neon|Ride"] = 320.92, ["Neon|Fly|Ride"] = 550.65, ["Mega"] = 1341.9, ["Mega|Fly|Ride"] = 1861.13}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 3.48, ["Fly"] = 19.45, ["Ride"] = 19.85, ["Fly|Ride"] = 49.89, ["Neon"] = 41.26, ["Neon|Fly"] = 524.98, ["Neon|Ride"] = 55.7, ["Neon|Fly|Ride"] = 132.98, ["Mega"] = 316.57, ["Mega|Fly|Ride"] = 687.78}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 140.01, ["Fly"] = 144.38, ["Ride"] = 144.25, ["Fly|Ride"] = 210.78, ["Neon|Ride"] = 518.43, ["Neon|Fly|Ride"] = 519.75, ["Mega|Fly|Ride"] = 1921.5}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 4.11, ["Ride"] = 51.1, ["Fly|Ride"] = 138.18, ["Neon"] = 39.38, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 824.92, ["Mega"] = 170.62, ["Mega|Ride"] = 474.62}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 14.01, ["Fly"] = 41.43, ["Ride"] = 32.4, ["Fly|Ride"] = 76.32, ["Neon"] = 123.76, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 305.23, ["Mega|Fly|Ride"] = 1018.5}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 20.58, ["Ride"] = 128.62, ["Fly|Ride"] = 156.19, ["Neon"] = 245.46, ["Neon|Ride"] = 275.34, ["Mega"] = 3360, ["Mega|Ride"] = 1161.57}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 14.52, ["Fly"] = 206.27, ["Ride"] = 26.25, ["Fly|Ride"] = 67.38, ["Neon"] = 91.88, ["Neon|Ride"] = 114.59, ["Neon|Fly|Ride"] = 205.22, ["Mega|Fly|Ride"] = 1090.95}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6738.24, ["Ride"] = 6555.94, ["Fly|Ride"] = 5496.74, ["Neon"] = 34371.63, ["Neon|Ride"] = 23625, ["Neon|Fly|Ride"] = 24540.86, ["Mega|Fly|Ride"] = 93305.27}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 224.42, ["Fly"] = 261.95, ["Ride"] = 243.86, ["Fly|Ride"] = 294, ["Neon|Fly|Ride"] = 564.38, ["Mega|Fly|Ride"] = 2067.19}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 44.49, ["Fly"] = 139.54, ["Ride"] = 89.67, ["Fly|Ride"] = 143.07, ["Neon"] = 138.18, ["Neon|Fly"] = 241.5, ["Neon|Ride"] = 179.61, ["Neon|Fly|Ride"] = 276.94, ["Mega"] = 455.28, ["Mega|Ride"] = 417.38, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 3.68, ["Fly"] = 86.38, ["Ride"] = 35.07, ["Fly|Ride"] = 52.5, ["Neon"] = 30.95, ["Neon|Fly"] = 59.81, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 187.68, ["Mega"] = 341.25, ["Mega|Ride"] = 188.99, ["Mega|Fly|Ride"] = 348.75}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 51.18, ["Fly"] = 5290.42, ["Ride"] = 95.11, ["Fly|Ride"] = 247.49, ["Neon"] = 218.36, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 265.15, ["Neon|Fly|Ride"] = 369.62, ["Mega"] = 564.38, ["Mega|Ride"] = 580.46, ["Mega|Fly|Ride"] = 608.37}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 16485, ["Ride"] = 13387.5, ["Fly|Ride"] = 11942.44, ["Neon|Fly|Ride"] = 22837.5}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 262.49, ["Ride"] = 301.53, ["Fly|Ride"] = 459.38, ["Neon"] = 1520.86, ["Neon|Fly|Ride"] = 1575, ["Mega|Fly|Ride"] = 5912.5}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 103.15, ["Fly"] = 91.88, ["Ride"] = 57.18, ["Fly|Ride"] = 118.02, ["Neon"] = 1050, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 412.47, ["Mega|Fly|Ride"] = 3438.83}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 15.75, ["Fly"] = 44.36, ["Ride"] = 27.85, ["Fly|Ride"] = 74.72, ["Neon"] = 69.11, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 468.15, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 379.1, ["Ride"] = 393.74, ["Fly|Ride"] = 500.39, ["Neon"] = 1649.82, ["Neon|Ride"] = 1581.77, ["Neon|Fly|Ride"] = 1575, ["Mega|Fly|Ride"] = 4331.25}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 7.18, ["Fly"] = 103.67, ["Ride"] = 38.8, ["Fly|Ride"] = 105, ["Neon"] = 25.93, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 179.43, ["Mega"] = 169.32, ["Mega|Fly"] = 278.37, ["Mega|Ride"] = 218.73, ["Mega|Fly|Ride"] = 343.88}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 91.87, ["Fly"] = 234.11, ["Ride"] = 144.27, ["Fly|Ride"] = 242.61, ["Neon"] = 614.57, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 557.82, ["Mega|Fly|Ride"] = 2178.63}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 12.53, ["Fly"] = 18.75, ["Ride"] = 18.8, ["Fly|Ride"] = 37.63, ["Neon|Ride"] = 96.94, ["Neon|Fly|Ride"] = 90.02, ["Mega"] = 2474.72}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 10.01}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 62.99, ["Ride"] = 58.46, ["Fly|Ride"] = 412.47, ["Neon"] = 344.42, ["Neon|Fly"] = 1649.82, ["Neon|Ride"] = 524.99, ["Neon|Fly|Ride"] = 3093.4, ["Mega|Ride"] = 1312.5}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 16.02, ["Fly"] = 102.12, ["Ride"] = 31.49, ["Fly|Ride"] = 93.19, ["Neon"] = 98.44, ["Neon|Ride"] = 109.18, ["Neon|Fly|Ride"] = 240.95, ["Mega|Ride"] = 550.65, ["Mega|Fly|Ride"] = 824.92}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 31.5}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 55.13, ["Fly"] = 210, ["Ride"] = 91.88, ["Fly|Ride"] = 249.38, ["Neon"] = 218.11, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 514.55, ["Mega"] = 1546.71, ["Mega|Ride"] = 2092.13, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 4.91, ["Neon"] = 23.73, ["Neon|Ride"] = 101.49, ["Neon|Fly|Ride"] = 275.34, ["Mega"] = 124.67, ["Mega|Ride"] = 213.42}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 9.85, ["Fly"] = 52.5, ["Ride"] = 28.25, ["Fly|Ride"] = 78.16, ["Neon|Ride"] = 152.62, ["Neon|Fly|Ride"] = 206.24, ["Mega|Fly|Ride"] = 777.95}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 446.25, ["Ride"] = 490.28, ["Fly|Ride"] = 630, ["Neon|Fly|Ride"] = 2750.03, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 32.62, ["Ride"] = 64.78, ["Fly|Ride"] = 304.2, ["Neon"] = 235.45, ["Neon|Ride"] = 262.5, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 1375.55}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 60.79, ["Fly"] = 119.89, ["Ride"] = 69.42, ["Fly|Ride"] = 152.62, ["Neon"] = 275.34, ["Neon|Ride"] = 412.47, ["Neon|Fly|Ride"] = 458.1, ["Mega|Fly|Ride"] = 911.53}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 37.14, ["Fly"] = 78.21, ["Ride"] = 59.06, ["Fly|Ride"] = 123.92, ["Neon"] = 92.85, ["Neon|Ride"] = 156.3, ["Neon|Fly|Ride"] = 418.69, ["Mega"] = 437.07, ["Mega|Ride"] = 411.44, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 8531.25, ["Ride"] = 13383, ["Fly|Ride"] = 8137.4, ["Neon|Fly|Ride"] = 16931.25, ["Mega|Fly|Ride"] = 38850}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1397.81, ["Fly"] = 1663.82, ["Ride"] = 1443.75, ["Fly|Ride"] = 1574.9, ["Neon|Fly|Ride"] = 4987.5, ["Mega|Fly|Ride"] = 14437.5}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 522.85, ["Ride"] = 560.39, ["Fly|Ride"] = 614.57, ["Neon"] = 2552.44, ["Neon|Fly|Ride"] = 2093.9, ["Mega|Fly|Ride"] = 6874.54}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 10.62, ["Fly"] = 20.7, ["Ride"] = 21.51, ["Fly|Ride"] = 40.5, ["Neon"] = 110.35, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 164.99, ["Mega|Fly|Ride"] = 572.25}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 6.2, ["Fly"] = 78.74, ["Ride"] = 29.6, ["Neon"] = 24.94, ["Neon|Ride"] = 54.94, ["Mega"] = 146.86, ["Mega|Ride"] = 172.64, ["Mega|Fly|Ride"] = 324.81}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 31.64, ["Fly"] = 63.09, ["Ride"] = 70.26, ["Fly|Ride"] = 107.86, ["Neon"] = 268.11, ["Neon|Ride"] = 200.06, ["Neon|Fly|Ride"] = 189.95, ["Mega|Fly|Ride"] = 582.75}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.5, ["Fly"] = 19.69, ["Ride"] = 20.64, ["Fly|Ride"] = 39.38, ["Neon"] = 31.48, ["Neon|Fly"] = 76.92, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 78.66, ["Mega"] = 206.24, ["Mega|Ride"] = 264.76}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 275.52, ["Fly"] = 369.49, ["Ride"] = 398.99, ["Fly|Ride"] = 419.3, ["Neon|Fly|Ride"] = 1647.75}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 22.52, ["Fly"] = 58.36, ["Ride"] = 31.5, ["Fly|Ride"] = 105, ["Neon"] = 188.72, ["Neon|Fly"] = 138.18, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 288.75, ["Mega|Ride"] = 787.4, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 10.56, ["Fly"] = 20.99, ["Ride"] = 17.07, ["Fly|Ride"] = 45.94, ["Neon"] = 138.18, ["Neon|Fly"] = 132.97, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 1575, ["Mega|Ride"] = 618.19, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 639.39, ["Fly"] = 787.5, ["Ride"] = 514.55, ["Fly|Ride"] = 824.92, ["Neon|Fly|Ride"] = 2062.28, ["Mega|Fly|Ride"] = 9797.07}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1228.46, ["Ride"] = 1260, ["Fly|Ride"] = 1344, ["Neon"] = 4812.28, ["Neon|Ride"] = 4124.53, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 13782.3}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 86.62, ["Fly"] = 134.08, ["Ride"] = 123.73, ["Fly|Ride"] = 129.84, ["Neon"] = 971.25, ["Neon|Ride"] = 585.46, ["Neon|Fly|Ride"] = 590.63, ["Mega|Fly|Ride"] = 2268.49}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 171.82, ["Fly"] = 157.49, ["Ride"] = 171.78, ["Fly|Ride"] = 238.68, ["Neon"] = 851.73, ["Neon|Ride"] = 630, ["Neon|Fly|Ride"] = 621.06, ["Mega|Ride"] = 3025.34, ["Mega|Fly|Ride"] = 2792.56}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 31.29, ["Ride"] = 53.72, ["Fly|Ride"] = 118.97, ["Neon"] = 385.66, ["Neon|Ride"] = 272.99, ["Mega|Ride"] = 2062.28, ["Mega|Fly|Ride"] = 908.43}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 157.5, ["Ride"] = 315, ["Fly|Ride"] = 550.65, ["Neon|Fly|Ride"] = 1306.3, ["Mega|Fly|Ride"] = 3851.28}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2241.96, ["Fly"] = 2217.48, ["Ride"] = 2483.25, ["Fly|Ride"] = 3150, ["Neon|Fly|Ride"] = 10311.29, ["Mega|Fly|Ride"] = 27991.6}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 53.69, ["Fly"] = 206.27, ["Ride"] = 52.47, ["Fly|Ride"] = 196.88, ["Neon"] = 511.88, ["Neon|Ride"] = 328.12, ["Neon|Fly|Ride"] = 343.88, ["Mega|Ride"] = 1100.23, ["Mega|Fly|Ride"] = 1399.6}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 630, ["Ride"] = 682.5, ["Fly|Ride"] = 735, ["Neon|Fly|Ride"] = 1345.31, ["Mega|Fly|Ride"] = 3451.86}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 38.66, ["Fly"] = 67.7, ["Ride"] = 45.94, ["Fly|Ride"] = 98.44, ["Neon|Ride"] = 266.09, ["Neon|Fly|Ride"] = 287.44, ["Mega|Fly|Ride"] = 1100.23}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 2.63, ["Fly"] = 43.3, ["Ride"] = 21.09, ["Fly|Ride"] = 50.37, ["Neon"] = 22.32, ["Neon|Fly"] = 139.13, ["Neon|Ride"] = 45.92, ["Neon|Fly|Ride"] = 78.2, ["Mega"] = 167.18, ["Mega|Fly"] = 249.26, ["Mega|Ride"] = 182.11, ["Mega|Fly|Ride"] = 297.94}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 50.3, ["Ride"] = 128.34, ["Fly|Ride"] = 253.32, ["Neon"] = 340.28, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 687.78, ["Mega"] = 1507.52, ["Mega|Fly|Ride"] = 1429.16}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 826.88, ["Ride"] = 826.88, ["Fly|Ride"] = 899.42, ["Neon|Ride"] = 2598.75, ["Neon|Fly|Ride"] = 2572.92, ["Mega|Fly|Ride"] = 7875}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 721.88, ["Ride"] = 1089.33, ["Fly|Ride"] = 7775.65, ["Mega|Fly|Ride"] = 14984.36}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 13.63, ["Fly"] = 27.85, ["Ride"] = 24.03, ["Fly|Ride"] = 38, ["Neon"] = 78.75, ["Neon|Ride"] = 110.35, ["Neon|Fly|Ride"] = 170.63, ["Mega|Fly|Ride"] = 699.81}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 7.65, ["Ride"] = 19.58, ["Fly|Ride"] = 69.11, ["Neon"] = 125.69, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 518.44, ["Mega|Ride"] = 412.47, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 2.77, ["Ride"] = 24.74, ["Fly|Ride"] = 102.38, ["Neon"] = 21.7, ["Neon|Fly"] = 310.7, ["Neon|Ride"] = 54.47, ["Neon|Fly|Ride"] = 170.57, ["Mega"] = 154.88, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 296.26, ["Mega|Fly|Ride"] = 334.69}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 42, ["Fly"] = 57.25, ["Ride"] = 48.56, ["Fly|Ride"] = 101.37, ["Neon"] = 249.38, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 273, ["Mega|Fly|Ride"] = 933.07}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 51.75, ["Ride"] = 135.19, ["Fly|Ride"] = 622.81, ["Neon"] = 424.07, ["Neon|Ride"] = 515.58, ["Neon|Fly|Ride"] = 695.63, ["Mega|Ride"] = 1546.71, ["Mega|Fly|Ride"] = 1512.68}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 13.7, ["Fly"] = 43.3, ["Ride"] = 35.43, ["Fly|Ride"] = 82.92, ["Neon"] = 105, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 192.84, ["Mega"] = 617.66, ["Mega|Ride"] = 428.96, ["Mega|Fly|Ride"] = 870.45}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 38.8, ["Ride"] = 45.74, ["Fly|Ride"] = 86.91, ["Neon"] = 323.79, ["Neon|Ride"] = 190.11, ["Neon|Fly|Ride"] = 196.76, ["Mega"] = 2100, ["Mega|Ride"] = 1028.05, ["Mega|Fly|Ride"] = 1100.23}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.04, ["Fly"] = 20.9, ["Ride"] = 15.75, ["Fly|Ride"] = 42, ["Neon"] = 29.19, ["Neon|Ride"] = 45.93, ["Neon|Fly|Ride"] = 91.75, ["Mega"] = 721.81, ["Mega|Ride"] = 362.97, ["Mega|Fly|Ride"] = 550.65}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 7.61, ["Fly"] = 44.09, ["Ride"] = 32.45, ["Fly|Ride"] = 31621.61, ["Neon"] = 31.73, ["Neon|Fly"] = 115.54, ["Neon|Ride"] = 81.81, ["Neon|Fly|Ride"] = 206.24, ["Mega"] = 307.13, ["Mega|Ride"] = 313.04}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 77.36, ["Fly"] = 65.63, ["Ride"] = 51.19, ["Fly|Ride"] = 94.5, ["Neon"] = 404.72, ["Neon|Ride"] = 206.24, ["Neon|Fly|Ride"] = 262.5, ["Mega|Fly|Ride"] = 1074.06}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1574.99, ["Fly"] = 1574.99, ["Ride"] = 1682.61, ["Fly|Ride"] = 1577.92, ["Neon|Fly|Ride"] = 3858.74, ["Mega|Fly|Ride"] = 12998.72}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 446.25, ["Fly"] = 479.81, ["Ride"] = 459.38, ["Fly|Ride"] = 525, ["Mega|Fly|Ride"] = 9624.56}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 303.29, ["Ride"] = 331.35, ["Fly|Ride"] = 1237.37, ["Neon"] = 1375.55, ["Neon|Ride"] = 1555.88, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 44.61}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 26.17, ["Ride"] = 44.03, ["Fly|Ride"] = 98.44, ["Neon|Ride"] = 514.55, ["Neon|Fly|Ride"] = 412.47, ["Mega|Ride"] = 1499.28, ["Mega|Fly|Ride"] = 1038.19}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 34375.89, ["Fly"] = 65625, ["Ride"] = 34988.65, ["Fly|Ride"] = 16275, ["Neon|Fly|Ride"] = 38062.5, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 299.43, ["Fly"] = 611.63, ["Ride"] = 367.5, ["Fly|Ride"] = 426.56, ["Neon"] = 1373.48, ["Neon|Ride"] = 1089.36, ["Neon|Fly|Ride"] = 1036.88, ["Mega"] = 4124.53, ["Mega|Fly|Ride"] = 3871.88}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 275.36, ["Fly"] = 525, ["Ride"] = 138.21, ["Fly|Ride"] = 203.44}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 196.88, ["Fly"] = 275.36, ["Ride"] = 172.62, ["Fly|Ride"] = 216.57, ["Neon|Ride"] = 756.86, ["Neon|Fly|Ride"] = 802.24, ["Mega|Fly|Ride"] = 3018.75}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 11.45, ["Fly"] = 94.5, ["Ride"] = 30.17, ["Fly|Ride"] = 126, ["Neon|Ride"] = 138.18, ["Neon|Fly|Ride"] = 961.03, ["Mega"] = 697.48, ["Mega|Ride"] = 550.65, ["Mega|Fly|Ride"] = 687.78}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 5296.25, ["Ride"] = 5151.14, ["Fly|Ride"] = 4651.79, ["Neon"] = 26809.34, ["Neon|Fly|Ride"] = 27221.79}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 30.5, ["Fly"] = 45.92, ["Ride"] = 31.46, ["Fly|Ride"] = 68.07, ["Neon"] = 228.93, ["Neon|Ride"] = 343.88, ["Neon|Fly|Ride"] = 346.5, ["Mega|Fly|Ride"] = 824.92}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 44.35, ["Ride"] = 55.34, ["Fly|Ride"] = 94.8, ["Neon"] = 403.96, ["Neon|Ride"] = 488.77, ["Neon|Fly|Ride"] = 359.63, ["Mega|Fly|Ride"] = 1372.88}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 679.76, ["Fly"] = 920.07, ["Ride"] = 715.3, ["Fly|Ride"] = 905.5, ["Neon"] = 2371.61, ["Neon|Ride"] = 1968.75, ["Neon|Fly|Ride"] = 1942.5, ["Mega"] = 8042.82, ["Mega|Fly"] = 8042.82, ["Mega|Fly|Ride"] = 7972.7}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 15.64, ["Fly"] = 31.42, ["Ride"] = 24.65, ["Fly|Ride"] = 39.38, ["Neon"] = 115.49, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 192.84, ["Mega|Fly|Ride"] = 640.5}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 12.49, ["Fly"] = 275.36, ["Ride"] = 36.11, ["Fly|Ride"] = 78.16, ["Neon"] = 131.81, ["Neon|Ride"] = 116.64, ["Neon|Fly|Ride"] = 247.49}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 108.84, ["Ride"] = 128.63, ["Fly|Ride"] = 262.5, ["Neon"] = 1010.63, ["Neon|Ride"] = 530.25, ["Neon|Fly|Ride"] = 605.3, ["Mega|Fly|Ride"] = 2736.63}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 26.25, ["Fly"] = 138.21, ["Ride"] = 57.85, ["Fly|Ride"] = 131.15, ["Neon"] = 76.32, ["Neon|Ride"] = 138.18, ["Neon|Fly|Ride"] = 236.24, ["Mega"] = 313.69, ["Mega|Fly"] = 715.62, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 423.39}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3930.83, ["Ride"] = 4068.75, ["Fly|Ride"] = 4003.13, ["Neon"] = 13061.31, ["Neon|Ride"] = 11812.5, ["Neon|Fly|Ride"] = 11023.69, ["Mega"] = 61867.67, ["Mega|Fly|Ride"] = 35456.02}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 32.47, ["Ride"] = 80.07, ["Fly|Ride"] = 191.29, ["Neon"] = 550.65, ["Neon|Ride"] = 190.32, ["Neon|Fly|Ride"] = 683.82, ["Mega|Ride"] = 1022.89, ["Mega|Fly|Ride"] = 1819.47}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 7271.25, ["Fly"] = 7563.25, ["Ride"] = 6857.82, ["Fly|Ride"] = 6339.16, ["Neon|Ride"] = 18972.77, ["Neon|Fly|Ride"] = 17850, ["Mega|Fly|Ride"] = 63759.01}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.61, ["Fly"] = 20.79, ["Ride"] = 20.65, ["Fly|Ride"] = 29.26, ["Neon"] = 22.98, ["Neon|Fly"] = 57.77, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 87.94, ["Mega"] = 451.39, ["Mega|Fly|Ride"] = 341.32}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 14.44, ["Fly"] = 28.71, ["Ride"] = 25.13, ["Fly|Ride"] = 53.58, ["Neon"] = 192.84, ["Neon|Fly"] = 227.89, ["Neon|Ride"] = 550.65, ["Neon|Fly|Ride"] = 153.2, ["Mega|Fly|Ride"] = 935.82}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 4.14}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 12.92, ["Ride"] = 32.82, ["Fly|Ride"] = 116.02, ["Neon"] = 103.13, ["Neon|Ride"] = 157.68, ["Mega"] = 790.57, ["Mega|Ride"] = 865.13, ["Mega|Fly|Ride"] = 1244.48}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 26.25, ["Fly"] = 190.37, ["Ride"] = 41.91, ["Fly|Ride"] = 99.75, ["Neon"] = 208.3, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 317.05, ["Mega"] = 945, ["Mega|Fly|Ride"] = 1099.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 11.79, ["Fly"] = 18.47, ["Ride"] = 21.27, ["Fly|Ride"] = 35.07, ["Neon|Fly"] = 110.35, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 179.55, ["Mega"] = 2474.72, ["Mega|Ride"] = 582.01, ["Mega|Fly|Ride"] = 535.17}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8353.2}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2941.15}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 23.82}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 277.93, ["Ride"] = 247.49, ["Fly|Ride"] = 223.13, ["Mega|Fly|Ride"] = 5131.8}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 18.69, ["Fly"] = 129.95, ["Ride"] = 38.8, ["Fly|Ride"] = 139.13, ["Neon"] = 180.46, ["Neon|Ride"] = 131.15, ["Neon|Fly|Ride"] = 265.13, ["Mega|Ride"] = 514.36, ["Mega|Fly|Ride"] = 1732.5}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 10.49}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 4.76, ["Ride"] = 29.92, ["Fly|Ride"] = 82.5, ["Neon"] = 105, ["Neon|Ride"] = 96.94, ["Mega|Fly|Ride"] = 824.92}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 3112.64}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 193.9, ["Fly"] = 412.52, ["Ride"] = 262.49, ["Fly|Ride"] = 328.13, ["Neon"] = 756.86, ["Neon|Ride"] = 774.38, ["Neon|Fly|Ride"] = 824.92, ["Mega|Ride"] = 3162.49, ["Mega|Fly|Ride"] = 3438.83}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 82.69, ["Ride"] = 148.32, ["Fly|Ride"] = 206.24, ["Neon"] = 550.65, ["Neon|Ride"] = 502.51, ["Neon|Fly|Ride"] = 601.84, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 171.29, ["Fly"] = 344.46, ["Ride"] = 201.91, ["Fly|Ride"] = 247.49, ["Neon"] = 897.75, ["Neon|Ride"] = 1056.69, ["Neon|Fly|Ride"] = 963.09, ["Mega|Fly|Ride"] = 4528.73}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1575, ["Fly"] = 3162.88, ["Ride"] = 2212.53, ["Fly|Ride"] = 2164.93, ["Neon"] = 8164.03, ["Neon|Fly|Ride"] = 6431.25, ["Mega|Fly|Ride"] = 17718.75}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 15.75, ["Fly"] = 96.95, ["Ride"] = 56.8, ["Fly|Ride"] = 99.74, ["Neon"] = 127.32, ["Neon|Ride"] = 202.96, ["Neon|Fly|Ride"] = 436.19, ["Mega"] = 927, ["Mega|Ride"] = 1011.21, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 825.02, ["Fly"] = 2100, ["Ride"] = 734.9, ["Fly|Ride"] = 948.66, ["Neon|Fly|Ride"] = 4043.64, ["Mega|Fly|Ride"] = 18661.07}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 51.74}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 14.43, ["Ride"] = 42, ["Fly|Ride"] = 647.98, ["Neon"] = 101.07, ["Neon|Ride"] = 138.18, ["Neon|Fly|Ride"] = 311.42, ["Mega"] = 398.9, ["Mega|Ride"] = 519.75, ["Mega|Fly|Ride"] = 700.88}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 8.96, ["Fly"] = 262.5, ["Ride"] = 27.57, ["Fly|Ride"] = 96.77, ["Neon"] = 53.13, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 210, ["Mega"] = 918.75, ["Mega|Ride"] = 412.47}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 88.82}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 20.42, ["Ride"] = 23.61, ["Fly|Ride"] = 80.45, ["Neon"] = 93.32, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 481.55, ["Mega|Fly|Ride"] = 1926.17}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 21.61, ["Ride"] = 45.85, ["Fly|Ride"] = 52.41, ["Neon|Ride"] = 412.47, ["Neon|Fly|Ride"] = 327.92, ["Mega|Ride"] = 1749.48, ["Mega|Fly|Ride"] = 961.03}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6561.19, ["Fly"] = 11000.42, ["Ride"] = 6793.5, ["Fly|Ride"] = 4984.77, ["Neon|Fly|Ride"] = 11588.07, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 10.4, ["Fly"] = 65.63, ["Ride"] = 33.27, ["Fly|Ride"] = 109.65, ["Neon"] = 82.26, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 218.12, ["Mega"] = 412.47, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 695.37}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 25.29}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 96.5, ["Fly"] = 365.09, ["Ride"] = 135.19, ["Fly|Ride"] = 233.04, ["Neon"] = 481.55, ["Neon|Ride"] = 510.42, ["Neon|Fly|Ride"] = 699.81, ["Mega"] = 2879.59, ["Mega|Fly|Ride"] = 1926.17}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 51.52, ["Fly"] = 140.06, ["Ride"] = 101.07, ["Fly|Ride"] = 190.32, ["Neon"] = 344.08, ["Neon|Ride"] = 304.2, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 2332.64, ["Mega|Ride"] = 2784.06, ["Mega|Fly|Ride"] = 1916.28}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 23.1, ["Fly"] = 70.47, ["Ride"] = 27.57, ["Fly|Ride"] = 81.38, ["Neon|Fly"] = 234.08, ["Neon|Ride"] = 206.24, ["Neon|Fly|Ride"] = 190.3, ["Mega"] = 1016.21, ["Mega|Ride"] = 856.09, ["Mega|Fly|Ride"] = 735}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 6.57, ["Fly"] = 65.44, ["Ride"] = 30.34, ["Fly|Ride"] = 94.18, ["Neon"] = 31.83, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 157.4, ["Mega"] = 179.04, ["Mega|Fly"] = 254.63, ["Mega|Ride"] = 226.28, ["Mega|Fly|Ride"] = 307.79}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 11.69, ["Ride"] = 31.42, ["Fly|Ride"] = 73.5, ["Neon"] = 86.23, ["Neon|Ride"] = 122.72, ["Neon|Fly|Ride"] = 160.13, ["Mega"] = 606.51, ["Mega|Ride"] = 529.52, ["Mega|Fly|Ride"] = 584.07}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 19.59, ["Fly"] = 30.19, ["Ride"] = 27.18, ["Fly|Ride"] = 47.16, ["Neon"] = 154.69, ["Neon|Ride"] = 145.69, ["Neon|Fly|Ride"] = 144.38, ["Mega|Fly|Ride"] = 699.81}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 195.55}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 103.15, ["Ride"] = 98.44, ["Neon"] = 196.88, ["Neon|Fly|Ride"] = 565.07, ["Mega"] = 1100.23, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 208.69, ["Ride"] = 443.63, ["Fly|Ride"] = 1555.85}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 36.53, ["Fly"] = 212.02, ["Ride"] = 116.53, ["Fly|Ride"] = 227.89, ["Neon"] = 511.46, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 485.63, ["Mega"] = 1210.56, ["Mega|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 1266.24}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 918.74, ["Fly"] = 1334.47, ["Ride"] = 944.99, ["Fly|Ride"] = 1069.45, ["Neon|Fly"] = 4035.38, ["Neon|Ride"] = 3281.25, ["Neon|Fly|Ride"] = 3150, ["Mega|Fly|Ride"] = 12924.17}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 401.52, ["Fly"] = 687.86, ["Ride"] = 413.44, ["Fly|Ride"] = 564.04, ["Neon"] = 2887.18, ["Neon|Ride"] = 2062.28, ["Neon|Fly|Ride"] = 2559.38, ["Mega|Fly|Ride"] = 7742.44}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 71.32}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 3.68}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 8.5, ["Fly"] = 78.75, ["Ride"] = 19.76, ["Fly|Ride"] = 69.11, ["Neon"] = 78.75, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 157.5, ["Mega|Ride"] = 687.78, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 259.66, ["Ride"] = 311.41, ["Fly|Ride"] = 603.75, ["Neon"] = 1097.13, ["Neon|Ride"] = 1006.43, ["Neon|Fly|Ride"] = 917.44, ["Mega|Fly|Ride"] = 3190.32}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 18.5}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 137.81, ["Ride"] = 257.8, ["Fly|Ride"] = 293.2, ["Neon"] = 585.36, ["Neon|Fly"] = 580.61, ["Neon|Ride"] = 510.57, ["Neon|Fly|Ride"] = 610.32, ["Mega"] = 9898.84, ["Mega|Ride"] = 2722.19, ["Mega|Fly|Ride"] = 3023.29}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 125.55, ["Fly"] = 105, ["Ride"] = 128.66, ["Fly|Ride"] = 202.12, ["Neon"] = 687.78, ["Neon|Ride"] = 1005.38, ["Neon|Fly|Ride"] = 913.5, ["Mega|Ride"] = 3438.83}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 3.84, ["Ride"] = 26.25, ["Fly|Ride"] = 168.09, ["Neon"] = 30.95, ["Neon|Ride"] = 86.56, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 304.2, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 823.89}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 14.17, ["Fly"] = 63.03, ["Ride"] = 26.83, ["Fly|Ride"] = 74, ["Neon"] = 177.19, ["Neon|Ride"] = 164.07, ["Neon|Fly|Ride"] = 393.75, ["Mega|Ride"] = 803.27, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 15.49, ["Fly"] = 102.34, ["Ride"] = 48.48, ["Fly|Ride"] = 104.6, ["Neon"] = 65.63, ["Neon|Ride"] = 132, ["Neon|Fly|Ride"] = 256.57, ["Mega"] = 498.75, ["Mega|Ride"] = 466.54, ["Mega|Fly|Ride"] = 729.03}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 3.85, ["Fly"] = 123.77, ["Ride"] = 52.07, ["Fly|Ride"] = 206.24, ["Neon"] = 26.78, ["Neon|Ride"] = 64.19, ["Neon|Fly|Ride"] = 172.49, ["Mega"] = 155.69, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 273, ["Ride"] = 290.04, ["Fly|Ride"] = 354.38, ["Neon"] = 1623.01, ["Neon|Ride"] = 1327.28, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 5224.74}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 133.39, ["Fly"] = 550.7, ["Ride"] = 237.51, ["Fly|Ride"] = 241.48, ["Neon"] = 1649.82, ["Neon|Ride"] = 731.3, ["Neon|Fly|Ride"] = 1173.27, ["Mega|Fly|Ride"] = 2473.69}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 75.31, ["Ride"] = 69.33, ["Fly|Ride"] = 176.34, ["Neon"] = 393.75, ["Neon|Ride"] = 523.69, ["Neon|Fly|Ride"] = 416.07}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 11.38, ["Ride"] = 69.12, ["Fly|Ride"] = 275.34, ["Neon|Ride"] = 592.51, ["Neon|Fly|Ride"] = 481.55, ["Mega|Ride"] = 618.7, ["Mega|Fly|Ride"] = 1856.05}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 15.75, ["Fly"] = 75.63, ["Ride"] = 35.49, ["Fly|Ride"] = 75.8, ["Neon"] = 77.4, ["Neon|Ride"] = 123.76, ["Neon|Fly|Ride"] = 210, ["Mega"] = 371.44, ["Mega|Fly"] = 525, ["Mega|Ride"] = 428.96, ["Mega|Fly|Ride"] = 530.01}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.74, ["Fly"] = 52.45, ["Ride"] = 23.63, ["Fly|Ride"] = 98.44, ["Neon"] = 24.94, ["Neon|Fly"] = 65.58, ["Neon|Ride"] = 35.25, ["Neon|Fly|Ride"] = 118.1, ["Mega"] = 137.1, ["Mega|Ride"] = 137.82, ["Mega|Fly|Ride"] = 385.66}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 840, ["Fly"] = 1082.72, ["Ride"] = 965.48, ["Fly|Ride"] = 951.56, ["Neon|Ride"] = 3144.95, ["Neon|Fly|Ride"] = 2624.88, ["Mega|Fly|Ride"] = 10138.06}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["Ride"] = 357.31, ["Fly|Ride"] = 452.82, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1620.94, ["Mega"] = 10311.29, ["Mega|Fly|Ride"] = 5774.33}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 92.38, ["Fly"] = 138.21, ["Ride"] = 103.64, ["Fly|Ride"] = 190.32, ["Neon"] = 339.94, ["Neon|Ride"] = 310.06, ["Neon|Fly|Ride"] = 824.92, ["Mega|Fly|Ride"] = 4124.53}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 311.63, ["Fly"] = 522.85, ["Ride"] = 371.26, ["Fly|Ride"] = 261.22, ["Neon|Fly|Ride"] = 1237.37, ["Mega|Fly|Ride"] = 4812.28}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 16.59, ["Fly"] = 52.5, ["Ride"] = 27.57, ["Fly|Ride"] = 65.63, ["Neon"] = 157.5, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 236.25, ["Mega|Fly|Ride"] = 777.95}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 253.32, ["Ride"] = 500.35, ["Fly|Ride"] = 472.4, ["Neon"] = 814.03, ["Neon|Ride"] = 824.92, ["Neon|Fly|Ride"] = 708.75, ["Mega"] = 4104.19, ["Mega|Ride"] = 4536.97, ["Mega|Fly|Ride"] = 3818.31}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 41.91, ["Fly"] = 125.98, ["Ride"] = 69.45, ["Fly|Ride"] = 123.76, ["Neon|Ride"] = 587.85, ["Neon|Fly|Ride"] = 550.65, ["Mega|Fly|Ride"] = 1732.5}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1870.32, ["Ride"] = 2231.25, ["Fly|Ride"] = 1640.63, ["Neon|Ride"] = 10886.4, ["Neon|Fly|Ride"] = 12373.55, ["Mega"] = 49494.14, ["Mega|Fly|Ride"] = 22230.1}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 13.31, ["Fly"] = 116.89, ["Ride"] = 40.23, ["Fly|Ride"] = 70.75, ["Neon"] = 51.89, ["Neon|Fly"] = 187.68, ["Neon|Ride"] = 76.32, ["Neon|Fly|Ride"] = 206.24, ["Mega"] = 344.08, ["Mega|Ride"] = 651, ["Mega|Fly|Ride"] = 463.63}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 52.79, ["Ride"] = 84.57, ["Fly|Ride"] = 125.74, ["Neon"] = 189, ["Neon|Ride"] = 344.42, ["Neon|Fly|Ride"] = 418.85, ["Mega"] = 1632.86, ["Mega|Fly|Ride"] = 1373.48}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 105, ["Fly"] = 78.7, ["Ride"] = 76.13, ["Fly|Ride"] = 97.13, ["Neon"] = 525, ["Neon|Ride"] = 481.55, ["Neon|Fly|Ride"] = 380.63, ["Mega|Fly|Ride"] = 1842.38}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 3439.26, ["Fly"] = 1556.91, ["Ride"] = 1073.63, ["Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 545.04, ["Fly|Ride"] = 656.25, ["Neon|Fly|Ride"] = 3110.58}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 83.29, ["Fly"] = 311.63, ["Ride"] = 137.82, ["Fly|Ride"] = 215.96, ["Neon"] = 444.29, ["Neon|Ride"] = 465.94, ["Neon|Fly|Ride"] = 538.13, ["Mega|Ride"] = 4124.53, ["Mega|Fly|Ride"] = 3438.83}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 7.5, ["Ride"] = 21.76, ["Fly|Ride"] = 103.13, ["Neon"] = 86.63, ["Neon|Fly"] = 138.18, ["Neon|Ride"] = 95.82, ["Neon|Fly|Ride"] = 196.88}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 38.17, ["Fly"] = 275.36, ["Ride"] = 54.57, ["Fly|Ride"] = 104.67, ["Neon"] = 262.5, ["Neon|Fly"] = 323.79, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 371.22, ["Mega"] = 2200.44, ["Mega|Fly|Ride"] = 1049.99}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 757.32, ["Ride"] = 874.13, ["Fly|Ride"] = 892.5, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2162.42, ["Mega|Fly|Ride"] = 9723}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 960.11}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 4921.88, ["Ride"] = 6159.98, ["Fly|Ride"] = 5569.58, ["Neon"] = 42000, ["Neon|Ride"] = 29553.16, ["Neon|Fly|Ride"] = 22968.75, ["Mega|Fly|Ride"] = 87990.27}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 313.59, ["Fly"] = 414.75, ["Neon"] = 1649.82, ["Neon|Ride"] = 2062.28, ["Neon|Fly|Ride"] = 2165.39, ["Mega"] = 6185.75}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 85.32, ["Fly"] = 275.36, ["Ride"] = 122.07, ["Fly|Ride"] = 336, ["Neon"] = 622.81, ["Neon|Ride"] = 687.78, ["Neon|Fly|Ride"] = 1645.7, ["Mega|Fly|Ride"] = 2118.98}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 10.7, ["Fly"] = 41.27, ["Ride"] = 37.98, ["Fly|Ride"] = 157.5, ["Neon"] = 111.57, ["Neon|Fly"] = 1244.44, ["Neon|Ride"] = 82.5, ["Neon|Fly|Ride"] = 258.83, ["Mega|Ride"] = 824.92, ["Mega|Fly|Ride"] = 687.78}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 12.99, ["Fly"] = 26.24, ["Ride"] = 20.78, ["Fly|Ride"] = 39.21, ["Neon"] = 206.24, ["Neon|Ride"] = 311.42, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 2200.44}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 16.26, ["Ride"] = 35.07, ["Fly|Ride"] = 139.97, ["Neon"] = 102.38, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 231, ["Mega"] = 670.69, ["Mega|Ride"] = 658.88, ["Mega|Fly|Ride"] = 654.94}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 6.54, ["Ride"] = 22.32, ["Fly|Ride"] = 48.47, ["Neon"] = 35.44, ["Neon|Ride"] = 55.7, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 275.34, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 311.42}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 23.26, ["Fly"] = 90.57, ["Ride"] = 39.26, ["Fly|Ride"] = 139.13, ["Neon"] = 223.13, ["Neon|Fly"] = 824.92, ["Neon|Ride"] = 249.37, ["Neon|Fly|Ride"] = 394.93, ["Mega"] = 630, ["Mega|Ride"] = 1260}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 384.63, ["Fly"] = 538.13, ["Ride"] = 434.37, ["Fly|Ride"] = 497.99, ["Neon"] = 1567.33, ["Neon|Ride"] = 1375.55, ["Neon|Fly|Ride"] = 1286.94, ["Mega"] = 7875, ["Mega|Fly|Ride"] = 11663.16}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 5.24, ["Fly"] = 18.8, ["Ride"] = 14.44, ["Fly|Ride"] = 31.42, ["Neon"] = 23.73, ["Neon|Ride"] = 33.23, ["Neon|Fly|Ride"] = 105, ["Mega"] = 824.92, ["Mega|Ride"] = 311.42, ["Mega|Fly|Ride"] = 249.61}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 45.93, ["Fly"] = 97.05, ["Ride"] = 69.21, ["Fly|Ride"] = 162.79, ["Neon"] = 229.67, ["Neon|Fly"] = 389.57, ["Neon|Ride"] = 210.37, ["Neon|Fly|Ride"] = 269.07, ["Mega"] = 575.05, ["Mega|Ride"] = 582.64, ["Mega|Fly|Ride"] = 631.17}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 794.07, ["Ride"] = 824.25, ["Fly|Ride"] = 820.32, ["Neon|Ride"] = 1603.88, ["Neon|Fly|Ride"] = 1575, ["Mega|Fly|Ride"] = 3934.86}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 36.66, ["Fly"] = 165.37, ["Ride"] = 53.5, ["Fly|Ride"] = 100.68, ["Neon"] = 220.68, ["Neon|Ride"] = 220.68, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 1575, ["Mega|Fly|Ride"] = 806.39}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 341.25, ["Fly"] = 380.7, ["Ride"] = 290.76, ["Fly|Ride"] = 345.19, ["Neon|Ride"] = 1555.88, ["Neon|Fly|Ride"] = 1375.55}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 164.07, ["Fly"] = 270.2, ["Ride"] = 196.27, ["Fly|Ride"] = 233.82, ["Neon|Ride"] = 1035.7, ["Neon|Fly|Ride"] = 848.23, ["Mega|Fly|Ride"] = 4640.09}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 787.5, ["Ride"] = 754.69, ["Fly|Ride"] = 786.19, ["Neon|Fly|Ride"] = 2997.5, ["Mega|Fly|Ride"] = 7611.19}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 21.66, ["Ride"] = 44.63, ["Fly|Ride"] = 111.56, ["Neon"] = 122.07, ["Neon|Fly"] = 279.92, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 270.6, ["Mega"] = 354.38, ["Mega|Ride"] = 302.9, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 4084.49, ["Ride"] = 3936.19, ["Fly|Ride"] = 3149.51, ["Neon"] = 13749.07, ["Neon|Fly|Ride"] = 5912.5, ["Mega|Fly|Ride"] = 24549.1}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 109.32, ["Fly"] = 166.28, ["Ride"] = 144.38, ["Fly|Ride"] = 196.72, ["Neon"] = 550.97, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 593.25, ["Mega|Fly|Ride"] = 2387.44}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.63, ["Fly"] = 27.81, ["Ride"] = 18.8, ["Fly|Ride"] = 33.85, ["Neon"] = 20.64, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 118.13, ["Mega|Fly"] = 446.25, ["Mega|Ride"] = 357.81, ["Mega|Fly|Ride"] = 244.13}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.86, ["Ride"] = 24.55, ["Fly|Ride"] = 57.71, ["Neon"] = 21, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 266.44, ["Mega"] = 161.49, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 369.15}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 26.25, ["Ride"] = 39.38, ["Fly|Ride"] = 56.34, ["Neon|Fly|Ride"] = 344.08, ["Mega|Fly|Ride"] = 1154.88}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 1181.25, ["Ride"] = 1361.28, ["Fly|Ride"] = 1298.07}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 6693.75, ["Fly|Ride"] = 6431.25}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 20.13, ["Fly"] = 35.6, ["Ride"] = 25.73, ["Fly|Ride"] = 47.25, ["Neon"] = 452.13, ["Neon|Ride"] = 275.34, ["Neon|Fly|Ride"] = 206.24, ["Mega"] = 2474.72, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 22.32, ["Fly"] = 41.27, ["Ride"] = 24.86, ["Fly|Ride"] = 74.43, ["Neon"] = 101.07, ["Neon|Ride"] = 109.65, ["Neon|Fly|Ride"] = 179.11, ["Mega"] = 662.17, ["Mega|Ride"] = 777.95, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 72.18, ["Fly"] = 157.5, ["Ride"] = 91.88, ["Fly|Ride"] = 112.88, ["Neon|Ride"] = 550.65, ["Neon|Fly|Ride"] = 441.68, ["Mega|Fly|Ride"] = 1581.09}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 267.74, ["Ride"] = 261.19, ["Fly|Ride"] = 316.32, ["Neon|Ride"] = 977.79, ["Neon|Fly|Ride"] = 1102.5, ["Mega|Fly|Ride"] = 5500.05}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.65, ["Ride"] = 30.34, ["Fly|Ride"] = 86.64, ["Neon"] = 26.83, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 102.1, ["Mega"] = 145.04, ["Mega|Ride"] = 191.23, ["Mega|Fly|Ride"] = 412.47}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 179.71, ["Ride"] = 229.69, ["Fly|Ride"] = 284.59, ["Neon"] = 755.6, ["Neon|Ride"] = 886.41, ["Neon|Fly|Ride"] = 843.94, ["Mega|Fly|Ride"] = 5315.63}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 2.62, ["Fly"] = 41.27, ["Ride"] = 16.43, ["Fly|Ride"] = 53.64, ["Neon"] = 22.26, ["Neon|Fly"] = 123.76, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 108.94, ["Mega"] = 263.61, ["Mega|Ride"] = 223.12, ["Mega|Fly|Ride"] = 316.57}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 309.4, ["Fly"] = 279.59, ["Ride"] = 311.41, ["Fly|Ride"] = 231.55, ["Neon|Fly|Ride"] = 705.18, ["Mega"] = 10311.29, ["Mega|Ride"] = 4675.15, ["Mega|Fly|Ride"] = 4809.19}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 10.25, ["Fly"] = 85.32, ["Ride"] = 27.09, ["Fly|Ride"] = 68.25, ["Neon"] = 97.54, ["Neon|Fly"] = 296.26, ["Neon|Ride"] = 152.62, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 480.53, ["Mega|Ride"] = 618.7, ["Mega|Fly|Ride"] = 449.5}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 3.39, ["Ride"] = 28.01, ["Fly|Ride"] = 65.54, ["Neon"] = 11.3, ["Neon|Fly"] = 170.45, ["Neon|Ride"] = 36.66, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 69.57, ["Mega|Ride"] = 115, ["Mega|Fly|Ride"] = 195.57}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.57, ["Neon"] = 4.87, ["Mega"] = 22.18, ["Mega|Ride"] = 148.5}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 3.71, ["Fly"] = 52.49, ["Ride"] = 39.38, ["Fly|Ride"] = 116.82, ["Neon"] = 7.54, ["Neon|Ride"] = 38.63, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 76.12, ["Mega|Fly"] = 155509.56, ["Mega|Ride"] = 98.84, ["Mega|Fly|Ride"] = 205.96}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 69.56, ["Fly"] = 525, ["Ride"] = 98.15, ["Fly|Ride"] = 164.07, ["Neon"] = 236.8, ["Neon|Ride"] = 295.31, ["Neon|Fly|Ride"] = 353.28, ["Mega|Fly|Ride"] = 1172.76}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 33.86, ["Ride"] = 15.73, ["Fly|Ride"] = 109.31, ["Neon"] = 8.23, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 129.94, ["Mega|Ride"] = 165.38, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 13.01, ["Ride"] = 162.87, ["Neon"] = 87.94, ["Neon|Ride"] = 299.25, ["Mega"] = 459.38}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 51.82, ["Neon|Fly|Ride"] = 275.34, ["Mega"] = 17.39, ["Mega|Ride"] = 54.51}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 60.51, ["Ride"] = 15.57, ["Fly|Ride"] = 35.07, ["Neon"] = 2.1, ["Neon|Fly"] = 18.38, ["Neon|Ride"] = 14.8, ["Neon|Fly|Ride"] = 37.86, ["Mega"] = 12.66, ["Mega|Fly"] = 31.38, ["Mega|Ride"] = 19.69, ["Mega|Fly|Ride"] = 66.5}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 18.15, ["Ride"] = 12.71, ["Fly|Ride"] = 81.38, ["Neon"] = 3.91, ["Neon|Fly"] = 39.37, ["Neon|Ride"] = 15.65, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 122.3, ["Mega|Ride"] = 1041.12}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Mega"] = 93.19, ["Mega|Ride"] = 109.65}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.63, ["Fly"] = 91.84, ["Ride"] = 20.94, ["Fly|Ride"] = 107.63, ["Neon"] = 6.57, ["Neon|Fly"] = 168, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 90.57, ["Mega"] = 23.63, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 70.13, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 3.84, ["Neon|Fly|Ride"] = 411.44, ["Mega"] = 18.43, ["Mega|Ride"] = 69.57, ["Mega|Fly|Ride"] = 206.24}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 2.17, ["Fly"] = 69.12, ["Ride"] = 26.25, ["Fly|Ride"] = 155.66, ["Neon"] = 11.68, ["Neon|Fly"] = 69.11, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 116.88, ["Mega"] = 129.94, ["Mega|Fly"] = 344.42, ["Mega|Ride"] = 124.64, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 50.94, ["Neon"] = 2.1, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 258.55, ["Mega"] = 15.23, ["Mega|Fly"] = 144.38, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 185.61}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.63, ["Fly|Ride"] = 524.99, ["Neon"] = 16.21, ["Mega"] = 188.4, ["Mega|Fly"] = 315}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.14, ["Ride"] = 27.57, ["Neon"] = 16.59, ["Neon|Ride"] = 70.49, ["Mega"] = 103.94, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 550.65}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 24.94, ["Neon"] = 3.62, ["Neon|Ride"] = 26.83, ["Neon|Fly|Ride"] = 138.18, ["Mega"] = 21, ["Mega|Ride"] = 40.82, ["Mega|Fly|Ride"] = 131.06}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 11.78, ["Fly|Ride"] = 32.71, ["Neon"] = 2.1, ["Neon|Fly"] = 16.56, ["Neon|Ride"] = 15.48, ["Neon|Fly|Ride"] = 32.44, ["Mega"] = 13.8, ["Mega|Fly"] = 39.19, ["Mega|Ride"] = 19.26, ["Mega|Fly|Ride"] = 49.26}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.1, ["Fly"] = 72.19, ["Ride"] = 229.68, ["Fly|Ride"] = 118.11, ["Neon"] = 34.92, ["Neon|Ride"] = 140.95, ["Mega|Ride"] = 240.19}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 23.4, ["Neon"] = 3.81, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 105, ["Mega"] = 26.23, ["Mega|Ride"] = 46.67, ["Mega|Fly|Ride"] = 136.7}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 2.88, ["Neon"] = 11.44, ["Neon|Fly|Ride"] = 138.18, ["Mega"] = 94.5, ["Mega|Ride"] = 164.99, ["Mega|Fly|Ride"] = 238.87}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.63, ["Fly"] = 91.88, ["Ride"] = 45.39, ["Fly|Ride"] = 187.68, ["Neon"] = 65.51, ["Neon|Ride"] = 55.7, ["Neon|Fly|Ride"] = 105, ["Mega"] = 124.59, ["Mega|Ride"] = 143.06, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 11.46, ["Ride"] = 11.23, ["Fly|Ride"] = 18.8, ["Neon"] = 2.1, ["Neon|Fly"] = 15.48, ["Neon|Ride"] = 13.01, ["Neon|Fly|Ride"] = 30.95, ["Mega"] = 13.96, ["Mega|Fly"] = 37.14, ["Mega|Ride"] = 23.63, ["Mega|Fly|Ride"] = 54.07}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 27.85, ["Ride"] = 27.39, ["Fly|Ride"] = 131.25, ["Neon"] = 17.43, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 196.47, ["Mega"] = 105, ["Mega|Ride"] = 156.3, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 6.56, ["Fly"] = 112.03, ["Ride"] = 22.22, ["Fly|Ride"] = 59.06, ["Neon"] = 77.24, ["Neon|Ride"] = 67.48, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 236.24, ["Mega|Ride"] = 329.97, ["Mega|Fly|Ride"] = 466.54}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 15.49, ["Ride"] = 12.34, ["Fly|Ride"] = 36.81, ["Neon"] = 2.1, ["Neon|Fly"] = 23.63, ["Neon|Ride"] = 14.42, ["Neon|Fly|Ride"] = 34.84, ["Mega"] = 26.83, ["Mega|Ride"] = 31.5, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.63, ["Fly"] = 172.24, ["Ride"] = 30.23, ["Neon"] = 7.88, ["Neon|Ride"] = 27.85, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 65.62, ["Mega|Fly"] = 164.99, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.63, ["Ride"] = 35.44, ["Neon"] = 6.03, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 138.18, ["Mega"] = 34.99, ["Mega|Fly"] = 138.18, ["Mega|Ride"] = 138.18, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Ride"] = 17.99, ["Neon"] = 2.1, ["Neon|Fly"] = 41.26, ["Neon|Ride"] = 34.12, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 19.69, ["Mega|Ride"] = 40.69, ["Mega|Fly|Ride"] = 172.93}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 91.88, ["Ride"] = 14.95, ["Fly|Ride"] = 42.02, ["Neon"] = 8.27, ["Neon|Fly"] = 53.09, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 57.66, ["Mega"] = 65.54, ["Mega|Ride"] = 85.6}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 53.26, ["Neon"] = 3.98, ["Neon|Ride"] = 62.06, ["Mega"] = 35.01, ["Mega|Fly|Ride"] = 307.3}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 19.95, ["Ride"] = 14.47, ["Fly|Ride"] = 72.19, ["Neon"] = 24.93, ["Neon|Ride"] = 25.14, ["Neon|Fly|Ride"] = 84, ["Mega"] = 92.15, ["Mega|Ride"] = 90.56, ["Mega|Fly|Ride"] = 309.36}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 2.63, ["Fly"] = 42, ["Ride"] = 36.26, ["Neon"] = 41.91, ["Neon|Fly"] = 188.89, ["Neon|Fly|Ride"] = 327.3, ["Mega"] = 98.44, ["Mega|Ride"] = 168.38}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Ride"] = 15.74, ["Fly|Ride"] = 57.48, ["Neon"] = 20.54, ["Neon|Fly"] = 55.7, ["Neon|Ride"] = 28.4, ["Neon|Fly|Ride"] = 137.64, ["Mega"] = 315, ["Mega|Fly"] = 420, ["Mega|Fly|Ride"] = 222.78}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 6.57, ["Fly"] = 21.26, ["Ride"] = 16.96, ["Fly|Ride"] = 45.93, ["Neon"] = 14.53, ["Neon|Fly"] = 84, ["Neon|Ride"] = 46.55, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 275.34, ["Mega|Fly"] = 192.84, ["Mega|Ride"] = 412.47, ["Mega|Fly|Ride"] = 550.65}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 109.32, ["Fly|Ride"] = 72.19, ["Neon"] = 71.31, ["Mega"] = 231.67, ["Mega|Ride"] = 236.24}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 14.8, ["Ride"] = 56.44, ["Neon"] = 262.39, ["Neon|Ride"] = 233.27, ["Mega|Ride"] = 687.78}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 2.3, ["Ride"] = 39.38, ["Neon"] = 41.26, ["Neon|Ride"] = 123.76, ["Mega"] = 261.92, ["Mega|Ride"] = 309.36}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 5.3, ["Ride"] = 45.94, ["Fly|Ride"] = 120.75, ["Neon"] = 33.11, ["Neon|Ride"] = 82.5, ["Mega"] = 466.54, ["Mega|Ride"] = 275.34, ["Mega|Fly|Ride"] = 360.29}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.9, ["Neon|Ride"] = 64.98, ["Mega"] = 23.1, ["Mega|Fly"] = 123.76, ["Mega|Ride"] = 123.76}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 40.04}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 3.82, ["Fly"] = 19.91, ["Ride"] = 16.99, ["Fly|Ride"] = 48.48, ["Neon"] = 39.38, ["Neon|Fly"] = 188.48, ["Neon|Ride"] = 41.26, ["Neon|Fly|Ride"] = 88.67, ["Mega"] = 374.32, ["Mega|Ride"] = 208.68, ["Mega|Fly|Ride"] = 291.8}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 92.84, ["Ride"] = 19.69, ["Neon"] = 2.96, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 25.09, ["Neon|Fly|Ride"] = 153.97, ["Mega"] = 52.5, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 90.96}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 47.45, ["Neon"] = 6.24, ["Neon|Ride"] = 33.11, ["Mega"] = 44.35, ["Mega|Ride"] = 70.2, ["Mega|Fly|Ride"] = 133.88}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.63, ["Fly"] = 48.48, ["Ride"] = 16.52, ["Fly|Ride"] = 55.65, ["Neon"] = 15.65, ["Neon|Ride"] = 22.7, ["Neon|Fly|Ride"] = 116.24, ["Mega"] = 122.72, ["Mega|Ride"] = 156.3, ["Mega|Fly|Ride"] = 187.68}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 14.42, ["Ride"] = 36.66, ["Fly|Ride"] = 57.75, ["Neon"] = 28.88, ["Neon|Ride"] = 49.5, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 344.42}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.24, ["Fly"] = 82.51, ["Ride"] = 26.25, ["Neon"] = 3.93, ["Mega"] = 20.67, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 60.38, ["Mega|Fly|Ride"] = 329.97}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 21.66, ["Ride"] = 15.32, ["Fly|Ride"] = 274967.76, ["Neon"] = 2.93, ["Neon|Fly"] = 109.31, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 35.44, ["Mega|Fly"] = 143.15, ["Mega|Ride"] = 43.42, ["Mega|Fly|Ride"] = 156.3}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 27.85, ["Ride"] = 13.12, ["Fly|Ride"] = 32.82, ["Neon"] = 3.93, ["Neon|Fly"] = 69.11, ["Neon|Ride"] = 18.14, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 47.95, ["Mega|Fly"] = 138.18, ["Mega|Ride"] = 56.44, ["Mega|Fly|Ride"] = 72.19}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 27.85, ["Ride"] = 51.83, ["Fly|Ride"] = 118.13, ["Neon"] = 3.26, ["Neon|Ride"] = 27.58, ["Neon|Fly|Ride"] = 111.87, ["Mega"] = 29.75, ["Mega|Ride"] = 79.58, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 164.99, ["Neon|Fly|Ride"] = 150220.32, ["Mega"] = 18.78, ["Mega|Fly"] = 106.45, ["Mega|Ride"] = 110.29, ["Mega|Fly|Ride"] = 410.41}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 45.87, ["Ride"] = 20.99, ["Fly|Ride"] = 50.17, ["Neon"] = 3.41, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 20.64, ["Neon|Fly|Ride"] = 83.99, ["Mega"] = 32.82, ["Mega|Fly"] = 61.88, ["Mega|Ride"] = 40.69, ["Mega|Fly|Ride"] = 111.37}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Neon"] = 2.62, ["Neon|Ride"] = 36.66, ["Mega"] = 27.57, ["Mega|Ride"] = 167.35}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.19, ["Neon|Ride"] = 296.26, ["Neon|Fly|Ride"] = 420, ["Mega"] = 25.54, ["Mega|Ride"] = 158.89, ["Mega|Fly|Ride"] = 187.99}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 18.78, ["Fly|Ride"] = 49.86, ["Neon"] = 5.25, ["Neon|Fly"] = 32.81, ["Neon|Ride"] = 17.01, ["Neon|Fly|Ride"] = 136.5, ["Mega"] = 123.76, ["Mega|Ride"] = 48.04, ["Mega|Fly|Ride"] = 93.55}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 13.86, ["Ride"] = 86.63, ["Neon"] = 515.58, ["Mega"] = 617.66, ["Mega|Ride"] = 906.38, ["Mega|Fly|Ride"] = 687.78}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 3.93, ["Fly"] = 6562.5, ["Ride"] = 82.5, ["Neon"] = 41.91}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 4.69, ["Ride"] = 30.33, ["Fly|Ride"] = 177.37, ["Neon"] = 27.43, ["Neon|Fly|Ride"] = 261.92, ["Mega"] = 397.94, ["Mega|Ride"] = 352.66, ["Mega|Fly|Ride"] = 375.26}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 12.97, ["Ride"] = 11.68, ["Fly|Ride"] = 22.84, ["Neon"] = 2.1, ["Neon|Fly"] = 14.59, ["Neon|Ride"] = 12.73, ["Neon|Fly|Ride"] = 20.94, ["Mega"] = 14.97, ["Mega|Fly"] = 22.81, ["Mega|Ride"] = 19.66, ["Mega|Fly|Ride"] = 49.7}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.63, ["Fly"] = 118.12, ["Ride"] = 65.63, ["Neon"] = 5.15, ["Neon|Fly"] = 67.76, ["Neon|Ride"] = 31.99, ["Neon|Fly|Ride"] = 687.78, ["Mega"] = 85.31, ["Mega|Ride"] = 118.02}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Ride"] = 31.01, ["Neon"] = 2.24, ["Neon|Fly"] = 30.95, ["Neon|Ride"] = 22.37, ["Neon|Fly|Ride"] = 82.5, ["Mega"] = 14.32, ["Mega|Ride"] = 69.56, ["Mega|Fly|Ride"] = 130.96}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 2.51, ["Neon|Fly"] = 60.89, ["Neon|Ride"] = 127.31, ["Mega"] = 17.49, ["Mega|Fly|Ride"] = 164.99}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 41.91, ["Ride"] = 16.69, ["Fly|Ride"] = 53.34, ["Neon"] = 9.75, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 89.6, ["Mega"] = 208.95, ["Mega|Ride"] = 391.84, ["Mega|Fly|Ride"] = 259.86}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 169.66, ["Ride"] = 212.63, ["Fly|Ride"] = 236.25, ["Mega"] = 8249.04, ["Mega|Fly|Ride"] = 3889.68}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.63, ["Ride"] = 17.52, ["Neon"] = 10.17, ["Neon|Ride"] = 82.5, ["Mega"] = 91.88, ["Mega|Ride"] = 164.99, ["Mega|Fly|Ride"] = 624.88}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 2.1, ["Fly"] = 64.97, ["Ride"] = 25.67, ["Fly|Ride"] = 57.29, ["Neon"] = 24.93, ["Neon|Ride"] = 93.33, ["Neon|Fly|Ride"] = 164.99, ["Mega"] = 356.43, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 408.34}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 15.11, ["Ride"] = 12.27, ["Fly|Ride"] = 32.34, ["Neon"] = 7.88, ["Neon|Fly"] = 27.85, ["Neon|Ride"] = 29.34, ["Neon|Fly|Ride"] = 32.19, ["Mega"] = 49.67, ["Mega|Ride"] = 81.38, ["Mega|Fly|Ride"] = 433.12}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 51.19, ["Ride"] = 23.78, ["Fly|Ride"] = 92.57, ["Neon"] = 6.24, ["Neon|Ride"] = 69.47, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 138.18, ["Mega|Ride"] = 185.61}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 6.33, ["Fly"] = 24.64, ["Ride"] = 15.06, ["Fly|Ride"] = 52.5, ["Neon"] = 46.67, ["Neon|Fly"] = 98.85, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 136.12, ["Mega|Ride"] = 271.2, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 4.62, ["Ride"] = 21, ["Fly|Ride"] = 249.55, ["Neon"] = 77.44, ["Neon|Ride"] = 140.34, ["Neon|Fly|Ride"] = 612.5, ["Mega"] = 412.47, ["Mega|Ride"] = 349.34, ["Mega|Fly|Ride"] = 1031.15}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.49, ["Fly"] = 23.12, ["Ride"] = 15.75, ["Fly|Ride"] = 27.85, ["Neon"] = 20.26, ["Neon|Fly"] = 76.04, ["Neon|Ride"] = 28.29, ["Neon|Fly|Ride"] = 52.41, ["Mega"] = 138.18, ["Mega|Fly|Ride"] = 311.42}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 55.44, ["Ride"] = 86.46, ["Fly|Ride"] = 148.32, ["Neon"] = 328.13, ["Neon|Fly"] = 437.07, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 406.88, ["Mega|Fly|Ride"] = 1244.48}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 223.11, ["Fly"] = 330.02, ["Ride"] = 249.38, ["Fly|Ride"] = 341.25, ["Neon|Ride"] = 2577.83, ["Neon|Fly|Ride"] = 1256.31, ["Mega"] = 10311.29, ["Mega|Fly|Ride"] = 4675.15}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 54.58, ["Fly"] = 138.21, ["Ride"] = 74.94, ["Fly|Ride"] = 111.57, ["Neon"] = 699.79, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 412.47, ["Mega|Fly|Ride"] = 1231.08}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 6.56, ["Fly"] = 287.89, ["Ride"] = 36.1, ["Fly|Ride"] = 138.18, ["Neon"] = 33.27, ["Neon|Ride"] = 119.27, ["Neon|Fly|Ride"] = 196.77, ["Mega"] = 309.72, ["Mega|Ride"] = 392.44, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 9.48, ["Fly"] = 69.12, ["Ride"] = 33.01, ["Fly|Ride"] = 59.63, ["Neon"] = 81.2, ["Neon|Ride"] = 126.26, ["Neon|Fly|Ride"] = 275.34, ["Mega"] = 312.36, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 1154.88}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 19.58, ["Ride"] = 12.6, ["Fly|Ride"] = 44.63, ["Neon"] = 4.69, ["Neon|Ride"] = 19.92, ["Neon|Fly|Ride"] = 58.2, ["Mega"] = 49.77, ["Mega|Fly"] = 154.88, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 5.92, ["Fly"] = 72.12, ["Ride"] = 18.19, ["Fly|Ride"] = 81.38, ["Neon"] = 110.35, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 150.56, ["Mega"] = 413.44, ["Mega|Ride"] = 820.8, ["Mega|Fly|Ride"] = 732.38}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 41.9, ["Ride"] = 15.21, ["Fly|Ride"] = 31.5, ["Neon"] = 11.81, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 28.66, ["Neon|Fly|Ride"] = 100.49, ["Mega"] = 179.43, ["Mega|Ride"] = 275.34, ["Mega|Fly|Ride"] = 173.25}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 2.1, ["Ride"] = 21.18, ["Fly|Ride"] = 328.13, ["Neon"] = 22.28, ["Neon|Ride"] = 65.54, ["Mega"] = 207.38, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 371.22}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 34.35, ["Ride"] = 131.25, ["Neon"] = 2.1, ["Neon|Ride"] = 19.65, ["Neon|Fly|Ride"] = 57.73, ["Mega"] = 15.74, ["Mega|Ride"] = 41.26, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 3.94, ["Fly"] = 18.71, ["Ride"] = 18.38, ["Fly|Ride"] = 41.26, ["Neon"] = 15.74, ["Neon|Fly"] = 36.75, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 147, ["Mega"] = 108.94, ["Mega|Fly|Ride"] = 204.1}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 3.34, ["Fly"] = 24.94, ["Ride"] = 19.69, ["Fly|Ride"] = 61.11, ["Neon"] = 42.58, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 550.65, ["Mega"] = 261.92, ["Mega|Ride"] = 195.92, ["Mega|Fly|Ride"] = 275.34}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 198.9, ["Fly"] = 179.82, ["Ride"] = 262.5, ["Fly|Ride"] = 334.69, ["Neon"] = 1050, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 742.43, ["Mega"] = 4124.53, ["Mega|Fly|Ride"] = 5250}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 7.79, ["Ride"] = 123.76, ["Fly|Ride"] = 124.81, ["Neon"] = 117.56, ["Neon|Ride"] = 98.42, ["Neon|Fly|Ride"] = 376.56, ["Mega"] = 444.94, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 41.1, ["Ride"] = 15.42, ["Fly|Ride"] = 45.28, ["Neon"] = 12.45, ["Neon|Ride"] = 26.82, ["Neon|Fly|Ride"] = 120.74, ["Mega"] = 233.27, ["Mega|Fly|Ride"] = 308.44}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 22.92, ["Ride"] = 41.32, ["Fly|Ride"] = 170.63, ["Neon"] = 210, ["Neon|Fly|Ride"] = 528.86, ["Mega"] = 674.38, ["Mega|Fly"] = 824.92, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 616.01}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 5.25}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 2.19, ["Ride"] = 31.5, ["Neon"] = 40.3, ["Neon|Ride"] = 275.34, ["Neon|Fly|Ride"] = 344.42, ["Mega"] = 567.14, ["Mega|Ride"] = 824.92, ["Mega|Fly|Ride"] = 901.23}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 25.03, ["Fly"] = 31.96, ["Ride"] = 29.84, ["Fly|Ride"] = 49.26, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 162.63, ["Neon|Fly|Ride"] = 168.87, ["Mega"] = 2062.28, ["Mega|Fly|Ride"] = 670.73}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 18.67, ["Neon"] = 3.92, ["Neon|Fly"] = 65.62, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 106.18, ["Mega"] = 31.49, ["Mega|Fly"] = 275.34, ["Mega|Ride"] = 64.62, ["Mega|Fly|Ride"] = 274.3}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 15.22, ["Fly"] = 27.85, ["Ride"] = 24.76, ["Fly|Ride"] = 61.88, ["Neon"] = 10.4, ["Neon|Ride"] = 233.27, ["Mega"] = 267.81, ["Mega|Fly"] = 389.57, ["Mega|Ride"] = 204.18}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.14, ["Fly"] = 32.82, ["Ride"] = 18.48, ["Fly|Ride"] = 45.55, ["Neon"] = 8.71, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 35, ["Neon|Fly|Ride"] = 64.37, ["Mega"] = 138.89, ["Mega|Ride"] = 138.18, ["Mega|Fly|Ride"] = 270.38}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 32.42, ["Fly|Ride"] = 206.24, ["Neon"] = 2.63, ["Neon|Ride"] = 23.39, ["Neon|Fly|Ride"] = 206.24, ["Mega"] = 24.05, ["Mega|Ride"] = 111.87, ["Mega|Fly|Ride"] = 311.42}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 68.82, ["Ride"] = 71.46, ["Fly|Ride"] = 179.43, ["Neon"] = 223.13, ["Neon|Fly|Ride"] = 576.19, ["Mega"] = 850.61, ["Mega|Ride"] = 933.07, ["Mega|Fly|Ride"] = 959.59}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Fly|Ride"] = 210, ["Neon"] = 92.26, ["Neon|Ride"] = 138.18, ["Mega|Ride"] = 524.99}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 7.87, ["Fly"] = 210, ["Ride"] = 18.44, ["Fly|Ride"] = 68.07, ["Neon"] = 17.9, ["Neon|Fly"] = 315, ["Neon|Ride"] = 40.36, ["Neon|Fly|Ride"] = 111.98, ["Mega"] = 190.98, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 111.57, ["Fly"] = 433.12, ["Ride"] = 393.73, ["Fly|Ride"] = 262.46, ["Neon"] = 328.13, ["Neon|Ride"] = 536.2, ["Mega|Ride"] = 2165.63, ["Mega|Fly|Ride"] = 1836.19}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 6.16, ["Fly"] = 32.69, ["Ride"] = 18.38, ["Fly|Ride"] = 55.99, ["Neon"] = 45.03, ["Neon|Ride"] = 57.77, ["Neon|Fly|Ride"] = 206.24, ["Mega"] = 216.57, ["Mega|Ride"] = 411.44, ["Mega|Fly|Ride"] = 638.72}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 66.94, ["Fly"] = 186.38, ["Ride"] = 84, ["Neon"] = 271.02, ["Neon|Ride"] = 223.12, ["Mega"] = 1113.63, ["Mega|Ride"] = 901.78, ["Mega|Fly|Ride"] = 1053.66}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 18.79, ["Ride"] = 52.15, ["Fly|Ride"] = 138.18, ["Neon"] = 81.81, ["Neon|Ride"] = 129.48, ["Neon|Fly|Ride"] = 225.37, ["Mega"] = 590.63, ["Mega|Ride"] = 366.19, ["Mega|Fly|Ride"] = 550.65}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 3.97, ["Fly"] = 104.13, ["Ride"] = 27.85, ["Fly|Ride"] = 61.88, ["Neon"] = 75.94, ["Neon|Ride"] = 90.45, ["Neon|Fly|Ride"] = 370.91, ["Mega"] = 412.47, ["Mega|Ride"] = 1546.71, ["Mega|Fly|Ride"] = 687.78}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 14.03, ["Ride"] = 66.01, ["Fly|Ride"] = 162.54, ["Neon"] = 65.63, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 438.38, ["Mega"] = 283.82, ["Mega|Ride"] = 297.39, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 5.92, ["Ride"] = 28.88, ["Fly|Ride"] = 65.2, ["Neon"] = 31.05, ["Neon|Ride"] = 54.33, ["Neon|Fly|Ride"] = 141.16, ["Mega"] = 245.44, ["Mega|Ride"] = 454.74, ["Mega|Fly|Ride"] = 411.98}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 57.1, ["Mega"] = 26.83, ["Mega|Ride"] = 123.76, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 6.54, ["Ride"] = 28.42, ["Neon"] = 22.56, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 202.78, ["Mega"] = 177.33, ["Mega|Ride"] = 206.24, ["Mega|Fly|Ride"] = 410.41}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.63, ["Fly"] = 122.74, ["Neon"] = 25.83, ["Mega"] = 169.98, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 3.93, ["Ride"] = 32.8, ["Fly|Ride"] = 116.64, ["Neon"] = 32.82, ["Neon|Ride"] = 82.95, ["Mega"] = 124.69, ["Mega|Ride"] = 275.34, ["Mega|Fly|Ride"] = 4124.53}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 610.32, ["Ride"] = 525, ["Fly|Ride"] = 695.62, ["Neon"] = 1779.74, ["Neon|Ride"] = 2062.28, ["Neon|Fly|Ride"] = 1968.75, ["Mega|Fly|Ride"] = 5880}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 2.63, ["Fly"] = 27.85, ["Ride"] = 19.2, ["Fly|Ride"] = 62.99, ["Neon"] = 40.23, ["Neon|Ride"] = 96.94, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 156.3, ["Mega|Ride"] = 356.91, ["Mega|Fly|Ride"] = 468.15}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 5.79, ["Fly"] = 524.69, ["Ride"] = 32.82, ["Fly|Ride"] = 56.35, ["Neon"] = 54.83, ["Neon|Fly"] = 315, ["Neon|Ride"] = 88.69, ["Neon|Fly|Ride"] = 160.88, ["Mega"] = 331.85, ["Mega|Ride"] = 412.47, ["Mega|Fly|Ride"] = 481.55}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 2.1, ["Fly"] = 15.49, ["Ride"] = 26.87, ["Fly|Ride"] = 309.36, ["Neon"] = 13.13, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 264.76}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.58, ["Ride"] = 21.61, ["Fly|Ride"] = 90.57, ["Neon"] = 7.44, ["Neon|Ride"] = 29.9, ["Neon|Fly|Ride"] = 103.83, ["Mega"] = 75.12, ["Mega|Fly"] = 211.78, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 210.5}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 69.12, ["Ride"] = 20.65, ["Neon"] = 3.56, ["Neon|Ride"] = 24.05, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 23.84, ["Mega|Ride"] = 64.37, ["Mega|Fly|Ride"] = 218.61}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1556.91}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 15.47, ["Ride"] = 48.2, ["Fly|Ride"] = 321.72, ["Neon"] = 57.74, ["Neon|Ride"] = 105, ["Mega"] = 550.65, ["Mega|Ride"] = 559.84, ["Mega|Fly|Ride"] = 849.66}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 25.85, ["Neon"] = 4.5, ["Neon|Ride"] = 74.26, ["Neon|Fly|Ride"] = 982.1, ["Mega"] = 39.26, ["Mega|Ride"] = 141.85, ["Mega|Fly|Ride"] = 264.76}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.1, ["Fly"] = 41.27, ["Ride"] = 19.69, ["Fly|Ride"] = 412.47, ["Neon"] = 19.69, ["Neon|Ride"] = 138.18, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 183.75, ["Mega|Ride"] = 366.24, ["Mega|Fly|Ride"] = 1031.15}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 488.25, ["Ride"] = 525, ["Fly|Ride"] = 556.5, ["Neon|Ride"] = 2168.2, ["Neon|Fly|Ride"] = 1706.25, ["Mega"] = 8553.77, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 3.03, ["Fly"] = 196.88, ["Fly|Ride"] = 412.47, ["Neon"] = 32.82, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 186.63, ["Mega"] = 481.55, ["Mega|Ride"] = 466.54, ["Mega|Fly|Ride"] = 669.48}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Fly"] = 91.04, ["Ride"] = 24.94, ["Fly|Ride"] = 118.13, ["Neon"] = 3.82, ["Neon|Ride"] = 34.44, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 35.95, ["Mega|Fly"] = 125.55, ["Mega|Ride"] = 70.83, ["Mega|Fly|Ride"] = 177.19}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Neon"] = 5.25, ["Neon|Ride"] = 28.39, ["Neon|Fly|Ride"] = 412.47, ["Mega"] = 32.82, ["Mega|Ride"] = 134.78, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 15.52, ["Fly"] = 107.9, ["Ride"] = 79.95, ["Fly|Ride"] = 87.28, ["Neon"] = 127.56, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 367.5, ["Mega|Ride"] = 605.3, ["Mega|Fly|Ride"] = 595.88}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 7.94, ["Ride"] = 71.31, ["Neon"] = 96.48, ["Neon|Ride"] = 123.76, ["Neon|Fly|Ride"] = 918.75, ["Mega"] = 393.75, ["Mega|Ride"] = 477.75, ["Mega|Fly|Ride"] = 618.7}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 6.57, ["Ride"] = 31.39, ["Fly|Ride"] = 412.47, ["Neon"] = 311.25, ["Neon|Ride"] = 176.12, ["Mega"] = 638, ["Mega|Fly|Ride"] = 1237.37}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 11.57, ["Ride"] = 23.15, ["Fly|Ride"] = 262.5, ["Neon"] = 167.37, ["Neon|Ride"] = 182.44, ["Neon|Fly|Ride"] = 206.24, ["Mega"] = 616.63, ["Mega|Ride"] = 1300.69, ["Mega|Fly|Ride"] = 687.78}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 346.5, ["Ride"] = 481.55, ["Fly|Ride"] = 751.11, ["Neon"] = 918.75, ["Neon|Ride"] = 1375.55, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 4124.53}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 10.34, ["Fly"] = 78.74, ["Ride"] = 20.01, ["Fly|Ride"] = 236.25, ["Neon"] = 129.84, ["Neon|Ride"] = 205.22, ["Mega"] = 824.92, ["Mega|Ride"] = 729.1, ["Mega|Fly|Ride"] = 851.73}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 8.36, ["Ride"] = 126, ["Neon"] = 52.61, ["Neon|Ride"] = 221.82, ["Mega"] = 218.61, ["Mega|Ride"] = 344.42, ["Mega|Fly|Ride"] = 1031.15}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 21, ["Ride"] = 69.57, ["Neon"] = 79.91, ["Neon|Ride"] = 129.66, ["Neon|Fly|Ride"] = 260.78, ["Mega"] = 275.63, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 334.59}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.63, ["Ride"] = 78.39, ["Neon"] = 10.5, ["Neon|Ride"] = 157.5, ["Mega"] = 47.12, ["Mega|Ride"] = 125.57, ["Mega|Fly|Ride"] = 295.32}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 43.44, ["Ride"] = 106.32, ["Neon"] = 481.55, ["Neon|Ride"] = 223.13, ["Mega"] = 1632.86, ["Mega|Ride"] = 1399.6, ["Mega|Fly|Ride"] = 1499.28}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 583.56, ["Ride"] = 26.25, ["Neon"] = 10.5, ["Neon|Fly"] = 179.43, ["Neon|Ride"] = 78.46, ["Neon|Fly|Ride"] = 145.91, ["Mega"] = 101.07, ["Mega|Ride"] = 107.63, ["Mega|Fly|Ride"] = 391.79}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 89.74, ["Ride"] = 31.5, ["Fly|Ride"] = 157.5, ["Neon"] = 6.03, ["Neon|Ride"] = 47.16, ["Neon|Fly|Ride"] = 97.89, ["Mega"] = 82.5, ["Mega|Fly"] = 101.49, ["Mega|Ride"] = 73.5, ["Mega|Fly|Ride"] = 170.46}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Ride"] = 38.07, ["Fly|Ride"] = 127.52, ["Neon"] = 14.44, ["Neon|Ride"] = 59.81, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 109.65, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 311.42}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 36.58, ["Fly"] = 93.38, ["Ride"] = 60.24, ["Fly|Ride"] = 266.04, ["Neon"] = 291.38, ["Neon|Ride"] = 300.38, ["Neon|Fly|Ride"] = 466.54, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 419.99, ["Ride"] = 291.27, ["Fly|Ride"] = 411.44, ["Neon"] = 1433.29, ["Neon|Ride"] = 1100.23, ["Neon|Fly|Ride"] = 1399.6, ["Mega"] = 9330.55, ["Mega|Fly|Ride"] = 4410}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 15.49, ["Neon"] = 31.42, ["Neon|Fly"] = 350.44, ["Neon|Fly|Ride"] = 105, ["Mega"] = 98.44, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.63, ["Fly"] = 138.21, ["Ride"] = 32.82, ["Neon"] = 15.48, ["Neon|Ride"] = 45.85, ["Mega"] = 62.41, ["Mega|Fly"] = 210, ["Mega|Ride"] = 102.37, ["Mega|Fly|Ride"] = 241.5}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 6.57, ["Fly"] = 156.4, ["Ride"] = 27.57, ["Neon"] = 32.81, ["Neon|Ride"] = 69.11, ["Mega|Ride"] = 348.23}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 3.83, ["Fly"] = 70, ["Ride"] = 39.19, ["Fly|Ride"] = 367.11, ["Neon"] = 8.81, ["Neon|Ride"] = 46.35, ["Neon|Fly|Ride"] = 152.62, ["Mega"] = 124.2, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 90.76, ["Neon"] = 8.54, ["Neon|Fly|Ride"] = 188.72, ["Mega"] = 39.73, ["Mega|Fly|Ride"] = 272.23}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 65.54, ["Ride"] = 17.71, ["Fly|Ride"] = 52.49, ["Neon"] = 7.01, ["Neon|Fly"] = 78.16, ["Neon|Ride"] = 27.85, ["Neon|Fly|Ride"] = 412.47, ["Mega|Ride"] = 95.72, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 3.75, ["Fly"] = 138.21, ["Ride"] = 15.89, ["Fly|Ride"] = 61.69, ["Neon"] = 17.07, ["Neon|Fly"] = 64.97, ["Neon|Ride"] = 26.57, ["Neon|Fly|Ride"] = 93.33, ["Mega"] = 156.15, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 166.51}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 27.57, ["Ride"] = 31.37, ["Fly|Ride"] = 78.66, ["Neon|Fly|Ride"] = 466.54, ["Mega"] = 1134.25, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 548.79}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 63, ["Ride"] = 78.65, ["Fly|Ride"] = 124.52, ["Neon"] = 511.46, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 3346.14, ["Mega|Fly|Ride"] = 1938.53}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.37, ["Ride"] = 17.88, ["Fly|Ride"] = 131.25, ["Neon"] = 3.94, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 27.56, ["Mega"] = 37, ["Mega|Fly"] = 672, ["Mega|Ride"] = 92.8}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 14.22, ["Ride"] = 13.55, ["Fly|Ride"] = 36.66, ["Neon"] = 3.94, ["Neon|Fly"] = 28.37, ["Neon|Ride"] = 23.75, ["Neon|Fly|Ride"] = 61.68, ["Mega"] = 61.58, ["Mega|Fly"] = 131.21, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 129.94}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 4.69, ["Ride"] = 73.5, ["Neon"] = 17.07, ["Neon|Ride"] = 124.68, ["Neon|Fly|Ride"] = 275.34, ["Mega"] = 527.63, ["Mega|Ride"] = 481.55, ["Mega|Fly|Ride"] = 622.82}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 393.75, ["Fly"] = 518.44, ["Ride"] = 472.5, ["Fly|Ride"] = 721.81, ["Mega|Fly|Ride"] = 7775.84}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 23.63, ["Fly"] = 101.33, ["Ride"] = 50.58, ["Fly|Ride"] = 98.44, ["Neon"] = 236.25, ["Neon|Ride"] = 210.74, ["Neon|Fly|Ride"] = 305.81, ["Mega|Ride"] = 1237.37, ["Mega|Fly|Ride"] = 917.9}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 25.85, ["Fly|Ride"] = 281.29, ["Neon"] = 9.45, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 309.36, ["Mega"] = 77.44, ["Mega|Ride"] = 131.24, ["Mega|Fly|Ride"] = 283.58}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.63, ["Fly"] = 91.88, ["Ride"] = 65.61, ["Fly|Ride"] = 143.05, ["Neon"] = 13.11}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 40.59, ["Fly"] = 169.3, ["Ride"] = 37.72, ["Fly|Ride"] = 65.63, ["Neon"] = 194.25, ["Neon|Ride"] = 466.54, ["Neon|Fly|Ride"] = 264.99, ["Mega"] = 2474.72, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1237.37}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 99.91, ["Ride"] = 108.94, ["Fly|Ride"] = 412.47, ["Neon"] = 434.43, ["Neon|Fly|Ride"] = 610.32, ["Mega"] = 8249.04, ["Mega|Fly|Ride"] = 2227.25}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 242.01, ["Ride"] = 264.24, ["Fly|Ride"] = 514.55, ["Neon"] = 1050, ["Neon|Ride"] = 1365, ["Neon|Fly|Ride"] = 1340.48, ["Mega|Fly|Ride"] = 3574.93}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 11.44, ["Fly"] = 51.81, ["Ride"] = 55.7, ["Fly|Ride"] = 117.56, ["Neon"] = 77.18, ["Neon|Ride"] = 118.13, ["Mega"] = 436.35, ["Mega|Ride"] = 392.44, ["Mega|Fly|Ride"] = 512.3}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 17.2, ["Ride"] = 15.18, ["Fly|Ride"] = 41.91, ["Neon"] = 11.22, ["Neon|Ride"] = 21.76, ["Neon|Fly|Ride"] = 89.73, ["Mega"] = 84.28, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 170.24}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 3.13, ["Fly"] = 39.11, ["Ride"] = 15.89, ["Fly|Ride"] = 58.33, ["Neon"] = 44.34, ["Neon|Ride"] = 44.3, ["Neon|Fly|Ride"] = 109.31, ["Mega|Ride"] = 422.22, ["Mega|Fly|Ride"] = 366.19}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 301.88, ["Fly"] = 481.61, ["Ride"] = 336.3, ["Fly|Ride"] = 436.21, ["Neon"] = 1968.75, ["Neon|Ride"] = 2150.35, ["Mega"] = 9898.84, ["Mega|Fly|Ride"] = 5754.61}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Neon"] = 6.07, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 64.32, ["Mega|Ride"] = 170.99}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 4.29, ["Ride"] = 13.79, ["Fly|Ride"] = 55.13, ["Neon"] = 22.2, ["Neon|Ride"] = 47.16, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 227.89, ["Mega|Ride"] = 179.43, ["Mega|Fly|Ride"] = 294}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 14.19, ["Ride"] = 46.71, ["Neon"] = 104.99, ["Neon|Ride"] = 236.24, ["Neon|Fly|Ride"] = 296.26, ["Mega"] = 527.7, ["Mega|Ride"] = 649.69, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 158.81, ["Fly"] = 210.39, ["Ride"] = 121.8, ["Fly|Ride"] = 166.59, ["Neon"] = 638.28, ["Neon|Ride"] = 699.81, ["Neon|Fly|Ride"] = 654.94, ["Mega|Fly|Ride"] = 2378.25}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 16.59, ["Fly"] = 43.29, ["Ride"] = 27.85, ["Fly|Ride"] = 60.97, ["Neon"] = 102.1, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 687.78, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 545.4}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 20.65, ["Neon"] = 2.63, ["Neon|Ride"] = 138.18, ["Mega"] = 23.63, ["Mega|Ride"] = 275.34, ["Mega|Fly|Ride"] = 275.34}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Fly"] = 39.37, ["Ride"] = 19.69, ["Fly|Ride"] = 72.19, ["Neon"] = 2.63, ["Neon|Ride"] = 19.85, ["Neon|Fly|Ride"] = 75.51, ["Mega"] = 26.63, ["Mega|Fly"] = 97.12, ["Mega|Ride"] = 49.89, ["Mega|Fly|Ride"] = 129.93}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 9.59, ["Ride"] = 76.32, ["Fly|Ride"] = 131.18, ["Neon"] = 32.82, ["Neon|Fly"] = 144.38, ["Neon|Ride"] = 78.56, ["Neon|Fly|Ride"] = 181.9, ["Mega"] = 159.22, ["Mega|Ride"] = 202.02, ["Mega|Fly|Ride"] = 319.7}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1610.6, ["Ride"] = 1351.88, ["Fly|Ride"] = 1309.87, ["Neon"] = 4589.36, ["Neon|Ride"] = 3845.63, ["Neon|Fly|Ride"] = 3794.81, ["Mega|Fly|Ride"] = 12589.5}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 408.84, ["Fly"] = 918.75, ["Ride"] = 479.07, ["Fly|Ride"] = 639.27, ["Neon"] = 2421.11, ["Neon|Ride"] = 2571.64, ["Neon|Fly|Ride"] = 2362.5, ["Mega"] = 16498.06, ["Mega|Fly|Ride"] = 9349.25}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 301.76, ["Ride"] = 359.88, ["Fly|Ride"] = 429.07, ["Neon"] = 656.25, ["Neon|Ride"] = 721.77, ["Neon|Fly|Ride"] = 786.19, ["Mega|Fly|Ride"] = 2916.24}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 301.88, ["Ride"] = 342.48, ["Fly|Ride"] = 420, ["Neon|Ride"] = 4665.28, ["Neon|Fly|Ride"] = 989.89}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 64.32, ["Ride"] = 15.64, ["Fly|Ride"] = 38.71, ["Neon"] = 7.86, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 104.9, ["Mega"] = 68.41, ["Mega|Ride"] = 138.18, ["Mega|Fly|Ride"] = 200.82}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 421.31, ["Fly"] = 1375.71, ["Ride"] = 675.76, ["Fly|Ride"] = 943.95, ["Neon"] = 1706.25, ["Neon|Ride"] = 1365, ["Neon|Fly|Ride"] = 1952.97, ["Mega|Ride"] = 6599.23, ["Mega|Fly|Ride"] = 4331.25}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 5.25, ["Fly"] = 183.75, ["Ride"] = 35.07, ["Fly|Ride"] = 112.54, ["Neon"] = 20.99, ["Neon|Ride"] = 206.24, ["Neon|Fly|Ride"] = 252, ["Mega"] = 137.45, ["Mega|Ride"] = 204.75, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 39.37, ["Ride"] = 20.65, ["Fly|Ride"] = 31.98, ["Neon"] = 7.88, ["Neon|Ride"] = 27.85, ["Neon|Fly|Ride"] = 138.18, ["Mega"] = 104.81, ["Mega|Ride"] = 192.93}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 54.91, ["Neon"] = 3.8, ["Neon|Ride"] = 39.37, ["Mega"] = 41.26, ["Mega|Ride"] = 196.77}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 129.51, ["Fly|Ride"] = 459.38, ["Neon"] = 235.75, ["Neon|Ride"] = 351.29, ["Mega"] = 1050, ["Mega|Ride"] = 488.25, ["Mega|Fly|Ride"] = 773.07}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.63, ["Fly"] = 41.27, ["Ride"] = 26.83, ["Fly|Ride"] = 68.24, ["Neon"] = 73.5, ["Mega|Ride"] = 424.55, ["Mega|Fly|Ride"] = 412.47}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.13, ["Neon"] = 3.41, ["Neon|Ride"] = 40.32, ["Neon|Fly|Ride"] = 90.22, ["Mega"] = 24.95, ["Mega|Ride"] = 67.93, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.1, ["Fly"] = 34.04, ["Ride"] = 16.49, ["Fly|Ride"] = 78.65, ["Neon"] = 13.12, ["Neon|Fly"] = 113.9, ["Neon|Ride"] = 44.54, ["Neon|Fly|Ride"] = 104.9, ["Mega"] = 110.87, ["Mega|Fly"] = 279.93, ["Mega|Ride"] = 128.63, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 4.1, ["Fly"] = 91.77, ["Ride"] = 19.23, ["Fly|Ride"] = 52.5, ["Neon"] = 35.07, ["Neon|Ride"] = 138.18, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 237.57, ["Mega|Ride"] = 300.53, ["Mega|Fly|Ride"] = 1321.69}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 9.37, ["Ride"] = 17.51, ["Neon"] = 85.32, ["Mega"] = 506.19, ["Mega|Ride"] = 413.44, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.1, ["Fly"] = 6225.26, ["Ride"] = 27.85, ["Fly|Ride"] = 42.83, ["Neon"] = 187.58, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 314.99, ["Neon|Fly|Ride"] = 699.81, ["Mega"] = 301.88, ["Mega|Ride"] = 481.55, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 64.16, ["Ride"] = 18.38, ["Fly|Ride"] = 45.94, ["Neon"] = 3.67, ["Neon|Fly"] = 82.48, ["Neon|Ride"] = 24.76, ["Neon|Fly|Ride"] = 69.11, ["Mega"] = 59.81, ["Mega|Ride"] = 176.12, ["Mega|Fly|Ride"] = 309.36}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 155.76, ["Ride"] = 178.4, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 886.78, ["Neon|Fly|Ride"] = 1036.87, ["Mega"] = 8249.04, ["Mega|Ride"] = 4124.53, ["Mega|Fly|Ride"] = 2756.25}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 18.36, ["Ride"] = 14.44, ["Fly|Ride"] = 28.49, ["Neon"] = 2.62, ["Neon|Ride"] = 19.83, ["Neon|Fly|Ride"] = 56.25, ["Mega"] = 44.63, ["Mega|Ride"] = 52.65, ["Mega|Fly|Ride"] = 194.25}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 6.38, ["Ride"] = 42.36, ["Fly|Ride"] = 183.75, ["Neon"] = 96.94, ["Neon|Ride"] = 133.84, ["Neon|Fly|Ride"] = 164.99, ["Mega"] = 466.54, ["Mega|Fly"] = 777.95, ["Mega|Fly|Ride"] = 1031.15}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 34.18, ["Ride"] = 93.32, ["Fly|Ride"] = 170.63, ["Neon"] = 189.58, ["Neon|Ride"] = 275.34, ["Mega"] = 963.09, ["Mega|Ride"] = 1025.2, ["Mega|Fly|Ride"] = 1160.51}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 171.75, ["Ride"] = 253.45, ["Fly|Ride"] = 309.28, ["Neon"] = 874.13, ["Neon|Fly|Ride"] = 922.88, ["Mega|Fly|Ride"] = 3638.92}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 16.58, ["Fly|Ride"] = 138.18, ["Neon"] = 156.3, ["Mega"] = 287.44, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 687.78}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 8.37, ["Fly|Ride"] = 179.43, ["Neon"] = 412.47, ["Neon|Ride"] = 199, ["Neon|Fly|Ride"] = 218.12, ["Mega"] = 771.89, ["Mega|Ride"] = 824.92, ["Mega|Fly|Ride"] = 963.09}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 1512.87, ["Ride"] = 1043.44, ["Fly|Ride"] = 1251.04, ["Neon"] = 4675.15, ["Neon|Ride"] = 4790.63, ["Neon|Fly|Ride"] = 4647.3, ["Mega|Fly|Ride"] = 18106.61}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 9.08, ["Fly"] = 19.68, ["Ride"] = 19.79, ["Fly|Ride"] = 90.99, ["Neon"] = 26.25, ["Neon|Fly"] = 96.84, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 206.24, ["Mega"] = 233.27, ["Mega|Fly|Ride"] = 347.82}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 5.25, ["Fly"] = 51.19, ["Ride"] = 35.44, ["Fly|Ride"] = 135.19, ["Neon"] = 34.49, ["Neon|Ride"] = 60.66, ["Mega"] = 200.06, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 248.36}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Fly"] = 90.37, ["Ride"] = 25.34, ["Fly|Ride"] = 89.73, ["Neon"] = 10.03, ["Neon|Ride"] = 47.16, ["Mega"] = 110.35, ["Mega|Ride"] = 240.62, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 12.57, ["Ride"] = 28.98, ["Fly|Ride"] = 81.92, ["Neon"] = 100.32, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 141.56, ["Mega"] = 435.2, ["Mega|Ride"] = 431.82, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 3.84, ["Fly"] = 32.82, ["Ride"] = 20.55, ["Fly|Ride"] = 51.1, ["Neon"] = 22.18, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 35.07, ["Neon|Fly|Ride"] = 108.94, ["Mega|Fly"] = 247.49, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 290.79}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 7.88, ["Ride"] = 14.97, ["Neon"] = 12.21, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 52.61, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 177.37, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 344.42}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 466.86, ["Ride"] = 231, ["Fly|Ride"] = 2062.28, ["Neon|Fly|Ride"] = 1375.55}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 22.7, ["Fly|Ride"] = 107.25, ["Neon"] = 7.48, ["Neon|Ride"] = 32.02, ["Neon|Fly|Ride"] = 148.14, ["Mega"] = 90.99, ["Mega|Fly"] = 412.47, ["Mega|Ride"] = 122.84, ["Mega|Fly|Ride"] = 275.34}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 3.23, ["Fly|Ride"] = 88.86, ["Neon"] = 138.18, ["Neon|Ride"] = 188.27, ["Mega"] = 124.69, ["Mega|Ride"] = 237.57}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 2.1, ["Fly"] = 96.95, ["Ride"] = 26.25, ["Neon"] = 20.66, ["Neon|Ride"] = 51.18, ["Mega"] = 99.75, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 484.03}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["Fly|Ride"] = 824.92, ["Mega|Ride"] = 4949.43, ["Mega|Fly|Ride"] = 4331.25}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 25.64, ["Fly|Ride"] = 206.24, ["Neon"] = 149.5, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 498.75, ["Mega|Fly|Ride"] = 889.88}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 18.77, ["Fly"] = 74.7, ["Ride"] = 30.97, ["Fly|Ride"] = 90.57, ["Neon"] = 97.67, ["Neon|Ride"] = 164.99, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 687.78, ["Mega|Ride"] = 421.32, ["Mega|Fly|Ride"] = 540.28}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 4.23, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 209.99, ["Mega"] = 52.5, ["Mega|Ride"] = 275.33, ["Mega|Fly|Ride"] = 237.18}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 42.46, ["Fly"] = 138.21, ["Ride"] = 77.44, ["Fly|Ride"] = 182.31, ["Neon"] = 262.48, ["Neon|Fly"] = 344.42, ["Neon|Ride"] = 325.85, ["Neon|Fly|Ride"] = 298.83, ["Mega|Fly|Ride"] = 1169.32}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 19.47, ["Fly|Ride"] = 32.16, ["Neon"] = 5, ["Neon|Ride"] = 55.7, ["Neon|Fly|Ride"] = 122.72, ["Mega"] = 58.9}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 18.18, ["Fly"] = 138.21, ["Ride"] = 28.61, ["Fly|Ride"] = 88.69, ["Neon"] = 89.73, ["Neon|Ride"] = 125.15, ["Neon|Fly|Ride"] = 247.49, ["Mega"] = 275.34, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 412.47, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 43.19, ["Fly"] = 110.15, ["Ride"] = 81.53, ["Neon"] = 183.75, ["Neon|Ride"] = 311.42, ["Neon|Fly|Ride"] = 411.44, ["Mega|Ride"] = 1926.17, ["Mega|Fly|Ride"] = 1226.47}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 27.85, ["Ride"] = 13.85, ["Fly|Ride"] = 35.44, ["Neon"] = 2.63, ["Neon|Fly"] = 23.73, ["Neon|Ride"] = 17.56, ["Neon|Fly|Ride"] = 32.61, ["Mega"] = 17.07, ["Mega|Ride"] = 28.77, ["Mega|Fly|Ride"] = 86.63}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 2.45, ["Ride"] = 52.5, ["Fly|Ride"] = 129.93, ["Neon"] = 16.29, ["Neon|Ride"] = 61.88, ["Neon|Fly|Ride"] = 412.47, ["Mega"] = 227.89, ["Mega|Ride"] = 274.98, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 20.64, ["Ride"] = 59.07, ["Neon"] = 111.57, ["Neon|Ride"] = 550.65, ["Mega"] = 536.71, ["Mega|Ride"] = 459.37, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 26.83, ["Neon"] = 2.63, ["Neon|Ride"] = 28.86, ["Neon|Fly|Ride"] = 95.8, ["Mega"] = 19.1, ["Mega|Ride"] = 65.54}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 10.52, ["Fly"] = 189.5, ["Ride"] = 69.57, ["Fly|Ride"] = 164.07, ["Neon"] = 74.46, ["Neon|Ride"] = 120.96, ["Neon|Fly|Ride"] = 411.44, ["Mega"] = 536.65, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 738.43}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 18.77, ["Fly"] = 103.69, ["Ride"] = 26.48, ["Fly|Ride"] = 98.44, ["Neon"] = 388.53, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 129.94, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 3.57, ["Ride"] = 18.12, ["Neon"] = 31.29, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 130.19, ["Mega"] = 233.62, ["Mega|Ride"] = 240.19, ["Mega|Fly|Ride"] = 403.18}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 11.82, ["Fly"] = 2062.53, ["Ride"] = 83.99, ["Neon"] = 206.24, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 6219.97, ["Mega"] = 466.54, ["Mega|Ride"] = 442.32}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Ride"] = 18.8, ["Fly|Ride"] = 196.88, ["Neon"] = 6.57, ["Neon|Ride"] = 32.43, ["Mega"] = 69.44, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 150.56, ["Mega|Fly|Ride"] = 275.34}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 55.53, ["Neon"] = 3.5, ["Mega"] = 27.57, ["Mega|Ride"] = 138.18, ["Mega|Fly|Ride"] = 261.17}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 31.5}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 34.44, ["Fly"] = 78.75, ["Ride"] = 39.38, ["Neon"] = 235.11, ["Neon|Ride"] = 282.97, ["Neon|Fly|Ride"] = 313.69, ["Mega"] = 1649.82, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 889.88}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.68, ["Neon|Ride"] = 109.31, ["Mega"] = 23.73, ["Mega|Ride"] = 119.6, ["Mega|Fly|Ride"] = 299.25}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 446.25, ["Fly"] = 498.75, ["Ride"] = 1155, ["Fly|Ride"] = 641.82, ["Neon"] = 2750.03, ["Mega"] = 16498.06, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 2.8, ["Fly"] = 26.24, ["Ride"] = 24.45, ["Fly|Ride"] = 66.26, ["Neon"] = 30.98, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 95.85, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 550.65}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 3.04, ["Fly"] = 52.5, ["Ride"] = 20.99, ["Fly|Ride"] = 69.33, ["Neon"] = 24.95, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 149, ["Mega|Ride"] = 179.43, ["Mega|Fly|Ride"] = 234.69}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 181.53, ["Ride"] = 50.3, ["Fly|Ride"] = 106.32, ["Neon"] = 126, ["Neon|Ride"] = 168.09, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 824.92, ["Mega|Ride"] = 879.38}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 2.63, ["Ride"] = 27.85, ["Fly|Ride"] = 721.88, ["Neon"] = 25.26, ["Neon|Ride"] = 118.13, ["Mega"] = 262.5}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 9.55, ["Fly"] = 138.21, ["Ride"] = 42, ["Fly|Ride"] = 173.23, ["Neon"] = 118.13, ["Neon|Ride"] = 177.37, ["Neon|Fly|Ride"] = 359.29, ["Mega|Ride"] = 404.92, ["Mega|Fly|Ride"] = 798.11}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 6.12, ["Ride"] = 51.93, ["Fly|Ride"] = 133.88, ["Neon"] = 32.45, ["Neon|Ride"] = 76.32, ["Neon|Fly|Ride"] = 204.75, ["Mega"] = 321.72, ["Mega|Fly"] = 550.65, ["Mega|Ride"] = 344.08, ["Mega|Fly|Ride"] = 370.41}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 46.71, ["Ride"] = 11.82, ["Fly|Ride"] = 69.11, ["Neon"] = 2.1, ["Neon|Fly"] = 58.79, ["Neon|Ride"] = 15.38, ["Neon|Fly|Ride"] = 123.76, ["Mega"] = 15.65, ["Mega|Ride"] = 31.99, ["Mega|Fly|Ride"] = 139.79}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 6.45, ["Fly"] = 52.61, ["Ride"] = 32.61, ["Fly|Ride"] = 103.13, ["Neon"] = 40.76, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 220.68, ["Mega"] = 196.85, ["Mega|Ride"] = 217.88, ["Mega|Fly|Ride"] = 469.23}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 294.96, ["Ride"] = 298.86, ["Fly|Ride"] = 433.13, ["Neon"] = 1312.5, ["Neon|Ride"] = 1404.38, ["Neon|Fly|Ride"] = 1252.12, ["Mega|Ride"] = 5052.54, ["Mega|Fly|Ride"] = 5073.16}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 81.37, ["Ride"] = 210, ["Fly|Ride"] = 7561.28, ["Neon"] = 536.47, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 574.41, ["Mega"] = 2200.44, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1704.94}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 16.85, ["Ride"] = 15.22, ["Fly|Ride"] = 41.26, ["Neon"] = 136.12, ["Neon|Fly"] = 69.11, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 63.31, ["Mega|Fly"] = 205.22, ["Mega|Ride"] = 156.3, ["Mega|Fly|Ride"] = 259.23}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 27.85, ["Ride"] = 14.44, ["Fly|Ride"] = 32.45, ["Neon"] = 10.49, ["Neon|Fly"] = 41.26, ["Neon|Ride"] = 23.1, ["Neon|Fly|Ride"] = 55.04, ["Mega"] = 96.94, ["Mega|Ride"] = 116.82, ["Mega|Fly|Ride"] = 241.5}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.1, ["Ride"] = 22.32, ["Fly|Ride"] = 98.44, ["Neon"] = 45.85, ["Mega"] = 206.24, ["Mega|Ride"] = 412.47}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 257.25, ["Fly"] = 420, ["Ride"] = 304.2, ["Fly|Ride"] = 367.5, ["Neon|Ride"] = 1047.63, ["Neon|Fly|Ride"] = 1526.09, ["Mega|Ride"] = 8249.04, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.1, ["Fly"] = 19.84, ["Ride"] = 15.75, ["Fly|Ride"] = 32.81, ["Neon"] = 17.07, ["Neon|Fly"] = 105, ["Neon|Ride"] = 40.43, ["Neon|Fly|Ride"] = 247.49, ["Mega"] = 255.94, ["Mega|Ride"] = 311.42, ["Mega|Fly|Ride"] = 360.91}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 6.15, ["Ride"] = 98.44, ["Fly|Ride"] = 206.24, ["Neon"] = 56.6, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 275.34, ["Mega"] = 299.25, ["Mega|Ride"] = 288.65, ["Mega|Fly|Ride"] = 441.34}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 27.85, ["Neon"] = 5.07, ["Neon|Ride"] = 156.09, ["Mega"] = 81.81, ["Mega|Ride"] = 206.24}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 12.88, ["Fly"] = 55.7, ["Ride"] = 19.55, ["Fly|Ride"] = 74.81, ["Neon"] = 80.75, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 588.78, ["Mega|Ride"] = 438.38, ["Mega|Fly|Ride"] = 782.64}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 39.78, ["Ride"] = 89.25, ["Fly|Ride"] = 296.71, ["Neon"] = 152.62, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 179.43, ["Neon|Fly|Ride"] = 353.07, ["Mega"] = 465.77, ["Mega|Fly"] = 2165.39, ["Mega|Ride"] = 520.41, ["Mega|Fly|Ride"] = 528.94}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 20.98, ["Ride"] = 55.7, ["Fly|Ride"] = 91.88, ["Neon"] = 154.69, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 210.37, ["Neon|Fly|Ride"] = 309.36, ["Mega|Ride"] = 933.07, ["Mega|Fly|Ride"] = 866.25}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 20.65, ["Ride"] = 14.91, ["Fly|Ride"] = 26.25, ["Neon"] = 2.63, ["Neon|Fly"] = 17.47, ["Neon|Ride"] = 15.31, ["Neon|Fly|Ride"] = 47.15, ["Mega"] = 20.96, ["Mega|Fly"] = 412.47, ["Mega|Ride"] = 35.07, ["Mega|Fly|Ride"] = 98.44}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 296.45, ["Ride"] = 280.88, ["Fly|Ride"] = 371.16, ["Neon"] = 1444.42, ["Neon|Fly|Ride"] = 1237.37, ["Mega|Fly|Ride"] = 3379.69}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 12.93, ["Fly"] = 101.18, ["Ride"] = 42.37, ["Fly|Ride"] = 105, ["Neon"] = 144.38, ["Neon|Ride"] = 39.82, ["Neon|Fly|Ride"] = 328.12, ["Mega|Ride"] = 699.81, ["Mega|Fly|Ride"] = 777.95}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 30.68, ["Ride"] = 16.96, ["Fly|Ride"] = 42.09, ["Neon"] = 5.91, ["Neon|Fly"] = 36.42, ["Neon|Ride"] = 27.35, ["Neon|Fly|Ride"] = 109.31, ["Mega"] = 59.07, ["Mega|Fly"] = 275.34, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 211.78}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 30.96, ["Ride"] = 15.54, ["Fly|Ride"] = 43.28, ["Neon"] = 3.59, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 27.85, ["Neon|Fly|Ride"] = 115.86, ["Mega"] = 24.76, ["Mega|Fly"] = 138.18, ["Mega|Ride"] = 55.7, ["Mega|Fly|Ride"] = 181.79}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.96, ["Ride"] = 28.65, ["Fly|Ride"] = 69.29, ["Neon"] = 8.75, ["Neon|Fly"] = 699.79, ["Neon|Ride"] = 70, ["Mega"] = 128.39, ["Mega|Fly|Ride"] = 373.24}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 7.13, ["Fly"] = 27.85, ["Ride"] = 26.8, ["Fly|Ride"] = 58.97, ["Neon"] = 54.9, ["Neon|Fly"] = 261.92, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 93.19, ["Mega"] = 464.21, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 10.28, ["Ride"] = 18.38, ["Neon"] = 69.11, ["Mega"] = 275.63, ["Mega|Ride"] = 311.42, ["Mega|Fly|Ride"] = 410.41}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 43.31, ["Neon"] = 3.94, ["Neon|Ride"] = 31.4, ["Neon|Fly|Ride"] = 100.65, ["Mega"] = 31.08, ["Mega|Ride"] = 70.88, ["Mega|Fly|Ride"] = 174.57}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 8.64, ["Ride"] = 25.15, ["Fly|Ride"] = 131.25, ["Neon"] = 28.88, ["Neon|Fly"] = 102.92, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 105.19, ["Mega"] = 210, ["Mega|Ride"] = 200.82, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 210, ["Neon"] = 2.91, ["Neon|Ride"] = 45.77, ["Neon|Fly|Ride"] = 102.31, ["Mega"] = 27.57, ["Mega|Ride"] = 101.07, ["Mega|Fly|Ride"] = 138.18}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 41.46, ["Ride"] = 16.69, ["Fly|Ride"] = 39.38, ["Neon"] = 4.97, ["Neon|Ride"] = 20.88, ["Neon|Fly|Ride"] = 124.82, ["Mega"] = 52.41, ["Mega|Fly"] = 138.18, ["Mega|Ride"] = 86.4, ["Mega|Fly|Ride"] = 274.76}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 656.12, ["Ride"] = 820.32, ["Fly|Ride"] = 825.57, ["Neon|Ride"] = 3577.1, ["Neon|Fly|Ride"] = 3299.62, ["Mega|Fly|Ride"] = 17873.58}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 19.22, ["Ride"] = 14.02, ["Fly|Ride"] = 40.05, ["Neon"] = 18.36, ["Neon|Fly"] = 138.18, ["Neon|Ride"] = 35.79, ["Neon|Fly|Ride"] = 72.19, ["Mega|Fly|Ride"] = 344.42}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.1, ["Ride"] = 26.16, ["Fly|Ride"] = 275.34, ["Neon"] = 8.33, ["Neon|Fly"] = 721.81, ["Neon|Ride"] = 88.55, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 53.82, ["Mega|Ride"] = 134.03, ["Mega|Fly|Ride"] = 240.66}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 5.91, ["Fly"] = 40.66, ["Ride"] = 19.83, ["Fly|Ride"] = 48.64, ["Neon"] = 41.06, ["Neon|Fly"] = 189.38, ["Neon|Ride"] = 69.11, ["Neon|Fly|Ride"] = 107.62, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 328.11}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 20.11, ["Ride"] = 15.48, ["Fly|Ride"] = 44.35, ["Neon"] = 9.05, ["Neon|Fly"] = 137.13, ["Neon|Ride"] = 23.62, ["Neon|Fly|Ride"] = 69.24, ["Mega"] = 65.01, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 99.75, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 26.16, ["Ride"] = 72.19, ["Fly|Ride"] = 275.34, ["Neon"] = 316.57, ["Neon|Ride"] = 263.61, ["Mega"] = 918.75}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 19.68, ["Fly|Ride"] = 64.05, ["Neon"] = 7.88, ["Neon|Fly"] = 141.75, ["Neon|Ride"] = 31.4, ["Neon|Fly|Ride"] = 142.31, ["Mega"] = 61.88, ["Mega|Ride"] = 116.55, ["Mega|Fly|Ride"] = 264.76}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 3.78, ["Fly"] = 124.89, ["Ride"] = 19.66, ["Fly|Ride"] = 53.64, ["Neon"] = 12.22, ["Neon|Ride"] = 41.89, ["Neon|Fly|Ride"] = 110.35, ["Mega"] = 114.19, ["Mega|Ride"] = 198.58, ["Mega|Fly|Ride"] = 474.34}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.63, ["Neon"] = 36.18, ["Mega"] = 93.33, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 375.38}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 42, ["Ride"] = 15.73, ["Fly|Ride"] = 49.86, ["Neon"] = 5.25, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 99.42, ["Mega"] = 52.5, ["Mega|Fly"] = 229.68, ["Mega|Ride"] = 62.28, ["Mega|Fly|Ride"] = 164.99}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 11.9, ["Fly"] = 17.31, ["Ride"] = 19.81, ["Fly|Ride"] = 42.5, ["Neon"] = 311.41, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 98.43, ["Mega"] = 824.92}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 833.44, ["Ride"] = 918.75, ["Fly|Ride"] = 926.63, ["Neon"] = 1729.93, ["Neon|Ride"] = 1909.69, ["Neon|Fly|Ride"] = 2163, ["Mega"] = 8249.04, ["Mega|Fly|Ride"] = 7464.43}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 18.42, ["Fly|Ride"] = 33.39, ["Neon"] = 6.57, ["Neon|Ride"] = 16.69, ["Neon|Fly|Ride"] = 51.89, ["Mega"] = 33.73, ["Mega|Ride"] = 57.66, ["Mega|Fly|Ride"] = 136.43}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 5.25, ["Ride"] = 36.72, ["Fly|Ride"] = 201.92, ["Neon"] = 39.38, ["Neon|Ride"] = 112.5, ["Neon|Fly|Ride"] = 210, ["Mega"] = 366.18, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 481.55}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 45.73, ["Ride"] = 77.35, ["Fly|Ride"] = 110.25, ["Neon|Ride"] = 389.82, ["Neon|Fly|Ride"] = 498.75, ["Mega"] = 3162.49, ["Mega|Fly|Ride"] = 2742.81}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 27.83, ["Ride"] = 32.82, ["Fly|Ride"] = 104.89, ["Neon|Ride"] = 206.24, ["Neon|Fly|Ride"] = 687.78, ["Mega"] = 983.89, ["Mega|Ride"] = 896.44, ["Mega|Fly|Ride"] = 816.38}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 6.68, ["Ride"] = 26.23, ["Fly|Ride"] = 139.71, ["Neon"] = 59.07, ["Neon|Ride"] = 90.57, ["Neon|Fly|Ride"] = 121.47, ["Mega"] = 288.75, ["Mega|Fly|Ride"] = 547.77}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["Ride"] = 55.7, ["Neon"] = 138.18, ["Neon|Ride"] = 358.07, ["Mega"] = 337.98, ["Mega|Fly"] = 506.19, ["Mega|Ride"] = 385.66, ["Mega|Fly|Ride"] = 511.46}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 19.69, ["Fly"] = 126.89, ["Neon"] = 420, ["Neon|Ride"] = 317.01, ["Neon|Fly|Ride"] = 525, ["Mega"] = 924, ["Mega|Fly|Ride"] = 674.38}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 16.3}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 13.13, ["Fly"] = 131248.69, ["Ride"] = 16.62, ["Fly|Ride"] = 85.32, ["Neon"] = 31.2, ["Neon|Ride"] = 101.49, ["Neon|Fly|Ride"] = 179.43, ["Mega"] = 190.26, ["Mega|Fly"] = 466.08, ["Mega|Ride"] = 214.49, ["Mega|Fly|Ride"] = 466.54}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.17, ["Ride"] = 46.85, ["Neon"] = 11.7, ["Mega"] = 138.18}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 53.64, ["Fly"] = 412.52, ["Ride"] = 110.36, ["Fly|Ride"] = 94.22, ["Neon"] = 273, ["Neon|Ride"] = 189, ["Neon|Fly|Ride"] = 933.07, ["Mega|Ride"] = 1649.82, ["Mega|Fly|Ride"] = 1072.39}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 10.49, ["Fly"] = 17.56, ["Ride"] = 15.24, ["Fly|Ride"] = 38.11, ["Neon"] = 25.43, ["Neon|Fly"] = 69.11, ["Neon|Ride"] = 31.24, ["Neon|Fly|Ride"] = 73.5, ["Mega"] = 129.94, ["Mega|Ride"] = 195.46, ["Mega|Fly|Ride"] = 251.22}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 4.16, ["Fly"] = 146.46, ["Ride"] = 27.42, ["Fly|Ride"] = 55.7, ["Neon"] = 18.59, ["Neon|Ride"] = 42.26, ["Neon|Fly|Ride"] = 118.11, ["Mega"] = 129.94, ["Mega|Ride"] = 169.25, ["Mega|Fly|Ride"] = 262.47}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 6.57, ["Mega"] = 42.5, ["Mega|Ride"] = 195.83}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 29.02, ["Fly"] = 77.17, ["Ride"] = 65.63, ["Fly|Ride"] = 89.15, ["Neon"] = 210, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 284.61, ["Mega|Ride"] = 13749.07, ["Mega|Fly|Ride"] = 824.92}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 38.96, ["Fly|Ride"] = 65.63, ["Neon"] = 5.92, ["Neon|Ride"] = 66.49, ["Mega"] = 72.1, ["Mega|Ride"] = 118.12, ["Mega|Fly|Ride"] = 462.2}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 6.56, ["Fly"] = 52.5, ["Ride"] = 78.16, ["Fly|Ride"] = 274.3, ["Neon"] = 104.97, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 656.25, ["Mega|Fly|Ride"] = 550.65}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.63, ["Fly"] = 45.91, ["Ride"] = 14.95, ["Fly|Ride"] = 40.63, ["Neon"] = 18.6, ["Neon|Ride"] = 35.6, ["Neon|Fly|Ride"] = 75.87, ["Mega|Ride"] = 206.73, ["Mega|Fly|Ride"] = 249.61}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 5.15, ["Fly"] = 52.49, ["Ride"] = 19.3, ["Fly|Ride"] = 71.36, ["Neon"] = 26.25, ["Neon|Ride"] = 45.94, ["Mega|Ride"] = 412.47, ["Mega|Fly|Ride"] = 412.47}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 6.55, ["Ride"] = 70, ["Neon"] = 78, ["Neon|Ride"] = 157.55, ["Mega"] = 469.19, ["Mega|Ride"] = 933.07}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 39.37, ["Ride"] = 109.65, ["Neon"] = 233.63, ["Neon|Fly|Ride"] = 561.59, ["Mega|Ride"] = 1649.82, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 15.63, ["Ride"] = 65.54, ["Neon"] = 99.02, ["Neon|Ride"] = 262.5, ["Mega"] = 452.91, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 5.25, ["Ride"] = 144.27, ["Neon"] = 162.75, ["Mega|Ride"] = 823.89}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 17.27, ["Ride"] = 232.32, ["Fly|Ride"] = 367.46, ["Neon"] = 145.53, ["Neon|Ride"] = 721.81, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 616.88, ["Mega|Fly"] = 2062.28, ["Mega|Fly|Ride"] = 1089.36}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 2.59, ["Neon"] = 20.64, ["Mega"] = 131.25, ["Mega|Fly|Ride"] = 311.42}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 18.38, ["Fly|Ride"] = 63, ["Neon"] = 5.56, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 96.81, ["Mega"] = 82.5, ["Mega|Ride"] = 121.69, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 3.83, ["Fly"] = 50.5, ["Ride"] = 275.34, ["Fly|Ride"] = 65.63, ["Neon"] = 15.46, ["Neon|Ride"] = 41.26, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 102.53, ["Mega|Ride"] = 156.3, ["Mega|Fly|Ride"] = 237.18}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 20.65, ["Ride"] = 15.46, ["Fly|Ride"] = 56.25, ["Neon"] = 9.18, ["Neon|Ride"] = 27.46, ["Neon|Fly|Ride"] = 78.16, ["Mega"] = 55.12, ["Mega|Fly"] = 164.99, ["Mega|Ride"] = 76.56, ["Mega|Fly|Ride"] = 275.34}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.63, ["Fly"] = 65.62, ["Ride"] = 26.25, ["Fly|Ride"] = 118.13, ["Neon"] = 24.76, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 256.77, ["Mega"] = 328.13, ["Mega|Ride"] = 329.97, ["Mega|Fly|Ride"] = 466.54}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 19.69, ["Fly"] = 65.63, ["Ride"] = 19.69, ["Fly|Ride"] = 103.69, ["Neon"] = 28.88, ["Neon|Fly"] = 466.53, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 196.88, ["Mega|Fly|Ride"] = 1237.37}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 2.14, ["Fly"] = 131.25, ["Ride"] = 24.76, ["Fly|Ride"] = 60.41, ["Neon"] = 26.25, ["Neon|Fly"] = 111.55, ["Neon|Ride"] = 28.25, ["Neon|Fly|Ride"] = 78.66, ["Mega"] = 227.64, ["Mega|Fly|Ride"] = 396.38}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 33.72, ["Ride"] = 18.58, ["Fly|Ride"] = 51.69, ["Neon"] = 26.83, ["Neon|Fly"] = 82.5, ["Neon|Ride"] = 69.11, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 252.82, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 247.49}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 4.32, ["Fly"] = 57.66, ["Ride"] = 42.95, ["Fly|Ride"] = 131.25, ["Neon"] = 24.03, ["Neon|Fly"] = 437.07, ["Neon|Ride"] = 94.5, ["Neon|Fly|Ride"] = 128.44, ["Mega"] = 138.18, ["Mega|Fly"] = 156.3, ["Mega|Fly|Ride"] = 261.86}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 22.18, ["Fly"] = 206.27, ["Ride"] = 103.94, ["Fly|Ride"] = 468.57, ["Neon"] = 105, ["Neon|Fly"] = 433.13, ["Neon|Ride"] = 313.69, ["Neon|Fly|Ride"] = 519.03, ["Mega"] = 498.75, ["Mega|Ride"] = 711.5, ["Mega|Fly|Ride"] = 669.38}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 49.85, ["Fly"] = 164.07, ["Ride"] = 90.53, ["Fly|Ride"] = 480.53, ["Neon"] = 267.07, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 480.54, ["Mega"] = 1511.66, ["Mega|Ride"] = 1061.82, ["Mega|Fly|Ride"] = 1221.94}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 50.96, ["Ride"] = 19.61, ["Fly|Ride"] = 64.97, ["Neon"] = 2.25, ["Neon|Ride"] = 23.49, ["Mega"] = 39.38, ["Mega|Ride"] = 71.04, ["Mega|Fly|Ride"] = 148.32}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 63.95, ["Mega|Fly|Ride"] = 963.09}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 50.23, ["Ride"] = 91.89, ["Neon"] = 411.44, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 823.89, ["Mega"] = 1690.04}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 8, ["Fly"] = 190.32, ["Ride"] = 53.64, ["Fly|Ride"] = 133.88, ["Neon"] = 36.62, ["Neon|Ride"] = 65.63, ["Mega"] = 144.38, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 385.66}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 2.51, ["Ride"] = 61.85, ["Fly|Ride"] = 138.18, ["Neon"] = 10.5, ["Neon|Ride"] = 65.63, ["Mega"] = 64.66, ["Mega|Fly"] = 341.25, ["Mega|Ride"] = 129.29, ["Mega|Fly|Ride"] = 351.16}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.63, ["Fly"] = 27.55, ["Ride"] = 22.7, ["Fly|Ride"] = 37.69, ["Neon"] = 11.82, ["Neon|Ride"] = 40.39, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 124.82, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 205.22}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 16.75, ["Ride"] = 17.07, ["Fly|Ride"] = 40.85, ["Neon"] = 2.49, ["Neon|Fly"] = 17.77, ["Neon|Ride"] = 24.93, ["Neon|Fly|Ride"] = 36.75, ["Mega"] = 21, ["Mega|Ride"] = 69.55}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 15.48, ["Fly|Ride"] = 32.61, ["Neon"] = 3.94, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 124.69, ["Mega"] = 74.42, ["Mega|Ride"] = 56.44, ["Mega|Fly|Ride"] = 275.34}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.48, ["Neon"] = 2.63, ["Neon|Ride"] = 145.08, ["Mega"] = 25.74, ["Mega|Ride"] = 101.07, ["Mega|Fly|Ride"] = 315.54}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 10.5, ["Ride"] = 104.98, ["Neon"] = 30.35, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 618.7, ["Mega|Ride"] = 269.48, ["Mega|Fly|Ride"] = 311.42}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 4.94, ["Ride"] = 31.62, ["Fly|Ride"] = 206.24, ["Neon"] = 49.88, ["Neon|Ride"] = 202.96, ["Neon|Fly|Ride"] = 288.75, ["Mega|Ride"] = 412.47, ["Mega|Fly|Ride"] = 1016.71}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 7.08, ["Fly"] = 25.79, ["Ride"] = 21, ["Fly|Ride"] = 47.12, ["Neon"] = 26.25, ["Neon|Fly"] = 69.11, ["Neon|Ride"] = 38.17, ["Neon|Fly|Ride"] = 82.46, ["Mega|Ride"] = 272.93, ["Mega|Fly|Ride"] = 360.39}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 131.25, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 446.15}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 52.5, ["Fly"] = 82.67, ["Ride"] = 65.63, ["Neon"] = 282.71, ["Neon|Fly|Ride"] = 630, ["Mega"] = 622.82, ["Mega|Ride"] = 866.92, ["Mega|Fly|Ride"] = 1044.1}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 14.44, ["Fly|Ride"] = 38.07, ["Neon"] = 2.63, ["Neon|Fly"] = 41.26, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 61.88, ["Mega|Fly|Ride"] = 87.94}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 15.12, ["Ride"] = 13.13, ["Fly|Ride"] = 27.44, ["Neon"] = 3.91, ["Neon|Fly"] = 26.88, ["Neon|Ride"] = 18.1, ["Neon|Fly|Ride"] = 46.1, ["Mega"] = 44.63, ["Mega|Fly"] = 82.5, ["Mega|Ride"] = 56.32, ["Mega|Fly|Ride"] = 102.38}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 451.49, ["Ride"] = 534.19, ["Fly|Ride"] = 557.81, ["Neon|Fly|Ride"] = 1884.09}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 8.38, ["Ride"] = 56.25, ["Fly|Ride"] = 535.41, ["Neon"] = 30.19, ["Neon|Ride"] = 80.31, ["Mega"] = 357.2, ["Mega|Ride"] = 674.38, ["Mega|Fly|Ride"] = 274967.76}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 15.43, ["Fly|Ride"] = 26.25, ["Neon"] = 3.82, ["Neon|Fly"] = 26.83, ["Neon|Ride"] = 15.48, ["Neon|Fly|Ride"] = 44.63, ["Mega"] = 138.18, ["Mega|Ride"] = 74.11, ["Mega|Fly|Ride"] = 105.44}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 58.7, ["Ride"] = 138.18, ["Fly|Ride"] = 515.58, ["Neon"] = 261.09, ["Neon|Ride"] = 282.56, ["Neon|Fly|Ride"] = 1134.25, ["Mega"] = 719.25, ["Mega|Ride"] = 1048.95, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 3.94, ["Fly"] = 37.14, ["Ride"] = 16.2, ["Fly|Ride"] = 47.77, ["Neon"] = 28.46, ["Neon|Fly"] = 52.52, ["Neon|Ride"] = 29.92, ["Neon|Fly|Ride"] = 70.86, ["Mega"] = 105, ["Mega|Ride"] = 130.17, ["Mega|Fly|Ride"] = 206.07}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 69.57, ["Ride"] = 43.33, ["Neon"] = 3.23, ["Neon|Ride"] = 35.43, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 20.9, ["Mega|Ride"] = 61.28, ["Mega|Fly|Ride"] = 190.88}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 43.97, ["Fly"] = 108.05, ["Ride"] = 89.73, ["Fly|Ride"] = 194.97, ["Neon"] = 212.43, ["Neon|Ride"] = 191.26, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 787.5, ["Mega|Ride"] = 708.75, ["Mega|Fly|Ride"] = 1072.39}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Ride"] = 22.7, ["Neon"] = 6.82, ["Neon|Ride"] = 39.99, ["Mega"] = 123.76, ["Mega|Ride"] = 191.02, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 34.48, ["Ride"] = 69.44, ["Fly|Ride"] = 138.18, ["Neon"] = 329.97, ["Neon|Fly|Ride"] = 466.54, ["Mega"] = 1629.2, ["Mega|Ride"] = 1649.82, ["Mega|Fly|Ride"] = 1511.66}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 2.1, ["Ride"] = 183.74, ["Neon"] = 19.57, ["Neon|Ride"] = 46.67, ["Neon|Fly|Ride"] = 152.62, ["Mega"] = 156.19, ["Mega|Ride"] = 131.25}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.49, ["Fly"] = 69.12, ["Ride"] = 72.75, ["Fly|Ride"] = 69.11, ["Neon"] = 7.88, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 183.75, ["Mega|Ride"] = 1089.36, ["Mega|Fly|Ride"] = 550.65}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 36.14, ["Ride"] = 115.5, ["Fly|Ride"] = 515.58, ["Mega|Ride"] = 2784.06, ["Mega|Fly|Ride"] = 1647.75}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 278.93, ["Ride"] = 20.94, ["Fly|Ride"] = 908.98, ["Neon"] = 5.23, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 49.88, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 94.54, ["Mega|Fly|Ride"] = 181.92}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 14.36, ["Ride"] = 19.69, ["Fly|Ride"] = 101.82, ["Neon"] = 13.13, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 196.88, ["Mega|Fly|Ride"] = 275.34}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 8.43, ["Fly"] = 58.49, ["Ride"] = 32.69, ["Fly|Ride"] = 75.78, ["Neon"] = 81.78, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 148.14, ["Mega"] = 431.03, ["Mega|Ride"] = 404.73, ["Mega|Fly|Ride"] = 466.54}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 14.79, ["Fly"] = 57.11, ["Ride"] = 55.7, ["Fly|Ride"] = 71.31, ["Neon"] = 102.1, ["Neon|Fly"] = 138.18, ["Neon|Ride"] = 80.45, ["Neon|Fly|Ride"] = 152.62, ["Mega"] = 902.25, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 856.09}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 23.07, ["Fly"] = 51.19, ["Ride"] = 26.25, ["Fly|Ride"] = 62.99, ["Neon"] = 56.03, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 156.3, ["Mega"] = 550.65, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 424.85}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 69.02, ["Fly"] = 139.36, ["Ride"] = 121, ["Fly|Ride"] = 247.49, ["Neon"] = 347.82, ["Neon|Ride"] = 468.15, ["Neon|Fly|Ride"] = 705.31, ["Mega"] = 1399.6, ["Mega|Ride"] = 1512.68, ["Mega|Fly|Ride"] = 1299.38}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 3.44, ["Ride"] = 55.7, ["Neon"] = 23.63, ["Neon|Ride"] = 116.53, ["Neon|Fly|Ride"] = 311.42, ["Mega"] = 223.13, ["Mega|Fly|Ride"] = 385.66}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 7.79, ["Ride"] = 27.2, ["Fly|Ride"] = 78.74, ["Neon"] = 26.83, ["Neon|Ride"] = 82.5, ["Neon|Fly|Ride"] = 123.76, ["Mega"] = 206.24, ["Mega|Ride"] = 183.74, ["Mega|Fly|Ride"] = 466.54}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 9.85, ["Fly"] = 275.36, ["Ride"] = 24.03, ["Fly|Ride"] = 108.73, ["Neon"] = 47.04, ["Neon|Ride"] = 206.24, ["Neon|Fly|Ride"] = 233.27, ["Mega"] = 454.74, ["Mega|Ride"] = 638}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.23, ["Ride"] = 12.55, ["Fly|Ride"] = 30.55, ["Neon"] = 2.1, ["Neon|Fly"] = 19.69, ["Neon|Ride"] = 13.32, ["Neon|Fly|Ride"] = 37.68, ["Mega"] = 15.65, ["Mega|Ride"] = 27.54, ["Mega|Fly|Ride"] = 93.82}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 55.79, ["Ride"] = 78.75, ["Fly|Ride"] = 275.34, ["Neon"] = 408.21, ["Neon|Fly"] = 2337.59, ["Neon|Ride"] = 294, ["Neon|Fly|Ride"] = 488.15, ["Mega"] = 3093.4, ["Mega|Ride"] = 945, ["Mega|Fly|Ride"] = 866.25}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 20.64, ["Fly|Ride"] = 35.07, ["Neon"] = 2.88, ["Neon|Ride"] = 27.44, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 260.89, ["Mega|Ride"] = 138.18, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.63, ["Fly"] = 27.85, ["Ride"] = 15.74, ["Fly|Ride"] = 51.7, ["Neon"] = 30.95, ["Neon|Ride"] = 30.66, ["Neon|Fly|Ride"] = 119.62, ["Mega|Ride"] = 138.18, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 74.82, ["Fly"] = 157.5, ["Ride"] = 131.25, ["Fly|Ride"] = 258.56, ["Neon|Ride"] = 675.4, ["Neon|Fly|Ride"] = 1237.37, ["Mega"] = 1748.25, ["Mega|Ride"] = 1758.75, ["Mega|Fly|Ride"] = 1715.44}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 25.25, ["Neon"] = 6.17, ["Neon|Ride"] = 63.95, ["Mega"] = 64.19, ["Mega|Ride"] = 1100.23, ["Mega|Fly|Ride"] = 234.94}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 12.39}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 31.91, ["Neon"] = 6.45, ["Neon|Ride"] = 50.28, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 45.94, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 144.38, ["Ride"] = 217.88, ["Fly|Ride"] = 296.26, ["Neon"] = 836.07, ["Neon|Ride"] = 684.64, ["Neon|Fly|Ride"] = 917.44, ["Mega"] = 3299.62, ["Mega|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 2835}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 3.13, ["Ride"] = 38.07, ["Neon"] = 19.57, ["Neon|Ride"] = 64.32, ["Mega"] = 183.75, ["Mega|Ride"] = 202.85, ["Mega|Fly|Ride"] = 362.97}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.21, ["Fly"] = 26.25, ["Ride"] = 82.5, ["Neon"] = 6.57, ["Neon|Ride"] = 20.86, ["Neon|Fly|Ride"] = 275.34, ["Mega"] = 32.8, ["Mega|Ride"] = 101.07, ["Mega|Fly|Ride"] = 138.18}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 10.38, ["Ride"] = 18.8, ["Neon"] = 48.47, ["Neon|Ride"] = 110.35, ["Neon|Fly|Ride"] = 156.3, ["Mega"] = 481.55, ["Mega|Ride"] = 550.65, ["Mega|Fly|Ride"] = 661.33}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 70.46, ["Fly"] = 26.25, ["Ride"] = 26.83, ["Fly|Ride"] = 55.76, ["Neon"] = 132, ["Neon|Ride"] = 131.15, ["Mega|Ride"] = 555.19, ["Mega|Fly|Ride"] = 481.69}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 16.58, ["Ride"] = 138.18, ["Neon"] = 145.69, ["Neon|Ride"] = 217.7, ["Neon|Fly|Ride"] = 1575, ["Mega"] = 560.44, ["Mega|Fly|Ride"] = 727.99}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 142.91, ["Fly"] = 274.76, ["Ride"] = 203.34, ["Fly|Ride"] = 249.38, ["Neon"] = 593.14, ["Neon|Ride"] = 590, ["Neon|Fly|Ride"] = 636.36, ["Mega|Fly|Ride"] = 3079.09}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 104.95, ["Fly"] = 275.36, ["Ride"] = 110.36, ["Fly|Ride"] = 342.45, ["Neon|Ride"] = 393.74, ["Neon|Fly|Ride"] = 662}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.1, ["Fly"] = 131.23, ["Ride"] = 19.68, ["Fly|Ride"] = 91.88, ["Neon"] = 15.62, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 137.82, ["Mega|Fly|Ride"] = 297.94}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 24.85, ["Fly"] = 233.43, ["Fly|Ride"] = 177.37, ["Neon"] = 166.13, ["Neon|Ride"] = 110.35, ["Mega"] = 259.88, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 51.18, ["Fly"] = 140.06, ["Ride"] = 75.07, ["Fly|Ride"] = 157.5, ["Neon"] = 242.61, ["Neon|Ride"] = 272.23, ["Neon|Fly|Ride"] = 305.74, ["Mega|Ride"] = 1636.41, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 17.42, ["Ride"] = 68.08, ["Neon"] = 105, ["Neon|Ride"] = 550.65, ["Neon|Fly|Ride"] = 454.74, ["Mega"] = 1050, ["Mega|Ride"] = 1932}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 327.39, ["Ride"] = 615.57, ["Neon|Ride"] = 3110.58, ["Neon|Fly|Ride"] = 1376.82}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 25.85, ["Ride"] = 32.7, ["Fly|Ride"] = 75.7, ["Neon|Ride"] = 229.69, ["Neon|Fly|Ride"] = 303.68, ["Mega"] = 1196.12, ["Mega|Ride"] = 921.38, ["Mega|Fly|Ride"] = 1076.25}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 38.32, ["Ride"] = 12.39, ["Fly|Ride"] = 119.62, ["Neon"] = 2.1, ["Neon|Ride"] = 14.4, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 19.25, ["Mega|Fly"] = 109.31, ["Mega|Ride"] = 34.44, ["Mega|Fly|Ride"] = 104.92}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 7.88, ["Neon"] = 19.3, ["Neon|Ride"] = 63.95, ["Neon|Fly|Ride"] = 259.86, ["Mega"] = 144.38, ["Mega|Ride"] = 316.57, ["Mega|Fly|Ride"] = 412.47}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 2.63, ["Ride"] = 29.92, ["Fly|Ride"] = 144.19, ["Neon"] = 19.13, ["Neon|Fly|Ride"] = 963.09, ["Mega"] = 108.05, ["Mega|Fly"] = 498.61, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 422.63, ["Ride"] = 439.69, ["Fly|Ride"] = 525, ["Neon"] = 1424.39, ["Neon|Ride"] = 2913.75, ["Neon|Fly|Ride"] = 2053.9, ["Mega|Fly|Ride"] = 5026.88}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.63, ["Fly"] = 69.12, ["Ride"] = 17.07, ["Fly|Ride"] = 42, ["Neon"] = 39.29, ["Neon|Ride"] = 68.87, ["Neon|Fly|Ride"] = 87.44, ["Mega"] = 168, ["Mega|Ride"] = 275.34, ["Mega|Fly|Ride"] = 466.54}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 5.65, ["Fly"] = 22.32, ["Ride"] = 16.89, ["Fly|Ride"] = 32.82, ["Neon"] = 26.83, ["Neon|Fly"] = 156.45, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 687.78, ["Mega|Fly|Ride"] = 286.38}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 6.57, ["Fly"] = 44.36, ["Ride"] = 28.88, ["Neon"] = 10.63, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 54.94, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 262.5, ["Mega|Ride"] = 268.11, ["Mega|Fly|Ride"] = 304.2}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 116.72, ["Fly"] = 42, ["Ride"] = 44.63, ["Fly|Ride"] = 57.46, ["Neon"] = 220.29, ["Neon|Ride"] = 206.24, ["Neon|Fly|Ride"] = 308.32, ["Mega"] = 1312.5, ["Mega|Ride"] = 823.89, ["Mega|Fly|Ride"] = 660.19}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 39.37, ["Ride"] = 27.17, ["Fly|Ride"] = 50.19, ["Neon"] = 11.7, ["Neon|Ride"] = 114.19, ["Neon|Fly|Ride"] = 210, ["Mega|Ride"] = 457.8}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 6.47, ["Fly"] = 787.5, ["Ride"] = 35.07, ["Fly|Ride"] = 85.6, ["Neon"] = 185.72, ["Neon|Ride"] = 210, ["Mega"] = 1649.82, ["Mega|Fly|Ride"] = 846.57}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 19.57, ["Neon"] = 6.06, ["Neon|Ride"] = 28.88, ["Mega"] = 53.83, ["Mega|Ride"] = 109.65, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 55.7, ["Neon"] = 67.29}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 63, ["Neon"] = 78.66, ["Neon|Ride"] = 466.54, ["Neon|Fly|Ride"] = 412.47, ["Mega"] = 275.34, ["Mega|Ride"] = 550.65, ["Mega|Fly|Ride"] = 509.25}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 9.75, ["Fly"] = 28.69, ["Ride"] = 23.91, ["Fly|Ride"] = 93.84, ["Neon"] = 52.41, ["Neon|Fly"] = 68.07, ["Neon|Ride"] = 44.5, ["Neon|Fly|Ride"] = 119.44, ["Mega"] = 579.51, ["Mega|Ride"] = 412.47, ["Mega|Fly|Ride"] = 361.87}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 336.84, ["Fly"] = 577.73, ["Ride"] = 334.69, ["Fly|Ride"] = 469.98, ["Neon"] = 1640.63, ["Neon|Ride"] = 1437.4, ["Neon|Fly|Ride"] = 1470, ["Mega|Fly|Ride"] = 4181.25}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 15.64, ["Fly|Ride"] = 26.25, ["Neon"] = 12.5, ["Neon|Fly"] = 78.16, ["Neon|Ride"] = 32.28, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 213.45, ["Mega|Ride"] = 196.77}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 3.6, ["Fly"] = 110.36, ["Ride"] = 45.94, ["Fly|Ride"] = 110.34, ["Neon"] = 43.19, ["Neon|Ride"] = 146.97, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 196.88, ["Mega|Fly"] = 687.78, ["Mega|Ride"] = 393.75}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 25.97, ["Ride"] = 99.3, ["Neon"] = 117.56, ["Neon|Ride"] = 132.49, ["Neon|Fly|Ride"] = 404.73, ["Mega"] = 350.44, ["Mega|Ride"] = 4124.53}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 125.09, ["Fly|Ride"] = 445.47, ["Neon"] = 2799.11, ["Neon|Ride"] = 1443.6, ["Neon|Fly|Ride"] = 1089.36, ["Mega|Ride"] = 6344.77, ["Mega|Fly|Ride"] = 3547.09}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 11.69, ["Fly"] = 121.7, ["Ride"] = 60.04, ["Fly|Ride"] = 123.22, ["Neon"] = 124.85, ["Neon|Ride"] = 116.45, ["Neon|Fly|Ride"] = 360.94, ["Mega"] = 341.25, ["Mega|Ride"] = 511.88, ["Mega|Fly|Ride"] = 433.15}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.63, ["Fly"] = 28.87, ["Ride"] = 19.58, ["Fly|Ride"] = 52.5, ["Neon"] = 12.46, ["Neon|Ride"] = 33.53, ["Neon|Fly|Ride"] = 69.11, ["Mega"] = 65.59, ["Mega|Ride"] = 142.3, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 3.6, ["Ride"] = 30.19, ["Neon"] = 27.18, ["Neon|Ride"] = 94.25, ["Neon|Fly|Ride"] = 174.57, ["Mega"] = 169.32}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 55.28, ["Fly"] = 196.88, ["Ride"] = 99.73, ["Fly|Ride"] = 198.19, ["Neon"] = 223.13, ["Neon|Ride"] = 213.68, ["Neon|Fly|Ride"] = 311.25, ["Mega"] = 1134.25, ["Mega|Ride"] = 507.6, ["Mega|Fly|Ride"] = 612.94}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 3.93, ["Ride"] = 131.24, ["Neon"] = 11.73, ["Neon|Ride"] = 206.24, ["Neon|Fly|Ride"] = 202.13, ["Mega"] = 49.79, ["Mega|Ride"] = 160.4, ["Mega|Fly|Ride"] = 404.22}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 35.07, ["Neon"] = 110.07, ["Neon|Ride"] = 401.03, ["Mega"] = 494.95, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 1023.75, ["Fly"] = 2062.53, ["Ride"] = 984.27, ["Fly|Ride"] = 1132.47, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2887.18, ["Mega|Fly|Ride"] = 10929.97}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 22.18, ["Ride"] = 55.7, ["Fly|Ride"] = 191.63, ["Neon"] = 202.13, ["Neon|Fly"] = 686.75, ["Neon|Ride"] = 157.5, ["Mega"] = 471.45, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 5.24, ["Fly"] = 49.34, ["Ride"] = 20.64, ["Fly|Ride"] = 65.63, ["Neon"] = 10.5, ["Neon|Ride"] = 33.01, ["Neon|Fly|Ride"] = 99.21, ["Mega"] = 75.51, ["Mega|Ride"] = 156.3, ["Mega|Fly|Ride"] = 220.89}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 9.9, ["Ride"] = 131.24, ["Fly|Ride"] = 138.18, ["Neon"] = 95.17, ["Mega|Ride"] = 422, ["Mega|Fly|Ride"] = 924}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 18.99, ["Fly|Ride"] = 59.81, ["Neon"] = 2.63, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 91.66, ["Mega"] = 15.74, ["Mega|Fly"] = 123.76, ["Mega|Ride"] = 40.22, ["Mega|Fly|Ride"] = 143.17}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 65.01, ["Fly"] = 105, ["Ride"] = 108.73, ["Fly|Ride"] = 229.69, ["Neon"] = 260.64, ["Neon|Ride"] = 297.39, ["Mega"] = 1117.44, ["Mega|Ride"] = 914.76, ["Mega|Fly|Ride"] = 1036.88}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 6.39, ["Ride"] = 65.63, ["Fly|Ride"] = 159.43, ["Neon"] = 60.75, ["Neon|Ride"] = 44.63, ["Mega"] = 682.5, ["Mega|Ride"] = 472.5, ["Mega|Fly|Ride"] = 548.58}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2.1, ["Ride"] = 26.83, ["Neon"] = 17.07, ["Neon|Ride"] = 32.82, ["Mega"] = 91.88, ["Mega|Ride"] = 258.03}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 73.49, ["Fly"] = 69.12, ["Ride"] = 32.61, ["Fly|Ride"] = 115.17, ["Neon"] = 99.65, ["Neon|Ride"] = 87.05, ["Neon|Fly|Ride"] = 139.72, ["Mega"] = 1039.49, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 687.78}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 6.29, ["Ride"] = 30.21, ["Neon"] = 43.68, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 315, ["Mega"] = 481.55, ["Mega|Ride"] = 518.22, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 56.6, ["Ride"] = 307.79, ["Neon|Ride"] = 183.75, ["Mega"] = 2058.69, ["Mega|Ride"] = 1649.82, ["Mega|Fly|Ride"] = 1636.41}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 4.18, ["Neon"] = 138.18, ["Neon|Ride"] = 88.69, ["Neon|Fly|Ride"] = 169.32, ["Mega"] = 138.18, ["Mega|Ride"] = 275.34, ["Mega|Fly|Ride"] = 256.77}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 3.92, ["Ride"] = 19.69, ["Fly|Ride"] = 90.76, ["Neon"] = 63, ["Neon|Ride"] = 138.18, ["Neon|Fly|Ride"] = 136.12, ["Mega"] = 350.44, ["Mega|Ride"] = 381.53, ["Mega|Fly|Ride"] = 686.75}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 241.33, ["Fly"] = 382.05, ["Ride"] = 160.12, ["Fly|Ride"] = 207.9, ["Neon"] = 777.93, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 723.19, ["Mega"] = 2327.07, ["Mega|Fly|Ride"] = 1945.13}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 36.75, ["Ride"] = 17.75, ["Fly|Ride"] = 39.38, ["Neon"] = 10.69, ["Neon|Fly"] = 57.53, ["Neon|Ride"] = 33.27, ["Neon|Fly|Ride"] = 68.92, ["Mega"] = 124.69, ["Mega|Ride"] = 233.27, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 11.03, ["Fly"] = 201.42, ["Ride"] = 34.8, ["Fly|Ride"] = 68.25, ["Neon"] = 97.01, ["Neon|Ride"] = 82.84, ["Neon|Fly|Ride"] = 206.24, ["Mega"] = 526.43, ["Mega|Ride"] = 453.75, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 18.89, ["Ride"] = 14.68, ["Fly|Ride"] = 52.41, ["Neon"] = 2.1, ["Neon|Fly"] = 26.17, ["Neon|Ride"] = 13.78, ["Neon|Fly|Ride"] = 45.27, ["Mega"] = 15.74, ["Mega|Ride"] = 32.22, ["Mega|Fly|Ride"] = 77.24}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Fly|Ride"] = 39.38, ["Neon"] = 2.43, ["Neon|Ride"] = 41.26, ["Neon|Fly|Ride"] = 127.87, ["Mega"] = 19.17, ["Mega|Fly"] = 104.99, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 159.85}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 3.94, ["Fly"] = 35.07, ["Ride"] = 19.68, ["Fly|Ride"] = 98.85, ["Neon"] = 26.25, ["Neon|Ride"] = 82.5, ["Mega"] = 156.3, ["Mega|Ride"] = 261.92, ["Mega|Fly|Ride"] = 242.82}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 26.25, ["Ride"] = 52.47, ["Fly|Ride"] = 131.25, ["Neon"] = 118.13, ["Neon|Ride"] = 349.91, ["Neon|Fly|Ride"] = 433.13, ["Mega"] = 1181.24, ["Mega|Ride"] = 701.18, ["Mega|Fly|Ride"] = 668.19}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 15.75, ["Fly|Ride"] = 43.33, ["Neon"] = 11.67, ["Neon|Fly"] = 25.83, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 54.51, ["Mega"] = 104.9, ["Mega|Fly"] = 170.62, ["Mega|Ride"] = 411.44, ["Mega|Fly|Ride"] = 177.19}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 3.59, ["Fly"] = 39.38, ["Ride"] = 24.44, ["Fly|Ride"] = 78.75, ["Neon"] = 28.68, ["Neon|Fly"] = 55.76, ["Neon|Ride"] = 36.2, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 208.28, ["Mega|Fly"] = 412.47, ["Mega|Ride"] = 212.08, ["Mega|Fly|Ride"] = 272.32}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.5, ["Fly"] = 21.53, ["Ride"] = 18.09, ["Fly|Ride"] = 60.85, ["Neon"] = 10.5, ["Neon|Fly"] = 98.43, ["Neon|Ride"] = 24.76, ["Neon|Fly|Ride"] = 89.23, ["Mega"] = 156.3, ["Mega|Fly"] = 170.63, ["Mega|Ride"] = 88.69, ["Mega|Fly|Ride"] = 162.04}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 17.07, ["Fly"] = 169.32, ["Ride"] = 23.44, ["Fly|Ride"] = 196.88, ["Neon"] = 30.19, ["Neon|Ride"] = 93.33, ["Neon|Fly|Ride"] = 275.34, ["Mega"] = 261.92, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 370.19, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 5.94, ["Ride"] = 138.18, ["Neon"] = 69.28, ["Neon|Ride"] = 262.4, ["Mega"] = 446.25, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 3.75, ["Fly"] = 41.88, ["Ride"] = 15.75, ["Fly|Ride"] = 44.45, ["Neon"] = 26.24, ["Neon|Fly"] = 196.76, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 111.64, ["Mega"] = 262.49, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 418.28}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 23.12, ["Ride"] = 18.58, ["Fly|Ride"] = 35, ["Neon"] = 15.58, ["Neon|Fly"] = 46.67, ["Neon|Ride"] = 31.43, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 131.15, ["Mega|Ride"] = 279.45, ["Mega|Fly|Ride"] = 232.32}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 196.87, ["Fly"] = 393.75, ["Ride"] = 311.63, ["Fly|Ride"] = 466.53, ["Neon"] = 1196.12, ["Neon|Ride"] = 1364.61, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 3937.5}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 9.36, ["Ride"] = 107.31, ["Neon"] = 152.62, ["Mega"] = 122.07, ["Mega|Ride"] = 622.82, ["Mega|Fly|Ride"] = 481.55}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 3.02, ["Fly"] = 103.15, ["Ride"] = 21.77, ["Fly|Ride"] = 79.07, ["Neon"] = 21.73, ["Neon|Ride"] = 55.7, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 204.35, ["Mega|Ride"] = 321.72, ["Mega|Fly|Ride"] = 316.57}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 6.56, ["Neon"] = 60.9, ["Neon|Ride"] = 218.61, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 603.74, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 552.85}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 15.49, ["Ride"] = 13.56, ["Fly|Ride"] = 26.25, ["Neon"] = 2.1, ["Neon|Fly"] = 28.87, ["Neon|Ride"] = 15.54, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 18.37, ["Mega|Fly"] = 69.11, ["Mega|Ride"] = 130.96, ["Mega|Fly|Ride"] = 98.43}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 30.79, ["Fly|Ride"] = 110.35, ["Neon"] = 12.21, ["Neon|Ride"] = 23.39, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 98.34, ["Mega|Ride"] = 140.43, ["Mega|Fly|Ride"] = 211.83}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 3.94, ["Ride"] = 144.38, ["Neon"] = 15.61, ["Neon|Ride"] = 275.34, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 124.82, ["Mega|Ride"] = 412.47, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 82.64, ["Fly"] = 163.41, ["Ride"] = 94.5, ["Fly|Ride"] = 210, ["Neon"] = 556.49, ["Neon|Ride"] = 372.9, ["Neon|Fly|Ride"] = 622.82, ["Mega"] = 2062.28, ["Mega|Ride"] = 3438.83, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 6.18, ["Fly"] = 96.95, ["Ride"] = 28.88, ["Fly|Ride"] = 262.49, ["Neon"] = 22.74, ["Neon|Ride"] = 168.09, ["Neon|Fly|Ride"] = 412.47, ["Mega"] = 157.49, ["Mega|Ride"] = 264.76, ["Mega|Fly|Ride"] = 555.8}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.14, ["Fly"] = 20.99, ["Ride"] = 55.7, ["Neon"] = 23.62, ["Neon|Ride"] = 62.99, ["Neon|Fly|Ride"] = 523.69, ["Mega"] = 66.94, ["Mega|Fly"] = 314.99, ["Mega|Fly|Ride"] = 919.07}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 46.71, ["Fly"] = 210, ["Ride"] = 107.39, ["Fly|Ride"] = 225.84, ["Neon"] = 177.19, ["Neon|Ride"] = 220.5, ["Neon|Fly|Ride"] = 396.38, ["Mega"] = 622.82, ["Mega|Ride"] = 426.57, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 17.04, ["Ride"] = 12.71, ["Fly|Ride"] = 28.58, ["Neon"] = 2.1, ["Neon|Fly"] = 17.13, ["Neon|Ride"] = 17.56, ["Neon|Fly|Ride"] = 32.82, ["Mega"] = 17.99, ["Mega|Fly"] = 49.87, ["Mega|Ride"] = 35.44, ["Mega|Fly|Ride"] = 85.65}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Neon"] = 4.69, ["Neon|Fly"] = 31.99, ["Neon|Ride"] = 69.11, ["Neon|Fly|Ride"] = 209.36, ["Mega"] = 52.61, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 199.5}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 3.31, ["Ride"] = 46.24, ["Neon"] = 9.91, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 138.18, ["Neon|Fly|Ride"] = 184.58, ["Mega"] = 94.5, ["Mega|Fly"] = 179.43, ["Mega|Ride"] = 146.43, ["Mega|Fly|Ride"] = 185.07}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 3.59, ["Fly"] = 77.17, ["Ride"] = 41.91, ["Fly|Ride"] = 206.07, ["Neon"] = 23.1, ["Neon|Fly"] = 91.55, ["Neon|Ride"] = 76.56, ["Neon|Fly|Ride"] = 141.45, ["Mega"] = 110.14, ["Mega|Fly"] = 220.68, ["Mega|Ride"] = 191.19, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 21.2, ["Ride"] = 11.61, ["Fly|Ride"] = 91.34, ["Neon"] = 2.63, ["Neon|Fly"] = 25.66, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 59.81, ["Mega"] = 28.01, ["Mega|Ride"] = 52.49, ["Mega|Fly|Ride"] = 118.12}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 23.31, ["Fly"] = 131.25, ["Ride"] = 123.76, ["Neon"] = 129.94, ["Neon|Fly"] = 412.47, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 656.25, ["Mega|Ride"] = 564.04}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2610.55, ["Ride"] = 2493.73, ["Fly|Ride"] = 2598.75, ["Mega|Fly|Ride"] = 36088.45}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.75, ["Fly|Ride"] = 43.42, ["Neon"] = 7.01, ["Neon|Fly"] = 62.99, ["Neon|Ride"] = 24.03, ["Neon|Fly|Ride"] = 63.95, ["Mega"] = 73.41, ["Mega|Ride"] = 124.69, ["Mega|Fly|Ride"] = 178.25}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 3.41, ["Neon"] = 9.34, ["Mega"] = 140.37, ["Mega|Fly"] = 441, ["Mega|Ride"] = 156.3, ["Mega|Fly|Ride"] = 233.27}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 14.77, ["Fly"] = 110.36, ["Ride"] = 30.35, ["Fly|Ride"] = 157.5, ["Neon"] = 264.76, ["Neon|Ride"] = 103.79, ["Neon|Fly|Ride"] = 292.37, ["Mega"] = 459.38, ["Mega|Ride"] = 1031.15}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 24.93, ["Ride"] = 43.73, ["Neon"] = 187.69, ["Mega"] = 1237.37, ["Mega|Ride"] = 824.92, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 131.25, ["Fly"] = 1375.71, ["Ride"] = 197.88, ["Fly|Ride"] = 251.98, ["Neon"] = 1312.5, ["Neon|Ride"] = 700.41, ["Neon|Fly|Ride"] = 824.92, ["Mega"] = 6186.78, ["Mega|Fly|Ride"] = 2799.18}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 6.27, ["Ride"] = 28.88, ["Fly|Ride"] = 675.94, ["Neon"] = 15.65, ["Neon|Ride"] = 156.3, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 156.19, ["Mega|Ride"] = 304.2, ["Mega|Fly|Ride"] = 721.81}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 3.94, ["Fly|Ride"] = 69.11, ["Neon"] = 18.38, ["Mega"] = 140.44, ["Mega|Fly|Ride"] = 829.26}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 131.25, ["Neon"] = 8.01, ["Neon|Fly"] = 84.13, ["Neon|Ride"] = 47.45, ["Mega"] = 138.18, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 12.91, ["Ride"] = 50.34, ["Neon"] = 180.07, ["Neon|Ride"] = 1169.83, ["Mega"] = 374.07, ["Mega|Ride"] = 456.81}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 41.27, ["Neon"] = 2.1, ["Neon|Ride"] = 47.57, ["Mega"] = 18.38, ["Mega|Fly"] = 116.64, ["Mega|Ride"] = 156.3, ["Mega|Fly|Ride"] = 275.34}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 91.77, ["Fly"] = 206.27, ["Ride"] = 87.94, ["Fly|Ride"] = 309.36, ["Neon"] = 515.58, ["Neon|Ride"] = 401.06, ["Neon|Fly|Ride"] = 514.36, ["Mega|Fly|Ride"] = 2491.13}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 91.82, ["Neon"] = 10.06, ["Neon|Ride"] = 142.31, ["Neon|Fly|Ride"] = 206.24, ["Mega"] = 74.66, ["Mega|Ride"] = 276.29}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 44.7, ["Fly"] = 218.27, ["Ride"] = 81.73, ["Fly|Ride"] = 157.48, ["Neon"] = 295.32, ["Neon|Ride"] = 416.51, ["Neon|Fly|Ride"] = 532.88, ["Mega"] = 2625, ["Mega|Fly|Ride"] = 2590.88}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 60.85, ["Ride"] = 31.99, ["Fly|Ride"] = 50.71, ["Neon"] = 3.94, ["Neon|Fly"] = 87.45, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 83.99, ["Mega"] = 55.13, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 177.14}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 3.93, ["Neon"] = 6.57, ["Neon|Ride"] = 98.44, ["Mega"] = 65.61, ["Mega|Ride"] = 152.25, ["Mega|Fly|Ride"] = 687.78}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 6.44, ["Fly"] = 77.43, ["Ride"] = 39.38, ["Fly|Ride"] = 206.24, ["Neon"] = 67.2, ["Neon|Ride"] = 110.35, ["Mega"] = 262.5, ["Mega|Fly|Ride"] = 550.65}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 423.94, ["Ride"] = 440.53, ["Fly|Ride"] = 533.32, ["Neon"] = 1050, ["Neon|Ride"] = 1443.75, ["Neon|Fly|Ride"] = 1399.6, ["Mega"] = 5500.05, ["Mega|Ride"] = 4725, ["Mega|Fly|Ride"] = 5361.88}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 33.68, ["Fly"] = 82.51, ["Ride"] = 63.04, ["Fly|Ride"] = 98.14, ["Neon"] = 1181.25, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 311.42, ["Mega|Fly|Ride"] = 983.07}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.63, ["Fly"] = 47.38, ["Ride"] = 17.31, ["Fly|Ride"] = 57.75, ["Neon"] = 6.24, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 23.77, ["Neon|Fly|Ride"] = 131.15, ["Mega"] = 111.57, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 229.69}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 20.05, ["Fly"] = 111.57, ["Ride"] = 43.43, ["Fly|Ride"] = 111.57, ["Neon"] = 65.63, ["Neon|Ride"] = 115.5, ["Neon|Fly|Ride"] = 181.55, ["Mega"] = 314.9, ["Mega|Fly"] = 959.88, ["Mega|Ride"] = 355.83, ["Mega|Fly|Ride"] = 406.87}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 4.65, ["Ride"] = 20.69, ["Fly|Ride"] = 82.5, ["Neon"] = 138.18, ["Neon|Ride"] = 91.87, ["Neon|Fly|Ride"] = 264.76, ["Mega"] = 288.75, ["Mega|Ride"] = 658.91, ["Mega|Fly|Ride"] = 550.65}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.94, ["Neon"] = 14.44, ["Mega"] = 70.88, ["Mega|Ride"] = 131.25}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 5.25, ["Fly"] = 39.38, ["Ride"] = 19.69, ["Fly|Ride"] = 57.77, ["Neon"] = 39.38, ["Neon|Ride"] = 32.79, ["Neon|Fly|Ride"] = 270.18, ["Mega"] = 544.69, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 103.94, ["Ride"] = 117.5, ["Fly|Ride"] = 215.15, ["Neon|Ride"] = 582.65, ["Neon|Fly|Ride"] = 568.5, ["Mega"] = 2887.5, ["Mega|Fly|Ride"] = 2928.41}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 23.61, ["Ride"] = 74.69, ["Fly|Ride"] = 118.13, ["Neon"] = 142.95, ["Neon|Ride"] = 206.24, ["Neon|Fly|Ride"] = 389.73, ["Mega"] = 1031.15, ["Mega|Ride"] = 895.04, ["Mega|Fly|Ride"] = 824.92}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 1995, ["Fly"] = 3575.38, ["Ride"] = 2556.18, ["Fly|Ride"] = 2397.33, ["Neon"] = 10999.06, ["Neon|Fly|Ride"] = 6424.69, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 3.82, ["Fly"] = 65625, ["Ride"] = 116.28, ["Neon"] = 13.13, ["Neon|Fly|Ride"] = 105, ["Mega"] = 96.22, ["Mega|Fly"] = 786.19, ["Mega|Ride"] = 167.35, ["Mega|Fly|Ride"] = 451.39}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 4.6, ["Ride"] = 31.5, ["Neon"] = 35.36, ["Neon|Ride"] = 118.98, ["Neon|Fly|Ride"] = 232.32, ["Mega"] = 544.69, ["Mega|Ride"] = 198.19, ["Mega|Fly|Ride"] = 1031.15}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 1047.81, ["Fly"] = 948.54, ["Ride"] = 879.27, ["Fly|Ride"] = 987, ["Neon"] = 2778.57, ["Neon|Ride"] = 2611.87, ["Neon|Fly|Ride"] = 3110.63, ["Mega"] = 11823.96, ["Mega|Fly|Ride"] = 11136.19}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 30.32, ["Ride"] = 52.49, ["Fly|Ride"] = 209.94, ["Neon"] = 227.89, ["Neon|Ride"] = 206.24, ["Neon|Fly|Ride"] = 368.58, ["Mega"] = 839.9, ["Mega|Ride"] = 804.56, ["Mega|Fly|Ride"] = 819.76}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 2.63, ["Ride"] = 23.58, ["Fly|Ride"] = 128.15, ["Neon"] = 24.92, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 175.88, ["Mega|Ride"] = 268.98, ["Mega|Fly|Ride"] = 550.65}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 52.41, ["Ride"] = 138.18, ["Neon"] = 2.61, ["Neon|Ride"] = 55.55, ["Neon|Fly|Ride"] = 78.38, ["Mega"] = 41.26, ["Mega|Ride"] = 251.62, ["Mega|Fly|Ride"] = 275.34}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 90.75, ["Ride"] = 129.94, ["Fly|Ride"] = 206.24, ["Neon"] = 412.47, ["Neon|Fly|Ride"] = 603.75, ["Mega"] = 8249.04, ["Mega|Fly|Ride"] = 5352.24}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 2.62, ["Fly|Ride"] = 73.12, ["Neon"] = 27.85, ["Neon|Ride"] = 52.02, ["Neon|Fly|Ride"] = 275.34, ["Mega"] = 159.5, ["Mega|Ride"] = 262.49, ["Mega|Fly|Ride"] = 305.82}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 74.93, ["Ride"] = 152.62, ["Neon"] = 393.75, ["Neon|Ride"] = 411.44, ["Neon|Fly|Ride"] = 506.3}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 3.89, ["Fly"] = 105, ["Fly|Ride"] = 110.35, ["Neon"] = 26.2, ["Neon|Fly|Ride"] = 315, ["Mega"] = 206.24, ["Mega|Ride"] = 164.07}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 255.94, ["Ride"] = 314.6, ["Fly|Ride"] = 338.49, ["Neon"] = 1498.88, ["Neon|Ride"] = 1340.48, ["Neon|Fly|Ride"] = 879.03, ["Mega|Fly|Ride"] = 3899.56}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 15.6, ["Fly"] = 87.94, ["Ride"] = 19.63, ["Fly|Ride"] = 56.6, ["Neon"] = 17.75, ["Neon|Ride"] = 57, ["Neon|Fly|Ride"] = 100.27, ["Mega"] = 210, ["Mega|Ride"] = 649.68, ["Mega|Fly|Ride"] = 687.78}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 14.02, ["Ride"] = 11.82, ["Fly|Ride"] = 36.03, ["Neon"] = 6.57, ["Neon|Fly"] = 31.29, ["Neon|Ride"] = 20.33, ["Neon|Fly|Ride"] = 48.57, ["Mega"] = 52.5, ["Mega|Fly"] = 142.31, ["Mega|Ride"] = 115.5, ["Mega|Fly|Ride"] = 278.33}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 1190.61, ["Ride"] = 1050, ["Fly|Ride"] = 1254.19, ["Neon|Ride"] = 7562.3, ["Neon|Fly|Ride"] = 5912.5, ["Mega"] = 22859.81}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 10.1, ["Fly"] = 963.21, ["Ride"] = 72.19, ["Neon"] = 45.94, ["Neon|Ride"] = 129.93, ["Mega"] = 308.42, ["Mega|Ride"] = 375.35, ["Mega|Fly|Ride"] = 626.75}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 7.82, ["Fly"] = 49.51, ["Ride"] = 45.27, ["Fly|Ride"] = 79.49, ["Neon"] = 25.74, ["Neon|Fly"] = 123.76, ["Neon|Ride"] = 69.11, ["Neon|Fly|Ride"] = 275.34, ["Mega"] = 206.24, ["Mega|Ride"] = 204.16, ["Mega|Fly|Ride"] = 296.56}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 33.49, ["Fly"] = 33.26, ["Ride"] = 39.38, ["Fly|Ride"] = 73.5, ["Neon|Ride"] = 209.79, ["Neon|Fly|Ride"] = 189.74, ["Mega|Fly|Ride"] = 798}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 13.71, ["Ride"] = 27.56, ["Fly|Ride"] = 69.11, ["Neon"] = 52.31, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 179.8, ["Mega"] = 367.5, ["Mega|Fly"] = 470.21, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 494}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 32.48, ["Ride"] = 109.65, ["Fly|Ride"] = 636.57, ["Neon"] = 129.94, ["Neon|Ride"] = 376.69, ["Mega|Ride"] = 654.94, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 116.61, ["Fly|Ride"] = 78.16, ["Neon"] = 2.63, ["Neon|Fly"] = 55.7, ["Neon|Ride"] = 109.65, ["Neon|Fly|Ride"] = 105.16, ["Mega"] = 18.05, ["Mega|Ride"] = 79.26}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 57.74, ["Fly"] = 116.54, ["Ride"] = 71.32, ["Fly|Ride"] = 140.31, ["Neon"] = 578.82, ["Neon|Ride"] = 393.74, ["Neon|Fly|Ride"] = 447.2, ["Mega"] = 3299.62, ["Mega|Ride"] = 1697.25, ["Mega|Fly|Ride"] = 1516.51}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 3.49, ["Fly"] = 91.4, ["Ride"] = 30.35, ["Fly|Ride"] = 127.32, ["Neon"] = 58.97, ["Mega"] = 773.06, ["Mega|Ride"] = 389.57}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 20.95, ["Ride"] = 18.38, ["Fly|Ride"] = 36.63, ["Neon"] = 16.28, ["Neon|Fly"] = 78.16, ["Neon|Ride"] = 55.7, ["Neon|Fly|Ride"] = 122.85, ["Mega|Ride"] = 271.2, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 3.94, ["Ride"] = 126, ["Neon"] = 20.13, ["Neon|Fly"] = 136.12, ["Neon|Fly|Ride"] = 205.22, ["Mega"] = 329.97, ["Mega|Fly|Ride"] = 466.54}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 59.74, ["Ride"] = 154.69, ["Fly|Ride"] = 262.5, ["Neon"] = 210, ["Neon|Ride"] = 414.78, ["Neon|Fly|Ride"] = 550.65, ["Mega|Ride"] = 1454.94, ["Mega|Fly|Ride"] = 1214.51}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 3.94, ["Neon"] = 23.63, ["Neon|Ride"] = 77.35, ["Mega"] = 122.06, ["Mega|Fly|Ride"] = 290.15}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Neon"] = 2.1, ["Neon|Ride"] = 52.5, ["Mega"] = 17.07, ["Mega|Ride"] = 40.28, ["Mega|Fly|Ride"] = 515.58}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 102.94, ["Ride"] = 35.07, ["Fly|Ride"] = 39.31, ["Neon"] = 2.63, ["Neon|Ride"] = 27.72, ["Neon|Fly|Ride"] = 164.99, ["Mega"] = 17.47, ["Mega|Ride"] = 51.7, ["Mega|Fly|Ride"] = 137.16}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 30.96, ["Ride"] = 15.89, ["Fly|Ride"] = 49.26, ["Neon"] = 6.57, ["Neon|Ride"] = 26.81, ["Neon|Fly|Ride"] = 86.64, ["Mega"] = 63, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.23, ["Ride"] = 28.88, ["Fly|Ride"] = 110.35, ["Neon"] = 39.37, ["Mega"] = 118.09, ["Mega|Ride"] = 106.3, ["Mega|Fly|Ride"] = 279.93}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 38.04, ["Ride"] = 15.48, ["Fly|Ride"] = 32.37, ["Neon"] = 15.72, ["Neon|Fly"] = 206.24, ["Neon|Ride"] = 41.26, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 202.12, ["Mega|Fly|Ride"] = 451.49}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 39.38, ["Ride"] = 107.63, ["Fly|Ride"] = 220.68, ["Neon"] = 196.87, ["Neon|Ride"] = 316.57, ["Neon|Fly|Ride"] = 1031.15, ["Mega"] = 963.09, ["Mega|Ride"] = 886.78, ["Mega|Fly|Ride"] = 1079.61}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 15.53, ["Ride"] = 15.02, ["Fly|Ride"] = 35.43, ["Neon"] = 2.63, ["Neon|Fly"] = 23.13, ["Neon|Ride"] = 17.06, ["Neon|Fly|Ride"] = 43.35, ["Mega"] = 24.94, ["Mega|Fly|Ride"] = 104.67}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 6.41, ["Fly"] = 80.46, ["Ride"] = 23.56, ["Fly|Ride"] = 101.49, ["Neon"] = 26.19, ["Neon|Fly"] = 82.91, ["Neon|Ride"] = 53.67, ["Neon|Fly|Ride"] = 144.01, ["Mega"] = 412.47, ["Mega|Fly"] = 321.72, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 481.55}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 14.1, ["Fly"] = 40.23, ["Ride"] = 27.57, ["Fly|Ride"] = 84.14, ["Neon"] = 124.16, ["Neon|Ride"] = 144.37, ["Neon|Fly|Ride"] = 196.67, ["Mega"] = 787.5, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 692.46}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 13.12, ["Fly"] = 196.88, ["Ride"] = 44.63, ["Neon"] = 42, ["Neon|Ride"] = 71.76, ["Mega"] = 366.19, ["Mega|Ride"] = 399.07, ["Mega|Fly|Ride"] = 412.47}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 27.85, ["Ride"] = 15.04, ["Fly|Ride"] = 51.57, ["Neon"] = 4.6, ["Neon|Fly"] = 24.76, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 66.89, ["Mega"] = 72.19, ["Mega|Ride"] = 137.82, ["Mega|Fly|Ride"] = 122.07}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 3.84, ["Fly"] = 76.32, ["Ride"] = 37.97, ["Neon"] = 21.62, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 138.18, ["Mega"] = 311.42, ["Mega|Fly"] = 735, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 412.47}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 1059.19, ["Ride"] = 1070.87, ["Fly|Ride"] = 1115.49, ["Neon|Ride"] = 2744.44, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 6929.9}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 96.83, ["Ride"] = 157.5, ["Fly|Ride"] = 380.63, ["Neon"] = 571.27, ["Neon|Ride"] = 510.42, ["Neon|Fly|Ride"] = 740.25, ["Mega"] = 6186.78, ["Mega|Ride"] = 2612.9, ["Mega|Fly|Ride"] = 2074.64}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.63, ["Fly"] = 55.7, ["Neon"] = 6.14, ["Neon|Ride"] = 52.41, ["Neon|Fly|Ride"] = 206.24, ["Mega"] = 89.25, ["Mega|Fly|Ride"] = 1100.23}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 79.96, ["Ride"] = 131.25, ["Fly|Ride"] = 196.88, ["Neon"] = 341.25, ["Neon|Ride"] = 367.49, ["Neon|Fly|Ride"] = 551.25, ["Mega"] = 1575, ["Mega|Ride"] = 1706.25, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 2.62, ["Ride"] = 19.13, ["Fly|Ride"] = 89.73, ["Neon"] = 18.58, ["Neon|Fly"] = 54.83, ["Neon|Ride"] = 47.7, ["Neon|Fly|Ride"] = 275.34, ["Mega"] = 291.6, ["Mega|Ride"] = 316.32, ["Mega|Fly|Ride"] = 399.07}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 301.93, ["Fly"] = 288.78, ["Ride"] = 345.44, ["Fly|Ride"] = 430.5, ["Neon|Ride"] = 1306.46, ["Neon|Fly|Ride"] = 1430.19, ["Mega|Fly|Ride"] = 4528.13}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 76.4, ["Ride"] = 52.41, ["Fly|Ride"] = 213.09, ["Neon"] = 31.29, ["Neon|Ride"] = 54.37, ["Mega"] = 412.29, ["Mega|Fly"] = 321.72, ["Mega|Ride"] = 622.82}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Neon"] = 28.01, ["Mega"] = 329.97, ["Mega|Ride"] = 353.7}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 26.56, ["Ride"] = 275.36, ["Fly|Ride"] = 196.88, ["Neon"] = 164.99, ["Neon|Ride"] = 124.59, ["Mega"] = 1100.23, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.63, ["Ride"] = 49.73, ["Neon"] = 25.25, ["Neon|Ride"] = 141.91, ["Mega"] = 233.27, ["Mega|Ride"] = 253.3, ["Mega|Fly|Ride"] = 456.05}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 15.12, ["Ride"] = 12.29, ["Fly|Ride"] = 39.35, ["Neon"] = 3.89, ["Neon|Fly"] = 23.63, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 37.43, ["Mega"] = 164.99, ["Mega|Ride"] = 32.82, ["Mega|Fly|Ride"] = 80.53}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4593.75, ["Ride"] = 5118.75, ["Fly|Ride"] = 4517.63, ["Neon"] = 30933.84, ["Neon|Fly|Ride"] = 18414.38, ["Mega|Fly|Ride"] = 128890.97}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 7.13, ["Ride"] = 41.57, ["Neon"] = 52.41, ["Neon|Ride"] = 105, ["Mega"] = 311.42, ["Mega|Ride"] = 302.57, ["Mega|Fly|Ride"] = 412.47}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 24.7, ["Ride"] = 28.77, ["Fly|Ride"] = 51.19, ["Neon"] = 15.71, ["Neon|Fly"] = 45.91, ["Neon|Ride"] = 34.18, ["Neon|Fly|Ride"] = 80.63, ["Mega"] = 144.38, ["Mega|Ride"] = 188.74, ["Mega|Fly|Ride"] = 242.18}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 493.29, ["Fly"] = 598.15, ["Ride"] = 532.61, ["Fly|Ride"] = 545.68, ["Neon"] = 2100, ["Neon|Ride"] = 1555.88, ["Neon|Fly|Ride"] = 1744.43, ["Mega|Fly|Ride"] = 5898.06}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 4.53, ["Ride"] = 32.45, ["Neon"] = 22.3, ["Mega"] = 187.95, ["Mega|Fly|Ride"] = 687.78}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 3.4, ["Fly"] = 4125.03, ["Ride"] = 46.67, ["Neon"] = 24.76, ["Neon|Ride"] = 62.99, ["Neon|Fly|Ride"] = 280.49, ["Mega"] = 410.41, ["Mega|Ride"] = 401.63}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Ride"] = 29.92, ["Neon"] = 3.81, ["Neon|Fly"] = 124.69, ["Neon|Ride"] = 20.99, ["Neon|Fly|Ride"] = 91.74, ["Mega"] = 76.99, ["Mega|Ride"] = 78.08, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 1100.37, ["Ride"] = 960, ["Fly|Ride"] = 753.54, ["Neon|Ride"] = 3281.25, ["Neon|Fly|Ride"] = 2455.63}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 6.74, ["Ride"] = 55.7, ["Fly|Ride"] = 412.47, ["Neon"] = 35.77, ["Neon|Ride"] = 96.94, ["Neon|Fly|Ride"] = 275.34, ["Mega"] = 155.99, ["Mega|Ride"] = 229.69, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 3.84, ["Fly"] = 236.15, ["Ride"] = 30.19, ["Neon"] = 27.85, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 216.55, ["Mega"] = 365.04, ["Mega|Fly"] = 777.95, ["Mega|Ride"] = 222.58, ["Mega|Fly|Ride"] = 344.42}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 4.69, ["Fly"] = 34.13, ["Ride"] = 16.7, ["Fly|Ride"] = 59.07, ["Neon"] = 6.57, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 30.84, ["Neon|Fly|Ride"] = 81.36, ["Mega"] = 275.34, ["Mega|Ride"] = 195.57, ["Mega|Fly|Ride"] = 215.2}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 18.15, ["Ride"] = 34.12, ["Fly|Ride"] = 55.7, ["Neon"] = 118.13, ["Neon|Fly|Ride"] = 309.36, ["Mega"] = 550.65, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 742.43}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Fly|Ride"] = 82.5, ["Neon"] = 5.81, ["Neon|Ride"] = 45.23, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 45.39, ["Mega|Ride"] = 104.89, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 616.88, ["Ride"] = 538.12, ["Fly|Ride"] = 687.78, ["Neon"] = 2589.57, ["Neon|Fly|Ride"] = 2799.18, ["Mega|Fly|Ride"] = 7861.88}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.62, ["Fly"] = 103.15, ["Ride"] = 76.11, ["Neon"] = 15.75, ["Neon|Ride"] = 84.42, ["Neon|Fly|Ride"] = 466.54, ["Mega"] = 98.44, ["Mega|Ride"] = 275.34}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 27.46, ["Neon"] = 6.56, ["Neon|Fly"] = 234.08, ["Neon|Ride"] = 209.96, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 82.5, ["Mega|Ride"] = 137.82, ["Mega|Fly|Ride"] = 348.54}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 49.44, ["Neon"] = 6.57, ["Neon|Ride"] = 44.57, ["Mega"] = 101.07, ["Mega|Fly"] = 152.62, ["Mega|Ride"] = 99.65, ["Mega|Fly|Ride"] = 145.68}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 3.94, ["Ride"] = 131.25, ["Neon"] = 15.48, ["Mega"] = 206.24, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 33.27, ["Fly"] = 98.44, ["Ride"] = 82.51, ["Fly|Ride"] = 275.34, ["Neon"] = 152.25, ["Neon|Ride"] = 137.22, ["Neon|Fly|Ride"] = 334.68, ["Mega"] = 824.92, ["Mega|Ride"] = 967.32, ["Mega|Fly|Ride"] = 2332.64}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 17.53, ["Ride"] = 65.01, ["Fly|Ride"] = 190.32, ["Neon"] = 90.19, ["Neon|Ride"] = 141.82, ["Neon|Fly|Ride"] = 275.34, ["Mega"] = 477.23, ["Mega|Ride"] = 536.2, ["Mega|Fly|Ride"] = 572.25}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.63, ["Fly"] = 19.59, ["Ride"] = 14.11, ["Fly|Ride"] = 32.81, ["Neon"] = 27.77, ["Neon|Ride"] = 43.33, ["Neon|Fly|Ride"] = 67.1, ["Mega"] = 299.92, ["Mega|Ride"] = 275.34, ["Mega|Fly|Ride"] = 349.91}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 9.18, ["Ride"] = 101.49, ["Neon"] = 72.19, ["Neon|Ride"] = 136.12}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Ride"] = 20.63, ["Fly|Ride"] = 111.56, ["Neon"] = 15.48, ["Neon|Ride"] = 64.97, ["Neon|Fly|Ride"] = 153.97, ["Mega"] = 105, ["Mega|Ride"] = 156.3, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 18.18, ["Ride"] = 26.25, ["Fly|Ride"] = 77.42, ["Neon"] = 209.99, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 195.92, ["Mega"] = 927, ["Mega|Fly|Ride"] = 815.64}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 34.7, ["Fly"] = 874.13, ["Neon"] = 261.92, ["Mega"] = 517.64, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 761.92}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 51.07, ["Ride"] = 77.17, ["Fly|Ride"] = 185.61, ["Neon"] = 183.75, ["Neon|Ride"] = 421.18, ["Neon|Fly|Ride"] = 364.41, ["Mega|Ride"] = 1649.19, ["Mega|Fly|Ride"] = 1764.28}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 34.65, ["Fly"] = 82.51, ["Ride"] = 76.73, ["Fly|Ride"] = 201.08, ["Neon"] = 138.96, ["Neon|Ride"] = 203.44, ["Neon|Fly|Ride"] = 577.34, ["Mega"] = 856.09, ["Mega|Ride"] = 2026.5, ["Mega|Fly|Ride"] = 640.01}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 19.05, ["Ride"] = 57.5, ["Fly|Ride"] = 206.24, ["Neon"] = 164.99, ["Neon|Ride"] = 284.82, ["Mega"] = 1049.99, ["Mega|Ride"] = 777.95, ["Mega|Fly|Ride"] = 824.92}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 12.93, ["Ride"] = 57.21, ["Fly|Ride"] = 105, ["Neon"] = 126.37, ["Neon|Fly"] = 420, ["Neon|Ride"] = 135.1, ["Neon|Fly|Ride"] = 279.93, ["Mega"] = 537.85, ["Mega|Ride"] = 528.67, ["Mega|Fly|Ride"] = 713.91}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 17.74, ["Ride"] = 15.26, ["Fly|Ride"] = 32.74, ["Neon"] = 6.18, ["Neon|Fly"] = 27.02, ["Neon|Ride"] = 27.46, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 163.96, ["Mega|Ride"] = 80.05, ["Mega|Fly|Ride"] = 399.07}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1890}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 59.06, ["Ride"] = 123.76, ["Fly|Ride"] = 412.47, ["Neon"] = 344.4, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 1133.23, ["Mega|Fly|Ride"] = 1237.37}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 79.73, ["Neon"] = 3.61, ["Neon|Ride"] = 42.95, ["Neon|Fly|Ride"] = 288.73, ["Mega"] = 28.02, ["Mega|Ride"] = 84.94}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 30.39, ["Ride"] = 110.36, ["Fly|Ride"] = 167.06, ["Neon"] = 130.96, ["Neon|Ride"] = 279.62, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 769.78, ["Mega|Ride"] = 777.95, ["Mega|Fly|Ride"] = 1237.37}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 3.82, ["Mega"] = 23.57}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Mega"] = 40.68, ["Mega|Ride"] = 151.41}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 114.55, ["Fly"] = 350.64, ["Ride"] = 146.86, ["Fly|Ride"] = 288.73, ["Neon"] = 2640.48, ["Neon|Ride"] = 588, ["Neon|Fly|Ride"] = 771.3, ["Mega|Ride"] = 2543.82, ["Mega|Fly|Ride"] = 2001.57}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 35.07, ["Fly|Ride"] = 95.01, ["Neon"] = 9.19, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 114.19, ["Mega"] = 90.57, ["Mega|Ride"] = 96.94, ["Mega|Fly|Ride"] = 281.71}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 38.07, ["Ride"] = 64.13, ["Fly|Ride"] = 86.63, ["Neon"] = 5.82, ["Neon|Ride"] = 40.84, ["Neon|Fly|Ride"] = 138.18, ["Mega"] = 36.75, ["Mega|Ride"] = 123.76, ["Mega|Fly|Ride"] = 687.78}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 4.23, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 209.99, ["Mega"] = 52.5, ["Mega|Ride"] = 275.33, ["Mega|Fly|Ride"] = 237.18}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 27.85, ["Neon"] = 5.07, ["Neon|Ride"] = 156.09, ["Mega"] = 81.81, ["Mega|Ride"] = 206.24}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 51.75, ["Ride"] = 135.19, ["Fly|Ride"] = 622.81, ["Neon"] = 424.07, ["Neon|Ride"] = 515.58, ["Neon|Fly|Ride"] = 695.63, ["Mega|Ride"] = 1546.71, ["Mega|Fly|Ride"] = 1512.68}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 6.55, ["Ride"] = 70, ["Neon"] = 78, ["Neon|Ride"] = 157.55, ["Mega"] = 469.19, ["Mega|Ride"] = 933.07}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 346.5, ["Ride"] = 481.55, ["Fly|Ride"] = 751.11, ["Neon"] = 918.75, ["Neon|Ride"] = 1375.55, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 4124.53}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 82.22}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 47.12}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 25.88}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 15.73}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 122.66}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 95.8}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 11.33}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 3.98}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 259.88}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 25.8}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 48.57}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 5.39}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 32.8}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 918.75}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 9.36}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 5.32}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 7.59}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 6.69}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 11.82}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 450.02}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 742.52}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 7.27}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1039.5}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 45.94}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 7.49}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 21.27}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.63}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 3.94}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 39.2}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 34.09}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 46.15}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 18.54}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 15.94}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 17.32}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 3.62}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 18.36}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 3.65}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 16.7}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 14.47}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 15.49}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 5.01}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 1968.75}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.24}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 33.66}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 301.88}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 4.2}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 4.69}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 8.98}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 6.89}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 46.49}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 193.17}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 10.14}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 10.8}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 1181.25}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 17.06}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 6}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 24.85}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 6.02}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 19.69}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 101.07}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 24.26}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 8.17}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.6}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 21.94}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 311.63}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 3.91}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 24.97}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.63}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 78.65}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 210}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 3.94}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 5.54}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 130.61}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 24.92}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 108.93}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 19.95}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.63}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22230.68}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 164.07}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 74.7}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 41.89}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 78.75}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 46.71}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 31.15}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 36.75}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 80.85}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 78.74}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 89.74}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 56.49}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 114.06}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 46.08}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 6909.44}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 6.57}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 6.14}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 11.82}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 23.55}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 52.48}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 110.55}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.1}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 3.48}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 3.94}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 11.45}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 8.68}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 756.96}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 9.9}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 583.75}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 11.7}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.63}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 606.89}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 30.95}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 115.31}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 25.1}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 45.94}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 11.8}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 3.57}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 7.59}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.1}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 15.73}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 2.87}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 28.67}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 5.24}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 2.47}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 2.75}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 31.76}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 262.5}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 52.06}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.63}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 7.23}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 1048.69}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 9.4}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 3.15}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 6.08}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 21.66}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 13.44}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 3.08}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 12.03}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 4.76}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 5.91}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 27.56}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 16.66}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 4.29}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 3.11}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 5}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 3.93}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 6.57}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 6.04}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 4.54}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 4.24}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 3.69}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 2.81}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 7837.55}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 8.27}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 17.75}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 2.15}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 8.69}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 5.81}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 9.79}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 10.49}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 2.59}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 3.56}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.3}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 30.17}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 6.49}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 3.71}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 2.3}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 3.12}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 6.2}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4318.23}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 8.12}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 27.17}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 6.37}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 2.91}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 63.62}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 103.15}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 8.05}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 129.84}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 11.46}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 3.55}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.1}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 8.39}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 7.18}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 24.07}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.61}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.63}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.55}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.15}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 15.54}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 2.57}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 2.91}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 5.3}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.43}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 28.83}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 3.82}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 3.47}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 8.56}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 78.66}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.53}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 62.09}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 4.46}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 30.96}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1041.5}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.14}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 26.03}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.51}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 5.24}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 4.85}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 10.39}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 5.44}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 4.99}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 10.31}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.52}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 15.75}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 14.49}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.63}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 7.01}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 3.6}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 2.98}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 6.54}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 6.86}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.14}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 18.61}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 3.42}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 3.39}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 2.3}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.14}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 17.75}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 51.56}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 3.39}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 6.2}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 29.61}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 61.69}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 18.38}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 44.2}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 6.22}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 28.67}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.14}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 3.82}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 3.78}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 4.81}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 3.59}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 74.44}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 7.01}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 143.64}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 4.41}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1187.71}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 3.94}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 247.52}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 3.83}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.63}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.63}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 199.49}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 55.33}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 3.34}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 2.35}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 3.47}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 78.25}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 17.54}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 7.88}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 3.4}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.52}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 3.93}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 3.94}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 5.69}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 8.54}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 66.54}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 2.18}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 60.56}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 3.91}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 6.57}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.63}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 15.49}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 26.17}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 127.25}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.61}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 6.07}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 74.85}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 5.79}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 3.4}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.63}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 778.46}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 57.73}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 45.38}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 64.43}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 371.23}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 5.84}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.63}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 115.99}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.84}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 3.66}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 6.76}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 23.26}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 64.34}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 3.94}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 52.5}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 2.46}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 46.55}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 13.55}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 56.95}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 26.76}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 66.14}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 41.29}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 5.85}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 2.37}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 26.11}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 3.93}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.14}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 10.49}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 47.16}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 41.11}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 35.25}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 2023.74}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 9.17}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 8.26}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 19.56}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 328.13}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 14.43}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 11.85}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 10.21}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 6.28}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 10.76}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 315.19}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 50.61}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 41.4}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 55.7}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 6.2}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 72.69}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 165.27}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 63}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 1155}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 7.07}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 2337.87}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 551.24}},
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