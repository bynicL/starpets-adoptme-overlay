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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 699.72, ["Fly"] = 1119.22, ["Ride"] = 1048.93, ["Fly|Ride"] = 809.79, ["Neon"] = 6502.79, ["Neon|Ride"] = 4475.76, ["Neon|Fly|Ride"] = 3422.65}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 477.75, ["Fly"] = 503.92, ["Ride"] = 472.5, ["Fly|Ride"] = 541.38, ["Neon|Fly|Ride"] = 2361.19, ["Mega|Fly|Ride"] = 8247.67}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 5419.32, ["Ride"] = 4790.63, ["Fly|Ride"] = 4811.19, ["Neon"] = 25873.71, ["Neon|Fly|Ride"] = 31466.54, ["Mega|Fly|Ride"] = 72803.35}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 139.12, ["Ride"] = 155.59, ["Fly|Ride"] = 525, ["Neon"] = 972.65, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 943, ["Mega"] = 3498.16, ["Mega|Fly|Ride"] = 6196.79}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 523.69, ["Ride"] = 514, ["Fly|Ride"] = 551.25, ["Neon|Fly|Ride"] = 1719.38, ["Mega|Fly|Ride"] = 7224.96}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 9.98, ["Ride"] = 46.76, ["Fly|Ride"] = 119.59, ["Neon"] = 45.3, ["Neon|Ride"] = 108.06, ["Neon|Fly|Ride"] = 271.87, ["Mega"] = 262.5, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 409.5}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 3.92, ["Fly"] = 31.43, ["Ride"] = 23.05, ["Fly|Ride"] = 52.5, ["Neon"] = 20.91, ["Neon|Fly"] = 64.32, ["Neon|Ride"] = 39.88, ["Neon|Fly|Ride"] = 89.8, ["Mega"] = 129.03, ["Mega|Fly"] = 303.19, ["Mega|Ride"] = 179.82, ["Mega|Fly|Ride"] = 293.71}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 140.37, ["Ride"] = 282.19, ["Fly|Ride"] = 251.37, ["Neon"] = 522.9, ["Neon|Ride"] = 560.14, ["Neon|Fly|Ride"] = 626.07, ["Mega"] = 1858.81, ["Mega|Ride"] = 1888.07, ["Mega|Fly|Ride"] = 1676.19}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 32.42, ["Fly"] = 62.4, ["Ride"] = 45.65, ["Fly|Ride"] = 72.19, ["Neon"] = 277.54, ["Neon|Ride"] = 204.75, ["Neon|Fly|Ride"] = 233.58, ["Mega"] = 2100, ["Mega|Ride"] = 673.83, ["Mega|Fly|Ride"] = 720.29}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 23.07, ["Fly"] = 46.45, ["Ride"] = 27.3, ["Fly|Ride"] = 62.71, ["Neon"] = 279.03, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 182.53, ["Mega|Ride"] = 769.93, ["Mega|Fly|Ride"] = 519.23}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 52.48, ["Ride"] = 39.38, ["Fly|Ride"] = 144.38, ["Neon|Fly"] = 209.81, ["Neon|Ride"] = 249.66, ["Neon|Fly|Ride"] = 304.16, ["Mega|Ride"] = 1047.89, ["Mega|Fly|Ride"] = 1034.25}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 61.68}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 398.34, ["Ride"] = 360.94, ["Fly|Ride"] = 419.58, ["Neon"] = 1258.72, ["Neon|Ride"] = 1231.44, ["Neon|Fly|Ride"] = 1216.76, ["Mega|Fly|Ride"] = 3776.13}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 118.13, ["Fly"] = 140.58, ["Ride"] = 114.19, ["Fly|Ride"] = 138.65, ["Neon"] = 1399.28, ["Neon|Fly|Ride"] = 540.75, ["Mega|Fly|Ride"] = 2323.52}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.1, ["Fly"] = 32.52, ["Ride"] = 56.65, ["Fly|Ride"] = 65.63, ["Neon"] = 16.65, ["Neon|Ride"] = 67.17, ["Mega"] = 112.72, ["Mega|Ride"] = 171.95, ["Mega|Fly|Ride"] = 384.55}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 117.21, ["Fly"] = 124.69, ["Ride"] = 110.97, ["Fly|Ride"] = 169.4, ["Neon"] = 615.72, ["Neon|Ride"] = 630.13, ["Neon|Fly|Ride"] = 542.07, ["Mega"] = 2097.85, ["Mega|Fly|Ride"] = 1967.44}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 2.5, ["Fly"] = 24.04, ["Ride"] = 18.69, ["Fly|Ride"] = 58.75, ["Neon"] = 20.99, ["Neon|Fly"] = 104.91, ["Neon|Ride"] = 62.95, ["Neon|Fly|Ride"] = 91.87, ["Mega"] = 222.38, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 38.06, ["Ride"] = 69.57, ["Fly|Ride"] = 137.82, ["Neon"] = 139.13, ["Neon|Ride"] = 155.24, ["Neon|Fly|Ride"] = 241.26, ["Mega"] = 699.64, ["Mega|Ride"] = 774.89, ["Mega|Fly|Ride"] = 879.83}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 44.62}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 49.88, ["Fly"] = 70.3, ["Ride"] = 167.84, ["Fly|Ride"] = 170.63, ["Neon"] = 279.57, ["Neon|Ride"] = 348.37, ["Mega"] = 2936.99, ["Mega|Fly|Ride"] = 3098.41}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 11.42, ["Fly"] = 39.88, ["Ride"] = 32.02, ["Fly|Ride"] = 140.58, ["Neon"] = 59.07, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 258.27, ["Mega"] = 2672.03, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 650.6}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 36.74, ["Fly"] = 99.75, ["Ride"] = 45.94, ["Fly|Ride"] = 78.75, ["Neon"] = 386.03, ["Neon|Ride"] = 213.94, ["Neon|Fly|Ride"] = 254.63, ["Mega"] = 1681.32, ["Mega|Fly|Ride"] = 905.24}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 62.11, ["Ride"] = 155.76, ["Fly|Ride"] = 196.88, ["Neon"] = 209.95, ["Neon|Ride"] = 419.58, ["Neon|Fly|Ride"] = 404.92, ["Mega"] = 1678.29, ["Mega|Ride"] = 1245.08, ["Mega|Fly|Ride"] = 1203.13}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 20.99, ["Ride"] = 45.94, ["Fly|Ride"] = 133.23, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 408.19, ["Mega"] = 699.65, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 755.24}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 51.19, ["Fly"] = 77.64, ["Ride"] = 56.44, ["Fly|Ride"] = 97.56, ["Neon"] = 251.76, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 307.97, ["Mega|Ride"] = 2493.75, ["Mega|Fly|Ride"] = 938.79}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 2.63, ["Fly"] = 28.33, ["Ride"] = 18.31, ["Fly|Ride"] = 43.32, ["Neon"] = 23.24, ["Neon|Fly"] = 44.63, ["Neon|Ride"] = 56.43, ["Neon|Fly|Ride"] = 80.83, ["Mega"] = 126.6, ["Mega|Fly"] = 419.58, ["Mega|Ride"] = 170.62, ["Mega|Fly|Ride"] = 222.37}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 292.04, ["Ride"] = 314.7, ["Fly|Ride"] = 367.5, ["Neon|Ride"] = 2936.99, ["Neon|Fly|Ride"] = 1416.19, ["Mega"] = 10489.2, ["Mega|Fly|Ride"] = 5421.9}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 15.72, ["Ride"] = 34.13, ["Fly|Ride"] = 49.31, ["Neon"] = 238.11, ["Neon|Ride"] = 209.81, ["Mega"] = 825.51, ["Mega|Fly|Ride"] = 738.46}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 4.17, ["Fly"] = 32.81, ["Ride"] = 19.69, ["Fly|Ride"] = 41.42, ["Neon"] = 41.97, ["Neon|Fly"] = 89.25, ["Neon|Ride"] = 64.93, ["Neon|Fly|Ride"] = 112.25, ["Mega"] = 350.36, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 95.82, ["Fly"] = 182.53, ["Ride"] = 119.33, ["Fly|Ride"] = 140.58, ["Neon"] = 280.35, ["Neon|Fly"] = 419.58, ["Neon|Ride"] = 343.01, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 6156.12, ["Mega|Ride"] = 3098.41, ["Mega|Fly|Ride"] = 2028.63}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 15.23, ["Ride"] = 31.49, ["Fly|Ride"] = 115.5, ["Neon"] = 150.97, ["Neon|Ride"] = 140.58, ["Neon|Fly|Ride"] = 207.38, ["Mega"] = 696.49}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 203.44, ["Ride"] = 226.1, ["Fly|Ride"] = 335.67, ["Neon"] = 699.65, ["Neon|Ride"] = 743.19, ["Neon|Fly|Ride"] = 828.19, ["Mega"] = 6293.53, ["Mega|Fly|Ride"] = 2479.19}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 25.99}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 2.63, ["Fly"] = 31.39, ["Ride"] = 31.49, ["Fly|Ride"] = 61.9, ["Neon"] = 18.38, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 41.97, ["Neon|Fly|Ride"] = 84, ["Mega"] = 158.82, ["Mega|Fly"] = 224.48, ["Mega|Ride"] = 209.81, ["Mega|Fly|Ride"] = 278.83}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 471.49, ["Ride"] = 624.15, ["Fly|Ride"] = 623.44, ["Neon"] = 3049.23, ["Neon|Ride"] = 3040.84, ["Neon|Fly|Ride"] = 2756.25, ["Mega"] = 11888.46, ["Mega|Ride"] = 52278.72, ["Mega|Fly|Ride"] = 9790.62}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 12.11, ["Fly"] = 45.3, ["Ride"] = 28.84, ["Fly|Ride"] = 71.34, ["Neon"] = 49.31, ["Neon|Fly"] = 140.58, ["Neon|Ride"] = 102.1, ["Neon|Fly|Ride"] = 175.19, ["Mega"] = 526.32, ["Mega|Ride"] = 597.91, ["Mega|Fly|Ride"] = 661.89}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 111.39, ["Ride"] = 147, ["Fly|Ride"] = 196.88, ["Neon"] = 615.72, ["Neon|Ride"] = 419.58, ["Neon|Fly|Ride"] = 615.72, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 2787.05}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 65.84}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 31.49, ["Ride"] = 167.84, ["Fly|Ride"] = 196.88, ["Neon"] = 157.5, ["Neon|Ride"] = 245.46, ["Neon|Fly|Ride"] = 273.74, ["Mega"] = 627.27, ["Mega|Ride"] = 620.39, ["Mega|Fly|Ride"] = 699.65}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["Ride"] = 208.69, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 608.39, ["Mega|Fly|Ride"] = 2306.59}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 131.25, ["Ride"] = 129.94, ["Fly|Ride"] = 196.88, ["Neon"] = 497.06, ["Neon|Ride"] = 404.94, ["Neon|Fly|Ride"] = 464.63, ["Mega|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 1468.69}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 57.74}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 59.27, ["Fly"] = 77.64, ["Ride"] = 46.49, ["Fly|Ride"] = 65.51, ["Neon|Ride"] = 280.08, ["Neon|Fly|Ride"] = 314.1, ["Mega"] = 4195.69, ["Mega|Fly|Ride"] = 1258.69}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 5.24, ["Ride"] = 48.55, ["Fly|Ride"] = 131.25, ["Neon"] = 32.82, ["Neon|Ride"] = 140.58, ["Neon|Fly|Ride"] = 237.06, ["Mega"] = 175.19, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 251.76, ["Mega|Fly|Ride"] = 329.38}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 303.19, ["Fly"] = 576.18, ["Ride"] = 309.75, ["Fly|Ride"] = 353.07, ["Neon|Ride"] = 1959.4, ["Neon|Fly|Ride"] = 1207.5, ["Mega|Fly|Ride"] = 4802.68}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 68.19, ["Fly"] = 99.75, ["Ride"] = 77.67, ["Fly|Ride"] = 147, ["Neon"] = 262.5, ["Neon|Fly"] = 328.13, ["Neon|Ride"] = 280.08, ["Neon|Fly|Ride"] = 392.32, ["Mega|Fly|Ride"] = 1468.5}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3565.29, ["Fly"] = 3776.13, ["Ride"] = 3018.75, ["Fly|Ride"] = 3412.5, ["Neon|Fly|Ride"] = 13634.92}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 31.97, ["Fly"] = 56.65, ["Ride"] = 41.97, ["Fly|Ride"] = 119.62, ["Neon"] = 324.86, ["Neon|Ride"] = 278.7, ["Neon|Fly|Ride"] = 280.08, ["Mega"] = 1888.07, ["Mega|Ride"] = 1888.07, ["Mega|Fly|Ride"] = 1329}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 238.11, ["Ride"] = 41.97, ["Fly|Ride"] = 147, ["Neon"] = 371.61, ["Neon|Ride"] = 268.26, ["Neon|Fly|Ride"] = 560.14, ["Mega"] = 6293.53, ["Mega|Ride"] = 1858.81, ["Mega|Fly|Ride"] = 1504.17}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 28.66, ["Fly"] = 73.94, ["Ride"] = 39.38, ["Fly|Ride"] = 65.63, ["Neon"] = 105, ["Neon|Fly"] = 273, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 203.42, ["Mega"] = 2598.75, ["Mega|Fly|Ride"] = 627.38}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 11.58}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 63, ["Ride"] = 59.07, ["Fly|Ride"] = 105, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 503.5, ["Mega|Fly|Ride"] = 1704.3}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 34.78}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 227.07, ["Ride"] = 196.88, ["Fly|Ride"] = 341.25, ["Neon|Fly|Ride"] = 2097.85}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 656.25, ["Ride"] = 616.88, ["Fly|Ride"] = 656.25, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2100, ["Mega|Fly|Ride"] = 11812.5}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 7.29}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 29.93, ["Fly"] = 52.49, ["Ride"] = 32.82, ["Fly|Ride"] = 80.78, ["Neon"] = 266.44, ["Neon|Fly"] = 209.81, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 155.69, ["Mega|Fly"] = 560.14, ["Mega|Fly|Ride"] = 752.07}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 8.39}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5040, ["Fly"] = 5248.69, ["Fly|Ride"] = 4854.94, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 40419.05}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 10, ["Ride"] = 23.63, ["Fly|Ride"] = 62.71, ["Neon"] = 70.3, ["Neon|Ride"] = 107.63, ["Neon|Fly|Ride"] = 219.57, ["Mega"] = 310.21, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 13.13, ["Fly"] = 78.69, ["Ride"] = 41.97, ["Fly|Ride"] = 114.22, ["Neon"] = 140.58, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 699.65, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 86.63, ["Fly"] = 98.61, ["Ride"] = 75.54, ["Fly|Ride"] = 187.69}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 11.55, ["Ride"] = 36.72, ["Fly|Ride"] = 139.65, ["Neon"] = 61.9, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 306.3, ["Mega"] = 1119.22, ["Mega|Ride"] = 839.15, ["Mega|Fly|Ride"] = 984.38}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 2494.17, ["Fly"] = 2181.38, ["Ride"] = 2592.23, ["Fly|Ride"] = 2100, ["Neon|Fly|Ride"] = 3953.25, ["Mega|Fly|Ride"] = 11188.84}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 29410.23, ["Fly"] = 26250, ["Ride"] = 22706.25, ["Fly|Ride"] = 23625, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 69788.79, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 195798.59}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 23.05, ["Fly"] = 393.75, ["Ride"] = 39.35, ["Fly|Ride"] = 90.22, ["Neon"] = 236.25, ["Neon|Ride"] = 178.38, ["Neon|Fly|Ride"] = 314.7, ["Mega"] = 1470, ["Mega|Ride"] = 734.26, ["Mega|Fly|Ride"] = 948.49}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 2.1, ["Ride"] = 28.33, ["Fly|Ride"] = 104.91, ["Neon"] = 14.44, ["Neon|Fly"] = 129.34, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 119.44, ["Mega"] = 111.86, ["Mega|Ride"] = 140.58, ["Mega|Fly|Ride"] = 245.44}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 26.18}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 5.24, ["Ride"] = 39.87, ["Fly|Ride"] = 280.08, ["Neon"] = 42.97, ["Neon|Ride"] = 124.36, ["Neon|Fly|Ride"] = 463.32, ["Mega"] = 183.75, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 392.44}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 708.75, ["Fly"] = 835.87, ["Ride"] = 682.5, ["Fly|Ride"] = 845.54, ["Neon|Ride"] = 2771.83, ["Neon|Fly|Ride"] = 2625, ["Mega"] = 11188.84, ["Mega|Fly|Ride"] = 10769.27}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 910.88, ["Fly"] = 1076.25, ["Ride"] = 931.88, ["Fly|Ride"] = 1069.69, ["Neon|Ride"] = 2926.26, ["Neon|Fly|Ride"] = 3874.45, ["Mega|Fly|Ride"] = 13986.3}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 23.63, ["Fly"] = 56.65, ["Ride"] = 39.38, ["Fly|Ride"] = 83.93, ["Neon"] = 91.88, ["Neon|Ride"] = 155.63, ["Neon|Fly|Ride"] = 209.73, ["Mega|Fly|Ride"] = 698.6}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 31.16}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 64.32, ["Fly"] = 109.15, ["Ride"] = 75.33, ["Fly|Ride"] = 85.32, ["Neon|Fly"] = 280.08, ["Neon|Ride"] = 375.38, ["Neon|Fly|Ride"] = 380.63, ["Mega|Fly|Ride"] = 1533.52}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 77.79, ["Fly"] = 131.25, ["Ride"] = 112.49, ["Fly|Ride"] = 170.63, ["Neon"] = 441, ["Neon|Ride"] = 559.58, ["Neon|Fly|Ride"] = 15490.77, ["Mega"] = 2113.81, ["Mega|Ride"] = 1678.29, ["Mega|Fly|Ride"] = 1433.9}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 4.19, ["Fly"] = 40.92, ["Ride"] = 21.74, ["Fly|Ride"] = 54.39, ["Neon"] = 23.24, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 280.08, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 375.8}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 82.83, ["Fly"] = 93.18, ["Ride"] = 74.17, ["Fly|Ride"] = 131.25, ["Neon"] = 1119.22, ["Neon|Ride"] = 343.01, ["Neon|Fly|Ride"] = 283.5, ["Mega|Fly|Ride"] = 1128.75}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 3.94, ["Ride"] = 31.37, ["Fly|Ride"] = 73.6, ["Neon"] = 28.33, ["Neon|Fly"] = 266.44, ["Neon|Ride"] = 91.59, ["Neon|Fly|Ride"] = 560.14, ["Mega"] = 98.44, ["Mega|Fly"] = 1119.22, ["Mega|Ride"] = 285.8, ["Mega|Fly|Ride"] = 426.43}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 15.57, ["Fly"] = 60.85, ["Ride"] = 39.38, ["Fly|Ride"] = 70.3, ["Neon"] = 262.5, ["Neon|Ride"] = 111.55, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 1050, ["Mega|Fly|Ride"] = 615.72}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 26.13, ["Ride"] = 291.38, ["Fly|Ride"] = 272.73, ["Neon"] = 133.88, ["Neon|Ride"] = 343.73, ["Neon|Fly|Ride"] = 131.25, ["Mega|Ride"] = 2097.85, ["Mega|Fly|Ride"] = 727.96}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 18.36, ["Fly"] = 85.72, ["Ride"] = 26.25, ["Fly|Ride"] = 79.73, ["Neon"] = 96.26, ["Neon|Ride"] = 171.95, ["Neon|Fly|Ride"] = 140.58, ["Mega"] = 629.37, ["Mega|Ride"] = 909.43, ["Mega|Fly|Ride"] = 909.43}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6965.05, ["Fly"] = 5454.4, ["Ride"] = 4856.25, ["Fly|Ride"] = 4959.94, ["Neon"] = 30770.06, ["Neon|Fly|Ride"] = 26250, ["Mega|Fly|Ride"] = 89508.47}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 211.97, ["Fly"] = 242.32, ["Ride"] = 232.87, ["Fly|Ride"] = 271.15, ["Neon|Fly|Ride"] = 623.44, ["Mega|Fly|Ride"] = 1928.98}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 19.69, ["Fly"] = 78.75, ["Ride"] = 38.07, ["Fly|Ride"] = 105, ["Neon"] = 63, ["Neon|Fly"] = 109.16, ["Neon|Ride"] = 91.7, ["Neon|Fly|Ride"] = 181.05, ["Mega"] = 300.57, ["Mega|Fly"] = 523.43, ["Mega|Ride"] = 261.98, ["Mega|Fly|Ride"] = 333.38}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 3.56, ["Fly"] = 40.65, ["Ride"] = 20.93, ["Fly|Ride"] = 65.63, ["Neon"] = 15.75, ["Neon|Ride"] = 52.5, ["Mega"] = 140.44}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 26.25, ["Fly"] = 5263.22, ["Ride"] = 65.62, ["Fly|Ride"] = 131.25, ["Neon"] = 104.74, ["Neon|Fly"] = 333.27, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 232.19, ["Mega"] = 419.58, ["Mega|Ride"] = 406.04, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 18571.88, ["Ride"] = 11519.82, ["Fly|Ride"] = 11510.63, ["Neon|Fly|Ride"] = 23625, ["Mega|Fly|Ride"] = 108430.7}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 140.58, ["Ride"] = 196.87, ["Fly|Ride"] = 276.94, ["Neon"] = 2097.85, ["Neon|Fly|Ride"] = 840, ["Mega"] = 4615.26, ["Mega|Fly|Ride"] = 4526.19}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 60.94, ["Fly"] = 459.38, ["Ride"] = 45.94, ["Fly|Ride"] = 95.73, ["Neon|Fly"] = 464.5, ["Neon|Ride"] = 264.34, ["Neon|Fly|Ride"] = 341.25, ["Mega|Fly|Ride"] = 1090.89}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 9.96, ["Ride"] = 27.28, ["Fly|Ride"] = 53.38, ["Neon"] = 65.14, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 173.39, ["Mega"] = 2517.42, ["Mega|Ride"] = 492.19, ["Mega|Fly|Ride"] = 1045.79}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 360.94, ["Fly"] = 839.15, ["Ride"] = 404.35, ["Fly|Ride"] = 446.25, ["Neon"] = 1640.63, ["Neon|Ride"] = 1820.47, ["Neon|Fly|Ride"] = 1350.57, ["Mega"] = 5189.77, ["Mega|Fly|Ride"] = 5021.19}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 5.2, ["Ride"] = 38.07, ["Fly|Ride"] = 92.92, ["Neon"] = 18.59, ["Neon|Ride"] = 109.22, ["Neon|Fly|Ride"] = 139.12, ["Mega"] = 135.29, ["Mega|Ride"] = 178.5, ["Mega|Fly|Ride"] = 238.11}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 139.13, ["Fly"] = 156.29, ["Ride"] = 143.47, ["Fly|Ride"] = 183.75, ["Neon"] = 419.58, ["Neon|Ride"] = 452.37, ["Neon|Fly|Ride"] = 426.57, ["Mega"] = 1574.99, ["Mega|Fly|Ride"] = 1706.6}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 14, ["Fly"] = 13.13, ["Ride"] = 15.73, ["Fly|Ride"] = 39.57, ["Neon|Fly"] = 140.58, ["Neon|Ride"] = 102.12, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 2517.42, ["Mega|Fly|Ride"] = 565.39}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 7.85}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 64.32, ["Ride"] = 112.25, ["Fly|Ride"] = 525, ["Neon"] = 393.75, ["Neon|Fly"] = 1678.29, ["Neon|Ride"] = 367.14, ["Neon|Fly|Ride"] = 688.09, ["Mega|Ride"] = 1394.12, ["Mega|Fly|Ride"] = 1533.52}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 10.49, ["Ride"] = 31.37, ["Fly|Ride"] = 77.64, ["Neon"] = 84.55, ["Neon|Ride"] = 123.9, ["Neon|Fly|Ride"] = 139.42, ["Mega|Ride"] = 545.45, ["Mega|Fly|Ride"] = 928.24}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 19.69}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 28.88, ["Fly"] = 210, ["Ride"] = 76.13, ["Fly|Ride"] = 278.7, ["Neon"] = 133.88, ["Neon|Ride"] = 105.05, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 691.25, ["Mega|Ride"] = 797.19, ["Mega|Fly|Ride"] = 654.94}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.83, ["Ride"] = 23.09, ["Neon"] = 18.83, ["Neon|Ride"] = 137.42, ["Neon|Fly|Ride"] = 321.57, ["Mega"] = 114.55, ["Mega|Ride"] = 280.08, ["Mega|Fly|Ride"] = 400.98}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 16.75, ["Fly"] = 56.65, ["Ride"] = 30.27, ["Fly|Ride"] = 91.87, ["Neon"] = 213.57, ["Neon|Ride"] = 154.88, ["Neon|Fly|Ride"] = 140.58, ["Mega|Ride"] = 620.39, ["Mega|Fly|Ride"] = 690.2}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 393.75, ["Fly"] = 437.75, ["Ride"] = 367.5, ["Fly|Ride"] = 323.49, ["Neon|Fly|Ride"] = 1646.82, ["Mega|Fly|Ride"] = 8810.93}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 37.69, ["Ride"] = 52.5, ["Fly|Ride"] = 136.5, ["Neon"] = 209.81, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 335.67, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 699.65}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 56.39, ["Ride"] = 77.12, ["Neon"] = 209.81, ["Neon|Ride"] = 157.5, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1329}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 19.69, ["Fly"] = 69.68, ["Ride"] = 52.06, ["Fly|Ride"] = 98.61, ["Neon"] = 90.46, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 315, ["Mega"] = 322.04, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 11146.44, ["Ride"] = 11089.97, ["Fly|Ride"] = 8117.82, ["Neon|Fly|Ride"] = 16859.07, ["Mega|Fly|Ride"] = 39372.9}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 2377.54, ["Ride"] = 2517.42, ["Fly|Ride"] = 1885.8, ["Neon"] = 4593.75, ["Neon|Ride"] = 5806.06, ["Neon|Fly|Ride"] = 5193.56, ["Mega|Fly|Ride"] = 17349.57}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 328.13, ["Ride"] = 419.58, ["Fly|Ride"] = 373.43, ["Neon"] = 1399.28, ["Neon|Ride"] = 1384.69, ["Neon|Fly|Ride"] = 1370.96, ["Mega"] = 16782.71, ["Mega|Fly|Ride"] = 6293.53}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 14.15, ["Fly"] = 26.25, ["Ride"] = 22.11, ["Fly|Ride"] = 44.6, ["Neon"] = 125.89, ["Neon|Ride"] = 108.06, ["Neon|Fly|Ride"] = 280.08, ["Mega|Fly|Ride"] = 503.5}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 3.84, ["Ride"] = 61.69, ["Fly|Ride"] = 153.57, ["Neon"] = 24.93, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 232.37, ["Mega"] = 118.13, ["Mega|Ride"] = 209.81, ["Mega|Fly|Ride"] = 318.89}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 31.38, ["Fly"] = 45.94, ["Ride"] = 41.97, ["Fly|Ride"] = 78.62, ["Neon|Fly"] = 139.35, ["Neon|Ride"] = 195.57, ["Neon|Fly|Ride"] = 157.49, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 2.1, ["Fly"] = 25.56, ["Ride"] = 18.38, ["Fly|Ride"] = 44.63, ["Neon"] = 28.33, ["Neon|Fly"] = 58.08, ["Neon|Ride"] = 36.73, ["Neon|Fly|Ride"] = 87.94, ["Mega"] = 155.26, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 255.94}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 341.25, ["Fly"] = 317.63, ["Ride"] = 282.19, ["Fly|Ride"] = 328.13, ["Neon|Ride"] = 1237.87, ["Neon|Fly|Ride"] = 1102.5, ["Mega|Fly|Ride"] = 3281.25}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 19.69, ["Fly"] = 56.65, ["Ride"] = 45.93, ["Fly|Ride"] = 70.3, ["Neon"] = 121.69, ["Neon|Fly"] = 464.5, ["Neon|Ride"] = 140.58, ["Neon|Fly|Ride"] = 170.63, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 699.65}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 10.48, ["Fly"] = 19.9, ["Ride"] = 28.33, ["Fly|Ride"] = 41.97, ["Neon"] = 62.71, ["Neon|Fly"] = 136.5, ["Neon|Ride"] = 109.16, ["Neon|Fly|Ride"] = 116.82, ["Mega"] = 524.48, ["Mega|Ride"] = 577.97, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 419.58, ["Fly"] = 787.5, ["Ride"] = 465.94, ["Fly|Ride"] = 449.4, ["Mega|Fly|Ride"] = 8659.69}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1046.07, ["Fly"] = 1238.89, ["Ride"] = 1244.25, ["Fly|Ride"] = 1291.79, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 17703.68}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 98.44, ["Fly"] = 107.01, ["Ride"] = 82.88, ["Fly|Ride"] = 123.38, ["Neon"] = 560.14, ["Neon|Ride"] = 414.75, ["Neon|Fly|Ride"] = 464.71, ["Mega|Fly|Ride"] = 1312.49}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 157.5, ["Fly"] = 251.76, ["Ride"] = 196.88, ["Fly|Ride"] = 255.94, ["Neon"] = 686.01, ["Neon|Ride"] = 732.38, ["Neon|Fly|Ride"] = 527.24, ["Mega|Ride"] = 7290.94, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 22.32, ["Ride"] = 56.44, ["Neon"] = 274.83, ["Neon|Ride"] = 279.03, ["Neon|Fly|Ride"] = 839.15, ["Mega|Ride"] = 929.41, ["Mega|Fly|Ride"] = 1033.97}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 141.75, ["Ride"] = 167.84, ["Fly|Ride"] = 597.19, ["Neon"] = 1538.78, ["Neon|Ride"] = 1258.72, ["Neon|Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 2991.53}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 1534.32, ["Fly"] = 2517.42, ["Ride"] = 1522.53, ["Fly|Ride"] = 1967.44, ["Neon|Fly|Ride"] = 6562.49, ["Mega|Fly|Ride"] = 31909.78}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 17.43, ["Ride"] = 56.65, ["Fly|Ride"] = 262.45, ["Neon"] = 288.47, ["Neon|Ride"] = 280.08, ["Neon|Fly|Ride"] = 229.69, ["Mega"] = 1959.4, ["Mega|Ride"] = 2307.64, ["Mega|Fly|Ride"] = 1963.6}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 616.88, ["Fly"] = 675.94, ["Ride"] = 589.32, ["Fly|Ride"] = 636.6, ["Neon"] = 1399.28, ["Neon|Ride"] = 1455.91, ["Neon|Fly|Ride"] = 1102.5, ["Mega|Fly|Ride"] = 2782.5}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 51.91, ["Fly"] = 62.95, ["Ride"] = 52.5, ["Fly|Ride"] = 105, ["Neon"] = 209.81, ["Neon|Ride"] = 513.45, ["Neon|Fly|Ride"] = 167.84, ["Mega|Fly|Ride"] = 825.27}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.62, ["Fly"] = 31.49, ["Ride"] = 19.93, ["Fly|Ride"] = 45.94, ["Neon"] = 17.46, ["Neon|Fly"] = 62.99, ["Neon|Ride"] = 31.38, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 121.69, ["Mega|Ride"] = 140.58, ["Mega|Fly|Ride"] = 208.69}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 37.37, ["Ride"] = 66.94, ["Fly|Ride"] = 252, ["Neon"] = 699.65, ["Neon|Ride"] = 769.93, ["Mega"] = 1394.12, ["Mega|Ride"] = 1119.22, ["Mega|Fly|Ride"] = 6993.16}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 518.44, ["Fly"] = 1109.83, ["Ride"] = 535.5, ["Fly|Ride"] = 525, ["Neon"] = 2322.43, ["Neon|Ride"] = 2238.42, ["Neon|Fly|Ride"] = 1907.07, ["Mega|Fly|Ride"] = 5643.75}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 446.25, ["Ride"] = 523.68, ["Fly|Ride"] = 656.25, ["Neon"] = 8391.36, ["Neon|Ride"] = 4068.75, ["Neon|Fly|Ride"] = 2441.25, ["Mega|Fly|Ride"] = 17797.02}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 15, ["Fly"] = 32.82, ["Ride"] = 26.25, ["Fly|Ride"] = 40.42, ["Neon"] = 140.58, ["Neon|Ride"] = 87.1, ["Neon|Fly|Ride"] = 132.57, ["Mega|Fly|Ride"] = 619.43}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 7.69, ["Ride"] = 19.69, ["Fly|Ride"] = 39.38, ["Neon"] = 70.3, ["Neon|Ride"] = 77.82, ["Neon|Fly|Ride"] = 183.58, ["Mega"] = 459.44, ["Mega|Ride"] = 459.44, ["Mega|Fly|Ride"] = 620.39}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 3.92, ["Ride"] = 26.25, ["Fly|Ride"] = 91.27, ["Neon"] = 17.67, ["Neon|Fly"] = 109.66, ["Neon|Ride"] = 38.06, ["Neon|Fly|Ride"] = 189, ["Mega"] = 132.17, ["Mega|Ride"] = 123.38, ["Mega|Fly|Ride"] = 225.75}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 32.82, ["Fly"] = 56.69, ["Ride"] = 32.82, ["Fly|Ride"] = 84, ["Neon"] = 250.83, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 196.88, ["Mega|Fly|Ride"] = 714.82}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 31.49, ["Ride"] = 91.88, ["Fly|Ride"] = 620.09, ["Neon"] = 280.08, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1119.22, ["Mega|Ride"] = 1048.93, ["Mega|Fly|Ride"] = 1245.08}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 15.72, ["Fly"] = 57.11, ["Ride"] = 35.68, ["Fly|Ride"] = 62.71, ["Neon"] = 52.46, ["Neon|Ride"] = 92.93, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 656.25, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 440.56}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 35.63, ["Fly"] = 77.64, ["Ride"] = 34.91, ["Fly|Ride"] = 77.8, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 210, ["Mega"] = 2100, ["Mega|Ride"] = 1208.23, ["Mega|Fly|Ride"] = 897.89}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 4.19, ["Fly"] = 38.07, ["Ride"] = 17.16, ["Fly|Ride"] = 38.96, ["Neon"] = 34.29, ["Neon|Ride"] = 35.67, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 248.63, ["Mega|Ride"] = 464.71, ["Mega|Fly|Ride"] = 313.65}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 3.94, ["Fly"] = 58.75, ["Ride"] = 26.92, ["Fly|Ride"] = 1838.22, ["Neon"] = 39.38, ["Neon|Fly"] = 155.63, ["Neon|Ride"] = 49.24, ["Neon|Fly|Ride"] = 128.61, ["Mega"] = 232.37, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 48.28, ["Fly"] = 60.37, ["Ride"] = 45.72, ["Fly|Ride"] = 90.57, ["Neon"] = 419.58, ["Neon|Ride"] = 232.37, ["Neon|Fly|Ride"] = 216.57, ["Mega|Fly|Ride"] = 839.15}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 2168.57, ["Fly"] = 2412.54, ["Ride"] = 2034.38, ["Fly|Ride"] = 2034.38, ["Neon|Ride"] = 5244.61, ["Neon|Fly|Ride"] = 3924.37, ["Mega|Fly|Ride"] = 14003.07}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 464.36, ["Fly"] = 577.97, ["Ride"] = 414.75, ["Fly|Ride"] = 531.82, ["Neon"] = 3096.97, ["Neon|Ride"] = 3077.54, ["Neon|Fly|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 7875}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 291.38, ["Ride"] = 328.83, ["Fly|Ride"] = 393.75, ["Neon|Ride"] = 1640.63, ["Neon|Fly|Ride"] = 1735.97, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 38.04}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 26.17, ["Fly"] = 65.63, ["Ride"] = 57.37, ["Fly|Ride"] = 78.75, ["Neon"] = 288.75, ["Neon|Ride"] = 238.11, ["Neon|Fly|Ride"] = 418.98, ["Mega"] = 1152.78, ["Mega|Ride"] = 1468.5, ["Mega|Fly|Ride"] = 1231.13}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 30770.06, ["Fly"] = 20998.69, ["Ride"] = 34781.25, ["Fly|Ride"] = 15093.75, ["Neon|Fly|Ride"] = 36748.69, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 223.13, ["Fly"] = 280.08, ["Ride"] = 241.5, ["Fly|Ride"] = 275.63, ["Neon"] = 576.18, ["Neon|Fly"] = 1093.87, ["Neon|Ride"] = 690.2, ["Neon|Fly|Ride"] = 616.88, ["Mega"] = 3483.47, ["Mega|Ride"] = 2462.87, ["Mega|Fly|Ride"] = 2418.94}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 5250, ["Ride"] = 111.57, ["Fly|Ride"] = 257.25, ["Neon|Fly|Ride"] = 1704.3, ["Mega|Fly|Ride"] = 4056.19}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 105, ["Ride"] = 103.69, ["Fly|Ride"] = 169.32, ["Neon"] = 562.04, ["Neon|Ride"] = 527.2, ["Neon|Fly|Ride"] = 560.14, ["Mega"] = 13986.3, ["Mega|Fly|Ride"] = 1572.35}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 14.41, ["Fly"] = 94.5, ["Ride"] = 28.13, ["Fly|Ride"] = 77.64, ["Neon"] = 98.61, ["Neon|Ride"] = 135.19, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 620.39, ["Mega|Ride"] = 599.47}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 3150, ["Ride"] = 4331.25, ["Fly|Ride"] = 4265.2, ["Neon|Fly|Ride"] = 17062.5}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 26.12, ["Fly"] = 53.51, ["Ride"] = 31.33, ["Fly|Ride"] = 56.44, ["Neon"] = 131.25, ["Neon|Ride"] = 139.35, ["Neon|Fly|Ride"] = 168, ["Mega|Fly|Ride"] = 623.44}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 45.3, ["Fly"] = 62.71, ["Ride"] = 45.77, ["Fly|Ride"] = 91.88, ["Neon"] = 148.65, ["Neon|Ride"] = 279.03, ["Neon|Fly|Ride"] = 216.09, ["Mega"] = 976.57, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 525, ["Fly"] = 656.25, ["Ride"] = 523.68, ["Fly|Ride"] = 656.24, ["Neon"] = 1666.88, ["Neon|Ride"] = 1535.45, ["Neon|Fly|Ride"] = 1438.5, ["Mega|Ride"] = 6293.53, ["Mega|Fly|Ride"] = 3936.19}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 13.11, ["Fly"] = 23.63, ["Ride"] = 20.99, ["Fly|Ride"] = 55.13, ["Neon"] = 104.91, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 119.65, ["Mega"] = 699.65, ["Mega|Fly|Ride"] = 461.64}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 20.77, ["Ride"] = 139.13, ["Fly|Ride"] = 136.37, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 131.25}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 98.61, ["Ride"] = 124.69, ["Fly|Ride"] = 165.38, ["Neon"] = 574.83, ["Neon|Ride"] = 649.29, ["Neon|Fly|Ride"] = 551.25, ["Mega|Fly|Ride"] = 2936.99}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 22.24, ["Fly"] = 77.64, ["Ride"] = 90.57, ["Fly|Ride"] = 140.58, ["Neon"] = 51.11, ["Neon|Fly"] = 123.79, ["Neon|Ride"] = 140.58, ["Neon|Fly|Ride"] = 209.81, ["Mega"] = 140.58, ["Mega|Fly"] = 523.69, ["Mega|Ride"] = 241.49, ["Mega|Fly|Ride"] = 432.17}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3767.28, ["Ride"] = 3143.7, ["Fly|Ride"] = 3018.48, ["Neon"] = 12386.66, ["Neon|Ride"] = 17032.65, ["Neon|Fly|Ride"] = 7021.88, ["Mega"] = 62935.15, ["Mega|Fly|Ride"] = 27971.54}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 40.68, ["Fly"] = 210, ["Ride"] = 52.5, ["Fly|Ride"] = 112.25, ["Neon"] = 161.55, ["Neon|Ride"] = 140.76, ["Neon|Fly|Ride"] = 209.81, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 6993.16, ["Fly"] = 7875, ["Ride"] = 7804.13, ["Fly|Ride"] = 5512.5, ["Neon|Fly|Ride"] = 13125, ["Mega|Fly|Ride"] = 62865.93}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.54, ["Fly"] = 19.68, ["Ride"] = 15.73, ["Fly|Ride"] = 36.94, ["Neon"] = 20.99, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 39.87, ["Neon|Fly|Ride"] = 84.04, ["Mega"] = 146.87, ["Mega|Fly|Ride"] = 217.26}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 13.13, ["Fly"] = 35.69, ["Ride"] = 31.49, ["Fly|Ride"] = 45.94, ["Neon"] = 140.58, ["Neon|Ride"] = 280.08, ["Neon|Fly|Ride"] = 249.38, ["Mega|Ride"] = 1342.05, ["Mega|Fly|Ride"] = 927.09}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 13.84, ["Ride"] = 27.53, ["Fly|Ride"] = 140.58, ["Neon"] = 63, ["Neon|Ride"] = 153.57, ["Neon|Fly|Ride"] = 167.84, ["Mega|Ride"] = 699.65, ["Mega|Fly|Ride"] = 839.15}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 41.97, ["Fly"] = 41.97, ["Ride"] = 50.54, ["Neon"] = 177.09, ["Neon|Ride"] = 124.26, ["Neon|Fly|Ride"] = 278.83, ["Mega"] = 840, ["Mega|Ride"] = 1678.29, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 13.09, ["Fly"] = 30.21, ["Ride"] = 24.13, ["Fly|Ride"] = 37.54, ["Neon"] = 54.56, ["Neon|Ride"] = 96.51, ["Neon|Fly|Ride"] = 138.48, ["Mega"] = 2517.42, ["Mega|Fly|Ride"] = 620.39}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8888.24}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2715.57}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 23.46}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 304.58, ["Fly"] = 419.58, ["Ride"] = 314.7, ["Fly|Ride"] = 329.38, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 1790.52}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 14.43, ["Fly"] = 132.18, ["Ride"] = 52.5, ["Fly|Ride"] = 109.15, ["Neon"] = 104.99, ["Neon|Ride"] = 406.88, ["Mega"] = 542.55, ["Mega|Ride"] = 560.14, ["Mega|Fly|Ride"] = 555.19}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 10.39}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 6.18, ["Neon"] = 98.61, ["Neon|Ride"] = 249.38}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2040.94}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 141.75, ["Ride"] = 105, ["Fly|Ride"] = 274.83, ["Neon"] = 472.5, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 839.15, ["Mega|Fly|Ride"] = 2000.31}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 98.44, ["Fly"] = 140.58, ["Ride"] = 167.84, ["Fly|Ride"] = 419.58, ["Neon"] = 469.93, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 1787.38, ["Mega|Ride"] = 1575, ["Mega|Fly|Ride"] = 1573.4}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 176.85, ["Fly"] = 280.08, ["Ride"] = 156.19, ["Fly|Ride"] = 199.5, ["Neon"] = 805.89, ["Neon|Ride"] = 671.32, ["Neon|Fly|Ride"] = 839.15, ["Mega|Fly|Ride"] = 2937.38}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1076.25, ["Fly"] = 2517.42, ["Ride"] = 1147.53, ["Fly|Ride"] = 1097.97, ["Neon|Fly|Ride"] = 4593.75, ["Mega|Fly|Ride"] = 20978.39}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 16.7, ["Fly"] = 109.14, ["Ride"] = 46.17, ["Fly|Ride"] = 86.63, ["Neon"] = 115.5, ["Neon|Ride"] = 140.58, ["Neon|Fly|Ride"] = 437.07, ["Mega"] = 929.41, ["Mega|Fly|Ride"] = 807.69}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 582.75, ["Fly"] = 2100, ["Ride"] = 629.37, ["Fly|Ride"] = 560.14, ["Neon|Fly|Ride"] = 4027.79}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 51.19}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 15.65, ["Fly"] = 144.38, ["Ride"] = 39.38, ["Fly|Ride"] = 98.44, ["Neon"] = 42, ["Neon|Ride"] = 155.63, ["Neon|Fly|Ride"] = 489.86, ["Mega"] = 393.75, ["Mega|Ride"] = 418.69, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 5.58, ["Fly"] = 348.29, ["Ride"] = 28.88, ["Fly|Ride"] = 91.88, ["Neon"] = 35.68, ["Neon|Ride"] = 98.61, ["Neon|Fly|Ride"] = 202.18, ["Mega|Ride"] = 390.22, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 78.64}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 17.07, ["Ride"] = 31.37, ["Fly|Ride"] = 65.54, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 279.03, ["Mega|Ride"] = 839.15, ["Mega|Fly|Ride"] = 560.14}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 30.43, ["Fly"] = 39.38, ["Ride"] = 19.69, ["Fly|Ride"] = 52.46, ["Neon"] = 155.63, ["Neon|Fly"] = 241.55, ["Neon|Ride"] = 274.83, ["Neon|Fly|Ride"] = 274.32, ["Mega"] = 1397.18, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 5712, ["Fly"] = 11188.84, ["Ride"] = 6562.5, ["Fly|Ride"] = 5091.19, ["Neon|Fly|Ride"] = 9712.5, ["Mega|Fly|Ride"] = 27971.54}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 9.32, ["Fly"] = 79.73, ["Ride"] = 36.01, ["Fly|Ride"] = 116.19, ["Neon"] = 79.46, ["Neon|Fly"] = 119.59, ["Neon|Ride"] = 85.31, ["Neon|Fly|Ride"] = 276.94, ["Mega"] = 531.82, ["Mega|Ride"] = 384.57, ["Mega|Fly|Ride"] = 465.13}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 23.61}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 111.57, ["Fly"] = 371.33, ["Ride"] = 133.24, ["Fly|Ride"] = 280.08, ["Neon"] = 417.38, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 472.84, ["Mega|Ride"] = 1818.85, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 60.38, ["Fly"] = 183.75, ["Ride"] = 111.34, ["Fly|Ride"] = 236.02, ["Neon"] = 234.44, ["Neon|Ride"] = 380.63, ["Neon|Fly|Ride"] = 525, ["Mega|Ride"] = 1347.64, ["Mega|Fly|Ride"] = 1216.76}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 23.28, ["Fly"] = 70.86, ["Ride"] = 27.56, ["Fly|Ride"] = 77.64, ["Neon"] = 182.53, ["Neon|Ride"] = 182.53, ["Neon|Fly|Ride"] = 160.34, ["Mega|Fly|Ride"] = 485.62}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 5.02, ["Fly"] = 49.07, ["Ride"] = 23.07, ["Fly|Ride"] = 52.5, ["Neon"] = 19.62, ["Neon|Ride"] = 41.67, ["Neon|Fly|Ride"] = 154.92, ["Mega"] = 120.83, ["Mega|Fly"] = 151.05, ["Mega|Ride"] = 188.99, ["Mega|Fly|Ride"] = 267.15}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 10.48, ["Ride"] = 28.33, ["Fly|Ride"] = 77.91, ["Neon"] = 51.85, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 142.14, ["Mega"] = 699.65, ["Mega|Ride"] = 419.99, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 19.4, ["Fly"] = 26.21, ["Ride"] = 28.33, ["Fly|Ride"] = 45.94, ["Neon"] = 92.92, ["Neon|Fly"] = 209.81, ["Neon|Ride"] = 188.25, ["Neon|Fly|Ride"] = 105, ["Mega|Fly"] = 699.65, ["Mega|Fly|Ride"] = 585.83}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 196.67}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 19.69, ["Fly"] = 124.24, ["Ride"] = 98.44, ["Neon"] = 83.93, ["Neon|Ride"] = 392.32, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 489.86, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 896.44}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 266.44, ["Ride"] = 359.8, ["Fly|Ride"] = 262.49, ["Neon|Ride"] = 417.38}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 40.5, ["Ride"] = 91.7, ["Fly|Ride"] = 254.61, ["Neon"] = 242.82, ["Neon|Ride"] = 327.08, ["Neon|Fly|Ride"] = 525, ["Mega"] = 1111.69, ["Mega|Ride"] = 1317.44, ["Mega|Fly|Ride"] = 1174.69}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 656.25, ["Fly"] = 780.94, ["Ride"] = 590.63, ["Fly|Ride"] = 653.63, ["Neon|Ride"] = 2100, ["Neon|Fly|Ride"] = 2086.88, ["Mega|Fly|Ride"] = 8531.25}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 233.63, ["Ride"] = 260.15, ["Fly|Ride"] = 288.75, ["Neon"] = 1152.78, ["Neon|Fly"] = 4490.41, ["Neon|Ride"] = 1549.08, ["Neon|Fly|Ride"] = 1224.09, ["Mega"] = 8251.86, ["Mega|Ride"] = 4066.13, ["Mega|Fly|Ride"] = 3917.73}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 89.24}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 10.48, ["Fly"] = 23.09, ["Ride"] = 23.63, ["Fly|Ride"] = 48.57, ["Neon"] = 80.07, ["Neon|Ride"] = 77.82, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 405.57}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 288.74, ["Fly"] = 598.48, ["Ride"] = 328.13, ["Fly|Ride"] = 426.57, ["Neon"] = 1258.72, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 966, ["Mega|Fly|Ride"] = 3498.16}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 13.11}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 90.45, ["Fly"] = 178.12, ["Ride"] = 156.19, ["Fly|Ride"] = 229.69, ["Neon"] = 525, ["Neon|Fly"] = 1399.28, ["Neon|Ride"] = 486.94, ["Neon|Fly|Ride"] = 654.94, ["Mega"] = 2571.96, ["Mega|Fly|Ride"] = 1705.2}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 156.19, ["Ride"] = 118.13, ["Fly|Ride"] = 131.25, ["Neon|Ride"] = 997.5, ["Neon|Fly|Ride"] = 699.65}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 4.97, ["Ride"] = 39.38, ["Fly|Ride"] = 124.26, ["Neon"] = 27.27, ["Neon|Ride"] = 46.17, ["Neon|Fly|Ride"] = 167.84, ["Mega"] = 240.19, ["Mega|Ride"] = 196.17, ["Mega|Fly|Ride"] = 411.18}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 15.73, ["Fly"] = 49.88, ["Ride"] = 26.92, ["Fly|Ride"] = 76.13, ["Neon"] = 98.61, ["Neon|Ride"] = 95.46, ["Neon|Fly|Ride"] = 196.17, ["Mega|Ride"] = 734.26, ["Mega|Fly|Ride"] = 774.89}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 22.29, ["Fly"] = 140.58, ["Ride"] = 52.5, ["Fly|Ride"] = 144.38, ["Neon"] = 133.23, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 275.89, ["Mega"] = 328.13, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 552.79}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 3.78, ["Fly"] = 335.67, ["Ride"] = 48.23, ["Fly|Ride"] = 107.57, ["Neon"] = 19.59, ["Neon|Fly"] = 69.25, ["Neon|Ride"] = 56.65, ["Neon|Fly|Ride"] = 149.63, ["Mega"] = 111.57, ["Mega|Fly"] = 189, ["Mega|Ride"] = 152.81, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 301.11, ["Fly"] = 350.36, ["Ride"] = 353.07, ["Fly|Ride"] = 411.5, ["Neon"] = 1678.29, ["Neon|Ride"] = 1246.88, ["Neon|Fly|Ride"] = 1378.13}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 112.13, ["Fly"] = 1050, ["Ride"] = 161.61, ["Fly|Ride"] = 235.41, ["Neon"] = 551.25, ["Neon|Ride"] = 548.87, ["Neon|Fly|Ride"] = 589.32, ["Mega"] = 4339.15, ["Mega|Ride"] = 2517.42, ["Mega|Fly|Ride"] = 2525.81}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 72.19, ["Fly"] = 155.26, ["Ride"] = 85.16, ["Fly|Ride"] = 131.24, ["Neon|Ride"] = 334.69, ["Neon|Fly|Ride"] = 420, ["Mega"] = 1611.36, ["Mega|Fly|Ride"] = 1515.94}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 15.73, ["Fly"] = 52.5, ["Ride"] = 55.78, ["Fly|Ride"] = 280.08, ["Neon"] = 209.81, ["Neon|Ride"] = 589.91, ["Neon|Fly|Ride"] = 488.82, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 18.06, ["Ride"] = 39.87, ["Fly|Ride"] = 102.38, ["Neon"] = 111.57, ["Neon|Ride"] = 116.13, ["Neon|Fly|Ride"] = 157.33, ["Mega"] = 482.51, ["Mega|Fly"] = 525, ["Mega|Ride"] = 417.5, ["Mega|Fly|Ride"] = 620.39}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 2.1, ["Fly"] = 41.97, ["Ride"] = 23.24, ["Fly|Ride"] = 77.81, ["Neon"] = 15.68, ["Neon|Ride"] = 35.68, ["Neon|Fly|Ride"] = 81.38, ["Mega"] = 115.22, ["Mega|Ride"] = 163.48, ["Mega|Fly|Ride"] = 187.72}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 892.5, ["Fly"] = 1118.17, ["Ride"] = 945, ["Fly|Ride"] = 983.07, ["Neon"] = 3498.16, ["Neon|Fly"] = 2832.1, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2415, ["Mega"] = 11888.46, ["Mega|Fly|Ride"] = 7245}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 262.5, ["Fly"] = 496.96, ["Ride"] = 288.75, ["Fly|Ride"] = 315, ["Neon"] = 1048.93, ["Neon|Ride"] = 943.69, ["Neon|Fly|Ride"] = 1005.38, ["Mega"] = 10489.2, ["Mega|Ride"] = 5886.6, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 136.5, ["Ride"] = 140.41, ["Fly|Ride"] = 266.44, ["Neon"] = 381.82, ["Neon|Ride"] = 383.93, ["Neon|Fly|Ride"] = 410.13, ["Mega"] = 1640.63, ["Mega|Ride"] = 1678.29, ["Mega|Fly|Ride"] = 1441.23}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 209.81, ["Ride"] = 183.75, ["Fly|Ride"] = 250.71, ["Neon"] = 699.65, ["Neon|Ride"] = 979.71, ["Neon|Fly|Ride"] = 699.65, ["Mega"] = 10489.2, ["Mega|Fly|Ride"] = 2887.49}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 17, ["Fly"] = 48.26, ["Ride"] = 31.49, ["Fly|Ride"] = 68.25, ["Neon"] = 140.57, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 157.5, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 773.16}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 301.88, ["Ride"] = 369.05, ["Fly|Ride"] = 464.5, ["Neon"] = 1332.15, ["Neon|Ride"] = 1354.17, ["Neon|Fly|Ride"] = 1930.03, ["Mega"] = 5250, ["Mega|Fly|Ride"] = 3937.5}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 117.01, ["Fly"] = 126, ["Ride"] = 140.58, ["Fly|Ride"] = 196.87, ["Neon|Ride"] = 140.58, ["Neon|Fly|Ride"] = 417.5, ["Mega|Fly|Ride"] = 2014.49}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1246.88, ["Ride"] = 1399.28, ["Fly|Ride"] = 1259, ["Neon|Ride"] = 4056.19, ["Neon|Fly|Ride"] = 3949.96, ["Mega"] = 50348.12, ["Mega|Fly|Ride"] = 23233.83}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 14.42, ["Fly"] = 53.82, ["Ride"] = 35.36, ["Fly|Ride"] = 99.75, ["Neon"] = 39.38, ["Neon|Fly"] = 167.23, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 305.82, ["Mega|Ride"] = 299.71, ["Mega|Fly|Ride"] = 379.05}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 61.53, ["Ride"] = 109.15, ["Fly|Ride"] = 315, ["Neon"] = 263.29, ["Neon|Ride"] = 316.32, ["Neon|Fly|Ride"] = 413.44, ["Mega"] = 1023.51, ["Mega|Fly|Ride"] = 979.71}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 77.31, ["Fly"] = 78.75, ["Ride"] = 73.5, ["Fly|Ride"] = 80.07, ["Neon|Ride"] = 410.82, ["Neon|Fly|Ride"] = 391.13, ["Mega|Fly|Ride"] = 1469.99}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 2516.37, ["Ride"] = 958.13, ["Fly|Ride"] = 951.39, ["Neon|Fly|Ride"] = 4199.99, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 417.5, ["Ride"] = 456.3, ["Fly|Ride"] = 405.95, ["Neon|Ride"] = 1678.29, ["Neon|Fly|Ride"] = 1458.01, ["Mega|Fly|Ride"] = 9139.49}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 115.5, ["Fly"] = 209.79, ["Ride"] = 140.58, ["Fly|Ride"] = 196.88, ["Neon"] = 879.38, ["Neon|Ride"] = 454.65, ["Neon|Fly|Ride"] = 525, ["Mega"] = 4195.69, ["Mega|Ride"] = 1443.75, ["Mega|Fly|Ride"] = 1635.27}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 7.8, ["Ride"] = 23.63, ["Fly|Ride"] = 87.94, ["Neon"] = 74.34, ["Neon|Ride"] = 61.9, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 638.98, ["Mega|Ride"] = 508.59, ["Mega|Fly|Ride"] = 839.15}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 30.96, ["Fly"] = 70.3, ["Ride"] = 28.33, ["Fly|Ride"] = 81.3, ["Neon"] = 248.51, ["Neon|Fly"] = 293.71, ["Neon|Ride"] = 238.09, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 1814.64, ["Mega|Fly|Ride"] = 1036.34}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 813.75, ["Fly"] = 952.18, ["Ride"] = 918.75, ["Fly|Ride"] = 816.53, ["Neon|Fly|Ride"] = 2965.32, ["Mega|Fly|Ride"] = 12586}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 787.5}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 4173.75, ["Ride"] = 3368.96, ["Fly|Ride"] = 3281.25, ["Neon|Ride"] = 30063.09, ["Neon|Fly|Ride"] = 14437.5, ["Mega|Fly|Ride"] = 89508.47}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 140.58, ["Fly"] = 408.19, ["Ride"] = 167.84, ["Fly|Ride"] = 392.32, ["Neon"] = 608.39, ["Neon|Ride"] = 1239.03, ["Neon|Fly|Ride"] = 851.82, ["Mega"] = 5873.97, ["Mega|Fly|Ride"] = 5454.4}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 77.44, ["Ride"] = 109.15, ["Fly|Ride"] = 336, ["Neon|Ride"] = 1119.22, ["Neon|Fly|Ride"] = 525, ["Mega|Ride"] = 1399.28, ["Mega|Fly|Ride"] = 1678.29}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 12.48, ["Fly"] = 131.25, ["Ride"] = 28.29, ["Fly|Ride"] = 49.95, ["Neon"] = 74.49, ["Neon|Ride"] = 83.93, ["Neon|Fly|Ride"] = 195.57, ["Mega"] = 418.52, ["Mega|Ride"] = 839.15, ["Mega|Fly|Ride"] = 476.22}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 19.88, ["Fly"] = 37.41, ["Ride"] = 22.28, ["Fly|Ride"] = 39.38, ["Neon|Fly|Ride"] = 653.63, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 698.6}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 17.48, ["Fly"] = 70.9, ["Ride"] = 36.83, ["Fly|Ride"] = 90.57, ["Neon"] = 140.58, ["Neon|Ride"] = 97.13, ["Neon|Fly|Ride"] = 187.68, ["Mega|Ride"] = 859.69, ["Mega|Fly|Ride"] = 671.32}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 5.5, ["Ride"] = 28.33, ["Fly|Ride"] = 252, ["Neon"] = 49.31, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 166.68, ["Mega"] = 290.45, ["Mega|Fly|Ride"] = 357}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 20.98, ["Ride"] = 49.25, ["Fly|Ride"] = 111.57, ["Neon"] = 143.07, ["Neon|Ride"] = 293.69, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 671.32, ["Mega|Ride"] = 560.14, ["Mega|Fly|Ride"] = 728.44}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 262.5, ["Fly"] = 209.81, ["Ride"] = 255.45, ["Fly|Ride"] = 292.69, ["Neon"] = 721.83, ["Neon|Ride"] = 681.19, ["Neon|Fly|Ride"] = 715.32, ["Mega"] = 6562.5, ["Mega|Ride"] = 4195.69, ["Mega|Fly|Ride"] = 2756.25}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.1, ["Fly"] = 16.79, ["Ride"] = 13.13, ["Fly|Ride"] = 28.33, ["Neon"] = 20.86, ["Neon|Fly"] = 92.92, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 69.57, ["Mega"] = 197.21, ["Mega|Ride"] = 738.46, ["Mega|Fly|Ride"] = 249.54}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 29.98, ["Fly"] = 115.5, ["Ride"] = 48.49, ["Fly|Ride"] = 117.27, ["Neon"] = 115.5, ["Neon|Fly"] = 209.81, ["Neon|Ride"] = 197.43, ["Neon|Fly|Ride"] = 229.46, ["Mega"] = 511.88, ["Mega|Ride"] = 552.36, ["Mega|Fly|Ride"] = 494.84}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 761.25, ["Fly"] = 787.5, ["Ride"] = 757.32, ["Fly|Ride"] = 707.36, ["Neon|Ride"] = 1816.5, ["Neon|Fly|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 4196.07}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 24.81, ["Fly"] = 69.68, ["Ride"] = 41.97, ["Fly|Ride"] = 78.23, ["Neon"] = 241.55, ["Neon|Fly"] = 464.5, ["Neon|Ride"] = 181.13, ["Neon|Fly|Ride"] = 187.69, ["Mega"] = 1575, ["Mega|Ride"] = 979.71, ["Mega|Fly|Ride"] = 834.04}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 292.57, ["Fly"] = 310.03, ["Ride"] = 245.44, ["Fly|Ride"] = 229.69, ["Neon"] = 1399.28, ["Neon|Fly|Ride"] = 951.57, ["Mega|Fly|Ride"] = 4166.32}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 114.19, ["Fly"] = 139.13, ["Ride"] = 122.07, ["Fly|Ride"] = 166.69, ["Neon"] = 629.37, ["Neon|Fly"] = 637.76, ["Neon|Ride"] = 523.43, ["Neon|Fly|Ride"] = 527.44, ["Mega"] = 2936.99, ["Mega|Fly|Ride"] = 1678.29}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 656.25, ["Ride"] = 570.93, ["Fly|Ride"] = 549.94, ["Neon"] = 2482.81, ["Neon|Fly|Ride"] = 2411.07, ["Mega|Fly|Ride"] = 7762.01}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 15.74, ["Ride"] = 52.5, ["Fly|Ride"] = 94.42, ["Neon"] = 91.62, ["Neon|Fly"] = 182.53, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 354.38, ["Mega|Ride"] = 405.57, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 3719.63, ["Fly"] = 2821.88, ["Ride"] = 3528, ["Fly|Ride"] = 2625, ["Neon"] = 13950.64, ["Neon|Fly|Ride"] = 6642.04, ["Mega|Fly|Ride"] = 24754.51}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 77.26, ["Fly"] = 98.61, ["Ride"] = 78.62, ["Fly|Ride"] = 139.35, ["Neon"] = 394.78, ["Neon|Fly"] = 418.04, ["Neon|Ride"] = 403.14, ["Neon|Fly|Ride"] = 400.32, ["Mega|Fly|Ride"] = 1761.15}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.63, ["Fly"] = 27.28, ["Ride"] = 19.51, ["Fly|Ride"] = 70.3, ["Neon"] = 15.75, ["Neon|Fly"] = 44.63, ["Neon|Ride"] = 54.58, ["Neon|Fly|Ride"] = 110.39, ["Mega"] = 106.55, ["Mega|Fly"] = 452.82, ["Mega|Ride"] = 140.58, ["Mega|Fly|Ride"] = 233.92}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Fly|Ride"] = 65.63, ["Neon"] = 17.07, ["Neon|Ride"] = 41.97, ["Neon|Fly|Ride"] = 292.78, ["Mega"] = 147, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 55.13, ["Fly"] = 65.63, ["Ride"] = 54.39, ["Fly|Ride"] = 70.3, ["Neon|Ride"] = 699.65, ["Neon|Fly|Ride"] = 240.19, ["Mega|Fly|Ride"] = 1141.88}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 787.5, ["Ride"] = 917.44, ["Fly|Ride"] = 918.75, ["Neon|Ride"] = 5244.61, ["Neon|Fly|Ride"] = 5840.14, ["Mega"] = 16264.5, ["Mega|Fly|Ride"] = 25174.07}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 5070.5, ["Ride"] = 4876.58, ["Fly|Ride"] = 4856.25}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 15.73, ["Fly"] = 41.97, ["Ride"] = 24.13, ["Fly|Ride"] = 45.82, ["Neon|Ride"] = 140.58, ["Neon|Fly|Ride"] = 129.5, ["Mega"] = 2517.42, ["Mega|Fly|Ride"] = 616.91}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 13.1, ["Fly"] = 41.97, ["Ride"] = 39.87, ["Fly|Ride"] = 79.32, ["Neon"] = 109.11, ["Neon|Ride"] = 62.34, ["Neon|Fly|Ride"] = 152.94, ["Mega"] = 929.41, ["Mega|Ride"] = 502.45, ["Mega|Fly|Ride"] = 419.27}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 53.47, ["Fly"] = 157.49, ["Ride"] = 52.5, ["Fly|Ride"] = 84, ["Neon"] = 393.75, ["Neon|Ride"] = 245.44, ["Neon|Fly|Ride"] = 329.38, ["Mega|Fly|Ride"] = 1114.18}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 217.88, ["Ride"] = 254.63, ["Fly|Ride"] = 320.25, ["Neon|Ride"] = 1048.69, ["Neon|Fly|Ride"] = 1157.62, ["Mega"] = 10489.2, ["Mega|Fly|Ride"] = 3655.32}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 4.86, ["Fly|Ride"] = 105, ["Neon"] = 19.65, ["Neon|Fly"] = 70.95, ["Neon|Ride"] = 28.33, ["Neon|Fly|Ride"] = 140.58, ["Mega"] = 105, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 293.71}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 189, ["Fly"] = 290.29, ["Ride"] = 231, ["Fly|Ride"] = 261.19, ["Neon"] = 810.54, ["Neon|Ride"] = 628.69, ["Neon|Fly|Ride"] = 733.69, ["Mega|Fly|Ride"] = 2624.99}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 3.28, ["Fly"] = 73.5, ["Ride"] = 16.59, ["Fly|Ride"] = 43.55, ["Neon"] = 28.17, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 464.71, ["Mega|Ride"] = 419.58, ["Mega|Fly|Ride"] = 472.03}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 210, ["Fly"] = 270.63, ["Ride"] = 238.11, ["Fly|Ride"] = 275.63, ["Neon|Fly|Ride"] = 892.5, ["Mega"] = 10489.2, ["Mega|Fly|Ride"] = 3636.62}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 11.64, ["Fly"] = 419.58, ["Ride"] = 28.25, ["Fly|Ride"] = 83.93, ["Neon"] = 44.15, ["Neon|Fly"] = 294.97, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 392.32, ["Mega"] = 448.95, ["Mega|Ride"] = 587.41, ["Mega|Fly|Ride"] = 503.5}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 3.92, ["Fly|Ride"] = 131.25, ["Neon"] = 13.99, ["Neon|Fly"] = 170.63, ["Neon|Ride"] = 60.85, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 76.13, ["Mega|Fly"] = 419.58, ["Mega|Ride"] = 101.05, ["Mega|Fly|Ride"] = 213.94}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 4.94, ["Mega"] = 23.09, ["Mega|Fly|Ride"] = 165.74}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 2.1, ["Ride"] = 35.68, ["Fly|Ride"] = 218.19, ["Neon"] = 10.48, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 141.75, ["Mega|Fly"] = 154900.66, ["Mega|Ride"] = 119.67, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 66.91, ["Fly"] = 140.58, ["Ride"] = 102.8, ["Fly|Ride"] = 131.25, ["Neon"] = 262.5, ["Neon|Ride"] = 320.24, ["Neon|Fly|Ride"] = 367.5, ["Mega|Ride"] = 1311.19, ["Mega|Fly|Ride"] = 1191.59}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 45.85, ["Ride"] = 18.38, ["Fly|Ride"] = 51.11, ["Neon"] = 12.5, ["Neon|Ride"] = 40.68, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 129.94, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 18.79, ["Ride"] = 63, ["Neon"] = 137.16, ["Neon|Ride"] = 212.63, ["Mega"] = 380.63, ["Mega|Ride"] = 558.05}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 77.64, ["Neon|Fly|Ride"] = 280.08, ["Mega"] = 16.94, ["Mega|Ride"] = 87.07, ["Mega|Fly|Ride"] = 170.47}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 18, ["Fly|Ride"] = 35.68, ["Neon"] = 2.1, ["Neon|Ride"] = 16.79, ["Neon|Fly|Ride"] = 77.17, ["Mega"] = 14.44, ["Mega|Ride"] = 26.25, ["Mega|Fly|Ride"] = 52.5}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Ride"] = 134.09, ["Fly|Ride"] = 45.52, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 17.43, ["Neon|Fly|Ride"] = 46.49, ["Mega"] = 17.07, ["Mega|Ride"] = 44.14, ["Mega|Fly|Ride"] = 98.44}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Ride"] = 27.28, ["Neon"] = 2.63, ["Mega"] = 19.69, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 31.49, ["Ride"] = 14.43, ["Fly|Ride"] = 107.63, ["Neon"] = 6.32, ["Neon|Ride"] = 92.32, ["Neon|Fly|Ride"] = 73.43, ["Mega"] = 220.76, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 161.44}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Fly|Ride"] = 140.58, ["Mega"] = 7.87, ["Mega|Ride"] = 86.63, ["Mega|Fly|Ride"] = 139.42}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 2.1, ["Fly"] = 46.56, ["Ride"] = 19.9, ["Fly|Ride"] = 36.02, ["Neon"] = 6.07, ["Neon|Fly"] = 37.96, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 80.57, ["Mega|Fly"] = 109.11, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Fly|Ride"] = 39.38, ["Neon"] = 2.1, ["Neon|Ride"] = 26.25, ["Mega"] = 15.73, ["Mega|Ride"] = 47.25, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.1, ["Ride"] = 141.63, ["Fly|Ride"] = 525, ["Neon"] = 17.05, ["Mega"] = 140.44, ["Mega|Ride"] = 157.5}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.6, ["Ride"] = 79.73, ["Neon"] = 21}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Neon"] = 6.51, ["Neon|Ride"] = 103.95, ["Mega"] = 37.77, ["Mega|Ride"] = 173.12, ["Mega|Fly|Ride"] = 280.08}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 30.21, ["Ride"] = 16.79, ["Fly|Ride"] = 47.22, ["Neon"] = 2.1, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 15.73, ["Mega|Ride"] = 22.32, ["Mega|Fly|Ride"] = 62.99}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.1, ["Fly"] = 72.19, ["Ride"] = 42, ["Fly|Ride"] = 109.11, ["Neon"] = 27.57, ["Neon|Ride"] = 39.38, ["Mega|Ride"] = 350.36}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 42, ["Fly|Ride"] = 78.73, ["Neon"] = 7.86, ["Neon|Ride"] = 41.97, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 36.75, ["Mega|Ride"] = 62.34, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 2.1, ["Ride"] = 70.3, ["Neon"] = 9.16, ["Neon|Fly|Ride"] = 140.58, ["Mega"] = 83.93, ["Mega|Ride"] = 233.63}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 4.13, ["Fly"] = 656.25, ["Ride"] = 32.81, ["Fly|Ride"] = 190.92, ["Neon"] = 10.5, ["Neon|Fly"] = 91.75, ["Neon|Ride"] = 41.97, ["Mega"] = 209.88, ["Mega|Ride"] = 85.3, ["Mega|Fly|Ride"] = 280.08}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 38.07, ["Ride"] = 22.32, ["Fly|Ride"] = 27.57, ["Neon"] = 2.1, ["Neon|Fly"] = 14.43, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 32.81, ["Mega"] = 12.57, ["Mega|Ride"] = 19.63, ["Mega|Fly|Ride"] = 45.94}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 19.65, ["Fly|Ride"] = 138.48, ["Neon"] = 15.74, ["Neon|Ride"] = 110.8, ["Mega"] = 122.19, ["Mega|Fly|Ride"] = 204.56}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 3.89, ["Neon"] = 97.22, ["Neon|Ride"] = 388.04, ["Neon|Fly|Ride"] = 139.42, ["Mega"] = 238.11, ["Mega|Ride"] = 419.58, ["Mega|Fly|Ride"] = 419.58}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 23.09, ["Ride"] = 15.74, ["Fly|Ride"] = 27.57, ["Neon"] = 2.1, ["Neon|Fly"] = 21.32, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 28.88, ["Mega"] = 15.89, ["Mega|Fly"] = 156.19, ["Mega|Fly|Ride"] = 93.19}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.1, ["Ride"] = 31.5, ["Neon"] = 7.88, ["Neon|Fly"] = 77.64, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 105, ["Mega"] = 81.38, ["Mega|Ride"] = 99.75, ["Mega|Fly|Ride"] = 310.21}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 61.69, ["Neon"] = 5.97, ["Neon|Fly"] = 155.26, ["Neon|Fly|Ride"] = 310.21, ["Mega"] = 38.06, ["Mega|Ride"] = 65.04, ["Mega|Fly|Ride"] = 280.08}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 119.59, ["Neon"] = 2.1, ["Neon|Fly"] = 40.69, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 84, ["Mega"] = 15.72, ["Mega|Ride"] = 25.57, ["Mega|Fly|Ride"] = 186.73}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 28.33, ["Ride"] = 20.9, ["Fly|Ride"] = 79.73, ["Neon"] = 9.19, ["Neon|Fly"] = 41.97, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 140.58, ["Mega"] = 218.43, ["Mega|Ride"] = 105}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Neon"] = 13.1, ["Neon|Ride"] = 59.8, ["Mega"] = 86.63, ["Mega|Ride"] = 85.32}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 28.33, ["Ride"] = 21, ["Fly|Ride"] = 35.67, ["Neon"] = 5.7, ["Neon|Fly"] = 70.3, ["Neon|Ride"] = 39.5, ["Neon|Fly|Ride"] = 72.19, ["Mega|Ride"] = 139.13, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 17.07, ["Ride"] = 80.99, ["Neon"] = 72.19, ["Mega"] = 296.63, ["Mega|Fly|Ride"] = 844.06}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Ride"] = 21, ["Fly|Ride"] = 5341.58, ["Neon"] = 10.5, ["Neon|Fly"] = 58.78, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 142.91, ["Mega"] = 315, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 4.22, ["Fly"] = 105, ["Ride"] = 31.49, ["Fly|Ride"] = 209.81, ["Neon"] = 26.25, ["Neon|Fly"] = 56.65, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 103.37, ["Mega"] = 128.62, ["Mega|Ride"] = 140.58, ["Mega|Fly|Ride"] = 207.64}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 79.47, ["Fly|Ride"] = 104.52, ["Neon"] = 140.33}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 11.16, ["Mega"] = 590.63, ["Mega|Ride"] = 979.71, ["Mega|Fly|Ride"] = 794.07}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 2.1, ["Ride"] = 262.5, ["Fly|Ride"] = 70.3, ["Neon"] = 42, ["Neon|Ride"] = 140.58, ["Neon|Fly|Ride"] = 83.93, ["Mega"] = 362.36, ["Mega|Ride"] = 559.13, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 3.78, ["Ride"] = 69.68, ["Neon"] = 53.5, ["Neon|Ride"] = 291.38, ["Mega"] = 309.44, ["Mega|Ride"] = 271.69, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.76, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 17.03, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 148.32}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 41.99}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 5.97, ["Fly"] = 17.43, ["Ride"] = 24.94, ["Fly|Ride"] = 58.08, ["Neon"] = 28.32, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 104.91, ["Mega"] = 280.08, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 367.14}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 18.38, ["Fly|Ride"] = 65.63, ["Neon"] = 5.25, ["Neon|Ride"] = 37.78, ["Neon|Fly|Ride"] = 232.37, ["Mega"] = 19.69, ["Mega|Ride"] = 68.25, ["Mega|Fly|Ride"] = 196.17}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 164.07, ["Fly|Ride"] = 387.85, ["Neon"] = 5.13, ["Neon|Ride"] = 45.12, ["Mega"] = 39.48, ["Mega|Ride"] = 78.69, ["Mega|Fly|Ride"] = 310.21}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 19.74, ["Neon"] = 14.68, ["Neon|Ride"] = 57.75, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 179.39, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 310.21}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 2.1, ["Ride"] = 45.94, ["Neon"] = 45.94, ["Neon|Fly|Ride"] = 232.37, ["Mega"] = 326.17, ["Mega|Fly|Ride"] = 293.71}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 51.08, ["Mega"] = 15.73, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 47.25, ["Mega|Fly|Ride"] = 252.06}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Ride"] = 19.79, ["Fly|Ride"] = 279712.11, ["Neon"] = 10.49, ["Neon|Fly"] = 68.83, ["Neon|Ride"] = 30.03, ["Neon|Fly|Ride"] = 66.09, ["Mega"] = 23.55, ["Mega|Fly"] = 100.71, ["Mega|Ride"] = 62.95, ["Mega|Fly|Ride"] = 98.44}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 28.25, ["Ride"] = 17.07, ["Fly|Ride"] = 104.91, ["Neon"] = 5.25, ["Neon|Fly"] = 70.3, ["Neon|Ride"] = 28.33, ["Neon|Fly|Ride"] = 56.44, ["Mega"] = 111.55, ["Mega|Fly|Ride"] = 110.5}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Ride"] = 280.08, ["Neon"] = 3.92, ["Neon|Ride"] = 39.51, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 26.66, ["Mega|Ride"] = 47.25, ["Mega|Fly|Ride"] = 111.57}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 3.68, ["Neon|Ride"] = 41.97, ["Neon|Fly|Ride"] = 120.62, ["Mega"] = 15.75, ["Mega|Fly"] = 105, ["Mega|Ride"] = 83.78, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 26.36, ["Ride"] = 22.32, ["Neon"] = 3.94, ["Neon|Fly"] = 45.93, ["Neon|Ride"] = 27.28, ["Neon|Fly|Ride"] = 86.63, ["Mega"] = 19.69, ["Mega|Ride"] = 45.85, ["Mega|Fly|Ride"] = 129.94}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Mega"] = 14.44, ["Mega|Ride"] = 205.33}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 6.35, ["Neon|Ride"] = 77.82, ["Neon|Fly|Ride"] = 420, ["Mega"] = 27.28}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 17416.3, ["Ride"] = 17.43, ["Fly|Ride"] = 52.5, ["Neon"] = 5.25, ["Neon|Ride"] = 20.98, ["Neon|Fly|Ride"] = 77.44, ["Mega"] = 35.44, ["Mega|Fly"] = 63, ["Mega|Ride"] = 45.94, ["Mega|Fly|Ride"] = 82.67}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 12.24, ["Ride"] = 59.07, ["Neon"] = 134.27, ["Mega"] = 412.79, ["Mega|Ride"] = 419.58, ["Mega|Fly|Ride"] = 516.08}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 3.7, ["Ride"] = 68.25, ["Neon"] = 94.5, ["Neon|Fly|Ride"] = 110.25, ["Mega"] = 419.58, ["Mega|Ride"] = 344.54}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 3.93, ["Ride"] = 42, ["Fly|Ride"] = 419.58, ["Neon"] = 15.74, ["Neon|Ride"] = 280.08, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 166.69, ["Mega|Fly|Ride"] = 560.14}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 15.46, ["Fly|Ride"] = 28.88, ["Neon"] = 2.1, ["Neon|Fly"] = 23.09, ["Neon|Ride"] = 18.89, ["Neon|Fly|Ride"] = 35.44, ["Mega"] = 15.67, ["Mega|Fly"] = 23.63, ["Mega|Ride"] = 19.69, ["Mega|Fly|Ride"] = 39.38}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 3.42, ["Ride"] = 55.13, ["Fly|Ride"] = 64.32, ["Neon"] = 14.96, ["Neon|Fly"] = 140.58, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 65.04, ["Mega|Ride"] = 155.69, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Ride"] = 31.5, ["Neon"] = 2.1, ["Neon|Fly"] = 28.33, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 79.04, ["Mega"] = 10.47, ["Mega|Fly"] = 46.49, ["Mega|Ride"] = 36.46, ["Mega|Fly|Ride"] = 326.17}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 3.73, ["Neon|Fly"] = 60.9, ["Mega"] = 14.37, ["Mega|Fly|Ride"] = 272.73}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 56.65, ["Neon"] = 10.5, ["Neon|Fly"] = 77.79, ["Neon|Ride"] = 43.32, ["Mega"] = 155.69, ["Mega|Ride"] = 125.89, ["Mega|Fly|Ride"] = 220.29}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 257.25, ["Ride"] = 265.71, ["Fly|Ride"] = 393.75, ["Neon"] = 1537.74, ["Neon|Ride"] = 1050, ["Neon|Fly|Ride"] = 1538.78, ["Mega"] = 8391.36, ["Mega|Fly|Ride"] = 4720.15}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Fly|Ride"] = 52.5, ["Neon"] = 8.38, ["Neon|Ride"] = 68.25, ["Mega"] = 73.44, ["Mega|Ride"] = 174.13, ["Mega|Fly|Ride"] = 419.58}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 10.49, ["Fly"] = 103.68, ["Ride"] = 24.1, ["Fly|Ride"] = 140.2, ["Neon"] = 53.82, ["Neon|Ride"] = 166.49, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 577.5, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 1048.93}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 21.19, ["Ride"] = 14.44, ["Fly|Ride"] = 46.17, ["Neon"] = 3.93, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 61.69, ["Mega"] = 49.88, ["Mega|Ride"] = 62.75, ["Mega|Fly|Ride"] = 123.79}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 36.73, ["Fly|Ride"] = 121.69, ["Neon"] = 5.25, ["Neon|Fly"] = 36.02, ["Neon|Ride"] = 41.97, ["Mega"] = 102.8, ["Mega|Ride"] = 91.88}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 4.5, ["Fly"] = 32.82, ["Ride"] = 19.62, ["Fly|Ride"] = 48.25, ["Neon"] = 28.59, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 160.13, ["Mega|Ride"] = 155.25, ["Mega|Fly|Ride"] = 308.44}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 4.7, ["Ride"] = 37.01, ["Fly|Ride"] = 246.75, ["Neon"] = 62.83, ["Neon|Ride"] = 104.91, ["Neon|Fly|Ride"] = 623.06, ["Mega"] = 233.92, ["Mega|Fly|Ride"] = 419.58}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.1, ["Fly"] = 16.99, ["Ride"] = 17.52, ["Fly|Ride"] = 31.48, ["Neon"] = 66.09, ["Neon|Fly"] = 56.65, ["Neon|Ride"] = 30.43, ["Neon|Fly|Ride"] = 70.3, ["Mega|Ride"] = 419.58, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 68.25, ["Fly"] = 141.75, ["Ride"] = 101.07, ["Fly|Ride"] = 163.48, ["Neon"] = 435.31, ["Neon|Fly"] = 394.42, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 441.39, ["Mega|Fly|Ride"] = 1455.49}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 241, ["Fly"] = 314.7, ["Ride"] = 209.99, ["Fly|Ride"] = 250.69, ["Neon|Ride"] = 1119.22, ["Neon|Fly|Ride"] = 944.05, ["Mega"] = 10489.2, ["Mega|Fly|Ride"] = 5242.52}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 77.64, ["Fly"] = 115.24, ["Ride"] = 72.19, ["Fly|Ride"] = 104.09, ["Neon"] = 301.88, ["Neon|Ride"] = 273, ["Neon|Fly|Ride"] = 335.04, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 5.25, ["Ride"] = 28.33, ["Fly|Ride"] = 46.47, ["Neon"] = 39.5, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 171.95, ["Mega"] = 245.46, ["Mega|Ride"] = 239.33, ["Mega|Fly|Ride"] = 392.44}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 12.48, ["Ride"] = 32.52, ["Fly|Ride"] = 62.99, ["Neon"] = 107.1, ["Neon|Ride"] = 291.38, ["Neon|Fly|Ride"] = 280.08, ["Mega"] = 482.14, ["Mega|Ride"] = 377.63, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 31.49, ["Ride"] = 22.32, ["Fly|Ride"] = 66.21, ["Neon"] = 6.04, ["Neon|Fly"] = 129.94, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 40.68, ["Mega|Fly"] = 116.2, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 209.81}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 7.6, ["Fly"] = 65.63, ["Ride"] = 24.94, ["Fly|Ride"] = 103.69, ["Neon"] = 18.89, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 140.58, ["Mega"] = 464.71, ["Mega|Ride"] = 161.55, ["Mega|Fly|Ride"] = 232.37}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 16.37, ["Fly|Ride"] = 45.1, ["Neon"] = 11.63, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 40.72, ["Neon|Fly|Ride"] = 125.89, ["Mega"] = 129.94, ["Mega|Ride"] = 219.45, ["Mega|Fly|Ride"] = 175.88}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 3.66, ["Ride"] = 30.19, ["Fly|Ride"] = 328.13, ["Neon"] = 21.19, ["Neon|Ride"] = 56.65, ["Mega"] = 179.21, ["Mega|Fly|Ride"] = 699.65}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 28.33, ["Neon"] = 2.63, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 14.41, ["Mega|Ride"] = 49.31, ["Mega|Fly|Ride"] = 155.69}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 45.93, ["Ride"] = 31.49, ["Fly|Ride"] = 56.44, ["Neon"] = 17.07, ["Neon|Fly"] = 70.3, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 87.14, ["Mega"] = 78.75, ["Mega|Fly|Ride"] = 192.29}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.1, ["Fly"] = 36.72, ["Ride"] = 23.62, ["Fly|Ride"] = 59.07, ["Neon"] = 62.31, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 560.14, ["Mega"] = 155.26, ["Mega|Fly|Ride"] = 271.69}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 105.97, ["Fly"] = 165.74, ["Ride"] = 153.57, ["Fly|Ride"] = 196.88, ["Neon"] = 560.14, ["Neon|Ride"] = 543.36, ["Neon|Fly|Ride"] = 551.24, ["Mega"] = 1963.6, ["Mega|Fly|Ride"] = 1785}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 12.78, ["Ride"] = 240.91, ["Fly|Ride"] = 206.07, ["Neon"] = 55.13, ["Neon|Ride"] = 124.26, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 414.75, ["Mega|Fly|Ride"] = 389.17}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 69.68, ["Ride"] = 26.51, ["Fly|Ride"] = 112.88, ["Neon"] = 35.68, ["Neon|Ride"] = 57.05, ["Neon|Fly|Ride"] = 125.89, ["Mega"] = 236.25, ["Mega|Ride"] = 280.08, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 19.5, ["Ride"] = 62.71, ["Fly|Ride"] = 155.63, ["Neon"] = 77.84, ["Neon|Ride"] = 112.25, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 524.48, ["Mega|Ride"] = 551.25, ["Mega|Fly|Ride"] = 489.86}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 4.97}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 69.57, ["Neon|Fly|Ride"] = 629.37, ["Mega"] = 288.75, ["Mega|Ride"] = 405.95, ["Mega|Fly|Ride"] = 1258.72}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 26.84, ["Fly"] = 56.25, ["Ride"] = 42, ["Fly|Ride"] = 65.63, ["Neon"] = 155.26, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 119.58, ["Neon|Fly|Ride"] = 166.79, ["Mega"] = 2097.85, ["Mega|Fly|Ride"] = 687.77}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 2.1, ["Neon|Ride"] = 39.87, ["Mega"] = 24.94, ["Mega|Ride"] = 62.53, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 2.1, ["Fly"] = 28.33, ["Ride"] = 28.33, ["Fly|Ride"] = 73.21, ["Neon"] = 47.92, ["Neon|Ride"] = 232.26, ["Mega"] = 278.92, ["Mega|Fly"] = 388.04, ["Mega|Ride"] = 161.47, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 3.94, ["Ride"] = 18.38, ["Fly|Ride"] = 45, ["Neon"] = 31.37, ["Neon|Ride"] = 25.12, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 137.82, ["Mega|Ride"] = 128.63, ["Mega|Fly|Ride"] = 234.86}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Fly|Ride"] = 36.73, ["Neon"] = 3.92, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 112.88, ["Mega"] = 39.75, ["Mega|Ride"] = 64.32, ["Mega|Fly|Ride"] = 193.02}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 24.82, ["Fly"] = 155.59, ["Ride"] = 52.5, ["Neon"] = 208.26, ["Neon|Ride"] = 232.26, ["Mega"] = 787.28, ["Mega|Ride"] = 813.75, ["Mega|Fly|Ride"] = 835.06}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.82, ["Ride"] = 48.26, ["Fly|Ride"] = 209.99, ["Neon"] = 262.5, ["Neon|Ride"] = 78.69, ["Mega"] = 231.21}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 9.85, ["Fly"] = 87.5, ["Ride"] = 41.97, ["Fly|Ride"] = 167.84, ["Neon"] = 65.63, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 75.28, ["Neon|Fly|Ride"] = 155.51, ["Mega"] = 393.1, ["Mega|Ride"] = 346.12, ["Mega|Fly|Ride"] = 413.87}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 57.75, ["Fly"] = 280.08, ["Ride"] = 102.38, ["Fly|Ride"] = 350.36, ["Neon"] = 18316.2, ["Neon|Ride"] = 419.58, ["Neon|Fly|Ride"] = 419.58, ["Mega|Ride"] = 1790.52, ["Mega|Fly|Ride"] = 1818.85}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 30.19, ["Ride"] = 42, ["Fly|Ride"] = 92.99, ["Neon"] = 90.55, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 551.25, ["Mega"] = 378, ["Mega|Ride"] = 392.44, ["Mega|Fly|Ride"] = 501.4}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 77.8, ["Ride"] = 97.9, ["Fly|Ride"] = 157.5, ["Neon"] = 234.94, ["Neon|Ride"] = 263.05, ["Neon|Fly|Ride"] = 300.57, ["Mega"] = 1399.28, ["Mega|Ride"] = 977.61, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 24.87, ["Ride"] = 52.5, ["Fly|Ride"] = 155.63, ["Neon"] = 83.08, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 209.77, ["Mega"] = 310.1, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 19.69, ["Fly"] = 52.5, ["Ride"] = 27.28, ["Fly|Ride"] = 65.63, ["Neon"] = 59.85, ["Neon|Ride"] = 93.35, ["Neon|Fly|Ride"] = 98.61, ["Mega"] = 329.95, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 20.98, ["Fly"] = 111.57, ["Ride"] = 59.05, ["Fly|Ride"] = 167.84, ["Neon"] = 69.77, ["Neon|Ride"] = 90.57, ["Neon|Fly|Ride"] = 203.44, ["Mega"] = 234.94, ["Mega|Ride"] = 352.98, ["Mega|Fly|Ride"] = 570.94}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 8.9, ["Ride"] = 39.38, ["Neon"] = 43.32, ["Neon|Ride"] = 124.04, ["Neon|Fly|Ride"] = 199.29, ["Mega"] = 416.59, ["Mega|Ride"] = 300.65, ["Mega|Fly|Ride"] = 393.33}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 32.78, ["Mega"] = 16.72, ["Mega|Fly"] = 140.58, ["Mega|Ride"] = 66.94, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 2.54, ["Ride"] = 104.91, ["Fly|Ride"] = 70.3, ["Neon"] = 13.12, ["Neon|Ride"] = 83.83, ["Mega"] = 123.09, ["Mega|Ride"] = 156.4, ["Mega|Fly|Ride"] = 310.21}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Neon"] = 22.23, ["Neon|Ride"] = 125.89, ["Mega"] = 336, ["Mega|Ride"] = 392.32}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 6.57, ["Ride"] = 31.37, ["Fly|Ride"] = 116.13, ["Neon"] = 27.57, ["Neon|Ride"] = 83.93, ["Neon|Fly|Ride"] = 279.03, ["Mega"] = 123.38, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 504.67}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 484.32, ["Fly"] = 620.04, ["Ride"] = 485.63, ["Fly|Ride"] = 590.63, ["Neon"] = 1615.36, ["Neon|Ride"] = 1399.28, ["Neon|Fly|Ride"] = 1517.25, ["Mega|Fly|Ride"] = 4593.74}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 6.98, ["Fly"] = 56.26, ["Ride"] = 31.49, ["Fly|Ride"] = 72.01, ["Neon"] = 37.78, ["Neon|Ride"] = 83.93, ["Neon|Fly|Ride"] = 124.32, ["Mega"] = 299.75, ["Mega|Ride"] = 280.08}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 7.56, ["Fly"] = 31.5, ["Neon"] = 64.32, ["Neon|Fly"] = 315, ["Neon|Ride"] = 155.63, ["Mega"] = 343.01, ["Mega|Ride"] = 558.05, ["Mega|Fly|Ride"] = 356.65}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 2.63, ["Ride"] = 23.21, ["Fly|Ride"] = 314.7, ["Neon|Ride"] = 45.94, ["Mega|Ride"] = 354.38, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 41.97, ["Ride"] = 26.25, ["Neon"] = 7.02, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 134.27, ["Mega"] = 73.98, ["Mega|Fly"] = 237.06, ["Mega|Ride"] = 87.62, ["Mega|Fly|Ride"] = 212.31}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Ride"] = 69.25, ["Neon"] = 3.78, ["Neon|Ride"] = 36.02, ["Neon|Fly|Ride"] = 116.2, ["Mega"] = 24.49, ["Mega|Ride"] = 77.64, ["Mega|Fly|Ride"] = 184.63}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1322.26}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 7.85, ["Fly"] = 65.63, ["Ride"] = 41.27, ["Neon"] = 56.44, ["Neon|Fly"] = 140.58, ["Neon|Ride"] = 132.56, ["Neon|Fly|Ride"] = 524.48, ["Mega"] = 523.43, ["Mega|Ride"] = 388.12, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 45.36, ["Neon"] = 7.87, ["Neon|Ride"] = 74.33, ["Mega"] = 49.97, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 230.35}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.1, ["Fly"] = 41.97, ["Ride"] = 42, ["Fly|Ride"] = 525, ["Neon"] = 7.86, ["Neon|Ride"] = 70.09, ["Neon|Fly|Ride"] = 105, ["Mega"] = 118.54, ["Mega|Ride"] = 140.44, ["Mega|Fly|Ride"] = 186.73}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 450.01, ["Fly"] = 459.38, ["Ride"] = 435.31, ["Fly|Ride"] = 510.15, ["Neon|Ride"] = 1509.38, ["Neon|Fly|Ride"] = 1443.32, ["Mega|Fly|Ride"] = 7692.79}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 4.65, ["Fly"] = 196.88, ["Ride"] = 59.07, ["Neon"] = 59.8, ["Neon|Ride"] = 131.25, ["Mega"] = 458.07, ["Mega|Ride"] = 411.27, ["Mega|Fly|Ride"] = 374.07}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Ride"] = 31.37, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 38.66, ["Mega|Fly"] = 155.69, ["Mega|Ride"] = 99.66, ["Mega|Fly|Ride"] = 160.13}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 238.11, ["Neon"] = 3.39, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 23.63, ["Mega|Ride"] = 83.67, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 8.9, ["Fly"] = 78.69, ["Ride"] = 37.16, ["Fly|Ride"] = 56.65, ["Neon"] = 65.63, ["Neon|Ride"] = 207.38, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 328.13, ["Mega|Ride"] = 195.55, ["Mega|Fly|Ride"] = 292.66}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 9.18, ["Ride"] = 36.01, ["Fly|Ride"] = 131.25, ["Neon"] = 41.97, ["Neon|Fly|Ride"] = 837.38, ["Mega"] = 924.11, ["Mega|Ride"] = 464.71, ["Mega|Fly|Ride"] = 1049.35}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 3.82, ["Fly|Ride"] = 140.58, ["Neon"] = 196.17, ["Neon|Ride"] = 208.76, ["Mega"] = 280.08, ["Mega|Ride"] = 395.89, ["Mega|Fly|Ride"] = 1220.63}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 7.82, ["Ride"] = 28.33, ["Fly|Ride"] = 229.66, ["Neon|Ride"] = 124.26, ["Neon|Fly|Ride"] = 774.89, ["Mega"] = 660.19, ["Mega|Ride"] = 440.55, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 301.88, ["Ride"] = 460.04, ["Fly|Ride"] = 606.3, ["Neon"] = 1759.25, ["Neon|Ride"] = 1165.87, ["Neon|Fly|Ride"] = 1174.81, ["Mega|Fly|Ride"] = 3150}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 3.15, ["Fly"] = 24.94, ["Ride"] = 44.63, ["Fly|Ride"] = 82.46, ["Neon"] = 140.58, ["Neon|Ride"] = 98.61, ["Neon|Fly|Ride"] = 196.17, ["Mega"] = 529.78, ["Mega|Ride"] = 498.25, ["Mega|Fly|Ride"] = 699.65}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 5.54, ["Ride"] = 41.68, ["Neon"] = 28.33, ["Mega"] = 1258.72, ["Mega|Fly|Ride"] = 560.14}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 11.22, ["Ride"] = 46.47, ["Fly|Ride"] = 162.75, ["Neon"] = 35.44, ["Neon|Ride"] = 77.42, ["Neon|Fly|Ride"] = 168, ["Mega"] = 162.36, ["Mega|Ride"] = 232.04, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 31.49, ["Fly|Ride"] = 98.61, ["Neon"] = 9.19, ["Neon|Ride"] = 91.88, ["Mega"] = 39.37, ["Mega|Ride"] = 90.63, ["Mega|Fly|Ride"] = 212.62}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 31.48, ["Ride"] = 61.9, ["Neon"] = 215.13, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 464.71, ["Mega"] = 924.11, ["Mega|Ride"] = 951.39, ["Mega|Fly|Ride"] = 1189.5}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 580.47, ["Ride"] = 26.24, ["Fly|Ride"] = 65.63, ["Neon"] = 10.48, ["Neon|Fly"] = 182.53, ["Neon|Ride"] = 49.88, ["Mega"] = 66.3, ["Mega|Ride"] = 106.99, ["Mega|Fly|Ride"] = 250.95}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Ride"] = 31.37, ["Fly|Ride"] = 148.32, ["Neon"] = 5.25, ["Neon|Ride"] = 28.32, ["Mega"] = 44.63, ["Mega|Ride"] = 280.08, ["Mega|Fly|Ride"] = 268.53}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Fly"] = 1519.88, ["Ride"] = 24.94, ["Fly|Ride"] = 262.5, ["Neon"] = 12.48, ["Neon|Ride"] = 158.06, ["Neon|Fly|Ride"] = 295.32, ["Mega"] = 107.01, ["Mega|Ride"] = 170.99, ["Mega|Fly|Ride"] = 201.41}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 72.19, ["Ride"] = 97.13, ["Fly|Ride"] = 155.59, ["Neon"] = 485.63, ["Neon|Ride"] = 314.7, ["Neon|Fly|Ride"] = 672.67, ["Mega|Fly|Ride"] = 901.69}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 196.88, ["Ride"] = 325.12, ["Fly|Ride"] = 419.58, ["Neon|Ride"] = 1099.88, ["Neon|Fly|Ride"] = 1549.78, ["Mega"] = 6993.16, ["Mega|Fly|Ride"] = 5594.95}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 3.68, ["Neon"] = 27.44, ["Neon|Ride"] = 81.3, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 102.35, ["Mega|Ride"] = 229.24, ["Mega|Fly|Ride"] = 415.38}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 4.46, ["Neon"] = 12.78, ["Mega"] = 187.69, ["Mega|Ride"] = 182.53, ["Mega|Fly|Ride"] = 449.61}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 3.81, ["Fly"] = 155.57, ["Neon"] = 56.65, ["Neon|Ride"] = 62.75, ["Mega"] = 484.98}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 53.23, ["Ride"] = 19.94, ["Neon"] = 6.56, ["Neon|Ride"] = 26.94, ["Neon|Fly|Ride"] = 182.53, ["Mega"] = 60.15, ["Mega|Ride"] = 139.42, ["Mega|Fly|Ride"] = 138.48}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 59.07, ["Neon"] = 8.33, ["Mega"] = 28.88, ["Mega|Ride"] = 206.07}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 65.54, ["Ride"] = 15.75, ["Fly|Ride"] = 46.47, ["Neon"] = 3.93, ["Neon|Ride"] = 23.09, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 43.78, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 132.46}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 19.94, ["Fly|Ride"] = 60.38, ["Neon"] = 24.13, ["Neon|Ride"] = 28.33, ["Neon|Fly|Ride"] = 85.98, ["Mega"] = 170.63, ["Mega|Ride"] = 196.17, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 27.49, ["Fly"] = 99.87, ["Ride"] = 28.33, ["Fly|Ride"] = 136.37, ["Neon"] = 113.3, ["Neon|Ride"] = 140.58, ["Neon|Fly|Ride"] = 167.84, ["Mega"] = 367.5, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 435.31}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 80.07, ["Fly"] = 582.75, ["Ride"] = 98.44, ["Fly|Ride"] = 118.13, ["Neon"] = 462.58, ["Neon|Ride"] = 391.13, ["Neon|Fly|Ride"] = 523.43, ["Mega"] = 3098.41, ["Mega|Ride"] = 1437.03, ["Mega|Fly|Ride"] = 1527.59}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 131.25, ["Neon"] = 4.72, ["Neon|Ride"] = 70.3, ["Neon|Fly|Ride"] = 359.63, ["Mega"] = 41.97, ["Mega|Ride"] = 91.35, ["Mega|Fly|Ride"] = 232.37}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 24.13, ["Ride"] = 18.88, ["Fly|Ride"] = 46.47, ["Neon"] = 3.78, ["Neon|Ride"] = 24.86, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 38.07, ["Mega|Fly"] = 157.5, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 3.81, ["Ride"] = 37.78, ["Neon"] = 91.18, ["Neon|Ride"] = 419.58, ["Neon|Fly|Ride"] = 279.03, ["Mega"] = 611, ["Mega|Ride"] = 629.37, ["Mega|Fly|Ride"] = 471.19}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 251.73, ["Ride"] = 551.75, ["Fly|Ride"] = 350.36, ["Neon"] = 979.71, ["Neon|Ride"] = 1468.5, ["Mega|Fly|Ride"] = 5267.39}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 20.96, ["Fly"] = 209.9, ["Ride"] = 68.53, ["Fly|Ride"] = 155.26, ["Neon"] = 278.25, ["Neon|Ride"] = 197.3, ["Neon|Fly|Ride"] = 354.38, ["Mega"] = 896.84, ["Mega|Ride"] = 839.15, ["Mega|Fly|Ride"] = 826.88}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 26.24, ["Neon"] = 10.48, ["Neon|Ride"] = 49.31, ["Mega"] = 123.38, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.55, ["Fly"] = 209.81, ["Ride"] = 83.93, ["Fly|Ride"] = 142.7, ["Neon"] = 25.18, ["Mega"] = 211.32, ["Mega|Ride"] = 434.51}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 28.35, ["Fly"] = 255.95, ["Ride"] = 39.37, ["Fly|Ride"] = 67.36, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 2517.42, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 839.15}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 77.37, ["Ride"] = 140.58, ["Fly|Ride"] = 238.11, ["Neon"] = 345.19, ["Neon|Ride"] = 469.88, ["Neon|Fly|Ride"] = 419.58, ["Mega"] = 3077.54, ["Mega|Fly|Ride"] = 2170.17}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 262.5, ["Fly"] = 499.3, ["Ride"] = 279.03, ["Fly|Ride"] = 406.88, ["Neon"] = 820.32, ["Neon|Ride"] = 979.71, ["Neon|Fly|Ride"] = 918.75, ["Mega|Fly|Ride"] = 3006.22}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 12.26, ["Ride"] = 83.93, ["Fly|Ride"] = 262.5, ["Neon"] = 141.46, ["Neon|Ride"] = 105.15, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 508.87, ["Mega|Ride"] = 380.62, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 20.91, ["Fly|Ride"] = 32.82, ["Neon"] = 8.81, ["Neon|Fly"] = 70.3, ["Neon|Ride"] = 40.92, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 112.28, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 160.13}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 4.22, ["Ride"] = 23.24, ["Fly|Ride"] = 62.95, ["Neon"] = 31.5, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 127.32, ["Mega"] = 225.75, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 409.86}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 313.36, ["Ride"] = 380.63, ["Fly|Ride"] = 482.51, ["Neon|Ride"] = 1818.85, ["Neon|Fly|Ride"] = 1935.27, ["Mega|Fly|Ride"] = 6970.51}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Neon"] = 11.34, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 31.49, ["Mega|Ride"] = 157.36, ["Mega|Fly|Ride"] = 288.14}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 5.16, ["Fly"] = 52.5, ["Ride"] = 17.07, ["Fly|Ride"] = 77.82, ["Neon"] = 25.18, ["Neon|Ride"] = 36.74, ["Neon|Fly|Ride"] = 97.13, ["Mega"] = 236.25, ["Mega|Ride"] = 280.08, ["Mega|Fly|Ride"] = 245.46}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 19.69, ["Ride"] = 41.97, ["Neon"] = 103.63, ["Neon|Fly|Ride"] = 537.06, ["Mega"] = 522.8, ["Mega|Ride"] = 451.5, ["Mega|Fly|Ride"] = 514.5}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 98.44, ["Fly"] = 279.03, ["Ride"] = 118.13, ["Fly|Ride"] = 140.38, ["Neon|Ride"] = 419.58, ["Neon|Fly|Ride"] = 525, ["Mega|Fly|Ride"] = 1531.43}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 19.62, ["Fly"] = 77.81, ["Ride"] = 26.92, ["Fly|Ride"] = 61.9, ["Neon"] = 65.63, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 112.25, ["Mega"] = 699.65, ["Mega|Ride"] = 392.32, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 41.97, ["Neon"] = 2.1, ["Neon|Ride"] = 70.3, ["Neon|Fly|Ride"] = 140.58, ["Mega"] = 19.67, ["Mega|Ride"] = 112.24, ["Mega|Fly|Ride"] = 419.58}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Ride"] = 35.44, ["Fly|Ride"] = 83.93, ["Neon"] = 2.63, ["Neon|Fly"] = 31.37, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 69.18, ["Mega"] = 20.99, ["Mega|Fly"] = 85.98, ["Mega|Ride"] = 61.9, ["Mega|Fly|Ride"] = 112.75}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 7.25, ["Ride"] = 28.88, ["Fly|Ride"] = 157.5, ["Neon"] = 26.17, ["Neon|Fly"] = 263.61, ["Neon|Ride"] = 77.82, ["Neon|Fly|Ride"] = 140.38, ["Mega"] = 185.21, ["Mega|Ride"] = 179.39, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1446.38, ["Ride"] = 1401.75, ["Fly|Ride"] = 1480.5, ["Neon"] = 5244.61, ["Neon|Fly|Ride"] = 4195.69, ["Mega|Fly|Ride"] = 13634.25}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 551.25, ["Ride"] = 615.72, ["Fly|Ride"] = 606.3, ["Neon|Ride"] = 2376.87, ["Neon|Fly|Ride"] = 2412.54, ["Mega"] = 13941.01, ["Mega|Fly|Ride"] = 4659.38}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 278.24, ["Fly"] = 356.65, ["Ride"] = 355.16, ["Fly|Ride"] = 414.1, ["Neon"] = 735, ["Neon|Fly"] = 839.15, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 826.88, ["Mega|Fly|Ride"] = 2061.24}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 322.88, ["Fly"] = 334.69, ["Ride"] = 349.13, ["Fly|Ride"] = 435.75, ["Neon"] = 918.75, ["Neon|Ride"] = 984.37, ["Neon|Fly|Ride"] = 896.44, ["Mega|Ride"] = 3675, ["Mega|Fly|Ride"] = 3033.49}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 79.73, ["Ride"] = 17.07, ["Fly|Ride"] = 34.13, ["Neon"] = 6.17, ["Neon|Ride"] = 45.39, ["Neon|Fly|Ride"] = 124.32, ["Mega"] = 69.3, ["Mega|Ride"] = 87.07, ["Mega|Fly|Ride"] = 140.58}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 301.88, ["Fly"] = 408.72, ["Ride"] = 353.07, ["Fly|Ride"] = 393.75, ["Neon"] = 1110.14, ["Neon|Ride"] = 1085.65, ["Neon|Fly|Ride"] = 1049.99, ["Mega"] = 4182.05, ["Mega|Ride"] = 3937.5, ["Mega|Fly|Ride"] = 3281.25}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 2.1, ["Fly"] = 183.75, ["Ride"] = 27.57, ["Neon"] = 4.22, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 254.63, ["Mega"] = 65.63, ["Mega|Ride"] = 140.37, ["Mega|Fly|Ride"] = 264.48}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 20.93, ["Ride"] = 31.49, ["Fly|Ride"] = 49.88, ["Neon"] = 7.86, ["Neon|Ride"] = 62.71, ["Neon|Fly|Ride"] = 125.89, ["Mega|Ride"] = 133.23, ["Mega|Fly|Ride"] = 202.13}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Neon"] = 3.82, ["Mega"] = 21.9, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 57.31, ["Ride"] = 70.3, ["Fly|Ride"] = 459.38, ["Neon"] = 273, ["Neon|Ride"] = 420, ["Mega"] = 2097.85, ["Mega|Ride"] = 929.41, ["Mega|Fly|Ride"] = 972.57}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 65.61, ["Ride"] = 18.88, ["Neon"] = 28.33, ["Mega"] = 328.13, ["Mega|Ride"] = 316.79}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 53.82, ["Neon"] = 3.93, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 19.69, ["Mega|Fly"] = 109.22, ["Mega|Ride"] = 155.69, ["Mega|Fly|Ride"] = 308.44}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.1, ["Ride"] = 27.28, ["Fly|Ride"] = 69.57, ["Neon"] = 4.66, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 19.59, ["Neon|Fly|Ride"] = 82.67, ["Mega"] = 66.33, ["Mega|Fly"] = 209.12, ["Mega|Ride"] = 89.25, ["Mega|Fly|Ride"] = 171.99}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 8.39, ["Fly"] = 46.1, ["Ride"] = 32.49, ["Fly|Ride"] = 55.26, ["Neon"] = 56.65, ["Neon|Ride"] = 107.14, ["Neon|Fly|Ride"] = 251.76, ["Mega"] = 237.57, ["Mega|Fly|Ride"] = 1019.82}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 13.9, ["Ride"] = 27.57, ["Mega"] = 464.71, ["Mega|Ride"] = 333.57, ["Mega|Fly|Ride"] = 519.23}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.52, ["Ride"] = 46.18, ["Fly|Ride"] = 87.94, ["Neon"] = 39.38, ["Neon|Fly|Ride"] = 697.07, ["Mega"] = 228.68, ["Mega|Ride"] = 489.86}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 17.43, ["Fly|Ride"] = 83.93, ["Neon"] = 3.76, ["Neon|Ride"] = 28.33, ["Neon|Fly|Ride"] = 167.84, ["Mega"] = 34.13, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 314.7}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 207.37, ["Fly"] = 218.19, ["Ride"] = 216.57, ["Fly|Ride"] = 275.63, ["Neon"] = 1163.09, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 951.39, ["Neon|Fly|Ride"] = 979.71, ["Mega"] = 8391.36, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 16.54, ["Fly|Ride"] = 32.82, ["Neon"] = 3.77, ["Neon|Ride"] = 22.73, ["Neon|Fly|Ride"] = 69.71, ["Mega"] = 41.97, ["Mega|Ride"] = 73.5, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 9.17, ["Ride"] = 69.57, ["Fly|Ride"] = 105, ["Neon"] = 77.56, ["Neon|Ride"] = 145.82, ["Neon|Fly|Ride"] = 327.63, ["Mega"] = 315, ["Mega|Ride"] = 318.71, ["Mega|Fly|Ride"] = 464.71}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 32.34, ["Ride"] = 118.13, ["Neon"] = 153.57, ["Neon|Ride"] = 219.19, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 720.62, ["Mega|Ride"] = 788.06, ["Mega|Fly|Ride"] = 826.19}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 168, ["Fly"] = 262.5, ["Ride"] = 223.13, ["Fly|Ride"] = 291.38, ["Neon|Ride"] = 742.88, ["Neon|Fly|Ride"] = 866.25, ["Mega|Fly|Ride"] = 3245.38}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 20.6, ["Neon"] = 65.63, ["Mega"] = 328.13, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 699.65}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 24.33, ["Ride"] = 314.7, ["Fly|Ride"] = 628.32, ["Neon"] = 188.09, ["Neon|Ride"] = 629.37, ["Neon|Fly|Ride"] = 839.15, ["Mega"] = 625.79, ["Mega|Ride"] = 895.72, ["Mega|Fly|Ride"] = 1048.93}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 1147.82, ["Ride"] = 984.38, ["Fly|Ride"] = 997.5, ["Neon|Ride"] = 6293.53, ["Neon|Fly|Ride"] = 4726.44, ["Mega|Fly|Ride"] = 16358.95}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 5.86, ["Fly"] = 43.32, ["Ride"] = 20.99, ["Fly|Ride"] = 62.03, ["Neon"] = 49.3, ["Neon|Fly"] = 111.57, ["Neon|Ride"] = 77.86, ["Neon|Fly|Ride"] = 65.62, ["Mega"] = 131.24, ["Mega|Fly"] = 560.14, ["Mega|Ride"] = 267.49, ["Mega|Fly|Ride"] = 382.6}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 2.63, ["Fly"] = 13845.75, ["Ride"] = 42, ["Neon"] = 38.07, ["Neon|Fly|Ride"] = 144.74, ["Mega"] = 212.63, ["Mega|Ride"] = 217.88, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Ride"] = 31.49, ["Fly|Ride"] = 91.27, ["Neon"] = 16.99, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 310.21, ["Mega"] = 162.6, ["Mega|Ride"] = 238.11, ["Mega|Fly|Ride"] = 560.14}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 15.1, ["Fly"] = 40.69, ["Ride"] = 38.88, ["Fly|Ride"] = 83.62, ["Neon"] = 64.32, ["Neon|Ride"] = 127.15, ["Neon|Fly|Ride"] = 200.87, ["Mega"] = 315, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 3.29, ["Fly"] = 36.73, ["Ride"] = 34.13, ["Fly|Ride"] = 65.63, ["Neon"] = 22.32, ["Neon|Ride"] = 62.71, ["Neon|Fly|Ride"] = 75.54, ["Mega|Ride"] = 197.51, ["Mega|Fly|Ride"] = 218.93}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Ride"] = 27.93, ["Neon"] = 7.88, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 44.07, ["Neon|Fly|Ride"] = 140.44, ["Mega"] = 111.56, ["Mega|Ride"] = 266.44, ["Mega|Fly|Ride"] = 209.81}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 1084.3, ["Ride"] = 448.95, ["Fly|Ride"] = 476.22, ["Neon|Ride"] = 1693.13, ["Neon|Fly|Ride"] = 1119.22, ["Mega|Fly|Ride"] = 3455.15}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Ride"] = 35.44, ["Neon"] = 8.97, ["Neon|Fly"] = 77.82, ["Neon|Ride"] = 38.59, ["Neon|Fly|Ride"] = 122.74, ["Mega"] = 71.08, ["Mega|Ride"] = 139.12, ["Mega|Fly|Ride"] = 209.81}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 3.72, ["Fly"] = 408.19, ["Neon"] = 77.43, ["Mega"] = 248.07, ["Mega|Ride"] = 272.34}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 3.92, ["Fly"] = 81.79, ["Ride"] = 34.13, ["Neon"] = 15.72, ["Neon|Ride"] = 52.5, ["Mega"] = 125.69, ["Mega|Ride"] = 177.85, ["Mega|Fly|Ride"] = 404.92}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 156.19, ["Fly"] = 262.5, ["Ride"] = 220.5, ["Fly|Ride"] = 337.93, ["Neon"] = 393.75, ["Neon|Ride"] = 577.5, ["Neon|Fly|Ride"] = 628.32, ["Mega"] = 1957.3, ["Mega|Ride"] = 2475.47, ["Mega|Fly|Ride"] = 1785}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 19.2, ["Ride"] = 84, ["Fly|Ride"] = 109.11, ["Neon"] = 163.49, ["Neon|Ride"] = 115.5, ["Neon|Fly|Ride"] = 209.81, ["Mega"] = 531.82, ["Mega|Ride"] = 629.37, ["Mega|Fly|Ride"] = 560.2}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 12.37, ["Ride"] = 39.38, ["Neon"] = 110.96, ["Neon|Ride"] = 140.58, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 671.32, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 636.57}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 31.37, ["Neon"] = 4.73, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 35.44, ["Mega"] = 34.13, ["Mega|Ride"] = 74.82, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 78.63, ["Fly"] = 155.56, ["Ride"] = 124.69, ["Fly|Ride"] = 224.49, ["Neon"] = 432.68, ["Neon|Ride"] = 419.58, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 905.63}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 20.98, ["Neon"] = 8.4, ["Neon|Fly|Ride"] = 588, ["Mega"] = 60.85}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 15.74, ["Fly"] = 140.38, ["Ride"] = 45.94, ["Fly|Ride"] = 124.84, ["Neon"] = 98.54, ["Neon|Ride"] = 104.91, ["Neon|Fly|Ride"] = 119.59, ["Mega"] = 380.63, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 419.41}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 42, ["Ride"] = 98.44, ["Fly|Ride"] = 167.84, ["Neon|Ride"] = 246.51, ["Neon|Fly|Ride"] = 402.8, ["Mega"] = 1394.12, ["Mega|Ride"] = 1214.66, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 28.25, ["Ride"] = 15.75, ["Fly|Ride"] = 47.25, ["Neon"] = 2.55, ["Neon|Fly"] = 27.72, ["Neon|Ride"] = 15.73, ["Neon|Fly|Ride"] = 48.09, ["Mega"] = 20.05, ["Mega|Ride"] = 44.63, ["Mega|Fly|Ride"] = 103.67}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 3.91, ["Ride"] = 36.72, ["Fly|Ride"] = 98.65, ["Neon"] = 18.59, ["Neon|Ride"] = 65.04, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 202.79, ["Mega|Ride"] = 280.88, ["Mega|Fly|Ride"] = 504.67}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 13.13, ["Ride"] = 62.71, ["Fly|Ride"] = 130.08, ["Neon"] = 177.19, ["Neon|Ride"] = 140.58, ["Neon|Fly|Ride"] = 280.08, ["Mega"] = 697.07, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 628.69}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 23.09, ["Neon"] = 2.63, ["Neon|Ride"] = 28.13, ["Neon|Fly|Ride"] = 125.89, ["Mega"] = 16.79, ["Mega|Ride"] = 138.48, ["Mega|Fly|Ride"] = 390.48}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 3.54, ["Fly"] = 210, ["Ride"] = 53.44, ["Fly|Ride"] = 98.44, ["Neon"] = 40.69, ["Neon|Ride"] = 62.69, ["Neon|Fly|Ride"] = 181.22, ["Mega"] = 405.95, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 414.33}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 16.79, ["Fly"] = 31.36, ["Ride"] = 32.82, ["Fly|Ride"] = 46.47, ["Neon"] = 112.22, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 699.65, ["Mega|Fly|Ride"] = 466.55}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 2.1, ["Ride"] = 22.99, ["Neon"] = 28.87, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 200.82, ["Mega"] = 150.94, ["Mega|Ride"] = 246.51, ["Mega|Fly|Ride"] = 289.52}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 20.71, ["Fly"] = 2097.85, ["Ride"] = 99.75, ["Neon"] = 121.02, ["Neon|Ride"] = 497.01, ["Neon|Fly|Ride"] = 6195.62, ["Mega"] = 451.5, ["Mega|Ride"] = 560.14, ["Mega|Fly|Ride"] = 661.5}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.63, ["Ride"] = 24.13, ["Fly|Ride"] = 126.48, ["Neon"] = 7.38, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 70.3, ["Mega"] = 78.69, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 408.19, ["Mega|Fly|Ride"] = 288.74}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 28.33, ["Neon"] = 3.91, ["Mega"] = 27.57, ["Mega|Ride"] = 132.19}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 31.5}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 52.41, ["Fly"] = 77.64, ["Ride"] = 78.73, ["Fly|Ride"] = 204.56, ["Neon"] = 1050, ["Neon|Fly|Ride"] = 1048.93, ["Mega|Ride"] = 977.62, ["Mega|Fly|Ride"] = 889.88}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 140.58, ["Neon"] = 2.1, ["Mega"] = 18.32, ["Mega|Ride"] = 77.64, ["Mega|Fly|Ride"] = 140.58}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 140.58, ["Ride"] = 590.63, ["Fly|Ride"] = 654.93, ["Neon"] = 4195.69, ["Neon|Fly|Ride"] = 2362.5, ["Mega"] = 16782.71, ["Mega|Fly|Ride"] = 8370.38}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 262.5, ["Fly"] = 49.88, ["Ride"] = 40.94, ["Fly|Ride"] = 54.58, ["Neon"] = 30.19, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 560.14, ["Mega|Fly|Ride"] = 560.14}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.49, ["Ride"] = 21, ["Fly|Ride"] = 44.63, ["Neon"] = 26.25, ["Neon|Ride"] = 35.47, ["Neon|Fly|Ride"] = 78.69, ["Mega"] = 167.87, ["Mega|Ride"] = 155.69, ["Mega|Fly|Ride"] = 258.05}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 13.13, ["Ride"] = 76.13, ["Fly|Ride"] = 524.48, ["Neon"] = 344.06, ["Neon|Ride"] = 419.58, ["Mega"] = 1036.34, ["Mega|Ride"] = 489.86, ["Mega|Fly|Ride"] = 1257.67}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 9.18, ["Fly"] = 49.31, ["Ride"] = 39.38, ["Fly|Ride"] = 393.75, ["Neon"] = 140.58, ["Mega"] = 293.71, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 10.48, ["Ride"] = 60.38, ["Fly|Ride"] = 157.5, ["Neon"] = 62.67, ["Neon|Fly"] = 188.83, ["Neon|Ride"] = 176.24, ["Neon|Fly|Ride"] = 350.44, ["Mega"] = 414.58, ["Mega|Ride"] = 476.22, ["Mega|Fly|Ride"] = 524.48}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 6.28, ["Fly"] = 105, ["Ride"] = 28.33, ["Fly|Ride"] = 65.63, ["Neon"] = 42, ["Neon|Ride"] = 70.3, ["Neon|Fly|Ride"] = 138.48, ["Mega"] = 170.63, ["Mega|Fly"] = 484.61, ["Mega|Ride"] = 280.08, ["Mega|Fly|Ride"] = 294}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 46.47, ["Ride"] = 18.88, ["Fly|Ride"] = 75.54, ["Neon"] = 2.1, ["Neon|Fly"] = 41.99, ["Neon|Ride"] = 18.9, ["Neon|Fly|Ride"] = 60.1, ["Mega"] = 15.75, ["Mega|Fly"] = 77.86, ["Mega|Ride"] = 46.49, ["Mega|Fly|Ride"] = 65.63}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 6.27, ["Ride"] = 32.82, ["Fly|Ride"] = 56.65, ["Neon"] = 44.63, ["Neon|Fly"] = 387.85, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 622.13, ["Mega"] = 132.56, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 270.63}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 255.94, ["Ride"] = 288.75, ["Fly|Ride"] = 302.98, ["Neon"] = 1290.19, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1365, ["Mega"] = 5593.84, ["Mega|Fly|Ride"] = 5643.75}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 96.54, ["Ride"] = 133.54, ["Fly|Ride"] = 249.38, ["Neon"] = 906.29, ["Neon|Ride"] = 866.25, ["Neon|Fly|Ride"] = 944.05, ["Mega"] = 4195.69, ["Mega|Ride"] = 1992.97, ["Mega|Fly|Ride"] = 1746.72}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 24.94, ["Fly|Ride"] = 39.37, ["Neon"] = 12.6, ["Neon|Ride"] = 23.24, ["Neon|Fly|Ride"] = 53.45, ["Mega|Fly"] = 208.76, ["Mega|Ride"] = 91.27, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 18.83, ["Ride"] = 15.75, ["Fly|Ride"] = 31.17, ["Neon"] = 6.28, ["Neon|Fly"] = 36.02, ["Neon|Ride"] = 22.93, ["Neon|Fly|Ride"] = 62.75, ["Mega"] = 131.78, ["Mega|Ride"] = 153.36, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.55, ["Ride"] = 18.97, ["Fly|Ride"] = 98.44, ["Neon"] = 13.13, ["Mega"] = 140.58}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 275.63, ["Ride"] = 312.6, ["Fly|Ride"] = 252, ["Neon|Ride"] = 1258.72, ["Neon|Fly|Ride"] = 1678.29, ["Mega|Ride"] = 8391.36, ["Mega|Fly|Ride"] = 4751.62}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.1, ["Fly"] = 23.99, ["Ride"] = 15.74, ["Fly|Ride"] = 39.37, ["Neon"] = 11.7, ["Neon|Fly"] = 155.63, ["Neon|Ride"] = 33.9, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 266.44, ["Mega|Ride"] = 209.81, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 3.93, ["Ride"] = 39.37, ["Fly|Ride"] = 209.81, ["Neon"] = 24.94, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 224.48, ["Mega"] = 196.17, ["Mega|Ride"] = 204.75, ["Mega|Fly|Ride"] = 302.44}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 91.88, ["Neon"] = 3.93, ["Neon|Ride"] = 24.94, ["Mega"] = 28.33, ["Mega|Ride"] = 94.5, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 16.37, ["Fly"] = 41.97, ["Ride"] = 26.73, ["Fly|Ride"] = 60.78, ["Neon"] = 107.01, ["Neon|Ride"] = 90.01, ["Neon|Fly|Ride"] = 231, ["Mega"] = 575.08, ["Mega|Ride"] = 405.95, ["Mega|Fly|Ride"] = 769.93}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 41.97, ["Ride"] = 69.12, ["Fly|Ride"] = 262.5, ["Neon"] = 155.66, ["Neon|Fly"] = 310.06, ["Neon|Ride"] = 182.44, ["Neon|Fly|Ride"] = 279.57, ["Mega"] = 476.7, ["Mega|Fly"] = 587.41, ["Mega|Ride"] = 531.76, ["Mega|Fly|Ride"] = 601.13}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 27.57, ["Fly"] = 131.25, ["Ride"] = 41.89, ["Fly|Ride"] = 65.63, ["Neon"] = 380.63, ["Neon|Ride"] = 179.16, ["Neon|Fly|Ride"] = 219.19, ["Mega|Ride"] = 783.12, ["Mega|Fly|Ride"] = 696.49}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 20.89, ["Ride"] = 71.53, ["Fly|Ride"] = 51.45, ["Neon"] = 2.1, ["Neon|Fly"] = 70.3, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 56.65, ["Mega"] = 20.99, ["Mega|Fly"] = 40.92, ["Mega|Ride"] = 58.75, ["Mega|Fly|Ride"] = 115.5}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 209.79, ["Ride"] = 262.5, ["Fly|Ride"] = 263.61, ["Neon"] = 928.99, ["Neon|Ride"] = 906.94, ["Neon|Fly|Ride"] = 1045.79, ["Mega|Fly|Ride"] = 3412.5}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 11.38, ["Fly"] = 210, ["Ride"] = 45.94, ["Fly|Ride"] = 112.25, ["Neon"] = 118.13, ["Neon|Ride"] = 123.38, ["Neon|Fly|Ride"] = 210, ["Mega"] = 545.45, ["Mega|Ride"] = 449.61, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Ride"] = 28.33, ["Fly|Ride"] = 59.07, ["Neon"] = 5.24, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 52.65, ["Mega|Fly"] = 111.57, ["Mega|Ride"] = 140.58, ["Mega|Fly|Ride"] = 274.82}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 140.58, ["Ride"] = 17.07, ["Neon"] = 2.1, ["Neon|Ride"] = 22.44, ["Neon|Fly|Ride"] = 101.21, ["Mega"] = 19.67, ["Mega|Fly"] = 137.42, ["Mega|Ride"] = 45.12, ["Mega|Fly|Ride"] = 127.98}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 3.78, ["Ride"] = 28.88, ["Fly|Ride"] = 62.95, ["Neon"] = 13.13, ["Neon|Fly|Ride"] = 182.53, ["Mega"] = 85.32, ["Mega|Ride"] = 116.75, ["Mega|Fly|Ride"] = 419.58}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 11.8, ["Fly"] = 32.29, ["Ride"] = 24.55, ["Fly|Ride"] = 67.02, ["Neon"] = 45.93, ["Neon|Ride"] = 74.47, ["Neon|Fly|Ride"] = 140.58, ["Mega"] = 540.21, ["Mega|Ride"] = 370.13, ["Mega|Fly|Ride"] = 435.31}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 7.77, ["Ride"] = 26.25, ["Neon"] = 101.07, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 208.76, ["Mega|Ride"] = 360.15, ["Mega|Fly|Ride"] = 446.85}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 52.41, ["Fly|Ride"] = 49.31, ["Neon"] = 3.5, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 26.25, ["Mega|Ride"] = 45.94, ["Mega|Fly|Ride"] = 241.47}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 13.13, ["Ride"] = 31.49, ["Fly|Ride"] = 94.42, ["Neon"] = 27.88, ["Neon|Fly"] = 102.92, ["Neon|Ride"] = 60.85, ["Neon|Fly|Ride"] = 119.6, ["Mega"] = 140.58, ["Mega|Ride"] = 262.24, ["Mega|Fly|Ride"] = 379.92}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 210, ["Neon"] = 8.4, ["Neon|Ride"] = 91.88, ["Mega"] = 31.49, ["Mega|Ride"] = 94.22, ["Mega|Fly|Ride"] = 615.9}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 40.05, ["Ride"] = 24.94, ["Fly|Ride"] = 118.13, ["Neon"] = 4.08, ["Neon|Ride"] = 27.3, ["Neon|Fly|Ride"] = 116.45, ["Mega"] = 56.44, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 195.8}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 1216.76, ["Ride"] = 1048.69, ["Fly|Ride"] = 1552.42, ["Neon|Fly|Ride"] = 4685.54, ["Mega|Fly|Ride"] = 13941.01}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 15.64, ["Fly|Ride"] = 39.38, ["Neon"] = 22.32, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 124.68, ["Neon|Fly|Ride"] = 104.91, ["Mega"] = 187.78, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.1, ["Ride"] = 30.19, ["Neon"] = 5.09, ["Neon|Ride"] = 125.89, ["Neon|Fly|Ride"] = 140.58, ["Mega"] = 41.97, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 198.18}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 10.5, ["Fly"] = 32.82, ["Ride"] = 18.83, ["Fly|Ride"] = 52.5, ["Neon"] = 140.58, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 277.93, ["Mega|Fly|Ride"] = 353.07}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.74, ["Fly|Ride"] = 40.36, ["Neon"] = 4.65, ["Neon|Fly"] = 89.24, ["Neon|Ride"] = 22.81, ["Neon|Fly|Ride"] = 62.99, ["Mega"] = 72.19, ["Mega|Ride"] = 100.71, ["Mega|Fly|Ride"] = 198.19}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 59.07, ["Fly|Ride"] = 155.63, ["Neon"] = 302.09, ["Neon|Ride"] = 335.67, ["Neon|Fly|Ride"] = 314.7, ["Mega"] = 769.13, ["Mega|Ride"] = 1021.67, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Fly"] = 36.01, ["Ride"] = 26.17, ["Fly|Ride"] = 39.38, ["Neon"] = 4.19, ["Neon|Ride"] = 34.84, ["Neon|Fly|Ride"] = 109.22, ["Mega"] = 115.5, ["Mega|Ride"] = 77.67, ["Mega|Fly|Ride"] = 280.08}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 73.5, ["Ride"] = 31.35, ["Fly|Ride"] = 65.63, ["Neon"] = 11.8, ["Neon|Fly"] = 146.87, ["Neon|Ride"] = 70.08, ["Neon|Fly|Ride"] = 140.58, ["Mega"] = 280.08, ["Mega|Ride"] = 293.71, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly|Ride"] = 65.63, ["Neon"] = 20.91, ["Neon|Fly"] = 62.71, ["Mega"] = 57.16, ["Mega|Ride"] = 155.69}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 2593.49, ["Ride"] = 19.94, ["Fly|Ride"] = 134.27, ["Neon"] = 3.81, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 41.85, ["Mega|Fly"] = 108.94, ["Mega|Ride"] = 90.69, ["Mega|Fly|Ride"] = 116.18}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 17.28, ["Fly"] = 39.87, ["Ride"] = 22.08, ["Fly|Ride"] = 43.32, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 78.73, ["Mega"] = 839.15, ["Mega|Ride"] = 519.23, ["Mega|Fly|Ride"] = 463.6}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 777, ["Ride"] = 758.63, ["Fly|Ride"] = 880.69, ["Neon"] = 2020.52, ["Neon|Ride"] = 2179.67, ["Neon|Fly|Ride"] = 2000.31, ["Mega"] = 6993.16, ["Mega|Ride"] = 5643.75, ["Mega|Fly|Ride"] = 4987.5}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 66.94, ["Ride"] = 16.3, ["Fly|Ride"] = 45.12, ["Neon"] = 5.09, ["Neon|Fly"] = 28.33, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 36.75, ["Mega|Fly"] = 77.64, ["Mega|Ride"] = 74.37, ["Mega|Fly|Ride"] = 99.75}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 6.86, ["Ride"] = 38.66, ["Neon"] = 54.55, ["Neon|Ride"] = 125.55, ["Neon|Fly|Ride"] = 335.67, ["Mega"] = 269.07, ["Mega|Ride"] = 155.69, ["Mega|Fly|Ride"] = 441}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 83.77, ["Fly"] = 144.38, ["Ride"] = 101.74, ["Fly|Ride"] = 140.44, ["Neon|Ride"] = 635.66, ["Neon|Fly|Ride"] = 560.14, ["Mega"] = 2943.88, ["Mega|Fly|Ride"] = 3062.07}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 35.37, ["Ride"] = 70.32, ["Fly|Ride"] = 301.88, ["Neon"] = 280.08, ["Neon|Ride"] = 177.19, ["Mega"] = 825.51, ["Mega|Ride"] = 690.77, ["Mega|Fly|Ride"] = 677.62}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 15.65, ["Fly|Ride"] = 317.84, ["Neon"] = 82.64, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 225.39, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 498.87}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 52.01, ["Ride"] = 112.35, ["Neon"] = 121.69, ["Neon|Ride"] = 356.51, ["Mega"] = 327.28, ["Mega|Ride"] = 340.74, ["Mega|Fly|Ride"] = 431.17}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 26.35, ["Ride"] = 315, ["Neon"] = 145.62, ["Neon|Ride"] = 314.7, ["Neon|Fly|Ride"] = 525, ["Mega"] = 719.92, ["Mega|Ride"] = 778.28, ["Mega|Fly|Ride"] = 771.1}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 7.54}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 4.17, ["Ride"] = 31.37, ["Neon"] = 56.11, ["Neon|Ride"] = 70.29, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 419.58, ["Mega|Ride"] = 216.57, ["Mega|Fly|Ride"] = 377.63}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 3.28, ["Neon"] = 33.57, ["Mega"] = 867.84, ["Mega|Fly|Ride"] = 944.05}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 52.5, ["Fly"] = 418.52, ["Ride"] = 52.5, ["Fly|Ride"] = 116.81, ["Neon"] = 209.81, ["Neon|Ride"] = 208.22, ["Neon|Fly|Ride"] = 354.38, ["Mega|Ride"] = 681.19, ["Mega|Fly|Ride"] = 754.69}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.93, ["Fly"] = 26.17, ["Ride"] = 15.75, ["Fly|Ride"] = 45.12, ["Neon"] = 27.26, ["Neon|Fly"] = 41.92, ["Neon|Ride"] = 36.04, ["Neon|Fly|Ride"] = 51.06, ["Mega"] = 310.21, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 241.5}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 6.22, ["Ride"] = 19.66, ["Fly|Ride"] = 91.88, ["Neon"] = 26.25, ["Neon|Ride"] = 62.83, ["Neon|Fly|Ride"] = 148.81, ["Mega"] = 131.25, ["Mega|Fly"] = 301.45, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Mega"] = 45.94}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 32.82, ["Fly"] = 148.32, ["Ride"] = 45.94, ["Fly|Ride"] = 78.72, ["Neon"] = 167.84, ["Neon|Ride"] = 209.81, ["Mega"] = 1085.1, ["Mega|Ride"] = 827.91, ["Mega|Fly|Ride"] = 695.63}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Neon"] = 11.47, ["Neon|Fly"] = 145.69, ["Mega"] = 125.89, ["Mega|Ride"] = 208.11}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 7.86, ["Ride"] = 140.63, ["Neon"] = 65.63, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 293.71, ["Mega"] = 292.69, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 560.14}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 23.63, ["Ride"] = 17.26, ["Fly|Ride"] = 61.69, ["Neon"] = 27.28, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 70.88, ["Mega|Ride"] = 196.23, ["Mega|Fly|Ride"] = 314.35}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 3.68, ["Fly"] = 52.5, ["Ride"] = 24.13, ["Fly|Ride"] = 49.88, ["Neon"] = 52.5, ["Neon|Fly"] = 112.25, ["Neon|Ride"] = 28.33, ["Mega"] = 209.81, ["Mega|Ride"] = 418.52, ["Mega|Fly|Ride"] = 209.81}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 3.67, ["Ride"] = 24.94, ["Fly|Ride"] = 77.82, ["Neon"] = 21, ["Neon|Ride"] = 111.57, ["Mega"] = 140.6, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 335.67}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 32.71, ["Fly"] = 118.13, ["Ride"] = 125.89, ["Fly|Ride"] = 131.25, ["Neon"] = 167.84, ["Neon|Ride"] = 260.15, ["Mega"] = 905.24, ["Mega|Ride"] = 1258.72, ["Mega|Fly|Ride"] = 870.19}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 14.42, ["Ride"] = 245.46, ["Neon"] = 209.79, ["Neon|Fly|Ride"] = 388.04, ["Mega"] = 262.5, ["Mega|Ride"] = 350.36, ["Mega|Fly|Ride"] = 419.58}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 7.53, ["Ride"] = 105, ["Neon"] = 91.62, ["Neon|Ride"] = 56.65, ["Mega"] = 430.87, ["Mega|Ride"] = 1550.95, ["Mega|Fly|Ride"] = 1678.29}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 15.7, ["Ride"] = 105, ["Fly|Ride"] = 422.03, ["Neon"] = 59.07, ["Mega"] = 766.5, ["Mega|Ride"] = 708.75, ["Mega|Fly|Ride"] = 671.35}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 3.81, ["Neon"] = 44.34, ["Mega"] = 249.38, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 28.32, ["Ride"] = 21, ["Fly|Ride"] = 52.5, ["Neon"] = 6.5, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 46.17, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 194.2}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 5.24, ["Ride"] = 69.68, ["Neon"] = 26.25, ["Neon|Ride"] = 119.62, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 196.88, ["Mega|Ride"] = 265.89, ["Mega|Fly|Ride"] = 356.67}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 31.86, ["Ride"] = 23.09, ["Fly|Ride"] = 53.82, ["Neon"] = 6.57, ["Neon|Fly"] = 32.52, ["Neon|Ride"] = 25.18, ["Neon|Fly|Ride"] = 69.25, ["Mega"] = 44.44, ["Mega|Ride"] = 97.13, ["Mega|Fly|Ride"] = 139.42}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 3.13, ["Ride"] = 19.69, ["Neon"] = 13.13, ["Neon|Ride"] = 92.92, ["Neon|Fly|Ride"] = 260.15, ["Mega"] = 249.38, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 464.71}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 5.25, ["Ride"] = 27.57, ["Fly|Ride"] = 72.19, ["Neon|Ride"] = 133.23, ["Mega"] = 419.58, ["Mega|Fly|Ride"] = 977.62}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 3.72, ["Fly"] = 30.85, ["Ride"] = 22.31, ["Neon"] = 28.33, ["Neon|Fly"] = 91.27, ["Neon|Ride"] = 35.35, ["Neon|Fly|Ride"] = 92.95, ["Mega"] = 280.08, ["Mega|Ride"] = 118.12, ["Mega|Fly|Ride"] = 201.44}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Ride"] = 23.03, ["Fly|Ride"] = 42.03, ["Neon"] = 23.24, ["Neon|Ride"] = 82.46, ["Mega"] = 166.68, ["Mega|Ride"] = 140.44, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 3.71, ["Ride"] = 349.51, ["Neon"] = 19.67, ["Neon|Fly"] = 57.68, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 167.84, ["Mega"] = 77.44, ["Mega|Ride"] = 140.58, ["Mega|Fly|Ride"] = 289.52}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 10.5, ["Ride"] = 98.44, ["Fly|Ride"] = 209.81, ["Neon"] = 56.65, ["Neon|Ride"] = 119.51, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 360.94, ["Mega|Fly"] = 656.25, ["Mega|Ride"] = 476.22, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 52.5, ["Fly"] = 197.36, ["Ride"] = 110.87, ["Fly|Ride"] = 291.38, ["Neon"] = 279.57, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 317.56, ["Mega"] = 1678.29, ["Mega|Ride"] = 997.5, ["Mega|Fly|Ride"] = 1007.26}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Ride"] = 19.92, ["Neon"] = 2.6, ["Neon|Ride"] = 17.43, ["Mega"] = 28.33, ["Mega|Ride"] = 62.99, ["Mega|Fly|Ride"] = 120.64}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 15.75, ["Ride"] = 131.25, ["Neon"] = 54.55, ["Mega"] = 312.38, ["Mega|Ride"] = 405.95, ["Mega|Fly|Ride"] = 1245.08}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 42.08, ["Ride"] = 115.5, ["Neon"] = 279.98, ["Neon|Ride"] = 419.58, ["Mega|Ride"] = 1153.83, ["Mega|Fly|Ride"] = 1239.1}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 8.91, ["Fly"] = 190.32, ["Ride"] = 59.07, ["Fly|Ride"] = 117.69, ["Neon"] = 39.35, ["Neon|Ride"] = 99.52, ["Neon|Fly|Ride"] = 140.58, ["Mega"] = 157.5, ["Mega|Ride"] = 161.55, ["Mega|Fly|Ride"] = 310.21}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 2.1, ["Fly"] = 157.5, ["Ride"] = 42, ["Fly|Ride"] = 137.82, ["Neon"] = 2.1, ["Neon|Ride"] = 27.53, ["Mega"] = 20.98, ["Mega|Ride"] = 62.97, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 17.07, ["Fly|Ride"] = 77.81, ["Neon"] = 15.73, ["Neon|Fly"] = 26.72, ["Neon|Ride"] = 35.1, ["Neon|Fly|Ride"] = 98.44, ["Mega|Ride"] = 140.58, ["Mega|Fly|Ride"] = 209.81}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 18.37, ["Ride"] = 18.81, ["Fly|Ride"] = 32.52, ["Neon"] = 3.82, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 2943.88, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 98.44}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 20.99, ["Fly|Ride"] = 91.27, ["Neon"] = 3.78, ["Neon|Ride"] = 34.01, ["Neon|Fly|Ride"] = 83.32, ["Mega"] = 35.64, ["Mega|Fly"] = 168, ["Mega|Ride"] = 94.42, ["Mega|Fly|Ride"] = 147.48}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 2.1, ["Neon|Ride"] = 30.19, ["Mega"] = 19.69, ["Mega|Ride"] = 98.61, ["Mega|Fly|Ride"] = 258.05}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 9.18, ["Ride"] = 157.5, ["Fly|Ride"] = 356.65, ["Neon"] = 27.38, ["Neon|Fly"] = 140.58, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 620.39, ["Mega"] = 213.94, ["Mega|Ride"] = 295.1, ["Mega|Fly|Ride"] = 1118.17}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 4.99, ["Ride"] = 41.94, ["Fly|Ride"] = 83.93, ["Neon"] = 124.43, ["Neon|Ride"] = 140.58, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 377.63, ["Mega|Ride"] = 405.95, ["Mega|Fly|Ride"] = 364.88}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 7.85, ["Fly"] = 24.93, ["Ride"] = 19.69, ["Fly|Ride"] = 45.93, ["Neon"] = 56.44, ["Neon|Fly"] = 105.69, ["Neon|Ride"] = 57.14, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 317.63, ["Mega|Ride"] = 342.57, ["Mega|Fly|Ride"] = 363.99}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 85.93, ["Ride"] = 67.14, ["Fly|Ride"] = 262.49, ["Neon"] = 419.58, ["Neon|Ride"] = 524.48, ["Mega"] = 3098.41, ["Mega|Ride"] = 2097.85, ["Mega|Fly|Ride"] = 1538.17}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 18.02, ["Ride"] = 65.63, ["Neon"] = 36.75, ["Neon|Fly"] = 125.89, ["Mega"] = 610.97, ["Mega|Fly"] = 644.05, ["Mega|Ride"] = 600.48, ["Mega|Fly|Ride"] = 560.14}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 20.91, ["Ride"] = 21.77, ["Fly|Ride"] = 54.56, ["Neon"] = 3.19, ["Neon|Fly"] = 41.97, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 23.63, ["Mega|Ride"] = 107.63, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 15.74, ["Ride"] = 15.75, ["Fly|Ride"] = 32.82, ["Neon"] = 2.1, ["Neon|Fly"] = 26.24, ["Neon|Ride"] = 18.89, ["Neon|Fly|Ride"] = 49.31, ["Mega"] = 39.37, ["Mega|Ride"] = 76.69, ["Mega|Fly|Ride"] = 114.62}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 415.09, ["Ride"] = 473.82, ["Fly|Ride"] = 524.99, ["Neon|Ride"] = 1818.85, ["Neon|Fly|Ride"] = 1802.84}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 13.06, ["Ride"] = 139.34, ["Neon"] = 45.94, ["Neon|Ride"] = 280.08, ["Neon|Fly|Ride"] = 398.61, ["Mega"] = 491.54, ["Mega|Ride"] = 497.2, ["Mega|Fly|Ride"] = 419.58}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 26.92, ["Ride"] = 17.07, ["Fly|Ride"] = 41.97, ["Neon"] = 6.57, ["Neon|Fly"] = 15.75, ["Neon|Ride"] = 20.99, ["Neon|Fly|Ride"] = 71.34, ["Mega"] = 113.87, ["Mega|Ride"] = 72.05, ["Mega|Fly|Ride"] = 103.69}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 78.75, ["Ride"] = 111.43, ["Fly|Ride"] = 315, ["Neon"] = 236.25, ["Neon|Ride"] = 277.99, ["Neon|Fly|Ride"] = 473.08, ["Mega"] = 997.54, ["Mega|Ride"] = 805.88, ["Mega|Fly|Ride"] = 958.73}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 45.12, ["Ride"] = 16.99, ["Fly|Ride"] = 39.17, ["Neon"] = 10.71, ["Neon|Fly"] = 90.22, ["Neon|Ride"] = 23.28, ["Neon|Fly|Ride"] = 103.85, ["Mega"] = 82.69, ["Mega|Ride"] = 131.54, ["Mega|Fly|Ride"] = 203.44}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Ride"] = 77.81, ["Fly|Ride"] = 1312.5, ["Neon"] = 2.1, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 283.5, ["Mega"] = 15.75, ["Mega|Ride"] = 83.99, ["Mega|Fly|Ride"] = 196.17}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 62.39, ["Ride"] = 98.61, ["Fly|Ride"] = 155.26, ["Neon"] = 174.39, ["Neon|Fly"] = 452.09, ["Neon|Ride"] = 280.08, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 637.88, ["Mega|Ride"] = 774.89, ["Mega|Fly|Ride"] = 780.94}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Neon"] = 8.4, ["Neon|Ride"] = 50.36, ["Mega"] = 62.75, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 40.68, ["Fly"] = 140.58, ["Ride"] = 67.36, ["Fly|Ride"] = 207.69, ["Neon"] = 157.36, ["Neon|Ride"] = 157.36, ["Neon|Fly|Ride"] = 278.83, ["Mega|Ride"] = 1678.29}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 6.2, ["Ride"] = 114.96, ["Neon"] = 57.75, ["Neon|Ride"] = 288.75, ["Mega"] = 170.63, ["Mega|Ride"] = 837.38, ["Mega|Fly|Ride"] = 486.29}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.1, ["Fly"] = 70.3, ["Ride"] = 70.3, ["Neon"] = 13.13, ["Neon|Fly"] = 62.95, ["Neon|Ride"] = 171.94, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 420, ["Mega|Ride"] = 569.63, ["Mega|Fly|Ride"] = 560.14}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 30.86, ["Ride"] = 49.31, ["Neon"] = 542.3, ["Mega|Ride"] = 2611.88, ["Mega|Fly|Ride"] = 1239.6}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 104.9, ["Ride"] = 89.25, ["Fly|Ride"] = 241.55, ["Neon"] = 5.97, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 138.48, ["Mega"] = 45.94, ["Mega|Fly"] = 158.61, ["Mega|Ride"] = 82.85, ["Mega|Fly|Ride"] = 271.87}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 46.47, ["Ride"] = 23.6, ["Fly|Ride"] = 72.17, ["Neon"] = 11.81, ["Neon|Fly"] = 41.88, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 108.06, ["Mega"] = 209.81, ["Mega|Fly|Ride"] = 282.85}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 8.59, ["Ride"] = 31.37, ["Neon"] = 111.57, ["Neon|Ride"] = 70.3, ["Neon|Fly|Ride"] = 111.55, ["Mega"] = 262.5, ["Mega|Ride"] = 452.09, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 31.49, ["Ride"] = 60.38, ["Fly|Ride"] = 131.25, ["Neon"] = 227.61, ["Neon|Ride"] = 194.25, ["Neon|Fly|Ride"] = 276.51, ["Mega"] = 510.56, ["Mega|Ride"] = 662.82, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 20.76, ["Fly"] = 30.17, ["Ride"] = 41.97, ["Fly|Ride"] = 76.13, ["Neon"] = 103.69, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 237.86, ["Mega"] = 407, ["Mega|Ride"] = 417.5, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 76.13, ["Fly"] = 196.88, ["Ride"] = 131.43, ["Fly|Ride"] = 279.45, ["Neon"] = 314.69, ["Neon|Ride"] = 385.88, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 1258.72, ["Mega|Ride"] = 1302, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 2.63, ["Ride"] = 23.63, ["Fly|Ride"] = 262.5, ["Neon"] = 17.07, ["Neon|Ride"] = 140.58, ["Neon|Fly|Ride"] = 314.7, ["Mega"] = 147.92, ["Mega|Ride"] = 155.69, ["Mega|Fly|Ride"] = 327.48}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 6.55, ["Ride"] = 39.87, ["Fly|Ride"] = 118.13, ["Neon"] = 12.47, ["Neon|Ride"] = 69.25, ["Mega"] = 151.05, ["Mega|Ride"] = 193.55}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 10.17, ["Fly"] = 65.63, ["Ride"] = 28.54, ["Fly|Ride"] = 157.5, ["Neon"] = 46.47, ["Neon|Ride"] = 125.89, ["Mega"] = 364.88, ["Mega|Ride"] = 699.65, ["Mega|Fly|Ride"] = 452.82}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 14.44, ["Fly|Ride"] = 31.49, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 14.84, ["Neon|Fly|Ride"] = 62.75, ["Mega"] = 21, ["Mega|Fly"] = 77.86, ["Mega|Ride"] = 24.13, ["Mega|Fly|Ride"] = 103.85}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 59.07, ["Fly"] = 220.5, ["Ride"] = 65.63, ["Neon"] = 371.61, ["Neon|Fly"] = 2377.92, ["Neon|Ride"] = 291.37, ["Neon|Fly|Ride"] = 418.69, ["Mega"] = 1147.53, ["Mega|Fly"] = 958.73, ["Mega|Ride"] = 891.19, ["Mega|Fly|Ride"] = 907.54}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 20.91, ["Fly|Ride"] = 89.24, ["Neon"] = 6.45, ["Neon|Ride"] = 52.5, ["Mega"] = 107.01, ["Mega|Fly"] = 112.25, ["Mega|Ride"] = 116.2, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 28.33, ["Ride"] = 31.5, ["Fly|Ride"] = 62.95, ["Neon"] = 22.56, ["Neon|Ride"] = 34.42, ["Neon|Fly|Ride"] = 98.61, ["Mega"] = 140.58, ["Mega|Ride"] = 209.81, ["Mega|Fly|Ride"] = 280.08}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 84, ["Fly"] = 209.81, ["Ride"] = 137.03, ["Neon"] = 196.88, ["Neon|Ride"] = 280.08, ["Neon|Fly|Ride"] = 576.92, ["Mega"] = 958.13, ["Mega|Ride"] = 912.19, ["Mega|Fly|Ride"] = 1010.63}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 34.84, ["Neon"] = 7.33, ["Neon|Ride"] = 140.58, ["Neon|Fly|Ride"] = 105.74, ["Mega"] = 48.49, ["Mega|Ride"] = 109.22, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 11.78}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 25.91, ["Fly|Ride"] = 209.47, ["Neon"] = 3.94, ["Neon|Ride"] = 36.72, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 41.97, ["Mega|Ride"] = 115.5, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 129.94, ["Ride"] = 280.08, ["Fly|Ride"] = 280.08, ["Neon"] = 587.41, ["Neon|Ride"] = 702.19, ["Neon|Fly|Ride"] = 734.26, ["Mega"] = 2168.14, ["Mega|Fly|Ride"] = 2493.75}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 2.1, ["Ride"] = 41.99, ["Neon"] = 18.38, ["Neon|Ride"] = 61.69, ["Mega"] = 280.08, ["Mega|Ride"] = 296.26, ["Mega|Fly|Ride"] = 368.19}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 209.81, ["Neon"] = 6.57, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 40.92, ["Mega|Ride"] = 77.64, ["Mega|Fly|Ride"] = 312.9}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 5.66, ["Ride"] = 23.24, ["Neon"] = 41.99, ["Neon|Ride"] = 140.58, ["Neon|Fly|Ride"] = 155.69, ["Mega"] = 853.13, ["Mega|Ride"] = 629.37, ["Mega|Fly|Ride"] = 350.36}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 17.07, ["Fly"] = 74.49, ["Ride"] = 23.44, ["Neon"] = 82.69, ["Neon|Ride"] = 98.61, ["Neon|Fly|Ride"] = 270.63, ["Mega"] = 187.69, ["Mega|Fly|Ride"] = 538.13}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 26.66, ["Ride"] = 65.63, ["Fly|Ride"] = 73.5, ["Neon"] = 138.6, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 266.13, ["Mega"] = 524.48, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 111.56, ["Fly"] = 222.94, ["Ride"] = 154.88, ["Fly|Ride"] = 157.5, ["Neon"] = 629.37, ["Neon|Ride"] = 548.63, ["Neon|Fly|Ride"] = 692.3, ["Mega|Fly|Ride"] = 3060.75}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 6.55, ["Fly"] = 18.38, ["Ride"] = 19.66, ["Fly|Ride"] = 32.59, ["Neon"] = 34.26, ["Neon|Ride"] = 35.68, ["Neon|Fly|Ride"] = 83.93, ["Mega"] = 419.58, ["Mega|Ride"] = 698.6, ["Mega|Fly|Ride"] = 360.94}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.1, ["Fly"] = 72.19, ["Ride"] = 23.63, ["Fly|Ride"] = 59.07, ["Neon"] = 18.83, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 137.09, ["Mega|Fly|Ride"] = 280.08}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 5.13, ["Fly"] = 232.23, ["Ride"] = 65.03, ["Fly|Ride"] = 65.63, ["Neon"] = 70.3, ["Neon|Ride"] = 91.88, ["Mega"] = 560.14, ["Mega|Fly|Ride"] = 433.1}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 35.18, ["Ride"] = 76.13, ["Fly|Ride"] = 112.25, ["Neon"] = 154.75, ["Neon|Ride"] = 187.69, ["Neon|Fly|Ride"] = 294, ["Mega"] = 603.75, ["Mega|Fly"] = 979.71, ["Mega|Ride"] = 734.26, ["Mega|Fly|Ride"] = 866.25}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 16.63, ["Fly"] = 65.63, ["Ride"] = 81.84, ["Neon"] = 131.25, ["Neon|Ride"] = 125.89, ["Mega"] = 656.25, ["Mega|Ride"] = 699.65, ["Mega|Fly|Ride"] = 524.48}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 238.11, ["Ride"] = 280.08, ["Fly|Ride"] = 459.38, ["Neon"] = 1256.62, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1258.72, ["Mega|Ride"] = 3937.5, ["Mega|Fly|Ride"] = 5662.09}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 19.69, ["Fly"] = 140.58, ["Ride"] = 41.99, ["Fly|Ride"] = 119.6, ["Neon"] = 280.08, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 209.92, ["Mega"] = 1195.69, ["Mega|Ride"] = 539.16, ["Mega|Fly|Ride"] = 699.65}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 28.33, ["Ride"] = 17.05, ["Fly|Ride"] = 37.78, ["Neon"] = 2.1, ["Neon|Ride"] = 17.45, ["Neon|Fly|Ride"] = 61.69, ["Mega"] = 30.22, ["Mega|Fly"] = 98.44, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 127.18}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 3.81, ["Ride"] = 59.07, ["Neon"] = 13.13, ["Neon|Ride"] = 39.37, ["Mega"] = 119.59, ["Mega|Ride"] = 322.04, ["Mega|Fly|Ride"] = 460.04}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 2.61, ["Ride"] = 102.37, ["Neon"] = 17.05, ["Neon|Ride"] = 77.86, ["Neon|Fly|Ride"] = 1181.25, ["Mega"] = 105.11, ["Mega|Fly"] = 280.08, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 392.44, ["Fly"] = 580.56, ["Ride"] = 393.75, ["Fly|Ride"] = 494.82, ["Neon"] = 1464.31, ["Neon|Ride"] = 1363.27, ["Neon|Fly|Ride"] = 1345.32, ["Mega|Fly|Ride"] = 5034.75}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.63, ["Fly"] = 70.3, ["Ride"] = 18.04, ["Fly|Ride"] = 46.17, ["Neon"] = 39.26, ["Neon|Ride"] = 69.57, ["Neon|Fly|Ride"] = 71.12, ["Mega"] = 249.38, ["Mega|Ride"] = 315.6, ["Mega|Fly|Ride"] = 464.71}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 6.57, ["Fly"] = 18.89, ["Ride"] = 19.58, ["Fly|Ride"] = 59.07, ["Neon|Ride"] = 46.47, ["Neon|Fly|Ride"] = 208.76, ["Mega"] = 418.52, ["Mega|Ride"] = 699.65, ["Mega|Fly|Ride"] = 839.15}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 4.82, ["Fly"] = 83.93, ["Ride"] = 27.28, ["Fly|Ride"] = 104.52, ["Neon"] = 13.11, ["Neon|Fly"] = 70.3, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 128.97, ["Mega"] = 140.58, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 417.5}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 47.45, ["Fly"] = 210, ["Fly|Ride"] = 90.22, ["Neon"] = 91.88, ["Neon|Ride"] = 125.89, ["Neon|Fly|Ride"] = 146.87, ["Mega|Ride"] = 845.25, ["Mega|Fly|Ride"] = 623.05}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 315, ["Ride"] = 63, ["Neon"] = 14.44, ["Neon|Ride"] = 77.86, ["Neon|Fly|Ride"] = 210, ["Mega|Fly|Ride"] = 600.48}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 6.45, ["Fly"] = 787.5, ["Ride"] = 36.73, ["Fly|Ride"] = 91.88, ["Neon"] = 310.06, ["Neon|Ride"] = 135.53, ["Mega"] = 699.65, ["Mega|Ride"] = 320.99, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 60.85, ["Neon"] = 3.93, ["Mega"] = 85.32, ["Mega|Ride"] = 2558.33, ["Mega|Fly|Ride"] = 231.21}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 11.78, ["Neon"] = 89.25, ["Mega"] = 195.12, ["Mega|Ride"] = 338.63, ["Mega|Fly|Ride"] = 629.37}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 9.85, ["Ride"] = 70.3, ["Fly|Ride"] = 140.58, ["Neon"] = 119.62, ["Neon|Fly|Ride"] = 209.81, ["Mega"] = 293.71, ["Mega|Ride"] = 280.18, ["Mega|Fly|Ride"] = 1048.93}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 18.38, ["Fly"] = 36.69, ["Ride"] = 24.13, ["Fly|Ride"] = 52.12, ["Neon"] = 54.58, ["Neon|Ride"] = 69.25, ["Neon|Fly|Ride"] = 108.3, ["Mega"] = 589.51, ["Mega|Ride"] = 708.37, ["Mega|Fly|Ride"] = 471.98}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 203.44, ["Fly"] = 224.48, ["Ride"] = 225.8, ["Fly|Ride"] = 260.39, ["Neon"] = 946.15, ["Neon|Ride"] = 928.99, ["Neon|Fly|Ride"] = 850.08, ["Mega|Fly|Ride"] = 4194.65}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Fly"] = 21.2, ["Ride"] = 18.38, ["Fly|Ride"] = 65.04, ["Neon"] = 83.93, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 106.98, ["Mega"] = 209.81, ["Mega|Ride"] = 322.04, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 3.24, ["Fly"] = 32.82, ["Ride"] = 23.63, ["Fly|Ride"] = 77.7, ["Neon"] = 17.33, ["Neon|Ride"] = 56.65, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 131.25, ["Mega|Ride"] = 774.89, ["Mega|Fly|Ride"] = 410.82}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 45.94, ["Ride"] = 101.55, ["Fly|Ride"] = 216.57, ["Neon"] = 195.57, ["Neon|Ride"] = 229.37, ["Neon|Fly|Ride"] = 560.14, ["Mega"] = 404.25, ["Mega|Ride"] = 378, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 56.44, ["Fly"] = 59.07, ["Ride"] = 98.6, ["Fly|Ride"] = 172.5, ["Neon"] = 268.74, ["Neon|Ride"] = 435.31, ["Neon|Fly|Ride"] = 464.08, ["Mega"] = 1362.57, ["Mega|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 1315.36}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 22.3, ["Ride"] = 69.25, ["Fly|Ride"] = 65.63, ["Neon"] = 85.4, ["Neon|Ride"] = 112.2, ["Neon|Fly|Ride"] = 280.08, ["Mega"] = 188.99, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 329.18}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 23.08, ["Fly|Ride"] = 39.38, ["Neon"] = 12.6, ["Neon|Fly|Ride"] = 121.69, ["Mega"] = 124.32, ["Mega|Fly|Ride"] = 252}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 11.82, ["Ride"] = 90.22, ["Fly|Ride"] = 45.94, ["Neon"] = 60.38, ["Neon|Fly"] = 112.25, ["Neon|Ride"] = 138.47, ["Neon|Fly|Ride"] = 419.58, ["Mega|Ride"] = 277.15, ["Mega|Fly|Ride"] = 423.83}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 69.49, ["Ride"] = 137.82, ["Fly|Ride"] = 262.5, ["Neon"] = 196.88, ["Neon|Ride"] = 283.5, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 570.94, ["Mega|Ride"] = 496.1, ["Mega|Fly|Ride"] = 511.22}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.1, ["Ride"] = 28.33, ["Neon"] = 6.57, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 35.44, ["Mega|Fly"] = 98.44, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 219.19}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 10.23, ["Ride"] = 288.75, ["Fly|Ride"] = 398.61, ["Neon"] = 35.68, ["Neon|Ride"] = 564.38, ["Mega"] = 291.38, ["Mega|Fly|Ride"] = 523.43}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 1046.05, ["Fly"] = 1238.89, ["Ride"] = 1050, ["Fly|Ride"] = 1047.37, ["Neon"] = 3314.59, ["Neon|Fly|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 27.4, ["Ride"] = 96.51, ["Fly|Ride"] = 310.06, ["Neon"] = 140.58, ["Neon|Ride"] = 165.74, ["Mega"] = 489.86, ["Mega|Ride"] = 526.32, ["Mega|Fly|Ride"] = 712.14}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 3.94, ["Fly"] = 49.88, ["Ride"] = 28.7, ["Fly|Ride"] = 208.76, ["Neon"] = 17.35, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 108.06, ["Mega"] = 87.94, ["Mega|Ride"] = 98.44, ["Mega|Fly|Ride"] = 250.69}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 13.6, ["Ride"] = 131.22, ["Neon"] = 109.16, ["Mega|Ride"] = 350.36, ["Mega|Fly|Ride"] = 699.65}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 49.31, ["Fly|Ride"] = 419.58, ["Neon"] = 2.1, ["Neon|Ride"] = 36.23, ["Neon|Fly|Ride"] = 109.22, ["Mega"] = 16.96, ["Mega|Ride"] = 45.94, ["Mega|Fly|Ride"] = 151.05}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 89.25, ["Ride"] = 189.79, ["Neon"] = 336, ["Neon|Ride"] = 402.94, ["Neon|Fly|Ride"] = 438.38, ["Mega"] = 1312.5, ["Mega|Ride"] = 1036.88, ["Mega|Fly|Ride"] = 1245.57}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 6.02, ["Fly"] = 101.07, ["Ride"] = 45.29, ["Fly|Ride"] = 812.78, ["Neon"] = 24.13, ["Neon|Ride"] = 84, ["Mega"] = 314.7, ["Mega|Ride"] = 252.27, ["Mega|Fly|Ride"] = 322.04}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2.1, ["Ride"] = 28.95, ["Neon"] = 12.32, ["Neon|Ride"] = 39.38, ["Mega"] = 170.63, ["Mega|Ride"] = 276.92, ["Mega|Fly|Ride"] = 388.04}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 56.44, ["Fly"] = 98.61, ["Ride"] = 52.5, ["Fly|Ride"] = 130.3, ["Neon"] = 195.09, ["Neon|Ride"] = 169.45, ["Neon|Fly|Ride"] = 341.96, ["Mega"] = 528.67, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 450.19}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 13.27, ["Fly"] = 183.75, ["Ride"] = 63, ["Neon"] = 85.32, ["Neon|Fly"] = 178.34, ["Neon|Ride"] = 240.19, ["Neon|Fly|Ride"] = 203.44, ["Mega"] = 393.75, ["Mega|Ride"] = 690.1, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 72.07, ["Ride"] = 280.08, ["Neon"] = 315, ["Neon|Ride"] = 448.95, ["Neon|Fly|Ride"] = 911.54, ["Mega"] = 1468.5, ["Mega|Ride"] = 1394.12, ["Mega|Fly|Ride"] = 1245.08}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 7.2, ["Ride"] = 46.47, ["Fly|Ride"] = 167.84, ["Neon"] = 26.72, ["Neon|Ride"] = 95.8, ["Neon|Fly|Ride"] = 155.69, ["Mega"] = 140.44, ["Mega|Ride"] = 105.98, ["Mega|Fly|Ride"] = 249.66}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 7.88, ["Fly"] = 196.88, ["Ride"] = 18.36, ["Fly|Ride"] = 70.3, ["Neon"] = 62.97, ["Neon|Ride"] = 79.73, ["Neon|Fly|Ride"] = 275.89, ["Mega"] = 354.37, ["Mega|Ride"] = 380.63, ["Mega|Fly|Ride"] = 446.13}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 137.82, ["Ride"] = 197.4, ["Fly|Ride"] = 236.25, ["Neon"] = 472.03, ["Neon|Fly"] = 450.56, ["Neon|Ride"] = 516.08, ["Neon|Fly|Ride"] = 589.02, ["Mega"] = 2362.5, ["Mega|Ride"] = 2084.21, ["Mega|Fly|Ride"] = 1836.19}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 19.94, ["Fly|Ride"] = 105000, ["Neon"] = 18.88, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 180.44, ["Mega|Ride"] = 136.5, ["Mega|Fly|Ride"] = 149.63}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 6.45, ["Fly"] = 41.97, ["Ride"] = 15.75, ["Fly|Ride"] = 39.38, ["Neon"] = 18.38, ["Neon|Ride"] = 45.32, ["Neon|Fly|Ride"] = 95.46, ["Mega"] = 220.5, ["Mega|Ride"] = 209.81, ["Mega|Fly|Ride"] = 278.83}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 28.33, ["Ride"] = 18.89, ["Fly|Ride"] = 36.72, ["Neon"] = 2.1, ["Neon|Fly"] = 22.09, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 49.97, ["Mega"] = 14.95, ["Mega|Ride"] = 36.75, ["Mega|Fly|Ride"] = 64.32}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 31.49, ["Neon"] = 3.93, ["Neon|Ride"] = 41.97, ["Mega"] = 18.32, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 155.69}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.61, ["Fly"] = 131.54, ["Ride"] = 42, ["Neon"] = 38.06, ["Neon|Ride"] = 63.67, ["Mega"] = 131.25, ["Mega|Ride"] = 207.69}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 103.69, ["Ride"] = 315, ["Neon"] = 522.38, ["Neon|Ride"] = 452.82, ["Neon|Fly|Ride"] = 630, ["Mega"] = 526.58, ["Mega|Fly|Ride"] = 515.03}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 3.07, ["Fly"] = 21.66, ["Ride"] = 16.99, ["Fly|Ride"] = 38.62, ["Neon"] = 15.74, ["Neon|Fly"] = 25.72, ["Neon|Ride"] = 31.38, ["Neon|Fly|Ride"] = 77.44, ["Mega"] = 131.54, ["Mega|Fly"] = 209.81, ["Mega|Ride"] = 152.25, ["Mega|Fly|Ride"] = 181.13}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 5.34, ["Fly"] = 36.75, ["Ride"] = 26.24, ["Fly|Ride"] = 77.44, ["Neon"] = 12.65, ["Neon|Fly"] = 46.47, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 77.44, ["Mega"] = 137.16, ["Mega|Fly"] = 220.29, ["Mega|Ride"] = 125.89, ["Mega|Fly|Ride"] = 234.21}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 3.94, ["Ride"] = 24.94, ["Fly|Ride"] = 72.19, ["Neon"] = 7.88, ["Neon|Fly"] = 98.44, ["Neon|Ride"] = 34.84, ["Neon|Fly|Ride"] = 106.32, ["Mega"] = 127.23, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 11.69, ["Ride"] = 131.25, ["Neon"] = 26.24, ["Neon|Ride"] = 112.25, ["Neon|Fly|Ride"] = 178.92, ["Mega"] = 237.02, ["Mega|Ride"] = 299.92, ["Mega|Fly|Ride"] = 419.58}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 5.24, ["Fly"] = 146.87, ["Neon"] = 98.44, ["Neon|Ride"] = 262.5, ["Mega"] = 420, ["Mega|Ride"] = 412.13, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 4.46, ["Fly"] = 91.88, ["Ride"] = 28.09, ["Fly|Ride"] = 139.31, ["Neon"] = 18.31, ["Neon|Fly"] = 196.65, ["Neon|Ride"] = 62.71, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 196.17, ["Mega|Fly"] = 175.19, ["Mega|Ride"] = 195.96, ["Mega|Fly|Ride"] = 318.89}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 16.86, ["Fly|Ride"] = 49.31, ["Neon"] = 10.48, ["Neon|Fly"] = 85.95, ["Neon|Ride"] = 50.36, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 419.58, ["Mega|Ride"] = 155.69, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 183.75, ["Fly"] = 393.75, ["Ride"] = 251.11, ["Fly|Ride"] = 359.99, ["Neon"] = 903, ["Neon|Ride"] = 924.11, ["Neon|Fly|Ride"] = 892.5, ["Mega"] = 5594.95, ["Mega|Fly|Ride"] = 3661.88}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 3.82, ["Ride"] = 42, ["Neon"] = 26.25, ["Neon|Fly|Ride"] = 280.08, ["Mega"] = 155.26, ["Mega|Ride"] = 267.49, ["Mega|Fly|Ride"] = 979.71}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 3.03, ["Fly"] = 32.82, ["Ride"] = 27.28, ["Fly|Ride"] = 96.51, ["Neon"] = 31.43, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 139.65, ["Mega"] = 203.44, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 314.7}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 9.06, ["Fly|Ride"] = 155.63, ["Neon"] = 40.92, ["Neon|Fly|Ride"] = 629.37, ["Mega"] = 414.33, ["Mega|Ride"] = 335.67, ["Mega|Fly|Ride"] = 419.58}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 16.79, ["Fly|Ride"] = 39.38, ["Neon"] = 2.1, ["Neon|Fly"] = 28.76, ["Neon|Ride"] = 22.11, ["Neon|Fly|Ride"] = 50.36, ["Mega"] = 15.73, ["Mega|Fly|Ride"] = 73.5}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.1, ["Fly"] = 56.44, ["Ride"] = 26.25, ["Fly|Ride"] = 44.63, ["Neon"] = 23.24, ["Neon|Fly"] = 15.75, ["Neon|Ride"] = 37.77, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 209.12, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 155.69}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 4.28, ["Ride"] = 65.63, ["Neon"] = 11.8, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 112.25, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 450.19}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 68.25, ["Fly"] = 130.08, ["Ride"] = 103.5, ["Fly|Ride"] = 148.44, ["Neon"] = 393.75, ["Neon|Ride"] = 463.32, ["Neon|Fly|Ride"] = 408.19, ["Mega|Ride"] = 3498.16, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 3.76, ["Fly"] = 85.32, ["Ride"] = 52.49, ["Fly|Ride"] = 65.54, ["Neon"] = 16.79, ["Neon|Ride"] = 62.95, ["Neon|Fly|Ride"] = 310.21, ["Mega"] = 283.5, ["Mega|Ride"] = 185.9}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Ride"] = 56.65, ["Fly|Ride"] = 155.26, ["Neon"] = 5.8, ["Neon|Ride"] = 177.07, ["Neon|Fly|Ride"] = 521.63, ["Mega"] = 66.94, ["Mega|Fly"] = 409.1, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 209.81}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 52.49, ["Fly"] = 174.18, ["Ride"] = 110.25, ["Fly|Ride"] = 225.29, ["Neon"] = 165.83, ["Neon|Fly"] = 293.71, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 291.37, ["Mega"] = 580.11, ["Mega|Ride"] = 519.75, ["Mega|Fly|Ride"] = 649.69}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 16.79, ["Fly|Ride"] = 81.82, ["Neon"] = 2.1, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 16.57, ["Neon|Fly|Ride"] = 43.31, ["Mega"] = 15.75, ["Mega|Ride"] = 41.99, ["Mega|Fly|Ride"] = 86.56}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Neon"] = 3.24, ["Neon|Ride"] = 61.9, ["Neon|Fly|Ride"] = 140.58, ["Mega"] = 20.99, ["Mega|Fly"] = 131.25, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.63, ["Ride"] = 70.08, ["Neon"] = 8.45, ["Neon|Ride"] = 31.38, ["Neon|Fly|Ride"] = 140.58, ["Mega"] = 69.49, ["Mega|Ride"] = 127.93, ["Mega|Fly|Ride"] = 444.96}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 4.66, ["Fly"] = 82.69, ["Ride"] = 46.47, ["Fly|Ride"] = 125.08, ["Neon"] = 20.93, ["Neon|Fly"] = 83.93, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 137.82, ["Mega"] = 125.97, ["Mega|Fly"] = 139.42, ["Mega|Ride"] = 124.63, ["Mega|Fly|Ride"] = 278.31}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 15.7, ["Fly|Ride"] = 91.34, ["Neon"] = 2.1, ["Neon|Fly"] = 23.09, ["Neon|Ride"] = 30.18, ["Neon|Fly|Ride"] = 74.82, ["Mega"] = 15.74, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 35.44, ["Mega|Fly|Ride"] = 125.89}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 13.13, ["Ride"] = 42, ["Neon"] = 52.47, ["Neon|Fly|Ride"] = 176.54, ["Mega"] = 405.95, ["Mega|Ride"] = 417.5, ["Mega|Fly|Ride"] = 389.17}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 3160.82, ["Ride"] = 3176.25, ["Fly|Ride"] = 3562.13, ["Neon|Fly|Ride"] = 10500, ["Mega|Fly|Ride"] = 34964.68}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 28.32, ["Ride"] = 17.05, ["Fly|Ride"] = 50.35, ["Neon"] = 6.54, ["Neon|Fly"] = 69.22, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 66.94, ["Mega"] = 78.75, ["Mega|Ride"] = 98.76, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 3.67, ["Ride"] = 39.38, ["Neon"] = 12.44, ["Mega"] = 131.25, ["Mega|Ride"] = 419.58, ["Mega|Fly|Ride"] = 165.74}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 19.3, ["Ride"] = 30.18, ["Fly|Ride"] = 157.5, ["Neon"] = 66.62, ["Neon|Ride"] = 121.69, ["Neon|Fly|Ride"] = 280.08, ["Mega"] = 1048.93, ["Mega|Ride"] = 324.18, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 51.16, ["Ride"] = 125.89, ["Fly|Ride"] = 105, ["Neon"] = 324.86, ["Neon|Fly|Ride"] = 419.58, ["Mega"] = 486.72, ["Mega|Ride"] = 623.44, ["Mega|Fly|Ride"] = 615.72}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 153.54, ["Fly"] = 209.81, ["Ride"] = 181.13, ["Fly|Ride"] = 231.3, ["Neon"] = 696.73, ["Neon|Ride"] = 774.38, ["Neon|Fly|Ride"] = 797.19, ["Mega"] = 6293.53, ["Mega|Ride"] = 3007.27, ["Mega|Fly|Ride"] = 3539.07}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 18.59, ["Ride"] = 26.25, ["Fly|Ride"] = 112.25, ["Neon"] = 23.09, ["Neon|Ride"] = 124.26, ["Neon|Fly|Ride"] = 104.91, ["Mega"] = 800.63, ["Mega|Fly|Ride"] = 253.32}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 62.95, ["Neon"] = 16.51, ["Neon|Fly"] = 94.42, ["Neon|Ride"] = 34.13, ["Mega"] = 89.99, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 819}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.63, ["Fly"] = 101.99, ["Ride"] = 69.65, ["Fly|Ride"] = 78.75, ["Neon"] = 8.14, ["Neon|Ride"] = 39.48, ["Mega"] = 79.33, ["Mega|Ride"] = 142.67, ["Mega|Fly|Ride"] = 287.44}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 12.63, ["Neon"] = 109.16, ["Neon|Ride"] = 171.87, ["Mega"] = 393.75, ["Mega|Ride"] = 279.03, ["Mega|Fly|Ride"] = 607.04}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 69.78, ["Neon"] = 2.1, ["Neon|Ride"] = 41.97, ["Mega"] = 15.73, ["Mega|Ride"] = 133.88, ["Mega|Fly|Ride"] = 350.36}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 83.39, ["Fly"] = 342.55, ["Fly|Ride"] = 167.83, ["Neon"] = 280.08, ["Neon|Ride"] = 312.38, ["Neon|Fly|Ride"] = 455.44, ["Mega|Fly|Ride"] = 1609.06}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 32.52, ["Neon"] = 6.34, ["Mega"] = 98.61, ["Mega|Ride"] = 137.82}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 43.32, ["Ride"] = 99.64, ["Neon"] = 265.91, ["Neon|Ride"] = 390.22, ["Neon|Fly|Ride"] = 419.58, ["Mega"] = 2625, ["Mega|Ride"] = 2797.49, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 23.09, ["Fly|Ride"] = 70.3, ["Neon"] = 4.97, ["Neon|Ride"] = 91.8, ["Mega"] = 52.5, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 210.67}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Neon"] = 11.82, ["Mega"] = 70.88, ["Mega|Ride"] = 178.52, ["Mega|Fly|Ride"] = 334.69}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 6.55, ["Ride"] = 48.25, ["Fly|Ride"] = 157.5, ["Neon"] = 45.61, ["Neon|Fly"] = 291.38, ["Neon|Ride"] = 78.75, ["Mega"] = 155.26, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 452.82}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 398.05, ["Ride"] = 414.75, ["Fly|Ride"] = 496.13, ["Neon"] = 1047.38, ["Neon|Ride"] = 1115.63, ["Neon|Fly|Ride"] = 1177.32, ["Mega"] = 3917.73, ["Mega|Ride"] = 3018.75, ["Mega|Fly|Ride"] = 2887.5}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 31.49, ["Fly"] = 70.3, ["Ride"] = 52.5, ["Fly|Ride"] = 103.69, ["Neon"] = 181.12, ["Neon|Fly"] = 310.06, ["Neon|Ride"] = 186.38, ["Neon|Fly|Ride"] = 310.21, ["Mega|Ride"] = 713.33, ["Mega|Fly|Ride"] = 905.63}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Ride"] = 19.95, ["Neon"] = 5.25, ["Neon|Fly"] = 136.37, ["Neon|Ride"] = 23.97, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 53, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 280.08}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 11, ["Fly"] = 109.59, ["Ride"] = 31.37, ["Fly|Ride"] = 89.12, ["Neon"] = 33.64, ["Neon|Fly"] = 140.58, ["Neon|Ride"] = 65.19, ["Neon|Fly|Ride"] = 104.99, ["Mega"] = 173.25, ["Mega|Fly"] = 371.69, ["Mega|Ride"] = 282, ["Mega|Fly|Ride"] = 323.09}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 6.57, ["Ride"] = 25.96, ["Fly|Ride"] = 104.91, ["Neon"] = 105, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 137.42, ["Mega"] = 377.63, ["Mega|Ride"] = 377.63, ["Mega|Fly|Ride"] = 476.22}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 2.41, ["Neon"] = 15.72, ["Mega"] = 36.72, ["Mega|Ride"] = 140.65, ["Mega|Fly|Ride"] = 188.83}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.1, ["Fly"] = 86.63, ["Ride"] = 20.11, ["Fly|Ride"] = 78.75, ["Neon"] = 46.47, ["Neon|Ride"] = 41.97, ["Neon|Fly|Ride"] = 280.08, ["Mega"] = 542.55, ["Mega|Ride"] = 322.04}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 105.94, ["Ride"] = 150.94, ["Fly|Ride"] = 210, ["Neon"] = 734.26, ["Neon|Ride"] = 628.68, ["Neon|Fly|Ride"] = 670.28, ["Mega|Ride"] = 2412.54, ["Mega|Fly|Ride"] = 2296.88}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 20.97, ["Ride"] = 78.75, ["Fly|Ride"] = 144, ["Neon"] = 56.65, ["Neon|Ride"] = 280.08, ["Mega"] = 590.63, ["Mega|Ride"] = 706.99, ["Mega|Fly|Ride"] = 708.37}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2625, ["Ride"] = 3323.04, ["Fly|Ride"] = 2690.63, ["Neon"] = 12587.04, ["Neon|Ride"] = 7899.91, ["Neon|Fly|Ride"] = 5760.56, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 2.1, ["Fly"] = 65625, ["Ride"] = 22.32, ["Fly|Ride"] = 170.63, ["Neon"] = 11.82, ["Neon|Ride"] = 35.68, ["Mega"] = 61.84, ["Mega|Ride"] = 159.43, ["Mega|Fly|Ride"] = 422.63}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 13.11, ["Ride"] = 52.5, ["Fly|Ride"] = 280.08, ["Neon"] = 59.07, ["Neon|Ride"] = 140.58, ["Neon|Fly|Ride"] = 140.58, ["Mega"] = 156.19, ["Mega|Ride"] = 260.15, ["Mega|Fly|Ride"] = 419.57}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 1050, ["Fly"] = 1253.99, ["Ride"] = 984.38, ["Fly|Ride"] = 1036.88, ["Neon"] = 4039.4, ["Neon|Ride"] = 3636.62, ["Neon|Fly|Ride"] = 3005.63, ["Mega|Ride"] = 15883.8, ["Mega|Fly|Ride"] = 12337.5}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 39.38, ["Neon"] = 209.36, ["Mega|Ride"] = 1394.12, ["Mega|Fly|Ride"] = 945}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 4.54, ["Ride"] = 35.44, ["Fly|Ride"] = 52.5, ["Neon"] = 13.95, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 249.38, ["Mega|Fly|Ride"] = 305.17}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly|Ride"] = 52.5, ["Neon"] = 3.89, ["Mega"] = 24.94, ["Mega|Ride"] = 68.25, ["Mega|Fly|Ride"] = 119.59}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 82.69, ["Ride"] = 156.19, ["Fly|Ride"] = 656.25, ["Neon"] = 699.65, ["Neon|Ride"] = 406.04, ["Mega"] = 5250, ["Mega|Fly|Ride"] = 2517.42}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 7.28, ["Ride"] = 140.48, ["Neon"] = 36.03, ["Neon|Ride"] = 46.49, ["Mega"] = 141.75, ["Mega|Ride"] = 419.58, ["Mega|Fly|Ride"] = 263.82}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 127.04, ["Ride"] = 209.81, ["Neon"] = 603.75, ["Mega"] = 2097.85, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 6.6, ["Fly"] = 105, ["Neon"] = 31.37, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 315, ["Mega"] = 224.44}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 261.18, ["Ride"] = 286.13, ["Fly|Ride"] = 398.61, ["Neon|Ride"] = 944.05, ["Neon|Fly|Ride"] = 787.5, ["Mega|Fly|Ride"] = 4007.93}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 3.66, ["Fly"] = 91.88, ["Ride"] = 23.63, ["Fly|Ride"] = 41.97, ["Neon"] = 15.75, ["Neon|Ride"] = 45.89, ["Neon|Fly|Ride"] = 116.82, ["Mega"] = 250.04, ["Mega|Ride"] = 279.03, ["Mega|Fly|Ride"] = 350.44}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 13.13, ["Fly|Ride"] = 36.75, ["Neon"] = 2.63, ["Neon|Fly"] = 39.11, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 56.65, ["Mega"] = 28.33, ["Mega|Ride"] = 49.31, ["Mega|Fly|Ride"] = 112.25}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 859.69, ["Ride"] = 901.69, ["Fly|Ride"] = 951.56, ["Neon|Ride"] = 3890.07, ["Neon|Fly|Ride"] = 3566.34, ["Mega"] = 27882, ["Mega|Fly|Ride"] = 27971.54}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 9.11, ["Fly"] = 980.19, ["Ride"] = 40.69, ["Neon"] = 45.83, ["Mega"] = 150.94, ["Mega|Ride"] = 207.69, ["Mega|Fly|Ride"] = 412.79}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 5.25, ["Ride"] = 41.97, ["Fly|Ride"] = 52.5, ["Neon"] = 27.57, ["Neon|Fly"] = 75.54, ["Neon|Ride"] = 60.38, ["Neon|Fly|Ride"] = 140.58, ["Mega"] = 174.57, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 331.8}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 42, ["Fly"] = 65.61, ["Ride"] = 31.5, ["Fly|Ride"] = 65.63, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 162.75, ["Mega"] = 2071.63, ["Mega|Fly|Ride"] = 856.91}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 13.73, ["Fly"] = 78.69, ["Ride"] = 35.33, ["Fly|Ride"] = 69.68, ["Neon"] = 78.69, ["Neon|Ride"] = 82.89, ["Neon|Fly|Ride"] = 185.9, ["Mega"] = 560.14, ["Mega|Ride"] = 735, ["Mega|Fly|Ride"] = 442.31}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 26.23, ["Ride"] = 28.33, ["Fly|Ride"] = 636.57, ["Neon"] = 91.88, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 435.31, ["Mega|Ride"] = 494.82, ["Mega|Fly|Ride"] = 453.15}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Fly"] = 48.26, ["Ride"] = 105, ["Neon"] = 2.1, ["Neon|Ride"] = 91.75, ["Mega"] = 8.4, ["Mega|Ride"] = 89.25}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 32.54, ["Fly"] = 56.65, ["Ride"] = 51.18, ["Fly|Ride"] = 94.42, ["Neon"] = 141.63, ["Neon|Fly"] = 310.21, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 209.82, ["Mega"] = 3356.56, ["Mega|Fly|Ride"] = 1029.13}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 3.59, ["Fly"] = 133.54, ["Ride"] = 26.25, ["Fly|Ride"] = 127.32, ["Neon|Ride"] = 141.07, ["Mega"] = 773.07, ["Mega|Ride"] = 271.69}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 25.18, ["Ride"] = 18.38, ["Fly|Ride"] = 70.3, ["Neon"] = 39.38, ["Neon|Fly|Ride"] = 62.75, ["Mega"] = 1036.34, ["Mega|Ride"] = 266.44, ["Mega|Fly|Ride"] = 202.13}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 3.92, ["Neon"] = 105, ["Mega"] = 229.69, ["Mega|Ride"] = 196.88}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 22.25, ["Fly"] = 262.5, ["Ride"] = 39.38, ["Fly|Ride"] = 83.93, ["Neon"] = 104.61, ["Neon|Ride"] = 116.1, ["Neon|Fly|Ride"] = 209.81, ["Mega"] = 1090.89, ["Mega|Ride"] = 993.35, ["Mega|Fly|Ride"] = 774.89}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 8.54, ["Neon"] = 22.32, ["Neon|Ride"] = 39.38, ["Mega"] = 84.76, ["Mega|Fly|Ride"] = 310.21}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 27.18, ["Neon"] = 2.1, ["Neon|Ride"] = 65.63, ["Mega"] = 15.74, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 198.85}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Ride"] = 26.13, ["Neon"] = 2.1, ["Neon|Fly"] = 393.65, ["Neon|Ride"] = 33.33, ["Mega"] = 18.38, ["Mega|Ride"] = 70.3, ["Mega|Fly|Ride"] = 119.44}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 31.49, ["Ride"] = 20.98, ["Fly|Ride"] = 56.65, ["Neon"] = 6.56, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 25.18, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 86.63, ["Mega|Ride"] = 140.58, ["Mega|Fly|Ride"] = 178.5}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 5225.47, ["Neon"] = 57.75, ["Neon|Ride"] = 1312.5, ["Mega"] = 140.58, ["Mega|Ride"] = 158.33}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 39.87, ["Ride"] = 16.78, ["Fly|Ride"] = 72.19, ["Neon"] = 22.31, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 486.29, ["Mega|Ride"] = 232.87, ["Mega|Fly|Ride"] = 363.57}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 62.85, ["Fly|Ride"] = 392.32, ["Neon"] = 251.76, ["Neon|Ride"] = 314.7, ["Neon|Fly|Ride"] = 322.04, ["Mega"] = 699.65, ["Mega|Fly"] = 839.15, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 746.05}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 26.23, ["Ride"] = 17.07, ["Fly|Ride"] = 36.02, ["Neon"] = 3.81, ["Neon|Fly"] = 72.19, ["Neon|Ride"] = 23.29, ["Neon|Fly|Ride"] = 51.19, ["Mega"] = 39.37, ["Mega|Ride"] = 56.65, ["Mega|Fly|Ride"] = 130.54}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 9.49, ["Fly"] = 65.63, ["Ride"] = 34.13, ["Fly|Ride"] = 80.07, ["Neon"] = 41.97, ["Neon|Fly"] = 54.58, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 524.99, ["Mega|Ride"] = 280.08, ["Mega|Fly|Ride"] = 347.82}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 7.86, ["Fly"] = 52.5, ["Ride"] = 24.81, ["Fly|Ride"] = 65.63, ["Neon"] = 77.64, ["Neon|Ride"] = 90.59, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 1021.67, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 419.58}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 3.29, ["Fly"] = 140.38, ["Ride"] = 46.4, ["Neon"] = 17.07, ["Neon|Ride"] = 70.3, ["Mega"] = 150.94, ["Mega|Ride"] = 238.11}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 15.74, ["Fly|Ride"] = 70.3, ["Neon"] = 3.94, ["Neon|Fly"] = 81.38, ["Neon|Ride"] = 23.6, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 40.69, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 61.46, ["Mega|Fly|Ride"] = 152.25}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 3.68, ["Ride"] = 27.57, ["Neon"] = 14.3, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 209.81, ["Mega"] = 155.69, ["Mega|Fly"] = 735, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 372.38}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 1042.36, ["Fly"] = 1261.87, ["Ride"] = 1048.69, ["Fly|Ride"] = 1036.88, ["Neon"] = 2942.51, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2098.68, ["Mega|Fly|Ride"] = 7428.75}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 72.19, ["Ride"] = 102.8, ["Fly|Ride"] = 140.44, ["Neon"] = 196.88, ["Neon|Ride"] = 250.69, ["Mega"] = 3145.73, ["Mega|Ride"] = 1258.72, ["Mega|Fly|Ride"] = 1160.25}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Fly"] = 62.95, ["Ride"] = 70.3, ["Neon"] = 9.24, ["Neon|Ride"] = 74.49, ["Neon|Fly|Ride"] = 315, ["Mega"] = 83.69, ["Mega|Ride"] = 393.75}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 39.04, ["Ride"] = 56.44, ["Fly|Ride"] = 262.5, ["Neon"] = 146.87, ["Neon|Ride"] = 202.06, ["Neon|Fly|Ride"] = 300.57, ["Mega"] = 944.05, ["Mega|Ride"] = 746.82, ["Mega|Fly|Ride"] = 940.89}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 5.23, ["Ride"] = 26.25, ["Neon"] = 46.81, ["Neon|Ride"] = 131.25, ["Mega"] = 376.69, ["Mega|Ride"] = 140.58, ["Mega|Fly|Ride"] = 1048.93}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 363.99, ["Fly"] = 928.73, ["Ride"] = 354.38, ["Fly|Ride"] = 282.19, ["Neon|Ride"] = 1273.13, ["Neon|Fly|Ride"] = 1430.75, ["Mega|Fly|Ride"] = 4462.5}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 102.38, ["Ride"] = 22.32, ["Fly|Ride"] = 129.93, ["Neon"] = 14.44, ["Mega"] = 393.75, ["Mega|Fly"] = 280.08}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Neon"] = 104.97, ["Neon|Ride"] = 140.58}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 39.11, ["Ride"] = 103.69, ["Fly|Ride"] = 209.81, ["Neon"] = 161.61, ["Neon|Ride"] = 309.44, ["Mega"] = 699.65, ["Mega|Ride"] = 981.1, ["Mega|Fly|Ride"] = 733.22}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 70.86, ["Fly|Ride"] = 140.58, ["Neon"] = 15.75, ["Mega"] = 178.34, ["Mega|Ride"] = 229.72, ["Mega|Fly|Ride"] = 419.58}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 23.63, ["Ride"] = 15.74, ["Fly|Ride"] = 32.82, ["Neon"] = 3.5, ["Neon|Fly"] = 31.18, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 40.69, ["Mega"] = 18.89, ["Mega|Ride"] = 40.69, ["Mega|Fly|Ride"] = 99.65}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 3933.57, ["Ride"] = 3937.5, ["Fly|Ride"] = 4198.69, ["Neon"] = 25174.07, ["Neon|Fly|Ride"] = 19163.82, ["Mega|Fly|Ride"] = 78458.1}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 11.79, ["Ride"] = 56.44, ["Neon"] = 47.25, ["Neon|Ride"] = 44.63, ["Mega"] = 262.5, ["Mega|Ride"] = 351.41, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.43, ["Ride"] = 25.13, ["Fly|Ride"] = 54.51, ["Neon"] = 15.73, ["Neon|Fly"] = 46.47, ["Neon|Ride"] = 33.45, ["Neon|Fly|Ride"] = 105.02, ["Mega"] = 283.23, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 207.64}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 413.44, ["Fly"] = 840, ["Ride"] = 460.35, ["Fly|Ride"] = 478.1, ["Neon"] = 1678.29, ["Neon|Ride"] = 1539.78, ["Neon|Fly|Ride"] = 1278.38, ["Mega|Fly|Ride"] = 5514.85}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 4.25, ["Ride"] = 31.5, ["Neon"] = 17.52, ["Neon|Ride"] = 291.38, ["Mega"] = 144.38, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 3.77, ["Fly"] = 90.02, ["Ride"] = 77.81, ["Neon"] = 59.07, ["Neon|Ride"] = 280.08, ["Neon|Fly|Ride"] = 13986.3, ["Mega"] = 280.08, ["Mega|Ride"] = 360.94}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 19.69, ["Fly|Ride"] = 32.82, ["Neon"] = 5.25, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 27.28, ["Mega"] = 50.43, ["Mega|Ride"] = 64.32, ["Mega|Fly|Ride"] = 179.1}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 597.19, ["Ride"] = 654.31, ["Fly|Ride"] = 735, ["Neon|Ride"] = 2097.85, ["Neon|Fly|Ride"] = 2071.63, ["Mega|Fly|Ride"] = 8751.75}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 7.66, ["Ride"] = 65.63, ["Neon"] = 23.63, ["Neon|Fly"] = 77.64, ["Neon|Ride"] = 75.54, ["Neon|Fly|Ride"] = 196.17, ["Mega"] = 114.19, ["Mega|Ride"] = 229.43, ["Mega|Fly|Ride"] = 305.82}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 3.93, ["Fly"] = 236.25, ["Ride"] = 70.29, ["Fly|Ride"] = 167.84, ["Neon"] = 41.97, ["Neon|Ride"] = 75.68, ["Neon|Fly|Ride"] = 3217.06, ["Mega"] = 251.5, ["Mega|Ride"] = 246.75, ["Mega|Fly|Ride"] = 333.38}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 22.46, ["Fly|Ride"] = 20.93, ["Neon"] = 10.48, ["Neon|Fly"] = 140.58, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 70.3, ["Mega"] = 131.25, ["Mega|Fly"] = 224.48, ["Mega|Ride"] = 158.82, ["Mega|Fly|Ride"] = 249.92}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 32.52, ["Ride"] = 92.4, ["Fly|Ride"] = 116.13, ["Neon"] = 140.58, ["Mega"] = 544.4, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 526.32}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Neon"] = 5.13, ["Neon|Fly|Ride"] = 2033.08, ["Mega"] = 56.65, ["Mega|Ride"] = 72.19, ["Mega|Fly|Ride"] = 169.32}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 511.88, ["Ride"] = 540.21, ["Fly|Ride"] = 682.5, ["Neon"] = 2071.63, ["Neon|Ride"] = 1966.74, ["Neon|Fly|Ride"] = 1850.31, ["Mega|Ride"] = 9061.66, ["Mega|Fly|Ride"] = 7848.75}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 40.61, ["Neon"] = 10.5, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 109.22, ["Mega"] = 35.68, ["Mega|Ride"] = 122.14, ["Mega|Fly|Ride"] = 328.91}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 28.32, ["Neon"] = 4.22, ["Neon|Ride"] = 171.88, ["Mega"] = 34.13, ["Mega|Ride"] = 69.71}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 62.95, ["Mega"] = 32.78, ["Mega|Fly"] = 155.26, ["Mega|Ride"] = 104.91, ["Mega|Fly|Ride"] = 167.37}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 3.82, ["Ride"] = 68.25, ["Neon"] = 15.73, ["Mega|Ride"] = 388.04}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 49.88, ["Ride"] = 114.62, ["Fly|Ride"] = 156.19, ["Neon"] = 155.63, ["Neon|Ride"] = 224.44, ["Neon|Fly|Ride"] = 343.01, ["Mega"] = 669.38, ["Mega|Ride"] = 593.25, ["Mega|Fly|Ride"] = 654.93}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 14.38, ["Ride"] = 82.69, ["Fly|Ride"] = 262.5, ["Neon"] = 107.63, ["Neon|Ride"] = 189.09, ["Mega"] = 338.28, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 488.24}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.52, ["Fly"] = 13.13, ["Ride"] = 16.37, ["Fly|Ride"] = 36.02, ["Neon"] = 24.94, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 83.93, ["Mega"] = 299.92, ["Mega|Ride"] = 222.38, ["Mega|Fly|Ride"] = 232.37}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 11.63, ["Ride"] = 39.38, ["Neon"] = 140.58, ["Neon|Ride"] = 158.82, ["Mega"] = 419.58, ["Mega|Fly|Ride"] = 516.08}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Fly"] = 31.49, ["Ride"] = 28.29, ["Fly|Ride"] = 362.25, ["Neon"] = 13.13, ["Neon|Ride"] = 78.69, ["Mega"] = 104.56, ["Mega|Ride"] = 139.42, ["Mega|Fly|Ride"] = 209.81}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 20.86, ["Ride"] = 66.09, ["Fly|Ride"] = 155.63, ["Neon"] = 249.66, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 210, ["Mega"] = 943, ["Mega|Ride"] = 929.41, ["Mega|Fly|Ride"] = 694.32}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 62.95, ["Fly"] = 874.13, ["Neon"] = 310.06, ["Neon|Fly"] = 210, ["Neon|Ride"] = 328.13}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 46.45, ["Fly"] = 115.5, ["Ride"] = 93.17, ["Fly|Ride"] = 144.38, ["Neon"] = 290.07, ["Neon|Ride"] = 350.36, ["Neon|Fly|Ride"] = 367.5, ["Mega|Ride"] = 1642.73, ["Mega|Fly|Ride"] = 1664.64}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 67.76, ["Fly"] = 126.1, ["Ride"] = 104.19, ["Fly|Ride"] = 131.25, ["Neon"] = 171.3, ["Neon|Ride"] = 408.19, ["Neon|Fly|Ride"] = 364.88, ["Mega"] = 630, ["Mega|Ride"] = 723.19, ["Mega|Fly|Ride"] = 670.8}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 22.32, ["Ride"] = 65.62, ["Neon"] = 419.58, ["Neon|Ride"] = 167.84, ["Mega"] = 1050, ["Mega|Ride"] = 797.19, ["Mega|Fly|Ride"] = 1257.67}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 5.96, ["Ride"] = 33.57, ["Fly|Ride"] = 111.57, ["Neon"] = 26.93, ["Neon|Fly"] = 167.84, ["Neon|Ride"] = 94.5, ["Neon|Fly|Ride"] = 224.44, ["Mega"] = 495.11, ["Mega|Ride"] = 345.18, ["Mega|Fly|Ride"] = 342.74}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 28.33, ["Ride"] = 15.74, ["Fly|Ride"] = 41.68, ["Neon"] = 5.24, ["Neon|Ride"] = 41.84, ["Neon|Fly|Ride"] = 72.05, ["Mega"] = 45.94, ["Mega|Ride"] = 48.57, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1311.19}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 26.24, ["Ride"] = 82.69, ["Fly|Ride"] = 262.5, ["Neon"] = 92.92, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 314.7, ["Mega"] = 560.14, ["Mega|Ride"] = 518.44, ["Mega|Fly|Ride"] = 454.54}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 56.48, ["Neon"] = 3.86, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 293.71, ["Mega"] = 42.03, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 140.58}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 22.32, ["Ride"] = 83.93, ["Fly|Ride"] = 280.08, ["Neon"] = 111.57, ["Neon|Ride"] = 414.75, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 699.65, ["Mega|Ride"] = 699.65, ["Mega|Fly|Ride"] = 662.92}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Mega"] = 21.41}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 5.25, ["Neon|Ride"] = 87.1, ["Mega"] = 28.33, ["Mega|Ride"] = 125.89, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 131.25, ["Ride"] = 137.82, ["Fly|Ride"] = 341.96, ["Neon"] = 588.75, ["Neon|Ride"] = 590.63, ["Neon|Fly|Ride"] = 618.87, ["Mega|Ride"] = 6389.64, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 23.62, ["Fly|Ride"] = 88.12, ["Neon"] = 11.42, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 86.03, ["Mega"] = 107.58, ["Mega|Ride"] = 155.69, ["Mega|Fly|Ride"] = 449.61}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 34.92, ["Fly|Ride"] = 65.63, ["Neon"] = 6.08, ["Neon|Ride"] = 28.33, ["Neon|Fly|Ride"] = 419.99, ["Mega"] = 39.38, ["Mega|Ride"] = 124.84}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 31.37, ["Neon"] = 4.73, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 35.44, ["Mega"] = 34.13, ["Mega|Ride"] = 74.82, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 91.88, ["Neon"] = 3.93, ["Neon|Ride"] = 24.94, ["Mega"] = 28.33, ["Mega|Ride"] = 94.5, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 31.49, ["Ride"] = 91.88, ["Fly|Ride"] = 620.09, ["Neon"] = 280.08, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1119.22, ["Mega|Ride"] = 1048.93, ["Mega|Fly|Ride"] = 1245.08}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 3.67, ["Ride"] = 24.94, ["Fly|Ride"] = 77.82, ["Neon"] = 21, ["Neon|Ride"] = 111.57, ["Mega"] = 140.6, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 335.67}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 301.88, ["Ride"] = 460.04, ["Fly|Ride"] = 606.3, ["Neon"] = 1759.25, ["Neon|Ride"] = 1165.87, ["Neon|Fly|Ride"] = 1174.81, ["Mega|Fly|Ride"] = 3150}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.05}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 62.99}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 35.43}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 15.73}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 23.55}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 43.24}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 53.82}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 10.48}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 6.23}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 216.56}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 22.3}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 39.31}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 11.22}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 18.38}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 787.5}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 115.5}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 5.85}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 19}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 626.77}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 698.66}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 9.17}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1064.44}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 250.69}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 9.78}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 13.55}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.63}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.55}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 49.95}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 69.83}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 46.83}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 15.73}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 7.86}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 13.06}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 3.93}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 17.07}},
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
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 111.57}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 280.39}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 3.91}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 10.21}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 39.37}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 179.39}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 143.06}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 10.5}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 14.2}},
    ["rbxassetid://1265129435"] = {name = "Gold Snowboard", prices = {["default"] = 210}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 209.5}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 13.1}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 3.93}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 12.69}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 7.07}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 3.07}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 151.06}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 27.5}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 7.85}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 30.43}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 9.85}},
    ["rbxassetid://1265129203"] = {name = "Ice Snowboard", prices = {["default"] = 164.07}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 2.63}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 19.69}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 186.97}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 91.87}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 3.54}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 9.18}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 16.32}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 26.23}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 65.63}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 38.89}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22056.72}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 170.63}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 27.57}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 44.07}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 30.64}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 271.68}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 25.7}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 39.38}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 74.12}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 119.44}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 157.5}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 35.44}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 36.73}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 39.37}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 40.65}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 170.63}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 6.57}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 9.96}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 3.94}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 6.23}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 28.01}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 44.62}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.1}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 3.66}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 3.92}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 4.45}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 745.5}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 6.57}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 651}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 20.91}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.1}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 262.5}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 28.74}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 42}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 32.81}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 132.57}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 28.88}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 4.66}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 15.74}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.1}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 6.98}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 3.93}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 40.95}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 3.91}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 3.15}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 3.82}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 12.64}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 190.11}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 37.91}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.1}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 131.25}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 9.31}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 8.85}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 52.5}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 12.99}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 90.39}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 6.3}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 44.63}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 12.48}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 11.79}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 135.19}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 39.26}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 8.16}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 3.93}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 3.82}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 8.38}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 14.42}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 3.94}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 5.25}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 22.4}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 3.67}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 3.94}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 8.4}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 7349.79}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 17.41}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 6.55}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 5.13}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 26.88}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 8.74}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 5.39}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 3.93}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 14.42}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 118.01}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 11.8}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 8.85}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 3.93}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 8.14}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 5.87}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 3.67}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 3.44}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4335.97}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 209.99}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 41.77}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.46}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 3.75}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 81.38}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 3.93}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 3.94}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 182.28}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.63}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 3.94}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.63}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 3.93}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 12.77}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 23.45}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 3.59}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.44}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 11.71}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 5.64}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 3.93}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 8.71}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.46}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.57}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 4.97}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 3.68}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 131.25}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 2.59}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 19.69}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 5.91}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.51}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 12.6}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 111.57}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 31.17}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 2.63}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1091.01}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 19.67}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.05}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 27.98}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 3.29}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 6.36}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 9.19}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 15.61}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 28.33}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 16.1}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 4.39}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 4.99}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 3.7}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 18.36}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 3.68}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 11.49}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 4.59}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 6.04}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 16.16}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 6.57}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.05}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 6.57}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 399}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 62.7}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 4.7}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 26.17}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 18.32}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 3.62}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 99.75}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 3.39}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 6.32}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 7.85}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 3.15}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 3.93}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 5.07}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 3.94}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 8.9}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 75.93}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 90.38}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 5.25}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1109.07}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 196.88}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 5.92}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.52}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.55}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 17.07}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 41.74}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 3.82}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 2.37}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 4.66}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 65.61}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 6.54}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 2.24}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.59}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 3.51}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 10.49}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 63.66}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 3.62}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 54.73}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 4.65}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 22.32}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 105.52}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 2.61}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.13}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 55.95}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 5.25}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 3.94}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 5.08}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 73.71}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.63}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 27.53}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 86.63}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 406.88}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 47.25}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.63}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 104.14}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 8.35}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.63}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 15.74}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 73.43}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 2.24}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 15.7}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 2.37}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 9.12}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 16.93}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.55}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 19.69}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 4.22}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 3.93}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 3.93}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 31.5}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 52.41}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 3.13}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 26.23}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 4.72}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 3.91}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 39.38}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 59.06}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 34.12}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1401.16}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 15.73}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 7.49}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 39.32}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 247.01}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 20.9}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 6.03}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 11.73}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 5.09}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 2.52}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 208.69}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 45.44}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 4.66}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 4.22}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 60.37}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 111.57}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 90.28}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 943.69}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 199.5}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 7.85}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 1036.88}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 525}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 3.29}},
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