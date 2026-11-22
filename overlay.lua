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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 971.25, ["Fly"] = 1111.43, ["Ride"] = 1041.64, ["Fly|Ride"] = 833.32, ["Neon|Ride"] = 4444.62, ["Neon|Fly|Ride"] = 3403}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 478.87, ["Fly"] = 553.88, ["Ride"] = 519.79, ["Fly|Ride"] = 537.49, ["Neon"] = 1575, ["Neon|Fly|Ride"] = 2361.19, ["Mega|Fly|Ride"] = 8315.29}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 5719.58, ["Ride"] = 4790.63, ["Fly|Ride"] = 5092.5, ["Neon"] = 25693.74, ["Neon|Fly|Ride"] = 19634.62, ["Mega|Fly|Ride"] = 62497.41}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 120.75, ["Ride"] = 182.48, ["Fly|Ride"] = 262.5, ["Neon"] = 1090.27, ["Neon|Ride"] = 820.32, ["Neon|Fly|Ride"] = 641.82, ["Mega"] = 3473.84, ["Mega|Fly|Ride"] = 3077.4}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 523.69, ["Ride"] = 602.09, ["Fly|Ride"] = 639.19, ["Neon|Fly|Ride"] = 1706.25, ["Mega|Fly|Ride"] = 8831.94}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 11.22, ["Ride"] = 46.17, ["Fly|Ride"] = 125.01, ["Neon"] = 32.82, ["Neon|Ride"] = 56.26, ["Neon|Fly|Ride"] = 300.02, ["Mega"] = 262.5, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 409.5}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 3.94, ["Fly"] = 36.46, ["Ride"] = 25.98, ["Fly|Ride"] = 75.36, ["Neon"] = 20.84, ["Neon|Fly"] = 64.32, ["Neon|Ride"] = 45.44, ["Neon|Fly|Ride"] = 92.22, ["Mega"] = 123.38, ["Mega|Fly"] = 303.19, ["Mega|Ride"] = 195.16, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 188.1, ["Ride"] = 290.07, ["Fly|Ride"] = 250.01, ["Neon"] = 458.07, ["Neon|Fly"] = 459.38, ["Neon|Ride"] = 719.78, ["Neon|Fly|Ride"] = 622.91, ["Mega"] = 1846.21, ["Mega|Ride"] = 1874.95, ["Mega|Fly|Ride"] = 1846.21}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 27.57, ["Fly"] = 65.63, ["Ride"] = 41.68, ["Fly|Ride"] = 98.44, ["Neon"] = 301.88, ["Neon|Ride"] = 191.56, ["Neon|Fly|Ride"] = 210, ["Mega"] = 2100, ["Mega|Ride"] = 778.11, ["Mega|Fly|Ride"] = 736.44}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 28.88, ["Fly"] = 57.75, ["Ride"] = 40.68, ["Fly|Ride"] = 82.87, ["Neon"] = 278.13, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 187.69, ["Mega|Ride"] = 686.45, ["Mega|Fly|Ride"] = 820.82}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 54.24, ["Ride"] = 59.07, ["Fly|Ride"] = 161.6, ["Neon|Ride"] = 194.8, ["Neon|Fly|Ride"] = 249.38, ["Mega|Ride"] = 1061.43, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 69.25}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 379.32, ["Fly"] = 415.42, ["Ride"] = 331.02, ["Fly|Ride"] = 444.94, ["Neon"] = 1283.63, ["Neon|Fly|Ride"] = 1391.25, ["Mega|Fly|Ride"] = 4013.39}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 118.13, ["Fly"] = 139.59, ["Ride"] = 123.38, ["Fly|Ride"] = 157.39, ["Neon|Fly|Ride"] = 553.11, ["Mega|Fly|Ride"] = 2497.83}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.63, ["Fly"] = 31.26, ["Ride"] = 31.18, ["Fly|Ride"] = 90.63, ["Neon"] = 18.76, ["Neon|Fly"] = 61.47, ["Neon|Ride"] = 68.09, ["Mega"] = 115.64, ["Mega|Ride"] = 189, ["Mega|Fly|Ride"] = 381.94}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 139.59, ["Fly"] = 140.64, ["Ride"] = 129.94, ["Fly|Ride"] = 206.27, ["Neon"] = 473.95, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 543.38, ["Mega|Fly|Ride"] = 1967.44}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 2.1, ["Fly"] = 18.76, ["Ride"] = 21.3, ["Fly|Ride"] = 60.43, ["Neon"] = 23.63, ["Neon|Fly"] = 104.19, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 211.32, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 41.67, ["Ride"] = 82.9, ["Fly|Ride"] = 143.73, ["Neon"] = 155.66, ["Neon|Ride"] = 154.63, ["Neon|Fly|Ride"] = 207.27, ["Mega"] = 791.64, ["Mega|Ride"] = 694.78, ["Mega|Fly|Ride"] = 767.82}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 56.44}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 39.38, ["Ride"] = 170.63, ["Neon"] = 298.96, ["Mega"] = 2916.56, ["Mega|Fly|Ride"] = 3077.4}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 9.24, ["Fly"] = 393.75, ["Ride"] = 28.88, ["Fly|Ride"] = 525, ["Neon"] = 137.49, ["Neon|Ride"] = 243.75, ["Neon|Fly|Ride"] = 203.44, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 1666.62}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 39.38, ["Fly"] = 62.51, ["Ride"] = 52.5, ["Fly|Ride"] = 115.64, ["Neon"] = 383.33, ["Neon|Ride"] = 199.5, ["Neon|Fly|Ride"] = 222.93, ["Mega"] = 1681.32, ["Mega|Fly|Ride"] = 918.65}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 66.93, ["Ride"] = 155.76, ["Fly|Ride"] = 196.88, ["Neon"] = 196.88, ["Neon|Ride"] = 209.99, ["Neon|Fly|Ride"] = 405.57, ["Mega"] = 1101.38, ["Mega|Ride"] = 1245.8, ["Mega|Fly|Ride"] = 1232.25}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 35.79, ["Ride"] = 52.45, ["Fly|Ride"] = 137.16, ["Neon"] = 139.59, ["Neon|Ride"] = 215.79, ["Neon|Fly|Ride"] = 288.48, ["Mega"] = 694.78, ["Mega|Ride"] = 2040.94, ["Mega|Fly|Ride"] = 952.06}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 40.74, ["Ride"] = 85.4, ["Fly|Ride"] = 131.25, ["Neon"] = 250.01, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 308.11, ["Mega|Ride"] = 2493.75, ["Mega|Fly|Ride"] = 932.27}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 3.94, ["Fly"] = 30.18, ["Ride"] = 20.85, ["Fly|Ride"] = 44.61, ["Neon"] = 24.94, ["Neon|Fly"] = 64.97, ["Neon|Ride"] = 54.17, ["Neon|Fly|Ride"] = 93.19, ["Mega"] = 124.69, ["Mega|Fly"] = 27811.35, ["Mega|Ride"] = 131.24, ["Mega|Fly|Ride"] = 333.34}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 280.08, ["Ride"] = 290.07, ["Fly|Ride"] = 282.19, ["Neon"] = 1454.67, ["Neon|Ride"] = 2916.56, ["Neon|Fly|Ride"] = 1806.18, ["Mega"] = 10416.25, ["Mega|Fly|Ride"] = 5831.02}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 15.74, ["Ride"] = 33.35, ["Fly|Ride"] = 137.52, ["Neon"] = 236.46, ["Neon|Ride"] = 208.34, ["Mega"] = 819.77, ["Mega|Fly|Ride"] = 782.28}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 5.25, ["Fly"] = 37.94, ["Ride"] = 23.98, ["Fly|Ride"] = 48.56, ["Neon"] = 48.98, ["Neon|Ride"] = 69.8, ["Neon|Fly|Ride"] = 116.88, ["Mega|Ride"] = 556.24, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 97.13, ["Fly"] = 136.17, ["Ride"] = 135.19, ["Fly|Ride"] = 198.97, ["Neon"] = 357, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 412.44, ["Mega"] = 6114.38, ["Mega|Ride"] = 3077.4, ["Mega|Fly|Ride"] = 1491}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 12.52, ["Ride"] = 33.34, ["Fly|Ride"] = 118.13, ["Neon"] = 154.63, ["Neon|Ride"] = 139.59, ["Neon|Fly|Ride"] = 207.38, ["Mega"] = 691.65, ["Mega|Fly|Ride"] = 520.83}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 300.02, ["Fly"] = 354.25, ["Ride"] = 195.57, ["Fly|Ride"] = 291.67, ["Neon"] = 708.5, ["Neon|Ride"] = 769.64, ["Neon|Fly|Ride"] = 819.77, ["Mega"] = 6249.75, ["Mega|Fly|Ride"] = 2549.91}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 19.69}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.92, ["Fly"] = 31.4, ["Ride"] = 22.32, ["Fly|Ride"] = 61.47, ["Neon"] = 17.33, ["Neon|Fly"] = 5208.13, ["Neon|Ride"] = 48.07, ["Neon|Fly|Ride"] = 104.16, ["Mega"] = 118.13, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 278.13}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 598.5, ["Ride"] = 733.69, ["Fly|Ride"] = 760.31, ["Neon"] = 3055.76, ["Neon|Ride"] = 3611.33, ["Neon|Fly|Ride"] = 2966.25, ["Mega"] = 11805.77, ["Mega|Ride"] = 51924.23, ["Mega|Fly|Ride"] = 9678.78}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 8.35, ["Ride"] = 36.47, ["Fly|Ride"] = 90.63, ["Neon"] = 69.8, ["Neon|Ride"] = 102.08, ["Neon|Fly|Ride"] = 173.96, ["Mega"] = 787.5, ["Mega|Ride"] = 602.06, ["Mega|Fly|Ride"] = 657.27}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 150.94, ["Ride"] = 157.5, ["Fly|Ride"] = 207.38, ["Neon"] = 598.96, ["Neon|Ride"] = 514.5, ["Neon|Fly|Ride"] = 525, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 2623.86}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 62.31}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 28.14, ["Ride"] = 55.13, ["Fly|Ride"] = 196.88, ["Neon"] = 166.68, ["Neon|Ride"] = 208.34, ["Neon|Fly|Ride"] = 286.17, ["Mega"] = 691.65, ["Mega|Ride"] = 616.19, ["Mega|Fly|Ride"] = 769.64}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.18}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 178.92, ["Ride"] = 208.69, ["Neon"] = 556.24, ["Neon|Ride"] = 624.99, ["Neon|Fly|Ride"] = 923.11, ["Mega|Fly|Ride"] = 1931.19}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 141.75, ["Ride"] = 154.88, ["Fly|Ride"] = 294.79, ["Neon"] = 520.83, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 483, ["Mega|Ride"] = 1286.25, ["Mega|Fly|Ride"] = 1396.5}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 80.04}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 92.97, ["Fly"] = 93.49, ["Ride"] = 59.07, ["Fly|Ride"] = 77.44, ["Neon|Ride"] = 344.78, ["Neon|Fly|Ride"] = 334.69, ["Mega"] = 4166.51, ["Mega|Fly|Ride"] = 1258.41}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 7.77, ["Ride"] = 53.44, ["Fly|Ride"] = 131.25, ["Neon"] = 39.38, ["Neon|Ride"] = 154.18, ["Neon|Fly|Ride"] = 235.43, ["Mega"] = 196.88, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 208.34, ["Mega|Fly|Ride"] = 340.62}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 308.06, ["Fly"] = 459.37, ["Ride"] = 328.13, ["Fly|Ride"] = 354.38, ["Neon|Ride"] = 1945.76, ["Neon|Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 6923.24}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 64.32, ["Fly"] = 99.75, ["Ride"] = 85.32, ["Fly|Ride"] = 171.94, ["Neon"] = 323.1, ["Neon|Fly"] = 312.5, ["Neon|Ride"] = 310.43, ["Neon|Fly|Ride"] = 369.02, ["Mega|Fly|Ride"] = 1561.88}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3569.66, ["Ride"] = 3018.75, ["Fly|Ride"] = 3416.54, ["Neon|Fly|Ride"] = 13886.94}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 39.38, ["Fly"] = 222.93, ["Ride"] = 50.91, ["Fly|Ride"] = 85.32, ["Neon"] = 369.25, ["Neon|Ride"] = 408.19, ["Neon|Fly|Ride"] = 308.11, ["Mega"] = 1874.95, ["Mega|Ride"] = 1874.95, ["Mega|Fly|Ride"] = 1319.75}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 56.44, ["Ride"] = 77.65, ["Fly|Ride"] = 154.18, ["Neon"] = 393.75, ["Neon|Ride"] = 266.57, ["Neon|Fly|Ride"] = 525, ["Mega"] = 6249.75, ["Mega|Fly|Ride"] = 1486.42}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 39.38, ["Fly"] = 74.82, ["Ride"] = 61.47, ["Fly|Ride"] = 130.88, ["Neon"] = 184.98, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 198.19, ["Mega"] = 2598.75, ["Mega|Fly|Ride"] = 627.38}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 9.19}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 65.63, ["Ride"] = 78.75, ["Fly|Ride"] = 131.25, ["Neon"] = 433.33, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 494.79}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 39.38}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 215.71, ["Ride"] = 243.75, ["Fly|Ride"] = 367.5, ["Neon|Ride"] = 1389.54, ["Neon|Fly|Ride"] = 2083.26}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 761.24, ["Ride"] = 643.13, ["Fly|Ride"] = 654.94, ["Neon|Fly|Ride"] = 2231.25, ["Mega|Fly|Ride"] = 11812.5}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 3.91}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 30.19, ["Fly"] = 52.5, ["Ride"] = 38.19, ["Fly|Ride"] = 59.07, ["Neon"] = 264.58, ["Neon|Fly"] = 308.11, ["Neon|Ride"] = 169.32, ["Neon|Fly|Ride"] = 203.44, ["Mega|Ride"] = 791.64, ["Mega|Fly|Ride"] = 692.34}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 9.19}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5118.75, ["Fly|Ride"] = 4725, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 39998.35}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 9.24, ["Fly"] = 41.68, ["Ride"] = 23.39, ["Fly|Ride"] = 48.98, ["Neon"] = 56.26, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 385.41, ["Mega|Ride"] = 374.07, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 10.43, ["Fly"] = 78.14, ["Ride"] = 39.38, ["Fly|Ride"] = 114.23, ["Neon"] = 139.59, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 694.78, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 69.25, ["Ride"] = 128.63, ["Fly|Ride"] = 131.27, ["Neon|Fly|Ride"] = 525}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 11.21, ["Ride"] = 35.44, ["Fly|Ride"] = 139.65, ["Neon"] = 56.69, ["Neon|Ride"] = 83.35, ["Neon|Fly|Ride"] = 139.59, ["Mega"] = 358.34, ["Mega|Ride"] = 549.99, ["Mega|Fly|Ride"] = 1019.82}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 2100, ["Fly"] = 2310, ["Ride"] = 2098.69, ["Fly|Ride"] = 2034.37, ["Neon|Fly|Ride"] = 3806.25, ["Mega|Fly|Ride"] = 11892.57}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 32222.63, ["Ride"] = 24207.75, ["Fly|Ride"] = 24281.15, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 65970.19, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 194436.72}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 27.48, ["Fly"] = 393.75, ["Ride"] = 56.26, ["Fly|Ride"] = 86.56, ["Neon"] = 236.25, ["Neon|Ride"] = 178.38, ["Neon|Fly|Ride"] = 250.01, ["Mega"] = 1111.43, ["Mega|Ride"] = 729.15, ["Mega|Fly|Ride"] = 695.63}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 2.63, ["Ride"] = 31.5, ["Fly|Ride"] = 118.13, ["Neon"] = 15.73, ["Neon|Fly"] = 129.34, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 107.78, ["Mega"] = 105, ["Mega|Ride"] = 252.2, ["Mega|Fly|Ride"] = 230.78}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 18.38}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 7.3, ["Ride"] = 35.42, ["Fly|Ride"] = 278.13, ["Neon"] = 33.64, ["Neon|Ride"] = 124.38, ["Neon|Fly|Ride"] = 463.32, ["Mega"] = 264.58, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 399.99}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 708.75, ["Ride"] = 656.25, ["Fly|Ride"] = 656.25, ["Neon|Fly|Ride"] = 2778.02, ["Mega"] = 11111.01, ["Mega|Fly|Ride"] = 10727.7}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 1032.94, ["Fly"] = 1076.25, ["Ride"] = 1036.88, ["Fly|Ride"] = 1128.75, ["Neon|Fly|Ride"] = 3890.48, ["Mega|Fly|Ride"] = 15276.47}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 28.14, ["Fly"] = 56.25, ["Ride"] = 58.85, ["Fly|Ride"] = 125.01, ["Neon"] = 200.8, ["Neon|Ride"] = 59.17, ["Neon|Fly|Ride"] = 208.31, ["Mega|Ride"] = 486.45, ["Mega|Fly|Ride"] = 694.78}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 26.25}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 55.13, ["Fly"] = 112.88, ["Ride"] = 69.8, ["Fly|Ride"] = 139.59, ["Neon"] = 278.13, ["Neon|Ride"] = 461.56, ["Neon|Fly|Ride"] = 419.99, ["Mega|Fly|Ride"] = 1479.13}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 88.33, ["Ride"] = 90.63, ["Fly|Ride"] = 170.63, ["Neon"] = 450.19, ["Neon|Fly"] = 500, ["Neon|Ride"] = 616.19, ["Neon|Fly|Ride"] = 15385.73, ["Mega"] = 2099.11, ["Mega|Fly|Ride"] = 1912.43}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 2.61, ["Fly"] = 48.57, ["Ride"] = 22.93, ["Fly|Ride"] = 61.69, ["Neon"] = 31.48, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 92.32, ["Mega"] = 556.24, ["Mega|Fly|Ride"] = 450.19}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 82.64, ["Fly"] = 89.24, ["Ride"] = 103.69, ["Fly|Ride"] = 158.82, ["Neon|Ride"] = 356.25, ["Neon|Fly|Ride"] = 304.5, ["Mega|Fly|Ride"] = 1190.44}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 3.94, ["Ride"] = 38.74, ["Fly|Ride"] = 69.91, ["Neon"] = 26.25, ["Neon|Fly"] = 264.58, ["Neon|Ride"] = 91.66, ["Neon|Fly|Ride"] = 556.24, ["Mega"] = 117.72, ["Mega|Fly"] = 1111.43, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 392.44}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 18.32, ["Fly"] = 65.63, ["Ride"] = 32.82, ["Fly|Ride"] = 104.19, ["Neon"] = 278.09, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 139.65, ["Mega"] = 1050, ["Mega|Fly|Ride"] = 623.95}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 35.44, ["Ride"] = 116.17, ["Fly|Ride"] = 270.84, ["Neon"] = 108.48, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 2083.26}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 14.89, ["Fly"] = 81.41, ["Ride"] = 39.58, ["Fly|Ride"] = 82.69, ["Neon"] = 103.69, ["Neon|Ride"] = 170.79, ["Neon|Fly|Ride"] = 166.68, ["Mega"] = 624.99, ["Mega|Fly|Ride"] = 932.27}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 7061.25, ["Ride"] = 5446.88, ["Fly|Ride"] = 4373.25, ["Neon"] = 30556.03, ["Neon|Fly|Ride"] = 24998.98, ["Mega|Fly|Ride"] = 99202.14}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 263.82, ["Fly"] = 288.48, ["Ride"] = 234.94, ["Fly|Ride"] = 275.63, ["Neon|Ride"] = 624.99, ["Neon|Fly|Ride"] = 660.4, ["Mega|Fly|Ride"] = 2187.15}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 26.24, ["Fly"] = 69.25, ["Ride"] = 56.44, ["Fly|Ride"] = 118.76, ["Neon"] = 75.86, ["Neon|Fly"] = 241.5, ["Neon|Ride"] = 94.5, ["Neon|Fly|Ride"] = 181.26, ["Mega"] = 340.36, ["Mega|Fly"] = 520.83, ["Mega|Ride"] = 355.69, ["Mega|Fly|Ride"] = 473.17}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.63, ["Fly"] = 40.4, ["Ride"] = 28.14, ["Fly|Ride"] = 97.93, ["Neon"] = 26.23, ["Neon|Ride"] = 56.69, ["Mega"] = 140.44}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 33.49, ["Fly"] = 83.35, ["Ride"] = 62.32, ["Fly|Ride"] = 131.25, ["Neon"] = 137.51, ["Neon|Fly"] = 307.3, ["Neon|Ride"] = 196.2, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 420.83, ["Mega|Ride"] = 448.02, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 18571.88, ["Ride"] = 14583.19, ["Fly|Ride"] = 11156.25, ["Neon|Fly|Ride"] = 23625}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 135.43, ["Ride"] = 196.88, ["Fly|Ride"] = 393.75, ["Neon"] = 2083.26, ["Neon|Fly|Ride"] = 1083.31, ["Mega|Fly|Ride"] = 6770.57}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 56.26, ["Fly"] = 459.38, ["Ride"] = 47.06, ["Fly|Ride"] = 98.6, ["Neon|Fly"] = 461.56, ["Neon|Ride"] = 264.58, ["Neon|Fly|Ride"] = 286.47, ["Mega|Fly|Ride"] = 1241.63}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 9.3, ["Ride"] = 20.85, ["Fly|Ride"] = 64.32, ["Neon"] = 65.14, ["Neon|Ride"] = 110.79, ["Neon|Fly|Ride"] = 172.17, ["Mega"] = 2499.91, ["Mega|Ride"] = 492.19, ["Mega|Fly|Ride"] = 1041.64}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 426.57, ["Fly"] = 833.32, ["Ride"] = 446.23, ["Fly|Ride"] = 484.32, ["Neon"] = 1431.21, ["Neon|Ride"] = 1323, ["Neon|Fly|Ride"] = 1417.5, ["Mega|Fly|Ride"] = 5547.7}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 6.45, ["Fly"] = 50.78, ["Ride"] = 42, ["Fly|Ride"] = 92.32, ["Neon"] = 17.33, ["Neon|Ride"] = 101.17, ["Neon|Fly|Ride"] = 139.59, ["Mega"] = 98.44, ["Mega|Ride"] = 178.5, ["Mega|Fly|Ride"] = 249.98}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 117.29, ["Fly"] = 393.75, ["Ride"] = 164.07, ["Fly|Ride"] = 208.69, ["Neon"] = 520.77, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 500, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 1785, ["Mega|Fly|Ride"] = 1929.1}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 17.26, ["Fly"] = 20.04, ["Ride"] = 22.76, ["Fly|Ride"] = 39.38, ["Neon|Ride"] = 101.56, ["Neon|Fly|Ride"] = 81.38, ["Mega"] = 2499.91, ["Mega|Fly|Ride"] = 566.66}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 10.43}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 65.63, ["Ride"] = 166.68, ["Fly|Ride"] = 525, ["Neon"] = 393.75, ["Neon|Fly"] = 1666.62, ["Neon|Ride"] = 375, ["Neon|Fly|Ride"] = 350.47, ["Mega|Ride"] = 2231.25, ["Mega|Fly|Ride"] = 1523.12}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 13.7, ["Ride"] = 31.42, ["Fly|Ride"] = 68.61, ["Neon"] = 97.13, ["Neon|Ride"] = 123.96, ["Neon|Fly|Ride"] = 218.67, ["Mega"] = 618.75, ["Mega|Ride"] = 459.37, ["Mega|Fly|Ride"] = 936.08}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 15.69}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 34.13, ["Fly"] = 210, ["Ride"] = 78.14, ["Fly|Ride"] = 97.93, ["Neon"] = 133.88, ["Neon|Ride"] = 79.72, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1528.08, ["Mega|Ride"] = 729.15, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 4.72, ["Ride"] = 22.93, ["Fly|Ride"] = 118.13, ["Neon"] = 19.04, ["Neon|Ride"] = 136.47, ["Neon|Fly|Ride"] = 321.57, ["Mega"] = 139.59, ["Mega|Ride"] = 333.34, ["Mega|Fly|Ride"] = 416.67}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 14.44, ["Fly"] = 56.26, ["Ride"] = 30.18, ["Fly|Ride"] = 91.87, ["Neon"] = 139.59, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 220.84, ["Mega|Ride"] = 616.19, ["Mega|Fly|Ride"] = 691.65}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 393.75, ["Fly"] = 437.75, ["Ride"] = 322.88, ["Fly|Ride"] = 387.19, ["Neon|Fly|Ride"] = 1722.86, ["Mega|Fly|Ride"] = 8611.12}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 43.31, ["Ride"] = 64.32, ["Fly|Ride"] = 69.8, ["Neon"] = 253.32, ["Neon|Ride"] = 236.25, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 895.82}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 62.51, ["Ride"] = 69.8, ["Neon|Ride"] = 833.32, ["Neon|Fly|Ride"] = 630, ["Mega|Ride"] = 556.24, ["Mega|Fly|Ride"] = 1329.13}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 17.78, ["Fly"] = 79.17, ["Ride"] = 53.09, ["Fly|Ride"] = 111.47, ["Neon"] = 93.01, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 616.19, ["Mega|Ride"] = 380.63, ["Mega|Fly|Ride"] = 529.65}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 11077.18, ["Ride"] = 11077.18, ["Fly|Ride"] = 7698.13, ["Neon|Fly|Ride"] = 16905, ["Mega|Fly|Ride"] = 39372.9}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 2232.56, ["Ride"] = 2001.57, ["Fly|Ride"] = 1870.32, ["Neon"] = 4593.75, ["Neon|Fly|Ride"] = 5209.32, ["Mega|Fly|Ride"] = 18900}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 415.62, ["Ride"] = 236.25, ["Fly|Ride"] = 541.66, ["Neon"] = 1389.54, ["Neon|Ride"] = 1384.69, ["Neon|Fly|Ride"] = 1389.54, ["Mega"] = 16665.98, ["Mega|Fly|Ride"] = 6353.92}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 13.73, ["Fly"] = 35.42, ["Ride"] = 23.63, ["Fly|Ride"] = 51.19, ["Neon"] = 115.4, ["Neon|Ride"] = 97.93, ["Neon|Fly|Ride"] = 166.68, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 5.85, ["Ride"] = 61.69, ["Fly|Ride"] = 153.57, ["Neon"] = 24.83, ["Neon|Ride"] = 56.26, ["Mega"] = 157.5}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 33.47, ["Fly"] = 85.32, ["Ride"] = 52.11, ["Fly|Ride"] = 97.93, ["Neon"] = 139.59, ["Neon|Ride"] = 206.27, ["Neon|Fly|Ride"] = 222.89, ["Mega|Fly|Ride"] = 775.31}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 2.1, ["Fly"] = 24.94, ["Ride"] = 19.8, ["Fly|Ride"] = 44.62, ["Neon"] = 22.93, ["Neon|Fly"] = 69.8, ["Neon|Ride"] = 35.42, ["Neon|Fly|Ride"] = 71.91, ["Mega"] = 472.5, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 341.25, ["Fly"] = 314.99, ["Ride"] = 317.01, ["Fly|Ride"] = 399, ["Neon"] = 903.1, ["Neon|Ride"] = 1341.63, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 3890.48}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 20.85, ["Fly"] = 62.51, ["Ride"] = 41.88, ["Fly|Ride"] = 87.71, ["Neon"] = 277.08, ["Neon|Fly"] = 461.56, ["Neon|Ride"] = 215.77, ["Neon|Fly|Ride"] = 236.25, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 903.1}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 13.86, ["Fly"] = 18.36, ["Ride"] = 27.09, ["Fly|Ride"] = 45.85, ["Neon"] = 62.33, ["Neon|Fly"] = 136.5, ["Neon|Ride"] = 108.47, ["Neon|Fly|Ride"] = 116.82, ["Mega"] = 520.83, ["Mega|Ride"] = 573.95, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 328.13, ["Fly"] = 787.5, ["Ride"] = 525, ["Fly|Ride"] = 677.07, ["Mega|Fly|Ride"] = 8055.93}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1050, ["Ride"] = 1290.19, ["Fly|Ride"] = 1340.59, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 16925.01}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 84, ["Fly"] = 115.4, ["Ride"] = 78.75, ["Fly|Ride"] = 100.41, ["Neon"] = 495.84, ["Neon|Ride"] = 416.06, ["Neon|Fly|Ride"] = 525, ["Mega|Fly|Ride"] = 1573.69}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 182.3, ["Fly"] = 328.13, ["Ride"] = 246.94, ["Fly|Ride"] = 245.44, ["Neon"] = 1077.72, ["Neon|Fly"] = 694.78, ["Neon|Ride"] = 769.64, ["Neon|Fly|Ride"] = 652.3, ["Mega|Ride"] = 7290.94, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 28.13, ["Ride"] = 64.32, ["Neon"] = 272.92, ["Neon|Ride"] = 278.13, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 923.11, ["Mega|Fly|Ride"] = 1032.73}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 143.07, ["Ride"] = 572.91, ["Fly|Ride"] = 597.19, ["Neon"] = 1528.08, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 2972.82}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 1771.88, ["Fly"] = 2499.91, ["Ride"] = 2083.26, ["Fly|Ride"] = 1967.44, ["Mega|Fly|Ride"] = 33193.42}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 83.35, ["Ride"] = 61.69, ["Fly|Ride"] = 260.79, ["Neon"] = 286.47, ["Neon|Fly|Ride"] = 307.26, ["Mega"] = 1945.76, ["Mega|Ride"] = 2291.59, ["Mega|Fly|Ride"] = 1949.93}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 630, ["Fly"] = 675.94, ["Ride"] = 616.19, ["Fly|Ride"] = 668.07, ["Neon|Ride"] = 1445.61, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 2782.5}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 54.17, ["Fly"] = 137.38, ["Ride"] = 41.96, ["Fly|Ride"] = 115.64, ["Neon"] = 208.34, ["Neon|Ride"] = 513.45, ["Neon|Fly|Ride"] = 208.69, ["Mega|Fly|Ride"] = 895.7}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.72, ["Fly"] = 26.25, ["Ride"] = 19.69, ["Fly|Ride"] = 43.86, ["Neon"] = 19.67, ["Neon|Fly"] = 62.99, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 84, ["Mega"] = 122.93, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 53.82, ["Ride"] = 64.6, ["Fly|Ride"] = 252, ["Neon"] = 694.78, ["Neon|Ride"] = 764.56, ["Neon|Fly|Ride"] = 308.11, ["Mega"] = 1384.66, ["Mega|Ride"] = 1111.43, ["Mega|Fly|Ride"] = 6944.53}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 611.45, ["Fly"] = 899.07, ["Ride"] = 611.45, ["Fly|Ride"] = 613.8, ["Neon"] = 1804.11, ["Neon|Ride"] = 2756.25, ["Neon|Fly|Ride"] = 1968.75, ["Mega|Fly|Ride"] = 5775}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 472.5, ["Ride"] = 573.95, ["Fly|Ride"] = 656.25, ["Neon"] = 8333, ["Neon|Ride"] = 4068.75, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 12499.5}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 14.42, ["Fly"] = 32.82, ["Ride"] = 22.08, ["Fly|Ride"] = 39.35, ["Neon"] = 208.34, ["Neon|Ride"] = 94.8, ["Neon|Fly|Ride"] = 125.9, ["Mega|Fly|Ride"] = 416.67}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 9.24, ["Ride"] = 23.08, ["Fly|Ride"] = 62.51, ["Neon"] = 69.74, ["Neon|Ride"] = 76.17, ["Neon|Fly|Ride"] = 182.33, ["Mega"] = 1968.75, ["Mega|Ride"] = 461.56, ["Mega|Fly|Ride"] = 473.95}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 3.63, ["Ride"] = 28.32, ["Fly|Ride"] = 90.63, ["Neon"] = 19.69, ["Neon|Fly"] = 111.47, ["Neon|Ride"] = 46.17, ["Neon|Fly|Ride"] = 278.13, ["Mega"] = 137.51, ["Mega|Ride"] = 186.38, ["Mega|Fly|Ride"] = 334.69}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 38.96, ["Fly"] = 57.7, ["Ride"] = 41.97, ["Fly|Ride"] = 139.59, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 239.59, ["Mega|Fly|Ride"] = 727.07}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 39.37, ["Ride"] = 77.33, ["Fly|Ride"] = 616.19, ["Neon"] = 336.99, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 972.89, ["Mega|Ride"] = 1041.64, ["Mega|Fly|Ride"] = 1247.88}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 18.38, ["Fly"] = 57.14, ["Ride"] = 36.74, ["Fly|Ride"] = 72.17, ["Neon"] = 78.75, ["Neon|Ride"] = 92.93, ["Neon|Fly|Ride"] = 119.37, ["Mega|Ride"] = 375, ["Mega|Fly|Ride"] = 515.63}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 37.37, ["Fly"] = 87.68, ["Ride"] = 38.07, ["Fly|Ride"] = 106.25, ["Neon"] = 345.83, ["Neon|Ride"] = 228.43, ["Neon|Fly|Ride"] = 278.13, ["Mega"] = 2100, ["Mega|Fly|Ride"] = 1118.57}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.93, ["Fly"] = 41.68, ["Ride"] = 16.99, ["Fly|Ride"] = 42.4, ["Neon"] = 25.4, ["Neon|Ride"] = 45.02, ["Neon|Fly|Ride"] = 104.16, ["Mega"] = 177.19, ["Mega|Ride"] = 181.26, ["Mega|Fly|Ride"] = 394.79}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 5.31, ["Fly"] = 65.63, ["Ride"] = 28.67, ["Fly|Ride"] = 1825.44, ["Neon"] = 24.2, ["Neon|Fly"] = 154.63, ["Neon|Ride"] = 41.68, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 230.76, ["Mega|Ride"] = 154.63, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 36.74, ["Fly"] = 79.17, ["Ride"] = 56.25, ["Fly|Ride"] = 104.16, ["Neon"] = 414.58, ["Neon|Ride"] = 230.78, ["Neon|Fly|Ride"] = 157.35, ["Mega|Fly|Ride"] = 917.68}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 2222.83, ["Fly"] = 2462.38, ["Ride"] = 2231.25, ["Fly|Ride"] = 2099.99, ["Neon|Ride"] = 5416.46, ["Neon|Fly|Ride"] = 3937.5, ["Mega|Fly|Ride"] = 14437.5}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 472.91, ["Fly"] = 681.23, ["Ride"] = 416.67, ["Fly|Ride"] = 461.56, ["Neon"] = 3077.4, ["Neon|Ride"] = 2361.37, ["Neon|Fly|Ride"] = 1771.88, ["Mega|Fly|Ride"] = 8330.91}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 292.42, ["Ride"] = 393.75, ["Fly|Ride"] = 399, ["Neon"] = 1437.45, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1585.43, ["Mega|Fly|Ride"] = 5906.25}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 45.36}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 40.4, ["Fly"] = 65.63, ["Ride"] = 54.63, ["Fly|Ride"] = 78.75, ["Neon"] = 288.75, ["Neon|Ride"] = 230.22, ["Neon|Fly|Ride"] = 317.92, ["Mega|Ride"] = 1458.29, ["Mega|Fly|Ride"] = 1423.92}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 33331.96, ["Fly"] = 23625, ["Ride"] = 34616.15, ["Fly|Ride"] = 15750, ["Neon|Fly|Ride"] = 36748.69, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 249.38, ["Fly"] = 346.18, ["Ride"] = 280.54, ["Fly|Ride"] = 400.4, ["Neon"] = 909.36, ["Neon|Fly"] = 1086.96, ["Neon|Ride"] = 933.19, ["Neon|Fly|Ride"] = 731.07, ["Mega"] = 3473.84, ["Mega|Ride"] = 5027.93, ["Mega|Fly|Ride"] = 2488.49}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 5250, ["Ride"] = 249.38, ["Fly|Ride"] = 257.25, ["Neon|Fly|Ride"] = 833.32, ["Mega|Fly|Ride"] = 4027.97}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 78.75, ["Ride"] = 91.88, ["Fly|Ride"] = 208.69, ["Neon|Ride"] = 520.83, ["Neon|Fly|Ride"] = 520.83, ["Mega"] = 13889.03, ["Mega|Fly|Ride"] = 3124.89}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 13.11, ["Fly"] = 94.5, ["Ride"] = 39.59, ["Fly|Ride"] = 86.46, ["Neon|Ride"] = 83.35, ["Neon|Fly|Ride"] = 262.5, ["Mega|Fly|Ride"] = 556.24}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 3536.69, ["Ride"] = 3630.38, ["Fly|Ride"] = 4262.34, ["Neon|Fly|Ride"] = 15750}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 28.39, ["Fly"] = 45.94, ["Ride"] = 31.46, ["Fly|Ride"] = 64.3, ["Neon"] = 131.25, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 229.69, ["Mega|Fly|Ride"] = 632.63}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 37.51, ["Fly"] = 139.59, ["Ride"] = 53.43, ["Fly|Ride"] = 87.28, ["Neon"] = 154.63, ["Neon|Ride"] = 278.13, ["Neon|Fly|Ride"] = 367.5, ["Mega|Fly|Ride"] = 831.23}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 580.13, ["Fly"] = 682.5, ["Ride"] = 588, ["Fly|Ride"] = 713.98, ["Neon"] = 1181.25, ["Neon|Ride"] = 1706.25, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 4022.82}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 17.07, ["Fly"] = 27.43, ["Ride"] = 19.69, ["Fly|Ride"] = 48.47, ["Neon|Fly"] = 187.51, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 694.78, ["Mega|Fly|Ride"] = 523.68}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 17.33, ["Ride"] = 139.57, ["Fly|Ride"] = 461.56, ["Neon"] = 69.55, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 230.78}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 98.44, ["Fly"] = 139.59, ["Ride"] = 125.01, ["Fly|Ride"] = 166.68, ["Neon"] = 694.78, ["Neon|Ride"] = 616.19, ["Neon|Fly|Ride"] = 809.82, ["Mega|Ride"] = 2341.58, ["Mega|Fly|Ride"] = 2373}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 23.63, ["Ride"] = 77.6, ["Fly|Ride"] = 132.3, ["Neon"] = 83.53, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 262.5, ["Mega|Fly"] = 656.25, ["Mega|Ride"] = 293.01, ["Mega|Fly|Ride"] = 392.44}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 4196.52, ["Fly"] = 3852.99, ["Ride"] = 3281.25, ["Fly|Ride"] = 3150, ["Neon"] = 9027.76, ["Neon|Ride"] = 16925.01, ["Neon|Fly|Ride"] = 7868.44, ["Mega"] = 62497.41, ["Mega|Fly|Ride"] = 38463.16}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 34.37, ["Ride"] = 85.32, ["Fly|Ride"] = 103.15, ["Neon"] = 278.13, ["Neon|Ride"] = 206.27, ["Neon|Fly|Ride"] = 328.13, ["Mega|Fly|Ride"] = 833.32}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 9027.76, ["Ride"] = 8307.89, ["Fly|Ride"] = 5880, ["Neon|Fly|Ride"] = 15750, ["Mega|Fly|Ride"] = 62428.67}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 18.88, ["Fly|Ride"] = 41.26, ["Neon"] = 20.84, ["Neon|Fly"] = 139.59, ["Neon|Ride"] = 40.63, ["Neon|Fly|Ride"] = 83.93, ["Mega"] = 446.57, ["Mega|Fly|Ride"] = 222.93}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 19.69, ["Fly"] = 35.44, ["Ride"] = 33.28, ["Fly|Ride"] = 48.57, ["Neon"] = 139.59, ["Neon|Ride"] = 278.1, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 1401.1, ["Mega|Fly|Ride"] = 920.8}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 2.88}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 14.44, ["Ride"] = 28.88, ["Fly|Ride"] = 139.59, ["Neon"] = 110.42, ["Neon|Ride"] = 153.57, ["Neon|Fly|Ride"] = 170.63, ["Mega|Ride"] = 693.74, ["Mega|Fly|Ride"] = 846.97}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 35.41, ["Fly"] = 69.8, ["Ride"] = 69.78, ["Neon"] = 177.09, ["Neon|Ride"] = 181.22, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 840, ["Mega|Ride"] = 923.11, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 11.58, ["Fly"] = 23.98, ["Ride"] = 23.09, ["Fly|Ride"] = 39.38, ["Neon"] = 53.13, ["Neon|Ride"] = 174.57, ["Neon|Fly|Ride"] = 161.54, ["Mega"] = 1112.47, ["Mega|Fly|Ride"] = 945}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 7999.98}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2812.05}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 34.13}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 369.21, ["Fly"] = 556.24, ["Ride"] = 139.59, ["Fly|Ride"] = 656.25, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 2208.26, ["Mega|Fly|Ride"] = 5556.03}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 27.55, ["Fly"] = 131.27, ["Ride"] = 56.26, ["Fly|Ride"] = 131.25, ["Neon"] = 208.34, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 385.41, ["Mega|Ride"] = 623.95, ["Mega|Fly|Ride"] = 729.15}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 12.52}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 9.18, ["Ride"] = 56.26, ["Neon"] = 70.88, ["Neon|Ride"] = 249.38}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2572.5}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 156.19, ["Ride"] = 308.11, ["Fly|Ride"] = 289.59, ["Neon"] = 556.24, ["Neon|Ride"] = 694.78, ["Neon|Fly|Ride"] = 833.32, ["Mega|Fly|Ride"] = 2111.39}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 137.51, ["Ride"] = 172.92, ["Fly|Ride"] = 278.13, ["Neon"] = 406.25, ["Neon|Ride"] = 416.67, ["Neon|Fly|Ride"] = 556.24, ["Mega|Ride"] = 1575, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 183.75, ["Fly"] = 208.34, ["Ride"] = 145.69, ["Fly|Ride"] = 204.75, ["Neon"] = 876.95, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 909.36, ["Mega|Ride"] = 3469.67, ["Mega|Fly|Ride"] = 2937.38}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1089.38, ["Fly"] = 2499.91, ["Ride"] = 1116.94, ["Fly|Ride"] = 1102.5, ["Neon"] = 4833.14, ["Neon|Fly|Ride"] = 4462.5, ["Mega|Fly|Ride"] = 20832.48}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 14.36, ["Fly"] = 81.82, ["Ride"] = 45.85, ["Fly|Ride"] = 86.63, ["Neon"] = 139.59, ["Neon|Ride"] = 139.59, ["Neon|Fly|Ride"] = 416.67, ["Mega"] = 728.11, ["Mega|Fly|Ride"] = 903.1}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 656.25, ["Fly"] = 2100, ["Ride"] = 694.68, ["Fly|Ride"] = 833.32, ["Neon|Fly|Ride"] = 4000.49}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 49.88}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 15.28, ["Fly"] = 144.38, ["Ride"] = 39.38, ["Fly|Ride"] = 98.44, ["Neon"] = 73.5, ["Neon|Ride"] = 154.63, ["Neon|Fly|Ride"] = 486.45, ["Mega"] = 334.69, ["Mega|Ride"] = 418.69, ["Mega|Fly|Ride"] = 485.63}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 9.44, ["Fly"] = 28.14, ["Ride"] = 27.09, ["Fly|Ride"] = 65.63, ["Neon"] = 69.78, ["Neon|Ride"] = 97.93, ["Neon|Fly|Ride"] = 200.16, ["Mega|Ride"] = 385.41, ["Mega|Fly|Ride"] = 619.5}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 89.57}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 24.1, ["Ride"] = 38.06, ["Fly|Ride"] = 65.54, ["Neon"] = 177.19, ["Neon|Ride"] = 222.93, ["Neon|Fly|Ride"] = 277.08, ["Mega"] = 807.28, ["Mega|Ride"] = 833.32, ["Mega|Fly|Ride"] = 653.12}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 41.68, ["Fly"] = 53.09, ["Ride"] = 61.59, ["Fly|Ride"] = 66.68, ["Neon"] = 154.63, ["Neon|Fly"] = 240.02, ["Neon|Ride"] = 278.25, ["Neon|Fly|Ride"] = 274.32, ["Mega"] = 1389.54, ["Mega|Fly|Ride"] = 917.44}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 5667.38, ["Fly"] = 11111.01, ["Ride"] = 6206.01, ["Fly|Ride"] = 4856.25, ["Neon|Ride"] = 12082.85, ["Neon|Fly|Ride"] = 10078.69, ["Mega|Fly|Ride"] = 34648.69}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 12.52, ["Ride"] = 35.42, ["Fly|Ride"] = 115.4, ["Neon"] = 69.78, ["Neon|Fly"] = 125.01, ["Neon|Ride"] = 85.31, ["Mega"] = 459.37, ["Mega|Ride"] = 385.34, ["Mega|Fly|Ride"] = 431.5}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 27.09}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 91.87, ["Fly"] = 368.75, ["Ride"] = 139.39, ["Fly|Ride"] = 157.5, ["Neon"] = 418.69, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 575, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 72.17, ["Fly"] = 183.75, ["Ride"] = 125.01, ["Fly|Ride"] = 168, ["Neon"] = 278.13, ["Neon|Ride"] = 380.63, ["Neon|Fly|Ride"] = 764.56, ["Mega|Ride"] = 1312.46, ["Mega|Fly|Ride"] = 1285.38}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 18.47, ["Fly"] = 70.86, ["Ride"] = 31.26, ["Fly|Ride"] = 57.75, ["Neon"] = 181.26, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 160.13, ["Mega|Fly|Ride"] = 590.62}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 6.57, ["Fly"] = 49.87, ["Ride"] = 33.34, ["Fly|Ride"] = 99.25, ["Neon"] = 19.69, ["Neon|Fly"] = 181.26, ["Neon|Ride"] = 64.6, ["Neon|Fly|Ride"] = 130.12, ["Mega"] = 122.07, ["Mega|Fly"] = 7034.11, ["Mega|Ride"] = 164.07, ["Mega|Fly|Ride"] = 250.52}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 11.34, ["Fly"] = 73.86, ["Ride"] = 35.44, ["Fly|Ride"] = 83.35, ["Neon"] = 62.51, ["Neon|Ride"] = 96.48, ["Neon|Fly|Ride"] = 200.8, ["Mega|Ride"] = 419.99, ["Mega|Fly|Ride"] = 538.13}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 26.24, ["Fly"] = 31.98, ["Ride"] = 31.26, ["Fly|Ride"] = 60.43, ["Neon"] = 139.59, ["Neon|Fly"] = 208.34, ["Neon|Ride"] = 187.51, ["Neon|Fly|Ride"] = 118.13, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 217.88}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 25.02, ["Ride"] = 103.85, ["Neon"] = 103.69, ["Mega"] = 486.45, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 1340.59}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 77.44, ["Ride"] = 208.34, ["Fly|Ride"] = 358.34, ["Neon|Ride"] = 418.69, ["Neon|Fly|Ride"] = 753.12}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 41.96, ["Ride"] = 94.5, ["Fly|Ride"] = 223.13, ["Neon"] = 259.88, ["Neon|Ride"] = 303.38, ["Neon|Fly|Ride"] = 354.17, ["Mega"] = 1148.44, ["Mega|Ride"] = 1248.93, ["Mega|Fly|Ride"] = 1233.75}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 649.69, ["Fly"] = 656.25, ["Ride"] = 691.69, ["Fly|Ride"] = 761.24, ["Neon|Ride"] = 2100, ["Neon|Fly|Ride"] = 1890, ["Mega|Fly|Ride"] = 6429.94}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 262.5, ["Ride"] = 346.5, ["Fly|Ride"] = 312.46, ["Neon"] = 1278.09, ["Neon|Ride"] = 2083.26, ["Neon|Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 4056.68}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 108.33}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 10.43, ["Fly"] = 23.09, ["Ride"] = 25.74, ["Fly|Ride"] = 41.97, ["Neon"] = 80.07, ["Neon|Fly"] = 230.99, ["Neon|Ride"] = 115.64, ["Neon|Fly|Ride"] = 127.32, ["Mega|Ride"] = 416.67, ["Mega|Fly|Ride"] = 405.57}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 307.13, ["Fly"] = 624.99, ["Ride"] = 345.19, ["Fly|Ride"] = 459.38, ["Neon"] = 2761.36, ["Neon|Ride"] = 1010.63, ["Neon|Fly|Ride"] = 971.25, ["Mega"] = 4166.51, ["Mega|Fly|Ride"] = 3229.05}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 14.44}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 97.13, ["Fly"] = 590.63, ["Ride"] = 131.25, ["Fly|Ride"] = 258.35, ["Neon"] = 444.94, ["Neon|Fly"] = 1389.54, ["Neon|Ride"] = 485.63, ["Neon|Fly|Ride"] = 570.94, ["Mega"] = 2499.91, ["Mega|Fly|Ride"] = 1705.2}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 135.43, ["Ride"] = 157.5, ["Fly|Ride"] = 214.64, ["Neon"] = 890.8, ["Neon|Ride"] = 997.5, ["Neon|Fly|Ride"] = 694.78}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 7.86, ["Ride"] = 25.4, ["Fly|Ride"] = 104.19, ["Neon"] = 26.04, ["Neon|Ride"] = 82.3, ["Neon|Fly|Ride"] = 166.68, ["Mega"] = 194.8, ["Mega|Ride"] = 202.06, ["Mega|Fly|Ride"] = 404.16}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 14.44, ["Fly"] = 49.88, ["Ride"] = 28.14, ["Fly|Ride"] = 65.63, ["Neon"] = 110.42, ["Neon|Ride"] = 154.18, ["Neon|Fly|Ride"] = 258.35}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 25.02, ["Fly"] = 139.59, ["Ride"] = 39.38, ["Fly|Ride"] = 139.59, ["Neon"] = 185.38, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 208.34, ["Mega|Ride"] = 485.36, ["Mega|Fly|Ride"] = 548.96}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 5.25, ["Fly"] = 333.34, ["Ride"] = 52.5, ["Fly|Ride"] = 196.88, ["Neon"] = 19.67, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 124.29, ["Mega|Fly"] = 183.75, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 314.45, ["Fly"] = 918.75, ["Ride"] = 276.94, ["Fly|Ride"] = 301.88, ["Neon"] = 1666.62, ["Neon|Ride"] = 1384.66, ["Neon|Fly|Ride"] = 1378.13}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 83.84, ["Fly"] = 1050, ["Ride"] = 135.19, ["Fly|Ride"] = 247.86, ["Neon"] = 433.13, ["Neon|Ride"] = 426.43, ["Neon|Fly|Ride"] = 525, ["Mega"] = 2431.16, ["Mega|Ride"] = 2042.64, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 82.69, ["Fly"] = 154.18, ["Ride"] = 82.69, ["Fly|Ride"] = 140.44, ["Neon|Ride"] = 288.75, ["Neon|Fly|Ride"] = 456.25, ["Mega|Fly|Ride"] = 1515.94}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 15.75, ["Ride"] = 56.25, ["Fly|Ride"] = 278.13, ["Neon"] = 208.34, ["Neon|Ride"] = 586.18, ["Neon|Fly|Ride"] = 486.45, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 20.85, ["Fly"] = 41.68, ["Ride"] = 48.98, ["Fly|Ride"] = 92.32, ["Neon"] = 111.56, ["Neon|Ride"] = 115.64, ["Neon|Fly|Ride"] = 165.61, ["Mega"] = 479.11, ["Mega|Fly"] = 525, ["Mega|Ride"] = 472.5, ["Mega|Fly|Ride"] = 444.94}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.29, ["Fly"] = 41.68, ["Ride"] = 21, ["Fly|Ride"] = 136.47, ["Neon"] = 17.32, ["Neon|Ride"] = 39.24, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 122.91, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 213.94}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 1023.75, ["Fly"] = 1111.43, ["Ride"] = 984.38, ["Fly|Ride"] = 984.38, ["Neon"] = 2231.25, ["Neon|Fly"] = 2812.4, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2401.88, ["Mega"] = 11805.77, ["Mega|Fly|Ride"] = 7481.25}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 304.64, ["Ride"] = 313.69, ["Fly|Ride"] = 326.82, ["Neon"] = 1041.64, ["Neon|Ride"] = 1036.88, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 10416.25, ["Mega|Fly|Ride"] = 4037.35}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 143.76, ["Ride"] = 145.69, ["Fly|Ride"] = 308.11, ["Neon"] = 360.03, ["Neon|Ride"] = 320.25, ["Neon|Fly|Ride"] = 333.3, ["Mega"] = 1181.25, ["Mega|Ride"] = 1666.62, ["Mega|Fly|Ride"] = 1524.58}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 177.19, ["Ride"] = 209.95, ["Fly|Ride"] = 288.75, ["Neon"] = 694.78, ["Neon|Ride"] = 905.63, ["Neon|Fly|Ride"] = 972.89, ["Mega"] = 10416.25, ["Mega|Fly|Ride"] = 2887.49}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 20.98, ["Fly"] = 47.94, ["Ride"] = 35.44, ["Fly|Ride"] = 83.35, ["Neon"] = 154.63, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 157.5, ["Mega|Ride"] = 694.78, ["Mega|Fly|Ride"] = 619.12}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 346.5, ["Ride"] = 459.37, ["Fly|Ride"] = 556.24, ["Neon"] = 1584.98, ["Neon|Ride"] = 1115.63, ["Neon|Fly|Ride"] = 1378.13, ["Mega"] = 5250, ["Mega|Fly|Ride"] = 4845.65}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 117.72, ["Fly"] = 126, ["Ride"] = 69.8, ["Neon|Ride"] = 278.13, ["Mega|Fly|Ride"] = 2000.82}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1307.25, ["Ride"] = 1389.36, ["Fly|Ride"] = 1469.74, ["Neon|Ride"] = 4374.83, ["Neon|Fly|Ride"] = 3675, ["Mega"] = 49997.94, ["Mega|Fly|Ride"] = 24302.13}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 11.82, ["Fly"] = 64.58, ["Ride"] = 39.38, ["Fly|Ride"] = 110.24, ["Neon"] = 40.39, ["Neon|Fly"] = 166.18, ["Neon|Ride"] = 35.79, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 305.75, ["Mega|Ride"] = 261.94, ["Mega|Fly|Ride"] = 563.77}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 82.29, ["Ride"] = 83.93, ["Fly|Ride"] = 208.34, ["Neon"] = 314.99, ["Neon|Ride"] = 222.93, ["Neon|Fly|Ride"] = 416.67, ["Mega|Fly|Ride"] = 966.63}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 77.31, ["Fly"] = 78.75, ["Ride"] = 81.03, ["Fly|Ride"] = 104.19, ["Neon|Ride"] = 389.59, ["Neon|Fly|Ride"] = 393.73, ["Mega|Fly|Ride"] = 1469.99}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 2499.91, ["Ride"] = 918.75, ["Fly|Ride"] = 1076.25, ["Neon|Fly|Ride"] = 4199.99, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 470.16, ["Ride"] = 328.13, ["Fly|Ride"] = 400.32, ["Neon|Ride"] = 1737.45, ["Neon|Fly|Ride"] = 1452.04, ["Mega|Fly|Ride"] = 9077.53}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 128.36, ["Fly"] = 208.34, ["Ride"] = 164.07, ["Fly|Ride"] = 262.5, ["Neon"] = 462.46, ["Neon|Ride"] = 456.75, ["Neon|Fly|Ride"] = 519.49, ["Mega"] = 3958.18, ["Mega|Ride"] = 1704.94, ["Mega|Fly|Ride"] = 1839.53}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 11.82, ["Ride"] = 27.09, ["Fly|Ride"] = 87.94, ["Neon"] = 101.06, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 233.63, ["Mega"] = 278.13, ["Mega|Fly|Ride"] = 972.89}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 41.97, ["Fly"] = 95.82, ["Ride"] = 35.42, ["Fly|Ride"] = 90.63, ["Neon"] = 249.38, ["Neon|Fly"] = 403.12, ["Neon|Ride"] = 244.79, ["Neon|Fly|Ride"] = 311.46, ["Mega"] = 1806.18, ["Mega|Fly|Ride"] = 1049.99}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 851.82, ["Ride"] = 874.13, ["Fly|Ride"] = 943.69, ["Neon"] = 3264.47, ["Neon|Ride"] = 2828.44, ["Neon|Fly|Ride"] = 3020.73, ["Mega|Fly|Ride"] = 17360.76}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 758.63}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 4200, ["Ride"] = 4331.25, ["Fly|Ride"] = 4556.99, ["Neon|Ride"] = 29853.98, ["Neon|Fly|Ride"] = 16099.34, ["Mega|Fly|Ride"] = 88885.9}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 150.94, ["Fly"] = 408.19, ["Ride"] = 347.91, ["Fly|Ride"] = 403.12, ["Neon"] = 624.99, ["Neon|Ride"] = 639.57, ["Neon|Fly|Ride"] = 851.82, ["Mega"] = 5833.1, ["Mega|Fly|Ride"] = 6111.21}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 65.63, ["Ride"] = 97.92, ["Fly|Ride"] = 336, ["Neon|Ride"] = 463.54, ["Neon|Fly|Ride"] = 640.61}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 11.5, ["Fly"] = 131.25, ["Ride"] = 31.18, ["Fly|Ride"] = 91.88, ["Neon"] = 68.77, ["Neon|Ride"] = 115.5, ["Neon|Fly|Ride"] = 155.25, ["Mega|Ride"] = 833.32, ["Mega|Fly|Ride"] = 472.91}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 15.72, ["Fly"] = 28.32, ["Ride"] = 30.19, ["Fly|Ride"] = 53.82, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 2208.26}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 15.64, ["Ride"] = 39.38, ["Fly|Ride"] = 105, ["Neon"] = 108.48, ["Neon|Ride"] = 90.63, ["Neon|Fly|Ride"] = 187.69, ["Mega|Ride"] = 859.69, ["Mega|Fly|Ride"] = 687.4}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 6.26, ["Fly"] = 28.14, ["Ride"] = 20.85, ["Fly|Ride"] = 41.68, ["Neon"] = 21, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 308.11, ["Mega|Ride"] = 308.11, ["Mega|Fly|Ride"] = 357}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 32.82, ["Ride"] = 58.34, ["Fly|Ride"] = 164.07, ["Neon"] = 138.44, ["Neon|Ride"] = 308.06, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 666.66, ["Mega|Ride"] = 782.28, ["Mega|Fly|Ride"] = 729.15}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 239.46, ["Fly"] = 348.34, ["Ride"] = 257.25, ["Fly|Ride"] = 309.75, ["Neon"] = 720.82, ["Neon|Ride"] = 708.23, ["Neon|Fly|Ride"] = 732.38, ["Mega"] = 6562.5, ["Mega|Ride"] = 4166.51, ["Mega|Fly|Ride"] = 3799.68}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 3.56, ["Fly"] = 16.69, ["Ride"] = 16.42, ["Neon"] = 18.96, ["Neon|Fly"] = 92.32, ["Neon|Ride"] = 35.42, ["Neon|Fly|Ride"] = 74.82, ["Mega"] = 694.78, ["Mega|Ride"] = 733.32, ["Mega|Fly|Ride"] = 267.75}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 34.59, ["Fly"] = 138.49, ["Ride"] = 62.51, ["Fly|Ride"] = 129.93, ["Neon"] = 183.74, ["Neon|Fly"] = 288.75, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 248.07, ["Mega"] = 485.63, ["Mega|Ride"] = 520.99, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 761.25, ["Ride"] = 809.22, ["Fly|Ride"] = 786.19, ["Neon|Ride"] = 1945.76, ["Neon|Fly|Ride"] = 1575, ["Mega|Fly|Ride"] = 3937.5}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 19.67, ["Fly"] = 64.32, ["Ride"] = 34.92, ["Fly|Ride"] = 82.69, ["Neon"] = 125.01, ["Neon|Fly"] = 461.56, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 178.29, ["Mega"] = 1575, ["Mega|Ride"] = 972.89, ["Mega|Fly|Ride"] = 815.81}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 307.3, ["Fly"] = 316.32, ["Ride"] = 262.49, ["Fly|Ride"] = 324.96, ["Neon"] = 1389.54, ["Neon|Fly|Ride"] = 1296.75, ["Mega|Fly|Ride"] = 4426.91}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 115.4, ["Fly"] = 129.94, ["Ride"] = 128.63, ["Fly|Ride"] = 148.32, ["Neon"] = 624.99, ["Neon|Fly"] = 633.32, ["Neon|Ride"] = 556.24, ["Neon|Fly|Ride"] = 556.17, ["Mega"] = 2916.56, ["Mega|Fly|Ride"] = 1874.95}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 639.57, ["Ride"] = 525, ["Fly|Ride"] = 748.13, ["Neon"] = 2634.31, ["Neon|Ride"] = 2361.37, ["Neon|Fly|Ride"] = 2395.75, ["Mega|Fly|Ride"] = 7624.7}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 23.94, ["Ride"] = 52.5, ["Fly|Ride"] = 94.8, ["Neon"] = 61.69, ["Neon|Fly"] = 181.26, ["Neon|Ride"] = 103.87, ["Neon|Fly|Ride"] = 211.32, ["Mega"] = 415.62, ["Mega|Ride"] = 411.33, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 3739.37, ["Fly"] = 3956.54, ["Ride"] = 3936.19, ["Fly|Ride"] = 3143.6, ["Neon"] = 13853.61, ["Neon|Fly|Ride"] = 6944.53, ["Mega|Fly|Ride"] = 23745.75}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 72.93, ["Fly"] = 119.81, ["Ride"] = 72.19, ["Fly|Ride"] = 157.29, ["Neon"] = 394.78, ["Neon|Ride"] = 446.25, ["Neon|Fly|Ride"] = 400.32, ["Mega|Fly|Ride"] = 1766.61}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 27.09, ["Ride"] = 19.69, ["Fly|Ride"] = 47.25, ["Neon"] = 16.69, ["Neon|Fly"] = 44.63, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 111.47, ["Mega"] = 110.42, ["Mega|Fly"] = 452.82, ["Mega|Ride"] = 202.09, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.6, ["Ride"] = 31.5, ["Neon"] = 22.32, ["Neon|Ride"] = 69.8, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 147, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 278.2}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 97.93, ["Fly"] = 39.38, ["Ride"] = 40.69, ["Fly|Ride"] = 78.75, ["Neon|Ride"] = 694.78, ["Neon|Fly|Ride"] = 240.19, ["Mega|Fly|Ride"] = 1233.3}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 918.75, ["Ride"] = 1174.69, ["Fly|Ride"] = 1181.24, ["Neon"] = 3745.7, ["Neon|Fly|Ride"] = 4725, ["Mega|Fly|Ride"] = 26388.5}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 5139.39, ["Ride"] = 4944.6, ["Fly|Ride"] = 4890.43}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 16.69, ["Fly"] = 47.94, ["Ride"] = 23.63, ["Fly|Ride"] = 53.82, ["Neon|Ride"] = 144.8, ["Neon|Fly|Ride"] = 137.91, ["Mega"] = 2499.91, ["Mega|Fly|Ride"] = 553.11}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 19.08, ["Fly"] = 44.81, ["Ride"] = 35.41, ["Fly|Ride"] = 72.19, ["Neon"] = 94.48, ["Neon|Ride"] = 83.34, ["Neon|Fly|Ride"] = 165.38, ["Mega"] = 923.11, ["Mega|Ride"] = 769.64, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 38.04, ["Fly"] = 157.49, ["Ride"] = 40.65, ["Fly|Ride"] = 91.88, ["Neon|Ride"] = 245.44, ["Neon|Fly|Ride"] = 249.38, ["Mega|Fly|Ride"] = 859.69}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 217.88, ["Ride"] = 224.44, ["Fly|Ride"] = 296.83, ["Neon|Ride"] = 1354.5, ["Neon|Fly|Ride"] = 1139.55, ["Mega"] = 10416.25, ["Mega|Fly|Ride"] = 3692.4}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.92, ["Neon"] = 20.97, ["Neon|Fly"] = 70.95, ["Neon|Fly|Ride"] = 154.63, ["Mega"] = 139.55, ["Mega|Ride"] = 268.75, ["Mega|Fly|Ride"] = 307.3}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 183.75, ["Fly"] = 278.13, ["Ride"] = 223.13, ["Fly|Ride"] = 282.19, ["Neon"] = 731.24, ["Neon|Ride"] = 807.73, ["Neon|Fly|Ride"] = 923.11, ["Mega|Fly|Ride"] = 2624.99}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 3.81, ["Fly"] = 28.88, ["Ride"] = 18.38, ["Fly|Ride"] = 45.85, ["Neon"] = 39.59, ["Neon|Fly|Ride"] = 105, ["Mega"] = 461.56, ["Mega|Ride"] = 416.67, ["Mega|Fly|Ride"] = 416.67}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 223.25, ["Fly"] = 157.5, ["Ride"] = 236.4, ["Fly|Ride"] = 275.63, ["Neon|Fly|Ride"] = 890.6, ["Mega"] = 10416.25, ["Mega|Ride"] = 4166.51, ["Mega|Fly|Ride"] = 3749.87}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 12.79, ["Fly"] = 416.67, ["Ride"] = 28.88, ["Fly|Ride"] = 86.56, ["Neon"] = 52.5, ["Neon|Fly"] = 293.09, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 389.59, ["Mega"] = 459.37, ["Mega|Ride"] = 583.33, ["Mega|Fly|Ride"] = 459.32}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 3.67, ["Ride"] = 27.27, ["Fly|Ride"] = 157.5, ["Neon"] = 14.96, ["Neon|Fly"] = 170.63, ["Neon|Ride"] = 39.59, ["Neon|Fly|Ride"] = 163.79, ["Mega"] = 76.13, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 213.94}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 4.99, ["Mega"] = 154.63}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 2.1, ["Ride"] = 41.68, ["Fly|Ride"] = 216.67, ["Neon"] = 15.64, ["Neon|Ride"] = 41.56, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 77.62, ["Mega|Fly"] = 153850.29, ["Mega|Ride"] = 143.3, ["Mega|Fly|Ride"] = 254.18}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 78.75, ["Fly"] = 137.51, ["Ride"] = 97.93, ["Fly|Ride"] = 194.8, ["Neon"] = 262.5, ["Neon|Ride"] = 319.79, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 1215.59, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 1249.97}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 45.85, ["Ride"] = 18.38, ["Fly|Ride"] = 53.81, ["Neon"] = 3.93, ["Neon|Ride"] = 21.11, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 129.94, ["Mega|Ride"] = 135.43, ["Mega|Fly|Ride"] = 261.45}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 16.96, ["Ride"] = 97.93, ["Neon"] = 111.45, ["Neon|Ride"] = 111.47, ["Mega"] = 411.46, ["Mega|Ride"] = 556.24}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 77.1, ["Neon|Fly|Ride"] = 154.63, ["Mega"] = 12.71, ["Mega|Ride"] = 82.3, ["Mega|Fly|Ride"] = 278.13}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 17.07, ["Fly|Ride"] = 35.42, ["Neon"] = 2.1, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 43.77, ["Mega"] = 18.76, ["Mega|Ride"] = 25.99, ["Mega|Fly|Ride"] = 58.87}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Ride"] = 139.47, ["Fly|Ride"] = 45.86, ["Neon"] = 2.1, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 139.59, ["Mega"] = 18.47, ["Mega|Ride"] = 31.18, ["Mega|Fly|Ride"] = 122.93}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Mega"] = 69.8, ["Mega|Ride"] = 131.25}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 15.74, ["Ride"] = 17.45, ["Fly|Ride"] = 107.63, ["Neon"] = 8.35, ["Neon|Fly"] = 135.05, ["Neon|Ride"] = 91.66, ["Neon|Fly|Ride"] = 81.38, ["Mega"] = 219.26, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 95.85, ["Mega|Fly|Ride"] = 161.39}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Fly|Ride"] = 139.59, ["Mega"] = 23.08, ["Mega|Ride"] = 78.75}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 2.3, ["Fly"] = 47.09, ["Ride"] = 19.31, ["Fly|Ride"] = 56.26, ["Neon"] = 8.72, ["Neon|Fly"] = 37.96, ["Neon|Ride"] = 28.13, ["Neon|Fly|Ride"] = 62.51, ["Mega"] = 98.44, ["Mega|Fly"] = 78.75, ["Mega|Ride"] = 83.35, ["Mega|Fly|Ride"] = 180.64}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 26.17, ["Mega"] = 16.85, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 120.75}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.1, ["Ride"] = 140.63, ["Fly|Ride"] = 525, ["Neon"] = 23.09, ["Mega"] = 137.51, ["Mega|Ride"] = 157.5}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 4.99, ["Neon"] = 16.88}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Neon"] = 6.56, ["Neon|Ride"] = 36.95, ["Neon|Fly|Ride"] = 75.01, ["Mega"] = 22.49, ["Mega|Ride"] = 171.94}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 30.01, ["Ride"] = 18.38, ["Neon"] = 2.1, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 15.37, ["Neon|Fly|Ride"] = 41.88, ["Mega"] = 18.76, ["Mega|Fly"] = 41.68, ["Mega|Ride"] = 22.93, ["Mega|Fly|Ride"] = 43.32}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.59, ["Fly"] = 72.19, ["Ride"] = 218.19, ["Neon"] = 41.68, ["Mega"] = 250.01, ["Mega|Ride"] = 347.91}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 42, ["Fly|Ride"] = 78.73, ["Neon"] = 7.87, ["Neon|Ride"] = 1249.97, ["Mega"] = 45.94, ["Mega|Ride"] = 208.31, ["Mega|Fly|Ride"] = 139.57}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 2.1, ["Neon"] = 11.8, ["Neon|Fly|Ride"] = 139.59, ["Mega"] = 78.75, ["Mega|Ride"] = 233.63}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 6.3, ["Fly"] = 31.7, ["Ride"] = 31.65, ["Fly|Ride"] = 189.58, ["Neon"] = 10.43, ["Neon|Fly"] = 91.18, ["Neon|Ride"] = 48.98, ["Neon|Fly|Ride"] = 268.75, ["Mega"] = 209.77, ["Mega|Ride"] = 85.3, ["Mega|Fly|Ride"] = 278.13}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 39.29, ["Ride"] = 95.76, ["Neon"] = 2.1, ["Neon|Fly"] = 20.79, ["Neon|Ride"] = 18.76, ["Neon|Fly|Ride"] = 29.61, ["Mega"] = 17.07, ["Mega|Ride"] = 23.98, ["Mega|Fly|Ride"] = 55.13}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 3.82, ["Fly"] = 26.25, ["Ride"] = 19.65, ["Fly|Ride"] = 138.49, ["Neon"] = 15.64, ["Neon|Ride"] = 110.78, ["Neon|Fly|Ride"] = 73.97, ["Mega"] = 128.63, ["Mega|Ride"] = 125.01, ["Mega|Fly|Ride"] = 203.14}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 2.1, ["Fly|Ride"] = 139.59, ["Neon"] = 73.76, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 291.67, ["Mega|Ride"] = 277.55, ["Mega|Fly|Ride"] = 441.67}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 22.13, ["Ride"] = 14.05, ["Neon"] = 2.1, ["Neon|Fly"] = 23.63, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 32.82, ["Mega"] = 17.33, ["Mega|Fly"] = 156.19, ["Mega|Ride"] = 28.88, ["Mega|Fly|Ride"] = 98.43}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.1, ["Neon"] = 6.2, ["Neon|Fly"] = 77.1, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 105, ["Mega"] = 59.96, ["Mega|Ride"] = 118.13}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 28.49, ["Neon"] = 6.57, ["Neon|Fly"] = 154.18, ["Neon|Ride"] = 43.77, ["Neon|Fly|Ride"] = 308.11, ["Mega"] = 32.81, ["Mega|Ride"] = 65.64, ["Mega|Fly|Ride"] = 278.13}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Ride"] = 27.57, ["Neon"] = 2.1, ["Neon|Fly"] = 40.69, ["Neon|Ride"] = 47.94, ["Neon|Fly|Ride"] = 82.69, ["Mega"] = 18.38, ["Mega|Ride"] = 69.22}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 41.68, ["Ride"] = 17, ["Fly|Ride"] = 41.68, ["Neon"] = 6.56, ["Neon|Fly"] = 45.85, ["Neon|Ride"] = 27.09, ["Neon|Fly|Ride"] = 69.8, ["Mega"] = 94.5, ["Mega|Ride"] = 105}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.61, ["Ride"] = 40.69, ["Neon"] = 9.08, ["Neon|Ride"] = 154.63, ["Mega"] = 64.32, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 160.13}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 28.14, ["Ride"] = 15.64, ["Fly|Ride"] = 108.94, ["Neon"] = 6.03, ["Neon|Ride"] = 28.13, ["Neon|Fly|Ride"] = 62.33, ["Mega"] = 65.63, ["Mega|Fly"] = 125.01, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 16.99, ["Fly"] = 35.42, ["Ride"] = 80.99, ["Mega"] = 296.63, ["Mega|Fly|Ride"] = 844.06}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 3.94, ["Ride"] = 21, ["Fly|Ride"] = 5307.83, ["Neon"] = 11.8, ["Neon|Fly"] = 58.78, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 315, ["Mega|Fly|Ride"] = 553.11}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 9.24, ["Fly"] = 149.1, ["Ride"] = 27.09, ["Fly|Ride"] = 141.75, ["Neon"] = 20.84, ["Neon|Fly"] = 56.26, ["Neon|Ride"] = 28.14, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 196.88, ["Mega|Ride"] = 136.5, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.63, ["Fly"] = 79.47, ["Fly|Ride"] = 103.87, ["Neon"] = 71.37, ["Mega"] = 315}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 16.69, ["Mega"] = 694.78, ["Mega|Fly|Ride"] = 794.07}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 3.93, ["Ride"] = 262.5, ["Fly|Ride"] = 69.8, ["Neon"] = 15.64, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 125.01, ["Mega"] = 256.26}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 5.92, ["Ride"] = 69.8, ["Neon"] = 39.38, ["Neon|Ride"] = 97.93, ["Neon|Fly|Ride"] = 139.59, ["Mega"] = 189, ["Mega|Ride"] = 230.22, ["Mega|Fly|Ride"] = 312.5}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Ride"] = 119.81, ["Mega"] = 19.48, ["Mega|Ride"] = 69.8, ["Mega|Fly|Ride"] = 141.75}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 51.19}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 10.24, ["Fly"] = 15.74, ["Ride"] = 25.02, ["Fly|Ride"] = 56.26, ["Neon"] = 40.64, ["Neon|Fly"] = 69.8, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 106.31, ["Mega"] = 210, ["Mega|Ride"] = 230.78, ["Mega|Fly|Ride"] = 366.66}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 18.36, ["Fly|Ride"] = 70.62, ["Neon"] = 5.25, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 170.79, ["Mega"] = 19.69, ["Mega|Ride"] = 94.5, ["Mega|Fly|Ride"] = 261.45}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.63, ["Ride"] = 164.07, ["Fly|Ride"] = 385.02, ["Neon"] = 6.3, ["Neon|Ride"] = 40.64, ["Mega"] = 56.26, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.49, ["Fly"] = 45.94, ["Ride"] = 23.55, ["Neon"] = 20.98, ["Neon|Ride"] = 57.75, ["Neon|Fly|Ride"] = 95.85, ["Mega"] = 133.76, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 308.11}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 3.93, ["Neon"] = 43.77, ["Neon|Fly|Ride"] = 191.63, ["Mega"] = 393.75, ["Mega|Ride"] = 208.34, ["Mega|Fly|Ride"] = 415.62}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Neon"] = 3.86, ["Neon|Ride"] = 50.78, ["Mega"] = 16.79, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 50.78, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Ride"] = 56.26, ["Fly|Ride"] = 277766.58, ["Neon"] = 6.57, ["Neon|Fly"] = 30.18, ["Neon|Ride"] = 30.01, ["Neon|Fly|Ride"] = 68.77, ["Mega"] = 32.82, ["Mega|Fly"] = 100.02, ["Mega|Ride"] = 73.97, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 28.25, ["Ride"] = 21, ["Fly|Ride"] = 48.15, ["Neon"] = 8.54, ["Neon|Fly"] = 69.8, ["Neon|Ride"] = 23.37, ["Neon|Fly|Ride"] = 139.59, ["Mega"] = 56.26, ["Mega|Fly|Ride"] = 133.34}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Ride"] = 278.13, ["Neon"] = 4.6, ["Neon|Ride"] = 47.94, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 25.14, ["Mega|Ride"] = 62.99, ["Mega|Fly|Ride"] = 102.38}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 3.77, ["Neon|Ride"] = 38.06, ["Neon|Fly|Ride"] = 125.01, ["Mega"] = 22.32, ["Mega|Fly"] = 105, ["Mega|Ride"] = 83.71, ["Mega|Fly|Ride"] = 162.42}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 26.36, ["Ride"] = 26.46, ["Fly|Ride"] = 79.17, ["Neon"] = 3.93, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 28.14, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 26.25, ["Mega|Ride"] = 65.64, ["Mega|Fly|Ride"] = 138.49}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Ride"] = 46.17, ["Neon"] = 2.63, ["Mega"] = 17.07, ["Mega|Ride"] = 204.18}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 8.34, ["Neon|Ride"] = 77.33, ["Neon|Fly|Ride"] = 420, ["Mega"] = 555.2, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 18.38, ["Neon"] = 8.21, ["Neon|Ride"] = 23.98, ["Neon|Fly|Ride"] = 77.44, ["Mega"] = 54.17, ["Mega|Ride"] = 53.82, ["Mega|Fly|Ride"] = 123.47}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 11.82, ["Ride"] = 59.07, ["Neon"] = 119.81, ["Mega"] = 435.41, ["Mega|Ride"] = 486.45, ["Mega|Fly|Ride"] = 694.78}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 6.27, ["Fly"] = 6562.5, ["Ride"] = 36.47, ["Neon"] = 20.85, ["Neon|Fly|Ride"] = 110.25, ["Mega"] = 1586.41, ["Mega|Ride"] = 288.75}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 7.87, ["Ride"] = 31.18, ["Fly|Ride"] = 416.67, ["Neon"] = 97.93, ["Neon|Ride"] = 278.13, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 265.13, ["Mega|Fly|Ride"] = 556.24}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 15.63, ["Fly|Ride"] = 39.41, ["Neon"] = 2.1, ["Neon|Fly"] = 22.93, ["Neon|Ride"] = 14.7, ["Neon|Fly|Ride"] = 42, ["Mega"] = 25.02, ["Mega|Fly"] = 24.94, ["Mega|Ride"] = 23.24, ["Mega|Fly|Ride"] = 52.5}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 64.32, ["Neon"] = 15.74, ["Neon|Fly"] = 139.59, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 45.91, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 31.18, ["Neon|Ride"] = 31.26, ["Neon|Fly|Ride"] = 69.8, ["Mega"] = 15.64, ["Mega|Fly"] = 78.44, ["Mega|Ride"] = 36.46, ["Mega|Fly|Ride"] = 337.98}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 3.87, ["Neon|Fly"] = 60.9, ["Mega"] = 19.69, ["Mega|Fly|Ride"] = 184.64}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Ride"] = 23.97, ["Fly|Ride"] = 39.38, ["Neon"] = 11.42, ["Neon|Fly"] = 139.59, ["Neon|Ride"] = 31.16, ["Neon|Fly|Ride"] = 102.93, ["Mega"] = 104.19, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 408.49}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 245.44, ["Ride"] = 416.67, ["Fly|Ride"] = 393.75, ["Neon"] = 1194.76, ["Neon|Ride"] = 1050, ["Neon|Fly|Ride"] = 1194.76, ["Mega"] = 8333, ["Mega|Fly|Ride"] = 4615.5}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Fly|Ride"] = 52.5, ["Neon"] = 8.3, ["Neon|Ride"] = 68.25, ["Mega"] = 62.33, ["Mega|Ride"] = 172.92, ["Mega|Fly|Ride"] = 548.96}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 3.94, ["Fly"] = 103.68, ["Ride"] = 23.98, ["Neon"] = 72.19, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 603.75, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 1041.64}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 22.32, ["Ride"] = 14.44, ["Fly|Ride"] = 33.08, ["Neon"] = 3.87, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 28.86, ["Neon|Fly|Ride"] = 61.69, ["Mega"] = 49.88, ["Mega|Ride"] = 77.33, ["Mega|Fly|Ride"] = 140.44}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Ride"] = 24.94, ["Fly|Ride"] = 120.85, ["Neon"] = 11.47, ["Neon|Fly"] = 41.68, ["Neon|Ride"] = 41.68, ["Mega"] = 125.01, ["Mega|Ride"] = 135.43, ["Mega|Fly|Ride"] = 207.31}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 3.12, ["Fly"] = 32.82, ["Ride"] = 22.32, ["Fly|Ride"] = 43.76, ["Neon"] = 17.33, ["Neon|Ride"] = 39.59, ["Neon|Fly|Ride"] = 87.28, ["Mega"] = 203.14, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 308.11}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 5.92, ["Ride"] = 23.63, ["Fly|Ride"] = 246.75, ["Neon"] = 57.75, ["Neon|Ride"] = 90.57, ["Neon|Fly|Ride"] = 618.75, ["Mega"] = 328.13, ["Mega|Ride"] = 416.67, ["Mega|Fly|Ride"] = 416.67}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.1, ["Fly"] = 28.14, ["Ride"] = 16.84, ["Fly|Ride"] = 41.68, ["Neon"] = 28.32, ["Neon|Fly"] = 56.26, ["Neon|Ride"] = 45.25, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 196.88, ["Mega|Ride"] = 416.67, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 57.74, ["Fly"] = 141.75, ["Ride"] = 109.6, ["Fly|Ride"] = 154.63, ["Neon"] = 523.95, ["Neon|Fly"] = 394.42, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 485.41, ["Mega|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 1565.82}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 207.27, ["Fly"] = 312.5, ["Ride"] = 240.19, ["Fly|Ride"] = 280.88, ["Neon"] = 999.97, ["Neon|Ride"] = 1111.43, ["Neon|Fly|Ride"] = 1021.84, ["Mega"] = 10416.25, ["Mega|Fly|Ride"] = 4857.11}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 70.3, ["Fly"] = 115.4, ["Ride"] = 78.95, ["Fly|Ride"] = 118.76, ["Neon"] = 415.62, ["Neon|Ride"] = 296.92, ["Neon|Fly|Ride"] = 262.5, ["Mega|Fly|Ride"] = 1309.88}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 6.25, ["Ride"] = 40.63, ["Neon"] = 28.13, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 187.51, ["Mega"] = 582.28, ["Mega|Ride"] = 217.3, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 13.09, ["Ride"] = 31.49, ["Fly|Ride"] = 78.75, ["Neon"] = 123.47, ["Neon|Ride"] = 139.59, ["Neon|Fly|Ride"] = 208.34, ["Mega"] = 478.87, ["Mega|Ride"] = 388.5, ["Mega|Fly|Ride"] = 611.45}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 31.49, ["Ride"] = 21, ["Fly|Ride"] = 50.02, ["Neon"] = 6.04, ["Neon|Fly"] = 22.32, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 31.5, ["Mega|Fly"] = 115.4, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 177.72}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 9.19, ["Fly"] = 286.47, ["Ride"] = 19.69, ["Fly|Ride"] = 50.02, ["Neon"] = 105, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 139.59, ["Mega"] = 493.87, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 347.91}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 18.36, ["Fly|Ride"] = 38.07, ["Neon"] = 13.71, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 27.71, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 131.24, ["Mega|Ride"] = 230.13, ["Mega|Fly|Ride"] = 216.67}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 4.87, ["Ride"] = 30.19, ["Fly|Ride"] = 328.13, ["Neon"] = 23.98, ["Neon|Ride"] = 41.68, ["Mega"] = 157.5}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 28.14, ["Neon"] = 2.1, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 17.07, ["Mega|Ride"] = 26.25, ["Mega|Fly|Ride"] = 207696.84}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 45.93, ["Ride"] = 31.26, ["Fly|Ride"] = 56.26, ["Neon"] = 17.33, ["Neon|Fly"] = 69.8, ["Neon|Ride"] = 56.9, ["Neon|Fly|Ride"] = 86.56, ["Mega"] = 154.63, ["Mega|Fly|Ride"] = 147.58}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.63, ["Fly"] = 152.33, ["Ride"] = 18.37, ["Neon"] = 62.31, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 556.24, ["Mega"] = 181.26, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 271.69}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 147.93, ["Fly"] = 243.75, ["Ride"] = 154.61, ["Fly|Ride"] = 223.86, ["Neon"] = 525, ["Neon|Ride"] = 624.99, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 1953.06, ["Mega|Fly|Ride"] = 1903.13}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 11.71, ["Ride"] = 240.91, ["Fly|Ride"] = 203.14, ["Neon"] = 62.33, ["Neon|Ride"] = 154.63, ["Neon|Fly|Ride"] = 152.25, ["Mega"] = 414.75, ["Mega|Ride"] = 416.67, ["Mega|Fly|Ride"] = 495.8}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 69.25, ["Ride"] = 26.24, ["Fly|Ride"] = 69.8, ["Neon"] = 26.55, ["Neon|Ride"] = 28.33, ["Neon|Fly|Ride"] = 83.35, ["Mega"] = 308.44, ["Mega|Ride"] = 258.35, ["Mega|Fly|Ride"] = 250.01}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 26.23, ["Ride"] = 138.54, ["Fly|Ride"] = 131.25, ["Neon"] = 90.57, ["Neon|Ride"] = 108.48, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 519.79, ["Mega|Ride"] = 581.24, ["Mega|Fly|Ride"] = 583.33}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 6.25}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 2.1, ["Ride"] = 27.57, ["Neon"] = 72.19, ["Neon|Fly|Ride"] = 624.99, ["Mega"] = 145.69, ["Mega|Ride"] = 416.67, ["Mega|Fly|Ride"] = 1249.97}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 15.64, ["Fly"] = 56.25, ["Ride"] = 34.12, ["Fly|Ride"] = 59.07, ["Neon"] = 278.13, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 125.01, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 2083.26, ["Mega|Fly|Ride"] = 1461.96}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 4.08, ["Neon|Ride"] = 34.63, ["Mega"] = 23.63, ["Mega|Ride"] = 77.64, ["Mega|Fly|Ride"] = 234.39}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 3.91, ["Fly"] = 34.13, ["Ride"] = 28.14, ["Fly|Ride"] = 112.54, ["Neon"] = 39.38, ["Neon|Ride"] = 230.78, ["Mega"] = 144.8, ["Mega|Fly"] = 385.41, ["Mega|Ride"] = 160.42, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.23, ["Fly"] = 17.33, ["Ride"] = 17.07, ["Fly|Ride"] = 61.46, ["Neon"] = 19.69, ["Neon|Ride"] = 36.03, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 116.82, ["Mega|Fly"] = 137.51, ["Mega|Ride"] = 120.75, ["Mega|Fly|Ride"] = 234.86}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Neon"] = 3.92, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 112.88, ["Mega"] = 52.5, ["Mega|Ride"] = 67.5, ["Mega|Fly|Ride"] = 206.27}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 30.19, ["Fly"] = 61.47, ["Ride"] = 81.26, ["Neon"] = 208.32, ["Neon|Ride"] = 262.5, ["Mega"] = 791.64, ["Mega|Ride"] = 813.75, ["Mega|Fly|Ride"] = 1111.43}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 26.24, ["Ride"] = 59.07, ["Fly|Ride"] = 210, ["Neon"] = 69.55, ["Neon|Ride"] = 77.1, ["Mega"] = 59.07, ["Mega|Ride"] = 511.88}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 20.79, ["Fly"] = 96.96, ["Ride"] = 42.71, ["Fly|Ride"] = 182.3, ["Neon"] = 83.1, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 83.93, ["Neon|Fly|Ride"] = 228.48, ["Mega"] = 313.69, ["Mega|Ride"] = 346.13, ["Mega|Fly|Ride"] = 385.41}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 73.95, ["Fly"] = 139.59, ["Ride"] = 105, ["Fly|Ride"] = 347.91, ["Neon"] = 288.48, ["Neon|Ride"] = 452.08, ["Mega|Fly|Ride"] = 1806.18}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 26.18, ["Ride"] = 48.98, ["Fly|Ride"] = 157.5, ["Neon"] = 72.17, ["Neon|Ride"] = 98.6, ["Neon|Fly|Ride"] = 833.32, ["Mega"] = 379.32, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 467.25}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 74.82, ["Ride"] = 85.76, ["Fly|Ride"] = 199.5, ["Neon"] = 245.84, ["Neon|Ride"] = 345.83, ["Neon|Fly|Ride"] = 339.94, ["Mega"] = 1249.97, ["Mega|Ride"] = 1085.27, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 26.25, ["Ride"] = 45.94, ["Fly|Ride"] = 230.76, ["Neon"] = 102.37, ["Neon|Fly"] = 249.38, ["Neon|Ride"] = 150.94, ["Neon|Fly|Ride"] = 209.77, ["Mega"] = 312.5, ["Mega|Ride"] = 363.65, ["Mega|Fly|Ride"] = 538.79}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 4.87, ["Fly"] = 52.5, ["Ride"] = 27.09, ["Neon"] = 26.25, ["Neon|Ride"] = 264.58, ["Neon|Fly|Ride"] = 123.66, ["Mega"] = 327.71, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 39.37, ["Ride"] = 115.64, ["Neon"] = 106.32, ["Neon|Ride"] = 166.68, ["Neon|Fly|Ride"] = 207.3, ["Mega"] = 230.22, ["Mega|Ride"] = 416.67, ["Mega|Fly|Ride"] = 615.04}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 15.63, ["Ride"] = 50.02, ["Neon"] = 137.51, ["Neon|Fly"] = 111.47, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 278.13, ["Mega"] = 416.67, ["Mega|Ride"] = 280.82, ["Mega|Fly|Ride"] = 377.53}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 69.8, ["Neon|Ride"] = 26.25, ["Mega"] = 21, ["Mega|Fly"] = 139.59, ["Mega|Ride"] = 66.94, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 3.14, ["Ride"] = 104.19, ["Neon"] = 15.74, ["Neon|Ride"] = 83.83, ["Mega"] = 99.62, ["Mega|Ride"] = 156.26, ["Mega|Fly|Ride"] = 308.11}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 3.92, ["Neon"] = 22.23, ["Neon|Ride"] = 103.69, ["Mega"] = 336}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 5.77, ["Ride"] = 31.26, ["Fly|Ride"] = 115.4, ["Neon"] = 27.46, ["Neon|Ride"] = 82.95, ["Neon|Fly|Ride"] = 277.08, ["Mega"] = 123.38, ["Mega|Ride"] = 375, ["Mega|Fly|Ride"] = 508.6}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 548.63, ["Ride"] = 485.63, ["Fly|Ride"] = 590.63, ["Neon|Ride"] = 1764.53, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 5878.95}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 7.87, ["Fly"] = 56.26, ["Ride"] = 24.4, ["Fly|Ride"] = 71.55, ["Neon"] = 37.51, ["Neon|Ride"] = 83.35, ["Mega|Ride"] = 278.13}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 18.64, ["Fly"] = 31.5, ["Neon"] = 52.11, ["Neon|Fly"] = 315, ["Neon|Ride"] = 140.54, ["Neon|Fly|Ride"] = 108.48, ["Mega"] = 319.79, ["Mega|Ride"] = 333.34, ["Mega|Fly|Ride"] = 461.56}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 2.1, ["Fly"] = 28.14, ["Ride"] = 23.23, ["Fly|Ride"] = 312.5, ["Neon|Ride"] = 154.63, ["Mega"] = 223.13, ["Mega|Ride"] = 354.38, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 29.09, ["Neon"] = 7.86, ["Neon|Ride"] = 39.26, ["Neon|Fly|Ride"] = 125.01, ["Mega"] = 59.05, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 233.63}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Ride"] = 69.72, ["Neon"] = 3.21, ["Neon|Ride"] = 57.7, ["Neon|Fly|Ride"] = 115.4, ["Mega"] = 23.63, ["Mega|Ride"] = 111.47, ["Mega|Fly|Ride"] = 208.34}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1225.88}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 6.72, ["Fly"] = 56.26, ["Ride"] = 33.71, ["Fly|Ride"] = 123.47, ["Neon"] = 139.59, ["Neon|Fly"] = 139.59, ["Neon|Ride"] = 154.61, ["Mega"] = 493.87, ["Mega|Ride"] = 515.63, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 45.36, ["Neon"] = 13.13, ["Neon|Ride"] = 73.86, ["Mega"] = 54.17, ["Mega|Ride"] = 308.11, ["Mega|Fly|Ride"] = 230.78}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.1, ["Fly"] = 41.68, ["Ride"] = 27.43, ["Fly|Ride"] = 525, ["Neon"] = 10.5, ["Neon|Ride"] = 69.8, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 154.18, ["Mega|Ride"] = 154.88, ["Mega|Fly|Ride"] = 202.09}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 387.44, ["Ride"] = 416.67, ["Fly|Ride"] = 556.5, ["Neon|Ride"] = 1509.38, ["Neon|Fly|Ride"] = 1458.29, ["Mega|Fly|Ride"] = 7639.28}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 694.78, ["Fly"] = 196.88, ["Ride"] = 72.19, ["Neon"] = 57.75, ["Mega"] = 399, ["Mega|Ride"] = 408.49}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Neon"] = 6.29, ["Neon|Ride"] = 39.51, ["Neon|Fly|Ride"] = 93.76, ["Mega"] = 43.77, ["Mega|Fly"] = 154.63, ["Mega|Ride"] = 92.32, ["Mega|Fly|Ride"] = 196.87}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 3.82, ["Neon|Ride"] = 59.07, ["Mega"] = 24.94, ["Mega|Ride"] = 83.1, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 11.82, ["Fly"] = 78.14, ["Ride"] = 39.38, ["Neon"] = 41.26, ["Neon|Ride"] = 207.38, ["Neon|Fly|Ride"] = 308.34, ["Mega"] = 328.13, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 312.5}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 13.13, ["Ride"] = 139.59, ["Fly|Ride"] = 131.25, ["Neon"] = 92.3, ["Neon|Ride"] = 56.26, ["Neon|Fly|Ride"] = 833.32, ["Mega"] = 1249.97, ["Mega|Ride"] = 493.87, ["Mega|Fly|Ride"] = 1066.42}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 3.94, ["Fly|Ride"] = 139.59, ["Neon"] = 278.13, ["Neon|Ride"] = 207.31, ["Mega"] = 582.75, ["Mega|Fly|Ride"] = 1222.88}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 48.47, ["Ride"] = 64.6, ["Neon|Ride"] = 131.56, ["Neon|Fly|Ride"] = 769.64, ["Mega"] = 1443.75, ["Mega|Ride"] = 486.39, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 347.82, ["Ride"] = 367.5, ["Fly|Ride"] = 438.48, ["Neon"] = 853.13, ["Neon|Ride"] = 1079.14, ["Neon|Fly|Ride"] = 1041.64, ["Mega|Fly|Ride"] = 3150}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 5.92, ["Ride"] = 44.63, ["Fly|Ride"] = 87.52, ["Neon"] = 57.75, ["Neon|Ride"] = 97.93, ["Neon|Fly|Ride"] = 139.59, ["Mega"] = 556.24, ["Mega|Ride"] = 494.79, ["Mega|Fly|Ride"] = 754.16}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 3.93, ["Ride"] = 41.68, ["Fly|Ride"] = 154.18, ["Mega"] = 1249.97, ["Mega|Fly|Ride"] = 556.24}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 8.39, ["Ride"] = 56.26, ["Fly|Ride"] = 162.75, ["Neon"] = 28.35, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 168, ["Mega"] = 170.63, ["Mega|Ride"] = 202.1, ["Mega|Fly|Ride"] = 357.3}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.1, ["Ride"] = 31.5, ["Fly|Ride"] = 107.3, ["Neon"] = 9.24, ["Neon|Ride"] = 42.47, ["Mega"] = 39.38, ["Mega|Ride"] = 95.85, ["Mega|Fly|Ride"] = 154.63}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 45.94, ["Ride"] = 70.88, ["Neon"] = 229.69, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 461.56, ["Mega"] = 1111.43, ["Mega|Ride"] = 1027.06, ["Mega|Fly|Ride"] = 1065.6}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.63, ["Fly"] = 576.95, ["Ride"] = 32.29, ["Fly|Ride"] = 65.63, ["Neon"] = 12.71, ["Neon|Fly"] = 181.26, ["Neon|Ride"] = 54.55, ["Mega"] = 59.05, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 308.44}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 28.14, ["Ride"] = 30.01, ["Fly|Ride"] = 148.25, ["Neon"] = 3.93, ["Neon|Ride"] = 40.64, ["Neon|Fly|Ride"] = 139.59, ["Mega"] = 104.14, ["Mega|Fly"] = 90.63, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Fly"] = 1519.88, ["Ride"] = 24.94, ["Fly|Ride"] = 262.5, ["Neon"] = 15.64, ["Neon|Ride"] = 158.06, ["Neon|Fly|Ride"] = 295.32, ["Mega"] = 117.71, ["Mega|Ride"] = 189.25, ["Mega|Fly|Ride"] = 204.18}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 56.65, ["Fly"] = 91.68, ["Ride"] = 97.13, ["Fly|Ride"] = 154.63, ["Neon"] = 307.26, ["Neon|Ride"] = 322.92, ["Neon|Fly|Ride"] = 692.35, ["Mega|Fly|Ride"] = 901.69}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 355.21, ["Ride"] = 315.62, ["Fly|Ride"] = 420, ["Neon|Ride"] = 1099.88, ["Neon|Fly|Ride"] = 1329.13, ["Mega"] = 6944.53, ["Mega|Fly|Ride"] = 5615.4}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 6.57, ["Neon"] = 25.98, ["Mega"] = 102.38, ["Mega|Ride"] = 235.12, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.61, ["Neon"] = 12.71, ["Mega"] = 99.75, ["Mega|Fly|Ride"] = 340.4}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 3.78, ["Fly"] = 155.57, ["Neon"] = 131.27, ["Mega"] = 488.92}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 53.23, ["Ride"] = 34.13, ["Neon"] = 5.25, ["Neon|Ride"] = 31.18, ["Neon|Fly|Ride"] = 181.26, ["Mega"] = 123.38, ["Mega|Ride"] = 86.46, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 68.77, ["Neon"] = 8.35, ["Mega"] = 32.8, ["Mega|Ride"] = 206.07}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 65.54, ["Ride"] = 19.8, ["Fly|Ride"] = 46.17, ["Neon"] = 5.24, ["Neon|Ride"] = 43.86, ["Neon|Fly|Ride"] = 105, ["Mega"] = 34.13, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 154.18}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 27.71, ["Fly|Ride"] = 60.38, ["Neon"] = 23.63, ["Neon|Fly"] = 97.93, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 85.4, ["Mega"] = 170.63, ["Mega|Ride"] = 194.8, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 32.96, ["Ride"] = 70.88, ["Neon"] = 114.19, ["Neon|Ride"] = 154.63, ["Mega"] = 367.5, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 500}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 64.32, ["Ride"] = 89.25, ["Fly|Ride"] = 160.42, ["Neon"] = 416.67, ["Neon|Ride"] = 391.13, ["Mega"] = 3077.4, ["Mega|Ride"] = 1737.45, ["Mega|Fly|Ride"] = 1590.07}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 33.35, ["Fly|Ride"] = 131.25, ["Neon"] = 5.25, ["Neon|Ride"] = 56.26, ["Neon|Fly|Ride"] = 359.63, ["Mega"] = 56.35, ["Mega|Ride"] = 125.01, ["Mega|Fly|Ride"] = 246.94}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 23.97, ["Ride"] = 19.66, ["Fly|Ride"] = 53.09, ["Neon"] = 3.92, ["Neon|Ride"] = 24.86, ["Neon|Fly|Ride"] = 39.59, ["Mega"] = 38.06, ["Mega|Fly"] = 157.5, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 125.01}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 3.94, ["Ride"] = 41.68, ["Neon"] = 125.01, ["Neon|Ride"] = 137.51, ["Neon|Fly|Ride"] = 277.08, ["Mega"] = 611.45, ["Mega|Ride"] = 624.99, ["Mega|Fly|Ride"] = 471.19}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 251.76, ["Fly"] = 343.75, ["Ride"] = 170.63, ["Fly|Ride"] = 370.78, ["Neon"] = 999.97, ["Neon|Ride"] = 1458.29, ["Neon|Fly|Ride"] = 1508.29, ["Mega|Fly|Ride"] = 5538.6}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 28.88, ["Fly"] = 209.9, ["Ride"] = 55.12, ["Fly|Ride"] = 218.29, ["Neon"] = 278.13, ["Neon|Ride"] = 237.41, ["Neon|Fly|Ride"] = 381.94, ["Mega"] = 917.68, ["Mega|Ride"] = 972.89, ["Mega|Fly|Ride"] = 826.88}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 31.49, ["Fly|Ride"] = 97.93, ["Neon"] = 9.44, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 97.93, ["Mega"] = 101.07, ["Mega|Ride"] = 110.25, ["Mega|Fly|Ride"] = 208.69}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 3.94, ["Fly"] = 208.34, ["Ride"] = 83.35, ["Fly|Ride"] = 142.7, ["Neon"] = 17.41, ["Neon|Ride"] = 166.68, ["Mega"] = 211.32, ["Mega|Ride"] = 431.55}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 104.19, ["Fly"] = 254.18, ["Ride"] = 92.32, ["Fly|Ride"] = 52.5, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 2499.91, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 1032.27}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 78.14, ["Ride"] = 236.46, ["Fly|Ride"] = 416.59, ["Neon"] = 345.19, ["Neon|Ride"] = 469.88, ["Neon|Fly|Ride"] = 610.32, ["Mega"] = 3056.15, ["Mega|Fly|Ride"] = 6249.75}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 217.88, ["Fly"] = 495.84, ["Ride"] = 270.79, ["Fly|Ride"] = 376.69, ["Neon"] = 972.89, ["Neon|Ride"] = 986.43, ["Neon|Fly|Ride"] = 918.75, ["Mega|Fly|Ride"] = 3049.89}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 12.96, ["Ride"] = 41.97, ["Fly|Ride"] = 206.27, ["Neon"] = 111.57, ["Neon|Ride"] = 115.49, ["Mega"] = 388.5, ["Mega|Ride"] = 380.63, ["Mega|Fly|Ride"] = 511.46}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.63, ["Fly"] = 28.14, ["Ride"] = 20.85, ["Fly|Ride"] = 47.25, ["Neon"] = 15.64, ["Neon|Ride"] = 40.64, ["Neon|Fly|Ride"] = 75.01, ["Mega"] = 112.28, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 3.56, ["Ride"] = 27.09, ["Fly|Ride"] = 52.11, ["Neon"] = 72.19, ["Neon|Ride"] = 41.3, ["Neon|Fly|Ride"] = 108.48, ["Mega"] = 250.79, ["Mega|Ride"] = 241.5, ["Mega|Fly|Ride"] = 291.67}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 255.94, ["Ride"] = 393.75, ["Fly|Ride"] = 484.64, ["Neon"] = 1389.54, ["Neon|Ride"] = 1243.12, ["Neon|Fly|Ride"] = 1486.42}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 45.85, ["Neon"] = 11.55, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 32.82, ["Mega|Ride"] = 156.23}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 4.17, ["Ride"] = 19.69, ["Fly|Ride"] = 64.63, ["Neon"] = 41.68, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 110.25, ["Mega"] = 142.93, ["Mega|Ride"] = 278.13, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 22.08, ["Ride"] = 97.93, ["Neon"] = 115.4, ["Neon|Fly|Ride"] = 533.33, ["Mega"] = 515.63, ["Mega|Ride"] = 520.83, ["Mega|Fly|Ride"] = 535.41}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 117.52, ["Fly"] = 277.08, ["Ride"] = 118.13, ["Fly|Ride"] = 147.95, ["Neon|Ride"] = 694.68, ["Neon|Fly|Ride"] = 524.99, ["Mega|Fly|Ride"] = 1713.49}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 24.12, ["Fly"] = 80.79, ["Ride"] = 34.9, ["Fly|Ride"] = 69.25, ["Neon"] = 56.26, ["Neon|Ride"] = 89.25, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 694.78, ["Mega|Ride"] = 416.67, ["Mega|Fly|Ride"] = 691.65}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 56.26, ["Neon"] = 3.42, ["Neon|Ride"] = 47.94, ["Neon|Fly|Ride"] = 139.59, ["Mega"] = 23.08, ["Mega|Ride"] = 166.68, ["Mega|Fly|Ride"] = 416.67}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 52.5, ["Neon"] = 2.63, ["Neon|Fly"] = 31.18, ["Neon|Ride"] = 26.55, ["Neon|Fly|Ride"] = 69.18, ["Mega"] = 17.43, ["Mega|Ride"] = 64.6, ["Mega|Fly|Ride"] = 125.01}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 11.81, ["Ride"] = 74.8, ["Fly|Ride"] = 165.37, ["Neon"] = 23.09, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 154.88, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 307.3}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1389.54, ["Ride"] = 1299.38, ["Fly|Ride"] = 1457.64, ["Neon"] = 6666.4, ["Neon|Fly|Ride"] = 4846.28, ["Mega|Fly|Ride"] = 13648.69}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 539.44, ["Ride"] = 640.5, ["Fly|Ride"] = 660.19, ["Neon|Ride"] = 2462.38, ["Neon|Fly|Ride"] = 2502.94, ["Mega"] = 16665.98, ["Mega|Fly|Ride"] = 6811.88}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 328.13, ["Fly"] = 556.24, ["Ride"] = 375.37, ["Fly|Ride"] = 418.69, ["Neon"] = 735, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 782.25, ["Mega|Fly|Ride"] = 2462.41}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 325, ["Fly"] = 419.44, ["Ride"] = 380.62, ["Fly|Ride"] = 423.49, ["Neon"] = 945, ["Neon|Fly"] = 787.5, ["Neon|Ride"] = 1041.64, ["Neon|Fly|Ride"] = 1077.72, ["Mega|Ride"] = 3675, ["Mega|Fly|Ride"] = 2914.48}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 79.17, ["Ride"] = 19.69, ["Fly|Ride"] = 44.62, ["Neon"] = 9.19, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 62.51, ["Mega"] = 83.69, ["Mega|Ride"] = 112.88, ["Mega|Fly|Ride"] = 144.37}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 322.87, ["Fly"] = 590.62, ["Ride"] = 357, ["Fly|Ride"] = 521.85, ["Neon"] = 932.27, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 1048.69, ["Mega"] = 8194.47, ["Mega|Ride"] = 3937.5, ["Mega|Fly|Ride"] = 3478.13}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 2.1, ["Fly"] = 183.75, ["Ride"] = 139.59, ["Neon"] = 15.64, ["Neon|Ride"] = 53.59, ["Neon|Fly|Ride"] = 112.72, ["Mega"] = 67.95, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 272.35}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 20.35, ["Ride"] = 17.32, ["Fly|Ride"] = 41.68, ["Neon"] = 7.86, ["Neon|Ride"] = 61.69, ["Neon|Fly|Ride"] = 110.25, ["Mega"] = 123.97, ["Mega|Ride"] = 136.47, ["Mega|Fly|Ride"] = 202.13}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Neon"] = 3.94, ["Mega"] = 21, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 60.38, ["Ride"] = 65.63, ["Fly|Ride"] = 459.38, ["Neon"] = 244.13, ["Neon|Ride"] = 308.11, ["Mega"] = 2083.26, ["Mega|Ride"] = 897.75, ["Mega|Fly|Ride"] = 972.89}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 3.93, ["Fly"] = 65.6, ["Ride"] = 19.43, ["Neon"] = 103.87, ["Mega"] = 328.13, ["Mega|Ride"] = 314.58}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 53.82, ["Neon"] = 3.4, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 18.38, ["Mega|Fly"] = 123.47, ["Mega|Ride"] = 104.19, ["Mega|Fly|Ride"] = 308.44}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.1, ["Ride"] = 23.09, ["Fly|Ride"] = 39.38, ["Neon"] = 9.19, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 27.27, ["Neon|Fly|Ride"] = 91.28, ["Mega"] = 102.26, ["Mega|Fly"] = 230.78, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 217.45}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 5.2, ["Fly"] = 16.77, ["Ride"] = 54.1, ["Fly|Ride"] = 55.26, ["Neon"] = 89.59, ["Neon|Fly"] = 39.24, ["Neon|Ride"] = 139.57, ["Neon|Fly|Ride"] = 250.01, ["Mega"] = 237.57, ["Mega|Ride"] = 139.59, ["Mega|Fly|Ride"] = 1019.82}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 11.82, ["Ride"] = 27.57, ["Neon"] = 43.77, ["Mega"] = 461.56, ["Mega|Ride"] = 331.25, ["Mega|Fly|Ride"] = 556.24}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Fly|Ride"] = 87.94, ["Neon"] = 20.85, ["Neon|Ride"] = 80.31, ["Neon|Fly|Ride"] = 692.34, ["Mega"] = 275.01, ["Mega|Ride"] = 461.56, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Ride"] = 19.8, ["Fly|Ride"] = 83.35, ["Neon"] = 3.93, ["Neon|Ride"] = 28.14, ["Neon|Fly|Ride"] = 166.68, ["Mega"] = 40.69, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 312.5}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 208.69, ["Fly"] = 291.67, ["Ride"] = 239.59, ["Fly|Ride"] = 282.19, ["Neon"] = 1153.88, ["Neon|Fly"] = 1319.75, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1236.27, ["Mega"] = 8333, ["Mega|Fly|Ride"] = 3848.18}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 17.75, ["Fly|Ride"] = 34.13, ["Neon"] = 3.92, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 61.47, ["Mega"] = 40.69, ["Mega|Ride"] = 56.23, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 14.3, ["Fly"] = 139.59, ["Ride"] = 98.44, ["Fly|Ride"] = 105, ["Neon"] = 78.75, ["Neon|Ride"] = 104.41, ["Mega"] = 288.75, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 461.5}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 37.2, ["Ride"] = 108.48, ["Neon"] = 154.88, ["Neon|Ride"] = 306.94, ["Mega"] = 753.63, ["Mega|Ride"] = 790.61, ["Mega|Fly|Ride"] = 1015.92}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 175.88, ["Fly"] = 262.5, ["Ride"] = 240.19, ["Fly|Ride"] = 268.56, ["Neon"] = 775.69, ["Neon|Ride"] = 742.88, ["Neon|Fly|Ride"] = 866.25, ["Mega|Fly|Ride"] = 3383.21}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 21, ["Neon"] = 73.5, ["Mega"] = 415.42, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 694.78}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 36.75, ["Ride"] = 312.5, ["Fly|Ride"] = 624.99, ["Neon"] = 205.57, ["Neon|Ride"] = 311.46, ["Neon|Fly|Ride"] = 833.32, ["Mega"] = 727.07, ["Mega|Ride"] = 832.27, ["Mega|Fly|Ride"] = 2083.26}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 1141.88, ["Fly"] = 1441.13, ["Ride"] = 1115.63, ["Fly|Ride"] = 1148.43, ["Neon|Ride"] = 6249.75, ["Neon|Fly|Ride"] = 4315.5, ["Mega|Fly|Ride"] = 13846.47}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 5.84, ["Fly"] = 35.42, ["Ride"] = 21, ["Fly|Ride"] = 62.35, ["Neon"] = 76.78, ["Neon|Fly"] = 111.57, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 105, ["Mega"] = 131.25, ["Mega|Fly"] = 556.24, ["Mega|Ride"] = 251.55, ["Mega|Fly|Ride"] = 385.41}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 5.04, ["Fly"] = 13749.44, ["Ride"] = 39.38, ["Neon"] = 35.79, ["Neon|Ride"] = 164.59, ["Neon|Fly|Ride"] = 144.74, ["Mega"] = 212.63, ["Mega|Ride"] = 217.88, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Ride"] = 22.93, ["Fly|Ride"] = 90.63, ["Neon"] = 15.74, ["Neon|Ride"] = 77.33, ["Neon|Fly|Ride"] = 308.11, ["Mega"] = 203.41, ["Mega|Ride"] = 252.09, ["Mega|Fly|Ride"] = 694.78}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 17.91, ["Ride"] = 40.68, ["Fly|Ride"] = 63, ["Neon"] = 53.82, ["Neon|Ride"] = 107.3, ["Neon|Fly|Ride"] = 208.34, ["Mega"] = 354.38, ["Mega|Ride"] = 383.25, ["Mega|Fly|Ride"] = 657.19}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 2.63, ["Fly"] = 18.76, ["Ride"] = 31.39, ["Fly|Ride"] = 62.51, ["Neon"] = 27.28, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 105, ["Mega"] = 345.83, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 3.94, ["Ride"] = 43.63, ["Neon"] = 17.33, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 93.82, ["Mega"] = 111.56, ["Mega|Ride"] = 187.51, ["Mega|Fly|Ride"] = 347.91}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 139.13, ["Ride"] = 224.44, ["Fly|Ride"] = 535.41, ["Neon"] = 840, ["Neon|Ride"] = 1693.13, ["Neon|Fly|Ride"] = 1337.46, ["Mega|Fly|Ride"] = 3736.31}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.61, ["Ride"] = 23.08, ["Fly|Ride"] = 54.29, ["Neon"] = 10.49, ["Neon|Fly"] = 77.33, ["Neon|Ride"] = 41.89, ["Mega"] = 91.88, ["Mega|Ride"] = 147.52, ["Mega|Fly|Ride"] = 208.34}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 15.61, ["Neon"] = 77.43, ["Mega"] = 249.38}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 3.93, ["Fly"] = 58.11, ["Ride"] = 40.69, ["Neon"] = 15.73, ["Neon|Ride"] = 25.02, ["Neon|Fly|Ride"] = 270.02, ["Mega"] = 145.69, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 347.17}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 157.5, ["Fly"] = 262.5, ["Ride"] = 228.38, ["Fly|Ride"] = 681.23, ["Neon"] = 459.38, ["Neon|Ride"] = 619.5, ["Neon|Fly|Ride"] = 624.99, ["Mega"] = 3541.54, ["Mega|Ride"] = 2499.91, ["Mega|Fly|Ride"] = 1785}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 29.97, ["Ride"] = 56.26, ["Fly|Ride"] = 520.83, ["Neon"] = 140.6, ["Neon|Ride"] = 137.51, ["Neon|Fly|Ride"] = 278.13, ["Mega"] = 623.95, ["Mega|Ride"] = 658.32, ["Mega|Fly|Ride"] = 694.78}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 25.13, ["Ride"] = 39.38, ["Neon"] = 115.64, ["Neon|Ride"] = 144.64, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 666.58, ["Mega|Ride"] = 489.86, ["Mega|Fly|Ride"] = 538.12}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 83.35, ["Neon"] = 3.93, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 35.44, ["Mega"] = 35.44, ["Mega|Ride"] = 74.82, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 83.35, ["Fly"] = 137.69, ["Ride"] = 131.25, ["Fly|Ride"] = 252.06, ["Neon"] = 315, ["Neon|Ride"] = 361.31, ["Neon|Fly|Ride"] = 485.41, ["Mega|Fly|Ride"] = 917.44}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 20.85, ["Neon"] = 4.6, ["Neon|Fly|Ride"] = 588, ["Mega"] = 69.8}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 45.94, ["Fly"] = 139.59, ["Ride"] = 44.07, ["Fly|Ride"] = 108.48, ["Neon"] = 97.93, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 112.88, ["Mega"] = 395.82, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 387.5}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 50.93, ["Ride"] = 98.44, ["Fly|Ride"] = 157.5, ["Neon|Ride"] = 369.25, ["Neon|Fly|Ride"] = 347.91, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 15.64, ["Fly|Ride"] = 47.94, ["Neon"] = 3.29, ["Neon|Fly"] = 27.72, ["Neon|Ride"] = 28.14, ["Neon|Fly|Ride"] = 62.51, ["Mega|Fly"] = 50.02, ["Mega|Ride"] = 45.09, ["Mega|Fly|Ride"] = 103.94}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 3.94, ["Ride"] = 83.35, ["Fly|Ride"] = 98.65, ["Neon"] = 18.35, ["Neon|Ride"] = 95.88, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 157.5, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 515.17}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 21.94, ["Ride"] = 72.19, ["Fly|Ride"] = 105, ["Neon"] = 208.34, ["Neon|Ride"] = 308.11, ["Neon|Fly|Ride"] = 616.19, ["Mega"] = 556.24, ["Mega|Ride"] = 572.91, ["Mega|Fly|Ride"] = 623.44}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 22.93, ["Neon"] = 2.63, ["Neon|Ride"] = 35.42, ["Neon|Fly|Ride"] = 125.01, ["Mega"] = 18.38, ["Mega|Ride"] = 137.51, ["Mega|Fly|Ride"] = 410.17}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 4.96, ["Fly"] = 210, ["Ride"] = 34.63, ["Fly|Ride"] = 98.44, ["Neon"] = 17.33, ["Neon|Ride"] = 97.92, ["Neon|Fly|Ride"] = 181.26, ["Mega"] = 202.09, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 373.14}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 26.55, ["Fly"] = 41.68, ["Ride"] = 31.16, ["Fly|Ride"] = 62.33, ["Neon"] = 139.59, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 694.78, ["Mega|Fly|Ride"] = 466.66}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 3.91, ["Ride"] = 91.87, ["Neon"] = 20.84, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 200.82, ["Mega"] = 169.32, ["Mega|Ride"] = 166.68, ["Mega|Fly|Ride"] = 291.67}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 26.25, ["Fly"] = 2083.26, ["Neon"] = 84, ["Neon|Ride"] = 493.87, ["Neon|Fly|Ride"] = 6153.61, ["Mega"] = 511.62, ["Mega|Ride"] = 524.99, ["Mega|Fly|Ride"] = 666.66}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Ride"] = 41.68, ["Fly|Ride"] = 126.48, ["Neon"] = 7.49, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 69.8, ["Mega"] = 70.52, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 408.19, ["Mega|Fly|Ride"] = 288.74}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 28.14, ["Neon"] = 5.25, ["Neon|Fly|Ride"] = 104.19, ["Mega"] = 28.88, ["Mega|Ride"] = 136.47, ["Mega|Fly|Ride"] = 154.18}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 32.82}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 68.75, ["Fly"] = 91.68, ["Ride"] = 90.63, ["Fly|Ride"] = 203.14, ["Neon"] = 1050, ["Neon|Fly|Ride"] = 1041.64, ["Mega"] = 972.89, ["Mega|Ride"] = 970.8, ["Mega|Fly|Ride"] = 889.88}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 139.59, ["Neon"] = 3.81, ["Neon|Ride"] = 26.55, ["Mega"] = 19.8, ["Mega|Ride"] = 104.16, ["Mega|Fly|Ride"] = 139.59}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 639.57, ["Ride"] = 769.64, ["Fly|Ride"] = 656.25, ["Neon"] = 4166.51, ["Neon|Fly|Ride"] = 2361.37, ["Mega"] = 16665.98, ["Mega|Fly|Ride"] = 10416.25}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 4.64, ["Fly"] = 49.88, ["Ride"] = 40.94, ["Fly|Ride"] = 54.25, ["Neon|Fly|Ride"] = 556.24, ["Mega|Fly|Ride"] = 556.24}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 3.49, ["Ride"] = 22.63, ["Fly|Ride"] = 54.17, ["Neon"] = 31.18, ["Neon|Ride"] = 35.48, ["Neon|Fly|Ride"] = 86.46, ["Mega"] = 177.09, ["Mega|Ride"] = 174.57, ["Mega|Fly|Ride"] = 182.44}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 15.75, ["Ride"] = 32.31, ["Fly|Ride"] = 106.32, ["Neon"] = 93.56, ["Neon|Ride"] = 247.92, ["Mega"] = 1029.14, ["Mega|Ride"] = 903.1, ["Mega|Fly|Ride"] = 1248.93}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 2.5, ["Fly"] = 39.38, ["Ride"] = 31.5, ["Fly|Ride"] = 393.75, ["Neon"] = 139.59, ["Mega"] = 289.59, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 11.82, ["Ride"] = 210, ["Fly|Ride"] = 111.47, ["Neon"] = 125.74, ["Neon|Fly|Ride"] = 350.44, ["Mega"] = 401.63, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 452.82}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 7.87, ["Fly"] = 105, ["Ride"] = 41.68, ["Fly|Ride"] = 131.25, ["Neon"] = 15.64, ["Neon|Ride"] = 91.68, ["Neon|Fly|Ride"] = 184.64, ["Mega"] = 231, ["Mega|Ride"] = 208.69, ["Mega|Fly|Ride"] = 291.67}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 46.17, ["Ride"] = 18.76, ["Fly|Ride"] = 75.01, ["Neon"] = 2.1, ["Neon|Fly"] = 41.99, ["Neon|Ride"] = 20.84, ["Neon|Fly|Ride"] = 63.27, ["Mega"] = 15.64, ["Mega|Fly"] = 77.33, ["Mega|Ride"] = 34.13, ["Mega|Fly|Ride"] = 77.44}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 15.74, ["Ride"] = 31.18, ["Fly|Ride"] = 157.94, ["Neon"] = 44.63, ["Neon|Fly"] = 385.41, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 230.78, ["Mega"] = 139.59, ["Mega|Ride"] = 174.57, ["Mega|Fly|Ride"] = 243.75}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 261.19, ["Ride"] = 301.88, ["Fly|Ride"] = 349.13, ["Neon"] = 1480.5, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 4081.88}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 137.66, ["Ride"] = 145.69, ["Fly|Ride"] = 7638.24, ["Neon|Ride"] = 833.32, ["Neon|Fly|Ride"] = 698.25, ["Mega"] = 4166.51, ["Mega|Ride"] = 1979.1, ["Mega|Fly|Ride"] = 2082.99}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 24.94, ["Fly|Ride"] = 38.06, ["Neon"] = 11.82, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 56.25, ["Mega|Fly"] = 207.31, ["Mega|Ride"] = 90.61, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 15.73, ["Fly|Ride"] = 36.93, ["Neon"] = 7.88, ["Neon|Fly"] = 54.25, ["Neon|Ride"] = 25.15, ["Neon|Fly|Ride"] = 52.01, ["Mega"] = 131.78, ["Mega|Ride"] = 72.93, ["Mega|Fly|Ride"] = 138.49}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.61, ["Ride"] = 22.31, ["Fly|Ride"] = 98.44, ["Neon"] = 39.38, ["Mega"] = 139.59}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 329.44, ["Ride"] = 367.5, ["Fly|Ride"] = 410.61, ["Neon|Ride"] = 1666.62, ["Neon|Fly|Ride"] = 1766.81, ["Mega|Ride"] = 8333, ["Mega|Fly|Ride"] = 4847.74}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 3.82, ["Fly"] = 22.78, ["Ride"] = 15.73, ["Fly|Ride"] = 45.72, ["Neon"] = 28.14, ["Neon|Fly"] = 154.63, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 78.73, ["Mega"] = 264.58, ["Mega|Ride"] = 125.01, ["Mega|Fly|Ride"] = 300.83}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 4.09, ["Fly"] = 123.47, ["Ride"] = 39.24, ["Fly|Ride"] = 208.34, ["Neon"] = 37.28, ["Neon|Ride"] = 223.13, ["Mega"] = 209.99, ["Mega|Ride"] = 204.75, ["Mega|Fly|Ride"] = 394.59}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 91.88, ["Neon"] = 4.67, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 139.59, ["Mega"] = 40.91, ["Mega|Ride"] = 94.5, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 19.57, ["Fly"] = 83.35, ["Ride"] = 31.26, ["Fly|Ride"] = 56.25, ["Neon"] = 85.71, ["Neon|Ride"] = 91.19, ["Neon|Fly|Ride"] = 110.25, ["Mega"] = 571.18, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 361.47}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 44.63, ["Ride"] = 69.8, ["Fly|Ride"] = 216.57, ["Neon"] = 131.25, ["Neon|Fly"] = 385.41, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 298.96, ["Mega"] = 472.5, ["Mega|Fly"] = 2187.42, ["Mega|Ride"] = 538.13, ["Mega|Fly|Ride"] = 622.13}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 27.03, ["Fly"] = 131.25, ["Ride"] = 49.88, ["Neon"] = 131.25, ["Neon|Ride"] = 139.59, ["Neon|Fly|Ride"] = 236.25, ["Mega|Ride"] = 783.12, ["Mega|Fly|Ride"] = 2048.13}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 15.64, ["Ride"] = 71.54, ["Fly|Ride"] = 51.45, ["Neon"] = 2.63, ["Neon|Fly"] = 20.85, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 63, ["Mega"] = 23.09, ["Mega|Fly"] = 56.26, ["Mega|Ride"] = 68.77, ["Mega|Fly|Ride"] = 115.5}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 208.34, ["Ride"] = 266.07, ["Fly|Ride"] = 390.63, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1317.75, ["Mega"] = 3436.33, ["Mega|Fly|Ride"] = 3543.75}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 13.54, ["Fly"] = 140.39, ["Ride"] = 45.93, ["Fly|Ride"] = 80.07, ["Neon"] = 91.88, ["Neon|Ride"] = 156.19, ["Mega"] = 624.99, ["Mega|Ride"] = 556.24, ["Mega|Fly|Ride"] = 515.63}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 24.94, ["Ride"] = 13.13, ["Fly|Ride"] = 39.38, ["Neon"] = 4.64, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 61.47, ["Mega|Ride"] = 139.59, ["Mega|Fly|Ride"] = 278.09}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 139.59, ["Ride"] = 18.38, ["Neon"] = 3.68, ["Neon|Ride"] = 22.4, ["Neon|Fly|Ride"] = 95.71, ["Mega"] = 20.84, ["Mega|Fly"] = 144.38, ["Mega|Ride"] = 6000.15, ["Mega|Fly|Ride"] = 104.83}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 3.93, ["Ride"] = 26.25, ["Fly|Ride"] = 62.51, ["Neon"] = 6.56, ["Neon|Fly|Ride"] = 6944.53, ["Mega"] = 83.34, ["Mega|Ride"] = 125, ["Mega|Fly|Ride"] = 416.67}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 12.71, ["Fly"] = 32.31, ["Ride"] = 23.25, ["Fly|Ride"] = 72.72, ["Neon"] = 43.73, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 108.33, ["Mega"] = 493.87, ["Mega|Ride"] = 264.58, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 9.22, ["Neon"] = 101.07, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 207.31, ["Mega|Ride"] = 357.72, ["Mega|Fly|Ride"] = 443.75}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 52.11, ["Fly|Ride"] = 90.63, ["Neon"] = 3.67, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 93.19, ["Mega"] = 20.35, ["Mega|Ride"] = 81.38, ["Mega|Fly|Ride"] = 127.32}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 10.43, ["Ride"] = 28.14, ["Fly|Ride"] = 93.76, ["Neon"] = 31.14, ["Neon|Fly"] = 102.92, ["Neon|Ride"] = 56.26, ["Neon|Fly|Ride"] = 123.36, ["Mega"] = 146.55, ["Mega|Fly"] = 139.59, ["Mega|Ride"] = 254.18, ["Mega|Fly|Ride"] = 208.34}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 210, ["Neon"] = 6.99, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 154.63, ["Mega"] = 33.35, ["Mega|Ride"] = 97.92, ["Mega|Fly|Ride"] = 616.19}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 40.05, ["Ride"] = 20.84, ["Fly|Ride"] = 118.13, ["Neon"] = 6.56, ["Neon|Ride"] = 20.56, ["Neon|Fly|Ride"] = 115.64, ["Mega"] = 52.49, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 193.87}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 1389.54, ["Ride"] = 1312.5, ["Fly|Ride"] = 1362.57, ["Neon|Fly|Ride"] = 4095.68, ["Mega|Fly|Ride"] = 15385.73}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 18.76, ["Fly|Ride"] = 43.77, ["Neon"] = 22.32, ["Neon|Fly"] = 40.99, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 110.41, ["Mega"] = 186.47, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 3.91, ["Ride"] = 56.26, ["Fly|Ride"] = 65.63, ["Neon"] = 6.57, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 34.61, ["Mega|Ride"] = 111.47, ["Mega|Fly|Ride"] = 219.98}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 9.8, ["Fly"] = 41.56, ["Ride"] = 21, ["Fly|Ride"] = 72.19, ["Neon"] = 35.43, ["Neon|Ride"] = 43.31, ["Neon|Fly|Ride"] = 93, ["Mega|Ride"] = 326.55, ["Mega|Fly|Ride"] = 353.07}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 40.64, ["Ride"] = 18.57, ["Fly|Ride"] = 37.31, ["Neon"] = 7.85, ["Neon|Fly"] = 89.24, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 61.47, ["Mega"] = 72.93, ["Mega|Ride"] = 137.51, ["Mega|Fly|Ride"] = 174.09}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 73.5, ["Neon"] = 333.34, ["Neon|Ride"] = 338.63, ["Neon|Fly|Ride"] = 556.24, ["Mega"] = 769.13, ["Mega|Ride"] = 972.89, ["Mega|Fly|Ride"] = 758.31}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Neon"] = 6.57, ["Neon|Ride"] = 139.59, ["Neon|Fly|Ride"] = 92.32, ["Mega"] = 78.69, ["Mega|Ride"] = 107.63, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 3.87, ["Fly"] = 73.5, ["Ride"] = 31.16, ["Fly|Ride"] = 65.63, ["Neon"] = 13.13, ["Neon|Fly"] = 145.84, ["Neon|Ride"] = 69.8, ["Neon|Fly|Ride"] = 139.59, ["Mega"] = 208.34, ["Mega|Ride"] = 339.59, ["Mega|Fly|Ride"] = 416.67}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.63, ["Fly|Ride"] = 65.65, ["Neon"] = 15.64, ["Neon|Fly"] = 62.33, ["Mega"] = 259.23}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 2593.49, ["Ride"] = 23.36, ["Fly|Ride"] = 98.44, ["Neon"] = 3.94, ["Neon|Ride"] = 22.51, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 41.74, ["Mega|Fly"] = 416.67, ["Mega|Ride"] = 139.59, ["Mega|Fly|Ride"] = 203.04}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 30.18, ["Fly"] = 30.19, ["Ride"] = 26.25, ["Fly|Ride"] = 48.57, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 833.32, ["Mega|Ride"] = 515.63, ["Mega|Fly|Ride"] = 389.59}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 838.69, ["Ride"] = 969.76, ["Fly|Ride"] = 939.75, ["Neon"] = 2100, ["Neon|Ride"] = 2139.38, ["Neon|Fly|Ride"] = 2093.44, ["Mega"] = 6944.53, ["Mega|Ride"] = 5643.75, ["Mega|Fly|Ride"] = 5250}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 66.89, ["Ride"] = 18.45, ["Fly|Ride"] = 43.77, ["Neon"] = 3.93, ["Neon|Fly"] = 28.14, ["Neon|Ride"] = 28.14, ["Neon|Fly|Ride"] = 81.36, ["Mega"] = 36.75, ["Mega|Fly"] = 108.34, ["Mega|Ride"] = 193.39, ["Mega|Fly|Ride"] = 138.28}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 9.18, ["Ride"] = 38.67, ["Neon"] = 56.2, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 333.34, ["Mega"] = 274.32, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 441}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 77.1, ["Ride"] = 91.68, ["Fly|Ride"] = 181.26, ["Neon|Fly|Ride"] = 729.15, ["Mega"] = 2923.92, ["Mega|Fly|Ride"] = 2231.25}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 48.57, ["Ride"] = 52.5, ["Fly|Ride"] = 301.88, ["Neon"] = 278.13, ["Neon|Ride"] = 177.19, ["Mega"] = 833.32, ["Mega|Ride"] = 727.07, ["Mega|Fly|Ride"] = 923.11}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 13.11, ["Ride"] = 35.6, ["Neon"] = 65.63, ["Neon|Ride"] = 392.44, ["Neon|Fly|Ride"] = 209.82, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 461.55}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 53.09, ["Ride"] = 112.35, ["Neon"] = 104.16, ["Neon|Ride"] = 354.25, ["Mega"] = 325, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 432.48}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 39.24, ["Fly"] = 105, ["Ride"] = 315, ["Neon"] = 224.44, ["Neon|Ride"] = 312.5, ["Neon|Fly|Ride"] = 525, ["Mega"] = 656.25, ["Mega|Ride"] = 778.28, ["Mega|Fly|Ride"] = 786.44}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 11.82}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 9.19, ["Ride"] = 31.18, ["Neon"] = 66.93, ["Neon|Ride"] = 74.8, ["Neon|Fly|Ride"] = 493.5, ["Mega"] = 270.84, ["Mega|Ride"] = 216.57, ["Mega|Fly|Ride"] = 833.32}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 3.94, ["Neon"] = 35.42, ["Mega"] = 861.96, ["Mega|Fly|Ride"] = 937.48}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 70.35, ["Fly"] = 415.62, ["Ride"] = 92.32, ["Fly|Ride"] = 105, ["Neon"] = 196.85, ["Neon|Ride"] = 228.11, ["Neon|Fly|Ride"] = 307.25, ["Mega|Ride"] = 681.19, ["Mega|Fly|Ride"] = 809.82}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.52, ["Fly"] = 23.62, ["Ride"] = 19.17, ["Fly|Ride"] = 39.24, ["Neon"] = 28.07, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 93.76, ["Mega"] = 164.07, ["Mega|Ride"] = 137.51, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 6.57, ["Fly"] = 97.93, ["Ride"] = 35.42, ["Fly|Ride"] = 69.8, ["Neon"] = 19.69, ["Neon|Ride"] = 58.34, ["Neon|Fly|Ride"] = 103.92, ["Mega"] = 207.31, ["Mega|Fly"] = 301.45, ["Mega|Ride"] = 186.47, ["Mega|Fly|Ride"] = 270.84}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 6.57, ["Neon|Ride"] = 197.33, ["Mega"] = 35.42, ["Mega|Fly|Ride"] = 189.58}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 48.98, ["Ride"] = 58.34, ["Fly|Ride"] = 124.9, ["Neon"] = 131.25, ["Neon|Ride"] = 181.26, ["Neon|Fly|Ride"] = 278.13, ["Mega"] = 1077.72, ["Mega|Ride"] = 734.08, ["Mega|Fly|Ride"] = 791.44}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Neon"] = 13.13, ["Neon|Fly"] = 145.69, ["Mega"] = 125.01, ["Mega|Ride"] = 208.34}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 6.48, ["Ride"] = 56.26, ["Neon"] = 69.8, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 291.67, ["Mega"] = 319.79, ["Mega|Ride"] = 392.44, ["Mega|Fly|Ride"] = 961.44}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 23.21, ["Ride"] = 18.62, ["Fly|Ride"] = 56.26, ["Neon"] = 24.92, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 107.29, ["Mega|Ride"] = 196.23, ["Mega|Fly|Ride"] = 311.46}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 3.28, ["Fly"] = 52.5, ["Ride"] = 24.94, ["Fly|Ride"] = 49.88, ["Neon"] = 52.5, ["Neon|Ride"] = 125.01, ["Mega"] = 308.11, ["Mega|Ride"] = 415.62, ["Mega|Fly|Ride"] = 325}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 3.14, ["Ride"] = 139.47, ["Neon"] = 22.31, ["Neon|Ride"] = 111.57, ["Mega"] = 140.6, ["Mega|Ride"] = 547.98, ["Mega|Fly|Ride"] = 414.58}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 35.44, ["Fly"] = 131.25, ["Ride"] = 143.07, ["Fly|Ride"] = 131.25, ["Neon"] = 190.32, ["Neon|Ride"] = 178.86, ["Mega"] = 892.5, ["Mega|Ride"] = 1249.97, ["Mega|Fly|Ride"] = 826.88}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 23.09, ["Ride"] = 250.01, ["Neon"] = 116.82, ["Mega"] = 262.5, ["Mega|Ride"] = 769.64, ["Mega|Fly|Ride"] = 449.99}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 20.79, ["Ride"] = 105, ["Neon"] = 115.4, ["Neon|Ride"] = 393.75, ["Mega"] = 157.5, ["Mega|Ride"] = 1540.43, ["Mega|Fly|Ride"] = 1666.62}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 39.38, ["Ride"] = 105, ["Fly|Ride"] = 422.03, ["Neon"] = 459.32, ["Mega"] = 766.5, ["Mega|Ride"] = 708.75, ["Mega|Fly|Ride"] = 556.24}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 3.66, ["Neon"] = 44.79, ["Mega"] = 833.32, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 28.14, ["Ride"] = 20.79, ["Fly|Ride"] = 50.02, ["Neon"] = 6.57, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 137.82, ["Mega"] = 94.8, ["Mega|Ride"] = 111.47, ["Mega|Fly|Ride"] = 258.56}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 9.45, ["Ride"] = 91.88, ["Fly|Ride"] = 87.52, ["Neon"] = 35.44, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 278.13, ["Mega|Ride"] = 485.41}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 32.28, ["Ride"] = 22.93, ["Fly|Ride"] = 55.13, ["Neon"] = 6.17, ["Neon|Ride"] = 30.45, ["Neon|Fly|Ride"] = 85.43, ["Mega"] = 40.09, ["Mega|Ride"] = 80.56, ["Mega|Fly|Ride"] = 184.64}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.6, ["Ride"] = 26.25, ["Fly|Ride"] = 97.93, ["Neon"] = 12.6, ["Neon|Ride"] = 92.32, ["Neon|Fly|Ride"] = 258.35, ["Mega"] = 249.38, ["Mega|Ride"] = 150.94, ["Mega|Fly|Ride"] = 461.56}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.77, ["Ride"] = 31.26, ["Fly|Ride"] = 99.75, ["Neon"] = 62.33, ["Neon|Ride"] = 111.47, ["Mega"] = 416.67, ["Mega|Ride"] = 416.67, ["Mega|Fly|Ride"] = 1249.97}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 3.81, ["Fly"] = 41.68, ["Ride"] = 22.42, ["Neon"] = 53.13, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 105, ["Mega|Ride"] = 184.64, ["Mega|Fly|Ride"] = 230.22}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 3.81, ["Fly"] = 34.07, ["Ride"] = 20.85, ["Fly|Ride"] = 58.34, ["Neon|Ride"] = 81.94, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 166.66, ["Mega|Ride"] = 173.96, ["Mega|Fly|Ride"] = 452.08}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 7.88, ["Ride"] = 347.33, ["Neon"] = 19.69, ["Neon|Fly"] = 139.59, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 154.63, ["Mega"] = 66.68, ["Mega|Ride"] = 305.82, ["Mega|Fly|Ride"] = 312.5}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 13.12, ["Ride"] = 99.25, ["Fly|Ride"] = 166.68, ["Neon"] = 80.94, ["Neon|Ride"] = 155.7, ["Neon|Fly|Ride"] = 361.47, ["Mega"] = 403.12, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 479.07, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 59.06, ["Fly"] = 196.17, ["Ride"] = 92.3, ["Fly|Ride"] = 196.88, ["Neon"] = 236.25, ["Neon|Ride"] = 278.1, ["Neon|Fly|Ride"] = 304.48, ["Mega"] = 1666.62, ["Mega|Ride"] = 1063.13, ["Mega|Fly|Ride"] = 1207.5}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 65.63, ["Neon"] = 3.94, ["Neon|Ride"] = 37.46, ["Mega"] = 31.18, ["Mega|Ride"] = 69.8, ["Mega|Fly|Ride"] = 111.47}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 15.64, ["Ride"] = 131.25, ["Neon"] = 54.17, ["Mega"] = 310.43, ["Mega|Ride"] = 361.47, ["Mega|Fly|Ride"] = 1236.42}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 77.1, ["Ride"] = 115.4, ["Neon|Ride"] = 1111.43, ["Mega|Ride"] = 1095.81, ["Mega|Fly|Ride"] = 1111.43}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 6.57, ["Fly"] = 190.32, ["Ride"] = 46.47, ["Fly|Ride"] = 126, ["Neon"] = 49.88, ["Neon|Ride"] = 59.07, ["Mega"] = 166.68, ["Mega|Ride"] = 173.25, ["Mega|Fly|Ride"] = 278.13}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 2.1, ["Fly"] = 157.5, ["Ride"] = 62.87, ["Fly|Ride"] = 115.64, ["Neon"] = 3.91, ["Neon|Ride"] = 27.53, ["Mega"] = 77.44, ["Mega|Ride"] = 54.39, ["Mega|Fly|Ride"] = 277.97}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 34.13, ["Ride"] = 20.77, ["Fly|Ride"] = 51.14, ["Neon"] = 15.75, ["Neon|Ride"] = 41.67, ["Neon|Fly|Ride"] = 125.01, ["Mega"] = 203.6, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 231}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 22.93, ["Ride"] = 18.04, ["Neon"] = 3.94, ["Neon|Ride"] = 28.13, ["Neon|Fly|Ride"] = 32.82, ["Mega"] = 23.63, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 25.02, ["Fly|Ride"] = 65.7, ["Neon"] = 3.93, ["Neon|Ride"] = 28.97, ["Neon|Fly|Ride"] = 83.35, ["Mega"] = 39.35, ["Mega|Fly"] = 168, ["Mega|Ride"] = 73.41, ["Mega|Fly|Ride"] = 154.63}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 28.14, ["Neon"] = 2.37, ["Neon|Ride"] = 154.63, ["Mega"] = 18.76, ["Mega|Ride"] = 104.19, ["Mega|Fly|Ride"] = 256.26}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 30.22, ["Ride"] = 31.18, ["Fly|Ride"] = 354.17, ["Neon"] = 34.5, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 624.99, ["Mega"] = 213.94, ["Mega|Ride"] = 307.3, ["Mega|Fly|Ride"] = 1110.39}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 11.47, ["Ride"] = 41.94, ["Fly|Ride"] = 208.34, ["Neon"] = 124.43, ["Neon|Ride"] = 200.8, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 196.88, ["Mega|Ride"] = 395.82, ["Mega|Fly|Ride"] = 354.17}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 7.88, ["Fly"] = 23.97, ["Ride"] = 20.85, ["Fly|Ride"] = 53.28, ["Neon"] = 62.33, ["Neon|Fly"] = 123.47, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 103.69, ["Mega|Ride"] = 311.07, ["Mega|Fly|Ride"] = 510.33}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 70.26, ["Ride"] = 91.88, ["Fly|Ride"] = 262.5, ["Neon"] = 412.51, ["Neon|Ride"] = 520.83}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 18.47, ["Ride"] = 41.64, ["Neon"] = 72.19, ["Neon|Fly"] = 125.01, ["Mega"] = 613.59, ["Mega|Fly"] = 639.57, ["Mega|Ride"] = 603.75, ["Mega|Fly|Ride"] = 1029.67}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 18.76, ["Fly|Ride"] = 40.4, ["Neon"] = 3.29, ["Neon|Fly"] = 41.68, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 39.24, ["Mega|Ride"] = 107.63, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 15.26, ["Ride"] = 18.76, ["Fly|Ride"] = 39.58, ["Neon"] = 4.18, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 23.09, ["Neon|Fly|Ride"] = 46.17, ["Mega"] = 38.07, ["Mega|Fly"] = 69.8, ["Mega|Ride"] = 57.7, ["Mega|Fly|Ride"] = 148.97}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 588.52, ["Fly"] = 694.78, ["Ride"] = 459.38, ["Fly|Ride"] = 551.25, ["Neon|Fly|Ride"] = 1522.5}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 15.64, ["Ride"] = 139.59, ["Neon"] = 105, ["Neon|Fly|Ride"] = 395.82, ["Mega"] = 495.48, ["Mega|Ride"] = 500, ["Mega|Fly|Ride"] = 347.91}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 28.14, ["Ride"] = 17.07, ["Fly|Ride"] = 32.31, ["Neon"] = 6.18, ["Neon|Ride"] = 20.85, ["Neon|Fly|Ride"] = 63.79, ["Mega"] = 154.63, ["Mega|Fly"] = 46.17, ["Mega|Ride"] = 71.55, ["Mega|Fly|Ride"] = 307.3}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 77.8, ["Ride"] = 120.85, ["Fly|Ride"] = 315, ["Neon"] = 223.13, ["Neon|Ride"] = 288.75, ["Neon|Fly|Ride"] = 472.91, ["Mega"] = 1041.64, ["Mega|Ride"] = 748.13, ["Mega|Fly|Ride"] = 1017.19}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 20.85, ["Ride"] = 22.93, ["Fly|Ride"] = 40.64, ["Neon"] = 15.64, ["Neon|Fly"] = 77.85, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 83.98, ["Mega"] = 128.63, ["Mega|Fly"] = 181.26, ["Mega|Ride"] = 115.27, ["Mega|Fly|Ride"] = 277.08}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Ride"] = 97.93, ["Fly|Ride"] = 1312.5, ["Neon"] = 3.87, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 69.8, ["Mega"] = 17.42, ["Mega|Ride"] = 111.47, ["Mega|Fly|Ride"] = 234.39}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 46.17, ["Ride"] = 131.25, ["Neon"] = 183.6, ["Neon|Fly"] = 452.08, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 819.77, ["Mega|Ride"] = 787.48, ["Mega|Fly|Ride"] = 692.34}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Neon"] = 10.43, ["Neon|Ride"] = 53.13, ["Mega"] = 96.94, ["Mega|Ride"] = 65.62, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 47.25, ["Fly"] = 139.59, ["Ride"] = 60.38, ["Fly|Ride"] = 208.34, ["Neon"] = 186.47, ["Neon|Ride"] = 194.8, ["Neon|Fly|Ride"] = 236.46, ["Mega|Ride"] = 1664.53}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 9.24, ["Ride"] = 31.26, ["Neon"] = 78.75, ["Neon|Ride"] = 416.67, ["Mega"] = 196.88, ["Mega|Ride"] = 822.94, ["Mega|Fly|Ride"] = 486.45}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.1, ["Fly"] = 69.8, ["Ride"] = 102.71, ["Neon"] = 10.97, ["Neon|Fly"] = 62.51, ["Neon|Ride"] = 56.26, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 97.93, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 556.24}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 27.57, ["Ride"] = 40.89, ["Fly|Ride"] = 91.88, ["Neon|Ride"] = 131.25, ["Mega|Ride"] = 2611.88, ["Mega|Fly|Ride"] = 1231.2}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 131.62, ["Ride"] = 89.25, ["Neon"] = 6.25, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 83.35, ["Neon|Fly|Ride"] = 168, ["Mega"] = 47.23, ["Mega|Fly"] = 158.61, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 306.96}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 46.15, ["Ride"] = 23.62, ["Fly|Ride"] = 72.17, ["Neon"] = 64.89, ["Neon|Fly"] = 41.88, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 105.59, ["Mega|Fly|Ride"] = 278.13}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 12.22, ["Ride"] = 36.47, ["Fly|Ride"] = 75.01, ["Neon"] = 39.38, ["Neon|Ride"] = 111.47, ["Mega"] = 254.63, ["Mega|Ride"] = 497.91, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 38.96, ["Ride"] = 69.8, ["Fly|Ride"] = 181.22, ["Neon"] = 145.63, ["Neon|Fly"] = 278.13, ["Neon|Ride"] = 207.72, ["Neon|Fly|Ride"] = 207.31, ["Mega"] = 519.75, ["Mega|Ride"] = 518.44, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 27.57, ["Fly"] = 181.26, ["Ride"] = 41.68, ["Fly|Ride"] = 79.16, ["Neon"] = 103.69, ["Neon|Ride"] = 83.35, ["Neon|Fly|Ride"] = 222.89, ["Mega"] = 616.19, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 59.07, ["Fly"] = 196.88, ["Ride"] = 103.94, ["Fly|Ride"] = 237.57, ["Neon"] = 341.25, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 520.83, ["Mega"] = 1258.69, ["Mega|Ride"] = 1302, ["Mega|Fly|Ride"] = 1334.82}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 3.93, ["Ride"] = 32.01, ["Fly|Ride"] = 262.5, ["Neon"] = 19.69, ["Neon|Ride"] = 139.59, ["Neon|Fly|Ride"] = 312.5, ["Mega"] = 154.63, ["Mega|Ride"] = 250.01, ["Mega|Fly|Ride"] = 328.79}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 4.6, ["Ride"] = 25.02, ["Fly|Ride"] = 108.34, ["Neon"] = 31.24, ["Neon|Ride"] = 69.8, ["Neon|Fly|Ride"] = 208.34, ["Mega"] = 154.18, ["Mega|Ride"] = 219.11, ["Mega|Fly|Ride"] = 308.11}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 17.8, ["Fly"] = 105, ["Ride"] = 46.57, ["Fly|Ride"] = 157.5, ["Neon"] = 122.8, ["Neon|Ride"] = 139.59, ["Neon|Fly|Ride"] = 168, ["Mega"] = 366.19, ["Mega|Fly|Ride"] = 458.07}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 15.64, ["Fly|Ride"] = 39.38, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 17.33, ["Neon|Fly|Ride"] = 62.33, ["Mega"] = 15.64, ["Mega|Fly"] = 77.33, ["Mega|Ride"] = 30.22, ["Mega|Fly|Ride"] = 98.44}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 68.25, ["Fly"] = 220.5, ["Ride"] = 416.67, ["Neon"] = 290.63, ["Neon|Fly"] = 2361.37, ["Neon|Ride"] = 266.53, ["Mega"] = 853.13, ["Mega|Fly"] = 952.06, ["Mega|Ride"] = 997.88, ["Mega|Fly|Ride"] = 955.42}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 23.09, ["Fly|Ride"] = 89.25, ["Neon"] = 3.94, ["Neon|Ride"] = 19.69, ["Mega"] = 106.25, ["Mega|Fly|Ride"] = 210.76}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 28.14, ["Ride"] = 31.5, ["Fly|Ride"] = 62.51, ["Neon"] = 39.38, ["Neon|Ride"] = 32.44, ["Neon|Fly|Ride"] = 92.32, ["Mega"] = 208.34, ["Mega|Ride"] = 208.34, ["Mega|Fly|Ride"] = 278.13}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 86.51, ["Fly"] = 208.34, ["Ride"] = 136.38, ["Fly|Ride"] = 423.95, ["Neon"] = 262.5, ["Neon|Ride"] = 230.67, ["Neon|Fly|Ride"] = 583.33, ["Mega"] = 986.43, ["Mega|Ride"] = 912.19, ["Mega|Fly|Ride"] = 1010.63}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 56.26, ["Neon"] = 6.57, ["Neon|Ride"] = 1389.54, ["Mega"] = 51.11, ["Mega|Ride"] = 91.2, ["Mega|Fly|Ride"] = 160.13}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 24.93}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 33.35, ["Fly|Ride"] = 104.99, ["Neon"] = 6.29, ["Neon|Ride"] = 64.6, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 40.63, ["Mega|Ride"] = 114.19, ["Mega|Fly|Ride"] = 227.07}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 147, ["Ride"] = 166.68, ["Fly|Ride"] = 272.92, ["Neon"] = 481.69, ["Neon|Ride"] = 553.11, ["Neon|Fly|Ride"] = 735, ["Mega|Fly|Ride"] = 2086.88}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 6.93, ["Ride"] = 41.99, ["Neon"] = 21.18, ["Neon|Ride"] = 40.69, ["Mega"] = 278.13, ["Mega|Ride"] = 385.41, ["Mega|Fly|Ride"] = 403.12}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.63, ["Fly"] = 208.34, ["Neon"] = 6.57, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 39.53, ["Mega|Ride"] = 83.35, ["Mega|Fly|Ride"] = 312.9}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 3.92, ["Ride"] = 30.85, ["Neon"] = 52.49, ["Neon|Ride"] = 139.59, ["Mega"] = 386.46, ["Mega|Ride"] = 278.13, ["Mega|Fly|Ride"] = 616.19}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 8.29, ["Fly"] = 73.97, ["Ride"] = 26.25, ["Neon"] = 62.33, ["Neon|Fly|Ride"] = 272.92, ["Mega"] = 350.07, ["Mega|Ride"] = 466.66, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 20.84, ["Ride"] = 62.43, ["Fly|Ride"] = 166.68, ["Neon"] = 152.98, ["Neon|Ride"] = 278.13, ["Neon|Fly|Ride"] = 278.13, ["Mega"] = 595.83, ["Mega|Fly|Ride"] = 616.87}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 140.69, ["Fly"] = 235.4, ["Ride"] = 132.56, ["Fly|Ride"] = 262.5, ["Neon"] = 557.9, ["Neon|Ride"] = 548.63, ["Neon|Fly|Ride"] = 641.81, ["Mega|Fly|Ride"] = 3056.15}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 7.88, ["Fly"] = 23.09, ["Ride"] = 19.8, ["Fly|Ride"] = 45.93, ["Neon"] = 36.75, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 97.93, ["Mega|Ride"] = 694.78, ["Mega|Fly|Ride"] = 360.94}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 3.82, ["Fly"] = 78.75, ["Fly|Ride"] = 131.25, ["Neon"] = 20.85, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 192.95, ["Mega"] = 187.51, ["Mega|Ride"] = 131.24, ["Mega|Fly|Ride"] = 461.56}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 9.74, ["Fly"] = 230.78, ["Fly|Ride"] = 165.63, ["Neon|Ride"] = 132.7, ["Mega"] = 500, ["Mega|Ride"] = 461.56, ["Mega|Fly|Ride"] = 503.62}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 40.69, ["Ride"] = 61.69, ["Fly|Ride"] = 98.64, ["Neon"] = 199.99, ["Neon|Ride"] = 208.31, ["Neon|Fly|Ride"] = 295.41, ["Mega|Fly"] = 972.89, ["Mega|Ride"] = 833.32, ["Mega|Fly|Ride"] = 880.69}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 19.69, ["Fly"] = 65.63, ["Ride"] = 81.38, ["Neon"] = 118.13, ["Neon|Ride"] = 208.34, ["Mega"] = 666.66, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 520.83}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 196.88, ["Ride"] = 413.44, ["Neon"] = 2153.05, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1561.41, ["Mega|Ride"] = 3937.5, ["Mega|Fly|Ride"] = 4119.25}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 31.47, ["Fly"] = 52.5, ["Ride"] = 41.99, ["Fly|Ride"] = 83.35, ["Neon"] = 278.13, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 1195.69, ["Mega|Ride"] = 611.45, ["Mega|Fly|Ride"] = 691.65}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 28.14, ["Ride"] = 15.75, ["Neon"] = 2.19, ["Neon|Ride"] = 19.94, ["Neon|Fly|Ride"] = 48.48, ["Mega"] = 18.88, ["Mega|Fly"] = 65.63, ["Mega|Ride"] = 48.98, ["Mega|Fly|Ride"] = 136.18}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 7.87, ["Ride"] = 59.07, ["Neon"] = 14.44, ["Neon|Ride"] = 39.38, ["Mega"] = 129.18, ["Mega|Ride"] = 154.63, ["Mega|Fly|Ride"] = 491.54}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 6.55, ["Ride"] = 39.37, ["Neon"] = 28.88, ["Neon|Ride"] = 77.33, ["Neon|Fly|Ride"] = 1181.25, ["Mega"] = 118.44, ["Mega|Fly"] = 222.93, ["Mega|Ride"] = 278.13, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 379.32, ["Fly"] = 576.95, ["Ride"] = 418.69, ["Fly|Ride"] = 458.07, ["Neon"] = 1528.08, ["Neon|Ride"] = 1377.04, ["Neon|Fly|Ride"] = 1345.32, ["Mega|Fly|Ride"] = 4791.48}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 3.29, ["Fly"] = 41.68, ["Ride"] = 18.38, ["Fly|Ride"] = 56.44, ["Neon"] = 46.17, ["Neon|Ride"] = 69.78, ["Neon|Fly|Ride"] = 71.18, ["Mega|Ride"] = 98.44, ["Mega|Fly|Ride"] = 831.23}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 4.6, ["Fly"] = 31.77, ["Ride"] = 23.97, ["Fly|Ride"] = 53.01, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 97.93, ["Mega"] = 416.67, ["Mega|Ride"] = 694.78, ["Mega|Fly|Ride"] = 833.32}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 5.25, ["Fly"] = 83.35, ["Ride"] = 30.01, ["Neon"] = 18.36, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 123.38, ["Mega"] = 147, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 483.32}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 38.66, ["Fly"] = 210, ["Ride"] = 61.47, ["Neon"] = 118.13, ["Neon|Ride"] = 250.01, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 262.5, ["Mega|Ride"] = 832.27, ["Mega|Fly|Ride"] = 640.49}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 315, ["Ride"] = 62.78, ["Neon"] = 14.44, ["Neon|Ride"] = 108.48, ["Neon|Fly|Ride"] = 210, ["Mega|Ride"] = 108.48, ["Mega|Fly|Ride"] = 620.17}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 3.29, ["Fly"] = 104.15, ["Ride"] = 24.93, ["Fly|Ride"] = 91.88, ["Neon"] = 308.11, ["Neon|Ride"] = 139.59, ["Mega"] = 694.78, ["Mega|Ride"] = 308.11, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 35.42, ["Neon"] = 6.18, ["Neon|Ride"] = 41.68, ["Mega"] = 125.01, ["Mega|Ride"] = 58.33, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 12.52, ["Ride"] = 69.57, ["Neon"] = 77.33, ["Mega"] = 196.88, ["Mega|Ride"] = 338.63, ["Mega|Fly|Ride"] = 624.99}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 11.81, ["Ride"] = 222.93, ["Neon"] = 154.63, ["Neon|Ride"] = 69.8, ["Mega"] = 416.67, ["Mega|Ride"] = 194.8, ["Mega|Fly|Ride"] = 1036.43}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 15.72, ["Fly"] = 37.49, ["Ride"] = 24.94, ["Fly|Ride"] = 50.09, ["Neon"] = 52.5, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 49.87, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 403.12, ["Mega|Ride"] = 375.38, ["Mega|Fly|Ride"] = 444.62}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 195.57, ["Fly"] = 498.75, ["Ride"] = 205.72, ["Fly|Ride"] = 288.75, ["Neon"] = 865.44, ["Neon|Ride"] = 917.68, ["Neon|Fly|Ride"] = 850.91, ["Mega|Fly|Ride"] = 2686.36}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Fly"] = 21.2, ["Ride"] = 18.38, ["Fly|Ride"] = 64.6, ["Neon"] = 20.85, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 108.29, ["Mega"] = 208.34, ["Mega|Ride"] = 319.79, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 2.1, ["Fly|Ride"] = 103.64, ["Neon"] = 17.43, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 334.69, ["Mega"] = 137.82, ["Mega|Ride"] = 416.67, ["Mega|Fly|Ride"] = 410.82}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 32.8, ["Ride"] = 115.64, ["Fly|Ride"] = 510.57, ["Neon"] = 104.09, ["Neon|Ride"] = 236.46, ["Neon|Fly|Ride"] = 624.91, ["Mega"] = 418.41, ["Mega|Ride"] = 378, ["Mega|Fly|Ride"] = 467.25}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 59.07, ["Fly"] = 393.75, ["Ride"] = 90.63, ["Fly|Ride"] = 205.26, ["Neon"] = 308.11, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 556.24, ["Mega|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 1456.21}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 26.24, ["Ride"] = 73.5, ["Fly|Ride"] = 208.34, ["Neon"] = 92.97, ["Neon|Ride"] = 160.39, ["Neon|Fly|Ride"] = 196.06, ["Mega"] = 214.46, ["Mega|Ride"] = 283.02, ["Mega|Fly|Ride"] = 393.63}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 22.93, ["Fly|Ride"] = 39.22, ["Neon"] = 15.64, ["Mega"] = 123.47, ["Mega|Fly|Ride"] = 347.91}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 18.38, ["Ride"] = 65.62, ["Neon"] = 58.86, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 307.13, ["Mega"] = 260.42, ["Mega|Ride"] = 307.3, ["Mega|Fly|Ride"] = 411.39}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 70.33, ["Ride"] = 111.57, ["Fly|Ride"] = 246.75, ["Neon"] = 225.67, ["Neon|Ride"] = 288.74, ["Neon|Fly|Ride"] = 278.13, ["Mega"] = 708.1, ["Mega|Ride"] = 535.5, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.1, ["Ride"] = 72.19, ["Neon"] = 11.43, ["Neon|Ride"] = 104.75, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 36.23, ["Mega|Fly"] = 105, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 221.82}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 11.42, ["Ride"] = 288.75, ["Neon"] = 51.19, ["Neon|Ride"] = 154.18, ["Mega"] = 312.5, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 947.63, ["Fly"] = 1365, ["Ride"] = 983.07, ["Fly|Ride"] = 1179.94, ["Neon|Ride"] = 3645.69, ["Neon|Fly|Ride"] = 2283.75, ["Mega|Fly|Ride"] = 10832.91}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 28.66, ["Ride"] = 125.01, ["Fly|Ride"] = 220.84, ["Neon"] = 154.63, ["Neon|Ride"] = 278.13, ["Mega"] = 590.63, ["Mega|Ride"] = 551.25, ["Mega|Fly|Ride"] = 620.82}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 5.25, ["Fly"] = 47.35, ["Ride"] = 39.38, ["Fly|Ride"] = 262.5, ["Neon"] = 15.63, ["Neon|Fly"] = 191.63, ["Neon|Ride"] = 45.93, ["Neon|Fly|Ride"] = 92.32, ["Mega"] = 103.67, ["Mega|Ride"] = 127.32, ["Mega|Fly|Ride"] = 352.08}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 11.69, ["Ride"] = 131.22, ["Neon"] = 78.75, ["Neon|Fly|Ride"] = 408.19, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 769.64}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Fly|Ride"] = 416.67, ["Neon"] = 2.37, ["Neon|Ride"] = 36.46, ["Neon|Fly|Ride"] = 97.93, ["Mega"] = 16.54, ["Mega|Ride"] = 62.99, ["Mega|Fly|Ride"] = 111.47}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 82.69, ["Ride"] = 173.96, ["Fly|Ride"] = 308.11, ["Neon"] = 315, ["Neon|Ride"] = 353.07, ["Neon|Fly|Ride"] = 556.24, ["Mega"] = 1312.5, ["Mega|Ride"] = 1443.75, ["Mega|Fly|Ride"] = 1195.69}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 7.71, ["Fly"] = 101.07, ["Ride"] = 48.97, ["Fly|Ride"] = 69.57, ["Neon"] = 33.34, ["Neon|Ride"] = 84, ["Mega"] = 345.83, ["Mega|Ride"] = 253.56, ["Mega|Fly|Ride"] = 361.47}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2.6, ["Ride"] = 28.14, ["Neon"] = 11.78, ["Neon|Ride"] = 28.88, ["Mega"] = 140.44, ["Mega|Ride"] = 246.94, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 44.87, ["Fly"] = 107.3, ["Ride"] = 89.59, ["Fly|Ride"] = 183.74, ["Neon"] = 158.41, ["Neon|Fly"] = 278.13, ["Neon|Ride"] = 288.44, ["Neon|Fly|Ride"] = 411.46, ["Mega"] = 535.5, ["Mega|Ride"] = 523.87, ["Mega|Fly|Ride"] = 458.07}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 11.82, ["Fly"] = 183.75, ["Neon"] = 91.87, ["Neon|Fly"] = 184.64, ["Neon|Ride"] = 194.8, ["Neon|Fly|Ride"] = 307.3, ["Mega"] = 414.58, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 66.94, ["Ride"] = 111.19, ["Neon"] = 556.17, ["Neon|Ride"] = 933.19, ["Neon|Fly|Ride"] = 919.42, ["Mega"] = 1347.88, ["Mega|Ride"] = 1806.18, ["Mega|Fly|Ride"] = 1348.92}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 6.57, ["Fly|Ride"] = 166.68, ["Neon"] = 17.07, ["Neon|Ride"] = 109.25, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 196.88, ["Mega|Ride"] = 204.18, ["Mega|Fly|Ride"] = 308.44}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 6.57, ["Fly"] = 196.88, ["Ride"] = 30.58, ["Neon"] = 72.17, ["Neon|Ride"] = 206.27, ["Neon|Fly|Ride"] = 280.88, ["Mega"] = 354.37, ["Mega|Ride"] = 392.44, ["Mega|Fly|Ride"] = 702.85}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 177.72, ["Ride"] = 216.67, ["Fly|Ride"] = 242.82, ["Neon"] = 543.38, ["Neon|Ride"] = 577.5, ["Neon|Fly|Ride"] = 546, ["Mega"] = 2362.5, ["Mega|Ride"] = 2361.19, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 39.22, ["Ride"] = 20.85, ["Fly|Ride"] = 35.44, ["Neon"] = 16.62, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 78.14, ["Mega"] = 181.26, ["Mega|Ride"] = 160.13, ["Mega|Fly|Ride"] = 174.57}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 7.87, ["Fly"] = 87.94, ["Ride"] = 32.41, ["Fly|Ride"] = 65.63, ["Neon"] = 18.74, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 83.35, ["Mega"] = 220.5, ["Mega|Fly"] = 231.26, ["Mega|Ride"] = 260.42, ["Mega|Fly|Ride"] = 447.96}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 28.14, ["Ride"] = 15.74, ["Fly|Ride"] = 35.94, ["Neon"] = 2.1, ["Neon|Fly"] = 31.18, ["Neon|Ride"] = 20.85, ["Neon|Fly|Ride"] = 41.68, ["Mega"] = 18.38, ["Mega|Ride"] = 32.29, ["Mega|Fly|Ride"] = 90.92}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 31.26, ["Neon"] = 3.94, ["Mega"] = 19.8, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 54.24, ["Mega|Fly|Ride"] = 139.59}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.61, ["Fly"] = 130.62, ["Ride"] = 71.37, ["Neon"] = 22.32, ["Neon|Ride"] = 64.98, ["Mega"] = 262.5, ["Mega|Ride"] = 206.27, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 19.69, ["Ride"] = 315, ["Neon"] = 225, ["Neon|Ride"] = 452.82, ["Neon|Fly|Ride"] = 630, ["Mega"] = 774.38, ["Mega|Ride"] = 556.24, ["Mega|Fly|Ride"] = 833.32}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.61, ["Fly"] = 15.64, ["Ride"] = 20.84, ["Fly|Ride"] = 56.25, ["Neon"] = 11.55, ["Neon|Fly"] = 36.93, ["Neon|Ride"] = 32.54, ["Neon|Fly|Ride"] = 70.84, ["Mega"] = 193.75, ["Mega|Fly"] = 184.64, ["Mega|Ride"] = 415.62, ["Mega|Fly|Ride"] = 162.74}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 6.18, ["Fly"] = 36.75, ["Ride"] = 26.24, ["Fly|Ride"] = 69.8, ["Neon"] = 28.14, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 92.32, ["Mega"] = 125.35, ["Mega|Fly"] = 278.13, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 182.44}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Ride"] = 18.76, ["Fly|Ride"] = 115.71, ["Neon"] = 6.57, ["Neon|Fly"] = 98.44, ["Neon|Ride"] = 35.42, ["Neon|Fly|Ride"] = 106.32, ["Mega"] = 51.16, ["Mega|Fly"] = 408.19, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 19.67, ["Ride"] = 61.47, ["Neon"] = 66.94, ["Neon|Ride"] = 59.04, ["Neon|Fly|Ride"] = 187.51, ["Mega"] = 250.01, ["Mega|Ride"] = 300, ["Mega|Fly|Ride"] = 479.16}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 9.19, ["Fly"] = 153.83, ["Neon"] = 13.13, ["Neon|Ride"] = 85.32, ["Mega"] = 393.75, ["Mega|Ride"] = 412.51, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 3.93, ["Fly"] = 35.44, ["Ride"] = 28.88, ["Fly|Ride"] = 138.49, ["Neon"] = 23.09, ["Neon|Fly"] = 196.65, ["Neon|Ride"] = 82.29, ["Neon|Fly|Ride"] = 105, ["Mega"] = 208.34, ["Mega|Ride"] = 206.26, ["Mega|Fly|Ride"] = 344.78}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.63, ["Ride"] = 16.86, ["Fly|Ride"] = 42.88, ["Neon"] = 15.22, ["Neon|Fly"] = 85.4, ["Neon|Ride"] = 50.02, ["Neon|Fly|Ride"] = 70.88, ["Mega"] = 97.93, ["Mega|Ride"] = 154.63, ["Mega|Fly|Ride"] = 223.91}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 199, ["Fly"] = 393.75, ["Ride"] = 292.58, ["Fly|Ride"] = 416.67, ["Neon"] = 898.93, ["Neon|Ride"] = 923.11, ["Neon|Fly|Ride"] = 944.77, ["Mega"] = 5556.03, ["Mega|Fly|Ride"] = 3661.88}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 5.09, ["Ride"] = 61.76, ["Neon"] = 26.25, ["Neon|Fly|Ride"] = 278.13, ["Mega"] = 154.18, ["Mega|Ride"] = 139.59, ["Mega|Fly|Ride"] = 972.89}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 3.02, ["Fly"] = 65.63, ["Ride"] = 17.33, ["Fly|Ride"] = 118.13, ["Neon"] = 37.51, ["Neon|Ride"] = 57.7, ["Neon|Fly|Ride"] = 139.65, ["Mega"] = 203.44, ["Mega|Ride"] = 459.38}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 6.3, ["Neon"] = 40.66, ["Neon|Fly|Ride"] = 624.99, ["Mega"] = 65.63, ["Mega|Ride"] = 407.29, ["Mega|Fly|Ride"] = 416.67}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 23.62, ["Fly|Ride"] = 33.79, ["Neon"] = 2.1, ["Neon|Fly"] = 28.46, ["Neon|Ride"] = 20.85, ["Neon|Fly|Ride"] = 49.64, ["Mega"] = 17.05, ["Mega|Ride"] = 31.18, ["Mega|Fly|Ride"] = 69.25}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.1, ["Fly"] = 56.44, ["Ride"] = 19.56, ["Fly|Ride"] = 40.93, ["Neon"] = 26.55, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 28.32, ["Neon|Fly|Ride"] = 84, ["Mega"] = 145.69}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.1, ["Ride"] = 153.41, ["Neon"] = 12.59, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 131.25, ["Mega|Ride"] = 147.71, ["Mega|Fly|Ride"] = 450.19}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 68.25, ["Fly"] = 183.35, ["Ride"] = 99.64, ["Fly|Ride"] = 152.36, ["Neon"] = 341.25, ["Neon|Ride"] = 383.25, ["Neon|Fly|Ride"] = 446.25, ["Mega|Ride"] = 3473.84, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 6.17, ["Fly"] = 85.32, ["Ride"] = 64.6, ["Fly|Ride"] = 139.59, ["Neon"] = 15.74, ["Neon|Ride"] = 70.12, ["Neon|Fly|Ride"] = 308.11}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Ride"] = 17.33, ["Fly|Ride"] = 154.18, ["Neon"] = 13.86, ["Neon|Ride"] = 125.01, ["Neon|Fly|Ride"] = 166.68, ["Mega"] = 66.94, ["Mega|Fly"] = 406.25, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 909.27}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 54.24, ["Fly"] = 124.69, ["Ride"] = 95.81, ["Neon"] = 166.69, ["Neon|Ride"] = 210.71, ["Neon|Fly|Ride"] = 330.74, ["Mega"] = 693.74, ["Mega|Ride"] = 519.75, ["Mega|Fly|Ride"] = 651}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 16.69, ["Ride"] = 22.73, ["Fly|Ride"] = 58.34, ["Neon"] = 2.63, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 22.68, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 18.38, ["Mega|Ride"] = 55.13, ["Mega|Fly|Ride"] = 126}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 60.02, ["Neon|Fly|Ride"] = 139.59, ["Mega"] = 36.71, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.1, ["Neon"] = 10.75, ["Neon|Ride"] = 56.48, ["Neon|Fly|Ride"] = 192.94, ["Mega"] = 78.75, ["Mega|Ride"] = 155.67, ["Mega|Fly|Ride"] = 307.13}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 6.57, ["Fly"] = 81.26, ["Ride"] = 50.22, ["Fly|Ride"] = 208.34, ["Neon"] = 26.92, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 179.18, ["Mega|Ride"] = 183.74, ["Mega|Fly|Ride"] = 293.74}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 15.64, ["Fly|Ride"] = 35.79, ["Neon"] = 2.5, ["Neon|Fly"] = 22.93, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 53.44, ["Mega"] = 21.94, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 31.18, ["Mega|Fly|Ride"] = 141.67}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 13.71, ["Ride"] = 42, ["Fly|Ride"] = 104.19, ["Neon"] = 60.85, ["Neon|Fly|Ride"] = 189.67, ["Mega|Ride"] = 445.83}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2887.5, ["Ride"] = 3176.25, ["Fly|Ride"] = 3179.53, ["Neon|Fly|Ride"] = 12718.13}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 52.49, ["Ride"] = 22.93, ["Fly|Ride"] = 60.43, ["Neon"] = 9.18, ["Neon|Fly"] = 68.43, ["Neon|Ride"] = 31.26, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 97.86, ["Mega|Ride"] = 94.75, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.1, ["Neon"] = 22.42, ["Mega"] = 126, ["Mega|Ride"] = 416.67, ["Mega|Fly|Ride"] = 312.5}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 18.47, ["Ride"] = 31.49, ["Fly|Ride"] = 157.5, ["Neon"] = 91.65, ["Neon|Ride"] = 78.14, ["Neon|Fly|Ride"] = 139.59, ["Mega"] = 479.16, ["Mega|Ride"] = 989.42, ["Mega|Fly|Ride"] = 624.99}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 43.32, ["Ride"] = 78.75, ["Fly|Ride"] = 139.59, ["Neon|Fly|Ride"] = 416.67, ["Mega"] = 1249.97, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 624.99}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 131.25, ["Fly"] = 1389.54, ["Ride"] = 172.07, ["Fly|Ride"] = 250.01, ["Neon"] = 815.81, ["Neon|Ride"] = 756, ["Neon|Fly|Ride"] = 800.63, ["Mega"] = 6249.75, ["Mega|Ride"] = 2986.35, ["Mega|Fly|Ride"] = 3538.94}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 5.94, ["Ride"] = 39.38, ["Fly|Ride"] = 111.47, ["Neon"] = 22.92, ["Neon|Ride"] = 138.49, ["Neon|Fly|Ride"] = 139.59, ["Mega"] = 807.73, ["Mega|Ride"] = 178.13, ["Mega|Fly|Ride"] = 253.32}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 27.09, ["Neon"] = 20.84, ["Neon|Fly"] = 95.85, ["Mega"] = 77.33, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 820.42}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 3.3, ["Fly"] = 101.99, ["Ride"] = 69.8, ["Fly|Ride"] = 118.13, ["Neon"] = 3.92, ["Neon|Ride"] = 41.68, ["Neon|Fly|Ride"] = 250.01, ["Mega"] = 70.82, ["Mega|Ride"] = 141.67, ["Mega|Fly|Ride"] = 287.44}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 15.68, ["Neon|Ride"] = 208.34, ["Mega"] = 196.88, ["Mega|Ride"] = 461.56, ["Mega|Fly|Ride"] = 344.78}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 69.78, ["Neon"] = 2.24, ["Neon|Ride"] = 41.68, ["Mega"] = 15.75, ["Mega|Ride"] = 133.88, ["Mega|Fly|Ride"] = 151.17}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 91.87, ["Fly"] = 415.42, ["Ride"] = 115.64, ["Fly|Ride"] = 139.59, ["Neon|Ride"] = 409.5, ["Neon|Fly|Ride"] = 455.44, ["Mega|Ride"] = 1666.62, ["Mega|Fly|Ride"] = 1249.97}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.63, ["Ride"] = 32.29, ["Neon"] = 10.31, ["Mega|Ride"] = 112.88}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 39.38, ["Fly"] = 215.79, ["Ride"] = 95.82, ["Fly|Ride"] = 178.13, ["Neon"] = 271.71, ["Neon|Ride"] = 387.34, ["Neon|Fly|Ride"] = 419.43, ["Mega"] = 2625, ["Mega|Ride"] = 2778.02, ["Mega|Fly|Ride"] = 1258.72}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 22.93, ["Fly|Ride"] = 69.8, ["Neon"] = 5.92, ["Neon|Ride"] = 35.42, ["Neon|Fly|Ride"] = 86.89, ["Mega"] = 52.5, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 211.98}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Neon"] = 11.82, ["Mega"] = 360.94, ["Mega|Ride"] = 139.59, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 13.06, ["Ride"] = 32.8, ["Neon"] = 62.33, ["Neon|Ride"] = 78.75, ["Mega"] = 166.68, ["Mega|Ride"] = 260.42, ["Mega|Fly|Ride"] = 452.82}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 420.13, ["Ride"] = 446.25, ["Fly|Ride"] = 590.63, ["Neon"] = 1179.94, ["Neon|Ride"] = 1128.75, ["Neon|Fly|Ride"] = 1258.69, ["Mega"] = 3333.21, ["Mega|Ride"] = 3181.14, ["Mega|Fly|Ride"] = 3389.46}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 38.07, ["Ride"] = 58.34, ["Fly|Ride"] = 78.75, ["Neon"] = 181.12, ["Neon|Fly"] = 308.11, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 184.64, ["Mega|Fly|Ride"] = 905.63}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 19.8, ["Fly|Ride"] = 91.88, ["Neon"] = 7.23, ["Neon|Fly"] = 135.43, ["Neon|Ride"] = 23.97, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 66.68, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 230.78}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 11.81, ["Fly"] = 70.3, ["Ride"] = 40.93, ["Fly|Ride"] = 69.8, ["Neon"] = 41.99, ["Neon|Fly"] = 123.47, ["Neon|Ride"] = 82.93, ["Neon|Fly|Ride"] = 181.26, ["Mega"] = 173.96, ["Mega|Fly"] = 372.86, ["Mega|Ride"] = 243.75, ["Mega|Fly|Ride"] = 409.5}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 7.97, ["Ride"] = 33.35, ["Fly|Ride"] = 86.46, ["Neon"] = 105, ["Neon|Ride"] = 68.25, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 445.83, ["Mega|Ride"] = 445.77, ["Mega|Fly|Ride"] = 300}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 8.82, ["Neon"] = 20.85, ["Mega"] = 52.5, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 184.64}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.1, ["Fly"] = 86.63, ["Ride"] = 19.69, ["Fly|Ride"] = 77.33, ["Neon"] = 26.24, ["Neon|Ride"] = 3194.68, ["Neon|Fly|Ride"] = 278.13, ["Mega"] = 538.86, ["Mega|Ride"] = 486.94}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 97.22, ["Fly"] = 160.42, ["Ride"] = 122.13, ["Fly|Ride"] = 236.25, ["Neon|Ride"] = 720.03, ["Neon|Fly|Ride"] = 761.44, ["Mega|Ride"] = 2528.03, ["Mega|Fly|Ride"] = 2307.76}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 28.14, ["Ride"] = 78.75, ["Fly|Ride"] = 144, ["Neon"] = 154.18, ["Neon|Ride"] = 278.13, ["Mega"] = 692.34, ["Mega|Ride"] = 665.61, ["Mega|Fly|Ride"] = 694.78}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2441.25, ["Ride"] = 2362.5, ["Fly|Ride"] = 2821.88, ["Neon"] = 12499.5, ["Neon|Fly|Ride"] = 8647.12, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 4.17, ["Fly"] = 65625, ["Ride"] = 22.1, ["Fly|Ride"] = 170.63, ["Neon"] = 12.47, ["Neon|Ride"] = 41.68, ["Mega"] = 105, ["Mega|Ride"] = 169.32}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 8.8, ["Ride"] = 52.5, ["Fly|Ride"] = 278.13, ["Neon"] = 63, ["Neon|Ride"] = 278.13, ["Neon|Fly|Ride"] = 347.91, ["Mega"] = 131.25, ["Mega|Fly"] = 139.59, ["Mega|Ride"] = 268.75, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 985.03, ["Ride"] = 1025.06, ["Fly|Ride"] = 1122.19, ["Neon"] = 4010.26, ["Neon|Ride"] = 4011.31, ["Neon|Fly|Ride"] = 3543.75, ["Mega|Ride"] = 14305.68, ["Mega|Fly|Ride"] = 13387.5}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 47.14, ["Ride"] = 93.19, ["Fly|Ride"] = 262.5, ["Neon"] = 315, ["Mega|Ride"] = 1384.66, ["Mega|Fly|Ride"] = 752.07}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 2.1, ["Ride"] = 41.68, ["Neon"] = 19.69, ["Neon|Ride"] = 68.77, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 190.98, ["Mega|Ride"] = 344.78, ["Mega|Fly|Ride"] = 273.97}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Mega"] = 31.5, ["Mega|Ride"] = 68.25, ["Mega|Fly|Ride"] = 125.01}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 77.44, ["Ride"] = 277.08, ["Neon"] = 694.78, ["Neon|Ride"] = 406.04, ["Mega"] = 5250, ["Mega|Fly|Ride"] = 2499.91}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 5.85, ["Ride"] = 139.59, ["Neon"] = 27.09, ["Neon|Ride"] = 139.59, ["Mega"] = 196.88, ["Mega|Ride"] = 154.63, ["Mega|Fly|Ride"] = 412.51}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 168, ["Ride"] = 139.59, ["Neon"] = 616.19, ["Mega"] = 2083.26, ["Mega|Fly|Ride"] = 1797.86}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 6.97, ["Fly"] = 105, ["Neon"] = 19.8, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 315, ["Mega"] = 222.93}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 262.5, ["Ride"] = 274.32, ["Fly|Ride"] = 354.38, ["Neon"] = 1766.63, ["Neon|Ride"] = 943.73, ["Neon|Fly|Ride"] = 1023.75, ["Mega|Fly|Ride"] = 3983.18}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 3.82, ["Fly"] = 69.8, ["Ride"] = 22.32, ["Fly|Ride"] = 83.35, ["Neon"] = 34.13, ["Neon|Ride"] = 56.26, ["Neon|Fly|Ride"] = 116.82, ["Mega"] = 250.04, ["Mega|Ride"] = 308.11, ["Mega|Fly|Ride"] = 350.44}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 27.09, ["Ride"] = 17.07, ["Fly|Ride"] = 43.63, ["Neon"] = 4.17, ["Neon|Fly"] = 28.88, ["Neon|Ride"] = 32.31, ["Neon|Fly|Ride"] = 60.43, ["Mega"] = 39.38, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 98.97}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 787.5, ["Fly"] = 1097.88, ["Ride"] = 903, ["Fly|Ride"] = 984.35, ["Neon|Ride"] = 3865.49, ["Neon|Fly|Ride"] = 3644.66, ["Mega"] = 29165.47, ["Mega|Fly|Ride"] = 27776.99}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 11.47, ["Fly"] = 980.19, ["Ride"] = 210, ["Neon"] = 45.85, ["Mega"] = 150.94, ["Mega|Ride"] = 214.59, ["Mega|Fly|Ride"] = 278.13}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 6.57, ["Fly"] = 56.26, ["Ride"] = 31.18, ["Fly|Ride"] = 90.63, ["Neon"] = 28.13, ["Neon|Fly"] = 76.17, ["Neon|Ride"] = 60.43, ["Neon|Fly|Ride"] = 278.13, ["Mega"] = 139.59, ["Mega|Ride"] = 196.87, ["Mega|Fly|Ride"] = 461.05}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 52.11, ["Fly"] = 32.82, ["Ride"] = 41.68, ["Fly|Ride"] = 68.23, ["Neon|Ride"] = 169.8, ["Neon|Fly|Ride"] = 200.8, ["Mega"] = 2083.26, ["Mega|Fly|Ride"] = 866.25}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 17.54, ["Fly"] = 78.14, ["Ride"] = 41.96, ["Fly|Ride"] = 92.32, ["Neon"] = 65.63, ["Neon|Ride"] = 82.89, ["Neon|Fly|Ride"] = 184.64, ["Mega"] = 556.24, ["Mega|Ride"] = 312.5, ["Mega|Fly|Ride"] = 442.31}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 20.85, ["Ride"] = 62.33, ["Fly|Ride"] = 636.57, ["Neon"] = 139.57, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 432.29, ["Mega|Ride"] = 494.82, ["Mega|Fly|Ride"] = 449.99}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 105, ["Neon"] = 2.63, ["Neon|Ride"] = 91.18, ["Mega"] = 23.98, ["Mega|Ride"] = 89.25}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 36.04, ["Fly"] = 56.25, ["Ride"] = 56.44, ["Fly|Ride"] = 77.44, ["Neon"] = 267.16, ["Neon|Fly"] = 310.21, ["Neon|Ride"] = 194.8, ["Neon|Fly|Ride"] = 334.69, ["Mega"] = 3333.21, ["Mega|Fly|Ride"] = 1052.05}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.1, ["Fly"] = 132.56, ["Ride"] = 27.56, ["Fly|Ride"] = 127.32, ["Neon"] = 15.64, ["Neon|Ride"] = 141.07, ["Mega"] = 773.07, ["Mega|Ride"] = 271.69, ["Mega|Fly|Ride"] = 666.66}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 25.02, ["Ride"] = 18.38, ["Fly|Ride"] = 69.8, ["Neon"] = 39.38, ["Neon|Fly|Ride"] = 108.48, ["Mega"] = 1029.14, ["Mega|Ride"] = 273.97, ["Mega|Fly|Ride"] = 202.13}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 6.57, ["Neon"] = 105, ["Neon|Fly|Ride"] = 104.19, ["Mega"] = 196.88, ["Mega|Ride"] = 196.88}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 25.02, ["Fly"] = 262.5, ["Ride"] = 41.68, ["Fly|Ride"] = 78.75, ["Neon"] = 116.8, ["Neon|Ride"] = 108.34, ["Neon|Fly|Ride"] = 208.34, ["Mega"] = 1111.43, ["Mega|Ride"] = 735, ["Mega|Fly|Ride"] = 769.64}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 9.18, ["Neon"] = 23.63, ["Neon|Ride"] = 62.93, ["Mega"] = 104.78, ["Mega|Fly|Ride"] = 308.11}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 27.28, ["Neon"] = 2.63, ["Neon|Ride"] = 91.88, ["Mega"] = 27.09, ["Mega|Ride"] = 41.68, ["Mega|Fly|Ride"] = 200.17}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Ride"] = 26.13, ["Neon"] = 2.63, ["Neon|Ride"] = 33.35, ["Mega"] = 20.84, ["Mega|Fly"] = 73.86, ["Mega|Ride"] = 111.47, ["Mega|Fly|Ride"] = 119.44}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 31.49, ["Ride"] = 23.63, ["Fly|Ride"] = 40.05, ["Neon"] = 10.47, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 36.47, ["Neon|Fly|Ride"] = 139.59, ["Mega"] = 86.63, ["Mega|Ride"] = 123.47, ["Mega|Fly|Ride"] = 239.59}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.63, ["Ride"] = 26.25, ["Fly|Ride"] = 5192.44, ["Neon"] = 20.85, ["Neon|Ride"] = 1312.5, ["Mega"] = 139.59, ["Mega|Ride"] = 146.88}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 39.59, ["Ride"] = 16.94, ["Fly|Ride"] = 39.59, ["Neon"] = 23.63, ["Neon|Ride"] = 23.25, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 210, ["Mega|Ride"] = 128.63, ["Mega|Fly|Ride"] = 363.56}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 82.66, ["Ride"] = 166.68, ["Fly|Ride"] = 389.59, ["Neon"] = 346.18, ["Neon|Ride"] = 248.07, ["Neon|Fly|Ride"] = 1041.64, ["Mega"] = 692.34, ["Mega|Ride"] = 1049.99, ["Mega|Fly|Ride"] = 926.02}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 26.06, ["Ride"] = 18.38, ["Fly|Ride"] = 36.93, ["Neon"] = 3.29, ["Neon|Fly"] = 27.09, ["Neon|Ride"] = 20.63, ["Neon|Fly|Ride"] = 66.68, ["Mega"] = 39.37, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 123.67}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 11.54, ["Fly"] = 62.31, ["Ride"] = 34.23, ["Fly|Ride"] = 80.07, ["Neon"] = 52.5, ["Neon|Ride"] = 56.1, ["Neon|Fly|Ride"] = 150.94, ["Mega"] = 525, ["Mega|Ride"] = 286.17, ["Mega|Fly|Ride"] = 414.58}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 14.43, ["Fly"] = 56.66, ["Ride"] = 26.25, ["Fly|Ride"] = 48.57, ["Neon"] = 92.3, ["Neon|Ride"] = 95.82, ["Neon|Fly|Ride"] = 111.47, ["Mega"] = 833.32, ["Mega|Ride"] = 548.96, ["Mega|Fly|Ride"] = 416.67}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 3.63, ["Fly"] = 140.38, ["Ride"] = 46.4, ["Neon"] = 38.27, ["Mega"] = 278.13, ["Mega|Ride"] = 241.5}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Ride"] = 17.33, ["Neon"] = 3.92, ["Neon|Fly"] = 81.38, ["Neon|Ride"] = 20.85, ["Neon|Fly|Ride"] = 108.48, ["Mega"] = 41.68, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 61.57, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 3.83, ["Ride"] = 28.13, ["Neon"] = 15.65, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 98.96, ["Neon|Fly|Ride"] = 208.34, ["Mega"] = 92.32, ["Mega|Fly"] = 735, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 379.16}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 984.38, ["Ride"] = 1115.63, ["Fly|Ride"] = 1076.25, ["Neon"] = 2718.12, ["Neon|Ride"] = 3022.01, ["Neon|Fly|Ride"] = 2231.25, ["Mega|Fly|Ride"] = 7434}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 55.13, ["Ride"] = 111.47, ["Fly|Ride"] = 97.93, ["Neon"] = 210, ["Neon|Ride"] = 264.58, ["Neon|Fly|Ride"] = 484.64, ["Mega"] = 2812.69, ["Mega|Ride"] = 1249.97, ["Mega|Fly|Ride"] = 1172.88}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Fly"] = 62.51, ["Neon"] = 6.57, ["Neon|Ride"] = 73.97, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 52.5, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 144.8}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 39.37, ["Ride"] = 72.93, ["Fly|Ride"] = 208.34, ["Neon"] = 198.96, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 300.57, ["Mega"] = 918.75, ["Mega|Ride"] = 759.94, ["Mega|Fly|Ride"] = 1124.96}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 6.03, ["Ride"] = 36.47, ["Neon"] = 41.67, ["Neon|Ride"] = 131.25, ["Mega"] = 431.55, ["Mega|Ride"] = 230.78, ["Mega|Fly|Ride"] = 1041.64}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 311.07, ["Fly"] = 923.11, ["Ride"] = 362.25, ["Fly|Ride"] = 422.63, ["Neon"] = 1228.08, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 1068.38, ["Mega|Fly|Ride"] = 6175.76}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.59, ["Fly"] = 102.38, ["Ride"] = 22.32, ["Fly|Ride"] = 114.19, ["Neon"] = 11.82, ["Neon|Ride"] = 73.5, ["Mega"] = 393.75}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Neon"] = 83.92, ["Neon|Ride"] = 139.59}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 27.41, ["Ride"] = 105, ["Fly|Ride"] = 208.34, ["Neon"] = 170.63, ["Neon|Ride"] = 307.3, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 653.12, ["Mega|Ride"] = 611.45, ["Mega|Fly|Ride"] = 556.24}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 3.91, ["Ride"] = 70.86, ["Fly|Ride"] = 139.59, ["Neon"] = 15.64, ["Mega"] = 220.84, ["Mega|Ride"] = 258.35, ["Mega|Fly|Ride"] = 416.67}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 23.63, ["Ride"] = 15.64, ["Fly|Ride"] = 32.82, ["Neon"] = 3.89, ["Neon|Fly"] = 31.18, ["Neon|Ride"] = 22.92, ["Neon|Fly|Ride"] = 48.57, ["Mega"] = 36.47, ["Mega|Ride"] = 40.69, ["Mega|Fly|Ride"] = 99.65}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4604.59, ["Ride"] = 4315.5, ["Fly|Ride"] = 3150, ["Neon"] = 24998.98, ["Neon|Fly|Ride"] = 25693.74, ["Mega|Fly|Ride"] = 77913.44}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 12.47, ["Ride"] = 56.44, ["Neon"] = 139, ["Neon|Ride"] = 85.32, ["Mega"] = 262.5, ["Mega|Ride"] = 389.59, ["Mega|Fly|Ride"] = 520.83}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.61, ["Ride"] = 27.09, ["Fly|Ride"] = 57.75, ["Neon"] = 15.74, ["Neon|Fly"] = 46.17, ["Neon|Ride"] = 35.68, ["Neon|Fly|Ride"] = 139.59, ["Mega"] = 154.63, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 154.63}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 420, ["Fly"] = 840, ["Ride"] = 472.5, ["Fly|Ride"] = 525, ["Neon"] = 1666.62, ["Neon|Ride"] = 1528.08, ["Neon|Fly|Ride"] = 1278.38, ["Mega|Fly|Ride"] = 5972.68}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 3.93, ["Ride"] = 62.51, ["Neon"] = 19.79, ["Neon|Ride"] = 69.8, ["Mega"] = 144.38, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 681.23}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 4.18, ["Fly"] = 99.75, ["Ride"] = 77.33, ["Neon"] = 139.59, ["Neon|Ride"] = 278.13, ["Neon|Fly|Ride"] = 13889.03, ["Mega"] = 278.13, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 60.38, ["Ride"] = 23.63, ["Neon"] = 6.57, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 33.71, ["Neon|Fly|Ride"] = 65.62, ["Mega"] = 92.32, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 240.33}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 616.88, ["Ride"] = 694.68, ["Fly|Ride"] = 761.25, ["Neon|Ride"] = 2100, ["Neon|Fly|Ride"] = 2194.71, ["Mega|Fly|Ride"] = 8751.75}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 6.57, ["Ride"] = 60.43, ["Neon"] = 31.26, ["Neon|Fly"] = 92.32, ["Neon|Ride"] = 89.59, ["Neon|Fly|Ride"] = 648.38, ["Mega"] = 120.75, ["Mega|Ride"] = 278.13, ["Mega|Fly|Ride"] = 346.23}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 10.5, ["Fly"] = 166.68, ["Ride"] = 48.98, ["Fly|Ride"] = 175.01, ["Neon"] = 44.63, ["Neon|Ride"] = 103.15, ["Neon|Fly|Ride"] = 3222.8, ["Mega"] = 242.81, ["Mega|Ride"] = 227.67, ["Mega|Fly|Ride"] = 333.38}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 40.4, ["Ride"] = 23.09, ["Fly|Ride"] = 51.19, ["Neon"] = 13.13, ["Neon|Ride"] = 33.35, ["Neon|Fly|Ride"] = 86.63, ["Mega"] = 128.63, ["Mega|Ride"] = 158.82, ["Mega|Fly|Ride"] = 266.44}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 39.37, ["Ride"] = 62.33, ["Fly|Ride"] = 115.4, ["Neon"] = 138.49, ["Neon|Ride"] = 138.49, ["Mega"] = 540.62, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 526.32}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Neon"] = 5.23, ["Neon|Ride"] = 56.26, ["Neon|Fly|Ride"] = 2019.29, ["Mega"] = 77.33, ["Mega|Ride"] = 94.63, ["Mega|Fly|Ride"] = 169.32}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 523.69, ["Ride"] = 438.27, ["Fly|Ride"] = 682.5, ["Neon"] = 2057.23, ["Neon|Ride"] = 2064.5, ["Neon|Fly|Ride"] = 2035.35, ["Mega|Fly|Ride"] = 9861.06}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 65.63, ["Neon"] = 5.25, ["Neon|Ride"] = 83.98, ["Neon|Fly|Ride"] = 104.19, ["Mega"] = 40.69, ["Mega|Ride"] = 119.6, ["Mega|Fly|Ride"] = 217.77}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 39.59, ["Neon"] = 3.93, ["Neon|Fly"] = 139.59, ["Neon|Ride"] = 144.8, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 35.42, ["Mega|Ride"] = 82.3, ["Mega|Fly|Ride"] = 261.45}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 45.92, ["Mega"] = 32.82, ["Mega|Ride"] = 97.92, ["Mega|Fly|Ride"] = 203.14}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.1, ["Ride"] = 124.69, ["Neon"] = 18.76, ["Mega"] = 222.93, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 40.68, ["Ride"] = 62.51, ["Fly|Ride"] = 156.19, ["Neon"] = 125.01, ["Neon|Ride"] = 208.32, ["Neon|Fly|Ride"] = 461.56, ["Mega"] = 497.44, ["Mega|Ride"] = 524.98, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 22.32, ["Ride"] = 82.69, ["Fly|Ride"] = 276.94, ["Neon"] = 85.31, ["Neon|Ride"] = 185.42, ["Neon|Fly|Ride"] = 278.13, ["Mega"] = 472.91, ["Mega|Ride"] = 519.79, ["Mega|Fly|Ride"] = 488.24}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 3.29, ["Fly"] = 26.25, ["Ride"] = 17.33, ["Fly|Ride"] = 44.78, ["Neon"] = 23.09, ["Neon|Ride"] = 35.07, ["Neon|Fly|Ride"] = 77.33, ["Mega"] = 307.79, ["Mega|Ride"] = 206.07, ["Mega|Fly|Ride"] = 238.88}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 12.68, ["Ride"] = 39.38, ["Neon"] = 278.13, ["Neon|Ride"] = 158.82, ["Neon|Fly|Ride"] = 210, ["Mega|Fly|Ride"] = 516.67}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 28.13, ["Fly|Ride"] = 115.4, ["Neon"] = 7.88, ["Neon|Ride"] = 34.63, ["Mega"] = 111.47, ["Mega|Ride"] = 145.84, ["Mega|Fly|Ride"] = 208.34}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 70.84, ["Ride"] = 31.49, ["Fly|Ride"] = 69.25, ["Neon"] = 208.34, ["Neon|Ride"] = 83.35, ["Neon|Fly|Ride"] = 222.93, ["Mega"] = 936.44, ["Mega|Ride"] = 923.11, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 95.76, ["Fly"] = 874.13, ["Neon"] = 308.11, ["Neon|Ride"] = 328.13, ["Mega|Ride"] = 590.63}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 47.36, ["Fly"] = 54.24, ["Ride"] = 78.73, ["Fly|Ride"] = 270.38, ["Neon"] = 297.94, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 403.1, ["Mega|Ride"] = 1631.6}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 46.17, ["Fly"] = 126.1, ["Ride"] = 97.93, ["Neon"] = 164.59, ["Neon|Ride"] = 184.64, ["Neon|Fly|Ride"] = 279.17, ["Mega"] = 769.64, ["Mega|Ride"] = 960.42, ["Mega|Fly|Ride"] = 932.27}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 24.94, ["Ride"] = 34.13, ["Neon"] = 412.51, ["Neon|Ride"] = 223.13, ["Mega"] = 833.32, ["Mega|Ride"] = 791.64, ["Mega|Fly|Ride"] = 1248.93}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 6.96, ["Fly"] = 52.5, ["Ride"] = 26.25, ["Fly|Ride"] = 85.32, ["Neon"] = 44.99, ["Neon|Fly"] = 166.68, ["Neon|Ride"] = 97.93, ["Neon|Fly|Ride"] = 199.5, ["Mega"] = 491.67, ["Mega|Ride"] = 345.18, ["Mega|Fly|Ride"] = 403.12}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 28.14, ["Ride"] = 16.69, ["Fly|Ride"] = 41.13, ["Neon"] = 3.91, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 21.1, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 40.69, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 186.38}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 917.44}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 30.19, ["Ride"] = 65.63, ["Fly|Ride"] = 262.5, ["Neon"] = 122.91, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 416.67, ["Mega"] = 556.24, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 694.78}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 56.26, ["Neon"] = 3.82, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 291.67, ["Mega"] = 28.14, ["Mega|Ride"] = 84.96, ["Mega|Fly|Ride"] = 217.88}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 26.25, ["Neon"] = 169.32, ["Neon|Ride"] = 347.91, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 711.38, ["Mega|Ride"] = 728.11, ["Mega|Fly|Ride"] = 590.62}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Mega"] = 24.94}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 3.87, ["Neon|Ride"] = 86.56, ["Mega"] = 36.47, ["Mega|Ride"] = 83.35, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 159.26, ["Ride"] = 165.51, ["Fly|Ride"] = 339.59, ["Neon"] = 665.61, ["Neon|Ride"] = 590.63, ["Neon|Fly|Ride"] = 762.48, ["Mega|Ride"] = 6346.3, ["Mega|Fly|Ride"] = 2034.37}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.61, ["Fly"] = 65.63, ["Ride"] = 26.24, ["Fly|Ride"] = 87.52, ["Neon"] = 11.42, ["Neon|Fly"] = 62.51, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 154.18, ["Mega"] = 32.82, ["Mega|Ride"] = 116.82, ["Mega|Fly|Ride"] = 416.67}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 36.47, ["Fly|Ride"] = 86.63, ["Neon"] = 6.57, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 419.99, ["Mega"] = 43.32, ["Mega|Fly"] = 41.68, ["Mega|Ride"] = 103.11}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 83.35, ["Neon"] = 3.93, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 35.44, ["Mega"] = 35.44, ["Mega|Ride"] = 74.82, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 91.88, ["Neon"] = 4.67, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 139.59, ["Mega"] = 40.91, ["Mega|Ride"] = 94.5, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 39.37, ["Ride"] = 77.33, ["Fly|Ride"] = 616.19, ["Neon"] = 336.99, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 972.89, ["Mega|Ride"] = 1041.64, ["Mega|Fly|Ride"] = 1247.88}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 3.14, ["Ride"] = 139.47, ["Neon"] = 22.31, ["Neon|Ride"] = 111.57, ["Mega"] = 140.6, ["Mega|Ride"] = 547.98, ["Mega|Fly|Ride"] = 414.58}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 347.82, ["Ride"] = 367.5, ["Fly|Ride"] = 438.48, ["Neon"] = 853.13, ["Neon|Ride"] = 1079.14, ["Neon|Fly|Ride"] = 1041.64, ["Mega|Fly|Ride"] = 3150}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 72.13}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 44.62}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 13.17}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 27.76}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 50.02}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 53.5}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 9.19}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 6.56}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 216.57}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 22.3}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 40.66}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 9}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 7.09}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 256.92}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 7.19}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 6.97}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 8.35}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 15.64}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 23.02}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 465.94}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 736.36}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 17.04}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1111.69}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 525}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 19.8}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 14.3}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.37}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 19.47}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 86.63}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 43.3}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 17.05}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 10.5}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 14.11}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 12.5}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 11.82}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.63}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 28.04}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 14.26}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 6.57}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 3.94}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 1575}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 116.7}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 301.86}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 4.18}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.24}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 10.64}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 40.36}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 23.24}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 153.57}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 10.5}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 12.44}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 177.06}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 24.94}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 13.13}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 26.23}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 7.62}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 4.64}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 107.63}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 18.35}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 9.19}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 3.82}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 113.71}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.37}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 9.85}},
    ["rbxassetid://1265129203"] = {name = "Ice Snowboard", prices = {["default"] = 215.69}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 3.29}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 21.99}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 149.26}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 98.43}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 5.25}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 9.18}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 19.09}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 27.57}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 58.69}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 52.45}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 166.31}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 32.82}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 45.41}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 34.18}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 270.8}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 25.78}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 34.1}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 74.8}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 231.21}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 49.12}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 39.38}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 28.88}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 40.68}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 350.83}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 4.6}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 10.5}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 3.59}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 6.28}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 23.63}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 48.18}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 4.17}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 4.91}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.63}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 3.15}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 4.61}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 6.57}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 12.71}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 669.38}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 26.23}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.61}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 6.26}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 372.87}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 45.94}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 230.76}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 38.07}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 32.82}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 132.57}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 19.8}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 5.23}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 15.74}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 3.82}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 3.94}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 3.94}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 40.95}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 3.93}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 3.87}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 4.85}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 9.19}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 137.82}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 52.5}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 3.93}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.63}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.63}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 235.38}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 8.86}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 9.4}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 7.07}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 18.38}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 210}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 20.85}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 3.82}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 15.08}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 18.25}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 111.45}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 48.35}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 10.43}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 5.91}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 4.73}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 6.57}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 5.86}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 6.26}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 196.88}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 45.94}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.24}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 4.45}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 3.94}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.5}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 7811.23}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 19.65}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 3.94}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 11.47}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 9.3}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 31.49}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 10.07}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 63}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 7.86}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 4.57}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 14.42}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 118.13}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.24}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 15.38}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 9.24}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 5.39}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 8.35}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 5.91}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 3.71}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 3.46}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4309.2}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 4.54}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.61}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 48.57}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.63}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 6.23}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 81.38}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 65.61}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 5.92}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 182.28}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.63}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 3.94}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 3.92}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.63}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 6.95}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 21}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 39.38}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 3.89}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.46}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 3.42}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 46.16}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 6.56}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 4.19}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 28.13}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 4.75}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.5}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 3.82}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 3.93}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.63}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 3.71}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 28.62}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.61}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 6.04}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 3.82}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 16.47}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 131.25}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 2.13}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 36.75}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 5.25}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1249.81}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 21.94}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 2.63}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 2.63}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.63}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 47.94}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 6.26}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 3.87}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 5.25}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 15.74}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 3.15}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 27.01}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 15.74}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 38.07}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 4.7}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 3.72}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 13.13}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 39.38}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 3.82}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 12.47}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 5.25}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 4.55}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 52.5}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.63}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 11.82}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.37}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 40.27}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.63}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 230.76}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 4.18}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 26.22}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 23.62}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 2.63}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 3.92}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 98.44}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 4.07}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 20.79}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 5.12}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.63}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.3}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 3.93}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 5.18}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 5.92}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 5.84}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 86.63}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 3.94}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.5}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 105}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 8.54}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1497.57}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 4.18}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 213.7}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 6.25}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.63}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 18.38}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 36.74}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 3.91}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 39.38}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 4.17}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 65.63}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 8.6}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 3.93}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 3.42}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.63}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.63}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 3.87}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 89.24}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 3.93}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 75.01}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 5.23}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 57.58}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.63}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 10.43}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 2.19}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.63}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 35.41}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 118.13}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 4.18}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 2.63}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.52}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 60.46}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 2.63}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 3.93}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.37}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 5.25}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 64.29}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 44.45}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 86.63}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 383.93}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 2.63}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 64.6}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.61}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 77.31}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 4.97}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 27.9}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 90.63}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 3.91}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 23.63}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 9.19}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 36.47}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 26.25}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.24}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 23.14}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 3.94}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 4.17}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 52.5}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 39.59}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 103.11}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 3.91}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 42.75}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 5.6}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 6.46}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 45.87}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 70.84}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 60.42}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1371.57}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 27.57}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 5.58}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 187.48}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 249.25}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 23.08}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 11.81}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 12.23}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 12.58}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 4.61}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 208.68}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 65.63}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 5.16}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 6.25}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 63.79}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 118.13}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 91.74}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 853.13}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 170.63}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 9.17}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 1107.75}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 525}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 2.61}},
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