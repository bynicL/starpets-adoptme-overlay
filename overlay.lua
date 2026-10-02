-- ============================================
--  Adopt Me Price Overlay — ПУБЛИЧНАЯ ВЕРСИЯ
--  Один файл: логика + встроенные актуальные цены
--  Игрок запускает: loadstring(game:HttpGet("URL"))()
-- ============================================
print("===== ADOPT ME PRICE OVERLAY (public) =====")

local PG = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
local DISCORD_URL = "https://discord.gg/QsxA7ybDa"

-- ===== НАСТРОЙКИ (панель настроек) =====
local settings = {
    showPrices = true,     -- показывать цены на слотах
    showBackpack = true,   -- считать/показывать стоимость рюкзака
    showTradePanel = true, -- показывать панель анализа трейда
}

-- ===== ВСТРОЕННЫЕ ДАННЫЕ (заполняет генератор / GitHub Actions) =====
-- Структура: ["rbxassetid://..."] = { name="...", prices={ ["default"]=цена, ... } }
-- =====BEGIN_PRICES=====
local PRICES_DATA = {
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 1250, ["Ride"] = 1123.75, ["Fly|Ride"] = 1643.21, ["Neon"] = 6586.42, ["Neon|Fly|Ride"] = 4792.78}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 450, ["Fly"] = 713.71, ["Ride"] = 470, ["Fly|Ride"] = 553.85, ["Neon|Fly|Ride"] = 3068.38}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 4249.98, ["Ride"] = 4125, ["Fly|Ride"] = 4199.5, ["Neon|Fly|Ride"] = 18481.85}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 180, ["Ride"] = 229.85, ["Fly|Ride"] = 313.16, ["Neon"] = 875, ["Neon|Ride"] = 812.5, ["Neon|Fly|Ride"] = 725}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 482.5, ["Fly"] = 685.01, ["Ride"] = 499.99, ["Fly|Ride"] = 497.5, ["Neon|Fly|Ride"] = 1465}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 11.23, ["Ride"] = 56.25, ["Fly|Ride"] = 125, ["Neon"] = 101.68, ["Neon|Fly"] = 274.21, ["Neon|Ride"] = 100, ["Neon|Fly|Ride"] = 157.57}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 4.71, ["Fly"] = 37.12, ["Ride"] = 31.24, ["Fly|Ride"] = 54.99, ["Neon"] = 29.8, ["Neon|Fly"] = 94.9, ["Neon|Ride"] = 47.07, ["Neon|Fly|Ride"] = 99.65}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 100, ["Fly"] = 282.2, ["Ride"] = 112.5, ["Fly|Ride"] = 313.94, ["Neon"] = 416.87, ["Neon|Ride"] = 468.75, ["Neon|Fly|Ride"] = 684.15}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 36.01, ["Fly"] = 100, ["Ride"] = 45.98, ["Fly|Ride"] = 95.07, ["Neon"] = 357.49, ["Neon|Fly"] = 231.25, ["Neon|Ride"] = 204.1, ["Neon|Fly|Ride"] = 275}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 22.37, ["Fly"] = 31.8, ["Ride"] = 30.28, ["Fly|Ride"] = 67.8, ["Neon"] = 250, ["Neon|Ride"] = 166.25, ["Neon|Fly|Ride"] = 192.1}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 68.74, ["Fly"] = 75, ["Ride"] = 86.25, ["Fly|Ride"] = 219.8, ["Neon"] = 387.5, ["Neon|Ride"] = 250, ["Neon|Fly|Ride"] = 313.94}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 68.75}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 353.75, ["Fly"] = 324.98, ["Ride"] = 348.75, ["Fly|Ride"] = 362.5, ["Neon|Ride"] = 960, ["Neon|Fly|Ride"] = 1006.87}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 124.98, ["Fly"] = 164.82, ["Ride"] = 149.9, ["Fly|Ride"] = 179.98, ["Neon|Fly|Ride"] = 643.83}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 3.75, ["Fly"] = 80.8, ["Ride"] = 41.09, ["Neon"] = 23.53, ["Neon|Ride"] = 112.5, ["Neon|Fly|Ride"] = 235.17}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 200, ["Fly"] = 223.75, ["Ride"] = 200, ["Fly|Ride"] = 267.5, ["Neon"] = 975.65, ["Neon|Ride"] = 812.5, ["Neon|Fly|Ride"] = 809.53}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3, ["Fly"] = 24.66, ["Ride"] = 18.55, ["Fly|Ride"] = 41.24, ["Neon"] = 26.71, ["Neon|Fly"] = 123.24, ["Neon|Ride"] = 68.83, ["Neon|Fly|Ride"] = 96.24}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 153.54, ["Fly"] = 212.5, ["Ride"] = 192.05, ["Fly|Ride"] = 250, ["Neon"] = 563.21, ["Neon|Ride"] = 498.13, ["Neon|Fly|Ride"] = 606.25}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 41.12}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 86.25, ["Ride"] = 156.25, ["Fly|Ride"] = 310, ["Neon"] = 575, ["Neon|Ride"] = 492.96, ["Neon|Fly|Ride"] = 750}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 20.39, ["Fly"] = 375, ["Ride"] = 109.9, ["Fly|Ride"] = 82.41, ["Neon"] = 250, ["Neon|Ride"] = 411.51, ["Neon|Fly|Ride"] = 409.76}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 41.21, ["Fly"] = 81.25, ["Ride"] = 49.89, ["Fly|Ride"] = 103.75, ["Neon"] = 206.25, ["Neon|Ride"] = 185, ["Neon|Fly|Ride"] = 243.75}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 45.78, ["Fly"] = 87.5, ["Ride"] = 82.15, ["Fly|Ride"] = 187.5, ["Neon"] = 294.76, ["Neon|Ride"] = 384.1, ["Neon|Fly|Ride"] = 500}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 33.82, ["Ride"] = 63.68, ["Fly|Ride"] = 133.52, ["Neon"] = 200, ["Neon|Ride"] = 155, ["Neon|Fly|Ride"] = 262.5}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 42.49, ["Ride"] = 69.62, ["Fly|Ride"] = 118.11, ["Neon"] = 225, ["Neon|Ride"] = 260.4, ["Neon|Fly|Ride"] = 308.11}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 6.23, ["Fly"] = 30.53, ["Ride"] = 22.89, ["Fly|Ride"] = 42.5, ["Neon"] = 27.64, ["Neon|Fly"] = 56.23, ["Neon|Ride"] = 59.37, ["Neon|Fly|Ride"] = 99.99}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 387.5, ["Ride"] = 482.59, ["Fly|Ride"] = 630.59, ["Neon|Ride"] = 2179.18, ["Neon|Fly|Ride"] = 2177.67}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 13.61, ["Ride"] = 30, ["Fly|Ride"] = 78.8, ["Neon"] = 137.63, ["Neon|Ride"] = 108.88}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 8.25, ["Fly"] = 41.25, ["Ride"] = 23.63, ["Fly|Ride"] = 41.36, ["Neon"] = 77.03, ["Neon|Ride"] = 54.99, ["Neon|Fly|Ride"] = 135.27}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 76.82, ["Fly"] = 86.55, ["Ride"] = 88.75, ["Fly|Ride"] = 137.39, ["Neon"] = 337.5, ["Neon|Fly"] = 452.92, ["Neon|Ride"] = 287.5, ["Neon|Fly|Ride"] = 400}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 8.23, ["Ride"] = 32.93, ["Fly|Ride"] = 56.25, ["Neon"] = 78.75, ["Neon|Ride"] = 118.74, ["Neon|Fly|Ride"] = 249.7}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 216.23, ["Fly"] = 287.39, ["Ride"] = 249.9, ["Fly|Ride"] = 313.81, ["Neon"] = 820.7, ["Neon|Ride"] = 799.54, ["Neon|Fly|Ride"] = 697.49}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 24.92}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.75, ["Fly"] = 26.6, ["Ride"] = 22.42, ["Fly|Ride"] = 73.48, ["Neon"] = 23, ["Neon|Fly"] = 137.45, ["Neon|Ride"] = 55, ["Neon|Fly|Ride"] = 137.49}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 1250, ["Fly"] = 3125, ["Ride"] = 1402.42, ["Fly|Ride"] = 1741.79, ["Neon"] = 8888.75, ["Neon|Fly|Ride"] = 6875}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 13.75, ["Ride"] = 43.74, ["Fly|Ride"] = 100.94, ["Neon"] = 213.75, ["Neon|Ride"] = 373.75, ["Neon|Fly|Ride"] = 1094.79}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 231.25, ["Ride"] = 265.14, ["Fly|Ride"] = 340, ["Neon"] = 1100.08, ["Neon|Ride"] = 937.5, ["Neon|Fly|Ride"] = 1000}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 42.77}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 18.58, ["Fly"] = 82.66, ["Ride"] = 45.87, ["Fly|Ride"] = 137.63, ["Neon"] = 87.5, ["Neon|Ride"] = 122.5, ["Neon|Fly|Ride"] = 392.84}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 109.9, ["Fly"] = 141.12, ["Ride"] = 125, ["Fly|Ride"] = 219.8, ["Neon"] = 780.53, ["Neon|Ride"] = 650}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 122.9, ["Fly"] = 236.21, ["Ride"] = 155.1, ["Fly|Ride"] = 273.22, ["Neon"] = 479.62, ["Neon|Fly"] = 784.5, ["Neon|Ride"] = 369, ["Neon|Fly|Ride"] = 387.49}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 41.25}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 51.23, ["Fly"] = 68.75, ["Ride"] = 48.75, ["Fly|Ride"] = 79.99, ["Neon|Ride"] = 399.78, ["Neon|Fly|Ride"] = 401.56}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 7.4, ["Fly"] = 129.25, ["Ride"] = 65.18, ["Neon"] = 33.12, ["Neon|Ride"] = 123.25, ["Neon|Fly|Ride"] = 171.52}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 500, ["Ride"] = 518.65, ["Fly|Ride"] = 611.24, ["Neon|Fly"] = 3703.52, ["Neon|Ride"] = 3692.53, ["Neon|Fly|Ride"] = 1562.5}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 92.71, ["Fly"] = 134.54, ["Ride"] = 114.99, ["Fly|Ride"] = 186.93, ["Neon"] = 470.33, ["Neon|Ride"] = 546.37, ["Neon|Fly|Ride"] = 418.89}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 4616.36, ["Ride"] = 3772.5, ["Fly|Ride"] = 3750}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 67.49, ["Fly"] = 219.51, ["Ride"] = 87.39, ["Fly|Ride"] = 159.37, ["Neon|Ride"] = 312.49, ["Neon|Fly|Ride"] = 381.02}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 83.71, ["Fly"] = 312.5, ["Ride"] = 68.75, ["Fly|Ride"] = 124.99, ["Neon"] = 548.33, ["Neon|Ride"] = 513.51, ["Neon|Fly|Ride"] = 645.71}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 30.1, ["Fly"] = 54.49, ["Ride"] = 40.87, ["Fly|Ride"] = 87.46, ["Neon"] = 157.56, ["Neon|Fly"] = 293.71, ["Neon|Ride"] = 134.99, ["Neon|Fly|Ride"] = 192.49}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 7.37}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 41.11, ["Fly"] = 375, ["Ride"] = 56.25, ["Fly|Ride"] = 171.52, ["Neon|Ride"] = 470.47, ["Neon|Fly|Ride"] = 425}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 40.64}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 187.5, ["Ride"] = 212.5, ["Fly|Ride"] = 323.51, ["Neon"] = 1095.82, ["Neon|Ride"] = 1095.82, ["Neon|Fly|Ride"] = 922.26}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 762.5, ["Ride"] = 747.25, ["Fly|Ride"] = 806.25, ["Neon|Fly|Ride"] = 2944.41}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 6.43}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 27.5, ["Fly"] = 41.53, ["Ride"] = 31.24, ["Fly|Ride"] = 61.56, ["Neon"] = 243.99, ["Neon|Ride"] = 187.49, ["Neon|Fly|Ride"] = 212.49}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 27.4}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 4443.75, ["Fly"] = 6858.7, ["Ride"] = 4450, ["Fly|Ride"] = 4371.25, ["Neon|Ride"] = 17246.39, ["Neon|Fly|Ride"] = 9250}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 14.24, ["Ride"] = 30.5, ["Fly|Ride"] = 72.41, ["Neon"] = 112.5, ["Neon|Ride"] = 137.6, ["Neon|Fly|Ride"] = 179}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 17.49, ["Fly"] = 68.83, ["Ride"] = 48.46, ["Fly|Ride"] = 126.33, ["Neon"] = 96.54, ["Neon|Ride"] = 137.13, ["Neon|Fly|Ride"] = 250}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 72.76, ["Ride"] = 87.5, ["Fly|Ride"] = 125, ["Neon|Ride"] = 562.5, ["Neon|Fly|Ride"] = 472.09}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 11.23, ["Fly"] = 41.34, ["Ride"] = 28.78, ["Fly|Ride"] = 117.59, ["Neon"] = 95.58, ["Neon|Ride"] = 130.44, ["Neon|Fly|Ride"] = 477.5}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1473.46, ["Fly"] = 1606.23, ["Ride"] = 1437.5, ["Fly|Ride"] = 1405.25, ["Neon|Fly|Ride"] = 3000}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 25000, ["Fly"] = 28750, ["Ride"] = 29838.42, ["Fly|Ride"] = 21248.75, ["Neon|Ride"] = 62500, ["Neon|Fly|Ride"] = 54999.99}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 19.8, ["Fly"] = 85, ["Ride"] = 49.99, ["Fly|Ride"] = 115, ["Neon"] = 246.48, ["Neon|Ride"] = 207.5, ["Neon|Fly|Ride"] = 561.78}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 4.13, ["Fly"] = 69.02, ["Ride"] = 38.75, ["Fly|Ride"] = 123.22, ["Neon"] = 23.63, ["Neon|Fly"] = 96.55, ["Neon|Ride"] = 62.5, ["Neon|Fly|Ride"] = 117.49}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 25.9}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 6.53, ["Fly"] = 25, ["Ride"] = 28.75, ["Fly|Ride"] = 88.34, ["Neon"] = 55.22, ["Neon|Ride"] = 88.34, ["Neon|Fly|Ride"] = 246.48}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 682.5, ["Fly"] = 670, ["Ride"] = 674.96, ["Fly|Ride"] = 713.78, ["Neon"] = 2976.92, ["Neon|Ride"] = 2250, ["Neon|Fly|Ride"] = 1875}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 750, ["Fly"] = 1024.9, ["Ride"] = 781.24, ["Fly|Ride"] = 812.49, ["Neon|Ride"] = 4699.16, ["Neon|Fly|Ride"] = 2625}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 14, ["Fly"] = 75, ["Ride"] = 30.82, ["Fly|Ride"] = 112.5, ["Neon"] = 65.75, ["Neon|Ride"] = 105.78, ["Neon|Fly|Ride"] = 154.99}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 27.63}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 66.22, ["Fly"] = 97.11, ["Ride"] = 78.03, ["Fly|Ride"] = 113.74, ["Neon|Ride"] = 437.5, ["Neon|Fly|Ride"] = 393.75}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 68.98, ["Fly"] = 137.63, ["Ride"] = 75, ["Fly|Ride"] = 208.9, ["Neon"] = 428.75, ["Neon|Ride"] = 492.9, ["Neon|Fly|Ride"] = 485}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 6.24, ["Fly"] = 39.2, ["Ride"] = 19.32, ["Fly|Ride"] = 48.42, ["Neon"] = 43.66, ["Neon|Fly"] = 465.41, ["Neon|Ride"] = 71.25, ["Neon|Fly|Ride"] = 127.5}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 175, ["Fly"] = 219.88, ["Ride"] = 199.9, ["Fly|Ride"] = 250, ["Neon"] = 940.65, ["Neon|Ride"] = 648.73, ["Neon|Fly|Ride"] = 597.5}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 8.75, ["Ride"] = 54.91, ["Fly|Ride"] = 137.63, ["Neon"] = 31.24, ["Neon|Ride"] = 100, ["Neon|Fly|Ride"] = 385.14}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 19.41, ["Fly"] = 47.25, ["Ride"] = 31.13, ["Fly|Ride"] = 88.16, ["Neon"] = 123.25, ["Neon|Fly"] = 314.05, ["Neon|Ride"] = 138.36, ["Neon|Fly|Ride"] = 261.88}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 37.5, ["Ride"] = 57.5, ["Fly|Ride"] = 148.75, ["Neon"] = 245, ["Neon|Ride"] = 268.75}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 15.23, ["Fly"] = 84.37, ["Ride"] = 40.19, ["Fly|Ride"] = 79.91, ["Neon"] = 143.79, ["Neon|Ride"] = 341.45, ["Neon|Fly|Ride"] = 287.5}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6625, ["Ride"] = 5187.5, ["Fly|Ride"] = 5785.39, ["Neon"] = 30809.93, ["Neon|Fly|Ride"] = 26651.48}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 212.49, ["Fly"] = 250, ["Ride"] = 216.56, ["Fly|Ride"] = 243.75, ["Neon"] = 784.26, ["Neon|Ride"] = 548.75, ["Neon|Fly|Ride"] = 525}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 58.75, ["Fly"] = 300, ["Ride"] = 108.68, ["Fly|Ride"] = 225, ["Neon"] = 175, ["Neon|Fly"] = 269.6, ["Neon|Ride"] = 213.75, ["Neon|Fly|Ride"] = 331.25}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.43, ["Fly"] = 62.5, ["Ride"] = 18.57, ["Fly|Ride"] = 77.5, ["Neon"] = 23.13, ["Neon|Ride"] = 33.6, ["Neon|Fly|Ride"] = 157.57}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 56.14, ["Fly"] = 188.6, ["Ride"] = 124.17, ["Fly|Ride"] = 267.03, ["Neon"] = 198.75, ["Neon|Ride"] = 238.88, ["Neon|Fly|Ride"] = 362.1}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 11250, ["Ride"] = 12776.25, ["Fly|Ride"] = 11177.5, ["Neon|Fly|Ride"] = 23600}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 341.25, ["Ride"] = 410.46, ["Fly|Ride"] = 586.42, ["Neon"] = 3078.95, ["Neon|Fly|Ride"] = 1848.61}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 43.75, ["Fly"] = 87.07, ["Ride"] = 55.32, ["Fly|Ride"] = 110.2, ["Neon"] = 1000, ["Neon|Ride"] = 312.5, ["Neon|Fly|Ride"] = 275}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 9.9, ["Ride"] = 22.76, ["Fly|Ride"] = 69.05, ["Neon"] = 65.91, ["Neon|Fly"] = 267, ["Neon|Ride"] = 74.99, ["Neon|Fly|Ride"] = 112.5}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 337.46, ["Ride"] = 399.9, ["Fly|Ride"] = 443.75, ["Neon"] = 1193.75, ["Neon|Ride"] = 1436.78, ["Neon|Fly|Ride"] = 1150}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 8.23, ["Ride"] = 32.5, ["Fly|Ride"] = 174.02, ["Neon"] = 25, ["Neon|Ride"] = 137.5, ["Neon|Fly|Ride"] = 250}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 117.5, ["Fly"] = 205.42, ["Ride"] = 130, ["Fly|Ride"] = 210.48, ["Neon"] = 524.99, ["Neon|Ride"] = 575, ["Neon|Fly|Ride"] = 543.5}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 12.5, ["Fly"] = 20.54, ["Ride"] = 18.64, ["Fly|Ride"] = 37.49, ["Neon|Ride"] = 60.6, ["Neon|Fly|Ride"] = 87.48}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 9.87}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 82.8, ["Fly"] = 569.74, ["Ride"] = 112.5, ["Fly|Ride"] = 150.34, ["Neon"] = 339.06, ["Neon|Fly"] = 1230.85, ["Neon|Ride"] = 387.5, ["Neon|Fly|Ride"] = 356.38}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 13.4, ["Fly"] = 55.78, ["Ride"] = 30.81, ["Fly|Ride"] = 96.52, ["Neon"] = 100, ["Neon|Ride"] = 118.75, ["Neon|Fly|Ride"] = 205.91}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 75}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 86.25, ["Fly"] = 200, ["Ride"] = 129.7, ["Fly|Ride"] = 287.57, ["Neon"] = 410.82, ["Neon|Ride"] = 983.67, ["Neon|Fly|Ride"] = 470}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.78, ["Fly|Ride"] = 125, ["Neon"] = 21.25, ["Neon|Ride"] = 123.25, ["Neon|Fly|Ride"] = 254.71}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 11.25, ["Fly"] = 53.73, ["Ride"] = 30.82, ["Fly|Ride"] = 92.5, ["Neon|Ride"] = 75, ["Neon|Fly|Ride"] = 236.32}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 482.57, ["Ride"] = 509, ["Fly|Ride"] = 499.99, ["Neon|Fly|Ride"] = 5487.38}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 37.32, ["Ride"] = 72.5, ["Fly|Ride"] = 102.47, ["Neon"] = 219.92, ["Neon|Ride"] = 250, ["Neon|Fly|Ride"] = 262.5}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 45.87, ["Fly"] = 96.55, ["Ride"] = 62.5, ["Fly|Ride"] = 103.75, ["Neon"] = 303.31, ["Neon|Ride"] = 270, ["Neon|Fly|Ride"] = 306.05}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 19.58, ["Fly"] = 81.25, ["Ride"] = 81.12, ["Fly|Ride"] = 106.12, ["Neon"] = 88.98, ["Neon|Fly"] = 314.48, ["Neon|Ride"] = 154.06, ["Neon|Fly|Ride"] = 313.81}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 9501.89, ["Fly"] = 9563.84, ["Ride"] = 8440, ["Fly|Ride"] = 7125, ["Neon|Fly|Ride"] = 13620}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1375, ["Fly"] = 1489.18, ["Ride"] = 1206.25, ["Fly|Ride"] = 1244.99, ["Neon|Fly|Ride"] = 3712.5}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 580, ["Ride"] = 500, ["Fly|Ride"] = 650, ["Neon"] = 2146.26, ["Neon|Fly|Ride"] = 2665.51}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 12.29, ["Fly"] = 22.5, ["Ride"] = 22.59, ["Fly|Ride"] = 41.08, ["Neon"] = 76.02, ["Neon|Ride"] = 74.99, ["Neon|Fly|Ride"] = 125}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 4.71, ["Fly"] = 75, ["Ride"] = 30.86, ["Fly|Ride"] = 103.74, ["Neon"] = 19.99, ["Neon|Ride"] = 68.15}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 29.9, ["Fly"] = 62.5, ["Ride"] = 48.31, ["Fly|Ride"] = 86.17, ["Neon"] = 274.22, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 174.9}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.39, ["Fly"] = 29.99, ["Ride"] = 16.23, ["Fly|Ride"] = 35.87, ["Neon"] = 22.62, ["Neon|Fly"] = 66.82, ["Neon|Ride"] = 47.5, ["Neon|Fly|Ride"] = 101.13}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 287.5, ["Fly"] = 312.5, ["Ride"] = 312.5, ["Fly|Ride"] = 372.5, ["Neon"] = 1566.16, ["Neon|Fly|Ride"] = 1364.73}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 20, ["Fly"] = 87.5, ["Ride"] = 38.74, ["Fly|Ride"] = 97.61, ["Neon"] = 112.5, ["Neon|Fly"] = 410.82, ["Neon|Ride"] = 137.5, ["Neon|Fly|Ride"] = 205.53}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 9.8, ["Fly"] = 23.5, ["Ride"] = 17.5, ["Fly|Ride"] = 39.99, ["Neon"] = 78.8, ["Neon|Fly"] = 116.05, ["Neon|Ride"] = 125.86, ["Neon|Fly|Ride"] = 112.5}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 685.01, ["Fly"] = 998.75, ["Ride"] = 628.51, ["Fly|Ride"] = 607.45}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1062.5, ["Fly"] = 1369.97, ["Ride"] = 1012.5, ["Fly|Ride"] = 1025, ["Neon"] = 5046.86, ["Neon|Ride"] = 3977.15, ["Neon|Fly|Ride"] = 3375}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 93.75, ["Fly"] = 114, ["Ride"] = 95, ["Fly|Ride"] = 130.44, ["Neon"] = 602.86, ["Neon|Ride"] = 940.65, ["Neon|Fly|Ride"] = 625}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 186.94, ["Fly"] = 231.09, ["Ride"] = 186.09, ["Fly|Ride"] = 222.12, ["Neon"] = 685.01, ["Neon|Ride"] = 537.5, ["Neon|Fly|Ride"] = 572.5}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 25.33, ["Fly"] = 70.56, ["Ride"] = 56.24, ["Fly|Ride"] = 98.61, ["Neon"] = 249.99, ["Neon|Ride"] = 231.42, ["Neon|Fly|Ride"] = 274.68}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 225, ["Ride"] = 616.21, ["Fly|Ride"] = 568.75, ["Neon"] = 1162.5}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2326.83, ["Ride"] = 2292.69, ["Fly|Ride"] = 2246.93, ["Neon"] = 10269.98, ["Neon|Fly|Ride"] = 10296.64}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 61.25, ["Fly"] = 205.42, ["Ride"] = 70, ["Neon"] = 275, ["Neon|Ride"] = 225, ["Neon|Fly|Ride"] = 343.03}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 549.89, ["Fly"] = 820.58, ["Ride"] = 524.9, ["Fly|Ride"] = 543.74, ["Neon|Ride"] = 1243.73, ["Neon|Fly|Ride"] = 1085}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 45, ["Fly"] = 68.83, ["Ride"] = 55.87, ["Fly|Ride"] = 77.49, ["Neon"] = 410.82, ["Neon|Ride"] = 197.5, ["Neon|Fly|Ride"] = 217.5}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 6.09, ["Fly"] = 33.66, ["Ride"] = 26.14, ["Fly|Ride"] = 41.32, ["Neon"] = 27.5, ["Neon|Fly"] = 75, ["Neon|Ride"] = 43.33, ["Neon|Fly|Ride"] = 98.64}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 71.25, ["Ride"] = 124.99, ["Fly|Ride"] = 150, ["Neon"] = 386.25, ["Neon|Ride"] = 470.33, ["Neon|Fly|Ride"] = 685.01}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 1098.2, ["Ride"] = 937.5, ["Fly|Ride"] = 1057.5, ["Neon"] = 4245.62, ["Neon|Ride"] = 3518.75, ["Neon|Fly|Ride"] = 3187.5}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 674.99, ["Ride"] = 725, ["Fly|Ride"] = 874.22, ["Neon|Fly|Ride"] = 4107.91}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 17.9, ["Fly"] = 24.5, ["Ride"] = 21.53, ["Fly|Ride"] = 37.5, ["Neon"] = 137.5, ["Neon|Fly"] = 274.22, ["Neon|Ride"] = 125, ["Neon|Fly|Ride"] = 147.49}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 22.15, ["Ride"] = 30.93, ["Fly|Ride"] = 121.19, ["Neon"] = 353.4, ["Neon|Ride"] = 250, ["Neon|Fly|Ride"] = 262.5}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 5.86, ["Fly"] = 60.99, ["Ride"] = 27.48, ["Fly|Ride"] = 110.92, ["Neon"] = 19.22, ["Neon|Fly"] = 133.52, ["Neon|Ride"] = 56.24, ["Neon|Fly|Ride"] = 121.19}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 39.98, ["Fly"] = 57.41, ["Ride"] = 47.02, ["Fly|Ride"] = 96.43, ["Neon"] = 287.39, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 218.3}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 100, ["Ride"] = 125, ["Fly|Ride"] = 769.72, ["Neon"] = 533.64, ["Neon|Ride"] = 643.95, ["Neon|Fly|Ride"] = 868.92}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 14.98, ["Fly"] = 48.75, ["Ride"] = 34.8, ["Fly|Ride"] = 80.47, ["Neon"] = 90, ["Neon|Ride"] = 106.24, ["Neon|Fly|Ride"] = 188.55}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 34.13, ["Fly"] = 46.52, ["Ride"] = 41.91, ["Fly|Ride"] = 77.49, ["Neon"] = 250, ["Neon|Fly"] = 1368.3, ["Neon|Ride"] = 125, ["Neon|Fly|Ride"] = 237.28}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 5.25, ["Fly"] = 57.59, ["Ride"] = 16.24, ["Fly|Ride"] = 48.04, ["Neon"] = 33.56, ["Neon|Ride"] = 38.19, ["Neon|Fly|Ride"] = 62.5}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 7.5, ["Fly"] = 55.47, ["Ride"] = 35, ["Fly|Ride"] = 61.63, ["Neon"] = 31.79, ["Neon|Fly"] = 110.03, ["Neon|Ride"] = 80.7, ["Neon|Fly|Ride"] = 250}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 42.25, ["Fly"] = 57.5, ["Ride"] = 47.02, ["Fly|Ride"] = 80.43, ["Neon"] = 548.43, ["Neon|Ride"] = 235, ["Neon|Fly|Ride"] = 198.75}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1500, ["Fly"] = 1643.21, ["Ride"] = 1300.65, ["Fly|Ride"] = 1250, ["Neon|Fly|Ride"] = 3235}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 475, ["Fly"] = 648.04, ["Ride"] = 500, ["Fly|Ride"] = 500, ["Neon|Ride"] = 1657.5, ["Neon|Fly|Ride"] = 2221.25}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 273.75, ["Fly"] = 452.92, ["Ride"] = 348.74, ["Fly|Ride"] = 440.8, ["Neon"] = 1630.88, ["Neon|Ride"] = 1659.64, ["Neon|Fly|Ride"] = 1570.02}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 40}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 29.98, ["Fly"] = 61.63, ["Ride"] = 58.69, ["Fly|Ride"] = 110, ["Neon"] = 307.5, ["Neon|Fly"] = 548.43, ["Neon|Ride"] = 294.76, ["Neon|Fly|Ride"] = 533.37}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 25674.94, ["Fly"] = 24592.98, ["Ride"] = 36057.75, ["Fly|Ride"] = 17401.25, ["Neon|Fly|Ride"] = 31250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 250, ["Fly"] = 312.5, ["Ride"] = 268.74, ["Fly|Ride"] = 331.25, ["Neon|Ride"] = 1036.25, ["Neon|Fly|Ride"] = 937.5}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 141.24, ["Fly"] = 500, ["Ride"] = 276.95, ["Fly|Ride"] = 307.08, ["Neon|Fly|Ride"] = 821.61}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 100, ["Fly"] = 315.3, ["Ride"] = 123.15, ["Fly|Ride"] = 186.25, ["Neon|Ride"] = 444.61, ["Neon|Fly|Ride"] = 596.25}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 12.5, ["Fly"] = 47.65, ["Ride"] = 27.49, ["Fly|Ride"] = 82.17, ["Neon"] = 192.05, ["Neon|Fly"] = 125, ["Neon|Ride"] = 113, ["Neon|Fly|Ride"] = 226.98}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 3669.5, ["Ride"] = 3865, ["Fly|Ride"] = 3812.5, ["Neon"] = 20514, ["Neon|Fly|Ride"] = 15000}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 27.02, ["Fly"] = 53.74, ["Ride"] = 32.41, ["Fly|Ride"] = 58.44, ["Neon"] = 199.9, ["Neon|Ride"] = 188.13, ["Neon|Fly|Ride"] = 200}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 32.5, ["Fly"] = 97.57, ["Ride"] = 43.74, ["Fly|Ride"] = 93.75, ["Neon"] = 294.76, ["Neon|Fly"] = 1372.37, ["Neon|Ride"] = 187.49, ["Neon|Fly|Ride"] = 256.33}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 412.5, ["Fly"] = 485, ["Ride"] = 400, ["Fly|Ride"] = 481.25, ["Neon"] = 1250, ["Neon|Ride"] = 1087.5, ["Neon|Fly|Ride"] = 1175}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 17.49, ["Fly"] = 28.5, ["Ride"] = 23.75, ["Fly|Ride"] = 51.89, ["Neon"] = 124.99, ["Neon|Ride"] = 123.75, ["Neon|Fly|Ride"] = 141.24}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 14.83, ["Fly"] = 274.21, ["Ride"] = 41.09, ["Fly|Ride"] = 68.22, ["Neon"] = 81.25, ["Neon|Ride"] = 125, ["Neon|Fly|Ride"] = 209.43}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 87.39, ["Ride"] = 116.25, ["Fly|Ride"] = 233.75, ["Neon"] = 508.37, ["Neon|Ride"] = 405.01, ["Neon|Fly|Ride"] = 618.75}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 15.46, ["Fly"] = 91.98, ["Ride"] = 76.25, ["Fly|Ride"] = 157.57, ["Neon"] = 60, ["Neon|Fly"] = 139.12, ["Neon|Ride"] = 92.5, ["Neon|Fly|Ride"] = 213.41}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 4098.99, ["Fly"] = 4375, ["Ride"] = 4998.75, ["Fly|Ride"] = 4062.5, ["Neon"] = 16431.96, ["Neon|Ride"] = 13482.72, ["Neon|Fly|Ride"] = 11005.5}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 36.25, ["Fly"] = 109.9, ["Ride"] = 63.6, ["Fly|Ride"] = 124.99, ["Neon"] = 205.42, ["Neon|Ride"] = 287.57, ["Neon|Fly|Ride"] = 329.48}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 5593.75, ["Ride"] = 6531.24, ["Fly|Ride"] = 5993.74, ["Neon|Fly"] = 17664.36, ["Neon|Fly|Ride"] = 14375}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 3.64, ["Fly"] = 24.66, ["Ride"] = 15.16, ["Fly|Ride"] = 36.83, ["Neon"] = 20.63, ["Neon|Fly"] = 59.57, ["Neon|Ride"] = 38.02, ["Neon|Fly|Ride"] = 87.49}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 17.5, ["Fly"] = 28.46, ["Ride"] = 33.75, ["Fly|Ride"] = 49.97, ["Neon"] = 137.63, ["Neon|Fly"] = 226.98, ["Neon|Ride"] = 137.87, ["Neon|Fly|Ride"] = 150}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 7.07}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 11.23, ["Fly"] = 37.49, ["Ride"] = 26.13, ["Fly|Ride"] = 64.91, ["Neon"] = 98.74, ["Neon|Ride"] = 132.49, ["Neon|Fly|Ride"] = 201.07}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 30.42, ["Fly"] = 181.3, ["Ride"] = 59.57, ["Fly|Ride"] = 108.89, ["Neon"] = 300, ["Neon|Ride"] = 192.05, ["Neon|Fly|Ride"] = 199.24}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 15.41, ["Fly"] = 22.5, ["Ride"] = 19.36, ["Fly|Ride"] = 35.9, ["Neon"] = 89.36, ["Neon|Fly"] = 1022.63, ["Neon|Ride"] = 109.9, ["Neon|Fly|Ride"] = 108.75}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 6312.5}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2998.75}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 21.61}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 250, ["Ride"] = 360.98, ["Fly|Ride"] = 300, ["Neon|Fly|Ride"] = 1163.68}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 15, ["Fly"] = 41.25, ["Ride"] = 38.95, ["Fly|Ride"] = 44.18, ["Neon"] = 85.65, ["Neon|Ride"] = 96.55, ["Neon|Fly|Ride"] = 228}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 12.36}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 7.4, ["Ride"] = 24.74, ["Fly|Ride"] = 82.17, ["Neon"] = 147.89, ["Neon|Ride"] = 237.5, ["Neon|Fly|Ride"] = 174.6}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2250}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 500, ["Fly|Ride"] = 9999}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 64.98, ["Fly"] = 205.42, ["Ride"] = 50, ["Fly|Ride"] = 96.83, ["Neon"] = 301.25, ["Neon|Ride"] = 437.5, ["Neon|Fly|Ride"] = 686.19}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 160, ["Fly"] = 262.5, ["Ride"] = 137.5, ["Fly|Ride"] = 206.03, ["Neon"] = 929.33, ["Neon|Ride"] = 737.5, ["Neon|Fly|Ride"] = 743.75}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 2342.5, ["Fly"] = 2350, ["Ride"] = 2125, ["Fly|Ride"] = 2250, ["Neon"] = 14425.21, ["Neon|Fly|Ride"] = 9406.27}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 24.98, ["Fly"] = 162.5, ["Ride"] = 55, ["Fly|Ride"] = 85.75, ["Neon"] = 123.75, ["Neon|Ride"] = 352.74, ["Neon|Fly|Ride"] = 231.25}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 750, ["Ride"] = 705.48, ["Fly|Ride"] = 736.41, ["Neon|Ride"] = 2464.81}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 42.5}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 20, ["Fly"] = 94.49, ["Ride"] = 36.8, ["Fly|Ride"] = 235, ["Neon"] = 102.5, ["Neon|Ride"] = 157.57, ["Neon|Fly|Ride"] = 313.94}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 10.87, ["Fly"] = 66.97, ["Ride"] = 26.71, ["Fly|Ride"] = 72.91, ["Neon"] = 68.75, ["Neon|Fly"] = 300, ["Neon|Ride"] = 73.66, ["Neon|Fly|Ride"] = 175}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 72.5}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 24.66, ["Fly"] = 61.63, ["Ride"] = 31.13, ["Fly|Ride"] = 57.44, ["Neon"] = 137.99, ["Neon|Ride"] = 250, ["Neon|Fly|Ride"] = 245.89}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 27.5, ["Fly"] = 34.97, ["Ride"] = 37.48, ["Fly|Ride"] = 55.47, ["Neon"] = 192.05, ["Neon|Fly"] = 274.21, ["Neon|Ride"] = 212.49, ["Neon|Fly|Ride"] = 237.48}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 5000, ["Fly"] = 4487.5, ["Ride"] = 6161.99, ["Fly|Ride"] = 4530, ["Neon|Fly|Ride"] = 9591.49}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 9.97, ["Fly"] = 47.34, ["Ride"] = 26.4, ["Fly|Ride"] = 78.07, ["Neon"] = 39.08, ["Neon|Ride"] = 92.16}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 24.92}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 102.7, ["Fly"] = 363.11, ["Ride"] = 112.48, ["Fly|Ride"] = 222.75, ["Neon"] = 512.48, ["Neon|Ride"] = 527.89, ["Neon|Fly|Ride"] = 454.8}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 50, ["Fly"] = 191.83, ["Ride"] = 91.24, ["Fly|Ride"] = 174.02, ["Neon"] = 256.25, ["Neon|Fly"] = 352.71, ["Neon|Ride"] = 275, ["Neon|Fly|Ride"] = 534.05}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 20.42, ["Fly"] = 61.82, ["Ride"] = 32.48, ["Fly|Ride"] = 59.74, ["Neon"] = 110, ["Neon|Fly"] = 125, ["Neon|Ride"] = 129.83, ["Neon|Fly|Ride"] = 193.34}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 6.48, ["Fly"] = 41.21, ["Ride"] = 27.71, ["Fly|Ride"] = 80.33, ["Neon"] = 34.93, ["Neon|Ride"] = 68.05, ["Neon|Fly|Ride"] = 172.01}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 12.49, ["Fly"] = 100, ["Ride"] = 25.63, ["Fly|Ride"] = 83.75, ["Neon"] = 74.24, ["Neon|Ride"] = 110.34, ["Neon|Fly|Ride"] = 143.75}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 17.03, ["Fly"] = 30.9, ["Ride"] = 26.4, ["Fly|Ride"] = 42.49, ["Neon"] = 232.11, ["Neon|Ride"] = 122.5, ["Neon|Fly|Ride"] = 150}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 186.25}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 32.5, ["Ride"] = 96.55, ["Fly|Ride"] = 212.5, ["Neon"] = 150, ["Neon|Ride"] = 250, ["Neon|Fly|Ride"] = 562.5}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 181.1, ["Fly"] = 222.73, ["Ride"] = 180, ["Fly|Ride"] = 206.24, ["Neon|Ride"] = 2000, ["Neon|Fly|Ride"] = 1232.41}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 47.49, ["Ride"] = 98.75, ["Fly|Ride"] = 168.75, ["Neon"] = 208.74, ["Neon|Ride"] = 300, ["Neon|Fly|Ride"] = 450}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 1061.25, ["Fly"] = 1209.03, ["Ride"] = 989.99, ["Fly|Ride"] = 1040, ["Neon"] = 4108, ["Neon|Ride"] = 3571.49, ["Neon|Fly|Ride"] = 3283.66}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 523.75, ["Ride"] = 687.5, ["Fly|Ride"] = 772.63, ["Neon"] = 3013.07, ["Neon|Ride"] = 4704.59, ["Neon|Fly|Ride"] = 3750}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 60.58}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 10, ["Fly"] = 26.9, ["Ride"] = 22.67, ["Fly|Ride"] = 41.09, ["Neon"] = 112.5, ["Neon|Fly"] = 138.75, ["Neon|Ride"] = 77.02, ["Neon|Fly|Ride"] = 122.29}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 249.99, ["Fly"] = 500, ["Ride"] = 280.42, ["Fly|Ride"] = 340.94, ["Neon"] = 2355.61, ["Neon|Ride"] = 750, ["Neon|Fly|Ride"] = 833.08}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 17}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 111.06, ["Fly"] = 562.39, ["Ride"] = 152.01, ["Fly|Ride"] = 237.49, ["Neon"] = 428.75, ["Neon|Ride"] = 543.75, ["Neon|Fly|Ride"] = 641.25}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 118.75, ["Fly"] = 298.66, ["Ride"] = 150, ["Fly|Ride"] = 276.25, ["Neon"] = 1097.69, ["Neon|Ride"] = 983.75, ["Neon|Fly|Ride"] = 821.61}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 6.25, ["Ride"] = 22.5, ["Fly|Ride"] = 53.39, ["Neon"] = 35, ["Neon|Ride"] = 71.91, ["Neon|Fly|Ride"] = 201.25}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 16.5, ["Fly"] = 29.4, ["Ride"] = 24.75, ["Fly|Ride"] = 68.22, ["Neon"] = 104.77, ["Neon|Ride"] = 107.15, ["Neon|Fly|Ride"] = 176.41}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 13.75, ["Fly"] = 97.48, ["Ride"] = 32.85, ["Fly|Ride"] = 125, ["Neon"] = 105, ["Neon|Ride"] = 82.26, ["Neon|Fly|Ride"] = 273.14}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 4, ["Fly"] = 123.25, ["Ride"] = 50.79, ["Fly|Ride"] = 136.25, ["Neon"] = 23.63, ["Neon|Fly"] = 199.24, ["Neon|Ride"] = 66.72, ["Neon|Fly|Ride"] = 148.49}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 293.74, ["Ride"] = 299.99, ["Fly|Ride"] = 410.82, ["Neon|Ride"] = 1370.02, ["Neon|Fly|Ride"] = 1356.25}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 94.2, ["Fly"] = 203.36, ["Ride"] = 135.59, ["Fly|Ride"] = 212.5, ["Neon"] = 373.75, ["Neon|Ride"] = 375, ["Neon|Fly|Ride"] = 489.99}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 69.19, ["Fly"] = 159.18, ["Ride"] = 74.95, ["Fly|Ride"] = 183.84, ["Neon"] = 335, ["Neon|Ride"] = 332.5, ["Neon|Fly|Ride"] = 423.75}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 18.56, ["Ride"] = 55.47, ["Neon|Ride"] = 596.83, ["Neon|Fly|Ride"] = 470.15}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 17.39, ["Ride"] = 32.49, ["Fly|Ride"] = 96.55, ["Neon"] = 86.95, ["Neon|Ride"] = 82.5, ["Neon|Fly|Ride"] = 141.12}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.28, ["Fly"] = 39.67, ["Ride"] = 17.61, ["Fly|Ride"] = 92.49, ["Neon"] = 18.75, ["Neon|Ride"] = 47.28, ["Neon|Fly|Ride"] = 106.24}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 900, ["Fly"] = 999.98, ["Ride"] = 854.48, ["Fly|Ride"] = 799.99, ["Neon"] = 4108, ["Neon|Ride"] = 8230.04, ["Neon|Fly|Ride"] = 2362.49}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 237.48, ["Fly"] = 376.25, ["Ride"] = 278.17, ["Fly|Ride"] = 287.5, ["Neon|Ride"] = 875, ["Neon|Fly|Ride"] = 1646.01}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 87.5, ["Fly"] = 123.25, ["Ride"] = 120, ["Fly|Ride"] = 182.26, ["Neon"] = 412, ["Neon|Ride"] = 455.49, ["Neon|Fly|Ride"] = 500}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 213.63, ["Fly"] = 212.5, ["Ride"] = 205, ["Fly|Ride"] = 242.5, ["Neon|Ride"] = 1098.2, ["Neon|Fly|Ride"] = 931.83}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 23.73, ["Fly"] = 50, ["Ride"] = 31.48, ["Fly|Ride"] = 77.5, ["Neon"] = 162.5, ["Neon|Ride"] = 109.9, ["Neon|Fly|Ride"] = 136.25}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 205.5, ["Ride"] = 258.75, ["Neon"] = 1033.52, ["Neon|Ride"] = 897.5, ["Neon|Fly|Ride"] = 850}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 97.18, ["Ride"] = 93.81, ["Fly|Ride"] = 124.99, ["Neon|Ride"] = 411.42, ["Neon|Fly|Ride"] = 493.81}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 2212.5, ["Ride"] = 2264.52, ["Fly|Ride"] = 2249.99, ["Neon|Fly|Ride"] = 7500}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 13.63, ["Fly"] = 82.07, ["Ride"] = 36.23, ["Fly|Ride"] = 87.5, ["Neon"] = 47.9, ["Neon|Fly"] = 164.8, ["Neon|Ride"] = 83.75, ["Neon|Fly|Ride"] = 163.3}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 46.25, ["Fly"] = 137.63, ["Ride"] = 40.06, ["Fly|Ride"] = 135.59, ["Neon"] = 250, ["Neon|Ride"] = 200, ["Neon|Fly|Ride"] = 479.62}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 95, ["Fly"] = 110.59, ["Ride"] = 94.99, ["Fly|Ride"] = 131.32, ["Neon|Fly|Ride"] = 450}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 1665.09, ["Fly"] = 1567.18, ["Ride"] = 906.25, ["Fly|Ride"] = 932.43, ["Neon|Ride"] = 5967.93, ["Neon|Fly|Ride"] = 3749.99}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 437.49, ["Fly"] = 808.26, ["Ride"] = 779.89, ["Fly|Ride"] = 780.53, ["Neon"] = 2054.01}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 72.49, ["Fly"] = 206.11, ["Ride"] = 92.8, ["Neon"] = 458.05, ["Neon|Ride"] = 300, ["Neon|Fly|Ride"] = 425}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 8.38, ["Fly"] = 125, ["Ride"] = 25.04, ["Fly|Ride"] = 59.58, ["Neon"] = 65.58, ["Neon|Ride"] = 89.99, ["Neon|Fly|Ride"] = 150}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 37.48, ["Fly"] = 66.25, ["Ride"] = 40.01, ["Fly|Ride"] = 62.5, ["Neon"] = 204.6, ["Neon|Fly"] = 287.57, ["Neon|Ride"] = 271.14, ["Neon|Fly|Ride"] = 323.75}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 700, ["Fly"] = 886.55, ["Ride"] = 687.49, ["Fly|Ride"] = 790, ["Neon"] = 4108, ["Neon|Ride"] = 2750, ["Neon|Fly|Ride"] = 2388.98}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 596.24}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 5500, ["Ride"] = 4999.99, ["Fly|Ride"] = 5250, ["Neon"] = 40000, ["Neon|Ride"] = 29485.07, ["Neon|Fly|Ride"] = 26291.13}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 258.48, ["Fly"] = 471.24, ["Ride"] = 352.74, ["Fly|Ride"] = 399.78, ["Neon"] = 1643.12, ["Neon|Ride"] = 1521.94, ["Neon|Fly|Ride"] = 1187.49}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 95.29, ["Ride"] = 148.75, ["Fly|Ride"] = 141.12, ["Neon"] = 956.15, ["Neon|Ride"] = 627.88, ["Neon|Fly|Ride"] = 1095.82}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 21.17, ["Fly"] = 97.49, ["Ride"] = 46, ["Fly|Ride"] = 101.69, ["Neon"] = 196.7, ["Neon|Ride"] = 123.75, ["Neon|Fly|Ride"] = 235.17}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 11.78, ["Fly"] = 36.25, ["Ride"] = 24.63, ["Fly|Ride"] = 55.47, ["Neon"] = 137.63, ["Neon|Ride"] = 109.89, ["Neon|Fly|Ride"] = 162.5}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 17.94, ["Fly"] = 111.24, ["Ride"] = 41.07, ["Fly|Ride"] = 105, ["Neon"] = 109.25, ["Neon|Ride"] = 118.72, ["Neon|Fly|Ride"] = 196.24}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 3.69, ["Fly"] = 27.74, ["Ride"] = 22.5, ["Fly|Ride"] = 55.47, ["Neon"] = 34.98, ["Neon|Ride"] = 54.1, ["Neon|Fly|Ride"] = 137.6}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 18.55, ["Ride"] = 47.5, ["Fly|Ride"] = 137.63, ["Neon"] = 110, ["Neon|Fly"] = 823.01, ["Neon|Ride"] = 112.5, ["Neon|Fly|Ride"] = 225}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 468.75, ["Fly"] = 500, ["Ride"] = 497.5, ["Fly|Ride"] = 575, ["Neon"] = 1619.26, ["Neon|Ride"] = 1517.51, ["Neon|Fly|Ride"] = 1486.44}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 3.62, ["Fly"] = 26.7, ["Ride"] = 16.21, ["Fly|Ride"] = 37.5, ["Neon"] = 20.57, ["Neon|Ride"] = 29.96, ["Neon|Fly|Ride"] = 72.93}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 42.13, ["Fly"] = 107, ["Ride"] = 71.13, ["Fly|Ride"] = 119.88, ["Neon"] = 173.22, ["Neon|Fly"] = 315.76, ["Neon|Ride"] = 157.51, ["Neon|Fly|Ride"] = 237.57}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 748.75, ["Ride"] = 700, ["Fly|Ride"] = 725, ["Neon|Ride"] = 1822.93, ["Neon|Fly|Ride"] = 1434.99}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 39.75, ["Fly"] = 85.39, ["Ride"] = 44.4, ["Fly|Ride"] = 83.7, ["Neon"] = 241.25, ["Neon|Ride"] = 201.24, ["Neon|Fly|Ride"] = 244.9}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 302.5, ["Ride"] = 316.24, ["Fly|Ride"] = 331.25, ["Neon|Fly|Ride"] = 1000}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 267.49, ["Fly"] = 288.54, ["Ride"] = 236.25, ["Fly|Ride"] = 437.5, ["Neon|Ride"] = 875, ["Neon|Fly|Ride"] = 1016.43}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 509.4, ["Ride"] = 599.75, ["Fly|Ride"] = 604.43, ["Neon"] = 2821.89, ["Neon|Ride"] = 2600, ["Neon|Fly|Ride"] = 2450}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 16.24, ["Fly"] = 35.96, ["Ride"] = 37.49, ["Fly|Ride"] = 104.79, ["Neon"] = 75, ["Neon|Fly"] = 282.29, ["Neon|Ride"] = 112.49, ["Neon|Fly|Ride"] = 193.75}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 2837.5, ["Fly"] = 3000, ["Ride"] = 3248.75, ["Fly|Ride"] = 3000, ["Neon|Fly|Ride"] = 6250}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 117.5, ["Fly"] = 138.66, ["Ride"] = 147.89, ["Fly|Ride"] = 183.75, ["Neon"] = 524.73, ["Neon|Ride"] = 625, ["Neon|Fly|Ride"] = 528.75}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 3.75, ["Fly"] = 22.13, ["Ride"] = 16.23, ["Fly|Ride"] = 40, ["Neon"] = 18.41, ["Neon|Fly"] = 41.09, ["Neon|Ride"] = 41.25, ["Neon|Fly|Ride"] = 88.75}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.75, ["Ride"] = 24.98, ["Fly|Ride"] = 78.75, ["Neon"] = 19.93, ["Neon|Fly"] = 115.28, ["Neon|Ride"] = 49.99, ["Neon|Fly|Ride"] = 137.63}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 45.62, ["Fly"] = 59.84, ["Ride"] = 43.74, ["Fly|Ride"] = 49.5, ["Neon|Fly|Ride"] = 312.5}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 806.05, ["Fly"] = 1128.76, ["Ride"] = 821.25, ["Fly|Ride"] = 925, ["Neon|Ride"] = 10993.6, ["Neon|Fly|Ride"] = 4083.45}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 18.65, ["Fly"] = 31.25, ["Ride"] = 24.2, ["Fly|Ride"] = 42.89, ["Neon"] = 273.19, ["Neon|Ride"] = 133.43, ["Neon|Fly|Ride"] = 155.53}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 14.14, ["Fly"] = 36.98, ["Ride"] = 31.15, ["Fly|Ride"] = 68.75, ["Neon"] = 101.59, ["Neon|Fly"] = 106.25, ["Neon|Ride"] = 83.48, ["Neon|Fly|Ride"] = 148.67}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 86.25, ["Ride"] = 108.75, ["Fly|Ride"] = 138.73, ["Neon"] = 462.5, ["Neon|Ride"] = 464.4, ["Neon|Fly|Ride"] = 483.65}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 250, ["Fly"] = 305.6, ["Ride"] = 244.28, ["Fly|Ride"] = 318.06, ["Neon"] = 953.07, ["Neon|Ride"] = 890.25, ["Neon|Fly|Ride"] = 1011.6}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 4.12, ["Ride"] = 24.99, ["Fly|Ride"] = 88.75, ["Neon"] = 21.25, ["Neon|Fly"] = 625, ["Neon|Ride"] = 55.47}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 185, ["Fly"] = 282.2, ["Ride"] = 233.52, ["Fly|Ride"] = 302.97, ["Neon"] = 748.75, ["Neon|Ride"] = 668.75, ["Neon|Fly|Ride"] = 850}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 3.52, ["Fly"] = 26.24, ["Ride"] = 14.88, ["Fly|Ride"] = 42.47, ["Neon"] = 23.52, ["Neon|Fly"] = 123.46, ["Neon|Ride"] = 32.37, ["Neon|Fly|Ride"] = 80}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 307.5, ["Fly"] = 313.94, ["Ride"] = 343.03, ["Fly|Ride"] = 300, ["Neon"] = 1014.48, ["Neon|Ride"] = 1372.37, ["Neon|Fly|Ride"] = 1211.86}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 11.65, ["Fly"] = 67.14, ["Ride"] = 29.79, ["Fly|Ride"] = 65, ["Neon"] = 85.75, ["Neon|Fly"] = 298.42, ["Neon|Ride"] = 108.88, ["Neon|Fly|Ride"] = 187.5}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.9, ["Ride"] = 25, ["Fly|Ride"] = 66.94, ["Neon"] = 9.87, ["Neon|Fly"] = 162.34, ["Neon|Ride"] = 61.91, ["Neon|Fly|Ride"] = 205.42}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2, ["Neon"] = 4.66}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 2, ["Ride"] = 25, ["Fly|Ride"] = 82.5, ["Neon"] = 10.2, ["Neon|Ride"] = 33.84, ["Neon|Fly|Ride"] = 112.5}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 61.25, ["Fly"] = 135.59, ["Ride"] = 100.95, ["Fly|Ride"] = 178.7, ["Neon"] = 231.25, ["Neon|Ride"] = 295, ["Neon|Fly|Ride"] = 341.25}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2, ["Fly"] = 40.84, ["Ride"] = 15.54, ["Fly|Ride"] = 67.55, ["Neon"] = 5.63, ["Neon|Ride"] = 27.91, ["Neon|Fly|Ride"] = 67.4}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 40, ["Ride"] = 137.63, ["Neon"] = 74.99, ["Neon|Ride"] = 300}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2, ["Neon"] = 2, ["Neon|Ride"] = 52.39, ["Neon|Fly|Ride"] = 137.63}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2, ["Fly"] = 84.03, ["Ride"] = 15, ["Neon"] = 2, ["Neon|Fly"] = 23.5, ["Neon|Ride"] = 15.01, ["Neon|Fly|Ride"] = 41.09}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2, ["Fly"] = 20.62, ["Ride"] = 12.5, ["Fly|Ride"] = 34.93, ["Neon"] = 2.5, ["Neon|Fly"] = 27.74, ["Neon|Ride"] = 18.55, ["Neon|Fly|Ride"] = 62.32}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2, ["Neon"] = 3.15}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2, ["Fly"] = 112.34, ["Ride"] = 27.74, ["Fly|Ride"] = 43.14, ["Neon"] = 3.65, ["Neon|Fly"] = 97.1, ["Neon|Ride"] = 27.39, ["Neon|Fly|Ride"] = 87.5}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2, ["Ride"] = 68.83, ["Neon"] = 3.52, ["Neon|Ride"] = 85.15}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 11.59, ["Ride"] = 26.25, ["Fly|Ride"] = 98.78, ["Neon"] = 56.24, ["Neon|Ride"] = 97.61, ["Neon|Fly|Ride"] = 250}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2, ["Ride"] = 79.63, ["Neon"] = 2, ["Neon|Ride"] = 24.92, ["Neon|Fly|Ride"] = 75}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2, ["Fly|Ride"] = 65.74, ["Neon"] = 25}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 3.65, ["Ride"] = 24.99, ["Neon"] = 22.5, ["Neon|Ride"] = 62.5}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2, ["Fly"] = 137.45, ["Ride"] = 31.25, ["Neon"] = 3.38, ["Neon|Ride"] = 22.6, ["Neon|Fly|Ride"] = 137.63}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2, ["Fly"] = 18.92, ["Ride"] = 11.9, ["Fly|Ride"] = 36.82, ["Neon"] = 2, ["Neon|Fly"] = 19.55, ["Neon|Ride"] = 12.49, ["Neon|Fly|Ride"] = 38.75}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2, ["Fly"] = 68.75, ["Ride"] = 51.69, ["Fly|Ride"] = 112.49, ["Neon"] = 52.44, ["Neon|Ride"] = 137.63, ["Neon|Fly|Ride"] = 684.15}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2, ["Ride"] = 41.91, ["Fly|Ride"] = 55.47, ["Neon"] = 3.75, ["Neon|Ride"] = 31.76, ["Neon|Fly|Ride"] = 102.31}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 6.25, ["Neon"] = 19.9, ["Neon|Ride"] = 35}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.5, ["Fly"] = 84.02, ["Ride"] = 32.88, ["Fly|Ride"] = 56.25, ["Neon"] = 14.99, ["Neon|Ride"] = 41.25, ["Neon|Fly|Ride"] = 123.25}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2, ["Fly"] = 13.28, ["Ride"] = 14.9, ["Fly|Ride"] = 23.75, ["Neon"] = 2, ["Neon|Fly"] = 16.24, ["Neon|Ride"] = 11.91, ["Neon|Fly|Ride"] = 29.99}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.5, ["Fly"] = 43.31, ["Ride"] = 26.24, ["Fly|Ride"] = 55.47, ["Neon"] = 12.36, ["Neon|Fly"] = 125, ["Neon|Ride"] = 49.99, ["Neon|Fly|Ride"] = 187.49}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 2.49, ["Fly"] = 110, ["Fly|Ride"] = 88.75, ["Neon"] = 39.8, ["Neon|Ride"] = 87.48, ["Neon|Fly|Ride"] = 375}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2, ["Fly"] = 55.47, ["Ride"] = 12.49, ["Fly|Ride"] = 41.22, ["Neon"] = 2, ["Neon|Fly"] = 20.56, ["Neon|Ride"] = 14.34, ["Neon|Fly|Ride"] = 42.5}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2, ["Fly"] = 171.81, ["Ride"] = 20.62, ["Fly|Ride"] = 87.5, ["Neon"] = 3.75, ["Neon|Ride"] = 36.25, ["Neon|Fly|Ride"] = 187.5}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2, ["Fly"] = 27.79, ["Ride"] = 27.5, ["Fly|Ride"] = 125, ["Neon"] = 8.13, ["Neon|Fly"] = 112.5, ["Neon|Ride"] = 50}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2, ["Ride"] = 25.9, ["Fly|Ride"] = 46.22, ["Neon"] = 2, ["Neon|Ride"] = 36.12, ["Neon|Fly|Ride"] = 123.25}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2, ["Fly"] = 22.6, ["Ride"] = 19.42, ["Fly|Ride"] = 55, ["Neon"] = 7.14, ["Neon|Fly"] = 59.75, ["Neon|Ride"] = 58.55, ["Neon|Fly|Ride"] = 75}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2, ["Ride"] = 26.25, ["Neon"] = 6.1, ["Neon|Ride"] = 41.09, ["Neon|Fly|Ride"] = 274.22}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2, ["Fly"] = 27.62, ["Ride"] = 19.9, ["Fly|Ride"] = 31.56, ["Neon"] = 6.98, ["Neon|Fly"] = 72.93, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 56.16}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 3.75, ["Ride"] = 33.74, ["Neon"] = 39.63, ["Neon|Fly"] = 87.5, ["Neon|Fly|Ride"] = 308.09}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2, ["Fly"] = 24.79, ["Ride"] = 17.5, ["Fly|Ride"] = 33.73, ["Neon"] = 8.64, ["Neon|Fly"] = 69.25, ["Neon|Ride"] = 41.16, ["Neon|Fly|Ride"] = 82.45}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2, ["Fly"] = 21.24, ["Ride"] = 18.27, ["Fly|Ride"] = 48.74, ["Neon"] = 14.89, ["Neon|Fly"] = 27.93, ["Neon|Ride"] = 21.25, ["Neon|Fly|Ride"] = 63.63}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2, ["Fly"] = 108.74, ["Ride"] = 77.41, ["Fly|Ride"] = 137.63, ["Neon"] = 20.82, ["Neon|Fly|Ride"] = 2500}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 14.75, ["Ride"] = 125, ["Neon"] = 190.55, ["Neon|Ride"] = 201.9, ["Neon|Fly|Ride"] = 282.2}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 5.88, ["Ride"] = 68.83, ["Neon"] = 54.6, ["Neon|Ride"] = 100}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 5.43, ["Ride"] = 48.75, ["Fly|Ride"] = 106.24, ["Neon"] = 56.16, ["Neon|Ride"] = 62.5, ["Neon|Fly|Ride"] = 109.9}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2, ["Neon"] = 2.5}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 39.75}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 3.64, ["Fly"] = 44.98, ["Ride"] = 18.75, ["Fly|Ride"] = 62.49, ["Neon"] = 43.75, ["Neon|Fly"] = 179.01, ["Neon|Ride"] = 44.69, ["Neon|Fly|Ride"] = 86.25}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2, ["Fly"] = 67.41, ["Ride"] = 14.69, ["Neon"] = 2.85, ["Neon|Fly"] = 50.28, ["Neon|Ride"] = 23.08, ["Neon|Fly|Ride"] = 137.45}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2, ["Ride"] = 24.99, ["Fly|Ride"] = 274.22, ["Neon"] = 4.8, ["Neon|Ride"] = 31.76, ["Neon|Fly|Ride"] = 70.88}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2, ["Fly"] = 48.21, ["Ride"] = 18.18, ["Fly|Ride"] = 48.21, ["Neon"] = 16.24, ["Neon|Ride"] = 24.73, ["Neon|Fly|Ride"] = 59.9}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 2, ["Ride"] = 37.3, ["Neon"] = 54.9, ["Neon|Ride"] = 196.37, ["Neon|Fly|Ride"] = 149.99}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2, ["Neon"] = 3.5, ["Neon|Ride"] = 37.5, ["Neon|Fly|Ride"] = 300}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2, ["Fly"] = 26.71, ["Ride"] = 16.23, ["Fly|Ride"] = 62.5, ["Neon"] = 6.14, ["Neon|Fly"] = 110, ["Neon|Ride"] = 31.15, ["Neon|Fly|Ride"] = 101.25}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2, ["Fly"] = 19.52, ["Ride"] = 18.53, ["Fly|Ride"] = 51.24, ["Neon"] = 6.17, ["Neon|Fly"] = 36.04, ["Neon|Ride"] = 21.24, ["Neon|Fly|Ride"] = 76.02}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 12.5, ["Fly"] = 37.5, ["Ride"] = 270.76, ["Neon"] = 35, ["Neon|Ride"] = 39.9, ["Neon|Fly|Ride"] = 100.65}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2, ["Neon"] = 3.22, ["Neon|Ride"] = 41.54, ["Neon|Fly|Ride"] = 192.05}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2, ["Fly"] = 43.73, ["Ride"] = 24.63, ["Fly|Ride"] = 78.19, ["Neon"] = 3.25, ["Neon|Fly"] = 43.75, ["Neon|Ride"] = 18.25, ["Neon|Fly|Ride"] = 64.34}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2, ["Neon"] = 2}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2, ["Neon"] = 3.39, ["Neon|Fly|Ride"] = 400}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2, ["Fly"] = 24.98, ["Ride"] = 18.53, ["Fly|Ride"] = 66.14, ["Neon"] = 3.65, ["Neon|Fly"] = 49.31, ["Neon|Ride"] = 21.23, ["Neon|Fly|Ride"] = 55.27}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 7.5, ["Ride"] = 100, ["Neon"] = 88.75, ["Neon|Ride"] = 184.87, ["Neon|Fly|Ride"] = 198.75}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 3.75, ["Fly"] = 6250, ["Ride"] = 55.56, ["Neon"] = 40, ["Neon|Ride"] = 150}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 2.59, ["Ride"] = 22.5, ["Fly|Ride"] = 175.93, ["Neon"] = 24.79, ["Neon|Ride"] = 137.63, ["Neon|Fly|Ride"] = 187.5}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2, ["Fly"] = 13.43, ["Ride"] = 12.36, ["Fly|Ride"] = 27.28, ["Neon"] = 2, ["Neon|Fly"] = 15.52, ["Neon|Ride"] = 11.89, ["Neon|Fly|Ride"] = 31.85}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2, ["Fly"] = 112.5, ["Ride"] = 50, ["Neon"] = 18.05, ["Neon|Ride"] = 30.3, ["Neon|Fly|Ride"] = 684.99}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2, ["Fly"] = 16.24, ["Ride"] = 29.89, ["Neon"] = 2, ["Neon|Fly"] = 30.81, ["Neon|Ride"] = 22.42, ["Neon|Fly|Ride"] = 77.03}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2, ["Neon"] = 5, ["Neon|Fly"] = 58, ["Neon|Ride"] = 121.25, ["Neon|Fly|Ride"] = 123.4}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2, ["Fly"] = 212.5, ["Ride"] = 19.51, ["Fly|Ride"] = 54.7, ["Neon"] = 12.34, ["Neon|Fly"] = 49.99, ["Neon|Ride"] = 27.03, ["Neon|Fly|Ride"] = 81.25}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 187.5, ["Ride"] = 227.3, ["Fly|Ride"] = 205.42, ["Neon|Ride"] = 775, ["Neon|Fly|Ride"] = 810.48}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2, ["Ride"] = 20.65, ["Neon"] = 6.25, ["Neon|Fly"] = 55.56, ["Neon|Ride"] = 61.25}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 4.23, ["Fly"] = 98.75, ["Ride"] = 40.06, ["Fly|Ride"] = 56.25, ["Neon"] = 21.33, ["Neon|Ride"] = 128.75, ["Neon|Fly|Ride"] = 164.32}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2, ["Fly"] = 18.73, ["Ride"] = 12.33, ["Fly|Ride"] = 35, ["Neon"] = 4.8, ["Neon|Fly"] = 24.96, ["Neon|Ride"] = 27.65, ["Neon|Fly|Ride"] = 49.99}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2, ["Fly"] = 59.98, ["Ride"] = 17.5, ["Fly|Ride"] = 135.81, ["Neon"] = 7.35, ["Neon|Ride"] = 38.75, ["Neon|Fly|Ride"] = 109.9}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 3.88, ["Fly"] = 21.14, ["Ride"] = 15, ["Fly|Ride"] = 31.24, ["Neon"] = 30.98, ["Neon|Fly"] = 96.42, ["Neon|Ride"] = 32.87, ["Neon|Fly|Ride"] = 49.91}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 2.3, ["Ride"] = 60.88, ["Fly|Ride"] = 247.53, ["Neon"] = 26.4, ["Neon|Ride"] = 82.17, ["Neon|Fly|Ride"] = 443.74}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.72, ["Fly"] = 24.73, ["Ride"] = 16.24, ["Fly|Ride"] = 28.17, ["Neon"] = 53.75, ["Neon|Fly"] = 39.04, ["Neon|Ride"] = 32.5, ["Neon|Fly|Ride"] = 74.72}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 46.25, ["Fly"] = 137.63, ["Ride"] = 76.9, ["Fly|Ride"] = 118.89, ["Neon"] = 286.25, ["Neon|Fly"] = 329.23, ["Neon|Ride"] = 312.5, ["Neon|Fly|Ride"] = 348.54}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 181.25, ["Fly"] = 266.92, ["Ride"] = 206.25, ["Fly|Ride"] = 257.49, ["Neon|Ride"] = 750, ["Neon|Fly|Ride"] = 712.5}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 56, ["Fly"] = 95, ["Ride"] = 71.8, ["Fly|Ride"] = 96.9, ["Neon"] = 470.33, ["Neon|Fly"] = 348.17, ["Neon|Ride"] = 295, ["Neon|Fly|Ride"] = 328.65}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 5.39, ["Fly"] = 30.82, ["Ride"] = 30, ["Fly|Ride"] = 62.49, ["Neon"] = 19.79, ["Neon|Ride"] = 56.14, ["Neon|Fly|Ride"] = 228}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 12.37, ["Fly"] = 75.92, ["Ride"] = 27.74, ["Fly|Ride"] = 106.82, ["Neon"] = 112.4, ["Neon|Ride"] = 152.5, ["Neon|Fly|Ride"] = 192.05}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2, ["Fly"] = 17.65, ["Ride"] = 16.44, ["Fly|Ride"] = 41.09, ["Neon"] = 3.6, ["Neon|Fly"] = 55.29, ["Neon|Ride"] = 17.5, ["Neon|Fly|Ride"] = 81.25}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 11.68, ["Fly"] = 65.74, ["Ride"] = 31.25, ["Fly|Ride"] = 56.25, ["Neon"] = 74.9, ["Neon|Fly"] = 274.22, ["Neon|Ride"] = 187.5, ["Neon|Fly|Ride"] = 274.17}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2, ["Fly"] = 17.16, ["Ride"] = 14.9, ["Fly|Ride"] = 34.93, ["Neon"] = 13.72, ["Neon|Fly"] = 50.57, ["Neon|Ride"] = 28.53, ["Neon|Fly|Ride"] = 90}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 2.31, ["Ride"] = 24.86, ["Fly|Ride"] = 118.11, ["Neon"] = 38.29, ["Neon|Ride"] = 38.8, ["Neon|Fly|Ride"] = 164.33}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2, ["Fly"] = 26.36, ["Ride"] = 26.67, ["Neon"] = 2, ["Neon|Fly"] = 25, ["Neon|Ride"] = 16.44, ["Neon|Fly|Ride"] = 55.46}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2, ["Fly"] = 24.49, ["Ride"] = 18.23, ["Fly|Ride"] = 37.49, ["Neon"] = 13.7, ["Neon|Fly"] = 69.84, ["Neon|Ride"] = 34.93, ["Neon|Fly|Ride"] = 140}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2, ["Fly"] = 19.98, ["Ride"] = 21.24, ["Fly|Ride"] = 79.83, ["Neon"] = 21.25, ["Neon|Fly"] = 93.99, ["Neon|Ride"] = 40, ["Neon|Fly|Ride"] = 62.5}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 101.23, ["Fly"] = 138.75, ["Ride"] = 132.49, ["Fly|Ride"] = 183.5, ["Neon"] = 399.69, ["Neon|Ride"] = 437.5, ["Neon|Fly|Ride"] = 461.24}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 12.49, ["Ride"] = 229.42, ["Fly|Ride"] = 175, ["Neon"] = 70.63, ["Neon|Ride"] = 89.36, ["Neon|Fly|Ride"] = 215}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 4.91, ["Fly"] = 59.6, ["Ride"] = 15.28, ["Fly|Ride"] = 47.05, ["Neon"] = 23.34, ["Neon|Ride"] = 41.09, ["Neon|Fly|Ride"] = 86.65}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 25.67, ["Ride"] = 43.74, ["Fly|Ride"] = 162.5, ["Neon"] = 95.53, ["Neon|Ride"] = 151.25, ["Neon|Fly|Ride"] = 271.8}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 6.15}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 12.5, ["Ride"] = 131.24, ["Fly|Ride"] = 108.37, ["Neon"] = 68.83, ["Neon|Ride"] = 31.25, ["Neon|Fly|Ride"] = 221.84}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 24.99, ["Fly"] = 30, ["Ride"] = 32.84, ["Fly|Ride"] = 46.99, ["Neon"] = 386.14, ["Neon|Fly"] = 20514, ["Neon|Ride"] = 81.25, ["Neon|Fly|Ride"] = 137.59}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2, ["Ride"] = 36.98, ["Fly|Ride"] = 55.47, ["Neon"] = 5, ["Neon|Ride"] = 48.26, ["Neon|Fly|Ride"] = 129.41}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 3.93, ["Fly"] = 34.99, ["Ride"] = 20.23, ["Fly|Ride"] = 107.18, ["Neon"] = 60.6}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2, ["Fly"] = 27.59, ["Ride"] = 13.82, ["Fly|Ride"] = 41.13, ["Neon"] = 11.15, ["Neon|Fly"] = 178, ["Neon|Ride"] = 29.99, ["Neon|Fly|Ride"] = 67.23}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2, ["Fly"] = 37.5, ["Ride"] = 22.6, ["Fly|Ride"] = 112.5, ["Neon"] = 4.03, ["Neon|Ride"] = 40.06}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 24.92, ["Fly"] = 99.9, ["Ride"] = 61.58, ["Fly|Ride"] = 137.53, ["Neon"] = 175, ["Neon|Ride"] = 177.5, ["Neon|Fly|Ride"] = 578.21}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.95, ["Ride"] = 57.5, ["Fly|Ride"] = 83.41, ["Neon"] = 91.25, ["Neon|Ride"] = 112.5, ["Neon|Fly|Ride"] = 175}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 2, ["Fly"] = 18.65, ["Ride"] = 19.52, ["Fly|Ride"] = 49.39, ["Neon"] = 13.5, ["Neon|Fly"] = 28.75, ["Neon|Ride"] = 26.43, ["Neon|Fly|Ride"] = 75}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 55, ["Fly"] = 137.63, ["Ride"] = 68.75, ["Neon"] = 330.51, ["Neon|Ride"] = 368.71, ["Neon|Fly|Ride"] = 643.95}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 6.25, ["Fly"] = 46.24, ["Ride"] = 21.31, ["Fly|Ride"] = 86.43, ["Neon"] = 37.4, ["Neon|Ride"] = 37.48, ["Neon|Fly|Ride"] = 108.75}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 82.79, ["Fly"] = 115, ["Ride"] = 109.9, ["Fly|Ride"] = 216.58, ["Neon"] = 231.25, ["Neon|Ride"] = 272.5, ["Neon|Fly|Ride"] = 441.25}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 18.12, ["Ride"] = 55.79, ["Fly|Ride"] = 148.49, ["Neon"] = 96.25, ["Neon|Ride"] = 100, ["Neon|Fly|Ride"] = 175}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 3.64, ["Fly"] = 102.5, ["Ride"] = 24.99, ["Fly|Ride"] = 68.98, ["Neon"] = 65.74, ["Neon|Ride"] = 154.04, ["Neon|Fly|Ride"] = 274.68}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 19.99, ["Ride"] = 56.24, ["Fly|Ride"] = 100, ["Neon"] = 67.5, ["Neon|Ride"] = 205.42, ["Neon|Fly|Ride"] = 181.25}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 6.93, ["Ride"] = 32.5, ["Fly|Ride"] = 80.43, ["Neon"] = 53.87, ["Neon|Ride"] = 54.89, ["Neon|Fly|Ride"] = 143.75}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2, ["Neon"] = 2.25, ["Neon|Fly|Ride"] = 102.71}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 8.68, ["Ride"] = 135.83, ["Fly|Ride"] = 310.38, ["Neon"] = 37.28, ["Neon|Ride"] = 277.4}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2, ["Fly"] = 122.07, ["Ride"] = 27.74, ["Neon"] = 25, ["Neon|Fly"] = 111.37, ["Neon|Ride"] = 93.75, ["Neon|Fly|Ride"] = 187.5}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 4.98, ["Ride"] = 31.23, ["Neon"] = 16.01, ["Neon|Ride"] = 118.75, ["Neon|Fly|Ride"] = 274.22}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 444.99, ["Fly"] = 654.98, ["Ride"] = 500, ["Fly|Ride"] = 534.68, ["Neon|Ride"] = 1687.5, ["Neon|Fly|Ride"] = 1300}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 6.5, ["Fly"] = 43.14, ["Ride"] = 23.6, ["Fly|Ride"] = 62.49, ["Neon"] = 48.28, ["Neon|Ride"] = 48.75, ["Neon|Fly|Ride"] = 327.78}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 8.73, ["Fly"] = 63.66, ["Ride"] = 20.28, ["Fly|Ride"] = 50.93, ["Neon"] = 68.75, ["Neon|Fly"] = 300, ["Neon|Ride"] = 92.49, ["Neon|Fly|Ride"] = 262.5}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 2.36, ["Fly"] = 23.74, ["Ride"] = 23.6, ["Fly|Ride"] = 48.66, ["Neon"] = 27.73, ["Neon|Ride"] = 36.98, ["Neon|Fly|Ride"] = 125}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2, ["Fly"] = 55.47, ["Ride"] = 22.49, ["Fly|Ride"] = 50, ["Neon"] = 8.75, ["Neon|Fly"] = 55.9, ["Neon|Ride"] = 35.29, ["Neon|Fly|Ride"] = 137.49}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2, ["Fly"] = 24.99, ["Ride"] = 20, ["Fly|Ride"] = 50, ["Neon"] = 2.31, ["Neon|Ride"] = 30.8, ["Neon|Fly|Ride"] = 99.98}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1500}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 5.85, ["Ride"] = 27.5, ["Fly|Ride"] = 112.5, ["Neon"] = 89.98, ["Neon|Ride"] = 93.47, ["Neon|Fly|Ride"] = 308.11}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2, ["Ride"] = 18.73, ["Neon"] = 7.21, ["Neon|Ride"] = 53.75}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 6.88, ["Fly"] = 319.18, ["Ride"] = 62.41, ["Fly|Ride"] = 62.5, ["Neon"] = 35, ["Neon|Ride"] = 70.56, ["Neon|Fly|Ride"] = 224.9}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 362.51, ["Fly"] = 512.79, ["Ride"] = 393.75, ["Fly|Ride"] = 436.95, ["Neon|Ride"] = 1587.75, ["Neon|Fly|Ride"] = 1250}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 2.93, ["Fly"] = 187.5, ["Ride"] = 41.25, ["Neon"] = 68.83, ["Neon|Ride"] = 73.75, ["Neon|Fly|Ride"] = 176.44}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2, ["Fly"] = 27.74, ["Ride"] = 27.5, ["Fly|Ride"] = 112.5, ["Neon"] = 3.44, ["Neon|Ride"] = 35.17, ["Neon|Fly|Ride"] = 93.09}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2, ["Ride"] = 82.17, ["Neon"] = 3.75, ["Neon|Ride"] = 137.63, ["Neon|Fly|Ride"] = 138}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 21.68, ["Fly"] = 110.13, ["Ride"] = 68.75, ["Fly|Ride"] = 118.74, ["Neon"] = 174.99, ["Neon|Ride"] = 184.87}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 7.3, ["Ride"] = 54.98, ["Neon"] = 78.86, ["Neon|Ride"] = 112.5, ["Neon|Fly|Ride"] = 823.01}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 3.28, ["Ride"] = 42.49, ["Fly|Ride"] = 410.78, ["Neon"] = 115, ["Neon|Ride"] = 191.25}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 24.74, ["Ride"] = 53.7, ["Fly|Ride"] = 225, ["Neon"] = 125, ["Neon|Ride"] = 172.4, ["Neon|Fly|Ride"] = 230}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 423.24, ["Ride"] = 524.59, ["Fly|Ride"] = 652.58, ["Neon"] = 1018.75, ["Neon|Ride"] = 1024.75, ["Neon|Fly|Ride"] = 1121.47}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 7.9, ["Ride"] = 27.27, ["Fly|Ride"] = 219.79, ["Neon"] = 123.68, ["Neon|Ride"] = 260.87, ["Neon|Fly|Ride"] = 274.22}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 5.13, ["Ride"] = 26.71, ["Fly|Ride"] = 121.25, ["Neon"] = 99.99, ["Neon|Ride"] = 100}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 31.2, ["Ride"] = 92.48, ["Fly|Ride"] = 187.5, ["Neon"] = 203.75, ["Neon|Fly|Ride"] = 374.9}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.5, ["Ride"] = 68.83, ["Fly|Ride"] = 137.63, ["Neon"] = 7.5, ["Neon|Ride"] = 55.47}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 44.18, ["Ride"] = 70.05, ["Neon"] = 250, ["Neon|Ride"] = 408.76, ["Neon|Fly|Ride"] = 375}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2, ["Fly"] = 55.47, ["Ride"] = 32.69, ["Neon"] = 9.89, ["Neon|Fly"] = 179.01, ["Neon|Ride"] = 41.25, ["Neon|Fly|Ride"] = 106.22}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2, ["Ride"] = 43.73, ["Fly|Ride"] = 67.76, ["Neon"] = 3.75, ["Neon|Ride"] = 31.25, ["Neon|Fly|Ride"] = 94.07}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2, ["Ride"] = 25, ["Fly|Ride"] = 125.86, ["Neon"] = 13.63, ["Neon|Ride"] = 53.75, ["Neon|Fly|Ride"] = 144.51}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 65.2, ["Fly"] = 125, ["Ride"] = 74.96, ["Fly|Ride"] = 93.75, ["Neon"] = 350, ["Neon|Ride"] = 273.97, ["Neon|Fly|Ride"] = 821.61}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 2.5, ["Neon"] = 23.25, ["Neon|Fly"] = 333.75}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2, ["Fly"] = 27.74, ["Ride"] = 25.6, ["Fly|Ride"] = 125, ["Neon"] = 8.47, ["Neon|Ride"] = 31.15}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 3.53, ["Fly"] = 82.17, ["Ride"] = 31.24, ["Fly|Ride"] = 98.74, ["Neon"] = 31.25, ["Neon|Fly|Ride"] = 157.84}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 7.78, ["Fly"] = 80, ["Ride"] = 49.4, ["Fly|Ride"] = 173.23, ["Neon"] = 23.73, ["Neon|Ride"] = 62.49, ["Neon|Fly|Ride"] = 143.74}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2, ["Ride"] = 67.8, ["Neon"] = 5.79, ["Neon|Ride"] = 75}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2, ["Fly"] = 50, ["Ride"] = 18.75, ["Fly|Ride"] = 59.87, ["Neon"] = 4.82, ["Neon|Fly"] = 75, ["Neon|Ride"] = 20.58, ["Neon|Fly|Ride"] = 96.51}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2, ["Fly"] = 26.21, ["Ride"] = 22.43, ["Fly|Ride"] = 55, ["Neon"] = 18.5, ["Neon|Fly"] = 49.99, ["Neon|Ride"] = 36.16, ["Neon|Fly|Ride"] = 60}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 27.08, ["Fly"] = 68.86, ["Ride"] = 62.5, ["Fly|Ride"] = 68.75, ["Neon"] = 150, ["Neon|Ride"] = 234}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 63.64, ["Ride"] = 91.34, ["Fly|Ride"] = 146.25, ["Neon"] = 356.25, ["Neon|Ride"] = 412.5, ["Neon|Fly|Ride"] = 443.75}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2, ["Fly"] = 27.82, ["Ride"] = 18.74, ["Neon"] = 4.64, ["Neon|Fly"] = 75, ["Neon|Ride"] = 28.65, ["Neon|Fly|Ride"] = 137.63}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2, ["Fly"] = 17.27, ["Ride"] = 13.75, ["Fly|Ride"] = 31.25, ["Neon"] = 4.74, ["Neon|Fly"] = 37.5, ["Neon|Ride"] = 23.47, ["Neon|Fly|Ride"] = 47.49}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 5.93, ["Fly"] = 175, ["Ride"] = 18.75, ["Neon"] = 40, ["Neon|Ride"] = 151.82, ["Neon|Fly|Ride"] = 157.57}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 391.05, ["Ride"] = 627.88, ["Fly|Ride"] = 556.25, ["Neon"] = 4107.8, ["Neon|Ride"] = 2059.33, ["Neon|Fly|Ride"] = 1687.5}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 22.25, ["Fly"] = 109.42, ["Ride"] = 54.8, ["Fly|Ride"] = 118.81, ["Neon"] = 205, ["Neon|Ride"] = 175, ["Neon|Fly|Ride"] = 246.17}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2, ["Fly"] = 43.75, ["Ride"] = 20.68, ["Fly|Ride"] = 273.88, ["Neon"] = 8.74, ["Neon|Ride"] = 34.99, ["Neon|Fly|Ride"] = 136.25}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.5, ["Fly"] = 100, ["Ride"] = 59.39, ["Fly|Ride"] = 249.53, ["Neon"] = 41.37}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 25.74, ["Fly"] = 30.58, ["Ride"] = 49.99, ["Fly|Ride"] = 64.99, ["Neon"] = 162.5, ["Neon|Ride"] = 245.63, ["Neon|Fly|Ride"] = 305.71}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 103.42, ["Ride"] = 137.38, ["Fly|Ride"] = 179.74, ["Neon"] = 467.3, ["Neon|Fly"] = 1232.34, ["Neon|Ride"] = 384.1, ["Neon|Fly|Ride"] = 425}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 221.25, ["Fly"] = 214.99, ["Ride"] = 248.86, ["Fly|Ride"] = 375, ["Neon"] = 940.74, ["Neon|Ride"] = 755, ["Neon|Fly|Ride"] = 986.25}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 9.62, ["Fly"] = 55.54, ["Ride"] = 48.17, ["Fly|Ride"] = 137.63, ["Neon"] = 81.16, ["Neon|Fly"] = 262.42, ["Neon|Ride"] = 94.95, ["Neon|Fly|Ride"] = 179.9}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2, ["Fly"] = 27.74, ["Ride"] = 15.89, ["Fly|Ride"] = 41.24, ["Neon"] = 8.65, ["Neon|Ride"] = 24.99, ["Neon|Fly|Ride"] = 86.24}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 5.99, ["Fly"] = 37.5, ["Ride"] = 20.35, ["Fly|Ride"] = 48.59, ["Neon"] = 35, ["Neon|Fly"] = 130.68, ["Neon|Ride"] = 38.14, ["Neon|Fly|Ride"] = 99.35}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 287.2, ["Fly"] = 439.75, ["Ride"] = 312.5, ["Fly|Ride"] = 548.43, ["Neon"] = 1410.95}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2, ["Neon"] = 3.33, ["Neon|Ride"] = 135.48}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 5.77, ["Fly"] = 18.75, ["Ride"] = 14.99, ["Fly|Ride"] = 44.16, ["Neon"] = 19.3, ["Neon|Ride"] = 27.4, ["Neon|Fly|Ride"] = 78.8}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 13.75, ["Fly"] = 6250, ["Ride"] = 96.55, ["Fly|Ride"] = 137.5, ["Neon"] = 85.6, ["Neon|Fly"] = 175, ["Neon|Ride"] = 137.63, ["Neon|Fly|Ride"] = 196.17}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 115.21, ["Fly"] = 274.21, ["Ride"] = 120.85, ["Fly|Ride"] = 156.23, ["Neon|Ride"] = 821.61, ["Neon|Fly|Ride"] = 625}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 15.9, ["Fly"] = 37.56, ["Ride"] = 27.04, ["Fly|Ride"] = 47.89, ["Neon"] = 112.5, ["Neon|Ride"] = 79, ["Neon|Fly|Ride"] = 120}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2, ["Ride"] = 59.58, ["Neon"] = 3.62}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2, ["Ride"] = 18.5, ["Fly|Ride"] = 82.16, ["Neon"] = 2.25, ["Neon|Fly"] = 68.75, ["Neon|Ride"] = 26.58, ["Neon|Fly|Ride"] = 74.98}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 11.25, ["Ride"] = 72.43, ["Fly|Ride"] = 152.5, ["Neon"] = 31.79, ["Neon|Ride"] = 90.38, ["Neon|Fly|Ride"] = 187.5}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1150, ["Fly"] = 1811.28, ["Ride"] = 937.5, ["Fly|Ride"] = 1106.25, ["Neon"] = 4252.87, ["Neon|Fly|Ride"] = 3812.5}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 378.75, ["Fly"] = 480.65, ["Ride"] = 421.27, ["Fly|Ride"] = 455.62, ["Neon"] = 1600, ["Neon|Ride"] = 1374.99, ["Neon|Fly|Ride"] = 1250}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 286.13, ["Fly"] = 410.82, ["Ride"] = 324.27, ["Fly|Ride"] = 367.48, ["Neon"] = 700, ["Neon|Fly"] = 842.15, ["Neon|Ride"] = 618, ["Neon|Fly|Ride"] = 700}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 218.65, ["Fly"] = 287.5, ["Ride"] = 266.25, ["Fly|Ride"] = 357.34, ["Neon"] = 612.5, ["Neon|Ride"] = 710, ["Neon|Fly|Ride"] = 736.13}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2, ["Fly"] = 28.75, ["Ride"] = 15.42, ["Fly|Ride"] = 46.25, ["Neon"] = 7.5, ["Neon|Fly"] = 20.56, ["Neon|Ride"] = 33.47, ["Neon|Fly|Ride"] = 88.74}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 226.25, ["Fly"] = 1372.37, ["Ride"] = 232.5, ["Fly|Ride"] = 300, ["Neon"] = 1250, ["Neon|Ride"] = 750, ["Neon|Fly|Ride"] = 1114.16}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 9.64, ["Fly"] = 174.99, ["Ride"] = 138.4, ["Neon"] = 54.99}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2, ["Fly"] = 22.48, ["Ride"] = 15.33, ["Fly|Ride"] = 37.5, ["Neon"] = 11.25, ["Neon|Ride"] = 51.36, ["Neon|Fly|Ride"] = 127.5}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2, ["Neon"] = 3.13}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 30.61, ["Ride"] = 125, ["Fly|Ride"] = 437.5, ["Neon"] = 225, ["Neon|Ride"] = 342.6}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2, ["Fly"] = 7838.96, ["Ride"] = 17.9, ["Fly|Ride"] = 65, ["Neon"] = 35.36, ["Neon|Ride"] = 47.04, ["Neon|Fly|Ride"] = 205.42}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2, ["Fly"] = 69.02, ["Ride"] = 31.25, ["Neon"] = 3.75, ["Neon|Ride"] = 54.98, ["Neon|Fly|Ride"] = 135.59}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 6.72, ["Fly"] = 77.24, ["Ride"] = 34.81, ["Fly|Ride"] = 87.46, ["Neon"] = 35, ["Neon|Fly"] = 106.05, ["Neon|Ride"] = 137.49, ["Neon|Fly|Ride"] = 129.64}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 5.61, ["Fly"] = 30.88, ["Ride"] = 17.48, ["Fly|Ride"] = 55.47, ["Neon"] = 22.49, ["Neon|Fly"] = 785.6, ["Neon|Ride"] = 61.74, ["Neon|Fly|Ride"] = 125}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 15.46, ["Ride"] = 29, ["Neon"] = 63.51, ["Neon|Ride"] = 112.5, ["Neon|Fly|Ride"] = 248.75}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 3.75, ["Fly"] = 6266.33, ["Ride"] = 27.64, ["Neon"] = 112.5, ["Neon|Ride"] = 205.15}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2, ["Fly"] = 71.17, ["Ride"] = 17.12, ["Fly|Ride"] = 40.74, ["Neon"] = 4.78, ["Neon|Fly"] = 78.55, ["Neon|Ride"] = 27.39, ["Neon|Fly|Ride"] = 123.25}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 153.58, ["Fly"] = 190, ["Ride"] = 187.49, ["Fly|Ride"] = 208.75, ["Neon"] = 1098.2, ["Neon|Ride"] = 2563.45, ["Neon|Fly|Ride"] = 940.65}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2, ["Fly"] = 24.66, ["Ride"] = 12.29, ["Fly|Ride"] = 31.24, ["Neon"] = 3.38, ["Neon|Fly"] = 27.49, ["Neon|Ride"] = 19.81, ["Neon|Fly|Ride"] = 54.76}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 6.88, ["Ride"] = 47.51, ["Fly|Ride"] = 219.8, ["Neon"] = 101.66, ["Neon|Ride"] = 125}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 27.75, ["Ride"] = 93.65, ["Fly|Ride"] = 175, ["Neon"] = 206.25, ["Neon|Ride"] = 339.9, ["Neon|Fly|Ride"] = 444.7}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 173.73, ["Fly"] = 249.99, ["Ride"] = 220, ["Fly|Ride"] = 261.34, ["Neon"] = 623.75, ["Neon|Fly"] = 1568.5, ["Neon|Ride"] = 600, ["Neon|Fly|Ride"] = 825}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 16.7, ["Fly"] = 157.84, ["Ride"] = 157.62, ["Fly|Ride"] = 158.36, ["Neon"] = 157.5, ["Neon|Ride"] = 137.63}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 11.25, ["Ride"] = 69.73, ["Fly|Ride"] = 103.48, ["Neon"] = 125, ["Neon|Fly"] = 157.57, ["Neon|Fly|Ride"] = 274.99}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 937.5, ["Fly"] = 1183.11, ["Ride"] = 949.9, ["Fly|Ride"] = 955, ["Neon"] = 4875, ["Neon|Ride"] = 5625, ["Neon|Fly|Ride"] = 4326.9}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 4.57, ["Fly"] = 17.5, ["Ride"] = 22.6, ["Fly|Ride"] = 39.99, ["Neon"] = 52.18, ["Neon|Fly"] = 75.08, ["Neon|Ride"] = 77.57, ["Neon|Fly|Ride"] = 192.5}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 5.6, ["Fly"] = 50, ["Ride"] = 40.62, ["Neon"] = 24.49, ["Neon|Ride"] = 81.16}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2, ["Fly"] = 62.1, ["Ride"] = 20.13, ["Fly|Ride"] = 852.55, ["Neon"] = 12.38, ["Neon|Ride"] = 36.25, ["Neon|Fly|Ride"] = 137.5}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 14.74, ["Fly"] = 58.55, ["Ride"] = 39.99, ["Fly|Ride"] = 101.25, ["Neon"] = 64.66, ["Neon|Ride"] = 103, ["Neon|Fly|Ride"] = 245}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 3.25, ["Fly"] = 26.9, ["Ride"] = 15.9, ["Fly|Ride"] = 37.41, ["Neon"] = 21.8, ["Neon|Fly"] = 55.47, ["Neon|Ride"] = 38.75, ["Neon|Fly|Ride"] = 75}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2, ["Fly"] = 31.19, ["Ride"] = 30.6, ["Fly|Ride"] = 68.83, ["Neon"] = 20, ["Neon|Fly"] = 12500, ["Neon|Ride"] = 38.42, ["Neon|Fly|Ride"] = 102.42}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 125.93, ["Ride"] = 220.95, ["Fly|Ride"] = 273.67, ["Neon"] = 873.81, ["Neon|Fly|Ride"] = 1126.67}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 3.43, ["Fly"] = 31.24, ["Ride"] = 20.38, ["Fly|Ride"] = 101.69, ["Neon"] = 11.07, ["Neon|Ride"] = 54.68, ["Neon|Fly|Ride"] = 97.01}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 3.65, ["Fly|Ride"] = 84.63, ["Neon"] = 18.61, ["Neon|Fly"] = 187.5, ["Neon|Ride"] = 118.3}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 3.63, ["Fly"] = 90.25, ["Ride"] = 31.25, ["Fly|Ride"] = 66.8, ["Neon"] = 17.89, ["Neon|Ride"] = 50}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 81.25, ["Ride"] = 131.24, ["Fly|Ride"] = 248.75, ["Neon"] = 425.71, ["Neon|Ride"] = 564.39, ["Neon|Fly|Ride"] = 513.5}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 21.24, ["Fly"] = 88.23, ["Ride"] = 59.99, ["Fly|Ride"] = 277.86, ["Neon"] = 120, ["Neon|Ride"] = 150, ["Neon|Fly|Ride"] = 325.64}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 17.49, ["Fly"] = 250.89, ["Ride"] = 75, ["Fly|Ride"] = 137.63, ["Neon"] = 63.58, ["Neon|Ride"] = 101.31, ["Neon|Fly|Ride"] = 162.5}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2, ["Ride"] = 45.2, ["Neon"] = 11.14, ["Neon|Ride"] = 200}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 34.99, ["Fly"] = 94.07, ["Ride"] = 80, ["Fly|Ride"] = 137.99, ["Neon"] = 191.15, ["Neon|Fly"] = 250, ["Neon|Ride"] = 218.75, ["Neon|Fly|Ride"] = 276.25}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2, ["Ride"] = 43.39, ["Fly|Ride"] = 302.96, ["Neon"] = 4.94, ["Neon|Fly|Ride"] = 96.55}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 13.4, ["Fly"] = 37.5, ["Ride"] = 27.73, ["Fly|Ride"] = 68.83, ["Neon"] = 68.75, ["Neon|Ride"] = 95.63, ["Neon|Fly|Ride"] = 193.75}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 50.33, ["Ride"] = 84.13, ["Fly|Ride"] = 110.19, ["Neon"] = 257.5, ["Neon|Fly"] = 325, ["Neon|Ride"] = 302.5, ["Neon|Fly|Ride"] = 348.65}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2, ["Fly"] = 15.41, ["Ride"] = 14.99, ["Fly|Ride"] = 48.6, ["Neon"] = 2.5, ["Neon|Fly"] = 26.71, ["Neon|Ride"] = 15.4, ["Neon|Fly|Ride"] = 43.14}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 3.23, ["Ride"] = 46.91, ["Fly|Ride"] = 1332.39, ["Neon"] = 18.73, ["Neon|Ride"] = 82.4, ["Neon|Fly|Ride"] = 160}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 12.5, ["Ride"] = 49.05, ["Fly|Ride"] = 99.9, ["Neon"] = 124.99, ["Neon|Ride"] = 100.99}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2, ["Ride"] = 16.14, ["Neon"] = 2.48, ["Neon|Ride"] = 19.19, ["Neon|Fly|Ride"] = 100}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 49.98, ["Fly"] = 82.17, ["Ride"] = 103.74, ["Fly|Ride"] = 274, ["Neon"] = 302.97, ["Neon|Ride"] = 271.25, ["Neon|Fly|Ride"] = 475}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 14.81, ["Fly"] = 22.74, ["Ride"] = 15.41, ["Fly|Ride"] = 96.55, ["Neon"] = 61.25, ["Neon|Ride"] = 130.13, ["Neon|Fly|Ride"] = 167.4}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 5, ["Ride"] = 64.69, ["Neon"] = 60, ["Neon|Fly"] = 666.25, ["Neon|Ride"] = 68.83, ["Neon|Fly|Ride"] = 125}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 7.5, ["Fly"] = 56.25, ["Ride"] = 62.49, ["Fly|Ride"] = 228, ["Neon"] = 40, ["Neon|Ride"] = 126.25, ["Neon|Fly|Ride"] = 6265.15}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.49, ["Ride"] = 138.74, ["Fly|Ride"] = 187.5, ["Neon"] = 8.47, ["Neon|Fly"] = 200, ["Neon|Ride"] = 46.88, ["Neon|Fly|Ride"] = 274.68}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2, ["Ride"] = 25, ["Neon"] = 3.75}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 18.74}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 37.32, ["Fly"] = 96.36, ["Ride"] = 55.69, ["Fly|Ride"] = 90.38, ["Neon"] = 125, ["Neon|Ride"] = 221.84, ["Neon|Fly|Ride"] = 297.5}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2, ["Fly"] = 31.25, ["Neon"] = 3.39, ["Neon|Ride"] = 26.13}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 424.9, ["Fly"] = 685.01, ["Ride"] = 561.07, ["Fly|Ride"] = 545, ["Neon"] = 3556.12, ["Neon|Fly|Ride"] = 2739.02}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 8.2, ["Fly"] = 47.8, ["Ride"] = 32.48, ["Fly|Ride"] = 55.5, ["Neon"] = 87.5, ["Neon|Fly"] = 175, ["Neon|Ride"] = 56.81}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2, ["Fly"] = 41.11, ["Ride"] = 16.9, ["Fly|Ride"] = 42.5, ["Neon"] = 14, ["Neon|Ride"] = 27.74, ["Neon|Fly|Ride"] = 93.75}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 11.25, ["Ride"] = 55.22, ["Fly|Ride"] = 82.17, ["Neon"] = 125, ["Neon|Ride"] = 106.25, ["Neon|Fly|Ride"] = 375}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 2.4, ["Fly"] = 33.95, ["Ride"] = 37.5, ["Fly|Ride"] = 90.38, ["Neon"] = 51.28, ["Neon|Ride"] = 62.5}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 12.47, ["Ride"] = 87.01, ["Fly|Ride"] = 410.49, ["Neon"] = 76.25, ["Neon|Ride"] = 111.25, ["Neon|Fly|Ride"] = 236.21}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 3.81, ["Ride"] = 24.99, ["Fly|Ride"] = 137.74, ["Neon"] = 31.85, ["Neon|Fly"] = 125, ["Neon|Ride"] = 107.12, ["Neon|Fly|Ride"] = 193.75}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2, ["Fly"] = 40.75, ["Ride"] = 14.84, ["Fly|Ride"] = 33.05, ["Neon"] = 2, ["Neon|Fly"] = 40, ["Neon|Ride"] = 15.37, ["Neon|Fly|Ride"] = 54.76}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 6.88, ["Fly"] = 40, ["Ride"] = 53.75, ["Fly|Ride"] = 102.88, ["Neon"] = 38.75, ["Neon|Ride"] = 57.49, ["Neon|Fly|Ride"] = 168.74}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 240, ["Ride"] = 249.89, ["Fly|Ride"] = 324.99, ["Neon"] = 1000, ["Neon|Ride"] = 848.75, ["Neon|Fly|Ride"] = 937.5}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 78.28, ["Ride"] = 122.75, ["Fly|Ride"] = 243.05, ["Neon"] = 319.43, ["Neon|Fly"] = 878.01, ["Neon|Ride"] = 437.5, ["Neon|Fly|Ride"] = 499.99}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2, ["Fly"] = 15.46, ["Ride"] = 15.46, ["Fly|Ride"] = 31.25, ["Neon"] = 9.18, ["Neon|Fly"] = 96.42, ["Neon|Ride"] = 24.92, ["Neon|Fly|Ride"] = 55}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2, ["Fly"] = 21.9, ["Ride"] = 14.7, ["Fly|Ride"] = 38.75, ["Neon"] = 8.38, ["Neon|Fly"] = 30, ["Neon|Ride"] = 19.78, ["Neon|Fly|Ride"] = 47.4}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.4, ["Fly"] = 96.55, ["Ride"] = 19.98, ["Fly|Ride"] = 93.75, ["Neon"] = 22.48, ["Neon|Fly|Ride"] = 150}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 213.75, ["Ride"] = 221.14, ["Fly|Ride"] = 343.03, ["Neon"] = 975.85, ["Neon|Ride"] = 932.5, ["Neon|Fly|Ride"] = 1236.93}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2, ["Fly"] = 26.71, ["Ride"] = 15.89, ["Fly|Ride"] = 46.91, ["Neon"] = 23.5, ["Neon|Fly"] = 99.97, ["Neon|Ride"] = 36.06, ["Neon|Fly|Ride"] = 93.75}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 6.09, ["Ride"] = 75, ["Fly|Ride"] = 187.49, ["Neon"] = 22.5, ["Neon|Ride"] = 104.76, ["Neon|Fly|Ride"] = 219.8}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2, ["Neon"] = 11.05, ["Neon|Ride"] = 106.24}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 12.49, ["Fly"] = 55.47, ["Ride"] = 24.73, ["Fly|Ride"] = 75, ["Neon"] = 152.01, ["Neon|Ride"] = 116.05, ["Neon|Fly|Ride"] = 199}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 39.56, ["Ride"] = 78.7, ["Fly|Ride"] = 193.75, ["Neon"] = 124.81, ["Neon|Fly"] = 625, ["Neon|Ride"] = 187.5, ["Neon|Fly|Ride"] = 287.49}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 26.79, ["Fly"] = 96.55, ["Ride"] = 51.36, ["Fly|Ride"] = 70.56, ["Neon"] = 138.13, ["Neon|Fly"] = 274.21, ["Neon|Ride"] = 205.42, ["Neon|Fly|Ride"] = 174.89}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2, ["Fly"] = 17.5, ["Ride"] = 15.41, ["Fly|Ride"] = 41.16, ["Neon"] = 2, ["Neon|Fly"] = 18.5, ["Neon|Ride"] = 17.13, ["Neon|Fly|Ride"] = 43.72}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 204.99, ["Ride"] = 245.07, ["Fly|Ride"] = 281.25, ["Neon"] = 3289.5, ["Neon|Fly|Ride"] = 1279.41}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 5.86, ["Fly"] = 96.37, ["Ride"] = 39.5, ["Fly|Ride"] = 105, ["Neon"] = 41.09}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2, ["Fly"] = 18.75, ["Ride"] = 18.55, ["Fly|Ride"] = 41.09, ["Neon"] = 8.16, ["Neon|Fly"] = 45.2, ["Neon|Ride"] = 39.4, ["Neon|Fly|Ride"] = 123.25}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2, ["Fly"] = 68.83, ["Ride"] = 18.49, ["Fly|Ride"] = 68.83, ["Neon"] = 3.44, ["Neon|Fly"] = 78.84, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 78.75}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2, ["Ride"] = 37.48, ["Fly|Ride"] = 102.71, ["Neon"] = 12.9, ["Neon|Fly"] = 704.9, ["Neon|Ride"] = 71.24, ["Neon|Fly|Ride"] = 137.63}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 10.61, ["Fly"] = 37.41, ["Ride"] = 23.63, ["Fly|Ride"] = 54.99, ["Neon"] = 46.25, ["Neon|Fly"] = 103.33, ["Neon|Ride"] = 48.74, ["Neon|Fly|Ride"] = 137.63}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 10.91, ["Ride"] = 26.25, ["Neon"] = 44.18, ["Neon|Ride"] = 59.57, ["Neon|Fly|Ride"] = 312.5}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2, ["Ride"] = 34.95, ["Neon"] = 3.75, ["Neon|Ride"] = 118.67, ["Neon|Fly|Ride"] = 86.28}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 8.75, ["Fly"] = 80, ["Ride"] = 27.5, ["Fly|Ride"] = 112.5, ["Neon"] = 27.73, ["Neon|Ride"] = 55.42, ["Neon|Fly|Ride"] = 137.63}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2, ["Ride"] = 29.99, ["Neon"] = 3.75, ["Neon|Fly"] = 109.9, ["Neon|Ride"] = 37.46, ["Neon|Fly|Ride"] = 102.71}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2, ["Fly"] = 60.62, ["Ride"] = 19.9, ["Fly|Ride"] = 41.19, ["Neon"] = 7.11, ["Neon|Ride"] = 18.75, ["Neon|Fly|Ride"] = 67.8}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 618.73, ["Ride"] = 703.75, ["Fly|Ride"] = 830, ["Neon"] = 2500, ["Neon|Ride"] = 2312.5, ["Neon|Fly|Ride"] = 2312.5}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2, ["Fly"] = 17.88, ["Ride"] = 15.04, ["Fly|Ride"] = 62.28, ["Neon"] = 10, ["Neon|Fly"] = 113.92, ["Neon|Ride"] = 26.23, ["Neon|Fly|Ride"] = 61.13}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2, ["Ride"] = 37.5, ["Fly|Ride"] = 82.17, ["Neon"] = 9.81, ["Neon|Fly"] = 31.79, ["Neon|Ride"] = 56.25, ["Neon|Fly|Ride"] = 137.63}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 7.69, ["Fly"] = 23.7, ["Ride"] = 21.24, ["Fly|Ride"] = 48.24, ["Neon"] = 46.54, ["Neon|Fly"] = 230, ["Neon|Ride"] = 43.74, ["Neon|Fly|Ride"] = 121.25}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2, ["Fly"] = 56.15, ["Ride"] = 13.28, ["Fly|Ride"] = 33.03, ["Neon"] = 9.11, ["Neon|Fly"] = 49.98, ["Neon|Ride"] = 24.83, ["Neon|Fly|Ride"] = 56.25}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 38.55, ["Ride"] = 80, ["Neon"] = 181.91, ["Neon|Ride"] = 212.5, ["Neon|Fly|Ride"] = 303.77}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2, ["Fly"] = 27.73, ["Ride"] = 32.41, ["Fly|Ride"] = 78.07, ["Neon"] = 5, ["Neon|Fly"] = 134.06, ["Neon|Ride"] = 40, ["Neon|Fly|Ride"] = 150}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 3.75, ["Fly"] = 73.66, ["Ride"] = 24.98, ["Fly|Ride"] = 97.44, ["Neon"] = 14.67, ["Neon|Ride"] = 56.16}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2, ["Fly|Ride"] = 62.7, ["Neon"] = 15.41}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2, ["Fly"] = 27.74, ["Ride"] = 15, ["Fly|Ride"] = 66.25, ["Neon"] = 5, ["Neon|Fly"] = 69.03, ["Neon|Ride"] = 22.48, ["Neon|Fly|Ride"] = 101.69}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 11.88, ["Fly"] = 21.13, ["Ride"] = 20.36, ["Fly|Ride"] = 42.49, ["Neon"] = 314.48, ["Neon|Fly"] = 117.43, ["Neon|Ride"] = 123.23, ["Neon|Fly|Ride"] = 116.25}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 606.25, ["Fly"] = 862.69, ["Ride"] = 699.37, ["Fly|Ride"] = 700, ["Neon"] = 1510, ["Neon|Fly"] = 1625, ["Neon|Ride"] = 1412.5, ["Neon|Fly|Ride"] = 1525}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2, ["Fly"] = 14.12, ["Ride"] = 13.75, ["Fly|Ride"] = 32.87, ["Neon"] = 3.75, ["Neon|Fly"] = 27.5, ["Neon|Ride"] = 20.52, ["Neon|Fly|Ride"] = 44.9}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 5.23, ["Ride"] = 37.47, ["Neon"] = 80.11, ["Neon|Ride"] = 137.63, ["Neon|Fly|Ride"] = 187.5}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 47.47, ["Fly"] = 125.86, ["Ride"] = 62.46, ["Fly|Ride"] = 114.18, ["Neon"] = 298.75, ["Neon|Ride"] = 309.01, ["Neon|Fly|Ride"] = 337.5}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 24.67, ["Fly"] = 138.24, ["Ride"] = 56.25, ["Fly|Ride"] = 93.75, ["Neon"] = 125, ["Neon|Ride"] = 228.75, ["Neon|Fly|Ride"] = 206.73}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 15.7, ["Ride"] = 43.22, ["Fly|Ride"] = 100, ["Neon"] = 98.9, ["Neon|Ride"] = 121.25, ["Neon|Fly|Ride"] = 262.5}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 19.24, ["Fly"] = 82.17, ["Ride"] = 68.13, ["Fly|Ride"] = 137.63, ["Neon"] = 68.83, ["Neon|Ride"] = 106.25, ["Neon|Fly|Ride"] = 350}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 26.9, ["Ride"] = 68.83, ["Neon"] = 256.77, ["Neon|Ride"] = 313.94, ["Neon|Fly|Ride"] = 500}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 199.89}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 5.92, ["Ride"] = 28.74, ["Fly|Ride"] = 55.47, ["Neon"] = 36.25, ["Neon|Ride"] = 61.63, ["Neon|Fly|Ride"] = 109.9}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.29, ["Ride"] = 49.99, ["Neon"] = 12.5}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 26.22, ["Fly"] = 60, ["Ride"] = 34.91, ["Fly|Ride"] = 51.56, ["Neon"] = 165, ["Neon|Fly"] = 250, ["Neon|Ride"] = 153.73, ["Neon|Fly|Ride"] = 202.49}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.5, ["Fly"] = 19.8, ["Ride"] = 14.84, ["Fly|Ride"] = 37.39, ["Neon"] = 27.93, ["Neon|Fly"] = 43.14, ["Neon|Ride"] = 27.73, ["Neon|Fly|Ride"] = 75}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 3.5, ["Fly"] = 102.76, ["Ride"] = 21.25, ["Fly|Ride"] = 61.16, ["Neon"] = 18.75, ["Neon|Ride"] = 43.22, ["Neon|Fly|Ride"] = 122.5}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2, ["Neon"] = 4.75}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 31.14, ["Ride"] = 31.25, ["Fly|Ride"] = 75, ["Neon"] = 157.57, ["Neon|Ride"] = 161.25, ["Neon|Fly|Ride"] = 548.43}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2, ["Ride"] = 18.75, ["Fly|Ride"] = 62.5, ["Neon"] = 8.17, ["Neon|Ride"] = 43.73, ["Neon|Fly|Ride"] = 162.5}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 10.85, ["Ride"] = 41.05, ["Fly|Ride"] = 200, ["Neon"] = 82.5, ["Neon|Ride"] = 162.5, ["Neon|Fly|Ride"] = 375}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2, ["Fly"] = 43.75, ["Ride"] = 15.41, ["Fly|Ride"] = 40.06, ["Neon"] = 15, ["Neon|Ride"] = 18.75, ["Neon|Fly|Ride"] = 106.82}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 5.84, ["Fly"] = 49.99, ["Ride"] = 17.39, ["Fly|Ride"] = 67.86, ["Neon"] = 103.65, ["Neon|Ride"] = 68.83, ["Neon|Fly|Ride"] = 162.5}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 5, ["Ride"] = 54.91, ["Neon"] = 81.24, ["Neon|Ride"] = 159.99}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 59.91, ["Fly"] = 205.42, ["Ride"] = 98.75, ["Neon"] = 320.43, ["Neon|Ride"] = 277.5, ["Neon|Fly|Ride"] = 689.02}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 18.75, ["Fly"] = 123.46, ["Ride"] = 74.25, ["Fly|Ride"] = 154.06, ["Neon"] = 83.75}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 6.72, ["Ride"] = 110.88, ["Neon"] = 137.63, ["Neon|Fly"] = 205.42, ["Neon|Ride"] = 135.46}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 28.38, ["Fly"] = 250, ["Ride"] = 122.23, ["Fly|Ride"] = 204.5, ["Neon"] = 165, ["Neon|Fly"] = 137.63, ["Neon|Ride"] = 221.02, ["Neon|Fly|Ride"] = 312.5}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 4.09, ["Neon"] = 23.38, ["Neon|Fly|Ride"] = 137.63}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2, ["Fly"] = 150, ["Ride"] = 15.88, ["Fly|Ride"] = 45.09, ["Neon"] = 3.73, ["Neon|Fly"] = 39.18, ["Neon|Ride"] = 20.47, ["Neon|Fly|Ride"] = 66.02}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 6.15, ["Fly"] = 43.75, ["Ride"] = 22.5, ["Fly|Ride"] = 80, ["Neon"] = 11.8, ["Neon|Fly"] = 84.87, ["Neon|Ride"] = 34.96, ["Neon|Fly|Ride"] = 156.23}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2, ["Fly"] = 137.44, ["Ride"] = 20.69, ["Fly|Ride"] = 71.41, ["Neon"] = 6.25, ["Neon|Fly"] = 69.04, ["Neon|Ride"] = 24.24, ["Neon|Fly|Ride"] = 79.62}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.5, ["Fly"] = 62.5, ["Ride"] = 24.65, ["Fly|Ride"] = 80.11, ["Neon"] = 24.92, ["Neon|Ride"] = 137.63, ["Neon|Fly|Ride"] = 205.42}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 2, ["Fly"] = 124.9, ["Ride"] = 32.49, ["Fly|Ride"] = 82.17, ["Neon"] = 41.07, ["Neon|Fly"] = 300, ["Neon|Ride"] = 55.46, ["Neon|Fly|Ride"] = 250}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 2.5, ["Fly"] = 124.99, ["Ride"] = 23.62, ["Fly|Ride"] = 52.82, ["Neon"] = 19.88, ["Neon|Fly"] = 129.31, ["Neon|Ride"] = 41.24, ["Neon|Fly|Ride"] = 112.4}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2, ["Fly"] = 34.51, ["Ride"] = 20.3, ["Fly|Ride"] = 50, ["Neon"] = 14.98, ["Neon|Ride"] = 31.25, ["Neon|Fly|Ride"] = 157.57}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 2.5, ["Fly"] = 275, ["Ride"] = 27.5, ["Neon"] = 11.24, ["Neon|Fly"] = 48.28, ["Neon|Ride"] = 62.5}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 16.24, ["Ride"] = 80, ["Fly|Ride"] = 175, ["Neon"] = 97.49, ["Neon|Ride"] = 162.5, ["Neon|Fly|Ride"] = 287.5}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 46.11, ["Fly"] = 156.25, ["Ride"] = 74.99, ["Fly|Ride"] = 123.62, ["Neon"] = 231.87, ["Neon|Ride"] = 251.25, ["Neon|Fly|Ride"] = 250}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2, ["Ride"] = 18.62, ["Fly|Ride"] = 112.49, ["Neon"] = 2.5, ["Neon|Ride"] = 31.24, ["Neon|Fly|Ride"] = 137.63}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 17.5, ["Ride"] = 100, ["Neon"] = 112.5}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 57.39, ["Ride"] = 112.5, ["Fly|Ride"] = 163.31, ["Neon"] = 329.1, ["Neon|Ride"] = 334.61, ["Neon|Fly|Ride"] = 409.78}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 5.63, ["Fly"] = 111.25, ["Ride"] = 38.75, ["Fly|Ride"] = 127.4, ["Neon"] = 37.49, ["Neon|Fly"] = 125.71, ["Neon|Ride"] = 96.93}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 2, ["Fly"] = 26.71, ["Ride"] = 37.62, ["Fly|Ride"] = 112.5, ["Neon"] = 11.15, ["Neon|Ride"] = 58.67, ["Neon|Fly|Ride"] = 129.41}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2, ["Fly"] = 29.89, ["Ride"] = 18.75, ["Fly|Ride"] = 54.54, ["Neon"] = 13.16, ["Neon|Fly"] = 41.39, ["Neon|Ride"] = 47.23, ["Neon|Fly|Ride"] = 102.81}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2, ["Fly"] = 15.41, ["Ride"] = 15, ["Fly|Ride"] = 39.01, ["Neon"] = 2.5, ["Neon|Fly"] = 123.25, ["Neon|Ride"] = 22.46, ["Neon|Fly|Ride"] = 62.5}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2, ["Ride"] = 17.16, ["Fly|Ride"] = 88.65, ["Neon"] = 4.76, ["Neon|Ride"] = 25.97, ["Neon|Fly|Ride"] = 92.8}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2, ["Neon"] = 3.75, ["Neon|Ride"] = 138.18}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 5.89, ["Ride"] = 149.99, ["Neon"] = 29.79, ["Neon|Ride"] = 78.66, ["Neon|Fly|Ride"] = 117.09}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 8.23, ["Ride"] = 30, ["Fly|Ride"] = 205.42, ["Neon"] = 62.5, ["Neon|Ride"] = 125, ["Neon|Fly|Ride"] = 220}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 7.39, ["Fly"] = 20.18, ["Ride"] = 28.74, ["Fly|Ride"] = 40.19, ["Neon"] = 46.57, ["Neon|Fly"] = 109.9, ["Neon|Ride"] = 41.07, ["Neon|Fly|Ride"] = 99.68}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 63.15, ["Ride"] = 75, ["Fly|Ride"] = 118.75, ["Neon|Ride"] = 513.51, ["Neon|Fly|Ride"] = 684.15}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 15.9, ["Fly"] = 48.75, ["Ride"] = 56.25, ["Fly|Ride"] = 97.87, ["Neon"] = 67.8, ["Neon|Fly|Ride"] = 600}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2, ["Fly"] = 25.93, ["Ride"] = 14.99, ["Fly|Ride"] = 39.99, ["Neon"] = 2.5, ["Neon|Fly"] = 37.5, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 60.55}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2, ["Fly"] = 14.18, ["Ride"] = 14.62, ["Fly|Ride"] = 30.26, ["Neon"] = 4.78, ["Neon|Fly"] = 26.71, ["Neon|Ride"] = 20.56, ["Neon|Fly|Ride"] = 41.12}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 412.4, ["Fly"] = 651.4, ["Ride"] = 500, ["Fly|Ride"] = 473.75, ["Neon|Ride"] = 2187.5, ["Neon|Fly|Ride"] = 2249.98}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 6.24, ["Ride"] = 51.77, ["Fly|Ride"] = 82.49, ["Neon"] = 31.24, ["Neon|Ride"] = 88.5, ["Neon|Fly|Ride"] = 275}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2, ["Fly"] = 15, ["Ride"] = 16.44, ["Fly|Ride"] = 30, ["Neon"] = 4.72, ["Neon|Fly"] = 23.58, ["Neon|Ride"] = 17.5, ["Neon|Fly|Ride"] = 53.75}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 49.99, ["Ride"] = 100, ["Fly|Ride"] = 235.17, ["Neon"] = 172.5, ["Neon|Ride"] = 268.13, ["Neon|Fly|Ride"] = 548.43}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2, ["Fly"] = 23.5, ["Ride"] = 16.14, ["Fly|Ride"] = 43.64, ["Neon"] = 11.78, ["Neon|Fly"] = 55.47, ["Neon|Ride"] = 32.96, ["Neon|Fly|Ride"] = 81.18}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2, ["Ride"] = 41.84, ["Fly|Ride"] = 187.5, ["Neon"] = 2, ["Neon|Ride"] = 187.5, ["Neon|Fly|Ride"] = 96.55}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 39.97, ["Fly"] = 123.75, ["Ride"] = 74.9, ["Fly|Ride"] = 205.42, ["Neon"] = 203.75, ["Neon|Ride"] = 174.99, ["Neon|Fly|Ride"] = 409.78}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2, ["Ride"] = 23.15, ["Fly|Ride"] = 139.99, ["Neon"] = 6.15, ["Neon|Ride"] = 22.51}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 37.35, ["Ride"] = 68.98, ["Fly|Ride"] = 125, ["Neon"] = 271.25, ["Neon|Ride"] = 228.75, ["Neon|Fly|Ride"] = 274.2}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 3.44, ["Ride"] = 29.99, ["Neon"] = 23.63, ["Neon|Ride"] = 220, ["Neon|Fly|Ride"] = 137.63}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2, ["Ride"] = 77.49, ["Fly|Ride"] = 55.47, ["Neon"] = 8.75, ["Neon|Ride"] = 41.28, ["Neon|Fly|Ride"] = 102.88}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 71.91, ["Ride"] = 87.5, ["Fly|Ride"] = 512.86, ["Neon"] = 318.65, ["Neon|Ride"] = 455.75, ["Neon|Fly|Ride"] = 350}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2, ["Fly"] = 63.75, ["Ride"] = 43.39, ["Neon"] = 4.64, ["Neon|Ride"] = 55.47, ["Neon|Fly|Ride"] = 100}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2, ["Fly"] = 26.71, ["Ride"] = 19.98, ["Fly|Ride"] = 37.5, ["Neon"] = 10, ["Neon|Fly"] = 50, ["Neon|Ride"] = 24.75, ["Neon|Fly|Ride"] = 82.75}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 9.9, ["Fly"] = 55.72, ["Ride"] = 38.5, ["Fly|Ride"] = 188.19, ["Neon"] = 86.15, ["Neon|Ride"] = 97.5, ["Neon|Fly|Ride"] = 201.83}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 7.39, ["Fly"] = 35.64, ["Ride"] = 23.75, ["Fly|Ride"] = 404.82, ["Neon"] = 46.99, ["Neon|Fly"] = 313.94, ["Neon|Ride"] = 56.45, ["Neon|Fly|Ride"] = 130}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 20.79, ["Fly"] = 25, ["Ride"] = 22.5, ["Fly|Ride"] = 54.1, ["Neon"] = 77.24, ["Neon|Ride"] = 81.24, ["Neon|Fly|Ride"] = 137.63}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 74.43, ["Ride"] = 124.5, ["Fly|Ride"] = 187.5, ["Neon"] = 250, ["Neon|Ride"] = 292.5, ["Neon|Fly|Ride"] = 462.5}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 17.32, ["Ride"] = 96.55, ["Fly|Ride"] = 405, ["Neon"] = 62.13, ["Neon|Ride"] = 205.42, ["Neon|Fly|Ride"] = 250}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 3.8, ["Ride"] = 27.74, ["Fly|Ride"] = 75, ["Neon"] = 21.33, ["Neon|Ride"] = 31.15}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 8.74, ["Fly"] = 128.75, ["Ride"] = 48.28, ["Fly|Ride"] = 1352.31, ["Neon"] = 75, ["Neon|Ride"] = 89.17, ["Neon|Fly|Ride"] = 220.8}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2, ["Fly"] = 14.39, ["Ride"] = 11.31, ["Fly|Ride"] = 28.73, ["Neon"] = 2, ["Neon|Fly"] = 37.49, ["Neon|Ride"] = 14.85, ["Neon|Fly|Ride"] = 41.18}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 43.12, ["Fly"] = 156.25, ["Ride"] = 84.61, ["Fly|Ride"] = 242.38, ["Neon"] = 218.25, ["Neon|Fly"] = 2325.27, ["Neon|Ride"] = 237.5, ["Neon|Fly|Ride"] = 410.82}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2, ["Fly"] = 61.25, ["Ride"] = 20.56, ["Fly|Ride"] = 137.2, ["Neon"] = 5.85, ["Neon|Fly"] = 125, ["Neon|Fly|Ride"] = 123.74}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2, ["Fly"] = 19.9, ["Ride"] = 18.64, ["Fly|Ride"] = 43.72, ["Neon"] = 16.86, ["Neon|Ride"] = 27.93, ["Neon|Fly|Ride"] = 88.74}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 53.66, ["Fly"] = 137.63, ["Ride"] = 93.75, ["Fly|Ride"] = 188.13, ["Neon"] = 198.75, ["Neon|Ride"] = 280, ["Neon|Fly|Ride"] = 425}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2, ["Ride"] = 37.5, ["Neon"] = 5.63, ["Neon|Ride"] = 90.38, ["Neon|Fly|Ride"] = 112.4}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 3.7}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2, ["Fly"] = 109.9, ["Ride"] = 34.99, ["Fly|Ride"] = 137.27, ["Neon"] = 4.57, ["Neon|Ride"] = 37.5, ["Neon|Fly|Ride"] = 201.07}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 124.97, ["Ride"] = 173.75, ["Fly|Ride"] = 259.86, ["Neon"] = 500, ["Neon|Ride"] = 599.99, ["Neon|Fly|Ride"] = 646.25}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 2.3, ["Ride"] = 100, ["Fly|Ride"] = 68.75, ["Neon"] = 18.75, ["Neon|Fly"] = 137.63, ["Neon|Ride"] = 63.51, ["Neon|Fly|Ride"] = 156.25}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2, ["Fly"] = 22.6, ["Ride"] = 23.73, ["Neon"] = 2.5, ["Neon|Ride"] = 22.07}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 10, ["Ride"] = 17.5, ["Fly|Ride"] = 96.71, ["Neon"] = 57.41, ["Neon|Ride"] = 87.5, ["Neon|Fly|Ride"] = 157.57}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 10.68, ["Fly"] = 51.88, ["Ride"] = 20.56, ["Fly|Ride"] = 60.6, ["Neon"] = 68.83, ["Neon|Ride"] = 137.63, ["Neon|Fly|Ride"] = 205.76}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 25, ["Ride"] = 61.25, ["Fly|Ride"] = 176.85, ["Neon"] = 123.75, ["Neon|Ride"] = 149.98, ["Neon|Fly|Ride"] = 303.75}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 119.99, ["Fly"] = 187.5, ["Ride"] = 150, ["Fly|Ride"] = 200, ["Neon"] = 587.75, ["Neon|Fly"] = 462.5, ["Neon|Ride"] = 495, ["Neon|Fly|Ride"] = 556.87}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 5.82, ["Fly"] = 20, ["Ride"] = 17.49, ["Fly|Ride"] = 36.25, ["Neon"] = 47.25, ["Neon|Fly"] = 199.99, ["Neon|Ride"] = 37.48, ["Neon|Fly|Ride"] = 77.42}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.5, ["Fly"] = 124.98, ["Ride"] = 69.25, ["Fly|Ride"] = 75, ["Neon"] = 22.48, ["Neon|Ride"] = 37.5, ["Neon|Fly|Ride"] = 123.24}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 3.43, ["Fly"] = 41.14, ["Ride"] = 39.2, ["Fly|Ride"] = 39.15, ["Neon"] = 43.74, ["Neon|Fly"] = 122.5, ["Neon|Ride"] = 53.98, ["Neon|Fly|Ride"] = 141.73}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 45, ["Fly"] = 117.59, ["Ride"] = 88.73, ["Fly|Ride"] = 149.99, ["Neon"] = 214.73, ["Neon|Ride"] = 227.95, ["Neon|Fly|Ride"] = 350}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 21.6, ["Ride"] = 180.89, ["Neon"] = 212.49, ["Neon|Ride"] = 246.48, ["Neon|Fly|Ride"] = 426.22}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 224.87, ["Ride"] = 315.3, ["Fly|Ride"] = 375, ["Neon"] = 1250, ["Neon|Ride"] = 1568.5, ["Neon|Fly|Ride"] = 1410.95}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 20.14, ["Fly"] = 62.5, ["Ride"] = 27.64, ["Fly|Ride"] = 56.25, ["Neon"] = 137.63, ["Neon|Ride"] = 142.5, ["Neon|Fly|Ride"] = 187.48}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2, ["Fly"] = 40.8, ["Ride"] = 12.5, ["Fly|Ride"] = 32.5, ["Neon"] = 2, ["Neon|Ride"] = 15.62, ["Neon|Fly|Ride"] = 55.38}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 2, ["Ride"] = 23.75, ["Neon"] = 12.86, ["Neon|Ride"] = 500, ["Neon|Fly|Ride"] = 157.57}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 2, ["Ride"] = 48.28, ["Fly|Ride"] = 190.04, ["Neon"] = 21.23, ["Neon|Ride"] = 68.83, ["Neon|Fly|Ride"] = 1125}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 406.15, ["Fly"] = 375, ["Ride"] = 435, ["Fly|Ride"] = 537.5, ["Neon"] = 1780.83, ["Neon|Ride"] = 1509.18, ["Neon|Fly|Ride"] = 1632.68}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 3.75, ["Ride"] = 17.5, ["Fly|Ride"] = 46.25, ["Neon"] = 22.22, ["Neon|Ride"] = 55.41, ["Neon|Fly|Ride"] = 108.39}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 4.91, ["Fly"] = 26.71, ["Ride"] = 18.84, ["Fly|Ride"] = 37.5, ["Neon"] = 48.75, ["Neon|Fly"] = 149, ["Neon|Ride"] = 67.8, ["Neon|Fly|Ride"] = 82.17}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 3.91, ["Fly"] = 43.75, ["Ride"] = 23.59, ["Fly|Ride"] = 56.25, ["Neon"] = 14.02, ["Neon|Fly"] = 89.98, ["Neon|Ride"] = 33.75, ["Neon|Fly|Ride"] = 121.25}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 28.53, ["Fly"] = 86.23, ["Ride"] = 32.5, ["Fly|Ride"] = 134.54, ["Neon"] = 160, ["Neon|Ride"] = 207.02, ["Neon|Fly|Ride"] = 312.5}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2, ["Fly"] = 37.5, ["Ride"] = 32.87, ["Fly|Ride"] = 50.39, ["Neon"] = 18.75, ["Neon|Ride"] = 102.48, ["Neon|Fly|Ride"] = 138.75}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 12.59, ["Fly"] = 68.83, ["Ride"] = 47.04, ["Neon"] = 174.02, ["Neon|Ride"] = 152.01, ["Neon|Fly|Ride"] = 246.48}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2, ["Ride"] = 16.25, ["Fly|Ride"] = 137.63, ["Neon"] = 6.08, ["Neon|Ride"] = 137.63, ["Neon|Fly|Ride"] = 102.71}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 12.5, ["Neon"] = 65}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 12.5, ["Ride"] = 79.99, ["Fly|Ride"] = 117.09, ["Neon"] = 65.22, ["Neon|Ride"] = 94.07, ["Neon|Fly|Ride"] = 138.66}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 6.04, ["Fly"] = 26.25, ["Ride"] = 22.49, ["Fly|Ride"] = 47.75, ["Neon"] = 46.25, ["Neon|Fly"] = 87.5, ["Neon|Ride"] = 57.59, ["Neon|Fly|Ride"] = 102.49}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 365.04, ["Fly"] = 564.39, ["Ride"] = 411.05, ["Fly|Ride"] = 431.25, ["Neon"] = 1250, ["Neon|Fly"] = 1974.18, ["Neon|Ride"] = 3399.99, ["Neon|Fly|Ride"] = 1562.5}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.5, ["Fly"] = 27.74, ["Ride"] = 15.36, ["Fly|Ride"] = 34.91, ["Neon"] = 14.2, ["Neon|Fly"] = 78.81, ["Neon|Ride"] = 30.41, ["Neon|Fly|Ride"] = 188.13}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 13.82, ["Ride"] = 37.5, ["Fly|Ride"] = 188.13, ["Neon"] = 80, ["Neon|Fly"] = 162.5, ["Neon|Ride"] = 147.5, ["Neon|Fly|Ride"] = 375}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 22.71, ["Ride"] = 77.85, ["Fly|Ride"] = 246.16, ["Neon"] = 66.18, ["Neon|Ride"] = 152.39, ["Neon|Fly|Ride"] = 178.7}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 51.36, ["Fly"] = 161.14, ["Ride"] = 67.5, ["Fly|Ride"] = 125.23, ["Neon"] = 322.49, ["Neon|Ride"] = 318.75, ["Neon|Fly|Ride"] = 362.5}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 13.48, ["Ride"] = 56.77, ["Fly|Ride"] = 127.69, ["Neon"] = 78.8, ["Neon|Ride"] = 77.5, ["Neon|Fly|Ride"] = 182.5}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2, ["Fly"] = 25, ["Ride"] = 16.25, ["Fly|Ride"] = 56.25, ["Neon"] = 17.5, ["Neon|Ride"] = 31.93, ["Neon|Fly|Ride"] = 117.09}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 5.68, ["Ride"] = 23.32, ["Neon"] = 19.45, ["Neon|Ride"] = 58.1, ["Neon|Fly|Ride"] = 143.75}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 56.23, ["Fly"] = 163.26, ["Ride"] = 86.61, ["Fly|Ride"] = 154.99, ["Neon"] = 112.5, ["Neon|Ride"] = 150, ["Neon|Fly|Ride"] = 268.75}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2, ["Ride"] = 92.5, ["Neon"] = 8.23, ["Neon|Ride"] = 68.83, ["Neon|Fly|Ride"] = 226.7}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 35, ["Fly"] = 57.68, ["Ride"] = 212.5, ["Neon"] = 137.63, ["Neon|Fly"] = 470.33, ["Neon|Ride"] = 397.46}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 893.75, ["Fly"] = 1137.5, ["Ride"] = 890, ["Fly|Ride"] = 1083.45, ["Neon"] = 4107.8, ["Neon|Ride"] = 2500, ["Neon|Fly|Ride"] = 2750}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 13.63, ["Fly"] = 137.63, ["Ride"] = 79.66, ["Fly|Ride"] = 205.95, ["Neon"] = 157.62, ["Neon|Fly"] = 616.17, ["Neon|Ride"] = 185.67}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.14, ["Fly"] = 49.96, ["Ride"] = 21.25, ["Fly|Ride"] = 55.8, ["Neon"] = 9.9, ["Neon|Fly"] = 37.5, ["Neon|Ride"] = 31.74, ["Neon|Fly|Ride"] = 74.91}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 18.65, ["Ride"] = 76.02, ["Fly|Ride"] = 137.63, ["Neon"] = 73.96, ["Neon|Fly|Ride"] = 374.98}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2, ["Fly"] = 20.56, ["Ride"] = 20, ["Fly|Ride"] = 51.29, ["Neon"] = 2, ["Neon|Ride"] = 24.92, ["Neon|Fly|Ride"] = 125}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 52.49, ["Ride"] = 93.64, ["Fly|Ride"] = 260.87, ["Neon"] = 230, ["Neon|Ride"] = 280.89, ["Neon|Fly|Ride"] = 387.5}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 20.35, ["Ride"] = 137.63, ["Fly|Ride"] = 822.38, ["Neon"] = 138.12, ["Neon|Ride"] = 245.46, ["Neon|Fly|Ride"] = 279.86}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2, ["Ride"] = 26.25, ["Neon"] = 11.25, ["Neon|Ride"] = 41.09, ["Neon|Fly|Ride"] = 205.76}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 17.59, ["Fly"] = 49.99, ["Ride"] = 37.4, ["Fly|Ride"] = 71.25, ["Neon"] = 87.32, ["Neon|Fly"] = 175, ["Neon|Ride"] = 112.5, ["Neon|Fly|Ride"] = 112.5}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 3.91, ["Fly"] = 31.85, ["Ride"] = 25, ["Fly|Ride"] = 63.52, ["Neon"] = 17.5, ["Neon|Fly"] = 125, ["Neon|Ride"] = 47.5, ["Neon|Fly|Ride"] = 95}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 37.62, ["Ride"] = 47.04, ["Neon"] = 375, ["Neon|Ride"] = 309.34, ["Neon|Fly|Ride"] = 675}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 3.7, ["Ride"] = 68.75, ["Fly|Ride"] = 515.56, ["Neon"] = 18.75, ["Neon|Ride"] = 62.5, ["Neon|Fly|Ride"] = 107.01}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 7.41, ["Fly"] = 48.28, ["Ride"] = 18.57, ["Fly|Ride"] = 55.47, ["Neon"] = 31.79, ["Neon|Fly"] = 178.7, ["Neon|Ride"] = 67.48, ["Neon|Fly|Ride"] = 100.17}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 125, ["Fly"] = 144.63, ["Ride"] = 169.3, ["Fly|Ride"] = 220, ["Neon"] = 526.1, ["Neon|Fly"] = 800, ["Neon|Ride"] = 499.99, ["Neon|Fly|Ride"] = 518.74}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2, ["Fly"] = 33.7, ["Ride"] = 16.44, ["Fly|Ride"] = 43.74, ["Neon"] = 10, ["Neon|Fly"] = 54.97, ["Neon|Ride"] = 47.02, ["Neon|Fly|Ride"] = 68.66}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 34.58, ["Fly"] = 75, ["Ride"] = 57.5, ["Fly|Ride"] = 121.19, ["Neon"] = 149.9, ["Neon|Ride"] = 267.99, ["Neon|Fly|Ride"] = 293.75}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2, ["Fly"] = 18.37, ["Ride"] = 12.5, ["Fly|Ride"] = 58.65, ["Neon"] = 2.13, ["Neon|Fly"] = 29.72, ["Neon|Ride"] = 15.48, ["Neon|Fly|Ride"] = 55.47}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2, ["Neon"] = 8.22, ["Neon|Fly|Ride"] = 127.19}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2, ["Fly"] = 34.99, ["Ride"] = 62.5, ["Fly|Ride"] = 123.62, ["Neon"] = 11.24, ["Neon|Ride"] = 55.47, ["Neon|Fly|Ride"] = 175}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 29.88, ["Fly|Ride"] = 625, ["Neon"] = 165, ["Neon|Ride"] = 314.48, ["Neon|Fly|Ride"] = 412.5}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 3.34, ["Fly"] = 23.63, ["Ride"] = 14.99, ["Fly|Ride"] = 27.72, ["Neon"] = 11.25, ["Neon|Fly"] = 25, ["Neon|Ride"] = 29.99, ["Neon|Fly|Ride"] = 53.73}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 8.75, ["Fly"] = 53.75, ["Ride"] = 34.44, ["Fly|Ride"] = 121.45, ["Neon"] = 58.63, ["Neon|Fly"] = 122.23, ["Neon|Ride"] = 42.5, ["Neon|Fly|Ride"] = 126.39}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2, ["Fly"] = 27.11, ["Ride"] = 17.4, ["Fly|Ride"] = 42.5, ["Neon"] = 12.24, ["Neon|Fly"] = 93.74, ["Neon|Ride"] = 25.71, ["Neon|Fly|Ride"] = 61.25}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 11.13, ["Fly"] = 112.49, ["Ride"] = 39.9, ["Fly|Ride"] = 206.95, ["Neon"] = 44.7, ["Neon|Ride"] = 62.5, ["Neon|Fly|Ride"] = 175}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 3.53, ["Fly"] = 87.5, ["Ride"] = 54.88, ["Fly|Ride"] = 225, ["Neon"] = 62.47, ["Neon|Ride"] = 250}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 4.72, ["Fly"] = 71.77, ["Ride"] = 16.25, ["Fly|Ride"] = 55.47, ["Neon"] = 26.24, ["Neon|Fly"] = 187.5, ["Neon|Ride"] = 47.33, ["Neon|Fly|Ride"] = 109.99}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2, ["Fly"] = 25.51, ["Ride"] = 17.5, ["Fly|Ride"] = 37.5, ["Neon"] = 17.5, ["Neon|Fly"] = 73.95, ["Neon|Ride"] = 18.82, ["Neon|Fly|Ride"] = 62.49}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 209.98, ["Fly"] = 375, ["Ride"] = 251.62, ["Fly|Ride"] = 369.99, ["Neon"] = 1264.25, ["Neon|Ride"] = 1164.63, ["Neon|Fly|Ride"] = 1118.75}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 4.99, ["Ride"] = 108.73, ["Neon"] = 50}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 4, ["Fly"] = 102.71, ["Ride"] = 17.69, ["Fly|Ride"] = 82.16, ["Neon"] = 66.25, ["Neon|Fly"] = 246.48, ["Neon|Ride"] = 62.5, ["Neon|Fly|Ride"] = 137.87}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 5.62, ["Fly|Ride"] = 684.15, ["Neon"] = 67.49, ["Neon|Ride"] = 274.21, ["Neon|Fly|Ride"] = 574.99}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2, ["Fly"] = 14.34, ["Ride"] = 15.41, ["Fly|Ride"] = 30.88, ["Neon"] = 2.49, ["Neon|Fly"] = 27.74, ["Neon|Ride"] = 15.65, ["Neon|Fly|Ride"] = 41.09}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 3.46, ["Fly"] = 57.38, ["Ride"] = 17.48, ["Fly|Ride"] = 86.24, ["Neon"] = 17.5, ["Neon|Ride"] = 28.11, ["Neon|Fly|Ride"] = 78.2}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2, ["Ride"] = 120.06, ["Neon"] = 7.5, ["Neon|Ride"] = 274.21, ["Neon|Fly|Ride"] = 1000}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 68.83, ["Fly"] = 103.47, ["Ride"] = 78.88, ["Fly|Ride"] = 137.5, ["Neon"] = 533.37, ["Neon|Ride"] = 356.25, ["Neon|Fly|Ride"] = 412.5}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 3.75, ["Fly"] = 99.99, ["Ride"] = 21.81, ["Fly|Ride"] = 135.41, ["Neon"] = 17.67, ["Neon|Ride"] = 70.69, ["Neon|Fly|Ride"] = 135.59}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2, ["Fly"] = 87.5, ["Ride"] = 47.19, ["Neon"] = 7.28, ["Neon|Ride"] = 147.5, ["Neon|Fly|Ride"] = 274.22}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 39.9, ["Fly"] = 100, ["Ride"] = 81.21, ["Fly|Ride"] = 173.75, ["Neon"] = 129.99, ["Neon|Ride"] = 162.5, ["Neon|Fly|Ride"] = 262.5}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2, ["Fly"] = 15.44, ["Ride"] = 13.44, ["Fly|Ride"] = 31.15, ["Neon"] = 2.47, ["Neon|Fly"] = 27.06, ["Neon|Ride"] = 15.63, ["Neon|Fly|Ride"] = 34.92}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2, ["Ride"] = 50, ["Neon"] = 4.11, ["Neon|Ride"] = 49.01, ["Neon|Fly|Ride"] = 96.56}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.33, ["Ride"] = 46.25, ["Fly|Ride"] = 110.23, ["Neon"] = 10, ["Neon|Ride"] = 89.28, ["Neon|Fly|Ride"] = 106.23}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 6.25, ["Fly"] = 36.06, ["Ride"] = 37.5, ["Fly|Ride"] = 133.43, ["Neon"] = 18.74, ["Neon|Fly"] = 37.5, ["Neon|Ride"] = 82.38, ["Neon|Fly|Ride"] = 118.75}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2, ["Fly"] = 14.42, ["Ride"] = 13.52, ["Fly|Ride"] = 30.76, ["Neon"] = 2.38, ["Neon|Fly"] = 20.56, ["Neon|Ride"] = 18.74, ["Neon|Fly|Ride"] = 43.11}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 25.9, ["Fly"] = 469.93, ["Ride"] = 79.62, ["Neon"] = 132.41, ["Neon|Ride"] = 138.75, ["Neon|Fly|Ride"] = 1250}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2374.99, ["Fly"] = 3000, ["Ride"] = 2061.15, ["Fly|Ride"] = 2026.44, ["Neon|Fly|Ride"] = 7062.5}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2, ["Fly"] = 29.95, ["Ride"] = 14.99, ["Fly|Ride"] = 42.46, ["Neon"] = 7.5, ["Neon|Fly"] = 47.5, ["Neon|Ride"] = 22.47, ["Neon|Fly|Ride"] = 60.4}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.29, ["Ride"] = 62.5, ["Neon"] = 10.8, ["Neon|Ride"] = 137.63}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 14.53, ["Fly"] = 100, ["Ride"] = 24.91, ["Fly|Ride"] = 127.5, ["Neon"] = 98.13, ["Neon|Ride"] = 108.74, ["Neon|Fly|Ride"] = 277.5}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 29.7, ["Fly"] = 130.44, ["Ride"] = 75, ["Fly|Ride"] = 138.43, ["Neon"] = 178.7, ["Neon|Ride"] = 131.55, ["Neon|Fly|Ride"] = 274.22}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 115.9, ["Fly"] = 522.3, ["Ride"] = 165.59, ["Fly|Ride"] = 267.83, ["Neon"] = 676.8, ["Neon|Ride"] = 577.44, ["Neon|Fly|Ride"] = 575}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 5, ["Ride"] = 29.98, ["Fly|Ride"] = 645, ["Neon"] = 18.82, ["Neon|Ride"] = 68.83, ["Neon|Fly|Ride"] = 250}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.5, ["Ride"] = 84.22, ["Neon"] = 22.17, ["Neon|Ride"] = 109.9}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2, ["Fly"] = 96.71, ["Ride"] = 27.72, ["Fly|Ride"] = 82.17, ["Neon"] = 5.57, ["Neon|Fly"] = 96.55, ["Neon|Ride"] = 34.96, ["Neon|Fly|Ride"] = 137.87}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 12.78, ["Ride"] = 94.1, ["Fly|Ride"] = 125, ["Neon"] = 125, ["Neon|Ride"] = 1178.32, ["Neon|Fly|Ride"] = 347.5}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2, ["Ride"] = 22.79, ["Neon"] = 2, ["Neon|Ride"] = 55.18}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 94.13, ["Fly"] = 784.26, ["Ride"] = 118.75, ["Fly|Ride"] = 191.04, ["Neon"] = 350, ["Neon|Fly"] = 441.32, ["Neon|Ride"] = 403.9, ["Neon|Fly|Ride"] = 479.62}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2, ["Fly"] = 40.41, ["Ride"] = 34.93, ["Neon"] = 24.92, ["Neon|Ride"] = 157.57, ["Neon|Fly|Ride"] = 98.01}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 32.48, ["Fly"] = 79.62, ["Ride"] = 56.24, ["Fly|Ride"] = 214.01, ["Neon"] = 223.74, ["Neon|Ride"] = 247.23, ["Neon|Fly|Ride"] = 487.5}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2, ["Fly"] = 27.92, ["Ride"] = 18.7, ["Fly|Ride"] = 51.65, ["Neon"] = 5.79, ["Neon|Fly"] = 78.8, ["Neon|Ride"] = 30.63, ["Neon|Fly|Ride"] = 79.97}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2, ["Neon"] = 7.95, ["Neon|Ride"] = 81.25}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 4.71, ["Fly"] = 27.79, ["Ride"] = 26.71, ["Fly|Ride"] = 87.17, ["Neon"] = 23.75, ["Neon|Fly"] = 102.71, ["Neon|Ride"] = 56.25, ["Neon|Fly|Ride"] = 118.75}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 324.79, ["Fly"] = 705.48, ["Ride"] = 349.45, ["Fly|Ride"] = 421.06, ["Neon"] = 812.5, ["Neon|Ride"] = 879.49, ["Neon|Fly|Ride"] = 951.55}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 30.63, ["Ride"] = 41.21, ["Fly|Ride"] = 88.34, ["Neon"] = 137.27, ["Neon|Ride"] = 164.33, ["Neon|Fly|Ride"] = 205}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.5, ["Fly"] = 61.62, ["Ride"] = 28.65, ["Fly|Ride"] = 62.41, ["Neon"] = 37.5, ["Neon|Fly"] = 96.25, ["Neon|Ride"] = 45, ["Neon|Fly|Ride"] = 124.81}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 18.71, ["Fly"] = 89.36, ["Ride"] = 81.24, ["Fly|Ride"] = 143.79, ["Neon"] = 73.48, ["Neon|Fly"] = 410.82, ["Neon|Ride"] = 96.83, ["Neon|Fly|Ride"] = 247.49}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 6, ["Ride"] = 17.49, ["Neon"] = 137.63, ["Neon|Ride"] = 117.63, ["Neon|Fly|Ride"] = 187.5}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 2, ["Fly|Ride"] = 137.63, ["Neon"] = 9.49, ["Neon|Ride"] = 149.99, ["Neon|Fly|Ride"] = 141.12}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 3.53, ["Fly"] = 68.83, ["Ride"] = 18.62, ["Fly|Ride"] = 62.5, ["Neon"] = 56.24, ["Neon|Fly"] = 82.16, ["Neon|Ride"] = 56.25, ["Neon|Fly|Ride"] = 238.74}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 93.74, ["Fly"] = 235.24, ["Ride"] = 122.5, ["Fly|Ride"] = 150, ["Neon"] = 738.46, ["Neon|Ride"] = 549.22, ["Neon|Fly|Ride"] = 533.31}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 26.25, ["Ride"] = 90, ["Fly|Ride"] = 92.49, ["Neon"] = 112.5, ["Neon|Ride"] = 200, ["Neon|Fly|Ride"] = 302.97}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 1585, ["Fly"] = 1960.29, ["Ride"] = 1625, ["Fly|Ride"] = 1625, ["Neon"] = 10973.71, ["Neon|Ride"] = 6584.4, ["Neon|Fly|Ride"] = 6268.75}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 6.25, ["Fly"] = 125000, ["Ride"] = 104.99, ["Fly|Ride"] = 187.29, ["Neon"] = 40.03, ["Neon|Fly|Ride"] = 250}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 4.71, ["Ride"] = 59.91, ["Fly|Ride"] = 104.72, ["Neon"] = 50, ["Neon|Ride"] = 60.02, ["Neon|Fly|Ride"] = 201.07}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 1013.5, ["Fly"] = 1078.52, ["Ride"] = 874.99, ["Fly|Ride"] = 900, ["Neon"] = 2646.25, ["Neon|Ride"] = 2891.83, ["Neon|Fly|Ride"] = 2787.5}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 33.21, ["Ride"] = 58.45, ["Fly|Ride"] = 100, ["Neon"] = 152.52, ["Neon|Ride"] = 178.7, ["Neon|Fly|Ride"] = 260.87}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 2.14, ["Ride"] = 22.5, ["Fly|Ride"] = 137.63, ["Neon"] = 14.24, ["Neon|Fly"] = 157.62, ["Neon|Ride"] = 31.25, ["Neon|Fly|Ride"] = 312.5}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2, ["Fly"] = 55.47, ["Ride"] = 137.87, ["Neon"] = 3.53, ["Neon|Ride"] = 50, ["Neon|Fly|Ride"] = 106.82}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 76.9, ["Ride"] = 137.49, ["Fly|Ride"] = 205.42, ["Neon"] = 437.5, ["Neon|Ride"] = 587.9, ["Neon|Fly|Ride"] = 548.43}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 3.75, ["Ride"] = 28.48, ["Fly|Ride"] = 69.38, ["Neon"] = 11.25, ["Neon|Ride"] = 40, ["Neon|Fly|Ride"] = 102.71}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 81.25, ["Ride"] = 100.95, ["Neon"] = 575.13, ["Neon|Ride"] = 687.5}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 4.98, ["Fly"] = 100, ["Ride"] = 114.2, ["Fly|Ride"] = 97.99, ["Neon"] = 48.33, ["Neon|Ride"] = 125, ["Neon|Fly|Ride"] = 123.75}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 278.89, ["Ride"] = 293.74, ["Fly|Ride"] = 369.99, ["Neon"] = 1245.73, ["Neon|Ride"] = 1246.34, ["Neon|Fly|Ride"] = 887.5}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 3.74, ["Fly"] = 47.04, ["Ride"] = 20.56, ["Fly|Ride"] = 68.75, ["Neon"] = 31.25, ["Neon|Fly"] = 125, ["Neon|Ride"] = 41.25, ["Neon|Fly|Ride"] = 121.19}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2, ["Fly"] = 24.98, ["Ride"] = 14.8, ["Fly|Ride"] = 37.87, ["Neon"] = 5.31, ["Neon|Fly"] = 27.82, ["Neon|Ride"] = 18.64, ["Neon|Fly|Ride"] = 49.48}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 967.5, ["Ride"] = 1125, ["Fly|Ride"] = 958.92, ["Neon|Ride"] = 7522.49, ["Neon|Fly|Ride"] = 7362.4}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 13.18, ["Fly"] = 131.68, ["Ride"] = 90, ["Neon"] = 80, ["Neon|Ride"] = 300}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 5.8, ["Fly"] = 52.29, ["Ride"] = 32.85, ["Fly|Ride"] = 73.75, ["Neon"] = 25.35, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 96.04}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 28.71, ["Fly"] = 35, ["Ride"] = 32.47, ["Fly|Ride"] = 72.41, ["Neon"] = 273.83, ["Neon|Ride"] = 161.24, ["Neon|Fly|Ride"] = 137.5}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 12.23, ["Fly"] = 68.83, ["Ride"] = 33.14, ["Fly|Ride"] = 68.75, ["Neon"] = 60, ["Neon|Ride"] = 96.55, ["Neon|Fly|Ride"] = 178.7}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 60, ["Ride"] = 259.86, ["Fly|Ride"] = 516.06, ["Neon"] = 410.82, ["Neon|Ride"] = 499.99, ["Neon|Fly|Ride"] = 987.5}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2, ["Ride"] = 111.06, ["Neon"] = 2.48, ["Neon|Fly"] = 55.63, ["Neon|Ride"] = 109.89, ["Neon|Fly|Ride"] = 96.55}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 115, ["Fly"] = 162.5, ["Ride"] = 137.5, ["Fly|Ride"] = 212.5, ["Neon"] = 500, ["Neon|Ride"] = 461.25, ["Neon|Fly|Ride"] = 603.75}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 3.55, ["Fly"] = 37.5, ["Ride"] = 19.46, ["Fly|Ride"] = 67.48, ["Neon"] = 218.74, ["Neon|Ride"] = 79.99, ["Neon|Fly|Ride"] = 125}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2, ["Fly"] = 18.65, ["Ride"] = 15.41, ["Fly|Ride"] = 37.48, ["Neon"] = 13.75, ["Neon|Fly"] = 78.81, ["Neon|Ride"] = 62.41, ["Neon|Fly|Ride"] = 117}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 3.09, ["Ride"] = 120.05, ["Neon"] = 35, ["Neon|Fly"] = 135.57, ["Neon|Fly|Ride"] = 204.13}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 114.98, ["Ride"] = 187.5, ["Fly|Ride"] = 375, ["Neon"] = 515, ["Neon|Ride"] = 819.55, ["Neon|Fly|Ride"] = 734.99}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 3.45, ["Ride"] = 125, ["Neon"] = 18.65, ["Neon|Ride"] = 75}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2, ["Ride"] = 26.21, ["Neon"] = 2.49, ["Neon|Fly"] = 37.5, ["Neon|Ride"] = 23.63}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2, ["Fly"] = 96.42, ["Ride"] = 24.98, ["Fly|Ride"] = 137.63, ["Neon"] = 2, ["Neon|Fly"] = 82.09, ["Neon|Ride"] = 27.74, ["Neon|Fly|Ride"] = 147.53}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2, ["Fly"] = 35, ["Ride"] = 15.46, ["Fly|Ride"] = 48.28, ["Neon"] = 5.44, ["Neon|Ride"] = 21.13, ["Neon|Fly|Ride"] = 70}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2, ["Ride"] = 16.24, ["Fly|Ride"] = 109.9, ["Neon"] = 12.5}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2, ["Fly"] = 37.5, ["Ride"] = 17.35, ["Fly|Ride"] = 40.76, ["Neon"] = 12.23, ["Neon|Fly"] = 82.07, ["Neon|Ride"] = 39, ["Neon|Fly|Ride"] = 77.42}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 57.25, ["Fly|Ride"] = 273.01, ["Neon"] = 218.73, ["Neon|Ride"] = 346.87, ["Neon|Fly|Ride"] = 602.86}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2, ["Fly"] = 15.85, ["Ride"] = 18.53, ["Fly|Ride"] = 34.89, ["Neon"] = 2, ["Neon|Fly"] = 18.49, ["Neon|Ride"] = 20.12, ["Neon|Fly|Ride"] = 51.36}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 7.5, ["Fly"] = 57.32, ["Ride"] = 25, ["Fly|Ride"] = 82.15, ["Neon"] = 28.75, ["Neon|Fly"] = 56.23, ["Neon|Ride"] = 78.07, ["Neon|Fly|Ride"] = 113.75}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 26.71, ["Fly"] = 52.5, ["Ride"] = 43.22, ["Fly|Ride"] = 92.81, ["Neon"] = 162.85, ["Neon|Ride"] = 126.25, ["Neon|Fly|Ride"] = 225}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 16.25, ["Fly"] = 199.98, ["Neon"] = 110}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2, ["Fly"] = 19.57, ["Ride"] = 14.75, ["Fly|Ride"] = 40.06, ["Neon"] = 6.06, ["Neon|Fly"] = 27.81, ["Neon|Ride"] = 19.65, ["Neon|Fly|Ride"] = 52.47}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 13.45, ["Ride"] = 53.41, ["Neon"] = 45, ["Neon|Ride"] = 342.9, ["Neon|Fly|Ride"] = 397.46}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 860.91, ["Ride"] = 912.49, ["Fly|Ride"] = 937.5, ["Neon"] = 2498.75, ["Neon|Ride"] = 1968.74, ["Neon|Fly|Ride"] = 1937.5}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 212.5, ["Ride"] = 250, ["Fly|Ride"] = 470.14, ["Neon"] = 700, ["Neon|Ride"] = 821.61, ["Neon|Fly|Ride"] = 993.75}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.49, ["Ride"] = 28.75, ["Neon"] = 9.75, ["Neon|Ride"] = 106.25, ["Neon|Fly|Ride"] = 274.68}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 187.5, ["Ride"] = 262.49, ["Fly|Ride"] = 338.43, ["Neon"] = 750, ["Neon|Ride"] = 675, ["Neon|Fly|Ride"] = 955.94}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 2, ["Ride"] = 23.96, ["Fly|Ride"] = 89.36, ["Neon"] = 16.36, ["Neon|Fly"] = 50, ["Neon|Ride"] = 37.4, ["Neon|Fly|Ride"] = 137.63}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 225, ["Fly"] = 304.12, ["Ride"] = 250, ["Fly|Ride"] = 331.25, ["Neon"] = 1095.82, ["Neon|Ride"] = 1062.5, ["Neon|Fly|Ride"] = 900}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2, ["Fly"] = 75, ["Ride"] = 23.75, ["Fly|Ride"] = 112.5, ["Neon"] = 25, ["Neon|Ride"] = 55.47, ["Neon|Fly|Ride"] = 125}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2, ["Neon"] = 27.49}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 17.65, ["Fly"] = 50, ["Ride"] = 68.83, ["Fly|Ride"] = 137.45, ["Neon"] = 87.5, ["Neon|Fly"] = 410.78, ["Neon|Ride"] = 118.75, ["Neon|Fly|Ride"] = 205.42}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.5, ["Ride"] = 27.82, ["Neon"] = 27.75, ["Neon|Ride"] = 187.5}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2, ["Fly"] = 16.25, ["Ride"] = 12.33, ["Fly|Ride"] = 27.49, ["Neon"] = 3.57, ["Neon|Fly"] = 26.6, ["Neon|Ride"] = 23.74, ["Neon|Fly|Ride"] = 38.57}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4031.25, ["Ride"] = 4374.99, ["Fly|Ride"] = 3937.5, ["Neon"] = 30771, ["Neon|Fly|Ride"] = 23464.85}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 10.15, ["Fly"] = 82.17, ["Ride"] = 40, ["Neon"] = 94.99, ["Neon|Fly"] = 365.16, ["Neon|Ride"] = 96.81, ["Neon|Fly|Ride"] = 179.74}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2, ["Fly"] = 23.69, ["Ride"] = 17.4, ["Fly|Ride"] = 48.26, ["Neon"] = 13.69, ["Neon|Fly"] = 43.74, ["Neon|Ride"] = 21.24, ["Neon|Fly|Ride"] = 56.25}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 393.74, ["Fly"] = 489.27, ["Ride"] = 398.75, ["Fly|Ride"] = 472.5, ["Neon"] = 1436.75, ["Neon|Fly"] = 1100, ["Neon|Ride"] = 1231.25, ["Neon|Fly|Ride"] = 1186.25}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 3.75, ["Ride"] = 47.01, ["Neon"] = 47.01, ["Neon|Ride"] = 137.63, ["Neon|Fly|Ride"] = 375}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 4.38, ["Fly"] = 4099.49, ["Ride"] = 34.92, ["Neon"] = 68.83, ["Neon|Ride"] = 100, ["Neon|Fly|Ride"] = 237.5}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2, ["Fly"] = 68.94, ["Ride"] = 20, ["Fly|Ride"] = 62.49, ["Neon"] = 6.25, ["Neon|Fly"] = 118.75, ["Neon|Ride"] = 137.45, ["Neon|Fly|Ride"] = 87.39}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 572.5, ["Fly"] = 835.99, ["Ride"] = 625, ["Fly|Ride"] = 655.6, ["Neon|Ride"] = 2025.01, ["Neon|Fly|Ride"] = 1999.99}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 17.4, ["Fly"] = 158.4, ["Ride"] = 118.75, ["Fly|Ride"] = 329.47, ["Neon"] = 58.75, ["Neon|Ride"] = 125}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 4.67, ["Fly"] = 41.07, ["Ride"] = 36.89, ["Neon"] = 20.53, ["Neon|Ride"] = 55, ["Neon|Fly|Ride"] = 121.25}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.5, ["Fly"] = 37.5, ["Ride"] = 20.56, ["Fly|Ride"] = 40.88, ["Neon"] = 16.58, ["Neon|Fly"] = 39.08, ["Neon|Ride"] = 23.74, ["Neon|Fly|Ride"] = 79.74}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 23.75, ["Fly"] = 96.55, ["Ride"] = 37.92, ["Fly|Ride"] = 62.5, ["Neon"] = 81.25, ["Neon|Ride"] = 108.64}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2, ["Ride"] = 41.25, ["Neon"] = 3.65, ["Neon|Ride"] = 28.46, ["Neon|Fly|Ride"] = 198.75}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 499.9, ["Ride"] = 593.75, ["Fly|Ride"] = 624.75, ["Neon"] = 2469.17, ["Neon|Ride"] = 2655.83, ["Neon|Fly|Ride"] = 2373.99}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2, ["Ride"] = 52.5, ["Fly|Ride"] = 274.22, ["Neon"] = 12.99, ["Neon|Ride"] = 55.56, ["Neon|Fly|Ride"] = 193.74}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2, ["Ride"] = 49.94, ["Fly|Ride"] = 187.5, ["Neon"] = 4.9, ["Neon|Fly|Ride"] = 250}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2, ["Ride"] = 33.75, ["Neon"] = 4.79, ["Neon|Ride"] = 52.9, ["Neon|Fly|Ride"] = 274.22}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2, ["Ride"] = 23.74, ["Neon"] = 12.39, ["Neon|Ride"] = 152.26, ["Neon|Fly|Ride"] = 99.38}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 33.5, ["Fly"] = 78.75, ["Ride"] = 70.81, ["Fly|Ride"] = 155, ["Neon"] = 155.11, ["Neon|Ride"] = 274.22, ["Neon|Fly|Ride"] = 406.25}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 16.68, ["Ride"] = 50, ["Fly|Ride"] = 112.5, ["Neon"] = 83.99, ["Neon|Ride"] = 200, ["Neon|Fly|Ride"] = 225}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2, ["Fly"] = 22.49, ["Ride"] = 14.52, ["Fly|Ride"] = 35.62, ["Neon"] = 18.56, ["Neon|Ride"] = 27.74, ["Neon|Fly|Ride"] = 81.16}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 13.24, ["Ride"] = 37.28, ["Neon"] = 85, ["Neon|Ride"] = 138.52}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2, ["Ride"] = 25, ["Fly|Ride"] = 106.24, ["Neon"] = 11.15, ["Neon|Ride"] = 51.77, ["Neon|Fly|Ride"] = 121.27}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 21.25, ["Fly"] = 110.54, ["Ride"] = 41.63, ["Fly|Ride"] = 52.5, ["Neon"] = 123.75, ["Neon|Ride"] = 137.5, ["Neon|Fly|Ride"] = 161.88}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 30.9, ["Fly"] = 92.5, ["Neon"] = 137.5}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 48.65, ["Fly"] = 137.63, ["Ride"] = 73.75, ["Fly|Ride"] = 121.9, ["Neon"] = 186.25, ["Neon|Ride"] = 250, ["Neon|Fly|Ride"] = 424.51}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 34.98, ["Fly"] = 137.63, ["Ride"] = 62.5, ["Fly|Ride"] = 97.5, ["Neon"] = 125, ["Neon|Ride"] = 187.4, ["Neon|Fly|Ride"] = 312.5}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 17.79, ["Ride"] = 149.99, ["Neon"] = 134.88, ["Neon|Ride"] = 208.26}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 38.74, ["Fly"] = 124.89, ["Ride"] = 91.23, ["Fly|Ride"] = 250, ["Neon"] = 231.25, ["Neon|Fly"] = 293.75, ["Neon|Ride"] = 249.89, ["Neon|Fly|Ride"] = 357.5}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2, ["Fly"] = 24.97, ["Ride"] = 12.37, ["Fly|Ride"] = 34.99, ["Neon"] = 4.73, ["Neon|Fly"] = 31.24, ["Neon|Ride"] = 37.12, ["Neon|Fly|Ride"] = 55.63}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1250}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 109.9, ["Ride"] = 205.95, ["Fly|Ride"] = 310, ["Neon"] = 475.32, ["Neon|Ride"] = 788.09, ["Neon|Fly|Ride"] = 410.82}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2, ["Ride"] = 79.91, ["Neon"] = 3.64, ["Neon|Fly"] = 96.71, ["Neon|Ride"] = 41.21, ["Neon|Fly|Ride"] = 288.06}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 30.56, ["Ride"] = 67.03, ["Neon"] = 147.89, ["Neon|Ride"] = 217.49, ["Neon|Fly|Ride"] = 518.75}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2, ["Neon"] = 2.5, ["Neon|Fly|Ride"] = 178.7}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2, ["Neon"] = 5}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 111.25, ["Fly"] = 1250, ["Ride"] = 125.98, ["Fly|Ride"] = 193.75, ["Neon"] = 473.01, ["Neon|Ride"] = 437.5, ["Neon|Fly|Ride"] = 615}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2, ["Fly"] = 86.25, ["Ride"] = 17.18, ["Fly|Ride"] = 47.31, ["Neon"] = 6.83, ["Neon|Ride"] = 30.78, ["Neon|Fly|Ride"] = 94.99}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2, ["Fly"] = 36.25, ["Ride"] = 26.25, ["Fly|Ride"] = 63.75, ["Neon"] = 5.75, ["Neon|Ride"] = 35, ["Neon|Fly|Ride"] = 398.65}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2, ["Ride"] = 45.2, ["Neon"] = 11.14, ["Neon|Ride"] = 200}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2, ["Neon"] = 11.05, ["Neon|Ride"] = 106.24}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 100, ["Ride"] = 125, ["Fly|Ride"] = 769.72, ["Neon"] = 533.64, ["Neon|Ride"] = 643.95, ["Neon|Fly|Ride"] = 868.92}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 5, ["Ride"] = 54.91, ["Neon"] = 81.24, ["Neon|Ride"] = 159.99}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 423.24, ["Ride"] = 524.59, ["Fly|Ride"] = 652.58, ["Neon"] = 1018.75, ["Neon|Ride"] = 1024.75, ["Neon|Fly|Ride"] = 1121.47}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 73.02}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 41}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 18.75}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 17.5}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 37.14}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 302.97}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 12.48}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 7.03}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 279.9}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 16.25}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 53.29}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 6.25}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 6.25}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 1233.48}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 6.25}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 10.31}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 4.95}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 4.96}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 22.22}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 498.75}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 524.7}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 11.14}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1000}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 65}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 5.65}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 19.2}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 23.52}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 26.25}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 246.44}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 19.99}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 11.9}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 16.15}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 3.23}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 68.19}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 6.14}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 10.29}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 11.58}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 5.19}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 1425}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 125.81}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 301.25}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 4.82}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 8.18}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 9.21}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 37.49}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 321.61}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 10}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 8.75}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 157.59}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 29.9}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 5.63}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 21.37}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 7.72}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 2}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 87.48}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 28.3}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 8.54}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.5}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 25.69}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.13}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 8.19}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 3.12}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 26.21}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 106.25}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 169.98}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 8.53}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 10.91}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 26.67}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 137.01}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 28.77}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 16466.04}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 133.59}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 33.92}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 39.23}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 29.71}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 64.91}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 18.5}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 34.8}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 51.74}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 106.06}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 30.8}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 135}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 37.5}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 46.24}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 54.1}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 93.75}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 8.18}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 7.4}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 3.75}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 5.88}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 24.58}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 93.65}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.5}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 3.75}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 3.63}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 22.32}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 171.51}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 790.65}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 11.23}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 724.89}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 9.23}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.05}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 220}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 44.64}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 94.99}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 25.87}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 30.89}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 69}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 21.17}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 3.43}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 12.5}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 14.88}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 11.77}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 35}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 3.65}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 2}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 4.68}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 17.88}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 196.24}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 30.6}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 207.11}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 9.42}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 8.75}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 12.5}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 27.27}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 96.25}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 4.18}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 11.8}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 3.25}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 5.88}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 29.99}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 15.74}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 5.88}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 2}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 2}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.5}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 10}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 7.1}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 2}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 2.31}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.49}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.5}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 5.83}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 10.34}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 6750}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.35}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 11.9}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 2.46}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 6.25}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 6.25}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.31}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 32.29}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 8.75}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 7.29}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 5.74}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 13.75}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 57.41}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 6.62}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 3.53}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 8.23}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 3.5}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 2}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 4.49}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 3133.8}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 22.29}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 29.93}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.34}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 2.5}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 81.39}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.04}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 3.75}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 144.53}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 2}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 2}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 2.5}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 8.44}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 26.89}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 4.11}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 2}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 17.9}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 3.89}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 6.17}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 4.99}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 3.33}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 31.23}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 5.57}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.19}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 10.91}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 98.73}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 2}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 67.23}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 6.79}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 4.23}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1368.76}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 51.13}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 10.13}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 37.5}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 29.4}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 7.54}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 8.58}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 19.61}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 17.81}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 15}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 2.4}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 2}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 12.13}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 3.73}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 14.03}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 2}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 2.4}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 2.29}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 8.75}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 96.88}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.5}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 38.75}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 3.41}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 45.63}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 104.95}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 14.91}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 2.3}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.36}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 20.93}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.08}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 23.51}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 5.63}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 7.49}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 5.98}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 2}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 6.53}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 59.09}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 154.89}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 15.32}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1267.21}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 4.39}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 179.97}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 2.6}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 12.29}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 49.71}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.29}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 3.75}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 6.96}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 4.12}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 68.83}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 7.81}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 4.72}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 8.63}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 6.03}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 48.75}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 2.81}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 50.01}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 2.38}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 2}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 5.35}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 14.6}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 113.64}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.47}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 2.04}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 83.32}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 2}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 4.92}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 2}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 55.75}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 48.75}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 74.74}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 72.5}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 5}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 48.64}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 137.29}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 4}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 2.5}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.39}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 27.8}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 64.91}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 2.38}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 22.48}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 2.5}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 4.58}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 10.63}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 21.43}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 20.22}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 4.88}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 17.27}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 38.55}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 3.69}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 5.38}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 45.2}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 3.32}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 24.92}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 76.09}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.5}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 41.25}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 30.99}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1899.99}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 6.14}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 18.41}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 24.92}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 251.14}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 17.49}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 16.43}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 20.56}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 49.91}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 16.14}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 258.55}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 67.5}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 44.99}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 2}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 64.95}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 217.24}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 83.26}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 1000}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 192.3}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 6.23}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 937.5}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 549.19}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 3.8}},
}
=====END_PRICES=====

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
                        if settings.showPrices then
                            local text = (stack > 1) and ("x" .. stack .. " = " .. format_price(total) .. "₽") or (format_price(price) .. "₽")
                            make_label(slot, text, false)
                        else
                            local lbl = slot:FindFirstChild("PriceOverlay")
                            if lbl then lbl:Destroy() end
                        end

                        if results then
                            results.total = (results.total or 0) + total
                            results.count = (results.count or 0) + 1
                        end
                    else
                        if settings.showPrices then make_label(slot, "?", true) end
                        if results then
                            results.unknown = (results.unknown or 0) + 1
                        end
                    end
                else
                    if settings.showPrices then make_label(slot, "?", true) end
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
    if not pets then return end

    local res = {total = 0, count = 0, unknown = 0}
    scan_container(pets, res)

    -- Стоимость рюкзака
    local total_frame = backpack:FindFirstChild("BackpackTotal")
    if settings.showBackpack then
        if not total_frame or not total_frame.Parent then
            total_frame = Instance.new("TextLabel")
            total_frame.Name = "BackpackTotal"
            total_frame.Size = UDim2.new(0, 260, 0, 26)
            total_frame.Position = UDim2.new(1, -270, 0, 6)
            total_frame.AnchorPoint = Vector2.new(1, 0)
            total_frame.BackgroundColor3 = Color3.fromRGB(12, 12, 22)
            total_frame.BackgroundTransparency = 0.15
            total_frame.TextColor3 = Color3.fromRGB(255, 220, 100)
            total_frame.TextSize = 14
            total_frame.Font = Enum.Font.GothamBold
            total_frame.ZIndex = 60
            total_frame.Parent = backpack
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(0, 8)
            c.Parent = total_frame
        end
        total_frame.Text = "🎒 Рюкзак: " .. format_price(res.total) .. " ₽  (" .. res.count .. ")"
    elseif total_frame then
        total_frame:Destroy()
    end
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

    if not settings.showTradePanel then
        if panel then panel.Visible = false end
        return
    end

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

-- ===== ПАНЕЛЬ НАСТРОЕК =====
local settings_panel = nil

local function make_toggle(p, y, text, key, color)
    local row = Instance.new("TextButton")
    row.Name = "Toggle_" .. key
    row.Size = UDim2.new(1, -16, 0, 26)
    row.Position = UDim2.new(0, 8, 0, y)
    row.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    row.BackgroundTransparency = 0.2
    row.BorderSizePixel = 0
    row.AutoButtonColor = true
    row.TextXAlignment = Enum.TextXAlignment.Left
    row.TextSize = 13
    row.Font = Enum.Font.GothamBold
    row.TextColor3 = Color3.fromRGB(220, 220, 240)
    row.ZIndex = 110
    row.Parent = p

    local tick = Instance.new("TextLabel")
    tick.Size = UDim2.new(0, 22, 0, 22)
    tick.Position = UDim2.new(1, -26, 0, 2)
    tick.BackgroundColor3 = color
    tick.BackgroundTransparency = settings[key] and 0 or 0.7
    tick.Text = settings[key] and "✔" or ""
    tick.TextColor3 = Color3.fromRGB(255, 255, 255)
    tick.TextSize = 15
    tick.Font = Enum.Font.GothamBold
    tick.ZIndex = 111
    tick.TextWrapped = false
    tick.Parent = row

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 4)
    c.Parent = tick

    row.MouseButton1Click:Connect(function()
        settings[key] = not settings[key]
        tick.Text = settings[key] and "✔" or ""
        tick.BackgroundTransparency = settings[key] and 0 or 0.7
    end)

    return row
end

local function create_settings_panel()
    local gui = PG:FindFirstChild("OverlaySettingsGui")
    if gui then gui:Destroy() end
    gui = Instance.new("ScreenGui")
    gui.Name = "OverlaySettingsGui"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = PG

    local p = Instance.new("Frame")
    p.Name = "Header"
    p.Size = UDim2.new(0, 200, 0, 34)
    p.Position = UDim2.new(1, -210, 0, 6)
    p.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    p.BackgroundTransparency = 0.15
    p.BorderSizePixel = 0
    p.ZIndex = 100
    p.Parent = gui

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = p

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -34, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "⚙️ Настройки"
    title.TextColor3 = Color3.fromRGB(220, 220, 240)
    title.TextSize = 14
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 101
    title.Parent = p

    local expand = Instance.new("TextButton")
    expand.Size = UDim2.new(0, 24, 0, 24)
    expand.Position = UDim2.new(1, -28, 0, 5)
    expand.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    expand.Text = "▾"
    expand.TextColor3 = Color3.fromRGB(255, 255, 255)
    expand.TextSize = 12
    expand.Font = Enum.Font.GothamBold
    expand.BorderSizePixel = 0
    expand.ZIndex = 101
    expand.Parent = p

    local ec = Instance.new("UICorner")
    ec.CornerRadius = UDim.new(0, 4)
    ec.Parent = expand

    local body = Instance.new("Frame")
    body.Name = "Body"
    body.Size = UDim2.new(0, 200, 0, 98)
    body.Position = UDim2.new(0, 0, 0, 36)
    body.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    body.BackgroundTransparency = 0.15
    body.BorderSizePixel = 0
    body.ZIndex = 100
    body.Visible = false
    body.Parent = p

    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 8)
    bc.Parent = body

    make_toggle(body, 8, "Цены на слотах", "showPrices", Color3.fromRGB(0, 180, 100))
    make_toggle(body, 38, "Стоимость рюкзака", "showBackpack", Color3.fromRGB(80, 160, 255))
    make_toggle(body, 68, "Панель трейда", "showTradePanel", Color3.fromRGB(255, 170, 80))

    local expanded = false
    expand.MouseButton1Click:Connect(function()
        expanded = not expanded
        body.Visible = expanded
        expand.Text = expanded and "▴" or "▾"
    end)

    settings_panel = p
end

-- ===== МГНОВЕННЫЙ СКАН ПО СОБЫТИЯМ =====
local function hook_instant_scan()
    local function hook(appName)
        pcall(function()
            local app = PG:FindFirstChild(appName)
            if app then
                app:GetPropertyChangedSignal("Enabled"):Connect(function()
                    if app.Enabled then
                        pcall(scan_backpack)
                        pcall(scan_trade)
                    end
                end)
            end
        end)
    end
    hook("BackpackApp")
    hook("TradeApp")
end

-- ===== ЦИКЛ =====
create_settings_panel()
hook_instant_scan()
print("[*] Overlay запущен. Проверка каждые 2 сек.")
task.spawn(function()
    while true do
        task.wait(1)
        pcall(scan_backpack)
        pcall(scan_trade)
    end
end)