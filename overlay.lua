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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 1043.39, ["Ride"] = 1050, ["Fly|Ride"] = 1292.82, ["Neon"] = 6646.05, ["Neon|Ride"] = 6562.5, ["Neon|Fly|Ride"] = 4235.63}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 462, ["Ride"] = 655.53, ["Fly|Ride"] = 618.11, ["Neon|Fly|Ride"] = 1967.44}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 5465.25, ["Ride"] = 6330.14, ["Fly|Ride"] = 4689.57, ["Neon|Fly|Ride"] = 21188.43}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 173.62, ["Ride"] = 269.74, ["Fly|Ride"] = 282.19, ["Neon"] = 976.48, ["Neon|Ride"] = 948.94, ["Neon|Fly|Ride"] = 1040.25}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 632.63, ["Fly"] = 836.38, ["Ride"] = 639.19, ["Fly|Ride"] = 568.32, ["Neon|Fly|Ride"] = 1745.63}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 9.87, ["Ride"] = 32.42, ["Fly|Ride"] = 129.94, ["Neon"] = 81.38, ["Neon|Ride"] = 140.11, ["Neon|Fly|Ride"] = 404.25}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 3.14, ["Fly"] = 42.68, ["Ride"] = 30.92, ["Fly|Ride"] = 63, ["Neon"] = 26.04, ["Neon|Fly"] = 138.02, ["Neon|Ride"] = 55.42, ["Neon|Fly|Ride"] = 133.45}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 122.17, ["Fly"] = 209.11, ["Ride"] = 290.07, ["Neon"] = 485.63, ["Neon|Ride"] = 493.5, ["Neon|Fly|Ride"] = 1672.76}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 40.6, ["Fly"] = 105, ["Ride"] = 64.11, ["Fly|Ride"] = 119.87, ["Neon"] = 312.38, ["Neon|Ride"] = 286.13, ["Neon|Fly|Ride"] = 334.69}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 24.36, ["Fly"] = 85.32, ["Ride"] = 37.47, ["Fly|Ride"] = 70.63, ["Neon"] = 145.34, ["Neon|Ride"] = 296.92, ["Neon|Fly|Ride"] = 393.75}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 56.45, ["Fly"] = 140.11, ["Ride"] = 98.28, ["Fly|Ride"] = 177.19, ["Neon"] = 418.2, ["Neon|Ride"] = 334.69, ["Neon|Fly|Ride"] = 420.13}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 67.46}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 393.75, ["Fly"] = 521.7, ["Ride"] = 326.82, ["Fly|Ride"] = 395, ["Neon|Fly"] = 1352.96, ["Neon|Ride"] = 1672.76, ["Neon|Fly|Ride"] = 1063.13}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 140.44, ["Fly"] = 195.51, ["Ride"] = 156.19, ["Fly|Ride"] = 196.88, ["Neon|Ride"] = 573.56, ["Neon|Fly|Ride"] = 787.5}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 3.61, ["Ride"] = 56.47, ["Fly|Ride"] = 131.25, ["Neon"] = 22.32, ["Neon|Fly"] = 98.28, ["Neon|Ride"] = 131.25}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 190.26, ["Fly"] = 237.57, ["Ride"] = 183.75, ["Fly|Ride"] = 231.4, ["Neon"] = 830.76, ["Neon|Ride"] = 1355.33, ["Neon|Fly|Ride"] = 643.13}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.48, ["Fly"] = 19.69, ["Ride"] = 21, ["Fly|Ride"] = 37.32, ["Neon"] = 35.56, ["Neon|Ride"] = 92.02, ["Neon|Fly|Ride"] = 118.13}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 81.36, ["Fly"] = 284.72, ["Ride"] = 173.64, ["Fly|Ride"] = 196.88, ["Neon"] = 328.71, ["Neon|Ride"] = 437.31, ["Neon|Fly|Ride"] = 523.69}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 45.81}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 61.69, ["Ride"] = 459.38, ["Fly|Ride"] = 181.93, ["Neon"] = 558.3, ["Neon|Fly|Ride"] = 787.5}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 15.75, ["Fly"] = 393.75, ["Ride"] = 71.31, ["Fly|Ride"] = 376.39, ["Neon"] = 320.98, ["Neon|Ride"] = 209.99, ["Neon|Fly|Ride"] = 367.5}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 40.64, ["Fly"] = 157.5, ["Ride"] = 61.69, ["Fly|Ride"] = 100.27, ["Neon"] = 684.79, ["Neon|Ride"] = 296.71, ["Neon|Fly|Ride"] = 303.19}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 39.26, ["Ride"] = 157.5, ["Fly|Ride"] = 261.38, ["Neon"] = 210, ["Neon|Ride"] = 418.2, ["Neon|Fly|Ride"] = 447.47}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 22.32, ["Ride"] = 49.86, ["Fly|Ride"] = 193.2, ["Neon"] = 174.6, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 316.89}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 36.75, ["Fly"] = 136.75, ["Ride"] = 65.63, ["Fly|Ride"] = 135.93, ["Neon"] = 196.88, ["Neon|Ride"] = 188.2, ["Neon|Fly|Ride"] = 322.88}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 5.16, ["Fly"] = 35.24, ["Ride"] = 22.65, ["Fly|Ride"] = 57.75, ["Neon"] = 36.74, ["Neon|Fly"] = 101.07, ["Neon|Ride"] = 59.95, ["Neon|Fly|Ride"] = 95.82}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 517.52, ["Ride"] = 577.97, ["Fly|Ride"] = 486.87, ["Neon|Ride"] = 2927.32, ["Neon|Fly|Ride"] = 1964.82}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 19.69, ["Ride"] = 49.16, ["Fly|Ride"] = 107.34, ["Neon"] = 219.19}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 6.91, ["Fly"] = 49.86, ["Ride"] = 28.24, ["Fly|Ride"] = 47.65, ["Neon"] = 71.68, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 138.63}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 93.65, ["Fly"] = 102.38, ["Ride"] = 111.88, ["Fly|Ride"] = 131.25, ["Neon"] = 372.67, ["Neon|Fly"] = 376.72, ["Neon|Ride"] = 399.38, ["Neon|Fly|Ride"] = 451.37}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 14.41, ["Ride"] = 45.94, ["Fly|Ride"] = 210, ["Neon"] = 131.25, ["Neon|Ride"] = 140.11, ["Neon|Fly|Ride"] = 209.11}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 223.13, ["Fly"] = 353.38, ["Ride"] = 280.87, ["Fly|Ride"] = 301.88}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 23.63}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 2.1, ["Fly"] = 32.06, ["Ride"] = 24.06, ["Fly|Ride"] = 67.67, ["Neon"] = 20.45, ["Neon|Fly"] = 140.11, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 140.11}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 926.88, ["Fly"] = 2625, ["Ride"] = 892.5, ["Fly|Ride"] = 1089.99, ["Neon|Ride"] = 6133.75, ["Neon|Fly|Ride"] = 4461.01}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 8.3, ["Ride"] = 46.02, ["Fly|Ride"] = 125.81, ["Neon"] = 140.11, ["Neon|Ride"] = 111.88, ["Neon|Fly|Ride"] = 231.07}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 186.38, ["Ride"] = 196.77, ["Fly|Ride"] = 301.88, ["Neon"] = 1108.44, ["Neon|Ride"] = 813.65, ["Neon|Fly|Ride"] = 977.82}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 47.12}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 15.75, ["Fly"] = 111.88, ["Ride"] = 65.63, ["Fly|Ride"] = 145.69, ["Neon"] = 104.9, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 472.5}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 3.14}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 128.37, ["Ride"] = 136.5, ["Fly|Ride"] = 236.25, ["Neon"] = 639.19}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 114.33, ["Fly"] = 157.49, ["Ride"] = 245.44, ["Fly|Ride"] = 418.2, ["Neon"] = 360.94, ["Neon|Ride"] = 322.43, ["Neon|Fly|Ride"] = 690.02}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 35.07}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 71.23, ["Fly"] = 89.92, ["Ride"] = 55.55, ["Fly|Ride"] = 87.94, ["Neon|Ride"] = 417.77, ["Neon|Fly|Ride"] = 383.93}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 6.56, ["Fly"] = 70.06, ["Ride"] = 83.66, ["Fly|Ride"] = 157.5, ["Neon"] = 75.97, ["Neon|Fly"] = 223.13, ["Neon|Ride"] = 141.75, ["Neon|Fly|Ride"] = 558.3}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 433.13, ["Fly"] = 455.11, ["Ride"] = 433.13, ["Fly|Ride"] = 531.57, ["Neon|Ride"] = 3763.68, ["Neon|Fly|Ride"] = 1668.11}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 109.8, ["Ride"] = 122.07, ["Fly|Ride"] = 184.48, ["Neon"] = 697.34, ["Neon|Ride"] = 767.39, ["Neon|Fly|Ride"] = 525}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3150, ["Fly|Ride"] = 3675}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 43.65, ["Fly"] = 118.13, ["Ride"] = 49.88, ["Fly|Ride"] = 173.56, ["Neon|Ride"] = 316.89, ["Neon|Fly|Ride"] = 696.67}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 140.11, ["Ride"] = 99.75, ["Fly|Ride"] = 147, ["Neon"] = 575.75, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 986.93}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 31.29, ["Fly"] = 55.59, ["Ride"] = 46.83, ["Fly|Ride"] = 91.88, ["Neon"] = 209.11, ["Neon|Ride"] = 225.51, ["Neon|Fly|Ride"] = 213.94}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 6.24}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 56.47, ["Ride"] = 93.77, ["Fly|Ride"] = 65.63, ["Neon|Ride"] = 316.89, ["Neon|Fly|Ride"] = 418.25}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 42.3}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 223.13, ["Ride"] = 236.25, ["Fly|Ride"] = 318.94, ["Neon|Ride"] = 1394.66}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 940.93, ["Fly|Ride"] = 1533.72, ["Neon|Fly|Ride"] = 3356.99}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 5.97}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 32.78, ["Fly"] = 54.12, ["Ride"] = 45.03, ["Fly|Ride"] = 89.02, ["Neon"] = 250.92, ["Neon|Ride"] = 159.05, ["Neon|Fly|Ride"] = 278.11}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 18.75}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5250, ["Fly|Ride"] = 4961.25, ["Neon|Fly|Ride"] = 11287.5}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 11.46, ["Fly"] = 42.04, ["Ride"] = 26.91, ["Fly|Ride"] = 54.09, ["Neon"] = 99.59, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 249.38}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 15.75, ["Ride"] = 36.66, ["Neon"] = 91.88, ["Neon|Ride"] = 122.07, ["Neon|Fly|Ride"] = 262.5}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 70.88, ["Fly"] = 279.16, ["Ride"] = 112.11, ["Fly|Ride"] = 104.56, ["Neon|Ride"] = 387.89, ["Neon|Fly|Ride"] = 480.96}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 11.46, ["Fly"] = 150.93, ["Ride"] = 56.98, ["Fly|Ride"] = 132.65, ["Neon"] = 108.94, ["Neon|Ride"] = 263.47, ["Neon|Fly|Ride"] = 501.38}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1666.88, ["Fly"] = 2314.67, ["Ride"] = 1749.48, ["Fly|Ride"] = 1837.5, ["Neon|Fly|Ride"] = 3609.38}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 27428.63, ["Fly"] = 33454.83, ["Fly|Ride"] = 24937.5, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 72473.88}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 16.98, ["Fly"] = 393.75, ["Ride"] = 79.48, ["Fly|Ride"] = 165.83, ["Neon"] = 313.66, ["Neon|Ride"] = 279.16, ["Neon|Fly|Ride"] = 525}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 2.1, ["Ride"] = 43.09, ["Fly|Ride"] = 153.71, ["Neon"] = 20.92, ["Neon|Fly"] = 198.21, ["Neon|Ride"] = 63.91, ["Neon|Fly|Ride"] = 183.75}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 25.59}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 5.24, ["Ride"] = 52.29, ["Fly|Ride"] = 131.25, ["Neon"] = 89.02, ["Neon|Ride"] = 118.13}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 811.3, ["Ride"] = 791.58, ["Fly|Ride"] = 797.63, ["Neon"] = 3007.35, ["Neon|Fly|Ride"] = 2625}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 918.75, ["Fly"] = 975.19, ["Ride"] = 1091.48, ["Fly|Ride"] = 945, ["Neon|Ride"] = 3624.64, ["Neon|Fly|Ride"] = 3109.32}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 14.67, ["Fly"] = 118.7, ["Ride"] = 36.61, ["Fly|Ride"] = 77.44, ["Neon"] = 140.11, ["Neon|Ride"] = 126, ["Neon|Fly|Ride"] = 278.15}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 27.38}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 69.21, ["Fly"] = 128.34, ["Ride"] = 77.44, ["Fly|Ride"] = 118.13, ["Neon"] = 587.48, ["Neon|Ride"] = 418.2, ["Neon|Fly|Ride"] = 420}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 110.83, ["Ride"] = 91.88, ["Fly|Ride"] = 228.38, ["Neon"] = 450.19, ["Neon|Ride"] = 337.47, ["Neon|Fly|Ride"] = 553.88}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 5.23, ["Fly"] = 41.84, ["Ride"] = 24.06, ["Fly|Ride"] = 39.38, ["Neon"] = 40.37, ["Neon|Fly"] = 525, ["Neon|Ride"] = 66.93, ["Neon|Fly|Ride"] = 98.44}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 141.75, ["Fly"] = 181.37, ["Ride"] = 164, ["Fly|Ride"] = 212.63, ["Neon"] = 725.82, ["Neon|Ride"] = 576.19, ["Neon|Fly|Ride"] = 531.57}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 3.56, ["Ride"] = 46.28, ["Neon"] = 52.45, ["Neon|Ride"] = 82.69}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 15.29, ["Fly"] = 63, ["Ride"] = 39.38, ["Fly|Ride"] = 77.38, ["Neon"] = 91.88, ["Neon|Fly"] = 127, ["Neon|Ride"] = 131.24}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 28.24, ["Ride"] = 128.63, ["Fly|Ride"] = 156.19, ["Neon"] = 266.61, ["Neon|Ride"] = 316.89}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 16.75, ["Fly"] = 209.11, ["Ride"] = 51.06, ["Fly|Ride"] = 70.88, ["Neon"] = 91.88, ["Neon|Ride"] = 114.59, ["Neon|Fly|Ride"] = 249.38}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 8363.73, ["Ride"] = 8363.73, ["Fly|Ride"] = 5496.75, ["Neon"] = 34849.48, ["Neon|Ride"] = 24281.25, ["Neon|Fly|Ride"] = 26345.69}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 223.13, ["Fly"] = 313.66, ["Ride"] = 250.69, ["Fly|Ride"] = 291.6, ["Neon|Fly|Ride"] = 590.63}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 39.38, ["Fly"] = 140.64, ["Ride"] = 78.74, ["Fly|Ride"] = 180.35, ["Neon"] = 150.77, ["Neon|Ride"] = 166.68, ["Neon|Fly|Ride"] = 280.86}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 3.89, ["Fly"] = 87.83, ["Fly|Ride"] = 52.5, ["Neon"] = 31.38, ["Neon|Fly"] = 60.65, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 190.29}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 52.5, ["Fly"] = 5379.55, ["Ride"] = 131.25, ["Fly|Ride"] = 221.01, ["Neon"] = 225.22, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 272.89, ["Neon|Fly|Ride"] = 363.83}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 14384.99, ["Ride"] = 16727.42, ["Fly|Ride"] = 12073.69, ["Neon|Fly|Ride"] = 24150}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 265.13, ["Ride"] = 242.82, ["Fly|Ride"] = 459.38, ["Neon|Fly|Ride"] = 1575}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 79.2, ["Fly"] = 91.88, ["Ride"] = 65.51, ["Fly|Ride"] = 142.34, ["Neon"] = 397.29, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 418.25}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 7.66, ["Fly"] = 27.67, ["Ride"] = 28.24, ["Fly|Ride"] = 72.12, ["Neon"] = 70.06, ["Neon|Fly"] = 269.41, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 157.5}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 379.2, ["Fly"] = 836.38, ["Ride"] = 475.13, ["Fly|Ride"] = 492.19, ["Neon"] = 1568.76, ["Neon|Ride"] = 1680, ["Neon|Fly|Ride"] = 2624.99}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 6.57, ["Fly"] = 103.51, ["Ride"] = 42, ["Fly|Ride"] = 140.11, ["Neon"] = 28.24, ["Neon|Ride"] = 127.32, ["Neon|Fly|Ride"] = 181.93}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 102.36, ["Fly"] = 237.34, ["Ride"] = 231.07, ["Fly|Ride"] = 218.52, ["Neon"] = 683.74, ["Neon|Fly"] = 525, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 557.82}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 11.54, ["Fly"] = 19.71, ["Ride"] = 20.62, ["Fly|Ride"] = 38.4, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 103.69}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 8.99}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 52.5, ["Ride"] = 87.94, ["Fly|Ride"] = 418.2, ["Neon"] = 421.32, ["Neon|Fly"] = 417.15, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 418.2}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 17.07, ["Fly"] = 103.51, ["Ride"] = 31.5, ["Fly|Ride"] = 93.19, ["Neon"] = 151.93, ["Neon|Ride"] = 165.38, ["Neon|Fly|Ride"] = 261.19}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 26.13}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 46.92, ["Fly"] = 210, ["Ride"] = 115.5, ["Fly|Ride"] = 249.38, ["Neon"] = 284.85, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 459.38}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.94, ["Neon"] = 24.94, ["Neon|Ride"] = 103.26, ["Neon|Fly|Ride"] = 279.16}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 11.33, ["Fly"] = 52.5, ["Ride"] = 47.49, ["Fly|Ride"] = 99.75, ["Neon|Ride"] = 311.85, ["Neon|Fly|Ride"] = 209.11}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 446.25, ["Ride"] = 490.28, ["Fly|Ride"] = 606.38, ["Neon|Fly|Ride"] = 5576.51}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 39.35, ["Ride"] = 70.06, ["Fly|Ride"] = 177.19, ["Neon"] = 177.68, ["Neon|Ride"] = 262.5}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 59.95, ["Ride"] = 65.63, ["Fly|Ride"] = 140.11, ["Neon|Ride"] = 418.2, ["Neon|Fly|Ride"] = 458.1}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 20.99, ["Ride"] = 63.02, ["Fly|Ride"] = 125.26, ["Neon"] = 97.13, ["Neon|Ride"] = 154.74, ["Neon|Fly|Ride"] = 328.3}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 26250, ["Ride"] = 13608.47, ["Fly|Ride"] = 8518.13, ["Neon|Fly|Ride"] = 17259.38}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1366.65, ["Ride"] = 1509.38, ["Fly|Ride"] = 1619.82, ["Neon|Fly|Ride"] = 3936.19}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 1312.49, ["Fly|Ride"] = 538.13, ["Neon"] = 2552.44, ["Neon|Fly|Ride"] = 2090.94}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 11.78, ["Fly"] = 28.24, ["Ride"] = 24.36, ["Fly|Ride"] = 42, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 131.25}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 4.73, ["Fly"] = 78.74, ["Ride"] = 32.06, ["Neon"] = 21.05, ["Neon|Ride"] = 55.12}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 41.22, ["Fly"] = 102.46, ["Ride"] = 58.08, ["Fly|Ride"] = 94.37, ["Neon"] = 534.08, ["Neon|Ride"] = 155.92, ["Neon|Fly|Ride"] = 209.78}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 4.39, ["Fly"] = 23.24, ["Ride"] = 17.38, ["Fly|Ride"] = 40.4, ["Neon"] = 31.48, ["Neon|Fly"] = 76.92, ["Neon|Ride"] = 44.98, ["Neon|Fly|Ride"] = 91.88}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 354.38, ["Fly"] = 380.63, ["Ride"] = 324.19, ["Fly|Ride"] = 422.22, ["Neon|Ride"] = 1462.62, ["Neon|Fly|Ride"] = 1671.71}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 20.5, ["Fly"] = 59.36, ["Ride"] = 44.63, ["Fly|Ride"] = 119.2, ["Neon"] = 208.95, ["Neon|Ride"] = 166.57, ["Neon|Fly|Ride"] = 287.44}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 10.89, ["Fly"] = 21, ["Ride"] = 28.88, ["Fly|Ride"] = 44.97, ["Neon"] = 140.11, ["Neon|Fly"] = 135.31, ["Neon|Ride"] = 129.06, ["Neon|Fly|Ride"] = 103.69}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 577.86, ["Fly"] = 1048.69, ["Ride"] = 540.75, ["Fly|Ride"] = 976.48}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1273.48, ["Ride"] = 1260, ["Fly|Ride"] = 1384.69, ["Neon"] = 4879.19, ["Neon|Ride"] = 4181.87, ["Neon|Fly|Ride"] = 3570}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 122, ["Fly"] = 135.93, ["Ride"] = 98.44, ["Fly|Ride"] = 125.47, ["Neon"] = 971.25, ["Neon|Ride"] = 585.46, ["Neon|Fly|Ride"] = 498.75}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 170.42, ["Fly"] = 170.63, ["Ride"] = 190.32, ["Fly|Ride"] = 229.95, ["Neon"] = 847.89, ["Neon|Fly"] = 697.34, ["Neon|Ride"] = 630, ["Neon|Fly|Ride"] = 587.46}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 27.83, ["Fly"] = 120.24, ["Ride"] = 181.93, ["Neon"] = 391.02, ["Neon|Ride"] = 272.98}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 183.75, ["Ride"] = 558.3, ["Fly|Ride"] = 558.3, ["Neon|Fly|Ride"] = 1329.22}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2272.86, ["Ride"] = 2483.25, ["Fly|Ride"] = 2370.08}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 53.82, ["Fly"] = 209.11, ["Ride"] = 106.82, ["Fly|Ride"] = 196.88, ["Neon"] = 511.88, ["Neon|Ride"] = 454.13, ["Neon|Fly|Ride"] = 343.88}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 656.25, ["Ride"] = 761.8, ["Fly|Ride"] = 630, ["Neon|Fly|Ride"] = 1311.19}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 45.94, ["Fly"] = 68.85, ["Ride"] = 62.74, ["Fly|Ride"] = 95.08, ["Neon|Ride"] = 278.11, ["Neon|Fly|Ride"] = 262.5}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 2.89, ["Fly"] = 39.37, ["Ride"] = 21.35, ["Fly|Ride"] = 51.49, ["Neon"] = 26.08, ["Neon|Fly"] = 159.05, ["Neon|Ride"] = 48.71, ["Neon|Fly|Ride"] = 98.44}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 53.66, ["Ride"] = 164.07, ["Fly|Ride"] = 253.32, ["Neon"] = 420, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 697.34}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 845.23, ["Fly"] = 1085.44, ["Ride"] = 905.63, ["Fly|Ride"] = 930.01, ["Neon|Ride"] = 2598.75, ["Neon|Fly|Ride"] = 2690.63}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 721.88, ["Fly|Ride"] = 7912.07}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 15.38, ["Fly"] = 31.5, ["Ride"] = 23.61, ["Fly|Ride"] = 43.8, ["Neon"] = 209.11, ["Neon|Ride"] = 125.47, ["Neon|Fly|Ride"] = 169.51}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 10.96, ["Ride"] = 26.25, ["Fly|Ride"] = 103.51, ["Neon"] = 141.44, ["Neon|Ride"] = 98.28, ["Neon|Fly|Ride"] = 250.04}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 5.67, ["Ride"] = 54.38, ["Fly|Ride"] = 111.57, ["Neon"] = 22.32, ["Neon|Fly"] = 316.89, ["Neon|Ride"] = 55.59, ["Neon|Fly|Ride"] = 170.57}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 37.15, ["Fly"] = 75.29, ["Ride"] = 53.4, ["Fly|Ride"] = 103.01, ["Neon"] = 249.38, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 231}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 74.27, ["Ride"] = 284.84, ["Fly|Ride"] = 1045.48, ["Neon"] = 424.07, ["Neon|Ride"] = 633.76, ["Neon|Fly|Ride"] = 695.63}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 15.57, ["Fly"] = 51.19, ["Ride"] = 42, ["Fly|Ride"] = 82.82, ["Neon"] = 107.63, ["Neon|Ride"] = 118.12, ["Neon|Fly|Ride"] = 157.5}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 44.96, ["Ride"] = 45.94, ["Fly|Ride"] = 102.38, ["Neon"] = 332.47, ["Neon|Fly"] = 1394.66, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 302.08}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 2.41, ["Fly"] = 20.88, ["Ride"] = 16.07, ["Fly|Ride"] = 42, ["Neon"] = 29.19, ["Neon|Ride"] = 60.38, ["Neon|Fly|Ride"] = 85.32}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 7.17, ["Fly"] = 46.41, ["Ride"] = 40.37, ["Neon"] = 42.74, ["Neon|Fly"] = 115.54, ["Neon|Ride"] = 90.57, ["Neon|Fly|Ride"] = 142.44}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 56.51, ["Fly"] = 87.94, ["Ride"] = 71.22, ["Fly|Ride"] = 98.44, ["Neon"] = 411.83, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 262.49}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1575, ["Fly"] = 1575, ["Ride"] = 1437.19, ["Fly|Ride"] = 1568.78, ["Neon|Fly|Ride"] = 4200}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 459.37, ["Fly"] = 479.81, ["Ride"] = 535.5, ["Fly|Ride"] = 473.82}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 301.88, ["Ride"] = 341.25, ["Neon"] = 1273.13, ["Neon|Ride"] = 1672.76, ["Neon|Fly|Ride"] = 1672.97}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 44.58}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 25.99, ["Ride"] = 65.63, ["Fly|Ride"] = 98.44, ["Neon|Ride"] = 521.7, ["Neon|Fly|Ride"] = 418.25}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 32061.24, ["Fly"] = 65625, ["Fly|Ride"] = 17390.63, ["Neon|Fly|Ride"] = 38062.5}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 289.24, ["Fly"] = 611.63, ["Ride"] = 349.19, ["Fly|Ride"] = 359.59, ["Neon"] = 1359.12, ["Neon|Ride"] = 1147.13, ["Neon|Fly|Ride"] = 931.88}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 195.51, ["Fly"] = 525, ["Fly|Ride"] = 313.66, ["Neon|Fly|Ride"] = 1741.04}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 192.38, ["Fly"] = 279.16, ["Ride"] = 157.5, ["Fly|Ride"] = 227.56, ["Neon|Ride"] = 606.79, ["Neon|Fly|Ride"] = 814.44}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 14.21, ["Fly"] = 94.5, ["Ride"] = 35.44, ["Fly|Ride"] = 125.47, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 787.5}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 3921.75, ["Fly|Ride"] = 4748.87, ["Neon"] = 27182.06, ["Neon|Fly|Ride"] = 27879.38}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 29.14, ["Fly"] = 64.11, ["Ride"] = 32.52, ["Fly|Ride"] = 64.11, ["Neon|Ride"] = 343.88, ["Neon|Fly|Ride"] = 211.97}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 53.33, ["Ride"] = 75.97, ["Fly|Ride"] = 94.85, ["Neon"] = 405.66, ["Neon|Fly"] = 1394.66, ["Neon|Fly|Ride"] = 248.07}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 609, ["Fly|Ride"] = 684.5, ["Neon"] = 3957.97, ["Neon|Ride"] = 2649.22, ["Neon|Fly|Ride"] = 1968.74}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 18.74, ["Fly"] = 26.25, ["Ride"] = 25.1, ["Fly|Ride"] = 41.54, ["Neon"] = 118.12, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 184.48}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 13.1, ["Ride"] = 27.57, ["Fly|Ride"] = 474.71, ["Neon"] = 95.82, ["Neon|Ride"] = 118.7, ["Neon|Fly|Ride"] = 249.38}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 108.84, ["Ride"] = 128.63, ["Fly|Ride"] = 246.75, ["Neon"] = 1010.63, ["Neon|Ride"] = 836.38, ["Neon|Fly|Ride"] = 834.29}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 20.62, ["Fly"] = 140.11, ["Ride"] = 105, ["Fly|Ride"] = 168.56, ["Neon"] = 87.85, ["Neon|Ride"] = 140.11, ["Neon|Fly|Ride"] = 249.43}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3734.28, ["Ride"] = 4068.75, ["Fly|Ride"] = 4182.51, ["Neon"] = 13940.22, ["Neon|Ride"] = 12337.5, ["Neon|Fly|Ride"] = 9841.13}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 36.75, ["Ride"] = 65.34, ["Fly|Ride"] = 111.88, ["Neon"] = 1603.75, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 683.82}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 7612.5, ["Ride"] = 7945.54, ["Fly|Ride"] = 7168.88, ["Neon|Ride"] = 19515.67, ["Neon|Fly|Ride"] = 17718.75}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.1, ["Fly"] = 22.32, ["Ride"] = 19.69, ["Fly|Ride"] = 30.82, ["Neon"] = 26.23, ["Neon|Fly"] = 62.62, ["Neon|Ride"] = 59.36, ["Neon|Fly|Ride"] = 82.69}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 24.94, ["Fly"] = 37.3, ["Ride"] = 41.84, ["Fly|Ride"] = 55.27, ["Neon"] = 195.51, ["Neon|Fly"] = 231.07, ["Neon|Ride"] = 558.3, ["Neon|Fly|Ride"] = 161.44}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.56}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 11.82, ["Ride"] = 42, ["Neon"] = 279.16, ["Neon|Ride"] = 157.68}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 28.58, ["Fly"] = 190.37, ["Ride"] = 41.84, ["Fly|Ride"] = 160.23, ["Neon"] = 210, ["Neon|Ride"] = 236.25}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 11.9, ["Fly"] = 26.25, ["Ride"] = 24.35, ["Fly|Ride"] = 40.51, ["Neon|Ride"] = 140.11, ["Neon|Fly|Ride"] = 179.55}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8503.82}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2624.98}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 20.92}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 277.93, ["Ride"] = 376.39, ["Fly|Ride"] = 223.13}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 14.26, ["Fly"] = 131.75, ["Ride"] = 37.45, ["Fly|Ride"] = 128.19, ["Neon"] = 182.97, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 265.13}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 13.13}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 6.24, ["Neon|Ride"] = 181.93}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 3165.38}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 196.88, ["Ride"] = 215.25, ["Fly|Ride"] = 328.13, ["Neon"] = 906.43, ["Neon|Ride"] = 813.75, ["Neon|Fly|Ride"] = 1115.67}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 70.14, ["Ride"] = 131.24, ["Fly|Ride"] = 202.83, ["Neon"] = 558.3, ["Neon|Ride"] = 320.98, ["Neon|Fly|Ride"] = 1435.35}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 156.19, ["Fly"] = 349.19, ["Ride"] = 223.13, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 787.4, ["Neon|Fly|Ride"] = 976.48}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1967.44, ["Fly"] = 1968.75, ["Ride"] = 2717.17, ["Fly|Ride"] = 2208.94, ["Neon|Fly|Ride"] = 6628.13}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 14.44, ["Ride"] = 72.19, ["Fly|Ride"] = 99.75, ["Neon"] = 181.93, ["Neon|Ride"] = 206.52, ["Neon|Fly|Ride"] = 308.43}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 712.06, ["Fly"] = 2100, ["Ride"] = 864.62, ["Fly|Ride"] = 1254.57, ["Neon|Fly|Ride"] = 4180.82}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 44.63}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 17.82, ["Ride"] = 56.47, ["Fly|Ride"] = 832.2, ["Neon"] = 87.85, ["Neon|Ride"] = 140.11, ["Neon|Fly|Ride"] = 262.5}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 6.39, ["Fly"] = 165.55, ["Ride"] = 39.38, ["Fly|Ride"] = 99.75, ["Neon"] = 65.63, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 262.5}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 64.32}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 18.77, ["Ride"] = 36.61, ["Fly|Ride"] = 92.57, ["Neon"] = 94.96, ["Neon|Ride"] = 250.92, ["Neon|Fly|Ride"] = 488.25}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["Ride"] = 52.29, ["Fly|Ride"] = 76.13, ["Neon|Ride"] = 418.2, ["Neon|Fly|Ride"] = 309.47}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6300, ["Fly"] = 10237.5, ["Ride"] = 7875, ["Fly|Ride"] = 5118.75, ["Neon|Fly|Ride"] = 11812.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 10.4, ["Fly"] = 65.63, ["Ride"] = 34.13, ["Fly|Ride"] = 78.35, ["Neon"] = 56.44, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 221.94}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 21.17}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 105, ["Fly"] = 370.11, ["Ride"] = 132.79, ["Neon"] = 525, ["Neon|Ride"] = 455.44, ["Neon|Fly|Ride"] = 734.98}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 48.2, ["Fly"] = 142.43, ["Ride"] = 102.46, ["Fly|Ride"] = 177.19, ["Neon"] = 350.13, ["Neon|Ride"] = 317.84, ["Neon|Fly|Ride"] = 393.75}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 25.34, ["Fly"] = 70.47, ["Ride"] = 31.5, ["Fly|Ride"] = 66.31, ["Neon|Ride"] = 142.96, ["Neon|Fly|Ride"] = 208.69}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 8.37, ["Fly"] = 65.54, ["Ride"] = 25.81, ["Fly|Ride"] = 99.31, ["Neon"] = 32.7, ["Neon|Fly"] = 70.06, ["Neon|Ride"] = 68.37, ["Neon|Fly|Ride"] = 175.65}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 11.82, ["Ride"] = 31.5, ["Fly|Ride"] = 94.5, ["Neon"] = 86.63, ["Neon|Ride"] = 126, ["Neon|Fly|Ride"] = 291.71}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 19.04, ["Fly"] = 23.63, ["Ride"] = 27.2, ["Fly|Ride"] = 48.57, ["Neon"] = 362.79, ["Neon|Ride"] = 128.63, ["Neon|Fly|Ride"] = 144.38}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 208.99}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 28.1, ["Ride"] = 131.24, ["Fly|Ride"] = 656.25, ["Neon"] = 170.63, ["Neon|Ride"] = 279.16, ["Neon|Fly|Ride"] = 572.94}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 210, ["Fly|Ride"] = 1583.14}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 47.38, ["Fly"] = 212.42, ["Ride"] = 126, ["Fly|Ride"] = 244.64, ["Neon"] = 269.99, ["Neon|Ride"] = 295.32, ["Neon|Fly|Ride"] = 459.38}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 984.38, ["Fly"] = 1352.85, ["Ride"] = 1181.25, ["Fly|Ride"] = 1030.32, ["Neon|Ride"] = 3281.25, ["Neon|Fly|Ride"] = 3394.52}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 393.75, ["Fly"] = 697.34, ["Ride"] = 413.44, ["Fly|Ride"] = 570.94, ["Neon"] = 2509.13, ["Neon|Ride"] = 2090.94, ["Neon|Fly|Ride"] = 2559.38}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 71.54}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 3.93}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 10.5, ["Fly"] = 23.27, ["Ride"] = 23.63, ["Fly|Ride"] = 51.56, ["Neon"] = 78.74, ["Neon|Fly"] = 167.28, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 157.5}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 261.19, ["Fly"] = 525, ["Ride"] = 316.32, ["Fly|Ride"] = 387.93, ["Neon"] = 2373.6, ["Neon|Ride"] = 1039.61, ["Neon|Fly|Ride"] = 1094.76}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 17.07}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 139.12, ["Ride"] = 183.23, ["Fly|Ride"] = 282.19, ["Neon"] = 585.38, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 636.57}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 127.32, ["Fly"] = 105, ["Ride"] = 104.56, ["Fly|Ride"] = 209.11, ["Neon"] = 1115.52, ["Neon|Fly"] = 590.63, ["Neon|Ride"] = 2300.03, ["Neon|Fly|Ride"] = 913.5}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 5.06, ["Ride"] = 41.84, ["Fly|Ride"] = 729.75, ["Neon"] = 27.57, ["Neon|Ride"] = 140.11, ["Neon|Fly|Ride"] = 236.3}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 13.93, ["Fly"] = 83.66, ["Ride"] = 27.15, ["Fly|Ride"] = 76.28, ["Neon"] = 177.19, ["Neon|Ride"] = 175.67, ["Neon|Fly|Ride"] = 999.6}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 12.76, ["Fly"] = 102.35, ["Ride"] = 70.06, ["Fly|Ride"] = 131.25, ["Neon"] = 96.36, ["Neon|Ride"] = 101.06, ["Neon|Fly|Ride"] = 328.13}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 5.38, ["Fly"] = 131.23, ["Ride"] = 73.2, ["Fly|Ride"] = 279.16, ["Neon"] = 26.74, ["Neon|Ride"] = 68.93, ["Neon|Fly|Ride"] = 204.15}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 269.07, ["Ride"] = 290.04, ["Fly|Ride"] = 412.97, ["Neon"] = 1645.58, ["Neon|Ride"] = 1350.59, ["Neon|Fly|Ride"] = 1312.5}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 140.33, ["Fly"] = 558.3, ["Ride"] = 209.11, ["Fly|Ride"] = 263.82, ["Neon"] = 703.75, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 1173.27}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 74.82, ["Ride"] = 72.19, ["Fly|Ride"] = 159.04, ["Neon"] = 393.75, ["Neon|Ride"] = 1190.36, ["Neon|Fly|Ride"] = 416.07}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 13.13, ["Ride"] = 96.2, ["Fly|Ride"] = 279.16, ["Neon|Ride"] = 602.9, ["Neon|Fly|Ride"] = 488.25}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 14.44, ["Fly"] = 58.47, ["Ride"] = 35.56, ["Fly|Ride"] = 79.61, ["Neon"] = 77.44, ["Neon|Fly"] = 279.16, ["Neon|Ride"] = 125.47, ["Neon|Fly|Ride"] = 199.69}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.48, ["Fly"] = 52.47, ["Ride"] = 23.63, ["Fly|Ride"] = 52.5, ["Neon"] = 24.84, ["Neon|Fly"] = 66.25, ["Neon|Ride"] = 61.7, ["Neon|Fly|Ride"] = 168}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 983.09, ["Fly"] = 1050, ["Ride"] = 914.82, ["Fly|Ride"] = 941.07, ["Neon|Ride"] = 8363.73, ["Neon|Fly|Ride"] = 2625}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["Ride"] = 393.75, ["Fly|Ride"] = 974.39, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 2090.94}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 91.88, ["Fly"] = 170.42, ["Ride"] = 121.06, ["Fly|Ride"] = 196.88, ["Neon"] = 339.94, ["Neon|Ride"] = 379.79, ["Neon|Fly|Ride"] = 587.56}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 263.82, ["Fly"] = 283.5, ["Ride"] = 223.13, ["Fly|Ride"] = 362.53, ["Neon|Fly|Ride"] = 1583.19}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 17.07, ["Fly"] = 52.5, ["Ride"] = 32.82, ["Fly|Ride"] = 80.07, ["Neon"] = 279.16, ["Neon|Ride"] = 96.48, ["Neon|Fly|Ride"] = 236.25}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 236.25, ["Ride"] = 509.13, ["Fly|Ride"] = 472.5, ["Neon"] = 1492.2, ["Neon|Ride"] = 942.38, ["Neon|Fly|Ride"] = 1460.95}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 97.13, ["Fly"] = 125.98, ["Ride"] = 90.57, ["Fly|Ride"] = 125.47, ["Neon|Fly|Ride"] = 558.3}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1889.99, ["Ride"] = 2612.63, ["Fly|Ride"] = 1837.5, ["Neon|Ride"] = 11077.55, ["Neon|Fly|Ride"] = 7249.26}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 13.47, ["Fly"] = 154.74, ["Ride"] = 48.11, ["Fly|Ride"] = 71.28, ["Neon"] = 58.97, ["Neon|Fly"] = 237.57, ["Neon|Ride"] = 115.5, ["Neon|Fly|Ride"] = 223.69}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 64.85, ["Ride"] = 99.33, ["Fly|Ride"] = 161.44, ["Neon"] = 315, ["Neon|Ride"] = 349.19, ["Neon|Fly|Ride"] = 558.3}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 104.89, ["Fly"] = 78.7, ["Ride"] = 78.11, ["Fly|Ride"] = 106.32, ["Neon"] = 525, ["Neon|Fly|Ride"] = 393.71}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 3018.75, ["Fly"] = 1583.14, ["Ride"] = 1198.12, ["Fly|Ride"] = 1133.16}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 459.38, ["Fly"] = 580.25}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 85.22, ["Fly"] = 316.88, ["Ride"] = 137.82, ["Fly|Ride"] = 279.16, ["Neon"] = 409.83, ["Neon|Ride"] = 465.94, ["Neon|Fly|Ride"] = 557.82}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 5.82, ["Ride"] = 22.32, ["Fly|Ride"] = 140.11, ["Neon"] = 86.63, ["Neon|Ride"] = 95.82, ["Neon|Fly|Ride"] = 196.88}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 39.29, ["Ride"] = 55.13, ["Fly|Ride"] = 104.56, ["Neon"] = 262.5, ["Neon|Fly"] = 328.3, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 376.39}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 796.69, ["Ride"] = 899.07, ["Fly|Ride"] = 820.32, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2162.42}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 750.69}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 4921.88, ["Fly|Ride"] = 5961.31, ["Neon"] = 42000, ["Neon|Ride"] = 29964.03, ["Neon|Fly|Ride"] = 23420.18}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 328.13, ["Fly"] = 496.13, ["Ride"] = 393.75, ["Neon"] = 1672.76, ["Neon|Fly|Ride"] = 2195.48}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 91.82, ["Fly"] = 279.16, ["Ride"] = 131.25, ["Fly|Ride"] = 336, ["Neon|Ride"] = 1672.76, ["Neon|Fly|Ride"] = 623.12}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 12.5, ["Fly"] = 98.28, ["Ride"] = 37.22, ["Fly|Ride"] = 140.11, ["Neon"] = 112.88, ["Neon|Fly"] = 1266.33, ["Neon|Ride"] = 124.37, ["Neon|Fly|Ride"] = 170.63}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 13.13, ["Fly"] = 26.24, ["Ride"] = 23.63, ["Fly|Ride"] = 47.25, ["Neon|Ride"] = 316.89, ["Neon|Fly|Ride"] = 177.19}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 17.2, ["Ride"] = 27.57, ["Fly|Ride"] = 142.43, ["Neon"] = 154.88, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 232.11}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 5.25, ["Ride"] = 22.32, ["Fly|Ride"] = 48.57, ["Neon"] = 35.44, ["Neon|Ride"] = 55.79, ["Neon|Fly|Ride"] = 131.76}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 23.37, ["Fly"] = 90.57, ["Ride"] = 39.38, ["Fly|Ride"] = 139.13, ["Neon"] = 223.13, ["Neon|Fly"] = 836.38, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 418.2}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 422.56, ["Fly"] = 577.5, ["Ride"] = 492.19, ["Fly|Ride"] = 508.64, ["Neon"] = 1568.21, ["Neon|Ride"] = 1533.72, ["Neon|Fly|Ride"] = 1147.13}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.47, ["Fly"] = 19.25, ["Ride"] = 15.75, ["Fly|Ride"] = 32.82, ["Neon"] = 25.3, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 52.5}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 42.38, ["Fly"] = 102.11, ["Ride"] = 87.47, ["Fly|Ride"] = 144.62, ["Neon"] = 229.68, ["Neon|Fly"] = 428.45, ["Neon|Ride"] = 197.59, ["Neon|Fly|Ride"] = 279.04}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 794.07, ["Ride"] = 824.25, ["Fly|Ride"] = 853.11, ["Neon|Ride"] = 1988.23, ["Neon|Fly|Ride"] = 1575}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 43.32, ["Fly"] = 165.38, ["Ride"] = 56.35, ["Fly|Ride"] = 97.4, ["Neon|Ride"] = 235.28, ["Neon|Fly|Ride"] = 288.75}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 393.75, ["Fly"] = 384.56, ["Ride"] = 290.76, ["Fly|Ride"] = 387.8, ["Neon|Ride"] = 1583.19, ["Neon|Fly|Ride"] = 1672.76}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 177.19, ["Fly"] = 273.93, ["Ride"] = 196.87, ["Fly|Ride"] = 262.96, ["Neon"] = 976.48, ["Neon|Ride"] = 986.24, ["Neon|Fly|Ride"] = 886.15}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 942.3, ["Ride"] = 783.57, ["Fly|Ride"] = 921.06, ["Neon|Ride"] = 4181.87, ["Neon|Fly|Ride"] = 5298.02}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 17.03, ["Ride"] = 39.38, ["Fly|Ride"] = 110.25, ["Neon"] = 104.56, ["Neon|Fly"] = 284.85, ["Neon|Ride"] = 108.01, ["Neon|Fly|Ride"] = 275.39}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 4084.49, ["Ride"] = 5456.29, ["Fly|Ride"] = 3584.44, ["Neon"] = 13940.22, ["Neon|Fly|Ride"] = 7021.88}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 125.47, ["Fly"] = 166.28, ["Ride"] = 166.25, ["Fly|Ride"] = 201.22, ["Neon"] = 550.97, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 706.13}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.37, ["Fly"] = 28.24, ["Ride"] = 21, ["Fly|Ride"] = 38.07, ["Neon"] = 19.69, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 78.75}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 5.25, ["Ride"] = 27.98, ["Fly|Ride"] = 59.36, ["Neon"] = 20.47, ["Neon|Fly"] = 116.31, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 266.44}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 34.38, ["Fly"] = 83.66, ["Ride"] = 39.38, ["Fly|Ride"] = 73.2, ["Neon|Fly|Ride"] = 301.88}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 1575, ["Fly|Ride"] = 1342.71}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 6693.75, ["Ride"] = 7104.99, ["Fly|Ride"] = 13125}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 22.17, ["Fly"] = 36.01, ["Ride"] = 24.74, ["Fly|Ride"] = 43.11, ["Neon"] = 452.13, ["Neon|Ride"] = 142.44, ["Neon|Fly|Ride"] = 174.19}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 12.46, ["Ride"] = 24.94, ["Fly|Ride"] = 84.29, ["Neon"] = 89.25, ["Neon|Ride"] = 140.11, ["Neon|Fly|Ride"] = 181.95}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 79.48, ["Fly"] = 157.5, ["Ride"] = 99.65, ["Fly|Ride"] = 132.57, ["Neon|Ride"] = 585.47, ["Neon|Fly|Ride"] = 446.25}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 262.32, ["Ride"] = 262.5, ["Fly|Ride"] = 346.53, ["Neon|Ride"] = 1613.17, ["Neon|Fly|Ride"] = 1102.5}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.71, ["Ride"] = 32.8, ["Fly|Ride"] = 93.19, ["Neon"] = 22.01, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 94.11}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 207.08, ["Ride"] = 224.66, ["Fly|Ride"] = 293.7, ["Neon"] = 1000.13, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 939.92}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 3.34, ["Fly"] = 24.94, ["Ride"] = 16.95, ["Fly|Ride"] = 159.04, ["Neon"] = 19.69, ["Neon|Fly"] = 125.47, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 108.94}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 223.13, ["Fly"] = 463.16, ["Fly|Ride"] = 315, ["Neon|Fly|Ride"] = 772.01}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 10.11, ["Fly"] = 73.62, ["Ride"] = 28.24, ["Fly|Ride"] = 68.25, ["Neon"] = 140.11, ["Neon|Fly"] = 301.46, ["Neon|Ride"] = 154.74, ["Neon|Fly|Ride"] = 196.88}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 3.85, ["Ride"] = 27.32, ["Neon"] = 10.49, ["Neon|Fly"] = 170.45, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 195.57}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.63, ["Neon"] = 3.75}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 8.37, ["Fly"] = 52.49, ["Fly|Ride"] = 110.83, ["Neon"] = 7.53, ["Neon|Ride"] = 34.4, ["Neon|Fly|Ride"] = 131.25}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 78.21, ["Fly"] = 525, ["Ride"] = 132.23, ["Fly|Ride"] = 128.63, ["Neon"] = 236.8, ["Neon|Ride"] = 295.31, ["Neon|Fly|Ride"] = 372.78}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 49.16, ["Ride"] = 21, ["Fly|Ride"] = 110.83, ["Neon"] = 8.69, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 52.5}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 7.74, ["Neon"] = 160.23, ["Neon|Ride"] = 105}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 52.35, ["Neon|Fly|Ride"] = 279.16}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 61.13, ["Ride"] = 26.25, ["Fly|Ride"] = 131.25, ["Neon"] = 2.1, ["Neon|Fly"] = 18.38, ["Neon|Ride"] = 15.69, ["Neon|Fly|Ride"] = 37.99}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 18.15, ["Fly|Ride"] = 78.43, ["Neon"] = 3.94, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 52.5}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Neon"] = 3.52, ["Neon|Ride"] = 63.67}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.14, ["Fly"] = 91.84, ["Ride"] = 37.65, ["Fly|Ride"] = 107.63, ["Neon"] = 6.57, ["Neon|Fly"] = 168, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 90.57}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Fly|Ride"] = 418.2}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 6.57, ["Fly"] = 77.44, ["Ride"] = 32.8, ["Fly|Ride"] = 98.28, ["Neon"] = 19.69, ["Neon|Fly"] = 69.28, ["Neon|Ride"] = 32.55, ["Neon|Fly|Ride"] = 119.05}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 77.09, ["Neon|Fly|Ride"] = 261.19}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.63, ["Fly|Ride"] = 525, ["Neon"] = 18.38}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.68, ["Neon"] = 16.94}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Neon"] = 5.25, ["Neon|Ride"] = 40.37, ["Neon|Fly|Ride"] = 140.11}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 11.87, ["Fly|Ride"] = 56.47, ["Neon"] = 2.1, ["Neon|Fly"] = 35.32, ["Neon|Ride"] = 15.69, ["Neon|Fly|Ride"] = 32.45}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.1, ["Fly"] = 72.19, ["Ride"] = 237.37, ["Neon"] = 37.41, ["Neon|Ride"] = 140.95}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Ride"] = 52.29, ["Neon|Fly|Ride"] = 52.5}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 3.67, ["Neon"] = 14.18}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.1, ["Fly"] = 91.88, ["Fly|Ride"] = 190.29, ["Neon"] = 65.63, ["Neon|Fly|Ride"] = 140.11}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 19, ["Ride"] = 12.55, ["Fly|Ride"] = 26.31, ["Neon"] = 2.1, ["Neon|Fly"] = 15.62, ["Neon|Ride"] = 14.05, ["Neon|Fly|Ride"] = 30.29}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.24, ["Fly"] = 28.24, ["Ride"] = 37.65, ["Fly|Ride"] = 131.25, ["Neon"] = 17.82, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 196.88}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 2.1, ["Fly|Ride"] = 59.06, ["Neon"] = 65.63, ["Neon|Fly|Ride"] = 262.5}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 32.82, ["Fly|Ride"] = 71.11, ["Neon"] = 2.62, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 15.69, ["Neon|Fly|Ride"] = 35.43}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 3.94, ["Fly"] = 174.6, ["Neon"] = 7.88, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 166.25}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 61.69, ["Neon"] = 3.91, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 142.44}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 41.84, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 131.25}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 70.06, ["Ride"] = 41.84, ["Fly|Ride"] = 46.54, ["Neon"] = 11.51, ["Neon|Fly"] = 53.64, ["Neon|Ride"] = 24.06, ["Neon|Fly|Ride"] = 57.75}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Neon"] = 6.57, ["Neon|Ride"] = 26.25}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 23.01, ["Ride"] = 19.69, ["Fly|Ride"] = 72.19, ["Neon"] = 12.55, ["Neon|Ride"] = 35.62, ["Neon|Fly|Ride"] = 84}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 13.13, ["Ride"] = 36.27, ["Neon"] = 42, ["Neon|Fly"] = 188.89, ["Neon|Fly|Ride"] = 327.3}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 21.45, ["Fly|Ride"] = 57.48, ["Neon"] = 33.7, ["Neon|Fly"] = 56.47, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 140.13}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.1, ["Fly"] = 22.49, ["Fly|Ride"] = 49.16, ["Neon"] = 15.75, ["Neon|Fly"] = 84, ["Neon|Ride"] = 47.49, ["Neon|Fly|Ride"] = 72.19}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 6.4, ["Fly"] = 110.83, ["Neon"] = 71.37}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 11.82, ["Ride"] = 131.25, ["Neon"] = 262.5, ["Neon|Ride"] = 237.38}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 3.05, ["Neon"] = 41.84, ["Neon|Ride"] = 125.47}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 11.25, ["Neon"] = 159.05, ["Neon|Ride"] = 103.51}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Ride"] = 65.01}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 40.69}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 6.28, ["Fly"] = 23.61, ["Ride"] = 27.32, ["Fly|Ride"] = 60.65, ["Neon"] = 51.51, ["Neon|Ride"] = 48.71, ["Neon|Fly|Ride"] = 78.63}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 94.11, ["Ride"] = 13.13, ["Neon"] = 6.02, ["Neon|Fly"] = 32.06, ["Neon|Ride"] = 26.41, ["Neon|Fly|Ride"] = 156.68}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.63, ["Neon"] = 10.46, ["Neon|Ride"] = 33.1}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.63, ["Fly"] = 51.47, ["Fly|Ride"] = 55.65, ["Neon"] = 28.24, ["Neon|Ride"] = 28.49, ["Neon|Fly|Ride"] = 127}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 8.34, ["Fly|Ride"] = 57.75, ["Neon"] = 35.05, ["Neon|Ride"] = 187.53}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Fly"] = 83.66, ["Ride"] = 31.82, ["Neon"] = 3.93}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 21.67, ["Ride"] = 16.87, ["Fly|Ride"] = 32.82, ["Neon"] = 2.85, ["Neon|Fly"] = 111.57, ["Neon|Ride"] = 19.88, ["Neon|Fly|Ride"] = 111.57}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 28.11, ["Ride"] = 18.38, ["Neon"] = 3.94, ["Neon|Fly"] = 91.4, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 61.69}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.63, ["Fly"] = 28.24, ["Fly|Ride"] = 140.11, ["Neon"] = 8.97, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 111.88}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 167.28, ["Neon|Fly|Ride"] = 152881.67}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 45.88, ["Fly|Ride"] = 79.48, ["Neon"] = 3.15, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 85.46}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Neon"] = 3.82, ["Neon|Ride"] = 36.74}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.63, ["Neon"] = 3, ["Neon|Ride"] = 316.89}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 30.33, ["Fly|Ride"] = 69.57, ["Neon"] = 5.25, ["Neon|Ride"] = 17.01, ["Neon|Fly|Ride"] = 59.07}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 12.36, ["Neon"] = 147}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 6.28, ["Fly"] = 6562.5, ["Ride"] = 56.24, ["Neon"] = 41.99}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 6.46, ["Ride"] = 65.63, ["Fly|Ride"] = 177.74}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 12.98, ["Ride"] = 2625, ["Fly|Ride"] = 24.9, ["Neon"] = 2.1, ["Neon|Fly"] = 24.06, ["Neon|Ride"] = 13.38, ["Neon|Fly|Ride"] = 25.8}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 5.25, ["Fly"] = 118.12, ["Neon"] = 5.25, ["Neon|Fly"] = 66.93, ["Neon|Ride"] = 32.43, ["Neon|Fly|Ride"] = 697.34}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 31.38, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 84.16}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 127.32}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 58.56, ["Ride"] = 17.07, ["Fly|Ride"] = 69.57, ["Neon"] = 11.02, ["Neon|Ride"] = 44.97, ["Neon|Fly|Ride"] = 91.77}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 178.35, ["Fly|Ride"] = 836.38}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Neon"] = 10.5, ["Neon|Ride"] = 64.32}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 3.49, ["Fly"] = 103.68, ["Ride"] = 32.06, ["Fly|Ride"] = 65.63, ["Neon"] = 59.07, ["Neon|Ride"] = 94.96, ["Neon|Fly|Ride"] = 167.28}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 13.55, ["Fly|Ride"] = 38.07, ["Neon"] = 4.33, ["Neon|Fly"] = 28.24, ["Neon|Ride"] = 29.55, ["Neon|Fly|Ride"] = 39.38}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 70.06, ["Fly|Ride"] = 92.57, ["Neon"] = 6.36, ["Neon|Ride"] = 78.46, ["Neon|Fly|Ride"] = 118.13}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 6.56, ["Fly"] = 23.49, ["Ride"] = 15.3, ["Fly|Ride"] = 49.86, ["Neon"] = 23.75, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 159.07}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 4.97, ["Ride"] = 41.84, ["Fly|Ride"] = 253.01, ["Neon"] = 91.88, ["Neon|Ride"] = 195.51, ["Neon|Fly|Ride"] = 465.94}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 4.16, ["Fly"] = 23.88, ["Ride"] = 18.83, ["Fly|Ride"] = 41.84, ["Neon"] = 20.26, ["Neon|Fly"] = 76.13, ["Neon|Ride"] = 31.38, ["Neon|Fly|Ride"] = 76.13}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 62.91, ["Fly"] = 121.29, ["Ride"] = 86.47, ["Fly|Ride"] = 148.32, ["Neon"] = 383.71, ["Neon|Fly"] = 437.07, ["Neon|Ride"] = 404.61, ["Neon|Fly|Ride"] = 498.75}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 223.12, ["Fly"] = 334.56, ["Ride"] = 249.38, ["Fly|Ride"] = 315, ["Neon|Ride"] = 2613.66, ["Neon|Fly|Ride"] = 906.46}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 56.17, ["Fly"] = 140.11, ["Ride"] = 74.29, ["Fly|Ride"] = 116.82, ["Neon"] = 712.09, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 416.11}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 7.34, ["Fly"] = 288.42, ["Ride"] = 36.61, ["Fly|Ride"] = 137.67, ["Neon"] = 35.6, ["Neon|Ride"] = 68.25, ["Neon|Fly|Ride"] = 250.95}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 9.49, ["Fly"] = 70.06, ["Ride"] = 34.28, ["Fly|Ride"] = 71.22, ["Neon"] = 81.37, ["Neon|Ride"] = 126.27}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 20.96, ["Ride"] = 26.13, ["Fly|Ride"] = 44.63, ["Neon"] = 4.08, ["Neon|Fly"] = 27.32, ["Neon|Ride"] = 20.58, ["Neon|Fly|Ride"] = 59}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 7.79, ["Fly"] = 90.21, ["Ride"] = 31.38, ["Fly|Ride"] = 62.74, ["Neon"] = 123.69, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 165.19}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 41.91, ["Ride"] = 16.46, ["Fly|Ride"] = 35.44, ["Neon"] = 11.81, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 33.47, ["Neon|Fly|Ride"] = 111.57}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 3.59, ["Ride"] = 27.32, ["Fly|Ride"] = 328.13, ["Neon"] = 28.49, ["Neon|Ride"] = 65.63}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 33.47, ["Ride"] = 36.61, ["Neon"] = 2.1, ["Neon|Ride"] = 19.65, ["Neon|Fly|Ride"] = 57.74}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 28.88, ["Fly|Ride"] = 35.56, ["Neon"] = 15.75, ["Neon|Fly"] = 104.56, ["Neon|Ride"] = 35.56, ["Neon|Fly|Ride"] = 144.38}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.1, ["Fly"] = 24.94, ["Ride"] = 19.69, ["Fly|Ride"] = 61.64, ["Neon"] = 26.25, ["Neon|Ride"] = 47.25}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 118.12, ["Fly"] = 179.82, ["Ride"] = 262.5, ["Fly|Ride"] = 216.33, ["Neon"] = 675.39, ["Neon|Ride"] = 560.44, ["Neon|Fly|Ride"] = 632.63}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 17.82, ["Ride"] = 32.43, ["Fly|Ride"] = 209.11, ["Neon"] = 42, ["Neon|Ride"] = 98.42, ["Neon|Fly|Ride"] = 376.56}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Ride"] = 21, ["Fly|Ride"] = 46.29, ["Neon"] = 19.69, ["Neon|Ride"] = 28.24, ["Neon|Fly|Ride"] = 120.74}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 24.94, ["Ride"] = 56.47, ["Fly|Ride"] = 437.92, ["Neon"] = 177.19, ["Neon|Fly|Ride"] = 696.29}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 3.85}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 5.81, ["Ride"] = 45.94, ["Fly|Ride"] = 126.84, ["Neon"] = 52.5, ["Neon|Fly|Ride"] = 349.19}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 26.11, ["Fly"] = 26.2, ["Ride"] = 30.18, ["Fly|Ride"] = 55.27, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 182.97}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 3.94, ["Neon|Ride"] = 31.38, ["Neon|Fly|Ride"] = 107.63}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 6.28, ["Fly"] = 28.24, ["Ride"] = 25.1, ["Fly|Ride"] = 65.63, ["Neon"] = 45.85, ["Neon|Ride"] = 237.38}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 27.2, ["Fly|Ride"] = 77.38, ["Neon"] = 15.69, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 52.29, ["Neon|Fly|Ride"] = 78.75}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Fly|Ride"] = 78.43, ["Neon"] = 2.63, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 209.11}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 23.77, ["Ride"] = 87.94, ["Fly|Ride"] = 142.43, ["Neon"] = 416.41, ["Neon|Ride"] = 280.88, ["Neon|Fly|Ride"] = 576.19}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Fly|Ride"] = 210, ["Neon"] = 92.26, ["Neon|Ride"] = 140.11}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 2.63, ["Fly"] = 36.61, ["Ride"] = 32.82, ["Fly|Ride"] = 41.84, ["Neon"] = 28.1, ["Neon|Fly"] = 315, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 140.11}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 61.07, ["Fly"] = 433.13, ["Neon"] = 328.13, ["Neon|Ride"] = 543.66}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 6.17, ["Fly"] = 44.63, ["Ride"] = 31.38, ["Fly|Ride"] = 57.66, ["Neon"] = 65.63, ["Neon|Ride"] = 82.6, ["Neon|Fly|Ride"] = 279.16}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 74.8, ["Fly"] = 163.11, ["Ride"] = 104.99, ["Neon"] = 271.69, ["Neon|Ride"] = 223.12}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 22.12, ["Ride"] = 58.56, ["Fly|Ride"] = 140.11, ["Neon"] = 78.75, ["Neon|Ride"] = 140.11, ["Neon|Fly|Ride"] = 264.67}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 5.15, ["Fly"] = 104.13, ["Ride"] = 28.24, ["Fly|Ride"] = 72.43, ["Neon"] = 104.56, ["Neon|Ride"] = 118.02, ["Neon|Fly|Ride"] = 377.47}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 14.2, ["Neon"] = 66.98, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 359.65}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 5.84, ["Ride"] = 44.97, ["Fly|Ride"] = 87.83, ["Neon"] = 140.11, ["Neon|Ride"] = 159.05}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 57.2}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 8.37, ["Ride"] = 316.88, ["Neon"] = 23.78, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 202.78}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Fly"] = 124.43, ["Neon"] = 27.3}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 5.82, ["Ride"] = 140.11, ["Fly|Ride"] = 118.7, ["Neon"] = 32.06, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 262.5}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 511.87, ["Fly|Ride"] = 690.13, ["Neon|Ride"] = 2090.94, ["Neon|Fly|Ride"] = 1782.86}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 9.19, ["Fly"] = 37.65, ["Ride"] = 28.24, ["Fly|Ride"] = 56.35, ["Neon"] = 40.79, ["Neon|Ride"] = 98.28, ["Neon|Fly|Ride"] = 341.25}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 6.03, ["Fly"] = 524.69, ["Ride"] = 32.82, ["Fly|Ride"] = 51.55, ["Neon"] = 74.25, ["Neon|Fly"] = 315, ["Neon|Ride"] = 97.35, ["Neon|Fly|Ride"] = 159.05}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 6.28, ["Fly"] = 91.87, ["Ride"] = 28.24, ["Fly|Ride"] = 313.66, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 131.25}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.61, ["Ride"] = 21.86, ["Fly|Ride"] = 90.57, ["Neon"] = 7.73, ["Neon|Ride"] = 39.35, ["Neon|Fly|Ride"] = 123.44}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 70.06, ["Neon"] = 3.21, ["Neon|Ride"] = 24.33, ["Neon|Fly|Ride"] = 125.47}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1109.07}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 21.67, ["Ride"] = 140.11, ["Fly|Ride"] = 326.21, ["Neon"] = 65.62, ["Neon|Ride"] = 91.75}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 28.26, ["Neon"] = 6.34, ["Neon|Ride"] = 56.44}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 3.94, ["Fly"] = 385.81, ["Neon"] = 22.32, ["Neon|Ride"] = 140.11, ["Neon|Fly|Ride"] = 262.5}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 488.25, ["Ride"] = 525, ["Fly|Ride"] = 556.5, ["Neon|Ride"] = 1415.74, ["Neon|Fly|Ride"] = 2493.75}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 3.4, ["Fly"] = 196.88, ["Ride"] = 56.47, ["Fly|Ride"] = 418.2, ["Neon"] = 36.4, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 189.9}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Fly"] = 90.33, ["Fly|Ride"] = 118.13, ["Neon"] = 6.23, ["Neon|Ride"] = 35.78, ["Neon|Fly|Ride"] = 147.2}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 28.39}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 10.28, ["Fly"] = 111.88, ["Ride"] = 111.57, ["Neon"] = 633.76, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 231.44, ["Neon|Fly|Ride"] = 367.5}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 8.05, ["Neon"] = 96.48, ["Neon|Ride"] = 159.05, ["Neon|Fly|Ride"] = 918.75}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 7.3, ["Ride"] = 70.06, ["Neon"] = 131.25, ["Neon|Ride"] = 179.23}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 12.55, ["Ride"] = 23.63, ["Neon"] = 167.37, ["Neon|Ride"] = 182.44, ["Neon|Fly|Ride"] = 209.13}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 354.38, ["Ride"] = 603.75, ["Neon"] = 1115.63, ["Neon|Ride"] = 1186.81, ["Neon|Fly|Ride"] = 1312.5}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 3.29, ["Fly"] = 78.75, ["Ride"] = 20.01, ["Fly|Ride"] = 279.16, ["Neon"] = 159.05, ["Neon|Ride"] = 208.06}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 6.57, ["Neon"] = 129.66, ["Neon|Ride"] = 221.82}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 21, ["Ride"] = 96.05, ["Neon"] = 79.99, ["Neon|Ride"] = 151.99, ["Neon|Fly|Ride"] = 261.19}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 3.14, ["Neon"] = 7.27, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 269.74}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 40.69, ["Ride"] = 102.69, ["Neon"] = 396.25, ["Neon|Ride"] = 417.15, ["Neon|Fly|Ride"] = 461.07}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 521, ["Ride"] = 26.25, ["Neon"] = 10.61, ["Neon|Fly"] = 181.93, ["Neon|Ride"] = 47.77, ["Neon|Fly|Ride"] = 131.75}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 26.22, ["Ride"] = 86.63, ["Neon"] = 3.94, ["Neon|Ride"] = 51.19, ["Neon|Fly|Ride"] = 90.97}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Ride"] = 72.19, ["Fly|Ride"] = 127.52, ["Neon"] = 15.07, ["Neon|Ride"] = 60.65, ["Neon|Fly|Ride"] = 177.19}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 50.88, ["Fly"] = 94.96, ["Ride"] = 111.88, ["Fly|Ride"] = 269.74, ["Neon"] = 291.38, ["Neon|Fly|Ride"] = 474.74}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 271.84, ["Ride"] = 309.75, ["Fly|Ride"] = 417.15, ["Neon"] = 1462.13, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1497.29}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 4.2, ["Neon"] = 51.19, ["Neon|Fly"] = 350.44}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.63, ["Neon"] = 10.5, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 140.11}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 2.1, ["Fly"] = 159.04, ["Ride"] = 28.1, ["Fly|Ride"] = 95.82, ["Neon"] = 32.82, ["Neon|Ride"] = 70.06}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 3.88, ["Fly"] = 71.11, ["Fly|Ride"] = 372.2, ["Neon"] = 15.74, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 154.74}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Neon"] = 8.54, ["Neon|Fly|Ride"] = 191.34}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 28.24, ["Ride"] = 19.18, ["Fly|Ride"] = 52.49, ["Neon"] = 7.13, ["Neon|Fly"] = 79.53, ["Neon|Ride"] = 255.94, ["Neon|Fly|Ride"] = 418.2}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 3.94, ["Fly"] = 26.25, ["Ride"] = 20.92, ["Fly|Ride"] = 28.38, ["Neon"] = 30.19, ["Neon|Fly"] = 64.96, ["Neon|Ride"] = 26.57, ["Neon|Fly|Ride"] = 111.88}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 34.67, ["Ride"] = 44.97, ["Fly|Ride"] = 78.74, ["Neon"] = 195.51}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 70.88, ["Ride"] = 84.33, ["Fly|Ride"] = 146.39, ["Neon"] = 840, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 393.75}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 23.5, ["Fly|Ride"] = 131.25, ["Neon"] = 2.69, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 27.57}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 14, ["Ride"] = 14.18, ["Fly|Ride"] = 522.75, ["Neon"] = 5.24, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 23.75, ["Neon|Fly|Ride"] = 61.68}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 2.71, ["Neon"] = 40.69, ["Neon|Ride"] = 159.05, ["Neon|Fly|Ride"] = 279.16}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 393.74, ["Ride"] = 543.66, ["Fly|Ride"] = 787.5, ["Neon|Ride"] = 6562.5}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 29.78, ["Fly"] = 101.33, ["Ride"] = 76.13, ["Fly|Ride"] = 108.94, ["Neon"] = 284.85, ["Neon|Ride"] = 227.07, ["Neon|Fly|Ride"] = 465.24}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 25.86, ["Fly|Ride"] = 289.58, ["Neon"] = 8.56, ["Neon|Ride"] = 47.39, ["Neon|Fly|Ride"] = 169.39}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.63, ["Fly"] = 91.88, ["Ride"] = 65.61, ["Neon"] = 17.82, ["Neon|Ride"] = 72.34}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 26.25, ["Fly"] = 170.63, ["Ride"] = 48.11, ["Fly|Ride"] = 106.12, ["Neon"] = 194.25, ["Neon|Ride"] = 355.47, ["Neon|Fly|Ride"] = 316.89}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 77.16, ["Fly"] = 91.88, ["Ride"] = 111.16, ["Fly|Ride"] = 418.2, ["Neon"] = 434.44, ["Neon|Ride"] = 556.2, ["Neon|Fly|Ride"] = 610.32}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 190.21, ["Ride"] = 320.98, ["Fly|Ride"] = 521.7, ["Neon|Ride"] = 1365, ["Neon|Fly|Ride"] = 1312.5}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 12.21, ["Fly"] = 56.47, ["Fly|Ride"] = 119.2, ["Neon"] = 78.75}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 18.32, ["Ride"] = 15.75, ["Fly|Ride"] = 43.31, ["Neon"] = 11.69, ["Neon|Ride"] = 23.14, ["Neon|Fly|Ride"] = 90.97}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 2.63, ["Fly"] = 41.84, ["Ride"] = 20.92, ["Fly|Ride"] = 59.36, ["Neon"] = 70.06, ["Neon|Fly"] = 146.39, ["Neon|Ride"] = 44.51, ["Neon|Fly|Ride"] = 79.53}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 315, ["Fly"] = 488.25, ["Ride"] = 483, ["Fly|Ride"] = 618.93, ["Neon"] = 1575, ["Neon|Ride"] = 2927.32}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.24, ["Neon"] = 10.36}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 5.25, ["Ride"] = 17.06, ["Fly|Ride"] = 126, ["Neon"] = 26.4, ["Neon|Ride"] = 37.93, ["Neon|Fly|Ride"] = 78.74}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 17.06, ["Neon"] = 193.47, ["Neon|Ride"] = 236.25}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 108.94, ["Fly"] = 157.5, ["Ride"] = 109.4, ["Fly|Ride"] = 150.56, ["Neon|Ride"] = 783.3, ["Neon|Fly|Ride"] = 761.25}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 14.42, ["Fly"] = 43.41, ["Ride"] = 28.56, ["Fly|Ride"] = 57.75, ["Neon"] = 104.56, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 131.25}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 56.47, ["Neon"] = 3.15, ["Neon|Ride"] = 140.11}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Fly|Ride"] = 70.06, ["Neon"] = 2.23, ["Neon|Ride"] = 18.95, ["Neon|Fly|Ride"] = 97.13}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 11.19, ["Ride"] = 94.11, ["Fly|Ride"] = 136.85, ["Neon"] = 35.24, ["Neon|Fly"] = 144.38, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 201.93}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1636.69, ["Fly|Ride"] = 1455.57, ["Neon|Ride"] = 4200, ["Neon|Fly|Ride"] = 3976.88}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 446.25, ["Ride"] = 555.16, ["Fly|Ride"] = 739.15, ["Neon"] = 2454.76, ["Neon|Ride"] = 1640.63, ["Neon|Fly|Ride"] = 2362.5}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 323.33, ["Fly|Ride"] = 446.25, ["Neon"] = 656.25, ["Neon|Ride"] = 799.32, ["Neon|Fly|Ride"] = 786.18}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 294, ["Ride"] = 354.38, ["Fly|Ride"] = 416.7, ["Neon"] = 1394.66, ["Neon|Ride"] = 1108.48, ["Neon|Fly|Ride"] = 1050}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Ride"] = 18.38, ["Fly|Ride"] = 37.3, ["Neon"] = 7.88, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 105}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 421.05, ["Fly"] = 1394.66, ["Ride"] = 418.2, ["Fly|Ride"] = 943.95, ["Neon"] = 1574.99, ["Neon|Ride"] = 1365, ["Neon|Fly|Ride"] = 2081.65}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 5.23, ["Fly"] = 183.75, ["Ride"] = 40.79, ["Neon"] = 19.69, ["Neon|Ride"] = 207.34}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.52, ["Fly"] = 18.12, ["Ride"] = 20.92, ["Fly|Ride"] = 31.98, ["Neon"] = 8.37, ["Neon|Ride"] = 32.43, ["Neon|Fly|Ride"] = 140.13}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Neon"] = 3.8, ["Neon|Ride"] = 39.38}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 33.92, ["Fly|Ride"] = 459.38, ["Neon"] = 273, ["Neon|Ride"] = 351.29}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 7912.07, ["Ride"] = 28.49, ["Fly|Ride"] = 68.25, ["Neon"] = 73.5}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Neon"] = 3.54, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 94.89}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 7.88, ["Fly"] = 34.13, ["Ride"] = 20.12, ["Fly|Ride"] = 78.65, ["Neon"] = 17.07, ["Neon|Fly"] = 113.9, ["Neon|Ride"] = 41.54, ["Neon|Fly|Ride"] = 76.13}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 4.15, ["Fly"] = 91.88, ["Ride"] = 35.56, ["Neon"] = 154.74, ["Neon|Ride"] = 159.05, ["Neon|Fly|Ride"] = 131.25}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 10.11, ["Ride"] = 94.96, ["Neon"] = 115.5}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.48, ["Fly"] = 6330.14, ["Neon"] = 63, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 183.73, ["Neon|Fly|Ride"] = 712.09}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 95.15, ["Ride"] = 18.38, ["Fly|Ride"] = 45.94, ["Neon"] = 5.25, ["Neon|Fly"] = 31.38, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 75.29}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 157.5, ["Ride"] = 221.82, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 973.34, ["Neon|Fly|Ride"] = 1036.88}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 19.69, ["Fly|Ride"] = 28.61, ["Neon"] = 3.94, ["Neon|Ride"] = 23.75, ["Neon|Fly|Ride"] = 63}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 6.08, ["Ride"] = 42.37, ["Fly|Ride"] = 183.75, ["Neon"] = 135.31, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 118.13}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 23.4, ["Fly"] = 262.5, ["Fly|Ride"] = 170.63, ["Neon"] = 209.11, ["Neon|Ride"] = 270.21}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 171.94, ["Ride"] = 329.94, ["Fly|Ride"] = 315.57, ["Neon"] = 874.13, ["Neon|Ride"] = 926.29, ["Neon|Fly|Ride"] = 917.44}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 22.76, ["Fly|Ride"] = 140.11, ["Neon"] = 159.05}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 8.63, ["Fly|Ride"] = 627.3, ["Neon"] = 416.07, ["Neon|Fly"] = 159.05, ["Neon|Ride"] = 199.39}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 957.9, ["Ride"] = 1168.13, ["Fly|Ride"] = 1266.28, ["Neon|Ride"] = 4790.63, ["Neon|Fly|Ride"] = 4804.96}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 10.46, ["Fly"] = 19.69, ["Ride"] = 19.81, ["Fly|Ride"] = 52.5, ["Neon"] = 70.88, ["Neon|Fly"] = 106.05, ["Neon|Ride"] = 91.87, ["Neon|Fly|Ride"] = 459.38}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 6.57, ["Fly"] = 51.19, ["Ride"] = 35.44, ["Fly|Ride"] = 135.19, ["Neon"] = 35.21, ["Neon|Ride"] = 157.5}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Fly"] = 82.6, ["Fly|Ride"] = 942.38, ["Neon"] = 11.38, ["Neon|Ride"] = 47.16}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 12.29, ["Ride"] = 41.54, ["Fly|Ride"] = 89.24, ["Neon"] = 85.22, ["Neon|Ride"] = 79.45, ["Neon|Fly|Ride"] = 259.29}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 15.69, ["Fly"] = 32.82, ["Ride"] = 28.24, ["Fly|Ride"] = 51.19, ["Neon"] = 16.76, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 32.43, ["Neon|Fly|Ride"] = 98.28}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 3.94, ["Ride"] = 20.94, ["Neon"] = 12.31, ["Neon|Fly"] = 13125, ["Neon|Fly|Ride"] = 196.88}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 259.88, ["Fly|Ride"] = 2090.94, ["Neon|Fly|Ride"] = 1394.66}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.49, ["Fly"] = 32.82, ["Ride"] = 26.71, ["Fly|Ride"] = 108.74, ["Neon"] = 6.48, ["Neon|Ride"] = 32.55}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 3.19, ["Ride"] = 82.02, ["Fly|Ride"] = 88.87, ["Neon"] = 140.11, ["Neon|Ride"] = 250.92}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 3.03, ["Fly"] = 98.28, ["Neon"] = 20.92, ["Neon|Ride"] = 52.5}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 389.3, ["Fly|Ride"] = 558.3, ["Neon"] = 1312.5, ["Neon|Ride"] = 1837.5}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 23.36, ["Ride"] = 70.06, ["Fly|Ride"] = 522.75, ["Neon"] = 181.33, ["Neon|Fly|Ride"] = 393.75}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 18.8, ["Fly"] = 316.88, ["Ride"] = 164.07, ["Fly|Ride"] = 90.57, ["Neon"] = 96.67, ["Neon|Ride"] = 124.68, ["Neon|Fly|Ride"] = 262.5}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 4.92, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 210}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 44.58, ["Fly"] = 5933.76, ["Ride"] = 90.57, ["Fly|Ride"] = 153.74, ["Neon"] = 292.74, ["Neon|Fly"] = 301.88, ["Neon|Ride"] = 269.06, ["Neon|Fly|Ride"] = 375.34}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 35.36, ["Neon"] = 5.14, ["Neon|Fly|Ride"] = 124.43}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 20.62, ["Fly"] = 127, ["Ride"] = 34.13, ["Fly|Ride"] = 85.46, ["Neon"] = 70.06, ["Neon|Ride"] = 125.15, ["Neon|Fly|Ride"] = 248.07}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 35.8, ["Fly"] = 111.88, ["Ride"] = 140.11, ["Fly|Ride"] = 151.71, ["Neon"] = 183.75, ["Neon|Ride"] = 418.2, ["Neon|Fly|Ride"] = 488.25}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 28.24, ["Ride"] = 17.82, ["Fly|Ride"] = 35.44, ["Neon"] = 2.1, ["Neon|Fly"] = 24.06, ["Neon|Ride"] = 17.81, ["Neon|Fly|Ride"] = 32.82}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 2.89, ["Ride"] = 70.06, ["Fly|Ride"] = 131.75, ["Neon"] = 16.98, ["Neon|Ride"] = 56.47}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 17.78, ["Ride"] = 52.61, ["Fly|Ride"] = 85.32, ["Neon"] = 110.14, ["Neon|Ride"] = 558.3}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 27.57, ["Neon"] = 2.1, ["Neon|Ride"] = 28.86, ["Neon|Fly|Ride"] = 95.8}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 10.57, ["Fly"] = 210, ["Ride"] = 90.97, ["Fly|Ride"] = 179.82, ["Neon"] = 60.38, ["Neon|Ride"] = 172.57, ["Neon|Fly|Ride"] = 443.63}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 9.09, ["Fly"] = 41.84, ["Ride"] = 32.43, ["Fly|Ride"] = 558.3, ["Neon"] = 408.98, ["Neon|Ride"] = 108.7, ["Neon|Fly|Ride"] = 129.94}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 2.1, ["Fly"] = 83.66, ["Ride"] = 18.31, ["Neon"] = 39.38, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 77.44}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 65.55, ["Fly"] = 2090.94, ["Ride"] = 84, ["Neon"] = 51.51, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 6330.17}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Ride"] = 157.85, ["Fly|Ride"] = 196.88, ["Neon"] = 7.07, ["Neon|Ride"] = 32.43}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Neon"] = 4.71}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 19.22}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 36.65, ["Fly"] = 78.75, ["Ride"] = 70.88, ["Neon"] = 238.39, ["Neon|Fly|Ride"] = 313.69}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.15, ["Neon|Ride"] = 110.83}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 446.25, ["Fly"] = 498.75, ["Fly|Ride"] = 791.58, ["Neon"] = 2788.26}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 5.64, ["Fly"] = 26.25, ["Ride"] = 47.49, ["Fly|Ride"] = 131.25, ["Neon"] = 35.39, ["Neon|Fly|Ride"] = 129.94}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.88, ["Fly"] = 52.5, ["Ride"] = 24.94, ["Fly|Ride"] = 70.88, ["Neon"] = 41.84, ["Neon|Ride"] = 40.68, ["Neon|Fly|Ride"] = 125.48}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 185.14, ["Fly"] = 70.06, ["Ride"] = 71.31, ["Fly|Ride"] = 68.17, ["Neon"] = 100.73, ["Neon|Ride"] = 170.42, ["Neon|Fly|Ride"] = 131.25}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 3.14, ["Fly|Ride"] = 721.88, ["Neon"] = 30.33, ["Neon|Ride"] = 118.13}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 65.63, ["Fly"] = 140.11, ["Ride"] = 210, ["Fly|Ride"] = 173.24, ["Neon"] = 101.07, ["Neon|Ride"] = 208.06}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 11.51, ["Ride"] = 53.33, ["Fly|Ride"] = 133.88, ["Neon"] = 32.02, ["Neon|Ride"] = 80.12, ["Neon|Fly|Ride"] = 248.84}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 47.49, ["Ride"] = 13.54, ["Fly|Ride"] = 85.74, ["Neon"] = 2.1, ["Neon|Fly"] = 59.61, ["Neon|Ride"] = 15.48, ["Neon|Fly|Ride"] = 140.11}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 4.75, ["Fly"] = 53.33, ["Ride"] = 39.38, ["Fly|Ride"] = 104.56, ["Neon"] = 39.35, ["Neon|Fly"] = 118.7, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 223.75}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 326.7, ["Ride"] = 341.25, ["Fly|Ride"] = 587.46, ["Neon"] = 1312.5, ["Neon|Ride"] = 1263.94, ["Neon|Fly|Ride"] = 1252.12}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 91.88, ["Ride"] = 140.11, ["Fly|Ride"] = 279.16, ["Neon"] = 558.3, ["Neon|Ride"] = 637.75, ["Neon|Fly|Ride"] = 585.38}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 24.94, ["Fly|Ride"] = 48.11, ["Neon"] = 11.82, ["Neon|Fly"] = 69.53, ["Neon|Ride"] = 32.06, ["Neon|Fly|Ride"] = 78.36}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 24.94, ["Ride"] = 13.4, ["Fly|Ride"] = 34.17, ["Neon"] = 11.51, ["Neon|Fly"] = 41.84, ["Neon|Ride"] = 23.37, ["Neon|Fly|Ride"] = 60.8}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 3.23, ["Fly|Ride"] = 98.44, ["Neon"] = 45.85}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 243.89, ["Fly"] = 420, ["Ride"] = 253.32, ["Fly|Ride"] = 367.5, ["Neon|Ride"] = 1062.22, ["Neon|Fly|Ride"] = 1547.3}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.1, ["Ride"] = 13.55, ["Fly|Ride"] = 44.51, ["Neon"] = 18.38, ["Neon|Fly"] = 104.97, ["Neon|Ride"] = 40.43, ["Neon|Fly|Ride"] = 140.11}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 6.26, ["Ride"] = 98.44, ["Fly|Ride"] = 334.56, ["Neon"] = 70.06, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 279.16}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Neon"] = 6.57, ["Neon|Ride"] = 156.19}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 13.83, ["Fly"] = 26.25, ["Ride"] = 19.56, ["Fly|Ride"] = 102.46, ["Neon"] = 118.13, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 193.47}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 50.58, ["Ride"] = 107.63, ["Fly|Ride"] = 376.39, ["Neon"] = 210, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 199.46, ["Neon|Fly|Ride"] = 331.49}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 23.06, ["Ride"] = 131.25, ["Fly|Ride"] = 96.5, ["Neon"] = 141.81, ["Neon|Ride"] = 418.2, ["Neon|Fly|Ride"] = 304.25}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 20.92, ["Ride"] = 15.69, ["Fly|Ride"] = 62.74, ["Neon"] = 2.63, ["Neon|Fly"] = 28.88, ["Neon|Ride"] = 15.32, ["Neon|Fly|Ride"] = 47.16}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 207.38, ["Ride"] = 280.88, ["Fly|Ride"] = 836.38, ["Neon"] = 2082.64, ["Neon|Fly|Ride"] = 1321.69}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 8.44, ["Fly"] = 101.19, ["Ride"] = 49.41, ["Fly|Ride"] = 105, ["Neon"] = 175.88, ["Neon|Fly|Ride"] = 328.12}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 32.29, ["Ride"] = 17.68, ["Fly|Ride"] = 45.11, ["Neon"] = 7.76, ["Neon|Ride"] = 27.35, ["Neon|Fly|Ride"] = 110.83}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 31.38, ["Ride"] = 27.2, ["Fly|Ride"] = 43.28, ["Neon"] = 3.29, ["Neon|Fly"] = 79.53, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 116.05}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Ride"] = 77.38, ["Fly|Ride"] = 72.19, ["Neon"] = 12.45, ["Neon|Fly"] = 712.09, ["Neon|Ride"] = 71.23, ["Neon|Fly|Ride"] = 99.75}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 7.64, ["Fly"] = 53.33, ["Ride"] = 23.63, ["Fly|Ride"] = 59.07, ["Neon"] = 55.13, ["Neon|Fly"] = 265.56, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 125.49}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 4.51, ["Ride"] = 56.22, ["Neon"] = 64.97, ["Neon|Fly|Ride"] = 288.75}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 52.5}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 10.64, ["Ride"] = 71.22, ["Fly|Ride"] = 131.25, ["Neon"] = 31.18, ["Neon|Fly"] = 138.02, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 258.57}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Neon"] = 6.32, ["Neon|Fly"] = 111.88, ["Neon|Ride"] = 45.8, ["Neon|Fly|Ride"] = 102.3}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 42.74, ["Ride"] = 17.06, ["Fly|Ride"] = 39.38, ["Neon"] = 5.04, ["Neon|Ride"] = 25.1, ["Neon|Fly|Ride"] = 127}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 767.7, ["Ride"] = 682.5, ["Fly|Ride"] = 836.38, ["Neon|Fly|Ride"] = 3543.75}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 14.23, ["Fly|Ride"] = 36.11, ["Neon"] = 18.36, ["Neon|Fly"] = 140.9, ["Neon|Ride"] = 35.79, ["Neon|Fly|Ride"] = 111.57}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 3.31, ["Ride"] = 82.6, ["Neon"] = 9.99, ["Neon|Fly"] = 731.84, ["Neon|Ride"] = 90.97, ["Neon|Fly|Ride"] = 393.75}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 10.32, ["Fly"] = 47.49, ["Ride"] = 25.3, ["Fly|Ride"] = 53.49, ["Neon"] = 50.6, ["Neon|Fly"] = 189.9, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 97.12}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 15.93, ["Fly|Ride"] = 32.82, ["Neon"] = 8.32, ["Neon|Fly"] = 146.39, ["Neon|Ride"] = 26.14, ["Neon|Fly|Ride"] = 69.57}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 42.88, ["Ride"] = 98.28, ["Fly|Ride"] = 279.16, ["Neon"] = 245.86, ["Neon|Ride"] = 268.23}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 27.2, ["Fly|Ride"] = 64.46, ["Neon"] = 5.24, ["Neon|Fly"] = 141.75, ["Neon|Ride"] = 30.74, ["Neon|Fly|Ride"] = 144.31}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 127, ["Ride"] = 28.24, ["Fly|Ride"] = 87.83, ["Neon"] = 13.02, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 111.88}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.37, ["Neon"] = 26.25}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 42, ["Ride"] = 23.36, ["Neon"] = 6.97, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 99.42}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 13.72, ["Fly"] = 19.69, ["Ride"] = 23.01, ["Fly|Ride"] = 37.65, ["Neon"] = 316.89, ["Neon|Ride"] = 80.85, ["Neon|Fly|Ride"] = 98.43}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 713.99, ["Ride"] = 1812.85, ["Fly|Ride"] = 926.63, ["Neon"] = 1837.5, ["Neon|Ride"] = 1967.44, ["Neon|Fly|Ride"] = 2163}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 16.74, ["Fly|Ride"] = 38.07, ["Neon"] = 3.64, ["Neon|Ride"] = 23.01, ["Neon|Fly|Ride"] = 57.75}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 6.9, ["Ride"] = 47.49, ["Neon"] = 47.25, ["Neon|Fly"] = 71.23, ["Neon|Ride"] = 126.14, ["Neon|Fly|Ride"] = 196.88}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 55.13, ["Ride"] = 83.66, ["Fly|Ride"] = 150.94, ["Neon|Ride"] = 474.74, ["Neon|Fly|Ride"] = 393.75}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 33.41, ["Ride"] = 68.85, ["Neon|Ride"] = 219.56, ["Neon|Fly|Ride"] = 697.34}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 11.73, ["Ride"] = 26.25, ["Fly|Ride"] = 140.11, ["Neon"] = 62.74, ["Neon|Ride"] = 140.11, ["Neon|Fly|Ride"] = 116.07}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 27.13, ["Ride"] = 94.96, ["Neon"] = 279.16, ["Neon|Ride"] = 364.37}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 23.63, ["Neon"] = 420, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 525}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 18.26}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 7.34, ["Ride"] = 19.22, ["Fly|Ride"] = 85.32, ["Neon"] = 34.13, ["Neon|Ride"] = 94.11, ["Neon|Fly|Ride"] = 181.93}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 3.13, ["Neon"] = 11.82}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 44.96, ["Fly"] = 418.2, ["Ride"] = 52.45, ["Fly|Ride"] = 99.27, ["Neon"] = 262.5, ["Neon|Ride"] = 216.57, ["Neon|Fly|Ride"] = 949.6}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 2.1, ["Fly"] = 17.7, ["Ride"] = 16.36, ["Fly|Ride"] = 38.41, ["Neon"] = 45.11, ["Neon|Fly"] = 95.15, ["Neon|Ride"] = 32.28, ["Neon|Fly|Ride"] = 81.51}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 6.54, ["Fly"] = 148.47, ["Ride"] = 21.72, ["Fly|Ride"] = 55.7, ["Neon"] = 15.69, ["Neon|Ride"] = 71.23, ["Neon|Fly|Ride"] = 128.63}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 7.88}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 24.66, ["Fly"] = 77.17, ["Ride"] = 39.38, ["Fly|Ride"] = 89.25, ["Neon"] = 945, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 308.59}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 105, ["Fly|Ride"] = 65.63, ["Neon"] = 6.57, ["Neon|Ride"] = 32.43}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 9.19, ["Ride"] = 140.11, ["Neon"] = 75.29, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 393.75}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 20.92, ["Fly|Ride"] = 40.64, ["Neon"] = 18.74, ["Neon|Ride"] = 40.72, ["Neon|Fly|Ride"] = 75.88}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 2.1, ["Fly"] = 52.49, ["Ride"] = 23.24, ["Fly|Ride"] = 75.12, ["Neon"] = 31.5, ["Neon|Ride"] = 418.2}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 3.67, ["Ride"] = 33.47, ["Neon"] = 79.53, ["Neon|Ride"] = 227.07}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 45, ["Ride"] = 263.82, ["Neon"] = 291.97, ["Neon|Fly|Ride"] = 791.61}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 16.62, ["Neon"] = 107.63, ["Neon|Ride"] = 262.5}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 12.55, ["Neon"] = 171.63, ["Neon|Fly"] = 209.11, ["Neon|Ride"] = 418.2}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 19.28, ["Fly|Ride"] = 367.46, ["Neon"] = 103.36, ["Neon|Ride"] = 731.84, ["Neon|Fly|Ride"] = 328.13}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 3.94, ["Neon"] = 20.92}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 128.63, ["Ride"] = 19.68, ["Fly|Ride"] = 40.61, ["Neon"] = 3.72, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 41.84, ["Neon|Fly|Ride"] = 93.19}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 6.26, ["Fly|Ride"] = 65.63, ["Neon"] = 26.25, ["Neon|Ride"] = 41.56, ["Neon|Fly|Ride"] = 164.07}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 19.69, ["Fly|Ride"] = 56.47, ["Neon"] = 9.19, ["Neon|Ride"] = 25.6, ["Neon|Fly|Ride"] = 78.75}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 3.67, ["Fly"] = 65.63, ["Fly|Ride"] = 118.13, ["Neon"] = 15.69, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 259.29}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 19.69, ["Fly"] = 65.63, ["Ride"] = 35.56, ["Neon"] = 25.62, ["Neon|Fly"] = 315, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 196.88}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 6.57, ["Fly"] = 131.25, ["Ride"] = 26.23, ["Fly|Ride"] = 95.15, ["Neon"] = 24.06, ["Neon|Fly"] = 111.88, ["Neon|Ride"] = 40.37, ["Neon|Fly|Ride"] = 118.13}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 3.94, ["Fly"] = 33.72, ["Ride"] = 19.69, ["Fly|Ride"] = 51.89, ["Neon"] = 36.75, ["Neon|Ride"] = 70.06, ["Neon|Fly|Ride"] = 196.88}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Ride"] = 68.85, ["Fly|Ride"] = 131.25, ["Neon"] = 19.68, ["Neon|Fly"] = 437.07, ["Neon|Ride"] = 61.7, ["Neon|Fly|Ride"] = 142.21}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 17.81, ["Ride"] = 105, ["Fly|Ride"] = 359.65, ["Neon"] = 108.94, ["Neon|Ride"] = 418.2, ["Neon|Fly|Ride"] = 528.22}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 51.19, ["Fly"] = 164.07, ["Ride"] = 103.03, ["Fly|Ride"] = 488.95, ["Neon"] = 269.07, ["Neon|Ride"] = 316.89, ["Neon|Fly|Ride"] = 488.98}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 50.97, ["Ride"] = 41.84, ["Fly|Ride"] = 65.63, ["Neon"] = 3.82, ["Neon|Ride"] = 32.82}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 65.29, ["Neon"] = 159.05}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 55.12, ["Neon"] = 354.38, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 835.34}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 3.61, ["Fly"] = 190.32, ["Fly|Ride"] = 133.88, ["Neon"] = 40.69, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 210}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 3.85, ["Fly|Ride"] = 141.75, ["Neon"] = 13.11, ["Neon|Ride"] = 65.63}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 29.01, ["Ride"] = 24.06, ["Fly|Ride"] = 48.7, ["Neon"] = 11.42, ["Neon|Ride"] = 40.37, ["Neon|Fly|Ride"] = 70.88}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 19.88, ["Fly|Ride"] = 41.84, ["Neon"] = 2.63, ["Neon|Fly"] = 17.78, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 61.7}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 19.88, ["Fly|Ride"] = 89.93, ["Neon"] = 5.25, ["Neon|Ride"] = 17.82, ["Neon|Fly|Ride"] = 124.69}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Neon"] = 2.59, ["Neon|Ride"] = 145.08}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 10.5, ["Neon"] = 47.49, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 627.3}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 5.7, ["Fly|Ride"] = 209.11, ["Neon"] = 58.33, ["Neon|Ride"] = 206.52, ["Neon|Fly|Ride"] = 184.02}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 9.37, ["Fly"] = 40.37, ["Ride"] = 19.76, ["Fly|Ride"] = 38.07, ["Neon"] = 56.47, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 101.68}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 56.2, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 447.47}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 25.3, ["Fly"] = 82.69, ["Ride"] = 31.4, ["Neon"] = 250.92, ["Neon|Fly|Ride"] = 630}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 26.25, ["Fly|Ride"] = 35.44, ["Neon"] = 2.63, ["Neon|Fly"] = 41.84, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 62.74}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 13.13, ["Fly|Ride"] = 30.26, ["Neon"] = 3.94, ["Neon|Fly"] = 27.2, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 45.12}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 690.02, ["Fly"] = 554.23, ["Ride"] = 669.11, ["Fly|Ride"] = 557.82, ["Neon|Fly|Ride"] = 2098.69}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 24.94, ["Ride"] = 131.25, ["Neon"] = 47.49}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 24.92, ["Fly|Ride"] = 27.82, ["Neon"] = 5.25, ["Neon|Fly"] = 23.75, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 38.31}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 58.11, ["Fly|Ride"] = 522.75, ["Neon"] = 241.6, ["Neon|Ride"] = 269.41, ["Neon|Fly|Ride"] = 461.07}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 37.65, ["Ride"] = 18.09, ["Fly|Ride"] = 55.13, ["Neon"] = 14.57, ["Neon|Fly"] = 61.7, ["Neon|Ride"] = 30.33, ["Neon|Fly|Ride"] = 70.88}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 69.57, ["Ride"] = 70.06, ["Neon"] = 3.15, ["Neon|Ride"] = 40.37, ["Neon|Fly|Ride"] = 74.82}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 42, ["Fly"] = 209.11, ["Ride"] = 70.06, ["Fly|Ride"] = 195.51, ["Neon"] = 184.85, ["Neon|Ride"] = 202.13, ["Neon|Fly|Ride"] = 393.75}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Fly"] = 15.69, ["Ride"] = 38.07, ["Neon"] = 4.6, ["Neon|Ride"] = 40.45}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 34.67, ["Fly|Ride"] = 142.43, ["Neon"] = 418.2, ["Neon|Fly|Ride"] = 359.63}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 3.14, ["Neon"] = 23.09, ["Neon|Ride"] = 47.49, ["Neon|Fly|Ride"] = 488.31}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.1, ["Ride"] = 78.75, ["Fly|Ride"] = 70.06, ["Neon"] = 7.88, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 406.88}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 43.02, ["Ride"] = 83.66, ["Fly|Ride"] = 522.75}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.35, ["Fly"] = 305.39, ["Ride"] = 24.86, ["Fly|Ride"] = 908.98, ["Neon"] = 6.57, ["Neon|Ride"] = 140.11, ["Neon|Fly|Ride"] = 144.38}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 18.96, ["Ride"] = 22.32, ["Fly|Ride"] = 101.82, ["Neon"] = 10.9, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 196.88}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 9.11, ["Fly"] = 58.5, ["Ride"] = 32.69, ["Fly|Ride"] = 103.51, ["Neon"] = 81.78, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 418.2}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 9.74, ["Ride"] = 32.79, ["Fly|Ride"] = 71.3, ["Neon"] = 148.32, ["Neon|Ride"] = 140.11, ["Neon|Fly|Ride"] = 196.88}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 23.63, ["Fly"] = 51.19, ["Ride"] = 26.25, ["Fly|Ride"] = 64.11, ["Neon"] = 120.24, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 154.74}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 65.2, ["Ride"] = 118.13, ["Fly|Ride"] = 259.88, ["Neon"] = 359.63, ["Neon|Ride"] = 488.25, ["Neon|Fly|Ride"] = 735.82}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 6.08, ["Ride"] = 56.05, ["Neon"] = 39.38, ["Neon|Ride"] = 522.75}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 3.69, ["Ride"] = 26.88, ["Fly|Ride"] = 78.74, ["Neon"] = 25.17, ["Neon|Ride"] = 59.36, ["Neon|Fly|Ride"] = 125.47}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 7.03, ["Ride"] = 35.44, ["Fly|Ride"] = 109.83, ["Neon"] = 84, ["Neon|Ride"] = 209.11, ["Neon|Fly|Ride"] = 237.38}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.33, ["Ride"] = 12.55, ["Fly|Ride"] = 32.82, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 15.69, ["Neon|Fly|Ride"] = 56.47}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 52.49, ["Ride"] = 104.99, ["Neon"] = 416.58, ["Neon|Fly"] = 2370.08, ["Neon|Ride"] = 294, ["Neon|Fly|Ride"] = 497.65}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 20.92, ["Fly|Ride"] = 140.11, ["Neon"] = 6.09, ["Neon|Ride"] = 27.44, ["Neon|Fly|Ride"] = 196.88}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 28.24, ["Ride"] = 15.75, ["Fly|Ride"] = 59.07, ["Neon"] = 31.38, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 120.65}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 65.63, ["Fly"] = 157.5, ["Ride"] = 118.13, ["Fly|Ride"] = 258.57, ["Neon"] = 415.38, ["Neon|Ride"] = 684.79}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 25.26, ["Neon"] = 7.56, ["Neon|Ride"] = 70.06}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 15.75}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Neon"] = 7.61, ["Neon|Ride"] = 50.28, ["Neon|Fly|Ride"] = 262.5}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 114.34, ["Ride"] = 279.16, ["Fly|Ride"] = 417.15, ["Neon"] = 836.07, ["Neon|Ride"] = 696.67, ["Neon|Fly|Ride"] = 917.44}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 2.52, ["Neon"] = 19.57, ["Neon|Fly"] = 140.11, ["Neon|Ride"] = 65.63}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Neon"] = 6.57, ["Neon|Ride"] = 26.25}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 10.4, ["Ride"] = 19.52, ["Neon"] = 65.63, ["Neon|Ride"] = 64.11, ["Neon|Fly|Ride"] = 164.07}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 10.39, ["Fly"] = 53.39, ["Ride"] = 28.24, ["Fly|Ride"] = 55.79, ["Neon"] = 135.31, ["Neon|Ride"] = 131.25}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 18.06, ["Ride"] = 89.92, ["Fly|Ride"] = 111.88, ["Neon"] = 131.24, ["Neon|Ride"] = 279.16, ["Neon|Fly|Ride"] = 1575}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 131.23, ["Fly"] = 279.16, ["Ride"] = 203.44, ["Fly|Ride"] = 216.57, ["Neon"] = 759.56, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 654.94}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 311.75, ["Ride"] = 1581.96, ["Fly|Ride"] = 342.45, ["Neon"] = 471.15, ["Neon|Ride"] = 767.39, ["Neon|Fly|Ride"] = 836.38}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.1, ["Fly"] = 131.23, ["Ride"] = 35.56, ["Fly|Ride"] = 131.25, ["Neon"] = 21, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 196.88}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 8.37, ["Fly"] = 98.44, ["Neon"] = 62.42, ["Neon|Ride"] = 80.06, ["Neon|Fly|Ride"] = 156.84}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 51.19, ["Fly"] = 142.43, ["Ride"] = 77.01, ["Fly|Ride"] = 223.75, ["Neon"] = 316.89, ["Neon|Ride"] = 279.16, ["Neon|Fly|Ride"] = 329.38}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 20.92, ["Ride"] = 83.15, ["Neon"] = 170.51, ["Neon|Ride"] = 558.3, ["Neon|Fly|Ride"] = 461.07}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 327.39, ["Ride"] = 615.57, ["Neon|Ride"] = 3165.2}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 40.4, ["Fly"] = 70.06, ["Ride"] = 38.4, ["Fly|Ride"] = 75.87, ["Neon"] = 418.2, ["Neon|Ride"] = 229.69, ["Neon|Fly|Ride"] = 463.2}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 39.2, ["Ride"] = 15.69, ["Neon"] = 3.78, ["Neon|Ride"] = 18.06, ["Neon|Fly|Ride"] = 40.25}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 2.1, ["Neon"] = 22.32, ["Neon|Ride"] = 69.57, ["Neon|Fly|Ride"] = 263.47}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 4.2, ["Ride"] = 64.11, ["Fly|Ride"] = 144.21, ["Neon"] = 19.61, ["Neon|Ride"] = 140.11, ["Neon|Fly|Ride"] = 976.48}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 406.88, ["Ride"] = 439.69, ["Neon"] = 1568.21, ["Neon|Ride"] = 9187.5, ["Neon|Fly|Ride"] = 1672.76}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 3.94, ["Fly"] = 70.06, ["Ride"] = 17.07, ["Fly|Ride"] = 61.7, ["Neon"] = 32.06, ["Neon|Ride"] = 140.11, ["Neon|Fly|Ride"] = 104.56}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 5.67, ["Fly"] = 22.32, ["Ride"] = 17.3, ["Fly|Ride"] = 44.63, ["Neon"] = 43.25, ["Neon|Fly"] = 156.45, ["Neon|Fly|Ride"] = 118.13}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 4.2, ["Fly"] = 44.97, ["Ride"] = 28.88, ["Neon"] = 10.63, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 56.98, ["Neon|Fly|Ride"] = 107.33}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 39.38, ["Fly"] = 46.29, ["Ride"] = 61.72, ["Fly|Ride"] = 65.63, ["Neon"] = 140.11, ["Neon|Ride"] = 174.66, ["Neon|Fly|Ride"] = 312.61}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 28.24, ["Fly|Ride"] = 50.3, ["Neon"] = 15.75, ["Neon|Ride"] = 108.74, ["Neon|Fly|Ride"] = 210}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 7.3, ["Fly"] = 787.5, ["Neon"] = 185.73, ["Neon|Ride"] = 210}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Neon"] = 6.06, ["Neon|Ride"] = 35.11}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 4.87, ["Neon"] = 85.32}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 6.47, ["Neon"] = 78.91, ["Neon|Ride"] = 474.74, ["Neon|Fly|Ride"] = 418.2}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 8.87, ["Fly"] = 27.63, ["Ride"] = 24.94, ["Fly|Ride"] = 99.75, ["Neon"] = 52.5, ["Neon|Fly"] = 70.06, ["Neon|Ride"] = 45.93, ["Neon|Fly|Ride"] = 119.44}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 343.88, ["Ride"] = 410.12, ["Fly|Ride"] = 482.99, ["Neon"] = 1659, ["Neon|Ride"] = 1462.62, ["Neon|Fly|Ride"] = 1470}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.63, ["Ride"] = 15.65, ["Fly|Ride"] = 26.25, ["Neon"] = 28.24, ["Neon|Fly"] = 79.53, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 262.49}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 7.79, ["Fly"] = 111.88, ["Fly|Ride"] = 94.96, ["Neon"] = 43.84, ["Neon|Ride"] = 156.84, ["Neon|Fly|Ride"] = 406.88}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 36.75, ["Ride"] = 393.75, ["Fly|Ride"] = 315, ["Neon"] = 112.82, ["Neon|Ride"] = 292.74, ["Neon|Fly|Ride"] = 411.83}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 68.25, ["Neon"] = 2848.32, ["Neon|Ride"] = 1463.67, ["Neon|Fly|Ride"] = 1254.57}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 68.85, ["Ride"] = 119.2, ["Fly|Ride"] = 127.74, ["Neon"] = 125.72, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 360.94}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 19.59, ["Fly|Ride"] = 59.07, ["Neon"] = 13.13, ["Neon|Ride"] = 33.53, ["Neon|Fly|Ride"] = 69.57}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 10.46, ["Ride"] = 57.84, ["Neon"] = 26.25, ["Neon|Ride"] = 106.82, ["Neon|Fly|Ride"] = 174.57}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 63.14, ["Fly"] = 183.75, ["Ride"] = 102.38, ["Fly|Ride"] = 198.81, ["Neon"] = 150.94, ["Neon|Ride"] = 197.03, ["Neon|Fly|Ride"] = 354.38}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 5.23, ["Ride"] = 131.25, ["Neon"] = 17.07, ["Neon|Ride"] = 254, ["Neon|Fly|Ride"] = 199.5}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 19.69, ["Neon"] = 140.11, ["Neon|Ride"] = 401.03}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 1023.75, ["Fly"] = 2090.94, ["Ride"] = 1050, ["Fly|Ride"] = 1086.65, ["Neon"] = 3326.69, ["Neon|Ride"] = 3596.4, ["Neon|Fly|Ride"] = 3221.36}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 13.08, ["Fly"] = 82.41, ["Ride"] = 78.35, ["Fly|Ride"] = 194.25, ["Neon"] = 90.97, ["Neon|Fly"] = 696.29, ["Neon|Ride"] = 157.5}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.1, ["Fly"] = 49.34, ["Ride"] = 28.24, ["Fly|Ride"] = 80.89, ["Neon"] = 13.13, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 92.02}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 11.25, ["Fly|Ride"] = 140.11, ["Neon"] = 141.75}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Fly|Ride"] = 181.93, ["Neon"] = 3.66, ["Neon|Ride"] = 24.06, ["Neon|Fly|Ride"] = 91.66}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 71.93, ["Fly|Ride"] = 310.94, ["Neon"] = 260.74, ["Neon|Ride"] = 363.84, ["Neon|Fly|Ride"] = 404.61}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 10.22, ["Ride"] = 65.63, ["Fly|Ride"] = 279.16, ["Neon"] = 70.06, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 262.31}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2.1, ["Ride"] = 36.61, ["Neon"] = 13.13, ["Neon|Ride"] = 65.62}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 21.55, ["Fly"] = 65.88, ["Ride"] = 41.08, ["Fly|Ride"] = 161.44, ["Neon"] = 140.11, ["Neon|Ride"] = 95.82, ["Neon|Fly|Ride"] = 140.17}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 5.04, ["Ride"] = 72.19, ["Fly|Ride"] = 102.08, ["Neon"] = 49.88, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 315}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 39.75, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 906.43}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 6.28, ["Neon"] = 32.81, ["Neon|Ride"] = 102.46, ["Neon|Fly|Ride"] = 633.76}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 6.39, ["Ride"] = 30.87, ["Fly|Ride"] = 92.02, ["Neon"] = 142.44, ["Neon|Ride"] = 140.11}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 144.38, ["Fly"] = 179.83, ["Fly|Ride"] = 207.9, ["Neon"] = 656.25, ["Neon|Ride"] = 839.08, ["Neon|Fly|Ride"] = 765.3}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 3.82, ["Fly"] = 36.75, ["Ride"] = 34.43, ["Fly|Ride"] = 39.38, ["Neon"] = 12.2, ["Neon|Fly"] = 57.53, ["Neon|Ride"] = 34.43, ["Neon|Fly|Ride"] = 70.67}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 6.14, ["Fly"] = 193.47, ["Ride"] = 38.74, ["Fly|Ride"] = 116.81, ["Neon"] = 97.13, ["Neon|Fly"] = 316.89, ["Neon|Ride"] = 82.84, ["Neon|Fly|Ride"] = 246.75}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 19.69, ["Neon"] = 2.1, ["Neon|Fly"] = 26.56, ["Neon|Ride"] = 15.51, ["Neon|Fly|Ride"] = 39.38}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Neon"] = 3.67, ["Neon|Ride"] = 41.84, ["Neon|Fly|Ride"] = 129.66}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 3.94, ["Fly"] = 35.56, ["Ride"] = 26.04, ["Fly|Ride"] = 104, ["Neon"] = 16.98, ["Neon|Ride"] = 60.54, ["Neon|Fly|Ride"] = 217.47}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 30.18, ["Ride"] = 52.49, ["Fly|Ride"] = 131.25, ["Neon"] = 168, ["Neon|Ride"] = 668.07, ["Neon|Fly|Ride"] = 433.13}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 3.45, ["Fly"] = 17.07, ["Ride"] = 15.69, ["Fly|Ride"] = 39.35, ["Neon"] = 14.06, ["Neon|Fly"] = 26.16, ["Neon|Ride"] = 28.04, ["Neon|Fly|Ride"] = 65.57}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 8.16, ["Fly"] = 40.69, ["Ride"] = 44.63, ["Fly|Ride"] = 87.72, ["Neon"] = 27.57, ["Neon|Fly"] = 55.86, ["Neon|Ride"] = 36.89, ["Neon|Fly|Ride"] = 118.13}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Fly"] = 22.32, ["Ride"] = 26.25, ["Fly|Ride"] = 39.38, ["Neon"] = 15.69, ["Neon|Fly"] = 35.56, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 89.24}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 7.31, ["Fly"] = 169.32, ["Ride"] = 47.49, ["Neon"] = 35.56, ["Neon|Ride"] = 110.83, ["Neon|Fly|Ride"] = 836.38}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 6.48, ["Neon"] = 39.37, ["Neon|Ride"] = 262.5}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 13.13, ["Fly"] = 49.86, ["Ride"] = 18.36, ["Fly|Ride"] = 60.65, ["Neon"] = 22.32, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 171.94}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 24.85, ["Ride"] = 19.59, ["Fly|Ride"] = 35.62, ["Neon"] = 16.11, ["Neon|Fly"] = 47.49, ["Neon|Ride"] = 35.56, ["Neon|Fly|Ride"] = 78.75}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 203.44, ["Fly"] = 393.75, ["Ride"] = 316.88, ["Fly|Ride"] = 499.74, ["Neon"] = 1212.75, ["Neon|Ride"] = 1424.17, ["Neon|Fly|Ride"] = 1181.25}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 5.97, ["Neon"] = 63}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 3.92, ["Fly"] = 104.56, ["Ride"] = 24.69, ["Fly|Ride"] = 52.5, ["Neon"] = 23.15, ["Neon|Fly"] = 237.34, ["Neon|Ride"] = 69.02, ["Neon|Fly|Ride"] = 262.5}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 6.57, ["Fly|Ride"] = 212.89, ["Neon"] = 52.5, ["Neon|Ride"] = 221.66, ["Neon|Fly|Ride"] = 627.3}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 16.28, ["Fly|Ride"] = 28.98, ["Neon"] = 2.63, ["Neon|Fly"] = 28.88, ["Neon|Ride"] = 15.65, ["Neon|Fly|Ride"] = 39.38}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.1, ["Fly"] = 42, ["Ride"] = 57.75, ["Fly|Ride"] = 111.88, ["Neon"] = 7.93, ["Neon|Ride"] = 27.77, ["Neon|Fly|Ride"] = 99.75}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 3.92, ["Neon"] = 15.61, ["Neon|Ride"] = 279.16, ["Neon|Fly|Ride"] = 393.75}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 94.59, ["Fly"] = 166.16, ["Ride"] = 119.2, ["Fly|Ride"] = 167.28, ["Neon"] = 556.5, ["Neon|Ride"] = 413.44, ["Neon|Fly|Ride"] = 633.76}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 6.45, ["Fly"] = 98.28, ["Ride"] = 28.88, ["Fly|Ride"] = 18038.6, ["Neon"] = 22.78, ["Neon|Ride"] = 170.42, ["Neon|Fly|Ride"] = 418.2}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Ride"] = 56.47, ["Neon"] = 6.57, ["Neon|Ride"] = 177.06, ["Neon|Fly|Ride"] = 532.89}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 48.87, ["Fly"] = 210, ["Ride"] = 107.69, ["Neon"] = 196.88, ["Neon|Ride"] = 220.5, ["Neon|Fly|Ride"] = 301.88}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Ride"] = 14.44, ["Fly|Ride"] = 91.88, ["Neon"] = 2.1, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 14.62, ["Neon|Fly|Ride"] = 31.5}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Neon"] = 5.25, ["Neon|Ride"] = 558.3, ["Neon|Fly|Ride"] = 285.31}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 107.63, ["Neon"] = 8.17, ["Neon|Ride"] = 101.07, ["Neon|Fly|Ride"] = 340.83}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 4.46, ["Fly"] = 78.75, ["Ride"] = 164.07, ["Fly|Ride"] = 236.25, ["Neon"] = 22.44, ["Neon|Fly"] = 91.55, ["Neon|Ride"] = 77.76, ["Neon|Fly|Ride"] = 459.38}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 12.55, ["Ride"] = 12.43, ["Fly|Ride"] = 91.34, ["Neon"] = 2.1, ["Neon|Fly"] = 25.1, ["Neon|Fly|Ride"] = 67.19}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 21, ["Fly"] = 131.25, ["Ride"] = 204.75, ["Neon"] = 129.93, ["Neon|Fly|Ride"] = 1312.5}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 3937.5, ["Ride"] = 2493.75, ["Fly|Ride"] = 2493.75}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 116.06, ["Ride"] = 15.31, ["Fly|Ride"] = 44.63, ["Neon"] = 11.51, ["Neon|Fly"] = 64.11, ["Neon|Ride"] = 25.1, ["Neon|Fly|Ride"] = 72.12}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 3.94, ["Neon"] = 4.39}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 20.62, ["Fly"] = 111.88, ["Ride"] = 32.43, ["Fly|Ride"] = 70.06, ["Neon"] = 70.16, ["Neon|Ride"] = 103.79, ["Neon|Fly|Ride"] = 294.38}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 35.44, ["Ride"] = 50.23, ["Neon"] = 187.69}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 158.58, ["Fly"] = 1394.66, ["Ride"] = 316.88, ["Fly|Ride"] = 284.84, ["Neon"] = 1312.5, ["Neon|Ride"] = 700.41, ["Neon|Fly|Ride"] = 820.99}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 6.57, ["Fly|Ride"] = 675.94, ["Neon"] = 22.57, ["Neon|Ride"] = 140.11}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.63, ["Fly|Ride"] = 70.06, ["Neon"] = 26.25, ["Neon|Ride"] = 114.85}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Ride"] = 53.33, ["Neon"] = 9.17, ["Neon|Ride"] = 28.24, ["Neon|Fly|Ride"] = 140.13}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 9.19, ["Neon"] = 204.75, ["Neon|Ride"] = 1190.36}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 41.84, ["Neon"] = 2.1, ["Neon|Ride"] = 47.67}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 89.02, ["Fly"] = 266.61, ["Ride"] = 132.79, ["Fly|Ride"] = 159.04, ["Neon"] = 366.19, ["Neon|Ride"] = 401.06, ["Neon|Fly|Ride"] = 836.38}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.37, ["Ride"] = 91.84, ["Neon"] = 10.4, ["Neon|Ride"] = 154.74}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 39.38, ["Fly"] = 221.93, ["Ride"] = 104.45, ["Fly|Ride"] = 79.52, ["Neon"] = 295.32, ["Neon|Ride"] = 485.63, ["Neon|Fly|Ride"] = 532.88}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Fly|Ride"] = 51.06, ["Neon"] = 5.23, ["Neon|Fly"] = 87.45, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 83.99}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 3.94, ["Neon"] = 10.49, ["Neon|Ride"] = 98.44}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 4.55, ["Fly"] = 77.44, ["Ride"] = 39.38, ["Fly|Ride"] = 209.11, ["Neon"] = 67.2, ["Neon|Ride"] = 120.24}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 350.41, ["Fly|Ride"] = 519.99, ["Neon"] = 1048.68, ["Neon|Ride"] = 964.66, ["Neon|Fly|Ride"] = 1881.85}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 31.24, ["Fly"] = 83.66, ["Ride"] = 52.5, ["Fly|Ride"] = 104.56, ["Neon"] = 196.88, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 376.39}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.63, ["Fly"] = 49.88, ["Ride"] = 17.89, ["Fly|Ride"] = 150.94, ["Neon"] = 10.25, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 131.25}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 21.81, ["Fly"] = 74.81, ["Ride"] = 75.29, ["Fly|Ride"] = 178.79, ["Neon"] = 69.57, ["Neon|Ride"] = 129.93, ["Neon|Fly|Ride"] = 182.11}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 6.23, ["Ride"] = 124.43, ["Fly|Ride"] = 83.66, ["Neon"] = 141.16, ["Neon|Ride"] = 91.87, ["Neon|Fly|Ride"] = 269.41}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.94, ["Neon"] = 17.07}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.49, ["Fly"] = 39.38, ["Ride"] = 27.57, ["Fly|Ride"] = 56.47, ["Neon"] = 39.29, ["Neon|Ride"] = 45.47, ["Neon|Fly|Ride"] = 273.93}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 98.44, ["Ride"] = 131.25, ["Fly|Ride"] = 236.25, ["Neon"] = 1028.97, ["Neon|Ride"] = 582.65, ["Neon|Fly|Ride"] = 651}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 27.61, ["Ride"] = 139.13, ["Fly|Ride"] = 118.13, ["Neon"] = 192.94, ["Neon|Ride"] = 209.11}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 1995, ["Fly"] = 3624.64, ["Fly|Ride"] = 2165.63, ["Neon"] = 11151.97, ["Neon|Fly|Ride"] = 6424.69}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 3.94, ["Fly"] = 65625, ["Ride"] = 32.82, ["Neon"] = 21.04}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 6.65, ["Ride"] = 279.16, ["Neon"] = 36.78, ["Neon|Ride"] = 94.96}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 1198.12, ["Fly"] = 948.54, ["Ride"] = 1266.28, ["Fly|Ride"] = 987, ["Neon"] = 4745.37, ["Neon|Ride"] = 2611.88, ["Neon|Fly|Ride"] = 2493.75}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 29.98, ["Ride"] = 52.49, ["Fly|Ride"] = 173.35, ["Neon"] = 176.81, ["Neon|Fly|Ride"] = 375.04}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 3.82, ["Ride"] = 39.38, ["Fly|Ride"] = 128.15, ["Neon"] = 24.92, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 328.13}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Neon"] = 3.83, ["Neon|Ride"] = 70.06, ["Neon|Fly|Ride"] = 92.02}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 87.86, ["Ride"] = 129.94, ["Fly|Ride"] = 209.11, ["Neon"] = 418.2, ["Neon|Ride"] = 593.41, ["Neon|Fly|Ride"] = 627.3}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 2.1, ["Neon"] = 11.82, ["Neon|Ride"] = 132.93, ["Neon|Fly|Ride"] = 279.18}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 76.56, ["Ride"] = 154.74, ["Neon"] = 614.25, ["Neon|Ride"] = 417.15, ["Neon|Fly|Ride"] = 513.34}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 3.9, ["Fly"] = 105, ["Neon"] = 35.43, ["Neon|Fly|Ride"] = 315}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 281.13, ["Ride"] = 35602.48, ["Fly|Ride"] = 350.25, ["Neon"] = 1498.88, ["Neon|Ride"] = 1062.2, ["Neon|Fly|Ride"] = 934.23}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 4.2, ["Fly"] = 87.94, ["Ride"] = 28.24, ["Fly|Ride"] = 105, ["Neon"] = 28.87, ["Neon|Fly"] = 159.05, ["Neon|Ride"] = 57.1, ["Neon|Fly|Ride"] = 100.59}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 21.38, ["Ride"] = 14.53, ["Fly|Ride"] = 39.35, ["Neon"] = 6.27, ["Neon|Fly"] = 31.39, ["Neon|Ride"] = 21.61, ["Neon|Fly|Ride"] = 52.45}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 1252.48, ["Ride"] = 1050, ["Fly|Ride"] = 1422.75, ["Neon|Ride"] = 7667.44, ["Neon|Fly|Ride"] = 6063.7}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 10.5, ["Fly"] = 976.48, ["Ride"] = 210, ["Neon"] = 72.71, ["Neon|Ride"] = 131.75}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 7.39, ["Fly"] = 50.19, ["Ride"] = 57.67, ["Fly|Ride"] = 79.59, ["Neon"] = 26.23, ["Neon|Fly"] = 159.05, ["Neon|Ride"] = 54.71, ["Neon|Fly|Ride"] = 279.16}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 34.29, ["Fly"] = 48.57, ["Ride"] = 39.38, ["Fly|Ride"] = 87.94, ["Neon"] = 252.8, ["Neon|Ride"] = 196.86, ["Neon|Fly|Ride"] = 209.62}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 13.34, ["Fly"] = 83.66, ["Ride"] = 24.94, ["Fly|Ride"] = 103.26, ["Neon"] = 69.43, ["Neon|Ride"] = 99.7, ["Neon|Fly|Ride"] = 179.8}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 31.5, ["Fly|Ride"] = 636.57, ["Neon"] = 164.07, ["Neon|Ride"] = 378}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Fly|Ride"] = 79.52, ["Neon"] = 2.61, ["Neon|Ride"] = 111.57}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 76.13, ["Fly"] = 125.47, ["Ride"] = 97.78, ["Fly|Ride"] = 157.5, ["Neon"] = 446.24, ["Neon|Ride"] = 434.85, ["Neon|Fly|Ride"] = 456.75}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 6.28, ["Fly"] = 107.62, ["Ride"] = 30.87, ["Fly|Ride"] = 70.88, ["Neon"] = 63, ["Neon|Ride"] = 110.83}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 28.24, ["Ride"] = 39.38, ["Fly|Ride"] = 42, ["Neon"] = 17.26, ["Neon|Fly"] = 79.53, ["Neon|Ride"] = 65.88, ["Neon|Fly|Ride"] = 122.85}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 3.94, ["Ride"] = 131.25, ["Neon"] = 16.03, ["Neon|Fly"] = 138.02, ["Neon|Fly|Ride"] = 207.69}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 63, ["Ride"] = 111.88, ["Fly|Ride"] = 262.5, ["Neon"] = 288.75, ["Neon|Ride"] = 282.19, ["Neon|Fly|Ride"] = 558.3}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 13.13, ["Neon"] = 16.69}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 2090.94, ["Neon"] = 2.1, ["Neon|Ride"] = 115.04}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 102.94, ["Ride"] = 35.56, ["Fly|Ride"] = 41.84, ["Neon"] = 3.81, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 167.31}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 20.92, ["Fly|Ride"] = 56.44, ["Neon"] = 6.55, ["Neon|Ride"] = 28.58, ["Neon|Fly|Ride"] = 92.02}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.63, ["Ride"] = 28.88, ["Fly|Ride"] = 111.88, ["Neon"] = 39.38}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 15.69, ["Fly|Ride"] = 32.04, ["Neon"] = 6.57, ["Neon|Fly"] = 209.11, ["Neon|Ride"] = 24.92}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 52.5, ["Fly|Ride"] = 265.56, ["Neon"] = 196.87, ["Neon|Ride"] = 334.56, ["Neon|Fly|Ride"] = 1045.48}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 23.01, ["Ride"] = 17.07, ["Fly|Ride"] = 35.44, ["Neon"] = 4.08, ["Neon|Fly"] = 32.81, ["Neon|Ride"] = 20.62, ["Neon|Fly|Ride"] = 46.25}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 7.88, ["Fly"] = 129.94, ["Ride"] = 118.12, ["Fly|Ride"] = 57.19, ["Neon"] = 26.19, ["Neon|Fly"] = 87.28, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 167.28}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 14.51, ["Fly"] = 47.06, ["Ride"] = 28.24, ["Fly|Ride"] = 107.63, ["Neon"] = 124.69, ["Neon|Ride"] = 144.37, ["Neon|Fly|Ride"] = 236.25}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 13.13, ["Fly"] = 196.88, ["Neon"] = 52.5}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 28.24, ["Ride"] = 15.69, ["Fly|Ride"] = 56.44, ["Neon"] = 3.94, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 17.56, ["Neon|Fly|Ride"] = 66.89}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 4.2, ["Fly"] = 77.38, ["Ride"] = 39.38, ["Neon"] = 22.23, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 206.05}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 958.13, ["Ride"] = 1149.71, ["Fly|Ride"] = 1148.44, ["Neon|Ride"] = 2744.44, ["Neon|Fly|Ride"] = 2362.5}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 111.88, ["Ride"] = 182.97, ["Fly|Ride"] = 416.11, ["Neon"] = 599.82, ["Neon|Ride"] = 835.34, ["Neon|Fly|Ride"] = 820.31}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.63, ["Fly"] = 56.47, ["Neon"] = 6.14, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 209.11}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 70.14, ["Ride"] = 120.75, ["Fly|Ride"] = 229.69, ["Neon"] = 459.38, ["Neon|Ride"] = 367.49, ["Neon|Fly|Ride"] = 630}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 3.94, ["Ride"] = 31.38, ["Fly|Ride"] = 90.97, ["Neon"] = 16.3, ["Neon|Fly"] = 55.79, ["Neon|Ride"] = 49.45, ["Neon|Fly|Ride"] = 279.18}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 275.63, ["Fly"] = 949.41, ["Ride"] = 328.13, ["Fly|Ride"] = 369.36, ["Neon|Ride"] = 1421.84, ["Neon|Fly|Ride"] = 1181.25}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 76.4, ["Ride"] = 40.79, ["Fly|Ride"] = 219.57, ["Neon"] = 31.5, ["Neon|Fly"] = 35.56, ["Neon|Ride"] = 54.37}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Neon"] = 45.94}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 27.17, ["Fly|Ride"] = 105, ["Neon"] = 151.93, ["Neon|Ride"] = 124.59}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 49.75, ["Neon"] = 25.25, ["Neon|Ride"] = 141.91}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 15.92, ["Ride"] = 14.44, ["Fly|Ride"] = 39.37, ["Neon"] = 3.89, ["Neon|Fly"] = 32.06, ["Neon|Ride"] = 21.38, ["Neon|Fly|Ride"] = 37.65}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4593.75, ["Fly|Ride"] = 4830, ["Neon"] = 31363.9, ["Neon|Fly|Ride"] = 19293.75}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 18.83, ["Fly"] = 83.66, ["Ride"] = 56.43, ["Neon"] = 53.44, ["Neon|Ride"] = 105}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 24.96, ["Ride"] = 15.65, ["Fly|Ride"] = 35.4, ["Neon"] = 16.87, ["Neon|Fly"] = 45.91, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 64.05}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 503.08, ["Fly"] = 547.77, ["Ride"] = 534.19, ["Fly|Ride"] = 574.94, ["Neon"] = 2100, ["Neon|Fly|Ride"] = 1394.66}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 5.17, ["Ride"] = 32.62, ["Neon"] = 35.56}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 7.88, ["Fly"] = 4181.87, ["Ride"] = 65.63, ["Neon"] = 23.37, ["Neon|Ride"] = 64.11}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Ride"] = 30.33, ["Neon"] = 3.81, ["Neon|Fly"] = 124.69, ["Neon|Ride"] = 23.29, ["Neon|Fly|Ride"] = 91.74}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 1068.19, ["Fly|Ride"] = 801.55, ["Neon|Ride"] = 3281.25, ["Neon|Fly|Ride"] = 2940}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 6.97, ["Ride"] = 125.47, ["Fly|Ride"] = 418.2, ["Neon"] = 32.82, ["Neon|Ride"] = 73.2}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 4.96, ["Fly"] = 236.25, ["Ride"] = 47.02, ["Neon"] = 27.8, ["Neon|Ride"] = 51.19, ["Neon|Fly|Ride"] = 219.56}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 6.28, ["Fly"] = 34.13, ["Ride"] = 17.07, ["Neon"] = 17.74, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 32.51, ["Neon|Fly|Ride"] = 91.88}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 19.69, ["Ride"] = 70.06, ["Fly|Ride"] = 159.04, ["Neon"] = 117.58, ["Neon|Fly|Ride"] = 313.66}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Fly|Ride"] = 418.2, ["Neon"] = 7.35, ["Neon|Ride"] = 45.23, ["Neon|Fly|Ride"] = 157.5}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 616.88, ["Ride"] = 538.12, ["Fly|Ride"] = 697.34, ["Neon"] = 2589.57, ["Neon|Fly|Ride"] = 2391.38}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 79.95, ["Neon"] = 16.87, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 474.74}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 27.57, ["Neon"] = 5.25, ["Neon|Fly"] = 237.34, ["Neon|Ride"] = 36.61}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 40.82, ["Neon"] = 5.24, ["Neon|Ride"] = 45.02}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.1, ["Neon"] = 17.82}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 29.24, ["Fly"] = 98.44, ["Ride"] = 118.13, ["Fly|Ride"] = 498.75, ["Neon"] = 131.25, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 334.69}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 17.87, ["Ride"] = 105, ["Fly|Ride"] = 190.32, ["Neon"] = 65.61, ["Neon|Ride"] = 141.91}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 3.56, ["Fly"] = 12.55, ["Ride"] = 16.62, ["Fly|Ride"] = 32.82, ["Neon"] = 28.65, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 87.18}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 7.62, ["Ride"] = 103.26, ["Neon"] = 71.11, ["Neon|Ride"] = 194.48}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Fly"] = 129.94, ["Ride"] = 26.25, ["Fly|Ride"] = 111.57, ["Neon"] = 10.49, ["Neon|Ride"] = 40.34, ["Neon|Fly|Ride"] = 156.68}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 23.4, ["Ride"] = 34.13, ["Fly|Ride"] = 62.75, ["Neon"] = 418.2, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 223.75}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 35.74, ["Fly"] = 874.13, ["Neon"] = 274.97}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 57.14, ["Ride"] = 138.02, ["Fly|Ride"] = 192.92, ["Neon"] = 315, ["Neon|Ride"] = 557.25, ["Neon|Fly|Ride"] = 441.99}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 44.03, ["Fly"] = 83.66, ["Ride"] = 76.74, ["Fly|Ride"] = 209.11, ["Neon"] = 189.9, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 525}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 18.38, ["Ride"] = 57.5, ["Fly|Ride"] = 209.11, ["Neon"] = 140.11, ["Neon|Ride"] = 284.82}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 18.09, ["Fly"] = 418.2, ["Ride"] = 57.21, ["Fly|Ride"] = 279.16, ["Neon"] = 120.75, ["Neon|Fly"] = 420, ["Neon|Ride"] = 158.93, ["Neon|Fly|Ride"] = 142.44}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 17.74, ["Ride"] = 15.09, ["Fly|Ride"] = 32.74, ["Neon"] = 6.57, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 59.07}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1890}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 41.49, ["Ride"] = 127.32, ["Fly|Ride"] = 371.16, ["Neon"] = 344.4, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 538.13}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Neon"] = 5.25, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 292.74}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 27.58, ["Fly|Ride"] = 169.39, ["Neon"] = 156.19, ["Neon|Ride"] = 140.11, ["Neon|Fly|Ride"] = 544.69}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 3.94}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 39.38}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 107.69, ["Fly"] = 223.13, ["Ride"] = 156.19, ["Neon"] = 517.52, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 656.25}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.2, ["Fly"] = 90.57, ["Ride"] = 27.2, ["Neon"] = 9.19, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 114.19}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 38.07, ["Fly|Ride"] = 52.5, ["Neon"] = 6.04, ["Neon|Ride"] = 36.61, ["Neon|Fly|Ride"] = 419.99}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 4.92, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 210}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Neon"] = 6.57, ["Neon|Ride"] = 156.19}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 74.27, ["Ride"] = 284.84, ["Fly|Ride"] = 1045.48, ["Neon"] = 424.07, ["Neon|Ride"] = 633.76, ["Neon|Fly|Ride"] = 695.63}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 3.67, ["Ride"] = 33.47, ["Neon"] = 79.53, ["Neon|Ride"] = 227.07}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 354.38, ["Ride"] = 603.75, ["Neon"] = 1115.63, ["Neon|Ride"] = 1186.81, ["Neon|Fly|Ride"] = 1312.5}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 88.08}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 48.57}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 32.82}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 17.82}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 129.12}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 104.34}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 14.83}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 6.09}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 262.5}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 26.25}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 32.82}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 8.14}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 32.82}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 577.49}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 11.51}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 5.35}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 13.13}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 9.72}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 12.57}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 552.57}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 1050}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 7.4}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1243.27}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 7.89}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.63}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 32.82}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.63}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.44}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.49}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 39.75}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 45.55}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 47.25}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 18.68}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 13.16}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 17.54}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 6.17}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 18.27}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 3.74}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 18.03}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 140.07}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 6.57}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 2068.5}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.63}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 30.36}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 307.93}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 6.55}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 8.82}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 6.22}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 49.64}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 213.94}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 7.88}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 11.25}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.63}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 1181.25}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 31.36}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 4.75}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 17.07}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 12.48}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 13.08}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 219.56}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 30.55}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 8.02}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 3.57}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 24.94}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 316.91}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 13.13}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 51.89}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 78.75}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 222.98}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.63}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 5.87}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 131.25}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 24.91}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 108.94}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 22.04}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22550.41}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 316.79}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 159.05}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 78.75}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 44.97}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 44.63}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 48.23}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 196.88}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 110.83}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 90.97}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 76.13}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 144.38}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 55.13}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 7004.62}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 233.37}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 8.59}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 6.14}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 5}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 7.69}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 33.69}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 137.26}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 3.25}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 5.19}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 3.9}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 6.57}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 13.13}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 1135.32}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 15.54}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 583.68}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 14.17}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.63}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.63}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 617.18}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 24.94}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 171.47}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 21}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 23.75}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 78.43}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 14.19}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 11.88}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 7.98}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 3.77}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 5.25}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 5.92}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 28.88}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 5.43}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 3.85}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 6.57}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 31.76}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 728.44}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 52.5}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 4.77}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 1048.69}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 10.12}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 6.43}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 6.4}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 26.86}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 14.84}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 6.57}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.63}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 8.6}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 3.94}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 12.47}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 30.92}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 14.44}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 4.75}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 4.03}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 3.93}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 9.37}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 7.82}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 4.87}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 5.5}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.4}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 3.7}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.63}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 2.81}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 8348.82}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 22.68}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 2.15}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 6.56}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 18.2}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 17.82}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 7.88}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 3.94}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 30.19}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 13.11}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 3.82}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 4.55}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 3.45}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 6.28}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4181.87}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 16.16}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 32.25}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 6.37}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 2.96}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 66.97}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 65.63}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 5.25}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 129.94}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 15.75}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.41}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 5.18}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 7.54}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 27.2}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.61}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.65}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.45}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 15.73}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 3.61}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 3.93}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 3.54}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 5.41}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.51}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 2.41}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 32.82}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 3.92}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 8.58}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 275.63}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.53}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 65.59}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 6.24}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 15.75}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1042.1}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.63}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 38.7}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.63}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 5.24}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 17.46}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.63}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 11.81}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 5.44}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 6.12}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 6.13}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 15.4}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.63}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 26.25}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 14.78}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 6.28}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 5.16}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 2.59}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 14.06}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 10.37}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 23.02}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 6.39}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 5.98}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 3.94}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 18.9}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 51.77}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 3.39}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 8.54}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.63}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.48}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 34.82}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 85.32}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 6.65}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 8.66}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 69.57}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 6.49}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 28.88}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.63}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 4.29}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 3.68}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 1.79}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 6.08}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 140.11}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 6.57}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.63}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 144.23}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 5.07}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1289.39}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 4.2}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 236.3}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 20.44}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 55.13}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 3.73}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 3.68}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 3.94}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.63}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 67.44}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 21.33}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 8.59}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.49}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 3.85}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 5.59}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 79.09}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 4.2}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 62.6}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 3.94}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 28.88}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.63}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 2.27}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 24.18}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 195.51}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 6.07}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 74.82}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 8.1}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 7.88}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.63}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 10.46}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 512.29}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.63}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 52.69}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 66.94}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 209.99}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 5.9}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 56.58}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 209.11}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.94}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 3.54}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 8.38}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 28}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 66.08}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 10.5}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 61.69}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 6.57}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 87.19}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 14.96}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 61.64}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 34.85}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 24.42}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 44.63}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 5.85}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 2.37}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 26.25}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 3.93}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 12.25}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 64.99}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 3.94}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 37.58}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 81.78}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 2041.43}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 9.19}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 6.14}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 173.56}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 336.53}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 16.76}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 11.9}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 8.97}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 11.68}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 318.94}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 52.17}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 83.66}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 51.24}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 59.24}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 228.38}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 62.84}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 1116.94}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 316.91}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 7.46}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 2361.19}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 551.24}},
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