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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 1043.06, ["Ride"] = 993.58, ["Fly|Ride"] = 1365, ["Neon"] = 6718, ["Neon|Fly|Ride"] = 3921.75, ["Mega|Fly|Ride"] = 25143.57}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 406.86, ["Fly"] = 544.79, ["Ride"] = 402.55, ["Fly|Ride"] = 631.32, ["Neon|Ride"] = 2233.92, ["Neon|Fly|Ride"] = 2072.44, ["Mega|Fly|Ride"] = 8318.67}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 4725, ["Ride"] = 4935, ["Fly|Ride"] = 4790.63, ["Neon"] = 26239.94, ["Neon|Fly|Ride"] = 21592.89, ["Mega|Fly|Ride"] = 67372.6}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 129.94, ["Ride"] = 170.58, ["Fly|Ride"] = 252.09, ["Neon"] = 844.65, ["Neon|Ride"] = 808.48, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 3829.58, ["Mega|Fly|Ride"] = 2889.06}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 632.63, ["Fly"] = 667, ["Ride"] = 538.13, ["Fly|Ride"] = 539.44, ["Neon|Ride"] = 1575, ["Neon|Fly|Ride"] = 1522.5, ["Mega|Fly|Ride"] = 6717.8}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 7.83, ["Ride"] = 36.19, ["Fly|Ride"] = 142.55, ["Neon"] = 63.83, ["Neon|Fly"] = 113.85, ["Neon|Ride"] = 91.5, ["Neon|Fly|Ride"] = 284.04, ["Mega"] = 275.13, ["Mega|Ride"] = 479.85, ["Mega|Fly|Ride"] = 420.2}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 3.83, ["Fly"] = 42.56, ["Ride"] = 24.01, ["Fly|Ride"] = 64.79, ["Neon"] = 31.92, ["Neon|Fly"] = 106.39, ["Neon|Ride"] = 56.37, ["Neon|Fly|Ride"] = 127.32, ["Mega"] = 185.07, ["Mega|Fly"] = 278.33, ["Mega|Ride"] = 141.09, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 118.12, ["Fly"] = 656.25, ["Ride"] = 157.45, ["Fly|Ride"] = 178.5, ["Neon"] = 355.31, ["Neon|Ride"] = 469.13, ["Neon|Fly|Ride"] = 638.27, ["Mega"] = 1919.38, ["Mega|Fly|Ride"] = 2042.44}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 31.48, ["Fly"] = 143.63, ["Ride"] = 52.49, ["Fly|Ride"] = 107.07, ["Neon"] = 240.42, ["Neon|Ride"] = 210.63, ["Neon|Fly|Ride"] = 261.19, ["Mega"] = 2100, ["Mega|Ride"] = 2730, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 23.23, ["Fly"] = 94.5, ["Ride"] = 27.71, ["Fly|Ride"] = 61.71, ["Neon"] = 140.43, ["Neon|Ride"] = 147.88, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 764.87, ["Mega|Fly|Ride"] = 735}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 52.56, ["Fly"] = 289.36, ["Ride"] = 73.64, ["Fly|Ride"] = 127.32, ["Neon"] = 272.33, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 335.9, ["Mega|Ride"] = 1419.08, ["Mega|Fly|Ride"] = 1391.56}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 80.07}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 355.31, ["Fly"] = 387.19, ["Ride"] = 367.49, ["Fly|Ride"] = 452.58, ["Neon"] = 1283.63, ["Neon|Fly|Ride"] = 2482.85, ["Mega|Fly|Ride"] = 8510.14}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 118.13, ["Fly"] = 131.25, ["Ride"] = 105, ["Fly|Ride"] = 131.25, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 643.13, ["Mega|Fly|Ride"] = 2613.19}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.61, ["Fly"] = 118.09, ["Ride"] = 24.02, ["Fly|Ride"] = 142.55, ["Neon"] = 17.04, ["Neon|Ride"] = 65.63, ["Mega"] = 120.45, ["Mega|Ride"] = 189, ["Mega|Fly|Ride"] = 383.25}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 141.37, ["Fly"] = 160.75, ["Ride"] = 163.73, ["Fly|Ride"] = 202, ["Neon"] = 709.55, ["Neon|Ride"] = 638.27, ["Neon|Fly|Ride"] = 564.38, ["Mega|Fly|Ride"] = 1837.38}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.68, ["Fly"] = 27.2, ["Ride"] = 18.51, ["Fly|Ride"] = 52.37, ["Neon"] = 26.25, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 787.5, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 305.82}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 62.99, ["Fly"] = 262.5, ["Ride"] = 91.88, ["Fly|Ride"] = 241.48, ["Neon"] = 216.57, ["Neon|Ride"] = 229.68, ["Neon|Fly|Ride"] = 412.63, ["Mega"] = 1415.89, ["Mega|Ride"] = 921.23, ["Mega|Fly|Ride"] = 797.22}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 55.28}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 76.13, ["Ride"] = 142.55, ["Fly|Ride"] = 246.1, ["Neon"] = 525, ["Neon|Ride"] = 590.63, ["Neon|Fly|Ride"] = 2362.5}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 12.9, ["Fly"] = 393.75, ["Ride"] = 26.17, ["Fly|Ride"] = 106.32, ["Neon"] = 134.03, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 185.11, ["Mega"] = 2759.11, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 1702.04}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 30.3, ["Fly"] = 64.3, ["Ride"] = 43.32, ["Fly|Ride"] = 91.34, ["Neon"] = 336, ["Neon|Fly"] = 317.01, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 262.29, ["Mega"] = 1681.32, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 57.75, ["Fly"] = 105, ["Ride"] = 155.76, ["Fly|Ride"] = 140.43, ["Neon"] = 236.25, ["Neon|Fly"] = 398.27, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 318.08, ["Mega"] = 1254.19, ["Mega|Ride"] = 1272.28, ["Mega|Fly|Ride"] = 1262.7}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 39.46, ["Ride"] = 42.55, ["Fly|Ride"] = 171.29, ["Neon"] = 182.98, ["Neon|Ride"] = 212.77, ["Neon|Fly|Ride"] = 263.83, ["Mega"] = 1207.92, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1276.53}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 52.48, ["Fly"] = 587.65, ["Ride"] = 78.75, ["Fly|Ride"] = 135.19, ["Neon"] = 280.01, ["Neon|Ride"] = 309.68, ["Mega|Ride"] = 1124.82, ["Mega|Fly|Ride"] = 800.15}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 4.93, ["Fly"] = 28.88, ["Ride"] = 19.69, ["Fly|Ride"] = 38.06, ["Neon"] = 39.38, ["Neon|Fly"] = 70.86, ["Neon|Ride"] = 47.95, ["Neon|Fly|Ride"] = 87.26, ["Mega"] = 131.14, ["Mega|Fly"] = 239.94, ["Mega|Ride"] = 178.5, ["Mega|Fly|Ride"] = 238.85}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 295.32, ["Ride"] = 355.31, ["Fly|Ride"] = 362.25, ["Neon"] = 1475.25, ["Neon|Ride"] = 1702.04, ["Neon|Fly|Ride"] = 1627.5, ["Mega"] = 10637.67, ["Mega|Fly|Ride"] = 6658.13}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 16.88, ["Ride"] = 26.23, ["Fly|Ride"] = 136.49, ["Neon"] = 568.07, ["Neon|Ride"] = 160.76, ["Mega"] = 837.2, ["Mega|Ride"] = 719.78, ["Mega|Fly|Ride"] = 837.2}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 3.61, ["Fly"] = 38.21, ["Ride"] = 21, ["Fly|Ride"] = 36.38, ["Neon"] = 49.88, ["Neon|Ride"] = 64.79, ["Neon|Fly|Ride"] = 126.11, ["Mega"] = 425.52, ["Mega|Ride"] = 619.5, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 93.58, ["Fly"] = 112.12, ["Ride"] = 72.19, ["Fly|Ride"] = 157.5, ["Neon"] = 421.28, ["Neon|Ride"] = 449.98, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 1785.03, ["Mega|Ride"] = 7290.94, ["Mega|Fly|Ride"] = 1827.56}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 11.82, ["Ride"] = 26.25, ["Fly|Ride"] = 115.5, ["Neon"] = 97.88, ["Neon|Ride"] = 100.02, ["Neon|Fly|Ride"] = 158.82, ["Mega"] = 425.52, ["Mega|Fly|Ride"] = 704.19}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 182.44, ["Fly"] = 355.31, ["Ride"] = 223.13, ["Fly|Ride"] = 284.04, ["Neon"] = 787.2, ["Neon|Ride"] = 851.03, ["Neon|Fly|Ride"] = 773.07, ["Mega"] = 6382.61, ["Mega|Fly|Ride"] = 2993.45}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 30.19}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.93, ["Fly"] = 35.13, ["Ride"] = 24.01, ["Fly|Ride"] = 59.56, ["Neon"] = 21, ["Neon|Fly"] = 93.58, ["Neon|Ride"] = 55.18, ["Neon|Fly|Ride"] = 147.88, ["Mega"] = 131.23, ["Mega|Fly"] = 288.04, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 307.11}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 917.44, ["Ride"] = 958.13, ["Fly|Ride"] = 1312.5, ["Neon"] = 5118.88, ["Neon|Ride"] = 5250, ["Neon|Fly|Ride"] = 3937.5, ["Mega"] = 20424.33, ["Mega|Ride"] = 53982.21, ["Mega|Fly|Ride"] = 14184.29}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 5.24, ["Fly"] = 28.49, ["Ride"] = 23.34, ["Fly|Ride"] = 87.94, ["Neon"] = 108.51, ["Neon|Ride"] = 113.82, ["Neon|Fly|Ride"] = 105, ["Mega"] = 364.89, ["Mega|Ride"] = 617.01, ["Mega|Fly|Ride"] = 667}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 105, ["Ride"] = 131.25, ["Fly|Ride"] = 196.88, ["Neon"] = 656.25, ["Neon|Ride"] = 682.5, ["Neon|Fly|Ride"] = 685.13, ["Mega|Ride"] = 2658.37, ["Mega|Fly|Ride"] = 2482.83}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 36.19}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 20.67, ["Fly"] = 68.85, ["Ride"] = 55.13, ["Fly|Ride"] = 143.95, ["Neon"] = 91.41, ["Neon|Fly"] = 170.22, ["Neon|Ride"] = 206.07, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 680.82, ["Mega|Ride"] = 723.19, ["Mega|Fly|Ride"] = 752.17}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.63}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 127.86, ["Ride"] = 199.5, ["Fly|Ride"] = 262.74, ["Neon"] = 525, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 590.63, ["Mega|Fly|Ride"] = 2165.63}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 129.88, ["Ride"] = 171.66, ["Fly|Ride"] = 239.88, ["Neon"] = 438.38, ["Neon|Ride"] = 366.18, ["Neon|Fly|Ride"] = 640.5, ["Mega"] = 1443.75, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1702.03}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 45.93}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 78.75, ["Fly"] = 65.63, ["Ride"] = 52.5, ["Fly|Ride"] = 65.63, ["Neon"] = 610.62, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 341.11, ["Mega"] = 4254.02, ["Mega|Fly|Ride"] = 1443.75}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 7.49, ["Ride"] = 30.19, ["Fly|Ride"] = 160.64, ["Neon"] = 38.31, ["Neon|Ride"] = 127.66, ["Neon|Fly|Ride"] = 237.23, ["Mega"] = 155.33, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 178.5, ["Mega|Fly|Ride"] = 352.11}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 354.38, ["Fly"] = 420, ["Ride"] = 388.49, ["Fly|Ride"] = 393.75, ["Neon|Ride"] = 1246.88, ["Neon|Fly|Ride"] = 1251.88, ["Mega|Fly|Ride"] = 6099.64}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 81.29, ["Fly"] = 99.75, ["Ride"] = 94.5, ["Fly|Ride"] = 105, ["Neon"] = 367.13, ["Neon|Ride"] = 382.97, ["Neon|Fly|Ride"] = 369.01, ["Mega"] = 2837.08, ["Mega|Ride"] = 1900.97, ["Mega|Fly|Ride"] = 1943.51}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3236.63, ["Ride"] = 3433.5, ["Fly|Ride"] = 3017.43, ["Neon|Fly|Ride"] = 14891.68}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 42, ["Fly"] = 113.85, ["Ride"] = 54.57, ["Fly|Ride"] = 95.82, ["Neon"] = 392.44, ["Neon|Ride"] = 276.94, ["Neon|Fly|Ride"] = 381.91, ["Mega"] = 1278.66, ["Mega|Ride"] = 1275.47, ["Mega|Fly|Ride"] = 2270.09}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 71.99, ["Ride"] = 91.5, ["Fly|Ride"] = 160.76, ["Neon"] = 656.25, ["Neon|Ride"] = 798.42, ["Neon|Fly|Ride"] = 568.07, ["Mega"] = 6382.61, ["Mega|Fly|Ride"] = 1838.2}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 38.06, ["Fly"] = 78.73, ["Ride"] = 61.51, ["Fly|Ride"] = 126.84, ["Neon"] = 131.25, ["Neon|Ride"] = 168.63, ["Neon|Fly|Ride"] = 190.32, ["Mega"] = 2625, ["Mega|Fly|Ride"] = 697.86}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 8.92}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 52.49, ["Ride"] = 65.63, ["Fly|Ride"] = 116.5, ["Neon"] = 328.13, ["Neon|Ride"] = 479.83, ["Neon|Fly|Ride"] = 424.46, ["Mega|Ride"] = 1419.08, ["Mega|Fly|Ride"] = 1903.79}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 36.74}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 230.58, ["Fly"] = 313.83, ["Ride"] = 246.79, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 3510.44, ["Neon|Fly|Ride"] = 1560.56}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 709.55, ["Ride"] = 840, ["Fly|Ride"] = 853.13, ["Neon|Ride"] = 3404.07, ["Neon|Fly|Ride"] = 3451.88, ["Mega|Fly|Ride"] = 11812.5}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 13.13}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 23.39, ["Fly"] = 52.43, ["Ride"] = 39.37, ["Fly|Ride"] = 62.36, ["Neon"] = 162.75, ["Neon|Fly"] = 212.77, ["Neon|Ride"] = 160.75, ["Neon|Fly|Ride"] = 216.57, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 765.19}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 11.82}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5250, ["Fly"] = 5815.63, ["Ride"] = 6382.61, ["Fly|Ride"] = 4441.5, ["Neon|Fly|Ride"] = 10498.69, ["Mega|Fly|Ride"] = 28875}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 13.13, ["Fly"] = 74.55, ["Ride"] = 20.98, ["Fly|Ride"] = 68.1, ["Neon"] = 97.13, ["Neon|Ride"] = 110.65, ["Neon|Fly|Ride"] = 195.57, ["Mega"] = 406.88, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 567.56}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 13.38, ["Fly"] = 197.87, ["Ride"] = 32.82, ["Fly|Ride"] = 118.78, ["Neon"] = 85.32, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 231, ["Mega"] = 1067.67, ["Mega|Ride"] = 526.58, ["Mega|Fly|Ride"] = 709.55}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 262.5, ["Fly"] = 139.21, ["Ride"] = 94.96, ["Fly|Ride"] = 187.68, ["Neon"] = 1419.08, ["Neon|Fly|Ride"] = 420, ["Mega"] = 4255.09}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 9.18, ["Ride"] = 32.99, ["Fly|Ride"] = 139.13, ["Neon"] = 78.75, ["Neon|Ride"] = 87.24, ["Neon|Fly|Ride"] = 462.53, ["Mega"] = 560.62, ["Mega|Ride"] = 417.03, ["Mega|Fly|Ride"] = 496.8}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 2126.25, ["Fly"] = 3121.11, ["Ride"] = 2306.66, ["Fly|Ride"] = 2114.07, ["Neon|Fly|Ride"] = 4331.25, ["Mega|Fly|Ride"] = 15079.32}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 34168.32, ["Fly"] = 35828.84, ["Ride"] = 35459.61, ["Fly|Ride"] = 22914.94, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 64611.75, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 198570.11}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 16.67, ["Fly"] = 393.75, ["Ride"] = 42, ["Fly|Ride"] = 71.29, ["Neon"] = 136.77, ["Neon|Ride"] = 174.57, ["Neon|Fly|Ride"] = 281.69, ["Mega"] = 851.03, ["Mega|Ride"] = 1102.5, ["Mega|Fly|Ride"] = 1397.82}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 2.5, ["Ride"] = 41.46, ["Fly|Ride"] = 65.63, ["Neon"] = 18.38, ["Neon|Fly"] = 134.39, ["Neon|Ride"] = 57.74, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 127.32, ["Mega|Ride"] = 137.82, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 19.57}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 9.19, ["Ride"] = 42, ["Fly|Ride"] = 111.57, ["Neon"] = 32.41, ["Neon|Ride"] = 71.29, ["Neon|Fly|Ride"] = 463.32, ["Mega"] = 370.54, ["Mega|Ride"] = 411.7, ["Mega|Fly|Ride"] = 546.79}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 734.02, ["Ride"] = 682.5, ["Fly|Ride"] = 786.19, ["Neon"] = 3039.9, ["Neon|Ride"] = 2567.95, ["Neon|Fly|Ride"] = 2520, ["Mega|Fly|Ride"] = 11197.12}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 918.74, ["Fly"] = 962.07, ["Ride"] = 1015.88, ["Fly|Ride"] = 945, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 3071.25}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 19.69, ["Fly"] = 119.98, ["Ride"] = 53.39, ["Fly|Ride"] = 85.12, ["Neon"] = 160.75, ["Neon|Ride"] = 160.76, ["Neon|Fly|Ride"] = 220.5, ["Mega"] = 987.29, ["Mega|Ride"] = 1522.5}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 31.46}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 69.57, ["Fly"] = 133.17, ["Ride"] = 71.99, ["Fly|Ride"] = 113.85, ["Neon|Ride"] = 397.87, ["Neon|Fly|Ride"] = 410.82, ["Mega|Ride"] = 1700.98, ["Mega|Fly|Ride"] = 1598.63}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 68.23, ["Ride"] = 84, ["Fly|Ride"] = 195.39, ["Neon"] = 397.87, ["Neon|Fly"] = 397.87, ["Neon|Ride"] = 610.62, ["Neon|Fly|Ride"] = 510.63, ["Mega"] = 1637.15, ["Mega|Fly|Ride"] = 1666.94}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 3.84, ["Fly"] = 32.78, ["Ride"] = 18.27, ["Fly|Ride"] = 56.6, ["Neon"] = 28.88, ["Neon|Fly"] = 320.3, ["Neon|Ride"] = 77.42, ["Neon|Fly|Ride"] = 125.54, ["Mega"] = 236.25, ["Mega|Fly"] = 340.41, ["Mega|Ride"] = 404.24, ["Mega|Fly|Ride"] = 371.44}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 85.12, ["Fly"] = 91.88, ["Ride"] = 91.88, ["Fly|Ride"] = 149.99, ["Neon"] = 821.24, ["Neon|Ride"] = 284.82, ["Neon|Fly|Ride"] = 308.44, ["Mega|Fly|Ride"] = 991.99}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 3.72, ["Ride"] = 35.44, ["Fly|Ride"] = 262.5, ["Neon"] = 26.25, ["Neon|Ride"] = 109.58, ["Mega"] = 158.82, ["Mega|Fly"] = 993.58, ["Mega|Ride"] = 312.52, ["Mega|Fly|Ride"] = 387.19}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 14.95, ["Fly"] = 37.25, ["Ride"] = 28.88, ["Fly|Ride"] = 65.63, ["Neon"] = 78.75, ["Neon|Fly"] = 106.39, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 141.8, ["Mega"] = 752.1, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 23.63, ["Ride"] = 67.03, ["Fly|Ride"] = 156.19, ["Neon"] = 212.77, ["Neon|Ride"] = 186.17, ["Mega|Ride"] = 1161.57, ["Mega|Fly|Ride"] = 709.55}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 10.35, ["Fly"] = 77.33, ["Ride"] = 24.93, ["Fly|Ride"] = 82.67, ["Neon"] = 103.69, ["Neon|Fly"] = 568.07, ["Neon|Ride"] = 100.06, ["Neon|Fly|Ride"] = 136.18, ["Mega|Ride"] = 947.84, ["Mega|Fly|Ride"] = 947.63}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6994.18, ["Ride"] = 5250, ["Fly|Ride"] = 5184.38, ["Neon"] = 34921.69, ["Neon|Fly|Ride"] = 24112.4}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 245.23, ["Fly"] = 255.29, ["Ride"] = 236.25, ["Fly|Ride"] = 280.88, ["Neon"] = 667, ["Neon|Ride"] = 659.53, ["Neon|Fly|Ride"] = 608.43, ["Mega|Fly|Ride"] = 2098.69}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 28.88, ["Fly"] = 85.12, ["Ride"] = 71.29, ["Fly|Ride"] = 120.44, ["Neon"] = 78.52, ["Neon|Fly"] = 157.54, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 195.57, ["Mega"] = 305.28, ["Mega|Fly"] = 385.88, ["Mega|Ride"] = 312.45, ["Mega|Fly|Ride"] = 394.78}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 3.28, ["Fly"] = 42.56, ["Ride"] = 18.38, ["Fly|Ride"] = 91.5, ["Neon"] = 21, ["Neon|Ride"] = 56.27, ["Neon|Fly|Ride"] = 193.62, ["Mega"] = 141.75, ["Mega|Ride"] = 157.5}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 39.38, ["Fly"] = 100.02, ["Ride"] = 96.96, ["Fly|Ride"] = 150.94, ["Neon"] = 116.82, ["Neon|Fly"] = 297.88, ["Neon|Ride"] = 124.9, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 418.69, ["Mega|Ride"] = 449.06, ["Mega|Fly|Ride"] = 560.44}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 10070.69, ["Ride"] = 15995.65, ["Fly|Ride"] = 11090.63, ["Neon|Fly|Ride"] = 23625, ["Mega|Fly|Ride"] = 92193.47}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 166.51, ["Ride"] = 196.02, ["Fly|Ride"] = 241.48, ["Neon"] = 848.91, ["Neon|Ride"] = 1135.05, ["Neon|Fly|Ride"] = 1130.8, ["Mega|Fly|Ride"] = 7197.64}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 47.11, ["Fly"] = 459.38, ["Ride"] = 60.1, ["Fly|Ride"] = 104.39, ["Neon|Fly"] = 479.83, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 295.32, ["Mega|Fly|Ride"] = 2023.88}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 10.49, ["Fly"] = 32.41, ["Ride"] = 24.24, ["Fly|Ride"] = 65.54, ["Neon"] = 72.19, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 2553.05, ["Mega|Fly|Ride"] = 548.13}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 389.82, ["Ride"] = 420, ["Fly|Ride"] = 503.88, ["Neon"] = 1639.31, ["Neon|Ride"] = 1311.19, ["Neon|Fly|Ride"] = 1276.53, ["Mega|Ride"] = 4724.98, ["Mega|Fly|Ride"] = 4935}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 6.17, ["Fly"] = 39.38, ["Ride"] = 35.26, ["Fly|Ride"] = 107.99, ["Neon"] = 26.18, ["Neon|Ride"] = 76.6, ["Neon|Fly|Ride"] = 282.98, ["Mega"] = 118.13, ["Mega|Ride"] = 142.55, ["Mega|Fly|Ride"] = 261.7}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 185.93, ["Fly"] = 393.75, ["Ride"] = 208.69, ["Fly|Ride"] = 288.75, ["Neon"] = 771.74, ["Neon|Ride"] = 761.25, ["Neon|Fly|Ride"] = 786.19, ["Mega|Ride"] = 5624.15, ["Mega|Fly|Ride"] = 2624.99}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 7.87, ["Fly"] = 20.98, ["Ride"] = 18.36, ["Fly|Ride"] = 32.41, ["Neon|Fly"] = 142.55, ["Neon|Ride"] = 119.97, ["Neon|Fly|Ride"] = 101.58, ["Mega"] = 786.19, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 9.19}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 57.75, ["Ride"] = 113.85, ["Fly|Ride"] = 525, ["Neon"] = 211.31, ["Neon|Fly"] = 1702.04, ["Neon|Ride"] = 425.52, ["Neon|Fly|Ride"] = 800.15, ["Mega"] = 1404.19, ["Mega|Ride"] = 1439.54, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 11.8, ["Fly"] = 62.41, ["Ride"] = 32.81, ["Fly|Ride"] = 84, ["Neon"] = 88.78, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 196.77, ["Mega"] = 482.95, ["Mega|Ride"] = 503.74, ["Mega|Fly|Ride"] = 557.82}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 15.7}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 27.41, ["Fly"] = 110.44, ["Ride"] = 78.75, ["Fly|Ride"] = 237.23, ["Neon"] = 173.14, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 275.52, ["Mega"] = 1135.05, ["Mega|Ride"] = 780.82, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.93, ["Ride"] = 26.25, ["Fly|Ride"] = 131.25, ["Neon"] = 23.61, ["Neon|Ride"] = 107.98, ["Neon|Fly|Ride"] = 127.66, ["Mega"] = 113.92, ["Mega|Fly|Ride"] = 639.85}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 11.81, ["Fly"] = 71.29, ["Ride"] = 30.18, ["Fly|Ride"] = 76.12, ["Neon|Ride"] = 138.3, ["Neon|Fly|Ride"] = 227.66, ["Mega"] = 708.48, ["Mega|Ride"] = 423.4, ["Mega|Fly|Ride"] = 759.94}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 301.88, ["Fly"] = 510.63, ["Ride"] = 315, ["Fly|Ride"] = 409.5, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 7801.68}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 38.17, ["Ride"] = 100.01, ["Fly|Ride"] = 103.67, ["Neon"] = 253.32, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 284.04, ["Mega"] = 702.59, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 764.87}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 45.83, ["Fly"] = 85.12, ["Ride"] = 74.82, ["Fly|Ride"] = 149.6, ["Neon"] = 198.95, ["Neon|Ride"] = 207.44, ["Neon|Fly|Ride"] = 424.46, ["Mega"] = 1280, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1163.77}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 27.56, ["Fly"] = 71.29, ["Ride"] = 74.79, ["Fly|Ride"] = 131.25, ["Neon"] = 100.82, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 283.99, ["Mega"] = 367.5, ["Mega|Ride"] = 405.57, ["Mega|Fly|Ride"] = 523.68}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 9843.75, ["Ride"] = 11516.3, ["Fly|Ride"] = 7481.25, ["Neon|Fly|Ride"] = 16398.8, ["Mega|Fly|Ride"] = 39372.9}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1706.25, ["Fly"] = 2034.38, ["Ride"] = 1680, ["Fly|Ride"] = 1706.25, ["Neon|Fly|Ride"] = 5217.56, ["Mega|Fly|Ride"] = 23100}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 391.13, ["Ride"] = 468.07, ["Fly|Ride"] = 446.25, ["Neon"] = 2127.56, ["Neon|Fly|Ride"] = 1914.8, ["Mega"] = 11996.06, ["Mega|Fly|Ride"] = 6636.86}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 15.06, ["Fly"] = 30.86, ["Ride"] = 22.31, ["Fly|Ride"] = 41.97, ["Neon"] = 127.66, ["Neon|Ride"] = 113.85, ["Neon|Fly|Ride"] = 105, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 6.57, ["Fly"] = 39.38, ["Ride"] = 61.69, ["Fly|Ride"] = 111.56, ["Neon"] = 28.73, ["Neon|Ride"] = 50.02, ["Mega"] = 144.38, ["Mega|Ride"] = 187.69, ["Mega|Fly|Ride"] = 276.6}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 36.1, ["Fly"] = 48.93, ["Ride"] = 43.62, ["Fly|Ride"] = 95.7, ["Neon"] = 189.37, ["Neon|Ride"] = 138.44, ["Neon|Fly|Ride"] = 164.07, ["Mega|Fly|Ride"] = 559.13}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.14, ["Fly"] = 27.2, ["Ride"] = 17.07, ["Fly|Ride"] = 34.01, ["Neon"] = 27.67, ["Neon|Fly"] = 63.68, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 68.25, ["Mega"] = 360.94, ["Mega|Ride"] = 305.31, ["Mega|Fly|Ride"] = 320.34}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 295.8, ["Fly"] = 320.24, ["Ride"] = 300.57, ["Fly|Ride"] = 341.25, ["Neon|Ride"] = 1799.33, ["Neon|Fly|Ride"] = 1413.92, ["Mega|Fly|Ride"] = 7446.38}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 26.25, ["Fly"] = 48.19, ["Ride"] = 26.25, ["Fly|Ride"] = 93.62, ["Neon"] = 143.97, ["Neon|Fly"] = 170.22, ["Neon|Ride"] = 142.54, ["Neon|Fly|Ride"] = 212.77, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 9.19, ["Fly"] = 21.29, ["Ride"] = 18.38, ["Fly|Ride"] = 34.12, ["Neon"] = 55.34, ["Neon|Fly"] = 136.5, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 115.77, ["Mega"] = 531.9, ["Mega|Ride"] = 586.16, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 568.05, ["Fly"] = 787.5, ["Ride"] = 446.25, ["Fly|Ride"] = 479.85, ["Neon|Ride"] = 2765.81, ["Mega|Fly|Ride"] = 8619.19}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1123.49, ["Fly"] = 1439.49, ["Ride"] = 1173.24, ["Fly|Ride"] = 1181.24, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 17162.82}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 95.99, ["Fly"] = 110.65, ["Ride"] = 98.44, ["Fly|Ride"] = 133.41, ["Neon"] = 971.25, ["Neon|Ride"] = 416.06, ["Neon|Fly|Ride"] = 422.63, ["Mega|Fly|Ride"] = 2099.99}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 183.75, ["Fly"] = 208.76, ["Ride"] = 183.75, ["Fly|Ride"] = 224.44, ["Neon"] = 709.55, ["Neon|Fly"] = 893.59, ["Neon|Ride"] = 705.87, ["Neon|Fly|Ride"] = 693, ["Mega"] = 5674.15, ["Mega|Ride"] = 8596.88, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 26.25, ["Fly"] = 131.25, ["Ride"] = 42, ["Fly|Ride"] = 131.25, ["Neon"] = 196.88, ["Neon|Fly"] = 425.52, ["Neon|Ride"] = 272.99, ["Neon|Fly|Ride"] = 369.14, ["Mega|Ride"] = 1844.58, ["Mega|Fly|Ride"] = 879.75}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 160.75, ["Ride"] = 210.74, ["Fly|Ride"] = 597.19, ["Mega|Fly|Ride"] = 3002.63}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2221.3, ["Ride"] = 2415, ["Fly|Ride"] = 2550.93, ["Neon|Fly|Ride"] = 7233.62, ["Mega|Fly|Ride"] = 48933.27}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 60.65, ["Ride"] = 49.65, ["Fly|Ride"] = 157.45, ["Neon"] = 292.56, ["Neon|Fly"] = 297.88, ["Neon|Ride"] = 212.77, ["Neon|Fly|Ride"] = 414.75, ["Mega"] = 2121.16, ["Mega|Ride"] = 2340.3, ["Mega|Fly|Ride"] = 1919.38}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 590.63, ["Fly"] = 675.94, ["Ride"] = 602.43, ["Fly|Ride"] = 643.13, ["Neon"] = 1276.53, ["Neon|Ride"] = 1266.57, ["Neon|Fly|Ride"] = 1246.88, ["Mega|Fly|Ride"] = 2950.5}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 57.18, ["Fly"] = 64.31, ["Ride"] = 59.06, ["Fly|Ride"] = 98.44, ["Neon"] = 196.88, ["Neon|Ride"] = 371.87, ["Neon|Fly|Ride"] = 233.63, ["Mega|Fly|Ride"] = 1169.63}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.84, ["Fly"] = 32.82, ["Ride"] = 19.94, ["Fly|Ride"] = 45.57, ["Neon"] = 23.63, ["Neon|Fly"] = 160.75, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 85.12, ["Mega"] = 124.67, ["Mega|Fly"] = 253.19, ["Mega|Ride"] = 169.32, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 44.86, ["Ride"] = 52.5, ["Fly|Ride"] = 131.25, ["Neon"] = 248.07, ["Neon|Ride"] = 270.21, ["Neon|Fly|Ride"] = 539.34, ["Mega|Ride"] = 1419.08, ["Mega|Fly|Ride"] = 955.47}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 504, ["Fly"] = 899.07, ["Ride"] = 538.13, ["Fly|Ride"] = 581.44, ["Neon"] = 2127.56, ["Neon|Ride"] = 1771.88, ["Neon|Fly|Ride"] = 1443.75, ["Mega|Fly|Ride"] = 4593.75}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 551.25, ["Ride"] = 525, ["Fly|Ride"] = 590.63, ["Neon"] = 5318.84, ["Neon|Ride"] = 4068.75, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 12796.19}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 17.04, ["Fly"] = 40.43, ["Ride"] = 24.94, ["Fly|Ride"] = 43.32, ["Neon"] = 212.77, ["Neon|Ride"] = 102.14, ["Neon|Fly|Ride"] = 116.82, ["Mega"] = 787.5, ["Mega|Fly|Ride"] = 640.6}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 6.57, ["Ride"] = 19.69, ["Fly|Ride"] = 67.04, ["Neon"] = 63.82, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 1699.91, ["Mega|Ride"] = 449.98, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 3.93, ["Ride"] = 34.32, ["Fly|Ride"] = 109.98, ["Neon"] = 19.69, ["Neon|Fly"] = 314.9, ["Neon|Ride"] = 57.72, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 175.32, ["Mega|Fly"] = 412.69, ["Mega|Ride"] = 157.45, ["Mega|Fly|Ride"] = 330.75}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 30.19, ["Fly"] = 63.79, ["Ride"] = 44.62, ["Fly|Ride"] = 90.56, ["Neon"] = 239.94, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 236.25, ["Mega|Fly|Ride"] = 901.59}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 39.37, ["Ride"] = 91.88, ["Fly|Ride"] = 449.61, ["Neon"] = 348.91, ["Neon|Ride"] = 407.69, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1560.56, ["Mega|Ride"] = 1560.56, ["Mega|Fly|Ride"] = 1280}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 18.38, ["Fly"] = 65.63, ["Ride"] = 31.49, ["Fly|Ride"] = 83.93, ["Neon"] = 110.91, ["Neon|Fly"] = 152.36, ["Neon|Ride"] = 108.81, ["Neon|Fly|Ride"] = 196.77, ["Mega"] = 425.52, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 28.77, ["Fly"] = 65.05, ["Ride"] = 38.06, ["Fly|Ride"] = 87.49, ["Neon"] = 411.7, ["Neon|Ride"] = 195.82, ["Neon|Fly|Ride"] = 230.99, ["Mega"] = 2100, ["Mega|Fly|Ride"] = 1199.63}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 2.63, ["Fly"] = 31.5, ["Ride"] = 13.13, ["Fly|Ride"] = 39.37, ["Neon"] = 28.6, ["Neon|Ride"] = 37.7, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 212.77, ["Mega|Ride"] = 261.7, ["Mega|Fly|Ride"] = 405.36}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 5.98, ["Fly"] = 44.7, ["Ride"] = 24.93, ["Fly|Ride"] = 67.24, ["Neon"] = 25.2, ["Neon|Fly"] = 160.75, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 190.32, ["Mega"] = 170.22, ["Mega|Fly"] = 482.96, ["Mega|Ride"] = 282.19, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 52.49, ["Fly"] = 60.37, ["Ride"] = 55.1, ["Fly|Ride"] = 80.85, ["Neon"] = 586.16, ["Neon|Ride"] = 261.7, ["Neon|Fly|Ride"] = 223.13, ["Mega|Fly|Ride"] = 918.64}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1995, ["Fly"] = 2231.25, ["Ride"] = 1819.13, ["Fly|Ride"] = 1798.13, ["Neon|Ride"] = 5317.78, ["Neon|Fly|Ride"] = 3916.5, ["Mega|Fly|Ride"] = 13460.92}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 446.25, ["Fly"] = 709.55, ["Ride"] = 493.41, ["Fly|Ride"] = 855.75, ["Neon"] = 3199.45, ["Neon|Ride"] = 3121.11, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 9771.78}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 262.5, ["Ride"] = 261.19, ["Fly|Ride"] = 438.38, ["Neon"] = 1202.53, ["Neon|Ride"] = 1179.94, ["Neon|Fly|Ride"] = 1544.61, ["Mega"] = 7446.38, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 32.8}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 30.19, ["Fly"] = 65.63, ["Ride"] = 55.18, ["Fly|Ride"] = 103.69, ["Neon"] = 206.07, ["Neon|Ride"] = 313.83, ["Neon|Fly|Ride"] = 319.14, ["Mega|Ride"] = 952.09, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 34040.54, ["Fly"] = 23625, ["Ride"] = 34781.25, ["Fly|Ride"] = 16232.6, ["Neon|Fly|Ride"] = 38062.5, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 320.25, ["Fly"] = 420, ["Ride"] = 398.93, ["Fly|Ride"] = 393.75, ["Neon"] = 1274.4, ["Neon|Fly"] = 1050, ["Neon|Ride"] = 1179.94, ["Neon|Fly|Ride"] = 1063.13, ["Mega"] = 6382.61, ["Mega|Ride"] = 6717.8, ["Mega|Fly|Ride"] = 3688}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 128.37, ["Fly"] = 142.55, ["Ride"] = 136.49, ["Fly|Ride"] = 160.76, ["Neon|Fly|Ride"] = 1063.78, ["Mega|Fly|Ride"] = 4255.09}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 103.68, ["Ride"] = 141.57, ["Fly|Ride"] = 157.5, ["Neon|Ride"] = 851.03, ["Neon|Fly|Ride"] = 1047.27, ["Mega"] = 14184.29, ["Mega|Fly|Ride"] = 5318.84}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 17.07, ["Fly"] = 67.04, ["Ride"] = 34.05, ["Fly|Ride"] = 80.39, ["Neon"] = 284.04, ["Neon|Ride"] = 135.19, ["Neon|Fly|Ride"] = 265.86, ["Mega"] = 709.55, ["Mega|Fly|Ride"] = 709.55}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 5118.58, ["Ride"] = 5118.75, ["Fly|Ride"] = 4594.43, ["Neon|Ride"] = 17020.27, ["Neon|Fly|Ride"] = 17729.82, ["Mega|Fly|Ride"] = 70918.14}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 20.1, ["Fly"] = 35.38, ["Ride"] = 30.3, ["Fly|Ride"] = 49.8, ["Neon"] = 333.94, ["Neon|Ride"] = 227.93, ["Neon|Fly|Ride"] = 204.24, ["Mega|Fly|Ride"] = 703.38}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 35.44, ["Fly"] = 142.54, ["Ride"] = 43.97, ["Fly|Ride"] = 101.07, ["Neon"] = 265.14, ["Neon|Fly"] = 1419.08, ["Neon|Ride"] = 142.55, ["Neon|Fly|Ride"] = 262.5, ["Mega|Fly|Ride"] = 1088.07}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 564.38, ["Fly"] = 751.04, ["Ride"] = 590.63, ["Fly|Ride"] = 714.09, ["Neon"] = 1706.25, ["Neon|Ride"] = 1652.46, ["Neon|Fly|Ride"] = 1458.19, ["Mega|Fly|Ride"] = 5249.99}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 18.36, ["Fly"] = 27.55, ["Ride"] = 28.73, ["Fly|Ride"] = 47.98, ["Neon"] = 98.44, ["Neon|Ride"] = 107.61, ["Neon|Fly|Ride"] = 137.36, ["Mega"] = 780.82, ["Mega|Fly|Ride"] = 523.68}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 13.13, ["Ride"] = 78.73, ["Fly|Ride"] = 479.87, ["Neon"] = 91.88, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 411.7, ["Mega|Ride"] = 575.84}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 102.38, ["Fly"] = 320.3, ["Ride"] = 134.06, ["Fly|Ride"] = 245.44, ["Neon"] = 680.82, ["Neon|Ride"] = 523.69, ["Neon|Fly|Ride"] = 719.78, ["Mega|Fly|Ride"] = 2812.69}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 22.31, ["Fly"] = 99.23, ["Ride"] = 78.75, ["Fly|Ride"] = 151.05, ["Neon"] = 95.37, ["Neon|Fly"] = 239.93, ["Neon|Ride"] = 141.03, ["Neon|Fly|Ride"] = 245.37, ["Mega"] = 292.69, ["Mega|Fly"] = 807.19, ["Mega|Ride"] = 317.46, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3255, ["Ride"] = 3570, ["Fly|Ride"] = 3340.32, ["Neon"] = 17062.5, ["Neon|Ride"] = 11036.38, ["Neon|Fly|Ride"] = 8518.13, ["Mega"] = 63826, ["Mega|Fly|Ride"] = 33333.14}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 41.99, ["Fly"] = 115.5, ["Ride"] = 63, ["Fly|Ride"] = 220.4, ["Neon"] = 191.94, ["Neon|Ride"] = 263.83, ["Neon|Fly|Ride"] = 400.68, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 7218.75, ["Ride"] = 7595.55, ["Fly|Ride"] = 5840.63, ["Neon|Fly|Ride"] = 17062.5, ["Mega|Fly|Ride"] = 63826}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.63, ["Fly"] = 20.9, ["Ride"] = 17.95, ["Fly|Ride"] = 36.75, ["Neon"] = 28.88, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 85.94, ["Mega"] = 326.59, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 20.22, ["Fly"] = 26.25, ["Ride"] = 30.19, ["Fly|Ride"] = 48.45, ["Neon"] = 118.78, ["Neon|Ride"] = 559.37, ["Neon|Fly|Ride"] = 142.55, ["Mega|Ride"] = 1247.55, ["Mega|Fly|Ride"] = 927.94}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.23}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 14.44, ["Ride"] = 39.38, ["Fly|Ride"] = 123.38, ["Neon"] = 142.55, ["Neon|Ride"] = 138.44, ["Neon|Fly|Ride"] = 281.93, ["Mega"] = 1050, ["Mega|Ride"] = 991.46, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 25.99, ["Fly"] = 262.5, ["Ride"] = 51.59, ["Fly|Ride"] = 71.29, ["Neon"] = 182.43, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 205.41, ["Mega"] = 840, ["Mega|Ride"] = 959.69, ["Mega|Fly|Ride"] = 931.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 11.82, ["Fly"] = 25.86, ["Ride"] = 18, ["Fly|Ride"] = 34.91, ["Neon"] = 141.61, ["Neon|Ride"] = 112.77, ["Neon|Fly|Ride"] = 170.22, ["Mega"] = 820.32, ["Mega|Ride"] = 598.62, ["Mega|Fly|Ride"] = 689.79}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8467.59}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2716.11}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 21.93}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 160.54, ["Fly"] = 174.57, ["Ride"] = 189, ["Fly|Ride"] = 787.5, ["Neon|Ride"] = 993.58}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 21.29, ["Fly"] = 134.06, ["Ride"] = 32.82, ["Fly|Ride"] = 320.33, ["Neon"] = 113.82, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 464.26, ["Mega"] = 922.29, ["Mega|Ride"] = 892.5, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 8.67}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 9.19, ["Ride"] = 26.25, ["Neon|Ride"] = 85.12, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2572.5}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 231, ["Ride"] = 223.13, ["Fly|Ride"] = 416.3, ["Neon"] = 748.13, ["Neon|Ride"] = 918.75, ["Mega|Ride"] = 3532.78, ["Mega|Fly|Ride"] = 3513.64}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 127.32, ["Ride"] = 183.75, ["Fly|Ride"] = 320.33, ["Neon|Ride"] = 752.1, ["Neon|Fly|Ride"] = 709.55, ["Mega|Ride"] = 2778.57, ["Mega|Fly|Ride"] = 2387.44}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 177.18, ["Fly"] = 270.21, ["Ride"] = 169.32, ["Fly|Ride"] = 221.82, ["Neon"] = 799.32, ["Neon|Ride"] = 840, ["Neon|Fly|Ride"] = 842.03, ["Mega"] = 4680.59, ["Mega|Fly|Ride"] = 3493.88}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1439.49, ["Fly"] = 2553.05, ["Ride"] = 1089.37, ["Fly|Ride"] = 1286.25, ["Neon"] = 5390.12, ["Neon|Ride"] = 4331.25, ["Neon|Fly|Ride"] = 4462.5, ["Mega|Fly|Ride"] = 28367.48}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 17.57, ["Fly"] = 82.99, ["Ride"] = 39.38, ["Fly|Ride"] = 86.63, ["Neon"] = 127.26, ["Neon|Ride"] = 85.12, ["Neon|Fly|Ride"] = 320.25, ["Mega"] = 849.97, ["Mega|Fly|Ride"] = 952.09}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 638.27, ["Fly"] = 2100, ["Ride"] = 759.84, ["Fly|Ride"] = 800.17, ["Neon|Fly|Ride"] = 2695.6}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 62.36}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 14.18, ["Fly"] = 393.75, ["Ride"] = 43.32, ["Fly|Ride"] = 98.44, ["Neon"] = 99.75, ["Neon|Ride"] = 142.55, ["Neon|Fly|Ride"] = 496.8, ["Mega"] = 378.72, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 878.13}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 6.56, ["Fly"] = 131.25, ["Ride"] = 27.57, ["Fly|Ride"] = 94.5, ["Neon"] = 64.79, ["Neon|Ride"] = 83.61, ["Neon|Fly|Ride"] = 210, ["Mega"] = 918.75, ["Mega|Ride"] = 485.63, ["Mega|Fly|Ride"] = 619.5}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 73.5}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 21, ["Ride"] = 36.09, ["Fly|Ride"] = 71.29, ["Neon"] = 196.88, ["Neon|Ride"] = 159.58, ["Neon|Fly|Ride"] = 608.22, ["Mega"] = 824.43, ["Mega|Fly|Ride"] = 1276.53}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 24.49, ["Fly"] = 55.34, ["Ride"] = 30.18, ["Fly|Ride"] = 67.04, ["Neon"] = 91.88, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 237.23, ["Neon|Fly|Ride"] = 274.32, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 5757.94, ["Fly"] = 6238, ["Ride"] = 6486.87, ["Fly|Ride"] = 4921.88, ["Neon|Ride"] = 17445.79, ["Neon|Fly|Ride"] = 10078.69, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 13.13, ["Fly"] = 34.13, ["Ride"] = 32.82, ["Fly|Ride"] = 100.02, ["Neon"] = 65.62, ["Neon|Ride"] = 100.02, ["Neon|Fly|Ride"] = 355.3, ["Mega"] = 537.45, ["Mega|Ride"] = 441.49, ["Mega|Fly|Ride"] = 417.38}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 22.32}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 115.5, ["Fly"] = 376.6, ["Ride"] = 174.46, ["Fly|Ride"] = 235.11, ["Neon"] = 418.69, ["Neon|Ride"] = 481.69, ["Neon|Fly|Ride"] = 551.25, ["Mega|Ride"] = 4255.09, ["Mega|Fly|Ride"] = 2034.38}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 52.47, ["Ride"] = 105, ["Fly|Ride"] = 153.57, ["Neon"] = 327.6, ["Neon|Ride"] = 320.25, ["Neon|Fly|Ride"] = 511.88, ["Mega|Ride"] = 2871.11}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 20.74, ["Fly"] = 72.17, ["Ride"] = 30.19, ["Fly|Ride"] = 46.98, ["Neon"] = 206.36, ["Neon|Ride"] = 127.65, ["Neon|Fly|Ride"] = 189, ["Mega|Ride"] = 909.54, ["Mega|Fly|Ride"] = 656.22}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 6.36, ["Fly"] = 49.76, ["Ride"] = 32.37, ["Fly|Ride"] = 68.25, ["Neon"] = 22.13, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 166.27, ["Mega"] = 131.12, ["Mega|Fly"] = 7034.11, ["Mega|Ride"] = 142.55, ["Mega|Fly|Ride"] = 263.82}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 9.09, ["Fly"] = 42.56, ["Ride"] = 32.97, ["Fly|Ride"] = 62.99, ["Neon"] = 92.56, ["Neon|Ride"] = 82.69, ["Neon|Fly|Ride"] = 212.77, ["Mega"] = 373.4, ["Mega|Ride"] = 410.82, ["Mega|Fly|Ride"] = 538.13}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 17.64, ["Fly"] = 28.8, ["Ride"] = 28.88, ["Fly|Ride"] = 43.32, ["Neon"] = 208.71, ["Neon|Ride"] = 138.96, ["Neon|Fly|Ride"] = 118.13, ["Mega|Fly|Ride"] = 663.8}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 212.63}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 21.29, ["Ride"] = 100.02, ["Fly|Ride"] = 128.38, ["Neon"] = 164.07, ["Neon|Ride"] = 425.52, ["Mega"] = 957.41, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 1699.91}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 125.63, ["Ride"] = 103.69, ["Fly|Ride"] = 262.5, ["Neon"] = 568.07, ["Neon|Ride"] = 820.32}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 38.7, ["Fly"] = 211.99, ["Ride"] = 65.63, ["Fly|Ride"] = 236.41, ["Neon"] = 295.21, ["Neon|Fly"] = 482.96, ["Neon|Ride"] = 355.31, ["Neon|Fly|Ride"] = 420, ["Mega"] = 1148.88, ["Mega|Ride"] = 2240.87, ["Mega|Fly|Ride"] = 1169.44}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 761.25, ["Fly"] = 780.94, ["Ride"] = 721.87, ["Fly|Ride"] = 771.44, ["Neon|Ride"] = 3281.25, ["Neon|Fly|Ride"] = 2582.58, ["Mega|Ride"] = 8227.19, ["Mega|Fly|Ride"] = 8749.13}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 393.75, ["Ride"] = 409.5, ["Fly|Ride"] = 529.05, ["Neon"] = 1560.56, ["Neon|Ride"] = 2080.02, ["Neon|Fly|Ride"] = 1560.56, ["Mega"] = 8403.77, ["Mega|Fly|Ride"] = 8137.5}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 76.13}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 9.97, ["Fly"] = 31.5, ["Ride"] = 24.87, ["Fly|Ride"] = 56.44, ["Neon"] = 72.19, ["Neon|Fly"] = 230.99, ["Neon|Ride"] = 97.5, ["Neon|Fly|Ride"] = 127.66, ["Mega"] = 595.73, ["Mega|Ride"] = 568.07, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 275.63, ["Fly"] = 404.24, ["Ride"] = 360.94, ["Fly|Ride"] = 395.69, ["Neon"] = 1086.75, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 918.75, ["Mega|Fly|Ride"] = 3457.6}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 18.38}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 118.09, ["Fly"] = 590.63, ["Ride"] = 195.57, ["Fly|Ride"] = 273, ["Neon"] = 590.63, ["Neon|Fly"] = 1702.04, ["Neon|Ride"] = 634.4, ["Neon|Fly|Ride"] = 707.44, ["Mega"] = 1985.01, ["Mega|Ride"] = 2028.63, ["Mega|Fly|Ride"] = 1965.57}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 156.19, ["Ride"] = 157.5, ["Fly|Ride"] = 275.63, ["Neon|Ride"] = 997.5}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 6.29, ["Ride"] = 28.73, ["Fly|Ride"] = 212.77, ["Neon"] = 40.44, ["Neon|Ride"] = 51.19, ["Mega"] = 210, ["Mega|Ride"] = 320.31, ["Mega|Fly|Ride"] = 395.73}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 17.9, ["Fly"] = 63, ["Ride"] = 28.88, ["Fly|Ride"] = 65.63, ["Neon"] = 98.98, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 160.76, ["Mega|Ride"] = 561.69, ["Mega|Fly|Ride"] = 568.07}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 20.98, ["Fly"] = 131.25, ["Ride"] = 48, ["Fly|Ride"] = 141.39, ["Neon"] = 99.75, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 424.45, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 959.69}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 6.39, ["Fly"] = 72.19, ["Ride"] = 32.26, ["Fly|Ride"] = 111.18, ["Neon"] = 26.17, ["Neon|Ride"] = 57.46, ["Neon|Fly|Ride"] = 178.23, ["Mega"] = 131.25, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 265.12}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 273, ["Fly"] = 918.75, ["Ride"] = 301.88, ["Fly|Ride"] = 393.75, ["Neon"] = 1560.56, ["Neon|Ride"] = 1214.07, ["Neon|Fly|Ride"] = 1424.07, ["Mega|Fly|Ride"] = 5148.65}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 116.82, ["Fly"] = 1050, ["Ride"] = 186.38, ["Fly|Ride"] = 249.36, ["Neon"] = 456.74, ["Neon|Ride"] = 459.37, ["Neon|Fly|Ride"] = 522.2, ["Mega"] = 1792.88, ["Mega|Ride"] = 1836.08, ["Mega|Fly|Ride"] = 1704.94}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 81.38, ["Fly"] = 167.45, ["Ride"] = 84, ["Fly|Ride"] = 128.63, ["Neon"] = 315, ["Neon|Ride"] = 401.63, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 1758.75}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 19.69, ["Ride"] = 58.24, ["Fly|Ride"] = 284.04, ["Neon|Ride"] = 609.38, ["Neon|Fly|Ride"] = 496.8, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 13.12, ["Fly"] = 75.62, ["Ride"] = 38.07, ["Fly|Ride"] = 102.38, ["Neon"] = 90.96, ["Neon|Ride"] = 113.85, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 425.91, ["Mega|Fly"] = 525, ["Mega|Ride"] = 438.38, ["Mega|Fly|Ride"] = 443.63}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 2.63, ["Fly"] = 45.83, ["Ride"] = 21, ["Fly|Ride"] = 65.63, ["Neon"] = 19.03, ["Neon|Ride"] = 37.2, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 108.71, ["Mega|Ride"] = 128.63, ["Mega|Fly|Ride"] = 266.76}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 964.69, ["Fly"] = 1275.47, ["Ride"] = 984.38, ["Fly|Ride"] = 1036.88, ["Neon"] = 3007.12, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2467.5, ["Mega|Fly|Ride"] = 9177}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 420, ["Ride"] = 406.88, ["Fly|Ride"] = 517.13, ["Neon"] = 1702.04, ["Neon|Ride"] = 1680, ["Neon|Fly|Ride"] = 1419.08, ["Mega"] = 10637.67, ["Mega|Fly|Ride"] = 5814.57}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 92.56, ["Ride"] = 105.55, ["Fly|Ride"] = 164.51, ["Neon"] = 282.19, ["Neon|Ride"] = 328.12, ["Neon|Fly|Ride"] = 411.66, ["Mega|Ride"] = 1419.08, ["Mega|Fly|Ride"] = 1468.02}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 288.75, ["Fly"] = 340.41, ["Ride"] = 296.63, ["Fly|Ride"] = 336, ["Neon|Ride"] = 1115.63, ["Neon|Fly|Ride"] = 1248.87, ["Mega"] = 10637.67, ["Mega|Fly|Ride"] = 4199.99}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 26.24, ["Fly"] = 142.55, ["Ride"] = 39.08, ["Fly|Ride"] = 85.1, ["Neon"] = 157.49, ["Neon|Ride"] = 108.51, ["Neon|Fly|Ride"] = 169.16, ["Mega"] = 1419.08, ["Mega|Ride"] = 800.15, ["Mega|Fly|Ride"] = 618.87}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 217.88, ["Ride"] = 292.51, ["Fly|Ride"] = 314.79, ["Neon"] = 1584.98, ["Neon|Ride"] = 1700.98, ["Neon|Fly|Ride"] = 2411.57, ["Mega"] = 4234.11}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 88.31, ["Fly"] = 126, ["Ride"] = 65.62, ["Fly|Ride"] = 142.55, ["Neon"] = 425.52, ["Neon|Ride"] = 508.5, ["Neon|Fly|Ride"] = 567.99, ["Mega|Fly|Ride"] = 1397.82}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1312.5, ["Ride"] = 1378.13, ["Fly|Ride"] = 1443.75, ["Neon"] = 4964.61, ["Neon|Fly|Ride"] = 6793.22, ["Mega"] = 51060.8, ["Mega|Fly|Ride"] = 24679.4}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 14.41, ["Fly"] = 80.87, ["Ride"] = 30.81, ["Fly|Ride"] = 97.13, ["Neon"] = 59.06, ["Neon|Fly"] = 170.22, ["Neon|Ride"] = 61.2, ["Neon|Fly|Ride"] = 141.8, ["Mega"] = 253.32, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 408.43}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 64.8, ["Fly"] = 78.75, ["Ride"] = 84, ["Fly|Ride"] = 161.44, ["Neon"] = 315, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 320.31, ["Mega|Ride"] = 1153.14, ["Mega|Fly|Ride"] = 1458.19}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 84, ["Fly"] = 91.88, ["Ride"] = 82.69, ["Fly|Ride"] = 100.37, ["Neon|Ride"] = 410.82, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 1551.96}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 1135.05, ["Ride"] = 918.75, ["Fly|Ride"] = 1100.46, ["Neon|Fly|Ride"] = 4199.99, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 465.94, ["Fly"] = 848.91, ["Ride"] = 355.31, ["Fly|Ride"] = 525, ["Neon|Fly|Ride"] = 2021.17, ["Mega"] = 10637.67, ["Mega|Fly|Ride"] = 14395.27}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 95.82, ["Fly"] = 138.3, ["Ride"] = 131.25, ["Fly|Ride"] = 232.49, ["Neon"] = 595.73, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 571.43, ["Mega"] = 4255.09, ["Mega|Ride"] = 2695.6, ["Mega|Fly|Ride"] = 2080.14}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 8.5, ["Fly"] = 39.38, ["Ride"] = 19.67, ["Fly|Ride"] = 61.69, ["Neon"] = 90.46, ["Neon|Ride"] = 132.57, ["Neon|Fly|Ride"] = 233.63, ["Mega"] = 656.25, ["Mega|Ride"] = 723.29, ["Mega|Fly|Ride"] = 1033.99}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 40.68, ["Fly"] = 79.8, ["Ride"] = 48.57, ["Fly|Ride"] = 91.88, ["Neon"] = 191.49, ["Neon|Fly"] = 424.46, ["Neon|Ride"] = 225.53, ["Neon|Fly|Ride"] = 282.98, ["Mega"] = 1844.58, ["Mega|Ride"] = 1105.27, ["Mega|Fly|Ride"] = 1049.99}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 741.57, ["Ride"] = 872.82, ["Fly|Ride"] = 936.86, ["Neon"] = 2837.08, ["Neon|Ride"] = 2828.44, ["Neon|Fly|Ride"] = 2756.25, ["Mega|Fly|Ride"] = 20705.19}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 892.49}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 4921.88, ["Ride"] = 4608.19, ["Fly|Ride"] = 4458.57, ["Neon|Ride"] = 30488.62, ["Neon|Fly|Ride"] = 21806.16, ["Mega|Fly|Ride"] = 90775.47}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 144.38, ["Fly"] = 284.04, ["Ride"] = 284.04, ["Neon"] = 1702.04, ["Neon|Ride"] = 1063.78, ["Neon|Fly|Ride"] = 1419.08, ["Mega"] = 5957.11, ["Mega|Fly|Ride"] = 5674.15}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 83.6, ["Fly"] = 284.04, ["Ride"] = 77.44, ["Fly|Ride"] = 336, ["Neon"] = 425.52, ["Neon|Ride"] = 510.63, ["Neon|Fly|Ride"] = 993.58, ["Mega|Fly|Ride"] = 2838.13}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 13.13, ["Fly"] = 57.46, ["Ride"] = 35.25, ["Fly|Ride"] = 80.32, ["Neon"] = 98.44, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 708.48, ["Mega|Ride"] = 610.62, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 18.72, ["Fly"] = 28.81, ["Ride"] = 26.23, ["Fly|Ride"] = 45.94, ["Neon|Ride"] = 142.55, ["Neon|Fly|Ride"] = 177.18, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 845.71}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 22.32, ["Fly"] = 71.29, ["Ride"] = 34.06, ["Fly|Ride"] = 65.63, ["Neon"] = 126, ["Neon|Ride"] = 142.55, ["Neon|Fly|Ride"] = 226.41, ["Mega|Ride"] = 568.07, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 5.25, ["Fly"] = 57.46, ["Ride"] = 20.97, ["Fly|Ride"] = 38.07, ["Neon"] = 35.13, ["Neon|Ride"] = 40.43, ["Neon|Fly|Ride"] = 126.86, ["Mega"] = 695.67, ["Mega|Ride"] = 225.53, ["Mega|Fly|Ride"] = 319.14}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 31.5, ["Ride"] = 70.23, ["Fly|Ride"] = 160.76, ["Neon"] = 165.97, ["Neon|Fly"] = 851.03, ["Neon|Ride"] = 160.13, ["Neon|Fly|Ride"] = 251.06, ["Mega"] = 702.1, ["Mega|Ride"] = 709.55, ["Mega|Fly|Ride"] = 861.67}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 290.58, ["Fly"] = 355.68, ["Ride"] = 283.05, ["Fly|Ride"] = 288.75, ["Neon"] = 1050, ["Neon|Fly"] = 957.41, ["Neon|Ride"] = 761.25, ["Neon|Fly|Ride"] = 735, ["Mega"] = 6562.5, ["Mega|Fly|Ride"] = 3529.59}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.41, ["Fly"] = 22.57, ["Ride"] = 17.07, ["Fly|Ride"] = 36.75, ["Neon"] = 27.67, ["Neon|Ride"] = 27.98, ["Neon|Fly|Ride"] = 66.94, ["Mega"] = 183.75, ["Mega|Ride"] = 221.17, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 33.08, ["Fly"] = 98.78, ["Ride"] = 78.75, ["Fly|Ride"] = 110.25, ["Neon"] = 181.13, ["Neon|Fly"] = 399, ["Neon|Ride"] = 190.32, ["Neon|Fly|Ride"] = 251.99, ["Mega"] = 564.27, ["Mega|Fly"] = 695.72, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 708.65, ["Fly"] = 959.7, ["Ride"] = 721.88, ["Fly|Ride"] = 838.69, ["Neon"] = 1702.04, ["Neon|Ride"] = 1575, ["Neon|Fly|Ride"] = 1666.88, ["Mega|Fly|Ride"] = 4003.13}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 32.81, ["Fly"] = 107.63, ["Ride"] = 44.07, ["Fly|Ride"] = 91.87, ["Neon|Fly"] = 479.83, ["Neon|Ride"] = 177.18, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 1575, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 602.44}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 301.88, ["Fly"] = 341.25, ["Ride"] = 241.49, ["Fly|Ride"] = 325.5, ["Neon"] = 1248.87, ["Neon|Ride"] = 957.41, ["Neon|Fly|Ride"] = 945, ["Mega|Fly|Ride"] = 5318.84}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 138.3, ["Fly"] = 204.26, ["Ride"] = 137.44, ["Fly|Ride"] = 157.5, ["Neon"] = 638.27, ["Neon|Fly"] = 646.78, ["Neon|Ride"] = 510.63, ["Neon|Fly|Ride"] = 485.63, ["Mega|Fly|Ride"] = 2318.75}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 590.63, ["Ride"] = 599.37, ["Fly|Ride"] = 669.38, ["Neon|Fly|Ride"] = 1979.69, ["Mega|Fly|Ride"] = 7217.44}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 18.01, ["Ride"] = 53.17, ["Fly|Ride"] = 157.45, ["Neon"] = 98.44, ["Neon|Fly"] = 287.9, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 278.33, ["Mega"] = 304.7, ["Mega|Ride"] = 337.84, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 4039.38, ["Fly"] = 4071.51, ["Ride"] = 3936.19, ["Fly|Ride"] = 3129, ["Neon|Fly|Ride"] = 6562.5, ["Mega|Fly|Ride"] = 25058.25}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 82.69, ["Fly"] = 178.5, ["Ride"] = 98.44, ["Fly|Ride"] = 131.25, ["Neon"] = 479.87, ["Neon|Ride"] = 421.28, ["Neon|Fly|Ride"] = 437.29, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.37, ["Fly"] = 31.92, ["Ride"] = 19.15, ["Fly|Ride"] = 84, ["Neon"] = 19.69, ["Neon|Fly"] = 45.05, ["Neon|Ride"] = 36.19, ["Neon|Fly|Ride"] = 84.26, ["Mega"] = 139.12, ["Mega|Fly"] = 452.82, ["Mega|Ride"] = 233.89, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.14, ["Ride"] = 28.49, ["Fly|Ride"] = 62.99, ["Neon"] = 19.21, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 53.82, ["Neon|Fly|Ride"] = 266.44, ["Mega"] = 173.42, ["Mega|Ride"] = 199.47, ["Mega|Fly|Ride"] = 278.2}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 53.81, ["Fly"] = 82.85, ["Ride"] = 52.69, ["Fly|Ride"] = 59.06, ["Neon|Ride"] = 212.77, ["Neon|Fly|Ride"] = 306.37, ["Mega|Fly|Ride"] = 1404.19}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 993.58, ["Ride"] = 1174.69, ["Fly|Ride"] = 1276.53, ["Neon"] = 5546.49, ["Neon|Fly|Ride"] = 5248.64, ["Mega|Fly|Ride"] = 22694.4}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 5184.37, ["Ride"] = 5998.08, ["Fly|Ride"] = 5249.99}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 19.67, ["Fly"] = 23.63, ["Ride"] = 24.94, ["Fly|Ride"] = 41.64, ["Neon"] = 105.33, ["Neon|Ride"] = 85.12, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 2428.13, ["Mega|Fly|Ride"] = 539.34}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 14.44, ["Fly"] = 47.95, ["Ride"] = 40.03, ["Fly|Ride"] = 80.07, ["Neon"] = 85.12, ["Neon|Fly"] = 142.55, ["Neon|Ride"] = 83.27, ["Neon|Fly|Ride"] = 175.62, ["Mega"] = 933.52, ["Mega|Ride"] = 393.74, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 39.38, ["Fly"] = 47.99, ["Ride"] = 54.36, ["Fly|Ride"] = 72.01, ["Neon"] = 271.24, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 275.39, ["Mega|Fly|Ride"] = 984.38}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 232.31, ["Fly"] = 320.3, ["Ride"] = 241.32, ["Fly|Ride"] = 252.1, ["Neon|Ride"] = 976.5, ["Neon|Fly|Ride"] = 945, ["Mega"] = 10637.67, ["Mega|Fly|Ride"] = 3530.65}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 5.25, ["Ride"] = 39.38, ["Fly|Ride"] = 86.63, ["Neon"] = 21.61, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 85.12, ["Neon|Fly|Ride"] = 249.53, ["Mega"] = 115.5, ["Mega|Ride"] = 253.32, ["Mega|Fly|Ride"] = 374.29}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 189, ["Fly"] = 239.85, ["Ride"] = 223.55, ["Fly|Ride"] = 275.63, ["Neon"] = 808.5, ["Neon|Ride"] = 719.78, ["Neon|Fly|Ride"] = 786.19, ["Mega|Fly|Ride"] = 3973.18}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 2.63, ["Fly"] = 24.1, ["Ride"] = 16.99, ["Fly|Ride"] = 39.37, ["Neon"] = 13.13, ["Neon|Fly"] = 52.49, ["Neon|Ride"] = 27.15, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 210, ["Mega|Ride"] = 196.27, ["Mega|Fly|Ride"] = 270.85}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 183.75, ["Fly"] = 268.82, ["Ride"] = 246.75, ["Fly|Ride"] = 261.19, ["Neon|Ride"] = 1276.53, ["Neon|Fly|Ride"] = 1115.63, ["Mega"] = 10637.67, ["Mega|Ride"] = 6382.61, ["Mega|Fly|Ride"] = 7797.44}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 15.74, ["Fly"] = 26.25, ["Ride"] = 30.86, ["Fly|Ride"] = 65.63, ["Neon"] = 92.56, ["Neon|Fly"] = 304.69, ["Neon|Ride"] = 139.37, ["Neon|Fly|Ride"] = 277.12, ["Mega"] = 522.41, ["Mega|Ride"] = 568.07, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.1, ["Ride"] = 84.05, ["Neon"] = 15.15, ["Neon|Fly"] = 67.03, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 89.14, ["Mega"] = 76.11, ["Mega|Ride"] = 130.83, ["Mega|Fly|Ride"] = 204.75}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.05, ["Mega"] = 22.32, ["Mega|Ride"] = 141.57}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 3.6, ["Ride"] = 261.19, ["Fly|Ride"] = 142.54, ["Neon"] = 9.98, ["Neon|Ride"] = 239.94, ["Neon|Fly|Ride"] = 121.29, ["Mega"] = 88.88, ["Mega|Fly"] = 159948.03, ["Mega|Ride"] = 95.99, ["Mega|Fly|Ride"] = 181.33}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 65.02, ["Fly"] = 140.41, ["Ride"] = 109.94, ["Fly|Ride"] = 190.32, ["Neon"] = 268.09, ["Neon|Fly"] = 263.17, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 330.68, ["Mega|Fly|Ride"] = 1052.65}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 40.69, ["Ride"] = 15.89, ["Fly|Ride"] = 41.14, ["Neon"] = 3.94, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 105, ["Mega"] = 95.1, ["Mega|Ride"] = 98.34, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 8.93, ["Ride"] = 24.94, ["Fly|Ride"] = 197.87, ["Neon"] = 74.82, ["Neon|Ride"] = 128.37, ["Mega"] = 485.63, ["Mega|Ride"] = 523.69}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Ride"] = 30.86, ["Neon"] = 2.5, ["Neon|Ride"] = 28.48, ["Neon|Fly|Ride"] = 278.25, ["Mega"] = 17.43, ["Mega|Ride"] = 54.17, ["Mega|Fly|Ride"] = 131.15}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 20.9, ["Ride"] = 18, ["Fly|Ride"] = 34.55, ["Neon"] = 2.1, ["Neon|Fly"] = 36.01, ["Neon|Ride"] = 13.13, ["Neon|Fly|Ride"] = 40.8, ["Mega"] = 15.75, ["Mega|Fly"] = 30.19, ["Mega|Ride"] = 24.68, ["Mega|Fly|Ride"] = 58.56}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 13.13, ["Fly|Ride"] = 23.63, ["Neon"] = 2.1, ["Neon|Fly"] = 15.54, ["Neon|Ride"] = 17.64, ["Neon|Fly|Ride"] = 48, ["Mega"] = 28.03, ["Mega|Ride"] = 65.97, ["Mega|Fly|Ride"] = 78.73}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Ride"] = 21.39, ["Fly|Ride"] = 125.73, ["Neon"] = 2.37, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 39.38, ["Mega"] = 26.25, ["Mega|Ride"] = 146.96, ["Mega|Fly|Ride"] = 308.52}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 118.07, ["Ride"] = 19.69, ["Fly|Ride"] = 107.63, ["Neon"] = 3.61, ["Neon|Fly"] = 135.03, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 64.32, ["Mega"] = 37.17, ["Mega|Fly"] = 85.32, ["Mega|Ride"] = 53.82, ["Mega|Fly|Ride"] = 168.09}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 5.72, ["Neon|Fly|Ride"] = 204.75, ["Mega"] = 21, ["Mega|Ride"] = 82.58}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 2.1, ["Fly"] = 47.16, ["Ride"] = 32.82, ["Fly|Ride"] = 47.25, ["Neon"] = 5.54, ["Neon|Fly"] = 49.26, ["Neon|Ride"] = 32.41, ["Neon|Fly|Ride"] = 95.99, ["Mega"] = 52.91, ["Mega|Fly"] = 208.51, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 107.52}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 48.95, ["Neon"] = 2.1, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 313.84, ["Mega"] = 15.32, ["Mega|Ride"] = 44.63, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Fly|Ride"] = 525, ["Neon"] = 47.67, ["Mega"] = 208.51, ["Mega|Fly"] = 314.99, ["Mega|Ride"] = 344.97}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Ride"] = 42.56, ["Neon"] = 13.13, ["Mega"] = 105, ["Mega|Fly|Ride"] = 381.91}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 71.29, ["Neon"] = 5.25, ["Neon|Ride"] = 37.71, ["Neon|Fly|Ride"] = 85.12, ["Mega"] = 21.19, ["Mega|Ride"] = 70.23, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 10.84, ["Ride"] = 18.84, ["Fly|Ride"] = 28.6, ["Neon"] = 2.1, ["Neon|Fly"] = 42.56, ["Neon|Ride"] = 13.71, ["Neon|Fly|Ride"] = 39.29, ["Mega"] = 15.73, ["Mega|Fly"] = 53.2, ["Mega|Ride"] = 24.49, ["Mega|Fly|Ride"] = 60.38}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.1, ["Fly"] = 72.19, ["Ride"] = 42, ["Fly|Ride"] = 104.98, ["Neon"] = 32.82, ["Neon|Ride"] = 39.83, ["Mega"] = 255.32, ["Mega|Fly"] = 284.04, ["Mega|Ride"] = 274.55, ["Mega|Fly|Ride"] = 693.58}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Fly"] = 28.73, ["Ride"] = 42, ["Fly|Ride"] = 78.73, ["Neon"] = 5.25, ["Neon|Ride"] = 31.17, ["Neon|Fly|Ride"] = 158.06, ["Mega"] = 34.13, ["Mega|Ride"] = 51.18, ["Mega|Fly|Ride"] = 160.13}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 2.63, ["Neon"] = 13.13, ["Neon|Fly|Ride"] = 142.55, ["Mega"] = 78.73, ["Mega|Ride"] = 165.97, ["Mega|Fly|Ride"] = 220.5}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.37, ["Fly"] = 131.25, ["Ride"] = 32.81, ["Fly|Ride"] = 193.62, ["Neon"] = 10.59, ["Neon|Ride"] = 71.29, ["Neon|Fly|Ride"] = 142.55, ["Mega"] = 91.5, ["Mega|Ride"] = 85.3, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 12.73, ["Fly|Ride"] = 28.67, ["Neon"] = 2.1, ["Neon|Fly"] = 15.74, ["Neon|Ride"] = 15.37, ["Neon|Fly|Ride"] = 32.41, ["Mega"] = 15.94, ["Mega|Fly"] = 40.44, ["Mega|Ride"] = 22.32, ["Mega|Fly|Ride"] = 51.08}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 23.94, ["Ride"] = 21.29, ["Fly|Ride"] = 72.19, ["Neon"] = 15.61, ["Neon|Ride"] = 115.18, ["Neon|Fly|Ride"] = 67.04, ["Mega"] = 78.75, ["Mega|Fly|Ride"] = 196.77}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 4.81, ["Fly"] = 41.91, ["Ride"] = 23.42, ["Fly|Ride"] = 141.39, ["Neon"] = 82.99, ["Neon|Ride"] = 112.77, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 279.2, ["Mega|Ride"] = 278.07, ["Mega|Fly|Ride"] = 387.85}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 13.77, ["Ride"] = 16.17, ["Fly|Ride"] = 26.17, ["Neon"] = 2.63, ["Neon|Fly"] = 20.24, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 64.78, ["Mega|Fly"] = 156.19, ["Mega|Ride"] = 67.19, ["Mega|Fly|Ride"] = 97.54}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.1, ["Fly"] = 177.66, ["Ride"] = 26.25, ["Neon"] = 12.59, ["Neon|Fly"] = 77.53, ["Neon|Ride"] = 40.68, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 59.96, ["Mega|Fly"] = 170.22, ["Mega|Ride"] = 105}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 6.39, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 158.52, ["Neon|Fly|Ride"] = 143.97, ["Mega"] = 32.82, ["Mega|Ride"] = 160.76, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 43.62, ["Neon"] = 2.1, ["Neon|Fly"] = 42.56, ["Neon|Ride"] = 21.29, ["Neon|Fly|Ride"] = 101.07, ["Mega"] = 18.17, ["Mega|Ride"] = 71.29, ["Mega|Fly|Ride"] = 124.76}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 100.02, ["Ride"] = 19.15, ["Fly|Ride"] = 59.07, ["Neon"] = 11.7, ["Neon|Fly"] = 45.09, ["Neon|Ride"] = 27.67, ["Neon|Fly|Ride"] = 56.4, ["Mega"] = 74.08, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 240.42}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 31.4, ["Neon"] = 6.46, ["Neon|Ride"] = 57.46, ["Mega"] = 62.9, ["Mega|Ride"] = 117.21, ["Mega|Fly|Ride"] = 314.89}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 32.48, ["Ride"] = 17.07, ["Fly|Ride"] = 141.75, ["Neon"] = 8.39, ["Neon|Fly"] = 109.18, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 62.39, ["Mega"] = 65.63, ["Mega|Ride"] = 90.46, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 2.63, ["Ride"] = 82.6, ["Neon"] = 30.79, ["Mega"] = 284.04, ["Mega|Fly|Ride"] = 844.06}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Ride"] = 18.1, ["Fly|Ride"] = 5518.35, ["Neon"] = 5.25, ["Neon|Fly"] = 142.55, ["Neon|Ride"] = 31.44, ["Neon|Fly|Ride"] = 142.55, ["Mega"] = 202.21, ["Mega|Ride"] = 113.85, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 4.27, ["Fly"] = 20.6, ["Ride"] = 25.72, ["Fly|Ride"] = 142.34, ["Neon"] = 20.05, ["Neon|Fly"] = 40.44, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 101, ["Mega"] = 115.5, ["Mega|Fly"] = 142.55, ["Mega|Ride"] = 136.5, ["Mega|Fly|Ride"] = 209.98}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 79.47, ["Fly|Ride"] = 106.14, ["Neon"] = 4.27, ["Neon|Ride"] = 160.75, ["Mega"] = 200.16, ["Mega|Ride"] = 405.56}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 10.63, ["Ride"] = 78.73, ["Neon|Ride"] = 100.02, ["Mega"] = 577.5, ["Mega|Ride"] = 675.51, ["Mega|Fly|Ride"] = 794.07}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 6.4, ["Ride"] = 55.65, ["Fly|Ride"] = 59.07, ["Neon"] = 142.55, ["Neon|Ride"] = 105, ["Mega"] = 224.34, ["Mega|Ride"] = 367.5}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 8.38, ["Ride"] = 26.25, ["Neon"] = 56.44, ["Neon|Ride"] = 118.08, ["Neon|Fly|Ride"] = 118.09, ["Mega"] = 479.85, ["Mega|Ride"] = 255.29, ["Mega|Fly|Ride"] = 390.48}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.1, ["Neon|Ride"] = 92.29, ["Mega"] = 21.19, ["Mega|Ride"] = 139.13, ["Mega|Fly|Ride"] = 148.29}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 48.13}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 4.81, ["Fly"] = 26.85, ["Ride"] = 23.24, ["Fly|Ride"] = 59.08, ["Neon"] = 24.01, ["Neon|Ride"] = 42.47, ["Neon|Fly|Ride"] = 80.87, ["Mega"] = 261.19, ["Mega|Ride"] = 425.52, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 18.36, ["Fly|Ride"] = 743.79, ["Neon"] = 2.67, ["Neon|Ride"] = 28.25, ["Mega"] = 1593.54, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 45.76, ["Fly|Ride"] = 140.17, ["Neon"] = 5.16, ["Neon|Ride"] = 30.18, ["Neon|Fly|Ride"] = 159.33, ["Mega"] = 39.35, ["Mega|Ride"] = 84.69, ["Mega|Fly|Ride"] = 75.54}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 45.92, ["Ride"] = 16.68, ["Neon"] = 16.96, ["Neon|Ride"] = 28.73, ["Neon|Fly|Ride"] = 96.64, ["Mega"] = 148.73, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 284.04}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 5.25, ["Neon"] = 39.38, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 157.35, ["Mega"] = 328.13, ["Mega|Ride"] = 278.73, ["Mega|Fly|Ride"] = 425.52}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Fly|Ride"] = 80.39, ["Mega"] = 24.47, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 142.55, ["Mega|Fly|Ride"] = 142.55}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 27.57, ["Ride"] = 17.07, ["Fly|Ride"] = 283671.43, ["Neon"] = 3.83, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 28.73, ["Neon|Fly|Ride"] = 85.12, ["Mega"] = 30.19, ["Mega|Fly"] = 203.95, ["Mega|Ride"] = 62.77, ["Mega|Fly|Ride"] = 133.88}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 15.43, ["Ride"] = 18.38, ["Fly|Ride"] = 34.04, ["Neon"] = 10.4, ["Neon|Fly"] = 71.29, ["Neon|Ride"] = 23.37, ["Neon|Fly|Ride"] = 51.19, ["Mega"] = 65.63, ["Mega|Ride"] = 51.33, ["Mega|Fly|Ride"] = 158.29}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 35.43, ["Fly|Ride"] = 79.2, ["Neon"] = 3.68, ["Neon|Ride"] = 36.74, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 22.32, ["Mega|Ride"] = 43.14, ["Mega|Fly|Ride"] = 112.87}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 174.47, ["Mega"] = 15.54, ["Mega|Fly"] = 146.56, ["Mega|Ride"] = 89.38, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 26.17, ["Ride"] = 19.57, ["Fly|Ride"] = 77.44, ["Neon"] = 5.25, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 78.66, ["Mega"] = 28.73, ["Mega|Ride"] = 56.22, ["Mega|Fly|Ride"] = 85.32}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Mega"] = 14.44, ["Mega|Ride"] = 84.05, ["Mega|Fly|Ride"] = 250.04}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Ride"] = 160.75, ["Neon|Fly|Ride"] = 284.04, ["Mega"] = 28.69, ["Mega|Fly"] = 119.98, ["Mega|Ride"] = 113.85, ["Mega|Fly|Ride"] = 320.31}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 80.38, ["Ride"] = 15.74, ["Fly|Ride"] = 39.38, ["Neon"] = 3.52, ["Neon|Ride"] = 21.29, ["Neon|Fly|Ride"] = 104.98, ["Mega"] = 78.75, ["Mega|Ride"] = 62.77, ["Mega|Fly|Ride"] = 167.97}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 10.4, ["Ride"] = 78.75, ["Neon"] = 95.82, ["Neon|Ride"] = 239.93, ["Mega"] = 390.1, ["Mega|Ride"] = 479.85, ["Mega|Fly|Ride"] = 952.09}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 6.57, ["Fly"] = 6562.49, ["Ride"] = 54.86, ["Neon"] = 118.09, ["Mega"] = 211.71, ["Mega|Ride"] = 147.88, ["Mega|Fly|Ride"] = 425.52}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 3.83, ["Ride"] = 28.41, ["Fly|Ride"] = 425.52, ["Neon"] = 30.19, ["Mega"] = 140.43, ["Mega|Ride"] = 201.89, ["Mega|Fly|Ride"] = 296.87}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 16.69, ["Ride"] = 10.5, ["Fly|Ride"] = 31.46, ["Neon"] = 2.1, ["Neon|Fly"] = 17.22, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 21.29, ["Mega"] = 15.54, ["Mega|Fly"] = 26.7, ["Mega|Ride"] = 21.29, ["Mega|Fly|Ride"] = 55.13}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Ride"] = 55.13, ["Neon"] = 10.65, ["Neon|Fly"] = 84.29, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 67.04, ["Mega|Ride"] = 142.55}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 31.91, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 79.05, ["Mega"] = 15.64, ["Mega|Fly"] = 78.72, ["Mega|Ride"] = 51.34, ["Mega|Fly|Ride"] = 103.56}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 3.56, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 52.5, ["Mega"] = 17.33, ["Mega|Ride"] = 71.29, ["Mega|Fly|Ride"] = 211.71}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 21.29, ["Ride"] = 16.21, ["Fly|Ride"] = 53.2, ["Neon"] = 16.9, ["Neon|Fly"] = 65.6, ["Neon|Ride"] = 32.4, ["Neon|Fly|Ride"] = 85.1, ["Mega"] = 143.22, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 279.38}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 203.44, ["Ride"] = 181.13, ["Fly|Ride"] = 262.5, ["Neon"] = 1560.56, ["Neon|Ride"] = 1120.39, ["Neon|Fly|Ride"] = 1106.34, ["Mega"] = 8510.14, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Neon"] = 6.04, ["Neon|Fly"] = 57.46, ["Neon|Ride"] = 68.25, ["Mega"] = 65.42, ["Mega|Ride"] = 198.95, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 3.94, ["Fly"] = 103.68, ["Ride"] = 24.28, ["Fly|Ride"] = 196.88, ["Neon"] = 59.07, ["Neon|Ride"] = 170.22, ["Neon|Fly|Ride"] = 160.64, ["Mega"] = 425.52, ["Mega|Ride"] = 564.37, ["Mega|Fly|Ride"] = 631.52}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 17.16, ["Fly|Ride"] = 34.81, ["Neon"] = 9.19, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 45.93, ["Mega"] = 65.63, ["Mega|Ride"] = 59.7, ["Mega|Fly|Ride"] = 121.28}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Ride"] = 25.55, ["Fly|Ride"] = 120.89, ["Neon"] = 7.88, ["Neon|Fly"] = 85.12, ["Neon|Ride"] = 82.15, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 125.54, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 211.71}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 3.56, ["Fly"] = 28.77, ["Ride"] = 17.46, ["Fly|Ride"] = 34.13, ["Neon"] = 28.73, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 209.18, ["Mega|Ride"] = 282.98, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 3.93, ["Fly"] = 28.73, ["Ride"] = 39.38, ["Fly|Ride"] = 247.07, ["Neon"] = 51.47, ["Neon|Ride"] = 137.45, ["Neon|Fly|Ride"] = 631.89, ["Mega"] = 327.48, ["Mega|Ride"] = 323.4, ["Mega|Fly|Ride"] = 398.35}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.63, ["Fly"] = 21, ["Ride"] = 17.04, ["Fly|Ride"] = 40.69, ["Neon"] = 21.59, ["Neon|Fly"] = 84.05, ["Neon|Ride"] = 50.02, ["Neon|Fly|Ride"] = 56.4, ["Mega"] = 196.88, ["Mega|Ride"] = 359.89, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 68.25, ["Fly"] = 113.85, ["Ride"] = 106.32, ["Fly|Ride"] = 142.55, ["Neon"] = 383.75, ["Neon|Fly"] = 405.57, ["Neon|Ride"] = 378, ["Neon|Fly|Ride"] = 479.07, ["Mega|Fly|Ride"] = 1573.69}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 183.75, ["Fly"] = 322.17, ["Ride"] = 217.02, ["Fly|Ride"] = 274.63, ["Neon"] = 916.54, ["Neon|Ride"] = 2659.43, ["Neon|Fly|Ride"] = 1106.34, ["Mega"] = 10637.67, ["Mega|Fly|Ride"] = 6525.16}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 78.14, ["Fly"] = 200.08, ["Ride"] = 92.44, ["Fly|Ride"] = 127.32, ["Neon"] = 379.25, ["Neon|Ride"] = 314.99, ["Neon|Fly|Ride"] = 375.27, ["Mega|Fly|Ride"] = 1334.59}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 6.4, ["Ride"] = 53.82, ["Fly|Ride"] = 91.5, ["Neon"] = 19.57, ["Neon|Fly"] = 48, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 594.65, ["Mega|Ride"] = 142.55, ["Mega|Fly|Ride"] = 320.31}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 15.43, ["Fly"] = 68.14, ["Ride"] = 21, ["Fly|Ride"] = 71.29, ["Neon"] = 121.64, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 104.27, ["Neon|Fly|Ride"] = 160.76, ["Mega"] = 353.07, ["Mega|Ride"] = 423.4, ["Mega|Fly|Ride"] = 469.13}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 20.83, ["Fly|Ride"] = 51.08, ["Neon"] = 5.77, ["Neon|Fly"] = 129.94, ["Neon|Ride"] = 28.72, ["Neon|Fly|Ride"] = 87.24, ["Mega"] = 40.8, ["Mega|Fly"] = 213.54, ["Mega|Ride"] = 111.57, ["Mega|Fly|Ride"] = 195.75}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 5.15, ["Fly"] = 68.49, ["Ride"] = 28.72, ["Fly|Ride"] = 131.25, ["Neon"] = 24, ["Neon|Ride"] = 158.06, ["Neon|Fly|Ride"] = 134.93, ["Mega"] = 803.15, ["Mega|Ride"] = 497.44, ["Mega|Fly|Ride"] = 568.07}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 30.19, ["Ride"] = 16.77, ["Fly|Ride"] = 42, ["Neon"] = 12.49, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 37.25, ["Neon|Fly|Ride"] = 99.49, ["Mega"] = 131.25, ["Mega|Ride"] = 181.16, ["Mega|Fly|Ride"] = 175.88}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 3.94, ["Ride"] = 27.57, ["Fly|Ride"] = 328.13, ["Neon"] = 28.73, ["Neon|Ride"] = 78.73, ["Neon|Fly|Ride"] = 239.94, ["Mega"] = 207.37, ["Mega|Ride"] = 239.94, ["Mega|Fly|Ride"] = 457.47}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 34.06, ["Neon"] = 2.1, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 17, ["Mega|Ride"] = 40.44, ["Mega|Fly|Ride"] = 227.64}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 3.62, ["Fly"] = 20.34, ["Ride"] = 20.89, ["Fly|Ride"] = 48.95, ["Neon"] = 13.13, ["Neon|Fly"] = 106.39, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 69.57, ["Mega"] = 108.94, ["Mega|Ride"] = 96.49, ["Mega|Fly|Ride"] = 189.67}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.1, ["Fly"] = 24.92, ["Ride"] = 18.06, ["Fly|Ride"] = 39.29, ["Neon"] = 19.16, ["Neon|Fly"] = 142.55, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 283.5, ["Mega|Ride"] = 208.76, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 133.88, ["Fly"] = 200.82, ["Ride"] = 205.2, ["Fly|Ride"] = 268.59, ["Neon"] = 625.51, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 597.18, ["Mega|Ride"] = 3478.13, ["Mega|Fly|Ride"] = 2180.05}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 6.5, ["Ride"] = 32.8, ["Fly|Ride"] = 206.07, ["Neon"] = 45.94, ["Neon|Ride"] = 104.81, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 284.04, ["Mega|Ride"] = 355.31, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Ride"] = 15.89, ["Fly|Ride"] = 70.21, ["Neon"] = 15.96, ["Neon|Ride"] = 28.73, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 137.82, ["Mega|Ride"] = 255.32, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 18.38, ["Ride"] = 51.08, ["Fly|Ride"] = 178.5, ["Neon"] = 65.62, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 294.53, ["Mega"] = 479.8, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 635.25}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 6.57}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 2.63, ["Ride"] = 27.03, ["Neon"] = 13.13, ["Neon|Ride"] = 162.48, ["Neon|Fly|Ride"] = 185.11, ["Mega"] = 283.5, ["Mega|Ride"] = 313.69, ["Mega|Fly|Ride"] = 545.31}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 24.82, ["Fly"] = 26.25, ["Ride"] = 31.37, ["Fly|Ride"] = 49.88, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 157.45, ["Neon|Fly|Ride"] = 126.41, ["Mega"] = 2127.56, ["Mega|Ride"] = 705.38, ["Mega|Fly|Ride"] = 629.52}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 34.13, ["Fly|Ride"] = 78.75, ["Neon"] = 3.68, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 26.25, ["Mega|Ride"] = 80.07, ["Mega|Fly|Ride"] = 140.18}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 3.84, ["Fly"] = 26.25, ["Ride"] = 28.5, ["Fly|Ride"] = 62.26, ["Neon"] = 50.02, ["Neon|Ride"] = 113.85, ["Mega"] = 190.43, ["Mega|Fly"] = 400.68, ["Mega|Ride"] = 147, ["Mega|Fly|Ride"] = 241.48}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 15.58, ["Fly|Ride"] = 57.46, ["Neon"] = 15.74, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 72.1, ["Mega"] = 124.68, ["Mega|Ride"] = 128.38, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 27.67, ["Neon"] = 2.63, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 31.39, ["Neon|Fly|Ride"] = 425.52, ["Mega"] = 30.19, ["Mega|Ride"] = 71.29, ["Mega|Fly|Ride"] = 101.08}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 29.9, ["Fly"] = 127.66, ["Ride"] = 56.44, ["Neon"] = 232.32, ["Neon|Ride"] = 319.09, ["Neon|Fly|Ride"] = 221.82, ["Mega"] = 800.63, ["Mega|Ride"] = 774.38, ["Mega|Fly|Ride"] = 950.87}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.93, ["Ride"] = 39.38, ["Fly|Ride"] = 210, ["Neon"] = 69.57, ["Neon|Ride"] = 85.12, ["Neon|Fly|Ride"] = 212.77, ["Mega|Ride"] = 524.99, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 24.36, ["Fly"] = 131.25, ["Ride"] = 51.47, ["Fly|Ride"] = 134.79, ["Neon"] = 73.38, ["Neon|Fly"] = 212.77, ["Neon|Ride"] = 85.12, ["Neon|Fly|Ride"] = 160.76, ["Mega"] = 406.85, ["Mega|Ride"] = 341.11, ["Mega|Fly|Ride"] = 473.2}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 63, ["Fly"] = 142.55, ["Ride"] = 103.69, ["Fly|Ride"] = 262.44, ["Neon"] = 284.04, ["Neon|Ride"] = 284.04, ["Neon|Fly|Ride"] = 340.41, ["Mega|Ride"] = 1968.75, ["Mega|Fly|Ride"] = 1455.25}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 14.43, ["Fly"] = 39.38, ["Ride"] = 36.19, ["Fly|Ride"] = 142.55, ["Neon"] = 65.63, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 212.77, ["Mega"] = 551.25, ["Mega|Ride"] = 526.58, ["Mega|Fly|Ride"] = 513.45}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 93.19, ["Fly"] = 145.69, ["Ride"] = 115.99, ["Fly|Ride"] = 185.11, ["Neon"] = 203.43, ["Neon|Ride"] = 241.39, ["Neon|Fly|Ride"] = 391.15, ["Mega"] = 993.58, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 949.08}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 26.1, ["Ride"] = 72.42, ["Fly|Ride"] = 162.75, ["Neon"] = 101.01, ["Neon|Ride"] = 131.06, ["Neon|Fly|Ride"] = 291.53, ["Mega"] = 370.2, ["Mega|Ride"] = 325.61, ["Mega|Fly|Ride"] = 425.52}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 3.83, ["Fly"] = 69.5, ["Ride"] = 18.38, ["Neon"] = 80.76, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 127.66, ["Mega"] = 340.71, ["Mega|Ride"] = 1063.78, ["Mega|Fly|Ride"] = 405.47}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 13.64, ["Ride"] = 78.75, ["Fly|Ride"] = 142.55, ["Neon"] = 76.12, ["Neon|Ride"] = 355.31, ["Neon|Fly|Ride"] = 425.48, ["Mega"] = 473.6, ["Mega|Fly"] = 424.46, ["Mega|Ride"] = 346.49, ["Mega|Fly|Ride"] = 532.23}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 9.19, ["Ride"] = 34.13, ["Fly|Ride"] = 140.41, ["Neon"] = 48.95, ["Neon|Ride"] = 94.78, ["Mega"] = 325.53, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 411.6}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 42.56, ["Neon|Ride"] = 55.95, ["Mega"] = 18.38, ["Mega|Fly"] = 142.55, ["Mega|Ride"] = 70.81, ["Mega|Fly|Ride"] = 177.19}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 3.82, ["Ride"] = 30.86, ["Fly|Ride"] = 441.49, ["Neon"] = 11.74, ["Neon|Ride"] = 83.83, ["Mega"] = 133.55, ["Mega|Ride"] = 235.11, ["Mega|Fly|Ride"] = 455.86}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.61, ["Neon"] = 22.32, ["Neon|Ride"] = 105.33, ["Mega"] = 157.45, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 6.57, ["Ride"] = 31.44, ["Fly|Ride"] = 118.78, ["Neon"] = 15.75, ["Neon|Ride"] = 82.95, ["Neon|Fly|Ride"] = 282.98, ["Mega"] = 123.38, ["Mega|Ride"] = 152.97, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 472.4, ["Ride"] = 523.98, ["Fly|Ride"] = 646.3, ["Neon|Ride"] = 1378.13, ["Neon|Fly|Ride"] = 1443.75, ["Mega|Fly|Ride"] = 5840.63}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 5.65, ["Fly"] = 28.49, ["Ride"] = 25.18, ["Fly|Ride"] = 57.44, ["Neon"] = 52.5, ["Neon|Ride"] = 77.6, ["Neon|Fly|Ride"] = 210, ["Mega"] = 284.04, ["Mega|Ride"] = 278.25}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 9.19, ["Fly"] = 39.38, ["Ride"] = 27.53, ["Fly|Ride"] = 85.12, ["Neon"] = 57.18, ["Neon|Fly"] = 315, ["Neon|Ride"] = 59.06, ["Mega"] = 479.85, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 320.31}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 5.13, ["Fly"] = 28.73, ["Ride"] = 22.98, ["Fly|Ride"] = 319.14, ["Neon"] = 18.27, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 223.13, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 27.12, ["Fly|Ride"] = 941.48, ["Neon"] = 6.4, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 125.32, ["Mega"] = 59.07, ["Mega|Ride"] = 91.02, ["Mega|Fly|Ride"] = 170.62}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 71.29, ["Ride"] = 71.29, ["Neon"] = 2.63, ["Neon|Ride"] = 31.13, ["Mega"] = 20.05, ["Mega|Ride"] = 77.44}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1559.46}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 6.46, ["Ride"] = 37.25, ["Neon"] = 72.19, ["Neon|Fly"] = 142.55, ["Neon|Ride"] = 62.77, ["Neon|Fly|Ride"] = 142.55, ["Mega"] = 653.17, ["Mega|Ride"] = 553.18, ["Mega|Fly|Ride"] = 568.07}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 29.7, ["Neon"] = 8.43, ["Neon|Ride"] = 42.56, ["Mega"] = 57.75, ["Mega|Ride"] = 142.54, ["Mega|Fly|Ride"] = 229.04}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.61, ["Fly"] = 98.33, ["Ride"] = 24.47, ["Fly|Ride"] = 574.38, ["Neon"] = 10.48, ["Neon|Ride"] = 63.83, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 183.73, ["Mega|Ride"] = 80.39, ["Mega|Fly|Ride"] = 284.04}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 368.82, ["Ride"] = 441.49, ["Fly|Ride"] = 446.25, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1702.04, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 6.43, ["Fly"] = 196.88, ["Ride"] = 72.19, ["Neon"] = 86.63, ["Mega"] = 383.88, ["Mega|Ride"] = 280.85, ["Mega|Fly|Ride"] = 397.08}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Ride"] = 29.29, ["Fly|Ride"] = 63, ["Neon"] = 6.57, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 112.44, ["Mega"] = 39.38, ["Mega|Fly"] = 189, ["Mega|Ride"] = 83.87, ["Mega|Fly|Ride"] = 208.49}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Ride"] = 851.03, ["Neon"] = 3.93, ["Neon|Ride"] = 98.28, ["Neon|Fly|Ride"] = 270.21, ["Mega"] = 21, ["Mega|Ride"] = 142.55, ["Mega|Fly|Ride"] = 192.94}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 10.49, ["Fly"] = 56.27, ["Ride"] = 71.29, ["Fly|Ride"] = 148.95, ["Neon"] = 85.12, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 71.29, ["Mega"] = 280.88, ["Mega|Ride"] = 339.5, ["Mega|Fly|Ride"] = 372.75}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 11.24, ["Ride"] = 110.65, ["Fly|Ride"] = 106.39, ["Neon"] = 100.02, ["Neon|Ride"] = 142.55, ["Neon|Fly|Ride"] = 838.69, ["Mega"] = 568.07, ["Mega|Ride"] = 561.29, ["Mega|Fly|Ride"] = 1086.11}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 5.67, ["Fly"] = 65.63, ["Ride"] = 26.25, ["Fly|Ride"] = 100.02, ["Neon"] = 141.37, ["Neon|Ride"] = 200.82, ["Mega"] = 582.75, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 10.5, ["Ride"] = 37.2, ["Fly|Ride"] = 262.5, ["Neon"] = 160.76, ["Neon|Ride"] = 100.02, ["Neon|Fly|Ride"] = 799.84, ["Mega"] = 525, ["Mega|Ride"] = 523.39, ["Mega|Fly|Ride"] = 665.44}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 383.02, ["Ride"] = 388.37, ["Fly|Ride"] = 448.67, ["Neon"] = 1419.08, ["Neon|Ride"] = 1276.53, ["Neon|Fly|Ride"] = 1276.53, ["Mega|Ride"] = 3829.58, ["Mega|Fly|Ride"] = 3446.13}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 3.71, ["Fly"] = 28.3, ["Ride"] = 30.86, ["Fly|Ride"] = 85.19, ["Neon"] = 98.44, ["Neon|Ride"] = 138.44, ["Neon|Fly|Ride"] = 137.64, ["Mega"] = 709.55, ["Mega|Ride"] = 538.59, ["Mega|Fly|Ride"] = 719.13}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 13.06, ["Ride"] = 118.11, ["Mega"] = 1276.53, ["Mega|Fly|Ride"] = 1702.04}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 17.46, ["Ride"] = 56.44, ["Fly|Ride"] = 164.9, ["Neon"] = 45.94, ["Neon|Ride"] = 103.69, ["Mega"] = 210, ["Mega|Ride"] = 214.94, ["Mega|Fly|Ride"] = 323.04}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.49, ["Ride"] = 42, ["Fly|Ride"] = 118.09, ["Neon"] = 14.43, ["Neon|Ride"] = 45.76, ["Mega"] = 40.69, ["Mega|Ride"] = 78.74, ["Mega|Fly|Ride"] = 239.94}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 57.18, ["Ride"] = 80.38, ["Neon"] = 284.04, ["Neon|Ride"] = 254.86, ["Neon|Fly|Ride"] = 425.52, ["Mega"] = 2553.05, ["Mega|Ride"] = 1262.7, ["Mega|Fly|Ride"] = 1242.42}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 3.93, ["Fly"] = 599.8, ["Ride"] = 31.4, ["Fly|Ride"] = 64.79, ["Neon"] = 10.4, ["Neon|Fly"] = 156.96, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 63, ["Mega|Ride"] = 96.22, ["Mega|Fly|Ride"] = 221.82}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 41.74, ["Ride"] = 28.6, ["Fly|Ride"] = 71.29, ["Neon"] = 6.57, ["Neon|Fly"] = 425.52, ["Neon|Ride"] = 31.92, ["Neon|Fly|Ride"] = 140.39, ["Mega"] = 46.35, ["Mega|Ride"] = 87.24, ["Mega|Fly|Ride"] = 195.29}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 5.15, ["Ride"] = 38.06, ["Fly|Ride"] = 111.2, ["Neon"] = 31.5, ["Neon|Ride"] = 95.99, ["Neon|Fly|Ride"] = 709.55, ["Mega"] = 131.25, ["Mega|Fly"] = 638.27, ["Mega|Ride"] = 219.15, ["Mega|Fly|Ride"] = 619.5}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 70.2, ["Fly"] = 100.02, ["Ride"] = 110.85, ["Fly|Ride"] = 191.96, ["Neon"] = 485.63, ["Neon|Ride"] = 509.25, ["Neon|Fly|Ride"] = 780.29, ["Mega|Ride"] = 1135.05, ["Mega|Fly|Ride"] = 1355.82}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 267.71, ["Ride"] = 297.88, ["Fly|Ride"] = 341.25, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 918.75, ["Mega"] = 12765.21, ["Mega|Fly|Ride"] = 4331.25}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 4.72, ["Ride"] = 40.8, ["Neon"] = 28.3, ["Neon|Ride"] = 139.37, ["Mega"] = 97.13, ["Mega|Fly"] = 212.77, ["Mega|Ride"] = 185.07, ["Mega|Fly|Ride"] = 270.21}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 5.36, ["Ride"] = 45.85, ["Fly|Ride"] = 211.71, ["Neon"] = 18.01, ["Neon|Ride"] = 32.41, ["Neon|Fly|Ride"] = 212.77, ["Mega"] = 99.75, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 3.82, ["Ride"] = 27.57, ["Neon"] = 154.35, ["Mega"] = 517.79, ["Mega|Ride"] = 337.84}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 28.46, ["Ride"] = 28.48, ["Fly|Ride"] = 75.54, ["Neon"] = 6.17, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 90.09, ["Mega"] = 44.7, ["Mega|Ride"] = 65.62, ["Mega|Fly|Ride"] = 251.85}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 37.17, ["Fly|Ride"] = 210.68, ["Neon"] = 10.5, ["Mega"] = 32.99, ["Mega|Fly"] = 142.55, ["Mega|Ride"] = 207.44}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 18.38, ["Fly|Ride"] = 41.94, ["Neon"] = 6.4, ["Neon|Ride"] = 28.49, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 39.38, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 128.63}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.63, ["Fly"] = 26.25, ["Ride"] = 21.29, ["Fly|Ride"] = 63.83, ["Neon"] = 8.97, ["Neon|Fly"] = 47.92, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 92.56, ["Mega"] = 170.63, ["Mega|Ride"] = 202.13, ["Mega|Fly|Ride"] = 437.07}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 26.25, ["Ride"] = 52.48, ["Fly|Ride"] = 83.65, ["Neon"] = 197.29, ["Neon|Fly|Ride"] = 270.21, ["Mega"] = 380.63, ["Mega|Fly"] = 446.25, ["Mega|Ride"] = 446.25, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 84.96, ["Ride"] = 102.18, ["Fly|Ride"] = 164.84, ["Neon"] = 439.69, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 561.19, ["Mega|Ride"] = 2266.9, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 23.23, ["Fly|Ride"] = 131.25, ["Neon"] = 6.3, ["Neon|Fly"] = 78.75, ["Mega"] = 56.44, ["Mega|Ride"] = 91.35, ["Mega|Fly|Ride"] = 106.39}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 16.77, ["Ride"] = 19.16, ["Fly|Ride"] = 30.15, ["Neon"] = 3.94, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 68.85, ["Mega"] = 44.21, ["Mega|Fly"] = 131.21, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 3.56, ["Ride"] = 24.01, ["Fly|Ride"] = 142.55, ["Neon"] = 36.09, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 282.98, ["Mega"] = 315, ["Mega|Ride"] = 319.14, ["Mega|Fly|Ride"] = 472.38}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 341.25, ["Fly"] = 393.75, ["Ride"] = 425.52, ["Fly|Ride"] = 301.88, ["Neon|Ride"] = 1489.29, ["Neon|Fly|Ride"] = 1594.6, ["Mega"] = 7997.78, ["Mega|Fly|Ride"] = 5318.84}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 28.72, ["Fly"] = 142.55, ["Ride"] = 65.09, ["Fly|Ride"] = 116.25, ["Neon"] = 196.88, ["Neon|Ride"] = 215.94, ["Neon|Fly|Ride"] = 280.85, ["Mega"] = 1091.45, ["Mega|Fly|Ride"] = 984.72}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Fly|Ride"] = 63.82, ["Neon"] = 10.49, ["Neon|Ride"] = 34.78, ["Neon|Fly|Ride"] = 142.55, ["Mega"] = 84, ["Mega|Ride"] = 117.14, ["Mega|Fly|Ride"] = 195.57}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 212.77, ["Ride"] = 28.87, ["Fly|Ride"] = 142.7, ["Neon"] = 26.17, ["Neon|Ride"] = 203.2, ["Mega"] = 489.35}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 30.19, ["Fly"] = 78.72, ["Ride"] = 43.32, ["Fly|Ride"] = 77.44, ["Neon|Ride"] = 212.77, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 2553.05, ["Mega|Ride"] = 957.41, ["Mega|Fly|Ride"] = 1280}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 105.45, ["Ride"] = 140.43, ["Fly|Ride"] = 142.55, ["Neon"] = 414.86, ["Neon|Ride"] = 469.88, ["Neon|Fly|Ride"] = 479.07, ["Mega"] = 3121.11, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 210.91, ["Fly"] = 281.93, ["Ride"] = 246.75, ["Fly|Ride"] = 393.75, ["Neon|Ride"] = 872.82, ["Neon|Fly|Ride"] = 976.55, ["Mega|Fly|Ride"] = 2893.46}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 17.14, ["Ride"] = 7446.38, ["Fly|Ride"] = 160.76, ["Neon"] = 118.13, ["Neon|Ride"] = 136.33, ["Neon|Fly|Ride"] = 326.59, ["Mega"] = 388.5, ["Mega|Ride"] = 397.37, ["Mega|Fly|Ride"] = 528.03}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 28.73, ["Ride"] = 17.38, ["Fly|Ride"] = 40.69, ["Neon"] = 15.74, ["Neon|Ride"] = 31.92, ["Neon|Fly|Ride"] = 42.04, ["Mega"] = 90.57, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 2.63, ["Fly"] = 33.64, ["Ride"] = 25.86, ["Fly|Ride"] = 71.29, ["Neon"] = 36.18, ["Neon|Fly"] = 148.95, ["Neon|Ride"] = 56.96, ["Neon|Fly|Ride"] = 106.39, ["Mega"] = 236.25, ["Mega|Ride"] = 232.32, ["Mega|Fly|Ride"] = 349.65}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 301.88, ["Ride"] = 313.69, ["Fly|Ride"] = 406.88, ["Neon"] = 2074.36, ["Neon|Ride"] = 1702.04, ["Neon|Fly|Ride"] = 1457.37, ["Mega|Fly|Ride"] = 4638.04}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 46.82, ["Neon"] = 13.18, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 41.97, ["Mega|Ride"] = 153.19, ["Mega|Fly|Ride"] = 270.21}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 3.93, ["Fly"] = 15.73, ["Ride"] = 19.09, ["Fly|Ride"] = 55.18, ["Neon"] = 30.87, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 97.13, ["Mega"] = 171.94, ["Mega|Ride"] = 223.32, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 18.8, ["Ride"] = 118.78, ["Neon"] = 104.9, ["Neon|Fly"] = 425.52, ["Neon|Ride"] = 152.25, ["Neon|Fly|Ride"] = 568.07, ["Mega"] = 466.48, ["Mega|Ride"] = 504.69, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 124.69, ["Fly"] = 282.98, ["Ride"] = 157.5, ["Fly|Ride"] = 170.63, ["Neon|Ride"] = 727.13, ["Neon|Fly|Ride"] = 485.63, ["Mega|Fly|Ride"] = 2098.69}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 21.27, ["Fly"] = 42.56, ["Ride"] = 30.19, ["Fly|Ride"] = 52.49, ["Neon"] = 76.13, ["Neon|Ride"] = 98.34, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 708.48, ["Mega|Ride"] = 424.68, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 26.24, ["Neon"] = 3.15, ["Neon|Ride"] = 205.14, ["Neon|Fly|Ride"] = 709.55, ["Mega"] = 21, ["Mega|Ride"] = 70.23, ["Mega|Fly|Ride"] = 270.21}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Ride"] = 22.32, ["Fly|Ride"] = 52.5, ["Neon"] = 3.66, ["Neon|Fly"] = 160.75, ["Neon|Ride"] = 20.23, ["Neon|Fly|Ride"] = 69.18, ["Mega"] = 29.89, ["Mega|Fly"] = 141.96, ["Mega|Ride"] = 61.71, ["Mega|Fly|Ride"] = 103.36}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 9.19, ["Fly"] = 91.88, ["Ride"] = 61.69, ["Neon"] = 17.99, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 153.57, ["Mega"] = 144.38, ["Mega|Fly"] = 284.04, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 297.94}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1380.75, ["Ride"] = 1311.19, ["Fly|Ride"] = 1181.25, ["Neon|Ride"] = 4113.6, ["Neon|Fly|Ride"] = 4152.96, ["Mega"] = 18296.8, ["Mega|Fly|Ride"] = 12600}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 471.19, ["Ride"] = 466.5, ["Fly|Ride"] = 606.93, ["Neon"] = 1903.11, ["Neon|Ride"] = 1575, ["Neon|Fly|Ride"] = 1844.58, ["Mega"] = 14395.27, ["Mega|Fly|Ride"] = 7084.87}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 282.19, ["Fly"] = 355.31, ["Ride"] = 344.66, ["Fly|Ride"] = 428.42, ["Neon"] = 734.99, ["Neon|Fly"] = 1279.92, ["Neon|Ride"] = 623.44, ["Neon|Fly|Ride"] = 761.25, ["Mega|Fly|Ride"] = 2803.04}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 278.67, ["Fly"] = 419.99, ["Ride"] = 370.53, ["Fly|Ride"] = 452.81, ["Neon"] = 1023.75, ["Neon|Fly"] = 3199.2, ["Neon|Ride"] = 993.58, ["Neon|Fly|Ride"] = 945, ["Mega|Ride"] = 3675, ["Mega|Fly|Ride"] = 3900.85}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Ride"] = 17.04, ["Fly|Ride"] = 44.63, ["Neon"] = 5.99, ["Neon|Ride"] = 19.16, ["Neon|Fly|Ride"] = 79.8, ["Mega"] = 59.41, ["Mega|Ride"] = 112.88, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 392.44, ["Fly"] = 590.63, ["Ride"] = 419.35, ["Fly|Ride"] = 589.82, ["Neon"] = 1036.88, ["Neon|Ride"] = 1153.69, ["Neon|Fly|Ride"] = 1312.5, ["Mega"] = 6382.61, ["Mega|Fly|Ride"] = 4725}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 2.1, ["Fly"] = 183.75, ["Ride"] = 25.33, ["Neon"] = 11.82, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 112.22, ["Mega"] = 52.5, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 208.04}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 21.29, ["Ride"] = 16.25, ["Fly|Ride"] = 39.38, ["Neon"] = 14.36, ["Neon|Ride"] = 61.69, ["Neon|Fly|Ride"] = 105.51, ["Mega"] = 91.77, ["Mega|Ride"] = 192.93, ["Mega|Fly|Ride"] = 314.62}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Neon"] = 3.82, ["Neon|Fly"] = 80.38, ["Neon|Ride"] = 26.25, ["Mega"] = 24.92, ["Mega|Fly"] = 71.29, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 34.13, ["Ride"] = 65.63, ["Fly|Ride"] = 459.38, ["Neon"] = 244.13, ["Neon|Ride"] = 320.31, ["Neon|Fly|Ride"] = 318.08, ["Mega"] = 1702.04, ["Mega|Fly|Ride"] = 1010.63}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 4.07, ["Fly"] = 65.62, ["Ride"] = 32.41, ["Fly|Ride"] = 60.44, ["Neon"] = 34.81, ["Mega"] = 328.13, ["Mega|Ride"] = 233.63}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.12, ["Neon"] = 2.52, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 36.51, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 27.64, ["Mega|Fly"] = 709.55, ["Mega|Ride"] = 64.78, ["Mega|Fly|Ride"] = 308.44}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.1, ["Fly"] = 31.49, ["Ride"] = 21.29, ["Fly|Ride"] = 57.46, ["Neon"] = 8.03, ["Neon|Fly"] = 52.49, ["Neon|Ride"] = 33.54, ["Neon|Fly|Ride"] = 80.07, ["Mega"] = 39.37, ["Mega|Fly"] = 175.14, ["Mega|Ride"] = 80.7, ["Mega|Fly|Ride"] = 168}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 6.25, ["Fly"] = 47.16, ["Ride"] = 42.14, ["Fly|Ride"] = 51.45, ["Neon"] = 105.33, ["Neon|Fly"] = 143.96, ["Neon|Ride"] = 71.29, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 237.57, ["Mega|Ride"] = 300.57, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 11.81, ["Ride"] = 52.5, ["Neon|Ride"] = 71.29, ["Neon|Fly|Ride"] = 314.31, ["Mega"] = 400.68, ["Mega|Ride"] = 338.29, ["Mega|Fly|Ride"] = 313.83}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 6.56, ["Ride"] = 26.25, ["Fly|Ride"] = 71.29, ["Neon"] = 142.55, ["Neon|Ride"] = 80.38, ["Neon|Fly|Ride"] = 284.04, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 18.75, ["Ride"] = 19.69, ["Fly|Ride"] = 56.4, ["Neon"] = 5.25, ["Neon|Ride"] = 28.27, ["Mega"] = 43.32, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 319.14}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 162.75, ["Fly"] = 369.14, ["Ride"] = 258.57, ["Fly|Ride"] = 406.88, ["Neon|Ride"] = 1156.19, ["Neon|Fly|Ride"] = 1102.5, ["Mega"] = 10637.67, ["Mega|Fly|Ride"] = 4501.35}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 22.2, ["Ride"] = 16.05, ["Fly|Ride"] = 42, ["Neon"] = 6.4, ["Neon|Fly"] = 19.16, ["Neon|Ride"] = 25.26, ["Neon|Fly|Ride"] = 44.07, ["Mega"] = 42.56, ["Mega|Ride"] = 78.14, ["Mega|Fly|Ride"] = 106.39}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 10.28, ["Ride"] = 26.25, ["Fly|Ride"] = 180.81, ["Neon"] = 69.57, ["Neon|Ride"] = 105, ["Mega"] = 379.32, ["Mega|Ride"] = 436.15, ["Mega|Fly|Ride"] = 637.21}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 29.3, ["Fly"] = 131.25, ["Ride"] = 64.79, ["Fly|Ride"] = 157.45, ["Neon"] = 253.22, ["Neon|Ride"] = 297.88, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 846.77, ["Mega|Ride"] = 808.54, ["Mega|Fly|Ride"] = 851.03}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 192.94, ["Fly"] = 308.44, ["Ride"] = 210, ["Fly|Ride"] = 304.65, ["Neon"] = 841.32, ["Neon|Ride"] = 651, ["Neon|Fly|Ride"] = 656.25, ["Mega|Ride"] = 3404.07, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 19.69, ["Fly"] = 168.88, ["Neon"] = 82.69, ["Neon|Ride"] = 284.04, ["Mega"] = 285.48, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 709.55}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 32.82, ["Ride"] = 425.52, ["Fly|Ride"] = 158.81, ["Neon"] = 177.21, ["Neon|Fly|Ride"] = 851.03, ["Mega"] = 851.03, ["Mega|Fly|Ride"] = 2127.56}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 1076.13, ["Fly"] = 1441.13, ["Ride"] = 1076.13, ["Fly|Ride"] = 1074.94, ["Neon|Ride"] = 5674.15, ["Neon|Fly|Ride"] = 4774.39, ["Mega|Fly|Ride"] = 16737.31}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 5.2, ["Fly"] = 25.55, ["Ride"] = 21.83, ["Fly|Ride"] = 48, ["Neon"] = 74.48, ["Neon|Fly"] = 75.06, ["Neon|Ride"] = 78.73, ["Neon|Fly|Ride"] = 200.82, ["Mega"] = 225.53, ["Mega|Ride"] = 259.58, ["Mega|Fly|Ride"] = 388.5}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 5.15, ["Fly"] = 65.63, ["Ride"] = 35.43, ["Neon"] = 40.8, ["Neon|Ride"] = 140.39, ["Mega"] = 212.63, ["Mega|Ride"] = 217.88, ["Mega|Fly|Ride"] = 479.85}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 4.27, ["Ride"] = 44.7, ["Fly|Ride"] = 91.33, ["Neon"] = 45.93, ["Neon|Ride"] = 72.19, ["Mega"] = 168.09, ["Mega|Ride"] = 379.32, ["Mega|Fly|Ride"] = 624.44}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 18.38, ["Fly"] = 709.55, ["Ride"] = 39.38, ["Fly|Ride"] = 104.82, ["Neon"] = 86.62, ["Neon|Ride"] = 98.98, ["Neon|Fly|Ride"] = 211.32, ["Mega"] = 433.23, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 3.94, ["Fly"] = 28.73, ["Ride"] = 13.13, ["Fly|Ride"] = 54.26, ["Neon"] = 21.72, ["Neon|Fly"] = 57.44, ["Neon|Ride"] = 40.8, ["Neon|Fly|Ride"] = 88.31, ["Mega|Ride"] = 273.26, ["Mega|Fly|Ride"] = 270.6}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Neon"] = 15.26, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 56.9, ["Neon|Fly|Ride"] = 142.55, ["Mega"] = 233.36, ["Mega|Ride"] = 131.14, ["Mega|Fly|Ride"] = 390.42}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 248.94, ["Ride"] = 333.38, ["Fly|Ride"] = 608.23, ["Neon|Ride"] = 990.38, ["Neon|Fly|Ride"] = 1133.98, ["Mega|Ride"] = 5250, ["Mega|Fly|Ride"] = 4935.9}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Fly"] = 71.29, ["Ride"] = 28.24, ["Fly|Ride"] = 59.07, ["Neon"] = 10.64, ["Neon|Fly"] = 85.12, ["Neon|Ride"] = 45.85, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 98.48, ["Mega|Ride"] = 89.25, ["Mega|Fly|Ride"] = 431.87}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 6.54, ["Ride"] = 15.94, ["Neon"] = 48, ["Neon|Ride"] = 313.85, ["Mega"] = 280.85, ["Mega|Ride"] = 284.04}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 9.61, ["Fly"] = 58.38, ["Ride"] = 34.13, ["Neon"] = 19.69, ["Neon|Fly"] = 71.29, ["Neon|Ride"] = 92.56, ["Mega"] = 113.48, ["Mega|Fly"] = 425.52, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 288.25}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 166.69, ["Fly"] = 340.41, ["Ride"] = 295.32, ["Fly|Ride"] = 493.5, ["Neon"] = 752.1, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 945, ["Mega|Ride"] = 5106.09, ["Mega|Fly|Ride"] = 2165.63}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 24.93, ["Fly"] = 61.71, ["Ride"] = 41.5, ["Fly|Ride"] = 112.77, ["Neon"] = 71.29, ["Neon|Ride"] = 161.7, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 568.07, ["Mega|Ride"] = 638.27, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 20.98, ["Ride"] = 54.26, ["Fly|Ride"] = 1276.53, ["Neon"] = 111.19, ["Neon|Ride"] = 133.88, ["Neon|Fly|Ride"] = 257.25, ["Mega"] = 489.14, ["Mega|Ride"] = 427.88, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 3.15, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 35.35, ["Mega"] = 30.51, ["Mega|Ride"] = 222.07, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 77.44, ["Fly"] = 117.54, ["Ride"] = 85.32, ["Fly|Ride"] = 196.92, ["Neon"] = 402.94, ["Neon|Fly"] = 471.78, ["Neon|Ride"] = 320.15, ["Neon|Fly|Ride"] = 380.42, ["Mega|Fly|Ride"] = 1280}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 18.83, ["Neon"] = 6.57, ["Neon|Ride"] = 57.46, ["Neon|Fly|Ride"] = 588, ["Mega"] = 38.31, ["Mega|Ride"] = 136.77}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 26.18, ["Fly"] = 65.63, ["Ride"] = 29.82, ["Fly|Ride"] = 89.99, ["Neon"] = 87.05, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 142.55, ["Mega"] = 389.82, ["Mega|Ride"] = 408.19, ["Mega|Fly|Ride"] = 382.66}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 38.04, ["Fly"] = 79.92, ["Ride"] = 70.86, ["Fly|Ride"] = 158.18, ["Neon"] = 280.85, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 239.91, ["Mega|Ride"] = 1199.93, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 15.72, ["Ride"] = 14.44, ["Fly|Ride"] = 32.82, ["Neon"] = 2.63, ["Neon|Fly"] = 15.98, ["Neon|Ride"] = 18.01, ["Neon|Fly|Ride"] = 47.99, ["Mega"] = 18.38, ["Mega|Fly"] = 55.13, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 76.22}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 3.68, ["Ride"] = 26.4, ["Fly|Ride"] = 1346.59, ["Neon"] = 25.53, ["Neon|Ride"] = 95.99, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 177.19, ["Mega|Ride"] = 271.04, ["Mega|Fly|Ride"] = 282.98}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 15.72, ["Fly"] = 142.55, ["Ride"] = 31.21, ["Neon"] = 148.95, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 479.85, ["Mega"] = 586.69, ["Mega|Ride"] = 485.63, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 26.76, ["Neon"] = 2.63, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 138.3, ["Mega"] = 22.32, ["Mega|Ride"] = 65.54}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 7.44, ["Fly"] = 210, ["Ride"] = 32.29, ["Fly|Ride"] = 105, ["Neon"] = 70.52, ["Neon|Ride"] = 88.09, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 411.7, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 261.8, ["Mega|Fly|Ride"] = 425.52}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 20.98, ["Fly"] = 42.21, ["Ride"] = 26.17, ["Fly|Ride"] = 103.69, ["Neon"] = 129.68, ["Neon|Ride"] = 64.56, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 568.07, ["Mega|Fly|Ride"] = 667}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 2.63, ["Ride"] = 59.98, ["Fly|Ride"] = 76.01, ["Neon"] = 25.67, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 203.95, ["Mega"] = 170.63, ["Mega|Ride"] = 198.47, ["Mega|Fly|Ride"] = 284.04}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 15.73, ["Fly"] = 2127.56, ["Ride"] = 85.56, ["Neon"] = 504.24, ["Neon|Fly"] = 160.75, ["Neon|Ride"] = 388.5, ["Neon|Fly|Ride"] = 6397.5, ["Mega|Ride"] = 1149.11, ["Mega|Fly|Ride"] = 1149.11}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 125.58, ["Fly|Ride"] = 196.88, ["Neon"] = 6.57, ["Neon|Fly"] = 51.08, ["Neon|Ride"] = 21.29, ["Mega"] = 74.82, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 127.66}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 28.73, ["Neon"] = 3.71, ["Mega"] = 24.83, ["Mega|Ride"] = 153.19, ["Mega|Fly|Ride"] = 422.63}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 36.64}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 74.39, ["Fly"] = 102.38, ["Ride"] = 78.75, ["Fly|Ride"] = 118.09, ["Neon"] = 1050, ["Neon|Ride"] = 248.94, ["Neon|Fly|Ride"] = 1063.78, ["Mega"] = 993.58, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 780.93}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Ride"] = 84, ["Fly|Ride"] = 142.55, ["Neon"] = 3.15, ["Mega"] = 21, ["Mega|Fly"] = 137.82, ["Mega|Ride"] = 106.39, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 527.85, ["Ride"] = 472.49, ["Fly|Ride"] = 656.25, ["Neon"] = 1987.13, ["Neon|Fly|Ride"] = 2411.57, ["Mega"] = 17020.27, ["Mega|Fly|Ride"] = 14184.29}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 6.4, ["Fly"] = 25.71, ["Ride"] = 42.56, ["Fly|Ride"] = 79.8, ["Neon"] = 12.85, ["Neon|Ride"] = 280.85, ["Mega"] = 79.8, ["Mega|Ride"] = 80.39, ["Mega|Fly|Ride"] = 568.07}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 3.93, ["Fly"] = 44.7, ["Ride"] = 23.25, ["Fly|Ride"] = 55.13, ["Neon"] = 21.29, ["Neon|Ride"] = 35.6, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 270.21, ["Mega|Ride"] = 140.54, ["Mega|Fly|Ride"] = 255.94}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 12.5, ["Ride"] = 76.13, ["Fly|Ride"] = 106.31, ["Neon"] = 79.8, ["Neon|Ride"] = 116.82, ["Mega"] = 393.75, ["Mega|Ride"] = 383.25, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 3.62, ["Fly"] = 39.38, ["Ride"] = 31.5, ["Fly|Ride"] = 142.55, ["Mega"] = 255.94}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 12.59, ["Ride"] = 210, ["Fly|Ride"] = 157.43, ["Neon"] = 196.88, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 160.76, ["Mega"] = 361.69, ["Mega|Ride"] = 423.4, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 7.91, ["Fly"] = 104.98, ["Ride"] = 39.38, ["Fly|Ride"] = 191.49, ["Neon"] = 51.19, ["Neon|Ride"] = 93.61, ["Neon|Fly|Ride"] = 142.55, ["Mega"] = 168, ["Mega|Fly"] = 493.6, ["Mega|Ride"] = 393.75}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 36.19, ["Ride"] = 15.98, ["Fly|Ride"] = 29.79, ["Neon"] = 2.1, ["Neon|Ride"] = 21.29, ["Neon|Fly|Ride"] = 70.23, ["Mega"] = 19.41, ["Mega|Fly"] = 60.78, ["Mega|Ride"] = 28.73, ["Mega|Fly|Ride"] = 122.38}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 9.55, ["Ride"] = 27.57, ["Fly|Ride"] = 160.76, ["Neon"] = 35.6, ["Neon|Fly"] = 119.98, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 319.1, ["Mega"] = 170.63, ["Mega|Ride"] = 217.88, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 276.6, ["Ride"] = 311.66, ["Fly|Ride"] = 372.51, ["Neon"] = 1480.5, ["Neon|Ride"] = 1114.84, ["Neon|Fly|Ride"] = 1133.98, ["Mega|Fly|Ride"] = 4200}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 91.88, ["Fly"] = 157.45, ["Ride"] = 137.27, ["Fly|Ride"] = 7717.5, ["Neon"] = 431.62, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 623.44, ["Mega"] = 4255.09, ["Mega|Ride"] = 1744.59, ["Mega|Fly|Ride"] = 1603.88}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 23.42, ["Ride"] = 18.94, ["Fly|Ride"] = 39.38, ["Neon"] = 19.69, ["Neon|Fly"] = 18.36, ["Neon|Ride"] = 33.53, ["Neon|Fly|Ride"] = 62.67, ["Mega"] = 91.5, ["Mega|Fly"] = 211.71, ["Mega|Ride"] = 92.56, ["Mega|Fly|Ride"] = 153.08}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 17.07, ["Fly|Ride"] = 34.13, ["Neon"] = 6.39, ["Neon|Fly"] = 32.41, ["Neon|Ride"] = 24.01, ["Neon|Fly|Ride"] = 70.61, ["Mega"] = 79.74, ["Mega|Fly"] = 355.31, ["Mega|Ride"] = 93.19, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.61, ["Ride"] = 19.21, ["Fly|Ride"] = 98.44, ["Neon"] = 38.07, ["Neon|Fly|Ride"] = 425.52, ["Mega"] = 142.55, ["Mega|Ride"] = 211.71, ["Mega|Fly|Ride"] = 268.82}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 210, ["Ride"] = 269.03, ["Fly|Ride"] = 328.13, ["Neon|Ride"] = 1030.76, ["Neon|Fly|Ride"] = 1321.21, ["Mega|Ride"] = 8510.14, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.1, ["Fly"] = 24, ["Ride"] = 18, ["Fly|Ride"] = 37.2, ["Neon"] = 26.25, ["Neon|Fly"] = 32.41, ["Neon|Ride"] = 32.41, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 355.31, ["Mega|Ride"] = 255.32, ["Mega|Fly|Ride"] = 262.48}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 3.89, ["Fly"] = 160.75, ["Ride"] = 42.56, ["Fly|Ride"] = 212.77, ["Neon"] = 34.13, ["Neon|Ride"] = 74.84, ["Mega"] = 196.88, ["Mega|Ride"] = 236.24, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 19.16, ["Neon"] = 9.6, ["Neon|Ride"] = 29.3, ["Mega"] = 38.66, ["Mega|Ride"] = 95.7, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 11.81, ["Fly"] = 568.07, ["Ride"] = 27.57, ["Fly|Ride"] = 70.82, ["Neon"] = 143.97, ["Neon|Ride"] = 91.5, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 728.34, ["Mega|Ride"] = 369.14, ["Mega|Fly|Ride"] = 397.87}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 59.85, ["Ride"] = 101.01, ["Fly|Ride"] = 249.38, ["Neon"] = 142.55, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 189.45, ["Neon|Fly|Ride"] = 368.84, ["Mega"] = 458.5, ["Mega|Fly"] = 2233.92, ["Mega|Ride"] = 493.5, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 23.14, ["Fly"] = 64.79, ["Ride"] = 53.81, ["Fly|Ride"] = 142.54, ["Neon"] = 118.13, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 176.72, ["Neon|Fly|Ride"] = 235.87, ["Mega|Ride"] = 800.15, ["Mega|Fly|Ride"] = 800.15}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 17.05, ["Ride"] = 15.98, ["Fly|Ride"] = 42.56, ["Neon"] = 2.61, ["Neon|Fly"] = 19.02, ["Neon|Ride"] = 21.29, ["Neon|Fly|Ride"] = 61.63, ["Mega"] = 21.1, ["Mega|Fly"] = 36.75, ["Mega|Ride"] = 45.76, ["Mega|Fly|Ride"] = 114.35}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 204.74, ["Fly"] = 278.24, ["Ride"] = 277.28, ["Fly|Ride"] = 345.19, ["Neon"] = 1257.48, ["Neon|Ride"] = 958.13, ["Neon|Fly|Ride"] = 1173.83, ["Mega|Fly|Ride"] = 4199.99}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 10.05, ["Fly"] = 140.39, ["Ride"] = 42.2, ["Fly|Ride"] = 131.51, ["Neon"] = 105, ["Neon|Ride"] = 126.6, ["Neon|Fly|Ride"] = 321.56, ["Mega"] = 485.63, ["Mega|Ride"] = 539.34, ["Mega|Fly|Ride"] = 538.13}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 16.37, ["Ride"] = 18.38, ["Fly|Ride"] = 39.3, ["Neon"] = 6.46, ["Neon|Fly"] = 27.57, ["Neon|Ride"] = 32.41, ["Mega"] = 49.24, ["Mega|Fly"] = 181.92, ["Mega|Ride"] = 141.38, ["Mega|Fly|Ride"] = 304.71}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 28.73, ["Ride"] = 17.07, ["Fly|Ride"] = 56.9, ["Neon"] = 3.13, ["Neon|Fly"] = 48, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 97.34, ["Mega"] = 27.67, ["Mega|Fly"] = 142.55, ["Mega|Ride"] = 56.4, ["Mega|Fly|Ride"] = 139.13}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 19.18, ["Fly|Ride"] = 142.54, ["Neon"] = 9.12, ["Neon|Fly|Ride"] = 7092.16, ["Mega"] = 92.92, ["Mega|Fly|Ride"] = 397.87}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 12.48, ["Fly"] = 65.63, ["Ride"] = 28.72, ["Fly|Ride"] = 50.76, ["Neon"] = 60.04, ["Neon|Ride"] = 61.69, ["Neon|Fly|Ride"] = 123.38, ["Mega"] = 358.7, ["Mega|Ride"] = 284.04, ["Mega|Fly|Ride"] = 334.69}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 6.82, ["Fly|Ride"] = 72.19, ["Neon"] = 39.38, ["Neon|Ride"] = 42.95, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 236.25, ["Mega|Ride"] = 326.59, ["Mega|Fly|Ride"] = 480.83}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Fly"] = 21.12, ["Neon"] = 2.52, ["Neon|Ride"] = 41.67, ["Neon|Fly|Ride"] = 100.02, ["Mega"] = 31.48, ["Mega|Ride"] = 82.9, ["Mega|Fly|Ride"] = 425.52}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 7.82, ["Ride"] = 30.18, ["Fly|Ride"] = 85.12, ["Neon"] = 19.69, ["Neon|Fly"] = 102.92, ["Neon|Ride"] = 56.88, ["Neon|Fly|Ride"] = 160.74, ["Mega"] = 157.5, ["Mega|Fly"] = 270.21, ["Mega|Ride"] = 221.28, ["Mega|Fly|Ride"] = 283.5}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 127.66, ["Fly|Ride"] = 100.02, ["Neon"] = 7.22, ["Neon|Fly"] = 85.12, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 160.76, ["Mega"] = 34.13, ["Mega|Ride"] = 91.34, ["Mega|Fly|Ride"] = 640.6}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 24.61, ["Ride"] = 17.07, ["Fly|Ride"] = 65.54, ["Neon"] = 7.87, ["Neon|Ride"] = 27.67, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 65.63, ["Mega|Ride"] = 85.22, ["Mega|Fly|Ride"] = 179.41}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 665.44, ["Fly"] = 525, ["Ride"] = 752.38, ["Fly|Ride"] = 656.24, ["Neon"] = 4237, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 3357.48, ["Mega"] = 12796.19, ["Mega|Fly|Ride"] = 12462.19}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 19.69, ["Fly|Ride"] = 49.88, ["Neon"] = 27.24, ["Neon|Fly"] = 51.08, ["Neon|Ride"] = 57.44, ["Neon|Fly|Ride"] = 56.58, ["Mega"] = 190.43, ["Mega|Fly|Ride"] = 211.71}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 3.93, ["Ride"] = 69.57, ["Fly|Ride"] = 105.51, ["Neon"] = 6.57, ["Neon|Fly"] = 851.03, ["Neon|Ride"] = 52.46, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 49.88, ["Mega|Fly"] = 142.55, ["Mega|Ride"] = 98.44, ["Mega|Fly|Ride"] = 160.13}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 6.56, ["Fly"] = 32.82, ["Ride"] = 22.32, ["Fly|Ride"] = 45.6, ["Neon"] = 52.5, ["Neon|Fly"] = 112.74, ["Neon|Ride"] = 43.19, ["Neon|Fly|Ride"] = 123.52, ["Mega"] = 313.83, ["Mega|Ride"] = 305.54, ["Mega|Fly|Ride"] = 335.99}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 10.18, ["Ride"] = 13.2, ["Fly|Ride"] = 32.82, ["Neon"] = 5.99, ["Neon|Fly"] = 131.24, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 55.47, ["Mega"] = 63.31, ["Mega|Fly"] = 349.84, ["Mega|Ride"] = 99.75, ["Mega|Fly|Ride"] = 178.68}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 56.4, ["Fly|Ride"] = 212.77, ["Neon"] = 217.88, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 807.41, ["Mega|Ride"] = 1419.08, ["Mega|Fly|Ride"] = 848.91}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 27.57, ["Fly|Ride"] = 89.38, ["Neon"] = 7.69, ["Neon|Fly"] = 136.76, ["Neon|Ride"] = 32.41, ["Neon|Fly|Ride"] = 206.07, ["Mega"] = 59.07, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 351.75}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 3.42, ["Fly"] = 73.5, ["Ride"] = 23.29, ["Fly|Ride"] = 61.71, ["Neon"] = 15.74, ["Neon|Fly"] = 143.96, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 127.66, ["Mega"] = 129.8, ["Mega|Ride"] = 142.34, ["Mega|Fly|Ride"] = 147}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Fly|Ride"] = 65.76, ["Neon"] = 15.75, ["Neon|Fly"] = 64.79, ["Mega"] = 115.97, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Ride"] = 20.96, ["Fly|Ride"] = 85.12, ["Neon"] = 5.25, ["Neon|Ride"] = 29.89, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 45.41, ["Mega|Fly"] = 157.45, ["Mega|Ride"] = 59.06, ["Mega|Fly|Ride"] = 171.94}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 17.3, ["Fly"] = 21.11, ["Ride"] = 19.67, ["Fly|Ride"] = 43.32, ["Neon"] = 137.82, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 109.58, ["Mega"] = 851.03, ["Mega|Ride"] = 391.48, ["Mega|Fly|Ride"] = 434.44}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 656.25, ["Ride"] = 746.82, ["Fly|Ride"] = 838.69, ["Neon"] = 1938.57, ["Neon|Ride"] = 2340.3, ["Neon|Fly|Ride"] = 1890, ["Mega"] = 8292.01, ["Mega|Ride"] = 5643.75, ["Mega|Fly|Ride"] = 5775}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 23.42, ["Ride"] = 14.39, ["Fly|Ride"] = 43.31, ["Neon"] = 3.93, ["Neon|Fly"] = 139.19, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 60.38, ["Mega"] = 53.81, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 195.33}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 4.72, ["Ride"] = 38.67, ["Fly|Ride"] = 92.18, ["Neon"] = 46.8, ["Neon|Fly"] = 105.33, ["Neon|Ride"] = 115.5, ["Neon|Fly|Ride"] = 248.11, ["Mega"] = 328.13, ["Mega|Ride"] = 351.75, ["Mega|Fly|Ride"] = 539.34}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 73.5, ["Fly"] = 157.5, ["Ride"] = 78.75, ["Fly|Ride"] = 142.55, ["Neon"] = 380.84, ["Neon|Ride"] = 355.31, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 1544.61, ["Mega|Ride"] = 1560.56, ["Mega|Fly|Ride"] = 1581.36}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 41.97, ["Ride"] = 55.12, ["Neon"] = 198.95, ["Neon|Ride"] = 177.55, ["Neon|Fly|Ride"] = 284.04, ["Mega"] = 935.06, ["Mega|Ride"] = 808.48, ["Mega|Fly|Ride"] = 1036.13}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 14.44, ["Ride"] = 26.25, ["Fly|Ride"] = 142.44, ["Neon"] = 82.69, ["Neon|Ride"] = 160.75, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 319.14, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 416.07}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 26.25, ["Ride"] = 99.75, ["Neon"] = 72.19, ["Neon|Fly"] = 316.68, ["Neon|Ride"] = 368.27, ["Mega"] = 282.98, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 526.98}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 18.94, ["Fly"] = 63, ["Ride"] = 106.39, ["Neon"] = 131.25, ["Neon|Ride"] = 158.82, ["Neon|Fly|Ride"] = 525, ["Mega"] = 924, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 1053.29}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 17.07}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 5.86, ["Fly"] = 80.38, ["Ride"] = 31.91, ["Fly|Ride"] = 64.79, ["Neon"] = 40.27, ["Neon|Ride"] = 99.19, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 189, ["Mega|Fly"] = 239.94, ["Mega|Ride"] = 216.57, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 3.94, ["Ride"] = 48, ["Neon"] = 31.5, ["Mega"] = 348.92, ["Mega|Fly|Ride"] = 957.41}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 72.17, ["Fly"] = 393.75, ["Ride"] = 86.57, ["Fly|Ride"] = 111.57, ["Neon"] = 344.68, ["Neon|Ride"] = 282.98, ["Neon|Fly|Ride"] = 403.94, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 937.2}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.62, ["Fly"] = 13.13, ["Ride"] = 16.9, ["Fly|Ride"] = 45.94, ["Neon"] = 18.38, ["Neon|Fly"] = 42.55, ["Neon|Ride"] = 38.31, ["Neon|Fly|Ride"] = 64.72, ["Mega"] = 262.5, ["Mega|Fly"] = 424.46, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 260.21}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 8.5, ["Fly"] = 85.12, ["Ride"] = 31.49, ["Fly|Ride"] = 61.71, ["Neon"] = 26.99, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 140.44, ["Mega"] = 131.25, ["Mega|Ride"] = 178.5, ["Mega|Fly|Ride"] = 252.45}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 6.4, ["Neon|Ride"] = 91.5, ["Mega"] = 34.13, ["Mega|Ride"] = 140.38, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 31.5, ["Fly"] = 65.63, ["Ride"] = 65.93, ["Fly|Ride"] = 78.73, ["Neon"] = 131.25, ["Neon|Ride"] = 297.88, ["Neon|Fly|Ride"] = 284.04, ["Mega"] = 1135.05, ["Mega|Ride"] = 838.03, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 23.78, ["Fly|Ride"] = 85.12, ["Neon"] = 13.13, ["Neon|Fly"] = 291.38, ["Neon|Ride"] = 71.29, ["Mega"] = 142.55, ["Mega|Fly|Ride"] = 309.68}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 12.47, ["Ride"] = 73.5, ["Neon"] = 80.39, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 353.19, ["Mega"] = 288.75, ["Mega|Ride"] = 494.82, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 18.87, ["Ride"] = 16.94, ["Fly|Ride"] = 28.88, ["Neon"] = 21, ["Neon|Ride"] = 23.42, ["Neon|Fly|Ride"] = 78.72, ["Mega|Ride"] = 234.29, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 7.88, ["Fly"] = 52.5, ["Ride"] = 24.49, ["Fly|Ride"] = 52.5, ["Neon"] = 76.6, ["Neon|Ride"] = 177.19, ["Mega"] = 276.6, ["Mega|Ride"] = 248.94, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 3.83, ["Ride"] = 36.53, ["Neon"] = 28.43, ["Neon|Ride"] = 262.5, ["Mega"] = 113.85, ["Mega|Ride"] = 830.17}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 39.38, ["Ride"] = 105, ["Neon"] = 220.5, ["Neon|Ride"] = 329.78, ["Mega"] = 1062.72, ["Mega|Ride"] = 1419.08, ["Mega|Fly|Ride"] = 1382.91}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 15.59, ["Ride"] = 284.04, ["Neon"] = 210, ["Mega"] = 389.82, ["Mega|Ride"] = 657.42, ["Mega|Fly|Ride"] = 498.1}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 9.19, ["Ride"] = 89.87, ["Fly|Ride"] = 284.04, ["Neon"] = 92.56, ["Neon|Ride"] = 393.75, ["Mega"] = 595.73, ["Mega|Ride"] = 560.62, ["Mega|Fly|Ride"] = 1702.04}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 28.59, ["Ride"] = 76.6, ["Fly|Ride"] = 422.03, ["Neon"] = 468.57, ["Neon|Ride"] = 638.27, ["Neon|Fly|Ride"] = 459.56, ["Mega"] = 945, ["Mega|Ride"] = 1110.81, ["Mega|Fly|Ride"] = 1042.79}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 3.15, ["Neon"] = 40.69, ["Neon|Ride"] = 284.04, ["Mega"] = 309.51}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 17.71, ["Fly|Ride"] = 41.91, ["Neon"] = 6.04, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 25.55, ["Neon|Fly|Ride"] = 137.82, ["Mega"] = 60.38, ["Mega|Ride"] = 89.25, ["Mega|Fly|Ride"] = 186.8}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 9.18, ["Ride"] = 43.32, ["Neon"] = 35.97, ["Neon|Fly"] = 71.29, ["Neon|Ride"] = 61.71, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 184.75, ["Mega|Ride"] = 160.76, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 31.49, ["Ride"] = 17.85, ["Fly|Ride"] = 55.13, ["Neon"] = 6.57, ["Neon|Ride"] = 25.55, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 48, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 149.6}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 3.93, ["Fly"] = 131.25, ["Fly|Ride"] = 100.02, ["Neon"] = 39.38, ["Neon|Ride"] = 93.62, ["Neon|Fly|Ride"] = 113.85, ["Mega"] = 225.53, ["Mega|Ride"] = 169.32, ["Mega|Fly|Ride"] = 479.85}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.82, ["Ride"] = 32.82, ["Fly|Ride"] = 99.75, ["Neon"] = 39.38, ["Neon|Fly"] = 479.83, ["Neon|Ride"] = 98.59, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 416.8, ["Mega|Fly|Ride"] = 959.69}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 6.57, ["Fly"] = 131.25, ["Ride"] = 28.73, ["Fly|Ride"] = 61.71, ["Neon"] = 32.97, ["Neon|Fly"] = 104.77, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 106.55, ["Mega"] = 221.29, ["Mega|Ride"] = 252, ["Mega|Fly|Ride"] = 394.42}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 34.07, ["Ride"] = 16.69, ["Fly|Ride"] = 63.83, ["Neon"] = 28.73, ["Neon|Fly"] = 85.12, ["Neon|Ride"] = 142.55, ["Neon|Fly|Ride"] = 192.94, ["Mega"] = 142.55, ["Mega|Ride"] = 285.1, ["Mega|Fly|Ride"] = 353.19}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 4.72, ["Fly"] = 26.25, ["Ride"] = 41.5, ["Fly|Ride"] = 179.82, ["Neon"] = 21.41, ["Neon|Fly"] = 437.07, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 114.66, ["Mega|Ride"] = 152.1, ["Mega|Fly|Ride"] = 313.83}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 15.75, ["Fly"] = 105, ["Ride"] = 97.13, ["Fly|Ride"] = 272.4, ["Neon"] = 98.44, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 565.69, ["Mega"] = 384.57, ["Mega|Fly"] = 669.38, ["Mega|Ride"] = 440.9, ["Mega|Fly|Ride"] = 566.29}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 64.32, ["Fly"] = 239.93, ["Ride"] = 95.64, ["Fly|Ride"] = 259.58, ["Neon"] = 307.39, ["Neon|Ride"] = 269.07, ["Neon|Fly|Ride"] = 397.32, ["Mega"] = 1050, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 1014.02}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 51.01, ["Ride"] = 21.29, ["Fly|Ride"] = 65.54, ["Neon"] = 5.55, ["Neon|Ride"] = 38.06, ["Mega"] = 29.77, ["Mega|Ride"] = 71.14, ["Mega|Fly|Ride"] = 131.15}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 16.95, ["Neon"] = 284.04, ["Mega"] = 859.04, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 1276.53}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 56.35, ["Ride"] = 116.82, ["Neon"] = 191.96, ["Neon|Ride"] = 304.71, ["Neon|Fly|Ride"] = 508.5, ["Mega"] = 1736.09, ["Mega|Ride"] = 1114.84, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 6.55, ["Fly"] = 190.32, ["Ride"] = 43.2, ["Fly|Ride"] = 126, ["Neon"] = 40.58, ["Neon|Ride"] = 77.44, ["Mega"] = 227.73, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 465.29}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 2.1, ["Fly"] = 157.5, ["Ride"] = 19.67, ["Fly|Ride"] = 105.33, ["Neon"] = 3.82, ["Neon|Ride"] = 32.4, ["Mega"] = 24.94, ["Mega|Ride"] = 62.08, ["Mega|Fly|Ride"] = 136.67}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.63, ["Fly"] = 52.5, ["Ride"] = 15.74, ["Fly|Ride"] = 53.82, ["Neon"] = 15.74, ["Neon|Ride"] = 24.01, ["Neon|Fly|Ride"] = 112.88, ["Mega"] = 177.18, ["Mega|Fly"] = 355.31, ["Mega|Ride"] = 235.11, ["Mega|Fly|Ride"] = 177.18}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 19.16, ["Ride"] = 18.38, ["Fly|Ride"] = 35.44, ["Neon"] = 2.63, ["Neon|Fly"] = 21, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 59.59, ["Mega"] = 34.13, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Fly"] = 42.56, ["Ride"] = 25.99, ["Fly|Ride"] = 65.7, ["Neon"] = 3.91, ["Neon|Ride"] = 37.25, ["Neon|Fly|Ride"] = 124.69, ["Mega"] = 37.25, ["Mega|Fly"] = 168, ["Mega|Ride"] = 65.62, ["Mega|Fly|Ride"] = 241.77}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Fly|Ride"] = 160.76, ["Neon"] = 2.52, ["Neon|Ride"] = 126.27, ["Mega"] = 28.6, ["Mega|Ride"] = 104.85, ["Mega|Fly|Ride"] = 263.83}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 4.39, ["Ride"] = 40.8, ["Fly|Ride"] = 262.5, ["Neon"] = 57.44, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 210.65, ["Mega"] = 203.2, ["Mega|Ride"] = 231, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 11.47, ["Ride"] = 35.44, ["Fly|Ride"] = 85.12, ["Neon"] = 63.83, ["Neon|Ride"] = 97.13, ["Neon|Fly|Ride"] = 238.73, ["Mega"] = 328.13, ["Mega|Fly|Ride"] = 643}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 6.19, ["Fly"] = 33.75, ["Ride"] = 19.69, ["Fly|Ride"] = 48.19, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 60.37, ["Neon|Fly|Ride"] = 86.4, ["Mega|Ride"] = 334.69, ["Mega|Fly|Ride"] = 325.5}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 74.55, ["Ride"] = 144.37, ["Fly|Ride"] = 262.5, ["Neon"] = 538.13, ["Neon|Ride"] = 597.19, ["Mega"] = 3199.37, ["Mega|Fly|Ride"] = 1574.39}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 20.65, ["Fly"] = 72.43, ["Ride"] = 65.63, ["Fly|Ride"] = 59.07, ["Neon"] = 57.46, ["Mega"] = 633.29, ["Mega|Ride"] = 284.04, ["Mega|Fly|Ride"] = 1280.36}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 17.93, ["Ride"] = 17.94, ["Fly|Ride"] = 36.74, ["Neon"] = 3.15, ["Neon|Fly"] = 28.73, ["Neon|Ride"] = 24.43, ["Neon|Fly|Ride"] = 48, ["Mega"] = 42.56, ["Mega|Ride"] = 113.85, ["Mega|Fly|Ride"] = 108.94}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 15.96, ["Ride"] = 18.98, ["Fly|Ride"] = 31.5, ["Neon"] = 4.81, ["Neon|Fly"] = 23.5, ["Neon|Ride"] = 18.01, ["Neon|Fly|Ride"] = 49.45, ["Mega"] = 48.93, ["Mega|Ride"] = 57.6, ["Mega|Fly|Ride"] = 101.04}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 393.75, ["Ride"] = 431.75, ["Fly|Ride"] = 455.77, ["Neon|Ride"] = 1808.42, ["Neon|Fly|Ride"] = 1509.38}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 14.43, ["Fly|Ride"] = 241.78, ["Neon"] = 91.88, ["Mega"] = 355.31, ["Mega|Ride"] = 610.62, ["Mega|Fly|Ride"] = 1276.53}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 19.16, ["Ride"] = 18.38, ["Fly|Ride"] = 39.38, ["Neon"] = 3.93, ["Neon|Ride"] = 20.74, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 55.34, ["Mega|Ride"] = 74.82, ["Mega|Fly|Ride"] = 116.25}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 80.38, ["Ride"] = 127.66, ["Fly|Ride"] = 507.94, ["Neon"] = 262.5, ["Neon|Ride"] = 303.18, ["Neon|Fly|Ride"] = 425.52, ["Mega"] = 737.63, ["Mega|Ride"] = 748.13, ["Mega|Fly|Ride"] = 914.86}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 16.02, ["Ride"] = 18.96, ["Fly|Ride"] = 45.07, ["Neon"] = 15.75, ["Neon|Fly"] = 48, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 83.36, ["Mega"] = 104.27, ["Mega|Fly"] = 160.13, ["Mega|Ride"] = 96.36, ["Mega|Fly|Ride"] = 194.29}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 71.29, ["Ride"] = 47.99, ["Fly|Ride"] = 1312.5, ["Neon"] = 3.93, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 13.13, ["Mega|Fly"] = 142.55, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 51.19, ["Fly"] = 142.55, ["Ride"] = 89.3, ["Neon"] = 211.32, ["Neon|Ride"] = 257.27, ["Neon|Fly|Ride"] = 335.9, ["Mega"] = 830.82, ["Mega|Ride"] = 629.94, ["Mega|Fly|Ride"] = 835.07}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Ride"] = 23.63, ["Neon"] = 7.2, ["Neon|Ride"] = 55.34, ["Neon|Fly|Ride"] = 127.66, ["Mega"] = 98.54, ["Mega|Ride"] = 129.84, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 36.75, ["Ride"] = 64.79, ["Neon"] = 270.21, ["Neon|Ride"] = 184.53, ["Neon|Fly|Ride"] = 319.14, ["Mega"] = 1041.45, ["Mega|Ride"] = 1702.04, ["Mega|Fly|Ride"] = 1061.66}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 4.6, ["Ride"] = 45.02, ["Fly|Ride"] = 212.77, ["Neon"] = 23.63, ["Neon|Ride"] = 203.44, ["Neon|Fly|Ride"] = 425.52, ["Mega"] = 142.55, ["Mega|Ride"] = 603.75, ["Mega|Fly|Ride"] = 460.04}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 3.71, ["Fly"] = 71.29, ["Ride"] = 71.29, ["Fly|Ride"] = 65.63, ["Neon"] = 6.57, ["Neon|Fly"] = 78.54, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 78.73, ["Mega|Ride"] = 728.43, ["Mega|Fly|Ride"] = 568.07}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 18.36, ["Ride"] = 55.23, ["Fly|Ride"] = 104.81, ["Neon"] = 160.76, ["Neon|Ride"] = 131.25, ["Mega|Ride"] = 2040.94, ["Mega|Fly|Ride"] = 1131.86}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 144.82, ["Ride"] = 54.26, ["Fly|Ride"] = 908.98, ["Neon"] = 6.45, ["Neon|Ride"] = 28.73, ["Neon|Fly|Ride"] = 163.84, ["Mega"] = 37.2, ["Mega|Fly"] = 158.61, ["Mega|Ride"] = 94.8, ["Mega|Fly|Ride"] = 228.9}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 57.46, ["Ride"] = 19.69, ["Fly|Ride"] = 102.85, ["Neon"] = 6.3, ["Neon|Fly"] = 41.88, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 105.92, ["Mega"] = 168, ["Mega|Ride"] = 178.5, ["Mega|Fly|Ride"] = 291.48}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 8.48, ["Fly"] = 35.6, ["Ride"] = 40.8, ["Fly|Ride"] = 191.96, ["Neon"] = 63.19, ["Neon|Ride"] = 120.75, ["Mega"] = 284.04, ["Mega|Ride"] = 333.77, ["Mega|Fly|Ride"] = 377.99}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 37.95, ["Ride"] = 65.63, ["Fly|Ride"] = 141.03, ["Neon"] = 209.99, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 608.22, ["Mega"] = 814.99, ["Mega|Ride"] = 773.67, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 32.7, ["Fly"] = 30.19, ["Ride"] = 35.41, ["Fly|Ride"] = 77.44, ["Neon"] = 105.58, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 85.31, ["Neon|Fly|Ride"] = 142.55, ["Mega"] = 620.57, ["Mega|Ride"] = 355.31, ["Mega|Fly|Ride"] = 396.38}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 69.57, ["Ride"] = 131.25, ["Fly|Ride"] = 196.85, ["Neon"] = 287.44, ["Neon|Ride"] = 322.34, ["Neon|Fly|Ride"] = 425.52, ["Mega"] = 1419.08, ["Mega|Ride"] = 1302, ["Mega|Fly|Ride"] = 1250.69}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 5.16, ["Ride"] = 35.44, ["Neon"] = 15.98, ["Neon|Ride"] = 54.26, ["Neon|Fly|Ride"] = 305.8, ["Mega"] = 185.11, ["Mega|Ride"] = 225.53, ["Mega|Fly|Ride"] = 327.48}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 6.08, ["Ride"] = 24.76, ["Fly|Ride"] = 109.58, ["Neon"] = 21.29, ["Neon|Ride"] = 49.88, ["Mega"] = 203.44, ["Mega|Ride"] = 194.38}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 12.81, ["Fly"] = 28.88, ["Ride"] = 43.99, ["Fly|Ride"] = 98.95, ["Neon"] = 56.37, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 185.11, ["Mega"] = 319.14, ["Mega|Ride"] = 326.59, ["Mega|Fly|Ride"] = 452.82}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.74, ["Ride"] = 11.79, ["Fly|Ride"] = 31.4, ["Neon"] = 2.1, ["Neon|Fly"] = 17.05, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 32.82, ["Mega"] = 16.96, ["Mega|Fly"] = 71.29, ["Mega|Ride"] = 23.63, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 59.07, ["Fly"] = 91.88, ["Ride"] = 65.63, ["Fly|Ride"] = 303.01, ["Neon"] = 241.48, ["Neon|Fly"] = 2411.57, ["Neon|Ride"] = 294, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 972.3, ["Mega|Ride"] = 807.19, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 95.75, ["Fly|Ride"] = 110.65, ["Neon"] = 3.7, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 43.2, ["Mega|Ride"] = 68.1, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 22.32, ["Ride"] = 19.69, ["Fly|Ride"] = 61.71, ["Neon"] = 21.06, ["Neon|Fly"] = 142.55, ["Neon|Ride"] = 32.44, ["Neon|Fly|Ride"] = 55.18, ["Mega"] = 118.13, ["Mega|Ride"] = 414.24, ["Mega|Fly|Ride"] = 284.04}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 77.95, ["Ride"] = 115.5, ["Fly|Ride"] = 320.33, ["Neon"] = 291.48, ["Neon|Ride"] = 288.75, ["Neon|Fly|Ride"] = 511.88, ["Mega"] = 1019.82, ["Mega|Ride"] = 1048.69, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 72.19, ["Neon"] = 7.77, ["Neon|Ride"] = 42.95, ["Mega"] = 59.85, ["Mega|Ride"] = 137.21, ["Mega|Fly|Ride"] = 276.6}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 6.57}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 34.06, ["Fly|Ride"] = 297.57, ["Neon"] = 5.99, ["Neon|Ride"] = 66.36, ["Neon|Fly|Ride"] = 160.76, ["Mega"] = 45.26, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 148.76, ["Ride"] = 185.22, ["Fly|Ride"] = 236.25, ["Neon"] = 538.13, ["Neon|Ride"] = 702.1, ["Neon|Fly|Ride"] = 708.75, ["Mega|Fly|Ride"] = 2493.75}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 3.93, ["Ride"] = 25.5, ["Neon"] = 15.96, ["Neon|Ride"] = 61.69, ["Neon|Fly|Ride"] = 110.65, ["Mega"] = 165.37, ["Mega|Ride"] = 179.95, ["Mega|Fly|Ride"] = 455.31}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Neon"] = 2.63, ["Neon|Ride"] = 20.19, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 31.84, ["Mega|Ride"] = 128.21, ["Mega|Fly|Ride"] = 142.55}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 6.57, ["Ride"] = 28.73, ["Neon"] = 51.1, ["Neon|Ride"] = 142.55, ["Neon|Fly|Ride"] = 170.22, ["Mega"] = 853.13, ["Mega|Ride"] = 638.27, ["Mega|Fly|Ride"] = 637.77}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 10.4, ["Fly"] = 28.88, ["Ride"] = 26.24, ["Fly|Ride"] = 157.5, ["Neon"] = 79.75, ["Neon|Ride"] = 91.5, ["Neon|Fly|Ride"] = 148.76, ["Mega"] = 587.35, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 47.36, ["Fly|Ride"] = 212.77, ["Neon"] = 220.5, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 482.9, ["Mega"] = 640.6, ["Mega|Ride"] = 733.49, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 150.67, ["Fly"] = 189.9, ["Ride"] = 192.25, ["Fly|Ride"] = 221.82, ["Neon"] = 538.12, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 576.19, ["Mega|Fly|Ride"] = 2100}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 8.92, ["Fly"] = 22.16, ["Ride"] = 19.67, ["Fly|Ride"] = 39.29, ["Neon"] = 91.88, ["Neon|Fly"] = 425.52, ["Neon|Ride"] = 62.84, ["Neon|Fly|Ride"] = 110.62, ["Mega|Ride"] = 455.31, ["Mega|Fly|Ride"] = 485.63}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.63, ["Fly"] = 131.23, ["Ride"] = 32.41, ["Fly|Ride"] = 131.25, ["Neon"] = 28.72, ["Neon|Ride"] = 35.69, ["Neon|Fly|Ride"] = 140.44, ["Mega"] = 137.82, ["Mega|Ride"] = 127.66, ["Mega|Fly|Ride"] = 355.31}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 17.07, ["Fly"] = 236.25, ["Ride"] = 69.15, ["Neon"] = 97.42, ["Mega"] = 380.63, ["Mega|Ride"] = 425.52, ["Mega|Fly|Ride"] = 560.62}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 44.63, ["Fly"] = 55.34, ["Ride"] = 74.82, ["Fly|Ride"] = 105.68, ["Neon"] = 210, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 282.98, ["Mega"] = 993.58, ["Mega|Ride"] = 931.88, ["Mega|Fly|Ride"] = 866.25}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 15.74, ["Ride"] = 81.86, ["Neon"] = 100.02, ["Neon|Ride"] = 126.62, ["Mega"] = 638.27, ["Mega|Ride"] = 752.1, ["Mega|Fly|Ride"] = 1063.78}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 309.75, ["Ride"] = 413.44, ["Neon"] = 774.43, ["Neon|Ride"] = 993.58, ["Mega|Fly|Ride"] = 4680.59}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 32.81, ["Ride"] = 32.4, ["Fly|Ride"] = 168.41, ["Neon|Ride"] = 284.04, ["Neon|Fly|Ride"] = 355.31, ["Mega"] = 984.38, ["Mega|Ride"] = 843.94, ["Mega|Fly|Ride"] = 842.52}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 16.14, ["Ride"] = 12.73, ["Fly|Ride"] = 67.65, ["Neon"] = 2.5, ["Neon|Fly"] = 19.21, ["Neon|Ride"] = 18.72, ["Neon|Fly|Ride"] = 56.39, ["Mega"] = 22.25, ["Mega|Fly"] = 108.51, ["Mega|Ride"] = 47.65, ["Mega|Fly|Ride"] = 91.88}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 3.94, ["Ride"] = 211.02, ["Neon"] = 19.69, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 126.62, ["Mega"] = 157.45, ["Mega|Fly"] = 124.69, ["Mega|Ride"] = 142.55, ["Mega|Fly|Ride"] = 373.42}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 3.76, ["Ride"] = 34.06, ["Fly|Ride"] = 144.16, ["Neon"] = 14.6, ["Neon|Ride"] = 78.28, ["Neon|Fly|Ride"] = 225.53, ["Mega"] = 135.31, ["Mega|Fly"] = 496.8, ["Mega|Ride"] = 136.84, ["Mega|Fly|Ride"] = 304.71}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 360.77, ["Fly"] = 640.61, ["Ride"] = 393.75, ["Fly|Ride"] = 431.82, ["Neon"] = 1702.04, ["Neon|Ride"] = 1631.47, ["Neon|Fly|Ride"] = 1518.01, ["Mega|Fly|Ride"] = 5033.44}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.1, ["Fly"] = 47.59, ["Ride"] = 16.84, ["Fly|Ride"] = 42.21, ["Neon"] = 24.94, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 78.35, ["Mega|Ride"] = 270.83, ["Mega|Fly|Ride"] = 425.52}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 6.3, ["Fly"] = 31.92, ["Ride"] = 17.05, ["Fly|Ride"] = 39.38, ["Neon"] = 27.67, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 71.29, ["Neon|Fly|Ride"] = 85.12, ["Mega|Ride"] = 709.55, ["Mega|Fly|Ride"] = 270.21}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 5.07, ["Fly"] = 85.12, ["Ride"] = 27.67, ["Fly|Ride"] = 65.63, ["Neon"] = 19, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 65.62, ["Neon|Fly|Ride"] = 121.28, ["Mega"] = 111.57, ["Mega|Ride"] = 196.87, ["Mega|Fly|Ride"] = 531.9}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 57.28, ["Fly"] = 210, ["Ride"] = 71.29, ["Fly|Ride"] = 61.69, ["Neon"] = 118.27, ["Neon|Ride"] = 185.11, ["Neon|Fly|Ride"] = 210, ["Mega"] = 957.41, ["Mega|Ride"] = 849.97, ["Mega|Fly|Ride"] = 581.89}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 31.35, ["Ride"] = 30.6, ["Fly|Ride"] = 52.9, ["Neon"] = 15.72, ["Neon|Ride"] = 114.19, ["Neon|Fly|Ride"] = 210, ["Mega"] = 157.24, ["Mega|Ride"] = 185.11, ["Mega|Fly|Ride"] = 952.23}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 4.81, ["Fly"] = 104.15, ["Ride"] = 28.87, ["Fly|Ride"] = 68.25, ["Neon"] = 113.82, ["Neon|Ride"] = 141.38, ["Mega|Ride"] = 609.77, ["Mega|Fly|Ride"] = 735.08}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 22.32, ["Neon"] = 6.29, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 28.71, ["Mega"] = 36.75, ["Mega|Ride"] = 135.12, ["Mega|Fly|Ride"] = 478.66}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 9.61, ["Ride"] = 57.46, ["Neon"] = 59.07, ["Mega"] = 357.96, ["Mega|Fly|Ride"] = 851.03}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 17.07, ["Ride"] = 57.44, ["Neon"] = 87.33, ["Mega"] = 328.13, ["Mega|Ride"] = 561.69, ["Mega|Fly|Ride"] = 499.98}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 6.56, ["Fly"] = 30.19, ["Ride"] = 23.63, ["Fly|Ride"] = 53.42, ["Neon"] = 61.94, ["Neon|Fly"] = 65.54, ["Neon|Ride"] = 64.14, ["Neon|Fly|Ride"] = 112.01, ["Mega"] = 595.73, ["Mega|Ride"] = 375.38, ["Mega|Fly|Ride"] = 392.27}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 181.13, ["Fly"] = 224.34, ["Ride"] = 183.75, ["Fly|Ride"] = 275.63, ["Neon"] = 870.18, ["Neon|Ride"] = 851.03, ["Neon|Fly|Ride"] = 917.84, ["Mega|Fly|Ride"] = 4240.2}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Fly"] = 27.67, ["Ride"] = 17.05, ["Fly|Ride"] = 48.95, ["Neon"] = 12.74, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 142.55, ["Mega"] = 220.5, ["Mega|Ride"] = 165.97, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 4.5, ["Fly"] = 42.56, ["Ride"] = 54.26, ["Fly|Ride"] = 103.8, ["Neon"] = 16.96, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 160.76, ["Mega"] = 252, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 410.82}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 55.13, ["Ride"] = 153.57, ["Fly|Ride"] = 369.14, ["Neon"] = 141.75, ["Neon|Ride"] = 206.38, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 441.49, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 493.5}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 99.74, ["Fly"] = 170.22, ["Ride"] = 150.82, ["Fly|Ride"] = 261.18, ["Neon"] = 472.5, ["Neon|Ride"] = 492.19, ["Neon|Fly|Ride"] = 679.76, ["Mega|Ride"] = 1744.59, ["Mega|Fly|Ride"] = 1648.5}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 37.16, ["Ride"] = 91.48, ["Neon"] = 78.75, ["Neon|Fly"] = 117.57, ["Neon|Ride"] = 122.07, ["Neon|Fly|Ride"] = 299.18, ["Mega"] = 255.94, ["Mega|Fly"] = 318.08, ["Mega|Ride"] = 338.63, ["Mega|Fly|Ride"] = 450.19}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 16.22, ["Fly|Ride"] = 46.5, ["Neon"] = 10.65, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 57.46, ["Mega|Ride"] = 185.11, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 14.44, ["Ride"] = 52.5, ["Fly|Ride"] = 9219.69, ["Neon"] = 71.28, ["Mega"] = 225.36, ["Mega|Ride"] = 290.61, ["Mega|Fly|Ride"] = 455.31}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 78.75, ["Ride"] = 118.13, ["Fly|Ride"] = 216.57, ["Neon"] = 142.58, ["Neon|Ride"] = 253.95, ["Neon|Fly|Ride"] = 396.81, ["Mega"] = 581.43, ["Mega|Ride"] = 594.55, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 3.15, ["Ride"] = 87.94, ["Neon"] = 10.5, ["Neon|Ride"] = 104.74, ["Neon|Fly|Ride"] = 147.51, ["Mega"] = 40.8, ["Mega|Fly"] = 163.84, ["Mega|Ride"] = 107.6, ["Mega|Fly|Ride"] = 417.01}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 15.23, ["Ride"] = 238.74, ["Neon"] = 65.63, ["Neon|Ride"] = 124.69, ["Mega"] = 410.41, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 977.81, ["Fly"] = 1347.81, ["Ride"] = 958.13, ["Fly|Ride"] = 1069.69, ["Neon|Ride"] = 3121.11, ["Neon|Fly|Ride"] = 3245.6, ["Mega|Fly|Ride"] = 13125}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 40.04, ["Ride"] = 111.56, ["Fly|Ride"] = 207.44, ["Neon"] = 187.71, ["Neon|Fly"] = 892.5, ["Neon|Ride"] = 287.9, ["Mega"] = 568.07, ["Mega|Ride"] = 564.87, ["Mega|Fly|Ride"] = 740.32}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 6.4, ["Fly"] = 49.18, ["Ride"] = 19.69, ["Fly|Ride"] = 112.77, ["Neon"] = 14.43, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 59.06, ["Mega|Ride"] = 108.94, ["Mega|Fly|Ride"] = 638.27}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 7.87, ["Ride"] = 131.22, ["Neon"] = 106.32, ["Mega|Ride"] = 539.34, ["Mega|Fly|Ride"] = 482.96}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 22.81, ["Fly|Ride"] = 61.71, ["Neon"] = 3.84, ["Neon|Ride"] = 27.36, ["Neon|Fly|Ride"] = 105.46, ["Mega"] = 19.16, ["Mega|Ride"] = 44.63, ["Mega|Fly|Ride"] = 179.13}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 85.32, ["Ride"] = 139.13, ["Fly|Ride"] = 262.5, ["Neon"] = 317.01, ["Neon|Ride"] = 370.9, ["Neon|Fly|Ride"] = 496.8, ["Mega"] = 1185.78, ["Mega|Ride"] = 1117.28, ["Mega|Fly|Ride"] = 1036.88}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 5.92, ["Ride"] = 52.5, ["Fly|Ride"] = 85.12, ["Neon"] = 38.66, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 350.44, ["Mega|Ride"] = 295.32, ["Mega|Fly|Ride"] = 340.41}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 5.25, ["Ride"] = 27.67, ["Neon"] = 13.13, ["Neon|Ride"] = 78.75, ["Mega"] = 142.55, ["Mega|Ride"] = 241.48, ["Mega|Fly|Ride"] = 376.6}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 51.18, ["Fly"] = 142.55, ["Ride"] = 91.25, ["Fly|Ride"] = 167.63, ["Neon"] = 181.02, ["Neon|Fly"] = 280.65, ["Neon|Ride"] = 212.77, ["Neon|Fly|Ride"] = 638.27, ["Mega"] = 638.27, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 922.29}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 17.75, ["Ride"] = 70.68, ["Fly|Ride"] = 196.88, ["Neon"] = 49.88, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 315, ["Mega"] = 624.44, ["Mega|Fly|Ride"] = 667}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 49.79, ["Neon"] = 779.63, ["Neon|Ride"] = 145.69, ["Neon|Fly|Ride"] = 1083.49, ["Mega"] = 1135.05, ["Mega|Ride"] = 1844.58, ["Mega|Fly|Ride"] = 2127.56}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 9.19, ["Ride"] = 75.54, ["Neon"] = 22.87, ["Neon|Ride"] = 100.02, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 118.95, ["Mega|Fly"] = 142.55, ["Mega|Ride"] = 147.94, ["Mega|Fly|Ride"] = 284.04}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 6.57, ["Fly"] = 32.15, ["Ride"] = 21.61, ["Fly|Ride"] = 78.75, ["Neon"] = 47.98, ["Neon|Ride"] = 100.02, ["Neon|Fly|Ride"] = 139.12, ["Mega"] = 399, ["Mega|Ride"] = 392.44, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 137.82, ["Ride"] = 157.5, ["Fly|Ride"] = 232.61, ["Neon"] = 579.83, ["Neon|Fly"] = 667, ["Neon|Ride"] = 580.38, ["Neon|Fly|Ride"] = 621.18, ["Mega|Ride"] = 2361.19, ["Mega|Fly|Ride"] = 1903.13}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 19.21, ["Ride"] = 17.07, ["Fly|Ride"] = 28.72, ["Neon"] = 8.75, ["Neon|Fly"] = 64.31, ["Neon|Ride"] = 27.2, ["Neon|Fly|Ride"] = 59.98, ["Mega"] = 145.69, ["Mega|Ride"] = 136.5, ["Mega|Fly|Ride"] = 575.84}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 6.57, ["Fly"] = 87.93, ["Ride"] = 18.38, ["Fly|Ride"] = 78.59, ["Neon"] = 39.38, ["Neon|Fly"] = 281.17, ["Neon|Ride"] = 51.14, ["Neon|Fly|Ride"] = 119.98, ["Mega"] = 203.2, ["Mega|Ride"] = 200.16, ["Mega|Fly|Ride"] = 284.04}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Ride"] = 15.96, ["Fly|Ride"] = 36.66, ["Neon"] = 2.1, ["Neon|Fly"] = 16.69, ["Neon|Ride"] = 17.98, ["Neon|Fly|Ride"] = 52.49, ["Mega"] = 20.97, ["Mega|Ride"] = 40.99, ["Mega|Fly|Ride"] = 85.32}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 42.28, ["Neon"] = 3.94, ["Neon|Ride"] = 40.44, ["Mega"] = 21.17, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 64.32, ["Mega|Fly|Ride"] = 140.43}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 3.93, ["Fly"] = 131.25, ["Ride"] = 27.67, ["Fly|Ride"] = 45.94, ["Neon"] = 20.98, ["Neon|Ride"] = 23.63, ["Mega"] = 112.77, ["Mega|Ride"] = 152.3}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 82.69, ["Ride"] = 84, ["Neon"] = 271.27, ["Neon|Ride"] = 425.52, ["Neon|Fly|Ride"] = 630, ["Mega"] = 774.38, ["Mega|Fly|Ride"] = 654.23}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.1, ["Fly"] = 18.8, ["Ride"] = 17.07, ["Fly|Ride"] = 30.19, ["Neon"] = 12.49, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 24.99, ["Neon|Fly|Ride"] = 69.07, ["Mega"] = 91.68, ["Mega|Fly"] = 164.04, ["Mega|Ride"] = 113.85, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 3.18, ["Fly"] = 28.3, ["Ride"] = 22.32, ["Fly|Ride"] = 68.22, ["Neon"] = 17.99, ["Neon|Fly"] = 95.82, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 82.67, ["Mega"] = 144.98, ["Mega|Fly"] = 310.64, ["Mega|Ride"] = 131.24, ["Mega|Fly|Ride"] = 189.59}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 3.82, ["Fly"] = 19.59, ["Ride"] = 18.21, ["Fly|Ride"] = 100.02, ["Neon"] = 13.18, ["Neon|Fly"] = 48, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 140.44, ["Mega"] = 103.29, ["Mega|Fly"] = 220.5, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 98.39}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 14.42, ["Fly"] = 282.98, ["Ride"] = 24.61, ["Neon"] = 39.38, ["Neon|Ride"] = 59.04, ["Neon|Fly|Ride"] = 267.75, ["Mega"] = 210, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 344.98, ["Mega|Fly|Ride"] = 485.63}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 5.24, ["Fly"] = 160.7, ["Ride"] = 66, ["Neon"] = 122.38, ["Neon|Ride"] = 91.77, ["Mega"] = 328.13, ["Mega|Ride"] = 424.46, ["Mega|Fly|Ride"] = 1063.78}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 5.76, ["Fly"] = 35.44, ["Ride"] = 15.98, ["Fly|Ride"] = 52.5, ["Neon"] = 19.21, ["Neon|Fly"] = 196.65, ["Neon|Ride"] = 60.38, ["Neon|Fly|Ride"] = 109.4, ["Mega"] = 191.96, ["Mega|Ride"] = 281.27}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 20.98, ["Ride"] = 18.35, ["Fly|Ride"] = 39.38, ["Neon"] = 14.95, ["Neon|Fly"] = 24.49, ["Neon|Ride"] = 26.4, ["Neon|Fly|Ride"] = 61.69, ["Mega"] = 425.52, ["Mega|Ride"] = 238.73, ["Mega|Fly|Ride"] = 223.69}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 212.77, ["Fly"] = 393.75, ["Ride"] = 236.25, ["Fly|Ride"] = 371.9, ["Neon"] = 987.19, ["Neon|Ride"] = 1043.44, ["Neon|Fly|Ride"] = 1179.94, ["Mega|Ride"] = 3547.68, ["Mega|Fly|Ride"] = 3511.14}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 6.18, ["Ride"] = 38.72, ["Neon"] = 26.25, ["Neon|Fly|Ride"] = 284.04, ["Mega"] = 123.38, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 3.93, ["Ride"] = 30.86, ["Fly|Ride"] = 118.13, ["Neon"] = 21.29, ["Neon|Fly"] = 144.38, ["Neon|Ride"] = 36.45, ["Neon|Fly|Ride"] = 139.65, ["Mega"] = 196.88, ["Mega|Ride"] = 280.85, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 3.94, ["Neon"] = 42.56, ["Neon|Ride"] = 213.45, ["Neon|Fly|Ride"] = 638.27, ["Mega"] = 476.55, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 427.23}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 13.13, ["Fly|Ride"] = 26.17, ["Neon"] = 2.1, ["Neon|Fly"] = 21.29, ["Neon|Ride"] = 17.04, ["Neon|Fly|Ride"] = 39.26, ["Mega"] = 22.32, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 60.65, ["Mega|Fly|Ride"] = 64.79}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 5.94, ["Fly"] = 56.37, ["Ride"] = 26.25, ["Fly|Ride"] = 56.44, ["Neon"] = 24.94, ["Neon|Ride"] = 24, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 126.93, ["Mega|Ride"] = 119.98, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 4.19, ["Ride"] = 57.46, ["Fly|Ride"] = 77.43, ["Neon"] = 10.5, ["Neon|Ride"] = 28.73, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 55.11, ["Mega|Ride"] = 160.13, ["Mega|Fly|Ride"] = 198.95}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 72.19, ["Fly"] = 133.98, ["Ride"] = 112.44, ["Fly|Ride"] = 143.07, ["Neon"] = 373.4, ["Neon|Ride"] = 425.52, ["Neon|Fly|Ride"] = 351.75, ["Mega|Ride"] = 3547.68, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 7.88, ["Fly"] = 100.02, ["Ride"] = 34.05, ["Fly|Ride"] = 65.63, ["Neon"] = 26.25, ["Neon|Ride"] = 55.2, ["Neon|Fly|Ride"] = 137.96, ["Mega"] = 221.28, ["Mega|Ride"] = 259.86, ["Mega|Fly|Ride"] = 663.8}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 31.92, ["Ride"] = 52.5, ["Fly|Ride"] = 118.13, ["Neon"] = 10.56, ["Neon|Ride"] = 57.46, ["Neon|Fly|Ride"] = 170.22, ["Mega"] = 75.83, ["Mega|Fly"] = 313.69, ["Mega|Ride"] = 104.27, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 65.09, ["Fly"] = 128.37, ["Ride"] = 89.24, ["Fly|Ride"] = 299.25, ["Neon"] = 160.72, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 634.02, ["Mega|Ride"] = 638.27, ["Mega|Fly|Ride"] = 614.25}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 17.04, ["Ride"] = 15.84, ["Fly|Ride"] = 37.25, ["Neon"] = 2.63, ["Neon|Fly"] = 38.06, ["Neon|Ride"] = 18.36, ["Neon|Fly|Ride"] = 41.99, ["Mega"] = 24.94, ["Mega|Fly"] = 43.24, ["Mega|Ride"] = 43.2, ["Mega|Fly|Ride"] = 81.38}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Neon"] = 4.99, ["Neon|Ride"] = 60.38, ["Neon|Fly|Ride"] = 71.09, ["Mega"] = 26.24, ["Mega|Ride"] = 76.65, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 3.63, ["Ride"] = 107.63, ["Neon"] = 9.19, ["Neon|Ride"] = 100.02, ["Neon|Fly|Ride"] = 191.49, ["Mega"] = 70.88, ["Mega|Ride"] = 157.22, ["Mega|Fly|Ride"] = 279.79}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 6.02, ["Fly"] = 142.55, ["Ride"] = 62.46, ["Fly|Ride"] = 123.38, ["Neon"] = 26.24, ["Neon|Fly"] = 136.5, ["Neon|Ride"] = 104.81, ["Neon|Fly|Ride"] = 177.18, ["Mega"] = 115.85, ["Mega|Fly"] = 212.77, ["Mega|Ride"] = 160.76, ["Mega|Fly|Ride"] = 304.96}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 15.64, ["Ride"] = 13.71, ["Fly|Ride"] = 40.8, ["Neon"] = 2.1, ["Neon|Fly"] = 28.81, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 70.8, ["Mega"] = 21.48, ["Mega|Ride"] = 44.7, ["Mega|Fly|Ride"] = 130.86}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 14.44, ["Ride"] = 43.98, ["Fly|Ride"] = 231.92, ["Neon"] = 70.88, ["Neon|Ride"] = 168.09, ["Neon|Fly|Ride"] = 208.04, ["Mega"] = 422.25, ["Mega|Ride"] = 496.8, ["Mega|Fly|Ride"] = 568.07}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2756.25, ["Fly"] = 3150, ["Ride"] = 2779.88, ["Fly|Ride"] = 2748.38, ["Neon|Ride"] = 9929.21, ["Neon|Fly|Ride"] = 9318.75, ["Mega|Fly|Ride"] = 44146.32}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 15.74, ["Fly|Ride"] = 67.99, ["Neon"] = 5.25, ["Neon|Fly"] = 62.29, ["Neon|Ride"] = 30.18, ["Neon|Fly|Ride"] = 66.94, ["Mega"] = 74.82, ["Mega|Fly"] = 142.55, ["Mega|Ride"] = 99.02, ["Mega|Fly|Ride"] = 142.55}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.1, ["Fly|Ride"] = 74.82, ["Neon"] = 13.13, ["Mega"] = 126, ["Mega|Fly"] = 179.82, ["Mega|Ride"] = 437.07, ["Mega|Fly|Ride"] = 638.27}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 15.72, ["Ride"] = 35.44, ["Fly|Ride"] = 148.95, ["Neon"] = 91.69, ["Neon|Ride"] = 247.12, ["Neon|Fly|Ride"] = 216.09, ["Mega"] = 402.12, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 52.49, ["Ride"] = 98.44, ["Neon"] = 187.69, ["Neon|Ride"] = 279.74, ["Neon|Fly|Ride"] = 425.52, ["Mega"] = 540.75, ["Mega|Ride"] = 742.58, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 172.15, ["Fly"] = 270.21, ["Ride"] = 210, ["Fly|Ride"] = 241.48, ["Neon"] = 1312.5, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 774.38, ["Neon|Fly|Ride"] = 764.21, ["Mega"] = 6382.61, ["Mega|Ride"] = 3567.64, ["Mega|Fly|Ride"] = 2493.75}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 9.83, ["Ride"] = 52.5, ["Fly|Ride"] = 675.94, ["Neon"] = 20.23, ["Neon|Fly"] = 71.29, ["Neon|Ride"] = 104.9, ["Neon|Fly|Ride"] = 142.55, ["Mega"] = 224.44, ["Mega|Fly"] = 191.96, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 284.04}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 63.83, ["Neon"] = 15.74, ["Neon|Fly"] = 100.02, ["Neon|Ride"] = 42.56, ["Neon|Fly|Ride"] = 530.84, ["Mega"] = 135.12, ["Mega|Ride"] = 261.03, ["Mega|Fly|Ride"] = 838.31}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Fly"] = 101.97, ["Ride"] = 26.25, ["Fly|Ride"] = 131.25, ["Neon"] = 12.69, ["Neon|Ride"] = 90.57, ["Neon|Fly|Ride"] = 100.02, ["Mega"] = 76.19, ["Mega|Ride"] = 117.21, ["Mega|Fly|Ride"] = 270.21}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 18.38, ["Fly|Ride"] = 656.25, ["Neon|Ride"] = 142.55, ["Neon|Fly|Ride"] = 297.88, ["Mega"] = 374.06, ["Mega|Ride"] = 501.27, ["Mega|Fly|Ride"] = 643.79}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 71.29, ["Neon"] = 2.63, ["Neon|Ride"] = 38.4, ["Mega"] = 19.69, ["Mega|Ride"] = 61.69, ["Mega|Fly|Ride"] = 355.31}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 82.69, ["Ride"] = 91.88, ["Fly|Ride"] = 131.25, ["Neon"] = 355.31, ["Neon|Ride"] = 356.37, ["Neon|Fly|Ride"] = 425.52, ["Mega"] = 1365, ["Mega|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 1443.75}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 6.4, ["Neon|Ride"] = 105.33, ["Mega"] = 48, ["Mega|Ride"] = 141.75}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 45.92, ["Fly"] = 100.02, ["Ride"] = 73.5, ["Fly|Ride"] = 171.51, ["Neon"] = 284.04, ["Neon|Fly"] = 355.31, ["Neon|Ride"] = 211.03, ["Neon|Fly|Ride"] = 527.64, ["Mega"] = 2625, ["Mega|Ride"] = 2837.08, ["Mega|Fly|Ride"] = 1206.33}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 34.06, ["Ride"] = 24.49, ["Fly|Ride"] = 49.88, ["Neon"] = 5.2, ["Neon|Fly"] = 122.35, ["Neon|Ride"] = 42.21, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 42.28, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 107.46}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 3.54, ["Ride"] = 48, ["Neon"] = 11.82, ["Neon|Ride"] = 113.85, ["Mega"] = 80.07, ["Mega|Ride"] = 170.57, ["Mega|Fly|Ride"] = 425.52}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 14.17, ["Fly|Ride"] = 212.77, ["Neon"] = 39.38, ["Mega"] = 217.49, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 952.09}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 406.88, ["Ride"] = 459.38, ["Fly|Ride"] = 538.13, ["Neon"] = 1232.44, ["Neon|Ride"] = 1260, ["Neon|Fly|Ride"] = 1443.75, ["Mega|Ride"] = 4410, ["Mega|Fly|Ride"] = 3906.35}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 34.13, ["Fly"] = 57.46, ["Ride"] = 51.19, ["Fly|Ride"] = 86.36, ["Neon"] = 239.94, ["Neon|Fly"] = 320.3, ["Neon|Ride"] = 208.69, ["Neon|Fly|Ride"] = 262.5, ["Mega|Ride"] = 1062.72, ["Mega|Fly|Ride"] = 984.38}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 27.26, ["Ride"] = 17.04, ["Fly|Ride"] = 91.88, ["Neon"] = 7.09, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 48, ["Neon|Fly|Ride"] = 97.02, ["Mega"] = 55.13, ["Mega|Ride"] = 71.29, ["Mega|Fly|Ride"] = 416.29}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 11.82, ["Fly"] = 72.1, ["Ride"] = 39.37, ["Fly|Ride"] = 122.07, ["Neon"] = 45.94, ["Neon|Fly"] = 198.95, ["Neon|Ride"] = 77.46, ["Neon|Fly|Ride"] = 160.76, ["Mega"] = 229.69, ["Mega|Fly"] = 397.87, ["Mega|Ride"] = 301.06, ["Mega|Fly|Ride"] = 382.69}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 7.87, ["Ride"] = 32.81, ["Fly|Ride"] = 51.19, ["Neon"] = 85.12, ["Neon|Ride"] = 125.54, ["Neon|Fly|Ride"] = 52.5, ["Mega|Ride"] = 479.49, ["Mega|Fly|Ride"] = 411.7}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.93, ["Neon"] = 15.49, ["Mega"] = 52.5, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 3.41, ["Fly"] = 86.63, ["Ride"] = 19.16, ["Fly|Ride"] = 52.8, ["Neon"] = 26.25, ["Neon|Ride"] = 46.57, ["Neon|Fly|Ride"] = 217.02, ["Mega"] = 560.23, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 479.85}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 116.82, ["Fly"] = 128.37, ["Ride"] = 142.55, ["Fly|Ride"] = 191.49, ["Neon|Ride"] = 534.87, ["Neon|Fly|Ride"] = 843.96, ["Mega"] = 2678.59, ["Mega|Ride"] = 2837.08, ["Mega|Fly|Ride"] = 3117.92}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 23.19, ["Fly"] = 95.82, ["Ride"] = 85.1, ["Fly|Ride"] = 159.33, ["Neon"] = 192.94, ["Neon|Ride"] = 197.87, ["Mega"] = 794.66, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 675.12}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2418.94, ["Fly"] = 2349.3, ["Ride"] = 2310, ["Fly|Ride"] = 2323.13, ["Neon"] = 12765.21, ["Neon|Fly|Ride"] = 7743.75, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 2.1, ["Fly"] = 65625, ["Ride"] = 41.89, ["Fly|Ride"] = 170.63, ["Neon"] = 17.07, ["Neon|Ride"] = 95.97, ["Neon|Fly|Ride"] = 169.32, ["Mega"] = 125.64, ["Mega|Ride"] = 168.67, ["Mega|Fly|Ride"] = 425.52}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 19.67, ["Ride"] = 203.95, ["Fly|Ride"] = 156.19, ["Neon"] = 42.56, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 253.32, ["Mega"] = 255.94, ["Mega|Ride"] = 329.67, ["Mega|Fly|Ride"] = 693.58}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 958.13, ["Fly"] = 1148.88, ["Ride"] = 943.69, ["Fly|Ride"] = 997.5, ["Neon"] = 2445.65, ["Neon|Ride"] = 3018.75, ["Neon|Fly|Ride"] = 2296.87, ["Mega|Fly|Ride"] = 12364.34}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 39.37, ["Ride"] = 45.52, ["Fly|Ride"] = 210, ["Neon"] = 272.29, ["Neon|Ride"] = 289.42, ["Mega"] = 656.25, ["Mega|Ride"] = 696.48, ["Mega|Fly|Ride"] = 845.71}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 3.94, ["Ride"] = 23.63, ["Fly|Ride"] = 91.88, ["Neon"] = 15.64, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 105, ["Mega"] = 135.12, ["Mega|Fly|Ride"] = 307.13}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 111.19, ["Ride"] = 23.42, ["Neon"] = 3.87, ["Neon|Ride"] = 52.5, ["Mega"] = 28.88, ["Mega|Ride"] = 70.23, ["Mega|Fly|Ride"] = 202.13}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 118.09, ["Ride"] = 125.99, ["Fly|Ride"] = 320.31, ["Neon"] = 459.38, ["Neon|Fly|Ride"] = 479.85, ["Mega"] = 5250, ["Mega|Fly|Ride"] = 2695.6}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 6.57, ["Neon"] = 27.67, ["Neon|Ride"] = 142.55, ["Mega"] = 149.6, ["Mega|Ride"] = 164.84, ["Mega|Fly|Ride"] = 359.89}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 76, ["Ride"] = 97.62, ["Neon"] = 614.25, ["Neon|Ride"] = 525, ["Mega"] = 1844.58, ["Mega|Fly|Ride"] = 1682.63}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 10.07, ["Fly"] = 105, ["Fly|Ride"] = 91.88, ["Neon"] = 33.15, ["Neon|Fly"] = 42.56, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 143.97, ["Mega|Fly|Ride"] = 284.04}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 261.19, ["Fly"] = 425.52, ["Ride"] = 302.08, ["Fly|Ride"] = 344.31, ["Neon"] = 1120.39, ["Neon|Ride"] = 1017.23, ["Neon|Fly|Ride"] = 812.44, ["Mega|Fly|Ride"] = 4106.15}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 6.02, ["Fly"] = 87.05, ["Ride"] = 26.25, ["Fly|Ride"] = 70, ["Neon"] = 28.49, ["Neon|Ride"] = 63.5, ["Neon|Fly|Ride"] = 104.96, ["Mega"] = 137.82, ["Mega|Ride"] = 394.67}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 18.15, ["Ride"] = 15.75, ["Fly|Ride"] = 26.25, ["Neon"] = 6.4, ["Neon|Fly"] = 19.21, ["Neon|Ride"] = 26.18, ["Neon|Fly|Ride"] = 54.26, ["Mega"] = 59.07, ["Mega|Fly"] = 104.87, ["Mega|Ride"] = 138.28, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 840, ["Fly"] = 1199.63, ["Ride"] = 903, ["Fly|Ride"] = 1058.47, ["Neon|Ride"] = 5038.08, ["Neon|Fly|Ride"] = 4467.83, ["Mega"] = 28790.52, ["Mega|Fly|Ride"] = 28367.48}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 8.52, ["Fly"] = 993.58, ["Ride"] = 57.16, ["Neon"] = 31.91, ["Neon|Ride"] = 69.84, ["Mega"] = 165.53, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 372.1}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 6.56, ["Fly"] = 32.82, ["Ride"] = 51.58, ["Fly|Ride"] = 112.72, ["Neon"] = 26.25, ["Neon|Fly"] = 77.68, ["Neon|Ride"] = 81, ["Neon|Fly|Ride"] = 108.54, ["Mega"] = 195.33, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 38.04, ["Fly"] = 35.44, ["Ride"] = 39.29, ["Fly|Ride"] = 66.94, ["Neon|Ride"] = 211.3, ["Neon|Fly|Ride"] = 192.94, ["Mega"] = 2127.56, ["Mega|Fly|Ride"] = 787.48}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 15.54, ["Fly"] = 79.8, ["Ride"] = 30.19, ["Fly|Ride"] = 78.75, ["Neon"] = 60.64, ["Neon|Ride"] = 104.39, ["Neon|Fly|Ride"] = 207.42, ["Mega"] = 288.75, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 448.88}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 27.57, ["Ride"] = 210, ["Fly|Ride"] = 343.62, ["Neon"] = 86.63, ["Neon|Ride"] = 183.1, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 486.18, ["Mega|Ride"] = 518.07, ["Mega|Fly|Ride"] = 610.62}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 116.59, ["Fly|Ride"] = 238.6, ["Neon"] = 2.63, ["Neon|Ride"] = 28.13, ["Mega"] = 20.98, ["Mega|Fly"] = 86.38, ["Mega|Ride"] = 59.59}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 26.25, ["Fly"] = 61.69, ["Ride"] = 46.73, ["Fly|Ride"] = 70.7, ["Neon"] = 297.88, ["Neon|Fly"] = 309.58, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 259.88, ["Mega"] = 3404.07, ["Mega|Fly|Ride"] = 1122.61}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 3.93, ["Fly"] = 91.19, ["Ride"] = 19.66, ["Fly|Ride"] = 70.87, ["Neon"] = 42.35, ["Neon|Ride"] = 142.54, ["Mega"] = 773.07, ["Mega|Ride"] = 239.94, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 26.14, ["Ride"] = 20.34, ["Fly|Ride"] = 36.75, ["Neon"] = 21.18, ["Neon|Ride"] = 50.02, ["Neon|Fly|Ride"] = 131.24, ["Mega|Ride"] = 284.04, ["Mega|Fly|Ride"] = 203.44}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 5.25, ["Ride"] = 103.69, ["Neon"] = 105, ["Neon|Ride"] = 851.03, ["Neon|Fly|Ride"] = 127.66, ["Mega"] = 297.88}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 21.62, ["Fly"] = 262.36, ["Ride"] = 91.88, ["Fly|Ride"] = 262.5, ["Neon"] = 106.39, ["Neon|Fly"] = 313.83, ["Neon|Ride"] = 211.32, ["Neon|Fly|Ride"] = 236.17, ["Mega"] = 656.25, ["Mega|Ride"] = 485.63, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 5.07, ["Ride"] = 98.44, ["Neon"] = 23.63, ["Neon|Ride"] = 74.48, ["Neon|Fly|Ride"] = 129.8, ["Mega"] = 81.74, ["Mega|Ride"] = 70.88, ["Mega|Fly|Ride"] = 320.31}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 2.57, ["Neon|Ride"] = 28.73, ["Mega"] = 19.69, ["Mega|Ride"] = 52.37, ["Mega|Fly|Ride"] = 204.75}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Ride"] = 19.16, ["Neon"] = 3.93, ["Neon|Fly"] = 393.59, ["Neon|Ride"] = 21.11, ["Mega"] = 18.38, ["Mega|Fly"] = 73.86, ["Mega|Ride"] = 47.25, ["Mega|Fly|Ride"] = 106.32}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 25.89, ["Ride"] = 24.04, ["Fly|Ride"] = 45.94, ["Neon"] = 12.01, ["Neon|Fly"] = 57.46, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 71.29, ["Mega"] = 83.89, ["Mega|Ride"] = 158.82, ["Mega|Fly|Ride"] = 148.32}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 28.67, ["Fly|Ride"] = 5369.02, ["Neon"] = 15.74, ["Neon|Ride"] = 1312.5, ["Mega"] = 105, ["Mega|Ride"] = 148.79, ["Mega|Fly|Ride"] = 170.22}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 17.07, ["Fly|Ride"] = 42.56, ["Neon"] = 16.89, ["Neon|Fly"] = 53.2, ["Neon|Ride"] = 31.34, ["Neon|Fly|Ride"] = 77.17, ["Mega"] = 287.93, ["Mega|Ride"] = 276.29, ["Mega|Fly|Ride"] = 367.49}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 77.44, ["Ride"] = 207.44, ["Fly|Ride"] = 397.87, ["Neon"] = 164.07, ["Neon|Ride"] = 298.91, ["Neon|Fly|Ride"] = 1063.78, ["Mega"] = 787.5, ["Mega|Ride"] = 845.4, ["Mega|Fly|Ride"] = 1262.7}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 26.19, ["Ride"] = 21.29, ["Fly|Ride"] = 39.38, ["Neon"] = 3.82, ["Neon|Fly"] = 28.5, ["Neon|Ride"] = 13.13, ["Neon|Fly|Ride"] = 40.78, ["Mega"] = 64.32, ["Mega|Ride"] = 59.08, ["Mega|Fly|Ride"] = 110.97}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 8.52, ["Fly"] = 62.91, ["Ride"] = 45.94, ["Fly|Ride"] = 92.46, ["Neon"] = 57.18, ["Neon|Fly"] = 76.6, ["Neon|Ride"] = 48, ["Neon|Fly|Ride"] = 114.65, ["Mega"] = 851.03, ["Mega|Ride"] = 257.86, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 19.05, ["Fly"] = 39.38, ["Ride"] = 21, ["Fly|Ride"] = 78.7, ["Neon"] = 76.59, ["Neon|Fly"] = 113.85, ["Neon|Ride"] = 82.69, ["Neon|Fly|Ride"] = 176.8, ["Mega"] = 1063.78, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 317.63}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 2.1, ["Fly"] = 140.44, ["Ride"] = 48, ["Neon"] = 15.65, ["Neon|Ride"] = 71.29, ["Mega"] = 279.57, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 381.91}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 17.71, ["Ride"] = 17.22, ["Fly|Ride"] = 30.19, ["Neon"] = 3.82, ["Neon|Fly"] = 41.5, ["Neon|Ride"] = 22.88, ["Neon|Fly|Ride"] = 64.32, ["Mega"] = 51.19, ["Mega|Fly"] = 105, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 130.55}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 3.75, ["Fly"] = 78.07, ["Ride"] = 28.73, ["Fly|Ride"] = 141.39, ["Neon"] = 15.75, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 62.77, ["Neon|Fly|Ride"] = 212.77, ["Mega"] = 126, ["Mega|Fly"] = 735, ["Mega|Ride"] = 196.77, ["Mega|Fly|Ride"] = 421.28}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 969.94, ["Ride"] = 968.63, ["Fly|Ride"] = 1060.49, ["Neon"] = 2625, ["Neon|Fly"] = 2908.36, ["Neon|Ride"] = 2763.68, ["Neon|Fly|Ride"] = 2278.5, ["Mega|Fly|Ride"] = 7609.88}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 65.63, ["Ride"] = 94.5, ["Neon"] = 260.33, ["Neon|Ride"] = 316.32, ["Neon|Fly|Ride"] = 421.28, ["Mega"] = 1488.23, ["Mega|Ride"] = 1479.72, ["Mega|Fly|Ride"] = 1320.96}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Ride"] = 68.39, ["Neon"] = 7.88, ["Neon|Ride"] = 71.29, ["Neon|Fly|Ride"] = 100.02, ["Mega"] = 70.23}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 35.43, ["Ride"] = 63.03, ["Fly|Ride"] = 169.16, ["Neon"] = 167.14, ["Neon|Ride"] = 190.21, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 1023.75, ["Mega|Ride"] = 1515.94, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 7.88, ["Ride"] = 119.98, ["Fly|Ride"] = 156.19, ["Neon"] = 39.8, ["Neon|Ride"] = 72.35, ["Neon|Fly|Ride"] = 282.98, ["Mega"] = 477.65, ["Mega|Ride"] = 315.52, ["Mega|Fly|Ride"] = 1063.78}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 236.25, ["Fly"] = 425.52, ["Ride"] = 288.75, ["Fly|Ride"] = 315, ["Neon|Ride"] = 1122.29, ["Neon|Fly|Ride"] = 1115.63, ["Mega|Fly|Ride"] = 4231.68}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 102.37, ["Ride"] = 22.32, ["Fly|Ride"] = 129.93, ["Neon"] = 15.75, ["Neon|Ride"] = 53.9, ["Mega"] = 407.44, ["Mega|Fly"] = 284.04}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Neon"] = 104.9}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 58.7, ["Ride"] = 142.55, ["Fly|Ride"] = 279.7, ["Neon"] = 319.14, ["Neon|Ride"] = 329.78, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 393.75, ["Mega|Ride"] = 715.98, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 48.54, ["Neon"] = 13.86, ["Mega"] = 227.66, ["Mega|Ride"] = 297.88, ["Mega|Fly|Ride"] = 212.77}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 16.89, ["Ride"] = 15.74, ["Fly|Ride"] = 32.82, ["Neon"] = 3.93, ["Neon|Fly"] = 32.29, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 28.88, ["Mega"] = 26.25, ["Mega|Fly"] = 71.29, ["Mega|Ride"] = 41.5, ["Mega|Fly|Ride"] = 99.58}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4200, ["Ride"] = 4331.25, ["Fly|Ride"] = 4200, ["Neon"] = 26523.97, ["Neon|Fly|Ride"] = 21359.63, ["Mega|Fly|Ride"] = 63818.95}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 13.13, ["Ride"] = 48.95, ["Neon"] = 85.12, ["Mega"] = 319.14, ["Mega|Ride"] = 284.04, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.63, ["Fly"] = 19.69, ["Ride"] = 21, ["Fly|Ride"] = 57.74, ["Neon"] = 12.86, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 24.01, ["Neon|Fly|Ride"] = 69.57, ["Mega"] = 229.53, ["Mega|Ride"] = 143.97, ["Mega|Fly|Ride"] = 208.69}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 403.05, ["Fly"] = 518.07, ["Ride"] = 472.17, ["Fly|Ride"] = 525, ["Neon"] = 1312.5, ["Neon|Ride"] = 1358.44, ["Neon|Fly|Ride"] = 1233.7, ["Mega|Fly|Ride"] = 4964.61}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 3.93, ["Ride"] = 28.73, ["Neon"] = 15.73, ["Neon|Ride"] = 145.68, ["Mega"] = 124.59, ["Mega|Fly|Ride"] = 690.38}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 3.93, ["Fly"] = 201.81, ["Ride"] = 956.33, ["Neon"] = 124.69, ["Neon|Ride"] = 142.55, ["Neon|Fly|Ride"] = 14184.29, ["Mega"] = 415.42, ["Mega|Ride"] = 401.63}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Ride"] = 17.64, ["Fly|Ride"] = 82.55, ["Neon"] = 7.87, ["Neon|Fly"] = 124.68, ["Neon|Ride"] = 34.06, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 48.6, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 156.19}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 637.88, ["Ride"] = 639.19, ["Fly|Ride"] = 709.55, ["Neon"] = 2100, ["Neon|Fly|Ride"] = 1967.34, ["Mega|Fly|Ride"] = 9187.5}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 4.09, ["Ride"] = 84.05, ["Fly|Ride"] = 98.73, ["Neon"] = 23.63, ["Neon|Ride"] = 93.58, ["Neon|Fly|Ride"] = 211.71, ["Mega"] = 144.38, ["Mega|Ride"] = 282.98, ["Mega|Fly|Ride"] = 325.61}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 6.35, ["Fly"] = 235.94, ["Ride"] = 42, ["Neon"] = 51.98, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 242.82, ["Mega|Ride"] = 238.26, ["Mega|Fly|Ride"] = 423.4}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 3.94, ["Fly"] = 28.72, ["Ride"] = 17.95, ["Fly|Ride"] = 71.29, ["Neon"] = 15.7, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 170.63, ["Mega|Fly"] = 284.04, ["Mega|Ride"] = 158.82, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["Ride"] = 42.56, ["Neon"] = 91.87, ["Neon|Fly"] = 170.63, ["Neon|Fly|Ride"] = 320.31, ["Mega"] = 479.85, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 530.84}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Ride"] = 39.37, ["Neon"] = 6.28, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 54.54, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 26.25, ["Mega|Ride"] = 87.93, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 420, ["Ride"] = 471.18, ["Fly|Ride"] = 510.63, ["Neon"] = 1837.5, ["Neon|Ride"] = 2411.57, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Ride"] = 9356.92, ["Mega|Fly|Ride"] = 7848.75}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 51.19, ["Neon"] = 6.57, ["Neon|Ride"] = 80.38, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 44.63, ["Mega|Ride"] = 138.3, ["Mega|Fly|Ride"] = 331.57}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 52.48, ["Neon"] = 4.25, ["Neon|Fly"] = 71.29, ["Neon|Ride"] = 215.94, ["Neon|Fly|Ride"] = 111.46, ["Mega"] = 34.06, ["Mega|Fly"] = 93.62, ["Mega|Ride"] = 85.12, ["Mega|Fly|Ride"] = 211.71}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 60.37, ["Neon"] = 4.04, ["Neon|Ride"] = 45.91, ["Neon|Fly|Ride"] = 142.55, ["Mega"] = 44.46, ["Mega|Fly"] = 157.45, ["Mega|Ride"] = 92.56}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Neon"] = 25.55, ["Neon|Ride"] = 71.29, ["Mega"] = 232.99, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 62.88, ["Ride"] = 110.25, ["Fly|Ride"] = 232.32, ["Neon"] = 235.6, ["Neon|Ride"] = 212.77, ["Neon|Fly|Ride"] = 416.73, ["Mega"] = 813.75, ["Mega|Ride"] = 851.03, ["Mega|Fly|Ride"] = 709.55}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 31.2, ["Fly"] = 69.57, ["Ride"] = 64.31, ["Fly|Ride"] = 112.11, ["Neon"] = 102.38, ["Neon|Ride"] = 157.45, ["Neon|Fly|Ride"] = 284.04, ["Mega"] = 463.3, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 524.98}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly"] = 40.69, ["Ride"] = 18, ["Fly|Ride"] = 41.99, ["Neon"] = 30.38, ["Neon|Fly"] = 71.29, ["Neon|Ride"] = 35.02, ["Neon|Fly|Ride"] = 77.43, ["Mega"] = 394.42, ["Mega|Ride"] = 239.36, ["Mega|Fly|Ride"] = 255.32}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 7.88, ["Ride"] = 64.32, ["Fly|Ride"] = 115.18, ["Neon"] = 142.55, ["Neon|Ride"] = 158.82, ["Mega"] = 336.16, ["Mega|Ride"] = 800.15, ["Mega|Fly|Ride"] = 993.58}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 3.93, ["Fly"] = 262.5, ["Ride"] = 28.73, ["Fly|Ride"] = 210, ["Neon"] = 27.57, ["Neon|Ride"] = 57.46, ["Mega"] = 181.05, ["Mega|Ride"] = 197.87, ["Mega|Fly|Ride"] = 505.3}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 22.31, ["Fly"] = 70.8, ["Ride"] = 30.17, ["Fly|Ride"] = 52.5, ["Neon"] = 228.74, ["Neon|Ride"] = 212.77, ["Neon|Fly|Ride"] = 244.79, ["Mega"] = 956.33, ["Mega|Ride"] = 959.69, ["Mega|Fly|Ride"] = 706.36}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 52.5, ["Fly"] = 874.13, ["Ride"] = 85.12, ["Neon"] = 142.55, ["Neon|Ride"] = 479.83, ["Mega|Ride"] = 590.63}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 49.88, ["Fly"] = 115.5, ["Ride"] = 81.38, ["Fly|Ride"] = 139.13, ["Neon"] = 296.8, ["Neon|Fly"] = 326.59, ["Neon|Ride"] = 276.92, ["Neon|Fly|Ride"] = 363.83, ["Mega"] = 1170.17, ["Mega|Ride"] = 1360.36, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 50.02, ["Fly"] = 92.79, ["Ride"] = 79.72, ["Neon"] = 137.82, ["Neon|Ride"] = 187.24, ["Neon|Fly|Ride"] = 408.19, ["Mega"] = 542.07, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 568.07}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 26.08, ["Ride"] = 65.63, ["Neon"] = 118.13, ["Mega"] = 422.63, ["Mega|Ride"] = 780.82, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 4.81, ["Fly"] = 29.95, ["Ride"] = 32.22, ["Fly|Ride"] = 90.79, ["Neon"] = 45.94, ["Neon|Fly"] = 170.22, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 116.28, ["Mega"] = 349.49, ["Mega|Ride"] = 425.52, ["Mega|Fly|Ride"] = 413.68}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 21.29, ["Ride"] = 15.85, ["Fly|Ride"] = 42.56, ["Neon"] = 4.99, ["Neon|Fly"] = 24.89, ["Neon|Ride"] = 21.29, ["Neon|Fly|Ride"] = 62.99, ["Mega"] = 49.88, ["Mega|Fly"] = 212.77, ["Mega|Ride"] = 62.99, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1458.18}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 27.75, ["Ride"] = 57.6, ["Fly|Ride"] = 131.25, ["Neon"] = 142.55, ["Neon|Ride"] = 157.97, ["Neon|Fly|Ride"] = 319.12, ["Mega"] = 487.23, ["Mega|Ride"] = 527.63, ["Mega|Fly|Ride"] = 522.38}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 56.88, ["Neon"] = 3.82, ["Neon|Ride"] = 57.46, ["Neon|Fly|Ride"] = 297.88, ["Mega"] = 37.89, ["Mega|Ride"] = 140.32, ["Mega|Fly|Ride"] = 550.62}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 24.29, ["Fly"] = 112.77, ["Ride"] = 47.22, ["Neon"] = 168.66, ["Neon|Fly"] = 328.13, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 708.75, ["Mega|Ride"] = 952.09, ["Mega|Fly|Ride"] = 1019.82}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 4.56, ["Neon|Ride"] = 105, ["Mega"] = 32.82, ["Mega|Fly|Ride"] = 709.55}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 5.38, ["Neon|Ride"] = 160.75, ["Mega"] = 25.55, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 118.13, ["Ride"] = 178.74, ["Neon"] = 426.57, ["Neon|Fly"] = 599.79, ["Neon|Ride"] = 420, ["Neon|Fly|Ride"] = 522.43, ["Mega|Ride"] = 6597.84, ["Mega|Fly|Ride"] = 2227.23}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 3.87, ["Fly"] = 26.11, ["Ride"] = 21.29, ["Fly|Ride"] = 71.46, ["Neon"] = 14.44, ["Neon|Fly"] = 63.83, ["Neon|Ride"] = 35.43, ["Neon|Fly|Ride"] = 157.45, ["Mega"] = 91.88, ["Mega|Ride"] = 139.37, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 36.16, ["Ride"] = 131.24, ["Fly|Ride"] = 86.63, ["Neon"] = 3.84, ["Neon|Fly"] = 63.83, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 42.67, ["Mega|Ride"] = 104.27, ["Mega|Fly|Ride"] = 116.82}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 3.15, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 35.35, ["Mega"] = 30.51, ["Mega|Ride"] = 222.07, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 19.16, ["Neon"] = 9.6, ["Neon|Ride"] = 29.3, ["Mega"] = 38.66, ["Mega|Ride"] = 95.7, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 39.37, ["Ride"] = 91.88, ["Fly|Ride"] = 449.61, ["Neon"] = 348.91, ["Neon|Ride"] = 407.69, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1560.56, ["Mega|Ride"] = 1560.56, ["Mega|Fly|Ride"] = 1280}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 3.83, ["Ride"] = 36.53, ["Neon"] = 28.43, ["Neon|Ride"] = 262.5, ["Mega"] = 113.85, ["Mega|Ride"] = 830.17}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 383.02, ["Ride"] = 388.37, ["Fly|Ride"] = 448.67, ["Neon"] = 1419.08, ["Neon|Ride"] = 1276.53, ["Neon|Fly|Ride"] = 1276.53, ["Mega|Ride"] = 3829.58, ["Mega|Fly|Ride"] = 3446.13}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 72.19}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 41.88}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 17.05}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 13.11}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 31.37}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 41.99}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 6.51}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 5.16}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 240.19}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 19.67}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 45.91}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 8.93}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 9.08}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 918.73}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 5.13}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 4.9}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 6.04}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 5.72}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 23.62}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 466.54}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 652.61}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 7.86}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1437.19}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 65.63}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 6.28}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 11.16}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 15.74}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 78.72}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 43.32}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 15.74}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 10.5}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 15.74}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 3.93}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 17.05}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 3.05}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 32.79}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 15.75}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 6.48}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 1640.63}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 57.46}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 308.23}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 10.74}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 6.57}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 9.61}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 157.49}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 9.83}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 14.07}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 1008.11}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 19.58}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 3.92}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 19.68}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 4.99}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 131.24}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 16.16}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 9.19}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 13.64}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 11.27}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 6.29}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 32.49}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 114.39}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 141.75}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 6.55}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 16.4}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 30.18}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 72.19}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 91.86}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22791.83}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 177.19}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 26.24}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 65.62}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 25.99}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 52.48}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 62.91}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 45.94}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 183.75}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 111.37}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 26.24}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 43.08}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 41.77}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 44.88}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 249.37}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 354.37}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 9.19}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 7.85}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 6.35}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 26.25}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 48.51}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.1}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 3.13}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.63}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 7.88}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 6.57}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 1071}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 5.92}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 631.92}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 18.19}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.1}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 423.53}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 40.66}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 88.78}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 27.15}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 36.75}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 211.32}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 15.27}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 4.6}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 14.99}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.1}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 3.92}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 3.94}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 34.13}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 3.93}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 3.89}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 4.27}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 16.85}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 157.5}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 59.06}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.1}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 1021.22}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 10.65}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 7.61}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 7.46}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 10.48}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 85.31}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 10.5}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 6.57}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 7.87}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 12.89}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 91.88}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 34.12}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 7.87}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 20.22}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 3.93}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 6.55}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 14.36}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 2.47}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 3.94}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 6.23}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 4.25}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 5670}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 13.09}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 3.36}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 7.86}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 4.59}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 3.93}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 20.34}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 7.22}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 3.91}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 15.53}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 105}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 32.18}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 3.92}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 4.61}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 3.84}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 3.6}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4462.01}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 4.64}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 45.72}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 2.1}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 81.36}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 6.57}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 284.04}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 2.23}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 3.3}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.1}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 4.24}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 9.52}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 26.24}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.6}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.67}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 13.13}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 6.43}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 5.59}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 5.24}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 5.2}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 21}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.63}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 152.08}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.47}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 7.88}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 76.94}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.29}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 89.25}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 13.11}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 984.38}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 15.94}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 5.24}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 3.93}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 27.5}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 7.6}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 11.82}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 26.25}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 15.69}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 18.38}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 6.57}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 3.66}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 6.4}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 17.07}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 8.65}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.63}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 47.24}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 3.45}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 3.91}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 142.55}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 9.19}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 45.3}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.63}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 11.47}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 4.81}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 2.1}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 49.87}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 25.74}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 3.93}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 104.93}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.63}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 11.81}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 18}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.15}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 5.25}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 5.8}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 23.62}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 86.62}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 56.16}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 123.37}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 4.27}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 4255.09}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 4.8}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 154.88}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 2.63}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 10.5}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 38.06}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.63}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 3.93}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 7.85}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 124.68}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 8.76}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 2.63}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 6.39}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 6.4}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 10.5}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 2.63}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 55.13}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 6.4}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 57.75}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.63}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 2.63}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 3.63}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 3.93}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 26.54}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 95.82}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 3.93}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 75.86}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 4.76}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 8.52}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 68.22}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 56.42}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 111.57}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 341.24}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 91.88}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 393.75}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.71}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 14.6}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 56.43}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 3.92}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 36.75}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 3.15}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 7.66}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 7.86}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 43.31}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 12.5}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 7.25}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 6.57}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 23.62}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 45.89}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 3.82}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 3.24}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 32.13}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 3.94}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 7.66}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 51.19}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 32.81}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 28.72}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1650.78}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 9.19}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 6.57}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 65.36}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.37}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 271.64}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 13.33}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 7.88}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 7.88}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 9.03}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 4.11}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 182.44}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 45.94}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 39.35}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 11.38}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 73.44}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 105}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 109.58}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 1653.02}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 172.08}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 7.88}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 1135.05}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 380.63}},
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