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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 694.32, ["Fly"] = 1111.29, ["Ride"] = 735, ["Fly|Ride"] = 806.13, ["Neon"] = 6461.14, ["Neon|Ride"] = 4444.08, ["Neon|Fly|Ride"] = 3406.34}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 477.75, ["Fly"] = 500.75, ["Ride"] = 500.75, ["Fly|Ride"] = 461.53, ["Neon|Fly|Ride"] = 2361.19, ["Mega|Fly|Ride"] = 8323.46}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 5538.11, ["Ride"] = 4790.63, ["Fly|Ride"] = 4986.18, ["Neon"] = 25690.59, ["Neon|Fly|Ride"] = 19653.92, ["Mega|Fly|Ride"] = 62558.85}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 124.69, ["Ride"] = 156.19, ["Fly|Ride"] = 262.5, ["Neon"] = 733.69, ["Neon|Ride"] = 820.32, ["Neon|Fly|Ride"] = 933.19, ["Mega"] = 3477.25, ["Mega|Fly|Ride"] = 3080.53}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 523.69, ["Ride"] = 577.5, ["Fly|Ride"] = 590.62, ["Neon|Fly|Ride"] = 1443.75, ["Mega|Fly|Ride"] = 7391.94}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 11.47, ["Ride"] = 46.17, ["Fly|Ride"] = 118.74, ["Neon"] = 32.82, ["Neon|Ride"] = 103.11, ["Neon|Fly|Ride"] = 300.32, ["Mega"] = 262.5, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 409.5}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 3.93, ["Fly"] = 33.34, ["Ride"] = 25.98, ["Fly|Ride"] = 28.88, ["Neon"] = 19.69, ["Neon|Fly"] = 64.32, ["Neon|Ride"] = 45.44, ["Neon|Fly|Ride"] = 91.76, ["Mega"] = 132.29, ["Mega|Fly"] = 303.19, ["Mega|Ride"] = 195.14, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 108.49, ["Ride"] = 290.07, ["Fly|Ride"] = 249.98, ["Neon"] = 458.07, ["Neon|Fly"] = 459.38, ["Neon|Ride"] = 719.7, ["Neon|Fly|Ride"] = 623.52, ["Mega"] = 1847.99, ["Mega|Ride"] = 1876.77, ["Mega|Fly|Ride"] = 1848.09}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 27.56, ["Fly"] = 65.63, ["Ride"] = 31.5, ["Fly|Ride"] = 117.71, ["Neon"] = 301.88, ["Neon|Ride"] = 203.11, ["Neon|Fly|Ride"] = 210, ["Mega"] = 2100, ["Mega|Ride"] = 758.02, ["Mega|Fly|Ride"] = 723.61}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 28.88, ["Fly"] = 57.75, ["Ride"] = 28.88, ["Fly|Ride"] = 82.87, ["Neon"] = 278.1, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 187.69, ["Mega|Ride"] = 687.12, ["Mega|Fly|Ride"] = 880.53}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 53.09, ["Ride"] = 59.07, ["Fly|Ride"] = 151.16, ["Neon|Ride"] = 208.31, ["Neon|Fly|Ride"] = 249.38, ["Mega|Ride"] = 1062.48, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 68.25}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 379.32, ["Ride"] = 384.4, ["Fly|Ride"] = 444.94, ["Neon"] = 1283.63, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1385.94, ["Mega|Fly|Ride"] = 3894.31}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 115.62, ["Fly"] = 118.78, ["Ride"] = 123.38, ["Fly|Ride"] = 157.5, ["Neon|Fly|Ride"] = 556.79, ["Mega|Fly|Ride"] = 2500.29}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.63, ["Fly"] = 31.26, ["Ride"] = 23.09, ["Fly|Ride"] = 90.62, ["Neon"] = 15.63, ["Neon|Fly"] = 61.46, ["Neon|Ride"] = 69.79, ["Mega"] = 114.19, ["Mega|Ride"] = 189, ["Mega|Fly|Ride"] = 382.34}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 140.44, ["Fly"] = 140.65, ["Ride"] = 124.69, ["Fly|Ride"] = 178.5, ["Neon"] = 473.89, ["Neon|Ride"] = 625.61, ["Neon|Fly|Ride"] = 543.37, ["Mega|Fly|Ride"] = 1967.44}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 2.63, ["Fly"] = 31.26, ["Ride"] = 21.3, ["Fly|Ride"] = 45.94, ["Neon"] = 22.93, ["Neon|Fly"] = 104.16, ["Neon|Ride"] = 62.51, ["Neon|Fly|Ride"] = 91.87, ["Mega"] = 787.5, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 41.64, ["Ride"] = 84, ["Fly|Ride"] = 143.73, ["Neon"] = 154.88, ["Neon|Ride"] = 181.23, ["Neon|Fly|Ride"] = 207.51, ["Mega"] = 640.2, ["Mega|Ride"] = 667.31, ["Mega|Fly|Ride"] = 767.82}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 51.08}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 39.38, ["Ride"] = 170.63, ["Neon"] = 291.63, ["Neon|Ride"] = 346.15, ["Mega"] = 2919.44, ["Mega|Fly|Ride"] = 3080.53}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 11.47, ["Fly"] = 66.32, ["Ride"] = 28.88, ["Fly|Ride"] = 139.57, ["Neon"] = 123.46, ["Neon|Ride"] = 261.92, ["Neon|Fly|Ride"] = 258.37, ["Mega"] = 2656.48, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 1668.26}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 38.04, ["Fly"] = 62.51, ["Ride"] = 48.57, ["Fly|Ride"] = 118.13, ["Neon"] = 383.29, ["Neon|Ride"] = 200.76, ["Neon|Fly|Ride"] = 222.94, ["Mega"] = 1681.32, ["Mega|Fly|Ride"] = 893.79}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 52.49, ["Ride"] = 155.76, ["Fly|Ride"] = 196.88, ["Neon"] = 196.87, ["Neon|Ride"] = 416.61, ["Neon|Fly|Ride"] = 406.23, ["Mega"] = 1101.38, ["Mega|Ride"] = 1247.02, ["Mega|Fly|Ride"] = 1233.47}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 23.6, ["Ride"] = 50.34, ["Fly|Ride"] = 137.16, ["Neon"] = 137.49, ["Neon|Ride"] = 215.78, ["Neon|Fly|Ride"] = 408.19, ["Mega"] = 695.46, ["Mega|Ride"] = 2040.94, ["Mega|Fly|Ride"] = 953}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 46.17, ["Ride"] = 95.45, ["Fly|Ride"] = 131.25, ["Neon"] = 249.98, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 295.09, ["Mega|Ride"] = 2493.75, ["Mega|Fly|Ride"] = 933.19}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 5.24, ["Fly"] = 30.18, ["Ride"] = 22.32, ["Fly|Ride"] = 39.38, ["Neon"] = 26.25, ["Neon|Fly"] = 55.13, ["Neon|Ride"] = 48.57, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 105, ["Mega|Fly"] = 27838.7, ["Mega|Ride"] = 170.62, ["Mega|Fly|Ride"] = 278.4}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 280.08, ["Fly"] = 364.54, ["Ride"] = 304.5, ["Fly|Ride"] = 282.19, ["Neon"] = 1458.12, ["Neon|Ride"] = 2916.21, ["Neon|Fly|Ride"] = 1416.19, ["Mega"] = 10426.48, ["Mega|Fly|Ride"] = 5390.62}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 15.75, ["Ride"] = 33.35, ["Fly|Ride"] = 135.4, ["Neon"] = 236.43, ["Neon|Ride"] = 208.31, ["Neon|Fly|Ride"] = 556.79, ["Mega"] = 820.58, ["Mega|Fly|Ride"] = 783.05}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 3.93, ["Fly"] = 37.94, ["Ride"] = 22.32, ["Fly|Ride"] = 54.24, ["Neon"] = 56.25, ["Neon|Ride"] = 69.79, ["Neon|Fly|Ride"] = 105, ["Mega"] = 380.63, ["Mega|Ride"] = 556.79, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 97.13, ["Fly"] = 136.18, ["Ride"] = 115.4, ["Fly|Ride"] = 166.64, ["Neon"] = 357, ["Neon|Fly"] = 416.61, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 462.02, ["Mega"] = 6120.3, ["Mega|Ride"] = 3080.37, ["Mega|Fly|Ride"] = 1491}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 12.52, ["Ride"] = 33.34, ["Fly|Ride"] = 118.13, ["Neon"] = 154.62, ["Neon|Ride"] = 104.16, ["Neon|Fly|Ride"] = 207.38, ["Mega"] = 692.33, ["Mega|Fly|Ride"] = 521.34}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 230.77, ["Fly"] = 354.22, ["Ride"] = 196.88, ["Fly|Ride"] = 216.57, ["Neon"] = 692.28, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 837.38, ["Mega"] = 6255.89, ["Mega|Fly|Ride"] = 2552.41}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 28.87}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 2.1, ["Fly"] = 31.4, ["Ride"] = 22.32, ["Fly|Ride"] = 61.46, ["Neon"] = 19.67, ["Neon|Fly"] = 5207.49, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 83.35, ["Mega"] = 118.13, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 271.1}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 577.5, ["Ride"] = 729.75, ["Fly|Ride"] = 757.37, ["Neon"] = 3055.76, ["Neon|Ride"] = 3610.88, ["Neon|Fly|Ride"] = 2966.25, ["Mega"] = 11817.38, ["Mega|Ride"] = 51974.43, ["Mega|Fly|Ride"] = 9732.09}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 8.28, ["Ride"] = 28.88, ["Fly|Ride"] = 90.62, ["Neon"] = 62.51, ["Neon|Ride"] = 102.1, ["Neon|Fly|Ride"] = 173.1, ["Mega"] = 526.32, ["Mega|Ride"] = 602.66, ["Mega|Fly|Ride"] = 657.92}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 131.24, ["Ride"] = 147, ["Fly|Ride"] = 207.38, ["Neon"] = 591.59, ["Neon|Ride"] = 514.5, ["Neon|Fly|Ride"] = 688.16, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 2502.38}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 62.32}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 24.94, ["Ride"] = 73.96, ["Fly|Ride"] = 196.88, ["Neon"] = 166.66, ["Neon|Ride"] = 208.31, ["Neon|Fly|Ride"] = 286.46, ["Mega"] = 692.33, ["Mega|Ride"] = 616.77, ["Mega|Fly|Ride"] = 724.23}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.24}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 162.49, ["Ride"] = 154.62, ["Neon"] = 556.17, ["Neon|Fly|Ride"] = 656.25, ["Mega|Fly|Ride"] = 2016.5}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 137.82, ["Ride"] = 156.19, ["Fly|Ride"] = 258.57, ["Neon"] = 515.55, ["Neon|Ride"] = 409.5, ["Neon|Fly|Ride"] = 483, ["Mega|Ride"] = 1760, ["Mega|Fly|Ride"] = 1468.69}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 47.24}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 40.68, ["Fly"] = 93.49, ["Ride"] = 69.25, ["Fly|Ride"] = 65.63, ["Neon|Ride"] = 344.75, ["Neon|Fly|Ride"] = 357, ["Mega"] = 4170.6, ["Mega|Fly|Ride"] = 1258.41}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 7.74, ["Ride"] = 52.5, ["Fly|Ride"] = 131.25, ["Neon"] = 39.38, ["Neon|Ride"] = 154.16, ["Neon|Fly|Ride"] = 235.66, ["Mega"] = 184.82, ["Mega|Fly"] = 267.75, ["Mega|Fly|Ride"] = 340.67}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 303.19, ["Fly"] = 389.53, ["Ride"] = 334.68, ["Fly|Ride"] = 353.07, ["Neon|Ride"] = 1945.53, ["Neon|Fly|Ride"] = 1308.57, ["Mega|Fly|Ride"] = 4774.97}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 62.34, ["Fly"] = 99.75, ["Ride"] = 85.32, ["Fly|Ride"] = 153.57, ["Neon"] = 315, ["Neon|Fly"] = 312.46, ["Neon|Ride"] = 310.72, ["Neon|Fly|Ride"] = 410.82, ["Mega|Fly|Ride"] = 1562.95}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3569.23, ["Ride"] = 3018.75, ["Fly|Ride"] = 3416.13, ["Neon|Fly|Ride"] = 13900.6}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 37.41, ["Fly"] = 222.89, ["Ride"] = 50.91, ["Fly|Ride"] = 84, ["Neon"] = 369.23, ["Neon|Ride"] = 276.94, ["Neon|Fly|Ride"] = 276.94, ["Mega"] = 1876.77, ["Mega|Ride"] = 1876.77, ["Mega|Fly|Ride"] = 1321.05}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 56.44, ["Ride"] = 108.33, ["Fly|Ride"] = 154.16, ["Neon"] = 393.75, ["Neon|Ride"] = 781.72, ["Neon|Fly|Ride"] = 556.79, ["Mega"] = 6255.89, ["Mega|Ride"] = 1847.99, ["Mega|Fly|Ride"] = 1487.88}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 36.75, ["Fly"] = 74.82, ["Ride"] = 55.13, ["Fly|Ride"] = 124.68, ["Neon"] = 184.98, ["Neon|Ride"] = 106.24, ["Neon|Fly|Ride"] = 198.18, ["Mega"] = 2598.75, ["Mega|Fly|Ride"] = 616.87}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 9.17}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 65.63, ["Ride"] = 78.75, ["Fly|Ride"] = 105, ["Neon"] = 433.28, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 495.28, ["Mega|Fly|Ride"] = 1694.47}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 39.38}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 183.75, ["Ride"] = 262.5, ["Fly|Ride"] = 367.5, ["Neon|Ride"] = 833.21, ["Neon|Fly|Ride"] = 1390.91}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 656.25, ["Ride"] = 590.63, ["Fly|Ride"] = 654.93, ["Neon|Fly|Ride"] = 2198.44, ["Mega|Fly|Ride"] = 11812.5}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 3.93}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 22.3, ["Fly"] = 52.5, ["Ride"] = 35.44, ["Fly|Ride"] = 58.7, ["Neon"] = 264.56, ["Neon|Fly"] = 308.06, ["Neon|Ride"] = 196.86, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 667.31, ["Mega|Fly|Ride"] = 721.52}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 7.86}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5118.75, ["Fly"] = 4725, ["Fly|Ride"] = 4461.19, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 40037.67}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 8.6, ["Ride"] = 24.93, ["Fly|Ride"] = 51.19, ["Neon"] = 56.25, ["Neon|Ride"] = 108.94, ["Neon|Fly|Ride"] = 139.73, ["Mega"] = 385.79, ["Mega|Ride"] = 374.07, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 13.5, ["Fly"] = 78.12, ["Ride"] = 39.38, ["Fly|Ride"] = 114.23, ["Neon"] = 139.57, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 695.46, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 86.63, ["Ride"] = 75.01, ["Fly|Ride"] = 125}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 10.49, ["Ride"] = 38.06, ["Fly|Ride"] = 139.65, ["Neon"] = 60.01, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 139.73, ["Mega"] = 358.68, ["Mega|Ride"] = 550.53, ["Mega|Fly|Ride"] = 1019.82}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 3124.5, ["Fly"] = 2310, ["Ride"] = 2761.02, ["Fly|Ride"] = 2231.25, ["Neon|Fly|Ride"] = 4114.69, ["Mega|Fly|Ride"] = 11892.57}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 32218.67, ["Ride"] = 24207.75, ["Fly|Ride"] = 23625, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 65339.59, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 194627.86}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 27.46, ["Fly"] = 393.75, ["Ride"] = 81.25, ["Fly|Ride"] = 85.39, ["Neon"] = 236.25, ["Neon|Ride"] = 178.38, ["Neon|Fly|Ride"] = 278.4, ["Mega"] = 1112.51, ["Mega|Ride"] = 729.87, ["Mega|Fly|Ride"] = 695.1}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 2.1, ["Ride"] = 28.13, ["Fly|Ride"] = 105, ["Neon"] = 14.44, ["Neon|Fly"] = 129.34, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 105, ["Mega"] = 92.75, ["Mega|Ride"] = 252.2, ["Mega|Fly|Ride"] = 245.44}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 23.63}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 4.87, ["Ride"] = 34.13, ["Fly|Ride"] = 278.1, ["Neon"] = 33.64, ["Neon|Ride"] = 124.38, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 240.87, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 400.39}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 708.75, ["Ride"] = 866.5, ["Fly|Ride"] = 774.38, ["Neon"] = 2923.67, ["Neon|Fly|Ride"] = 2777.63, ["Mega"] = 11121.93, ["Mega|Fly|Ride"] = 10738.24}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 912.19, ["Fly"] = 1076.25, ["Ride"] = 945, ["Fly|Ride"] = 1153.69, ["Neon|Fly|Ride"] = 3816.1, ["Mega|Fly|Ride"] = 15291.48}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 20.85, ["Fly"] = 56.25, ["Ride"] = 58.85, ["Fly|Ride"] = 125, ["Neon"] = 200.76, ["Neon|Ride"] = 125, ["Neon|Fly|Ride"] = 208.55, ["Mega|Ride"] = 486.93, ["Mega|Fly|Ride"] = 692.33}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 26.25}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 55.13, ["Fly"] = 123.38, ["Ride"] = 78.73, ["Fly|Ride"] = 139.57, ["Neon|Ride"] = 416.61, ["Neon|Fly|Ride"] = 419.99, ["Mega|Fly|Ride"] = 1480.58}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 78.75, ["Ride"] = 118.13, ["Fly|Ride"] = 170.63, ["Neon"] = 450.19, ["Neon|Ride"] = 556.29, ["Neon|Fly|Ride"] = 15400.61, ["Mega"] = 2101.18, ["Mega|Fly|Ride"] = 1692.59}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 5.2, ["Fly"] = 43.32, ["Ride"] = 19.69, ["Fly|Ride"] = 59.38, ["Neon"] = 61.68, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 125.13, ["Mega"] = 556.79, ["Mega|Ride"] = 242.82, ["Mega|Fly|Ride"] = 416.03}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 81.25, ["Fly"] = 85.31, ["Ride"] = 90.57, ["Fly|Ride"] = 144.38, ["Neon"] = 525, ["Neon|Ride"] = 342.83, ["Neon|Fly|Ride"] = 295.37, ["Mega|Fly|Ride"] = 1189.12}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 3.68, ["Ride"] = 36.74, ["Fly|Ride"] = 69.91, ["Neon"] = 26.25, ["Neon|Fly"] = 264.56, ["Neon|Ride"] = 91.67, ["Neon|Fly|Ride"] = 556.79, ["Mega"] = 103.69, ["Mega|Fly"] = 1112.51, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 392.44}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 15.64, ["Fly"] = 65.63, ["Ride"] = 32.82, ["Fly|Ride"] = 104.16, ["Neon"] = 278.1, ["Neon|Ride"] = 112.88, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 1050, ["Mega|Fly|Ride"] = 624.57}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 32.61, ["Ride"] = 278.1, ["Fly|Ride"] = 270.8, ["Neon"] = 190.32, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 2085.32, ["Mega|Fly|Ride"] = 834.14}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 15.63, ["Fly"] = 81.41, ["Ride"] = 35.42, ["Fly|Ride"] = 82.69, ["Neon"] = 103.69, ["Neon|Ride"] = 170.78, ["Neon|Fly|Ride"] = 166.84, ["Mega"] = 625.61, ["Mega|Ride"] = 903.99, ["Mega|Fly|Ride"] = 924.05}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 7061.25, ["Fly"] = 5415.79, ["Ride"] = 5446.88, ["Fly|Ride"] = 4247.25, ["Neon"] = 30552.29, ["Neon|Fly|Ride"] = 25023.55, ["Mega|Fly|Ride"] = 99299.65}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 236.25, ["Fly"] = 278.25, ["Ride"] = 261.19, ["Fly|Ride"] = 288.63, ["Neon|Fly|Ride"] = 547.32, ["Mega|Fly|Ride"] = 2155.17}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 22.31, ["Fly"] = 89.58, ["Ride"] = 61.69, ["Fly|Ride"] = 104.16, ["Neon"] = 75.84, ["Neon|Fly"] = 241.5, ["Neon|Ride"] = 96.01, ["Neon|Fly|Ride"] = 197.3, ["Mega"] = 308.13, ["Mega|Fly"] = 520.3, ["Mega|Ride"] = 308.39, ["Mega|Fly|Ride"] = 458.07}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.63, ["Fly"] = 40.4, ["Ride"] = 30.01, ["Fly|Ride"] = 97.92, ["Neon"] = 26.22, ["Neon|Ride"] = 56.69, ["Mega"] = 140.44}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 33.49, ["Fly"] = 83.34, ["Ride"] = 45.94, ["Fly|Ride"] = 85.32, ["Neon"] = 137.49, ["Neon|Fly"] = 307.26, ["Neon|Ride"] = 190.32, ["Neon|Fly|Ride"] = 230.83, ["Mega"] = 421.24, ["Mega|Ride"] = 448.02, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 18571.88, ["Ride"] = 13125, ["Fly|Ride"] = 11665.5, ["Neon|Fly|Ride"] = 23625}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 137.49, ["Ride"] = 195.57, ["Fly|Ride"] = 393.75, ["Neon"] = 2083.01, ["Neon|Fly|Ride"] = 1084.37, ["Mega|Fly|Ride"] = 4620.19}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 42.84, ["Fly"] = 459.38, ["Ride"] = 49.6, ["Fly|Ride"] = 98.6, ["Neon|Fly"] = 461.53, ["Neon|Ride"] = 262.47, ["Neon|Fly|Ride"] = 288.75, ["Mega|Fly|Ride"] = 1154.23}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 6.56, ["Ride"] = 39.38, ["Neon"] = 65.14, ["Neon|Ride"] = 106.24, ["Neon|Fly|Ride"] = 201.86, ["Mega"] = 2502.38, ["Mega|Ride"] = 492.19, ["Mega|Fly|Ride"] = 1042.67}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 393.75, ["Fly"] = 833.21, ["Ride"] = 446.23, ["Fly|Ride"] = 483, ["Neon"] = 1640.63, ["Neon|Ride"] = 1299.38, ["Neon|Fly|Ride"] = 1350.57, ["Mega|Fly|Ride"] = 5542.72}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 5.23, ["Fly"] = 46.17, ["Ride"] = 42, ["Fly|Ride"] = 139.57, ["Neon"] = 19.69, ["Neon|Ride"] = 101.17, ["Neon|Fly|Ride"] = 139.73, ["Mega"] = 105, ["Mega|Ride"] = 178.5, ["Mega|Fly|Ride"] = 246.08}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 107.63, ["Fly"] = 170.63, ["Ride"] = 145.68, ["Fly|Ride"] = 169.32, ["Neon"] = 508.82, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 1785, ["Mega|Fly|Ride"] = 1901.81}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 17.26, ["Fly"] = 20.24, ["Ride"] = 22.32, ["Fly|Ride"] = 35.41, ["Neon|Ride"] = 104.16, ["Neon|Fly|Ride"] = 81.38, ["Mega"] = 2502.38, ["Mega|Fly|Ride"] = 567.23}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 9.19}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 64.32, ["Ride"] = 111.45, ["Fly|Ride"] = 525, ["Neon"] = 393.75, ["Neon|Fly"] = 1666.41, ["Neon|Ride"] = 375.37, ["Neon|Fly|Ride"] = 415.67, ["Mega|Ride"] = 1386, ["Mega|Fly|Ride"] = 1524.67}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 13.69, ["Ride"] = 39.38, ["Fly|Ride"] = 68.61, ["Neon"] = 83.34, ["Neon|Ride"] = 115.42, ["Neon|Fly|Ride"] = 131.25, ["Mega|Fly|Ride"] = 938.39}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 14.44}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 33.97, ["Fly"] = 210, ["Ride"] = 77.88, ["Fly|Ride"] = 93.75, ["Neon"] = 133.88, ["Neon|Ride"] = 79.72, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1529.57, ["Mega|Ride"] = 729.87, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 2.1, ["Ride"] = 31.16, ["Fly|Ride"] = 118.13, ["Neon"] = 19.04, ["Neon|Ride"] = 136.45, ["Neon|Fly|Ride"] = 321.57, ["Mega"] = 110.41, ["Mega|Ride"] = 333.66, ["Mega|Fly|Ride"] = 411.87}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 14.43, ["Fly"] = 56.25, ["Ride"] = 30.19, ["Fly|Ride"] = 91.87, ["Neon"] = 139.57, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 223.14, ["Mega|Ride"] = 616.77, ["Mega|Fly|Ride"] = 692.33}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 393.75, ["Fly"] = 437.75, ["Ride"] = 321.57, ["Fly|Ride"] = 382.99, ["Neon|Fly|Ride"] = 1668.26, ["Mega|Fly|Ride"] = 8619.58}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 43.3, ["Ride"] = 109.24, ["Fly|Ride"] = 136.5, ["Neon"] = 208.31, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 333.66, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 834.14}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 62.99, ["Ride"] = 78.7, ["Fly|Ride"] = 91.88, ["Neon"] = 190.32, ["Neon|Ride"] = 831.13, ["Neon|Fly|Ride"] = 630, ["Mega|Ride"] = 556.79, ["Mega|Fly|Ride"] = 612.06}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 17.77, ["Fly"] = 83.34, ["Ride"] = 53.08, ["Fly|Ride"] = 131.24, ["Neon"] = 93.18, ["Neon|Ride"] = 123.47, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 308.06, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 521.34}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 11076.21, ["Ride"] = 11076.21, ["Fly|Ride"] = 8137.5, ["Neon|Fly|Ride"] = 16891.88, ["Mega|Fly|Ride"] = 39372.9}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 2232.56, ["Ride"] = 1706.25, ["Fly|Ride"] = 1837.5, ["Neon"] = 4593.75, ["Neon|Fly|Ride"] = 5209.32, ["Mega|Fly|Ride"] = 16012.5}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 415.57, ["Ride"] = 308.06, ["Fly|Ride"] = 479.11, ["Neon"] = 2083.01, ["Neon|Ride"] = 1384.69, ["Neon|Fly|Ride"] = 1362.76, ["Mega"] = 16682.37, ["Mega|Fly|Ride"] = 6360.17}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 13.12, ["Fly"] = 35.42, ["Ride"] = 20.85, ["Fly|Ride"] = 51.19, ["Neon"] = 115.4, ["Neon|Ride"] = 83.34, ["Neon|Fly|Ride"] = 166.84, ["Mega|Fly|Ride"] = 500.06}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 4.6, ["Ride"] = 61.69, ["Fly|Ride"] = 153.57, ["Neon"] = 20.98, ["Neon|Ride"] = 56.25, ["Mega"] = 157.5, ["Mega|Ride"] = 278.4}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 30.19, ["Fly"] = 45.94, ["Ride"] = 48.57, ["Fly|Ride"] = 97.13, ["Neon"] = 154.62, ["Neon|Ride"] = 207.51, ["Neon|Fly|Ride"] = 172.78, ["Mega|Fly|Ride"] = 775.68}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 2.63, ["Fly"] = 23.09, ["Ride"] = 19.69, ["Fly|Ride"] = 39.35, ["Neon"] = 18.76, ["Neon|Fly"] = 69.79, ["Neon|Ride"] = 28.13, ["Neon|Fly|Ride"] = 87.94, ["Mega"] = 472.5, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 255.94}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 261.19, ["Fly"] = 315, ["Ride"] = 278.81, ["Fly|Ride"] = 469.72, ["Neon"] = 1145.66, ["Neon|Ride"] = 1341.45, ["Neon|Fly|Ride"] = 1261.32, ["Mega|Fly|Ride"] = 3730.6}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 26.25, ["Fly"] = 65.63, ["Ride"] = 44.8, ["Fly|Ride"] = 87.94, ["Neon"] = 277.06, ["Neon|Fly"] = 461.53, ["Neon|Ride"] = 208.31, ["Neon|Fly|Ride"] = 236.25, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 695.46}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 13.13, ["Fly"] = 19.9, ["Ride"] = 27.09, ["Fly|Ride"] = 45.85, ["Neon"] = 62.31, ["Neon|Fly"] = 136.5, ["Neon|Ride"] = 108.47, ["Neon|Fly|Ride"] = 116.82, ["Mega"] = 521.34, ["Mega|Ride"] = 574.51, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 328.13, ["Fly"] = 787.5, ["Ride"] = 525, ["Fly|Ride"] = 676.98, ["Mega|Fly|Ride"] = 8063.85}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1050, ["Ride"] = 1290.19, ["Fly|Ride"] = 1260, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 16942.22}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 84, ["Fly"] = 115.4, ["Ride"] = 78.75, ["Fly|Ride"] = 108.94, ["Neon|Ride"] = 414.75, ["Neon|Fly|Ride"] = 525, ["Mega|Fly|Ride"] = 1573.69}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 207.32, ["Fly"] = 246.92, ["Ride"] = 221.53, ["Fly|Ride"] = 245.44, ["Neon"] = 525, ["Neon|Fly"] = 694.7, ["Neon|Ride"] = 769.58, ["Neon|Fly|Ride"] = 652.31, ["Mega|Ride"] = 7290.94, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 27.71, ["Ride"] = 64.32, ["Neon"] = 272.89, ["Neon|Fly"] = 154.16, ["Neon|Ride"] = 278.1, ["Neon|Fly|Ride"] = 301.88, ["Mega|Ride"] = 924, ["Mega|Fly|Ride"] = 1033.78}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 143.07, ["Ride"] = 572.83, ["Fly|Ride"] = 597.19, ["Neon"] = 1527.88, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 1050, ["Mega"] = 2617.21, ["Mega|Fly|Ride"] = 2618.49}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 1771.88, ["Fly"] = 2499.6, ["Ride"] = 2014.26, ["Fly|Ride"] = 1967.44, ["Mega|Fly|Ride"] = 31725.64}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 69.81, ["Ride"] = 59.07, ["Fly|Ride"] = 260.77, ["Neon"] = 278.1, ["Neon|Fly|Ride"] = 278.4, ["Mega"] = 1947.68, ["Mega|Ride"] = 2293.83, ["Mega|Fly|Ride"] = 1951.85}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 628.69, ["Fly"] = 675.94, ["Ride"] = 599.82, ["Fly|Ride"] = 681.19, ["Neon|Ride"] = 1347.71, ["Neon|Fly|Ride"] = 1053.61, ["Mega|Fly|Ride"] = 2782.5}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 48.97, ["Fly"] = 116.82, ["Ride"] = 52.5, ["Fly|Ride"] = 106.32, ["Neon"] = 208.31, ["Neon|Ride"] = 513.45, ["Neon|Fly|Ride"] = 267.75, ["Mega|Fly|Ride"] = 895.92}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 2.1, ["Fly"] = 31.26, ["Ride"] = 21, ["Fly|Ride"] = 47.93, ["Neon"] = 19.66, ["Neon|Fly"] = 52.49, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 123.05, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 41.91, ["Ride"] = 64.58, ["Fly|Ride"] = 252, ["Neon"] = 694.7, ["Neon|Ride"] = 764.48, ["Mega"] = 1386, ["Mega|Ride"] = 1112.51, ["Mega|Fly|Ride"] = 6951.34}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 523.68, ["Fly"] = 604.09, ["Ride"] = 549.93, ["Fly|Ride"] = 616.12, ["Neon"] = 2307.56, ["Neon|Ride"] = 1640.63, ["Neon|Fly|Ride"] = 1918.48, ["Mega|Fly|Ride"] = 6930}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 430.5, ["Ride"] = 523.69, ["Fly|Ride"] = 708.43, ["Neon"] = 8331.98, ["Neon|Ride"] = 4068.75, ["Neon|Fly|Ride"] = 2100, ["Mega|Fly|Ride"] = 18073.27}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 14.39, ["Fly"] = 32.82, ["Ride"] = 24.94, ["Fly|Ride"] = 40.68, ["Neon"] = 208.31, ["Neon|Ride"] = 94.79, ["Neon|Fly|Ride"] = 125.9, ["Mega|Fly|Ride"] = 615.6}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 7.22, ["Ride"] = 22.32, ["Fly|Ride"] = 62.51, ["Neon"] = 65.62, ["Neon|Ride"] = 92.97, ["Neon|Fly|Ride"] = 182.49, ["Mega"] = 1968.75, ["Mega|Ride"] = 3304.88, ["Mega|Fly|Ride"] = 616.82}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 5.25, ["Ride"] = 26.25, ["Fly|Ride"] = 89.59, ["Neon"] = 19.66, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 46.17, ["Neon|Fly|Ride"] = 278.4, ["Mega"] = 137.49, ["Mega|Ride"] = 186.38, ["Mega|Fly|Ride"] = 334.69}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 40.69, ["Fly"] = 56.25, ["Ride"] = 41.97, ["Fly|Ride"] = 139.12, ["Neon|Ride"] = 181.43, ["Neon|Fly|Ride"] = 250.25, ["Mega|Fly|Ride"] = 723.39}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 39.35, ["Ride"] = 86.63, ["Fly|Ride"] = 616.12, ["Neon"] = 336.99, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 973.85, ["Mega|Ride"] = 1042.67, ["Mega|Fly|Ride"] = 1248.03}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 15.74, ["Fly"] = 57.14, ["Ride"] = 36.74, ["Fly|Ride"] = 89.58, ["Neon"] = 77.33, ["Neon|Ride"] = 92.93, ["Neon|Fly|Ride"] = 119.37, ["Mega|Ride"] = 348.27, ["Mega|Fly|Ride"] = 516.13}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 35.41, ["Fly"] = 87.68, ["Ride"] = 39.37, ["Fly|Ride"] = 87.33, ["Neon|Ride"] = 192.73, ["Neon|Fly|Ride"] = 264.85, ["Mega"] = 2100, ["Mega|Fly|Ride"] = 1105.49}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 4.18, ["Fly"] = 37.51, ["Ride"] = 17.19, ["Fly|Ride"] = 41.68, ["Neon"] = 31.38, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 104.16, ["Mega"] = 177.19, ["Mega|Ride"] = 181.43, ["Mega|Fly|Ride"] = 395.17}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 5.25, ["Fly"] = 65.63, ["Ride"] = 28.67, ["Fly|Ride"] = 59.07, ["Neon"] = 22.04, ["Neon|Fly"] = 154.62, ["Neon|Ride"] = 41.68, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 416.07, ["Mega|Ride"] = 192.94, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 34.13, ["Fly"] = 79.17, ["Ride"] = 53.82, ["Fly|Ride"] = 82.29, ["Neon"] = 416.61, ["Neon|Ride"] = 230.77, ["Neon|Fly|Ride"] = 216.57, ["Mega|Fly|Ride"] = 875.83}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 2439.09, ["Fly"] = 4860.68, ["Ride"] = 2177.43, ["Fly|Ride"] = 2031.75, ["Neon|Ride"] = 5415.79, ["Neon|Fly|Ride"] = 3937.49, ["Mega|Fly|Ride"] = 14437.5}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 472.85, ["Fly"] = 681.15, ["Ride"] = 414.75, ["Fly|Ride"] = 631.14, ["Neon"] = 3077.11, ["Neon|Ride"] = 2083.01, ["Neon|Fly|Ride"] = 1704.94, ["Mega|Fly|Ride"] = 8339.12}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 269.07, ["Ride"] = 346.15, ["Fly|Ride"] = 399, ["Neon"] = 1562.26, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1578.89, ["Mega|Fly|Ride"] = 5906.25}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 44.62}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 43.31, ["Fly"] = 65.63, ["Ride"] = 54.63, ["Fly|Ride"] = 78.75, ["Neon"] = 288.75, ["Neon|Ride"] = 230.24, ["Neon|Fly|Ride"] = 317.92, ["Mega|Ride"] = 1459.73, ["Mega|Fly|Ride"] = 1232.44}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 33327.87, ["Fly"] = 23625, ["Ride"] = 34613.14, ["Fly|Ride"] = 16012.5, ["Neon|Fly|Ride"] = 36748.69, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 249.38, ["Fly"] = 319.75, ["Ride"] = 262.49, ["Fly|Ride"] = 262.5, ["Neon"] = 890.49, ["Neon|Ride"] = 932.15, ["Neon|Fly|Ride"] = 652.31, ["Mega"] = 2708.82, ["Mega|Ride"] = 5032.86, ["Mega|Fly|Ride"] = 2428.13}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 91.88, ["Ride"] = 145.69, ["Fly|Ride"] = 257.25, ["Neon|Fly|Ride"] = 1694.39, ["Mega|Fly|Ride"] = 4031.94}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 117.71, ["Ride"] = 97.13, ["Fly|Ride"] = 169.32, ["Neon|Ride"] = 520.77, ["Neon|Fly|Ride"] = 554.7, ["Mega"] = 13902.67, ["Mega|Fly|Ride"] = 1392.27}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 12.99, ["Fly"] = 94.5, ["Ride"] = 36.46, ["Fly|Ride"] = 86.63, ["Neon"] = 166.66, ["Neon|Ride"] = 83.34, ["Neon|Fly|Ride"] = 291.38, ["Mega"] = 616.77, ["Mega|Ride"] = 595.98, ["Mega|Fly|Ride"] = 556.79}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 3399.38, ["Ride"] = 3630.38, ["Fly|Ride"] = 4499.73, ["Neon|Fly|Ride"] = 16405.04}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 26.24, ["Fly"] = 45.94, ["Ride"] = 37.51, ["Fly|Ride"] = 51.18, ["Neon"] = 131.25, ["Neon|Ride"] = 181.23, ["Neon|Fly|Ride"] = 168, ["Mega|Fly|Ride"] = 632.63}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 45.3, ["Fly"] = 139.57, ["Ride"] = 53.38, ["Fly|Ride"] = 91.88, ["Neon"] = 154.62, ["Neon|Ride"] = 278.1, ["Neon|Fly|Ride"] = 271.1, ["Mega|Fly|Ride"] = 832.05}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 577.5, ["Fly"] = 688.8, ["Ride"] = 651, ["Fly|Ride"] = 728.44, ["Neon"] = 1639.33, ["Neon|Ride"] = 1666.41, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 3803.63}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 18.38, ["Fly"] = 27.57, ["Ride"] = 26.25, ["Fly|Ride"] = 53.74, ["Neon|Fly"] = 187.48, ["Neon|Ride"] = 94.5, ["Neon|Fly|Ride"] = 139.73, ["Mega"] = 695.46, ["Mega|Fly|Ride"] = 470.25}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 20.85, ["Ride"] = 139.57, ["Fly|Ride"] = 461.53, ["Neon"] = 69.55, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 231.02}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 97.92, ["Fly"] = 139.57, ["Ride"] = 124.69, ["Fly|Ride"] = 165.38, ["Neon"] = 694.7, ["Neon|Ride"] = 616.12, ["Neon|Fly|Ride"] = 809.82, ["Mega|Ride"] = 2343.89}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 22.32, ["Ride"] = 77.44, ["Fly|Ride"] = 135.4, ["Neon"] = 90.57, ["Neon|Ride"] = 132.57, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 208.31, ["Mega|Fly"] = 807.19, ["Mega|Ride"] = 278.4, ["Mega|Fly|Ride"] = 357}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 4183.94, ["Ride"] = 3281.25, ["Fly|Ride"] = 3150, ["Neon"] = 9026.66, ["Neon|Ride"] = 16923.54, ["Neon|Fly|Ride"] = 7861.88, ["Mega"] = 62558.85, ["Mega|Fly|Ride"] = 38502.29}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 35.64, ["Ride"] = 85.32, ["Fly|Ride"] = 102.08, ["Neon"] = 154.62, ["Neon|Ride"] = 206.22, ["Neon|Fly|Ride"] = 385.79, ["Mega|Fly|Ride"] = 875.83}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 9026.66, ["Ride"] = 8307.16, ["Fly|Ride"] = 5775, ["Neon|Ride"] = 19383.37, ["Neon|Fly|Ride"] = 15750, ["Mega|Fly|Ride"] = 62490.04}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 3.29, ["Fly"] = 21, ["Ride"] = 18.38, ["Fly|Ride"] = 41.68, ["Neon"] = 20.84, ["Neon|Fly"] = 139.57, ["Neon|Ride"] = 31.16, ["Neon|Fly|Ride"] = 83.43, ["Mega"] = 446.99, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 19.65, ["Fly"] = 35.44, ["Ride"] = 32.3, ["Fly|Ride"] = 69.79, ["Neon"] = 139.57, ["Neon|Ride"] = 278.1, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 1401.1, ["Mega|Fly|Ride"] = 921.75}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 2.63}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 14.44, ["Ride"] = 38.07, ["Fly|Ride"] = 139.57, ["Neon"] = 94.79, ["Neon|Ride"] = 153.57, ["Neon|Fly|Ride"] = 131.25, ["Mega|Ride"] = 695.46, ["Mega|Fly|Ride"] = 834.14}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 35.41, ["Fly"] = 64.59, ["Ride"] = 51.08, ["Neon"] = 177.09, ["Neon|Ride"] = 181.23, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 840, ["Mega|Ride"] = 924, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 11.54, ["Fly"] = 23.97, ["Ride"] = 21, ["Fly|Ride"] = 45.94, ["Neon"] = 54.17, ["Neon|Ride"] = 174.57, ["Neon|Fly|Ride"] = 135.44, ["Mega"] = 2502.38, ["Mega|Fly|Ride"] = 616.82}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8000.6}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2811.38}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 31.24}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 379.12, ["Fly"] = 556.17, ["Ride"] = 139.57, ["Fly|Ride"] = 656.25, ["Neon|Ride"] = 2076.8, ["Neon|Fly|Ride"] = 2210.42, ["Mega|Fly|Ride"] = 5561.5}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 22.93, ["Fly"] = 131.24, ["Ride"] = 53.45, ["Fly|Ride"] = 131.25, ["Neon"] = 208.31, ["Neon|Ride"] = 131.25, ["Mega|Ride"] = 624.57, ["Mega|Fly|Ride"] = 695.46}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 11.47}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 7.87, ["Ride"] = 56.25, ["Neon"] = 70.88, ["Neon|Ride"] = 249.38}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2572.5}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 144.37, ["Ride"] = 105, ["Fly|Ride"] = 287.46, ["Neon"] = 556.17, ["Neon|Ride"] = 694.86, ["Neon|Fly|Ride"] = 834.14, ["Mega|Fly|Ride"] = 2113.47}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 124.69, ["Ride"] = 166.66, ["Fly|Ride"] = 416.61, ["Neon"] = 406.2, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 938.39, ["Mega|Ride"] = 1575, ["Mega|Fly|Ride"] = 1694.47}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 183.74, ["Fly"] = 208.31, ["Ride"] = 196.88, ["Fly|Ride"] = 203.44, ["Neon"] = 820.32, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 862.29, ["Mega|Ride"] = 3473.07, ["Mega|Fly|Ride"] = 2937.38}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1090.69, ["Fly"] = 2499.6, ["Ride"] = 1106.44, ["Fly|Ride"] = 1114.52, ["Neon|Fly|Ride"] = 4593.75, ["Mega|Fly|Ride"] = 20852.95}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 13.13, ["Fly"] = 108.47, ["Ride"] = 45.85, ["Fly|Ride"] = 78.75, ["Neon"] = 65.63, ["Neon|Ride"] = 139.57, ["Neon|Fly|Ride"] = 437.07, ["Mega"] = 728.82, ["Mega|Fly|Ride"] = 903.99}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 654.93, ["Fly"] = 2100, ["Ride"] = 694.7, ["Fly|Ride"] = 833.21, ["Neon|Fly|Ride"] = 4004.36}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 44.63}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 18.75, ["Fly"] = 144.38, ["Ride"] = 39.38, ["Fly|Ride"] = 98.44, ["Neon"] = 73.5, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 486.93, ["Mega"] = 334.69, ["Mega|Ride"] = 418.69, ["Mega|Fly|Ride"] = 485.63}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 8.93, ["Fly"] = 28.13, ["Ride"] = 28.88, ["Fly|Ride"] = 91.88, ["Neon"] = 64.59, ["Neon|Ride"] = 97.92, ["Neon|Fly|Ride"] = 125.13, ["Mega|Ride"] = 385.79, ["Mega|Fly|Ride"] = 417.08}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 82.29}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 35.41, ["Fly"] = 108.92, ["Ride"] = 25.02, ["Fly|Ride"] = 65.54, ["Neon"] = 177.19, ["Neon|Ride"] = 222.89, ["Neon|Fly|Ride"] = 277.36, ["Mega|Ride"] = 834.14, ["Mega|Fly|Ride"] = 653.75}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 39.24, ["Fly"] = 44.63, ["Ride"] = 35.42, ["Fly|Ride"] = 78.75, ["Neon"] = 154.62, ["Neon|Fly"] = 240, ["Neon|Ride"] = 278.1, ["Neon|Fly|Ride"] = 274.32, ["Mega"] = 1390.91, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6146.44, ["Fly"] = 11109.65, ["Ride"] = 6205.24, ["Fly|Ride"] = 5079.38, ["Neon|Fly|Ride"] = 10078.69, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 11.82, ["Fly"] = 79.17, ["Ride"] = 32.82, ["Fly|Ride"] = 97.92, ["Neon"] = 79.48, ["Neon|Fly"] = 118.74, ["Neon|Ride"] = 85.31, ["Mega"] = 459.82, ["Mega|Ride"] = 385.46, ["Mega|Fly|Ride"] = 461.63}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 27.57}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 89.1, ["Fly"] = 368.71, ["Ride"] = 154.16, ["Fly|Ride"] = 278.1, ["Neon"] = 417.38, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 554.4, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 77.42, ["Fly"] = 183.75, ["Ride"] = 115.5, ["Fly|Ride"] = 168, ["Neon"] = 327.6, ["Neon|Ride"] = 380.63, ["Neon|Fly|Ride"] = 765.32, ["Mega|Ride"] = 1251.2, ["Mega|Fly|Ride"] = 1251.2}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 26.23, ["Fly"] = 70.86, ["Ride"] = 30.19, ["Fly|Ride"] = 57.75, ["Neon"] = 108.47, ["Neon|Ride"] = 128.63, ["Neon|Fly|Ride"] = 175.88, ["Mega|Fly|Ride"] = 590.62}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 3.93, ["Fly"] = 49.74, ["Ride"] = 22.32, ["Fly|Ride"] = 94.63, ["Neon"] = 19.69, ["Neon|Ride"] = 64.59, ["Neon|Fly|Ride"] = 130.09, ["Mega"] = 118.13, ["Mega|Fly"] = 139.73, ["Mega|Ride"] = 164.07, ["Mega|Fly|Ride"] = 253.63}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 13.13, ["Fly"] = 73.86, ["Ride"] = 33.35, ["Fly|Ride"] = 97.92, ["Neon"] = 61.69, ["Neon|Ride"] = 91.87, ["Neon|Fly|Ride"] = 156.19, ["Mega|Ride"] = 419.99, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 19.67, ["Fly"] = 32.28, ["Ride"] = 26.25, ["Fly|Ride"] = 39.38, ["Neon"] = 139.57, ["Neon|Fly"] = 208.31, ["Neon|Ride"] = 141.75, ["Neon|Fly|Ride"] = 131.25, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 249.98}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 24.94, ["Ride"] = 103.85, ["Neon"] = 103.69, ["Mega"] = 486.93, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 1341.9}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 77.44, ["Ride"] = 207.27, ["Fly|Ride"] = 262.49, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 753.85}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 38.06, ["Ride"] = 91.88, ["Fly|Ride"] = 206.22, ["Neon"] = 252, ["Neon|Ride"] = 303.38, ["Neon|Fly|Ride"] = 462.02, ["Mega"] = 1128.75, ["Mega|Ride"] = 1250.15, ["Mega|Fly|Ride"] = 1220.63}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 656.25, ["Fly"] = 780.94, ["Ride"] = 691.69, ["Fly|Ride"] = 656.25, ["Neon|Ride"] = 2100, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 6429.94}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 233.63, ["Ride"] = 346.5, ["Fly|Ride"] = 311.07, ["Neon"] = 1222.74, ["Neon|Ride"] = 1539.15, ["Neon|Fly|Ride"] = 1312.5, ["Mega"] = 8202.52, ["Mega|Fly|Ride"] = 4084.21}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 91.88}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 12.52, ["Fly"] = 23.09, ["Ride"] = 25.74, ["Fly|Ride"] = 45.94, ["Neon"] = 80.07, ["Neon|Ride"] = 115.62, ["Neon|Fly|Ride"] = 127.32, ["Mega|Ride"] = 389.97, ["Mega|Fly|Ride"] = 405.57}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 374.07, ["Fly"] = 724.23, ["Ride"] = 459.38, ["Fly|Ride"] = 459.38, ["Neon"] = 918.75, ["Neon|Ride"] = 1010.63, ["Neon|Fly|Ride"] = 971.25, ["Mega"] = 3649.28, ["Mega|Fly|Ride"] = 3229.05}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 15.64}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 98.44, ["Fly"] = 590.63, ["Ride"] = 145.84, ["Fly|Ride"] = 288.75, ["Neon"] = 444.94, ["Neon|Fly"] = 1389.38, ["Neon|Ride"] = 485.63, ["Neon|Fly|Ride"] = 564.38, ["Mega"] = 2502.38, ["Mega|Fly|Ride"] = 1705.2}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 140.44, ["Ride"] = 157.5, ["Fly|Ride"] = 214.61, ["Neon|Ride"] = 769.58, ["Neon|Fly|Ride"] = 695.46}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 6.57, ["Ride"] = 25.4, ["Fly|Ride"] = 104.16, ["Neon"] = 26.04, ["Neon|Ride"] = 83.35, ["Neon|Fly|Ride"] = 166.84, ["Mega"] = 173.1, ["Mega|Ride"] = 202.08, ["Mega|Fly|Ride"] = 404.1}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 14.43, ["Fly"] = 49.88, ["Ride"] = 31.16, ["Fly|Ride"] = 65.63, ["Neon"] = 103.11, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 248.16}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 23.63, ["Fly"] = 139.57, ["Ride"] = 39.38, ["Fly|Ride"] = 105, ["Neon"] = 185.07, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 509.37, ["Mega|Ride"] = 485.88, ["Mega|Fly|Ride"] = 528.64}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 3.94, ["Fly"] = 333.3, ["Ride"] = 34.13, ["Fly|Ride"] = 131.25, ["Neon"] = 19.63, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 123.37, ["Mega|Fly"] = 189, ["Mega|Ride"] = 180.03, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 305.26, ["Fly"] = 918.75, ["Ride"] = 260.54, ["Fly|Ride"] = 414.58, ["Neon"] = 1666.41, ["Neon|Ride"] = 1246.88, ["Neon|Fly|Ride"] = 1378.13}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 83.84, ["Fly"] = 1050, ["Ride"] = 146.35, ["Fly|Ride"] = 242.82, ["Neon"] = 433.13, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 577.5, ["Mega"] = 1540.76, ["Mega|Ride"] = 2044.65, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 72.19, ["Fly"] = 154.16, ["Ride"] = 89.25, ["Fly|Ride"] = 131.25, ["Neon|Ride"] = 288.75, ["Neon|Fly|Ride"] = 429.11, ["Mega|Fly|Ride"] = 1515.94}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 15.74, ["Ride"] = 56.25, ["Fly|Ride"] = 278.1, ["Neon"] = 208.31, ["Neon|Ride"] = 586.13, ["Neon|Fly|Ride"] = 486.93, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 19.69, ["Fly"] = 35.42, ["Ride"] = 48.57, ["Fly|Ride"] = 102.38, ["Neon"] = 75.48, ["Neon|Ride"] = 122.33, ["Neon|Fly|Ride"] = 157.33, ["Mega"] = 479.11, ["Mega|Fly"] = 525, ["Mega|Ride"] = 472.5, ["Mega|Fly|Ride"] = 556.17}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 2.37, ["Fly"] = 41.68, ["Ride"] = 21.93, ["Fly|Ride"] = 136.45, ["Neon"] = 17.32, ["Neon|Ride"] = 35.79, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 108.47, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 211.45}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 1023.75, ["Ride"] = 1002.72, ["Fly|Ride"] = 918.75, ["Neon"] = 2812.05, ["Neon|Fly"] = 2812.05, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2401.88, ["Mega"] = 11817.38, ["Mega|Fly|Ride"] = 7481.25}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 308.06, ["Ride"] = 321.57, ["Fly|Ride"] = 420, ["Neon"] = 1041.51, ["Neon|Ride"] = 943.69, ["Neon|Fly|Ride"] = 1000.96, ["Mega"] = 10426.48, ["Mega|Ride"] = 5852.34, ["Mega|Fly|Ride"] = 4031.94}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 85.39, ["Ride"] = 143.74, ["Fly|Ride"] = 308.06, ["Neon"] = 359.99, ["Neon|Ride"] = 320.25, ["Neon|Fly|Ride"] = 375.04, ["Mega"] = 918.75, ["Mega|Ride"] = 1668.26, ["Mega|Fly|Ride"] = 1528.26}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 171.87, ["Ride"] = 209.95, ["Fly|Ride"] = 300.57, ["Neon"] = 694.7, ["Neon|Ride"] = 905.63, ["Neon|Fly|Ride"] = 945.7, ["Mega"] = 10426.48, ["Mega|Fly|Ride"] = 2887.49}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 18.38, ["Fly"] = 50.02, ["Ride"] = 39.38, ["Fly|Ride"] = 83.34, ["Neon"] = 154.65, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 157.5, ["Mega|Ride"] = 695.46, ["Mega|Fly|Ride"] = 619.12}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 311.72, ["Ride"] = 416.61, ["Neon"] = 1249.81, ["Neon|Ride"] = 1115.63, ["Neon|Fly|Ride"] = 1355.45, ["Mega"] = 5250, ["Mega|Fly|Ride"] = 4331.24}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 111.45, ["Fly"] = 126, ["Ride"] = 68.75, ["Fly|Ride"] = 65.63, ["Neon|Ride"] = 278.1, ["Mega|Fly|Ride"] = 2002.87}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1307.23, ["Ride"] = 1312.5, ["Fly|Ride"] = 1409.92, ["Neon|Ride"] = 4374.29, ["Neon|Fly|Ride"] = 3926.97, ["Mega"] = 50047.08, ["Mega|Fly|Ride"] = 24326.02}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 13.13, ["Fly"] = 41.67, ["Ride"] = 35.44, ["Fly|Ride"] = 105, ["Neon"] = 35.43, ["Neon|Fly"] = 166.16, ["Neon|Ride"] = 83.98, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 305.82, ["Mega|Ride"] = 230.77, ["Mega|Fly|Ride"] = 561.75}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 81.25, ["Ride"] = 104.16, ["Fly|Ride"] = 208.31, ["Neon"] = 283.31, ["Neon|Ride"] = 208.31, ["Neon|Fly|Ride"] = 413.44, ["Mega"] = 1017.56, ["Mega|Fly|Ride"] = 967.59}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 73.43, ["Fly"] = 78.75, ["Ride"] = 78.75, ["Fly|Ride"] = 125, ["Neon|Ride"] = 389.53, ["Neon|Fly|Ride"] = 360.41, ["Mega|Fly|Ride"] = 1469.99}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 2498.56, ["Ride"] = 905.63, ["Fly|Ride"] = 1074.94, ["Neon|Fly|Ride"] = 4199.99, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 461.53, ["Ride"] = 328.13, ["Fly|Ride"] = 525, ["Neon|Ride"] = 1737.23, ["Neon|Fly|Ride"] = 1449.3, ["Mega|Fly|Ride"] = 9086.75}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 139.57, ["Fly"] = 208.31, ["Ride"] = 227.06, ["Fly|Ride"] = 236.43, ["Neon"] = 460.04, ["Neon|Ride"] = 456.75, ["Neon|Fly|Ride"] = 519.49, ["Mega"] = 3962.07, ["Mega|Ride"] = 1704.94, ["Mega|Fly|Ride"] = 1770.55}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 9.18, ["Ride"] = 22.93, ["Fly|Ride"] = 87.94, ["Neon"] = 101.06, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 233.63, ["Mega"] = 274.97, ["Mega|Fly|Ride"] = 973.85}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 41.97, ["Fly"] = 95.82, ["Ride"] = 64.32, ["Fly|Ride"] = 90.62, ["Neon"] = 249.38, ["Neon|Fly"] = 403.07, ["Neon|Ride"] = 244.77, ["Neon|Fly|Ride"] = 311.76, ["Mega"] = 1807.97, ["Mega|Fly|Ride"] = 1049.99}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 702.19, ["Ride"] = 1058.17, ["Fly|Ride"] = 1231.09, ["Neon"] = 3264.07, ["Neon|Fly|Ride"] = 2981.99, ["Mega|Fly|Ride"] = 17377.82}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 774.38}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 4068.75, ["Ride"] = 4173.75, ["Fly|Ride"] = 4173.75, ["Neon|Ride"] = 29850.32, ["Neon|Fly|Ride"] = 15750, ["Mega|Fly|Ride"] = 88973.29}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 149.63, ["Fly"] = 408.19, ["Ride"] = 347.88, ["Fly|Ride"] = 393.75, ["Neon"] = 624.91, ["Neon|Ride"] = 1231.09, ["Neon|Fly|Ride"] = 851.82, ["Mega"] = 5838.84, ["Mega|Fly|Ride"] = 6117.23}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 77.44, ["Ride"] = 97.92, ["Fly|Ride"] = 336, ["Neon|Ride"] = 463.49, ["Neon|Fly|Ride"] = 973.85}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 11.47, ["Fly"] = 131.25, ["Ride"] = 26.25, ["Fly|Ride"] = 89.58, ["Neon"] = 68.75, ["Neon|Ride"] = 103.87, ["Neon|Fly|Ride"] = 155.25, ["Mega|Ride"] = 834.14, ["Mega|Fly|Ride"] = 473.38}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 17.05, ["Fly"] = 28.32, ["Ride"] = 28.13, ["Fly|Ride"] = 52.08, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 2210.42}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 21.19, ["Fly"] = 70.9, ["Ride"] = 32.82, ["Fly|Ride"] = 105, ["Neon"] = 108.47, ["Neon|Ride"] = 97.13, ["Neon|Fly|Ride"] = 154.2, ["Mega|Ride"] = 859.69, ["Mega|Fly|Ride"] = 666.73}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 3.93, ["Ride"] = 28.88, ["Fly|Ride"] = 41.68, ["Neon"] = 21, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 308.13, ["Mega|Fly|Ride"] = 357}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 32.8, ["Ride"] = 56.25, ["Fly|Ride"] = 164.07, ["Neon"] = 143.07, ["Neon|Ride"] = 308.06, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 667.31, ["Mega|Ride"] = 694.68, ["Mega|Fly|Ride"] = 729.87}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 273, ["Fly"] = 331.14, ["Ride"] = 262.5, ["Fly|Ride"] = 309.75, ["Neon"] = 720.74, ["Neon|Ride"] = 681.19, ["Neon|Fly|Ride"] = 717.94, ["Mega"] = 6562.5, ["Mega|Ride"] = 4170.6, ["Mega|Fly|Ride"] = 3799.69}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.1, ["Fly"] = 16.69, ["Ride"] = 15.75, ["Fly|Ride"] = 32.3, ["Neon"] = 16.69, ["Neon|Fly"] = 92.32, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 71.06, ["Mega"] = 118.13, ["Mega|Ride"] = 734.04, ["Mega|Fly|Ride"] = 267.75}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 32.78, ["Fly"] = 98.96, ["Ride"] = 62.5, ["Fly|Ride"] = 126.34, ["Neon"] = 157.47, ["Neon|Fly"] = 288.75, ["Neon|Ride"] = 177.43, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 472.5, ["Mega|Ride"] = 511.88, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 761.25, ["Fly"] = 787.5, ["Ride"] = 761.25, ["Fly|Ride"] = 786.19, ["Neon|Ride"] = 1945.53, ["Neon|Fly|Ride"] = 1575, ["Mega|Fly|Ride"] = 3937.5}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 28.12, ["Fly"] = 64.32, ["Ride"] = 36.75, ["Fly|Ride"] = 78.75, ["Neon"] = 125, ["Neon|Fly"] = 461.53, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 179.82, ["Mega"] = 1575, ["Mega|Ride"] = 973.85, ["Mega|Fly|Ride"] = 813.28}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 317.61, ["Fly"] = 316.32, ["Ride"] = 262.49, ["Fly|Ride"] = 324.19, ["Neon"] = 1389.38, ["Neon|Fly|Ride"] = 1278.24, ["Mega|Fly|Ride"] = 4431.27}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 114.19, ["Fly"] = 129.93, ["Ride"] = 123.38, ["Fly|Ride"] = 166.16, ["Neon"] = 624.91, ["Neon|Fly"] = 633.25, ["Neon|Ride"] = 556.17, ["Neon|Fly|Ride"] = 486.93, ["Mega"] = 2919.44, ["Mega|Fly|Ride"] = 1805.89}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 645.74, ["Ride"] = 570.93, ["Fly|Ride"] = 682.5, ["Neon"] = 2634.08, ["Neon|Ride"] = 2361.09, ["Neon|Fly|Ride"] = 2411.07, ["Mega|Fly|Ride"] = 10146.02}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 19.69, ["Ride"] = 52.5, ["Fly|Ride"] = 94.79, ["Neon"] = 61.69, ["Neon|Fly"] = 181.23, ["Neon|Ride"] = 118.6, ["Neon|Fly|Ride"] = 211.32, ["Mega"] = 416.03, ["Mega|Ride"] = 403.52, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 3732.75, ["Fly"] = 3915.92, ["Ride"] = 3936.19, ["Fly|Ride"] = 3150, ["Neon"] = 13851.91, ["Neon|Fly|Ride"] = 6943.65, ["Mega|Fly|Ride"] = 23745.75}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 66.94, ["Fly"] = 119.79, ["Ride"] = 102.08, ["Fly|Ride"] = 139.57, ["Neon"] = 394.78, ["Neon|Ride"] = 446.25, ["Neon|Fly|Ride"] = 400.32, ["Mega|Fly|Ride"] = 1694.39}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 27.09, ["Ride"] = 19.69, ["Fly|Ride"] = 84, ["Neon"] = 14.44, ["Neon|Fly"] = 44.63, ["Neon|Ride"] = 41.99, ["Neon|Fly|Ride"] = 111.58, ["Mega"] = 111.58, ["Mega|Fly"] = 452.82, ["Mega|Ride"] = 204.38, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.54, ["Ride"] = 31.5, ["Neon"] = 19.69, ["Neon|Ride"] = 69.79, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 147, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 278.2}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 60.59, ["Fly"] = 65.63, ["Ride"] = 47.51, ["Fly|Ride"] = 73.5, ["Neon|Ride"] = 694.7, ["Neon|Fly|Ride"] = 240.19, ["Mega|Fly|Ride"] = 1209.49}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 904.32, ["Ride"] = 943.69, ["Fly|Ride"] = 1050, ["Neon"] = 3745.23, ["Neon|Fly|Ride"] = 4725, ["Mega|Fly|Ride"] = 26414.45}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 5138.76, ["Ride"] = 5103.34, ["Fly|Ride"] = 5207.49}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 22.32, ["Fly"] = 33.34, ["Ride"] = 27.57, ["Fly|Ride"] = 52.49, ["Neon|Ride"] = 144.8, ["Neon|Fly|Ride"] = 137.09, ["Mega"] = 2502.38, ["Mega|Fly|Ride"] = 462.04}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 17.89, ["Fly"] = 44.8, ["Ride"] = 34.13, ["Fly|Ride"] = 82.69, ["Neon"] = 94.48, ["Neon|Ride"] = 101.3, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 924, ["Mega|Ride"] = 640.2, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 38.04, ["Fly"] = 139.6, ["Ride"] = 40.63, ["Fly|Ride"] = 85.32, ["Neon"] = 393.75, ["Neon|Ride"] = 245.44, ["Neon|Fly|Ride"] = 249.38, ["Mega|Fly|Ride"] = 859.68}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 216.57, ["Ride"] = 254.63, ["Fly|Ride"] = 296.83, ["Neon|Ride"] = 1048.69, ["Neon|Fly|Ride"] = 1140.67, ["Mega"] = 10426.48, ["Mega|Fly|Ride"] = 3696.15}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.93, ["Neon"] = 20.96, ["Neon|Fly"] = 70.95, ["Neon|Fly|Ride"] = 154.79, ["Mega"] = 139.55, ["Mega|Ride"] = 269.01, ["Mega|Fly|Ride"] = 307.59}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 183.74, ["Fly"] = 278.1, ["Ride"] = 199.86, ["Fly|Ride"] = 282.19, ["Neon"] = 749.89, ["Neon|Fly"] = 923.04, ["Neon|Ride"] = 609, ["Neon|Fly|Ride"] = 733.69, ["Mega|Fly|Ride"] = 2624.99}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 2.1, ["Fly"] = 73.5, ["Ride"] = 16.89, ["Fly|Ride"] = 43.55, ["Neon"] = 28.19, ["Neon|Ride"] = 66.68, ["Neon|Fly|Ride"] = 105, ["Mega"] = 462.02, ["Mega|Ride"] = 417.08, ["Mega|Fly|Ride"] = 417.08}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 203.7, ["Fly"] = 322.22, ["Ride"] = 234.35, ["Fly|Ride"] = 275.63, ["Neon|Fly|Ride"] = 891.49, ["Mega"] = 10426.48, ["Mega|Ride"] = 4170.6, ["Mega|Fly|Ride"] = 3753.54}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 12.75, ["Fly"] = 416.61, ["Ride"] = 31.16, ["Fly|Ride"] = 86.56, ["Neon"] = 52.5, ["Neon|Fly"] = 293.07, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 389.97, ["Mega"] = 459.82, ["Mega|Ride"] = 583.9, ["Mega|Fly|Ride"] = 459.82}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 3.14, ["Ride"] = 18.38, ["Fly|Ride"] = 157.5, ["Neon"] = 10.48, ["Neon|Fly"] = 170.63, ["Neon|Ride"] = 39.59, ["Neon|Fly|Ride"] = 163.79, ["Mega"] = 75.36, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 213.94}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 4.98, ["Neon|Ride"] = 65.4, ["Mega"] = 164.59, ["Mega|Fly|Ride"] = 166.84}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 3.87, ["Ride"] = 66.93, ["Fly|Ride"] = 216.65, ["Neon"] = 10.5, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 69.57, ["Mega|Fly"] = 153999.05, ["Mega|Ride"] = 94.5, ["Mega|Fly|Ride"] = 272.6}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 66.92, ["Fly"] = 137.49, ["Ride"] = 103.16, ["Fly|Ride"] = 181.07, ["Neon"] = 275.63, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 291.38, ["Mega|Ride"] = 1311.19, ["Mega|Fly|Ride"] = 1250.15}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 28.32, ["Ride"] = 18.26, ["Fly|Ride"] = 53.81, ["Neon"] = 12.52, ["Neon|Ride"] = 21.1, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 129.94, ["Mega|Ride"] = 135.56, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 16.65, ["Ride"] = 97.92, ["Neon"] = 131.25, ["Neon|Ride"] = 315, ["Mega"] = 393.75, ["Mega|Ride"] = 556.79, ["Mega|Fly|Ride"] = 556.79}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 77.09, ["Neon|Fly|Ride"] = 154.79, ["Mega"] = 17.11, ["Mega|Ride"] = 48.57, ["Mega|Fly|Ride"] = 278.4}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 17.07, ["Fly|Ride"] = 35.42, ["Neon"] = 2.1, ["Neon|Ride"] = 15.64, ["Neon|Fly|Ride"] = 77.17, ["Mega"] = 18.75, ["Mega|Fly"] = 41.72, ["Mega|Ride"] = 18.38, ["Mega|Fly|Ride"] = 58.92}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 15.64, ["Ride"] = 139.07, ["Fly|Ride"] = 45.52, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 15.64, ["Neon|Fly|Ride"] = 102.2, ["Mega"] = 15.74, ["Mega|Ride"] = 40.4, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Mega"] = 15.74, ["Mega|Ride"] = 131.25}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 15.73, ["Ride"] = 17.45, ["Fly|Ride"] = 107.63, ["Neon"] = 8.35, ["Neon|Fly"] = 135.05, ["Neon|Ride"] = 35.41, ["Neon|Fly|Ride"] = 81.38, ["Mega"] = 219.47, ["Mega|Fly"] = 91.88, ["Mega|Fly|Ride"] = 139.73}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly|Ride"] = 139.57, ["Mega"] = 24.94, ["Mega|Ride"] = 103.97}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 2.24, ["Fly"] = 46.98, ["Ride"] = 19.31, ["Fly|Ride"] = 56.25, ["Neon"] = 7.87, ["Neon|Fly"] = 37.96, ["Neon|Ride"] = 28.13, ["Neon|Fly|Ride"] = 61.69, ["Mega"] = 80.79, ["Mega|Fly"] = 348.27, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 158.48}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 26.17, ["Mega"] = 14.44, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 120.75}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.1, ["Ride"] = 140.62, ["Fly|Ride"] = 525, ["Neon"] = 21.76, ["Mega"] = 139.73, ["Mega|Ride"] = 157.5}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 4.6, ["Ride"] = 79.17, ["Neon"] = 16.88}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Neon"] = 6.55, ["Neon|Ride"] = 36.95, ["Neon|Fly|Ride"] = 69.87, ["Mega"] = 22.49, ["Mega|Ride"] = 172.11}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 12.5, ["Ride"] = 18.38, ["Fly|Ride"] = 42.72, ["Neon"] = 2.1, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 15.64, ["Neon|Fly|Ride"] = 32.71, ["Mega"] = 15.64, ["Mega|Ride"] = 22.95, ["Mega|Fly|Ride"] = 54.3}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.61, ["Fly"] = 72.19, ["Ride"] = 42, ["Fly|Ride"] = 103.11, ["Neon"] = 41.68, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 182.47, ["Mega"] = 250.25, ["Mega|Ride"] = 346.12}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.63, ["Ride"] = 18.57, ["Fly|Ride"] = 78.73, ["Neon"] = 11.47, ["Neon|Ride"] = 42, ["Mega"] = 43.32, ["Mega|Ride"] = 105.95, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 2.1, ["Ride"] = 69.79, ["Neon"] = 13.48, ["Neon|Fly|Ride"] = 139.73, ["Mega"] = 84, ["Mega|Ride"] = 233.63}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 6.3, ["Fly"] = 656.25, ["Ride"] = 31.58, ["Fly|Ride"] = 189.56, ["Neon"] = 12.52, ["Neon|Fly"] = 91.17, ["Neon|Ride"] = 35.42, ["Neon|Fly|Ride"] = 269.01, ["Mega"] = 209.77, ["Mega|Ride"] = 85.3, ["Mega|Fly|Ride"] = 278.4}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 39.29, ["Ride"] = 22.32, ["Fly|Ride"] = 26.94, ["Neon"] = 2.1, ["Neon|Fly"] = 20.79, ["Neon|Ride"] = 15.64, ["Neon|Fly|Ride"] = 34.13, ["Mega"] = 13.13, ["Mega|Ride"] = 23.98, ["Mega|Fly|Ride"] = 55.13}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 15.65, ["Fly|Ride"] = 138.48, ["Neon"] = 15.64, ["Neon|Ride"] = 110.77, ["Neon|Fly|Ride"] = 74.04, ["Mega"] = 128.63, ["Mega|Ride"] = 124.69, ["Mega|Fly|Ride"] = 202.16}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 2.1, ["Fly"] = 111.45, ["Fly|Ride"] = 139.57, ["Neon"] = 77.09, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 307.25, ["Mega|Ride"] = 277.55, ["Mega|Fly|Ride"] = 441.06}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 22.93, ["Ride"] = 18.75, ["Fly|Ride"] = 36.46, ["Neon"] = 2.1, ["Neon|Fly"] = 22.44, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 32.82, ["Mega"] = 17.34, ["Mega|Fly"] = 156.19, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 97.33}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.1, ["Neon"] = 6.2, ["Neon|Fly"] = 77.09, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 105, ["Mega"] = 81.94, ["Mega|Ride"] = 118.13}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 61.69, ["Neon"] = 6.57, ["Neon|Fly"] = 154.16, ["Neon|Ride"] = 43.76, ["Neon|Fly|Ride"] = 308.39, ["Mega"] = 39.29, ["Mega|Ride"] = 92.42, ["Mega|Fly|Ride"] = 278.4}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 118.74, ["Neon"] = 2.1, ["Neon|Fly"] = 40.69, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 84, ["Mega"] = 14.44, ["Mega|Ride"] = 31.2}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 41.68, ["Ride"] = 19.79, ["Fly|Ride"] = 59.07, ["Neon|Fly"] = 41.68, ["Neon|Ride"] = 17.33, ["Neon|Fly|Ride"] = 69.87, ["Mega"] = 94.5, ["Mega|Ride"] = 105}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 41.95, ["Neon"] = 7.86, ["Neon|Ride"] = 154.62, ["Mega"] = 64.32, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 160.13}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 28.13, ["Ride"] = 20.84, ["Fly|Ride"] = 97.92, ["Neon"] = 6.03, ["Neon|Ride"] = 39.24, ["Neon|Fly|Ride"] = 102.38, ["Mega"] = 65.63, ["Mega|Ride"] = 90.2, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 2.1, ["Fly"] = 35.42, ["Ride"] = 80.99, ["Neon"] = 84, ["Mega"] = 296.63, ["Mega|Fly|Ride"] = 844.06}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Ride"] = 21, ["Fly|Ride"] = 5307.36, ["Neon"] = 15.64, ["Neon|Fly"] = 58.78, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 315, ["Mega|Fly|Ride"] = 553.66}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.1, ["Fly"] = 28.13, ["Ride"] = 27.09, ["Fly|Ride"] = 141.75, ["Neon"] = 18.38, ["Neon|Fly"] = 56.25, ["Neon|Ride"] = 56.25, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 196.88, ["Mega|Ride"] = 136.5, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 79.47, ["Fly|Ride"] = 103.85, ["Neon"] = 71.37, ["Neon|Ride"] = 36.75, ["Mega|Fly|Ride"] = 462.04}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 16.65, ["Mega"] = 656.25, ["Mega|Fly|Ride"] = 794.07}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 3.93, ["Ride"] = 262.5, ["Fly|Ride"] = 69.79, ["Neon"] = 41.68, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 125.13, ["Mega"] = 256.28}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 4.17, ["Ride"] = 123.46, ["Neon"] = 37.51, ["Neon|Ride"] = 97.92, ["Mega"] = 189, ["Mega|Ride"] = 230.15, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 119.79, ["Mega"] = 22.32, ["Mega|Fly|Ride"] = 141.75}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 45.94}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 3.94, ["Fly"] = 23.97, ["Ride"] = 22.92, ["Fly|Ride"] = 52.47, ["Neon"] = 35.44, ["Neon|Fly"] = 223.13, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 106.31, ["Mega"] = 210, ["Mega|Ride"] = 184.82, ["Mega|Fly|Ride"] = 367.03}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 19.69, ["Fly|Ride"] = 70.62, ["Neon"] = 4.17, ["Neon|Ride"] = 37.51, ["Neon|Fly|Ride"] = 154.79, ["Mega"] = 19.65, ["Mega|Ride"] = 94.5, ["Mega|Fly|Ride"] = 261.73}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.63, ["Ride"] = 164.07, ["Fly|Ride"] = 385.38, ["Neon"] = 5.25, ["Neon|Ride"] = 48.48, ["Mega"] = 56.26, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 23.55, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 95.93, ["Mega"] = 133.76, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 308.42}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 3.94, ["Neon"] = 43.76, ["Neon|Fly|Ride"] = 155.92, ["Mega"] = 391.79, ["Mega|Fly|Ride"] = 416.03}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Neon"] = 3.67, ["Neon|Ride"] = 50.78, ["Mega"] = 6.57, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 50.77, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Ride"] = 19.79, ["Fly|Ride"] = 277732.45, ["Neon"] = 6.34, ["Neon|Fly"] = 30.18, ["Neon|Ride"] = 30.01, ["Neon|Fly|Ride"] = 68.82, ["Mega"] = 32.05, ["Mega|Fly"] = 100.11, ["Mega|Ride"] = 73.95, ["Mega|Fly|Ride"] = 150.02}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 28.25, ["Ride"] = 17.07, ["Fly|Ride"] = 42, ["Neon"] = 8.39, ["Neon|Fly"] = 69.79, ["Neon|Ride"] = 20.85, ["Neon|Fly|Ride"] = 139.73, ["Mega"] = 56.32, ["Mega|Fly"] = 107.63, ["Mega|Fly|Ride"] = 133.33}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Ride"] = 278.1, ["Neon"] = 3.94, ["Neon|Ride"] = 47.93, ["Neon|Fly|Ride"] = 82.03, ["Mega"] = 26.25, ["Mega|Ride"] = 56.32, ["Mega|Fly|Ride"] = 102.38}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 3.77, ["Neon|Ride"] = 38.06, ["Neon|Fly|Ride"] = 119.91, ["Mega"] = 27.98, ["Mega|Fly"] = 105, ["Mega|Ride"] = 83.71, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 26.36, ["Ride"] = 25.14, ["Fly|Ride"] = 79.17, ["Neon"] = 2.63, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 84, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 138.62}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Neon"] = 2.1, ["Mega"] = 15.75, ["Mega|Ride"] = 204.18}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 7.87, ["Neon|Ride"] = 77.32, ["Neon|Fly|Ride"] = 420, ["Mega"] = 525}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 18.38, ["Neon"] = 7.65, ["Neon|Ride"] = 20.84, ["Neon|Fly|Ride"] = 77.44, ["Mega"] = 45.94, ["Mega|Ride"] = 53.81, ["Mega|Fly|Ride"] = 154.19}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 18.52, ["Ride"] = 59.07, ["Neon"] = 111.45, ["Mega"] = 414.1, ["Mega|Ride"] = 486.93, ["Mega|Fly|Ride"] = 688.16}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 3.15, ["Ride"] = 68.25, ["Neon"] = 20.85, ["Neon|Fly|Ride"] = 110.25, ["Mega"] = 1587.97, ["Mega|Ride"] = 288.75}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 3.93, ["Ride"] = 31.16, ["Fly|Ride"] = 416.61, ["Neon"] = 97.92, ["Neon|Ride"] = 278.1, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 265.13, ["Mega|Fly|Ride"] = 556.79}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 12.85, ["Ride"] = 15.63, ["Fly|Ride"] = 39.41, ["Neon"] = 2.1, ["Neon|Fly"] = 19.69, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 35.46, ["Mega"] = 16.62, ["Mega|Fly"] = 24.94, ["Mega|Ride"] = 18.61, ["Mega|Fly|Ride"] = 51.6}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Neon"] = 15.74, ["Neon|Fly"] = 139.57, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 62.39, ["Mega|Ride"] = 61.69, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Ride"] = 31.5, ["Neon"] = 2.1, ["Neon|Fly"] = 31.16, ["Neon|Ride"] = 31.26, ["Neon|Fly|Ride"] = 69.87, ["Mega"] = 15.21, ["Mega|Fly"] = 78.44, ["Mega|Ride"] = 36.46, ["Mega|Fly|Ride"] = 337.98}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 3.82, ["Neon|Fly"] = 60.9, ["Mega"] = 15.75, ["Mega|Fly|Ride"] = 154.79}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Ride"] = 23.97, ["Fly|Ride"] = 262.5, ["Neon"] = 11.42, ["Neon|Fly"] = 139.57, ["Neon|Ride"] = 31.14, ["Neon|Fly|Ride"] = 102.93, ["Mega"] = 104.28, ["Mega|Ride"] = 108.59, ["Mega|Fly|Ride"] = 258.6}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 245.44, ["Ride"] = 416.61, ["Fly|Ride"] = 393.75, ["Neon"] = 1194.61, ["Neon|Ride"] = 1050, ["Neon|Fly|Ride"] = 1215.69, ["Mega"] = 8341.19, ["Mega|Fly|Ride"] = 5283.11}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Fly|Ride"] = 52.5, ["Neon"] = 7.88, ["Neon|Ride"] = 68.25, ["Mega"] = 62.39, ["Mega|Ride"] = 173.1, ["Mega|Fly|Ride"] = 556.63}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 3.92, ["Fly"] = 103.68, ["Ride"] = 23.97, ["Fly|Ride"] = 140.2, ["Neon"] = 114.23, ["Neon|Ride"] = 165.62, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 603.75, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 616.82}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 22.32, ["Ride"] = 14.97, ["Fly|Ride"] = 33.08, ["Neon"] = 4.17, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 28.85, ["Neon|Fly|Ride"] = 61.69, ["Mega"] = 49.88, ["Mega|Ride"] = 77.4, ["Mega|Fly|Ride"] = 140.44}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Ride"] = 15.64, ["Fly|Ride"] = 120.83, ["Neon"] = 9.24, ["Neon|Fly"] = 41.68, ["Neon|Ride"] = 41.68, ["Mega"] = 110.53, ["Mega|Ride"] = 135.56, ["Mega|Fly|Ride"] = 207.51}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 3.93, ["Fly"] = 32.66, ["Ride"] = 22.32, ["Fly|Ride"] = 43.76, ["Neon"] = 28.59, ["Neon|Ride"] = 39.59, ["Neon|Fly|Ride"] = 87.28, ["Mega"] = 203.33, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 308.39}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 5.8, ["Ride"] = 145.69, ["Fly|Ride"] = 246.75, ["Neon"] = 57.75, ["Neon|Ride"] = 90.57, ["Neon|Fly|Ride"] = 619.35, ["Mega"] = 328.13, ["Mega|Ride"] = 417.08, ["Mega|Fly|Ride"] = 512.54}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.63, ["Fly"] = 28.13, ["Ride"] = 15.74, ["Fly|Ride"] = 39.38, ["Neon"] = 28.32, ["Neon|Fly"] = 56.25, ["Neon|Ride"] = 45.85, ["Neon|Fly|Ride"] = 52.49, ["Mega"] = 196.88, ["Mega|Ride"] = 417.08, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 66.94, ["Fly"] = 83.34, ["Ride"] = 92.32, ["Fly|Ride"] = 156.23, ["Neon"] = 439.69, ["Neon|Fly"] = 394.42, ["Neon|Ride"] = 295.25, ["Neon|Fly|Ride"] = 418.69, ["Mega|Fly|Ride"] = 1463.6}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 207.27, ["Fly"] = 385.38, ["Ride"] = 236.43, ["Fly|Ride"] = 258.3, ["Neon"] = 999.86, ["Neon|Ride"] = 1111.29, ["Neon|Fly|Ride"] = 1022.85, ["Mega"] = 10426.48, ["Mega|Fly|Ride"] = 4861.87}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 65.63, ["Fly"] = 115.4, ["Ride"] = 69.79, ["Fly|Ride"] = 111.45, ["Neon"] = 415.57, ["Neon|Ride"] = 293.47, ["Neon|Fly|Ride"] = 353.07, ["Mega|Fly|Ride"] = 1168.13}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 6.25, ["Fly"] = 26.25, ["Ride"] = 41.54, ["Fly|Ride"] = 83.08, ["Neon"] = 28.12, ["Neon|Fly"] = 50.02, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 187.69, ["Mega"] = 582.86, ["Mega|Ride"] = 169.32, ["Mega|Fly|Ride"] = 392.44}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 13.09, ["Fly"] = 41.68, ["Ride"] = 31.49, ["Fly|Ride"] = 78.73, ["Neon"] = 83.69, ["Neon|Ride"] = 139.57, ["Neon|Fly|Ride"] = 208.55, ["Mega"] = 479.34, ["Mega|Ride"] = 388.5, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 31.49, ["Ride"] = 21, ["Fly|Ride"] = 50.02, ["Neon"] = 6.04, ["Neon|Fly"] = 31.26, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 30.19, ["Mega|Fly"] = 115.52, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 177.9}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 8.28, ["Fly"] = 81.38, ["Ride"] = 27.09, ["Fly|Ride"] = 104.16, ["Neon"] = 41.11, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 139.73, ["Mega"] = 494.34, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 346.18}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 15.75, ["Fly|Ride"] = 45.1, ["Neon"] = 13.13, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 32.52, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 131.24, ["Mega|Ride"] = 230.13, ["Mega|Fly|Ride"] = 175.88}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 4.86, ["Ride"] = 30.19, ["Fly|Ride"] = 328.13, ["Neon"] = 23.97, ["Neon|Ride"] = 56.25, ["Mega"] = 179.34, ["Mega|Fly|Ride"] = 695.46}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 28.13, ["Neon"] = 2.1, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 15.64, ["Mega|Ride"] = 37.55, ["Mega|Fly|Ride"] = 208.55}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 45.93, ["Ride"] = 31.26, ["Fly|Ride"] = 56.25, ["Neon"] = 16.69, ["Neon|Fly"] = 69.79, ["Neon|Ride"] = 35.79, ["Neon|Fly|Ride"] = 86.64, ["Mega"] = 154.79, ["Mega|Ride"] = 92.42, ["Mega|Fly|Ride"] = 192.29}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 18.37, ["Neon"] = 62.31, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 556.79, ["Mega"] = 181.43, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 271.69}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 118.13, ["Fly"] = 243.73, ["Ride"] = 154.6, ["Fly|Ride"] = 218.19, ["Neon"] = 524.99, ["Neon|Ride"] = 624.91, ["Neon|Fly|Ride"] = 544.68, ["Mega|Fly|Ride"] = 1903.13}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 8.33, ["Ride"] = 240.91, ["Fly|Ride"] = 203.11, ["Neon"] = 128.13, ["Neon|Ride"] = 154.62, ["Neon|Fly|Ride"] = 152.25, ["Mega"] = 414.75, ["Mega|Fly|Ride"] = 487.39}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 69.25, ["Ride"] = 27.08, ["Fly|Ride"] = 112.88, ["Neon"] = 30.22, ["Neon|Ride"] = 27.09, ["Neon|Fly|Ride"] = 86.63, ["Mega"] = 308.44, ["Mega|Ride"] = 258.6, ["Mega|Fly|Ride"] = 230.44}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 25.99, ["Ride"] = 138.53, ["Fly|Ride"] = 131.25, ["Neon"] = 90.57, ["Neon|Ride"] = 137.49, ["Neon|Fly|Ride"] = 294.54, ["Mega"] = 519.7, ["Mega|Ride"] = 551.25, ["Mega|Fly|Ride"] = 556.79}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 6.18}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 2.1, ["Ride"] = 27.57, ["Neon"] = 72.19, ["Neon|Fly|Ride"] = 625.61, ["Mega"] = 288.75, ["Mega|Ride"] = 417.08, ["Mega|Fly|Ride"] = 1251.2}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 27.56, ["Fly"] = 47.93, ["Ride"] = 45.93, ["Fly|Ride"] = 52.5, ["Neon"] = 278.1, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 154.19, ["Neon|Fly|Ride"] = 220.81, ["Mega"] = 2085.32, ["Mega|Fly|Ride"] = 1057.98}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Fly|Ride"] = 28.13, ["Neon"] = 2.1, ["Neon|Ride"] = 35.42, ["Neon|Fly|Ride"] = 125.13, ["Mega"] = 23.63, ["Mega|Ride"] = 77.64, ["Mega|Fly|Ride"] = 234.62}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 3.82, ["Fly"] = 34.13, ["Ride"] = 28.13, ["Fly|Ride"] = 77.09, ["Neon"] = 39.38, ["Neon|Ride"] = 230.77, ["Mega"] = 144.95, ["Mega|Fly"] = 385.79, ["Mega|Ride"] = 161.47, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 17.33, ["Ride"] = 23.97, ["Fly|Ride"] = 61.47, ["Neon"] = 19.69, ["Neon|Ride"] = 36.03, ["Neon|Fly|Ride"] = 83.35, ["Mega"] = 111.58, ["Mega|Fly"] = 137.64, ["Mega|Ride"] = 120.75, ["Mega|Fly|Ride"] = 232.13}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Neon"] = 5.25, ["Neon|Ride"] = 40.63, ["Neon|Fly|Ride"] = 112.88, ["Mega"] = 61.47, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 308.42}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 26.24, ["Fly"] = 61.46, ["Ride"] = 81.25, ["Neon"] = 208.29, ["Neon|Ride"] = 249.38, ["Mega"] = 770.39, ["Mega|Ride"] = 813.75, ["Mega|Fly|Ride"] = 1108.35}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.93, ["Ride"] = 59.07, ["Fly|Ride"] = 209.99, ["Neon"] = 69.55, ["Neon|Ride"] = 77.09, ["Mega|Ride"] = 511.88}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 13.13, ["Fly"] = 92.11, ["Ride"] = 42.71, ["Fly|Ride"] = 91.67, ["Neon"] = 79.17, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 84.69, ["Neon|Fly|Ride"] = 208.55, ["Mega"] = 262.5, ["Mega|Ride"] = 346.13, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 69.57, ["Fly"] = 139.57, ["Ride"] = 103.69, ["Fly|Ride"] = 347.88, ["Neon"] = 278.1, ["Neon|Ride"] = 452.03, ["Mega|Fly|Ride"] = 1807.97}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 20.98, ["Ride"] = 53.12, ["Fly|Ride"] = 148.03, ["Neon"] = 72.19, ["Neon|Ride"] = 93.18, ["Neon|Fly|Ride"] = 551.25, ["Mega"] = 378, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 467.25}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 68.22, ["Ride"] = 110.41, ["Fly|Ride"] = 199.5, ["Neon"] = 262.5, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 308.39, ["Mega"] = 2001.61, ["Mega|Ride"] = 1085.27, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 26.23, ["Ride"] = 48.27, ["Fly|Ride"] = 116.82, ["Neon"] = 102.38, ["Neon|Fly"] = 249.38, ["Neon|Ride"] = 139.57, ["Neon|Fly|Ride"] = 209.77, ["Mega"] = 320.11, ["Mega|Ride"] = 358.21, ["Mega|Fly|Ride"] = 534.85}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 4.12, ["Fly"] = 52.5, ["Ride"] = 27.09, ["Fly|Ride"] = 105, ["Neon"] = 48.97, ["Neon|Ride"] = 93.35, ["Neon|Fly|Ride"] = 98.02, ["Mega"] = 328.02, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 23.62, ["Fly"] = 111.57, ["Ride"] = 104.16, ["Fly|Ride"] = 177.07, ["Neon"] = 104.99, ["Neon|Ride"] = 144.79, ["Neon|Fly|Ride"] = 207.26, ["Mega"] = 230.21, ["Mega|Ride"] = 346.52, ["Mega|Fly|Ride"] = 611.1}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 14.43, ["Ride"] = 50.02, ["Fly|Ride"] = 104.87, ["Neon"] = 34.63, ["Neon|Fly"] = 111.45, ["Neon|Ride"] = 81.94, ["Neon|Fly|Ride"] = 264.24, ["Mega"] = 250.25, ["Mega|Ride"] = 566.98, ["Mega|Fly|Ride"] = 377.53}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 69.79, ["Neon|Ride"] = 26.25, ["Mega"] = 30.19, ["Mega|Fly"] = 139.73, ["Mega|Ride"] = 66.94, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 3.94, ["Ride"] = 104.16, ["Neon"] = 15.74, ["Neon|Ride"] = 32.82, ["Mega"] = 99.62, ["Mega|Ride"] = 156.41, ["Mega|Fly|Ride"] = 216.89}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Neon"] = 22.23, ["Neon|Ride"] = 103.69, ["Mega"] = 336}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 2.1, ["Ride"] = 31.26, ["Fly|Ride"] = 115.4, ["Neon"] = 18.38, ["Neon|Ride"] = 83.34, ["Neon|Fly|Ride"] = 277.36, ["Mega"] = 123.38, ["Mega|Ride"] = 375.37, ["Mega|Fly|Ride"] = 508.6}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 525, ["Ride"] = 559.13, ["Fly|Ride"] = 609, ["Neon"] = 1666.41, ["Neon|Ride"] = 1764.31, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 5878.95}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 7.87, ["Fly"] = 56.25, ["Ride"] = 28.13, ["Fly|Ride"] = 71.55, ["Neon|Ride"] = 83.34, ["Mega"] = 297.99, ["Mega|Ride"] = 278.4}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 11.82, ["Fly"] = 31.5, ["Neon"] = 52.08, ["Neon|Fly"] = 315, ["Neon|Ride"] = 140.54, ["Neon|Fly|Ride"] = 105, ["Mega"] = 307.59, ["Mega|Ride"] = 329.48, ["Mega|Fly|Ride"] = 462.04}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 3.68, ["Fly"] = 28.13, ["Ride"] = 23.21, ["Fly|Ride"] = 312.46, ["Neon|Ride"] = 86.56, ["Mega"] = 223.13, ["Mega|Ride"] = 354.38, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 42.45, ["Neon"] = 7.62, ["Neon|Ride"] = 41.68, ["Neon|Fly|Ride"] = 130.35, ["Mega"] = 59.05, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 233.63}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Ride"] = 69.51, ["Neon"] = 3.03, ["Neon|Ride"] = 57.7, ["Neon|Fly|Ride"] = 115.52, ["Mega"] = 23.63, ["Mega|Fly|Ride"] = 208.31}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1225.88}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 7.86, ["Fly"] = 56.25, ["Ride"] = 41.27, ["Fly|Ride"] = 123.46, ["Neon"] = 139.12, ["Neon|Fly"] = 139.57, ["Neon|Ride"] = 146.89, ["Mega"] = 494.34, ["Mega|Ride"] = 462.02, ["Mega|Fly|Ride"] = 709.02}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 45.36, ["Neon"] = 10.5, ["Neon|Ride"] = 73.86, ["Mega"] = 54.17, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 231.03}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.1, ["Fly"] = 41.68, ["Ride"] = 19.69, ["Fly|Ride"] = 525, ["Neon"] = 10.5, ["Neon|Ride"] = 69.79, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 145.99, ["Mega|Ride"] = 154.88, ["Mega|Fly|Ride"] = 199.16}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 437.43, ["Fly"] = 459.38, ["Ride"] = 395.82, ["Fly|Ride"] = 521.07, ["Neon|Ride"] = 1509.38, ["Neon|Fly|Ride"] = 1671.29, ["Mega|Fly|Ride"] = 7646.8}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 9.49, ["Fly"] = 196.88, ["Ride"] = 72.19, ["Neon"] = 57.75, ["Neon|Ride"] = 131.25, ["Mega"] = 399, ["Mega|Ride"] = 494.34, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Neon"] = 5.24, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 93.19, ["Mega"] = 38.06, ["Mega|Fly"] = 154.79, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 197.06}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 3.81, ["Neon|Ride"] = 59.07, ["Mega"] = 23.13, ["Mega|Ride"] = 83.18, ["Mega|Fly|Ride"] = 199.5}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 10.48, ["Fly"] = 78.12, ["Ride"] = 39.38, ["Fly|Ride"] = 69.79, ["Neon"] = 41.68, ["Neon|Ride"] = 139.73, ["Neon|Fly|Ride"] = 308.63, ["Mega"] = 328.13, ["Mega|Ride"] = 195.55, ["Mega|Fly|Ride"] = 361.81}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 10.5, ["Ride"] = 139.57, ["Fly|Ride"] = 131.25, ["Neon"] = 92.32, ["Neon|Ride"] = 56.25, ["Neon|Fly|Ride"] = 834.14, ["Mega"] = 1251.2, ["Mega|Ride"] = 462.02, ["Mega|Fly|Ride"] = 1066.42}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 3.92, ["Fly|Ride"] = 39.38, ["Neon"] = 278.09, ["Neon|Ride"] = 207.27, ["Mega"] = 582.75, ["Mega|Ride"] = 407.06, ["Mega|Fly|Ride"] = 542.19}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 12.71, ["Ride"] = 64.59, ["Neon|Ride"] = 131.56, ["Neon|Fly|Ride"] = 770.39, ["Mega"] = 1443.75, ["Mega|Ride"] = 486.93, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 347.82, ["Ride"] = 459.32, ["Fly|Ride"] = 602, ["Neon"] = 2916.21, ["Neon|Ride"] = 1111.29, ["Neon|Fly|Ride"] = 1042.67, ["Mega|Fly|Ride"] = 3150}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 5.25, ["Ride"] = 44.63, ["Fly|Ride"] = 81.94, ["Neon"] = 49.88, ["Neon|Ride"] = 97.92, ["Neon|Fly|Ride"] = 139.57, ["Mega"] = 529.78, ["Mega|Ride"] = 495.28, ["Mega|Fly|Ride"] = 695.46}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 3.92, ["Ride"] = 91.88, ["Fly|Ride"] = 154.16, ["Mega"] = 1251.2, ["Mega|Fly|Ride"] = 556.79}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 10.39, ["Ride"] = 48.97, ["Fly|Ride"] = 162.75, ["Neon"] = 19.69, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 168, ["Mega"] = 170.63, ["Mega|Ride"] = 202.1, ["Mega|Fly|Ride"] = 357.65}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.1, ["Ride"] = 31.49, ["Fly|Ride"] = 107.28, ["Neon"] = 9.24, ["Neon|Ride"] = 41.19, ["Mega"] = 39.37, ["Mega|Ride"] = 83.43, ["Mega|Fly|Ride"] = 154.79}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 40.68, ["Ride"] = 70.88, ["Neon"] = 229.69, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 462.02, ["Mega"] = 1112.51, ["Mega|Ride"] = 1028.06, ["Mega|Fly|Ride"] = 1066.65}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 576.91, ["Ride"] = 30.22, ["Fly|Ride"] = 65.63, ["Neon"] = 12.6, ["Neon|Fly"] = 181.23, ["Neon|Ride"] = 54.55, ["Mega"] = 80.07, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 287.78}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 27.57, ["Ride"] = 83.34, ["Fly|Ride"] = 148.25, ["Neon"] = 3.93, ["Neon|Ride"] = 41.68, ["Neon|Fly|Ride"] = 139.73, ["Mega"] = 52.06, ["Mega|Fly|Ride"] = 198.85}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Fly"] = 1519.88, ["Ride"] = 24.94, ["Fly|Ride"] = 262.5, ["Neon"] = 11.48, ["Neon|Ride"] = 60.42, ["Neon|Fly|Ride"] = 295.32, ["Mega"] = 117.71, ["Mega|Ride"] = 189.25, ["Mega|Fly|Ride"] = 201}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 64.32, ["Fly"] = 91.67, ["Ride"] = 68.75, ["Fly|Ride"] = 154.62, ["Neon"] = 307.26, ["Neon|Ride"] = 322.88, ["Neon|Fly|Ride"] = 692.35, ["Mega|Fly|Ride"] = 901.69}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 262.5, ["Ride"] = 326.82, ["Fly|Ride"] = 438.45, ["Neon|Ride"] = 1099.88, ["Neon|Fly|Ride"] = 1330.43, ["Mega"] = 6951.34, ["Mega|Fly|Ride"] = 5620.92}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 3.94, ["Ride"] = 28.13, ["Neon"] = 30.19, ["Mega"] = 122.07, ["Mega|Ride"] = 175.19, ["Mega|Fly|Ride"] = 361.81}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 6.25, ["Neon"] = 12.71, ["Neon|Ride"] = 139.57, ["Mega"] = 70.88, ["Mega|Fly|Ride"] = 462.04}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 2.6, ["Fly"] = 155.57, ["Neon"] = 131.24, ["Mega"] = 488.92}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 53.23, ["Ride"] = 34.13, ["Neon"] = 6.57, ["Neon|Ride"] = 27.43, ["Neon|Fly|Ride"] = 181.43, ["Mega"] = 66.68, ["Mega|Ride"] = 86.56, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 68.75, ["Neon"] = 8.35, ["Mega"] = 43.81, ["Mega|Ride"] = 206.07}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 65.54, ["Ride"] = 21.94, ["Fly|Ride"] = 46.17, ["Neon"] = 5.24, ["Neon|Ride"] = 43.85, ["Neon|Fly|Ride"] = 105, ["Mega"] = 56.32, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 278.4}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 27.71, ["Fly|Ride"] = 60.38, ["Neon"] = 3.94, ["Neon|Fly"] = 97.92, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 85.4, ["Mega"] = 170.63, ["Mega|Ride"] = 195, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 32.8, ["Fly"] = 99.24, ["Ride"] = 70.88, ["Fly|Ride"] = 278.1, ["Neon"] = 114.19, ["Neon|Ride"] = 147, ["Mega"] = 367.5, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 500.49}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 62.34, ["Fly"] = 582.75, ["Ride"] = 98.44, ["Fly|Ride"] = 160.4, ["Neon"] = 416.61, ["Neon|Ride"] = 391.13, ["Mega"] = 3080.37, ["Mega|Ride"] = 1739.15, ["Mega|Fly|Ride"] = 1590.07}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 33.35, ["Fly|Ride"] = 131.25, ["Neon"] = 2.1, ["Neon|Ride"] = 56.25, ["Neon|Fly|Ride"] = 359.63, ["Mega"] = 38.74, ["Mega|Ride"] = 86.56, ["Mega|Fly|Ride"] = 247.2}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 23.97, ["Ride"] = 19.67, ["Fly|Ride"] = 53.09, ["Neon"] = 3.92, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 24.86, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 38.06, ["Mega|Fly"] = 157.5, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 3.92, ["Ride"] = 41.68, ["Neon"] = 91.17, ["Neon|Ride"] = 68.75, ["Neon|Fly|Ride"] = 277.36, ["Mega"] = 611, ["Mega|Ride"] = 625.61, ["Mega|Fly|Ride"] = 471.19}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 251.74, ["Ride"] = 262.47, ["Fly|Ride"] = 370.78, ["Neon"] = 972.77, ["Neon|Ride"] = 1458.12, ["Mega|Fly|Ride"] = 5236.98}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 22.32, ["Fly"] = 209.9, ["Ride"] = 59.07, ["Fly|Ride"] = 165.62, ["Neon"] = 278.1, ["Neon|Ride"] = 237.41, ["Neon|Fly|Ride"] = 432.5, ["Mega"] = 918.59, ["Mega|Ride"] = 792.43, ["Mega|Fly|Ride"] = 813.75}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 31.48, ["Fly|Ride"] = 97.92, ["Neon"] = 15.64, ["Neon|Ride"] = 48.97, ["Neon|Fly|Ride"] = 98.02, ["Mega"] = 101.07, ["Mega|Ride"] = 137.29, ["Mega|Fly|Ride"] = 209.73}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 208.31, ["Ride"] = 83.34, ["Fly|Ride"] = 142.7, ["Neon"] = 17.33, ["Neon|Ride"] = 166.66, ["Mega"] = 211.32, ["Mega|Ride"] = 431.99}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 21, ["Fly"] = 254.14, ["Ride"] = 39.38, ["Fly|Ride"] = 59.07, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 2502.38, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 1033.28}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 78.75, ["Ride"] = 104.16, ["Fly|Ride"] = 416.61, ["Neon"] = 345.19, ["Neon|Ride"] = 469.88, ["Neon|Fly|Ride"] = 610.32, ["Mega"] = 3059.14, ["Mega|Fly|Ride"] = 1848.09}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 217.88, ["Fly"] = 495.77, ["Ride"] = 311.42, ["Fly|Ride"] = 378, ["Neon"] = 1021.73, ["Neon|Ride"] = 986.31, ["Neon|Fly|Ride"] = 918.75, ["Mega|Fly|Ride"] = 3059.14}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 13.11, ["Ride"] = 41.97, ["Fly|Ride"] = 206.22, ["Neon"] = 13.13, ["Neon|Ride"] = 109.72, ["Mega"] = 421.32, ["Mega|Ride"] = 380.62, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 16.94, ["Fly|Ride"] = 47.25, ["Neon"] = 15.63, ["Neon|Ride"] = 31.26, ["Neon|Fly|Ride"] = 75.09, ["Mega"] = 157.1, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 2.1, ["Ride"] = 20.85, ["Fly|Ride"] = 52.11, ["Neon"] = 31.5, ["Neon|Ride"] = 41.3, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 250.79, ["Mega|Ride"] = 241.5, ["Mega|Fly|Ride"] = 388.01}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 255.94, ["Ride"] = 393.75, ["Fly|Ride"] = 1207.5, ["Neon|Fly|Ride"] = 1668.26}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 45.85, ["Neon"] = 11.55, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 32.82, ["Mega|Ride"] = 156.41, ["Mega|Fly|Ride"] = 293.4}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 4.87, ["Ride"] = 19.69, ["Fly|Ride"] = 69.79, ["Neon"] = 19.17, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 110.25, ["Mega"] = 346.52, ["Mega|Ride"] = 278.4, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 15.74, ["Ride"] = 97.92, ["Neon"] = 103.69, ["Neon|Fly|Ride"] = 533.85, ["Mega"] = 516.13, ["Mega|Ride"] = 451.5, ["Mega|Fly|Ride"] = 514.5}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 111.57, ["Fly"] = 277.06, ["Ride"] = 112.22, ["Fly|Ride"] = 131.54, ["Neon|Ride"] = 563.07, ["Neon|Fly|Ride"] = 525.51, ["Mega|Fly|Ride"] = 1696.41}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 24.12, ["Fly"] = 80.78, ["Ride"] = 34.75, ["Fly|Ride"] = 60.42, ["Neon"] = 56.25, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 695.46, ["Mega|Ride"] = 417.08, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 56.25, ["Neon"] = 2.1, ["Neon|Ride"] = 47.93, ["Neon|Fly|Ride"] = 139.73, ["Mega"] = 21, ["Mega|Ride"] = 166.84, ["Mega|Fly|Ride"] = 417.08}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Ride"] = 34.13, ["Fly|Ride"] = 52.5, ["Neon"] = 2.61, ["Neon|Fly"] = 31.16, ["Neon|Ride"] = 28.13, ["Neon|Fly|Ride"] = 69.18, ["Mega"] = 22.32, ["Mega|Ride"] = 68.82, ["Mega|Fly|Ride"] = 123.05}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 7.86, ["Ride"] = 74.8, ["Fly|Ride"] = 165.37, ["Neon"] = 31.13, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 222.16, ["Mega"] = 154.88, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 291.38}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1433.25, ["Ride"] = 1266.57, ["Fly|Ride"] = 1312.5, ["Neon"] = 5207.49, ["Neon|Fly|Ride"] = 4727.39, ["Mega|Fly|Ride"] = 13648.69}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 539.44, ["Ride"] = 624.91, ["Fly|Ride"] = 832.17, ["Neon|Ride"] = 2462.16, ["Neon|Fly|Ride"] = 2362.5, ["Mega"] = 13859.87, ["Mega|Fly|Ride"] = 6495.57}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 309.75, ["Fly"] = 556.17, ["Ride"] = 350.44, ["Fly|Ride"] = 524.93, ["Neon"] = 682.5, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 616.77, ["Mega|Fly|Ride"] = 2402.23}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 338.63, ["Fly"] = 416.61, ["Ride"] = 374.07, ["Fly|Ride"] = 435.74, ["Neon"] = 945, ["Neon|Fly"] = 1111.29, ["Neon|Ride"] = 932.15, ["Neon|Fly|Ride"] = 1086.75, ["Mega|Ride"] = 3675, ["Mega|Fly|Ride"] = 2989.28}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 79.17, ["Ride"] = 19.79, ["Fly|Ride"] = 44.62, ["Neon"] = 6.57, ["Neon|Ride"] = 29.93, ["Neon|Fly|Ride"] = 145.55, ["Mega"] = 83.68, ["Mega|Ride"] = 112.88, ["Mega|Fly|Ride"] = 144.37}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 353.08, ["Fly"] = 590.62, ["Ride"] = 362.3, ["Fly|Ride"] = 393.75, ["Neon"] = 932.15, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 1048.69, ["Mega"] = 8202.52, ["Mega|Ride"] = 3937.5, ["Mega|Fly|Ride"] = 3474.19}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 2.1, ["Fly"] = 183.75, ["Ride"] = 139.57, ["Neon"] = 11.82, ["Neon|Ride"] = 53.59, ["Neon|Fly|Ride"] = 112.72, ["Mega"] = 67.95, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 272.35}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 20.84, ["Fly|Ride"] = 41.68, ["Neon"] = 11.55, ["Neon|Ride"] = 61.69, ["Neon|Fly|Ride"] = 110.25, ["Mega"] = 65.51, ["Mega|Ride"] = 136.47, ["Mega|Fly|Ride"] = 202.13}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Neon"] = 3.92, ["Mega"] = 23.63, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 60.38, ["Ride"] = 65.63, ["Fly|Ride"] = 459.38, ["Neon"] = 244.13, ["Neon|Ride"] = 308.06, ["Mega"] = 2085.32, ["Mega|Ride"] = 897.75, ["Mega|Fly|Ride"] = 972.57}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 65.61, ["Ride"] = 19.3, ["Neon"] = 28.13, ["Mega"] = 328.13, ["Mega|Ride"] = 314.89}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 53.82, ["Neon"] = 3.29, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 19.69, ["Mega|Fly"] = 123.6, ["Mega|Ride"] = 104.19, ["Mega|Fly|Ride"] = 308.44}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 22.93, ["Fly|Ride"] = 53.09, ["Neon"] = 6.54, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 27.23, ["Neon|Fly|Ride"] = 95.81, ["Mega"] = 102.26, ["Mega|Fly"] = 231.02, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 169.78}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 5.18, ["Fly"] = 16.77, ["Ride"] = 53.72, ["Fly|Ride"] = 55.26, ["Neon"] = 97.92, ["Neon|Fly"] = 39.24, ["Neon|Ride"] = 139.6, ["Neon|Fly|Ride"] = 250.25, ["Mega"] = 237.57, ["Mega|Fly|Ride"] = 1019.82}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 15.75, ["Ride"] = 27.57, ["Neon"] = 43.76, ["Mega"] = 462.02, ["Mega|Ride"] = 331.57, ["Mega|Fly|Ride"] = 516.13}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.1, ["Ride"] = 52.12, ["Fly|Ride"] = 87.94, ["Neon"] = 20.85, ["Neon|Ride"] = 154.62, ["Neon|Fly|Ride"] = 693, ["Mega"] = 275.27, ["Mega|Ride"] = 462.02, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 32.3, ["Ride"] = 19.8, ["Fly|Ride"] = 83.34, ["Neon"] = 2.1, ["Neon|Ride"] = 28.13, ["Neon|Fly|Ride"] = 166.84, ["Mega"] = 39.38, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 312.81}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 208.68, ["Fly"] = 291.63, ["Ride"] = 223.13, ["Fly|Ride"] = 275.63, ["Neon"] = 1153.79, ["Neon|Fly"] = 1319.59, ["Neon|Ride"] = 1145.66, ["Neon|Fly|Ride"] = 1209.49, ["Mega"] = 8341.19, ["Mega|Fly|Ride"] = 3852.09}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 19.69, ["Fly|Ride"] = 43.76, ["Neon"] = 3.89, ["Neon|Ride"] = 24.92, ["Neon|Fly|Ride"] = 61.53, ["Mega"] = 41.72, ["Mega|Ride"] = 41.67, ["Mega|Fly|Ride"] = 111.57}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 12.71, ["Fly"] = 139.57, ["Ride"] = 98.44, ["Fly|Ride"] = 105, ["Neon"] = 78.75, ["Neon|Fly|Ride"] = 340.74, ["Mega"] = 308.39, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 461.63}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 36.75, ["Ride"] = 108.47, ["Neon"] = 154.88, ["Neon|Ride"] = 306.92, ["Mega"] = 746.54, ["Mega|Ride"] = 791.38, ["Mega|Fly|Ride"] = 1016.94}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 168, ["Fly"] = 262.5, ["Ride"] = 223.13, ["Fly|Ride"] = 245.1, ["Neon"] = 775.69, ["Neon|Ride"] = 742.88, ["Neon|Fly|Ride"] = 866.25, ["Mega|Fly|Ride"] = 3386.54}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 21, ["Neon"] = 100.01, ["Mega"] = 415.42, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 695.46}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 27.55, ["Ride"] = 261.19, ["Fly|Ride"] = 111.45, ["Neon"] = 205.57, ["Neon|Ride"] = 311.42, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 695.46, ["Mega|Ride"] = 833.09, ["Mega|Fly|Ride"] = 2085.32}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 1147.82, ["Fly"] = 1441.13, ["Ride"] = 1050, ["Fly|Ride"] = 1148.43, ["Neon|Ride"] = 4384.34, ["Neon|Fly|Ride"] = 4315.5, ["Mega|Fly|Ride"] = 20158.56}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 5.84, ["Fly"] = 35.42, ["Ride"] = 21.6, ["Fly|Ride"] = 62.35, ["Neon"] = 77.32, ["Neon|Fly"] = 111.57, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 105, ["Mega"] = 131.23, ["Mega|Fly"] = 556.79, ["Mega|Ride"] = 265.89, ["Mega|Fly|Ride"] = 340.75}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 5.07, ["Fly"] = 13747.76, ["Ride"] = 39.38, ["Neon"] = 41.55, ["Neon|Ride"] = 164.57, ["Neon|Fly|Ride"] = 144.74, ["Mega"] = 212.63, ["Mega|Ride"] = 217.88, ["Mega|Fly|Ride"] = 417.08}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Ride"] = 26.24, ["Fly|Ride"] = 90.62, ["Neon"] = 15.74, ["Neon|Ride"] = 77.32, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 162.75, ["Mega|Ride"] = 250.25, ["Mega|Fly|Ride"] = 695.46}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 17.04, ["Ride"] = 40.68, ["Fly|Ride"] = 65.63, ["Neon"] = 65.63, ["Neon|Ride"] = 108.47, ["Neon|Fly|Ride"] = 203.33, ["Mega"] = 354.38, ["Mega|Ride"] = 374.07, ["Mega|Fly|Ride"] = 526.23}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 2.1, ["Fly"] = 22.32, ["Ride"] = 19.69, ["Fly|Ride"] = 41.68, ["Neon"] = 22.32, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 62.57, ["Mega|Ride"] = 362.25, ["Mega|Fly|Ride"] = 222.08}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 3.54, ["Ride"] = 13.13, ["Neon"] = 17.33, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 50.02, ["Mega"] = 111.56, ["Mega|Ride"] = 187.52, ["Mega|Fly|Ride"] = 348.27}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 139.13, ["Ride"] = 139.57, ["Fly|Ride"] = 486.39, ["Neon"] = 840, ["Neon|Ride"] = 1693.13, ["Neon|Fly|Ride"] = 1386, ["Mega|Fly|Ride"] = 3711.84}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.61, ["Ride"] = 25.39, ["Fly|Ride"] = 77.09, ["Neon"] = 6.18, ["Neon|Fly"] = 77.32, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 125.13, ["Mega"] = 105, ["Mega|Ride"] = 146.46, ["Mega|Fly|Ride"] = 208.55}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 15.59, ["Neon"] = 77.42, ["Mega"] = 249.38, ["Mega|Ride"] = 304.56}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 2.1, ["Fly"] = 58.07, ["Ride"] = 40.69, ["Neon"] = 11.82, ["Neon|Ride"] = 25.02, ["Mega"] = 145.69, ["Mega|Ride"] = 166.04, ["Mega|Fly|Ride"] = 347.17}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 131.24, ["Fly"] = 262.5, ["Ride"] = 228.38, ["Fly|Ride"] = 681.15, ["Neon"] = 459.38, ["Neon|Ride"] = 619.5, ["Neon|Fly|Ride"] = 625.61, ["Mega"] = 3545.01, ["Mega|Ride"] = 2481.52, ["Mega|Fly|Ride"] = 1785}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 26.25, ["Ride"] = 56.25, ["Fly|Ride"] = 520.77, ["Neon"] = 117.71, ["Neon|Ride"] = 137.49, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 604.75, ["Mega|Ride"] = 661.5, ["Mega|Fly|Ride"] = 663.14}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 24.94, ["Ride"] = 39.38, ["Fly|Ride"] = 437.07, ["Neon"] = 109.87, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 624.02, ["Mega|Ride"] = 489.86, ["Mega|Fly|Ride"] = 705.11}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 83.34, ["Neon"] = 5.25, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 41.72, ["Mega"] = 35.44, ["Mega|Ride"] = 74.82, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 91.88, ["Fly"] = 137.69, ["Ride"] = 129.94, ["Fly|Ride"] = 211.78, ["Neon"] = 328.13, ["Neon|Ride"] = 361.31, ["Neon|Fly|Ride"] = 446.25, ["Mega|Fly|Ride"] = 917.44}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 20.84, ["Neon"] = 4.6, ["Neon|Fly|Ride"] = 588, ["Mega"] = 69.87}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 30.17, ["Fly"] = 139.57, ["Ride"] = 39.58, ["Fly|Ride"] = 108.47, ["Neon"] = 97.92, ["Neon|Ride"] = 104.2, ["Neon|Fly|Ride"] = 112.88, ["Mega"] = 396.22, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 386.84}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 49.88, ["Ride"] = 91.88, ["Fly|Ride"] = 157.5, ["Neon"] = 240, ["Neon|Ride"] = 369.23, ["Neon|Fly|Ride"] = 446.27, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 15.73, ["Fly|Ride"] = 47.25, ["Neon"] = 2.63, ["Neon|Fly"] = 27.72, ["Neon|Ride"] = 27.09, ["Neon|Fly|Ride"] = 47.97, ["Mega"] = 32.33, ["Mega|Ride"] = 45.09, ["Mega|Fly|Ride"] = 103.94}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 3.92, ["Ride"] = 37.51, ["Fly|Ride"] = 98.65, ["Neon"] = 35.79, ["Neon|Ride"] = 95.88, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 157.5, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 515.17}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 17.04, ["Ride"] = 55.9, ["Neon"] = 208.31, ["Neon|Ride"] = 308.06, ["Neon|Fly|Ride"] = 616.77, ["Mega"] = 667.31, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 22.93, ["Neon"] = 2.1, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 125.13, ["Mega"] = 20.84, ["Mega|Ride"] = 137.64, ["Mega|Fly|Ride"] = 410.17}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 2.63, ["Fly"] = 210, ["Ride"] = 31.16, ["Fly|Ride"] = 98.44, ["Neon"] = 40.69, ["Neon|Ride"] = 111.45, ["Neon|Fly|Ride"] = 181.43, ["Mega"] = 111.58, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 373.24}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 19.66, ["Fly"] = 41.68, ["Ride"] = 28.13, ["Fly|Ride"] = 62.31, ["Neon"] = 139.57, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 695.46, ["Mega|Fly|Ride"] = 467.12}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 3.89, ["Ride"] = 52.55, ["Neon"] = 20.84, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 200.82, ["Mega"] = 169.32, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 291.96}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 17.33, ["Fly"] = 2083.01, ["Neon"] = 139.57, ["Neon|Ride"] = 493.83, ["Neon|Fly|Ride"] = 6159.57, ["Mega"] = 485.63, ["Mega|Ride"] = 517.17, ["Mega|Fly|Ride"] = 662.82}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Ride"] = 41.68, ["Fly|Ride"] = 126.48, ["Neon"] = 3.94, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 69.87, ["Mega"] = 70.52, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 408.19, ["Mega|Fly|Ride"] = 288.74}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 28.13, ["Neon"] = 3.93, ["Neon|Fly|Ride"] = 104.28, ["Mega"] = 28.88, ["Mega|Ride"] = 131.38, ["Mega|Fly|Ride"] = 417.08}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 31.5}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 56.44, ["Fly"] = 91.67, ["Ride"] = 78.73, ["Fly|Ride"] = 203.11, ["Neon"] = 154.16, ["Neon|Fly|Ride"] = 1042.67, ["Mega"] = 973.85, ["Mega|Ride"] = 971.76, ["Mega|Fly|Ride"] = 889.88}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Ride"] = 84, ["Fly|Ride"] = 139.57, ["Neon"] = 3.78, ["Neon|Ride"] = 26.55, ["Mega"] = 25.04, ["Mega|Ride"] = 104.16, ["Mega|Fly|Ride"] = 139.73}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 666.58, ["Ride"] = 761.25, ["Fly|Ride"] = 656.25, ["Neon"] = 4166, ["Neon|Ride"] = 3150, ["Neon|Fly|Ride"] = 2363.7, ["Mega"] = 16682.37, ["Mega|Fly|Ride"] = 10426.48}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 40.94, ["Fly|Ride"] = 54.24, ["Neon|Fly|Ride"] = 556.79, ["Mega|Fly|Ride"] = 556.79}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 3.42, ["Ride"] = 21.18, ["Fly|Ride"] = 83.34, ["Neon"] = 28.13, ["Neon|Ride"] = 35.48, ["Neon|Fly|Ride"] = 86.56, ["Mega"] = 166.84, ["Mega|Ride"] = 174.57, ["Mega|Fly|Ride"] = 330.75}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 16.86, ["Ride"] = 48.97, ["Fly|Ride"] = 106.32, ["Neon"] = 94.5, ["Neon|Ride"] = 247.9, ["Mega"] = 1030.15, ["Mega|Ride"] = 516.13, ["Mega|Fly|Ride"] = 1250.15}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 2.63, ["Fly"] = 39.38, ["Ride"] = 31.5, ["Fly|Ride"] = 393.75, ["Neon"] = 139.57, ["Mega"] = 291.96, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 11.69, ["Ride"] = 30.19, ["Fly|Ride"] = 69.78, ["Neon"] = 93.19, ["Neon|Ride"] = 174.99, ["Neon|Fly|Ride"] = 350.44, ["Mega"] = 414.58, ["Mega|Ride"] = 486.93, ["Mega|Fly|Ride"] = 452.82}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 7.87, ["Fly"] = 105, ["Ride"] = 35.42, ["Fly|Ride"] = 131.25, ["Neon"] = 15.64, ["Neon|Ride"] = 91.67, ["Neon|Fly|Ride"] = 184.82, ["Mega"] = 236.7, ["Mega|Ride"] = 403.52, ["Mega|Fly|Ride"] = 278.4}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 46.17, ["Ride"] = 18.76, ["Fly|Ride"] = 75.01, ["Neon"] = 2.1, ["Neon|Fly"] = 28.46, ["Neon|Ride"] = 20.85, ["Neon|Fly|Ride"] = 60.1, ["Mega"] = 15.64, ["Mega|Fly"] = 77.4, ["Mega|Ride"] = 46.23, ["Mega|Fly|Ride"] = 77.44}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 7.44, ["Ride"] = 31.16, ["Fly|Ride"] = 157.94, ["Neon"] = 44.63, ["Neon|Fly"] = 385.38, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 231.02, ["Mega"] = 139.73, ["Mega|Ride"] = 174.57, ["Mega|Fly|Ride"] = 250.25}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 259.88, ["Ride"] = 285.53, ["Fly|Ride"] = 367.5, ["Neon"] = 1480.5, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 4081.88}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 114.18, ["Ride"] = 124.69, ["Fly|Ride"] = 249.98, ["Neon"] = 437.43, ["Neon|Ride"] = 833.21, ["Neon|Fly|Ride"] = 698.25, ["Mega"] = 4170.6, ["Mega|Ride"] = 1981.05, ["Mega|Fly|Ride"] = 2042.88}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 24.94, ["Fly|Ride"] = 38.06, ["Neon"] = 11.82, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 56.26, ["Mega"] = 139.73, ["Mega|Fly"] = 207.51, ["Mega|Ride"] = 90.61, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 18.75, ["Ride"] = 15.94, ["Fly|Ride"] = 36.6, ["Neon"] = 11.47, ["Neon|Fly"] = 28.13, ["Neon|Ride"] = 23.09, ["Neon|Fly|Ride"] = 70.88, ["Mega"] = 125.13, ["Mega|Ride"] = 103.69, ["Mega|Fly|Ride"] = 138.44}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.1, ["Ride"] = 18.98, ["Fly|Ride"] = 98.44, ["Neon"] = 8.35, ["Mega"] = 139.73}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 329.44, ["Ride"] = 367.5, ["Fly|Ride"] = 416.61, ["Neon|Ride"] = 1776.83, ["Neon|Fly|Ride"] = 1766.81, ["Mega|Ride"] = 8341.19, ["Mega|Fly|Ride"] = 4774.73}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.1, ["Fly"] = 23.99, ["Ride"] = 15.74, ["Fly|Ride"] = 45.73, ["Neon"] = 17.33, ["Neon|Fly"] = 154.62, ["Neon|Ride"] = 56.25, ["Neon|Fly|Ride"] = 78.73, ["Mega"] = 264.85, ["Mega|Ride"] = 125.13, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 5.12, ["Fly"] = 123.46, ["Ride"] = 39.53, ["Fly|Ride"] = 208.31, ["Neon"] = 37.28, ["Neon|Ride"] = 35.44, ["Mega"] = 209.99, ["Mega|Ride"] = 204.75, ["Mega|Fly|Ride"] = 377.71}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 91.88, ["Neon"] = 6.29, ["Neon|Ride"] = 27.6, ["Neon|Fly|Ride"] = 139.73, ["Mega"] = 46.17, ["Mega|Ride"] = 94.5, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 19.52, ["Fly"] = 83.34, ["Ride"] = 31.23, ["Fly|Ride"] = 62.51, ["Neon"] = 78.75, ["Neon|Ride"] = 91.19, ["Neon|Fly|Ride"] = 76.39, ["Mega"] = 571.74, ["Mega|Ride"] = 501.38, ["Mega|Fly|Ride"] = 312.81}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 45.92, ["Ride"] = 82.11, ["Fly|Ride"] = 216.57, ["Neon"] = 131.25, ["Neon|Fly"] = 354.22, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 280.14, ["Mega"] = 471.43, ["Mega|Fly"] = 583.9, ["Mega|Ride"] = 536.81, ["Mega|Fly|Ride"] = 618.45}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 27.03, ["Fly"] = 131.25, ["Ride"] = 59.38, ["Fly|Ride"] = 129.17, ["Neon"] = 131.25, ["Neon|Ride"] = 160.4, ["Neon|Fly|Ride"] = 234.44, ["Mega|Ride"] = 783.12, ["Mega|Fly|Ride"] = 2050.22}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 15.64, ["Ride"] = 71.55, ["Fly|Ride"] = 51.45, ["Neon"] = 2.1, ["Neon|Fly"] = 20.85, ["Neon|Ride"] = 18.75, ["Neon|Fly|Ride"] = 56.32, ["Mega"] = 23.09, ["Mega|Fly"] = 47.97, ["Mega|Ride"] = 68.82, ["Mega|Fly|Ride"] = 115.5}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 208.32, ["Ride"] = 313.48, ["Fly|Ride"] = 313.69, ["Neon|Ride"] = 923.04, ["Neon|Fly|Ride"] = 1317.75, ["Mega|Fly|Ride"] = 3543.75}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 10.49, ["Fly"] = 140.39, ["Ride"] = 39.38, ["Neon"] = 101.07, ["Neon|Ride"] = 156.19, ["Mega"] = 625.61, ["Mega|Ride"] = 556.79, ["Mega|Fly|Ride"] = 516.13}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 24.94, ["Ride"] = 28.13, ["Fly|Ride"] = 39.38, ["Neon"] = 3.94, ["Neon|Ride"] = 31.16, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 61.47, ["Mega|Ride"] = 139.73, ["Mega|Fly|Ride"] = 278.15}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 139.57, ["Ride"] = 18.38, ["Neon"] = 3.68, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 95.71, ["Mega"] = 20.84, ["Mega|Fly"] = 144.38, ["Mega|Ride"] = 6005.94, ["Mega|Fly|Ride"] = 106.97}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 3.93, ["Ride"] = 26.25, ["Fly|Ride"] = 78.12, ["Neon"] = 38.07, ["Neon|Ride"] = 46.17, ["Neon|Fly|Ride"] = 181.43, ["Mega"] = 86.02, ["Mega|Ride"] = 124.98, ["Mega|Fly|Ride"] = 417.08}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 10.5, ["Fly"] = 32.3, ["Ride"] = 36.75, ["Fly|Ride"] = 72.72, ["Neon"] = 43.71, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 108.33, ["Mega"] = 520.3, ["Mega|Ride"] = 347.88, ["Mega|Fly|Ride"] = 419.58}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 10.43, ["Neon"] = 101.07, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 210, ["Mega|Ride"] = 358.05, ["Mega|Fly|Ride"] = 444.19}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 52.08, ["Fly|Ride"] = 62.51, ["Neon"] = 3.66, ["Neon|Ride"] = 46.1, ["Neon|Fly|Ride"] = 93.19, ["Mega"] = 31.18, ["Mega|Ride"] = 139.73, ["Mega|Fly|Ride"] = 127.32}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 11.52, ["Ride"] = 28.13, ["Fly|Ride"] = 93.75, ["Neon"] = 35.42, ["Neon|Fly"] = 102.92, ["Neon|Ride"] = 60.42, ["Neon|Fly|Ride"] = 123.35, ["Mega"] = 143.9, ["Mega|Fly"] = 139.73, ["Mega|Ride"] = 254.16, ["Mega|Fly|Ride"] = 187.69}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 210, ["Neon"] = 8.35, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 154.79, ["Mega"] = 34.1, ["Mega|Ride"] = 97.92, ["Mega|Fly|Ride"] = 616.82}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 40.05, ["Ride"] = 25.02, ["Fly|Ride"] = 68.75, ["Neon"] = 6.56, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 115.75, ["Mega"] = 56.32, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 195.25}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 1077.64, ["Ride"] = 1246.88, ["Fly|Ride"] = 1805.97, ["Neon|Fly|Ride"] = 6617.21, ["Mega|Fly|Ride"] = 15401.38}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 20.77, ["Fly|Ride"] = 43.76, ["Neon|Fly"] = 40.99, ["Neon|Ride"] = 124.68, ["Neon|Fly|Ride"] = 110.4, ["Mega"] = 186.65, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.1, ["Ride"] = 41.68, ["Fly|Ride"] = 59.07, ["Neon"] = 5.25, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 34.61, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 203.43}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 3.93, ["Fly"] = 41.54, ["Ride"] = 18.38, ["Fly|Ride"] = 56.95, ["Neon"] = 35.43, ["Neon|Ride"] = 43.31, ["Neon|Fly|Ride"] = 93, ["Mega|Ride"] = 326.55, ["Mega|Fly|Ride"] = 353.07}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 17.07, ["Fly|Ride"] = 32.82, ["Neon"] = 7.8, ["Neon|Fly"] = 89.24, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 61.47, ["Mega"] = 72.19, ["Mega|Ride"] = 137.64, ["Mega|Fly|Ride"] = 174.09}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 44.79, ["Neon"] = 347.82, ["Neon|Ride"] = 338.63, ["Mega"] = 769.13, ["Mega|Ride"] = 973.85}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 41.68, ["Neon"] = 6.57, ["Neon|Ride"] = 139.57, ["Neon|Fly|Ride"] = 108.59, ["Mega"] = 78.69, ["Mega|Ride"] = 106.4, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.61, ["Fly"] = 73.5, ["Ride"] = 31.16, ["Fly|Ride"] = 65.63, ["Neon"] = 13.13, ["Neon|Fly"] = 145.83, ["Neon|Ride"] = 68.75, ["Neon|Fly|Ride"] = 139.73, ["Mega"] = 308.39, ["Mega|Ride"] = 320.11, ["Mega|Fly|Ride"] = 191.86}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly|Ride"] = 65.49, ["Neon"] = 15.64, ["Neon|Fly"] = 62.31, ["Mega"] = 111.02, ["Mega|Ride"] = 154.79}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 2593.49, ["Ride"] = 23.36, ["Fly|Ride"] = 98.44, ["Neon"] = 6.3, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 36.74, ["Mega|Fly"] = 417.08, ["Mega|Ride"] = 151.32, ["Mega|Fly|Ride"] = 166.84}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 19.67, ["Fly"] = 41.68, ["Ride"] = 28.88, ["Fly|Ride"] = 53.82, ["Neon|Ride"] = 69.87, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 834.14, ["Mega|Ride"] = 516.13, ["Mega|Fly|Ride"] = 465.04}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 787.5, ["Ride"] = 939.49, ["Fly|Ride"] = 969.65, ["Neon"] = 2100, ["Neon|Ride"] = 2139.38, ["Neon|Fly|Ride"] = 2189.13, ["Mega"] = 6951.34, ["Mega|Ride"] = 5643.75, ["Mega|Fly|Ride"] = 5145}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 66.89, ["Ride"] = 17.07, ["Fly|Ride"] = 27.57, ["Neon"] = 5.25, ["Neon|Fly"] = 28.13, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 81.31, ["Mega"] = 36.63, ["Mega|Fly"] = 108.46, ["Mega|Ride"] = 77.4, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 6.57, ["Ride"] = 38.66, ["Neon"] = 56.2, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 333.66, ["Mega"] = 274.32, ["Mega|Ride"] = 278.4, ["Mega|Fly|Ride"] = 441}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 73.5, ["Ride"] = 85.32, ["Fly|Ride"] = 139.57, ["Neon|Ride"] = 415.37, ["Neon|Fly|Ride"] = 728.82, ["Mega"] = 2926.74, ["Mega|Fly|Ride"] = 2231.25}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 43.31, ["Ride"] = 70.32, ["Fly|Ride"] = 301.88, ["Neon"] = 278.09, ["Neon|Ride"] = 177.19, ["Mega"] = 834.14, ["Mega|Ride"] = 727.78, ["Mega|Fly|Ride"] = 903.99}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 15.12, ["Neon"] = 83.34, ["Neon|Ride"] = 392.44, ["Neon|Fly|Ride"] = 223.83, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 459.82}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 52.5, ["Ride"] = 112.35, ["Neon"] = 138.48, ["Neon|Fly"] = 154.62, ["Neon|Ride"] = 354.22, ["Mega"] = 325.33, ["Mega|Ride"] = 242.82, ["Mega|Fly|Ride"] = 432.48}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 37.51, ["Fly"] = 105, ["Ride"] = 315, ["Neon"] = 224.44, ["Neon|Ride"] = 312.46, ["Neon|Fly|Ride"] = 525, ["Mega"] = 721.88, ["Mega|Ride"] = 778.28, ["Mega|Fly|Ride"] = 773.73}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 6.57}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 4.87, ["Fly"] = 39.38, ["Ride"] = 31.16, ["Neon"] = 66.94, ["Neon|Ride"] = 74.8, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 210, ["Mega|Ride"] = 216.57, ["Mega|Fly|Ride"] = 417.08}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 5.43, ["Neon"] = 26.92, ["Mega"] = 861.89, ["Mega|Fly|Ride"] = 938.39}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 70.86, ["Fly"] = 415.57, ["Ride"] = 73.48, ["Fly|Ride"] = 116.81, ["Neon"] = 196.85, ["Neon|Ride"] = 208.22, ["Neon|Fly|Ride"] = 279.88, ["Mega|Ride"] = 681.19, ["Mega|Fly|Ride"] = 784.88}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.52, ["Fly"] = 18.47, ["Ride"] = 17.07, ["Fly|Ride"] = 44.58, ["Neon"] = 27.99, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 93.19, ["Mega"] = 308.39, ["Mega|Ride"] = 137.64, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 7.87, ["Fly"] = 97.92, ["Ride"] = 31.26, ["Fly|Ride"] = 100.69, ["Neon"] = 17.33, ["Neon|Ride"] = 56.25, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 157.5, ["Mega|Fly"] = 301.45, ["Mega|Ride"] = 207.32, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 6.57, ["Neon|Ride"] = 197.31, ["Mega"] = 35.46}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 48.97, ["Ride"] = 73.96, ["Fly|Ride"] = 78.72, ["Neon"] = 126, ["Neon|Ride"] = 382.25, ["Neon|Fly|Ride"] = 278.4, ["Mega"] = 1078.77, ["Mega|Ride"] = 734.08, ["Mega|Fly|Ride"] = 695.46}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Neon"] = 11.47, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 26.25, ["Mega"] = 125.13, ["Mega|Ride"] = 208.55}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 7.87, ["Ride"] = 140.63, ["Neon"] = 66.67, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 291.96, ["Mega"] = 320.11, ["Mega|Ride"] = 417.08, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 23.16, ["Ride"] = 15.75, ["Fly|Ride"] = 56.25, ["Neon"] = 24.93, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 131.24, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 24.94, ["Fly|Ride"] = 49.88, ["Neon"] = 52.5, ["Neon|Fly"] = 83.34, ["Neon|Ride"] = 125, ["Mega"] = 308.39, ["Mega|Ride"] = 416.03, ["Mega|Fly|Ride"] = 325.33}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 2.63, ["Ride"] = 129.17, ["Neon"] = 20.98, ["Neon|Ride"] = 90.62, ["Neon|Fly|Ride"] = 278.4, ["Mega"] = 140.6, ["Mega|Ride"] = 547.98, ["Mega|Fly|Ride"] = 415}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 31.17, ["Fly"] = 118.13, ["Ride"] = 143.07, ["Fly|Ride"] = 131.25, ["Neon"] = 166.66, ["Neon|Ride"] = 207.27, ["Mega"] = 1078.77, ["Mega|Ride"] = 1251.2, ["Mega|Fly|Ride"] = 870.19}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 20.98, ["Ride"] = 249.98, ["Neon"] = 116.82, ["Neon|Fly|Ride"] = 462.02, ["Mega"] = 262.5, ["Mega|Ride"] = 769.13}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 20.79, ["Ride"] = 105, ["Neon"] = 91.62, ["Neon|Ride"] = 393.75, ["Mega"] = 157.5, ["Mega|Ride"] = 1541.93, ["Mega|Fly|Ride"] = 1668.26}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 22.32, ["Ride"] = 105, ["Fly|Ride"] = 422.03, ["Neon"] = 459.32, ["Mega"] = 616.77, ["Mega|Ride"] = 708.75, ["Mega|Fly|Ride"] = 673.95}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 2.1, ["Neon"] = 44.8, ["Mega"] = 249.38, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 28.13, ["Ride"] = 20.77, ["Fly|Ride"] = 50.02, ["Neon"] = 6.56, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 137.82, ["Mega"] = 56.32, ["Mega|Ride"] = 102.2, ["Mega|Fly|Ride"] = 258.56}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 9.19, ["Ride"] = 60.42, ["Fly|Ride"] = 90.62, ["Neon"] = 35.44, ["Neon|Ride"] = 93.14, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 278.15, ["Mega|Ride"] = 485.88}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 32.21, ["Ride"] = 22.93, ["Fly|Ride"] = 55.13, ["Neon"] = 6.18, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 35.44, ["Mega|Ride"] = 97.13, ["Mega|Fly|Ride"] = 138.62}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.59, ["Ride"] = 26.25, ["Fly|Ride"] = 97.92, ["Neon"] = 4.23, ["Neon|Ride"] = 35.42, ["Neon|Fly|Ride"] = 258.6, ["Mega"] = 249.38, ["Mega|Ride"] = 150.94, ["Mega|Fly|Ride"] = 462.04}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.94, ["Ride"] = 31.26, ["Fly|Ride"] = 99.75, ["Neon"] = 62.31, ["Neon|Ride"] = 111.45, ["Mega"] = 417.08, ["Mega|Ride"] = 417.08, ["Mega|Fly|Ride"] = 834.14}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 3.87, ["Fly"] = 41.68, ["Ride"] = 22.42, ["Neon"] = 53.12, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 53.12, ["Neon|Fly|Ride"] = 105, ["Mega"] = 236.7, ["Mega|Fly"] = 187.69, ["Mega|Ride"] = 166.68, ["Mega|Fly|Ride"] = 226.12}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 3.29, ["Fly"] = 34.07, ["Ride"] = 23.09, ["Fly|Ride"] = 56.25, ["Neon"] = 23.63, ["Neon|Ride"] = 81.94, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 166.64, ["Mega|Ride"] = 139.73, ["Mega|Fly|Ride"] = 452.52}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 3.93, ["Ride"] = 60.42, ["Neon"] = 19.67, ["Neon|Fly"] = 118.69, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 208.55, ["Mega"] = 66.68, ["Mega|Ride"] = 305.82, ["Mega|Fly|Ride"] = 230.44}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 8.35, ["Ride"] = 62.51, ["Fly|Ride"] = 166.66, ["Neon"] = 69.8, ["Neon|Ride"] = 125.02, ["Neon|Fly|Ride"] = 486.93, ["Mega"] = 393.75, ["Mega|Fly"] = 656.25, ["Mega|Ride"] = 486.93, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 56.06, ["Ride"] = 87.68, ["Fly|Ride"] = 196.87, ["Neon"] = 283.84, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 304.49, ["Mega"] = 1668.26, ["Mega|Ride"] = 1063.13, ["Mega|Fly|Ride"] = 1200.94}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Ride"] = 41.68, ["Fly|Ride"] = 65.63, ["Neon"] = 2.63, ["Neon|Ride"] = 37.31, ["Mega"] = 30.26, ["Mega|Ride"] = 71.14, ["Mega|Fly|Ride"] = 111.58}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 15.74, ["Ride"] = 131.25, ["Neon"] = 54.17, ["Mega"] = 264.85, ["Mega|Ride"] = 361.81, ["Mega|Fly|Ride"] = 1237.64}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 45.83, ["Fly"] = 105, ["Ride"] = 111.57, ["Neon"] = 769.58, ["Neon|Ride"] = 1111.29, ["Mega|Ride"] = 1092.71, ["Mega|Fly|Ride"] = 1232.38}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 6.99, ["Fly"] = 190.32, ["Ride"] = 38.89, ["Fly|Ride"] = 126, ["Neon"] = 39.38, ["Neon|Ride"] = 59.07, ["Mega"] = 125.58, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 278.4}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 2.1, ["Fly"] = 157.5, ["Ride"] = 62.87, ["Fly|Ride"] = 115.62, ["Neon"] = 3.91, ["Neon|Ride"] = 27.44, ["Mega"] = 72.19, ["Mega|Ride"] = 60.08, ["Mega|Fly|Ride"] = 277.97}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 35.41, ["Ride"] = 20.84, ["Fly|Ride"] = 107.63, ["Neon"] = 15.75, ["Neon|Ride"] = 35.41, ["Neon|Fly|Ride"] = 125.13, ["Mega"] = 203.6, ["Mega|Ride"] = 131.24, ["Mega|Fly|Ride"] = 231}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 22.93, ["Ride"] = 23.63, ["Neon"] = 3.93, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 23.63, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 98.44}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 24.94, ["Fly|Ride"] = 65.7, ["Neon"] = 3.93, ["Neon|Ride"] = 29.27, ["Neon|Fly|Ride"] = 83.35, ["Mega"] = 36.75, ["Mega|Fly"] = 168, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 154.79}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 28.13, ["Neon"] = 2.1, ["Neon|Ride"] = 154.62, ["Mega"] = 31.2, ["Mega|Ride"] = 104.28, ["Mega|Fly|Ride"] = 256.51}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 22.32, ["Ride"] = 157.5, ["Fly|Ride"] = 354.12, ["Neon"] = 34.39, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 625.61, ["Mega"] = 213.94, ["Mega|Ride"] = 293.39, ["Mega|Fly|Ride"] = 1111.48}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 7.88, ["Ride"] = 41.94, ["Fly|Ride"] = 208.31, ["Neon"] = 32.82, ["Neon|Ride"] = 200.76, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 278.4, ["Mega|Ride"] = 396.22, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 9.18, ["Fly"] = 24.13, ["Ride"] = 18.38, ["Fly|Ride"] = 60.42, ["Neon|Fly"] = 123.46, ["Neon|Ride"] = 57.14, ["Neon|Fly|Ride"] = 91.88, ["Mega|Fly|Ride"] = 510.83}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 65.61, ["Ride"] = 91.88, ["Fly|Ride"] = 181.23, ["Neon"] = 412.44, ["Neon|Ride"] = 520.77, ["Mega"] = 3080.37, ["Mega|Fly|Ride"] = 1538.54}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 17.07, ["Fly"] = 72.43, ["Ride"] = 41.55, ["Neon"] = 56.44, ["Neon|Fly"] = 125, ["Mega"] = 613.59, ["Mega|Fly"] = 640.2, ["Mega|Ride"] = 603.75, ["Mega|Fly|Ride"] = 1029.67}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 16.69, ["Ride"] = 22.93, ["Fly|Ride"] = 40.68, ["Neon"] = 3.29, ["Neon|Fly"] = 41.68, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 38.99, ["Mega|Ride"] = 107.63, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 15.42, ["Ride"] = 18.75, ["Fly|Ride"] = 39.59, ["Neon"] = 3.93, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 20.85, ["Neon|Fly|Ride"] = 46.17, ["Mega"] = 38.06, ["Mega|Fly"] = 69.87, ["Mega|Ride"] = 56.32, ["Mega|Fly|Ride"] = 139.73}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 357.32, ["Fly"] = 694.7, ["Ride"] = 399, ["Fly|Ride"] = 551.25, ["Neon|Fly|Ride"] = 1522.5}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 15.64, ["Ride"] = 139.57, ["Neon"] = 105, ["Neon|Fly|Ride"] = 396.22, ["Mega"] = 495.48, ["Mega|Ride"] = 486.93, ["Mega|Fly|Ride"] = 348.27}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 28.13, ["Ride"] = 16.42, ["Fly|Ride"] = 35.79, ["Neon"] = 6.3, ["Neon|Ride"] = 20.84, ["Neon|Fly|Ride"] = 68.72, ["Mega"] = 154.62, ["Mega|Ride"] = 71.63, ["Mega|Fly|Ride"] = 104.28}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 65.63, ["Ride"] = 111.45, ["Fly|Ride"] = 154.16, ["Neon"] = 223.12, ["Neon|Ride"] = 288.75, ["Neon|Fly|Ride"] = 492.19, ["Mega"] = 1042.67, ["Mega|Ride"] = 945, ["Mega|Fly|Ride"] = 1095.84}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 44.8, ["Ride"] = 20.77, ["Fly|Ride"] = 27.56, ["Neon"] = 17.05, ["Neon|Fly"] = 77.85, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 118.13, ["Mega|Ride"] = 115.27, ["Mega|Fly|Ride"] = 248.07}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Fly|Ride"] = 1312.5, ["Neon"] = 2.63, ["Neon|Ride"] = 41.7, ["Neon|Fly|Ride"] = 281.75, ["Mega"] = 17.07, ["Mega|Ride"] = 83.43, ["Mega|Fly|Ride"] = 223.14}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 59.07, ["Ride"] = 131.25, ["Neon"] = 174.4, ["Neon|Fly"] = 452.03, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 813.28, ["Mega|Ride"] = 824.25, ["Mega|Fly|Ride"] = 786.19}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Neon"] = 6.25, ["Neon|Ride"] = 53.12, ["Mega"] = 97.04, ["Mega|Ride"] = 65.6, ["Mega|Fly|Ride"] = 104.93}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 40.69, ["Fly"] = 139.57, ["Ride"] = 83.34, ["Fly|Ride"] = 207.27, ["Neon"] = 149.63, ["Neon|Ride"] = 222.89, ["Neon|Fly|Ride"] = 258.6, ["Mega|Ride"] = 1668.26}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 8.34, ["Ride"] = 31.26, ["Neon"] = 18.76, ["Neon|Ride"] = 416.61, ["Mega"] = 93.85, ["Mega|Ride"] = 822.94, ["Mega|Fly|Ride"] = 486.93}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.1, ["Fly"] = 69.79, ["Ride"] = 70.9, ["Neon"] = 7.88, ["Neon|Fly"] = 62.51, ["Neon|Ride"] = 56.25, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 420, ["Mega|Ride"] = 569.63, ["Mega|Fly|Ride"] = 556.79}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 27.57, ["Ride"] = 40.78, ["Fly|Ride"] = 91.88, ["Neon"] = 97.92, ["Neon|Ride"] = 210, ["Mega|Ride"] = 2611.88, ["Mega|Fly|Ride"] = 1232.44}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 131.62, ["Ride"] = 65.63, ["Fly|Ride"] = 240, ["Neon"] = 4.34, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 168, ["Mega"] = 45.93, ["Mega|Fly"] = 158.61, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 268.48}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 27.09, ["Ride"] = 23.61, ["Fly|Ride"] = 72.17, ["Neon"] = 6.26, ["Neon|Fly"] = 41.88, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 105.59, ["Mega|Fly|Ride"] = 278.15}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 10.5, ["Ride"] = 39.38, ["Neon"] = 39.38, ["Neon|Ride"] = 111.45, ["Neon|Fly|Ride"] = 105, ["Mega"] = 254.63, ["Mega|Ride"] = 459.82, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 30.19, ["Ride"] = 91.67, ["Fly|Ride"] = 181.22, ["Neon"] = 131.24, ["Neon|Fly"] = 278.1, ["Neon|Ride"] = 249.98, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 518.43, ["Mega|Ride"] = 671.48, ["Mega|Fly|Ride"] = 623.44}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 22.71, ["Fly"] = 30.17, ["Ride"] = 41.68, ["Fly|Ride"] = 78.11, ["Neon"] = 103.69, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 222.89, ["Mega"] = 616.77, ["Mega|Ride"] = 459.82, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 62.99, ["Fly"] = 196.88, ["Ride"] = 111.57, ["Fly|Ride"] = 237.57, ["Neon"] = 341.24, ["Neon|Ride"] = 371.44, ["Neon|Fly|Ride"] = 504, ["Mega"] = 1260, ["Mega|Ride"] = 1246.88, ["Mega|Fly|Ride"] = 1334.81}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 2.63, ["Ride"] = 32.01, ["Fly|Ride"] = 262.5, ["Neon"] = 23.09, ["Neon|Ride"] = 139.57, ["Neon|Fly|Ride"] = 312.81, ["Mega"] = 138.62, ["Mega|Ride"] = 208.55, ["Mega|Fly|Ride"] = 328.79}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 5.25, ["Ride"] = 41.68, ["Fly|Ride"] = 118.13, ["Neon"] = 28.13, ["Neon|Ride"] = 69.79, ["Mega"] = 144.95, ["Mega|Ride"] = 212.55, ["Mega|Fly|Ride"] = 308.42}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 16.69, ["Fly"] = 105, ["Ride"] = 28.84, ["Fly|Ride"] = 157.5, ["Neon"] = 122.43, ["Neon|Ride"] = 139.57, ["Mega"] = 366.19, ["Mega|Fly|Ride"] = 458.07}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 15.64, ["Fly|Ride"] = 39.38, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 62.39, ["Mega"] = 15.64, ["Mega|Fly"] = 77.4, ["Mega|Ride"] = 23.63, ["Mega|Fly|Ride"] = 98.44}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 49.88, ["Fly"] = 220.5, ["Ride"] = 97.92, ["Neon"] = 290.59, ["Neon|Fly"] = 2361.09, ["Neon|Ride"] = 291.37, ["Mega"] = 1167.78, ["Mega|Fly"] = 953, ["Mega|Ride"] = 998.88, ["Mega|Fly|Ride"] = 956.34}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 23.09, ["Fly|Ride"] = 89.25, ["Neon"] = 3.94, ["Neon|Ride"] = 19.69, ["Mega"] = 106.25, ["Mega|Ride"] = 154.79, ["Mega|Fly|Ride"] = 210.76}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 28.13, ["Ride"] = 22.93, ["Fly|Ride"] = 62.51, ["Neon"] = 20.41, ["Neon|Ride"] = 32.44, ["Neon|Fly|Ride"] = 98.02, ["Mega"] = 208.55, ["Mega|Ride"] = 208.55, ["Mega|Fly|Ride"] = 278.4}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 78.75, ["Fly"] = 208.31, ["Ride"] = 118.74, ["Fly|Ride"] = 403.07, ["Neon"] = 262.5, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 598.49, ["Mega"] = 1002.75, ["Mega|Ride"] = 912.19, ["Mega|Fly|Ride"] = 1010.63}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 56.25, ["Neon"] = 3.94, ["Neon|Ride"] = 42, ["Mega"] = 51.06, ["Mega|Ride"] = 85.79, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 11.8}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 105, ["Neon"] = 5.23, ["Neon|Ride"] = 46.17, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 42, ["Mega|Fly"] = 94.89, ["Mega|Ride"] = 115.5, ["Mega|Fly|Ride"] = 200.81}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 139.57, ["Ride"] = 166.66, ["Fly|Ride"] = 278.1, ["Neon"] = 481.69, ["Neon|Ride"] = 604.09, ["Neon|Fly|Ride"] = 735, ["Mega|Fly|Ride"] = 2835}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 6.57, ["Ride"] = 41.99, ["Neon"] = 19.9, ["Neon|Ride"] = 61.69, ["Mega"] = 278.4, ["Mega|Ride"] = 354.52, ["Mega|Fly|Ride"] = 403.52}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 208.31, ["Neon"] = 6.57, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 26.25, ["Mega|Ride"] = 98.57, ["Mega|Fly|Ride"] = 312.9}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 3.93, ["Fly"] = 45.85, ["Ride"] = 30.85, ["Neon"] = 52.5, ["Neon|Ride"] = 139.57, ["Mega"] = 853.13, ["Mega|Ride"] = 278.4, ["Mega|Fly|Ride"] = 616.82}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 7.87, ["Fly"] = 73.96, ["Ride"] = 24.94, ["Neon"] = 62.31, ["Neon|Fly|Ride"] = 312.81, ["Mega"] = 350.07, ["Mega|Ride"] = 467.12, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 23.63, ["Ride"] = 65.71, ["Fly|Ride"] = 166.66, ["Neon"] = 153.6, ["Neon|Ride"] = 227.07, ["Neon|Fly|Ride"] = 264.85, ["Mega"] = 583.9, ["Mega|Ride"] = 583.9, ["Mega|Fly|Ride"] = 616.87}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 140.44, ["Ride"] = 196.88, ["Fly|Ride"] = 262.5, ["Neon"] = 557.9, ["Neon|Ride"] = 546, ["Neon|Fly|Ride"] = 641.82, ["Mega|Fly|Ride"] = 3044.54}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 8.65, ["Fly"] = 31.16, ["Ride"] = 21.13, ["Fly|Ride"] = 41.11, ["Neon"] = 36.75, ["Neon|Ride"] = 46.17, ["Neon|Fly|Ride"] = 84, ["Mega|Ride"] = 695.46, ["Mega|Fly|Ride"] = 360.94}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 3.54, ["Fly"] = 78.75, ["Ride"] = 43.98, ["Fly|Ride"] = 178.12, ["Neon"] = 20.84, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 192.95, ["Mega"] = 136.31, ["Mega|Ride"] = 131.24, ["Mega|Fly|Ride"] = 459.82}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 10.5, ["Fly"] = 230.77, ["Ride"] = 72.92, ["Fly|Ride"] = 104.16, ["Neon"] = 161.44, ["Neon|Ride"] = 131.24, ["Mega"] = 500.49, ["Mega|Ride"] = 462.02, ["Mega|Fly|Ride"] = 503.48}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 39.38, ["Ride"] = 73.86, ["Fly|Ride"] = 125.01, ["Neon"] = 203.11, ["Neon|Ride"] = 202.12, ["Neon|Fly|Ride"] = 293.99, ["Mega"] = 598.49, ["Mega|Fly"] = 973.85, ["Mega|Ride"] = 765.32, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 19.69, ["Fly"] = 65.63, ["Ride"] = 81.38, ["Neon"] = 131.24, ["Neon|Ride"] = 208.31, ["Mega"] = 667.31, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 521.34}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 235.38, ["Ride"] = 413.44, ["Neon"] = 2152.79, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1562.95, ["Mega|Ride"] = 3937.5, ["Mega|Fly|Ride"] = 5629.26}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 34.13, ["Fly"] = 52.5, ["Ride"] = 41.99, ["Fly|Ride"] = 93.75, ["Neon"] = 278.1, ["Neon|Ride"] = 208.32, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 1195.69, ["Mega|Ride"] = 577.64, ["Mega|Fly|Ride"] = 695.46}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 28.13, ["Ride"] = 16.69, ["Neon"] = 2.1, ["Neon|Ride"] = 19.94, ["Neon|Fly|Ride"] = 41.72, ["Mega"] = 35.82, ["Mega|Fly"] = 65.63, ["Mega|Ride"] = 65.69, ["Mega|Fly|Ride"] = 123.61}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 2.1, ["Ride"] = 59.07, ["Neon"] = 20.85, ["Neon|Ride"] = 39.38, ["Mega"] = 122.72, ["Mega|Ride"] = 262.47, ["Mega|Fly|Ride"] = 491.54}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 6.51, ["Ride"] = 102.37, ["Neon"] = 19.79, ["Neon|Ride"] = 62.31, ["Neon|Fly|Ride"] = 1181.25, ["Mega"] = 105, ["Mega|Fly"] = 223.14, ["Mega|Ride"] = 278.4, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 393.75, ["Fly"] = 576.91, ["Ride"] = 418.69, ["Fly|Ride"] = 435.16, ["Neon"] = 1527.88, ["Neon|Ride"] = 1389.38, ["Neon|Fly|Ride"] = 1345.32, ["Mega|Fly|Ride"] = 4796.18}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.1, ["Fly"] = 41.68, ["Ride"] = 18.38, ["Fly|Ride"] = 56.44, ["Neon"] = 46.15, ["Neon|Ride"] = 66.68, ["Neon|Fly|Ride"] = 71.18, ["Mega|Ride"] = 165.72, ["Mega|Fly|Ride"] = 832.05}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 2.1, ["Fly"] = 31.77, ["Ride"] = 23.97, ["Fly|Ride"] = 45.94, ["Neon|Ride"] = 56.25, ["Neon|Fly|Ride"] = 98.02, ["Mega"] = 416.03, ["Mega|Ride"] = 695.46, ["Mega|Fly|Ride"] = 834.14}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 5.18, ["Fly"] = 83.34, ["Ride"] = 28.13, ["Neon"] = 15.73, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 123.38, ["Mega"] = 147, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 483.8}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 60.38, ["Fly"] = 202.06, ["Ride"] = 61.46, ["Neon"] = 118.13, ["Neon|Ride"] = 208.31, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 833.09, ["Mega|Fly|Ride"] = 640.49}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 315, ["Ride"] = 62.62, ["Fly|Ride"] = 41.68, ["Neon"] = 17.07, ["Neon|Ride"] = 108.59, ["Neon|Fly|Ride"] = 210, ["Mega|Ride"] = 108.59, ["Mega|Fly|Ride"] = 620.17}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 3.93, ["Fly"] = 104.15, ["Ride"] = 24.93, ["Fly|Ride"] = 91.88, ["Neon"] = 308.06, ["Neon|Ride"] = 139.57, ["Mega"] = 695.46, ["Mega|Ride"] = 308.39, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 35.42, ["Fly|Ride"] = 60.42, ["Neon"] = 5.24, ["Neon|Ride"] = 33.34, ["Mega"] = 81.35, ["Mega|Ride"] = 180.03, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 12.5, ["Neon"] = 77.32, ["Mega|Ride"] = 338.63, ["Mega|Fly|Ride"] = 625.61}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 11.81, ["Ride"] = 193.73, ["Fly|Ride"] = 139.57, ["Neon"] = 154.62, ["Neon|Ride"] = 69.79, ["Mega"] = 234.62, ["Mega|Ride"] = 278.4, ["Mega|Fly|Ride"] = 1037.45}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 14.43, ["Fly"] = 37.48, ["Ride"] = 24.94, ["Fly|Ride"] = 56.25, ["Neon"] = 61.92, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 585.99, ["Mega|Ride"] = 375.38, ["Mega|Fly|Ride"] = 445.75}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 254.14, ["Fly"] = 498.75, ["Ride"] = 220.5, ["Fly|Ride"] = 288.75, ["Neon"] = 1575, ["Neon|Ride"] = 923.04, ["Neon|Fly|Ride"] = 845.81, ["Mega|Fly|Ride"] = 2689}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Fly"] = 21.2, ["Ride"] = 18.38, ["Fly|Ride"] = 55.13, ["Neon"] = 20.85, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 108.29, ["Mega"] = 208.55, ["Mega|Ride"] = 320.11, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 3.28, ["Ride"] = 23.63, ["Fly|Ride"] = 103.63, ["Neon"] = 17.32, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 137.82, ["Mega|Ride"] = 770.39, ["Mega|Fly|Ride"] = 410.82}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 30.19, ["Ride"] = 147.91, ["Fly|Ride"] = 446.25, ["Neon"] = 109.62, ["Neon|Ride"] = 229.37, ["Neon|Fly|Ride"] = 625.61, ["Mega"] = 418.42, ["Mega|Ride"] = 378, ["Mega|Fly|Ride"] = 467.25}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 59.06, ["Fly"] = 393.75, ["Ride"] = 118.13, ["Fly|Ride"] = 205.24, ["Neon"] = 299.25, ["Neon|Ride"] = 461.53, ["Neon|Fly|Ride"] = 556.79, ["Mega|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 1390.91}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 23.63, ["Ride"] = 91.86, ["Fly|Ride"] = 208.32, ["Neon"] = 90.57, ["Neon|Ride"] = 138.48, ["Neon|Fly|Ride"] = 202.13, ["Mega"] = 208.31, ["Mega|Ride"] = 283.02, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 22.93, ["Fly|Ride"] = 39.11, ["Neon"] = 15.64, ["Mega"] = 123.6, ["Mega|Ride"] = 278.4, ["Mega|Fly|Ride"] = 348.27}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 27.09, ["Fly"] = 44.63, ["Ride"] = 52.5, ["Fly|Ride"] = 83.34, ["Neon"] = 58.72, ["Neon|Ride"] = 141.65, ["Neon|Fly|Ride"] = 307.13, ["Mega"] = 247.19, ["Mega|Ride"] = 307.59, ["Mega|Fly|Ride"] = 411.39}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 75.48, ["Ride"] = 139.57, ["Fly|Ride"] = 210, ["Neon"] = 208.69, ["Neon|Ride"] = 276.92, ["Neon|Fly|Ride"] = 419.32, ["Mega"] = 604.15, ["Mega|Ride"] = 534.06, ["Mega|Fly|Ride"] = 590.62}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.1, ["Ride"] = 72.19, ["Neon"] = 4.39, ["Neon|Ride"] = 104.74, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 35.7, ["Mega|Fly"] = 103.68, ["Mega|Ride"] = 104.19, ["Mega|Fly|Ride"] = 220.5}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 8.35, ["Ride"] = 288.75, ["Neon"] = 41.68, ["Neon|Ride"] = 649.91, ["Mega"] = 403.52, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 984.37, ["Fly"] = 1365, ["Ride"] = 943.69, ["Fly|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 3412.5, ["Mega|Fly|Ride"] = 11156.25}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 19.69, ["Ride"] = 97.92, ["Neon"] = 154.62, ["Neon|Ride"] = 278.1, ["Mega"] = 590.63, ["Mega|Ride"] = 539.44, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 3.93, ["Fly"] = 46.91, ["Ride"] = 28.13, ["Fly|Ride"] = 208.31, ["Neon"] = 14.44, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 45.93, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 99.57, ["Mega|Ride"] = 124.69, ["Mega|Fly|Ride"] = 347.82}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 26.25, ["Ride"] = 131.22, ["Neon"] = 78.75, ["Mega|Ride"] = 250.25, ["Mega|Fly|Ride"] = 695.46}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Fly|Ride"] = 416.61, ["Neon"] = 2.61, ["Neon|Ride"] = 36.43, ["Neon|Fly|Ride"] = 100.11, ["Mega"] = 14.44, ["Mega|Ride"] = 62.99, ["Mega|Fly|Ride"] = 154.61}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 89.25, ["Ride"] = 208.31, ["Fly|Ride"] = 308.06, ["Neon"] = 442.17, ["Neon|Ride"] = 353.07, ["Neon|Fly|Ride"] = 556.17, ["Mega"] = 1312.5, ["Mega|Ride"] = 1390.91, ["Mega|Fly|Ride"] = 1153.69}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 3.93, ["Fly"] = 101.07, ["Ride"] = 48.97, ["Fly|Ride"] = 69.57, ["Neon"] = 33.35, ["Neon|Ride"] = 84, ["Mega"] = 346.18, ["Mega|Ride"] = 252.79, ["Mega|Fly|Ride"] = 320.11}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2.5, ["Ride"] = 31.26, ["Neon"] = 9.18, ["Neon|Ride"] = 45.94, ["Mega"] = 140.44, ["Mega|Ride"] = 247.19, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 54.18, ["Fly"] = 126, ["Ride"] = 77.32, ["Fly|Ride"] = 183.74, ["Neon"] = 157.49, ["Neon|Fly"] = 278.1, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 395.17, ["Mega"] = 535.5, ["Mega|Ride"] = 541.65, ["Mega|Fly|Ride"] = 458.07}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 13.11, ["Fly"] = 183.75, ["Ride"] = 50.02, ["Fly|Ride"] = 111.45, ["Neon"] = 91.87, ["Neon|Fly"] = 184.63, ["Neon|Ride"] = 145.83, ["Neon|Fly|Ride"] = 242.82, ["Mega"] = 328.13, ["Mega|Ride"] = 537.43, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 92.3, ["Ride"] = 278.1, ["Neon"] = 556.17, ["Neon|Ride"] = 933.19, ["Neon|Fly|Ride"] = 919.42, ["Mega"] = 1349.2, ["Mega|Ride"] = 1807.97, ["Mega|Fly|Ride"] = 1321.05}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 7.76, ["Ride"] = 26.25, ["Fly|Ride"] = 104.16, ["Neon"] = 31.5, ["Neon|Ride"] = 95.8, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 185.78, ["Mega|Ride"] = 184.82, ["Mega|Fly|Ride"] = 308.39}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 6.55, ["Fly"] = 196.88, ["Ride"] = 29.66, ["Fly|Ride"] = 52.5, ["Neon"] = 72.16, ["Neon|Ride"] = 93.75, ["Neon|Fly|Ride"] = 231.02, ["Mega"] = 354.37, ["Mega|Ride"] = 373.28, ["Mega|Fly|Ride"] = 702.85}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 144.38, ["Ride"] = 190.31, ["Fly|Ride"] = 183.75, ["Neon"] = 543.38, ["Neon|Ride"] = 532.88, ["Neon|Fly|Ride"] = 546, ["Mega"] = 2362.5, ["Mega|Ride"] = 1988.34, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 23.97, ["Fly|Ride"] = 47.93, ["Neon"] = 16.62, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 78.22, ["Mega"] = 181.43, ["Mega|Ride"] = 160.13, ["Mega|Fly|Ride"] = 174.57}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 5.25, ["Fly"] = 87.94, ["Ride"] = 23.09, ["Fly|Ride"] = 65.63, ["Neon"] = 18.72, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 83.43, ["Mega"] = 220.5, ["Mega|Fly"] = 231.49, ["Mega|Ride"] = 260.68, ["Mega|Fly|Ride"] = 308.39}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 28.13, ["Ride"] = 15.64, ["Fly|Ride"] = 35.94, ["Neon"] = 2.1, ["Neon|Fly"] = 31.16, ["Neon|Ride"] = 20.84, ["Neon|Fly|Ride"] = 41.4, ["Mega"] = 14.43, ["Mega|Ride"] = 27.57, ["Mega|Fly|Ride"] = 87.92}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 31.26, ["Neon"] = 3.94, ["Neon|Ride"] = 41.68, ["Neon|Fly|Ride"] = 417.08, ["Mega"] = 23.63, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 62.92, ["Mega|Fly|Ride"] = 139.73}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.1, ["Fly"] = 130.61, ["Ride"] = 42, ["Neon"] = 22.32, ["Neon|Ride"] = 64.98, ["Mega"] = 154.79, ["Mega|Ride"] = 206.46, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 69.79, ["Ride"] = 315, ["Neon"] = 160.39, ["Neon|Ride"] = 452.82, ["Neon|Fly|Ride"] = 630, ["Mega"] = 774.38, ["Mega|Ride"] = 556.79, ["Mega|Fly|Ride"] = 792.43}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.1, ["Fly"] = 28.33, ["Ride"] = 20.84, ["Fly|Ride"] = 59.38, ["Neon"] = 17.43, ["Neon|Fly"] = 31.16, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 77.09, ["Mega"] = 193.95, ["Mega|Fly"] = 178.31, ["Mega|Ride"] = 416.03, ["Mega|Fly|Ride"] = 169.98}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 2.1, ["Fly"] = 34.13, ["Ride"] = 24.94, ["Fly|Ride"] = 77.32, ["Neon"] = 17.73, ["Neon|Fly"] = 68.09, ["Neon|Ride"] = 27.09, ["Neon|Fly|Ride"] = 98.02, ["Mega"] = 125.32, ["Mega|Fly"] = 278.4, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 188.73}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 115.71, ["Neon"] = 15.64, ["Neon|Fly"] = 98.44, ["Neon|Ride"] = 23.09, ["Neon|Fly|Ride"] = 106.32, ["Mega"] = 50.54, ["Mega|Fly"] = 408.19, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 9.19, ["Ride"] = 61.46, ["Neon"] = 66.93, ["Neon|Ride"] = 59.04, ["Neon|Fly|Ride"] = 154.32, ["Mega"] = 249.21, ["Mega|Ride"] = 300.3, ["Mega|Fly|Ride"] = 459.82}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 7.95, ["Fly"] = 153.83, ["Neon"] = 57.1, ["Neon|Ride"] = 85.32, ["Mega"] = 420, ["Mega|Ride"] = 411.87, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 3.42, ["Fly"] = 35.44, ["Ride"] = 27.09, ["Fly|Ride"] = 138.48, ["Neon"] = 18.38, ["Neon|Fly"] = 196.65, ["Neon|Ride"] = 82.29, ["Neon|Fly|Ride"] = 105, ["Mega"] = 199.16, ["Mega|Ride"] = 202.08, ["Mega|Fly|Ride"] = 311.76}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 23.97, ["Ride"] = 16.86, ["Fly|Ride"] = 43.32, ["Neon"] = 14.44, ["Neon|Fly"] = 85.39, ["Neon|Ride"] = 41.68, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 131.25, ["Mega|Ride"] = 154.79, ["Mega|Fly|Ride"] = 223.91}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 196.88, ["Fly"] = 393.75, ["Ride"] = 292.58, ["Fly|Ride"] = 416.61, ["Neon"] = 898.83, ["Neon|Ride"] = 923.04, ["Neon|Fly|Ride"] = 918.75, ["Mega"] = 5561.5, ["Mega|Fly|Ride"] = 3661.88}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 4.81, ["Ride"] = 61.76, ["Neon"] = 28.13, ["Neon|Fly|Ride"] = 278.4, ["Mega"] = 154.32, ["Mega|Ride"] = 139.73, ["Mega|Fly|Ride"] = 973.85}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 17.33, ["Fly|Ride"] = 118.13, ["Neon"] = 37.51, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 139.65, ["Mega"] = 203.44, ["Mega|Ride"] = 459.38}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 9.09, ["Neon"] = 40.63, ["Neon|Fly|Ride"] = 625.61, ["Mega"] = 415.82, ["Mega|Ride"] = 407.69, ["Mega|Fly|Ride"] = 417.08}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 19.8, ["Fly|Ride"] = 33.79, ["Neon"] = 2.1, ["Neon|Fly"] = 28.76, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 49.67, ["Mega"] = 17.05, ["Mega|Fly|Ride"] = 69.78}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.1, ["Fly"] = 56.47, ["Ride"] = 19.56, ["Fly|Ride"] = 44.8, ["Neon"] = 20.83, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 28.32, ["Mega"] = 196.81, ["Mega|Ride"] = 256.43, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.63, ["Ride"] = 154.16, ["Neon"] = 12.59, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 162.67, ["Mega|Ride"] = 133.12, ["Mega|Fly|Ride"] = 450.19}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 59.07, ["Fly"] = 183.32, ["Ride"] = 77.32, ["Fly|Ride"] = 144.38, ["Neon"] = 341.25, ["Neon|Ride"] = 381.94, ["Neon|Fly|Ride"] = 437.07, ["Mega|Ride"] = 3477.25, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 6.17, ["Fly"] = 85.32, ["Ride"] = 64.58, ["Fly|Ride"] = 139.57, ["Neon"] = 15.74, ["Neon|Ride"] = 68.77, ["Neon|Fly|Ride"] = 308.39, ["Mega"] = 284.15, ["Mega|Ride"] = 200.99}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Ride"] = 56.25, ["Fly|Ride"] = 154.16, ["Neon"] = 13.86, ["Neon|Ride"] = 125, ["Neon|Fly|Ride"] = 166.84, ["Mega"] = 66.94, ["Mega|Fly"] = 406.65, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 223.14}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 49.88, ["Fly"] = 124.69, ["Ride"] = 111.57, ["Fly|Ride"] = 230.77, ["Neon"] = 164.04, ["Neon|Ride"] = 210.72, ["Neon|Fly|Ride"] = 330.74, ["Mega"] = 662.8, ["Mega|Ride"] = 519.75, ["Mega|Fly|Ride"] = 651}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 16.69, ["Ride"] = 17.33, ["Fly|Ride"] = 58.33, ["Neon"] = 2.63, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 17.33, ["Neon|Fly|Ride"] = 43.91, ["Mega"] = 18.38, ["Mega|Ride"] = 55.13, ["Mega|Fly|Ride"] = 126}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Ride"] = 60.01, ["Neon|Fly|Ride"] = 139.73, ["Mega"] = 31.18, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 69.79, ["Neon"] = 9.18, ["Neon|Ride"] = 58.64, ["Neon|Fly|Ride"] = 192.94, ["Mega"] = 62.32, ["Mega|Ride"] = 155.66, ["Mega|Fly|Ride"] = 307.13}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 5.25, ["Fly"] = 81.25, ["Ride"] = 45.65, ["Fly|Ride"] = 161.64, ["Neon"] = 26.25, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 69.79, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 140.44, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 280.35}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 15.64, ["Fly|Ride"] = 35.79, ["Neon"] = 2.1, ["Neon|Fly"] = 22.93, ["Neon|Ride"] = 30.18, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 23.13, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 41.72, ["Mega|Fly|Ride"] = 125.13}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 13.64, ["Ride"] = 42, ["Fly|Ride"] = 98.96, ["Neon"] = 60.85, ["Neon|Fly|Ride"] = 189.67, ["Mega"] = 354.59, ["Mega|Ride"] = 446.27}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2953.13, ["Ride"] = 3176.25, ["Fly|Ride"] = 3176.25, ["Neon|Fly|Ride"] = 11812.24}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 41.68, ["Ride"] = 22.32, ["Fly|Ride"] = 41.99, ["Neon"] = 7.87, ["Neon|Fly"] = 68.4, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 83.43, ["Mega"] = 97.92, ["Mega|Ride"] = 99.73, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 4.64, ["Neon"] = 22.41, ["Mega"] = 98.02, ["Mega|Ride"] = 417.08, ["Mega|Fly|Ride"] = 250.25}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 22.3, ["Ride"] = 31.49, ["Fly|Ride"] = 97.92, ["Neon"] = 91.65, ["Neon|Ride"] = 53.09, ["Neon|Fly|Ride"] = 308.39, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 625.61}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 39.34, ["Ride"] = 78.75, ["Fly|Ride"] = 105, ["Neon"] = 275.63, ["Neon|Fly|Ride"] = 417.08, ["Mega"] = 486.93, ["Mega|Ride"] = 654.94, ["Mega|Fly|Ride"] = 1458.19}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 105, ["Fly"] = 236.43, ["Ride"] = 181.13, ["Fly|Ride"] = 279.56, ["Neon"] = 815.74, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 774.38, ["Neon|Fly|Ride"] = 1063.52, ["Mega"] = 6255.89, ["Mega|Ride"] = 2989.28, ["Mega|Fly|Ride"] = 3517.5}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 5.92, ["Ride"] = 39.38, ["Fly|Ride"] = 111.45, ["Neon"] = 22.92, ["Neon|Ride"] = 138.48, ["Neon|Fly|Ride"] = 139.73, ["Mega"] = 808.5, ["Mega|Ride"] = 178.31, ["Mega|Fly|Ride"] = 253.32}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.63, ["Ride"] = 27.09, ["Neon"] = 20.84, ["Neon|Fly"] = 95.84, ["Mega"] = 77.33, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 821.25}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Fly"] = 101.99, ["Ride"] = 69.79, ["Fly|Ride"] = 118.13, ["Neon"] = 9.19, ["Neon|Ride"] = 40.4, ["Neon|Fly|Ride"] = 250.25, ["Mega"] = 69.57, ["Mega|Ride"] = 141.65, ["Mega|Fly|Ride"] = 287.44}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 13.11, ["Neon"] = 108.47, ["Neon|Ride"] = 208.31, ["Mega"] = 196.88, ["Mega|Ride"] = 417.08, ["Mega|Fly|Ride"] = 345.14}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 69.78, ["Neon"] = 2.1, ["Neon|Ride"] = 41.68, ["Mega"] = 15.75, ["Mega|Ride"] = 133.88, ["Mega|Fly|Ride"] = 151.32}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 91.83, ["Fly"] = 369.23, ["Ride"] = 139.57, ["Fly|Ride"] = 139.57, ["Neon|Ride"] = 409.5, ["Neon|Fly|Ride"] = 455.44, ["Mega|Ride"] = 1668.26, ["Mega|Fly|Ride"] = 1926.64}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.63, ["Ride"] = 32.29, ["Neon"] = 10.31, ["Mega"] = 98.02, ["Mega|Ride"] = 112.88}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 39.38, ["Fly"] = 215.77, ["Ride"] = 56.25, ["Fly|Ride"] = 166.66, ["Neon"] = 265.92, ["Neon|Ride"] = 387.34, ["Neon|Fly|Ride"] = 419.43, ["Mega"] = 2625, ["Mega|Ride"] = 2780.76, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 22.93, ["Fly|Ride"] = 69.79, ["Neon"] = 3.94, ["Neon|Ride"] = 35.42, ["Neon|Fly|Ride"] = 86.89, ["Mega"] = 52.5, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 211.98}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Ride"] = 27.09, ["Neon"] = 10.5, ["Mega"] = 89.57, ["Mega|Ride"] = 140.44, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 9.19, ["Ride"] = 42.9, ["Fly|Ride"] = 380.63, ["Neon"] = 62.31, ["Neon|Ride"] = 78.75, ["Mega"] = 139.73, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 452.82}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 372.75, ["Ride"] = 446.25, ["Fly|Ride"] = 525, ["Neon"] = 1048.69, ["Neon|Ride"] = 1127.44, ["Neon|Fly|Ride"] = 1258.69, ["Mega"] = 3267.68, ["Mega|Ride"] = 3124.49, ["Mega|Fly|Ride"] = 3330.24}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 41.68, ["Ride"] = 58.35, ["Fly|Ride"] = 106.24, ["Neon"] = 181.12, ["Neon|Fly"] = 308.06, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 193.95, ["Mega|Fly|Ride"] = 905.63}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 19.8, ["Fly|Ride"] = 91.88, ["Neon"] = 7.22, ["Neon|Fly"] = 135.4, ["Neon|Ride"] = 23.97, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 66.68, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 231.03}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 10.17, ["Fly"] = 70.23, ["Ride"] = 40.93, ["Fly|Ride"] = 59.07, ["Neon"] = 35.41, ["Neon|Fly"] = 123.46, ["Neon|Ride"] = 82.93, ["Neon|Fly|Ride"] = 157.49, ["Mega"] = 234.89, ["Mega|Fly"] = 372.95, ["Mega|Ride"] = 305.05, ["Mega|Fly|Ride"] = 383.24}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 7.48, ["Ride"] = 31.26, ["Fly|Ride"] = 86.46, ["Neon"] = 105, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 446.27, ["Mega|Ride"] = 403.52, ["Mega|Fly|Ride"] = 500.49}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 4.87, ["Neon"] = 16.69, ["Mega"] = 52.49, ["Mega|Ride"] = 105}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.63, ["Fly"] = 86.63, ["Ride"] = 22.32, ["Fly|Ride"] = 69.25, ["Neon"] = 13.12, ["Neon|Ride"] = 68.75, ["Neon|Fly|Ride"] = 278.4, ["Mega"] = 539.4, ["Mega|Ride"] = 419.37}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 97.13, ["Ride"] = 154.62, ["Fly|Ride"] = 236.25, ["Neon"] = 729.06, ["Neon|Ride"] = 719.97, ["Neon|Fly|Ride"] = 474.43, ["Mega|Ride"] = 2363.7, ["Mega|Fly|Ride"] = 2418.96}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 27.56, ["Ride"] = 78.75, ["Fly|Ride"] = 144, ["Neon"] = 106.24, ["Neon|Ride"] = 278.1, ["Mega"] = 693, ["Mega|Ride"] = 666.27, ["Mega|Fly|Ride"] = 770.39}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2534.43, ["Ride"] = 2625, ["Fly|Ride"] = 2805.59, ["Neon"] = 12497.97, ["Neon|Fly|Ride"] = 8652.94, ["Mega|Fly|Ride"] = 26181.42}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 2.63, ["Fly"] = 65625, ["Ride"] = 22.1, ["Fly|Ride"] = 170.63, ["Neon"] = 11.84, ["Neon|Ride"] = 48.97, ["Mega"] = 105, ["Mega|Ride"] = 169.32}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 14.44, ["Ride"] = 65.63, ["Fly|Ride"] = 278.1, ["Neon"] = 59.07, ["Neon|Ride"] = 139.57, ["Neon|Fly|Ride"] = 348.27, ["Mega"] = 131.25, ["Mega|Ride"] = 269.01, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 1050, ["Ride"] = 1025.07, ["Fly|Ride"] = 1095.94, ["Neon"] = 3866.05, ["Neon|Ride"] = 4010.82, ["Neon|Fly|Ride"] = 3622.5, ["Mega|Ride"] = 14319.73, ["Mega|Fly|Ride"] = 13387.49}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 47.02, ["Fly"] = 139.57, ["Ride"] = 139.57, ["Fly|Ride"] = 262.5, ["Neon"] = 315, ["Mega"] = 924, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 752.07}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 6.2, ["Ride"] = 35.44, ["Neon"] = 19.69, ["Neon|Ride"] = 62.31, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 190.98, ["Mega|Fly|Ride"] = 274.23}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Mega"] = 31.49, ["Mega|Ride"] = 68.25, ["Mega|Fly|Ride"] = 125.13}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 77.44, ["Ride"] = 277.06, ["Fly|Ride"] = 656.25, ["Neon"] = 694.7, ["Neon|Ride"] = 406.04, ["Mega"] = 5250, ["Mega|Fly|Ride"] = 2502.38}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 5.84, ["Ride"] = 139.57, ["Neon"] = 27.09, ["Neon|Ride"] = 103.11, ["Mega"] = 177.19, ["Mega|Ride"] = 158.29, ["Mega|Fly|Ride"] = 408.74}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 139.57, ["Neon"] = 616.12, ["Mega"] = 2085.32, ["Mega|Fly|Ride"] = 1799.62}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 5.75, ["Fly"] = 105, ["Neon"] = 31.16, ["Neon|Fly|Ride"] = 315, ["Mega"] = 224.44}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 262.5, ["Ride"] = 321.57, ["Fly|Ride"] = 355.26, ["Neon"] = 1766.63, ["Neon|Ride"] = 1041.51, ["Neon|Fly|Ride"] = 1023.75, ["Mega|Fly|Ride"] = 3983.98}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 2.1, ["Fly"] = 69.78, ["Ride"] = 22.32, ["Fly|Ride"] = 69.25, ["Neon"] = 34.13, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 116.82, ["Mega"] = 250.04, ["Mega|Ride"] = 308.39, ["Mega|Fly|Ride"] = 350.44}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 31.26, ["Ride"] = 16.21, ["Fly|Ride"] = 57.75, ["Neon"] = 3.56, ["Neon|Fly"] = 39.13, ["Neon|Ride"] = 25.39, ["Neon|Fly|Ride"] = 46.55, ["Mega"] = 39.38, ["Mega|Ride"] = 108.59, ["Mega|Fly|Ride"] = 99.91}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 787.5, ["Fly"] = 1097.75, ["Ride"] = 903, ["Fly|Ride"] = 984.35, ["Neon|Ride"] = 3865.15, ["Neon|Fly|Ride"] = 3545.01, ["Mega"] = 27719.71, ["Mega|Fly|Ride"] = 27804.29}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 10.5, ["Fly"] = 980.19, ["Ride"] = 210, ["Neon"] = 45.85, ["Mega"] = 150.94, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 291.38}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 6.55, ["Fly"] = 56.25, ["Ride"] = 39.48, ["Fly|Ride"] = 90, ["Neon"] = 28.13, ["Neon|Ride"] = 60.42, ["Neon|Fly|Ride"] = 278.4, ["Mega"] = 171.02, ["Mega|Ride"] = 196.85, ["Mega|Fly|Ride"] = 417.08}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 37.94, ["Fly"] = 32.82, ["Ride"] = 32.79, ["Fly|Ride"] = 85.39, ["Neon"] = 278.1, ["Neon|Ride"] = 174.23, ["Neon|Fly|Ride"] = 191.63, ["Mega"] = 2085.32, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 17.04, ["Fly"] = 69.79, ["Ride"] = 32.82, ["Fly|Ride"] = 92.14, ["Neon"] = 98.43, ["Neon|Ride"] = 82.89, ["Neon|Fly|Ride"] = 184.82, ["Mega"] = 556.79, ["Mega|Ride"] = 321.16, ["Mega|Fly|Ride"] = 442.31}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 20.67, ["Ride"] = 54.24, ["Fly|Ride"] = 636.57, ["Neon"] = 91.88, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 432.72, ["Mega|Ride"] = 494.82, ["Mega|Fly|Ride"] = 450.44}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 105, ["Neon"] = 2.1, ["Neon|Ride"] = 91.17, ["Mega"] = 13.13, ["Mega|Ride"] = 89.25}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 36.04, ["Fly"] = 56.26, ["Ride"] = 56.69, ["Fly|Ride"] = 77.44, ["Neon"] = 306.22, ["Neon|Fly"] = 310.21, ["Neon|Ride"] = 208.31, ["Neon|Fly|Ride"] = 308.39, ["Mega"] = 3336.48, ["Mega|Fly|Ride"] = 1049.96}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.63, ["Fly"] = 132.56, ["Ride"] = 27.55, ["Fly|Ride"] = 127.32, ["Neon"] = 15.64, ["Neon|Ride"] = 141.07, ["Mega"] = 773.07, ["Mega|Ride"] = 271.69, ["Mega|Fly|Ride"] = 667.31}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 25.02, ["Ride"] = 18.38, ["Fly|Ride"] = 69.79, ["Neon|Fly|Ride"] = 108.59, ["Mega"] = 1030.15, ["Mega|Ride"] = 274.23, ["Mega|Fly|Ride"] = 202.13}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 5.25, ["Neon"] = 105, ["Neon|Fly|Ride"] = 104.28, ["Mega"] = 196.88, ["Mega|Ride"] = 196.88}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 27.4, ["Fly"] = 262.5, ["Ride"] = 41.68, ["Fly|Ride"] = 105, ["Neon"] = 116.79, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 278.4, ["Mega"] = 1112.51, ["Mega|Ride"] = 735, ["Mega|Fly|Ride"] = 770.39}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 9.16, ["Neon"] = 23.55, ["Mega"] = 103.52, ["Mega|Fly|Ride"] = 308.42}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 27.27, ["Neon"] = 2.1, ["Neon|Ride"] = 91.88, ["Mega"] = 27.09, ["Mega|Ride"] = 41.72, ["Mega|Fly|Ride"] = 200.17}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Ride"] = 26.13, ["Neon"] = 2.1, ["Neon|Ride"] = 33.35, ["Mega"] = 22.77, ["Mega|Fly"] = 73.86, ["Mega|Ride"] = 47.25, ["Mega|Fly|Ride"] = 119.44}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 23.63, ["Fly|Ride"] = 47.76, ["Neon"] = 10.47, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 36.46, ["Neon|Fly|Ride"] = 139.73, ["Mega"] = 86.63, ["Mega|Ride"] = 123.6, ["Mega|Fly|Ride"] = 239.81}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.63, ["Ride"] = 15.64, ["Fly|Ride"] = 5191.98, ["Neon"] = 20.85, ["Neon|Ride"] = 1312.5, ["Mega"] = 139.73, ["Mega|Ride"] = 158.33, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 39.58, ["Ride"] = 15.63, ["Fly|Ride"] = 36.46, ["Neon"] = 23.63, ["Neon|Ride"] = 31.23, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 210, ["Mega|Ride"] = 276.29, ["Mega|Fly|Ride"] = 363.57}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 82.62, ["Ride"] = 166.66, ["Fly|Ride"] = 389.53, ["Neon"] = 250.69, ["Neon|Ride"] = 248.06, ["Neon|Fly|Ride"] = 1042.67, ["Mega"] = 693, ["Mega|Ride"] = 889.88, ["Mega|Fly|Ride"] = 936.32}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 26.04, ["Ride"] = 18.38, ["Fly|Ride"] = 37.17, ["Neon"] = 2.1, ["Neon|Fly"] = 20.84, ["Neon|Ride"] = 24.99, ["Neon|Fly|Ride"] = 65.69, ["Mega"] = 18.38, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 124.92}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 8.38, ["Fly"] = 62.32, ["Ride"] = 39.38, ["Fly|Ride"] = 80.07, ["Neon"] = 52.5, ["Neon|Fly"] = 54.24, ["Neon|Ride"] = 56.1, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 277.22, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 396.22}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 11.81, ["Fly"] = 56.66, ["Ride"] = 27.71, ["Fly|Ride"] = 56.25, ["Neon"] = 76.11, ["Neon|Ride"] = 76.13, ["Neon|Fly|Ride"] = 117.83, ["Mega"] = 1251.2, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 435.75}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 3.15, ["Fly"] = 140.38, ["Ride"] = 46.4, ["Neon"] = 38.27, ["Mega"] = 278.4, ["Mega|Ride"] = 241.5}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Ride"] = 18.75, ["Fly|Ride"] = 61.69, ["Neon"] = 3.92, ["Neon|Fly"] = 81.38, ["Neon|Ride"] = 23.09, ["Neon|Fly|Ride"] = 108.59, ["Mega"] = 41.68, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 61.57, ["Mega|Fly|Ride"] = 92.42}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 2.1, ["Ride"] = 28.13, ["Neon"] = 15.64, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 98.96, ["Neon|Fly|Ride"] = 208.55, ["Mega"] = 91.76, ["Mega|Fly"] = 735, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 370.16}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 1048.68, ["Ride"] = 984.38, ["Fly|Ride"] = 1044.75, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2278.5, ["Mega|Fly|Ride"] = 7434}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 55.13, ["Ride"] = 112.24, ["Fly|Ride"] = 131.25, ["Neon"] = 210, ["Neon|Ride"] = 249.98, ["Mega"] = 1042.67, ["Mega|Ride"] = 1251.2, ["Mega|Fly|Ride"] = 1172.07}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Fly"] = 62.51, ["Ride"] = 69.79, ["Neon"] = 9.24, ["Neon|Ride"] = 73.96, ["Neon|Fly|Ride"] = 315, ["Mega"] = 52.5, ["Mega|Ride"] = 393.75}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 35.44, ["Ride"] = 68.75, ["Fly|Ride"] = 262.5, ["Neon"] = 250.69, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 300.57, ["Mega"] = 1201.2, ["Mega|Ride"] = 759.94, ["Mega|Fly|Ride"] = 950.25}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 2.1, ["Ride"] = 36.46, ["Fly|Ride"] = 278.1, ["Neon"] = 54.17, ["Neon|Ride"] = 131.25, ["Mega"] = 431.99, ["Mega|Fly|Ride"] = 1042.67}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 411.44, ["Ride"] = 363.57, ["Fly|Ride"] = 422.63, ["Neon"] = 1227.94, ["Neon|Ride"] = 1273.13, ["Neon|Fly|Ride"] = 1068.38, ["Mega|Fly|Ride"] = 6175.76}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.5, ["Fly"] = 102.38, ["Ride"] = 22.32, ["Fly|Ride"] = 129.93, ["Neon"] = 15.64, ["Neon|Ride"] = 73.5, ["Mega"] = 393.75}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Ride"] = 23.97, ["Neon"] = 104.99, ["Neon|Ride"] = 139.57}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 30.19, ["Ride"] = 105, ["Fly|Ride"] = 208.31, ["Neon"] = 170.63, ["Neon|Ride"] = 307.32, ["Mega"] = 653.75, ["Mega|Ride"] = 713.35, ["Mega|Fly|Ride"] = 656.24}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 3.87, ["Ride"] = 70.86, ["Fly|Ride"] = 139.57, ["Neon"] = 15.64, ["Mega"] = 202.29, ["Mega|Ride"] = 258.6, ["Mega|Fly|Ride"] = 417.08}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 23.63, ["Ride"] = 15.74, ["Fly|Ride"] = 32.82, ["Neon"] = 2.1, ["Neon|Fly"] = 31.17, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 48.57, ["Mega"] = 17.34, ["Mega|Ride"] = 40.69, ["Mega|Fly|Ride"] = 99.65}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4590.79, ["Ride"] = 4315.5, ["Fly|Ride"] = 4198.69, ["Neon"] = 24995.9, ["Neon|Fly|Ride"] = 25719, ["Mega|Fly|Ride"] = 77990.04}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 7.87, ["Ride"] = 56.44, ["Neon"] = 138.6, ["Mega"] = 262.5, ["Mega|Ride"] = 387.89, ["Mega|Fly|Ride"] = 493.66}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Ride"] = 23.63, ["Fly|Ride"] = 43.32, ["Neon"] = 15.64, ["Neon|Fly"] = 46.17, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 139.73, ["Mega"] = 154.32, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 208.55}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 443.63, ["Fly"] = 840, ["Ride"] = 502.27, ["Fly|Ride"] = 525, ["Neon"] = 1666.41, ["Neon|Ride"] = 1527.88, ["Neon|Fly|Ride"] = 1240.02, ["Mega|Fly|Ride"] = 5483.01}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 6.57, ["Neon"] = 15.73, ["Neon|Ride"] = 69.79, ["Mega"] = 144.38, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 681.91}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 4.86, ["Fly"] = 99.75, ["Ride"] = 77.32, ["Neon"] = 83.34, ["Neon|Ride"] = 278.1, ["Neon|Fly|Ride"] = 13902.67, ["Mega"] = 278.4, ["Mega|Ride"] = 401.63}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 23.63, ["Neon"] = 2.63, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 101.07, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 78.22, ["Mega|Ride"] = 77.99, ["Mega|Fly|Ride"] = 240.33}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 616.88, ["Ride"] = 656.25, ["Fly|Ride"] = 759.94, ["Neon|Ride"] = 2777.69, ["Neon|Fly|Ride"] = 2085.32, ["Mega|Fly|Ride"] = 8751.75}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 6.57, ["Ride"] = 55.13, ["Neon"] = 22.32, ["Neon|Fly"] = 92.32, ["Neon|Ride"] = 90.62, ["Neon|Fly|Ride"] = 237.75, ["Mega"] = 114.71, ["Mega|Ride"] = 250.59, ["Mega|Fly|Ride"] = 346.57}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 9.19, ["Fly"] = 139.57, ["Ride"] = 57.7, ["Fly|Ride"] = 154.62, ["Neon"] = 39.38, ["Neon|Ride"] = 102, ["Neon|Fly|Ride"] = 125.13, ["Mega"] = 210, ["Mega|Ride"] = 304.13, ["Mega|Fly|Ride"] = 333.38}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 40.4, ["Ride"] = 23.09, ["Fly|Ride"] = 154.16, ["Neon"] = 13.13, ["Neon|Ride"] = 33.35, ["Neon|Fly|Ride"] = 105, ["Mega"] = 144.38, ["Mega|Ride"] = 158.82, ["Mega|Fly|Ride"] = 154.79}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 22.94, ["Ride"] = 61.69, ["Fly|Ride"] = 115.4, ["Neon"] = 138.48, ["Mega"] = 541.15, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 526.31}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Ride"] = 39.37, ["Neon"] = 5.23, ["Neon|Ride"] = 56.25, ["Neon|Fly|Ride"] = 2021.24, ["Mega"] = 34.13, ["Mega|Ride"] = 94.5, ["Mega|Fly|Ride"] = 169.32}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 541.59, ["Ride"] = 380.63, ["Fly|Ride"] = 682.5, ["Neon"] = 2056.98, ["Neon|Fly|Ride"] = 1981.05, ["Mega|Ride"] = 9008.91, ["Mega|Fly|Ride"] = 9870.75}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 41.68, ["Neon"] = 11.55, ["Neon|Ride"] = 83.98, ["Neon|Fly|Ride"] = 278.4, ["Mega"] = 38.07, ["Mega|Ride"] = 119.44, ["Mega|Fly|Ride"] = 217.77}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 39.58, ["Neon"] = 3.94, ["Neon|Fly"] = 139.57, ["Neon|Ride"] = 41.68, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 35.46, ["Mega|Ride"] = 82.39, ["Mega|Fly|Ride"] = 261.73}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 30.19, ["Neon"] = 4.46, ["Neon|Ride"] = 45.92, ["Mega"] = 32.82, ["Mega|Ride"] = 97.94, ["Mega|Fly|Ride"] = 203.33}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.61, ["Ride"] = 68.25, ["Neon"] = 21.94, ["Mega"] = 223.14, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 40.65, ["Ride"] = 62.51, ["Fly|Ride"] = 156.19, ["Neon"] = 123.96, ["Neon|Ride"] = 260.76, ["Neon|Fly|Ride"] = 462.02, ["Mega"] = 497.44, ["Mega|Ride"] = 694.84, ["Mega|Fly|Ride"] = 668.07}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 31.26, ["Ride"] = 82.69, ["Fly|Ride"] = 276.94, ["Neon"] = 85.32, ["Neon|Ride"] = 125, ["Mega"] = 388.89, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 488.24}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.63, ["Fly"] = 26.25, ["Ride"] = 19.69, ["Fly|Ride"] = 54.57, ["Neon"] = 31.26, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 93.85, ["Mega"] = 307.79, ["Mega|Ride"] = 206.07, ["Mega|Fly|Ride"] = 238.88}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 12.69, ["Ride"] = 39.38, ["Neon"] = 278.1, ["Neon|Ride"] = 158.82, ["Mega|Fly|Ride"] = 517.17}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Ride"] = 28.13, ["Fly|Ride"] = 115.4, ["Neon"] = 6.93, ["Neon|Ride"] = 34.63, ["Mega"] = 110.25, ["Mega|Ride"] = 139.73, ["Mega|Fly|Ride"] = 208.55}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 23.09, ["Ride"] = 31.49, ["Fly|Ride"] = 69.25, ["Neon"] = 208.31, ["Neon|Ride"] = 83.34, ["Neon|Fly|Ride"] = 223.14, ["Mega"] = 937.36, ["Mega|Ride"] = 924, ["Mega|Fly|Ride"] = 695.63}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 55.13, ["Fly"] = 874.13, ["Neon"] = 308.13, ["Neon|Ride"] = 328.13, ["Mega|Ride"] = 590.63}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 44.63, ["Fly"] = 115.5, ["Ride"] = 78.73, ["Fly|Ride"] = 270.38, ["Neon"] = 290.07, ["Neon|Ride"] = 299.25, ["Neon|Fly|Ride"] = 316.31, ["Mega|Ride"] = 1633.16}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 46.15, ["Fly"] = 126.1, ["Ride"] = 104.16, ["Neon"] = 154.2, ["Neon|Ride"] = 184.63, ["Neon|Fly|Ride"] = 279.45, ["Mega"] = 770.39, ["Mega|Ride"] = 770.39, ["Mega|Fly|Ride"] = 790.13}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 24.91, ["Ride"] = 34.13, ["Neon"] = 208.31, ["Neon|Ride"] = 223.13, ["Mega"] = 834.14, ["Mega|Ride"] = 792.43, ["Mega|Fly|Ride"] = 1250.15}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 7.87, ["Ride"] = 23.09, ["Fly|Ride"] = 97.94, ["Neon"] = 44.63, ["Neon|Fly"] = 166.66, ["Neon|Ride"] = 96.94, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 491.72, ["Mega|Ride"] = 345.18, ["Mega|Fly|Ride"] = 375.37}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 28.13, ["Ride"] = 15.75, ["Fly|Ride"] = 41.68, ["Neon"] = 3.92, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 30.22, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 40.69, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 972.57}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 28.13, ["Ride"] = 123.96, ["Fly|Ride"] = 262.5, ["Neon"] = 92.32, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 345.35, ["Mega"] = 556.79, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 543.85}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 39.63, ["Neon"] = 3.92, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 291.96, ["Mega"] = 35.44, ["Mega|Ride"] = 75.43, ["Mega|Fly|Ride"] = 217.88}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 26.25, ["Ride"] = 83.34, ["Neon"] = 261.19, ["Neon|Ride"] = 347.88, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 711.38, ["Mega|Ride"] = 728.82, ["Mega|Fly|Ride"] = 590.62}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 3.29, ["Mega"] = 15.75}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 3.87, ["Neon|Ride"] = 86.56, ["Mega"] = 26.25, ["Mega|Ride"] = 83.43, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 136.5, ["Ride"] = 219.19, ["Neon"] = 584.96, ["Neon|Ride"] = 590.63, ["Neon|Fly|Ride"] = 765.32, ["Mega|Ride"] = 6352.45, ["Mega|Fly|Ride"] = 2034.37}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.63, ["Fly"] = 65.63, ["Ride"] = 26.24, ["Fly|Ride"] = 87.5, ["Neon"] = 11.42, ["Neon|Fly"] = 62.51, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 154.32, ["Mega"] = 41.72, ["Mega|Ride"] = 116.82, ["Mega|Fly|Ride"] = 417.08}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 36.46, ["Fly|Ride"] = 86.63, ["Neon"] = 6.29, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 419.99, ["Mega"] = 28.17, ["Mega|Ride"] = 104.28}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 83.34, ["Neon"] = 5.25, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 41.72, ["Mega"] = 35.44, ["Mega|Ride"] = 74.82, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 91.88, ["Neon"] = 6.29, ["Neon|Ride"] = 27.6, ["Neon|Fly|Ride"] = 139.73, ["Mega"] = 46.17, ["Mega|Ride"] = 94.5, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 39.35, ["Ride"] = 86.63, ["Fly|Ride"] = 616.12, ["Neon"] = 336.99, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 973.85, ["Mega|Ride"] = 1042.67, ["Mega|Fly|Ride"] = 1248.03}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 2.63, ["Ride"] = 129.17, ["Neon"] = 20.98, ["Neon|Ride"] = 90.62, ["Neon|Fly|Ride"] = 278.4, ["Mega"] = 140.6, ["Mega|Ride"] = 547.98, ["Mega|Fly|Ride"] = 415}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 347.82, ["Ride"] = 459.32, ["Fly|Ride"] = 602, ["Neon"] = 2916.21, ["Neon|Ride"] = 1111.29, ["Neon|Fly|Ride"] = 1042.67, ["Mega|Fly|Ride"] = 3150}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 65.63}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 40.95}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 11.82}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 23.97}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 520.77}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 53.5}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 18.76}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 6.54}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 216.57}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 22.3}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 39.38}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 15.64}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 10.43}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 256.88}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 6.56}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 5.24}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 6.56}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 23.02}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 465.94}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 736.36}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 13.11}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1111.69}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 250.69}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 14.3}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 19.47}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 86.62}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 43.24}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 17.07}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 9.19}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 14.44}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 12.49}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 19.48}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.6}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 28.02}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 14.21}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 3.93}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 7.87}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 1575}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 116.7}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 300.66}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 3.92}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 10.42}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 7.88}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 23.24}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 153.57}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 10.5}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 12.44}},
    ["rbxassetid://1265129435"] = {name = "Gold Snowboard", prices = {["default"] = 210}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 177.06}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 17.03}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 6.57}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 22.31}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 6.57}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 3.68}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 110.25}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 18.38}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 7.88}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.63}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 21.93}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 9.18}},
    ["rbxassetid://1265129203"] = {name = "Ice Snowboard", prices = {["default"] = 207.38}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 3.93}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 21.67}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 149.26}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 98.43}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.63}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 8.33}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 19.08}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 39.06}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 77.31}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 52.45}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 21922.56}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 166.31}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 32.82}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 32.82}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 34.12}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 270.8}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 25.77}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 30.86}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 74.79}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 131.25}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 31.49}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 19.69}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 27.57}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 40.69}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 36.75}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 350.83}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 8.17}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 10.5}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 6.25}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 32.82}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 48.56}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.63}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 3.93}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.63}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 2.63}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 6.5}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 7.88}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 669.38}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 22.31}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 6.26}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 372.87}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 40.66}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 230.77}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 45.94}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 32.82}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 132.56}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 30.56}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 2.1}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 15.74}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 3.5}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 3.94}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 3.92}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 40.95}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 3.92}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 3.84}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 3.94}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 6.56}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 207.69}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 52.48}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.1}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 235.38}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 7.88}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 7.88}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 7.02}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 17.07}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 203.44}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 20.85}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 3.94}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 14.42}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 18.25}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 111.57}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 45.94}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 4.87}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 5.91}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 8.39}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 5.86}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 3.52}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 5.24}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 45.94}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 4.45}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 3.94}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 7811.23}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 19.62}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 3.36}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 11.82}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 21}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 31.49}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 9.18}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 5.18}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 3.81}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 14.42}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.3}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 118.01}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 14.44}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 9.22}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 4.77}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.61}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 5.9}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 3.7}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 3.46}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4309.53}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 4.64}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.61}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 44.63}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 6.22}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 77.33}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 52.49}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 5.25}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 182.27}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.63}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 2.1}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.63}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 3.93}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 17.07}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 28.87}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.35}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.45}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 4.64}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 45.94}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 6.54}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 4.17}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 28.13}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.5}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 3.41}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 6.57}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.63}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 3.71}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 28.62}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 6.02}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 3.07}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 13.12}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 118.13}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 34.91}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 5.2}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1236.27}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 20.85}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 3.93}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 2.47}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.63}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 103.68}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 3.29}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 6.26}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 3.84}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 15.7}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.63}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 27.01}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 19.66}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 4.7}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 3.72}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 11.81}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 4.69}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 12.44}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 4.86}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 3.93}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 30.19}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 11.82}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.37}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 40.27}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.63}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 230.77}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 4.75}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 26.22}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 23.6}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 2.63}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.61}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 98.44}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 3.92}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 28.87}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.24}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 3.93}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 5.16}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 5.92}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 4.72}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 15.64}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 86.63}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.5}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 107.92}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 9.19}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1437.19}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 4.18}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 213.7}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 3.93}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 18.76}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 37.68}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 3.89}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 4.17}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 65.63}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 8.6}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 3.93}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 3.93}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 3.65}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 89.23}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 4.99}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 74.82}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 3.93}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 56.44}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 7.87}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 8.35}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 27.56}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 114.19}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 3.93}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.57}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 76.1}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 3.93}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 7.54}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 64.26}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 41.82}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 86.62}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 383.93}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 47.23}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.63}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 104.16}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 2.63}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 22.32}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 74.82}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 3.89}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 23.63}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 9.18}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 9.17}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 26.25}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.24}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 23.15}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 4.17}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 11.82}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 37.51}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 90.62}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 3.92}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 34.13}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 5.58}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 6.43}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 45.91}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 66.93}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 55.13}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1374.78}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 25.46}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 6.35}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 53.82}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 249.25}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 23.07}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 10.5}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 12.78}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 10.49}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 3.92}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 208.67}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 49.88}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 5.25}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 63.79}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 118.13}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 91.74}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 944.65}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 144.37}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 9.16}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 1057.4}},
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