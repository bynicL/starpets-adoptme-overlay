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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 1187.82, ["Ride"] = 1179.91, ["Fly|Ride"] = 1690.5, ["Neon"] = 6825, ["Neon|Ride"] = 6825, ["Neon|Fly|Ride"] = 5070.21, ["Mega"] = 21679.44, ["Mega|Fly|Ride"] = 21679.44}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 536.25, ["Ride"] = 498.93, ["Fly|Ride"] = 618.47, ["Neon|Fly|Ride"] = 1837.49, ["Mega"] = 10839.72, ["Mega|Fly|Ride"] = 8094.02}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 6562.5, ["Ride"] = 5250, ["Fly|Ride"] = 5118.74, ["Neon|Fly|Ride"] = 16800.49, ["Mega|Fly|Ride"] = 71687.39}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 192.94, ["Fly"] = 229.69, ["Ride"] = 289.44, ["Fly|Ride"] = 577.5, ["Neon"] = 1145.53, ["Neon|Ride"] = 1012.45, ["Neon|Fly|Ride"] = 853.13, ["Mega|Fly|Ride"] = 4409.99}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 632.63, ["Fly"] = 867.19, ["Ride"] = 564.38, ["Fly|Ride"] = 585.38, ["Neon|Fly|Ride"] = 1922.7, ["Mega|Fly|Ride"] = 6431.25}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 12.76, ["Ride"] = 52.5, ["Fly|Ride"] = 129.94, ["Neon"] = 84.87, ["Neon|Fly"] = 289.44, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 325.2, ["Mega"] = 353.75, ["Mega|Ride"] = 520.32, ["Mega|Fly|Ride"] = 605.96}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 7.8, ["Fly"] = 57.96, ["Ride"] = 26.24, ["Fly|Ride"] = 115.49, ["Neon"] = 49.88, ["Neon|Fly"] = 139.83, ["Neon|Ride"] = 63.97, ["Neon|Fly|Ride"] = 123.1, ["Mega"] = 322.88, ["Mega|Ride"] = 289.44, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 120.75, ["Fly"] = 216.81, ["Ride"] = 141.75, ["Neon"] = 524.94, ["Neon|Ride"] = 492.19, ["Neon|Fly|Ride"] = 1446.04, ["Mega"] = 1586.82, ["Mega|Ride"] = 2167.95, ["Mega|Fly|Ride"] = 2167.95}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 35.42, ["Fly"] = 72.64, ["Ride"] = 42.2, ["Fly|Ride"] = 98.32, ["Neon"] = 244.13, ["Neon|Ride"] = 242.82, ["Neon|Fly|Ride"] = 312.38, ["Mega"] = 2100, ["Mega|Ride"] = 1207.56, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 24.65, ["Fly"] = 49.07, ["Ride"] = 29.51, ["Fly|Ride"] = 71.55, ["Neon"] = 154.35, ["Neon|Ride"] = 166.94, ["Neon|Fly|Ride"] = 207.38, ["Mega"] = 650.4, ["Mega|Fly|Ride"] = 1127.35}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 80.07, ["Fly"] = 216.57, ["Ride"] = 110.25, ["Fly|Ride"] = 131.25, ["Neon"] = 244.86, ["Neon|Ride"] = 321.57, ["Neon|Fly|Ride"] = 414.37, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 64.32}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 321.57, ["Fly"] = 362.07, ["Ride"] = 353.07, ["Fly|Ride"] = 366.19, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 5181.41}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 131.25, ["Fly"] = 210.97, ["Ride"] = 147.97, ["Fly|Ride"] = 177.19, ["Neon|Ride"] = 573.03, ["Neon|Fly|Ride"] = 536.82, ["Mega"] = 4312.63, ["Mega|Fly|Ride"] = 2467.5}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 3.86, ["Fly"] = 79.03, ["Ride"] = 39.38, ["Fly|Ride"] = 131.25, ["Neon"] = 24.93, ["Neon|Ride"] = 57.75, ["Neon|Fly|Ride"] = 202.73, ["Mega"] = 160.13, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 375.84}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 209.99, ["Fly"] = 287.01, ["Ride"] = 245.44, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 975.58, ["Neon|Fly|Ride"] = 734.88, ["Mega|Fly|Ride"] = 2749.69}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.89, ["Fly"] = 27.16, ["Ride"] = 23.31, ["Fly|Ride"] = 40.31, ["Neon"] = 22.92, ["Neon|Fly"] = 82.19, ["Neon|Ride"] = 57.09, ["Neon|Fly|Ride"] = 87.94, ["Mega"] = 164.07, ["Mega|Ride"] = 258.57, ["Mega|Fly|Ride"] = 422.63}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 127.34, ["Fly"] = 289.44, ["Ride"] = 171.94, ["Fly|Ride"] = 288.75, ["Neon"] = 461.78, ["Neon|Ride"] = 433.6, ["Neon|Fly|Ride"] = 600.2, ["Mega"] = 1471.77, ["Mega|Ride"] = 1575, ["Mega|Fly|Ride"] = 1580.44}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 40.63}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 77.44, ["Ride"] = 185.07, ["Fly|Ride"] = 244.36, ["Neon"] = 419.51, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 2167.95, ["Mega|Fly|Ride"] = 1589.12}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 30.08, ["Fly"] = 58.55, ["Ride"] = 59.06, ["Fly|Ride"] = 433.6, ["Neon"] = 262.5, ["Neon|Ride"] = 319.79, ["Neon|Fly|Ride"] = 342.56, ["Mega"] = 787.5, ["Mega|Ride"] = 1055.8, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 40.67, ["Fly"] = 110.58, ["Ride"] = 65.63, ["Fly|Ride"] = 115.31, ["Neon"] = 231, ["Neon|Ride"] = 195.55, ["Neon|Fly|Ride"] = 283.03, ["Mega"] = 1717.06, ["Mega|Fly|Ride"] = 1076.25}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 46.81, ["Fly"] = 244.63, ["Ride"] = 85.32, ["Fly|Ride"] = 196.88, ["Neon"] = 160.43, ["Neon|Ride"] = 399.21, ["Neon|Fly|Ride"] = 519.75, ["Mega"] = 1967.44, ["Mega|Ride"] = 1734.36, ["Mega|Fly|Ride"] = 1559.84}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 36.16, ["Ride"] = 44.71, ["Fly|Ride"] = 101.91, ["Neon"] = 210, ["Neon|Ride"] = 210.3, ["Neon|Fly|Ride"] = 260.16, ["Mega"] = 1207.92, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 41.94, ["Fly"] = 145.27, ["Ride"] = 72.19, ["Fly|Ride"] = 129.94, ["Neon"] = 164.07, ["Neon|Fly"] = 409.65, ["Neon|Ride"] = 372.22, ["Neon|Fly|Ride"] = 322.88, ["Mega|Ride"] = 1145.53, ["Mega|Fly|Ride"] = 1039.5}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 8.57, ["Fly"] = 34.04, ["Ride"] = 26.24, ["Fly|Ride"] = 61.67, ["Neon"] = 45.93, ["Neon|Fly"] = 272.99, ["Neon|Ride"] = 48.56, ["Neon|Fly|Ride"] = 101.01, ["Mega"] = 169.32, ["Mega|Fly"] = 24715.64, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 351.53}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 399, ["Ride"] = 415.68, ["Fly|Ride"] = 471.19, ["Neon|Ride"] = 1706.25, ["Neon|Fly|Ride"] = 1966.13, ["Mega"] = 10839.72, ["Mega|Fly|Ride"] = 9730.8}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 12.98, ["Ride"] = 32.81, ["Fly|Ride"] = 65.63, ["Neon"] = 219.18, ["Mega|Ride"] = 823.83, ["Mega|Fly|Ride"] = 671.66}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 6.41, ["Fly"] = 43.32, ["Ride"] = 25.26, ["Fly|Ride"] = 66.94, ["Neon"] = 63, ["Neon|Ride"] = 74.07, ["Neon|Fly|Ride"] = 128.52, ["Mega|Ride"] = 446.25, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 84.81, ["Fly"] = 120.25, ["Ride"] = 84, ["Fly|Ride"] = 137.82, ["Neon"] = 343.42, ["Neon|Ride"] = 376.61, ["Neon|Fly|Ride"] = 400.59, ["Mega"] = 6499.05, ["Mega|Ride"] = 5832.75, ["Mega|Fly|Ride"] = 2100}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 14.95, ["Fly"] = 26.25, ["Ride"] = 36.75, ["Fly|Ride"] = 72.44, ["Neon"] = 66.81, ["Neon|Ride"] = 115.08, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 720.57, ["Mega|Ride"] = 735.9, ["Mega|Fly|Ride"] = 540.92}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 221.82, ["Fly"] = 288.75, ["Ride"] = 236.25, ["Fly|Ride"] = 331.88, ["Neon"] = 719.95, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 3467.64, ["Mega|Ride"] = 2763.52, ["Mega|Fly|Ride"] = 2989.61}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 23.67}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 5.13, ["Fly"] = 37.95, ["Ride"] = 24.94, ["Fly|Ride"] = 71.3, ["Neon"] = 22.31, ["Neon|Fly"] = 145.27, ["Neon|Ride"] = 44.62, ["Neon|Fly|Ride"] = 124.69, ["Mega"] = 196.88, ["Mega|Fly"] = 488.5, ["Mega|Ride"] = 390.25, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 721.88, ["Fly"] = 1446.04, ["Ride"] = 840, ["Fly|Ride"] = 956.82, ["Neon"] = 6503.84, ["Neon|Ride"] = 5492.5, ["Neon|Fly|Ride"] = 5058.92, ["Mega|Ride"] = 55190.93, ["Mega|Fly|Ride"] = 18789.58}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 16.96, ["Fly"] = 55.4, ["Ride"] = 51.94, ["Fly|Ride"] = 105, ["Neon"] = 185.07, ["Neon|Ride"] = 205.97, ["Neon|Fly|Ride"] = 212.47, ["Mega"] = 1036.88, ["Mega|Ride"] = 1113.26, ["Mega|Fly|Ride"] = 723.02}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 248.07, ["Fly"] = 367.96, ["Ride"] = 236.22, ["Fly|Ride"] = 357, ["Neon"] = 885.93, ["Neon|Ride"] = 892.5, ["Neon|Fly|Ride"] = 1030.31, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 3899.56}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 45.94}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 16.72, ["Fly"] = 130.09, ["Ride"] = 72.59, ["Fly|Ride"] = 145.27, ["Neon"] = 65.62, ["Neon|Ride"] = 128.62, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 409.65, ["Mega|Ride"] = 576.13, ["Mega|Fly|Ride"] = 607.11}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.52}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 111.57, ["Fly"] = 160.61, ["Ride"] = 202.72, ["Fly|Ride"] = 219.19, ["Neon"] = 649.31, ["Neon|Ride"] = 506.23, ["Neon|Fly|Ride"] = 814.38, ["Mega"] = 2383.67, ["Mega|Ride"] = 2024.88, ["Mega|Fly|Ride"] = 1808.62}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 102.9, ["Fly"] = 157.49, ["Ride"] = 157.5, ["Fly|Ride"] = 234.15, ["Neon"] = 389.46, ["Neon|Fly"] = 578.86, ["Neon|Ride"] = 426.27, ["Neon|Fly|Ride"] = 496.12, ["Mega"] = 1625.97, ["Mega|Ride"] = 1466.07, ["Mega|Fly|Ride"] = 1300.78}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 34.72}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 52.5, ["Fly"] = 65.63, ["Ride"] = 60.38, ["Fly|Ride"] = 78.74, ["Neon|Ride"] = 397.83, ["Neon|Fly|Ride"] = 332.79, ["Mega"] = 4335.9, ["Mega|Fly|Ride"] = 1378.13}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 6.56, ["Fly"] = 101.91, ["Ride"] = 45.94, ["Fly|Ride"] = 157.5, ["Neon"] = 35.44, ["Neon|Fly"] = 223.13, ["Neon|Ride"] = 70.88, ["Neon|Fly|Ride"] = 145.27, ["Mega"] = 190.32, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 229.37, ["Mega|Fly|Ride"] = 458.72}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 572.78, ["Fly"] = 723.02, ["Ride"] = 540.75, ["Fly|Ride"] = 610.32, ["Neon|Fly"] = 3902.31, ["Neon|Ride"] = 1976.63, ["Neon|Fly|Ride"] = 1886.71, ["Mega|Ride"] = 15175.61, ["Mega|Fly|Ride"] = 7481.25}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 118.13, ["Fly"] = 144.38, ["Ride"] = 131.25, ["Fly|Ride"] = 196.87, ["Neon"] = 498.75, ["Neon|Ride"] = 578.86, ["Neon|Fly|Ride"] = 723.02, ["Mega|Ride"] = 2601.55, ["Mega|Fly|Ride"] = 2296.88}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 4068.75, ["Ride"] = 3885, ["Fly|Ride"] = 3937.5, ["Neon|Fly|Ride"] = 15174.53}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 60.38, ["Fly"] = 131.25, ["Ride"] = 98.43, ["Fly|Ride"] = 188.62, ["Neon"] = 341.25, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 272.09, ["Mega"] = 2167.95, ["Mega|Ride"] = 2027.04, ["Mega|Fly|Ride"] = 1866.38}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 63.66, ["Ride"] = 49.07, ["Fly|Ride"] = 86.73, ["Neon"] = 575.75, ["Neon|Ride"] = 427.88, ["Neon|Fly|Ride"] = 431.82, ["Mega"] = 6359.69, ["Mega|Ride"] = 2388.75, ["Mega|Fly|Ride"] = 2211.32}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 41.98, ["Fly"] = 72.19, ["Ride"] = 48.57, ["Fly|Ride"] = 127.32, ["Neon"] = 152.25, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 203.44, ["Mega"] = 2625, ["Mega|Ride"] = 900.79, ["Mega|Fly|Ride"] = 577.47}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 4.35}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 57.75, ["Fly"] = 393.75, ["Ride"] = 53.82, ["Fly|Ride"] = 98.13, ["Neon|Ride"] = 289.44, ["Neon|Fly|Ride"] = 607.04, ["Mega|Ride"] = 1308.65, ["Mega|Fly|Ride"] = 1300.78}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 35.43}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 212.62, ["Ride"] = 183.75, ["Fly|Ride"] = 282.19, ["Neon"] = 1156.61, ["Neon|Ride"] = 1156.61, ["Neon|Fly|Ride"] = 1156.61, ["Mega|Fly|Ride"] = 5058.92}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 715.21, ["Ride"] = 623.44, ["Fly|Ride"] = 656.25, ["Neon"] = 2625, ["Neon|Fly|Ride"] = 4335.9, ["Mega|Fly|Ride"] = 11265.36}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 6.16}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 31.66, ["Fly"] = 56.37, ["Ride"] = 36.75, ["Fly|Ride"] = 64.29, ["Neon"] = 246.75, ["Neon|Fly"] = 260.16, ["Neon|Ride"] = 143.07, ["Neon|Fly|Ride"] = 209.48, ["Mega"] = 2167.95, ["Mega|Ride"] = 1177.42, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 23.6}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5250, ["Ride"] = 6502.76, ["Fly|Ride"] = 5055.74, ["Neon|Ride"] = 17989.8, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 44152.76}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 12.99, ["Fly"] = 58.55, ["Ride"] = 26.11, ["Fly|Ride"] = 57.83, ["Neon"] = 82.69, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 196.89, ["Mega"] = 561.75, ["Mega|Ride"] = 490.88, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 10.28, ["Fly"] = 142.01, ["Ride"] = 37.95, ["Fly|Ride"] = 121.44, ["Neon"] = 95.82, ["Neon|Ride"] = 124.67, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 757.72, ["Mega|Ride"] = 974.51, ["Mega|Fly|Ride"] = 1012.45}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 74.26, ["Ride"] = 82.69, ["Fly|Ride"] = 85.31, ["Neon|Ride"] = 405.42, ["Neon|Fly|Ride"] = 485.82, ["Mega"] = 4335.9, ["Mega|Fly|Ride"] = 1799.24}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 11.82, ["Fly"] = 72.64, ["Ride"] = 36.72, ["Fly|Ride"] = 78.75, ["Neon"] = 91.88, ["Neon|Ride"] = 148.32, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 555.01, ["Mega|Ride"] = 769, ["Mega|Fly|Ride"] = 800.63}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1783.69, ["Fly"] = 2007.53, ["Ride"] = 1851.94, ["Fly|Ride"] = 1649.82, ["Neon|Fly|Ride"] = 3780, ["Mega|Fly|Ride"] = 12468.75}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 27562.5, ["Fly"] = 34687.1, ["Ride"] = 33966.26, ["Fly|Ride"] = 26160.75, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 63000, ["Mega|Fly|Ride"] = 183748.69}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 25.98, ["Fly"] = 393.75, ["Ride"] = 55.12, ["Fly|Ride"] = 130.09, ["Neon"] = 250.81, ["Neon|Ride"] = 208.69, ["Neon|Fly|Ride"] = 582.75, ["Mega"] = 754.69, ["Mega|Ride"] = 1308.65, ["Mega|Fly|Ride"] = 578.86}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 5.25, ["Fly"] = 145.27, ["Ride"] = 43.36, ["Fly|Ride"] = 164.07, ["Neon"] = 25.72, ["Neon|Fly"] = 145.15, ["Neon|Ride"] = 70.79, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 196.87, ["Mega|Fly"] = 405.42, ["Mega|Ride"] = 228.38, ["Mega|Fly|Ride"] = 262.45}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 22.41}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 7.49, ["Ride"] = 49.88, ["Fly|Ride"] = 131.25, ["Neon"] = 56.44, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 277.1, ["Mega"] = 289.44, ["Mega|Ride"] = 402.94, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 803.25, ["Ride"] = 787.5, ["Fly|Ride"] = 855.75, ["Neon"] = 3107.87, ["Neon|Ride"] = 2530, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 11447.83}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 918.65, ["Fly"] = 1076.15, ["Ride"] = 871.4, ["Fly|Ride"] = 997.49, ["Neon"] = 4191.74, ["Neon|Ride"] = 3271, ["Neon|Fly|Ride"] = 2756.25, ["Mega|Fly|Ride"] = 11610.96}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 15.23, ["Fly"] = 122.67, ["Ride"] = 32.48, ["Fly|Ride"] = 77.18, ["Neon"] = 79.62, ["Neon|Ride"] = 105.5, ["Neon|Fly|Ride"] = 145.17, ["Mega"] = 496.53, ["Mega|Ride"] = 481.9, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 23.54}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 78.89, ["Fly"] = 91.01, ["Ride"] = 86.63, ["Fly|Ride"] = 131.25, ["Neon"] = 578.86, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 420, ["Mega"] = 19687.5, ["Mega|Ride"] = 2024.88, ["Mega|Fly|Ride"] = 2369.07}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 72.64, ["Ride"] = 94.32, ["Fly|Ride"] = 216.81, ["Neon"] = 450.19, ["Neon|Ride"] = 411.09, ["Neon|Fly|Ride"] = 553.77, ["Mega"] = 1410.68, ["Mega|Ride"] = 1951.16, ["Mega|Fly|Ride"] = 1962.35}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 6.34, ["Fly"] = 32.41, ["Ride"] = 23.02, ["Fly|Ride"] = 52.4, ["Neon"] = 44.17, ["Neon|Fly"] = 524.99, ["Neon|Ride"] = 99.73, ["Neon|Fly|Ride"] = 110.92, ["Mega|Fly|Ride"] = 578.86}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 177.19, ["Fly"] = 192.92, ["Ride"] = 190.32, ["Fly|Ride"] = 260.93, ["Neon"] = 866.12, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 694.32, ["Mega"] = 5203.08, ["Mega|Fly|Ride"] = 2622.37}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 7.87, ["Ride"] = 47.97, ["Fly|Ride"] = 141.75, ["Neon"] = 43.37, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 424.7, ["Mega"] = 249.38, ["Mega|Fly"] = 1137.94, ["Mega|Ride"] = 342.01, ["Mega|Fly|Ride"] = 654.93}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 17.48, ["Fly"] = 65.63, ["Ride"] = 39.27, ["Fly|Ride"] = 65.29, ["Neon"] = 120.75, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 654.94, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 28.27, ["Ride"] = 91.88, ["Fly|Ride"] = 148.38, ["Neon"] = 220.81, ["Neon|Ride"] = 245.32, ["Mega"] = 997.5, ["Mega|Ride"] = 853.13, ["Mega|Fly|Ride"] = 1011.85}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 18.12, ["Fly"] = 58.55, ["Ride"] = 26.24, ["Fly|Ride"] = 78.68, ["Neon"] = 103.69, ["Neon|Ride"] = 127.92, ["Neon|Fly|Ride"] = 328.47, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6744.94, ["Ride"] = 5512.5, ["Fly|Ride"] = 5377.32, ["Neon"] = 36133.12, ["Neon|Ride"] = 28875, ["Neon|Fly|Ride"] = 30207.05, ["Mega|Fly|Ride"] = 98117.21}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 210, ["Fly"] = 249.36, ["Ride"] = 245, ["Fly|Ride"] = 319.79, ["Neon"] = 818.07, ["Neon|Fly"] = 735.9, ["Neon|Fly|Ride"] = 568.55, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 62.37, ["Fly"] = 91.88, ["Ride"] = 111.18, ["Fly|Ride"] = 227.07, ["Neon"] = 184.25, ["Neon|Fly"] = 354.47, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 320.25, ["Mega"] = 602.95, ["Mega|Ride"] = 523.59, ["Mega|Fly|Ride"] = 588}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 3.63, ["Fly"] = 90.78, ["Ride"] = 21.19, ["Fly|Ride"] = 81.37, ["Neon"] = 18.38, ["Neon|Fly"] = 86.73, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 289.44, ["Mega|Ride"] = 330.75, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 62.33, ["Fly"] = 215.34, ["Ride"] = 196.77, ["Fly|Ride"] = 221.95, ["Neon"] = 199.5, ["Neon|Ride"] = 256.69, ["Neon|Fly|Ride"] = 498.75, ["Mega"] = 482.99, ["Mega|Ride"] = 512.74, ["Mega|Fly|Ride"] = 735}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 14717.6, ["Ride"] = 13415.07, ["Fly|Ride"] = 11808.57, ["Neon|Fly|Ride"] = 22968.75, ["Mega|Fly|Ride"] = 102472.18}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 315, ["Ride"] = 406.88, ["Fly|Ride"] = 556.5, ["Neon|Ride"] = 1590.2, ["Neon|Fly|Ride"] = 3543.75}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 43.36, ["Fly"] = 81.31, ["Ride"] = 64.32, ["Fly|Ride"] = 113.18, ["Neon"] = 1049.99, ["Neon|Ride"] = 328.11, ["Neon|Fly|Ride"] = 334.69, ["Mega|Fly|Ride"] = 2021.25}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 7.71, ["Ride"] = 26.24, ["Fly|Ride"] = 59.07, ["Neon"] = 67.47, ["Neon|Fly"] = 327.48, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 145.27, ["Mega"] = 421.32, ["Mega|Ride"] = 735.9, ["Mega|Fly|Ride"] = 1012.45}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 392.34, ["Fly"] = 867.19, ["Ride"] = 419.99, ["Fly|Ride"] = 563.69, ["Neon"] = 1691.02, ["Neon|Ride"] = 1442.44, ["Neon|Fly|Ride"] = 1312.49, ["Mega|Fly|Ride"] = 4593.75}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 9.19, ["Ride"] = 41.13, ["Fly|Ride"] = 199.49, ["Neon"] = 31.5, ["Neon|Ride"] = 93.17, ["Neon|Fly|Ride"] = 225.48, ["Mega"] = 158.82, ["Mega|Fly"] = 263.92, ["Mega|Ride"] = 227.07, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 100.7, ["Fly"] = 167.9, ["Ride"] = 158.82, ["Fly|Ride"] = 197.71, ["Neon"] = 650.4, ["Neon|Fly"] = 525, ["Neon|Ride"] = 459.37, ["Neon|Fly|Ride"] = 522.38, ["Mega|Fly|Ride"] = 2235.08}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 11.93, ["Fly"] = 21.97, ["Ride"] = 22.4, ["Fly|Ride"] = 38.07, ["Neon"] = 116, ["Neon|Ride"] = 58.55, ["Neon|Fly|Ride"] = 103, ["Mega"] = 2601.55, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 11.54}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 78.75, ["Ride"] = 87.94, ["Fly|Ride"] = 131.25, ["Neon"] = 325.2, ["Neon|Fly"] = 540.92, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 430.5, ["Mega|Ride"] = 2022.7, ["Mega|Fly|Ride"] = 1734.24}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 12.5, ["Fly"] = 80.07, ["Ride"] = 32.82, ["Fly|Ride"] = 94.5, ["Neon"] = 89.24, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 239.57, ["Mega"] = 584.27, ["Mega|Ride"] = 577.5, ["Mega|Fly|Ride"] = 737.12}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 35.17}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 74.82, ["Fly"] = 145.27, ["Ride"] = 118.13, ["Fly|Ride"] = 327.48, ["Neon"] = 418.5, ["Neon|Ride"] = 468.29, ["Neon|Fly|Ride"] = 575.6, ["Mega|Fly|Ride"] = 1734.36}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.76, ["Ride"] = 29.24, ["Fly|Ride"] = 137.82, ["Neon"] = 26.25, ["Neon|Ride"] = 137.68, ["Neon|Fly|Ride"] = 260.16, ["Mega|Fly|Ride"] = 331.42}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 11.82, ["Fly"] = 56.44, ["Ride"] = 33.15, ["Fly|Ride"] = 95.01, ["Neon"] = 160.13, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 215.73, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 586.69}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 522.38, ["Fly"] = 541.99, ["Ride"] = 519, ["Fly|Ride"] = 498.74, ["Neon|Fly|Ride"] = 2817.25, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 36.74, ["Fly"] = 108.41, ["Ride"] = 50.93, ["Fly|Ride"] = 99.71, ["Neon"] = 156.19, ["Neon|Ride"] = 145.27, ["Neon|Fly|Ride"] = 376.55, ["Mega"] = 776.43, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 717.84}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 46.91, ["Fly"] = 144.46, ["Ride"] = 64.32, ["Fly|Ride"] = 144.27, ["Neon"] = 236.25, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 262.5, ["Mega|Ride"] = 1066.65, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 18.41, ["Fly"] = 145.27, ["Ride"] = 78.64, ["Fly|Ride"] = 127.94, ["Neon"] = 98.44, ["Neon|Ride"] = 128.64, ["Neon|Fly|Ride"] = 289.44, ["Mega"] = 357.73, ["Mega|Fly"] = 525, ["Mega|Ride"] = 520.32, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 10500, ["Ride"] = 8862, ["Fly|Ride"] = 8186.07, ["Neon|Fly|Ride"] = 15124.73, ["Mega|Fly|Ride"] = 38850}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1506.75, ["Fly"] = 1501.85, ["Ride"] = 1312.4, ["Fly|Ride"] = 1481.82, ["Neon|Fly|Ride"] = 4143.13, ["Mega|Fly|Ride"] = 24570.4}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 735.9, ["Ride"] = 572.78, ["Fly|Ride"] = 721.66, ["Neon"] = 2253.58, ["Neon|Fly|Ride"] = 3084.38, ["Mega"] = 21679.44, ["Mega|Fly|Ride"] = 9975}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 12.68, ["Fly"] = 26.02, ["Ride"] = 24.94, ["Fly|Ride"] = 39.46, ["Neon"] = 136.5, ["Neon|Ride"] = 72.64, ["Neon|Fly|Ride"] = 131.23, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 577.49}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 5.11, ["Fly"] = 52.5, ["Ride"] = 37.82, ["Fly|Ride"] = 199.46, ["Neon"] = 24.45, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 216.81, ["Mega"] = 216.81, ["Mega|Ride"] = 200.42, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 42, ["Fly"] = 41.91, ["Ride"] = 47.25, ["Fly|Ride"] = 97.13, ["Neon"] = 551.92, ["Neon|Ride"] = 145.69, ["Neon|Fly|Ride"] = 181.47, ["Mega|Fly|Ride"] = 666.75}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.51, ["Fly"] = 26.25, ["Ride"] = 18.77, ["Fly|Ride"] = 43.36, ["Neon"] = 30.19, ["Neon|Fly"] = 86.63, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 108.93, ["Mega"] = 216.81, ["Mega|Ride"] = 774.38, ["Mega|Fly|Ride"] = 245.43}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 346.89, ["Fly"] = 426.2, ["Ride"] = 301.26, ["Fly|Ride"] = 354.37, ["Neon"] = 1300.78, ["Neon|Ride"] = 1055.8, ["Neon|Fly|Ride"] = 918.75, ["Mega|Fly|Ride"] = 4335.9}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 16.88, ["Fly"] = 60.6, ["Ride"] = 42.19, ["Fly|Ride"] = 86.73, ["Neon"] = 144.38, ["Neon|Fly"] = 407.29, ["Neon|Ride"] = 162.65, ["Neon|Fly|Ride"] = 229.82, ["Mega"] = 867.19, ["Mega|Fly"] = 916.19, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 721.77}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 8.99, ["Fly"] = 24.94, ["Ride"] = 22.32, ["Fly|Ride"] = 45.94, ["Neon"] = 84.57, ["Neon|Fly"] = 122.5, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 1575, ["Mega|Ride"] = 618.15, ["Mega|Fly|Ride"] = 423.94}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 432.52, ["Fly"] = 1048.69, ["Ride"] = 541.99, ["Fly|Ride"] = 866.58, ["Mega|Fly|Ride"] = 9971.07}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1115.63, ["Fly"] = 1446.04, ["Ride"] = 1155, ["Fly|Ride"] = 1181.24, ["Neon"] = 5262.77, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 13729.59}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 105, ["Fly"] = 145.27, ["Ride"] = 99.23, ["Fly|Ride"] = 107.52, ["Neon"] = 971.25, ["Neon|Ride"] = 596.21, ["Neon|Fly|Ride"] = 492.14, ["Mega|Fly|Ride"] = 2854}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 183.75, ["Fly"] = 246.07, ["Ride"] = 229.69, ["Fly|Ride"] = 298.8, ["Neon"] = 1012.45, ["Neon|Ride"] = 735.9, ["Neon|Fly|Ride"] = 725.82, ["Mega|Ride"] = 9187.5, ["Mega|Fly|Ride"] = 2598.75}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 28.81, ["Fly"] = 124.67, ["Ride"] = 52.5, ["Fly|Ride"] = 116, ["Neon"] = 254.62, ["Neon|Ride"] = 240.55, ["Mega|Ride"] = 2167.95, ["Mega|Fly|Ride"] = 1097.7}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 362.25, ["Ride"] = 431.16, ["Fly|Ride"] = 492.14, ["Neon"] = 1220.63, ["Neon|Fly|Ride"] = 1300.78, ["Mega|Fly|Ride"] = 5781.91}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 1968.75, ["Ride"] = 1968.65, ["Fly|Ride"] = 2029.07, ["Neon|Fly|Ride"] = 10839.72, ["Mega|Fly|Ride"] = 36793.96}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 45.54, ["Fly"] = 216.81, ["Ride"] = 49.88, ["Fly|Ride"] = 196.88, ["Neon"] = 216.81, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 343.88, ["Mega|Ride"] = 2384.75, ["Mega|Fly|Ride"] = 1259.99}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 656.25, ["Fly"] = 743.63, ["Ride"] = 656.25, ["Fly|Ride"] = 715.32, ["Neon|Ride"] = 1498.88, ["Neon|Fly|Ride"] = 1307.25, ["Mega|Fly|Ride"] = 4200}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 45.92, ["Fly"] = 72.19, ["Ride"] = 62.89, ["Fly|Ride"] = 117.83, ["Neon|Ride"] = 245.32, ["Neon|Fly|Ride"] = 288.75, ["Mega|Ride"] = 1083.98, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 4.93, ["Fly"] = 26.25, ["Ride"] = 24.03, ["Fly|Ride"] = 68.29, ["Neon"] = 26.24, ["Neon|Fly"] = 110.25, ["Neon|Ride"] = 51.18, ["Neon|Fly|Ride"] = 102.37, ["Mega"] = 166.68, ["Mega|Ride"] = 187.38, ["Mega|Fly|Ride"] = 432.52}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 49.07, ["Ride"] = 131.25, ["Fly|Ride"] = 157.5, ["Neon"] = 275.63, ["Neon|Ride"] = 481.47, ["Neon|Fly|Ride"] = 433.6, ["Mega"] = 1586.95, ["Mega|Ride"] = 1734.36, ["Mega|Fly|Ride"] = 1720.27}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 990.82, ["Fly"] = 1082.91, ["Ride"] = 940.84, ["Fly|Ride"] = 984.38, ["Neon|Ride"] = 3694.69, ["Neon|Fly|Ride"] = 3076.5, ["Mega|Fly|Ride"] = 11562.74}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 708.75, ["Ride"] = 809.82, ["Fly|Ride"] = 905.63, ["Neon|Fly|Ride"] = 3250.84, ["Mega|Fly|Ride"] = 15899.7}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 15.44, ["Fly"] = 26.25, ["Ride"] = 26.03, ["Fly|Ride"] = 43.37, ["Neon"] = 144.38, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 144.38, ["Mega|Fly|Ride"] = 722.52}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 16.55, ["Ride"] = 40.72, ["Fly|Ride"] = 120.33, ["Neon"] = 168, ["Neon|Ride"] = 148.66, ["Neon|Fly|Ride"] = 143.1, ["Mega"] = 1012.45, ["Mega|Ride"] = 988.6, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 5.16, ["Ride"] = 55.82, ["Fly|Ride"] = 216.81, ["Neon"] = 23.63, ["Neon|Fly"] = 326.17, ["Neon|Ride"] = 76.06, ["Neon|Fly|Ride"] = 227.64, ["Mega"] = 196.88, ["Mega|Fly"] = 572.78, ["Mega|Ride"] = 204.65, ["Mega|Fly|Ride"] = 476.96}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 49.93, ["Fly"] = 43.37, ["Ride"] = 59.06, ["Fly|Ride"] = 127.33, ["Neon"] = 319.79, ["Neon|Ride"] = 162.61, ["Neon|Fly|Ride"] = 209.87, ["Mega|Ride"] = 1090.35, ["Mega|Fly|Ride"] = 1012.45}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 98.33, ["Ride"] = 327.48, ["Fly|Ride"] = 362.07, ["Neon"] = 413.44, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 695.63, ["Mega|Ride"] = 2167.95, ["Mega|Fly|Ride"] = 2587.46}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 15.27, ["Fly"] = 52.41, ["Ride"] = 36, ["Fly|Ride"] = 90.57, ["Neon"] = 85.32, ["Neon|Ride"] = 101.91, ["Neon|Fly|Ride"] = 268.84, ["Mega"] = 429.7, ["Mega|Ride"] = 351.28, ["Mega|Fly|Ride"] = 515.82}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 38.64, ["Fly"] = 61.69, ["Ride"] = 42.78, ["Fly|Ride"] = 90.45, ["Neon"] = 242.82, ["Neon|Ride"] = 223.02, ["Neon|Fly|Ride"] = 249.27, ["Mega"] = 1734.36, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.35, ["Fly"] = 45.34, ["Ride"] = 20.78, ["Fly|Ride"] = 39.52, ["Neon"] = 27.57, ["Neon|Ride"] = 58.55, ["Neon|Fly|Ride"] = 91.87, ["Mega"] = 289.44, ["Mega|Ride"] = 490.61, ["Mega|Fly|Ride"] = 368.82}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 6.47, ["Fly"] = 53.82, ["Ride"] = 36.73, ["Fly|Ride"] = 88.92, ["Neon"] = 52.41, ["Neon|Fly"] = 115.54, ["Neon|Ride"] = 68.25, ["Neon|Fly|Ride"] = 231.98, ["Mega"] = 262.5, ["Mega|Ride"] = 441.54, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 43.32, ["Fly"] = 72.18, ["Ride"] = 52.06, ["Fly|Ride"] = 101.91, ["Neon"] = 202.72, ["Neon|Ride"] = 332.79, ["Neon|Fly|Ride"] = 272.54}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1396.5, ["Fly"] = 1410.93, ["Ride"] = 1438.02, ["Fly|Ride"] = 1540.41, ["Neon|Ride"] = 5145.62, ["Neon|Fly|Ride"] = 3622.5, ["Mega|Fly|Ride"] = 12429.92}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 472.48, ["Fly"] = 524.99, ["Ride"] = 479.07, ["Fly|Ride"] = 524.98, ["Neon|Ride"] = 3758.14, ["Neon|Fly|Ride"] = 2362.5, ["Mega"] = 15175.61, ["Mega|Fly|Ride"] = 8671.79}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 289.44, ["Fly"] = 378.23, ["Ride"] = 360.93, ["Fly|Ride"] = 393.75, ["Neon"] = 1575, ["Neon|Ride"] = 1443.75, ["Neon|Fly|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 7804.61}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 37.55}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 32.71, ["Ride"] = 54.67, ["Fly|Ride"] = 101.92, ["Neon"] = 325.2, ["Neon|Fly"] = 433.6, ["Neon|Ride"] = 249.34, ["Neon|Fly|Ride"] = 390.25, ["Mega|Ride"] = 1192.38, ["Mega|Fly|Ride"] = 1036.54}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 70875, ["Fly"] = 27099.31, ["Ride"] = 37612.01, ["Fly|Ride"] = 18361.88, ["Neon|Fly|Ride"] = 37798.69, ["Mega"] = 216794.31, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 212.03, ["Fly"] = 262.5, ["Ride"] = 260.25, ["Fly|Ride"] = 311.53, ["Neon"] = 903, ["Neon|Ride"] = 975.58, ["Neon|Fly|Ride"] = 951.57, ["Mega"] = 6503.84, ["Mega|Fly|Ride"] = 3281.25}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 123.38, ["Fly"] = 525, ["Ride"] = 173.45, ["Fly|Ride"] = 262.49}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 118.13, ["Fly"] = 157.5, ["Ride"] = 110.25, ["Fly|Ride"] = 182.44, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 585.72, ["Mega|Fly|Ride"] = 3032.97}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 13.13, ["Fly"] = 65.06, ["Ride"] = 33.62, ["Fly|Ride"] = 85.64, ["Neon"] = 433.6, ["Neon|Ride"] = 145.27, ["Neon|Fly|Ride"] = 164.36, ["Mega"] = 733.44, ["Mega|Ride"] = 723.02, ["Mega|Fly|Ride"] = 975.58}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 4769.49, ["Ride"] = 3937.5, ["Fly|Ride"] = 4199.99, ["Neon"] = 21679.44, ["Neon|Fly|Ride"] = 15750, ["Mega|Fly|Ride"] = 81764.76}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 29.58, ["Fly"] = 43.43, ["Ride"] = 34.55, ["Fly|Ride"] = 67.97, ["Neon"] = 131.25, ["Neon|Ride"] = 216.81, ["Neon|Fly|Ride"] = 173.14, ["Mega|Ride"] = 1446.04, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 31.5, ["Ride"] = 53.8, ["Fly|Ride"] = 93.45, ["Neon"] = 291.67, ["Neon|Fly"] = 1446.04, ["Neon|Ride"] = 202.79, ["Neon|Fly|Ride"] = 295.32, ["Mega|Fly|Ride"] = 1416.19}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 420, ["Fly"] = 498.65, ["Ride"] = 446.25, ["Fly|Ride"] = 525, ["Neon"] = 1312.5, ["Neon|Ride"] = 1246.88, ["Neon|Fly|Ride"] = 1437.19, ["Mega|Fly|Ride"] = 4302.54}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 17.07, ["Fly"] = 30.08, ["Ride"] = 24.43, ["Fly|Ride"] = 40.68, ["Neon"] = 131.25, ["Neon|Ride"] = 111.18, ["Neon|Fly|Ride"] = 145.26, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 609.17}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 14.42, ["Ride"] = 34.55, ["Fly|Ride"] = 82.19, ["Neon"] = 91.88, ["Neon|Ride"] = 131.15, ["Neon|Fly|Ride"] = 211.21, ["Mega|Ride"] = 415.8, ["Mega|Fly|Ride"] = 735.9}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 107.34, ["Ride"] = 108.94, ["Fly|Ride"] = 245.44, ["Neon"] = 735.9, ["Neon|Ride"] = 511.88, ["Neon|Fly|Ride"] = 1577.2, ["Mega|Fly|Ride"] = 2601.55}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 19.52, ["Fly"] = 115.5, ["Ride"] = 79.84, ["Fly|Ride"] = 122.67, ["Neon"] = 94.5, ["Neon|Ride"] = 192.94, ["Neon|Fly|Ride"] = 259.26, ["Mega"] = 393.75, ["Mega|Fly"] = 487.1, ["Mega|Ride"] = 312.68, ["Mega|Fly|Ride"] = 523.95}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 4264.32, ["Fly"] = 6377.64, ["Ride"] = 4551.75, ["Fly|Ride"] = 3937.5, ["Neon"] = 19687.5, ["Neon|Ride"] = 12337.5, ["Neon|Fly|Ride"] = 10447.5, ["Mega"] = 49140.78, ["Mega|Fly|Ride"] = 37945.69}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 39.38, ["Fly"] = 145.27, ["Ride"] = 61.69, ["Fly|Ride"] = 144.38, ["Neon"] = 223.31, ["Neon|Ride"] = 258.57, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 867.19, ["Mega|Ride"] = 866.12, ["Mega|Fly|Ride"] = 784.88}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 6562.5, ["Fly"] = 7696.22, ["Ride"] = 6857.82, ["Fly|Ride"] = 6562.5, ["Neon"] = 22894.44, ["Neon|Fly|Ride"] = 15146.25, ["Mega|Fly|Ride"] = 46921.88}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 3.76, ["Fly"] = 22.2, ["Ride"] = 17.72, ["Fly|Ride"] = 39.03, ["Neon"] = 49.96, ["Neon|Fly"] = 62.62, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 97.13, ["Mega"] = 210, ["Mega|Ride"] = 372.75, ["Mega|Fly|Ride"] = 262.48}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 18.36, ["Fly"] = 33.99, ["Ride"] = 29.28, ["Fly|Ride"] = 47.25, ["Neon"] = 188.62, ["Neon|Fly"] = 239.57, ["Neon|Ride"] = 578.86, ["Neon|Fly|Ride"] = 144.65, ["Mega|Ride"] = 998.17, ["Mega|Fly|Ride"] = 1012.45}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 4.31}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 12.5, ["Fly"] = 32.82, ["Ride"] = 30.19, ["Fly|Ride"] = 87.02, ["Neon"] = 78.74, ["Neon|Ride"] = 120.75, ["Mega"] = 1050, ["Mega|Ride"] = 1082.91, ["Mega|Fly|Ride"] = 1130.6}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 22.31, ["Fly"] = 190.37, ["Ride"] = 48.43, ["Fly|Ride"] = 173.45, ["Neon"] = 107.34, ["Neon|Ride"] = 128.64, ["Neon|Fly|Ride"] = 219.19, ["Mega|Ride"] = 867.19, ["Mega|Fly|Ride"] = 1099.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 15.75, ["Fly"] = 28.88, ["Ride"] = 20.98, ["Fly|Ride"] = 43.37, ["Neon|Fly"] = 1080.74, ["Neon|Ride"] = 114.92, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 2601.55, ["Mega|Ride"] = 429.27, ["Mega|Fly|Ride"] = 611.38}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8879.92}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2625}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 25.72}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 243.39, ["Ride"] = 278.42, ["Fly|Ride"] = 341.24, ["Neon|Fly|Ride"] = 1213}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 17.18, ["Fly"] = 97.07, ["Ride"] = 32.82, ["Fly|Ride"] = 145.27, ["Neon"] = 118.44, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 265.13, ["Mega"] = 444.44, ["Mega|Ride"] = 2045.75, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 11.71}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 6.44, ["Ride"] = 26.24, ["Fly|Ride"] = 86.73, ["Neon|Ride"] = 249.38}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2357.25}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 204.75, ["Fly"] = 433.6, ["Ride"] = 262.5, ["Fly|Ride"] = 367.5, ["Neon"] = 1012.45, ["Neon|Ride"] = 1080.53, ["Neon|Fly|Ride"] = 1009.19, ["Mega|Ride"] = 4191.74, ["Mega|Fly|Ride"] = 3936.45}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 60.38, ["Fly"] = 477.1, ["Ride"] = 101.75, ["Fly|Ride"] = 245.32, ["Neon"] = 393.75, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 563.69, ["Mega|Fly|Ride"] = 1951.16}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 163.61, ["Fly"] = 276.43, ["Ride"] = 183.75, ["Fly|Ride"] = 253.67, ["Neon"] = 944.99, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 825.33, ["Mega|Fly|Ride"] = 3468.72}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 2488.5, ["Fly"] = 3125.05, ["Ride"] = 2708.86, ["Fly|Ride"] = 2841.57, ["Neon"] = 15225.49, ["Neon|Ride"] = 9811.73, ["Neon|Fly|Ride"] = 8137.5, ["Mega|Fly|Ride"] = 28906.28}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 18.18, ["Fly"] = 106.24, ["Ride"] = 54.11, ["Fly|Ride"] = 116, ["Neon"] = 127.32, ["Neon|Ride"] = 156.19, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 974.51, ["Mega|Ride"] = 1012.45, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 865.03, ["Fly"] = 2100, ["Ride"] = 841.37, ["Fly|Ride"] = 867.18, ["Neon|Fly|Ride"] = 4252.17}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 41.58}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 23.15, ["Ride"] = 43.32, ["Fly|Ride"] = 86.73, ["Neon"] = 105, ["Neon|Ride"] = 137.06, ["Neon|Fly|Ride"] = 239.57, ["Mega"] = 444.94, ["Mega|Fly"] = 981.19, ["Mega|Ride"] = 514.56, ["Mega|Fly|Ride"] = 695.63}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 8.88, ["Fly"] = 49.07, ["Ride"] = 30.18, ["Fly|Ride"] = 128.63, ["Neon"] = 65.63, ["Neon|Fly"] = 315, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 105, ["Mega"] = 458.72, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 397.39}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 57.61}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 19.4, ["Ride"] = 26.14, ["Fly|Ride"] = 101.91, ["Neon|Ride"] = 213.43, ["Neon|Fly|Ride"] = 202.72, ["Mega|Ride"] = 1083.98}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 25.92, ["Fly"] = 45.93, ["Ride"] = 42, ["Fly|Ride"] = 63, ["Neon|Fly"] = 239.57, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 288.35, ["Mega"] = 1446.04, ["Mega|Ride"] = 1839.71, ["Mega|Fly|Ride"] = 871.5}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6502.76, ["Fly"] = 6777.01, ["Ride"] = 5781.91, ["Fly|Ride"] = 5117.18, ["Neon|Fly|Ride"] = 9999.94, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 11.82, ["Fly"] = 63.66, ["Ride"] = 32.82, ["Fly|Ride"] = 81.38, ["Neon"] = 55.12, ["Neon|Ride"] = 87.45, ["Neon|Fly|Ride"] = 229.37, ["Mega"] = 354.38, ["Mega|Ride"] = 288.74, ["Mega|Fly|Ride"] = 546}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 20.9}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 82.19, ["Fly"] = 383.74, ["Ride"] = 126, ["Fly|Ride"] = 196.88, ["Neon"] = 374.07, ["Neon|Ride"] = 460.9, ["Neon|Fly|Ride"] = 535.49, ["Mega"] = 2879.59, ["Mega|Ride"] = 1764.77, ["Mega|Fly|Ride"] = 2709.94}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 48.62, ["Fly"] = 189.02, ["Ride"] = 89.25, ["Fly|Ride"] = 158.26, ["Neon"] = 249.38, ["Neon|Ride"] = 145.27, ["Neon|Fly|Ride"] = 458.07, ["Mega"] = 2452.95, ["Mega|Ride"] = 1170.7, ["Mega|Fly|Ride"] = 1046.07}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 23.62, ["Fly"] = 72.18, ["Ride"] = 31.56, ["Fly|Ride"] = 76.13, ["Neon|Fly"] = 234.15, ["Neon|Ride"] = 130.09, ["Neon|Fly|Ride"] = 181.79, ["Mega"] = 1016.21, ["Mega|Ride"] = 883.07, ["Mega|Fly|Ride"] = 803.24}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 6.47, ["Fly"] = 78.74, ["Ride"] = 27.23, ["Fly|Ride"] = 115.5, ["Neon"] = 28.87, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 66.24, ["Mega"] = 164.07, ["Mega|Fly"] = 7226.85, ["Mega|Ride"] = 222.87, ["Mega|Fly|Ride"] = 345.19}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 15.28, ["Fly"] = 145.27, ["Ride"] = 31.49, ["Fly|Ride"] = 98.06, ["Neon"] = 90.45, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 218.29, ["Mega"] = 514.9, ["Mega|Ride"] = 723.02, ["Mega|Fly|Ride"] = 615.57}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 20.19, ["Fly"] = 29.3, ["Ride"] = 27.57, ["Fly|Ride"] = 61.07, ["Neon"] = 278.25, ["Neon|Fly"] = 144.38, ["Neon|Ride"] = 128.63, ["Neon|Fly|Ride"] = 144.26, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 213.51}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 21.7, ["Ride"] = 140.44, ["Fly|Ride"] = 289.44, ["Neon"] = 170.63, ["Neon|Ride"] = 239.57, ["Neon|Fly|Ride"] = 376.55, ["Mega"] = 866.25, ["Mega|Fly|Ride"] = 678.57}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 245.32, ["Fly"] = 236.25, ["Ride"] = 1446.04, ["Fly|Ride"] = 433.6, ["Neon|Fly|Ride"] = 28906.28}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 55.13, ["Fly"] = 210.3, ["Ride"] = 89.25, ["Fly|Ride"] = 162.61, ["Neon"] = 216.81, ["Neon|Ride"] = 342.26, ["Neon|Fly|Ride"] = 394.83, ["Mega"] = 1140.57, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1308.65}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 1154.98, ["Fly"] = 1181.25, ["Ride"] = 1050, ["Fly|Ride"] = 1049.99, ["Neon|Ride"] = 4868.13, ["Neon|Fly|Ride"] = 3609.38, ["Mega|Fly|Ride"] = 13125}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 341.25, ["Fly"] = 723.02, ["Ride"] = 417.37, ["Fly|Ride"] = 530.98, ["Neon"] = 2690.63, ["Neon|Ride"] = 2167.95, ["Neon|Fly|Ride"] = 1994.99, ["Mega"] = 13007.67, ["Mega|Fly|Ride"] = 9448.69}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 52.49}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 3.14}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 9.19, ["Fly"] = 31.49, ["Ride"] = 24.91, ["Fly|Ride"] = 51.52, ["Neon"] = 79.8, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 85.25, ["Neon|Fly|Ride"] = 143.06, ["Mega"] = 437.26, ["Mega|Ride"] = 723.02, ["Mega|Fly|Ride"] = 573.57}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 234.85, ["Fly"] = 524.99, ["Ride"] = 275.63, ["Fly|Ride"] = 396.38, ["Neon"] = 909.85, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 945, ["Mega|Fly|Ride"] = 3109.21}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 16.51}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 115.5, ["Ride"] = 169.08, ["Fly|Ride"] = 216.81, ["Neon"] = 472.5, ["Neon|Fly"] = 610.32, ["Neon|Ride"] = 566.68, ["Neon|Fly|Ride"] = 656.25, ["Mega|Ride"] = 2575.59, ["Mega|Fly|Ride"] = 2328.8}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 106.6, ["Fly"] = 216.81, ["Ride"] = 143.73, ["Fly|Ride"] = 225.75, ["Neon"] = 650.4, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 867.19, ["Mega|Fly|Ride"] = 2890.97}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 4.64, ["Fly"] = 80.22, ["Ride"] = 29.28, ["Fly|Ride"] = 176.7, ["Neon"] = 36.75, ["Neon|Ride"] = 69.39, ["Neon|Fly|Ride"] = 252.35, ["Mega"] = 216.81, ["Mega|Ride"] = 189.95, ["Mega|Fly|Ride"] = 294.36}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 13.01, ["Fly"] = 51.43, ["Ride"] = 30.18, ["Fly|Ride"] = 69.57, ["Neon"] = 177.18, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 327.48, ["Mega|Ride"] = 1446.04, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 12.99, ["Fly"] = 102.36, ["Ride"] = 34.13, ["Fly|Ride"] = 117.09, ["Neon"] = 79.54, ["Neon|Ride"] = 101.06, ["Neon|Fly|Ride"] = 269.07, ["Mega"] = 498.75, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 496.13}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 8.53, ["Fly"] = 131.23, ["Ride"] = 52.5, ["Fly|Ride"] = 184.86, ["Neon"] = 28.33, ["Neon|Ride"] = 75.13, ["Neon|Fly|Ride"] = 145.27, ["Mega"] = 181.13, ["Mega|Ride"] = 171.9, ["Mega|Fly|Ride"] = 314.95}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 288.75, ["Ride"] = 292.69, ["Fly|Ride"] = 340.61, ["Neon"] = 1446.04, ["Neon|Ride"] = 1408, ["Neon|Fly|Ride"] = 1395.72, ["Mega|Fly|Ride"] = 6612.24}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 98.75, ["Fly"] = 578.86, ["Ride"] = 145.03, ["Fly|Ride"] = 216.07, ["Neon"] = 420, ["Neon|Ride"] = 485.63, ["Neon|Fly|Ride"] = 513.19, ["Mega"] = 2600.46, ["Mega|Fly|Ride"] = 1829.76}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 65.63, ["Fly"] = 167.45, ["Ride"] = 82.69, ["Fly|Ride"] = 116.1, ["Neon"] = 315, ["Neon|Ride"] = 324.13, ["Neon|Fly|Ride"] = 415.8, ["Mega|Ride"] = 1799.24, ["Mega|Fly|Ride"] = 1372.88}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 21, ["Ride"] = 72.64, ["Fly|Ride"] = 289.44, ["Neon|Ride"] = 623.05, ["Neon|Fly|Ride"] = 506.23}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 14.15, ["Ride"] = 31.5, ["Fly|Ride"] = 72.64, ["Neon"] = 94.5, ["Neon|Fly"] = 145.27, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 126, ["Mega"] = 433.6, ["Mega|Ride"] = 490.61, ["Mega|Fly|Ride"] = 649.69}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 4.29, ["Fly"] = 39.38, ["Ride"] = 21, ["Fly|Ride"] = 69.57, ["Neon"] = 24.94, ["Neon|Fly"] = 78.06, ["Neon|Ride"] = 58.47, ["Neon|Fly|Ride"] = 86.73, ["Mega"] = 166.69, ["Mega|Ride"] = 179.71, ["Mega|Fly|Ride"] = 278.15}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 840, ["Fly"] = 1145.53, ["Ride"] = 892.5, ["Fly|Ride"] = 925.32, ["Neon"] = 3035.13, ["Neon|Fly"] = 3329.87, ["Neon|Ride"] = 8671.79, ["Neon|Fly|Ride"] = 2624.99, ["Mega|Fly|Ride"] = 7221.38}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 289.44, ["Fly"] = 752.3, ["Ride"] = 306.98, ["Fly|Ride"] = 353.38, ["Neon"] = 1286.69, ["Neon|Ride"] = 1270.5, ["Neon|Fly|Ride"] = 1273.13, ["Mega"] = 10839.72, ["Mega|Fly|Ride"] = 5058.92}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 91.88, ["Fly"] = 173.45, ["Ride"] = 114.32, ["Fly|Ride"] = 327.48, ["Neon"] = 422.63, ["Neon|Ride"] = 416.61, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 1312.5, ["Mega|Ride"] = 1749.55, ["Mega|Fly|Ride"] = 1879.63}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 213.94, ["Fly"] = 283.5, ["Ride"] = 196.88, ["Fly|Ride"] = 223.13, ["Neon|Ride"] = 997.5, ["Neon|Fly|Ride"] = 870.19, ["Mega"] = 10839.72, ["Mega|Fly|Ride"] = 5926.09}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 25.28, ["Fly"] = 58.55, ["Ride"] = 29.87, ["Fly|Ride"] = 79.62, ["Neon"] = 169.32, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 216.81, ["Mega|Ride"] = 758.68, ["Mega|Fly|Ride"] = 956.08}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 260.16, ["Ride"] = 282.19, ["Fly|Ride"] = 360.94, ["Neon"] = 895.32, ["Neon|Ride"] = 942.38, ["Neon|Fly|Ride"] = 1022.88, ["Mega"] = 3034.04, ["Mega|Fly|Ride"] = 4247.22}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 72.53, ["Fly"] = 125.99, ["Ride"] = 65.63, ["Fly|Ride"] = 129.55, ["Neon|Ride"] = 578.86, ["Neon|Fly|Ride"] = 506.23, ["Mega|Ride"] = 2313.21, ["Mega|Fly|Ride"] = 1624.88}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 2943.53, ["Ride"] = 2453.24, ["Fly|Ride"] = 2472.75, ["Neon|Ride"] = 8671.79, ["Neon|Fly|Ride"] = 7660.44, ["Mega"] = 52030.65, ["Mega|Fly|Ride"] = 27605.52}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 13.13, ["Fly"] = 89.98, ["Ride"] = 36.75, ["Fly|Ride"] = 105, ["Neon"] = 56.01, ["Neon|Fly"] = 124.69, ["Neon|Ride"] = 82.69, ["Neon|Fly|Ride"] = 173.34, ["Mega"] = 271.52, ["Mega|Fly"] = 578.86, ["Mega|Ride"] = 355.56, ["Mega|Fly|Ride"] = 418.59}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 65.63, ["Ride"] = 81.58, ["Fly|Ride"] = 149.63, ["Neon"] = 236.25, ["Neon|Ride"] = 242.82, ["Neon|Fly|Ride"] = 477.37, ["Mega|Ride"] = 931.88, ["Mega|Fly|Ride"] = 1471.77}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 91.88, ["Fly"] = 91.46, ["Ride"] = 82.43, ["Fly|Ride"] = 89.24, ["Neon"] = 525, ["Neon|Ride"] = 492.14, ["Neon|Fly|Ride"] = 410.8, ["Mega|Fly|Ride"] = 1879.63}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 2203.69, ["Fly"] = 1636.13, ["Ride"] = 1069.69, ["Fly|Ride"] = 1181.25, ["Neon|Ride"] = 5723.92, ["Neon|Fly|Ride"] = 3937.49, ["Mega"] = 37144.47, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 425.25, ["Fly"] = 865.03, ["Ride"] = 758.79, ["Fly|Ride"] = 534.19}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 65.63, ["Fly"] = 327.48, ["Ride"] = 105, ["Fly|Ride"] = 279.57, ["Neon"] = 364.88, ["Neon|Ride"] = 342.57, ["Neon|Fly|Ride"] = 506.23, ["Mega"] = 2167.95, ["Mega|Ride"] = 1712.69, ["Mega|Fly|Ride"] = 1715.57}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 8.96, ["Fly"] = 32.82, ["Ride"] = 24.94, ["Fly|Ride"] = 72.64, ["Neon"] = 78.75, ["Neon|Ride"] = 94.31, ["Neon|Fly|Ride"] = 196.87, ["Mega"] = 553.88, ["Mega|Ride"] = 613.25}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 34.12, ["Fly"] = 62.67, ["Ride"] = 44.12, ["Fly|Ride"] = 65.52, ["Neon"] = 212.63, ["Neon|Fly"] = 362.07, ["Neon|Ride"] = 281.86, ["Neon|Fly|Ride"] = 346.89, ["Mega|Ride"] = 1187.82, ["Mega|Fly|Ride"] = 1012.45}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 748.13, ["Fly"] = 1128.36, ["Ride"] = 874.13, ["Fly|Ride"] = 892.5, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2508.43, ["Mega|Fly|Ride"] = 9723}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 604.57}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 12264.66, ["Ride"] = 5250, ["Fly|Ride"] = 4921.87, ["Neon"] = 42000, ["Neon|Ride"] = 31067.73, ["Neon|Fly|Ride"] = 19687.5, ["Mega|Fly|Ride"] = 108253}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 266.44, ["Fly"] = 406.5, ["Ride"] = 341.25, ["Fly|Ride"] = 426.83, ["Neon"] = 1312.5, ["Neon|Ride"] = 1879.63, ["Neon|Fly|Ride"] = 2167.95, ["Mega"] = 6502.76, ["Mega|Ride"] = 6215.51, ["Mega|Fly|Ride"] = 6215.51}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 98.12, ["Ride"] = 131.25, ["Fly|Ride"] = 289.44, ["Neon"] = 1144.69, ["Neon|Ride"] = 506.23, ["Neon|Fly|Ride"] = 485.63}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 18.27, ["Fly"] = 101.91, ["Ride"] = 43.32, ["Fly|Ride"] = 105, ["Neon"] = 187, ["Neon|Ride"] = 129.82, ["Neon|Fly|Ride"] = 210, ["Mega|Ride"] = 723.02, ["Mega|Fly|Ride"] = 723.02}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 13.11, ["Fly"] = 28.87, ["Ride"] = 24.82, ["Fly|Ride"] = 50.18, ["Neon"] = 146.5, ["Neon|Ride"] = 130.09, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 1312.5, ["Mega|Ride"] = 380.63, ["Mega|Fly|Ride"] = 4407.12}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 15.11, ["Fly"] = 163.47, ["Ride"] = 35.44, ["Fly|Ride"] = 106.32, ["Neon"] = 118.13, ["Neon|Ride"] = 122.87, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 645.91, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 654.94}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 3.84, ["Fly"] = 29.28, ["Ride"] = 22.32, ["Fly|Ride"] = 48.57, ["Neon"] = 35.44, ["Neon|Ride"] = 56.39, ["Neon|Fly|Ride"] = 129.31, ["Mega"] = 668.25, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 217.88}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 27.24, ["Ride"] = 47.25, ["Fly|Ride"] = 130.92, ["Neon"] = 156.58, ["Neon|Fly"] = 867.19, ["Neon|Ride"] = 234.15, ["Neon|Fly|Ride"] = 327.48, ["Mega"] = 630, ["Mega|Ride"] = 723.02}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 531.57, ["Fly"] = 538.13, ["Ride"] = 551.24, ["Fly|Ride"] = 525, ["Neon"] = 1864.45, ["Neon|Ride"] = 2100, ["Neon|Fly|Ride"] = 1561.88, ["Mega"] = 7875, ["Mega|Fly|Ride"] = 6300}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 3.94, ["Fly"] = 19.69, ["Ride"] = 18.38, ["Fly|Ride"] = 38.05, ["Neon"] = 32.54, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 70.88, ["Mega"] = 170.63, ["Mega|Ride"] = 229.82, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 53.18, ["Fly"] = 116.81, ["Ride"] = 78.75, ["Fly|Ride"] = 143.05, ["Neon"] = 213.93, ["Neon|Fly"] = 301.37, ["Neon|Ride"] = 224.44, ["Neon|Fly|Ride"] = 295.64, ["Mega"] = 523.69, ["Mega|Fly"] = 867.19, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 738.83, ["Ride"] = 777, ["Fly|Ride"] = 853.12, ["Neon|Ride"] = 2746.79, ["Neon|Fly|Ride"] = 1614.37, ["Mega|Fly|Ride"] = 4287.82}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 41.99, ["Fly"] = 71.18, ["Ride"] = 44.17, ["Fly|Ride"] = 94.39, ["Neon"] = 262.5, ["Neon|Fly"] = 249.38, ["Neon|Ride"] = 188.9, ["Neon|Fly|Ride"] = 213.22, ["Mega"] = 1575, ["Mega|Fly|Ride"] = 876.89}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 272.45, ["Fly"] = 433.6, ["Ride"] = 287.44, ["Fly|Ride"] = 346.5, ["Neon"] = 1625.97, ["Neon|Ride"] = 1408.1, ["Neon|Fly|Ride"] = 1291.5, ["Mega|Fly|Ride"] = 4335.9}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 244.4, ["Fly"] = 367.96, ["Ride"] = 262.49, ["Fly|Ride"] = 328.13, ["Neon"] = 892.5, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 918.75, ["Mega"] = 5042.65, ["Mega|Fly|Ride"] = 3831.85}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 1300.78, ["Ride"] = 695.63, ["Fly|Ride"] = 787.5, ["Neon|Ride"] = 3858.48, ["Neon|Fly|Ride"] = 2296.88, ["Mega|Fly|Ride"] = 10549.23}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 16.89, ["Fly"] = 62.89, ["Ride"] = 43.32, ["Fly|Ride"] = 130.03, ["Neon"] = 78.45, ["Neon|Fly"] = 294.36, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 262.5, ["Mega|Ride"] = 327.48, ["Mega|Fly|Ride"] = 439.69}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 4094.99, ["Fly"] = 3508.32, ["Ride"] = 3281.25, ["Fly|Ride"] = 3212.98, ["Neon|Fly|Ride"] = 7874.99, ["Mega|Fly|Ride"] = 18890.82}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 145.69, ["Fly"] = 178.5, ["Ride"] = 131.25, ["Fly|Ride"] = 164.07, ["Neon"] = 535.5, ["Neon|Fly"] = 662.31, ["Neon|Ride"] = 523.69, ["Neon|Fly|Ride"] = 525, ["Mega|Ride"] = 3180.38, ["Mega|Fly|Ride"] = 3215.63}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 3.56, ["Fly"] = 32.53, ["Ride"] = 22.32, ["Fly|Ride"] = 43.31, ["Neon"] = 19.69, ["Neon|Fly"] = 82.19, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 115.31, ["Mega"] = 231, ["Mega|Fly"] = 203.44, ["Mega|Ride"] = 248.24, ["Mega|Fly|Ride"] = 237.4}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.72, ["Ride"] = 27.98, ["Fly|Ride"] = 59.07, ["Neon"] = 22.35, ["Neon|Fly"] = 120.21, ["Neon|Ride"] = 64.31, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 165.83, ["Mega|Ride"] = 419.51, ["Mega|Fly|Ride"] = 490.61}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 29.92, ["Fly"] = 39.86, ["Ride"] = 34.13, ["Fly|Ride"] = 48.39, ["Neon"] = 294.36, ["Neon|Fly|Ride"] = 271.42, ["Mega|Fly|Ride"] = 1224.89}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 938.44, ["Fly"] = 1308.65, ["Ride"] = 892.5, ["Fly|Ride"] = 1036.88, ["Neon"] = 4191.74, ["Neon|Ride"] = 4580.87, ["Neon|Fly|Ride"] = 4826.16}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 7612.5, ["Fly|Ride"] = 7985.63}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 20.55, ["Fly"] = 39.38, ["Ride"] = 27.53, ["Fly|Ride"] = 53, ["Neon"] = 452.13, ["Neon|Ride"] = 139.13, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 2520, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 11.82, ["Fly"] = 57.75, ["Ride"] = 28.88, ["Fly|Ride"] = 70.88, ["Neon"] = 101.91, ["Neon|Fly"] = 177.79, ["Neon|Ride"] = 75.03, ["Neon|Fly|Ride"] = 150.94, ["Mega"] = 668.87, ["Mega|Ride"] = 528.93, ["Mega|Fly|Ride"] = 501.38}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 118.02, ["Fly"] = 157.5, ["Ride"] = 118.12, ["Fly|Ride"] = 179.07, ["Neon|Ride"] = 452.82, ["Neon|Fly|Ride"] = 577.5, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 223.13, ["Fly"] = 236.25, ["Ride"] = 236.25, ["Fly|Ride"] = 315, ["Neon"] = 932.24, ["Neon|Ride"] = 1182.93, ["Neon|Fly|Ride"] = 682.5, ["Mega"] = 10839.72, ["Mega|Fly"] = 4090.27, ["Mega|Fly|Ride"] = 4090.27}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 6.43, ["Ride"] = 31.96, ["Fly|Ride"] = 57.75, ["Neon"] = 27.2, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 67.22, ["Neon|Fly|Ride"] = 104.9, ["Mega"] = 225.75, ["Mega|Fly"] = 241.74, ["Mega|Ride"] = 176.1, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 184.57, ["Fly"] = 231.72, ["Ride"] = 196.87, ["Fly|Ride"] = 262.5, ["Neon"] = 721.88, ["Neon|Ride"] = 715.32, ["Neon|Fly|Ride"] = 767.82, ["Mega|Fly|Ride"] = 2779.88}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 3.28, ["Fly"] = 19.68, ["Ride"] = 13.13, ["Fly|Ride"] = 49.88, ["Neon"] = 24.94, ["Neon|Fly"] = 130.09, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 122.5, ["Mega"] = 253.67, ["Mega|Ride"] = 219.19, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 262.5, ["Fly"] = 355.56, ["Ride"] = 275.35, ["Fly|Ride"] = 314.99, ["Neon|Ride"] = 1308.65, ["Neon|Fly|Ride"] = 1115.63, ["Mega"] = 10839.72, ["Mega|Fly|Ride"] = 5141.29}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 11.82, ["Fly"] = 104.98, ["Ride"] = 28.59, ["Fly|Ride"] = 68.25, ["Neon"] = 73.5, ["Neon|Fly"] = 311.53, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 578.86, ["Mega|Ride"] = 618.96, ["Mega|Fly|Ride"] = 578.86}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.1, ["Ride"] = 26.23, ["Fly|Ride"] = 92.34, ["Neon"] = 10.29, ["Neon|Fly"] = 170.46, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 195.57, ["Mega"] = 81.31, ["Mega|Ride"] = 136.14, ["Mega|Fly|Ride"] = 298.11}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.61, ["Mega"] = 24.29, ["Mega|Ride"] = 145.27, ["Mega|Fly|Ride"] = 136.6}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 2.1, ["Ride"] = 34.02, ["Fly|Ride"] = 115.47, ["Neon"] = 7.09, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 131.22, ["Mega"] = 66.24, ["Mega|Fly"] = 191720.66, ["Mega|Ride"] = 87.94}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 61.11, ["Fly"] = 156.58, ["Ride"] = 105, ["Fly|Ride"] = 180.87, ["Neon"] = 262.5, ["Neon|Ride"] = 295.31, ["Neon|Fly|Ride"] = 416.07, ["Mega|Fly|Ride"] = 1516.5}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 38.04, ["Ride"] = 16.05, ["Fly|Ride"] = 83.73, ["Neon"] = 10.97, ["Neon|Ride"] = 27.55, ["Neon|Fly|Ride"] = 52.4, ["Mega"] = 91.88, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 6.79, ["Ride"] = 145.27, ["Neon"] = 70.02, ["Neon|Fly"] = 318.9, ["Neon|Ride"] = 212.63, ["Neon|Fly|Ride"] = 360.94, ["Mega"] = 261.19, ["Mega|Ride"] = 561.51}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Neon"] = 3.94, ["Neon|Ride"] = 55.83, ["Neon|Fly|Ride"] = 137.68, ["Mega"] = 28.39, ["Mega|Ride"] = 55.59, ["Mega|Fly|Ride"] = 222.91}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 72.63, ["Ride"] = 16.28, ["Fly|Ride"] = 49.88, ["Neon"] = 2.1, ["Neon|Fly"] = 39.44, ["Neon|Ride"] = 15.39, ["Neon|Fly|Ride"] = 32.81, ["Mega"] = 14.3, ["Mega|Fly"] = 35.8, ["Mega|Ride"] = 18.04, ["Mega|Fly|Ride"] = 43.37}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 29.28, ["Ride"] = 15.28, ["Fly|Ride"] = 81.04, ["Neon"] = 2.63, ["Neon|Fly"] = 21.65, ["Neon|Ride"] = 14.73, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 19.69, ["Mega|Fly"] = 164.36, ["Mega|Ride"] = 31.74, ["Mega|Fly|Ride"] = 82.2}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Neon"] = 2.45, ["Mega"] = 19.08, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 433.6}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 117.91, ["Ride"] = 21, ["Fly|Ride"] = 49.88, ["Neon"] = 3, ["Neon|Fly"] = 123.59, ["Neon|Ride"] = 24.93, ["Neon|Fly|Ride"] = 91.87, ["Mega"] = 41.39, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 40.74, ["Mega|Fly|Ride"] = 101.91}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 79.63, ["Neon|Fly|Ride"] = 433.6, ["Mega"] = 20.99, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 82.19}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 7.88, ["Fly"] = 77.44, ["Ride"] = 65.61, ["Fly|Ride"] = 159.44, ["Neon"] = 30.56, ["Neon|Fly"] = 129.29, ["Neon|Ride"] = 48.65, ["Neon|Fly|Ride"] = 156.5, ["Mega"] = 179.06, ["Mega|Fly"] = 401.07, ["Mega|Ride"] = 168.92, ["Mega|Fly|Ride"] = 282.18}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 51.98, ["Neon"] = 2.1, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 27, ["Neon|Fly|Ride"] = 326.92, ["Mega"] = 16.93, ["Mega|Fly"] = 144.38, ["Mega|Ride"] = 133.58, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.63, ["Fly"] = 65.63, ["Ride"] = 26.25, ["Fly|Ride"] = 52.5, ["Neon"] = 18.98, ["Mega"] = 105, ["Mega|Ride"] = 274.31, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 3.6, ["Ride"] = 26.24, ["Neon"] = 17.07, ["Mega"] = 127.32, ["Mega|Ride"] = 160.43, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 32.81, ["Neon"] = 2.61, ["Neon|Ride"] = 27.13, ["Neon|Fly|Ride"] = 145.27, ["Mega"] = 19.52, ["Mega|Ride"] = 44.63, ["Mega|Fly|Ride"] = 98.01}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.61, ["Ride"] = 19.42, ["Fly|Ride"] = 38.07, ["Neon"] = 2.1, ["Neon|Fly"] = 29.45, ["Neon|Ride"] = 15.44, ["Neon|Fly|Ride"] = 38.07, ["Mega"] = 14.3, ["Mega|Fly"] = 32.82, ["Mega|Ride"] = 20.79, ["Mega|Fly|Ride"] = 51.19}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 3.5, ["Fly"] = 72.19, ["Ride"] = 54.28, ["Fly|Ride"] = 118.11, ["Neon"] = 32.16, ["Neon|Ride"] = 72.64, ["Mega"] = 183.74, ["Mega|Ride"] = 241.5}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 32.81, ["Neon"] = 6.24, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 34.69, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 26.21, ["Mega|Ride"] = 60.38, ["Mega|Fly|Ride"] = 115.5}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 3.94, ["Neon"] = 17.82, ["Mega"] = 78.75, ["Mega|Ride"] = 171.28, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.1, ["Fly"] = 78.93, ["Ride"] = 28.87, ["Fly|Ride"] = 45.94, ["Neon"] = 11.36, ["Neon|Ride"] = 50.96, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 130.09, ["Mega|Ride"] = 163.41, ["Mega|Fly|Ride"] = 107.34}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 35.06, ["Ride"] = 16.28, ["Fly|Ride"] = 31.49, ["Neon"] = 2.1, ["Neon|Fly"] = 19.49, ["Neon|Ride"] = 15.28, ["Neon|Fly|Ride"] = 36.75, ["Mega"] = 25.1, ["Mega|Fly"] = 31.9, ["Mega|Ride"] = 24.19, ["Mega|Fly|Ride"] = 47.25}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 29.25, ["Ride"] = 27.42, ["Fly|Ride"] = 144.38, ["Neon"] = 12.96, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 196.56, ["Mega"] = 129.65, ["Mega|Ride"] = 160.78, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 2.1, ["Ride"] = 24.54, ["Fly|Ride"] = 59.07, ["Neon"] = 62.39, ["Neon|Ride"] = 72.3, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 291.38, ["Mega|Ride"] = 297.51, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 58.55, ["Ride"] = 14.41, ["Fly|Ride"] = 40.85, ["Neon"] = 2.1, ["Neon|Fly"] = 19.69, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 40.69, ["Mega"] = 21, ["Mega|Fly"] = 50.96, ["Mega|Ride"] = 28.88, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 3.49, ["Fly"] = 181.04, ["Ride"] = 45.91, ["Neon"] = 6.25, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 51.18, ["Mega|Fly"] = 173.45, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 216.81}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 35.44, ["Fly|Ride"] = 131.24, ["Neon"] = 3.51, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 289.44, ["Mega"] = 28.59, ["Mega|Fly"] = 114.59, ["Mega|Ride"] = 72.19, ["Mega|Fly|Ride"] = 196.23}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 33.13, ["Ride"] = 27.56, ["Neon"] = 2.1, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 289.44, ["Mega"] = 16.22, ["Mega|Fly"] = 253.82, ["Mega|Ride"] = 42.07, ["Mega|Fly|Ride"] = 156.18}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 23.86, ["Ride"] = 19.46, ["Fly|Ride"] = 52.64, ["Neon"] = 5.2, ["Neon|Fly"] = 58.3, ["Neon|Ride"] = 31.57, ["Neon|Fly|Ride"] = 74.81, ["Mega"] = 89.97, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 21.92, ["Neon"] = 3.71, ["Neon|Ride"] = 57.75, ["Mega"] = 45.94, ["Mega|Fly"] = 327.48, ["Mega|Ride"] = 114.19, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 18.92, ["Ride"] = 16.57, ["Fly|Ride"] = 43.37, ["Neon"] = 6.57, ["Neon|Fly"] = 82.19, ["Neon|Ride"] = 25.92, ["Neon|Fly|Ride"] = 83.98, ["Mega"] = 114.19, ["Mega|Fly"] = 114.6, ["Mega|Ride"] = 76.61, ["Mega|Fly|Ride"] = 152.78}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 3.4, ["Ride"] = 35.91, ["Neon"] = 29.21, ["Neon|Fly"] = 188.89, ["Neon|Fly|Ride"] = 325.2, ["Mega"] = 104.74, ["Mega|Fly"] = 367.5, ["Mega|Ride"] = 108.41}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Fly"] = 25.77, ["Ride"] = 18.36, ["Fly|Ride"] = 47.23, ["Neon"] = 9, ["Neon|Fly"] = 49.07, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 89.98, ["Mega"] = 236.25, ["Mega|Fly"] = 420, ["Mega|Ride"] = 145.16, ["Mega|Fly|Ride"] = 185.16}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 3.73, ["Fly"] = 21.1, ["Ride"] = 19.98, ["Fly|Ride"] = 64.75, ["Neon"] = 10.5, ["Neon|Fly"] = 36.87, ["Neon|Ride"] = 28.97, ["Neon|Fly|Ride"] = 74.71, ["Mega"] = 192.96, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 131.24, ["Mega|Fly|Ride"] = 194.25}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 114.84, ["Ride"] = 72.65, ["Neon"] = 10.85, ["Neon|Ride"] = 73.61, ["Neon|Fly|Ride"] = 2625, ["Mega"] = 257.28, ["Mega|Ride"] = 323.04}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 4.93, ["Ride"] = 131.25, ["Neon"] = 72.33, ["Neon|Ride"] = 170.63, ["Mega"] = 675.33, ["Mega|Ride"] = 728.44, ["Mega|Fly|Ride"] = 981.19}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 5.24, ["Ride"] = 40.68, ["Neon"] = 43.28, ["Neon|Ride"] = 108.32, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 238.88, ["Mega|Ride"] = 367.5}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 3.57, ["Ride"] = 44.56, ["Fly|Ride"] = 130.09, ["Neon"] = 44.94, ["Neon|Ride"] = 64.93, ["Neon|Fly|Ride"] = 127.28, ["Mega"] = 225.66, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 446.91}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.74, ["Neon|Ride"] = 52.5, ["Mega"] = 17.47, ["Mega|Fly"] = 124.67, ["Mega|Ride"] = 58.55, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 48.07}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 5.98, ["Fly"] = 21, ["Ride"] = 22.31, ["Fly|Ride"] = 47.71, ["Neon"] = 35.65, ["Neon|Fly"] = 189, ["Neon|Ride"] = 43.38, ["Neon|Fly|Ride"] = 111.56, ["Mega|Ride"] = 208.68, ["Mega|Fly|Ride"] = 389.17}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 19.32, ["Neon"] = 3.7, ["Neon|Fly"] = 52.8, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 118.02, ["Mega"] = 24.94, ["Mega|Fly"] = 145.27, ["Mega|Ride"] = 68.25, ["Mega|Fly|Ride"] = 124.67}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 26.17, ["Neon"] = 3.71, ["Neon|Ride"] = 29.26, ["Neon|Fly|Ride"] = 72.18, ["Mega"] = 30.56, ["Mega|Ride"] = 65.06, ["Mega|Fly|Ride"] = 130.09}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 44.71, ["Ride"] = 13.13, ["Fly|Ride"] = 44.8, ["Neon"] = 10.76, ["Neon|Ride"] = 50.43, ["Neon|Fly|Ride"] = 63.49, ["Mega"] = 108.41, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 164.36}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 2.96, ["Fly"] = 43.37, ["Ride"] = 21.05, ["Fly|Ride"] = 72.19, ["Neon"] = 36.92, ["Neon|Ride"] = 208.13, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 328.13, ["Mega|Ride"] = 345.45, ["Mega|Fly|Ride"] = 325.2}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Ride"] = 34.12, ["Neon"] = 3.3, ["Neon|Ride"] = 39.9, ["Neon|Fly|Ride"] = 315, ["Mega"] = 19.25, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 53.7, ["Mega|Fly|Ride"] = 124.67}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 22.2, ["Fly|Ride"] = 58.95, ["Neon"] = 3.81, ["Neon|Fly"] = 115.31, ["Neon|Ride"] = 26.03, ["Neon|Fly|Ride"] = 90.57, ["Mega"] = 31.08, ["Mega|Fly"] = 145.27, ["Mega|Ride"] = 51.19, ["Mega|Fly|Ride"] = 124.67}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 29.28, ["Ride"] = 17.74, ["Fly|Ride"] = 35.94, ["Neon"] = 4.29, ["Neon|Fly"] = 56.79, ["Neon|Ride"] = 18.62, ["Neon|Fly|Ride"] = 61.31, ["Mega"] = 84.57, ["Mega|Fly"] = 145.27, ["Mega|Ride"] = 115.99, ["Mega|Fly|Ride"] = 116}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 3.44, ["Fly"] = 91.88, ["Ride"] = 53.82, ["Fly|Ride"] = 144.38, ["Neon"] = 8.73, ["Neon|Ride"] = 64.31, ["Neon|Fly|Ride"] = 93.19, ["Mega"] = 77.44, ["Mega|Ride"] = 108.41, ["Mega|Fly|Ride"] = 287.44}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 3.21, ["Neon|Ride"] = 38.09, ["Neon|Fly|Ride"] = 157967.48, ["Mega"] = 18.45, ["Mega|Fly"] = 112.51, ["Mega|Ride"] = 86.63, ["Mega|Fly|Ride"] = 131.14}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 45.91, ["Ride"] = 18.38, ["Fly|Ride"] = 51.19, ["Neon"] = 2.24, ["Neon|Fly"] = 28.23, ["Neon|Ride"] = 24.19, ["Neon|Fly|Ride"] = 90.62, ["Mega"] = 16.74, ["Mega|Fly"] = 72.59, ["Mega|Ride"] = 36.75, ["Mega|Fly|Ride"] = 78.73}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Mega"] = 23.86, ["Mega|Ride"] = 144.38}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.73, ["Neon|Fly|Ride"] = 420, ["Mega"] = 22.32, ["Mega|Ride"] = 199.46, ["Mega|Fly|Ride"] = 147.19}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 16.11, ["Fly|Ride"] = 68.25, ["Neon"] = 3.64, ["Neon|Fly"] = 39.37, ["Neon|Ride"] = 17.21, ["Neon|Fly|Ride"] = 48.38, ["Mega"] = 38.06, ["Mega|Ride"] = 145.27, ["Mega|Fly|Ride"] = 103}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 19.69, ["Fly"] = 37.41, ["Ride"] = 78.75, ["Fly|Ride"] = 216.81, ["Neon"] = 72.19, ["Mega"] = 388.5, ["Mega|Ride"] = 486.72}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.1, ["Fly"] = 6562.5, ["Ride"] = 26.25, ["Neon"] = 24.95, ["Neon|Ride"] = 157.5, ["Mega"] = 245.32, ["Mega|Fly|Ride"] = 629.99}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 3.56, ["Ride"] = 33.12, ["Fly|Ride"] = 177.79, ["Neon"] = 22.95, ["Neon|Fly|Ride"] = 289.44, ["Mega"] = 325.2, ["Mega|Ride"] = 298.11, ["Mega|Fly|Ride"] = 383.15}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 14.05, ["Ride"] = 11.69, ["Fly|Ride"] = 31.08, ["Neon"] = 2.1, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 14.84, ["Neon|Fly|Ride"] = 31.18, ["Mega"] = 24.94, ["Mega|Ride"] = 28.2, ["Mega|Fly|Ride"] = 64.82}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Fly"] = 118.12, ["Ride"] = 60.38, ["Neon"] = 8.15, ["Neon|Fly"] = 68.59, ["Neon|Ride"] = 32.54, ["Neon|Fly|Ride"] = 723.02, ["Mega"] = 86.72, ["Mega|Ride"] = 107.34}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Fly"] = 72.64, ["Ride"] = 44.17, ["Neon"] = 2.1, ["Neon|Fly"] = 32.36, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 86.67, ["Mega"] = 14.27, ["Mega|Fly"] = 130.09, ["Mega|Fly|Ride"] = 173.45}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 3.68, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 127.32, ["Mega"] = 20.22, ["Mega|Fly"] = 216.81, ["Mega|Fly|Ride"] = 367.49}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 144.56, ["Ride"] = 18.88, ["Fly|Ride"] = 40.68, ["Neon"] = 8.87, ["Neon|Fly"] = 66.05, ["Neon|Ride"] = 58.55, ["Neon|Fly|Ride"] = 90.49, ["Mega"] = 173.25, ["Mega|Ride"] = 160.13, ["Mega|Fly|Ride"] = 245.44}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 178.36, ["Ride"] = 236.24, ["Fly|Ride"] = 841.17, ["Mega"] = 8671.79, ["Mega|Fly|Ride"] = 2890.97}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Ride"] = 28.21, ["Neon"] = 7.96, ["Neon|Ride"] = 64.31, ["Mega"] = 65.63, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 2.63, ["Fly"] = 103.68, ["Ride"] = 24.69, ["Fly|Ride"] = 65.63, ["Neon"] = 33.13, ["Neon|Ride"] = 173.44, ["Neon|Fly|Ride"] = 173.45, ["Mega"] = 385.87, ["Mega|Ride"] = 229.37, ["Mega|Fly|Ride"] = 653.84}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 23.86, ["Ride"] = 16.28, ["Fly|Ride"] = 32.7, ["Neon"] = 6.57, ["Neon|Fly"] = 33.62, ["Neon|Ride"] = 28.87, ["Neon|Fly|Ride"] = 51.45, ["Mega"] = 49.67, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 132.25}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 72.64, ["Ride"] = 19.69, ["Fly|Ride"] = 127.21, ["Neon"] = 10.85, ["Neon|Ride"] = 80.07, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 77.44, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 2.43, ["Fly"] = 27.96, ["Ride"] = 16.95, ["Fly|Ride"] = 38.72, ["Neon"] = 31.5, ["Neon|Fly"] = 101.25, ["Neon|Ride"] = 43.31, ["Neon|Fly|Ride"] = 84.9, ["Mega"] = 145.27, ["Mega|Ride"] = 867.19, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 2.1, ["Ride"] = 34.7, ["Fly|Ride"] = 82.19, ["Neon"] = 49.07, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 257.25, ["Mega|Ride"] = 271.01, ["Mega|Fly|Ride"] = 387.18}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.48, ["Fly"] = 22.32, ["Ride"] = 17.82, ["Fly|Ride"] = 33.95, ["Neon"] = 30.19, ["Neon|Fly"] = 95.68, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 262.5, ["Mega|Ride"] = 376.16, ["Mega|Fly|Ride"] = 275.01}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 76.04, ["Ride"] = 85.32, ["Fly|Ride"] = 143.07, ["Neon"] = 341.25, ["Neon|Fly"] = 450.19, ["Neon|Ride"] = 249.34, ["Neon|Fly|Ride"] = 426.57, ["Mega|Fly|Ride"] = 1311.19}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 223.13, ["Fly"] = 433.6, ["Ride"] = 210, ["Fly|Ride"] = 328.13, ["Neon|Ride"] = 1128.75, ["Neon|Fly|Ride"] = 1115.63, ["Mega"] = 10839.72, ["Mega|Fly|Ride"] = 5058.92}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 63, ["Fly"] = 108.41, ["Ride"] = 85.32, ["Fly|Ride"] = 117.5, ["Neon"] = 490.61, ["Neon|Fly"] = 367.47, ["Neon|Ride"] = 293.29, ["Neon|Fly|Ride"] = 347.82, ["Mega|Fly|Ride"] = 1408.1}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 5.08, ["Fly"] = 288.2, ["Ride"] = 28, ["Neon"] = 56.49, ["Neon|Fly"] = 101.2, ["Neon|Ride"] = 99.31, ["Mega"] = 262.5, ["Mega|Ride"] = 190.32, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 10.49, ["Fly"] = 72.64, ["Ride"] = 28.88, ["Fly|Ride"] = 65.54, ["Neon"] = 61.69, ["Neon|Ride"] = 78.06, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 301.88, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 477.2}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 34.07, ["Ride"] = 15.75, ["Fly|Ride"] = 39.51, ["Neon"] = 3.03, ["Neon|Ride"] = 20.15, ["Neon|Fly|Ride"] = 75.89, ["Mega"] = 122.67, ["Mega|Fly"] = 149.64, ["Mega|Ride"] = 216.81, ["Mega|Fly|Ride"] = 493.68}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 7.28, ["Fly"] = 69.39, ["Ride"] = 36.87, ["Fly|Ride"] = 66.05, ["Neon"] = 95.82, ["Neon|Fly"] = 289.44, ["Neon|Ride"] = 114.19, ["Neon|Fly|Ride"] = 260.16, ["Mega"] = 520.32, ["Mega|Ride"] = 490.61, ["Mega|Fly|Ride"] = 723.02}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 41.91, ["Ride"] = 15.75, ["Fly|Ride"] = 45.38, ["Neon"] = 15.52, ["Neon|Fly"] = 69.57, ["Neon|Ride"] = 20.51, ["Neon|Fly|Ride"] = 84.91, ["Mega"] = 131.25, ["Mega|Ride"] = 272.09, ["Mega|Fly|Ride"] = 286.13}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 2.86, ["Ride"] = 31.57, ["Fly|Ride"] = 318.28, ["Neon"] = 44.63, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 204.84, ["Mega"] = 207.38, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 310.55}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 27.68, ["Ride"] = 19.37, ["Neon"] = 2.1, ["Neon|Ride"] = 19.5, ["Neon|Fly|Ride"] = 57.74, ["Mega"] = 15.75, ["Mega|Ride"] = 43.37, ["Mega|Fly|Ride"] = 74.82}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.26, ["Fly"] = 19.69, ["Ride"] = 18.51, ["Fly|Ride"] = 43.37, ["Neon"] = 25.47, ["Neon|Fly"] = 108.41, ["Neon|Ride"] = 36.82, ["Neon|Fly|Ride"] = 139.83, ["Mega"] = 78.72, ["Mega|Fly|Ride"] = 433.6}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.1, ["Fly"] = 55.13, ["Ride"] = 18.51, ["Fly|Ride"] = 71.11, ["Neon"] = 18.47, ["Neon|Ride"] = 47.25, ["Mega"] = 131.25, ["Mega|Ride"] = 266.44, ["Mega|Fly|Ride"] = 266.67}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 113.06, ["Fly"] = 164.12, ["Ride"] = 160.12, ["Fly|Ride"] = 215.15, ["Neon"] = 489.57, ["Neon|Ride"] = 463.08, ["Neon|Fly|Ride"] = 473.82, ["Mega"] = 3924.69, ["Mega|Fly|Ride"] = 3054.64}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 10.13, ["Ride"] = 130.09, ["Fly|Ride"] = 131.25, ["Neon"] = 42.94, ["Neon|Ride"] = 98.42, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 280.88, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 376.82}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 43.22, ["Ride"] = 19.49, ["Fly|Ride"] = 41.72, ["Neon"] = 20.37, ["Neon|Ride"] = 60.38, ["Neon|Fly|Ride"] = 121.08, ["Mega"] = 246.75, ["Mega|Ride"] = 185.79, ["Mega|Fly|Ride"] = 272.09}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 21.87, ["Ride"] = 46.64, ["Fly|Ride"] = 157.41, ["Neon"] = 72.6, ["Neon|Ride"] = 161.34, ["Neon|Fly|Ride"] = 289.44, ["Mega"] = 470.51, ["Mega|Fly"] = 867.19, ["Mega|Ride"] = 679.66, ["Mega|Fly|Ride"] = 834.02}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 3.81}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 2.59, ["Ride"] = 45.94, ["Fly|Ride"] = 129.01, ["Neon"] = 32.82, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 441.54, ["Mega|Ride"] = 490.61, ["Mega|Fly|Ride"] = 865.56}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 20.43, ["Fly"] = 36.75, ["Ride"] = 28.97, ["Fly|Ride"] = 72.19, ["Neon"] = 407.59, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 162.65, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 1399.41, ["Mega|Fly|Ride"] = 560.48}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.49, ["Fly|Ride"] = 52.38, ["Neon"] = 3.24, ["Neon|Ride"] = 33.1, ["Neon|Fly|Ride"] = 137.68, ["Mega"] = 49.88, ["Mega|Fly"] = 189, ["Mega|Ride"] = 86.73, ["Mega|Fly|Ride"] = 232.21}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 3.84, ["Fly"] = 33.6, ["Ride"] = 21.15, ["Fly|Ride"] = 65.54, ["Neon"] = 58.55, ["Mega"] = 288.33, ["Mega|Fly"] = 409.65, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 575.6}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 28.96, ["Ride"] = 21.7, ["Fly|Ride"] = 48.56, ["Neon"] = 12.92, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 37.94, ["Neon|Fly|Ride"] = 74.34, ["Mega"] = 183.75, ["Mega|Ride"] = 221.15, ["Mega|Fly|Ride"] = 160.47}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 39.37, ["Neon"] = 6.57, ["Neon|Ride"] = 41.72, ["Mega"] = 31.5, ["Mega|Ride"] = 70.11, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 21.93, ["Ride"] = 86.25, ["Fly|Ride"] = 136.5, ["Neon"] = 162.75, ["Neon|Ride"] = 207.06, ["Neon|Fly|Ride"] = 574.87, ["Mega"] = 838.69, ["Mega|Ride"] = 689.06, ["Mega|Fly|Ride"] = 867.19}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.07, ["Fly"] = 29.28, ["Ride"] = 48.56, ["Fly|Ride"] = 210, ["Neon"] = 98.13, ["Mega|Ride"] = 325.2, ["Mega|Fly|Ride"] = 327.48}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 6.51, ["Fly"] = 22.32, ["Ride"] = 21.25, ["Fly|Ride"] = 63.66, ["Neon"] = 18.94, ["Neon|Fly"] = 86.73, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 109.51, ["Mega"] = 152.28, ["Mega|Ride"] = 140.09, ["Mega|Fly|Ride"] = 514.9}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 91.88, ["Fly"] = 433.12, ["Ride"] = 72.64, ["Neon"] = 18316.2, ["Neon|Ride"] = 656.25, ["Mega"] = 4580.87, ["Mega|Fly|Ride"] = 2887.5}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 7.42, ["Fly"] = 45.85, ["Ride"] = 23.86, ["Fly|Ride"] = 71.15, ["Neon"] = 33.62, ["Neon|Ride"] = 48.57, ["Neon|Fly|Ride"] = 119.44, ["Mega"] = 238.53, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 383.74}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 65.63, ["Fly"] = 131.24, ["Ride"] = 115.77, ["Fly|Ride"] = 206.07, ["Neon"] = 234.52, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 348.5, ["Mega"] = 1048.69, ["Mega|Ride"] = 1082.91, ["Mega|Fly|Ride"] = 1077.23}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 19.69, ["Fly"] = 60.38, ["Ride"] = 55.3, ["Fly|Ride"] = 161.44, ["Neon"] = 97.57, ["Neon|Ride"] = 99.75, ["Neon|Fly|Ride"] = 210, ["Mega"] = 353.07, ["Mega|Ride"] = 378.81, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 10.85, ["Fly"] = 53.99, ["Ride"] = 26.03, ["Fly|Ride"] = 72.42, ["Neon"] = 85.32, ["Neon|Fly|Ride"] = 390.03, ["Mega"] = 572.78, ["Mega|Ride"] = 576.69, ["Mega|Fly|Ride"] = 611.63}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 14.32, ["Fly"] = 100.58, ["Ride"] = 65.63, ["Fly|Ride"] = 102.92, ["Neon"] = 55.79, ["Neon|Ride"] = 113.48, ["Neon|Fly|Ride"] = 246.06, ["Mega"] = 340.38, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 8.54, ["Ride"] = 39.37, ["Neon"] = 41.72, ["Neon|Ride"] = 57.74, ["Neon|Fly|Ride"] = 105, ["Mega"] = 276.84, ["Mega|Ride"] = 275.35, ["Mega|Fly|Ride"] = 437.12}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Ride"] = 72.64, ["Neon"] = 2.37, ["Neon|Fly"] = 97.68, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 210, ["Mega"] = 19.69, ["Mega|Ride"] = 86.73, ["Mega|Fly|Ride"] = 578.86}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 5.76, ["Ride"] = 126.06, ["Neon"] = 35.19, ["Neon|Ride"] = 198.38, ["Neon|Fly|Ride"] = 201.54, ["Mega"] = 238.88, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 540.92}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Fly"] = 129.01, ["Ride"] = 29.28, ["Neon"] = 28.88, ["Neon|Fly"] = 116.94, ["Neon|Ride"] = 101.91, ["Neon|Fly|Ride"] = 210.31, ["Mega"] = 210.67, ["Mega|Ride"] = 327.48, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 3.93, ["Ride"] = 32.8, ["Fly|Ride"] = 122.67, ["Neon"] = 19.39, ["Neon|Ride"] = 85.31, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 125.76, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 517.13}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 498.74, ["Fly"] = 708.93, ["Ride"] = 577.5, ["Fly|Ride"] = 603.75, ["Neon"] = 1842.77, ["Neon|Fly"] = 1844.94, ["Neon|Ride"] = 1842.77, ["Neon|Fly|Ride"] = 1610.6, ["Mega|Fly|Ride"] = 5085.94}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 6.57, ["Fly"] = 45.47, ["Ride"] = 22.14, ["Fly|Ride"] = 59.29, ["Neon"] = 42.3, ["Neon|Ride"] = 58.55, ["Neon|Fly|Ride"] = 319.93, ["Mega"] = 216.81, ["Mega|Ride"] = 376.55, ["Mega|Fly|Ride"] = 362.07}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 7.35, ["Fly"] = 66.94, ["Ride"] = 20.94, ["Fly|Ride"] = 55.21, ["Neon"] = 95.24, ["Neon|Fly"] = 315, ["Neon|Ride"] = 97.13, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 331.87, ["Mega|Ride"] = 433.6, ["Mega|Fly|Ride"] = 681.45}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 3.67, ["Fly"] = 24.93, ["Ride"] = 17.06, ["Fly|Ride"] = 50.3, ["Neon"] = 13.12, ["Neon|Ride"] = 41.99, ["Neon|Fly|Ride"] = 131.25}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 43.19, ["Ride"] = 32.82, ["Fly|Ride"] = 90.57, ["Neon"] = 11.69, ["Neon|Ride"] = 33.13, ["Neon|Fly|Ride"] = 196.25, ["Mega"] = 68.24, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 3.61, ["Neon|Ride"] = 24.54, ["Neon|Fly|Ride"] = 116, ["Mega"] = 21.69, ["Mega|Fly"] = 202.72, ["Mega|Ride"] = 159.36, ["Mega|Fly|Ride"] = 231.98}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1181.25}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 21.23, ["Ride"] = 43.32, ["Fly|Ride"] = 182.44, ["Neon"] = 83.42, ["Neon|Ride"] = 112.87, ["Mega"] = 409.65, ["Mega|Ride"] = 376.16, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 19.26, ["Neon"] = 6.01, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 1007.55, ["Mega"] = 39.38, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 182.44}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 6.3, ["Fly"] = 325.18, ["Ride"] = 62.57, ["Neon"] = 48.49, ["Neon|Ride"] = 170.52, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 261.37, ["Mega|Ride"] = 362.07, ["Mega|Fly|Ride"] = 402.17}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 407.51, ["Ride"] = 446.24, ["Fly|Ride"] = 514.48, ["Neon|Ride"] = 1709.71, ["Neon|Fly|Ride"] = 1365, ["Mega"] = 8129.81, ["Mega|Fly|Ride"] = 6164.82}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 5.25, ["Fly"] = 196.88, ["Ride"] = 31.5, ["Fly|Ride"] = 130.09, ["Neon"] = 58.55, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 196.25, ["Mega"] = 306.56, ["Mega|Ride"] = 497.56, ["Mega|Fly|Ride"] = 518.16}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Fly"] = 95.68, ["Ride"] = 32.79, ["Fly|Ride"] = 118.11, ["Neon"] = 5.24, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 42.94, ["Neon|Fly|Ride"] = 97.13, ["Mega"] = 38.48, ["Mega|Fly"] = 145.2, ["Mega|Ride"] = 82.53, ["Mega|Fly|Ride"] = 205.59}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 6.46, ["Neon|Ride"] = 144.45, ["Neon|Fly|Ride"] = 144.89, ["Mega"] = 26.17, ["Mega|Ride"] = 65.54, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 25.61, ["Fly"] = 107.91, ["Ride"] = 78.71, ["Fly|Ride"] = 325.2, ["Neon"] = 144.38, ["Neon|Ride"] = 229.69, ["Neon|Fly|Ride"] = 437.07, ["Mega"] = 679.66, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 7.54, ["Ride"] = 82.19, ["Neon"] = 1446.04, ["Neon|Ride"] = 291.38, ["Neon|Fly|Ride"] = 867.19, ["Mega"] = 572.78, ["Mega|Ride"] = 479.73, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 4.79, ["Ride"] = 76.13, ["Neon"] = 131.25, ["Neon|Ride"] = 200.82, ["Mega"] = 663.41, ["Mega|Ride"] = 650.4, ["Mega|Fly|Ride"] = 818.07}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 15.75, ["Ride"] = 27, ["Fly|Ride"] = 229.17, ["Neon"] = 131.25, ["Neon|Ride"] = 177.51, ["Neon|Fly|Ride"] = 241.5, ["Mega"] = 643.13, ["Mega|Ride"] = 536.59, ["Mega|Fly|Ride"] = 607.11}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 367.48, ["Ride"] = 427.32, ["Fly|Ride"] = 719.78, ["Neon"] = 1069.69, ["Neon|Ride"] = 1050, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 3346.87}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 5.24, ["Fly"] = 42.02, ["Ride"] = 34.13, ["Fly|Ride"] = 115.91, ["Neon"] = 116, ["Neon|Ride"] = 131.25, ["Mega|Fly"] = 590.63, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 867.19}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 2.1, ["Ride"] = 34.7, ["Fly|Ride"] = 127.32, ["Neon"] = 52.5, ["Neon|Ride"] = 221.82, ["Mega"] = 170.63, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 629.99}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 33.5, ["Fly"] = 346.89, ["Ride"] = 118.3, ["Fly|Ride"] = 233.63, ["Neon"] = 149.63, ["Neon|Ride"] = 196.64, ["Neon|Fly|Ride"] = 490.53, ["Mega"] = 422.68, ["Mega|Ride"] = 429.19, ["Mega|Fly|Ride"] = 511.86}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.62, ["Fly"] = 26.25, ["Ride"] = 97.57, ["Fly|Ride"] = 122.67, ["Neon"] = 7.83, ["Neon|Ride"] = 69.57, ["Mega"] = 65.63, ["Mega|Fly"] = 188.62, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 281.06}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 57.58, ["Ride"] = 83.07, ["Neon"] = 262.5, ["Neon|Ride"] = 359.63, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 1655.75, ["Mega|Ride"] = 2870.37, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.52, ["Fly"] = 56.44, ["Ride"] = 26.25, ["Fly|Ride"] = 101.91, ["Neon"] = 11.97, ["Neon|Fly"] = 188.62, ["Neon|Ride"] = 57.38, ["Neon|Fly|Ride"] = 147.19, ["Mega"] = 59.78, ["Mega|Ride"] = 90.82, ["Mega|Fly|Ride"] = 225.75}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 29.28, ["Ride"] = 28.88, ["Fly|Ride"] = 100.58, ["Neon"] = 4.6, ["Neon|Fly"] = 63.55, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 105, ["Mega"] = 38.07, ["Mega|Fly"] = 107.23, ["Mega|Ride"] = 86.73, ["Mega|Fly|Ride"] = 289.44}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Ride"] = 38.07, ["Fly|Ride"] = 131.07, ["Neon"] = 12.04, ["Neon|Ride"] = 53.95, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 83.14, ["Mega|Ride"] = 140.94, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 52.71, ["Fly"] = 65.62, ["Ride"] = 61.58, ["Fly|Ride"] = 247.16, ["Neon"] = 245.95, ["Neon|Ride"] = 361.6, ["Neon|Fly|Ride"] = 490.61, ["Mega|Ride"] = 1156.61, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 2167.95}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 7.24, ["Neon"] = 22.32, ["Neon|Fly"] = 350.44, ["Mega"] = 128.62, ["Mega|Ride"] = 205.43, ["Mega|Fly|Ride"] = 291.38}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.1, ["Ride"] = 19.62, ["Neon"] = 9.19, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 173.45, ["Mega"] = 47.25, ["Mega|Fly"] = 210, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 241.4}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 2.1, ["Fly"] = 108.41, ["Ride"] = 32.82, ["Fly|Ride"] = 98.44, ["Neon"] = 32.82, ["Mega"] = 311.11, ["Mega|Ride"] = 351.56, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Ride"] = 40.69, ["Fly|Ride"] = 131.25, ["Neon"] = 24.17, ["Neon|Ride"] = 65.62, ["Neon|Fly|Ride"] = 143.07, ["Mega"] = 174.58, ["Mega|Ride"] = 189.78, ["Mega|Fly|Ride"] = 347.03}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 71.6, ["Neon"] = 13.51, ["Neon|Ride"] = 145.27, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 72.19, ["Mega|Fly"] = 145.27, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 870.44}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 19.69, ["Fly|Ride"] = 52.5, ["Neon"] = 5.2, ["Neon|Ride"] = 28.77, ["Neon|Fly|Ride"] = 105.15, ["Mega"] = 41.99, ["Mega|Ride"] = 99.68, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 27.51, ["Ride"] = 20.09, ["Fly|Ride"] = 57.74, ["Neon"] = 17.85, ["Neon|Fly"] = 103, ["Neon|Ride"] = 40.68, ["Neon|Fly|Ride"] = 108.41, ["Mega"] = 151.46, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 215.73}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 36.82, ["Ride"] = 39.15, ["Fly|Ride"] = 78.75, ["Neon"] = 131.25, ["Neon|Ride"] = 164.07, ["Mega"] = 459.38, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 651}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 74.82, ["Ride"] = 100.99, ["Fly|Ride"] = 131.25, ["Neon"] = 367.5, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 465.94, ["Mega"] = 2153.86, ["Mega|Ride"] = 3255, ["Mega|Fly|Ride"] = 1482.83}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 19.41, ["Fly|Ride"] = 144.38, ["Neon"] = 3.81, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 28.4, ["Neon|Fly|Ride"] = 145.27, ["Mega"] = 32.83, ["Mega|Fly"] = 672, ["Mega|Ride"] = 92.42, ["Mega|Fly|Ride"] = 253.31}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 17.1, ["Ride"] = 15.62, ["Fly|Ride"] = 43.24, ["Neon"] = 3.88, ["Neon|Fly"] = 36.86, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 61.69, ["Mega"] = 65.62, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 49.87, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 3.61, ["Fly"] = 39.03, ["Ride"] = 38.01, ["Fly|Ride"] = 65.62, ["Neon"] = 40.67, ["Neon|Ride"] = 164.07, ["Neon|Fly|Ride"] = 145.27, ["Mega"] = 549.6, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 472.5, ["Ride"] = 496.49, ["Fly|Ride"] = 446.25, ["Neon"] = 4335.9, ["Neon|Fly|Ride"] = 1771.88, ["Mega|Fly|Ride"] = 5906.25}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 19.09, ["Fly"] = 101.33, ["Ride"] = 43.37, ["Fly|Ride"] = 129.94, ["Neon"] = 217.74, ["Neon|Ride"] = 226.62, ["Neon|Fly|Ride"] = 258.57, ["Mega|Ride"] = 795.65, ["Mega|Fly|Ride"] = 1798.01}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 25.76, ["Fly|Ride"] = 287.81, ["Neon"] = 8.4, ["Neon|Ride"] = 47.77, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 426.01, ["Mega|Ride"] = 128.63, ["Mega|Fly|Ride"] = 286.91}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 82.16, ["Ride"] = 56.79, ["Neon"] = 72.65, ["Mega"] = 124.69, ["Mega|Fly|Ride"] = 324.13}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 25.81, ["Fly"] = 72.64, ["Ride"] = 38.07, ["Fly|Ride"] = 116, ["Neon"] = 194.25, ["Neon|Ride"] = 219.45, ["Neon|Fly|Ride"] = 215.73, ["Mega"] = 2601.55, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1002.75}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 91.88, ["Fly"] = 182.96, ["Ride"] = 128.62, ["Fly|Ride"] = 184.61, ["Neon"] = 430.1, ["Neon|Fly"] = 823.83, ["Neon|Ride"] = 513.81, ["Neon|Fly|Ride"] = 610.32, ["Mega"] = 3180.38, ["Mega|Fly|Ride"] = 2709.94}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 228.38, ["Ride"] = 288.75, ["Fly|Ride"] = 540.75, ["Neon"] = 938.44, ["Neon|Ride"] = 800.63, ["Neon|Fly|Ride"] = 1035.57, ["Mega|Fly|Ride"] = 3610.72}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 10.4, ["Ride"] = 55.04, ["Fly|Ride"] = 147.19, ["Neon"] = 98.44, ["Neon|Ride"] = 87.92, ["Neon|Fly|Ride"] = 254.63, ["Mega"] = 723.02, ["Mega|Ride"] = 397.23, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 28.95, ["Ride"] = 16.42, ["Fly|Ride"] = 35.44, ["Neon"] = 7.77, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 84, ["Mega"] = 90.39, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 158.28}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 5.76, ["Fly"] = 19.69, ["Ride"] = 21.86, ["Fly|Ride"] = 83.61, ["Neon"] = 26.74, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 43.36, ["Neon|Fly|Ride"] = 124.07, ["Mega"] = 288.7, ["Mega|Ride"] = 244.9, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 317.62, ["Ride"] = 350.44, ["Fly|Ride"] = 669.38, ["Neon"] = 1562.54, ["Neon|Ride"] = 1590.2, ["Neon|Fly|Ride"] = 1655.24, ["Mega"] = 10839.72, ["Mega|Fly|Ride"] = 5906.25}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 33.47, ["Neon"] = 6.5, ["Neon|Ride"] = 139.41, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 34.12, ["Mega|Ride"] = 91.88}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 6.51, ["Ride"] = 17.43, ["Fly|Ride"] = 60.72, ["Neon"] = 36.66, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 98.03, ["Mega"] = 202.72, ["Mega|Ride"] = 147, ["Mega|Fly|Ride"] = 228.38}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 13.54, ["Fly"] = 6562.5, ["Ride"] = 72.64, ["Fly|Ride"] = 137.68, ["Neon"] = 98.44, ["Neon|Ride"] = 108.43, ["Neon|Fly|Ride"] = 318.28, ["Mega"] = 551.25, ["Mega|Ride"] = 649.69, ["Mega|Fly|Ride"] = 721.94}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 104.99, ["Fly"] = 157.5, ["Ride"] = 124.69, ["Fly|Ride"] = 145.27, ["Neon|Ride"] = 818.07, ["Neon|Fly|Ride"] = 656.25, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 21, ["Fly"] = 36.46, ["Ride"] = 29.66, ["Fly|Ride"] = 58.7, ["Neon"] = 105, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 875.44, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 3.93, ["Neon|Ride"] = 81.31, ["Mega"] = 39.38, ["Mega|Ride"] = 122.5, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Ride"] = 17.06, ["Fly|Ride"] = 86.57, ["Neon"] = 3.28, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 22.91, ["Neon|Fly|Ride"] = 86.93, ["Mega"] = 37.19, ["Mega|Fly"] = 101.91, ["Mega|Ride"] = 48.56, ["Mega|Fly|Ride"] = 115.5}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 15.1, ["Ride"] = 78.72, ["Fly|Ride"] = 230.22, ["Neon"] = 42, ["Neon|Ride"] = 105.83, ["Neon|Fly|Ride"] = 349.13, ["Mega"] = 184.93, ["Mega|Ride"] = 212.38, ["Mega|Fly|Ride"] = 343.87}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1155, ["Ride"] = 1312.5, ["Fly|Ride"] = 1365, ["Neon"] = 4450.81, ["Neon|Ride"] = 4265.44, ["Neon|Fly|Ride"] = 4017.24, ["Mega|Fly|Ride"] = 12600}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 413.3, ["Ride"] = 492.16, ["Fly|Ride"] = 577.5, ["Neon"] = 1680, ["Neon|Ride"] = 2045.75, ["Neon|Fly|Ride"] = 1573.69, ["Mega"] = 17343.56}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 315, ["Fly"] = 432.52, ["Ride"] = 353.53, ["Fly|Ride"] = 434.44, ["Neon"] = 787.5, ["Neon|Fly"] = 1145.53, ["Neon|Ride"] = 708.65, ["Neon|Fly|Ride"] = 735, ["Mega|Fly|Ride"] = 2916.24}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 244.11, ["Ride"] = 292.72, ["Fly|Ride"] = 367.5, ["Neon"] = 647.09, ["Neon|Ride"] = 682.49, ["Neon|Fly|Ride"] = 702.97, ["Mega|Fly|Ride"] = 3035.13}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 16.28, ["Ride"] = 18.01, ["Fly|Ride"] = 42.88, ["Neon"] = 5.08, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 104.07, ["Mega"] = 73.61, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 259.88, ["Fly"] = 466.07, ["Ride"] = 288.75, ["Fly|Ride"] = 508.99, ["Neon"] = 1050, ["Neon|Ride"] = 1365, ["Neon|Fly|Ride"] = 1312.5, ["Mega"] = 21968.87, ["Mega|Ride"] = 5492.5, ["Mega|Fly|Ride"] = 4593.75}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 9.09, ["Fly"] = 105, ["Ride"] = 52.5, ["Neon"] = 32.61, ["Neon|Ride"] = 127.31, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 170.22, ["Mega|Ride"] = 346.8, ["Mega|Fly|Ride"] = 662.32}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 19.68, ["Ride"] = 21.7, ["Fly|Ride"] = 38.98, ["Neon"] = 8.69, ["Neon|Ride"] = 55.3, ["Neon|Fly|Ride"] = 55.13, ["Mega"] = 117.08, ["Mega|Ride"] = 164.36, ["Mega|Fly|Ride"] = 159.12}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Neon"] = 3.23, ["Mega"] = 32.82, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 177.62}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 31.04, ["Ride"] = 65.63, ["Fly|Ride"] = 459.38, ["Neon"] = 199.5, ["Neon|Ride"] = 359.73, ["Mega"] = 1050, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 773.07}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 8176.86, ["Ride"] = 32.82, ["Fly|Ride"] = 68.25, ["Neon"] = 21, ["Mega"] = 359.89, ["Mega|Ride"] = 231.98, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.13, ["Neon"] = 3.73, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 141.93, ["Mega"] = 19.67, ["Mega|Ride"] = 81.31, ["Mega|Fly|Ride"] = 78.74}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 7.88, ["Fly"] = 85.99, ["Ride"] = 35.44, ["Fly|Ride"] = 85.22, ["Neon"] = 31.28, ["Neon|Fly"] = 116, ["Neon|Ride"] = 54.34, ["Neon|Fly|Ride"] = 196.25, ["Mega"] = 158.82, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 3.76, ["Fly"] = 32.48, ["Ride"] = 22.31, ["Fly|Ride"] = 44.56, ["Neon"] = 37.95, ["Neon|Fly"] = 147.19, ["Neon|Ride"] = 145.27, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 238.83, ["Mega|Ride"] = 251.07, ["Mega|Fly|Ride"] = 1321.69}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 19.98, ["Ride"] = 38.07, ["Fly|Ride"] = 147.19, ["Neon"] = 95.68, ["Neon|Ride"] = 171.28, ["Neon|Fly|Ride"] = 327.48, ["Mega"] = 433.6, ["Mega|Ride"] = 492.14}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.1, ["Fly"] = 6541.98, ["Ride"] = 16.55, ["Fly|Ride"] = 131.24, ["Neon"] = 51.98, ["Neon|Ride"] = 215.4, ["Neon|Fly|Ride"] = 289.44, ["Mega"] = 353.07, ["Mega|Ride"] = 506.23, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 68.16, ["Ride"] = 17.07, ["Fly|Ride"] = 45.94, ["Neon"] = 3.81, ["Neon|Fly"] = 82.48, ["Neon|Ride"] = 28.18, ["Mega"] = 43.71, ["Mega|Fly|Ride"] = 245.32}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 149.77, ["Fly"] = 264.5, ["Ride"] = 177.19, ["Fly|Ride"] = 262.5, ["Neon"] = 867.19, ["Neon|Ride"] = 866.12, ["Neon|Fly|Ride"] = 910.55, ["Mega"] = 8671.79, ["Mega|Fly|Ride"] = 4335.9}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 22.26, ["Ride"] = 17.08, ["Fly|Ride"] = 36.66, ["Neon"] = 3.71, ["Neon|Fly"] = 36.82, ["Neon|Ride"] = 24.19, ["Neon|Fly|Ride"] = 51.19, ["Mega"] = 49.65, ["Mega|Ride"] = 52.56, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 6.39, ["Ride"] = 72.64, ["Fly|Ride"] = 230.9, ["Neon"] = 64.58, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 784.95, ["Mega"] = 315, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 28.67, ["Ride"] = 95.54, ["Fly|Ride"] = 183.75, ["Neon"] = 190.32, ["Neon|Ride"] = 302.44, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 786.19, ["Mega|Ride"] = 912.45, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 170.63, ["Fly"] = 223.13, ["Ride"] = 222.69, ["Fly|Ride"] = 478.33, ["Neon"] = 800.63, ["Neon|Ride"] = 702.19, ["Neon|Fly|Ride"] = 840.09, ["Mega|Fly|Ride"] = 3576.03}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 11.8, ["Ride"] = 164.36, ["Fly|Ride"] = 147.19, ["Neon"] = 105, ["Neon|Ride"] = 174.87, ["Neon|Fly|Ride"] = 433.6, ["Mega"] = 278.81, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 397.83}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 6.42, ["Ride"] = 43.37, ["Fly|Ride"] = 72.64, ["Neon"] = 138.77, ["Neon|Fly"] = 164.36, ["Neon|Ride"] = 327.48, ["Neon|Fly|Ride"] = 216.81, ["Mega"] = 1446.04, ["Mega|Ride"] = 1446.04, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 939.75, ["Fly"] = 1283.44, ["Ride"] = 917.81, ["Fly|Ride"] = 1050, ["Neon|Ride"] = 5906.25, ["Neon|Fly|Ride"] = 4660.01, ["Mega|Fly|Ride"] = 17055.22}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 5.24, ["Fly"] = 25.99, ["Ride"] = 19.49, ["Fly|Ride"] = 45.93, ["Neon"] = 47.25, ["Neon|Fly"] = 76.44, ["Neon|Ride"] = 49.13, ["Neon|Fly|Ride"] = 202.13, ["Mega"] = 242.82, ["Mega|Ride"] = 289.44, ["Mega|Fly|Ride"] = 346.49}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 5.92, ["Fly"] = 78.75, ["Ride"] = 38.07, ["Fly|Ride"] = 135.19, ["Neon"] = 19.69, ["Neon|Ride"] = 101.91, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 211.32, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 324.13}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Fly"] = 86.73, ["Ride"] = 24.94, ["Fly|Ride"] = 105, ["Neon"] = 11.69, ["Neon|Ride"] = 47.85, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 91.87, ["Mega|Ride"] = 360.34, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 16.07, ["Ride"] = 32.82, ["Fly|Ride"] = 73.5, ["Neon"] = 65.55, ["Neon|Fly"] = 188.36, ["Neon|Ride"] = 97.81, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 446.22, ["Mega|Ride"] = 421.32, ["Mega|Fly|Ride"] = 434.44}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 2.1, ["Fly"] = 24.05, ["Ride"] = 21, ["Fly|Ride"] = 53.84, ["Neon"] = 29.28, ["Neon|Fly"] = 43.37, ["Neon|Ride"] = 31.75, ["Neon|Fly|Ride"] = 101.91, ["Mega"] = 145.69, ["Mega|Fly"] = 280.98, ["Mega|Ride"] = 169.32, ["Mega|Fly|Ride"] = 175.3}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Ride"] = 19.85, ["Neon"] = 15.35, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 124.69, ["Mega|Ride"] = 188.62, ["Mega|Fly|Ride"] = 266.67}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 259.88, ["Ride"] = 289.44, ["Fly|Ride"] = 433.13, ["Neon"] = 939.82, ["Neon|Fly|Ride"] = 1183.01, ["Mega|Fly|Ride"] = 3937}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 3.84, ["Fly"] = 32.81, ["Ride"] = 26.16, ["Fly|Ride"] = 145.26, ["Neon"] = 7.88, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 63.34, ["Mega|Ride"] = 100.87, ["Mega|Fly|Ride"] = 346.89}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 3.82, ["Ride"] = 29.28, ["Fly|Ride"] = 88.86, ["Neon"] = 28.21, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 188.27, ["Mega"] = 195.57, ["Mega|Ride"] = 346.89, ["Mega|Fly|Ride"] = 201.64}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 2.1, ["Fly"] = 94.75, ["Ride"] = 32.82, ["Neon"] = 15.26, ["Neon|Ride"] = 68.31, ["Neon|Fly|Ride"] = 66.24, ["Mega"] = 84.1, ["Mega|Ride"] = 120.53, ["Mega|Fly|Ride"] = 504.2}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 72.18, ["Ride"] = 129.94, ["Fly|Ride"] = 249.38, ["Neon"] = 432.52, ["Neon|Ride"] = 433.6, ["Neon|Fly|Ride"] = 508.99, ["Mega"] = 2601.55, ["Mega|Ride"] = 4335.9, ["Mega|Fly|Ride"] = 1587.06}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 19.58, ["Fly"] = 88.08, ["Ride"] = 70.83, ["Fly|Ride"] = 269.9, ["Neon"] = 29.28, ["Neon|Ride"] = 211.39, ["Neon|Fly|Ride"] = 341.93, ["Mega"] = 656.24, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 21, ["Fly"] = 58.55, ["Ride"] = 42, ["Fly|Ride"] = 105, ["Neon"] = 93.19, ["Neon|Ride"] = 128.63, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 596.82, ["Mega|Ride"] = 435.75, ["Mega|Fly|Ride"] = 538.13}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 13.75, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 230.79, ["Mega"] = 124.69, ["Mega|Fly|Ride"] = 578.86}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 45.93, ["Fly"] = 91.87, ["Ride"] = 87.94, ["Fly|Ride"] = 168, ["Neon"] = 246.07, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 229.48, ["Neon|Fly|Ride"] = 290.07, ["Mega|Fly|Ride"] = 1011.71}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 21, ["Fly|Ride"] = 65.63, ["Neon"] = 5.44, ["Neon|Fly|Ride"] = 129.01, ["Mega"] = 61.8, ["Mega|Ride"] = 288.35, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 15.48, ["Fly"] = 39.38, ["Ride"] = 32.81, ["Fly|Ride"] = 94.32, ["Neon"] = 116, ["Neon|Fly"] = 84, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 203.44, ["Mega"] = 360.7, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 432.52, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 48.57, ["Fly"] = 203.41, ["Ride"] = 76.38, ["Fly|Ride"] = 146.25, ["Neon"] = 262.5, ["Neon|Fly"] = 433.6, ["Neon|Ride"] = 265.13, ["Neon|Fly|Ride"] = 474.79, ["Mega|Ride"] = 1482.89, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 15.65, ["Ride"] = 14.77, ["Fly|Ride"] = 35.44, ["Neon"] = 2.1, ["Neon|Fly"] = 28.21, ["Neon|Ride"] = 19.13, ["Neon|Fly|Ride"] = 44.63, ["Mega"] = 20.41, ["Mega|Ride"] = 40.6, ["Mega|Fly|Ride"] = 91.19}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 3.52, ["Ride"] = 23.14, ["Fly|Ride"] = 64.31, ["Neon"] = 28.3, ["Neon|Ride"] = 65.61, ["Neon|Fly|Ride"] = 167.99, ["Mega"] = 303.53, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 12.34, ["Fly"] = 145.27, ["Ride"] = 49.88, ["Fly|Ride"] = 117.25, ["Neon"] = 110.86, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 327.48, ["Mega"] = 650.4, ["Mega|Ride"] = 454.77, ["Mega|Fly|Ride"] = 637.39}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 21.37, ["Neon"] = 2.1, ["Neon|Fly"] = 32.81, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 90.57, ["Mega"] = 21, ["Mega|Ride"] = 54.22, ["Mega|Fly|Ride"] = 145.27}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 29.28, ["Fly"] = 210, ["Ride"] = 65.61, ["Fly|Ride"] = 218.05, ["Neon"] = 156.59, ["Neon|Ride"] = 259.09, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 624.28, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 634.24, ["Mega|Fly|Ride"] = 1003.77}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 13.13, ["Fly"] = 43.37, ["Ride"] = 26.25, ["Fly|Ride"] = 89.98, ["Neon"] = 376.69, ["Neon|Ride"] = 121.8, ["Neon|Fly|Ride"] = 166.94, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 518.16}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 10.85, ["Ride"] = 52.5, ["Neon"] = 64.32, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 145.27, ["Mega"] = 233.61, ["Mega|Ride"] = 314.44, ["Mega|Fly|Ride"] = 432.52}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 8.29, ["Fly"] = 72.19, ["Ride"] = 72.18, ["Fly|Ride"] = 239.76, ["Neon"] = 54.22, ["Neon|Ride"] = 88.91, ["Neon|Fly|Ride"] = 190.31, ["Mega"] = 242.19, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Fly"] = 43.37, ["Ride"] = 36.66, ["Fly|Ride"] = 196.88, ["Neon"] = 8.72, ["Neon|Ride"] = 36.3, ["Neon|Fly|Ride"] = 105, ["Mega"] = 69.57, ["Mega|Fly"] = 216.81, ["Mega|Ride"] = 89.98, ["Mega|Fly|Ride"] = 289.44}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 58.89, ["Neon"] = 5.2, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 145.29, ["Mega"] = 44.56, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 195.33}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 32.89}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 49.23, ["Fly"] = 101.07, ["Ride"] = 53.82, ["Fly|Ride"] = 91.87, ["Neon"] = 184.58, ["Neon|Ride"] = 216.81, ["Neon|Fly|Ride"] = 289.44, ["Mega"] = 1854.36, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 853.58}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Fly|Ride"] = 108.41, ["Neon"] = 2.63, ["Neon|Ride"] = 37.95, ["Mega"] = 20.85, ["Mega|Ride"] = 115.31, ["Mega|Fly|Ride"] = 325.2}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 525, ["Fly"] = 578.86, ["Ride"] = 564.9, ["Fly|Ride"] = 698.09, ["Neon"] = 2890.97, ["Neon|Ride"] = 2709.94, ["Neon|Fly|Ride"] = 2240.59, ["Mega"] = 17343.56, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 7.12, ["Fly"] = 48.86, ["Ride"] = 33.73, ["Fly|Ride"] = 66.13, ["Neon"] = 9.81, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 115.9, ["Mega"] = 289.44, ["Mega|Ride"] = 195.57, ["Mega|Fly|Ride"] = 636.3}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 3.64, ["Fly"] = 29.12, ["Ride"] = 21, ["Fly|Ride"] = 63.97, ["Neon"] = 26.17, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 147, ["Mega|Fly"] = 289.44, ["Mega|Ride"] = 175.88, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 9.96, ["Ride"] = 58.47, ["Fly|Ride"] = 541.99, ["Neon"] = 112.87, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 313.69, ["Mega"] = 527.9, ["Mega|Ride"] = 388.5, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 2.44, ["Fly"] = 58.55, ["Ride"] = 38.57, ["Fly|Ride"] = 72.64, ["Neon"] = 37.7, ["Neon|Fly"] = 72.64, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 392.44, ["Mega"] = 282.19, ["Mega|Fly|Ride"] = 505.14}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 15.28, ["Ride"] = 73.5, ["Fly|Ride"] = 196.88, ["Neon"] = 61.69, ["Neon|Ride"] = 97.13, ["Neon|Fly|Ride"] = 143.1, ["Mega"] = 536.59, ["Mega|Ride"] = 415.8, ["Mega|Fly|Ride"] = 723.02}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 5.97, ["Ride"] = 26.25, ["Fly|Ride"] = 91.88, ["Neon"] = 28.21, ["Neon|Ride"] = 82.1, ["Neon|Fly|Ride"] = 277.52, ["Mega"] = 222.02, ["Mega|Ride"] = 329.47, ["Mega|Fly|Ride"] = 349.13}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 45.21, ["Ride"] = 13.13, ["Fly|Ride"] = 86.73, ["Neon"] = 2.1, ["Neon|Fly"] = 41.99, ["Neon|Ride"] = 18.19, ["Neon|Fly|Ride"] = 53.82, ["Mega"] = 15.27, ["Mega|Fly"] = 66.24, ["Mega|Ride"] = 49.07, ["Mega|Fly|Ride"] = 145.27}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 5.25, ["Fly"] = 49.88, ["Ride"] = 56.43, ["Fly|Ride"] = 108.41, ["Neon"] = 36.66, ["Neon|Fly"] = 122.67, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 220.38, ["Mega"] = 196.88, ["Mega|Ride"] = 259.88, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 258.46, ["Ride"] = 301.88, ["Fly|Ride"] = 383.25, ["Neon"] = 1308.65, ["Neon|Ride"] = 1043.44, ["Neon|Fly|Ride"] = 1050, ["Mega|Ride"] = 9517.38, ["Mega|Fly|Ride"] = 4345.14}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 100.95, ["Ride"] = 105, ["Fly|Ride"] = 259.09, ["Neon"] = 458.07, ["Neon|Fly"] = 927.9, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 643.9, ["Mega"] = 2313.21, ["Mega|Ride"] = 1732.2, ["Mega|Fly|Ride"] = 1827}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 16.03, ["Ride"] = 15.75, ["Fly|Ride"] = 32.82, ["Neon"] = 7.33, ["Neon|Fly"] = 72.64, ["Neon|Ride"] = 28.21, ["Neon|Fly|Ride"] = 72.64, ["Mega"] = 145.27, ["Mega|Fly"] = 215.73, ["Mega|Ride"] = 101.91, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 22.99, ["Ride"] = 16.28, ["Fly|Ride"] = 36.75, ["Neon"] = 11.8, ["Neon|Fly"] = 32.81, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 56.6, ["Mega"] = 51.19, ["Mega|Fly"] = 289.44, ["Mega|Ride"] = 90.81, ["Mega|Fly|Ride"] = 144.34}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 3.11, ["Fly"] = 101.91, ["Ride"] = 22.32, ["Fly|Ride"] = 98.44, ["Neon"] = 105, ["Neon|Ride"] = 33.13, ["Neon|Fly|Ride"] = 157.5, ["Mega|Ride"] = 332.05, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 209.94, ["Fly"] = 327.48, ["Ride"] = 253.32, ["Fly|Ride"] = 334.69, ["Neon"] = 1192.38, ["Neon|Ride"] = 1050, ["Neon|Fly|Ride"] = 1606.45, ["Mega|Ride"] = 8671.79, ["Mega|Fly|Ride"] = 3758.14}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.63, ["Fly"] = 31.29, ["Ride"] = 18.37, ["Fly|Ride"] = 43.09, ["Neon"] = 15.15, ["Neon|Fly"] = 104.97, ["Neon|Ride"] = 39.03, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 262.5, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 3.78, ["Ride"] = 77.97, ["Fly|Ride"] = 216.01, ["Neon"] = 26.25, ["Neon|Ride"] = 108.41, ["Neon|Fly|Ride"] = 289.44, ["Mega"] = 196.88, ["Mega|Ride"] = 303.19, ["Mega|Fly|Ride"] = 432.52}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Neon"] = 11.46, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 62.34, ["Mega"] = 103.69}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 12.04, ["Fly"] = 49.65, ["Ride"] = 27.2, ["Fly|Ride"] = 68.3, ["Neon"] = 160.43, ["Neon|Ride"] = 94.32, ["Neon|Fly|Ride"] = 150.94, ["Mega"] = 288.75, ["Mega|Ride"] = 501.38, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 42.93, ["Ride"] = 91.88, ["Fly|Ride"] = 292.84, ["Neon"] = 128.63, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 190.21, ["Neon|Fly|Ride"] = 290, ["Mega"] = 505.02, ["Mega|Fly"] = 2276.35, ["Mega|Ride"] = 488.9, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 22.2, ["Ride"] = 47.72, ["Fly|Ride"] = 86.73, ["Neon"] = 155.76, ["Neon|Fly"] = 286.43, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 223.12, ["Mega"] = 867.19, ["Mega|Ride"] = 700.88, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 13.13, ["Fly|Ride"] = 32.82, ["Neon"] = 2.1, ["Neon|Fly"] = 32.45, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 18.38, ["Mega|Fly"] = 433.6, ["Mega|Ride"] = 39.03, ["Mega|Fly|Ride"] = 89.25}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 207.32, ["Ride"] = 244.13, ["Fly|Ride"] = 262.5, ["Neon"] = 814.08, ["Neon|Ride"] = 814.08, ["Neon|Fly|Ride"] = 866.12, ["Mega|Fly|Ride"] = 3758.14}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 10.75, ["Fly"] = 101.18, ["Ride"] = 24.9, ["Fly|Ride"] = 92.94, ["Neon"] = 78.75, ["Neon|Ride"] = 145.27, ["Neon|Fly|Ride"] = 289.44, ["Mega"] = 413.44, ["Mega|Ride"] = 578.86, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 35.98, ["Ride"] = 18.78, ["Fly|Ride"] = 50.71, ["Neon"] = 7.95, ["Neon|Fly"] = 43.37, ["Neon|Ride"] = 29.28, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 61.8, ["Mega|Fly"] = 231.98, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 32.54, ["Ride"] = 17.85, ["Fly|Ride"] = 80.22, ["Neon"] = 2.1, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 22.16, ["Neon|Fly|Ride"] = 116, ["Mega"] = 23.8, ["Mega|Fly"] = 144.38, ["Mega|Ride"] = 72.64, ["Mega|Fly|Ride"] = 163.7}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Ride"] = 28.59, ["Fly|Ride"] = 44.63, ["Neon"] = 11.88, ["Neon|Fly"] = 735.9, ["Neon|Ride"] = 48.38, ["Mega"] = 156.19, ["Mega|Ride"] = 135.87, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 12.73, ["Fly"] = 47.23, ["Ride"] = 31.5, ["Fly|Ride"] = 70.88, ["Neon"] = 42, ["Neon|Fly"] = 275.35, ["Neon|Ride"] = 47.16, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 613.25, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 578.86}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 17.93, ["Ride"] = 101.91, ["Neon"] = 108.41, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 253.67, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 490.61}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 57.75, ["Neon"] = 3.13, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 101.91, ["Mega"] = 19.08, ["Mega|Ride"] = 73.41, ["Mega|Fly|Ride"] = 158.69}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 7.88, ["Fly"] = 83.99, ["Ride"] = 33.88, ["Fly|Ride"] = 103, ["Neon"] = 37.72, ["Neon|Fly"] = 102.8, ["Neon|Ride"] = 49.07, ["Neon|Fly|Ride"] = 289.44, ["Mega"] = 131.25, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 308.44}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.24, ["Ride"] = 31.5, ["Neon"] = 3.61, ["Neon|Fly"] = 116, ["Neon|Ride"] = 29.28, ["Neon|Fly|Ride"] = 105, ["Mega"] = 26.17, ["Mega|Ride"] = 122.5, ["Mega|Fly|Ride"] = 260.16}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 51.18, ["Ride"] = 23.31, ["Fly|Ride"] = 44.63, ["Neon"] = 3.5, ["Neon|Ride"] = 27.3, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 45.46, ["Mega|Ride"] = 106.6, ["Mega|Fly|Ride"] = 207.06}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 616.88, ["Ride"] = 708.75, ["Fly|Ride"] = 771.75, ["Neon"] = 2625, ["Neon|Ride"] = 3615.06, ["Neon|Fly|Ride"] = 3434.11, ["Mega|Fly|Ride"] = 9620.63}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 16.48, ["Ride"] = 15.74, ["Fly|Ride"] = 41.21, ["Neon"] = 18.38, ["Neon|Fly"] = 43.14, ["Neon|Ride"] = 27.27, ["Neon|Fly|Ride"] = 105}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 4.27, ["Ride"] = 51.19, ["Neon"] = 12.48, ["Neon|Fly"] = 758.79, ["Neon|Ride"] = 86.63, ["Neon|Fly|Ride"] = 162.75, ["Mega"] = 74.82, ["Mega|Fly"] = 216.81, ["Mega|Ride"] = 163.59, ["Mega|Fly|Ride"] = 291.38}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 8.94, ["Fly"] = 44.63, ["Ride"] = 26.25, ["Fly|Ride"] = 63, ["Neon"] = 48.56, ["Neon|Fly"] = 194.86, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 485.63, ["Mega|Ride"] = 308.43, ["Mega|Fly|Ride"] = 343.87}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 58.96, ["Ride"] = 19.51, ["Fly|Ride"] = 45.54, ["Neon"] = 6.97, ["Neon|Fly"] = 151.77, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 62.89, ["Mega"] = 62.89, ["Mega|Ride"] = 94.55, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 36.01, ["Ride"] = 65.63, ["Fly|Ride"] = 319.79, ["Neon"] = 196.88, ["Neon|Ride"] = 210, ["Mega"] = 745.79, ["Mega|Ride"] = 795.65, ["Mega|Fly|Ride"] = 723.02}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 24.66, ["Fly|Ride"] = 145.27, ["Neon"] = 7.88, ["Neon|Fly"] = 139.83, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 115.85, ["Mega"] = 47.25, ["Mega|Ride"] = 112.75, ["Mega|Fly|Ride"] = 279.57}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 21.38, ["Fly|Ride"] = 63.02, ["Neon"] = 13.11, ["Neon|Ride"] = 47.59, ["Mega"] = 113.9, ["Mega|Ride"] = 198.59, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Ride"] = 43.37, ["Fly|Ride"] = 65.83, ["Neon"] = 11.34, ["Neon|Fly|Ride"] = 116, ["Mega"] = 97.12, ["Mega|Ride"] = 65.63}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 43.37, ["Ride"] = 17.8, ["Fly|Ride"] = 69.21, ["Neon"] = 3.94, ["Neon|Fly"] = 72.24, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 108.15, ["Mega"] = 43.3, ["Mega|Fly"] = 229.69, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 145.27}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 13.13, ["Fly"] = 22.16, ["Ride"] = 22.55, ["Fly|Ride"] = 42.59, ["Neon"] = 118.13, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 82.21, ["Neon|Fly|Ride"] = 143.1, ["Mega|Ride"] = 433.6, ["Mega|Fly|Ride"] = 441.96}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 780.94, ["Fly"] = 1083.98, ["Ride"] = 771.65, ["Fly|Ride"] = 853.13, ["Neon"] = 1935.94, ["Neon|Ride"] = 2100, ["Neon|Fly|Ride"] = 2164.32, ["Mega"] = 8094.02, ["Mega|Ride"] = 5709.3, ["Mega|Fly|Ride"] = 4508.44}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 19.59, ["Ride"] = 16.54, ["Fly|Ride"] = 41.48, ["Neon"] = 6.36, ["Neon|Ride"] = 21.86, ["Neon|Fly|Ride"] = 70.88, ["Mega"] = 43.36, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 155.54}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 6.22, ["Ride"] = 36.75, ["Fly|Ride"] = 72.64, ["Neon"] = 58.89, ["Neon|Ride"] = 216.57, ["Neon|Fly|Ride"] = 236.25, ["Mega|Ride"] = 393.74, ["Mega|Fly|Ride"] = 433.6}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 55.13, ["Fly"] = 104.9, ["Ride"] = 78.75, ["Fly|Ride"] = 116.71, ["Neon"] = 315, ["Neon|Ride"] = 313.69, ["Neon|Fly|Ride"] = 405.42, ["Mega"] = 2439.83, ["Mega|Fly|Ride"] = 2623.69}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 31.4, ["Fly"] = 146.86, ["Ride"] = 51.45, ["Fly|Ride"] = 107.94, ["Neon"] = 231.98, ["Neon|Ride"] = 173.45, ["Neon|Fly|Ride"] = 433.6, ["Mega"] = 2024.88, ["Mega|Ride"] = 938.74, ["Mega|Fly|Ride"] = 853.1}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 10.17, ["Fly"] = 95.68, ["Ride"] = 27.32, ["Neon"] = 53.2, ["Neon|Ride"] = 108.41, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 305.36, ["Mega|Ride"] = 419.51, ["Mega|Fly|Ride"] = 462}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 23.63, ["Ride"] = 59.07, ["Fly|Ride"] = 143.1, ["Neon"] = 105, ["Neon|Ride"] = 106.32, ["Neon|Fly|Ride"] = 152.25, ["Mega"] = 324.13, ["Mega|Fly"] = 532.3, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 397.69}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 20.79, ["Ride"] = 78.75, ["Neon"] = 145.69, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 525, ["Mega"] = 525, ["Mega|Fly"] = 567, ["Mega|Ride"] = 476.44, ["Mega|Fly|Ride"] = 756.62}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 5.1}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 5.9, ["Ride"] = 29.27, ["Fly|Ride"] = 78.75, ["Neon"] = 35.44, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 213.97, ["Mega"] = 210, ["Mega|Fly"] = 458.27, ["Mega|Ride"] = 233.63, ["Mega|Fly|Ride"] = 308.05}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 3.29, ["Neon"] = 12.73, ["Neon|Fly|Ride"] = 216.81, ["Mega"] = 143.07, ["Mega|Fly|Ride"] = 409.5}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 32.3, ["Fly"] = 62.99, ["Ride"] = 43.55, ["Fly|Ride"] = 86.03, ["Neon"] = 220.5, ["Neon|Fly"] = 289.44, ["Neon|Ride"] = 231, ["Neon|Fly|Ride"] = 240.35, ["Mega|Ride"] = 578.86, ["Mega|Fly|Ride"] = 616.87}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.21, ["Fly"] = 28.88, ["Ride"] = 19.52, ["Fly|Ride"] = 40.69, ["Neon"] = 29.14, ["Neon|Fly"] = 69.57, ["Neon|Ride"] = 31.4, ["Neon|Fly|Ride"] = 69.57, ["Mega"] = 232.31, ["Mega|Fly"] = 432.52, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 198.18}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 5.66, ["Fly"] = 31.9, ["Ride"] = 26.16, ["Fly|Ride"] = 72.64, ["Neon"] = 25.99, ["Neon|Ride"] = 55.76, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 177.65, ["Mega|Fly"] = 197.4, ["Mega|Ride"] = 180.01, ["Mega|Fly|Ride"] = 350.44}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 6.51, ["Mega"] = 40.69, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 258.57}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 43.37, ["Ride"] = 69.91, ["Fly|Ride"] = 80.22, ["Neon"] = 163.61, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 433.6, ["Mega|Ride"] = 858.52, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 20.16, ["Fly|Ride"] = 58.43, ["Neon"] = 7.65, ["Neon|Fly"] = 203.44, ["Neon|Ride"] = 41.98, ["Neon|Fly|Ride"] = 105, ["Mega"] = 72.64, ["Mega|Ride"] = 139.94}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 8.52, ["Ride"] = 87.94, ["Fly|Ride"] = 288.35, ["Neon"] = 56.43, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 325.2, ["Mega"] = 403.26, ["Mega|Fly"] = 578.86, ["Mega|Ride"] = 400.77, ["Mega|Fly|Ride"] = 723.02}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 45.92, ["Ride"] = 15.94, ["Fly|Ride"] = 61.69, ["Neon"] = 29.28, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 99.74, ["Mega"] = 194.25, ["Mega|Ride"] = 207.06, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 6.51, ["Fly"] = 52.49, ["Ride"] = 19.29, ["Fly|Ride"] = 42.26, ["Neon"] = 48.16, ["Neon|Fly"] = 130.09, ["Neon|Ride"] = 145.27, ["Neon|Fly|Ride"] = 170.63, ["Mega|Ride"] = 432.52, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 10.02, ["Neon"] = 90.01, ["Mega"] = 418.06, ["Mega|Ride"] = 366.19, ["Mega|Fly|Ride"] = 645.74}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 49.64, ["Ride"] = 98.43, ["Fly|Ride"] = 480.26, ["Neon"] = 393.75, ["Neon|Ride"] = 486.72, ["Neon|Fly|Ride"] = 669.38, ["Mega"] = 1409.18, ["Mega|Fly|Ride"] = 1942.5}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 15.03, ["Ride"] = 78.65, ["Fly|Ride"] = 161.28, ["Neon"] = 107.62, ["Mega"] = 380.63, ["Mega|Ride"] = 572.78, ["Mega|Fly|Ride"] = 723.02}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 6.37, ["Ride"] = 126.04, ["Neon"] = 40.37, ["Neon|Fly"] = 216.81, ["Neon|Ride"] = 170.63, ["Mega|Ride"] = 865.03}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 23.62, ["Ride"] = 105, ["Fly|Ride"] = 367.48, ["Neon"] = 130.13, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 679.66, ["Mega|Fly"] = 2167.95, ["Mega|Ride"] = 735.9, ["Mega|Fly|Ride"] = 813}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 3.42, ["Neon"] = 19.32, ["Neon|Fly|Ride"] = 145.27, ["Mega"] = 184.29, ["Mega|Fly|Ride"] = 327.48}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 19.35, ["Fly|Ride"] = 41.91, ["Neon"] = 3.64, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 98.13, ["Mega"] = 65.63, ["Mega|Ride"] = 76.13, ["Mega|Fly|Ride"] = 144.36}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 21.7, ["Fly|Ride"] = 75.49, ["Neon"] = 16.52, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 164.06, ["Mega"] = 87.46, ["Mega|Ride"] = 143.1, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 145.27, ["Ride"] = 18.89, ["Fly|Ride"] = 39.38, ["Neon"] = 6.57, ["Neon|Ride"] = 29.28, ["Neon|Fly|Ride"] = 92.18, ["Mega"] = 55, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 158.28}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 3.39, ["Fly"] = 65.62, ["Ride"] = 19.69, ["Fly|Ride"] = 81.31, ["Neon"] = 17.92, ["Neon|Ride"] = 108.41, ["Neon|Fly|Ride"] = 216.81, ["Mega"] = 332.79, ["Mega|Ride"] = 331.71, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.77, ["Fly"] = 56.07, ["Ride"] = 24.53, ["Fly|Ride"] = 433.6, ["Neon"] = 30.19, ["Neon|Fly"] = 315, ["Neon|Ride"] = 85.32, ["Mega"] = 307.86, ["Mega|Ride"] = 287.47, ["Mega|Fly|Ride"] = 1083.98}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 3.66, ["Fly"] = 131.25, ["Ride"] = 31.45, ["Fly|Ride"] = 53.23, ["Neon"] = 43.37, ["Neon|Fly"] = 130.09, ["Neon|Ride"] = 45.02, ["Neon|Fly|Ride"] = 81.31, ["Mega"] = 301.88, ["Mega|Ride"] = 294, ["Mega|Fly|Ride"] = 406.5}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 35.48, ["Ride"] = 22.32, ["Fly|Ride"] = 52.41, ["Neon"] = 22.32, ["Neon|Ride"] = 29.28, ["Neon|Fly|Ride"] = 108.41, ["Mega"] = 260.16, ["Mega|Ride"] = 318.29, ["Mega|Fly|Ride"] = 186.18}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 3.46, ["Fly"] = 196.88, ["Ride"] = 47.22, ["Fly|Ride"] = 131.25, ["Neon"] = 12.35, ["Neon|Fly"] = 437.06, ["Neon|Ride"] = 66.93, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 107.63, ["Mega|Fly"] = 216.57, ["Mega|Ride"] = 129.93, ["Mega|Fly|Ride"] = 269.98}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 29.28, ["Fly"] = 113.82, ["Ride"] = 126, ["Fly|Ride"] = 433.6, ["Neon"] = 157.49, ["Neon|Fly"] = 288.75, ["Neon|Ride"] = 289.44, ["Neon|Fly|Ride"] = 241.5, ["Mega"] = 733.97}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 55.31, ["Fly"] = 164.07, ["Ride"] = 84, ["Fly|Ride"] = 162.75, ["Neon"] = 240.9, ["Neon|Ride"] = 270.9, ["Neon|Fly|Ride"] = 431.82, ["Mega"] = 1589.12, ["Mega|Ride"] = 1063.13, ["Mega|Fly|Ride"] = 1284.94}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Ride"] = 21.57, ["Fly|Ride"] = 52.04, ["Neon"] = 2.62, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 145.27, ["Mega"] = 27, ["Mega|Ride"] = 71.04, ["Mega|Fly|Ride"] = 145.27}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 7.88, ["Ride"] = 78.75, ["Neon"] = 115.31, ["Mega"] = 686.56, ["Mega|Fly|Ride"] = 1142.52}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 53.17, ["Ride"] = 91.92, ["Fly|Ride"] = 172.66, ["Neon"] = 249.37, ["Neon|Ride"] = 357, ["Neon|Fly|Ride"] = 866.12, ["Mega"] = 1786.4, ["Mega|Fly|Ride"] = 1458.19}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 6.41, ["Fly"] = 190.32, ["Ride"] = 32.33, ["Fly|Ride"] = 133.88, ["Neon"] = 46.39, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 127.92, ["Mega"] = 267.46, ["Mega|Fly"] = 740.8, ["Mega|Ride"] = 242.82, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 6.48, ["Fly"] = 87.62, ["Neon"] = 25.46, ["Neon|Ride"] = 66.91, ["Mega"] = 103.69, ["Mega|Fly"] = 282.17, ["Mega|Ride"] = 133.88}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 28.87, ["Ride"] = 19.26, ["Fly|Ride"] = 57.38, ["Neon"] = 19.69, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 84, ["Mega"] = 173.25, ["Mega|Ride"] = 131.15, ["Mega|Fly|Ride"] = 433.6}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 17.11, ["Ride"] = 17.07, ["Fly|Ride"] = 52.31, ["Neon"] = 2.62, ["Neon|Fly"] = 34.7, ["Neon|Ride"] = 19.68, ["Neon|Fly|Ride"] = 52.41, ["Mega"] = 27.2, ["Mega|Ride"] = 69.57, ["Mega|Fly|Ride"] = 154.8}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 82.19, ["Neon"] = 3.94, ["Neon|Ride"] = 24.93, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 43.37, ["Mega|Fly"] = 154.94, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 173.25}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Neon"] = 2.62, ["Neon|Ride"] = 145.08, ["Mega"] = 42.3, ["Mega|Ride"] = 110.25, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 5.86, ["Ride"] = 105, ["Neon"] = 65.63, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 332.79, ["Mega|Ride"] = 260.59, ["Mega|Fly|Ride"] = 427.23}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 3.84, ["Ride"] = 30.19, ["Fly|Ride"] = 215.87, ["Neon"] = 58.62, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 145.27, ["Mega"] = 262.5, ["Mega|Ride"] = 233.89, ["Mega|Fly|Ride"] = 433.6}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 10.49, ["Fly"] = 26.03, ["Ride"] = 22.77, ["Fly|Ride"] = 42, ["Neon"] = 21, ["Neon|Ride"] = 35.23, ["Neon|Fly|Ride"] = 91.76, ["Mega"] = 351.22, ["Mega|Ride"] = 311.37, ["Mega|Fly|Ride"] = 401.63}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 70.75, ["Ride"] = 78.75, ["Fly|Ride"] = 124.69, ["Neon"] = 393.75, ["Neon|Ride"] = 432.52, ["Neon|Fly|Ride"] = 723.02, ["Mega"] = 2452.95, ["Mega|Ride"] = 1633.56, ["Mega|Fly|Ride"] = 1472.63}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 19.55, ["Fly"] = 82.69, ["Ride"] = 58.97, ["Fly|Ride"] = 116, ["Neon"] = 50.96, ["Neon|Fly|Ride"] = 630, ["Mega"] = 433.6, ["Mega|Ride"] = 879.38, ["Mega|Fly|Ride"] = 1083.98}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 19.68, ["Ride"] = 15.64, ["Fly|Ride"] = 43.37, ["Neon"] = 2.5, ["Neon|Fly"] = 44.17, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 56.44, ["Mega"] = 36.75, ["Mega|Fly"] = 145.27, ["Mega|Ride"] = 93.44, ["Mega|Fly|Ride"] = 169.26}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 17.07, ["Fly|Ride"] = 32.82, ["Neon"] = 4.08, ["Neon|Fly"] = 27.54, ["Neon|Ride"] = 21.69, ["Neon|Fly|Ride"] = 43.32, ["Mega"] = 45.98, ["Mega|Ride"] = 49.37, ["Mega|Fly|Ride"] = 98.44}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 406.86, ["Fly"] = 758.35, ["Ride"] = 441.83, ["Fly|Ride"] = 511.77, ["Neon"] = 1995.48, ["Neon|Ride"] = 1951.16, ["Neon|Fly|Ride"] = 2059.56, ["Mega|Fly|Ride"] = 6503.84}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 8.42, ["Ride"] = 47.71, ["Neon"] = 23.86, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 403.5, ["Mega|Ride"] = 719.78, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 16.28, ["Ride"] = 15.75, ["Fly|Ride"] = 34.13, ["Neon"] = 6.47, ["Neon|Fly"] = 23.8, ["Neon|Ride"] = 18.17, ["Neon|Fly|Ride"] = 49.88, ["Mega"] = 63.97, ["Mega|Ride"] = 145.17, ["Mega|Fly|Ride"] = 112.75}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 43.59, ["Ride"] = 111.56, ["Fly|Ride"] = 286.18, ["Neon"] = 198.65, ["Neon|Ride"] = 259.51, ["Neon|Fly|Ride"] = 426.57, ["Mega"] = 737.63, ["Mega|Ride"] = 682.5, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 4.68, ["Fly"] = 24.87, ["Ride"] = 21.87, ["Fly|Ride"] = 122.67, ["Neon"] = 16.17, ["Neon|Fly"] = 80.22, ["Neon|Ride"] = 32.69, ["Neon|Fly|Ride"] = 93.08, ["Mega"] = 123.38, ["Mega|Ride"] = 129.92, ["Mega|Fly|Ride"] = 233.62}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Ride"] = 54.22, ["Fly|Ride"] = 196.88, ["Neon"] = 2.52, ["Neon|Fly"] = 101.91, ["Neon|Ride"] = 39.9, ["Neon|Fly|Ride"] = 111.55, ["Mega"] = 18.38, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 35.78, ["Fly"] = 129.94, ["Ride"] = 72.64, ["Fly|Ride"] = 215.54, ["Neon"] = 131.25, ["Neon|Ride"] = 208.69, ["Neon|Fly|Ride"] = 288.74, ["Mega"] = 708.93, ["Mega|Ride"] = 647.05, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Fly"] = 23.63, ["Ride"] = 19.69, ["Fly|Ride"] = 146.99, ["Neon"] = 3.89, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 86.73, ["Mega"] = 62.88, ["Mega|Ride"] = 157.25, ["Mega|Fly|Ride"] = 252}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 27.98, ["Ride"] = 64.75, ["Fly|Ride"] = 104.99, ["Neon"] = 283.23, ["Neon|Ride"] = 288.75, ["Neon|Fly|Ride"] = 288.46, ["Mega"] = 1181.25, ["Mega|Ride"] = 1300.78, ["Mega|Fly|Ride"] = 1333.83}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 3.47, ["Fly"] = 72.64, ["Ride"] = 131.25, ["Fly|Ride"] = 433.6, ["Neon"] = 18.38, ["Neon|Ride"] = 231, ["Neon|Fly|Ride"] = 505.86, ["Mega"] = 164.24, ["Mega|Ride"] = 236.25}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.63, ["Fly"] = 72.64, ["Ride"] = 78.1, ["Fly|Ride"] = 58.55, ["Neon"] = 10.89, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 441.54, ["Mega"] = 117.6, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 305.7}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 51.45, ["Fly"] = 162.61, ["Ride"] = 105, ["Fly|Ride"] = 196.88, ["Neon"] = 359.63, ["Neon|Ride"] = 419.41, ["Mega"] = 1777.73, ["Mega|Ride"] = 2756.25, ["Mega|Fly|Ride"] = 2024.88}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 587.48, ["Ride"] = 45.86, ["Neon"] = 7.23, ["Neon|Ride"] = 55.3, ["Neon|Fly|Ride"] = 115.99, ["Mega"] = 45.94, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 277.34}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 17.74, ["Ride"] = 19.49, ["Fly|Ride"] = 36.87, ["Neon"] = 8.69, ["Neon|Fly"] = 42, ["Neon|Ride"] = 25.91, ["Neon|Fly|Ride"] = 73.33, ["Mega"] = 59.13, ["Mega|Fly"] = 150.88, ["Mega|Ride"] = 81.38, ["Mega|Fly|Ride"] = 219.43}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 11.32, ["Fly"] = 57.91, ["Ride"] = 37.26, ["Fly|Ride"] = 195.57, ["Neon"] = 80.12, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 196.25, ["Mega"] = 289.44, ["Mega|Ride"] = 275.62, ["Mega|Fly|Ride"] = 355.56}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 6.56, ["Fly"] = 43.37, ["Ride"] = 24.29, ["Fly|Ride"] = 72.64, ["Neon"] = 86.1, ["Neon|Ride"] = 55.3, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 354.38, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 867.19}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 23.62, ["Fly"] = 48.57, ["Ride"] = 28.69, ["Fly|Ride"] = 65.63, ["Neon"] = 92.32, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 154.07, ["Mega"] = 408.98, ["Mega|Ride"] = 327.44, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 69.46, ["Ride"] = 128.25, ["Fly|Ride"] = 202.55, ["Neon"] = 257.24, ["Neon|Ride"] = 283.49, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 1575, ["Mega|Ride"] = 1625.97, ["Mega|Fly|Ride"] = 1669.33}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 10.06, ["Ride"] = 115.4, ["Fly|Ride"] = 203.44, ["Neon"] = 58.38, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 296.1, ["Mega"] = 241.5, ["Mega|Fly"] = 576.69, ["Mega|Ride"] = 343.42, ["Mega|Fly|Ride"] = 572.35}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 4.62, ["Ride"] = 27.3, ["Fly|Ride"] = 78.74, ["Neon"] = 24.28, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 289.44, ["Mega|Ride"] = 243.91, ["Mega|Fly|Ride"] = 490.61}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 11.04, ["Fly"] = 135.19, ["Ride"] = 36.37, ["Fly|Ride"] = 115.5, ["Neon"] = 57.63, ["Neon|Ride"] = 60.73, ["Mega"] = 317.63, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 13.13, ["Fly|Ride"] = 45.94, ["Neon"] = 2.1, ["Neon|Fly"] = 21.7, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 55, ["Mega"] = 14.44, ["Mega|Fly"] = 42, ["Mega|Ride"] = 27.66, ["Mega|Fly|Ride"] = 115.48}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 55.13, ["Fly"] = 229.82, ["Ride"] = 102.66, ["Fly|Ride"] = 164.36, ["Neon"] = 236.25, ["Neon|Fly"] = 2457.38, ["Neon|Ride"] = 294, ["Neon|Fly|Ride"] = 487.8, ["Mega"] = 1081.82, ["Mega|Ride"] = 1142.52, ["Mega|Fly|Ride"] = 905.63}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 23.61, ["Neon"] = 7.16, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 29.45, ["Mega|Ride"] = 87.09, ["Mega|Fly|Ride"] = 313.68}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 29.28, ["Ride"] = 15.75, ["Fly|Ride"] = 45.94, ["Neon"] = 17.7, ["Neon|Ride"] = 27, ["Neon|Fly|Ride"] = 89.98, ["Mega"] = 257.25, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 228.38}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 62.74, ["Fly"] = 108.41, ["Ride"] = 82.69, ["Fly|Ride"] = 258.57, ["Neon"] = 196.88, ["Neon|Ride"] = 259.88, ["Mega"] = 836.07, ["Mega|Ride"] = 1145.53, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 72.19, ["Neon"] = 8.35, ["Neon|Ride"] = 1446.04, ["Mega"] = 164.36, ["Mega|Ride"] = 116.81, ["Mega|Fly|Ride"] = 314.89}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 3.2}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 33.3, ["Fly|Ride"] = 68.31, ["Neon"] = 7.63, ["Neon|Ride"] = 84.57, ["Neon|Fly|Ride"] = 115.31, ["Mega"] = 82.69, ["Mega|Ride"] = 105.25, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 129.94, ["Ride"] = 196.07, ["Fly|Ride"] = 313.69, ["Neon"] = 656.18, ["Neon|Ride"] = 611.1, ["Neon|Fly|Ride"] = 678.57, ["Mega"] = 6503.84, ["Mega|Ride"] = 3035.13, ["Mega|Fly|Ride"] = 2643.82}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 2.12, ["Ride"] = 36.87, ["Fly|Ride"] = 216.81, ["Neon"] = 22.41, ["Neon|Fly"] = 145.27, ["Neon|Ride"] = 65.06, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 178.48, ["Mega|Ride"] = 220.5, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 26.24, ["Neon"] = 3.49, ["Neon|Ride"] = 24.69, ["Mega"] = 32.6, ["Mega|Ride"] = 72.64, ["Mega|Fly|Ride"] = 346.65}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 3.41, ["Ride"] = 32.82, ["Fly|Ride"] = 131.25, ["Neon"] = 57.36, ["Neon|Ride"] = 89.63, ["Neon|Fly|Ride"] = 160.43, ["Mega"] = 433.6, ["Mega|Ride"] = 419.51, ["Mega|Fly|Ride"] = 665.57}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 9.09, ["Fly"] = 37.31, ["Ride"] = 26.25, ["Fly|Ride"] = 58.54, ["Neon"] = 101.03, ["Neon|Ride"] = 158.17, ["Neon|Fly|Ride"] = 276.29, ["Mega"] = 626.07, ["Mega|Ride"] = 646.06, ["Mega|Fly|Ride"] = 492.19}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 21.84, ["Ride"] = 53.82, ["Fly|Ride"] = 194.04, ["Neon"] = 127.32, ["Neon|Ride"] = 208.14, ["Neon|Fly|Ride"] = 331.71, ["Mega"] = 561.75, ["Mega|Ride"] = 494.04, ["Mega|Fly|Ride"] = 599.82}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 149.63, ["Fly"] = 157.5, ["Ride"] = 191.6, ["Fly|Ride"] = 245.32, ["Neon"] = 540.92, ["Neon|Fly"] = 867.19, ["Neon|Ride"] = 540.92, ["Neon|Fly|Ride"] = 643.02, ["Mega|Ride"] = 2601.55, ["Mega|Fly|Ride"] = 2291.05}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 8.76, ["Fly"] = 20.9, ["Ride"] = 21.19, ["Fly|Ride"] = 45.94, ["Neon"] = 48.58, ["Neon|Fly"] = 160.68, ["Neon|Ride"] = 49.07, ["Neon|Fly|Ride"] = 95.4, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 372.23}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.1, ["Fly"] = 131.23, ["Ride"] = 27.48, ["Fly|Ride"] = 65.63, ["Neon"] = 20.37, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 159.85, ["Mega|Ride"] = 136.6, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 4.54, ["Fly"] = 42.78, ["Ride"] = 32.82, ["Fly|Ride"] = 90.57, ["Neon"] = 179.95, ["Neon|Fly"] = 128.63, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 173.45, ["Mega"] = 458.07, ["Mega|Ride"] = 414.41, ["Mega|Fly|Ride"] = 406.5}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 46.99, ["Fly"] = 86.73, ["Ride"] = 65.54, ["Fly|Ride"] = 134.43, ["Neon"] = 196.88, ["Neon|Ride"] = 259.88, ["Neon|Fly|Ride"] = 319.79, ["Mega"] = 945, ["Mega|Ride"] = 925.32, ["Mega|Fly|Ride"] = 958.1}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 10.49, ["Fly"] = 57.75, ["Ride"] = 72.64, ["Neon"] = 196.88, ["Neon|Ride"] = 461.78, ["Neon|Fly|Ride"] = 478.05, ["Mega"] = 809.74, ["Mega|Ride"] = 1932, ["Mega|Fly|Ride"] = 823.83}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 328.02, ["Ride"] = 578.86, ["Neon"] = 1636.13, ["Neon|Ride"] = 3271, ["Mega|Fly|Ride"] = 5203.08}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 23.97, ["Fly"] = 58.64, ["Ride"] = 29.48, ["Fly|Ride"] = 69.45, ["Neon"] = 251.5, ["Neon|Ride"] = 129.99, ["Neon|Fly|Ride"] = 199.46, ["Mega"] = 761.25, ["Mega|Ride"] = 753.27, ["Mega|Fly|Ride"] = 844.91}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 43.36, ["Ride"] = 14.44, ["Fly|Ride"] = 72.64, ["Neon"] = 2.1, ["Neon|Ride"] = 15.71, ["Neon|Fly|Ride"] = 53.82, ["Mega"] = 22.04, ["Mega|Fly"] = 114.92, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 82.19}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 5.16, ["Ride"] = 29.28, ["Neon"] = 15.23, ["Neon|Ride"] = 86.73, ["Neon|Fly|Ride"] = 164.36, ["Mega"] = 111.57, ["Mega|Ride"] = 164.17, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 6.32, ["Ride"] = 30.85, ["Fly|Ride"] = 144.2, ["Neon"] = 21.6, ["Neon|Ride"] = 58.55, ["Neon|Fly|Ride"] = 1181.23, ["Mega"] = 133.37, ["Mega|Fly"] = 575.01, ["Mega|Ride"] = 377.23, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 393.74, ["Fly"] = 505.32, ["Ride"] = 418.69, ["Fly|Ride"] = 552.57, ["Neon"] = 1898.49, ["Neon|Ride"] = 2024.88, ["Neon|Fly|Ride"] = 1246.88, ["Mega|Fly|Ride"] = 5636.67}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 3.84, ["Fly"] = 39.38, ["Ride"] = 17.07, ["Fly|Ride"] = 86.72, ["Neon"] = 26.16, ["Neon|Ride"] = 62.88, ["Neon|Fly|Ride"] = 105, ["Mega"] = 216.57, ["Mega|Ride"] = 214.65, ["Mega|Fly|Ride"] = 231}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 3.49, ["Fly"] = 22.32, ["Ride"] = 19.64, ["Fly|Ride"] = 42.94, ["Neon"] = 39.03, ["Neon|Fly"] = 156.45, ["Neon|Ride"] = 58.55, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 181.53, ["Mega|Ride"] = 293.77, ["Mega|Fly|Ride"] = 318.28}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 5.16, ["Fly"] = 42, ["Ride"] = 26.25, ["Fly|Ride"] = 52.94, ["Neon"] = 13.13, ["Neon|Fly"] = 94.48, ["Neon|Ride"] = 42.14, ["Neon|Fly|Ride"] = 113.19, ["Mega"] = 145.27, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 30.08, ["Fly"] = 49.07, ["Ride"] = 31.5, ["Fly|Ride"] = 78.75, ["Neon"] = 220.4, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 324.13, ["Mega"] = 1300.78, ["Mega|Ride"] = 862.32, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 54.22, ["Ride"] = 51.19, ["Fly|Ride"] = 51.75, ["Neon"] = 11.71, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 210, ["Mega"] = 165.4, ["Mega|Ride"] = 457.79, ["Mega|Fly|Ride"] = 919.42}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 7.72, ["Fly"] = 65.63, ["Ride"] = 71.91, ["Fly|Ride"] = 101.91, ["Neon"] = 223.13, ["Neon|Ride"] = 216.81, ["Mega"] = 748.13, ["Mega|Fly|Ride"] = 789.14}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 30.19, ["Neon"] = 6.18, ["Neon|Ride"] = 26.03, ["Neon|Fly|Ride"] = 115.31, ["Mega"] = 51.35, ["Mega|Ride"] = 124.67, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 5.15, ["Fly"] = 72.19, ["Ride"] = 33.62, ["Neon"] = 48.32, ["Mega"] = 136.02, ["Mega|Ride"] = 327.48}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 5.64, ["Ride"] = 28.23, ["Neon"] = 66.24, ["Neon|Ride"] = 289.44, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 319.79, ["Mega|Ride"] = 562.59, ["Mega|Fly|Ride"] = 463.32}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 10.5, ["Fly"] = 38.04, ["Ride"] = 27.96, ["Fly|Ride"] = 56.39, ["Neon"] = 41.1, ["Neon|Fly"] = 115.31, ["Neon|Ride"] = 51.19, ["Neon|Fly|Ride"] = 130.09, ["Mega"] = 540.92, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 431.17}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 471.68, ["Fly"] = 541.99, ["Ride"] = 430.5, ["Fly|Ride"] = 481.59, ["Neon"] = 1642.41, ["Neon|Ride"] = 1881.42, ["Neon|Fly|Ride"] = 1601.25, ["Mega|Fly|Ride"] = 7457.73}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 18.14, ["Fly|Ride"] = 39.37, ["Neon"] = 36.66, ["Neon|Fly"] = 82.19, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 184.42, ["Mega"] = 243.91, ["Mega|Ride"] = 196.77, ["Mega|Fly|Ride"] = 307.86}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 9.48, ["Fly"] = 65.06, ["Ride"] = 32.82, ["Fly|Ride"] = 188.64, ["Neon"] = 65.63, ["Neon|Ride"] = 123.59, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 359.63, ["Mega|Fly"] = 723.02, ["Mega|Ride"] = 420}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 24.93, ["Ride"] = 94.66, ["Fly|Ride"] = 236.93, ["Neon"] = 89.24, ["Neon|Ride"] = 213.94, ["Neon|Fly|Ride"] = 432.52, ["Mega"] = 325.2, ["Mega|Ride"] = 578.86, ["Mega|Fly|Ride"] = 485.63}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 52.41, ["Fly"] = 151.41, ["Ride"] = 84, ["Fly|Ride"] = 131.25, ["Neon"] = 321.56, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 380.63, ["Mega"] = 2517.26, ["Mega|Ride"] = 2890.86, ["Mega|Fly|Ride"] = 1792.86}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 8.71, ["Ride"] = 39.38, ["Fly|Ride"] = 144.38, ["Neon"] = 35.47, ["Neon|Ride"] = 106.32, ["Neon|Fly|Ride"] = 268.84, ["Mega"] = 159.44, ["Mega|Ride"] = 194.04, ["Mega|Fly|Ride"] = 401.07}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 21.7, ["Ride"] = 17.07, ["Fly|Ride"] = 57.87, ["Neon"] = 18.21, ["Neon|Ride"] = 33.53, ["Neon|Fly|Ride"] = 202.13, ["Mega"] = 65.62, ["Mega|Ride"] = 204.84, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 6.29, ["Ride"] = 45.47, ["Neon"] = 23.63, ["Neon|Ride"] = 102.38, ["Neon|Fly|Ride"] = 174.57, ["Mega"] = 137.82, ["Mega|Fly"] = 246.07, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 282.35}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 42, ["Fly"] = 183.73, ["Ride"] = 107.31, ["Fly|Ride"] = 197.73, ["Neon"] = 144.38, ["Neon|Ride"] = 161.44, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 433.6, ["Mega|Ride"] = 446.15, ["Mega|Fly|Ride"] = 572.78}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.63, ["Ride"] = 85.28, ["Neon"] = 9.17, ["Neon|Ride"] = 77.18, ["Neon|Fly|Ride"] = 231.98, ["Mega"] = 51.19, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 432.52}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 19.52, ["Ride"] = 185.07, ["Neon"] = 118.01, ["Neon|Ride"] = 374.06, ["Mega"] = 628.69, ["Mega|Ride"] = 763.13, ["Mega|Fly|Ride"] = 763.13}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 951.55, ["Fly"] = 1194.38, ["Ride"] = 1010.63, ["Fly|Ride"] = 1017.17, ["Neon"] = 4335.9, ["Neon|Ride"] = 3150, ["Neon|Fly|Ride"] = 3684.43, ["Mega|Fly|Ride"] = 11099.88}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 15.65, ["Fly"] = 112.17, ["Ride"] = 43.37, ["Fly|Ride"] = 173.73, ["Neon"] = 65.63, ["Neon|Fly"] = 721.94, ["Neon|Ride"] = 175.77, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 259.88, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.52, ["Fly"] = 49.37, ["Ride"] = 28.21, ["Fly|Ride"] = 92.53, ["Neon"] = 12.33, ["Neon|Fly"] = 79.83, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 80.55, ["Mega"] = 63, ["Mega|Ride"] = 90.67, ["Mega|Fly|Ride"] = 324.13}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 11.85, ["Ride"] = 131.25, ["Fly|Ride"] = 145.27, ["Neon"] = 63, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 393.73, ["Mega"] = 288.73, ["Mega|Ride"] = 430.61, ["Mega|Fly|Ride"] = 924}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 23.39, ["Fly|Ride"] = 187.69, ["Neon"] = 2.63, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 20.58, ["Mega|Ride"] = 47.87, ["Mega|Fly|Ride"] = 118.12}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 52.19, ["Ride"] = 110.51, ["Fly|Ride"] = 266.44, ["Neon"] = 220.47, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 413, ["Mega"] = 943.05, ["Mega|Ride"] = 879.37, ["Mega|Fly|Ride"] = 925.32}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 8.9, ["Ride"] = 62.88, ["Fly|Ride"] = 286.57, ["Neon"] = 154.87, ["Neon|Ride"] = 143.1, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 418.69, ["Mega|Ride"] = 835.75, ["Mega|Fly|Ride"] = 813}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2.1, ["Ride"] = 23.2, ["Neon"] = 13.13, ["Neon|Ride"] = 40.56, ["Neon|Fly|Ride"] = 216.81, ["Mega"] = 98.14, ["Mega|Ride"] = 145.27, ["Mega|Fly|Ride"] = 376.16}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 15.09, ["Fly"] = 160.43, ["Ride"] = 40.4, ["Fly|Ride"] = 91.88, ["Neon"] = 77.24, ["Neon|Ride"] = 95.45, ["Neon|Fly|Ride"] = 271.07, ["Mega"] = 409.17, ["Mega|Ride"] = 419.99, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 4.82, ["Fly"] = 97.57, ["Ride"] = 27.35, ["Fly|Ride"] = 173.45, ["Neon"] = 27.32, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 57.75, ["Neon|Fly|Ride"] = 144.19, ["Mega"] = 433.6, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 430.5}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 31.82, ["Ride"] = 91.88, ["Neon"] = 253.67, ["Neon|Ride"] = 260.16, ["Neon|Fly|Ride"] = 289.44, ["Mega"] = 2530, ["Mega|Ride"] = 2452.95, ["Mega|Fly|Ride"] = 2165.8}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 2.55, ["Ride"] = 47.71, ["Fly|Ride"] = 124.69, ["Neon"] = 15.65, ["Neon|Ride"] = 73.5, ["Neon|Fly|Ride"] = 188.62, ["Mega"] = 68.2, ["Mega|Ride"] = 111.54, ["Mega|Fly|Ride"] = 242.82}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 4.72, ["Ride"] = 31.9, ["Fly|Ride"] = 90.57, ["Neon"] = 38.06, ["Neon|Fly"] = 188.62, ["Neon|Ride"] = 69.92, ["Neon|Fly|Ride"] = 118.02, ["Mega"] = 299.95, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 281.36}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 120.65, ["Fly"] = 393.75, ["Ride"] = 157.5, ["Fly|Ride"] = 253.08, ["Neon"] = 479.07, ["Neon|Ride"] = 543.38, ["Neon|Fly|Ride"] = 636.3, ["Mega|Ride"] = 1834.96, ["Mega|Fly|Ride"] = 2125.04}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 3.5, ["Fly"] = 22.68, ["Ride"] = 18.25, ["Fly|Ride"] = 43.32, ["Neon"] = 20.79, ["Neon|Fly"] = 57.22, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 130.09, ["Mega"] = 137.82, ["Mega|Ride"] = 245.31, ["Mega|Fly|Ride"] = 182.43}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 20.55, ["Fly"] = 85.32, ["Ride"] = 65.06, ["Fly|Ride"] = 131.25, ["Neon"] = 138.83, ["Neon|Ride"] = 174.3, ["Neon|Fly|Ride"] = 261.19, ["Mega"] = 578.86, ["Mega|Ride"] = 485.63, ["Mega|Fly|Ride"] = 707.44}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 13.13, ["Fly|Ride"] = 59.07, ["Neon"] = 2.1, ["Neon|Fly"] = 28.63, ["Neon|Ride"] = 16.17, ["Neon|Fly|Ride"] = 45.83, ["Mega"] = 19.69, ["Mega|Ride"] = 35.43, ["Mega|Fly|Ride"] = 80.07}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 58.55, ["Neon"] = 2.63, ["Neon|Ride"] = 43.37, ["Neon|Fly|Ride"] = 130.09, ["Mega"] = 19.69, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 159.42}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.1, ["Fly"] = 36.85, ["Ride"] = 19.69, ["Fly|Ride"] = 173.36, ["Neon"] = 14.89, ["Neon|Ride"] = 58.42, ["Neon|Fly|Ride"] = 122.5, ["Mega"] = 105, ["Mega|Ride"] = 287.56, ["Mega|Fly|Ride"] = 246.1}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 28.88, ["Ride"] = 65.06, ["Fly|Ride"] = 131.25, ["Neon"] = 132.56, ["Neon|Ride"] = 346.89, ["Neon|Fly|Ride"] = 420.13, ["Mega"] = 511.88, ["Mega|Ride"] = 578.86, ["Mega|Fly|Ride"] = 867.19}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 4.35, ["Fly"] = 21.7, ["Ride"] = 18.38, ["Fly|Ride"] = 36.86, ["Neon"] = 13.13, ["Neon|Fly"] = 27, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 68.25, ["Mega"] = 120.75, ["Mega|Fly"] = 267.22, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 8.08, ["Fly"] = 47.13, ["Ride"] = 44.63, ["Fly|Ride"] = 259.09, ["Neon"] = 57.04, ["Neon|Fly"] = 86.73, ["Neon|Ride"] = 55.04, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 303.53, ["Mega|Fly"] = 433.13, ["Mega|Ride"] = 262.48, ["Mega|Fly|Ride"] = 352.31}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Fly"] = 16.71, ["Ride"] = 24.94, ["Fly|Ride"] = 67.92, ["Neon"] = 11.94, ["Neon|Fly"] = 98.42, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 47.25, ["Mega|Fly"] = 220.4, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 144.04}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 11.24, ["Fly"] = 163.7, ["Ride"] = 24.93, ["Fly|Ride"] = 217.2, ["Neon"] = 37.69, ["Neon|Ride"] = 98.13, ["Neon|Fly|Ride"] = 289.44, ["Mega"] = 325.2, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 405.42, ["Mega|Fly|Ride"] = 433.6}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 5.25, ["Ride"] = 189.93, ["Fly|Ride"] = 142.41, ["Neon"] = 51.19, ["Neon|Ride"] = 145.27, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 223.12, ["Mega|Ride"] = 303.19, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 5.16, ["Fly"] = 37.79, ["Ride"] = 25.93, ["Fly|Ride"] = 51.98, ["Neon"] = 35.55, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 39.45, ["Neon|Fly|Ride"] = 145.3, ["Mega"] = 262.5, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 578.86}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 16.34, ["Ride"] = 15.65, ["Fly|Ride"] = 52.56, ["Neon"] = 13.02, ["Neon|Fly"] = 70.51, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 82.69, ["Mega"] = 189.71, ["Mega|Ride"] = 101.91, ["Mega|Fly|Ride"] = 215.73}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 196.77, ["Fly"] = 393.75, ["Ride"] = 273, ["Fly|Ride"] = 392.44, ["Neon"] = 1156.61, ["Neon|Ride"] = 1256.34, ["Neon|Fly|Ride"] = 1174.69, ["Mega"] = 4252.17, ["Mega|Fly|Ride"] = 4117.32}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 4.83, ["Ride"] = 105, ["Neon"] = 34.37, ["Neon|Ride"] = 45.94, ["Mega"] = 123.38, ["Mega|Ride"] = 654.94, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 6.14, ["Fly"] = 108.41, ["Ride"] = 24.94, ["Fly|Ride"] = 86.73, ["Neon"] = 31.2, ["Neon|Fly"] = 246.07, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 233.94, ["Mega|Ride"] = 196.87, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 3.81, ["Fly|Ride"] = 216.81, ["Neon"] = 43.04, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 603.74, ["Mega"] = 486.29, ["Mega|Ride"] = 409.65, ["Mega|Fly|Ride"] = 289.44}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 16.17, ["Ride"] = 14.44, ["Fly|Ride"] = 33.62, ["Neon"] = 2.1, ["Neon|Fly"] = 43.37, ["Neon|Ride"] = 15.1, ["Neon|Fly|Ride"] = 42.3, ["Mega"] = 26.25, ["Mega|Fly"] = 81.31, ["Mega|Ride"] = 36.87, ["Mega|Fly|Ride"] = 72.18}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.1, ["Fly"] = 44.88, ["Ride"] = 22.66, ["Fly|Ride"] = 57.66, ["Neon"] = 17.69, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 89.25, ["Mega"] = 132.57, ["Mega|Ride"] = 211.11, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.63, ["Ride"] = 119.85, ["Neon"] = 10.23, ["Neon|Ride"] = 288.35, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 52.5, ["Mega|Fly"] = 145.27, ["Mega|Ride"] = 167.99, ["Mega|Fly|Ride"] = 276.94}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 78.75, ["Fly"] = 104.99, ["Ride"] = 112.88, ["Fly|Ride"] = 153.02, ["Neon"] = 315, ["Neon|Fly"] = 654.94, ["Neon|Ride"] = 368.82, ["Neon|Fly|Ride"] = 471.54, ["Mega|Ride"] = 3615.06, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 5.16, ["Fly"] = 72.64, ["Ride"] = 28.88, ["Fly|Ride"] = 58.55, ["Neon"] = 22.07, ["Neon|Ride"] = 68.16, ["Mega"] = 169.3, ["Mega|Ride"] = 213.94}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 49.88, ["Ride"] = 34.13, ["Neon"] = 7.14, ["Neon|Ride"] = 177.05, ["Neon|Fly|Ride"] = 145.27, ["Mega"] = 55.78, ["Mega|Fly"] = 314.99, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 52.04, ["Fly"] = 91.88, ["Ride"] = 90.82, ["Fly|Ride"] = 178.4, ["Neon"] = 157.5, ["Neon|Ride"] = 178.49, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 538.13, ["Mega|Ride"] = 603.75, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 16.28, ["Fly|Ride"] = 32.54, ["Neon"] = 2.1, ["Neon|Fly"] = 22.19, ["Neon|Ride"] = 19.52, ["Neon|Fly|Ride"] = 34.13, ["Mega"] = 17.07, ["Mega|Fly"] = 48.38, ["Mega|Ride"] = 34.13, ["Mega|Fly|Ride"] = 63.03}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 59.63, ["Fly|Ride"] = 93.24, ["Neon"] = 5.25, ["Neon|Ride"] = 30.18, ["Neon|Fly|Ride"] = 114.11, ["Mega"] = 23.63, ["Mega|Fly"] = 145.27, ["Mega|Ride"] = 78.66, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 3.56, ["Ride"] = 107.63, ["Fly|Ride"] = 161.44, ["Neon"] = 6.5, ["Neon|Ride"] = 122.07, ["Neon|Fly|Ride"] = 288.65, ["Mega"] = 62.37, ["Mega|Fly"] = 188.62, ["Mega|Ride"] = 98.44}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 7.14, ["Fly"] = 86.66, ["Ride"] = 50.86, ["Fly|Ride"] = 157.01, ["Neon"] = 26.22, ["Neon|Fly"] = 179.08, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 159.69, ["Mega"] = 214.65, ["Mega|Fly"] = 336.45, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 18.8, ["Ride"] = 13.49, ["Fly|Ride"] = 45.54, ["Neon"] = 2.1, ["Neon|Fly"] = 24.86, ["Neon|Ride"] = 21.55, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 18.38, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 117.8}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 20.79, ["Fly"] = 131.25, ["Ride"] = 53.27, ["Neon"] = 129.75, ["Neon|Ride"] = 202.57, ["Neon|Fly|Ride"] = 374.07, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 801.06}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2547.35, ["Fly"] = 3150, ["Ride"] = 2224.69, ["Fly|Ride"] = 2215.5, ["Neon|Fly|Ride"] = 7415.63, ["Mega|Fly|Ride"] = 44984.83}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 45.92, ["Ride"] = 19.69, ["Fly|Ride"] = 53.89, ["Neon"] = 11.7, ["Neon|Fly"] = 58.46, ["Neon|Ride"] = 28.18, ["Neon|Fly|Ride"] = 63.66, ["Mega"] = 144.38, ["Mega|Fly"] = 433.6, ["Mega|Ride"] = 123.38, ["Mega|Fly|Ride"] = 150.72}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.1, ["Ride"] = 28.21, ["Neon"] = 8.82, ["Mega"] = 103.8, ["Mega|Fly|Ride"] = 490.61}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 13.13, ["Fly"] = 105, ["Ride"] = 33.62, ["Fly|Ride"] = 157.5, ["Neon"] = 84.57, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 227.39, ["Mega"] = 431.82, ["Mega|Ride"] = 405.42, ["Mega|Fly|Ride"] = 686.83}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 29.79, ["Fly"] = 108.41, ["Ride"] = 66.94, ["Fly|Ride"] = 51.52, ["Neon"] = 140.44, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 164.36, ["Mega"] = 541.99, ["Mega|Ride"] = 620.05, ["Mega|Fly|Ride"] = 327.48}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 143.07, ["Fly"] = 1446.04, ["Ride"] = 189, ["Fly|Ride"] = 242.82, ["Neon"] = 647.07, ["Neon|Ride"] = 758.96, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 6503.84, ["Mega|Fly|Ride"] = 4173.75}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 7.88, ["Ride"] = 65.54, ["Fly|Ride"] = 675.94, ["Neon"] = 26.25, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 144.45, ["Mega|Fly|Ride"] = 433.6}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 36.87, ["Neon"] = 15.18, ["Neon|Fly"] = 94.32, ["Neon|Ride"] = 114.85, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 179.82, ["Mega|Ride"] = 330.65, ["Mega|Fly|Ride"] = 267.09}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Fly"] = 101.9, ["Ride"] = 33.5, ["Fly|Ride"] = 72.64, ["Neon"] = 15.75, ["Neon|Fly"] = 127.92, ["Neon|Ride"] = 26.25, ["Mega"] = 61.69, ["Mega|Ride"] = 123.38, ["Mega|Fly|Ride"] = 229.69}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 14.43, ["Ride"] = 70.74, ["Fly|Ride"] = 131.25, ["Neon"] = 121.84, ["Neon|Ride"] = 179.08, ["Neon|Fly|Ride"] = 510.57, ["Mega"] = 420, ["Mega|Ride"] = 325.2, ["Mega|Fly|Ride"] = 591.29}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 29.28, ["Mega"] = 35.44, ["Mega|Fly"] = 122.67, ["Mega|Ride"] = 85.2, ["Mega|Fly|Ride"] = 135.19}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 95.19, ["Fly"] = 202.72, ["Ride"] = 106.24, ["Fly|Ride"] = 137.82, ["Neon"] = 304.5, ["Neon|Fly"] = 463.96, ["Neon|Ride"] = 407.38, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 3251.93, ["Mega|Fly|Ride"] = 1299.71}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Fly"] = 45.54, ["Ride"] = 91.85, ["Neon"] = 9.77, ["Neon|Ride"] = 144.65, ["Neon|Fly|Ride"] = 216.81, ["Mega"] = 62.37, ["Mega|Ride"] = 288.35, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 43.19, ["Fly"] = 105, ["Ride"] = 78.75, ["Fly|Ride"] = 169.32, ["Neon"] = 229.06, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 378, ["Mega"] = 2625, ["Mega|Ride"] = 2167.95}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 64.32, ["Ride"] = 21.46, ["Fly|Ride"] = 52.75, ["Neon"] = 3.98, ["Neon|Fly"] = 85.86, ["Neon|Ride"] = 72.64, ["Neon|Fly|Ride"] = 116, ["Mega"] = 61.69, ["Mega|Fly"] = 147.19, ["Mega|Ride"] = 103.69, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Neon"] = 21, ["Neon|Ride"] = 115.5, ["Mega"] = 143.1, ["Mega|Fly|Ride"] = 405.42}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 4.77, ["Fly"] = 77.43, ["Ride"] = 33.62, ["Fly|Ride"] = 90.57, ["Neon"] = 25.2, ["Neon|Ride"] = 72.47, ["Neon|Fly|Ride"] = 124.67, ["Mega"] = 157.5, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 541.99}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 371.43, ["Ride"] = 420, ["Fly|Ride"] = 787.5, ["Neon"] = 1181.25, ["Neon|Ride"] = 971.25, ["Neon|Fly|Ride"] = 1102.5, ["Mega"] = 3126.19, ["Mega|Ride"] = 3130.32, ["Mega|Fly|Ride"] = 4314.22}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 37.89, ["Fly"] = 86.73, ["Ride"] = 47.25, ["Fly|Ride"] = 107.34, ["Neon"] = 154.53, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 286.13, ["Mega|Ride"] = 1238.99, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 3.94, ["Fly"] = 61.62, ["Ride"] = 31.81, ["Fly|Ride"] = 122.22, ["Neon"] = 24.69, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 52.74, ["Neon|Fly|Ride"] = 131.06, ["Mega"] = 169.31, ["Mega|Ride"] = 262.48, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 27.29, ["Fly"] = 131.25, ["Ride"] = 63.13, ["Fly|Ride"] = 149.63, ["Neon"] = 78.94, ["Neon|Fly"] = 177.19, ["Neon|Ride"] = 145.69, ["Neon|Fly|Ride"] = 216.81, ["Mega"] = 348.16, ["Mega|Fly"] = 1009.39, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 509.25}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 5.91, ["Ride"] = 23.61, ["Neon"] = 101.36, ["Neon|Ride"] = 136.6, ["Neon|Fly|Ride"] = 490.61, ["Mega"] = 654.94, ["Mega|Ride"] = 682.5, ["Mega|Fly|Ride"] = 311.07}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.61, ["Neon"] = 23.61, ["Neon|Ride"] = 157.5, ["Mega"] = 102.38, ["Mega|Ride"] = 332.79}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.29, ["Fly"] = 72.64, ["Ride"] = 22.32, ["Fly|Ride"] = 62.97, ["Neon"] = 57.66, ["Neon|Fly"] = 94.32, ["Neon|Ride"] = 114.92, ["Neon|Fly|Ride"] = 212.14, ["Mega"] = 216.57, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 105, ["Fly"] = 245.32, ["Ride"] = 111.34, ["Fly|Ride"] = 196.88, ["Neon"] = 823.83, ["Neon|Ride"] = 523.68, ["Neon|Fly|Ride"] = 524.98, ["Mega"] = 2887.5, ["Mega|Ride"] = 2625, ["Mega|Fly|Ride"] = 3271}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 24.92, ["Ride"] = 55.56, ["Fly|Ride"] = 144.63, ["Neon"] = 157.38, ["Neon|Ride"] = 173.45, ["Mega"] = 1156.61, ["Mega|Ride"] = 867.19}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2034.37, ["Fly"] = 2311.32, ["Ride"] = 1968.75, ["Fly|Ride"] = 1890, ["Neon"] = 11562.74, ["Neon|Fly|Ride"] = 6502.76, ["Mega|Fly|Ride"] = 24675}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 4.76, ["Fly"] = 65625, ["Ride"] = 24.94, ["Fly|Ride"] = 196.87, ["Neon"] = 22.45, ["Neon|Ride"] = 65.63, ["Mega"] = 156.19, ["Mega|Fly"] = 786.19, ["Mega|Ride"] = 209.35, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 6.36, ["Ride"] = 58.55, ["Fly|Ride"] = 131.25, ["Neon"] = 24.84, ["Neon|Ride"] = 90.09, ["Neon|Fly|Ride"] = 231.98, ["Mega"] = 144.37, ["Mega|Fly"] = 289.44, ["Mega|Ride"] = 231.98, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 879.38, ["Fly"] = 1503.48, ["Ride"] = 954.19, ["Fly|Ride"] = 997.5, ["Neon"] = 3271, ["Neon|Ride"] = 3067.09, ["Neon|Fly|Ride"] = 2891.43, ["Mega|Ride"] = 13900.78, ["Mega|Fly|Ride"] = 14308.44}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 24.44, ["Ride"] = 52.5, ["Fly|Ride"] = 173.35, ["Neon"] = 238.88, ["Neon|Ride"] = 327.48, ["Mega"] = 857.2, ["Mega|Ride"] = 975.58, ["Mega|Fly|Ride"] = 835.42}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 3.35, ["Ride"] = 21.79, ["Fly|Ride"] = 118.13, ["Neon"] = 12.3, ["Neon|Ride"] = 64.84, ["Neon|Fly|Ride"] = 215.73, ["Mega"] = 157.5, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 145.27, ["Neon"] = 3.94, ["Neon|Fly"] = 126, ["Neon|Ride"] = 49.26, ["Neon|Fly|Ride"] = 112.75, ["Mega"] = 22.52, ["Mega|Ride"] = 61.31, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 91.84, ["Ride"] = 126.77, ["Fly|Ride"] = 170.63, ["Neon"] = 459.38, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 640.5, ["Mega"] = 2452.95, ["Mega|Fly|Ride"] = 2313.21}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 2.63, ["Ride"] = 34.7, ["Fly|Ride"] = 75.89, ["Neon"] = 11.71, ["Neon|Ride"] = 33.62, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 90.56, ["Mega|Ride"] = 121.96, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 78.75, ["Fly"] = 151.77, ["Ride"] = 102.1, ["Fly|Ride"] = 289.44, ["Neon"] = 433.6, ["Neon|Ride"] = 721.88, ["Mega"] = 1408.1, ["Mega|Fly|Ride"] = 1768.57}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 3.25, ["Fly"] = 105, ["Fly|Ride"] = 130.09, ["Neon"] = 59.07, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 269.06, ["Mega"] = 328.02, ["Mega|Ride"] = 145.27}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 262.5, ["Ride"] = 280.76, ["Fly|Ride"] = 321.57, ["Neon"] = 1137.32, ["Neon|Ride"] = 1083.98, ["Neon|Fly|Ride"] = 793.63, ["Mega|Fly|Ride"] = 3899.56}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 2.37, ["Fly"] = 56.11, ["Ride"] = 24.71, ["Fly|Ride"] = 115.9, ["Neon"] = 38.07, ["Neon|Ride"] = 64.87, ["Neon|Fly|Ride"] = 114.19, ["Mega|Ride"] = 262.48, ["Mega|Fly|Ride"] = 288.98}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 23.21, ["Ride"] = 16.66, ["Fly|Ride"] = 40.77, ["Neon"] = 5.86, ["Neon|Fly"] = 37.97, ["Neon|Ride"] = 26.16, ["Neon|Fly|Ride"] = 60.38, ["Mega"] = 48.56, ["Mega|Ride"] = 71.86, ["Mega|Fly|Ride"] = 126}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 1357.14, ["Ride"] = 1050, ["Fly|Ride"] = 1254.75, ["Neon|Ride"] = 7949.86, ["Neon|Fly|Ride"] = 7045.83, ["Mega"] = 24529.31}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 12.73, ["Ride"] = 72.19, ["Fly|Ride"] = 86.73, ["Neon"] = 98.13, ["Neon|Ride"] = 314.98, ["Mega"] = 315, ["Mega|Ride"] = 421.62, ["Mega|Fly|Ride"] = 564.27}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 6.36, ["Fly"] = 54.9, ["Ride"] = 43.32, ["Fly|Ride"] = 80.75, ["Neon"] = 24.93, ["Neon|Fly"] = 103, ["Neon|Ride"] = 55.54, ["Neon|Fly|Ride"] = 130.09, ["Mega"] = 181.13, ["Mega|Ride"] = 182.26, ["Mega|Fly|Ride"] = 285.27}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 33.78, ["Fly"] = 39.85, ["Ride"] = 40.65, ["Fly|Ride"] = 80.07, ["Neon"] = 196.25, ["Neon|Ride"] = 210.31, ["Neon|Fly|Ride"] = 190.97, ["Mega"] = 2601.55, ["Mega|Ride"] = 1145.53, ["Mega|Fly|Ride"] = 696.55}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 14.6, ["Fly"] = 71.55, ["Ride"] = 30.19, ["Fly|Ride"] = 99.73, ["Neon"] = 59.07, ["Neon|Ride"] = 88.23, ["Neon|Fly|Ride"] = 260.16, ["Mega"] = 367.5, ["Mega|Ride"] = 282.19, ["Mega|Fly|Ride"] = 431.71}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 68.86, ["Fly|Ride"] = 644.01, ["Neon"] = 249.38, ["Neon|Fly"] = 489.97, ["Neon|Ride"] = 433.6, ["Mega"] = 3902.31, ["Mega|Ride"] = 1080.74, ["Mega|Fly|Ride"] = 966}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 116.61, ["Neon"] = 2.63, ["Neon|Fly"] = 54.71, ["Neon|Ride"] = 111.84, ["Neon|Fly|Ride"] = 108.4, ["Mega"] = 17.07, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 203.44}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 99.75, ["Fly"] = 124.51, ["Ride"] = 124.04, ["Fly|Ride"] = 177.19, ["Neon"] = 573.02, ["Neon|Fly"] = 490.88, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 590.62, ["Mega"] = 2167.95, ["Mega|Fly|Ride"] = 1771.88}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.92, ["Fly"] = 107.63, ["Ride"] = 19.69, ["Fly|Ride"] = 66.68, ["Neon"] = 198.19, ["Neon|Ride"] = 100.58, ["Mega"] = 773.71, ["Mega|Ride"] = 441.54, ["Mega|Fly|Ride"] = 490.88}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 18.38, ["Fly|Ride"] = 39.34, ["Neon"] = 52.49, ["Neon|Fly"] = 82.19, ["Neon|Ride"] = 86.73, ["Neon|Fly|Ride"] = 122.85, ["Mega|Ride"] = 275.07, ["Mega|Fly|Ride"] = 269.07}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 2.1, ["Ride"] = 126, ["Neon"] = 19.52, ["Neon|Fly"] = 143.1, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 214.76}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 86.52, ["Fly"] = 247.55, ["Ride"] = 164.36, ["Fly|Ride"] = 414.09, ["Neon"] = 414.75, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 578.86, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 2205, ["Mega|Ride"] = 1680, ["Mega|Fly|Ride"] = 1680}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 8.18, ["Fly|Ride"] = 433.6, ["Neon"] = 20.3, ["Neon|Ride"] = 59.07, ["Mega"] = 115.31, ["Mega|Fly|Ride"] = 327.48}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 37.79, ["Neon"] = 2.1, ["Neon|Ride"] = 101.91, ["Mega"] = 16.7, ["Mega|Ride"] = 210.31, ["Mega|Fly|Ride"] = 541.99}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 102.94, ["Ride"] = 32.82, ["Fly|Ride"] = 144.44, ["Neon"] = 3.84, ["Neon|Fly"] = 86.2, ["Neon|Ride"] = 17.36, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 24.05, ["Mega|Fly"] = 55.63, ["Mega|Ride"] = 45.07, ["Mega|Fly|Ride"] = 160.43}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 36.74, ["Ride"] = 18.38, ["Fly|Ride"] = 52.47, ["Neon"] = 5.87, ["Neon|Ride"] = 29.28, ["Neon|Fly|Ride"] = 50.93, ["Mega"] = 63, ["Mega|Ride"] = 101.91, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 115.49, ["Neon"] = 24.36, ["Neon|Ride"] = 115.31, ["Mega"] = 118.12, ["Mega|Ride"] = 130.08, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 39.36, ["Ride"] = 19.52, ["Fly|Ride"] = 36.98, ["Neon"] = 16.16, ["Neon|Fly"] = 86.73, ["Neon|Ride"] = 38.04, ["Neon|Fly|Ride"] = 101.91, ["Mega"] = 183.75, ["Mega|Ride"] = 142.01, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 54.57, ["Ride"] = 110.25, ["Neon"] = 289.44, ["Neon|Ride"] = 392.44, ["Neon|Fly|Ride"] = 1083.98, ["Mega"] = 656.25, ["Mega|Ride"] = 708.75, ["Mega|Fly|Ride"] = 1145.53}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 17.07, ["Fly|Ride"] = 41.88, ["Neon"] = 2.1, ["Neon|Fly"] = 32.45, ["Neon|Ride"] = 20.61, ["Neon|Fly|Ride"] = 43.32, ["Mega"] = 19.69, ["Mega|Ride"] = 28.21, ["Mega|Fly|Ride"] = 100.84}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 8.29, ["Fly"] = 28.88, ["Ride"] = 32.6, ["Fly|Ride"] = 72.19, ["Neon"] = 54.22, ["Neon|Fly"] = 88.91, ["Neon|Ride"] = 65.55, ["Neon|Fly|Ride"] = 132.75, ["Mega"] = 301.87, ["Mega|Fly"] = 578.86, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 266.68}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 22.83, ["Fly"] = 29.28, ["Ride"] = 51.35, ["Fly|Ride"] = 111.57, ["Neon"] = 135.18, ["Neon|Fly"] = 173.45, ["Neon|Ride"] = 124.48, ["Neon|Fly|Ride"] = 203.43, ["Mega"] = 787.5, ["Mega|Ride"] = 867.19, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 7.8, ["Fly"] = 196.88, ["Fly|Ride"] = 67.22, ["Neon"] = 82.74, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 147.19, ["Mega"] = 537, ["Mega|Ride"] = 665.57, ["Mega|Fly|Ride"] = 266.67}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 18.42, ["Ride"] = 17.07, ["Fly|Ride"] = 34.13, ["Neon"] = 5.19, ["Neon|Fly"] = 28.11, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 69.56, ["Mega"] = 45.91, ["Mega|Ride"] = 61.69, ["Mega|Fly|Ride"] = 122.07}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 7.33, ["Fly"] = 52.49, ["Ride"] = 38.07, ["Neon"] = 74.78, ["Neon|Ride"] = 134.43, ["Neon|Fly|Ride"] = 1168.13, ["Mega"] = 321.57, ["Mega|Fly"] = 371.82, ["Mega|Ride"] = 527.9, ["Mega|Fly|Ride"] = 563.69}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 997.49, ["Fly"] = 1390.83, ["Ride"] = 1008, ["Fly|Ride"] = 1114.32, ["Neon"] = 2625, ["Neon|Fly"] = 2872.54, ["Neon|Ride"] = 2744.44, ["Neon|Fly|Ride"] = 2420.24, ["Mega|Fly|Ride"] = 7199.07}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 190.32, ["Ride"] = 262.5, ["Fly|Ride"] = 393.75, ["Neon"] = 840, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 1012.45, ["Mega"] = 3250.84, ["Mega|Ride"] = 3758.14, ["Mega|Fly|Ride"] = 3180.38}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 392.44, ["Neon"] = 8.38, ["Neon|Ride"] = 72.64, ["Neon|Fly|Ride"] = 259.09, ["Mega"] = 78.51, ["Mega|Fly|Ride"] = 215.73}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 127.22, ["Fly"] = 131.25, ["Ride"] = 196.66, ["Fly|Ride"] = 361.8, ["Neon"] = 578.86, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 792.62, ["Mega"] = 2384.75, ["Mega|Ride"] = 2564.63, ["Mega|Fly|Ride"] = 1916.25}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 2.1, ["Fly"] = 41.21, ["Ride"] = 21.9, ["Fly|Ride"] = 94.32, ["Neon"] = 14.12, ["Neon|Ride"] = 43.37, ["Neon|Fly|Ride"] = 289.44, ["Mega"] = 115.96, ["Mega|Ride"] = 490.61, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 223.12, ["Fly"] = 433.6, ["Ride"] = 290.07, ["Fly|Ride"] = 393.75, ["Neon|Ride"] = 1430.86, ["Neon|Fly|Ride"] = 1373.4, ["Mega|Fly|Ride"] = 4905.88}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 77.18, ["Ride"] = 42.3, ["Fly|Ride"] = 223.25, ["Neon"] = 23.86, ["Neon|Ride"] = 54.37, ["Mega"] = 393.74, ["Mega|Fly"] = 363.14, ["Mega|Ride"] = 157.5}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Fly"] = 29.28, ["Ride"] = 26.25, ["Neon"] = 41.07, ["Mega"] = 249.38, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 24.77, ["Ride"] = 67.44, ["Fly|Ride"] = 143.1, ["Neon"] = 123.59, ["Neon|Fly"] = 433.6, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 783.72, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 867.19}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 49.76, ["Fly|Ride"] = 45.94, ["Neon"] = 21.7, ["Neon|Ride"] = 196.88, ["Mega"] = 245.32, ["Mega|Ride"] = 257.19, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 16.08, ["Ride"] = 14.3, ["Fly|Ride"] = 39.26, ["Neon"] = 2.55, ["Neon|Fly"] = 20.79, ["Neon|Ride"] = 19.52, ["Neon|Fly|Ride"] = 44.56, ["Mega"] = 28.17, ["Mega|Ride"] = 38.89, ["Mega|Fly|Ride"] = 72.35}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 5405.78, ["Ride"] = 4461.19, ["Fly|Ride"] = 5152.88, ["Neon"] = 32519.16, ["Neon|Fly|Ride"] = 19511.5, ["Mega|Fly|Ride"] = 52500}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 10.4, ["Fly"] = 86.73, ["Ride"] = 41.91, ["Neon"] = 86.28, ["Neon|Fly"] = 385.91, ["Neon|Ride"] = 106.32, ["Neon|Fly|Ride"] = 164.36, ["Mega"] = 210, ["Mega|Fly"] = 346.89, ["Mega|Ride"] = 215.15, ["Mega|Fly|Ride"] = 419.51}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 24.7, ["Ride"] = 19.69, ["Fly|Ride"] = 47.23, ["Neon"] = 18, ["Neon|Fly"] = 45.93, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 131.25, ["Mega|Ride"] = 145.27, ["Mega|Fly|Ride"] = 214.65}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 399.11, ["Fly"] = 547.77, ["Ride"] = 446.25, ["Fly|Ride"] = 574.88, ["Neon"] = 2100, ["Neon|Ride"] = 1292.82, ["Neon|Fly|Ride"] = 1375.5, ["Mega|Fly|Ride"] = 4873.32}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 3.81, ["Ride"] = 49.07, ["Neon"] = 13.43, ["Neon|Ride"] = 291.38, ["Mega"] = 144.53, ["Mega|Fly|Ride"] = 693}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 3.42, ["Fly"] = 145.69, ["Ride"] = 131.25, ["Neon"] = 32.82, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 229.69, ["Mega"] = 409.65, ["Mega|Ride"] = 362.07}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 51.19, ["Ride"] = 19.45, ["Fly|Ride"] = 65.63, ["Neon"] = 7.13, ["Neon|Fly"] = 124.69, ["Neon|Ride"] = 36.82, ["Neon|Fly|Ride"] = 91.74, ["Mega"] = 48.51, ["Mega|Ride"] = 77.44, ["Mega|Fly|Ride"] = 275.62}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 656.24, ["Fly"] = 757.72, ["Ride"] = 722.4, ["Fly|Ride"] = 738.1, ["Neon|Ride"] = 2126.25, ["Neon|Fly|Ride"] = 2099.99, ["Mega|Fly|Ride"] = 8749.61}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 11.07, ["Ride"] = 76.37, ["Fly|Ride"] = 145.27, ["Neon"] = 36.9, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 215.73, ["Mega"] = 242.82, ["Mega|Fly"] = 433.6, ["Mega|Ride"] = 231.98, ["Mega|Fly|Ride"] = 388.07}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 4.16, ["Fly"] = 236.25, ["Ride"] = 38.07, ["Fly|Ride"] = 129.94, ["Neon"] = 55.79, ["Neon|Ride"] = 49.07, ["Neon|Fly|Ride"] = 150.94, ["Mega"] = 169.32, ["Mega|Fly"] = 818.07, ["Mega|Ride"] = 179.3, ["Mega|Fly|Ride"] = 271.01}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 3.94, ["Fly"] = 33.1, ["Ride"] = 20.61, ["Fly|Ride"] = 41.97, ["Neon"] = 29.28, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 35.65, ["Neon|Fly|Ride"] = 82.97, ["Mega"] = 165.38, ["Mega|Fly|Ride"] = 239.77}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 23.62, ["Fly"] = 39.38, ["Ride"] = 33.62, ["Fly|Ride"] = 65.63, ["Neon"] = 117.59, ["Neon|Ride"] = 114.18, ["Mega"] = 867.19, ["Mega|Ride"] = 622.13, ["Mega|Fly|Ride"] = 866.12}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 43.31, ["Fly|Ride"] = 82.19, ["Neon"] = 3.57, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 30.45, ["Mega|Ride"] = 91.87, ["Mega|Fly|Ride"] = 339.94}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 573.57, ["Fly"] = 714.35, ["Ride"] = 630.19, ["Fly|Ride"] = 630, ["Neon"] = 2589.57, ["Neon|Ride"] = 2313.21, ["Neon|Fly|Ride"] = 2391.38, ["Mega|Ride"] = 9566.44, ["Mega|Fly|Ride"] = 7861.88}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.63, ["Ride"] = 101.91, ["Fly|Ride"] = 262.5, ["Neon"] = 13.01, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 224.44, ["Mega"] = 66.94, ["Mega|Ride"] = 145.27, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 49.06, ["Neon"] = 5.12, ["Neon|Fly"] = 246.07, ["Neon|Ride"] = 220.78, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 52.5, ["Mega|Fly|Ride"] = 289.44}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 60.45, ["Neon"] = 3.81, ["Neon|Ride"] = 56.17, ["Neon|Fly|Ride"] = 145.27, ["Mega"] = 61.07, ["Mega|Fly"] = 160.43, ["Mega|Ride"] = 126.95, ["Mega|Fly|Ride"] = 188.62}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 14.44, ["Neon|Ride"] = 48.98, ["Mega"] = 237.4, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 25.99, ["Fly"] = 72.19, ["Ride"] = 57.66, ["Fly|Ride"] = 144.38, ["Neon"] = 103.92, ["Neon|Fly"] = 278.42, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 393.74, ["Mega"] = 501.64, ["Mega|Ride"] = 523.18, ["Mega|Fly|Ride"] = 562}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 13.01, ["Ride"] = 56.22, ["Fly|Ride"] = 155.99, ["Neon"] = 85.89, ["Neon|Ride"] = 126, ["Neon|Fly|Ride"] = 283.5, ["Mega"] = 540.92, ["Mega|Ride"] = 445.59, ["Mega|Fly|Ride"] = 575.73}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 6.56, ["Fly"] = 22.32, ["Ride"] = 17.07, ["Fly|Ride"] = 35.44, ["Neon"] = 31.5, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 86.61, ["Mega"] = 301.88, ["Mega|Ride"] = 289.44, ["Mega|Fly|Ride"] = 239.56}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 14.44, ["Ride"] = 78.73, ["Fly|Ride"] = 144.74, ["Neon"] = 38.06, ["Neon|Ride"] = 91.88, ["Mega|Ride"] = 563.69}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Ride"] = 24.94, ["Fly|Ride"] = 109.5, ["Neon"] = 11.24, ["Neon|Ride"] = 52.04, ["Neon|Fly|Ride"] = 145.27, ["Mega"] = 82.57, ["Mega|Ride"] = 115.5, ["Mega|Fly|Ride"] = 303.53}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 23.55, ["Fly"] = 115.31, ["Ride"] = 23.7, ["Fly|Ride"] = 53.82, ["Neon"] = 110.25, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 212.47, ["Mega"] = 753.38, ["Mega|Fly|Ride"] = 757.32}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 33.43, ["Fly"] = 874.13, ["Neon"] = 133.88, ["Mega"] = 332.07, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 578.86}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 51.19, ["Fly"] = 86.63, ["Ride"] = 70.55, ["Fly|Ride"] = 145.27, ["Neon"] = 262.49, ["Neon|Ride"] = 304.27, ["Neon|Fly|Ride"] = 433.6, ["Mega"] = 1961.13, ["Mega|Fly|Ride"] = 1299.38}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 32.21, ["Fly"] = 145.27, ["Ride"] = 63, ["Fly|Ride"] = 223.13, ["Neon"] = 128.54, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 309.75, ["Mega"] = 745.79, ["Mega|Ride"] = 2026.5, ["Mega|Fly|Ride"] = 925.32}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 18.93, ["Ride"] = 36.87, ["Neon"] = 139.13, ["Neon|Ride"] = 223.12, ["Mega"] = 1050, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 819.51}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 26.76, ["Fly"] = 81.81, ["Ride"] = 91.88, ["Fly|Ride"] = 189, ["Neon"] = 145.27, ["Neon|Fly"] = 420, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 468.18, ["Mega"] = 684.47, ["Mega|Ride"] = 669.38, ["Mega|Fly|Ride"] = 681.08}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 18.14, ["Ride"] = 15.74, ["Fly|Ride"] = 32.8, ["Neon"] = 3.94, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 58.15, ["Mega"] = 49.85, ["Mega|Fly"] = 327.48, ["Mega|Ride"] = 55.17, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 922.48}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 95.13, ["Ride"] = 191.62, ["Fly|Ride"] = 356.99, ["Neon"] = 433.34, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 613.25, ["Mega"] = 1443.75, ["Mega|Ride"] = 1619.47, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 80.57, ["Neon"] = 3.5, ["Neon|Fly"] = 101.91, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 303.3, ["Mega"] = 26.25, ["Mega|Ride"] = 86.73, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 26.24, ["Ride"] = 67.2, ["Fly|Ride"] = 216.81, ["Neon"] = 118.13, ["Neon|Ride"] = 131.15, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 591.93, ["Mega|Ride"] = 511.88, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly|Ride"] = 116, ["Mega"] = 24.94}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Ride"] = 74.82, ["Neon"] = 5.24, ["Mega"] = 22.32, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 86.51, ["Fly"] = 1312.5, ["Ride"] = 141.75, ["Fly|Ride"] = 223.13, ["Neon"] = 693.75, ["Neon|Ride"] = 459.37, ["Neon|Fly|Ride"] = 636.3, ["Mega|Ride"] = 6745.57, ["Mega|Fly|Ride"] = 1979.83}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 90.57, ["Ride"] = 21.69, ["Fly|Ride"] = 100.96, ["Neon"] = 7.29, ["Neon|Fly"] = 29.28, ["Neon|Ride"] = 32.29, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 91.86, ["Mega|Ride"] = 118.12, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Fly|Ride"] = 61.69, ["Neon"] = 4.62, ["Neon|Fly"] = 43.37, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 419.9, ["Mega"] = 32.81, ["Mega|Ride"] = 129.15, ["Mega|Fly|Ride"] = 217.87}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 13.75, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 230.79, ["Mega"] = 124.69, ["Mega|Fly|Ride"] = 578.86}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Neon"] = 11.46, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 62.34, ["Mega"] = 103.69}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 98.33, ["Ride"] = 327.48, ["Fly|Ride"] = 362.07, ["Neon"] = 413.44, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 695.63, ["Mega|Ride"] = 2167.95, ["Mega|Fly|Ride"] = 2587.46}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 10.02, ["Neon"] = 90.01, ["Mega"] = 418.06, ["Mega|Ride"] = 366.19, ["Mega|Fly|Ride"] = 645.74}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 367.48, ["Ride"] = 427.32, ["Fly|Ride"] = 719.78, ["Neon"] = 1069.69, ["Neon|Ride"] = 1050, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 3346.87}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 103.68}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 54.57}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 17.07}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 32.54}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 50.59}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 116.78}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 15.25}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 7.86}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 190.3}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 18.38}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 40.73}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 24.93}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 11.84}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 944.99}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 15.75}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 7.25}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 13.01}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 8.69}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 19.68}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 735}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 462}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 86.63}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1488.14}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.63}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 52.4}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 5.92}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 43.32}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.63}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 30.61}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 164.36}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 57.66}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 19.14}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 11.81}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 23.78}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 6.32}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 26.17}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 3.94}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 4.23}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 196.87}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 99.75}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 6.06}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 3045}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 81.54}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 247.23}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 3.85}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 18.38}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 15.74}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 30.55}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 213.92}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 14.44}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 10.1}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 131.25}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 43.32}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 9.19}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 30.55}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 16.28}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 3.89}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 105}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 30.18}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 12.98}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 24.94}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 36.85}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 2.52}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 28.88}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.52}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 93.19}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 256.98}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 6.53}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 9.18}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 316.32}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 24.86}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 78.74}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 20.57}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 24406.67}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 124.69}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 42}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 39.73}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 27.56}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 57.66}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 24.66}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 35.44}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 91.14}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 86.63}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 29.63}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 103.69}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 431.78}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 44.42}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 7262.62}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 234.78}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 25.73}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 9.17}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 6.57}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 24.93}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 142.93}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.3}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 2.51}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.15}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 6.3}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 19.69}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 195.57}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 830.75}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 9.19}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 616.75}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 8.69}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.1}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 231}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 28.86}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 99.64}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 19.68}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 31.47}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 64.71}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 12.91}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 2.1}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 8.91}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.1}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 3.93}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 9.07}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 32.81}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 3.21}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 3.87}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 6.44}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 18.61}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 163.87}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 52.08}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.1}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 165.51}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 14.44}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 24.93}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 11.82}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 23.63}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 19.09}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 4.09}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 7.87}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 7.51}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 6.44}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 39.38}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 86.63}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 6.36}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 3.69}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 5.04}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 18.41}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 6.57}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 6.11}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 5.88}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 2.37}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 9648.61}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.28}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 19.69}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 4.6}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 4.13}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 4.08}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 33.13}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 4.35}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 2.12}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 5.25}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 3.57}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 9.19}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 40.21}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 6.17}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 3.9}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 4.32}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 3.84}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 3.08}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 3937.5}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 8.96}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 85.22}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 2.68}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 72.35}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.52}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 9.18}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 118.46}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 8.69}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 5.24}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 3.84}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 4.5}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 143.81}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 61.69}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.4}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 11.69}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 6.57}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.76}},
    ["rbxassetid://3009779565"] = {name = "Rainbow Rattle", prices = {["default"] = 289059.45}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 3.28}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 3.94}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 14}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.52}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 5.97}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 11.82}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 104.7}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 89.25}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 11.78}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1260.29}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 66.94}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.63}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 22.99}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 34.04}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 5.76}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.63}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 10.5}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 327057.76}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 38.19}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 12.87}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 14.28}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.63}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 3.29}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 3.92}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 11.79}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 3.21}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 29.28}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 3.84}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 6.7}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 63.03}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 13.12}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 314.9}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 91.88}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 12.71}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 3.94}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 4.27}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 83.99}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 22.19}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.63}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 5.01}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 19.69}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 5.74}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 124.69}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.52}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 4.77}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 180.35}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 11.23}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1013.25}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.63}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 192.83}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 5.36}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 9.19}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 57.75}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 6.57}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 3.89}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 81.38}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 18.15}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 45.99}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 3.89}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 8.78}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 2.24}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 99.69}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 25.73}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 91.88}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 15.75}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 3.62}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 15.75}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 114.19}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 2.21}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 86.1}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 3.67}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 4.82}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 78.75}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.63}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 53.82}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 189.53}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 3.67}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 143.07}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 14.84}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 4.5}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 314.9}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 57.75}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 8.48}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 28.88}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 5.16}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 10.5}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 13.01}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 30.86}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 6.09}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 13.13}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 44.89}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 7.88}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 6.5}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 30.19}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 3.28}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 27.44}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 145.27}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 56.42}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 24.94}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1994.99}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 16.27}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 8.23}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 24.85}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 376.16}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 17.07}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 8.8}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 17.57}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 5.21}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 11.8}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 318.94}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 64.32}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 130.08}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 3.9}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 45.94}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 156.19}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 82.69}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 965.63}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 181.13}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 6.57}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 1727.25}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 570.41}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 3.62}},
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