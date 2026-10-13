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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 1139.2, ["Ride"] = 1050, ["Fly|Ride"] = 1490.66, ["Neon"] = 6756.59, ["Neon|Fly|Ride"] = 12603.94, ["Mega"] = 21350.78, ["Mega|Fly|Ride"] = 21350.78}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 433.13, ["Fly"] = 525, ["Ride"] = 393.75, ["Fly|Ride"] = 623.16, ["Neon|Fly|Ride"] = 1706.25, ["Mega"] = 10675.4, ["Mega|Fly|Ride"] = 7540.03}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 6038.39, ["Ride"] = 5250, ["Fly|Ride"] = 4934.99, ["Neon|Fly|Ride"] = 17850, ["Mega|Fly|Ride"] = 71169.61}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 156.85, ["Ride"] = 283.5, ["Fly|Ride"] = 306.47, ["Neon"] = 1054.99, ["Neon|Ride"] = 1054.75, ["Neon|Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 4725}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 517.46, ["Fly"] = 651.54, ["Ride"] = 564.38, ["Fly|Ride"] = 577.5, ["Neon|Fly|Ride"] = 1822.9, ["Mega|Fly|Ride"] = 8525.83}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 10.17, ["Ride"] = 57.69, ["Fly|Ride"] = 129.94, ["Neon"] = 71.47, ["Neon|Fly"] = 285.09, ["Neon|Ride"] = 89.25, ["Neon|Fly|Ride"] = 320.28, ["Mega"] = 350.21, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 541.26}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 4.81, ["Fly"] = 43.22, ["Ride"] = 26.24, ["Fly|Ride"] = 83.91, ["Neon"] = 44.12, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 60.37, ["Neon|Fly|Ride"] = 132.78, ["Mega"] = 196.87, ["Mega|Ride"] = 261.19, ["Mega|Fly|Ride"] = 384.62}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 120.67, ["Ride"] = 157.5, ["Fly|Ride"] = 241.34, ["Neon"] = 568.08, ["Neon|Ride"] = 492.19, ["Neon|Fly|Ride"] = 683.24, ["Mega"] = 1586.82, ["Mega|Ride"] = 2492.44, ["Mega|Fly|Ride"] = 2842.88}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 37.7, ["Fly"] = 64.08, ["Ride"] = 45.41, ["Fly|Ride"] = 110.15, ["Neon"] = 275.63, ["Neon|Ride"] = 183.73, ["Neon|Fly|Ride"] = 285.05, ["Mega"] = 2100, ["Mega|Ride"] = 1203.13, ["Mega|Fly|Ride"] = 967.29}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 19.46, ["Fly"] = 37.4, ["Ride"] = 32.03, ["Fly|Ride"] = 71.3, ["Neon|Ride"] = 136.5, ["Neon|Fly|Ride"] = 203.44, ["Mega|Ride"] = 570.05, ["Mega|Fly|Ride"] = 854.05}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 62.99, ["Fly"] = 128.15, ["Ride"] = 100.38, ["Fly|Ride"] = 175.88, ["Neon"] = 406.88, ["Neon|Ride"] = 320.25, ["Neon|Fly|Ride"] = 427.03, ["Mega|Fly|Ride"] = 1267.19}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 57.75}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 347.4, ["Fly"] = 315, ["Ride"] = 334.43, ["Fly|Ride"] = 315, ["Neon|Ride"] = 1048.69, ["Neon|Fly|Ride"] = 1181.24, ["Mega|Fly|Ride"] = 5064.42}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 124.69, ["Fly"] = 128.13, ["Ride"] = 144.2, ["Fly|Ride"] = 177.09, ["Neon|Fly"] = 627.63, ["Neon|Ride"] = 573.03, ["Neon|Fly|Ride"] = 536.82, ["Mega"] = 4312.63, ["Mega|Fly|Ride"] = 2467.5}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 3.83, ["Ride"] = 57.68, ["Fly|Ride"] = 131.25, ["Neon"] = 23.93, ["Neon|Ride"] = 56.35, ["Neon|Fly|Ride"] = 242.82, ["Mega"] = 157.5, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 342.01}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 209.99, ["Fly"] = 285.08, ["Ride"] = 229.69, ["Fly|Ride"] = 249.37, ["Neon|Ride"] = 960.91, ["Neon|Fly|Ride"] = 701.56, ["Mega|Fly|Ride"] = 2749.69}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.56, ["Fly"] = 26.65, ["Ride"] = 17.8, ["Fly|Ride"] = 52.48, ["Neon"] = 28.86, ["Neon|Fly"] = 80.89, ["Neon|Ride"] = 57.7, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 322.13, ["Mega|Fly|Ride"] = 422.63}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 102.37, ["Fly"] = 284.72, ["Ride"] = 127.33, ["Fly|Ride"] = 286.79, ["Neon"] = 341.25, ["Neon|Ride"] = 291.38, ["Neon|Fly|Ride"] = 523.69, ["Mega"] = 1708.08, ["Mega|Ride"] = 1441.19, ["Mega|Fly|Ride"] = 1476.57}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 38.07}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 78.74, ["Ride"] = 170.86, ["Fly|Ride"] = 244.02, ["Neon"] = 577.5, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 2135.09, ["Mega|Fly|Ride"] = 4506.02}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 24.02, ["Fly"] = 55.54, ["Ride"] = 50.67, ["Fly|Ride"] = 384.42, ["Neon"] = 241.34, ["Neon|Ride"] = 209.99, ["Neon|Fly|Ride"] = 326.69, ["Mega"] = 425.97, ["Mega|Ride"] = 988.56, ["Mega|Fly|Ride"] = 965.07}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 39.2, ["Fly"] = 78.75, ["Ride"] = 42.56, ["Fly|Ride"] = 105, ["Neon"] = 322.16, ["Neon|Ride"] = 202.78, ["Neon|Fly|Ride"] = 210, ["Mega"] = 1689.01, ["Mega|Ride"] = 1424.11, ["Mega|Fly|Ride"] = 957.86}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 41.91, ["Fly"] = 244.63, ["Ride"] = 80.85, ["Fly|Ride"] = 196.88, ["Neon"] = 185.79, ["Neon|Ride"] = 392.39, ["Neon|Fly|Ride"] = 519.75, ["Mega"] = 1967.44, ["Mega|Ride"] = 1334.44, ["Mega|Fly|Ride"] = 1535.14}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 19.31, ["Ride"] = 35.18, ["Fly|Ride"] = 100.33, ["Neon"] = 209.9, ["Neon|Ride"] = 213.52, ["Neon|Fly|Ride"] = 173.25, ["Mega"] = 1207.92, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 40.4, ["Fly"] = 57.68, ["Ride"] = 80.76, ["Fly|Ride"] = 129.94, ["Neon"] = 161.76, ["Neon|Fly"] = 403.14, ["Neon|Ride"] = 272.66, ["Neon|Fly|Ride"] = 322.88, ["Mega|Ride"] = 3202.63, ["Mega|Fly|Ride"] = 1018.81}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 5.25, ["Fly"] = 44.87, ["Ride"] = 21.37, ["Fly|Ride"] = 49.88, ["Neon"] = 39.29, ["Neon|Fly"] = 97.43, ["Neon|Ride"] = 49.87, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 177.74, ["Mega|Fly"] = 274.32, ["Mega|Ride"] = 182.44, ["Mega|Fly|Ride"] = 345.07}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 399, ["Ride"] = 513.99, ["Fly|Ride"] = 328.13, ["Neon"] = 2093.96, ["Neon|Ride"] = 1689.18, ["Neon|Fly|Ride"] = 1966.13, ["Mega"] = 10675.4, ["Mega|Fly|Ride"] = 9571.79}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 15.49, ["Ride"] = 32.81, ["Fly|Ride"] = 65.63, ["Neon"] = 219.18, ["Mega|Ride"] = 804.95, ["Mega|Fly|Ride"] = 671.66}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 5.94, ["Fly"] = 57.68, ["Ride"] = 20.6, ["Fly|Ride"] = 56.99, ["Neon"] = 58.47, ["Neon|Ride"] = 70.97, ["Neon|Fly|Ride"] = 130.93, ["Mega|Ride"] = 327.93, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 78.66, ["Fly"] = 118.54, ["Ride"] = 90.57, ["Fly|Ride"] = 128.13, ["Neon"] = 323.65, ["Neon|Fly"] = 408.93, ["Neon|Ride"] = 354.26, ["Neon|Fly|Ride"] = 395.01, ["Mega"] = 6392.87, ["Mega|Ride"] = 2437, ["Mega|Fly|Ride"] = 2100}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 11.81, ["Ride"] = 36.09, ["Fly|Ride"] = 76.02, ["Neon"] = 137.82, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 201.21, ["Mega"] = 712.06, ["Mega|Ride"] = 563.41, ["Mega|Fly|Ride"] = 720.61}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 209.3, ["Fly"] = 262.5, ["Ride"] = 226.07, ["Fly|Ride"] = 292.69, ["Neon"] = 570.22, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 712.06, ["Mega"] = 3415.08, ["Mega|Ride"] = 2763.52, ["Mega|Fly|Ride"] = 2946.42}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 19.59}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.55, ["Fly"] = 36.32, ["Ride"] = 28.75, ["Fly|Ride"] = 72.19, ["Neon"] = 21.37, ["Neon|Fly"] = 143.09, ["Neon|Ride"] = 50.19, ["Neon|Fly|Ride"] = 134.52, ["Mega"] = 183.75, ["Mega|Fly"] = 341.62, ["Mega|Ride"] = 266.9, ["Mega|Fly|Ride"] = 288.74}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 854.25, ["Fly"] = 2625, ["Ride"] = 853.13, ["Fly|Ride"] = 942.38, ["Neon"] = 6392.9, ["Neon|Ride"] = 4840.82, ["Neon|Fly|Ride"] = 4269.11, ["Mega|Ride"] = 54289.15, ["Mega|Fly|Ride"] = 17080.63}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 14.37, ["Fly"] = 56.6, ["Ride"] = 51.82, ["Fly|Ride"] = 91.88, ["Neon"] = 169.21, ["Neon|Ride"] = 158.01, ["Neon|Fly|Ride"] = 170.82, ["Mega"] = 1010.63, ["Mega|Ride"] = 1096.38, ["Mega|Fly|Ride"] = 820.31}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 235.83, ["Fly"] = 361.97, ["Ride"] = 236.25, ["Fly|Ride"] = 403.13, ["Neon"] = 830.82, ["Neon|Ride"] = 892.5, ["Neon|Fly|Ride"] = 853.13, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 3899.56}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 38.74}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 12.93, ["Fly"] = 128.15, ["Ride"] = 64.97, ["Fly|Ride"] = 143.1, ["Neon"] = 65.63, ["Neon|Ride"] = 128.62, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 353.22, ["Mega|Ride"] = 567.95, ["Mega|Fly|Ride"] = 597.19}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 112.85, ["Fly"] = 160.61, ["Ride"] = 144.27, ["Fly|Ride"] = 168.72, ["Neon"] = 639.62, ["Neon|Ride"] = 498.61, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 2220.49}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 91.74, ["Fly"] = 157.5, ["Ride"] = 122.07, ["Fly|Ride"] = 211.64, ["Neon"] = 389.24, ["Neon|Fly"] = 570.15, ["Neon|Ride"] = 434.78, ["Neon|Fly|Ride"] = 496.12, ["Mega|Ride"] = 1447.73, ["Mega|Fly|Ride"] = 1382.07}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 34.04}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 53.34, ["Fly"] = 67.29, ["Ride"] = 40.69, ["Fly|Ride"] = 69.54, ["Neon|Ride"] = 370.44, ["Neon|Fly|Ride"] = 325.5, ["Mega"] = 4270.17, ["Mega|Fly|Ride"] = 1350.21}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 4.28, ["Fly"] = 98.44, ["Ride"] = 54.47, ["Fly|Ride"] = 206.34, ["Neon"] = 35.44, ["Neon|Fly"] = 223.13, ["Neon|Ride"] = 93.97, ["Neon|Fly|Ride"] = 240.21, ["Mega"] = 170.63, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 276.94, ["Mega|Fly|Ride"] = 427.03}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 465.94, ["Fly"] = 703.6, ["Ride"] = 479.03, ["Fly|Ride"] = 539.43, ["Neon|Fly"] = 3843.61, ["Neon|Ride"] = 1876.88, ["Neon|Fly|Ride"] = 1857.77, ["Mega|Ride"] = 14945.55, ["Mega|Fly|Ride"] = 7481.25}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 105, ["Fly"] = 185.81, ["Ride"] = 129.94, ["Fly|Ride"] = 183.74, ["Neon"] = 420, ["Neon|Ride"] = 470.8, ["Neon|Fly|Ride"] = 583.95, ["Mega|Ride"] = 2562.11, ["Mega|Fly|Ride"] = 2296.88}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3543.75, ["Ride"] = 3885, ["Fly|Ride"] = 3937.5, ["Neon|Fly|Ride"] = 14944.49}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 56.44, ["Fly"] = 121.75, ["Ride"] = 80.73, ["Fly|Ride"] = 169.78, ["Neon"] = 443.15, ["Neon|Ride"] = 279.74, ["Neon|Fly|Ride"] = 292.69, ["Mega"] = 2135.09, ["Mega|Ride"] = 1984.57, ["Mega|Fly|Ride"] = 1749.57}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 48.57, ["Ride"] = 70.88, ["Fly|Ride"] = 143.1, ["Neon"] = 575.75, ["Neon|Ride"] = 427.88, ["Neon|Fly|Ride"] = 399.27, ["Mega"] = 6263.27, ["Mega|Ride"] = 2388.75, ["Mega|Fly|Ride"] = 2335.78}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 31.29, ["Fly"] = 42.72, ["Ride"] = 47.25, ["Fly|Ride"] = 71.52, ["Neon"] = 151.72, ["Neon|Fly"] = 285.09, ["Neon|Ride"] = 140.88, ["Neon|Fly|Ride"] = 204.75, ["Mega"] = 997.11, ["Mega|Ride"] = 878.6, ["Mega|Fly|Ride"] = 577.47}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 4.27}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 54.21, ["Fly"] = 393.75, ["Ride"] = 46.58, ["Fly|Ride"] = 96.54, ["Neon|Ride"] = 322.13, ["Neon|Fly|Ride"] = 597.84, ["Mega|Ride"] = 1287.27, ["Mega|Fly|Ride"] = 1447.73}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 32.82}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 184.8, ["Ride"] = 233.89, ["Fly|Ride"] = 282.19, ["Neon"] = 965.58, ["Neon|Ride"] = 997.11, ["Neon|Fly|Ride"] = 1135.88, ["Mega|Fly|Ride"] = 5067.01}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 628.89, ["Ride"] = 643.12, ["Fly|Ride"] = 748.13, ["Neon"] = 2625, ["Neon|Fly|Ride"] = 3619.28, ["Mega|Fly|Ride"] = 11265.36}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 7.88}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 27.86, ["Fly"] = 45.94, ["Ride"] = 35.63, ["Fly|Ride"] = 75.86, ["Neon"] = 228.53, ["Neon|Fly"] = 170.85, ["Neon|Ride"] = 179.65, ["Neon|Fly|Ride"] = 211.41, ["Mega"] = 2135.09, ["Mega|Ride"] = 1158.19, ["Mega|Fly|Ride"] = 767.8}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 20.89}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 4462.5, ["Fly"] = 7118.99, ["Ride"] = 5650.32, ["Fly|Ride"] = 5055.7, ["Neon|Ride"] = 17703.78, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 43431.32}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 6.57, ["Fly"] = 55.12, ["Ride"] = 24.94, ["Fly|Ride"] = 56.44, ["Neon"] = 72.19, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 207.12, ["Mega"] = 561.75, ["Mega|Ride"] = 490.88, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 12.49, ["Fly"] = 139.9, ["Ride"] = 28.88, ["Fly|Ride"] = 119.46, ["Neon"] = 126, ["Neon|Ride"] = 128.14, ["Neon|Fly|Ride"] = 262.48, ["Mega"] = 712.06, ["Mega|Ride"] = 840.16, ["Mega|Fly|Ride"] = 997.11}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 45.94, ["Ride"] = 45.94, ["Fly|Ride"] = 100.38, ["Neon|Ride"] = 396.06, ["Neon|Fly|Ride"] = 480.96, ["Mega"] = 4270.17, ["Mega|Fly|Ride"] = 1769.84}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 11.82, ["Fly"] = 71.55, ["Ride"] = 33.08, ["Fly|Ride"] = 78.75, ["Neon"] = 82.43, ["Neon|Ride"] = 148.32, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 1424.11, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 800.63}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1783.69, ["Fly"] = 2364.11, ["Ride"] = 1851.92, ["Fly|Ride"] = 1607.97, ["Neon|Fly|Ride"] = 3353.44, ["Mega|Fly|Ride"] = 12468.75}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 27300, ["Fly"] = 34169.41, ["Ride"] = 35437.5, ["Fly|Ride"] = 25591.13, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 63000, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 183748.69}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 24.05, ["Fly"] = 393.75, ["Ride"] = 57.75, ["Fly|Ride"] = 128.15, ["Neon"] = 256.29, ["Neon|Ride"] = 208.69, ["Neon|Fly|Ride"] = 570.08, ["Mega"] = 754.69, ["Mega|Ride"] = 1148.44, ["Mega|Fly|Ride"] = 1281.06}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 3.93, ["Fly"] = 105, ["Ride"] = 35.7, ["Fly|Ride"] = 158.05, ["Neon"] = 21, ["Neon|Fly"] = 145.15, ["Neon|Ride"] = 64.22, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 157.5, ["Mega|Fly"] = 285.05, ["Mega|Ride"] = 182.44, ["Mega|Fly|Ride"] = 282.19}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 21.2}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 8.93, ["Ride"] = 49.86, ["Fly|Ride"] = 131.25, ["Neon"] = 68.25, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 277.1, ["Mega"] = 403.54, ["Mega|Ride"] = 427.03, ["Mega|Fly|Ride"] = 746.22}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 748.13, ["Fly"] = 901.3, ["Ride"] = 708.65, ["Fly|Ride"] = 711.38, ["Neon"] = 2890.54, ["Neon|Ride"] = 2818.31, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 11260.79}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 917.23, ["Fly"] = 853.13, ["Ride"] = 984.38, ["Fly|Ride"] = 1013.84, ["Neon"] = 4129.17, ["Neon|Fly|Ride"] = 3109.32, ["Mega|Fly|Ride"] = 11885.98}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 12.17, ["Fly"] = 120.66, ["Ride"] = 30.32, ["Fly|Ride"] = 91.84, ["Neon"] = 82.72, ["Neon|Ride"] = 80.71, ["Neon|Fly|Ride"] = 161.44, ["Mega"] = 1215.56, ["Mega|Ride"] = 481.69, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 24.94}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 69.57, ["Fly"] = 89.15, ["Ride"] = 82.69, ["Fly|Ride"] = 126, ["Neon"] = 570.22, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 420, ["Mega"] = 19687.5, ["Mega|Ride"] = 1994.19, ["Mega|Fly|Ride"] = 2124.42}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 80.85, ["Ride"] = 90.96, ["Fly|Ride"] = 213.59, ["Neon"] = 369.99, ["Neon|Ride"] = 386.78, ["Neon|Fly|Ride"] = 521.34, ["Mega"] = 1416.07, ["Mega|Ride"] = 1708.08, ["Mega|Fly|Ride"] = 1909.89}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 3.93, ["Fly"] = 28.67, ["Ride"] = 23, ["Fly|Ride"] = 52.32, ["Neon"] = 48.07, ["Neon|Fly"] = 524.99, ["Neon|Ride"] = 61.93, ["Neon|Fly|Ride"] = 110.92, ["Mega"] = 170.63, ["Mega|Fly|Ride"] = 570.08}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 151.95, ["Fly"] = 170.63, ["Ride"] = 162.75, ["Fly|Ride"] = 246.75, ["Neon"] = 853.18, ["Neon|Ride"] = 590.62, ["Neon|Fly|Ride"] = 623.44, ["Mega"] = 5124.2, ["Mega|Ride"] = 2895.44, ["Mega|Fly|Ride"] = 2559.37}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 5.24, ["Ride"] = 51.19, ["Fly|Ride"] = 200.75, ["Neon"] = 42, ["Neon|Ride"] = 124.67, ["Neon|Fly|Ride"] = 285.05, ["Mega"] = 223.02, ["Mega|Fly"] = 1137.94, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 566.62}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 10.38, ["Fly"] = 50.21, ["Ride"] = 32.81, ["Fly|Ride"] = 89.72, ["Neon"] = 120.75, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 1050, ["Mega|Ride"] = 826.29, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 27.66, ["Ride"] = 68.23, ["Fly|Ride"] = 156.19, ["Neon"] = 198.61, ["Neon|Ride"] = 228.38, ["Mega"] = 997.5, ["Mega|Ride"] = 853.13, ["Mega|Fly|Ride"] = 1011.85}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 13.13, ["Fly"] = 57.68, ["Ride"] = 37.31, ["Fly|Ride"] = 63.95, ["Neon"] = 103.69, ["Neon|Ride"] = 125.98, ["Neon|Fly|Ride"] = 323.48, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6300, ["Ride"] = 5118.75, ["Fly|Ride"] = 5248.69, ["Neon"] = 32033.81, ["Neon|Ride"] = 28471.48, ["Neon|Fly|Ride"] = 27756.02}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 227.05, ["Fly"] = 254.67, ["Ride"] = 242.82, ["Fly|Ride"] = 282.19, ["Neon"] = 747.38, ["Neon|Fly|Ride"] = 611.63, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 51.17, ["Fly"] = 161.44, ["Ride"] = 110.25, ["Fly|Ride"] = 210, ["Neon"] = 169.32, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 135.61, ["Neon|Fly|Ride"] = 287.44, ["Mega"] = 494.82, ["Mega|Fly"] = 651.48, ["Mega|Ride"] = 563.07, ["Mega|Fly|Ride"] = 619.5}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.96, ["Fly"] = 89.31, ["Ride"] = 19.69, ["Fly|Ride"] = 81.38, ["Neon"] = 21, ["Neon|Fly"] = 85.43, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 499.8, ["Mega|Ride"] = 330.75, ["Mega|Fly|Ride"] = 250.69}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 61.73, ["Fly"] = 211.03, ["Ride"] = 129.11, ["Fly|Ride"] = 234.94, ["Neon"] = 210, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 391.12, ["Mega"] = 569.58, ["Mega|Ride"] = 1440.12, ["Mega|Fly|Ride"] = 783.59}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 16373.57, ["Ride"] = 13415.07, ["Fly|Ride"] = 11808.56, ["Neon|Fly|Ride"] = 22903.13, ["Mega|Fly|Ride"] = 78286.89}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 229.69, ["Ride"] = 383.52, ["Fly|Ride"] = 459.38, ["Neon|Ride"] = 1563.09, ["Neon|Fly|Ride"] = 1601.33}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 68.16, ["Fly"] = 91.43, ["Ride"] = 72.16, ["Fly|Ride"] = 98.44, ["Neon"] = 1049.99, ["Neon|Ride"] = 328.11, ["Neon|Fly|Ride"] = 305.68, ["Mega|Fly|Ride"] = 3095.89}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 9.18, ["Ride"] = 26.25, ["Fly|Ride"] = 56.44, ["Neon"] = 66.11, ["Neon|Fly"] = 322.28, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 140.93, ["Mega"] = 393.75, ["Mega|Ride"] = 427.03, ["Mega|Fly|Ride"] = 498.57}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 393.64, ["Fly"] = 854.25, ["Ride"] = 433.12, ["Fly|Ride"] = 542.07, ["Neon"] = 1663.65, ["Neon|Ride"] = 1706.25, ["Neon|Fly|Ride"] = 1637.62, ["Mega|Fly|Ride"] = 5232.94}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 7.93, ["Ride"] = 39.29, ["Fly|Ride"] = 198.85, ["Neon"] = 32.71, ["Neon|Ride"] = 128.51, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 149.47, ["Mega|Fly"] = 263.92, ["Mega|Ride"] = 228.38, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 93.19, ["Fly"] = 167.91, ["Ride"] = 142.67, ["Fly|Ride"] = 193.58, ["Neon"] = 459.38, ["Neon|Fly"] = 525, ["Neon|Ride"] = 488.25, ["Neon|Fly|Ride"] = 523.69, ["Mega|Fly|Ride"] = 2199.07}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 11.82, ["Fly"] = 21.37, ["Ride"] = 18.71, ["Fly|Ride"] = 39.29, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 2562.11, ["Mega|Fly|Ride"] = 454.79}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 10.38}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 66.29, ["Ride"] = 86.63, ["Fly|Ride"] = 177.27, ["Neon"] = 353.07, ["Neon|Fly"] = 426.01, ["Neon|Ride"] = 406.87, ["Neon|Fly|Ride"] = 356.57, ["Mega|Ride"] = 1992.04, ["Mega|Fly|Ride"] = 1633.34}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 9.19, ["Fly"] = 80.07, ["Ride"] = 31.4, ["Fly|Ride"] = 91.88, ["Neon"] = 98.44, ["Neon|Ride"] = 129.17, ["Neon|Fly|Ride"] = 219.84, ["Mega"] = 575.42, ["Mega|Ride"] = 577.5, ["Mega|Fly|Ride"] = 570.08}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 30.07}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 55.52, ["Fly"] = 143.1, ["Ride"] = 91.88, ["Fly|Ride"] = 316.32, ["Neon"] = 322.28, ["Neon|Ride"] = 328.12, ["Neon|Fly|Ride"] = 511.87, ["Mega|Fly|Ride"] = 1695.27}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.82, ["Ride"] = 29.23, ["Fly|Ride"] = 137.23, ["Neon"] = 24.14, ["Neon|Ride"] = 135.61, ["Neon|Fly|Ride"] = 256.23, ["Mega"] = 178.29, ["Mega|Fly|Ride"] = 449.54}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 10.69, ["Fly"] = 56.44, ["Ride"] = 37.4, ["Fly|Ride"] = 99.99, ["Neon"] = 65.17, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 199.64, ["Mega|Ride"] = 639.47, ["Mega|Fly|Ride"] = 512.44}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 431.82, ["Fly"] = 435.75, ["Ride"] = 534.35, ["Fly|Ride"] = 541.66, ["Neon|Fly|Ride"] = 2748.43, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 31.79, ["Fly"] = 106.8, ["Ride"] = 58.95, ["Fly|Ride"] = 97.71, ["Neon"] = 129.94, ["Neon|Ride"] = 170.82, ["Neon|Fly|Ride"] = 339.5, ["Mega"] = 776.43, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 717.84}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 39.34, ["Fly"] = 142.99, ["Ride"] = 71.47, ["Fly|Ride"] = 143.1, ["Neon"] = 234.94, ["Neon|Ride"] = 162.29, ["Neon|Fly|Ride"] = 319.22, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 19.22, ["Fly"] = 114.28, ["Ride"] = 67.56, ["Fly|Ride"] = 100.38, ["Neon"] = 87.94, ["Neon|Fly"] = 137.82, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 437.07, ["Mega|Fly"] = 525, ["Mega|Ride"] = 465.84, ["Mega|Fly|Ride"] = 634.6}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 8334.38, ["Ride"] = 8862, ["Fly|Ride"] = 7875, ["Neon|Fly|Ride"] = 14311.5, ["Mega|Fly|Ride"] = 38850}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1344, ["Fly"] = 1486.83, ["Ride"] = 1443.75, ["Fly|Ride"] = 1428, ["Neon|Fly|Ride"] = 5003.06}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 597.98, ["Ride"] = 619.34, ["Fly|Ride"] = 796.59, ["Neon"] = 2253.58, ["Neon|Fly|Ride"] = 2625, ["Mega"] = 21350.78, ["Mega|Fly|Ride"] = 9817.11}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 11.45, ["Fly"] = 23.85, ["Ride"] = 21.11, ["Fly|Ride"] = 38.96, ["Neon"] = 71.55, ["Neon|Ride"] = 90.27, ["Neon|Fly|Ride"] = 127.05, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 577.49}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 6.3, ["Fly"] = 78.74, ["Ride"] = 28.85, ["Fly|Ride"] = 131.25, ["Neon"] = 22.32, ["Neon|Ride"] = 56.11, ["Mega"] = 184.04, ["Mega|Ride"] = 198.41, ["Mega|Fly|Ride"] = 285.87}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 36.66, ["Fly"] = 59.78, ["Ride"] = 48.19, ["Fly|Ride"] = 103.66, ["Neon"] = 199.69, ["Neon|Ride"] = 150.94, ["Neon|Fly|Ride"] = 181.12, ["Mega|Fly|Ride"] = 666.75}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.66, ["Fly"] = 23.39, ["Ride"] = 18.1, ["Fly|Ride"] = 40.16, ["Neon"] = 23.63, ["Neon|Fly"] = 86.63, ["Neon|Ride"] = 44.86, ["Neon|Fly|Ride"] = 98.43, ["Mega"] = 319.22, ["Mega|Ride"] = 213.52, ["Mega|Fly|Ride"] = 269.07}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 335.31, ["Fly"] = 369.5, ["Ride"] = 282.1, ["Fly|Ride"] = 328.13, ["Neon"] = 1110.03, ["Neon|Ride"] = 1439.23, ["Neon|Fly|Ride"] = 1174.3, ["Mega|Fly|Ride"] = 4436.25}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 19.84, ["Fly"] = 60.34, ["Ride"] = 41.91, ["Fly|Ride"] = 78.66, ["Neon"] = 131.25, ["Neon|Fly"] = 403.22, ["Neon|Ride"] = 100.36, ["Neon|Fly|Ride"] = 231, ["Mega"] = 854.05, ["Mega|Fly"] = 901.22, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 642.54}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 9.08, ["Fly"] = 18.38, ["Ride"] = 21.4, ["Fly|Ride"] = 40.67, ["Neon"] = 83.3, ["Neon|Fly"] = 120.66, ["Neon|Ride"] = 80.85, ["Neon|Fly|Ride"] = 104.21, ["Mega"] = 1575, ["Mega|Ride"] = 608.06, ["Mega|Fly|Ride"] = 423.94}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 669.52, ["Fly"] = 1048.69, ["Ride"] = 567, ["Fly|Ride"] = 482.63, ["Neon|Fly|Ride"] = 3560.26, ["Mega|Fly|Ride"] = 9971.07}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1115.63, ["Fly"] = 1424.45, ["Ride"] = 1214.04, ["Fly|Ride"] = 1293.03, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 13236.43}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 65.63, ["Fly"] = 143.1, ["Ride"] = 91.88, ["Fly|Ride"] = 125.26, ["Neon"] = 512.56, ["Neon|Ride"] = 587.15, ["Neon|Fly|Ride"] = 480.64, ["Mega|Fly|Ride"] = 2807.36}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 182.44, ["Fly"] = 209.99, ["Ride"] = 204.65, ["Fly|Ride"] = 262.49, ["Neon"] = 957.11, ["Neon|Ride"] = 557.82, ["Neon|Fly|Ride"] = 721.66, ["Mega|Ride"] = 9187.5, ["Mega|Fly|Ride"] = 2598.75}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 29.3, ["Fly"] = 57.68, ["Ride"] = 35.49, ["Fly|Ride"] = 100.38, ["Neon"] = 236.25, ["Neon|Ride"] = 240.55, ["Mega|Ride"] = 2135.09, ["Mega|Fly|Ride"] = 1079.77}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 328.13, ["Ride"] = 315, ["Fly|Ride"] = 427.13, ["Neon"] = 1220.63, ["Neon|Fly"] = 965.58, ["Neon|Fly|Ride"] = 1281.06, ["Mega|Fly|Ride"] = 5694.27}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 1968.75, ["Fly"] = 1994.66, ["Ride"] = 1955.63, ["Fly|Ride"] = 2100, ["Neon|Fly|Ride"] = 10675.4, ["Mega|Fly|Ride"] = 35390.51}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 57.62, ["Fly"] = 213.59, ["Ride"] = 51.18, ["Fly|Ride"] = 196.88, ["Neon"] = 174.57, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 343.88, ["Mega"] = 1424.11, ["Mega|Ride"] = 1139.08, ["Mega|Fly|Ride"] = 1253.31}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 623.42, ["Fly"] = 854.25, ["Ride"] = 629.9, ["Fly|Ride"] = 576.93, ["Neon|Ride"] = 1498.88, ["Neon|Fly|Ride"] = 1276.96, ["Mega|Fly|Ride"] = 3451.88}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 45.82, ["Fly"] = 52.5, ["Ride"] = 64.08, ["Fly|Ride"] = 87.05, ["Neon"] = 262.5, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 242.82, ["Mega|Ride"] = 1067.55, ["Mega|Fly|Ride"] = 965.15}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.93, ["Fly"] = 32.71, ["Ride"] = 19.38, ["Fly|Ride"] = 51.96, ["Neon"] = 36.32, ["Neon|Fly"] = 74.82, ["Neon|Ride"] = 52.36, ["Neon|Fly|Ride"] = 97.44, ["Mega"] = 179.82, ["Mega|Ride"] = 186.27, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 58.49, ["Ride"] = 129.11, ["Fly|Ride"] = 157.5, ["Neon"] = 262.5, ["Neon|Ride"] = 452.82, ["Neon|Fly|Ride"] = 712.06, ["Mega"] = 1562.89, ["Mega|Ride"] = 1708.08}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 854.43, ["Ride"] = 826.88, ["Fly|Ride"] = 888.46, ["Neon|Ride"] = 3255, ["Neon|Fly|Ride"] = 3064.69, ["Mega|Fly|Ride"] = 12064.26}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 641.82, ["Ride"] = 857.85, ["Fly|Ride"] = 896.97, ["Neon|Fly|Ride"] = 2847.14, ["Mega|Fly|Ride"] = 15513.48}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 15.43, ["Fly"] = 23.91, ["Ride"] = 23, ["Fly|Ride"] = 50.21, ["Neon"] = 144.38, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 783.59, ["Mega|Fly|Ride"] = 722.52}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 13.55, ["Ride"] = 31.47, ["Fly|Ride"] = 114.28, ["Neon"] = 129.05, ["Neon|Ride"] = 193.04, ["Neon|Fly|Ride"] = 248.07, ["Mega"] = 997.11, ["Mega|Ride"] = 840.16, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 6.28, ["Fly"] = 75.83, ["Ride"] = 41.91, ["Fly|Ride"] = 141.72, ["Neon"] = 19.69, ["Neon|Fly"] = 322.28, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 228.46, ["Mega"] = 176.68, ["Mega|Fly"] = 563.41, ["Mega|Ride"] = 202.5, ["Mega|Fly|Ride"] = 356.57}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 41.2, ["Fly"] = 50.94, ["Ride"] = 49.88, ["Fly|Ride"] = 107.63, ["Neon"] = 223.13, ["Neon|Fly"] = 207.15, ["Neon|Ride"] = 215.65, ["Neon|Fly|Ride"] = 242.81, ["Mega|Ride"] = 890.35, ["Mega|Fly|Ride"] = 1035.57}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 83.51, ["Ride"] = 184.04, ["Fly|Ride"] = 356.66, ["Neon"] = 428.35, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 2420.13, ["Mega|Ride"] = 2292.22, ["Mega|Fly|Ride"] = 2262.12}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 11.8, ["Fly"] = 52.41, ["Ride"] = 37.97, ["Fly|Ride"] = 63.67, ["Neon"] = 76.31, ["Neon|Fly"] = 85.43, ["Neon|Ride"] = 98.43, ["Neon|Fly|Ride"] = 250.95, ["Mega"] = 425.39, ["Mega|Ride"] = 340.74, ["Mega|Fly|Ride"] = 514.17}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 32.59, ["Fly"] = 52.5, ["Ride"] = 39.38, ["Fly|Ride"] = 94, ["Neon"] = 242.82, ["Neon|Ride"] = 200.41, ["Neon|Fly|Ride"] = 234.92, ["Mega"] = 2100, ["Mega|Fly|Ride"] = 1241.62}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 6.33, ["Fly"] = 19.23, ["Ride"] = 17.74, ["Fly|Ride"] = 42.72, ["Neon"] = 26.25, ["Neon|Fly"] = 37.43, ["Neon|Ride"] = 59.76, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 434.74, ["Mega|Ride"] = 482.58, ["Mega|Fly|Ride"] = 369.71}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 5.24, ["Fly"] = 64.04, ["Ride"] = 46.99, ["Fly|Ride"] = 86.63, ["Neon"] = 52.39, ["Neon|Fly"] = 114.19, ["Neon|Ride"] = 68.25, ["Neon|Fly|Ride"] = 235.94, ["Mega"] = 416.06, ["Mega|Ride"] = 414.22, ["Mega|Fly|Ride"] = 479.07}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 46.33, ["Fly"] = 70.72, ["Ride"] = 48.76, ["Fly|Ride"] = 98.44, ["Neon"] = 578.43, ["Neon|Fly"] = 211.3, ["Neon|Ride"] = 276.53, ["Neon|Fly|Ride"] = 249.38, ["Mega|Fly|Ride"] = 1074.92}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1443.75, ["Fly"] = 1410.94, ["Ride"] = 1389.92, ["Fly|Ride"] = 1489.69, ["Neon"] = 4464.18, ["Neon|Ride"] = 4827.87, ["Neon|Fly|Ride"] = 3853.5, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 472.49, ["Fly"] = 524.99, ["Ride"] = 465.94, ["Fly|Ride"] = 479.07, ["Neon|Ride"] = 3132.55, ["Neon|Fly|Ride"] = 2362.5, ["Mega"] = 14945.55}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 265.13, ["Fly"] = 378.23, ["Ride"] = 359.63, ["Fly|Ride"] = 354.38, ["Neon"] = 1575, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 7684.16}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 39.37}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 32.43, ["Ride"] = 42, ["Fly|Ride"] = 99.73, ["Neon"] = 325.5, ["Neon|Fly"] = 427.08, ["Neon|Ride"] = 192.18, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 1708.08, ["Mega|Fly|Ride"] = 1036.54}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 70875, ["Fly"] = 23491.48, ["Ride"] = 36195.96, ["Fly|Ride"] = 18374.91, ["Neon|Fly|Ride"] = 38061.19, ["Mega"] = 213507.74, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 232.31, ["Fly"] = 262.4, ["Ride"] = 243.43, ["Fly|Ride"] = 334.68, ["Neon"] = 1036.88, ["Neon|Ride"] = 940.63, ["Neon|Fly|Ride"] = 879.38, ["Mega"] = 6405.25, ["Mega|Fly|Ride"] = 3887.51}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 216.46, ["Fly"] = 525, ["Ride"] = 249.38, ["Fly|Ride"] = 257.27}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 162.74, ["Fly"] = 157.5, ["Ride"] = 132.37, ["Fly|Ride"] = 146.99, ["Neon"] = 538.35, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 630, ["Mega|Ride"] = 3560.26, ["Mega|Fly|Ride"] = 2986.99}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 11.7, ["Fly"] = 64.08, ["Ride"] = 30.19, ["Fly|Ride"] = 84.36, ["Neon"] = 113.47, ["Neon|Ride"] = 114.26, ["Neon|Fly|Ride"] = 228.46, ["Mega"] = 721.46, ["Mega|Ride"] = 482.58, ["Mega|Fly|Ride"] = 960.81}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 4974.86, ["Ride"] = 3937.5, ["Fly|Ride"] = 4055.63, ["Neon"] = 21355.88, ["Neon|Fly|Ride"] = 15750}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 26.25, ["Fly"] = 32.82, ["Ride"] = 34.13, ["Fly|Ride"] = 53.82, ["Neon"] = 131.25, ["Neon|Ride"] = 203.99, ["Neon|Fly|Ride"] = 199.39, ["Mega|Ride"] = 1424.11, ["Mega|Fly|Ride"] = 723.87}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 37.27, ["Ride"] = 48.47, ["Fly|Ride"] = 102.84, ["Neon"] = 314.26, ["Neon|Fly"] = 1424.28, ["Neon|Ride"] = 202.79, ["Neon|Fly|Ride"] = 262.49, ["Mega|Fly|Ride"] = 1378.21}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 477.35, ["Fly"] = 563.06, ["Ride"] = 427.13, ["Fly|Ride"] = 564.38, ["Neon"] = 1312.5, ["Neon|Ride"] = 1242.93, ["Neon|Fly|Ride"] = 1380.75, ["Mega|Fly|Ride"] = 5481.83}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 19.58, ["Fly"] = 24.94, ["Ride"] = 23.63, ["Fly|Ride"] = 38.53, ["Neon"] = 131.24, ["Neon|Fly"] = 161.23, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 143.04, ["Mega|Ride"] = 611.67, ["Mega|Fly|Ride"] = 532.11}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 13.55, ["Ride"] = 34.54, ["Fly|Ride"] = 80.64, ["Neon"] = 98.43, ["Neon|Ride"] = 143.07, ["Neon|Fly|Ride"] = 209.09, ["Mega"] = 563.41, ["Mega|Ride"] = 747.99, ["Mega|Fly|Ride"] = 528.45}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 108.94, ["Ride"] = 103.69, ["Fly|Ride"] = 242.41, ["Neon"] = 1010.63, ["Neon|Ride"] = 588.3, ["Neon|Fly|Ride"] = 698.18, ["Mega|Fly|Ride"] = 2703.02}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 15.75, ["Fly"] = 103.69, ["Ride"] = 63.66, ["Fly|Ride"] = 470.91, ["Neon"] = 71.55, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 196.86, ["Mega"] = 360.85, ["Mega|Fly"] = 487.1, ["Mega|Ride"] = 313.72, ["Mega|Fly|Ride"] = 478.17}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3937.5, ["Fly"] = 6210.14, ["Ride"] = 4068.75, ["Fly|Ride"] = 4134.38, ["Neon"] = 19687.5, ["Neon|Ride"] = 12337.5, ["Neon|Fly|Ride"] = 10354.32, ["Mega"] = 48395.82, ["Mega|Fly|Ride"] = 37945.69}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 32.97, ["Fly"] = 143.1, ["Ride"] = 65.54, ["Fly|Ride"] = 144.38, ["Neon"] = 215.25, ["Neon|Ride"] = 258.57, ["Neon|Fly|Ride"] = 320.28, ["Mega"] = 854.05, ["Mega|Ride"] = 1769.84, ["Mega|Fly|Ride"] = 784.88}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 7581.35, ["Fly"] = 7581.35, ["Ride"] = 6857.82, ["Fly|Ride"] = 6365.63, ["Neon|Fly|Ride"] = 15225, ["Mega|Fly|Ride"] = 46921.88}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.63, ["Fly"] = 18.88, ["Ride"] = 16.3, ["Fly|Ride"] = 37.88, ["Neon"] = 24.92, ["Neon|Fly"] = 62.62, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 157.5, ["Mega|Ride"] = 372.75, ["Mega|Fly|Ride"] = 248.07}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 18.24, ["Fly"] = 31.5, ["Ride"] = 32.5, ["Fly|Ride"] = 61.94, ["Neon"] = 185.81, ["Neon|Fly"] = 235.97, ["Neon|Ride"] = 498.61, ["Neon|Fly|Ride"] = 167.99, ["Mega|Ride"] = 991.6, ["Mega|Fly|Ride"] = 997.11}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.93}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 11.06, ["Ride"] = 19.69, ["Fly|Ride"] = 87.02, ["Neon"] = 78.75, ["Neon|Ride"] = 118.13, ["Mega"] = 1018.71, ["Mega|Ride"] = 1065.42, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 22.29, ["Fly"] = 190.37, ["Ride"] = 42.7, ["Fly|Ride"] = 99.75, ["Neon"] = 203.44, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 945, ["Mega|Ride"] = 854.05, ["Mega|Fly|Ride"] = 1099.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 13.84, ["Fly"] = 27.78, ["Ride"] = 19.69, ["Fly|Ride"] = 36.21, ["Neon|Fly"] = 1064.48, ["Neon|Ride"] = 113.17, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 2562.11, ["Mega|Fly|Ride"] = 570.08}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8685.45}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2624.99}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 18.37}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 161.44, ["Ride"] = 391.9, ["Fly|Ride"] = 315, ["Mega|Fly|Ride"] = 4200}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 15.01, ["Fly"] = 143.1, ["Ride"] = 31.49, ["Fly|Ride"] = 143.1, ["Neon"] = 85.43, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 265.13, ["Mega"] = 525, ["Mega|Ride"] = 532.05, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 10.49}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 6.17, ["Ride"] = 26.25, ["Neon|Ride"] = 155.88, ["Mega"] = 1566.1}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2357.24}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 152.81, ["Fly"] = 356.66, ["Ride"] = 261.18, ["Fly|Ride"] = 328.13, ["Neon"] = 997.34, ["Neon|Ride"] = 965.15, ["Neon|Fly|Ride"] = 777.18, ["Mega|Ride"] = 4128.18, ["Mega|Fly|Ride"] = 3936.45}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 59.07, ["Ride"] = 84.62, ["Fly|Ride"] = 241.32, ["Neon"] = 315, ["Neon|Ride"] = 356.55, ["Neon|Fly|Ride"] = 712.06, ["Mega|Ride"] = 1851.13, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 155.9, ["Fly"] = 196.88, ["Ride"] = 170.61, ["Fly|Ride"] = 238.55, ["Neon"] = 944.99, ["Neon|Ride"] = 787.49, ["Neon|Fly|Ride"] = 823.8, ["Mega"] = 3987.27, ["Mega|Fly|Ride"] = 3490.1}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 2395.31, ["Fly"] = 3074.3, ["Ride"] = 2607.08, ["Fly|Ride"] = 2602, ["Neon"] = 14998.25, ["Neon|Ride"] = 9655.73, ["Neon|Fly|Ride"] = 7875, ["Mega|Fly|Ride"] = 27045.04}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 16.04, ["Fly"] = 182.61, ["Ride"] = 42.14, ["Fly|Ride"] = 105.73, ["Neon"] = 120.66, ["Neon|Ride"] = 154.44, ["Neon|Fly|Ride"] = 199.64, ["Mega"] = 959.73, ["Mega|Ride"] = 997.11, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 813.75, ["Fly"] = 2100, ["Ride"] = 997.34, ["Fly|Ride"] = 867.18, ["Neon|Fly|Ride"] = 4182.69}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 39.87}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 17.07, ["Ride"] = 50.69, ["Fly|Ride"] = 340.26, ["Neon"] = 78.75, ["Neon|Ride"] = 137.06, ["Neon|Fly|Ride"] = 314.94, ["Mega"] = 480.38, ["Mega|Fly"] = 965.15, ["Mega|Ride"] = 509.36, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 7.01, ["Fly"] = 48.27, ["Ride"] = 27.96, ["Fly|Ride"] = 127.33, ["Neon"] = 57.66, ["Neon|Fly"] = 315, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 178.5, ["Mega"] = 451.22, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 405.68}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 60.38}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 19.11, ["Fly"] = 108.92, ["Ride"] = 28.88, ["Fly|Ride"] = 100.38, ["Neon|Ride"] = 193.04, ["Neon|Fly|Ride"] = 254.63, ["Mega|Fly|Ride"] = 2135.09}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 40, ["Fly"] = 45.94, ["Ride"] = 39.37, ["Fly|Ride"] = 45.94, ["Neon|Fly"] = 235.97, ["Neon|Ride"] = 293.58, ["Neon|Fly|Ride"] = 170.82, ["Mega"] = 1424.11, ["Mega|Ride"] = 1809.66, ["Mega|Fly|Ride"] = 989.63}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6470.85, ["Fly"] = 10237.5, ["Ride"] = 7875, ["Fly|Ride"] = 4764.38, ["Neon|Fly|Ride"] = 9843.75, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 6.57, ["Fly"] = 61.69, ["Ride"] = 26.17, ["Fly|Ride"] = 81.38, ["Neon"] = 54.55, ["Neon|Ride"] = 82.57, ["Neon|Fly|Ride"] = 199.64, ["Mega"] = 512.44, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 535.5}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 19.36}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 83.15, ["Fly"] = 378.02, ["Ride"] = 124.69, ["Fly|Ride"] = 157.5, ["Neon"] = 486.25, ["Neon|Ride"] = 512.43, ["Neon|Fly|Ride"] = 481.42, ["Mega"] = 2879.59, ["Mega|Ride"] = 1764.77, ["Mega|Fly|Ride"] = 2434}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 47.87, ["Fly"] = 189.02, ["Ride"] = 75.49, ["Fly|Ride"] = 185.81, ["Neon"] = 347.82, ["Neon|Ride"] = 285.05, ["Neon|Fly|Ride"] = 446.25, ["Mega"] = 2412.86, ["Mega|Ride"] = 2882.37, ["Mega|Fly|Ride"] = 1046.07}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 23.28, ["Fly"] = 71.55, ["Ride"] = 30.61, ["Fly|Ride"] = 66.89, ["Neon"] = 128.78, ["Neon|Fly"] = 230.63, ["Neon|Ride"] = 156.18, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 1016.21, ["Mega|Ride"] = 868.64, ["Mega|Fly|Ride"] = 800.62}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 5.99, ["Fly"] = 71.8, ["Ride"] = 26.17, ["Fly|Ride"] = 112.59, ["Neon"] = 28.58, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 129.84, ["Mega"] = 162.73, ["Mega|Fly"] = 285.05, ["Mega|Ride"] = 221.79, ["Mega|Fly|Ride"] = 326.03}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 10.39, ["Ride"] = 30.4, ["Fly|Ride"] = 98.06, ["Neon"] = 99.75, ["Neon|Ride"] = 120.74, ["Neon|Fly|Ride"] = 218.28, ["Mega"] = 541.26, ["Mega|Ride"] = 632, ["Mega|Fly|Ride"] = 586.27}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 21, ["Fly"] = 27.23, ["Ride"] = 29.8, ["Fly|Ride"] = 52.5, ["Neon|Fly"] = 144.38, ["Neon|Ride"] = 128.62, ["Neon|Fly|Ride"] = 137.82, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 203.43}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 28.85, ["Fly"] = 100.38, ["Ride"] = 130.2, ["Fly|Ride"] = 285.11, ["Neon"] = 183.75, ["Neon|Ride"] = 276.54, ["Neon|Fly|Ride"] = 355.91, ["Mega"] = 866.25, ["Mega|Fly|Ride"] = 678.57}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 284.83, ["Ride"] = 267.87, ["Fly|Ride"] = 434.37, ["Neon|Fly|Ride"] = 28468.07}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 56.43, ["Fly"] = 213.59, ["Ride"] = 87.3, ["Fly|Ride"] = 185.8, ["Neon"] = 275.63, ["Neon|Ride"] = 342.26, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 986.23, ["Mega|Ride"] = 984.38, ["Mega|Fly|Ride"] = 1258.65}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 1312.5, ["Fly"] = 1381.74, ["Ride"] = 1023.74, ["Fly|Ride"] = 1010.62, ["Neon|Fly"] = 4377.68, ["Neon|Ride"] = 4128.18, ["Neon|Fly|Ride"] = 3281.25, ["Mega"] = 21715.66, ["Mega|Fly|Ride"] = 13125}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 337.84, ["Fly"] = 712.23, ["Ride"] = 328.13, ["Fly|Ride"] = 470.3, ["Neon"] = 2388.75, ["Neon|Ride"] = 3132.55, ["Neon|Fly|Ride"] = 1930.29, ["Mega"] = 12225.93, ["Mega|Fly|Ride"] = 9448.69}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 54.51}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 3.71}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 10.49, ["Fly"] = 31.29, ["Ride"] = 23.55, ["Fly|Ride"] = 65.63, ["Neon"] = 78.75, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 81.46, ["Neon|Fly|Ride"] = 137.75, ["Mega"] = 437.26, ["Mega|Ride"] = 712.06, ["Mega|Fly|Ride"] = 562.61}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 249.3, ["Fly"] = 409.24, ["Ride"] = 280.74, ["Fly|Ride"] = 367.49, ["Neon"] = 2413.07, ["Neon|Ride"] = 954.19, ["Neon|Fly|Ride"] = 1703.81, ["Mega|Fly|Ride"] = 2991.77}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 13.95}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 118.12, ["Ride"] = 171.94, ["Fly|Ride"] = 287.44, ["Neon"] = 647.1, ["Neon|Fly"] = 610.32, ["Neon|Ride"] = 551.25, ["Neon|Fly|Ride"] = 656.24, ["Mega"] = 2347.53, ["Mega|Ride"] = 2231.25, ["Mega|Fly|Ride"] = 2220.88}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 112.2, ["Fly"] = 213.59, ["Ride"] = 131.93, ["Fly|Ride"] = 143.1, ["Neon"] = 498.67, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 854.05, ["Mega|Fly|Ride"] = 3084.38}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 4.72, ["Ride"] = 23.63, ["Fly|Ride"] = 52.5, ["Neon"] = 41.14, ["Neon|Ride"] = 69.62, ["Neon|Fly|Ride"] = 251.95, ["Mega"] = 189.32, ["Mega|Ride"] = 189.95, ["Mega|Fly|Ride"] = 371.53}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 14.44, ["Fly"] = 71.55, ["Ride"] = 30.18, ["Fly|Ride"] = 78.75, ["Neon"] = 177.19, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 322.13, ["Mega|Ride"] = 1424.11, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 11.8, ["Fly"] = 102.36, ["Ride"] = 34.06, ["Fly|Ride"] = 127.89, ["Neon"] = 100.2, ["Neon|Ride"] = 101.06, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 425.97, ["Mega|Ride"] = 519.75, ["Mega|Fly|Ride"] = 427.03}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 4.82, ["Fly"] = 104.99, ["Ride"] = 49.79, ["Fly|Ride"] = 149.63, ["Neon"] = 31.07, ["Neon|Ride"] = 71.55, ["Neon|Fly|Ride"] = 185.81, ["Mega"] = 157.38, ["Mega|Fly"] = 273.87, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 295.32}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 255.49, ["Ride"] = 262.5, ["Fly|Ride"] = 352.38, ["Neon"] = 1601.71, ["Neon|Ride"] = 1050, ["Neon|Fly|Ride"] = 1381.75, ["Mega|Fly|Ride"] = 5691.07}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 95.82, ["Fly"] = 570.22, ["Ride"] = 148.32, ["Fly|Ride"] = 236.25, ["Neon"] = 424.89, ["Neon|Ride"] = 485.63, ["Neon|Fly|Ride"] = 525, ["Mega|Fly|Ride"] = 1994.19}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 62.9, ["Fly"] = 94.5, ["Ride"] = 78.74, ["Fly|Ride"] = 118.13, ["Neon"] = 262.5, ["Neon|Ride"] = 331.05, ["Neon|Fly|Ride"] = 416.07, ["Mega"] = 1424.11, ["Mega|Ride"] = 1769.84, ["Mega|Fly|Ride"] = 1372.88}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 19.67, ["Fly"] = 126, ["Ride"] = 36.32, ["Fly|Ride"] = 285.11, ["Neon"] = 170.86, ["Neon|Ride"] = 613.15, ["Neon|Fly|Ride"] = 498.57, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 12.46, ["Fly"] = 77.18, ["Ride"] = 30.07, ["Fly|Ride"] = 91.88, ["Neon"] = 77.44, ["Neon|Fly"] = 143.09, ["Neon|Ride"] = 121.71, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 384.34, ["Mega|Fly"] = 525, ["Mega|Ride"] = 482.58, ["Mega|Fly|Ride"] = 590.61}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.76, ["Fly"] = 36.75, ["Ride"] = 21.41, ["Fly|Ride"] = 45.94, ["Neon"] = 21, ["Neon|Fly"] = 76.94, ["Neon|Ride"] = 45.93, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 166.67, ["Mega|Ride"] = 170.52, ["Mega|Fly|Ride"] = 263.82}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 879.37, ["Fly"] = 918.75, ["Ride"] = 853.13, ["Fly|Ride"] = 971.25, ["Neon"] = 4271.19, ["Neon|Ride"] = 2989.48, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 8098.23}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 262.49, ["Fly"] = 399.36, ["Ride"] = 288.65, ["Fly|Ride"] = 433.13, ["Neon|Ride"] = 1270.5, ["Neon|Fly|Ride"] = 1246.88, ["Mega"] = 10675.4, ["Mega|Fly|Ride"] = 4462.5}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 91.87, ["Fly"] = 149.51, ["Ride"] = 119.44, ["Fly|Ride"] = 176.56, ["Neon"] = 420, ["Neon|Fly"] = 482.81, ["Neon|Ride"] = 384.13, ["Neon|Fly|Ride"] = 444.11, ["Mega|Ride"] = 1723.02, ["Mega|Fly|Ride"] = 1694.2}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 168, ["Fly"] = 283.5, ["Ride"] = 184.94, ["Fly|Ride"] = 206.3, ["Neon|Ride"] = 971.25, ["Neon|Fly|Ride"] = 917.44, ["Mega"] = 10675.4, ["Mega|Fly|Ride"] = 3987.27}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 24.4, ["Fly"] = 42.73, ["Ride"] = 28.65, ["Fly|Ride"] = 86.63, ["Neon"] = 169.31, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 204.75, ["Mega|Ride"] = 712.06, ["Mega|Fly|Ride"] = 938.38}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 236.24, ["Ride"] = 261.02, ["Fly|Ride"] = 358.32, ["Neon"] = 846.11, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 1050, ["Mega"] = 4249.11, ["Mega|Fly|Ride"] = 3836.75}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 76.13, ["Fly"] = 125.99, ["Ride"] = 80.07, ["Fly|Ride"] = 127.32, ["Neon|Ride"] = 570.08, ["Mega|Fly|Ride"] = 1417.5}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 2724.21, ["Ride"] = 2453.24, ["Fly|Ride"] = 2362.5, ["Neon|Ride"] = 8541.35, ["Neon|Fly|Ride"] = 5630.4, ["Mega"] = 51241.86, ["Mega|Fly|Ride"] = 26304.16}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 11.21, ["Fly"] = 78.04, ["Ride"] = 31.11, ["Fly|Ride"] = 77.84, ["Neon"] = 55.13, ["Neon|Fly"] = 157.49, ["Neon|Ride"] = 74.64, ["Neon|Fly|Ride"] = 164.06, ["Mega"] = 274.32, ["Mega|Fly"] = 570.08, ["Mega|Ride"] = 318.03, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 59.68, ["Ride"] = 58.97, ["Fly|Ride"] = 161.69, ["Neon"] = 196.88, ["Neon|Ride"] = 256.26, ["Neon|Fly|Ride"] = 484.67, ["Mega|Ride"] = 931.88, ["Mega|Fly|Ride"] = 1365}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 70.49, ["Fly"] = 91.87, ["Ride"] = 82.43, ["Fly|Ride"] = 87.68, ["Neon"] = 525, ["Neon|Ride"] = 640.61, ["Neon|Fly|Ride"] = 410.79, ["Mega|Fly|Ride"] = 1879.84}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 2203.69, ["Fly"] = 1609.56, ["Ride"] = 1069.69, ["Fly|Ride"] = 931.88, ["Neon|Ride"] = 5147.84, ["Neon|Fly|Ride"] = 4270.17, ["Mega"] = 34873.3, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 525, ["Fly"] = 852.12, ["Ride"] = 567.09, ["Fly|Ride"] = 534.19, ["Mega|Fly|Ride"] = 11387.44}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 64.32, ["Fly"] = 322.17, ["Ride"] = 85.33, ["Fly|Ride"] = 208.69, ["Neon"] = 446.71, ["Neon|Ride"] = 342.55, ["Neon|Fly|Ride"] = 563.41, ["Mega"] = 1994.19, ["Mega|Ride"] = 2574.53, ["Mega|Fly|Ride"] = 1619.1}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 5.23, ["Fly"] = 32.82, ["Ride"] = 19.69, ["Fly|Ride"] = 72.19, ["Neon"] = 75, ["Neon|Ride"] = 84.25, ["Neon|Fly|Ride"] = 161.27, ["Mega"] = 553.88, ["Mega|Ride"] = 776.12}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 35, ["Fly"] = 68.25, ["Ride"] = 42.73, ["Fly|Ride"] = 56.44, ["Neon"] = 284.82, ["Neon|Fly"] = 356.62, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 341.62, ["Mega|Ride"] = 1187.82, ["Mega|Fly|Ride"] = 1049.99}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 745.5, ["Fly"] = 1110.04, ["Ride"] = 745.63, ["Fly|Ride"] = 860.99, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2231.25, ["Mega|Fly|Ride"] = 9723}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 591.62}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 6973.87, ["Ride"] = 6122.74, ["Fly|Ride"] = 5775, ["Neon"] = 42000, ["Neon|Ride"] = 30596.74, ["Neon|Fly|Ride"] = 18375, ["Mega|Fly|Ride"] = 106611.9}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 255.81, ["Fly"] = 400.44, ["Ride"] = 285.11, ["Fly|Ride"] = 413.25, ["Neon"] = 1312.5, ["Neon|Ride"] = 1851.13, ["Neon|Fly|Ride"] = 1706.25, ["Mega"] = 6405.25, ["Mega|Ride"] = 6119.15, ["Mega|Fly|Ride"] = 6121.28}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 91.84, ["Fly"] = 285.11, ["Ride"] = 131.25, ["Fly|Ride"] = 336, ["Neon"] = 1119.06, ["Neon|Ride"] = 997.11, ["Neon|Fly|Ride"] = 640.54}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 16.96, ["Fly"] = 100.38, ["Ride"] = 32.69, ["Fly|Ride"] = 91.75, ["Neon"] = 131.91, ["Neon|Ride"] = 127.33, ["Neon|Fly|Ride"] = 241.31, ["Mega"] = 712.06, ["Mega|Ride"] = 854.05, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 11.82, ["Fly"] = 26.24, ["Ride"] = 27.19, ["Fly|Ride"] = 43.32, ["Neon|Ride"] = 114.26, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 1312.5, ["Mega|Ride"] = 380.63, ["Mega|Fly|Ride"] = 2135.09}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 16.26, ["Fly"] = 163.47, ["Ride"] = 31.5, ["Fly|Ride"] = 103.04, ["Neon"] = 124.67, ["Neon|Ride"] = 108.71, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 645.75, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 619.19}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 3.77, ["Fly"] = 63.02, ["Ride"] = 21.37, ["Fly|Ride"] = 48.57, ["Neon"] = 31.39, ["Neon|Ride"] = 56.72, ["Neon|Fly|Ride"] = 125.98, ["Mega"] = 661.56, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 204.23}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 27.68, ["Fly"] = 90.57, ["Ride"] = 45.94, ["Fly|Ride"] = 143.1, ["Neon"] = 156.58, ["Neon|Fly"] = 854.15, ["Neon|Ride"] = 230.63, ["Neon|Fly|Ride"] = 339.5, ["Mega"] = 630, ["Mega|Ride"] = 1260}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 498.95, ["Fly"] = 538.13, ["Ride"] = 524.9, ["Fly|Ride"] = 571.73, ["Neon"] = 1922.05, ["Neon|Ride"] = 1566.1, ["Neon|Fly|Ride"] = 1443.75, ["Mega"] = 7875, ["Mega|Fly|Ride"] = 5833.05}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.1, ["Fly"] = 19.58, ["Ride"] = 15.49, ["Fly|Ride"] = 32.82, ["Neon"] = 31.5, ["Neon|Ride"] = 32.1, ["Neon|Fly|Ride"] = 78.37, ["Mega"] = 170.63, ["Mega|Ride"] = 226.33, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 49.87, ["Fly"] = 114.19, ["Ride"] = 77.44, ["Fly|Ride"] = 124.69, ["Neon"] = 226.35, ["Neon|Fly"] = 285.09, ["Neon|Ride"] = 194.88, ["Neon|Fly|Ride"] = 261.18, ["Mega"] = 557.82, ["Mega|Fly"] = 854.05, ["Mega|Ride"] = 557.81, ["Mega|Fly|Ride"] = 615.56}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 761.25, ["Ride"] = 734.99, ["Fly|Ride"] = 807.19, ["Neon|Ride"] = 2135.09, ["Neon|Fly|Ride"] = 1568.44, ["Mega|Fly|Ride"] = 4265.63}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 28.97, ["Fly"] = 66.98, ["Ride"] = 50.21, ["Fly|Ride"] = 80.66, ["Neon"] = 262.5, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 249.37, ["Mega"] = 1575, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 315, ["Ride"] = 257.27, ["Fly|Ride"] = 337.32, ["Neon|Ride"] = 1566.28, ["Neon|Fly|Ride"] = 1851.13, ["Mega|Fly|Ride"] = 3701.18}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 242.82, ["Fly"] = 262.48, ["Ride"] = 244.88, ["Fly|Ride"] = 259.88, ["Neon|Ride"] = 892.5, ["Neon|Fly|Ride"] = 918.75, ["Mega"] = 4265.9, ["Mega|Fly|Ride"] = 3773.76}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 912.98, ["Ride"] = 804.78, ["Fly|Ride"] = 1025.09, ["Neon|Ride"] = 3795.44, ["Neon|Fly|Ride"] = 2953.9, ["Mega|Fly|Ride"] = 9711.19}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 16.14, ["Fly"] = 61.94, ["Ride"] = 46.36, ["Fly|Ride"] = 119.46, ["Neon"] = 78.75, ["Neon|Fly"] = 289.69, ["Neon|Ride"] = 91.77, ["Neon|Fly|Ride"] = 160.15, ["Mega"] = 354.38, ["Mega|Ride"] = 356.79, ["Mega|Fly|Ride"] = 644.24}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 4084.49, ["Fly"] = 3438.49, ["Ride"] = 3281.25, ["Fly|Ride"] = 3346.87, ["Neon|Fly|Ride"] = 7350, ["Mega|Fly|Ride"] = 18892.13}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 120.75, ["Fly"] = 170.86, ["Ride"] = 142.91, ["Fly|Ride"] = 205.96, ["Neon"] = 498.75, ["Neon|Fly"] = 712.69, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 577.5, ["Mega|Ride"] = 2989.12, ["Mega|Fly|Ride"] = 3141.78}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.62, ["Fly"] = 28.75, ["Ride"] = 18.48, ["Fly|Ride"] = 50.96, ["Neon"] = 24.25, ["Neon|Fly"] = 65.62, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 102.92, ["Mega"] = 160.1, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 245.75, ["Mega|Fly|Ride"] = 235.94}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.29, ["Ride"] = 26.25, ["Fly|Ride"] = 65.62, ["Neon"] = 21, ["Neon|Fly"] = 118.3, ["Neon|Ride"] = 64.29, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 170.81, ["Mega|Ride"] = 223.12, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 37.42, ["Fly"] = 76.9, ["Ride"] = 42.87, ["Fly|Ride"] = 56.35, ["Neon"] = 289.58, ["Neon|Ride"] = 313.68, ["Neon|Fly|Ride"] = 253.8, ["Mega|Fly|Ride"] = 1125.21}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 836.1, ["Fly"] = 1254.83, ["Ride"] = 1035.57, ["Fly|Ride"] = 1038.18, ["Neon|Ride"] = 2895.44, ["Neon|Fly|Ride"] = 4825.71}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 6549.86, ["Fly|Ride"] = 6823.69}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 19.15, ["Fly"] = 39.38, ["Ride"] = 25.51, ["Fly|Ride"] = 47.25, ["Neon"] = 452.13, ["Neon|Ride"] = 139.13, ["Neon|Fly|Ride"] = 143.07, ["Mega"] = 2520, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 11.82, ["Fly"] = 43.32, ["Ride"] = 30.19, ["Fly|Ride"] = 65.63, ["Neon"] = 71.55, ["Neon|Ride"] = 86.47, ["Neon|Fly|Ride"] = 169.32, ["Mega"] = 662.17, ["Mega|Ride"] = 479.07, ["Mega|Fly|Ride"] = 501.38}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 71.55, ["Fly"] = 157.5, ["Ride"] = 92.86, ["Fly|Ride"] = 114.2, ["Neon|Ride"] = 448.28, ["Neon|Fly|Ride"] = 498.81, ["Mega|Fly|Ride"] = 1984.57}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 212.15, ["Fly"] = 241.5, ["Ride"] = 221.81, ["Fly|Ride"] = 328.13, ["Neon"] = 1286.25, ["Neon|Ride"] = 1182.93, ["Neon|Fly|Ride"] = 1018.7, ["Mega"] = 10675.4, ["Mega|Fly"] = 4023.45, ["Mega|Fly|Ride"] = 4506.02}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 6.4, ["Ride"] = 38.07, ["Fly|Ride"] = 93.19, ["Neon"] = 20.57, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 46.47, ["Mega"] = 160.13, ["Mega|Fly"] = 238.08, ["Mega|Ride"] = 191.63, ["Mega|Fly|Ride"] = 229.69}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 177.45, ["Fly"] = 231.71, ["Ride"] = 206.07, ["Fly|Ride"] = 259.87, ["Neon"] = 656.25, ["Neon|Ride"] = 715.32, ["Neon|Fly|Ride"] = 787.5, ["Mega|Fly|Ride"] = 2779.88}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 3.84, ["Fly"] = 25.65, ["Ride"] = 15.75, ["Fly|Ride"] = 56.73, ["Neon"] = 24.94, ["Neon|Fly"] = 71.55, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 108.94, ["Mega"] = 225.75, ["Mega|Ride"] = 219.19, ["Mega|Fly|Ride"] = 285.05}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 188.41, ["Fly"] = 348.12, ["Ride"] = 207.9, ["Fly|Ride"] = 259.85, ["Neon|Ride"] = 1327.68, ["Neon|Fly|Ride"] = 1115.63, ["Mega"] = 10675.4, ["Mega|Fly|Ride"] = 3987.27}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 9.9, ["Fly"] = 77.44, ["Ride"] = 28.28, ["Fly|Ride"] = 68.25, ["Neon"] = 73.5, ["Neon|Fly"] = 306.58, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 155.93, ["Mega"] = 570.08, ["Mega|Ride"] = 555.13, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 3.94, ["Ride"] = 26.17, ["Fly|Ride"] = 51.19, ["Neon"] = 6.02, ["Neon|Fly"] = 170.46, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 195.57, ["Mega"] = 85.98, ["Mega|Ride"] = 131.15, ["Mega|Fly|Ride"] = 322.41}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Mega"] = 20.27, ["Mega|Ride"] = 143.07, ["Mega|Fly|Ride"] = 161.68}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 4.26, ["Ride"] = 30.9, ["Fly|Ride"] = 85.53, ["Neon"] = 6.39, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 126, ["Mega"] = 84.62, ["Mega|Fly"] = 160857.54, ["Mega|Ride"] = 84.45, ["Mega|Fly|Ride"] = 213.52}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 64.32, ["Fly"] = 166.32, ["Ride"] = 101.07, ["Fly|Ride"] = 164.07, ["Neon"] = 339.94, ["Neon|Ride"] = 294, ["Neon|Fly|Ride"] = 389.82, ["Mega|Fly|Ride"] = 1537.27}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 37.42, ["Ride"] = 16.96, ["Fly|Ride"] = 83.3, ["Neon"] = 10.49, ["Neon|Fly"] = 71.55, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 52.4, ["Mega"] = 91.77, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 262.47}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 10.56, ["Neon"] = 82.26, ["Neon|Fly"] = 289.69, ["Neon|Ride"] = 212.63, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 261.19, ["Mega|Ride"] = 541.26, ["Mega|Fly|Ride"] = 604.24}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Ride"] = 17.84, ["Neon"] = 3.15, ["Neon|Ride"] = 55.25, ["Mega"] = 16.96, ["Mega|Ride"] = 90.04, ["Mega|Fly|Ride"] = 196.56}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 71.3, ["Ride"] = 15.65, ["Fly|Ride"] = 48.82, ["Neon"] = 2.1, ["Neon|Fly"] = 37.09, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 32.82, ["Mega"] = 12.46, ["Mega|Fly"] = 34.72, ["Mega|Ride"] = 24.94, ["Mega|Fly|Ride"] = 59.25}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 13.61, ["Fly|Ride"] = 80.1, ["Neon"] = 3.75, ["Neon|Fly"] = 21, ["Neon|Ride"] = 15.6, ["Neon|Fly|Ride"] = 52.41, ["Mega"] = 24.14, ["Mega|Fly"] = 161.68, ["Mega|Ride"] = 48.27, ["Mega|Fly|Ride"] = 86.63}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 36.75, ["Mega"] = 19.59, ["Mega|Ride"] = 105}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 91.88, ["Ride"] = 21, ["Fly|Ride"] = 107.62, ["Neon"] = 6.19, ["Neon|Fly"] = 121.72, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 86.46, ["Mega"] = 35.56, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 38.19, ["Mega|Fly|Ride"] = 101.07}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 2.62, ["Neon|Ride"] = 82.09, ["Neon|Fly|Ride"] = 427.03, ["Mega"] = 20.9, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 69.57, ["Mega|Fly|Ride"] = 144.37}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 4.29, ["Fly"] = 77.44, ["Ride"] = 36.75, ["Fly|Ride"] = 158.05, ["Neon"] = 29.98, ["Neon|Fly"] = 118.54, ["Neon|Ride"] = 52.41, ["Neon|Fly|Ride"] = 105, ["Mega"] = 144.38, ["Mega|Fly"] = 283.53, ["Mega|Ride"] = 161.44, ["Mega|Fly|Ride"] = 271.59}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 28.85, ["Neon"] = 2.1, ["Neon|Ride"] = 42.72, ["Neon|Fly|Ride"] = 322.13, ["Mega"] = 12.83, ["Mega|Fly"] = 144.27, ["Mega|Ride"] = 76.31, ["Mega|Fly|Ride"] = 196.77}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 144.17, ["Fly|Ride"] = 143.1, ["Neon"] = 18.37, ["Mega"] = 120.63, ["Mega|Fly"] = 315, ["Mega|Ride"] = 274.31, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Ride"] = 26.24, ["Neon"] = 13.13, ["Neon|Ride"] = 71.55, ["Mega"] = 119.79, ["Mega|Ride"] = 158.01}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 3.93, ["Neon|Ride"] = 27.77, ["Neon|Fly|Ride"] = 143.07, ["Mega"] = 21.06, ["Mega|Ride"] = 44.63, ["Mega|Fly|Ride"] = 98.01}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.28, ["Ride"] = 14.34, ["Fly|Ride"] = 32.82, ["Neon"] = 2.1, ["Neon|Fly"] = 28.97, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 37.68, ["Mega"] = 11.81, ["Mega|Fly"] = 32.81, ["Mega|Ride"] = 20.64, ["Mega|Fly|Ride"] = 49.88}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.1, ["Fly"] = 72.19, ["Ride"] = 54.28, ["Fly|Ride"] = 118.11, ["Neon"] = 36.75, ["Neon|Ride"] = 71.54, ["Mega"] = 202.73, ["Mega|Ride"] = 192.18}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 32.37, ["Neon"] = 3.29, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 25.81, ["Mega|Ride"] = 55.53, ["Mega|Fly|Ride"] = 115.49}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 4.34, ["Neon"] = 17.07, ["Mega"] = 85.32, ["Mega|Ride"] = 161.21, ["Mega|Fly|Ride"] = 213.52}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.1, ["Fly"] = 78.93, ["Ride"] = 19.69, ["Neon"] = 14.19, ["Neon|Fly"] = 32.04, ["Neon|Ride"] = 42.72, ["Neon|Fly|Ride"] = 105, ["Mega"] = 124.69, ["Mega|Ride"] = 163.41, ["Mega|Fly|Ride"] = 193.04}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 14.34, ["Ride"] = 15.65, ["Fly|Ride"] = 31.49, ["Neon"] = 2.1, ["Neon|Fly"] = 15.65, ["Neon|Ride"] = 14.26, ["Neon|Fly|Ride"] = 32.13, ["Mega"] = 15.28, ["Mega|Fly"] = 28.17, ["Mega|Ride"] = 18.09, ["Mega|Fly|Ride"] = 52.5}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 28.85, ["Ride"] = 27.42, ["Fly|Ride"] = 143.1, ["Neon"] = 12.96, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 196.47, ["Mega"] = 129.65, ["Mega|Ride"] = 161.68, ["Mega|Fly|Ride"] = 161.68}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 3.91, ["Fly"] = 114.28, ["Ride"] = 114.28, ["Fly|Ride"] = 59.07, ["Neon"] = 49.87, ["Neon|Ride"] = 69.57, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 254.68, ["Mega|Ride"] = 297.51, ["Mega|Fly|Ride"] = 327.48}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 14.44, ["Fly|Ride"] = 39.29, ["Neon"] = 2.1, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 14.43, ["Neon|Fly|Ride"] = 32.19, ["Mega"] = 20.25, ["Mega|Ride"] = 31.5, ["Mega|Fly|Ride"] = 85.35}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.1, ["Fly"] = 178.34, ["Ride"] = 45.9, ["Neon"] = 13.13, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 129.1, ["Mega"] = 76.88, ["Mega|Fly"] = 170.82, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 213.52}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 35.44, ["Neon"] = 3.93, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 285.05, ["Mega"] = 27.56, ["Mega|Fly"] = 64.07, ["Mega|Ride"] = 63, ["Mega|Fly|Ride"] = 341.62}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 32.59, ["Ride"] = 21, ["Neon"] = 2.1, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 285.05, ["Mega"] = 12.89, ["Mega|Fly"] = 253.82, ["Mega|Ride"] = 42.56, ["Mega|Fly|Ride"] = 156.18}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 71.55, ["Ride"] = 15.75, ["Fly|Ride"] = 46.57, ["Neon"] = 8.33, ["Neon|Fly"] = 54.42, ["Neon|Ride"] = 34.36, ["Neon|Fly|Ride"] = 71.54, ["Mega"] = 71.31, ["Mega|Ride"] = 73.5, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 22.59, ["Neon"] = 5.91, ["Neon|Ride"] = 68.25, ["Mega"] = 44.24, ["Mega|Fly"] = 322.13, ["Mega|Ride"] = 103.69, ["Mega|Fly|Ride"] = 249.37}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 15.74, ["Fly|Ride"] = 57.68, ["Neon"] = 6.57, ["Neon|Fly"] = 80.89, ["Neon|Ride"] = 25.74, ["Neon|Fly|Ride"] = 57.67, ["Mega"] = 111.57, ["Mega|Fly"] = 114.6, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 97.13}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 2.1, ["Ride"] = 37.03, ["Neon"] = 31.39, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 320.28, ["Mega"] = 105, ["Mega|Fly"] = 367.5, ["Mega|Ride"] = 210}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Fly"] = 25.77, ["Ride"] = 18.35, ["Fly|Ride"] = 46.99, ["Neon"] = 10.54, ["Neon|Fly"] = 48.2, ["Neon|Ride"] = 32.12, ["Neon|Fly|Ride"] = 89.3, ["Mega"] = 236.25, ["Mega|Fly"] = 420, ["Mega|Ride"] = 121.71, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 18.3, ["Fly|Ride"] = 120.66, ["Neon"] = 14.44, ["Neon|Fly"] = 67.28, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 106.77, ["Mega"] = 213.52, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 131.06, ["Mega|Fly|Ride"] = 177.19}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 113.21, ["Neon"] = 8.54, ["Neon|Fly|Ride"] = 2625, ["Mega"] = 247.67, ["Mega|Ride"] = 310.68}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 7.32, ["Ride"] = 56.44, ["Neon"] = 202.11, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 794.07, ["Mega"] = 638.4, ["Mega|Ride"] = 728.44, ["Mega|Fly|Ride"] = 644.24}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 2.1, ["Ride"] = 42.73, ["Neon"] = 40.69, ["Neon|Ride"] = 106.77, ["Mega"] = 238.88, ["Mega|Ride"] = 361.6}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 3.6, ["Ride"] = 37.58, ["Fly|Ride"] = 120.75, ["Neon"] = 47.78, ["Neon|Ride"] = 31.19, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 377.92, ["Mega|Ride"] = 413.16, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Ride"] = 28.85, ["Neon"] = 2.6, ["Neon|Ride"] = 65.02, ["Mega"] = 16.96, ["Mega|Fly"] = 122.79, ["Mega|Ride"] = 63, ["Mega|Fly|Ride"] = 232.75}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 49.03}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 6.41, ["Fly"] = 23.63, ["Ride"] = 20.99, ["Fly|Ride"] = 47.59, ["Neon"] = 44.63, ["Neon|Fly"] = 189, ["Neon|Ride"] = 49.67, ["Neon|Fly|Ride"] = 96.07, ["Mega"] = 272.24, ["Mega|Ride"] = 208.69, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.79, ["Ride"] = 19.15, ["Fly|Ride"] = 85.32, ["Neon"] = 2.1, ["Neon|Fly"] = 52.8, ["Neon|Ride"] = 20.99, ["Neon|Fly|Ride"] = 105, ["Mega"] = 24.18, ["Mega|Ride"] = 57.67, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 25.65, ["Neon"] = 6.42, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 72.18, ["Mega"] = 32.89, ["Mega|Fly"] = 92.89, ["Mega|Ride"] = 55.13, ["Mega|Fly|Ride"] = 115.96}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 44.71, ["Ride"] = 16.04, ["Fly|Ride"] = 32.59, ["Neon"] = 9.19, ["Neon|Ride"] = 29.89, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 106.77, ["Mega|Ride"] = 106.77, ["Mega|Fly|Ride"] = 169.24}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 2.5, ["Fly"] = 42.73, ["Ride"] = 31.5, ["Fly|Ride"] = 69.57, ["Neon"] = 47.72, ["Neon|Ride"] = 208.13, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 161.44, ["Mega|Ride"] = 365.11, ["Mega|Fly|Ride"] = 320.28}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Ride"] = 34.12, ["Neon"] = 2.62, ["Neon|Ride"] = 39.9, ["Mega"] = 21.95, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 51, ["Mega|Fly|Ride"] = 341.62}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 27.57, ["Ride"] = 17.07, ["Fly|Ride"] = 36.32, ["Neon"] = 3.94, ["Neon|Fly"] = 113.13, ["Neon|Ride"] = 19.68, ["Neon|Fly|Ride"] = 96.52, ["Mega"] = 28.81, ["Mega|Fly"] = 143.07, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 113.17}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 28.66, ["Ride"] = 18.18, ["Fly|Ride"] = 42.7, ["Neon"] = 4.92, ["Neon|Fly"] = 52.58, ["Neon|Ride"] = 16.99, ["Neon|Fly|Ride"] = 61.11, ["Mega"] = 71.54, ["Mega|Fly"] = 143.07, ["Mega|Ride"] = 85.41, ["Mega|Fly|Ride"] = 72.19}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 3.22, ["Fly"] = 91.88, ["Ride"] = 41.52, ["Fly|Ride"] = 143.1, ["Neon"] = 8.88, ["Neon|Ride"] = 52.41, ["Neon|Fly|Ride"] = 106.76, ["Mega"] = 72.64, ["Mega|Ride"] = 109.88, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 106.78, ["Neon|Fly|Ride"] = 155386.39, ["Mega"] = 17.05, ["Mega|Fly"] = 113.17, ["Mega|Ride"] = 51.77, ["Mega|Fly|Ride"] = 136.49}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 45.9, ["Ride"] = 19.67, ["Fly|Ride"] = 32.82, ["Neon"] = 3.94, ["Neon|Fly"] = 27.77, ["Neon|Ride"] = 25.64, ["Neon|Fly|Ride"] = 96.09, ["Mega"] = 19.35, ["Mega|Fly"] = 64.07, ["Mega|Ride"] = 38.13, ["Mega|Fly|Ride"] = 78.66}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Ride"] = 19.49, ["Neon"] = 3.15, ["Neon|Fly|Ride"] = 114.23, ["Mega"] = 19.59, ["Mega|Ride"] = 427.03}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 6.11, ["Neon|Fly|Ride"] = 420, ["Mega"] = 35.44, ["Mega|Ride"] = 196.45, ["Mega|Fly|Ride"] = 151.61}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 15.99, ["Fly|Ride"] = 47.25, ["Neon"] = 6.57, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 16.82, ["Neon|Fly|Ride"] = 21.37, ["Mega"] = 36.75, ["Mega|Fly|Ride"] = 107.57}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 19.69, ["Ride"] = 78.74, ["Fly|Ride"] = 213.59, ["Neon"] = 111.6, ["Neon|Ride"] = 156.5, ["Mega"] = 389.81, ["Mega|Ride"] = 669.38, ["Mega|Fly|Ride"] = 683.24}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.1, ["Fly"] = 6562.5, ["Ride"] = 26.23, ["Neon"] = 39.38, ["Neon|Ride"] = 39.38, ["Mega"] = 183.75, ["Mega|Fly|Ride"] = 570.08}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 2.1, ["Ride"] = 32.04, ["Fly|Ride"] = 175.13, ["Neon"] = 21, ["Neon|Ride"] = 71.55, ["Mega"] = 313.69, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 15.65, ["Ride"] = 12.5, ["Fly|Ride"] = 27.75, ["Neon"] = 2.1, ["Neon|Fly"] = 18.27, ["Neon|Ride"] = 11.75, ["Neon|Fly|Ride"] = 28.87, ["Mega"] = 12.92, ["Mega|Fly"] = 104.98, ["Mega|Ride"] = 19.66, ["Mega|Fly|Ride"] = 58.75}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Fly"] = 118.12, ["Ride"] = 59.81, ["Neon"] = 6.04, ["Neon|Fly"] = 68.34, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 712.06, ["Mega"] = 85.32, ["Mega|Ride"] = 143.07}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Fly"] = 71.55, ["Ride"] = 26.25, ["Neon"] = 2.1, ["Neon|Fly"] = 32.04, ["Neon|Ride"] = 22.21, ["Neon|Fly|Ride"] = 86.67, ["Mega"] = 13, ["Mega|Fly"] = 64.07, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 3.29, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 127.32, ["Mega"] = 21, ["Mega|Fly"] = 213.52, ["Mega|Ride"] = 53.1, ["Mega|Fly|Ride"] = 367.49}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 126.29, ["Ride"] = 18.38, ["Fly|Ride"] = 56.67, ["Neon"] = 9.66, ["Neon|Fly"] = 71.23, ["Neon|Ride"] = 42.71, ["Neon|Fly|Ride"] = 71.54, ["Mega"] = 170.62, ["Mega|Fly"] = 199.64, ["Mega|Ride"] = 160.13, ["Mega|Fly|Ride"] = 294}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 158.71, ["Ride"] = 224.32, ["Fly|Ride"] = 413.25, ["Neon|Fly|Ride"] = 982.15, ["Mega"] = 8540.32, ["Mega|Fly|Ride"] = 4023.45}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Ride"] = 24.57, ["Neon"] = 5.25, ["Neon|Ride"] = 64.31, ["Mega"] = 68.16, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 2.63, ["Fly"] = 103.68, ["Ride"] = 24.69, ["Fly|Ride"] = 64.32, ["Neon"] = 32.49, ["Neon|Ride"] = 170.85, ["Neon|Fly|Ride"] = 143.07, ["Mega"] = 381.89, ["Mega|Ride"] = 225.62, ["Mega|Fly|Ride"] = 213.52}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 15.94, ["Ride"] = 15.73, ["Fly|Ride"] = 32.82, ["Neon"] = 3.94, ["Neon|Fly"] = 33.12, ["Neon|Ride"] = 30.08, ["Neon|Fly|Ride"] = 48.41, ["Mega"] = 49.67, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 127.05}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 71.55, ["Ride"] = 19.69, ["Fly|Ride"] = 98.44, ["Neon"] = 10.69, ["Neon|Ride"] = 80.07, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 77.35, ["Mega|Ride"] = 193.04, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 16.32, ["Fly|Ride"] = 36.75, ["Neon"] = 28.01, ["Neon|Fly"] = 100.37, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 52.5, ["Mega|Ride"] = 285.05, ["Mega|Fly|Ride"] = 294}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 3.92, ["Ride"] = 34.32, ["Fly|Ride"] = 65.17, ["Neon"] = 48.57, ["Neon|Ride"] = 85.41, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 216.57, ["Mega|Ride"] = 427.35, ["Mega|Fly|Ride"] = 387.18}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 3.51, ["Fly"] = 19.69, ["Ride"] = 15.33, ["Fly|Ride"] = 42.73, ["Neon"] = 31.46, ["Neon|Fly"] = 71.55, ["Neon|Ride"] = 36.39, ["Neon|Fly|Ride"] = 79.97, ["Mega"] = 262.5, ["Mega|Ride"] = 370.44, ["Mega|Fly|Ride"] = 253.47}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 45.94, ["Fly"] = 161.69, ["Ride"] = 80.76, ["Fly|Ride"] = 149.1, ["Neon"] = 341.24, ["Neon|Fly"] = 450.19, ["Neon|Ride"] = 418.59, ["Neon|Fly|Ride"] = 378.19, ["Mega|Fly|Ride"] = 1468.59}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 239.19, ["Fly"] = 427.13, ["Ride"] = 249.24, ["Fly|Ride"] = 328.13, ["Neon|Ride"] = 1126.81, ["Neon|Fly|Ride"] = 1115.63, ["Mega"] = 10675.4, ["Mega|Fly|Ride"] = 4982.21}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 57.68, ["Fly"] = 57.68, ["Ride"] = 56.44, ["Fly|Ride"] = 85.44, ["Neon"] = 482.63, ["Neon|Ride"] = 290.34, ["Neon|Fly|Ride"] = 347.82, ["Mega|Fly|Ride"] = 1381.42}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 3.7, ["Fly"] = 288.09, ["Ride"] = 23.63, ["Fly|Ride"] = 73.5, ["Neon"] = 40.42, ["Neon|Ride"] = 99.75, ["Mega"] = 234.06, ["Mega|Ride"] = 196.75, ["Mega|Fly|Ride"] = 416.73}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 11.68, ["Fly"] = 71.55, ["Ride"] = 33.12, ["Fly|Ride"] = 64.22, ["Neon"] = 62.99, ["Neon|Ride"] = 87.56, ["Neon|Fly|Ride"] = 143.07, ["Mega"] = 482.58, ["Mega|Ride"] = 372.84, ["Mega|Fly|Ride"] = 446.45}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 15.74, ["Fly|Ride"] = 50.9, ["Neon"] = 3.05, ["Neon|Fly"] = 32.04, ["Neon|Ride"] = 20.9, ["Neon|Fly|Ride"] = 55.3, ["Mega"] = 33.11, ["Mega|Fly"] = 146.9, ["Mega|Ride"] = 213.52, ["Mega|Fly|Ride"] = 283.5}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 4.92, ["Fly"] = 39.38, ["Ride"] = 30.68, ["Fly|Ride"] = 59.81, ["Neon"] = 95.7, ["Neon|Fly"] = 285.09, ["Neon|Ride"] = 107.63, ["Neon|Fly|Ride"] = 249.57, ["Mega"] = 413.16, ["Mega|Ride"] = 482.58, ["Mega|Fly|Ride"] = 456.92}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 21.37, ["Ride"] = 15.75, ["Fly|Ride"] = 39.19, ["Neon"] = 13.8, ["Neon|Fly"] = 80.89, ["Neon|Ride"] = 27.77, ["Neon|Fly|Ride"] = 60.48, ["Mega"] = 118.13, ["Mega|Ride"] = 267.96, ["Mega|Fly|Ride"] = 257.24}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 2.1, ["Ride"] = 24.14, ["Fly|Ride"] = 328.13, ["Neon"] = 17.1, ["Neon|Ride"] = 36.3, ["Mega"] = 207.37, ["Mega|Ride"] = 216.57, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 27.68, ["Ride"] = 19.37, ["Neon"] = 2.1, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 57.74, ["Mega"] = 13.13, ["Mega|Fly"] = 31.5, ["Mega|Ride"] = 42.72, ["Mega|Fly|Ride"] = 78.73}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 19.59, ["Ride"] = 19.07, ["Fly|Ride"] = 42.73, ["Neon"] = 10.08, ["Neon|Fly"] = 106.78, ["Neon|Ride"] = 35.24, ["Neon|Fly|Ride"] = 147, ["Mega"] = 78.72, ["Mega|Fly|Ride"] = 226.42}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.1, ["Fly"] = 28.01, ["Ride"] = 18.52, ["Fly|Ride"] = 62.98, ["Neon"] = 19.69, ["Neon|Ride"] = 47.25, ["Mega"] = 131.23, ["Mega|Ride"] = 266.44, ["Mega|Fly|Ride"] = 264.76}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 111.56, ["Fly"] = 164.11, ["Ride"] = 161.58, ["Fly|Ride"] = 199.4, ["Neon"] = 489.57, ["Neon|Fly"] = 644.54, ["Neon|Ride"] = 446.25, ["Neon|Fly|Ride"] = 534.19, ["Mega"] = 4270.17, ["Mega|Fly|Ride"] = 2100}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 9.74, ["Ride"] = 128.02, ["Fly|Ride"] = 129.11, ["Neon"] = 40.69, ["Neon|Ride"] = 98.42, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 278.07, ["Mega|Ride"] = 284.82, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 32.59, ["Ride"] = 19.25, ["Fly|Ride"] = 36.75, ["Neon"] = 13.23, ["Neon|Ride"] = 32.53, ["Neon|Fly|Ride"] = 120.65, ["Mega"] = 246.75, ["Mega|Ride"] = 187.69, ["Mega|Fly|Ride"] = 199.5}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 20.11, ["Ride"] = 45.93, ["Fly|Ride"] = 151.19, ["Neon"] = 90.75, ["Neon|Ride"] = 143.09, ["Neon|Fly|Ride"] = 711, ["Mega"] = 712.06, ["Mega|Fly"] = 854.05, ["Mega|Ride"] = 692.5, ["Mega|Fly|Ride"] = 820.38}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 2.62}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 6.57, ["Ride"] = 28.85, ["Fly|Ride"] = 127.09, ["Neon"] = 33.14, ["Neon|Fly"] = 89.25, ["Neon|Ride"] = 160.16, ["Neon|Fly|Ride"] = 327.75, ["Mega"] = 840.16, ["Mega|Ride"] = 583.95, ["Mega|Fly|Ride"] = 885.53}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 27.57, ["Fly"] = 36.25, ["Ride"] = 32.25, ["Fly|Ride"] = 65.14, ["Neon"] = 401.5, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 177.08, ["Mega"] = 1378.21, ["Mega|Fly|Ride"] = 485.63}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 21, ["Fly|Ride"] = 52.38, ["Neon"] = 3.61, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 107.63, ["Mega"] = 31.17, ["Mega|Fly"] = 188.99, ["Mega|Ride"] = 77.86, ["Mega|Fly|Ride"] = 230.85}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 3.93, ["Fly"] = 32.55, ["Ride"] = 20.79, ["Fly|Ride"] = 65.54, ["Neon"] = 57.68, ["Neon|Ride"] = 64.07, ["Mega"] = 271.17, ["Mega|Fly"] = 402.96, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 566.88}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 21.37, ["Ride"] = 16.04, ["Fly|Ride"] = 48.45, ["Neon"] = 13.12, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 34.55, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 131.25, ["Mega|Ride"] = 213.52, ["Mega|Fly|Ride"] = 275.73}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 21.37, ["Neon"] = 3.28, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 40.85, ["Mega"] = 28.77, ["Mega|Ride"] = 70.47, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 26.16, ["Fly"] = 141.73, ["Ride"] = 85.39, ["Fly|Ride"] = 136.5, ["Neon"] = 180.54, ["Neon|Ride"] = 249.85, ["Neon|Fly|Ride"] = 525, ["Mega"] = 727.13, ["Mega|Ride"] = 689.06, ["Mega|Fly|Ride"] = 854.05}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 2.21, ["Ride"] = 47.25, ["Fly|Ride"] = 210, ["Neon"] = 96.46, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 322.13}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 2.1, ["Fly"] = 22.3, ["Ride"] = 19.59, ["Fly|Ride"] = 61.86, ["Neon"] = 25.91, ["Neon|Fly"] = 85.43, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 87.55, ["Mega"] = 196.23, ["Mega|Fly|Ride"] = 290.07}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 71.63, ["Fly"] = 433.13, ["Ride"] = 393.75, ["Fly|Ride"] = 262.5, ["Neon"] = 18316.2, ["Neon|Ride"] = 523.69, ["Neon|Fly|Ride"] = 565.04, ["Mega"] = 4506.02, ["Mega|Ride"] = 2165.63, ["Mega|Fly|Ride"] = 2887.49}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 6.37, ["Fly"] = 45.55, ["Ride"] = 23.47, ["Fly|Ride"] = 59.07, ["Neon"] = 32.7, ["Neon|Ride"] = 57.67, ["Neon|Fly|Ride"] = 104.35, ["Mega"] = 373.66, ["Mega|Ride"] = 273.87, ["Mega|Fly|Ride"] = 398.99}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 68.75, ["Fly"] = 131.24, ["Ride"] = 108.6, ["Fly|Ride"] = 188.98, ["Neon"] = 210, ["Neon|Fly"] = 324.58, ["Neon|Ride"] = 222.01, ["Neon|Fly|Ride"] = 348.75, ["Mega"] = 1125.21, ["Mega|Ride"] = 1063.13, ["Mega|Fly|Ride"] = 1035.57}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 16.01, ["Fly"] = 170.86, ["Ride"] = 53.7, ["Fly|Ride"] = 149.51, ["Neon"] = 85.32, ["Neon|Ride"] = 99.74, ["Neon|Fly|Ride"] = 277.45, ["Mega"] = 446.25, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 555.13}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 6.97, ["Fly"] = 42.73, ["Ride"] = 25.65, ["Fly|Ride"] = 70.13, ["Neon"] = 128.14, ["Neon|Ride"] = 193.04, ["Neon|Fly|Ride"] = 383.65, ["Mega"] = 563.41, ["Mega|Ride"] = 567.95, ["Mega|Fly|Ride"] = 566.88}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 15.73, ["Ride"] = 65.62, ["Fly|Ride"] = 102.37, ["Neon"] = 43.32, ["Neon|Fly"] = 120.71, ["Neon|Ride"] = 75.36, ["Neon|Fly|Ride"] = 438.38, ["Mega"] = 285.05, ["Mega|Ride"] = 347.82, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 5.65, ["Ride"] = 35.65, ["Fly|Ride"] = 271.24, ["Neon"] = 33.03, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 143.07, ["Mega"] = 276.82, ["Mega|Ride"] = 279.34, ["Mega|Fly|Ride"] = 399.27}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Ride"] = 71.55, ["Neon"] = 2.1, ["Neon|Fly"] = 96.68, ["Neon|Ride"] = 131.23, ["Neon|Fly|Ride"] = 210, ["Mega"] = 19.67, ["Mega|Fly"] = 71.6, ["Mega|Ride"] = 143.07, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 3.19, ["Ride"] = 123.38, ["Neon"] = 31.5, ["Neon|Ride"] = 195.4, ["Mega"] = 236.24, ["Mega|Ride"] = 506.02, ["Mega|Fly|Ride"] = 524.18}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Fly"] = 127.09, ["Ride"] = 28.85, ["Neon"] = 6.57, ["Neon|Fly"] = 116.94, ["Neon|Ride"] = 100.37, ["Neon|Fly|Ride"] = 170.82, ["Mega"] = 210.67, ["Mega|Ride"] = 283.98, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 3.93, ["Ride"] = 32.8, ["Fly|Ride"] = 120.66, ["Neon"] = 32.04, ["Neon|Ride"] = 85.22, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 125.98, ["Mega|Ride"] = 285.05, ["Mega|Fly|Ride"] = 519.74}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 519.16, ["Fly"] = 597.98, ["Ride"] = 511.88, ["Fly|Ride"] = 570.71, ["Neon"] = 1815.27, ["Neon|Fly"] = 1817.19, ["Neon|Ride"] = 1855.4, ["Neon|Fly|Ride"] = 1561.25, ["Mega|Fly|Ride"] = 5893.13}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 3.99, ["Fly"] = 45.47, ["Ride"] = 20.43, ["Fly|Ride"] = 56.94, ["Neon"] = 71.55, ["Neon|Ride"] = 57.67, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 213.52, ["Mega|Ride"] = 370.38, ["Mega|Fly|Ride"] = 353.37}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 6.16, ["Fly"] = 66.94, ["Ride"] = 20.93, ["Fly|Ride"] = 52.07, ["Neon"] = 84, ["Neon|Fly"] = 315, ["Neon|Ride"] = 76.13, ["Neon|Fly|Ride"] = 57.75, ["Mega"] = 331.87, ["Mega|Ride"] = 482.58, ["Mega|Fly|Ride"] = 470.8}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 2.1, ["Fly"] = 24.93, ["Ride"] = 21.37, ["Fly|Ride"] = 50.79, ["Neon|Ride"] = 42.09, ["Neon|Fly|Ride"] = 131.25}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 24.57, ["Fly|Ride"] = 89.24, ["Neon"] = 7.33, ["Neon|Ride"] = 30.07, ["Neon|Fly|Ride"] = 139.86, ["Mega"] = 62.91, ["Mega|Ride"] = 124.59, ["Mega|Fly|Ride"] = 229.09}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 71.55, ["Ride"] = 17.07, ["Neon"] = 2.1, ["Neon|Ride"] = 24.45, ["Neon|Fly|Ride"] = 114.23, ["Mega"] = 23.29, ["Mega|Fly"] = 199.64, ["Mega|Ride"] = 86.52, ["Mega|Fly|Ride"] = 226.33}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1181.25}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 7.87, ["Ride"] = 31.5, ["Fly|Ride"] = 170.86, ["Neon"] = 68.06, ["Neon|Ride"] = 112.87, ["Mega"] = 400.35, ["Mega|Ride"] = 370.38, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 28.56, ["Neon"] = 3.94, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 997.11, ["Mega"] = 39.29, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 182.44}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 3.72, ["Fly"] = 318.7, ["Ride"] = 50.23, ["Fly|Ride"] = 65.63, ["Neon"] = 13.13, ["Neon|Ride"] = 170.52, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 258.57, ["Mega|Ride"] = 378.83, ["Mega|Fly|Ride"] = 1067.55}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 393.74, ["Ride"] = 426.57, ["Fly|Ride"] = 536.81, ["Neon|Ride"] = 1577.84, ["Neon|Fly|Ride"] = 1312.5, ["Mega"] = 8006.56, ["Mega|Fly|Ride"] = 6164.82}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 5.77, ["Fly"] = 196.88, ["Ride"] = 57.68, ["Fly|Ride"] = 128.15, ["Neon"] = 52.5, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 193.04, ["Mega"] = 306.56, ["Mega|Ride"] = 440, ["Mega|Fly|Ride"] = 759.03}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Fly"] = 94.13, ["Ride"] = 32.13, ["Fly|Ride"] = 118.11, ["Neon"] = 3.93, ["Neon|Ride"] = 28.85, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 34.04, ["Mega|Fly"] = 143.07, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 191.02}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 2.1, ["Neon|Ride"] = 143.09, ["Neon|Fly|Ride"] = 198.58, ["Mega"] = 32.81, ["Mega|Ride"] = 178.27, ["Mega|Fly|Ride"] = 209.98}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 18.26, ["Fly"] = 107.89, ["Ride"] = 42.67, ["Fly|Ride"] = 213.59, ["Neon"] = 193.12, ["Neon|Ride"] = 202.13, ["Neon|Fly|Ride"] = 437.07, ["Mega"] = 452.82, ["Mega|Ride"] = 472.5, ["Mega|Fly|Ride"] = 545.74}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 11.5, ["Ride"] = 71.51, ["Neon"] = 76.02, ["Neon|Ride"] = 133.88, ["Neon|Fly|Ride"] = 854.05, ["Mega"] = 563.41, ["Mega|Ride"] = 482.35, ["Mega|Fly|Ride"] = 838.69}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 3.13, ["Ride"] = 28.54, ["Neon"] = 96.94, ["Neon|Ride"] = 194.83, ["Mega"] = 626.67, ["Mega|Ride"] = 640.54, ["Mega|Fly|Ride"] = 427.03}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 12.5, ["Ride"] = 25.12, ["Fly|Ride"] = 236.25, ["Neon"] = 167.28, ["Neon|Ride"] = 177.51, ["Neon|Fly|Ride"] = 241.5, ["Mega"] = 643.02, ["Mega|Ride"] = 528.45, ["Mega|Fly|Ride"] = 550.87}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 393.75, ["Ride"] = 463.77, ["Fly|Ride"] = 709.03, ["Neon"] = 1050, ["Neon|Ride"] = 1050, ["Neon|Fly|Ride"] = 1113, ["Mega|Fly|Ride"] = 3346.87}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 4.9, ["Fly"] = 30.19, ["Ride"] = 24.14, ["Fly|Ride"] = 68.35, ["Neon"] = 97.12, ["Neon|Ride"] = 192.2, ["Mega|Fly"] = 590.63, ["Mega|Ride"] = 561.1, ["Mega|Fly|Ride"] = 776.12}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 2.1, ["Ride"] = 42.68, ["Fly|Ride"] = 127.32, ["Neon"] = 51.45, ["Neon|Ride"] = 221.82, ["Mega"] = 163, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 629.99}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 27.57, ["Fly"] = 341.71, ["Ride"] = 100.84, ["Fly|Ride"] = 175.88, ["Neon"] = 131.25, ["Neon|Ride"] = 196.77, ["Neon|Fly|Ride"] = 262.29, ["Mega"] = 378.96, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.1, ["Ride"] = 65.63, ["Fly|Ride"] = 213.59, ["Neon"] = 7.8, ["Neon|Ride"] = 69.57, ["Neon|Fly|Ride"] = 276.5, ["Mega"] = 35.44, ["Mega|Fly"] = 189, ["Mega|Ride"] = 129.1, ["Mega|Fly|Ride"] = 280.88}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 42.55, ["Ride"] = 79.03, ["Neon"] = 248.07, ["Neon|Ride"] = 310.94, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 1628.68, ["Mega|Ride"] = 2826.87, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 56.44, ["Ride"] = 28.52, ["Fly|Ride"] = 262.5, ["Neon"] = 9.19, ["Neon|Fly"] = 185.79, ["Neon|Ride"] = 25.65, ["Neon|Fly|Ride"] = 99.51, ["Mega"] = 65.62, ["Mega|Ride"] = 94.4, ["Mega|Fly|Ride"] = 143.07}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 28.85, ["Ride"] = 28.88, ["Fly|Ride"] = 98.96, ["Neon"] = 3.71, ["Neon|Fly"] = 49.13, ["Neon|Ride"] = 49.12, ["Neon|Fly|Ride"] = 105, ["Mega"] = 25.64, ["Mega|Fly"] = 112.88, ["Mega|Ride"] = 87.55, ["Mega|Fly|Ride"] = 263.71}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Ride"] = 37.96, ["Fly|Ride"] = 131.07, ["Neon"] = 10.5, ["Neon|Ride"] = 53.4, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 75.12, ["Mega|Ride"] = 113.17, ["Mega|Fly|Ride"] = 241.31}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 48.87, ["Fly"] = 65.61, ["Ride"] = 61.57, ["Fly|Ride"] = 236.25, ["Neon"] = 190.32, ["Neon|Ride"] = 340.41, ["Neon|Fly|Ride"] = 482.58, ["Mega|Ride"] = 1139.08, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 190.32, ["Ride"] = 275.63, ["Fly|Ride"] = 1067.81, ["Neon"] = 1708.49, ["Neon|Ride"] = 1566.1, ["Neon|Fly|Ride"] = 1771.88, ["Mega"] = 12810.48, ["Mega|Fly|Ride"] = 9964.42}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 3.14, ["Neon"] = 20.79, ["Neon|Fly"] = 350.44, ["Mega"] = 101.07, ["Mega|Ride"] = 209.96, ["Mega|Fly|Ride"] = 280.88}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.1, ["Ride"] = 20.9, ["Neon"] = 8.36, ["Neon|Ride"] = 45.05, ["Neon|Fly|Ride"] = 170.82, ["Mega"] = 37.32, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 91.87, ["Mega|Fly|Ride"] = 241.4}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 2.49, ["Fly"] = 106.8, ["Ride"] = 32.16, ["Fly|Ride"] = 97.13, ["Neon"] = 32.81, ["Mega"] = 242.34, ["Mega|Ride"] = 348.04, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 4.17, ["Fly"] = 98.44, ["Ride"] = 38.57, ["Fly|Ride"] = 106.8, ["Neon"] = 21.37, ["Neon|Ride"] = 65.62, ["Neon|Fly|Ride"] = 139, ["Mega"] = 143, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 187.3, ["Mega|Fly|Ride"] = 344.7}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 93.91, ["Neon"] = 8.6, ["Neon|Ride"] = 143.09, ["Neon|Fly|Ride"] = 143.07, ["Mega"] = 34.93, ["Mega|Ride"] = 90.02, ["Mega|Fly|Ride"] = 399.27}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 19.18, ["Fly|Ride"] = 52.5, ["Neon"] = 3.9, ["Neon|Fly"] = 80.89, ["Neon|Ride"] = 28.25, ["Neon|Fly|Ride"] = 127.05, ["Mega"] = 39.41, ["Mega|Ride"] = 99.68, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 28.85, ["Ride"] = 20.47, ["Fly|Ride"] = 57.68, ["Neon"] = 15.43, ["Neon|Fly"] = 101.43, ["Neon|Ride"] = 40.46, ["Neon|Fly|Ride"] = 106.77, ["Mega"] = 156.15, ["Mega|Ride"] = 141.74, ["Mega|Fly|Ride"] = 728.44}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 25.46, ["Ride"] = 37.95, ["Fly|Ride"] = 78.75, ["Neon"] = 144.34, ["Neon|Ride"] = 233.86, ["Mega"] = 644.24, ["Mega|Ride"] = 555.13, ["Mega|Fly|Ride"] = 651}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 69.78, ["Ride"] = 90.96, ["Fly|Ride"] = 139.13, ["Neon"] = 427.08, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 356.54, ["Neon|Fly|Ride"] = 464.63, ["Mega"] = 1994.19, ["Mega|Ride"] = 3254.99, ["Mega|Fly|Ride"] = 1515.94}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 19.3, ["Fly|Ride"] = 65.63, ["Neon"] = 2.88, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 28.85, ["Neon|Fly|Ride"] = 142.94, ["Mega"] = 34.71, ["Mega|Fly"] = 672, ["Mega|Ride"] = 92.42, ["Mega|Fly|Ride"] = 249.82}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 16.99, ["Ride"] = 15.75, ["Fly|Ride"] = 42.67, ["Neon"] = 3.8, ["Neon|Fly"] = 28.85, ["Neon|Ride"] = 20.89, ["Neon|Fly|Ride"] = 42.72, ["Mega"] = 41.97, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 68.34, ["Mega|Fly|Ride"] = 91.87}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 2.85, ["Fly"] = 50.21, ["Ride"] = 38.04, ["Fly|Ride"] = 52.5, ["Neon"] = 51.9, ["Neon|Ride"] = 144.79, ["Mega"] = 541.26, ["Mega|Ride"] = 275.62, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 393.75, ["Ride"] = 496.49, ["Fly|Ride"] = 446.25, ["Neon"] = 4271.19, ["Neon|Fly|Ride"] = 1771.88, ["Mega|Fly|Ride"] = 5906.25}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 18.26, ["Fly"] = 100.38, ["Ride"] = 36.75, ["Fly|Ride"] = 96.54, ["Neon"] = 214.89, ["Neon|Ride"] = 191.63, ["Neon|Fly|Ride"] = 207.52, ["Mega|Ride"] = 965.99, ["Mega|Fly|Ride"] = 1768.64}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 25.76, ["Fly|Ride"] = 284.05, ["Neon"] = 9.17, ["Neon|Ride"] = 49.24, ["Neon|Fly|Ride"] = 143.07, ["Mega"] = 87.94, ["Mega|Ride"] = 149.17, ["Mega|Fly|Ride"] = 238}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 83.85, ["Ride"] = 50.25, ["Fly|Ride"] = 103.69, ["Neon"] = 58.97, ["Neon|Ride"] = 72.34, ["Mega"] = 118.13, ["Mega|Fly|Ride"] = 319.22}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 28.88, ["Fly"] = 42.73, ["Ride"] = 36.15, ["Fly|Ride"] = 100.38, ["Neon"] = 194.25, ["Neon|Ride"] = 211.32, ["Neon|Fly|Ride"] = 314.94, ["Mega"] = 2562.11, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1002.75}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 110.22, ["Fly"] = 114.28, ["Ride"] = 116.93, ["Fly|Ride"] = 190.32, ["Neon"] = 355.94, ["Neon|Fly"] = 712.15, ["Neon|Ride"] = 482.58, ["Neon|Fly|Ride"] = 610.32, ["Mega"] = 8540.32, ["Mega|Fly|Ride"] = 2572.5}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 236.7, ["Ride"] = 262.5, ["Fly|Ride"] = 328.13, ["Neon"] = 938.44, ["Neon|Ride"] = 776.76, ["Neon|Fly|Ride"] = 918.75, ["Mega|Fly|Ride"] = 3700.13}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 9.68, ["Ride"] = 45.94, ["Fly|Ride"] = 150.94, ["Neon"] = 65.21, ["Neon|Ride"] = 106.97, ["Neon|Fly|Ride"] = 199.64, ["Mega"] = 420, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 463.33}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 28.85, ["Ride"] = 16.96, ["Fly|Ride"] = 43.32, ["Neon"] = 7.88, ["Neon|Ride"] = 21.37, ["Neon|Fly|Ride"] = 84, ["Mega"] = 93.09, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 187.94}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 3.08, ["Fly"] = 26.25, ["Ride"] = 20.69, ["Fly|Ride"] = 47.25, ["Neon"] = 26.25, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 33.11, ["Neon|Fly|Ride"] = 106.54, ["Mega"] = 285.05, ["Mega|Ride"] = 244.15, ["Mega|Fly|Ride"] = 333.33}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 346.8, ["Ride"] = 329.89, ["Fly|Ride"] = 745.34, ["Neon"] = 1569.1, ["Neon|Fly|Ride"] = 2135.09, ["Mega"] = 10248.39, ["Mega|Fly|Ride"] = 5730.82}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Neon"] = 8.56, ["Neon|Ride"] = 139.41, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 30.19, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 466.43}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 3.84, ["Fly"] = 21.37, ["Ride"] = 17.04, ["Fly|Ride"] = 39.37, ["Neon"] = 19.68, ["Neon|Ride"] = 38.03, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 199.01, ["Mega|Ride"] = 228.46, ["Mega|Fly|Ride"] = 228.38}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 17.42, ["Ride"] = 85.44, ["Neon"] = 92.75, ["Neon|Fly"] = 427.08, ["Neon|Ride"] = 108.43, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 539.04, ["Mega|Ride"] = 609, ["Mega|Fly|Ride"] = 673.61}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 100.38, ["Fly"] = 157.5, ["Ride"] = 118.13, ["Fly|Ride"] = 136.5, ["Neon|Ride"] = 796.61, ["Neon|Fly|Ride"] = 570.08, ["Mega|Fly|Ride"] = 2847.14}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 19.67, ["Fly"] = 16.47, ["Ride"] = 27.93, ["Fly|Ride"] = 51.43, ["Neon"] = 134.29, ["Neon|Ride"] = 101.85, ["Neon|Fly|Ride"] = 105.73, ["Mega"] = 875.44, ["Mega|Ride"] = 422.63, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 46.99, ["Neon"] = 3.41, ["Mega"] = 25.64, ["Mega|Ride"] = 128.13, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Ride"] = 16.04, ["Fly|Ride"] = 85.44, ["Neon"] = 2.59, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 21.37, ["Neon|Fly|Ride"] = 85.19, ["Mega"] = 21, ["Mega|Fly"] = 97.13, ["Mega|Ride"] = 47.58, ["Mega|Fly|Ride"] = 111.57}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 8.86, ["Ride"] = 74.46, ["Fly|Ride"] = 131.25, ["Neon"] = 31.14, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 220.5, ["Mega"] = 178.4, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 321.12}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1286.25, ["Ride"] = 1286.25, ["Fly|Ride"] = 1437.19, ["Neon|Ride"] = 4697.76, ["Neon|Fly|Ride"] = 4680.11, ["Mega|Fly|Ride"] = 12600}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 443.52, ["Ride"] = 466.6, ["Fly|Ride"] = 612.33, ["Neon"] = 1663.2, ["Neon|Ride"] = 2562.42, ["Neon|Fly|Ride"] = 1753.5, ["Mega"] = 17080.63, ["Mega|Fly|Ride"] = 7530.44}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 295.2, ["Fly"] = 380.63, ["Ride"] = 341.16, ["Fly|Ride"] = 418.48, ["Neon"] = 746.46, ["Neon|Fly"] = 805.06, ["Neon|Ride"] = 673.2, ["Neon|Fly|Ride"] = 786.18, ["Mega|Fly|Ride"] = 2916.23}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 205.28, ["Fly"] = 498.67, ["Ride"] = 259.86, ["Fly|Ride"] = 338.63, ["Neon"] = 647.07, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 733.69, ["Mega|Fly|Ride"] = 2986.99}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 15.79, ["Ride"] = 15.75, ["Fly|Ride"] = 42, ["Neon"] = 4.94, ["Neon|Ride"] = 30.45, ["Neon|Fly|Ride"] = 102.51, ["Mega"] = 69.47, ["Mega|Fly"] = 114.23, ["Mega|Ride"] = 77.44, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 246.53, ["Fly"] = 1424.45, ["Ride"] = 309.75, ["Fly|Ride"] = 943.95, ["Neon"] = 1494.75, ["Neon|Ride"] = 1365, ["Neon|Fly|Ride"] = 1196.72, ["Mega"] = 21635.82, ["Mega|Ride"] = 5124.2, ["Mega|Fly|Ride"] = 4593.75}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 6.55, ["Fly"] = 157.5, ["Ride"] = 70.49, ["Fly|Ride"] = 161.69, ["Neon"] = 28.9, ["Neon|Ride"] = 115.8, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 175.87, ["Mega|Ride"] = 314.79, ["Mega|Fly|Ride"] = 425.97}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 18.11, ["Ride"] = 16.7, ["Fly|Ride"] = 38.58, ["Neon"] = 16.04, ["Neon|Ride"] = 50.19, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 118.13, ["Mega|Ride"] = 192.31}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 56.6, ["Neon"] = 2.99, ["Neon|Ride"] = 46.73, ["Mega"] = 33.94, ["Mega|Ride"] = 196.77, ["Mega|Fly|Ride"] = 177.62}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 26.24, ["Ride"] = 57.73, ["Fly|Ride"] = 459.38, ["Neon"] = 199.5, ["Neon|Ride"] = 356.57, ["Mega"] = 1050, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 773.07}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 8044.09, ["Ride"] = 26.56, ["Fly|Ride"] = 68.25, ["Neon"] = 16.28, ["Neon|Ride"] = 61.13, ["Mega"] = 354.43, ["Mega|Ride"] = 297.51, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.13, ["Neon"] = 2.1, ["Neon|Ride"] = 55.13, ["Neon|Fly|Ride"] = 141.93, ["Mega"] = 22.96, ["Mega|Ride"] = 70.42, ["Mega|Fly|Ride"] = 168.69}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 3.34, ["Fly"] = 85.35, ["Ride"] = 34.04, ["Fly|Ride"] = 72.19, ["Neon"] = 23.63, ["Neon|Fly"] = 114.26, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 161.68, ["Mega"] = 139.13, ["Mega|Ride"] = 131.06, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 2.63, ["Fly"] = 44.87, ["Ride"] = 22.3, ["Fly|Ride"] = 50.3, ["Neon"] = 37.4, ["Neon|Fly"] = 144.85, ["Neon|Ride"] = 143.07, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 238.83, ["Mega|Ride"] = 251.07, ["Mega|Fly|Ride"] = 1321.69}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 19.85, ["Ride"] = 38.07, ["Fly|Ride"] = 105, ["Neon"] = 92.92, ["Neon|Ride"] = 185.79, ["Neon|Fly|Ride"] = 322.13, ["Mega"] = 427.03, ["Mega|Ride"] = 799.6}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.1, ["Fly"] = 6435.65, ["Ride"] = 17.07, ["Neon"] = 36.32, ["Neon|Fly"] = 52.12, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 285.05, ["Mega"] = 334.69, ["Mega|Ride"] = 482.58, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 65.36, ["Ride"] = 18.37, ["Fly|Ride"] = 45.94, ["Neon"] = 3.78, ["Neon|Fly"] = 82.48, ["Neon|Ride"] = 27.66, ["Neon|Fly|Ride"] = 114.23, ["Mega"] = 49.88, ["Mega|Fly|Ride"] = 225.62}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 144.38, ["Fly"] = 228.53, ["Ride"] = 164.04, ["Fly|Ride"] = 256.29, ["Neon"] = 968.51, ["Neon|Ride"] = 997.21, ["Neon|Fly|Ride"] = 840, ["Mega"] = 8540.32, ["Mega|Ride"] = 3843.15, ["Mega|Fly|Ride"] = 3987.27}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 19.21, ["Ride"] = 15.65, ["Fly|Ride"] = 34.13, ["Neon"] = 3.29, ["Neon|Fly"] = 36.22, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 47.25, ["Mega"] = 47.95, ["Mega|Ride"] = 57.75, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 6.55, ["Ride"] = 40.36, ["Fly|Ride"] = 228.53, ["Neon"] = 64.99, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 772.13, ["Mega"] = 313.69, ["Mega|Ride"] = 341.45, ["Mega|Fly|Ride"] = 379.32}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 28.66, ["Ride"] = 309.67, ["Fly|Ride"] = 183.75, ["Neon"] = 157.5, ["Neon|Ride"] = 249.85, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 786.19, ["Mega|Ride"] = 866.25, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 196.65, ["Fly"] = 306.47, ["Ride"] = 248.7, ["Fly|Ride"] = 262.49, ["Neon"] = 812.4, ["Neon|Ride"] = 702.18, ["Neon|Fly|Ride"] = 787.5, ["Mega|Fly|Ride"] = 3521.83}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 30.08, ["Ride"] = 161.69, ["Fly|Ride"] = 144.8, ["Neon"] = 124.69, ["Neon|Ride"] = 213.52, ["Neon|Fly|Ride"] = 427.03, ["Mega"] = 242.34, ["Mega|Ride"] = 326.69, ["Mega|Fly|Ride"] = 341.62}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 5.76, ["Fly"] = 96.54, ["Ride"] = 59.17, ["Fly|Ride"] = 71.55, ["Neon"] = 131.25, ["Neon|Fly"] = 161.76, ["Neon|Ride"] = 211.14, ["Neon|Fly|Ride"] = 203.75, ["Mega"] = 1139.08, ["Mega|Ride"] = 854.05, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 918.75, ["Fly"] = 1206.57, ["Ride"] = 978.02, ["Fly|Ride"] = 958.13, ["Neon|Ride"] = 4982.82, ["Neon|Fly|Ride"] = 5106.06, ["Mega|Fly|Ride"] = 17079.57}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 6.03, ["Fly"] = 23, ["Ride"] = 21.46, ["Fly|Ride"] = 36.32, ["Neon"] = 47.24, ["Neon|Fly"] = 74.15, ["Neon|Ride"] = 49.13, ["Neon|Fly|Ride"] = 202.13, ["Mega"] = 219.19, ["Mega|Ride"] = 285.05, ["Mega|Fly|Ride"] = 346.49}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 3.77, ["Fly"] = 78.75, ["Ride"] = 42.73, ["Fly|Ride"] = 135.19, ["Neon"] = 32.82, ["Neon|Ride"] = 96.52, ["Neon|Fly|Ride"] = 190.32, ["Mega"] = 211.32, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 309.6, ["Mega|Fly|Ride"] = 421.7}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Fly"] = 85.44, ["Ride"] = 24.31, ["Fly|Ride"] = 143.1, ["Neon"] = 10.84, ["Neon|Ride"] = 46.95, ["Neon|Fly|Ride"] = 85.41, ["Mega"] = 68.34, ["Mega|Ride"] = 360.34, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 16.03, ["Ride"] = 41.58, ["Fly|Ride"] = 95.82, ["Neon"] = 69.91, ["Neon|Fly"] = 228.5, ["Neon|Ride"] = 96.36, ["Neon|Fly|Ride"] = 178.55, ["Mega"] = 446.23, ["Mega|Ride"] = 415.8, ["Mega|Fly|Ride"] = 457.13}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 4.83, ["Fly"] = 21, ["Ride"] = 16.04, ["Fly|Ride"] = 45.85, ["Neon"] = 20.51, ["Neon|Fly"] = 42.74, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 114.23, ["Mega"] = 118.13, ["Mega|Fly"] = 280.98, ["Mega|Ride"] = 143.07, ["Mega|Fly|Ride"] = 162.68}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Ride"] = 24.94, ["Neon"] = 10.5, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 48.27, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 124.48, ["Mega|Ride"] = 165.48}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 240.19, ["Fly"] = 238.12, ["Ride"] = 213.59, ["Fly|Ride"] = 427.13, ["Neon"] = 924.73, ["Neon|Fly|Ride"] = 1183.01, ["Mega|Fly|Ride"] = 3877.32}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Fly"] = 32.81, ["Ride"] = 26.17, ["Fly|Ride"] = 110.25, ["Neon"] = 3.93, ["Neon|Ride"] = 49.79, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 61.69, ["Mega|Ride"] = 127.37, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 2.62, ["Ride"] = 28.85, ["Fly|Ride"] = 88.86, ["Neon"] = 32.17, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 188.27, ["Mega"] = 170.82, ["Mega|Ride"] = 322.13, ["Mega|Fly|Ride"] = 193.04}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 3.91, ["Fly"] = 94.74, ["Ride"] = 25.73, ["Neon"] = 14.15, ["Neon|Ride"] = 36.17, ["Mega"] = 94.31, ["Mega|Ride"] = 120.53, ["Mega|Fly|Ride"] = 504.19}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 72.18, ["Ride"] = 127.89, ["Fly|Ride"] = 249.38, ["Neon"] = 447.57, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 762.47, ["Mega"] = 2562.11, ["Mega|Ride"] = 4270.17, ["Mega|Fly|Ride"] = 1765.73}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 22.31, ["Fly"] = 90.78, ["Ride"] = 42.73, ["Fly|Ride"] = 264.83, ["Neon"] = 180.99, ["Neon|Ride"] = 208.18, ["Neon|Fly|Ride"] = 341.93, ["Mega"] = 643.15, ["Mega|Ride"] = 620.82, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 18.37, ["Fly"] = 57.68, ["Ride"] = 39.37, ["Fly|Ride"] = 97.13, ["Neon"] = 81.38, ["Neon|Ride"] = 125.99, ["Neon|Fly|Ride"] = 247.11, ["Mega"] = 457.25, ["Mega|Ride"] = 435.75, ["Mega|Fly|Ride"] = 497.44}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 72.36, ["Neon"] = 8.56, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 71.55, ["Mega"] = 129.1, ["Mega|Ride"] = 163.13, ["Mega|Fly|Ride"] = 554.07}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 32.82, ["Fly"] = 78.75, ["Ride"] = 83.45, ["Fly|Ride"] = 156.98, ["Neon"] = 262.5, ["Neon|Fly"] = 245.44, ["Neon|Ride"] = 298.96, ["Neon|Fly|Ride"] = 312.38, ["Mega|Fly|Ride"] = 1011.71}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 52.5, ["Neon"] = 3.82, ["Neon|Ride"] = 57.67, ["Neon|Fly|Ride"] = 127.05, ["Mega"] = 60.86, ["Mega|Ride"] = 283.98, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 13.13, ["Fly"] = 129.11, ["Ride"] = 32.15, ["Fly|Ride"] = 86.89, ["Neon"] = 83.55, ["Neon|Ride"] = 65.17, ["Neon|Fly|Ride"] = 219.93, ["Mega"] = 357.09, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 425.97, ["Mega|Fly|Ride"] = 433.79}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 49.6, ["Fly"] = 203.41, ["Ride"] = 65.54, ["Fly|Ride"] = 123.35, ["Neon"] = 249.38, ["Neon|Fly"] = 427.08, ["Neon|Ride"] = 288.74, ["Neon|Fly|Ride"] = 496.12, ["Mega|Ride"] = 1460.41, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 15.65, ["Ride"] = 14.19, ["Fly|Ride"] = 35.42, ["Neon"] = 2.1, ["Neon|Fly"] = 24.47, ["Neon|Ride"] = 15.57, ["Neon|Fly|Ride"] = 42.76, ["Mega"] = 16.59, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 40.58, ["Mega|Fly|Ride"] = 99.65}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 2.1, ["Ride"] = 21, ["Fly|Ride"] = 98.44, ["Neon"] = 23.63, ["Neon|Ride"] = 65.61, ["Neon|Fly|Ride"] = 167.99, ["Mega"] = 228.38, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 392.44}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 14.84, ["Fly"] = 143.1, ["Ride"] = 41.56, ["Fly|Ride"] = 85.32, ["Neon"] = 110.15, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 272.76, ["Mega"] = 616.71, ["Mega|Ride"] = 454.77, ["Mega|Fly|Ride"] = 651}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 22.23, ["Neon"] = 2.1, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 95.81, ["Mega"] = 21, ["Mega|Ride"] = 52, ["Mega|Fly|Ride"] = 211.38}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 27.55, ["Fly"] = 207.9, ["Ride"] = 78.1, ["Fly|Ride"] = 181.55, ["Neon"] = 104.81, ["Neon|Ride"] = 173.36, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 612.68, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 574.5, ["Mega|Fly|Ride"] = 759.03}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 13.12, ["Fly"] = 42.73, ["Ride"] = 21.37, ["Fly|Ride"] = 88.64, ["Neon"] = 376.69, ["Neon|Ride"] = 120.59, ["Neon|Fly|Ride"] = 164.41, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 484.67}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 3.28, ["Ride"] = 48.57, ["Neon"] = 56.42, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 75.12, ["Neon|Fly|Ride"] = 712.06, ["Mega"] = 232.98, ["Mega|Ride"] = 313.68, ["Mega|Fly|Ride"] = 422.76}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 7.84, ["Fly"] = 65.63, ["Ride"] = 72.19, ["Fly|Ride"] = 229.69, ["Neon"] = 54.51, ["Neon|Ride"] = 88.62, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 215.86, ["Mega|Ride"] = 228.46, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Fly"] = 42.73, ["Ride"] = 20.9, ["Fly|Ride"] = 196.88, ["Neon"] = 3.52, ["Neon|Ride"] = 34.92, ["Mega"] = 53.82, ["Mega|Fly"] = 213.52, ["Mega|Ride"] = 96.52, ["Mega|Fly|Ride"] = 285.05}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 57.93, ["Neon"] = 3.94, ["Mega"] = 41.08, ["Mega|Ride"] = 76.13, ["Mega|Fly|Ride"] = 195.33}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 16.94}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 38.04, ["Fly"] = 100.38, ["Ride"] = 64.94, ["Fly|Ride"] = 80.1, ["Neon"] = 196.88, ["Neon|Ride"] = 213.54, ["Neon|Fly|Ride"] = 315, ["Mega"] = 1851.13, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 853.58}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.25, ["Neon|Ride"] = 27.57, ["Mega"] = 23.49, ["Mega|Ride"] = 121.71, ["Mega|Fly|Ride"] = 320.28}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 524.99, ["Fly"] = 570.22, ["Ride"] = 561.75, ["Fly|Ride"] = 555.27, ["Neon"] = 2847.83, ["Neon|Ride"] = 2028.58, ["Neon|Fly|Ride"] = 2111.03, ["Mega"] = 17080.63, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 4.29, ["Fly"] = 48.37, ["Ride"] = 33.72, ["Fly|Ride"] = 41.04, ["Neon"] = 9.81, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 114.23, ["Mega"] = 170.82, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 626.67}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 16.71, ["Fly|Ride"] = 57.75, ["Neon"] = 21.27, ["Neon|Ride"] = 64.08, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 129.1, ["Mega|Fly"] = 285.05, ["Mega|Ride"] = 164.41, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 11.54, ["Ride"] = 28.85, ["Fly|Ride"] = 533.92, ["Neon"] = 106.8, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 301.88, ["Mega"] = 644.24, ["Mega|Ride"] = 540.5, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 2.1, ["Fly"] = 427.13, ["Ride"] = 38.57, ["Fly|Ride"] = 712.23, ["Neon"] = 30.24, ["Neon|Fly"] = 50.19, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 392.44, ["Mega"] = 279.57, ["Mega|Fly|Ride"] = 495.35}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 8.79, ["Ride"] = 73.49, ["Fly|Ride"] = 157.5, ["Neon"] = 52.5, ["Neon|Ride"] = 94.5, ["Neon|Fly|Ride"] = 273.02, ["Mega"] = 497.44, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 402.96}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 6.29, ["Fly"] = 105, ["Ride"] = 28.25, ["Fly|Ride"] = 91.88, ["Neon"] = 31.16, ["Neon|Ride"] = 81.1, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 232.32, ["Mega|Ride"] = 324.55, ["Mega|Fly|Ride"] = 349.13}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 45.86, ["Ride"] = 13.55, ["Fly|Ride"] = 85.46, ["Neon"] = 2.1, ["Neon|Fly"] = 41.99, ["Neon|Ride"] = 15.7, ["Neon|Fly|Ride"] = 48.27, ["Mega"] = 13.96, ["Mega|Fly"] = 65.01, ["Mega|Ride"] = 49.03, ["Mega|Fly|Ride"] = 98.01}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 4.37, ["Fly"] = 54.47, ["Ride"] = 38.43, ["Fly|Ride"] = 106.8, ["Neon"] = 23.45, ["Neon|Fly"] = 120.71, ["Neon|Ride"] = 50.94, ["Neon|Fly|Ride"] = 200.05, ["Mega"] = 196.88, ["Mega|Ride"] = 213.52, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 261.19, ["Ride"] = 339.06, ["Fly|Ride"] = 364.88, ["Neon"] = 1312.5, ["Neon|Ride"] = 1094.63, ["Neon|Fly|Ride"] = 1050, ["Mega|Ride"] = 9361.88, ["Mega|Fly|Ride"] = 5258.71}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 71.55, ["Ride"] = 112.88, ["Fly|Ride"] = 255.22, ["Neon"] = 458.07, ["Neon|Fly"] = 913.95, ["Neon|Ride"] = 427.08, ["Neon|Fly|Ride"] = 698.25, ["Mega"] = 2278.14, ["Mega|Ride"] = 1701.67, ["Mega|Fly|Ride"] = 1808.73}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 16.96, ["Ride"] = 16.22, ["Fly|Ride"] = 35.44, ["Neon"] = 6.12, ["Neon|Fly"] = 71.55, ["Neon|Ride"] = 34.18, ["Neon|Fly|Ride"] = 64.07, ["Mega"] = 143.07, ["Mega|Fly"] = 212.46, ["Mega|Ride"] = 92.89, ["Mega|Fly|Ride"] = 246.88}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 16.04, ["Ride"] = 15.38, ["Fly|Ride"] = 28.85, ["Neon"] = 7.69, ["Neon|Fly"] = 38.46, ["Neon|Ride"] = 25.1, ["Neon|Fly|Ride"] = 58.77, ["Mega"] = 76.16, ["Mega|Fly"] = 285.05, ["Mega|Ride"] = 82.77, ["Mega|Fly|Ride"] = 143.16}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.1, ["Fly"] = 100.38, ["Ride"] = 22.32, ["Fly|Ride"] = 98.44, ["Neon"] = 91.88, ["Neon|Fly|Ride"] = 157.5, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 203.73, ["Fly"] = 322.17, ["Ride"] = 226.5, ["Fly|Ride"] = 288.75, ["Neon"] = 1174.6, ["Neon|Ride"] = 1050, ["Neon|Fly|Ride"] = 1174.3, ["Mega|Ride"] = 8540.32, ["Mega|Fly|Ride"] = 3806.25}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.1, ["Fly"] = 14.44, ["Ride"] = 15, ["Fly|Ride"] = 42.73, ["Neon"] = 18.06, ["Neon|Fly"] = 104.97, ["Neon|Ride"] = 25.47, ["Neon|Fly|Ride"] = 85.41, ["Mega"] = 255.94, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 2.26, ["Ride"] = 77.09, ["Fly|Ride"] = 213.59, ["Neon"] = 21.37, ["Neon|Ride"] = 106.78, ["Neon|Fly|Ride"] = 285.05, ["Mega"] = 196.88, ["Mega|Ride"] = 300.45, ["Mega|Fly|Ride"] = 456.92}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 91.1, ["Neon"] = 6.57, ["Mega"] = 91.88, ["Mega|Ride"] = 337.82, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 12.7, ["Fly"] = 28.55, ["Ride"] = 21, ["Fly|Ride"] = 57.68, ["Neon"] = 149.48, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 235.94, ["Mega"] = 460.69, ["Mega|Ride"] = 456.75, ["Mega|Fly|Ride"] = 590.52}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 37.96, ["Ride"] = 80.07, ["Fly|Ride"] = 391.84, ["Neon"] = 127.32, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 169.3, ["Neon|Fly|Ride"] = 308.72, ["Mega"] = 511.54, ["Mega|Fly"] = 2241.84, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 621.01}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 27.57, ["Fly"] = 64.08, ["Ride"] = 36.28, ["Fly|Ride"] = 91.77, ["Neon"] = 161.76, ["Neon|Fly"] = 286.44, ["Neon|Ride"] = 133.7, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 854.05, ["Mega|Ride"] = 700.88, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 17.05, ["Ride"] = 13.55, ["Fly|Ride"] = 36.32, ["Neon"] = 2.1, ["Neon|Fly"] = 31.47, ["Neon|Ride"] = 15.94, ["Neon|Fly|Ride"] = 48.47, ["Mega"] = 20.97, ["Mega|Fly"] = 427.03, ["Mega|Ride"] = 36.59, ["Mega|Fly|Ride"] = 94.23}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 164.07, ["Ride"] = 203.44, ["Fly|Ride"] = 272.62, ["Neon"] = 3273.94, ["Neon|Fly|Ride"] = 1016.31, ["Mega|Fly|Ride"] = 4398.28}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 9.19, ["Fly"] = 74.82, ["Ride"] = 20.33, ["Fly|Ride"] = 92.94, ["Neon"] = 161.16, ["Neon|Ride"] = 110.25, ["Neon|Fly|Ride"] = 427.03, ["Mega"] = 422.63, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 35.98, ["Ride"] = 18.76, ["Fly|Ride"] = 43.35, ["Neon"] = 5.07, ["Neon|Fly"] = 41.93, ["Neon|Ride"] = 28.85, ["Neon|Fly|Ride"] = 102.38, ["Mega"] = 60.88, ["Mega|Fly"] = 222.07, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 232.75}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 16.14, ["Fly|Ride"] = 76.9, ["Neon"] = 2.24, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 129.1, ["Mega"] = 22.23, ["Mega|Fly"] = 143.07, ["Mega|Ride"] = 38.45, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 72.19, ["Neon"] = 10.28, ["Neon|Fly"] = 724.2, ["Neon|Ride"] = 59.07, ["Mega"] = 129.94, ["Mega|Ride"] = 136.5, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 9.18, ["Fly"] = 44.87, ["Ride"] = 24.81, ["Fly|Ride"] = 65.63, ["Neon"] = 46.45, ["Neon|Fly"] = 271.2, ["Neon|Ride"] = 59.41, ["Neon|Fly|Ride"] = 107.63, ["Mega"] = 301.88, ["Mega|Ride"] = 370.13, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 4.55, ["Ride"] = 45.93, ["Neon"] = 65.63, ["Neon|Ride"] = 149.48, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 275.63, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 482.58}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 34.13, ["Neon"] = 3.93, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 100.38, ["Mega"] = 23.63, ["Mega|Ride"] = 98.23, ["Mega|Fly|Ride"] = 121.38}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 5.73, ["Ride"] = 28.46, ["Fly|Ride"] = 143.1, ["Neon"] = 34.41, ["Neon|Fly"] = 102.92, ["Neon|Ride"] = 45.72, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 148.4, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 35.85, ["Neon"] = 3.66, ["Neon|Fly"] = 114.26, ["Neon|Ride"] = 54.46, ["Neon|Fly|Ride"] = 102.38, ["Mega"] = 26.25, ["Mega|Ride"] = 106.77, ["Mega|Fly|Ride"] = 321.26}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 47.4, ["Ride"] = 20.31, ["Fly|Ride"] = 41.04, ["Neon"] = 6.57, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 128.13, ["Mega"] = 65.17, ["Mega|Ride"] = 63.95, ["Mega|Fly|Ride"] = 238.74}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 623.6, ["Ride"] = 700.37, ["Fly|Ride"] = 771.75, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 3675, ["Mega|Fly|Ride"] = 9620.63}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 16.46, ["Ride"] = 13.13, ["Fly|Ride"] = 37.4, ["Neon"] = 13.13, ["Neon|Fly"] = 42.72, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 191.1, ["Mega|Fly|Ride"] = 394.51}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.62, ["Ride"] = 45.93, ["Neon"] = 14.43, ["Neon|Fly"] = 747.38, ["Neon|Ride"] = 71.55, ["Neon|Fly|Ride"] = 185.77, ["Mega"] = 56.44, ["Mega|Fly"] = 190.03, ["Mega|Ride"] = 145.36, ["Mega|Fly|Ride"] = 257.27}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 7.06, ["Fly"] = 26.25, ["Ride"] = 22.23, ["Fly|Ride"] = 61.94, ["Neon"] = 39.38, ["Neon|Fly"] = 193.12, ["Neon|Ride"] = 43.31, ["Neon|Fly|Ride"] = 101.77, ["Mega"] = 485.63, ["Mega|Ride"] = 299.23, ["Mega|Fly|Ride"] = 347.82}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 24.57, ["Ride"] = 15.65, ["Fly|Ride"] = 36.32, ["Neon"] = 5.85, ["Neon|Fly"] = 149.48, ["Neon|Ride"] = 24.57, ["Neon|Fly|Ride"] = 57.67, ["Mega"] = 59.07, ["Mega|Ride"] = 99.75, ["Mega|Fly|Ride"] = 180.45}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 36.39, ["Ride"] = 57.68, ["Fly|Ride"] = 315.02, ["Neon"] = 196.88, ["Neon|Ride"] = 258.3, ["Mega"] = 682.18, ["Mega|Ride"] = 693.91, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Fly"] = 32.7, ["Ride"] = 20.37, ["Fly|Ride"] = 76.13, ["Neon"] = 7.79, ["Neon|Fly"] = 137.61, ["Neon|Ride"] = 31.38, ["Neon|Fly|Ride"] = 119.43, ["Mega"] = 45.93, ["Mega|Ride"] = 132.9, ["Mega|Fly|Ride"] = 272.98}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 26.17, ["Fly|Ride"] = 63.02, ["Neon"] = 11.79, ["Neon|Ride"] = 48.57, ["Neon|Fly|Ride"] = 161.68, ["Mega"] = 100.02, ["Mega|Ride"] = 198.59, ["Mega|Fly|Ride"] = 353.37}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.63, ["Fly|Ride"] = 65.83, ["Neon"] = 17.1, ["Neon|Fly|Ride"] = 114.23, ["Mega"] = 97.12, ["Mega|Ride"] = 160.15, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 42.73, ["Ride"] = 15.94, ["Fly|Ride"] = 68.86, ["Neon"] = 3.44, ["Neon|Fly"] = 71.55, ["Neon|Ride"] = 21.86, ["Neon|Fly|Ride"] = 114.23, ["Mega"] = 40.57, ["Mega|Fly"] = 227.39, ["Mega|Ride"] = 81.51, ["Mega|Fly|Ride"] = 84}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 18.26, ["Fly"] = 21.37, ["Ride"] = 18.37, ["Fly|Ride"] = 36.32, ["Neon"] = 114.28, ["Neon|Ride"] = 80.88, ["Neon|Fly|Ride"] = 143.07, ["Mega|Ride"] = 558.33, ["Mega|Fly|Ride"] = 384.55}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 695.63, ["Fly"] = 997.34, ["Ride"] = 734.99, ["Fly|Ride"] = 779.63, ["Neon"] = 1935.94, ["Neon|Ride"] = 2072.94, ["Neon|Fly|Ride"] = 2163, ["Mega"] = 4654.5, ["Mega|Fly|Ride"] = 6194.94}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 22.23, ["Ride"] = 14.96, ["Fly|Ride"] = 41.48, ["Neon"] = 3.46, ["Neon|Fly"] = 50.19, ["Neon|Ride"] = 19.49, ["Neon|Fly|Ride"] = 56.31, ["Mega"] = 39.37, ["Mega|Ride"] = 68.88, ["Mega|Fly|Ride"] = 170.68}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 3.93, ["Ride"] = 32.81, ["Fly|Ride"] = 210, ["Neon"] = 51.51, ["Neon|Ride"] = 212.48, ["Neon|Fly|Ride"] = 210, ["Mega"] = 478.28, ["Mega|Ride"] = 393.1, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 50.18, ["Fly"] = 104.9, ["Ride"] = 71.55, ["Fly|Ride"] = 111.57, ["Neon"] = 315, ["Neon|Ride"] = 313.69, ["Neon|Fly|Ride"] = 434.44, ["Mega"] = 2439.83, ["Mega|Fly|Ride"] = 2611.88}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 28.87, ["Fly"] = 146.86, ["Ride"] = 60.38, ["Fly|Ride"] = 104.9, ["Neon"] = 228.53, ["Neon|Ride"] = 240.24, ["Neon|Fly|Ride"] = 427.03, ["Mega"] = 1287.27, ["Mega|Ride"] = 912.76, ["Mega|Fly|Ride"] = 1126.81}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 9.17, ["Fly"] = 90.51, ["Ride"] = 26.49, ["Fly|Ride"] = 143.1, ["Neon"] = 50.82, ["Neon|Ride"] = 126, ["Neon|Fly|Ride"] = 273, ["Mega"] = 302.3, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 460.69}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 27.57, ["Ride"] = 61.55, ["Fly|Ride"] = 140.96, ["Neon"] = 104.99, ["Neon|Ride"] = 348.9, ["Neon|Fly|Ride"] = 149.22, ["Mega"] = 339.05, ["Mega|Fly"] = 523.61, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 429.51}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 19.69, ["Ride"] = 77.44, ["Neon"] = 144.18, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 525, ["Mega"] = 524.99, ["Mega|Fly"] = 567, ["Mega|Ride"] = 476.44, ["Mega|Fly|Ride"] = 744.19}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 6.46}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 7.32, ["Ride"] = 24.86, ["Fly|Ride"] = 50.21, ["Neon"] = 49.16, ["Neon|Ride"] = 63.15, ["Neon|Fly|Ride"] = 213.52, ["Mega"] = 222.24, ["Mega|Fly"] = 453.68, ["Mega|Ride"] = 220.78, ["Mega|Fly|Ride"] = 306.54}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.51, ["Ride"] = 46.97, ["Neon"] = 11.81, ["Neon|Fly|Ride"] = 213.52, ["Mega"] = 140.93}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 28.02, ["Fly"] = 62.99, ["Ride"] = 30.55, ["Fly|Ride"] = 81.37, ["Neon"] = 132.42, ["Neon|Ride"] = 228.69, ["Neon|Fly|Ride"] = 294.66, ["Mega|Ride"] = 767.92, ["Mega|Fly|Ride"] = 616.82}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 5.07, ["Fly"] = 20.29, ["Ride"] = 16.01, ["Fly|Ride"] = 34.18, ["Neon"] = 26.17, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 35.89, ["Neon|Fly|Ride"] = 71.54, ["Mega"] = 198.19, ["Mega|Fly"] = 425.97, ["Mega|Ride"] = 192.18, ["Mega|Fly|Ride"] = 234.8}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 3.83, ["Fly"] = 108.22, ["Ride"] = 26.23, ["Fly|Ride"] = 71.55, ["Neon"] = 22.98, ["Neon|Ride"] = 48.16, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 161.68, ["Mega|Fly"] = 197.4, ["Mega|Ride"] = 162.36, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Ride"] = 71.55, ["Neon"] = 7.35, ["Mega"] = 37.38, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 258.57}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 24.94, ["Ride"] = 52.48, ["Fly|Ride"] = 120.75, ["Neon"] = 281.91, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 427.03, ["Mega|Ride"] = 14234.57, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 21, ["Fly|Ride"] = 65.63, ["Neon"] = 7.88, ["Neon|Fly"] = 203.44, ["Neon|Ride"] = 85.43, ["Neon|Fly|Ride"] = 105, ["Mega"] = 69.71, ["Mega|Ride"] = 141.36}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 9.08, ["Ride"] = 57.68, ["Fly|Ride"] = 284.05, ["Neon"] = 72.19, ["Neon|Ride"] = 150.94, ["Neon|Fly|Ride"] = 143.07, ["Mega"] = 367.5, ["Mega|Ride"] = 482.58, ["Mega|Fly|Ride"] = 555.13}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 45.91, ["Ride"] = 15.65, ["Fly|Ride"] = 60.88, ["Neon"] = 14, ["Neon|Ride"] = 38.46, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 185.77, ["Mega|Ride"] = 202.79, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 2.67, ["Fly"] = 52.49, ["Ride"] = 24.14, ["Fly|Ride"] = 87.57, ["Neon"] = 43.94, ["Neon|Fly"] = 128.14, ["Neon|Ride"] = 143.09, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 399.27, ["Mega|Ride"] = 425.97, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 6.56, ["Ride"] = 93.98, ["Neon"] = 90.92, ["Neon|Ride"] = 77.44, ["Mega"] = 413.86, ["Mega|Ride"] = 366.19, ["Mega|Fly|Ride"] = 639.29}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 46.27, ["Ride"] = 80.85, ["Fly|Ride"] = 145.26, ["Neon"] = 237.18, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 669.38, ["Mega"] = 1164.71, ["Mega|Ride"] = 1238.36, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 10.39, ["Ride"] = 81.81, ["Fly|Ride"] = 143.1, ["Neon"] = 107.61, ["Neon|Ride"] = 183.75, ["Mega"] = 354.27, ["Mega|Ride"] = 563.41, ["Mega|Fly|Ride"] = 712.06}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 10.59, ["Ride"] = 126.04, ["Neon"] = 91.84, ["Neon|Fly"] = 213.54, ["Neon|Ride"] = 170.63, ["Mega"] = 804.7, ["Mega|Ride"] = 434.33, ["Mega|Fly|Ride"] = 570.08}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 22.31, ["Ride"] = 105, ["Fly|Ride"] = 367.48, ["Neon"] = 90.57, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 665.09, ["Mega|Fly"] = 2135.09, ["Mega|Ride"] = 723.87, ["Mega|Fly|Ride"] = 739.19}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 2.1, ["Neon"] = 18.35, ["Neon|Fly|Ride"] = 143.07, ["Mega"] = 185.77, ["Mega|Fly|Ride"] = 322.13}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 27.78, ["Ride"] = 15.93, ["Fly|Ride"] = 42.73, ["Neon"] = 7.87, ["Neon|Fly"] = 42.72, ["Neon|Ride"] = 23.89, ["Neon|Fly|Ride"] = 96.52, ["Mega"] = 96.44, ["Mega|Ride"] = 89.13, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 3.26, ["Fly"] = 48.27, ["Ride"] = 29.25, ["Fly|Ride"] = 69.57, ["Neon"] = 14.79, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 121.71, ["Mega"] = 86.36, ["Mega|Ride"] = 110.25, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 19.68, ["Fly|Ride"] = 46.4, ["Neon"] = 3.94, ["Neon|Ride"] = 27.26, ["Neon|Fly|Ride"] = 118.12, ["Mega"] = 51.75, ["Mega|Fly"] = 122.79, ["Mega|Ride"] = 83.99, ["Mega|Fly|Ride"] = 173.25}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.1, ["Fly"] = 65.62, ["Ride"] = 21.04, ["Fly|Ride"] = 71.55, ["Neon"] = 19.59, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 213.52, ["Mega"] = 284.91, ["Mega|Ride"] = 325.5, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.15, ["Fly"] = 49.61, ["Ride"] = 24.53, ["Fly|Ride"] = 427.13, ["Neon"] = 29.28, ["Neon|Fly"] = 315, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 150.94, ["Mega"] = 242.34, ["Mega|Ride"] = 287.47, ["Mega|Fly|Ride"] = 1067.55}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 3.94, ["Fly"] = 131.25, ["Ride"] = 21.95, ["Fly|Ride"] = 70.88, ["Neon"] = 31.49, ["Neon|Fly"] = 114.26, ["Neon|Ride"] = 29.58, ["Neon|Fly|Ride"] = 102.92, ["Mega"] = 211.32, ["Mega|Ride"] = 291.6, ["Mega|Fly|Ride"] = 397.04}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 35.48, ["Ride"] = 23.63, ["Fly|Ride"] = 51.79, ["Neon"] = 19.23, ["Neon|Ride"] = 69.08, ["Neon|Fly|Ride"] = 106.77, ["Mega"] = 256.23, ["Mega|Ride"] = 207.31, ["Mega|Fly|Ride"] = 186.18}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 2.61, ["Fly"] = 131.25, ["Ride"] = 45.71, ["Fly|Ride"] = 91.88, ["Neon"] = 15.75, ["Neon|Fly"] = 437.06, ["Neon|Ride"] = 66.91, ["Neon|Fly|Ride"] = 170.62, ["Mega"] = 98.34, ["Mega|Fly"] = 210, ["Mega|Ride"] = 134.52, ["Mega|Fly|Ride"] = 248.07}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 32.01, ["Ride"] = 105, ["Fly|Ride"] = 314.9, ["Neon"] = 111.57, ["Neon|Ride"] = 258.19, ["Neon|Fly|Ride"] = 392.44, ["Mega"] = 590.63, ["Mega|Ride"] = 610.03, ["Mega|Fly|Ride"] = 701.15}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 50.18, ["Fly"] = 164.07, ["Ride"] = 71.49, ["Fly|Ride"] = 187.69, ["Neon"] = 235.65, ["Neon|Ride"] = 188.45, ["Neon|Fly|Ride"] = 366.03, ["Mega"] = 1338.7, ["Mega|Ride"] = 1031.44, ["Mega|Fly|Ride"] = 1102.5}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 51.09, ["Ride"] = 21.57, ["Fly|Ride"] = 118.12, ["Neon"] = 2.1, ["Neon|Ride"] = 32.8, ["Neon|Fly|Ride"] = 143.07, ["Mega"] = 25.55, ["Mega|Ride"] = 70.47, ["Mega|Fly|Ride"] = 145.59}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 8.24, ["Ride"] = 52.5, ["Neon|Ride"] = 113.42, ["Mega"] = 686.56, ["Mega|Fly|Ride"] = 1125.21}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 48.56, ["Ride"] = 91.91, ["Neon"] = 462.27, ["Neon|Ride"] = 357, ["Neon|Fly|Ride"] = 852.97, ["Mega"] = 1254.38, ["Mega|Fly|Ride"] = 1311.19}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 7.77, ["Fly"] = 190.32, ["Ride"] = 29.51, ["Fly|Ride"] = 133.88, ["Neon"] = 49.88, ["Neon|Fly"] = 129.17, ["Neon|Ride"] = 70.88, ["Neon|Fly|Ride"] = 125.98, ["Mega"] = 241.5, ["Mega|Ride"] = 242.71, ["Mega|Fly|Ride"] = 241.95}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 6.54, ["Ride"] = 45.93, ["Neon"] = 15.9, ["Neon|Ride"] = 87.55, ["Neon|Fly|Ride"] = 123.38, ["Mega"] = 97.13, ["Mega|Fly"] = 282.18, ["Mega|Ride"] = 160.15, ["Mega|Fly|Ride"] = 232.07}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 18.27, ["Fly|Ride"] = 47.16, ["Neon"] = 11.4, ["Neon|Ride"] = 24.44, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 131.25, ["Mega|Ride"] = 104.81, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 17.64, ["Ride"] = 16.09, ["Fly|Ride"] = 28.85, ["Neon"] = 2.1, ["Neon|Fly"] = 34.18, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 45.85, ["Mega"] = 26.25, ["Mega|Ride"] = 69.56, ["Mega|Fly|Ride"] = 152.25}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 18.71, ["Fly|Ride"] = 85.39, ["Neon"] = 3.66, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 39.06, ["Mega|Fly"] = 138.62, ["Mega|Ride"] = 57.19, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Neon"] = 2.24, ["Neon|Ride"] = 145.08, ["Mega"] = 32.82, ["Mega|Ride"] = 110.25, ["Mega|Fly|Ride"] = 328.02}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 4.64, ["Ride"] = 104.99, ["Neon"] = 38.97, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 402.96, ["Mega|Ride"] = 272.44, ["Mega|Fly|Ride"] = 421.7}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 9.97, ["Ride"] = 26.25, ["Fly|Ride"] = 212.36, ["Neon"] = 56.6, ["Neon|Ride"] = 101.43, ["Neon|Fly|Ride"] = 143.07, ["Mega"] = 225.62, ["Mega|Ride"] = 351.75, ["Mega|Fly|Ride"] = 482.58}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 6.56, ["Fly"] = 24.57, ["Ride"] = 18.59, ["Fly|Ride"] = 42.73, ["Neon"] = 28.88, ["Neon|Ride"] = 38.18, ["Neon|Fly|Ride"] = 84, ["Mega"] = 333.09, ["Mega|Ride"] = 311.37, ["Mega|Fly|Ride"] = 360.4}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 57.39, ["Ride"] = 98.44, ["Fly|Ride"] = 124.69, ["Neon"] = 393.75, ["Neon|Ride"] = 285.09, ["Neon|Fly|Ride"] = 712.06, ["Mega"] = 2412.86, ["Mega|Fly|Ride"] = 1472.63}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 17.55, ["Fly"] = 82.69, ["Ride"] = 58.97, ["Fly|Ride"] = 64.32, ["Neon"] = 143.07, ["Neon|Fly|Ride"] = 630, ["Mega"] = 464.63, ["Mega|Ride"] = 879.38, ["Mega|Fly|Ride"] = 1037.54}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 15.94, ["Fly|Ride"] = 40.6, ["Neon"] = 2.24, ["Neon|Fly"] = 42.72, ["Neon|Ride"] = 17.96, ["Neon|Fly|Ride"] = 56.44, ["Mega|Fly"] = 71.54, ["Mega|Ride"] = 93.44, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 14.3, ["Ride"] = 15.74, ["Fly|Ride"] = 35.14, ["Neon"] = 4.83, ["Neon|Fly"] = 28.85, ["Neon|Ride"] = 20.13, ["Neon|Fly|Ride"] = 41.58, ["Mega"] = 44.63, ["Mega|Fly"] = 128.13, ["Mega|Ride"] = 57.14, ["Mega|Fly|Ride"] = 91.88}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 367.5, ["Fly"] = 563.47, ["Ride"] = 441.83, ["Fly|Ride"] = 497.66, ["Neon|Fly|Ride"] = 1960.01, ["Mega|Fly|Ride"] = 6761.81}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 10.48, ["Fly"] = 114.28, ["Ride"] = 26.25, ["Neon"] = 45.74, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 403.5, ["Mega|Ride"] = 400.32, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 15.93, ["Ride"] = 19.23, ["Fly|Ride"] = 34.04, ["Neon"] = 3.49, ["Neon|Fly"] = 19.84, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 43.22, ["Mega"] = 44.96, ["Mega|Ride"] = 80.08, ["Mega|Fly|Ride"] = 106.46}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 42.95, ["Ride"] = 98.24, ["Fly|Ride"] = 261.19, ["Neon"] = 223.13, ["Neon|Ride"] = 261.19, ["Neon|Fly|Ride"] = 412.13, ["Mega"] = 737.62, ["Mega|Ride"] = 761.25, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 27.28, ["Ride"] = 17.06, ["Fly|Ride"] = 42.73, ["Neon"] = 10.39, ["Neon|Fly"] = 79.03, ["Neon|Ride"] = 28.85, ["Neon|Fly|Ride"] = 79.93, ["Mega"] = 124.63, ["Mega|Ride"] = 135.59, ["Mega|Fly|Ride"] = 215.23}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 71.55, ["Ride"] = 57.68, ["Fly|Ride"] = 196.88, ["Neon"] = 4.29, ["Neon|Fly"] = 96.42, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 19.68, ["Mega|Ride"] = 68.16, ["Mega|Fly|Ride"] = 209.9}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 31.43, ["Fly"] = 128.63, ["Ride"] = 78.74, ["Fly|Ride"] = 215.73, ["Neon"] = 190.16, ["Neon|Ride"] = 201.2, ["Neon|Fly|Ride"] = 287.44, ["Mega"] = 804.7, ["Mega|Ride"] = 640.57, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 19.68, ["Fly|Ride"] = 146.99, ["Neon"] = 3.94, ["Neon|Ride"] = 40.58, ["Mega"] = 38.74, ["Mega|Ride"] = 155.68, ["Mega|Fly|Ride"] = 252}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 34.18, ["Ride"] = 62.79, ["Fly|Ride"] = 105, ["Neon"] = 148.32, ["Neon|Ride"] = 249.27, ["Neon|Fly|Ride"] = 288.46, ["Mega"] = 1181.25, ["Mega|Ride"] = 1708.08, ["Mega|Fly|Ride"] = 1333.83}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 2.89, ["Fly"] = 71.55, ["Ride"] = 39.38, ["Fly|Ride"] = 121.75, ["Neon"] = 23.63, ["Neon|Ride"] = 230.9, ["Neon|Fly|Ride"] = 161.68, ["Mega"] = 169.32, ["Mega|Ride"] = 183.75}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.1, ["Fly"] = 71.55, ["Ride"] = 73.5, ["Fly|Ride"] = 71.55, ["Neon"] = 8.29, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 434.33, ["Mega"] = 104.64, ["Mega|Ride"] = 124.69, ["Mega|Fly|Ride"] = 301.06}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 41.58, ["Fly"] = 85.44, ["Ride"] = 45.94, ["Fly|Ride"] = 533.92, ["Mega|Ride"] = 1708.08, ["Mega|Fly|Ride"] = 1986.71}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 569.94, ["Ride"] = 39.38, ["Fly|Ride"] = 71.55, ["Neon"] = 6.2, ["Neon|Ride"] = 40.61, ["Neon|Fly|Ride"] = 114.23, ["Mega"] = 36.31, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 134.52, ["Mega|Fly|Ride"] = 237.01}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 24.66, ["Ride"] = 19.09, ["Fly|Ride"] = 102.88, ["Neon"] = 8.25, ["Neon|Fly"] = 42, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 60.86, ["Mega"] = 59.13, ["Mega|Fly"] = 148.41, ["Mega|Ride"] = 120.66, ["Mega|Fly|Ride"] = 219.19}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 9.07, ["Fly"] = 57.91, ["Ride"] = 35.63, ["Fly|Ride"] = 169.8, ["Neon"] = 71.55, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 149.47, ["Mega"] = 328.01, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 401.06}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 10.69, ["Fly"] = 63.19, ["Ride"] = 23.94, ["Fly|Ride"] = 65.67, ["Neon"] = 87.28, ["Neon|Ride"] = 50.19, ["Neon|Fly|Ride"] = 150.94, ["Mega"] = 410.2, ["Mega|Ride"] = 444.32, ["Mega|Fly|Ride"] = 562.61}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 34.12, ["Fly"] = 48.57, ["Ride"] = 28.38, ["Fly|Ride"] = 53.9, ["Neon"] = 78.95, ["Neon|Ride"] = 90.54, ["Neon|Fly|Ride"] = 141.72, ["Mega"] = 404.88, ["Mega|Ride"] = 323.54, ["Mega|Fly|Ride"] = 379.32}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 61.56, ["Ride"] = 123.38, ["Fly|Ride"] = 258.21, ["Neon"] = 301.88, ["Neon|Ride"] = 283.66, ["Neon|Fly|Ride"] = 427.03, ["Mega"] = 1575, ["Mega|Ride"] = 1566.1, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 6.18, ["Ride"] = 114.28, ["Fly|Ride"] = 203.44, ["Neon"] = 55.43, ["Neon|Ride"] = 113.47, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 249.38, ["Mega|Fly"] = 566.88, ["Mega|Ride"] = 354.43, ["Mega|Fly|Ride"] = 519.91}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 3.53, ["Ride"] = 27.28, ["Fly|Ride"] = 78.74, ["Neon"] = 16.04, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 285.05, ["Mega|Ride"] = 244.13, ["Mega|Fly|Ride"] = 335.99}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 9.1, ["Fly"] = 135.19, ["Ride"] = 36.27, ["Fly|Ride"] = 115.5, ["Neon"] = 57.63, ["Neon|Ride"] = 57.67, ["Mega"] = 421.7, ["Mega|Ride"] = 640.54, ["Mega|Fly|Ride"] = 789.99}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 13.13, ["Fly|Ride"] = 39.74, ["Neon"] = 2.1, ["Neon|Fly"] = 21.69, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 15.63, ["Mega|Ride"] = 26.78, ["Mega|Fly|Ride"] = 96.01}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 48.46, ["Fly"] = 226.4, ["Ride"] = 121.75, ["Fly|Ride"] = 131.25, ["Neon"] = 234.94, ["Neon|Fly"] = 2420.42, ["Neon|Ride"] = 293.99, ["Neon|Fly|Ride"] = 1287.27, ["Mega"] = 1064.35, ["Mega|Ride"] = 945, ["Mega|Fly|Ride"] = 905.63}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 21.29, ["Neon"] = 5.25, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 31.39, ["Mega|Ride"] = 143.07, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 28.85, ["Ride"] = 17.59, ["Fly|Ride"] = 45.94, ["Neon"] = 18.38, ["Neon|Ride"] = 25.54, ["Neon|Fly|Ride"] = 71.54, ["Mega"] = 257.25, ["Mega|Ride"] = 193.04, ["Mega|Fly|Ride"] = 228.38}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 63.56, ["Fly"] = 71.6, ["Ride"] = 67.7, ["Fly|Ride"] = 258.57, ["Neon"] = 207.89, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 370.44, ["Mega"] = 940.75, ["Mega|Ride"] = 1110.25, ["Mega|Fly|Ride"] = 984.38}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 28.85, ["Fly|Ride"] = 43.32, ["Neon"] = 9.19, ["Neon|Ride"] = 32.82, ["Mega"] = 80.08, ["Mega|Ride"] = 111.2, ["Mega|Fly|Ride"] = 249.37}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 6.42}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 24.47, ["Fly|Ride"] = 123.87, ["Neon"] = 6.49, ["Neon|Ride"] = 84.54, ["Neon|Fly|Ride"] = 114.23, ["Mega"] = 63.67, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 131.08, ["Ride"] = 180.55, ["Fly|Ride"] = 335.31, ["Neon"] = 712.23, ["Neon|Ride"] = 611.23, ["Neon|Fly|Ride"] = 665.05, ["Mega"] = 6405.25, ["Mega|Ride"] = 3217.55, ["Mega|Fly|Ride"] = 2603.74}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 2.63, ["Ride"] = 36.32, ["Fly|Ride"] = 120.66, ["Neon"] = 21.95, ["Neon|Fly"] = 143.09, ["Neon|Ride"] = 64.07, ["Neon|Fly|Ride"] = 219.43, ["Mega"] = 178.39, ["Mega|Ride"] = 206.85, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 26.24, ["Neon"] = 3.94, ["Neon|Ride"] = 24.43, ["Mega"] = 32.45, ["Mega|Ride"] = 71.54, ["Mega|Fly|Ride"] = 314.94}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 3.93, ["Fly"] = 39.38, ["Ride"] = 31.5, ["Fly|Ride"] = 65.63, ["Neon"] = 55.95, ["Neon|Ride"] = 88.61, ["Neon|Fly|Ride"] = 153.74, ["Mega"] = 427.03, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 639.47}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 8.56, ["Fly"] = 56.74, ["Ride"] = 21.37, ["Fly|Ride"] = 56.58, ["Neon"] = 72.19, ["Neon|Ride"] = 158.04, ["Neon|Fly|Ride"] = 309.1, ["Mega"] = 619.8, ["Mega|Ride"] = 597.84, ["Mega|Fly|Ride"] = 356.57}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 20.99, ["Ride"] = 59.07, ["Neon"] = 164.11, ["Neon|Ride"] = 187.8, ["Neon|Fly|Ride"] = 1575, ["Mega"] = 561.75, ["Mega|Ride"] = 553.25, ["Mega|Fly|Ride"] = 599.82}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 128.15, ["Fly"] = 177.19, ["Ride"] = 167.88, ["Fly|Ride"] = 228.27, ["Neon"] = 547.8, ["Neon|Fly"] = 684.36, ["Neon|Ride"] = 493.77, ["Neon|Fly|Ride"] = 570.08, ["Mega|Ride"] = 2562.11, ["Mega|Fly|Ride"] = 2220.49}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 6.01, ["Fly"] = 21, ["Ride"] = 18.27, ["Fly|Ride"] = 47.16, ["Neon"] = 41.36, ["Neon|Fly"] = 53.4, ["Neon|Ride"] = 40.6, ["Neon|Fly|Ride"] = 90.57, ["Mega|Ride"] = 341.62, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.39, ["Fly"] = 131.23, ["Ride"] = 23.5, ["Fly|Ride"] = 131.25, ["Neon"] = 18.27, ["Neon|Fly"] = 42.72, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 151.61, ["Mega|Ride"] = 161.68, ["Mega|Fly|Ride"] = 211.51}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 4.27, ["Fly"] = 42.35, ["Ride"] = 28.85, ["Fly|Ride"] = 128.15, ["Neon"] = 47.25, ["Neon|Fly"] = 128.63, ["Neon|Ride"] = 46.77, ["Neon|Fly|Ride"] = 161.68, ["Mega"] = 427.03, ["Mega|Ride"] = 439.84, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 46.56, ["Fly"] = 113.21, ["Ride"] = 78.44, ["Fly|Ride"] = 134.37, ["Neon"] = 202.13, ["Neon|Ride"] = 226.21, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 955.47, ["Mega|Ride"] = 925.32, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 18.26, ["Fly"] = 57.75, ["Ride"] = 131.25, ["Neon"] = 174.98, ["Neon|Ride"] = 217.16, ["Neon|Fly|Ride"] = 470.8, ["Mega"] = 1049.9, ["Mega|Ride"] = 997.11, ["Mega|Fly|Ride"] = 632.19}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 327.51, ["Ride"] = 570.22, ["Neon|Ride"] = 3217.55}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 18.37, ["Fly"] = 61.94, ["Ride"] = 33.12, ["Fly|Ride"] = 69.57, ["Neon"] = 247.74, ["Neon|Ride"] = 212.48, ["Neon|Fly|Ride"] = 322.13, ["Mega"] = 761.25, ["Mega|Ride"] = 738.27, ["Mega|Fly|Ride"] = 997.11}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 42.6, ["Ride"] = 16.04, ["Fly|Ride"] = 31.5, ["Neon"] = 2.1, ["Neon|Ride"] = 18.18, ["Neon|Fly|Ride"] = 53.45, ["Mega"] = 18.09, ["Mega|Fly"] = 111.04, ["Mega|Ride"] = 41.06, ["Mega|Fly|Ride"] = 114.03}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 2.1, ["Ride"] = 41.19, ["Neon"] = 8.54, ["Neon|Ride"] = 42.72, ["Neon|Fly|Ride"] = 143.07, ["Mega"] = 103.49, ["Mega|Ride"] = 164.18, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 2.24, ["Fly"] = 31.92, ["Ride"] = 26.25, ["Fly|Ride"] = 126, ["Neon"] = 19.04, ["Neon|Fly"] = 87.94, ["Neon|Ride"] = 48.55, ["Neon|Fly|Ride"] = 1181.23, ["Mega"] = 133.62, ["Mega|Fly"] = 498.57, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 341.92}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 393.74, ["Fly"] = 498.67, ["Ride"] = 418.69, ["Fly|Ride"] = 518.41, ["Neon"] = 1898.49, ["Neon|Ride"] = 2092.9, ["Neon|Fly|Ride"] = 1246.88, ["Mega|Fly|Ride"] = 5508.51}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.1, ["Fly"] = 37.97, ["Ride"] = 16.22, ["Fly|Ride"] = 45.95, ["Neon"] = 17.1, ["Neon|Ride"] = 55.98, ["Neon|Fly|Ride"] = 97.46, ["Mega"] = 196.77, ["Mega|Ride"] = 213.94, ["Mega|Fly|Ride"] = 231}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 3.86, ["Fly"] = 21.36, ["Ride"] = 18.17, ["Fly|Ride"] = 42, ["Neon"] = 27.71, ["Neon|Fly"] = 33.12, ["Neon|Ride"] = 59.79, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 144.79, ["Mega|Ride"] = 289.31, ["Mega|Fly|Ride"] = 276.94}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 2.63, ["Fly"] = 45.71, ["Ride"] = 23.63, ["Fly|Ride"] = 61.25, ["Neon"] = 15.58, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 108.5, ["Mega"] = 131.25, ["Mega|Ride"] = 175.88, ["Mega|Fly|Ride"] = 236.24}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 30.08, ["Fly"] = 48.27, ["Ride"] = 32.82, ["Fly|Ride"] = 65.63, ["Neon"] = 220.4, ["Neon|Ride"] = 196.86, ["Neon|Fly|Ride"] = 319.22, ["Mega"] = 712.06, ["Mega|Ride"] = 854.05, ["Mega|Fly|Ride"] = 629.87}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 53.41, ["Ride"] = 34.13, ["Fly|Ride"] = 51.85, ["Neon"] = 11.59, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 163.74, ["Mega|Ride"] = 457.79, ["Mega|Fly|Ride"] = 1011.29}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 6.57, ["Fly"] = 65.61, ["Ride"] = 28.86, ["Fly|Ride"] = 78.75, ["Neon"] = 168.9, ["Neon|Ride"] = 183.74, ["Mega"] = 530.14, ["Mega|Fly|Ride"] = 774.38}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 20.9, ["Neon"] = 3.93, ["Neon|Ride"] = 28.85, ["Mega"] = 54.74, ["Mega|Ride"] = 122.79, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 3.93, ["Fly"] = 72.19, ["Ride"] = 143.1, ["Neon"] = 18.11, ["Mega"] = 134.66, ["Mega|Ride"] = 322.13, ["Mega|Fly|Ride"] = 720.57}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 7.88, ["Ride"] = 64.08, ["Neon"] = 64.32, ["Neon|Ride"] = 285.05, ["Mega"] = 314.94, ["Mega|Ride"] = 554.07, ["Mega|Fly|Ride"] = 463.32}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 8.55, ["Fly"] = 28.85, ["Ride"] = 22.31, ["Fly|Ride"] = 39.38, ["Neon"] = 49.87, ["Neon|Fly"] = 114.26, ["Neon|Ride"] = 54.51, ["Neon|Fly|Ride"] = 120.75, ["Mega|Ride"] = 323.54, ["Mega|Fly|Ride"] = 447.03}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 367.4, ["Fly"] = 516.5, ["Ride"] = 433.61, ["Fly|Ride"] = 432.11, ["Neon"] = 1642.41, ["Neon|Ride"] = 1836.4, ["Neon|Fly|Ride"] = 1640.63}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 15.75, ["Fly|Ride"] = 28.85, ["Neon"] = 35.09, ["Neon|Fly"] = 80.89, ["Neon|Ride"] = 32.28, ["Neon|Fly|Ride"] = 158.17, ["Mega"] = 228.46, ["Mega|Ride"] = 196.77, ["Mega|Fly|Ride"] = 302.82}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 6.44, ["Fly"] = 64.08, ["Ride"] = 21.37, ["Fly|Ride"] = 185.81, ["Neon"] = 57.6, ["Neon|Ride"] = 122.03, ["Neon|Fly|Ride"] = 185.77, ["Mega"] = 308.44, ["Mega|Fly"] = 712.06, ["Mega|Ride"] = 415.8, ["Mega|Fly|Ride"] = 1066.49}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 22.31, ["Fly"] = 87.67, ["Ride"] = 84.62, ["Fly|Ride"] = 320.36, ["Neon"] = 78.66, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 425.97, ["Mega"] = 310.08, ["Mega|Ride"] = 362.25, ["Mega|Fly|Ride"] = 498.95}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 57.62, ["Fly"] = 146.87, ["Ride"] = 72.19, ["Fly|Ride"] = 106.8, ["Neon"] = 321.57, ["Neon|Ride"] = 334.69, ["Neon|Fly|Ride"] = 380.63, ["Mega"] = 2492.09, ["Mega|Ride"] = 1794.55, ["Mega|Fly|Ride"] = 1762.07}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 9.17, ["Ride"] = 37.4, ["Fly|Ride"] = 143.1, ["Neon"] = 31.11, ["Neon|Ride"] = 94.43, ["Neon|Fly|Ride"] = 228.46, ["Mega"] = 170.63, ["Mega|Ride"] = 181.55, ["Mega|Fly|Ride"] = 353.39}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 21.37, ["Ride"] = 19.59, ["Fly|Ride"] = 59.07, ["Neon"] = 18, ["Neon|Ride"] = 33.53, ["Neon|Fly|Ride"] = 130.6, ["Mega"] = 65.62, ["Mega|Ride"] = 176.16, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 3.93, ["Ride"] = 33.12, ["Neon"] = 18.38, ["Neon|Ride"] = 106.77, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 114.19, ["Mega|Fly"] = 242.34, ["Mega|Ride"] = 139.09, ["Mega|Fly|Ride"] = 285.66}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 40.69, ["Fly"] = 137.82, ["Ride"] = 85.68, ["Fly|Ride"] = 170.63, ["Neon"] = 124.69, ["Neon|Ride"] = 162.75, ["Neon|Fly|Ride"] = 210, ["Mega"] = 439.69, ["Mega|Ride"] = 455.32, ["Mega|Fly|Ride"] = 563.07}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.1, ["Ride"] = 82.72, ["Neon"] = 6.3, ["Neon|Ride"] = 101.07, ["Neon|Fly|Ride"] = 200.82, ["Mega"] = 45.91, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 283.5}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 38.07, ["Ride"] = 213.59, ["Neon"] = 131.25, ["Mega"] = 598.5, ["Mega|Fly|Ride"] = 777.18}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 974.53, ["Fly"] = 1004.07, ["Ride"] = 1006.69, ["Fly|Ride"] = 1095.84, ["Neon|Ride"] = 3466.73, ["Neon|Fly|Ride"] = 3463.1, ["Mega|Fly|Ride"] = 10818.45}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 8.56, ["Fly"] = 39.38, ["Ride"] = 41.47, ["Fly|Ride"] = 173.25, ["Neon"] = 64.31, ["Neon|Fly"] = 711.09, ["Neon|Ride"] = 163.78, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 361.95, ["Mega|Ride"] = 328.27, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.1, ["Fly"] = 49.37, ["Ride"] = 19.68, ["Fly|Ride"] = 90.57, ["Neon"] = 9.19, ["Neon|Ride"] = 32.71, ["Neon|Fly|Ride"] = 90.98, ["Mega"] = 77.35, ["Mega|Ride"] = 80.76, ["Mega|Fly|Ride"] = 183.6}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 8.51, ["Ride"] = 99.75, ["Fly|Ride"] = 143.1, ["Neon"] = 60.34, ["Neon|Fly|Ride"] = 393.73, ["Mega"] = 288.73, ["Mega|Ride"] = 425.81, ["Mega|Fly|Ride"] = 480.17}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 23.15, ["Fly|Ride"] = 185.81, ["Neon"] = 3.14, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 17.07, ["Mega|Ride"] = 47.7, ["Mega|Fly|Ride"] = 140.44}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 50.96, ["Ride"] = 100.69, ["Fly|Ride"] = 236.25, ["Neon"] = 208.58, ["Neon|Ride"] = 253.16, ["Neon|Fly|Ride"] = 405.42, ["Mega"] = 1106.35, ["Mega|Ride"] = 827.54, ["Mega|Fly|Ride"] = 918.49}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 6.41, ["Ride"] = 52.5, ["Fly|Ride"] = 283.87, ["Neon"] = 104.81, ["Neon|Ride"] = 152.1, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 418.69, ["Mega|Ride"] = 806.01, ["Mega|Fly|Ride"] = 723.19}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 8.37, ["Neon|Ride"] = 28.46, ["Neon|Fly|Ride"] = 96.52, ["Mega"] = 94.06, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 370.44}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 14.44, ["Fly"] = 52.5, ["Ride"] = 35.63, ["Fly|Ride"] = 65.63, ["Neon"] = 57.66, ["Neon|Fly"] = 72.19, ["Neon|Ride"] = 91.58, ["Neon|Fly|Ride"] = 263.38, ["Mega"] = 409.17, ["Mega|Ride"] = 405.68, ["Mega|Fly|Ride"] = 392.44}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 6.57, ["Fly"] = 96.11, ["Ride"] = 31.49, ["Fly|Ride"] = 80.85, ["Neon"] = 143.1, ["Neon|Fly"] = 129.17, ["Neon|Ride"] = 72.4, ["Neon|Fly|Ride"] = 144.18, ["Mega"] = 414.6, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 516.36}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 35.44, ["Ride"] = 208.69, ["Neon"] = 249.87, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 669.38, ["Mega"] = 2091.95, ["Mega|Ride"] = 2412.86, ["Mega|Fly|Ride"] = 2132.96}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 3.7, ["Ride"] = 57.68, ["Fly|Ride"] = 255.05, ["Neon"] = 14.44, ["Neon|Ride"] = 79.02, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 57.74, ["Mega|Ride"] = 123.4, ["Mega|Fly|Ride"] = 228.06}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 7.87, ["Ride"] = 21.73, ["Fly|Ride"] = 89.25, ["Neon"] = 45.39, ["Neon|Fly"] = 185.79, ["Neon|Ride"] = 63.82, ["Neon|Fly|Ride"] = 158.01, ["Mega"] = 286.51, ["Mega|Ride"] = 351.75, ["Mega|Fly|Ride"] = 712.06}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 115.37, ["Fly"] = 393.75, ["Ride"] = 128.14, ["Fly|Ride"] = 236.25, ["Neon"] = 420.2, ["Neon|Ride"] = 511.77, ["Neon|Fly|Ride"] = 669.38, ["Mega"] = 2326.19, ["Mega|Ride"] = 2348.59, ["Mega|Fly|Ride"] = 2067.19}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 24.94, ["Ride"] = 15.89, ["Fly|Ride"] = 31.5, ["Neon"] = 10.39, ["Neon|Fly"] = 57.32, ["Neon|Ride"] = 33.99, ["Neon|Fly|Ride"] = 80.08, ["Mega"] = 145.69, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 14.17, ["Fly"] = 200.82, ["Ride"] = 41.32, ["Fly|Ride"] = 118.13, ["Neon"] = 87.94, ["Neon|Ride"] = 106.73, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 454.78, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 18.27, ["Ride"] = 14.81, ["Fly|Ride"] = 62.99, ["Neon"] = 2.1, ["Neon|Fly"] = 28.25, ["Neon|Ride"] = 16.83, ["Neon|Fly|Ride"] = 57.67, ["Mega"] = 14.36, ["Mega|Fly"] = 50.69, ["Mega|Ride"] = 45.93, ["Mega|Fly|Ride"] = 80.07}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 57.68, ["Neon"] = 3.93, ["Neon|Ride"] = 42.72, ["Neon|Fly|Ride"] = 128.13, ["Mega"] = 19.28, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 57.67, ["Mega|Fly|Ride"] = 170.82}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.1, ["Fly"] = 36.32, ["Ride"] = 19.08, ["Fly|Ride"] = 173.25, ["Neon"] = 14.56, ["Neon|Ride"] = 55.55, ["Neon|Fly|Ride"] = 100.36, ["Mega"] = 99.35, ["Mega|Ride"] = 285.05, ["Mega|Fly|Ride"] = 246.1}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 28.77, ["Ride"] = 59.07, ["Fly|Ride"] = 131.25, ["Neon"] = 128.63, ["Neon|Ride"] = 341.67, ["Neon|Fly|Ride"] = 433.13, ["Mega"] = 506.76, ["Mega|Ride"] = 639.47}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.1, ["Fly"] = 15.65, ["Ride"] = 15.65, ["Fly|Ride"] = 34.11, ["Neon"] = 9.64, ["Neon|Fly"] = 24.15, ["Neon|Ride"] = 30.98, ["Neon|Fly|Ride"] = 61.35, ["Mega"] = 114.35, ["Mega|Fly"] = 267.22, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 145.69}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 8.52, ["Fly"] = 32.5, ["Ride"] = 32.55, ["Fly|Ride"] = 106.8, ["Neon"] = 24.94, ["Neon|Fly"] = 84.9, ["Neon|Ride"] = 36.21, ["Neon|Fly|Ride"] = 102.38, ["Mega"] = 236.15, ["Mega|Fly"] = 433.13, ["Mega|Ride"] = 251.9, ["Mega|Fly|Ride"] = 326.94}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Fly"] = 21.37, ["Ride"] = 18.11, ["Fly|Ride"] = 67.92, ["Neon"] = 11.33, ["Neon|Fly"] = 98.44, ["Neon|Ride"] = 24.86, ["Neon|Fly|Ride"] = 89.24, ["Mega"] = 47.25, ["Mega|Fly"] = 80.76, ["Mega|Ride"] = 58.47, ["Mega|Fly|Ride"] = 127.79}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 9.17, ["Fly"] = 161.24, ["Ride"] = 24.43, ["Fly|Ride"] = 217.2, ["Neon"] = 29.87, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 285.05, ["Mega"] = 292.68, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 392.87, ["Mega|Fly|Ride"] = 413.16}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 5.23, ["Ride"] = 32.82, ["Fly|Ride"] = 142.38, ["Neon"] = 48.66, ["Neon|Ride"] = 143.07, ["Neon|Fly|Ride"] = 257.28, ["Mega"] = 320.28, ["Mega|Ride"] = 303.19, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 4.29, ["Fly"] = 37.7, ["Ride"] = 16.21, ["Fly|Ride"] = 50.72, ["Neon"] = 30.79, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 39.45, ["Neon|Fly|Ride"] = 171.94, ["Mega"] = 262.5, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 296.69, ["Mega|Fly|Ride"] = 570.08}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 24.86, ["Ride"] = 17, ["Fly|Ride"] = 52.41, ["Neon"] = 15.44, ["Neon|Fly"] = 28.85, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 186.83, ["Mega|Ride"] = 102.37, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 229.67, ["Fly"] = 393.75, ["Ride"] = 255.94, ["Fly|Ride"] = 392.43, ["Neon"] = 1254.81, ["Neon|Ride"] = 1230.57, ["Neon|Fly|Ride"] = 1174.69, ["Mega"] = 4182.69, ["Mega|Fly|Ride"] = 4495.32}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 3.44, ["Ride"] = 65.63, ["Neon"] = 21.27, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 570.08, ["Mega"] = 123.38, ["Mega|Ride"] = 644.24, ["Mega|Fly|Ride"] = 356.57}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 2.1, ["Fly"] = 106.8, ["Ride"] = 24.69, ["Fly|Ride"] = 85.44, ["Neon"] = 26.56, ["Neon|Fly"] = 242.38, ["Neon|Ride"] = 57.67, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 228.8, ["Mega|Ride"] = 194.9, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 2.1, ["Fly|Ride"] = 213.5, ["Neon"] = 37.55, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 603.74, ["Mega"] = 479.73, ["Mega|Ride"] = 402.6, ["Mega|Fly|Ride"] = 416.73}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 16.17, ["Ride"] = 13.02, ["Fly|Ride"] = 32.71, ["Neon"] = 2.1, ["Neon|Fly"] = 42.72, ["Neon|Ride"] = 17.1, ["Neon|Fly|Ride"] = 44.61, ["Mega"] = 18.38, ["Mega|Fly"] = 79.02, ["Mega|Ride"] = 42.14, ["Mega|Fly|Ride"] = 70.01}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 19.69, ["Fly|Ride"] = 57.75, ["Neon"] = 16.02, ["Neon|Ride"] = 30.17, ["Neon|Fly|Ride"] = 105, ["Mega"] = 132.57, ["Mega|Ride"] = 128.13, ["Mega|Fly|Ride"] = 216.46}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.1, ["Ride"] = 119.85, ["Neon"] = 9.19, ["Neon|Ride"] = 284.01, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 39.38, ["Mega|Ride"] = 167.99, ["Mega|Fly|Ride"] = 276.94}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 72.18, ["Fly"] = 104.99, ["Ride"] = 95.82, ["Fly|Ride"] = 125.99, ["Neon"] = 409.5, ["Neon|Fly"] = 482.81, ["Neon|Ride"] = 368.82, ["Neon|Fly|Ride"] = 426.57, ["Mega|Ride"] = 3560.26, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 3.57, ["Fly"] = 71.55, ["Ride"] = 26.17, ["Fly|Ride"] = 141.75, ["Neon"] = 27.77, ["Neon|Ride"] = 67.48, ["Neon|Fly|Ride"] = 161.68, ["Mega"] = 161.68, ["Mega|Ride"] = 248.76, ["Mega|Fly|Ride"] = 424.9}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 49.13, ["Ride"] = 34.12, ["Neon"] = 6.45, ["Neon|Ride"] = 80.85, ["Neon|Fly|Ride"] = 143.07, ["Mega"] = 66.94, ["Mega|Fly"] = 314.99, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 46.73, ["Fly"] = 131.25, ["Ride"] = 78.75, ["Fly|Ride"] = 199.49, ["Neon"] = 196.88, ["Neon|Ride"] = 195.82, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 492.19, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 668.07}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 28.75, ["Ride"] = 13.64, ["Fly|Ride"] = 31.5, ["Neon"] = 2.1, ["Neon|Fly"] = 21.74, ["Neon|Ride"] = 16.04, ["Neon|Fly|Ride"] = 43.23, ["Mega"] = 20.15, ["Mega|Fly"] = 45.49, ["Mega|Ride"] = 34.13, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 33.73, ["Neon"] = 3.93, ["Neon|Ride"] = 30.18, ["Neon|Fly|Ride"] = 71.54, ["Mega"] = 23.63, ["Mega|Ride"] = 61.55, ["Mega|Fly|Ride"] = 186.94}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 61.85, ["Neon"] = 6.33, ["Neon|Ride"] = 120.71, ["Neon|Fly|Ride"] = 143.07, ["Mega"] = 36.3, ["Mega|Fly"] = 185.77, ["Mega|Ride"] = 117.29}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 7.87, ["Fly"] = 100.38, ["Ride"] = 45.14, ["Fly|Ride"] = 127.32, ["Neon"] = 21.37, ["Neon|Ride"] = 89.91, ["Neon|Fly|Ride"] = 158.01, ["Mega"] = 125.88, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 184.7, ["Mega|Fly|Ride"] = 314.22}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 21.29, ["Ride"] = 13.8, ["Fly|Ride"] = 37.68, ["Neon"] = 2.1, ["Neon|Fly"] = 24.55, ["Neon|Ride"] = 28.85, ["Neon|Fly|Ride"] = 48.71, ["Mega"] = 18.27, ["Mega|Ride"] = 42, ["Mega|Fly|Ride"] = 117.48}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 19.05, ["Fly"] = 131.25, ["Ride"] = 52.5, ["Neon"] = 128.14, ["Neon|Ride"] = 202.57, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 708.86, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 772.13}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2562.72, ["Fly"] = 3150, ["Ride"] = 2464.88, ["Fly|Ride"] = 2506.88, ["Neon|Fly|Ride"] = 7415.63, ["Mega|Fly|Ride"] = 44302.88}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 21.36, ["Ride"] = 15.94, ["Fly|Ride"] = 36.32, ["Neon"] = 3.94, ["Neon|Fly"] = 65.19, ["Neon|Ride"] = 23, ["Neon|Fly|Ride"] = 55.27, ["Mega"] = 70.01, ["Mega|Fly"] = 427.03, ["Mega|Ride"] = 94.12, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.1, ["Ride"] = 27.78, ["Neon"] = 8.81, ["Mega"] = 107.01, ["Mega|Fly"] = 441, ["Mega|Ride"] = 161.68, ["Mega|Fly|Ride"] = 446.44}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 12.88, ["Fly"] = 143.1, ["Ride"] = 26.25, ["Fly|Ride"] = 131.25, ["Neon"] = 79.26, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 229.69, ["Mega"] = 567.95, ["Mega|Ride"] = 431.82, ["Mega|Fly|Ride"] = 544.69}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 27.56, ["Fly"] = 106.8, ["Ride"] = 65.99, ["Neon"] = 161.44, ["Neon|Ride"] = 190.32, ["Mega"] = 548.56, ["Mega|Ride"] = 610.64, ["Mega|Fly|Ride"] = 712.06}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 128.15, ["Fly"] = 1424.45, ["Ride"] = 157.39, ["Fly|Ride"] = 256.29, ["Neon"] = 1205.33, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 652.32, ["Mega"] = 6405.25, ["Mega|Fly|Ride"] = 4052.4}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 4.94, ["Ride"] = 65.54, ["Fly|Ride"] = 675.94, ["Neon"] = 24.14, ["Neon|Ride"] = 143.09, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 143.07, ["Mega|Fly|Ride"] = 427.03}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 36.32, ["Neon"] = 12.92, ["Neon|Ride"] = 114.85, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 179.82, ["Mega|Ride"] = 330.75, ["Mega|Fly|Ride"] = 267.09}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Fly"] = 100.33, ["Ride"] = 28.86, ["Fly|Ride"] = 74.76, ["Neon"] = 10.39, ["Neon|Fly"] = 114.26, ["Neon|Ride"] = 31.49, ["Mega"] = 61.13, ["Mega|Ride"] = 113.8, ["Mega|Fly|Ride"] = 203.44}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 10.58, ["Ride"] = 50.74, ["Fly|Ride"] = 131.25, ["Neon"] = 108.12, ["Neon|Ride"] = 176.16, ["Neon|Fly|Ride"] = 502.83, ["Mega"] = 420, ["Mega|Ride"] = 451.59, ["Mega|Fly|Ride"] = 584.73}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 27.77, ["Mega"] = 26.25, ["Mega|Fly"] = 120.66, ["Mega|Ride"] = 91.77, ["Mega|Fly|Ride"] = 135.19}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 90.95, ["Fly"] = 170.71, ["Ride"] = 105, ["Fly|Ride"] = 137.45, ["Neon"] = 301.46, ["Neon|Fly"] = 456.98, ["Neon|Ride"] = 403.31, ["Neon|Fly|Ride"] = 417.09, ["Mega"] = 1215.94, ["Mega|Fly|Ride"] = 1866.36}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Fly"] = 28.85, ["Ride"] = 91.84, ["Fly|Ride"] = 59.07, ["Neon"] = 5.77, ["Neon|Ride"] = 143.09, ["Mega"] = 62.37, ["Mega|Ride"] = 276.29, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 40.69, ["Fly"] = 143.09, ["Ride"] = 85.22, ["Fly|Ride"] = 170.62, ["Neon"] = 255.94, ["Neon|Ride"] = 229.69, ["Neon|Fly|Ride"] = 532.05, ["Mega"] = 2625, ["Mega|Ride"] = 1708.08, ["Mega|Fly|Ride"] = 1851.13}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 21.29, ["Fly|Ride"] = 51.76, ["Neon"] = 3.94, ["Neon|Fly"] = 84.5, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 84, ["Mega"] = 54.57, ["Mega|Ride"] = 103.69, ["Mega|Fly|Ride"] = 144.27}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Neon"] = 10.5, ["Neon|Ride"] = 111.57, ["Mega"] = 47.25, ["Mega|Fly|Ride"] = 451.22}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 6.47, ["Fly"] = 77.43, ["Ride"] = 28.85, ["Neon"] = 22.32, ["Neon|Ride"] = 72.45, ["Mega"] = 427.03, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 567.95}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 343.87, ["Fly"] = 498.67, ["Ride"] = 409.5, ["Fly|Ride"] = 490.88, ["Neon"] = 918.75, ["Neon|Ride"] = 980.44, ["Neon|Fly|Ride"] = 1102.5, ["Mega"] = 2756.25, ["Mega|Ride"] = 3037.02, ["Mega|Fly|Ride"] = 2909.73}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 32.6, ["Fly"] = 85.44, ["Ride"] = 45.75, ["Fly|Ride"] = 105.73, ["Neon"] = 183.75, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 276.5, ["Mega|Ride"] = 1131.61, ["Mega|Fly|Ride"] = 1048.34}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 26.25, ["Fly|Ride"] = 111.57, ["Neon"] = 14.44, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 35.75, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 129.94, ["Mega|Ride"] = 262.47, ["Mega|Fly|Ride"] = 314.9}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 23.62, ["Fly"] = 109.01, ["Ride"] = 61.95, ["Fly|Ride"] = 175.13, ["Neon"] = 65.54, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 240.19, ["Mega"] = 310.55, ["Mega|Fly"] = 992.91, ["Mega|Ride"] = 457.26, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 4.9, ["Ride"] = 28.75, ["Neon"] = 101.36, ["Neon|Ride"] = 122.07, ["Neon|Fly|Ride"] = 356.57, ["Mega"] = 393.75, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 311.07}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.66, ["Neon"] = 17.07, ["Mega"] = 91.88, ["Mega|Ride"] = 285.05, ["Mega|Fly|Ride"] = 413.16}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.1, ["Fly"] = 71.55, ["Ride"] = 19.63, ["Fly|Ride"] = 65.62, ["Neon"] = 18.11, ["Neon|Fly"] = 80.09, ["Neon|Ride"] = 50.19, ["Neon|Fly|Ride"] = 212.14, ["Mega"] = 210, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 85.2, ["Ride"] = 115.5, ["Fly|Ride"] = 199.69, ["Neon"] = 797.66, ["Neon|Ride"] = 523.68, ["Neon|Fly|Ride"] = 524.99, ["Mega"] = 2887.5, ["Mega|Ride"] = 2625, ["Mega|Fly|Ride"] = 2976.27}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 18.77, ["Ride"] = 39.38, ["Fly|Ride"] = 131.25, ["Neon"] = 157.38, ["Neon|Ride"] = 170.82, ["Neon|Fly|Ride"] = 314.94, ["Mega"] = 1105.91, ["Mega|Ride"] = 699.75, ["Mega|Fly|Ride"] = 731.07}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2034.38, ["Fly"] = 2311.32, ["Ride"] = 2060.63, ["Fly|Ride"] = 2033.05, ["Neon"] = 11390.16, ["Neon|Fly|Ride"] = 7019.25, ["Mega|Fly|Ride"] = 23622.92}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 4.81, ["Fly"] = 65625, ["Ride"] = 57.68, ["Fly|Ride"] = 196.87, ["Neon"] = 20.31, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 105, ["Mega"] = 116.74, ["Mega|Fly"] = 786.19, ["Mega|Ride"] = 195.07, ["Mega|Fly|Ride"] = 439.84}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 8.06, ["Ride"] = 48.57, ["Fly|Ride"] = 178.34, ["Neon"] = 24.73, ["Neon|Ride"] = 90.46, ["Mega"] = 131.25, ["Mega|Fly"] = 271.17, ["Mega|Ride"] = 164.48, ["Mega|Fly|Ride"] = 252.13}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 826.88, ["Fly"] = 1481.04, ["Ride"] = 894.81, ["Fly|Ride"] = 989.63, ["Neon"] = 2778.57, ["Neon|Ride"] = 2821.88, ["Neon|Fly|Ride"] = 2805.21, ["Mega|Fly|Ride"] = 14804.65}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 27.45, ["Ride"] = 51.19, ["Fly|Ride"] = 173.35, ["Neon"] = 185.81, ["Neon|Ride"] = 174.87, ["Mega"] = 843.3, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 835.42}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 2.1, ["Ride"] = 23.63, ["Fly|Ride"] = 128.15, ["Neon"] = 9.09, ["Neon|Ride"] = 64.84, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 157.48, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 143.1, ["Neon"] = 3.48, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 111.04, ["Mega"] = 23.22, ["Mega|Ride"] = 61.31, ["Mega|Fly|Ride"] = 157.4}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 78.74, ["Ride"] = 130.69, ["Fly|Ride"] = 170.63, ["Neon"] = 459.38, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 634.1, ["Mega"] = 2412.86, ["Mega|Fly|Ride"] = 2263.21}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 2.1, ["Ride"] = 34.18, ["Fly|Ride"] = 74.46, ["Neon"] = 11.82, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 105.28, ["Mega|Ride"] = 122.07, ["Mega|Fly|Ride"] = 249.57}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 73.5, ["Fly"] = 143.1, ["Ride"] = 102.08, ["Fly|Ride"] = 242.41, ["Neon"] = 427.13, ["Neon|Ride"] = 721.88, ["Mega|Fly|Ride"] = 1739.68}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 7.25, ["Fly"] = 105, ["Fly|Ride"] = 128.15, ["Neon"] = 39.38, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 269.06, ["Mega"] = 328.02, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 233.89, ["Ride"] = 262.5, ["Fly|Ride"] = 311.97, ["Neon"] = 1137.32, ["Neon|Fly"] = 1046.46, ["Neon|Ride"] = 1062.34, ["Neon|Fly|Ride"] = 879.16, ["Mega|Fly|Ride"] = 3842.08}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 2.1, ["Fly"] = 91.88, ["Ride"] = 21.37, ["Fly|Ride"] = 103.93, ["Neon"] = 29.29, ["Neon|Ride"] = 55.13, ["Neon|Fly|Ride"] = 114.19, ["Mega"] = 196.88, ["Mega|Ride"] = 250.22, ["Mega|Fly|Ride"] = 276.4}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 20.1, ["Ride"] = 15.65, ["Fly|Ride"] = 35.89, ["Neon"] = 3.71, ["Neon|Fly"] = 20.79, ["Neon|Ride"] = 24.13, ["Neon|Fly|Ride"] = 42.72, ["Mega"] = 43.41, ["Mega|Fly"] = 64.07, ["Mega|Ride"] = 70.37, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 1230.11, ["Ride"] = 1050, ["Fly|Ride"] = 1254.2, ["Neon|Ride"] = 7830.29, ["Neon|Fly|Ride"] = 6618.75, ["Mega"] = 24128.51, ["Mega|Fly|Ride"] = 28468.07}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 14.9, ["Fly"] = 997.34, ["Ride"] = 72.19, ["Neon"] = 92.26, ["Neon|Ride"] = 311.76, ["Mega"] = 310.71, ["Mega|Ride"] = 404.54, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 6.41, ["Fly"] = 28.85, ["Ride"] = 39.38, ["Fly|Ride"] = 70.19, ["Neon"] = 24.93, ["Neon|Fly"] = 101.43, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 105, ["Mega"] = 141.15, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 282.19}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 28.87, ["Fly"] = 42.73, ["Ride"] = 38.58, ["Fly|Ride"] = 76.48, ["Neon"] = 241.32, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 213.52, ["Mega"] = 2562.11, ["Mega|Ride"] = 1126.81, ["Mega|Fly|Ride"] = 779.5}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 13.83, ["Fly"] = 70.49, ["Ride"] = 28.88, ["Fly|Ride"] = 78.75, ["Neon"] = 57.75, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 367.5, ["Mega|Ride"] = 282.19, ["Mega|Fly|Ride"] = 431.61}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 55.46, ["Ride"] = 108.92, ["Fly|Ride"] = 498.67, ["Neon"] = 164.07, ["Neon|Fly"] = 370.5, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 413.16, ["Mega"] = 1054.75, ["Mega|Ride"] = 1010.98, ["Mega|Fly|Ride"] = 1039.8}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 116.61, ["Fly|Ride"] = 285.11, ["Neon"] = 2.62, ["Neon|Fly"] = 57.67, ["Neon|Ride"] = 113.47, ["Neon|Fly|Ride"] = 106.77, ["Mega"] = 16.68, ["Mega|Ride"] = 143.07, ["Mega|Fly|Ride"] = 203.44}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 82.77, ["Fly"] = 137.82, ["Ride"] = 90.82, ["Fly|Ride"] = 158.05, ["Neon"] = 487.27, ["Neon|Fly"] = 490.88, ["Neon|Ride"] = 390.67, ["Neon|Fly|Ride"] = 525, ["Mega"] = 3416.14, ["Mega|Fly|Ride"] = 1763.74}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.1, ["Fly"] = 107.63, ["Ride"] = 19.57, ["Fly|Ride"] = 67.37, ["Neon"] = 198.19, ["Neon|Ride"] = 113.17, ["Mega"] = 773.71, ["Mega|Ride"] = 434.33, ["Mega|Fly|Ride"] = 490.88}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 28.56, ["Ride"] = 18.27, ["Fly|Ride"] = 38.16, ["Neon"] = 19.23, ["Neon|Fly"] = 80.89, ["Neon|Ride"] = 83.28, ["Neon|Fly|Ride"] = 122.85, ["Mega"] = 104.97, ["Mega|Ride"] = 277.86, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 2.1, ["Ride"] = 126, ["Neon"] = 16.04, ["Neon|Fly"] = 140.95, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 212.46}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 64.97, ["Ride"] = 196.88, ["Fly|Ride"] = 223.13, ["Neon"] = 391.13, ["Neon|Ride"] = 427.08, ["Neon|Fly|Ride"] = 727.13, ["Mega"] = 1830.85, ["Mega|Ride"] = 1424.11, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 3.94, ["Fly|Ride"] = 427.13, ["Neon"] = 19.09, ["Neon|Ride"] = 59.07, ["Mega"] = 126.88, ["Mega|Fly|Ride"] = 285.05}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 37.42, ["Neon"] = 2.1, ["Neon|Ride"] = 118.3, ["Mega"] = 16.93, ["Mega|Ride"] = 202.26, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 102.94, ["Ride"] = 32.04, ["Fly|Ride"] = 143.09, ["Neon"] = 3.93, ["Neon|Fly"] = 86.2, ["Neon|Ride"] = 21.37, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 19.69, ["Mega|Fly"] = 71.54, ["Mega|Ride"] = 42.77}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 23.5, ["Fly|Ride"] = 34.18, ["Neon"] = 5.41, ["Neon|Ride"] = 24.15, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 61.07, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 104.99}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 114.26, ["Neon"] = 24.36, ["Mega"] = 118.11, ["Mega|Ride"] = 114.23, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 38.07, ["Ride"] = 14.44, ["Fly|Ride"] = 40.95, ["Neon"] = 10.08, ["Neon|Fly"] = 85.43, ["Neon|Ride"] = 28.85, ["Neon|Fly|Ride"] = 100.36, ["Mega"] = 170.63, ["Mega|Ride"] = 156.49, ["Mega|Fly|Ride"] = 161.21}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 56.44, ["Ride"] = 102.38, ["Fly|Ride"] = 285.11, ["Neon"] = 229.69, ["Neon|Ride"] = 324.07, ["Neon|Fly|Ride"] = 1067.55, ["Mega"] = 786.19, ["Mega|Ride"] = 698.18, ["Mega|Fly|Ride"] = 1126.81}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 17.07, ["Fly|Ride"] = 39, ["Neon"] = 2.1, ["Neon|Fly"] = 21.37, ["Neon|Ride"] = 20.29, ["Neon|Fly|Ride"] = 31.71, ["Mega"] = 47.07, ["Mega|Ride"] = 131.1, ["Mega|Fly|Ride"] = 95.82}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 7.86, ["Fly"] = 35.25, ["Ride"] = 27.79, ["Fly|Ride"] = 57.47, ["Neon"] = 33.72, ["Neon|Fly"] = 91.77, ["Neon|Ride"] = 57.75, ["Neon|Fly|Ride"] = 105, ["Mega"] = 301.88, ["Mega|Fly"] = 570.08, ["Mega|Ride"] = 328.02, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 22.31, ["Fly"] = 57.68, ["Ride"] = 42.71, ["Fly|Ride"] = 114.18, ["Neon"] = 105, ["Neon|Fly"] = 147, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 787.5, ["Mega|Ride"] = 783.59, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 3.93, ["Fly"] = 196.88, ["Neon"] = 74.82, ["Neon|Ride"] = 103.69, ["Mega"] = 470.8, ["Mega|Ride"] = 412.13, ["Mega|Fly|Ride"] = 533.78}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 19.59, ["Ride"] = 16.04, ["Fly|Ride"] = 32.71, ["Neon"] = 3.47, ["Neon|Fly"] = 28.11, ["Neon|Ride"] = 21.36, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 40.09, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 121.96}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 3.91, ["Fly"] = 39.38, ["Ride"] = 31.5, ["Neon"] = 52.41, ["Neon|Ride"] = 128.14, ["Mega"] = 177.19, ["Mega|Fly"] = 366.18, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 535.92}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 918.75, ["Fly"] = 1288.6, ["Ride"] = 938.44, ["Fly|Ride"] = 1034.25, ["Neon|Ride"] = 2744.44, ["Neon|Fly|Ride"] = 2415, ["Mega|Fly|Ride"] = 7117.29}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 181.02, ["Ride"] = 262.5, ["Neon"] = 840, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 977.82, ["Mega"] = 3201.56, ["Mega|Ride"] = 3560.26, ["Mega|Fly|Ride"] = 2988.05}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Fly|Ride"] = 392.44, ["Neon"] = 7.07, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 255.15, ["Mega"] = 78.32, ["Mega|Fly|Ride"] = 212.46}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 102.77, ["Ride"] = 185.81, ["Fly|Ride"] = 315, ["Neon"] = 549.94, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 754.69, ["Mega"] = 1967.44, ["Mega|Ride"] = 1907.71, ["Mega|Fly|Ride"] = 1903.13}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 2.21, ["Ride"] = 20.66, ["Fly|Ride"] = 98.44, ["Neon"] = 15.98, ["Neon|Fly"] = 56.74, ["Neon|Ride"] = 55.98, ["Neon|Fly|Ride"] = 285.05, ["Mega"] = 118.13, ["Mega|Ride"] = 242.34, ["Mega|Fly|Ride"] = 361.6}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 227.39, ["Fly"] = 427.13, ["Ride"] = 262.49, ["Fly|Ride"] = 376.69, ["Neon"] = 1146.22, ["Neon|Ride"] = 1409.16, ["Neon|Fly|Ride"] = 2135.09, ["Mega|Fly|Ride"] = 5043.94}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 77.18, ["Ride"] = 41.66, ["Fly|Ride"] = 220.56, ["Neon"] = 23.9, ["Neon|Ride"] = 56.54, ["Mega"] = 321.57, ["Mega|Fly"] = 357.65, ["Mega|Ride"] = 427.03}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Fly"] = 28.85, ["Ride"] = 19.23, ["Neon"] = 43.65, ["Mega"] = 249.38, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 19.31, ["Ride"] = 56.73, ["Fly|Ride"] = 153.24, ["Neon"] = 121.96, ["Neon|Fly"] = 427.08, ["Neon|Ride"] = 98.44, ["Mega"] = 764.57, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 854.05}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 49.76, ["Neon"] = 21.37, ["Neon|Ride"] = 196.88, ["Mega"] = 241.31, ["Mega|Ride"] = 256.23, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 15.65, ["Ride"] = 15.31, ["Fly|Ride"] = 32.71, ["Neon"] = 2.63, ["Neon|Fly"] = 20.79, ["Neon|Ride"] = 19.23, ["Neon|Fly|Ride"] = 36.3, ["Mega"] = 24.57, ["Mega|Ride"] = 38.89, ["Mega|Fly|Ride"] = 96.36}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 5026.12, ["Ride"] = 4461.19, ["Fly|Ride"] = 4987.5, ["Neon"] = 32033.81, ["Neon|Fly|Ride"] = 21350.78, ["Mega|Fly|Ride"] = 52500}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 9.54, ["Fly"] = 85.44, ["Ride"] = 41.91, ["Neon"] = 78.75, ["Neon|Ride"] = 106.32, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 203.75, ["Mega|Fly"] = 327.75, ["Mega|Ride"] = 214.85, ["Mega|Fly|Ride"] = 285.05}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 24.7, ["Ride"] = 20.49, ["Fly|Ride"] = 42.73, ["Neon"] = 11.75, ["Neon|Fly"] = 36.32, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 131.25, ["Mega|Ride"] = 138.9, ["Mega|Fly|Ride"] = 206.05}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 415.76, ["Fly"] = 547.77, ["Ride"] = 459.38, ["Fly|Ride"] = 532.86, ["Neon"] = 2100, ["Neon|Ride"] = 1292.82, ["Neon|Fly|Ride"] = 1115.63, ["Mega|Fly|Ride"] = 4873.32}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 2.17, ["Ride"] = 42.54, ["Neon"] = 13.85, ["Neon|Ride"] = 291.38, ["Mega"] = 187.94, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 693}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 3.14, ["Fly"] = 145.69, ["Ride"] = 36.32, ["Neon"] = 131.25, ["Neon|Fly"] = 118.53, ["Neon|Ride"] = 119.45, ["Neon|Fly|Ride"] = 306.41, ["Mega"] = 425.97, ["Mega|Ride"] = 285.05, ["Mega|Fly|Ride"] = 740.88}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 51.07, ["Ride"] = 17.1, ["Fly|Ride"] = 65.63, ["Neon"] = 7.88, ["Neon|Fly"] = 124.69, ["Neon|Ride"] = 36.22, ["Neon|Fly|Ride"] = 91.74, ["Mega"] = 52.49, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 272.24}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 700.88, ["Fly"] = 869.21, ["Ride"] = 656.25, ["Fly|Ride"] = 689.07, ["Neon|Ride"] = 2126.27, ["Neon|Fly|Ride"] = 2940}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 10.38, ["Fly"] = 249.38, ["Ride"] = 62.99, ["Neon"] = 32.22, ["Neon|Fly"] = 114.26, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 143.07, ["Mega"] = 194.25, ["Mega|Fly"] = 427.03, ["Mega|Ride"] = 231, ["Mega|Fly|Ride"] = 424.83}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 5.9, ["Fly"] = 236.25, ["Ride"] = 45.94, ["Fly|Ride"] = 65.63, ["Neon"] = 23.63, ["Neon|Ride"] = 61.02, ["Neon|Fly|Ride"] = 157.4, ["Mega"] = 162.65, ["Mega|Fly"] = 804.7, ["Mega|Ride"] = 179.64, ["Mega|Fly|Ride"] = 285.05}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 34.13, ["Ride"] = 20.5, ["Fly|Ride"] = 52.61, ["Neon"] = 15.9, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 32.04, ["Neon|Fly|Ride"] = 82.93, ["Mega"] = 285.05, ["Mega|Fly"] = 143.07, ["Mega|Ride"] = 158.01, ["Mega|Fly|Ride"] = 194.25}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 20.9, ["Ride"] = 38.07, ["Fly|Ride"] = 58.59, ["Neon"] = 117.59, ["Mega"] = 852.97, ["Mega|Ride"] = 622.13, ["Mega|Fly|Ride"] = 712.06}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 43.31, ["Fly|Ride"] = 80.85, ["Neon"] = 4.16, ["Neon|Ride"] = 49.13, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 30.19, ["Mega|Ride"] = 78.66, ["Mega|Fly|Ride"] = 228.38}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 608.89, ["Fly"] = 703.69, ["Ride"] = 630.19, ["Fly|Ride"] = 630, ["Neon"] = 2589.57, ["Neon|Ride"] = 2193, ["Neon|Fly|Ride"] = 2367.46, ["Mega|Ride"] = 9410.13, ["Mega|Fly|Ride"] = 7861.88}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Neon"] = 10.58, ["Neon|Ride"] = 79.26, ["Neon|Fly|Ride"] = 427.03, ["Mega"] = 93.95, ["Mega|Ride"] = 222.07, ["Mega|Fly|Ride"] = 365.11}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 19.59, ["Neon"] = 4.29, ["Neon|Fly"] = 242.38, ["Neon|Ride"] = 76.88, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 42.72, ["Mega|Ride"] = 137.54, ["Mega|Fly|Ride"] = 285.05}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 60.38, ["Neon"] = 3.64, ["Neon|Ride"] = 41.05, ["Neon|Fly|Ride"] = 143.07, ["Mega"] = 57.62, ["Mega|Fly"] = 158.01, ["Mega|Ride"] = 125.14, ["Mega|Fly|Ride"] = 140.93}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 11.74, ["Neon|Ride"] = 48.18, ["Mega"] = 213.52, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 26.24, ["Fly"] = 72.19, ["Ride"] = 41.91, ["Fly|Ride"] = 203.24, ["Neon"] = 138.65, ["Neon|Fly"] = 213.54, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 213.52, ["Mega"] = 511.88, ["Mega|Ride"] = 443.04, ["Mega|Fly|Ride"] = 556.36}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 14.91, ["Fly"] = 96.54, ["Ride"] = 55.64, ["Fly|Ride"] = 149.51, ["Neon"] = 84.07, ["Neon|Ride"] = 126, ["Neon|Fly|Ride"] = 281.74, ["Mega"] = 512.3, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 575.72}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 16.69, ["Fly|Ride"] = 34.54, ["Neon"] = 36.32, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 88.61, ["Mega"] = 298.6, ["Mega|Ride"] = 285.05, ["Mega|Fly|Ride"] = 335.23}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 7.87, ["Ride"] = 56.94, ["Fly|Ride"] = 134.56, ["Neon"] = 38.05, ["Neon|Ride"] = 91.88}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Ride"] = 26.17, ["Fly|Ride"] = 106.8, ["Neon"] = 10.5, ["Neon|Ride"] = 50.19, ["Neon|Fly|Ride"] = 128.13, ["Mega"] = 69.57, ["Mega|Ride"] = 115.5, ["Mega|Fly|Ride"] = 256.23}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 17.07, ["Fly"] = 113.43, ["Ride"] = 30.8, ["Fly|Ride"] = 57.68, ["Neon"] = 109.15, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 289.42, ["Mega"] = 787.5, ["Mega|Fly|Ride"] = 749.43}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 29.94, ["Fly"] = 874.13, ["Neon"] = 98.44, ["Mega"] = 332.06, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 498.57}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 45.48, ["Fly"] = 115.84, ["Ride"] = 80.99, ["Fly|Ride"] = 114.12, ["Neon"] = 317.35, ["Neon|Ride"] = 277.71, ["Neon|Fly|Ride"] = 341.16, ["Mega"] = 1930.29, ["Mega|Ride"] = 1769.84, ["Mega|Fly|Ride"] = 1260.39}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 34.83, ["Fly"] = 129.11, ["Ride"] = 65.63, ["Fly|Ride"] = 131.25, ["Neon"] = 139.13, ["Neon|Ride"] = 142.92, ["Neon|Fly|Ride"] = 291.38, ["Mega"] = 712.06, ["Mega|Ride"] = 768.65, ["Mega|Fly|Ride"] = 654.94}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 15.49, ["Ride"] = 40.6, ["Neon"] = 114.28, ["Neon|Ride"] = 223.13, ["Mega"] = 659.93, ["Mega|Ride"] = 623.44, ["Mega|Fly|Ride"] = 806.01}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 23.62, ["Fly"] = 36.32, ["Ride"] = 36.32, ["Fly|Ride"] = 199.69, ["Neon"] = 128.15, ["Neon|Fly"] = 256.26, ["Neon|Ride"] = 227.95, ["Neon|Fly|Ride"] = 210, ["Mega"] = 660.24, ["Mega|Ride"] = 601.63, ["Mega|Fly|Ride"] = 693.16}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 18.08, ["Ride"] = 15.67, ["Fly|Ride"] = 32.78, ["Neon"] = 3.42, ["Neon|Fly"] = 27.77, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 57.64, ["Mega"] = 42.72, ["Mega|Fly"] = 322.13, ["Mega|Ride"] = 57.67, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 866.25}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 70.88, ["Fly"] = 482.63, ["Ride"] = 127.35, ["Fly|Ride"] = 330.65, ["Neon"] = 415.8, ["Neon|Ride"] = 458.07, ["Neon|Fly|Ride"] = 555.13, ["Mega"] = 1417.5, ["Mega|Ride"] = 1515.92, ["Mega|Fly|Ride"] = 1493.54}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 79.76, ["Neon"] = 3.6, ["Neon|Fly"] = 100.37, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 298.9, ["Mega"] = 24.69, ["Mega|Ride"] = 85.37, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 26.16, ["Ride"] = 79.03, ["Neon"] = 140.23, ["Neon|Ride"] = 135.35, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 482.58, ["Mega|Ride"] = 511.77, ["Mega|Fly|Ride"] = 712.06}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 3.61, ["Neon|Fly|Ride"] = 114.23, ["Mega"] = 25.73, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Ride"] = 74.82, ["Neon"] = 3.81, ["Mega"] = 21, ["Mega|Ride"] = 152.02, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 90.3, ["Fly"] = 223.13, ["Ride"] = 143.47, ["Fly|Ride"] = 344.37, ["Neon"] = 433.13, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 663.55, ["Mega|Ride"] = 2847.14, ["Mega|Fly|Ride"] = 2093.44}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 90.57, ["Ride"] = 19.28, ["Fly|Ride"] = 88.47, ["Neon"] = 7.56, ["Neon|Fly"] = 42.72, ["Neon|Ride"] = 32.28, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 91.59, ["Mega|Ride"] = 116.93, ["Mega|Fly|Ride"] = 213.52}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 38.07, ["Fly|Ride"] = 57.68, ["Neon"] = 5.25, ["Neon|Fly"] = 42.72, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 419.9, ["Mega"] = 32.81, ["Mega|Ride"] = 128.13, ["Mega|Fly|Ride"] = 217.87}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 72.36, ["Neon"] = 8.56, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 71.55, ["Mega"] = 129.1, ["Mega|Ride"] = 163.13, ["Mega|Fly|Ride"] = 554.07}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 91.1, ["Neon"] = 6.57, ["Mega"] = 91.88, ["Mega|Ride"] = 337.82, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 83.51, ["Ride"] = 184.04, ["Fly|Ride"] = 356.66, ["Neon"] = 428.35, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 2420.13, ["Mega|Ride"] = 2292.22, ["Mega|Fly|Ride"] = 2262.12}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 6.56, ["Ride"] = 93.98, ["Neon"] = 90.92, ["Neon|Ride"] = 77.44, ["Mega"] = 413.86, ["Mega|Ride"] = 366.19, ["Mega|Fly|Ride"] = 639.29}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 393.75, ["Ride"] = 463.77, ["Fly|Ride"] = 709.03, ["Neon"] = 1050, ["Neon|Ride"] = 1050, ["Neon|Fly|Ride"] = 1113, ["Mega|Fly|Ride"] = 3346.87}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 91.88}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 51.18}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 25.73}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 23.41}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 52.5}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 40.58}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 16.83}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 7.87}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 183.75}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 17.52}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 22.66}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 10.48}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 3.94}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 839.99}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 7.62}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 6.51}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 9.08}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 4.81}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 17.07}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 619.25}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 471.19}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 9.06}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1443.75}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 52.39}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 5.24}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 34.31}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 19.68}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 45.87}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 57.69}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 16.63}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 10.39}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 16.89}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 5.19}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 21.95}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 3.28}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 20.99}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 15.02}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 6.2}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 3061.38}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 51.35}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 315}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 3.6}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 3.55}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 13.79}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 8.81}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 28.88}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 213.87}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 9.19}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 9.19}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 144.38}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 31.5}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 3.94}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 28.72}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 16.22}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 105}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 28.25}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 10.5}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 20.58}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 7.88}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 4.04}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 25.2}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 91.87}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 242.82}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 7.88}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 288.66}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 24.86}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 76.67}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 20.54}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 24010.38}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 124.69}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 57.74}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 38.64}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 26.9}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 45.92}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 23.4}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 26.25}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 87.44}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 91.88}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 26.25}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 91.87}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 393.75}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 48.57}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 48.38}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 214.27}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 6.45}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 6.55}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 6.01}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 19.57}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 141.61}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.1}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 2.63}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 2.63}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 13}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 183.75}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 830.8}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 9.19}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 590}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 11.82}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.1}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 231}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 28.51}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 99.63}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 17.06}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 30.08}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 61.24}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 14.82}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 3.94}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 7.87}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.36}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 2.43}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 5.79}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 32.69}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 5.64}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 2.29}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 3.68}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 16.47}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 143.1}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 51.54}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.1}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 216.56}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 10.5}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 10.39}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 5.25}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 25.74}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 7.76}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 4.07}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 7.88}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 8.36}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 6.15}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 30.09}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 12.89}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 5.92}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 2.43}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 6.43}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 7.7}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 14.6}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 2.61}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 5.1}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 3.29}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 6.42}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 9396.59}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 14.34}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 4.07}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 2.16}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 3.29}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 57.75}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 11.75}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 7.87}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 2.38}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.63}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 5.25}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 19.69}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 5.03}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 3.51}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 3.15}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4270.11}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 6.36}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 37.97}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.51}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 8.56}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 71.96}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 8.56}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 90.75}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 8.54}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 2.6}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.1}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 8.56}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 11.69}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 24.45}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 8.99}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 3.63}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 6.57}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 3.94}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 2.86}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 19.17}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 5.86}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 13.13}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 141.75}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 79.59}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 9.57}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 2.27}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1214.07}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 63.31}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.26}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 3.29}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 31.08}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 27.46}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 5.25}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 8.91}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 14.86}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 13.13}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 12.9}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 3.94}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 3.52}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 11.58}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 3.2}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 21.37}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 3.62}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 7.88}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 59.16}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 6.56}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 173.15}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 91.88}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 11.44}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 2.63}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 27.3}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 3.29}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 22.51}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 5.24}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 3.94}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 6.46}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 5.08}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 79.94}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 162.65}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 11.21}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1275.59}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.52}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 196.88}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 10.39}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 7.28}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 60.29}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 6.18}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 3.59}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 64.97}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 18.38}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 17.07}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 5.64}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 4.29}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 53.72}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 2.43}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 63}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 3.94}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 37.38}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 116.73}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 85.32}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 8.06}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 63.66}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.62}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 89.15}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 53.61}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 111.57}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 3.86}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 65.58}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 140.2}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 5.24}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 47.25}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 57.44}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 63}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 3.6}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 3.42}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 8.77}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 21.61}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 82.69}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 39.1}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 14.44}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 40.69}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 26.25}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 17.18}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 82.3}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 49.03}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 26.25}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1994.66}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 9.63}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 7.24}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 20.89}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 354.38}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 15.75}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 8.27}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 16.68}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 10.48}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 7.88}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 295.82}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 62.34}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 49.26}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 5.25}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 55.86}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 217.69}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 76.67}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 918.75}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 179.82}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 9}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 1727.25}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 570.41}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 2.63}},
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