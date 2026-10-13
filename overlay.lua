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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 1194.66, ["Ride"] = 1050, ["Fly|Ride"] = 1489.05, ["Neon"] = 6745.97, ["Neon|Fly|Ride"] = 12603.94, ["Mega"] = 21345.69, ["Mega|Fly|Ride"] = 21348.23}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 433.13, ["Fly"] = 525, ["Ride"] = 393.75, ["Fly|Ride"] = 623.16, ["Neon|Fly|Ride"] = 1706.25, ["Mega"] = 10672.85, ["Mega|Fly|Ride"] = 7539.13}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 6031.9, ["Ride"] = 5250, ["Fly|Ride"] = 4986.19, ["Neon|Fly|Ride"] = 17850, ["Mega|Fly|Ride"] = 71161.09}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 165.38, ["Ride"] = 284.81, ["Fly|Ride"] = 313.22, ["Neon"] = 1053.98, ["Neon|Ride"] = 1054.5, ["Neon|Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 4725}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 517.46, ["Fly"] = 650.49, ["Ride"] = 564.38, ["Fly|Ride"] = 525, ["Neon|Fly|Ride"] = 1822.9, ["Mega|Fly|Ride"] = 8517.86}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 10.17, ["Ride"] = 57.69, ["Fly|Ride"] = 129.94, ["Neon"] = 71.47, ["Neon|Fly"] = 284.97, ["Neon|Ride"] = 87.47, ["Neon|Fly|Ride"] = 320.2, ["Mega"] = 350.21, ["Mega|Ride"] = 470.74, ["Mega|Fly|Ride"] = 570.01}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 4.83, ["Fly"] = 43.32, ["Ride"] = 26.25, ["Fly|Ride"] = 83.91, ["Neon"] = 44.57, ["Neon|Fly"] = 72.19, ["Neon|Ride"] = 60.37, ["Neon|Fly|Ride"] = 130.11, ["Mega"] = 196.87, ["Mega|Ride"] = 261.19, ["Mega|Fly|Ride"] = 384.62}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 120.49, ["Ride"] = 157.5, ["Fly|Ride"] = 241.12, ["Neon"] = 567.53, ["Neon|Ride"] = 492.19, ["Neon|Fly|Ride"] = 711.89, ["Mega"] = 1586.82, ["Mega|Ride"] = 2492.44, ["Mega|Fly|Ride"] = 2842.52}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 38.04, ["Fly"] = 64.02, ["Ride"] = 46.17, ["Fly|Ride"] = 110.15, ["Neon"] = 275.63, ["Neon|Ride"] = 183.65, ["Neon|Fly|Ride"] = 284.97, ["Mega"] = 2100, ["Mega|Ride"] = 1173.1, ["Mega|Fly|Ride"] = 967.29}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 19.56, ["Fly"] = 37.34, ["Ride"] = 32.02, ["Fly|Ride"] = 71.31, ["Neon|Ride"] = 136.5, ["Neon|Fly|Ride"] = 203.44, ["Mega|Ride"] = 627.02, ["Mega|Fly|Ride"] = 853.94}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 63, ["Fly"] = 128.02, ["Ride"] = 101.36, ["Fly|Ride"] = 175.88, ["Neon"] = 384.65, ["Neon|Ride"] = 320.25, ["Neon|Fly|Ride"] = 426.93, ["Mega|Fly|Ride"] = 1267.03}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 66.93}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 347.61, ["Fly"] = 315, ["Ride"] = 334.43, ["Fly|Ride"] = 389.82, ["Neon|Ride"] = 1048.69, ["Neon|Fly|Ride"] = 1181.24, ["Mega|Fly|Ride"] = 5063.82}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 121.87, ["Fly"] = 142.94, ["Ride"] = 144.19, ["Fly|Ride"] = 177.09, ["Neon|Fly"] = 626.64, ["Neon|Ride"] = 573.03, ["Neon|Fly|Ride"] = 536.82, ["Mega"] = 4312.63, ["Mega|Fly|Ride"] = 2467.5}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.62, ["Ride"] = 32.82, ["Fly|Ride"] = 131.25, ["Neon"] = 23.93, ["Neon|Ride"] = 56.35, ["Neon|Fly|Ride"] = 242.82, ["Mega"] = 157.5, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 342.01}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 209.99, ["Fly"] = 284.81, ["Ride"] = 194.88, ["Fly|Ride"] = 249.38, ["Neon|Ride"] = 960.58, ["Neon|Fly|Ride"] = 701.56, ["Mega|Fly|Ride"] = 2749.69}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.57, ["Fly"] = 26.65, ["Ride"] = 17.8, ["Fly|Ride"] = 52.48, ["Neon"] = 28.86, ["Neon|Fly"] = 80.76, ["Neon|Ride"] = 57.64, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 321.83, ["Mega|Fly|Ride"] = 422.63}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 102.38, ["Fly"] = 284.72, ["Ride"] = 127.33, ["Fly|Ride"] = 286.79, ["Neon"] = 402.81, ["Neon|Ride"] = 291.38, ["Neon|Fly|Ride"] = 547.32, ["Mega"] = 1709.08, ["Mega|Ride"] = 1477.25, ["Mega|Fly|Ride"] = 1476.57}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 38.98}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 73.5, ["Ride"] = 170.68, ["Fly|Ride"] = 244.02, ["Neon"] = 577.5, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 2134.58, ["Mega|Fly|Ride"] = 4501.81}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 24.11, ["Fly"] = 55.49, ["Ride"] = 43.31, ["Fly|Ride"] = 384.05, ["Neon"] = 241.12, ["Neon|Ride"] = 209.99, ["Neon|Fly|Ride"] = 326.61, ["Mega"] = 425.86, ["Mega|Ride"] = 990.57, ["Mega|Fly|Ride"] = 964.95}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 39.35, ["Fly"] = 78.75, ["Ride"] = 42.69, ["Fly|Ride"] = 104.9, ["Neon"] = 321.65, ["Neon|Ride"] = 202.46, ["Neon|Fly|Ride"] = 210, ["Mega"] = 1687.09, ["Mega|Ride"] = 1423.94, ["Mega|Fly|Ride"] = 958.65}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 42, ["Fly"] = 262.5, ["Ride"] = 80.72, ["Fly|Ride"] = 196.88, ["Neon"] = 185.63, ["Neon|Ride"] = 392.39, ["Neon|Fly|Ride"] = 519.75, ["Mega"] = 1967.44, ["Mega|Ride"] = 1334.27, ["Mega|Fly|Ride"] = 1534.95}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 15.39, ["Ride"] = 35.18, ["Fly|Ride"] = 100.33, ["Neon"] = 209.9, ["Neon|Ride"] = 213.47, ["Neon|Fly|Ride"] = 173.25, ["Mega"] = 1207.92, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 40.49, ["Fly"] = 57.62, ["Ride"] = 67.22, ["Fly|Ride"] = 129.94, ["Neon"] = 161.48, ["Neon|Fly"] = 402.5, ["Neon|Ride"] = 272.36, ["Neon|Fly|Ride"] = 322.88, ["Mega|Ride"] = 3202.25, ["Mega|Fly|Ride"] = 1018.81}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 7.88, ["Fly"] = 44.82, ["Ride"] = 23.48, ["Fly|Ride"] = 49.79, ["Neon"] = 39.29, ["Neon|Fly"] = 98.42, ["Neon|Ride"] = 49.87, ["Neon|Fly|Ride"] = 90.96, ["Mega"] = 177.57, ["Mega|Fly"] = 274.32, ["Mega|Ride"] = 182.44, ["Mega|Fly|Ride"] = 345.07}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 395.01, ["Ride"] = 416.07, ["Fly|Ride"] = 452.81, ["Neon"] = 2091.95, ["Neon|Ride"] = 1689.18, ["Neon|Fly|Ride"] = 1966.13, ["Mega"] = 10672.85, ["Mega|Fly|Ride"] = 9562.86}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 15.69, ["Ride"] = 32.81, ["Fly|Ride"] = 65.63, ["Neon"] = 219.18, ["Mega|Ride"] = 804.84, ["Mega|Fly|Ride"] = 671.66}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 5.25, ["Fly"] = 38.75, ["Ride"] = 20.58, ["Fly|Ride"] = 49.08, ["Neon"] = 58.47, ["Neon|Ride"] = 70.97, ["Neon|Fly|Ride"] = 129.93, ["Mega|Ride"] = 327.93, ["Mega|Fly|Ride"] = 378.38}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 78.75, ["Fly"] = 118.55, ["Ride"] = 89.25, ["Fly|Ride"] = 128.03, ["Neon"] = 323.65, ["Neon|Fly"] = 408.78, ["Neon|Ride"] = 354.26, ["Neon|Fly|Ride"] = 395.01, ["Mega"] = 6385.61, ["Mega|Ride"] = 2434.71, ["Mega|Fly|Ride"] = 2100}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 11.81, ["Ride"] = 36.09, ["Fly|Ride"] = 75.9, ["Neon"] = 137.82, ["Neon|Ride"] = 113.29, ["Neon|Fly|Ride"] = 201.21, ["Mega"] = 711.89, ["Mega|Ride"] = 562.89, ["Mega|Fly|Ride"] = 720.51}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 209.4, ["Fly"] = 262.5, ["Ride"] = 226.07, ["Fly|Ride"] = 292.69, ["Neon"] = 569.67, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 711.89, ["Mega"] = 3414.25, ["Mega|Ride"] = 2763.52, ["Mega|Fly|Ride"] = 3133.8}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 19.69}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.56, ["Fly"] = 36.32, ["Ride"] = 28.82, ["Fly|Ride"] = 72.19, ["Neon"] = 24.92, ["Neon|Fly"] = 143.03, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 143.03, ["Mega"] = 183.75, ["Mega|Fly"] = 341.55, ["Mega|Ride"] = 241.34, ["Mega|Fly|Ride"] = 288.74}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 918.74, ["Fly"] = 2625, ["Ride"] = 895.61, ["Fly|Ride"] = 943.59, ["Neon"] = 6386.79, ["Neon|Ride"] = 4839.08, ["Neon|Fly|Ride"] = 4268.09, ["Mega|Ride"] = 54238.46, ["Mega|Fly|Ride"] = 17078.59}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 13.13, ["Fly"] = 56.84, ["Ride"] = 51.82, ["Fly|Ride"] = 91.88, ["Neon"] = 169.21, ["Neon|Ride"] = 157.98, ["Neon|Fly|Ride"] = 170.79, ["Mega"] = 1010.63, ["Mega|Ride"] = 1096.25, ["Mega|Fly|Ride"] = 820.31}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 235.75, ["Fly"] = 361.39, ["Ride"] = 236.25, ["Fly|Ride"] = 403.13, ["Neon"] = 787.5, ["Neon|Ride"] = 892.5, ["Neon|Fly|Ride"] = 853.13, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 3899.56}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 38.74}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 11.82, ["Fly"] = 128.02, ["Ride"] = 64.97, ["Fly|Ride"] = 142.96, ["Neon"] = 65.63, ["Neon|Ride"] = 128.62, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 353.22, ["Mega|Ride"] = 568.01, ["Mega|Fly|Ride"] = 596.64}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 112.85, ["Ride"] = 144.27, ["Fly|Ride"] = 168.54, ["Neon"] = 639.01, ["Neon|Ride"] = 498.44, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 2220.23}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 91.86, ["Fly"] = 157.49, ["Ride"] = 122.07, ["Fly|Ride"] = 218.86, ["Neon"] = 389.34, ["Neon|Fly"] = 569.94, ["Neon|Ride"] = 434.78, ["Neon|Fly|Ride"] = 496.12, ["Mega|Ride"] = 1446.38, ["Mega|Fly|Ride"] = 1401}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 34.13}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 28.82, ["Fly"] = 54.67, ["Ride"] = 32.82, ["Fly|Ride"] = 69.54, ["Neon|Ride"] = 379.98, ["Neon|Fly|Ride"] = 325.5, ["Mega"] = 4269.15, ["Mega|Fly|Ride"] = 1350.21}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 5.23, ["Fly"] = 98.44, ["Ride"] = 54.42, ["Fly|Ride"] = 206, ["Neon"] = 35.44, ["Neon|Fly"] = 223.13, ["Neon|Ride"] = 124.79, ["Neon|Fly|Ride"] = 240.16, ["Mega"] = 170.63, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 276.94, ["Mega|Fly|Ride"] = 417.37}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 465.94, ["Fly"] = 702.93, ["Ride"] = 479.04, ["Fly|Ride"] = 539.42, ["Neon|Fly"] = 3842.24, ["Neon|Ride"] = 1876.88, ["Neon|Fly|Ride"] = 1857.77, ["Mega|Ride"] = 14943.76, ["Mega|Fly|Ride"] = 7481.25}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 111.45, ["Fly"] = 185.55, ["Ride"] = 129.94, ["Fly|Ride"] = 144.27, ["Neon"] = 420, ["Neon|Ride"] = 470.69, ["Neon|Fly|Ride"] = 583.83, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3543.75, ["Ride"] = 3885, ["Fly|Ride"] = 3937.5, ["Neon|Fly|Ride"] = 14940.93}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 59.59, ["Fly"] = 121.62, ["Ride"] = 80.72, ["Fly|Ride"] = 169.61, ["Neon"] = 426.93, ["Neon|Ride"] = 251.15, ["Neon|Fly|Ride"] = 292.69, ["Mega"] = 2134.58, ["Mega|Ride"] = 1984.33, ["Mega|Fly|Ride"] = 1749.57}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 45.52, ["Ride"] = 70.88, ["Fly|Ride"] = 142.96, ["Neon"] = 575.75, ["Neon|Ride"] = 427.88, ["Neon|Fly|Ride"] = 399.18, ["Mega"] = 6261.76, ["Mega|Ride"] = 2388.75, ["Mega|Fly|Ride"] = 2335.51}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 31.5, ["Fly"] = 60.82, ["Ride"] = 46.88, ["Fly|Ride"] = 92.93, ["Neon"] = 151.72, ["Neon|Fly"] = 284.97, ["Neon|Ride"] = 140.88, ["Neon|Fly|Ride"] = 204.75, ["Mega"] = 996.86, ["Mega|Ride"] = 878.49, ["Mega|Fly|Ride"] = 577.47}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 4.29}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 54.21, ["Fly"] = 393.75, ["Ride"] = 47.54, ["Fly|Ride"] = 96.39, ["Neon|Ride"] = 284.97, ["Neon|Fly|Ride"] = 597.7, ["Mega|Ride"] = 1286.07, ["Mega|Fly|Ride"] = 1446.38}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 32.81}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 184.8, ["Ride"] = 233.89, ["Fly|Ride"] = 282.19, ["Neon"] = 964.06, ["Neon|Ride"] = 711.89, ["Neon|Fly|Ride"] = 1135.6, ["Mega|Fly|Ride"] = 4981.62}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 628.89, ["Ride"] = 643.12, ["Fly|Ride"] = 656.25, ["Neon"] = 2625, ["Neon|Fly|Ride"] = 3615.18, ["Mega|Fly|Ride"] = 11265.36}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 7.21}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 26.25, ["Fly"] = 45.94, ["Ride"] = 35.6, ["Fly|Ride"] = 75.86, ["Neon"] = 228.3, ["Neon|Fly"] = 170.79, ["Neon|Ride"] = 179.65, ["Neon|Fly|Ride"] = 211.41, ["Mega"] = 2134.58, ["Mega|Ride"] = 1157.29, ["Mega|Fly|Ride"] = 767.8}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 18.38}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 4462.5, ["Fly"] = 7111.35, ["Ride"] = 5650.32, ["Fly|Ride"] = 5055.7, ["Neon|Ride"] = 17675.78, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 43390.77}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 6.56, ["Fly"] = 55.13, ["Ride"] = 24.93, ["Fly|Ride"] = 56.44, ["Neon"] = 72.19, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 199.6, ["Mega"] = 561.75, ["Mega|Ride"] = 490.88, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 12.06, ["Fly"] = 139.74, ["Ride"] = 28.88, ["Fly|Ride"] = 119.27, ["Neon"] = 125.95, ["Neon|Ride"] = 128.09, ["Neon|Fly|Ride"] = 262.48, ["Mega"] = 711.89, ["Mega|Ride"] = 840.07, ["Mega|Fly|Ride"] = 996.98}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 45.94, ["Ride"] = 45.94, ["Fly|Ride"] = 106.7, ["Neon|Ride"] = 395.97, ["Neon|Fly|Ride"] = 480.96, ["Mega"] = 4269.15, ["Mega|Fly|Ride"] = 1768.18}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 11.82, ["Fly"] = 71.48, ["Ride"] = 33.08, ["Fly|Ride"] = 78.75, ["Neon"] = 83.65, ["Neon|Ride"] = 148.32, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 1423.77, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 800.63}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1783.69, ["Fly"] = 1975.44, ["Ride"] = 1851.93, ["Fly|Ride"] = 1710.09, ["Neon|Fly|Ride"] = 3353.44, ["Mega|Fly|Ride"] = 12468.75}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 27300, ["Fly"] = 34132.7, ["Ride"] = 35437.5, ["Fly|Ride"] = 25591.13, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 63000, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 183748.69}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 24.11, ["Fly"] = 393.75, ["Ride"] = 57.75, ["Fly|Ride"] = 128.03, ["Neon"] = 256.04, ["Neon|Ride"] = 208.69, ["Neon|Fly|Ride"] = 569.94, ["Mega"] = 754.69, ["Mega|Ride"] = 1148.44, ["Mega|Fly|Ride"] = 1280.91}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 2.63, ["Fly"] = 105, ["Ride"] = 35.7, ["Fly|Ride"] = 121.62, ["Neon"] = 16.02, ["Neon|Fly"] = 143.07, ["Neon|Ride"] = 64.22, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 162.75, ["Mega|Fly"] = 284.97, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 287.43}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 21.38}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 8.93, ["Ride"] = 45.94, ["Fly|Ride"] = 131.25, ["Neon"] = 52.5, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 277.1, ["Mega"] = 405.59, ["Mega|Ride"] = 426.98, ["Mega|Fly|Ride"] = 746.13}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 748.13, ["Fly"] = 899.82, ["Ride"] = 730.63, ["Fly|Ride"] = 787.5, ["Neon"] = 2887.77, ["Neon|Ride"] = 2817.65, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 11250.27}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 917.23, ["Fly"] = 1076.15, ["Ride"] = 984.38, ["Fly|Ride"] = 1034.65, ["Neon"] = 4125.22, ["Neon|Fly|Ride"] = 3109.32, ["Mega|Fly|Ride"] = 11884.57}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 12.48, ["Fly"] = 120.47, ["Ride"] = 30.32, ["Fly|Ride"] = 91.74, ["Neon"] = 82.72, ["Neon|Ride"] = 108.31, ["Neon|Fly|Ride"] = 161.44, ["Mega"] = 1215.56, ["Mega|Ride"] = 481.9, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 26.25}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 56.7, ["Fly"] = 77.46, ["Ride"] = 82.69, ["Fly|Ride"] = 126, ["Neon"] = 569.67, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 420, ["Mega"] = 19687.5, ["Mega|Ride"] = 1993.94, ["Mega|Fly|Ride"] = 2124.15}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 80.74, ["Ride"] = 90.96, ["Fly|Ride"] = 213.38, ["Neon"] = 369.99, ["Neon|Ride"] = 386.78, ["Neon|Fly|Ride"] = 526.61, ["Mega"] = 1415.73, ["Mega|Ride"] = 1707.87, ["Mega|Fly|Ride"] = 1909.89}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 6.39, ["Fly"] = 28.67, ["Ride"] = 23, ["Fly|Ride"] = 52.32, ["Neon"] = 48.07, ["Neon|Fly"] = 524.98, ["Neon|Ride"] = 74.74, ["Neon|Fly|Ride"] = 110.92, ["Mega"] = 196.88, ["Mega|Fly|Ride"] = 570.01}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 118.13, ["Fly"] = 170.63, ["Ride"] = 155.82, ["Fly|Ride"] = 233.89, ["Neon"] = 852.37, ["Neon|Ride"] = 590.62, ["Neon|Fly|Ride"] = 610.71, ["Mega"] = 5122.98, ["Mega|Ride"] = 2892.73, ["Mega|Fly|Ride"] = 2559.37}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 5.16, ["Ride"] = 36.75, ["Fly|Ride"] = 200.54, ["Neon"] = 42, ["Neon|Fly"] = 241.02, ["Neon|Ride"] = 124.67, ["Neon|Fly|Ride"] = 284.97, ["Mega"] = 223.02, ["Mega|Fly"] = 1137.94, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 567}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 10.38, ["Fly"] = 50.14, ["Ride"] = 32.81, ["Fly|Ride"] = 89.63, ["Neon"] = 120.75, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 1050, ["Mega|Ride"] = 826.2, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 28.24, ["Ride"] = 68.24, ["Fly|Ride"] = 156.19, ["Neon"] = 198.43, ["Neon|Ride"] = 228.38, ["Mega"] = 997.5, ["Mega|Ride"] = 853.13, ["Mega|Fly|Ride"] = 1011.85}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 16.12, ["Fly"] = 57.62, ["Ride"] = 37.31, ["Fly|Ride"] = 63.95, ["Neon"] = 103.69, ["Neon|Ride"] = 125.95, ["Neon|Fly|Ride"] = 323.4, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6300, ["Ride"] = 5118.75, ["Fly|Ride"] = 5249.99, ["Neon"] = 32003.24, ["Neon|Ride"] = 28461.28, ["Neon|Fly|Ride"] = 27749.39}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 227.05, ["Fly"] = 254.68, ["Ride"] = 231.55, ["Fly|Ride"] = 275.52, ["Neon"] = 747.11, ["Neon|Fly|Ride"] = 619.18, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 53.64, ["Fly"] = 161.44, ["Ride"] = 105, ["Fly|Ride"] = 181.68, ["Neon"] = 142.96, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 301.88, ["Mega"] = 496.13, ["Mega|Ride"] = 563.07, ["Mega|Fly|Ride"] = 619.5}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 89.16, ["Ride"] = 19.69, ["Fly|Ride"] = 81.38, ["Neon"] = 21, ["Neon|Fly"] = 85.4, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 499.8, ["Mega|Ride"] = 330.75, ["Mega|Fly|Ride"] = 250.69}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 52.5, ["Fly"] = 211.03, ["Ride"] = 129.11, ["Fly|Ride"] = 234.94, ["Neon"] = 210, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 391.12, ["Mega"] = 656.25, ["Mega|Ride"] = 1439.95, ["Mega|Fly|Ride"] = 765.72}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 16355.97, ["Ride"] = 13415.07, ["Fly|Ride"] = 11808.56, ["Neon|Fly|Ride"] = 22903.13, ["Mega|Fly|Ride"] = 78277.52}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 261.19, ["Ride"] = 383.11, ["Fly|Ride"] = 459.38, ["Neon|Ride"] = 1562.51, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 7231.82}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 57.85, ["Fly"] = 91.43, ["Ride"] = 72.16, ["Fly|Ride"] = 98.44, ["Neon"] = 1049.99, ["Neon|Ride"] = 328.11, ["Neon|Fly|Ride"] = 308.78, ["Mega|Fly|Ride"] = 3095.51}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 9.18, ["Ride"] = 23.12, ["Fly|Ride"] = 56.44, ["Neon"] = 66.11, ["Neon|Fly"] = 321.76, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 140.9, ["Mega"] = 393.75, ["Mega|Ride"] = 498.5, ["Mega|Fly|Ride"] = 498.5}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 393.74, ["Fly"] = 853.34, ["Ride"] = 393.75, ["Fly|Ride"] = 545.74, ["Neon"] = 1662.05, ["Neon|Ride"] = 1706.25, ["Neon|Fly|Ride"] = 1664.98, ["Mega|Fly|Ride"] = 5232.94}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 9.19, ["Ride"] = 39.38, ["Fly|Ride"] = 199.49, ["Neon"] = 32.82, ["Neon|Ride"] = 128.51, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 111.57, ["Mega|Fly"] = 263.92, ["Mega|Ride"] = 228.38, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 93.7, ["Fly"] = 167.91, ["Ride"] = 142.68, ["Fly|Ride"] = 193.58, ["Neon"] = 459.38, ["Neon|Fly"] = 525, ["Neon|Ride"] = 488.25, ["Neon|Fly|Ride"] = 523.69, ["Mega|Fly|Ride"] = 2199.07}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 11.82, ["Fly"] = 21.38, ["Ride"] = 18.71, ["Fly|Ride"] = 39.29, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 91.12, ["Mega"] = 2561.49, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 10.47}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 66.29, ["Ride"] = 86.62, ["Fly|Ride"] = 177.1, ["Neon"] = 353.07, ["Neon|Fly"] = 425.86, ["Neon|Ride"] = 406.87, ["Neon|Fly|Ride"] = 356.49, ["Mega|Ride"] = 1991.8, ["Mega|Fly|Ride"] = 1633.15}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 11.23, ["Fly"] = 80.07, ["Ride"] = 31.49, ["Fly|Ride"] = 91.88, ["Neon"] = 98.44, ["Neon|Ride"] = 133.84, ["Neon|Fly|Ride"] = 219.87, ["Mega"] = 575.29, ["Mega|Ride"] = 577.5, ["Mega|Fly|Ride"] = 570.01}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 31.5}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 72.17, ["Fly"] = 142.94, ["Ride"] = 91.88, ["Fly|Ride"] = 316.32, ["Neon"] = 384.05, ["Neon|Ride"] = 328.12, ["Neon|Fly|Ride"] = 511.87, ["Mega|Fly|Ride"] = 1695.06}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.15, ["Ride"] = 29.23, ["Fly|Ride"] = 137.23, ["Neon"] = 25.66, ["Neon|Ride"] = 135.56, ["Neon|Fly|Ride"] = 256.17, ["Mega"] = 177.18, ["Mega|Fly|Ride"] = 449.54}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 11.81, ["Fly"] = 56.44, ["Ride"] = 37.34, ["Fly|Ride"] = 99.99, ["Neon"] = 65.07, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 199.6, ["Mega|Ride"] = 639.39, ["Mega|Fly|Ride"] = 512.37}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 431.82, ["Fly"] = 435.75, ["Ride"] = 528.99, ["Fly|Ride"] = 541.66, ["Neon|Fly|Ride"] = 2748.43, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 31.69, ["Fly"] = 106.68, ["Ride"] = 58.95, ["Fly|Ride"] = 97.71, ["Neon"] = 129.94, ["Neon|Ride"] = 170.79, ["Neon|Fly|Ride"] = 339.42, ["Mega"] = 776.43, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 717.84}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 44.93, ["Fly"] = 142.94, ["Ride"] = 71.47, ["Fly|Ride"] = 142.94, ["Neon"] = 234.94, ["Neon|Ride"] = 162.29, ["Neon|Fly|Ride"] = 319.13, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 18.38, ["Fly"] = 86.25, ["Ride"] = 57.62, ["Fly|Ride"] = 100.29, ["Neon"] = 87.94, ["Neon|Fly"] = 170.79, ["Neon|Ride"] = 141.65, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 438.38, ["Mega|Fly"] = 525, ["Mega|Ride"] = 465.84, ["Mega|Fly|Ride"] = 611.1}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Ride"] = 8862, ["Fly|Ride"] = 8107.32, ["Neon|Fly|Ride"] = 14311.5, ["Mega|Fly|Ride"] = 38850}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1344, ["Fly"] = 1486.83, ["Ride"] = 1443.75, ["Fly|Ride"] = 1429.32, ["Neon|Fly|Ride"] = 4851}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 597.34, ["Ride"] = 618.68, ["Fly|Ride"] = 795.82, ["Neon"] = 2253.58, ["Neon|Fly|Ride"] = 2625, ["Mega"] = 21345.69, ["Mega|Fly|Ride"] = 9819.12}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 11.45, ["Fly"] = 23.85, ["Ride"] = 21.42, ["Fly|Ride"] = 38.85, ["Neon"] = 71.49, ["Neon|Ride"] = 90.27, ["Neon|Fly|Ride"] = 127.02, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 577.49}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 6.04, ["Fly"] = 78.74, ["Ride"] = 29.89, ["Fly|Ride"] = 131.25, ["Neon"] = 22.23, ["Neon|Ride"] = 56.11, ["Mega"] = 184.04, ["Mega|Ride"] = 198.41, ["Mega|Fly|Ride"] = 285.87}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 31.49, ["Fly"] = 59.78, ["Ride"] = 48.2, ["Fly|Ride"] = 103.58, ["Neon"] = 542.29, ["Neon|Ride"] = 150.94, ["Neon|Fly|Ride"] = 181.13, ["Mega|Fly|Ride"] = 666.75}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.15, ["Fly"] = 23.39, ["Ride"] = 18.19, ["Fly|Ride"] = 40.16, ["Neon"] = 23.62, ["Neon|Fly"] = 86.63, ["Neon|Ride"] = 44.84, ["Neon|Fly|Ride"] = 98.43, ["Mega"] = 319.13, ["Mega|Ride"] = 231.27, ["Mega|Fly|Ride"] = 269.07}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 337.51, ["Fly"] = 369.5, ["Ride"] = 282, ["Fly|Ride"] = 371.44, ["Neon"] = 1108.28, ["Neon|Ride"] = 1438.71, ["Neon|Fly|Ride"] = 1191.81, ["Mega|Fly|Ride"] = 4436.11}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 20.1, ["Fly"] = 60.24, ["Ride"] = 41.99, ["Fly|Ride"] = 78.66, ["Neon"] = 131.25, ["Neon|Fly"] = 403.22, ["Neon|Ride"] = 141.71, ["Neon|Fly|Ride"] = 231, ["Mega"] = 853.84, ["Mega|Fly"] = 900.19, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 642.9}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 7.88, ["Fly"] = 18.38, ["Ride"] = 21.4, ["Fly|Ride"] = 40.68, ["Neon"] = 83.22, ["Neon|Fly"] = 120.62, ["Neon|Ride"] = 80.76, ["Neon|Fly|Ride"] = 104.21, ["Mega"] = 1575, ["Mega|Ride"] = 607.49, ["Mega|Fly|Ride"] = 423.94}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 668.81, ["Fly"] = 1048.69, ["Ride"] = 567, ["Fly|Ride"] = 481.87, ["Neon|Fly|Ride"] = 3559.41, ["Mega|Fly|Ride"] = 9971.07}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1115.63, ["Fly"] = 1422.92, ["Ride"] = 1214.04, ["Fly|Ride"] = 1291.8, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 13234.83}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 87.94, ["Fly"] = 142.94, ["Ride"] = 96.29, ["Fly|Ride"] = 125.27, ["Neon"] = 512.06, ["Neon|Ride"] = 587.03, ["Neon|Fly|Ride"] = 480.64, ["Mega|Fly|Ride"] = 2804.74}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 182.44, ["Fly"] = 209.99, ["Ride"] = 204.74, ["Fly|Ride"] = 262.49, ["Neon"] = 957.11, ["Neon|Ride"] = 557.82, ["Neon|Fly|Ride"] = 721.66, ["Mega|Ride"] = 9187.5, ["Mega|Fly|Ride"] = 2598.75}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 29.39, ["Fly"] = 57.62, ["Ride"] = 35.9, ["Fly|Ride"] = 100.29, ["Neon"] = 236.25, ["Neon|Ride"] = 240.55, ["Mega|Ride"] = 2134.83, ["Mega|Fly|Ride"] = 1078.75}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 328.13, ["Ride"] = 315, ["Fly|Ride"] = 426.68, ["Neon"] = 1220.63, ["Neon|Fly|Ride"] = 1280.75, ["Mega|Fly|Ride"] = 5693.59}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 1968.75, ["Fly"] = 2133.31, ["Ride"] = 1955.63, ["Fly|Ride"] = 2100, ["Neon|Fly|Ride"] = 10672.85, ["Mega|Fly|Ride"] = 35357.45}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 57.62, ["Fly"] = 213.35, ["Ride"] = 51.18, ["Fly|Ride"] = 196.88, ["Neon"] = 288.75, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 343.88, ["Mega"] = 1423.77, ["Mega|Ride"] = 1138.95, ["Mega|Fly|Ride"] = 1253.15}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 623.42, ["Fly"] = 853.34, ["Ride"] = 630, ["Fly|Ride"] = 590.63, ["Neon|Ride"] = 1498.88, ["Neon|Fly|Ride"] = 1276.96, ["Mega|Fly|Ride"] = 3451.88}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 45.84, ["Fly"] = 52.5, ["Ride"] = 54.6, ["Fly|Ride"] = 87.05, ["Neon"] = 262.5, ["Neon|Ride"] = 213.47, ["Neon|Fly|Ride"] = 242.82, ["Mega|Ride"] = 1067.42, ["Mega|Fly|Ride"] = 1122.15}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 2.6, ["Fly"] = 32.71, ["Ride"] = 19.48, ["Fly|Ride"] = 51.96, ["Neon"] = 36.28, ["Neon|Fly"] = 74.82, ["Neon|Ride"] = 52.36, ["Neon|Fly|Ride"] = 97.44, ["Mega"] = 179.82, ["Mega|Ride"] = 186.27, ["Mega|Fly|Ride"] = 282.19}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 58.59, ["Ride"] = 128.91, ["Fly|Ride"] = 157.5, ["Neon"] = 272.76, ["Neon|Ride"] = 452.82, ["Neon|Fly|Ride"] = 711.89, ["Mega"] = 1562.51, ["Mega|Ride"] = 1707.87}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 845.9, ["Ride"] = 826.88, ["Fly|Ride"] = 888.57, ["Neon|Ride"] = 3253.67, ["Neon|Fly|Ride"] = 3064.69, ["Mega|Fly|Ride"] = 12053}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 641.82, ["Ride"] = 856.47, ["Fly|Ride"] = 912.11, ["Neon|Fly|Ride"] = 2846.46, ["Mega|Fly|Ride"] = 15511.62}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 15.59, ["Fly"] = 23.91, ["Ride"] = 22.98, ["Fly|Ride"] = 50.14, ["Neon"] = 144.38, ["Neon|Ride"] = 113.91, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 783.4, ["Mega|Fly|Ride"] = 722.52}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 13.55, ["Ride"] = 31.47, ["Fly|Ride"] = 118.43, ["Neon"] = 129.35, ["Neon|Ride"] = 129.03, ["Neon|Fly|Ride"] = 248.07, ["Mega"] = 996.86, ["Mega|Ride"] = 852.88, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 4.29, ["Ride"] = 41.99, ["Fly|Ride"] = 141.72, ["Neon"] = 20.99, ["Neon|Fly"] = 321.85, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 228.54, ["Mega"] = 176.68, ["Mega|Fly"] = 562.77, ["Mega|Ride"] = 202.6, ["Mega|Fly|Ride"] = 356.53}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 41.4, ["Fly"] = 50.94, ["Ride"] = 49.88, ["Fly|Ride"] = 111.17, ["Neon"] = 223.13, ["Neon|Fly"] = 207.08, ["Neon|Ride"] = 162.75, ["Neon|Fly|Ride"] = 242.81, ["Mega|Ride"] = 890.24, ["Mega|Fly|Ride"] = 1035.57}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 83.51, ["Ride"] = 184.04, ["Fly|Ride"] = 356.32, ["Neon"] = 428.35, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 2419.55, ["Mega|Ride"] = 2290.09, ["Mega|Fly|Ride"] = 2261.86}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 11.8, ["Fly"] = 52.41, ["Ride"] = 38.07, ["Fly|Ride"] = 63.66, ["Neon"] = 76.31, ["Neon|Fly"] = 85.4, ["Neon|Ride"] = 98.43, ["Neon|Fly|Ride"] = 219.87, ["Mega"] = 425.39, ["Mega|Ride"] = 340.74, ["Mega|Fly|Ride"] = 514.17}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 34.04, ["Fly"] = 52.5, ["Ride"] = 39.38, ["Fly|Ride"] = 94, ["Neon"] = 242.82, ["Neon|Ride"] = 181, ["Neon|Fly|Ride"] = 234.92, ["Mega"] = 2100, ["Mega|Fly|Ride"] = 1241.62}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 2.1, ["Fly"] = 19.22, ["Ride"] = 15.75, ["Fly|Ride"] = 43.38, ["Neon"] = 25.66, ["Neon|Fly"] = 37.37, ["Neon|Ride"] = 59.76, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 434.74, ["Mega|Ride"] = 482.14, ["Mega|Fly|Ride"] = 369.71}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 7.19, ["Fly"] = 64.02, ["Ride"] = 46.95, ["Fly|Ride"] = 86.63, ["Neon"] = 52.39, ["Neon|Fly"] = 114.19, ["Neon|Ride"] = 68.25, ["Neon|Fly|Ride"] = 235.89, ["Mega"] = 416.06, ["Mega|Ride"] = 414.22, ["Mega|Fly|Ride"] = 485.63}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 46.33, ["Fly"] = 70.72, ["Ride"] = 48.76, ["Fly|Ride"] = 102.01, ["Neon"] = 578.43, ["Neon|Fly"] = 211.3, ["Neon|Ride"] = 276.53, ["Neon|Fly|Ride"] = 249.38, ["Mega|Fly|Ride"] = 1074.92}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1443.75, ["Fly"] = 1410.94, ["Ride"] = 1389.93, ["Fly|Ride"] = 1456.88, ["Neon"] = 4457.16, ["Neon|Ride"] = 4820.24, ["Neon|Fly|Ride"] = 3632.98, ["Mega|Fly|Ride"] = 16011.17}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 472.49, ["Fly"] = 524.99, ["Ride"] = 465.94, ["Fly|Ride"] = 479.07, ["Neon|Ride"] = 3131.43, ["Neon|Fly|Ride"] = 2362.5, ["Mega"] = 14941.99}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 287.44, ["Fly"] = 378.23, ["Ride"] = 326.82, ["Fly|Ride"] = 354.38, ["Neon"] = 1575, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 7683.23}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 36.75}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 32.43, ["Ride"] = 42, ["Fly|Ride"] = 99.73, ["Neon"] = 325.5, ["Neon|Fly"] = 426.93, ["Neon|Ride"] = 192.12, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 1707.87, ["Mega|Fly|Ride"] = 1036.54}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 70875, ["Fly"] = 23466.23, ["Ride"] = 36137.16, ["Fly|Ride"] = 18374.91, ["Neon|Fly|Ride"] = 38061.19, ["Mega"] = 213456.78, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 232.31, ["Fly"] = 262.5, ["Ride"] = 244.12, ["Fly|Ride"] = 334.68, ["Neon"] = 1039.98, ["Neon|Ride"] = 982.75, ["Neon|Fly|Ride"] = 879.38, ["Mega"] = 6403.72, ["Mega|Fly|Ride"] = 3943.03}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 216.46, ["Fly"] = 525, ["Ride"] = 249.38, ["Fly|Ride"] = 257.27}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 162.74, ["Fly"] = 157.5, ["Ride"] = 132.46, ["Fly|Ride"] = 143.07, ["Neon"] = 543.79, ["Neon|Ride"] = 524.99, ["Neon|Fly|Ride"] = 630, ["Mega|Ride"] = 3559.83, ["Mega|Fly|Ride"] = 2986.62}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 11.81, ["Fly"] = 64.02, ["Ride"] = 26.72, ["Fly|Ride"] = 84.29, ["Neon"] = 131.25, ["Neon|Ride"] = 114.21, ["Neon|Fly|Ride"] = 228.42, ["Mega"] = 720.63, ["Mega|Ride"] = 482.14, ["Mega|Fly|Ride"] = 960.68}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 4969.53, ["Ride"] = 3937.5, ["Fly|Ride"] = 4068.75, ["Neon"] = 21335.5, ["Neon|Fly|Ride"] = 15750}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 27.95, ["Fly"] = 41.9, ["Ride"] = 34.12, ["Fly|Ride"] = 49.88, ["Neon"] = 131.25, ["Neon|Ride"] = 184.36, ["Neon|Fly|Ride"] = 199.4, ["Mega|Ride"] = 1423.94, ["Mega|Fly|Ride"] = 723.19}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 36.75, ["Ride"] = 39.38, ["Fly|Ride"] = 102.84, ["Neon"] = 311.32, ["Neon|Fly"] = 1423.77, ["Neon|Ride"] = 202.79, ["Neon|Fly|Ride"] = 262.49, ["Mega|Fly|Ride"] = 1378.05}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 459.38, ["Fly"] = 563.06, ["Ride"] = 492.19, ["Fly|Ride"] = 557.82, ["Neon"] = 1312.5, ["Neon|Ride"] = 1242.83, ["Neon|Fly|Ride"] = 1378.13, ["Mega|Fly|Ride"] = 5481.16}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 19.68, ["Fly"] = 28.65, ["Ride"] = 23.12, ["Fly|Ride"] = 38.07, ["Neon"] = 131.24, ["Neon|Fly"] = 161.18, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 143.04, ["Mega|Ride"] = 611.1, ["Mega|Fly|Ride"] = 550.25}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 13.84, ["Ride"] = 34.54, ["Fly|Ride"] = 80.64, ["Neon"] = 98.43, ["Neon|Ride"] = 124.14, ["Neon|Fly|Ride"] = 209.09, ["Mega"] = 562.77, ["Mega|Ride"] = 747.3, ["Mega|Fly|Ride"] = 528.39}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 97.13, ["Ride"] = 103.69, ["Fly|Ride"] = 242.18, ["Neon"] = 1285.36, ["Neon|Ride"] = 588.09, ["Neon|Fly|Ride"] = 698.01, ["Mega|Fly|Ride"] = 2410.62}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 17.05, ["Fly"] = 70.42, ["Ride"] = 64.31, ["Fly|Ride"] = 471.07, ["Neon"] = 89.97, ["Neon|Fly"] = 122.75, ["Neon|Ride"] = 135.56, ["Neon|Fly|Ride"] = 196.86, ["Mega"] = 329.84, ["Mega|Fly"] = 487.1, ["Mega|Ride"] = 316.32, ["Mega|Fly|Ride"] = 478.17}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3947.5, ["Fly"] = 6201.16, ["Ride"] = 4068.75, ["Fly|Ride"] = 4134.38, ["Neon"] = 19687.5, ["Neon|Ride"] = 12337.5, ["Neon|Fly|Ride"] = 10354.32, ["Mega"] = 48384.27, ["Mega|Fly|Ride"] = 37945.69}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 33.08, ["Fly"] = 142.94, ["Ride"] = 65.63, ["Fly|Ride"] = 144.38, ["Neon"] = 215.25, ["Neon|Ride"] = 258.57, ["Neon|Fly|Ride"] = 320.2, ["Mega"] = 853.84, ["Mega|Ride"] = 1768.18, ["Mega|Fly|Ride"] = 784.88}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 5775, ["Fly"] = 7573.2, ["Ride"] = 6857.82, ["Fly|Ride"] = 6431.25, ["Neon|Fly|Ride"] = 15225, ["Mega|Fly|Ride"] = 46921.88}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.63, ["Fly"] = 18.88, ["Ride"] = 16.3, ["Fly|Ride"] = 38.36, ["Neon"] = 24.92, ["Neon|Fly"] = 62.62, ["Neon|Ride"] = 30.24, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 229.69, ["Mega|Ride"] = 372.75, ["Mega|Fly|Ride"] = 257.95}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 18.24, ["Fly"] = 31.5, ["Ride"] = 32.5, ["Fly|Ride"] = 61.88, ["Neon"] = 185.63, ["Neon|Fly"] = 235.89, ["Neon|Ride"] = 498.44, ["Neon|Fly|Ride"] = 167.99, ["Mega|Ride"] = 991.6, ["Mega|Fly|Ride"] = 996.98}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 4.2}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 11.05, ["Ride"] = 26.46, ["Fly|Ride"] = 87.02, ["Neon"] = 68.79, ["Neon|Ride"] = 118.13, ["Mega"] = 1018.61, ["Mega|Ride"] = 1065.29, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 22.29, ["Fly"] = 190.37, ["Ride"] = 42.69, ["Fly|Ride"] = 170.7, ["Neon"] = 203.44, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 945, ["Mega|Ride"] = 853.94, ["Mega|Fly|Ride"] = 1099.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 12.49, ["Fly"] = 27.75, ["Ride"] = 16.96, ["Fly|Ride"] = 38.07, ["Neon|Fly"] = 1064.1, ["Neon|Ride"] = 118.49, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 2561.49, ["Mega|Fly|Ride"] = 570.01}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8687.53}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2624.99}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 18.38}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 161.44, ["Ride"] = 391.47, ["Fly|Ride"] = 315, ["Mega|Fly|Ride"] = 4200}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 15.12, ["Fly"] = 142.94, ["Ride"] = 31.49, ["Fly|Ride"] = 142.96, ["Neon"] = 85.4, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 265.13, ["Mega"] = 525, ["Mega|Ride"] = 531.55, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 10.9}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 6.18, ["Ride"] = 26.24, ["Fly|Ride"] = 85.36, ["Neon|Ride"] = 155.84, ["Mega"] = 1565.72}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2357.24}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 152.81, ["Fly"] = 356.27, ["Ride"] = 261.18, ["Fly|Ride"] = 328.13, ["Neon"] = 996.38, ["Neon|Ride"] = 964.06, ["Neon|Fly|Ride"] = 777, ["Mega|Ride"] = 4127.69, ["Mega|Fly|Ride"] = 3936.45}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 61.69, ["Fly"] = 183.75, ["Ride"] = 84.62, ["Fly|Ride"] = 240.94, ["Neon"] = 315, ["Neon|Ride"] = 356.55, ["Neon|Fly|Ride"] = 711.89, ["Mega|Ride"] = 1850.9, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 155.89, ["Fly"] = 196.88, ["Ride"] = 170.61, ["Fly|Ride"] = 240.97, ["Neon"] = 944.99, ["Neon|Ride"] = 787.49, ["Neon|Fly|Ride"] = 823.8, ["Mega"] = 3986.32, ["Mega|Fly|Ride"] = 3490.1}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 2395.32, ["Fly"] = 3069.87, ["Ride"] = 2604.29, ["Fly|Ride"] = 2631.9, ["Neon"] = 14983.92, ["Neon|Ride"] = 9640.46, ["Neon|Fly|Ride"] = 7218.75, ["Mega|Fly|Ride"] = 27041.8}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 16.02, ["Fly"] = 182.41, ["Ride"] = 42.14, ["Fly|Ride"] = 105.63, ["Neon"] = 120.48, ["Neon|Fly"] = 161.48, ["Neon|Ride"] = 154.27, ["Neon|Fly|Ride"] = 228.42, ["Mega"] = 959.51, ["Mega|Ride"] = 996.98, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 840, ["Fly"] = 2100, ["Ride"] = 996.26, ["Fly|Ride"] = 867.18, ["Neon|Fly|Ride"] = 4177.94}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 36.75}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 21, ["Ride"] = 50.6, ["Fly|Ride"] = 131.25, ["Neon"] = 78.75, ["Neon|Ride"] = 128.09, ["Neon|Fly|Ride"] = 314.87, ["Mega"] = 480.38, ["Mega|Fly"] = 964.06, ["Mega|Ride"] = 509.36, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 6.57, ["Fly"] = 48.2, ["Ride"] = 27.95, ["Fly|Ride"] = 128.03, ["Neon"] = 57.66, ["Neon|Fly"] = 315, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 209.94, ["Mega"] = 450.71, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 405.63}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 61.71}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 19.22, ["Fly"] = 55.13, ["Ride"] = 27.71, ["Fly|Ride"] = 100.29, ["Neon|Ride"] = 192.83, ["Neon|Fly|Ride"] = 254.63, ["Mega|Fly|Ride"] = 2134.83}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 41.02, ["Fly"] = 45.94, ["Ride"] = 39.37, ["Fly|Ride"] = 55.13, ["Neon|Fly"] = 235.89, ["Neon|Ride"] = 293.52, ["Neon|Fly|Ride"] = 170.79, ["Mega"] = 1423.77, ["Mega|Ride"] = 1807.97, ["Mega|Fly|Ride"] = 989.63}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6463.89, ["Fly"] = 10237.5, ["Ride"] = 7875, ["Fly|Ride"] = 4790.63, ["Neon|Fly|Ride"] = 9875.25, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 7.65, ["Fly"] = 61.69, ["Ride"] = 26.17, ["Fly|Ride"] = 81.38, ["Neon"] = 54.55, ["Neon|Ride"] = 82.57, ["Neon|Fly|Ride"] = 199.6, ["Mega"] = 512.32, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 535.5}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 19.66}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 83.35, ["Fly"] = 377.61, ["Ride"] = 124.69, ["Fly|Ride"] = 157.5, ["Neon"] = 485, ["Neon|Ride"] = 511.62, ["Neon|Fly|Ride"] = 476.6, ["Mega"] = 2879.59, ["Mega|Ride"] = 1764.77, ["Mega|Fly|Ride"] = 2450.79}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 48.09, ["Fly"] = 189.02, ["Ride"] = 65.63, ["Fly|Ride"] = 190.32, ["Neon"] = 347.82, ["Neon|Ride"] = 284.97, ["Neon|Fly|Ride"] = 446.25, ["Mega"] = 2410.13, ["Mega|Ride"] = 2882.02, ["Mega|Fly|Ride"] = 1046.07}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 21, ["Fly"] = 43.32, ["Ride"] = 28.29, ["Fly|Ride"] = 66.81, ["Neon"] = 128.78, ["Neon|Fly"] = 230.54, ["Neon|Ride"] = 135.57, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 1016.21, ["Mega|Ride"] = 867.83, ["Mega|Fly|Ride"] = 800.62}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 6, ["Fly"] = 72.54, ["Ride"] = 26.25, ["Fly|Ride"] = 112.59, ["Neon"] = 28.58, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 129.84, ["Mega"] = 157.5, ["Mega|Fly"] = 285.16, ["Mega|Ride"] = 221.79, ["Mega|Fly|Ride"] = 326.03}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 10.5, ["Ride"] = 30.4, ["Fly|Ride"] = 98.06, ["Neon"] = 100.42, ["Neon|Ride"] = 120.74, ["Neon|Fly|Ride"] = 218.28, ["Mega"] = 551.25, ["Mega|Ride"] = 634.06, ["Mega|Fly|Ride"] = 586.27}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 21, ["Fly"] = 27.51, ["Ride"] = 29.8, ["Fly|Ride"] = 52.41, ["Neon|Fly"] = 144.38, ["Neon|Ride"] = 128.62, ["Neon|Fly|Ride"] = 137.82, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 200.82}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 32.02, ["Fly"] = 100.28, ["Ride"] = 131.23, ["Fly|Ride"] = 284.85, ["Neon"] = 209.99, ["Neon|Ride"] = 276.44, ["Neon|Fly|Ride"] = 355.51, ["Mega"] = 866.25, ["Mega|Fly|Ride"] = 678.57}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 290.64, ["Ride"] = 298.68, ["Fly|Ride"] = 433.69, ["Neon|Fly|Ride"] = 28461.28}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 61.69, ["Fly"] = 213.35, ["Ride"] = 87.41, ["Fly|Ride"] = 185.8, ["Neon"] = 275.63, ["Neon|Ride"] = 342.25, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 986.23, ["Mega|Ride"] = 1134.68, ["Mega|Fly|Ride"] = 1274.51}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 1179.72, ["Fly"] = 1209.59, ["Ride"] = 1023.74, ["Fly|Ride"] = 990.12, ["Neon|Fly"] = 4370.75, ["Neon|Ride"] = 4127.21, ["Neon|Fly|Ride"] = 3281.25, ["Mega"] = 21691.02, ["Mega|Fly|Ride"] = 13125}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 295.32, ["Fly"] = 711.46, ["Ride"] = 282.19, ["Fly|Ride"] = 470.57, ["Neon"] = 2388.75, ["Neon|Ride"] = 3131.43, ["Neon|Fly|Ride"] = 1928.11, ["Mega"] = 12212.05, ["Mega|Fly|Ride"] = 9448.69}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 54.8}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.63}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 10.49, ["Fly"] = 31.4, ["Ride"] = 23.55, ["Fly|Ride"] = 42.69, ["Neon"] = 78.75, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 70.62, ["Neon|Fly|Ride"] = 137.75, ["Mega"] = 437.26, ["Mega|Ride"] = 711.98, ["Mega|Fly|Ride"] = 562.53}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 249.31, ["Fly"] = 409.16, ["Ride"] = 280.74, ["Fly|Ride"] = 367.49, ["Neon"] = 2409.28, ["Neon|Ride"] = 954.19, ["Neon|Fly|Ride"] = 1588.13, ["Mega|Fly|Ride"] = 2991.77}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 14.05}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 119.54, ["Ride"] = 173.97, ["Fly|Ride"] = 262.5, ["Neon"] = 636.06, ["Neon|Fly"] = 610.32, ["Neon|Ride"] = 551.25, ["Neon|Fly|Ride"] = 656.24, ["Mega"] = 2346.96, ["Mega|Ride"] = 2231.25, ["Mega|Fly|Ride"] = 2220.88}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 112.2, ["Fly"] = 213.35, ["Ride"] = 137.11, ["Fly|Ride"] = 142.96, ["Neon"] = 498.2, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 853.84, ["Mega|Fly|Ride"] = 3084.38}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 4.73, ["Ride"] = 23.63, ["Fly|Ride"] = 52.5, ["Neon"] = 36.63, ["Neon|Ride"] = 69.62, ["Neon|Fly|Ride"] = 251.89, ["Mega"] = 189.32, ["Mega|Ride"] = 189.84, ["Mega|Fly|Ride"] = 373.61}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 14.43, ["Fly"] = 71.48, ["Ride"] = 30.18, ["Fly|Ride"] = 69.57, ["Neon"] = 131.25, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 321.76, ["Mega|Ride"] = 1423.94, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 11.81, ["Fly"] = 102.36, ["Ride"] = 34.05, ["Fly|Ride"] = 128, ["Neon"] = 72.19, ["Neon|Ride"] = 101.06, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 425.86, ["Mega|Ride"] = 519.75, ["Mega|Fly|Ride"] = 426.98}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 4.79, ["Fly"] = 104.99, ["Ride"] = 49.88, ["Fly|Ride"] = 150.63, ["Neon"] = 31.4, ["Neon|Ride"] = 74.82, ["Neon|Fly|Ride"] = 172.11, ["Mega"] = 157.4, ["Mega|Fly"] = 273.57, ["Mega|Ride"] = 174.77, ["Mega|Fly|Ride"] = 295.32}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 258.07, ["Ride"] = 262.5, ["Fly|Ride"] = 327.89, ["Neon"] = 1600.17, ["Neon|Ride"] = 1373.78, ["Neon|Fly|Ride"] = 1381.75, ["Mega|Fly|Ride"] = 4981.62}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 94.5, ["Fly"] = 569.6, ["Ride"] = 142.92, ["Fly|Ride"] = 246.61, ["Neon"] = 412.27, ["Neon|Ride"] = 485.63, ["Neon|Fly|Ride"] = 590.63, ["Mega|Fly|Ride"] = 2028.09}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 63, ["Fly"] = 94.5, ["Ride"] = 78.74, ["Fly|Ride"] = 126, ["Neon"] = 262.5, ["Neon|Ride"] = 331.05, ["Neon|Fly|Ride"] = 415.8, ["Mega"] = 1423.77, ["Mega|Ride"] = 1768.18, ["Mega|Fly|Ride"] = 1372.88}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 19.67, ["Fly"] = 126, ["Ride"] = 36.28, ["Fly|Ride"] = 284.85, ["Neon"] = 170.7, ["Neon|Ride"] = 612.19, ["Neon|Fly|Ride"] = 498.44, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 12.47, ["Fly"] = 77.18, ["Ride"] = 30.16, ["Fly|Ride"] = 91.88, ["Neon"] = 68.57, ["Neon|Fly"] = 143.03, ["Neon|Ride"] = 118.49, ["Neon|Fly|Ride"] = 157.49, ["Mega"] = 384.23, ["Mega|Fly"] = 525, ["Mega|Ride"] = 482.14, ["Mega|Fly|Ride"] = 590.61}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.72, ["Fly"] = 36.75, ["Ride"] = 21.41, ["Fly|Ride"] = 69.57, ["Neon"] = 23.41, ["Neon|Fly"] = 76.94, ["Neon|Ride"] = 45.93, ["Neon|Fly|Ride"] = 113.29, ["Mega"] = 166.67, ["Mega|Ride"] = 170.52, ["Mega|Fly|Ride"] = 269.13}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 879.38, ["Fly"] = 918.75, ["Ride"] = 853.34, ["Fly|Ride"] = 971.25, ["Neon"] = 4267.11, ["Neon|Fly"] = 3271.74, ["Neon|Ride"] = 3131.43, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 8098.23}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 262.49, ["Fly"] = 398.94, ["Ride"] = 288.65, ["Fly|Ride"] = 470.47, ["Neon|Ride"] = 1270.5, ["Neon|Fly|Ride"] = 1246.88, ["Mega"] = 10672.85, ["Mega|Fly|Ride"] = 4331.25}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 91.87, ["Fly"] = 157.88, ["Ride"] = 99.27, ["Fly|Ride"] = 131.25, ["Neon"] = 420, ["Neon|Fly"] = 482.04, ["Neon|Ride"] = 388.01, ["Neon|Fly|Ride"] = 284.83, ["Mega"] = 1494.22, ["Mega|Ride"] = 1722.82, ["Mega|Fly|Ride"] = 1694}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 168, ["Fly"] = 283.5, ["Ride"] = 184.94, ["Fly|Ride"] = 208.39, ["Neon|Ride"] = 971.25, ["Neon|Fly|Ride"] = 917.44, ["Mega"] = 10672.85, ["Mega|Fly|Ride"] = 3700.73}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 24.67, ["Fly"] = 42.69, ["Ride"] = 28.86, ["Fly|Ride"] = 86.63, ["Neon"] = 169.31, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 204.75, ["Mega|Ride"] = 712.48, ["Mega|Fly|Ride"] = 938.27}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 236.24, ["Ride"] = 261.02, ["Fly|Ride"] = 358.32, ["Neon"] = 846.11, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 1050, ["Mega"] = 4252.06, ["Mega|Fly|Ride"] = 3559.83}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 76.13, ["Fly"] = 125.99, ["Ride"] = 80.07, ["Fly|Ride"] = 127.32, ["Neon|Ride"] = 569.94, ["Mega|Fly|Ride"] = 1417.5}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 2716.88, ["Ride"] = 2453.24, ["Fly|Ride"] = 2472.75, ["Neon|Ride"] = 8538.29, ["Neon|Fly|Ride"] = 6747.13, ["Mega"] = 51229.64, ["Mega|Fly|Ride"] = 26301.01}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 7.88, ["Fly"] = 78.04, ["Ride"] = 31.11, ["Fly|Ride"] = 77.84, ["Neon"] = 55.12, ["Neon|Fly"] = 105, ["Neon|Ride"] = 74.64, ["Neon|Fly|Ride"] = 164.06, ["Mega"] = 274.32, ["Mega|Fly"] = 569.94, ["Mega|Ride"] = 320.41, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 59.8, ["Ride"] = 59.07, ["Fly|Ride"] = 161.44, ["Neon"] = 196.88, ["Neon|Ride"] = 256.17, ["Neon|Fly|Ride"] = 484.57, ["Mega|Ride"] = 931.88, ["Mega|Fly|Ride"] = 1084.78}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 70.42, ["Fly"] = 91.87, ["Ride"] = 82.42, ["Fly|Ride"] = 87.69, ["Neon"] = 525, ["Neon|Ride"] = 640.38, ["Neon|Fly|Ride"] = 410.79, ["Mega|Fly|Ride"] = 1879.84}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 2203.69, ["Fly"] = 1606.91, ["Ride"] = 1069.69, ["Fly|Ride"] = 951.57, ["Neon|Ride"] = 5141.99, ["Neon|Fly|Ride"] = 4269.15, ["Mega"] = 34864.98, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 525, ["Fly"] = 851.2, ["Ride"] = 566.18, ["Fly|Ride"] = 534.19, ["Mega"] = 11206.49, ["Mega|Fly|Ride"] = 11386.08}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 70.45, ["Fly"] = 321.7, ["Ride"] = 85.34, ["Fly|Ride"] = 208.69, ["Neon"] = 341.25, ["Neon|Ride"] = 342.55, ["Neon|Fly|Ride"] = 562.77, ["Mega"] = 1993.7, ["Mega|Ride"] = 2572.12, ["Mega|Fly|Ride"] = 1619.1}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 5.25, ["Fly"] = 32.82, ["Ride"] = 19.69, ["Fly|Ride"] = 72.19, ["Neon"] = 75.09, ["Neon|Ride"] = 84.25, ["Neon|Fly|Ride"] = 161.27, ["Mega"] = 553.88, ["Mega|Ride"] = 807.53}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 34.96, ["Fly"] = 68.25, ["Ride"] = 43.34, ["Fly|Ride"] = 56.44, ["Neon"] = 284.82, ["Neon|Fly"] = 356.49, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 341.55, ["Mega|Ride"] = 1187.82, ["Mega|Fly|Ride"] = 1049.99}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 745.5, ["Fly"] = 1108.22, ["Ride"] = 651.49, ["Fly|Ride"] = 860.99, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2508.42, ["Mega|Fly|Ride"] = 9723}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 591.71}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 6963.8, ["Ride"] = 6116.17, ["Fly|Ride"] = 5775, ["Neon"] = 42000, ["Neon|Ride"] = 30589.43, ["Neon|Fly|Ride"] = 18375, ["Mega|Fly|Ride"] = 106599.12}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 255.43, ["Fly"] = 400, ["Ride"] = 284.81, ["Fly|Ride"] = 412.85, ["Neon"] = 1312.5, ["Neon|Ride"] = 1850.68, ["Neon|Fly|Ride"] = 1706.25, ["Mega"] = 6402.65, ["Mega|Ride"] = 6118.41, ["Mega|Fly|Ride"] = 6120.55}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 71.34, ["Fly"] = 284.81, ["Ride"] = 144.26, ["Fly|Ride"] = 336, ["Neon"] = 711.56, ["Neon|Ride"] = 996.86, ["Neon|Fly|Ride"] = 640.38}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 15.74, ["Fly"] = 100.28, ["Ride"] = 32.69, ["Fly|Ride"] = 91.75, ["Neon"] = 124.13, ["Neon|Ride"] = 127.33, ["Neon|Fly|Ride"] = 213.47, ["Mega"] = 711.89, ["Mega|Ride"] = 853.94, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 11.82, ["Fly"] = 26.24, ["Ride"] = 27.19, ["Fly|Ride"] = 43.32, ["Neon"] = 213.38, ["Neon|Ride"] = 114.21, ["Neon|Fly|Ride"] = 153.79, ["Mega"] = 1312.5, ["Mega|Ride"] = 380.63, ["Mega|Fly|Ride"] = 2134.83}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 16.36, ["Fly"] = 163.47, ["Ride"] = 31.5, ["Fly|Ride"] = 103.04, ["Neon"] = 124.67, ["Neon|Ride"] = 109.81, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 645.75, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 619.12}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 3.77, ["Fly"] = 62.94, ["Ride"] = 21.35, ["Fly|Ride"] = 48.57, ["Neon"] = 31.39, ["Neon|Ride"] = 56.65, ["Neon|Fly|Ride"] = 125.95, ["Mega"] = 661.56, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 204.23}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 27.67, ["Fly"] = 90.57, ["Ride"] = 45.94, ["Fly|Ride"] = 142.94, ["Neon"] = 156.58, ["Neon|Fly"] = 853.84, ["Neon|Ride"] = 230.54, ["Neon|Fly|Ride"] = 339.42, ["Mega"] = 630, ["Mega|Ride"] = 1260}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 498.96, ["Fly"] = 538.13, ["Ride"] = 525, ["Fly|Ride"] = 596.42, ["Neon|Ride"] = 1565.72, ["Neon|Fly|Ride"] = 1548.75, ["Mega"] = 7875, ["Mega|Fly|Ride"] = 5832.35}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.1, ["Fly"] = 19.58, ["Ride"] = 15.59, ["Fly|Ride"] = 38.04, ["Neon"] = 32.82, ["Neon|Ride"] = 32.1, ["Neon|Fly|Ride"] = 78.26, ["Mega"] = 170.63, ["Mega|Ride"] = 226.31, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 51.44, ["Fly"] = 114.19, ["Ride"] = 76.13, ["Fly|Ride"] = 137.71, ["Neon"] = 226.35, ["Neon|Fly"] = 284.97, ["Neon|Ride"] = 194.88, ["Neon|Fly|Ride"] = 261.19, ["Mega"] = 557.82, ["Mega|Fly"] = 853.84, ["Mega|Ride"] = 557.81, ["Mega|Fly|Ride"] = 609}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 761.25, ["Ride"] = 735, ["Fly|Ride"] = 787.5, ["Neon|Ride"] = 2134.58, ["Neon|Fly|Ride"] = 1557.95, ["Mega|Fly|Ride"] = 4265.63}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 33.39, ["Fly"] = 67.67, ["Ride"] = 51.16, ["Fly|Ride"] = 72.35, ["Neon"] = 262.5, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 183.65, ["Neon|Fly|Ride"] = 249.37, ["Mega"] = 1575, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 315, ["Fly"] = 481.93, ["Ride"] = 259.87, ["Fly|Ride"] = 337.31, ["Neon|Ride"] = 1850.68, ["Neon|Fly|Ride"] = 1850.68, ["Mega|Fly|Ride"] = 3700.73}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 242.82, ["Fly"] = 293.99, ["Ride"] = 249.38, ["Fly|Ride"] = 273.95, ["Neon|Ride"] = 892.5, ["Neon|Fly|Ride"] = 918.75, ["Mega"] = 4264.88, ["Mega|Fly|Ride"] = 3773.32}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 839.46, ["Ride"] = 803.46, ["Fly|Ride"] = 1024.11, ["Neon|Ride"] = 3791.12, ["Neon|Fly|Ride"] = 2953.19, ["Mega|Fly|Ride"] = 9711.19}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 16.14, ["Fly"] = 61.88, ["Ride"] = 46.35, ["Fly|Ride"] = 119.27, ["Neon"] = 78.75, ["Neon|Fly"] = 289.23, ["Neon|Ride"] = 91.77, ["Neon|Fly|Ride"] = 157.98, ["Mega"] = 354.38, ["Mega|Ride"] = 356.79, ["Mega|Fly|Ride"] = 643.64}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 4084.49, ["Fly"] = 3438.49, ["Ride"] = 3281.25, ["Fly|Ride"] = 3346.87, ["Neon|Fly|Ride"] = 6562.5, ["Mega|Fly|Ride"] = 18892.13}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 124.68, ["Fly"] = 170.68, ["Ride"] = 142.91, ["Fly|Ride"] = 205.96, ["Neon"] = 498.75, ["Neon|Fly"] = 712.69, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 577.5, ["Mega|Ride"] = 2988.77, ["Mega|Fly|Ride"] = 3141.41}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 28.24, ["Ride"] = 18.31, ["Fly|Ride"] = 50.96, ["Neon"] = 24.5, ["Neon|Fly"] = 65.62, ["Neon|Ride"] = 41.65, ["Neon|Fly|Ride"] = 102.92, ["Mega"] = 160.1, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 245.75, ["Mega|Fly|Ride"] = 235.92}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 2.63, ["Ride"] = 27.56, ["Fly|Ride"] = 59.07, ["Neon"] = 21, ["Neon|Fly"] = 118.12, ["Neon|Ride"] = 64.29, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 170.94, ["Mega|Ride"] = 223.12, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 37.37, ["Fly"] = 57.62, ["Ride"] = 42.87, ["Fly|Ride"] = 56.35, ["Neon"] = 289.13, ["Neon|Ride"] = 313.34, ["Neon|Fly|Ride"] = 253.8, ["Mega|Fly|Ride"] = 1125.06}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 835.21, ["Fly"] = 1253.02, ["Ride"] = 826.87, ["Fly|Ride"] = 1038.18, ["Neon|Ride"] = 3213.91, ["Neon|Fly|Ride"] = 4820.24}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 6825, ["Fly|Ride"] = 6956.25}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 18.09, ["Fly"] = 29.63, ["Ride"] = 24.94, ["Fly|Ride"] = 47.25, ["Neon"] = 452.13, ["Neon|Ride"] = 123.22, ["Neon|Fly|Ride"] = 143.03, ["Mega"] = 2520, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 12.17, ["Fly"] = 43.32, ["Ride"] = 28.85, ["Fly|Ride"] = 65.63, ["Neon"] = 78.95, ["Neon|Ride"] = 86.47, ["Neon|Fly|Ride"] = 169.32, ["Mega"] = 662.17, ["Mega|Ride"] = 479.07, ["Mega|Fly|Ride"] = 501.38}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 89.25, ["Fly"] = 157.5, ["Ride"] = 106.32, ["Fly|Ride"] = 146.52, ["Neon|Ride"] = 452.81, ["Neon|Fly|Ride"] = 498.81, ["Mega|Fly|Ride"] = 1978.99}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 214.3, ["Fly"] = 241.5, ["Ride"] = 221.81, ["Fly|Ride"] = 315, ["Neon"] = 1286.25, ["Neon|Ride"] = 1182.93, ["Neon|Fly|Ride"] = 1018.7, ["Mega"] = 10672.85, ["Mega|Fly"] = 4018.87, ["Mega|Fly|Ride"] = 4501.81}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 5.25, ["Ride"] = 38.07, ["Fly|Ride"] = 93.19, ["Neon"] = 20.47, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 56.44, ["Mega"] = 160.13, ["Mega|Fly"] = 238.02, ["Mega|Ride"] = 191.63, ["Mega|Fly|Ride"] = 229.69}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 177.45, ["Fly"] = 231.71, ["Ride"] = 206.07, ["Fly|Ride"] = 259.87, ["Neon"] = 721.88, ["Neon|Ride"] = 715.32, ["Neon|Fly|Ride"] = 787.5, ["Mega|Fly|Ride"] = 2779.88}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 2.63, ["Fly"] = 27.57, ["Ride"] = 15.75, ["Fly|Ride"] = 32.82, ["Neon"] = 24.94, ["Neon|Fly"] = 71.52, ["Neon|Ride"] = 30.45, ["Neon|Fly|Ride"] = 108.94, ["Mega"] = 256.17, ["Mega|Ride"] = 219.19, ["Mega|Fly|Ride"] = 281.81}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 188.41, ["Fly"] = 347.74, ["Ride"] = 207.9, ["Fly|Ride"] = 262.47, ["Neon|Ride"] = 1325.58, ["Neon|Fly|Ride"] = 1115.63, ["Mega"] = 10672.85, ["Mega|Fly|Ride"] = 4127.69}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 9.9, ["Fly"] = 77.44, ["Ride"] = 28.28, ["Fly|Ride"] = 68.25, ["Neon"] = 73.5, ["Neon|Fly"] = 306.1, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 155.93, ["Mega"] = 569.94, ["Mega|Ride"] = 555.08, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 3.94, ["Ride"] = 26.17, ["Fly|Ride"] = 51.19, ["Neon"] = 6.57, ["Neon|Fly"] = 170.46, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 195.57, ["Mega"] = 85.98, ["Mega|Ride"] = 131.19, ["Mega|Fly|Ride"] = 309.11}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Mega"] = 20.29, ["Mega|Ride"] = 143.05, ["Mega|Fly|Ride"] = 161.53}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 4.26, ["Ride"] = 30.9, ["Fly|Ride"] = 85.53, ["Neon"] = 5.92, ["Neon|Ride"] = 33.99, ["Neon|Fly|Ride"] = 126, ["Mega"] = 84.62, ["Mega|Fly"] = 160674.96, ["Mega|Ride"] = 84.45, ["Mega|Fly|Ride"] = 256.1}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 63, ["Fly"] = 166.32, ["Ride"] = 100.95, ["Fly|Ride"] = 185.63, ["Neon"] = 339.94, ["Neon|Ride"] = 294, ["Neon|Fly|Ride"] = 389.82, ["Mega|Fly|Ride"] = 1537.09}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 37.35, ["Ride"] = 17.05, ["Fly|Ride"] = 83.22, ["Neon"] = 10.49, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 52.4, ["Mega"] = 91.77, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 262.47}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 10.58, ["Ride"] = 113.08, ["Neon"] = 82.26, ["Neon|Fly"] = 289.23, ["Neon|Ride"] = 212.63, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 261.19, ["Mega|Ride"] = 541.19, ["Mega|Fly|Ride"] = 604.17}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Ride"] = 17.84, ["Neon"] = 2.1, ["Neon|Ride"] = 55.25, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 16.96, ["Mega|Ride"] = 90.04, ["Mega|Fly|Ride"] = 196.56}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 71.3, ["Ride"] = 15.75, ["Fly|Ride"] = 49.03, ["Neon"] = 2.1, ["Neon|Fly"] = 37.09, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 32.82, ["Mega"] = 12.55, ["Mega|Fly"] = 34.72, ["Mega|Ride"] = 24.94, ["Mega|Fly|Ride"] = 59.25}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 13.13, ["Fly|Ride"] = 80.01, ["Neon"] = 3.75, ["Neon|Fly"] = 21, ["Neon|Ride"] = 15.6, ["Neon|Fly|Ride"] = 52.41, ["Mega"] = 24.11, ["Mega|Fly"] = 161.48, ["Mega|Ride"] = 48.22, ["Mega|Fly|Ride"] = 86.63}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 36.75, ["Mega"] = 19.59, ["Mega|Ride"] = 105}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 91.88, ["Ride"] = 21, ["Fly|Ride"] = 107.62, ["Neon"] = 6.19, ["Neon|Fly"] = 121.69, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 87.34, ["Mega"] = 35.56, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 38.19, ["Mega|Fly|Ride"] = 101.07}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 2.62, ["Neon|Ride"] = 82.09, ["Neon|Fly|Ride"] = 426.93, ["Mega"] = 20.9, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 69.57, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 3.94, ["Fly"] = 77.44, ["Ride"] = 36.75, ["Fly|Ride"] = 157.9, ["Neon"] = 30.07, ["Neon|Fly"] = 118.54, ["Neon|Ride"] = 52.41, ["Neon|Fly|Ride"] = 105, ["Mega"] = 154.88, ["Mega|Fly"] = 283.2, ["Mega|Ride"] = 161.44, ["Mega|Fly|Ride"] = 271.59}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 28.82, ["Neon"] = 2.1, ["Neon|Ride"] = 42.71, ["Neon|Fly|Ride"] = 321.76, ["Mega"] = 15.39, ["Mega|Fly"] = 144.27, ["Mega|Ride"] = 77.09, ["Mega|Fly|Ride"] = 196.77}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 144.01, ["Fly|Ride"] = 142.96, ["Neon"] = 18.37, ["Mega"] = 120.63, ["Mega|Fly"] = 315, ["Mega|Ride"] = 274.31, ["Mega|Fly|Ride"] = 392.44}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Ride"] = 26.24, ["Neon"] = 13.13, ["Neon|Ride"] = 71.52, ["Mega"] = 119.79, ["Mega|Ride"] = 157.99, ["Mega|Fly|Ride"] = 570.01}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 32.8, ["Neon"] = 3.93, ["Neon|Ride"] = 27.77, ["Neon|Fly|Ride"] = 143.03, ["Mega"] = 21.06, ["Mega|Ride"] = 44.63, ["Mega|Fly|Ride"] = 98.01}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.28, ["Ride"] = 14.44, ["Fly|Ride"] = 32.82, ["Neon"] = 2.1, ["Neon|Fly"] = 28.94, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 37.68, ["Mega"] = 11.69, ["Mega|Fly"] = 32.81, ["Mega|Ride"] = 16.96, ["Mega|Fly|Ride"] = 48.22}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.1, ["Fly"] = 72.19, ["Ride"] = 54.28, ["Fly|Ride"] = 118.11, ["Neon"] = 36.75, ["Neon|Ride"] = 71.52, ["Mega"] = 202.73, ["Mega|Ride"] = 192.14}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 32.37, ["Neon"] = 3.81, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 25.81, ["Mega|Ride"] = 50.94, ["Mega|Fly|Ride"] = 115.49}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 4.47, ["Neon"] = 17.07, ["Mega"] = 85.32, ["Mega|Ride"] = 161.2, ["Mega|Fly|Ride"] = 213.49}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.1, ["Fly"] = 78.93, ["Ride"] = 19.69, ["Neon"] = 14.48, ["Neon|Fly"] = 32.03, ["Neon|Ride"] = 42.71, ["Neon|Fly|Ride"] = 105, ["Mega"] = 124.69, ["Mega|Ride"] = 163.41, ["Mega|Fly|Ride"] = 192.86}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 14.44, ["Ride"] = 15.93, ["Fly|Ride"] = 31.49, ["Neon"] = 2.1, ["Neon|Fly"] = 15.65, ["Neon|Ride"] = 14.34, ["Neon|Fly|Ride"] = 34.55, ["Mega"] = 15.28, ["Mega|Fly"] = 28.18, ["Mega|Ride"] = 18.34, ["Mega|Fly|Ride"] = 51.29}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 28.82, ["Ride"] = 27.42, ["Fly|Ride"] = 142.96, ["Neon"] = 12.96, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 196.47, ["Mega"] = 129.65, ["Mega|Ride"] = 161.53, ["Mega|Fly|Ride"] = 161.53}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 3.91, ["Fly"] = 114.14, ["Ride"] = 114.14, ["Fly|Ride"] = 59.07, ["Neon"] = 49.88, ["Neon|Ride"] = 69.57, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 254.68, ["Mega|Ride"] = 297.51, ["Mega|Fly|Ride"] = 327.48}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 14.44, ["Fly|Ride"] = 39.29, ["Neon"] = 2.1, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 14.43, ["Neon|Fly|Ride"] = 32.19, ["Mega"] = 20.25, ["Mega|Ride"] = 31.5, ["Mega|Fly|Ride"] = 98.21}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.1, ["Fly"] = 178.14, ["Ride"] = 45.9, ["Neon"] = 13.13, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 128.96, ["Mega"] = 76.85, ["Mega|Fly"] = 170.79, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 213.49}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 35.44, ["Neon"] = 3.93, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 284.97, ["Mega"] = 27.56, ["Mega|Fly"] = 64.05, ["Mega|Ride"] = 63, ["Mega|Fly|Ride"] = 341.59}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 32.54, ["Ride"] = 21, ["Neon"] = 2.1, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 284.97, ["Mega"] = 13.13, ["Mega|Fly"] = 253.82, ["Mega|Ride"] = 42.56, ["Mega|Fly|Ride"] = 156.18}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 71.48, ["Ride"] = 15.75, ["Fly|Ride"] = 46.57, ["Neon"] = 8.33, ["Neon|Fly"] = 54.45, ["Neon|Ride"] = 34.36, ["Neon|Fly|Ride"] = 71.52, ["Mega"] = 71.31, ["Mega|Ride"] = 73.5, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 22.59, ["Neon"] = 5.91, ["Neon|Ride"] = 71.52, ["Mega"] = 44.24, ["Mega|Fly"] = 321.76, ["Mega|Ride"] = 103.69, ["Mega|Fly|Ride"] = 249.37}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 16.79, ["Ride"] = 15.74, ["Fly|Ride"] = 57.62, ["Neon"] = 3.94, ["Neon|Fly"] = 80.76, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 64.97, ["Mega"] = 111.57, ["Mega|Fly"] = 114.6, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 97.13}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 2.1, ["Ride"] = 37.03, ["Neon"] = 31.39, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 320.2, ["Mega"] = 105, ["Mega|Fly"] = 367.5, ["Mega|Ride"] = 210}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Fly"] = 25.77, ["Ride"] = 18.08, ["Fly|Ride"] = 47.01, ["Neon"] = 10.53, ["Neon|Fly"] = 48.2, ["Neon|Ride"] = 32.12, ["Neon|Fly|Ride"] = 89.19, ["Mega"] = 236.25, ["Mega|Fly"] = 420, ["Mega|Ride"] = 121.7, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 16.92, ["Fly|Ride"] = 100.29, ["Neon"] = 14.44, ["Neon|Fly"] = 67.26, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 74.73, ["Mega"] = 213.47, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 131.06, ["Mega|Fly|Ride"] = 182.44}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 113.08, ["Neon"] = 98.67, ["Neon|Fly|Ride"] = 2625, ["Mega"] = 247.67, ["Mega|Ride"] = 310.63}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 7.35, ["Ride"] = 56.44, ["Neon"] = 202.11, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 794.07, ["Mega"] = 638.25, ["Mega|Ride"] = 728.44, ["Mega|Fly|Ride"] = 643.64}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 2.1, ["Ride"] = 42.69, ["Neon"] = 40.69, ["Neon|Ride"] = 106.74, ["Mega"] = 238.88, ["Mega|Ride"] = 361.6}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 3.61, ["Ride"] = 37.58, ["Fly|Ride"] = 120.75, ["Neon"] = 47.78, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 377.84, ["Mega|Ride"] = 413.11, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Ride"] = 28.82, ["Neon"] = 2.52, ["Neon|Ride"] = 65.02, ["Mega"] = 16.96, ["Mega|Fly"] = 122.75, ["Mega|Ride"] = 63, ["Mega|Fly|Ride"] = 232.71}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 49.08}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 4.29, ["Fly"] = 23.63, ["Ride"] = 20.99, ["Fly|Ride"] = 47.59, ["Neon"] = 44.63, ["Neon|Fly"] = 189, ["Neon|Ride"] = 50.17, ["Neon|Fly|Ride"] = 96.07, ["Mega"] = 272.16, ["Mega|Ride"] = 208.68, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.79, ["Ride"] = 19.24, ["Fly|Ride"] = 85.32, ["Neon"] = 2.1, ["Neon|Fly"] = 52.8, ["Neon|Ride"] = 20.9, ["Neon|Fly|Ride"] = 105, ["Mega"] = 24.18, ["Mega|Fly"] = 143.03, ["Mega|Ride"] = 57.66, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 6.57, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 72.18, ["Mega"] = 32.89, ["Mega|Ride"] = 55.13, ["Mega|Fly|Ride"] = 115.96}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 50.14, ["Ride"] = 16.02, ["Fly|Ride"] = 32.54, ["Neon"] = 9.19, ["Neon|Ride"] = 29.89, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 106.74, ["Mega|Ride"] = 106.75, ["Mega|Fly|Ride"] = 169.24}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 2.38, ["Fly"] = 42.69, ["Ride"] = 31.5, ["Fly|Ride"] = 69.57, ["Neon"] = 47.72, ["Neon|Ride"] = 208.13, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 161.44, ["Mega|Ride"] = 365.07, ["Mega|Fly|Ride"] = 320.23}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Ride"] = 34.12, ["Neon"] = 2.63, ["Neon|Ride"] = 39.9, ["Mega"] = 21.95, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 51.1, ["Mega|Fly|Ride"] = 341.59}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 27.57, ["Ride"] = 17.07, ["Fly|Ride"] = 36.33, ["Neon"] = 3.94, ["Neon|Fly"] = 113.13, ["Neon|Ride"] = 19.68, ["Neon|Fly|Ride"] = 96.42, ["Mega"] = 27.77, ["Mega|Fly"] = 143.16, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 113.16}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 28.66, ["Ride"] = 18.27, ["Fly|Ride"] = 42.69, ["Neon"] = 4.92, ["Neon|Fly"] = 52.58, ["Neon|Ride"] = 16.99, ["Neon|Fly|Ride"] = 61.11, ["Mega"] = 71.52, ["Mega|Fly"] = 143.03, ["Mega|Ride"] = 85.45, ["Mega|Fly|Ride"] = 72.19}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 3.94, ["Fly"] = 91.88, ["Ride"] = 41.62, ["Fly|Ride"] = 142.96, ["Neon"] = 8.88, ["Neon|Ride"] = 52.41, ["Neon|Fly|Ride"] = 106.74, ["Mega"] = 72.64, ["Mega|Ride"] = 109.88, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Ride"] = 17.09, ["Neon"] = 2.1, ["Neon|Ride"] = 106.74, ["Neon|Fly|Ride"] = 155210.03, ["Mega"] = 17.05, ["Mega|Fly"] = 96.42, ["Mega|Ride"] = 51.77, ["Mega|Fly|Ride"] = 136.49}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 45.9, ["Ride"] = 19.68, ["Fly|Ride"] = 32.82, ["Neon"] = 3.94, ["Neon|Fly"] = 27.74, ["Neon|Ride"] = 25.64, ["Neon|Fly|Ride"] = 96.07, ["Mega"] = 19.68, ["Mega|Fly"] = 64.05, ["Mega|Ride"] = 38.13, ["Mega|Fly|Ride"] = 78.66}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Neon"] = 3.83, ["Neon|Fly|Ride"] = 114.21, ["Mega"] = 19.59, ["Mega|Ride"] = 426.98}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 6.17, ["Neon|Fly|Ride"] = 420, ["Mega"] = 36.3, ["Mega|Ride"] = 196.42, ["Mega|Fly|Ride"] = 153.72}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 15.65, ["Fly|Ride"] = 42, ["Neon"] = 5.25, ["Neon|Fly"] = 39.37, ["Neon|Ride"] = 16.99, ["Neon|Fly|Ride"] = 35.43, ["Mega"] = 36.75, ["Mega|Ride"] = 51.26, ["Mega|Fly|Ride"] = 107.57}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 19.68, ["Ride"] = 78.74, ["Fly|Ride"] = 213.38, ["Neon"] = 113.88, ["Neon|Ride"] = 90.27, ["Mega"] = 389.81, ["Mega|Ride"] = 669.38, ["Mega|Fly|Ride"] = 683.16}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.1, ["Fly"] = 6562.5, ["Ride"] = 26.23, ["Neon"] = 39.38, ["Neon|Ride"] = 39.38, ["Mega"] = 183.75, ["Mega|Fly|Ride"] = 570.01}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 2.1, ["Ride"] = 32.02, ["Fly|Ride"] = 174.97, ["Neon"] = 21, ["Neon|Ride"] = 71.52, ["Mega"] = 313.69, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 12.83, ["Fly|Ride"] = 27.72, ["Neon"] = 2.1, ["Neon|Fly"] = 18.27, ["Neon|Ride"] = 9.53, ["Neon|Fly|Ride"] = 28.88, ["Mega"] = 12.92, ["Mega|Fly"] = 104.98, ["Mega|Ride"] = 19.57, ["Mega|Fly|Ride"] = 58.75}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Fly"] = 118.12, ["Ride"] = 59.75, ["Neon"] = 6.04, ["Neon|Fly"] = 68.32, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 711.89, ["Mega"] = 85.32, ["Mega|Ride"] = 143.05}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Fly"] = 71.48, ["Ride"] = 26.25, ["Neon"] = 2.1, ["Neon|Fly"] = 32.04, ["Neon|Ride"] = 22.44, ["Neon|Fly|Ride"] = 86.67, ["Mega"] = 13.11, ["Mega|Fly"] = 64.05, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 127.32, ["Mega"] = 21, ["Mega|Fly"] = 213.47, ["Mega|Ride"] = 53.04, ["Mega|Fly|Ride"] = 367.49}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 126.29, ["Ride"] = 18.38, ["Fly|Ride"] = 56.67, ["Neon"] = 8.69, ["Neon|Fly"] = 71.12, ["Neon|Ride"] = 24.05, ["Neon|Fly|Ride"] = 71.52, ["Mega"] = 170.62, ["Mega|Fly"] = 199.6, ["Mega|Ride"] = 160.13, ["Mega|Fly|Ride"] = 294}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 158.71, ["Ride"] = 224.32, ["Fly|Ride"] = 412.85, ["Neon|Fly|Ride"] = 981.91, ["Mega"] = 8538.29, ["Mega|Fly|Ride"] = 4019.69}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Ride"] = 24.54, ["Neon"] = 6.91, ["Neon|Ride"] = 64.31, ["Mega"] = 68.16, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 2.63, ["Fly"] = 103.68, ["Ride"] = 24.69, ["Fly|Ride"] = 64.32, ["Neon"] = 32.49, ["Neon|Ride"] = 170.79, ["Neon|Fly|Ride"] = 143.03, ["Mega"] = 381.89, ["Mega|Ride"] = 225.4, ["Mega|Fly|Ride"] = 213.49}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 16.02, ["Ride"] = 15.73, ["Fly|Ride"] = 32.82, ["Neon"] = 3.94, ["Neon|Fly"] = 33.11, ["Neon|Ride"] = 29.98, ["Neon|Fly|Ride"] = 48.9, ["Mega"] = 49.67, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 127.03}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 71.48, ["Ride"] = 19.68, ["Fly|Ride"] = 92.6, ["Neon"] = 10.68, ["Neon|Ride"] = 69.47, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 77.35, ["Mega|Ride"] = 192.86, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 15.43, ["Fly|Ride"] = 36.75, ["Neon"] = 28.29, ["Neon|Fly"] = 100.34, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 65.63, ["Mega|Ride"] = 285.02, ["Mega|Fly|Ride"] = 294}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 3.94, ["Ride"] = 34.32, ["Fly|Ride"] = 65.07, ["Neon"] = 50.65, ["Neon|Ride"] = 85.4, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 216.57, ["Mega|Ride"] = 427.35, ["Mega|Fly|Ride"] = 387.18}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.1, ["Fly"] = 19.68, ["Ride"] = 15.44, ["Fly|Ride"] = 38.06, ["Neon"] = 31.1, ["Neon|Fly"] = 71.52, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 79.71, ["Mega"] = 262.5, ["Mega|Ride"] = 370.41, ["Mega|Fly|Ride"] = 253.47}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 52.5, ["Ride"] = 80.76, ["Fly|Ride"] = 149.1, ["Neon"] = 341.24, ["Neon|Fly"] = 450.19, ["Neon|Ride"] = 418.69, ["Neon|Fly|Ride"] = 377.79, ["Mega|Fly|Ride"] = 1468.59}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 239.3, ["Fly"] = 426.68, ["Ride"] = 249.24, ["Fly|Ride"] = 328.13, ["Neon|Ride"] = 1125.53, ["Neon|Fly|Ride"] = 1115.63, ["Mega"] = 10672.85, ["Mega|Fly|Ride"] = 4269.66}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 59.07, ["Fly"] = 85.2, ["Ride"] = 74.82, ["Fly|Ride"] = 117.54, ["Neon"] = 481.87, ["Neon|Ride"] = 290.34, ["Neon|Fly|Ride"] = 347.82, ["Mega|Fly|Ride"] = 1387.64}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 3.75, ["Fly"] = 288.09, ["Ride"] = 23.63, ["Fly|Ride"] = 73.5, ["Neon"] = 40.42, ["Neon|Ride"] = 99.75, ["Mega"] = 233.8, ["Mega|Ride"] = 196.75, ["Mega|Fly|Ride"] = 416.73}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 11.7, ["Fly"] = 71.48, ["Ride"] = 28.86, ["Fly|Ride"] = 64.22, ["Neon"] = 62.99, ["Neon|Ride"] = 67.64, ["Neon|Fly|Ride"] = 143.03, ["Mega"] = 480.3, ["Mega|Ride"] = 372.84, ["Mega|Fly|Ride"] = 446.45}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 15.74, ["Fly|Ride"] = 50.9, ["Neon"] = 3.05, ["Neon|Fly"] = 32.03, ["Neon|Ride"] = 20.89, ["Neon|Fly|Ride"] = 48.93, ["Mega"] = 33.03, ["Mega|Fly"] = 146.9, ["Mega|Ride"] = 213.49, ["Mega|Fly|Ride"] = 283.5}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 4.98, ["Fly"] = 39.38, ["Ride"] = 30.68, ["Fly|Ride"] = 64.02, ["Neon"] = 95.7, ["Neon|Fly"] = 284.97, ["Neon|Ride"] = 107.63, ["Neon|Fly|Ride"] = 249.57, ["Mega"] = 301.88, ["Mega|Ride"] = 482.14, ["Mega|Fly|Ride"] = 456.87}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 41.91, ["Ride"] = 15.74, ["Fly|Ride"] = 39.19, ["Neon"] = 13.95, ["Neon|Fly"] = 80.76, ["Neon|Ride"] = 27.77, ["Neon|Fly|Ride"] = 60.48, ["Mega"] = 131.25, ["Mega|Ride"] = 267.93, ["Mega|Fly|Ride"] = 260.53}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 2.1, ["Ride"] = 24.11, ["Fly|Ride"] = 328.13, ["Neon"] = 17.09, ["Neon|Ride"] = 36.3, ["Mega"] = 207.37, ["Mega|Ride"] = 216.57, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 27.68, ["Ride"] = 19.37, ["Neon"] = 2.1, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 57.74, ["Mega"] = 12.92, ["Mega|Fly"] = 31.5, ["Mega|Ride"] = 42.71, ["Mega|Fly|Ride"] = 78.73}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 19.59, ["Ride"] = 19.07, ["Fly|Ride"] = 42.69, ["Neon"] = 10.08, ["Neon|Fly"] = 106.74, ["Neon|Ride"] = 35.23, ["Neon|Fly|Ride"] = 147, ["Mega"] = 78.72, ["Mega|Fly|Ride"] = 226.42}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.1, ["Fly"] = 28.29, ["Ride"] = 17.38, ["Fly|Ride"] = 63.03, ["Neon"] = 19.69, ["Neon|Ride"] = 47.25, ["Mega"] = 131.23, ["Mega|Ride"] = 266.44, ["Mega|Fly|Ride"] = 264.73}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 111.57, ["Fly"] = 164.11, ["Ride"] = 161.59, ["Fly|Ride"] = 199.4, ["Neon"] = 489.57, ["Neon|Fly"] = 643.51, ["Neon|Ride"] = 448.88, ["Neon|Fly|Ride"] = 534.19, ["Mega"] = 4269.15, ["Mega|Fly|Ride"] = 2099.9}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 8.55, ["Ride"] = 128.02, ["Fly|Ride"] = 128.91, ["Neon"] = 40.69, ["Neon|Ride"] = 98.42, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 278.07, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 32.54, ["Ride"] = 19.25, ["Fly|Ride"] = 36.75, ["Neon"] = 13.44, ["Neon|Ride"] = 32.55, ["Neon|Fly|Ride"] = 120.65, ["Mega"] = 246.75, ["Mega|Ride"] = 187.69, ["Mega|Fly|Ride"] = 199.5}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 20.32, ["Ride"] = 45.88, ["Fly|Ride"] = 151.19, ["Neon"] = 90.75, ["Neon|Ride"] = 143.03, ["Neon|Fly|Ride"] = 710.83, ["Mega"] = 711.89, ["Mega|Fly"] = 853.84, ["Mega|Ride"] = 691.86, ["Mega|Fly|Ride"] = 819.62}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 2.63}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 2.1, ["Ride"] = 28.82, ["Fly|Ride"] = 126.97, ["Neon"] = 33.14, ["Neon|Fly"] = 89.25, ["Neon|Ride"] = 160.11, ["Neon|Fly|Ride"] = 327.68, ["Mega"] = 839.97, ["Mega|Ride"] = 570.01, ["Mega|Fly|Ride"] = 884.71}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 27.57, ["Fly"] = 36.28, ["Ride"] = 32.26, ["Fly|Ride"] = 64.75, ["Neon"] = 401.12, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 101.4, ["Neon|Fly|Ride"] = 177.08, ["Mega"] = 1377.88, ["Mega|Fly|Ride"] = 485.63}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 27.75, ["Fly|Ride"] = 52.38, ["Neon"] = 2.1, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 107.63, ["Mega"] = 31.17, ["Mega|Fly"] = 188.99, ["Mega|Ride"] = 77.86, ["Mega|Fly|Ride"] = 230.85}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 4.29, ["Fly"] = 32.55, ["Ride"] = 20.9, ["Fly|Ride"] = 65.54, ["Neon"] = 57.62, ["Neon|Ride"] = 64.05, ["Mega"] = 284.97, ["Mega|Fly"] = 402.5, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 566.81}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 21.35, ["Ride"] = 16.02, ["Fly|Ride"] = 44.01, ["Neon"] = 13.12, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 18.09, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 131.25, ["Mega|Ride"] = 213.55, ["Mega|Fly|Ride"] = 275.73}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 21.35, ["Neon"] = 3.15, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 40.85, ["Mega"] = 28.77, ["Mega|Ride"] = 70.47, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 26.25, ["Fly"] = 141.73, ["Ride"] = 85.39, ["Fly|Ride"] = 136.5, ["Neon"] = 180.54, ["Neon|Ride"] = 249.76, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 727.65, ["Mega|Ride"] = 689.06, ["Mega|Fly|Ride"] = 853.94}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 2.21, ["Ride"] = 47.25, ["Fly|Ride"] = 210, ["Neon"] = 96.46, ["Mega|Ride"] = 525}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 2.1, ["Fly"] = 22.3, ["Ride"] = 19.69, ["Fly|Ride"] = 61.86, ["Neon"] = 25.91, ["Neon|Fly"] = 85.4, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 87.53, ["Mega"] = 196.23, ["Mega|Fly|Ride"] = 290.07}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 71.63, ["Fly"] = 433.12, ["Ride"] = 130.09, ["Fly|Ride"] = 262.5, ["Neon"] = 18316.2, ["Neon|Ride"] = 523.69, ["Neon|Fly|Ride"] = 565.04, ["Mega"] = 4500.9, ["Mega|Ride"] = 2165.63, ["Mega|Fly|Ride"] = 2887.49}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 6.57, ["Fly"] = 45.65, ["Ride"] = 23.47, ["Fly|Ride"] = 67.33, ["Neon"] = 32.7, ["Neon|Ride"] = 57.64, ["Neon|Fly|Ride"] = 104.35, ["Mega"] = 373.56, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 398.99}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 69.57, ["Fly"] = 131.24, ["Ride"] = 90.93, ["Fly|Ride"] = 188.98, ["Neon"] = 210, ["Neon|Fly"] = 324.47, ["Neon|Ride"] = 222.01, ["Neon|Fly|Ride"] = 348.75, ["Mega"] = 1078.53, ["Mega|Ride"] = 1063.13, ["Mega|Fly|Ride"] = 1035.57}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 20.28, ["Fly"] = 170.68, ["Ride"] = 53.7, ["Fly|Ride"] = 142.96, ["Neon"] = 65.62, ["Neon|Ride"] = 99.74, ["Neon|Fly|Ride"] = 277.51, ["Mega"] = 467.49, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 570.01}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 7.33, ["Fly"] = 42.69, ["Ride"] = 25.62, ["Fly|Ride"] = 70.13, ["Neon"] = 142.96, ["Neon|Ride"] = 192.83, ["Neon|Fly|Ride"] = 383.22, ["Mega"] = 562.77, ["Mega|Ride"] = 567.88, ["Mega|Fly|Ride"] = 567.88}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 15.75, ["Ride"] = 65.62, ["Fly|Ride"] = 102.37, ["Neon"] = 45.82, ["Neon|Fly"] = 120.51, ["Neon|Ride"] = 76.13, ["Neon|Fly|Ride"] = 438.38, ["Mega"] = 285.16, ["Mega|Ride"] = 320.25, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 5.67, ["Ride"] = 35.65, ["Fly|Ride"] = 270.97, ["Neon"] = 33.03, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 145.69, ["Mega"] = 276.71, ["Mega|Ride"] = 279.34, ["Mega|Fly|Ride"] = 399.46}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Ride"] = 71.48, ["Neon"] = 2.1, ["Neon|Fly"] = 96.68, ["Neon|Ride"] = 131.23, ["Neon|Fly|Ride"] = 210, ["Mega"] = 19.66, ["Mega|Fly"] = 71.6, ["Mega|Ride"] = 143.05, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 3.21, ["Ride"] = 123.38, ["Neon"] = 31.5, ["Neon|Ride"] = 195.33, ["Mega"] = 236.24, ["Mega|Ride"] = 505.97, ["Mega|Fly|Ride"] = 524.11}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Fly"] = 126.94, ["Ride"] = 28.82, ["Neon"] = 6.57, ["Neon|Fly"] = 116.94, ["Neon|Ride"] = 100.34, ["Neon|Fly|Ride"] = 185.72, ["Mega"] = 210.67, ["Mega|Ride"] = 284.08, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 2.1, ["Ride"] = 32.8, ["Fly|Ride"] = 120.48, ["Neon"] = 32.02, ["Neon|Ride"] = 85.22, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 125.95, ["Mega|Ride"] = 285.02, ["Mega|Fly|Ride"] = 519.74}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 519.16, ["Ride"] = 511.88, ["Fly|Ride"] = 570.82, ["Neon"] = 1813.53, ["Neon|Fly"] = 1816.54, ["Neon|Ride"] = 1767.84, ["Neon|Fly|Ride"] = 1561.25, ["Mega|Fly|Ride"] = 5893.13}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 4.12, ["Fly"] = 45.47, ["Ride"] = 20.43, ["Fly|Ride"] = 56.94, ["Neon"] = 71.49, ["Neon|Ride"] = 57.64, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 213.47, ["Mega|Ride"] = 370.05, ["Mega|Fly|Ride"] = 353.32}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 6.22, ["Fly"] = 66.94, ["Ride"] = 20.93, ["Fly|Ride"] = 52.07, ["Neon"] = 85.31, ["Neon|Fly"] = 315, ["Neon|Ride"] = 76.91, ["Neon|Fly|Ride"] = 57.75, ["Mega"] = 331.87, ["Mega|Ride"] = 482.14, ["Mega|Fly|Ride"] = 681.45}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 2.1, ["Fly"] = 24.93, ["Ride"] = 21.35, ["Fly|Ride"] = 50.79, ["Neon|Ride"] = 42.09, ["Neon|Fly|Ride"] = 131.25}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 24.59, ["Fly|Ride"] = 89.15, ["Neon"] = 7.32, ["Neon|Ride"] = 30.07, ["Neon|Fly|Ride"] = 139.82, ["Mega"] = 63.35, ["Mega|Ride"] = 124.59, ["Mega|Fly|Ride"] = 208.43}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 71.48, ["Ride"] = 17.07, ["Neon"] = 2.1, ["Neon|Ride"] = 24.45, ["Neon|Fly|Ride"] = 114.21, ["Mega"] = 23.29, ["Mega|Fly"] = 199.6, ["Mega|Ride"] = 86.52, ["Mega|Fly|Ride"] = 226.31}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1181.25}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 7.34, ["Ride"] = 32.12, ["Fly|Ride"] = 170.7, ["Neon"] = 68.16, ["Neon|Ride"] = 112.87, ["Mega"] = 400.24, ["Mega|Ride"] = 370.05, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 28.56, ["Neon"] = 3.94, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 997.21, ["Mega"] = 39.29, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 182.44}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 3.84, ["Fly"] = 318.7, ["Ride"] = 50.23, ["Fly|Ride"] = 65.63, ["Neon"] = 44.63, ["Neon|Ride"] = 170.52, ["Neon|Fly|Ride"] = 262.4, ["Mega"] = 258.57, ["Mega|Ride"] = 378.48, ["Mega|Fly|Ride"] = 1067.42}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 393.74, ["Ride"] = 446.23, ["Fly|Ride"] = 536.81, ["Neon|Ride"] = 1577.46, ["Neon|Fly|Ride"] = 1312.5, ["Mega"] = 8004.65, ["Mega|Fly|Ride"] = 6164.82}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 5.78, ["Fly"] = 196.88, ["Ride"] = 57.62, ["Fly|Ride"] = 128.03, ["Neon"] = 52.5, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 192.83, ["Mega"] = 306.56, ["Mega|Ride"] = 440, ["Mega|Fly|Ride"] = 758.94}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Fly"] = 93.99, ["Ride"] = 28.23, ["Fly|Ride"] = 118.11, ["Neon"] = 3.32, ["Neon|Ride"] = 28.84, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 34.04, ["Mega|Fly"] = 143.07, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 191.02}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 3.94, ["Neon|Ride"] = 143.03, ["Neon|Fly|Ride"] = 198.54, ["Mega"] = 25.99, ["Mega|Ride"] = 178.27, ["Mega|Fly|Ride"] = 209.98}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 18.26, ["Fly"] = 107.89, ["Ride"] = 42.67, ["Fly|Ride"] = 213.38, ["Neon"] = 192.76, ["Neon|Ride"] = 202.13, ["Neon|Fly|Ride"] = 437.07, ["Mega"] = 452.82, ["Mega|Ride"] = 472.5, ["Mega|Fly|Ride"] = 545.74}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 10.5, ["Ride"] = 71.51, ["Neon"] = 93.81, ["Neon|Ride"] = 133.88, ["Neon|Fly|Ride"] = 853.84, ["Mega"] = 562.77, ["Mega|Ride"] = 482.35, ["Mega|Fly|Ride"] = 838.69}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 3.13, ["Ride"] = 28.82, ["Neon"] = 96.94, ["Neon|Ride"] = 196.81, ["Mega"] = 626.51, ["Mega|Ride"] = 640.46, ["Mega|Fly|Ride"] = 426.98}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 11.82, ["Ride"] = 25.38, ["Fly|Ride"] = 236.25, ["Neon"] = 167.28, ["Neon|Ride"] = 177.51, ["Neon|Fly|Ride"] = 241.5, ["Mega"] = 643.02, ["Mega|Ride"] = 528.39, ["Mega|Fly|Ride"] = 550.8}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 393.75, ["Ride"] = 423.05, ["Fly|Ride"] = 708.36, ["Neon"] = 1050, ["Neon|Ride"] = 1050, ["Neon|Fly|Ride"] = 1113, ["Mega|Fly|Ride"] = 3346.87}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 4.99, ["Fly"] = 30.19, ["Ride"] = 24.11, ["Fly|Ride"] = 71.57, ["Neon"] = 97.09, ["Neon|Ride"] = 192.12, ["Mega|Fly"] = 590.63, ["Mega|Ride"] = 561.1, ["Mega|Fly|Ride"] = 776.02}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 2.1, ["Ride"] = 42.68, ["Fly|Ride"] = 127.32, ["Neon"] = 51.45, ["Neon|Ride"] = 221.82, ["Mega"] = 163, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 629.99}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 28.56, ["Fly"] = 341.35, ["Ride"] = 100.84, ["Fly|Ride"] = 175.88, ["Neon"] = 131.25, ["Neon|Ride"] = 196.77, ["Neon|Fly|Ride"] = 262.29, ["Mega"] = 378.96, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Fly|Ride"] = 213.38, ["Neon"] = 7.88, ["Neon|Ride"] = 69.57, ["Neon|Fly|Ride"] = 276.44, ["Mega"] = 42, ["Mega|Fly"] = 189, ["Mega|Ride"] = 380.01, ["Mega|Fly|Ride"] = 280.88}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 42.67, ["Ride"] = 79.06, ["Neon"] = 248.07, ["Neon|Ride"] = 310.94, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 1547.58, ["Mega|Ride"] = 2826.51, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 56.44, ["Ride"] = 28.52, ["Fly|Ride"] = 262.5, ["Neon"] = 8.55, ["Neon|Fly"] = 185.72, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 99.51, ["Mega"] = 65.62, ["Mega|Ride"] = 94.4, ["Mega|Fly|Ride"] = 204.95}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 28.82, ["Ride"] = 28.88, ["Fly|Ride"] = 98.8, ["Neon"] = 3.7, ["Neon|Fly"] = 49.88, ["Neon|Ride"] = 49.1, ["Neon|Fly|Ride"] = 105, ["Mega"] = 29.3, ["Mega|Fly"] = 112.88, ["Mega|Ride"] = 87.54, ["Mega|Fly|Ride"] = 263.71}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Ride"] = 37.96, ["Fly|Ride"] = 131.07, ["Neon"] = 11.81, ["Neon|Ride"] = 53.38, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 75.12, ["Mega|Ride"] = 103.38, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 49.38, ["Fly"] = 65.61, ["Ride"] = 61.57, ["Fly|Ride"] = 236.25, ["Neon"] = 190.32, ["Neon|Ride"] = 343.86, ["Neon|Fly|Ride"] = 482.04, ["Mega|Ride"] = 1138.95, ["Mega|Fly|Ride"] = 1127.2}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 192.93, ["Ride"] = 262.5, ["Fly|Ride"] = 1066.78, ["Neon"] = 1706.86, ["Neon|Ride"] = 1565.72, ["Neon|Fly|Ride"] = 1771.88, ["Mega"] = 12807.42, ["Mega|Fly|Ride"] = 9963.22}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 3.94, ["Neon"] = 20.79, ["Neon|Fly"] = 350.44, ["Mega"] = 109.66, ["Mega|Ride"] = 211.31, ["Mega|Fly|Ride"] = 280.88}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.1, ["Ride"] = 20.9, ["Neon"] = 8.28, ["Neon|Ride"] = 45.34, ["Neon|Fly|Ride"] = 170.79, ["Mega"] = 37.7, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 91.76, ["Mega|Fly|Ride"] = 241.4}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 2.49, ["Fly"] = 106.68, ["Ride"] = 28.82, ["Fly|Ride"] = 97.13, ["Neon"] = 32.81, ["Mega"] = 242.29, ["Mega|Ride"] = 348.04, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 6.93, ["Fly"] = 98.44, ["Ride"] = 35.22, ["Fly|Ride"] = 106.7, ["Neon"] = 21.25, ["Neon|Ride"] = 65.62, ["Neon|Fly|Ride"] = 139.02, ["Mega"] = 146.24, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 187.3, ["Mega|Fly|Ride"] = 344.7}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 94.01, ["Neon"] = 8.6, ["Neon|Ride"] = 143.03, ["Neon|Fly|Ride"] = 143.03, ["Mega"] = 33.23, ["Mega|Ride"] = 90.02, ["Mega|Fly|Ride"] = 399.24}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 19.18, ["Fly|Ride"] = 52.5, ["Neon"] = 3.9, ["Neon|Fly"] = 80.76, ["Neon|Ride"] = 28.25, ["Neon|Fly|Ride"] = 106.74, ["Mega"] = 39.41, ["Mega|Ride"] = 99.68, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 28.82, ["Ride"] = 20.68, ["Fly|Ride"] = 57.62, ["Neon"] = 15.32, ["Neon|Fly"] = 101.4, ["Neon|Ride"] = 40.37, ["Neon|Fly|Ride"] = 106.74, ["Mega"] = 156.15, ["Mega|Ride"] = 141.74, ["Mega|Fly|Ride"] = 728.44}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 25.96, ["Ride"] = 37.95, ["Fly|Ride"] = 78.75, ["Neon"] = 144.34, ["Neon|Ride"] = 233.86, ["Mega"] = 643.51, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 651}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 72.03, ["Ride"] = 90.96, ["Fly|Ride"] = 139.13, ["Neon"] = 426.72, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 356.54, ["Neon|Fly|Ride"] = 464.63, ["Mega"] = 1993.7, ["Mega|Ride"] = 1599, ["Mega|Fly|Ride"] = 1515.94}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 19.3, ["Fly|Ride"] = 131.25, ["Neon"] = 2.88, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 16.02, ["Neon|Fly|Ride"] = 143.03, ["Mega"] = 34.61, ["Mega|Fly"] = 672, ["Mega|Ride"] = 92.42, ["Mega|Fly|Ride"] = 249.79}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 16.99, ["Ride"] = 15.75, ["Fly|Ride"] = 42.67, ["Neon"] = 3.84, ["Neon|Fly"] = 28.84, ["Neon|Ride"] = 20.89, ["Neon|Fly|Ride"] = 42.71, ["Mega"] = 43.32, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 68.33, ["Mega|Fly|Ride"] = 127.03}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 2.9, ["Fly"] = 50.14, ["Ride"] = 38.04, ["Fly|Ride"] = 52.5, ["Neon"] = 51.81, ["Neon|Ride"] = 144.62, ["Mega"] = 541.12, ["Mega|Ride"] = 275.62, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 393.75, ["Ride"] = 496.49, ["Fly|Ride"] = 446.25, ["Neon"] = 4267.11, ["Neon|Fly|Ride"] = 1771.88, ["Mega|Fly|Ride"] = 5906.25}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 19.69, ["Fly"] = 100.28, ["Ride"] = 36.66, ["Fly|Ride"] = 96.38, ["Neon"] = 198.43, ["Neon|Ride"] = 191.52, ["Neon|Fly|Ride"] = 192.12, ["Mega|Ride"] = 965.99, ["Mega|Fly|Ride"] = 1766.98}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 25.85, ["Fly|Ride"] = 283.99, ["Neon"] = 7.88, ["Neon|Ride"] = 49.24, ["Neon|Fly|Ride"] = 143.07, ["Mega"] = 65.63, ["Mega|Ride"] = 293.55, ["Mega|Fly|Ride"] = 238.04}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 83.85, ["Ride"] = 50.25, ["Fly|Ride"] = 103.69, ["Neon"] = 59.07, ["Neon|Ride"] = 72.34, ["Mega"] = 118.13, ["Mega|Fly|Ride"] = 319.17}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 40.55, ["Fly"] = 169.31, ["Ride"] = 36.52, ["Fly|Ride"] = 142.96, ["Neon"] = 194.25, ["Neon|Ride"] = 211.32, ["Neon|Fly|Ride"] = 314.87, ["Mega"] = 2561.49, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1002.75}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 110.22, ["Fly"] = 131.15, ["Ride"] = 116.93, ["Fly|Ride"] = 190.32, ["Neon"] = 389.11, ["Neon|Fly"] = 711.89, ["Neon|Ride"] = 482.04, ["Neon|Fly|Ride"] = 610.32, ["Mega"] = 8538.29, ["Mega|Fly|Ride"] = 2572.5}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 236.7, ["Ride"] = 262.5, ["Fly|Ride"] = 532.33, ["Neon"] = 938.44, ["Neon|Ride"] = 776.76, ["Neon|Fly|Ride"] = 918.75, ["Mega|Fly|Ride"] = 3696.67}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 26.25, ["Ride"] = 57.03, ["Fly|Ride"] = 150.94, ["Neon"] = 65.42, ["Neon|Ride"] = 106.97, ["Neon|Fly|Ride"] = 199.6, ["Mega"] = 459.38, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 450.89}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 28.85, ["Ride"] = 17.07, ["Fly|Ride"] = 43.32, ["Neon"] = 7.88, ["Neon|Ride"] = 21.36, ["Neon|Fly|Ride"] = 84, ["Mega"] = 93.09, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 187.94}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 20.78, ["Fly|Ride"] = 47.25, ["Neon"] = 26.25, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 33.11, ["Neon|Fly|Ride"] = 106.54, ["Mega"] = 284.97, ["Mega|Ride"] = 244.25, ["Mega|Fly|Ride"] = 333.33}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 347.01, ["Ride"] = 333.23, ["Fly|Ride"] = 744.62, ["Neon"] = 1569.1, ["Neon|Fly|Ride"] = 2134.58, ["Mega"] = 10245.94, ["Mega|Fly|Ride"] = 5730.82}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Neon"] = 8.54, ["Neon|Ride"] = 139.41, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 30.19, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 466.43}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 3.94, ["Ride"] = 17.04, ["Fly|Ride"] = 39.37, ["Neon"] = 19.68, ["Neon|Ride"] = 38.03, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 199.01, ["Mega|Ride"] = 228.44, ["Mega|Fly|Ride"] = 228.38}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 13.13, ["Ride"] = 85.35, ["Fly|Ride"] = 114.15, ["Neon"] = 92.96, ["Neon|Fly"] = 426.93, ["Neon|Ride"] = 108.43, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 539.04, ["Mega|Ride"] = 609, ["Mega|Fly|Ride"] = 688.55}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 114.14, ["Fly"] = 157.5, ["Ride"] = 118.13, ["Fly|Ride"] = 136.5, ["Neon|Ride"] = 795.36, ["Neon|Fly|Ride"] = 569.94, ["Mega|Fly|Ride"] = 2846.8}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 19.68, ["Fly"] = 16.47, ["Ride"] = 27.93, ["Fly|Ride"] = 51.43, ["Neon"] = 134.29, ["Neon|Ride"] = 101.85, ["Neon|Fly|Ride"] = 121.36, ["Mega"] = 875.44, ["Mega|Ride"] = 422.63, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 46.95, ["Neon"] = 3.41, ["Neon|Ride"] = 74.59, ["Mega"] = 34, ["Mega|Ride"] = 128.1, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Ride"] = 16.02, ["Fly|Ride"] = 85.36, ["Neon"] = 2.1, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 23.85, ["Neon|Fly|Ride"] = 84.96, ["Mega"] = 21, ["Mega|Fly"] = 97.13, ["Mega|Ride"] = 47.58, ["Mega|Fly|Ride"] = 111.46}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 8.88, ["Ride"] = 74.46, ["Fly|Ride"] = 131.25, ["Neon"] = 31.14, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 178.4, ["Mega|Ride"] = 208.69, ["Mega|Fly|Ride"] = 285.02}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1291.5, ["Ride"] = 1286.25, ["Fly|Ride"] = 1433.18, ["Neon|Ride"] = 4696.07, ["Neon|Fly|Ride"] = 4738.76, ["Mega|Fly|Ride"] = 12600}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 443.63, ["Ride"] = 466.6, ["Fly|Ride"] = 612.33, ["Neon"] = 1663.2, ["Neon|Ride"] = 2561.49, ["Neon|Fly|Ride"] = 1753.5, ["Mega"] = 17076.56, ["Mega|Fly|Ride"] = 7543.4}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 295.32, ["Fly"] = 393.75, ["Ride"] = 341.16, ["Fly|Ride"] = 418.48, ["Neon"] = 746.46, ["Neon|Fly"] = 851.99, ["Neon|Ride"] = 673.2, ["Neon|Fly|Ride"] = 786.18, ["Mega|Fly|Ride"] = 2916.23}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 228.38, ["Fly"] = 314.67, ["Ride"] = 259.86, ["Fly|Ride"] = 339.85, ["Neon"] = 647.09, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 733.69, ["Mega|Fly|Ride"] = 2986.62}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 62.56, ["Ride"] = 15.75, ["Fly|Ride"] = 42, ["Neon"] = 5.04, ["Neon|Ride"] = 29.22, ["Neon|Fly|Ride"] = 102.47, ["Mega"] = 69.47, ["Mega|Fly"] = 114.21, ["Mega|Ride"] = 77.44, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 246.75, ["Fly"] = 288.75, ["Ride"] = 309.75, ["Fly|Ride"] = 943.95, ["Neon"] = 1494.22, ["Neon|Ride"] = 1365, ["Neon|Fly|Ride"] = 1211.05, ["Mega"] = 21630.66, ["Mega|Ride"] = 5123.58, ["Mega|Fly|Ride"] = 4593.75}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 7.5, ["Fly"] = 157.5, ["Ride"] = 23.63, ["Fly|Ride"] = 161.44, ["Neon"] = 28.88, ["Neon|Ride"] = 115.9, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 175.86, ["Mega|Ride"] = 315.35, ["Mega|Fly|Ride"] = 426.21}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 18.09, ["Ride"] = 16.7, ["Fly|Ride"] = 38.58, ["Neon"] = 16.02, ["Neon|Ride"] = 50.18, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 116.88, ["Mega|Ride"] = 192.31}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 56.6, ["Neon"] = 2.99, ["Neon|Ride"] = 46.73, ["Mega"] = 34.04, ["Mega|Ride"] = 196.77, ["Mega|Fly|Ride"] = 177.62}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 26.24, ["Ride"] = 57.73, ["Fly|Ride"] = 459.38, ["Neon"] = 199.5, ["Neon|Ride"] = 356.49, ["Mega"] = 1050, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 773.07}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 8032.47, ["Ride"] = 26.52, ["Fly|Ride"] = 68.25, ["Neon"] = 16.28, ["Neon|Ride"] = 61.13, ["Mega"] = 354.35, ["Mega|Ride"] = 297.51, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.13, ["Neon"] = 2.1, ["Neon|Ride"] = 55.13, ["Neon|Fly|Ride"] = 141.93, ["Mega"] = 17.1, ["Mega|Ride"] = 70.49, ["Mega|Fly|Ride"] = 168.67}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 3.34, ["Fly"] = 85.35, ["Ride"] = 34.13, ["Fly|Ride"] = 72.19, ["Neon"] = 23.63, ["Neon|Fly"] = 114.21, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 161.44, ["Mega"] = 136.24, ["Mega|Ride"] = 131.06, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 4.29, ["Fly"] = 44.82, ["Ride"] = 19.23, ["Fly|Ride"] = 50.33, ["Neon"] = 37.35, ["Neon|Fly"] = 144.62, ["Neon|Ride"] = 143.03, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 238.83, ["Mega|Ride"] = 251.07, ["Mega|Fly|Ride"] = 1321.69}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 19.87, ["Ride"] = 38.07, ["Fly|Ride"] = 105, ["Neon"] = 92.95, ["Neon|Ride"] = 185.72, ["Neon|Fly|Ride"] = 321.76, ["Mega"] = 426.93, ["Mega|Ride"] = 799.51}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.1, ["Fly"] = 6425.21, ["Ride"] = 17.07, ["Fly|Ride"] = 126, ["Neon"] = 42.69, ["Neon|Fly"] = 52.12, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 284.97, ["Mega"] = 334.69, ["Mega|Ride"] = 482.14, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 65.36, ["Ride"] = 15.74, ["Fly|Ride"] = 45.94, ["Neon"] = 3.78, ["Neon|Fly"] = 82.48, ["Neon|Ride"] = 27.66, ["Neon|Fly|Ride"] = 114.21, ["Mega"] = 45.94, ["Mega|Fly|Ride"] = 225.4}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 163.59, ["Fly"] = 228.27, ["Ride"] = 164.04, ["Fly|Ride"] = 256.04, ["Neon"] = 967.58, ["Neon|Ride"] = 1020.33, ["Neon|Fly|Ride"] = 840, ["Mega"] = 8538.29, ["Mega|Ride"] = 3842.7, ["Mega|Fly|Ride"] = 3986.8}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 19.22, ["Ride"] = 15.65, ["Fly|Ride"] = 36.75, ["Neon"] = 3.29, ["Neon|Fly"] = 36.17, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 47.25, ["Mega"] = 47.95, ["Mega|Ride"] = 49.26, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 6.57, ["Ride"] = 40.46, ["Fly|Ride"] = 228.27, ["Neon"] = 64.58, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 771.25, ["Mega"] = 313.69, ["Mega|Ride"] = 341.45, ["Mega|Fly|Ride"] = 379.32}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 21.83, ["Ride"] = 71.48, ["Fly|Ride"] = 183.75, ["Neon"] = 157.5, ["Neon|Ride"] = 284.97, ["Neon|Fly|Ride"] = 183.65, ["Mega"] = 786.19, ["Mega|Ride"] = 872.15, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 196.75, ["Fly"] = 305.97, ["Ride"] = 248.7, ["Fly|Ride"] = 293.99, ["Neon"] = 812.4, ["Neon|Ride"] = 702.18, ["Neon|Fly|Ride"] = 787.5, ["Mega|Fly|Ride"] = 3521.41}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 28.82, ["Ride"] = 161.43, ["Fly|Ride"] = 144.56, ["Neon"] = 124.68, ["Neon|Ride"] = 213.47, ["Neon|Fly|Ride"] = 426.93, ["Mega"] = 242.29, ["Mega|Ride"] = 326.64, ["Mega|Fly|Ride"] = 341.59}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 5.77, ["Fly"] = 96.41, ["Ride"] = 59.17, ["Fly|Ride"] = 71.49, ["Neon"] = 118.58, ["Neon|Fly"] = 161.48, ["Neon|Ride"] = 321.76, ["Neon|Fly|Ride"] = 203.75, ["Mega"] = 1138.8, ["Mega|Ride"] = 853.94, ["Mega|Fly|Ride"] = 695.63}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 920.07, ["Ride"] = 978.02, ["Fly|Ride"] = 958.13, ["Neon|Ride"] = 5906.25, ["Neon|Fly|Ride"] = 5117.63, ["Mega|Fly|Ride"] = 17077.53}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 6.11, ["Fly"] = 23.25, ["Ride"] = 21.46, ["Fly|Ride"] = 61.89, ["Neon"] = 47.23, ["Neon|Fly"] = 74.15, ["Neon|Ride"] = 49.13, ["Neon|Fly|Ride"] = 202.13, ["Mega"] = 241.02, ["Mega|Ride"] = 285.02, ["Mega|Fly|Ride"] = 346.49}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 2.62, ["Fly"] = 78.75, ["Ride"] = 42.67, ["Fly|Ride"] = 135.19, ["Neon"] = 32.82, ["Neon|Ride"] = 96.34, ["Neon|Fly|Ride"] = 190.32, ["Mega"] = 211.32, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 309.57, ["Mega|Fly|Ride"] = 421.64}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Fly"] = 85.35, ["Ride"] = 24.31, ["Fly|Ride"] = 142.96, ["Neon"] = 10.84, ["Neon|Ride"] = 46.95, ["Neon|Fly|Ride"] = 85.4, ["Mega"] = 91.81, ["Mega|Ride"] = 360.34, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 16.64, ["Fly"] = 57.62, ["Ride"] = 41.58, ["Fly|Ride"] = 95.71, ["Neon"] = 69.91, ["Neon|Fly"] = 228.42, ["Neon|Ride"] = 96.36, ["Neon|Fly|Ride"] = 178.55, ["Mega"] = 446.22, ["Mega|Ride"] = 415.8, ["Mega|Fly|Ride"] = 457.13}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 2.52, ["Fly"] = 21, ["Ride"] = 16.02, ["Fly|Ride"] = 45.85, ["Neon"] = 12.59, ["Neon|Fly"] = 42.74, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 101.4, ["Mega"] = 118.13, ["Mega|Fly"] = 280.98, ["Mega|Ride"] = 143.05, ["Mega|Fly|Ride"] = 164.33}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Ride"] = 24.94, ["Neon"] = 10.5, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 48.21, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 124.48, ["Mega|Ride"] = 166.53}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 240.64, ["Ride"] = 262.5, ["Fly|Ride"] = 426.72, ["Neon"] = 923.85, ["Neon|Fly|Ride"] = 1183.01, ["Mega|Fly|Ride"] = 3876.85}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Fly"] = 32.81, ["Ride"] = 26.17, ["Fly|Ride"] = 110.25, ["Neon"] = 3.93, ["Neon|Fly"] = 42.71, ["Neon|Ride"] = 39.29, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 61.6, ["Mega|Ride"] = 127.37, ["Mega|Fly|Ride"] = 341.59}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 3.93, ["Ride"] = 28.82, ["Fly|Ride"] = 88.86, ["Neon"] = 32.17, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 188.27, ["Mega"] = 170.79, ["Mega|Ride"] = 321.83, ["Mega|Fly|Ride"] = 192.86}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 3.93, ["Fly"] = 94.74, ["Ride"] = 25.73, ["Neon"] = 14.15, ["Neon|Ride"] = 36.17, ["Mega"] = 94.31, ["Mega|Ride"] = 120.53, ["Mega|Fly|Ride"] = 504.2}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 72.19, ["Ride"] = 129.46, ["Fly|Ride"] = 249.38, ["Neon"] = 447.57, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 761.61, ["Mega"] = 2561.49, ["Mega|Ride"] = 4269.66, ["Mega|Fly|Ride"] = 1780.46}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 22.32, ["Fly"] = 90.78, ["Ride"] = 42.69, ["Fly|Ride"] = 264.57, ["Neon"] = 180.71, ["Neon|Ride"] = 208.14, ["Neon|Fly|Ride"] = 341.93, ["Mega"] = 643.51, ["Mega|Ride"] = 621.25, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 17.99, ["Fly"] = 57.62, ["Ride"] = 39.37, ["Fly|Ride"] = 97.13, ["Neon"] = 81.38, ["Neon|Ride"] = 125.99, ["Neon|Fly|Ride"] = 249.61, ["Mega"] = 457.25, ["Mega|Ride"] = 435.75, ["Mega|Fly|Ride"] = 497.44}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 72.36, ["Neon"] = 10.49, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 71.52, ["Mega"] = 128.96, ["Mega|Ride"] = 163.13, ["Mega|Fly|Ride"] = 554}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 35.43, ["Fly"] = 78.75, ["Ride"] = 83.46, ["Fly|Ride"] = 104.99, ["Neon"] = 262.5, ["Neon|Fly"] = 245.44, ["Neon|Ride"] = 298.86, ["Neon|Fly|Ride"] = 312.38, ["Mega|Fly|Ride"] = 1011.71}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 52.5, ["Neon"] = 3.82, ["Neon|Ride"] = 57.69, ["Neon|Fly|Ride"] = 127.02, ["Mega"] = 60.85, ["Mega|Ride"] = 283.95, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 16.52, ["Fly"] = 128.93, ["Ride"] = 32.15, ["Fly|Ride"] = 86.75, ["Neon"] = 83.55, ["Neon|Ride"] = 99.95, ["Neon|Fly|Ride"] = 219.87, ["Mega"] = 357.09, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 425.91, ["Mega|Fly|Ride"] = 427.63}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 49.79, ["Fly"] = 203.41, ["Ride"] = 65.63, ["Fly|Ride"] = 133.64, ["Neon"] = 249.38, ["Neon|Fly"] = 426.93, ["Neon|Ride"] = 288.75, ["Neon|Fly|Ride"] = 496.13, ["Mega|Ride"] = 1460.24, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 15.94, ["Ride"] = 15.94, ["Fly|Ride"] = 35.42, ["Neon"] = 2.1, ["Neon|Fly"] = 24.49, ["Neon|Ride"] = 15.72, ["Neon|Fly|Ride"] = 42.76, ["Mega"] = 16.59, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 40.58, ["Mega|Fly|Ride"] = 89.88}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 2.1, ["Ride"] = 22.32, ["Fly|Ride"] = 98.44, ["Neon"] = 23.63, ["Neon|Ride"] = 65.61, ["Neon|Fly|Ride"] = 167.99, ["Mega"] = 228.38, ["Mega|Ride"] = 150.94, ["Mega|Fly|Ride"] = 392.44}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 14.96, ["Fly"] = 142.94, ["Ride"] = 41.55, ["Fly|Ride"] = 85.32, ["Neon"] = 110.15, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 272.76, ["Mega"] = 616.71, ["Mega|Ride"] = 454.77, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 22.23, ["Neon"] = 2.1, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 95.81, ["Mega"] = 21, ["Mega|Ride"] = 50.95, ["Mega|Fly|Ride"] = 211.36}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 24.11, ["Fly"] = 207.9, ["Ride"] = 78.66, ["Fly|Ride"] = 183.39, ["Neon"] = 104.81, ["Neon|Ride"] = 173.36, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 611.99, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 574.5, ["Mega|Fly|Ride"] = 776.02}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 13.13, ["Fly"] = 42.69, ["Ride"] = 21.35, ["Fly|Ride"] = 88.55, ["Neon"] = 376.69, ["Neon|Ride"] = 120.59, ["Neon|Fly|Ride"] = 164.37, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 484.61}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 4.59, ["Ride"] = 48.57, ["Neon"] = 56.42, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 75.89, ["Neon|Fly|Ride"] = 711.89, ["Mega"] = 232.98, ["Mega|Ride"] = 313.39, ["Mega|Fly|Ride"] = 422.7}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 7.87, ["Fly"] = 65.63, ["Ride"] = 72.19, ["Fly|Ride"] = 230.26, ["Neon"] = 54.9, ["Neon|Ride"] = 88.6, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 215.86, ["Mega|Ride"] = 256.19, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Fly"] = 42.69, ["Ride"] = 20.9, ["Fly|Ride"] = 196.88, ["Neon"] = 3.52, ["Neon|Ride"] = 34.92, ["Mega"] = 53.82, ["Mega|Fly"] = 213.47, ["Mega|Ride"] = 96.44, ["Mega|Fly|Ride"] = 285.02}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 57.84, ["Neon"] = 4.29, ["Neon|Fly|Ride"] = 145.29, ["Mega"] = 41.28, ["Mega|Ride"] = 78.66, ["Mega|Fly|Ride"] = 195.33}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 17.07}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 38.04, ["Fly"] = 100.28, ["Ride"] = 64.94, ["Fly|Ride"] = 80.01, ["Neon"] = 196.88, ["Neon|Ride"] = 213.47, ["Neon|Fly|Ride"] = 315, ["Mega"] = 1850.68, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 853.58}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.29, ["Neon|Ride"] = 27.57, ["Mega"] = 23.49, ["Mega|Ride"] = 121.7, ["Mega|Fly|Ride"] = 320.23}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 525, ["Fly"] = 569.6, ["Ride"] = 561.75, ["Fly|Ride"] = 554.68, ["Neon"] = 2845.1, ["Neon|Ride"] = 2027.86, ["Neon|Fly|Ride"] = 2111.03, ["Mega"] = 17076.56, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 3.93, ["Fly"] = 48.37, ["Ride"] = 33.72, ["Fly|Ride"] = 40.97, ["Neon"] = 9.81, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 114.21, ["Mega"] = 170.79, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 626.58}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 16.71, ["Fly|Ride"] = 57.75, ["Neon"] = 24.94, ["Neon|Ride"] = 64.05, ["Neon|Fly|Ride"] = 99.65, ["Mega"] = 128.96, ["Mega|Fly"] = 284.97, ["Mega|Ride"] = 164.4, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 11.58, ["Ride"] = 28.82, ["Fly|Ride"] = 533.39, ["Neon"] = 106.7, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 313.69, ["Mega"] = 643.51, ["Mega|Ride"] = 539.99, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 2.1, ["Fly"] = 426.68, ["Ride"] = 38.57, ["Fly|Ride"] = 711.56, ["Neon"] = 30.35, ["Neon|Fly"] = 50.18, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 392.44, ["Mega"] = 279.57, ["Mega|Fly|Ride"] = 495.29}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 8.9, ["Ride"] = 73.49, ["Fly|Ride"] = 173.25, ["Neon"] = 52.5, ["Neon|Ride"] = 94.5, ["Neon|Fly|Ride"] = 273.02, ["Mega"] = 497.44, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 402.59}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 6.3, ["Ride"] = 28.44, ["Fly|Ride"] = 91.88, ["Neon"] = 31.06, ["Neon|Ride"] = 81.1, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 232.21, ["Mega|Ride"] = 324.7, ["Mega|Fly|Ride"] = 349.13}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 45.78, ["Ride"] = 13.55, ["Fly|Ride"] = 85.46, ["Neon"] = 2.1, ["Neon|Fly"] = 41.99, ["Neon|Ride"] = 15.7, ["Neon|Fly|Ride"] = 45.91, ["Mega"] = 13.96, ["Mega|Fly"] = 65.01, ["Mega|Ride"] = 49.12, ["Mega|Fly|Ride"] = 99.01}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 4.38, ["Fly"] = 54.42, ["Ride"] = 38.42, ["Fly|Ride"] = 106.7, ["Neon"] = 24.03, ["Neon|Fly"] = 120.51, ["Neon|Ride"] = 50.94, ["Neon|Fly|Ride"] = 200.05, ["Mega"] = 196.88, ["Mega|Ride"] = 213.57, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 261.19, ["Ride"] = 342.49, ["Fly|Ride"] = 364.88, ["Neon"] = 1312.5, ["Neon|Ride"] = 1094.63, ["Neon|Fly|Ride"] = 1050, ["Mega|Ride"] = 9353.13, ["Mega|Fly|Ride"] = 5258.08}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 80.63, ["Ride"] = 114.19, ["Fly|Ride"] = 254.94, ["Neon"] = 458.07, ["Neon|Fly"] = 913.62, ["Neon|Ride"] = 446.25, ["Neon|Fly|Ride"] = 698.25, ["Mega"] = 2277.59, ["Mega|Ride"] = 1701.48, ["Mega|Fly|Ride"] = 1808.73}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 16.22, ["Fly|Ride"] = 35.44, ["Neon"] = 6.12, ["Neon|Fly"] = 67.38, ["Neon|Ride"] = 34.17, ["Neon|Fly|Ride"] = 64.05, ["Mega"] = 143.03, ["Mega|Fly"] = 212.41, ["Mega|Ride"] = 92.88, ["Mega|Fly|Ride"] = 246.88}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 16.02, ["Ride"] = 15.38, ["Fly|Ride"] = 28.85, ["Neon"] = 7.88, ["Neon|Fly"] = 38.43, ["Neon|Ride"] = 26.9, ["Neon|Fly|Ride"] = 41.65, ["Mega"] = 76.16, ["Mega|Fly"] = 284.97, ["Mega|Ride"] = 82.77, ["Mega|Fly|Ride"] = 143.16}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.1, ["Fly"] = 100.28, ["Ride"] = 22.32, ["Fly|Ride"] = 98.44, ["Neon"] = 91.88, ["Neon|Fly|Ride"] = 157.5, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 203.73, ["Fly"] = 321.7, ["Ride"] = 228.82, ["Fly|Ride"] = 288.75, ["Neon"] = 1173.47, ["Neon|Ride"] = 1050, ["Neon|Fly|Ride"] = 1174.03, ["Mega|Ride"] = 8539.31, ["Mega|Fly|Ride"] = 3806.25}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.1, ["Fly"] = 14.44, ["Ride"] = 15.1, ["Fly|Ride"] = 47.25, ["Neon"] = 18.06, ["Neon|Fly"] = 104.97, ["Neon|Ride"] = 24.95, ["Neon|Fly|Ride"] = 76.04, ["Mega"] = 255.94, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 2.26, ["Ride"] = 77.09, ["Fly|Ride"] = 213.35, ["Neon"] = 25.88, ["Neon|Ride"] = 106.74, ["Neon|Fly|Ride"] = 284.97, ["Mega"] = 196.88, ["Mega|Ride"] = 300.45, ["Mega|Fly|Ride"] = 396.5}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 91.1, ["Neon"] = 7.6, ["Neon|Ride"] = 156.13, ["Mega"] = 91.77, ["Mega|Ride"] = 337.5, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 12.84, ["Fly"] = 47.18, ["Ride"] = 21, ["Fly|Ride"] = 74.7, ["Neon"] = 149.37, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 235.89, ["Mega"] = 460.69, ["Mega|Ride"] = 456.75, ["Mega|Fly|Ride"] = 590.52}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 32.48, ["Ride"] = 85.35, ["Fly|Ride"] = 392.03, ["Neon"] = 127.74, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 143.03, ["Neon|Fly|Ride"] = 305.82, ["Mega"] = 509.77, ["Mega|Fly"] = 2241.31, ["Mega|Ride"] = 509, ["Mega|Fly|Ride"] = 621.01}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 28.88, ["Fly"] = 64.02, ["Ride"] = 36.28, ["Fly|Ride"] = 91.77, ["Neon"] = 161.48, ["Neon|Fly"] = 286.44, ["Neon|Ride"] = 133.7, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 853.84, ["Mega|Ride"] = 700.88, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 17.05, ["Ride"] = 13.55, ["Fly|Ride"] = 36.28, ["Neon"] = 2.1, ["Neon|Fly"] = 31.47, ["Neon|Ride"] = 15.94, ["Neon|Fly|Ride"] = 48.47, ["Mega"] = 20.9, ["Mega|Fly"] = 41.65, ["Mega|Ride"] = 38.45, ["Mega|Fly|Ride"] = 94.23}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 183.75, ["Ride"] = 203.44, ["Fly|Ride"] = 272.62, ["Neon"] = 3273.94, ["Neon|Fly|Ride"] = 1016.07, ["Mega|Fly|Ride"] = 3700.73}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 11.2, ["Fly"] = 74.82, ["Ride"] = 20.33, ["Fly|Ride"] = 92.94, ["Neon"] = 161.16, ["Neon|Ride"] = 110.25, ["Neon|Fly|Ride"] = 426.93, ["Mega"] = 422.63, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 35.98, ["Ride"] = 18.76, ["Fly|Ride"] = 43.35, ["Neon"] = 5.16, ["Neon|Fly"] = 41.93, ["Neon|Ride"] = 28.84, ["Neon|Fly|Ride"] = 102.38, ["Mega"] = 60.88, ["Mega|Fly"] = 222.01, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 232.71}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 16.14, ["Fly|Ride"] = 76.9, ["Neon"] = 2.1, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 128.96, ["Mega"] = 22.23, ["Mega|Fly"] = 143.03, ["Mega|Ride"] = 45.76, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 32.82, ["Neon"] = 10.37, ["Neon|Fly"] = 723.05, ["Neon|Ride"] = 49.88, ["Mega"] = 129.94, ["Mega|Ride"] = 131.78, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 8.65, ["Fly"] = 39.38, ["Ride"] = 24.81, ["Fly|Ride"] = 65.63, ["Neon"] = 46.34, ["Neon|Fly"] = 271.1, ["Neon|Ride"] = 60.19, ["Neon|Fly|Ride"] = 107.63, ["Mega"] = 602.54, ["Mega|Ride"] = 370.13, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 4.74, ["Ride"] = 45.88, ["Neon"] = 65.63, ["Neon|Ride"] = 149.44, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 275.63, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 482.14}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 34.13, ["Neon"] = 3.93, ["Neon|Ride"] = 26.16, ["Neon|Fly|Ride"] = 100.38, ["Mega"] = 21, ["Mega|Ride"] = 98.21, ["Mega|Fly|Ride"] = 121.38}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 5.85, ["Ride"] = 28.46, ["Fly|Ride"] = 142.96, ["Neon"] = 34.41, ["Neon|Fly"] = 96.42, ["Neon|Ride"] = 45.72, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 148.36, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 43.38, ["Neon"] = 3.66, ["Neon|Fly"] = 114.21, ["Neon|Ride"] = 54.45, ["Neon|Fly|Ride"] = 102.38, ["Mega"] = 26.25, ["Mega|Ride"] = 92.27, ["Mega|Fly|Ride"] = 321.26}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 47.4, ["Ride"] = 20.28, ["Fly|Ride"] = 40.97, ["Neon"] = 6.57, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 128.09, ["Mega"] = 78.36, ["Mega|Ride"] = 63.95, ["Mega|Fly|Ride"] = 238.65}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 623.6, ["Ride"] = 700.37, ["Fly|Ride"] = 771.75, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 3675, ["Mega|Fly|Ride"] = 9620.63}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 18.05, ["Fly|Ride"] = 37.35, ["Neon"] = 13.13, ["Neon|Fly"] = 42.71, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 191.06, ["Mega|Fly|Ride"] = 394.15}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.1, ["Ride"] = 45.93, ["Neon"] = 12.99, ["Neon|Fly"] = 747.11, ["Neon|Ride"] = 84.89, ["Neon|Fly|Ride"] = 185.72, ["Mega"] = 57.64, ["Mega|Fly"] = 190, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 257.27}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 7.08, ["Fly"] = 26.25, ["Ride"] = 22.23, ["Fly|Ride"] = 57.75, ["Neon"] = 41.44, ["Neon|Fly"] = 192.83, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 102.72, ["Mega"] = 485.63, ["Mega|Ride"] = 299.23, ["Mega|Fly|Ride"] = 347.82}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 42.69, ["Ride"] = 15.01, ["Fly|Ride"] = 57.62, ["Neon"] = 5.37, ["Neon|Fly"] = 149.44, ["Neon|Ride"] = 24.8, ["Neon|Fly|Ride"] = 58.65, ["Mega"] = 62.89, ["Mega|Ride"] = 100.58, ["Mega|Fly|Ride"] = 262.4}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 36.49, ["Ride"] = 57.62, ["Fly|Ride"] = 314.67, ["Neon"] = 196.88, ["Neon|Ride"] = 257.9, ["Mega"] = 682, ["Mega|Ride"] = 693.82, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Fly"] = 32.7, ["Ride"] = 20.37, ["Fly|Ride"] = 76.13, ["Neon"] = 6.42, ["Neon|Fly"] = 137.39, ["Neon|Ride"] = 32.55, ["Neon|Fly|Ride"] = 119.43, ["Mega"] = 45.93, ["Mega|Ride"] = 132.9, ["Mega|Fly|Ride"] = 272.98}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 26.25, ["Fly|Ride"] = 63.02, ["Neon"] = 11.79, ["Neon|Ride"] = 48.57, ["Neon|Fly|Ride"] = 161.48, ["Mega"] = 101.22, ["Mega|Ride"] = 198.59, ["Mega|Fly|Ride"] = 170.94}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly|Ride"] = 65.83, ["Neon"] = 17.09, ["Neon|Fly|Ride"] = 114.21, ["Mega"] = 97.12, ["Mega|Ride"] = 160.12, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 42.69, ["Ride"] = 15.94, ["Fly|Ride"] = 68.76, ["Neon"] = 3.39, ["Neon|Fly"] = 71.52, ["Neon|Ride"] = 21.86, ["Neon|Fly|Ride"] = 108.15, ["Mega"] = 40.58, ["Mega|Fly"] = 227.39, ["Mega|Ride"] = 81.51}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 18.38, ["Fly"] = 20.83, ["Ride"] = 16.74, ["Fly|Ride"] = 42, ["Neon"] = 114.15, ["Neon|Ride"] = 80.88, ["Neon|Fly|Ride"] = 143.03, ["Mega|Ride"] = 558.27, ["Mega|Fly|Ride"] = 384.55}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 630, ["Fly"] = 996.26, ["Ride"] = 713.15, ["Fly|Ride"] = 786.19, ["Neon"] = 1935.94, ["Neon|Ride"] = 2072.94, ["Neon|Fly|Ride"] = 2163, ["Mega"] = 4654.5, ["Mega|Fly|Ride"] = 6205.95}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 22.23, ["Ride"] = 14.96, ["Fly|Ride"] = 41.48, ["Neon"] = 3.46, ["Neon|Fly"] = 46.32, ["Neon|Ride"] = 19.48, ["Neon|Fly|Ride"] = 47.43, ["Mega"] = 39.37, ["Mega|Ride"] = 70.11, ["Mega|Fly|Ride"] = 170.8}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 3.94, ["Ride"] = 32.81, ["Fly|Ride"] = 210, ["Neon"] = 51.51, ["Neon|Ride"] = 212.41, ["Neon|Fly|Ride"] = 210, ["Mega"] = 482.04, ["Mega|Ride"] = 393.1, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 55, ["Fly"] = 104.9, ["Ride"] = 72.19, ["Fly|Ride"] = 111.57, ["Neon"] = 315, ["Neon|Ride"] = 313.69, ["Neon|Fly|Ride"] = 434.44, ["Mega"] = 2439.83, ["Mega|Fly|Ride"] = 2611.88}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 28.88, ["Fly"] = 146.86, ["Ride"] = 60.38, ["Fly|Ride"] = 104.9, ["Neon"] = 228.3, ["Neon|Ride"] = 161.3, ["Neon|Fly|Ride"] = 426.93, ["Mega"] = 1285.81, ["Mega|Ride"] = 912.65, ["Mega|Fly|Ride"] = 1125.76}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 9.19, ["Fly"] = 90.38, ["Ride"] = 26.49, ["Fly|Ride"] = 142.94, ["Neon"] = 50.72, ["Neon|Ride"] = 126, ["Neon|Fly|Ride"] = 273, ["Mega"] = 302.3, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 442.99}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 26.25, ["Ride"] = 61.45, ["Fly|Ride"] = 140.83, ["Neon"] = 109.68, ["Neon|Ride"] = 352.43, ["Neon|Fly|Ride"] = 149.22, ["Mega"] = 339.05, ["Mega|Fly"] = 523.01, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 433.93}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 19.69, ["Ride"] = 77.44, ["Fly|Ride"] = 160.02, ["Neon"] = 144.38, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 525, ["Mega"] = 524.99, ["Mega|Fly"] = 567, ["Mega|Ride"] = 476.44, ["Mega|Fly|Ride"] = 744.19}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 6.57}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 7.34, ["Ride"] = 24.86, ["Fly|Ride"] = 78.75, ["Neon"] = 49.16, ["Neon|Ride"] = 63.15, ["Neon|Fly|Ride"] = 213.47, ["Mega"] = 210, ["Mega|Fly"] = 453.68, ["Mega|Ride"] = 224.69, ["Mega|Fly|Ride"] = 306.54}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.62, ["Ride"] = 46.98, ["Neon"] = 11.81, ["Neon|Fly|Ride"] = 213.47, ["Mega"] = 140.9}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 28.12, ["Fly"] = 62.99, ["Ride"] = 30.55, ["Fly|Ride"] = 81.37, ["Neon"] = 162.56, ["Neon|Ride"] = 141.73, ["Neon|Fly|Ride"] = 294.59, ["Mega|Ride"] = 767.92, ["Mega|Fly|Ride"] = 616.81}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.94, ["Fly"] = 20.29, ["Ride"] = 16.02, ["Fly|Ride"] = 38.07, ["Neon"] = 16.02, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 35.88, ["Neon|Fly|Ride"] = 73.41, ["Mega"] = 198.19, ["Mega|Fly"] = 425.86, ["Mega|Ride"] = 185.75, ["Mega|Fly|Ride"] = 234.8}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 3.73, ["Fly"] = 108.22, ["Ride"] = 25.19, ["Fly|Ride"] = 71.49, ["Neon"] = 23.99, ["Neon|Ride"] = 48.16, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 161.48, ["Mega|Fly"] = 197.4, ["Mega|Ride"] = 162.36, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Ride"] = 71.48, ["Neon"] = 7.35, ["Mega"] = 37.37, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 258.57}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 30.85, ["Ride"] = 52.48, ["Fly|Ride"] = 120.75, ["Neon"] = 281.65, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 426.93, ["Mega|Ride"] = 853.94, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 22.31, ["Fly|Ride"] = 65.63, ["Neon"] = 7.88, ["Neon|Fly"] = 203.44, ["Neon|Ride"] = 85.4, ["Neon|Fly|Ride"] = 105, ["Mega"] = 69.71, ["Mega|Ride"] = 141.36}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 9.07, ["Ride"] = 57.62, ["Fly|Ride"] = 283.75, ["Neon"] = 72.19, ["Neon|Ride"] = 150.94, ["Neon|Fly|Ride"] = 143.03, ["Mega"] = 367.5, ["Mega|Fly"] = 569.94, ["Mega|Ride"] = 482.14, ["Mega|Fly|Ride"] = 552.93}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 45.91, ["Ride"] = 15.65, ["Fly|Ride"] = 60.82, ["Neon"] = 14.15, ["Neon|Ride"] = 30.09, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 185.72, ["Mega|Ride"] = 202.79, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 2.1, ["Fly"] = 52.49, ["Ride"] = 21.35, ["Fly|Ride"] = 87.49, ["Neon"] = 43.94, ["Neon|Fly"] = 128.09, ["Neon|Ride"] = 143.03, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 399.18, ["Mega|Ride"] = 425.91, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 7.34, ["Ride"] = 93.89, ["Neon"] = 90.92, ["Mega"] = 413.86, ["Mega|Ride"] = 366.19, ["Mega|Fly|Ride"] = 639.29}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 46.3, ["Ride"] = 131.25, ["Fly|Ride"] = 145.26, ["Neon"] = 237.18, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 284.97, ["Mega"] = 1164.42, ["Mega|Ride"] = 1238.22, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 10.5, ["Ride"] = 81.81, ["Fly|Ride"] = 142.96, ["Neon"] = 107.62, ["Neon|Ride"] = 183.75, ["Mega"] = 354.27, ["Mega|Ride"] = 562.89, ["Mega|Fly|Ride"] = 711.98}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 10.61, ["Ride"] = 126.04, ["Neon"] = 91.75, ["Neon|Fly"] = 213.47, ["Neon|Ride"] = 170.63, ["Mega"] = 803.78, ["Mega|Ride"] = 433.93, ["Mega|Fly|Ride"] = 570.01}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 22.32, ["Ride"] = 105, ["Fly|Ride"] = 367.48, ["Neon"] = 91.88, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 664.93, ["Mega|Fly"] = 2134.58, ["Mega|Ride"] = 723.19, ["Mega|Fly|Ride"] = 739.19}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 2.1, ["Neon"] = 18.35, ["Neon|Fly|Ride"] = 143.03, ["Mega"] = 185.72, ["Mega|Fly|Ride"] = 321.83}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 27.75, ["Ride"] = 16.02, ["Fly|Ride"] = 42.69, ["Neon"] = 6.42, ["Neon|Fly"] = 42.71, ["Neon|Ride"] = 23.89, ["Neon|Fly|Ride"] = 96.42, ["Mega"] = 96.44, ["Mega|Ride"] = 89.21, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 3.55, ["Fly"] = 45.94, ["Ride"] = 29.13, ["Fly|Ride"] = 69.57, ["Neon"] = 14.79, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 121.69, ["Mega"] = 86.37, ["Mega|Ride"] = 110.25, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 33.08, ["Ride"] = 19.68, ["Fly|Ride"] = 46.4, ["Neon"] = 3.84, ["Neon|Ride"] = 27.26, ["Neon|Fly|Ride"] = 118.12, ["Mega"] = 51.75, ["Mega|Fly"] = 122.75, ["Mega|Ride"] = 83.99, ["Mega|Fly|Ride"] = 173.25}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.1, ["Fly"] = 65.62, ["Ride"] = 21.04, ["Fly|Ride"] = 71.49, ["Neon"] = 18.69, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 213.47, ["Mega"] = 285.16, ["Mega|Ride"] = 325.5, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.12, ["Fly"] = 49.61, ["Ride"] = 24.53, ["Fly|Ride"] = 426.68, ["Neon"] = 29.28, ["Neon|Fly"] = 315, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 150.94, ["Mega"] = 284.97, ["Mega|Ride"] = 287.47, ["Mega|Fly|Ride"] = 1067.42}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 5.25, ["Fly"] = 131.25, ["Ride"] = 22.32, ["Fly|Ride"] = 53.82, ["Neon"] = 28.82, ["Neon|Fly"] = 114.21, ["Neon|Ride"] = 29.89, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 211.21, ["Mega|Ride"] = 291.6, ["Mega|Fly|Ride"] = 397.04}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 35.48, ["Ride"] = 18.38, ["Fly|Ride"] = 51.79, ["Neon"] = 19.22, ["Neon|Ride"] = 69.08, ["Neon|Fly|Ride"] = 106.74, ["Mega"] = 256.17, ["Mega|Ride"] = 207.31, ["Mega|Fly|Ride"] = 186.18}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 2.52, ["Fly"] = 131.25, ["Ride"] = 45.71, ["Fly|Ride"] = 131.24, ["Neon"] = 15.65, ["Neon|Fly"] = 437.06, ["Neon|Ride"] = 66.92, ["Neon|Fly|Ride"] = 170.62, ["Mega"] = 98.34, ["Mega|Fly"] = 210, ["Mega|Ride"] = 136.4, ["Mega|Fly|Ride"] = 248.58}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 10.39, ["Ride"] = 112.53, ["Fly|Ride"] = 314.9, ["Neon"] = 115.5, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 590.63, ["Mega|Ride"] = 658.45, ["Mega|Fly|Ride"] = 701.15}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 55.35, ["Fly"] = 164.07, ["Ride"] = 77.44, ["Fly|Ride"] = 165.38, ["Neon"] = 235.65, ["Neon|Ride"] = 190.36, ["Neon|Fly|Ride"] = 366.03, ["Mega"] = 1338.39, ["Mega|Ride"] = 1031.44, ["Mega|Fly|Ride"] = 1102.5}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 51.09, ["Ride"] = 21.56, ["Fly|Ride"] = 118.12, ["Neon"] = 2.1, ["Neon|Ride"] = 32.8, ["Neon|Fly|Ride"] = 143.03, ["Mega"] = 25.55, ["Mega|Ride"] = 70.26, ["Mega|Fly|Ride"] = 145.59}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 8.24, ["Ride"] = 52.5, ["Neon|Ride"] = 113.29, ["Mega"] = 686.56, ["Mega|Fly|Ride"] = 1125.06}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 48.57, ["Ride"] = 91.91, ["Neon"] = 462.27, ["Neon|Ride"] = 357, ["Neon|Fly|Ride"] = 852.77, ["Mega"] = 1254.07, ["Mega|Fly|Ride"] = 1311.19}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 7.75, ["Fly"] = 190.32, ["Ride"] = 29.46, ["Fly|Ride"] = 133.88, ["Neon"] = 49.88, ["Neon|Fly"] = 128.96, ["Neon|Ride"] = 70.88, ["Neon|Fly|Ride"] = 126, ["Mega"] = 242.71, ["Mega|Ride"] = 242.71, ["Mega|Fly|Ride"] = 241.95}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 6.57, ["Ride"] = 45.88, ["Fly|Ride"] = 78.75, ["Neon"] = 15.91, ["Neon|Ride"] = 68.15, ["Neon|Fly|Ride"] = 123.38, ["Mega"] = 97.13, ["Mega|Fly"] = 282.18, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 167.95}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 18.27, ["Fly|Ride"] = 47.16, ["Neon"] = 11.5, ["Neon|Ride"] = 24.44, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 131.25, ["Mega|Ride"] = 104.81, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 17.64, ["Ride"] = 16, ["Fly|Ride"] = 31.4, ["Neon"] = 2.1, ["Neon|Fly"] = 29.6, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 45.85, ["Mega"] = 26.25, ["Mega|Ride"] = 69.56, ["Mega|Fly|Ride"] = 152.25}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 18.71, ["Fly|Ride"] = 85.39, ["Neon"] = 3.66, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 39.06, ["Mega|Fly"] = 138.62, ["Mega|Ride"] = 57.19, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Neon"] = 2.1, ["Neon|Ride"] = 145.08, ["Mega"] = 32.71, ["Mega|Ride"] = 110.25, ["Mega|Fly|Ride"] = 328.02}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 4.54, ["Ride"] = 104.99, ["Neon"] = 38.98, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 402.5, ["Mega|Ride"] = 272.44, ["Mega|Fly|Ride"] = 421.64}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 10.19, ["Ride"] = 30.19, ["Fly|Ride"] = 212.03, ["Neon"] = 56.56, ["Neon|Ride"] = 101.4, ["Neon|Fly|Ride"] = 143.03, ["Mega"] = 225.37, ["Mega|Ride"] = 351.75, ["Mega|Fly|Ride"] = 482.14}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 3.94, ["Fly"] = 19.67, ["Ride"] = 18.69, ["Fly|Ride"] = 37.2, ["Neon"] = 28.88, ["Neon|Ride"] = 38.18, ["Neon|Fly|Ride"] = 84, ["Mega"] = 333.01, ["Mega|Ride"] = 306.16, ["Mega|Fly|Ride"] = 367.49}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 57.49, ["Ride"] = 98.44, ["Fly|Ride"] = 124.69, ["Neon"] = 393.75, ["Neon|Ride"] = 284.97, ["Neon|Fly|Ride"] = 711.89, ["Mega"] = 2410.13, ["Mega|Fly|Ride"] = 1472.63}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 17.73, ["Fly"] = 82.69, ["Ride"] = 58.97, ["Fly|Ride"] = 64.32, ["Neon"] = 992.7, ["Neon|Fly|Ride"] = 630, ["Mega"] = 464.63, ["Mega|Ride"] = 879.38, ["Mega|Fly|Ride"] = 1037.54}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 21.35, ["Ride"] = 15.94, ["Fly|Ride"] = 40.56, ["Neon"] = 2.16, ["Neon|Fly"] = 42.71, ["Neon|Ride"] = 17.97, ["Neon|Fly|Ride"] = 56.44, ["Mega|Fly"] = 71.52, ["Mega|Ride"] = 93.44, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 14.3, ["Ride"] = 15.74, ["Fly|Ride"] = 32.81, ["Neon"] = 3.56, ["Neon|Fly"] = 28.84, ["Neon|Ride"] = 16.02, ["Neon|Fly|Ride"] = 41.58, ["Mega"] = 48.21, ["Mega|Fly"] = 128.09, ["Mega|Ride"] = 57.14, ["Mega|Fly|Ride"] = 91.88}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 367.5, ["Fly"] = 562.55, ["Ride"] = 441.83, ["Fly|Ride"] = 497.66, ["Neon|Fly|Ride"] = 1959.56, ["Mega|Fly|Ride"] = 6761}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 10.68, ["Fly"] = 114.14, ["Ride"] = 26.25, ["Neon"] = 45.74, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 403.5, ["Mega|Ride"] = 400.32, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 15.93, ["Ride"] = 18.15, ["Fly|Ride"] = 33.92, ["Neon"] = 3.49, ["Neon|Fly"] = 19.84, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 43.22, ["Mega"] = 44.94, ["Mega|Ride"] = 80.13, ["Mega|Fly|Ride"] = 106.46}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 43.32, ["Ride"] = 98.24, ["Fly|Ride"] = 281.65, ["Neon"] = 227.07, ["Neon|Ride"] = 261.19, ["Neon|Fly|Ride"] = 412.13, ["Mega"] = 737.62, ["Mega|Ride"] = 761.25, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 27.27, ["Ride"] = 17.06, ["Fly|Ride"] = 45.78, ["Neon"] = 10.4, ["Neon|Fly"] = 79, ["Neon|Ride"] = 28.86, ["Neon|Fly|Ride"] = 79.94, ["Mega"] = 124.63, ["Mega|Ride"] = 143.05, ["Mega|Fly|Ride"] = 215.24}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 71.48, ["Ride"] = 57.62, ["Fly|Ride"] = 196.88, ["Neon"] = 3.68, ["Neon|Fly"] = 96.42, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 19.69, ["Mega|Ride"] = 68.16, ["Mega|Fly|Ride"] = 209.9}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 31.5, ["Fly"] = 128.63, ["Ride"] = 78.74, ["Fly|Ride"] = 215.73, ["Neon"] = 190.16, ["Neon|Ride"] = 201.2, ["Neon|Fly|Ride"] = 287.44, ["Mega"] = 803.78, ["Mega|Ride"] = 640.57, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 19.68, ["Fly|Ride"] = 146.99, ["Neon"] = 3.94, ["Neon|Ride"] = 40.6, ["Mega"] = 38.74, ["Mega|Ride"] = 155.59, ["Mega|Fly|Ride"] = 252}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 37.34, ["Ride"] = 62.79, ["Fly|Ride"] = 105, ["Neon"] = 148.32, ["Neon|Ride"] = 249.27, ["Neon|Fly|Ride"] = 288.46, ["Mega"] = 1181.25, ["Mega|Ride"] = 1707.87, ["Mega|Fly|Ride"] = 1333.83}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 2.9, ["Fly"] = 71.48, ["Ride"] = 39.38, ["Fly|Ride"] = 121.63, ["Neon"] = 26.77, ["Neon|Ride"] = 230.9, ["Neon|Fly|Ride"] = 161.48, ["Mega"] = 169.32, ["Mega|Ride"] = 183.75}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.1, ["Fly"] = 71.48, ["Ride"] = 73.5, ["Fly|Ride"] = 71.49, ["Neon"] = 8.39, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 433.84, ["Mega"] = 104.62, ["Mega|Ride"] = 124.69, ["Mega|Fly|Ride"] = 301.03}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 41.69, ["Fly"] = 85.35, ["Ride"] = 65.62, ["Fly|Ride"] = 533.39, ["Mega|Ride"] = 1707.87, ["Mega|Fly|Ride"] = 1986.47}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 569.94, ["Ride"] = 39.38, ["Fly|Ride"] = 71.49, ["Neon"] = 6.2, ["Neon|Ride"] = 40.61, ["Neon|Fly|Ride"] = 114.21, ["Mega"] = 39.38, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 134.51, ["Mega|Fly|Ride"] = 236.98}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 24.66, ["Ride"] = 19.09, ["Fly|Ride"] = 102.88, ["Neon"] = 8.25, ["Neon|Fly"] = 42, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 60.85, ["Mega"] = 59.13, ["Mega|Fly"] = 148.24, ["Mega|Ride"] = 120.54, ["Mega|Fly|Ride"] = 219.19}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 8.18, ["Fly"] = 57.91, ["Ride"] = 35.63, ["Fly|Ride"] = 169.63, ["Neon"] = 71.31, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 149.44, ["Mega"] = 328.01, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 401.06}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 11.48, ["Fly"] = 80.72, ["Ride"] = 24.05, ["Fly|Ride"] = 65.58, ["Neon"] = 87.28, ["Neon|Ride"] = 85.4, ["Neon|Fly|Ride"] = 150.94, ["Mega"] = 409.74, ["Mega|Ride"] = 444.32, ["Mega|Fly|Ride"] = 563.61}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 28.82, ["Fly"] = 48.57, ["Ride"] = 28.38, ["Fly|Ride"] = 54.45, ["Neon"] = 79.75, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 141.72, ["Mega"] = 404.88, ["Mega|Ride"] = 323.54, ["Mega|Fly|Ride"] = 379.32}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 61.45, ["Ride"] = 123.38, ["Fly|Ride"] = 257.81, ["Neon"] = 301.88, ["Neon|Ride"] = 286.53, ["Neon|Fly|Ride"] = 426.93, ["Mega"] = 1575, ["Mega|Ride"] = 1591.53, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 6.25, ["Ride"] = 114.14, ["Fly|Ride"] = 203.44, ["Neon"] = 55.33, ["Neon|Ride"] = 113.29, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 249.48, ["Mega|Fly"] = 566.74, ["Mega|Ride"] = 354.4, ["Mega|Fly|Ride"] = 532.65}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 3.59, ["Ride"] = 27.28, ["Fly|Ride"] = 78.74, ["Neon"] = 16.02, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 284.97, ["Mega|Ride"] = 244.13, ["Mega|Fly|Ride"] = 335.99}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 9.1, ["Fly"] = 135.19, ["Ride"] = 36.36, ["Fly|Ride"] = 115.5, ["Neon"] = 57.63, ["Neon|Ride"] = 105, ["Mega"] = 426.93, ["Mega|Ride"] = 640.46, ["Mega|Fly|Ride"] = 789.9}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 13.13, ["Fly|Ride"] = 39.74, ["Neon"] = 2.1, ["Neon|Fly"] = 21.69, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 15.63, ["Mega|Ride"] = 26.78, ["Mega|Fly|Ride"] = 96.01}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 48.57, ["Fly"] = 226.15, ["Ride"] = 121.62, ["Fly|Ride"] = 131.25, ["Neon"] = 236.25, ["Neon|Fly"] = 2419.55, ["Neon|Ride"] = 293.99, ["Neon|Fly|Ride"] = 1285.81, ["Mega"] = 1064.1, ["Mega|Ride"] = 955.35, ["Mega|Fly|Ride"] = 905.63}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 21.35, ["Neon"] = 5.25, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 31.4, ["Mega|Ride"] = 143.05, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 28.82, ["Ride"] = 17.59, ["Fly|Ride"] = 45.94, ["Neon"] = 18.38, ["Neon|Ride"] = 24.52, ["Neon|Fly|Ride"] = 71.52, ["Mega"] = 257.25, ["Mega|Ride"] = 192.86, ["Mega|Fly|Ride"] = 228.38}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 63.66, ["Ride"] = 66.94, ["Fly|Ride"] = 258.57, ["Neon"] = 196.88, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 361.53, ["Mega"] = 940.75, ["Mega|Ride"] = 1110.13, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 28.82, ["Fly|Ride"] = 43.32, ["Neon"] = 8.55, ["Neon|Ride"] = 32.81, ["Mega"] = 61.68, ["Mega|Ride"] = 111.46, ["Mega|Fly|Ride"] = 249.26}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 6.42}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 24.47, ["Fly|Ride"] = 123.75, ["Neon"] = 6.39, ["Neon|Ride"] = 40.57, ["Neon|Fly|Ride"] = 114.21, ["Mega"] = 72.19, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 216.79}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 131.08, ["Ride"] = 180.55, ["Fly|Ride"] = 334.99, ["Neon"] = 711.56, ["Neon|Ride"] = 611.23, ["Neon|Fly|Ride"] = 665.05, ["Mega"] = 6403.72, ["Mega|Ride"] = 3214.55, ["Mega|Fly|Ride"] = 2603.43}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 2.1, ["Ride"] = 36.33, ["Fly|Ride"] = 120.48, ["Neon"] = 21.84, ["Neon|Fly"] = 143.03, ["Neon|Ride"] = 64.05, ["Neon|Fly|Ride"] = 219.43, ["Mega"] = 178.39, ["Mega|Ride"] = 207.1, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 26.24, ["Neon"] = 3.94, ["Neon|Ride"] = 24.43, ["Mega"] = 32.45, ["Mega|Fly"] = 65.63, ["Mega|Ride"] = 71.53, ["Mega|Fly|Ride"] = 315.06}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 3.93, ["Fly"] = 39.38, ["Ride"] = 31.5, ["Fly|Ride"] = 65.63, ["Neon"] = 55.95, ["Neon|Ride"] = 88.6, ["Neon|Fly|Ride"] = 153.7, ["Mega"] = 426.93, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 639.39}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 8.57, ["Fly"] = 56.74, ["Ride"] = 21.37, ["Fly|Ride"] = 56.58, ["Neon"] = 72.19, ["Neon|Ride"] = 158.04, ["Neon|Fly|Ride"] = 309.1, ["Mega"] = 619.8, ["Mega|Ride"] = 597.77, ["Mega|Fly|Ride"] = 356.53}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 22.32, ["Ride"] = 59.07, ["Neon"] = 163.85, ["Neon|Ride"] = 189.7, ["Neon|Fly|Ride"] = 1575, ["Mega"] = 561.75, ["Mega|Ride"] = 553.25, ["Mega|Fly|Ride"] = 599.82}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 144.35, ["Fly"] = 177.19, ["Ride"] = 167.88, ["Fly|Ride"] = 249.27, ["Neon"] = 547.8, ["Neon|Fly"] = 683.28, ["Neon|Ride"] = 493.77, ["Neon|Fly|Ride"] = 623.85, ["Mega|Ride"] = 2561.81, ["Mega|Fly|Ride"] = 3214.55}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 5.25, ["Fly"] = 21, ["Ride"] = 17.07, ["Fly|Ride"] = 47.16, ["Neon"] = 41.36, ["Neon|Fly"] = 53.38, ["Neon|Ride"] = 40.6, ["Neon|Fly|Ride"] = 82.69, ["Mega|Ride"] = 341.59, ["Mega|Fly|Ride"] = 416.07}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.1, ["Fly"] = 131.23, ["Ride"] = 24.54, ["Fly|Ride"] = 131.25, ["Neon"] = 18.38, ["Neon|Fly"] = 42.71, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 151.57, ["Mega|Ride"] = 161.53, ["Mega|Fly|Ride"] = 211.51}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 4.29, ["Fly"] = 42.35, ["Ride"] = 40.67, ["Fly|Ride"] = 128.03, ["Neon"] = 47.25, ["Neon|Fly"] = 128.63, ["Neon|Ride"] = 46.77, ["Neon|Fly|Ride"] = 161.48, ["Mega"] = 426.93, ["Mega|Ride"] = 387.85, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 46.67, ["Fly"] = 113.08, ["Ride"] = 78.36, ["Fly|Ride"] = 134.37, ["Neon"] = 202.13, ["Neon|Ride"] = 240.01, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 955.24, ["Mega|Ride"] = 925.32, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 18.38, ["Fly"] = 57.75, ["Ride"] = 131.25, ["Neon"] = 171.47, ["Neon|Ride"] = 219.35, ["Neon|Fly|Ride"] = 470.69, ["Mega"] = 1049.9, ["Mega|Ride"] = 996.98, ["Mega|Fly|Ride"] = 631.59}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 327.51, ["Ride"] = 569.6, ["Neon|Ride"] = 3213.91}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 18.38, ["Fly"] = 39.84, ["Ride"] = 33.55, ["Fly|Ride"] = 69.57, ["Neon"] = 228.3, ["Neon|Ride"] = 212.41, ["Neon|Fly|Ride"] = 321.76, ["Mega"] = 761.25, ["Mega|Ride"] = 738.07, ["Mega|Fly|Ride"] = 996.98}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 42.6, ["Ride"] = 16.02, ["Fly|Ride"] = 39.38, ["Neon"] = 2.1, ["Neon|Ride"] = 18.18, ["Neon|Fly|Ride"] = 53.45, ["Mega"] = 18.09, ["Mega|Fly"] = 111.01, ["Mega|Ride"] = 41.06, ["Mega|Fly|Ride"] = 113.93}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 2.1, ["Ride"] = 41.19, ["Neon"] = 8.54, ["Neon|Ride"] = 42.71, ["Neon|Fly|Ride"] = 143.03, ["Mega"] = 103.49, ["Mega|Ride"] = 164.18, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 2.35, ["Fly"] = 32.13, ["Ride"] = 26.25, ["Fly|Ride"] = 125.89, ["Neon"] = 20.31, ["Neon|Fly"] = 87.94, ["Neon|Ride"] = 48.55, ["Neon|Fly|Ride"] = 1181.23, ["Mega"] = 130.56, ["Mega|Fly"] = 498.44, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 341.92}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 393.74, ["Fly"] = 498.14, ["Ride"] = 393.75, ["Fly|Ride"] = 518.41, ["Neon"] = 1898.49, ["Neon|Ride"] = 2047.06, ["Neon|Fly|Ride"] = 1246.88, ["Mega|Fly|Ride"] = 5507.85}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.1, ["Fly"] = 38.07, ["Ride"] = 16.32, ["Fly|Ride"] = 45.95, ["Neon"] = 16.05, ["Neon|Ride"] = 56.55, ["Neon|Fly|Ride"] = 97.46, ["Mega"] = 196.77, ["Mega|Ride"] = 213.94, ["Mega|Fly|Ride"] = 231}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 3.9, ["Fly"] = 21.35, ["Ride"] = 18.17, ["Fly|Ride"] = 42, ["Neon"] = 27.71, ["Neon|Fly"] = 33.11, ["Neon|Ride"] = 59.78, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 144.62, ["Mega|Ride"] = 289.28, ["Mega|Fly|Ride"] = 276.94}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 2.59, ["Fly"] = 45.71, ["Ride"] = 23.62, ["Fly|Ride"] = 61.25, ["Neon"] = 11.73, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 108.5, ["Mega"] = 131.25, ["Mega|Ride"] = 175.88, ["Mega|Fly|Ride"] = 236.24}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 30.19, ["Fly"] = 48.21, ["Ride"] = 32.82, ["Fly|Ride"] = 65.63, ["Neon"] = 220.4, ["Neon|Ride"] = 196.86, ["Neon|Fly|Ride"] = 319.13, ["Mega"] = 711.89, ["Mega|Ride"] = 853.94, ["Mega|Fly|Ride"] = 629.79}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 53.34, ["Ride"] = 34.13, ["Fly|Ride"] = 51.85, ["Neon"] = 11.59, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 163.74, ["Mega|Ride"] = 457.79, ["Mega|Fly|Ride"] = 1011.29}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 5.24, ["Fly"] = 65.61, ["Ride"] = 28.86, ["Fly|Ride"] = 78.75, ["Neon"] = 168.9, ["Neon|Ride"] = 183.74, ["Mega"] = 530.14, ["Mega|Fly|Ride"] = 774.38}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 21, ["Neon"] = 2.63, ["Neon|Ride"] = 25.83, ["Mega"] = 54.74, ["Mega|Ride"] = 122.83, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 3.94, ["Fly"] = 72.19, ["Ride"] = 142.94, ["Neon"] = 18.09, ["Mega"] = 134.66, ["Mega|Ride"] = 321.83, ["Mega|Fly|Ride"] = 733.69}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 7.88, ["Ride"] = 64.02, ["Neon"] = 64.32, ["Neon|Ride"] = 284.97, ["Mega"] = 314.87, ["Mega|Ride"] = 554.3, ["Mega|Fly|Ride"] = 463.32}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 5.92, ["Fly"] = 32.38, ["Ride"] = 21.91, ["Fly|Ride"] = 39.38, ["Neon"] = 49.87, ["Neon|Fly"] = 114.21, ["Neon|Ride"] = 54.91, ["Neon|Fly|Ride"] = 120.75, ["Mega|Ride"] = 323.54, ["Mega|Fly|Ride"] = 484.81}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 367.5, ["Fly"] = 516.97, ["Ride"] = 433.61, ["Fly|Ride"] = 432.11, ["Neon"] = 1659, ["Neon|Ride"] = 1843.21, ["Neon|Fly|Ride"] = 1640.63}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 15.75, ["Fly|Ride"] = 40.68, ["Neon"] = 35.35, ["Neon|Fly"] = 80.76, ["Neon|Ride"] = 32.28, ["Neon|Fly|Ride"] = 158.17, ["Mega"] = 228.42, ["Mega|Ride"] = 196.77, ["Mega|Fly|Ride"] = 302.55}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 6.57, ["Fly"] = 64.02, ["Ride"] = 63.99, ["Fly|Ride"] = 185.63, ["Neon"] = 57.62, ["Neon|Ride"] = 122.03, ["Neon|Fly|Ride"] = 185.72, ["Mega"] = 305.36, ["Mega|Fly"] = 711.89, ["Mega|Ride"] = 415.8, ["Mega|Fly|Ride"] = 1066.36}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 22.32, ["Fly"] = 87.67, ["Ride"] = 84.62, ["Fly|Ride"] = 320.04, ["Neon"] = 87.26, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 425.86, ["Mega"] = 311.27, ["Mega|Ride"] = 362.25, ["Mega|Fly|Ride"] = 513.24}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 57.63, ["Fly"] = 146.87, ["Ride"] = 90.81, ["Fly|Ride"] = 131.25, ["Neon"] = 321.57, ["Neon|Ride"] = 334.69, ["Neon|Fly|Ride"] = 380.63, ["Mega"] = 2492.09, ["Mega|Ride"] = 1794.55, ["Mega|Fly|Ride"] = 1762.07}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 6.46, ["Ride"] = 37.34, ["Fly|Ride"] = 142.96, ["Neon"] = 26.06, ["Neon|Ride"] = 94.43, ["Neon|Fly|Ride"] = 228.42, ["Mega"] = 170.63, ["Mega|Ride"] = 181.55, ["Mega|Fly|Ride"] = 353.39}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 21.35, ["Ride"] = 19.59, ["Fly|Ride"] = 59.07, ["Neon"] = 18, ["Neon|Ride"] = 33.53, ["Neon|Fly|Ride"] = 130.6, ["Mega"] = 65.62, ["Mega|Ride"] = 192.86, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 3.94, ["Ride"] = 34.15, ["Neon"] = 19.38, ["Neon|Ride"] = 106.74, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 114.19, ["Mega|Fly"] = 242.29, ["Mega|Ride"] = 139.09, ["Mega|Fly|Ride"] = 285.66}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 44.58, ["Fly"] = 137.82, ["Ride"] = 90.57, ["Fly|Ride"] = 170.63, ["Neon"] = 124.69, ["Neon|Ride"] = 146.99, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 439.69, ["Mega|Ride"] = 452.22, ["Mega|Fly|Ride"] = 563.07}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.52, ["Ride"] = 82.72, ["Neon"] = 6.3, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 200.82, ["Mega"] = 45.85, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 283.95}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 21.35, ["Ride"] = 213.35, ["Neon"] = 164.3, ["Neon|Ride"] = 374.07, ["Mega"] = 598.5, ["Mega|Fly|Ride"] = 783.49}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 974.53, ["Fly"] = 1004.07, ["Ride"] = 1006.69, ["Fly|Ride"] = 1095.94, ["Neon|Ride"] = 3541.27, ["Neon|Fly|Ride"] = 3249.17, ["Mega|Fly|Ride"] = 10817.16}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 12.2, ["Fly"] = 39.38, ["Ride"] = 41.89, ["Fly|Ride"] = 173.25, ["Neon"] = 64.31, ["Neon|Fly"] = 710.83, ["Neon|Ride"] = 163.78, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 361.53, ["Mega|Ride"] = 328.27, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.1, ["Fly"] = 49.37, ["Ride"] = 19.68, ["Fly|Ride"] = 90.57, ["Neon"] = 10.96, ["Neon|Ride"] = 32.71, ["Neon|Fly|Ride"] = 90.98, ["Mega"] = 77.35, ["Mega|Ride"] = 80.76, ["Mega|Fly|Ride"] = 183.58}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 8.7, ["Ride"] = 99.75, ["Fly|Ride"] = 142.96, ["Neon"] = 71.49, ["Neon|Fly|Ride"] = 393.73, ["Mega"] = 288.73, ["Mega|Ride"] = 426.21, ["Mega|Fly|Ride"] = 503.84}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 23.15, ["Fly|Ride"] = 185.79, ["Neon"] = 2.63, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 17.75, ["Mega|Ride"] = 47.7, ["Mega|Fly|Ride"] = 134.81}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 51.19, ["Ride"] = 100.69, ["Fly|Ride"] = 236.25, ["Neon"] = 208.58, ["Neon|Ride"] = 255.72, ["Neon|Fly|Ride"] = 405.33, ["Mega"] = 1106.35, ["Mega|Ride"] = 827.68, ["Mega|Fly|Ride"] = 956.82}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 5.25, ["Ride"] = 52.5, ["Fly|Ride"] = 283.87, ["Neon"] = 104.81, ["Neon|Ride"] = 151.86, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 418.69, ["Mega|Ride"] = 805.91, ["Mega|Fly|Ride"] = 723.19}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 8.37, ["Neon|Ride"] = 27.88, ["Neon|Fly|Ride"] = 96.42, ["Mega"] = 96.3, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 370.41}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 14.44, ["Fly"] = 52.5, ["Ride"] = 35.63, ["Fly|Ride"] = 65.63, ["Neon"] = 57.75, ["Neon|Fly"] = 72.19, ["Neon|Ride"] = 91.58, ["Neon|Fly|Ride"] = 263.38, ["Mega"] = 409.17, ["Mega|Ride"] = 405.63, ["Mega|Fly|Ride"] = 392.44}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 6.56, ["Fly"] = 96.02, ["Ride"] = 31.49, ["Fly|Ride"] = 80.73, ["Neon"] = 142.96, ["Neon|Fly"] = 128.96, ["Neon|Ride"] = 80.76, ["Neon|Fly|Ride"] = 144.18, ["Mega"] = 414.6, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 515.88}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 38.06, ["Ride"] = 91.88, ["Neon"] = 249.63, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 682.5, ["Mega"] = 2089.59, ["Mega|Ride"] = 2410.62, ["Mega|Fly|Ride"] = 2132.71}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 3.51, ["Ride"] = 49.08, ["Fly|Ride"] = 255.05, ["Neon"] = 15.44, ["Neon|Ride"] = 78.96, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 57.75, ["Mega|Ride"] = 123.4, ["Mega|Fly|Ride"] = 228.17}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 7.88, ["Ride"] = 21.4, ["Fly|Ride"] = 90.57, ["Neon"] = 45.48, ["Neon|Fly"] = 185.72, ["Neon|Ride"] = 64.47, ["Neon|Fly|Ride"] = 157.98, ["Mega"] = 286.51, ["Mega|Ride"] = 419.46, ["Mega|Fly|Ride"] = 711.98}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 115.38, ["Fly"] = 393.75, ["Ride"] = 136.4, ["Fly|Ride"] = 236.25, ["Neon"] = 420.2, ["Neon|Ride"] = 511.77, ["Neon|Fly|Ride"] = 669.38, ["Mega"] = 2325.63, ["Mega|Ride"] = 2277.87, ["Mega|Fly|Ride"] = 2072.44}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 24.94, ["Ride"] = 16, ["Fly|Ride"] = 31.5, ["Neon"] = 10.49, ["Neon|Fly"] = 57.32, ["Neon|Ride"] = 34, ["Neon|Fly|Ride"] = 80.07, ["Mega"] = 145.69, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 14.43, ["Fly"] = 200.82, ["Ride"] = 41.32, ["Fly|Ride"] = 118.13, ["Neon"] = 86.18, ["Neon|Ride"] = 114.21, ["Neon|Fly|Ride"] = 261.19, ["Mega"] = 454.78, ["Mega|Ride"] = 486.63, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 18.27, ["Ride"] = 14.81, ["Fly|Ride"] = 62.99, ["Neon"] = 2.1, ["Neon|Fly"] = 28.14, ["Neon|Ride"] = 16.83, ["Neon|Fly|Ride"] = 57.64, ["Mega"] = 14.65, ["Mega|Ride"] = 32.57, ["Mega|Fly|Ride"] = 89.21}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 57.62, ["Neon"] = 3.93, ["Neon|Ride"] = 42.71, ["Neon|Fly|Ride"] = 128.09, ["Mega"] = 19.28, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 170.8}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.1, ["Fly"] = 36.28, ["Ride"] = 19.08, ["Fly|Ride"] = 173.25, ["Neon"] = 14.56, ["Neon|Ride"] = 55.55, ["Neon|Fly|Ride"] = 100.34, ["Mega"] = 99.35, ["Mega|Ride"] = 285.02, ["Mega|Fly|Ride"] = 246.1}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 28.88, ["Ride"] = 59.07, ["Fly|Ride"] = 131.25, ["Neon"] = 128.63, ["Neon|Ride"] = 341.55, ["Neon|Fly|Ride"] = 433.13, ["Mega"] = 506.76, ["Mega|Ride"] = 639.39}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.1, ["Fly"] = 15.69, ["Ride"] = 15.73, ["Fly|Ride"] = 34, ["Neon"] = 9.85, ["Neon|Fly"] = 31.31, ["Neon|Ride"] = 30.97, ["Neon|Fly|Ride"] = 61.35, ["Mega"] = 114.35, ["Mega|Fly"] = 267.22, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 145.69}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 9.1, ["Fly"] = 32.5, ["Ride"] = 32.55, ["Fly|Ride"] = 106.68, ["Neon"] = 31.4, ["Neon|Fly"] = 75.16, ["Neon|Ride"] = 49.79, ["Neon|Fly|Ride"] = 102.38, ["Mega"] = 236.15, ["Mega|Fly"] = 433.13, ["Mega|Ride"] = 251.9, ["Mega|Fly|Ride"] = 332.07}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Fly"] = 21.35, ["Ride"] = 14.47, ["Fly|Ride"] = 67.92, ["Neon"] = 11.33, ["Neon|Fly"] = 98.44, ["Neon|Ride"] = 24.86, ["Neon|Fly|Ride"] = 89.24, ["Mega"] = 47.23, ["Mega|Fly"] = 80.76, ["Mega|Ride"] = 58.47, ["Mega|Fly|Ride"] = 128.24}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 9.19, ["Fly"] = 161.07, ["Ride"] = 24.43, ["Fly|Ride"] = 217.2, ["Neon"] = 29.97, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 284.97, ["Mega"] = 292.68, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 392.82, ["Mega|Fly|Ride"] = 413.11}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 5.09, ["Ride"] = 32.82, ["Fly|Ride"] = 142.38, ["Neon"] = 48.77, ["Neon|Ride"] = 143.03, ["Neon|Fly|Ride"] = 257.28, ["Mega"] = 223.12, ["Mega|Ride"] = 303.19, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 6.57, ["Fly"] = 37.7, ["Ride"] = 16.31, ["Fly|Ride"] = 50.82, ["Neon"] = 30.7, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 39.45, ["Neon|Fly|Ride"] = 171.94, ["Mega"] = 262.5, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 296.69, ["Mega|Fly|Ride"] = 570.01}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 24.86, ["Ride"] = 17, ["Fly|Ride"] = 52.41, ["Neon"] = 15.54, ["Neon|Fly"] = 28.84, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 186.79, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 228.38, ["Fly"] = 393.75, ["Ride"] = 255.94, ["Fly|Ride"] = 392.43, ["Neon"] = 1252.84, ["Neon|Ride"] = 1229.18, ["Neon|Fly|Ride"] = 1174.69, ["Mega"] = 4177.94, ["Mega|Fly|Ride"] = 4495.32}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 3.44, ["Ride"] = 65.63, ["Neon"] = 21.29, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 569.94, ["Mega"] = 123.38, ["Mega|Ride"] = 643.64, ["Mega|Fly|Ride"] = 356.53}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 2.1, ["Fly"] = 106.68, ["Ride"] = 24.69, ["Fly|Ride"] = 85.36, ["Neon"] = 29.88, ["Neon|Fly"] = 242.29, ["Neon|Ride"] = 57.64, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 228.9, ["Mega|Ride"] = 194.9, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 3.72, ["Fly|Ride"] = 213.59, ["Neon"] = 36.66, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 603.74, ["Mega"] = 479.73, ["Mega|Ride"] = 402.6, ["Mega|Fly|Ride"] = 416.73}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 16.17, ["Ride"] = 12.75, ["Fly|Ride"] = 32.71, ["Neon"] = 2.1, ["Neon|Fly"] = 42.71, ["Neon|Ride"] = 10.68, ["Neon|Fly|Ride"] = 32.03, ["Mega"] = 18.38, ["Mega|Fly"] = 79, ["Mega|Ride"] = 42.14, ["Mega|Fly|Ride"] = 70.01}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 19.69, ["Fly|Ride"] = 57.75, ["Neon"] = 16.03, ["Neon|Ride"] = 30.17, ["Neon|Fly|Ride"] = 105, ["Mega"] = 132.57, ["Mega|Ride"] = 139.13, ["Mega|Fly|Ride"] = 216.46}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.1, ["Ride"] = 119.85, ["Neon"] = 9.19, ["Neon|Ride"] = 283.91, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 39.38, ["Mega|Ride"] = 167.99, ["Mega|Fly|Ride"] = 276.94}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 72.18, ["Fly"] = 104.99, ["Ride"] = 95.82, ["Fly|Ride"] = 136.49, ["Neon"] = 409.5, ["Neon|Fly"] = 482.04, ["Neon|Ride"] = 368.82, ["Neon|Fly|Ride"] = 426.57, ["Mega|Ride"] = 3559.83, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 3.04, ["Fly"] = 71.48, ["Ride"] = 26.24, ["Fly|Ride"] = 141.73, ["Neon"] = 27.72, ["Neon|Ride"] = 67.48, ["Neon|Fly|Ride"] = 161.48, ["Mega"] = 168, ["Mega|Ride"] = 248.76, ["Mega|Fly|Ride"] = 425.91}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 49.08, ["Ride"] = 34.12, ["Neon"] = 6.45, ["Neon|Ride"] = 80.76, ["Neon|Fly|Ride"] = 143.03, ["Mega"] = 75.83, ["Mega|Fly"] = 314.99, ["Mega|Ride"] = 125.9, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 46.73, ["Fly"] = 131.25, ["Ride"] = 78.75, ["Fly|Ride"] = 199.49, ["Neon"] = 185.63, ["Neon|Ride"] = 195.82, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 492.19, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 668.07}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 28.82, ["Ride"] = 13.13, ["Fly|Ride"] = 24.54, ["Neon"] = 2.1, ["Neon|Fly"] = 21.74, ["Neon|Ride"] = 16.02, ["Neon|Fly|Ride"] = 42.71, ["Mega"] = 20.15, ["Mega|Fly"] = 45.49, ["Mega|Ride"] = 25.6, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 33.73, ["Neon"] = 3.93, ["Neon|Ride"] = 30.08, ["Neon|Fly|Ride"] = 71.52, ["Mega"] = 22.23, ["Mega|Ride"] = 78.65, ["Mega|Fly|Ride"] = 220.5}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 61.97, ["Neon"] = 5.25, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 143.07, ["Mega"] = 36.3, ["Mega|Fly"] = 185.72, ["Mega|Ride"] = 117.29}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 6.56, ["Fly"] = 100.28, ["Ride"] = 45.14, ["Fly|Ride"] = 126.92, ["Neon"] = 20.79, ["Neon|Ride"] = 78.02, ["Neon|Fly|Ride"] = 157.98, ["Mega"] = 125.9, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 184.7, ["Mega|Fly|Ride"] = 314.21}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 21.29, ["Ride"] = 13.8, ["Fly|Ride"] = 37.67, ["Neon"] = 2.1, ["Neon|Fly"] = 24.55, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 48.82, ["Mega"] = 18.27, ["Mega|Ride"] = 42, ["Mega|Fly|Ride"] = 117.48}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 19.16, ["Fly"] = 131.25, ["Ride"] = 52.5, ["Neon"] = 128.62, ["Neon|Ride"] = 202.57, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 708.69, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 771.41}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2507.7, ["Fly"] = 3150, ["Ride"] = 2464.88, ["Fly|Ride"] = 2506.88, ["Neon|Fly|Ride"] = 7415.63, ["Mega|Fly|Ride"] = 44297.56}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 21.35, ["Ride"] = 16.04, ["Fly|Ride"] = 42.69, ["Neon"] = 6.42, ["Neon|Fly"] = 58.52, ["Neon|Ride"] = 23, ["Neon|Fly|Ride"] = 55.28, ["Mega"] = 70.01, ["Mega|Fly"] = 426.93, ["Mega|Ride"] = 94.13, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.1, ["Ride"] = 27.75, ["Neon"] = 8.81, ["Mega"] = 107.01, ["Mega|Fly"] = 441, ["Mega|Ride"] = 161.53, ["Mega|Fly|Ride"] = 446.44}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 13.13, ["Fly"] = 142.94, ["Ride"] = 26.25, ["Fly|Ride"] = 131.25, ["Neon"] = 79.26, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 229.69, ["Mega"] = 567.81, ["Mega|Ride"] = 431.82, ["Mega|Fly|Ride"] = 555.08}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 27.19, ["Fly"] = 106.68, ["Ride"] = 65.99, ["Neon"] = 161.44, ["Neon|Ride"] = 190.32, ["Mega"] = 548.65, ["Mega|Ride"] = 610.57, ["Mega|Fly|Ride"] = 711.98}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 161.69, ["Fly"] = 1422.92, ["Ride"] = 157.4, ["Fly|Ride"] = 264.55, ["Neon"] = 1203.44, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 652.32, ["Mega"] = 6403.72, ["Mega|Fly|Ride"] = 4056.18}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 3.96, ["Ride"] = 65.54, ["Fly|Ride"] = 675.94, ["Neon"] = 22.74, ["Neon|Ride"] = 143.03, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 143.03, ["Mega|Fly|Ride"] = 426.98}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 36.28, ["Neon"] = 13.02, ["Neon|Ride"] = 114.85, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 179.82, ["Mega|Ride"] = 330.65, ["Mega|Fly|Ride"] = 267.09}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Fly"] = 100.43, ["Ride"] = 28.86, ["Fly|Ride"] = 74.69, ["Neon"] = 10.47, ["Neon|Fly"] = 114.21, ["Neon|Ride"] = 31.49, ["Mega"] = 60.51, ["Mega|Ride"] = 113.8, ["Mega|Fly|Ride"] = 203.44}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 10.59, ["Ride"] = 50.74, ["Fly|Ride"] = 131.25, ["Neon"] = 96.32, ["Neon|Ride"] = 175.95, ["Neon|Fly|Ride"] = 502.7, ["Mega"] = 420, ["Mega|Ride"] = 451.53, ["Mega|Fly|Ride"] = 584.73}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 27.77, ["Mega"] = 23.63, ["Mega|Fly"] = 120.51, ["Mega|Ride"] = 91.77, ["Mega|Fly|Ride"] = 135.19}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 90.95, ["Fly"] = 170.68, ["Ride"] = 105, ["Fly|Ride"] = 137.45, ["Neon"] = 301.46, ["Neon|Fly"] = 456.82, ["Neon|Ride"] = 403.31, ["Neon|Fly|Ride"] = 421.31, ["Mega"] = 1215.65, ["Mega|Fly|Ride"] = 1864.61}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Fly"] = 28.82, ["Ride"] = 91.84, ["Fly|Ride"] = 59.07, ["Neon"] = 6.4, ["Neon|Ride"] = 143.03, ["Neon|Fly|Ride"] = 213.47, ["Mega"] = 62.37, ["Mega|Ride"] = 276.29, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 41.89, ["Fly"] = 142.94, ["Ride"] = 85.23, ["Fly|Ride"] = 170.62, ["Neon"] = 255.94, ["Neon|Ride"] = 229.69, ["Neon|Fly|Ride"] = 531.44, ["Mega"] = 2625, ["Mega|Ride"] = 1707.87, ["Mega|Fly|Ride"] = 1850.9}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 21.35, ["Fly|Ride"] = 51.76, ["Neon"] = 3.4, ["Neon|Fly"] = 84.36, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 84, ["Mega"] = 54.57, ["Mega|Ride"] = 103.69, ["Mega|Fly|Ride"] = 144.27}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Neon"] = 10.5, ["Neon|Ride"] = 111.57, ["Mega"] = 49.79, ["Mega|Ride"] = 413.11, ["Mega|Fly|Ride"] = 450.79}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 6.57, ["Fly"] = 77.43, ["Ride"] = 28.82, ["Neon"] = 22.32, ["Neon|Ride"] = 72.45, ["Mega"] = 426.93, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 567.88}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 341.25, ["Fly"] = 498.14, ["Ride"] = 409.5, ["Fly|Ride"] = 490.88, ["Neon"] = 918.75, ["Neon|Ride"] = 980.44, ["Neon|Fly|Ride"] = 1102.5, ["Mega"] = 2756.25, ["Mega|Ride"] = 3037.02, ["Mega|Fly|Ride"] = 2909.73}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 31.4, ["Fly"] = 85.35, ["Ride"] = 45.85, ["Fly|Ride"] = 105.63, ["Neon"] = 183.75, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 276.62, ["Mega|Ride"] = 1131.47, ["Mega|Fly|Ride"] = 1048.22}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 16.02, ["Fly|Ride"] = 111.57, ["Neon"] = 14.44, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 35.75, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 129.94, ["Mega|Ride"] = 262.47, ["Mega|Fly|Ride"] = 314.9}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 24.02, ["Fly"] = 109.01, ["Ride"] = 61.95, ["Fly|Ride"] = 174.95, ["Neon"] = 65.63, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 240.19, ["Mega"] = 310.55, ["Mega|Fly"] = 991.78, ["Mega|Ride"] = 456.82, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 3.94, ["Ride"] = 28.75, ["Neon"] = 101.36, ["Neon|Ride"] = 122.07, ["Neon|Fly|Ride"] = 482.04, ["Mega"] = 393.75, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 311.07}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.8, ["Ride"] = 19.69, ["Neon"] = 23.45, ["Mega"] = 94.5, ["Mega|Ride"] = 285.02, ["Mega|Fly|Ride"] = 413.11}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.1, ["Fly"] = 71.48, ["Ride"] = 20.04, ["Fly|Ride"] = 65.62, ["Neon"] = 18.09, ["Neon|Fly"] = 80.07, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 212.14, ["Mega"] = 210, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 84.34, ["Ride"] = 105, ["Fly|Ride"] = 199.5, ["Neon"] = 796.9, ["Neon|Ride"] = 523.68, ["Neon|Fly|Ride"] = 524.99, ["Mega"] = 2887.5, ["Mega|Ride"] = 2625, ["Mega|Fly|Ride"] = 2973.49}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 18.77, ["Ride"] = 39.38, ["Fly|Ride"] = 131.25, ["Neon"] = 157.38, ["Neon|Ride"] = 170.79, ["Neon|Fly|Ride"] = 314.87, ["Mega"] = 1105.91, ["Mega|Ride"] = 699.09, ["Mega|Fly|Ride"] = 731.07}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2034.38, ["Fly"] = 2311.32, ["Ride"] = 1968.75, ["Fly|Ride"] = 2033.05, ["Neon"] = 11379.3, ["Neon|Fly|Ride"] = 7019.25, ["Mega|Fly|Ride"] = 23622.92}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 3.92, ["Fly"] = 65625, ["Ride"] = 48.67, ["Fly|Ride"] = 196.87, ["Neon"] = 24.86, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 105, ["Mega"] = 116.84, ["Mega|Fly"] = 786.19, ["Mega|Ride"] = 198.86, ["Mega|Fly|Ride"] = 426.98}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 6.57, ["Ride"] = 48.57, ["Fly|Ride"] = 178.17, ["Neon"] = 21.4, ["Neon|Ride"] = 90.46, ["Mega"] = 144.04, ["Mega|Fly"] = 271.1, ["Mega|Ride"] = 164.46, ["Mega|Fly|Ride"] = 252.13}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 826.88, ["Fly"] = 1479.45, ["Ride"] = 894.81, ["Fly|Ride"] = 989.63, ["Neon"] = 2778.57, ["Neon|Ride"] = 2821.88, ["Neon|Fly|Ride"] = 2805.21, ["Mega|Fly|Ride"] = 14794.33}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 24.59, ["Ride"] = 51.19, ["Fly|Ride"] = 173.35, ["Neon"] = 199.5, ["Neon|Ride"] = 176.65, ["Mega"] = 842.71, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 835.42}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 2.1, ["Ride"] = 18.15, ["Fly|Ride"] = 128.15, ["Neon"] = 9.09, ["Neon|Ride"] = 64.84, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 157.48, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 142.94, ["Neon"] = 3.49, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 111.01, ["Mega"] = 23.22, ["Mega|Ride"] = 61.31, ["Mega|Fly|Ride"] = 157.4}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 78.73, ["Ride"] = 130.69, ["Fly|Ride"] = 170.63, ["Neon"] = 459.38, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 634.1, ["Mega"] = 2410.13, ["Mega|Fly|Ride"] = 2262.92}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 2.63, ["Ride"] = 34.15, ["Fly|Ride"] = 74.46, ["Neon"] = 13.12, ["Neon|Ride"] = 35.7, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 105.28, ["Mega|Ride"] = 122.07, ["Mega|Fly|Ride"] = 249.57}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 73.5, ["Fly"] = 142.94, ["Ride"] = 102.08, ["Fly|Ride"] = 242.18, ["Neon"] = 426.72, ["Neon|Ride"] = 721.88, ["Mega|Fly|Ride"] = 1738.06}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 9.19, ["Fly"] = 105, ["Fly|Ride"] = 128.03, ["Neon"] = 58.95, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 269.06, ["Mega"] = 328.02, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 234.94, ["Ride"] = 279.56, ["Fly|Ride"] = 311.97, ["Neon"] = 1148.82, ["Neon|Fly"] = 1044.8, ["Neon|Ride"] = 1061.95, ["Neon|Fly|Ride"] = 879.16, ["Mega|Fly|Ride"] = 3841.62}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 2.52, ["Fly"] = 91.88, ["Ride"] = 25.75, ["Fly|Ride"] = 103.69, ["Neon"] = 29.29, ["Neon|Ride"] = 55.13, ["Neon|Fly|Ride"] = 114.19, ["Mega"] = 196.88, ["Mega|Ride"] = 250.11, ["Mega|Fly|Ride"] = 282.1}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 18.27, ["Ride"] = 15.65, ["Fly|Ride"] = 35.89, ["Neon"] = 3.67, ["Neon|Fly"] = 20.79, ["Neon|Ride"] = 24.55, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 43.41, ["Mega|Fly"] = 74.73, ["Mega|Ride"] = 71.4, ["Mega|Fly|Ride"] = 124.72}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 1223.46, ["Ride"] = 1050, ["Fly|Ride"] = 1254.2, ["Neon|Ride"] = 7827.47, ["Neon|Fly|Ride"] = 6617.17, ["Mega"] = 24101.13, ["Mega|Fly|Ride"] = 28487.82}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 10.4, ["Fly"] = 996.26, ["Ride"] = 72.19, ["Neon"] = 92.26, ["Neon|Ride"] = 311.76, ["Mega"] = 310.71, ["Mega|Ride"] = 404.54, ["Mega|Fly|Ride"] = 564.27}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 6.42, ["Fly"] = 28.82, ["Ride"] = 38.07, ["Fly|Ride"] = 70.19, ["Neon"] = 24.05, ["Neon|Fly"] = 101.4, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 101.88, ["Mega"] = 141.16, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 282.19}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 30.19, ["Fly"] = 44.25, ["Ride"] = 39.38, ["Fly|Ride"] = 76.48, ["Neon"] = 240.94, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 216.56, ["Mega"] = 2561.49, ["Mega|Ride"] = 1125.76, ["Mega|Fly|Ride"] = 779.57}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 15.36, ["Fly"] = 70.42, ["Ride"] = 28.88, ["Fly|Ride"] = 78.75, ["Neon"] = 57.75, ["Neon|Ride"] = 114.21, ["Neon|Fly|Ride"] = 426.93, ["Mega"] = 367.5, ["Mega|Ride"] = 282.19, ["Mega|Fly|Ride"] = 431.61}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 56.02, ["Ride"] = 155.74, ["Fly|Ride"] = 498.14, ["Neon"] = 164.07, ["Neon|Fly"] = 370.36, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 413.06, ["Mega"] = 1054.5, ["Mega|Ride"] = 1010.86, ["Mega|Fly|Ride"] = 1039.68}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 116.61, ["Fly|Ride"] = 284.85, ["Neon"] = 2.62, ["Neon|Fly"] = 57.64, ["Neon|Ride"] = 113.29, ["Neon|Fly|Ride"] = 106.74, ["Mega"] = 16.68, ["Mega|Ride"] = 143.05, ["Mega|Fly|Ride"] = 203.44}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 99.24, ["Fly"] = 137.82, ["Ride"] = 90.57, ["Fly|Ride"] = 169.31, ["Neon"] = 372.75, ["Neon|Fly"] = 490.88, ["Neon|Ride"] = 386.72, ["Neon|Fly|Ride"] = 525, ["Mega"] = 3415.33, ["Mega|Fly|Ride"] = 1763.74}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.1, ["Fly"] = 107.63, ["Ride"] = 19.57, ["Fly|Ride"] = 66.68, ["Neon"] = 198.19, ["Neon|Ride"] = 113.26, ["Mega"] = 773.71, ["Mega|Ride"] = 433.93, ["Mega|Fly|Ride"] = 490.88}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 28.56, ["Ride"] = 18.38, ["Fly|Ride"] = 38.16, ["Neon"] = 20.28, ["Neon|Fly"] = 80.76, ["Neon|Ride"] = 83.27, ["Neon|Fly|Ride"] = 122.85, ["Mega"] = 104.86, ["Mega|Ride"] = 277.86, ["Mega|Fly|Ride"] = 283.5}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 2.1, ["Ride"] = 126, ["Neon"] = 16.02, ["Neon|Fly"] = 140.9, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 212.41}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 64.93, ["Ride"] = 196.88, ["Fly|Ride"] = 223.13, ["Neon"] = 391.13, ["Neon|Ride"] = 426.93, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 1835.75, ["Mega|Ride"] = 1558.44, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 3.94, ["Fly|Ride"] = 426.72, ["Neon"] = 19.09, ["Neon|Ride"] = 59.07, ["Mega"] = 126.88, ["Mega|Ride"] = 161.53, ["Mega|Fly|Ride"] = 285.02}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 37.42, ["Neon"] = 2.1, ["Neon|Ride"] = 118.12, ["Mega"] = 16.94, ["Mega|Ride"] = 204.3, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 102.94, ["Ride"] = 32.02, ["Fly|Ride"] = 143.16, ["Neon"] = 3.94, ["Neon|Fly"] = 86.2, ["Neon|Ride"] = 21.36, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 20.19, ["Mega|Fly"] = 71.52, ["Mega|Ride"] = 42.78, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 17.46, ["Fly|Ride"] = 34.16, ["Neon"] = 5.25, ["Neon|Ride"] = 24.11, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 61.07, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 104.99}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 114.15, ["Neon"] = 24.36, ["Mega"] = 118.11, ["Mega|Ride"] = 114.22, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 38.07, ["Ride"] = 14.44, ["Fly|Ride"] = 40.95, ["Neon"] = 10.08, ["Neon|Fly"] = 85.4, ["Neon|Ride"] = 28.84, ["Neon|Fly|Ride"] = 108.47, ["Mega"] = 170.63, ["Mega|Ride"] = 156.49, ["Mega|Fly|Ride"] = 161.2}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 53.82, ["Ride"] = 101.35, ["Fly|Ride"] = 284.85, ["Neon"] = 229.69, ["Neon|Ride"] = 384.23, ["Neon|Fly|Ride"] = 1067.3, ["Mega"] = 786.19, ["Mega|Ride"] = 723.73, ["Mega|Fly|Ride"] = 1125.76}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 17.06, ["Ride"] = 14.44, ["Fly|Ride"] = 39, ["Neon"] = 2.1, ["Neon|Fly"] = 21.36, ["Neon|Ride"] = 20.29, ["Neon|Fly|Ride"] = 31.5, ["Mega"] = 21.71, ["Mega|Ride"] = 131.09, ["Mega|Fly|Ride"] = 95.82}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 7.88, ["Fly"] = 35.22, ["Ride"] = 27.79, ["Fly|Ride"] = 57.6, ["Neon"] = 34.41, ["Neon|Fly"] = 91.77, ["Neon|Ride"] = 63.63, ["Neon|Fly|Ride"] = 105, ["Mega"] = 301.88, ["Mega|Fly"] = 569.94, ["Mega|Ride"] = 328.02, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 24.94, ["Fly"] = 57.62, ["Ride"] = 40.55, ["Fly|Ride"] = 71.49, ["Neon"] = 105, ["Neon|Fly"] = 147, ["Neon|Ride"] = 103.94, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 787.5, ["Mega|Ride"] = 783.49, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 3.94, ["Fly"] = 196.88, ["Neon"] = 74.82, ["Neon|Ride"] = 103.69, ["Mega"] = 470.69, ["Mega|Ride"] = 412.13, ["Mega|Fly|Ride"] = 533.72}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 19.67, ["Ride"] = 15.75, ["Fly|Ride"] = 32.71, ["Neon"] = 3.47, ["Neon|Fly"] = 28.11, ["Neon|Ride"] = 21.37, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 40.09, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 121.96}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 3.93, ["Fly"] = 39.38, ["Ride"] = 31.5, ["Neon"] = 72.56, ["Neon|Ride"] = 128.09, ["Mega"] = 177.19, ["Mega|Fly"] = 366.1, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 535.85}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 905.63, ["Fly"] = 1286.51, ["Ride"] = 955.49, ["Fly|Ride"] = 1034.15, ["Neon|Ride"] = 2744.44, ["Neon|Fly|Ride"] = 2401.88, ["Mega|Fly|Ride"] = 7116.44}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 173.46, ["Ride"] = 262.5, ["Fly|Ride"] = 392.44, ["Neon"] = 840, ["Neon|Ride"] = 807.19, ["Neon|Fly|Ride"] = 977.82, ["Mega"] = 3200.8, ["Mega|Ride"] = 3559.83, ["Mega|Fly|Ride"] = 2987.71}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Fly|Ride"] = 392.44, ["Neon"] = 6.57, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 255.09, ["Mega"] = 78.32, ["Mega|Fly|Ride"] = 212.43}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 102.77, ["Ride"] = 189, ["Fly|Ride"] = 315, ["Neon"] = 552.21, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 752.21, ["Mega"] = 1978.76, ["Mega|Ride"] = 1907.48, ["Mega|Fly|Ride"] = 1903.13}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 2.21, ["Ride"] = 20.66, ["Fly|Ride"] = 98.44, ["Neon"] = 12.83, ["Neon|Fly"] = 56.65, ["Neon|Ride"] = 56.55, ["Neon|Fly|Ride"] = 284.97, ["Mega"] = 118.13, ["Mega|Ride"] = 242.32, ["Mega|Fly|Ride"] = 361.6}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 227.39, ["Fly"] = 426.68, ["Ride"] = 262.49, ["Fly|Ride"] = 376.69, ["Neon"] = 1144.42, ["Neon|Ride"] = 1408.83, ["Neon|Fly|Ride"] = 1397.88, ["Mega|Fly|Ride"] = 5044.59}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 77.18, ["Ride"] = 41.62, ["Fly|Ride"] = 220.56, ["Neon"] = 23.9, ["Neon|Ride"] = 56.54, ["Mega"] = 321.57, ["Mega|Fly"] = 357.55, ["Mega|Ride"] = 426.98}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Fly"] = 28.82, ["Ride"] = 26.25, ["Neon"] = 43.65, ["Mega"] = 249.38, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 15.86, ["Ride"] = 56.63, ["Fly|Ride"] = 142.96, ["Neon"] = 121.96, ["Neon|Fly"] = 426.93, ["Neon|Ride"] = 98.44, ["Mega"] = 764.57, ["Mega|Ride"] = 828.45, ["Mega|Fly|Ride"] = 853.94}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 49.76, ["Neon"] = 12.83, ["Neon|Ride"] = 196.88, ["Mega"] = 241.02, ["Mega|Ride"] = 256.19, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 16.25, ["Ride"] = 15.61, ["Fly|Ride"] = 32.71, ["Neon"] = 2.63, ["Neon|Fly"] = 20.79, ["Neon|Ride"] = 19.15, ["Neon|Fly|Ride"] = 40.72, ["Mega"] = 25.64, ["Mega|Ride"] = 38.89, ["Mega|Fly|Ride"] = 96.44}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 5020.73, ["Ride"] = 4461.19, ["Fly|Ride"] = 4987.5, ["Neon"] = 32003.24, ["Neon|Fly|Ride"] = 21345.69, ["Mega|Fly|Ride"] = 52500}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 9.68, ["Fly"] = 85.35, ["Ride"] = 41.91, ["Neon"] = 78.75, ["Neon|Ride"] = 106.32, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 203.75, ["Mega|Fly"] = 327.68, ["Mega|Ride"] = 214.85, ["Mega|Fly|Ride"] = 413.11}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 24.7, ["Ride"] = 20.49, ["Fly|Ride"] = 49.79, ["Neon"] = 11.74, ["Neon|Fly"] = 42.71, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 131.25, ["Mega|Ride"] = 138.9, ["Mega|Fly|Ride"] = 206.03}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 387.19, ["Fly"] = 547.77, ["Ride"] = 463.87, ["Fly|Ride"] = 532.86, ["Neon"] = 2100, ["Neon|Ride"] = 1292.82, ["Neon|Fly|Ride"] = 1115.63, ["Mega|Fly|Ride"] = 4873.32}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 2.22, ["Ride"] = 42.97, ["Neon"] = 13.85, ["Neon|Ride"] = 291.38, ["Mega"] = 187.94, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 693}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 3.14, ["Fly"] = 145.69, ["Ride"] = 36.28, ["Neon"] = 131.25, ["Neon|Fly"] = 118.49, ["Neon|Ride"] = 119.31, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 425.86, ["Mega|Ride"] = 285.02, ["Mega|Fly|Ride"] = 740.8}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 51.07, ["Ride"] = 17.09, ["Fly|Ride"] = 65.63, ["Neon"] = 9.07, ["Neon|Fly"] = 124.69, ["Neon|Ride"] = 36.09, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 52.49, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 272.21}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 700.88, ["Fly"] = 868.26, ["Ride"] = 656.25, ["Fly|Ride"] = 672, ["Neon|Ride"] = 2126.27, ["Neon|Fly|Ride"] = 2940}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 10.5, ["Fly"] = 249.38, ["Ride"] = 57.75, ["Neon"] = 31.4, ["Neon|Fly"] = 114.21, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 143.03, ["Mega"] = 194.91, ["Mega|Fly"] = 426.93, ["Mega|Ride"] = 231.67, ["Mega|Fly|Ride"] = 424.83}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 5.92, ["Fly"] = 236.25, ["Ride"] = 45.94, ["Fly|Ride"] = 65.63, ["Neon"] = 23.63, ["Neon|Ride"] = 61.64, ["Neon|Fly|Ride"] = 157.4, ["Mega"] = 162.64, ["Mega|Fly"] = 803.78, ["Mega|Ride"] = 179.64, ["Mega|Fly|Ride"] = 287.44}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 34.13, ["Ride"] = 20.28, ["Fly|Ride"] = 52.57, ["Neon"] = 15.9, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 32.18, ["Neon|Fly|Ride"] = 82.85, ["Mega"] = 284.97, ["Mega|Ride"] = 157.99, ["Mega|Fly|Ride"] = 194.25}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 18.38, ["Ride"] = 51.22, ["Fly|Ride"] = 58.59, ["Neon"] = 117.59, ["Mega"] = 853.84, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 851.81}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 43.31, ["Fly|Ride"] = 80.72, ["Neon"] = 4.2, ["Neon|Ride"] = 49.1, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 20.22, ["Mega|Ride"] = 78.66, ["Mega|Fly|Ride"] = 228.44}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 608.89, ["Fly"] = 725.33, ["Ride"] = 630, ["Fly|Ride"] = 630, ["Neon"] = 2589.57, ["Neon|Ride"] = 2192.22, ["Neon|Fly|Ride"] = 2367.46, ["Mega|Ride"] = 9401.35, ["Mega|Fly|Ride"] = 7861.88}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Neon"] = 11.46, ["Neon|Ride"] = 92.26, ["Neon|Fly|Ride"] = 426.93, ["Mega"] = 87.53, ["Mega|Ride"] = 161.28, ["Mega|Fly|Ride"] = 365.07}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 19.59, ["Neon"] = 4.29, ["Neon|Fly"] = 242.29, ["Neon|Ride"] = 76.85, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 39.38, ["Mega|Ride"] = 137.42, ["Mega|Fly|Ride"] = 285.02}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 60.44, ["Neon"] = 3.64, ["Neon|Ride"] = 41, ["Neon|Fly|Ride"] = 143.03, ["Mega"] = 57.64, ["Mega|Fly"] = 157.98, ["Mega|Ride"] = 125.14, ["Mega|Fly|Ride"] = 143.05}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 11.75, ["Neon|Ride"] = 48.18, ["Mega"] = 213.47, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 26.25, ["Fly"] = 72.19, ["Ride"] = 49.48, ["Fly|Ride"] = 144.37, ["Neon"] = 140.05, ["Neon|Fly"] = 213.47, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 213.47, ["Mega"] = 511.88, ["Mega|Ride"] = 491.03, ["Mega|Fly|Ride"] = 556.36}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 16.02, ["Fly"] = 96.38, ["Ride"] = 55.64, ["Fly|Ride"] = 149.52, ["Neon"] = 84.07, ["Neon|Ride"] = 125.95, ["Neon|Fly|Ride"] = 282.01, ["Mega"] = 512.7, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 575.72}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 16.02, ["Fly|Ride"] = 34.55, ["Neon"] = 36.3, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 88.6, ["Mega"] = 298.6, ["Mega|Ride"] = 285.02, ["Mega|Fly|Ride"] = 335.19}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 7.87, ["Ride"] = 57.03, ["Fly|Ride"] = 134.43, ["Neon"] = 38.05, ["Neon|Ride"] = 91.88}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Ride"] = 26.17, ["Fly|Ride"] = 106.7, ["Neon"] = 11.57, ["Neon|Ride"] = 50.18, ["Neon|Fly|Ride"] = 128.09, ["Mega"] = 69.57, ["Mega|Ride"] = 115.5, ["Mega|Fly|Ride"] = 256.19}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 18.38, ["Fly"] = 113.27, ["Ride"] = 27.26, ["Fly|Ride"] = 57.62, ["Neon"] = 109.15, ["Neon|Ride"] = 85.4, ["Neon|Fly|Ride"] = 289.42, ["Mega"] = 787.5, ["Mega|Fly|Ride"] = 749.34}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 28.82, ["Fly"] = 874.13, ["Neon"] = 98.44, ["Mega"] = 332.06, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 498.5}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 45.94, ["Fly"] = 115.65, ["Ride"] = 81.98, ["Fly|Ride"] = 114.14, ["Neon"] = 324.84, ["Neon|Ride"] = 269.42, ["Neon|Fly|Ride"] = 341.16, ["Mega"] = 1928.11, ["Mega|Ride"] = 1768.18, ["Mega|Fly|Ride"] = 1260.39}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 34.84, ["Fly"] = 128.91, ["Ride"] = 65.63, ["Fly|Ride"] = 131.25, ["Neon"] = 139.13, ["Neon|Ride"] = 142.92, ["Neon|Fly|Ride"] = 291.38, ["Mega"] = 711.89, ["Mega|Ride"] = 768.55, ["Mega|Fly|Ride"] = 654.94}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 15.88, ["Ride"] = 40.55, ["Neon"] = 131.25, ["Neon|Ride"] = 223.12, ["Mega"] = 659.18, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 797.37}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 23.68, ["Fly"] = 81.74, ["Ride"] = 70.88, ["Fly|Ride"] = 235.77, ["Neon"] = 142.83, ["Neon|Fly"] = 256.17, ["Neon|Ride"] = 230.26, ["Neon|Fly|Ride"] = 210, ["Mega"] = 660.24, ["Mega|Ride"] = 601.63, ["Mega|Fly|Ride"] = 693.16}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 18.08, ["Ride"] = 15.67, ["Fly|Ride"] = 32.78, ["Neon"] = 3.42, ["Neon|Fly"] = 27.77, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 57.64, ["Mega"] = 46.41, ["Mega|Fly"] = 321.76, ["Mega|Ride"] = 57.7, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 866.25}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 76.13, ["Fly"] = 481.84, ["Ride"] = 128.64, ["Fly|Ride"] = 330.65, ["Neon"] = 415.8, ["Neon|Ride"] = 458.07, ["Neon|Fly|Ride"] = 555, ["Mega"] = 1417.5, ["Mega|Ride"] = 1515.73, ["Mega|Fly|Ride"] = 1493.54}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 79.76, ["Neon"] = 3.6, ["Neon|Fly"] = 100.34, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 299, ["Mega"] = 26.17, ["Mega|Ride"] = 85.37, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 26.17, ["Ride"] = 64.02, ["Neon"] = 141.65, ["Neon|Ride"] = 135.33, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 591.93, ["Mega|Ride"] = 511.77, ["Mega|Fly|Ride"] = 711.98}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 3.63, ["Neon|Fly|Ride"] = 114.21, ["Mega"] = 25.73, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Ride"] = 74.82, ["Neon"] = 3.81, ["Mega"] = 21.36, ["Mega|Ride"] = 151.89, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 90.3, ["Fly"] = 223.13, ["Ride"] = 143.47, ["Fly|Ride"] = 347.86, ["Neon"] = 433.13, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 645.75, ["Mega|Ride"] = 2687.76, ["Mega|Fly|Ride"] = 2093.44}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 90.57, ["Ride"] = 19.28, ["Fly|Ride"] = 88.47, ["Neon"] = 7.66, ["Neon|Fly"] = 42.71, ["Neon|Ride"] = 32.28, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 91.59, ["Mega|Ride"] = 116.93, ["Mega|Fly|Ride"] = 213.49}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Fly|Ride"] = 57.62, ["Neon"] = 5.25, ["Neon|Fly"] = 42.71, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 419.9, ["Mega"] = 32.8, ["Mega|Ride"] = 128.2, ["Mega|Fly|Ride"] = 217.87}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 72.36, ["Neon"] = 10.49, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 71.52, ["Mega"] = 128.96, ["Mega|Ride"] = 163.13, ["Mega|Fly|Ride"] = 554}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 91.1, ["Neon"] = 7.6, ["Neon|Ride"] = 156.13, ["Mega"] = 91.77, ["Mega|Ride"] = 337.5, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 83.51, ["Ride"] = 184.04, ["Fly|Ride"] = 356.32, ["Neon"] = 428.35, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 2419.55, ["Mega|Ride"] = 2290.09, ["Mega|Fly|Ride"] = 2261.86}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 7.34, ["Ride"] = 93.89, ["Neon"] = 90.92, ["Mega"] = 413.86, ["Mega|Ride"] = 366.19, ["Mega|Fly|Ride"] = 639.29}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 393.75, ["Ride"] = 423.05, ["Fly|Ride"] = 708.36, ["Neon"] = 1050, ["Neon|Ride"] = 1050, ["Neon|Fly|Ride"] = 1113, ["Mega|Fly|Ride"] = 3346.87}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 91.88}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 49.88}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 25.73}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 23.51}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 52.5}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 40.68}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 10.5}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 3.94}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 183.75}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 17.52}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 22.76}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 10.48}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 3.94}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 839.99}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 7.62}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 6.51}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 9.18}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 4.81}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 17.07}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 628.19}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 471.19}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 8.54}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1412.25}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 52.39}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 4.64}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 34.31}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 19.69}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 45.72}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 57.69}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 16.62}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 9.19}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 16.89}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 5.19}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 22.23}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 3.28}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 20.99}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 15.02}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 5.92}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 3062.11}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 51.45}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 315}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 3.61}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 3.61}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 13.89}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 8.81}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 28.88}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 213.88}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 9.19}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 9.19}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 144.38}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 38.07}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 3.89}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 28.83}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 19.68}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 105}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 28.49}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 9.85}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 16.04}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 9.17}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 2.1}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 25.2}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 91.87}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 242.82}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 8.48}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 288.66}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 24.86}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 76.67}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 20.54}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 24008.1}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 124.69}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 57.74}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 37.71}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 26.9}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 45.92}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 23.4}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 31.97}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 87.44}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 81.81}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 26.25}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 99.75}},
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
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 4.29}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 19.67}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 141.61}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.1}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 2.63}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 2.63}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 13.11}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 183.75}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 830.8}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 7.88}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 590.27}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 11.82}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.1}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 231}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 28.62}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 99.63}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 17.06}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 30.18}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 61.34}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 14.82}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 3.94}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 7.49}},
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
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 2.52}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 3.84}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 16.57}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 143.13}},
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
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 13.12}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 10.49}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 5.25}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 25.88}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 7.76}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 3.93}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 7.88}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 5.03}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 6.21}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 31.38}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 11.81}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 5.92}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 2.1}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 7.7}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 14.8}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 2.92}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 5.2}},
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
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 9386.5}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 14.34}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 4.07}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 2.16}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 3.29}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 57.75}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 8.4}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 7.87}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 2.38}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.63}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 6.56}},
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
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4265.54}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 6.36}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 38.07}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.51}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 8.55}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 72.05}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 4.7}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 85.32}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 8.54}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 2.62}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.1}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 6.42}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 11.69}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 23.63}},
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
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 3.73}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 5.24}},
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
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 19.35}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 3.34}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 13.13}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 141.75}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 79.7}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 9.68}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 2.3}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1214.07}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 64.17}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.26}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 3.29}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 31.19}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 27.57}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 5.04}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 9.1}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 15.12}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 13.13}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 13}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 3.29}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 3.56}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 11.66}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 3.2}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 22.37}},
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
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 173.57}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 91.88}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 11.44}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 2.63}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 27.57}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 3.29}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 22.51}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 5.24}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 6.57}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 3.48}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 80.05}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 162.74}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 10.5}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1275.59}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.56}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 196.88}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 5}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 7.35}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 60.38}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 3.59}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 64.97}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 19.69}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 17.9}},
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
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 2.63}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 53.82}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 2.43}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 63}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 4.29}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 37.49}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 114.12}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 82.69}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 6.57}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 63.66}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.62}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 89.42}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 53.61}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 170.68}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 3.86}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 65.58}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 140.2}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 5.24}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 41.58}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 55.13}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 63}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 3.56}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 8.87}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 21.72}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 82.68}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 39.1}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 14.44}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 40.76}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 26.25}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 17.55}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 82.3}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 49.13}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 26.25}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1994.98}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 10.14}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 7.24}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 20.89}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 263.34}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 13.13}},
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
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 49.38}},
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
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 77.44}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 918.75}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 179.82}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 7.88}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 1727.25}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 570.41}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 2.62}},
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