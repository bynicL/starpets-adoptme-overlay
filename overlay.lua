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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 1223.25, ["Ride"] = 1179.91, ["Fly|Ride"] = 1690.5, ["Neon"] = 6869.03, ["Neon|Ride"] = 9187.5, ["Neon|Fly|Ride"] = 5070.82, ["Mega"] = 21682, ["Mega|Fly|Ride"] = 21682}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 536.26, ["Ride"] = 459.38, ["Fly|Ride"] = 551.25, ["Neon|Fly|Ride"] = 1837.5, ["Mega"] = 10841, ["Mega|Fly|Ride"] = 8124.26}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 6562.5, ["Ride"] = 5250, ["Fly|Ride"] = 5118.75, ["Neon|Fly|Ride"] = 17850, ["Mega|Fly|Ride"] = 71695.85}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 208.15, ["Fly"] = 229.69, ["Ride"] = 275.38, ["Fly|Ride"] = 490.67, ["Neon"] = 1145.67, ["Neon|Ride"] = 1156.75, ["Neon|Fly|Ride"] = 885.94, ["Mega|Fly|Ride"] = 4900.14}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 632.62, ["Fly"] = 867.29, ["Ride"] = 525, ["Fly|Ride"] = 607.69, ["Neon|Fly|Ride"] = 1922.7, ["Mega|Fly|Ride"] = 6431.25}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 13.02, ["Ride"] = 52.5, ["Fly|Ride"] = 129.94, ["Neon"] = 80.67, ["Neon|Fly"] = 289.47, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 325.25, ["Mega"] = 353.75, ["Mega|Ride"] = 520.38, ["Mega|Fly|Ride"] = 606.03}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 4.93, ["Fly"] = 58.56, ["Ride"] = 32.37, ["Fly|Ride"] = 73.5, ["Neon"] = 50.96, ["Neon|Fly"] = 132.57, ["Neon|Ride"] = 60.31, ["Neon|Fly|Ride"] = 112.76, ["Mega"] = 179.82, ["Mega|Ride"] = 216.56, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 118.13, ["Ride"] = 141.75, ["Neon"] = 525, ["Neon|Ride"] = 492.19, ["Neon|Fly|Ride"] = 1181.25, ["Mega"] = 1586.82, ["Mega|Ride"] = 2492.44}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 33.24, ["Fly"] = 30.19, ["Ride"] = 49.08, ["Fly|Ride"] = 103.49, ["Neon"] = 245.02, ["Neon|Ride"] = 242.82, ["Neon|Fly|Ride"] = 312.38, ["Mega"] = 2100, ["Mega|Ride"] = 1214.21, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 18.37, ["Fly"] = 72.19, ["Ride"] = 32.03, ["Fly|Ride"] = 76.13, ["Neon"] = 151.27, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 650.48, ["Mega|Fly|Ride"] = 1127.47}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 80.07, ["Fly"] = 216.57, ["Ride"] = 105, ["Fly|Ride"] = 195.57, ["Neon"] = 261.19, ["Neon|Ride"] = 321.57, ["Neon|Fly|Ride"] = 414.37, ["Mega|Fly|Ride"] = 1390.99}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 64.31}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 347.71, ["Fly"] = 398.9, ["Ride"] = 334.69, ["Fly|Ride"] = 366.19, ["Neon|Fly|Ride"] = 1181.25}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 131.25, ["Fly"] = 171.3, ["Ride"] = 126.74, ["Fly|Ride"] = 170.17, ["Neon|Fly"] = 686.93, ["Neon|Ride"] = 573.03, ["Neon|Fly|Ride"] = 536.82, ["Mega"] = 4312.63, ["Mega|Fly|Ride"] = 2467.5}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 3.74, ["Fly"] = 79.03, ["Ride"] = 65.06, ["Fly|Ride"] = 131.25, ["Neon"] = 22.89, ["Neon|Ride"] = 57.75, ["Neon|Fly|Ride"] = 202.74, ["Mega"] = 160.13, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 222.92, ["Fly"] = 287.04, ["Ride"] = 233.63, ["Fly|Ride"] = 272.56, ["Neon|Ride"] = 975.71, ["Neon|Fly|Ride"] = 734.88, ["Mega|Fly|Ride"] = 2749.69}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.59, ["Fly"] = 27.16, ["Ride"] = 23.63, ["Fly|Ride"] = 39.9, ["Neon"] = 23.63, ["Neon|Fly"] = 82.21, ["Neon|Ride"] = 58.26, ["Neon|Fly|Ride"] = 76.4, ["Mega"] = 164.07, ["Mega|Ride"] = 258.57, ["Mega|Fly|Ride"] = 381.42}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 148.31, ["Fly"] = 289.47, ["Ride"] = 160.12, ["Fly|Ride"] = 288.75, ["Neon"] = 467.27, ["Neon|Ride"] = 362.11, ["Neon|Fly|Ride"] = 570.94, ["Mega"] = 1590.39, ["Mega|Ride"] = 1575, ["Mega|Fly|Ride"] = 1673.44}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 40.25}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 59.07, ["Ride"] = 131.25, ["Fly|Ride"] = 244.36, ["Neon"] = 419.56, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 2168.21, ["Mega|Fly|Ride"] = 1545.94}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 28.77, ["Fly"] = 58.56, ["Ride"] = 54.24, ["Fly|Ride"] = 433.65, ["Neon"] = 262.5, ["Neon|Ride"] = 319.82, ["Neon|Fly|Ride"] = 346.92, ["Mega"] = 787.5, ["Mega|Ride"] = 1055.94, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 36.39, ["Fly"] = 110.59, ["Ride"] = 58.36, ["Fly|Ride"] = 98.33, ["Neon"] = 216.56, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 268.41, ["Mega"] = 1717.27, ["Mega|Fly|Ride"] = 1120.75}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 39.38, ["Fly"] = 247.11, ["Ride"] = 85.32, ["Fly|Ride"] = 196.88, ["Neon"] = 160.47, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1967.44, ["Mega|Ride"] = 1734.57, ["Mega|Fly|Ride"] = 1560.04}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 35.43, ["Ride"] = 46.1, ["Fly|Ride"] = 110.5, ["Neon"] = 210, ["Neon|Ride"] = 216.84, ["Neon|Fly|Ride"] = 260.21, ["Mega"] = 1207.92, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 44.62, ["Fly"] = 58.56, ["Ride"] = 72.19, ["Fly|Ride"] = 129.94, ["Neon"] = 236.25, ["Neon|Fly"] = 409.7, ["Neon|Ride"] = 226.93, ["Neon|Fly|Ride"] = 322.88, ["Mega|Ride"] = 1145.67, ["Mega|Fly|Ride"] = 1039.5}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 6.21, ["Fly"] = 33.87, ["Ride"] = 28.87, ["Fly|Ride"] = 61.69, ["Neon"] = 45.94, ["Neon|Fly"] = 273.2, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 101.03, ["Mega"] = 156.19, ["Mega|Fly"] = 818.16, ["Mega|Ride"] = 225.74, ["Mega|Fly|Ride"] = 345.35}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 391, ["Ride"] = 415.68, ["Fly|Ride"] = 471.19, ["Neon|Ride"] = 1706.25, ["Neon|Fly|Ride"] = 1966.13, ["Mega"] = 10841, ["Mega|Fly|Ride"] = 9731.94}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 16.28, ["Ride"] = 32.82, ["Fly|Ride"] = 65.63, ["Neon"] = 219.18, ["Mega|Ride"] = 823.94, ["Mega|Fly|Ride"] = 671.66}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 6.45, ["Fly"] = 43.32, ["Ride"] = 23.63, ["Fly|Ride"] = 65.54, ["Neon"] = 63, ["Neon|Ride"] = 74.07, ["Neon|Fly|Ride"] = 104.97, ["Mega|Ride"] = 446.25, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 84.92, ["Fly"] = 120.16, ["Ride"] = 84, ["Fly|Ride"] = 145.69, ["Neon"] = 263.7, ["Neon|Fly"] = 392.54, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 400.59, ["Mega"] = 6499.83, ["Mega|Ride"] = 5832.75, ["Mega|Fly|Ride"] = 2100}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 16.28, ["Fly"] = 26.25, ["Ride"] = 27.57, ["Fly|Ride"] = 72.45, ["Neon"] = 77.21, ["Neon|Ride"] = 115.08, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 720.57, ["Mega|Ride"] = 709.02, ["Mega|Fly|Ride"] = 540.99}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 221.82, ["Fly"] = 288.75, ["Ride"] = 242.82, ["Fly|Ride"] = 331.44, ["Neon"] = 728.63, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 743.7, ["Mega"] = 3468.05, ["Mega|Ride"] = 2763.52, ["Mega|Fly|Ride"] = 3002.96}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 23.34}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.44, ["Fly"] = 37.96, ["Ride"] = 24.94, ["Fly|Ride"] = 67.17, ["Neon"] = 22.32, ["Neon|Fly"] = 145.28, ["Neon|Ride"] = 44.62, ["Neon|Fly|Ride"] = 124.69, ["Mega"] = 196.88, ["Mega|Fly"] = 488.5, ["Mega|Ride"] = 433.65, ["Mega|Fly|Ride"] = 288.74}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 786.19, ["Fly"] = 2625, ["Ride"] = 867.29, ["Fly|Ride"] = 905.63, ["Neon"] = 6504.61, ["Neon|Ride"] = 5493.14, ["Neon|Fly|Ride"] = 5059.5, ["Mega|Ride"] = 55197.45, ["Mega|Fly|Ride"] = 18791.8}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 12.23, ["Fly"] = 55.4, ["Ride"] = 51.94, ["Fly|Ride"] = 106.25, ["Neon"] = 188.65, ["Neon|Ride"] = 205.99, ["Neon|Fly|Ride"] = 212.49, ["Mega"] = 1036.88, ["Mega|Ride"] = 1113.38, ["Mega|Fly|Ride"] = 1012.56}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 232.5, ["Fly"] = 368, ["Ride"] = 236.22, ["Fly|Ride"] = 357, ["Neon"] = 885.93, ["Neon|Ride"] = 892.5, ["Neon|Fly|Ride"] = 1030.31, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 3899.56}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 44.57}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 13.02, ["Fly"] = 130.11, ["Ride"] = 72.59, ["Fly|Ride"] = 145.28, ["Neon"] = 65.62, ["Neon|Ride"] = 128.62, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 409.7, ["Mega|Ride"] = 576.13, ["Mega|Fly|Ride"] = 607.19}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.63}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 99.64, ["Fly"] = 162.24, ["Ride"] = 118.13, ["Fly|Ride"] = 219.19, ["Neon"] = 649.39, ["Neon|Ride"] = 402.94, ["Neon|Fly|Ride"] = 582.75, ["Mega"] = 2383.96, ["Mega|Ride"] = 2291.33, ["Mega|Fly|Ride"] = 1808.62}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 104.99, ["Fly"] = 157.49, ["Ride"] = 156.13, ["Fly|Ride"] = 223.13, ["Neon"] = 362.11, ["Neon|Fly"] = 578.92, ["Neon|Ride"] = 426.27, ["Neon|Fly|Ride"] = 496.12, ["Mega"] = 1626.16, ["Mega|Ride"] = 1466.07, ["Mega|Fly|Ride"] = 1492.62}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 35.44}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 52.49, ["Fly"] = 86.63, ["Ride"] = 61.57, ["Fly|Ride"] = 78.75, ["Neon|Ride"] = 397.88, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 4336.41, ["Mega|Fly|Ride"] = 1378.13}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 7.87, ["Fly"] = 101.92, ["Ride"] = 56.44, ["Fly|Ride"] = 157.5, ["Neon"] = 36.87, ["Neon|Fly"] = 223.13, ["Neon|Ride"] = 93.19, ["Neon|Fly|Ride"] = 145.28, ["Mega"] = 190.32, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 229.39, ["Mega|Fly|Ride"] = 458.76}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 597.72, ["Fly"] = 723.11, ["Ride"] = 525, ["Fly|Ride"] = 623.44, ["Neon|Fly"] = 3902.77, ["Neon|Ride"] = 2075.07, ["Neon|Fly|Ride"] = 1937, ["Mega|Ride"] = 15177.41, ["Mega|Fly|Ride"] = 7481.25}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 126, ["Fly"] = 164.8, ["Ride"] = 131.25, ["Fly|Ride"] = 220.8, ["Neon"] = 498.75, ["Neon|Ride"] = 563.74, ["Neon|Fly|Ride"] = 774.38, ["Mega|Ride"] = 2601.86}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 4068.75, ["Ride"] = 3885, ["Fly|Ride"] = 3937.5}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 51.19, ["Fly"] = 131.25, ["Ride"] = 98.43, ["Fly|Ride"] = 188.65, ["Neon"] = 329.3, ["Neon|Ride"] = 289.36, ["Neon|Fly|Ride"] = 505.32, ["Mega"] = 2168.21, ["Mega|Ride"] = 2027.28, ["Mega|Fly|Ride"] = 1895.25}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 65.63, ["Ride"] = 68.25, ["Fly|Ride"] = 145.28, ["Neon"] = 575.75, ["Neon|Ride"] = 427.88, ["Neon|Fly|Ride"] = 431.82, ["Mega"] = 6360.43, ["Mega|Ride"] = 2388.75, ["Mega|Fly|Ride"] = 2211.58}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 28.88, ["Fly"] = 44.63, ["Ride"] = 46.64, ["Fly|Ride"] = 102.38, ["Neon"] = 152.24, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 145.28, ["Neon|Fly|Ride"] = 202.13, ["Mega"] = 2625, ["Mega|Ride"] = 905.24, ["Mega|Fly|Ride"] = 577.48}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 4.31}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 47.71, ["Fly"] = 393.75, ["Ride"] = 53.82, ["Fly|Ride"] = 98.15, ["Neon|Ride"] = 289.47, ["Neon|Fly|Ride"] = 607.11, ["Mega|Ride"] = 1308.81, ["Mega|Fly|Ride"] = 981.31}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 34.72}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 212.62, ["Ride"] = 210, ["Fly|Ride"] = 282.19, ["Neon"] = 1156.75, ["Neon|Ride"] = 1156.75, ["Neon|Fly|Ride"] = 1298.77, ["Mega|Fly|Ride"] = 4906.46}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 715.21, ["Ride"] = 641.82, ["Fly|Ride"] = 804.21, ["Neon"] = 2625, ["Neon|Fly|Ride"] = 4336.41, ["Mega|Fly|Ride"] = 11265.36}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 7.39}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 34.02, ["Fly"] = 56.37, ["Ride"] = 39.38, ["Fly|Ride"] = 64.29, ["Neon"] = 246.75, ["Neon|Fly"] = 273.2, ["Neon|Ride"] = 156.19, ["Neon|Fly|Ride"] = 209.48, ["Mega"] = 2168.21, ["Mega|Ride"] = 1177.56, ["Mega|Fly|Ride"] = 719.25}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 23.61}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5250, ["Ride"] = 7950.8, ["Fly|Ride"] = 5055.75, ["Neon|Ride"] = 17991.93, ["Neon|Fly|Ride"] = 10827.6}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 15.62, ["Fly"] = 58.56, ["Ride"] = 22.32, ["Fly|Ride"] = 57.84, ["Neon"] = 87.94, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 561.75, ["Mega|Ride"] = 490.88, ["Mega|Fly|Ride"] = 518.44}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 10.49, ["Fly"] = 142.04, ["Ride"] = 37.96, ["Fly|Ride"] = 121.45, ["Neon"] = 91.88, ["Neon|Ride"] = 127.95, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 757.8, ["Mega|Ride"] = 346.92, ["Mega|Fly|Ride"] = 1156.75}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 76.13, ["Ride"] = 82.69, ["Fly|Ride"] = 85.31, ["Neon|Ride"] = 405.46, ["Neon|Fly|Ride"] = 485.82, ["Mega"] = 4336.41, ["Mega|Fly|Ride"] = 1799.45}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 9.75, ["Fly"] = 72.65, ["Ride"] = 36.72, ["Fly|Ride"] = 78.75, ["Neon"] = 91.88, ["Neon|Ride"] = 148.32, ["Neon|Fly|Ride"] = 315, ["Mega"] = 532.88, ["Mega|Ride"] = 769.1, ["Mega|Fly|Ride"] = 800.63}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1783.69, ["Fly"] = 2400.22, ["Ride"] = 1852.2, ["Fly|Ride"] = 1649.82, ["Neon|Fly|Ride"] = 2756.25, ["Mega|Fly|Ride"] = 12468.75}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 27562.5, ["Fly"] = 34691.2, ["Ride"] = 33970.27, ["Fly|Ride"] = 24937.5, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 63000, ["Mega|Fly|Ride"] = 183748.69}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 15.75, ["Fly"] = 393.75, ["Ride"] = 55.01, ["Fly|Ride"] = 130.11, ["Neon"] = 214.78, ["Neon|Ride"] = 198.26, ["Neon|Fly|Ride"] = 582.75, ["Mega"] = 1050, ["Mega|Ride"] = 1305.94, ["Mega|Fly|Ride"] = 578.92}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 3.94, ["Fly"] = 123.06, ["Ride"] = 52.5, ["Fly|Ride"] = 131.25, ["Neon"] = 26.25, ["Neon|Fly"] = 145.15, ["Neon|Ride"] = 72.08, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 196.88, ["Mega|Fly"] = 327.52, ["Mega|Ride"] = 233.63, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 22.88}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 7.58, ["Ride"] = 49.88, ["Fly|Ride"] = 131.25, ["Neon"] = 56.43, ["Neon|Ride"] = 116.02, ["Neon|Fly|Ride"] = 277.1, ["Mega"] = 405.46, ["Mega|Ride"] = 404.25, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 803.44, ["Ride"] = 718.54, ["Fly|Ride"] = 738.86, ["Neon"] = 3108.25, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 11449.18}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 918.75, ["Fly"] = 1076.15, ["Ride"] = 871.5, ["Fly|Ride"] = 981.31, ["Neon"] = 3615.48, ["Neon|Ride"] = 3271.38, ["Neon|Fly|Ride"] = 2756.25, ["Mega|Fly|Ride"] = 11612.33}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 12.9, ["Fly"] = 122.68, ["Ride"] = 32.48, ["Fly|Ride"] = 77.18, ["Neon"] = 78.75, ["Neon|Ride"] = 78.73, ["Neon|Fly|Ride"] = 145.17, ["Mega"] = 496.53, ["Mega|Ride"] = 481.9, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 24.69}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 70.88, ["Fly"] = 91.01, ["Ride"] = 86.75, ["Fly|Ride"] = 131.15, ["Neon"] = 578.92, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 389.82, ["Mega"] = 19687.5, ["Mega|Ride"] = 2025.11, ["Mega|Fly|Ride"] = 2370.94}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 94.75, ["Ride"] = 122.07, ["Fly|Ride"] = 216.84, ["Neon"] = 450.19, ["Neon|Ride"] = 423.81, ["Neon|Fly|Ride"] = 553.77, ["Mega"] = 1410.85, ["Mega|Ride"] = 1951.39, ["Mega|Fly|Ride"] = 2149.79}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 5.24, ["Fly"] = 32.42, ["Ride"] = 23.63, ["Fly|Ride"] = 51.19, ["Neon"] = 44.17, ["Neon|Fly"] = 524.99, ["Neon|Ride"] = 99.74, ["Neon|Fly|Ride"] = 110.92, ["Mega|Fly|Ride"] = 578.92}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 158.82, ["Fly"] = 192.94, ["Ride"] = 180.62, ["Fly|Ride"] = 254.66, ["Neon"] = 866.21, ["Neon|Ride"] = 648.37, ["Neon|Fly|Ride"] = 551.25, ["Mega"] = 5203.7, ["Mega|Fly|Ride"] = 2622.38}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 6.51, ["Ride"] = 45.94, ["Fly|Ride"] = 141.75, ["Neon"] = 39.38, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 424.7, ["Mega"] = 249.38, ["Mega|Fly"] = 1137.94, ["Mega|Ride"] = 342.01, ["Mega|Fly|Ride"] = 654.93}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 14.44, ["Ride"] = 39.27, ["Fly|Ride"] = 65.29, ["Neon"] = 120.75, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 144.25, ["Mega"] = 655.03, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 28.87, ["Ride"] = 57.75, ["Fly|Ride"] = 148.38, ["Neon"] = 226.5, ["Neon|Ride"] = 245.34, ["Mega"] = 997.5, ["Mega|Ride"] = 853.13, ["Mega|Fly|Ride"] = 1011.85}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 17.9, ["Fly"] = 58.56, ["Ride"] = 26.24, ["Fly|Ride"] = 79.48, ["Neon"] = 129.94, ["Neon|Ride"] = 130.11, ["Neon|Fly|Ride"] = 328.5, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6784.32, ["Ride"] = 5512.5, ["Fly|Ride"] = 5512.5, ["Neon"] = 36137.39, ["Neon|Ride"] = 28875, ["Neon|Fly|Ride"] = 30210.63, ["Mega|Fly|Ride"] = 111213.05}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 208.69, ["Fly"] = 249.37, ["Ride"] = 245.01, ["Fly|Ride"] = 305.82, ["Neon"] = 818.16, ["Neon|Fly"] = 740.88, ["Neon|Fly|Ride"] = 568.55, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 64.97, ["Fly"] = 170.02, ["Ride"] = 111.57, ["Fly|Ride"] = 227.07, ["Neon"] = 181.13, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 320.25, ["Mega"] = 553.45, ["Mega|Ride"] = 524.9, ["Mega|Fly|Ride"] = 639.19}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.35, ["Fly"] = 90.79, ["Ride"] = 21.41, ["Fly|Ride"] = 81.37, ["Neon"] = 21.12, ["Neon|Fly"] = 86.75, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 499.8, ["Mega|Ride"] = 330.75, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 61.68, ["Fly"] = 215.34, ["Ride"] = 210, ["Fly|Ride"] = 245.58, ["Neon"] = 199.5, ["Neon|Ride"] = 261.19, ["Neon|Fly|Ride"] = 557.82, ["Mega"] = 478.16, ["Mega|Ride"] = 446.25, ["Mega|Fly|Ride"] = 735}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 16616.25, ["Ride"] = 13415.07, ["Fly|Ride"] = 11808.57, ["Neon|Fly|Ride"] = 22968.75, ["Mega|Fly|Ride"] = 102484.28}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 315, ["Ride"] = 405.46, ["Fly|Ride"] = 556.5, ["Neon|Ride"] = 1879.84, ["Neon|Fly|Ride"] = 1663.03}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 54.87, ["Fly"] = 65.63, ["Ride"] = 64.31, ["Fly|Ride"] = 113.19, ["Neon"] = 1049.99, ["Neon|Ride"] = 328.11, ["Neon|Fly|Ride"] = 385.88, ["Mega|Fly|Ride"] = 2021.25}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 7.7, ["Ride"] = 27.57, ["Fly|Ride"] = 60.38, ["Neon"] = 67.47, ["Neon|Fly"] = 327.52, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 145.28, ["Mega"] = 421.32, ["Mega|Ride"] = 735.98}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 354.38, ["Fly"] = 867.29, ["Ride"] = 406.87, ["Fly|Ride"] = 491.77, ["Neon"] = 1721.56, ["Neon|Ride"] = 1442.44, ["Neon|Fly|Ride"] = 1312.49, ["Mega|Fly|Ride"] = 4593.75}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 7.88, ["Ride"] = 41.97, ["Fly|Ride"] = 199.5, ["Neon"] = 30.17, ["Neon|Ride"] = 128.52, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 158.82, ["Mega|Fly"] = 263.92, ["Mega|Ride"] = 227.07, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 101.34, ["Fly"] = 167.91, ["Ride"] = 160.13, ["Fly|Ride"] = 197.72, ["Neon"] = 393.75, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 511.88, ["Mega"] = 2146.53, ["Mega|Fly|Ride"] = 2293.16}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 10.49, ["Fly"] = 22.2, ["Ride"] = 23.31, ["Fly|Ride"] = 33.12, ["Neon"] = 116.02, ["Neon|Ride"] = 58.56, ["Neon|Fly|Ride"] = 105, ["Mega"] = 2601.86, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 10.7}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 49.07, ["Ride"] = 87.94, ["Fly|Ride"] = 131.25, ["Neon"] = 327.52, ["Neon|Fly"] = 540.99, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 432.57, ["Mega|Ride"] = 2022.95}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 9.09, ["Fly"] = 80.07, ["Ride"] = 34.13, ["Fly|Ride"] = 94.5, ["Neon"] = 91.77, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 239.6, ["Mega"] = 584.34, ["Mega|Ride"] = 577.5, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 32.82}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 76.11, ["Fly"] = 145.28, ["Ride"] = 118.13, ["Fly|Ride"] = 433.65, ["Neon"] = 359.28, ["Neon|Ride"] = 439.69, ["Neon|Fly|Ride"] = 575.68, ["Mega|Fly|Ride"] = 2048.96}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.77, ["Ride"] = 29.24, ["Fly|Ride"] = 137.82, ["Neon"] = 26.25, ["Neon|Ride"] = 137.7, ["Neon|Fly|Ride"] = 289.47, ["Mega"] = 140.44, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 323.54}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 11.81, ["Fly"] = 56.44, ["Ride"] = 33.49, ["Fly|Ride"] = 95.01, ["Neon"] = 160.13, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 215.76, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 586.69}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 537.96, ["Fly"] = 542.07, ["Ride"] = 485.63, ["Fly|Ride"] = 498.74, ["Neon|Fly|Ride"] = 2817.59, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 36.75, ["Fly"] = 108.43, ["Ride"] = 52.5, ["Fly|Ride"] = 99.71, ["Neon"] = 195.57, ["Neon|Ride"] = 185.22, ["Neon|Fly|Ride"] = 327.52, ["Mega"] = 776.43, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 717.84}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 48.56, ["Fly"] = 144.46, ["Ride"] = 50.84, ["Fly|Ride"] = 144.27, ["Neon"] = 236.25, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 288.75, ["Mega|Ride"] = 1066.77, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 19.64, ["Fly"] = 33.63, ["Ride"] = 78.75, ["Fly|Ride"] = 127.94, ["Neon"] = 106.25, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 311.1, ["Mega"] = 362.11, ["Mega|Fly"] = 525, ["Mega|Ride"] = 527.98, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 10500, ["Ride"] = 8862, ["Fly|Ride"] = 8186.07, ["Neon|Fly|Ride"] = 15592.5, ["Mega|Fly|Ride"] = 38850}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1506.75, ["Fly"] = 1501.85, ["Ride"] = 1391.25, ["Fly|Ride"] = 1404.38, ["Neon|Fly|Ride"] = 4111.38, ["Mega|Fly|Ride"] = 24573.3}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 517.13, ["Ride"] = 583.89, ["Fly|Ride"] = 721.66, ["Neon"] = 2253.58, ["Neon|Fly|Ride"] = 3084.38, ["Mega"] = 21682, ["Mega|Fly|Ride"] = 7227.71}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 12.74, ["Fly"] = 26.03, ["Ride"] = 24.94, ["Fly|Ride"] = 39.86, ["Neon"] = 136.5, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 121.45, ["Mega|Fly|Ride"] = 577.49}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 2.9, ["Fly"] = 52.5, ["Ride"] = 37.7, ["Fly|Ride"] = 119.12, ["Neon"] = 23.63, ["Neon|Ride"] = 56.11, ["Mega"] = 144.38, ["Mega|Ride"] = 202.44}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 31.5, ["Fly"] = 41.91, ["Ride"] = 49.77, ["Fly|Ride"] = 97.13, ["Neon"] = 239.4, ["Neon|Ride"] = 162.75, ["Neon|Fly|Ride"] = 177.18, ["Mega|Fly|Ride"] = 666.75}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.71, ["Fly"] = 26.24, ["Ride"] = 18.78, ["Fly|Ride"] = 43.29, ["Neon"] = 30.12, ["Neon|Fly"] = 86.63, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 109.74, ["Mega"] = 281.88, ["Mega|Ride"] = 202.74, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 319.73, ["Fly"] = 426.2, ["Ride"] = 301.26, ["Fly|Ride"] = 354.37, ["Neon"] = 1626.16, ["Neon|Ride"] = 1055.94, ["Neon|Fly|Ride"] = 918.75, ["Mega|Fly|Ride"] = 4336.41}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 17.06, ["Fly"] = 60.73, ["Ride"] = 26.45, ["Fly|Ride"] = 62.99, ["Neon"] = 144.38, ["Neon|Fly"] = 407.29, ["Neon|Ride"] = 162.64, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 867.29, ["Mega|Fly"] = 916.3, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 721.77}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 6.57, ["Fly"] = 24.94, ["Ride"] = 22.32, ["Fly|Ride"] = 45.94, ["Neon"] = 84.57, ["Neon|Fly"] = 122.52, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 1575, ["Mega|Ride"] = 618.22, ["Mega|Fly|Ride"] = 423.94}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 524.94, ["Fly"] = 1048.69, ["Ride"] = 578.92, ["Fly|Ride"] = 866.58, ["Mega|Fly|Ride"] = 9971.07}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1115.63, ["Fly"] = 1446.21, ["Ride"] = 1155, ["Fly|Ride"] = 1181.24, ["Neon"] = 5263.39, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 13731.21}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 115.49, ["Fly"] = 145.28, ["Ride"] = 99.23, ["Fly|Ride"] = 105, ["Neon"] = 971.25, ["Neon|Ride"] = 596.27, ["Neon|Fly|Ride"] = 492.2, ["Mega|Fly|Ride"] = 2854.34}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 196.87, ["Fly"] = 262.5, ["Ride"] = 216.46, ["Fly|Ride"] = 272.99, ["Neon"] = 1012.56, ["Neon|Ride"] = 735.98, ["Neon|Fly|Ride"] = 725.82, ["Mega|Ride"] = 9187.5, ["Mega|Fly|Ride"] = 2598.75}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 31.35, ["Fly"] = 124.68, ["Ride"] = 52.5, ["Fly|Ride"] = 101.92, ["Neon"] = 242.04, ["Neon|Ride"] = 240.55, ["Mega|Ride"] = 2168.21, ["Mega|Fly|Ride"] = 1097.83}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 362.25, ["Ride"] = 431.16, ["Fly|Ride"] = 492.2, ["Neon"] = 1220.63, ["Neon|Fly|Ride"] = 1300.93, ["Mega|Fly|Ride"] = 5782.61}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 1968.75, ["Fly"] = 2313.48, ["Ride"] = 1968.65, ["Fly|Ride"] = 2029.07, ["Neon|Fly|Ride"] = 10841, ["Mega|Fly|Ride"] = 37454.54}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 49.07, ["Fly"] = 216.84, ["Ride"] = 49.88, ["Fly|Ride"] = 196.88, ["Neon"] = 216.84, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 343.88, ["Mega|Ride"] = 2385.04}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 682.5, ["Fly"] = 867.29, ["Ride"] = 656.25, ["Fly|Ride"] = 687.75, ["Neon|Ride"] = 1498.88, ["Neon|Fly|Ride"] = 1179.93, ["Mega|Fly|Ride"] = 4200}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 45.7, ["Fly"] = 70.88, ["Ride"] = 54.16, ["Fly|Ride"] = 107.63, ["Neon|Ride"] = 245.34, ["Neon|Fly|Ride"] = 288.75, ["Mega|Ride"] = 1084.12, ["Mega|Fly|Ride"] = 1156.75}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.93, ["Fly"] = 26.25, ["Ride"] = 19.55, ["Fly|Ride"] = 56.7, ["Neon"] = 28.25, ["Neon|Fly"] = 110.25, ["Neon|Ride"] = 39.29, ["Neon|Fly|Ride"] = 105, ["Mega"] = 166.69, ["Mega|Fly"] = 249.38, ["Mega|Ride"] = 187.38, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 61.68, ["Ride"] = 84.57, ["Fly|Ride"] = 157.5, ["Neon"] = 285.66, ["Neon|Ride"] = 481.47, ["Neon|Fly|Ride"] = 433.65, ["Mega"] = 1587.13, ["Mega|Ride"] = 1734.57, ["Mega|Fly|Ride"] = 1720.48}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 990.83, ["Ride"] = 971.24, ["Fly|Ride"] = 1036.88, ["Neon|Ride"] = 3469.13, ["Neon|Fly|Ride"] = 3081.74, ["Mega|Fly|Ride"] = 11564.11}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 721.88, ["Ride"] = 809.85, ["Fly|Ride"] = 909.57, ["Neon|Fly|Ride"] = 4335.33, ["Mega|Fly|Ride"] = 17345.61}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 15.49, ["Fly"] = 26.24, ["Ride"] = 23.31, ["Fly|Ride"] = 47.25, ["Neon"] = 144.38, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 144.38, ["Mega|Fly|Ride"] = 722.52}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 17.21, ["Ride"] = 40.72, ["Fly|Ride"] = 128.63, ["Neon"] = 168, ["Neon|Ride"] = 152.25, ["Neon|Fly|Ride"] = 143.12, ["Mega"] = 1012.56, ["Mega|Ride"] = 990.88, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 6.5, ["Ride"] = 31.5, ["Fly|Ride"] = 216.84, ["Neon"] = 23.63, ["Neon|Fly"] = 327.52, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 201.48, ["Mega"] = 196.88, ["Mega|Fly"] = 572.84, ["Mega|Ride"] = 204.65}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 47.25, ["Fly"] = 72.19, ["Ride"] = 52.49, ["Fly|Ride"] = 108.43, ["Neon"] = 202.74, ["Neon|Ride"] = 215.65, ["Neon|Fly|Ride"] = 214.28, ["Mega|Ride"] = 1090.47, ["Mega|Fly|Ride"] = 1207.5}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 97.13, ["Ride"] = 327.52, ["Fly|Ride"] = 362.11, ["Neon"] = 413.44, ["Neon|Ride"] = 613.32, ["Neon|Fly|Ride"] = 655.03, ["Mega|Ride"] = 2168.21, ["Mega|Fly|Ride"] = 2877.21}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 17.06, ["Fly"] = 57.66, ["Ride"] = 34.19, ["Fly|Ride"] = 90.57, ["Neon"] = 98.15, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 164.38, ["Mega"] = 429.7, ["Mega|Ride"] = 362.15, ["Mega|Fly|Ride"] = 544.68}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 31.98, ["Fly"] = 63, ["Ride"] = 41.66, ["Fly|Ride"] = 84.03, ["Neon"] = 233.07, ["Neon|Ride"] = 223.02, ["Neon|Fly|Ride"] = 239.26, ["Mega"] = 1842.99, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.77, ["Fly"] = 45.85, ["Ride"] = 20.98, ["Fly|Ride"] = 50.96, ["Neon"] = 27.57, ["Neon|Ride"] = 62.9, ["Neon|Fly|Ride"] = 91.87, ["Mega"] = 434.74, ["Mega|Ride"] = 490.67, ["Mega|Fly|Ride"] = 368.82}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 6.44, ["Fly"] = 53.82, ["Ride"] = 36.74, ["Fly|Ride"] = 33246.09, ["Neon"] = 51.1, ["Neon|Fly"] = 115.54, ["Neon|Ride"] = 68.25, ["Neon|Fly|Ride"] = 239.6, ["Mega"] = 367.5, ["Mega|Ride"] = 441.59, ["Mega|Fly|Ride"] = 546}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 45.61, ["Fly"] = 72.18, ["Ride"] = 53.71, ["Fly|Ride"] = 102.38, ["Neon"] = 202.74, ["Neon|Ride"] = 361.87, ["Neon|Fly|Ride"] = 272.54, ["Mega|Fly|Ride"] = 1074.92}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1396.5, ["Fly"] = 1410.93, ["Ride"] = 1447.28, ["Fly|Ride"] = 1537.62, ["Neon|Ride"] = 5059.5, ["Neon|Fly|Ride"] = 3622.5, ["Mega|Fly|Ride"] = 12576.37}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 472.48, ["Fly"] = 524.99, ["Ride"] = 498.75, ["Fly|Ride"] = 511.88, ["Neon|Ride"] = 3758.58, ["Neon|Fly|Ride"] = 2362.5, ["Mega"] = 15177.41, ["Mega|Fly|Ride"] = 8962.27}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 273, ["Fly"] = 378.23, ["Ride"] = 357.77, ["Fly|Ride"] = 393.75, ["Neon"] = 1575, ["Neon|Ride"] = 1468.69, ["Neon|Fly|Ride"] = 1446.21, ["Mega|Fly|Ride"] = 7805.53}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 38.31}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 25.93, ["Ride"] = 54.67, ["Fly|Ride"] = 101.92, ["Neon"] = 325.25, ["Neon|Fly"] = 289.47, ["Neon|Ride"] = 249.36, ["Neon|Fly|Ride"] = 393.75, ["Mega|Ride"] = 1192.52, ["Mega|Fly|Ride"] = 1012.56}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 70875, ["Fly"] = 27102.5, ["Ride"] = 37616.46, ["Fly|Ride"] = 16406.25, ["Neon|Fly|Ride"] = 37798.69, ["Mega"] = 216819.91, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 240.19, ["Fly"] = 284.55, ["Ride"] = 260.3, ["Fly|Ride"] = 274.32, ["Neon"] = 656.25, ["Neon|Fly"] = 853.13, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 918.75, ["Mega"] = 6504.61, ["Mega|Fly|Ride"] = 3281.25}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 118.13, ["Fly"] = 525, ["Ride"] = 249.38, ["Fly|Ride"] = 262.49}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 114.75, ["Fly"] = 157.5, ["Ride"] = 110.25, ["Fly|Ride"] = 182.44, ["Neon|Ride"] = 719.24, ["Neon|Fly|Ride"] = 624.75, ["Mega|Fly|Ride"] = 1734.57}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 13.11, ["Fly"] = 65.06, ["Ride"] = 27.57, ["Fly|Ride"] = 97.59, ["Neon"] = 82.21, ["Neon|Ride"] = 145.28, ["Neon|Fly|Ride"] = 232.02, ["Mega"] = 733.53, ["Mega|Ride"] = 723.11, ["Mega|Fly|Ride"] = 904.15}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 4839.44, ["Ride"] = 3936.19, ["Fly|Ride"] = 4199.99, ["Neon"] = 21682, ["Neon|Fly|Ride"] = 15750, ["Mega|Fly|Ride"] = 81774.42}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 30.19, ["Fly"] = 43.43, ["Ride"] = 33.56, ["Fly|Ride"] = 55.46, ["Neon"] = 131.25, ["Neon|Ride"] = 215.76, ["Neon|Fly|Ride"] = 173.15, ["Mega|Ride"] = 1446.21, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 36.53, ["Ride"] = 54.9, ["Fly|Ride"] = 85.31, ["Neon"] = 291.73, ["Neon|Fly"] = 1446.21, ["Neon|Ride"] = 202.79, ["Neon|Fly|Ride"] = 312.38, ["Mega|Fly|Ride"] = 1416.19}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 413.44, ["Fly"] = 563.06, ["Ride"] = 458.07, ["Fly|Ride"] = 568.32, ["Neon"] = 1168.13, ["Neon|Ride"] = 1226.91, ["Neon|Fly|Ride"] = 1437.19, ["Mega|Fly|Ride"] = 4302.54}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 14.6, ["Fly"] = 30.09, ["Ride"] = 23.62, ["Fly|Ride"] = 53.82, ["Neon"] = 131.25, ["Neon|Fly"] = 145.28, ["Neon|Ride"] = 111.18, ["Neon|Fly|Ride"] = 157.5, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 609.12}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 14.43, ["Ride"] = 34.55, ["Fly|Ride"] = 82.21, ["Neon"] = 91.88, ["Neon|Ride"] = 131.15, ["Neon|Fly|Ride"] = 211.21, ["Mega|Ride"] = 415.8, ["Mega|Fly|Ride"] = 735.98}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 105, ["Ride"] = 86.75, ["Fly|Ride"] = 245.44, ["Neon"] = 735.98, ["Neon|Ride"] = 511.88, ["Neon|Fly|Ride"] = 739.37, ["Mega|Fly|Ride"] = 2617.6}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 86.73, ["Fly"] = 539.44, ["Ride"] = 74.46, ["Fly|Ride"] = 131.25, ["Neon"] = 84, ["Neon|Ride"] = 118.33, ["Neon|Fly|Ride"] = 259.38, ["Mega"] = 393.75, ["Mega|Fly"] = 487.1, ["Mega|Ride"] = 312.67, ["Mega|Fly|Ride"] = 490.67}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 4264.21, ["Ride"] = 4331.25, ["Fly|Ride"] = 3937.5, ["Neon"] = 19687.5, ["Neon|Ride"] = 12337.5, ["Neon|Fly|Ride"] = 10447.5, ["Mega"] = 49146.59, ["Mega|Fly|Ride"] = 37945.69}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 34.12, ["Fly"] = 145.28, ["Ride"] = 51.19, ["Fly|Ride"] = 165.61, ["Neon"] = 223.34, ["Neon|Ride"] = 258.57, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 867.29, ["Mega|Ride"] = 1799.45}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 6562.5, ["Ride"] = 6857.82, ["Fly|Ride"] = 6126.75, ["Neon"] = 22897.14, ["Neon|Fly|Ride"] = 15144.94, ["Mega|Fly|Ride"] = 46921.88}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.63, ["Fly"] = 20.79, ["Ride"] = 17.89, ["Fly|Ride"] = 32.82, ["Neon"] = 25.78, ["Neon|Fly"] = 62.62, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 99.16, ["Mega"] = 210, ["Mega|Ride"] = 202.74, ["Mega|Fly|Ride"] = 260.21}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 18.02, ["Fly"] = 33.99, ["Ride"] = 32.82, ["Fly|Ride"] = 51.19, ["Neon"] = 188.65, ["Neon|Fly"] = 239.6, ["Neon|Ride"] = 141.91, ["Neon|Fly|Ride"] = 145.28, ["Mega|Ride"] = 1004.73, ["Mega|Fly|Ride"] = 735}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 4.3}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 12.93, ["Fly"] = 32.82, ["Ride"] = 33.63, ["Fly|Ride"] = 116.03, ["Neon"] = 78.74, ["Neon|Ride"] = 131.25, ["Mega|Ride"] = 1083.03, ["Mega|Fly|Ride"] = 1130.74}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 22.32, ["Fly"] = 190.37, ["Ride"] = 48.07, ["Fly|Ride"] = 173.46, ["Neon"] = 145.28, ["Neon|Ride"] = 128.64, ["Neon|Fly|Ride"] = 219.19, ["Mega|Ride"] = 867.29, ["Mega|Fly|Ride"] = 1099.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 12.5, ["Fly"] = 28.88, ["Ride"] = 24.05, ["Fly|Ride"] = 42, ["Neon|Fly"] = 1080.86, ["Neon|Ride"] = 101.92, ["Neon|Fly|Ride"] = 120.35, ["Mega"] = 2601.86, ["Mega|Ride"] = 429.33, ["Mega|Fly|Ride"] = 613.61}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8671.79}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2493.75}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 22.32}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 196.88, ["Ride"] = 278.45, ["Fly|Ride"] = 341.24, ["Neon|Fly|Ride"] = 1213.13}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 18.38, ["Fly"] = 145.28, ["Ride"] = 32.8, ["Fly|Ride"] = 138.77, ["Neon"] = 118.55, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 265.13, ["Mega"] = 525, ["Mega|Ride"] = 2045.99}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 11.69}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 6.45, ["Ride"] = 26.24, ["Fly|Ride"] = 86.75, ["Neon|Ride"] = 249.38}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2323.13}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 209.99, ["Fly"] = 433.65, ["Ride"] = 262.5, ["Fly|Ride"] = 367.5, ["Neon"] = 1012.56, ["Neon|Ride"] = 1080.66, ["Neon|Fly|Ride"] = 1083.03, ["Mega|Ride"] = 4192.23, ["Mega|Fly|Ride"] = 3936.45}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 60.38, ["Fly"] = 477.17, ["Ride"] = 93.26, ["Fly|Ride"] = 245.34, ["Neon"] = 393.75, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 563.74, ["Mega|Fly|Ride"] = 2009.95}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 173.45, ["Fly"] = 275.63, ["Ride"] = 198.79, ["Fly|Ride"] = 258.57, ["Neon"] = 944.99, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 826.88, ["Mega|Fly|Ride"] = 3674.9}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 2488.5, ["Fly"] = 3125.41, ["Ride"] = 2756.25, ["Fly|Ride"] = 2863.66, ["Neon"] = 15227.27, ["Neon|Ride"] = 9812.9, ["Neon|Fly|Ride"] = 8177.82, ["Mega|Fly|Ride"] = 28909.7}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 18.38, ["Fly"] = 106.25, ["Ride"] = 54.11, ["Fly|Ride"] = 112.76, ["Neon"] = 173.46, ["Neon|Ride"] = 156.19, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 974.61, ["Mega|Ride"] = 1012.56, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 630, ["Fly"] = 2100, ["Ride"] = 841.46, ["Fly|Ride"] = 867.29, ["Neon|Fly|Ride"] = 4252.67}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 41.58}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 18.25, ["Ride"] = 43.32, ["Fly|Ride"] = 157.5, ["Neon"] = 105, ["Neon|Ride"] = 134.44, ["Neon|Fly|Ride"] = 327.52, ["Mega"] = 444.94, ["Mega|Ride"] = 514.56, ["Mega|Fly|Ride"] = 695.63}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 6.57, ["Fly"] = 29.28, ["Ride"] = 30.18, ["Fly|Ride"] = 128.63, ["Neon"] = 72.1, ["Neon|Fly"] = 315, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 105, ["Mega"] = 458.76, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 397.43}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 59.05}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 19.4, ["Ride"] = 26.14, ["Fly|Ride"] = 82.21, ["Neon|Ride"] = 213.45, ["Neon|Fly|Ride"] = 202.74, ["Mega|Ride"] = 1229.39, ["Mega|Fly|Ride"] = 2168.21}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 25.92, ["Fly"] = 45.94, ["Ride"] = 42, ["Fly|Ride"] = 63, ["Neon"] = 393.75, ["Neon|Fly"] = 239.6, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 288.39, ["Mega"] = 1446.21, ["Mega|Ride"] = 1839.93}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 7226.63, ["Fly"] = 6779.98, ["Ride"] = 6924.17, ["Fly|Ride"] = 5117.18, ["Neon|Fly|Ride"] = 9999.94, ["Mega|Fly|Ride"] = 34691.2}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 8.92, ["Fly"] = 43.38, ["Ride"] = 32.82, ["Fly|Ride"] = 81.83, ["Neon"] = 55.13, ["Neon|Ride"] = 87.45, ["Neon|Fly|Ride"] = 229.39, ["Mega"] = 354.38, ["Mega|Ride"] = 288.74, ["Mega|Fly|Ride"] = 547.08}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 20.98}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 85.31, ["Fly"] = 383.79, ["Ride"] = 127.32, ["Fly|Ride"] = 196.88, ["Neon"] = 420, ["Neon|Ride"] = 460.92, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 2879.59, ["Mega|Ride"] = 1764.77, ["Mega|Fly|Ride"] = 2023.43}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 53.8, ["Fly"] = 190.93, ["Ride"] = 89.25, ["Fly|Ride"] = 164.37, ["Neon"] = 249.38, ["Neon|Fly"] = 392.54, ["Neon|Ride"] = 289.47, ["Neon|Fly|Ride"] = 458.07, ["Mega"] = 2453.24, ["Mega|Ride"] = 1191.44}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 23.55, ["Fly"] = 82.41, ["Ride"] = 31.88, ["Fly|Ride"] = 76.13, ["Neon"] = 174.57, ["Neon|Fly"] = 234.18, ["Neon|Ride"] = 147, ["Neon|Fly|Ride"] = 182.44, ["Mega"] = 1016.21, ["Mega|Ride"] = 883.17}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 6.56, ["Fly"] = 78.74, ["Ride"] = 29.53, ["Fly|Ride"] = 103.69, ["Neon"] = 28.87, ["Neon|Ride"] = 89.19, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 162.75, ["Mega|Fly"] = 7227.71, ["Mega|Ride"] = 222.87, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 12.39, ["Fly"] = 65.63, ["Ride"] = 32.82, ["Fly|Ride"] = 98.06, ["Neon"] = 87.94, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 218.29, ["Mega"] = 380.63, ["Mega|Ride"] = 723.11, ["Mega|Fly|Ride"] = 560.32}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 23.08, ["Fly"] = 32.81, ["Ride"] = 26.17, ["Fly|Ride"] = 51.98, ["Neon"] = 278.25, ["Neon|Fly"] = 144.38, ["Neon|Ride"] = 128.63, ["Neon|Fly|Ride"] = 144.25, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 199.39}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 32.82, ["Ride"] = 157.5, ["Fly|Ride"] = 289.47, ["Neon"] = 170.63, ["Neon|Ride"] = 326.82, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 866.25, ["Mega|Ride"] = 591.94, ["Mega|Fly|Ride"] = 685.17}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 245.34, ["Fly"] = 236.25, ["Ride"] = 170.63, ["Fly|Ride"] = 145.28, ["Neon|Fly|Ride"] = 28909.7}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 55.11, ["Fly"] = 199.61, ["Ride"] = 86.17, ["Fly|Ride"] = 210, ["Neon"] = 210, ["Neon|Ride"] = 342.26, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 1140.57, ["Mega|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 1337.44}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 918.75, ["Fly"] = 1181.25, ["Ride"] = 1114.32, ["Fly|Ride"] = 1102.5, ["Neon|Fly"] = 4722.47, ["Neon|Ride"] = 3018.75, ["Neon|Fly|Ride"] = 3581.48, ["Mega|Fly|Ride"] = 13125}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 393.75, ["Fly"] = 723.11, ["Ride"] = 417.38, ["Fly|Ride"] = 538.12, ["Neon"] = 2756.25, ["Neon|Ride"] = 2168.21, ["Neon|Fly|Ride"] = 1995, ["Mega"] = 13009.2, ["Mega|Fly|Ride"] = 9448.69}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 53.09}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.63}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 9.97, ["Fly"] = 31.49, ["Ride"] = 24.94, ["Fly|Ride"] = 52.49, ["Neon"] = 79.8, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 85.25, ["Neon|Fly|Ride"] = 143.06, ["Mega"] = 437.26, ["Mega|Ride"] = 723.11, ["Mega|Fly|Ride"] = 573.57}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 234.87, ["Fly"] = 524.99, ["Ride"] = 281.82, ["Fly|Ride"] = 366.19, ["Neon"] = 909.85, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 945, ["Mega|Fly|Ride"] = 3203.43}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 13.01}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 111.57, ["Ride"] = 162.75, ["Fly|Ride"] = 295.32, ["Neon"] = 459.38, ["Neon|Fly"] = 610.32, ["Neon|Ride"] = 566.68, ["Neon|Fly|Ride"] = 669.38, ["Mega"] = 2809.03, ["Mega|Ride"] = 2575.9, ["Mega|Fly|Ride"] = 2339.51}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 102.37, ["Fly"] = 216.84, ["Ride"] = 144.59, ["Fly|Ride"] = 225.75, ["Neon"] = 723.11, ["Neon|Ride"] = 853.13, ["Neon|Fly|Ride"] = 867.29, ["Mega|Fly|Ride"] = 2891.31}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 5.94, ["Fly"] = 80.24, ["Ride"] = 29.29, ["Fly|Ride"] = 176.73, ["Neon"] = 30.19, ["Neon|Ride"] = 69.39, ["Neon|Fly|Ride"] = 239.54, ["Mega"] = 216.84, ["Mega|Ride"] = 188.65, ["Mega|Fly|Ride"] = 327.52}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 13.01, ["Fly"] = 51.97, ["Ride"] = 27.57, ["Fly|Ride"] = 72.1, ["Neon"] = 177.18, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 327.52, ["Mega|Ride"] = 1446.21, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 13.12, ["Fly"] = 102.36, ["Ride"] = 34.12, ["Fly|Ride"] = 118.12, ["Neon"] = 81.17, ["Neon|Ride"] = 101.06, ["Neon|Fly|Ride"] = 269.07, ["Mega"] = 498.75, ["Mega|Ride"] = 525}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 7.35, ["Fly"] = 131.23, ["Ride"] = 56.34, ["Fly|Ride"] = 157.5, ["Neon"] = 26.24, ["Neon|Ride"] = 75.14, ["Neon|Fly|Ride"] = 196.49, ["Mega"] = 184.79, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 322.83}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 288.75, ["Ride"] = 307.13, ["Fly|Ride"] = 342.57, ["Neon"] = 1446.21, ["Neon|Ride"] = 1408.16, ["Neon|Fly|Ride"] = 1395.72, ["Mega|Fly|Ride"] = 6613.03}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 93.42, ["Fly"] = 578.92, ["Ride"] = 128.64, ["Fly|Ride"] = 183.75, ["Neon"] = 420, ["Neon|Ride"] = 492.18, ["Neon|Fly|Ride"] = 513.19, ["Mega"] = 2600.77, ["Mega|Fly|Ride"] = 1833.22}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 65.62, ["Fly"] = 167.45, ["Ride"] = 82.69, ["Fly|Ride"] = 116.11, ["Neon"] = 315, ["Neon|Ride"] = 262.49, ["Neon|Fly|Ride"] = 415.8, ["Mega|Ride"] = 1799.45, ["Mega|Fly|Ride"] = 1372.88}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 14.43, ["Ride"] = 54.23, ["Fly|Ride"] = 289.47, ["Neon|Ride"] = 623.13, ["Neon|Fly|Ride"] = 506.29}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 15.75, ["Ride"] = 29.24, ["Fly|Ride"] = 78.52, ["Neon"] = 94.5, ["Neon|Fly"] = 145.28, ["Neon|Ride"] = 116.02, ["Neon|Fly|Ride"] = 126, ["Mega"] = 433.65, ["Mega|Ride"] = 490.67, ["Mega|Fly|Ride"] = 618.22}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 2.63, ["Fly"] = 40.69, ["Ride"] = 21.31, ["Fly|Ride"] = 69.47, ["Neon"] = 24.15, ["Neon|Fly"] = 78.07, ["Neon|Ride"] = 41.36, ["Neon|Fly|Ride"] = 84.58, ["Mega"] = 166.69, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 278.25}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 884.63, ["Fly"] = 918.75, ["Ride"] = 952.88, ["Fly|Ride"] = 925.32, ["Neon"] = 3035.49, ["Neon|Fly"] = 3330.26, ["Neon|Ride"] = 8672.81, ["Neon|Fly|Ride"] = 2341.5, ["Mega|Fly|Ride"] = 7221.38}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 314.99, ["Fly"] = 319.82, ["Ride"] = 306.98, ["Fly|Ride"] = 362.6, ["Neon"] = 1300.93, ["Neon|Ride"] = 1270.5, ["Neon|Fly|Ride"] = 1273.13, ["Mega"] = 10841, ["Mega|Fly|Ride"] = 5059.5}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 91.88, ["Fly"] = 173.46, ["Ride"] = 118.85, ["Fly|Ride"] = 131.25, ["Neon"] = 422.63, ["Neon|Ride"] = 416.61, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 1312.5, ["Mega|Ride"] = 1749.75, ["Mega|Fly|Ride"] = 1879.84}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 203.43, ["Fly"] = 216.84, ["Ride"] = 205.24, ["Fly|Ride"] = 236.42, ["Neon|Ride"] = 997.5, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 10841, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 29.29, ["Fly"] = 58.56, ["Ride"] = 30.17, ["Fly|Ride"] = 81.38, ["Neon"] = 169.32, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 216.84, ["Mega|Ride"] = 758.68, ["Mega|Fly|Ride"] = 956.2}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 236.25, ["Ride"] = 282.19, ["Fly|Ride"] = 374.07, ["Neon"] = 895.42, ["Neon|Ride"] = 942.38, ["Neon|Fly|Ride"] = 1023, ["Mega"] = 4314.35, ["Mega|Fly|Ride"] = 4247.22}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 72.53, ["Fly"] = 125.99, ["Ride"] = 65.63, ["Fly|Ride"] = 129.55, ["Neon|Ride"] = 578.92, ["Neon|Fly|Ride"] = 867.29, ["Mega|Ride"] = 2313.48, ["Mega|Fly|Ride"] = 1624.88}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 2963.93, ["Ride"] = 2887.49, ["Fly|Ride"] = 2472.75, ["Neon|Ride"] = 8672.81, ["Neon|Fly|Ride"] = 7697.12, ["Mega"] = 52036.79, ["Mega|Fly|Ride"] = 27464.59}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 11.81, ["Fly"] = 65.63, ["Ride"] = 34.92, ["Fly|Ride"] = 78.75, ["Neon"] = 57.17, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 173.34, ["Mega"] = 255.61, ["Mega|Fly"] = 578.92, ["Mega|Ride"] = 338.05, ["Mega|Fly|Ride"] = 419.79}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 35.43, ["Ride"] = 82.57, ["Fly|Ride"] = 149.63, ["Neon"] = 232.02, ["Neon|Ride"] = 202.74, ["Neon|Fly|Ride"] = 452.1, ["Mega|Ride"] = 931.88}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 77.41, ["Fly"] = 86.92, ["Ride"] = 82.6, ["Fly|Ride"] = 89.25, ["Neon"] = 525, ["Neon|Ride"] = 492.2, ["Neon|Fly|Ride"] = 410.81, ["Mega|Fly|Ride"] = 2023.43}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 2203.69, ["Fly"] = 1636.31, ["Ride"] = 1069.69, ["Fly|Ride"] = 997.49, ["Neon|Ride"] = 5724.59, ["Neon|Fly|Ride"] = 3937.49, ["Mega"] = 37148.86, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 420, ["Fly"] = 865.12, ["Ride"] = 758.89, ["Fly|Ride"] = 534.19}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 70.87, ["Fly"] = 105, ["Ride"] = 116, ["Fly|Ride"] = 278.45, ["Neon"] = 364.88, ["Neon|Ride"] = 342.38, ["Neon|Fly|Ride"] = 542.07, ["Mega"] = 2168.21, ["Mega|Ride"] = 1712.9, ["Mega|Fly|Ride"] = 1748.58}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 8.69, ["Fly"] = 32.82, ["Ride"] = 23.55, ["Fly|Ride"] = 85.65, ["Neon"] = 73.5, ["Neon|Ride"] = 95.42, ["Neon|Fly|Ride"] = 187.69, ["Mega"] = 553.88, ["Mega|Ride"] = 815.69}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 34.12, ["Fly"] = 62.67, ["Ride"] = 44.12, ["Fly|Ride"] = 69.66, ["Neon"] = 212.63, ["Neon|Fly"] = 362.11, ["Neon|Ride"] = 281.88, ["Neon|Fly|Ride"] = 346.92, ["Mega|Ride"] = 1187.82, ["Mega|Fly|Ride"] = 1012.56}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 748.13, ["Fly"] = 1128.49, ["Ride"] = 874.13, ["Fly|Ride"] = 892.5, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2508.43, ["Mega|Fly|Ride"] = 9723}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 616.86}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 12264.66, ["Ride"] = 5250, ["Fly|Ride"] = 4921.87, ["Neon"] = 42000, ["Neon|Ride"] = 31071.38, ["Neon|Fly|Ride"] = 24573.3, ["Mega|Fly|Ride"] = 108409.96}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 266.44, ["Fly"] = 406.55, ["Ride"] = 289.47, ["Fly|Ride"] = 426.87, ["Neon"] = 1734.57, ["Neon|Fly|Ride"] = 2168.21, ["Mega"] = 6503.54, ["Mega|Ride"] = 6216.25, ["Mega|Fly|Ride"] = 6504.61}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 98.12, ["Ride"] = 131.25, ["Fly|Ride"] = 289.47, ["Neon"] = 1144.83, ["Neon|Ride"] = 563.74, ["Neon|Fly|Ride"] = 490.67}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 20.78, ["Fly"] = 101.92, ["Ride"] = 43.96, ["Fly|Ride"] = 114.93, ["Neon"] = 145.28, ["Neon|Ride"] = 129.82, ["Neon|Fly|Ride"] = 259.88, ["Mega|Ride"] = 723.11, ["Mega|Fly|Ride"] = 800.63}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 13.01, ["Fly"] = 28.88, ["Ride"] = 25.86, ["Fly|Ride"] = 51.19, ["Neon"] = 146.5, ["Neon|Ride"] = 130.11, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 1312.5, ["Mega|Ride"] = 380.63, ["Mega|Fly|Ride"] = 1084.12}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 19.69, ["Ride"] = 35.43, ["Fly|Ride"] = 106.32, ["Neon"] = 118.13, ["Neon|Ride"] = 126.67, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 645.91, ["Mega|Ride"] = 525}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 4.26, ["Fly"] = 29.29, ["Ride"] = 22.32, ["Fly|Ride"] = 48.99, ["Neon"] = 40.68, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 129.31, ["Mega"] = 668.25, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 220.26}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 16.96, ["Ride"] = 52.48, ["Fly|Ride"] = 130.92, ["Neon"] = 156.58, ["Neon|Fly"] = 867.29, ["Neon|Ride"] = 234.18, ["Neon|Fly|Ride"] = 327.52, ["Mega"] = 630, ["Mega|Ride"] = 722.03}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 551.15, ["Fly"] = 577.5, ["Ride"] = 535.5, ["Fly|Ride"] = 590.63, ["Neon"] = 1864.67, ["Neon|Ride"] = 2100, ["Neon|Fly|Ride"] = 1575, ["Mega"] = 9187.5}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.31, ["Fly"] = 19.59, ["Ride"] = 17.04, ["Fly|Ride"] = 42, ["Neon"] = 20.79, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 70.88, ["Mega"] = 170.63, ["Mega|Ride"] = 229.85, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 44.35, ["Fly"] = 116.81, ["Ride"] = 80.07, ["Fly|Ride"] = 148.32, ["Neon"] = 206.07, ["Neon|Fly"] = 380.63, ["Neon|Ride"] = 222.29, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 563.07, ["Mega|Fly"] = 867.29, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 740.95, ["Ride"] = 807.19, ["Fly|Ride"] = 813.75, ["Neon|Ride"] = 2126.96, ["Neon|Fly|Ride"] = 1575, ["Mega|Fly|Ride"] = 4553.24}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 35.06, ["Fly"] = 72.65, ["Ride"] = 42.4, ["Fly|Ride"] = 85.32, ["Neon"] = 262.5, ["Neon|Fly"] = 249.38, ["Neon|Ride"] = 188.9, ["Neon|Fly|Ride"] = 251.99, ["Mega"] = 1308.81, ["Mega|Fly|Ride"] = 880.67}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 282.79, ["Fly"] = 329.04, ["Ride"] = 280.54, ["Fly|Ride"] = 315, ["Neon"] = 1626.16, ["Neon|Ride"] = 1408.25, ["Neon|Fly|Ride"] = 1084.12, ["Mega|Fly|Ride"] = 4481.68}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 244.4, ["Fly"] = 368, ["Ride"] = 262.49, ["Fly|Ride"] = 328.13, ["Neon"] = 892.5, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 918.75, ["Mega"] = 5043.24, ["Mega|Fly|Ride"] = 3902.77}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 656.25, ["Ride"] = 695.63, ["Fly|Ride"] = 701.67, ["Neon|Ride"] = 3615.48, ["Neon|Fly|Ride"] = 2296.88, ["Mega|Fly|Ride"] = 10550.47}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 17.07, ["Fly"] = 62.9, ["Ride"] = 45.92, ["Fly|Ride"] = 107.47, ["Neon"] = 80.06, ["Neon|Fly"] = 294.39, ["Neon|Ride"] = 80.07, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 262.5, ["Mega|Ride"] = 327.52, ["Mega|Fly|Ride"] = 439.69}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 3902.77, ["Fly"] = 3508.32, ["Ride"] = 3281.25, ["Fly|Ride"] = 3150, ["Neon|Fly|Ride"] = 7972.98, ["Mega|Fly|Ride"] = 18893.44}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 145.27, ["Fly"] = 160.47, ["Ride"] = 157.5, ["Fly|Ride"] = 210, ["Neon"] = 535.5, ["Neon|Fly"] = 593.01, ["Neon|Ride"] = 523.69, ["Neon|Fly|Ride"] = 511.88, ["Mega|Ride"] = 3208.95, ["Mega|Fly|Ride"] = 3245.81}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 26.03, ["Ride"] = 19.4, ["Fly|Ride"] = 46.64, ["Neon"] = 21, ["Neon|Fly"] = 99.74, ["Neon|Ride"] = 35.81, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 255.87, ["Mega|Fly"] = 446.25, ["Mega|Ride"] = 248.24, ["Mega|Fly|Ride"] = 232.02}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.94, ["Ride"] = 27.98, ["Fly|Ride"] = 59.07, ["Neon"] = 22.58, ["Neon|Fly"] = 120.23, ["Neon|Ride"] = 49.08, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 174.35, ["Mega|Ride"] = 260.21, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 31.49, ["Fly"] = 39.87, ["Ride"] = 34.13, ["Fly|Ride"] = 48.88, ["Neon"] = 294.39, ["Neon|Fly|Ride"] = 271.42, ["Mega|Fly|Ride"] = 1225.04}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 853.13, ["Fly"] = 1226.63, ["Ride"] = 892.5, ["Fly|Ride"] = 1038.19, ["Neon"] = 4228, ["Neon|Ride"] = 4581.41, ["Neon|Fly|Ride"] = 4799.32}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 8021.41, ["Fly|Ride"] = 6820.09}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 23.39, ["Fly"] = 39.38, ["Ride"] = 27.56, ["Fly|Ride"] = 52.5, ["Neon"] = 452.13, ["Neon|Ride"] = 139.13, ["Neon|Fly|Ride"] = 145.28, ["Mega"] = 2520, ["Mega|Ride"] = 867.22, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 12.97, ["Fly"] = 43.32, ["Ride"] = 31.17, ["Fly|Ride"] = 89.99, ["Neon"] = 102.38, ["Neon|Fly"] = 111.57, ["Neon|Ride"] = 77.35, ["Neon|Fly|Ride"] = 150.94, ["Mega"] = 668.87, ["Mega|Ride"] = 528.94, ["Mega|Fly|Ride"] = 501.38}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 111.57, ["Ride"] = 114.05, ["Fly|Ride"] = 164.38, ["Neon|Ride"] = 453.32, ["Neon|Fly|Ride"] = 577.5, ["Mega|Fly|Ride"] = 2601.86}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 196.88, ["Fly"] = 236.25, ["Ride"] = 223.13, ["Fly|Ride"] = 262.19, ["Neon"] = 932.34, ["Neon|Ride"] = 1182.93, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 10841, ["Mega|Fly|Ride"] = 4581.41}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 4.2, ["Ride"] = 34.8, ["Fly|Ride"] = 57.75, ["Neon"] = 27.46, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 125.9, ["Mega"] = 225.51, ["Mega|Fly"] = 241.78, ["Mega|Ride"] = 191.63, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 191.05, ["Fly"] = 232.03, ["Ride"] = 196.87, ["Fly|Ride"] = 262.5, ["Neon"] = 721.88, ["Neon|Ride"] = 715.32, ["Neon|Fly|Ride"] = 771.75, ["Mega|Fly|Ride"] = 3045}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 2.63, ["Fly"] = 19.69, ["Ride"] = 17.06, ["Fly|Ride"] = 44.91, ["Neon"] = 23.63, ["Neon|Fly"] = 130.11, ["Neon|Ride"] = 44.17, ["Neon|Fly|Ride"] = 124.29, ["Mega"] = 246.11, ["Mega|Ride"] = 202.74, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 199.49, ["Fly"] = 355.61, ["Ride"] = 273.2, ["Fly|Ride"] = 314.99, ["Neon|Ride"] = 1242.94, ["Neon|Fly|Ride"] = 1115.63, ["Mega"] = 10841, ["Mega|Fly|Ride"] = 4906.46}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 12.07, ["Fly"] = 104.98, ["Ride"] = 28.49, ["Fly|Ride"] = 68.25, ["Neon"] = 73.5, ["Neon|Fly"] = 311.57, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 578.92, ["Mega|Ride"] = 446.66, ["Mega|Fly|Ride"] = 622.3}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.1, ["Ride"] = 26.23, ["Fly|Ride"] = 98.15, ["Neon"] = 10.31, ["Neon|Fly"] = 170.46, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 195.57, ["Mega"] = 78.98, ["Mega|Ride"] = 136.13, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.61, ["Mega"] = 26.25, ["Mega|Ride"] = 145.28, ["Mega|Fly|Ride"] = 136.61}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Fly|Ride"] = 115.47, ["Neon"] = 7.22, ["Neon|Ride"] = 28.23, ["Neon|Fly|Ride"] = 131.22, ["Mega"] = 61.03, ["Mega|Fly"] = 191720.66, ["Mega|Ride"] = 91.27, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 73.5, ["Fly"] = 131.27, ["Ride"] = 97.75, ["Fly|Ride"] = 166.69, ["Neon"] = 288.75, ["Neon|Ride"] = 308.44, ["Neon|Fly|Ride"] = 393.68, ["Mega|Fly|Ride"] = 1624}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 38.05, ["Ride"] = 16.55, ["Fly|Ride"] = 84.57, ["Neon"] = 5.25, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 49.88, ["Mega"] = 91.88, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 7.31, ["Ride"] = 147.46, ["Neon"] = 72.65, ["Neon|Fly"] = 327.52, ["Neon|Ride"] = 212.63, ["Neon|Fly|Ride"] = 360.94, ["Mega"] = 262.5, ["Mega|Ride"] = 576.76, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Neon"] = 2.5, ["Neon|Ride"] = 56.42, ["Neon|Fly|Ride"] = 137.7, ["Mega"] = 17.06, ["Mega|Ride"] = 56.1}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 72.63, ["Ride"] = 16.28, ["Fly|Ride"] = 49.88, ["Neon"] = 2.1, ["Neon|Fly"] = 40.67, ["Neon|Ride"] = 12.84, ["Neon|Fly|Ride"] = 32.82, ["Mega"] = 14.43, ["Mega|Fly"] = 36.17, ["Mega|Ride"] = 18.04, ["Mega|Fly|Ride"] = 48.57}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 29.29, ["Ride"] = 16.05, ["Fly|Ride"] = 39.38, ["Neon"] = 2.1, ["Neon|Fly"] = 19.69, ["Neon|Ride"] = 14.73, ["Neon|Fly|Ride"] = 39.9, ["Mega"] = 19.69, ["Mega|Fly"] = 164.38, ["Mega|Ride"] = 32.39, ["Mega|Fly|Ride"] = 89.24}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Neon"] = 2.24, ["Mega"] = 18.38, ["Mega|Ride"] = 131.27, ["Mega|Fly|Ride"] = 433.65}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 32.54, ["Ride"] = 21, ["Fly|Ride"] = 49.88, ["Neon"] = 3.26, ["Neon|Fly"] = 123.6, ["Neon|Ride"] = 24.93, ["Neon|Fly|Ride"] = 91.87, ["Mega"] = 41.39, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 42, ["Mega|Fly|Ride"] = 143.73}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 28.21, ["Neon|Fly|Ride"] = 433.65, ["Mega"] = 18.05, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 216.84}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 8.12, ["Fly"] = 77.44, ["Ride"] = 65.61, ["Fly|Ride"] = 151.46, ["Neon"] = 32.82, ["Neon|Fly"] = 133.29, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 161.34, ["Mega"] = 164.07, ["Mega|Fly"] = 401.12, ["Mega|Ride"] = 169.32, ["Mega|Fly|Ride"] = 282.18}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 2.1, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 27, ["Neon|Fly|Ride"] = 326.92, ["Mega"] = 22.04, ["Mega|Fly"] = 144.38, ["Mega|Ride"] = 130.72, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 26.25, ["Fly|Ride"] = 52.5, ["Neon"] = 19.57, ["Mega"] = 105, ["Mega|Fly"] = 315, ["Mega|Ride"] = 274.31, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 3.7, ["Ride"] = 26.24, ["Neon"] = 20.9, ["Mega"] = 131.25, ["Mega|Ride"] = 160.47, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Fly"] = 145.28, ["Ride"] = 32.81, ["Neon"] = 2.62, ["Neon|Ride"] = 27.13, ["Neon|Fly|Ride"] = 145.28, ["Mega"] = 22.28, ["Mega|Ride"] = 44.63}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.61, ["Ride"] = 13.13, ["Fly|Ride"] = 38.07, ["Neon"] = 2.1, ["Neon|Fly"] = 29.45, ["Neon|Ride"] = 12.99, ["Neon|Fly|Ride"] = 21, ["Mega"] = 14.31, ["Mega|Fly"] = 33.11, ["Mega|Ride"] = 20.89, ["Mega|Fly|Ride"] = 51.18}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 3.7, ["Fly"] = 72.19, ["Ride"] = 54.28, ["Fly|Ride"] = 118.11, ["Neon"] = 34.92, ["Neon|Ride"] = 72.65, ["Mega"] = 183.74, ["Mega|Ride"] = 241.5}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 32.81, ["Neon"] = 4.35, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 36.69, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 22.23, ["Mega|Ride"] = 60.38, ["Mega|Fly|Ride"] = 111.57}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 2.1, ["Neon"] = 15.75, ["Mega"] = 101.07, ["Mega|Ride"] = 173.46, ["Mega|Fly|Ride"] = 311.06}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.1, ["Fly"] = 79.73, ["Ride"] = 28.87, ["Fly|Ride"] = 45.94, ["Neon"] = 16.28, ["Neon|Ride"] = 50.96, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 131.25, ["Mega|Ride"] = 163.41, ["Mega|Fly|Ride"] = 196.87}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 36.16, ["Ride"] = 16.28, ["Fly|Ride"] = 31.49, ["Neon"] = 2.1, ["Neon|Fly"] = 19.69, ["Neon|Ride"] = 13.97, ["Neon|Fly|Ride"] = 31.07, ["Mega"] = 25.88, ["Mega|Fly"] = 27.59, ["Mega|Ride"] = 20.58, ["Mega|Fly|Ride"] = 47.24}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 29.25, ["Ride"] = 27.42, ["Fly|Ride"] = 144.38, ["Neon"] = 12.96, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 196.56, ["Mega"] = 129.65, ["Mega|Ride"] = 160.78, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 2.1, ["Ride"] = 24.54, ["Fly|Ride"] = 59.07, ["Neon"] = 64.32, ["Neon|Ride"] = 72.3, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 291.38, ["Mega|Ride"] = 297.51, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 58.56, ["Ride"] = 14.41, ["Fly|Ride"] = 41.3, ["Neon"] = 2.5, ["Neon|Fly"] = 19.69, ["Neon|Ride"] = 15.96, ["Neon|Fly|Ride"] = 40.63, ["Mega"] = 21, ["Mega|Fly"] = 50.96, ["Mega|Ride"] = 28.88}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.63, ["Fly"] = 181.07, ["Ride"] = 45.91, ["Neon"] = 6.49, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 150.94, ["Mega"] = 51.19, ["Mega|Fly"] = 173.46, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 262.48}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Fly"] = 28.35, ["Ride"] = 35.44, ["Fly|Ride"] = 131.25, ["Neon"] = 3.6, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 289.47, ["Mega"] = 28.87, ["Mega|Fly"] = 115.76, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 33.13, ["Ride"] = 27.57, ["Neon"] = 2.1, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 289.47, ["Mega"] = 14.43, ["Mega|Fly"] = 253.82, ["Mega|Ride"] = 45.93, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 23.87, ["Ride"] = 19.46, ["Fly|Ride"] = 52.64, ["Neon"] = 5.25, ["Neon|Fly"] = 58.3, ["Neon|Ride"] = 33.32, ["Neon|Fly|Ride"] = 74.81, ["Mega"] = 105.23, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 22.6, ["Neon"] = 5.81, ["Neon|Ride"] = 58.11, ["Mega"] = 45.94, ["Mega|Fly"] = 327.52, ["Mega|Ride"] = 114.19, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 19.5, ["Ride"] = 17.09, ["Fly|Ride"] = 43.37, ["Neon"] = 3.92, ["Neon|Fly"] = 82.21, ["Neon|Ride"] = 25.93, ["Neon|Fly|Ride"] = 83.98, ["Mega"] = 114.19, ["Mega|Fly"] = 115.77, ["Mega|Ride"] = 76.62}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 3.41, ["Ride"] = 37.03, ["Neon"] = 30.12, ["Neon|Fly"] = 188.88, ["Neon|Fly|Ride"] = 325.25, ["Mega"] = 104.74, ["Mega|Fly"] = 367.5, ["Mega|Ride"] = 232.02}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Fly"] = 25.77, ["Ride"] = 15.75, ["Fly|Ride"] = 47.23, ["Neon"] = 11.67, ["Neon|Fly"] = 49.08, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 89.98, ["Mega"] = 124.68, ["Mega|Fly"] = 420, ["Mega|Ride"] = 145.15, ["Mega|Fly|Ride"] = 187.04}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 5.2, ["Fly"] = 14.33, ["Ride"] = 17.07, ["Fly|Ride"] = 64.75, ["Neon"] = 12.76, ["Neon|Fly"] = 68.32, ["Neon|Ride"] = 29.69, ["Neon|Fly|Ride"] = 73.5, ["Mega"] = 105, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 131.25}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 114.84, ["Ride"] = 65.63, ["Neon"] = 10.85, ["Neon|Ride"] = 87.1, ["Neon|Fly|Ride"] = 2625, ["Mega"] = 257.28, ["Mega|Ride"] = 323.08}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 5.1, ["Ride"] = 65.63, ["Neon"] = 72.33, ["Neon|Ride"] = 170.63, ["Mega"] = 675.42, ["Mega|Ride"] = 728.44, ["Mega|Fly|Ride"] = 981.31}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 2.1, ["Ride"] = 40.68, ["Neon"] = 44.62, ["Neon|Ride"] = 108.32, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 221.82, ["Mega|Ride"] = 367.5}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 3.91, ["Ride"] = 45.94, ["Fly|Ride"] = 130.11, ["Neon"] = 47.78, ["Neon|Ride"] = 66.94, ["Neon|Fly|Ride"] = 127.29, ["Mega"] = 225.66, ["Mega|Ride"] = 411.97, ["Mega|Fly|Ride"] = 446.92}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.88, ["Neon|Ride"] = 52.5, ["Mega"] = 17.8, ["Mega|Fly"] = 124.68, ["Mega|Ride"] = 58.56, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 48.06}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 6.36, ["Fly"] = 21, ["Ride"] = 22.31, ["Fly|Ride"] = 45.94, ["Neon"] = 37.97, ["Neon|Fly"] = 187.7, ["Neon|Ride"] = 43.38, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 362.11, ["Mega|Ride"] = 208.68, ["Mega|Fly|Ride"] = 260.21}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 19.53, ["Neon"] = 3.81, ["Neon|Fly"] = 52.8, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 118.02, ["Mega"] = 24.94, ["Mega|Fly"] = 145.28, ["Mega|Ride"] = 72.19, ["Mega|Fly|Ride"] = 129.42}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 26.17, ["Neon"] = 3.84, ["Neon|Ride"] = 30.17, ["Neon|Fly|Ride"] = 72.18, ["Mega"] = 31.5, ["Mega|Ride"] = 56.46, ["Mega|Fly|Ride"] = 135.19}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 45.18, ["Ride"] = 13.13, ["Fly|Ride"] = 45.27, ["Neon"] = 11.46, ["Neon|Ride"] = 51.45, ["Neon|Fly|Ride"] = 65.45, ["Mega"] = 162.64, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 3.68, ["Fly"] = 43.38, ["Ride"] = 21.7, ["Fly|Ride"] = 78.75, ["Neon"] = 37.3, ["Neon|Ride"] = 208.14, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 328.13, ["Mega|Ride"] = 345.45}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Ride"] = 34.12, ["Neon"] = 3.42, ["Neon|Ride"] = 39.9, ["Neon|Fly|Ride"] = 103.01, ["Mega"] = 23.62, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 53.7, ["Mega|Fly|Ride"] = 145.28}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 27.6, ["Ride"] = 22.2, ["Fly|Ride"] = 59.06, ["Neon"] = 3.84, ["Neon|Fly"] = 114.93, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 90.57, ["Mega"] = 31.4, ["Mega|Fly"] = 136.5, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 138.77}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 29.29, ["Ride"] = 18.3, ["Fly|Ride"] = 27.57, ["Neon"] = 4.38, ["Neon|Fly"] = 54.23, ["Neon|Ride"] = 19.2, ["Neon|Fly|Ride"] = 61.31, ["Mega"] = 84.57, ["Mega|Fly"] = 145.28, ["Mega|Ride"] = 115.99, ["Mega|Fly|Ride"] = 120.35}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 91.88, ["Ride"] = 55.13, ["Fly|Ride"] = 145.28, ["Neon"] = 8.67, ["Neon|Ride"] = 64.31, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 72.19, ["Mega|Ride"] = 130.11, ["Mega|Fly|Ride"] = 287.44}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 2.1, ["Neon|Ride"] = 39.29, ["Neon|Fly|Ride"] = 157986.14, ["Mega"] = 19.68, ["Mega|Fly"] = 114.93, ["Mega|Ride"] = 86.99, ["Mega|Fly|Ride"] = 131.14}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 45.91, ["Ride"] = 15.75, ["Fly|Ride"] = 51.19, ["Neon"] = 2.25, ["Neon|Fly"] = 28.23, ["Neon|Ride"] = 24.19, ["Neon|Fly|Ride"] = 90.62, ["Mega"] = 18.37, ["Mega|Fly"] = 72.59, ["Mega|Ride"] = 36.75}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Neon"] = 3.25, ["Mega"] = 14.17, ["Mega|Ride"] = 129.94}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.76, ["Neon|Fly|Ride"] = 420, ["Mega"] = 27.3, ["Mega|Ride"] = 199.48, ["Mega|Fly|Ride"] = 147.2}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 14.44, ["Fly|Ride"] = 68.25, ["Neon"] = 3.72, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 17.75, ["Neon|Fly|Ride"] = 48.38, ["Mega"] = 38.06, ["Mega|Ride"] = 72.65, ["Mega|Fly|Ride"] = 76.67}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 9, ["Ride"] = 78.75, ["Fly|Ride"] = 216.84, ["Neon"] = 78.75, ["Neon|Ride"] = 188.65, ["Mega"] = 389.81, ["Mega|Ride"] = 483.53}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.1, ["Fly"] = 6562.5, ["Ride"] = 26.24, ["Neon"] = 25.22, ["Neon|Ride"] = 157.5, ["Mega"] = 245.34, ["Mega|Fly|Ride"] = 629.99}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 2.1, ["Fly"] = 29.29, ["Ride"] = 33.12, ["Fly|Ride"] = 47.25, ["Neon"] = 22.96, ["Neon|Fly|Ride"] = 289.47, ["Mega"] = 325.25, ["Mega|Ride"] = 298.14, ["Mega|Fly|Ride"] = 388.4}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 14.2, ["Ride"] = 11.71, ["Fly|Ride"] = 25.26, ["Neon"] = 2.1, ["Neon|Fly"] = 19.36, ["Neon|Ride"] = 11.82, ["Neon|Fly|Ride"] = 31.18, ["Mega"] = 14.44, ["Mega|Fly"] = 104.98, ["Mega|Ride"] = 21.67, ["Mega|Fly|Ride"] = 48.57}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Fly"] = 118.12, ["Ride"] = 60.73, ["Neon"] = 8.69, ["Neon|Fly"] = 68.59, ["Neon|Ride"] = 32.54, ["Neon|Fly|Ride"] = 723.11, ["Mega"] = 118.12, ["Mega|Ride"] = 145.28}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Fly"] = 72.65, ["Ride"] = 44.17, ["Neon"] = 2.1, ["Neon|Fly"] = 32.36, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 86.67, ["Mega"] = 14.26, ["Mega|Fly"] = 145.28, ["Mega|Fly|Ride"] = 181.07}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 3.68, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 127.32, ["Mega"] = 18.35, ["Mega|Fly"] = 216.84, ["Mega|Fly|Ride"] = 367.49}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 144.56, ["Ride"] = 18.88, ["Fly|Ride"] = 40.69, ["Neon"] = 9.08, ["Neon|Fly"] = 66.05, ["Neon|Ride"] = 39.04, ["Neon|Fly|Ride"] = 78.66, ["Mega"] = 173.25, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 245.34}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 180.06, ["Ride"] = 236.24, ["Fly|Ride"] = 798.44, ["Neon|Ride"] = 932.24, ["Neon|Fly|Ride"] = 955.54, ["Mega"] = 8672.81}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Ride"] = 28.21, ["Neon"] = 7.96, ["Neon|Ride"] = 64.31, ["Mega"] = 65.63, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 2.62, ["Fly"] = 103.68, ["Ride"] = 24.69, ["Fly|Ride"] = 65.63, ["Neon"] = 42.29, ["Neon|Ride"] = 80.24, ["Neon|Fly|Ride"] = 173.46, ["Mega"] = 385.88, ["Mega|Ride"] = 229.39, ["Mega|Fly|Ride"] = 653.84}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 14.73, ["Fly|Ride"] = 32.7, ["Neon"] = 7.88, ["Neon|Fly"] = 33.63, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 57.75, ["Mega"] = 49.67, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 132.28}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 72.65, ["Ride"] = 19.69, ["Fly|Ride"] = 131.15, ["Neon"] = 8.81, ["Neon|Ride"] = 80.07, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 77.44, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 2.88, ["Fly"] = 27.96, ["Ride"] = 16.76, ["Fly|Ride"] = 38.72, ["Neon"] = 31.5, ["Neon|Fly"] = 101.25, ["Neon|Ride"] = 43.31, ["Neon|Fly|Ride"] = 84.9, ["Mega|Ride"] = 867.29}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 2.1, ["Ride"] = 34.7, ["Fly|Ride"] = 82.21, ["Neon"] = 50.13, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 257.25, ["Mega|Ride"] = 319.82, ["Mega|Fly|Ride"] = 387.18}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.48, ["Fly"] = 19.67, ["Ride"] = 16.7, ["Fly|Ride"] = 34.13, ["Neon"] = 38.05, ["Neon|Fly"] = 95.16, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 262.5, ["Mega|Ride"] = 376.2, ["Mega|Fly|Ride"] = 282.7}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 48.57, ["Ride"] = 90.96, ["Fly|Ride"] = 144.38, ["Neon"] = 289.47, ["Neon|Fly"] = 450.19, ["Neon|Ride"] = 429.33, ["Neon|Fly|Ride"] = 365.97, ["Mega|Fly|Ride"] = 1378.13}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 247.17, ["Fly"] = 433.65, ["Ride"] = 232.32, ["Fly|Ride"] = 223.13, ["Neon|Ride"] = 1128.75, ["Neon|Fly|Ride"] = 1115.63, ["Mega"] = 10841}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 59.81, ["Fly"] = 108.43, ["Ride"] = 81.33, ["Fly|Ride"] = 119.77, ["Neon"] = 490.67, ["Neon|Fly"] = 367.53, ["Neon|Ride"] = 293.29, ["Neon|Fly|Ride"] = 346.92, ["Mega|Fly|Ride"] = 1842.99}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 5.19, ["Fly"] = 288.2, ["Ride"] = 28, ["Neon"] = 43.21, ["Neon|Fly"] = 101.2, ["Neon|Ride"] = 99.31, ["Mega"] = 262.5, ["Mega|Ride"] = 190.32, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 9.17, ["Fly"] = 72.65, ["Ride"] = 33.63, ["Fly|Ride"] = 65.63, ["Neon"] = 62.99, ["Neon|Ride"] = 81.33, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 301.77, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 513.87}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 34.52, ["Ride"] = 13.13, ["Fly|Ride"] = 49.69, ["Neon"] = 2.1, ["Neon|Ride"] = 20.14, ["Neon|Fly|Ride"] = 75.9, ["Mega"] = 36.75, ["Mega|Fly"] = 149.67, ["Mega|Ride"] = 94.5, ["Mega|Fly|Ride"] = 547.08}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 7.61, ["Fly"] = 69.39, ["Ride"] = 24.94, ["Fly|Ride"] = 66.05, ["Neon"] = 98.79, ["Neon|Fly"] = 289.47, ["Neon|Ride"] = 114.19, ["Neon|Fly|Ride"] = 273.2, ["Mega"] = 520.38, ["Mega|Ride"] = 506.29, ["Mega|Fly|Ride"] = 732.38}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 42, ["Ride"] = 15.74, ["Fly|Ride"] = 45.38, ["Neon"] = 16.11, ["Neon|Fly"] = 82.21, ["Neon|Ride"] = 26.56, ["Neon|Fly|Ride"] = 85.77, ["Mega"] = 144.22, ["Mega|Ride"] = 164.38, ["Mega|Fly|Ride"] = 290.07}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 3.35, ["Ride"] = 27.98, ["Fly|Ride"] = 328.13, ["Neon"] = 44.63, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 204.86, ["Mega"] = 207.38, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 310.55}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 27.68, ["Ride"] = 19.36, ["Neon"] = 2.52, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 19.53, ["Neon|Fly|Ride"] = 57.74, ["Mega"] = 15.75, ["Mega|Ride"] = 43.38, ["Mega|Fly|Ride"] = 78.74}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 24.82, ["Ride"] = 19.08, ["Fly|Ride"] = 43.38, ["Neon"] = 25.47, ["Neon|Fly"] = 108.43, ["Neon|Ride"] = 36.82, ["Neon|Fly|Ride"] = 139.85, ["Mega"] = 78.72, ["Mega|Ride"] = 86.75, ["Mega|Fly|Ride"] = 226.42}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.1, ["Fly"] = 55.13, ["Ride"] = 19.09, ["Fly|Ride"] = 71.11, ["Neon"] = 21.88, ["Neon|Ride"] = 47.25, ["Mega"] = 131.25, ["Mega|Ride"] = 266.44, ["Mega|Fly|Ride"] = 266.72}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 105, ["Fly"] = 164.12, ["Ride"] = 144.38, ["Fly|Ride"] = 215.44, ["Neon"] = 430.39, ["Neon|Ride"] = 463.08, ["Neon|Fly|Ride"] = 550.93, ["Mega"] = 3925.17, ["Mega|Fly|Ride"] = 3093.57}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 10.13, ["Ride"] = 130.11, ["Fly|Ride"] = 131.25, ["Neon"] = 47.67, ["Neon|Ride"] = 98.42, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 280.88, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 376.82}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 43.32, ["Ride"] = 19.69, ["Fly|Ride"] = 41.72, ["Neon"] = 21, ["Neon|Ride"] = 60.38, ["Neon|Fly|Ride"] = 118.65, ["Mega"] = 203.44, ["Mega|Ride"] = 185.8, ["Mega|Fly|Ride"] = 320.25}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 21.91, ["Ride"] = 28.88, ["Fly|Ride"] = 159.01, ["Neon"] = 72.6, ["Neon|Ride"] = 161.34, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 433.65, ["Mega|Fly"] = 867.29, ["Mega|Ride"] = 679.74, ["Mega|Fly|Ride"] = 834.11}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 3.82}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 2.41, ["Ride"] = 45.94, ["Fly|Ride"] = 129.02, ["Neon"] = 31.5, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 248.07, ["Mega|Ride"] = 490.67, ["Mega|Fly|Ride"] = 865.56}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 21, ["Fly"] = 36.75, ["Ride"] = 27.26, ["Fly|Ride"] = 57.75, ["Neon"] = 89.25, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 145.28, ["Neon|Fly|Ride"] = 150.9, ["Mega"] = 1399.59, ["Mega|Fly|Ride"] = 578.12}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.49, ["Fly|Ride"] = 52.39, ["Neon"] = 3.93, ["Neon|Ride"] = 43.22, ["Neon|Fly|Ride"] = 137.7, ["Mega"] = 49.88, ["Mega|Ride"] = 87.94, ["Mega|Fly|Ride"] = 232.83}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 4.35, ["Fly"] = 15.74, ["Ride"] = 21.15, ["Fly|Ride"] = 65.54, ["Neon"] = 58.56, ["Mega"] = 288.33, ["Mega|Fly"] = 409.7, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 578.92}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 28.96, ["Ride"] = 21, ["Fly|Ride"] = 48.56, ["Neon"] = 11.82, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 37.97, ["Neon|Fly|Ride"] = 74.34, ["Mega"] = 183.75, ["Mega|Ride"] = 221.15, ["Mega|Fly|Ride"] = 168.92}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 39.37, ["Neon"] = 3.59, ["Neon|Fly"] = 275.38, ["Neon|Ride"] = 41.72, ["Mega"] = 31.19, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 23.63, ["Ride"] = 86.05, ["Fly|Ride"] = 130.11, ["Neon"] = 163.02, ["Neon|Ride"] = 204.86, ["Neon|Fly|Ride"] = 576.19, ["Mega"] = 838.69, ["Mega|Ride"] = 689.06, ["Mega|Fly|Ride"] = 759.06}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.18, ["Fly"] = 29.29, ["Ride"] = 48.56, ["Fly|Ride"] = 157.5, ["Neon"] = 93.94, ["Mega|Ride"] = 325.25, ["Mega|Fly|Ride"] = 327.52}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 3.94, ["Fly"] = 22.32, ["Ride"] = 21.25, ["Fly|Ride"] = 63.66, ["Neon"] = 15.89, ["Neon|Fly"] = 86.75, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 120.75, ["Mega|Ride"] = 164.38, ["Mega|Fly|Ride"] = 612.94}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 78.75, ["Fly"] = 433.12, ["Ride"] = 130.11, ["Neon"] = 580, ["Neon|Ride"] = 590.63, ["Neon|Fly|Ride"] = 534.87, ["Mega"] = 4581.41, ["Mega|Fly|Ride"] = 2887.5}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 6.44, ["Fly"] = 45.85, ["Ride"] = 23.86, ["Fly|Ride"] = 71.15, ["Neon"] = 30.75, ["Neon|Ride"] = 48.57, ["Neon|Fly|Ride"] = 119.44, ["Mega"] = 239.65, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 361.87}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 65.63, ["Fly"] = 131.24, ["Ride"] = 72.65, ["Fly|Ride"] = 206.07, ["Neon"] = 241.83, ["Neon|Ride"] = 205.68, ["Neon|Fly|Ride"] = 348.49, ["Mega"] = 1018.5, ["Mega|Ride"] = 1080.86, ["Mega|Fly|Ride"] = 1093.32}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 16.77, ["Ride"] = 60.38, ["Fly|Ride"] = 169.32, ["Neon"] = 137.7, ["Neon|Ride"] = 109.8, ["Neon|Fly|Ride"] = 210, ["Mega"] = 353.06, ["Mega|Ride"] = 376.89, ["Mega|Fly|Ride"] = 439.69}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 16.11, ["Fly"] = 39.38, ["Ride"] = 26.03, ["Fly|Ride"] = 72.42, ["Neon"] = 98.44, ["Neon|Fly|Ride"] = 390.08, ["Mega"] = 572.84, ["Mega|Ride"] = 576.76, ["Mega|Fly|Ride"] = 622.3}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 14.34, ["Fly"] = 100.59, ["Ride"] = 65.63, ["Fly|Ride"] = 83.15, ["Neon"] = 57.74, ["Neon|Ride"] = 117, ["Neon|Fly|Ride"] = 237.05, ["Mega"] = 346.92, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 399.16}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 8.82, ["Fly"] = 65.63, ["Ride"] = 30.18, ["Neon"] = 40.69, ["Neon|Ride"] = 57.75, ["Neon|Fly|Ride"] = 138.77, ["Mega"] = 276.84, ["Mega|Ride"] = 289.47, ["Mega|Fly|Ride"] = 449.98}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.62, ["Neon|Fly"] = 94.68, ["Neon|Ride"] = 179.97, ["Mega"] = 17.07, ["Mega|Ride"] = 86.75, ["Mega|Fly|Ride"] = 578.92}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 5.11, ["Ride"] = 127.34, ["Neon"] = 36.28, ["Neon|Ride"] = 208.16, ["Neon|Fly|Ride"] = 201.54, ["Mega"] = 238.88, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 737.2}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Fly"] = 129.02, ["Ride"] = 29.29, ["Neon"] = 28.88, ["Neon|Fly"] = 116.94, ["Neon|Ride"] = 101.92, ["Neon|Fly|Ride"] = 214.67, ["Mega"] = 211.97, ["Mega|Ride"] = 422.82, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 3.71, ["Ride"] = 32.8, ["Fly|Ride"] = 122.68, ["Neon"] = 15.88, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 127.95, ["Mega|Ride"] = 289.47, ["Mega|Fly|Ride"] = 517.13}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 472.14, ["Fly"] = 709.02, ["Ride"] = 577.5, ["Fly|Ride"] = 656.24, ["Neon"] = 2096.67, ["Neon|Ride"] = 1771.88, ["Neon|Fly|Ride"] = 1601.49, ["Mega|Fly|Ride"] = 5085.94}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 6.48, ["Fly"] = 45.47, ["Ride"] = 23.3, ["Fly|Ride"] = 60.51, ["Neon"] = 42.3, ["Neon|Ride"] = 58.56, ["Neon|Fly|Ride"] = 319.93, ["Mega"] = 202.74, ["Mega|Ride"] = 376.58, ["Mega|Fly|Ride"] = 359.94}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 7.85, ["Fly"] = 66.94, ["Ride"] = 20.94, ["Fly|Ride"] = 54.1, ["Neon"] = 95.25, ["Neon|Fly"] = 315, ["Neon|Ride"] = 94.33, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 331.87, ["Mega|Ride"] = 288.39, ["Mega|Fly|Ride"] = 681.45}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 2.1, ["Fly"] = 24.93, ["Ride"] = 17.06, ["Fly|Ride"] = 50.3, ["Neon"] = 13.12, ["Neon|Ride"] = 41.99, ["Neon|Fly|Ride"] = 131.25}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 43.19, ["Ride"] = 32.82, ["Fly|Ride"] = 65.63, ["Neon"] = 11.9, ["Neon|Ride"] = 33.13, ["Neon|Fly|Ride"] = 123.38, ["Mega"] = 71.56, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 2.63, ["Neon|Ride"] = 24.54, ["Neon|Fly|Ride"] = 116.02, ["Mega"] = 21.69, ["Mega|Fly"] = 202.74, ["Mega|Ride"] = 73.5, ["Mega|Fly|Ride"] = 232.02}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1246.88}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 7.8, ["Ride"] = 52.5, ["Fly|Ride"] = 182.44, ["Neon"] = 69.21, ["Neon|Ride"] = 112.87, ["Mega"] = 409.7, ["Mega|Ride"] = 376.2}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 19.26, ["Neon"] = 6.02, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 1007.55, ["Mega"] = 39.38, ["Mega|Ride"] = 127.65, ["Mega|Fly|Ride"] = 182.44}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.63, ["Fly"] = 325.18, ["Ride"] = 72.37, ["Neon"] = 31.45, ["Neon|Ride"] = 170.52, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 261.37, ["Mega|Ride"] = 357.77, ["Mega|Fly|Ride"] = 1084.12}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 407.51, ["Ride"] = 446.24, ["Fly|Ride"] = 514.48, ["Neon"] = 1692.73, ["Neon|Ride"] = 1709.92, ["Neon|Fly|Ride"] = 1365, ["Mega"] = 8130.76, ["Mega|Fly|Ride"] = 6070.97}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 4.87, ["Fly"] = 196.88, ["Ride"] = 58.56, ["Fly|Ride"] = 130.11, ["Neon"] = 58.56, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 196.28, ["Mega"] = 306.57, ["Mega|Ride"] = 497.62, ["Mega|Fly|Ride"] = 518.22}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Fly"] = 95.69, ["Ride"] = 32.8, ["Fly|Ride"] = 118.11, ["Neon"] = 3.61, ["Neon|Fly"] = 52.49, ["Neon|Ride"] = 39.9, ["Neon|Fly|Ride"] = 86.65, ["Mega"] = 39.29, ["Mega|Fly"] = 145.2, ["Mega|Ride"] = 82.41, ["Mega|Fly|Ride"] = 205.59}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 3.94, ["Neon|Ride"] = 144.45, ["Neon|Fly|Ride"] = 144.89, ["Mega"] = 26.25, ["Mega|Ride"] = 65.54, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 25.9, ["Fly"] = 107.91, ["Ride"] = 81.15, ["Fly|Ride"] = 325.25, ["Neon"] = 144.38, ["Neon|Ride"] = 229.69, ["Neon|Fly|Ride"] = 437.07, ["Mega"] = 685.17, ["Mega|Ride"] = 709.02}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 7.88, ["Ride"] = 82.21, ["Neon"] = 1446.21, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 867.29, ["Mega"] = 572.84, ["Mega|Ride"] = 485.63, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 4.79, ["Ride"] = 76.13, ["Neon"] = 120.75, ["Neon|Ride"] = 173.46, ["Mega"] = 663.48, ["Mega|Ride"] = 650.48, ["Mega|Fly|Ride"] = 818.16}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 17.07, ["Ride"] = 27.56, ["Fly|Ride"] = 217.84, ["Neon"] = 167.37, ["Neon|Ride"] = 163.66, ["Neon|Fly|Ride"] = 241.5, ["Mega"] = 643.13, ["Mega|Ride"] = 780.56, ["Mega|Fly|Ride"] = 607.19}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 413.44, ["Ride"] = 427.32, ["Fly|Ride"] = 719.86, ["Neon"] = 1069.69, ["Neon|Ride"] = 1050, ["Neon|Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 3346.87}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 5.24, ["Fly"] = 41.89, ["Ride"] = 34.13, ["Fly|Ride"] = 115.91, ["Neon"] = 148.32, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 143.94, ["Mega|Fly"] = 590.63, ["Mega|Ride"] = 561.1, ["Mega|Fly|Ride"] = 867.29}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 2.1, ["Ride"] = 32.54, ["Fly|Ride"] = 127.32, ["Neon"] = 52.5, ["Neon|Ride"] = 221.82, ["Mega"] = 170.63, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 629.99}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 32.82, ["Fly"] = 346.92, ["Ride"] = 118.13, ["Fly|Ride"] = 233.63, ["Neon"] = 150.94, ["Neon|Ride"] = 196.64, ["Neon|Fly|Ride"] = 490.53, ["Mega"] = 393.75, ["Mega|Ride"] = 432.2, ["Mega|Fly|Ride"] = 511.86}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.62, ["Fly"] = 32.82, ["Ride"] = 43.38, ["Fly|Ride"] = 216.84, ["Neon"] = 7.61, ["Neon|Ride"] = 69.57, ["Neon|Fly|Ride"] = 280.81, ["Mega"] = 65.63, ["Mega|Ride"] = 173.46, ["Mega|Fly|Ride"] = 281.06}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 49.07, ["Ride"] = 78.85, ["Neon"] = 262.5, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 1655.94, ["Mega|Ride"] = 1590.39, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 56.44, ["Ride"] = 26.23, ["Fly|Ride"] = 101.92, ["Neon"] = 12.12, ["Neon|Fly"] = 188.65, ["Neon|Ride"] = 58.56, ["Neon|Fly|Ride"] = 147.2, ["Mega"] = 62.91, ["Mega|Ride"] = 90.82, ["Mega|Fly|Ride"] = 198.5}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 29.29, ["Ride"] = 28.88, ["Fly|Ride"] = 100.59, ["Neon"] = 3.82, ["Neon|Fly"] = 63.55, ["Neon|Ride"] = 46.64, ["Neon|Fly|Ride"] = 137.7, ["Mega"] = 37.52, ["Mega|Fly"] = 112.88, ["Mega|Ride"] = 86.75, ["Mega|Fly|Ride"] = 245.34}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Ride"] = 37.97, ["Fly|Ride"] = 131.07, ["Neon"] = 11.69, ["Neon|Ride"] = 53.95, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 83.46, ["Mega|Ride"] = 140.95, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 52.71, ["Fly"] = 65.62, ["Ride"] = 61.58, ["Fly|Ride"] = 247.19, ["Neon"] = 245.97, ["Neon|Ride"] = 437.07, ["Neon|Fly|Ride"] = 490.67, ["Mega|Ride"] = 1156.75}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 2167.95}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 9.19, ["Neon"] = 22.32, ["Neon|Fly"] = 350.44, ["Mega"] = 124.69, ["Mega|Ride"] = 246.11}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.1, ["Ride"] = 19.62, ["Neon"] = 9.19, ["Neon|Ride"] = 72.19, ["Mega"] = 47.24, ["Mega|Fly"] = 210, ["Mega|Ride"] = 91.88}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 2.52, ["Fly"] = 108.43, ["Ride"] = 32.82, ["Fly|Ride"] = 98.44, ["Neon"] = 32.82, ["Mega"] = 262.5, ["Mega|Ride"] = 351.56, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 6.48, ["Ride"] = 42.72, ["Fly|Ride"] = 299.64, ["Neon"] = 30.19, ["Neon|Ride"] = 65.62, ["Neon|Fly|Ride"] = 143.07, ["Mega"] = 174.96, ["Mega|Ride"] = 195.66, ["Mega|Fly|Ride"] = 353.48}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 71.6, ["Neon"] = 11, ["Neon|Ride"] = 94.33, ["Neon|Fly|Ride"] = 145.28, ["Mega"] = 76.13, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 870.55}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 19.69, ["Fly|Ride"] = 52.5, ["Neon"] = 4.6, ["Neon|Ride"] = 28.77, ["Neon|Fly|Ride"] = 99.8, ["Mega"] = 41.99, ["Mega|Ride"] = 99.68}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 27.51, ["Ride"] = 20.09, ["Fly|Ride"] = 57.74, ["Neon"] = 17.85, ["Neon|Fly"] = 103.01, ["Neon|Ride"] = 40.68, ["Neon|Fly|Ride"] = 108.43, ["Mega"] = 156.16, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 728.44}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 36.75, ["Ride"] = 27.02, ["Fly|Ride"] = 78.75, ["Neon"] = 144.35, ["Neon|Ride"] = 164.07, ["Mega"] = 459.38, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 654.01}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 58.62, ["Ride"] = 73.49, ["Fly|Ride"] = 139.13, ["Neon"] = 367.49, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 465.94, ["Mega"] = 2154.12, ["Mega|Ride"] = 1626.16, ["Mega|Fly|Ride"] = 1482.83}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 19.41, ["Fly|Ride"] = 144.38, ["Neon"] = 3.94, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 29.29, ["Neon|Fly|Ride"] = 145.28, ["Mega"] = 32.85, ["Mega|Fly"] = 672, ["Mega|Ride"] = 92.42, ["Mega|Fly|Ride"] = 253.32}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 17.31, ["Ride"] = 15.62, ["Fly|Ride"] = 43.24, ["Neon"] = 3.93, ["Neon|Fly"] = 36.87, ["Neon|Ride"] = 20.9, ["Neon|Fly|Ride"] = 61.69, ["Mega"] = 65.63, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 49.87, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 2.1, ["Fly"] = 43.38, ["Ride"] = 38.04, ["Fly|Ride"] = 65.62, ["Neon"] = 26.25, ["Neon|Ride"] = 164.38, ["Neon|Fly|Ride"] = 145.28, ["Mega"] = 549.65, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 472.5, ["Ride"] = 496.49, ["Fly|Ride"] = 446.25, ["Neon"] = 4336.41, ["Neon|Fly|Ride"] = 1771.88, ["Mega|Fly|Ride"] = 5906.25}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 16.89, ["Fly"] = 99.74, ["Ride"] = 52.49, ["Fly|Ride"] = 115.32, ["Neon"] = 217.75, ["Neon|Ride"] = 164.38, ["Neon|Fly|Ride"] = 170.52}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 21.6, ["Fly|Ride"] = 287.81, ["Neon"] = 9.19, ["Neon|Ride"] = 49.26, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 144.37, ["Mega|Ride"] = 116.82, ["Mega|Fly|Ride"] = 289.47}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 84.7, ["Ride"] = 54.66, ["Fly|Ride"] = 261.98, ["Neon"] = 72.65, ["Mega"] = 129.94, ["Mega|Fly|Ride"] = 578.92}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 26.25, ["Fly"] = 72.65, ["Ride"] = 33.17, ["Fly|Ride"] = 101.92, ["Neon"] = 194.25, ["Neon|Ride"] = 219.45, ["Neon|Fly|Ride"] = 275.38, ["Mega"] = 2601.86, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1002.75}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 91.88, ["Fly"] = 188.65, ["Ride"] = 128.62, ["Fly|Ride"] = 175.48, ["Neon"] = 430.1, ["Neon|Fly"] = 823.94, ["Neon|Ride"] = 513.87, ["Neon|Fly|Ride"] = 610.32, ["Mega"] = 3180.76, ["Mega|Fly|Ride"] = 2710.26}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 228.38, ["Ride"] = 292.69, ["Fly|Ride"] = 540.99, ["Neon"] = 938.44, ["Neon|Ride"] = 800.63, ["Neon|Fly|Ride"] = 1035.57, ["Mega|Fly|Ride"] = 2867.82}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 10.63, ["Ride"] = 55.04, ["Fly|Ride"] = 147.2, ["Neon"] = 98.44, ["Neon|Ride"] = 87.93, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 863.5, ["Mega|Ride"] = 402.94, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 28.96, ["Ride"] = 15.74, ["Fly|Ride"] = 38.07, ["Neon"] = 7.77, ["Neon|Ride"] = 23.4, ["Neon|Fly|Ride"] = 84, ["Mega"] = 80.89, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 122.68}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 3.63, ["Fly"] = 40.69, ["Ride"] = 21.23, ["Fly|Ride"] = 63, ["Neon"] = 58.56, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 43.36, ["Neon|Fly|Ride"] = 127.95, ["Mega"] = 288.7, ["Mega|Ride"] = 266.44}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 317.63, ["Ride"] = 350.44, ["Fly|Ride"] = 721.88, ["Neon"] = 1562.54, ["Neon|Ride"] = 2059.8, ["Neon|Fly|Ride"] = 1732.41, ["Mega"] = 10841, ["Mega|Fly|Ride"] = 5056.26}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 33.63, ["Neon"] = 6.5, ["Neon|Ride"] = 139.41, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 27.48, ["Mega|Ride"] = 91.88}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 2.65, ["Ride"] = 16.19, ["Fly|Ride"] = 60.73, ["Neon"] = 22.32, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 98.03, ["Mega"] = 205.99, ["Mega|Ride"] = 146.99}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 11.82, ["Fly"] = 6562.5, ["Ride"] = 59.07, ["Neon"] = 65.63, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 108.43, ["Neon|Fly|Ride"] = 302.55, ["Mega"] = 551.25, ["Mega|Ride"] = 649.69, ["Mega|Fly|Ride"] = 723.11}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 105, ["Fly"] = 157.5, ["Ride"] = 124.69, ["Fly|Ride"] = 156.19, ["Neon|Ride"] = 818.16, ["Neon|Fly|Ride"] = 656.25, ["Mega|Fly|Ride"] = 3252.32}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 17.07, ["Fly"] = 38.29, ["Ride"] = 28.48, ["Fly|Ride"] = 55.13, ["Neon"] = 105, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 114.71, ["Mega"] = 875.44, ["Mega|Ride"] = 422.63, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 145.26, ["Neon"] = 3.29, ["Neon|Ride"] = 81.33, ["Mega"] = 26.25, ["Mega|Ride"] = 122.52}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Ride"] = 17.06, ["Fly|Ride"] = 86.57, ["Neon"] = 2.1, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 83.49, ["Mega"] = 25.99, ["Mega|Fly"] = 101.92, ["Mega|Ride"] = 49.08, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 14.44, ["Ride"] = 78.72, ["Fly|Ride"] = 311.16, ["Neon"] = 38.48, ["Neon|Ride"] = 105.84, ["Neon|Fly|Ride"] = 349.13, ["Mega"] = 184.61, ["Mega|Ride"] = 212.38, ["Mega|Fly|Ride"] = 355.47}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1155, ["Fly"] = 1530.83, ["Ride"] = 1312.5, ["Fly|Ride"] = 1050, ["Neon"] = 4451.32, ["Neon|Ride"] = 4265.96, ["Neon|Fly|Ride"] = 4017.24, ["Mega|Fly|Ride"] = 12600}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 406.88, ["Ride"] = 505.85, ["Fly|Ride"] = 577.5, ["Neon"] = 1680, ["Neon|Ride"] = 2045.99, ["Neon|Fly|Ride"] = 1573.69, ["Mega"] = 17345.61}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 315, ["Fly"] = 414.61, ["Ride"] = 353.53, ["Fly|Ride"] = 393.75, ["Neon"] = 787.5, ["Neon|Fly"] = 1145.67, ["Neon|Ride"] = 708.65, ["Neon|Fly|Ride"] = 786.19, ["Mega|Fly|Ride"] = 2916.24}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 237.99, ["Ride"] = 275.62, ["Fly|Ride"] = 339.94, ["Neon"] = 647.07, ["Neon|Ride"] = 682.49, ["Neon|Fly|Ride"] = 643.13}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 21.7, ["Ride"] = 19.69, ["Fly|Ride"] = 39.38, ["Neon"] = 5.08, ["Neon|Ride"] = 34.75, ["Neon|Fly|Ride"] = 105, ["Mega"] = 55.58, ["Mega|Ride"] = 78.75}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 262.24, ["Fly"] = 466.13, ["Ride"] = 311.18, ["Fly|Ride"] = 376.69, ["Neon"] = 1050, ["Neon|Ride"] = 1365, ["Neon|Fly|Ride"] = 1312.5, ["Mega"] = 21971.46, ["Mega|Ride"] = 5493.14, ["Mega|Fly|Ride"] = 4593.75}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 8.35, ["Fly"] = 118.13, ["Ride"] = 52.49, ["Neon"] = 31.5, ["Neon|Ride"] = 131.15, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 175.87, ["Mega|Ride"] = 342.93, ["Mega|Fly|Ride"] = 698.17}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 19.68, ["Ride"] = 16.46, ["Fly|Ride"] = 38.98, ["Neon"] = 6.22, ["Neon|Ride"] = 55.3, ["Neon|Fly|Ride"] = 55.13, ["Mega"] = 117.08, ["Mega|Ride"] = 164.38, ["Mega|Fly|Ride"] = 159.12}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Mega"] = 32.82, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 177.62}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 31.37, ["Ride"] = 85.32, ["Fly|Ride"] = 459.38, ["Neon"] = 199.5, ["Neon|Ride"] = 359.73, ["Mega"] = 1050, ["Mega|Ride"] = 523.69}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 8177.82, ["Ride"] = 19.69, ["Fly|Ride"] = 68.25, ["Neon"] = 23.61, ["Neon|Ride"] = 62.37, ["Mega"] = 359.94, ["Mega|Ride"] = 232.02, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.13, ["Neon"] = 3.94, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 141.93, ["Mega"] = 23.63, ["Mega|Ride"] = 81.33, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 5.25, ["Fly"] = 85.99, ["Ride"] = 40.69, ["Fly|Ride"] = 85.32, ["Neon"] = 31.5, ["Neon|Fly"] = 116.02, ["Neon|Ride"] = 54.39, ["Neon|Fly|Ride"] = 192.94, ["Mega"] = 158.82, ["Mega|Ride"] = 131.24, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 3.92, ["Fly"] = 32.43, ["Ride"] = 22.31, ["Fly|Ride"] = 45.94, ["Neon"] = 28.87, ["Neon|Fly"] = 147.2, ["Neon|Ride"] = 145.28, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 238.83, ["Mega|Ride"] = 251.07, ["Mega|Fly|Ride"] = 1321.69}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 19.98, ["Ride"] = 38.07, ["Fly|Ride"] = 147.2, ["Neon"] = 27.57, ["Neon|Ride"] = 171.3, ["Neon|Fly|Ride"] = 327.52, ["Mega"] = 532.37, ["Mega|Ride"] = 492.2}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.1, ["Fly"] = 6542.75, ["Ride"] = 17.07, ["Fly|Ride"] = 131.24, ["Neon"] = 51.98, ["Neon|Ride"] = 215.41, ["Neon|Fly|Ride"] = 289.47, ["Mega"] = 354.38, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 68.16, ["Ride"] = 16.35, ["Fly|Ride"] = 45.94, ["Neon"] = 5.13, ["Neon|Fly"] = 82.48, ["Neon|Ride"] = 28.23, ["Mega"] = 43.32, ["Mega|Fly|Ride"] = 164.38}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 131.25, ["Fly"] = 264.54, ["Ride"] = 168, ["Fly|Ride"] = 262.5, ["Neon"] = 867.29, ["Neon|Ride"] = 1026.66, ["Neon|Fly|Ride"] = 932.34, ["Mega"] = 8672.81}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 22.97, ["Ride"] = 17.27, ["Fly|Ride"] = 36.66, ["Neon"] = 3.73, ["Neon|Fly"] = 36.82, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 62.57, ["Mega"] = 49.65, ["Mega|Ride"] = 53.2, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 6.39, ["Ride"] = 72.65, ["Fly|Ride"] = 230.9, ["Neon"] = 64.99, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 785.04, ["Mega"] = 295.32, ["Mega|Ride"] = 303.19}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 29.28, ["Ride"] = 95.54, ["Fly|Ride"] = 183.75, ["Neon"] = 157.5, ["Neon|Ride"] = 302.48, ["Neon|Fly|Ride"] = 414.23, ["Mega"] = 786.19, ["Mega|Ride"] = 913.5, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 181.27, ["Fly"] = 223.13, ["Ride"] = 245.44, ["Fly|Ride"] = 295.32, ["Neon"] = 812.4, ["Neon|Ride"] = 702.19, ["Neon|Fly|Ride"] = 851.82, ["Mega|Fly|Ride"] = 3758.58}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 11.8, ["Ride"] = 150.06, ["Fly|Ride"] = 147.2, ["Neon"] = 151.79, ["Neon|Ride"] = 176.65, ["Neon|Fly|Ride"] = 433.65, ["Mega"] = 265.04, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 597.37}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 6.57, ["Ride"] = 43.37, ["Fly|Ride"] = 72.65, ["Neon"] = 144.38, ["Neon|Ride"] = 327.52, ["Neon|Fly|Ride"] = 216.84, ["Mega"] = 1734.57, ["Mega|Ride"] = 1446.21, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 943.59, ["Fly"] = 1226.63, ["Ride"] = 1016.97, ["Fly|Ride"] = 1029, ["Neon|Ride"] = 5906.25, ["Neon|Fly|Ride"] = 5116.96, ["Mega|Fly|Ride"] = 17331.51}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 5.15, ["Fly"] = 26.25, ["Ride"] = 18.38, ["Fly|Ride"] = 45.93, ["Neon"] = 47.25, ["Neon|Fly"] = 72.19, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 242.82, ["Mega|Ride"] = 289.47, ["Mega|Fly|Ride"] = 346.49}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 5.98, ["Fly"] = 78.75, ["Ride"] = 38.07, ["Fly|Ride"] = 135.19, ["Neon"] = 26.25, ["Neon|Ride"] = 84.57, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 211.32, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 332.07}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Fly"] = 86.75, ["Ride"] = 24.94, ["Fly|Ride"] = 105, ["Neon"] = 9.34, ["Neon|Ride"] = 47.85, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 81.23, ["Mega|Ride"] = 360.34, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 13.09, ["Ride"] = 29.27, ["Fly|Ride"] = 84, ["Neon"] = 67.98, ["Neon|Fly"] = 232.02, ["Neon|Ride"] = 97.92, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 446.23, ["Mega|Ride"] = 421.32, ["Mega|Fly|Ride"] = 461.75}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 2.1, ["Fly"] = 24.05, ["Ride"] = 21.58, ["Fly|Ride"] = 53.85, ["Neon"] = 14.48, ["Neon|Fly"] = 46.64, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 77.44, ["Mega"] = 145.69, ["Mega|Fly"] = 280.98, ["Mega|Ride"] = 169.32, ["Mega|Fly|Ride"] = 175.3}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Ride"] = 20.72, ["Neon"] = 9.19, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 124.69, ["Mega|Ride"] = 188.65}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 196.88, ["Ride"] = 332.83, ["Fly|Ride"] = 433.13, ["Neon"] = 939.92, ["Neon|Fly|Ride"] = 1183.01, ["Mega|Fly|Ride"] = 3937.46}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.63, ["Fly"] = 32.81, ["Ride"] = 26.16, ["Fly|Ride"] = 145.28, ["Neon"] = 9.19, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 65.3, ["Mega|Ride"] = 101.92, ["Mega|Fly|Ride"] = 346.92}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 6.16, ["Ride"] = 29.29, ["Fly|Ride"] = 88.86, ["Neon"] = 28.21, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 188.27, ["Mega"] = 260.21, ["Mega|Ride"] = 346.92}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 2.1, ["Fly"] = 94.75, ["Ride"] = 31.5, ["Neon"] = 15.75, ["Neon|Ride"] = 68.32, ["Mega"] = 93.19, ["Mega|Ride"] = 120.54, ["Mega|Fly|Ride"] = 504.2}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 72.19, ["Ride"] = 129.94, ["Fly|Ride"] = 249.38, ["Neon"] = 262.5, ["Neon|Ride"] = 433.65, ["Neon|Fly|Ride"] = 376.2, ["Mega"] = 2601.86, ["Mega|Ride"] = 4336.41, ["Mega|Fly|Ride"] = 1539.44}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 21, ["Fly"] = 90.57, ["Ride"] = 71.56, ["Fly|Ride"] = 269.9, ["Neon"] = 181.33, ["Neon|Ride"] = 275.28, ["Neon|Fly|Ride"] = 341.93, ["Mega"] = 656.24, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 24.54, ["Fly"] = 58.56, ["Ride"] = 42, ["Fly|Ride"] = 115.69, ["Neon"] = 93.19, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 609, ["Mega|Ride"] = 435.75, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.54, ["Ride"] = 71.58, ["Neon"] = 14.43, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 230.79, ["Mega"] = 131.25, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 32.68, ["Fly"] = 91.88, ["Ride"] = 78.75, ["Fly|Ride"] = 157.5, ["Neon"] = 250.44, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 229.59, ["Neon|Fly|Ride"] = 261.19, ["Mega|Fly|Ride"] = 1011.71}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 65.63, ["Neon"] = 5.44, ["Neon|Fly|Ride"] = 129.02, ["Mega"] = 61.81, ["Mega|Ride"] = 288.39, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 15.48, ["Fly"] = 39.38, ["Ride"] = 32.82, ["Fly|Ride"] = 93.24, ["Neon"] = 61.69, ["Neon|Fly"] = 84, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 203.44, ["Mega"] = 360.7, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 432.57, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 45.94, ["Fly"] = 203.41, ["Ride"] = 80.07, ["Fly|Ride"] = 131.25, ["Neon"] = 262.5, ["Neon|Fly"] = 433.65, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 359.62, ["Mega|Ride"] = 1483.06, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 16.28, ["Ride"] = 14.77, ["Fly|Ride"] = 35.44, ["Neon"] = 2.63, ["Neon|Fly"] = 28.21, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 44.63, ["Mega"] = 20.41, ["Mega|Ride"] = 40.69, ["Mega|Fly|Ride"] = 82.55}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 3.64, ["Fly"] = 105, ["Ride"] = 23.87, ["Fly|Ride"] = 64.31, ["Neon"] = 29.29, ["Neon|Ride"] = 47.92, ["Neon|Fly|Ride"] = 168, ["Mega"] = 472.5, ["Mega|Ride"] = 289.47, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 13.01, ["Fly"] = 43.38, ["Ride"] = 41.57, ["Fly|Ride"] = 117.25, ["Neon"] = 110.76, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 271.38, ["Mega"] = 650.48, ["Mega|Ride"] = 454.77, ["Mega|Fly|Ride"] = 607.19}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 21.37, ["Neon"] = 2.5, ["Neon|Fly"] = 32.81, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 90.57, ["Mega"] = 21, ["Mega|Ride"] = 54.23}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 29.55, ["Fly"] = 210, ["Ride"] = 65.61, ["Fly|Ride"] = 215.45, ["Neon"] = 145.69, ["Neon|Ride"] = 258.03, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 648.63, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 640.73, ["Mega|Fly|Ride"] = 1003.89}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 13.34, ["Fly"] = 43.38, ["Ride"] = 26.25, ["Fly|Ride"] = 95.42, ["Neon"] = 376.69, ["Neon|Ride"] = 121.8, ["Neon|Fly|Ride"] = 166.98, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 520.38}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 3.76, ["Ride"] = 55.3, ["Neon"] = 64.32, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 723.11, ["Mega"] = 234.94, ["Mega|Ride"] = 316.28, ["Mega|Fly|Ride"] = 490.67}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 8.21, ["Fly"] = 72.19, ["Ride"] = 68.16, ["Fly|Ride"] = 242.19, ["Neon"] = 48.12, ["Neon|Ride"] = 88.92, ["Neon|Fly|Ride"] = 190.31, ["Mega"] = 244.63, ["Mega|Ride"] = 232.02, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Ride"] = 36.66, ["Fly|Ride"] = 196.88, ["Neon"] = 8.82, ["Neon|Ride"] = 37.43, ["Neon|Fly|Ride"] = 105, ["Mega"] = 69.57, ["Mega|Fly"] = 216.84, ["Mega|Ride"] = 93.26, ["Mega|Fly|Ride"] = 289.47}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 58.89, ["Neon"] = 5.25, ["Neon|Ride"] = 35.43, ["Neon|Fly|Ride"] = 145.29, ["Mega"] = 49.88, ["Mega|Ride"] = 115.49}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 19.68}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 49.23, ["Fly"] = 101.07, ["Ride"] = 59.07, ["Fly|Ride"] = 91.87, ["Neon"] = 184.58, ["Neon|Ride"] = 216.84, ["Neon|Fly|Ride"] = 312.38, ["Mega"] = 1854.36, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 853.58}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Fly|Ride"] = 108.43, ["Neon"] = 2.63, ["Neon|Ride"] = 31.5, ["Mega"] = 20.85, ["Mega|Ride"] = 115.32, ["Mega|Fly|Ride"] = 325.25}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 525, ["Ride"] = 567, ["Fly|Ride"] = 674.65, ["Neon"] = 2891.31, ["Neon|Ride"] = 2710.26, ["Neon|Fly|Ride"] = 2454.42, ["Mega"] = 17345.61, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 7.38, ["Fly"] = 48.86, ["Ride"] = 33.73, ["Fly|Ride"] = 66.13, ["Neon"] = 46.54, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 115.9, ["Mega"] = 327.52, ["Mega|Ride"] = 195.57, ["Mega|Fly|Ride"] = 636.39}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.16, ["Fly"] = 29.12, ["Ride"] = 22.32, ["Fly|Ride"] = 58.89, ["Neon"] = 23.63, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 99.65, ["Mega"] = 140.95, ["Mega|Fly"] = 289.47, ["Mega|Ride"] = 164.38, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 9.97, ["Ride"] = 58.47, ["Fly|Ride"] = 542.07, ["Neon"] = 112.87, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 313.69, ["Mega"] = 492.2, ["Mega|Ride"] = 388.5, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 2.45, ["Fly"] = 58.56, ["Ride"] = 38.57, ["Fly|Ride"] = 72.65, ["Neon"] = 39.25, ["Neon|Fly"] = 72.65, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 392.44, ["Mega"] = 282.19, ["Mega|Ride"] = 288.39, ["Mega|Fly|Ride"] = 505.2}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 11.82, ["Ride"] = 72.19, ["Fly|Ride"] = 196.88, ["Neon"] = 72.19, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 143.12, ["Mega"] = 536.65, ["Mega|Ride"] = 415.8, ["Mega|Fly|Ride"] = 491.34}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 5.98, ["Ride"] = 26.25, ["Fly|Ride"] = 91.88, ["Neon"] = 28.59, ["Neon|Ride"] = 82.1, ["Neon|Fly|Ride"] = 277.54, ["Mega"] = 226.96, ["Mega|Ride"] = 274.86, ["Mega|Fly|Ride"] = 349.13}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 47.57, ["Ride"] = 13.13, ["Fly|Ride"] = 58.56, ["Neon"] = 2.1, ["Neon|Fly"] = 41.99, ["Neon|Ride"] = 18.19, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 15.75, ["Mega|Fly"] = 66.25, ["Mega|Ride"] = 49.08, ["Mega|Fly|Ride"] = 118.79}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 5.58, ["Fly"] = 49.88, ["Ride"] = 56.43, ["Fly|Ride"] = 108.43, ["Neon"] = 18.31, ["Neon|Fly"] = 122.68, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 212.17, ["Mega|Ride"] = 275.38, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 258.46, ["Ride"] = 288.75, ["Fly|Ride"] = 383.84, ["Neon"] = 1275.68, ["Neon|Ride"] = 1043.44, ["Neon|Fly|Ride"] = 1050, ["Mega|Ride"] = 9518.51, ["Mega|Fly|Ride"] = 4065.38}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 81.81, ["Ride"] = 105, ["Fly|Ride"] = 258.03, ["Neon"] = 458.07, ["Neon|Fly"] = 928.01, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 2313.48, ["Mega|Ride"] = 1837.5, ["Mega|Fly|Ride"] = 1827}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 16.03, ["Ride"] = 15.75, ["Fly|Ride"] = 32.82, ["Neon"] = 7.33, ["Neon|Fly"] = 72.65, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 72.65, ["Mega"] = 145.28, ["Mega|Fly"] = 215.76, ["Mega|Ride"] = 101.92, ["Mega|Fly|Ride"] = 260.54}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 23.7, ["Ride"] = 15.71, ["Fly|Ride"] = 34.85, ["Neon"] = 11.71, ["Neon|Fly"] = 27.04, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 50.96, ["Mega"] = 51.19, ["Mega|Fly"] = 289.47, ["Mega|Ride"] = 90.81, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.1, ["Fly"] = 101.92, ["Ride"] = 22.32, ["Fly|Ride"] = 98.44, ["Neon"] = 105, ["Neon|Ride"] = 33.13, ["Neon|Fly|Ride"] = 157.5, ["Mega|Ride"] = 332.05, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 209.94, ["Fly"] = 327.52, ["Ride"] = 246.11, ["Fly|Ride"] = 315, ["Neon"] = 1192.52, ["Neon|Ride"] = 1050, ["Neon|Fly|Ride"] = 1517.75, ["Mega|Ride"] = 8672.81, ["Mega|Fly|Ride"] = 3937.5}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.1, ["Fly"] = 31.4, ["Ride"] = 15.75, ["Fly|Ride"] = 42.95, ["Neon"] = 15.16, ["Neon|Fly"] = 104.97, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 262.5, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 3.94, ["Ride"] = 77.97, ["Fly|Ride"] = 216.01, ["Neon"] = 46.64, ["Neon|Ride"] = 110.58, ["Neon|Fly|Ride"] = 289.47, ["Mega"] = 264.96, ["Mega|Ride"] = 232.02, ["Mega|Fly|Ride"] = 432.57}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Neon"] = 11.69, ["Neon|Ride"] = 137.82, ["Mega"] = 103.69}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 10.31, ["Fly"] = 50.15, ["Ride"] = 27.45, ["Fly|Ride"] = 65.63, ["Neon"] = 211.34, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 301.88, ["Mega|Ride"] = 501.38, ["Mega|Fly|Ride"] = 655.03}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 38.06, ["Ride"] = 99.8, ["Fly|Ride"] = 292.84, ["Neon"] = 102.18, ["Neon|Fly"] = 655.95, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 556.89, ["Mega|Fly"] = 2276.63, ["Mega|Ride"] = 486.33, ["Mega|Fly|Ride"] = 669.39}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 23.63, ["Ride"] = 47.7, ["Fly|Ride"] = 91.88, ["Neon"] = 155.79, ["Neon|Fly"] = 286.44, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 867.29, ["Mega|Ride"] = 700.88, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 15.83, ["Ride"] = 13.75, ["Fly|Ride"] = 51.45, ["Neon"] = 2.1, ["Neon|Fly"] = 32.45, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 19.84, ["Mega|Fly"] = 43.32, ["Mega|Ride"] = 27.46}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 209.41, ["Ride"] = 242.29, ["Fly|Ride"] = 295.21, ["Neon"] = 3434.52, ["Neon|Ride"] = 853.2, ["Neon|Fly|Ride"] = 1300.93, ["Mega|Fly|Ride"] = 4049.13}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 10.85, ["Fly"] = 101.18, ["Ride"] = 28.88, ["Fly|Ride"] = 92.94, ["Neon"] = 78.75, ["Neon|Ride"] = 66.25, ["Neon|Fly|Ride"] = 289.47, ["Mega"] = 380.63, ["Mega|Ride"] = 578.92, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 36.35, ["Ride"] = 18.78, ["Fly|Ride"] = 50.71, ["Neon"] = 5.71, ["Neon|Fly"] = 36.3, ["Neon|Ride"] = 29.29, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 61.81, ["Mega|Fly"] = 232.02, ["Mega|Ride"] = 86.75, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 32.54, ["Ride"] = 22.32, ["Fly|Ride"] = 80.24, ["Neon"] = 2.57, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 110.41, ["Mega"] = 32.45, ["Mega|Fly"] = 144.38, ["Mega|Ride"] = 82.21, ["Mega|Fly|Ride"] = 163.71}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 44.63, ["Neon"] = 12.27, ["Neon|Fly"] = 735.98, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 105, ["Mega"] = 155.54, ["Mega|Ride"] = 140.09, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 7.85, ["Fly"] = 47.23, ["Ride"] = 26.17, ["Fly|Ride"] = 66.94, ["Neon"] = 47.25, ["Neon|Fly"] = 246.11, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 246.11, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 374.07}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 20.19, ["Ride"] = 101.92, ["Neon"] = 108.43, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 246.11, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 490.67}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 57.75, ["Neon"] = 3.1, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 101.92, ["Mega"] = 19.69, ["Mega|Ride"] = 66.94, ["Mega|Fly|Ride"] = 158.74}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 7.88, ["Ride"] = 33.88, ["Fly|Ride"] = 103.01, ["Neon"] = 38.11, ["Neon|Fly"] = 102.8, ["Neon|Ride"] = 49.07, ["Neon|Fly|Ride"] = 145.28, ["Mega"] = 160.13, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 363.83}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 3.61, ["Neon|Fly"] = 116.02, ["Neon|Ride"] = 29.29, ["Neon|Fly|Ride"] = 105, ["Mega"] = 26.17, ["Mega|Ride"] = 122.52, ["Mega|Fly|Ride"] = 260.21}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 49.88, ["Ride"] = 17.07, ["Fly|Ride"] = 33.13, ["Neon"] = 5.07, ["Neon|Ride"] = 27.46, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 45.92, ["Mega|Ride"] = 118.13}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 629.99, ["Ride"] = 708.75, ["Fly|Ride"] = 771.75, ["Neon"] = 2625, ["Neon|Ride"] = 3434.52}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 14.44, ["Ride"] = 15.75, ["Fly|Ride"] = 39.38, ["Neon"] = 18.38, ["Neon|Fly"] = 43.14, ["Neon|Ride"] = 27.27, ["Neon|Fly|Ride"] = 85.31}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 3.94, ["Ride"] = 52.5, ["Neon"] = 13.02, ["Neon|Fly"] = 758.89, ["Neon|Ride"] = 70.69, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 89.25, ["Mega|Fly"] = 216.84, ["Mega|Ride"] = 163.59}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 8.58, ["Fly"] = 23.62, ["Ride"] = 23.44, ["Fly|Ride"] = 53.81, ["Neon"] = 48.57, ["Neon|Fly"] = 194.86, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 116.02, ["Mega"] = 485.63, ["Mega|Ride"] = 308.43, ["Mega|Fly|Ride"] = 376.67}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 58.96, ["Ride"] = 14.44, ["Fly|Ride"] = 45.54, ["Neon"] = 8.3, ["Neon|Fly"] = 151.79, ["Neon|Ride"] = 26.03, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 62.89, ["Mega|Ride"] = 94.55, ["Mega|Fly|Ride"] = 145.28}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 36.73, ["Ride"] = 65.63, ["Fly|Ride"] = 324.16, ["Neon"] = 236.25, ["Neon|Ride"] = 311.57, ["Mega"] = 748.05, ["Mega|Ride"] = 795.74, ["Mega|Fly|Ride"] = 766.47}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 21.7, ["Fly|Ride"] = 91.88, ["Neon"] = 7.88, ["Neon|Fly"] = 139.85, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 119.44, ["Mega"] = 47.24, ["Mega|Ride"] = 106.32, ["Mega|Fly|Ride"] = 279.57}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 21, ["Fly|Ride"] = 78.9, ["Neon"] = 13.11, ["Neon|Ride"] = 58.56, ["Mega"] = 113.9, ["Mega|Ride"] = 198.59, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Ride"] = 43.38, ["Fly|Ride"] = 65.83, ["Neon"] = 11.7, ["Neon|Fly|Ride"] = 116.02, ["Mega"] = 97.12, ["Mega|Ride"] = 92.37, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 43.38, ["Ride"] = 16.88, ["Fly|Ride"] = 69.21, ["Neon"] = 4.54, ["Neon|Fly"] = 72.24, ["Neon|Ride"] = 23.26, ["Neon|Fly|Ride"] = 108.15, ["Mega"] = 44.51, ["Mega|Fly"] = 229.69, ["Mega|Ride"] = 164.38}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 13.12, ["Fly"] = 22.16, ["Ride"] = 19.49, ["Fly|Ride"] = 43.32, ["Neon"] = 118.13, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 72.65, ["Neon|Fly|Ride"] = 140.95, ["Mega|Ride"] = 433.65, ["Mega|Fly|Ride"] = 441.6}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 724.49, ["Fly"] = 1084.12, ["Ride"] = 761.25, ["Fly|Ride"] = 905.63, ["Neon"] = 1935.94, ["Neon|Ride"] = 1785, ["Neon|Fly|Ride"] = 2164.32, ["Mega"] = 8672.81, ["Mega|Ride"] = 5702.38, ["Mega|Fly|Ride"] = 4508.44}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 19.59, ["Ride"] = 16.44, ["Fly|Ride"] = 41.48, ["Neon"] = 3.94, ["Neon|Ride"] = 18.27, ["Neon|Fly|Ride"] = 58.56, ["Mega"] = 43.36, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 204.86}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 6.13, ["Fly"] = 26.17, ["Ride"] = 28.88, ["Fly|Ride"] = 72.65, ["Neon"] = 49.08, ["Neon|Ride"] = 216.57, ["Neon|Fly|Ride"] = 236.25, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 433.65}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 51.05, ["Fly"] = 104.9, ["Ride"] = 63.96, ["Fly|Ride"] = 98.43, ["Neon"] = 262.5, ["Neon|Ride"] = 313.69, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 2439.83}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 31.49, ["Fly"] = 146.86, ["Ride"] = 52.4, ["Fly|Ride"] = 107.96, ["Neon"] = 143.12, ["Neon|Ride"] = 145.28, ["Neon|Fly|Ride"] = 433.65, ["Mega"] = 1471.95, ["Mega|Ride"] = 938.84, ["Mega|Fly|Ride"] = 678.87}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 9.22, ["Fly"] = 95.69, ["Ride"] = 28.17, ["Neon"] = 54.94, ["Neon|Ride"] = 108.43, ["Neon|Fly|Ride"] = 273, ["Mega"] = 305.36, ["Mega|Ride"] = 419.56, ["Mega|Fly|Ride"] = 462}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 19.36, ["Ride"] = 59.07, ["Fly|Ride"] = 145.28, ["Neon"] = 105, ["Neon|Ride"] = 106.32, ["Neon|Fly|Ride"] = 152.25, ["Mega"] = 338.63, ["Mega|Fly"] = 744.57, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 397.69}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 20.79, ["Ride"] = 78.75, ["Neon"] = 146.46, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 525, ["Mega"] = 536.65, ["Mega|Fly"] = 567, ["Mega|Ride"] = 476.44}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 3.81}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 5.25, ["Ride"] = 28.88, ["Fly|Ride"] = 78.75, ["Neon"] = 32.82, ["Neon|Ride"] = 66.25, ["Neon|Fly|Ride"] = 213.97, ["Mega"] = 210, ["Mega|Fly"] = 458.27, ["Mega|Ride"] = 233.63, ["Mega|Fly|Ride"] = 308.05}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.1, ["Neon"] = 13.13, ["Neon|Fly|Ride"] = 216.84, ["Mega"] = 143.07, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 28.98, ["Fly"] = 62.99, ["Ride"] = 44.09, ["Fly|Ride"] = 81.97, ["Neon"] = 220.5, ["Neon|Fly"] = 289.47, ["Neon|Ride"] = 173.46, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 578.92, ["Mega|Fly|Ride"] = 616.87}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.13, ["Fly"] = 17.94, ["Ride"] = 18.08, ["Fly|Ride"] = 36.75, ["Neon"] = 28.74, ["Neon|Fly"] = 69.57, ["Neon|Ride"] = 31.4, ["Neon|Fly|Ride"] = 75.06, ["Mega"] = 232.31, ["Mega|Fly"] = 432.57, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 198.18}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 3.94, ["Fly"] = 31.91, ["Ride"] = 26.16, ["Fly|Ride"] = 54.23, ["Neon"] = 21, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 220.16, ["Mega|Fly"] = 197.4, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 246.1}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 7.88, ["Mega"] = 40.69, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 258.57}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 26.16, ["Ride"] = 52.5, ["Fly|Ride"] = 145.28, ["Neon"] = 163.61, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 433.65, ["Mega|Ride"] = 858.63, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 21, ["Fly|Ride"] = 58.43, ["Neon"] = 7.65, ["Neon|Fly"] = 203.44, ["Neon|Ride"] = 41.98, ["Neon|Fly|Ride"] = 105, ["Mega"] = 72.65, ["Mega|Ride"] = 139.94}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 6.57, ["Ride"] = 87.94, ["Fly|Ride"] = 288.39, ["Neon"] = 59.07, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 325.25, ["Mega"] = 236.25, ["Mega|Fly"] = 578.92, ["Mega|Ride"] = 400.77}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 45.92, ["Ride"] = 15.94, ["Fly|Ride"] = 61.69, ["Neon"] = 21.51, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 99.74, ["Mega"] = 194.25, ["Mega|Ride"] = 202.79, ["Mega|Fly|Ride"] = 288.39}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 2.63, ["Fly"] = 52.49, ["Ride"] = 19.49, ["Fly|Ride"] = 44.93, ["Neon"] = 49.65, ["Neon|Ride"] = 145.28, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 613.32, ["Mega|Ride"] = 432.57, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 9.09, ["Neon"] = 52.77, ["Neon|Fly|Ride"] = 145.28, ["Mega"] = 418.06, ["Mega|Ride"] = 366.19, ["Mega|Fly|Ride"] = 645.74}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 50.34, ["Ride"] = 98.44, ["Fly|Ride"] = 480.26, ["Neon"] = 419.56, ["Neon|Ride"] = 496.53, ["Neon|Fly|Ride"] = 669.38, ["Mega"] = 1790.95, ["Mega|Fly|Ride"] = 1951.39}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 15.35, ["Ride"] = 78.65, ["Fly|Ride"] = 161.28, ["Neon"] = 107.62, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 380.63, ["Mega|Ride"] = 418.69}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 6.57, ["Ride"] = 126.04, ["Neon"] = 41.72, ["Neon|Fly"] = 216.84, ["Neon|Ride"] = 170.63, ["Mega|Ride"] = 866.21}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 23.62, ["Ride"] = 105, ["Fly|Ride"] = 367.48, ["Neon"] = 134.16, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 679.74, ["Mega|Fly"] = 2168.21, ["Mega|Ride"] = 643.97, ["Mega|Fly|Ride"] = 813.09}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 2.35, ["Neon"] = 19.92, ["Neon|Fly|Ride"] = 145.28, ["Mega"] = 184.31, ["Mega|Ride"] = 255.15, ["Mega|Fly|Ride"] = 327.52}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 19.36, ["Fly|Ride"] = 41.91, ["Neon"] = 3.49, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 44.12, ["Neon|Fly|Ride"] = 65.09, ["Mega"] = 131.25, ["Mega|Ride"] = 76.13, ["Mega|Fly|Ride"] = 144.36}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 21.7, ["Fly|Ride"] = 77.83, ["Neon"] = 14.97, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 164.06, ["Mega"] = 87.94, ["Mega|Ride"] = 104.98}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 145.28, ["Ride"] = 18.88, ["Fly|Ride"] = 65.63, ["Neon"] = 7.88, ["Neon|Ride"] = 29.29, ["Neon|Fly|Ride"] = 92.18, ["Mega"] = 52.49, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 167.76}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 3.88, ["Fly"] = 65.62, ["Ride"] = 19.29, ["Fly|Ride"] = 72.65, ["Neon"] = 18.47, ["Neon|Ride"] = 108.43, ["Neon|Fly|Ride"] = 216.84, ["Mega"] = 328.02, ["Mega|Ride"] = 331.74, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.93, ["Fly"] = 57.82, ["Ride"] = 24.54, ["Fly|Ride"] = 433.65, ["Neon"] = 30.19, ["Neon|Fly"] = 315, ["Neon|Ride"] = 85.32, ["Mega"] = 307.9, ["Mega|Ride"] = 287.47, ["Mega|Fly|Ride"] = 1084.12}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 3.51, ["Fly"] = 131.25, ["Ride"] = 23, ["Fly|Ride"] = 55.3, ["Neon"] = 32.62, ["Neon|Fly"] = 130.09, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 82.6, ["Mega"] = 306.51, ["Mega|Ride"] = 292.72, ["Mega|Fly|Ride"] = 466.59}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 35.48, ["Ride"] = 20.61, ["Fly|Ride"] = 52.41, ["Neon"] = 23.63, ["Neon|Ride"] = 69.08, ["Neon|Fly|Ride"] = 108.43, ["Mega"] = 260.21, ["Mega|Ride"] = 315.67, ["Mega|Fly|Ride"] = 186.18}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 3.67, ["Fly"] = 288.72, ["Ride"] = 47.22, ["Fly|Ride"] = 131.25, ["Neon"] = 12.89, ["Neon|Fly"] = 437.06, ["Neon|Ride"] = 66.93, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 105, ["Mega|Fly"] = 216.57, ["Mega|Ride"] = 164.07, ["Mega|Fly|Ride"] = 269.98}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 13.02, ["Ride"] = 91.88, ["Fly|Ride"] = 433.65, ["Neon"] = 115.5, ["Neon|Fly"] = 288.75, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 757.8, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 43.37, ["Fly"] = 164.07, ["Ride"] = 89.98, ["Fly|Ride"] = 165.38, ["Neon"] = 240.9, ["Neon|Ride"] = 270.38, ["Neon|Fly|Ride"] = 336, ["Mega"] = 1589.31, ["Mega|Ride"] = 1063.13, ["Mega|Fly|Ride"] = 1284.94}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Ride"] = 21.57, ["Fly|Ride"] = 52.05, ["Neon"] = 2.3, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 145.28, ["Mega"] = 27.57, ["Mega|Ride"] = 71.04, ["Mega|Fly|Ride"] = 107.63}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 10.22, ["Neon"] = 105.94, ["Mega"] = 686.56, ["Mega|Fly|Ride"] = 1142.66}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 53.7, ["Ride"] = 91.91, ["Neon"] = 249.37, ["Neon|Ride"] = 344.37, ["Neon|Fly|Ride"] = 866.21, ["Mega"] = 1786.61, ["Mega|Fly|Ride"] = 1458.19}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 4.97, ["Fly"] = 190.32, ["Ride"] = 25.82, ["Fly|Ride"] = 133.88, ["Neon"] = 46.87, ["Neon|Fly"] = 131.27, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 127.95, ["Mega"] = 267.46, ["Mega|Fly"] = 740.88, ["Mega|Ride"] = 242.81, ["Mega|Fly|Ride"] = 271.69}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 3.26, ["Neon"] = 12.99, ["Mega"] = 94.88, ["Mega|Fly"] = 282.17, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 29.51, ["Ride"] = 19.26, ["Fly|Ride"] = 42.86, ["Neon"] = 26.25, ["Neon|Fly"] = 43.38, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 84, ["Mega"] = 173.25, ["Mega|Ride"] = 131.15}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 17.11, ["Ride"] = 15.49, ["Fly|Ride"] = 52.31, ["Neon"] = 2.45, ["Neon|Fly"] = 34.7, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 52.41, ["Mega"] = 28.88, ["Mega|Ride"] = 69.57, ["Mega|Fly|Ride"] = 154.8}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 20.58, ["Fly|Ride"] = 82.21, ["Neon"] = 3.97, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 59.07, ["Mega|Fly"] = 154.94, ["Mega|Ride"] = 89.99, ["Mega|Fly|Ride"] = 173.46}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Neon"] = 2.63, ["Neon|Ride"] = 145.08, ["Mega"] = 42.3, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 3.87, ["Ride"] = 157.5, ["Neon"] = 53.33, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 409.7, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 428.54}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 4.09, ["Ride"] = 26.25, ["Fly|Ride"] = 215.9, ["Neon"] = 59.07, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 145.28, ["Mega"] = 262.5, ["Mega|Ride"] = 233.89, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 5.5, ["Fly"] = 25.27, ["Ride"] = 18.16, ["Fly|Ride"] = 43.94, ["Neon"] = 26.24, ["Neon|Fly"] = 116.02, ["Neon|Ride"] = 35.23, ["Neon|Fly|Ride"] = 91.77, ["Mega"] = 351.26, ["Mega|Ride"] = 311.37, ["Mega|Fly|Ride"] = 319.82}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 72.05, ["Ride"] = 78.75, ["Fly|Ride"] = 124.69, ["Neon"] = 393.75, ["Neon|Ride"] = 432.57, ["Neon|Fly|Ride"] = 723.11, ["Mega"] = 2453.24, ["Mega|Ride"] = 1633.75, ["Mega|Fly|Ride"] = 1472.63}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 20.02, ["Fly"] = 82.69, ["Ride"] = 58.97, ["Fly|Ride"] = 116.02, ["Neon"] = 58.56, ["Neon|Fly|Ride"] = 630, ["Mega"] = 433.65, ["Mega|Ride"] = 879.38, ["Mega|Fly|Ride"] = 1037.54}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 15.65, ["Fly|Ride"] = 41.56, ["Neon"] = 2.61, ["Neon|Fly"] = 43.38, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 56.44, ["Mega"] = 28.21, ["Mega|Ride"] = 93.44}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 15.65, ["Ride"] = 16.21, ["Fly|Ride"] = 34.13, ["Neon"] = 4.15, ["Neon|Fly"] = 27.54, ["Neon|Ride"] = 20.89, ["Neon|Fly|Ride"] = 43.32, ["Mega"] = 44.73, ["Mega|Ride"] = 49.37, ["Mega|Fly|Ride"] = 98.44}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 393.75, ["Fly"] = 576.52, ["Ride"] = 441.83, ["Fly|Ride"] = 518.44, ["Neon"] = 1995.71, ["Neon|Ride"] = 2034.38, ["Neon|Fly|Ride"] = 2097.38, ["Mega|Fly|Ride"] = 6866.7}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 2.63, ["Ride"] = 40.69, ["Neon"] = 40.68, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 403.5, ["Mega|Ride"] = 722.03, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 15.75, ["Fly|Ride"] = 34.13, ["Neon"] = 6.46, ["Neon|Fly"] = 19.49, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 49.88, ["Mega"] = 63.98, ["Mega|Ride"] = 145.18}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 48.97, ["Ride"] = 111.57, ["Fly|Ride"] = 286.22, ["Neon"] = 131.25, ["Neon|Ride"] = 259.51, ["Neon|Fly|Ride"] = 438.38, ["Mega"] = 737.63, ["Mega|Ride"] = 682.5, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 24.87, ["Ride"] = 19.53, ["Fly|Ride"] = 590.63, ["Neon"] = 14.44, ["Neon|Fly"] = 43.38, ["Neon|Ride"] = 31.96, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 130.11, ["Mega|Ride"] = 129.93, ["Mega|Fly|Ride"] = 233.62}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Ride"] = 54.23, ["Fly|Ride"] = 196.88, ["Neon"] = 2.63, ["Neon|Fly"] = 101.92, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 111.56, ["Mega"] = 18.38, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 231.82}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 31.49, ["Fly"] = 129.94, ["Ride"] = 77.95, ["Fly|Ride"] = 215.54, ["Neon"] = 118.13, ["Neon|Ride"] = 161.44, ["Neon|Fly|Ride"] = 288.73, ["Mega"] = 709.02, ["Mega|Ride"] = 647.05, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Fly"] = 24.94, ["Ride"] = 19.69, ["Fly|Ride"] = 146.99, ["Neon"] = 4.98, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 86.75, ["Mega"] = 62.9, ["Mega|Ride"] = 157.35, ["Mega|Fly|Ride"] = 252}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 27.57, ["Ride"] = 61.52, ["Fly|Ride"] = 105, ["Neon"] = 283.23, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 288.46, ["Mega"] = 1181.25, ["Mega|Ride"] = 1300.93, ["Mega|Fly|Ride"] = 1333.83}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 3.66, ["Fly"] = 72.65, ["Ride"] = 131.25, ["Fly|Ride"] = 433.65, ["Neon"] = 17.78, ["Neon|Ride"] = 231, ["Neon|Fly|Ride"] = 506.29, ["Mega"] = 169.32, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.1, ["Fly"] = 72.65, ["Ride"] = 78.1, ["Fly|Ride"] = 58.56, ["Neon"] = 11.01, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 441.59, ["Mega"] = 117.6, ["Mega|Ride"] = 124.69, ["Mega|Fly|Ride"] = 305.73}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 52.95, ["Fly"] = 168.05, ["Ride"] = 105, ["Fly|Ride"] = 163.24, ["Neon"] = 359.63, ["Neon|Ride"] = 419.46, ["Mega"] = 2025.11, ["Mega|Ride"] = 2756.25, ["Mega|Fly|Ride"] = 2025.11}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 587.48, ["Ride"] = 45.85, ["Neon"] = 7.76, ["Neon|Ride"] = 57.67, ["Neon|Fly|Ride"] = 116.02, ["Mega"] = 45.94, ["Mega|Fly"] = 216.84, ["Mega|Ride"] = 72.19}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 19.06, ["Ride"] = 19.49, ["Fly|Ride"] = 36.87, ["Neon"] = 8.69, ["Neon|Fly"] = 42, ["Neon|Ride"] = 25.91, ["Neon|Fly|Ride"] = 73.33, ["Mega"] = 59.13, ["Mega|Fly"] = 150.89, ["Mega|Ride"] = 81.37, ["Mega|Fly|Ride"] = 219.43}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 23.87, ["Fly"] = 57.91, ["Ride"] = 37.26, ["Fly|Ride"] = 195.57, ["Neon"] = 81.86, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 196.28, ["Mega"] = 289.47, ["Mega|Ride"] = 275.62, ["Mega|Fly|Ride"] = 355.61}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 5.25, ["Fly"] = 43.38, ["Ride"] = 24.53, ["Fly|Ride"] = 72.19, ["Neon"] = 57.75, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 354.38, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 867.29}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 22.16, ["Fly"] = 48.57, ["Ride"] = 31.83, ["Fly|Ride"] = 65.63, ["Neon"] = 92.32, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 148.43, ["Mega"] = 408.98, ["Mega|Ride"] = 327.44, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 73.5, ["Ride"] = 129.94, ["Fly|Ride"] = 201.66, ["Neon"] = 257.25, ["Neon|Ride"] = 283.49, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 1575, ["Mega|Ride"] = 1645.68, ["Mega|Fly|Ride"] = 1673.87}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 10.06, ["Ride"] = 115.4, ["Fly|Ride"] = 203.44, ["Neon"] = 60.4, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 299.25, ["Mega"] = 210, ["Mega|Fly"] = 576.76, ["Mega|Ride"] = 398.96, ["Mega|Fly|Ride"] = 578.92}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 3.63, ["Ride"] = 29.29, ["Fly|Ride"] = 78.74, ["Neon"] = 20.9, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 164.8, ["Mega|Ride"] = 173.46, ["Mega|Fly|Ride"] = 490.67}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 10.94, ["Fly"] = 135.19, ["Ride"] = 36.37, ["Fly|Ride"] = 164.38, ["Neon"] = 57.63, ["Neon|Ride"] = 61.81, ["Neon|Fly|Ride"] = 175.1, ["Mega"] = 317.63}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 12.48, ["Fly|Ride"] = 41.49, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 15.65, ["Neon|Fly|Ride"] = 55.11, ["Mega"] = 14.44, ["Mega|Fly"] = 42, ["Mega|Ride"] = 28.23, ["Mega|Fly|Ride"] = 115.48}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 42, ["Fly"] = 229.85, ["Ride"] = 102.67, ["Neon"] = 236.25, ["Neon|Fly"] = 2457.67, ["Neon|Ride"] = 294, ["Neon|Fly|Ride"] = 487.87, ["Mega"] = 1081.95, ["Mega|Ride"] = 1097.83, ["Mega|Fly|Ride"] = 905.63}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 24.04, ["Neon"] = 7.55, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 31.5, ["Mega|Ride"] = 87.1, ["Mega|Fly|Ride"] = 313.68}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 29.29, ["Ride"] = 15.75, ["Fly|Ride"] = 45.94, ["Neon"] = 24.94, ["Neon|Ride"] = 27, ["Neon|Fly|Ride"] = 64.31, ["Mega"] = 257.25, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 228.38}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 43.37, ["Fly"] = 108.43, ["Ride"] = 90.56, ["Fly|Ride"] = 199.48, ["Neon"] = 196.88, ["Neon|Ride"] = 261.19, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 836.07, ["Mega|Ride"] = 1145.67, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 72.19, ["Neon"] = 8.89, ["Neon|Ride"] = 1446.21, ["Mega"] = 53.67, ["Mega|Ride"] = 116.81, ["Mega|Fly|Ride"] = 314.89}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 3.2}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 33.29, ["Fly|Ride"] = 72.39, ["Neon"] = 7.8, ["Neon|Ride"] = 84.57, ["Neon|Fly|Ride"] = 115.32, ["Mega"] = 85.32, ["Mega|Ride"] = 105.25, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 131.12, ["Ride"] = 196.07, ["Fly|Ride"] = 313.69, ["Neon"] = 636.39, ["Neon|Ride"] = 580.91, ["Neon|Fly|Ride"] = 678.57, ["Mega"] = 6504.61, ["Mega|Ride"] = 3271.38}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 2.52, ["Ride"] = 36.87, ["Fly|Ride"] = 216.84, ["Neon"] = 23.24, ["Neon|Fly"] = 145.28, ["Neon|Ride"] = 65.06, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 178.48, ["Mega|Ride"] = 223.65, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 99.94, ["Neon"] = 3.84, ["Neon|Ride"] = 20.47, ["Mega"] = 33.63, ["Mega|Ride"] = 71.15, ["Mega|Fly|Ride"] = 346.92}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 3.51, ["Ride"] = 32.82, ["Fly|Ride"] = 131.25, ["Neon"] = 57.36, ["Neon|Ride"] = 89.63, ["Neon|Fly|Ride"] = 160.47, ["Mega"] = 433.65, ["Mega|Ride"] = 419.56, ["Mega|Fly|Ride"] = 665.65}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 9.72, ["Fly"] = 37.31, ["Ride"] = 26.25, ["Fly|Ride"] = 58.54, ["Neon"] = 101.03, ["Neon|Ride"] = 184.42, ["Neon|Fly|Ride"] = 197.54, ["Mega"] = 634.1, ["Mega|Ride"] = 646.14, ["Mega|Fly|Ride"] = 492.19}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 16.28, ["Ride"] = 55.13, ["Fly|Ride"] = 195.16, ["Neon"] = 124.69, ["Neon|Ride"] = 208.16, ["Neon|Fly|Ride"] = 329.59, ["Mega"] = 561.75, ["Mega|Ride"] = 494.04, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 149.62, ["Fly"] = 196.77, ["Ride"] = 191.6, ["Fly|Ride"] = 236.25, ["Neon"] = 570.84, ["Neon|Fly"] = 867.29, ["Neon|Ride"] = 566.9, ["Neon|Fly|Ride"] = 643.02, ["Mega|Ride"] = 2601.86, ["Mega|Fly|Ride"] = 2325.67}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 5.24, ["Fly"] = 20.69, ["Ride"] = 21.86, ["Fly|Ride"] = 42, ["Neon"] = 50.09, ["Neon|Fly"] = 58.56, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 86.63, ["Mega|Fly|Ride"] = 370.26}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.1, ["Fly"] = 131.23, ["Ride"] = 27.78, ["Fly|Ride"] = 65.63, ["Neon"] = 21, ["Neon|Ride"] = 39.34, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 140.11, ["Mega|Ride"] = 188.65, ["Mega|Fly|Ride"] = 291.98}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 3.81, ["Fly"] = 42.78, ["Ride"] = 32.82, ["Fly|Ride"] = 85.32, ["Neon"] = 28.88, ["Neon|Fly"] = 43.38, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 173.46, ["Mega"] = 236.25, ["Mega|Ride"] = 429.85, ["Mega|Fly|Ride"] = 1307.44}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 43.37, ["Fly"] = 110.41, ["Ride"] = 52.41, ["Fly|Ride"] = 134.44, ["Neon"] = 203.44, ["Neon|Fly"] = 170.63, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 336.08, ["Mega"] = 970.29, ["Mega|Ride"] = 925.32, ["Mega|Fly|Ride"] = 958.11}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 13.02, ["Fly"] = 57.75, ["Ride"] = 72.65, ["Neon"] = 185.22, ["Neon|Ride"] = 461.85, ["Neon|Fly|Ride"] = 478.11, ["Mega"] = 809.85, ["Mega|Ride"] = 1932, ["Mega|Fly|Ride"] = 823.94}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 262.5, ["Ride"] = 578.92, ["Neon"] = 1636.31, ["Neon|Ride"] = 3271.38, ["Mega|Fly|Ride"] = 5203.7}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 20.99, ["Fly"] = 58.65, ["Ride"] = 33.91, ["Fly|Ride"] = 69.45, ["Neon"] = 215.9, ["Neon|Ride"] = 129.99, ["Neon|Fly|Ride"] = 201.52, ["Mega"] = 761.25, ["Mega|Ride"] = 753.27, ["Mega|Fly|Ride"] = 823.94}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 43.38, ["Ride"] = 14.3, ["Fly|Ride"] = 70.17, ["Neon"] = 2.51, ["Neon|Ride"] = 15.72, ["Neon|Fly|Ride"] = 53.82, ["Mega"] = 21, ["Mega|Fly"] = 114.93, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 117.47}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 6.55, ["Ride"] = 29.29, ["Neon"] = 15.23, ["Neon|Ride"] = 86.75, ["Neon|Fly|Ride"] = 164.38, ["Mega"] = 111.57, ["Mega|Ride"] = 164.18, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 2.1, ["Ride"] = 24.94, ["Fly|Ride"] = 144.2, ["Neon"] = 21.7, ["Neon|Ride"] = 69.39, ["Neon|Fly|Ride"] = 1181.23, ["Mega"] = 133.87, ["Mega|Fly"] = 575.01, ["Mega|Ride"] = 377.28}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 393.74, ["Fly"] = 505.32, ["Ride"] = 418.69, ["Fly|Ride"] = 568.08, ["Neon"] = 1898.49, ["Neon|Ride"] = 2025.11, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 5493.14}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.63, ["Fly"] = 39.38, ["Ride"] = 16.93, ["Fly|Ride"] = 56.43, ["Neon"] = 20.61, ["Neon|Ride"] = 33.13, ["Neon|Fly|Ride"] = 111.13, ["Mega"] = 221.61, ["Mega|Ride"] = 195.16, ["Mega|Fly|Ride"] = 231}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 3.49, ["Fly"] = 22.32, ["Ride"] = 19.64, ["Fly|Ride"] = 42.95, ["Neon"] = 43.25, ["Neon|Fly"] = 156.45, ["Neon|Ride"] = 58.56, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 181.56, ["Mega|Ride"] = 289.47, ["Mega|Fly|Ride"] = 302.55}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 2.59, ["Fly"] = 45.82, ["Ride"] = 26.25, ["Fly|Ride"] = 52.5, ["Neon"] = 13.55, ["Neon|Fly"] = 94.48, ["Neon|Ride"] = 42.14, ["Neon|Fly|Ride"] = 113.19, ["Mega"] = 98.44, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 272.12}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 29.28, ["Fly"] = 57.67, ["Ride"] = 31.5, ["Fly|Ride"] = 78.75, ["Neon"] = 220.4, ["Neon|Ride"] = 209.99, ["Neon|Fly|Ride"] = 324.16, ["Mega"] = 1300.93, ["Mega|Ride"] = 862.32, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 51.19, ["Fly|Ride"] = 51.75, ["Neon"] = 11.71, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 210, ["Mega"] = 165.4, ["Mega|Ride"] = 457.79, ["Mega|Fly|Ride"] = 985.04}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 7.87, ["Fly"] = 787.5, ["Ride"] = 72.65, ["Neon"] = 170.62, ["Neon|Ride"] = 246.11, ["Mega"] = 748.13, ["Mega|Fly|Ride"] = 789.25}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 31.4, ["Neon"] = 4.41, ["Neon|Ride"] = 28.25, ["Neon|Fly|Ride"] = 115.32, ["Mega"] = 55.11, ["Mega|Ride"] = 145.28, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 7.77, ["Fly"] = 72.19, ["Ride"] = 24.26, ["Neon"] = 50.87, ["Mega"] = 136.02, ["Mega|Ride"] = 327.52, ["Mega|Fly|Ride"] = 761.92}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 5.79, ["Ride"] = 33.13, ["Neon"] = 71.56, ["Neon|Ride"] = 289.47, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 319.82, ["Mega|Ride"] = 562.67, ["Mega|Fly|Ride"] = 463.32}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 7.88, ["Fly"] = 37.96, ["Ride"] = 30.59, ["Fly|Ride"] = 56.39, ["Neon"] = 41.1, ["Neon|Fly"] = 115.32, ["Neon|Ride"] = 56.32, ["Neon|Fly|Ride"] = 120.75, ["Mega"] = 540.99, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 432.32}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 476.44, ["Fly"] = 542.07, ["Ride"] = 430.5, ["Fly|Ride"] = 485.63, ["Neon"] = 1642.41, ["Neon|Ride"] = 1881.64, ["Neon|Fly|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 7458.62}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 18.14, ["Fly|Ride"] = 39.37, ["Neon"] = 29.45, ["Neon|Fly"] = 82.21, ["Neon|Ride"] = 32.29, ["Neon|Fly|Ride"] = 164.73, ["Mega"] = 243.94, ["Mega|Ride"] = 196.77, ["Mega|Fly|Ride"] = 307.9}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 9.91, ["Fly"] = 65.06, ["Ride"] = 75.48, ["Fly|Ride"] = 188.64, ["Neon"] = 65.63, ["Neon|Ride"] = 127.95, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 359.63, ["Mega|Fly"] = 723.11, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 615.79}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 27.2, ["Ride"] = 78.75, ["Fly|Ride"] = 241.64, ["Neon"] = 78.75, ["Neon|Ride"] = 213.94, ["Neon|Fly|Ride"] = 350.44, ["Mega"] = 346.92, ["Mega|Ride"] = 433.65, ["Mega|Fly|Ride"] = 485.63}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 56.41, ["Fly"] = 156.1, ["Ride"] = 84, ["Fly|Ride"] = 124.69, ["Neon"] = 318.34, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 380.63, ["Mega"] = 2517.26, ["Mega|Ride"] = 2890.86, ["Mega|Fly|Ride"] = 1848.51}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 10.34, ["Ride"] = 46.1, ["Fly|Ride"] = 162.64, ["Neon"] = 35.6, ["Neon|Ride"] = 95.8, ["Neon|Fly|Ride"] = 268.87, ["Mega"] = 165.16, ["Mega|Ride"] = 194.04, ["Mega|Fly|Ride"] = 428.24}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 21.7, ["Ride"] = 17.07, ["Fly|Ride"] = 57.87, ["Neon"] = 18.21, ["Neon|Ride"] = 33.53, ["Neon|Fly|Ride"] = 145.28, ["Mega"] = 102.38, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 6.51, ["Ride"] = 45.57, ["Neon"] = 19.68, ["Neon|Ride"] = 102.38, ["Neon|Fly|Ride"] = 174.57, ["Mega"] = 94.5, ["Mega|Fly"] = 246.11, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 282.35}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 43.32, ["Fly"] = 183.72, ["Ride"] = 107.33, ["Fly|Ride"] = 197.64, ["Neon"] = 118.12, ["Neon|Ride"] = 161.44, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 388.49, ["Mega|Ride"] = 446.15, ["Mega|Fly|Ride"] = 534.19}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.1, ["Ride"] = 85.28, ["Neon"] = 9.08, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 232.02, ["Mega"] = 52.5, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 289.47}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 19.52, ["Ride"] = 140.95, ["Neon"] = 115.5, ["Neon|Ride"] = 374.06, ["Mega"] = 590.63, ["Mega|Ride"] = 763.22, ["Mega|Fly|Ride"] = 752.38}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 951.56, ["Fly"] = 1194.38, ["Ride"] = 1008, ["Fly|Ride"] = 1017.17, ["Neon"] = 4336.41, ["Neon|Ride"] = 3150, ["Neon|Fly|Ride"] = 3740.16, ["Mega|Fly|Ride"] = 11101.19}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 15.6, ["Fly"] = 113.3, ["Ride"] = 62.9, ["Fly|Ride"] = 179.1, ["Neon"] = 65.62, ["Neon|Fly"] = 722.03, ["Neon|Ride"] = 116.02, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 259.87, ["Mega|Ride"] = 301.88}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.1, ["Fly"] = 49.87, ["Ride"] = 27.57, ["Fly|Ride"] = 94.42, ["Neon"] = 11.82, ["Neon|Fly"] = 79.83, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 89.25, ["Mega"] = 64.31, ["Mega|Ride"] = 92.54, ["Mega|Fly|Ride"] = 324.16}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 11.82, ["Ride"] = 131.25, ["Fly|Ride"] = 145.28, ["Neon"] = 63, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 385.89, ["Mega"] = 288.73, ["Mega|Ride"] = 430.61, ["Mega|Fly|Ride"] = 924}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 23.63, ["Fly|Ride"] = 187.69, ["Neon"] = 2.63, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 19.49, ["Mega|Ride"] = 47.24, ["Mega|Fly|Ride"] = 118.12}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 53.82, ["Fly"] = 130.11, ["Ride"] = 102.29, ["Fly|Ride"] = 266.43, ["Neon"] = 220.48, ["Neon|Fly"] = 354.38, ["Neon|Ride"] = 262.5, ["Mega"] = 923.6, ["Mega|Ride"] = 879.38, ["Mega|Fly|Ride"] = 934.5}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 10.49, ["Ride"] = 62.89, ["Fly|Ride"] = 286.57, ["Neon"] = 154.88, ["Neon|Ride"] = 143.12, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 419.56, ["Mega|Ride"] = 847.79, ["Mega|Fly|Ride"] = 813.09}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2.1, ["Ride"] = 23.2, ["Neon"] = 11.78, ["Neon|Ride"] = 40.99, ["Neon|Fly|Ride"] = 216.84, ["Mega"] = 98.14, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 376.2}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 16.06, ["Fly"] = 160.47, ["Ride"] = 41.21, ["Fly|Ride"] = 95.96, ["Neon"] = 81.26, ["Neon|Ride"] = 95.7, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 409.17, ["Mega|Ride"] = 419.99, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 4.94, ["Fly"] = 97.59, ["Ride"] = 23.63, ["Fly|Ride"] = 173.45, ["Neon"] = 28.17, ["Neon|Fly"] = 131.27, ["Neon|Ride"] = 57.75, ["Neon|Fly|Ride"] = 144.19, ["Mega"] = 365.54, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 430.5}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 32.82, ["Ride"] = 91.88, ["Neon"] = 253.7, ["Neon|Ride"] = 260.21, ["Neon|Fly|Ride"] = 578.92, ["Mega"] = 2530.31, ["Mega|Ride"] = 2453.24, ["Mega|Fly|Ride"] = 2166.05}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 2.98, ["Fly|Ride"] = 170.63, ["Neon"] = 15.65, ["Neon|Ride"] = 85.87, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 69.39, ["Mega|Ride"] = 111.55, ["Mega|Fly|Ride"] = 256.76}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 5.06, ["Ride"] = 24.54, ["Fly|Ride"] = 90.57, ["Neon"] = 48.45, ["Neon|Fly"] = 188.65, ["Neon|Ride"] = 69.93, ["Neon|Fly|Ride"] = 118.02, ["Mega"] = 299.95, ["Mega|Ride"] = 344.76, ["Mega|Fly|Ride"] = 290.07}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 120.54, ["Fly"] = 393.75, ["Ride"] = 157.49, ["Fly|Ride"] = 260.19, ["Neon"] = 479.07, ["Neon|Ride"] = 543.38, ["Neon|Fly|Ride"] = 669.38, ["Mega|Ride"] = 1834.96, ["Mega|Fly|Ride"] = 2106}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 23.39, ["Ride"] = 18.25, ["Fly|Ride"] = 43.32, ["Neon"] = 21, ["Neon|Fly"] = 57.32, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 71.39, ["Mega"] = 137.82, ["Mega|Ride"] = 163.03, ["Mega|Fly|Ride"] = 182.44}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 20.97, ["Fly"] = 85.32, ["Ride"] = 72.65, ["Fly|Ride"] = 116.02, ["Neon"] = 141.75, ["Neon|Ride"] = 179.71, ["Neon|Fly|Ride"] = 261.19, ["Mega"] = 578.92, ["Mega|Ride"] = 485.63, ["Mega|Fly|Ride"] = 707.44}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 14.84, ["Fly|Ride"] = 64.3, ["Neon"] = 2.1, ["Neon|Fly"] = 28.82, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 43.38, ["Mega"] = 19.53, ["Mega|Ride"] = 31.5, ["Mega|Fly|Ride"] = 70.94}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 58.56, ["Neon"] = 2.63, ["Neon|Ride"] = 43.38, ["Neon|Fly|Ride"] = 130.11, ["Mega"] = 19.69, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 65.63}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.1, ["Fly"] = 36.85, ["Ride"] = 24.69, ["Fly|Ride"] = 173.36, ["Neon"] = 15, ["Neon|Ride"] = 58.56, ["Neon|Fly|Ride"] = 136.61, ["Mega"] = 105, ["Mega|Ride"] = 289.47, ["Mega|Fly|Ride"] = 246.1}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 31.79, ["Fly|Ride"] = 131.25, ["Neon"] = 132.56, ["Neon|Ride"] = 346.92, ["Neon|Fly|Ride"] = 399.37, ["Mega"] = 511.88, ["Mega|Ride"] = 649.39, ["Mega|Fly|Ride"] = 867.29}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.1, ["Fly"] = 19.64, ["Ride"] = 17.06, ["Fly|Ride"] = 36.75, ["Neon"] = 12.8, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 57.88, ["Mega"] = 120.75, ["Mega|Fly"] = 267.22, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 7.28, ["Fly"] = 48.09, ["Ride"] = 43.32, ["Fly|Ride"] = 96.79, ["Neon"] = 52.41, ["Neon|Fly"] = 110.25, ["Neon|Ride"] = 55.02, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 338.12, ["Mega|Fly"] = 441.59, ["Mega|Ride"] = 262.48, ["Mega|Fly|Ride"] = 347.82}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Fly"] = 16.71, ["Ride"] = 16.28, ["Fly|Ride"] = 68.61, ["Neon"] = 8.05, ["Neon|Fly"] = 98.42, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 72.45, ["Mega"] = 36.92, ["Mega|Fly"] = 220.4, ["Mega|Ride"] = 63, ["Mega|Fly|Ride"] = 144.23}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 11.34, ["Fly"] = 163.71, ["Ride"] = 24.93, ["Fly|Ride"] = 217.2, ["Neon"] = 37.7, ["Neon|Ride"] = 91.08, ["Neon|Fly|Ride"] = 289.47, ["Mega"] = 324.16, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 405.46}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 5.25, ["Ride"] = 189.93, ["Fly|Ride"] = 65.63, ["Neon"] = 45.94, ["Neon|Fly"] = 101.07, ["Neon|Ride"] = 216.84, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 236.25, ["Mega|Ride"] = 303.19, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 3.84, ["Fly"] = 39.79, ["Ride"] = 19.63, ["Fly|Ride"] = 50.45, ["Neon"] = 35.93, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 39.44, ["Neon|Fly|Ride"] = 145.3, ["Mega"] = 262.5, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 157.5}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 16.86, ["Ride"] = 14.81, ["Fly|Ride"] = 52.56, ["Neon"] = 16.28, ["Neon|Fly"] = 70.51, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 82.69, ["Mega"] = 164.38, ["Mega|Ride"] = 98.15, ["Mega|Fly|Ride"] = 288.39}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 196.88, ["Fly"] = 393.75, ["Ride"] = 262.5, ["Fly|Ride"] = 392.44, ["Neon"] = 1257.57, ["Neon|Ride"] = 1286.84, ["Neon|Fly|Ride"] = 1174.69, ["Mega"] = 4252.67, ["Mega|Fly|Ride"] = 4117.32}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 2.62, ["Ride"] = 105, ["Neon"] = 35.7, ["Neon|Ride"] = 45.94, ["Mega"] = 123.38, ["Mega|Ride"] = 655.03, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 3.88, ["Fly"] = 108.43, ["Ride"] = 24.94, ["Fly|Ride"] = 86.75, ["Neon"] = 31.2, ["Neon|Fly"] = 246.11, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 233.84, ["Mega|Ride"] = 196.87, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 3.63, ["Fly|Ride"] = 723.11, ["Neon"] = 45.84, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 603.74, ["Mega"] = 204.1, ["Mega|Ride"] = 409.7, ["Mega|Fly|Ride"] = 416.73}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 16.17, ["Ride"] = 16.24, ["Fly|Ride"] = 28.88, ["Neon"] = 2.1, ["Neon|Fly"] = 43.38, ["Neon|Ride"] = 15.1, ["Neon|Fly|Ride"] = 32.82, ["Mega"] = 26.25, ["Mega|Fly"] = 81.33, ["Mega|Ride"] = 28.87, ["Mega|Fly|Ride"] = 72.19}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.1, ["Fly"] = 44.88, ["Ride"] = 22.66, ["Fly|Ride"] = 103.63, ["Neon"] = 14.43, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 49.87, ["Mega"] = 132.57, ["Mega|Ride"] = 200.54, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.63, ["Ride"] = 119.85, ["Neon"] = 10.23, ["Neon|Ride"] = 289.47, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 52.5, ["Mega|Fly"] = 145.28, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 289.47}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 82.69, ["Fly"] = 104.99, ["Ride"] = 89.8, ["Fly|Ride"] = 150.94, ["Neon"] = 315, ["Neon|Fly"] = 720.03, ["Neon|Ride"] = 409.4, ["Neon|Fly|Ride"] = 425.25, ["Mega|Ride"] = 3615.48}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 3.62, ["Fly"] = 72.65, ["Ride"] = 23.87, ["Fly|Ride"] = 58.55, ["Neon"] = 22.08, ["Neon|Ride"] = 68.16, ["Mega"] = 169.3, ["Mega|Ride"] = 213.94}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 49.88, ["Ride"] = 34.13, ["Neon"] = 8.69, ["Neon|Ride"] = 177.06, ["Neon|Fly|Ride"] = 550.76, ["Mega"] = 56.35, ["Mega|Fly"] = 314.99, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 36.75, ["Fly"] = 145.28, ["Ride"] = 84, ["Fly|Ride"] = 174.57, ["Neon"] = 150.94, ["Neon|Ride"] = 174.83, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 551.25, ["Mega|Ride"] = 636.56, ["Mega|Fly|Ride"] = 748.13}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 23.87, ["Ride"] = 13.13, ["Fly|Ride"] = 33.63, ["Neon"] = 2.1, ["Neon|Fly"] = 22.19, ["Neon|Ride"] = 15.82, ["Neon|Fly|Ride"] = 34.7, ["Mega"] = 18.3, ["Mega|Fly"] = 49.88, ["Mega|Ride"] = 32.82, ["Mega|Fly|Ride"] = 61.69}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Fly|Ride"] = 93.26, ["Neon"] = 2.63, ["Neon|Ride"] = 30.18, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 24.94, ["Mega|Fly"] = 145.28, ["Mega|Ride"] = 78.66, ["Mega|Fly|Ride"] = 288.39}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 105, ["Fly|Ride"] = 161.44, ["Neon"] = 8.93, ["Neon|Ride"] = 91.77, ["Neon|Fly|Ride"] = 288.65, ["Mega"] = 62.39, ["Mega|Fly"] = 188.65, ["Mega|Ride"] = 125.81, ["Mega|Fly|Ride"] = 300.57}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 7.14, ["Fly"] = 86.75, ["Ride"] = 39.89, ["Fly|Ride"] = 132.2, ["Neon"] = 22.32, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 86.75, ["Neon|Fly|Ride"] = 159.7, ["Mega"] = 139.13, ["Mega|Fly"] = 332.83, ["Mega|Ride"] = 250.44, ["Mega|Fly|Ride"] = 311.06}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 18.8, ["Ride"] = 13.49, ["Fly|Ride"] = 43.38, ["Neon"] = 2.1, ["Neon|Fly"] = 24.94, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 18.8, ["Mega|Ride"] = 78.66, ["Mega|Fly|Ride"] = 117.8}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 20.31, ["Fly"] = 131.25, ["Ride"] = 53.27, ["Neon"] = 129.75, ["Neon|Ride"] = 202.57, ["Neon|Fly|Ride"] = 374.07, ["Mega|Ride"] = 590.63}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2601.55, ["Fly"] = 3150, ["Ride"] = 2205, ["Fly|Ride"] = 2165.62, ["Neon|Fly|Ride"] = 7415.63, ["Mega|Fly|Ride"] = 44990.14}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 17.06, ["Fly|Ride"] = 53.44, ["Neon"] = 7.22, ["Neon|Fly"] = 34.13, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 65.07, ["Mega"] = 103.69, ["Mega|Fly"] = 433.65, ["Mega|Ride"] = 89.23, ["Mega|Fly|Ride"] = 175.88}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.1, ["Ride"] = 28.21, ["Neon"] = 9.09, ["Mega"] = 98.66, ["Mega|Fly"] = 441, ["Mega|Fly|Ride"] = 490.67}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 13.12, ["Fly"] = 105, ["Ride"] = 36.86, ["Fly|Ride"] = 157.5, ["Neon"] = 82.21, ["Neon|Fly"] = 103.01, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 216.84, ["Mega"] = 431.82, ["Mega|Ride"] = 405.46, ["Mega|Fly|Ride"] = 686.93}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 27.57, ["Fly"] = 108.43, ["Ride"] = 68.27, ["Neon"] = 140.44, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 164.38, ["Mega"] = 541.71, ["Mega|Ride"] = 622.3, ["Mega|Fly|Ride"] = 687.33}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 143.71, ["Fly"] = 1446.21, ["Ride"] = 157.5, ["Fly|Ride"] = 242.82, ["Neon"] = 647.07, ["Neon|Ride"] = 758.96, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 6504.61}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 5.91, ["Ride"] = 65.54, ["Fly|Ride"] = 675.94, ["Neon"] = 15.75, ["Neon|Ride"] = 72.65, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 144.45, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 433.65}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 36.87, ["Neon"] = 15.33, ["Neon|Fly"] = 94.33, ["Neon|Ride"] = 114.85, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 179.82, ["Mega|Ride"] = 330.65, ["Mega|Fly|Ride"] = 267.09}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Fly"] = 101.92, ["Ride"] = 29.44, ["Fly|Ride"] = 72.65, ["Neon"] = 10.5, ["Neon|Fly"] = 127.95, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 62.9, ["Mega|Ride"] = 123.38}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 14.23, ["Ride"] = 70.74, ["Fly|Ride"] = 131.25, ["Neon"] = 121.84, ["Neon|Ride"] = 181.56, ["Neon|Fly|Ride"] = 364.88, ["Mega"] = 433.65, ["Mega|Ride"] = 475.13, ["Mega|Fly|Ride"] = 571.6}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Neon"] = 2.57, ["Neon|Ride"] = 20.37, ["Mega"] = 26.25, ["Mega|Fly"] = 122.68, ["Mega|Ride"] = 81.08, ["Mega|Fly|Ride"] = 135.19}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 97.89, ["Fly"] = 202.74, ["Ride"] = 114.93, ["Fly|Ride"] = 144.27, ["Neon"] = 304.5, ["Neon|Fly"] = 464.02, ["Neon|Ride"] = 407.38, ["Neon|Fly|Ride"] = 450.18, ["Mega"] = 3252.32, ["Mega|Fly|Ride"] = 1344.3}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Fly"] = 41.72, ["Ride"] = 91.85, ["Neon"] = 10.49, ["Neon|Ride"] = 144.65, ["Neon|Fly|Ride"] = 216.84, ["Mega"] = 63, ["Mega|Ride"] = 288.39, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 38.07, ["Fly"] = 105, ["Ride"] = 91.88, ["Fly|Ride"] = 101.92, ["Neon"] = 230.9, ["Neon|Ride"] = 428.24, ["Neon|Fly|Ride"] = 378, ["Mega"] = 2625}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 63.98, ["Ride"] = 18.38, ["Fly|Ride"] = 52.77, ["Neon"] = 4.13, ["Neon|Fly"] = 85.87, ["Neon|Ride"] = 72.65, ["Neon|Fly|Ride"] = 116.02, ["Mega"] = 61.69, ["Mega|Fly"] = 147.2, ["Mega|Ride"] = 103.69, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Neon"] = 6.57, ["Neon|Ride"] = 115.5, ["Mega"] = 42.3, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 173.46, ["Mega|Fly|Ride"] = 405.46}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 5.19, ["Fly"] = 77.44, ["Ride"] = 32.54, ["Fly|Ride"] = 90.57, ["Neon"] = 25.47, ["Neon|Ride"] = 65.63, ["Mega"] = 157.5, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 576.76}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 360.94, ["Fly"] = 499.25, ["Ride"] = 419.98, ["Fly|Ride"] = 640.5, ["Neon"] = 1063.49, ["Neon|Ride"] = 980.44, ["Neon|Fly|Ride"] = 1115.62, ["Mega"] = 3128.73, ["Mega|Ride"] = 3130.32, ["Mega|Fly|Ride"] = 3180.76}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 29.28, ["Fly"] = 86.75, ["Ride"] = 47.25, ["Fly|Ride"] = 98.67, ["Neon"] = 156.1, ["Neon|Ride"] = 242.89, ["Neon|Fly|Ride"] = 285.13, ["Mega|Ride"] = 1239.14, ["Mega|Fly|Ride"] = 867.29}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.63, ["Fly"] = 61.62, ["Ride"] = 32.8, ["Fly|Ride"] = 116.18, ["Neon"] = 24.69, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 53.82, ["Neon|Fly|Ride"] = 131.06, ["Mega"] = 169.32, ["Mega|Ride"] = 262.48, ["Mega|Fly|Ride"] = 282.76}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 21.7, ["Fly"] = 131.25, ["Ride"] = 49.88, ["Fly|Ride"] = 149.63, ["Neon"] = 73.5, ["Neon|Fly"] = 177.19, ["Neon|Ride"] = 136.61, ["Neon|Fly|Ride"] = 216.84, ["Mega"] = 301.88, ["Mega|Fly"] = 1009.52, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 509.25}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 6.72, ["Ride"] = 23.61, ["Neon"] = 101.36, ["Neon|Ride"] = 121.45, ["Neon|Fly|Ride"] = 490.67, ["Mega"] = 655.03, ["Mega|Ride"] = 692.75, ["Mega|Fly|Ride"] = 311.07}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.8, ["Neon"] = 23.62, ["Neon|Ride"] = 157.5, ["Mega"] = 108.94, ["Mega|Ride"] = 332.83}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 3.06, ["Fly"] = 72.65, ["Ride"] = 22.32, ["Fly|Ride"] = 62.97, ["Neon"] = 57.75, ["Neon|Fly"] = 94.33, ["Neon|Ride"] = 116.02, ["Neon|Fly|Ride"] = 212.14, ["Mega"] = 223.13, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 105, ["Fly"] = 245.34, ["Ride"] = 120.75, ["Fly|Ride"] = 196.88, ["Neon"] = 393.75, ["Neon|Ride"] = 523.68, ["Neon|Fly|Ride"] = 524.98, ["Mega"] = 2887.5, ["Mega|Ride"] = 2625, ["Mega|Fly|Ride"] = 3271.38}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 24.92, ["Ride"] = 55.56, ["Fly|Ride"] = 144.63, ["Neon"] = 118.12, ["Neon|Ride"] = 171.3, ["Neon|Fly|Ride"] = 194.25, ["Mega"] = 1156.75, ["Mega|Ride"] = 1156.75}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2034.38, ["Fly"] = 2311.32, ["Ride"] = 1968.75, ["Fly|Ride"] = 1967.44, ["Neon"] = 11564.11, ["Neon|Fly|Ride"] = 7019.25, ["Mega|Fly|Ride"] = 24675}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 5.2, ["Fly"] = 65625, ["Ride"] = 72.19, ["Fly|Ride"] = 196.87, ["Neon"] = 18.38, ["Neon|Ride"] = 62.23, ["Mega"] = 143.07, ["Mega|Fly"] = 786.19, ["Mega|Ride"] = 209.35}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 10.4, ["Ride"] = 58.56, ["Fly|Ride"] = 130.11, ["Neon"] = 24.61, ["Neon|Ride"] = 90.09, ["Mega"] = 144.37, ["Mega|Ride"] = 232.02}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 879.27, ["Fly"] = 1503.66, ["Ride"] = 918.75, ["Fly|Ride"] = 1002.75, ["Neon"] = 3271.38, ["Neon|Ride"] = 2572.76, ["Neon|Fly|Ride"] = 3150, ["Mega|Ride"] = 13902.41}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 20.99, ["Ride"] = 52.5, ["Fly|Ride"] = 173.35, ["Neon"] = 232.02, ["Neon|Ride"] = 302.3, ["Mega"] = 857.2, ["Mega|Ride"] = 975.71, ["Mega|Fly|Ride"] = 835.42}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 3.47, ["Ride"] = 21.79, ["Fly|Ride"] = 118.13, ["Neon"] = 10.63, ["Neon|Ride"] = 64.84, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 157.5, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 145.28, ["Neon"] = 3.94, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 49.32, ["Neon|Fly|Ride"] = 112.76, ["Mega"] = 23.22, ["Mega|Ride"] = 61.31, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 91.83, ["Ride"] = 120.51, ["Fly|Ride"] = 170.63, ["Neon"] = 459.38, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 640.5, ["Mega"] = 2453.24, ["Mega|Fly|Ride"] = 2313.48}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 3.81, ["Ride"] = 34.7, ["Fly|Ride"] = 75.9, ["Neon"] = 12.79, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 90.57, ["Mega|Ride"] = 122.07, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 76.28, ["Fly"] = 151.79, ["Ride"] = 102.1, ["Fly|Ride"] = 289.47, ["Neon"] = 433.65, ["Neon|Ride"] = 721.88, ["Mega|Fly|Ride"] = 1768.79}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 3.29, ["Fly"] = 55.3, ["Fly|Ride"] = 130.11, ["Neon"] = 59.07, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 269.06, ["Mega"] = 328.02, ["Mega|Ride"] = 319.82}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 246.64, ["Fly"] = 284.82, ["Ride"] = 296.39, ["Fly|Ride"] = 315, ["Neon"] = 1137.32, ["Neon|Ride"] = 1155.68, ["Neon|Fly|Ride"] = 879.38}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 2.1, ["Fly"] = 59.07, ["Ride"] = 22.31, ["Fly|Ride"] = 115.4, ["Neon"] = 38.07, ["Neon|Ride"] = 65.54, ["Neon|Fly|Ride"] = 114.19, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 23.21, ["Ride"] = 15.74, ["Fly|Ride"] = 49.85, ["Neon"] = 3.94, ["Neon|Fly"] = 37.97, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 57.66, ["Mega"] = 42, ["Mega|Ride"] = 71.86, ["Mega|Fly|Ride"] = 126}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 1446.04, ["Ride"] = 1050, ["Fly|Ride"] = 1254.75, ["Neon|Ride"] = 7950.8, ["Neon|Fly|Ride"] = 7046.67, ["Mega"] = 24532.2, ["Mega|Fly|Ride"] = 19513.8}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 14.43, ["Ride"] = 71.52, ["Fly|Ride"] = 202.74, ["Neon"] = 103.56, ["Neon|Ride"] = 314.98, ["Mega"] = 320.25, ["Mega|Ride"] = 436, ["Mega|Fly|Ride"] = 564.27}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 6.2, ["Fly"] = 54.9, ["Ride"] = 39.37, ["Fly|Ride"] = 80.75, ["Neon"] = 24.94, ["Neon|Fly"] = 103.01, ["Neon|Ride"] = 55.55, ["Neon|Fly|Ride"] = 130.11, ["Mega"] = 201.66, ["Mega|Ride"] = 179.45, ["Mega|Fly|Ride"] = 287.09}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 27.56, ["Fly"] = 39.85, ["Ride"] = 40.69, ["Fly|Ride"] = 80.07, ["Neon"] = 241.64, ["Neon|Ride"] = 144.8, ["Neon|Fly|Ride"] = 189.09, ["Mega"] = 2601.86, ["Mega|Ride"] = 1145.67, ["Mega|Fly|Ride"] = 696.55}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 8.84, ["Fly"] = 71.56, ["Ride"] = 27.57, ["Fly|Ride"] = 94.27, ["Neon"] = 59.07, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 367.5, ["Mega|Ride"] = 282.19, ["Mega|Fly|Ride"] = 431.71}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 77.9, ["Ride"] = 145.27, ["Fly|Ride"] = 644.01, ["Neon"] = 273, ["Neon|Fly"] = 490.03, ["Neon|Ride"] = 433.65, ["Mega"] = 1012.56, ["Mega|Ride"] = 1080.86, ["Mega|Fly|Ride"] = 1200.12}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 116.61, ["Neon"] = 2.1, ["Neon|Fly"] = 54.71, ["Neon|Ride"] = 100.04, ["Neon|Fly|Ride"] = 108.43, ["Mega"] = 17.07, ["Mega|Ride"] = 46.64, ["Mega|Fly|Ride"] = 203.44}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 82.1, ["Fly"] = 129.67, ["Ride"] = 123.43, ["Fly|Ride"] = 177.19, ["Neon"] = 573.02, ["Neon|Fly"] = 655.03, ["Neon|Ride"] = 478.05, ["Neon|Fly|Ride"] = 633.11, ["Mega"] = 2168.21, ["Mega|Fly|Ride"] = 1934.05}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.1, ["Fly"] = 144.38, ["Ride"] = 19.69, ["Fly|Ride"] = 67.36, ["Neon"] = 198.19, ["Neon|Ride"] = 83.99, ["Mega"] = 773.71, ["Mega|Ride"] = 437.73, ["Mega|Fly|Ride"] = 490.88}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 18.38, ["Fly|Ride"] = 39.34, ["Neon"] = 13.13, ["Neon|Fly"] = 82.21, ["Neon|Ride"] = 72.65, ["Neon|Fly|Ride"] = 122.85, ["Mega|Ride"] = 275.07, ["Mega|Fly|Ride"] = 269.07}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 2.1, ["Ride"] = 126, ["Neon"] = 21.7, ["Neon|Fly"] = 143.12, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 214.76}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 83.95, ["Ride"] = 223.13, ["Fly|Ride"] = 414.15, ["Neon"] = 363.32, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 549.65, ["Neon|Fly|Ride"] = 969.94, ["Mega"] = 1879.84, ["Mega|Ride"] = 1680, ["Mega|Fly|Ride"] = 1758.75}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 3.78, ["Fly|Ride"] = 433.65, ["Neon"] = 20.3, ["Neon|Ride"] = 59.07, ["Mega"] = 115.32, ["Mega|Ride"] = 158.29, ["Mega|Fly|Ride"] = 327.52}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 38.18, ["Neon"] = 2.1, ["Neon|Ride"] = 101.92, ["Mega"] = 16.78, ["Mega|Ride"] = 215.15, ["Mega|Fly|Ride"] = 196.64}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 102.94, ["Ride"] = 32.82, ["Fly|Ride"] = 144.44, ["Neon"] = 2.1, ["Neon|Fly"] = 86.2, ["Neon|Ride"] = 31.5, ["Mega"] = 21, ["Mega|Fly"] = 56.52, ["Mega|Ride"] = 46.62, ["Mega|Fly|Ride"] = 145.28}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 36.74, ["Ride"] = 18.41, ["Fly|Ride"] = 52.47, ["Neon"] = 6.08, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 29.29, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 63, ["Mega|Ride"] = 101.91, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 115.49, ["Neon"] = 27.57, ["Neon|Ride"] = 131.27, ["Mega"] = 118.13, ["Mega|Ride"] = 130.11, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 39.36, ["Ride"] = 17.1, ["Fly|Ride"] = 36.98, ["Neon"] = 16.16, ["Neon|Fly"] = 86.75, ["Neon|Ride"] = 40.68, ["Neon|Fly|Ride"] = 82.21, ["Mega"] = 196.88, ["Mega|Ride"] = 142.04, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 53.82, ["Ride"] = 110.25, ["Fly|Ride"] = 216.84, ["Neon"] = 288.26, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 1084.12, ["Mega"] = 656.25, ["Mega|Ride"] = 708.75, ["Mega|Fly|Ride"] = 1145.67}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 16.96, ["Ride"] = 15.75, ["Fly|Ride"] = 43.16, ["Neon"] = 2.1, ["Neon|Fly"] = 32.45, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 43.32, ["Mega"] = 19.69, ["Mega|Ride"] = 42.3, ["Mega|Fly|Ride"] = 99.33}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 6.57, ["Fly"] = 28.77, ["Ride"] = 30.19, ["Fly|Ride"] = 71.8, ["Neon"] = 32.81, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 136.86, ["Mega"] = 301.88, ["Mega|Fly"] = 578.92, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 311.07}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 23.36, ["Fly"] = 55.13, ["Ride"] = 51.36, ["Fly|Ride"] = 111.57, ["Neon"] = 135.18, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 160.47, ["Neon|Fly|Ride"] = 203.43, ["Mega"] = 1300.93, ["Mega|Ride"] = 433.65, ["Mega|Fly|Ride"] = 620.81}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 9.75, ["Fly"] = 196.88, ["Fly|Ride"] = 67.24, ["Neon"] = 85.31, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 147.2, ["Mega"] = 537.05, ["Mega|Ride"] = 665.65, ["Mega|Fly|Ride"] = 362.11}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 18.43, ["Ride"] = 16.28, ["Fly|Ride"] = 32.93, ["Neon"] = 3.93, ["Neon|Fly"] = 28.11, ["Neon|Ride"] = 25.12, ["Neon|Fly|Ride"] = 69.57, ["Mega"] = 45.93, ["Mega|Fly"] = 89.25, ["Mega|Ride"] = 61.69, ["Mega|Fly|Ride"] = 122.07}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 5.15, ["Fly"] = 52.5, ["Ride"] = 38.07, ["Neon"] = 75.54, ["Neon|Ride"] = 134.44, ["Neon|Fly|Ride"] = 1168.13, ["Mega"] = 326.82, ["Mega|Fly"] = 371.86, ["Mega|Ride"] = 364.28, ["Mega|Fly|Ride"] = 568.08}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 983.07, ["Fly"] = 1390.99, ["Ride"] = 1002.75, ["Fly|Ride"] = 1064.44, ["Neon|Ride"] = 2744.44, ["Neon|Fly|Ride"] = 2165.63, ["Mega|Fly|Ride"] = 7199.07}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 170.63, ["Ride"] = 262.5, ["Fly|Ride"] = 393.75, ["Neon"] = 840, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 1012.56, ["Mega"] = 6504.61, ["Mega|Ride"] = 3758.58, ["Mega|Fly|Ride"] = 3469.13}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 392.44, ["Neon"] = 8.76, ["Neon|Ride"] = 111.55, ["Neon|Fly|Ride"] = 259.11, ["Mega"] = 78.52, ["Mega|Fly|Ride"] = 1156.75}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 91.88, ["Fly"] = 131.25, ["Ride"] = 196.66, ["Fly|Ride"] = 361.8, ["Neon"] = 615.57, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 792.62, ["Mega"] = 2617.6, ["Mega|Ride"] = 2564.63, ["Mega|Fly|Ride"] = 1916.25}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 2.57, ["Fly"] = 41.21, ["Ride"] = 19.94, ["Fly|Ride"] = 78.75, ["Neon"] = 14.56, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 38.88, ["Neon|Fly|Ride"] = 289.47, ["Mega"] = 115.96, ["Mega|Ride"] = 490.67, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 223.12, ["Fly"] = 433.65, ["Ride"] = 315, ["Fly|Ride"] = 428.24, ["Neon"] = 1447.42, ["Neon|Ride"] = 1431.03, ["Neon|Fly|Ride"] = 1373.56, ["Mega|Fly|Ride"] = 4906.46}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 77.18, ["Ride"] = 42.3, ["Fly|Ride"] = 225.5, ["Neon"] = 23.87, ["Neon|Ride"] = 54.37, ["Mega"] = 393.74, ["Mega|Fly"] = 363.19, ["Mega|Ride"] = 157.5}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Fly"] = 29.29, ["Ride"] = 26.25, ["Neon"] = 43.65, ["Mega"] = 249.38, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 26.25, ["Fly"] = 52.5, ["Ride"] = 67.44, ["Fly|Ride"] = 143.12, ["Neon"] = 125.77, ["Neon|Fly"] = 433.65, ["Neon|Ride"] = 112.88, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 783.82, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 49.76, ["Fly|Ride"] = 59.07, ["Neon"] = 21.7, ["Neon|Ride"] = 196.88, ["Mega"] = 245.34, ["Mega|Ride"] = 257.19, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 16.08, ["Ride"] = 14.32, ["Fly|Ride"] = 39.26, ["Neon"] = 2.1, ["Neon|Fly"] = 20.79, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 28.18, ["Mega|Ride"] = 38.89, ["Mega|Fly|Ride"] = 72.65}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 5419.87, ["Ride"] = 4461.19, ["Fly|Ride"] = 4599, ["Neon"] = 32523, ["Neon|Fly|Ride"] = 19659.07, ["Mega|Fly|Ride"] = 52500}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 10.49, ["Fly"] = 86.75, ["Ride"] = 41.91, ["Neon"] = 86.28, ["Neon|Fly"] = 385.95, ["Neon|Ride"] = 106.32, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 210, ["Mega|Ride"] = 215.15, ["Mega|Fly|Ride"] = 419.56}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 24.7, ["Ride"] = 19.69, ["Fly|Ride"] = 45.92, ["Neon"] = 15.56, ["Neon|Fly"] = 45.93, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 86.52, ["Mega"] = 131.25, ["Mega|Ride"] = 145.28, ["Mega|Fly|Ride"] = 214.67}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 433.13, ["Fly"] = 547.77, ["Ride"] = 459.38, ["Fly|Ride"] = 577.49, ["Neon"] = 2100, ["Neon|Ride"] = 1292.82, ["Neon|Fly|Ride"] = 1386, ["Mega|Fly|Ride"] = 4873.32}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 3.9, ["Ride"] = 49.08, ["Neon"] = 13.85, ["Neon|Ride"] = 291.38, ["Mega"] = 144.24, ["Mega|Fly|Ride"] = 693}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 4.02, ["Fly"] = 19.69, ["Ride"] = 131.25, ["Neon"] = 32.82, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 229.69, ["Mega"] = 409.7, ["Mega|Ride"] = 362.11}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 51.19, ["Ride"] = 19.53, ["Fly|Ride"] = 65.63, ["Neon"] = 7.88, ["Neon|Fly"] = 124.69, ["Neon|Ride"] = 36.82, ["Neon|Fly|Ride"] = 91.74, ["Mega"] = 54.06, ["Mega|Ride"] = 77.44, ["Mega|Fly|Ride"] = 153.96}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 640.48, ["Fly"] = 882.48, ["Ride"] = 722.4, ["Fly|Ride"] = 748.13, ["Neon|Ride"] = 2126.25, ["Neon|Fly|Ride"] = 2099.99}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 11.58, ["Fly"] = 101.92, ["Ride"] = 77.84, ["Neon"] = 37.66, ["Neon|Fly"] = 328.12, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 188.65, ["Mega"] = 262.5, ["Mega|Fly"] = 433.65, ["Mega|Ride"] = 243.96, ["Mega|Fly|Ride"] = 385.95}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 6.53, ["Fly"] = 236.25, ["Ride"] = 38.07, ["Fly|Ride"] = 130.11, ["Neon"] = 22.99, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 150.94, ["Mega"] = 168, ["Mega|Fly"] = 818.16, ["Mega|Ride"] = 181.12, ["Mega|Fly|Ride"] = 290.07}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 34.13, ["Ride"] = 20.79, ["Fly|Ride"] = 41.97, ["Neon"] = 17.07, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 31.82, ["Neon|Fly|Ride"] = 82.97, ["Mega"] = 165.38}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 20.98, ["Fly"] = 39.38, ["Ride"] = 41.21, ["Fly|Ride"] = 62.34, ["Neon"] = 117.6, ["Neon|Ride"] = 114.18, ["Mega"] = 867.29, ["Mega|Ride"] = 506.29, ["Mega|Fly|Ride"] = 867.29}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Ride"] = 43.31, ["Fly|Ride"] = 82.21, ["Neon"] = 3.57, ["Neon|Ride"] = 143.07, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 31.5, ["Mega|Ride"] = 91.87, ["Mega|Fly|Ride"] = 340.43}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 556.84, ["Fly"] = 714.44, ["Ride"] = 630.19, ["Fly|Ride"] = 787.5, ["Neon"] = 2589.57, ["Neon|Ride"] = 2313.48, ["Neon|Fly|Ride"] = 2391.38, ["Mega|Ride"] = 9567.57, ["Mega|Fly|Ride"] = 7861.88}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 3.94, ["Ride"] = 65.63, ["Fly|Ride"] = 262.5, ["Neon"] = 10.49, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 453.17, ["Mega"] = 58.56, ["Mega|Ride"] = 150.26, ["Mega|Fly|Ride"] = 324.16}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 49.46, ["Neon"] = 4.36, ["Neon|Fly"] = 246.11, ["Neon|Ride"] = 220.8, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 54.23, ["Mega|Fly|Ride"] = 289.47}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 60.45, ["Neon"] = 4.47, ["Neon|Ride"] = 56.17, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 45.94, ["Mega|Fly"] = 160.47, ["Mega|Ride"] = 126.95, ["Mega|Fly|Ride"] = 215.76}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.35, ["Ride"] = 26.25, ["Neon"] = 14.44, ["Neon|Ride"] = 48.98, ["Mega"] = 237.43, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 20.89, ["Fly"] = 72.19, ["Ride"] = 39.38, ["Fly|Ride"] = 157.5, ["Neon"] = 103.93, ["Neon|Fly"] = 278.45, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 393.74, ["Mega"] = 511.88, ["Mega|Ride"] = 511.48, ["Mega|Fly|Ride"] = 562}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 13.12, ["Ride"] = 56.22, ["Fly|Ride"] = 156.13, ["Neon"] = 85.89, ["Neon|Ride"] = 114.84, ["Neon|Fly|Ride"] = 283.5, ["Mega"] = 544.69, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 575.74}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly"] = 20.36, ["Ride"] = 15.65, ["Fly|Ride"] = 35.44, ["Neon"] = 51.24, ["Neon|Fly"] = 42.95, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 86.61, ["Mega"] = 298.6, ["Mega|Ride"] = 367.53, ["Mega|Fly|Ride"] = 239.6}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 3.94, ["Ride"] = 78.73, ["Fly|Ride"] = 144.76, ["Neon"] = 35.68, ["Neon|Ride"] = 91.88, ["Mega|Ride"] = 563.74}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Ride"] = 26.17, ["Fly|Ride"] = 109.5, ["Neon"] = 10.18, ["Neon|Ride"] = 52.05, ["Neon|Fly|Ride"] = 145.28, ["Mega"] = 82.57, ["Mega|Ride"] = 115.5, ["Mega|Fly|Ride"] = 353.43}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 17.95, ["Fly"] = 115.32, ["Ride"] = 23.46, ["Fly|Ride"] = 53.82, ["Neon"] = 110.25, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 212.49, ["Mega"] = 787.5, ["Mega|Fly|Ride"] = 757.32}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 33.43, ["Fly"] = 874.13, ["Neon"] = 131.25, ["Mega"] = 332.07, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 722.54}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 44.18, ["Fly"] = 86.63, ["Ride"] = 64.32, ["Fly|Ride"] = 145.28, ["Neon"] = 262.5, ["Neon|Ride"] = 314.12, ["Neon|Fly|Ride"] = 433.65, ["Mega"] = 1961.36, ["Mega|Fly|Ride"] = 1299.38}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 31.5, ["Fly"] = 145.28, ["Ride"] = 76.13, ["Fly|Ride"] = 223.13, ["Neon"] = 125.57, ["Neon|Ride"] = 168, ["Neon|Fly|Ride"] = 315, ["Mega"] = 612.28, ["Mega|Ride"] = 2026.5, ["Mega|Fly|Ride"] = 952.94}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 19.32, ["Ride"] = 36.87, ["Neon"] = 139.13, ["Neon|Ride"] = 223.13, ["Mega"] = 607.11, ["Mega|Ride"] = 818.16, ["Mega|Fly|Ride"] = 819.6}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 27.44, ["Fly"] = 81.81, ["Ride"] = 73.5, ["Fly|Ride"] = 197.33, ["Neon"] = 145.27, ["Neon|Fly"] = 420, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 468.18, ["Mega"] = 687.46, ["Mega|Ride"] = 694, ["Mega|Fly|Ride"] = 733.64}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 18.89, ["Ride"] = 15.74, ["Fly|Ride"] = 32.8, ["Neon"] = 3.94, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 58.15, ["Mega"] = 41.26, ["Mega|Fly"] = 327.52, ["Mega|Ride"] = 55.12, ["Mega|Fly|Ride"] = 145.04}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1467.38}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 97.02, ["Ride"] = 191.63, ["Fly|Ride"] = 374.07, ["Neon"] = 433.34, ["Neon|Ride"] = 506.29, ["Neon|Fly|Ride"] = 650.48, ["Mega"] = 1443.75, ["Mega|Ride"] = 1619.66, ["Mega|Fly|Ride"] = 1671.66}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 76.58, ["Neon"] = 2.6, ["Neon|Fly"] = 101.92, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 303.3, ["Mega"] = 26.25, ["Mega|Ride"] = 89.66, ["Mega|Fly|Ride"] = 136.5}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 26.25, ["Ride"] = 48.91, ["Fly|Ride"] = 216.84, ["Neon"] = 118.13, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 591.93, ["Mega|Ride"] = 513.7, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 3.89, ["Neon|Fly|Ride"] = 145.28, ["Mega"] = 23.63}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Ride"] = 74.82, ["Neon"] = 3.82, ["Mega"] = 22.32, ["Mega|Ride"] = 90.57}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 86.61, ["Fly"] = 1312.5, ["Ride"] = 118.13, ["Fly|Ride"] = 223.13, ["Neon"] = 655.03, ["Neon|Ride"] = 459.37, ["Neon|Fly|Ride"] = 498.75, ["Mega|Ride"] = 6746.37, ["Mega|Fly|Ride"] = 2038.96}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 90.57, ["Ride"] = 21.69, ["Fly|Ride"] = 98.94, ["Neon"] = 7.33, ["Neon|Fly"] = 43.38, ["Neon|Ride"] = 32.29, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 91.88, ["Mega|Ride"] = 118.12, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 38.07, ["Fly|Ride"] = 63, ["Neon"] = 4.64, ["Neon|Fly"] = 43.38, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 419.9, ["Mega"] = 32.81, ["Mega|Ride"] = 129.15, ["Mega|Fly|Ride"] = 217.87}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.54, ["Ride"] = 71.58, ["Neon"] = 14.43, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 230.79, ["Mega"] = 131.25, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Neon"] = 11.69, ["Neon|Ride"] = 137.82, ["Mega"] = 103.69}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 97.13, ["Ride"] = 327.52, ["Fly|Ride"] = 362.11, ["Neon"] = 413.44, ["Neon|Ride"] = 613.32, ["Neon|Fly|Ride"] = 655.03, ["Mega|Ride"] = 2168.21, ["Mega|Fly|Ride"] = 2877.21}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 9.09, ["Neon"] = 52.77, ["Neon|Fly|Ride"] = 145.28, ["Mega"] = 418.06, ["Mega|Ride"] = 366.19, ["Mega|Fly|Ride"] = 645.74}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 413.44, ["Ride"] = 427.32, ["Fly|Ride"] = 719.86, ["Neon"] = 1069.69, ["Neon|Ride"] = 1050, ["Neon|Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 3346.87}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 101.91}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 57.75}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 17.07}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 32.54}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 50.9}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 52.5}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 15.25}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 6.18}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 190.3}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 18.26}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 41.57}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 24.94}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 11.83}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 944.99}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 5.25}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 7.58}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 13.01}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 6.46}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 27.57}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 735}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 462}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 13.12}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1474.83}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 52.4}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 5.91}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 43.37}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 24.66}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 26.23}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 59.05}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 19.14}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 11.81}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 23.78}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 6.34}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 26.17}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 3.62}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 4.23}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 52.5}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 14.15}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 6.56}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 3045}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 82.46}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 247.33}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 3.93}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.62}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 23.62}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 19.68}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 30.55}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 196.88}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 10.5}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 9.85}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 148.23}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 44.18}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 12.23}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 31.38}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 10.19}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 3.93}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 105}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 30.19}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 9.18}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 19.16}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 36.86}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 3.39}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 28.87}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 93.19}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 259.86}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.62}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 8.19}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 315.89}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 24.86}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 91.88}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 20.56}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 24406.67}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 124.69}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 36.75}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 39.73}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 27.56}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 57.66}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 24.86}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 35.42}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 91.14}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 91.88}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 29.61}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 103.69}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 431.78}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 44.42}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 32.82}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 242.05}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 11.31}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 9.19}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 4.29}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 6.57}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 22.32}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 142.93}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.3}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 2.46}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 6.38}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 19.67}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 208.69}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 830.75}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 8.95}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 616.75}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 11.69}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.1}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 223.13}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 28.86}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 99.64}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 20.9}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 30.19}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 65.37}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 13.01}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 3.85}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 9.16}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.1}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 3.93}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 9.07}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 32.8}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 3.25}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 2.5}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 6.55}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 14.12}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 163.96}},
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
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 170.63}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 24.6}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 25.98}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 11.94}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 24.55}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 19.68}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 4.18}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 7.88}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 7.69}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 6.44}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 39.38}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 17.32}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 6.56}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 3.93}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 2.51}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 18.41}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 6.57}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 6.41}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 5.84}},
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
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 7875}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.52}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 18.38}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 4.5}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 4.13}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 4.18}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 20.61}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 5.64}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 3.69}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 3.32}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 5.25}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 9.19}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 40.21}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 10.84}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 3.9}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 4.69}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 3.71}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 3.28}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 3937.5}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 8.96}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 34.13}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 3.89}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 72.35}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.26}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 5.25}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 124.69}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 8.65}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 6.51}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 4.24}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 5.2}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 143.81}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 26.25}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 2.24}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.3}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 11.69}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 6.57}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.77}},
    ["rbxassetid://3009779565"] = {name = "Rainbow Rattle", prices = {["default"] = 289059.45}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 3.29}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 3.94}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 14.44}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.52}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 5.84}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 8.69}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 116.71}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 87.12}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 11.58}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1290.09}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 64.31}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 23.37}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 35.42}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.62}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 5.87}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 13.02}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 51.98}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 12.6}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 14.28}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 2.58}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 3.94}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 11.76}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 3.94}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 55.31}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 22.67}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 3.84}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 3.84}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 7.88}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 64.98}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.63}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 13.11}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.96}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 321.57}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 91.88}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 13.11}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 3.94}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 3.84}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 27.9}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 3.3}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 22.18}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 5.01}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 2.14}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 6.5}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 5.93}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 124.69}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.63}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 4.3}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 145.25}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 11.71}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1013.25}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.63}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 192.83}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 5.65}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 9.73}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 52.49}},
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
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.36}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 8.64}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 2.61}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 64.23}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 105.45}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 61.34}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.52}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 4.2}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 3.9}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 19.52}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 112.88}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 2.37}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 86.1}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 3.73}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 4.93}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 52.4}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 65.62}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 53.81}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 97.13}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 62.65}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 216.8}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 15.62}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 4.79}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 46.22}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 57.75}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 8.48}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 28.88}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 3.34}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 5.5}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 7.26}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 13}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 85.77}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 30.86}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 6.22}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 12.6}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 39.38}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 6.45}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 28.65}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 3.29}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 28.28}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 94.5}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 56.41}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 24.94}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1994.99}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 16.28}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 8.6}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 23.62}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 263.68}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 16.19}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 9.82}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 17.57}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 5.22}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 11.79}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 280.88}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 64.31}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 43.32}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 3.82}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 51.18}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 155.85}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 78.2}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 965.87}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 181.13}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 6.56}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 1642.41}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 570.41}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 3.9}},
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