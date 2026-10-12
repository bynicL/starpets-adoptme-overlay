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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 1219.85, ["Ride"] = 1050, ["Fly|Ride"] = 1494.92, ["Neon"] = 6825, ["Neon|Ride"] = 6825, ["Neon|Fly|Ride"] = 5007.53, ["Mega"] = 21406.84, ["Mega|Fly|Ride"] = 21406.84}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 459.38, ["Ride"] = 536.82, ["Fly|Ride"] = 511.88, ["Neon|Fly|Ride"] = 1706.25, ["Mega"] = 10703.42, ["Mega|Fly|Ride"] = 7564.12}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 6562.5, ["Ride"] = 5250, ["Fly|Ride"] = 5117.43, ["Neon|Fly|Ride"] = 17850, ["Mega|Fly|Ride"] = 70785.96}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 183.75, ["Ride"] = 285.93, ["Fly|Ride"] = 315.12, ["Neon"] = 1131.96, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1060.73, ["Mega|Fly|Ride"] = 4790.63}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 544.69, ["Fly"] = 860.57, ["Ride"] = 564.38, ["Fly|Ride"] = 555.18, ["Neon|Ride"] = 1819.37, ["Neon|Fly|Ride"] = 1896.64, ["Mega|Fly|Ride"] = 5993.93}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 11.29, ["Ride"] = 59.06, ["Fly|Ride"] = 129.94, ["Neon"] = 72.19, ["Neon|Fly"] = 285.93, ["Neon|Ride"] = 103.94, ["Neon|Fly|Ride"] = 321.08, ["Mega"] = 353.75, ["Mega|Ride"] = 484.53, ["Mega|Fly|Ride"] = 598.34}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 4.89, ["Fly"] = 43.04, ["Ride"] = 27.17, ["Fly|Ride"] = 69.43, ["Neon"] = 33.22, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 132.57, ["Mega"] = 236.25, ["Mega|Ride"] = 265.46, ["Mega|Fly|Ride"] = 384.27}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 123.37, ["Ride"] = 141.74, ["Neon"] = 569.7, ["Neon|Ride"] = 492.19, ["Neon|Fly|Ride"] = 1425.71, ["Mega"] = 1586.82, ["Mega|Fly"] = 1999.41, ["Mega|Ride"] = 2140.7}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 39.38, ["Fly"] = 53.27, ["Ride"] = 53.82, ["Fly|Ride"] = 106.32, ["Neon"] = 275.63, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 310.16, ["Mega"] = 2100, ["Mega|Ride"] = 1184.88, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 19.56, ["Fly"] = 47.49, ["Ride"] = 36.46, ["Fly|Ride"] = 65.63, ["Neon|Ride"] = 136.5, ["Neon|Fly|Ride"] = 207.38, ["Mega|Ride"] = 779.65, ["Mega|Fly|Ride"] = 856.28}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 78.75, ["Fly"] = 129.1, ["Ride"] = 98.69, ["Fly|Ride"] = 194.25, ["Neon"] = 341.84, ["Neon|Ride"] = 320.25, ["Neon|Fly|Ride"] = 482.3, ["Mega|Fly|Ride"] = 1241.61}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 68.5}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 318.23, ["Fly"] = 341.16, ["Ride"] = 349.13, ["Fly|Ride"] = 380.63, ["Neon|Fly"] = 1428.53, ["Neon|Fly|Ride"] = 1181.24, ["Mega|Fly|Ride"] = 5077.72}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 140.44, ["Fly"] = 165.66, ["Ride"] = 145.69, ["Fly|Ride"] = 159.48, ["Neon"] = 441.16, ["Neon|Fly"] = 630.21, ["Neon|Ride"] = 573.03, ["Neon|Fly|Ride"] = 536.82, ["Mega"] = 4312.63, ["Mega|Fly|Ride"] = 2467.5}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.37, ["Ride"] = 32.82, ["Fly|Ride"] = 131.25, ["Neon"] = 24.91, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 202.73, ["Mega"] = 160.13, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 342.53}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 199.49, ["Fly"] = 287.44, ["Ride"] = 203.69, ["Fly|Ride"] = 234.92, ["Neon|Ride"] = 963.21, ["Neon|Fly|Ride"] = 721.77, ["Mega|Fly|Ride"] = 2749.69}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.26, ["Fly"] = 26.93, ["Ride"] = 18.36, ["Fly|Ride"] = 42, ["Neon"] = 28.87, ["Neon|Fly"] = 81.17, ["Neon|Ride"] = 75.1, ["Neon|Fly|Ride"] = 105, ["Mega"] = 178.5, ["Mega|Ride"] = 258.57, ["Mega|Fly|Ride"] = 422.63}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 126.93, ["Fly"] = 196.88, ["Ride"] = 164.07, ["Fly|Ride"] = 286.79, ["Neon"] = 455.75, ["Neon|Ride"] = 331.67, ["Neon|Fly|Ride"] = 557.12, ["Mega"] = 1776.99, ["Mega|Ride"] = 1484.58, ["Mega|Fly|Ride"] = 1511.34}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 40.61}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 76.13, ["Ride"] = 232.32, ["Fly|Ride"] = 244.02, ["Neon"] = 577.5, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 2140.7, ["Mega|Fly|Ride"] = 4524.22}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 26.41, ["Fly"] = 58.1, ["Ride"] = 50.67, ["Fly|Ride"] = 433.13, ["Neon"] = 244.16, ["Neon|Ride"] = 315.72, ["Neon|Fly|Ride"] = 328.6, ["Mega"] = 571.58, ["Mega|Ride"] = 999.71, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 36.66, ["Fly"] = 78.75, ["Ride"] = 53.69, ["Fly|Ride"] = 110.25, ["Neon"] = 231, ["Neon|Ride"] = 190.31, ["Neon|Fly|Ride"] = 269.21, ["Mega"] = 1695.84, ["Mega|Fly|Ride"] = 993.15}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 46.78, ["Fly"] = 244.63, ["Ride"] = 81.21, ["Fly|Ride"] = 196.88, ["Neon"] = 161.72, ["Neon|Ride"] = 398.13, ["Neon|Fly|Ride"] = 519.75, ["Mega"] = 1967.44, ["Mega|Ride"] = 1337.95, ["Mega|Fly|Ride"] = 1539.16}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 24.94, ["Ride"] = 35.18, ["Fly|Ride"] = 100.68, ["Neon"] = 210, ["Neon|Ride"] = 203.96, ["Neon|Fly|Ride"] = 189, ["Mega"] = 1207.92, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 41.88, ["Fly"] = 144.16, ["Ride"] = 64.32, ["Fly|Ride"] = 129.94, ["Neon"] = 214.18, ["Neon|Fly"] = 404.52, ["Neon|Ride"] = 350.2, ["Neon|Fly|Ride"] = 322.88, ["Mega|Ride"] = 1131.37, ["Mega|Fly|Ride"] = 1039.5}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 7.33, ["Fly"] = 33.86, ["Ride"] = 24.84, ["Fly|Ride"] = 70.79, ["Neon"] = 45.82, ["Neon|Fly"] = 188.5, ["Neon|Ride"] = 49.31, ["Neon|Fly|Ride"] = 91.85, ["Mega"] = 162.41, ["Mega|Fly"] = 28578.13, ["Mega|Ride"] = 189, ["Mega|Fly|Ride"] = 349.02}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 395.01, ["Ride"] = 416.06, ["Fly|Ride"] = 452.82, ["Neon"] = 2107.45, ["Neon|Ride"] = 1575, ["Neon|Fly|Ride"] = 1966.13, ["Mega"] = 10703.42, ["Mega|Fly|Ride"] = 9610.47}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 16.76, ["Ride"] = 32.81, ["Fly|Ride"] = 65.63, ["Neon"] = 219.18, ["Neon|Fly|Ride"] = 280.88, ["Mega|Ride"] = 813.48, ["Mega|Fly|Ride"] = 671.66}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 5.97, ["Fly"] = 61.85, ["Ride"] = 22.09, ["Fly|Ride"] = 50.16, ["Neon"] = 62.99, ["Neon|Ride"] = 71.8, ["Neon|Fly|Ride"] = 130.81, ["Mega"] = 324.05, ["Mega|Ride"] = 328.6, ["Mega|Fly|Ride"] = 378.91}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 81.38, ["Fly"] = 115.12, ["Ride"] = 106.32, ["Fly|Ride"] = 127.88, ["Neon"] = 328.76, ["Neon|Ride"] = 349.98, ["Neon|Fly|Ride"] = 400.32, ["Mega"] = 6418.7, ["Mega|Ride"] = 5832.75, ["Mega|Fly|Ride"] = 2100}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 12.34, ["Fly"] = 26.25, ["Ride"] = 36.43, ["Fly|Ride"] = 71.76, ["Neon"] = 123.16, ["Neon|Ride"] = 115.08, ["Neon|Fly|Ride"] = 209.9, ["Mega"] = 720.57, ["Mega|Ride"] = 565.69, ["Mega|Fly|Ride"] = 722.49}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 216.46, ["Fly"] = 288.75, ["Ride"] = 236.25, ["Fly|Ride"] = 315, ["Neon"] = 571.85, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 726.79, ["Mega"] = 3424.03, ["Mega|Ride"] = 2763.52, ["Mega|Fly|Ride"] = 3149.4}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 23.5}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.63, ["Fly"] = 27.92, ["Ride"] = 22.31, ["Fly|Ride"] = 72.19, ["Neon"] = 24.92, ["Neon|Fly"] = 143.51, ["Neon|Ride"] = 50.63, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 274.02, ["Mega|Fly"] = 342.53, ["Mega|Ride"] = 193.82, ["Mega|Fly|Ride"] = 288.74}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 900.45, ["Fly"] = 2625, ["Ride"] = 918.99, ["Fly|Ride"] = 918.75, ["Neon"] = 6425.11, ["Neon|Ride"] = 4852.36, ["Neon|Fly|Ride"] = 3937.5, ["Mega|Ride"] = 54508.52, ["Mega|Fly|Ride"] = 17767.37}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 13.12, ["Fly"] = 53.58, ["Ride"] = 51.94, ["Fly|Ride"] = 79.26, ["Neon"] = 182.06, ["Neon|Ride"] = 190.32, ["Neon|Fly|Ride"] = 209.81, ["Mega"] = 1036.88, ["Mega|Ride"] = 1099.26, ["Mega|Fly|Ride"] = 820.31}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 242.87, ["Fly"] = 365.18, ["Ride"] = 236.88, ["Fly|Ride"] = 412.07, ["Neon"] = 830.82, ["Neon|Ride"] = 892.5, ["Neon|Fly|Ride"] = 1030.3, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 3899.56}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 38.75}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 16.89, ["Fly"] = 129.1, ["Ride"] = 71.76, ["Fly|Ride"] = 143.51, ["Neon"] = 65.62, ["Neon|Ride"] = 128.62, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 357.52, ["Mega|Ride"] = 576.13, ["Mega|Fly|Ride"] = 599.61}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 110.44, ["Fly"] = 160.61, ["Ride"] = 147, ["Fly|Ride"] = 219.19, ["Neon"] = 641.46, ["Neon|Ride"] = 477.33, ["Neon|Fly|Ride"] = 498.75, ["Mega|Fly|Ride"] = 2372.95}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 103.59, ["Fly"] = 157.5, ["Ride"] = 150.94, ["Fly|Ride"] = 225.48, ["Neon"] = 389.46, ["Neon|Fly"] = 571.85, ["Neon|Ride"] = 426.27, ["Neon|Fly|Ride"] = 496.12, ["Mega|Ride"] = 1466.07, ["Mega|Fly|Ride"] = 1423.77}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 34.13}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 53.82, ["Fly"] = 97.35, ["Ride"] = 58.95, ["Fly|Ride"] = 70.17, ["Neon|Ride"] = 311.07, ["Neon|Fly|Ride"] = 336, ["Mega"] = 4281.38, ["Mega|Fly|Ride"] = 1350.21}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 6.16, ["Fly"] = 101.13, ["Ride"] = 45.94, ["Fly|Ride"] = 157.5, ["Neon"] = 41.24, ["Neon|Fly"] = 223.13, ["Neon|Ride"] = 126.3, ["Neon|Fly|Ride"] = 240.84, ["Mega"] = 189, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 276.94, ["Mega|Fly|Ride"] = 418.51}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 568.32, ["Fly"] = 697.07, ["Ride"] = 493.87, ["Fly|Ride"] = 551.25, ["Neon|Fly"] = 3855.07, ["Neon|Ride"] = 1876.88, ["Neon|Fly|Ride"] = 1870.35, ["Mega|Ride"] = 14984.8, ["Mega|Fly|Ride"] = 7481.25}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 116.67, ["Fly"] = 187.46, ["Ride"] = 131.25, ["Fly|Ride"] = 131.25, ["Neon"] = 420, ["Neon|Ride"] = 485.89, ["Neon|Fly|Ride"] = 713.93, ["Mega|Ride"] = 2568.83, ["Mega|Fly|Ride"] = 2296.88}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 4068.75, ["Ride"] = 3806.25, ["Fly|Ride"] = 3937.5, ["Neon|Fly|Ride"] = 14983.73}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 51.09, ["Fly"] = 131.25, ["Ride"] = 85.31, ["Fly|Ride"] = 170.28, ["Neon"] = 341.25, ["Neon|Ride"] = 289.36, ["Neon|Fly|Ride"] = 292.69, ["Mega"] = 2140.7, ["Mega|Ride"] = 1991.93, ["Mega|Fly|Ride"] = 1866.38}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 52.5, ["Ride"] = 61.69, ["Fly|Ride"] = 147, ["Neon"] = 575.75, ["Neon|Ride"] = 427.88, ["Neon|Fly|Ride"] = 428.15, ["Mega"] = 6279.71, ["Mega|Ride"] = 2388.75, ["Mega|Fly|Ride"] = 2213.61}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 32.7, ["Fly"] = 64.37, ["Ride"] = 43.18, ["Fly|Ride"] = 97.44, ["Neon"] = 152.25, ["Neon|Fly"] = 285.93, ["Neon|Ride"] = 136.66, ["Neon|Fly|Ride"] = 198.09, ["Mega"] = 2625, ["Mega|Ride"] = 889.47, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 5.09}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 75.51, ["Fly"] = 393.75, ["Ride"] = 53.82, ["Fly|Ride"] = 96.97, ["Neon|Ride"] = 285.76, ["Neon|Fly|Ride"] = 599.41, ["Mega|Ride"] = 1292.47, ["Mega|Fly|Ride"] = 1351.86}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 32.75}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 186.67, ["Ride"] = 233.89, ["Fly|Ride"] = 282.19, ["Neon"] = 1142.61, ["Neon|Ride"] = 1140.87, ["Neon|Fly|Ride"] = 1138.87, ["Mega|Fly|Ride"] = 5087.48}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 635.25, ["Fly"] = 817.53, ["Ride"] = 643.13, ["Fly|Ride"] = 720.57, ["Neon"] = 2625, ["Neon|Fly|Ride"] = 3633.92, ["Mega|Fly|Ride"] = 11265.36}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 3.93}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 29.44, ["Fly"] = 47.25, ["Ride"] = 35.6, ["Fly|Ride"] = 69.18, ["Neon"] = 246.75, ["Neon|Fly"] = 339.35, ["Neon|Ride"] = 185.22, ["Neon|Fly|Ride"] = 215.25, ["Mega"] = 2140.7, ["Mega|Ride"] = 1177.46, ["Mega|Fly|Ride"] = 767.81}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 20.98}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5250, ["Fly"] = 7171.65, ["Ride"] = 6424.05, ["Fly|Ride"] = 5055.74, ["Neon|Ride"] = 17764.5, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 43606.82}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 8.99, ["Fly"] = 55.13, ["Ride"] = 25.12, ["Fly|Ride"] = 57.84, ["Neon"] = 76.88, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 149.86, ["Mega"] = 496.79, ["Mega|Ride"] = 490.88, ["Mega|Fly|Ride"] = 466.47}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 12.5, ["Fly"] = 140.94, ["Ride"] = 40.7, ["Fly|Ride"] = 120, ["Neon"] = 126.37, ["Neon|Ride"] = 128.44, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 713.93, ["Mega|Ride"] = 847.72, ["Mega|Fly|Ride"] = 999.71}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 75.36, ["Ride"] = 66.94, ["Fly|Ride"] = 144.38, ["Neon|Ride"] = 397.06, ["Neon|Fly|Ride"] = 485.82, ["Mega"] = 4281.38, ["Mega|Fly|Ride"] = 1776.99}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 8.72, ["Fly"] = 72.09, ["Ride"] = 35.35, ["Fly|Ride"] = 78.75, ["Neon"] = 89.25, ["Neon|Ride"] = 148.32, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 499.87, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 800.63}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1783.69, ["Fly"] = 1992.19, ["Ride"] = 1851.93, ["Fly|Ride"] = 1640.63, ["Neon|Fly|Ride"] = 3281.25, ["Mega|Fly|Ride"] = 12468.75}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 27300, ["Fly"] = 34422.15, ["Ride"] = 33555.13, ["Fly|Ride"] = 24927, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 63000, ["Mega|Fly|Ride"] = 183748.69}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 49.44, ["Fly"] = 393.75, ["Ride"] = 59.06, ["Fly|Ride"] = 128.51, ["Neon"] = 258.57, ["Neon|Ride"] = 208.69, ["Neon|Fly|Ride"] = 571.58, ["Mega"] = 754.69, ["Mega|Ride"] = 1305.94, ["Mega|Fly|Ride"] = 1284.43}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 3.65, ["Fly"] = 129.83, ["Ride"] = 34.63, ["Fly|Ride"] = 199.4, ["Neon"] = 24.18, ["Neon|Fly"] = 143.51, ["Neon|Ride"] = 62.39, ["Neon|Fly|Ride"] = 189.56, ["Mega"] = 194.25, ["Mega|Fly"] = 285.8, ["Mega|Ride"] = 228.38, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 21.81}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 6.24, ["Ride"] = 49.87, ["Fly|Ride"] = 105, ["Neon"] = 85.68, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 143.43, ["Mega"] = 408.89, ["Mega|Ride"] = 484.53, ["Mega|Fly|Ride"] = 756.75}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 567, ["Fly"] = 909.28, ["Ride"] = 712.69, ["Fly|Ride"] = 759.9, ["Neon"] = 3071.06, ["Neon|Ride"] = 2825.38, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 11306.29}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 917.34, ["Fly"] = 1076.15, ["Ride"] = 1030.16, ["Fly|Ride"] = 924, ["Neon"] = 4140.99, ["Neon|Fly|Ride"] = 3109.32, ["Mega|Fly|Ride"] = 11467.39}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 12.79, ["Fly"] = 121.74, ["Ride"] = 30.96, ["Fly|Ride"] = 91.88, ["Neon"] = 85.28, ["Neon|Ride"] = 90.85, ["Neon|Fly|Ride"] = 150.22, ["Mega"] = 496.53, ["Mega|Ride"] = 481.9, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 25.86}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 78.75, ["Fly"] = 89.25, ["Ride"] = 85.31, ["Fly|Ride"] = 126, ["Neon"] = 571.85, ["Neon|Ride"] = 285.76, ["Neon|Fly|Ride"] = 399, ["Mega"] = 19687.5, ["Mega|Ride"] = 1999.41, ["Mega|Fly|Ride"] = 2136.42}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 102.37, ["Ride"] = 91.88, ["Fly|Ride"] = 171.35, ["Neon"] = 420.56, ["Neon|Ride"] = 398.75, ["Neon|Fly|Ride"] = 553.77, ["Mega"] = 1419.78, ["Mega|Ride"] = 1926.63, ["Mega|Fly|Ride"] = 1938.09}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 3.76, ["Fly"] = 30.49, ["Ride"] = 23.02, ["Fly|Ride"] = 52.32, ["Neon"] = 48.49, ["Neon|Fly"] = 524.99, ["Neon|Ride"] = 98.48, ["Neon|Fly|Ride"] = 110.92, ["Mega"] = 315.77, ["Mega|Fly|Ride"] = 571.58}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 150.34, ["Fly"] = 183.75, ["Ride"] = 154.37, ["Fly|Ride"] = 240.62, ["Neon"] = 855.62, ["Neon|Ride"] = 648.37, ["Neon|Fly|Ride"] = 571.58, ["Mega"] = 5137.65, ["Mega|Ride"] = 2907.14, ["Mega|Fly|Ride"] = 2622.36}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 6.56, ["Ride"] = 40.69, ["Fly|Ride"] = 99.75, ["Neon"] = 43.32, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 285.8, ["Mega"] = 234.94, ["Mega|Fly"] = 1137.94, ["Mega|Ride"] = 342.01, ["Mega|Fly|Ride"] = 654.93}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 15.38, ["Fly"] = 65.63, ["Ride"] = 36.66, ["Fly|Ride"] = 89.97, ["Neon"] = 120.75, ["Neon|Ride"] = 150.2, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 646.86, ["Mega|Ride"] = 828.47, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 28.24, ["Ride"] = 68.25, ["Fly|Ride"] = 156.19, ["Neon"] = 213.11, ["Neon|Ride"] = 282.19, ["Mega"] = 997.5, ["Mega|Ride"] = 853.13, ["Mega|Fly|Ride"] = 1011.85}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 16.65, ["Fly"] = 58.1, ["Ride"] = 28.93, ["Fly|Ride"] = 75.22, ["Neon"] = 81.21, ["Neon|Ride"] = 126.3, ["Neon|Fly|Ride"] = 324.33, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6744.94, ["Ride"] = 5250, ["Fly|Ride"] = 5374.69, ["Neon"] = 35695.76, ["Neon|Ride"] = 28875, ["Neon|Fly|Ride"] = 28542.81, ["Mega|Fly|Ride"] = 90444.15}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 244.13, ["Fly"] = 262.5, ["Ride"] = 248.8, ["Fly|Ride"] = 275.63, ["Neon|Fly|Ride"] = 637.88, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 56.44, ["Fly"] = 153.12, ["Ride"] = 93.18, ["Fly|Ride"] = 183.51, ["Neon"] = 164.07, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 207.9, ["Neon|Fly|Ride"] = 321.57, ["Mega"] = 521.07, ["Mega|Ride"] = 587.82, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 90.08, ["Ride"] = 21.19, ["Fly|Ride"] = 81.37, ["Neon"] = 31.5, ["Neon|Fly"] = 85.68, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 499.8, ["Mega|Ride"] = 330.75, ["Mega|Fly|Ride"] = 250.69}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 62.36, ["Fly"] = 213.18, ["Ride"] = 129.12, ["Fly|Ride"] = 157.49, ["Neon"] = 210, ["Neon|Ride"] = 248.12, ["Neon|Fly|Ride"] = 354.38, ["Mega"] = 487.89, ["Mega|Ride"] = 534.18, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 16494.68, ["Ride"] = 13415.07, ["Fly|Ride"] = 11808.56, ["Neon|Fly|Ride"] = 22968.75, ["Mega|Fly|Ride"] = 114170.12}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 287.44, ["Ride"] = 398.35, ["Fly|Ride"] = 459.38, ["Neon|Ride"] = 1566.81, ["Neon|Fly|Ride"] = 3281.25, ["Mega|Fly|Ride"] = 7267.82}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 65.52, ["Fly"] = 80.59, ["Ride"] = 60.47, ["Fly|Ride"] = 113.17, ["Neon"] = 363.6, ["Neon|Ride"] = 328.11, ["Neon|Fly|Ride"] = 324.74, ["Mega|Fly|Ride"] = 2021.25}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 10.4, ["Ride"] = 26.24, ["Fly|Ride"] = 58.47, ["Neon"] = 66.78, ["Neon|Fly"] = 323.6, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 141.3, ["Mega"] = 421.32, ["Mega|Ride"] = 556.6, ["Mega|Fly|Ride"] = 499.87}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 393.74, ["Fly"] = 860.57, ["Ride"] = 433.12, ["Fly|Ride"] = 551.25, ["Neon"] = 1664.12, ["Neon|Ride"] = 1442.44, ["Neon|Fly|Ride"] = 1299.38, ["Mega|Fly|Ride"] = 5232.94}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 8.03, ["Ride"] = 41.95, ["Fly|Ride"] = 199.49, ["Neon"] = 34.04, ["Neon|Ride"] = 128.51, ["Neon|Fly|Ride"] = 222.65, ["Mega"] = 158.81, ["Mega|Fly"] = 263.92, ["Mega|Ride"] = 227.07, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 103.21, ["Fly"] = 167.91, ["Ride"] = 158.82, ["Fly|Ride"] = 191.82, ["Neon"] = 557.5, ["Neon|Fly"] = 525, ["Neon|Ride"] = 488.25, ["Neon|Fly|Ride"] = 522.38, ["Mega|Ride"] = 2369.75, ["Mega|Fly|Ride"] = 2216.59}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 11.54, ["Fly"] = 21.39, ["Ride"] = 19.09, ["Fly|Ride"] = 33.74, ["Neon"] = 114.6, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 108.7, ["Mega"] = 2568.83, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 8.99}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 64.35, ["Ride"] = 87.94, ["Fly|Ride"] = 177.78, ["Neon"] = 353.07, ["Neon|Fly"] = 427.28, ["Neon|Ride"] = 406.87, ["Neon|Fly|Ride"] = 428.1, ["Mega"] = 1570.21, ["Mega|Ride"] = 1997.27, ["Mega|Fly|Ride"] = 1641.92}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 11.79, ["Fly"] = 80.07, ["Ride"] = 35.44, ["Fly|Ride"] = 91.88, ["Neon"] = 98.44, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 209.99, ["Mega"] = 576.93, ["Mega|Ride"] = 577.5, ["Mega|Fly|Ride"] = 646.86}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 38.07}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 72.19, ["Fly"] = 144.16, ["Ride"] = 101.07, ["Fly|Ride"] = 131.25, ["Neon"] = 410.86, ["Neon|Ride"] = 419.99, ["Neon|Fly|Ride"] = 428.15, ["Mega|Fly|Ride"] = 1701.86}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.68, ["Ride"] = 29.23, ["Fly|Ride"] = 137.82, ["Neon"] = 26.66, ["Neon|Ride"] = 135.94, ["Neon|Fly|Ride"] = 256.9, ["Mega"] = 222.65, ["Mega|Fly|Ride"] = 331.42}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 12.2, ["Fly"] = 56.44, ["Ride"] = 41.77, ["Fly|Ride"] = 104.95, ["Neon"] = 81.21, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 202.95, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 534.11}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 431.82, ["Fly"] = 537.87, ["Ride"] = 500.11, ["Fly|Ride"] = 545.39, ["Neon|Fly|Ride"] = 2781.5, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 32.45, ["Fly"] = 107.59, ["Ride"] = 52.41, ["Fly|Ride"] = 99.71, ["Neon"] = 129.94, ["Neon|Ride"] = 143.42, ["Neon|Fly|Ride"] = 340.38, ["Mega"] = 776.43, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 717.84}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 40.15, ["Fly"] = 144.16, ["Ride"] = 72.19, ["Fly|Ride"] = 143.51, ["Neon"] = 236.25, ["Neon|Ride"] = 163.94, ["Neon|Fly|Ride"] = 315, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 19.41, ["Fly"] = 110.38, ["Ride"] = 58.94, ["Fly|Ride"] = 110.23, ["Neon"] = 97.34, ["Neon|Ride"] = 143.06, ["Neon|Fly|Ride"] = 242.99, ["Mega"] = 379.99, ["Mega|Fly"] = 525, ["Mega|Ride"] = 492.37, ["Mega|Fly|Ride"] = 578.01}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 10500, ["Ride"] = 8862, ["Fly|Ride"] = 8186.07, ["Neon|Fly|Ride"] = 13831.23, ["Mega|Fly|Ride"] = 38850}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1506.75, ["Fly"] = 1501.85, ["Ride"] = 1481.29, ["Fly|Ride"] = 1437.19, ["Neon|Fly|Ride"] = 4314.92, ["Mega|Fly|Ride"] = 24261.44}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 730.34, ["Ride"] = 775.65, ["Fly|Ride"] = 721.66, ["Neon"] = 2253.58, ["Neon|Fly|Ride"] = 3084.38, ["Mega"] = 21406.84, ["Mega|Fly|Ride"] = 9975}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 11.42, ["Fly"] = 24.36, ["Ride"] = 23.64, ["Fly|Ride"] = 45.94, ["Neon"] = 136.5, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 128.45, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 577.49}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 3.18, ["Fly"] = 52.5, ["Ride"] = 31.44, ["Fly|Ride"] = 131.25, ["Neon"] = 24.94, ["Neon|Ride"] = 56.11, ["Mega"] = 216.72, ["Mega|Ride"] = 200.42, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 32.97, ["Fly"] = 85.31, ["Ride"] = 46.75, ["Fly|Ride"] = 102.15, ["Neon"] = 545.39, ["Neon|Ride"] = 150.94, ["Neon|Fly|Ride"] = 152.77, ["Mega|Fly|Ride"] = 666.75}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 2.1, ["Fly"] = 23.5, ["Ride"] = 17.07, ["Fly|Ride"] = 41.94, ["Neon"] = 29.54, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 48.57, ["Neon|Fly|Ride"] = 101.06, ["Mega"] = 320.04, ["Mega|Ride"] = 774.38, ["Mega|Fly|Ride"] = 275.62}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 306.51, ["Fly"] = 369.5, ["Ride"] = 310.92, ["Fly|Ride"] = 353.07, ["Neon"] = 1114.99, ["Neon|Ride"] = 1442.66, ["Neon|Fly|Ride"] = 1199.2, ["Mega|Fly|Ride"] = 4436.11}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 21, ["Fly"] = 60.6, ["Ride"] = 42, ["Fly|Ride"] = 89.71, ["Neon"] = 131.25, ["Neon|Fly"] = 407.29, ["Neon|Ride"] = 174.5, ["Neon|Fly|Ride"] = 220.52, ["Mega"] = 856.28, ["Mega|Fly"] = 904.86, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 646.86}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 10.12, ["Fly"] = 22.92, ["Ride"] = 21.41, ["Fly|Ride"] = 40.74, ["Neon"] = 83.54, ["Neon|Fly"] = 121.03, ["Neon|Ride"] = 81.17, ["Neon|Fly|Ride"] = 107.43, ["Mega"] = 1575, ["Mega|Ride"] = 610.51, ["Mega|Fly|Ride"] = 423.94}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 637.84, ["Fly"] = 1048.69, ["Ride"] = 571.85, ["Fly|Ride"] = 637.81, ["Neon|Fly|Ride"] = 3569.61, ["Mega|Fly|Ride"] = 9971.07}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1050, ["Fly"] = 1434.99, ["Ride"] = 1214.07, ["Fly|Ride"] = 1181.24, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 13271.18}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 101.07, ["Fly"] = 144.16, ["Ride"] = 90.57, ["Fly|Ride"] = 107.34, ["Neon"] = 971.25, ["Neon|Ride"] = 588.63, ["Neon|Fly|Ride"] = 481.67, ["Mega|Fly|Ride"] = 2818.71}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 200.82, ["Fly"] = 210, ["Ride"] = 216.46, ["Fly|Ride"] = 210, ["Neon|Ride"] = 571.51, ["Neon|Fly|Ride"] = 713.93, ["Mega|Ride"] = 9187.5, ["Mega|Fly|Ride"] = 2598.75}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 24.86, ["Fly"] = 58.1, ["Ride"] = 36.43, ["Fly|Ride"] = 114.6, ["Neon"] = 236.25, ["Neon|Ride"] = 238.13, ["Mega|Ride"] = 2140.7, ["Mega|Fly|Ride"] = 1084.13}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 328.13, ["Ride"] = 428.36, ["Fly|Ride"] = 428.36, ["Neon"] = 1220.63, ["Neon|Fly"] = 969.56, ["Neon|Fly|Ride"] = 1284.43, ["Mega|Fly|Ride"] = 5709.21}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 1968.75, ["Fly"] = 2438.61, ["Ride"] = 1962.19, ["Fly|Ride"] = 2029.07, ["Neon|Fly|Ride"] = 10703.42, ["Mega|Fly|Ride"] = 36339.01}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 57.65, ["Fly"] = 215.15, ["Ride"] = 49.88, ["Fly|Ride"] = 196.88, ["Neon"] = 214.18, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 343.88, ["Mega"] = 1427.86, ["Mega|Ride"] = 1142.08, ["Mega|Fly|Ride"] = 1259.99}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 626.07, ["Fly"] = 737.93, ["Ride"] = 603.75, ["Fly|Ride"] = 617.21, ["Neon|Ride"] = 1498.88, ["Neon|Fly|Ride"] = 1283.63, ["Mega|Fly|Ride"] = 3709.82}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 43.22, ["Fly"] = 70.88, ["Ride"] = 62.35, ["Fly|Ride"] = 91.83, ["Neon"] = 262.5, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 259.88, ["Mega|Ride"] = 1070.36, ["Mega|Fly|Ride"] = 1127.73}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 2.63, ["Fly"] = 40.98, ["Ride"] = 21.55, ["Fly|Ride"] = 64.29, ["Neon"] = 25.17, ["Neon|Fly"] = 110.25, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 97.46, ["Mega"] = 179.82, ["Mega|Ride"] = 187.19, ["Mega|Fly|Ride"] = 296.26}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 61.69, ["Ride"] = 129.69, ["Fly|Ride"] = 157.5, ["Neon"] = 275.52, ["Neon|Ride"] = 481.47, ["Neon|Fly|Ride"] = 428.15, ["Mega"] = 1566.99, ["Mega|Ride"] = 1712.55, ["Mega|Fly|Ride"] = 1698.65}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 907.39, ["Ride"] = 965.16, ["Fly|Ride"] = 937.13, ["Neon|Ride"] = 3270.01, ["Neon|Fly|Ride"] = 3064.69, ["Mega|Fly|Ride"] = 13129.9}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 714, ["Ride"] = 861.71, ["Fly|Ride"] = 921.08, ["Neon|Fly|Ride"] = 4280.31, ["Mega|Fly|Ride"] = 15554.21}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 19.45, ["Fly"] = 24.2, ["Ride"] = 23.78, ["Fly|Ride"] = 36.28, ["Neon"] = 144.38, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 785.65, ["Mega|Fly|Ride"] = 722.52}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 15.3, ["Ride"] = 36.43, ["Fly|Ride"] = 118.88, ["Neon"] = 165.38, ["Neon|Ride"] = 148.66, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 999.71, ["Mega|Ride"] = 940.85, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 4.02, ["Fly"] = 59.2, ["Ride"] = 55.7, ["Fly|Ride"] = 214.18, ["Neon"] = 23.23, ["Neon|Fly"] = 323.6, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 229.07, ["Mega"] = 196.88, ["Mega|Fly"] = 565.69, ["Mega|Ride"] = 281.3, ["Mega|Fly|Ride"] = 481.69}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 42.69, ["Fly"] = 51.97, ["Ride"] = 51.17, ["Fly|Ride"] = 120.73, ["Neon"] = 315.92, ["Neon|Ride"] = 162.59, ["Neon|Fly|Ride"] = 240.38, ["Mega|Ride"] = 892.68, ["Mega|Fly|Ride"] = 1067.17}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 91.87, ["Ride"] = 143.51, ["Fly|Ride"] = 357.69, ["Neon"] = 413.44, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 2426.48, ["Mega|Fly|Ride"] = 2284.13}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 11.81, ["Fly"] = 52.41, ["Ride"] = 32.82, ["Fly|Ride"] = 76.13, ["Neon"] = 80.33, ["Neon|Ride"] = 98.43, ["Neon|Fly|Ride"] = 203.44, ["Mega"] = 429.7, ["Mega|Ride"] = 330.51, ["Mega|Fly|Ride"] = 515.82}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 37.7, ["Fly"] = 52.5, ["Ride"] = 44.61, ["Fly|Ride"] = 111.57, ["Neon"] = 240.38, ["Neon|Ride"] = 208.69, ["Neon|Fly|Ride"] = 236.7, ["Mega"] = 2100, ["Mega|Fly|Ride"] = 1278}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 2.24, ["Fly"] = 37.96, ["Ride"] = 17.85, ["Fly|Ride"] = 45.62, ["Neon"] = 28.8, ["Neon|Ride"] = 59.95, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 434.74, ["Mega|Ride"] = 397.1, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 5.77, ["Fly"] = 64.56, ["Ride"] = 44.46, ["Fly|Ride"] = 88.92, ["Neon"] = 52.4, ["Neon|Fly"] = 114.19, ["Neon|Ride"] = 68.25, ["Neon|Fly|Ride"] = 229.07, ["Mega"] = 416.07, ["Mega|Ride"] = 420.34, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 36.75, ["Fly"] = 71.46, ["Ride"] = 49.75, ["Fly|Ride"] = 102.12, ["Neon"] = 578.43, ["Neon|Ride"] = 328.57, ["Neon|Fly|Ride"] = 272.54, ["Mega|Fly|Ride"] = 1074.92}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1443.74, ["Fly"] = 1367.63, ["Ride"] = 1389.93, ["Fly|Ride"] = 1470, ["Neon"] = 4484.17, ["Neon|Ride"] = 4844.44, ["Neon|Fly|Ride"] = 3621.19, ["Mega|Fly|Ride"] = 12576.37}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 467.76, ["Fly"] = 524.99, ["Ride"] = 459.38, ["Fly|Ride"] = 493.96, ["Neon|Ride"] = 3710.44, ["Neon|Fly|Ride"] = 2362.5, ["Mega"] = 14984.8}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 260.99, ["Fly"] = 378.23, ["Ride"] = 325.5, ["Fly|Ride"] = 439.69, ["Neon"] = 1575, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 7706.47}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 38.06}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 32.34, ["Ride"] = 51.28, ["Fly|Ride"] = 99.74, ["Neon"] = 321.26, ["Neon|Ride"] = 162.31, ["Neon|Fly|Ride"] = 393.75, ["Mega|Ride"] = 1712.55, ["Mega|Fly|Ride"] = 1036.54}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 70875, ["Fly"] = 26892.3, ["Ride"] = 36357.99, ["Fly|Ride"] = 18850.17, ["Neon|Fly|Ride"] = 38061.19, ["Mega"] = 214068.26, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 220.62, ["Fly"] = 284.44, ["Ride"] = 245.34, ["Fly|Ride"] = 341.84, ["Neon"] = 1039.98, ["Neon|Ride"] = 1014.21, ["Neon|Fly|Ride"] = 924.28, ["Mega"] = 6422.07, ["Mega|Fly|Ride"] = 4066.25}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 177.19, ["Fly"] = 525, ["Ride"] = 249.38, ["Fly|Ride"] = 257.27}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 129.1, ["Fly"] = 157.5, ["Ride"] = 144.37, ["Fly|Ride"] = 169.59, ["Neon"] = 566.12, ["Neon|Ride"] = 523.69, ["Neon|Fly|Ride"] = 630, ["Mega|Ride"] = 3569.61, ["Mega|Fly|Ride"] = 2994.83}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 13.1, ["Fly"] = 64.56, ["Ride"] = 26.25, ["Fly|Ride"] = 85.68, ["Neon"] = 162.42, ["Neon|Ride"] = 113.87, ["Neon|Fly|Ride"] = 229.07, ["Mega"] = 724.38, ["Mega|Ride"] = 484.53, ["Mega|Fly|Ride"] = 856.28}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 3937.5, ["Ride"] = 3937.5, ["Fly|Ride"] = 4068.75, ["Neon"] = 21417.02, ["Neon|Fly|Ride"] = 15750}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 17.07, ["Fly"] = 41.9, ["Ride"] = 34.12, ["Fly|Ride"] = 58.56, ["Neon"] = 131.25, ["Neon|Ride"] = 212.99, ["Neon|Fly|Ride"] = 173.13, ["Mega|Ride"] = 1427.86, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 37.68, ["Ride"] = 51.17, ["Fly|Ride"] = 104.56, ["Neon"] = 159.97, ["Neon|Fly"] = 1428.53, ["Neon|Ride"] = 202.79, ["Neon|Fly|Ride"] = 262.5, ["Mega|Fly|Ride"] = 1391.46}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 471.9, ["Fly"] = 563.07, ["Ride"] = 472.5, ["Fly|Ride"] = 572.09, ["Neon"] = 1312.5, ["Neon|Ride"] = 1226.91, ["Neon|Fly|Ride"] = 1391.25, ["Mega|Fly|Ride"] = 5281.08}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 16.15, ["Fly"] = 28.76, ["Ride"] = 24.05, ["Fly|Ride"] = 38.99, ["Neon"] = 131.24, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 157.39, ["Mega|Ride"] = 614.14, ["Mega|Fly|Ride"] = 582.67}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 14.24, ["Ride"] = 34.54, ["Fly|Ride"] = 83.54, ["Neon"] = 129.94, ["Neon|Ride"] = 143.42, ["Neon|Fly|Ride"] = 211.21, ["Mega"] = 565.69, ["Mega|Ride"] = 751.03, ["Mega|Fly|Ride"] = 571.58}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 103.28, ["Ride"] = 105, ["Fly|Ride"] = 243.1, ["Neon"] = 727.18, ["Neon|Ride"] = 637.79, ["Neon|Fly|Ride"] = 1557.35, ["Mega|Fly|Ride"] = 2422.62}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 19.59, ["Fly"] = 103.69, ["Ride"] = 70.45, ["Fly|Ride"] = 484.79, ["Neon"] = 84.42, ["Neon|Fly"] = 118.88, ["Neon|Ride"] = 162.31, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 393.75, ["Mega|Fly"] = 487.1, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 488.92}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 4200, ["Fly"] = 6265.04, ["Ride"] = 4246.12, ["Fly|Ride"] = 4173.75, ["Neon"] = 19687.5, ["Neon|Ride"] = 12337.5, ["Neon|Fly|Ride"] = 10421.25, ["Mega"] = 48522.87, ["Mega|Fly|Ride"] = 37945.69}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 39.37, ["Fly"] = 144.16, ["Ride"] = 65.54, ["Fly|Ride"] = 144.38, ["Neon"] = 164.07, ["Neon|Ride"] = 258.57, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 856.28, ["Mega|Ride"] = 855.22, ["Mega|Fly|Ride"] = 784.88}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 6300, ["Fly"] = 7637.42, ["Ride"] = 6857.82, ["Fly|Ride"] = 6483.75, ["Neon|Fly|Ride"] = 15225, ["Mega|Fly|Ride"] = 46921.88}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.37, ["Fly"] = 19.69, ["Ride"] = 17.13, ["Fly|Ride"] = 38.07, ["Neon"] = 24.19, ["Neon|Fly"] = 62.62, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 80.07, ["Mega"] = 196.88, ["Mega|Ride"] = 372.75, ["Mega|Fly|Ride"] = 259.24}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 18.25, ["Fly"] = 31.5, ["Ride"] = 38.75, ["Fly|Ride"] = 56.44, ["Neon"] = 186.34, ["Neon|Fly"] = 236.67, ["Neon|Ride"] = 499.8, ["Neon|Fly|Ride"] = 167.99, ["Mega|Ride"] = 998.17, ["Mega|Fly|Ride"] = 999.71}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.93}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 11.21, ["Ride"] = 26.74, ["Fly|Ride"] = 87.02, ["Neon"] = 78.36, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 1050, ["Mega|Ride"] = 1068.21, ["Mega|Fly|Ride"] = 803.84}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 22.3, ["Fly"] = 190.37, ["Ride"] = 46.27, ["Fly|Ride"] = 171.35, ["Neon"] = 203.44, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 945, ["Mega|Ride"] = 856.28, ["Mega|Fly|Ride"] = 1099.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 15.73, ["Fly"] = 28.88, ["Ride"] = 20.96, ["Fly|Ride"] = 41.79, ["Neon|Fly"] = 1067.01, ["Neon|Ride"] = 113.46, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 2568.83, ["Mega|Fly|Ride"] = 599.41}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8749.69}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2625}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 22.31}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 243.08, ["Ride"] = 393.02, ["Fly|Ride"] = 315}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 15.94, ["Fly"] = 144.16, ["Ride"] = 31.5, ["Fly|Ride"] = 143.51, ["Neon"] = 118.34, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 265.13, ["Mega"] = 438.85, ["Mega|Ride"] = 534.19, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 11.82}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 6.35, ["Ride"] = 24.69, ["Fly|Ride"] = 85.68, ["Neon|Ride"] = 249.38, ["Mega"] = 1570.21}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2357.25}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 170.52, ["Fly"] = 430.29, ["Ride"] = 262.5, ["Fly|Ride"] = 367.5, ["Neon"] = 1000.19, ["Neon|Ride"] = 968.89, ["Neon|Fly|Ride"] = 779.22, ["Mega|Ride"] = 4139.03, ["Mega|Fly|Ride"] = 3936.45}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 63.56, ["Fly"] = 196.88, ["Ride"] = 101.75, ["Fly|Ride"] = 257.01, ["Neon"] = 315, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 942.98, ["Mega|Ride"] = 1855.98, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 171.3, ["Fly"] = 274.32, ["Ride"] = 183.75, ["Fly|Ride"] = 250.87, ["Neon"] = 944.99, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 822.81, ["Mega|Fly|Ride"] = 3520.55}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 2488.5, ["Fly"] = 3101.48, ["Ride"] = 2455.69, ["Fly|Ride"] = 2730, ["Neon"] = 15041.18, ["Neon|Ride"] = 9688.86, ["Neon|Fly|Ride"] = 8017.66, ["Mega|Fly|Ride"] = 27116.04}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 21.39, ["Fly"] = 183.96, ["Ride"] = 54.11, ["Fly|Ride"] = 114.6, ["Neon"] = 121.21, ["Neon|Fly"] = 162.42, ["Neon|Ride"] = 156.19, ["Neon|Fly|Ride"] = 242.95, ["Mega"] = 962.26, ["Mega|Ride"] = 999.71, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 674.47, ["Fly"] = 2100, ["Ride"] = 803.55, ["Fly|Ride"] = 867.18, ["Neon|Fly|Ride"] = 4280.31}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 41.98}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 19.04, ["Ride"] = 51.41, ["Fly|Ride"] = 74.97, ["Neon"] = 94.5, ["Neon|Ride"] = 137.06, ["Neon|Fly|Ride"] = 165.92, ["Mega"] = 444.94, ["Mega|Fly"] = 969.05, ["Mega|Ride"] = 514.56, ["Mega|Fly|Ride"] = 700.87}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 7.66, ["Fly"] = 49.06, ["Ride"] = 27.98, ["Fly|Ride"] = 128.51, ["Neon"] = 65.62, ["Neon|Fly"] = 315, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 453.04, ["Mega|Ride"] = 268.67, ["Mega|Fly|Ride"] = 571.58}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 58.97}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 16.95, ["Fly"] = 110.81, ["Ride"] = 32.28, ["Fly|Ride"] = 100.68, ["Neon|Ride"] = 193.79, ["Neon|Fly|Ride"] = 254.63, ["Mega|Ride"] = 1070.36, ["Mega|Fly|Ride"] = 2140.7}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 29.97, ["Fly"] = 45.94, ["Ride"] = 42, ["Fly|Ride"] = 70.88, ["Neon|Fly"] = 236.67, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 284.72, ["Mega"] = 1427.86, ["Mega|Ride"] = 1816.97, ["Mega|Fly|Ride"] = 989.63}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6518.71, ["Fly"] = 10237.5, ["Ride"] = 6424.05, ["Fly|Ride"] = 5053.13, ["Neon|Fly|Ride"] = 9975, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 8.58, ["Fly"] = 61.11, ["Ride"] = 33.39, ["Fly|Ride"] = 81.38, ["Neon"] = 55.11, ["Neon|Ride"] = 85.22, ["Neon|Fly|Ride"] = 184.72, ["Mega"] = 354.38, ["Mega|Ride"] = 288.74, ["Mega|Fly|Ride"] = 546}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 19.69}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 84.2, ["Fly"] = 380.81, ["Ride"] = 125.99, ["Fly|Ride"] = 131.25, ["Neon"] = 374.07, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 535.48, ["Mega"] = 2879.59, ["Mega|Ride"] = 1764.77, ["Mega|Fly|Ride"] = 2568.83}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 50.39, ["Fly"] = 75.31, ["Ride"] = 77.85, ["Fly|Ride"] = 190.32, ["Neon"] = 262.5, ["Neon|Fly"] = 363.6, ["Neon|Ride"] = 288.75, ["Neon|Fly|Ride"] = 457.94, ["Mega"] = 2422.62, ["Mega|Ride"] = 2889.93, ["Mega|Fly|Ride"] = 1046.07}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 24.86, ["Fly"] = 72.18, ["Ride"] = 31.24, ["Fly|Ride"] = 76.01, ["Neon"] = 129.69, ["Neon|Fly"] = 231.18, ["Neon|Ride"] = 143.42, ["Neon|Fly|Ride"] = 178.5, ["Mega"] = 1016.21, ["Mega|Ride"] = 807.95, ["Mega|Fly|Ride"] = 800.62}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 6.57, ["Fly"] = 77.07, ["Ride"] = 27.22, ["Fly|Ride"] = 112.59, ["Neon"] = 25.45, ["Neon|Ride"] = 82.69, ["Neon|Fly|Ride"] = 150.94, ["Mega"] = 164.06, ["Mega|Fly"] = 7135.98, ["Mega|Ride"] = 221.8, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 13.39, ["Fly"] = 144.16, ["Ride"] = 27.27, ["Fly|Ride"] = 98.06, ["Neon"] = 123.98, ["Neon|Ride"] = 111.56, ["Neon|Fly|Ride"] = 218.29, ["Mega"] = 570.94, ["Mega|Ride"] = 646.86, ["Mega|Fly|Ride"] = 683.96}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 20.47, ["Fly"] = 28.4, ["Ride"] = 28.04, ["Fly|Ride"] = 55.38, ["Neon"] = 126.37, ["Neon|Fly"] = 144.38, ["Neon|Ride"] = 114.53, ["Neon|Fly|Ride"] = 144.38, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 196.86}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 21.53, ["Fly"] = 101.13, ["Ride"] = 131.25, ["Fly|Ride"] = 285.93, ["Neon"] = 170.62, ["Neon|Ride"] = 211.92, ["Neon|Fly|Ride"] = 301.88, ["Mega"] = 866.25, ["Mega|Fly|Ride"] = 678.57}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 328.13, ["Ride"] = 1428.53, ["Neon|Fly|Ride"] = 28542.81}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 72.09, ["Fly"] = 215.15, ["Ride"] = 88.31, ["Fly|Ride"] = 193.92, ["Neon"] = 275.63, ["Neon|Ride"] = 328.57, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 1065, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1358.18}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 1049.99, ["Fly"] = 1378.13, ["Ride"] = 1039.5, ["Fly|Ride"] = 1050, ["Neon|Fly"] = 4395.69, ["Neon|Ride"] = 4338.67, ["Neon|Fly|Ride"] = 3281.25, ["Mega|Fly|Ride"] = 13125}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 337.84, ["Fly"] = 717.5, ["Ride"] = 413.32, ["Fly|Ride"] = 498.75, ["Neon"] = 2388.75, ["Neon|Ride"] = 3140.02, ["Neon|Fly|Ride"] = 1855.98, ["Mega"] = 12844.12, ["Mega|Fly|Ride"] = 9448.69}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 58.42}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.63}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 12.35, ["Fly"] = 31.4, ["Ride"] = 25.41, ["Fly|Ride"] = 57.84, ["Neon"] = 78.75, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 81.46, ["Neon|Fly|Ride"] = 137.75, ["Mega"] = 437.26, ["Mega|Ride"] = 563.01, ["Mega|Fly|Ride"] = 564.09}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 210, ["Fly"] = 493.97, ["Ride"] = 288.64, ["Fly|Ride"] = 385.62, ["Neon"] = 965.48, ["Neon|Ride"] = 859.69, ["Neon|Fly|Ride"] = 954.19, ["Mega|Fly|Ride"] = 3123.08}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 14.44}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 118.13, ["Fly"] = 243.46, ["Ride"] = 176.36, ["Fly|Ride"] = 210, ["Neon"] = 656.25, ["Neon|Fly"] = 610.32, ["Neon|Ride"] = 577.4, ["Neon|Fly|Ride"] = 654.83, ["Mega"] = 2567.76, ["Mega|Ride"] = 2406.14, ["Mega|Fly|Ride"] = 2266.85}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 124.69, ["Fly"] = 215.15, ["Ride"] = 138.77, ["Fly|Ride"] = 196.88, ["Neon"] = 642.52, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 856.28, ["Mega|Fly|Ride"] = 3084.38}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 4.77, ["Fly"] = 79.62, ["Ride"] = 26.25, ["Fly|Ride"] = 174.57, ["Neon"] = 36.63, ["Neon|Ride"] = 69.62, ["Neon|Fly|Ride"] = 242.71, ["Mega"] = 162.33, ["Mega|Ride"] = 189.95, ["Mega|Fly|Ride"] = 372.5}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 15.01, ["Fly"] = 72.09, ["Ride"] = 30.18, ["Fly|Ride"] = 89.65, ["Neon"] = 164.07, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 171.27, ["Mega|Ride"] = 1427.86, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 11.84, ["Fly"] = 102.36, ["Ride"] = 34.06, ["Fly|Ride"] = 117, ["Neon"] = 72.19, ["Neon|Ride"] = 101.06, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 428.15, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 571.58}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 4.89, ["Fly"] = 131.23, ["Ride"] = 49.87, ["Fly|Ride"] = 150.63, ["Neon"] = 26.24, ["Neon|Ride"] = 75.1, ["Neon|Fly|Ride"] = 177.44, ["Mega"] = 155.93, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 306.66}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 271.68, ["Ride"] = 287.44, ["Fly|Ride"] = 343.07, ["Neon"] = 1428.53, ["Neon|Ride"] = 1299.38, ["Neon|Fly|Ride"] = 1395.72, ["Mega|Fly|Ride"] = 6422.07}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 94.43, ["Fly"] = 157.5, ["Ride"] = 144.37, ["Fly|Ride"] = 242.67, ["Neon"] = 429.19, ["Neon|Ride"] = 485.63, ["Neon|Fly|Ride"] = 610.74, ["Mega"] = 2284.13, ["Mega|Fly|Ride"] = 2012.26}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 64.21, ["Fly"] = 96.83, ["Ride"] = 81.31, ["Fly|Ride"] = 114.6, ["Neon"] = 315, ["Neon|Ride"] = 341.22, ["Neon|Fly|Ride"] = 315.77, ["Mega"] = 1427.86, ["Mega|Ride"] = 1776.99, ["Mega|Fly|Ride"] = 1372.88}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 20.99, ["Ride"] = 71.76, ["Fly|Ride"] = 285.93, ["Neon|Ride"] = 615.25, ["Neon|Fly|Ride"] = 499.87, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 12.75, ["Fly"] = 77.97, ["Ride"] = 29.88, ["Fly|Ride"] = 93.18, ["Neon"] = 94.5, ["Neon|Fly"] = 143.51, ["Neon|Ride"] = 122.01, ["Neon|Fly|Ride"] = 126, ["Mega"] = 431.82, ["Mega|Fly"] = 525, ["Mega|Ride"] = 484.53, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 21.15, ["Fly|Ride"] = 69.57, ["Neon"] = 34.13, ["Neon|Fly"] = 68.31, ["Neon|Ride"] = 48.45, ["Neon|Fly|Ride"] = 105.13, ["Mega"] = 166.69, ["Mega|Ride"] = 177.09, ["Mega|Fly|Ride"] = 271.85}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 879.37, ["Fly"] = 918.75, ["Ride"] = 897.48, ["Fly|Ride"] = 999.81, ["Neon"] = 4283.43, ["Neon|Fly"] = 3290.41, ["Neon|Ride"] = 3391.12, ["Neon|Fly|Ride"] = 2756.25, ["Mega|Fly|Ride"] = 8085}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 282.17, ["Fly"] = 402.32, ["Ride"] = 302.75, ["Fly|Ride"] = 365.55, ["Neon"] = 1285.03, ["Neon|Ride"] = 1270.5, ["Neon|Fly|Ride"] = 1273.13, ["Mega"] = 10703.42, ["Mega|Fly|Ride"] = 4709.52}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 91.87, ["Fly"] = 172.13, ["Ride"] = 99.27, ["Fly|Ride"] = 184.23, ["Neon"] = 422.63, ["Neon|Fly"] = 565.99, ["Neon|Ride"] = 416.61, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 1312.5, ["Mega|Ride"] = 1727.55, ["Mega|Fly|Ride"] = 1712.55}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 172.89, ["Fly"] = 283.5, ["Ride"] = 191.1, ["Fly|Ride"] = 219.15, ["Neon|Ride"] = 1131.18, ["Neon|Fly|Ride"] = 870.19, ["Mega"] = 10703.42, ["Mega|Fly|Ride"] = 4909.67}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 40.89, ["Fly"] = 43.04, ["Ride"] = 29.86, ["Fly|Ride"] = 86.63, ["Neon"] = 169.32, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 204.75, ["Mega|Ride"] = 727.84, ["Mega|Fly|Ride"] = 940.85}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 236.25, ["Ride"] = 269.07, ["Fly|Ride"] = 360.94, ["Neon"] = 853.06, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 1050, ["Mega"] = 4260.27, ["Mega|Fly|Ride"] = 4247.22}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 77.43, ["Fly"] = 125.99, ["Ride"] = 90.45, ["Fly|Ride"] = 127.32, ["Neon|Ride"] = 571.51, ["Neon|Fly|Ride"] = 428.1, ["Mega|Fly|Ride"] = 1570.21}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 2750.92, ["Ride"] = 2453.24, ["Fly|Ride"] = 2454.69, ["Neon|Ride"] = 8561.72, ["Neon|Fly|Ride"] = 7564.12, ["Mega"] = 51376.39, ["Mega|Fly|Ride"] = 26373.22}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 12.69, ["Fly"] = 78.04, ["Ride"] = 32.43, ["Fly|Ride"] = 91.88, ["Neon"] = 53.12, ["Neon|Fly"] = 105, ["Neon|Ride"] = 76.07, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 230.74, ["Mega|Fly"] = 571.58, ["Mega|Ride"] = 320.09, ["Mega|Fly|Ride"] = 393.54}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 62.41, ["Ride"] = 65.57, ["Fly|Ride"] = 210, ["Neon"] = 196.88, ["Neon|Ride"] = 214.07, ["Neon|Fly|Ride"] = 323.44, ["Mega|Ride"] = 931.88, ["Mega|Fly|Ride"] = 1373.63}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 80.07, ["Fly"] = 91.87, ["Ride"] = 82.42, ["Fly|Ride"] = 101.07, ["Neon"] = 525, ["Neon|Fly|Ride"] = 410.79, ["Mega|Fly|Ride"] = 1879.84}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 2203.69, ["Fly"] = 1623.79, ["Ride"] = 1069.69, ["Fly|Ride"] = 1148.44, ["Neon|Ride"] = 5652.25, ["Neon|Fly|Ride"] = 4567.16, ["Mega"] = 37105.55, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 576.98, ["Fly"] = 858.42, ["Ride"] = 569.62, ["Fly|Ride"] = 534.19, ["Mega|Fly|Ride"] = 11417.35}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 70.88, ["Fly"] = 325.01, ["Ride"] = 85.68, ["Fly|Ride"] = 209.72, ["Neon"] = 341.25, ["Neon|Ride"] = 342.56, ["Neon|Fly|Ride"] = 541.92, ["Mega"] = 2140.7, ["Mega|Ride"] = 2584.93, ["Mega|Fly|Ride"] = 1659.07}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 7.49, ["Fly"] = 32.82, ["Ride"] = 22.31, ["Fly|Ride"] = 44.63, ["Neon"] = 86.63, ["Neon|Ride"] = 86.85, ["Neon|Fly|Ride"] = 162.33, ["Mega"] = 553.88, ["Mega|Ride"] = 815.69}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 34.11, ["Fly"] = 68.25, ["Ride"] = 43.35, ["Fly|Ride"] = 89.25, ["Neon"] = 284.82, ["Neon|Fly"] = 357.69, ["Neon|Ride"] = 278.27, ["Neon|Fly|Ride"] = 342.48, ["Mega|Ride"] = 1187.82, ["Mega|Fly|Ride"] = 1049.99}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 748.13, ["Fly"] = 1119.86, ["Ride"] = 797.99, ["Fly|Ride"] = 866.24, ["Neon"] = 2570.05, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2508.43, ["Mega|Fly|Ride"] = 9723}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 592.31}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 6561.74, ["Ride"] = 6282.69, ["Fly|Ride"] = 5315.63, ["Neon"] = 42000, ["Neon|Ride"] = 30673.39, ["Neon|Fly|Ride"] = 19687.5, ["Mega|Fly|Ride"] = 72678.01}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 262.5, ["Fly"] = 403.4, ["Ride"] = 249.67, ["Fly|Ride"] = 421.77, ["Neon"] = 1312.5, ["Neon|Ride"] = 1855.76, ["Neon|Fly|Ride"] = 1706.25, ["Mega"] = 6420.99, ["Mega|Ride"] = 6137.36, ["Mega|Fly|Ride"] = 6137.36}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 71.34, ["Ride"] = 147.82, ["Fly|Ride"] = 336, ["Neon"] = 1122.28, ["Neon|Ride"] = 499.8, ["Neon|Fly|Ride"] = 484.53}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 19.28, ["Fly"] = 101.13, ["Ride"] = 31.83, ["Fly|Ride"] = 91.77, ["Neon"] = 171.35, ["Neon|Ride"] = 129.82, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 713.93, ["Mega|Ride"] = 856.28, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 12.46, ["Fly"] = 28.86, ["Ride"] = 24.82, ["Fly|Ride"] = 56.98, ["Neon"] = 146.5, ["Neon|Ride"] = 128.44, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 1312.5, ["Mega|Ride"] = 380.63, ["Mega|Fly|Ride"] = 2140.7}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 17.72, ["Ride"] = 25.98, ["Fly|Ride"] = 103.3, ["Neon"] = 118.12, ["Neon|Ride"] = 119.06, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 645.75, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 628.3}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 3.56, ["Fly"] = 63.48, ["Ride"] = 21.65, ["Fly|Ride"] = 48.57, ["Neon"] = 33.23, ["Neon|Ride"] = 56.95, ["Neon|Fly|Ride"] = 126.31, ["Mega"] = 668.25, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 191.47}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 27.7, ["Fly"] = 90.57, ["Ride"] = 47.25, ["Fly|Ride"] = 143.51, ["Neon"] = 156.58, ["Neon|Fly"] = 856.19, ["Neon|Ride"] = 231.18, ["Neon|Fly|Ride"] = 340.38, ["Mega"] = 630, ["Mega|Ride"] = 713.93}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 504, ["Fly"] = 538.13, ["Ride"] = 551.15, ["Fly|Ride"] = 634.99, ["Neon|Ride"] = 1570.02, ["Neon|Fly|Ride"] = 1575, ["Mega"] = 7875, ["Mega|Fly|Ride"] = 5851.57}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.1, ["Fly"] = 19.59, ["Ride"] = 15.77, ["Fly|Ride"] = 34.37, ["Neon"] = 22.86, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 170.63, ["Mega|Ride"] = 226.92, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 51.17, ["Fly"] = 116.44, ["Ride"] = 74.81, ["Fly|Ride"] = 147.95, ["Neon"] = 229.19, ["Neon|Fly"] = 406.93, ["Neon|Ride"] = 242.23, ["Neon|Fly|Ride"] = 286.12, ["Mega"] = 564.38, ["Mega|Fly"] = 856.28, ["Mega|Ride"] = 557.81, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 823.29, ["Fly"] = 975.66, ["Ride"] = 721.88, ["Fly|Ride"] = 761.25, ["Neon|Ride"] = 2450.09, ["Neon|Fly|Ride"] = 1574.99, ["Mega|Fly|Ride"] = 4287.82}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 27.35, ["Fly"] = 70.47, ["Ride"] = 43.18, ["Fly|Ride"] = 89.24, ["Neon"] = 262.5, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 188.88, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 1575, ["Mega|Fly|Ride"] = 863.77}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 264.27, ["Fly"] = 486.9, ["Ride"] = 287.42, ["Fly|Ride"] = 314.86, ["Neon"] = 1606.28, ["Neon|Fly|Ride"] = 999.71, ["Mega|Fly|Ride"] = 3710.88}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 144.38, ["Fly"] = 365.18, ["Ride"] = 262.49, ["Fly|Ride"] = 314.99, ["Neon|Ride"] = 1085.21, ["Neon|Fly|Ride"] = 764.1, ["Mega"] = 4326, ["Mega|Fly|Ride"] = 3639.17}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 941.25, ["Ride"] = 709.47, ["Fly|Ride"] = 909.25, ["Neon|Ride"] = 3810.15, ["Neon|Fly|Ride"] = 2296.88, ["Mega|Fly|Ride"] = 10416.58}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 16.16, ["Fly"] = 62.41, ["Ride"] = 43.32, ["Fly|Ride"] = 120, ["Neon"] = 78.75, ["Neon|Fly"] = 290.89, ["Neon|Ride"] = 118.02, ["Neon|Fly|Ride"] = 162.33, ["Mega"] = 354.38, ["Mega|Ride"] = 357.52, ["Mega|Fly|Ride"] = 646.86}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 3973.62, ["Fly"] = 3508.32, ["Ride"] = 3281.25, ["Fly|Ride"] = 3151.32, ["Neon|Fly|Ride"] = 7350, ["Mega|Fly|Ride"] = 18892.13}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 142.01, ["Fly"] = 163.12, ["Ride"] = 157.5, ["Fly|Ride"] = 206.22, ["Neon"] = 535.5, ["Neon|Fly"] = 654.46, ["Neon|Ride"] = 523.69, ["Neon|Fly|Ride"] = 577.5, ["Mega|Ride"] = 3068.69, ["Mega|Fly|Ride"] = 3155.38}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 28.24, ["Ride"] = 18.51, ["Fly|Ride"] = 51.5, ["Neon"] = 24.9, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 103.95, ["Mega"] = 160.1, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 248.24, ["Mega|Fly|Ride"] = 236.56}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.56, ["Fly"] = 30.19, ["Ride"] = 27.98, ["Fly|Ride"] = 59.07, ["Neon"] = 22.43, ["Neon|Fly"] = 118.71, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 189.13, ["Mega|Ride"] = 254.76, ["Mega|Fly|Ride"] = 473.82}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 29.8, ["Fly"] = 38.07, ["Ride"] = 38.07, ["Fly|Ride"] = 48.86, ["Neon"] = 290.89, ["Neon|Ride"] = 314.9, ["Neon|Fly|Ride"] = 256.9, ["Mega|Fly|Ride"] = 1138.87}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 763.88, ["Fly"] = 1265.92, ["Ride"] = 826.88, ["Fly|Ride"] = 1038.18, ["Neon|Ride"] = 4523.5, ["Neon|Fly|Ride"] = 4765.71}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 7809.38, ["Fly|Ride"] = 7875}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 20.53, ["Fly"] = 34.43, ["Ride"] = 23.19, ["Fly|Ride"] = 48.38, ["Neon"] = 452.13, ["Neon|Ride"] = 139.13, ["Neon|Fly|Ride"] = 123.4, ["Mega"] = 2520, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 13.86, ["Fly"] = 49.07, ["Ride"] = 28.79, ["Fly|Ride"] = 84.45, ["Neon"] = 91.88, ["Neon|Ride"] = 83.86, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 668.87, ["Mega|Ride"] = 479.07, ["Mega|Fly|Ride"] = 501.38}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 86.63, ["Fly"] = 157.5, ["Ride"] = 112.46, ["Fly|Ride"] = 178.5, ["Neon|Ride"] = 452.82, ["Neon|Fly|Ride"] = 533.78, ["Mega|Fly|Ride"] = 2035}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 223.12, ["Fly"] = 309.19, ["Ride"] = 242.79, ["Fly|Ride"] = 315, ["Neon"] = 907.03, ["Neon|Ride"] = 1182.93, ["Neon|Fly|Ride"] = 1028.99, ["Mega"] = 10703.42, ["Mega|Fly"] = 4039.7, ["Mega|Fly|Ride"] = 4524.22}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.3, ["Ride"] = 37.04, ["Fly|Ride"] = 70.7, ["Neon"] = 20.15, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 66.38, ["Neon|Fly|Ride"] = 323.44, ["Mega"] = 162.75, ["Mega|Fly"] = 238.7, ["Mega|Ride"] = 191.63, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 184.49, ["Fly"] = 231.71, ["Ride"] = 195.56, ["Fly|Ride"] = 291.37, ["Neon"] = 721.88, ["Neon|Ride"] = 715.32, ["Neon|Fly|Ride"] = 787.5, ["Mega|Fly|Ride"] = 2779.88}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 14.42, ["Fly|Ride"] = 40.69, ["Neon"] = 23.55, ["Neon|Fly"] = 118.88, ["Neon|Ride"] = 43.91, ["Neon|Fly|Ride"] = 116.97, ["Mega"] = 217.88, ["Mega|Ride"] = 187.03, ["Mega|Fly|Ride"] = 282.59}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 223.13, ["Fly"] = 350.69, ["Ride"] = 262.5, ["Fly|Ride"] = 307.43, ["Neon|Ride"] = 1269.92, ["Neon|Fly|Ride"] = 1115.63, ["Mega"] = 10703.42, ["Mega|Fly|Ride"] = 4424.81}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 10.13, ["Fly"] = 104.98, ["Ride"] = 28.58, ["Fly|Ride"] = 68.25, ["Neon"] = 73.5, ["Neon|Fly"] = 307.85, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 571.58, ["Mega|Ride"] = 556.6, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.1, ["Ride"] = 26.17, ["Fly|Ride"] = 51.19, ["Neon"] = 7.62, ["Neon|Fly"] = 170.46, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 195.56, ["Mega"] = 75.78, ["Mega|Ride"] = 136.1, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.56, ["Mega"] = 22.95, ["Mega|Ride"] = 143.43, ["Mega|Fly|Ride"] = 135.95}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 2.1, ["Ride"] = 34.28, ["Fly|Ride"] = 115.47, ["Neon"] = 6.46, ["Neon|Ride"] = 42.82, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 81.18, ["Mega|Fly"] = 161507.5, ["Mega|Ride"] = 87.39, ["Mega|Fly|Ride"] = 285.8}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 61.02, ["Fly"] = 102.65, ["Ride"] = 110.15, ["Fly|Ride"] = 173.25, ["Neon"] = 339.94, ["Neon|Fly"] = 328.76, ["Neon|Ride"] = 295.31, ["Neon|Fly|Ride"] = 391.11, ["Mega|Fly|Ride"] = 1599.1}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 37.74, ["Ride"] = 17.05, ["Fly|Ride"] = 83.73, ["Neon"] = 6.46, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 52.4, ["Mega"] = 91.77, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 262.48}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 10.05, ["Ride"] = 65.63, ["Neon"] = 72.19, ["Neon|Fly"] = 307.85, ["Neon|Ride"] = 212.52, ["Mega"] = 261.19, ["Mega|Ride"] = 552.3, ["Mega|Fly|Ride"] = 605.82}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Ride"] = 42.86, ["Neon"] = 2.1, ["Neon|Ride"] = 55.81, ["Neon|Fly|Ride"] = 135.95, ["Mega"] = 15.74, ["Mega|Ride"] = 90.96, ["Mega|Fly|Ride"] = 203.34}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 72.09, ["Ride"] = 16.09, ["Fly|Ride"] = 49.27, ["Neon"] = 2.1, ["Neon|Fly"] = 38.25, ["Neon|Ride"] = 10.5, ["Neon|Fly|Ride"] = 36.74, ["Mega"] = 13.39, ["Mega|Fly"] = 35.8, ["Mega|Ride"] = 24.94, ["Mega|Fly|Ride"] = 56.4}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 29.06, ["Ride"] = 14.81, ["Fly|Ride"] = 80.33, ["Neon"] = 3.46, ["Neon|Fly"] = 22.32, ["Neon|Ride"] = 15.74, ["Neon|Fly|Ride"] = 52.41, ["Mega"] = 22.78, ["Mega|Fly"] = 162.33, ["Mega|Ride"] = 31.18, ["Mega|Fly|Ride"] = 87.93}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 89.91, ["Mega"] = 19.69, ["Mega|Ride"] = 105}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 117.98, ["Ride"] = 21, ["Fly|Ride"] = 107.62, ["Neon"] = 2.9, ["Neon|Fly"] = 122.09, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 90.03, ["Mega"] = 36.85, ["Mega|Fly"] = 100.63, ["Mega|Ride"] = 36.75, ["Mega|Fly|Ride"] = 101.06}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 77.23, ["Neon|Fly|Ride"] = 428.15, ["Mega"] = 20.9, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 69.57, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 5.34, ["Fly"] = 77.43, ["Ride"] = 34.37, ["Fly|Ride"] = 171.35, ["Neon"] = 22.92, ["Neon|Fly"] = 126, ["Neon|Ride"] = 62.29, ["Neon|Fly|Ride"] = 142.53, ["Mega"] = 155.07, ["Mega|Fly"] = 401.06, ["Mega|Ride"] = 166.83, ["Mega|Fly|Ride"] = 274.98}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 51.98, ["Neon"] = 2.1, ["Neon|Ride"] = 26.99, ["Neon|Fly|Ride"] = 323.44, ["Mega"] = 15.63, ["Mega|Fly"] = 144.27, ["Mega|Ride"] = 90.85, ["Mega|Fly|Ride"] = 196.77}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 144.58, ["Fly|Ride"] = 143.51, ["Neon"] = 18.4, ["Mega"] = 111.56, ["Mega|Fly"] = 315, ["Mega|Ride"] = 274.31, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Ride"] = 26.24, ["Neon"] = 17.05, ["Mega"] = 123.5, ["Mega|Ride"] = 160.13, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 32.8, ["Neon"] = 3.94, ["Neon|Ride"] = 27.84, ["Neon|Fly|Ride"] = 143.43, ["Mega"] = 22.32, ["Mega|Ride"] = 44.63, ["Mega|Fly|Ride"] = 98.01}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.48, ["Ride"] = 14.34, ["Fly|Ride"] = 32.82, ["Neon"] = 2.1, ["Neon|Fly"] = 29.1, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 38.05, ["Mega"] = 13.3, ["Mega|Fly"] = 32.81, ["Mega|Ride"] = 20.97, ["Mega|Fly|Ride"] = 49.88}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.1, ["Fly"] = 72.19, ["Ride"] = 54.28, ["Fly|Ride"] = 118.1, ["Neon"] = 36.74, ["Neon|Ride"] = 71.72, ["Mega"] = 202.55, ["Mega|Ride"] = 241.5}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 32.7, ["Neon"] = 2.55, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 32.11, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 25.81, ["Mega|Ride"] = 43.2, ["Mega|Fly|Ride"] = 115.49}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 5.57, ["Neon"] = 10.75, ["Mega"] = 83.41, ["Mega|Ride"] = 165.92, ["Mega|Fly|Ride"] = 242.99}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.1, ["Fly"] = 78.92, ["Ride"] = 28.87, ["Neon"] = 16.08, ["Neon|Ride"] = 42.82, ["Neon|Fly|Ride"] = 105, ["Mega"] = 128.45, ["Mega|Ride"] = 163.41, ["Mega|Fly|Ride"] = 196.87}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 12.73, ["Ride"] = 11.54, ["Fly|Ride"] = 31.48, ["Neon"] = 2.1, ["Neon|Fly"] = 15.49, ["Neon|Ride"] = 15.1, ["Neon|Fly|Ride"] = 30.26, ["Mega"] = 16, ["Mega|Fly"] = 30.87, ["Mega|Ride"] = 24.22, ["Mega|Fly|Ride"] = 48.56}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 29.06, ["Ride"] = 27.42, ["Fly|Ride"] = 144.38, ["Neon"] = 12.96, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 196.47, ["Mega"] = 129.65, ["Mega|Ride"] = 160.78, ["Mega|Fly|Ride"] = 162.33}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 2.1, ["Ride"] = 24.26, ["Fly|Ride"] = 59.07, ["Neon"] = 56.91, ["Neon|Ride"] = 71.46, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 291.38, ["Mega|Ride"] = 297.51, ["Mega|Fly|Ride"] = 327.48}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 39.29, ["Ride"] = 14.41, ["Fly|Ride"] = 42.86, ["Neon"] = 2.1, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 14.43, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 20.78, ["Mega|Ride"] = 31.5, ["Mega|Fly|Ride"] = 104.97}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.1, ["Fly"] = 179.66, ["Ride"] = 45.91, ["Neon"] = 6.57, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 59.95, ["Mega|Fly"] = 171.27, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 214.09}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 35.44, ["Neon"] = 3.76, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 363.41, ["Mega"] = 28.25, ["Mega|Fly"] = 114.58, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 162.33}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 32.88, ["Ride"] = 27.56, ["Neon"] = 2.1, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 285.8, ["Mega"] = 15.64, ["Mega|Fly"] = 253.82, ["Mega|Ride"] = 43.23, ["Mega|Fly|Ride"] = 156.18}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 23.67, ["Ride"] = 18.38, ["Fly|Ride"] = 48.03, ["Neon"] = 8.52, ["Neon|Fly"] = 57.84, ["Neon|Ride"] = 32.06, ["Neon|Fly|Ride"] = 74.46, ["Mega"] = 72.58, ["Mega|Ride"] = 73.5, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 22.59, ["Neon"] = 5.94, ["Neon|Ride"] = 71.72, ["Mega"] = 45.85, ["Mega|Fly"] = 323.44, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 19.48, ["Ride"] = 16.21, ["Fly|Ride"] = 43.37, ["Neon"] = 3.83, ["Neon|Fly"] = 82.17, ["Neon|Ride"] = 25.74, ["Neon|Fly|Ride"] = 64.97, ["Mega"] = 114.19, ["Mega|Fly"] = 114.6, ["Mega|Ride"] = 72.69, ["Mega|Fly|Ride"] = 127.32}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 2.1, ["Ride"] = 37.03, ["Neon"] = 32.96, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 321.12, ["Mega"] = 104.74, ["Mega|Fly"] = 367.5, ["Mega|Ride"] = 210}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Fly"] = 25.77, ["Ride"] = 18.34, ["Fly|Ride"] = 47.23, ["Neon"] = 11.52, ["Neon|Fly"] = 48.45, ["Neon|Ride"] = 32.45, ["Neon|Fly|Ride"] = 123.5, ["Mega"] = 236.25, ["Mega|Fly"] = 420, ["Mega|Ride"] = 113.88, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 15.75, ["Fly|Ride"] = 100.68, ["Neon"] = 11.87, ["Neon|Fly"] = 68.28, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 64.32, ["Mega"] = 203.91, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 131.15, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 114.03, ["Ride"] = 72.65, ["Neon"] = 9.09, ["Neon|Fly|Ride"] = 2625, ["Mega"] = 255.29, ["Mega|Ride"] = 315.77}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 3.92, ["Ride"] = 59.07, ["Neon"] = 131.25, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 794.07, ["Mega"] = 640.08, ["Mega|Ride"] = 728.44, ["Mega|Fly|Ride"] = 646.86}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 2.1, ["Ride"] = 55.28, ["Neon"] = 44.61, ["Neon|Ride"] = 107.04, ["Mega"] = 238.88, ["Mega|Ride"] = 361.6}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 3.61, ["Ride"] = 37.7, ["Fly|Ride"] = 120.75, ["Neon"] = 42.86, ["Neon|Ride"] = 57.29, ["Neon|Fly|Ride"] = 127.28, ["Mega"] = 278.92, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 446.91}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Ride"] = 28.93, ["Neon"] = 3.52, ["Neon|Ride"] = 65.02, ["Mega"] = 17.72, ["Mega|Fly"] = 123.11, ["Mega|Ride"] = 63, ["Mega|Fly|Ride"] = 231.95}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 45.94}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 5.39, ["Fly"] = 23.37, ["Ride"] = 22.32, ["Fly|Ride"] = 51.01, ["Neon"] = 44.63, ["Neon|Fly"] = 189, ["Neon|Ride"] = 61.32, ["Neon|Fly|Ride"] = 104.4, ["Mega"] = 278.31, ["Mega|Ride"] = 208.68, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.79, ["Ride"] = 19.31, ["Fly|Ride"] = 86.63, ["Neon"] = 2.77, ["Neon|Fly"] = 52.8, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 104.9, ["Mega"] = 24.94, ["Mega|Fly"] = 143.43, ["Mega|Ride"] = 57.75, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 6.97, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 72.17, ["Mega"] = 30.55, ["Mega|Ride"] = 61.3, ["Mega|Fly|Ride"] = 115.96}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 44.71, ["Ride"] = 16.08, ["Fly|Ride"] = 44.8, ["Neon"] = 9.19, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 61.58, ["Mega"] = 107.05, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 171.71}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 2.49, ["Fly"] = 43.04, ["Ride"] = 21.73, ["Fly|Ride"] = 69.57, ["Neon"] = 41.99, ["Neon|Ride"] = 208.13, ["Neon|Fly|Ride"] = 157.49, ["Mega"] = 328.02, ["Mega|Ride"] = 345.45, ["Mega|Fly|Ride"] = 345.74}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Ride"] = 34.12, ["Neon"] = 2.1, ["Neon|Ride"] = 24.7, ["Neon|Fly|Ride"] = 315, ["Mega"] = 22.32, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 53.45, ["Mega|Fly|Ride"] = 145.69}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 27.45, ["Ride"] = 17.15, ["Fly|Ride"] = 58.7, ["Neon"] = 3.11, ["Neon|Fly"] = 113.53, ["Neon|Ride"] = 19.68, ["Neon|Fly|Ride"] = 96.9, ["Mega"] = 31.08, ["Mega|Fly"] = 143.43, ["Mega|Ride"] = 38.58, ["Mega|Fly|Ride"] = 123.37}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 29.04, ["Ride"] = 17.72, ["Fly|Ride"] = 42.86, ["Neon"] = 3.14, ["Neon|Fly"] = 52.58, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 61.11, ["Mega"] = 84, ["Mega|Fly"] = 143.43, ["Mega|Ride"] = 100.63, ["Mega|Fly|Ride"] = 115.48}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 91.88, ["Ride"] = 53.27, ["Fly|Ride"] = 143.51, ["Neon"] = 8.25, ["Neon|Ride"] = 59.74, ["Neon|Fly|Ride"] = 107.05, ["Mega"] = 72.76, ["Mega|Ride"] = 128.67, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 156014.25, ["Mega"] = 16.42, ["Mega|Fly"] = 108.1, ["Mega|Ride"] = 63.16, ["Mega|Fly|Ride"] = 136.49}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 45.9, ["Ride"] = 19.68, ["Fly|Ride"] = 42.86, ["Neon"] = 3.94, ["Neon|Fly"] = 27.87, ["Neon|Ride"] = 23.42, ["Neon|Fly|Ride"] = 90.61, ["Mega"] = 18.17, ["Mega|Fly"] = 64.23, ["Mega|Ride"] = 36.74, ["Mega|Fly|Ride"] = 78.66}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 2.51, ["Mega"] = 15.75, ["Mega|Ride"] = 118.13}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.16, ["Neon|Fly|Ride"] = 420, ["Mega"] = 51.18, ["Mega|Ride"] = 196.95, ["Mega|Fly|Ride"] = 154.14}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 15.89, ["Fly|Ride"] = 47.25, ["Neon"] = 2.43, ["Neon|Fly"] = 39.37, ["Neon|Ride"] = 17.53, ["Neon|Fly|Ride"] = 35.44, ["Mega"] = 38.06, ["Mega|Ride"] = 51.19, ["Mega|Fly|Ride"] = 108.36}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 19.68, ["Ride"] = 78.75, ["Fly|Ride"] = 214.18, ["Neon"] = 81.38, ["Mega"] = 389.81, ["Mega|Ride"] = 678.61, ["Mega|Fly|Ride"] = 713.93}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.1, ["Fly"] = 6562.5, ["Ride"] = 26.24, ["Neon"] = 43.32, ["Neon|Ride"] = 157.5, ["Mega"] = 183.75, ["Mega|Fly|Ride"] = 629.99}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 2.1, ["Ride"] = 32.15, ["Fly|Ride"] = 175.64, ["Neon"] = 22.73, ["Neon|Fly|Ride"] = 285.8, ["Mega"] = 320.04, ["Mega|Ride"] = 294.36, ["Mega|Fly|Ride"] = 383.15}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 14.15, ["Ride"] = 11.7, ["Fly|Ride"] = 30.71, ["Neon"] = 2.1, ["Neon|Fly"] = 23.58, ["Neon|Ride"] = 10.73, ["Neon|Fly|Ride"] = 31.4, ["Mega"] = 14.3, ["Mega|Fly"] = 28.92, ["Mega|Ride"] = 21.61, ["Mega|Fly|Ride"] = 59.76}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Fly"] = 118.12, ["Ride"] = 60.37, ["Neon"] = 7.43, ["Neon|Fly"] = 68.75, ["Neon|Ride"] = 32.11, ["Neon|Fly|Ride"] = 713.93, ["Mega"] = 86.72, ["Mega|Ride"] = 143.43}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Fly"] = 72.09, ["Ride"] = 43.65, ["Neon"] = 2.1, ["Neon|Fly"] = 32.36, ["Neon|Ride"] = 23.15, ["Neon|Fly|Ride"] = 86.67, ["Mega"] = 13.79, ["Mega|Fly"] = 128.45, ["Mega|Ride"] = 55.74, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 3.65, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 127.32, ["Neon|Fly|Ride"] = 72.63, ["Mega"] = 20.62, ["Mega|Fly"] = 214.09, ["Mega|Fly|Ride"] = 367.49}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 128.03, ["Ride"] = 19.37, ["Fly|Ride"] = 57.32, ["Neon"] = 8.6, ["Neon|Fly"] = 71.52, ["Neon|Ride"] = 36.41, ["Neon|Fly|Ride"] = 101.07, ["Mega"] = 170.62, ["Mega|Ride"] = 160.13, ["Mega|Fly|Ride"] = 295.98}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 164.07, ["Ride"] = 225.44, ["Fly|Ride"] = 856.7, ["Neon|Fly|Ride"] = 997.58, ["Mega"] = 8562.74, ["Mega|Fly|Ride"] = 4039.7}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Ride"] = 28.01, ["Neon"] = 7.37, ["Neon|Ride"] = 64.31, ["Mega"] = 65.63, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 2.86, ["Fly"] = 103.69, ["Ride"] = 24.68, ["Fly|Ride"] = 64.97, ["Neon"] = 33.12, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 171.25, ["Mega"] = 385.75, ["Mega|Ride"] = 222.89, ["Mega|Fly|Ride"] = 653.84}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 19.66, ["Ride"] = 15.71, ["Fly|Ride"] = 32.82, ["Neon"] = 4.2, ["Neon|Fly"] = 33.22, ["Neon|Ride"] = 28.76, ["Neon|Fly|Ride"] = 50.43, ["Mega"] = 49.67, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 143.43}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 72.09, ["Ride"] = 19.69, ["Fly|Ride"] = 95.48, ["Neon"] = 10.73, ["Neon|Ride"] = 80.07, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 69.57, ["Mega|Ride"] = 193.82, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 17.01, ["Fly|Ride"] = 37.9, ["Neon"] = 31.17, ["Neon|Fly"] = 100.68, ["Neon|Ride"] = 43.31, ["Neon|Fly|Ride"] = 78.75, ["Mega|Ride"] = 285.8, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 2.2, ["Ride"] = 34.28, ["Fly|Ride"] = 65.45, ["Neon"] = 32.82, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 257.25, ["Mega|Ride"] = 259.24, ["Mega|Fly|Ride"] = 387.18}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.1, ["Fly"] = 20.57, ["Ride"] = 17.73, ["Fly|Ride"] = 34.57, ["Neon"] = 31.5, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 79.16, ["Mega"] = 262.5, ["Mega|Fly"] = 213.01, ["Mega|Ride"] = 371.42, ["Mega|Fly|Ride"] = 262.4}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 65.54, ["Ride"] = 82.69, ["Fly|Ride"] = 148.12, ["Neon"] = 341.24, ["Neon|Fly"] = 450.19, ["Neon|Ride"] = 418.59, ["Neon|Fly|Ride"] = 381.94, ["Mega|Fly|Ride"] = 1468.59}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 242.24, ["Fly"] = 430.29, ["Ride"] = 249.25, ["Fly|Ride"] = 275.63, ["Neon|Ride"] = 1131.18, ["Neon|Fly|Ride"] = 1115.63, ["Mega"] = 10703.42, ["Mega|Fly|Ride"] = 4995.31}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 59.16, ["Fly"] = 85.2, ["Ride"] = 83.44, ["Fly|Ride"] = 111.76, ["Neon"] = 484.79, ["Neon|Fly"] = 363.03, ["Neon|Ride"] = 293.28, ["Neon|Fly|Ride"] = 286.81, ["Mega|Fly|Ride"] = 1563.33}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 3.66, ["Fly"] = 288.09, ["Ride"] = 47.13, ["Fly|Ride"] = 77.44, ["Neon"] = 47.24, ["Neon|Fly"] = 101.2, ["Neon|Ride"] = 99.75, ["Neon|Fly|Ride"] = 182.44, ["Mega"] = 262.5, ["Mega|Ride"] = 190.31, ["Mega|Fly|Ride"] = 416.73}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 9.1, ["Fly"] = 72.09, ["Ride"] = 28.87, ["Fly|Ride"] = 64.87, ["Neon"] = 61.07, ["Neon|Fly"] = 143.51, ["Neon|Ride"] = 78.05, ["Neon|Fly|Ride"] = 144.79, ["Mega"] = 481.67, ["Mega|Ride"] = 397.69, ["Mega|Fly|Ride"] = 456.16}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 33.58, ["Ride"] = 17.05, ["Fly|Ride"] = 50.9, ["Neon"] = 2.96, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 22.09, ["Neon|Fly|Ride"] = 56.44, ["Mega"] = 43.62, ["Mega|Fly"] = 147.79, ["Mega|Ride"] = 214.09, ["Mega|Fly|Ride"] = 381.98}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 6.57, ["Fly"] = 39.38, ["Ride"] = 31.06, ["Fly|Ride"] = 66.25, ["Neon"] = 95.81, ["Neon|Fly"] = 285.93, ["Neon|Ride"] = 113.05, ["Neon|Fly|Ride"] = 252.61, ["Mega"] = 472.03, ["Mega|Ride"] = 484.53, ["Mega|Fly|Ride"] = 585.5}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 41.91, ["Ride"] = 15.75, ["Fly|Ride"] = 34.15, ["Neon"] = 14.44, ["Neon|Fly"] = 61.69, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 62.35, ["Mega"] = 131.25, ["Mega|Ride"] = 268.67, ["Mega|Fly|Ride"] = 278.31}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 2.1, ["Ride"] = 20.37, ["Fly|Ride"] = 328.13, ["Neon"] = 44.63, ["Neon|Ride"] = 36.41, ["Mega"] = 207.38, ["Mega|Ride"] = 266.44, ["Mega|Fly|Ride"] = 310.55}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 27.68, ["Ride"] = 19.37, ["Neon"] = 2.1, ["Neon|Ride"] = 19.28, ["Neon|Fly|Ride"] = 57.74, ["Mega"] = 15.44, ["Mega|Ride"] = 42.82, ["Mega|Fly|Ride"] = 74.82}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 19.07, ["Fly|Ride"] = 42.86, ["Neon"] = 10.19, ["Neon|Fly"] = 107.1, ["Neon|Ride"] = 34.62, ["Neon|Fly|Ride"] = 147, ["Mega"] = 78.72, ["Mega|Fly|Ride"] = 226.42}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 17.94, ["Fly|Ride"] = 71.1, ["Neon"] = 19.09, ["Neon|Ride"] = 47.25, ["Mega"] = 131.23, ["Mega|Ride"] = 266.44, ["Mega|Fly|Ride"] = 266.44}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 84.63, ["Fly"] = 164.11, ["Ride"] = 152.71, ["Fly|Ride"] = 199.4, ["Neon"] = 489.57, ["Neon|Ride"] = 435.67, ["Neon|Fly|Ride"] = 525, ["Mega"] = 3876.18, ["Mega|Fly|Ride"] = 2854.61}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 7.29, ["Ride"] = 129.94, ["Fly|Ride"] = 129.69, ["Neon"] = 46.05, ["Neon|Ride"] = 98.42, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 280.88, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 42.94, ["Ride"] = 19.46, ["Fly|Ride"] = 55.89, ["Neon"] = 13.7, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 246.75, ["Mega|Ride"] = 185.79, ["Mega|Fly|Ride"] = 268.67}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 15.74, ["Ride"] = 46.07, ["Fly|Ride"] = 155.84, ["Neon"] = 87.83, ["Neon|Ride"] = 121.12, ["Neon|Fly|Ride"] = 428.15, ["Mega"] = 445.32, ["Mega|Fly"] = 856.28, ["Mega|Ride"] = 671.11, ["Mega|Fly|Ride"] = 817.64}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 3.93}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 2.1, ["Ride"] = 45.94, ["Fly|Ride"] = 127.45, ["Neon"] = 32.81, ["Neon|Fly"] = 89.25, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 328.6, ["Mega"] = 842.38, ["Mega|Ride"] = 589.92, ["Mega|Fly|Ride"] = 865.56}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 22.07, ["Fly"] = 41.99, ["Ride"] = 25.99, ["Fly|Ride"] = 60.47, ["Neon"] = 402.65, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 161.02, ["Neon|Fly|Ride"] = 177.08, ["Mega"] = 1381.83, ["Mega|Fly|Ride"] = 518.67}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 27.85, ["Fly|Ride"] = 52.38, ["Neon"] = 2.1, ["Neon|Ride"] = 29.07, ["Neon|Fly|Ride"] = 107.63, ["Mega"] = 37.36, ["Mega|Fly"] = 188.99, ["Mega|Ride"] = 87.84, ["Mega|Fly|Ride"] = 231.69}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 2.83, ["Fly"] = 32.55, ["Ride"] = 21.15, ["Fly|Ride"] = 65.54, ["Neon"] = 57.84, ["Neon|Ride"] = 162.31, ["Mega"] = 288.33, ["Mega|Fly"] = 404.59, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 28.95, ["Ride"] = 19.51, ["Fly|Ride"] = 45.67, ["Neon"] = 13.13, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 35.4, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 183.75, ["Mega|Ride"] = 213.01, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 32.81, ["Neon"] = 2.1, ["Neon|Ride"] = 41.2, ["Mega"] = 36.75, ["Mega|Ride"] = 70.66, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 23.62, ["Fly"] = 148.52, ["Ride"] = 81.14, ["Fly|Ride"] = 136.49, ["Neon"] = 180.57, ["Neon|Ride"] = 214.07, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 735, ["Mega|Ride"] = 689.06, ["Mega|Fly|Ride"] = 856.28}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 2.63, ["Ride"] = 106.02, ["Fly|Ride"] = 210, ["Neon"] = 96.97, ["Mega|Ride"] = 321.12, ["Mega|Fly|Ride"] = 323.44}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 2.1, ["Fly"] = 22.31, ["Ride"] = 19.69, ["Fly|Ride"] = 62.97, ["Neon"] = 15.75, ["Neon|Fly"] = 85.68, ["Neon|Ride"] = 39.35, ["Neon|Fly|Ride"] = 104.91, ["Mega"] = 158.82, ["Mega|Fly|Ride"] = 290.07}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 80.19, ["Fly"] = 433.12, ["Ride"] = 128.51, ["Neon"] = 423, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 565.04, ["Mega"] = 4524.22, ["Mega|Fly|Ride"] = 2887.5}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 6.46, ["Fly"] = 45.66, ["Ride"] = 19.29, ["Fly|Ride"] = 67.89, ["Neon"] = 35.81, ["Neon|Ride"] = 63.16, ["Neon|Fly|Ride"] = 107.79, ["Mega"] = 418.95, ["Mega|Ride"] = 242.27, ["Mega|Fly|Ride"] = 398.99}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 74.49, ["Fly"] = 131.24, ["Ride"] = 91.86, ["Fly|Ride"] = 200.26, ["Neon"] = 223.13, ["Neon|Fly"] = 325.55, ["Neon|Ride"] = 193.79, ["Neon|Fly|Ride"] = 354.25, ["Mega"] = 1142.08, ["Mega|Ride"] = 1076.25, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 18.25, ["Fly"] = 172.13, ["Ride"] = 55, ["Fly|Ride"] = 148.86, ["Neon"] = 58.1, ["Neon|Ride"] = 99.75, ["Neon|Fly|Ride"] = 285.8, ["Mega"] = 336.66, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 840.66}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 8.29, ["Fly"] = 53.58, ["Ride"] = 25.83, ["Fly|Ride"] = 71.76, ["Neon"] = 143.51, ["Neon|Ride"] = 193.79, ["Neon|Fly|Ride"] = 385.22, ["Mega"] = 565.69, ["Mega|Ride"] = 569.44, ["Mega|Fly|Ride"] = 571.58}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 15.75, ["Fly"] = 76.7, ["Ride"] = 96.97, ["Fly|Ride"] = 102.38, ["Neon"] = 49.87, ["Neon|Ride"] = 77.32, ["Neon|Fly|Ride"] = 272.19, ["Mega"] = 342.53, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 401.35}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 7.66, ["Ride"] = 39.25, ["Neon"] = 41.99, ["Neon|Ride"] = 57.18, ["Neon|Fly|Ride"] = 145.69, ["Mega"] = 276.83, ["Mega|Ride"] = 276.89, ["Mega|Fly|Ride"] = 417.8}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Ride"] = 72.09, ["Neon"] = 2.1, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 210, ["Mega"] = 15.75, ["Mega|Ride"] = 143.43, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 3.33, ["Ride"] = 126.06, ["Neon"] = 29.26, ["Neon|Ride"] = 195.86, ["Neon|Fly|Ride"] = 202.79, ["Mega"] = 238.88, ["Mega|Ride"] = 507.35, ["Mega|Fly|Ride"] = 525.55}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Fly"] = 128.03, ["Ride"] = 28.93, ["Neon"] = 28.87, ["Neon|Fly"] = 116.94, ["Neon|Ride"] = 100.62, ["Neon|Fly|Ride"] = 199.11, ["Mega"] = 210.67, ["Mega|Ride"] = 285.8, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 121.21, ["Neon"] = 18.8, ["Neon|Ride"] = 85.22, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 129.63, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 519.74}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 525, ["Fly"] = 644.36, ["Ride"] = 551.25, ["Fly|Ride"] = 577.24, ["Neon"] = 1820.46, ["Neon|Fly"] = 1822.59, ["Neon|Ride"] = 1776.71, ["Neon|Fly|Ride"] = 1637.26, ["Mega|Fly|Ride"] = 5085.94}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 6.19, ["Fly"] = 45.47, ["Ride"] = 20.44, ["Fly|Ride"] = 57.51, ["Neon"] = 118.78, ["Neon|Ride"] = 57.82, ["Neon|Fly|Ride"] = 319.93, ["Mega"] = 200.17, ["Mega|Ride"] = 371.88, ["Mega|Fly|Ride"] = 354.31}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 6.47, ["Fly"] = 66.94, ["Ride"] = 20.94, ["Fly|Ride"] = 52.61, ["Neon"] = 85.32, ["Neon|Fly"] = 315, ["Neon|Ride"] = 81.17, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 331.87, ["Mega|Ride"] = 339.19, ["Mega|Fly|Ride"] = 681.45}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 2.63, ["Fly"] = 24.93, ["Ride"] = 24.68, ["Fly|Ride"] = 50.3, ["Neon"] = 15.75, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 131.25}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.6, ["Ride"] = 26.22, ["Fly|Ride"] = 89.24, ["Neon"] = 8.75, ["Neon|Ride"] = 32.11, ["Neon|Fly|Ride"] = 193.79, ["Mega"] = 65.54, ["Mega|Ride"] = 140.44, ["Mega|Fly|Ride"] = 236.24}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Ride"] = 19.68, ["Fly|Ride"] = 52.31, ["Neon"] = 2.1, ["Neon|Ride"] = 24.45, ["Neon|Fly|Ride"] = 114.54, ["Mega"] = 39.38, ["Mega|Fly"] = 200.17, ["Mega|Ride"] = 86.63, ["Mega|Fly|Ride"] = 229.07}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1181.25}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 4.96, ["Ride"] = 31.4, ["Fly|Ride"] = 171.35, ["Neon"] = 81.26, ["Neon|Ride"] = 112.87, ["Mega"] = 402.47, ["Mega|Ride"] = 411.86, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 28.93, ["Neon"] = 3.94, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 1007.55, ["Mega"] = 39.38, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 182.44}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 3.7, ["Fly"] = 321.92, ["Ride"] = 56.98, ["Fly|Ride"] = 597.55, ["Neon"] = 45.94, ["Neon|Ride"] = 170.52, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 261.37, ["Mega|Ride"] = 357.52, ["Mega|Fly|Ride"] = 1070.36}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 315, ["Ride"] = 367.5, ["Fly|Ride"] = 551.24, ["Neon|Ride"] = 1582.86, ["Neon|Fly|Ride"] = 1312.5, ["Mega"] = 8027.58, ["Mega|Fly|Ride"] = 6164.82}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 6.12, ["Fly"] = 196.88, ["Ride"] = 26.25, ["Fly|Ride"] = 128.51, ["Neon"] = 58.53, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 193.82, ["Mega"] = 306.56, ["Mega|Ride"] = 491.31, ["Mega|Fly|Ride"] = 761.02}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Fly"] = 94.96, ["Ride"] = 30.17, ["Fly|Ride"] = 118.11, ["Neon"] = 3.59, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 42.93, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 37.16, ["Mega|Fly"] = 143.43, ["Mega|Ride"] = 86.62, ["Mega|Fly|Ride"] = 191.03}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 4.53, ["Neon|Ride"] = 143.42, ["Neon|Fly|Ride"] = 285.8, ["Mega"] = 34.12, ["Mega|Ride"] = 181.91, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 20.62, ["Fly"] = 107.9, ["Ride"] = 49.4, ["Fly|Ride"] = 144.38, ["Neon"] = 105, ["Neon|Ride"] = 208.7, ["Neon|Fly|Ride"] = 437.07, ["Mega"] = 518.44, ["Mega|Ride"] = 628.3, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 13.1, ["Ride"] = 72.09, ["Neon"] = 90.91, ["Neon|Ride"] = 133.88, ["Neon|Fly|Ride"] = 856.28, ["Mega"] = 565.69, ["Mega|Ride"] = 479.73, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 3.62, ["Ride"] = 76.12, ["Neon"] = 95.76, ["Neon|Ride"] = 200.82, ["Mega"] = 655.07, ["Mega|Fly|Ride"] = 807.95}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 13.02, ["Ride"] = 26.17, ["Fly|Ride"] = 222.29, ["Neon"] = 167.28, ["Neon|Ride"] = 177.51, ["Neon|Fly|Ride"] = 241.5, ["Mega"] = 643.02, ["Mega|Ride"] = 502.7, ["Mega|Fly|Ride"] = 565.69}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 393.75, ["Ride"] = 423.05, ["Fly|Ride"] = 711.05, ["Neon"] = 1050, ["Neon|Ride"] = 1050, ["Neon|Fly|Ride"] = 1115.63, ["Mega|Fly|Ride"] = 3346.87}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 7.75, ["Fly"] = 40.78, ["Ride"] = 33.5, ["Fly|Ride"] = 82.18, ["Neon"] = 100.68, ["Neon|Ride"] = 131.25, ["Mega|Fly"] = 590.63, ["Mega|Ride"] = 561.1, ["Mega|Fly|Ride"] = 778.16}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 2.3, ["Ride"] = 42.68, ["Fly|Ride"] = 127.32, ["Neon"] = 52.5, ["Neon|Ride"] = 221.82, ["Mega"] = 170.63, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 629.99}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 33.07, ["Fly"] = 344.24, ["Ride"] = 115.4, ["Fly|Ride"] = 143.51, ["Neon"] = 146.89, ["Neon|Ride"] = 177.19, ["Neon|Fly|Ride"] = 288.65, ["Mega"] = 412.48, ["Mega|Ride"] = 396.97, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Fly|Ride"] = 76.37, ["Neon"] = 9.69, ["Neon|Ride"] = 69.57, ["Neon|Fly|Ride"] = 277.24, ["Mega"] = 43.32, ["Mega|Fly"] = 186.25, ["Mega|Ride"] = 381.06, ["Mega|Fly|Ride"] = 281.06}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 51.18, ["Ride"] = 77.8, ["Neon"] = 262.5, ["Neon|Ride"] = 321.08, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 1635.26, ["Mega|Ride"] = 2712.26, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 56.44, ["Ride"] = 28.52, ["Fly|Ride"] = 300.57, ["Neon"] = 9.78, ["Neon|Fly"] = 186.34, ["Neon|Ride"] = 58.45, ["Neon|Fly|Ride"] = 129.63, ["Mega"] = 63, ["Mega|Ride"] = 94.4, ["Mega|Fly|Ride"] = 207.31}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 27.99, ["Ride"] = 20.76, ["Fly|Ride"] = 99.4, ["Neon"] = 3.56, ["Neon|Fly"] = 49.27, ["Neon|Ride"] = 51.19, ["Neon|Fly|Ride"] = 105, ["Mega"] = 31.08, ["Mega|Fly"] = 112.88, ["Mega|Ride"] = 74.82, ["Mega|Fly|Ride"] = 285.8}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Ride"] = 37.96, ["Fly|Ride"] = 131.07, ["Neon"] = 12.75, ["Neon|Ride"] = 53.95, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 79.67, ["Mega|Ride"] = 137.03, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 51.96, ["Fly"] = 65.61, ["Ride"] = 61.57, ["Fly|Ride"] = 244.16, ["Neon"] = 209.2, ["Neon|Ride"] = 361.6, ["Neon|Fly|Ride"] = 484.53, ["Mega|Ride"] = 1142.08, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 2151.4}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 3.05, ["Neon"] = 20.99, ["Neon|Fly"] = 350.44, ["Mega"] = 196.88, ["Mega|Ride"] = 248.07, ["Mega|Fly|Ride"] = 323.44}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.1, ["Ride"] = 21, ["Neon"] = 8.66, ["Neon|Ride"] = 72.01, ["Neon|Fly|Ride"] = 171.27, ["Mega"] = 42.52, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 91.87, ["Mega|Fly|Ride"] = 241.4}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 2.49, ["Fly"] = 107.59, ["Ride"] = 32.48, ["Fly|Ride"] = 81.21, ["Neon"] = 32.81, ["Mega"] = 307.19, ["Mega|Ride"] = 351.56, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 98.44, ["Ride"] = 39.37, ["Fly|Ride"] = 308.11, ["Neon"] = 12.85, ["Neon|Ride"] = 61.73, ["Neon|Fly|Ride"] = 138.99, ["Mega"] = 171.67, ["Mega|Fly"] = 175.88, ["Mega|Ride"] = 187.41, ["Mega|Fly|Ride"] = 347.75}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 94.25, ["Neon"] = 8.98, ["Neon|Ride"] = 143.42, ["Neon|Fly|Ride"] = 143.43, ["Mega"] = 65.63, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 405.67}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 22.31, ["Fly|Ride"] = 52.5, ["Neon"] = 4.55, ["Neon|Fly"] = 81.17, ["Neon|Ride"] = 28.67, ["Neon|Fly|Ride"] = 101.98, ["Mega"] = 43.32, ["Mega|Ride"] = 99.68, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 29.06, ["Ride"] = 19.69, ["Fly|Ride"] = 57.74, ["Neon"] = 15.74, ["Neon|Fly"] = 101.68, ["Neon|Ride"] = 40.57, ["Neon|Fly|Ride"] = 107.05, ["Mega"] = 143.43, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 728.44}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 27.07, ["Ride"] = 39.13, ["Fly|Ride"] = 78.75, ["Neon"] = 144.36, ["Neon|Ride"] = 164.07, ["Mega"] = 459.38, ["Mega|Ride"] = 561.75, ["Mega|Fly|Ride"] = 651}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 72.1, ["Ride"] = 95.19, ["Fly|Ride"] = 139.13, ["Neon"] = 428.36, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 465.94, ["Mega"] = 1997.27, ["Mega|Ride"] = 1605.53, ["Mega|Fly|Ride"] = 1500.78}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 19.39, ["Fly|Ride"] = 131.25, ["Neon"] = 3.41, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 19.99, ["Neon|Fly|Ride"] = 143.43, ["Mega"] = 32.81, ["Mega|Fly"] = 672, ["Mega|Ride"] = 92.42, ["Mega|Fly|Ride"] = 248.33}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 17.09, ["Ride"] = 15.75, ["Fly|Ride"] = 43.28, ["Neon"] = 4.07, ["Neon|Fly"] = 36.43, ["Neon|Ride"] = 20.9, ["Neon|Fly|Ride"] = 61.69, ["Mega"] = 52.01, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 68.53, ["Mega|Fly|Ride"] = 91.87}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 3.94, ["Fly"] = 50.57, ["Ride"] = 38.03, ["Fly|Ride"] = 52.5, ["Neon"] = 40.69, ["Neon|Ride"] = 162.31, ["Mega"] = 542.69, ["Mega|Ride"] = 323.44, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 393.75, ["Ride"] = 496.49, ["Fly|Ride"] = 446.25, ["Neon"] = 4283.43, ["Neon|Fly|Ride"] = 1771.88, ["Mega|Fly|Ride"] = 5906.25}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 20.24, ["Fly"] = 101.13, ["Ride"] = 50.94, ["Fly|Ride"] = 96.97, ["Neon"] = 214.99, ["Neon|Ride"] = 192.93, ["Neon|Fly|Ride"] = 255.97, ["Mega|Ride"] = 785.65, ["Mega|Fly|Ride"] = 855.22}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 25.86, ["Fly|Ride"] = 284.86, ["Neon"] = 10.59, ["Neon|Ride"] = 46.33, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 141.3, ["Mega|Ride"] = 122.19, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 86.44, ["Ride"] = 53.41, ["Fly|Ride"] = 261.97, ["Neon"] = 69.83, ["Neon|Ride"] = 72.34, ["Mega"] = 122.07, ["Mega|Fly|Ride"] = 320.04}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 29.17, ["Fly"] = 169.31, ["Ride"] = 38.06, ["Fly|Ride"] = 102.38, ["Neon"] = 194.25, ["Neon|Ride"] = 211.32, ["Neon|Fly|Ride"] = 230.89, ["Mega"] = 2568.83, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1002.75}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 114.58, ["Fly"] = 163.17, ["Ride"] = 118.13, ["Fly|Ride"] = 143.51, ["Neon"] = 391.47, ["Neon|Fly"] = 813.86, ["Neon|Ride"] = 571.51, ["Neon|Fly|Ride"] = 610.32, ["Mega"] = 8562.74, ["Mega|Fly|Ride"] = 2572.5}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 241.5, ["Ride"] = 294, ["Fly|Ride"] = 534.36, ["Neon"] = 938.44, ["Neon|Ride"] = 735, ["Neon|Fly|Ride"] = 984.38, ["Mega|Fly|Ride"] = 3522.5}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 9.91, ["Ride"] = 55.13, ["Fly|Ride"] = 200.26, ["Neon"] = 98.22, ["Neon|Ride"] = 88.73, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 459.38, ["Mega|Ride"] = 402.94, ["Mega|Fly|Ride"] = 455.44}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 28.95, ["Ride"] = 15.75, ["Fly|Ride"] = 36.66, ["Neon"] = 6.57, ["Neon|Ride"] = 27.46, ["Neon|Fly|Ride"] = 84, ["Mega"] = 81.39, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 187.94}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 2.1, ["Fly"] = 40.6, ["Ride"] = 20.78, ["Fly|Ride"] = 81.11, ["Neon"] = 25.47, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 38.77, ["Neon|Fly|Ride"] = 113.23, ["Mega"] = 288.7, ["Mega|Ride"] = 245.13, ["Mega|Fly|Ride"] = 304.86}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 347.61, ["Ride"] = 350.43, ["Fly|Ride"] = 753.9, ["Neon"] = 1562.54, ["Neon|Ride"] = 2033.41, ["Neon|Fly|Ride"] = 1741.46, ["Mega"] = 10275.29, ["Mega|Fly|Ride"] = 5847.19}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Neon"] = 9.1, ["Neon|Ride"] = 139.41, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 33.47, ["Mega|Ride"] = 85.22, ["Mega|Fly|Ride"] = 468.79}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 2.17, ["Fly"] = 26.24, ["Ride"] = 17.05, ["Fly|Ride"] = 60.71, ["Neon"] = 27.56, ["Neon|Ride"] = 38.03, ["Neon|Fly|Ride"] = 96.92, ["Mega"] = 122.04, ["Mega|Ride"] = 218.05, ["Mega|Fly|Ride"] = 228.38}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 15.45, ["Fly"] = 6562.5, ["Ride"] = 86.07, ["Fly|Ride"] = 128.51, ["Neon"] = 100.11, ["Neon|Fly"] = 428.1, ["Neon|Ride"] = 108.43, ["Neon|Fly|Ride"] = 308.73, ["Mega"] = 551.15, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 723.1}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 111.57, ["Fly"] = 157.5, ["Ride"] = 123.32, ["Fly|Ride"] = 143.07, ["Neon|Ride"] = 799.35, ["Neon|Fly|Ride"] = 642.22, ["Mega|Fly|Ride"] = 3248.44}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 23.86, ["Fly"] = 28.19, ["Ride"] = 28.14, ["Fly|Ride"] = 53.03, ["Neon"] = 139.22, ["Neon|Ride"] = 111.55, ["Neon|Fly|Ride"] = 126.36, ["Mega"] = 875.44, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 484.53}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 2.1, ["Mega"] = 42, ["Mega|Ride"] = 109.12, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Ride"] = 16.08, ["Fly|Ride"] = 85.68, ["Neon"] = 2.62, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 86.92, ["Mega"] = 25.2, ["Mega|Ride"] = 48.06, ["Mega|Fly|Ride"] = 111.57}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 8.97, ["Ride"] = 77.66, ["Fly|Ride"] = 199.49, ["Neon"] = 36.02, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 227.91, ["Mega"] = 191.58, ["Mega|Ride"] = 212.62, ["Mega|Fly|Ride"] = 314.9}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1292.82, ["Ride"] = 1299.38, ["Fly|Ride"] = 1363.69, ["Neon"] = 4396.93, ["Neon|Ride"] = 7135.12, ["Neon|Fly|Ride"] = 4533.53, ["Mega|Fly|Ride"] = 12600}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 402.71, ["Ride"] = 459.38, ["Fly|Ride"] = 576.19, ["Neon"] = 1680, ["Neon|Ride"] = 2669.13, ["Neon|Fly|Ride"] = 1753.5, ["Mega"] = 17125.47, ["Mega|Fly|Ride"] = 6850.2}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 319.1, ["Fly"] = 405.55, ["Ride"] = 347.82, ["Fly|Ride"] = 406.87, ["Neon"] = 747.47, ["Neon|Fly"] = 856.85, ["Neon|Ride"] = 708.64, ["Neon|Fly|Ride"] = 786.19, ["Mega|Fly|Ride"] = 2916.24}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 229.57, ["Fly"] = 288.75, ["Ride"] = 271.65, ["Fly|Ride"] = 370.13, ["Neon"] = 630, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 702.76, ["Mega|Fly|Ride"] = 2994.83}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 34.55, ["Ride"] = 17.04, ["Fly|Ride"] = 42.02, ["Neon"] = 8.88, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 102.77, ["Mega"] = 69.57, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 223.12, ["Fly"] = 462.55, ["Ride"] = 354.37, ["Fly|Ride"] = 571.85, ["Neon"] = 1050, ["Neon|Ride"] = 1284.33, ["Neon|Fly|Ride"] = 1299.36, ["Mega"] = 21692.63, ["Mega|Ride"] = 5423.43, ["Mega|Fly|Ride"] = 4593.75}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 3.71, ["Fly"] = 157.5, ["Ride"] = 70.7, ["Neon"] = 33.51, ["Neon|Ride"] = 119.59, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 175.88, ["Mega|Ride"] = 342.55, ["Mega|Fly|Ride"] = 571.58}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 19.67, ["Ride"] = 17.22, ["Fly|Ride"] = 38.98, ["Neon"] = 8.58, ["Neon|Ride"] = 53.52, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 117.08, ["Mega|Ride"] = 162.33, ["Mega|Fly|Ride"] = 120.8}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 57.18, ["Neon"] = 3.02, ["Neon|Ride"] = 46.73, ["Mega"] = 82.07, ["Mega|Ride"] = 196.77, ["Mega|Fly|Ride"] = 177.62}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 28.5, ["Ride"] = 57.75, ["Fly|Ride"] = 459.38, ["Neon"] = 199.5, ["Neon|Ride"] = 357.47, ["Mega"] = 1050, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 773.07}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 8115.2, ["Ride"] = 32.82, ["Fly|Ride"] = 68.25, ["Neon"] = 16.28, ["Neon|Ride"] = 61.13, ["Mega"] = 355.37, ["Mega|Ride"] = 300.53, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.13, ["Neon"] = 2.1, ["Neon|Ride"] = 56.43, ["Neon|Fly|Ride"] = 141.93, ["Mega"] = 23.69, ["Mega|Ride"] = 70.66, ["Mega|Fly|Ride"] = 158.42}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.63, ["Fly"] = 85.99, ["Ride"] = 33.24, ["Fly|Ride"] = 81.38, ["Neon"] = 26.17, ["Neon|Fly"] = 114.6, ["Neon|Ride"] = 53.81, ["Neon|Fly|Ride"] = 188.98, ["Mega"] = 168.72, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 252}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 2.1, ["Fly"] = 45.2, ["Ride"] = 19.29, ["Fly|Ride"] = 42, ["Neon"] = 37.49, ["Neon|Fly"] = 145.45, ["Neon|Ride"] = 143.42, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 238.83, ["Mega|Ride"] = 251.07, ["Mega|Fly|Ride"] = 1321.69}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 17.22, ["Ride"] = 38.06, ["Fly|Ride"] = 105, ["Neon"] = 93.18, ["Neon|Ride"] = 186.23, ["Neon|Fly|Ride"] = 323.44, ["Mega"] = 428.15, ["Mega|Ride"] = 801.7}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.1, ["Fly"] = 6492.65, ["Ride"] = 17.07, ["Fly|Ride"] = 131.24, ["Neon"] = 51.45, ["Neon|Ride"] = 212.99, ["Neon|Fly|Ride"] = 285.8, ["Mega"] = 341.25, ["Mega|Ride"] = 484.53, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 68.16, ["Ride"] = 16.34, ["Fly|Ride"] = 45.94, ["Neon"] = 3.68, ["Neon|Fly"] = 82.48, ["Neon|Ride"] = 27.87, ["Neon|Fly|Ride"] = 114.54, ["Mega"] = 49.88, ["Mega|Fly|Ride"] = 226.79}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 142.7, ["Fly"] = 230.22, ["Ride"] = 164.05, ["Fly|Ride"] = 262.5, ["Neon"] = 971.28, ["Neon|Ride"] = 850.84, ["Neon|Fly|Ride"] = 840, ["Mega"] = 8562.74, ["Mega|Ride"] = 4067.32, ["Mega|Fly|Ride"] = 3997.74}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 21.59, ["Ride"] = 14.57, ["Fly|Ride"] = 36.66, ["Neon"] = 2.1, ["Neon|Fly"] = 36.38, ["Neon|Ride"] = 18.18, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 49.65, ["Mega|Ride"] = 57.75, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 5.84, ["Ride"] = 41.18, ["Fly|Ride"] = 229.18, ["Neon"] = 64.58, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 775.25, ["Mega"] = 257.25, ["Mega|Ride"] = 428.81, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 23.51, ["Ride"] = 423, ["Fly|Ride"] = 183.75, ["Neon"] = 190.32, ["Neon|Ride"] = 298.6, ["Neon|Fly|Ride"] = 342.53, ["Mega"] = 786.19, ["Mega|Ride"] = 901.95, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 170.63, ["Fly"] = 309.19, ["Ride"] = 268.7, ["Fly|Ride"] = 319.39, ["Neon"] = 812.4, ["Neon|Ride"] = 702.18, ["Neon|Fly|Ride"] = 785.65, ["Mega|Fly|Ride"] = 3531.07}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 17.83, ["Ride"] = 162.42, ["Fly|Ride"] = 145.45, ["Neon"] = 124.69, ["Neon|Ride"] = 145.34, ["Neon|Fly|Ride"] = 428.15, ["Mega"] = 270.44, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 392.83}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 6.03, ["Fly"] = 97.39, ["Ride"] = 43.37, ["Fly|Ride"] = 71.76, ["Neon"] = 128.63, ["Neon|Fly"] = 162.42, ["Neon|Ride"] = 323.37, ["Neon|Fly|Ride"] = 214.09, ["Mega"] = 1213.78, ["Mega|Ride"] = 1427.86, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 931.88, ["Fly"] = 1136.89, ["Ride"] = 1016.97, ["Fly|Ride"] = 1035.44, ["Neon|Ride"] = 5906.25, ["Neon|Fly|Ride"] = 5250, ["Mega|Fly|Ride"] = 16412.63}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 6.12, ["Fly"] = 24.83, ["Ride"] = 21.56, ["Fly|Ride"] = 45.93, ["Neon"] = 47.24, ["Neon|Fly"] = 76.44, ["Neon|Ride"] = 49.13, ["Neon|Fly|Ride"] = 202.13, ["Mega"] = 242.82, ["Mega|Ride"] = 285.8, ["Mega|Fly|Ride"] = 346.49}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 2.99, ["Fly"] = 78.75, ["Ride"] = 49.88, ["Fly|Ride"] = 135.19, ["Neon"] = 32.82, ["Neon|Ride"] = 98.1, ["Neon|Fly|Ride"] = 190.32, ["Mega"] = 211.32, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 299.71}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Fly"] = 86.07, ["Ride"] = 24.59, ["Fly|Ride"] = 62.99, ["Neon"] = 9.71, ["Neon|Ride"] = 47.75, ["Neon|Fly|Ride"] = 81.18, ["Mega"] = 91.87, ["Mega|Ride"] = 360.34, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 15.63, ["Fly"] = 58.1, ["Ride"] = 32.81, ["Fly|Ride"] = 97.13, ["Neon"] = 72.41, ["Neon|Fly"] = 188.36, ["Neon|Ride"] = 97.44, ["Neon|Fly|Ride"] = 180.35, ["Mega"] = 446.22, ["Mega|Ride"] = 399, ["Mega|Fly|Ride"] = 461.75}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 2.1, ["Fly"] = 21.53, ["Ride"] = 21, ["Fly|Ride"] = 45.85, ["Neon"] = 20.62, ["Neon|Fly"] = 42.86, ["Neon|Ride"] = 31.18, ["Neon|Fly|Ride"] = 107.05, ["Mega"] = 131.25, ["Mega|Fly"] = 280.98, ["Mega|Ride"] = 169.32, ["Mega|Fly|Ride"] = 172.65}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Ride"] = 26.15, ["Neon"] = 11.82, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 48.45, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 124.49, ["Mega|Ride"] = 170.2}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 243.46, ["Ride"] = 268.94, ["Fly|Ride"] = 428.36, ["Neon"] = 927.36, ["Neon|Fly|Ride"] = 1183.01, ["Mega|Fly|Ride"] = 3887.49}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Fly"] = 32.81, ["Ride"] = 23.63, ["Fly|Ride"] = 110.25, ["Neon"] = 6.13, ["Neon|Ride"] = 50.3, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 57.66, ["Mega|Ride"] = 100.88, ["Mega|Fly|Ride"] = 342.53}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 3.49, ["Ride"] = 33.22, ["Fly|Ride"] = 88.86, ["Neon"] = 32.73, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 188.27, ["Mega"] = 176.86, ["Mega|Ride"] = 346.5, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 3.71, ["Fly"] = 94.74, ["Ride"] = 25.99, ["Neon"] = 15.27, ["Neon|Ride"] = 71.72, ["Mega"] = 91.85, ["Mega|Ride"] = 120.53, ["Mega|Fly|Ride"] = 256.9}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 81.85, ["Ride"] = 129.56, ["Fly|Ride"] = 249.38, ["Neon"] = 441.16, ["Neon|Ride"] = 420, ["Neon|Fly|Ride"] = 371.38, ["Mega"] = 2568.83, ["Mega|Ride"] = 1570.21, ["Mega|Fly|Ride"] = 1813.18}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 19.65, ["Fly"] = 88.08, ["Ride"] = 39.38, ["Fly|Ride"] = 265.59, ["Neon"] = 181.32, ["Neon|Ride"] = 207.64, ["Neon|Fly|Ride"] = 341.93, ["Mega"] = 656.24, ["Mega|Ride"] = 640.08, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 19.68, ["Fly"] = 58.1, ["Ride"] = 35.44, ["Fly|Ride"] = 103.69, ["Neon"] = 93.19, ["Neon|Ride"] = 170.18, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 472.03, ["Mega|Ride"] = 435.75, ["Mega|Fly|Ride"] = 513.18}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 72.19, ["Neon"] = 5.24, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 236.15, ["Mega"] = 118.13, ["Mega|Ride"] = 163.13, ["Mega|Fly|Ride"] = 555.52}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 38.06, ["Fly"] = 87.27, ["Ride"] = 71.45, ["Fly|Ride"] = 162.75, ["Neon"] = 223.13, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 229.59, ["Neon|Fly|Ride"] = 275.63, ["Mega|Fly|Ride"] = 856.28}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 52.5, ["Neon"] = 5.93, ["Neon|Ride"] = 57.82, ["Neon|Fly|Ride"] = 127.39, ["Mega"] = 61.02, ["Mega|Ride"] = 284.72, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 17.15, ["Fly"] = 130.27, ["Ride"] = 32.47, ["Fly|Ride"] = 85.68, ["Neon"] = 63.91, ["Neon|Ride"] = 100.53, ["Neon|Fly|Ride"] = 203.44, ["Mega"] = 360.7, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 427.08, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 54.74, ["Fly"] = 203.41, ["Ride"] = 69.57, ["Fly|Ride"] = 137.83, ["Neon"] = 255.94, ["Neon|Fly"] = 428.36, ["Neon|Ride"] = 265.13, ["Neon|Fly|Ride"] = 398.34, ["Mega|Ride"] = 1464.25, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 16.21, ["Ride"] = 15.75, ["Fly|Ride"] = 35.43, ["Neon"] = 2.1, ["Neon|Fly"] = 27.84, ["Neon|Ride"] = 16.51, ["Neon|Fly|Ride"] = 42.82, ["Mega"] = 20.2, ["Mega|Fly"] = 121.14, ["Mega|Ride"] = 40.58, ["Mega|Fly|Ride"] = 86.7}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 2.1, ["Ride"] = 18.38, ["Fly|Ride"] = 64.32, ["Neon"] = 19.44, ["Neon|Ride"] = 65.61, ["Neon|Fly|Ride"] = 167.99, ["Mega"] = 393.75, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 392.44}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 12.86, ["Fly"] = 144.16, ["Ride"] = 41.91, ["Fly|Ride"] = 117.24, ["Neon"] = 110.25, ["Neon|Ride"] = 173.25, ["Neon|Fly|Ride"] = 272.76, ["Mega"] = 636.87, ["Mega|Ride"] = 450.21, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 22.32, ["Neon"] = 2.1, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 87.94, ["Mega"] = 17.75, ["Mega|Ride"] = 52.36, ["Mega|Fly|Ride"] = 214.09}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 20.37, ["Fly"] = 207.9, ["Ride"] = 81.34, ["Fly|Ride"] = 194.87, ["Neon"] = 151.77, ["Neon|Ride"] = 173.37, ["Neon|Fly|Ride"] = 393.74, ["Mega"] = 641.19, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 596, ["Mega|Fly|Ride"] = 982.58}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 9.09, ["Fly"] = 43.04, ["Ride"] = 26.25, ["Fly|Ride"] = 88.9, ["Neon"] = 376.69, ["Neon|Ride"] = 120.59, ["Neon|Fly|Ride"] = 164.84, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 511.64}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 5.44, ["Ride"] = 50.94, ["Neon"] = 67.57, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 89.03, ["Neon|Fly|Ride"] = 713.93, ["Mega"] = 233.52, ["Mega|Ride"] = 315.6, ["Mega|Fly|Ride"] = 427.08}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 7.65, ["Fly"] = 72.19, ["Ride"] = 72.09, ["Fly|Ride"] = 237.34, ["Neon"] = 59.48, ["Neon|Ride"] = 88.91, ["Neon|Fly|Ride"] = 190.31, ["Mega"] = 242.19, ["Mega|Ride"] = 442.32, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Fly"] = 43.04, ["Ride"] = 26.74, ["Fly|Ride"] = 196.88, ["Neon"] = 4.87, ["Neon|Ride"] = 36.2, ["Mega"] = 53.53, ["Mega|Fly"] = 214.09, ["Mega|Ride"] = 106.31, ["Mega|Fly|Ride"] = 285.8}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 58.19, ["Neon"] = 3.15, ["Neon|Ride"] = 87.77, ["Neon|Fly|Ride"] = 145.29, ["Mega"] = 47.76, ["Mega|Ride"] = 103.59, ["Mega|Fly|Ride"] = 195.33}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 20.36}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 38.75, ["Fly"] = 101.07, ["Ride"] = 66.94, ["Fly|Ride"] = 91.87, ["Neon"] = 184.58, ["Neon|Ride"] = 214.07, ["Neon|Fly|Ride"] = 315, ["Mega"] = 1854.57, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 853.58}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Fly|Ride"] = 107.1, ["Neon"] = 2.1, ["Neon|Ride"] = 31.5, ["Mega"] = 22.19, ["Mega|Ride"] = 110.24, ["Mega|Fly|Ride"] = 321.12}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 525, ["Fly"] = 574.43, ["Ride"] = 561.75, ["Fly|Ride"] = 459.38, ["Neon"] = 2855.97, ["Neon|Ride"] = 2675.55, ["Neon|Fly|Ride"] = 2136.42, ["Mega"] = 17125.47, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 4.6, ["Fly"] = 48.37, ["Ride"] = 33.73, ["Fly|Ride"] = 48.49, ["Neon"] = 9.81, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 114.53, ["Mega"] = 289.17, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 646.86}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 3.84, ["Fly"] = 29.06, ["Ride"] = 19.32, ["Fly|Ride"] = 60.82, ["Neon"] = 51.86, ["Neon|Ride"] = 64.22, ["Neon|Fly|Ride"] = 99.65, ["Mega"] = 145.37, ["Mega|Fly"] = 285.8, ["Mega|Ride"] = 173.75, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 11.95, ["Ride"] = 28.93, ["Fly|Ride"] = 535.44, ["Neon"] = 112.88, ["Neon|Ride"] = 143.42, ["Neon|Fly|Ride"] = 313.69, ["Mega"] = 646.86, ["Mega|Ride"] = 534.11, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 2.1, ["Fly"] = 430.29, ["Ride"] = 38.57, ["Fly|Ride"] = 71.76, ["Neon"] = 32.06, ["Neon|Fly"] = 50.35, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 392.44, ["Mega"] = 280.23, ["Mega|Fly|Ride"] = 498.8}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 10.31, ["Ride"] = 73.49, ["Fly|Ride"] = 177.68, ["Neon"] = 54.45, ["Neon|Ride"] = 143.42, ["Neon|Fly|Ride"] = 273.02, ["Mega"] = 554.46, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 1019.8}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 3.75, ["Ride"] = 46.07, ["Fly|Ride"] = 91.88, ["Neon"] = 28.08, ["Neon|Ride"] = 81.29, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 222.99, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 349.13}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 43.84, ["Ride"] = 13.8, ["Fly|Ride"] = 85.68, ["Neon"] = 2.1, ["Neon|Fly"] = 41.99, ["Neon|Ride"] = 19.28, ["Neon|Fly|Ride"] = 53.82, ["Mega"] = 14.49, ["Mega|Fly"] = 66.21, ["Mega|Ride"] = 36.75, ["Mega|Fly|Ride"] = 103.5}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 7.28, ["Fly"] = 49.88, ["Ride"] = 38.75, ["Fly|Ride"] = 107.1, ["Neon"] = 29.19, ["Neon|Fly"] = 121.12, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 165.8, ["Mega"] = 196.88, ["Mega|Ride"] = 259.77, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 259.88, ["Ride"] = 360.19, ["Fly|Ride"] = 367.5, ["Neon"] = 1312.5, ["Neon|Ride"] = 1043.44, ["Neon|Fly|Ride"] = 1050, ["Mega|Ride"] = 9399.71, ["Mega|Fly|Ride"] = 3937.5}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 79.71, ["Ride"] = 126, ["Fly|Ride"] = 255.95, ["Neon"] = 458.07, ["Neon|Fly"] = 916.65, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 636.87, ["Mega"] = 2284.13, ["Mega|Ride"] = 1699.72, ["Mega|Fly|Ride"] = 1827}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 19.47, ["Ride"] = 16.22, ["Fly|Ride"] = 36.75, ["Neon"] = 6.39, ["Neon|Fly"] = 71.76, ["Neon|Ride"] = 27.84, ["Neon|Fly|Ride"] = 79.96, ["Mega"] = 143.43, ["Mega|Fly"] = 213.01, ["Mega|Ride"] = 100.63, ["Mega|Fly|Ride"] = 260.54}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 22.58, ["Ride"] = 15.71, ["Fly|Ride"] = 35.23, ["Neon"] = 8.93, ["Neon|Fly"] = 39, ["Neon|Ride"] = 27.18, ["Neon|Fly|Ride"] = 61.06, ["Mega"] = 58.95, ["Mega|Fly"] = 285.8, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 277.24}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.1, ["Fly"] = 101.13, ["Ride"] = 22.32, ["Fly|Ride"] = 98.44, ["Neon"] = 100.68, ["Neon|Ride"] = 32.72, ["Neon|Fly|Ride"] = 157.5, ["Mega|Ride"] = 327.91, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 207.89, ["Fly"] = 325.01, ["Ride"] = 248.26, ["Fly|Ride"] = 288.65, ["Neon"] = 1177.95, ["Neon|Ride"] = 1023.75, ["Neon|Fly|Ride"] = 1586.27, ["Mega|Ride"] = 8562.74, ["Mega|Fly|Ride"] = 3806.25}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.1, ["Fly"] = 19.38, ["Ride"] = 16.49, ["Fly|Ride"] = 39.52, ["Neon"] = 18.19, ["Neon|Fly"] = 104.97, ["Neon|Ride"] = 38.3, ["Neon|Fly|Ride"] = 76.13, ["Mega"] = 255.94, ["Mega|Ride"] = 221.82, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 3.05, ["Ride"] = 77.09, ["Fly|Ride"] = 214.18, ["Neon"] = 70.88, ["Neon|Ride"] = 107.04, ["Neon|Fly|Ride"] = 285.76, ["Mega"] = 196.88, ["Mega|Ride"] = 303.19, ["Mega|Fly|Ride"] = 458.12}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Neon"] = 7.87, ["Neon|Ride"] = 137.82, ["Mega"] = 101.07, ["Mega|Ride"] = 339.19}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 13.12, ["Fly"] = 49.13, ["Ride"] = 25.72, ["Fly|Ride"] = 65.63, ["Neon"] = 149.93, ["Neon|Ride"] = 111.22, ["Neon|Fly|Ride"] = 252.61, ["Mega"] = 460.69, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 577.61}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 38.97, ["Fly"] = 100.54, ["Ride"] = 72.19, ["Fly|Ride"] = 393.02, ["Neon"] = 132.34, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 142.59, ["Neon|Fly|Ride"] = 333.38, ["Mega"] = 529.83, ["Mega|Fly"] = 2247.74, ["Mega|Ride"] = 503.28, ["Mega|Fly|Ride"] = 647.07}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 24.85, ["Ride"] = 42.49, ["Fly|Ride"] = 91.77, ["Neon"] = 216.48, ["Neon|Fly"] = 286.43, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 856.28, ["Mega|Ride"] = 700.88, ["Mega|Fly|Ride"] = 802.77}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 17.06, ["Ride"] = 14.44, ["Fly|Ride"] = 51.45, ["Neon"] = 2.1, ["Neon|Fly"] = 30.53, ["Neon|Ride"] = 18.19, ["Neon|Fly|Ride"] = 42.82, ["Mega"] = 20.99, ["Mega|Fly"] = 428.15, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 89.25}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 209.21, ["Ride"] = 209.99, ["Fly|Ride"] = 272.87, ["Neon"] = 3393.43, ["Neon|Fly|Ride"] = 1211.32, ["Mega|Fly|Ride"] = 4995.31}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 8.84, ["Fly"] = 101.07, ["Ride"] = 24.62, ["Fly|Ride"] = 92.94, ["Neon"] = 78.75, ["Neon|Ride"] = 113.87, ["Neon|Fly|Ride"] = 285.8, ["Mega"] = 422.63, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 35.98, ["Ride"] = 18.77, ["Fly|Ride"] = 41.77, ["Neon"] = 5.6, ["Neon|Fly"] = 43.29, ["Neon|Ride"] = 28.92, ["Neon|Fly|Ride"] = 105, ["Mega"] = 61.8, ["Mega|Fly"] = 222.65, ["Mega|Ride"] = 85.64, ["Mega|Fly|Ride"] = 234.18}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 16.14, ["Fly|Ride"] = 79.4, ["Neon"] = 2.1, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 129.63, ["Mega"] = 23.48, ["Mega|Fly"] = 143.43, ["Mega|Ride"] = 65.62, ["Mega|Fly|Ride"] = 161.63}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Ride"] = 28.58, ["Fly|Ride"] = 72.18, ["Neon"] = 10.48, ["Neon|Fly"] = 727.18, ["Neon|Ride"] = 46.92, ["Neon|Fly|Ride"] = 101.79, ["Mega"] = 155.53, ["Mega|Ride"] = 123.98, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 9.42, ["Fly"] = 47.16, ["Ride"] = 27.02, ["Fly|Ride"] = 62.99, ["Neon"] = 47.16, ["Neon|Fly"] = 272.01, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 605.67, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 430.95}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 11.74, ["Ride"] = 45.2, ["Fly|Ride"] = 144.38, ["Neon"] = 107.1, ["Neon|Ride"] = 149.85, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 275.63, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 484.53}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 57.74, ["Neon"] = 2.1, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 101.81, ["Mega"] = 23.63, ["Mega|Ride"] = 193.82, ["Mega|Fly|Ride"] = 139.29}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 7.06, ["Ride"] = 34.04, ["Fly|Ride"] = 171.35, ["Neon"] = 35.13, ["Neon|Fly"] = 96.97, ["Neon|Ride"] = 44.34, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 156.19, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 318.36}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 143.75, ["Neon"] = 3.76, ["Neon|Fly"] = 114.53, ["Neon|Ride"] = 55.08, ["Neon|Fly|Ride"] = 105, ["Mega"] = 26.46, ["Mega|Ride"] = 107.05, ["Mega|Fly|Ride"] = 327.46}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 49.38, ["Ride"] = 21.94, ["Fly|Ride"] = 44.63, ["Neon"] = 5.1, ["Neon|Ride"] = 27.2, ["Neon|Fly|Ride"] = 128.62, ["Mega"] = 77.32, ["Mega|Ride"] = 78, ["Mega|Fly|Ride"] = 281.69}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 604.59, ["Ride"] = 721.88, ["Fly|Ride"] = 771.75, ["Neon|Fly|Ride"] = 3675, ["Mega|Fly|Ride"] = 9620.63}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 16.46, ["Ride"] = 18.23, ["Fly|Ride"] = 42.86, ["Neon"] = 17.07, ["Neon|Fly"] = 42.86, ["Neon|Ride"] = 27, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 191.61, ["Mega|Fly|Ride"] = 396.11}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.1, ["Ride"] = 51.19, ["Fly|Ride"] = 64.8, ["Neon"] = 15.5, ["Neon|Fly"] = 749.61, ["Neon|Ride"] = 114.53, ["Neon|Fly|Ride"] = 186.25, ["Mega"] = 74.79, ["Mega|Fly"] = 190.54, ["Mega|Ride"] = 149.86, ["Mega|Fly|Ride"] = 291.38}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 7.33, ["Fly"] = 33.36, ["Ride"] = 21.89, ["Fly|Ride"] = 61.4, ["Neon"] = 41.48, ["Neon|Fly"] = 193.79, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 123.44, ["Mega"] = 485.63, ["Mega|Ride"] = 308.43, ["Mega|Fly|Ride"] = 376.69}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 19.38, ["Ride"] = 14.44, ["Fly|Ride"] = 57.84, ["Neon"] = 5.76, ["Neon|Fly"] = 149.93, ["Neon|Ride"] = 20.34, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 62.89, ["Mega|Ride"] = 91.23, ["Mega|Fly|Ride"] = 180.22}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 42, ["Ride"] = 79.26, ["Fly|Ride"] = 315.92, ["Neon"] = 218.18, ["Neon|Ride"] = 210, ["Mega"] = 725.7, ["Mega|Ride"] = 726.79, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Fly"] = 32.71, ["Ride"] = 20.79, ["Fly|Ride"] = 76.13, ["Neon"] = 7.87, ["Neon|Fly"] = 138.17, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 112.38, ["Mega"] = 46.22, ["Mega|Ride"] = 132.9, ["Mega|Fly|Ride"] = 272.99}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 21.37, ["Fly|Ride"] = 63.02, ["Neon"] = 12.72, ["Neon|Ride"] = 48.57, ["Mega"] = 110.57, ["Mega|Ride"] = 198.59, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly|Ride"] = 65.83, ["Neon"] = 10.4, ["Neon|Fly|Ride"] = 114.54, ["Mega"] = 97.12, ["Mega|Ride"] = 143.43, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 43.04, ["Ride"] = 18.32, ["Fly|Ride"] = 69.09, ["Neon"] = 3.67, ["Neon|Fly"] = 72.24, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 108.15, ["Mega"] = 41.97, ["Mega|Fly"] = 229.69, ["Mega|Ride"] = 129.63}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 15, ["Fly"] = 21.49, ["Ride"] = 20.1, ["Fly|Ride"] = 38.06, ["Neon"] = 118.13, ["Neon|Ride"] = 101.07, ["Neon|Fly|Ride"] = 163.54, ["Mega|Ride"] = 559.8, ["Mega|Fly|Ride"] = 400.32}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 636.57, ["Fly"] = 1004.71, ["Ride"] = 771.74, ["Fly|Ride"] = 708.75, ["Neon"] = 1935.94, ["Neon|Ride"] = 2100, ["Neon|Fly|Ride"] = 2164.32, ["Mega"] = 6565.49, ["Mega|Fly|Ride"] = 5709.21}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 19.59, ["Ride"] = 16.19, ["Fly|Ride"] = 41.47, ["Neon"] = 4.02, ["Neon|Ride"] = 20.79, ["Neon|Fly|Ride"] = 57.75, ["Mega"] = 47.12, ["Mega|Ride"] = 90.46, ["Mega|Fly|Ride"] = 174.16}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 5.49, ["Fly"] = 26.17, ["Ride"] = 32.81, ["Fly|Ride"] = 202.04, ["Neon"] = 70.26, ["Neon|Ride"] = 212.99, ["Neon|Fly|Ride"] = 231, ["Mega|Ride"] = 393.73, ["Mega|Fly|Ride"] = 436.09}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 55.02, ["Fly"] = 104.9, ["Ride"] = 78.75, ["Fly|Ride"] = 111.57, ["Neon"] = 315, ["Neon|Ride"] = 313.69, ["Neon|Fly|Ride"] = 418.69, ["Mega"] = 2439.83, ["Mega|Fly|Ride"] = 2611.88}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 30.35, ["Fly"] = 146.86, ["Ride"] = 60.61, ["Fly|Ride"] = 106.66, ["Neon"] = 200.26, ["Neon|Ride"] = 162.31, ["Neon|Fly|Ride"] = 428.15, ["Mega"] = 1453.57, ["Mega|Ride"] = 915.16, ["Mega|Fly|Ride"] = 1131.37}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 11.67, ["Fly"] = 91.31, ["Ride"] = 26.49, ["Fly|Ride"] = 143.51, ["Neon"] = 50.93, ["Neon|Ride"] = 126, ["Neon|Fly|Ride"] = 273, ["Mega"] = 305.36, ["Mega|Ride"] = 414.24, ["Mega|Fly|Ride"] = 449.56}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 25.5, ["Ride"] = 56.11, ["Fly|Ride"] = 141.38, ["Neon"] = 104.9, ["Neon|Ride"] = 371.82, ["Neon|Fly|Ride"] = 150.73, ["Mega"] = 322.87, ["Mega|Fly"] = 525.72, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 436.09}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 22.71, ["Ride"] = 78.75, ["Fly|Ride"] = 160.64, ["Neon"] = 145.3, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 525, ["Mega"] = 525, ["Mega|Fly"] = 567, ["Mega|Ride"] = 476.44, ["Mega|Fly|Ride"] = 747.11}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 3.38}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 2.87, ["Ride"] = 21, ["Fly|Ride"] = 78.75, ["Neon"] = 37.63, ["Neon|Ride"] = 65.42, ["Neon|Fly|Ride"] = 213.97, ["Mega"] = 210, ["Mega|Fly"] = 458.27, ["Mega|Ride"] = 233.62, ["Mega|Fly|Ride"] = 308.05}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.52, ["Neon"] = 11.82, ["Neon|Fly|Ride"] = 214.09, ["Mega"] = 143.06}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 28.45, ["Fly"] = 62.99, ["Ride"] = 36.66, ["Fly|Ride"] = 81.37, ["Neon"] = 162.42, ["Neon|Ride"] = 231, ["Neon|Fly|Ride"] = 300.84, ["Mega|Ride"] = 571.58, ["Mega|Fly|Ride"] = 616.82}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 2.1, ["Fly"] = 25.99, ["Ride"] = 17.74, ["Fly|Ride"] = 38.07, ["Neon"] = 26.44, ["Neon|Fly"] = 69.57, ["Neon|Ride"] = 36.28, ["Neon|Fly|Ride"] = 72.72, ["Mega"] = 200.17, ["Mega|Fly"] = 427.08, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 198.07}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 3.83, ["Fly"] = 108.22, ["Ride"] = 25.64, ["Fly|Ride"] = 42.77, ["Neon"] = 24.74, ["Neon|Ride"] = 55.55, ["Neon|Fly|Ride"] = 105, ["Mega"] = 169.33, ["Mega|Fly"] = 197.4, ["Mega|Ride"] = 169.31, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Ride"] = 72.09, ["Neon"] = 4.66, ["Mega"] = 44.49, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 258.57}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 31.74, ["Ride"] = 51.19, ["Fly|Ride"] = 143.51, ["Neon"] = 243.1, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 428.1, ["Mega|Ride"] = 1712.55, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 22.31, ["Fly|Ride"] = 58.43, ["Neon"] = 9.09, ["Neon|Fly"] = 203.44, ["Neon|Ride"] = 41.98, ["Neon|Fly|Ride"] = 105, ["Mega"] = 74.09, ["Mega|Ride"] = 139.94}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 9.17, ["Ride"] = 45.94, ["Fly|Ride"] = 284.86, ["Neon"] = 59.07, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 321.08, ["Mega"] = 393.75, ["Mega|Fly"] = 571.58, ["Mega|Ride"] = 484.53, ["Mega|Fly|Ride"] = 599.41}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 45.91, ["Ride"] = 17.05, ["Fly|Ride"] = 61.69, ["Neon"] = 28.87, ["Neon|Ride"] = 30.09, ["Neon|Fly|Ride"] = 99.33, ["Mega"] = 194.25, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 2.24, ["Fly"] = 52.49, ["Ride"] = 24.26, ["Fly|Ride"] = 87.83, ["Neon"] = 46.71, ["Neon|Ride"] = 143.42, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 400.32, ["Mega|Ride"] = 427.08, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 4.32, ["Ride"] = 94.25, ["Neon"] = 114.15, ["Mega"] = 418.06, ["Mega|Ride"] = 366.19, ["Mega|Fly|Ride"] = 645.74}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 53.82, ["Ride"] = 97.44, ["Fly|Ride"] = 145.26, ["Neon"] = 210, ["Neon|Ride"] = 484.45, ["Neon|Fly|Ride"] = 499.87, ["Mega"] = 1213.78, ["Mega|Ride"] = 1284.43, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 14.05, ["Ride"] = 78.65, ["Fly|Ride"] = 161.28, ["Neon"] = 107.62, ["Mega"] = 377.9, ["Mega|Ride"] = 565.69, ["Mega|Fly|Ride"] = 715.98}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 2.82, ["Ride"] = 126.03, ["Neon"] = 51.41, ["Neon|Fly"] = 214.18, ["Neon|Ride"] = 170.63, ["Mega"] = 807.95, ["Mega|Ride"] = 484.53}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 23.38, ["Ride"] = 71.76, ["Fly|Ride"] = 367.48, ["Neon"] = 113.14, ["Neon|Ride"] = 262.49, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 666.84, ["Mega|Fly"] = 2140.7, ["Mega|Ride"] = 666.24, ["Mega|Fly|Ride"] = 769.58}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 3.12, ["Neon"] = 19.11, ["Neon|Fly|Ride"] = 143.43, ["Mega"] = 186.25, ["Mega|Fly|Ride"] = 323.44}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 18.59, ["Fly|Ride"] = 43.32, ["Neon"] = 7.88, ["Neon|Fly"] = 42.86, ["Neon|Ride"] = 41.91, ["Neon|Fly|Ride"] = 96.92, ["Mega"] = 98.18, ["Mega|Ride"] = 136.92, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 3.72, ["Fly"] = 45.94, ["Ride"] = 29.13, ["Fly|Ride"] = 73.22, ["Neon"] = 25.6, ["Neon|Ride"] = 117.74, ["Neon|Fly|Ride"] = 164.06, ["Mega"] = 89.15, ["Mega|Ride"] = 143.43, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 144.16, ["Ride"] = 19.69, ["Fly|Ride"] = 39.38, ["Neon"] = 6.57, ["Neon|Ride"] = 25.93, ["Neon|Fly|Ride"] = 122.04, ["Mega"] = 52.28, ["Mega|Ride"] = 83.99, ["Mega|Fly|Ride"] = 174.48}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.1, ["Fly"] = 65.62, ["Ride"] = 21.03, ["Fly|Ride"] = 71.76, ["Neon"] = 18.69, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 214.09, ["Mega"] = 289.07, ["Mega|Ride"] = 327.54, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.61, ["Fly"] = 51.16, ["Ride"] = 24.53, ["Fly|Ride"] = 93.19, ["Neon"] = 29.58, ["Neon|Fly"] = 315, ["Neon|Ride"] = 87.94, ["Mega"] = 304, ["Mega|Ride"] = 287.47, ["Mega|Fly|Ride"] = 1070.36}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 24.05, ["Fly|Ride"] = 53.72, ["Neon"] = 36.7, ["Neon|Fly"] = 128.44, ["Neon|Ride"] = 43.56, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 306.51, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 400.32}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 35.48, ["Ride"] = 22.92, ["Fly|Ride"] = 52.41, ["Neon"] = 22.23, ["Neon|Ride"] = 69.08, ["Neon|Fly|Ride"] = 107.05, ["Mega"] = 256.9, ["Mega|Ride"] = 214.09, ["Mega|Fly|Ride"] = 186.18}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 46.66, ["Fly|Ride"] = 178.85, ["Neon"] = 11.46, ["Neon|Fly"] = 437.06, ["Neon|Ride"] = 66.92, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 80.3, ["Mega|Fly"] = 216.57, ["Mega|Ride"] = 145.59, ["Mega|Fly|Ride"] = 255.98}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 10.77, ["Fly"] = 100.05, ["Ride"] = 104.99, ["Fly|Ride"] = 375.38, ["Neon"] = 143.51, ["Neon|Fly"] = 288.75, ["Neon|Ride"] = 256.87, ["Neon|Fly|Ride"] = 347.82, ["Mega"] = 571.58, ["Mega|Ride"] = 669.38, ["Mega|Fly|Ride"] = 715.07}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 48.28, ["Fly"] = 164.07, ["Ride"] = 89.25, ["Fly|Ride"] = 161.44, ["Neon"] = 248.07, ["Neon|Ride"] = 198.26, ["Neon|Fly|Ride"] = 360.62, ["Mega"] = 1569.14, ["Mega|Ride"] = 1063.13, ["Mega|Fly|Ride"] = 1106.89}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 51.1, ["Ride"] = 21.56, ["Fly|Ride"] = 118.12, ["Neon"] = 2.1, ["Neon|Ride"] = 32.8, ["Neon|Fly|Ride"] = 143.43, ["Mega"] = 25.81, ["Mega|Ride"] = 71.03, ["Mega|Fly|Ride"] = 139.32}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 8.59, ["Ride"] = 78.75, ["Mega"] = 686.56, ["Mega|Fly|Ride"] = 1128.16}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 46.92, ["Ride"] = 91.91, ["Neon"] = 262.5, ["Neon|Ride"] = 357, ["Neon|Fly|Ride"] = 855.22, ["Mega"] = 1196.77, ["Mega|Ride"] = 1211.32, ["Mega|Fly|Ride"] = 1458.19}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 7.76, ["Fly"] = 190.32, ["Ride"] = 36.66, ["Fly|Ride"] = 133.88, ["Neon"] = 42.86, ["Neon|Fly"] = 129.6, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 127.32, ["Mega"] = 261.72, ["Mega|Ride"] = 242.71, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 3.88, ["Ride"] = 32.59, ["Neon"] = 16.44, ["Neon|Ride"] = 68.16, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 103.25, ["Mega|Fly"] = 282.17, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 261.84}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 29.06, ["Ride"] = 18.78, ["Fly|Ride"] = 39.38, ["Neon"] = 10.77, ["Neon|Ride"] = 24.69, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 236.25, ["Mega|Ride"] = 117.93, ["Mega|Fly|Ride"] = 428.15}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 14.69, ["Ride"] = 16.7, ["Fly|Ride"] = 52.31, ["Neon"] = 2.1, ["Neon|Fly"] = 34.28, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 45.85, ["Mega"] = 24.94, ["Mega|Ride"] = 69.57, ["Mega|Fly|Ride"] = 150.73}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 19.29, ["Fly|Ride"] = 85.68, ["Neon"] = 3.71, ["Neon|Ride"] = 24.23, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 39.26, ["Mega|Fly"] = 140.02, ["Mega|Ride"] = 60.01, ["Mega|Fly|Ride"] = 191.61}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Neon"] = 2.1, ["Neon|Ride"] = 145.08, ["Mega"] = 31.5, ["Mega|Ride"] = 110.25, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 4.66, ["Ride"] = 104.99, ["Neon"] = 42, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 422.81, ["Mega|Ride"] = 346.2, ["Mega|Fly|Ride"] = 427.23}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 3.05, ["Ride"] = 30.19, ["Fly|Ride"] = 213.31, ["Neon"] = 58.46, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 143.42, ["Mega"] = 262.5, ["Mega|Ride"] = 285.8, ["Mega|Fly|Ride"] = 428.15}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 4.51, ["Fly"] = 19.69, ["Ride"] = 19.49, ["Fly|Ride"] = 38.69, ["Neon"] = 30.18, ["Neon|Ride"] = 38.57, ["Neon|Fly|Ride"] = 86.52, ["Mega"] = 338.24, ["Mega|Ride"] = 311.37, ["Mega|Fly|Ride"] = 357.59}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 62.89, ["Ride"] = 88.54, ["Fly|Ride"] = 124.69, ["Neon"] = 393.75, ["Neon|Ride"] = 285.76, ["Neon|Fly|Ride"] = 713.93, ["Mega"] = 2422.62, ["Mega|Fly|Ride"] = 1472.63}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 18.5, ["Fly"] = 82.69, ["Ride"] = 58.97, ["Fly|Ride"] = 78.75, ["Neon"] = 143.51, ["Neon|Fly|Ride"] = 630, ["Mega"] = 464.63, ["Mega|Ride"] = 879.38, ["Mega|Fly|Ride"] = 1037.54}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 19.68, ["Ride"] = 15.94, ["Fly|Ride"] = 40.65, ["Neon"] = 2.52, ["Neon|Fly"] = 42.82, ["Neon|Ride"] = 20.75, ["Neon|Fly|Ride"] = 53.62, ["Mega|Fly"] = 143.43, ["Mega|Ride"] = 93.44, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 14.44, ["Ride"] = 14.43, ["Fly|Ride"] = 30.86, ["Neon"] = 3.73, ["Neon|Fly"] = 28.93, ["Neon|Ride"] = 21.41, ["Neon|Fly|Ride"] = 43.3, ["Mega"] = 43.32, ["Mega|Ride"] = 61.02, ["Mega|Fly|Ride"] = 98.43}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 433.13, ["Fly"] = 568.45, ["Ride"] = 441.83, ["Fly|Ride"] = 510.57, ["Neon|Fly|Ride"] = 1924.49, ["Mega|Fly|Ride"] = 6779.55}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 2.1, ["Fly"] = 115.12, ["Ride"] = 47.7, ["Neon"] = 23.1, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 403.5, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 16.27, ["Ride"] = 19.29, ["Fly|Ride"] = 34.04, ["Neon"] = 5.16, ["Neon|Fly"] = 21.44, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 49.87, ["Mega"] = 63.16, ["Mega|Ride"] = 80.3, ["Mega|Fly|Ride"] = 113.93}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 55.13, ["Ride"] = 98.44, ["Fly|Ride"] = 210, ["Neon"] = 194.25, ["Neon|Ride"] = 259.51, ["Neon|Fly|Ride"] = 426.57, ["Mega"] = 737.63, ["Mega|Ride"] = 761.25, ["Mega|Fly|Ride"] = 929.25}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 27.57, ["Ride"] = 20.78, ["Fly|Ride"] = 56.48, ["Neon"] = 15.98, ["Neon|Fly"] = 79.26, ["Neon|Ride"] = 31.32, ["Neon|Fly|Ride"] = 80.77, ["Mega"] = 125.89, ["Mega|Ride"] = 188.46, ["Mega|Fly|Ride"] = 224.44}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 72.09, ["Ride"] = 57.84, ["Fly|Ride"] = 196.88, ["Neon"] = 3.82, ["Neon|Fly"] = 100.05, ["Neon|Ride"] = 25.47, ["Neon|Fly|Ride"] = 105, ["Mega"] = 25.71, ["Mega|Ride"] = 71.72, ["Mega|Fly|Ride"] = 209.9}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 33.9, ["Fly"] = 129.94, ["Ride"] = 78.74, ["Neon"] = 207.76, ["Neon|Ride"] = 207.38, ["Neon|Fly|Ride"] = 287.44, ["Mega"] = 807.95, ["Mega|Ride"] = 647.05, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Fly"] = 23.55, ["Ride"] = 19.68, ["Fly|Ride"] = 146.99, ["Neon"] = 3.7, ["Neon|Ride"] = 39.38, ["Mega"] = 52.49, ["Mega|Ride"] = 157.25, ["Mega|Fly|Ride"] = 251.99}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 39.37, ["Ride"] = 59.08, ["Fly|Ride"] = 105, ["Neon"] = 148.86, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 288.46, ["Mega"] = 1181.25, ["Mega|Ride"] = 1284.43, ["Mega|Fly|Ride"] = 1333.83}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 3.4, ["Fly"] = 72.09, ["Ride"] = 131.25, ["Fly|Ride"] = 428.36, ["Neon"] = 18.36, ["Neon|Ride"] = 230.9, ["Neon|Fly|Ride"] = 162.33, ["Mega"] = 159.3, ["Mega|Ride"] = 196.88}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.1, ["Ride"] = 74.25, ["Fly|Ride"] = 57.84, ["Neon"] = 9.96, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 437.97, ["Mega"] = 114.54, ["Mega|Ride"] = 124.69, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 41.7, ["Fly"] = 86.07, ["Ride"] = 65.63, ["Fly|Ride"] = 535.44, ["Neon"] = 242.41, ["Neon|Ride"] = 414.2, ["Mega|Ride"] = 1712.55, ["Mega|Fly|Ride"] = 1999.41}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 587.46, ["Ride"] = 39.38, ["Neon"] = 3.94, ["Neon|Ride"] = 42.82, ["Neon|Fly|Ride"] = 114.54, ["Mega"] = 45.92, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 139.16, ["Mega|Fly|Ride"] = 237.63}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 24.67, ["Ride"] = 19.49, ["Fly|Ride"] = 96.78, ["Neon"] = 8.58, ["Neon|Fly"] = 42, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 67.45, ["Mega"] = 59.13, ["Mega|Fly"] = 149, ["Mega|Ride"] = 121.14, ["Mega|Fly|Ride"] = 219.19}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 7.79, ["Fly"] = 57.91, ["Ride"] = 26.25, ["Fly|Ride"] = 170.28, ["Neon"] = 80.07, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 156.29, ["Mega"] = 328.01, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 295.32}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 6.14, ["Fly"] = 65.63, ["Ride"] = 27.26, ["Fly|Ride"] = 67.81, ["Neon"] = 65.45, ["Neon|Ride"] = 77.21, ["Neon|Fly|Ride"] = 145.69, ["Mega"] = 749.25, ["Mega|Ride"] = 452.78, ["Mega|Fly|Ride"] = 852.01}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 21.38, ["Fly"] = 48.57, ["Ride"] = 27.99, ["Fly|Ride"] = 65.63, ["Neon"] = 79.75, ["Neon|Ride"] = 76.12, ["Neon|Fly|Ride"] = 149.44, ["Mega"] = 408.98, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 379.32}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 58.56, ["Ride"] = 126, ["Fly|Ride"] = 246.75, ["Neon"] = 308.43, ["Neon|Ride"] = 283.48, ["Neon|Fly|Ride"] = 420, ["Mega"] = 1575, ["Mega|Ride"] = 1356.14, ["Mega|Fly|Ride"] = 1527.39}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 7.77, ["Ride"] = 115.4, ["Fly|Ride"] = 203.44, ["Neon"] = 55.13, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 299.25, ["Mega"] = 239.09, ["Mega|Fly"] = 568.37, ["Mega|Ride"] = 379.99, ["Mega|Fly|Ride"] = 554.46}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 3.63, ["Ride"] = 27.29, ["Fly|Ride"] = 78.74, ["Neon"] = 23.08, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 141.89, ["Mega|Ride"] = 240.84, ["Mega|Fly|Ride"] = 335.99}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 10.06, ["Fly"] = 135.19, ["Ride"] = 36.36, ["Fly|Ride"] = 115.5, ["Neon"] = 57.63, ["Neon|Ride"] = 59.64, ["Mega"] = 453.04, ["Mega|Fly|Ride"] = 856.28}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.74, ["Ride"] = 15.49, ["Fly|Ride"] = 41.4, ["Neon"] = 2.1, ["Neon|Fly"] = 21.69, ["Neon|Ride"] = 15.74, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 15.63, ["Mega|Ride"] = 26.51, ["Mega|Fly|Ride"] = 114.33}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 49.97, ["Ride"] = 103.69, ["Fly|Ride"] = 131.25, ["Neon"] = 236.25, ["Neon|Fly"] = 2426.19, ["Neon|Ride"] = 294, ["Neon|Fly|Ride"] = 1292.47, ["Mega"] = 1067.15, ["Mega|Ride"] = 1057.51, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 21.53, ["Fly|Ride"] = 112.22, ["Neon"] = 6.09, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 31.4, ["Mega|Ride"] = 86.02, ["Mega|Fly|Ride"] = 313.68}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 29.06, ["Ride"] = 13.13, ["Fly|Ride"] = 45.94, ["Neon"] = 13.13, ["Neon|Ride"] = 28.76, ["Neon|Fly|Ride"] = 90.03, ["Mega"] = 257.25, ["Mega|Ride"] = 194.9, ["Mega|Fly|Ride"] = 228.38}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 53.45, ["Ride"] = 87.94, ["Fly|Ride"] = 118.13, ["Neon"] = 225.65, ["Neon|Ride"] = 259.88, ["Neon|Fly|Ride"] = 354.31, ["Mega"] = 1142.08, ["Mega|Ride"] = 986.02, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 72.19, ["Neon"] = 8.07, ["Neon|Ride"] = 1427.69, ["Mega"] = 71.72, ["Mega|Fly"] = 143.43, ["Mega|Ride"] = 113.88, ["Mega|Fly|Ride"] = 256.9}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 7.71}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 24.62, ["Fly|Ride"] = 64.26, ["Neon"] = 7.33, ["Neon|Ride"] = 84.55, ["Neon|Fly|Ride"] = 81.38, ["Mega"] = 78.73, ["Mega|Ride"] = 105.23, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 131.04, ["Ride"] = 181.81, ["Fly|Ride"] = 336.27, ["Neon"] = 873.83, ["Neon|Ride"] = 592.77, ["Neon|Fly|Ride"] = 671.77, ["Mega"] = 6422.07, ["Mega|Ride"] = 2854.61, ["Mega|Fly|Ride"] = 2610.58}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 2.1, ["Ride"] = 36.43, ["Fly|Ride"] = 121.21, ["Neon"] = 21.95, ["Neon|Fly"] = 143.51, ["Neon|Ride"] = 63.16, ["Neon|Fly|Ride"] = 219.43, ["Mega"] = 178.5, ["Mega|Ride"] = 211.91, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 26.24, ["Neon"] = 2.1, ["Neon|Ride"] = 24.93, ["Mega"] = 33.5, ["Mega|Ride"] = 71.72, ["Mega|Fly|Ride"] = 342.53}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 5.75, ["Fly"] = 18.38, ["Ride"] = 32.48, ["Fly|Ride"] = 98.44, ["Neon"] = 56.99, ["Neon|Ride"] = 88.85, ["Neon|Fly|Ride"] = 146.86, ["Mega"] = 428.15, ["Mega|Ride"] = 428.15, ["Mega|Fly|Ride"] = 641.16}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 8.6, ["Fly"] = 57.31, ["Ride"] = 21.44, ["Fly|Ride"] = 57.84, ["Neon"] = 101.03, ["Neon|Ride"] = 158.16, ["Neon|Fly|Ride"] = 276.29, ["Mega"] = 626.07, ["Mega|Ride"] = 636.87, ["Mega|Fly|Ride"] = 357.52}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 17.99, ["Fly"] = 144.16, ["Ride"] = 51.98, ["Fly|Ride"] = 177.19, ["Neon"] = 127.32, ["Neon|Ride"] = 201.22, ["Neon|Fly|Ride"] = 1575, ["Mega"] = 561.75, ["Mega|Ride"] = 641.16, ["Mega|Fly|Ride"] = 599.82}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 150.94, ["Fly"] = 196.77, ["Ride"] = 157.4, ["Fly|Ride"] = 241.69, ["Neon"] = 565.13, ["Neon|Fly"] = 687.19, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 643.02, ["Mega|Ride"] = 2568.83, ["Mega|Fly|Ride"] = 2584.93}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 3.94, ["Fly"] = 20.98, ["Ride"] = 18.84, ["Fly|Ride"] = 31.5, ["Neon"] = 44.33, ["Neon|Fly"] = 158.79, ["Neon|Ride"] = 44.01, ["Neon|Fly|Ride"] = 77.53, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 416.07}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.63, ["Fly"] = 131.23, ["Ride"] = 25.85, ["Fly|Ride"] = 131.25, ["Neon"] = 19.9, ["Neon|Ride"] = 34.73, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 126.56, ["Mega|Ride"] = 183.04, ["Mega|Fly|Ride"] = 291.98}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 3.19, ["Fly"] = 42.78, ["Ride"] = 40.68, ["Fly|Ride"] = 128.51, ["Neon"] = 51.18, ["Neon|Fly"] = 128.63, ["Neon|Ride"] = 57.82, ["Neon|Fly|Ride"] = 162.31, ["Mega"] = 429.66, ["Mega|Ride"] = 401.97, ["Mega|Fly|Ride"] = 713.93}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 40.74, ["Fly"] = 115.12, ["Ride"] = 79.01, ["Fly|Ride"] = 134.37, ["Neon"] = 170.61, ["Neon|Ride"] = 259.87, ["Neon|Fly|Ride"] = 261.18, ["Mega"] = 957.97, ["Mega|Ride"] = 925.32, ["Mega|Fly|Ride"] = 958.1}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 20.35, ["Fly"] = 57.75, ["Ride"] = 72.66, ["Neon"] = 196.88, ["Neon|Ride"] = 228.38, ["Neon|Fly|Ride"] = 472.03, ["Mega"] = 799.56, ["Mega|Ride"] = 1932}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 328.02, ["Ride"] = 571.85, ["Neon|Ride"] = 3230.04}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 19.74, ["Fly"] = 58.63, ["Ride"] = 33.76, ["Fly|Ride"] = 69.3, ["Neon"] = 248.46, ["Neon|Ride"] = 215.24, ["Neon|Fly|Ride"] = 249.54, ["Mega"] = 761.25, ["Mega|Ride"] = 753.27, ["Mega|Fly|Ride"] = 1070.36}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 43.32, ["Ride"] = 12.74, ["Fly|Ride"] = 71.76, ["Neon"] = 2.1, ["Neon|Ride"] = 15.99, ["Neon|Fly|Ride"] = 53.82, ["Mega"] = 20.35, ["Mega|Fly"] = 113.47, ["Mega|Ride"] = 47.16, ["Mega|Fly|Ride"] = 115.31}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 2.1, ["Ride"] = 41.1, ["Neon"] = 9.19, ["Neon|Ride"] = 42.82, ["Neon|Fly|Ride"] = 143.43, ["Mega"] = 114.54, ["Mega|Ride"] = 164.17, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 3.19, ["Fly"] = 32.45, ["Ride"] = 30.19, ["Fly|Ride"] = 144.2, ["Neon"] = 21.18, ["Neon|Fly"] = 87.94, ["Neon|Ride"] = 57.82, ["Neon|Fly|Ride"] = 1181.23, ["Mega"] = 130.56, ["Mega|Fly"] = 575.01, ["Mega|Ride"] = 320.04, ["Mega|Fly|Ride"] = 341.92}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 328.13, ["Fly"] = 505.32, ["Ride"] = 418.69, ["Fly|Ride"] = 528.94, ["Neon"] = 1898.49, ["Neon|Ride"] = 2052.69, ["Neon|Fly|Ride"] = 1246.88, ["Mega|Fly|Ride"] = 5563.65}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.1, ["Ride"] = 16.69, ["Fly|Ride"] = 49.27, ["Neon"] = 19.69, ["Neon|Ride"] = 28.92, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 205.96, ["Mega|Ride"] = 179.29, ["Mega|Fly|Ride"] = 231}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 3.93, ["Fly"] = 21.53, ["Ride"] = 19.5, ["Fly|Ride"] = 44.37, ["Neon"] = 28.93, ["Neon|Fly"] = 156.45, ["Neon|Ride"] = 59.95, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 162.33, ["Mega|Ride"] = 290.08, ["Mega|Fly|Ride"] = 285.55}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 2.1, ["Fly"] = 45.82, ["Ride"] = 23.63, ["Fly|Ride"] = 52.92, ["Neon"] = 11.96, ["Neon|Fly"] = 94.48, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 109.6, ["Mega"] = 143.43, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 28.66, ["Fly"] = 48.7, ["Ride"] = 32.82, ["Fly|Ride"] = 65.63, ["Neon"] = 220.4, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 320.04, ["Mega"] = 713.93, ["Mega|Ride"] = 862.32, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 53.81, ["Ride"] = 36.59, ["Fly|Ride"] = 51.75, ["Neon"] = 11.46, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 210, ["Mega"] = 165.4, ["Mega|Ride"] = 457.79, ["Mega|Fly|Ride"] = 919.42}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 7.88, ["Fly"] = 65.61, ["Ride"] = 49.83, ["Fly|Ride"] = 100.68, ["Neon"] = 168.9, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 236.25, ["Mega|Fly|Ride"] = 778.16}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 16.58, ["Neon"] = 3.83, ["Neon|Ride"] = 25.83, ["Neon|Fly|Ride"] = 96.92, ["Mega"] = 54.85, ["Mega|Ride"] = 118.37, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 4.79, ["Fly"] = 72.19, ["Ride"] = 143.51, ["Neon"] = 46.59, ["Mega"] = 136.02, ["Mega|Ride"] = 323.44, ["Mega|Fly|Ride"] = 761.92}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 10.2, ["Ride"] = 77.12, ["Neon"] = 62.12, ["Neon|Ride"] = 285.76, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 315.77, ["Mega|Ride"] = 555.52, ["Mega|Fly|Ride"] = 463.32}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 7.37, ["Fly"] = 37.74, ["Ride"] = 22.14, ["Fly|Ride"] = 52.62, ["Neon"] = 55.01, ["Neon|Fly"] = 113.87, ["Neon|Ride"] = 55.13, ["Neon|Fly|Ride"] = 126.04, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 447.51, ["Fly"] = 524.06, ["Ride"] = 471.68, ["Fly|Ride"] = 482.9, ["Neon"] = 1659, ["Neon|Ride"] = 3570, ["Neon|Fly|Ride"] = 1640.63}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 15.75, ["Fly|Ride"] = 39.35, ["Neon"] = 35.44, ["Neon|Fly"] = 81.21, ["Neon|Ride"] = 32.28, ["Neon|Fly|Ride"] = 184.42, ["Mega"] = 229.07, ["Mega|Ride"] = 196.77, ["Mega|Fly|Ride"] = 304.04}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 5.07, ["Fly"] = 64.56, ["Ride"] = 64.56, ["Fly|Ride"] = 188.64, ["Neon"] = 102.61, ["Neon|Ride"] = 123.46, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 308.44, ["Mega|Fly"] = 713.93, ["Mega|Ride"] = 420}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 19.95, ["Ride"] = 89.25, ["Fly|Ride"] = 320.2, ["Neon"] = 89.34, ["Neon|Ride"] = 213.94, ["Neon|Fly|Ride"] = 366.09, ["Mega"] = 288.75, ["Mega|Ride"] = 363.57, ["Mega|Fly|Ride"] = 490.92}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 60.8, ["Fly"] = 151.41, ["Ride"] = 94.4, ["Fly|Ride"] = 131.25, ["Neon"] = 321.57, ["Neon|Ride"] = 334.68, ["Neon|Fly|Ride"] = 380.63, ["Mega"] = 2584.93, ["Mega|Fly|Ride"] = 1739.77}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 6.54, ["Ride"] = 27.57, ["Fly|Ride"] = 144.37, ["Neon"] = 31.08, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 171.27, ["Mega"] = 144.27, ["Mega|Ride"] = 193.85, ["Mega|Fly|Ride"] = 339.19}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 21.53, ["Ride"] = 18.38, ["Fly|Ride"] = 58.47, ["Neon"] = 18.11, ["Neon|Ride"] = 33.53, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 65.62, ["Mega|Ride"] = 193.82, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 5.84, ["Ride"] = 45.83, ["Neon"] = 19.69, ["Neon|Ride"] = 107.04, ["Neon|Fly|Ride"] = 185.24, ["Mega"] = 176.77, ["Mega|Fly"] = 242.99, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 282.35}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 40.36, ["Fly"] = 137.82, ["Ride"] = 93.19, ["Fly|Ride"] = 183.74, ["Neon"] = 133.35, ["Neon|Ride"] = 162.75, ["Neon|Fly|Ride"] = 252, ["Mega"] = 441, ["Mega|Ride"] = 455.32, ["Mega|Fly|Ride"] = 565.69}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.1, ["Ride"] = 84.41, ["Neon"] = 6.36, ["Neon|Ride"] = 90.57, ["Neon|Fly|Ride"] = 211.32, ["Mega"] = 40.69, ["Mega|Fly"] = 143.43, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 285.8}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 17.22, ["Ride"] = 214.18, ["Neon"] = 162.42, ["Neon|Ride"] = 374.07, ["Mega"] = 589.32, ["Mega|Fly|Ride"] = 796.35}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 1023.75, ["Fly"] = 1194.38, ["Ride"] = 1006.43, ["Fly|Ride"] = 1123.4, ["Neon|Ride"] = 2756.25, ["Neon|Fly|Ride"] = 3638.11, ["Mega|Fly|Ride"] = 10947.47}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 7.66, ["Fly"] = 112.17, ["Ride"] = 42.86, ["Fly|Ride"] = 168.05, ["Neon"] = 64.31, ["Neon|Fly"] = 713.21, ["Neon|Ride"] = 174.01, ["Neon|Fly|Ride"] = 392.44, ["Mega"] = 363.41, ["Mega|Ride"] = 328.27, ["Mega|Fly|Ride"] = 592.99}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.1, ["Fly"] = 49.37, ["Ride"] = 19.91, ["Fly|Ride"] = 91.49, ["Neon"] = 10.66, ["Neon|Fly"] = 79.83, ["Neon|Ride"] = 32.71, ["Neon|Fly|Ride"] = 94.76, ["Mega"] = 82.69, ["Mega|Ride"] = 84.03, ["Mega|Fly|Ride"] = 229.07}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 10.39, ["Ride"] = 28.93, ["Fly|Ride"] = 143.51, ["Neon"] = 72.74, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 393.73, ["Mega"] = 288.73, ["Mega|Ride"] = 406.74, ["Mega|Fly|Ride"] = 482.11}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 23.39, ["Fly|Ride"] = 187.7, ["Neon"] = 2.1, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 93.19, ["Mega"] = 16.26, ["Mega|Ride"] = 49.26, ["Mega|Fly|Ride"] = 153.13}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 52.84, ["Ride"] = 101.24, ["Fly|Ride"] = 229.18, ["Neon"] = 226.96, ["Neon|Ride"] = 268.7, ["Neon|Fly|Ride"] = 385.33, ["Mega"] = 1112.1, ["Mega|Ride"] = 879.37, ["Mega|Fly|Ride"] = 925.32}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 8.22, ["Ride"] = 62.88, ["Fly|Ride"] = 283.87, ["Neon"] = 114.6, ["Neon|Ride"] = 328.12, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 418.69, ["Mega|Ride"] = 820.97, ["Mega|Fly|Ride"] = 735}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2.1, ["Ride"] = 23.61, ["Neon"] = 9.97, ["Neon|Ride"] = 38.98, ["Mega"] = 96.92, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 371.42}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 14.44, ["Fly"] = 52.5, ["Ride"] = 36.75, ["Fly|Ride"] = 91.77, ["Neon"] = 73.38, ["Neon|Ride"] = 94.5, ["Neon|Fly|Ride"] = 267.71, ["Mega"] = 409.17, ["Mega|Ride"] = 419.99, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 2.77, ["Fly"] = 96.83, ["Ride"] = 27.85, ["Fly|Ride"] = 171.35, ["Neon"] = 143.51, ["Neon|Fly"] = 129.69, ["Neon|Ride"] = 81.17, ["Neon|Fly|Ride"] = 144.18, ["Mega"] = 428.15, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 1090.46}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 39.38, ["Ride"] = 91.88, ["Neon"] = 214.18, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 2100.4, ["Mega|Ride"] = 2422.62, ["Mega|Fly|Ride"] = 2138.55}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 3.62, ["Ride"] = 28.93, ["Fly|Ride"] = 183.65, ["Neon"] = 15.62, ["Neon|Ride"] = 90.85, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 70.66, ["Mega|Ride"] = 96.92, ["Mega|Fly|Ride"] = 229.69}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 5.25, ["Ride"] = 30.82, ["Fly|Ride"] = 90.57, ["Neon"] = 45.09, ["Neon|Fly"] = 186.34, ["Neon|Ride"] = 68.53, ["Neon|Fly|Ride"] = 100.56, ["Mega"] = 261.19, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 382.59}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 118.01, ["Fly"] = 393.75, ["Ride"] = 170.63, ["Fly|Ride"] = 221.82, ["Neon"] = 427.43, ["Neon|Ride"] = 543.17, ["Neon|Fly|Ride"] = 636.38, ["Mega|Ride"] = 1834.96, ["Mega|Fly|Ride"] = 2072.44}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 19.5, ["Ride"] = 17.55, ["Fly|Ride"] = 43.19, ["Neon"] = 13.02, ["Neon|Fly"] = 57.32, ["Neon|Ride"] = 26.22, ["Neon|Fly|Ride"] = 122.14, ["Mega"] = 145.69, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 188.9}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 17.07, ["Fly"] = 201.38, ["Ride"] = 61.14, ["Fly|Ride"] = 131.25, ["Neon"] = 116.55, ["Neon|Ride"] = 123.5, ["Neon|Fly|Ride"] = 261.19, ["Mega"] = 551.25, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 675.94}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 18.27, ["Ride"] = 15.75, ["Fly|Ride"] = 59.07, ["Neon"] = 2.1, ["Neon|Fly"] = 28.25, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 47.25, ["Mega"] = 15.57, ["Mega|Fly"] = 48.46, ["Mega|Ride"] = 33.99, ["Mega|Fly|Ride"] = 81.18}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 57.84, ["Neon"] = 4.16, ["Neon|Ride"] = 42.82, ["Neon|Fly|Ride"] = 128.45, ["Mega"] = 20.9, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 159.41}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.1, ["Fly"] = 36.59, ["Ride"] = 19.08, ["Fly|Ride"] = 173.35, ["Neon"] = 14.65, ["Neon|Ride"] = 58.31, ["Neon|Fly|Ride"] = 100.63, ["Mega"] = 105, ["Mega|Ride"] = 287.56, ["Mega|Fly|Ride"] = 246.1}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 28.69, ["Ride"] = 59.07, ["Fly|Ride"] = 131.25, ["Neon"] = 132.55, ["Neon|Ride"] = 342.48, ["Neon|Fly|Ride"] = 407.52, ["Mega"] = 511.88, ["Mega|Ride"] = 641.16, ["Mega|Fly|Ride"] = 856.28}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.1, ["Fly"] = 16.15, ["Ride"] = 15.71, ["Fly|Ride"] = 35.34, ["Neon"] = 11.45, ["Neon|Fly"] = 31.53, ["Neon|Ride"] = 26.23, ["Neon|Fly|Ride"] = 36.75, ["Mega"] = 120.65, ["Mega|Fly"] = 267.22, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 173.65}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 6.09, ["Fly"] = 43.24, ["Ride"] = 32.55, ["Fly|Ride"] = 99.57, ["Neon"] = 32.82, ["Neon|Fly"] = 86.63, ["Neon|Ride"] = 52.41, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 246.88, ["Mega|Fly"] = 433.13, ["Mega|Ride"] = 256.9, ["Mega|Fly|Ride"] = 335}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 20.35, ["Fly|Ride"] = 67.92, ["Neon"] = 11.46, ["Neon|Fly"] = 98.42, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 89.24, ["Mega"] = 47.23, ["Mega|Fly"] = 82.17, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 131.15}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 10.23, ["Fly"] = 169.32, ["Ride"] = 24.68, ["Fly|Ride"] = 217.2, ["Neon"] = 36.89, ["Neon|Ride"] = 88.55, ["Neon|Fly|Ride"] = 285.8, ["Mega"] = 315.77, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 400.32, ["Mega|Fly|Ride"] = 417.45}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 2.1, ["Ride"] = 189.93, ["Fly|Ride"] = 142.38, ["Neon"] = 51.08, ["Neon|Ride"] = 140.04, ["Neon|Fly|Ride"] = 259.88, ["Mega"] = 216.57, ["Mega|Ride"] = 303.19, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 2.42, ["Fly"] = 39.8, ["Ride"] = 18.01, ["Fly|Ride"] = 51.35, ["Neon"] = 35.44, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 39.45, ["Neon|Fly|Ride"] = 145.3, ["Mega"] = 262.5, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 285.8, ["Mega|Fly|Ride"] = 571.58}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 24.86, ["Ride"] = 19.29, ["Fly|Ride"] = 52.55, ["Neon"] = 16.96, ["Neon|Fly"] = 70.51, ["Neon|Ride"] = 25.92, ["Neon|Fly|Ride"] = 82.69, ["Mega"] = 187.32, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 170.52}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 220.87, ["Fly"] = 393.75, ["Ride"] = 255.94, ["Fly|Ride"] = 363.6, ["Neon"] = 1267.91, ["Neon|Ride"] = 1211.12, ["Neon|Fly|Ride"] = 1174.69, ["Mega"] = 4199.6, ["Mega|Fly|Ride"] = 4117.32}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 3.93, ["Ride"] = 65.63, ["Neon"] = 21.05, ["Neon|Ride"] = 45.94, ["Mega"] = 123.38, ["Mega|Ride"] = 646.86, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 2.52, ["Fly"] = 107.59, ["Ride"] = 24.68, ["Fly|Ride"] = 86.63, ["Neon"] = 30.19, ["Neon|Fly"] = 243.1, ["Neon|Ride"] = 64.97, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 229.64, ["Mega|Ride"] = 196.87, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 3.63, ["Fly|Ride"] = 216.61, ["Neon"] = 38.04, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 603.74, ["Mega"] = 486.29, ["Mega|Ride"] = 404.59, ["Mega|Fly|Ride"] = 416.73}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 16.17, ["Ride"] = 13.8, ["Fly|Ride"] = 39.29, ["Neon"] = 2.1, ["Neon|Fly"] = 42.86, ["Neon|Ride"] = 18.18, ["Neon|Fly|Ride"] = 42.82, ["Mega"] = 18.98, ["Mega|Fly"] = 79.22, ["Mega|Ride"] = 42.41, ["Mega|Fly|Ride"] = 72.17}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.1, ["Fly"] = 44.63, ["Ride"] = 23.5, ["Fly|Ride"] = 40.7, ["Neon"] = 18.06, ["Neon|Ride"] = 21.65, ["Neon|Fly|Ride"] = 89.25, ["Mega"] = 132.57, ["Mega|Ride"] = 140.44, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.1, ["Ride"] = 119.85, ["Neon"] = 10.4, ["Neon|Ride"] = 284.69, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 41.2, ["Mega|Ride"] = 167.99, ["Mega|Fly|Ride"] = 276.94}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 74.08, ["Fly"] = 104.99, ["Ride"] = 98.41, ["Fly|Ride"] = 162.1, ["Neon"] = 315, ["Neon|Fly"] = 534.48, ["Neon|Ride"] = 368.82, ["Neon|Fly|Ride"] = 477.75, ["Mega|Ride"] = 3569.61, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 2.63, ["Fly"] = 72.09, ["Ride"] = 26.24, ["Fly|Ride"] = 141.73, ["Neon"] = 13.02, ["Neon|Ride"] = 68.16, ["Mega"] = 169.3, ["Mega|Ride"] = 213.94}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 49.49, ["Ride"] = 34.12, ["Neon"] = 6.99, ["Neon|Ride"] = 81.17, ["Neon|Fly|Ride"] = 143.43, ["Mega"] = 55.78, ["Mega|Fly"] = 314.99, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 46.77, ["Fly"] = 131.25, ["Ride"] = 91.88, ["Fly|Ride"] = 199.5, ["Neon"] = 145.04, ["Neon|Ride"] = 174.39, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 525, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 669.38}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 15.6, ["Ride"] = 18.8, ["Fly|Ride"] = 43.28, ["Neon"] = 2.1, ["Neon|Fly"] = 21.84, ["Neon|Ride"] = 16.59, ["Neon|Fly|Ride"] = 36.57, ["Mega"] = 17.06, ["Mega|Fly"] = 46.91, ["Mega|Ride"] = 34.13, ["Mega|Fly|Ride"] = 81.18}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 46.86, ["Fly|Ride"] = 98.53, ["Neon"] = 2.1, ["Neon|Ride"] = 30.07, ["Neon|Fly|Ride"] = 141.45, ["Mega"] = 24.43, ["Mega|Ride"] = 78.56, ["Mega|Fly|Ride"] = 221.68}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.1, ["Fly"] = 33.12, ["Ride"] = 66.23, ["Fly|Ride"] = 59.01, ["Neon"] = 9.19, ["Neon|Ride"] = 91.77, ["Neon|Fly|Ride"] = 288.65, ["Mega"] = 49.65, ["Mega|Fly"] = 186.25, ["Mega|Ride"] = 117.8}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 7.4, ["Fly"] = 86.58, ["Ride"] = 42.76, ["Fly|Ride"] = 129.65, ["Neon"] = 20.36, ["Neon|Fly"] = 122.31, ["Neon|Ride"] = 92.04, ["Neon|Fly|Ride"] = 428.15, ["Mega"] = 136.37, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 192.93, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 21.5, ["Ride"] = 13.49, ["Fly|Ride"] = 38.79, ["Neon"] = 2.1, ["Neon|Fly"] = 24.64, ["Neon|Ride"] = 24.23, ["Neon|Fly|Ride"] = 49.73, ["Mega"] = 19.03, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 117.79}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 20, ["Fly"] = 131.25, ["Ride"] = 53.82, ["Neon"] = 128.63, ["Neon|Ride"] = 190.59, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 713.93, ["Mega|Fly"] = 642.22, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 790.99}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2527.89, ["Fly"] = 3150, ["Ride"] = 2383.18, ["Fly|Ride"] = 2231.25, ["Neon|Fly|Ride"] = 7415.63, ["Mega|Fly|Ride"] = 43606.82}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 45.92, ["Ride"] = 18.41, ["Fly|Ride"] = 44.63, ["Neon"] = 6.44, ["Neon|Fly"] = 58.46, ["Neon|Ride"] = 24.23, ["Neon|Fly|Ride"] = 52.49, ["Mega"] = 79.22, ["Mega|Fly"] = 428.15, ["Mega|Ride"] = 97.13, ["Mega|Fly|Ride"] = 171.94}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.1, ["Ride"] = 27.85, ["Neon"] = 8.82, ["Mega"] = 100.68, ["Mega|Fly"] = 441, ["Mega|Ride"] = 164.07, ["Mega|Fly|Ride"] = 428.15}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 15.4, ["Fly"] = 144.16, ["Ride"] = 31.49, ["Fly|Ride"] = 131.25, ["Neon"] = 81.37, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 229.69, ["Mega"] = 393.75, ["Mega|Ride"] = 405.42, ["Mega|Fly|Ride"] = 573.61}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 32.84, ["Fly"] = 107.59, ["Ride"] = 66.66, ["Neon"] = 140.44, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 1284.43, ["Mega|Ride"] = 612.25, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 143.07, ["Fly"] = 1434.99, ["Ride"] = 183.64, ["Fly|Ride"] = 266.44, ["Neon"] = 1210.74, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 652.32, ["Mega"] = 6422.07, ["Mega|Fly|Ride"] = 4127.82}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 3.92, ["Ride"] = 65.54, ["Fly|Ride"] = 675.94, ["Neon"] = 26.23, ["Neon|Ride"] = 143.42, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 144.45, ["Mega|Fly|Ride"] = 428.15}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 36.59, ["Neon"] = 14.6, ["Neon|Ride"] = 114.85, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 179.82, ["Mega|Ride"] = 330.65, ["Mega|Fly|Ride"] = 267.09}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Fly"] = 101.13, ["Ride"] = 33.49, ["Fly|Ride"] = 74.97, ["Neon"] = 12.75, ["Neon|Fly"] = 126.37, ["Neon|Ride"] = 36.39, ["Mega"] = 63, ["Mega|Ride"] = 113.8, ["Mega|Fly|Ride"] = 227.39}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 11.08, ["Ride"] = 51.89, ["Fly|Ride"] = 131.25, ["Neon"] = 108.12, ["Neon|Ride"] = 176.84, ["Neon|Fly|Ride"] = 504.14, ["Mega"] = 420, ["Mega|Ride"] = 325.17, ["Mega|Fly|Ride"] = 591.29}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 36.71, ["Mega"] = 32.82, ["Mega|Fly"] = 121.14, ["Mega|Ride"] = 75.13, ["Mega|Fly|Ride"] = 135.19}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 92.26, ["Fly"] = 201.16, ["Ride"] = 127.31, ["Fly|Ride"] = 137.62, ["Neon"] = 304.5, ["Neon|Fly"] = 458.34, ["Neon|Ride"] = 399.68, ["Neon|Fly|Ride"] = 444.56, ["Mega"] = 3211.04, ["Mega|Fly|Ride"] = 1420.36}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Fly"] = 29.06, ["Ride"] = 91.84, ["Fly|Ride"] = 78.75, ["Neon"] = 8.71, ["Neon|Ride"] = 143.42, ["Neon|Fly|Ride"] = 214.09, ["Mega"] = 62.37, ["Mega|Ride"] = 276.29, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 44.44, ["Fly"] = 144.16, ["Ride"] = 98.44, ["Fly|Ride"] = 170.62, ["Neon"] = 236.25, ["Neon|Ride"] = 229.69, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 2625, ["Mega|Ride"] = 1999.41, ["Mega|Fly|Ride"] = 1855.98}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 27.57, ["Ride"] = 23.24, ["Fly|Ride"] = 52.13, ["Neon"] = 4.34, ["Neon|Fly"] = 84.84, ["Neon|Ride"] = 71.72, ["Neon|Fly|Ride"] = 114.54, ["Mega"] = 57.82, ["Mega|Ride"] = 103.69, ["Mega|Fly|Ride"] = 170.52}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Neon"] = 11.5, ["Neon|Ride"] = 111.57, ["Mega"] = 62.91, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 3.94, ["Fly"] = 77.43, ["Ride"] = 37.04, ["Fly|Ride"] = 90.57, ["Neon"] = 19.69, ["Neon|Ride"] = 72.45, ["Mega"] = 433.13, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 535.19}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 359.63, ["Fly"] = 730.34, ["Ride"] = 418.43, ["Fly|Ride"] = 510.46, ["Neon"] = 918.74, ["Neon|Ride"] = 971.25, ["Neon|Fly|Ride"] = 918.75, ["Mega|Ride"] = 3130.32, ["Mega|Fly|Ride"] = 3089.82}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 25.47, ["Fly"] = 86.07, ["Ride"] = 47.14, ["Fly|Ride"] = 116.71, ["Neon"] = 154.52, ["Neon|Ride"] = 214.07, ["Neon|Fly|Ride"] = 190.38, ["Mega|Ride"] = 1142.08, ["Mega|Fly|Ride"] = 1055.38}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 30.56, ["Fly|Ride"] = 126, ["Neon"] = 22.31, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 36.12, ["Neon|Fly|Ride"] = 131.06, ["Mega"] = 169.31, ["Mega|Ride"] = 262.48, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 20.24, ["Fly"] = 111.45, ["Ride"] = 57.84, ["Fly|Ride"] = 227.06, ["Neon"] = 73.97, ["Neon|Fly"] = 177.19, ["Neon|Ride"] = 145.59, ["Neon|Fly|Ride"] = 240.19, ["Mega"] = 357.52, ["Mega|Fly"] = 996.91, ["Mega|Ride"] = 459.1, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 5.19, ["Ride"] = 27.85, ["Neon"] = 101.36, ["Neon|Ride"] = 135.94, ["Neon|Fly|Ride"] = 484.53, ["Mega"] = 525, ["Mega|Ride"] = 691.69, ["Mega|Fly|Ride"] = 311.07}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 2.1, ["Neon"] = 26.17, ["Mega"] = 80.99, ["Mega|Ride"] = 332.68, ["Mega|Fly|Ride"] = 427.08}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.1, ["Fly"] = 72.09, ["Ride"] = 22.31, ["Fly|Ride"] = 65.62, ["Neon"] = 56.97, ["Neon|Fly"] = 85.68, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 212.14, ["Mega"] = 213.94, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 82.74, ["Ride"] = 119.43, ["Fly|Ride"] = 229.32, ["Neon"] = 809.58, ["Neon|Ride"] = 523.68, ["Neon|Fly|Ride"] = 524.98, ["Mega"] = 2887.5, ["Mega|Ride"] = 2625, ["Mega|Fly|Ride"] = 2988.29}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 18.71, ["Ride"] = 54.44, ["Fly|Ride"] = 131.25, ["Neon"] = 157.38, ["Neon|Ride"] = 171.25, ["Neon|Fly|Ride"] = 315.77, ["Mega"] = 1142.08, ["Mega|Ride"] = 702.57, ["Mega|Fly|Ride"] = 807.95}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 1836.19, ["Fly"] = 2311.32, ["Ride"] = 1706.25, ["Fly|Ride"] = 1896.57, ["Neon"] = 11422.78, ["Neon|Fly|Ride"] = 7019.25, ["Mega|Fly|Ride"] = 24675}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 2.1, ["Fly"] = 65625, ["Ride"] = 48.67, ["Fly|Ride"] = 196.87, ["Neon"] = 19.69, ["Neon|Ride"] = 51.39, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 140.22, ["Mega|Fly"] = 786.19, ["Mega|Ride"] = 208.15, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 6.15, ["Ride"] = 52.5, ["Fly|Ride"] = 178.85, ["Neon"] = 23.09, ["Neon|Fly"] = 57.84, ["Neon|Ride"] = 89.88, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 144.25, ["Mega|Fly"] = 285.8, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 879.27, ["Ride"] = 918.65, ["Fly|Ride"] = 989.63, ["Neon"] = 2778.57, ["Neon|Ride"] = 3067.09, ["Neon|Fly|Ride"] = 2891.38, ["Mega|Ride"] = 13728.89, ["Mega|Fly|Ride"] = 11987.84}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 27.99, ["Ride"] = 46.56, ["Fly|Ride"] = 173.35, ["Neon"] = 143.51, ["Neon|Ride"] = 214.07, ["Mega"] = 856.28, ["Mega|Ride"] = 840.66, ["Mega|Fly|Ride"] = 835.42}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 2.1, ["Ride"] = 24.94, ["Fly|Ride"] = 118.13, ["Neon"] = 12.29, ["Neon|Ride"] = 64.84, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 157.48, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 143.51, ["Neon"] = 3.75, ["Neon|Fly"] = 126, ["Neon|Ride"] = 27.84, ["Neon|Fly|Ride"] = 112.88, ["Mega"] = 23.23, ["Mega|Ride"] = 61.3, ["Mega|Fly|Ride"] = 162.33}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 78.74, ["Ride"] = 122.96, ["Fly|Ride"] = 170.63, ["Neon"] = 459.38, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 640.5, ["Mega"] = 2422.62, ["Mega|Fly|Ride"] = 2284.13}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 2.1, ["Ride"] = 34.28, ["Fly|Ride"] = 74.97, ["Neon"] = 11.81, ["Neon|Ride"] = 36.37, ["Neon|Fly|Ride"] = 121.12, ["Mega"] = 90.56, ["Mega|Ride"] = 121.14, ["Mega|Fly|Ride"] = 249.57}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 78.64, ["Fly"] = 144.16, ["Ride"] = 102.09, ["Fly|Ride"] = 285.93, ["Neon"] = 428.36, ["Neon|Ride"] = 721.88, ["Mega|Fly|Ride"] = 1746.71}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 4.32, ["Fly"] = 105, ["Fly|Ride"] = 128.51, ["Neon"] = 58.95, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 269.05, ["Mega"] = 328.02, ["Mega|Ride"] = 143.43}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 236.25, ["Ride"] = 279.56, ["Fly|Ride"] = 320.15, ["Neon"] = 1148.82, ["Neon|Fly"] = 1050.76, ["Neon|Ride"] = 1064.88, ["Neon|Fly|Ride"] = 1003.68, ["Mega|Fly|Ride"] = 3852.17}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 2.52, ["Fly"] = 29.06, ["Ride"] = 25.91, ["Fly|Ride"] = 105, ["Neon"] = 40.18, ["Neon|Ride"] = 65.54, ["Neon|Fly|Ride"] = 114.18, ["Mega"] = 259.24, ["Mega|Ride"] = 259.24, ["Mega|Fly|Ride"] = 289.51}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 20.45, ["Ride"] = 16.02, ["Fly|Ride"] = 36.01, ["Neon"] = 3.63, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 21.41, ["Neon|Fly|Ride"] = 59.76, ["Mega"] = 44.62, ["Mega|Fly"] = 100.63, ["Mega|Ride"] = 71.39, ["Mega|Fly|Ride"] = 124.72}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 1233.83, ["Ride"] = 1050, ["Fly|Ride"] = 1254.75, ["Neon|Ride"] = 7848.96, ["Neon|Fly|Ride"] = 6957.24, ["Mega"] = 24226.01, ["Mega|Fly|Ride"] = 28542.81}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 9.86, ["Ride"] = 77.58, ["Neon"] = 103.55, ["Neon|Ride"] = 314.98, ["Mega"] = 320.25, ["Mega|Ride"] = 414.35, ["Mega|Fly|Ride"] = 564.27}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 5.84, ["Fly"] = 39.38, ["Ride"] = 35.39, ["Fly|Ride"] = 78.79, ["Neon"] = 14.44, ["Neon|Fly"] = 101.68, ["Neon|Ride"] = 55.02, ["Neon|Fly|Ride"] = 128.45, ["Mega"] = 143.07, ["Mega|Ride"] = 186.56, ["Mega|Fly|Ride"] = 286.92}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 27.57, ["Fly"] = 47.25, ["Ride"] = 40.05, ["Fly|Ride"] = 77.34, ["Neon"] = 193.92, ["Neon|Ride"] = 188.55, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 2568.83, ["Mega|Ride"] = 1131.37, ["Mega|Fly|Ride"] = 689.37}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 14, ["Fly"] = 71.01, ["Ride"] = 24.64, ["Fly|Ride"] = 53.57, ["Neon"] = 59.06, ["Neon|Ride"] = 102.38, ["Neon|Fly|Ride"] = 182.34, ["Mega"] = 367.5, ["Mega|Ride"] = 282.19, ["Mega|Fly|Ride"] = 431.71}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 47.25, ["Fly|Ride"] = 503.32, ["Neon"] = 236.25, ["Neon|Fly"] = 484.03, ["Neon|Ride"] = 315, ["Mega"] = 1070.36, ["Mega|Ride"] = 1712.55, ["Mega|Fly|Ride"] = 966}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 116.61, ["Fly|Ride"] = 285.93, ["Neon"] = 2.1, ["Neon|Ride"] = 108.52, ["Neon|Fly|Ride"] = 107.05, ["Mega"] = 16.7, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 203.44}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 83.7, ["Fly"] = 91.88, ["Ride"] = 91.76, ["Fly|Ride"] = 182.44, ["Neon"] = 573.02, ["Neon|Fly"] = 490.88, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 525, ["Mega"] = 3425.1, ["Mega|Fly|Ride"] = 1771.88}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 4.31, ["Fly"] = 107.63, ["Ride"] = 19.68, ["Fly|Ride"] = 66.68, ["Neon"] = 198.19, ["Neon|Ride"] = 113.46, ["Mega"] = 773.71, ["Mega|Ride"] = 437.73, ["Mega|Fly|Ride"] = 490.88}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 29.06, ["Ride"] = 18.38, ["Fly|Ride"] = 39.34, ["Neon"] = 15.75, ["Neon|Fly"] = 81.21, ["Neon|Ride"] = 83.5, ["Neon|Fly|Ride"] = 122.85, ["Mega"] = 105.4, ["Mega|Ride"] = 275.07, ["Mega|Fly|Ride"] = 283.5}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 4.32, ["Ride"] = 126, ["Neon"] = 19.29, ["Neon|Fly"] = 141.38, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 214.76}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 83.07, ["Fly"] = 247.55, ["Ride"] = 196.88, ["Fly|Ride"] = 262.5, ["Neon"] = 393.75, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 471.99, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 1999.41, ["Mega|Ride"] = 1603.39, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 2.77, ["Fly|Ride"] = 428.36, ["Neon"] = 7.87, ["Neon|Ride"] = 59.07, ["Mega"] = 138.1, ["Mega|Fly|Ride"] = 323.44}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 37.79, ["Neon"] = 2.1, ["Neon|Ride"] = 118.71, ["Mega"] = 16.94, ["Mega|Ride"] = 210.76, ["Mega|Fly|Ride"] = 535.19}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 102.93, ["Ride"] = 32.81, ["Fly|Ride"] = 144.44, ["Neon"] = 2.1, ["Neon|Fly"] = 86.2, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 20.58, ["Mega|Fly"] = 53.96, ["Mega|Ride"] = 45, ["Mega|Fly|Ride"] = 47.12}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 18.19, ["Fly|Ride"] = 52.41, ["Neon"] = 5.76, ["Neon|Ride"] = 29.3, ["Neon|Fly|Ride"] = 49.4, ["Mega"] = 61.74, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 114.6, ["Neon"] = 24.36, ["Mega"] = 118.11, ["Mega|Ride"] = 122.04, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 39.35, ["Ride"] = 16.59, ["Fly|Ride"] = 38.13, ["Neon"] = 10.4, ["Neon|Fly"] = 85.68, ["Neon|Ride"] = 38.03, ["Neon|Fly|Ride"] = 100.63, ["Mega"] = 178.5, ["Mega|Ride"] = 162.33, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 56.35, ["Ride"] = 107.63, ["Fly|Ride"] = 374.81, ["Neon"] = 289.38, ["Neon|Ride"] = 392.44, ["Neon|Fly|Ride"] = 1070.36, ["Mega"] = 616.88, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 1131.37}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 15.6, ["Fly|Ride"] = 40.63, ["Neon"] = 2.15, ["Neon|Fly"] = 32.24, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 53.53, ["Mega"] = 144.38, ["Mega|Ride"] = 40.69, ["Mega|Fly|Ride"] = 97.13}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 6.45, ["Fly"] = 76.49, ["Ride"] = 32.7, ["Fly|Ride"] = 72.19, ["Neon"] = 40.74, ["Neon|Fly"] = 91.77, ["Neon|Ride"] = 64.03, ["Neon|Fly|Ride"] = 120.75, ["Mega"] = 301.87, ["Mega|Fly"] = 571.58, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 19.38, ["Fly"] = 37.74, ["Ride"] = 49.07, ["Fly|Ride"] = 119.44, ["Neon"] = 166.69, ["Neon|Fly"] = 147, ["Neon|Ride"] = 113.87, ["Neon|Fly|Ride"] = 268.96, ["Mega"] = 713.93, ["Mega|Ride"] = 825.28, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 6.48, ["Fly"] = 196.88, ["Neon"] = 80.01, ["Neon|Ride"] = 103.69, ["Mega"] = 492.19, ["Mega|Ride"] = 448.28, ["Mega|Fly|Ride"] = 556.6}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 18.23, ["Ride"] = 17.04, ["Fly|Ride"] = 38.58, ["Neon"] = 3.56, ["Neon|Fly"] = 28.11, ["Neon|Ride"] = 22.02, ["Neon|Fly|Ride"] = 64.23, ["Mega"] = 45.33, ["Mega|Ride"] = 149, ["Mega|Fly|Ride"] = 122.07}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 6.06, ["Fly"] = 39.38, ["Ride"] = 38.07, ["Neon"] = 73.41, ["Neon|Ride"] = 128.44, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 275.63, ["Mega|Fly"] = 367.14, ["Mega|Ride"] = 484.53, ["Mega|Fly|Ride"] = 542.69}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 977.82, ["Fly"] = 1380.33, ["Ride"] = 980.44, ["Fly|Ride"] = 1089.38, ["Neon|Ride"] = 2744.44, ["Neon|Fly|Ride"] = 2401.88, ["Mega|Fly|Ride"] = 7199.07}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 187.68, ["Ride"] = 262.5, ["Fly|Ride"] = 393.75, ["Neon"] = 840, ["Neon|Ride"] = 807.19, ["Neon|Fly|Ride"] = 853.13, ["Mega"] = 3209.97, ["Mega|Ride"] = 3569.61, ["Mega|Fly|Ride"] = 3352.32}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Fly|Ride"] = 392.44, ["Neon"] = 7.17, ["Neon|Ride"] = 71.72, ["Neon|Fly|Ride"] = 255.83, ["Mega"] = 78.43, ["Mega|Fly|Ride"] = 213.01}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 115.39, ["Ride"] = 131.25, ["Fly|Ride"] = 315, ["Neon"] = 576.19, ["Neon|Ride"] = 538.13, ["Neon|Fly|Ride"] = 781.33, ["Mega"] = 1999.41, ["Mega|Ride"] = 1999.41, ["Mega|Fly|Ride"] = 1903.13}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 2.61, ["Ride"] = 22.57, ["Neon"] = 16.32, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 285.8, ["Mega"] = 115.95, ["Mega|Ride"] = 484.53, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 183.75, ["Fly"] = 430.29, ["Ride"] = 288.74, ["Fly|Ride"] = 376.69, ["Neon"] = 1151.35, ["Neon|Ride"] = 1284.27, ["Neon|Fly|Ride"] = 1405.13, ["Mega|Fly|Ride"] = 4845.21}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 77.18, ["Ride"] = 41.77, ["Fly|Ride"] = 223.25, ["Neon"] = 23.81, ["Neon|Ride"] = 54.37, ["Mega"] = 393.74, ["Mega|Fly"] = 358.58, ["Mega|Ride"] = 428.15}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Fly"] = 29.06, ["Ride"] = 26.25, ["Neon"] = 19.69, ["Mega"] = 249.38, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 13.12, ["Ride"] = 63.59, ["Fly|Ride"] = 143.51, ["Neon"] = 122.72, ["Neon|Fly"] = 428.36, ["Neon|Ride"] = 124.68, ["Mega"] = 773.88, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 49.76, ["Neon"] = 21.44, ["Neon|Ride"] = 196.88, ["Mega"] = 242.27, ["Mega|Ride"] = 254.61, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 16.25, ["Ride"] = 14.34, ["Fly|Ride"] = 32.69, ["Neon"] = 2.1, ["Neon|Fly"] = 20.69, ["Neon|Ride"] = 15.74, ["Neon|Fly|Ride"] = 42, ["Mega"] = 24.47, ["Mega|Ride"] = 38.88, ["Mega|Fly|Ride"] = 101.74}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 5450.54, ["Ride"] = 4461.19, ["Fly|Ride"] = 4987.5, ["Neon"] = 32125.53, ["Neon|Fly|Ride"] = 21406.84, ["Mega|Fly|Ride"] = 52500}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 9.92, ["Fly"] = 86.07, ["Ride"] = 41.91, ["Neon"] = 78.75, ["Neon|Ride"] = 96.9, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 210, ["Mega|Fly"] = 342.53, ["Mega|Ride"] = 215.04, ["Mega|Fly|Ride"] = 357.52}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 24.7, ["Ride"] = 20.68, ["Fly|Ride"] = 51.19, ["Neon"] = 14.44, ["Neon|Fly"] = 45.92, ["Neon|Ride"] = 29.27, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 144.37, ["Mega|Ride"] = 193.82, ["Mega|Fly|Ride"] = 209.81}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 417.38, ["Fly"] = 547.77, ["Ride"] = 476.43, ["Fly|Ride"] = 564.38, ["Neon"] = 2100, ["Neon|Ride"] = 1292.82, ["Neon|Fly|Ride"] = 1200.93, ["Mega|Fly|Ride"] = 4873.32}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 3.71, ["Ride"] = 45.69, ["Neon"] = 13.85, ["Neon|Ride"] = 291.38, ["Mega"] = 187.95, ["Mega|Fly|Ride"] = 693}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 4.29, ["Fly"] = 145.69, ["Ride"] = 36.43, ["Neon"] = 16.08, ["Neon|Ride"] = 119.91, ["Neon|Fly|Ride"] = 229.69, ["Mega"] = 427.08, ["Mega|Ride"] = 357.52}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 51.07, ["Ride"] = 28.93, ["Fly|Ride"] = 65.62, ["Neon"] = 3.83, ["Neon|Fly"] = 124.69, ["Neon|Ride"] = 36.35, ["Neon|Fly|Ride"] = 70.88, ["Mega"] = 53.72, ["Mega|Ride"] = 76.55, ["Mega|Fly|Ride"] = 100.63}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 617.46, ["Fly"] = 751.92, ["Ride"] = 674.62, ["Fly|Ride"] = 688.95, ["Neon|Ride"] = 2126.27, ["Neon|Fly|Ride"] = 2940, ["Mega|Fly|Ride"] = 10703.42}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 7.77, ["Ride"] = 55.13, ["Fly|Ride"] = 160.64, ["Neon"] = 33.51, ["Neon|Fly"] = 114.53, ["Neon|Ride"] = 104.81, ["Neon|Fly|Ride"] = 173.25, ["Mega"] = 209.9, ["Mega|Fly"] = 428.15, ["Mega|Ride"] = 231.97, ["Mega|Fly|Ride"] = 427.67}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 3.94, ["Fly"] = 236.25, ["Ride"] = 46.68, ["Fly|Ride"] = 104.99, ["Neon"] = 26.04, ["Neon|Ride"] = 58.58, ["Neon|Fly|Ride"] = 150.84, ["Mega"] = 162.33, ["Mega|Fly"] = 807.95, ["Mega|Ride"] = 179.3, ["Mega|Fly|Ride"] = 290.07}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 32.1, ["Ride"] = 19.69, ["Fly|Ride"] = 54.68, ["Neon"] = 19.36, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 29.36, ["Neon|Fly|Ride"] = 82.94, ["Mega"] = 285.8, ["Mega|Fly"] = 285.8, ["Mega|Ride"] = 158.42, ["Mega|Fly|Ride"] = 194.25}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 34.13, ["Ride"] = 33.22, ["Fly|Ride"] = 58.61, ["Neon"] = 117.59, ["Neon|Ride"] = 124.69, ["Mega"] = 856.28, ["Mega|Ride"] = 622.13, ["Mega|Fly|Ride"] = 854.15}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Ride"] = 43.31, ["Fly|Ride"] = 81.21, ["Neon"] = 6.14, ["Neon|Ride"] = 49.25, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 32.79, ["Mega|Ride"] = 91.76, ["Mega|Fly|Ride"] = 285.8}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 638.98, ["Fly"] = 708.9, ["Ride"] = 630.19, ["Fly|Ride"] = 630, ["Neon"] = 2589.57, ["Neon|Ride"] = 2283.85, ["Neon|Fly|Ride"] = 2391.38, ["Mega|Ride"] = 9448.16, ["Mega|Fly|Ride"] = 7861.88}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 74.97, ["Neon"] = 14.44, ["Neon|Ride"] = 98.48, ["Neon|Fly|Ride"] = 428.15, ["Mega"] = 213.01, ["Mega|Fly|Ride"] = 253.11}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 48.97, ["Neon"] = 3.71, ["Neon|Fly"] = 243.1, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 53.53, ["Mega|Fly|Ride"] = 288.74}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 60.45, ["Neon"] = 3.3, ["Neon|Ride"] = 56.17, ["Neon|Fly|Ride"] = 143.43, ["Mega"] = 107.05, ["Mega|Fly"] = 158.42, ["Mega|Ride"] = 126.62, ["Mega|Fly|Ride"] = 186.25}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 14.44, ["Neon|Ride"] = 48.45, ["Mega"] = 214.09, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 26.25, ["Fly"] = 72.19, ["Ride"] = 42.39, ["Fly|Ride"] = 205.3, ["Neon"] = 103.83, ["Neon|Ride"] = 164.07, ["Neon|Fly|Ride"] = 393.74, ["Mega"] = 511.88, ["Mega|Ride"] = 507.35, ["Mega|Fly|Ride"] = 556.36}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 12.81, ["Fly"] = 130.27, ["Ride"] = 77.24, ["Fly|Ride"] = 152.09, ["Neon"] = 85.79, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 282.59, ["Mega"] = 534.11, ["Mega|Ride"] = 427.89, ["Mega|Fly|Ride"] = 575.73}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 16.92, ["Fly|Ride"] = 34.23, ["Neon"] = 42.86, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 88.86, ["Mega"] = 298.6, ["Mega|Ride"] = 285.8, ["Mega|Fly|Ride"] = 239.56}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 9.18, ["Ride"] = 58.47, ["Fly|Ride"] = 143.03, ["Neon"] = 38.06, ["Neon|Ride"] = 91.88}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Ride"] = 26.17, ["Fly|Ride"] = 107.1, ["Neon"] = 10.49, ["Neon|Ride"] = 49.25, ["Neon|Fly|Ride"] = 135.95, ["Mega"] = 81.37, ["Mega|Ride"] = 115.5, ["Mega|Fly|Ride"] = 285.8}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 19.99, ["Fly"] = 114.43, ["Ride"] = 32.8, ["Fly|Ride"] = 63.34, ["Neon"] = 110.25, ["Neon|Ride"] = 81.17, ["Neon|Fly|Ride"] = 223.79, ["Mega"] = 742.83, ["Mega|Fly|Ride"] = 748.19}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 30.26, ["Fly"] = 874.13, ["Neon"] = 114.6, ["Mega"] = 332.07, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 50.52, ["Fly"] = 86.63, ["Ride"] = 86.41, ["Fly|Ride"] = 103.69, ["Neon"] = 328.13, ["Neon|Ride"] = 286.4, ["Neon|Fly|Ride"] = 420, ["Mega"] = 1938.09, ["Mega|Fly|Ride"] = 1299.38}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 32.79, ["Fly"] = 139.99, ["Ride"] = 72.19, ["Fly|Ride"] = 131.25, ["Neon"] = 127.32, ["Neon|Ride"] = 144.37, ["Neon|Fly|Ride"] = 309.74, ["Mega"] = 685.04, ["Mega|Ride"] = 828.47, ["Mega|Fly|Ride"] = 849.19}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 16.42, ["Ride"] = 36.43, ["Neon"] = 131.25, ["Neon|Ride"] = 223.12, ["Mega"] = 662.6, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 807.06}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 22.6, ["Fly"] = 81.74, ["Ride"] = 78.75, ["Fly|Ride"] = 248.46, ["Neon"] = 145.26, ["Neon|Fly"] = 257.01, ["Neon|Ride"] = 239.98, ["Neon|Fly|Ride"] = 342.53, ["Mega"] = 687.42, ["Mega|Ride"] = 631.49, ["Mega|Fly|Ride"] = 701.06}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 18.14, ["Ride"] = 16.01, ["Fly|Ride"] = 32.78, ["Neon"] = 2.98, ["Neon|Fly"] = 27.85, ["Neon|Ride"] = 29.22, ["Neon|Fly|Ride"] = 57.82, ["Mega"] = 48.46, ["Mega|Fly"] = 323.44, ["Mega|Ride"] = 65.62, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 866.25}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 65.62, ["Fly"] = 486.9, ["Ride"] = 131.25, ["Fly|Ride"] = 330.75, ["Neon"] = 472.26, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 1443.75, ["Mega|Ride"] = 1569.14, ["Mega|Fly|Ride"] = 1548.75}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 77.37, ["Neon"] = 3.4, ["Neon|Fly"] = 100.62, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 299.71, ["Mega"] = 28.88, ["Mega|Ride"] = 89.66}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 23.6, ["Ride"] = 67.15, ["Neon"] = 158.15, ["Neon|Ride"] = 137, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 591.93, ["Mega|Ride"] = 498.65, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 3.63, ["Neon|Fly|Ride"] = 114.54, ["Mega"] = 21.41, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Ride"] = 74.82, ["Neon"] = 3.92, ["Mega"] = 24.94, ["Mega|Ride"] = 153.05, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 98.33, ["Fly"] = 223.13, ["Ride"] = 141.65, ["Fly|Ride"] = 367.23, ["Neon"] = 437.07, ["Neon|Ride"] = 459.37, ["Neon|Fly|Ride"] = 628.24, ["Mega|Ride"] = 2854.61, ["Mega|Fly|Ride"] = 2093.44}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 90.57, ["Ride"] = 19.48, ["Fly|Ride"] = 96.97, ["Neon"] = 5.2, ["Neon|Fly"] = 42.86, ["Neon|Ride"] = 32.28, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 91.67, ["Mega|Ride"] = 118.12, ["Mega|Fly|Ride"] = 214.09}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Fly|Ride"] = 61.69, ["Neon"] = 5.65, ["Neon|Fly"] = 42.86, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 419.9, ["Mega"] = 32.81, ["Mega|Ride"] = 129.15, ["Mega|Fly|Ride"] = 217.87}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 72.19, ["Neon"] = 5.24, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 236.15, ["Mega"] = 118.13, ["Mega|Ride"] = 163.13, ["Mega|Fly|Ride"] = 555.52}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Neon"] = 7.87, ["Neon|Ride"] = 137.82, ["Mega"] = 101.07, ["Mega|Ride"] = 339.19}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 91.87, ["Ride"] = 143.51, ["Fly|Ride"] = 357.69, ["Neon"] = 413.44, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 2426.48, ["Mega|Fly|Ride"] = 2284.13}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 4.32, ["Ride"] = 94.25, ["Neon"] = 114.15, ["Mega"] = 418.06, ["Mega|Ride"] = 366.19, ["Mega|Fly|Ride"] = 645.74}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 393.75, ["Ride"] = 423.05, ["Fly|Ride"] = 711.05, ["Neon"] = 1050, ["Neon|Ride"] = 1050, ["Neon|Fly|Ride"] = 1115.63, ["Mega|Fly|Ride"] = 3346.87}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 94.5}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 52.12}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 32.81}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 26.25}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 144.16}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 47.25}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 18.25}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 2.52}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 190.25}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 17.52}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 24.19}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 10.49}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 9.18}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 944.99}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 7.88}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 3.93}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 11.81}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 5.15}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 18.68}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 644.36}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 462}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 11.71}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1328.79}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 52.4}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 6.39}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 24.66}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 163.96}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 57.72}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 17.07}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 10.38}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 19.63}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 6.13}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 26.17}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 3.52}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 21}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 15.04}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 6.44}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 3045}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 63.95}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 317.63}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 3.7}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 3.61}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 19.66}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 9.19}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 30.19}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 213.92}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 10.13}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 9.18}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 144.38}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 39.04}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 2.62}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 29.25}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 9.14}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 105}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 28.32}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 11.45}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 21.73}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 9.18}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 2.82}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 27.16}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 93.18}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 256.98}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.52}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 8.49}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 297.62}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 24.45}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 77.94}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 20.54}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 24222.65}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 85.32}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 57.74}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 37.72}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 27.17}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 56.44}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 23.63}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 31.98}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 91.14}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 119.44}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 31.19}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 103.69}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 431.78}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 48.57}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 49.88}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 220.9}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 9.17}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 7.46}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 6.12}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 26.4}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 143.06}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.1}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 7.28}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 3.42}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 15.64}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 183.75}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 830.75}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 20.43}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 590.37}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 12.06}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.1}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 221.82}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 30.97}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 99.63}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 20.99}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 31.4}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 61.34}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 15.45}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 3.54}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 7.88}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 3.27}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 2.55}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 6.35}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 32.69}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 5.92}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 3.49}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 2.63}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 18.26}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 142.93}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 52.07}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.1}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 216.56}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 23.58}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 24.17}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 7.87}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 25.88}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 10.5}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 3.83}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 7.76}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 3.49}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 6.41}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 38.97}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 15.44}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 6.18}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 2.1}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 7.8}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 15.29}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 4.51}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 5.61}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 3.71}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 6.47}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.15}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 9575.87}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 15.54}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 6.26}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 4.07}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 3.2}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 3.57}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 245.25}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 5.15}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 7.88}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 2.55}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.82}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 6.56}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 40.2}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 5.24}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 2.15}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 3.15}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4733.06}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 6.36}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 38.83}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.52}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 3.22}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 72.05}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 4.56}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 85.32}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 8.61}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 3.63}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.1}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 2.63}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 131.24}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 24.19}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 9.19}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 5.94}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 6.3}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 3.62}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 20.99}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.52}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 3.56}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.15}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 11.45}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 141.65}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 144.16}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 10.81}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 2.2}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1204.26}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 62.15}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.26}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 3.29}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 23.58}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 29.92}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 5.6}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 10.39}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 16.7}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.26}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 12.74}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 14.28}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 2.57}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 3.71}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 11.8}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 3.19}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 24.36}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 3.67}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 6.69}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 61.11}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 7.88}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 181.53}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 91.88}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 11.94}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 8.55}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 30.19}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 22.5}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 3.82}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 19.27}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 3.68}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 81.2}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 182.33}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 8.61}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1017.19}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.57}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 196.87}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 5}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 7.77}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 63}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 6.13}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 3.77}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 70.02}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 21}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 18.1}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 6.04}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 57.28}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 63.53}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 15.89}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 116.73}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 86.83}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 8.08}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 66.11}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 92.53}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 53.71}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 144.16}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 4.92}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 68.86}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 141.62}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 9.07}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 54.47}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 57.54}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 2.52}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 63}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 4.76}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 11.46}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 21.73}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 82.69}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 39.37}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 12.99}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 41.83}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 28.82}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 3.29}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 24.29}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 92.52}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 50.96}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 26.44}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1994.99}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 10.36}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 7.51}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 20.9}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 394.79}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 16.87}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 8.8}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 16.92}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 6.55}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 9.09}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 295.81}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 60.45}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 51.18}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 3.19}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 45.91}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 228.03}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 78.66}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 965.35}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 181.13}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 10.18}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 1727.25}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 570.41}},
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