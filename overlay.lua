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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 809.7, ["Fly"] = 1116.21, ["Ride"] = 1046.12, ["Fly|Ride"] = 836.91, ["Neon"] = 6455.42, ["Neon|Ride"] = 4463.74, ["Neon|Fly|Ride"] = 3413.46}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 477.75, ["Fly"] = 500.37, ["Ride"] = 523.06, ["Fly|Ride"] = 575.3, ["Neon|Fly|Ride"] = 2361.19, ["Mega|Fly|Ride"] = 8351.05}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 5419.32, ["Ride"] = 4790.63, ["Fly|Ride"] = 4840.5, ["Neon"] = 25804.24, ["Neon|Fly|Ride"] = 26151.55, ["Mega|Fly|Ride"] = 72228.4}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 111.57, ["Ride"] = 156.19, ["Fly|Ride"] = 576.47, ["Neon"] = 972.65, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 940.46, ["Mega"] = 3488.77, ["Mega|Fly|Ride"] = 6147.85}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 523.69, ["Ride"] = 519.75, ["Fly|Ride"] = 551.25, ["Neon|Fly|Ride"] = 1773.52, ["Mega|Fly|Ride"] = 7376.5}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 7.97, ["Ride"] = 39.38, ["Fly|Ride"] = 119.27, ["Neon"] = 32.82, ["Neon|Ride"] = 107.77, ["Neon|Fly|Ride"] = 279.33, ["Mega"] = 262.5, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 409.5}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 4.2, ["Fly"] = 28.26, ["Ride"] = 24.9, ["Fly|Ride"] = 52.5, ["Neon"] = 23.63, ["Neon|Fly"] = 64.32, ["Neon|Ride"] = 41.86, ["Neon|Fly|Ride"] = 90.41, ["Mega"] = 119.68, ["Mega|Fly"] = 303.19, ["Mega|Ride"] = 168.62, ["Mega|Fly|Ride"] = 341.18}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 131.17, ["Ride"] = 290.07, ["Neon"] = 547.38, ["Neon|Fly"] = 392.44, ["Neon|Ride"] = 558.64, ["Neon|Fly|Ride"] = 1673.79, ["Mega"] = 1844.14, ["Mega|Ride"] = 1883, ["Mega|Fly|Ride"] = 1844.14}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 33.44, ["Fly"] = 141.24, ["Ride"] = 45.87, ["Fly|Ride"] = 89.25, ["Neon"] = 275.52, ["Neon|Ride"] = 204.75, ["Neon|Fly|Ride"] = 209.24, ["Mega"] = 2100, ["Mega|Ride"] = 691.56, ["Mega|Fly|Ride"] = 768.79}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 23.08, ["Fly"] = 56.44, ["Ride"] = 38.99, ["Fly|Ride"] = 61.82, ["Neon"] = 276.19, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 187.69, ["Mega|Ride"] = 767.86, ["Mega|Fly|Ride"] = 696.72}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 36.75, ["Ride"] = 59.07, ["Fly|Ride"] = 148.99, ["Neon|Ride"] = 209.24, ["Neon|Fly|Ride"] = 307.75, ["Mega|Fly|Ride"] = 1034.25}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 61.57}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 399.15, ["Ride"] = 367.5, ["Fly|Ride"] = 444.94, ["Neon"] = 1283.58, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1253.25, ["Mega|Fly|Ride"] = 3904.07}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 118.13, ["Fly"] = 175.88, ["Ride"] = 123.38, ["Fly|Ride"] = 140.43, ["Neon"] = 1395.52, ["Neon|Fly|Ride"] = 556.55, ["Mega|Fly|Ride"] = 2305.16}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.49, ["Fly"] = 31.4, ["Ride"] = 23.07, ["Fly|Ride"] = 91.03, ["Neon"] = 19.9, ["Neon|Fly"] = 61.73, ["Neon|Ride"] = 70.1, ["Mega"] = 101.61, ["Mega|Ride"] = 170.6, ["Mega|Fly|Ride"] = 381.52}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 131.25, ["Fly"] = 144.64, ["Ride"] = 108.39, ["Fly|Ride"] = 157.5, ["Neon"] = 475.99, ["Neon|Ride"] = 627.68, ["Neon|Fly|Ride"] = 543.37, ["Mega"] = 2092.22, ["Mega|Fly|Ride"] = 1967.44}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.89, ["Fly"] = 31.4, ["Ride"] = 19.69, ["Fly|Ride"] = 46.12, ["Neon"] = 19.9, ["Neon|Fly"] = 104.63, ["Neon|Ride"] = 62.78, ["Neon|Fly|Ride"] = 104.74, ["Mega"] = 223.88, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 38.15, ["Ride"] = 70.09, ["Fly|Ride"] = 138.08, ["Neon"] = 106.88, ["Neon|Ride"] = 149.63, ["Neon|Fly|Ride"] = 244.8, ["Mega"] = 788.66, ["Mega|Ride"] = 723.92, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 44.63}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 41.88, ["Ride"] = 165.38, ["Fly|Ride"] = 203.44, ["Neon"] = 279.57, ["Neon|Ride"] = 345.83, ["Mega"] = 2929.11, ["Mega|Fly|Ride"] = 3073.93}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 11.43, ["Fly"] = 49.88, ["Ride"] = 27.43, ["Fly|Ride"] = 140.19, ["Neon"] = 85.32, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 2650.93, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 615.48}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 31.49, ["Fly"] = 99.75, ["Ride"] = 57.75, ["Fly|Ride"] = 108.38, ["Neon"] = 384.99, ["Neon|Ride"] = 155.09, ["Neon|Fly|Ride"] = 255.94, ["Mega"] = 1681.32, ["Mega|Ride"] = 691.56, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 66.94, ["Ride"] = 155.76, ["Fly|Ride"] = 196.88, ["Neon"] = 209.99, ["Neon|Ride"] = 418.46, ["Neon|Fly|Ride"] = 404.92, ["Mega"] = 1673.79, ["Mega|Ride"] = 1241.75, ["Mega|Fly|Ride"] = 1198.85}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 26.25, ["Ride"] = 45.94, ["Fly|Ride"] = 137.17, ["Neon"] = 172.91, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 408.19, ["Mega"] = 697.76, ["Mega|Ride"] = 902.79, ["Mega|Fly|Ride"] = 956.16}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 52.5, ["Fly"] = 125.55, ["Ride"] = 56.44, ["Fly|Ride"] = 160.07, ["Neon"] = 251.08, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 307.75, ["Mega|Ride"] = 2493.75, ["Mega|Fly|Ride"] = 936.28}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 3.93, ["Fly"] = 28.49, ["Ride"] = 17.32, ["Fly|Ride"] = 45.94, ["Neon"] = 28.32, ["Neon|Fly"] = 44.63, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 80.07, ["Mega"] = 128.4, ["Mega|Fly"] = 418.46, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 313.6, ["Ride"] = 279.33, ["Fly|Ride"] = 370.29, ["Neon|Ride"] = 2929.11, ["Neon|Fly|Ride"] = 1416.19, ["Mega"] = 10461.04, ["Mega|Fly|Ride"] = 5379.08}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 18.79, ["Ride"] = 48.14, ["Neon"] = 237.47, ["Neon|Ride"] = 209.24, ["Mega"] = 823.3, ["Mega|Fly|Ride"] = 736.47}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 5.25, ["Fly"] = 37.94, ["Ride"] = 20.93, ["Fly|Ride"] = 41.42, ["Neon"] = 41.86, ["Neon|Ride"] = 83.7, ["Neon|Fly|Ride"] = 105, ["Mega|Ride"] = 558.64, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 97.13, ["Fly"] = 138.1, ["Ride"] = 119, ["Fly|Ride"] = 146.47, ["Neon"] = 279.33, ["Neon|Fly"] = 418.46, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 461.05, ["Mega"] = 6107.51, ["Mega|Ride"] = 3073.93, ["Mega|Fly|Ride"] = 1491}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 15.7, ["Ride"] = 33.48, ["Fly|Ride"] = 118.13, ["Neon"] = 149.87, ["Neon|Ride"] = 140.19, ["Neon|Fly|Ride"] = 207.38, ["Mega"] = 694.62}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 203.44, ["Fly"] = 353.95, ["Ride"] = 237.47, ["Fly|Ride"] = 349.41, ["Neon"] = 691.66, ["Neon|Ride"] = 768.9, ["Neon|Fly|Ride"] = 836.91, ["Mega"] = 6276.63, ["Mega|Fly|Ride"] = 2558.48}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 28.88}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.82, ["Fly"] = 31.39, ["Ride"] = 31.4, ["Fly|Ride"] = 60.68, ["Neon"] = 18.38, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 41.86, ["Neon|Fly|Ride"] = 111.95, ["Mega"] = 158.82, ["Mega|Fly"] = 223.88, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 194.59}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 557.37, ["Ride"] = 558.64, ["Fly|Ride"] = 654.94, ["Neon"] = 3041.04, ["Neon|Ride"] = 3626.85, ["Neon|Fly|Ride"] = 2784.74, ["Mega"] = 11856.55, ["Mega|Ride"] = 51865.87, ["Mega|Fly|Ride"] = 9764.33}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 9.22, ["Fly"] = 44.98, ["Ride"] = 28.88, ["Fly|Ride"] = 71.14, ["Neon"] = 49.18, ["Neon|Fly"] = 140.19, ["Neon|Ride"] = 102.1, ["Neon|Fly|Ride"] = 173.67, ["Mega"] = 526.32, ["Mega|Ride"] = 596.3, ["Mega|Fly|Ride"] = 660.09}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 103.69, ["Ride"] = 147, ["Fly|Ride"] = 207.38, ["Neon"] = 573.28, ["Neon|Ride"] = 514.5, ["Neon|Fly|Ride"] = 679.97, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 2659.21}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 39.37}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 32.82, ["Ride"] = 74.28, ["Fly|Ride"] = 196.88, ["Neon"] = 86.46, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 271.83, ["Mega"] = 691.56, ["Mega|Ride"] = 615.48, ["Mega|Fly|Ride"] = 722.68}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.2}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 136.5, ["Ride"] = 200.63, ["Neon"] = 558.64, ["Neon|Ride"] = 577.5, ["Neon|Fly|Ride"] = 656.25, ["Mega|Fly|Ride"] = 1954.13}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 141.48, ["Ride"] = 123.44, ["Fly|Ride"] = 262.5, ["Neon"] = 493.39, ["Neon|Ride"] = 408.19, ["Neon|Fly|Ride"] = 465.94, ["Mega|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 1468.69}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 57.75}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 62.4, ["Fly"] = 110.88, ["Ride"] = 52.49, ["Fly|Ride"] = 65.63, ["Neon|Ride"] = 313.85, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 4184.43, ["Mega|Fly|Ride"] = 1258.69}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 6.22, ["Ride"] = 48.2, ["Fly|Ride"] = 131.25, ["Neon"] = 39.38, ["Neon|Ride"] = 154.84, ["Neon|Fly|Ride"] = 236.43, ["Mega"] = 174.71, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 251.08, ["Mega|Fly|Ride"] = 328.5}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 303.19, ["Ride"] = 334.69, ["Fly|Ride"] = 353.07, ["Neon|Ride"] = 1954.13, ["Neon|Fly|Ride"] = 1283.58, ["Mega|Fly|Ride"] = 4764.76}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 69.57, ["Fly"] = 99.75, ["Ride"] = 85.32, ["Fly|Ride"] = 146.42, ["Neon"] = 262.5, ["Neon|Ride"] = 292.92, ["Neon|Fly|Ride"] = 410.82, ["Mega|Fly|Ride"] = 1546.15}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 7113.51, ["Ride"] = 3018.75, ["Fly|Ride"] = 3412.5, ["Neon|Fly|Ride"] = 13946.66}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 33.66, ["Fly"] = 223.88, ["Ride"] = 53.82, ["Fly|Ride"] = 123.38, ["Neon"] = 322.79, ["Neon|Ride"] = 276.94, ["Neon|Fly|Ride"] = 209.24, ["Mega"] = 1883, ["Mega|Ride"] = 1883, ["Mega|Fly|Ride"] = 1325.43}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 237.47, ["Ride"] = 747.98, ["Fly|Ride"] = 147, ["Neon"] = 393.75, ["Neon|Ride"] = 266.3, ["Neon|Fly|Ride"] = 418.46, ["Mega"] = 6276.63, ["Mega|Ride"] = 1844.14, ["Mega|Fly|Ride"] = 1518.96}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 30.84, ["Fly"] = 62.78, ["Ride"] = 43.31, ["Fly|Ride"] = 123.38, ["Neon"] = 138.34, ["Neon|Fly"] = 273, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 231.21, ["Mega"] = 2598.75, ["Mega|Fly|Ride"] = 627.38}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 12.56}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 62.71, ["Ride"] = 78.75, ["Fly|Ride"] = 105, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 502.15, ["Mega|Fly|Ride"] = 1690.85}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 42}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 215.71, ["Ride"] = 262.5, ["Fly|Ride"] = 341.25, ["Neon|Ride"] = 836.91, ["Neon|Fly|Ride"] = 1450.97}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 656.25, ["Ride"] = 616.88, ["Fly|Ride"] = 656.25, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2198.44, ["Mega|Fly|Ride"] = 11812.5}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 8.39}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 22.32, ["Fly"] = 52.5, ["Ride"] = 35.38, ["Fly|Ride"] = 64.32, ["Neon"] = 318.03, ["Neon|Fly"] = 307.8, ["Neon|Ride"] = 140.19, ["Neon|Fly|Ride"] = 209.21, ["Mega|Ride"] = 648.59, ["Mega|Fly|Ride"] = 786.79}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 9.08}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5040, ["Fly"] = 4593.75, ["Ride"] = 5719.06, ["Fly|Ride"] = 5144.99, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 40310.55}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 6.55, ["Ride"] = 24.67, ["Fly|Ride"] = 56.51, ["Neon"] = 59.07, ["Neon|Ride"] = 108.94, ["Neon|Fly|Ride"] = 217.84, ["Mega"] = 389.17, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 14.43, ["Fly"] = 78.47, ["Ride"] = 41.86, ["Fly|Ride"] = 114.14, ["Neon"] = 140.19, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 697.76, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 539.81}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 73.24, ["Ride"] = 75.33, ["Fly|Ride"] = 125.55}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 9.91, ["Ride"] = 41.85, ["Fly|Ride"] = 139.65, ["Neon"] = 78.75, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 305.48, ["Mega"] = 1116.21, ["Mega|Ride"] = 552.36, ["Mega|Fly|Ride"] = 1019.82}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 2494.17, ["Fly"] = 2310, ["Ride"] = 2484.44, ["Fly|Ride"] = 2031.75, ["Neon|Fly|Ride"] = 4331.25, ["Mega|Fly|Ride"] = 11812.5}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 30743.96, ["Ride"] = 23537.07, ["Fly|Ride"] = 22968.75, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 71241.8, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 195272.95}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 19.69, ["Fly"] = 393.75, ["Ride"] = 57.74, ["Fly|Ride"] = 85.33, ["Neon"] = 236.25, ["Neon|Ride"] = 178.38, ["Neon|Fly|Ride"] = 418.46, ["Mega"] = 1470, ["Mega|Ride"] = 783.77, ["Mega|Fly|Ride"] = 948.83}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 2.63, ["Fly"] = 41.86, ["Ride"] = 31.49, ["Fly|Ride"] = 108.38, ["Neon"] = 17.07, ["Neon|Fly"] = 129.34, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 99.75, ["Mega|Ride"] = 179.29, ["Mega|Fly|Ride"] = 245.44}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 23.63}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 7.65, ["Ride"] = 39.77, ["Fly|Ride"] = 279.33, ["Neon"] = 45.65, ["Neon|Ride"] = 124.36, ["Neon|Fly|Ride"] = 124.5, ["Mega"] = 209.24, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 401.72}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 708.75, ["Ride"] = 800.17, ["Fly|Ride"] = 787.5, ["Neon|Fly|Ride"] = 2625, ["Mega"] = 11158.8, ["Mega|Fly|Ride"] = 10836.59}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 912.19, ["Fly"] = 1076.25, ["Ride"] = 931.88, ["Fly|Ride"] = 1141.88, ["Neon|Fly|Ride"] = 3856.99, ["Mega|Fly|Ride"] = 8368.84}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 19.67, ["Fly"] = 56.51, ["Ride"] = 51.18, ["Fly|Ride"] = 83.7, ["Neon"] = 91.88, ["Neon|Ride"] = 154.48, ["Neon|Fly|Ride"] = 209.76, ["Mega|Fly|Ride"] = 697.76}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 28.26}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 55.08, ["Fly"] = 108.39, ["Ride"] = 75.47, ["Fly|Ride"] = 140.18, ["Neon|Ride"] = 395.38, ["Neon|Fly|Ride"] = 380.63, ["Mega|Fly|Ride"] = 1485.47}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 92.22, ["Fly"] = 209.24, ["Ride"] = 118.13, ["Fly|Ride"] = 170.63, ["Neon"] = 441, ["Neon|Ride"] = 559.58, ["Neon|Fly|Ride"] = 15368.45, ["Mega"] = 2108.14, ["Mega|Ride"] = 1673.79, ["Mega|Fly|Ride"] = 1585.9}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 3.93, ["Fly"] = 44.98, ["Ride"] = 18.38, ["Fly|Ride"] = 54.41, ["Neon"] = 28.26, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 558.64, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 374.79}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 69.54, ["Fly"] = 93.19, ["Ride"] = 87.94, ["Fly|Ride"] = 145.69, ["Neon"] = 1116.21, ["Neon|Ride"] = 362.25, ["Neon|Fly|Ride"] = 304.5, ["Mega|Fly|Ride"] = 1153.69}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 3.67, ["Fly"] = 42, ["Ride"] = 31.13, ["Fly|Ride"] = 69.91, ["Neon"] = 39.9, ["Neon|Fly"] = 265.72, ["Neon|Ride"] = 91.65, ["Neon|Fly|Ride"] = 558.64, ["Mega"] = 103.69, ["Mega|Fly"] = 1116.21, ["Mega|Ride"] = 283.56, ["Mega|Fly|Ride"] = 392.44}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 15.62, ["Fly"] = 65.63, ["Ride"] = 39.38, ["Fly|Ride"] = 104.63, ["Neon"] = 262.5, ["Neon|Ride"] = 112.18, ["Neon|Fly|Ride"] = 167.4, ["Mega"] = 1050, ["Mega|Fly|Ride"] = 614.09}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 39.38, ["Ride"] = 291.38, ["Fly|Ride"] = 272, ["Neon"] = 177.85, ["Neon|Ride"] = 341.22, ["Neon|Fly|Ride"] = 131.25, ["Mega|Ride"] = 2092.22, ["Mega|Fly|Ride"] = 781.35}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 15.7, ["Fly"] = 85.6, ["Ride"] = 91.88, ["Fly|Ride"] = 79.52, ["Neon"] = 96.26, ["Neon|Ride"] = 170.62, ["Neon|Fly|Ride"] = 167.4, ["Mega"] = 627.68, ["Mega|Ride"] = 906.98, ["Mega|Fly|Ride"] = 921.63}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6917.32, ["Fly"] = 5439.75, ["Ride"] = 5250, ["Fly|Ride"] = 5103.25, ["Neon"] = 30687.45, ["Neon|Fly|Ride"] = 25665.11, ["Mega|Fly|Ride"] = 97622.37}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 229.69, ["Fly"] = 251.08, ["Ride"] = 246.75, ["Fly|Ride"] = 279.33, ["Neon|Fly|Ride"] = 547.32, ["Mega|Fly|Ride"] = 2056.41}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 26.22, ["Fly"] = 78.75, ["Ride"] = 44.3, ["Fly|Ride"] = 117.79, ["Neon"] = 73.5, ["Neon|Fly"] = 140.19, ["Neon|Ride"] = 93.48, ["Neon|Fly|Ride"] = 251.76, ["Mega"] = 301.88, ["Mega|Fly"] = 509.46, ["Mega|Ride"] = 290.07, ["Mega|Fly|Ride"] = 404.86}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 3.26, ["Fly"] = 40.37, ["Ride"] = 20.96, ["Fly|Ride"] = 98.35, ["Neon"] = 21, ["Neon|Ride"] = 52.5, ["Mega"] = 170.63}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 26.19, ["Fly"] = 98.35, ["Ride"] = 65.05, ["Fly|Ride"] = 132.86, ["Neon"] = 118.44, ["Neon|Fly"] = 330.85, ["Neon|Ride"] = 174.57, ["Neon|Fly|Ride"] = 229.69, ["Mega"] = 418.41, ["Mega|Ride"] = 448.02, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 18571.88, ["Ride"] = 11519.82, ["Fly|Ride"] = 11550, ["Neon|Fly|Ride"] = 23625}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 124.5, ["Ride"] = 178.49, ["Fly|Ride"] = 276.19, ["Neon"] = 2092.22, ["Neon|Fly|Ride"] = 1085.86, ["Mega|Fly|Ride"] = 4610.31}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 42.84, ["Fly"] = 459.38, ["Ride"] = 45.94, ["Fly|Ride"] = 100.3, ["Neon|Fly"] = 461.12, ["Neon|Ride"] = 263.63, ["Neon|Fly|Ride"] = 341.25, ["Mega|Fly|Ride"] = 1112.02}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 12.7, ["Ride"] = 36.63, ["Fly|Ride"] = 61.73, ["Neon"] = 61.87, ["Neon|Ride"] = 83.69, ["Neon|Fly|Ride"] = 139.13, ["Mega"] = 2510.67, ["Mega|Ride"] = 492.19, ["Mega|Fly|Ride"] = 1046.12}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 328.13, ["Fly"] = 836.91, ["Ride"] = 425.25, ["Fly|Ride"] = 446.25, ["Neon"] = 1534.46, ["Neon|Ride"] = 1323, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 5509.85}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 3.94, ["Fly"] = 46.13, ["Ride"] = 38.07, ["Fly|Ride"] = 140.19, ["Neon"] = 19.69, ["Neon|Ride"] = 98.35, ["Neon|Fly|Ride"] = 139.13, ["Mega"] = 136.27, ["Mega|Ride"] = 178.5, ["Mega|Fly|Ride"] = 251.08}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 111.57, ["Fly"] = 157.5, ["Ride"] = 154.51, ["Fly|Ride"] = 196.88, ["Neon"] = 490.83, ["Neon|Ride"] = 450.82, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 1574.99, ["Mega|Ride"] = 1673.79, ["Mega|Fly|Ride"] = 1809.77}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 18.38, ["Fly"] = 20.24, ["Ride"] = 18.68, ["Fly|Ride"] = 35.44, ["Neon|Fly"] = 140.19, ["Neon|Ride"] = 101.43, ["Neon|Fly|Ride"] = 81.38, ["Mega"] = 2510.67, ["Mega|Fly|Ride"] = 569.09}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 7.88}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 64.32, ["Ride"] = 111.95, ["Fly|Ride"] = 525, ["Neon"] = 393.75, ["Neon|Fly"] = 1673.79, ["Neon|Ride"] = 413.23, ["Neon|Fly|Ride"] = 417.35, ["Mega|Ride"] = 1383.11, ["Mega|Fly|Ride"] = 1521.41}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 14.44, ["Ride"] = 31.12, ["Fly|Ride"] = 77.42, ["Neon"] = 92.24, ["Neon|Ride"] = 98.34, ["Neon|Fly|Ride"] = 231.21, ["Mega|Fly|Ride"] = 921.09}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 16.02}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 34.13, ["Fly"] = 210, ["Ride"] = 78.47, ["Fly|Ride"] = 276.67, ["Neon"] = 133.88, ["Neon|Ride"] = 104.63, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 689.39, ["Mega|Ride"] = 795.05, ["Mega|Fly|Ride"] = 656.24}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.83, ["Ride"] = 31.14, ["Neon"] = 21.92, ["Neon|Ride"] = 137.06, ["Neon|Fly|Ride"] = 321.57, ["Mega"] = 108.61, ["Mega|Ride"] = 279.33, ["Mega|Fly|Ride"] = 404.86}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 14.43, ["Ride"] = 28.25, ["Fly|Ride"] = 91.87, ["Neon"] = 140.19, ["Neon|Ride"] = 154.88, ["Neon|Fly|Ride"] = 146.47, ["Mega"] = 696.72, ["Mega|Ride"] = 615.48, ["Mega|Fly|Ride"] = 688.35}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 393.75, ["Fly"] = 437.75, ["Ride"] = 315, ["Fly|Ride"] = 335.98, ["Neon|Fly|Ride"] = 1667.51, ["Mega|Fly|Ride"] = 8787.28}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 37.91, ["Ride"] = 103.58, ["Fly|Ride"] = 136.5, ["Neon"] = 209.24, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 334.77, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 697.76}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 53.82, ["Ride"] = 53.82, ["Fly|Ride"] = 91.88, ["Neon"] = 836.91, ["Neon|Ride"] = 834.81, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1334.84}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 15.74, ["Ride"] = 52.87, ["Fly|Ride"] = 131.23, ["Neon"] = 94.5, ["Neon|Ride"] = 123.36, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 615.48, ["Mega|Ride"] = 336, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 11067.7, ["Ride"] = 11067.86, ["Fly|Ride"] = 8124.38, ["Neon|Fly|Ride"] = 16863, ["Mega|Fly|Ride"] = 39372.9}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 2232.57, ["Ride"] = 2034.38, ["Fly|Ride"] = 1966.79, ["Neon"] = 4593.75, ["Neon|Fly|Ride"] = 4462.5, ["Mega|Fly|Ride"] = 18441.21}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 328.13, ["Ride"] = 439.39, ["Fly|Ride"] = 599.45, ["Neon"] = 1395.52, ["Neon|Ride"] = 1384.69, ["Neon|Fly|Ride"] = 1367.27, ["Mega"] = 16737.67, ["Mega|Fly|Ride"] = 6381.25}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 13.1, ["Fly"] = 26.25, ["Ride"] = 18.38, ["Fly|Ride"] = 50.74, ["Neon"] = 125.55, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 279.33, ["Mega|Fly|Ride"] = 404.86}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 3.94, ["Fly"] = 131.25, ["Ride"] = 61.69, ["Fly|Ride"] = 153.57, ["Neon"] = 24.93, ["Neon|Ride"] = 65.63, ["Mega"] = 105, ["Mega|Ride"] = 209.24, ["Mega|Fly|Ride"] = 232.32}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 39.36, ["Fly"] = 42, ["Ride"] = 43.32, ["Fly|Ride"] = 93.56, ["Neon|Ride"] = 195.57, ["Neon|Fly|Ride"] = 154.34, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.4, ["Fly"] = 25.38, ["Ride"] = 15.74, ["Fly|Ride"] = 44.63, ["Neon"] = 25.38, ["Neon|Ride"] = 36.63, ["Neon|Fly|Ride"] = 87.94, ["Mega"] = 219, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 255.94}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 261.19, ["Fly"] = 317.63, ["Ride"] = 282.19, ["Fly|Ride"] = 360.94, ["Neon"] = 1150.73, ["Neon|Ride"] = 1383.31, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 3343.36}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 26.14, ["Fly"] = 56.51, ["Ride"] = 28.25, ["Fly|Ride"] = 85.32, ["Neon"] = 278.28, ["Neon|Fly"] = 461.12, ["Neon|Ride"] = 178.9, ["Neon|Fly|Ride"] = 236.25, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 1144.45}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 10.5, ["Fly"] = 19.9, ["Ride"] = 18.38, ["Fly|Ride"] = 46.04, ["Neon"] = 62.27, ["Neon|Fly"] = 136.5, ["Neon|Ride"] = 108.38, ["Neon|Fly|Ride"] = 116.82, ["Mega"] = 523.06, ["Mega|Ride"] = 576.42, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 249.38, ["Fly"] = 787.5, ["Ride"] = 465.94, ["Fly|Ride"] = 679.97, ["Mega|Fly|Ride"] = 8090.57}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1047.37, ["Ride"] = 1211.4, ["Fly|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 17656.14}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 96.26, ["Fly"] = 107.77, ["Ride"] = 87.94, ["Fly|Ride"] = 89.25, ["Neon"] = 558.64, ["Neon|Ride"] = 414.75, ["Neon|Fly|Ride"] = 461.05, ["Mega|Fly|Ride"] = 1312.49}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 194.25, ["Fly"] = 251.08, ["Ride"] = 226.83, ["Fly|Ride"] = 195.57, ["Neon"] = 261.54, ["Neon|Ride"] = 892.5, ["Neon|Fly|Ride"] = 569.51, ["Mega|Ride"] = 7290.94, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 24.94, ["Ride"] = 64.32, ["Neon"] = 274.1, ["Neon|Ride"] = 279.33, ["Neon|Fly|Ride"] = 836.91, ["Mega|Ride"] = 948.83, ["Mega|Fly|Ride"] = 1031.57}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 143.07, ["Ride"] = 575.37, ["Fly|Ride"] = 597.19, ["Neon"] = 1534.64, ["Neon|Ride"] = 1255.34, ["Neon|Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 2985.59}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 1534.32, ["Fly"] = 2510.67, ["Ride"] = 2023.18, ["Fly|Ride"] = 1967.44, ["Neon|Fly|Ride"] = 6562.49, ["Mega|Fly|Ride"] = 31657.78}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 33.49, ["Ride"] = 69.05, ["Fly|Ride"] = 260.54, ["Neon"] = 287.69, ["Neon|Ride"] = 209.24, ["Neon|Fly|Ride"] = 229.69, ["Mega"] = 1954.13, ["Mega|Ride"] = 2301.45, ["Mega|Fly|Ride"] = 1958.32}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 628.69, ["Fly"] = 675.94, ["Ride"] = 553.88, ["Fly|Ride"] = 628.69, ["Neon"] = 1395.52, ["Neon|Ride"] = 1452.01, ["Neon|Fly|Ride"] = 1245.57, ["Mega|Fly|Ride"] = 2782.5}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 56.51, ["Fly"] = 62.78, ["Ride"] = 47.25, ["Fly|Ride"] = 112.11, ["Neon"] = 208.2, ["Neon|Ride"] = 138.34, ["Neon|Fly|Ride"] = 207.15, ["Mega|Fly|Ride"] = 828.53}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 2.63, ["Fly"] = 28.26, ["Ride"] = 23.02, ["Fly|Ride"] = 44.63, ["Neon"] = 19.62, ["Neon|Fly"] = 52.47, ["Neon|Ride"] = 34.59, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 117.7, ["Mega|Ride"] = 154.84, ["Mega|Fly|Ride"] = 215.25}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 48.57, ["Ride"] = 62.27, ["Fly|Ride"] = 252, ["Neon"] = 697.76, ["Neon|Ride"] = 767.86, ["Mega"] = 1383.11, ["Mega|Ride"] = 1116.21, ["Mega|Fly|Ride"] = 6974.39}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 523.69, ["Fly"] = 1130.99, ["Ride"] = 535.5, ["Fly|Ride"] = 620.27, ["Neon"] = 2305.51, ["Neon|Ride"] = 2232.4, ["Neon|Fly|Ride"] = 1907.07, ["Mega|Fly|Ride"] = 5775}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 525, ["Ride"] = 523.69, ["Fly|Ride"] = 682.5, ["Neon"] = 8368.84, ["Neon|Ride"] = 4068.75, ["Neon|Fly|Ride"] = 2441.25, ["Mega|Fly|Ride"] = 17749.25}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 12.56, ["Fly"] = 41.86, ["Ride"] = 26.25, ["Fly|Ride"] = 40.68, ["Neon"] = 140.19, ["Neon|Ride"] = 86.46, ["Neon|Fly|Ride"] = 104.63, ["Mega|Fly|Ride"] = 615.02}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 7.82, ["Ride"] = 22.32, ["Fly|Ride"] = 78.47, ["Neon"] = 52.5, ["Neon|Ride"] = 83.7, ["Neon|Fly|Ride"] = 182.13, ["Mega"] = 458.2, ["Mega|Ride"] = 458.2, ["Mega|Fly|Ride"] = 615.48}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 2.63, ["Ride"] = 26.25, ["Fly|Ride"] = 89.98, ["Neon"] = 17.71, ["Neon|Fly"] = 307.8, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 279.33, ["Mega"] = 138.08, ["Mega|Ride"] = 123.38, ["Mega|Fly|Ride"] = 251.99}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 39.77, ["Fly"] = 56.51, ["Ride"] = 45.94, ["Fly|Ride"] = 110.25, ["Neon"] = 249.01, ["Neon|Ride"] = 207.15, ["Neon|Fly|Ride"] = 196.88, ["Mega|Fly|Ride"] = 802.04}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 24.98, ["Ride"] = 86.63, ["Fly|Ride"] = 615.58, ["Neon"] = 279.33, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1116.21, ["Mega|Ride"] = 1044.03, ["Mega|Fly|Ride"] = 1241.75}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 15.69, ["Fly"] = 57.14, ["Ride"] = 41.85, ["Fly|Ride"] = 87.89, ["Neon"] = 77.33, ["Neon|Ride"] = 92.93, ["Neon|Fly|Ride"] = 191.34, ["Mega|Ride"] = 349.41, ["Mega|Fly|Ride"] = 470.76}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 36.91, ["Fly"] = 83.7, ["Ride"] = 36.74, ["Fly|Ride"] = 92.22, ["Neon|Ride"] = 140.19, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 2100, ["Mega|Fly|Ride"] = 1011.72}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.91, ["Fly"] = 37.67, ["Ride"] = 20.93, ["Fly|Ride"] = 40.69, ["Neon"] = 31.4, ["Neon|Ride"] = 35.58, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 1673.79, ["Mega|Ride"] = 461.05, ["Mega|Fly|Ride"] = 395.45}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 3.89, ["Ride"] = 26.18, ["Fly|Ride"] = 81.9, ["Neon"] = 19.43, ["Neon|Fly"] = 154.48, ["Neon|Ride"] = 49.24, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 416.07, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 35.44, ["Fly"] = 98.43, ["Ride"] = 53.76, ["Fly|Ride"] = 90.57, ["Neon"] = 418.46, ["Neon|Ride"] = 230.57, ["Neon|Fly|Ride"] = 216.57, ["Mega|Fly|Ride"] = 1074.94}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 2386.13, ["Fly"] = 4882.17, ["Ride"] = 2177.44, ["Fly|Ride"] = 1932, ["Neon"] = 6276.63, ["Neon|Fly|Ride"] = 5074.13, ["Mega|Fly|Ride"] = 13948.76}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 462, ["Fly"] = 576.34, ["Ride"] = 414.75, ["Fly|Ride"] = 508.44, ["Neon"] = 3074.4, ["Neon|Ride"] = 3069.28, ["Neon|Fly|Ride"] = 1704.94, ["Mega|Fly|Ride"] = 7875}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 262.5, ["Ride"] = 315, ["Fly|Ride"] = 367.5, ["Neon"] = 1325.43, ["Neon|Ride"] = 1569.17, ["Neon|Fly|Ride"] = 1983.42, ["Mega|Fly|Ride"] = 5775}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 38.06}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 26.24, ["Fly"] = 65.63, ["Ride"] = 57.7, ["Fly|Ride"] = 78.75, ["Neon"] = 288.75, ["Neon|Ride"] = 265.69, ["Neon|Fly|Ride"] = 418.98, ["Mega|Ride"] = 1464.57, ["Mega|Fly|Ride"] = 1229.82}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 30687.45, ["Fly"] = 23625, ["Ride"] = 34587.03, ["Fly|Ride"] = 15356.25, ["Neon|Fly|Ride"] = 33475.32, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 236.25, ["Fly"] = 471.8, ["Ride"] = 236.25, ["Fly|Ride"] = 286.78, ["Neon"] = 767.86, ["Neon|Fly"] = 1085.9, ["Neon|Ride"] = 697.76, ["Neon|Fly|Ride"] = 652.32, ["Mega"] = 3474.12, ["Mega|Ride"] = 4911.46, ["Mega|Fly|Ride"] = 2425.5}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 140.19, ["Ride"] = 124.69, ["Fly|Ride"] = 257.25, ["Neon|Fly|Ride"] = 1690.85, ["Mega|Fly|Ride"] = 4045.29}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 102.38, ["Ride"] = 106.32, ["Fly|Ride"] = 169.32, ["Neon|Ride"] = 523.06, ["Neon|Fly|Ride"] = 523.06, ["Mega"] = 13948.76, ["Mega|Fly|Ride"] = 3124.89}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 14.44, ["Fly"] = 94.5, ["Ride"] = 28.29, ["Fly|Ride"] = 83.7, ["Neon|Ride"] = 135.19, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 615.48, ["Mega|Ride"] = 594.74}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 3281.25, ["Ride"] = 3353.44, ["Fly|Ride"] = 3543.75, ["Neon|Fly|Ride"] = 13948.76}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 26.12, ["Fly"] = 41.86, ["Ride"] = 32.17, ["Fly|Ride"] = 65.63, ["Neon"] = 131.25, ["Neon|Ride"] = 154.48, ["Neon|Fly|Ride"] = 168, ["Mega|Fly|Ride"] = 623.44}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 45.3, ["Fly"] = 69.19, ["Ride"] = 49.7, ["Fly|Ride"] = 104.95, ["Neon"] = 147.56, ["Neon|Ride"] = 278.28, ["Neon|Fly|Ride"] = 217.6, ["Mega"] = 973.94, ["Mega|Fly|Ride"] = 921.63}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 551.25, ["Fly"] = 656.25, ["Ride"] = 551.25, ["Fly|Ride"] = 669.38, ["Neon"] = 1676.63, ["Neon|Ride"] = 1544.68, ["Neon|Fly|Ride"] = 1312.5, ["Mega"] = 4463.74, ["Mega|Ride"] = 8889.81, ["Mega|Fly|Ride"] = 3937.49}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 15.75, ["Fly"] = 23.63, ["Ride"] = 24.94, ["Fly|Ride"] = 56.51, ["Neon"] = 125.55, ["Neon|Ride"] = 104.63, ["Neon|Fly|Ride"] = 125.95, ["Mega"] = 697.76, ["Mega|Fly|Ride"] = 461.64}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 11.82, ["Ride"] = 59.07, ["Fly|Ride"] = 136.01, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 157.5}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 103.69, ["Ride"] = 115.5, ["Fly|Ride"] = 165.38, ["Neon"] = 693.58, ["Neon|Ride"] = 615.58, ["Neon|Fly|Ride"] = 551.25, ["Mega|Ride"] = 2351.65, ["Mega|Fly|Ride"] = 3488.77}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 22.32, ["Fly"] = 91.88, ["Ride"] = 77.21, ["Fly|Ride"] = 136.01, ["Neon"] = 84, ["Neon|Ride"] = 140.19, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 207.15, ["Mega|Fly"] = 807.19, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 444.29}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3791.37, ["Ride"] = 3281.25, ["Fly|Ride"] = 3071.25, ["Neon"] = 12296.4, ["Neon|Ride"] = 16908.54, ["Neon|Fly|Ride"] = 7213.5, ["Mega"] = 62766.2, ["Mega|Fly|Ride"] = 38419.94}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 40.69, ["Fly"] = 210, ["Ride"] = 73.22, ["Fly|Ride"] = 104.63, ["Neon"] = 154.48, ["Neon|Ride"] = 207.47, ["Neon|Fly|Ride"] = 367.5, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 6974.39, ["Ride"] = 8300.9, ["Fly|Ride"] = 5512.5, ["Neon|Fly|Ride"] = 14645.47, ["Mega|Fly|Ride"] = 62697.16}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.63, ["Fly"] = 19.69, ["Ride"] = 18.38, ["Fly|Ride"] = 34.59, ["Neon"] = 20.93, ["Neon|Fly"] = 104.63, ["Neon|Ride"] = 37.67, ["Neon|Fly|Ride"] = 77.33, ["Mega"] = 446.06, ["Mega|Fly|Ride"] = 215.55}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 15.7, ["Fly"] = 35.44, ["Ride"] = 31.4, ["Fly|Ride"] = 73.24, ["Neon"] = 140.19, ["Neon|Ride"] = 279.33, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 1401.1, ["Mega|Fly|Ride"] = 919.77}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 13.13, ["Ride"] = 28.88, ["Fly|Ride"] = 140.18, ["Neon"] = 63, ["Neon|Ride"] = 192.94, ["Neon|Fly|Ride"] = 229.38, ["Mega|Ride"] = 696.72, ["Mega|Fly|Ride"] = 836.91}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 39.38, ["Fly"] = 41.86, ["Ride"] = 70.1, ["Fly|Ride"] = 154.48, ["Neon"] = 177.09, ["Neon|Ride"] = 178.9, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 840, ["Mega|Ride"] = 616.88, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 11.51, ["Fly"] = 29.99, ["Ride"] = 17.07, ["Fly|Ride"] = 39.38, ["Neon"] = 184.46, ["Neon|Ride"] = 96.26, ["Neon|Fly|Ride"] = 138.1, ["Mega"] = 2510.67, ["Mega|Fly|Ride"] = 615.48}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 7994.11}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2818.22}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 23.49}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 305.48, ["Fly"] = 418.46, ["Ride"] = 313.85, ["Fly|Ride"] = 656.25, ["Neon|Fly|Ride"] = 1785.71, ["Mega|Fly|Ride"] = 5579.93}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 19.69, ["Fly"] = 131.82, ["Ride"] = 52.5, ["Fly|Ride"] = 138.34, ["Neon"] = 199.79, ["Neon|Ride"] = 406.88, ["Mega|Ride"] = 558.64, ["Mega|Fly|Ride"] = 627.68}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 10.48}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 7.86, ["Neon"] = 98.35, ["Neon|Ride"] = 249.38}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2231.25}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 141.75, ["Ride"] = 261.73, ["Fly|Ride"] = 287.69, ["Neon"] = 722.79, ["Neon|Ride"] = 698.96, ["Neon|Fly|Ride"] = 836.91, ["Mega|Fly|Ride"] = 2036.78}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 109.81, ["Ride"] = 167.4, ["Fly|Ride"] = 418.46, ["Neon"] = 468.66, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 3399.84, ["Mega|Ride"] = 1575, ["Mega|Fly|Ride"] = 1569.17}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 189, ["Fly"] = 279.33, ["Ride"] = 194.25, ["Fly|Ride"] = 199.5, ["Neon"] = 820.32, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 755.5, ["Mega|Fly|Ride"] = 2937.38}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1089.38, ["Fly"] = 2510.67, ["Ride"] = 1230.16, ["Fly|Ride"] = 1097.97, ["Neon|Fly|Ride"] = 4593.75, ["Mega|Fly|Ride"] = 20922.07}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 12.96, ["Fly"] = 108.39, ["Ride"] = 46.04, ["Fly|Ride"] = 78.75, ["Neon"] = 52.5, ["Neon|Ride"] = 140.19, ["Neon|Fly|Ride"] = 437.07, ["Mega"] = 922.08, ["Mega|Fly|Ride"] = 906.98}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 654.94, ["Fly"] = 2100, ["Ride"] = 627.68, ["Fly|Ride"] = 826.88, ["Neon|Fly|Ride"] = 3995.99}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 55.77}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 15.65, ["Fly"] = 144.38, ["Ride"] = 39.38, ["Fly|Ride"] = 98.35, ["Neon"] = 66.96, ["Neon|Ride"] = 154.48, ["Neon|Fly|Ride"] = 488.54, ["Mega"] = 437.99, ["Mega|Ride"] = 418.69, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 5.76, ["Fly"] = 345.89, ["Ride"] = 33.49, ["Fly|Ride"] = 91.88, ["Neon"] = 35.58, ["Neon|Ride"] = 98.35, ["Neon|Fly|Ride"] = 125.55, ["Mega|Ride"] = 389.17, ["Mega|Fly|Ride"] = 418.46}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 78.69}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 26.22, ["Ride"] = 26.25, ["Fly|Ride"] = 65.54, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 278.28, ["Mega|Ride"] = 836.91, ["Mega|Fly|Ride"] = 596.23}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 39.77, ["Fly"] = 39.38, ["Ride"] = 50.61, ["Fly|Ride"] = 64.97, ["Neon"] = 154.48, ["Neon|Fly"] = 239.78, ["Neon|Ride"] = 274.1, ["Neon|Fly|Ride"] = 307.75, ["Mega"] = 1393.43, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 5974.5, ["Fly"] = 11158.8, ["Ride"] = 5858.2, ["Fly|Ride"] = 5092.5, ["Neon|Fly|Ride"] = 9712.5, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 10.5, ["Fly"] = 79.52, ["Ride"] = 31.14, ["Fly|Ride"] = 98.58, ["Neon"] = 65.61, ["Neon|Fly"] = 119.27, ["Neon|Ride"] = 85.31, ["Neon|Fly|Ride"] = 276.93, ["Mega"] = 530.39, ["Mega|Ride"] = 384.98, ["Mega|Fly|Ride"] = 460.88}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 24.91}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 111.57, ["Fly"] = 370.34, ["Ride"] = 154.61, ["Fly|Ride"] = 279.33, ["Neon"] = 417.38, ["Neon|Ride"] = 433.13, ["Neon|Fly|Ride"] = 558.64, ["Mega"] = 1393.43, ["Mega|Fly|Ride"] = 1588.13}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 61.68, ["Fly"] = 183.75, ["Ride"] = 114.19, ["Fly|Ride"] = 168, ["Neon"] = 236.25, ["Neon|Ride"] = 380.63, ["Neon|Fly|Ride"] = 525, ["Mega|Ride"] = 1337, ["Mega|Fly|Ride"] = 1223.96}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 22.32, ["Fly"] = 70.86, ["Ride"] = 27.57, ["Fly|Ride"] = 74.82, ["Neon"] = 279.33, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 175.88, ["Mega|Fly|Ride"] = 533.01}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 6.27, ["Fly"] = 49.49, ["Ride"] = 23.08, ["Fly|Ride"] = 78.75, ["Neon"] = 20.72, ["Neon|Fly"] = 182.04, ["Neon|Ride"] = 41.99, ["Neon|Fly|Ride"] = 154.44, ["Mega"] = 154.84, ["Mega|Ride"] = 171.94, ["Mega|Fly|Ride"] = 277.12}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 13.13, ["Ride"] = 28.26, ["Fly|Ride"] = 78.56, ["Neon"] = 51.85, ["Neon|Ride"] = 91.85, ["Neon|Fly|Ride"] = 149.63, ["Mega"] = 315, ["Mega|Ride"] = 419.99, ["Mega|Fly|Ride"] = 535.5}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 23.57, ["Fly"] = 27.5, ["Ride"] = 32.44, ["Fly|Ride"] = 54.6, ["Neon"] = 136.01, ["Neon|Fly"] = 209.24, ["Neon|Ride"] = 188.32, ["Neon|Fly|Ride"] = 131.25, ["Mega|Fly"] = 697.76, ["Mega|Fly|Ride"] = 585.83}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 249.38}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 15.7, ["Fly"] = 123.38, ["Ride"] = 103.85, ["Neon"] = 104.63, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 488.25, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 896.44}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 77.44, ["Ride"] = 207.15, ["Fly|Ride"] = 359.88, ["Neon|Ride"] = 417.38, ["Neon|Fly|Ride"] = 736.47}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 39.38, ["Ride"] = 91.88, ["Fly|Ride"] = 252.99, ["Neon"] = 249.38, ["Neon|Ride"] = 327.08, ["Neon|Fly|Ride"] = 525, ["Mega"] = 1128.75, ["Mega|Ride"] = 1690.85, ["Mega|Fly|Ride"] = 1233.75}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 656.25, ["Fly"] = 780.94, ["Ride"] = 691.69, ["Fly|Ride"] = 603.75, ["Neon|Ride"] = 2100, ["Neon|Fly|Ride"] = 2086.88, ["Mega|Fly|Ride"] = 8531.25}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 233.63, ["Ride"] = 346.5, ["Fly|Ride"] = 288.75, ["Neon"] = 1207.22, ["Neon|Ride"] = 1537.78, ["Neon|Fly|Ride"] = 1254.29, ["Mega"] = 8229.72, ["Mega|Ride"] = 4034.02, ["Mega|Fly|Ride"] = 4003.46}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 82.69}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 7.86, ["Fly"] = 23.09, ["Ride"] = 23.63, ["Fly|Ride"] = 48.57, ["Neon"] = 80.07, ["Neon|Fly"] = 230.99, ["Neon|Ride"] = 116.13, ["Neon|Fly|Ride"] = 125.55, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 405.57}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 291.38, ["Fly"] = 627.68, ["Ride"] = 334.69, ["Fly|Ride"] = 431.82, ["Neon"] = 1255.34, ["Neon|Ride"] = 945, ["Neon|Fly|Ride"] = 981.75, ["Mega|Fly|Ride"] = 3901.98}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 14.44}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 94.17, ["Fly"] = 178.12, ["Ride"] = 145.56, ["Fly|Ride"] = 262.22, ["Neon"] = 444.94, ["Neon|Fly"] = 1395.52, ["Neon|Ride"] = 486.94, ["Neon|Fly|Ride"] = 626.63, ["Mega"] = 2647.71, ["Mega|Fly|Ride"] = 1705.2}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 156.19, ["Ride"] = 118.13, ["Fly|Ride"] = 196.88, ["Neon|Ride"] = 997.5, ["Neon|Fly|Ride"] = 697.76}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 5.08, ["Ride"] = 38.85, ["Fly|Ride"] = 123.36, ["Neon"] = 19.69, ["Neon|Ride"] = 56.51, ["Neon|Fly|Ride"] = 167.4, ["Mega"] = 195.64, ["Mega|Ride"] = 202.08, ["Mega|Fly|Ride"] = 405.9}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 19.9, ["Fly"] = 49.88, ["Ride"] = 35.57, ["Fly|Ride"] = 56.51, ["Neon"] = 82.66, ["Neon|Ride"] = 95.21, ["Neon|Fly|Ride"] = 195.64}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 22.32, ["Fly"] = 140.19, ["Ride"] = 56.51, ["Fly|Ride"] = 105, ["Neon"] = 132.87, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 209.24, ["Mega"] = 508.31, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 551.32}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 6.09, ["Fly"] = 334.77, ["Ride"] = 39.38, ["Fly|Ride"] = 190.32, ["Neon"] = 17.05, ["Neon|Fly"] = 70.1, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 149.63, ["Mega"] = 108.94, ["Mega|Fly"] = 183.74, ["Mega|Ride"] = 154.72, ["Mega|Fly|Ride"] = 307.75}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 313.69, ["Fly"] = 918.75, ["Ride"] = 279.33, ["Fly|Ride"] = 414.15, ["Neon"] = 1673.79, ["Neon|Ride"] = 1246.88, ["Neon|Fly|Ride"] = 1378.13}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 104.63, ["Fly"] = 1050, ["Ride"] = 136.5, ["Fly|Ride"] = 236.43, ["Neon"] = 433.12, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 679.97, ["Mega"] = 2719.88, ["Mega|Ride"] = 6974.39, ["Mega|Fly|Ride"] = 2459.62}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 59.07, ["Fly"] = 154.84, ["Ride"] = 100.44, ["Fly|Ride"] = 131.24, ["Neon|Ride"] = 334.69, ["Neon|Fly|Ride"] = 420, ["Mega|Fly|Ride"] = 1311.82}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 17.18, ["Ride"] = 58.24, ["Fly|Ride"] = 279.33, ["Neon"] = 209.24, ["Neon|Ride"] = 585.61, ["Neon|Fly|Ride"] = 487.5, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 15.73, ["Ride"] = 39.22, ["Fly|Ride"] = 98.35, ["Neon"] = 111.57, ["Neon|Ride"] = 115.23, ["Neon|Fly|Ride"] = 157.33, ["Mega"] = 481.22, ["Mega|Fly"] = 525, ["Mega|Ride"] = 615.48, ["Mega|Fly|Ride"] = 615.48}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.51, ["Fly"] = 41.86, ["Ride"] = 26.54, ["Fly|Ride"] = 77.26, ["Neon"] = 15.7, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 108.46, ["Mega|Ride"] = 132.01, ["Mega|Fly|Ride"] = 246.89}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 997.5, ["Fly"] = 1199.03, ["Ride"] = 945, ["Fly|Ride"] = 918.75, ["Neon"] = 3488.77, ["Neon|Fly"] = 2824.49, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2415, ["Mega"] = 11856.55, ["Mega|Fly|Ride"] = 7481.25}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 301.88, ["Ride"] = 262.5, ["Fly|Ride"] = 393.74, ["Neon"] = 1046.12, ["Neon|Ride"] = 943.69, ["Neon|Fly|Ride"] = 1003.1, ["Mega"] = 10461.04, ["Mega|Ride"] = 5840.1, ["Mega|Fly|Ride"] = 3871.88}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 136.5, ["Ride"] = 138.36, ["Fly|Ride"] = 307.8, ["Neon"] = 384.57, ["Neon|Ride"] = 418.46, ["Neon|Fly|Ride"] = 376.62, ["Mega"] = 1640.63, ["Mega|Ride"] = 1673.79, ["Mega|Fly|Ride"] = 1464.57}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 177.19, ["Ride"] = 183.75, ["Fly|Ride"] = 288.75, ["Neon"] = 697.76, ["Neon|Ride"] = 905.63, ["Neon|Fly|Ride"] = 899.67, ["Mega"] = 10461.04, ["Mega|Fly|Ride"] = 2887.49}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 20.99, ["Fly"] = 48.14, ["Ride"] = 35.97, ["Fly|Ride"] = 68.25, ["Neon"] = 154.47, ["Neon|Ride"] = 104.63, ["Neon|Fly|Ride"] = 157.5, ["Mega|Ride"] = 691.56, ["Mega|Fly|Ride"] = 768.79}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 286.76, ["Ride"] = 398.16, ["Neon"] = 1332.75, ["Neon|Ride"] = 1353.68, ["Neon|Fly|Ride"] = 2405.01, ["Mega"] = 5250, ["Mega|Fly|Ride"] = 4331.24}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 118.21, ["Fly"] = 126, ["Ride"] = 140.19, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 679.97, ["Mega|Fly|Ride"] = 1998.57}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1246.88, ["Ride"] = 1388.2, ["Fly|Ride"] = 1312.49, ["Neon|Ride"] = 4045.29, ["Neon|Fly|Ride"] = 3918.77, ["Mega"] = 50212.97, ["Mega|Fly|Ride"] = 24409.8}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 15.72, ["Fly"] = 57.75, ["Ride"] = 33.49, ["Fly|Ride"] = 100.3, ["Neon"] = 35.44, ["Neon|Fly"] = 166.02, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 140.19, ["Mega"] = 305.82, ["Mega|Ride"] = 288.6, ["Mega|Fly|Ride"] = 431.33}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 64.78, ["Ride"] = 131.25, ["Fly|Ride"] = 126, ["Neon"] = 308.61, ["Neon|Ride"] = 316.32, ["Neon|Fly|Ride"] = 413.44, ["Mega"] = 1015.43, ["Mega|Fly|Ride"] = 921.63}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 77.31, ["Fly"] = 78.75, ["Ride"] = 69.83, ["Fly|Ride"] = 79.63, ["Neon|Ride"] = 560.73, ["Neon|Fly|Ride"] = 315, ["Mega|Fly|Ride"] = 1469.99}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 2509.62, ["Ride"] = 958.13, ["Fly|Ride"] = 1050, ["Neon|Fly|Ride"] = 4199.99, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 418.46, ["Ride"] = 455.06, ["Fly|Ride"] = 525, ["Neon|Ride"] = 1744.92, ["Neon|Fly|Ride"] = 1454.1, ["Mega|Fly|Ride"] = 5840.1}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 105, ["Fly"] = 209.24, ["Ride"] = 175.23, ["Fly|Ride"] = 249.82, ["Neon"] = 367.5, ["Neon|Ride"] = 454.65, ["Neon|Fly|Ride"] = 519.49, ["Mega"] = 4184.43, ["Mega|Ride"] = 1443.75, ["Mega|Fly|Ride"] = 1652.86}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 7.85, ["Ride"] = 28.32, ["Fly|Ride"] = 87.94, ["Neon"] = 74.28, ["Neon|Ride"] = 52.32, ["Neon|Fly|Ride"] = 233.63, ["Mega"] = 274.97, ["Mega|Ride"] = 508.59, ["Mega|Fly|Ride"] = 974.98}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 33.84, ["Fly"] = 70.1, ["Ride"] = 49.18, ["Fly|Ride"] = 87.63, ["Neon"] = 249.38, ["Neon|Fly"] = 292.92, ["Neon|Ride"] = 237.44, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 1813.96, ["Mega|Fly|Ride"] = 1049.99}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 813.75, ["Ride"] = 918.75, ["Fly|Ride"] = 1033.57, ["Neon|Fly|Ride"] = 2927.02, ["Mega|Fly|Ride"] = 17290.01}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 983.07}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 3179.53, ["Ride"] = 4173.75, ["Fly|Ride"] = 3360, ["Neon|Ride"] = 29982.38, ["Neon|Fly|Ride"] = 15750, ["Mega|Fly|Ride"] = 89268.18}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 140.19, ["Fly"] = 408.19, ["Ride"] = 167.4, ["Fly|Ride"] = 391.27, ["Neon"] = 627.68, ["Neon|Ride"] = 1230.01, ["Neon|Fly|Ride"] = 851.82, ["Mega"] = 5858.2, ["Mega|Fly|Ride"] = 5993.4}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 90.57, ["Ride"] = 108.39, ["Fly|Ride"] = 336, ["Neon|Ride"] = 1116.21, ["Neon|Fly|Ride"] = 977.07}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 14.44, ["Fly"] = 131.25, ["Ride"] = 28.3, ["Fly|Ride"] = 83.7, ["Neon"] = 96.26, ["Neon|Ride"] = 115.29, ["Neon|Fly|Ride"] = 195.57, ["Mega|Ride"] = 836.91, ["Mega|Fly|Ride"] = 517.83}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 20.43, ["Fly"] = 29.59, ["Ride"] = 22.32, ["Fly|Ride"] = 45.94, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 696.72}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 25.12, ["Ride"] = 32.82, ["Fly|Ride"] = 87.89, ["Neon"] = 111.95, ["Neon|Ride"] = 97.13, ["Neon|Fly|Ride"] = 187.69, ["Mega|Ride"] = 859.69, ["Mega|Fly|Ride"] = 676.85}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 3.92, ["Ride"] = 28.88, ["Fly|Ride"] = 56.51, ["Neon"] = 49.18, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 166.69, ["Mega|Fly|Ride"] = 357}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 24.94, ["Ride"] = 49.26, ["Fly|Ride"] = 118.13, ["Neon"] = 142.95, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 669.52, ["Mega|Ride"] = 628.69}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 273, ["Fly"] = 330.89, ["Ride"] = 257.25, ["Fly|Ride"] = 322.83, ["Neon"] = 721.83, ["Neon|Ride"] = 681.19, ["Neon|Fly|Ride"] = 623.44, ["Mega"] = 6562.5, ["Mega|Ride"] = 4184.43, ["Mega|Fly|Ride"] = 2785.78}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 3.15, ["Fly"] = 16.76, ["Ride"] = 13.12, ["Fly|Ride"] = 39.38, ["Neon"] = 20.86, ["Neon|Fly"] = 92.24, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 196.69, ["Mega|Ride"] = 207.15, ["Mega|Fly|Ride"] = 259.45}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 28.88, ["Fly"] = 115.5, ["Ride"] = 52.41, ["Fly|Ride"] = 111.57, ["Neon"] = 143.07, ["Neon|Fly"] = 500.05, ["Neon|Ride"] = 169.3, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 517.13, ["Mega|Ride"] = 520.99, ["Mega|Fly|Ride"] = 497.78}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 761.25, ["Ride"] = 768.75, ["Fly|Ride"] = 786.19, ["Neon|Ride"] = 1816.5, ["Neon|Fly|Ride"] = 1535.63, ["Mega|Fly|Ride"] = 4198.69}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 24.91, ["Fly"] = 43.32, ["Ride"] = 31.49, ["Fly|Ride"] = 78.62, ["Neon"] = 239.78, ["Neon|Fly"] = 461.12, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 179.82, ["Mega"] = 1575, ["Mega|Ride"] = 977.07, ["Mega|Fly|Ride"] = 835.01}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 317.63, ["Fly"] = 307.83, ["Ride"] = 262.49, ["Fly|Ride"] = 262.5, ["Neon"] = 1395.52, ["Neon|Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 4163.51}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 114.19, ["Fly"] = 139.13, ["Ride"] = 123.36, ["Fly|Ride"] = 166.01, ["Neon"] = 627.68, ["Neon|Fly"] = 636.05, ["Neon|Ride"] = 522.02, ["Neon|Fly|Ride"] = 558.64, ["Mega"] = 2929.11, ["Mega|Fly|Ride"] = 1730.06}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 649.69, ["Ride"] = 570.93, ["Fly|Ride"] = 551.25, ["Neon"] = 2630.58, ["Neon|Fly|Ride"] = 2411.07, ["Mega|Fly|Ride"] = 8996.5}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 19.69, ["Ride"] = 52.5, ["Neon"] = 91.62, ["Neon|Fly"] = 182.04, ["Neon|Ride"] = 118.6, ["Neon|Fly|Ride"] = 140.19, ["Mega"] = 315, ["Mega|Ride"] = 461.05, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 3719.63, ["Fly"] = 3912.97, ["Ride"] = 3936.19, ["Fly|Ride"] = 2887.5, ["Neon"] = 13913.19, ["Neon|Fly|Ride"] = 6829.51, ["Mega|Fly|Ride"] = 24967.36}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 77.44, ["Fly"] = 120.49, ["Ride"] = 112.88, ["Fly|Ride"] = 152.75, ["Neon"] = 394.78, ["Neon|Ride"] = 399.96, ["Neon|Fly|Ride"] = 400.32, ["Mega|Fly|Ride"] = 1774.2}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.41, ["Fly"] = 27.21, ["Ride"] = 19.69, ["Fly|Ride"] = 54.2, ["Neon"] = 18.38, ["Neon|Fly"] = 44.63, ["Neon|Ride"] = 28.3, ["Neon|Fly|Ride"] = 78.47, ["Mega"] = 109.33, ["Mega|Fly"] = 452.82, ["Mega|Ride"] = 140.19, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 2.61, ["Ride"] = 39.38, ["Neon"] = 17.82, ["Neon|Ride"] = 70.1, ["Neon|Fly|Ride"] = 266.44, ["Mega"] = 147, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 61.73, ["Fly"] = 65.63, ["Ride"] = 44.88, ["Fly|Ride"] = 70.1, ["Neon|Ride"] = 697.76, ["Neon|Fly|Ride"] = 240.19, ["Mega|Fly|Ride"] = 1241.75}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 767.86, ["Ride"] = 917.44, ["Fly|Ride"] = 977.07, ["Neon|Fly|Ride"] = 6147.85, ["Mega|Fly|Ride"] = 25106.49}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 5056.25, ["Ride"] = 5579.93, ["Fly|Ride"] = 4856.25}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 19.88, ["Fly"] = 48.25, ["Ride"] = 23.07, ["Fly|Ride"] = 43.31, ["Neon|Ride"] = 140.19, ["Neon|Fly|Ride"] = 130.23, ["Mega"] = 2510.67, ["Mega|Fly|Ride"] = 615.48}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 14.42, ["Fly"] = 41.86, ["Ride"] = 32.82, ["Fly|Ride"] = 91.88, ["Neon"] = 108.81, ["Neon|Ride"] = 75.64, ["Neon|Fly|Ride"] = 154.46, ["Mega"] = 922.08, ["Mega|Ride"] = 627.68, ["Mega|Fly|Ride"] = 536.74}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 38.07, ["Fly"] = 157.5, ["Ride"] = 49.59, ["Fly|Ride"] = 84, ["Neon"] = 393.75, ["Neon|Ride"] = 245.44, ["Neon|Fly|Ride"] = 330.74, ["Mega|Fly|Ride"] = 1121.11}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 217.88, ["Ride"] = 254.63, ["Fly|Ride"] = 313.85, ["Neon"] = 836.91, ["Neon|Ride"] = 1048.69, ["Neon|Fly|Ride"] = 1157.62, ["Mega"] = 10461.04, ["Mega|Fly|Ride"] = 4610.31}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.92, ["Neon"] = 20.98, ["Neon|Fly"] = 656.25, ["Neon|Fly|Ride"] = 140.19, ["Mega"] = 120.75, ["Mega|Ride"] = 269.88, ["Mega|Fly|Ride"] = 292.92}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 199.5, ["Ride"] = 231, ["Fly|Ride"] = 282.19, ["Neon"] = 695.63, ["Neon|Fly"] = 815.01, ["Neon|Ride"] = 628.69, ["Neon|Fly|Ride"] = 733.68, ["Mega|Fly|Ride"] = 2624.99}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 2.63, ["Fly"] = 73.5, ["Ride"] = 15.74, ["Fly|Ride"] = 38.07, ["Neon"] = 66.96, ["Neon|Ride"] = 34.59, ["Neon|Fly|Ride"] = 105, ["Mega"] = 461.05, ["Mega|Ride"] = 195.64, ["Mega|Fly|Ride"] = 446.06}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 203.7, ["Fly"] = 322.22, ["Ride"] = 195.61, ["Fly|Ride"] = 275.63, ["Neon|Fly|Ride"] = 894.43, ["Mega"] = 10461.04, ["Mega|Fly|Ride"] = 3626.41}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 12.55, ["Fly"] = 418.46, ["Ride"] = 28.26, ["Fly|Ride"] = 83.69, ["Neon"] = 48.14, ["Neon|Fly"] = 292.82, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 391.27, ["Mega"] = 509.46, ["Mega|Ride"] = 585.83, ["Mega|Fly|Ride"] = 447.75}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 3.93, ["Ride"] = 28.88, ["Fly|Ride"] = 131.25, ["Neon"] = 19.63, ["Neon|Fly"] = 170.63, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 76.13, ["Mega|Fly"] = 418.46, ["Mega|Ride"] = 123.35, ["Mega|Fly|Ride"] = 213.94}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 4.98, ["Mega"] = 25.87, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 166.35}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 2.1, ["Ride"] = 37.67, ["Fly|Ride"] = 217.6, ["Neon"] = 10.5, ["Neon|Ride"] = 41.51, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 102.54, ["Mega|Fly"] = 153677.37, ["Mega|Ride"] = 94.5, ["Mega|Fly|Ride"] = 252.99}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 65.63, ["Fly"] = 140.19, ["Ride"] = 116.12, ["Fly|Ride"] = 134.53, ["Neon"] = 262.5, ["Neon|Ride"] = 279.33, ["Neon|Fly|Ride"] = 367.5, ["Mega|Ride"] = 1311.19, ["Mega|Fly|Ride"] = 1241.75}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 45.85, ["Ride"] = 18.38, ["Fly|Ride"] = 53.81, ["Neon"] = 3.94, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 129.94, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 9.19, ["Ride"] = 91.88, ["Neon"] = 170.63, ["Mega"] = 380.63, ["Mega|Ride"] = 558.64}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.05, ["Neon"] = 2.1, ["Neon|Ride"] = 77.42, ["Neon|Fly|Ride"] = 154.46, ["Mega"] = 17.31, ["Mega|Ride"] = 86.84, ["Mega|Fly|Ride"] = 170.29}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 18, ["Fly|Ride"] = 35.58, ["Neon"] = 2.1, ["Neon|Fly"] = 15.75, ["Neon|Ride"] = 11.82, ["Neon|Fly|Ride"] = 77.17, ["Mega"] = 14.44, ["Mega|Ride"] = 24.94, ["Mega|Fly|Ride"] = 52.5}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 15.7, ["Ride"] = 138.41, ["Fly|Ride"] = 45.52, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 46.12, ["Mega"] = 15.74, ["Mega|Ride"] = 48.42, ["Mega|Fly|Ride"] = 102.38}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.05, ["Ride"] = 27.21, ["Neon"] = 2.63, ["Mega"] = 104.91, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 31.39, ["Ride"] = 17.45, ["Fly|Ride"] = 107.63, ["Neon"] = 6.28, ["Neon|Ride"] = 35.58, ["Neon|Fly|Ride"] = 77.31, ["Mega"] = 49.18, ["Mega|Fly"] = 91.88, ["Mega|Fly|Ride"] = 161.44}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 4.99, ["Neon|Fly|Ride"] = 204.75, ["Mega"] = 19.66, ["Mega|Ride"] = 101.07}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 3.29, ["Fly"] = 46.78, ["Ride"] = 15.74, ["Fly|Ride"] = 53.04, ["Neon"] = 6.57, ["Neon|Fly"] = 37.96, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 72.19, ["Mega|Fly"] = 108.81, ["Mega|Ride"] = 107.41, ["Mega|Fly|Ride"] = 140.19}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 26.17, ["Mega"] = 13.13, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.97, ["Ride"] = 141.24, ["Fly|Ride"] = 525, ["Neon"] = 17.07, ["Mega"] = 182.04, ["Mega|Ride"] = 157.5}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 4.76, ["Ride"] = 79.52, ["Neon"] = 21}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Neon"] = 6.56, ["Neon|Ride"] = 103.95, ["Neon|Fly|Ride"] = 70.1, ["Mega"] = 37.67, ["Mega|Ride"] = 171.75, ["Mega|Fly|Ride"] = 279.33}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 29.99, ["Ride"] = 16.75, ["Fly|Ride"] = 45, ["Neon"] = 2.1, ["Neon|Fly"] = 35.58, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 41.88, ["Mega"] = 15.7, ["Mega|Ride"] = 26.55, ["Mega|Fly|Ride"] = 45.94}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.5, ["Fly"] = 72.19, ["Ride"] = 42, ["Fly|Ride"] = 104.63, ["Neon"] = 27.57, ["Neon|Ride"] = 39.38, ["Mega|Ride"] = 349.41}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.63, ["Ride"] = 42, ["Fly|Ride"] = 78.73, ["Neon"] = 4.17, ["Neon|Ride"] = 41.86, ["Neon|Fly|Ride"] = 87.89, ["Mega"] = 27.56, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 2.1, ["Ride"] = 70.1, ["Neon"] = 9.16, ["Neon|Fly|Ride"] = 140.19, ["Mega"] = 84, ["Mega|Ride"] = 233.63}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 4.19, ["Fly"] = 656.25, ["Ride"] = 31.46, ["Fly|Ride"] = 190.41, ["Neon"] = 10.48, ["Neon|Fly"] = 91.08, ["Neon|Ride"] = 41.86, ["Mega"] = 209.88, ["Mega|Ride"] = 85.3, ["Mega|Fly|Ride"] = 276.64}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 38.07, ["Ride"] = 22.32, ["Neon"] = 2.1, ["Neon|Fly"] = 20.93, ["Neon|Ride"] = 16.74, ["Neon|Fly|Ride"] = 20.93, ["Mega"] = 17.32, ["Mega|Ride"] = 19.63, ["Mega|Fly|Ride"] = 39.38}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.63, ["Fly"] = 26.25, ["Ride"] = 19.65, ["Fly|Ride"] = 138.1, ["Neon"] = 41.86, ["Neon|Ride"] = 110.67, ["Mega"] = 128.63, ["Mega|Fly|Ride"] = 204.01}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 3.24, ["Fly"] = 111.95, ["Neon"] = 105, ["Neon|Ride"] = 385.03, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 237.47, ["Mega|Ride"] = 277.55, ["Mega|Fly|Ride"] = 439.39}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 22.93, ["Ride"] = 13.13, ["Fly|Ride"] = 35.58, ["Neon"] = 2.1, ["Neon|Fly"] = 22.44, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 17.04, ["Mega|Ride"] = 19.69, ["Mega|Fly|Ride"] = 127.32}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.1, ["Neon"] = 11.51, ["Neon|Fly"] = 77.42, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 105, ["Mega"] = 81.94, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 307.75}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 61.69, ["Neon"] = 6.18, ["Neon|Fly"] = 154.84, ["Neon|Fly|Ride"] = 307.75, ["Mega"] = 38.06, ["Mega|Ride"] = 65.91, ["Mega|Fly|Ride"] = 279.33}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 119.27, ["Ride"] = 15.75, ["Neon"] = 2.1, ["Neon|Fly"] = 40.69, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 84, ["Mega"] = 15.73, ["Mega|Ride"] = 31.14}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 41.86, ["Ride"] = 20.76, ["Fly|Ride"] = 59.07, ["Neon"] = 9.18, ["Neon|Fly"] = 41.86, ["Neon|Ride"] = 39.77, ["Neon|Fly|Ride"] = 140.19, ["Mega"] = 216.69, ["Mega|Ride"] = 105}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Fly"] = 41.86, ["Ride"] = 105, ["Neon"] = 11.05, ["Mega"] = 59.07, ["Mega|Ride"] = 118.73}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 28.26, ["Ride"] = 20.84, ["Fly|Ride"] = 56.49, ["Neon"] = 5.7, ["Neon|Fly"] = 70.1, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 72.19, ["Mega|Ride"] = 103.58, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 17.07, ["Ride"] = 80.99, ["Neon"] = 72.19, ["Mega"] = 296.63, ["Mega|Fly|Ride"] = 844.06}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Ride"] = 21, ["Fly|Ride"] = 56.51, ["Neon"] = 20.93, ["Neon|Fly"] = 58.78, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 154.46, ["Mega"] = 140.19, ["Mega|Fly|Ride"] = 558.64}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 26.25, ["Fly"] = 131.25, ["Ride"] = 15.75, ["Fly|Ride"] = 141.75, ["Neon"] = 26.25, ["Neon|Fly"] = 56.51, ["Neon|Ride"] = 35.57, ["Neon|Fly|Ride"] = 103.07, ["Mega"] = 196.88, ["Mega|Fly|Ride"] = 208.17}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.41, ["Fly"] = 79.47, ["Fly|Ride"] = 103.76, ["Neon"] = 140.19}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 13.42, ["Mega"] = 590.63, ["Mega|Fly|Ride"] = 794.07}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 3.94, ["Ride"] = 262.5, ["Fly|Ride"] = 70.1, ["Neon"] = 42, ["Neon|Ride"] = 140.19, ["Neon|Fly|Ride"] = 83.7, ["Mega"] = 255.87, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 6.83, ["Neon"] = 77.25, ["Neon|Ride"] = 291.38, ["Mega"] = 418.46, ["Mega|Fly|Ride"] = 303.38}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.78, ["Neon|Ride"] = 120.31, ["Mega"] = 18.46, ["Mega|Fly|Ride"] = 148.32}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 52.45}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 6.82, ["Fly"] = 21.93, ["Ride"] = 17.07, ["Fly|Ride"] = 72.66, ["Neon"] = 39.37, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 104.63, ["Mega"] = 279.33, ["Mega|Ride"] = 275.63}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 14.44, ["Fly|Ride"] = 70.88, ["Neon"] = 5.25, ["Neon|Ride"] = 37.67, ["Neon|Fly|Ride"] = 446.06, ["Mega"] = 19.69, ["Mega|Ride"] = 70.1, ["Mega|Fly|Ride"] = 198.78}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.43, ["Ride"] = 164.07, ["Fly|Ride"] = 385.03, ["Neon"] = 3.92, ["Neon|Ride"] = 48.43, ["Mega"] = 46.1, ["Mega|Ride"] = 78.47, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 23.63, ["Neon"] = 7.88, ["Neon|Ride"] = 57.75, ["Neon|Fly|Ride"] = 45.94, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 307.75}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 5.24, ["Neon"] = 45.94, ["Neon|Fly|Ride"] = 230.53, ["Mega"] = 328.13, ["Mega|Fly|Ride"] = 301.29}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 50.72, ["Mega"] = 20.76, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 35.58, ["Mega|Fly|Ride"] = 330.59}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Ride"] = 19.79, ["Fly|Ride"] = 278961.2, ["Neon"] = 8.39, ["Neon|Fly"] = 68.83, ["Neon|Ride"] = 29.99, ["Neon|Fly|Ride"] = 65.91, ["Mega"] = 23.6, ["Mega|Fly"] = 100.44, ["Mega|Ride"] = 62.78, ["Mega|Fly|Ride"] = 98.44}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 28.25, ["Ride"] = 17.07, ["Fly|Ride"] = 104.63, ["Neon"] = 8.25, ["Neon|Fly"] = 70.1, ["Neon|Ride"] = 23.37, ["Neon|Fly|Ride"] = 140.19, ["Mega"] = 110.66, ["Mega|Fly"] = 107.63, ["Mega|Fly|Ride"] = 111.95}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Ride"] = 279.33, ["Neon"] = 3.94, ["Neon|Ride"] = 39.2, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 23.03, ["Mega|Ride"] = 56.51, ["Mega|Fly|Ride"] = 138.33}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 50.23, ["Neon|Fly|Ride"] = 120.31, ["Mega"] = 21, ["Mega|Fly"] = 105, ["Mega|Ride"] = 87.89, ["Mega|Fly|Ride"] = 162.42}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 26.36, ["Ride"] = 20.93, ["Fly|Ride"] = 79.52, ["Neon"] = 3.93, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 86.63, ["Mega"] = 48.14, ["Mega|Ride"] = 37.41, ["Mega|Fly|Ride"] = 138.33}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Neon"] = 2.1, ["Mega"] = 14.32, ["Mega|Ride"] = 205.06}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.63, ["Neon"] = 6.56, ["Neon|Ride"] = 77.25, ["Neon|Fly|Ride"] = 420, ["Mega"] = 27.06}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 17293.53, ["Ride"] = 18.38, ["Fly|Ride"] = 105, ["Neon"] = 4.2, ["Neon|Ride"] = 17.3, ["Neon|Fly|Ride"] = 77.44, ["Mega"] = 35.44, ["Mega|Fly"] = 68.25, ["Mega|Ride"] = 48.51, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 13.12, ["Ride"] = 59.07, ["Neon"] = 125.55, ["Mega"] = 414.1, ["Mega|Ride"] = 418.46, ["Mega|Fly|Ride"] = 517.83}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.1, ["Ride"] = 68.25, ["Neon"] = 27.57, ["Neon|Fly|Ride"] = 110.25, ["Mega"] = 1583.81, ["Mega|Ride"] = 313.04}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 3.15, ["Ride"] = 42, ["Fly|Ride"] = 418.46, ["Neon"] = 98.35, ["Neon|Ride"] = 279.33, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 129.73, ["Mega|Fly|Ride"] = 558.64}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 16.67, ["Ride"] = 15.63, ["Fly|Ride"] = 39.38, ["Neon"] = 2.1, ["Neon|Fly"] = 18.45, ["Neon|Ride"] = 15.7, ["Neon|Fly|Ride"] = 34.93, ["Mega"] = 15.68, ["Mega|Fly"] = 22.32, ["Mega|Ride"] = 13.13, ["Mega|Fly|Ride"] = 43.32}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 5.24, ["Neon"] = 15.22, ["Neon|Fly"] = 140.19, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 64.87, ["Mega|Ride"] = 154.46}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Ride"] = 31.5, ["Neon"] = 2.1, ["Neon|Fly"] = 31.14, ["Neon|Ride"] = 31.4, ["Neon|Fly|Ride"] = 79.04, ["Mega"] = 14.39, ["Mega|Fly"] = 46.12, ["Mega|Ride"] = 36.46, ["Mega|Fly|Ride"] = 337.98}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 3.82, ["Neon|Fly"] = 60.9, ["Mega"] = 14.44, ["Mega|Fly|Ride"] = 272}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Ride"] = 24.94, ["Fly|Ride"] = 262.5, ["Neon"] = 12.7, ["Neon|Fly"] = 77.25, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 70.09, ["Mega"] = 140.19, ["Mega|Ride"] = 111.95, ["Mega|Fly|Ride"] = 248.98}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 243.13, ["Ride"] = 265.72, ["Fly|Ride"] = 393.75, ["Neon"] = 1199.89, ["Neon|Ride"] = 1050, ["Neon|Fly|Ride"] = 1412.25, ["Mega"] = 8368.84, ["Mega|Fly|Ride"] = 5230.53}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Fly|Ride"] = 52.5, ["Neon"] = 8.4, ["Neon|Ride"] = 68.25, ["Mega"] = 73.24, ["Mega|Ride"] = 173.67, ["Mega|Fly|Ride"] = 551.32}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 3.94, ["Fly"] = 103.68, ["Ride"] = 14.44, ["Neon"] = 53.82, ["Neon|Ride"] = 166.35, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 603.75, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 615.48}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 15.06, ["Fly|Ride"] = 33.08, ["Neon"] = 3.91, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 61.69, ["Mega"] = 49.88, ["Mega|Ride"] = 69.18, ["Mega|Fly|Ride"] = 140.44}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 24.92, ["Fly|Ride"] = 121.36, ["Neon"] = 8.74, ["Neon|Fly"] = 35.75, ["Neon|Ride"] = 41.86, ["Mega"] = 106.72, ["Mega|Ride"] = 91.88}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 19.69, ["Fly|Ride"] = 48.14, ["Neon"] = 28.88, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 82.9, ["Mega"] = 204.01, ["Mega|Ride"] = 167.37, ["Mega|Fly|Ride"] = 307.75}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 4.93, ["Ride"] = 145.69, ["Fly|Ride"] = 246.75, ["Neon"] = 45.94, ["Neon|Ride"] = 104.63, ["Neon|Fly|Ride"] = 621.41, ["Mega"] = 298.53, ["Mega|Ride"] = 308.61, ["Mega|Fly|Ride"] = 418.46}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.61, ["Fly"] = 17.52, ["Ride"] = 14.43, ["Fly|Ride"] = 38.07, ["Neon"] = 31.13, ["Neon|Fly"] = 70.32, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 70.1, ["Mega"] = 230.53, ["Mega|Ride"] = 418.46, ["Mega|Fly|Ride"] = 558.64}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 101.07, ["Fly"] = 141.75, ["Ride"] = 110.25, ["Fly|Ride"] = 131.25, ["Neon"] = 442.53, ["Neon|Fly"] = 394.42, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 443.89, ["Mega|Fly|Ride"] = 1456.02}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 241.03, ["Fly"] = 313.85, ["Ride"] = 210, ["Fly|Ride"] = 250.69, ["Neon|Ride"] = 1116.21, ["Neon|Fly|Ride"] = 1019.82, ["Mega"] = 10461.04, ["Mega|Fly|Ride"] = 5225.79}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 57.75, ["Fly"] = 115.31, ["Ride"] = 72.19, ["Fly|Ride"] = 111.57, ["Neon"] = 301.88, ["Neon|Ride"] = 273, ["Neon|Fly|Ride"] = 309.1, ["Mega|Fly|Ride"] = 1168.13}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 7.87, ["Ride"] = 26.25, ["Neon"] = 20.93, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 182.04, ["Mega"] = 230.53, ["Mega|Ride"] = 237.44, ["Mega|Fly|Ride"] = 392.44}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 12.99, ["Fly"] = 41.86, ["Ride"] = 41.86, ["Fly|Ride"] = 65.63, ["Neon"] = 124.69, ["Neon|Ride"] = 200.6, ["Mega"] = 478.33, ["Mega|Ride"] = 388.5, ["Mega|Fly|Ride"] = 552.57}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 31.49, ["Ride"] = 15.74, ["Fly|Ride"] = 65.72, ["Neon"] = 2.1, ["Neon|Fly"] = 31.4, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 86.84, ["Mega"] = 40.36, ["Mega|Fly"] = 115.27, ["Mega|Ride"] = 108.35, ["Mega|Fly|Ride"] = 209.24}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 7.86, ["Fly"] = 65.63, ["Ride"] = 24.94, ["Fly|Ride"] = 103.69, ["Neon"] = 23, ["Neon|Ride"] = 140.19, ["Neon|Fly|Ride"] = 140.19, ["Mega"] = 461.05, ["Mega|Ride"] = 174.71, ["Mega|Fly|Ride"] = 279.33}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 15.74, ["Fly|Ride"] = 45.1, ["Neon"] = 14.44, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 35.63, ["Neon|Fly|Ride"] = 133.88, ["Mega"] = 131.24, ["Mega|Ride"] = 219.22, ["Mega|Fly|Ride"] = 175.88}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 3.93, ["Ride"] = 30.19, ["Fly|Ride"] = 328.13, ["Neon"] = 22.78, ["Neon|Ride"] = 56.51, ["Mega"] = 179.21, ["Mega|Fly|Ride"] = 697.76}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 28.26, ["Neon"] = 2.1, ["Neon|Ride"] = 31.4, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 15.62, ["Mega|Ride"] = 49.18, ["Mega|Fly|Ride"] = 166.35}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 45.93, ["Ride"] = 31.4, ["Fly|Ride"] = 56.44, ["Neon"] = 16.67, ["Neon|Fly"] = 70.1, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 86.45, ["Mega"] = 154.46, ["Mega|Fly|Ride"] = 192.29}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.63, ["Fly"] = 70.1, ["Ride"] = 18.37, ["Neon"] = 70.09, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 558.64, ["Mega"] = 182.04, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 271.69}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 144.38, ["Fly"] = 209.24, ["Ride"] = 162.75, ["Fly|Ride"] = 242.82, ["Neon"] = 614.09, ["Neon|Ride"] = 586.69, ["Neon|Fly|Ride"] = 551.24, ["Mega|Fly|Ride"] = 1884.75}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 6.57, ["Ride"] = 240.91, ["Fly|Ride"] = 206.07, ["Neon"] = 55.13, ["Neon|Ride"] = 123.36, ["Neon|Fly|Ride"] = 152.25, ["Mega"] = 414.75, ["Mega|Fly|Ride"] = 416.31}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.28, ["Fly"] = 69.19, ["Ride"] = 26.52, ["Fly|Ride"] = 112.88, ["Neon"] = 24.08, ["Neon|Ride"] = 25.03, ["Neon|Fly|Ride"] = 125.55, ["Mega"] = 308.44, ["Mega|Ride"] = 269.97, ["Mega|Fly|Ride"] = 408.19}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 19.59, ["Ride"] = 139.15, ["Fly|Ride"] = 131.25, ["Neon"] = 100.3, ["Neon|Ride"] = 138.1, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 523.06, ["Mega|Ride"] = 551.25, ["Mega|Fly|Ride"] = 522.02}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 5.15}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 5.25, ["Ride"] = 27.57, ["Neon"] = 72.19, ["Neon|Fly|Ride"] = 627.68, ["Mega"] = 288.75, ["Mega|Ride"] = 404.86, ["Mega|Fly|Ride"] = 1255.34}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 26.09, ["Fly"] = 56.25, ["Ride"] = 39.38, ["Fly|Ride"] = 52.5, ["Neon"] = 279.33, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 138.1, ["Neon|Fly|Ride"] = 166.35, ["Mega"] = 2092.22, ["Mega|Fly|Ride"] = 1055.78}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 3.82, ["Neon|Ride"] = 33.38, ["Mega"] = 24.86, ["Mega|Ride"] = 65.13, ["Mega|Fly|Ride"] = 171.94}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 2.1, ["Fly"] = 28.26, ["Ride"] = 28.26, ["Fly|Ride"] = 73.21, ["Neon"] = 140.19, ["Neon|Ride"] = 230.57, ["Mega"] = 277.6, ["Mega|Fly"] = 384.98, ["Mega|Ride"] = 161.47, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 44.98, ["Neon"] = 19.69, ["Neon|Ride"] = 25.12, ["Neon|Fly|Ride"] = 54.41, ["Mega"] = 140.41, ["Mega|Ride"] = 128.63, ["Mega|Fly|Ride"] = 229.1}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Ride"] = 40.81, ["Neon|Fly|Ride"] = 112.88, ["Mega"] = 41.86, ["Mega|Ride"] = 62.98, ["Mega|Fly|Ride"] = 192.5}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 23.66, ["Fly"] = 154.51, ["Ride"] = 65.63, ["Neon"] = 208.3, ["Mega"] = 769.1, ["Mega|Ride"] = 813.75, ["Mega|Fly|Ride"] = 919.54}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 2.63, ["Ride"] = 48.14, ["Fly|Ride"] = 210, ["Neon"] = 52.5, ["Neon|Ride"] = 78.47, ["Mega"] = 229.38, ["Mega|Ride"] = 511.88}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 6.56, ["Fly"] = 92.11, ["Ride"] = 36.75, ["Fly|Ride"] = 167.4, ["Neon"] = 32.82, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 78.05, ["Neon|Fly|Ride"] = 180.89, ["Mega"] = 229.69, ["Mega|Ride"] = 346.12, ["Mega|Fly|Ride"] = 413.23}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 56.43, ["Fly"] = 433.13, ["Ride"] = 102.38, ["Fly|Ride"] = 349.41, ["Neon"] = 18316.2, ["Neon|Ride"] = 454.02, ["Mega|Ride"] = 1785.71, ["Mega|Fly|Ride"] = 1813.96}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 23.3, ["Ride"] = 46.04, ["Fly|Ride"] = 134.92, ["Neon"] = 90.57, ["Neon|Ride"] = 93.18, ["Neon|Fly|Ride"] = 551.25, ["Mega"] = 377.99, ["Mega|Ride"] = 392.44, ["Mega|Fly|Ride"] = 517.83}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 81.61, ["Ride"] = 108.94, ["Fly|Ride"] = 230.57, ["Neon"] = 241.75, ["Neon|Ride"] = 263.05, ["Neon|Fly|Ride"] = 300.57, ["Mega"] = 1464.57, ["Mega|Ride"] = 1044.03, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 26.19, ["Ride"] = 98.34, ["Fly|Ride"] = 115.5, ["Neon"] = 87.94, ["Neon|Ride"] = 99.16, ["Neon|Fly|Ride"] = 209.77, ["Mega"] = 343.48, ["Mega|Ride"] = 326.76, ["Mega|Fly|Ride"] = 519.1}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 16.77, ["Fly"] = 52.5, ["Ride"] = 27.21, ["Fly|Ride"] = 65.63, ["Neon"] = 69.05, ["Neon|Ride"] = 93.35, ["Neon|Fly|Ride"] = 97.63, ["Mega"] = 327.35, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 23.59, ["Fly"] = 111.57, ["Ride"] = 41.86, ["Fly|Ride"] = 167.4, ["Neon"] = 89.77, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 203.44, ["Mega"] = 235.34, ["Mega|Ride"] = 371.57, ["Mega|Fly|Ride"] = 572.25}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 8.95, ["Ride"] = 46.13, ["Neon"] = 50.23, ["Neon|Ride"] = 133.23, ["Neon|Fly|Ride"] = 199.06, ["Mega"] = 416.59, ["Mega|Ride"] = 300.24, ["Mega|Fly|Ride"] = 390.23}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 32.8, ["Mega"] = 18.36, ["Mega|Fly"] = 140.19, ["Mega|Ride"] = 66.94, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 2.63, ["Ride"] = 104.63, ["Neon"] = 13.12, ["Neon|Ride"] = 83.83, ["Mega"] = 99.62, ["Mega|Ride"] = 156.4, ["Mega|Fly|Ride"] = 188.32}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Neon"] = 22.23, ["Neon|Ride"] = 125.55, ["Mega"] = 336, ["Mega|Ride"] = 391.27}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 6.28, ["Ride"] = 31.16, ["Fly|Ride"] = 115.29, ["Neon"] = 27.57, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 278.28, ["Mega"] = 123.38, ["Mega|Ride"] = 376.62, ["Mega|Fly|Ride"] = 508.6}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 493.5, ["Ride"] = 551.25, ["Fly|Ride"] = 525, ["Neon"] = 1611.02, ["Neon|Ride"] = 1450.97, ["Neon|Fly|Ride"] = 1517.25, ["Mega|Fly|Ride"] = 4593.74}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 7.86, ["Fly"] = 56.26, ["Ride"] = 25.18, ["Fly|Ride"] = 71.48, ["Neon"] = 37.67, ["Neon|Ride"] = 83.7, ["Neon|Fly|Ride"] = 123.35, ["Mega"] = 297.39, ["Mega|Ride"] = 279.33}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 7.86, ["Fly"] = 31.5, ["Fly|Ride"] = 70.88, ["Neon"] = 64.32, ["Neon|Fly"] = 315, ["Neon|Ride"] = 154.48, ["Neon|Fly|Ride"] = 105, ["Mega"] = 359.88, ["Mega|Ride"] = 299.83, ["Mega|Fly|Ride"] = 391.27}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 8.39, ["Ride"] = 23.23, ["Fly|Ride"] = 313.85, ["Neon|Ride"] = 45.94, ["Mega"] = 223.13, ["Mega|Ride"] = 354.38, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 41.86, ["Ride"] = 42, ["Neon"] = 5.25, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 137.06, ["Mega"] = 74.23, ["Mega|Ride"] = 107.63, ["Mega|Fly|Ride"] = 201.97}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Ride"] = 70.1, ["Neon"] = 3.14, ["Neon|Ride"] = 18.12, ["Neon|Fly|Ride"] = 115.27, ["Mega"] = 26.25, ["Mega|Ride"] = 77.42, ["Mega|Fly|Ride"] = 209.24}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1120.61}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 10.37, ["Fly"] = 65.63, ["Ride"] = 41.27, ["Neon"] = 56.49, ["Neon|Fly"] = 140.19, ["Neon|Ride"] = 139.54, ["Mega"] = 522.02, ["Mega|Ride"] = 400.67, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.61, ["Ride"] = 45.36, ["Neon"] = 7.87, ["Neon|Ride"] = 73.79, ["Mega"] = 54.41, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 230.35}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.1, ["Fly"] = 41.86, ["Ride"] = 19.69, ["Fly|Ride"] = 525, ["Neon"] = 7.87, ["Neon|Ride"] = 69.57, ["Neon|Fly|Ride"] = 105, ["Mega"] = 124.5, ["Mega|Ride"] = 154.88, ["Mega|Fly|Ride"] = 196.69}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 459.83, ["Fly"] = 459.38, ["Ride"] = 418.46, ["Fly|Ride"] = 538.13, ["Neon|Ride"] = 1509.38, ["Neon|Fly|Ride"] = 1689.69, ["Mega|Fly|Ride"] = 7672.13}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 6.54, ["Fly"] = 196.88, ["Ride"] = 72.19, ["Neon"] = 83.7, ["Neon|Ride"] = 131.25, ["Mega|Ride"] = 408.02, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Neon"] = 6.33, ["Neon|Ride"] = 39.2, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 45, ["Mega|Fly"] = 154.46, ["Mega|Ride"] = 100.62, ["Mega|Fly|Ride"] = 194.99}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Ride"] = 836.91, ["Fly|Ride"] = 140.19, ["Neon"] = 3.4, ["Neon|Ride"] = 59.07, ["Mega"] = 23.05, ["Mega|Ride"] = 83, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 12.37, ["Fly"] = 78.47, ["Ride"] = 39.38, ["Neon"] = 35.58, ["Neon|Ride"] = 104.63, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 328.13, ["Mega|Ride"] = 195.55, ["Mega|Fly|Ride"] = 306.6}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 9.19, ["Ride"] = 140.19, ["Fly|Ride"] = 131.25, ["Neon"] = 65.63, ["Neon|Fly|Ride"] = 836.91, ["Mega"] = 941.51, ["Mega|Ride"] = 461.05, ["Mega|Fly|Ride"] = 1066.42}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 3.93, ["Fly|Ride"] = 140.19, ["Neon"] = 195.64, ["Neon|Ride"] = 208.2, ["Mega"] = 391.27, ["Mega|Fly|Ride"] = 1220.63}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 10.48, ["Ride"] = 64.87, ["Neon|Ride"] = 123.36, ["Neon|Fly|Ride"] = 768.79, ["Mega"] = 660.19, ["Mega|Ride"] = 468.66, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 328.13, ["Ride"] = 482.35, ["Fly|Ride"] = 604.67, ["Neon"] = 2929.11, ["Neon|Ride"] = 1157.38, ["Neon|Fly|Ride"] = 1046.12, ["Mega|Fly|Ride"] = 3150}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 3.91, ["Fly"] = 24.94, ["Ride"] = 44.63, ["Fly|Ride"] = 81.86, ["Neon"] = 43.32, ["Neon|Ride"] = 98.35, ["Neon|Fly|Ride"] = 140.18, ["Mega"] = 529.78, ["Mega|Ride"] = 496.92, ["Mega|Fly|Ride"] = 697.76}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 8.39, ["Ride"] = 41.68, ["Mega"] = 1255.34, ["Mega|Fly|Ride"] = 558.64}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 5.91, ["Ride"] = 60.38, ["Fly|Ride"] = 162.75, ["Neon"] = 35.44, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 168, ["Mega"] = 207.15, ["Mega|Ride"] = 217.6, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.1, ["Ride"] = 31.49, ["Fly|Ride"] = 107.77, ["Neon"] = 5.25, ["Neon|Ride"] = 39.95, ["Mega"] = 39.2, ["Mega|Ride"] = 89.92, ["Mega|Fly|Ride"] = 215.55}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 36.54, ["Ride"] = 61.73, ["Neon"] = 229.69, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 461.05, ["Mega"] = 1116.21, ["Mega|Ride"] = 1031.47, ["Mega|Fly|Ride"] = 956.01}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 576.45, ["Ride"] = 32.44, ["Fly|Ride"] = 65.63, ["Neon"] = 7.88, ["Neon|Fly"] = 182.04, ["Neon|Ride"] = 55.35, ["Mega"] = 54.86, ["Mega|Ride"] = 106.99, ["Mega|Fly|Ride"] = 252.42}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Ride"] = 83.7, ["Fly|Ride"] = 148.25, ["Neon"] = 5.25, ["Neon|Ride"] = 37.67, ["Mega"] = 44.63, ["Mega|Ride"] = 279.33, ["Mega|Fly|Ride"] = 267.82}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Ride"] = 28.26, ["Fly|Ride"] = 65.63, ["Neon"] = 12.99, ["Neon|Fly|Ride"] = 295.32, ["Mega"] = 108.35, ["Mega|Ride"] = 189.05, ["Mega|Fly|Ride"] = 200.57}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 62.27, ["Ride"] = 97.13, ["Fly|Ride"] = 154.51, ["Neon"] = 485.63, ["Neon|Ride"] = 313.85, ["Neon|Fly|Ride"] = 672.67, ["Mega|Fly|Ride"] = 1249.06}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 248.12, ["Ride"] = 326.82, ["Fly|Ride"] = 418.46, ["Neon|Ride"] = 1127.44, ["Neon|Fly|Ride"] = 1419.99, ["Mega"] = 6974.39, ["Mega|Fly|Ride"] = 5646.88}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 3.94, ["Neon"] = 27.57, ["Mega"] = 104.89, ["Mega|Ride"] = 191.34, ["Mega|Fly|Ride"] = 416.37}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.1, ["Neon"] = 12.69, ["Neon|Ride"] = 41.86, ["Mega"] = 187.9, ["Mega|Ride"] = 167.4, ["Mega|Fly|Ride"] = 446.06}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 2.61, ["Fly"] = 155.57, ["Neon|Ride"] = 62.26, ["Mega"] = 488.92}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.45, ["Fly"] = 53.23, ["Ride"] = 34.13, ["Neon"] = 6.56, ["Neon|Ride"] = 32.44, ["Neon|Fly|Ride"] = 182.04, ["Mega"] = 60.38, ["Mega|Ride"] = 138.33, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 59.07, ["Neon"] = 8.33, ["Mega"] = 28.26, ["Mega|Ride"] = 206.07}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 65.35, ["Ride"] = 27.21, ["Fly|Ride"] = 46.12, ["Neon"] = 3.93, ["Neon|Ride"] = 43.82, ["Neon|Fly|Ride"] = 104.63, ["Mega"] = 45, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 138.33}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 27.68, ["Fly|Ride"] = 60.38, ["Neon"] = 24.07, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 85.31, ["Mega"] = 170.63, ["Mega|Ride"] = 195.64, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 31.42, ["Fly"] = 99.17, ["Ride"] = 62.78, ["Fly|Ride"] = 136.01, ["Neon"] = 114.19, ["Neon|Ride"] = 147, ["Neon|Fly|Ride"] = 167.4, ["Mega"] = 367.5, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 64.32, ["Fly"] = 582.75, ["Ride"] = 98.35, ["Fly|Ride"] = 104.63, ["Neon"] = 418.46, ["Neon|Ride"] = 383.25, ["Neon|Fly|Ride"] = 523.06, ["Mega"] = 3073.93, ["Mega|Ride"] = 1492.81, ["Mega|Fly|Ride"] = 1528.16}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Fly|Ride"] = 131.25, ["Neon"] = 5.23, ["Neon|Ride"] = 56.51, ["Neon|Fly|Ride"] = 359.63, ["Mega"] = 56.35, ["Mega|Ride"] = 125.55, ["Mega|Fly|Ride"] = 230.53}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 24.07, ["Ride"] = 13.13, ["Fly|Ride"] = 46.13, ["Neon"] = 3.93, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 38.07, ["Mega|Fly"] = 157.5, ["Mega|Ride"] = 52.32, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 3.93, ["Ride"] = 37.67, ["Neon"] = 91.18, ["Neon|Ride"] = 418.46, ["Neon|Fly|Ride"] = 278.28, ["Mega"] = 611, ["Mega|Ride"] = 627.68, ["Mega|Fly|Ride"] = 471.19}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 261.54, ["Ride"] = 550.27, ["Fly|Ride"] = 368.25, ["Neon"] = 977.07, ["Neon|Ride"] = 1464.57, ["Mega|Fly|Ride"] = 5225.79}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 28.11, ["Fly"] = 209.9, ["Ride"] = 55.13, ["Fly|Ride"] = 154.84, ["Neon"] = 209.24, ["Neon|Ride"] = 209.24, ["Neon|Fly|Ride"] = 354.38, ["Mega"] = 894.43, ["Mega|Ride"] = 977.07, ["Mega|Fly|Ride"] = 697.76}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 98.35, ["Neon"] = 10.5, ["Neon|Ride"] = 49.18, ["Neon|Fly|Ride"] = 98.35, ["Mega"] = 115.5, ["Mega|Ride"] = 140.56, ["Mega|Fly|Ride"] = 270.51}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.63, ["Fly"] = 209.24, ["Ride"] = 83.7, ["Neon"] = 25.12, ["Neon|Ride"] = 65.63, ["Mega|Ride"] = 431.07}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 19.94, ["Fly"] = 255.26, ["Ride"] = 39.38, ["Fly|Ride"] = 59.07, ["Neon|Ride"] = 137.06, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 2510.67, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 1036.71}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 78.75, ["Ride"] = 140.19, ["Fly|Ride"] = 251.08, ["Neon"] = 345.19, ["Neon|Ride"] = 514.69, ["Neon|Fly|Ride"] = 418.46, ["Mega"] = 3069.28, ["Mega|Fly|Ride"] = 2153.03}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 263.73, ["Fly"] = 497.96, ["Ride"] = 300.78, ["Fly|Ride"] = 408.53, ["Neon"] = 820.32, ["Neon|Ride"] = 1018.92, ["Neon|Fly|Ride"] = 918.75, ["Mega|Fly|Ride"] = 3067.19}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 13.1, ["Ride"] = 62.78, ["Fly|Ride"] = 262.5, ["Neon"] = 131.25, ["Neon|Ride"] = 109.72, ["Neon|Fly|Ride"] = 768.79, ["Mega"] = 512.91, ["Mega|Ride"] = 380.63, ["Mega|Fly|Ride"] = 502.15}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 21, ["Fly|Ride"] = 47.25, ["Neon"] = 15.09, ["Neon|Fly"] = 70.1, ["Neon|Ride"] = 40.81, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 112.28, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 160.13}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 3.93, ["Ride"] = 23.07, ["Fly|Ride"] = 62.78, ["Neon"] = 31.5, ["Neon|Ride"] = 34.07, ["Neon|Fly|Ride"] = 121.82, ["Mega"] = 250.79, ["Mega|Ride"] = 241.5, ["Mega|Fly|Ride"] = 290.69}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 316.51, ["Ride"] = 393.75, ["Fly|Ride"] = 481.22, ["Neon|Ride"] = 1673.79, ["Neon|Fly|Ride"] = 1930.07, ["Mega|Fly|Ride"] = 6915.46}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Neon"] = 6.83, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 32.82, ["Mega|Ride"] = 156.94, ["Mega|Fly|Ride"] = 292.77}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 5.92, ["Ride"] = 17.07, ["Fly|Ride"] = 77.26, ["Neon"] = 24.09, ["Neon|Ride"] = 36.74, ["Neon|Fly|Ride"] = 111.93, ["Mega"] = 236.25, ["Mega|Ride"] = 276.19, ["Mega|Fly|Ride"] = 248.98}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 26.25, ["Ride"] = 98.35, ["Neon"] = 103.66, ["Neon|Ride"] = 195.64, ["Neon|Fly|Ride"] = 535.56, ["Mega"] = 517.83, ["Mega|Ride"] = 451.5, ["Mega|Fly|Ride"] = 493.78}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 105, ["Fly"] = 278.28, ["Ride"] = 118.13, ["Fly|Ride"] = 140.19, ["Neon|Ride"] = 563.07, ["Neon|Fly|Ride"] = 670.69, ["Mega|Fly|Ride"] = 1669.6}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 20.78, ["Fly"] = 77.26, ["Ride"] = 28.01, ["Fly|Ride"] = 62.89, ["Neon"] = 65.63, ["Neon|Ride"] = 82.69, ["Neon|Fly|Ride"] = 132.87, ["Mega"] = 697.76, ["Mega|Ride"] = 418.46, ["Mega|Fly|Ride"] = 538.13}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 41.86, ["Neon"] = 3.53, ["Neon|Ride"] = 70.1, ["Neon|Fly|Ride"] = 140.19, ["Mega"] = 20.35, ["Mega|Ride"] = 167.35, ["Mega|Fly|Ride"] = 418.46}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Ride"] = 35.44, ["Fly|Ride"] = 83.7, ["Neon"] = 2.1, ["Neon|Fly"] = 31.14, ["Neon|Ride"] = 28.25, ["Neon|Fly|Ride"] = 69.18, ["Mega"] = 24.94, ["Mega|Ride"] = 69.05, ["Mega|Fly|Ride"] = 112.45}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 9.19, ["Ride"] = 51.85, ["Fly|Ride"] = 157.5, ["Neon"] = 29.51, ["Neon|Fly"] = 261.69, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 140.19, ["Mega"] = 147, ["Mega|Ride"] = 195.64, ["Mega|Fly|Ride"] = 246.75}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1446.38, ["Ride"] = 1443.75, ["Fly|Ride"] = 1607.82, ["Neon"] = 5230.53, ["Neon|Fly|Ride"] = 4463.74, ["Mega|Fly|Ride"] = 13634.25}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 616.88, ["Ride"] = 558.64, ["Fly|Ride"] = 749.58, ["Neon|Ride"] = 2406.05, ["Neon|Fly|Ride"] = 2483.46, ["Mega"] = 13830.91, ["Mega|Fly|Ride"] = 4948.13}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 308.48, ["Fly"] = 558.64, ["Ride"] = 315, ["Fly|Ride"] = 431.27, ["Neon"] = 735, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 656.25, ["Mega|Fly|Ride"] = 2428.13}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 236.25, ["Fly"] = 404.86, ["Ride"] = 328.13, ["Fly|Ride"] = 420, ["Neon"] = 918.75, ["Neon|Ride"] = 984.37, ["Neon|Fly|Ride"] = 897.75, ["Mega|Ride"] = 3675, ["Mega|Fly|Ride"] = 3025.34}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 79.52, ["Ride"] = 13.13, ["Fly|Ride"] = 34.13, ["Neon"] = 6.18, ["Neon|Ride"] = 45, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 69.18, ["Mega|Ride"] = 112.88, ["Mega|Fly|Ride"] = 140.19}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 276.35, ["Ride"] = 354.38, ["Fly|Ride"] = 446.25, ["Neon"] = 1255.34, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 1049.99, ["Mega"] = 5161.49, ["Mega|Ride"] = 3937.5, ["Mega|Fly|Ride"] = 3412.5}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 2.1, ["Fly"] = 183.75, ["Ride"] = 27.57, ["Neon"] = 9.23, ["Neon|Ride"] = 43.95, ["Neon|Fly|Ride"] = 254.63, ["Mega"] = 67.95, ["Mega|Ride"] = 140.19, ["Mega|Fly|Ride"] = 264.48}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 20.93, ["Ride"] = 31.5, ["Fly|Ride"] = 41.86, ["Neon"] = 9.23, ["Neon|Ride"] = 61.69, ["Neon|Fly|Ride"] = 110.25, ["Mega|Ride"] = 136.6, ["Mega|Fly|Ride"] = 202.13}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Neon"] = 3.94, ["Mega"] = 21.9, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 57.74, ["Ride"] = 70.09, ["Fly|Ride"] = 459.38, ["Neon"] = 184.46, ["Neon|Ride"] = 420, ["Mega"] = 2092.22, ["Mega|Ride"] = 922.08, ["Mega|Fly|Ride"] = 977.07}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Ride"] = 18.9, ["Neon"] = 28.12, ["Mega"] = 328.13, ["Mega|Ride"] = 315.94}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 53.82, ["Neon"] = 3.39, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 24.94, ["Mega|Fly"] = 123.35, ["Mega|Ride"] = 154.46, ["Mega|Fly|Ride"] = 308.44}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.1, ["Ride"] = 23.02, ["Fly|Ride"] = 140.18, ["Neon"] = 6.55, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 23.02, ["Neon|Fly|Ride"] = 98.35, ["Mega"] = 69.83, ["Mega|Fly"] = 207.48, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 173.25}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 8.39, ["Fly"] = 46.1, ["Ride"] = 32.49, ["Fly|Ride"] = 55.26, ["Neon"] = 59.64, ["Neon|Ride"] = 107.14, ["Neon|Fly|Ride"] = 251.08, ["Mega"] = 237.57, ["Mega|Fly|Ride"] = 1019.82}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 15.72, ["Ride"] = 27.57, ["Neon"] = 41.86, ["Mega"] = 461.05, ["Mega|Ride"] = 334.77, ["Mega|Fly|Ride"] = 517.83}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.61, ["Ride"] = 49.74, ["Fly|Ride"] = 87.94, ["Neon"] = 187.69, ["Neon|Fly|Ride"] = 691.56, ["Mega"] = 232.24, ["Mega|Ride"] = 488.54}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Ride"] = 17.31, ["Fly|Ride"] = 83.7, ["Neon"] = 3.55, ["Neon|Ride"] = 28.26, ["Neon|Fly|Ride"] = 167.4, ["Mega"] = 39.38, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 313.85}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 200.61, ["Fly"] = 217.6, ["Ride"] = 223.13, ["Fly|Ride"] = 275.63, ["Neon"] = 1153.51, ["Neon|Fly"] = 1325.43, ["Neon|Ride"] = 1129.8, ["Neon|Fly|Ride"] = 1045.07, ["Mega"] = 8368.84, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 18.31, ["Neon"] = 5.64, ["Neon|Ride"] = 23.87, ["Neon|Fly|Ride"] = 62.3, ["Mega"] = 46.12, ["Mega|Ride"] = 73.5, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 7.71, ["Ride"] = 98.44, ["Fly|Ride"] = 105, ["Neon"] = 78.47, ["Neon|Fly|Ride"] = 325.04, ["Mega"] = 315, ["Mega|Ride"] = 325.5, ["Mega|Fly|Ride"] = 460.67}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 35.18, ["Ride"] = 108.42, ["Neon"] = 153.57, ["Neon|Ride"] = 219.22, ["Mega"] = 783.77, ["Mega|Ride"] = 1013.13, ["Mega|Fly|Ride"] = 821.73}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 175.88, ["Fly"] = 262.5, ["Ride"] = 223.13, ["Fly|Ride"] = 326.68, ["Neon|Ride"] = 742.88, ["Neon|Fly|Ride"] = 866.25, ["Mega|Fly|Ride"] = 3451.1}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 20.61, ["Neon"] = 100.44, ["Mega"] = 415.42, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 697.76}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 24.94, ["Ride"] = 313.85, ["Fly|Ride"] = 626.63, ["Neon"] = 138.34, ["Neon|Ride"] = 627.68, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 656.98, ["Mega|Ride"] = 888.64, ["Mega|Fly|Ride"] = 1046.12}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 1147.82, ["Ride"] = 984.38, ["Fly|Ride"] = 1050, ["Neon|Ride"] = 6276.63, ["Neon|Fly|Ride"] = 4315.5, ["Mega|Fly|Ride"] = 13948.76}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 7.41, ["Fly"] = 43.32, ["Ride"] = 23.63, ["Fly|Ride"] = 62.35, ["Neon"] = 49.18, ["Neon|Fly"] = 111.57, ["Neon|Ride"] = 77.25, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 131.24, ["Mega|Fly"] = 558.64, ["Mega|Ride"] = 266.77, ["Mega|Fly|Ride"] = 383.94}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 11.68, ["Fly"] = 13808.59, ["Ride"] = 41.85, ["Neon"] = 38.07, ["Neon|Fly|Ride"] = 144.74, ["Mega"] = 212.63, ["Mega|Ride"] = 292.69, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 5.25, ["Ride"] = 28.26, ["Fly|Ride"] = 91.03, ["Neon"] = 14.44, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 307.75, ["Mega"] = 132.87, ["Mega|Ride"] = 246.89, ["Mega|Fly|Ride"] = 558.64}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 16.77, ["Ride"] = 34.12, ["Fly|Ride"] = 83.7, ["Neon"] = 62.51, ["Neon|Ride"] = 115.29, ["Neon|Fly|Ride"] = 200.87, ["Mega"] = 341.25, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 2.63, ["Fly"] = 36.63, ["Ride"] = 26.25, ["Fly|Ride"] = 65.63, ["Neon"] = 22.32, ["Neon|Ride"] = 62.27, ["Neon|Fly|Ride"] = 83.69, ["Mega|Ride"] = 170.54, ["Mega|Fly|Ride"] = 222.08}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Ride"] = 27.68, ["Neon"] = 15.72, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 140.19, ["Mega"] = 152.73, ["Mega|Ride"] = 266.44, ["Mega|Fly|Ride"] = 231.16}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 139.12, ["Ride"] = 224.44, ["Fly|Ride"] = 474.94, ["Neon"] = 735, ["Neon|Ride"] = 1693.13, ["Neon|Fly|Ride"] = 1116.21, ["Mega|Fly|Ride"] = 3703.22}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Ride"] = 21, ["Neon"] = 12.7, ["Neon|Fly"] = 77.25, ["Neon|Ride"] = 42.56, ["Neon|Fly|Ride"] = 162.17, ["Mega"] = 83.55, ["Mega|Ride"] = 139.13, ["Mega|Fly|Ride"] = 209.57}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 4.6, ["Fly"] = 408.19, ["Neon"] = 28.88, ["Mega"] = 249.38, ["Mega|Ride"] = 307.75}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 3.93, ["Fly"] = 81.59, ["Ride"] = 34.13, ["Neon"] = 11.81, ["Neon|Ride"] = 52.5, ["Mega"] = 125.73, ["Mega|Ride"] = 178.03, ["Mega|Fly|Ride"] = 404.92}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 123.38, ["Fly"] = 262.5, ["Ride"] = 167.37, ["Fly|Ride"] = 313.85, ["Neon"] = 393.75, ["Neon|Ride"] = 590.63, ["Neon|Fly|Ride"] = 621.41, ["Mega"] = 2090.13, ["Mega|Ride"] = 2468.82, ["Mega|Fly|Ride"] = 1785}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 18.8, ["Ride"] = 84, ["Fly|Ride"] = 108.81, ["Neon"] = 78.75, ["Neon|Ride"] = 146.42, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 600.48, ["Mega|Ride"] = 655.92, ["Mega|Fly|Ride"] = 697.76}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 17, ["Ride"] = 41.86, ["Neon"] = 124.69, ["Neon|Ride"] = 152.45, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 489.39, ["Mega|Ride"] = 532.38, ["Mega|Fly|Ride"] = 635.46}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 83.7, ["Neon"] = 5.13, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 35.44, ["Mega"] = 33.49, ["Mega|Ride"] = 74.82, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 78.75, ["Fly"] = 124.5, ["Ride"] = 129.94, ["Fly|Ride"] = 233.36, ["Neon"] = 347.88, ["Neon|Ride"] = 418.46, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 905.63}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 20.93, ["Neon"] = 8.39, ["Neon|Fly|Ride"] = 588, ["Mega"] = 60.68}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 19.51, ["Fly"] = 140.19, ["Ride"] = 45.94, ["Fly|Ride"] = 108.38, ["Neon"] = 98.52, ["Neon|Ride"] = 104.63, ["Neon|Fly|Ride"] = 124.5, ["Mega"] = 391.27, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 419.08}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 52.5, ["Ride"] = 98.44, ["Fly|Ride"] = 157.5, ["Neon"] = 279.33, ["Neon|Ride"] = 261.54, ["Neon|Fly|Ride"] = 423.82, ["Mega|Ride"] = 1219.78, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 28.26, ["Ride"] = 15.7, ["Fly|Ride"] = 47.25, ["Neon"] = 2.63, ["Neon|Fly"] = 27.72, ["Neon|Ride"] = 15.74, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 20.93, ["Mega|Ride"] = 45.09, ["Mega|Fly|Ride"] = 103.94}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 3.94, ["Ride"] = 36.75, ["Fly|Ride"] = 98.65, ["Neon"] = 17.32, ["Neon|Ride"] = 64.87, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 149.63, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 513.19}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 12.37, ["Ride"] = 62.21, ["Neon"] = 177.19, ["Neon|Ride"] = 307.8, ["Neon|Fly|Ride"] = 615.48, ["Mega"] = 691.56, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 628.69}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 23.02, ["Neon"] = 2.63, ["Neon|Ride"] = 28.13, ["Neon|Fly|Ride"] = 125.55, ["Mega"] = 23.02, ["Mega|Ride"] = 138.1, ["Mega|Fly|Ride"] = 410.17}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 2.59, ["Fly"] = 210, ["Ride"] = 73.24, ["Fly|Ride"] = 111.57, ["Neon"] = 40.69, ["Neon|Ride"] = 92.22, ["Neon|Fly|Ride"] = 181.22, ["Mega"] = 118.13, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 418.46}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 12.6, ["Fly"] = 41.86, ["Ride"] = 32.82, ["Fly|Ride"] = 46.12, ["Neon"] = 140.19, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 697.76, ["Mega|Fly|Ride"] = 466.55}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 2.63, ["Ride"] = 23.03, ["Neon"] = 19.67, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 200.82, ["Mega"] = 150.94, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 288.73}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 16.92, ["Fly"] = 2092.22, ["Neon"] = 111.57, ["Neon|Ride"] = 493.39, ["Neon|Fly|Ride"] = 6146.69, ["Mega"] = 468.48, ["Mega|Ride"] = 654.29, ["Mega|Fly|Ride"] = 662.17}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 3.93, ["Ride"] = 24.07, ["Fly|Ride"] = 196.88, ["Neon"] = 7.49, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 70.1, ["Mega"] = 79.52, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 408.19, ["Mega|Fly|Ride"] = 288.74}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 28.26, ["Neon"] = 3.93, ["Mega"] = 26.25, ["Mega|Ride"] = 128.94}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 30.35}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 62.27, ["Fly"] = 77.42, ["Ride"] = 78.75, ["Fly|Ride"] = 204.01, ["Neon"] = 1050, ["Neon|Fly|Ride"] = 1046.12, ["Mega|Ride"] = 974.98, ["Mega|Fly|Ride"] = 889.88}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 140.19, ["Neon"] = 2.18, ["Mega"] = 18.84, ["Mega|Ride"] = 103.56, ["Mega|Fly|Ride"] = 140.19}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 606.76, ["Ride"] = 761.25, ["Fly|Ride"] = 654.93, ["Neon"] = 4184.43, ["Neon|Fly|Ride"] = 2371.52, ["Mega"] = 16737.67, ["Mega|Fly|Ride"] = 6904.3}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 2.63, ["Fly"] = 49.88, ["Ride"] = 40.81, ["Fly|Ride"] = 54.2, ["Neon"] = 30.19, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 558.64, ["Mega|Fly|Ride"] = 558.64}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.63, ["Ride"] = 21.19, ["Fly|Ride"] = 87.89, ["Neon"] = 26.25, ["Neon|Ride"] = 35.48, ["Neon|Fly|Ride"] = 86.84, ["Mega"] = 167.4, ["Mega|Ride"] = 179.82, ["Mega|Fly|Ride"] = 530.39}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 16.3, ["Ride"] = 49.18, ["Fly|Ride"] = 148.56, ["Neon"] = 343.13, ["Neon|Ride"] = 418.46, ["Mega"] = 1033.57, ["Mega|Ride"] = 501.1, ["Mega|Fly|Ride"] = 832.72}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 3.15, ["Fly"] = 56.51, ["Ride"] = 31.5, ["Fly|Ride"] = 393.75, ["Neon"] = 140.19, ["Mega"] = 292.92, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 7.85, ["Ride"] = 60.68, ["Fly|Ride"] = 157.5, ["Neon"] = 63.35, ["Neon|Ride"] = 175.76, ["Neon|Fly|Ride"] = 350.44, ["Mega"] = 414.58, ["Mega|Ride"] = 474.94, ["Mega|Fly|Ride"] = 523.06}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 7.76, ["Fly"] = 105, ["Ride"] = 28.26, ["Fly|Ride"] = 131.25, ["Neon"] = 15.75, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 138.1, ["Mega"] = 199.5, ["Mega|Fly"] = 483.31, ["Mega|Ride"] = 279.33, ["Mega|Fly|Ride"] = 294}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 46.13, ["Ride"] = 18.84, ["Fly|Ride"] = 75.33, ["Neon"] = 2.1, ["Neon|Fly"] = 41.99, ["Neon|Ride"] = 13.13, ["Neon|Fly|Ride"] = 60.1, ["Mega"] = 14.44, ["Mega|Fly"] = 77.24, ["Mega|Ride"] = 46.12, ["Mega|Fly|Ride"] = 65.63}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 6.28, ["Ride"] = 39.38, ["Fly|Ride"] = 70.1, ["Neon"] = 45.09, ["Neon|Fly"] = 385.03, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 230.53, ["Mega"] = 131.82, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 279.33}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 259.88, ["Ride"] = 300.57, ["Fly|Ride"] = 318.63, ["Neon"] = 1480.5, ["Neon|Ride"] = 1604.74, ["Neon|Fly|Ride"] = 1374.59, ["Mega|Fly|Ride"] = 5669.52}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 89.25, ["Ride"] = 145.69, ["Fly|Ride"] = 249.38, ["Neon|Ride"] = 330.81, ["Neon|Fly|Ride"] = 941.51, ["Mega"] = 4184.43, ["Mega|Ride"] = 1987.61, ["Mega|Fly|Ride"] = 1682.67}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 24.94, ["Fly|Ride"] = 39.37, ["Neon"] = 11.82, ["Neon|Ride"] = 23.07, ["Neon|Fly|Ride"] = 53.45, ["Mega|Fly"] = 208.2, ["Mega|Ride"] = 91.03, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 18.31, ["Ride"] = 15.68, ["Fly|Ride"] = 31.17, ["Neon"] = 7.87, ["Neon|Fly"] = 54.2, ["Neon|Ride"] = 22.97, ["Neon|Fly|Ride"] = 35.55, ["Mega"] = 131.78, ["Mega|Ride"] = 140.19, ["Mega|Fly|Ride"] = 162.75}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.63, ["Ride"] = 18.98, ["Fly|Ride"] = 98.44, ["Neon"] = 39.38, ["Mega"] = 140.19}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 330.59, ["Ride"] = 276.94, ["Fly|Ride"] = 397.06, ["Neon|Ride"] = 1255.34, ["Neon|Fly|Ride"] = 1813.96, ["Mega|Ride"] = 8368.84, ["Mega|Fly|Ride"] = 4764.76}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.61, ["Fly"] = 26.54, ["Ride"] = 18.38, ["Fly|Ride"] = 42, ["Neon"] = 12.32, ["Neon|Fly"] = 154.48, ["Neon|Ride"] = 56.51, ["Neon|Fly|Ride"] = 77.24, ["Mega"] = 265.72, ["Mega|Ride"] = 184.13, ["Mega|Fly|Ride"] = 300.3}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 3.86, ["Fly"] = 123.38, ["Ride"] = 39.41, ["Fly|Ride"] = 209.24, ["Neon"] = 23.07, ["Neon|Ride"] = 223.13, ["Mega"] = 223.88, ["Mega|Ride"] = 204.75, ["Mega|Fly|Ride"] = 306.6}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 91.88, ["Neon"] = 3.93, ["Neon|Ride"] = 45.94, ["Mega"] = 39.77, ["Mega|Ride"] = 94.5, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 18.38, ["Fly"] = 83.7, ["Ride"] = 32.82, ["Fly|Ride"] = 60.78, ["Neon"] = 145.43, ["Neon|Ride"] = 90.92, ["Neon|Fly|Ride"] = 127.32, ["Mega"] = 570.54, ["Mega|Ride"] = 404.86, ["Mega|Fly|Ride"] = 767.86}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 38.06, ["Ride"] = 81.21, ["Fly|Ride"] = 127.99, ["Neon"] = 137.92, ["Neon|Fly"] = 307.8, ["Neon|Ride"] = 182.44, ["Neon|Fly|Ride"] = 218.19, ["Mega"] = 418.95, ["Mega|Fly"] = 585.83, ["Mega|Ride"] = 511.6, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 22.32, ["Fly"] = 131.25, ["Ride"] = 41.91, ["Fly|Ride"] = 90.57, ["Neon"] = 140.19, ["Neon|Ride"] = 174.71, ["Neon|Fly|Ride"] = 223.95, ["Mega|Ride"] = 783.12, ["Mega|Fly|Ride"] = 726.01}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 20.89, ["Ride"] = 71.49, ["Fly|Ride"] = 51.45, ["Neon"] = 2.1, ["Neon|Fly"] = 28.26, ["Neon|Ride"] = 23.07, ["Neon|Fly|Ride"] = 56.51, ["Mega"] = 18.38, ["Mega|Fly"] = 54.41, ["Mega|Ride"] = 58.8, ["Mega|Fly|Ride"] = 161.38}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 215.25, ["Ride"] = 262.5, ["Fly|Ride"] = 313.69, ["Neon|Ride"] = 906.94, ["Neon|Fly|Ride"] = 1046.12, ["Mega|Fly|Ride"] = 3412.5}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 12.47, ["Fly"] = 210, ["Ride"] = 45.94, ["Neon"] = 118.13, ["Neon|Ride"] = 125.55, ["Mega"] = 558.64, ["Mega|Ride"] = 543.99, ["Mega|Fly|Ride"] = 518.44}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 24.94, ["Ride"] = 28.26, ["Fly|Ride"] = 59.07, ["Neon"] = 3.93, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 55.44, ["Mega|Fly"] = 111.57, ["Mega|Ride"] = 140.19, ["Mega|Fly|Ride"] = 278.23}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 140.19, ["Ride"] = 17.07, ["Neon"] = 3.94, ["Neon|Ride"] = 28.26, ["Neon|Fly|Ride"] = 94.44, ["Mega"] = 23.63, ["Mega|Fly"] = 137.06, ["Mega|Ride"] = 5993.4, ["Mega|Fly|Ride"] = 105.89}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 3.86, ["Ride"] = 26.25, ["Fly|Ride"] = 76.11, ["Neon"] = 17.07, ["Neon|Ride"] = 41.86, ["Neon|Fly|Ride"] = 182.04, ["Mega"] = 85.32, ["Mega|Ride"] = 116.76, ["Mega|Fly|Ride"] = 418.46}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 13.86, ["Fly"] = 32.29, ["Ride"] = 27.04, ["Fly|Ride"] = 67.02, ["Neon"] = 41.47, ["Neon|Ride"] = 85.79, ["Neon|Fly|Ride"] = 140.19, ["Mega"] = 538.76, ["Mega|Ride"] = 370.13, ["Mega|Fly|Ride"] = 445.6}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 7.83, ["Ride"] = 26.25, ["Neon"] = 101.07, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 208.2, ["Mega|Ride"] = 357.31, ["Mega|Fly|Ride"] = 445.65}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 52.41, ["Fly|Ride"] = 49.18, ["Neon"] = 3.63, ["Neon|Ride"] = 45.94, ["Mega"] = 15.75, ["Mega|Ride"] = 65.91, ["Mega|Fly|Ride"] = 127.32}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 12.79, ["Ride"] = 92.25, ["Fly|Ride"] = 94.17, ["Neon"] = 34.8, ["Neon|Fly"] = 102.92, ["Neon|Ride"] = 56.51, ["Neon|Fly|Ride"] = 119.27, ["Mega"] = 146.4, ["Mega|Fly|Ride"] = 283.5}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 210, ["Neon"] = 6.92, ["Neon|Ride"] = 91.88, ["Mega"] = 31.5, ["Mega|Ride"] = 94.17, ["Mega|Fly|Ride"] = 615.48}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 40.05, ["Ride"] = 24.94, ["Fly|Ride"] = 118.13, ["Neon"] = 8.39, ["Neon|Ride"] = 27.21, ["Neon|Fly|Ride"] = 116.12, ["Mega"] = 91.88, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 195.8}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 1378.13, ["Ride"] = 1181.25, ["Fly|Ride"] = 1604.74, ["Neon|Fly|Ride"] = 4723.17, ["Mega|Fly|Ride"] = 13830.91}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 19.69, ["Fly|Ride"] = 23.07, ["Neon"] = 23.02, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 104.63, ["Mega"] = 187.27, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.63, ["Ride"] = 41.86, ["Fly|Ride"] = 59.07, ["Neon"] = 5.97, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 39.77, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 200.68}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 7.86, ["Fly"] = 46.04, ["Ride"] = 19.69, ["Fly|Ride"] = 56.44, ["Neon"] = 62.27, ["Neon|Fly"] = 56.51, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 439.84, ["Mega|Fly|Ride"] = 299.69}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 17.07, ["Fly|Ride"] = 31.5, ["Neon"] = 7.77, ["Neon|Fly"] = 89.24, ["Neon|Ride"] = 21.9, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 73.36, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 199.5}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 44.62, ["Neon"] = 316.99, ["Neon|Ride"] = 254.77, ["Neon|Fly|Ride"] = 313.85, ["Mega"] = 769.13, ["Mega|Ride"] = 1031.57}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 30.19, ["Neon"] = 7.67, ["Neon|Ride"] = 34.59, ["Neon|Fly|Ride"] = 108.35, ["Mega"] = 116.12, ["Mega|Ride"] = 83.7, ["Mega|Fly|Ride"] = 388.13}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 73.5, ["Ride"] = 31.13, ["Fly|Ride"] = 65.63, ["Neon"] = 13.13, ["Neon|Fly"] = 146.47, ["Neon|Ride"] = 70.09, ["Neon|Fly|Ride"] = 140.19, ["Mega"] = 209.24, ["Mega|Ride"] = 292.92, ["Mega|Fly|Ride"] = 418.46}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly|Ride"] = 65.85, ["Neon"] = 12.56, ["Neon|Fly"] = 62.27, ["Mega"] = 63, ["Mega|Ride"] = 154.46}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 2593.49, ["Ride"] = 23.36, ["Fly|Ride"] = 98.44, ["Neon"] = 3.84, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 89.25, ["Mega|Fly"] = 108.81, ["Mega|Ride"] = 67.67, ["Mega|Fly|Ride"] = 138.33}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 17.26, ["Fly"] = 39.77, ["Ride"] = 28.26, ["Fly|Ride"] = 43.32, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 78.73, ["Mega"] = 836.91, ["Mega|Ride"] = 517.83, ["Mega|Fly|Ride"] = 502.15}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 784.88, ["Ride"] = 845.25, ["Fly|Ride"] = 921.03, ["Neon"] = 2066.07, ["Neon|Ride"] = 2199.96, ["Neon|Fly|Ride"] = 2098.69, ["Mega"] = 6974.39, ["Mega|Ride"] = 5643.75, ["Mega|Fly|Ride"] = 4987.5}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 14.44, ["Ride"] = 18.84, ["Fly|Ride"] = 45, ["Neon"] = 4.2, ["Neon|Fly"] = 28.26, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 89.92, ["Mega"] = 27.57, ["Mega|Fly"] = 108.81, ["Mega|Ride"] = 77.24, ["Mega|Fly|Ride"] = 101.07}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 7.88, ["Ride"] = 41.86, ["Neon"] = 39.38, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 334.77, ["Mega"] = 274.32, ["Mega|Ride"] = 259.45, ["Mega|Fly|Ride"] = 441}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 92.3, ["Ride"] = 90.48, ["Fly|Ride"] = 167.35, ["Neon|Ride"] = 461.34, ["Neon|Fly|Ride"] = 627.68, ["Mega"] = 2920.64, ["Mega|Fly|Ride"] = 3062.07}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 35.41, ["Ride"] = 70.32, ["Fly|Ride"] = 301.88, ["Neon"] = 125.55, ["Neon|Ride"] = 177.19, ["Mega"] = 823.3, ["Mega|Ride"] = 724.74, ["Mega|Fly|Ride"] = 706.13}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 12.84, ["Fly|Ride"] = 316.99, ["Neon"] = 82.64, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 223.61, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 965.06}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 64.62, ["Ride"] = 112.35, ["Neon"] = 121.36, ["Neon|Ride"] = 353.92, ["Mega"] = 279.33, ["Mega|Ride"] = 340.74, ["Mega|Fly|Ride"] = 431.17}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 27.87, ["Ride"] = 315, ["Neon"] = 166.02, ["Neon|Ride"] = 313.85, ["Neon|Fly|Ride"] = 525, ["Mega"] = 721.88, ["Mega|Ride"] = 778.28, ["Mega|Fly|Ride"] = 772.42}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 7.8}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 4.59, ["Ride"] = 41.86, ["Neon"] = 59.12, ["Neon|Ride"] = 70.1, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 443.31, ["Mega|Ride"] = 216.57, ["Mega|Fly|Ride"] = 397.53}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 3.81, ["Neon"] = 35.57, ["Mega"] = 860.99, ["Mega|Fly|Ride"] = 941.51}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 54.53, ["Fly"] = 57.75, ["Ride"] = 52.5, ["Fly|Ride"] = 136.01, ["Neon"] = 209.24, ["Neon|Ride"] = 229.1, ["Neon|Fly|Ride"] = 354.37, ["Mega|Ride"] = 681.19, ["Mega|Fly|Ride"] = 780.94}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.44, ["Fly"] = 26.17, ["Ride"] = 15.73, ["Fly|Ride"] = 59.96, ["Neon"] = 27.55, ["Neon|Fly"] = 41.86, ["Neon|Ride"] = 35.75, ["Neon|Fly|Ride"] = 76.08, ["Mega"] = 307.75, ["Mega|Ride"] = 137.82, ["Mega|Fly|Ride"] = 241.5}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 7.33, ["Ride"] = 27.55, ["Fly|Ride"] = 91.88, ["Neon"] = 31.5, ["Neon|Ride"] = 56.51, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 157.49, ["Mega|Fly"] = 301.45, ["Mega|Ride"] = 181.13, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 5.25, ["Neon|Ride"] = 197.13, ["Mega"] = 45}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 33.38, ["Ride"] = 63, ["Fly|Ride"] = 353.92, ["Neon"] = 182.04, ["Neon|Ride"] = 209.24, ["Neon|Fly|Ride"] = 279.33, ["Mega"] = 1076.52, ["Mega|Ride"] = 827.91, ["Mega|Fly|Ride"] = 758.41}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Neon"] = 5.25, ["Neon|Fly"] = 145.69, ["Mega"] = 125.55, ["Mega|Ride"] = 208.2}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 15.7, ["Ride"] = 140.63, ["Neon"] = 65.63, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 292.92, ["Mega"] = 292.92, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 558.64}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 23.63, ["Ride"] = 17.07, ["Fly|Ride"] = 61.69, ["Neon"] = 27.24, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 34.59, ["Mega|Ride"] = 196.23, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 6.28, ["Fly"] = 52.5, ["Ride"] = 24.07, ["Fly|Ride"] = 49.88, ["Neon"] = 52.5, ["Neon|Ride"] = 28.26, ["Mega"] = 307.75, ["Mega|Ride"] = 417.41, ["Mega|Fly|Ride"] = 324.31}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 3.13, ["Ride"] = 129.31, ["Neon"] = 21, ["Neon|Ride"] = 111.57, ["Mega"] = 140.6, ["Mega|Ride"] = 534.85, ["Mega|Fly|Ride"] = 414.27}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 39.38, ["Fly"] = 118.13, ["Ride"] = 143.07, ["Neon"] = 309.66, ["Neon|Ride"] = 261.54, ["Mega"] = 899.67, ["Mega|Ride"] = 1255.34, ["Mega|Fly|Ride"] = 870.19}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 18.27, ["Ride"] = 245.84, ["Neon"] = 140.18, ["Neon|Fly|Ride"] = 384.98, ["Mega"] = 262.5, ["Mega|Ride"] = 447.75}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 11.68, ["Ride"] = 105, ["Neon"] = 91.62, ["Neon|Ride"] = 393.75, ["Mega"] = 427.62, ["Mega|Ride"] = 1538.71, ["Mega|Fly|Ride"] = 1673.79}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 15.73, ["Ride"] = 105, ["Fly|Ride"] = 517.67, ["Neon"] = 461.34, ["Mega"] = 766.5, ["Mega|Ride"] = 1076.52, ["Mega|Fly|Ride"] = 671.35}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 3.94, ["Neon"] = 44.63, ["Mega"] = 249.38, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 28.26, ["Ride"] = 20.93, ["Fly|Ride"] = 52.5, ["Neon"] = 6.55, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 55.63, ["Mega|Ride"] = 94.54, ["Mega|Fly|Ride"] = 192.5}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 3.93, ["Ride"] = 91.88, ["Fly|Ride"] = 91.03, ["Neon"] = 37.67, ["Neon|Ride"] = 87.39, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 198, ["Mega|Ride"] = 265.17}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 32.44, ["Ride"] = 23.02, ["Fly|Ride"] = 53.82, ["Neon"] = 6.56, ["Neon|Ride"] = 28.26, ["Neon|Fly|Ride"] = 87.89, ["Mega"] = 56.51, ["Mega|Ride"] = 97.13, ["Mega|Fly|Ride"] = 140.19}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 3.15, ["Ride"] = 19.69, ["Neon"] = 17.3, ["Neon|Ride"] = 92.24, ["Neon|Fly|Ride"] = 259.45, ["Mega"] = 249.38, ["Mega|Ride"] = 150.94, ["Mega|Fly|Ride"] = 461.05}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.51, ["Ride"] = 31.4, ["Fly|Ride"] = 83.7, ["Neon|Ride"] = 140.19, ["Mega"] = 418.46, ["Mega|Fly|Ride"] = 974.98}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 3.82, ["Fly"] = 41.86, ["Ride"] = 22.31, ["Fly|Ride"] = 56.51, ["Neon"] = 20.93, ["Neon|Fly"] = 98.35, ["Neon|Ride"] = 35.43, ["Neon|Fly|Ride"] = 105, ["Mega"] = 231.21, ["Mega|Fly"] = 187.27, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 195.64}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 34.07, ["Ride"] = 25.12, ["Fly|Ride"] = 41.86, ["Neon"] = 23.07, ["Neon|Ride"] = 81.86, ["Mega"] = 166.68, ["Mega|Ride"] = 140.19, ["Mega|Fly|Ride"] = 488.54}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 3.84, ["Ride"] = 347.03, ["Neon"] = 19.67, ["Neon|Fly"] = 61.72, ["Neon|Ride"] = 98.35, ["Neon|Fly|Ride"] = 455.28, ["Mega"] = 128.02, ["Mega|Ride"] = 305.82, ["Mega|Fly|Ride"] = 292.04}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 11.82, ["Ride"] = 98.44, ["Fly|Ride"] = 209.24, ["Neon"] = 53.42, ["Neon|Ride"] = 122.07, ["Mega"] = 367.5, ["Mega|Fly"] = 656.25, ["Mega|Ride"] = 474.94, ["Mega|Fly|Ride"] = 461.05}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 51.19, ["Fly"] = 196.01, ["Ride"] = 70.1, ["Fly|Ride"] = 291.38, ["Neon"] = 279.33, ["Neon|Ride"] = 278.25, ["Neon|Fly|Ride"] = 321.57, ["Mega"] = 1673.79, ["Mega|Ride"] = 997.5, ["Mega|Fly|Ride"] = 960.33}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Ride"] = 41.86, ["Neon"] = 3.93, ["Neon|Ride"] = 37.46, ["Mega"] = 31.4, ["Mega|Ride"] = 62.99, ["Mega|Fly|Ride"] = 120.31}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 17.07, ["Ride"] = 131.25, ["Neon"] = 54.55, ["Mega"] = 312.38, ["Mega|Ride"] = 404.86, ["Mega|Fly|Ride"] = 1241.75}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 44.36, ["Ride"] = 115.5, ["Neon"] = 282.97, ["Neon|Ride"] = 1116.21, ["Mega|Fly|Ride"] = 1224.01}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 6.57, ["Fly"] = 190.32, ["Ride"] = 38.52, ["Fly|Ride"] = 126, ["Neon"] = 39.35, ["Neon|Ride"] = 99.52, ["Neon|Fly|Ride"] = 140.19, ["Mega"] = 157.5, ["Mega|Ride"] = 179.95, ["Mega|Fly|Ride"] = 307.75}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 2.1, ["Fly"] = 157.5, ["Ride"] = 62.87, ["Fly|Ride"] = 137.82, ["Neon"] = 5.24, ["Neon|Ride"] = 26.81, ["Mega"] = 26.25, ["Mega|Ride"] = 62.68, ["Mega|Fly|Ride"] = 172.17}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 28.67, ["Ride"] = 16.78, ["Fly|Ride"] = 77.26, ["Neon"] = 18.38, ["Neon|Ride"] = 35.22, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 285.85, ["Mega|Ride"] = 154.46, ["Mega|Fly|Ride"] = 231}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 23.02, ["Ride"] = 18.04, ["Neon"] = 3.94, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 23.63, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 91.88}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 24.94, ["Fly|Ride"] = 91.03, ["Neon"] = 3.94, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 83.32, ["Mega"] = 35.58, ["Mega|Fly"] = 168, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 149.63}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Neon"] = 2.37, ["Neon|Ride"] = 32.82, ["Mega"] = 31.14, ["Mega|Ride"] = 104.63, ["Mega|Fly|Ride"] = 257.35}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 13.12, ["Ride"] = 157.5, ["Fly|Ride"] = 355.69, ["Neon"] = 27.56, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 627.68, ["Mega"] = 213.94, ["Mega|Ride"] = 292.77, ["Mega|Fly|Ride"] = 1115.16}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 51.19, ["Ride"] = 41.94, ["Fly|Ride"] = 209.24, ["Neon"] = 41.86, ["Neon|Ride"] = 104.63, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 376.62, ["Mega|Ride"] = 404.86, ["Mega|Fly|Ride"] = 697.76}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 6.28, ["Fly"] = 24.94, ["Ride"] = 19.69, ["Fly|Ride"] = 59.07, ["Neon"] = 145.69, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 89.25, ["Mega"] = 317.63, ["Mega|Fly|Ride"] = 378}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 65.63, ["Ride"] = 66.96, ["Fly|Ride"] = 262.5, ["Neon"] = 418.46, ["Neon|Ride"] = 523.06, ["Mega"] = 3073.93, ["Mega|Ride"] = 2092.22, ["Mega|Fly|Ride"] = 1537.55}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 17.33, ["Ride"] = 65.63, ["Neon"] = 44.63, ["Neon|Fly"] = 125.55, ["Mega"] = 613.14, ["Mega|Fly"] = 642.33, ["Mega|Ride"] = 600.48, ["Mega|Fly|Ride"] = 558.64}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 20.93, ["Ride"] = 22.93, ["Fly|Ride"] = 56.51, ["Neon"] = 3.29, ["Neon|Fly"] = 41.86, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 38.99, ["Mega|Ride"] = 107.63, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 23.02, ["Ride"] = 16.74, ["Fly|Ride"] = 39.58, ["Neon"] = 6.28, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 23.02, ["Neon|Fly|Ride"] = 51.19, ["Mega"] = 39.38, ["Mega|Ride"] = 70.1, ["Mega|Fly|Ride"] = 114.33}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 445.56, ["Fly"] = 523.06, ["Ride"] = 447.2, ["Fly|Ride"] = 511.88, ["Neon|Ride"] = 1534.64, ["Neon|Fly|Ride"] = 1813.96}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 13.11, ["Ride"] = 140.19, ["Neon"] = 55.13, ["Neon|Ride"] = 279.33, ["Neon|Fly|Ride"] = 397.53, ["Mega"] = 495.48, ["Mega|Ride"] = 495.87, ["Mega|Fly|Ride"] = 418.46}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 26.88, ["Ride"] = 17.07, ["Fly|Ride"] = 41.86, ["Neon"] = 6.3, ["Neon|Ride"] = 20.79, ["Neon|Fly|Ride"] = 66.99, ["Mega|Ride"] = 71.47, ["Mega|Fly|Ride"] = 83.7}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 89.98, ["Ride"] = 111.43, ["Fly|Ride"] = 315, ["Neon"] = 275.48, ["Neon|Ride"] = 292.64, ["Neon|Fly|Ride"] = 474.94, ["Mega"] = 1041.38, ["Mega|Ride"] = 859.69, ["Mega|Fly|Ride"] = 1064.96}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 45, ["Ride"] = 16.99, ["Fly|Ride"] = 43.32, ["Neon"] = 7.85, ["Neon|Fly"] = 89.98, ["Neon|Ride"] = 25.38, ["Neon|Fly|Ride"] = 73.24, ["Mega"] = 88.65, ["Mega|Ride"] = 127.09, ["Mega|Fly|Ride"] = 206.09}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Ride"] = 77.26, ["Neon"] = 2.6, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 283.5, ["Mega"] = 17.05, ["Mega|Ride"] = 83.99, ["Mega|Fly|Ride"] = 195.64}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 66.94, ["Ride"] = 112.77, ["Neon"] = 162.07, ["Neon|Ride"] = 272.67, ["Neon|Fly|Ride"] = 417.41, ["Mega"] = 765.76, ["Mega|Ride"] = 823.3, ["Mega|Fly|Ride"] = 786.19}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Neon"] = 10.43, ["Neon|Ride"] = 50.23, ["Mega"] = 96.85, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 40.66, ["Fly"] = 140.19, ["Ride"] = 66.88, ["Fly|Ride"] = 207.15, ["Neon"] = 140.19, ["Neon|Ride"] = 200.87, ["Neon|Fly|Ride"] = 259.45, ["Mega|Ride"] = 1673.79}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 7.87, ["Ride"] = 31.4, ["Neon"] = 57.75, ["Neon|Ride"] = 418.46, ["Mega"] = 170.63, ["Mega|Ride"] = 836.91, ["Mega|Fly|Ride"] = 486.29}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.1, ["Fly"] = 70.1, ["Ride"] = 102.62, ["Neon"] = 13.84, ["Neon|Fly"] = 62.78, ["Neon|Ride"] = 171.94, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 420, ["Mega|Ride"] = 569.63, ["Mega|Fly|Ride"] = 558.64}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 30.45, ["Ride"] = 46.13, ["Fly|Ride"] = 140.19, ["Neon"] = 558.64, ["Mega|Ride"] = 1046.12, ["Mega|Fly|Ride"] = 1229.82}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 131.62, ["Ride"] = 89.25, ["Fly|Ride"] = 239.78, ["Neon"] = 6.56, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 83.7, ["Neon|Fly|Ride"] = 140.19, ["Mega"] = 45.93, ["Mega|Fly"] = 158.61, ["Mega|Ride"] = 82.85, ["Mega|Fly|Ride"] = 268.68}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 27.21, ["Ride"] = 23.6, ["Fly|Ride"] = 72.19, ["Neon"] = 6.57, ["Neon|Fly"] = 41.88, ["Neon|Ride"] = 41.86, ["Neon|Fly|Ride"] = 107.77, ["Mega"] = 209.24, ["Mega|Fly|Ride"] = 284.17}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 9.17, ["Ride"] = 31.14, ["Neon"] = 39.38, ["Neon|Ride"] = 83.69, ["Neon|Fly|Ride"] = 182.04, ["Mega"] = 254.63, ["Mega|Ride"] = 450.89, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 26.24, ["Ride"] = 60.38, ["Fly|Ride"] = 368.9, ["Neon"] = 195.62, ["Neon|Ride"] = 240.61, ["Neon|Fly|Ride"] = 322.74, ["Mega"] = 513.18, ["Mega|Ride"] = 625.59, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 20.76, ["Fly"] = 182.04, ["Ride"] = 41.85, ["Fly|Ride"] = 76.13, ["Neon"] = 103.69, ["Neon|Ride"] = 104.63, ["Neon|Fly|Ride"] = 244.8, ["Mega"] = 405.9, ["Mega|Ride"] = 418.46, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 64.84, ["Fly"] = 196.88, ["Ride"] = 111.57, ["Fly|Ride"] = 279.33, ["Neon"] = 353.07, ["Neon|Ride"] = 385.88, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 1260, ["Mega|Ride"] = 1302, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 3.93, ["Ride"] = 32.01, ["Fly|Ride"] = 262.5, ["Neon"] = 23.02, ["Neon|Ride"] = 140.19, ["Neon|Fly|Ride"] = 313.85, ["Mega"] = 134.39, ["Mega|Ride"] = 154.46, ["Mega|Fly|Ride"] = 327.48}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 6.57, ["Ride"] = 39.77, ["Fly|Ride"] = 108.81, ["Neon"] = 21.9, ["Neon|Ride"] = 69.05, ["Mega"] = 105, ["Mega|Ride"] = 198.21}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 15.68, ["Ride"] = 39.77, ["Fly|Ride"] = 157.5, ["Neon"] = 31.14, ["Neon|Ride"] = 125.55, ["Mega"] = 366.19, ["Mega|Ride"] = 558.64, ["Mega|Fly|Ride"] = 458.07}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.05, ["Fly"] = 15.75, ["Ride"] = 15.7, ["Fly|Ride"] = 37.67, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 30.35, ["Mega"] = 12.55, ["Mega|Fly"] = 77.24, ["Mega|Ride"] = 24.07, ["Mega|Fly|Ride"] = 98.44}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 57.75, ["Fly"] = 220.5, ["Ride"] = 418.46, ["Neon"] = 368.9, ["Neon|Fly"] = 2371.52, ["Neon|Ride"] = 291.37, ["Neon|Fly|Ride"] = 418.46, ["Mega"] = 1144.45, ["Mega|Fly"] = 956.16, ["Mega|Ride"] = 891.19, ["Mega|Fly|Ride"] = 914.47}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 20.76, ["Fly|Ride"] = 89.24, ["Neon"] = 6.45, ["Neon|Ride"] = 52.5, ["Mega"] = 106.72, ["Mega|Fly"] = 111.95, ["Mega|Fly|Ride"] = 210.76}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 28.26, ["Ride"] = 23.02, ["Fly|Ride"] = 62.78, ["Neon"] = 20.31, ["Neon|Ride"] = 62.78, ["Neon|Fly|Ride"] = 70.1, ["Mega|Ride"] = 209.24, ["Mega|Fly|Ride"] = 279.33}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 72.19, ["Fly"] = 209.24, ["Ride"] = 105.67, ["Neon"] = 208.69, ["Neon|Ride"] = 211.97, ["Neon|Fly|Ride"] = 585.83, ["Mega"] = 958.13, ["Mega|Ride"] = 912.19, ["Mega|Fly|Ride"] = 1010.63}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 15.7, ["Neon"] = 5.25, ["Neon|Ride"] = 1395.52, ["Neon|Fly|Ride"] = 104.91, ["Mega"] = 48.57, ["Mega|Ride"] = 75.47, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 17.28}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 26.07, ["Fly|Ride"] = 104.99, ["Neon"] = 5.24, ["Neon|Ride"] = 33.45, ["Mega"] = 40.69, ["Mega|Ride"] = 115.5, ["Mega|Fly|Ride"] = 238.93}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 118.12, ["Ride"] = 196.88, ["Fly|Ride"] = 209.24, ["Neon"] = 481.69, ["Neon|Ride"] = 702.19, ["Neon|Fly|Ride"] = 732.29, ["Mega"] = 3347.55, ["Mega|Fly|Ride"] = 2493.75}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 6.57, ["Ride"] = 41.99, ["Neon"] = 18.38, ["Neon|Ride"] = 61.69, ["Mega"] = 279.33, ["Mega|Ride"] = 293.93, ["Mega|Fly|Ride"] = 395.45}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 209.24, ["Neon"] = 6.57, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 26.25, ["Mega|Ride"] = 77.42, ["Mega|Fly|Ride"] = 312.9}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 7.87, ["Ride"] = 29.99, ["Neon"] = 42, ["Neon|Ride"] = 140.19, ["Neon|Fly|Ride"] = 154.46, ["Mega"] = 853.13, ["Mega|Ride"] = 600.48, ["Mega|Fly|Ride"] = 558.56}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 9.19, ["Fly"] = 74.28, ["Ride"] = 24.94, ["Neon"] = 145.69, ["Neon|Fly|Ride"] = 269.91, ["Mega"] = 349.97, ["Mega|Ride"] = 468.66, ["Mega|Fly|Ride"] = 538.13}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 30.91, ["Ride"] = 69.18, ["Neon"] = 145.9, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 266.13, ["Mega"] = 585.83, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 140.43, ["Fly"] = 208.2, ["Ride"] = 136.5, ["Fly|Ride"] = 195.57, ["Neon"] = 627.68, ["Neon|Ride"] = 492.19, ["Neon|Fly|Ride"] = 590.63, ["Mega|Fly|Ride"] = 3052.54}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 7.01, ["Fly"] = 27.26, ["Ride"] = 18.38, ["Fly|Ride"] = 35.41, ["Neon"] = 35.32, ["Neon|Ride"] = 70.1, ["Neon|Fly|Ride"] = 84, ["Mega"] = 418.46, ["Mega|Ride"] = 697.76, ["Mega|Fly|Ride"] = 360.94}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.1, ["Fly"] = 131.23, ["Ride"] = 43.98, ["Fly|Ride"] = 59.07, ["Neon"] = 18.85, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 124.69, ["Mega"] = 136.02, ["Mega|Fly|Ride"] = 397.53}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 9.01, ["Fly"] = 230.6, ["Ride"] = 69.29, ["Fly|Ride"] = 78.75, ["Neon"] = 91.88, ["Neon|Ride"] = 307.8, ["Mega"] = 499.87, ["Mega|Ride"] = 461.05, ["Mega|Fly|Ride"] = 433.11}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 34.65, ["Ride"] = 74.28, ["Fly|Ride"] = 124.69, ["Neon"] = 154.75, ["Neon|Ride"] = 209.24, ["Neon|Fly|Ride"] = 294, ["Mega"] = 844.23, ["Mega|Fly"] = 977.07, ["Mega|Ride"] = 778.32, ["Mega|Fly|Ride"] = 865.75}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 16.89, ["Fly"] = 65.63, ["Ride"] = 81.84, ["Neon"] = 131.25, ["Neon|Ride"] = 209.24, ["Mega"] = 656.25, ["Mega|Ride"] = 732.29, ["Mega|Fly|Ride"] = 523.06}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 261.54, ["Ride"] = 261.54, ["Fly|Ride"] = 459.38, ["Neon"] = 1994.93, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1255.34, ["Mega|Ride"] = 3937.5, ["Mega|Fly|Ride"] = 5647.92}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 34.59, ["Fly"] = 140.19, ["Ride"] = 38.07, ["Fly|Ride"] = 111.93, ["Neon"] = 279.33, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 1195.69, ["Mega|Ride"] = 537.65, ["Mega|Fly|Ride"] = 688.35}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 28.26, ["Ride"] = 16.76, ["Neon"] = 2.1, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 61.69, ["Mega"] = 29.98, ["Mega|Fly"] = 13.13, ["Mega|Ride"] = 101.43, ["Mega|Fly|Ride"] = 123.35}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 2.1, ["Neon"] = 15.7, ["Neon|Ride"] = 39.38, ["Mega"] = 125.93, ["Mega|Ride"] = 263.63, ["Mega|Fly|Ride"] = 460.04}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 2.61, ["Ride"] = 102.37, ["Neon"] = 18.38, ["Neon|Ride"] = 62.78, ["Neon|Fly|Ride"] = 1181.25, ["Mega"] = 78.75, ["Mega|Fly"] = 223.88, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 392.44, ["Fly"] = 576.47, ["Ride"] = 417.38, ["Fly|Ride"] = 435.16, ["Neon"] = 1460.38, ["Neon|Ride"] = 1359.94, ["Neon|Fly|Ride"] = 1345.32, ["Mega|Fly|Ride"] = 4917.94}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.5, ["Fly"] = 70.1, ["Ride"] = 15.73, ["Fly|Ride"] = 56.44, ["Neon"] = 41.86, ["Neon|Ride"] = 69.57, ["Neon|Fly|Ride"] = 87.62, ["Mega|Ride"] = 315.6, ["Mega|Fly|Ride"] = 460.67}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 8.39, ["Fly"] = 93.12, ["Ride"] = 19.67, ["Fly|Ride"] = 45.94, ["Neon|Ride"] = 56.51, ["Neon|Fly|Ride"] = 98.35, ["Mega"] = 416.37, ["Mega|Ride"] = 697.76, ["Mega|Fly|Ride"] = 836.91}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 6.23, ["Fly"] = 83.7, ["Ride"] = 28.26, ["Fly|Ride"] = 103.76, ["Neon"] = 13.1, ["Neon|Fly"] = 70.1, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 127.96, ["Mega"] = 138.1, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 418.46}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 53.45, ["Fly"] = 210, ["Fly|Ride"] = 89.98, ["Neon"] = 118.13, ["Mega|Ride"] = 835.86, ["Mega|Fly|Ride"] = 613.19}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.63, ["Fly"] = 315, ["Ride"] = 63, ["Neon"] = 14.44, ["Neon|Ride"] = 77.25, ["Neon|Fly|Ride"] = 210, ["Mega|Ride"] = 108.35, ["Mega|Fly|Ride"] = 620.17}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 5.92, ["Fly"] = 787.5, ["Ride"] = 27.57, ["Fly|Ride"] = 91.88, ["Neon"] = 307.8, ["Neon|Ride"] = 141.75, ["Mega"] = 697.76, ["Mega|Ride"] = 320.12, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Fly|Ride"] = 60.68, ["Neon"] = 8.39, ["Mega"] = 85.32, ["Mega|Ride"] = 2551.45, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 12.38, ["Neon"] = 89.25, ["Mega|Fly|Ride"] = 627.68}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 10.47, ["Ride"] = 70.1, ["Fly|Ride"] = 140.19, ["Neon"] = 126.76, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 209.24, ["Mega"] = 308.61, ["Mega|Ride"] = 279.33, ["Mega|Fly|Ride"] = 1037.75}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 14.44, ["Fly"] = 37.67, ["Ride"] = 23.3, ["Fly|Ride"] = 52.5, ["Neon"] = 50.23, ["Neon|Ride"] = 76.1, ["Neon|Fly|Ride"] = 108.31, ["Mega"] = 587.93, ["Mega|Ride"] = 375.38, ["Mega|Fly|Ride"] = 461.56}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 203.44, ["Fly"] = 570.7, ["Ride"] = 228.11, ["Fly|Ride"] = 280.72, ["Neon"] = 943.6, ["Neon|Ride"] = 1922.8, ["Neon|Fly|Ride"] = 843.29, ["Mega|Fly|Ride"] = 4184.43}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 15.7, ["Fly|Ride"] = 64.87, ["Neon"] = 83.7, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 108.29, ["Mega"] = 209.24, ["Mega|Ride"] = 321.17, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 3.26, ["Fly"] = 32.82, ["Ride"] = 23.63, ["Fly|Ride"] = 77.7, ["Neon"] = 21, ["Neon|Ride"] = 56.49, ["Neon|Fly|Ride"] = 295.32, ["Mega"] = 137.82, ["Mega|Ride"] = 768.79, ["Mega|Fly|Ride"] = 517.83}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 31.49, ["Ride"] = 77.44, ["Fly|Ride"] = 157.5, ["Neon"] = 108.12, ["Neon|Ride"] = 216.43, ["Neon|Fly|Ride"] = 558.64, ["Mega"] = 414.75, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 57.37, ["Ride"] = 92.06, ["Fly|Ride"] = 154.4, ["Neon"] = 283.45, ["Neon|Ride"] = 461.12, ["Neon|Fly|Ride"] = 471.8, ["Mega"] = 1358.9, ["Mega|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 1353.68}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 26.23, ["Ride"] = 56.51, ["Fly|Ride"] = 209.21, ["Neon"] = 81.73, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 209.24, ["Mega"] = 204.41, ["Mega|Ride"] = 282.19, ["Mega|Fly|Ride"] = 349.13}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 21.98, ["Fly|Ride"] = 38.96, ["Neon"] = 15.7, ["Neon|Fly|Ride"] = 121.36, ["Mega"] = 123.35, ["Mega|Fly|Ride"] = 349.41}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 11.8, ["Fly"] = 31.5, ["Ride"] = 41.86, ["Fly|Ride"] = 82.66, ["Neon"] = 59.07, ["Neon|Ride"] = 138.08, ["Neon|Fly|Ride"] = 418.46, ["Mega"] = 210, ["Mega|Ride"] = 280.17, ["Mega|Fly|Ride"] = 329.44}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 75.22, ["Ride"] = 110.06, ["Fly|Ride"] = 183.75, ["Neon"] = 196.88, ["Neon|Ride"] = 284.82, ["Neon|Fly|Ride"] = 419.11, ["Mega"] = 570.94, ["Mega|Ride"] = 505.24, ["Mega|Fly|Ride"] = 554.86}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.1, ["Fly|Ride"] = 91.88, ["Neon"] = 8.35, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 169.32, ["Mega"] = 38.07, ["Mega|Fly"] = 105, ["Mega|Ride"] = 104.15, ["Mega|Fly|Ride"] = 220.5}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 9.23, ["Ride"] = 288.75, ["Neon"] = 42, ["Neon|Ride"] = 652.78, ["Mega"] = 312.12, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 1047.38, ["Fly"] = 1325.43, ["Ride"] = 1050, ["Fly|Ride"] = 1050, ["Neon|Ride"] = 3075.19, ["Neon|Fly|Ride"] = 3150, ["Mega|Fly|Ride"] = 11025}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 31.11, ["Ride"] = 98.35, ["Fly|Ride"] = 221.8, ["Neon"] = 154.48, ["Neon|Ride"] = 237.47, ["Mega"] = 590.63, ["Mega|Ride"] = 526.32, ["Mega|Fly|Ride"] = 710.22}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 6.51, ["Fly"] = 49.88, ["Ride"] = 35.58, ["Fly|Ride"] = 209.24, ["Neon"] = 17.3, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 107.77, ["Mega"] = 88.55, ["Mega|Ride"] = 115.27, ["Mega|Fly|Ride"] = 293.76}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 17.33, ["Ride"] = 131.22, ["Neon"] = 78.75, ["Mega|Ride"] = 349.41, ["Mega|Fly|Ride"] = 697.76}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 49.18, ["Fly|Ride"] = 418.46, ["Neon"] = 2.61, ["Neon|Ride"] = 36.3, ["Neon|Fly|Ride"] = 100.44, ["Mega"] = 20.93, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 149.85}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 94.49, ["Ride"] = 111.93, ["Fly|Ride"] = 292.82, ["Neon"] = 341.24, ["Neon|Ride"] = 403.2, ["Neon|Fly|Ride"] = 487.5, ["Mega"] = 1312.5, ["Mega|Ride"] = 1441.55, ["Mega|Fly|Ride"] = 1245.57}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 6.3, ["Fly"] = 101.07, ["Ride"] = 41.85, ["Fly|Ride"] = 807.05, ["Neon"] = 27.21, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 154.46, ["Mega"] = 347.32, ["Mega|Ride"] = 253.32, ["Mega|Fly|Ride"] = 418.46}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 3.91, ["Ride"] = 36.63, ["Neon"] = 14.43, ["Neon|Ride"] = 39.38, ["Mega"] = 170.63, ["Mega|Ride"] = 276.19, ["Mega|Fly|Ride"] = 384.98}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 44.63, ["Fly"] = 98.35, ["Ride"] = 72.17, ["Fly|Ride"] = 131.02, ["Neon"] = 188.32, ["Neon|Ride"] = 349.41, ["Neon|Fly|Ride"] = 308.57, ["Mega"] = 530.39, ["Mega|Ride"] = 416.37, ["Mega|Fly|Ride"] = 450.19}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 14.43, ["Fly"] = 183.75, ["Neon"] = 85.32, ["Neon|Fly"] = 178.9, ["Neon|Ride"] = 146.47, ["Neon|Fly|Ride"] = 203.44, ["Mega"] = 393.75, ["Mega|Ride"] = 539.81, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 72.13, ["Ride"] = 279.33, ["Neon"] = 315, ["Neon|Ride"] = 933.19, ["Neon|Fly|Ride"] = 919.42, ["Mega"] = 1464.57, ["Mega|Ride"] = 1383.11, ["Mega|Fly|Ride"] = 1297.17}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 7.85, ["Ride"] = 65.63, ["Fly|Ride"] = 167.4, ["Neon"] = 21, ["Neon|Ride"] = 95.8, ["Neon|Fly|Ride"] = 90.57, ["Mega"] = 187.69, ["Mega|Ride"] = 185.53, ["Mega|Fly|Ride"] = 250.03}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 6.55, ["Fly"] = 196.88, ["Ride"] = 30.18, ["Fly|Ride"] = 70.09, ["Neon"] = 65.61, ["Neon|Ride"] = 79.52, ["Neon|Fly|Ride"] = 280.88, ["Mega"] = 313.85, ["Mega|Ride"] = 380.8, ["Mega|Fly|Ride"] = 401.72}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 152.25, ["Ride"] = 208.04, ["Fly|Ride"] = 253.13, ["Neon"] = 525, ["Neon|Ride"] = 532.88, ["Neon|Fly|Ride"] = 583.74, ["Mega"] = 2232.4, ["Mega|Ride"] = 2361.19, ["Mega|Fly|Ride"] = 1836.19}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 3.6, ["Fly"] = 39.38, ["Ride"] = 17.3, ["Fly|Ride"] = 56.51, ["Neon"] = 23.02, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 23.07, ["Neon|Fly|Ride"] = 78.47, ["Mega"] = 179.95, ["Mega|Ride"] = 160.13, ["Mega|Fly|Ride"] = 146.88}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 6.54, ["Fly"] = 87.94, ["Ride"] = 22.32, ["Fly|Ride"] = 51.19, ["Neon"] = 20.93, ["Neon|Ride"] = 53.82, ["Neon|Fly|Ride"] = 140.19, ["Mega"] = 211.77, ["Mega|Ride"] = 211.95, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 28.26, ["Ride"] = 18.84, ["Fly|Ride"] = 49.18, ["Neon"] = 2.1, ["Neon|Fly"] = 43.95, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 69.05, ["Mega"] = 23.02, ["Mega|Ride"] = 31.86, ["Mega|Fly|Ride"] = 64.31}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 31.4, ["Neon"] = 5.24, ["Neon|Ride"] = 41.86, ["Mega"] = 17.07, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 154.46}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.1, ["Fly"] = 131.18, ["Ride"] = 42, ["Neon"] = 38.06, ["Neon|Ride"] = 64.98, ["Mega"] = 140.19, ["Mega|Ride"] = 207.15}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 62.25, ["Ride"] = 315, ["Neon"] = 522.38, ["Neon|Ride"] = 452.82, ["Neon|Fly|Ride"] = 630, ["Mega"] = 774.38, ["Mega|Fly|Ride"] = 613.19}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 4.87, ["Fly"] = 22.32, ["Ride"] = 17.07, ["Fly|Ride"] = 41.52, ["Neon"] = 13.12, ["Neon|Fly"] = 31.14, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 51.19, ["Mega"] = 138.68, ["Mega|Fly"] = 209.24, ["Mega|Ride"] = 182.04, ["Mega|Fly|Ride"] = 197.71}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 6.18, ["Fly"] = 26.25, ["Ride"] = 26.24, ["Fly|Ride"] = 77.25, ["Neon"] = 19.9, ["Neon|Fly"] = 68.02, ["Neon|Ride"] = 28.26, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 137.82, ["Mega|Fly"] = 279.33, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 235.2}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Ride"] = 24.94, ["Fly|Ride"] = 72.19, ["Neon"] = 7.88, ["Neon|Fly"] = 98.44, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 106.32, ["Mega"] = 51.19, ["Mega|Fly"] = 408.19, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 7.71, ["Ride"] = 61.73, ["Neon"] = 26.24, ["Neon|Ride"] = 111.95, ["Neon|Fly|Ride"] = 189, ["Mega"] = 236.43, ["Mega|Ride"] = 299.92, ["Mega|Fly|Ride"] = 446.06}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 6.56, ["Fly"] = 152.75, ["Neon"] = 98.44, ["Neon|Ride"] = 262.5, ["Mega"] = 376.62, ["Mega|Ride"] = 412.13, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 3.86, ["Fly"] = 35.44, ["Ride"] = 27.2, ["Fly|Ride"] = 138.34, ["Neon"] = 26.23, ["Neon|Ride"] = 62.29, ["Neon|Fly|Ride"] = 105, ["Mega"] = 199.83, ["Mega|Fly"] = 209.24, ["Mega|Ride"] = 195.96, ["Mega|Fly|Ride"] = 469.71}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 24.07, ["Ride"] = 16.86, ["Fly|Ride"] = 49.18, ["Neon"] = 14.42, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 50.23, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 418.46, ["Mega|Ride"] = 154.46, ["Mega|Fly|Ride"] = 223.91}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 157.5, ["Fly"] = 393.75, ["Ride"] = 265.58, ["Fly|Ride"] = 446.13, ["Neon"] = 902.79, ["Neon|Ride"] = 1954.13, ["Neon|Fly|Ride"] = 897.75, ["Mega"] = 5579.93, ["Mega|Fly|Ride"] = 3661.88}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 3.91, ["Ride"] = 42, ["Neon"] = 30.19, ["Neon|Fly|Ride"] = 279.33, ["Mega"] = 154.83, ["Mega|Ride"] = 154.46, ["Mega|Fly|Ride"] = 977.07}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 3.03, ["Ride"] = 23.63, ["Fly|Ride"] = 96.26, ["Neon"] = 35.44, ["Neon|Ride"] = 57.66, ["Neon|Fly|Ride"] = 139.65, ["Mega"] = 203.44, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 313.85}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 5.25, ["Fly|Ride"] = 154.48, ["Neon"] = 28.06, ["Neon|Fly|Ride"] = 627.68, ["Mega"] = 413.23, ["Mega|Ride"] = 334.77, ["Mega|Fly|Ride"] = 418.46}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 12.56, ["Fly|Ride"] = 26.25, ["Neon"] = 2.1, ["Neon|Fly"] = 28.76, ["Neon|Ride"] = 22.11, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 16.37, ["Mega|Fly|Ride"] = 73.5}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 3.93, ["Fly"] = 56.47, ["Ride"] = 26.25, ["Fly|Ride"] = 45.94, ["Neon"] = 17.07, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 28.32, ["Mega"] = 184.13, ["Mega|Fly|Ride"] = 265.72}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 4.61, ["Ride"] = 65.63, ["Neon"] = 11.82, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 80.07, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 450.19}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 93.19, ["Ride"] = 99.64, ["Fly|Ride"] = 167.37, ["Neon"] = 393.75, ["Neon|Ride"] = 463.32, ["Neon|Fly|Ride"] = 437.07, ["Mega|Ride"] = 3488.77, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 3.92, ["Fly"] = 85.32, ["Ride"] = 59.07, ["Fly|Ride"] = 65.54, ["Neon"] = 18.84, ["Neon|Ride"] = 62.78, ["Neon|Fly|Ride"] = 307.75, ["Mega"] = 283.56, ["Mega|Fly|Ride"] = 215.52}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Ride"] = 56.51, ["Fly|Ride"] = 154.84, ["Neon"] = 13.86, ["Neon|Ride"] = 177.07, ["Neon|Fly|Ride"] = 517.52, ["Mega"] = 66.94, ["Mega|Fly"] = 408, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 209.24}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 59.07, ["Fly"] = 177.56, ["Ride"] = 116.13, ["Fly|Ride"] = 223.68, ["Neon"] = 89.77, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 330.75, ["Mega"] = 582.75, ["Mega|Ride"] = 519.75, ["Mega|Fly|Ride"] = 649.69}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 15.7, ["Ride"] = 16.8, ["Fly|Ride"] = 81.61, ["Neon"] = 2.63, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 43.86, ["Mega"] = 16.64, ["Mega|Ride"] = 54.47, ["Mega|Fly|Ride"] = 86.56}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Neon"] = 3.78, ["Neon|Ride"] = 62.27, ["Neon|Fly|Ride"] = 140.19, ["Mega"] = 19.38, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 3.94, ["Ride"] = 24.94, ["Neon"] = 8.97, ["Neon|Ride"] = 74.8, ["Mega"] = 105, ["Mega|Ride"] = 134.67, ["Mega|Fly|Ride"] = 308.61}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 7.87, ["Fly"] = 82.69, ["Ride"] = 45.94, ["Fly|Ride"] = 83.7, ["Neon"] = 23.63, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 69.57, ["Neon|Fly|Ride"] = 137.82, ["Mega"] = 126, ["Mega|Fly"] = 209.24, ["Mega|Ride"] = 124.63, ["Mega|Fly|Ride"] = 276.87}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.05, ["Fly"] = 15.7, ["Ride"] = 15.7, ["Fly|Ride"] = 91.34, ["Neon"] = 2.1, ["Neon|Fly"] = 23.02, ["Neon|Ride"] = 30.18, ["Neon|Fly|Ride"] = 74.82, ["Mega"] = 19.83, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 35.74, ["Mega|Fly|Ride"] = 133.71}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 13.68, ["Fly"] = 41.86, ["Ride"] = 39.38, ["Neon"] = 52.49, ["Neon|Fly|Ride"] = 176.54, ["Mega|Ride"] = 416.37, ["Mega|Fly|Ride"] = 388.13}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 3136.88, ["Ride"] = 3033.19, ["Fly|Ride"] = 3500.44, ["Neon|Fly|Ride"] = 10500}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 52.49, ["Ride"] = 16.65, ["Fly|Ride"] = 41.63, ["Neon"] = 8.39, ["Neon|Fly"] = 69.05, ["Neon|Ride"] = 22.91, ["Neon|Fly|Ride"] = 69.57, ["Mega"] = 81.61, ["Mega|Ride"] = 99.73, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 4.2, ["Neon"] = 12.46, ["Mega"] = 131.25, ["Mega|Ride"] = 418.46, ["Mega|Fly|Ride"] = 207.15}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 21, ["Ride"] = 36.91, ["Fly|Ride"] = 157.5, ["Neon"] = 70.08, ["Neon|Ride"] = 92.24, ["Neon|Fly|Ride"] = 132.87, ["Mega"] = 1046.12, ["Mega|Ride"] = 374.07, ["Mega|Fly|Ride"] = 689.39}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 39.37, ["Ride"] = 78.75, ["Fly|Ride"] = 140.19, ["Neon"] = 275.62, ["Neon|Fly|Ride"] = 418.46, ["Mega"] = 485.41, ["Mega|Ride"] = 623.44, ["Mega|Fly|Ride"] = 642.33}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 154.5, ["Fly"] = 237.47, ["Ride"] = 172.06, ["Fly|Ride"] = 239.61, ["Neon"] = 768.9, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 774.38, ["Neon|Fly|Ride"] = 836.91, ["Mega"] = 6276.63, ["Mega|Ride"] = 2999.19, ["Mega|Fly|Ride"] = 3517.5}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 9.24, ["Ride"] = 39.38, ["Fly|Ride"] = 111.95, ["Neon"] = 23.02, ["Neon|Ride"] = 123.36, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 806.81, ["Mega|Fly|Ride"] = 253.32}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 27.21, ["Neon"] = 16.58, ["Neon|Fly"] = 94.17, ["Neon|Ride"] = 34.13, ["Mega"] = 89.99, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 819}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.63, ["Fly"] = 101.99, ["Ride"] = 70.09, ["Neon"] = 8.34, ["Neon|Ride"] = 41.85, ["Mega"] = 59.07, ["Mega|Ride"] = 142.29, ["Mega|Fly|Ride"] = 287.44}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 13.05, ["Neon"] = 108.38, ["Neon|Ride"] = 209.24, ["Mega"] = 393.75, ["Mega|Ride"] = 461.05, ["Mega|Fly|Ride"] = 557.17}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 69.78, ["Neon"] = 2.1, ["Neon|Ride"] = 41.86, ["Mega"] = 15.75, ["Mega|Ride"] = 133.88, ["Mega|Fly|Ride"] = 151.01}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 72.17, ["Fly"] = 340.13, ["Ride"] = 418.46, ["Fly|Ride"] = 163.17, ["Neon"] = 366.19, ["Neon|Ride"] = 409.5, ["Neon|Fly|Ride"] = 455.44, ["Mega|Fly|Ride"] = 1316.44}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 32.29, ["Neon"] = 6.57, ["Mega"] = 98.35, ["Mega|Ride"] = 138.33}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 45.93, ["Fly"] = 215.61, ["Ride"] = 91.88, ["Neon"] = 265.92, ["Neon|Ride"] = 389.11, ["Neon|Fly|Ride"] = 308.61, ["Mega"] = 2625, ["Mega|Ride"] = 2789.97, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 23.02, ["Fly|Ride"] = 70.1, ["Neon"] = 5.13, ["Neon|Ride"] = 23.02, ["Mega"] = 52.5, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 210.67}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Neon"] = 9.19, ["Mega"] = 111.57, ["Mega|Ride"] = 234.25, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 11.48, ["Ride"] = 140.18, ["Neon"] = 60.73, ["Neon|Fly"] = 291.38, ["Neon|Ride"] = 78.75, ["Mega"] = 131.25, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 452.82}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 366.79, ["Ride"] = 388.68, ["Fly|Ride"] = 521.07, ["Neon"] = 1048.69, ["Neon|Ride"] = 1115.63, ["Neon|Fly|Ride"] = 1179.94, ["Mega"] = 3054.63, ["Mega|Ride"] = 3124.49, ["Mega|Fly|Ride"] = 3051.57}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 41.86, ["Fly"] = 70.1, ["Ride"] = 45.94, ["Fly|Ride"] = 140.19, ["Neon"] = 181.12, ["Neon|Fly"] = 307.8, ["Neon|Ride"] = 186.38, ["Neon|Fly|Ride"] = 266.77, ["Mega"] = 797.14, ["Mega|Fly|Ride"] = 905.63}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.63, ["Fly"] = 39.38, ["Ride"] = 19.9, ["Fly|Ride"] = 91.88, ["Neon"] = 7.22, ["Neon|Fly"] = 136.01, ["Neon|Ride"] = 23.97, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 63, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 279.33}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 11.58, ["Fly"] = 111.56, ["Ride"] = 31.14, ["Fly|Ride"] = 110.25, ["Neon"] = 33.64, ["Neon|Fly"] = 140.19, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 183.75, ["Mega|Fly"] = 370.97, ["Mega|Ride"] = 268.91, ["Mega|Fly|Ride"] = 332.68}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 7.33, ["Ride"] = 25.97, ["Fly|Ride"] = 104.63, ["Neon"] = 105, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 137.06, ["Mega"] = 404.86, ["Mega|Ride"] = 376.62, ["Mega|Fly|Ride"] = 481.22}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.93, ["Neon"] = 15.72, ["Mega"] = 36.75, ["Mega|Ride"] = 140.18, ["Mega|Fly|Ride"] = 188.32}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.61, ["Fly"] = 86.63, ["Ride"] = 22.32, ["Fly|Ride"] = 78.75, ["Neon"] = 46.12, ["Neon|Ride"] = 28.26, ["Neon|Fly|Ride"] = 279.33, ["Mega"] = 538.27, ["Mega|Ride"] = 486.94}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 111.56, ["Ride"] = 154.51, ["Fly|Ride"] = 210, ["Neon"] = 732.29, ["Neon|Ride"] = 628.69, ["Neon|Fly|Ride"] = 763.67, ["Mega|Ride"] = 2406.05, ["Mega|Fly|Ride"] = 2296.88}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 27.17, ["Ride"] = 78.75, ["Fly|Ride"] = 144, ["Neon"] = 78.47, ["Neon|Ride"] = 154.84, ["Mega|Ride"] = 653.52, ["Mega|Fly|Ride"] = 704.6}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2821.87, ["Fly"] = 3278.5, ["Ride"] = 2362.5, ["Fly|Ride"] = 2803.5, ["Neon"] = 12553.25, ["Neon|Ride"] = 9207.02, ["Neon|Fly|Ride"] = 6228.39, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 2.63, ["Fly"] = 65625, ["Ride"] = 22.1, ["Fly|Ride"] = 170.63, ["Neon"] = 11.84, ["Neon|Ride"] = 35.58, ["Mega"] = 62.89, ["Mega|Ride"] = 207.03, ["Mega|Fly|Ride"] = 422.63}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 10.49, ["Ride"] = 52.5, ["Fly|Ride"] = 209.24, ["Neon"] = 49.18, ["Neon|Ride"] = 60.38, ["Mega"] = 156.94, ["Mega|Ride"] = 261.54, ["Mega|Fly|Ride"] = 418.4}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 1050, ["Ride"] = 1176, ["Fly|Ride"] = 1023.75, ["Neon"] = 4028.56, ["Neon|Ride"] = 3626.85, ["Neon|Fly|Ride"] = 2887.5, ["Mega|Ride"] = 15841.16, ["Mega|Fly|Ride"] = 12373.32}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 72.19, ["Neon"] = 209.24, ["Mega|Ride"] = 1383.11, ["Mega|Fly|Ride"] = 1343.21}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 3.93, ["Ride"] = 35.44, ["Neon"] = 7.88, ["Neon|Ride"] = 69.44, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 190.98, ["Mega|Fly|Ride"] = 274.98}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Neon"] = 3.91, ["Mega"] = 28.26, ["Mega|Ride"] = 68.25, ["Mega|Fly|Ride"] = 119.27}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 95.68, ["Ride"] = 156.19, ["Fly|Ride"] = 656.25, ["Neon"] = 697.76, ["Neon|Ride"] = 551.32, ["Mega"] = 5250, ["Mega|Fly|Ride"] = 2510.67}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 5.17, ["Ride"] = 140.48, ["Neon"] = 17.4, ["Neon|Ride"] = 46.12, ["Mega"] = 187.03, ["Mega|Ride"] = 418.46, ["Mega|Fly|Ride"] = 263.82}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 133.76, ["Ride"] = 152.75, ["Neon"] = 603.75, ["Mega"] = 2092.22, ["Mega|Fly|Ride"] = 2510.67}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["Fly"] = 105, ["Neon"] = 31.14, ["Neon|Fly|Ride"] = 315, ["Mega"] = 224.44}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 262.49, ["Ride"] = 305.82, ["Fly|Ride"] = 391.37, ["Neon"] = 1766.63, ["Neon|Ride"] = 948.83, ["Neon|Fly|Ride"] = 905.63, ["Mega|Fly|Ride"] = 3997.18}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 3.65, ["Fly"] = 91.88, ["Ride"] = 23.63, ["Fly|Ride"] = 83.69, ["Neon"] = 42, ["Neon|Ride"] = 45.89, ["Neon|Fly|Ride"] = 116.82, ["Mega"] = 250.04, ["Mega|Ride"] = 307.75, ["Mega|Fly|Ride"] = 350.44}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 31.4, ["Ride"] = 13.13, ["Fly|Ride"] = 49.56, ["Neon"] = 3.93, ["Neon|Fly"] = 39.12, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 62.26, ["Mega"] = 39.38, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 136.43}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 859.69, ["Ride"] = 901.69, ["Fly|Ride"] = 951.57, ["Neon|Ride"] = 3861.73, ["Neon|Fly|Ride"] = 3556.76, ["Mega"] = 27661.8, ["Mega|Fly|Ride"] = 27896.45}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 9.13, ["Fly"] = 980.19, ["Ride"] = 40.69, ["Neon"] = 45.85, ["Mega"] = 150.94, ["Mega|Ride"] = 207.15, ["Mega|Fly|Ride"] = 403.6}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 7.82, ["Fly"] = 70.1, ["Ride"] = 39.51, ["Fly|Ride"] = 96.85, ["Neon"] = 28.13, ["Neon|Ride"] = 60.38, ["Neon|Fly|Ride"] = 140.19, ["Mega"] = 174.06, ["Mega|Ride"] = 196.81, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 37.94, ["Fly"] = 52.39, ["Ride"] = 38.06, ["Fly|Ride"] = 87.63, ["Neon|Ride"] = 196.77, ["Neon|Fly|Ride"] = 162.75, ["Mega"] = 2092.22, ["Mega|Fly|Ride"] = 813.75}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 14.9, ["Fly"] = 78.47, ["Ride"] = 28.25, ["Fly|Ride"] = 91.69, ["Neon"] = 59.07, ["Neon|Ride"] = 82.89, ["Neon|Fly|Ride"] = 184.43, ["Mega"] = 558.64, ["Mega|Ride"] = 735, ["Mega|Fly|Ride"] = 442.31}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 40.69, ["Ride"] = 54.21, ["Fly|Ride"] = 636.57, ["Neon"] = 91.88, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 434.16, ["Mega|Fly|Ride"] = 451.92}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Fly"] = 62.78, ["Ride"] = 105, ["Neon"] = 2.63, ["Neon|Ride"] = 83.7, ["Mega"] = 17.73, ["Mega|Ride"] = 59.07}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 49.18, ["Fly"] = 65.91, ["Ride"] = 51.19, ["Fly|Ride"] = 91.88, ["Neon"] = 578.82, ["Neon|Fly"] = 310.21, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 277.09, ["Mega"] = 3347.55, ["Mega|Fly|Ride"] = 1036.71}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 3.29, ["Fly"] = 87.68, ["Ride"] = 27.22, ["Fly|Ride"] = 127.32, ["Mega"] = 773.07}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 25.1, ["Ride"] = 18.38, ["Fly|Ride"] = 70.1, ["Neon"] = 39.38, ["Mega"] = 1033.57, ["Mega|Ride"] = 275.1, ["Mega|Fly|Ride"] = 202.13}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 6.57, ["Neon"] = 35.58, ["Mega"] = 229.69, ["Mega|Ride"] = 196.88}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 22.41, ["Fly"] = 262.5, ["Ride"] = 39.38, ["Fly|Ride"] = 196.88, ["Neon"] = 104.62, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 209.24, ["Mega"] = 1116.21, ["Mega|Ride"] = 1046.12, ["Mega|Fly|Ride"] = 768.79}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 8.95, ["Neon"] = 22.32, ["Neon|Ride"] = 78.75, ["Mega"] = 91.34, ["Mega|Fly|Ride"] = 307.75}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 27.2, ["Neon"] = 2.1, ["Neon|Ride"] = 112.98, ["Mega"] = 18.32, ["Mega|Ride"] = 51.19, ["Mega|Fly|Ride"] = 200.17}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Ride"] = 26.13, ["Neon"] = 2.1, ["Neon|Fly"] = 393.65, ["Neon|Ride"] = 33.33, ["Mega"] = 15.7, ["Mega|Ride"] = 47.25, ["Mega|Fly|Ride"] = 119.44}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 31.49, ["Ride"] = 20.93, ["Fly|Ride"] = 59.07, ["Neon"] = 8.27, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 20.93, ["Neon|Fly|Ride"] = 140.19, ["Mega"] = 118.22, ["Mega|Ride"] = 131.82, ["Mega|Fly|Ride"] = 237.47}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 5187.39, ["Neon"] = 18.84, ["Mega"] = 140.19, ["Mega|Ride"] = 158.33}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.63, ["Fly"] = 39.58, ["Ride"] = 17.07, ["Fly|Ride"] = 35.58, ["Neon"] = 23.62, ["Neon|Ride"] = 41.86, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 492.85, ["Mega|Ride"] = 276.29, ["Mega|Fly|Ride"] = 363.57}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 62.85, ["Fly|Ride"] = 391.27, ["Neon"] = 237.47, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 321.17, ["Mega"] = 696.72, ["Mega|Fly"] = 836.91, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 754.22}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.05, ["Fly"] = 26.16, ["Ride"] = 17.07, ["Fly|Ride"] = 37.17, ["Neon"] = 3.92, ["Neon|Fly"] = 20.93, ["Neon|Ride"] = 23.07, ["Neon|Fly|Ride"] = 51.19, ["Mega"] = 35.44, ["Mega|Fly"] = 279.33, ["Mega|Ride"] = 56.51, ["Mega|Fly|Ride"] = 117.49}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 9.19, ["Fly"] = 62.27, ["Ride"] = 35.57, ["Fly|Ride"] = 65.63, ["Neon"] = 48.14, ["Neon|Fly"] = 54.2, ["Neon|Ride"] = 53.28, ["Neon|Fly|Ride"] = 187.9, ["Mega"] = 276.64, ["Mega|Ride"] = 307.75, ["Mega|Fly|Ride"] = 349.41}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 12.55, ["Fly"] = 52.5, ["Ride"] = 26.18, ["Fly|Ride"] = 83.7, ["Neon"] = 76.13, ["Neon|Ride"] = 76.1, ["Neon|Fly|Ride"] = 138.1, ["Mega"] = 1046.12, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 435.75}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 9.18, ["Fly"] = 140.38, ["Ride"] = 44.37, ["Neon"] = 17.07, ["Neon|Ride"] = 70.1, ["Mega"] = 150.94, ["Mega|Ride"] = 241.5}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 17.38, ["Neon"] = 3.82, ["Neon|Fly"] = 81.38, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 40.69, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 61.57, ["Mega|Fly|Ride"] = 159.29}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 3.68, ["Ride"] = 27.57, ["Neon"] = 14.3, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 209.24, ["Mega"] = 90.57, ["Mega|Fly"] = 735, ["Mega|Ride"] = 154.46, ["Mega|Fly|Ride"] = 371.38}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 918.75, ["Ride"] = 1050, ["Fly|Ride"] = 1181.25, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2278.48, ["Mega|Fly|Ride"] = 7434}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 72.19, ["Ride"] = 104.63, ["Neon"] = 196.88, ["Neon|Ride"] = 250.69, ["Mega"] = 2812.69, ["Mega|Ride"] = 1255.34, ["Mega|Fly|Ride"] = 1172.07}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Fly"] = 62.78, ["Ride"] = 70.1, ["Neon"] = 9.23, ["Neon|Ride"] = 74.28, ["Neon|Fly|Ride"] = 315, ["Mega"] = 61.93, ["Mega|Ride"] = 393.75}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 31.48, ["Ride"] = 52.32, ["Fly|Ride"] = 262.5, ["Neon"] = 206.14, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 300.57, ["Mega"] = 2030.85, ["Mega|Ride"] = 746.82, ["Mega|Fly|Ride"] = 950.25}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 6.02, ["Ride"] = 72.65, ["Neon"] = 46.81, ["Neon|Ride"] = 131.25, ["Mega"] = 376.69, ["Mega|Ride"] = 138.33, ["Mega|Fly|Ride"] = 1046.12}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 418.46, ["Fly"] = 922.32, ["Ride"] = 345.38, ["Fly|Ride"] = 487.5, ["Neon|Ride"] = 1255.34, ["Neon|Fly|Ride"] = 1068.38, ["Mega|Fly|Ride"] = 4462.5}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 102.38, ["Ride"] = 22.32, ["Fly|Ride"] = 129.93, ["Neon"] = 14.44, ["Mega"] = 393.75, ["Mega|Fly"] = 279.33}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Ride"] = 24.07, ["Neon"] = 104.98, ["Neon|Ride"] = 140.19}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 20.93, ["Fly"] = 70.1, ["Ride"] = 103.69, ["Fly|Ride"] = 209.24, ["Neon"] = 161.18, ["Neon|Ride"] = 307.8, ["Mega"] = 614.09, ["Mega|Ride"] = 981.1, ["Mega|Fly|Ride"] = 732.29}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.61, ["Ride"] = 70.86, ["Fly|Ride"] = 140.19, ["Neon"] = 15.7, ["Mega"] = 202.96, ["Mega|Ride"] = 233.29, ["Mega|Fly|Ride"] = 418.46}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 23.63, ["Ride"] = 15.7, ["Fly|Ride"] = 32.82, ["Neon"] = 3.81, ["Neon|Fly"] = 31.14, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 43.32, ["Mega"] = 48.14, ["Mega|Ride"] = 40.69, ["Mega|Fly|Ride"] = 99.65}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 5320.56, ["Ride"] = 4198.69, ["Fly|Ride"] = 4198.69, ["Neon"] = 25106.49, ["Neon|Fly|Ride"] = 19163.82, ["Mega|Fly|Ride"] = 78247.49}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 12.32, ["Ride"] = 56.44, ["Neon"] = 53.82, ["Neon|Ride"] = 44.63, ["Mega"] = 262.5, ["Mega|Ride"] = 387.08, ["Mega|Fly|Ride"] = 451.5}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Ride"] = 28.26, ["Fly|Ride"] = 54.35, ["Neon"] = 15.74, ["Neon|Fly"] = 111.84, ["Neon|Ride"] = 33.45, ["Neon|Fly|Ride"] = 138.1, ["Mega"] = 282.47, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 208.04}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 418.46, ["Fly"] = 488.54, ["Ride"] = 417.38, ["Fly|Ride"] = 518.88, ["Neon"] = 1673.79, ["Neon|Ride"] = 1253.25, ["Neon|Fly|Ride"] = 1219.47, ["Mega|Fly|Ride"] = 5471.29}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 2.1, ["Ride"] = 70.1, ["Neon"] = 17.52, ["Neon|Ride"] = 70.1, ["Mega"] = 144.38, ["Mega|Fly|Ride"] = 684.16}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 3.82, ["Fly"] = 94.77, ["Ride"] = 77.26, ["Neon"] = 59.07, ["Neon|Ride"] = 279.33, ["Neon|Fly|Ride"] = 13948.76, ["Mega"] = 279.33, ["Mega|Ride"] = 401.63}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.63, ["Fly"] = 52.5, ["Ride"] = 19.69, ["Fly|Ride"] = 32.82, ["Neon"] = 6.92, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 101.07, ["Mega"] = 138.1, ["Mega|Ride"] = 77.05, ["Mega|Fly|Ride"] = 214.03}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 558.64, ["Ride"] = 656.25, ["Fly|Ride"] = 721.88, ["Neon|Ride"] = 2092.22, ["Neon|Fly|Ride"] = 2066.07, ["Mega|Fly|Ride"] = 8751.75}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 5.25, ["Ride"] = 59.07, ["Neon"] = 25.03, ["Neon|Fly"] = 98.35, ["Neon|Ride"] = 77.42, ["Neon|Fly|Ride"] = 238.52, ["Mega"] = 114.59, ["Mega|Ride"] = 237.18, ["Mega|Fly|Ride"] = 307.75}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 6.54, ["Fly"] = 236.25, ["Ride"] = 52.5, ["Fly|Ride"] = 175.76, ["Neon"] = 40.69, ["Neon|Ride"] = 78.23, ["Neon|Fly|Ride"] = 126, ["Mega"] = 251.51, ["Mega|Ride"] = 246.75, ["Mega|Fly|Ride"] = 333.38}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 35.57, ["Ride"] = 23.07, ["Fly|Ride"] = 42, ["Neon"] = 13, ["Neon|Ride"] = 31.4, ["Neon|Fly|Ride"] = 89.25, ["Mega"] = 144.38, ["Mega|Ride"] = 219.71, ["Mega|Fly|Ride"] = 154.88}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 24.94, ["Ride"] = 62.27, ["Fly|Ride"] = 115.29, ["Neon"] = 33.45, ["Mega"] = 542.94, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 614.09}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Neon"] = 5.23, ["Neon|Fly|Ride"] = 2017.01, ["Mega"] = 58.59, ["Mega|Ride"] = 85.31, ["Mega|Fly|Ride"] = 169.32}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 511.88, ["Ride"] = 538.76, ["Fly|Ride"] = 682.5, ["Neon"] = 2066.07, ["Neon|Ride"] = 1961.46, ["Neon|Fly|Ride"] = 1880.91, ["Mega|Ride"] = 8990.1, ["Mega|Fly|Ride"] = 7848.75}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 40.62, ["Neon"] = 15.7, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 108.35, ["Mega"] = 39.77, ["Mega|Ride"] = 133.88, ["Mega|Fly|Ride"] = 345.23}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 3.94, ["Neon|Ride"] = 170.62, ["Mega"] = 35.58, ["Mega|Ride"] = 75.33, ["Mega|Fly|Ride"] = 262.59}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Neon"] = 4.61, ["Neon|Ride"] = 45.92, ["Mega"] = 32.13, ["Mega|Fly"] = 154.84, ["Mega|Ride"] = 79.65, ["Mega|Fly|Ride"] = 167.4}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 3.92, ["Ride"] = 68.25, ["Neon"] = 15.7}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 40.63, ["Ride"] = 70.1, ["Fly|Ride"] = 156.19, ["Neon"] = 117.24, ["Neon|Ride"] = 223.88, ["Neon|Fly|Ride"] = 342.09, ["Mega"] = 669.38, ["Mega|Ride"] = 624.86, ["Mega|Fly|Ride"] = 654.94}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 20.78, ["Ride"] = 279.33, ["Fly|Ride"] = 276.94, ["Neon"] = 108.81, ["Neon|Ride"] = 188.32, ["Mega"] = 365.13, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 488.24}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.61, ["Fly"] = 26.25, ["Ride"] = 14.44, ["Fly|Ride"] = 54.89, ["Neon"] = 31.4, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 92.23, ["Mega"] = 299.92, ["Mega|Ride"] = 219.71, ["Mega|Fly|Ride"] = 238.88}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 26.25, ["Ride"] = 39.38, ["Neon"] = 279.33, ["Neon|Ride"] = 158.82, ["Mega"] = 349.41, ["Mega|Fly|Ride"] = 514.69}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Fly"] = 31.4, ["Ride"] = 28.25, ["Fly|Ride"] = 362.25, ["Neon"] = 11.54, ["Neon|Ride"] = 78.47, ["Mega"] = 102.54, ["Mega|Ride"] = 138.33, ["Mega|Fly|Ride"] = 209.24}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 17.28, ["Ride"] = 27.57, ["Fly|Ride"] = 83.7, ["Neon"] = 248.98, ["Neon|Ride"] = 83.7, ["Neon|Fly|Ride"] = 205.06, ["Mega"] = 940.46, ["Mega|Ride"] = 922.08, ["Mega|Fly|Ride"] = 695.63}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 70.22, ["Fly"] = 874.13, ["Neon"] = 307.8, ["Neon|Fly"] = 262.5}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 53.82, ["Fly"] = 115.5, ["Ride"] = 77.41, ["Fly|Ride"] = 157.5, ["Neon"] = 290.07, ["Neon|Ride"] = 299.25, ["Neon|Fly|Ride"] = 355.69, ["Mega|Ride"] = 1629.76, ["Mega|Fly|Ride"] = 1809.77}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 136.5, ["Fly"] = 126.1, ["Ride"] = 104.19, ["Neon"] = 189.29, ["Neon|Ride"] = 244.39, ["Neon|Fly|Ride"] = 313.85, ["Mega"] = 630, ["Mega|Ride"] = 723.19, ["Mega|Fly|Ride"] = 738.94}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 22.98, ["Ride"] = 77.42, ["Neon"] = 418.46, ["Neon|Ride"] = 167.4, ["Mega"] = 1050, ["Mega|Ride"] = 760.53, ["Mega|Fly|Ride"] = 1254.29}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 6.54, ["Ride"] = 23.63, ["Fly|Ride"] = 52.5, ["Neon"] = 42.39, ["Neon|Fly"] = 167.4, ["Neon|Ride"] = 94.5, ["Neon|Fly|Ride"] = 224.44, ["Mega"] = 493.78, ["Mega|Ride"] = 345.19, ["Mega|Fly|Ride"] = 355.69}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 28.26, ["Ride"] = 17.07, ["Fly|Ride"] = 41.68, ["Neon"] = 2.63, ["Neon|Ride"] = 41.51, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 40.69, ["Mega|Ride"] = 85.79, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1150.73}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 26.25, ["Ride"] = 83.83, ["Fly|Ride"] = 262.5, ["Neon"] = 92.24, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 344.63, ["Mega"] = 558.64, ["Mega|Ride"] = 518.44, ["Mega|Fly|Ride"] = 495.48}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 56.51, ["Neon"] = 3.21, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 292.92, ["Mega"] = 23.07, ["Mega|Fly|Ride"] = 140.19}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 26.19, ["Ride"] = 83.7, ["Neon"] = 111.57, ["Neon|Ride"] = 349.41, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 697.76, ["Mega|Ride"] = 802.38, ["Mega|Fly|Ride"] = 590.62}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Mega"] = 22.76}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 86.46, ["Mega"] = 24.92, ["Mega|Ride"] = 83.7, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 131.25, ["Ride"] = 183.74, ["Neon"] = 584.47, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 625.59, ["Mega|Ride"] = 6339.18, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 3.93, ["Fly"] = 65.63, ["Ride"] = 23.63, ["Fly|Ride"] = 87.89, ["Neon"] = 11.42, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 140.19, ["Mega"] = 107.61, ["Mega|Ride"] = 154.46, ["Mega|Fly|Ride"] = 446.06}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 36.63, ["Fly|Ride"] = 86.63, ["Neon"] = 6.12, ["Neon|Ride"] = 56.51, ["Neon|Fly|Ride"] = 419.99, ["Mega"] = 47.93, ["Mega|Ride"] = 103.22}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 83.7, ["Neon"] = 5.13, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 35.44, ["Mega"] = 33.49, ["Mega|Ride"] = 74.82, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 91.88, ["Neon"] = 3.93, ["Neon|Ride"] = 45.94, ["Mega"] = 39.77, ["Mega|Ride"] = 94.5, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 24.98, ["Ride"] = 86.63, ["Fly|Ride"] = 615.58, ["Neon"] = 279.33, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1116.21, ["Mega|Ride"] = 1044.03, ["Mega|Fly|Ride"] = 1241.75}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 3.13, ["Ride"] = 129.31, ["Neon"] = 21, ["Neon|Ride"] = 111.57, ["Mega"] = 140.6, ["Mega|Ride"] = 534.85, ["Mega|Fly|Ride"] = 414.27}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.05}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.05}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 328.13, ["Ride"] = 482.35, ["Fly|Ride"] = 604.67, ["Neon"] = 2929.11, ["Neon|Ride"] = 1157.38, ["Neon|Fly|Ride"] = 1046.12, ["Mega|Fly|Ride"] = 3150}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.05}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 72.07}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 38.07}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 15.73}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 23.61}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 43.32}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 53.82}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 12.32}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 6.57}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 216.57}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 22.3}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 39.38}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 19.69}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 6.55}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 918.75}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.05}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 6.12}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 6.97}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 6.24}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 6.56}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 19.19}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 465.94}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 697.76}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 11.51}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1064.44}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 250.69}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 11.82}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 3.96}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 14.3}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 49.59}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 73.24}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 32.81}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 15.74}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 6.57}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 18.87}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 7.85}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 210}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.6}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 27.57}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 27.21}},
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
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 292.11}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 3.92}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 10.43}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 7.08}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 144.32}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 10.47}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 14.44}},
    ["rbxassetid://1265129435"] = {name = "Gold Snowboard", prices = {["default"] = 210}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 65.63}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 13.1}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 3.92}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 13.12}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 7.07}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 3.42}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 154.5}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 13.13}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 6.3}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.63}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.05}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 19.63}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.35}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 10.98}},
    ["rbxassetid://1265129203"] = {name = "Ice Snowboard", prices = {["default"] = 196.88}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 2.63}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 19.69}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 187.52}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 98.37}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 6.57}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 7.87}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 16.32}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 27.57}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 72.19}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 39.25}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 21904.81}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 177.19}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 27.57}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 26.24}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 30.64}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 64.87}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 25.75}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 31.49}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 74.12}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 119.44}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 190.32}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 34.13}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 26.24}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 39.37}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 40.66}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 196.88}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 7.87}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 10.48}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 6.23}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 28.84}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 44.63}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.1}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 2.62}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.42}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 5.25}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 5.24}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 741.57}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 6.55}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 651}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 15.69}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.1}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 262.5}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 28.88}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 70.1}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 41.86}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 32.81}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 132.57}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 28.88}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 2.61}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 14.44}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.61}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 6.28}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 3.94}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 40.95}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 5.39}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 3.68}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 3.93}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 12.73}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 187.94}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 38.06}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.63}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.63}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 4.61}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 131.25}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 10.5}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 9.4}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 5.6}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 13.09}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 118.13}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 5.25}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 13.13}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 14.42}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 135.19}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 45.42}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 10.48}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 5.23}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.63}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 8.39}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 14.42}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 3.94}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 6.28}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 23.67}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.37}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 15.75}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.24}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 4.41}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 3.93}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 7427.34}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 18.38}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 11.82}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 5.13}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 26.93}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 5.2}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 5.49}},
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
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 11.5}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 4.59}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.6}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 5.9}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 3.7}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 3.45}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4306.04}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 4.65}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.61}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 44.6}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.63}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.42}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.63}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 3.92}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 81.38}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 4.65}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 182.28}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.61}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.05}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.63}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 3.94}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 4.11}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.63}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 2.1}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 14.17}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 26.25}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 6.57}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.45}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 11.81}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 5.7}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 3.93}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 5.24}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.63}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.61}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 5.24}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 3.71}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
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
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 34.13}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 4.81}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1190.48}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 19.93}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 2.6}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.05}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 28.85}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 3.93}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 49.59}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 10.31}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 15.62}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 45.94}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 18.34}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 4.99}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 3.71}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 14.55}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 4.19}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 12.77}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 4.66}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 31.14}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 18.2}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 11.78}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.05}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 420}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.63}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 230.73}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 4.73}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 26.17}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 23.55}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 3.94}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 104.92}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 3.44}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 12.9}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 15.73}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 3.94}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 3.93}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 5.09}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 5.81}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 14.36}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 86.63}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.24}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 96.11}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 5.25}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1380.87}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.63}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 213.7}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 10.48}},
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
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 3.94}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 6.93}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 65.61}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 7.87}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 2.41}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 3.36}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.61}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 3.71}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 11.52}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 3.68}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 70.1}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 3.94}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 54.74}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 6.55}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.63}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 4.2}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 27.41}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 111.71}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.63}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.56}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 59.62}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 5.25}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.05}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 3.94}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.05}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 5.25}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 64.23}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 41.73}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 86.63}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 445.65}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 47.2}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.63}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 104.15}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 2.97}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.63}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 17.07}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 73.5}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 2.63}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 15.7}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 3.91}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 9.17}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 23.68}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.63}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 19.69}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 3.94}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 3.93}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 5.25}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 53.37}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 59.07}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 6.57}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 28.82}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 4.98}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 3.94}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 39.37}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 68.25}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 39.35}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1395.52}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 17.78}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 8.67}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 39.37}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 249.25}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 23.08}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 6.57}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.05}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 11.8}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 10.39}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 2.61}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 192.94}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 39.38}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 5.55}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 6.28}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 60.38}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 118.13}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 90.56}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 945}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 199.5}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 9.17}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 1036.88}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 518.44}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 4.2}},
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