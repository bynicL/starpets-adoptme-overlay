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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 818.35, ["Fly"] = 1123.44, ["Ride"] = 772.84, ["Fly|Ride"] = 980.18, ["Neon"] = 6536.84, ["Neon|Ride"] = 4493.23, ["Neon|Fly|Ride"] = 3424.31}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 426.46, ["Fly"] = 560.32, ["Ride"] = 325, ["Fly|Ride"] = 532.6, ["Neon|Fly|Ride"] = 2361.19, ["Mega|Fly|Ride"] = 8000.97}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 5381.25, ["Ride"] = 4528.13, ["Fly|Ride"] = 4569.43, ["Neon"] = 25971.58, ["Neon|Fly|Ride"] = 25669.17, ["Mega|Fly|Ride"] = 73118.59}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 124.69, ["Ride"] = 144.38, ["Fly|Ride"] = 290.07, ["Neon"] = 1086.18, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 842.22, ["Mega|Fly|Ride"] = 6223.62}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 477.74, ["Ride"] = 363.07, ["Fly|Ride"] = 483, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1639.32, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 9.08, ["Ride"] = 45.94, ["Fly|Ride"] = 105.3, ["Neon"] = 22.46, ["Neon|Ride"] = 105.32, ["Neon|Fly|Ride"] = 281.1, ["Mega"] = 267.41, ["Mega|Ride"] = 322.67, ["Mega|Fly|Ride"] = 409.5}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 3.29, ["Fly"] = 26.22, ["Ride"] = 13.12, ["Fly|Ride"] = 59.88, ["Neon"] = 16.9, ["Neon|Fly"] = 72.19, ["Neon|Ride"] = 37.88, ["Neon|Fly|Ride"] = 98.9, ["Mega"] = 111.46, ["Mega|Fly"] = 303.19, ["Mega|Ride"] = 144.04, ["Mega|Fly|Ride"] = 231.92}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 101.32, ["Fly"] = 656.25, ["Ride"] = 141.1, ["Fly|Ride"] = 124.91, ["Neon"] = 506.45, ["Neon|Ride"] = 644.46, ["Neon|Fly|Ride"] = 1684.43, ["Mega|Ride"] = 1894.97, ["Mega|Fly|Ride"] = 1682.33}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 22.18, ["Fly"] = 62.36, ["Ride"] = 26.23, ["Fly|Ride"] = 53.81, ["Neon"] = 210.79, ["Neon|Ride"] = 174.16, ["Neon|Fly|Ride"] = 224.62, ["Mega"] = 2100, ["Mega|Ride"] = 2730, ["Mega|Fly|Ride"] = 736.95}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 12.59, ["Fly"] = 37.69, ["Ride"] = 29.89, ["Fly|Ride"] = 45.36, ["Neon"] = 277.97, ["Neon|Ride"] = 108.48, ["Neon|Fly|Ride"] = 131.25, ["Mega|Ride"] = 770.63, ["Mega|Fly|Ride"] = 609.37}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 26.03, ["Fly"] = 400.12, ["Ride"] = 39.48, ["Fly|Ride"] = 105.3, ["Neon|Ride"] = 208.51, ["Neon|Fly|Ride"] = 204.75, ["Mega|Ride"] = 1040.13, ["Mega|Fly|Ride"] = 1034.25}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 60.22}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 326.53, ["Fly"] = 440.12, ["Ride"] = 314.39, ["Fly|Ride"] = 367.49, ["Neon"] = 1291.91, ["Neon|Ride"] = 1214.14, ["Neon|Fly|Ride"] = 1048.69, ["Mega|Fly|Ride"] = 4009.69}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 98.44, ["Fly"] = 105, ["Ride"] = 98.44, ["Fly|Ride"] = 138.73, ["Neon"] = 1404.56, ["Neon|Fly|Ride"] = 418.2, ["Mega|Fly|Ride"] = 2231.25}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.5, ["Ride"] = 15.75, ["Fly|Ride"] = 141.1, ["Neon"] = 12.53, ["Neon|Ride"] = 67.02, ["Neon|Fly|Ride"] = 80.04, ["Mega"] = 115.87, ["Mega|Ride"] = 168.46, ["Mega|Fly|Ride"] = 349.13}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 93.16, ["Fly"] = 124.69, ["Ride"] = 95.16, ["Fly|Ride"] = 140.84, ["Neon"] = 618.14, ["Neon|Ride"] = 630.58, ["Neon|Fly|Ride"] = 537.8, ["Mega"] = 2105.53, ["Mega|Fly|Ride"] = 1967.44}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 2.63, ["Fly"] = 23.16, ["Ride"] = 15.73, ["Fly|Ride"] = 53.82, ["Neon"] = 15.73, ["Neon|Fly"] = 105.32, ["Neon|Ride"] = 31.54, ["Neon|Fly|Ride"] = 69.57, ["Mega"] = 223.2, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 24.94, ["Fly"] = 262.5, ["Ride"] = 38.3, ["Fly|Ride"] = 129.94, ["Neon"] = 128.03, ["Neon|Ride"] = 104.15, ["Neon|Fly|Ride"] = 208.16, ["Mega"] = 687.42, ["Mega|Ride"] = 618.96, ["Mega|Fly|Ride"] = 683.23}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 39.34}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 41.04, ["Ride"] = 59.7, ["Neon"] = 279.57, ["Mega"] = 1522.5, ["Mega|Fly|Ride"] = 3111.83}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 11.63, ["Fly"] = 42.13, ["Ride"] = 25.18, ["Fly|Ride"] = 141.1, ["Neon"] = 84.09, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 57.75, ["Neon|Fly|Ride"] = 258.27, ["Mega"] = 2683.61, ["Mega|Ride"] = 499.4, ["Mega|Fly|Ride"] = 653.41}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 29.59, ["Fly"] = 49.55, ["Ride"] = 41.13, ["Fly|Ride"] = 65.63, ["Neon"] = 352.67, ["Neon|Ride"] = 178.5, ["Neon|Fly|Ride"] = 236.91, ["Mega"] = 1681.32, ["Mega|Fly|Ride"] = 893.82}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 42.04, ["Ride"] = 155.76, ["Fly|Ride"] = 124.91, ["Neon"] = 167.47, ["Neon|Ride"] = 421.22, ["Neon|Fly|Ride"] = 404.92, ["Mega"] = 1678.89, ["Mega|Ride"] = 1249.64, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 42, ["Ride"] = 35.44, ["Fly|Ride"] = 130.59, ["Neon"] = 171.08, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 310.57, ["Mega"] = 525, ["Mega|Ride"] = 898.59, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 49.88, ["Fly"] = 75.83, ["Ride"] = 50.8, ["Fly|Ride"] = 131.25, ["Neon"] = 252.71, ["Neon|Ride"] = 280.04, ["Neon|Fly|Ride"] = 307.97, ["Mega|Ride"] = 3158.29, ["Mega|Fly|Ride"] = 939.08}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 3.19, ["Fly"] = 23.57, ["Ride"] = 15.84, ["Fly|Ride"] = 34.13, ["Neon"] = 26.25, ["Neon|Fly"] = 62.93, ["Neon|Ride"] = 48.28, ["Neon|Fly|Ride"] = 66.82, ["Mega"] = 124.69, ["Mega|Fly"] = 421.12, ["Mega|Ride"] = 123.38, ["Mega|Fly|Ride"] = 209.79}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 301.07, ["Fly"] = 368.52, ["Ride"] = 252.71, ["Fly|Ride"] = 328.13, ["Neon"] = 1431.95, ["Neon|Ride"] = 2948.46, ["Neon|Fly|Ride"] = 1416.19, ["Mega"] = 10527.6, ["Mega|Fly|Ride"] = 5445.38}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 14.42, ["Ride"] = 46.31, ["Fly|Ride"] = 136.89, ["Neon"] = 239.03, ["Neon|Ride"] = 210.62, ["Mega"] = 828.54, ["Mega|Fly|Ride"] = 700.08}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 3.53, ["Fly"] = 32.82, ["Ride"] = 19.58, ["Fly|Ride"] = 25.91, ["Neon"] = 32.79, ["Neon|Fly"] = 89.25, ["Neon|Ride"] = 40.68, ["Neon|Fly|Ride"] = 74.29, ["Mega"] = 349.53, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 392.44}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 83.61, ["Fly"] = 118.37, ["Ride"] = 64.19, ["Fly|Ride"] = 105.83, ["Neon"] = 274.32, ["Neon|Fly"] = 379.11, ["Neon|Ride"] = 276.94, ["Neon|Fly|Ride"] = 262.4, ["Mega"] = 6182.78, ["Mega|Ride"] = 3111.83, ["Mega|Fly|Ride"] = 1491}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 12.37, ["Ride"] = 22.97, ["Fly|Ride"] = 115.5, ["Neon"] = 151.77, ["Neon|Ride"] = 83.94, ["Neon|Fly|Ride"] = 207.38, ["Mega"] = 699.04}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 137.52, ["Ride"] = 222.8, ["Fly|Ride"] = 279.09, ["Neon"] = 702.29, ["Neon|Ride"] = 758.19, ["Neon|Fly|Ride"] = 801.94, ["Mega"] = 6316.56, ["Mega|Fly|Ride"] = 2383.46}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 21}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.15, ["Fly"] = 31.4, ["Ride"] = 21.04, ["Fly|Ride"] = 52.41, ["Neon"] = 19.94, ["Neon|Fly"] = 77.91, ["Neon|Ride"] = 31.54, ["Neon|Fly|Ride"] = 105.29, ["Mega"] = 132.34, ["Mega|Fly"] = 224.58, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 236.24}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 494.82, ["Fly"] = 600.16, ["Ride"] = 477.28, ["Fly|Ride"] = 577.5, ["Neon"] = 2808.06, ["Neon|Ride"] = 3019.02, ["Neon|Fly|Ride"] = 2362.5, ["Mega"] = 12633.11, ["Mega|Ride"] = 52505.1, ["Mega|Fly|Ride"] = 9826.46}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 8.35, ["Fly"] = 45.54, ["Ride"] = 18.36, ["Fly|Ride"] = 70.06, ["Neon"] = 28.45, ["Neon|Fly"] = 141.11, ["Neon|Ride"] = 70.55, ["Neon|Fly|Ride"] = 92.35, ["Mega"] = 526.32, ["Mega|Ride"] = 600.09, ["Mega|Fly|Ride"] = 664.31}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 99.56, ["Ride"] = 157.5, ["Fly|Ride"] = 196.24, ["Neon"] = 688.59, ["Neon|Ride"] = 544.69, ["Neon|Fly|Ride"] = 603.75, ["Mega"] = 2489.92, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 2799.12}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 40.69}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 22.3, ["Ride"] = 91.88, ["Fly|Ride"] = 262.5, ["Neon"] = 65.39, ["Neon|Ride"] = 246.43, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 674.41, ["Mega|Ride"] = 619.03, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 153.07, ["Ride"] = 208.69, ["Neon"] = 513.19, ["Neon|Ride"] = 577.5, ["Neon|Fly|Ride"] = 656.25, ["Mega|Fly|Ride"] = 2100}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 91.69, ["Ride"] = 141.49, ["Neon"] = 433.21, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 480.38, ["Mega"] = 1750.88, ["Mega|Ride"] = 1565.47, ["Mega|Fly|Ride"] = 1468.69}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 52.48}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 46.41, ["Fly"] = 56.44, ["Ride"] = 45.94, ["Fly|Ride"] = 50.04, ["Neon|Ride"] = 305.88, ["Neon|Fly|Ride"] = 263.24, ["Mega|Fly|Ride"] = 1217.78}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 4.47, ["Ride"] = 49.33, ["Fly|Ride"] = 131.25, ["Neon"] = 22.4, ["Neon|Ride"] = 56.88, ["Neon|Fly|Ride"] = 156.37, ["Mega"] = 172.7, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 252.68, ["Mega|Fly|Ride"] = 306.36}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 303.19, ["Fly"] = 396.89, ["Ride"] = 248.33, ["Fly|Ride"] = 292.69, ["Neon|Fly"] = 1245.65, ["Neon|Ride"] = 1967.05, ["Neon|Fly|Ride"] = 1115.63, ["Mega|Fly|Ride"] = 4771.12}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 58.25, ["Fly"] = 91.32, ["Ride"] = 74.82, ["Fly|Ride"] = 112.12, ["Neon"] = 262.42, ["Neon|Fly"] = 301.21, ["Neon|Ride"] = 219.03, ["Neon|Fly|Ride"] = 392.51, ["Mega|Fly|Ride"] = 1375.97}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3578.77, ["Fly"] = 4071.53, ["Ride"] = 3961.13, ["Fly|Ride"] = 3412.5, ["Neon|Fly|Ride"] = 13684.82}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 26.71, ["Fly"] = 56.87, ["Ride"] = 54.76, ["Fly|Ride"] = 106.63, ["Neon"] = 326.38, ["Neon|Ride"] = 275.4, ["Neon|Fly|Ride"] = 280.05, ["Mega"] = 1894.97, ["Mega|Ride"] = 1894.97, ["Mega|Fly|Ride"] = 1312.8}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 91.88, ["Ride"] = 124.66, ["Fly|Ride"] = 167.55, ["Neon"] = 373.55, ["Neon|Ride"] = 505.45, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 6316.56, ["Mega|Fly|Ride"] = 1341.23}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 20.69, ["Fly"] = 64.32, ["Ride"] = 34.73, ["Fly|Ride"] = 78.75, ["Neon"] = 138.29, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 2598.75, ["Mega|Fly|Ride"] = 609.13}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 9.19}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 56.35, ["Ride"] = 78.75, ["Fly|Ride"] = 105, ["Neon"] = 442.23, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 491.66}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 26.23}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 196.49, ["Ride"] = 310.62, ["Fly|Ride"] = 341.25, ["Neon|Fly|Ride"] = 1684.43}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 643.12, ["Ride"] = 713.9, ["Fly|Ride"] = 656.25, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 1968.75, ["Mega|Fly|Ride"] = 11746.88}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 6.77}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 26.22, ["Fly"] = 52.5, ["Ride"] = 31.54, ["Fly|Ride"] = 58.57, ["Neon"] = 267.45, ["Neon|Fly"] = 311.72, ["Neon|Ride"] = 168.49, ["Neon|Fly|Ride"] = 131.59, ["Mega|Fly|Ride"] = 1170.86}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 15.75}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 4462.49, ["Fly|Ride"] = 4593.75, ["Neon|Fly|Ride"] = 10286.22, ["Mega|Fly|Ride"] = 40567.03}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 5.62, ["Fly"] = 74.64, ["Ride"] = 23.07, ["Fly|Ride"] = 47.25, ["Neon"] = 69.24, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 391.63, ["Mega|Ride"] = 367.4, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 10.63, ["Fly"] = 78.98, ["Ride"] = 35.57, ["Fly|Ride"] = 78.22, ["Neon"] = 39.38, ["Neon|Ride"] = 104.71, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 702.2, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 491.66}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 156.16, ["Ride"] = 109.47, ["Fly|Ride"] = 187.69, ["Neon|Fly|Ride"] = 575.88}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 9.19, ["Ride"] = 42, ["Fly|Ride"] = 139.65, ["Neon"] = 49.5, ["Neon|Ride"] = 235.81, ["Neon|Fly|Ride"] = 334.88, ["Mega"] = 1123.32, ["Mega|Ride"] = 415.86, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1824.72, ["Fly"] = 2165.63, ["Ride"] = 2779.64, ["Fly|Ride"] = 2098.59, ["Neon|Ride"] = 5335.64, ["Neon|Fly|Ride"] = 3953.25, ["Mega|Fly|Ride"] = 10498.69}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 23343.08, ["Fly"] = 26250, ["Ride"] = 24806.25, ["Fly|Ride"] = 24937.5, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 70044.28, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 196515.36}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 18.64, ["Fly"] = 393.75, ["Ride"] = 38.53, ["Fly|Ride"] = 91.32, ["Neon"] = 107.04, ["Neon|Ride"] = 178.38, ["Neon|Fly|Ride"] = 336.9, ["Mega"] = 1123.32, ["Mega|Ride"] = 736.95, ["Mega|Fly|Ride"] = 948.49}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 2.61, ["Ride"] = 26.94, ["Fly|Ride"] = 98.8, ["Neon"] = 14.94, ["Neon|Fly"] = 81.58, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 119.44, ["Mega"] = 110.92, ["Mega|Ride"] = 131.14, ["Mega|Fly|Ride"] = 196.87}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 18.36}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 4.2, ["Ride"] = 17.97, ["Fly|Ride"] = 281.14, ["Neon"] = 40.15, ["Neon|Ride"] = 124.36, ["Neon|Fly|Ride"] = 463.32, ["Mega"] = 170.63, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 384.67}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 682.5, ["Fly"] = 840.16, ["Ride"] = 708.75, ["Fly|Ride"] = 711.38, ["Neon"] = 2949.19, ["Neon|Fly|Ride"] = 2625, ["Mega"] = 11229.8, ["Mega|Fly|Ride"] = 10906.6}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 909.57, ["Ride"] = 875, ["Fly|Ride"] = 872.81, ["Neon|Fly|Ride"] = 3703.62, ["Mega|Fly|Ride"] = 13755.36}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 15.37, ["Fly"] = 56.75, ["Ride"] = 32.45, ["Fly|Ride"] = 78.56, ["Neon"] = 156.29, ["Neon|Ride"] = 196.29, ["Neon|Fly|Ride"] = 196.88, ["Mega|Fly|Ride"] = 641.29}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 23.67}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 46.94, ["Fly"] = 116.75, ["Ride"] = 49.7, ["Fly|Ride"] = 156.16, ["Neon"] = 421.17, ["Neon|Ride"] = 398.32, ["Neon|Fly|Ride"] = 367.5, ["Mega|Ride"] = 1684.43, ["Mega|Fly|Ride"] = 1598.63}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 51.12, ["Fly"] = 131.25, ["Ride"] = 156.16, ["Fly|Ride"] = 183.22, ["Neon"] = 441, ["Neon|Ride"] = 562.33, ["Neon|Fly|Ride"] = 15557.85, ["Mega"] = 2121.56, ["Mega|Ride"] = 1684.43, ["Mega|Fly|Ride"] = 1326.5}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 3.29, ["Fly"] = 33.97, ["Ride"] = 13.92, ["Fly|Ride"] = 41.37, ["Neon"] = 17.03, ["Neon|Ride"] = 63.19, ["Neon|Fly|Ride"] = 111.9, ["Mega"] = 562.19, ["Mega|Ride"] = 289.37, ["Mega|Fly|Ride"] = 374.07}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 59.41, ["Fly"] = 58.75, ["Ride"] = 63.88, ["Fly|Ride"] = 98.44, ["Neon"] = 1123.44, ["Neon|Ride"] = 325.5, ["Neon|Fly|Ride"] = 165.04, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 2.63, ["Ride"] = 24.57, ["Fly|Ride"] = 42.13, ["Neon"] = 28.88, ["Neon|Ride"] = 50.87, ["Neon|Fly|Ride"] = 141.08, ["Mega"] = 116.01, ["Mega|Fly"] = 336.9, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 833.26}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 13.69, ["Fly"] = 60.03, ["Ride"] = 31.46, ["Fly|Ride"] = 70.32, ["Neon"] = 259.88, ["Neon|Ride"] = 87.19, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1050, ["Mega|Fly|Ride"] = 453.75}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 18.35, ["Ride"] = 51.3, ["Fly|Ride"] = 126.36, ["Neon"] = 210.59, ["Neon|Ride"] = 345.57, ["Neon|Fly|Ride"] = 105, ["Mega"] = 421.12, ["Mega|Fly|Ride"] = 732.22}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 13.37, ["Fly"] = 90.27, ["Ride"] = 40.8, ["Fly|Ride"] = 36.49, ["Neon"] = 103.69, ["Neon|Ride"] = 123.85, ["Neon|Fly|Ride"] = 105.29, ["Mega|Ride"] = 842.22, ["Mega|Fly|Ride"] = 638}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6977.18, ["Ride"] = 4725, ["Fly|Ride"] = 3937.5, ["Neon"] = 29480.84, ["Neon|Fly|Ride"] = 26250}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 196.87, ["Fly"] = 149.07, ["Ride"] = 196.88, ["Fly|Ride"] = 246.04, ["Neon|Ride"] = 575.88, ["Neon|Fly|Ride"] = 529.92, ["Mega|Fly|Ride"] = 1920.13}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 15.74, ["Fly"] = 77.93, ["Ride"] = 40.03, ["Fly|Ride"] = 85.71, ["Neon"] = 55.9, ["Neon|Fly"] = 104.51, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 147, ["Mega"] = 301.77, ["Mega|Fly"] = 421.12, ["Mega|Ride"] = 248.15, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.62, ["Fly"] = 40.87, ["Ride"] = 20.93, ["Fly|Ride"] = 175.85, ["Neon"] = 15.65, ["Neon|Ride"] = 52.5, ["Mega"] = 140.44}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 34.13, ["Fly"] = 156.43, ["Ride"] = 42.15, ["Fly|Ride"] = 160.13, ["Neon"] = 103.69, ["Neon|Fly"] = 335.07, ["Neon|Ride"] = 155.81, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 390.97, ["Mega|Ride"] = 281.72, ["Mega|Fly|Ride"] = 496.13}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 18571.88, ["Ride"] = 11082.75, ["Fly|Ride"] = 11417.44, ["Neon|Fly|Ride"] = 23625, ["Mega|Fly|Ride"] = 91239.47}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 157.49, ["Ride"] = 196.86, ["Fly|Ride"] = 262.5, ["Neon"] = 2105.79, ["Neon|Fly|Ride"] = 840, ["Mega"] = 4421.6, ["Mega|Fly|Ride"] = 4562.66}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 36.23, ["Fly"] = 459.38, ["Ride"] = 38.66, ["Fly|Ride"] = 65.63, ["Neon|Fly"] = 466.98, ["Neon|Ride"] = 266.44, ["Neon|Fly|Ride"] = 322.88, ["Mega|Fly|Ride"] = 2806.68}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 7.96, ["Ride"] = 19.81, ["Fly|Ride"] = 91.63, ["Neon"] = 39.38, ["Neon|Ride"] = 84.09, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 2526.63, ["Mega|Ride"] = 492.19, ["Mega|Fly|Ride"] = 539.02}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 346.55, ["Fly"] = 840.69, ["Ride"] = 378.18, ["Fly|Ride"] = 435.74, ["Neon"] = 982.36, ["Neon|Ride"] = 1260, ["Neon|Fly|Ride"] = 1350.57, ["Mega"] = 5133.06, ["Mega|Fly|Ride"] = 4626.89}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 3.94, ["Fly"] = 101.53, ["Ride"] = 20.88, ["Neon"] = 26.25, ["Neon|Ride"] = 99.01, ["Neon|Fly|Ride"] = 138.67, ["Mega"] = 127.46, ["Mega|Fly"] = 278.37, ["Mega|Ride"] = 178.5, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 92.69, ["Fly"] = 109.3, ["Ride"] = 137.55, ["Fly|Ride"] = 196.88, ["Neon"] = 400.15, ["Neon|Ride"] = 327.8, ["Neon|Fly|Ride"] = 426.57, ["Mega"] = 1574.99, ["Mega|Fly|Ride"] = 1669.9}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 10.8, ["Fly"] = 18.38, ["Ride"] = 15.26, ["Fly|Ride"] = 27.57, ["Neon|Fly"] = 94.79, ["Neon|Ride"] = 102.59, ["Neon|Fly|Ride"] = 78.72, ["Mega"] = 2526.63, ["Mega|Fly|Ride"] = 532.88}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 5.77}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 54.66, ["Fly"] = 109.74, ["Ride"] = 98.67, ["Fly|Ride"] = 525, ["Neon"] = 350.52, ["Neon|Fly"] = 1684.83, ["Neon|Ride"] = 367.29, ["Neon|Fly|Ride"] = 689.52, ["Mega|Ride"] = 1400.16, ["Mega|Fly|Ride"] = 1540.17}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 7.77, ["Ride"] = 30.19, ["Fly|Ride"] = 77.06, ["Neon"] = 45.94, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 393.75, ["Mega|Ride"] = 511.88, ["Mega|Fly|Ride"] = 859.17}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 11.82}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 15.74, ["Fly"] = 210, ["Ride"] = 76.13, ["Fly|Ride"] = 73.71, ["Neon"] = 133.88, ["Neon|Ride"] = 82.78, ["Neon|Fly|Ride"] = 261.19, ["Mega"] = 1544.42, ["Mega|Ride"] = 983.29, ["Mega|Fly|Ride"] = 597.19}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.72, ["Ride"] = 24.23, ["Neon"] = 17.89, ["Neon|Ride"] = 137.96, ["Neon|Fly|Ride"] = 321.57, ["Mega"] = 106.72, ["Mega|Ride"] = 259, ["Mega|Fly|Ride"] = 399.67}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 10.53, ["Fly"] = 56.87, ["Ride"] = 29.48, ["Fly|Ride"] = 60.99, ["Neon"] = 212.1, ["Neon|Ride"] = 212.72, ["Neon|Fly|Ride"] = 623.07, ["Mega|Ride"] = 611.77, ["Mega|Fly|Ride"] = 678}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 343.79, ["Fly"] = 437.75, ["Ride"] = 322.88, ["Fly|Ride"] = 385.88, ["Neon|Fly|Ride"] = 1523.36, ["Mega|Fly|Ride"] = 8843.19}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 22.23, ["Ride"] = 51.4, ["Fly|Ride"] = 166.69, ["Neon"] = 151.04, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 190.32, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 696.94}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 41.15, ["Ride"] = 82.6, ["Fly|Ride"] = 109.47, ["Neon"] = 322.54, ["Neon|Fly"] = 281.17, ["Neon|Ride"] = 262.5, ["Mega"] = 1166.8, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1263.32}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 9.19, ["Ride"] = 23.93, ["Fly|Ride"] = 91.88, ["Neon"] = 57.32, ["Neon|Ride"] = 116.75, ["Neon|Fly|Ride"] = 279.16, ["Mega"] = 455.44, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 388.5}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 11206, ["Ride"] = 11089.32, ["Fly|Ride"] = 7217.43, ["Neon|Fly|Ride"] = 15484.88, ["Mega|Fly|Ride"] = 39372.9}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1800.49, ["Fly"] = 2558.13, ["Ride"] = 2214.41, ["Fly|Ride"] = 1706.25, ["Neon|Fly|Ride"] = 5185.69, ["Mega|Fly|Ride"] = 14437.5}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 315, ["Ride"] = 413.24, ["Fly|Ride"] = 590.63, ["Neon"] = 1395.74, ["Neon|Ride"] = 1347.87, ["Neon|Fly|Ride"] = 1347.54, ["Mega"] = 14437.5, ["Mega|Fly|Ride"] = 6176.56}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 9.14, ["Fly"] = 26.24, ["Ride"] = 17.36, ["Fly|Ride"] = 35.68, ["Neon"] = 124.91, ["Neon|Ride"] = 82.74, ["Neon|Fly|Ride"] = 121.09, ["Mega|Fly|Ride"] = 521.13}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 2.78, ["Fly"] = 131.25, ["Ride"] = 105, ["Fly|Ride"] = 105, ["Neon"] = 15.73, ["Neon|Ride"] = 45.91, ["Mega"] = 156.54, ["Mega|Ride"] = 103.95, ["Mega|Fly|Ride"] = 311.63}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 36.72, ["Fly"] = 45.94, ["Ride"] = 39.62, ["Fly|Ride"] = 48.13, ["Neon"] = 140.62, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 140.58, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.28, ["Fly"] = 16.68, ["Ride"] = 12.81, ["Fly|Ride"] = 37.84, ["Neon"] = 28.23, ["Neon|Fly"] = 58.4, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 93.97, ["Mega"] = 472.5, ["Mega|Ride"] = 286.37, ["Mega|Fly|Ride"] = 250.3}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 297.81, ["Fly"] = 317.62, ["Ride"] = 192.5, ["Fly|Ride"] = 347.82, ["Neon"] = 1097.27, ["Neon|Ride"] = 1051.97, ["Neon|Fly|Ride"] = 981.75, ["Mega|Fly|Ride"] = 3578.53}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 18.9, ["Fly"] = 56.87, ["Ride"] = 39.37, ["Fly|Ride"] = 56.43, ["Neon"] = 121.87, ["Neon|Fly"] = 466.98, ["Neon|Ride"] = 140.84, ["Neon|Fly|Ride"] = 170.63, ["Mega|Ride"] = 781.16, ["Mega|Fly|Ride"] = 838.69}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 5.1, ["Fly"] = 28.45, ["Ride"] = 15.38, ["Fly|Ride"] = 46.17, ["Neon|Fly"] = 124.92, ["Neon|Ride"] = 78.1, ["Neon|Fly|Ride"] = 115.5, ["Mega"] = 421.12, ["Mega|Ride"] = 580.08, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 439.69, ["Fly"] = 787.5, ["Ride"] = 499.62, ["Fly|Ride"] = 673.86, ["Mega|Fly|Ride"] = 9053.73}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 996.85, ["Ride"] = 1181.25, ["Fly|Ride"] = 1161.57, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 19403.42}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 54.32, ["Fly"] = 70.56, ["Ride"] = 74.76, ["Fly|Ride"] = 99.75, ["Neon"] = 501.19, ["Neon|Ride"] = 414.75, ["Neon|Fly|Ride"] = 428.49, ["Mega|Fly|Ride"] = 1312.49}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 170.62, ["Fly"] = 232.44, ["Ride"] = 177.19, ["Fly|Ride"] = 157.5, ["Neon"] = 1090.26, ["Neon|Ride"] = 892.5, ["Neon|Fly|Ride"] = 651.66, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 22.35, ["Ride"] = 30.22, ["Neon"] = 263.94, ["Neon|Ride"] = 252.74, ["Neon|Fly|Ride"] = 842.22, ["Mega|Ride"] = 933.44, ["Mega|Fly|Ride"] = 1038.44}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 105.52, ["Ride"] = 140.63, ["Fly|Ride"] = 597.19, ["Neon"] = 1544.6, ["Neon|Ride"] = 1263.64, ["Neon|Fly|Ride"] = 1684.43, ["Mega|Fly|Ride"] = 3088.81}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 1534.32, ["Fly"] = 2519.83, ["Ride"] = 1437.28, ["Fly|Ride"] = 1967.44, ["Neon|Fly|Ride"] = 6562.49, ["Mega|Fly|Ride"] = 32047.96}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 64.03, ["Ride"] = 91.88, ["Fly|Ride"] = 263.83, ["Neon"] = 278.07, ["Neon|Ride"] = 141.11, ["Neon|Fly|Ride"] = 196.54, ["Mega"] = 1966.57, ["Mega|Ride"] = 2316.08, ["Mega|Fly|Ride"] = 1964.8}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 525, ["Fly"] = 635.91, ["Ride"] = 557.82, ["Fly|Ride"] = 544.69, ["Neon"] = 1400.91, ["Neon|Ride"] = 1404.75, ["Neon|Fly|Ride"] = 1111.69, ["Mega|Fly|Ride"] = 2782.5}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 38.06, ["Fly"] = 53.72, ["Ride"] = 46.05, ["Fly|Ride"] = 76.94, ["Neon"] = 204.27, ["Neon|Ride"] = 513.45, ["Neon|Fly|Ride"] = 233.37, ["Mega|Fly|Ride"] = 1456.88}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 2.63, ["Fly"] = 25.81, ["Ride"] = 14.44, ["Fly|Ride"] = 37.92, ["Neon"] = 13.11, ["Neon|Fly"] = 39.35, ["Neon|Ride"] = 30.18, ["Neon|Fly|Ride"] = 66.55, ["Mega"] = 104.62, ["Mega|Ride"] = 140.54, ["Mega|Fly|Ride"] = 190.32}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 38.79, ["Ride"] = 66.94, ["Fly|Ride"] = 252, ["Neon"] = 702.29, ["Neon|Ride"] = 772.93, ["Mega"] = 1400.16, ["Mega|Fly|Ride"] = 955.47}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 467.87, ["Fly"] = 899.07, ["Ride"] = 515.96, ["Fly|Ride"] = 562.52, ["Neon|Ride"] = 1894.97, ["Neon|Fly|Ride"] = 1548.75, ["Mega|Fly|Ride"] = 5239.5}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 609.2, ["Ride"] = 523.69, ["Fly|Ride"] = 700.4, ["Neon"] = 8423.1, ["Neon|Fly|Ride"] = 3894.17, ["Mega|Fly|Ride"] = 17862.17}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 12.66, ["Fly"] = 32.71, ["Ride"] = 15.74, ["Fly|Ride"] = 27.02, ["Neon"] = 140.07, ["Neon|Ride"] = 87.34, ["Neon|Fly|Ride"] = 105, ["Mega|Fly|Ride"] = 623.07}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 6.57, ["Ride"] = 19.59, ["Fly|Ride"] = 75.83, ["Neon"] = 52.6, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 421.12, ["Mega"] = 461.13, ["Mega|Ride"] = 461.13, ["Mega|Fly|Ride"] = 473.76}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 3.26, ["Ride"] = 23.63, ["Fly|Ride"] = 99.95, ["Neon"] = 13.13, ["Neon|Fly"] = 108.51, ["Neon|Ride"] = 31.54, ["Neon|Fly|Ride"] = 141.08, ["Mega"] = 119.02, ["Mega|Fly"] = 224.44, ["Mega|Ride"] = 77.79, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 28.88, ["Fly"] = 39.38, ["Ride"] = 39.16, ["Fly|Ride"] = 62.99, ["Neon"] = 252.15, ["Neon|Ride"] = 181.13, ["Neon|Fly|Ride"] = 196.88, ["Mega|Fly|Ride"] = 707.05}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 31.37, ["Ride"] = 91.88, ["Fly|Ride"] = 620.95, ["Neon"] = 350.53, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 695.63, ["Mega|Fly|Ride"] = 1245.85}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 13.1, ["Fly"] = 33.11, ["Ride"] = 21.25, ["Fly|Ride"] = 70.32, ["Neon"] = 61.53, ["Neon|Fly"] = 120.06, ["Neon|Ride"] = 90.27, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 656.25, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 392.32}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 18.31, ["Fly"] = 77.37, ["Ride"] = 33.45, ["Fly|Ride"] = 50.23, ["Neon"] = 349.57, ["Neon|Ride"] = 172.33, ["Neon|Fly|Ride"] = 210, ["Mega"] = 2100, ["Mega|Ride"] = 1213.46, ["Mega|Fly|Ride"] = 934.56}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 2.63, ["Fly"] = 38.07, ["Ride"] = 15.18, ["Fly|Ride"] = 53.6, ["Neon"] = 15.1, ["Neon|Ride"] = 35.41, ["Neon|Fly|Ride"] = 104.9, ["Mega"] = 249.71, ["Mega|Ride"] = 466.73, ["Mega|Fly|Ride"] = 311.54}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 3.89, ["Fly"] = 57.99, ["Ride"] = 28.6, ["Fly|Ride"] = 44.21, ["Neon"] = 28.3, ["Neon|Fly"] = 156.16, ["Neon|Ride"] = 37.14, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 141.08, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 379.01}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 35.6, ["Fly"] = 55.12, ["Ride"] = 52.41, ["Fly|Ride"] = 78.75, ["Neon"] = 417.66, ["Neon|Ride"] = 241.74, ["Neon|Fly|Ride"] = 240.19, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1815.13, ["Fly"] = 2447.82, ["Ride"] = 1970.07, ["Fly|Ride"] = 1822.46, ["Neon"] = 6693.27, ["Neon|Fly|Ride"] = 4803.75, ["Mega|Fly|Ride"] = 14003.07}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 351.32, ["Fly"] = 578.26, ["Ride"] = 472.5, ["Fly|Ride"] = 531.57, ["Neon"] = 3113.18, ["Neon|Ride"] = 2387.2, ["Neon|Fly|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 7875}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 241.5, ["Ride"] = 280.88, ["Fly|Ride"] = 430.5, ["Neon"] = 1966.81, ["Neon|Ride"] = 1575, ["Neon|Fly|Ride"] = 1383.35, ["Mega|Fly|Ride"] = 5893.36}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 37.98}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 19.67, ["Fly"] = 65.63, ["Ride"] = 29.12, ["Fly|Ride"] = 76.13, ["Neon"] = 288.75, ["Neon|Ride"] = 252.24, ["Neon|Fly|Ride"] = 282.15, ["Mega"] = 1157, ["Mega|Ride"] = 1473.87, ["Mega|Fly|Ride"] = 821.17}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 29480.84, ["Fly"] = 20998.69, ["Ride"] = 34781.25, ["Fly|Ride"] = 15750, ["Neon|Fly|Ride"] = 36748.69, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 193.26, ["Fly"] = 217.41, ["Ride"] = 194.25, ["Fly|Ride"] = 186.83, ["Neon"] = 576.18, ["Neon|Fly"] = 800.3, ["Neon|Ride"] = 448.45, ["Neon|Fly|Ride"] = 526.08, ["Mega"] = 3496.23, ["Mega|Ride"] = 2471.89, ["Mega|Fly|Ride"] = 2296.88}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 166.37, ["Ride"] = 249.38, ["Fly|Ride"] = 262.5, ["Neon|Fly|Ride"] = 1711.67}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 77.24, ["Ride"] = 103.69, ["Fly|Ride"] = 166.94, ["Neon"] = 533.84, ["Neon|Ride"] = 356.79, ["Neon|Fly|Ride"] = 368.91, ["Mega"] = 5250, ["Mega|Fly|Ride"] = 2141.89}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 10.5, ["Fly"] = 94.5, ["Ride"] = 28.3, ["Fly|Ride"] = 77.67, ["Neon"] = 98.99, ["Neon|Ride"] = 138.94, ["Neon|Fly|Ride"] = 291.38, ["Mega"] = 623.07, ["Mega|Ride"] = 591.13}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 3799.42, ["Ride"] = 4188.19, ["Fly|Ride"] = 4071.53, ["Neon|Ride"] = 21757.38, ["Neon|Fly|Ride"] = 13125}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 21.84, ["Fly"] = 32.82, ["Ride"] = 25.97, ["Fly|Ride"] = 34.63, ["Neon"] = 105, ["Neon|Ride"] = 66.23, ["Neon|Fly|Ride"] = 150.93, ["Mega|Fly|Ride"] = 570.94}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 42.13, ["Fly"] = 63.06, ["Ride"] = 45.77, ["Fly|Ride"] = 80.59, ["Neon"] = 187.45, ["Neon|Ride"] = 278.01, ["Neon|Fly|Ride"] = 291.71, ["Mega"] = 828.54, ["Mega|Fly|Ride"] = 949.77}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 536.81, ["Fly"] = 924.51, ["Ride"] = 583.41, ["Fly|Ride"] = 654.94, ["Neon"] = 1631.44, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1311.19, ["Mega|Ride"] = 6315.51, ["Mega|Fly|Ride"] = 3752.44}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 12.58, ["Fly"] = 24.92, ["Ride"] = 19.95, ["Fly|Ride"] = 52.17, ["Neon"] = 105.3, ["Neon|Fly"] = 168.49, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 111.55, ["Mega"] = 702.2, ["Mega|Fly|Ride"] = 523.68}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 8.56, ["Ride"] = 42.13, ["Fly|Ride"] = 136.89, ["Neon"] = 68.59, ["Neon|Ride"] = 111.57}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 86.52, ["Ride"] = 122.19, ["Fly|Ride"] = 141.1, ["Neon"] = 354.38, ["Neon|Ride"] = 630.58, ["Neon|Fly|Ride"] = 735, ["Mega|Fly|Ride"] = 3010.91}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 14.22, ["Fly"] = 90.09, ["Ride"] = 65.63, ["Fly|Ride"] = 114.76, ["Neon"] = 41.3, ["Neon|Ride"] = 69.37, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 139, ["Mega|Fly"] = 523.69, ["Mega|Ride"] = 228.26, ["Mega|Fly|Ride"] = 364.88}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 2937.08, ["Ride"] = 3779.64, ["Fly|Ride"] = 2953.13, ["Neon"] = 9474.95, ["Neon|Ride"] = 17123.74, ["Neon|Fly|Ride"] = 6562.5, ["Mega"] = 63165.54, ["Mega|Fly|Ride"] = 37803.67}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 22.98, ["Fly"] = 210, ["Ride"] = 44.23, ["Fly|Ride"] = 98.99, ["Neon"] = 140.84, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 209.9, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 8283.08, ["Fly"] = 7875, ["Ride"] = 7804.13, ["Fly|Ride"] = 5985, ["Neon|Ride"] = 18181.43, ["Neon|Fly|Ride"] = 13122.38, ["Mega|Fly|Ride"] = 63082.38}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 3.29, ["Fly"] = 19.65, ["Ride"] = 12.47, ["Fly|Ride"] = 30.12, ["Neon"] = 21.1, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 41.09, ["Neon|Fly|Ride"] = 73.43, ["Mega"] = 451.56, ["Mega|Ride"] = 210.56, ["Mega|Fly|Ride"] = 281.1}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 17.89, ["Fly"] = 35.43, ["Ride"] = 28.35, ["Fly|Ride"] = 44.63, ["Neon|Ride"] = 281.38, ["Neon|Fly|Ride"] = 249.38, ["Mega|Ride"] = 1335.49, ["Mega|Fly|Ride"] = 927.94}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 9.54, ["Fly"] = 70.56, ["Ride"] = 23.87, ["Fly|Ride"] = 91.88, ["Neon"] = 62.99, ["Neon|Ride"] = 112.44, ["Neon|Fly|Ride"] = 140.8, ["Mega|Ride"] = 631.66, ["Mega|Fly|Ride"] = 748.13}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 30.18, ["Fly"] = 111.62, ["Ride"] = 56.75, ["Fly|Ride"] = 84.25, ["Neon"] = 161.63, ["Neon|Ride"] = 183.24, ["Neon|Fly|Ride"] = 280.04, ["Mega"] = 735, ["Mega|Ride"] = 1684.43, ["Mega|Fly|Ride"] = 883.73}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 12.94, ["Fly"] = 22.73, ["Ride"] = 20.97, ["Fly|Ride"] = 31.49, ["Neon"] = 124.91, ["Neon|Ride"] = 96.89, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 1124.37, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8888.24}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2688.74}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 15.04}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 176.79, ["Fly"] = 421.17, ["Ride"] = 229.69, ["Fly|Ride"] = 341.25, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 1797.07, ["Mega|Fly|Ride"] = 5755.45}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 18.36, ["Fly"] = 130.57, ["Ride"] = 31.42, ["Fly|Ride"] = 93.4, ["Neon"] = 118.11, ["Neon|Ride"] = 262.5, ["Mega"] = 544.9, ["Mega|Ride"] = 562.19, ["Mega|Fly|Ride"] = 456.91}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 8.02}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 4.87, ["Neon"] = 70.88, ["Neon|Ride"] = 183.24, ["Mega"] = 1050}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2572.5}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 154.88, ["Ride"] = 144.38, ["Fly|Ride"] = 170.62, ["Neon"] = 373.55, ["Neon|Ride"] = 328.13, ["Mega|Fly|Ride"] = 1853.92}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 84.32, ["Ride"] = 103.43, ["Fly|Ride"] = 418.73, ["Neon"] = 466.94, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 1793.92, ["Mega|Ride"] = 1575, ["Mega|Fly|Ride"] = 1400.16}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 115.81, ["Fly"] = 281.14, ["Ride"] = 147, ["Fly|Ride"] = 193.97, ["Neon"] = 778.59, ["Neon|Ride"] = 562.33, ["Neon|Fly|Ride"] = 845.09, ["Mega|Fly|Ride"] = 2936.07}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1068.62, ["Fly"] = 2526.95, ["Ride"] = 918.75, ["Fly|Ride"] = 1097.97, ["Neon|Fly|Ride"] = 4592.44, ["Mega|Fly|Ride"] = 21055.18}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 11.5, ["Fly"] = 109.7, ["Ride"] = 37.83, ["Fly|Ride"] = 49.5, ["Neon"] = 105, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 437.07, ["Mega"] = 933.44, ["Mega|Ride"] = 778.25, ["Mega|Fly|Ride"] = 791.69}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 582.74, ["Fly"] = 2100, ["Ride"] = 689.07, ["Fly|Ride"] = 1149.75, ["Neon|Fly|Ride"] = 4045.25}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 48.47}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 10.47, ["Fly"] = 144.38, ["Ride"] = 23.63, ["Fly|Ride"] = 98.44, ["Neon"] = 52.5, ["Neon|Ride"] = 156.37, ["Neon|Fly|Ride"] = 379.01, ["Mega"] = 391.84, ["Mega|Ride"] = 418.69, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 7.76, ["Fly"] = 350.07, ["Ride"] = 24.41, ["Fly|Ride"] = 46.71, ["Neon"] = 56.44, ["Neon|Ride"] = 84.26, ["Neon|Fly|Ride"] = 202.18, ["Mega|Ride"] = 389.72, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 63.14}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 17.37, ["Ride"] = 18.94, ["Fly|Ride"] = 65.54, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 544.9, ["Mega"] = 815.91, ["Mega|Ride"] = 1123.32, ["Mega|Fly|Ride"] = 1244.97}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 16.05, ["Fly"] = 39.38, ["Ride"] = 44.34, ["Fly|Ride"] = 60.98, ["Neon"] = 141.1, ["Neon|Fly"] = 242.84, ["Neon|Ride"] = 263.27, ["Neon|Fly|Ride"] = 274.32, ["Mega"] = 1402.29, ["Mega|Ride"] = 963.3, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 5248.95, ["Fly"] = 11231.16, ["Ride"] = 6091.1, ["Fly|Ride"] = 4418.24, ["Neon|Fly|Ride"] = 9711.19, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 7.18, ["Fly"] = 80.07, ["Ride"] = 22.32, ["Fly|Ride"] = 111.26, ["Neon"] = 65.55, ["Neon|Fly"] = 105.32, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 156.37, ["Mega"] = 449.17, ["Mega|Ride"] = 378.37, ["Mega|Fly|Ride"] = 454.65}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 13.13}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 74.8, ["Fly"] = 372.74, ["Ride"] = 149.96, ["Fly|Ride"] = 167.89, ["Neon"] = 411.24, ["Neon|Ride"] = 394.85, ["Neon|Fly|Ride"] = 476.44, ["Mega|Fly|Ride"] = 1443.75}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 57.63, ["Fly"] = 183.75, ["Ride"] = 72.19, ["Fly|Ride"] = 210.59, ["Neon"] = 235.09, ["Neon|Ride"] = 378, ["Neon|Fly|Ride"] = 271.41, ["Mega|Ride"] = 1353.49, ["Mega|Fly|Ride"] = 1044.36}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 21.95, ["Fly"] = 70.82, ["Ride"] = 25.91, ["Fly|Ride"] = 78.75, ["Neon"] = 126.36, ["Neon|Ride"] = 113.96, ["Neon|Fly|Ride"] = 171.94, ["Mega|Fly|Ride"] = 484.3}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 3.93, ["Fly"] = 47.57, ["Ride"] = 15.21, ["Fly|Ride"] = 77.93, ["Neon"] = 14.94, ["Neon|Ride"] = 36.74, ["Neon|Fly|Ride"] = 82.03, ["Mega"] = 118.13, ["Mega|Ride"] = 155.87, ["Mega|Fly|Ride"] = 242.82}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 9.85, ["Ride"] = 27.57, ["Fly|Ride"] = 98.6, ["Neon"] = 82.9, ["Neon|Ride"] = 78.23, ["Neon|Fly|Ride"] = 149.63, ["Mega"] = 379.01, ["Mega|Ride"] = 419.99, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 15.75, ["Fly"] = 20.88, ["Ride"] = 21.25, ["Fly|Ride"] = 38.58, ["Neon"] = 208.69, ["Neon|Fly"] = 210.62, ["Neon|Ride"] = 139.01, ["Neon|Fly|Ride"] = 127.32, ["Mega|Fly"] = 702.2, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 187.69}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 21.04, ["Fly"] = 124.88, ["Ride"] = 98.44, ["Neon"] = 77.91, ["Neon|Ride"] = 393.85, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 472.5, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 127.21, ["Ride"] = 360.1, ["Fly|Ride"] = 262.49}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 38.06, ["Ride"] = 76.13, ["Fly|Ride"] = 210, ["Neon"] = 199.5, ["Neon|Ride"] = 324.98, ["Neon|Fly|Ride"] = 381.11, ["Mega"] = 1076.25, ["Mega|Ride"] = 1212.8, ["Mega|Fly|Ride"] = 958.13}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 623.44, ["Fly"] = 778.59, ["Ride"] = 689.07, ["Fly|Ride"] = 634.75, ["Neon|Ride"] = 1506.75, ["Neon|Fly|Ride"] = 1837.5, ["Mega|Fly|Ride"] = 7783.13}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 239.03, ["Ride"] = 185.52, ["Fly|Ride"] = 288.75, ["Neon"] = 1157.14, ["Neon|Fly"] = 3425.23, ["Neon|Ride"] = 1067.78, ["Neon|Fly|Ride"] = 1119.09, ["Mega"] = 8282.07, ["Mega|Ride"] = 4083.74, ["Mega|Fly|Ride"] = 4357.94}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 76.96}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 7.88, ["Fly"] = 23.09, ["Ride"] = 22.32, ["Fly|Ride"] = 48.57, ["Neon"] = 80.07, ["Neon|Fly"] = 230.99, ["Neon|Ride"] = 60.73, ["Neon|Fly|Ride"] = 118.97, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 379.32}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 286.13, ["Fly"] = 421.17, ["Ride"] = 315, ["Fly|Ride"] = 393.75, ["Neon"] = 1176.81, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 912.19, ["Mega|Fly|Ride"] = 4082.61}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 11.79}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 103.69, ["Fly"] = 178.12, ["Ride"] = 140.84, ["Fly|Ride"] = 183.75, ["Neon"] = 459.38, ["Neon|Fly"] = 1404.75, ["Neon|Ride"] = 486.94, ["Neon|Fly|Ride"] = 491.7, ["Mega"] = 2210.81, ["Mega|Ride"] = 2147.64, ["Mega|Fly|Ride"] = 1763.06}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 155.74, ["Ride"] = 131.17, ["Fly|Ride"] = 105, ["Neon|Ride"] = 997.5, ["Neon|Fly|Ride"] = 700.07}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 3.34, ["Ride"] = 32.59, ["Fly|Ride"] = 62.83, ["Neon"] = 28.45, ["Neon|Ride"] = 45.14, ["Neon|Fly|Ride"] = 141.08, ["Mega"] = 240.19, ["Mega|Ride"] = 280.2, ["Mega|Fly|Ride"] = 546.31}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 12.22, ["Fly"] = 42, ["Ride"] = 24.91, ["Fly|Ride"] = 112.67, ["Neon"] = 97.31, ["Neon|Ride"] = 106.24, ["Neon|Fly|Ride"] = 196.24, ["Mega|Ride"] = 736.95, ["Mega|Fly|Ride"] = 623.07}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 15.67, ["Fly"] = 141.1, ["Ride"] = 65.63, ["Fly|Ride"] = 72.56, ["Neon"] = 169.32, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 228.24, ["Mega"] = 328.13, ["Mega|Ride"] = 354.12, ["Mega|Fly|Ride"] = 526.39}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 3.42, ["Fly"] = 336.94, ["Ride"] = 23.67, ["Fly|Ride"] = 104.7, ["Neon"] = 12.55, ["Neon|Fly"] = 69.51, ["Neon|Ride"] = 52.55, ["Neon|Fly|Ride"] = 119, ["Mega"] = 109.71, ["Mega|Fly"] = 183.74, ["Mega|Ride"] = 130.52, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 211.25, ["Fly"] = 918.75, ["Ride"] = 310.8, ["Fly|Ride"] = 334.69, ["Neon"] = 1741.49, ["Neon|Ride"] = 1246.88, ["Neon|Fly|Ride"] = 1721.08}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 116.88, ["Fly"] = 1050, ["Ride"] = 166.69, ["Fly|Ride"] = 222.92, ["Neon"] = 753.38, ["Neon|Ride"] = 561.75, ["Neon|Fly|Ride"] = 630, ["Mega"] = 2105.53, ["Mega|Ride"] = 2132.9, ["Mega|Fly|Ride"] = 2100}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 59.07, ["Fly"] = 155.84, ["Ride"] = 54.95, ["Fly|Ride"] = 131.24, ["Neon"] = 562.26, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 425.25, ["Mega"] = 1618.34, ["Mega|Ride"] = 1660.32, ["Mega|Fly|Ride"] = 1443.75}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 12.84, ["Fly"] = 52.5, ["Ride"] = 58.24, ["Fly|Ride"] = 281.14, ["Neon"] = 210.59, ["Neon|Ride"] = 593.07, ["Neon|Fly|Ride"] = 490.61, ["Mega"] = 421.12, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 14.44, ["Ride"] = 39.34, ["Fly|Ride"] = 98.44, ["Neon"] = 69.5, ["Neon|Ride"] = 112.88, ["Neon|Fly|Ride"] = 210.21, ["Mega"] = 484.29, ["Mega|Fly"] = 525, ["Mega|Ride"] = 315.84, ["Mega|Fly|Ride"] = 557.26}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 2.63, ["Fly"] = 42.13, ["Ride"] = 16.31, ["Fly|Ride"] = 69.5, ["Neon"] = 15.36, ["Neon|Ride"] = 27.64, ["Neon|Fly|Ride"] = 116.82, ["Mega"] = 106.12, ["Mega|Ride"] = 168, ["Mega|Fly|Ride"] = 213.94}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 905.63, ["Fly"] = 1118.71, ["Ride"] = 918.75, ["Fly|Ride"] = 853.13, ["Neon"] = 3034.98, ["Neon|Fly"] = 2843.15, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2362.5, ["Mega"] = 11931.98, ["Mega|Fly|Ride"] = 7054.69}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 239.24, ["Fly"] = 499.62, ["Ride"] = 255.94, ["Fly|Ride"] = 328.13, ["Neon"] = 1010.79, ["Neon|Ride"] = 943.69, ["Neon|Fly|Ride"] = 1005.38, ["Mega"] = 10527.6, ["Mega|Fly|Ride"] = 3281.25}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 63.06, ["Ride"] = 98.81, ["Fly|Ride"] = 196.29, ["Neon"] = 354.38, ["Neon|Ride"] = 373.65, ["Neon|Fly|Ride"] = 407.44, ["Mega"] = 1640.63, ["Mega|Ride"] = 1684.43, ["Mega|Fly|Ride"] = 1368.61}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 144.38, ["Fly"] = 227.07, ["Ride"] = 131.59, ["Fly|Ride"] = 263.23, ["Neon"] = 673.86, ["Neon|Ride"] = 983.53, ["Neon|Fly|Ride"] = 675.09, ["Mega"] = 10527.6, ["Mega|Fly|Ride"] = 2735.09}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 15.52, ["Fly"] = 48.44, ["Ride"] = 19.95, ["Fly|Ride"] = 68.25, ["Neon"] = 157.49, ["Neon|Ride"] = 291.37, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 533.76, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 763.09}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 249.38, ["Ride"] = 364.31, ["Neon"] = 1334.02, ["Neon|Ride"] = 1345.77, ["Neon|Fly|Ride"] = 1106.46, ["Mega"] = 5223.84, ["Mega|Fly|Ride"] = 3937.5}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 116.82, ["Fly"] = 172.7, ["Ride"] = 112.67, ["Fly|Ride"] = 101.57, ["Neon|Ride"] = 466.98, ["Neon|Fly|Ride"] = 568.5, ["Mega|Fly|Ride"] = 1732.5}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1246.88, ["Ride"] = 1351.88, ["Fly|Ride"] = 1357.13, ["Neon"] = 13125, ["Neon|Ride"] = 3933.03, ["Neon|Fly|Ride"] = 4492.14, ["Mega"] = 50532.43, ["Mega|Fly|Ride"] = 23211.92}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 9.93, ["Fly"] = 48.25, ["Ride"] = 31.49, ["Fly|Ride"] = 65.56, ["Neon"] = 38.9, ["Neon|Fly"] = 140.85, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 157.31, ["Mega|Ride"] = 274.58, ["Mega|Fly|Ride"] = 370.13}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 46.64, ["Ride"] = 52.97, ["Fly|Ride"] = 65.63, ["Neon"] = 203.44, ["Neon|Ride"] = 189.56, ["Neon|Fly|Ride"] = 413.34, ["Mega"] = 2916.38, ["Mega|Ride"] = 954.86, ["Mega|Fly|Ride"] = 1046.62}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 51.32, ["Fly"] = 88.46, ["Ride"] = 72.19, ["Fly|Ride"] = 90.56, ["Neon|Ride"] = 410.82, ["Neon|Fly|Ride"] = 317.62, ["Mega|Fly|Ride"] = 1404.39}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 2703.61, ["Ride"] = 891.19, ["Fly|Ride"] = 917.84, ["Neon|Fly|Ride"] = 4199.99, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 311.57, ["Ride"] = 387.48, ["Fly|Ride"] = 403.62, ["Neon|Ride"] = 1684.83, ["Neon|Fly|Ride"] = 1263.32, ["Mega|Fly|Ride"] = 9179.07}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 104.72, ["Fly"] = 209.83, ["Ride"] = 131.25, ["Fly|Ride"] = 210.59, ["Neon"] = 701.09, ["Neon|Ride"] = 429.99, ["Neon|Fly|Ride"] = 525, ["Mega"] = 4211.04, ["Mega|Ride"] = 4211.04, ["Mega|Fly|Ride"] = 1541.25}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 6.06, ["Fly"] = 39.38, ["Ride"] = 16.79, ["Fly|Ride"] = 87.94, ["Neon"] = 21.07, ["Neon|Ride"] = 37.14, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 641.74, ["Mega|Ride"] = 508.59, ["Mega|Fly|Ride"] = 811.69}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 34.72, ["Fly"] = 70.56, ["Ride"] = 44.6, ["Fly|Ride"] = 61.69, ["Neon"] = 209.9, ["Neon|Fly"] = 294.86, ["Neon|Ride"] = 230.2, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 1821.29, ["Mega|Fly|Ride"] = 1022.16}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 813.75, ["Fly"] = 894.37, ["Ride"] = 918.75, ["Fly|Ride"] = 784.88, ["Neon|Ride"] = 5250, ["Neon|Fly|Ride"] = 2863.29, ["Mega|Fly|Ride"] = 12912.76}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 916.84}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 4408.16, ["Ride"] = 2327, ["Fly|Ride"] = 3360, ["Neon|Ride"] = 30180.47, ["Neon|Fly|Ride"] = 13125, ["Mega|Fly|Ride"] = 89836.14}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 113.32, ["Fly"] = 408.19, ["Ride"] = 393.75, ["Fly|Ride"] = 379.05, ["Neon"] = 851.82, ["Neon|Ride"] = 1245.65, ["Neon|Fly|Ride"] = 851.82, ["Mega"] = 5895.46, ["Mega|Fly|Ride"] = 4913.24}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 88.5, ["Ride"] = 122.07, ["Fly|Ride"] = 336, ["Neon|Ride"] = 471.77, ["Neon|Fly|Ride"] = 459.38, ["Mega|Fly|Ride"] = 2807.73}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 11.82, ["Fly"] = 131.25, ["Ride"] = 16.44, ["Fly|Ride"] = 73.43, ["Neon"] = 274.32, ["Neon|Fly"] = 328.13, ["Neon|Ride"] = 84.26, ["Neon|Fly|Ride"] = 195.57, ["Mega"] = 690.63, ["Mega|Ride"] = 842.22, ["Mega|Fly|Ride"] = 623.07}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 13.83, ["Fly"] = 39.38, ["Ride"] = 24.12, ["Fly|Ride"] = 42.03, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 372.69, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 701.15}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 12.31, ["Fly"] = 70.9, ["Ride"] = 41.06, ["Fly|Ride"] = 84.25, ["Neon"] = 84.25, ["Neon|Ride"] = 61.25, ["Neon|Fly|Ride"] = 187.69, ["Mega"] = 1179.11, ["Mega|Ride"] = 859.69, ["Mega|Fly|Ride"] = 681.15}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 3.93, ["Ride"] = 27.91, ["Fly|Ride"] = 252, ["Neon"] = 52.5, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 166.68, ["Mega"] = 210, ["Mega|Ride"] = 336.9, ["Mega|Fly|Ride"] = 357}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 17.94, ["Ride"] = 39.45, ["Fly|Ride"] = 164.53, ["Neon"] = 126.13, ["Neon|Ride"] = 294.78, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 673.78, ["Mega|Ride"] = 560.41}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 223.13, ["Fly"] = 300.07, ["Ride"] = 242.53, ["Fly|Ride"] = 257.25, ["Neon"] = 689.67, ["Neon|Ride"] = 681.19, ["Neon|Fly|Ride"] = 677.25, ["Mega"] = 6562.5, ["Mega|Ride"] = 4211.04, ["Mega|Fly|Ride"] = 2493.75}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.63, ["Fly"] = 15.43, ["Ride"] = 13.13, ["Fly|Ride"] = 19.51, ["Neon"] = 13.52, ["Neon|Fly"] = 93.41, ["Neon|Ride"] = 23.12, ["Neon|Fly|Ride"] = 69.18, ["Mega"] = 157.5, ["Mega|Ride"] = 160.13, ["Mega|Fly|Ride"] = 189.52}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 34.13, ["Fly"] = 77.02, ["Ride"] = 46.87, ["Fly|Ride"] = 64.18, ["Neon"] = 140.44, ["Neon|Fly"] = 226.11, ["Neon|Ride"] = 140.84, ["Neon|Fly|Ride"] = 224.44, ["Mega"] = 525, ["Mega|Ride"] = 547.2, ["Mega|Fly|Ride"] = 483.83}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 682.5, ["Fly"] = 787.5, ["Ride"] = 654.94, ["Fly|Ride"] = 690.26, ["Neon|Ride"] = 1967.05, ["Neon|Fly|Ride"] = 1437.18, ["Mega|Fly|Ride"] = 3937.5}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 20.83, ["Fly"] = 59.41, ["Ride"] = 28.3, ["Fly|Ride"] = 47.14, ["Neon|Fly"] = 466.98, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 187.69, ["Mega"] = 1575, ["Mega|Ride"] = 983.29, ["Mega|Fly|Ride"] = 698.25}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 245.95, ["Fly"] = 351.68, ["Ride"] = 224.44, ["Fly|Ride"] = 216.36, ["Neon"] = 1404.56, ["Neon|Fly|Ride"] = 787.5, ["Mega|Fly|Ride"] = 4183.69}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 114.18, ["Fly"] = 139.12, ["Ride"] = 88.98, ["Fly|Ride"] = 149.63, ["Neon"] = 631.75, ["Neon|Fly"] = 640.25, ["Neon|Ride"] = 525.47, ["Neon|Fly|Ride"] = 543.37, ["Mega"] = 2947.73, ["Mega|Fly|Ride"] = 1730.06}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 646.41, ["Ride"] = 602.05, ["Fly|Ride"] = 623.44, ["Neon"] = 2373.21, ["Neon|Ride"] = 2400.89, ["Neon|Fly|Ride"] = 2358.2, ["Mega|Fly|Ride"] = 7299.85}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 17.46, ["Ride"] = 31.54, ["Fly|Ride"] = 91.63, ["Neon"] = 91.62, ["Neon|Fly"] = 183.24, ["Neon|Ride"] = 115.5, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 422.43, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 466.73}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 3693.38, ["Fly"] = 3956.54, ["Ride"] = 3511.39, ["Fly|Ride"] = 2953.13, ["Neon"] = 14003.41, ["Neon|Fly|Ride"] = 5906.25, ["Mega|Fly|Ride"] = 25058.25}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 56.9, ["Fly"] = 81.33, ["Ride"] = 77.93, ["Fly|Ride"] = 125.62, ["Neon"] = 394.74, ["Neon|Fly"] = 420.29, ["Neon|Ride"] = 404.88, ["Neon|Fly|Ride"] = 400.32, ["Mega|Fly|Ride"] = 1684.43}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.41, ["Fly"] = 26.25, ["Ride"] = 13.86, ["Fly|Ride"] = 52.5, ["Neon"] = 15.75, ["Neon|Fly"] = 44.63, ["Neon|Ride"] = 38.06, ["Neon|Fly|Ride"] = 61.03, ["Mega"] = 122.07, ["Mega|Fly"] = 452.82, ["Mega|Ride"] = 138.54, ["Mega|Fly|Ride"] = 232.53}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 2.63, ["Ride"] = 22.32, ["Neon"] = 11.64, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 141.08, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 41.99, ["Fly"] = 65.63, ["Ride"] = 45.49, ["Fly|Ride"] = 70.06, ["Neon|Ride"] = 702.38, ["Neon|Fly|Ride"] = 240.19, ["Mega|Fly|Ride"] = 1141.88}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 910.96, ["Ride"] = 772.15, ["Fly|Ride"] = 966.45, ["Neon|Ride"] = 5265.08, ["Neon|Fly|Ride"] = 3937.5, ["Mega|Fly|Ride"] = 19651.87}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 4975.29, ["Ride"] = 5616.12, ["Fly|Ride"] = 4856.25}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 19.55, ["Fly"] = 26.88, ["Ride"] = 22.32, ["Fly|Ride"] = 36.01, ["Neon"] = 452.12, ["Neon|Ride"] = 124.92, ["Neon|Fly|Ride"] = 110.25, ["Mega"] = 2526.63, ["Mega|Fly|Ride"] = 616.07}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 11.81, ["Fly"] = 31.49, ["Ride"] = 20.04, ["Fly|Ride"] = 77.7, ["Neon"] = 82.93, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 139.12, ["Mega"] = 933.44, ["Mega|Ride"] = 354.38, ["Mega|Fly|Ride"] = 542.38}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 28.32, ["Fly"] = 157.47, ["Ride"] = 42, ["Fly|Ride"] = 57.94, ["Neon"] = 393.75, ["Neon|Ride"] = 187.38, ["Neon|Fly|Ride"] = 295.17, ["Mega|Fly|Ride"] = 868.88}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 229.69, ["Ride"] = 210, ["Fly|Ride"] = 304.76, ["Neon|Ride"] = 1048.69, ["Neon|Fly|Ride"] = 1139.11, ["Mega"] = 10527.6, ["Mega|Fly|Ride"] = 3655.32}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.72, ["Ride"] = 41.08, ["Fly|Ride"] = 105, ["Neon"] = 14.44, ["Neon|Fly"] = 70.95, ["Neon|Ride"] = 104.27, ["Neon|Fly|Ride"] = 138.98, ["Mega"] = 123.3, ["Mega|Ride"] = 235.8, ["Mega|Fly|Ride"] = 302.16}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 183.23, ["Fly"] = 291.84, ["Ride"] = 196.88, ["Fly|Ride"] = 274.32, ["Neon"] = 631.75, ["Neon|Ride"] = 711.38, ["Neon|Fly|Ride"] = 733.68, ["Mega"] = 3496.23, ["Mega|Fly|Ride"] = 2624.99}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 3.07, ["Fly"] = 28.34, ["Ride"] = 13.13, ["Fly|Ride"] = 37.1, ["Neon"] = 15.1, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 336.9, ["Mega|Ride"] = 437.07, ["Mega|Fly|Ride"] = 464.28}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 206.89, ["Fly"] = 269.56, ["Ride"] = 190.32, ["Fly|Ride"] = 261.19, ["Neon|Fly|Ride"] = 891.19, ["Mega"] = 10527.6, ["Mega|Fly|Ride"] = 3789.94}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 6.18, ["Fly"] = 421.17, ["Ride"] = 17.35, ["Fly|Ride"] = 63.18, ["Neon"] = 124.26, ["Neon|Fly"] = 296.54, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 421.12, ["Mega"] = 450.6, ["Mega|Ride"] = 589.56, ["Mega|Fly|Ride"] = 503.43}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.1, ["Fly|Ride"] = 131.25, ["Neon"] = 11.08, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 38.56, ["Neon|Fly|Ride"] = 109.76, ["Mega"] = 76.13, ["Mega|Fly"] = 421.12, ["Mega|Ride"] = 100.9, ["Mega|Fly|Ride"] = 213.94}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.88, ["Mega"] = 23.26, ["Mega|Ride"] = 39.35, ["Mega|Fly|Ride"] = 166.36}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 2.1, ["Ride"] = 27.4, ["Fly|Ride"] = 140.84, ["Neon"] = 6.03, ["Neon|Ride"] = 32.4, ["Neon|Fly|Ride"] = 112.66, ["Mega"] = 64.95, ["Mega|Fly"] = 155571.39, ["Mega|Ride"] = 107.51, ["Mega|Fly|Ride"] = 191.25}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 56.13, ["Fly"] = 131.25, ["Ride"] = 65.63, ["Fly|Ride"] = 131.25, ["Neon"] = 249.38, ["Neon|Ride"] = 223.12, ["Neon|Fly|Ride"] = 338.28, ["Mega"] = 1228.58, ["Mega|Ride"] = 1311.19, ["Mega|Fly|Ride"] = 1122.26}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 45.82, ["Ride"] = 18.38, ["Fly|Ride"] = 29.01, ["Neon"] = 6.29, ["Neon|Ride"] = 40.66, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 129.94, ["Mega|Ride"] = 137.71, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 6.15, ["Ride"] = 59.07, ["Neon"] = 68.77, ["Neon|Ride"] = 212.63, ["Mega"] = 420, ["Mega|Ride"] = 300.97}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 156.37, ["Mega"] = 11.64, ["Mega|Ride"] = 57.84, ["Mega|Fly|Ride"] = 156.37}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.05, ["Fly"] = 17.04, ["Ride"] = 8.28, ["Fly|Ride"] = 35.81, ["Neon"] = 2.1, ["Neon|Fly"] = 21.08, ["Neon|Ride"] = 14.42, ["Neon|Fly|Ride"] = 72.16, ["Mega"] = 11.8, ["Mega|Ride"] = 14.11, ["Mega|Fly|Ride"] = 41.96}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.05, ["Ride"] = 14.95, ["Fly|Ride"] = 32.69, ["Neon"] = 2.1, ["Neon|Fly"] = 39.35, ["Neon|Ride"] = 15.43, ["Neon|Fly|Ride"] = 41.99, ["Mega"] = 17.26, ["Mega|Ride"] = 27.57, ["Mega|Fly|Ride"] = 65.56}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Ride"] = 33.71, ["Neon"] = 2.1, ["Mega"] = 15.27, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 155.82}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 21.04, ["Ride"] = 14.44, ["Fly|Ride"] = 105.3, ["Neon"] = 3.94, ["Neon|Ride"] = 35.75, ["Neon|Fly|Ride"] = 73.43, ["Mega"] = 31.65, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 66.12, ["Mega|Fly|Ride"] = 126.35}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 3.29, ["Neon|Fly|Ride"] = 140.63, ["Mega"] = 15.75, ["Mega|Ride"] = 84.89, ["Mega|Fly|Ride"] = 421.12}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 2.1, ["Fly"] = 42.13, ["Ride"] = 19.57, ["Fly|Ride"] = 48.49, ["Neon"] = 3.63, ["Neon|Fly"] = 31.49, ["Neon|Ride"] = 21.04, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 56.44, ["Mega|Fly"] = 91.61, ["Mega|Ride"] = 78.67, ["Mega|Fly|Ride"] = 103.47}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 45.56, ["Mega"] = 9.28, ["Mega|Ride"] = 47.25, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.48, ["Ride"] = 142.15, ["Fly|Ride"] = 525, ["Neon"] = 14.05, ["Mega"] = 131.25}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Ride"] = 55.55, ["Neon"] = 21}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 24.94, ["Neon"] = 2.1, ["Neon|Ride"] = 103.95, ["Mega"] = 25.86, ["Mega|Ride"] = 156.37, ["Mega|Fly|Ride"] = 141.08}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.05, ["Fly"] = 30.37, ["Ride"] = 15.42, ["Fly|Ride"] = 50.55, ["Neon"] = 2.05, ["Neon|Fly"] = 33.71, ["Neon|Ride"] = 15.78, ["Neon|Fly|Ride"] = 38.59, ["Mega"] = 11.82, ["Mega|Ride"] = 20.97, ["Mega|Fly|Ride"] = 34.78}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 3.03, ["Fly"] = 72.19, ["Ride"] = 218.19, ["Fly|Ride"] = 119, ["Neon"] = 27.57, ["Neon|Ride"] = 39.38, ["Mega"] = 251.63, ["Mega|Ride"] = 351.63}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 23.18, ["Fly|Ride"] = 78.73, ["Neon"] = 3.92, ["Neon|Ride"] = 31.61, ["Neon|Fly|Ride"] = 63.18, ["Mega"] = 28.34, ["Mega|Fly"] = 156.37, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 98.44}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 2.1, ["Ride"] = 70.56, ["Neon"] = 7.74, ["Neon|Fly|Ride"] = 141.08, ["Mega"] = 40.95, ["Mega|Ride"] = 132.57, ["Mega|Fly|Ride"] = 421.12}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.1, ["Fly"] = 656.25, ["Ride"] = 32.81, ["Fly|Ride"] = 191.64, ["Neon"] = 8.91, ["Neon|Fly"] = 92.24, ["Neon|Ride"] = 42.14, ["Neon|Fly|Ride"] = 271.63, ["Mega"] = 63.18, ["Mega|Fly|Ride"] = 280.26}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.05, ["Fly"] = 12.78, ["Ride"] = 22.29, ["Fly|Ride"] = 20.57, ["Neon"] = 2.1, ["Neon|Fly"] = 14.42, ["Neon|Ride"] = 11.38, ["Neon|Fly|Ride"] = 21, ["Mega"] = 14.43, ["Mega|Fly"] = 23.63, ["Mega|Ride"] = 12.55, ["Mega|Fly|Ride"] = 42.18}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 19.62, ["Fly|Ride"] = 42, ["Neon"] = 15.73, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 62.99, ["Mega"] = 89.25, ["Mega|Ride"] = 164.07, ["Mega|Fly|Ride"] = 201.09}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 3.15, ["Fly"] = 110.1, ["Neon"] = 43.05, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 140.03, ["Mega"] = 178.54, ["Mega|Ride"] = 419.01, ["Mega|Fly|Ride"] = 357.95}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 14.26, ["Ride"] = 15.74, ["Neon"] = 2.1, ["Neon|Fly"] = 23.63, ["Neon|Ride"] = 14.54, ["Mega"] = 15.73, ["Mega|Fly"] = 156.19, ["Mega|Ride"] = 141.08, ["Mega|Fly|Ride"] = 124.86}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.05, ["Ride"] = 26.25, ["Neon"] = 4.08, ["Neon|Fly"] = 77.95, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 105, ["Mega"] = 61.84, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 311.54}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 28.45, ["Neon"] = 3.93, ["Neon|Fly|Ride"] = 311.54, ["Mega"] = 31.5, ["Mega|Fly|Ride"] = 189.52}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Neon"] = 2.1, ["Neon|Fly"] = 40.69, ["Neon|Ride"] = 35.43, ["Neon|Fly|Ride"] = 63.02, ["Mega"] = 11.17, ["Mega|Ride"] = 72.35, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Ride"] = 20.9, ["Fly|Ride"] = 77.68, ["Neon"] = 5.25, ["Neon|Fly"] = 42.14, ["Neon|Ride"] = 44.61, ["Neon|Fly|Ride"] = 84, ["Mega"] = 219.38, ["Mega|Ride"] = 87.94}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 21.07, ["Neon"] = 3.87, ["Neon|Fly"] = 32.82, ["Mega"] = 70.43, ["Mega|Ride"] = 78.68, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 28.25, ["Ride"] = 14.85, ["Fly|Ride"] = 39.38, ["Neon"] = 3.94, ["Neon|Fly"] = 70.56, ["Neon|Ride"] = 25.38, ["Neon|Fly|Ride"] = 57.75, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 2.63, ["Ride"] = 79.92, ["Neon"] = 49.23, ["Mega"] = 296.63, ["Mega|Fly|Ride"] = 778.25}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Ride"] = 20.93, ["Fly|Ride"] = 56.44, ["Neon"] = 8.97, ["Neon|Fly"] = 81.85, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 143.53, ["Mega"] = 315, ["Mega|Ride"] = 264.26, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 3.5, ["Fly"] = 91.88, ["Ride"] = 19.69, ["Fly|Ride"] = 35.44, ["Neon"] = 13.32, ["Neon|Fly"] = 56.17, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 106.32, ["Mega"] = 128.62, ["Mega|Ride"] = 164.07, ["Mega|Fly|Ride"] = 197.65}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 5.25, ["Fly"] = 79.47, ["Fly|Ride"] = 106.14, ["Neon"] = 35.74}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 15.75, ["Mega"] = 459.38, ["Mega|Ride"] = 983.29, ["Mega|Fly|Ride"] = 794.07}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 39.38, ["Ride"] = 22.81, ["Fly|Ride"] = 69.59, ["Neon"] = 138.03, ["Mega"] = 363.27, ["Mega|Ride"] = 562.19, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 11.69, ["Ride"] = 70.06, ["Neon"] = 25.05, ["Neon|Ride"] = 291.38, ["Mega"] = 229.46, ["Mega|Ride"] = 269.73, ["Mega|Fly|Ride"] = 415.86}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.92, ["Neon|Ride"] = 121.11, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 14.2, ["Mega|Ride"] = 70.55, ["Mega|Fly|Ride"] = 148.32}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 52.22}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 5.25, ["Fly"] = 21.42, ["Ride"] = 21, ["Fly|Ride"] = 51.19, ["Neon"] = 32.47, ["Neon|Fly"] = 223.13, ["Neon|Ride"] = 29.8, ["Neon|Fly|Ride"] = 90.5, ["Mega"] = 281.1, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 165.08}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 19.29, ["Fly|Ride"] = 70.62, ["Neon"] = 4.09, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 156.37, ["Mega"] = 19.69, ["Mega|Ride"] = 68.25, ["Mega|Fly|Ride"] = 178.99}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 161.69, ["Fly|Ride"] = 389.89, ["Neon"] = 3.73, ["Neon|Ride"] = 44.62, ["Mega"] = 45.82, ["Mega|Ride"] = 62.29, ["Mega|Fly|Ride"] = 118.44}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.63, ["Fly"] = 32.13, ["Ride"] = 14.95, ["Neon"] = 13.13, ["Neon|Ride"] = 28.39, ["Neon|Fly|Ride"] = 155.82, ["Mega"] = 157.65, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 311.54}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 3.83, ["Ride"] = 23.37, ["Neon"] = 155.84, ["Neon|Ride"] = 63.06, ["Neon|Fly|Ride"] = 173.25, ["Mega"] = 252.68}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 50.38, ["Mega"] = 9.96, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 39.26, ["Mega|Fly|Ride"] = 162.09}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Ride"] = 18.97, ["Fly|Ride"] = 26.25, ["Neon"] = 2.63, ["Neon|Fly"] = 68.83, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 66.94, ["Mega"] = 35.44, ["Mega|Fly"] = 94.77, ["Mega|Ride"] = 58.48, ["Mega|Fly|Ride"] = 98.44}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 28.25, ["Ride"] = 17.07, ["Fly|Ride"] = 42, ["Neon"] = 4.12, ["Neon|Fly"] = 70.56, ["Neon|Ride"] = 23.13, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 42.13, ["Mega|Ride"] = 78, ["Mega|Fly|Ride"] = 133.71}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Ride"] = 281.14, ["Neon"] = 3.93, ["Neon|Ride"] = 16.89, ["Neon|Fly|Ride"] = 72.06, ["Mega"] = 20.02, ["Mega|Ride"] = 36.75, ["Mega|Fly|Ride"] = 111.57}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 3.76, ["Neon|Ride"] = 32.65, ["Neon|Fly|Ride"] = 121.09, ["Mega"] = 13.11, ["Mega|Fly"] = 105, ["Mega|Ride"] = 66.07, ["Mega|Fly|Ride"] = 131.14}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 53.71, ["Ride"] = 21.07, ["Neon"] = 3.23, ["Neon|Fly"] = 45.93, ["Neon|Ride"] = 18.47, ["Neon|Fly|Ride"] = 86.63, ["Mega"] = 20.79, ["Mega|Fly"] = 24.23, ["Mega|Ride"] = 38.07, ["Mega|Fly|Ride"] = 111.57}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Neon"] = 2.1, ["Mega"] = 14.65, ["Mega|Ride"] = 205.33}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.63, ["Neon"] = 3.59, ["Neon|Fly"] = 70.56, ["Neon|Ride"] = 78.23, ["Neon|Fly|Ride"] = 420, ["Mega"] = 22.73, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 28.3, ["Ride"] = 14.32, ["Fly|Ride"] = 52.5, ["Neon"] = 2.78, ["Neon|Ride"] = 15.65, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 41.99, ["Mega|Fly"] = 36.75, ["Mega|Ride"] = 43.3, ["Mega|Fly|Ride"] = 128.61}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 9.19, ["Ride"] = 59.07, ["Neon"] = 130.57, ["Mega"] = 415.42, ["Mega|Ride"] = 482.35, ["Mega|Fly|Ride"] = 513.77}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.59, ["Ride"] = 49.98, ["Neon"] = 94.5, ["Neon|Fly|Ride"] = 110.25, ["Mega"] = 421.12, ["Mega|Ride"] = 343.23, ["Mega|Fly|Ride"] = 631.66}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 3.29, ["Ride"] = 42.13, ["Fly|Ride"] = 344.02, ["Neon"] = 46.03, ["Neon|Ride"] = 84.26, ["Mega"] = 223.2, ["Mega|Fly|Ride"] = 562.19}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.05, ["Fly"] = 12.86, ["Ride"] = 11.43, ["Fly|Ride"] = 36.74, ["Neon"] = 2.1, ["Neon|Fly"] = 17.67, ["Neon|Ride"] = 10.5, ["Neon|Fly|Ride"] = 18.38, ["Mega"] = 10.5, ["Mega|Fly"] = 22.32, ["Mega|Ride"] = 17.07, ["Mega|Fly|Ride"] = 40.16}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 3.91, ["Ride"] = 55.13, ["Neon"] = 11.82, ["Neon|Fly"] = 141.11, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 70.2, ["Mega|Ride"] = 45.05, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.05, ["Ride"] = 31.5, ["Neon"] = 2.1, ["Neon|Fly"] = 31.54, ["Neon|Ride"] = 31.61, ["Neon|Fly|Ride"] = 79.04, ["Mega"] = 10.28, ["Mega|Fly"] = 46.69, ["Mega|Ride"] = 35.44, ["Mega|Fly|Ride"] = 208.04}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 60.9, ["Mega"] = 13.13, ["Mega|Ride"] = 84.24, ["Mega|Fly|Ride"] = 226.36}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 78.75, ["Ride"] = 15.37, ["Fly|Ride"] = 52.5, ["Neon"] = 8.28, ["Neon|Fly"] = 77.7, ["Neon|Ride"] = 37.72, ["Neon|Fly|Ride"] = 103.19, ["Mega"] = 125.92, ["Mega|Ride"] = 230.57, ["Mega|Fly|Ride"] = 195.66}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 199.4, ["Ride"] = 281.14, ["Fly|Ride"] = 315.88, ["Neon"] = 1370.41, ["Neon|Ride"] = 1050, ["Neon|Fly|Ride"] = 1263.32, ["Mega"] = 8422.08, ["Mega|Fly|Ride"] = 4856.25}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Fly|Ride"] = 52.5, ["Neon"] = 8.28, ["Neon|Ride"] = 69.51, ["Mega"] = 73.7, ["Mega|Ride"] = 175.82, ["Mega|Fly|Ride"] = 420.3}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 9.34, ["Fly"] = 103.68, ["Ride"] = 24.1, ["Fly|Ride"] = 140.2, ["Neon"] = 37.63, ["Neon|Ride"] = 156.91, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 525, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 21.17, ["Ride"] = 15.74, ["Fly|Ride"] = 63.78, ["Neon"] = 3.82, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 18.83, ["Neon|Fly|Ride"] = 43.32, ["Mega"] = 49.73, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 124.24}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Ride"] = 24.41, ["Fly|Ride"] = 122.15, ["Neon"] = 3.99, ["Neon|Fly"] = 42.14, ["Neon|Ride"] = 103.63, ["Mega"] = 84.24, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 209.51}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 2.05, ["Fly"] = 32.82, ["Ride"] = 18.09, ["Fly|Ride"] = 45.82, ["Neon"] = 28.58, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 52.65, ["Mega"] = 160.13, ["Mega|Ride"] = 279.71, ["Mega|Fly|Ride"] = 311.54}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 2.45, ["Ride"] = 33.92, ["Fly|Ride"] = 246.75, ["Neon"] = 45.55, ["Neon|Ride"] = 99, ["Neon|Fly|Ride"] = 625.35, ["Mega"] = 223.2, ["Mega|Ride"] = 350.05, ["Mega|Fly|Ride"] = 508.6}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.18, ["Fly"] = 17.04, ["Ride"] = 13.13, ["Fly|Ride"] = 28.66, ["Neon"] = 20.55, ["Neon|Fly"] = 49.5, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 71.96, ["Mega|Fly"] = 384.57, ["Mega|Ride"] = 419.71, ["Mega|Fly|Ride"] = 223.41}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 47.76, ["Ride"] = 79.12, ["Fly|Ride"] = 157.49, ["Neon"] = 244.33, ["Neon|Fly"] = 394.42, ["Neon|Ride"] = 351.72, ["Neon|Fly|Ride"] = 325.49, ["Mega|Ride"] = 1837.5, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 206.07, ["Fly"] = 315.88, ["Ride"] = 167.35, ["Fly|Ride"] = 278.88, ["Neon|Ride"] = 1123.59, ["Neon|Fly|Ride"] = 1014.75, ["Mega"] = 10527.6, ["Mega|Fly|Ride"] = 3780}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 53.68, ["Fly"] = 104.99, ["Ride"] = 41.42, ["Fly|Ride"] = 65.63, ["Neon"] = 226.47, ["Neon|Ride"] = 273, ["Neon|Fly|Ride"] = 308.44, ["Mega|Fly|Ride"] = 1022.44}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 2.86, ["Ride"] = 275.63, ["Fly|Ride"] = 56.87, ["Neon"] = 19.63, ["Neon|Ride"] = 128.63, ["Neon|Fly|Ride"] = 183.2, ["Mega"] = 246.37, ["Mega|Ride"] = 239.53, ["Mega|Fly|Ride"] = 387.85}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 8.8, ["Ride"] = 27.78, ["Fly|Ride"] = 43.32, ["Neon"] = 78.75, ["Neon|Ride"] = 291.38, ["Neon|Fly|Ride"] = 280.05, ["Mega"] = 393.75, ["Mega|Ride"] = 336, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 25.28, ["Ride"] = 19.69, ["Fly|Ride"] = 51.19, ["Neon"] = 6.48, ["Neon|Fly"] = 129.93, ["Neon|Ride"] = 19.67, ["Neon|Fly|Ride"] = 56.44, ["Mega"] = 36.19, ["Mega|Fly"] = 116.69, ["Mega|Fly|Ride"] = 178.54}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 6.06, ["Fly"] = 65.63, ["Ride"] = 24.94, ["Fly|Ride"] = 50.02, ["Neon"] = 18.75, ["Neon|Ride"] = 82.16, ["Neon|Fly|Ride"] = 141.08, ["Mega"] = 389.72, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 19.36, ["Ride"] = 12.85, ["Fly|Ride"] = 45.94, ["Neon"] = 10.49, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 23.68, ["Neon|Fly|Ride"] = 84.04, ["Mega"] = 131.24, ["Mega|Ride"] = 126.35, ["Mega|Fly|Ride"] = 311.54}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 3.66, ["Ride"] = 26.88, ["Fly|Ride"] = 328.13, ["Neon"] = 12.79, ["Neon|Ride"] = 56.76, ["Mega"] = 170.63, ["Mega|Ride"] = 533.76, ["Mega|Fly|Ride"] = 562.19}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 28.35, ["Neon"] = 2.1, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 9.16, ["Mega|Ride"] = 40.85, ["Mega|Fly|Ride"] = 166.04}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 55.71, ["Ride"] = 28.45, ["Fly|Ride"] = 56.44, ["Neon"] = 8.58, ["Neon|Fly"] = 70.56, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 84.24, ["Mega"] = 141.08, ["Mega|Ride"] = 112.66, ["Mega|Fly|Ride"] = 175.88}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.1, ["Fly"] = 36.86, ["Ride"] = 26.91, ["Fly|Ride"] = 38.96, ["Neon"] = 62.31, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 112.66, ["Mega"] = 155.82, ["Mega|Fly|Ride"] = 267.73}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 97.16, ["Fly"] = 243.7, ["Ride"] = 148.47, ["Fly|Ride"] = 182.44, ["Neon"] = 360.94, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 524.73, ["Mega|Fly|Ride"] = 1732.5}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 4.36, ["Ride"] = 240.91, ["Fly|Ride"] = 206.07, ["Neon"] = 19.69, ["Neon|Ride"] = 124.92, ["Neon|Fly|Ride"] = 105, ["Mega"] = 414.75, ["Mega|Ride"] = 421.12, ["Mega|Fly|Ride"] = 390.58}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 69.78, ["Ride"] = 17.78, ["Fly|Ride"] = 63, ["Neon"] = 21.15, ["Neon|Ride"] = 141.08, ["Neon|Fly|Ride"] = 93.23, ["Mega"] = 236.25, ["Mega|Ride"] = 255.94, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 17.1, ["Fly"] = 147.42, ["Ride"] = 63.06, ["Fly|Ride"] = 124.45, ["Neon"] = 70.88, ["Neon|Ride"] = 101.07, ["Neon|Fly|Ride"] = 294.54, ["Mega"] = 541.14, ["Mega|Ride"] = 551.25, ["Mega|Fly|Ride"] = 489.56}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 3.29}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 3.2, ["Ride"] = 35.7, ["Neon"] = 24.71, ["Neon|Fly|Ride"] = 622.2, ["Mega"] = 288.75, ["Mega|Ride"] = 406.14, ["Mega|Fly|Ride"] = 1263.32}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 21.55, ["Fly"] = 55.13, ["Ride"] = 24.29, ["Fly|Ride"] = 37.01, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 119.43, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 2105.53, ["Mega|Fly|Ride"] = 616.93}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 25.19, ["Neon"] = 2.1, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 210.56, ["Mega"] = 21.18, ["Mega|Ride"] = 40.48, ["Mega|Fly|Ride"] = 206.89}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 3.94, ["Fly"] = 22.56, ["Ride"] = 28.38, ["Neon"] = 29.24, ["Neon|Ride"] = 233.5, ["Mega"] = 248.47, ["Mega|Fly"] = 389.72, ["Mega|Ride"] = 203.04, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Ride"] = 13.13, ["Fly|Ride"] = 61.73, ["Neon"] = 12.85, ["Neon|Ride"] = 35.81, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 70.3, ["Mega|Ride"] = 98.98, ["Mega|Fly|Ride"] = 234.86}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 15.81, ["Neon"] = 3.14, ["Neon|Ride"] = 39.62, ["Neon|Fly|Ride"] = 78.84, ["Mega"] = 30.24, ["Mega|Ride"] = 64.16, ["Mega|Fly|Ride"] = 120.03}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 19.24, ["Fly"] = 156.43, ["Ride"] = 32.16, ["Neon"] = 156.91, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 351.63, ["Mega"] = 774.38, ["Mega|Ride"] = 755.7, ["Mega|Fly|Ride"] = 782.25}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.68, ["Ride"] = 46.34, ["Fly|Ride"] = 209.99, ["Neon"] = 47.25, ["Neon|Ride"] = 79, ["Mega"] = 232.2, ["Mega|Ride"] = 524.99}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 7.61, ["Fly"] = 74.82, ["Ride"] = 34.44, ["Fly|Ride"] = 99.83, ["Neon"] = 52.5, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 70.86, ["Neon|Fly|Ride"] = 138.91, ["Mega"] = 313.69, ["Mega|Ride"] = 318.42, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 69.48, ["Fly"] = 281.14, ["Ride"] = 102.38, ["Fly|Ride"] = 262.44, ["Neon"] = 421.17, ["Neon|Ride"] = 420.17, ["Neon|Fly|Ride"] = 448.06, ["Mega|Ride"] = 1797.07, ["Mega|Fly|Ride"] = 1822.38}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 17.25, ["Fly"] = 91.88, ["Ride"] = 45.89, ["Fly|Ride"] = 255.05, ["Neon"] = 83.12, ["Neon|Ride"] = 141.09, ["Neon|Fly|Ride"] = 551.25, ["Mega"] = 396.69, ["Mega|Ride"] = 353.07, ["Mega|Fly|Ride"] = 321.57}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 70.88, ["Fly"] = 131.25, ["Ride"] = 98.36, ["Fly|Ride"] = 214.12, ["Neon"] = 236.25, ["Neon|Ride"] = 263.05, ["Neon|Fly|Ride"] = 292.59, ["Mega"] = 936.97, ["Mega|Ride"] = 930.35, ["Mega|Fly|Ride"] = 903.67}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 14.44, ["Ride"] = 27.77, ["Fly|Ride"] = 140.8, ["Neon"] = 84.58, ["Neon|Fly"] = 249.38, ["Neon|Ride"] = 116.31, ["Neon|Fly|Ride"] = 209.77, ["Mega"] = 359.45, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 3.87, ["Fly"] = 28.45, ["Ride"] = 23.13, ["Fly|Ride"] = 65.63, ["Neon"] = 22.31, ["Neon|Ride"] = 93.35, ["Neon|Fly|Ride"] = 560.07, ["Mega"] = 315, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 27.98, ["Fly"] = 98.44, ["Ride"] = 91.88, ["Fly|Ride"] = 156.43, ["Neon"] = 69.71, ["Neon|Ride"] = 79.43, ["Neon|Fly|Ride"] = 525, ["Mega"] = 444.97, ["Mega|Ride"] = 299.25, ["Mega|Fly|Ride"] = 529.92}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 6.18, ["Ride"] = 25.99, ["Neon"] = 32.94, ["Neon|Ride"] = 65.63, ["Mega"] = 282.89, ["Mega|Ride"] = 301.41, ["Mega|Fly|Ride"] = 374.99}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 32.82, ["Mega"] = 18.69, ["Mega|Fly"] = 141.08, ["Mega|Ride"] = 84.24, ["Mega|Fly|Ride"] = 163.94}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 2.1, ["Ride"] = 28.45, ["Fly|Ride"] = 70.56, ["Neon"] = 10.21, ["Neon|Ride"] = 78.62, ["Mega"] = 122.83, ["Mega|Ride"] = 110.25, ["Mega|Fly|Ride"] = 281.1}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Ride"] = 17.53, ["Neon"] = 17.46, ["Neon|Ride"] = 125.99, ["Mega"] = 336, ["Mega|Ride"] = 393.75}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 3.72, ["Ride"] = 31.42, ["Fly|Ride"] = 116.75, ["Neon"] = 21.11, ["Neon|Ride"] = 84.26, ["Neon|Fly|Ride"] = 280.05, ["Mega"] = 93.49, ["Mega|Ride"] = 152.97, ["Mega|Fly|Ride"] = 263.34}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 438.2, ["Fly"] = 615.18, ["Ride"] = 473.82, ["Fly|Ride"] = 549.83, ["Neon"] = 1404.56, ["Neon|Ride"] = 1679.11, ["Neon|Fly|Ride"] = 1460.19, ["Mega|Fly|Ride"] = 4501.87}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 3.82, ["Fly"] = 56.26, ["Ride"] = 24.94, ["Fly|Ride"] = 72.39, ["Neon"] = 37.92, ["Neon|Ride"] = 84.08, ["Neon|Fly|Ride"] = 124.86, ["Mega"] = 134.5, ["Mega|Ride"] = 281.1, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 6.02, ["Fly"] = 31.49, ["Fly|Ride"] = 84.25, ["Neon"] = 75.83, ["Neon|Fly"] = 315, ["Neon|Ride"] = 64.22, ["Neon|Fly|Ride"] = 108.94, ["Mega"] = 328.48, ["Mega|Ride"] = 322.16, ["Mega|Fly|Ride"] = 400.07}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 2.1, ["Ride"] = 23.19, ["Fly|Ride"] = 315.88, ["Neon|Ride"] = 61.08, ["Mega|Ride"] = 354.38, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.05, ["Fly"] = 42.13, ["Ride"] = 24.91, ["Neon"] = 5.77, ["Neon|Fly"] = 70.56, ["Neon|Ride"] = 32.66, ["Neon|Fly|Ride"] = 125.3, ["Mega"] = 57.75, ["Mega|Fly"] = 237.93, ["Mega|Ride"] = 65.49, ["Mega|Fly|Ride"] = 186.35}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Ride"] = 14.65, ["Neon"] = 2.1, ["Neon|Ride"] = 29.01, ["Neon|Fly|Ride"] = 116.69, ["Mega"] = 18.66, ["Mega|Ride"] = 39.54, ["Mega|Fly|Ride"] = 185.73}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1362.38}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 3.94, ["Fly"] = 65.63, ["Ride"] = 39.87, ["Fly|Ride"] = 130.57, ["Neon"] = 141.1, ["Neon|Fly"] = 141.11, ["Neon|Ride"] = 128.58, ["Neon|Fly|Ride"] = 421.12, ["Mega"] = 474.86, ["Mega|Ride"] = 280.05, ["Mega|Fly|Ride"] = 278.31}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 45.36, ["Neon"] = 5.97, ["Neon|Ride"] = 74.73, ["Mega"] = 32.8, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 230.35}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.49, ["Fly"] = 42.13, ["Ride"] = 20.02, ["Fly|Ride"] = 525, ["Neon"] = 5.16, ["Neon|Ride"] = 70.09, ["Neon|Fly|Ride"] = 105, ["Mega"] = 73.79, ["Mega|Ride"] = 140.44, ["Mega|Fly|Ride"] = 183.2}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 240.29, ["Ride"] = 420, ["Fly|Ride"] = 446.25, ["Neon|Ride"] = 1443.75, ["Neon|Fly|Ride"] = 838.25, ["Mega|Fly|Ride"] = 7720.95}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 6.07, ["Fly"] = 196.88, ["Ride"] = 59.07, ["Neon"] = 52.45, ["Neon|Ride"] = 131.25, ["Mega"] = 415.86, ["Mega|Ride"] = 500.07, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 19.84, ["Neon"] = 3.92, ["Neon|Ride"] = 28.45, ["Neon|Fly|Ride"] = 86.36, ["Mega"] = 32.05, ["Mega|Fly"] = 189, ["Mega|Ride"] = 89.41, ["Mega|Fly|Ride"] = 194.25}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 239.03, ["Neon"] = 3.91, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 23.04, ["Mega|Ride"] = 124.5, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 7.96, ["Fly"] = 78.7, ["Ride"] = 34.83, ["Fly|Ride"] = 178.5, ["Neon"] = 31.87, ["Neon|Ride"] = 48.35, ["Neon|Fly|Ride"] = 276.89, ["Mega"] = 281.1, ["Mega|Ride"] = 281.1, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 9.19, ["Fly|Ride"] = 131.25, ["Neon"] = 156.08, ["Neon|Fly|Ride"] = 837.38, ["Mega"] = 421.12, ["Mega|Ride"] = 466.73, ["Mega|Fly|Ride"] = 1046.73}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 3.65, ["Neon"] = 148.77, ["Mega"] = 281.1, ["Mega|Ride"] = 406.33, ["Mega|Fly|Ride"] = 472.71}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 6.57, ["Ride"] = 65.3, ["Fly|Ride"] = 232.87, ["Neon|Ride"] = 124.43, ["Neon|Fly|Ride"] = 778.25, ["Mega"] = 660.19, ["Mega|Ride"] = 440.55, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 301.88, ["Ride"] = 459.38, ["Fly|Ride"] = 608.58, ["Neon"] = 1764.46, ["Neon|Ride"] = 1158.33, ["Neon|Fly|Ride"] = 1405.69, ["Mega|Ride"] = 3775.21, ["Mega|Fly|Ride"] = 3150}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 3.72, ["Fly"] = 24.94, ["Ride"] = 30.92, ["Fly|Ride"] = 82.69, ["Neon"] = 25.97, ["Neon|Ride"] = 98.98, ["Neon|Fly|Ride"] = 140.62, ["Mega"] = 529.78, ["Mega|Ride"] = 499.02, ["Mega|Fly|Ride"] = 694.84}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 3.36, ["Ride"] = 41.68, ["Neon"] = 26.73, ["Mega"] = 1263.32, ["Mega|Fly|Ride"] = 562.19}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 5.97, ["Ride"] = 60.37, ["Fly|Ride"] = 162.75, ["Neon"] = 16.88, ["Neon|Ride"] = 65.63, ["Mega"] = 159.8, ["Mega|Ride"] = 192.03, ["Mega|Fly|Ride"] = 295.32}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.1, ["Ride"] = 31.48, ["Fly|Ride"] = 98.99, ["Neon"] = 11.8, ["Neon|Ride"] = 65.63, ["Mega"] = 39.37, ["Mega|Ride"] = 96.7, ["Mega|Fly|Ride"] = 304.5}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 28.69, ["Ride"] = 45.94, ["Neon"] = 249.38, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 315, ["Mega"] = 842.22, ["Mega|Ride"] = 842.22, ["Mega|Fly|Ride"] = 980.78}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 583.46, ["Ride"] = 24.93, ["Neon"] = 7.25, ["Neon|Fly"] = 183.24, ["Neon|Ride"] = 47.62, ["Neon|Fly|Ride"] = 105.29, ["Mega"] = 50.48, ["Mega|Ride"] = 96.01, ["Mega|Fly|Ride"] = 241.63}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Ride"] = 31.5, ["Neon"] = 3.51, ["Neon|Ride"] = 27.28, ["Neon|Fly|Ride"] = 140.38, ["Mega"] = 43.32, ["Mega|Ride"] = 60.37, ["Mega|Fly|Ride"] = 259}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Fly"] = 1519.88, ["Ride"] = 24.23, ["Fly|Ride"] = 262.5, ["Neon"] = 6.45, ["Neon|Fly|Ride"] = 295.32, ["Mega"] = 100.01, ["Mega|Ride"] = 60.88, ["Mega|Fly|Ride"] = 192.94}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 36.05, ["Ride"] = 86.4, ["Fly|Ride"] = 156.43, ["Neon"] = 483, ["Neon|Ride"] = 464.28, ["Neon|Fly|Ride"] = 672.67, ["Mega|Ride"] = 908.55, ["Mega|Fly|Ride"] = 901.69}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 231.42, ["Ride"] = 262.5, ["Fly|Ride"] = 436.97, ["Neon|Ride"] = 1099.88, ["Neon|Fly|Ride"] = 1556.5, ["Mega"] = 7018.76, ["Mega|Fly|Ride"] = 4593.75}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 2.5, ["Neon"] = 22.35, ["Mega"] = 91.58, ["Mega|Ride"] = 192.02, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 3.81, ["Neon"] = 19.25, ["Neon|Fly|Ride"] = 1726.54, ["Mega"] = 66.07}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 3.93, ["Fly"] = 155.57, ["Ride"] = 20.55, ["Neon"] = 38.8, ["Neon|Ride"] = 63.02, ["Mega"] = 483.67, ["Mega|Ride"] = 337.84}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 25.28, ["Ride"] = 30.19, ["Neon"] = 3.54, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 47.25, ["Mega"] = 41.91, ["Mega|Ride"] = 98.44, ["Mega|Fly|Ride"] = 108.46}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 59.07, ["Neon"] = 5.25, ["Mega"] = 32.69, ["Mega|Ride"] = 206.07}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 65.54, ["Ride"] = 27.34, ["Fly|Ride"] = 46.71, ["Neon"] = 3.54, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 39.53, ["Mega|Ride"] = 72.19, ["Mega|Fly|Ride"] = 281.1}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 64.82, ["Ride"] = 18.97, ["Fly|Ride"] = 60.38, ["Neon"] = 13.57, ["Neon|Fly"] = 46.72, ["Neon|Ride"] = 39.61, ["Neon|Fly|Ride"] = 70.02, ["Mega"] = 170.63, ["Mega|Ride"] = 183.2, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 20.97, ["Ride"] = 26.23, ["Fly|Ride"] = 136.89, ["Neon"] = 114.19, ["Neon|Ride"] = 141.11, ["Mega"] = 367.5, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 96.87, ["Ride"] = 99.74, ["Fly|Ride"] = 155.84, ["Neon"] = 266.94, ["Neon|Ride"] = 391.13, ["Neon|Fly|Ride"] = 419.78, ["Mega"] = 3111.83, ["Mega|Ride"] = 1543.37, ["Mega|Fly|Ride"] = 1429.32}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Fly|Ride"] = 131.25, ["Neon"] = 3.86, ["Neon|Ride"] = 66.35, ["Neon|Fly|Ride"] = 215.39, ["Mega"] = 63.19, ["Mega|Ride"] = 91.35, ["Mega|Fly|Ride"] = 109.7}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 33.71, ["Ride"] = 18.88, ["Fly|Ride"] = 42.13, ["Neon"] = 2.1, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 38.06, ["Mega|Fly"] = 157.5, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 3.87, ["Ride"] = 26.25, ["Neon"] = 70.26, ["Neon|Ride"] = 149.55, ["Neon|Fly|Ride"] = 280.05, ["Mega"] = 611.63, ["Mega|Ride"] = 351.63, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 251.73, ["Fly"] = 347.47, ["Ride"] = 551.73, ["Fly|Ride"] = 347.82, ["Neon|Ride"] = 1474.24, ["Neon|Fly|Ride"] = 913.81, ["Mega"] = 6842.95, ["Mega|Fly|Ride"] = 5290.19}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 14.55, ["Fly"] = 209.9, ["Ride"] = 54.66, ["Fly|Ride"] = 118.13, ["Neon"] = 278.24, ["Neon|Ride"] = 210.56, ["Neon|Fly|Ride"] = 262.5, ["Mega|Ride"] = 776.58, ["Mega|Fly|Ride"] = 715.88}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 12.85, ["Fly|Ride"] = 281.29, ["Neon"] = 5.25, ["Neon|Ride"] = 40.89, ["Mega"] = 91.88, ["Mega|Ride"] = 132.66, ["Mega|Fly|Ride"] = 218.74}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 210.59, ["Ride"] = 64.93, ["Fly|Ride"] = 142.7, ["Neon"] = 25.19, ["Neon|Ride"] = 65.63, ["Mega"] = 211.32, ["Mega|Ride"] = 436.38}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 25.54, ["Ride"] = 39.38, ["Fly|Ride"] = 75.83, ["Neon|Fly|Ride"] = 336.9, ["Mega"] = 2526.63, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 749.32}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 76.56, ["Ride"] = 141.1, ["Fly|Ride"] = 98.99, ["Neon"] = 484.4, ["Neon|Ride"] = 469.88, ["Neon|Fly|Ride"] = 421.12, ["Mega"] = 3088.81, ["Mega|Fly"] = 2103.43, ["Mega|Fly|Ride"] = 2128.7}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 130.55, ["Fly"] = 501.19, ["Ride"] = 275.62, ["Fly|Ride"] = 341.7, ["Neon"] = 775.69, ["Neon|Ride"] = 983.29, ["Neon|Fly|Ride"] = 787.5, ["Mega|Fly|Ride"] = 2623.69}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 10.34, ["Ride"] = 59.07, ["Fly|Ride"] = 120.05, ["Neon"] = 90.2, ["Neon|Ride"] = 91.8, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 469.54, ["Mega|Ride"] = 380.61, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 25.72, ["Ride"] = 13.12, ["Fly|Ride"] = 32.82, ["Neon"] = 9.14, ["Neon|Fly"] = 70.56, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 43.32, ["Mega"] = 61.69, ["Mega|Ride"] = 60.38, ["Mega|Fly|Ride"] = 145.69}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 2.1, ["Fly"] = 37.08, ["Ride"] = 16.05, ["Fly|Ride"] = 46.71, ["Neon"] = 23.56, ["Neon|Ride"] = 21.55, ["Neon|Fly|Ride"] = 98.98, ["Mega"] = 229.69, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 299.65}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 282.14, ["Ride"] = 328.13, ["Fly|Ride"] = 483.29, ["Neon|Ride"] = 1240.72, ["Mega|Fly|Ride"] = 7017.71}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 46.34, ["Neon"] = 7.91, ["Neon|Ride"] = 233.5, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 31.5, ["Mega|Ride"] = 156.37, ["Mega|Fly|Ride"] = 280.04}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 17.07, ["Fly|Ride"] = 45.94, ["Neon"] = 19.69, ["Neon|Ride"] = 36.74, ["Neon|Fly|Ride"] = 97.13, ["Mega"] = 191.66, ["Mega|Ride"] = 195.87, ["Mega|Fly|Ride"] = 257.87}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 10.49, ["Ride"] = 42.13, ["Neon"] = 103.59, ["Neon|Ride"] = 281.17, ["Neon|Fly|Ride"] = 562.19, ["Mega"] = 503.52, ["Mega|Ride"] = 388.5, ["Mega|Fly|Ride"] = 514.5}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 93.01, ["Fly"] = 280.09, ["Ride"] = 82.15, ["Fly|Ride"] = 106.23, ["Neon|Ride"] = 551.25, ["Neon|Fly|Ride"] = 490.09, ["Mega|Fly|Ride"] = 1682.33}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 14.44, ["Fly"] = 76.34, ["Ride"] = 22.61, ["Fly|Ride"] = 56.87, ["Neon"] = 85.32, ["Neon|Ride"] = 67.24, ["Neon|Fly|Ride"] = 152.78, ["Mega"] = 702.2, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 42.13, ["Fly|Ride"] = 104.25, ["Neon"] = 2.63, ["Neon|Fly|Ride"] = 141.08, ["Mega"] = 22.73, ["Mega|Ride"] = 56.75, ["Mega|Fly|Ride"] = 421.12}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Fly"] = 39.16, ["Ride"] = 15.75, ["Neon"] = 2.1, ["Neon|Fly"] = 31.54, ["Neon|Ride"] = 28.39, ["Neon|Fly|Ride"] = 69.18, ["Mega"] = 18.97, ["Mega|Fly"] = 86.36, ["Mega|Ride"] = 52.41, ["Mega|Fly|Ride"] = 106.82}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 4.88, ["Fly"] = 105.3, ["Ride"] = 45.81, ["Fly|Ride"] = 157.35, ["Neon"] = 13.12, ["Neon|Fly"] = 265.02, ["Neon|Ride"] = 55.05, ["Neon|Fly|Ride"] = 160.04, ["Mega"] = 117.37, ["Mega|Ride"] = 160.31, ["Mega|Fly|Ride"] = 232.62}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1233.75, ["Ride"] = 1443.75, ["Fly|Ride"] = 1259.97, ["Neon"] = 4143.13, ["Neon|Ride"] = 3933.03, ["Neon|Fly|Ride"] = 4053, ["Mega"] = 18107.46, ["Mega|Fly|Ride"] = 13125}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 472.5, ["Ride"] = 601.19, ["Fly|Ride"] = 577.4, ["Neon"] = 1556.14, ["Neon|Ride"] = 2036.54, ["Neon|Fly|Ride"] = 1973.93, ["Mega"] = 14001.37, ["Mega|Fly|Ride"] = 6295.22}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 261.18, ["Fly"] = 358, ["Ride"] = 346.12, ["Fly|Ride"] = 359.89, ["Neon"] = 656.25, ["Neon|Fly"] = 842.42, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 826.88, ["Mega|Fly|Ride"] = 2428.13}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 257.25, ["Fly"] = 413.1, ["Ride"] = 316.32, ["Fly|Ride"] = 384.98, ["Neon"] = 721.87, ["Neon|Ride"] = 777.81, ["Neon|Fly|Ride"] = 879.38, ["Mega|Ride"] = 3675, ["Mega|Fly|Ride"] = 3042.48}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 28.45, ["Ride"] = 15.69, ["Fly|Ride"] = 53.59, ["Neon"] = 5.1, ["Neon|Ride"] = 45.39, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 37.58, ["Mega|Ride"] = 112.87, ["Mega|Fly|Ride"] = 141.08}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 282.19, ["Ride"] = 328.13, ["Fly|Ride"] = 500.07, ["Neon"] = 927.61, ["Neon|Ride"] = 1033.03, ["Neon|Fly|Ride"] = 990.94, ["Mega"] = 3721.51, ["Mega|Ride"] = 3412.5, ["Mega|Fly|Ride"] = 3281.25}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 2.1, ["Fly"] = 183.75, ["Ride"] = 40.03, ["Neon"] = 7.85, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 254.63, ["Mega"] = 45.24, ["Mega|Ride"] = 129.84, ["Mega|Fly|Ride"] = 93.35}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 19.94, ["Ride"] = 30.86, ["Fly|Ride"] = 49.88, ["Neon"] = 7.66, ["Neon|Ride"] = 62.91, ["Neon|Fly|Ride"] = 120.03, ["Mega"] = 125.3, ["Mega|Ride"] = 132.66, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Neon"] = 3.72, ["Mega"] = 23.63, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 39.67, ["Ride"] = 67.4, ["Fly|Ride"] = 459.38, ["Neon"] = 78.22, ["Neon|Ride"] = 420, ["Mega"] = 2105.53, ["Mega|Ride"] = 897.75, ["Mega|Fly|Ride"] = 972.57}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 4.69, ["Fly"] = 65.61, ["Ride"] = 18.9, ["Neon"] = 20.93, ["Mega"] = 281.1, ["Mega|Ride"] = 317.94}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 45.94, ["Neon"] = 2.49, ["Neon|Fly"] = 45.29, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 140.63, ["Mega"] = 23.87, ["Mega|Fly"] = 101.53, ["Mega|Ride"] = 156.37, ["Mega|Fly|Ride"] = 389.72}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.1, ["Ride"] = 15.58, ["Fly|Ride"] = 51.53, ["Neon"] = 7.76, ["Neon|Fly"] = 90.04, ["Neon|Ride"] = 23.37, ["Neon|Fly|Ride"] = 82.67, ["Mega"] = 51.44, ["Mega|Fly"] = 198.37, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 147}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 3.87, ["Fly"] = 45.94, ["Ride"] = 30.55, ["Fly|Ride"] = 55.26, ["Neon"] = 28.35, ["Neon|Ride"] = 90.57, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 237.56, ["Mega|Fly|Ride"] = 1019.82}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 10.45, ["Ride"] = 27.01, ["Neon"] = 131.25, ["Mega"] = 466.73, ["Mega|Ride"] = 336.9, ["Mega|Fly|Ride"] = 521.13}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.1, ["Ride"] = 25.71, ["Fly|Ride"] = 87.94, ["Neon"] = 39.38, ["Neon|Fly|Ride"] = 700.08, ["Mega"] = 238.98, ["Mega|Ride"] = 491.66}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.05, ["Fly"] = 26.25, ["Ride"] = 17.49, ["Fly|Ride"] = 66.35, ["Neon"] = 3.54, ["Neon|Ride"] = 25.24, ["Mega"] = 39.38, ["Mega|Ride"] = 124.95, ["Mega|Fly|Ride"] = 315.84}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 96.5, ["Fly"] = 280.18, ["Ride"] = 191.63, ["Fly|Ride"] = 224.57, ["Neon"] = 854.15, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 798.74, ["Neon|Fly|Ride"] = 827.12, ["Mega"] = 8422.08, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 18.32, ["Ride"] = 15.78, ["Fly|Ride"] = 32.81, ["Neon"] = 2.1, ["Neon|Fly"] = 56.88, ["Neon|Ride"] = 24.64, ["Neon|Fly|Ride"] = 69.28, ["Mega"] = 28.44, ["Mega|Ride"] = 70.88, ["Mega|Fly|Ride"] = 97.13}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 8.08, ["Ride"] = 69.57, ["Fly|Ride"] = 94.5, ["Neon"] = 70.56, ["Neon|Ride"] = 148.28, ["Neon|Fly|Ride"] = 311.54, ["Mega"] = 315, ["Mega|Ride"] = 309.6, ["Mega|Fly|Ride"] = 376.9}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 19.25, ["Ride"] = 118.13, ["Neon"] = 144.38, ["Neon|Ride"] = 310.55, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 697.47, ["Mega|Ride"] = 696.97, ["Mega|Fly|Ride"] = 814.86}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 156.19, ["Fly"] = 251.2, ["Ride"] = 209.6, ["Fly|Ride"] = 293.29, ["Neon"] = 716.63, ["Neon|Ride"] = 702.38, ["Neon|Fly|Ride"] = 866.25, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 3186.71}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 15.41, ["Neon"] = 95.73, ["Mega"] = 327.48, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 702.2}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 15.74, ["Ride"] = 54.66, ["Fly|Ride"] = 630.7, ["Neon"] = 165.2, ["Neon|Ride"] = 631.82, ["Neon|Fly|Ride"] = 842.22, ["Mega"] = 644.31, ["Mega|Ride"] = 630.61, ["Mega|Fly|Ride"] = 1894.97}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 1147.82, ["Fly"] = 1404.56, ["Ride"] = 1022.44, ["Fly|Ride"] = 1164.19, ["Neon|Ride"] = 3932.07, ["Neon|Fly|Ride"] = 4397.72, ["Mega|Fly|Ride"] = 16423.04}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 5.52, ["Fly"] = 43.32, ["Ride"] = 21.6, ["Fly|Ride"] = 62.68, ["Neon"] = 39.35, ["Neon|Fly"] = 111.57, ["Neon|Ride"] = 78.02, ["Neon|Fly|Ride"] = 65.62, ["Mega"] = 209.35, ["Mega|Fly"] = 562.19, ["Mega|Ride"] = 267.62, ["Mega|Fly|Ride"] = 416.73}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 4.61, ["Fly"] = 52.5, ["Ride"] = 38.8, ["Neon"] = 38.07, ["Neon|Ride"] = 166.01, ["Neon|Fly|Ride"] = 144.74, ["Mega"] = 212.63, ["Mega|Ride"] = 217.88, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 91.63, ["Neon"] = 10.43, ["Neon|Ride"] = 43.34, ["Neon|Fly|Ride"] = 311.54, ["Mega"] = 136.5, ["Mega|Ride"] = 190.32, ["Mega|Fly|Ride"] = 562.19}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 10.91, ["Ride"] = 36.72, ["Fly|Ride"] = 50.27, ["Neon"] = 43.73, ["Neon|Ride"] = 95.7, ["Neon|Fly|Ride"] = 127.02, ["Mega"] = 341.16, ["Mega|Ride"] = 332.07, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 2.1, ["Fly"] = 20.02, ["Ride"] = 13.18, ["Fly|Ride"] = 41.25, ["Neon"] = 15.81, ["Neon|Ride"] = 45.52, ["Neon|Fly|Ride"] = 54.66, ["Mega"] = 280.05, ["Mega|Ride"] = 141.08, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Ride"] = 12.48, ["Neon"] = 6.66, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 61.08, ["Neon|Fly|Ride"] = 140.44, ["Mega"] = 111.5, ["Mega|Ride"] = 154.88, ["Mega|Fly|Ride"] = 140.83}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 188.9, ["Ride"] = 183.75, ["Fly|Ride"] = 478.03, ["Neon|Fly"] = 721.88, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 1400.16, ["Mega|Fly|Ride"] = 3337.26}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Ride"] = 27.2, ["Neon"] = 4.14, ["Neon|Fly"] = 78.23, ["Neon|Ride"] = 37, ["Neon|Fly|Ride"] = 124.24, ["Mega"] = 83.12, ["Mega|Ride"] = 129.5, ["Mega|Fly|Ride"] = 232.32}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 3.73, ["Fly"] = 408.19, ["Neon"] = 16.57, ["Mega"] = 210.56, ["Mega|Ride"] = 980.64}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 2.1, ["Fly"] = 81.66, ["Ride"] = 35.81, ["Neon"] = 8.08, ["Neon|Ride"] = 46.6, ["Neon|Fly|Ride"] = 203.03, ["Mega"] = 97.13, ["Mega|Ride"] = 222.48, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 111.57, ["Fly"] = 262.5, ["Ride"] = 145.69, ["Fly|Ride"] = 420.4, ["Neon"] = 393.75, ["Neon|Ride"] = 414.75, ["Neon|Fly|Ride"] = 562.19, ["Mega"] = 1894.97, ["Mega|Ride"] = 1718.11, ["Mega|Fly|Ride"] = 1620.61}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 19.38, ["Ride"] = 25.18, ["Fly|Ride"] = 109.52, ["Neon"] = 141.1, ["Neon|Fly"] = 233.5, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 525, ["Mega|Ride"] = 524.99, ["Mega|Fly|Ride"] = 660.09}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 12.37, ["Ride"] = 39.38, ["Neon"] = 110.96, ["Neon|Ride"] = 140.63, ["Neon|Fly|Ride"] = 156.82, ["Mega"] = 671.55, ["Mega|Ride"] = 529.73, ["Mega|Fly|Ride"] = 458.47}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 31.54, ["Neon"] = 3.93, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 21.27, ["Mega"] = 31.44, ["Mega|Ride"] = 74.82, ["Mega|Fly|Ride"] = 210.56}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 62.2, ["Fly"] = 91.88, ["Ride"] = 81.63, ["Fly|Ride"] = 170.19, ["Neon"] = 381.72, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 249.27, ["Neon|Fly|Ride"] = 262.49, ["Mega|Fly|Ride"] = 904.32}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 20.56, ["Neon"] = 6.57, ["Neon|Ride"] = 36.87, ["Neon|Fly|Ride"] = 588, ["Mega"] = 60.88, ["Mega|Ride"] = 46.69}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 12.9, ["Fly"] = 140.38, ["Ride"] = 29.71, ["Fly|Ride"] = 105.82, ["Neon"] = 70.43, ["Neon|Ride"] = 48.35, ["Neon|Fly|Ride"] = 120.03, ["Mega"] = 380.63, ["Mega|Ride"] = 393.74, ["Mega|Fly|Ride"] = 442.22}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 35.75, ["Ride"] = 51.65, ["Fly|Ride"] = 140.44, ["Neon"] = 238.24, ["Neon|Ride"] = 144.47, ["Neon|Fly|Ride"] = 364.92, ["Mega"] = 842.22, ["Mega|Ride"] = 1219.12, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 15.7, ["Fly|Ride"] = 47.25, ["Neon"] = 2.1, ["Neon|Fly"] = 27.72, ["Neon|Ride"] = 18.8, ["Neon|Fly|Ride"] = 38.07, ["Mega"] = 11.82, ["Mega|Fly"] = 46.34, ["Mega|Ride"] = 36.86, ["Mega|Fly|Ride"] = 51.19}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 3.51, ["Fly"] = 18.97, ["Ride"] = 29.27, ["Fly|Ride"] = 98.65, ["Neon"] = 13.99, ["Neon|Ride"] = 56.6, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 218.21, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 501.8}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 7.33, ["Ride"] = 39.38, ["Neon"] = 101.58, ["Neon|Ride"] = 109.77, ["Neon|Fly|Ride"] = 623.07, ["Mega"] = 698.15, ["Mega|Ride"] = 536.55, ["Mega|Fly|Ride"] = 628.69}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 23.09, ["Neon"] = 2.63, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 14.42, ["Mega|Ride"] = 93.36, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 2.1, ["Fly"] = 210, ["Ride"] = 27.29, ["Fly|Ride"] = 98.44, ["Neon"] = 40.69, ["Neon|Ride"] = 91.63, ["Neon|Fly|Ride"] = 155.82, ["Mega"] = 631.66, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 420.07}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 14.12, ["Fly"] = 42.13, ["Ride"] = 23.37, ["Fly|Ride"] = 46.71, ["Neon"] = 112.22, ["Neon|Fly|Ride"] = 328.13, ["Mega|Fly|Ride"] = 631.66}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 2.1, ["Ride"] = 23.23, ["Neon"] = 19.63, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 200.82, ["Mega"] = 150.93, ["Mega|Ride"] = 247.42, ["Mega|Fly|Ride"] = 276.89}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 9.96, ["Fly"] = 2105.79, ["Ride"] = 70.33, ["Fly|Ride"] = 108.47, ["Neon"] = 78.75, ["Neon|Ride"] = 209.9, ["Neon|Fly|Ride"] = 6222.45, ["Mega"] = 288.73, ["Mega|Ride"] = 421.12, ["Mega|Fly|Ride"] = 562.19}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Ride"] = 23.68, ["Fly|Ride"] = 126.47, ["Neon"] = 6.55, ["Neon|Ride"] = 39.38, ["Mega"] = 157.5, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 408.19, ["Mega|Fly|Ride"] = 288.74}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Neon"] = 3.56, ["Neon|Ride"] = 32.66, ["Mega"] = 18.31, ["Mega|Ride"] = 126.35}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 19.56}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 30.11, ["Fly"] = 77.93, ["Ride"] = 62.93, ["Fly|Ride"] = 88.71, ["Neon"] = 165.78, ["Neon|Ride"] = 281.17, ["Neon|Fly|Ride"] = 526.39, ["Mega|Ride"] = 981.19, ["Mega|Fly|Ride"] = 795.54}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 140.6, ["Neon"] = 2.63, ["Mega"] = 21.07, ["Mega|Ride"] = 77.79, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 587.29, ["Ride"] = 656.25, ["Fly|Ride"] = 630.58, ["Neon"] = 4211.57, ["Neon|Ride"] = 2499.88, ["Neon|Fly|Ride"] = 2667.71, ["Mega"] = 16844.15, ["Mega|Fly|Ride"] = 6312.36}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 40.69, ["Fly|Ride"] = 54.88, ["Neon"] = 30.19, ["Neon|Ride"] = 98.65, ["Neon|Fly|Ride"] = 562.19, ["Mega|Fly|Ride"] = 335.56}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 3.03, ["Fly"] = 91.88, ["Ride"] = 16.59, ["Fly|Ride"] = 36.2, ["Neon"] = 28.35, ["Neon|Ride"] = 35.47, ["Neon|Fly|Ride"] = 87.94, ["Mega"] = 140.63, ["Mega|Ride"] = 156.37, ["Mega|Fly|Ride"] = 251.63}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 11.68, ["Ride"] = 76.13, ["Fly|Ride"] = 106.32, ["Neon"] = 93.22, ["Neon|Ride"] = 141.11, ["Neon|Fly|Ride"] = 141.08, ["Mega"] = 393.75, ["Mega|Ride"] = 463.23, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 3.13, ["Fly"] = 49.5, ["Ride"] = 31.5, ["Fly|Ride"] = 393.75, ["Neon"] = 140.59, ["Mega"] = 291.76, ["Mega|Ride"] = 386.22, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 13.02, ["Ride"] = 60.38, ["Fly|Ride"] = 157.5, ["Neon"] = 52.76, ["Neon|Fly"] = 189.56, ["Neon|Ride"] = 159.13, ["Neon|Fly|Ride"] = 350.44, ["Mega"] = 419.01, ["Mega|Ride"] = 436.91, ["Mega|Fly|Ride"] = 533.76}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 5.25, ["Fly"] = 105, ["Ride"] = 28.35, ["Fly|Ride"] = 131.25, ["Neon"] = 14.23, ["Neon|Ride"] = 78.56, ["Neon|Fly|Ride"] = 186.71, ["Mega"] = 156.37, ["Mega|Fly"] = 486.39, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 294}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.05, ["Fly"] = 42.13, ["Ride"] = 17.07, ["Fly|Ride"] = 75.83, ["Neon"] = 2.1, ["Neon|Fly"] = 41.99, ["Neon|Ride"] = 24.82, ["Neon|Fly|Ride"] = 60.1, ["Mega"] = 15.67, ["Mega|Fly"] = 78.2, ["Mega|Ride"] = 36.43, ["Mega|Fly|Ride"] = 65.63}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 5.24, ["Ride"] = 39.38, ["Fly|Ride"] = 56.87, ["Neon"] = 42.13, ["Neon|Fly"] = 389.93, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 129.5, ["Mega|Ride"] = 101.07, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 272.29, ["Fly"] = 262.49, ["Ride"] = 295.39, ["Fly|Ride"] = 309.95, ["Neon"] = 1378.13, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1347.54, ["Mega"] = 5618.06, ["Mega|Fly|Ride"] = 3937.5}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 56.9, ["Ride"] = 166.68, ["Fly|Ride"] = 155.84, ["Neon"] = 336.94, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 590.63, ["Mega"] = 4211.04, ["Mega|Ride"] = 1959.2, ["Mega|Fly|Ride"] = 1679.18}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 28.45, ["Ride"] = 24.94, ["Fly|Ride"] = 38.55, ["Neon"] = 12.53, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 23.37, ["Neon|Fly|Ride"] = 53.45, ["Mega"] = 63.02, ["Mega|Fly"] = 209.51, ["Mega|Ride"] = 91.61, ["Mega|Fly|Ride"] = 155.35}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 16.79, ["Ride"] = 14.76, ["Fly|Ride"] = 26.25, ["Neon"] = 6.33, ["Neon|Fly"] = 28.39, ["Neon|Ride"] = 16.79, ["Neon|Fly|Ride"] = 39.35, ["Mega"] = 101.08, ["Mega|Ride"] = 98.98, ["Mega|Fly|Ride"] = 137.55}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.61, ["Ride"] = 18.9, ["Fly|Ride"] = 98.44, ["Neon"] = 13.13, ["Neon|Fly|Ride"] = 210.56, ["Mega"] = 131.25}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 217.88, ["Fly"] = 466.77, ["Ride"] = 255.94, ["Fly|Ride"] = 401.79, ["Neon"] = 984.38, ["Neon|Ride"] = 1131.79, ["Neon|Fly|Ride"] = 1402.01, ["Mega|Ride"] = 8422.08, ["Mega|Fly|Ride"] = 3223.34}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.63, ["Fly"] = 21.04, ["Ride"] = 12.63, ["Fly|Ride"] = 32.75, ["Neon"] = 15.74, ["Neon|Fly"] = 156.45, ["Neon|Ride"] = 21.08, ["Neon|Fly|Ride"] = 75.15, ["Mega"] = 155.82, ["Mega|Ride"] = 125.3, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 3.28, ["Ride"] = 19.26, ["Fly|Ride"] = 210.59, ["Neon"] = 13.12, ["Neon|Ride"] = 421.22, ["Neon|Fly|Ride"] = 225.3, ["Mega"] = 92.17, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 348.81}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 78.22, ["Neon"] = 4.36, ["Neon|Ride"] = 37.37, ["Mega"] = 32.65, ["Mega|Ride"] = 93.13}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 10.17, ["Fly"] = 54.74, ["Ride"] = 17.98, ["Fly|Ride"] = 44.13, ["Neon"] = 146.1, ["Neon|Ride"] = 87.36, ["Neon|Fly|Ride"] = 91.87, ["Mega"] = 577.57, ["Mega|Ride"] = 501.38, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 33.11, ["Ride"] = 72.17, ["Fly|Ride"] = 198.56, ["Neon"] = 114.19, ["Neon|Fly"] = 311.72, ["Neon|Ride"] = 149.49, ["Neon|Fly|Ride"] = 287.53, ["Mega"] = 477.75, ["Mega|Fly"] = 2210.81, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 13.79, ["Fly"] = 65.63, ["Ride"] = 33.5, ["Fly|Ride"] = 77.78, ["Neon"] = 125.95, ["Neon|Ride"] = 174.82, ["Neon|Fly|Ride"] = 219.19, ["Mega|Ride"] = 783.12, ["Mega|Fly|Ride"] = 631.66}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.05, ["Fly"] = 17.69, ["Ride"] = 71.53, ["Fly|Ride"] = 29.98, ["Neon"] = 2.1, ["Neon|Fly"] = 30.19, ["Neon|Ride"] = 19.94, ["Neon|Fly|Ride"] = 56.86, ["Mega"] = 15.63, ["Mega|Fly"] = 48.44, ["Mega|Ride"] = 45.94, ["Mega|Fly|Ride"] = 105.21}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 189.98, ["Fly"] = 236.25, ["Ride"] = 204.63, ["Fly|Ride"] = 301.88, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 1109.61, ["Mega|Fly|Ride"] = 3412.5}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 5.99, ["Fly"] = 61.62, ["Ride"] = 45.94, ["Fly|Ride"] = 112.67, ["Neon"] = 118.08, ["Neon|Ride"] = 116.76, ["Mega"] = 485.63, ["Mega|Ride"] = 448.49, ["Mega|Fly|Ride"] = 361.11}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.05, ["Ride"] = 28.39, ["Fly|Ride"] = 59.07, ["Neon"] = 3.92, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 61.68, ["Mega|Fly"] = 111.57, ["Mega|Ride"] = 67.38, ["Mega|Fly|Ride"] = 265.31}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Ride"] = 17.07, ["Neon"] = 2.1, ["Neon|Fly"] = 31.54, ["Neon|Ride"] = 17.2, ["Neon|Fly|Ride"] = 119.73, ["Mega"] = 17.26, ["Mega|Fly"] = 137.93, ["Mega|Ride"] = 45.28, ["Mega|Fly|Ride"] = 108.94}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Ride"] = 22.79, ["Fly|Ride"] = 141.1, ["Neon"] = 7.39, ["Neon|Fly|Ride"] = 49.88, ["Mega"] = 116.93, ["Mega|Ride"] = 116.76, ["Mega|Fly|Ride"] = 209.51}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 9.96, ["Fly"] = 32.27, ["Ride"] = 23.63, ["Fly|Ride"] = 46.52, ["Neon"] = 44.49, ["Neon|Ride"] = 56.74, ["Neon|Fly|Ride"] = 140.78, ["Mega"] = 450.6, ["Mega|Ride"] = 338.39, ["Mega|Fly|Ride"] = 410.95}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 9.22, ["Ride"] = 39.38, ["Neon"] = 21.07, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 210, ["Mega|Ride"] = 354.38, ["Mega|Fly|Ride"] = 356.9}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.05, ["Ride"] = 141.1, ["Neon"] = 3.83, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 14.44, ["Mega|Ride"] = 27.6, ["Mega|Fly|Ride"] = 237.96}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 6.09, ["Ride"] = 18.54, ["Fly|Ride"] = 131.25, ["Neon"] = 13.96, ["Neon|Fly"] = 102.92, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 119.68, ["Mega"] = 61.16, ["Mega|Ride"] = 263.21, ["Mega|Fly|Ride"] = 136.96}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 6.3, ["Neon|Ride"] = 91.86, ["Mega"] = 26.54, ["Mega|Ride"] = 56.67, ["Mega|Fly|Ride"] = 615.9}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.05, ["Fly"] = 40.05, ["Ride"] = 15.74, ["Fly|Ride"] = 118.13, ["Neon"] = 3.34, ["Neon|Ride"] = 28.5, ["Neon|Fly|Ride"] = 116.52, ["Mega"] = 56.44, ["Mega|Ride"] = 88.1, ["Mega|Fly|Ride"] = 195.8}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 1181.25, ["Ride"] = 1032.94, ["Fly|Ride"] = 1284.04, ["Neon|Fly|Ride"] = 4484.48, ["Mega|Fly|Ride"] = 13846.19}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 13.71, ["Fly|Ride"] = 42.13, ["Neon"] = 11.78, ["Neon|Fly"] = 28.88, ["Neon|Ride"] = 124.68, ["Neon|Fly|Ride"] = 102.85, ["Mega|Fly|Ride"] = 149.63}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.1, ["Ride"] = 21.07, ["Fly|Ride"] = 59.07, ["Neon"] = 5.02, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 141.08, ["Mega"] = 49.41, ["Mega|Ride"] = 89.24, ["Mega|Fly|Ride"] = 220.69}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 6.48, ["Fly"] = 23.63, ["Ride"] = 17.07, ["Fly|Ride"] = 43.6, ["Neon"] = 35.44, ["Neon|Ride"] = 30.51, ["Neon|Fly|Ride"] = 104.95, ["Mega|Ride"] = 832.13, ["Mega|Fly|Ride"] = 353.07}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 41, ["Ride"] = 10.47, ["Fly|Ride"] = 32.66, ["Neon"] = 3.93, ["Neon|Fly"] = 83.98, ["Neon|Ride"] = 18.63, ["Neon|Fly|Ride"] = 62.98, ["Mega"] = 43.78, ["Mega|Ride"] = 86.36, ["Mega|Fly|Ride"] = 111.72}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 54.86, ["Ride"] = 141.1, ["Fly|Ride"] = 140.1, ["Neon"] = 297.67, ["Neon|Ride"] = 338.63, ["Mega"] = 769.13, ["Mega|Ride"] = 980.18, ["Mega|Fly|Ride"] = 1051.72}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Fly"] = 28.45, ["Ride"] = 22.32, ["Fly|Ride"] = 62.91, ["Neon"] = 4.67, ["Neon|Ride"] = 27.78, ["Neon|Fly|Ride"] = 109.7, ["Mega"] = 79.22, ["Mega|Ride"] = 108.66, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 73.5, ["Ride"] = 20.08, ["Fly|Ride"] = 65.63, ["Neon"] = 8.02, ["Neon|Fly"] = 147.44, ["Neon|Ride"] = 34.5, ["Neon|Fly|Ride"] = 140.78, ["Mega"] = 131.23, ["Mega|Ride"] = 293.73, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly|Ride"] = 52.5, ["Neon"] = 18.69, ["Neon|Fly"] = 63.06, ["Mega"] = 112.66}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 2593.49, ["Ride"] = 15.1, ["Fly|Ride"] = 41.08, ["Neon"] = 2.1, ["Neon|Ride"] = 19.81, ["Neon|Fly|Ride"] = 84.24, ["Mega"] = 36.75, ["Mega|Fly"] = 108.94, ["Mega|Ride"] = 77.91, ["Mega|Fly|Ride"] = 131.24}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 13.26, ["Fly"] = 35.68, ["Ride"] = 16.83, ["Fly|Ride"] = 26.77, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 105.29, ["Mega"] = 842.22, ["Mega|Ride"] = 521.13, ["Mega|Fly|Ride"] = 454.5}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 689.06, ["Ride"] = 679.88, ["Fly|Ride"] = 786.19, ["Neon"] = 2015.99, ["Neon|Ride"] = 1831.99, ["Neon|Fly|Ride"] = 1895.25, ["Mega"] = 7018.76, ["Mega|Ride"] = 7720.95, ["Mega|Fly|Ride"] = 4961.34}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Ride"] = 19.14, ["Fly|Ride"] = 28.45, ["Neon"] = 2.1, ["Neon|Fly"] = 28.35, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 20.47, ["Mega|Ride"] = 57.88, ["Mega|Fly|Ride"] = 120.88}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 5.8, ["Ride"] = 38.66, ["Fly|Ride"] = 116.82, ["Neon"] = 39.38, ["Neon|Ride"] = 125.99, ["Neon|Fly|Ride"] = 336.9, ["Mega"] = 157.5, ["Mega|Ride"] = 268.37, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 80.89, ["Fly"] = 144.38, ["Ride"] = 82.67, ["Fly|Ride"] = 141.1, ["Neon"] = 505.4, ["Neon|Ride"] = 533.76, ["Neon|Fly|Ride"] = 525.07, ["Mega"] = 2956.64, ["Mega|Fly|Ride"] = 3033.19}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 28.35, ["Ride"] = 59.07, ["Fly|Ride"] = 236.25, ["Neon"] = 156.43, ["Neon|Ride"] = 104.95, ["Mega"] = 736.95, ["Mega|Ride"] = 656.94, ["Mega|Fly|Ride"] = 682.2}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 8.22, ["Ride"] = 36.74, ["Fly|Ride"] = 210.59, ["Neon"] = 99.53, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 237.93, ["Mega"] = 257.78, ["Mega|Ride"] = 436.07, ["Mega|Fly|Ride"] = 475.86}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 25.71, ["Ride"] = 110.1, ["Neon"] = 56.75, ["Neon|Ride"] = 358.42, ["Mega"] = 281.1, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 377.95}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 16.33, ["Ride"] = 39.38, ["Neon"] = 164.83, ["Neon|Ride"] = 315.92, ["Neon|Fly|Ride"] = 718.01, ["Mega"] = 714.56, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 771.1}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 5.01}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 3.13, ["Ride"] = 56.87, ["Fly|Ride"] = 39.38, ["Neon"] = 25.92, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 77.95, ["Neon|Fly|Ride"] = 141.08, ["Mega"] = 206.93, ["Mega|Ride"] = 216.57, ["Mega|Fly|Ride"] = 237.77}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.18, ["Ride"] = 96.93, ["Neon"] = 18.57, ["Mega"] = 367.5, ["Mega|Fly|Ride"] = 947.5}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 41.99, ["Fly"] = 418.72, ["Ride"] = 66.93, ["Fly|Ride"] = 73.36, ["Neon"] = 293.86, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 354.38, ["Mega|Ride"] = 628.69, ["Mega|Fly|Ride"] = 654.81}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 2.72, ["Fly"] = 18.47, ["Ride"] = 13.95, ["Fly|Ride"] = 23.63, ["Neon"] = 19.67, ["Neon|Fly"] = 41.91, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 37.68, ["Mega"] = 311.54, ["Mega|Ride"] = 194.25, ["Mega|Fly|Ride"] = 262.81}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 4.56, ["Ride"] = 18.4, ["Fly|Ride"] = 83.94, ["Neon"] = 14.3, ["Neon|Ride"] = 51.43, ["Neon|Fly|Ride"] = 99.58, ["Mega"] = 120.74, ["Mega|Fly"] = 301.45, ["Mega|Ride"] = 155.82, ["Mega|Fly|Ride"] = 259.31}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 3.97, ["Mega"] = 37.43}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 29.08, ["Fly"] = 84.25, ["Ride"] = 39.61, ["Fly|Ride"] = 75.6, ["Neon"] = 152.2, ["Neon|Ride"] = 103.73, ["Neon|Fly|Ride"] = 504.29, ["Mega"] = 1089.79, ["Mega|Ride"] = 783.93, ["Mega|Fly|Ride"] = 695.63}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 7.83, ["Neon|Fly"] = 145.69, ["Neon|Fly|Ride"] = 141.08, ["Mega"] = 104.95, ["Mega|Ride"] = 208.11}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 7.28, ["Ride"] = 140.63, ["Neon"] = 63.06, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 294.78, ["Mega"] = 273.74, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 1089.79}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 23.21, ["Ride"] = 15.74, ["Fly|Ride"] = 61.69, ["Neon"] = 21, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 131.25, ["Mega|Ride"] = 196.23, ["Mega|Fly|Ride"] = 313.04}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 2.86, ["Fly"] = 52.5, ["Ride"] = 17.16, ["Neon|Ride"] = 126.37, ["Mega"] = 311.54, ["Mega|Ride"] = 140.63, ["Mega|Fly|Ride"] = 418.04}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 2.59, ["Ride"] = 129.31, ["Fly|Ride"] = 78.22, ["Neon"] = 11.06, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 281.1, ["Mega"] = 140.6, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 314.79}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 18.85, ["Fly"] = 118.13, ["Ride"] = 60.15, ["Neon"] = 172.38, ["Neon|Ride"] = 210.62, ["Neon|Fly|Ride"] = 273.74, ["Mega"] = 1089.79, ["Mega|Ride"] = 1263.32, ["Mega|Fly|Ride"] = 866.25}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 14.42, ["Ride"] = 174.01, ["Neon"] = 114.44, ["Neon|Fly|Ride"] = 389.72, ["Mega"] = 322.19, ["Mega|Ride"] = 233.37, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 9.56, ["Ride"] = 105, ["Neon"] = 63.98, ["Mega"] = 432.89, ["Mega|Ride"] = 1557.66, ["Mega|Fly|Ride"] = 1684.43}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 14.42, ["Ride"] = 105, ["Fly|Ride"] = 522.97, ["Neon"] = 52.5, ["Mega"] = 525, ["Mega|Ride"] = 562.19, ["Mega|Fly|Ride"] = 671.35}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 3.93, ["Neon"] = 23.28, ["Mega"] = 842.22, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 25.71, ["Ride"] = 22.09, ["Fly|Ride"] = 52.5, ["Neon"] = 6.34, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 36.87, ["Neon|Fly|Ride"] = 58.26, ["Mega"] = 32.8, ["Mega|Ride"] = 67.38, ["Mega|Fly|Ride"] = 186.8}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 3.93, ["Ride"] = 34.73, ["Fly|Ride"] = 105.3, ["Neon"] = 23.63, ["Neon|Fly"] = 466.98, ["Neon|Ride"] = 110.15, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 139.85, ["Mega|Ride"] = 266.44, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.05, ["Fly"] = 29.7, ["Ride"] = 15.74, ["Fly|Ride"] = 33.97, ["Neon"] = 5.6, ["Neon|Fly"] = 32.66, ["Neon|Ride"] = 25.3, ["Neon|Fly|Ride"] = 87.94, ["Mega"] = 39.38, ["Mega|Ride"] = 92.66, ["Mega|Fly|Ride"] = 124.86}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.63, ["Fly"] = 59.07, ["Ride"] = 27.4, ["Neon"] = 17.53, ["Neon|Ride"] = 93.41, ["Neon|Fly|Ride"] = 261.1, ["Mega"] = 130.05, ["Mega|Ride"] = 137.82, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 2.1, ["Ride"] = 27.57, ["Fly|Ride"] = 99.75, ["Neon"] = 25.88, ["Neon|Ride"] = 133.75, ["Mega"] = 421.12, ["Mega|Fly|Ride"] = 981.19}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 3.69, ["Fly"] = 30.77, ["Ride"] = 17.46, ["Fly|Ride"] = 75.83, ["Neon"] = 16.83, ["Neon|Ride"] = 35.25, ["Neon|Fly|Ride"] = 102.24, ["Mega"] = 252.04, ["Mega|Ride"] = 173.25, ["Mega|Fly|Ride"] = 277.94}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 33.72, ["Ride"] = 15.74, ["Fly|Ride"] = 59.89, ["Neon"] = 20.96, ["Neon|Ride"] = 82.9, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 166.59, ["Mega|Ride"] = 124.69, ["Mega|Fly|Ride"] = 491.66}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 5.25, ["Fly"] = 25.28, ["Ride"] = 67.14, ["Neon"] = 13.79, ["Neon|Fly"] = 56.9, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 460.89, ["Mega"] = 126.36, ["Mega|Ride"] = 98.44, ["Mega|Fly|Ride"] = 291.66}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 9.98, ["Ride"] = 39.75, ["Fly|Ride"] = 280.09, ["Neon"] = 47.56, ["Neon|Ride"] = 75.32, ["Neon|Fly|Ride"] = 442.22, ["Mega"] = 264.26, ["Mega|Fly"] = 983.29, ["Mega|Ride"] = 418.27, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 54, ["Fly"] = 198.39, ["Ride"] = 97.15, ["Fly|Ride"] = 91.88, ["Neon"] = 196.9, ["Neon|Ride"] = 278.24, ["Neon|Fly|Ride"] = 343.65, ["Mega"] = 2526.63, ["Mega|Ride"] = 997.5, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Ride"] = 19.92, ["Fly|Ride"] = 65.63, ["Neon"] = 2.1, ["Neon|Ride"] = 31.61, ["Mega"] = 26.23, ["Mega|Ride"] = 70.43, ["Mega|Fly|Ride"] = 94.5}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 4.94, ["Ride"] = 131.25, ["Neon"] = 49.51, ["Mega"] = 312.38, ["Mega|Ride"] = 407.44, ["Mega|Fly|Ride"] = 842.22}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 34.85, ["Ride"] = 115.5, ["Neon"] = 249.74, ["Neon|Ride"] = 315.92, ["Neon|Fly|Ride"] = 1052.77, ["Mega|Ride"] = 1081.19, ["Mega|Fly|Ride"] = 1246.49}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 2.61, ["Fly"] = 190.32, ["Ride"] = 23.5, ["Fly|Ride"] = 125.89, ["Neon"] = 30.12, ["Neon|Ride"] = 56.88, ["Neon|Fly|Ride"] = 141.08, ["Mega"] = 156.19, ["Mega|Ride"] = 179.7, ["Mega|Fly|Ride"] = 311.54}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 2.1, ["Fly"] = 157.5, ["Ride"] = 26.25, ["Fly|Ride"] = 83.74, ["Neon"] = 2.63, ["Neon|Ride"] = 26.17, ["Mega"] = 15.73, ["Mega|Fly"] = 105.29, ["Mega|Ride"] = 56.02, ["Mega|Fly|Ride"] = 122.33}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 15.43, ["Fly|Ride"] = 34.16, ["Neon"] = 12.86, ["Neon|Fly"] = 26.86, ["Neon|Ride"] = 34.85, ["Neon|Fly|Ride"] = 58.15, ["Mega"] = 175.82, ["Mega|Ride"] = 156.37, ["Mega|Fly|Ride"] = 203.44}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 15.73, ["Ride"] = 22.28, ["Fly|Ride"] = 25.28, ["Neon"] = 2.1, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 141.08, ["Mega|Ride"] = 69.55, ["Mega|Fly|Ride"] = 130.55}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 22.31, ["Fly|Ride"] = 91.63, ["Neon"] = 2.61, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 104.24, ["Mega"] = 31.5, ["Mega|Fly"] = 168, ["Mega|Ride"] = 61.69, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 26.25, ["Mega"] = 17.07, ["Mega|Ride"] = 98.98, ["Mega|Fly|Ride"] = 255.94}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 6.4, ["Ride"] = 157.5, ["Fly|Ride"] = 358, ["Neon"] = 16.41, ["Neon|Fly"] = 141.11, ["Neon|Ride"] = 131.15, ["Neon|Fly|Ride"] = 124.86, ["Mega"] = 213.94, ["Mega|Ride"] = 306.36, ["Mega|Fly|Ride"] = 718.6}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 4.68, ["Ride"] = 26.25, ["Fly|Ride"] = 84.25, ["Neon"] = 74.82, ["Neon|Ride"] = 88.68, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 370.59, ["Mega|Ride"] = 306.36, ["Mega|Fly|Ride"] = 364.88}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 4.99, ["Fly"] = 19.69, ["Ride"] = 15.75, ["Fly|Ride"] = 38.59, ["Neon"] = 40.62, ["Neon|Fly"] = 106.05, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 396.73, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 61.73, ["Ride"] = 98.65, ["Fly|Ride"] = 262.49, ["Neon"] = 538.13, ["Neon|Ride"] = 526.53, ["Mega"] = 3111.83, ["Mega|Ride"] = 2105.53}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 15.11, ["Ride"] = 42.04, ["Neon"] = 55.13, ["Neon|Fly"] = 126.37, ["Neon|Ride"] = 126.35, ["Mega"] = 607.04, ["Mega|Fly"] = 646.41, ["Mega|Ride"] = 579.1, ["Mega|Fly|Ride"] = 1029.67}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 21.07, ["Ride"] = 11.82, ["Fly|Ride"] = 26.75, ["Neon"] = 2.1, ["Neon|Ride"] = 17.03, ["Neon|Fly|Ride"] = 48.13, ["Mega"] = 31.6, ["Mega|Ride"] = 107.63, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 15.43, ["Ride"] = 13.69, ["Fly|Ride"] = 30.75, ["Neon"] = 2.1, ["Neon|Fly"] = 26.24, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 41.99, ["Mega"] = 39.32, ["Mega|Ride"] = 54.76, ["Mega|Fly|Ride"] = 99.21}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 367.5, ["Ride"] = 510.56, ["Fly|Ride"] = 524.99, ["Neon|Fly|Ride"] = 1996.32}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 7.43, ["Ride"] = 47.67, ["Fly|Ride"] = 72.19, ["Neon"] = 46.67, ["Neon|Ride"] = 94.5, ["Mega"] = 675.88, ["Mega|Fly|Ride"] = 1263.32}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 28.45, ["Ride"] = 17.07, ["Fly|Ride"] = 17.78, ["Neon"] = 3.51, ["Neon|Fly"] = 15.82, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 39.34, ["Mega"] = 80.14, ["Mega|Ride"] = 72.35, ["Mega|Fly|Ride"] = 94.61}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 46.23, ["Ride"] = 116.5, ["Fly|Ride"] = 167.29, ["Neon"] = 160.89, ["Neon|Ride"] = 301.87, ["Neon|Fly|Ride"] = 464.28, ["Mega"] = 881.53, ["Mega|Ride"] = 728.44, ["Mega|Fly|Ride"] = 987}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 21.04, ["Ride"] = 13.34, ["Fly|Ride"] = 41.55, ["Neon"] = 5.61, ["Neon|Fly"] = 69.51, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 82.25, ["Mega"] = 59.48, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 112.95, ["Mega|Fly|Ride"] = 165.38}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Ride"] = 37.13, ["Fly|Ride"] = 1312.5, ["Neon"] = 2.1, ["Neon|Ride"] = 23.72, ["Neon|Fly|Ride"] = 281.02, ["Mega"] = 16.69, ["Mega|Ride"] = 56.21, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 49.33, ["Fly"] = 164.07, ["Ride"] = 86.63, ["Neon"] = 174.56, ["Neon|Fly"] = 453.86, ["Neon|Ride"] = 280.11, ["Neon|Fly|Ride"] = 314.84, ["Mega"] = 657.57, ["Mega|Ride"] = 623.07, ["Mega|Fly|Ride"] = 730.42}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Ride"] = 42.13, ["Neon"] = 6.24, ["Neon|Ride"] = 54.77, ["Mega"] = 62.79, ["Mega|Ride"] = 93.36, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 39.14, ["Fly"] = 141.1, ["Ride"] = 56.44, ["Fly|Ride"] = 208.48, ["Neon"] = 140.44, ["Neon|Ride"] = 405.12, ["Neon|Fly|Ride"] = 249.38, ["Mega|Ride"] = 1682.33, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 3.04, ["Ride"] = 115.15, ["Neon"] = 48.64, ["Neon|Ride"] = 288.75, ["Mega"] = 164.07, ["Mega|Ride"] = 828.54, ["Mega|Fly|Ride"] = 411.38}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.49, ["Fly"] = 70.56, ["Ride"] = 18.97, ["Neon"] = 11.6, ["Neon|Ride"] = 171.84, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 141.08, ["Mega|Ride"] = 569.63, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 15.74, ["Ride"] = 32.82, ["Fly|Ride"] = 393.75, ["Neon"] = 421.17, ["Neon|Ride"] = 131.25, ["Mega|Ride"] = 2611.88, ["Mega|Fly|Ride"] = 1244.97}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.05, ["Fly"] = 104.73, ["Ride"] = 37.92, ["Neon"] = 4.65, ["Neon|Ride"] = 18.88, ["Neon|Fly|Ride"] = 138.98, ["Mega"] = 34.83, ["Mega|Fly"] = 158.61, ["Mega|Ride"] = 82.85, ["Mega|Fly|Ride"] = 274.98}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 26.78, ["Ride"] = 23.08, ["Fly|Ride"] = 72.17, ["Neon"] = 6.7, ["Neon|Fly"] = 41.88, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 225.3, ["Mega|Fly|Ride"] = 281.54}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 6.22, ["Ride"] = 35.44, ["Fly|Ride"] = 42.13, ["Neon"] = 97.13, ["Neon|Ride"] = 82.26, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 842.22, ["Mega|Ride"] = 454.13, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 23.36, ["Fly"] = 98.99, ["Ride"] = 44.92, ["Fly|Ride"] = 128, ["Neon"] = 148.1, ["Neon|Ride"] = 170.61, ["Neon|Fly|Ride"] = 277.71, ["Mega"] = 503.93, ["Mega|Ride"] = 662.82, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 31.6, ["Fly"] = 58.35, ["Ride"] = 39.63, ["Fly|Ride"] = 70.56, ["Neon"] = 98.51, ["Neon|Ride"] = 104.03, ["Neon|Fly|Ride"] = 231.94, ["Mega"] = 408.49, ["Mega|Ride"] = 400.07, ["Mega|Fly|Ride"] = 415.86}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 65.63, ["Fly"] = 196.88, ["Ride"] = 70.5, ["Fly|Ride"] = 209.89, ["Neon"] = 288.73, ["Neon|Fly"] = 439.53, ["Neon|Ride"] = 273, ["Neon|Fly|Ride"] = 503.99, ["Mega"] = 1260, ["Mega|Ride"] = 980.18, ["Mega|Fly|Ride"] = 1207.5}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 3.49, ["Ride"] = 23.62, ["Fly|Ride"] = 262.5, ["Neon"] = 15.74, ["Neon|Ride"] = 140.63, ["Neon|Fly|Ride"] = 314.82, ["Mega"] = 141.08, ["Mega|Ride"] = 155.79, ["Mega|Fly|Ride"] = 327.48}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 3.81, ["Ride"] = 26.33, ["Fly|Ride"] = 118.13, ["Neon"] = 30.19, ["Neon|Ride"] = 69.15, ["Neon|Fly|Ride"] = 141.08, ["Mega"] = 140.8, ["Mega|Ride"] = 131.25}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 8.27, ["Fly"] = 65.63, ["Ride"] = 35.69, ["Fly|Ride"] = 157.5, ["Neon"] = 38.32, ["Neon|Ride"] = 125.94, ["Mega"] = 477.96, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 445.82}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.05, ["Fly"] = 15.75, ["Ride"] = 15.74, ["Fly|Ride"] = 36.74, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 16.1, ["Neon|Fly|Ride"] = 41.9, ["Mega"] = 14.23, ["Mega|Fly"] = 78.2, ["Mega|Ride"] = 20.02, ["Mega|Fly|Ride"] = 98.98}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 52.49, ["Fly"] = 220.5, ["Ride"] = 155.84, ["Fly|Ride"] = 314.83, ["Neon"] = 224.21, ["Neon|Fly"] = 2387.2, ["Neon|Ride"] = 294, ["Mega"] = 835.9, ["Mega|Ride"] = 920.75, ["Mega|Fly|Ride"] = 885.94}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 15.81, ["Fly|Ride"] = 89.25, ["Neon"] = 6.54, ["Neon|Ride"] = 52.5, ["Mega"] = 84.84, ["Mega|Fly"] = 112.66, ["Mega|Ride"] = 93.36, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 28.38, ["Ride"] = 15.75, ["Fly|Ride"] = 63.18, ["Neon"] = 15.63, ["Neon|Ride"] = 52.67, ["Neon|Fly|Ride"] = 98.98, ["Mega|Ride"] = 421.12, ["Mega|Fly|Ride"] = 623.44}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 67.96, ["Fly"] = 210.59, ["Ride"] = 80.91, ["Fly|Ride"] = 112.67, ["Neon"] = 301.88, ["Neon|Ride"] = 314.45, ["Neon|Fly|Ride"] = 361.57, ["Mega"] = 958.13, ["Mega|Ride"] = 910.88, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 28.39, ["Neon"] = 2.78, ["Neon|Ride"] = 1399.95, ["Neon|Fly|Ride"] = 106.2, ["Mega"] = 36.57, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 11.73}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.05, ["Ride"] = 28.45, ["Fly|Ride"] = 209.4, ["Neon"] = 3.36, ["Neon|Ride"] = 23.59, ["Mega"] = 31.5, ["Mega|Ride"] = 76.49, ["Mega|Fly|Ride"] = 200.82}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 112.65, ["Ride"] = 170.63, ["Fly|Ride"] = 249.38, ["Neon"] = 366.19, ["Neon|Ride"] = 599.82, ["Neon|Fly|Ride"] = 735, ["Mega"] = 2667.71, ["Mega|Ride"] = 2819.31, ["Mega|Fly|Ride"] = 2493.75}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 3.75, ["Ride"] = 25.28, ["Neon"] = 17.53, ["Neon|Ride"] = 61.69, ["Mega"] = 217.6, ["Mega|Ride"] = 297.55, ["Mega|Fly|Ride"] = 249.33}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 210.59, ["Neon"] = 6.18, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 23.24, ["Mega|Ride"] = 77.91, ["Mega|Fly|Ride"] = 281.1}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 4.68, ["Ride"] = 30.85, ["Neon"] = 22.86, ["Neon|Ride"] = 125.32, ["Neon|Fly|Ride"] = 156.37, ["Mega"] = 390.58, ["Mega|Ride"] = 631.66, ["Mega|Fly|Ride"] = 621.77}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 12.85, ["Fly"] = 74.5, ["Ride"] = 24.68, ["Fly|Ride"] = 32.82, ["Neon"] = 82.6, ["Neon|Ride"] = 105.09, ["Neon|Fly|Ride"] = 271.63, ["Mega"] = 455.44, ["Mega|Ride"] = 617.98, ["Mega|Fly|Ride"] = 538.13}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 13.99, ["Ride"] = 33.97, ["Neon"] = 115.5, ["Neon|Ride"] = 167.68, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 562.19, ["Mega|Ride"] = 588, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 105.97, ["Fly"] = 201.57, ["Ride"] = 194.24, ["Fly|Ride"] = 193.6, ["Neon"] = 620.46, ["Neon|Ride"] = 548.63, ["Neon|Fly|Ride"] = 623.44, ["Mega|Fly|Ride"] = 2566.93}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 5.02, ["Fly"] = 16.79, ["Ride"] = 11.81, ["Fly|Ride"] = 23.63, ["Neon"] = 39.82, ["Neon|Ride"] = 46.47, ["Neon|Fly|Ride"] = 64.14, ["Mega"] = 421.12, ["Mega|Ride"] = 175.92, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 17.36, ["Neon"] = 13.37, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 146.09, ["Mega|Ride"] = 138.04, ["Mega|Fly|Ride"] = 238.24}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 6.34, ["Fly"] = 36.66, ["Ride"] = 53.76, ["Fly|Ride"] = 168.48, ["Neon"] = 80.07, ["Neon|Ride"] = 91.87, ["Mega"] = 1269.64, ["Mega|Fly|Ride"] = 1265.25}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 28.45, ["Ride"] = 59.74, ["Fly|Ride"] = 124.69, ["Neon"] = 131.25, ["Neon|Ride"] = 102.38, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 700.35, ["Mega|Fly"] = 983.29, ["Mega|Ride"] = 742.88, ["Mega|Fly|Ride"] = 875.03}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 13.5, ["Fly"] = 65.63, ["Ride"] = 81.84, ["Neon"] = 131.25, ["Neon|Ride"] = 105.08, ["Mega"] = 590.63, ["Mega|Ride"] = 660.09, ["Mega|Fly|Ride"] = 731.73}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 195.41, ["Ride"] = 367.5, ["Fly|Ride"] = 459.38, ["Neon"] = 1196.1, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1235.96, ["Mega|Ride"] = 3937.5, ["Mega|Fly|Ride"] = 5680.7}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 17.94, ["Fly"] = 141.1, ["Ride"] = 26.25, ["Fly|Ride"] = 69.21, ["Neon"] = 280.11, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 210.56, ["Mega"] = 1195.69, ["Mega|Ride"] = 520.25, ["Mega|Fly|Ride"] = 631.66}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 16.69, ["Ride"] = 14.65, ["Fly|Ride"] = 37.83, ["Neon"] = 2.1, ["Neon|Ride"] = 17.42, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 20.02, ["Mega|Fly"] = 98.44, ["Mega|Ride"] = 39.68, ["Mega|Fly|Ride"] = 108.42}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 2.86, ["Ride"] = 56.44, ["Neon"] = 8.82, ["Neon|Ride"] = 39.3, ["Mega"] = 83.19, ["Mega|Ride"] = 65.36, ["Mega|Fly|Ride"] = 460.04}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 3.5, ["Ride"] = 62.98, ["Neon"] = 11.95, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 1181.25, ["Mega"] = 84, ["Mega|Fly"] = 302.16, ["Mega|Ride"] = 310.57, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 333.67, ["Fly"] = 583.67, ["Ride"] = 403.78, ["Fly|Ride"] = 397.76, ["Neon"] = 1516.17, ["Neon|Ride"] = 1557.35, ["Neon|Fly|Ride"] = 1378.13, ["Mega|Fly|Ride"] = 5034.75}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.67, ["Ride"] = 16.79, ["Fly|Ride"] = 42.04, ["Neon"] = 33.37, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 52.5, ["Mega|Fly|Ride"] = 461.13}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 3.92, ["Fly"] = 18.85, ["Ride"] = 18.38, ["Fly|Ride"] = 59.07, ["Neon|Ride"] = 46.72, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 419.01, ["Mega|Ride"] = 702.2, ["Mega|Fly|Ride"] = 224.44}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 3.51, ["Fly"] = 26.25, ["Ride"] = 23.63, ["Fly|Ride"] = 104.68, ["Neon"] = 13.09, ["Neon|Fly"] = 70.56, ["Neon|Ride"] = 23.15, ["Neon|Fly|Ride"] = 104.93, ["Mega"] = 137.82, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 274.32}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 29.46, ["Fly"] = 42.13, ["Ride"] = 40.2, ["Fly|Ride"] = 70.56, ["Neon"] = 91.88, ["Neon|Fly|Ride"] = 147.39, ["Mega"] = 947.5, ["Mega|Ride"] = 840.12, ["Mega|Fly|Ride"] = 609.57}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 315, ["Ride"] = 62.99, ["Fly|Ride"] = 42, ["Neon"] = 14.15, ["Neon|Ride"] = 114.19, ["Neon|Fly|Ride"] = 210, ["Mega"] = 113.66, ["Mega|Fly"] = 262.5, ["Mega|Fly|Ride"] = 596.54}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 4.35, ["Fly"] = 23.13, ["Ride"] = 31.5, ["Fly|Ride"] = 91.88, ["Neon"] = 310.88, ["Neon|Ride"] = 132.69, ["Mega"] = 702.2, ["Mega|Ride"] = 322.16, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Fly"] = 28.45, ["Ride"] = 26.25, ["Fly|Ride"] = 61.08, ["Neon"] = 3.78, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 210.56, ["Mega"] = 51.35, ["Mega|Ride"] = 109.28, ["Mega|Fly|Ride"] = 232.2}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 9.91, ["Neon"] = 44.24, ["Mega"] = 182.62, ["Mega|Fly|Ride"] = 631.66}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 9.75, ["Ride"] = 70.56, ["Fly|Ride"] = 141.1, ["Neon"] = 136.07, ["Neon|Ride"] = 56.88, ["Mega"] = 280.32, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 9.19, ["Fly"] = 30.55, ["Ride"] = 13.15, ["Fly|Ride"] = 47.24, ["Neon"] = 60.38, ["Neon|Ride"] = 56.64, ["Neon|Fly|Ride"] = 105, ["Mega"] = 397.95, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 367.34}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 181.13, ["Fly"] = 159.13, ["Ride"] = 203.68, ["Fly|Ride"] = 206.31, ["Neon"] = 949.72, ["Neon|Ride"] = 977.22, ["Neon|Fly|Ride"] = 840.83, ["Mega|Fly|Ride"] = 3130.93}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Fly"] = 19.67, ["Ride"] = 14.44, ["Fly|Ride"] = 65.08, ["Neon"] = 28.45, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 138.02, ["Mega"] = 220.5, ["Mega|Ride"] = 347.72, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 22.98, ["Fly|Ride"] = 63.29, ["Neon"] = 17.3, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 124.69, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 410.82}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 21.25, ["Ride"] = 111.57, ["Fly|Ride"] = 210, ["Neon"] = 105, ["Neon|Ride"] = 250.83, ["Neon|Fly|Ride"] = 560.09, ["Mega"] = 401.63, ["Mega|Ride"] = 377.9, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 34.8, ["Fly"] = 126.36, ["Ride"] = 65.49, ["Fly|Ride"] = 109.36, ["Neon"] = 267.94, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 1607.58, ["Mega|Fly|Ride"] = 1220.63}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 10.5, ["Ride"] = 58.88, ["Fly|Ride"] = 315, ["Neon"] = 39.54, ["Neon|Ride"] = 63.24, ["Neon|Fly|Ride"] = 630.58, ["Mega"] = 219.54, ["Mega|Ride"] = 246, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 21.04, ["Fly|Ride"] = 33.6, ["Neon"] = 11.82, ["Mega"] = 70.55, ["Mega|Fly|Ride"] = 251.99}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 12.66, ["Fly"] = 42, ["Ride"] = 62.19, ["Fly|Ride"] = 46.71, ["Neon"] = 50.37, ["Neon|Fly"] = 104.27, ["Neon|Ride"] = 77.85, ["Neon|Fly|Ride"] = 421.12, ["Mega"] = 141.08, ["Mega|Ride"] = 276.94, ["Mega|Fly|Ride"] = 501.62}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 61.01, ["Fly"] = 140.84, ["Ride"] = 79.45, ["Fly|Ride"] = 262.5, ["Neon"] = 136.5, ["Neon|Ride"] = 246.75, ["Neon|Fly|Ride"] = 304.5, ["Mega"] = 446.25, ["Mega|Ride"] = 444.52, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.1, ["Neon"] = 3.91, ["Neon|Fly"] = 196.93, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 40.87, ["Mega|Fly"] = 98.44, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 9.79, ["Ride"] = 70.56, ["Neon"] = 49.88, ["Neon|Ride"] = 393.75, ["Mega"] = 266.43, ["Mega|Ride"] = 502.9, ["Mega|Fly|Ride"] = 488.5}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 885.2, ["Fly"] = 1206.99, ["Ride"] = 1010.63, ["Fly|Ride"] = 1023.64, ["Neon"] = 3361.81, ["Neon|Ride"] = 2802.95, ["Neon|Fly|Ride"] = 2802.95, ["Mega|Fly|Ride"] = 13533.23}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 16.21, ["Ride"] = 83.61, ["Neon"] = 143.64, ["Neon|Ride"] = 337.3, ["Neon|Fly|Ride"] = 413.44, ["Mega"] = 590.63, ["Mega|Ride"] = 524.95, ["Mega|Fly|Ride"] = 698.1}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.63, ["Fly"] = 48.27, ["Ride"] = 28.45, ["Fly|Ride"] = 210.16, ["Neon"] = 9.06, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 39.88, ["Neon|Fly|Ride"] = 104.97, ["Mega"] = 89.23, ["Mega|Ride"] = 65.92, ["Mega|Fly|Ride"] = 204.75}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 9.19, ["Ride"] = 131.25, ["Neon"] = 78.75, ["Mega"] = 386.22, ["Mega|Fly|Ride"] = 778.25}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.05, ["Ride"] = 18.98, ["Fly|Ride"] = 421.17, ["Neon"] = 2.1, ["Neon|Ride"] = 27.29, ["Neon|Fly|Ride"] = 109.7, ["Mega"] = 13.11, ["Mega|Ride"] = 27.56, ["Mega|Fly|Ride"] = 128.63}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 85.2, ["Ride"] = 105.82, ["Fly|Ride"] = 183.75, ["Neon"] = 288.75, ["Neon|Ride"] = 351.04, ["Neon|Fly|Ride"] = 451.5, ["Mega"] = 1251.92, ["Mega|Ride"] = 1113, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 3.23, ["Fly"] = 101.07, ["Ride"] = 13.13, ["Fly|Ride"] = 817.13, ["Neon"] = 35.43, ["Neon|Ride"] = 84, ["Mega"] = 129.5, ["Mega|Ride"] = 230.57, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2.05, ["Ride"] = 64.32, ["Neon"] = 15.75, ["Neon|Ride"] = 39.38, ["Mega"] = 170.59, ["Mega|Ride"] = 277.47, ["Mega|Fly|Ride"] = 386.54}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 37.27, ["Fly"] = 126, ["Ride"] = 45.2, ["Fly|Ride"] = 91.87, ["Neon"] = 99.12, ["Neon|Ride"] = 151.4, ["Neon|Fly|Ride"] = 301.12, ["Mega"] = 466.73, ["Mega|Ride"] = 527.1, ["Mega|Fly|Ride"] = 418.59}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 14.12, ["Fly"] = 183.75, ["Ride"] = 209.53, ["Fly|Ride"] = 131.25, ["Neon"] = 87.28, ["Neon|Fly"] = 179.82, ["Neon|Ride"] = 143.89, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 238.92, ["Mega|Ride"] = 419.01, ["Mega|Fly|Ride"] = 597.19}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 52.36, ["Ride"] = 281.14, ["Neon"] = 250.68, ["Neon|Ride"] = 618.14, ["Neon|Fly|Ride"] = 908.92, ["Mega"] = 1451.78, ["Mega|Ride"] = 1400.16, ["Mega|Fly|Ride"] = 1249.64}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 3.98, ["Ride"] = 84.25, ["Fly|Ride"] = 168.48, ["Neon"] = 18.1, ["Neon|Ride"] = 817.21, ["Neon|Fly|Ride"] = 90.85, ["Mega"] = 108.93, ["Mega|Ride"] = 164.09, ["Mega|Fly|Ride"] = 274.97}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 8.81, ["Fly"] = 196.88, ["Ride"] = 28.35, ["Fly|Ride"] = 64.32, ["Neon"] = 65.6, ["Neon|Ride"] = 61.98, ["Neon|Fly|Ride"] = 107.39, ["Mega"] = 354.37, ["Mega|Ride"] = 380.63, ["Mega|Fly|Ride"] = 464.28}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 144.37, ["Ride"] = 155.74, ["Fly|Ride"] = 231, ["Neon"] = 352.96, ["Neon|Ride"] = 345.81, ["Neon|Fly|Ride"] = 688.51, ["Mega"] = 2362.5, ["Mega|Ride"] = 2361.19, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.5, ["Fly"] = 26.25, ["Ride"] = 14.74, ["Fly|Ride"] = 41.78, ["Neon"] = 11.69, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 18.79, ["Neon|Fly|Ride"] = 62.99, ["Mega"] = 104.85, ["Mega|Ride"] = 136.5, ["Mega|Fly|Ride"] = 116.82}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 4.93, ["Fly"] = 42.13, ["Ride"] = 15.63, ["Fly|Ride"] = 29.3, ["Neon"] = 13.86, ["Neon|Ride"] = 41.99, ["Neon|Fly|Ride"] = 70.32, ["Mega"] = 220.5, ["Mega|Fly"] = 232.32, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 279.57}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.05, ["Ride"] = 19, ["Fly|Ride"] = 41.97, ["Neon"] = 2.1, ["Neon|Ride"] = 11.81, ["Neon|Fly|Ride"] = 46.64, ["Mega"] = 14.43, ["Mega|Ride"] = 22.46, ["Mega|Fly|Ride"] = 63.32}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 31.6, ["Neon"] = 3.82, ["Neon|Ride"] = 42.14, ["Mega"] = 19.93, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 156.37}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.1, ["Fly"] = 132.04, ["Ride"] = 26.17, ["Neon"] = 15.46, ["Neon|Ride"] = 28.45, ["Mega"] = 118.97, ["Mega|Ride"] = 131.25}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 44.63, ["Ride"] = 114.51, ["Neon"] = 257.99, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 630, ["Mega"] = 491.66, ["Mega|Fly|Ride"] = 520.94}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 3.4, ["Fly"] = 18.38, ["Ride"] = 11.34, ["Fly|Ride"] = 20.78, ["Neon"] = 12.58, ["Neon|Fly"] = 28.45, ["Neon|Ride"] = 20.97, ["Neon|Fly|Ride"] = 54.69, ["Mega"] = 126.36, ["Mega|Fly"] = 210.13, ["Mega|Ride"] = 152.25, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 2.56, ["Fly"] = 17.35, ["Ride"] = 13.13, ["Fly|Ride"] = 36.6, ["Neon"] = 6.36, ["Neon|Fly"] = 41.99, ["Neon|Ride"] = 16.69, ["Neon|Fly|Ride"] = 73.11, ["Mega"] = 134.93, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 186.38}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Fly"] = 25.28, ["Ride"] = 24.94, ["Fly|Ride"] = 46.52, ["Neon"] = 14.21, ["Neon|Fly"] = 62.09, ["Neon|Ride"] = 26.88, ["Neon|Fly|Ride"] = 57.94, ["Mega"] = 77.34, ["Mega|Fly"] = 408.19, ["Mega|Ride"] = 81.9, ["Mega|Fly|Ride"] = 241.5}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 6.56, ["Fly"] = 43.32, ["Ride"] = 131.25, ["Neon"] = 38.07, ["Neon|Ride"] = 112.3, ["Neon|Fly|Ride"] = 172.7, ["Mega"] = 204.25, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 355.85}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 3.93, ["Fly"] = 160.69, ["Neon"] = 89.57, ["Neon|Ride"] = 91.61, ["Neon|Fly|Ride"] = 728.44, ["Mega"] = 368.48, ["Mega|Ride"] = 412.13, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 3.24, ["Fly"] = 91.88, ["Ride"] = 20.98, ["Fly|Ride"] = 78.98, ["Neon"] = 16.16, ["Neon|Fly"] = 196.65, ["Neon|Ride"] = 60.02, ["Neon|Fly|Ride"] = 92.61, ["Mega"] = 141.08, ["Mega|Ride"] = 175.34, ["Mega|Fly|Ride"] = 284.82}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 20.69, ["Ride"] = 11.8, ["Fly|Ride"] = 52.5, ["Neon"] = 5.25, ["Neon|Fly"] = 86.41, ["Neon|Ride"] = 48.35, ["Neon|Fly|Ride"] = 70.88, ["Mega"] = 421.12, ["Mega|Ride"] = 133.71, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 150.94, ["Fly"] = 393.75, ["Ride"] = 231, ["Fly|Ride"] = 421.17, ["Neon"] = 532.28, ["Neon|Ride"] = 933.95, ["Neon|Fly|Ride"] = 892.5, ["Mega|Fly|Ride"] = 3661.88}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 3.62, ["Ride"] = 42, ["Neon"] = 15.74, ["Neon|Fly|Ride"] = 281.1, ["Mega"] = 140.84, ["Mega|Ride"] = 267.88, ["Mega|Fly|Ride"] = 702.2}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 26.25, ["Fly|Ride"] = 94.58, ["Neon"] = 14.32, ["Neon|Ride"] = 28.45, ["Neon|Fly|Ride"] = 124.59, ["Mega"] = 128.26, ["Mega|Fly"] = 366.38, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 295.61}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 2.76, ["Fly|Ride"] = 156.43, ["Neon"] = 37.8, ["Neon|Fly|Ride"] = 630, ["Mega"] = 415, ["Mega|Ride"] = 361.72, ["Mega|Fly|Ride"] = 421.12}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 26.17, ["Ride"] = 16.89, ["Fly|Ride"] = 38.59, ["Neon"] = 2.1, ["Neon|Fly"] = 20.93, ["Neon|Ride"] = 22.09, ["Neon|Fly|Ride"] = 42.03, ["Mega"] = 15.69, ["Mega|Ride"] = 35.81, ["Mega|Fly|Ride"] = 52.86}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.57, ["Fly"] = 38.06, ["Ride"] = 24.94, ["Fly|Ride"] = 84.25, ["Neon"] = 18.47, ["Neon|Ride"] = 23.55, ["Neon|Fly|Ride"] = 78.72, ["Mega"] = 198.02, ["Mega|Ride"] = 150.94, ["Mega|Fly|Ride"] = 188.72}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.1, ["Ride"] = 62.34, ["Neon"] = 8.38, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 93.19, ["Mega|Ride"] = 148.32, ["Mega|Fly|Ride"] = 450.19}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 75.08, ["Fly"] = 130.57, ["Ride"] = 90.04, ["Fly|Ride"] = 158.16, ["Neon"] = 334.84, ["Neon|Ride"] = 393.74, ["Neon|Fly|Ride"] = 408.19, ["Mega|Ride"] = 3510.96, ["Mega|Fly|Ride"] = 1704.78}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 3.92, ["Fly"] = 65.63, ["Ride"] = 24.92, ["Fly|Ride"] = 141.1, ["Neon"] = 13.12, ["Neon|Ride"] = 56.88, ["Neon|Fly|Ride"] = 311.54, ["Mega"] = 189.52, ["Mega|Fly|Ride"] = 263.21}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 56.87, ["Fly|Ride"] = 141.1, ["Neon"] = 9.35, ["Neon|Ride"] = 177.07, ["Neon|Fly|Ride"] = 523.89, ["Mega"] = 66.94, ["Mega|Ride"] = 84.24, ["Mega|Fly|Ride"] = 141.08}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 49.35, ["Fly"] = 179.79, ["Ride"] = 65.63, ["Fly|Ride"] = 144.38, ["Neon"] = 140.44, ["Neon|Ride"] = 194.2, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 557.82, ["Mega|Ride"] = 519.75, ["Mega|Fly|Ride"] = 700.75}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Ride"] = 21, ["Fly|Ride"] = 35.88, ["Neon"] = 2.1, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 14.58, ["Neon|Fly|Ride"] = 42.13, ["Mega"] = 15.2, ["Mega|Ride"] = 25.19, ["Mega|Fly|Ride"] = 44.5}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 2.61, ["Neon|Ride"] = 37.91, ["Neon|Fly|Ride"] = 141.08, ["Mega"] = 18.14, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 81.69, ["Mega|Fly|Ride"] = 162.79}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.05, ["Ride"] = 67.9, ["Neon"] = 4.59, ["Neon|Ride"] = 69.28, ["Neon|Fly|Ride"] = 141.08, ["Mega"] = 64.14, ["Mega|Ride"] = 127.89, ["Mega|Fly|Ride"] = 562.19}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 2.6, ["Fly"] = 77.91, ["Ride"] = 32.82, ["Fly|Ride"] = 98.81, ["Neon"] = 11.58, ["Neon|Fly"] = 37.37, ["Neon|Ride"] = 69.37, ["Neon|Fly|Ride"] = 166.69, ["Mega"] = 80.07, ["Mega|Fly"] = 187.69, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 245.18}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.05, ["Fly"] = 15.81, ["Ride"] = 11.82, ["Fly|Ride"] = 91.34, ["Neon"] = 2.1, ["Neon|Ride"] = 30.18, ["Neon|Fly|Ride"] = 30.07, ["Mega"] = 19.83, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 32.17, ["Mega|Fly|Ride"] = 121.09}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 11.5, ["Ride"] = 45.94, ["Neon"] = 59.83, ["Neon|Ride"] = 42.14, ["Neon|Fly|Ride"] = 176.54, ["Mega"] = 379.01, ["Mega|Ride"] = 419.01, ["Mega|Fly|Ride"] = 364.28}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 3806.25, ["Ride"] = 3938.82, ["Fly|Ride"] = 3500.44, ["Neon|Fly|Ride"] = 10500}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 28.29, ["Ride"] = 11.33, ["Fly|Ride"] = 43.32, ["Neon"] = 4.73, ["Neon|Fly"] = 56.42, ["Neon|Ride"] = 23, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 64.19, ["Mega|Ride"] = 69.5, ["Mega|Fly|Ride"] = 194.86}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 3.94, ["Ride"] = 26.25, ["Neon"] = 9.54, ["Neon|Ride"] = 31.61, ["Mega"] = 110.71, ["Mega|Ride"] = 413.59, ["Mega|Fly|Ride"] = 631.66}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 13.58, ["Ride"] = 21.25, ["Fly|Ride"] = 59.16, ["Neon"] = 42.05, ["Neon|Ride"] = 150.89, ["Neon|Fly|Ride"] = 267.41, ["Mega"] = 421.12, ["Mega|Ride"] = 452.72, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 23.45, ["Ride"] = 108.94, ["Fly|Ride"] = 141.1, ["Neon"] = 138.73, ["Neon|Fly|Ride"] = 421.12, ["Mega"] = 232.03, ["Mega|Ride"] = 620.82, ["Mega|Fly|Ride"] = 562.19}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 149.17, ["Fly"] = 210.59, ["Ride"] = 129.97, ["Fly|Ride"] = 186.96, ["Neon"] = 697.18, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 838.01, ["Mega"] = 6316.56, ["Mega|Ride"] = 3018.27, ["Mega|Fly|Ride"] = 3413.54}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 2.63, ["Ride"] = 26.25, ["Fly|Ride"] = 112.67, ["Neon"] = 18.36, ["Neon|Ride"] = 124.43, ["Neon|Fly|Ride"] = 105.29, ["Mega"] = 98.98, ["Mega|Ride"] = 186.71, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 14.1, ["Neon|Fly"] = 94.79, ["Neon|Ride"] = 34.13, ["Mega"] = 56.32, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 364.28}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Fly"] = 101.99, ["Ride"] = 70.43, ["Fly|Ride"] = 78.75, ["Neon"] = 7.24, ["Neon|Fly"] = 42.14, ["Neon|Ride"] = 39.53, ["Mega"] = 91.88, ["Mega|Ride"] = 125.95, ["Mega|Fly|Ride"] = 267.41}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 10.12, ["Neon"] = 323.26, ["Neon|Ride"] = 133.1, ["Mega"] = 376.69, ["Mega|Ride"] = 466.73, ["Mega|Fly|Ride"] = 618.85}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 69.78, ["Neon"] = 2.1, ["Neon|Ride"] = 42, ["Mega"] = 14.36, ["Mega|Ride"] = 168.46, ["Mega|Fly|Ride"] = 351.63}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 83.88, ["Fly"] = 249.04, ["Ride"] = 128.63, ["Fly|Ride"] = 167.13, ["Neon"] = 365.36, ["Neon|Fly"] = 604.45, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 272.77, ["Mega|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 1443.75}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 32.29, ["Neon"] = 5.15, ["Mega"] = 91.61, ["Mega|Ride"] = 122.07}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 43.15, ["Ride"] = 54.03, ["Fly|Ride"] = 157.5, ["Neon"] = 265.91, ["Neon|Ride"] = 414.94, ["Neon|Fly|Ride"] = 318.94, ["Mega"] = 2625, ["Mega|Ride"] = 2807.73, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 32.43, ["Ride"] = 21, ["Fly|Ride"] = 70.56, ["Neon"] = 4.45, ["Neon|Ride"] = 92.19, ["Mega"] = 42.13, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Fly"] = 281.14, ["Neon"] = 10.64, ["Mega"] = 100.9, ["Mega|Ride"] = 166.17, ["Mega|Fly|Ride"] = 284.81}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 6.64, ["Ride"] = 54.57, ["Fly|Ride"] = 157.5, ["Neon"] = 15.18, ["Neon|Ride"] = 70.56, ["Neon|Fly|Ride"] = 688.51, ["Mega"] = 141.08, ["Mega|Ride"] = 189, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 326.81, ["Fly"] = 545.13, ["Ride"] = 393.75, ["Fly|Ride"] = 413.44, ["Neon"] = 1018.4, ["Neon|Ride"] = 945, ["Neon|Fly|Ride"] = 1076.15, ["Mega"] = 3554.13, ["Mega|Ride"] = 2625, ["Mega|Fly|Ride"] = 2355.94}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 23.63, ["Fly"] = 65.63, ["Ride"] = 52.5, ["Fly|Ride"] = 77.91, ["Neon"] = 166.37, ["Neon|Fly"] = 311.72, ["Neon|Ride"] = 186.38, ["Neon|Fly|Ride"] = 280.23, ["Mega|Ride"] = 962.07, ["Mega|Fly|Ride"] = 842.22}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 19.95, ["Fly|Ride"] = 72.08, ["Neon"] = 4.14, ["Neon|Fly"] = 136.9, ["Neon|Ride"] = 23.97, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 42.13, ["Mega|Ride"] = 77.67, ["Mega|Fly|Ride"] = 266.6}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 5.86, ["Fly"] = 109.52, ["Ride"] = 20.56, ["Fly|Ride"] = 98.99, ["Neon"] = 18.47, ["Neon|Fly"] = 109.31, ["Neon|Ride"] = 78.66, ["Neon|Fly|Ride"] = 101.85, ["Mega"] = 198.19, ["Mega|Fly"] = 938.02, ["Mega|Ride"] = 270.84, ["Mega|Fly|Ride"] = 372.47}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 5.25, ["Ride"] = 25.45, ["Fly|Ride"] = 105.3, ["Neon"] = 105, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 137.93, ["Mega"] = 504.07, ["Mega|Ride"] = 310.57, ["Mega|Fly|Ride"] = 477.96}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 2.59, ["Neon"] = 6.8, ["Neon|Ride"] = 65.63, ["Mega"] = 47.35, ["Mega|Ride"] = 122.07}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.39, ["Fly"] = 86.63, ["Ride"] = 17.05, ["Fly|Ride"] = 65.63, ["Neon"] = 13.12, ["Neon|Ride"] = 41.99, ["Neon|Fly|Ride"] = 63.02, ["Mega"] = 544.9, ["Mega|Ride"] = 323.21}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 97.43, ["Ride"] = 101.28, ["Fly|Ride"] = 183.74, ["Neon"] = 494.87, ["Neon|Ride"] = 628.69, ["Neon|Fly|Ride"] = 625.35, ["Mega|Ride"] = 2421.36, ["Mega|Fly|Ride"] = 2186.63}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 18.61, ["Ride"] = 55.12, ["Fly|Ride"] = 144, ["Neon"] = 126.36, ["Neon|Ride"] = 281.17, ["Mega"] = 700.08, ["Mega|Ride"] = 709.57, ["Mega|Fly|Ride"] = 679.08}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2833.35, ["Fly"] = 3369.24, ["Ride"] = 2618.44, ["Fly|Ride"] = 2533.13, ["Neon"] = 12634.67, ["Neon|Fly|Ride"] = 6878.74, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 2.1, ["Fly"] = 65625, ["Ride"] = 22.32, ["Fly|Ride"] = 157.5, ["Neon"] = 6.55, ["Neon|Ride"] = 34.99, ["Mega"] = 91.88, ["Mega|Ride"] = 209.89, ["Mega|Fly|Ride"] = 422.63}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 8.12, ["Ride"] = 38.62, ["Fly|Ride"] = 281.14, ["Neon"] = 29.56, ["Neon|Ride"] = 101.82, ["Mega"] = 123.54, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 393.11}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 1049.79, ["Fly"] = 1237.35, ["Ride"] = 951.57, ["Fly|Ride"] = 1128.75, ["Neon"] = 4054.68, ["Neon|Ride"] = 3502.28, ["Neon|Fly|Ride"] = 3150, ["Mega|Ride"] = 11229.8, ["Mega|Fly|Ride"] = 11084.42}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 23.92, ["Ride"] = 78.22, ["Neon"] = 156.29, ["Mega"] = 653.02, ["Mega|Ride"] = 755.89, ["Mega|Fly|Ride"] = 769.13}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 2.33, ["Ride"] = 62.27, ["Fly|Ride"] = 56.87, ["Neon"] = 14.41, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 210.21, ["Mega|Ride"] = 348.48, ["Mega|Fly|Ride"] = 278.25}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 52.41, ["Ride"] = 13.13, ["Fly|Ride"] = 52.5, ["Neon"] = 3.91, ["Mega"] = 19.93, ["Mega|Ride"] = 68.25, ["Mega|Fly|Ride"] = 125.3}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 70.61, ["Ride"] = 156.19, ["Fly|Ride"] = 656.25, ["Neon"] = 315, ["Neon|Ride"] = 554.95, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 5250, ["Mega|Fly|Ride"] = 2526.63}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 2.37, ["Ride"] = 37.21, ["Neon"] = 14.25, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 168.46, ["Mega"] = 157.5, ["Mega|Ride"] = 179.17, ["Mega|Fly|Ride"] = 263.82}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 98.39, ["Ride"] = 210.59, ["Neon"] = 590.63, ["Mega"] = 2105.53}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 6.55, ["Fly"] = 105, ["Fly|Ride"] = 112.67, ["Neon"] = 54.64, ["Neon|Ride"] = 262.47, ["Mega"] = 196.88}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 258.56, ["Ride"] = 234.42, ["Fly|Ride"] = 328.13, ["Neon"] = 980.25, ["Neon|Ride"] = 1194.13, ["Neon|Fly|Ride"] = 905.63, ["Mega|Fly|Ride"] = 3522.56}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 23.63, ["Fly|Ride"] = 84.25, ["Neon"] = 31.48, ["Neon|Ride"] = 45.39, ["Neon|Fly|Ride"] = 100.03, ["Mega"] = 250.04, ["Mega|Ride"] = 306.36, ["Mega|Fly|Ride"] = 350.44}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.05, ["Fly"] = 30.37, ["Ride"] = 12.55, ["Fly|Ride"] = 34.9, ["Neon"] = 3.94, ["Neon|Fly"] = 39.09, ["Neon|Ride"] = 22.99, ["Neon|Fly|Ride"] = 34.85, ["Mega"] = 34.12, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 128.63}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 847.02, ["Fly"] = 1067.64, ["Ride"] = 901.69, ["Fly|Ride"] = 892.49, ["Neon|Ride"] = 3910.88, ["Neon|Fly|Ride"] = 3474.12, ["Mega"] = 28002.72, ["Mega|Fly|Ride"] = 28073.94}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 3.65, ["Fly"] = 980.19, ["Ride"] = 39.38, ["Neon"] = 26.25, ["Mega"] = 140.44, ["Mega|Ride"] = 193.97, ["Mega|Fly|Ride"] = 410.17}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 5.41, ["Fly"] = 141.1, ["Ride"] = 41.14, ["Neon"] = 17.03, ["Neon|Ride"] = 32.74, ["Neon|Fly|Ride"] = 138.03, ["Mega"] = 151.36, ["Mega|Ride"] = 196.87, ["Mega|Fly|Ride"] = 267.65}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 22.32, ["Fly"] = 19.69, ["Ride"] = 25.6, ["Fly|Ride"] = 52.39, ["Neon"] = 296.51, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 162.75, ["Mega"] = 2071.85, ["Mega|Fly|Ride"] = 759.59}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 11.28, ["Fly"] = 78.98, ["Ride"] = 27.75, ["Fly|Ride"] = 60.36, ["Neon"] = 54.48, ["Neon|Ride"] = 70.44, ["Neon|Fly|Ride"] = 157.92, ["Mega"] = 419.01, ["Mega|Ride"] = 735, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 19.2, ["Ride"] = 28.45, ["Fly|Ride"] = 636.57, ["Neon"] = 84.09, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 421.12, ["Mega|Ride"] = 494.82, ["Mega|Fly|Ride"] = 562.19}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.05, ["Fly"] = 42.13, ["Ride"] = 105, ["Fly|Ride"] = 156.43, ["Neon"] = 2.1, ["Neon|Ride"] = 42.14, ["Mega"] = 12.48, ["Mega|Ride"] = 89.25, ["Mega|Fly|Ride"] = 874.13}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 33.66, ["Fly"] = 56.87, ["Ride"] = 34.8, ["Fly|Ride"] = 98.81, ["Neon"] = 578.82, ["Neon|Fly"] = 310.21, ["Neon|Ride"] = 103.94, ["Neon|Fly|Ride"] = 258.55, ["Mega"] = 3368.84, ["Mega|Fly|Ride"] = 766.5}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 3.82, ["Fly"] = 757.32, ["Ride"] = 25.99, ["Fly|Ride"] = 112.67, ["Neon"] = 42, ["Mega"] = 656.25, ["Mega|Fly|Ride"] = 562.19}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 35.81, ["Ride"] = 18.38, ["Fly|Ride"] = 68.25, ["Neon"] = 15.74, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 54.86, ["Mega"] = 1040.13, ["Mega|Ride"] = 250.15, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 2.63, ["Ride"] = 61.69, ["Neon"] = 105, ["Mega"] = 262.5, ["Mega|Ride"] = 164.07, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 12.84, ["Fly"] = 262.5, ["Ride"] = 35.81, ["Fly|Ride"] = 196.88, ["Neon"] = 88.23, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 209.51, ["Mega"] = 631.66, ["Mega|Ride"] = 625.35, ["Mega|Fly|Ride"] = 701.15}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 7.76, ["Neon"] = 12.84, ["Neon|Ride"] = 78.75, ["Mega"] = 72.8, ["Mega|Fly|Ride"] = 311.54}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.05, ["Ride"] = 27.17, ["Neon"] = 2.1, ["Neon|Ride"] = 65.63, ["Mega"] = 13.13, ["Mega|Ride"] = 45.94, ["Mega|Fly|Ride"] = 199.5}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.05, ["Ride"] = 26.13, ["Neon"] = 2.1, ["Neon|Ride"] = 22.32, ["Mega"] = 9.19, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 31.49, ["Ride"] = 28.39, ["Fly|Ride"] = 32.03, ["Neon"] = 4.19, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 84.24, ["Mega"] = 86.63, ["Mega|Ride"] = 168.46, ["Mega|Fly|Ride"] = 171.94}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 5252.83, ["Neon"] = 75.83, ["Neon|Ride"] = 1312.5, ["Mega"] = 141.08, ["Mega|Ride"] = 158.33}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.45, ["Fly"] = 39.51, ["Ride"] = 11.82, ["Fly|Ride"] = 42, ["Neon"] = 16.47, ["Neon|Ride"] = 18.35, ["Neon|Fly|Ride"] = 80.07, ["Mega"] = 223.13, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 363.56}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 53.63, ["Ride"] = 165.41, ["Fly|Ride"] = 393.8, ["Neon"] = 103.95, ["Neon|Ride"] = 315.84, ["Neon|Fly|Ride"] = 323.21, ["Mega"] = 688.51, ["Mega|Ride"] = 761.25, ["Mega|Fly|Ride"] = 841.17}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 15.38, ["Fly|Ride"] = 32.92, ["Neon"] = 2.1, ["Neon|Fly"] = 22.66, ["Neon|Ride"] = 23.29, ["Neon|Fly|Ride"] = 40.94, ["Mega"] = 28.44, ["Mega|Fly|Ride"] = 122.6}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 7.61, ["Fly"] = 62.3, ["Ride"] = 32.82, ["Fly|Ride"] = 78.22, ["Neon"] = 40.69, ["Neon|Ride"] = 47.35, ["Neon|Fly|Ride"] = 104.99, ["Mega"] = 524.99, ["Mega|Ride"] = 297.55, ["Mega|Fly|Ride"] = 304.5}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 10.07, ["Fly"] = 27.29, ["Ride"] = 18.38, ["Fly|Ride"] = 41.06, ["Neon"] = 57.86, ["Neon|Ride"] = 53.21, ["Neon|Fly|Ride"] = 98.26, ["Mega"] = 1025.4, ["Mega|Ride"] = 502.04, ["Mega|Fly|Ride"] = 384.76}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 2.1, ["Fly"] = 140.38, ["Neon"] = 17.03, ["Neon|Ride"] = 70.55, ["Mega"] = 150.94, ["Mega|Ride"] = 232.67}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.05, ["Ride"] = 12.8, ["Fly|Ride"] = 61.69, ["Neon"] = 3.71, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 23.51, ["Neon|Fly|Ride"] = 69.57, ["Mega"] = 35.44, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 61.57, ["Mega|Fly|Ride"] = 142.37}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 2.1, ["Ride"] = 27.57, ["Neon"] = 14.44, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 210.56, ["Mega"] = 156.37, ["Mega|Fly"] = 735, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 334.55}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 909.85, ["Fly"] = 1266.64, ["Ride"] = 945, ["Fly|Ride"] = 1019.82, ["Neon"] = 2948.46, ["Neon|Ride"] = 1968.74, ["Neon|Fly|Ride"] = 2034.38, ["Mega|Fly|Ride"] = 7398.57}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 38.95, ["Ride"] = 98.44, ["Fly|Ride"] = 196.9, ["Neon"] = 236.25, ["Neon|Ride"] = 250.69, ["Neon|Fly|Ride"] = 408.38, ["Mega"] = 3147.38, ["Mega|Ride"] = 1123.32, ["Mega|Fly|Ride"] = 1155}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Fly"] = 63.03, ["Ride"] = 15.73, ["Neon"] = 6.02, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 315, ["Mega"] = 51.43, ["Mega|Ride"] = 131.25}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 34.63, ["Ride"] = 54.58, ["Fly|Ride"] = 262.5, ["Neon"] = 249.12, ["Neon|Ride"] = 131.02, ["Neon|Fly|Ride"] = 300.57, ["Mega"] = 839.56, ["Mega|Ride"] = 694.32, ["Mega|Fly|Ride"] = 710.07}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 4.86, ["Ride"] = 46.6, ["Neon"] = 20.02, ["Neon|Ride"] = 131.25, ["Mega"] = 315.84, ["Mega|Ride"] = 351.63}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 297.08, ["Fly"] = 933.52, ["Ride"] = 251.46, ["Fly|Ride"] = 436.58, ["Neon"] = 1181.25, ["Neon|Ride"] = 1259.32, ["Neon|Fly|Ride"] = 1182.57, ["Mega|Fly|Ride"] = 4162.01}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 102.38, ["Ride"] = 21, ["Fly|Ride"] = 129.93, ["Neon"] = 12.32, ["Mega"] = 196.88, ["Mega|Fly"] = 281.1}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Ride"] = 18.97, ["Neon"] = 19.02, ["Neon|Ride"] = 141.08}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 30.49, ["Ride"] = 52.45, ["Fly|Ride"] = 210.59, ["Neon"] = 151.26, ["Neon|Ride"] = 183.74, ["Mega"] = 623.07, ["Mega|Ride"] = 981.1, ["Mega|Fly|Ride"] = 744.85}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 20.02, ["Fly|Ride"] = 141.1, ["Neon"] = 65.63, ["Neon|Ride"] = 156.45, ["Mega"] = 176.89, ["Mega|Ride"] = 224.59, ["Mega|Fly|Ride"] = 421.12}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 21.04, ["Ride"] = 11.59, ["Fly|Ride"] = 30.35, ["Neon"] = 2.1, ["Neon|Fly"] = 31.18, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 43.32, ["Mega"] = 17.07, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 75.6}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 3890.55, ["Ride"] = 3937.5, ["Fly|Ride"] = 4198.68, ["Neon"] = 25269.3, ["Neon|Fly|Ride"] = 19163.82, ["Mega|Fly|Ride"] = 78745.32}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 7.86, ["Ride"] = 56.35, ["Neon"] = 31.5, ["Mega"] = 262.5, ["Mega|Ride"] = 323.21, ["Mega|Fly|Ride"] = 336}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 31.6, ["Ride"] = 15.74, ["Fly|Ride"] = 42.13, ["Neon"] = 15.21, ["Neon|Fly"] = 46.72, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 66.26, ["Mega"] = 284.25, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 195.02}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 319.92, ["Fly"] = 840, ["Ride"] = 446.25, ["Fly|Ride"] = 480.32, ["Neon"] = 1684.62, ["Neon|Ride"] = 1278.34, ["Neon|Fly|Ride"] = 928.76, ["Mega|Fly|Ride"] = 5796.51}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 4.23, ["Ride"] = 31.5, ["Neon"] = 15.72, ["Neon|Ride"] = 291.38, ["Neon|Fly|Ride"] = 281.1, ["Mega"] = 131.25, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 3.42, ["Fly"] = 51.49, ["Ride"] = 77.94, ["Neon"] = 49.7, ["Neon|Ride"] = 280.11, ["Neon|Fly|Ride"] = 14037.5, ["Mega"] = 281.1, ["Mega|Ride"] = 360.94, ["Mega|Fly|Ride"] = 2333.58}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 14.44, ["Neon"] = 3.52, ["Neon|Ride"] = 45.52, ["Mega"] = 22.84, ["Mega|Ride"] = 65.63}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 538.13, ["Ride"] = 589.46, ["Fly|Ride"] = 588.15, ["Neon|Fly|Ride"] = 2205, ["Mega|Fly|Ride"] = 8751.75}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 3.81, ["Ride"] = 43.87, ["Neon"] = 13.89, ["Neon|Fly"] = 75.83, ["Neon|Ride"] = 99, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 108.94, ["Mega|Ride"] = 215.13, ["Mega|Fly|Ride"] = 344.54}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 7.48, ["Fly"] = 236.25, ["Ride"] = 52.5, ["Fly|Ride"] = 147.13, ["Neon"] = 24.08, ["Neon|Ride"] = 59.01, ["Neon|Fly|Ride"] = 210.56, ["Mega"] = 250.95, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 315.52}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 14.44, ["Fly|Ride"] = 36.64, ["Neon"] = 7.86, ["Neon|Fly"] = 141.11, ["Neon|Ride"] = 18.63, ["Neon|Fly|Ride"] = 89.23, ["Mega"] = 118.13, ["Mega|Fly"] = 225.3, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 221.6}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 17.77, ["Ride"] = 39.38, ["Fly|Ride"] = 116.75, ["Neon"] = 196.88, ["Mega"] = 525.34, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 526.32}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.05, ["Neon"] = 5.25, ["Neon|Fly|Ride"] = 2041.88, ["Mega"] = 35.68, ["Mega|Ride"] = 95.51, ["Mega|Fly|Ride"] = 155.82}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 473.86, ["Ride"] = 492.19, ["Fly|Ride"] = 682.5, ["Neon"] = 1952.07, ["Neon|Ride"] = 2106.04, ["Neon|Fly|Ride"] = 2362.49, ["Mega|Ride"] = 9100.9, ["Mega|Fly|Ride"] = 7848.75}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 25.77, ["Neon"] = 4.9, ["Neon|Ride"] = 24.47, ["Mega"] = 41.01, ["Mega|Ride"] = 98.98, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 28.34, ["Neon"] = 3.78, ["Neon|Ride"] = 41.66, ["Mega"] = 35.21, ["Mega|Ride"] = 63.18, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 3.49, ["Neon|Ride"] = 62.91, ["Mega"] = 36.09, ["Mega|Fly"] = 155.82, ["Mega|Ride"] = 105.29, ["Mega|Fly|Ride"] = 167.37}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.55, ["Ride"] = 26.25, ["Neon"] = 15.73, ["Mega|Ride"] = 311.54}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 25.13, ["Ride"] = 38.1, ["Fly|Ride"] = 131.25, ["Neon"] = 85.13, ["Neon|Ride"] = 168, ["Neon|Fly|Ride"] = 416.91, ["Mega"] = 669.38, ["Mega|Ride"] = 523.68, ["Mega|Fly|Ride"] = 560.09}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 11.6, ["Ride"] = 65.63, ["Fly|Ride"] = 242.82, ["Neon"] = 112.46, ["Neon|Ride"] = 112.01, ["Mega"] = 551.25, ["Mega|Ride"] = 553.07, ["Mega|Fly|Ride"] = 488.24}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.35, ["Fly"] = 34.63, ["Ride"] = 12.47, ["Fly|Ride"] = 31.5, ["Neon"] = 31.48, ["Neon|Ride"] = 30.18, ["Neon|Fly|Ride"] = 67.38, ["Mega"] = 299.92, ["Mega|Ride"] = 222.69, ["Mega|Fly|Ride"] = 228.38}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 8.55, ["Fly"] = 21.07, ["Ride"] = 32.82, ["Neon"] = 124.14, ["Neon|Ride"] = 262.5, ["Mega"] = 332.69, ["Mega|Fly|Ride"] = 503.24}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Fly"] = 32.66, ["Ride"] = 27.72, ["Fly|Ride"] = 362.25, ["Neon"] = 8.44, ["Neon|Ride"] = 83.87, ["Mega"] = 97.13, ["Mega|Ride"] = 84.24, ["Mega|Fly|Ride"] = 195.83}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 19.59, ["Fly"] = 65.63, ["Ride"] = 19.67, ["Fly|Ride"] = 62.25, ["Neon"] = 131.25, ["Neon|Ride"] = 82.77, ["Neon|Fly|Ride"] = 207.38, ["Mega"] = 1050, ["Mega|Ride"] = 933.44, ["Mega|Fly|Ride"] = 673.35}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 23.82, ["Fly"] = 874.13, ["Neon"] = 150.93, ["Neon|Fly"] = 170.63, ["Neon|Ride"] = 328.13}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 26.25, ["Fly"] = 115.5, ["Ride"] = 60.68, ["Fly|Ride"] = 144.38, ["Neon"] = 297.93, ["Neon|Ride"] = 322.67, ["Neon|Fly|Ride"] = 396.03, ["Mega|Ride"] = 1378.13, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 49.27, ["Fly"] = 126.1, ["Ride"] = 98.78, ["Fly|Ride"] = 302.19, ["Neon"] = 174.16, ["Neon|Ride"] = 215.25, ["Neon|Fly|Ride"] = 364.88, ["Mega"] = 627.99, ["Mega|Ride"] = 623.44, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 15.22, ["Ride"] = 65.62, ["Fly|Ride"] = 116.75, ["Neon"] = 157.5, ["Neon|Ride"] = 251.99, ["Mega"] = 660.09, ["Mega|Ride"] = 655.89, ["Mega|Fly|Ride"] = 1261.22}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 5.76, ["Fly"] = 31.7, ["Ride"] = 18.31, ["Fly|Ride"] = 70.56, ["Neon"] = 52.71, ["Neon|Fly"] = 420, ["Neon|Ride"] = 94.5, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 336.9, ["Mega|Ride"] = 345.18, ["Mega|Fly|Ride"] = 378.27}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 27.98, ["Ride"] = 13.13, ["Fly|Ride"] = 24.55, ["Neon"] = 2.1, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 15.74, ["Neon|Fly|Ride"] = 72.35, ["Mega"] = 45.94, ["Mega|Ride"] = 86.35, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1311.19}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 15.74, ["Ride"] = 70.06, ["Fly|Ride"] = 52.5, ["Neon"] = 131.25, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 313.79, ["Mega"] = 562.19, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 528.13}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 21.98, ["Neon"] = 3.86, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 293.79, ["Mega"] = 23.35, ["Mega|Ride"] = 80.04, ["Mega|Fly|Ride"] = 217.88}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 17.22, ["Ride"] = 65.63, ["Fly|Ride"] = 281.14, ["Neon"] = 111.57, ["Neon|Ride"] = 414.74, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 702.2, ["Mega|Ride"] = 583.41, ["Mega|Fly|Ride"] = 631.66}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Ride"] = 35.81, ["Neon"] = 3.78, ["Mega"] = 18.25}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 3.68, ["Mega"] = 15.72, ["Mega|Ride"] = 126.35, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 94.74, ["Ride"] = 159.48, ["Fly|Ride"] = 223.13, ["Neon"] = 561.28, ["Neon|Ride"] = 590.63, ["Neon|Fly|Ride"] = 618.29, ["Mega|Ride"] = 6417.3, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.6, ["Fly"] = 65.63, ["Ride"] = 23.14, ["Neon"] = 9.19, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 87.4, ["Mega"] = 104.93, ["Mega|Ride"] = 156.37, ["Mega|Fly|Ride"] = 562.19}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 34.92, ["Fly|Ride"] = 86.63, ["Neon"] = 5.9, ["Neon|Ride"] = 28.35, ["Neon|Fly|Ride"] = 419.99, ["Mega"] = 32.82, ["Mega|Ride"] = 125.3}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 31.54, ["Neon"] = 3.93, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 21.27, ["Mega"] = 31.44, ["Mega|Ride"] = 74.82, ["Mega|Fly|Ride"] = 210.56}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 78.22, ["Neon"] = 4.36, ["Neon|Ride"] = 37.37, ["Mega"] = 32.65, ["Mega|Ride"] = 93.13}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 31.37, ["Ride"] = 91.88, ["Fly|Ride"] = 620.95, ["Neon"] = 350.53, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 695.63, ["Mega|Fly|Ride"] = 1245.85}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 2.59, ["Ride"] = 129.31, ["Fly|Ride"] = 78.22, ["Neon"] = 11.06, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 281.1, ["Mega"] = 140.6, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 314.79}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 301.88, ["Ride"] = 459.38, ["Fly|Ride"] = 608.58, ["Neon"] = 1764.46, ["Neon|Ride"] = 1158.33, ["Neon|Fly|Ride"] = 1405.69, ["Mega|Ride"] = 3775.21, ["Mega|Fly|Ride"] = 3150}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 65.63}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 38.07}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 11.53}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 12.27}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 42.47}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 52.5}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 5.28}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 4.24}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 213.94}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 20.96}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 26.25}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 9.13}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 8.75}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 249.38}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 8.88}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 3.92}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 14.43}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 501.04}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 690.11}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 10.48}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1064.44}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 221.12}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 8.97}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.63}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.52}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 20.93}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 53.03}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 45.91}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 15.74}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 5.25}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 18.72}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 2.49}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 17.05}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.1}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 21.87}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 21}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 3.83}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 1443.75}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 109.31}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 214.68}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 3.83}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.61}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 9.14}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 10.07}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 138.55}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 136.37}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 9.92}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 11.17}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 180.37}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 11.8}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 5.86}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 11.44}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 3.56}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 2.63}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 127.32}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 16.99}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 5.46}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 13.1}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 9.45}},
    ["rbxassetid://1265129203"] = {name = "Ice Snowboard", prices = {["default"] = 207.38}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 2.57}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 12.84}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 195.57}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 91.87}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 4.99}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 12.8}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 24.94}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 62.83}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 23.57}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22170.25}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 170.09}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 33.71}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 26.24}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 20.57}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 117.58}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 15.3}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 39.38}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 33.59}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 118.13}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 62.46}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 24.93}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 34.13}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 33.53}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 170.62}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 9.19}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 7.44}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 4.73}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 24.94}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 26.97}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.1}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 2.88}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 2.1}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 3.56}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 656.25}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 5.25}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 525}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 14.43}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 5.98}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 262.5}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 15.46}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 66.76}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 32.11}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 32.8}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 68.57}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 26.19}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 2.37}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 10.05}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.1}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 6.57}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 3.93}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 19.46}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 2.35}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 3.2}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 5.18}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 9.53}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 152.1}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 36.01}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.1}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 1051.85}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 5.03}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 7.95}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 52.5}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 10.39}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 66.57}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 6.56}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 5.57}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 7.86}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 9.16}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 89.1}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 17.43}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 8.03}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 2.57}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 7.87}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 11.54}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 3.1}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 3.61}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.6}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 3.41}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 4.55}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 7355.49}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 16.63}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 2.25}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 6.54}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 5.02}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.33}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 15.21}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 4.91}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 5.17}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 10.85}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 77.87}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 4.81}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 6.35}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 3.51}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4434.17}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 4.46}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 22.09}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 2.1}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 54.51}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 2.86}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 141.1}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.39}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 3.93}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 2.49}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.63}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 2.24}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 3.31}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 13.55}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 3.44}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.21}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 8.07}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 3.94}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.25}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 3.92}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 2.16}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 28.35}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 3.93}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 9.83}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 111.57}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 22.29}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 913.35}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 12.18}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 3.93}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 2.7}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 14.12}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.5}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 4.98}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 11.82}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 14.1}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 20.87}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 9.68}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 3.31}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 5.59}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 3.3}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 14.25}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 3.63}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 10.61}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 6.02}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 13.06}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 7.23}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 100.05}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 48.25}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.49}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 2.1}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 17.1}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 10.49}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 3.02}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.67}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 56.44}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.56}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 5.13}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.63}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 3.92}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 5.2}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 6.86}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 61.57}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 3.46}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 108.94}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 5.25}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1109.07}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 196.88}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 2.63}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 3.15}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.41}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.49}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 5.24}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 45.85}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.52}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 2.91}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 5.25}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 32.65}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 3.54}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.19}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 8.7}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 47.5}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 2.63}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 52.5}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 2.63}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.52}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 16.84}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 60.67}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.5}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 2.6}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.15}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 42.11}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 5.54}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 3.7}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 63.5}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 18.36}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 81.32}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 288.75}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 27.33}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 103.84}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.89}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 2.63}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.37}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 8.95}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 58.72}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 11.69}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 7.69}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 11.38}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.45}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 14.67}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 2.24}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 3.29}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 19.67}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 29.29}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 2.84}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 3.81}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 22.31}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 4.88}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 4.65}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 37.84}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 43.98}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 26.21}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1516.93}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 6.86}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 6.56}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 27.57}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 249.1}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 20.93}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 3.93}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 7.87}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 4.64}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 3.52}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 161.44}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 72.19}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 51.19}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 5.49}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 3.1}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 65.49}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 90.57}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 41.93}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 918.75}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 135.77}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 8.7}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 945}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 556.5}},
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