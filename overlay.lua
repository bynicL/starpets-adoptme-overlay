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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 963.57, ["Ride"] = 1048.69, ["Fly|Ride"] = 1292.82, ["Neon"] = 6805.32, ["Neon|Ride"] = 6562.5, ["Neon|Fly|Ride"] = 4189.55, ["Mega|Fly|Ride"] = 17107.72}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 528.22, ["Ride"] = 564.38, ["Fly|Ride"] = 525, ["Neon|Fly|Ride"] = 2425.69, ["Mega|Fly|Ride"] = 6810.53}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 4948.13, ["Ride"] = 5117.44, ["Fly|Ride"] = 4689.57, ["Neon|Fly|Ride"] = 20635.36, ["Mega|Fly|Ride"] = 68793.41}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 138.26, ["Ride"] = 218.18, ["Fly|Ride"] = 275.36, ["Neon"] = 963.69, ["Neon|Ride"] = 825.43, ["Neon|Fly|Ride"] = 1026.62, ["Mega|Ride"] = 3889.72, ["Mega|Fly|Ride"] = 3937.49}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 632.62, ["Fly"] = 825.33, ["Ride"] = 538.12, ["Fly|Ride"] = 597.19, ["Neon|Fly|Ride"] = 1745.62, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 9.19, ["Ride"] = 29.14, ["Fly|Ride"] = 156.35, ["Neon"] = 39.29, ["Neon|Fly"] = 275.5, ["Neon|Ride"] = 120.74, ["Neon|Fly|Ride"] = 404.25, ["Mega"] = 324.84, ["Mega|Ride"] = 262.49, ["Mega|Fly|Ride"] = 582.75}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 3.75, ["Fly"] = 41.91, ["Ride"] = 21.29, ["Fly|Ride"] = 69.13, ["Neon"] = 27.57, ["Neon|Fly"] = 116.68, ["Neon|Ride"] = 53.94, ["Neon|Fly|Ride"] = 104.81, ["Mega"] = 154.49, ["Mega|Ride"] = 213.94, ["Mega|Fly|Ride"] = 277.35}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 117.36, ["Fly"] = 206.37, ["Ride"] = 152.27, ["Neon"] = 412.72, ["Neon|Ride"] = 493.5, ["Neon|Fly|Ride"] = 688.2, ["Mega|Ride"] = 1789.32, ["Mega|Fly|Ride"] = 2694.29}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 31.48, ["Fly"] = 97.67, ["Ride"] = 52.41, ["Fly|Ride"] = 99.06, ["Neon"] = 257.62, ["Neon|Ride"] = 237.93, ["Neon|Fly|Ride"] = 336.39, ["Mega"] = 2100}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 16.7, ["Fly"] = 69.14, ["Ride"] = 18.38, ["Fly|Ride"] = 69.16, ["Neon"] = 143.43, ["Neon|Ride"] = 243.43, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 605.74}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 57.64, ["Fly"] = 140.36, ["Ride"] = 78.75, ["Fly|Ride"] = 174.46, ["Neon"] = 402.8, ["Neon|Ride"] = 334.69, ["Neon|Fly|Ride"] = 417.38, ["Mega|Fly|Ride"] = 1279.57}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 65.13}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 313.48, ["Fly"] = 467.84, ["Ride"] = 315, ["Fly|Ride"] = 374.07, ["Neon|Ride"] = 1023.75, ["Neon|Fly|Ride"] = 1049.99, ["Mega|Fly|Ride"] = 4881.92}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 124.68, ["Fly"] = 179.64, ["Ride"] = 131.25, ["Fly|Ride"] = 144.38, ["Neon|Fly"] = 676.68, ["Neon|Fly|Ride"] = 654.94, ["Mega|Fly|Ride"] = 2993.99}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.6, ["Ride"] = 55.04, ["Fly|Ride"] = 131.24, ["Neon"] = 20.65, ["Neon|Fly"] = 96.99, ["Neon|Ride"] = 47.72, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 131.25, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 311.66, ["Mega|Fly|Ride"] = 307.56}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 189.89, ["Fly"] = 204.45, ["Ride"] = 157.5, ["Fly|Ride"] = 230.67, ["Neon"] = 816.69, ["Neon|Fly|Ride"] = 590.63, ["Mega|Fly|Ride"] = 2730}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 2.94, ["Fly"] = 24.55, ["Ride"] = 17.54, ["Fly|Ride"] = 31.5, ["Neon"] = 35.4, ["Neon|Ride"] = 76.37, ["Neon|Fly|Ride"] = 108.96, ["Mega"] = 206.37, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 412.77}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 91.88, ["Fly"] = 196.88, ["Ride"] = 129.94, ["Fly|Ride"] = 195.56, ["Neon"] = 385.9, ["Neon|Ride"] = 416.41, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 1547.66, ["Mega|Ride"] = 1632.88, ["Mega|Fly|Ride"] = 1630.41}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 37.74}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 61.69, ["Ride"] = 101.13, ["Fly|Ride"] = 172.32, ["Neon"] = 577.5, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 1376.39}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 14.2, ["Fly"] = 393.75, ["Ride"] = 32.15, ["Fly|Ride"] = 130.03, ["Neon"] = 206.3, ["Neon|Ride"] = 209.99, ["Neon|Fly|Ride"] = 367.5, ["Mega|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 916.33}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 41.9, ["Fly"] = 157.5, ["Ride"] = 61.3, ["Fly|Ride"] = 102.27, ["Neon"] = 674.8, ["Neon|Ride"] = 240.18, ["Neon|Fly|Ride"] = 301.88, ["Mega"] = 1632.27, ["Mega|Ride"] = 1376.55, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 39.26, ["Fly"] = 72.19, ["Ride"] = 157.5, ["Fly|Ride"] = 138.27, ["Neon"] = 209.9, ["Neon|Ride"] = 359.64, ["Neon|Fly|Ride"] = 467.25, ["Mega"] = 1967.44, ["Mega|Ride"] = 1101.05, ["Mega|Fly|Ride"] = 1260.99}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 22.32, ["Ride"] = 43.35, ["Fly|Ride"] = 138.27, ["Neon"] = 477.75, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 293.82, ["Mega"] = 874.95, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 39.17, ["Fly"] = 136.75, ["Ride"] = 57.72, ["Fly|Ride"] = 123.83, ["Neon"] = 157.5, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 322.88, ["Mega|Ride"] = 1124.82, ["Mega|Fly|Ride"] = 903.42}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 3.7, ["Fly"] = 24.41, ["Ride"] = 22.31, ["Fly|Ride"] = 52.22, ["Neon"] = 36.74, ["Neon|Fly"] = 101.07, ["Neon|Ride"] = 47.16, ["Neon|Fly|Ride"] = 95.45, ["Mega"] = 189.79, ["Mega|Fly"] = 304.39, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 236.04}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 393.75, ["Ride"] = 502.16, ["Fly|Ride"] = 538.13, ["Neon|Ride"] = 1857.19, ["Neon|Fly|Ride"] = 1964.82, ["Mega|Fly|Ride"] = 7552.47}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 12.66, ["Ride"] = 32, ["Fly|Ride"] = 58.34, ["Neon"] = 206.34, ["Neon|Ride"] = 138.27, ["Neon|Fly|Ride"] = 275.5, ["Mega|Fly|Ride"] = 671.66}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 8.27, ["Fly"] = 34.54, ["Ride"] = 19.34, ["Fly|Ride"] = 42, ["Neon"] = 71.17, ["Neon|Ride"] = 65.62, ["Neon|Fly|Ride"] = 113.23, ["Mega"] = 206.37, ["Mega|Ride"] = 446.25}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 90.57, ["Fly"] = 108.13, ["Ride"] = 90.02, ["Fly|Ride"] = 131.25, ["Neon"] = 354.95, ["Neon|Fly"] = 376.72, ["Neon|Ride"] = 385.9, ["Neon|Fly|Ride"] = 490.25, ["Mega"] = 3714.38, ["Mega|Ride"] = 7875, ["Mega|Fly|Ride"] = 2100}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 14.41, ["Ride"] = 26.17, ["Fly|Ride"] = 118.13, ["Neon"] = 114.54, ["Neon|Ride"] = 82.56, ["Neon|Fly|Ride"] = 192.95, ["Mega"] = 550.98, ["Mega|Ride"] = 787.35, ["Mega|Fly|Ride"] = 825.53}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 205.94, ["Fly"] = 348.75, ["Ride"] = 228.38, ["Fly|Ride"] = 288.75, ["Neon"] = 656.25, ["Neon|Ride"] = 619.07, ["Mega"] = 6190.62, ["Mega|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 3018.75}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 32}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.94, ["Fly"] = 31.4, ["Ride"] = 20.48, ["Fly|Ride"] = 59.29, ["Neon"] = 20.34, ["Neon|Fly"] = 5158.84, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 140.7, ["Mega"] = 161.44, ["Mega|Fly"] = 211.54, ["Mega|Ride"] = 155.01, ["Mega|Fly|Ride"] = 279.55}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 892.49, ["Fly"] = 2625, ["Ride"] = 991.58, ["Fly|Ride"] = 1058.58, ["Neon"] = 3907.33, ["Neon|Ride"] = 6053.4, ["Neon|Fly|Ride"] = 4278.75, ["Mega|Ride"] = 52484.77, ["Mega|Fly|Ride"] = 17083.5}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 3.94, ["Fly"] = 69.14, ["Ride"] = 20.23, ["Fly|Ride"] = 91.49, ["Neon"] = 138.27, ["Neon|Ride"] = 123.83, ["Neon|Fly|Ride"] = 206.37, ["Mega"] = 787.5, ["Mega|Ride"] = 963.81, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 184.5, ["Ride"] = 190.91, ["Fly|Ride"] = 236.25, ["Neon"] = 1789.1, ["Neon|Ride"] = 813.65, ["Neon|Fly|Ride"] = 918.75, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 3150}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 43.32}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 15.06, ["Fly"] = 110.41, ["Ride"] = 65.54, ["Fly|Ride"] = 138.27, ["Neon"] = 104.89, ["Neon|Ride"] = 138.27, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 684.53, ["Mega|Ride"] = 1088.67, ["Mega|Fly|Ride"] = 577.35}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.37}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 138.26, ["Ride"] = 136.49, ["Fly|Ride"] = 236.25, ["Neon|Ride"] = 773.07, ["Mega|Fly|Ride"] = 2723.17}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 165.08, ["Ride"] = 172.68, ["Fly|Ride"] = 274.31, ["Neon"] = 315, ["Neon|Fly"] = 550.98, ["Neon|Ride"] = 412.72, ["Neon|Fly|Ride"] = 525, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1466.06}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 36.95}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 52.5, ["Fly"] = 61.35, ["Ride"] = 39.38, ["Fly|Ride"] = 78.75, ["Neon|Ride"] = 367.52, ["Neon|Fly|Ride"] = 365.15, ["Mega|Fly|Ride"] = 1592.07}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 5.25, ["Fly"] = 69.14, ["Ride"] = 35.38, ["Fly|Ride"] = 157.49, ["Neon"] = 74.68, ["Neon|Ride"] = 125.63, ["Neon|Fly|Ride"] = 232.16, ["Mega"] = 241.45, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 328.41, ["Mega|Fly|Ride"] = 412.77}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 446.25, ["Fly"] = 432.33, ["Ride"] = 419.9, ["Fly|Ride"] = 511.88, ["Neon|Ride"] = 1804.86, ["Neon|Fly|Ride"] = 1647.54, ["Mega|Fly|Ride"] = 7155.19}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 95.82, ["Fly"] = 150.66, ["Ride"] = 118.12, ["Fly|Ride"] = 189.87, ["Neon"] = 459.38, ["Neon|Fly"] = 825.43, ["Neon|Ride"] = 757.33, ["Neon|Fly|Ride"] = 459.38, ["Mega|Ride"] = 2475.53, ["Mega|Fly|Ride"] = 2491.01}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 6052.66, ["Ride"] = 3961.13, ["Fly|Ride"] = 3577.16}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 39.37, ["Fly"] = 110.41, ["Ride"] = 45.92, ["Fly|Ride"] = 128.43, ["Neon|Ride"] = 308.2, ["Neon|Fly|Ride"] = 544.79, ["Mega"] = 1335.12, ["Mega|Ride"] = 1927.61, ["Mega|Fly|Ride"] = 1236.22}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 63, ["Ride"] = 99.75, ["Fly|Ride"] = 111.57, ["Neon"] = 575.75, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 525, ["Mega|Ride"] = 2202.08, ["Mega|Fly|Ride"] = 3422.7}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 31.6, ["Fly"] = 51.36, ["Ride"] = 45, ["Fly|Ride"] = 106.32, ["Neon"] = 262.5, ["Neon|Fly"] = 296.14, ["Neon|Ride"] = 137.38, ["Neon|Fly|Ride"] = 202.94, ["Mega"] = 2625, ["Mega|Ride"] = 777.95, ["Mega|Fly|Ride"] = 656.04}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 6.2}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 37.99, ["Fly"] = 393.75, ["Ride"] = 76.37, ["Fly|Ride"] = 64.95, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 550.98, ["Mega|Fly|Ride"] = 1569.89}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 45.29}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 223.12, ["Ride"] = 236.25, ["Fly|Ride"] = 318.93, ["Neon|Ride"] = 1073.05}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 984.37, ["Ride"] = 943.69, ["Fly|Ride"] = 1513.62, ["Neon"] = 2887.5, ["Neon|Ride"] = 3027.23, ["Neon|Fly|Ride"] = 2723.88}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 6.55}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 24.33, ["Fly"] = 39.35, ["Ride"] = 37.49, ["Fly|Ride"] = 65.38, ["Neon"] = 164.07, ["Neon|Ride"] = 134.48, ["Neon|Fly|Ride"] = 241.45, ["Mega|Ride"] = 918.65, ["Mega|Fly|Ride"] = 929.78}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 18.09}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5250, ["Fly"] = 6328.88, ["Ride"] = 6500.16, ["Fly|Ride"] = 4921.77, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 40744.51}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 11.22, ["Fly"] = 52.41, ["Ride"] = 23.63, ["Fly|Ride"] = 52.69, ["Neon"] = 95.82, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 219.19, ["Mega"] = 693, ["Mega|Ride"] = 621.22, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 14.43, ["Ride"] = 36.66, ["Neon"] = 72.1, ["Neon|Ride"] = 122.07, ["Neon|Fly|Ride"] = 192.95, ["Mega"] = 727.13, ["Mega|Ride"] = 770.2, ["Mega|Fly|Ride"] = 1028.82}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 70.87, ["Fly"] = 276.59, ["Ride"] = 74.39, ["Fly|Ride"] = 131.25, ["Neon|Ride"] = 382.8, ["Neon|Fly|Ride"] = 476.14, ["Mega"] = 4127.09}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 9.76, ["Fly"] = 150.93, ["Ride"] = 25.93, ["Fly|Ride"] = 125.99, ["Neon"] = 108.94, ["Neon|Ride"] = 133.08, ["Neon|Fly|Ride"] = 501.38, ["Mega|Ride"] = 740.35, ["Mega|Fly|Ride"] = 813.75}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1561.88, ["Fly"] = 2284.07, ["Ride"] = 1706.25, ["Fly|Ride"] = 1771.77, ["Neon|Ride"] = 4292.16, ["Neon|Fly|Ride"] = 3542.34, ["Mega|Fly|Ride"] = 12468.75}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 26248.69, ["Fly"] = 33016.58, ["Ride"] = 52500, ["Fly|Ride"] = 24937.4, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 71197.9, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 183750}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 16.98, ["Fly"] = 393.74, ["Ride"] = 67.26, ["Fly|Ride"] = 78.75, ["Neon"] = 275.5, ["Neon|Ride"] = 275.5, ["Neon|Fly|Ride"] = 550.98, ["Mega"] = 1085.43, ["Mega|Ride"] = 1141.88, ["Mega|Fly|Ride"] = 821.4}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 2.63, ["Fly"] = 72.89, ["Ride"] = 31.68, ["Fly|Ride"] = 145.4, ["Neon"] = 19.69, ["Neon|Fly"] = 145.06, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 132.29, ["Mega|Ride"] = 222.92, ["Mega|Fly|Ride"] = 328.02}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 23.63}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 6.24, ["Ride"] = 32, ["Fly|Ride"] = 124.68, ["Neon"] = 81.29, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 464.3, ["Mega"] = 306.17, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 626.07}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 810.28, ["Ride"] = 770.44, ["Fly|Ride"] = 811.38, ["Neon|Fly|Ride"] = 2499.73, ["Mega|Fly|Ride"] = 8806.21}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 905.5, ["Fly"] = 918.75, ["Ride"] = 827.94, ["Fly|Ride"] = 1100.91, ["Neon|Ride"] = 3192.3, ["Neon|Fly|Ride"] = 3109.21, ["Mega|Fly|Ride"] = 10551.19}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 15.49, ["Fly"] = 116.68, ["Ride"] = 35.26, ["Fly|Ride"] = 65.61, ["Neon"] = 72.19, ["Neon|Ride"] = 119.9, ["Neon|Fly|Ride"] = 234.23, ["Mega"] = 1204.13, ["Mega|Ride"] = 934.48, ["Mega|Fly|Ride"] = 655.27}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 35.44}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 45.66, ["Fly"] = 111.29, ["Ride"] = 75.51, ["Fly|Ride"] = 105, ["Neon"] = 468.43, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 420, ["Mega|Ride"] = 2020.47, ["Mega|Fly|Ride"] = 1664.25}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 97.81, ["Ride"] = 78.75, ["Fly|Ride"] = 210.02, ["Neon"] = 450.19, ["Neon|Ride"] = 324.16, ["Neon|Fly|Ride"] = 550.98, ["Mega"] = 1342.73, ["Mega|Fly|Ride"] = 2231.25}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 3.92, ["Fly"] = 30.55, ["Ride"] = 19.84, ["Fly|Ride"] = 38.66, ["Neon"] = 23.63, ["Neon|Fly"] = 524.98, ["Neon|Ride"] = 63.98, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 315.74, ["Mega|Fly|Ride"] = 688.28}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 124.66, ["Fly"] = 161.43, ["Ride"] = 168.33, ["Fly|Ride"] = 209.02, ["Neon"] = 498.75, ["Neon|Ride"] = 518.43, ["Neon|Fly|Ride"] = 519.65, ["Mega|Fly|Ride"] = 1929.38}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 4.14, ["Ride"] = 35.22, ["Fly|Ride"] = 116.61, ["Neon"] = 33.77, ["Neon|Ride"] = 139.12, ["Neon|Fly|Ride"] = 825.43, ["Mega"] = 170.63, ["Mega|Ride"] = 474.62, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 15.72, ["Fly"] = 41.43, ["Ride"] = 30.18, ["Fly|Ride"] = 76.37, ["Neon"] = 90.72, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 305.42, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 20.27, ["Ride"] = 55.74, ["Fly|Ride"] = 156.19, ["Neon"] = 263.11, ["Neon|Ride"] = 311.52, ["Mega"] = 918.74, ["Mega|Ride"] = 1161.57, ["Mega|Fly|Ride"] = 963.81}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 14.88, ["Fly"] = 178.76, ["Ride"] = 26.25, ["Fly|Ride"] = 67.38, ["Neon"] = 91.87, ["Neon|Ride"] = 114.59, ["Neon|Fly|Ride"] = 205.33, ["Mega|Fly|Ride"] = 997.86}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6877.96, ["Ride"] = 6555.94, ["Fly|Ride"] = 5496.74, ["Neon"] = 34392.95, ["Neon|Ride"] = 23625, ["Neon|Fly|Ride"] = 24556.09, ["Mega|Fly|Ride"] = 93306.24}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 210, ["Fly"] = 271.57, ["Ride"] = 223.13, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 700.02, ["Neon|Fly|Ride"] = 564.38, ["Mega|Fly|Ride"] = 2067.19}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 44.4, ["Fly"] = 139.54, ["Ride"] = 83.52, ["Fly|Ride"] = 180.22, ["Neon"] = 138.27, ["Neon|Fly"] = 242.03, ["Neon|Ride"] = 157.4, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 406.88, ["Mega|Ride"] = 417.38, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 3.4, ["Fly"] = 86.35, ["Ride"] = 33.04, ["Fly|Ride"] = 52.5, ["Neon"] = 20.9, ["Neon|Fly"] = 59.85, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 187.8, ["Mega"] = 341.25, ["Mega|Ride"] = 187.69, ["Mega|Fly|Ride"] = 348.75}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 51.85, ["Fly"] = 5342.54, ["Ride"] = 95.24, ["Fly|Ride"] = 219.02, ["Neon"] = 218.36, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 233.87, ["Neon|Fly|Ride"] = 373.35, ["Mega"] = 564.38, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 608.37}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 16485, ["Ride"] = 12009.38, ["Fly|Ride"] = 11812.5, ["Neon|Fly|Ride"] = 22837.5}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 236.25, ["Ride"] = 249.38, ["Fly|Ride"] = 459.37, ["Neon"] = 1521.36, ["Neon|Ride"] = 1376.39, ["Neon|Fly|Ride"] = 1575, ["Mega|Fly|Ride"] = 5902.46}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 61.92, ["Fly"] = 78.77, ["Ride"] = 57.18, ["Fly|Ride"] = 94.4, ["Neon"] = 1050, ["Neon|Ride"] = 281.31, ["Neon|Fly|Ride"] = 412.72, ["Mega|Fly|Ride"] = 3441.38}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 7.87, ["Fly"] = 44.35, ["Ride"] = 27.88, ["Fly|Ride"] = 72.12, ["Neon"] = 69.14, ["Neon|Fly"] = 264.85, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 468.43, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 379.1, ["Fly"] = 837.82, ["Ride"] = 392.43, ["Fly|Ride"] = 487.91, ["Neon"] = 1771.88, ["Neon|Ride"] = 1668.03, ["Neon|Fly|Ride"] = 1575, ["Mega|Fly|Ride"] = 4856.25}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 6.34, ["Fly"] = 102.16, ["Ride"] = 37.59, ["Fly|Ride"] = 111.19, ["Neon"] = 26.17, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 165.1, ["Mega"] = 137.81, ["Mega|Fly"] = 278.37, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 229.69}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 91.87, ["Fly"] = 135.18, ["Ride"] = 129.83, ["Fly|Ride"] = 223.13, ["Neon"] = 614.96, ["Neon|Ride"] = 524.9, ["Neon|Fly|Ride"] = 557.82, ["Mega|Fly|Ride"] = 2624.99}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 10.26, ["Fly"] = 18.15, ["Ride"] = 18.45, ["Fly|Ride"] = 27.09, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 90.02, ["Mega"] = 2476.25}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 8.89}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 62.99, ["Fly"] = 138.27, ["Ride"] = 45.94, ["Fly|Ride"] = 138.27, ["Neon"] = 421.32, ["Neon|Fly"] = 550.98, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 3095.31, ["Mega|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 1815.51}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 16.95, ["Fly"] = 102.16, ["Ride"] = 32.82, ["Fly|Ride"] = 93.19, ["Neon"] = 97.13, ["Neon|Ride"] = 109.18, ["Neon|Fly|Ride"] = 210, ["Mega|Fly|Ride"] = 811.09}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 20.35}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 56.43, ["Fly"] = 210, ["Ride"] = 81.29, ["Fly|Ride"] = 249.38, ["Neon"] = 218.18, ["Neon|Ride"] = 275.63, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 1547.66, ["Mega|Ride"] = 1513.8, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 4.8, ["Ride"] = 29.23, ["Fly|Ride"] = 133.02, ["Neon"] = 20.98, ["Neon|Ride"] = 101.51, ["Neon|Fly|Ride"] = 275.5, ["Mega"] = 124.67, ["Mega|Ride"] = 213.42}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 10.87, ["Fly"] = 52.5, ["Ride"] = 28.23, ["Fly|Ride"] = 65.63, ["Neon|Ride"] = 152.73, ["Neon|Fly|Ride"] = 206.37, ["Mega|Ride"] = 629.47, ["Mega|Fly|Ride"] = 590.28}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 438.38, ["Ride"] = 490.28, ["Fly|Ride"] = 393.75, ["Neon|Fly|Ride"] = 2751.75, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 32.63, ["Ride"] = 57.54, ["Fly|Ride"] = 135.18, ["Neon"] = 235.34, ["Neon|Ride"] = 262.5, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 1376.55}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 41.28, ["Fly"] = 117.64, ["Ride"] = 68.81, ["Fly|Ride"] = 152.73, ["Neon"] = 275.5, ["Neon|Ride"] = 412.72, ["Neon|Fly|Ride"] = 458.1, ["Mega|Fly|Ride"] = 912.21}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 27.87, ["Fly"] = 52.5, ["Ride"] = 59.05, ["Fly|Ride"] = 123.38, ["Neon"] = 92.75, ["Neon|Ride"] = 131.15, ["Neon|Fly|Ride"] = 325.52, ["Mega"] = 414.74, ["Mega|Ride"] = 445.79, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 9843.75, ["Fly"] = 10500, ["Ride"] = 13378.25, ["Fly|Ride"] = 8137.4, ["Neon|Fly|Ride"] = 16931.25, ["Mega|Fly|Ride"] = 38850}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1397.81, ["Fly"] = 1487.07, ["Ride"] = 1443.75, ["Fly|Ride"] = 1556.21, ["Neon|Fly|Ride"] = 4987.5, ["Mega|Fly|Ride"] = 14437.5}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 656.25, ["Ride"] = 560.39, ["Fly|Ride"] = 787.49, ["Neon"] = 2499.03, ["Neon|Fly|Ride"] = 2093.9, ["Mega|Fly|Ride"] = 6997.98}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 9.97, ["Fly"] = 18.14, ["Ride"] = 20.65, ["Fly|Ride"] = 40.5, ["Neon"] = 101.07, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 165.1, ["Mega|Fly|Ride"] = 536.6}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 4.69, ["Fly"] = 78.74, ["Ride"] = 26.25, ["Neon"] = 23.63, ["Neon|Ride"] = 54.94, ["Mega"] = 151.68, ["Mega|Ride"] = 172.64, ["Mega|Fly|Ride"] = 257.27}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 33.76, ["Fly"] = 63.09, ["Ride"] = 45.94, ["Fly|Ride"] = 102.59, ["Neon"] = 268.28, ["Neon|Ride"] = 169.31, ["Neon|Fly|Ride"] = 190.11, ["Mega|Fly|Ride"] = 582.65}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.5, ["Fly"] = 23.13, ["Ride"] = 17, ["Fly|Ride"] = 32.22, ["Neon"] = 31.48, ["Neon|Fly"] = 76.91, ["Neon|Ride"] = 43.64, ["Neon|Fly|Ride"] = 78.66, ["Mega"] = 206.37, ["Mega|Ride"] = 264.76}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 275.52, ["Fly"] = 369.49, ["Ride"] = 324.19, ["Fly|Ride"] = 419.55, ["Neon|Fly|Ride"] = 1645.69}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 19.69, ["Fly"] = 55.74, ["Ride"] = 30.94, ["Fly|Ride"] = 81.38, ["Neon"] = 208.94, ["Neon|Fly"] = 138.27, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 234.23, ["Mega|Ride"] = 787.4, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 10.4, ["Fly"] = 20.99, ["Ride"] = 17.43, ["Fly|Ride"] = 43.35, ["Neon"] = 82.56, ["Neon|Fly"] = 123.83, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 1575, ["Mega|Ride"] = 618.19, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 577.5, ["Fly"] = 1048.69, ["Ride"] = 520.15, ["Fly|Ride"] = 537.71, ["Neon|Fly|Ride"] = 2063.56, ["Mega|Fly|Ride"] = 9797.17}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1228.91, ["Ride"] = 1214.06, ["Fly|Ride"] = 1345.32, ["Neon"] = 4815.27, ["Neon|Ride"] = 4127.09, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 13782.3}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 86.62, ["Fly"] = 134.15, ["Ride"] = 103.69, ["Fly|Ride"] = 121.7, ["Neon"] = 971.25, ["Neon|Ride"] = 585.46, ["Neon|Fly|Ride"] = 590.63, ["Mega|Fly|Ride"] = 2270.18}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 138.26, ["Fly"] = 157.49, ["Ride"] = 171.7, ["Fly|Ride"] = 230.89, ["Neon"] = 851.73, ["Neon|Fly"] = 688.2, ["Neon|Ride"] = 522.38, ["Neon|Fly|Ride"] = 640.55, ["Mega|Ride"] = 3027.6, ["Mega|Fly|Ride"] = 2792.56}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 27.57, ["Ride"] = 53.72, ["Fly|Ride"] = 120.65, ["Neon"] = 385.9, ["Neon|Ride"] = 272.99, ["Mega|Ride"] = 2063.81, ["Mega|Fly|Ride"] = 909.12}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 157.5, ["Ride"] = 315, ["Fly|Ride"] = 550.98, ["Neon|Fly|Ride"] = 1305.83, ["Mega|Fly|Ride"] = 3854.15}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2242.79, ["Fly"] = 2216.69, ["Ride"] = 2483.25, ["Fly|Ride"] = 2371, ["Neon|Fly|Ride"] = 10317.68, ["Mega|Fly|Ride"] = 27991.89}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 53.69, ["Fly"] = 206.37, ["Ride"] = 51.83, ["Fly|Ride"] = 196.88, ["Neon"] = 511.88, ["Neon|Ride"] = 328.12, ["Neon|Fly|Ride"] = 343.87, ["Mega|Ride"] = 1101.05, ["Mega|Fly|Ride"] = 2476.57}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 643.13, ["Ride"] = 696.48, ["Fly|Ride"] = 649.59, ["Neon|Ride"] = 1513.62, ["Neon|Fly|Ride"] = 1260, ["Mega|Fly|Ride"] = 3359.54}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 38.66, ["Fly"] = 67.69, ["Ride"] = 45.91, ["Fly|Ride"] = 85.32, ["Neon|Ride"] = 266.09, ["Neon|Fly|Ride"] = 287.44, ["Mega|Fly|Ride"] = 1181.24}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.04, ["Fly"] = 43.4, ["Ride"] = 16.38, ["Fly|Ride"] = 50.3, ["Neon"] = 24.53, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 98.34, ["Mega"] = 169.32, ["Mega|Fly"] = 249.26, ["Mega|Ride"] = 182.1, ["Mega|Fly|Ride"] = 297.94}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 50.72, ["Ride"] = 138.27, ["Fly|Ride"] = 253.32, ["Neon"] = 343.11, ["Neon|Ride"] = 309.23, ["Neon|Fly|Ride"] = 688.2, ["Mega"] = 1508.46, ["Mega|Fly|Ride"] = 1429.16}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 826.87, ["Fly"] = 789.79, ["Ride"] = 813.75, ["Fly|Ride"] = 899.32, ["Neon|Ride"] = 2598.75, ["Neon|Fly|Ride"] = 2572.92, ["Mega|Fly|Ride"] = 8531.25}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 714.65, ["Ride"] = 963.69, ["Fly|Ride"] = 957.5, ["Neon|Fly|Ride"] = 4117.8, ["Mega|Fly|Ride"] = 14995.53}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 13.63, ["Fly"] = 26.25, ["Ride"] = 20.74, ["Fly|Ride"] = 37.69, ["Neon"] = 78.75, ["Neon|Ride"] = 123.83, ["Neon|Fly|Ride"] = 206.07, ["Mega|Fly|Ride"] = 700.95}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 7.65, ["Ride"] = 19.58, ["Fly|Ride"] = 69.14, ["Neon"] = 125.69, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 250.04, ["Mega"] = 518.44, ["Mega|Ride"] = 412.77, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 2.77, ["Ride"] = 23.63, ["Fly|Ride"] = 102.38, ["Neon"] = 20.52, ["Neon|Fly"] = 315.2, ["Neon|Ride"] = 54.46, ["Neon|Fly|Ride"] = 124.77, ["Mega"] = 155.74, ["Mega|Fly"] = 157.5, ["Mega|Ride"] = 273.95, ["Mega|Fly|Ride"] = 339.94}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 42, ["Fly"] = 57.25, ["Ride"] = 49.88, ["Fly|Ride"] = 101.28, ["Neon"] = 249.38, ["Neon|Ride"] = 203.44, ["Neon|Fly|Ride"] = 242.82, ["Mega|Fly|Ride"] = 1009.21}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 49.06, ["Ride"] = 135.19, ["Fly|Ride"] = 449.61, ["Neon"] = 424.07, ["Neon|Ride"] = 424.08, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1787.04, ["Mega|Ride"] = 1547.85, ["Mega|Fly|Ride"] = 1513.8}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 14.02, ["Fly"] = 43.3, ["Ride"] = 31.34, ["Fly|Ride"] = 82.95, ["Neon"] = 107.63, ["Neon|Ride"] = 118.02, ["Neon|Fly|Ride"] = 192.95, ["Mega"] = 617.43, ["Mega|Ride"] = 352.96, ["Mega|Fly|Ride"] = 485.14}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 30.18, ["Fly"] = 56.01, ["Ride"] = 41.28, ["Fly|Ride"] = 86.92, ["Neon"] = 323.99, ["Neon|Fly"] = 1376.39, ["Neon|Ride"] = 190.11, ["Neon|Fly|Ride"] = 196.76, ["Mega"] = 2100, ["Mega|Ride"] = 1028.82, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 2.13, ["Fly"] = 20.87, ["Ride"] = 15.31, ["Fly|Ride"] = 41.91, ["Neon"] = 28.98, ["Neon|Ride"] = 60.38, ["Neon|Fly|Ride"] = 91.72, ["Mega"] = 732.38, ["Mega|Ride"] = 363.24, ["Mega|Fly|Ride"] = 551.06}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 5.24, ["Fly"] = 44.08, ["Ride"] = 32, ["Fly|Ride"] = 76.13, ["Neon"] = 31.71, ["Neon|Fly"] = 115.54, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 163.04, ["Mega"] = 288.91, ["Mega|Ride"] = 311.85, ["Mega|Fly|Ride"] = 551.06}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 50.34, ["Fly"] = 65.63, ["Ride"] = 52.31, ["Fly|Ride"] = 94.5, ["Neon"] = 404.85, ["Neon|Ride"] = 247.65, ["Neon|Fly|Ride"] = 192.95, ["Mega|Fly|Ride"] = 1074.06}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1574.99, ["Fly"] = 1574.99, ["Ride"] = 1365, ["Fly|Ride"] = 1443.75, ["Neon|Fly|Ride"] = 3858.74, ["Mega|Fly|Ride"] = 13008.41}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 446.25, ["Fly"] = 479.75, ["Ride"] = 459.38, ["Fly|Ride"] = 511.77, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 9631.73}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 303.14, ["Ride"] = 309.54, ["Fly|Ride"] = 556.65, ["Neon"] = 984.38, ["Neon|Ride"] = 1252.58, ["Neon|Fly|Ride"] = 1650.85, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 44.61}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 26.25, ["Ride"] = 42.95, ["Fly|Ride"] = 98.43, ["Neon|Ride"] = 356.04, ["Neon|Fly|Ride"] = 412.72, ["Mega|Ride"] = 1417.84, ["Mega|Fly|Ride"] = 1038.19}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 34388.69, ["Fly"] = 65625, ["Ride"] = 35437.5, ["Fly|Ride"] = 16406.25, ["Neon|Fly|Ride"] = 38062.5, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 299.43, ["Fly"] = 611.63, ["Ride"] = 367.5, ["Fly|Ride"] = 426.56, ["Neon"] = 1341.32, ["Neon|Fly"] = 1244.85, ["Neon|Ride"] = 1147.13, ["Neon|Fly|Ride"] = 891.19, ["Mega"] = 4675.98, ["Mega|Ride"] = 4126.57, ["Mega|Fly|Ride"] = 3871.88}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 194.15, ["Fly"] = 525, ["Ride"] = 138.27, ["Fly|Ride"] = 196.88}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 143.41, ["Fly"] = 275.5, ["Ride"] = 144.38, ["Fly|Ride"] = 223.13, ["Neon|Ride"] = 757.33, ["Neon|Fly|Ride"] = 803.76, ["Mega|Fly|Ride"] = 3018.75}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 11.45, ["Fly"] = 94.5, ["Ride"] = 29.96, ["Fly|Ride"] = 57.8, ["Neon|Ride"] = 138.27, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 697.22, ["Mega|Ride"] = 551.06, ["Mega|Fly|Ride"] = 660.42}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 3921.75, ["Ride"] = 3937.5, ["Fly|Ride"] = 4651.79, ["Neon"] = 26825.97, ["Neon|Fly|Ride"] = 27238.68, ["Mega|Fly|Ride"] = 62204.96}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 29.54, ["Fly"] = 32.81, ["Ride"] = 29.01, ["Fly|Ride"] = 68.11, ["Neon"] = 337.32, ["Neon|Ride"] = 343.88, ["Neon|Fly|Ride"] = 209.85, ["Mega|Fly|Ride"] = 825.53}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 32.82, ["Fly"] = 106.51, ["Ride"] = 55.34, ["Fly|Ride"] = 94.8, ["Neon"] = 403.96, ["Neon|Fly"] = 1376.39, ["Neon|Ride"] = 204.75, ["Neon|Fly|Ride"] = 216.57, ["Mega|Fly|Ride"] = 1372.87}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 679.76, ["Ride"] = 705.34, ["Fly|Ride"] = 754.92, ["Neon"] = 2570.3, ["Neon|Ride"] = 1968.75, ["Neon|Fly|Ride"] = 1942.5, ["Mega"] = 8047.8, ["Mega|Fly"] = 8047.8, ["Mega|Fly|Ride"] = 6746.25}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 15.49, ["Fly"] = 23.84, ["Ride"] = 24.65, ["Fly|Ride"] = 39.26, ["Neon"] = 115.5, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 171.54, ["Mega|Fly|Ride"] = 640.5}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 12.49, ["Fly"] = 275.5, ["Ride"] = 27.56, ["Fly|Ride"] = 78.19, ["Neon"] = 91.88, ["Neon|Ride"] = 116.68, ["Neon|Fly|Ride"] = 124.74, ["Mega|Ride"] = 720.28, ["Mega|Fly|Ride"] = 551.06}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 96.5, ["Ride"] = 123.83, ["Fly|Ride"] = 262.5, ["Neon"] = 605.67, ["Neon|Ride"] = 530.25, ["Neon|Fly|Ride"] = 605.67, ["Mega|Fly|Ride"] = 2752.09}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 16.52, ["Fly"] = 140.26, ["Ride"] = 57.85, ["Fly|Ride"] = 131.15, ["Neon"] = 68.16, ["Neon|Ride"] = 140.21, ["Neon|Fly|Ride"] = 238.04, ["Mega"] = 313.69, ["Mega|Fly"] = 723.52, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 400.32}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3930.83, ["Ride"] = 3883.64, ["Fly|Ride"] = 4160.62, ["Neon"] = 13069.42, ["Neon|Ride"] = 11812.5, ["Neon|Fly|Ride"] = 9841.13, ["Mega"] = 36181.01, ["Mega|Fly|Ride"] = 35456.38}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 34.44, ["Fly"] = 143.51, ["Ride"] = 65.33, ["Fly|Ride"] = 102.16, ["Neon"] = 757.31, ["Neon|Ride"] = 190.32, ["Neon|Fly|Ride"] = 574.23, ["Mega"] = 825.43, ["Mega|Ride"] = 1023.66, ["Mega|Fly|Ride"] = 782.25}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 7271.25, ["Fly"] = 7567, ["Ride"] = 6857.82, ["Fly|Ride"] = 6339.05, ["Neon|Ride"] = 18984.54, ["Neon|Fly|Ride"] = 17850, ["Mega|Fly|Ride"] = 80930.56}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.62, ["Fly"] = 20.69, ["Ride"] = 15.88, ["Fly|Ride"] = 29.57, ["Neon"] = 24.94, ["Neon|Fly"] = 62.61, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 87.94, ["Mega"] = 451.22, ["Mega|Fly|Ride"] = 341.58}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 13.97, ["Fly"] = 28.82, ["Ride"] = 26.37, ["Fly|Ride"] = 48.5, ["Neon"] = 192.95, ["Neon|Fly"] = 228.03, ["Neon|Ride"] = 550.98, ["Neon|Fly|Ride"] = 153.2, ["Mega|Fly|Ride"] = 935.82}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 4.11}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 18.38, ["Ride"] = 32.6, ["Fly|Ride"] = 116.01, ["Neon"] = 270.04, ["Neon|Ride"] = 157.67, ["Mega"] = 790.57, ["Mega|Ride"] = 865.77, ["Mega|Fly|Ride"] = 1568.02}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 28.86, ["Fly"] = 190.37, ["Ride"] = 41.28, ["Fly|Ride"] = 99.73, ["Neon"] = 208.44, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 317.05, ["Mega"] = 945, ["Mega|Fly|Ride"] = 1099.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 11.69, ["Fly"] = 17.73, ["Ride"] = 21.27, ["Fly|Ride"] = 35.07, ["Neon|Fly"] = 110.41, ["Neon|Ride"] = 217.88, ["Neon|Fly|Ride"] = 179.55, ["Mega"] = 2476.25, ["Mega|Ride"] = 582.01, ["Mega|Fly|Ride"] = 523.19}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8357.33}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2624.97}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 39.38}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 232.79, ["Ride"] = 247.65, ["Fly|Ride"] = 223.12, ["Mega|Fly|Ride"] = 5584.64}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 16.52, ["Fly"] = 130.03, ["Ride"] = 39.38, ["Fly|Ride"] = 140.02, ["Neon"] = 138.27, ["Neon|Ride"] = 116.81, ["Neon|Fly|Ride"] = 265.13, ["Mega|Ride"] = 514.37, ["Mega|Fly|Ride"] = 1732.5}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 12.48}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 4.66, ["Ride"] = 29.93, ["Fly|Ride"] = 82.56, ["Neon|Ride"] = 179.54, ["Mega|Fly|Ride"] = 825.53}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 3051.63}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 163.34, ["Fly"] = 412.72, ["Ride"] = 275.5, ["Fly|Ride"] = 328.13, ["Neon"] = 825.43, ["Neon|Ride"] = 774.38, ["Neon|Fly|Ride"] = 825.43, ["Mega|Ride"] = 3164.84, ["Mega|Fly|Ride"] = 3441.38}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 70.88, ["Ride"] = 106.32, ["Fly|Ride"] = 206.37, ["Neon"] = 550.98, ["Neon|Ride"] = 502.51, ["Neon|Fly|Ride"] = 601.62, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 156.19, ["Fly"] = 349.67, ["Ride"] = 201.98, ["Fly|Ride"] = 261.7, ["Neon"] = 787.5, ["Neon|Ride"] = 787.4, ["Neon|Fly|Ride"] = 963.69, ["Mega|Fly|Ride"] = 4540.35}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1966.13, ["Fly"] = 1968.75, ["Ride"] = 2212.53, ["Fly|Ride"] = 1837.5, ["Neon"] = 8166.73, ["Neon|Fly|Ride"] = 6561.18, ["Mega|Fly|Ride"] = 18375}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 16.52, ["Fly"] = 96.98, ["Ride"] = 56.8, ["Fly|Ride"] = 70.16, ["Neon"] = 127.32, ["Neon|Ride"] = 154.62, ["Neon|Fly|Ride"] = 192.95, ["Mega"] = 927.57, ["Mega|Ride"] = 1011.22, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 686.44, ["Fly"] = 2100, ["Ride"] = 727.65, ["Fly|Ride"] = 949.24, ["Neon|Fly|Ride"] = 4042.19, ["Mega|Fly|Ride"] = 16328.61}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 42}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 16.42, ["Ride"] = 42, ["Fly|Ride"] = 647.98, ["Neon"] = 81.38, ["Neon|Ride"] = 138.27, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 398.9, ["Mega|Ride"] = 514.56, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 8.27, ["Fly"] = 165.55, ["Ride"] = 27.57, ["Fly|Ride"] = 96.77, ["Neon"] = 53.03, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 210, ["Mega"] = 918.75, ["Mega|Ride"] = 412.77, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 89.78}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 13.19, ["Fly"] = 108.92, ["Ride"] = 23.61, ["Fly|Ride"] = 80.49, ["Neon"] = 93.35, ["Neon|Ride"] = 247.65, ["Neon|Fly|Ride"] = 236.25, ["Mega|Ride"] = 825.53, ["Mega|Fly|Ride"] = 1927.61}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 21.61, ["Fly"] = 39.37, ["Ride"] = 45.52, ["Fly|Ride"] = 52.4, ["Neon|Ride"] = 412.72, ["Neon|Fly|Ride"] = 328.12, ["Mega"] = 963.69, ["Mega|Ride"] = 1749.5, ["Mega|Fly|Ride"] = 894.67}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6300, ["Fly"] = 11005.87, ["Ride"] = 7778.23, ["Fly|Ride"] = 4593.75, ["Neon|Fly|Ride"] = 11588.07, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 10.4, ["Fly"] = 65.62, ["Ride"] = 27.78, ["Fly|Ride"] = 74.68, ["Neon"] = 69.14, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 138.27, ["Mega"] = 412.72, ["Mega|Ride"] = 412.77, ["Mega|Fly|Ride"] = 695.37}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 21}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 96.98, ["Fly"] = 365.27, ["Ride"] = 132.6, ["Fly|Ride"] = 220.81, ["Neon"] = 481.85, ["Neon|Ride"] = 378, ["Neon|Fly|Ride"] = 725.34, ["Mega"] = 2879.59, ["Mega|Fly|Ride"] = 1927.61}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 46.1, ["Fly"] = 140.05, ["Ride"] = 67.5, ["Fly|Ride"] = 91.88, ["Neon"] = 255.93, ["Neon|Ride"] = 265.13, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 2331.81, ["Mega|Ride"] = 2786.14, ["Mega|Fly|Ride"] = 1789.32}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 23.54, ["Fly"] = 70.47, ["Ride"] = 27.46, ["Fly|Ride"] = 59.73, ["Neon"] = 128.77, ["Neon|Fly"] = 234.23, ["Neon|Ride"] = 168, ["Neon|Fly|Ride"] = 190.3, ["Mega"] = 1016.21, ["Mega|Ride"] = 856.1, ["Mega|Fly|Ride"] = 748.12}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 9.18, ["Fly"] = 65.44, ["Ride"] = 22.32, ["Fly|Ride"] = 95.45, ["Neon"] = 32.68, ["Neon|Ride"] = 45, ["Neon|Fly|Ride"] = 128.4, ["Mega"] = 170.63, ["Mega|Fly"] = 254.52, ["Mega|Ride"] = 178.4, ["Mega|Fly|Ride"] = 307.51}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 11.71, ["Fly"] = 32.82, ["Ride"] = 27.57, ["Fly|Ride"] = 73.5, ["Neon"] = 86.23, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 160.13, ["Mega|Ride"] = 426.57, ["Mega|Fly|Ride"] = 584.07}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 19.59, ["Fly"] = 30.19, ["Ride"] = 26.84, ["Fly|Ride"] = 40.57, ["Neon"] = 154.77, ["Neon|Ride"] = 128.63, ["Neon|Fly|Ride"] = 161.44}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 190.3}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 28.27, ["Ride"] = 94.5, ["Fly|Ride"] = 275.5, ["Neon"] = 196.88, ["Neon|Ride"] = 825.43, ["Neon|Fly|Ride"] = 565.42, ["Mega"] = 1100.91, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 208.59, ["Ride"] = 443.63, ["Fly|Ride"] = 1556.36}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 36.53, ["Fly"] = 212.02, ["Ride"] = 100, ["Fly|Ride"] = 131.25, ["Neon"] = 347.71, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 485.63, ["Mega"] = 908.24, ["Mega|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 1263.05}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 918.73, ["Fly"] = 1335.12, ["Ride"] = 897.73, ["Fly|Ride"] = 1030.32, ["Neon|Fly"] = 4036.71, ["Neon|Ride"] = 3164.44, ["Neon|Fly|Ride"] = 3150, ["Mega|Fly|Ride"] = 13062.89}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 401.31, ["Fly"] = 688.2, ["Ride"] = 413.44, ["Fly|Ride"] = 523.13, ["Neon"] = 2888.96, ["Neon|Ride"] = 2063.56, ["Neon|Fly|Ride"] = 2201.81, ["Mega|Fly|Ride"] = 7940.63}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 71.54}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 4.14}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 8.39, ["Fly"] = 27.87, ["Ride"] = 18.76, ["Fly|Ride"] = 43.32, ["Neon"] = 65.63, ["Neon|Fly"] = 165.1, ["Neon|Ride"] = 82.56, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 437.26, ["Mega|Ride"] = 688.28, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 261.19, ["Fly"] = 289.44, ["Ride"] = 294, ["Fly|Ride"] = 350.44, ["Neon"] = 1097.82, ["Neon|Ride"] = 1022.72, ["Neon|Fly|Ride"] = 918.75, ["Mega|Fly|Ride"] = 3220.88}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 18.37}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 137.82, ["Ride"] = 183.23, ["Fly|Ride"] = 293.2, ["Neon"] = 585.36, ["Neon|Fly"] = 580.61, ["Neon|Ride"] = 510.57, ["Neon|Fly|Ride"] = 603.75, ["Mega"] = 9904.99, ["Mega|Ride"] = 2724.23, ["Mega|Fly|Ride"] = 3027.6}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 125.55, ["Fly"] = 105, ["Ride"] = 104.13, ["Fly|Ride"] = 202.25, ["Neon"] = 688.2, ["Neon|Ride"] = 1005.38, ["Neon|Fly|Ride"] = 913.5, ["Mega|Ride"] = 3441.38, ["Mega|Fly|Ride"] = 2476.57}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 5.25, ["Ride"] = 31.4, ["Fly|Ride"] = 168.19, ["Neon"] = 21.95, ["Neon|Ride"] = 86.56, ["Neon|Fly|Ride"] = 230.86, ["Mega"] = 264.75, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 824.51}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 12.16, ["Fly"] = 63.03, ["Ride"] = 26.84, ["Fly|Ride"] = 74, ["Neon"] = 177.19, ["Neon|Ride"] = 173.36, ["Neon|Fly|Ride"] = 311.32, ["Mega|Ride"] = 803.86, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 11.33, ["Fly"] = 102.34, ["Ride"] = 35.93, ["Fly|Ride"] = 82.56, ["Neon"] = 105, ["Neon|Ride"] = 96.99, ["Neon|Fly|Ride"] = 256.57, ["Mega"] = 498.75, ["Mega|Ride"] = 466.55, ["Mega|Fly|Ride"] = 729.57}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 3.86, ["Fly"] = 131.23, ["Ride"] = 48.5, ["Fly|Ride"] = 155.92, ["Neon"] = 20.23, ["Neon|Ride"] = 63.95, ["Neon|Fly|Ride"] = 172.49, ["Mega"] = 138.5, ["Mega|Fly"] = 262.08, ["Mega|Ride"] = 178.4, ["Mega|Fly|Ride"] = 285.47}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 255.83, ["Ride"] = 275.63, ["Fly|Ride"] = 354.38, ["Neon"] = 1624.01, ["Neon|Ride"] = 1323.02, ["Neon|Fly|Ride"] = 1299.38, ["Mega|Fly|Ride"] = 5228.63}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 112.73, ["Fly"] = 550.91, ["Ride"] = 159.5, ["Fly|Ride"] = 241.48, ["Neon"] = 1665.78, ["Neon|Ride"] = 3850.04, ["Neon|Fly|Ride"] = 1173.27, ["Mega|Ride"] = 3302.09, ["Mega|Fly|Ride"] = 2185.37}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 74.45, ["Ride"] = 69.34, ["Fly|Ride"] = 131.25, ["Neon"] = 393.75, ["Neon|Ride"] = 357, ["Neon|Fly|Ride"] = 416.07, ["Mega"] = 1789.1, ["Mega|Ride"] = 1857.42, ["Mega|Fly|Ride"] = 1801.11}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 9.98, ["Ride"] = 33.04, ["Fly|Ride"] = 275.5, ["Neon|Ride"] = 592.69, ["Neon|Fly|Ride"] = 481.85, ["Mega|Ride"] = 619.16, ["Mega|Fly|Ride"] = 1857.42}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 13.11, ["Fly"] = 75.63, ["Ride"] = 35.49, ["Fly|Ride"] = 75.51, ["Neon"] = 77.4, ["Neon|Fly"] = 275.5, ["Neon|Ride"] = 119.73, ["Neon|Fly|Ride"] = 197.09, ["Mega"] = 371.44, ["Mega|Fly"] = 525, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 535.57}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.22, ["Fly"] = 13.13, ["Ride"] = 18.37, ["Fly|Ride"] = 43.95, ["Neon"] = 20.64, ["Neon|Fly"] = 65.58, ["Neon|Ride"] = 35.17, ["Neon|Fly|Ride"] = 118.09, ["Mega"] = 136.9, ["Mega|Ride"] = 137.82, ["Mega|Fly|Ride"] = 253.61}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 853.02, ["Fly"] = 1082.72, ["Ride"] = 911.54, ["Fly|Ride"] = 951.45, ["Neon|Fly"] = 3423.03, ["Neon|Ride"] = 2886.9, ["Neon|Fly|Ride"] = 2624.88, ["Mega|Fly|Ride"] = 10141.49}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 344.58, ["Ride"] = 393.75, ["Fly|Ride"] = 472.02, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1609.57, ["Mega"] = 10317.68, ["Mega|Fly|Ride"] = 5778.64}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 94.36, ["Fly"] = 138.27, ["Ride"] = 103.64, ["Fly|Ride"] = 179.82, ["Neon"] = 283.07, ["Neon|Ride"] = 310.06, ["Neon|Fly|Ride"] = 344.63, ["Mega"] = 1399.09, ["Mega|Ride"] = 1651.05, ["Mega|Fly|Ride"] = 2474.51}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 263.82, ["Fly"] = 523.13, ["Ride"] = 219.09, ["Fly|Ride"] = 253.94, ["Neon|Fly|Ride"] = 1238.13, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 16.7, ["Fly"] = 52.5, ["Ride"] = 26.23, ["Fly|Ride"] = 65.63, ["Neon"] = 169.32, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 236.25, ["Mega|Fly|Ride"] = 777.95}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 236.15, ["Ride"] = 500.52, ["Fly|Ride"] = 472.4, ["Neon"] = 829.24, ["Neon|Ride"] = 825.43, ["Neon|Fly|Ride"] = 708.75, ["Mega"] = 4127.82, ["Mega|Ride"] = 4540.35, ["Mega|Fly|Ride"] = 3818.31}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 41.91, ["Fly"] = 125.98, ["Ride"] = 69.45, ["Fly|Ride"] = 98.43, ["Neon|Ride"] = 530.5, ["Neon|Fly|Ride"] = 550.98, ["Mega|Fly|Ride"] = 1732.5}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1870.32, ["Ride"] = 1837.5, ["Fly|Ride"] = 1706.25, ["Neon|Ride"] = 10882.51, ["Neon|Fly|Ride"] = 6741.59, ["Mega"] = 49524.86, ["Mega|Fly|Ride"] = 22246.65}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 13.2, ["Fly"] = 116.8, ["Ride"] = 34.01, ["Fly|Ride"] = 70.65, ["Neon"] = 51.35, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 223.12, ["Mega"] = 343.95, ["Mega|Ride"] = 411.74, ["Mega|Fly|Ride"] = 463.97}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 52.49, ["Ride"] = 96.99, ["Fly|Ride"] = 120.71, ["Neon"] = 189, ["Neon|Ride"] = 316.77, ["Neon|Fly|Ride"] = 418.85, ["Mega"] = 1632.27, ["Mega|Fly|Ride"] = 1374.5}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 90.45, ["Fly"] = 78.7, ["Ride"] = 77.3, ["Fly|Ride"] = 97.12, ["Neon"] = 525, ["Neon|Fly|Ride"] = 380.63, ["Mega|Fly|Ride"] = 1842.38}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 3094.93, ["Fly"] = 1556.36, ["Ride"] = 1073.63, ["Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 480.77, ["Fly|Ride"] = 656.25}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 83.3, ["Fly"] = 203.01, ["Ride"] = 136.2, ["Fly|Ride"] = 221.3, ["Neon"] = 408.19, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 538.13, ["Mega|Ride"] = 2614.84, ["Mega|Fly|Ride"] = 2038}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 6.36, ["Ride"] = 21.77, ["Fly|Ride"] = 103.19, ["Neon"] = 39.38, ["Neon|Fly"] = 138.27, ["Neon|Ride"] = 89.78, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 762.72}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 38.33, ["Fly"] = 61.92, ["Ride"] = 49.67, ["Fly|Ride"] = 104.66, ["Neon"] = 262.5, ["Neon|Fly"] = 323.99, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 371.45, ["Mega"] = 984.38, ["Mega|Fly|Ride"] = 1036.88}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 757.32, ["Ride"] = 840, ["Fly|Ride"] = 820.32, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2139.38, ["Mega|Fly|Ride"] = 9723}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 728.04}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 4921.88, ["Ride"] = 6163.79, ["Fly|Ride"] = 5578.13, ["Neon"] = 42000, ["Neon|Ride"] = 29571.51, ["Neon|Fly|Ride"] = 23264.07, ["Mega|Fly|Ride"] = 88055.8}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 313.59, ["Fly"] = 414.75, ["Ride"] = 393.75, ["Neon"] = 1650.85, ["Neon|Ride"] = 2063.56, ["Neon|Fly|Ride"] = 2166.72, ["Mega"] = 6189.6, ["Mega|Fly|Ride"] = 6531.45}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 85.32, ["Fly"] = 275.46, ["Ride"] = 118.13, ["Fly|Ride"] = 336, ["Neon"] = 623.02, ["Neon|Ride"] = 688.2, ["Neon|Fly|Ride"] = 1646.71, ["Mega|Fly|Ride"] = 2139.76}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 10.71, ["Fly"] = 41.28, ["Ride"] = 37.69, ["Fly|Ride"] = 85.32, ["Neon"] = 111.57, ["Neon|Fly"] = 1244.85, ["Neon|Ride"] = 82.56, ["Neon|Fly|Ride"] = 214.68, ["Mega|Ride"] = 825.53, ["Mega|Fly|Ride"] = 688.28}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 7.67, ["Fly"] = 26.23, ["Ride"] = 17.82, ["Fly|Ride"] = 39.21, ["Neon"] = 206.37, ["Neon|Ride"] = 311.52, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 2187.64}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 16.36, ["Ride"] = 34.13, ["Fly|Ride"] = 140.34, ["Neon"] = 102.38, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 670.69, ["Mega|Ride"] = 619.16, ["Mega|Fly|Ride"] = 654.94}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 4.09, ["Fly"] = 76.36, ["Ride"] = 22.23, ["Fly|Ride"] = 48.47, ["Neon"] = 35.33, ["Neon|Ride"] = 54.86, ["Neon|Fly|Ride"] = 130.03, ["Mega"] = 275.5, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 357}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 23.26, ["Fly"] = 90.57, ["Ride"] = 34.13, ["Fly|Ride"] = 139.13, ["Neon"] = 223.13, ["Neon|Fly"] = 825.43, ["Neon|Ride"] = 249.37, ["Neon|Fly|Ride"] = 395.19, ["Mega"] = 630, ["Mega|Ride"] = 1239, ["Mega|Fly|Ride"] = 614.25}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 369.24, ["Fly"] = 462.19, ["Ride"] = 393.75, ["Fly|Ride"] = 420, ["Neon"] = 1547.66, ["Neon|Ride"] = 1444.49, ["Neon|Fly|Ride"] = 1200.98, ["Mega"] = 7875, ["Mega|Fly|Ride"] = 11663.29}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.31, ["Fly"] = 18.8, ["Ride"] = 14.43, ["Fly|Ride"] = 32.36, ["Neon"] = 20.69, ["Neon|Ride"] = 34.28, ["Neon|Fly|Ride"] = 50.94, ["Mega"] = 825.43, ["Mega|Ride"] = 311.42, ["Mega|Fly|Ride"] = 220.84}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 44.63, ["Fly"] = 97.05, ["Ride"] = 58.97, ["Fly|Ride"] = 139.13, ["Neon"] = 157.5, ["Neon|Fly"] = 389.68, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 249.27, ["Mega"] = 575.05, ["Mega|Ride"] = 581.44, ["Mega|Fly|Ride"] = 610.28}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 771.75, ["Ride"] = 708.65, ["Fly|Ride"] = 826.2, ["Neon|Ride"] = 1603.88, ["Neon|Fly|Ride"] = 1573.69, ["Mega|Fly|Ride"] = 3934.86}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 36.66, ["Fly"] = 165.37, ["Ride"] = 42, ["Fly|Ride"] = 82.56, ["Neon"] = 282.59, ["Neon|Ride"] = 225.72, ["Neon|Fly|Ride"] = 210.06, ["Mega"] = 1575, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 330.14, ["Fly"] = 380.7, ["Ride"] = 290.76, ["Fly|Ride"] = 345.19, ["Neon|Ride"] = 1556.36, ["Neon|Fly|Ride"] = 1120.71}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 170.63, ["Fly"] = 400.3, ["Ride"] = 196.27, ["Fly|Ride"] = 210, ["Neon"] = 633.63, ["Neon|Ride"] = 708.75, ["Neon|Fly|Ride"] = 816.15, ["Mega|Fly|Ride"] = 3473.01}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 810.88, ["Ride"] = 754.68, ["Fly|Ride"] = 786.19, ["Neon|Ride"] = 3440.96, ["Neon|Fly|Ride"] = 2999.37, ["Mega|Fly|Ride"] = 7611.19}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 21.48, ["Fly"] = 82.56, ["Ride"] = 43.35, ["Fly|Ride"] = 111.56, ["Neon"] = 70.17, ["Neon|Fly"] = 280.02, ["Neon|Ride"] = 77.84, ["Neon|Fly|Ride"] = 270.51, ["Mega"] = 354.38, ["Mega|Ride"] = 302.9, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 3920.24, ["Fly"] = 3543.75, ["Ride"] = 3936.19, ["Fly|Ride"] = 3149.51, ["Neon"] = 13757.6, ["Neon|Fly|Ride"] = 7021.88, ["Mega|Fly|Ride"] = 25058.15}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 125.57, ["Fly"] = 166.28, ["Ride"] = 144.38, ["Fly|Ride"] = 196.86, ["Neon"] = 550.97, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 593.25, ["Mega|Fly|Ride"] = 2310.42}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.22, ["Fly"] = 24.15, ["Ride"] = 19.42, ["Fly|Ride"] = 36.75, ["Neon"] = 18.16, ["Neon|Fly"] = 65.62, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 78.66, ["Mega"] = 131.25, ["Mega|Fly"] = 446.25, ["Mega|Ride"] = 357.66, ["Mega|Fly|Ride"] = 244.13}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.87, ["Ride"] = 24.55, ["Fly|Ride"] = 57.7, ["Neon"] = 20.46, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 266.44, ["Mega"] = 161.44, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 356.1}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 25.72, ["Ride"] = 39.16, ["Fly|Ride"] = 56.34, ["Neon|Fly|Ride"] = 343.95, ["Mega|Fly|Ride"] = 1096.36}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 1237.99, ["Ride"] = 1238.13, ["Fly|Ride"] = 1298.07}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 6693.75, ["Fly|Ride"] = 6431.25}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 20.13, ["Fly"] = 35.44, ["Ride"] = 23.44, ["Fly|Ride"] = 45.05, ["Neon"] = 452.13, ["Neon|Ride"] = 139.93, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 2476.25, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 15.86, ["Fly"] = 41.28, ["Ride"] = 24.86, ["Fly|Ride"] = 74.42, ["Neon"] = 114.54, ["Neon|Ride"] = 109.61, ["Neon|Fly|Ride"] = 137.82, ["Mega"] = 655.54, ["Mega|Ride"] = 777.95, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 72.19, ["Fly"] = 157.5, ["Ride"] = 72.19, ["Fly|Ride"] = 113.19, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 441.68, ["Mega|Fly|Ride"] = 1614.62}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 258.56, ["Ride"] = 261.19, ["Fly|Ride"] = 316.32, ["Neon|Ride"] = 977.79, ["Neon|Fly|Ride"] = 984.38, ["Mega|Fly|Ride"] = 4510.21}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.65, ["Ride"] = 32.78, ["Fly|Ride"] = 87.87, ["Neon"] = 20.99, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 93.83, ["Mega"] = 143.66, ["Mega|Ride"] = 191.02, ["Mega|Fly|Ride"] = 1374.5}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 183.65, ["Ride"] = 195.57, ["Fly|Ride"] = 284.59, ["Neon"] = 755.6, ["Neon|Ride"] = 894.56, ["Neon|Fly|Ride"] = 843.94, ["Mega|Fly|Ride"] = 3615.63}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 3.42, ["Fly"] = 41.28, ["Ride"] = 14.4, ["Fly|Ride"] = 63.98, ["Neon"] = 20.69, ["Neon|Fly"] = 123.83, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 223.13, ["Mega|Ride"] = 223.12, ["Mega|Fly|Ride"] = 328.16}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 220.89, ["Fly"] = 275.5, ["Ride"] = 223.13, ["Fly|Ride"] = 223.13, ["Neon|Fly|Ride"] = 712.31, ["Mega"] = 10317.68, ["Mega|Ride"] = 4678.63, ["Mega|Fly|Ride"] = 4127.6}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 10.5, ["Fly"] = 85.32, ["Ride"] = 27.09, ["Fly|Ride"] = 68.25, ["Neon"] = 97.54, ["Neon|Fly"] = 296.36, ["Neon|Ride"] = 152.73, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 480.82, ["Mega|Ride"] = 619.16, ["Mega|Fly|Ride"] = 449.5}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 3.4, ["Ride"] = 23.34, ["Fly|Ride"] = 65.54, ["Neon"] = 11.36, ["Neon|Fly"] = 170.45, ["Neon|Ride"] = 36.66, ["Neon|Fly|Ride"] = 177.08, ["Mega"] = 78.74, ["Mega|Ride"] = 115, ["Mega|Fly|Ride"] = 195.57}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.57, ["Neon"] = 3.56, ["Mega"] = 19.59, ["Mega|Ride"] = 148.6}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 3.71, ["Fly"] = 52.49, ["Ride"] = 20.65, ["Fly|Ride"] = 108.18, ["Neon"] = 7.55, ["Neon|Ride"] = 38.82, ["Neon|Fly|Ride"] = 131.23, ["Mega"] = 76.13, ["Mega|Fly"] = 155453.86, ["Mega|Ride"] = 100.26, ["Mega|Fly|Ride"] = 198.83}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 70.49, ["Fly"] = 135.4, ["Ride"] = 78.75, ["Fly|Ride"] = 164.07, ["Neon"] = 236.8, ["Neon|Ride"] = 292.69, ["Neon|Fly|Ride"] = 353.29, ["Mega|Fly|Ride"] = 1172.76}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 34.3, ["Ride"] = 15.73, ["Fly|Ride"] = 109.38, ["Neon"] = 8.24, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 129.94, ["Mega|Ride"] = 165.38, ["Mega|Fly|Ride"] = 262.47}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 15.72, ["Ride"] = 162.87, ["Fly|Ride"] = 41.28, ["Neon"] = 157.52, ["Neon|Ride"] = 78.75, ["Mega"] = 459.38, ["Mega|Fly|Ride"] = 513.58}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 51.93, ["Neon|Fly|Ride"] = 275.5, ["Mega"] = 13.01, ["Mega|Ride"] = 54.51, ["Mega|Fly|Ride"] = 322.13}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 60.51, ["Ride"] = 15.56, ["Fly|Ride"] = 35.1, ["Neon"] = 2.1, ["Neon|Fly"] = 18.38, ["Neon|Ride"] = 14.81, ["Neon|Fly|Ride"] = 37.86, ["Mega"] = 12.66, ["Mega|Fly"] = 31.38, ["Mega|Ride"] = 19.06, ["Mega|Fly|Ride"] = 64.32}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 18.15, ["Ride"] = 12.71, ["Fly|Ride"] = 77.4, ["Neon"] = 3.89, ["Neon|Fly"] = 39.26, ["Neon|Ride"] = 15.49, ["Neon|Fly|Ride"] = 39.24, ["Mega"] = 25.73, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 95.82}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Mega"] = 23.36, ["Mega|Ride"] = 91.47, ["Mega|Fly|Ride"] = 443.22}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 91.84, ["Ride"] = 14.44, ["Fly|Ride"] = 26.25, ["Neon"] = 6.3, ["Neon|Fly"] = 167.96, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 19.69, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 26.25, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 3.84, ["Neon|Fly|Ride"] = 411.7, ["Mega"] = 16.95, ["Mega|Ride"] = 69.57, ["Mega|Fly|Ride"] = 195.57}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 2.18, ["Fly"] = 69.14, ["Ride"] = 19.59, ["Fly|Ride"] = 55.74, ["Neon"] = 11.69, ["Neon|Fly"] = 69.27, ["Neon|Ride"] = 25.2, ["Neon|Fly|Ride"] = 116.88, ["Mega"] = 91.88, ["Mega|Fly"] = 349.13, ["Mega|Ride"] = 110.65, ["Mega|Fly|Ride"] = 189.51}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 50.94, ["Neon"] = 2.1, ["Neon|Ride"] = 17.52, ["Neon|Fly|Ride"] = 258.56, ["Mega"] = 13.1, ["Mega|Fly"] = 144.38, ["Mega|Ride"] = 51.31, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.63, ["Fly|Ride"] = 524.99, ["Neon"] = 16.21, ["Mega"] = 188.4, ["Mega|Fly"] = 315, ["Mega|Ride"] = 712.47}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Ride"] = 27.57, ["Neon"] = 16.59, ["Neon|Ride"] = 70.49, ["Mega"] = 103.94, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 551.06}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 24.94, ["Neon"] = 3.51, ["Neon|Ride"] = 26.84, ["Neon|Fly|Ride"] = 138.27, ["Mega"] = 19.63, ["Mega|Ride"] = 40.82, ["Mega|Fly|Ride"] = 131.06}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 11.27, ["Fly|Ride"] = 32.71, ["Neon"] = 2.1, ["Neon|Fly"] = 16.56, ["Neon|Ride"] = 15.49, ["Neon|Fly|Ride"] = 32.24, ["Mega"] = 13.8, ["Mega|Fly"] = 39.8, ["Mega|Ride"] = 19.99, ["Mega|Fly|Ride"] = 49.26}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.1, ["Fly"] = 72.19, ["Ride"] = 229.68, ["Fly|Ride"] = 118.11, ["Neon"] = 34.92, ["Neon|Ride"] = 140.94, ["Mega"] = 179.82, ["Mega|Ride"] = 240.19}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 23.4, ["Neon"] = 3.94, ["Neon|Ride"] = 20.47, ["Neon|Fly|Ride"] = 105, ["Mega"] = 26.23, ["Mega|Ride"] = 138.29, ["Mega|Fly|Ride"] = 136.8}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 2.78, ["Neon"] = 11.44, ["Neon|Fly|Ride"] = 138.27, ["Mega"] = 94.5, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 238.87}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.1, ["Fly"] = 91.88, ["Ride"] = 34.53, ["Fly|Ride"] = 59.07, ["Neon"] = 65.51, ["Neon|Ride"] = 55.74, ["Neon|Fly|Ride"] = 105, ["Mega"] = 124.59, ["Mega|Ride"] = 143.06, ["Mega|Fly|Ride"] = 193.41}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 11.46, ["Ride"] = 11.24, ["Fly|Ride"] = 13.13, ["Neon"] = 2.1, ["Neon|Fly"] = 13.53, ["Neon|Ride"] = 13.01, ["Neon|Fly|Ride"] = 30.97, ["Mega"] = 13.96, ["Mega|Fly"] = 25.86, ["Mega|Ride"] = 24.04, ["Mega|Fly|Ride"] = 51.08}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 27.88, ["Ride"] = 27.39, ["Fly|Ride"] = 131.25, ["Neon"] = 17.52, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 105, ["Mega|Ride"] = 157.95, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 6.57, ["Fly"] = 112.03, ["Ride"] = 18.38, ["Fly|Ride"] = 58.46, ["Neon"] = 54.51, ["Neon|Ride"] = 67.37, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 236.24, ["Mega|Ride"] = 288.46, ["Mega|Fly|Ride"] = 411.99}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 32.24, ["Ride"] = 12.35, ["Fly|Ride"] = 36.71, ["Neon"] = 2.1, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 14.64, ["Neon|Fly|Ride"] = 34.84, ["Mega"] = 20.99, ["Mega|Ride"] = 31.5, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.1, ["Fly"] = 172.32, ["Ride"] = 28.73, ["Neon"] = 7.82, ["Neon|Ride"] = 27.88, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 65.63, ["Mega|Fly"] = 165.1, ["Mega|Ride"] = 118.02, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 35.43, ["Neon"] = 6.03, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 138.27, ["Mega"] = 35.09, ["Mega|Fly"] = 140.31, ["Mega|Ride"] = 117.66, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 32.66, ["Ride"] = 17.99, ["Neon"] = 2.1, ["Neon|Fly"] = 41.28, ["Neon|Ride"] = 34.12, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 18.75, ["Mega|Ride"] = 40.68, ["Mega|Fly|Ride"] = 166.01}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 69.14, ["Ride"] = 14.95, ["Fly|Ride"] = 42, ["Neon"] = 11.51, ["Neon|Fly"] = 53.09, ["Neon|Ride"] = 19.07, ["Neon|Fly|Ride"] = 57.66, ["Mega"] = 65.54, ["Mega|Ride"] = 52.5}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 53.26, ["Neon"] = 3.99, ["Neon|Ride"] = 62.06, ["Mega"] = 35.02, ["Mega|Ride"] = 104.81, ["Mega|Fly|Ride"] = 307.53}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 19.95, ["Ride"] = 12.7, ["Fly|Ride"] = 72.19, ["Neon"] = 3.93, ["Neon|Fly"] = 79.97, ["Neon|Ride"] = 16.99, ["Neon|Fly|Ride"] = 83.99, ["Mega"] = 103.69, ["Mega|Ride"] = 90.56, ["Mega|Fly|Ride"] = 309.59}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 3.83, ["Fly"] = 42, ["Ride"] = 36.26, ["Neon"] = 30.49, ["Neon|Fly"] = 188.89, ["Neon|Ride"] = 74.3, ["Neon|Fly|Ride"] = 327.3, ["Mega"] = 98.18, ["Mega|Ride"] = 168.38}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 15.75, ["Fly|Ride"] = 57.48, ["Neon"] = 33.7, ["Neon|Fly"] = 48.2, ["Neon|Ride"] = 28.41, ["Neon|Fly|Ride"] = 138.27, ["Mega"] = 315, ["Mega|Fly"] = 420, ["Mega|Fly|Ride"] = 222.78}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.1, ["Fly"] = 19.83, ["Ride"] = 19.69, ["Fly|Ride"] = 45.93, ["Neon"] = 15.75, ["Neon|Fly"] = 43.35, ["Neon|Ride"] = 46.68, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 171.96, ["Mega|Fly"] = 192.95, ["Mega|Ride"] = 412.77, ["Mega|Fly|Ride"] = 311.42}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 110.93, ["Fly|Ride"] = 72.19, ["Neon"] = 71.31, ["Neon|Ride"] = 101.51, ["Mega"] = 217.95, ["Mega|Ride"] = 236.24}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 14.8, ["Ride"] = 56.44, ["Neon"] = 209.09, ["Neon|Ride"] = 233.19, ["Mega|Ride"] = 688.28, ["Mega|Fly|Ride"] = 794.07}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 2.2, ["Ride"] = 39.38, ["Neon"] = 41.5, ["Neon|Ride"] = 123.83, ["Mega"] = 265.84, ["Mega|Ride"] = 309.59}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 5.41, ["Ride"] = 15.75, ["Fly|Ride"] = 120.75, ["Neon"] = 33.11, ["Neon|Ride"] = 82.56, ["Neon|Fly|Ride"] = 179.54, ["Mega"] = 472.5, ["Mega|Ride"] = 274.5, ["Mega|Fly|Ride"] = 296.26}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.9, ["Neon|Ride"] = 64.98, ["Mega"] = 23.13, ["Mega|Fly"] = 123.83, ["Mega|Ride"] = 123.84, ["Mega|Fly|Ride"] = 123.6}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 39.38}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 3.81, ["Fly"] = 19.91, ["Ride"] = 17.01, ["Fly|Ride"] = 35.2, ["Neon"] = 43.32, ["Neon|Fly"] = 188.48, ["Neon|Ride"] = 41.27, ["Neon|Fly|Ride"] = 78.62, ["Mega"] = 374.32, ["Mega|Ride"] = 208.68, ["Mega|Fly|Ride"] = 290.59}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 92.87, ["Ride"] = 13.02, ["Neon"] = 2.86, ["Neon|Fly"] = 31.52, ["Neon|Ride"] = 25.09, ["Neon|Fly|Ride"] = 153.91, ["Mega"] = 24.92, ["Mega|Fly"] = 138.27, ["Mega|Ride"] = 70.88, ["Mega|Fly|Ride"] = 90.96}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 47.48, ["Neon"] = 6.25, ["Neon|Ride"] = 33, ["Mega"] = 36.12, ["Mega|Ride"] = 71.31, ["Mega|Fly|Ride"] = 133.88}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.63, ["Fly"] = 48.5, ["Ride"] = 16.53, ["Fly|Ride"] = 55.65, ["Neon"] = 15.49, ["Neon|Ride"] = 55.74, ["Neon|Fly|Ride"] = 116.24, ["Mega"] = 124.61, ["Mega|Ride"] = 158.87, ["Mega|Fly|Ride"] = 166.63}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 14.43, ["Ride"] = 36.66, ["Fly|Ride"] = 57.75, ["Neon"] = 28.88, ["Neon|Ride"] = 49.26, ["Mega"] = 349.71, ["Mega|Ride"] = 275.44}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Fly"] = 82.55, ["Ride"] = 26.25, ["Neon"] = 2.61, ["Mega"] = 20.67, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 60.38, ["Mega|Fly|Ride"] = 330.23}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 21.67, ["Ride"] = 15.23, ["Fly|Ride"] = 275138.41, ["Neon"] = 2.93, ["Neon|Fly"] = 110.9, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 28.49, ["Mega|Fly"] = 143.15, ["Mega|Ride"] = 45.94, ["Mega|Fly|Ride"] = 131.35}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 28.11, ["Ride"] = 13.16, ["Fly|Ride"] = 32.82, ["Neon"] = 3.93, ["Neon|Fly"] = 69.14, ["Neon|Ride"] = 18.15, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 47.95, ["Mega|Fly"] = 138.27, ["Mega|Ride"] = 50.26, ["Mega|Fly|Ride"] = 72.19}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 27.88, ["Ride"] = 51.83, ["Fly|Ride"] = 118.13, ["Neon"] = 3.26, ["Neon|Ride"] = 27.58, ["Neon|Fly|Ride"] = 111.78, ["Mega"] = 29.76, ["Mega|Ride"] = 79.48, ["Mega|Fly|Ride"] = 215.25}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 5.15, ["Neon|Ride"] = 165.1, ["Neon|Fly|Ride"] = 150166.51, ["Mega"] = 18.78, ["Mega|Fly"] = 106.45, ["Mega|Ride"] = 110.29, ["Mega|Fly|Ride"] = 410.7}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 45.87, ["Ride"] = 20.9, ["Fly|Ride"] = 50.18, ["Neon"] = 3.41, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 19.18, ["Mega|Fly"] = 61.92, ["Mega|Ride"] = 40.69, ["Mega|Fly|Ride"] = 111.37}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Neon"] = 3.81, ["Neon|Ride"] = 36.66, ["Mega"] = 1312.08, ["Mega|Ride"] = 167.25, ["Mega|Fly|Ride"] = 161.24}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.19, ["Neon|Ride"] = 311.32, ["Neon|Fly|Ride"] = 420, ["Mega"] = 23.75, ["Mega|Ride"] = 158.89, ["Mega|Fly|Ride"] = 187.99}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 18.79, ["Fly|Ride"] = 49.86, ["Neon"] = 3.94, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 17.01, ["Neon|Fly|Ride"] = 45.93, ["Mega"] = 124.69, ["Mega|Fly"] = 82.56, ["Mega|Ride"] = 48.07, ["Mega|Fly|Ride"] = 93.55}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 11.58, ["Ride"] = 78.74, ["Neon"] = 144.38, ["Mega"] = 618.05, ["Mega|Ride"] = 666.75, ["Mega|Fly|Ride"] = 688.28}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 3.92, ["Fly"] = 6562.5, ["Ride"] = 56.24, ["Neon"] = 41.91, ["Mega"] = 105}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 2.1, ["Ride"] = 30.34, ["Fly|Ride"] = 177.48, ["Neon"] = 27.2, ["Neon|Fly|Ride"] = 262.08, ["Mega"] = 397.95, ["Mega|Ride"] = 352.93, ["Mega|Fly|Ride"] = 375.26}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 12.96, ["Ride"] = 11.69, ["Fly|Ride"] = 13.13, ["Neon"] = 2.1, ["Neon|Fly"] = 13.23, ["Neon|Ride"] = 12.72, ["Neon|Fly|Ride"] = 20.94, ["Mega"] = 12.98, ["Mega|Fly"] = 22.8, ["Mega|Ride"] = 19.36, ["Mega|Fly|Ride"] = 47.57}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Fly"] = 118.12, ["Ride"] = 65.63, ["Fly|Ride"] = 52.5, ["Neon"] = 5.04, ["Neon|Fly"] = 66.05, ["Neon|Ride"] = 32, ["Neon|Fly|Ride"] = 688.2, ["Mega"] = 59.07, ["Mega|Ride"] = 118.02}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Ride"] = 31.01, ["Neon"] = 2.1, ["Neon|Fly"] = 31.28, ["Neon|Ride"] = 22.37, ["Neon|Fly|Ride"] = 84.16, ["Mega"] = 14.33, ["Mega|Ride"] = 69.55, ["Mega|Fly|Ride"] = 131.83}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 60.89, ["Neon|Ride"] = 127.32, ["Mega"] = 18.25, ["Mega|Fly|Ride"] = 167.54}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 41.79, ["Ride"] = 16.67, ["Fly|Ride"] = 53.68, ["Neon"] = 9.75, ["Neon|Ride"] = 30.98, ["Neon|Fly|Ride"] = 90.97, ["Mega"] = 208.95, ["Mega|Ride"] = 395.75, ["Mega|Fly|Ride"] = 259.86}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 131.25, ["Fly"] = 183.75, ["Ride"] = 212.63, ["Fly|Ride"] = 257.25, ["Neon"] = 925.5, ["Mega"] = 8254.15, ["Mega|Fly|Ride"] = 3577.61}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Ride"] = 17.52, ["Neon"] = 10.17, ["Neon|Ride"] = 64.31, ["Mega"] = 91.87, ["Mega|Ride"] = 165.13, ["Mega|Fly|Ride"] = 624.88}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 2.1, ["Fly"] = 64.97, ["Ride"] = 25.68, ["Fly|Ride"] = 57.29, ["Neon"] = 24.93, ["Neon|Ride"] = 93.29, ["Neon|Fly|Ride"] = 165.1, ["Mega"] = 360.94, ["Mega|Ride"] = 564.37, ["Mega|Fly|Ride"] = 414.63}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 15.11, ["Ride"] = 12.23, ["Fly|Ride"] = 32.24, ["Neon"] = 7.01, ["Neon|Fly"] = 27.88, ["Neon|Ride"] = 29.34, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 49.67, ["Mega|Ride"] = 80.56, ["Mega|Fly|Ride"] = 433.12}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 55.73, ["Ride"] = 19.68, ["Fly|Ride"] = 92.56, ["Neon"] = 6.24, ["Neon|Ride"] = 80.07, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 69.57, ["Mega|Ride"] = 179.57}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 6.34, ["Fly"] = 23.29, ["Ride"] = 15.01, ["Fly|Ride"] = 35.63, ["Neon"] = 46.68, ["Neon|Fly"] = 98.85, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 74.83, ["Mega|Ride"] = 271.41, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 4.64, ["Ride"] = 21, ["Fly|Ride"] = 252.06, ["Neon"] = 78.44, ["Neon|Ride"] = 138.27, ["Neon|Fly|Ride"] = 612.89, ["Mega"] = 349.79, ["Mega|Ride"] = 352.88, ["Mega|Fly|Ride"] = 387.18}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.15, ["Fly"] = 22.32, ["Ride"] = 13.13, ["Fly|Ride"] = 34.13, ["Neon"] = 20.26, ["Neon|Fly"] = 76.04, ["Neon|Ride"] = 28.29, ["Neon|Fly|Ride"] = 52.41, ["Mega"] = 138.97, ["Mega|Ride"] = 206.39, ["Mega|Fly|Ride"] = 291.6}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 55.43, ["Fly"] = 110.4, ["Ride"] = 85.09, ["Fly|Ride"] = 145.59, ["Neon"] = 328.13, ["Neon|Fly"] = 437.07, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 406.88, ["Mega|Fly|Ride"] = 1450.97}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 210, ["Fly"] = 330.18, ["Ride"] = 210, ["Fly|Ride"] = 248.35, ["Neon|Ride"] = 2579.43, ["Neon|Fly|Ride"] = 978.13, ["Mega"] = 10317.68, ["Mega|Fly|Ride"] = 4678.63}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 54.5, ["Fly"] = 138.27, ["Ride"] = 70.33, ["Fly|Ride"] = 99.2, ["Neon"] = 701.38, ["Neon|Ride"] = 290.34, ["Neon|Fly|Ride"] = 410.66, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 4.34, ["Fly"] = 287.88, ["Ride"] = 23.63, ["Fly|Ride"] = 138.13, ["Neon"] = 26.71, ["Neon|Ride"] = 68.23, ["Neon|Fly|Ride"] = 138.27, ["Mega"] = 309.72, ["Mega|Ride"] = 392.44, ["Mega|Fly|Ride"] = 414.1}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 9.84, ["Fly"] = 69.14, ["Ride"] = 33.04, ["Fly|Ride"] = 54.94, ["Neon"] = 81.1, ["Neon|Ride"] = 126.26, ["Neon|Fly|Ride"] = 264.67, ["Mega"] = 312.36, ["Mega|Ride"] = 383.34, ["Mega|Fly|Ride"] = 1155.74}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 19.58, ["Ride"] = 16.66, ["Fly|Ride"] = 31.5, ["Neon"] = 3.02, ["Neon|Ride"] = 19.92, ["Neon|Fly|Ride"] = 58.83, ["Mega"] = 49.79, ["Mega|Fly"] = 154.88, ["Mega|Ride"] = 91.77, ["Mega|Fly|Ride"] = 84.46}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 5.71, ["Fly"] = 72.12, ["Ride"] = 18.19, ["Fly|Ride"] = 81.38, ["Neon"] = 111.77, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 150.66, ["Mega"] = 413.44, ["Mega|Ride"] = 821.4, ["Mega|Fly|Ride"] = 732.38}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 41.9, ["Ride"] = 15.09, ["Fly|Ride"] = 31.5, ["Neon"] = 11.7, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 28.66, ["Neon|Fly|Ride"] = 92.59, ["Mega"] = 179.54, ["Mega|Ride"] = 213.32, ["Mega|Fly|Ride"] = 171.52}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 2.1, ["Ride"] = 21.18, ["Fly|Ride"] = 328.13, ["Neon"] = 19.69, ["Neon|Ride"] = 65.54, ["Mega"] = 207.38, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 371.49}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 19.19, ["Neon"] = 2.1, ["Neon|Ride"] = 19.65, ["Neon|Fly|Ride"] = 57.73, ["Mega"] = 15.74, ["Mega|Ride"] = 41.29, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 3.94, ["Fly"] = 18.71, ["Ride"] = 18.26, ["Fly|Ride"] = 35.62, ["Neon"] = 15.64, ["Neon|Fly"] = 103.19, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 147, ["Mega"] = 52.5, ["Mega|Fly|Ride"] = 157.74}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.62, ["Fly"] = 24.94, ["Ride"] = 19.68, ["Fly|Ride"] = 61.01, ["Neon"] = 42.58, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 550.98, ["Mega"] = 262.08, ["Mega|Ride"] = 196.07, ["Mega|Fly|Ride"] = 278.25}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 198.9, ["Fly"] = 157.5, ["Ride"] = 172.99, ["Fly|Ride"] = 274.46, ["Neon"] = 622.08, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 742.43, ["Mega"] = 4127.09, ["Mega|Ride"] = 2614.84, ["Mega|Fly|Ride"] = 1968.65}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 7.79, ["Ride"] = 32.83, ["Fly|Ride"] = 124.85, ["Neon"] = 117.64, ["Neon|Ride"] = 98.42, ["Neon|Fly|Ride"] = 376.56, ["Mega"] = 417.38, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 358.09}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 41.46, ["Ride"] = 15.4, ["Fly|Ride"] = 45.52, ["Neon"] = 12.45, ["Neon|Ride"] = 26.82, ["Neon|Fly|Ride"] = 120.74, ["Mega"] = 233.19, ["Mega|Fly|Ride"] = 308.44}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 20.65, ["Ride"] = 41.32, ["Fly|Ride"] = 170.63, ["Neon"] = 176.3, ["Neon|Ride"] = 296.22, ["Neon|Fly|Ride"] = 534.2, ["Mega"] = 551.25, ["Mega|Fly"] = 825.43, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 611.85}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 3.89}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 2.1, ["Ride"] = 28.5, ["Fly|Ride"] = 126.83, ["Neon"] = 40.3, ["Neon|Ride"] = 123.46, ["Neon|Fly|Ride"] = 344.63, ["Mega"] = 575.79, ["Mega|Ride"] = 385.94, ["Mega|Fly|Ride"] = 915.09}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 23.48, ["Fly"] = 31.96, ["Ride"] = 29.86, ["Fly|Ride"] = 49.26, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 162.63, ["Neon|Fly|Ride"] = 168.87, ["Mega"] = 2063.56, ["Mega|Fly|Ride"] = 1101.05}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 18.67, ["Neon"] = 3.29, ["Neon|Fly"] = 65.62, ["Neon|Ride"] = 28.23, ["Neon|Fly|Ride"] = 106.18, ["Mega"] = 31.49, ["Mega|Fly"] = 275.5, ["Mega|Ride"] = 64.52, ["Mega|Fly|Ride"] = 227.99}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 2.1, ["Fly"] = 27.87, ["Ride"] = 19.69, ["Fly|Ride"] = 61.92, ["Neon"] = 10.31, ["Neon|Ride"] = 233.35, ["Mega"] = 267.81, ["Mega|Fly"] = 389.43, ["Mega|Ride"] = 204.33, ["Mega|Fly|Ride"] = 371.49}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 18.5, ["Fly|Ride"] = 45.55, ["Neon"] = 8.6, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 35, ["Neon|Fly|Ride"] = 64.37, ["Mega"] = 138.89, ["Mega|Ride"] = 78.66, ["Mega|Fly|Ride"] = 270.38}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 32.42, ["Fly|Ride"] = 206.37, ["Neon"] = 3.71, ["Neon|Ride"] = 23.38, ["Neon|Fly|Ride"] = 206.37, ["Mega"] = 24.05, ["Mega|Ride"] = 111.2, ["Mega|Fly|Ride"] = 311.42}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 31.73, ["Ride"] = 65.83, ["Fly|Ride"] = 140.02, ["Neon"] = 280.53, ["Neon|Ride"] = 244, ["Neon|Fly|Ride"] = 138.27, ["Mega"] = 853.57, ["Mega|Ride"] = 933.08, ["Mega|Fly|Ride"] = 956.26}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Fly|Ride"] = 210, ["Neon"] = 92.26, ["Neon|Ride"] = 138.27, ["Mega|Ride"] = 524.99}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 3.94, ["Fly"] = 207.9, ["Ride"] = 18.8, ["Fly|Ride"] = 68.11, ["Neon"] = 17.91, ["Neon|Fly"] = 315, ["Neon|Ride"] = 38.74, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 330.18, ["Mega|Ride"] = 267.47, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 72.18, ["Fly"] = 433.12, ["Ride"] = 165.1, ["Fly|Ride"] = 262.46, ["Neon"] = 328.13, ["Neon|Ride"] = 536.53, ["Mega|Ride"] = 2165.63, ["Mega|Fly|Ride"] = 1789.32}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 6.18, ["Fly"] = 26.25, ["Ride"] = 19.69, ["Fly|Ride"] = 55.99, ["Neon"] = 45.03, ["Neon|Ride"] = 52.92, ["Neon|Fly|Ride"] = 210.5, ["Mega"] = 215.25, ["Mega|Ride"] = 358.09, ["Mega|Fly|Ride"] = 638.72}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 67.48, ["Fly"] = 152.73, ["Ride"] = 83.91, ["Fly|Ride"] = 183.67, ["Neon"] = 270.38, ["Neon|Ride"] = 223.12, ["Neon|Fly|Ride"] = 412.72, ["Mega"] = 1114.33, ["Mega|Ride"] = 901.78, ["Mega|Fly|Ride"] = 1057.27}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 19.73, ["Ride"] = 58.83, ["Fly|Ride"] = 140.26, ["Neon"] = 79.36, ["Neon|Ride"] = 127.96, ["Neon|Fly|Ride"] = 226.62, ["Mega"] = 590.63, ["Mega|Ride"] = 313.94, ["Mega|Fly|Ride"] = 474.14}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 2.94, ["Fly"] = 92.12, ["Ride"] = 27.88, ["Fly|Ride"] = 61.92, ["Neon"] = 75.94, ["Neon|Ride"] = 90.2, ["Neon|Fly|Ride"] = 370.77, ["Mega"] = 416.96, ["Mega|Ride"] = 1547.85, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 13.95, ["Ride"] = 47.16, ["Fly|Ride"] = 162.54, ["Neon"] = 66.03, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 354.38, ["Mega"] = 283.82, ["Mega|Ride"] = 297.62, ["Mega|Fly|Ride"] = 392.44}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 5.92, ["Ride"] = 19.69, ["Fly|Ride"] = 65.2, ["Neon"] = 31.05, ["Neon|Ride"] = 54.33, ["Neon|Fly|Ride"] = 138.27, ["Mega"] = 236.25, ["Mega|Ride"] = 265.21, ["Mega|Fly|Ride"] = 483}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 57.1, ["Mega"] = 26.24, ["Mega|Ride"] = 123.84, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 6.55, ["Ride"] = 28.41, ["Neon"] = 22.57, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 202.78, ["Mega"] = 183.91, ["Mega|Ride"] = 260.06, ["Mega|Fly|Ride"] = 410.7}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.51, ["Fly"] = 122.8, ["Neon"] = 25.73, ["Neon|Fly"] = 116.94, ["Mega"] = 335.98, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 4.41, ["Ride"] = 32.79, ["Fly|Ride"] = 116.68, ["Neon"] = 32.82, ["Neon|Ride"] = 85.32, ["Mega"] = 123.38, ["Mega|Ride"] = 275.54, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 573.57, ["Ride"] = 551.15, ["Fly|Ride"] = 610.32, ["Neon"] = 1780.85, ["Neon|Ride"] = 1784.04, ["Neon|Fly|Ride"] = 1968.75, ["Mega|Fly|Ride"] = 5880}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 9.08, ["Fly"] = 27.87, ["Ride"] = 19.19, ["Fly|Ride"] = 63.02, ["Neon"] = 40.69, ["Neon|Ride"] = 97.13, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 158.81, ["Mega|Ride"] = 360.76, ["Mega|Fly|Ride"] = 468.49}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 5.24, ["Fly"] = 524.69, ["Ride"] = 19.62, ["Fly|Ride"] = 51.54, ["Neon"] = 39.35, ["Neon|Fly"] = 315, ["Neon|Ride"] = 88.75, ["Neon|Fly|Ride"] = 160.97, ["Mega"] = 331.85, ["Mega|Ride"] = 412.77, ["Mega|Fly|Ride"] = 481.91}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 2.1, ["Fly"] = 15.49, ["Ride"] = 26.77, ["Fly|Ride"] = 309.54, ["Neon"] = 13.12, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 131.25, ["Mega|Ride"] = 275.54}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.58, ["Ride"] = 21.61, ["Fly|Ride"] = 77.01, ["Neon"] = 7.44, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 129.43, ["Mega"] = 75.12, ["Mega|Fly"] = 211.78, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 210.5}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 69.14, ["Ride"] = 19.69, ["Neon"] = 2.1, ["Neon|Ride"] = 23.6, ["Neon|Fly|Ride"] = 118.12, ["Mega"] = 19.63, ["Mega|Ride"] = 63.32, ["Mega|Fly|Ride"] = 221.55}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1050}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 11.36, ["Ride"] = 39.38, ["Fly|Ride"] = 52.5, ["Neon"] = 57.75, ["Neon|Ride"] = 105, ["Mega"] = 550.98, ["Mega|Ride"] = 559.85, ["Mega|Fly|Ride"] = 1030.87}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 25.85, ["Neon"] = 4.61, ["Neon|Ride"] = 74.3, ["Neon|Fly|Ride"] = 982.1, ["Mega"] = 39.26, ["Mega|Ride"] = 141.85, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.1, ["Fly"] = 41.79, ["Ride"] = 98.32, ["Fly|Ride"] = 412.72, ["Neon"] = 19.48, ["Neon|Ride"] = 140.26, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 183.74, ["Mega|Ride"] = 366.24, ["Mega|Fly|Ride"] = 378.72}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 488.25, ["Ride"] = 495.33, ["Fly|Ride"] = 472.5, ["Neon|Ride"] = 2190.11, ["Neon|Fly|Ride"] = 1706.25, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 2.63, ["Fly"] = 196.88, ["Ride"] = 55.74, ["Fly|Ride"] = 412.72, ["Neon"] = 32.82, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 186.56, ["Mega"] = 481.85, ["Mega|Ride"] = 466.55, ["Mega|Fly|Ride"] = 669.48}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Fly"] = 88.51, ["Ride"] = 24.94, ["Fly|Ride"] = 118.13, ["Neon"] = 3.61, ["Neon|Ride"] = 34.26, ["Neon|Fly|Ride"] = 87.6, ["Mega"] = 35.85, ["Mega|Fly"] = 82.56, ["Mega|Ride"] = 70.82, ["Mega|Fly|Ride"] = 177.09}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Ride"] = 28.28, ["Neon|Fly|Ride"] = 275.5, ["Mega"] = 31.5, ["Mega|Ride"] = 134.78, ["Mega|Fly|Ride"] = 374.07}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 15.49, ["Fly"] = 107.63, ["Ride"] = 69.14, ["Fly|Ride"] = 87.28, ["Neon"] = 127.45, ["Neon|Ride"] = 129.55, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 493.2, ["Mega|Ride"] = 604.7, ["Mega|Fly|Ride"] = 594.57}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 7.93, ["Ride"] = 71.31, ["Neon"] = 80.12, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 918.75, ["Mega"] = 393.75, ["Mega|Ride"] = 477.75, ["Mega|Fly|Ride"] = 619.16}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 7, ["Ride"] = 31.39, ["Neon"] = 316.5, ["Neon|Ride"] = 176.18, ["Mega"] = 644.69, ["Mega|Ride"] = 1059.77, ["Mega|Fly|Ride"] = 1238.29}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 11.46, ["Ride"] = 23.15, ["Fly|Ride"] = 249.68, ["Neon"] = 145.98, ["Neon|Ride"] = 182.44, ["Neon|Fly|Ride"] = 206.37, ["Mega"] = 616.88, ["Mega|Ride"] = 1300.69, ["Mega|Fly|Ride"] = 665.44}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 306.87, ["Ride"] = 466.69, ["Fly|Ride"] = 751.35, ["Neon"] = 918.75, ["Neon|Ride"] = 1059.64, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Ride"] = 3990.35, ["Mega|Fly|Ride"] = 4126.57}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 4.81, ["Fly"] = 78.74, ["Ride"] = 20.01, ["Fly|Ride"] = 101.13, ["Neon"] = 129.84, ["Neon|Ride"] = 159.12, ["Mega"] = 825.43, ["Mega|Ride"] = 1019.82, ["Mega|Fly|Ride"] = 1028.82}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 4.2, ["Ride"] = 126, ["Neon"] = 48.5, ["Neon|Ride"] = 52.5, ["Mega"] = 218.75, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 1031.91}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 17.75, ["Ride"] = 70.87, ["Neon"] = 79.71, ["Neon|Ride"] = 124.47, ["Neon|Fly|Ride"] = 260.78, ["Mega"] = 282.19, ["Mega|Fly"] = 688.2, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 334.59}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.61, ["Ride"] = 78.43, ["Fly|Ride"] = 138.27, ["Neon"] = 9.34, ["Neon|Ride"] = 35.1, ["Mega"] = 53.23, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 295.32}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 38.06, ["Ride"] = 67.34, ["Neon"] = 323.99, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 472.57, ["Mega"] = 2476.25, ["Mega|Ride"] = 1399.61, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 583.51, ["Ride"] = 23.22, ["Fly|Ride"] = 60.36, ["Neon"] = 10.5, ["Neon|Fly"] = 179.54, ["Neon|Ride"] = 76.37, ["Neon|Fly|Ride"] = 112.02, ["Mega"] = 92.59, ["Mega|Ride"] = 107.63, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 41.28, ["Ride"] = 31.52, ["Fly|Ride"] = 157.5, ["Neon"] = 5.93, ["Neon|Fly"] = 49.38, ["Neon|Ride"] = 47.16, ["Neon|Fly|Ride"] = 97.89, ["Mega"] = 39.76, ["Mega|Fly"] = 101.46, ["Mega|Ride"] = 74.17, ["Mega|Fly|Ride"] = 170.36}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Ride"] = 37.97, ["Fly|Ride"] = 127.52, ["Neon"] = 14.44, ["Neon|Ride"] = 53.45, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 111.37, ["Mega|Fly"] = 459.38, ["Mega|Ride"] = 144.27, ["Mega|Fly|Ride"] = 311.42}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 36.57, ["Fly"] = 93.35, ["Ride"] = 59.06, ["Fly|Ride"] = 266.21, ["Neon"] = 291.38, ["Neon|Ride"] = 300.38, ["Neon|Fly|Ride"] = 472.33, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 222.2, ["Ride"] = 275.5, ["Fly|Ride"] = 371.45, ["Neon"] = 1434.17, ["Neon|Ride"] = 1100.91, ["Neon|Fly|Ride"] = 1282.51, ["Mega"] = 3937.5, ["Mega|Fly|Ride"] = 4410}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 32.82, ["Neon"] = 27.88, ["Neon|Fly"] = 350.44, ["Mega"] = 98.44, ["Mega|Ride"] = 202.42, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.63, ["Fly"] = 138.26, ["Ride"] = 32.82, ["Neon"] = 8.15, ["Neon|Ride"] = 44.1, ["Neon|Fly|Ride"] = 139.13, ["Mega"] = 56.55, ["Mega|Fly"] = 210, ["Mega|Ride"] = 102.37, ["Mega|Fly|Ride"] = 241.5}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 4.66, ["Fly"] = 158.75, ["Ride"] = 27.57, ["Fly|Ride"] = 95.82, ["Neon"] = 32.8, ["Neon|Ride"] = 69.14, ["Mega"] = 133.88, ["Mega|Ride"] = 348.23}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 70, ["Ride"] = 39.22, ["Fly|Ride"] = 367.32, ["Neon"] = 8.19, ["Neon|Ride"] = 46.34, ["Neon|Fly|Ride"] = 152.73, ["Mega"] = 124.2, ["Mega|Ride"] = 141.32, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 90.81, ["Neon"] = 7.87, ["Neon|Fly|Ride"] = 188.83, ["Mega"] = 39.76, ["Mega|Fly"] = 138.27, ["Mega|Fly|Ride"] = 272.44}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 27.88, ["Ride"] = 17.06, ["Fly|Ride"] = 49.88, ["Neon"] = 7.12, ["Neon|Fly"] = 78.19, ["Neon|Ride"] = 22.71, ["Neon|Fly|Ride"] = 412.72, ["Mega|Ride"] = 95.72, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 16.53, ["Ride"] = 15.89, ["Fly|Ride"] = 61.69, ["Neon"] = 30.16, ["Neon|Fly"] = 64.97, ["Neon|Ride"] = 26.16, ["Neon|Fly|Ride"] = 93.29, ["Mega"] = 156.15, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 436.96}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 26.25, ["Fly"] = 52.5, ["Ride"] = 31.37, ["Fly|Ride"] = 78.66, ["Neon|Fly|Ride"] = 316.5, ["Mega"] = 510.75, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 548.79}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 64.79, ["Ride"] = 78.65, ["Fly|Ride"] = 124.52, ["Neon"] = 412.72, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 3346.14, ["Mega|Ride"] = 3254.99, ["Mega|Fly|Ride"] = 1502.82}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 17.88, ["Fly|Ride"] = 131.25, ["Neon"] = 3.93, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 128.47, ["Mega"] = 36.9, ["Mega|Fly"] = 672, ["Mega|Ride"] = 89.79}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 12.36, ["Ride"] = 13.55, ["Fly|Ride"] = 36.66, ["Neon"] = 3.56, ["Neon|Fly"] = 28.37, ["Neon|Ride"] = 18.8, ["Neon|Fly|Ride"] = 61.68, ["Mega"] = 61.58, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 129.94}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 11.31, ["Ride"] = 73.49, ["Neon"] = 17.07, ["Neon|Ride"] = 124.68, ["Neon|Fly|Ride"] = 275.5, ["Mega"] = 527.63, ["Mega|Ride"] = 484.36, ["Mega|Fly|Ride"] = 622.83}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 388.4, ["Fly"] = 518.44, ["Ride"] = 472.5, ["Fly|Ride"] = 577.5, ["Neon|Ride"] = 6562.5, ["Mega|Fly|Ride"] = 7775.93}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 23.73, ["Fly"] = 101.33, ["Ride"] = 50.58, ["Fly|Ride"] = 84.72, ["Neon"] = 236.25, ["Neon|Ride"] = 210.74, ["Neon|Fly|Ride"] = 199.38, ["Mega|Ride"] = 1238.29, ["Mega|Fly|Ride"] = 917.91}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 25.85, ["Fly|Ride"] = 281.29, ["Neon"] = 9.66, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 152.73, ["Mega"] = 58.97, ["Mega|Ride"] = 126.99, ["Mega|Fly|Ride"] = 198.14}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.62, ["Fly"] = 91.88, ["Ride"] = 65.61, ["Fly|Ride"] = 143.05, ["Neon"] = 12.79, ["Mega"] = 328.13}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 24.59, ["Fly"] = 196.88, ["Ride"] = 45.09, ["Fly|Ride"] = 65.63, ["Neon"] = 194.25, ["Neon|Ride"] = 352.22, ["Neon|Fly|Ride"] = 264.99, ["Mega"] = 2476.25, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1238.29}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 77.58, ["Fly"] = 123.83, ["Ride"] = 108.94, ["Fly|Ride"] = 412.72, ["Neon"] = 434.43, ["Neon|Ride"] = 548.91, ["Neon|Fly|Ride"] = 610.32, ["Mega"] = 8254.15, ["Mega|Fly|Ride"] = 2228.91}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 181.92, ["Ride"] = 264.31, ["Fly|Ride"] = 514.86, ["Neon"] = 1050, ["Neon|Ride"] = 853.29, ["Neon|Fly|Ride"] = 1238.13, ["Mega|Fly|Ride"] = 3495.05}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 11.87, ["Fly"] = 51.81, ["Ride"] = 56.56, ["Fly|Ride"] = 96.16, ["Neon"] = 77.18, ["Neon|Ride"] = 118.13, ["Mega"] = 388.49, ["Mega|Ride"] = 363.57, ["Mega|Fly|Ride"] = 498.82}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 17.2, ["Ride"] = 13.8, ["Fly|Ride"] = 41.91, ["Neon"] = 5.61, ["Neon|Ride"] = 21.75, ["Neon|Fly|Ride"] = 85.65, ["Mega"] = 59.07, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 170.24}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 3.15, ["Fly"] = 38.66, ["Ride"] = 15.65, ["Fly|Ride"] = 58.34, ["Neon"] = 42.95, ["Neon|Fly"] = 105, ["Neon|Ride"] = 35.47, ["Neon|Fly|Ride"] = 109.38, ["Mega|Ride"] = 279.57, ["Mega|Fly|Ride"] = 366.19}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 301.88, ["Fly"] = 481.79, ["Ride"] = 339.7, ["Fly|Ride"] = 609.78, ["Neon"] = 1575, ["Neon|Ride"] = 2150.35, ["Neon|Fly|Ride"] = 1789.1, ["Mega"] = 9904.99, ["Mega|Fly|Ride"] = 6269.82}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 32.62, ["Neon"] = 6.18, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 53.65, ["Mega|Ride"] = 170.99, ["Mega|Fly|Ride"] = 447.99}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 4.29, ["Ride"] = 13.78, ["Fly|Ride"] = 55.13, ["Neon"] = 21.95, ["Neon|Ride"] = 37.54, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 225.96, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 179.57, ["Mega|Fly|Ride"] = 294}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 14.01, ["Ride"] = 46.68, ["Neon"] = 90.2, ["Neon|Fly"] = 412.72, ["Neon|Ride"] = 236.24, ["Mega"] = 527.7, ["Mega|Ride"] = 649.68, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 117.62, ["Fly"] = 210.47, ["Ride"] = 114.35, ["Fly|Ride"] = 156.35, ["Neon|Ride"] = 524.99, ["Neon|Fly|Ride"] = 586.34, ["Mega|Fly|Ride"] = 2378.25}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 16.49, ["Fly"] = 42.95, ["Ride"] = 19.69, ["Fly|Ride"] = 55.55, ["Neon"] = 104.24, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 688.2, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 727.13}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 20.83, ["Neon"] = 2.63, ["Neon|Ride"] = 138.27, ["Mega"] = 23.63, ["Mega|Ride"] = 275.54, ["Mega|Fly|Ride"] = 275.54}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Fly"] = 39.37, ["Ride"] = 19.69, ["Fly|Ride"] = 70.17, ["Neon"] = 2.1, ["Neon|Ride"] = 19.84, ["Neon|Fly|Ride"] = 75.51, ["Mega"] = 26.7, ["Mega|Fly"] = 87.64, ["Mega|Ride"] = 39.08, ["Mega|Fly|Ride"] = 103.85}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 9.7, ["Ride"] = 72.35, ["Fly|Ride"] = 131.18, ["Neon"] = 27.72, ["Neon|Fly"] = 144.38, ["Neon|Ride"] = 78.54, ["Neon|Fly|Ride"] = 181.9, ["Mega"] = 138.75, ["Mega|Fly"] = 293.04, ["Mega|Ride"] = 202.13, ["Mega|Fly|Ride"] = 308.34}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1168.12, ["Fly"] = 1610.47, ["Ride"] = 1298.08, ["Fly|Ride"] = 1299.38, ["Neon"] = 4200, ["Neon|Ride"] = 3845.63, ["Neon|Fly|Ride"] = 3797.17, ["Mega|Fly|Ride"] = 12589.5}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 408.84, ["Fly"] = 918.75, ["Ride"] = 451.5, ["Fly|Ride"] = 638.8, ["Neon"] = 2422.61, ["Neon|Ride"] = 2573.24, ["Neon|Fly|Ride"] = 2362.5, ["Mega"] = 16508.29, ["Mega|Fly|Ride"] = 9356.22}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 291.8, ["Ride"] = 360.17, ["Fly|Ride"] = 429.07, ["Neon"] = 656.14, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 774.38, ["Mega|Fly|Ride"] = 2916.24}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 269.07, ["Fly"] = 550.98, ["Ride"] = 343.26, ["Fly|Ride"] = 468.43, ["Neon|Fly"] = 945, ["Neon|Ride"] = 4666.71, ["Neon|Fly|Ride"] = 1405.69, ["Mega|Fly|Ride"] = 5504.15}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 64.31, ["Ride"] = 15.64, ["Fly|Ride"] = 38.7, ["Neon"] = 7.86, ["Neon|Ride"] = 38.06, ["Neon|Fly|Ride"] = 104.9, ["Mega"] = 58.28, ["Mega|Ride"] = 139.13, ["Mega|Fly|Ride"] = 200.82}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 406.88, ["Fly"] = 1376.39, ["Ride"] = 375.98, ["Fly|Ride"] = 597.41, ["Neon"] = 1706.24, ["Neon|Ride"] = 1365, ["Neon|Fly|Ride"] = 1956.25, ["Mega|Ride"] = 6604.16, ["Mega|Fly|Ride"] = 3936.19}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 6.02, ["Fly"] = 183.75, ["Ride"] = 35.1, ["Fly|Ride"] = 112.54, ["Neon"] = 15.75, ["Neon|Ride"] = 69.14, ["Neon|Fly|Ride"] = 252, ["Mega"] = 137.36, ["Mega|Ride"] = 204.65, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 18.12, ["Ride"] = 13.76, ["Fly|Ride"] = 31.97, ["Neon"] = 7.88, ["Neon|Ride"] = 28.02, ["Neon|Fly|Ride"] = 110.41, ["Mega"] = 104.81, ["Mega|Ride"] = 192.93}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 54.91, ["Neon"] = 2.15, ["Neon|Ride"] = 39.37, ["Mega"] = 39.22, ["Mega|Ride"] = 196.77}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 26.17, ["Ride"] = 55.49, ["Fly|Ride"] = 459.37, ["Neon"] = 235.75, ["Neon|Ride"] = 351.29, ["Mega"] = 1050, ["Mega|Ride"] = 488.25, ["Mega|Fly|Ride"] = 773.07}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 26.84, ["Fly|Ride"] = 68.24, ["Neon"] = 73.5, ["Mega|Ride"] = 424.55, ["Mega|Fly|Ride"] = 412.77}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.12, ["Neon"] = 3.52, ["Neon|Ride"] = 40.32, ["Neon|Fly|Ride"] = 91.13, ["Mega"] = 23.78, ["Mega|Ride"] = 67.93, ["Mega|Fly|Ride"] = 163.17}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.1, ["Fly"] = 34.04, ["Ride"] = 16.4, ["Fly|Ride"] = 78.65, ["Neon"] = 10.39, ["Neon|Fly"] = 113.9, ["Neon|Ride"] = 44.01, ["Neon|Fly|Ride"] = 76.56, ["Mega"] = 110.88, ["Mega|Fly"] = 311.32, ["Mega|Ride"] = 129.93, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 4.1, ["Fly"] = 55.73, ["Ride"] = 19.23, ["Fly|Ride"] = 52.5, ["Neon"] = 152.73, ["Neon|Fly"] = 40.25, ["Neon|Ride"] = 138.27, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 237.57, ["Mega|Ride"] = 300.51, ["Mega|Fly|Ride"] = 233.28}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 7.88, ["Ride"] = 58.34, ["Neon"] = 115.5, ["Mega"] = 506.01, ["Mega|Ride"] = 413.44, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.1, ["Fly"] = 6223.05, ["Ride"] = 27.88, ["Neon"] = 37.79, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 183.72, ["Neon|Fly|Ride"] = 699.55, ["Mega"] = 301.88, ["Mega|Ride"] = 481.91, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 64.16, ["Ride"] = 18.26, ["Fly|Ride"] = 45.94, ["Neon"] = 3.82, ["Neon|Fly"] = 82.48, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 69.14, ["Mega"] = 43.3, ["Mega|Ride"] = 176.13, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 155.19, ["Ride"] = 178.4, ["Fly|Ride"] = 254.63, ["Neon"] = 1686.78, ["Neon|Ride"] = 887.34, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 8254.15, ["Mega|Ride"] = 4127.6, ["Mega|Fly|Ride"] = 2756.25}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 18.36, ["Ride"] = 13.55, ["Fly|Ride"] = 28.24, ["Neon"] = 2.41, ["Neon|Ride"] = 19.83, ["Neon|Fly|Ride"] = 56.25, ["Mega"] = 40.25, ["Mega|Ride"] = 52.65, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 6.49, ["Ride"] = 42.36, ["Fly|Ride"] = 183.74, ["Neon"] = 96.99, ["Neon|Ride"] = 133.86, ["Mega"] = 312.38, ["Mega|Fly"] = 777.67, ["Mega|Fly|Ride"] = 1031.91}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 34.2, ["Ride"] = 275.5, ["Fly|Ride"] = 170.63, ["Neon"] = 189.58, ["Neon|Ride"] = 270.21, ["Mega"] = 786.19, ["Mega|Ride"] = 835.51, ["Mega|Fly|Ride"] = 1160.52}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 171.76, ["Ride"] = 253.45, ["Fly|Ride"] = 311.76, ["Neon"] = 735, ["Neon|Ride"] = 894.56, ["Neon|Fly|Ride"] = 982.66, ["Mega|Fly|Ride"] = 3638.96}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 16.59, ["Fly|Ride"] = 138.27, ["Neon"] = 117.64, ["Mega"] = 284.57, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 695.63}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 7.12, ["Ride"] = 76.37, ["Fly|Ride"] = 181.39, ["Neon"] = 412.72, ["Neon|Fly"] = 156.35, ["Neon|Ride"] = 199, ["Mega"] = 771.89, ["Mega|Ride"] = 825.53, ["Mega|Fly|Ride"] = 963.81}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 1181.25, ["Fly"] = 1050, ["Ride"] = 1043.34, ["Fly|Ride"] = 1239.24, ["Neon"] = 3440.96, ["Neon|Ride"] = 4790.63, ["Neon|Fly|Ride"] = 4650.19, ["Mega|Fly|Ride"] = 18120.11}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 8.38, ["Fly"] = 19.68, ["Ride"] = 19.79, ["Fly|Ride"] = 91.02, ["Neon"] = 26.25, ["Neon|Fly"] = 97.82, ["Neon|Ride"] = 91.87, ["Neon|Fly|Ride"] = 206.37, ["Mega"] = 218.04, ["Mega|Fly|Ride"] = 388.5}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 3.78, ["Fly"] = 51.19, ["Ride"] = 19.69, ["Fly|Ride"] = 135.19, ["Neon"] = 34.2, ["Neon|Ride"] = 60.68, ["Mega"] = 200.18, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 253.49}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Fly"] = 81.52, ["Ride"] = 23.76, ["Fly|Ride"] = 93.74, ["Neon"] = 10.03, ["Neon|Ride"] = 47.16, ["Mega"] = 93.29, ["Mega|Ride"] = 240.62, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 12.57, ["Ride"] = 27.81, ["Fly|Ride"] = 81.92, ["Neon"] = 59.07, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 141.56, ["Mega"] = 435.2, ["Mega|Ride"] = 427.49, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 8.21, ["Fly"] = 20.45, ["Ride"] = 20.55, ["Fly|Ride"] = 51.1, ["Neon"] = 13.13, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 35.6, ["Neon|Fly|Ride"] = 94.49, ["Mega|Fly"] = 247.65, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 291}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.2, ["Ride"] = 14.37, ["Neon"] = 12.22, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 52.63, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 138.27, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 347.82}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 262.05, ["Ride"] = 236.25, ["Fly|Ride"] = 344.63, ["Neon|Fly|Ride"] = 984.38}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Fly"] = 32.71, ["Ride"] = 19.69, ["Fly|Ride"] = 72.19, ["Neon"] = 6.49, ["Neon|Fly"] = 82.56, ["Neon|Ride"] = 31.91, ["Neon|Fly|Ride"] = 110.44, ["Mega"] = 85.78, ["Mega|Fly"] = 412.72, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 267.28}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 2.51, ["Ride"] = 81.79, ["Fly|Ride"] = 88.87, ["Neon"] = 36.12, ["Neon|Ride"] = 188.27, ["Mega"] = 124.69, ["Mega|Ride"] = 233.28}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 2.1, ["Fly"] = 98.01, ["Ride"] = 26.25, ["Neon"] = 20.35, ["Neon|Ride"] = 51.18, ["Mega"] = 99.75, ["Mega|Fly"] = 139.93, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 491.96}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["Fly|Ride"] = 825.43, ["Neon|Ride"] = 1097.91, ["Mega|Ride"] = 2488.96, ["Mega|Fly|Ride"] = 3027.6}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 28.87, ["Ride"] = 49.54, ["Fly|Ride"] = 206.37, ["Neon"] = 149.5, ["Neon|Fly|Ride"] = 374.07, ["Mega"] = 393.75, ["Mega|Ride"] = 863.09, ["Mega|Fly|Ride"] = 893.63}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 18.79, ["Fly"] = 69.14, ["Ride"] = 30.97, ["Fly|Ride"] = 87.94, ["Neon"] = 96.99, ["Neon|Ride"] = 124.67, ["Neon|Fly|Ride"] = 195.7, ["Mega"] = 548.02, ["Mega|Ride"] = 412.77, ["Mega|Fly|Ride"] = 540.68}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 4.23, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 210, ["Mega"] = 52.5, ["Mega|Ride"] = 275.54, ["Mega|Fly|Ride"] = 237.36}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 42.56, ["Fly"] = 5835.01, ["Ride"] = 77.44, ["Fly|Ride"] = 179.29, ["Neon"] = 262.47, ["Neon|Fly"] = 258.79, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 298.83, ["Mega|Fly|Ride"] = 1011.71}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 19.46, ["Fly|Ride"] = 32.15, ["Neon"] = 5, ["Neon|Ride"] = 55.74, ["Neon|Fly|Ride"] = 122.8, ["Mega"] = 58.9, ["Mega|Fly|Ride"] = 412.77}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 18.09, ["Fly"] = 124.89, ["Ride"] = 28.61, ["Fly|Ride"] = 84.02, ["Neon"] = 69.14, ["Neon|Ride"] = 125.15, ["Neon|Fly|Ride"] = 247.65, ["Mega"] = 275.5, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 412.77, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 32.81, ["Fly"] = 78.75, ["Ride"] = 81.53, ["Fly|Ride"] = 156.45, ["Neon"] = 183.75, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 412.72, ["Mega|Ride"] = 1927.61, ["Mega|Fly|Ride"] = 1169.44}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 27.88, ["Ride"] = 13.86, ["Fly|Ride"] = 35.43, ["Neon"] = 2.1, ["Neon|Fly"] = 23.96, ["Neon|Ride"] = 15.49, ["Neon|Fly|Ride"] = 30.19, ["Mega"] = 40.25, ["Mega|Fly"] = 118.57, ["Mega|Ride"] = 28.77, ["Mega|Fly|Ride"] = 86.63}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 2.45, ["Ride"] = 52.5, ["Fly|Ride"] = 131.15, ["Neon"] = 16.3, ["Neon|Ride"] = 49.54, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 228.03, ["Mega|Ride"] = 272.94, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 19.42, ["Ride"] = 45.94, ["Neon"] = 111.44, ["Neon|Ride"] = 550.98, ["Mega"] = 536.71, ["Mega|Ride"] = 459.37, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 19.13, ["Neon"] = 2.1, ["Neon|Ride"] = 28.86, ["Neon|Fly|Ride"] = 95.8, ["Mega"] = 16.64, ["Mega|Ride"] = 65.54}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 10.53, ["Fly"] = 189.5, ["Ride"] = 58.97, ["Fly|Ride"] = 164.05, ["Neon"] = 51.98, ["Neon|Ride"] = 120.96, ["Neon|Fly|Ride"] = 357.95, ["Mega"] = 528.28, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 1294.01}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 15.49, ["Fly"] = 41.28, ["Ride"] = 21.56, ["Fly|Ride"] = 98.44, ["Neon"] = 388.52, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 129.94, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 3.57, ["Ride"] = 18.12, ["Fly|Ride"] = 138.27, ["Neon"] = 28.55, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 130.19, ["Mega"] = 233.62, ["Mega|Ride"] = 242.82, ["Mega|Fly|Ride"] = 373.24}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 11.92, ["Fly"] = 2063.56, ["Ride"] = 66.94, ["Fly|Ride"] = 238.64, ["Neon"] = 41.28, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 6217.76, ["Mega"] = 466.37, ["Mega|Ride"] = 442.32}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Fly"] = 41.28, ["Ride"] = 16.15, ["Fly|Ride"] = 196.88, ["Neon"] = 6.4, ["Neon|Ride"] = 32.43, ["Mega"] = 69.44, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 150.67, ["Mega|Fly|Ride"] = 275.54}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 55.53, ["Neon"] = 3.82, ["Neon|Ride"] = 42.26, ["Mega"] = 27.57, ["Mega|Ride"] = 128.63, ["Mega|Fly|Ride"] = 269.53}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 23.13}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 34.44, ["Fly"] = 78.75, ["Ride"] = 37.8, ["Fly|Ride"] = 83.61, ["Neon"] = 131.25, ["Neon|Ride"] = 274.55, ["Neon|Fly|Ride"] = 313.68, ["Mega"] = 1650.85, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 889.88}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.68, ["Neon|Ride"] = 110.82, ["Neon|Fly|Ride"] = 138.27, ["Mega"] = 20.34, ["Mega|Ride"] = 119.6, ["Mega|Fly|Ride"] = 299.25}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 446.25, ["Fly"] = 498.75, ["Ride"] = 550.98, ["Fly|Ride"] = 641.82, ["Neon"] = 2059.42, ["Neon|Fly|Ride"] = 2273.82, ["Mega"] = 16508.29, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 2.2, ["Fly"] = 26.24, ["Ride"] = 24.45, ["Fly|Ride"] = 66.26, ["Neon"] = 30.98, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 90.42, ["Mega|Ride"] = 144.37, ["Mega|Fly|Ride"] = 551.06}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 20.9, ["Fly|Ride"] = 69.33, ["Neon"] = 24.97, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 123.83, ["Mega"] = 149, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 227.07}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 16.52, ["Fly"] = 69.14, ["Ride"] = 50.3, ["Fly|Ride"] = 106.32, ["Neon"] = 98.6, ["Neon|Ride"] = 165.1, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 808.92, ["Mega|Ride"] = 879.38, ["Mega|Fly|Ride"] = 963.81}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 2.1, ["Fly"] = 55.74, ["Ride"] = 27.88, ["Fly|Ride"] = 721.88, ["Neon"] = 25.26, ["Neon|Ride"] = 118.12, ["Mega"] = 262.5}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 9.56, ["Fly"] = 139.53, ["Ride"] = 42, ["Fly|Ride"] = 173.23, ["Neon"] = 138.23, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 359.28, ["Mega"] = 416.5, ["Mega|Ride"] = 624, ["Mega|Fly|Ride"] = 488.94}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 6.12, ["Ride"] = 51.93, ["Fly|Ride"] = 133.88, ["Neon"] = 32.45, ["Neon|Ride"] = 77.16, ["Neon|Fly|Ride"] = 204.75, ["Mega"] = 323.52, ["Mega|Fly"] = 550.98, ["Mega|Ride"] = 344.09, ["Mega|Fly|Ride"] = 359.51}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 46.68, ["Ride"] = 11.71, ["Fly|Ride"] = 69.14, ["Neon"] = 2.1, ["Neon|Fly"] = 58.83, ["Neon|Ride"] = 15.38, ["Neon|Fly|Ride"] = 138.27, ["Mega"] = 15.65, ["Mega|Ride"] = 24.94, ["Mega|Fly|Ride"] = 152.81}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 6.46, ["Fly"] = 52.63, ["Ride"] = 32.61, ["Fly|Ride"] = 103.19, ["Neon"] = 40.78, ["Neon|Fly"] = 116.68, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 220.81, ["Mega"] = 196.84, ["Mega|Ride"] = 217.88}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 294.84, ["Fly"] = 385.86, ["Ride"] = 298.86, ["Fly|Ride"] = 393.75, ["Neon"] = 1312.5, ["Neon|Ride"] = 1263.94, ["Neon|Fly|Ride"] = 1252.12, ["Mega|Ride"] = 9050.72, ["Mega|Fly|Ride"] = 5086.99}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 81.37, ["Ride"] = 138.27, ["Fly|Ride"] = 282.35, ["Neon"] = 536.47, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 574.41, ["Mega"] = 2201.81, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1704.94}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 12.39, ["Ride"] = 15.22, ["Fly|Ride"] = 41.28, ["Neon"] = 136.2, ["Neon|Fly"] = 69.14, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 63.31, ["Mega|Fly"] = 205.33, ["Mega|Ride"] = 80.5, ["Mega|Fly|Ride"] = 258.58}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 13.01, ["Fly|Ride"] = 19.69, ["Neon"] = 10.48, ["Neon|Fly"] = 41.28, ["Neon|Ride"] = 19.83, ["Neon|Fly|Ride"] = 49.38, ["Mega"] = 96.99, ["Mega|Fly"] = 344.63, ["Mega|Ride"] = 116.82, ["Mega|Fly|Ride"] = 249.27}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.1, ["Ride"] = 22.32, ["Fly|Ride"] = 98.44, ["Neon"] = 45.85, ["Mega"] = 206.37, ["Mega|Ride"] = 412.77}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 257.15, ["Fly"] = 420, ["Ride"] = 249.37, ["Fly|Ride"] = 367.5, ["Neon|Ride"] = 1031.79, ["Neon|Fly|Ride"] = 1527.03, ["Mega|Ride"] = 8255.18, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.1, ["Fly"] = 19.84, ["Ride"] = 13.55, ["Fly|Ride"] = 31.4, ["Neon"] = 17.07, ["Neon|Fly"] = 104.97, ["Neon|Ride"] = 39.25, ["Neon|Fly|Ride"] = 139.93, ["Mega"] = 255.94, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 361.18}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 6.15, ["Ride"] = 98.44, ["Fly|Ride"] = 206.37, ["Neon"] = 56.56, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 275.5, ["Mega"] = 275.5, ["Mega|Ride"] = 288.65, ["Mega|Fly|Ride"] = 413.22}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 28.13, ["Neon"] = 5.08, ["Neon|Ride"] = 155.6, ["Mega"] = 83.39, ["Mega|Ride"] = 207.38}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 14.32, ["Fly"] = 58.83, ["Ride"] = 19.55, ["Fly|Ride"] = 74.81, ["Neon"] = 80.76, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 180.58, ["Mega"] = 589.16, ["Mega|Ride"] = 438.38, ["Mega|Fly|Ride"] = 655.27}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 39.78, ["Ride"] = 89.25, ["Fly|Ride"] = 296.83, ["Neon"] = 131.24, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 358.03, ["Mega"] = 465.28, ["Mega|Fly"] = 2166.72, ["Mega|Ride"] = 485.5, ["Mega|Fly|Ride"] = 528.94}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 15.65, ["Ride"] = 43.32, ["Fly|Ride"] = 91.88, ["Neon"] = 104.9, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 210.5, ["Neon|Fly|Ride"] = 300.36, ["Mega|Ride"] = 840.16, ["Mega|Fly|Ride"] = 770.84}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 20.65, ["Ride"] = 14.91, ["Fly|Ride"] = 26.25, ["Neon"] = 2.1, ["Neon|Fly"] = 17.46, ["Neon|Ride"] = 15.31, ["Neon|Fly|Ride"] = 60.89, ["Mega"] = 17.07, ["Mega|Fly"] = 418.82, ["Mega|Ride"] = 40.22, ["Mega|Fly|Ride"] = 98.44}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 207.29, ["Ride"] = 280.88, ["Fly|Ride"] = 328.02, ["Neon"] = 1921.7, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1172.52, ["Mega|Fly|Ride"] = 4331.25}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 11.46, ["Fly"] = 101.18, ["Ride"] = 42.37, ["Fly|Ride"] = 105, ["Neon"] = 131.04, ["Neon|Ride"] = 39.82, ["Neon|Fly|Ride"] = 328.12, ["Mega|Ride"] = 699.82, ["Mega|Fly|Ride"] = 777.95}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 24.94, ["Ride"] = 16.96, ["Fly|Ride"] = 44.35, ["Neon"] = 4.69, ["Neon|Fly"] = 35.68, ["Neon|Ride"] = 27.34, ["Neon|Fly|Ride"] = 109.38, ["Mega"] = 60.89, ["Mega|Fly"] = 275.5, ["Mega|Ride"] = 69.33, ["Mega|Fly|Ride"] = 211.78}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 27.57, ["Ride"] = 15.44, ["Fly|Ride"] = 43.28, ["Neon"] = 2.1, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 27.88, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 24.9, ["Mega|Fly"] = 138.27, ["Mega|Ride"] = 56.43, ["Mega|Fly|Ride"] = 184.72}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.96, ["Ride"] = 28.65, ["Fly|Ride"] = 63.86, ["Neon"] = 8.56, ["Neon|Fly"] = 700.02, ["Neon|Ride"] = 70.02, ["Mega"] = 103.67, ["Mega|Ride"] = 194.08, ["Mega|Fly|Ride"] = 373.24}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 7.14, ["Fly"] = 47.25, ["Ride"] = 22.51, ["Fly|Ride"] = 58.97, ["Neon"] = 32.82, ["Neon|Fly"] = 262.08, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 93.19, ["Mega"] = 428.21, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 9.18, ["Ride"] = 55.12, ["Fly|Ride"] = 72.19, ["Neon"] = 44.1, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 275.63, ["Mega|Ride"] = 311.42, ["Mega|Fly|Ride"] = 410.7}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 41.28, ["Neon"] = 2.1, ["Neon|Ride"] = 31.39, ["Neon|Fly|Ride"] = 100.65, ["Mega"] = 30.98, ["Mega|Ride"] = 71.31, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 8.23, ["Ride"] = 24.76, ["Fly|Ride"] = 131.25, ["Neon"] = 26.92, ["Neon|Fly"] = 138.11, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 105.26, ["Mega"] = 209.2, ["Mega|Ride"] = 200.82, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 78.43, ["Neon"] = 2.91, ["Neon|Fly"] = 110.41, ["Neon|Ride"] = 45.77, ["Neon|Fly|Ride"] = 156.24, ["Mega"] = 31.29, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 138.29}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 41.46, ["Ride"] = 16.69, ["Fly|Ride"] = 39.38, ["Neon"] = 3.08, ["Neon|Ride"] = 20.88, ["Neon|Fly|Ride"] = 120.58, ["Mega"] = 52.41, ["Mega|Fly"] = 138.27, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 213.5}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 745.06, ["Ride"] = 822.7, ["Fly|Ride"] = 825.57, ["Neon|Ride"] = 3575.83, ["Neon|Fly|Ride"] = 3301.68, ["Mega|Fly|Ride"] = 17886.9}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 19.22, ["Ride"] = 13.55, ["Fly|Ride"] = 31.54, ["Neon"] = 17.75, ["Neon|Fly"] = 138.27, ["Neon|Ride"] = 27.88, ["Neon|Fly|Ride"] = 72.24, ["Mega|Fly|Ride"] = 344.67}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.1, ["Ride"] = 26.17, ["Fly|Ride"] = 275.5, ["Neon"] = 8.33, ["Neon|Fly"] = 722.25, ["Neon|Ride"] = 88.54, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 52.41, ["Mega|Ride"] = 134.03, ["Mega|Fly|Ride"] = 240.66}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 9.3, ["Fly"] = 47.16, ["Ride"] = 23.85, ["Fly|Ride"] = 48.64, ["Neon"] = 41.06, ["Neon|Fly"] = 189.38, ["Neon|Ride"] = 55.74, ["Neon|Fly|Ride"] = 92.26, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 328.11}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 20.11, ["Ride"] = 14.8, ["Fly|Ride"] = 32.04, ["Neon"] = 8.76, ["Neon|Fly"] = 126.37, ["Neon|Ride"] = 23.5, ["Neon|Fly|Ride"] = 68.4, ["Mega"] = 65.01, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 84.96, ["Mega|Fly|Ride"] = 177.09}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 26.16, ["Ride"] = 72.19, ["Fly|Ride"] = 275.5, ["Neon"] = 198.61, ["Neon|Ride"] = 263.68, ["Mega"] = 918.75, ["Mega|Fly|Ride"] = 1170.19}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 19.67, ["Fly|Ride"] = 64.05, ["Neon"] = 7.01, ["Neon|Fly"] = 141.75, ["Neon|Ride"] = 30.42, ["Neon|Fly|Ride"] = 119.43, ["Mega"] = 52.5, ["Mega|Ride"] = 116.55, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 3.78, ["Fly"] = 124.89, ["Ride"] = 19.57, ["Fly|Ride"] = 53.67, ["Neon"] = 8.71, ["Neon|Ride"] = 41.89, ["Neon|Fly|Ride"] = 110.41, ["Mega"] = 114.19, ["Mega|Ride"] = 198.59, ["Mega|Fly|Ride"] = 479.51}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly|Ride"] = 59.07, ["Neon"] = 36.19, ["Mega"] = 93.5, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 375.38}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 42, ["Ride"] = 15.72, ["Fly|Ride"] = 49.86, ["Neon"] = 3.94, ["Neon|Fly"] = 100.68, ["Neon|Ride"] = 24.26, ["Neon|Fly|Ride"] = 99.42, ["Mega"] = 42.84, ["Mega|Fly"] = 229.68, ["Mega|Ride"] = 62.08}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 14.43, ["Fly"] = 17.31, ["Ride"] = 16.88, ["Fly|Ride"] = 34.1, ["Neon"] = 315.29, ["Neon|Ride"] = 80.85, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 825.43, ["Mega|Ride"] = 407.61, ["Mega|Fly|Ride"] = 389.58}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 783.57, ["Ride"] = 787.5, ["Fly|Ride"] = 926.52, ["Neon"] = 1729.93, ["Neon|Ride"] = 1837.5, ["Neon|Fly|Ride"] = 2163, ["Mega"] = 7738.27, ["Mega|Fly|Ride"] = 7429.66}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 15.37, ["Fly|Ride"] = 33.29, ["Neon"] = 3.84, ["Neon|Ride"] = 16.69, ["Neon|Fly|Ride"] = 51.89, ["Mega"] = 42, ["Mega|Ride"] = 57.66, ["Mega|Fly|Ride"] = 136.43}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 6.19, ["Ride"] = 36.72, ["Fly|Ride"] = 194.85, ["Neon"] = 39.36, ["Neon|Ride"] = 46.66, ["Neon|Fly|Ride"] = 196.87, ["Mega"] = 366.18, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 481.91}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 45.73, ["Ride"] = 59.03, ["Fly|Ride"] = 110.25, ["Neon|Ride"] = 389.82, ["Neon|Fly|Ride"] = 498.75, ["Mega"] = 3209.18, ["Mega|Fly|Ride"] = 1335.29}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 27.83, ["Ride"] = 32.71, ["Fly|Ride"] = 104.89, ["Neon"] = 183.75, ["Neon|Ride"] = 206.37, ["Neon|Fly|Ride"] = 304.39, ["Mega"] = 963.69, ["Mega|Ride"] = 896.44, ["Mega|Fly|Ride"] = 816.38}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 6.68, ["Ride"] = 26.22, ["Fly|Ride"] = 139.71, ["Neon"] = 58.97, ["Neon|Ride"] = 76.37, ["Neon|Fly|Ride"] = 121.42, ["Mega"] = 285.87, ["Mega|Fly|Ride"] = 460.69}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 25.94, ["Ride"] = 56.55, ["Neon"] = 275.5, ["Neon|Ride"] = 358.19, ["Mega"] = 387.82, ["Mega|Fly"] = 506.01, ["Mega|Ride"] = 367.4, ["Mega|Fly|Ride"] = 511.84}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 65.63, ["Fly"] = 126.88, ["Neon"] = 275.5, ["Neon|Ride"] = 138.27, ["Neon|Fly|Ride"] = 525, ["Mega"] = 923.9, ["Mega|Ride"] = 728.44, ["Mega|Fly|Ride"] = 563.21}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 15.44}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 3.69, ["Fly"] = 131248.69, ["Ride"] = 16.62, ["Fly|Ride"] = 58.8, ["Neon"] = 31.11, ["Neon|Ride"] = 68.85, ["Neon|Fly|Ride"] = 179.54, ["Mega"] = 190.32, ["Mega|Fly"] = 463.87, ["Mega|Ride"] = 214.66, ["Mega|Fly|Ride"] = 466.55}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.18, ["Ride"] = 46.85, ["Neon"] = 11.7, ["Neon|Fly|Ride"] = 206.37, ["Mega"] = 140.3}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 41.28, ["Fly"] = 62.99, ["Ride"] = 55.74, ["Fly|Ride"] = 95.45, ["Neon"] = 274.18, ["Neon|Ride"] = 189, ["Neon|Fly|Ride"] = 932.73, ["Mega|Ride"] = 706.19, ["Mega|Fly|Ride"] = 701.7}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.5, ["Fly"] = 17.56, ["Ride"] = 14.96, ["Fly|Ride"] = 36.95, ["Neon"] = 25.31, ["Neon|Fly"] = 69.14, ["Neon|Ride"] = 31.24, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 198.19, ["Mega|Fly"] = 411.7, ["Mega|Ride"] = 195.46, ["Mega|Fly|Ride"] = 255.05}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 4.17, ["Fly"] = 146.5, ["Ride"] = 27.42, ["Fly|Ride"] = 55.7, ["Neon"] = 14.43, ["Neon|Ride"] = 42.26, ["Neon|Fly|Ride"] = 128.41, ["Mega"] = 129.94, ["Mega|Ride"] = 169.25, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 6.57, ["Mega"] = 45.94, ["Mega|Ride"] = 192.98}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 28.61, ["Fly"] = 77.16, ["Ride"] = 52.5, ["Fly|Ride"] = 89.15, ["Neon"] = 131.15, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 308.12, ["Mega|Ride"] = 13759.32}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 38.96, ["Fly|Ride"] = 65.63, ["Neon"] = 5.81, ["Neon|Fly"] = 291.38, ["Neon|Ride"] = 32, ["Mega"] = 74.7, ["Mega|Ride"] = 118.12, ["Mega|Fly|Ride"] = 462.2}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 10.4, ["Ride"] = 78.19, ["Fly|Ride"] = 274.46, ["Neon"] = 105.02, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 374.07, ["Mega|Ride"] = 444.94, ["Mega|Fly|Ride"] = 551.06}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 19.62, ["Ride"] = 14.56, ["Fly|Ride"] = 40.63, ["Neon"] = 18.59, ["Neon|Ride"] = 35.6, ["Neon|Fly|Ride"] = 75.87, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 249.61}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 4.15, ["Fly"] = 52.49, ["Ride"] = 19.3, ["Fly|Ride"] = 71.36, ["Neon"] = 26.25, ["Neon|Ride"] = 45.94, ["Mega"] = 385.9, ["Mega|Ride"] = 399.35, ["Mega|Fly|Ride"] = 412.77}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 3.93, ["Ride"] = 64.84, ["Neon"] = 78, ["Neon|Ride"] = 157.55, ["Mega"] = 465.14, ["Mega|Ride"] = 943.78, ["Mega|Fly|Ride"] = 545.74}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 39.37, ["Ride"] = 263.82, ["Neon"] = 216.57, ["Neon|Fly|Ride"] = 544.49, ["Mega|Ride"] = 1651.05, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 15.61, ["Ride"] = 65.54, ["Neon"] = 99.02, ["Neon|Ride"] = 262.5, ["Mega"] = 452.91, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 12.49, ["Ride"] = 125.9, ["Neon"] = 162.75, ["Neon|Fly"] = 206.37, ["Mega|Ride"] = 824.51}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 17.16, ["Ride"] = 105, ["Fly|Ride"] = 367.46, ["Neon"] = 145.53, ["Neon|Ride"] = 722.25, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 616.88, ["Mega|Fly"] = 2063.56, ["Mega|Fly|Ride"] = 1091.82}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 2.46, ["Neon"] = 13.07, ["Mega"] = 131.25, ["Mega|Fly|Ride"] = 311.42}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 43.32, ["Ride"] = 13.91, ["Fly|Ride"] = 41.28, ["Neon"] = 3.08, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 93.19, ["Mega"] = 45.94, ["Mega|Ride"] = 80.14, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 3.94, ["Fly"] = 50.5, ["Ride"] = 288.65, ["Fly|Ride"] = 65.63, ["Neon"] = 15.65, ["Neon|Ride"] = 41.55, ["Neon|Fly|Ride"] = 163.96, ["Mega"] = 102.59, ["Mega|Ride"] = 156.31, ["Mega|Fly|Ride"] = 237.36}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 20.65, ["Ride"] = 15.46, ["Fly|Ride"] = 56.16, ["Neon"] = 5.1, ["Neon|Ride"] = 21.95, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 55.11, ["Mega|Fly"] = 165.1, ["Mega|Ride"] = 76.56, ["Mega|Fly|Ride"] = 275.54}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.1, ["Fly"] = 65.62, ["Ride"] = 26.25, ["Fly|Ride"] = 118.13, ["Neon"] = 24.77, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 255.89, ["Mega"] = 251.2, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 466.55}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.94, ["Fly"] = 65.63, ["Ride"] = 19.69, ["Fly|Ride"] = 103.69, ["Neon"] = 26.15, ["Neon|Fly"] = 466.69, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 302.45, ["Mega|Ride"] = 287.46, ["Mega|Fly|Ride"] = 1238.29}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 2.14, ["Fly"] = 131.25, ["Ride"] = 24.77, ["Fly|Ride"] = 60.4, ["Neon"] = 16.43, ["Neon|Fly"] = 111.54, ["Neon|Ride"] = 28.25, ["Neon|Fly|Ride"] = 78.66, ["Mega"] = 227.75, ["Mega|Ride"] = 313.86, ["Mega|Fly|Ride"] = 392.4}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 3.9, ["Fly"] = 33.72, ["Ride"] = 18.58, ["Fly|Ride"] = 51.69, ["Neon"] = 17.73, ["Neon|Ride"] = 68.08, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 252.82, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 254.15}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 4.32, ["Fly"] = 57.65, ["Ride"] = 42.95, ["Fly|Ride"] = 131.25, ["Neon"] = 14.32, ["Neon|Fly"] = 418.76, ["Neon|Ride"] = 64.1, ["Neon|Fly|Ride"] = 128.44, ["Mega"] = 97.84, ["Mega|Fly"] = 156.24, ["Mega|Ride"] = 132.57, ["Mega|Fly|Ride"] = 259.94}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 18.5, ["Fly"] = 206.35, ["Ride"] = 99.32, ["Fly|Ride"] = 222.88, ["Neon"] = 69.14, ["Neon|Fly"] = 433.13, ["Neon|Ride"] = 313.69, ["Neon|Fly|Ride"] = 518.84, ["Mega"] = 511.88, ["Mega|Ride"] = 637.72, ["Mega|Fly|Ride"] = 675.94}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 51.17, ["Fly"] = 164.07, ["Ride"] = 89.08, ["Fly|Ride"] = 480.68, ["Neon"] = 252.87, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 478.04, ["Mega"] = 1512.58, ["Mega|Ride"] = 1061.82, ["Mega|Fly|Ride"] = 1221.94}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 50.96, ["Ride"] = 20.65, ["Fly|Ride"] = 65.54, ["Neon"] = 2.25, ["Neon|Ride"] = 23.48, ["Mega"] = 39.38, ["Mega|Ride"] = 71.04, ["Mega|Fly|Ride"] = 148.32}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 63.95, ["Neon"] = 156.35, ["Mega|Fly|Ride"] = 963.81}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 39.38, ["Fly"] = 105, ["Ride"] = 91.89, ["Neon"] = 403.44, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 824.39, ["Mega"] = 1691.08, ["Mega|Ride"] = 1238.29, ["Mega|Fly|Ride"] = 1857.42}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 6.2, ["Fly"] = 190.32, ["Ride"] = 35.6, ["Fly|Ride"] = 133.87, ["Neon"] = 36.62, ["Neon|Ride"] = 82.56, ["Mega"] = 144.38, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 388.5}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Fly|Ride"] = 141.65, ["Neon"] = 11.46, ["Neon|Ride"] = 65.63, ["Mega"] = 64.66, ["Mega|Fly"] = 341.25, ["Mega|Ride"] = 129.29, ["Mega|Fly|Ride"] = 351.05}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 21.19, ["Ride"] = 20.86, ["Fly|Ride"] = 37.69, ["Neon"] = 11.51, ["Neon|Ride"] = 35.1, ["Neon|Fly|Ride"] = 112.77, ["Mega"] = 209.4, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 205.35, ["Mega|Fly|Ride"] = 160.13}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 16.75, ["Ride"] = 14.35, ["Fly|Ride"] = 40.85, ["Neon"] = 2.49, ["Neon|Fly"] = 17.77, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 36.75, ["Mega"] = 26.25, ["Mega|Ride"] = 69.55}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 14.87, ["Fly|Ride"] = 32.61, ["Neon"] = 3.94, ["Neon|Ride"] = 27.43, ["Neon|Fly|Ride"] = 103.19, ["Mega"] = 72.24, ["Mega|Ride"] = 56.35, ["Mega|Fly|Ride"] = 177.11}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.48, ["Neon"] = 2.1, ["Neon|Ride"] = 145.08, ["Mega"] = 12.92, ["Mega|Ride"] = 101.07, ["Mega|Fly|Ride"] = 275.54}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 6.26, ["Ride"] = 104.98, ["Neon"] = 30.35, ["Neon|Ride"] = 237.56, ["Neon|Fly|Ride"] = 619.07, ["Mega"] = 233.19, ["Mega|Ride"] = 269.48, ["Mega|Fly|Ride"] = 311.42}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 4.85, ["Ride"] = 31.61, ["Fly|Ride"] = 202.98, ["Neon"] = 49.88, ["Neon|Ride"] = 203.44, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 294.06, ["Mega|Ride"] = 412.77, ["Mega|Fly|Ride"] = 468.49}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 7.1, ["Fly"] = 25.8, ["Ride"] = 16.02, ["Fly|Ride"] = 37.95, ["Neon"] = 37.97, ["Neon|Fly"] = 69.14, ["Neon|Ride"] = 35.01, ["Neon|Fly|Ride"] = 82.37, ["Mega|Ride"] = 272.94, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 61.69, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 446.15, ["Mega|Fly|Ride"] = 1560.57}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 52.5, ["Fly"] = 82.67, ["Ride"] = 31.4, ["Neon"] = 78.75, ["Neon|Fly|Ride"] = 630, ["Mega"] = 622.61, ["Mega|Ride"] = 830.82}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 39.37, ["Ride"] = 15.64, ["Fly|Ride"] = 35.44, ["Neon"] = 2.62, ["Neon|Fly"] = 41.28, ["Neon|Ride"] = 18.08, ["Neon|Fly|Ride"] = 61.92, ["Mega|Ride"] = 97, ["Mega|Fly|Ride"] = 188.97}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 15.12, ["Ride"] = 12.71, ["Fly|Ride"] = 27.2, ["Neon"] = 3.82, ["Neon|Fly"] = 26.99, ["Neon|Ride"] = 18.1, ["Neon|Fly|Ride"] = 46.09, ["Mega"] = 44.63, ["Mega|Fly"] = 82.56, ["Mega|Ride"] = 56.32, ["Mega|Fly|Ride"] = 114.35}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 428.92, ["Ride"] = 534.18, ["Fly|Ride"] = 551.25, ["Neon|Fly|Ride"] = 1884.09}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 7.82, ["Ride"] = 56.05, ["Fly|Ride"] = 65.63, ["Neon"] = 30.19, ["Neon|Ride"] = 80.31, ["Mega"] = 358.03, ["Mega|Ride"] = 674.88, ["Mega|Fly|Ride"] = 275172.55}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 14.78, ["Ride"] = 15.43, ["Fly|Ride"] = 26.99, ["Neon"] = 3.82, ["Neon|Fly"] = 23.35, ["Neon|Ride"] = 15.49, ["Neon|Fly|Ride"] = 36.77, ["Mega"] = 138.27, ["Mega|Ride"] = 72.35, ["Mega|Fly|Ride"] = 105.44}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 49.76, ["Ride"] = 101.13, ["Fly|Ride"] = 523.42, ["Neon"] = 261.09, ["Neon|Ride"] = 264.5, ["Neon|Fly|Ride"] = 1134.96, ["Mega"] = 719.25, ["Mega|Ride"] = 963.81, ["Mega|Fly|Ride"] = 878.35}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 37.16, ["Ride"] = 17.03, ["Fly|Ride"] = 35.44, ["Neon"] = 10.5, ["Neon|Fly"] = 52.63, ["Neon|Ride"] = 19.59, ["Neon|Fly|Ride"] = 70.85, ["Mega"] = 91.77, ["Mega|Fly"] = 206.37, ["Mega|Ride"] = 129.74, ["Mega|Fly|Ride"] = 206.07}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 69.57, ["Ride"] = 43.32, ["Neon"] = 2.1, ["Neon|Ride"] = 31.05, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 20.9, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 190.88}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 37.17, ["Fly"] = 108.03, ["Ride"] = 64.97, ["Fly|Ride"] = 194.86, ["Neon"] = 105, ["Neon|Ride"] = 191.26, ["Neon|Fly|Ride"] = 446.25, ["Mega"] = 825.43, ["Mega|Ride"] = 708.75, ["Mega|Fly|Ride"] = 1089.37}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 23.05, ["Fly|Ride"] = 52.5, ["Neon"] = 6.82, ["Neon|Ride"] = 39.99, ["Mega"] = 47.87, ["Mega|Ride"] = 191.02, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 47.48, ["Ride"] = 69.44, ["Fly|Ride"] = 138.27, ["Neon"] = 330.18, ["Neon|Ride"] = 256.48, ["Neon|Fly|Ride"] = 359.63, ["Mega"] = 1630.2, ["Mega|Ride"] = 1651.05, ["Mega|Fly|Ride"] = 1485.94}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 2.1, ["Ride"] = 183.74, ["Neon"] = 19.57, ["Neon|Ride"] = 46.68, ["Neon|Fly|Ride"] = 152.73, ["Mega"] = 136.5, ["Mega|Ride"] = 603.75}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.5, ["Fly"] = 69.14, ["Ride"] = 72.74, ["Fly|Ride"] = 69.14, ["Neon"] = 6.89, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 183.75, ["Mega|Ride"] = 728.44, ["Mega|Fly|Ride"] = 551.06}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 36.16, ["Ride"] = 65.63, ["Fly|Ride"] = 515.9, ["Mega|Ride"] = 2598.75, ["Mega|Fly|Ride"] = 1645.89}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 281.75, ["Ride"] = 19.85, ["Fly|Ride"] = 52.5, ["Neon"] = 5.29, ["Neon|Ride"] = 35.07, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 59.85, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 86.23, ["Mega|Fly|Ride"] = 181.92}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 14.36, ["Ride"] = 12.48, ["Fly|Ride"] = 101.82, ["Neon"] = 13.13, ["Neon|Fly"] = 47.77, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 51.6, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 8.33, ["Fly"] = 58.49, ["Ride"] = 32.69, ["Fly|Ride"] = 75.78, ["Neon"] = 81.78, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 148.09, ["Mega"] = 434.44, ["Mega|Ride"] = 404.73, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 69.61, ["Fly"] = 57.11, ["Ride"] = 40.3, ["Fly|Ride"] = 71.31, ["Neon"] = 96.99, ["Neon|Fly"] = 138.27, ["Neon|Ride"] = 82.56, ["Neon|Fly|Ride"] = 181.02, ["Mega"] = 916.05, ["Mega|Ride"] = 397.84, ["Mega|Fly|Ride"] = 472.75}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 23.07, ["Fly"] = 51.19, ["Ride"] = 26.17, ["Fly|Ride"] = 64.04, ["Neon"] = 56.03, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 150.66, ["Mega"] = 548.03, ["Mega|Ride"] = 298.86, ["Mega|Fly|Ride"] = 412.77}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 57.96, ["Fly"] = 139.36, ["Ride"] = 109.69, ["Fly|Ride"] = 156.35, ["Neon"] = 359.63, ["Neon|Ride"] = 523.13, ["Neon|Fly|Ride"] = 705.74, ["Mega|Ride"] = 1513.8, ["Mega|Fly|Ride"] = 1299.38}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 3.44, ["Ride"] = 55.74, ["Neon"] = 24.03, ["Neon|Ride"] = 515.9, ["Neon|Fly|Ride"] = 305.82, ["Mega"] = 223.13, ["Mega|Fly|Ride"] = 383.88}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 4.6, ["Ride"] = 27.08, ["Fly|Ride"] = 78.74, ["Neon"] = 26.84, ["Neon|Ride"] = 39.8, ["Neon|Fly|Ride"] = 123.83, ["Mega"] = 206.37, ["Mega|Ride"] = 183.74, ["Mega|Fly|Ride"] = 246.62}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 9.86, ["Ride"] = 24.02, ["Fly|Ride"] = 108.73, ["Neon"] = 47.04, ["Neon|Ride"] = 138.05, ["Neon|Fly|Ride"] = 237.04, ["Mega"] = 455.02, ["Mega|Ride"] = 639.19, ["Mega|Fly|Ride"] = 688.28}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.23, ["Ride"] = 12.55, ["Fly|Ride"] = 20.96, ["Neon"] = 2.1, ["Neon|Fly"] = 19.69, ["Neon|Ride"] = 13.31, ["Neon|Fly|Ride"] = 36.17, ["Mega"] = 14.6, ["Mega|Ride"] = 27.26, ["Mega|Fly|Ride"] = 93.82}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 50.67, ["Ride"] = 78.75, ["Fly|Ride"] = 275.5, ["Neon"] = 408.35, ["Neon|Fly"] = 2339.04, ["Neon|Ride"] = 291.06, ["Neon|Fly|Ride"] = 488.15, ["Mega"] = 1031.79, ["Mega|Ride"] = 945, ["Mega|Fly|Ride"] = 866.25}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 20.65, ["Fly|Ride"] = 35.1, ["Neon"] = 3.18, ["Neon|Ride"] = 27.44, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 261.05, ["Mega|Ride"] = 78.66, ["Mega|Fly|Ride"] = 399.35}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 27.88, ["Ride"] = 15.73, ["Fly|Ride"] = 51.7, ["Neon"] = 26.17, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 121.36, ["Mega|Ride"] = 135.19, ["Mega|Fly|Ride"] = 236.15}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 69.2, ["Fly"] = 157.5, ["Ride"] = 110.41, ["Fly|Ride"] = 258.56, ["Neon"] = 360.93, ["Neon|Ride"] = 675.83, ["Neon|Fly|Ride"] = 1238.13, ["Mega"] = 1238.13, ["Mega|Ride"] = 1758.75, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 25.25, ["Neon"] = 6.18, ["Neon|Ride"] = 63.98, ["Mega"] = 63.95, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 234.94}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 7.88}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 31.91, ["Neon"] = 6.57, ["Neon|Ride"] = 41.28, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 40.93, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 144.38, ["Ride"] = 217.88, ["Fly|Ride"] = 296.36, ["Neon"] = 701.61, ["Neon|Ride"] = 684.86, ["Neon|Fly|Ride"] = 917.44, ["Mega"] = 3301.68, ["Mega|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 2835}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 2.48, ["Ride"] = 38.07, ["Neon"] = 19.57, ["Neon|Fly"] = 138.27, ["Neon|Ride"] = 64.32, ["Mega"] = 178.38, ["Mega|Ride"] = 202.85, ["Mega|Fly|Ride"] = 631.76}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.16, ["Fly"] = 26.25, ["Ride"] = 41.79, ["Neon"] = 3.71, ["Neon|Ride"] = 19.6, ["Neon|Fly|Ride"] = 275.5, ["Mega"] = 28.61, ["Mega|Ride"] = 101.14, ["Mega|Fly|Ride"] = 139.71}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 10.38, ["Ride"] = 18.8, ["Neon"] = 48.47, ["Neon|Ride"] = 64.05, ["Neon|Fly|Ride"] = 156.24, ["Mega"] = 412.72, ["Mega|Ride"] = 551.06, ["Mega|Fly|Ride"] = 614.76}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 7.49, ["Fly"] = 26.25, ["Ride"] = 20.99, ["Fly|Ride"] = 54.86, ["Neon"] = 99, ["Neon|Ride"] = 131.14, ["Neon|Fly|Ride"] = 305.82, ["Mega"] = 597.19, ["Mega|Ride"] = 555.19, ["Mega|Fly|Ride"] = 481.69}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 16.59, ["Ride"] = 68.16, ["Fly|Ride"] = 125.9, ["Neon"] = 145.68, ["Neon|Ride"] = 168.04, ["Neon|Fly|Ride"] = 1575, ["Mega"] = 560.44, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 120.16, ["Fly"] = 279.46, ["Ride"] = 203.34, ["Fly|Ride"] = 228.38, ["Neon"] = 593.14, ["Neon|Ride"] = 590, ["Neon|Fly|Ride"] = 636.26, ["Mega|Fly|Ride"] = 2084.44}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 104.96, ["Ride"] = 103.19, ["Fly|Ride"] = 82.69, ["Neon"] = 471.15, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 489.07}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.1, ["Fly"] = 131.23, ["Ride"] = 19.68, ["Fly|Ride"] = 131.25, ["Neon"] = 15.62, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 137.82, ["Mega|Fly|Ride"] = 297.94}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 69.14, ["Fly"] = 233.35, ["Fly|Ride"] = 177.48, ["Neon"] = 145.16, ["Neon|Ride"] = 80.07, ["Mega"] = 262.5, ["Mega|Ride"] = 433.13, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 43.5, ["Fly"] = 110.4, ["Ride"] = 74.96, ["Fly|Ride"] = 157.5, ["Neon"] = 242.68, ["Neon|Ride"] = 271.37, ["Neon|Fly|Ride"] = 305.74, ["Mega"] = 1088.97, ["Mega|Ride"] = 1165.5, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 12.29, ["Ride"] = 68.08, ["Neon"] = 104.99, ["Neon|Ride"] = 550.98, ["Neon|Fly|Ride"] = 455.02, ["Mega"] = 683.71, ["Mega|Ride"] = 609.87}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 327.39, ["Ride"] = 459.38, ["Neon|Ride"] = 3109.46, ["Neon|Fly|Ride"] = 1376.82}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 31.37, ["Ride"] = 32.45, ["Fly|Ride"] = 74.92, ["Neon"] = 224.26, ["Neon|Ride"] = 227.39, ["Neon|Fly|Ride"] = 304.39, ["Mega"] = 1034.25, ["Mega|Ride"] = 921.38, ["Mega|Fly|Ride"] = 1030.87}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 38.32, ["Ride"] = 11.82, ["Fly|Ride"] = 119.69, ["Neon"] = 2.1, ["Neon|Ride"] = 14.39, ["Neon|Fly|Ride"] = 61.92, ["Mega"] = 18.26, ["Mega|Fly"] = 107.33, ["Mega|Ride"] = 34.44, ["Mega|Fly|Ride"] = 104.92}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 7.88, ["Neon"] = 19.42, ["Neon|Ride"] = 54.29, ["Neon|Fly|Ride"] = 260.02, ["Mega"] = 145.21, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 412.77}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 3.84, ["Ride"] = 29.93, ["Fly|Ride"] = 60.52, ["Neon"] = 12.48, ["Neon|Ride"] = 83.05, ["Neon|Fly|Ride"] = 963.69, ["Mega"] = 108.05, ["Mega|Fly"] = 498.61, ["Mega|Ride"] = 275.54, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 406.77, ["Ride"] = 439.69, ["Fly|Ride"] = 525, ["Neon"] = 1424.39, ["Neon|Ride"] = 1670.69, ["Neon|Fly|Ride"] = 1539.76, ["Mega|Fly|Ride"] = 5026.88}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 3.59, ["Fly"] = 19.69, ["Ride"] = 17.06, ["Fly|Ride"] = 42, ["Neon"] = 39.29, ["Neon|Ride"] = 69.14, ["Neon|Fly|Ride"] = 104.62, ["Mega"] = 168, ["Mega|Ride"] = 275.54, ["Mega|Fly|Ride"] = 389.58}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 5.65, ["Fly"] = 22.31, ["Ride"] = 16.7, ["Fly|Ride"] = 32.82, ["Neon"] = 26.84, ["Neon|Fly"] = 156.45, ["Neon|Ride"] = 15.49, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 688.28, ["Mega|Fly|Ride"] = 286.38}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 8.27, ["Fly"] = 44.94, ["Ride"] = 28.88, ["Fly|Ride"] = 78.75, ["Neon"] = 10.63, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 54.94, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 131.25, ["Mega|Ride"] = 268.3, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 116.71, ["Fly"] = 41.91, ["Ride"] = 26.25, ["Fly|Ride"] = 57.46, ["Neon"] = 220.29, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 308.52, ["Mega"] = 1312.5, ["Mega|Ride"] = 824.51, ["Mega|Fly|Ride"] = 660.19}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 31.52, ["Ride"] = 15.75, ["Fly|Ride"] = 50.19, ["Neon"] = 11.7, ["Neon|Ride"] = 114.19, ["Neon|Fly|Ride"] = 210, ["Mega"] = 162.08, ["Mega|Ride"] = 457.79}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 6.57, ["Fly"] = 64.26, ["Ride"] = 24.72, ["Fly|Ride"] = 91.88, ["Neon"] = 185.72, ["Neon|Ride"] = 209.99, ["Mega"] = 1650.85, ["Mega|Ride"] = 742.98, ["Mega|Fly|Ride"] = 846.57}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 19.57, ["Neon"] = 4.75, ["Neon|Ride"] = 28.88, ["Mega"] = 39.38, ["Mega|Ride"] = 110.9, ["Mega|Fly|Ride"] = 179.57}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 56.54, ["Neon"] = 67.29}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 10.47, ["Neon"] = 78.66, ["Neon|Ride"] = 466.69, ["Neon|Fly|Ride"] = 412.72, ["Mega"] = 275.5, ["Mega|Ride"] = 559.01, ["Mega|Fly|Ride"] = 509.25}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 9.75, ["Fly"] = 28.69, ["Ride"] = 23.9, ["Fly|Ride"] = 72.1, ["Neon"] = 52.39, ["Neon|Fly"] = 68.11, ["Neon|Ride"] = 54.8, ["Neon|Fly|Ride"] = 118.22, ["Mega"] = 579.87, ["Mega|Ride"] = 313.74, ["Mega|Fly|Ride"] = 344.9}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 307.28, ["Fly"] = 481.79, ["Ride"] = 334.69, ["Fly|Ride"] = 469.98, ["Neon"] = 1640.63, ["Neon|Ride"] = 1303.12, ["Neon|Fly|Ride"] = 1470, ["Mega|Fly|Ride"] = 4181.3}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Fly"] = 32, ["Ride"] = 15.63, ["Fly|Ride"] = 26.25, ["Neon"] = 12.49, ["Neon|Fly"] = 78.19, ["Neon|Ride"] = 32.28, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 213.38, ["Mega|Ride"] = 196.77}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 3.6, ["Fly"] = 110.41, ["Ride"] = 19.69, ["Fly|Ride"] = 110.41, ["Neon"] = 42.94, ["Neon|Ride"] = 154.82, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 196.88, ["Mega|Fly"] = 688.2, ["Mega|Ride"] = 389.82}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 31.43, ["Ride"] = 117.92, ["Fly|Ride"] = 138.27, ["Neon"] = 108.13, ["Neon|Ride"] = 129.93, ["Neon|Fly|Ride"] = 404.58, ["Mega"] = 352.96, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 538.01}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 125.11, ["Fly|Ride"] = 445.73, ["Neon"] = 320.25, ["Neon|Ride"] = 1444.49, ["Neon|Fly|Ride"] = 592.26, ["Mega"] = 2367.47, ["Mega|Ride"] = 7714.88, ["Mega|Fly|Ride"] = 3611.66}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 14.95, ["Fly"] = 121.76, ["Ride"] = 69.14, ["Fly|Ride"] = 123.78, ["Neon"] = 72.35, ["Neon|Ride"] = 116.45, ["Neon|Fly|Ride"] = 160.13, ["Mega"] = 347.81, ["Mega|Ride"] = 514.94, ["Mega|Fly|Ride"] = 432.2}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.63, ["Fly"] = 28.87, ["Ride"] = 19.58, ["Fly|Ride"] = 52.5, ["Neon"] = 11.71, ["Neon|Ride"] = 33.53, ["Neon|Fly|Ride"] = 69.47, ["Mega"] = 32.82, ["Mega|Ride"] = 142.31, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 3.6, ["Ride"] = 30.19, ["Neon"] = 23.1, ["Neon|Ride"] = 92.88, ["Neon|Fly|Ride"] = 172.81, ["Mega"] = 169.32, ["Mega|Ride"] = 160.13, ["Mega|Fly|Ride"] = 306.99}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 54.94, ["Fly"] = 196.88, ["Ride"] = 99.73, ["Fly|Ride"] = 190.56, ["Neon"] = 101.07, ["Neon|Ride"] = 169.29, ["Neon|Fly|Ride"] = 349.55, ["Mega"] = 511.88, ["Mega|Ride"] = 506.18, ["Mega|Fly|Ride"] = 612.94}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 3.93, ["Ride"] = 131.24, ["Neon"] = 11.1, ["Neon|Ride"] = 206.37, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 45.94, ["Mega|Ride"] = 160.4, ["Mega|Fly|Ride"] = 404.52}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 22.19, ["Neon"] = 69.14, ["Neon|Ride"] = 401.03, ["Mega"] = 495.27, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 917.44, ["Fly"] = 2063.56, ["Ride"] = 984.27, ["Fly|Ride"] = 1086.64, ["Neon"] = 3297.55, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2888.61, ["Mega|Fly|Ride"] = 10938.12}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 17.64, ["Fly"] = 106.47, ["Ride"] = 55.74, ["Fly|Ride"] = 192.95, ["Neon"] = 202.13, ["Neon|Fly"] = 687.18, ["Neon|Ride"] = 157.5, ["Mega"] = 411.7, ["Mega|Fly|Ride"] = 687.26}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 5.25, ["Fly"] = 49.34, ["Ride"] = 21.42, ["Fly|Ride"] = 65.63, ["Neon"] = 10.33, ["Neon|Ride"] = 36.74, ["Neon|Fly|Ride"] = 99.21, ["Mega"] = 72.35, ["Mega|Ride"] = 102.15, ["Mega|Fly|Ride"] = 220.89}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 8.99, ["Ride"] = 47.79, ["Fly|Ride"] = 138.27, ["Neon"] = 209.46, ["Mega|Ride"] = 421.92, ["Mega|Fly|Ride"] = 924}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 18.67, ["Fly|Ride"] = 59.85, ["Neon"] = 2.1, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 91.66, ["Mega"] = 15.73, ["Mega|Fly"] = 123.83, ["Mega|Ride"] = 36.87, ["Mega|Fly|Ride"] = 149.51}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 59.68, ["Ride"] = 69.14, ["Fly|Ride"] = 236.25, ["Neon"] = 236.25, ["Neon|Ride"] = 297.57, ["Neon|Fly|Ride"] = 402.01, ["Mega"] = 1062.09, ["Mega|Ride"] = 914.76, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 6.39, ["Ride"] = 31.92, ["Fly|Ride"] = 159.43, ["Neon"] = 60.74, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 257.67, ["Mega"] = 682.5, ["Mega|Ride"] = 472.5, ["Mega|Fly|Ride"] = 556.38}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2.1, ["Ride"] = 26.84, ["Neon"] = 13.13, ["Neon|Ride"] = 32.82, ["Mega"] = 91.88, ["Mega|Ride"] = 157.5}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 22.41, ["Fly"] = 52.5, ["Ride"] = 32.51, ["Fly|Ride"] = 115.17, ["Neon"] = 96.99, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 139.72, ["Mega"] = 1039.49, ["Mega|Ride"] = 455.09, ["Mega|Fly|Ride"] = 688.28}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 7.23, ["Ride"] = 30.21, ["Fly|Ride"] = 89.78, ["Neon"] = 44.24, ["Neon|Ride"] = 203.18, ["Neon|Fly|Ride"] = 315, ["Mega"] = 475.26, ["Mega|Ride"] = 518.22, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 41.28, ["Ride"] = 236.23, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 308.52, ["Mega"] = 2093.44, ["Mega|Ride"] = 1651.05, ["Mega|Fly|Ride"] = 1645.89}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 4.18, ["Ride"] = 45.87, ["Neon"] = 140.05, ["Neon|Ride"] = 88.75, ["Neon|Fly|Ride"] = 169.32, ["Mega"] = 101.07, ["Mega|Ride"] = 210.53, ["Mega|Fly|Ride"] = 256.67}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 6.34, ["Ride"] = 19.69, ["Fly|Ride"] = 78.75, ["Neon"] = 96.99, ["Neon|Ride"] = 58.24, ["Neon|Fly|Ride"] = 136.2, ["Mega"] = 350.44, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 551.06}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 140.74, ["Fly"] = 382.05, ["Ride"] = 160.12, ["Fly|Ride"] = 207.9, ["Neon"] = 600.9, ["Neon|Ride"] = 557.82, ["Neon|Fly|Ride"] = 643.13, ["Mega"] = 2327.07, ["Mega|Fly|Ride"] = 1945.13}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 36.75, ["Ride"] = 16.54, ["Fly|Ride"] = 34.55, ["Neon"] = 10.69, ["Neon|Fly"] = 57.53, ["Neon|Ride"] = 33.29, ["Neon|Fly|Ride"] = 68.92, ["Mega"] = 122.8, ["Mega|Ride"] = 233.28, ["Mega|Fly|Ride"] = 559.85}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 11.03, ["Fly"] = 195.43, ["Ride"] = 34.9, ["Fly|Ride"] = 68.25, ["Neon"] = 79.64, ["Neon|Ride"] = 79.52, ["Neon|Fly|Ride"] = 220.81, ["Mega"] = 417.86, ["Mega|Ride"] = 458.96, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 18.89, ["Ride"] = 14.69, ["Fly|Ride"] = 52.41, ["Neon"] = 2.1, ["Neon|Fly"] = 26.17, ["Neon|Ride"] = 13.79, ["Neon|Fly|Ride"] = 39.41, ["Mega"] = 15.75, ["Mega|Ride"] = 32.23, ["Mega|Fly|Ride"] = 72.18}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 55.74, ["Fly|Ride"] = 39.38, ["Neon"] = 2.35, ["Neon|Ride"] = 39.22, ["Neon|Fly|Ride"] = 127.96, ["Mega"] = 17.81, ["Mega|Fly"] = 104.98, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 159.95}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 3.92, ["Fly"] = 35.1, ["Ride"] = 19.46, ["Fly|Ride"] = 99.86, ["Neon"] = 26.17, ["Neon|Ride"] = 82.56, ["Mega"] = 156.24, ["Mega|Ride"] = 265.95}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 26.25, ["Ride"] = 52.46, ["Fly|Ride"] = 131.25, ["Neon"] = 118.02, ["Neon|Ride"] = 350.01, ["Neon|Fly|Ride"] = 433.13, ["Mega"] = 423.01, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 668.69}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.1, ["Fly"] = 16.68, ["Ride"] = 16.83, ["Fly|Ride"] = 29.96, ["Neon"] = 14, ["Neon|Fly"] = 25.83, ["Neon|Ride"] = 23.55, ["Neon|Fly|Ride"] = 54.51, ["Mega"] = 104.9, ["Mega|Fly"] = 170.62, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 3.59, ["Fly"] = 39.37, ["Ride"] = 24.29, ["Fly|Ride"] = 66.93, ["Neon"] = 14.91, ["Neon|Fly"] = 55.76, ["Neon|Ride"] = 36.2, ["Neon|Fly|Ride"] = 117.49, ["Mega"] = 208.19, ["Mega|Fly"] = 433.13, ["Mega|Ride"] = 212.02, ["Mega|Fly|Ride"] = 272.32}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.71, ["Fly"] = 21.63, ["Ride"] = 15.98, ["Fly|Ride"] = 60.89, ["Neon"] = 8.97, ["Neon|Fly"] = 98.42, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 89.23, ["Mega"] = 76.37, ["Mega|Fly"] = 170.63, ["Mega|Ride"] = 88.76, ["Mega|Fly|Ride"] = 162.04}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 12.39, ["Fly"] = 169.32, ["Ride"] = 23.44, ["Fly|Ride"] = 217.19, ["Neon"] = 30.19, ["Neon|Ride"] = 89.78, ["Neon|Fly|Ride"] = 275.5, ["Mega"] = 261.82, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 688.28}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 5.75, ["Ride"] = 139.7, ["Neon"] = 65.63, ["Neon|Ride"] = 262.4, ["Mega"] = 550.98, ["Mega|Ride"] = 389.58, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 2.62, ["Fly"] = 41.88, ["Ride"] = 15.65, ["Fly|Ride"] = 44.35, ["Neon"] = 26.24, ["Neon|Fly"] = 196.76, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 111.63, ["Mega"] = 255.94, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 418.28}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 21.29, ["Ride"] = 17.06, ["Fly|Ride"] = 35.59, ["Neon"] = 15.49, ["Neon|Fly"] = 46.68, ["Neon|Ride"] = 31.43, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 131.15, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 232.32}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 196.87, ["Fly"] = 393.75, ["Ride"] = 311.52, ["Fly|Ride"] = 392.43, ["Neon"] = 1100.18, ["Neon|Ride"] = 1365.03, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 3937.5}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 4.27, ["Ride"] = 107.31, ["Neon"] = 63.74, ["Mega"] = 120.84, ["Mega|Ride"] = 420.6, ["Mega|Fly|Ride"] = 481.91}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 2.63, ["Fly"] = 103.19, ["Ride"] = 21.77, ["Fly|Ride"] = 79.07, ["Neon"] = 21.72, ["Neon|Fly"] = 234.23, ["Neon|Ride"] = 55.74, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 204.25, ["Mega|Ride"] = 321.97, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 6.56, ["Neon"] = 36.63, ["Neon|Ride"] = 218.75, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 603.74, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 559.79}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 15.49, ["Ride"] = 13.57, ["Fly|Ride"] = 26.17, ["Neon"] = 2.1, ["Neon|Fly"] = 28.87, ["Neon|Ride"] = 15.49, ["Neon|Fly|Ride"] = 32.82, ["Mega"] = 18.26, ["Mega|Fly"] = 69.14, ["Mega|Ride"] = 131.08, ["Mega|Fly|Ride"] = 98.43}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 31.4, ["Fly|Ride"] = 110.41, ["Neon"] = 12.22, ["Neon|Ride"] = 23.4, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 98.34, ["Mega|Ride"] = 140.43, ["Mega|Fly|Ride"] = 211.83}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 3.82, ["Ride"] = 69.14, ["Neon"] = 15.61, ["Neon|Ride"] = 275.5, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 154.92, ["Mega|Ride"] = 412.77, ["Mega|Fly|Ride"] = 328.12}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 82.63, ["Fly"] = 163.35, ["Ride"] = 94.4, ["Fly|Ride"] = 158.82, ["Neon"] = 556.49, ["Neon|Ride"] = 372.91, ["Neon|Fly|Ride"] = 622.61, ["Mega"] = 2063.56, ["Mega|Ride"] = 3441.38, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 2.1, ["Fly"] = 96.99, ["Ride"] = 28.88, ["Fly|Ride"] = 141.75, ["Neon"] = 22.32, ["Neon|Ride"] = 59.83, ["Neon|Fly|Ride"] = 412.72, ["Mega"] = 211.54, ["Mega|Ride"] = 264.76, ["Mega|Fly|Ride"] = 556.21}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 20.99, ["Ride"] = 55.74, ["Neon"] = 23.51, ["Neon|Ride"] = 63.02, ["Neon|Fly|Ride"] = 532.25, ["Mega"] = 66.94, ["Mega|Fly"] = 314.99, ["Mega|Fly|Ride"] = 234.25}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 55.73, ["Fly"] = 210, ["Ride"] = 98.33, ["Fly|Ride"] = 225.96, ["Neon"] = 194.25, ["Neon|Ride"] = 202.12, ["Neon|Fly|Ride"] = 396.38, ["Mega"] = 572.64, ["Mega|Ride"] = 433.13, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 15.06, ["Ride"] = 12.71, ["Fly|Ride"] = 22.81, ["Neon"] = 2.1, ["Neon|Fly"] = 17.13, ["Neon|Ride"] = 14.79, ["Neon|Fly|Ride"] = 32.45, ["Mega"] = 17.99, ["Mega|Fly"] = 49.87, ["Mega|Ride"] = 35.43, ["Mega|Fly|Ride"] = 81.41}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 33.65, ["Neon"] = 3.81, ["Neon|Fly"] = 32, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 209.35, ["Mega"] = 48.5, ["Mega|Ride"] = 102.18, ["Mega|Fly|Ride"] = 175.76}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 46.24, ["Neon"] = 7.12, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 64.97, ["Neon|Fly|Ride"] = 184.7, ["Mega"] = 94.5, ["Mega|Fly"] = 179.54, ["Mega|Ride"] = 135.09, ["Mega|Fly|Ride"] = 206.36}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 3.56, ["Fly"] = 77.17, ["Ride"] = 41.4, ["Fly|Ride"] = 206.05, ["Neon"] = 14.44, ["Neon|Fly"] = 91.25, ["Neon|Ride"] = 76.56, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 97.02, ["Mega|Fly"] = 220.81, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 254.42}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 21.19, ["Ride"] = 11.73, ["Fly|Ride"] = 27.03, ["Neon"] = 2.1, ["Neon|Fly"] = 24.5, ["Neon|Ride"] = 24.97, ["Neon|Fly|Ride"] = 41.91, ["Mega"] = 16.96, ["Mega|Ride"] = 52.49, ["Mega|Fly|Ride"] = 118.12}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 26.85, ["Fly"] = 131.25, ["Ride"] = 125.09, ["Neon"] = 125.65, ["Neon|Fly"] = 412.72, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 656.25, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 688.28}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2610.55, ["Ride"] = 2493.73, ["Fly|Ride"] = 2493.75, ["Neon|Ride"] = 5832.75, ["Mega|Fly|Ride"] = 36115.33}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 53, ["Ride"] = 15.75, ["Fly|Ride"] = 42.07, ["Neon"] = 6.91, ["Neon|Fly"] = 63.95, ["Neon|Ride"] = 24.09, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 73.41, ["Mega|Ride"] = 124.69, ["Mega|Fly|Ride"] = 179.57}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.16, ["Neon"] = 5.16, ["Mega"] = 138.27, ["Mega|Fly"] = 441, ["Mega|Ride"] = 158.71, ["Mega|Fly|Ride"] = 192.31}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 20.34, ["Fly"] = 110.41, ["Ride"] = 30.34, ["Fly|Ride"] = 68.11, ["Neon"] = 69.54, ["Neon|Ride"] = 90.89, ["Neon|Fly|Ride"] = 292.37, ["Mega"] = 459.38, ["Mega|Ride"] = 584.07}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 28.19, ["Ride"] = 43.73, ["Neon"] = 187.68, ["Mega"] = 1256.31, ["Mega|Ride"] = 825.53, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 131.25, ["Fly"] = 1376.39, ["Ride"] = 197.88, ["Fly|Ride"] = 251.98, ["Neon"] = 1312.5, ["Neon|Ride"] = 700.41, ["Neon|Fly|Ride"] = 812.02, ["Mega"] = 6190.62, ["Mega|Fly|Ride"] = 3302.09}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 6.27, ["Ride"] = 28.88, ["Fly|Ride"] = 675.94, ["Neon"] = 15.75, ["Neon|Ride"] = 156.35, ["Mega"] = 156.19, ["Mega|Fly"] = 13125, ["Mega|Ride"] = 305.9, ["Mega|Fly|Ride"] = 582.75}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Fly|Ride"] = 69.14, ["Neon"] = 18.52, ["Neon|Ride"] = 114.85, ["Mega"] = 140.44, ["Mega|Fly|Ride"] = 829.27}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.23, ["Ride"] = 28.66, ["Fly|Ride"] = 131.25, ["Neon"] = 5.02, ["Neon|Ride"] = 39.37, ["Mega"] = 72.19, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 12.9, ["Ride"] = 50.34, ["Neon"] = 180.07, ["Neon|Ride"] = 1169.41, ["Mega"] = 374.07, ["Mega|Ride"] = 463.83}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 41.28, ["Neon"] = 2.1, ["Neon|Ride"] = 28.29, ["Mega"] = 13.02, ["Mega|Fly"] = 116.61, ["Mega|Ride"] = 158.81, ["Mega|Fly|Ride"] = 275.54}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 88.4, ["Fly"] = 206.37, ["Ride"] = 87.94, ["Fly|Ride"] = 311.09, ["Neon"] = 515.9, ["Neon|Ride"] = 401.06, ["Neon|Fly|Ride"] = 514.18, ["Mega"] = 2063.56, ["Mega|Fly|Ride"] = 2057.62}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 91.82, ["Neon"] = 10.06, ["Neon|Ride"] = 142.4, ["Neon|Fly|Ride"] = 206.37, ["Mega"] = 69.98, ["Mega|Ride"] = 274.5}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 36.3, ["Fly"] = 218.18, ["Ride"] = 73.41, ["Fly|Ride"] = 131.25, ["Neon"] = 295.32, ["Neon|Ride"] = 416.51, ["Neon|Fly|Ride"] = 321.57, ["Mega"] = 2625, ["Mega|Fly|Ride"] = 2590.88}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 60.89, ["Ride"] = 32, ["Fly|Ride"] = 50.7, ["Neon"] = 3.72, ["Neon|Fly"] = 87.44, ["Neon|Ride"] = 38.97, ["Neon|Fly|Ride"] = 83.99, ["Mega"] = 54.57, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 177.14}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Neon"] = 10.32, ["Neon|Ride"] = 98.44, ["Mega"] = 65.61, ["Mega|Ride"] = 152.25, ["Mega|Fly|Ride"] = 466.11}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 6.06, ["Fly"] = 77.43, ["Ride"] = 39.38, ["Fly|Ride"] = 206.37, ["Neon"] = 66.89, ["Neon|Ride"] = 111.93, ["Mega"] = 262.4, ["Mega|Fly|Ride"] = 551.06}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 345.19, ["Ride"] = 363.46, ["Fly|Ride"] = 525, ["Neon"] = 1050, ["Neon|Ride"] = 1140.37, ["Neon|Fly|Ride"] = 1443.75, ["Mega"] = 5503.46, ["Mega|Ride"] = 4725, ["Mega|Fly|Ride"] = 4289.25}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 26.24, ["Fly"] = 82.55, ["Ride"] = 51.85, ["Fly|Ride"] = 78.75, ["Neon"] = 190.2, ["Neon|Ride"] = 246.88, ["Neon|Fly|Ride"] = 371.45, ["Mega|Fly|Ride"] = 983.07}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 47.38, ["Ride"] = 17.3, ["Fly|Ride"] = 57.75, ["Neon"] = 6.86, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 23.66, ["Neon|Fly|Ride"] = 131.15, ["Mega"] = 117.93, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 229.69}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 12.47, ["Fly"] = 74.8, ["Ride"] = 43.42, ["Fly|Ride"] = 124.85, ["Neon"] = 65.63, ["Neon|Fly"] = 466.69, ["Neon|Ride"] = 96.99, ["Neon|Fly|Ride"] = 181.55, ["Mega"] = 311.84, ["Mega|Fly"] = 959.55, ["Mega|Ride"] = 354.19, ["Mega|Fly|Ride"] = 406.87}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 4.65, ["Ride"] = 20.69, ["Fly|Ride"] = 82.56, ["Neon"] = 138.27, ["Neon|Ride"] = 91.86, ["Neon|Fly|Ride"] = 264.67, ["Mega"] = 275.5, ["Mega|Ride"] = 659.4, ["Mega|Fly|Ride"] = 412.84}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.82, ["Neon"] = 13.74, ["Mega"] = 70.85, ["Mega|Ride"] = 131.25}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 18.59, ["Fly|Ride"] = 58.54, ["Neon"] = 32.82, ["Neon|Ride"] = 32.79, ["Neon|Fly|Ride"] = 270.35, ["Mega"] = 544.49, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 84, ["Ride"] = 117.5, ["Fly|Ride"] = 215.15, ["Neon"] = 742.89, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 853.13, ["Mega"] = 2887.5, ["Mega|Fly|Ride"] = 2799.2}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 24.81, ["Ride"] = 74.69, ["Fly|Ride"] = 91.88, ["Neon"] = 142.95, ["Neon|Ride"] = 206.37, ["Neon|Fly|Ride"] = 389.73, ["Mega"] = 1031.79, ["Mega|Ride"] = 895.7, ["Mega|Fly|Ride"] = 674.88}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 1995, ["Fly"] = 3576.71, ["Ride"] = 2100, ["Fly|Ride"] = 1955.63, ["Neon"] = 11005.87, ["Neon|Fly|Ride"] = 6424.69, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 3.8, ["Fly"] = 65625, ["Ride"] = 56.85, ["Neon"] = 12.6, ["Neon|Fly|Ride"] = 105, ["Mega"] = 96.22, ["Mega|Fly"] = 786.19, ["Mega|Ride"] = 167.35, ["Mega|Fly|Ride"] = 559.11}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 4.8, ["Ride"] = 49.54, ["Neon"] = 46.68, ["Neon|Ride"] = 119.02, ["Neon|Fly|Ride"] = 232.32, ["Mega"] = 192.95, ["Mega|Ride"] = 199.24, ["Mega|Fly|Ride"] = 1031.91}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 1047.81, ["Fly"] = 948.54, ["Ride"] = 879.27, ["Fly|Ride"] = 987, ["Neon"] = 2778.57, ["Neon|Ride"] = 2611.88, ["Neon|Fly|Ride"] = 2493.74, ["Mega"] = 11831.3, ["Mega|Fly|Ride"] = 11144.48}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 30.32, ["Ride"] = 52.49, ["Fly|Ride"] = 173.35, ["Neon"] = 157.5, ["Neon|Fly|Ride"] = 368.44, ["Mega"] = 839.9, ["Mega|Ride"] = 804.56, ["Mega|Fly|Ride"] = 1651.05}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 2.1, ["Ride"] = 23.58, ["Fly|Ride"] = 128.15, ["Neon"] = 15.49, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 175.88, ["Mega|Ride"] = 268.98, ["Mega|Fly|Ride"] = 551.06}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 52.41, ["Ride"] = 138.27, ["Neon"] = 2.72, ["Neon|Ride"] = 55.44, ["Neon|Fly|Ride"] = 78.43, ["Mega"] = 23.63, ["Mega|Ride"] = 255.46, ["Mega|Fly|Ride"] = 275.54}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 86.1, ["Ride"] = 129.94, ["Fly|Ride"] = 206.37, ["Neon"] = 412.72, ["Neon|Fly|Ride"] = 603.75, ["Mega"] = 8254.15, ["Mega|Fly|Ride"] = 5352.29}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 2.84, ["Ride"] = 27.88, ["Fly|Ride"] = 73.12, ["Neon"] = 12.76, ["Neon|Ride"] = 35.1, ["Neon|Fly|Ride"] = 275.5, ["Mega"] = 159.41, ["Mega|Ride"] = 111.57, ["Mega|Fly|Ride"] = 305.82}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 74.94, ["Ride"] = 152.73, ["Fly|Ride"] = 234.23, ["Neon"] = 393.75, ["Neon|Ride"] = 411.7, ["Neon|Fly|Ride"] = 506.62, ["Mega|Fly|Ride"] = 1752.18}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 2.98, ["Fly"] = 105, ["Fly|Ride"] = 110.41, ["Neon"] = 26.2, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 161.47, ["Mega|Ride"] = 164.07, ["Mega|Fly|Ride"] = 395.07}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 232.16, ["Ride"] = 301.88, ["Fly|Ride"] = 338.22, ["Neon"] = 1438.92, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 879.27, ["Mega|Fly|Ride"] = 3783.97}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 2.1, ["Fly"] = 87.94, ["Ride"] = 19.63, ["Fly|Ride"] = 55.74, ["Neon"] = 17.75, ["Neon|Ride"] = 57, ["Neon|Fly|Ride"] = 100.27, ["Mega"] = 210, ["Mega|Ride"] = 649.67, ["Mega|Fly|Ride"] = 688.28}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 14.02, ["Ride"] = 12.11, ["Fly|Ride"] = 28.24, ["Neon"] = 5.24, ["Neon|Fly"] = 31.29, ["Neon|Ride"] = 17.04, ["Neon|Fly|Ride"] = 48.57, ["Mega"] = 52.69, ["Mega|Fly"] = 136.14, ["Mega|Ride"] = 115.49, ["Mega|Fly|Ride"] = 209.39}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 1181.25, ["Ride"] = 1050, ["Fly|Ride"] = 1254.19, ["Neon|Ride"] = 7567, ["Neon|Fly|Ride"] = 5916.17}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 5.54, ["Fly"] = 963.69, ["Ride"] = 72.19, ["Neon"] = 42.77, ["Neon|Ride"] = 130.03, ["Mega"] = 308.43, ["Mega|Ride"] = 375.63, ["Mega|Fly|Ride"] = 698.15}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 7.53, ["Fly"] = 49.54, ["Ride"] = 45.29, ["Fly|Ride"] = 79.49, ["Neon"] = 25.74, ["Neon|Fly"] = 123.83, ["Neon|Ride"] = 52.41, ["Neon|Fly|Ride"] = 163.04, ["Mega"] = 185.76, ["Mega|Ride"] = 203.34, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 33.49, ["Fly"] = 33.26, ["Ride"] = 36.74, ["Fly|Ride"] = 75.14, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 189.74, ["Mega|Ride"] = 1238.29, ["Mega|Fly|Ride"] = 798}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 11.45, ["Fly"] = 82.56, ["Ride"] = 27.56, ["Fly|Ride"] = 89.78, ["Neon"] = 52.31, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 179.8, ["Mega"] = 367.5, ["Mega|Fly"] = 367.5, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 495.32}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 32.48, ["Ride"] = 109.69, ["Fly|Ride"] = 408.44, ["Neon"] = 129.94, ["Neon|Ride"] = 376.69, ["Mega"] = 699.55, ["Mega|Ride"] = 654.94, ["Mega|Fly|Ride"] = 583.83}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 116.61, ["Fly|Ride"] = 78.19, ["Neon"] = 2.58, ["Neon|Fly"] = 55.74, ["Neon|Ride"] = 111.02, ["Neon|Fly|Ride"] = 105.16, ["Mega"] = 17.07, ["Mega|Ride"] = 79.26, ["Mega|Fly|Ride"] = 158.93}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 57.66, ["Fly"] = 116.61, ["Ride"] = 62.91, ["Fly|Ride"] = 138.27, ["Neon"] = 446.22, ["Neon|Fly"] = 663.58, ["Neon|Ride"] = 393.74, ["Neon|Fly|Ride"] = 447.2, ["Mega"] = 3301.68, ["Mega|Ride"] = 1698.52, ["Mega|Fly|Ride"] = 1465.31}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 3.49, ["Fly"] = 91.4, ["Ride"] = 23.37, ["Fly|Ride"] = 127.32, ["Neon"] = 58.97, ["Mega"] = 773.06, ["Mega|Ride"] = 392.19}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 20.95, ["Ride"] = 15.65, ["Fly|Ride"] = 36.02, ["Neon"] = 16.28, ["Neon|Fly"] = 78.19, ["Neon|Ride"] = 55.74, ["Neon|Fly|Ride"] = 122.85, ["Mega|Ride"] = 275.06, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 3.92, ["Ride"] = 125.99, ["Neon"] = 20.13, ["Neon|Fly"] = 136.2, ["Neon|Fly|Ride"] = 205.33, ["Mega"] = 330.18, ["Mega|Fly|Ride"] = 466.55}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 59.76, ["Ride"] = 78.19, ["Fly|Ride"] = 262.5, ["Neon"] = 210, ["Neon|Ride"] = 412.72, ["Neon|Fly|Ride"] = 262.5, ["Mega|Ride"] = 1376.55, ["Mega|Fly|Ride"] = 1214.51}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 3.94, ["Neon"] = 24.97, ["Mega"] = 122.05, ["Mega|Fly|Ride"] = 290.15}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 33.78, ["Neon"] = 2.1, ["Neon|Ride"] = 52.5, ["Mega"] = 14.62, ["Mega|Ride"] = 40.28, ["Mega|Fly|Ride"] = 520.96}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 102.94, ["Ride"] = 26.25, ["Fly|Ride"] = 39.31, ["Neon"] = 3.52, ["Neon|Ride"] = 27.72, ["Neon|Fly|Ride"] = 165.1, ["Mega"] = 17.47, ["Mega|Ride"] = 51.59, ["Mega|Fly|Ride"] = 137.06}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 30.97, ["Ride"] = 15.89, ["Fly|Ride"] = 49.26, ["Neon"] = 5.25, ["Neon|Ride"] = 26.82, ["Neon|Fly|Ride"] = 86.68, ["Mega"] = 61.68, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 182.27}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.22, ["Ride"] = 28.88, ["Fly|Ride"] = 65.63, ["Neon"] = 39.37, ["Mega"] = 118.09, ["Mega|Ride"] = 106.3, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 38.04, ["Ride"] = 15.49, ["Fly|Ride"] = 32.37, ["Neon"] = 15.65, ["Neon|Fly"] = 209.31, ["Neon|Ride"] = 39.22, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 202.25, ["Mega|Fly|Ride"] = 451.5}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 39.37, ["Ride"] = 107.63, ["Fly|Ride"] = 220.81, ["Neon"] = 196.76, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 1031.79, ["Mega"] = 694.32, ["Mega|Ride"] = 887.45, ["Mega|Fly|Ride"] = 1081.44}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 15.53, ["Ride"] = 15.03, ["Fly|Ride"] = 35.44, ["Neon"] = 2.52, ["Neon|Fly"] = 23.13, ["Neon|Ride"] = 16.69, ["Neon|Fly|Ride"] = 43.35, ["Mega"] = 24.94, ["Mega|Ride"] = 23.93, ["Mega|Fly|Ride"] = 65.63}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 6.09, ["Fly"] = 81.33, ["Ride"] = 23.57, ["Fly|Ride"] = 57.2, ["Neon"] = 22.23, ["Neon|Fly"] = 82.91, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 143.92, ["Mega"] = 397.87, ["Mega|Ride"] = 278.11, ["Mega|Fly|Ride"] = 481.91}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 14.1, ["Fly"] = 40.25, ["Ride"] = 27.56, ["Fly|Ride"] = 83.91, ["Neon"] = 124.16, ["Neon|Fly"] = 174.49, ["Neon|Ride"] = 144.37, ["Neon|Fly|Ride"] = 196.56, ["Mega"] = 787.5, ["Mega|Ride"] = 590.52, ["Mega|Fly|Ride"] = 611.63}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 6.57, ["Fly"] = 196.87, ["Ride"] = 44.63, ["Neon"] = 41.91, ["Neon|Ride"] = 71.76, ["Mega"] = 366.19, ["Mega|Ride"] = 399.35, ["Mega|Fly|Ride"] = 412.77}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 14.6, ["Fly|Ride"] = 39.47, ["Neon"] = 4.58, ["Neon|Fly"] = 24.77, ["Neon|Ride"] = 20.61, ["Neon|Fly|Ride"] = 66.88, ["Mega"] = 42.84, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 138.29, ["Mega|Fly|Ride"] = 106.15}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 3.53, ["Fly"] = 70.17, ["Ride"] = 37.97, ["Neon"] = 21.52, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 110.41, ["Mega"] = 206.37, ["Mega|Fly"] = 735, ["Mega|Ride"] = 220.84, ["Mega|Fly|Ride"] = 385.94}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 929.25, ["Fly"] = 1323.02, ["Ride"] = 976.5, ["Fly|Ride"] = 1115.49, ["Neon"] = 4044.87, ["Neon|Ride"] = 2231.25, ["Neon|Fly|Ride"] = 2231.15, ["Mega|Fly|Ride"] = 6929.9}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 104.79, ["Ride"] = 185.42, ["Fly|Ride"] = 341.25, ["Neon"] = 550.98, ["Neon|Ride"] = 510.75, ["Neon|Fly|Ride"] = 688.2, ["Mega"] = 6190.62, ["Mega|Ride"] = 2614.84, ["Mega|Fly|Ride"] = 2074.64}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.63, ["Fly"] = 55.73, ["Neon"] = 6.14, ["Neon|Ride"] = 52.41, ["Neon|Fly|Ride"] = 206.37, ["Mega"] = 89.25, ["Mega|Fly|Ride"] = 1101.05}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 79.96, ["Ride"] = 114.92, ["Fly|Ride"] = 196.88, ["Neon"] = 392.41, ["Neon|Ride"] = 360.94, ["Neon|Fly|Ride"] = 551.25, ["Mega"] = 1575, ["Mega|Ride"] = 1307.43, ["Mega|Fly|Ride"] = 1265.25}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 2.93, ["Ride"] = 19.13, ["Fly|Ride"] = 89.78, ["Neon"] = 18.79, ["Neon|Fly"] = 54.86, ["Neon|Ride"] = 47.7, ["Neon|Fly|Ride"] = 275.5, ["Mega"] = 274.02, ["Mega|Ride"] = 310.01, ["Mega|Fly|Ride"] = 399.35}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 275.62, ["Fly"] = 330.14, ["Ride"] = 273, ["Fly|Ride"] = 384.44, ["Neon|Ride"] = 1307.27, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 4403.11}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 76.4, ["Ride"] = 40.25, ["Fly|Ride"] = 213.09, ["Neon"] = 31.2, ["Neon|Ride"] = 54.37, ["Mega"] = 412.29, ["Mega|Fly"] = 321.92, ["Mega|Ride"] = 622.83}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Neon"] = 28.01, ["Mega"] = 330.18, ["Mega|Ride"] = 353.95}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 26.04, ["Ride"] = 275.5, ["Fly|Ride"] = 196.88, ["Neon"] = 152.73, ["Neon|Ride"] = 124.49, ["Mega"] = 963.69, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.3, ["Ride"] = 49.73, ["Neon"] = 18.8, ["Neon|Ride"] = 141.91, ["Mega"] = 233.19, ["Mega|Ride"] = 253.3, ["Mega|Fly|Ride"] = 456.05}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 15.12, ["Ride"] = 12.29, ["Fly|Ride"] = 39.35, ["Neon"] = 2.1, ["Neon|Fly"] = 23.63, ["Neon|Ride"] = 26.15, ["Neon|Fly|Ride"] = 37.43, ["Mega"] = 32, ["Mega|Ride"] = 30.24, ["Mega|Fly|Ride"] = 80.53}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4593.75, ["Ride"] = 5130.57, ["Fly|Ride"] = 4517.63, ["Neon"] = 30953.04, ["Neon|Fly|Ride"] = 18414.38, ["Mega|Fly|Ride"] = 128986.97}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 7.13, ["Fly"] = 82.56, ["Ride"] = 41.57, ["Neon"] = 52.41, ["Neon|Ride"] = 105, ["Mega"] = 274.46, ["Mega|Ride"] = 302.57, ["Mega|Fly|Ride"] = 412.77}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 24.69, ["Ride"] = 16.49, ["Fly|Ride"] = 51.19, ["Neon"] = 11.83, ["Neon|Fly"] = 45.9, ["Neon|Ride"] = 34.18, ["Neon|Fly|Ride"] = 75.54, ["Mega"] = 144.37, ["Mega|Ride"] = 188.74, ["Mega|Fly|Ride"] = 239.75}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 431.82, ["Fly"] = 547.77, ["Ride"] = 420, ["Fly|Ride"] = 552.46, ["Neon"] = 2099.99, ["Neon|Ride"] = 1555.32, ["Neon|Fly|Ride"] = 1744.43, ["Mega|Fly|Ride"] = 5902.46}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 4.45, ["Ride"] = 32.45, ["Neon"] = 19.23, ["Neon|Ride"] = 145.69, ["Mega"] = 140.51, ["Mega|Fly|Ride"] = 695.63}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 3.4, ["Fly"] = 4126.57, ["Ride"] = 46.68, ["Neon"] = 27.2, ["Neon|Ride"] = 62.97, ["Neon|Fly|Ride"] = 280.66, ["Mega"] = 410.66, ["Mega|Ride"] = 401.62, ["Mega|Fly|Ride"] = 275.54}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 52.47, ["Ride"] = 18.53, ["Neon"] = 2.87, ["Neon|Fly"] = 124.69, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 91.74, ["Mega"] = 37.43, ["Mega|Ride"] = 75.99, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 1097.67, ["Ride"] = 767.8, ["Fly|Ride"] = 753.54, ["Neon|Ride"] = 3248.44, ["Neon|Fly|Ride"] = 2455.63}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 6.75, ["Ride"] = 55.74, ["Fly|Ride"] = 412.72, ["Neon"] = 36.15, ["Neon|Ride"] = 72.24, ["Neon|Fly|Ride"] = 275.5, ["Mega"] = 155.99, ["Mega|Ride"] = 229.03, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 8.33, ["Fly"] = 236.15, ["Ride"] = 30.18, ["Fly|Ride"] = 65.63, ["Neon"] = 24.69, ["Neon|Ride"] = 44.1, ["Neon|Fly|Ride"] = 216.68, ["Mega"] = 198.93, ["Mega|Fly"] = 777.67, ["Mega|Ride"] = 224.33, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 34.11, ["Ride"] = 16.67, ["Fly|Ride"] = 59.07, ["Neon"] = 16.1, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 30.64, ["Neon|Fly|Ride"] = 74.82, ["Mega"] = 274.46, ["Mega|Ride"] = 195.57, ["Mega|Fly|Ride"] = 217.24}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 18.16, ["Ride"] = 38.07, ["Fly|Ride"] = 55.74, ["Neon"] = 117.58, ["Neon|Fly|Ride"] = 309.54, ["Mega"] = 557.82, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 824.51}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Fly|Ride"] = 82.56, ["Neon"] = 5.29, ["Neon|Ride"] = 36.37, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 53.03, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 548.63, ["Ride"] = 538.12, ["Fly|Ride"] = 616.88, ["Neon"] = 2589.57, ["Neon|Ride"] = 2201.81, ["Neon|Fly|Ride"] = 2367.46, ["Mega|Fly|Ride"] = 7861.88}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Fly"] = 103.18, ["Ride"] = 70.13, ["Neon"] = 15.44, ["Neon|Ride"] = 84.4, ["Neon|Fly|Ride"] = 466.37, ["Mega"] = 98.34, ["Mega|Ride"] = 275.54, ["Mega|Fly|Ride"] = 344.09}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 14.44, ["Neon"] = 7.77, ["Neon|Fly"] = 234.23, ["Neon|Ride"] = 210.02, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 78.14, ["Mega|Ride"] = 138.29, ["Mega|Fly|Ride"] = 348.79}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 49.44, ["Fly|Ride"] = 76.37, ["Neon"] = 3.94, ["Neon|Ride"] = 44.57, ["Neon|Fly|Ride"] = 138.27, ["Mega"] = 69.57, ["Mega|Fly"] = 152.73, ["Mega|Ride"] = 99.65, ["Mega|Fly|Ride"] = 145.68}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.1, ["Ride"] = 34.69, ["Neon"] = 15.49, ["Mega"] = 206.37, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 33.28, ["Fly"] = 98.44, ["Ride"] = 118.01, ["Fly|Ride"] = 275.5, ["Neon"] = 122.06, ["Neon|Ride"] = 137.22, ["Neon|Fly|Ride"] = 334.68, ["Mega"] = 825.43, ["Mega|Ride"] = 967.32, ["Mega|Fly|Ride"] = 824.51}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 17.64, ["Ride"] = 58.44, ["Fly|Ride"] = 128.99, ["Neon"] = 81.79, ["Neon|Ride"] = 141.82, ["Neon|Fly|Ride"] = 279.2, ["Mega"] = 471.27, ["Mega|Fly"] = 550.98, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 659.48}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly"] = 19.59, ["Ride"] = 14.37, ["Fly|Ride"] = 31.49, ["Neon"] = 26.84, ["Neon|Ride"] = 36.68, ["Neon|Fly|Ride"] = 66.05, ["Mega"] = 301.88, ["Mega|Ride"] = 276.86, ["Mega|Fly|Ride"] = 292.35}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 6.55, ["Ride"] = 101.51, ["Neon"] = 72.19, ["Neon|Ride"] = 136.2, ["Mega"] = 466.37, ["Mega|Ride"] = 309.59}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Ride"] = 20.73, ["Fly|Ride"] = 111.55, ["Neon"] = 12.95, ["Neon|Ride"] = 25.89, ["Neon|Fly|Ride"] = 153.91, ["Mega"] = 103.95, ["Mega|Ride"] = 115.49, ["Mega|Fly|Ride"] = 247.67}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 18.09, ["Ride"] = 26.25, ["Fly|Ride"] = 77.42, ["Neon"] = 412.72, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 198.86, ["Mega"] = 927.57, ["Mega|Fly|Ride"] = 813.16}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 24.14, ["Fly"] = 874.13, ["Neon"] = 262.08, ["Mega"] = 450.19, ["Mega|Ride"] = 590.63}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 49.22, ["Fly"] = 115.4, ["Ride"] = 77.16, ["Fly|Ride"] = 138.27, ["Neon"] = 183.75, ["Neon|Ride"] = 313.69, ["Neon|Fly|Ride"] = 364.41, ["Mega|Ride"] = 1649.2, ["Mega|Fly|Ride"] = 1651.05}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 37.2, ["Fly"] = 82.56, ["Ride"] = 76.56, ["Fly|Ride"] = 201.22, ["Neon"] = 138.96, ["Neon|Ride"] = 203.44, ["Neon|Fly|Ride"] = 582.75, ["Mega"] = 855.79, ["Mega|Ride"] = 2026.5, ["Mega|Fly|Ride"] = 620.82}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 19.05, ["Ride"] = 57.5, ["Fly|Ride"] = 206.37, ["Neon"] = 140.02, ["Neon|Ride"] = 284.82, ["Mega"] = 1049.99, ["Mega|Ride"] = 783.26, ["Mega|Fly|Ride"] = 825.53}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 12.95, ["Fly"] = 412.68, ["Ride"] = 55.74, ["Fly|Ride"] = 105, ["Neon"] = 126.37, ["Neon|Fly"] = 420, ["Neon|Ride"] = 138.27, ["Neon|Fly|Ride"] = 279.84, ["Mega"] = 537.85, ["Mega|Ride"] = 525.08, ["Mega|Fly|Ride"] = 714.44}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 17.74, ["Ride"] = 15.25, ["Fly|Ride"] = 32.72, ["Neon"] = 3.51, ["Neon|Fly"] = 27.02, ["Neon|Ride"] = 27.46, ["Neon|Fly|Ride"] = 41.49, ["Mega"] = 156.24, ["Mega|Fly"] = 325.02, ["Mega|Ride"] = 79.5, ["Mega|Fly|Ride"] = 399.35}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1253.93}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 59.53, ["Ride"] = 98.44, ["Fly|Ride"] = 1181.25, ["Neon"] = 315.74, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 1513.62, ["Mega|Ride"] = 1134.07, ["Mega|Fly|Ride"] = 1260}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 79.71, ["Neon"] = 3.72, ["Neon|Ride"] = 42.95, ["Neon|Fly|Ride"] = 288.91, ["Mega"] = 28.01, ["Mega|Ride"] = 84.94}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 30.51, ["Ride"] = 52.5, ["Fly|Ride"] = 123.83, ["Neon"] = 206.37, ["Neon|Ride"] = 279.62, ["Neon|Fly|Ride"] = 311.32, ["Mega"] = 711.38, ["Mega|Ride"] = 777.95, ["Mega|Fly|Ride"] = 1237.26}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 3.82, ["Mega"] = 23.67}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 3.72, ["Mega"] = 23.45, ["Mega|Ride"] = 151.41}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 84.14, ["Fly"] = 350.78, ["Ride"] = 118.13, ["Fly|Ride"] = 288.91, ["Neon"] = 582.75, ["Neon|Ride"] = 588, ["Neon|Fly|Ride"] = 589.99, ["Mega|Ride"] = 2545.7, ["Mega|Fly|Ride"] = 2001.45}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 35.1, ["Fly|Ride"] = 93.35, ["Neon"] = 9.19, ["Neon|Ride"] = 24.93, ["Neon|Fly|Ride"] = 99.74, ["Mega"] = 90.15, ["Mega|Ride"] = 109.81, ["Mega|Fly|Ride"] = 281.71}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 38.07, ["Ride"] = 64.13, ["Fly|Ride"] = 86.63, ["Neon"] = 5.72, ["Neon|Ride"] = 40.85, ["Neon|Fly|Ride"] = 138.27, ["Mega"] = 36.75, ["Mega|Ride"] = 123.84, ["Mega|Fly|Ride"] = 688.28}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 4.23, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 210, ["Mega"] = 52.5, ["Mega|Ride"] = 275.54, ["Mega|Fly|Ride"] = 237.36}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 28.13, ["Neon"] = 5.08, ["Neon|Ride"] = 155.6, ["Mega"] = 83.39, ["Mega|Ride"] = 207.38}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 49.06, ["Ride"] = 135.19, ["Fly|Ride"] = 449.61, ["Neon"] = 424.07, ["Neon|Ride"] = 424.08, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1787.04, ["Mega|Ride"] = 1547.85, ["Mega|Fly|Ride"] = 1513.8}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 3.93, ["Ride"] = 64.84, ["Neon"] = 78, ["Neon|Ride"] = 157.55, ["Mega"] = 465.14, ["Mega|Ride"] = 943.78, ["Mega|Fly|Ride"] = 545.74}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 306.87, ["Ride"] = 466.69, ["Fly|Ride"] = 751.35, ["Neon"] = 918.75, ["Neon|Ride"] = 1059.64, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Ride"] = 3990.35, ["Mega|Fly|Ride"] = 4126.57}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 84}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 47.25}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 25.75}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 15.75}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 122.66}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 95.8}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 11.24}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 6.13}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 245.13}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 25.71}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 31.86}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 5.15}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 32.8}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 208.44}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 9.36}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 5.32}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 2.1}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 6.7}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 8.5}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 450.02}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 775.09}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 8.01}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1039.47}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 45.94}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 7.48}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 21.27}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 3.91}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 24.42}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 34.08}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 46.1}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 18.52}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 13.27}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 17.42}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 4.6}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 18.06}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.1}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 16.7}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 14.46}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 5.99}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 2055.38}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 42.9}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 301.88}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 3.92}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 5.16}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 8.96}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 6.23}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 46.4}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 185.43}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 6.02}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 10.8}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 1181.25}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 26.28}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 6.01}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 25.6}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 4.96}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 19.57}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 101.07}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 19.34}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 12.95}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.62}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 69.14}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 40.99}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 3.92}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 24.98}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 78.65}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 210}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 5.55}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 98.44}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 24.57}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 108.93}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 20.31}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22234.4}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 164.07}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 75.88}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 41.89}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 43.64}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 41.28}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 31.15}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 31.17}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 80.85}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 78.74}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 43.31}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 56.49}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 109.49}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 32.81}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 6912.86}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 6.13}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 6.13}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.62}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 23.56}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 31.65}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 110.65}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.1}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 3.49}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 7.85}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 8.69}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 787.5}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 9.91}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 583.68}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 12.66}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.6}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 607.01}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 27.26}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 115.31}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 24.45}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 20.79}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 45.05}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 11.8}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 3.56}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 7.59}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.1}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 15.73}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 2.88}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 28.67}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 5.25}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 2.47}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 3.73}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 26.25}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 191.02}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 48.5}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 5.24}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 1048.59}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 8.29}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 3.15}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 4.7}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 21.67}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 13.54}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 3.08}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 8.6}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 2.1}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 5.92}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 27.57}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 16.67}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 4.28}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 3.02}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 9.24}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 6.04}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 3.08}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 3.4}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 3.6}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 6.41}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 7978.72}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.61}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 17.67}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 2.15}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 8.69}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 5.81}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 9.11}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 10.49}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 2.46}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 7.48}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.3}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 30.17}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 6.49}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 3.61}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 2.2}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 2.52}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 6.2}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4317.92}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 7.49}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 27.17}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 6.36}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 2.52}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 58.15}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.9}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 9.17}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 129.74}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 10.9}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 3.55}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.1}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 7.84}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 6.56}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 24.07}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.55}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.15}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 15.54}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 2.45}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 2.91}},
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
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 27.87}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 3.62}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 8.56}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 78.66}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.53}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 62.09}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 4.61}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 2.14}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1041.39}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 25.39}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.62}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 5.22}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 5.2}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 9.02}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 5.24}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 3.82}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 10.31}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 9.09}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 13.94}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 7.01}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 3.6}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 2.2}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 6.46}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 9.85}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 18.58}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 3.19}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 17.75}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 47.88}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 5.98}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 26.17}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 61.69}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 5.2}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 2.16}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 43.65}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 24.05}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 3.82}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 2.37}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 6.08}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 3.03}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 3.4}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 74.42}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 143.06}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 3.98}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1187.71}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 3.71}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 234.2}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 199.49}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 54.23}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 3.24}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 2.42}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 3.47}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 32.71}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 15.31}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 7.88}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 3.5}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 3.74}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 5.37}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 59.29}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 2.16}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 61.01}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.37}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 20.79}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 3.93}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 21.74}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 125.67}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.61}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 74.84}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 5.78}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 3.4}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 698.25}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 66.1}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 45.38}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 64.43}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 371.23}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 5.84}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 59.06}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 106.7}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.84}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 3.66}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 6.65}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 22.89}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 64.16}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 3.73}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 52.49}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 2.15}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 46.55}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 13.54}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 57.66}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 25.91}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 62.84}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 41.2}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 5.25}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 26.11}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 2.61}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 10.39}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 47.16}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 41.11}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 35.06}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1783.42}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 9.18}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 6.12}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 69.14}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 328.13}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 13.13}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 8.27}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 7.8}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 6.45}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 8.38}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 275.62}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 51.31}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 41.4}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 7.69}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 140.24}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 165.27}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 62.87}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 1155}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 311.6}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 7.07}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 2361.19}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 551.24}},
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