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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 1210.13, ["Ride"] = 1049.99, ["Fly|Ride"] = 1689.19, ["Neon"] = 6694.98, ["Neon|Ride"] = 6825, ["Neon|Fly|Ride"] = 12603.94, ["Mega"] = 21289.64, ["Mega|Fly|Ride"] = 21289.64}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 433.12, ["Fly"] = 638.19, ["Ride"] = 500.35, ["Fly|Ride"] = 602.07, ["Neon|Fly|Ride"] = 1706.25, ["Mega"] = 10644.82, ["Mega|Fly|Ride"] = 7381.13}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 6562.5, ["Ride"] = 5250, ["Fly|Ride"] = 4462.5, ["Neon|Fly|Ride"] = 28389.92, ["Mega|Fly|Ride"] = 70965.79}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 157.48, ["Ride"] = 229.69, ["Fly|Ride"] = 308.36, ["Neon"] = 1051.85, ["Neon|Ride"] = 979.44, ["Neon|Fly|Ride"] = 982.65, ["Mega|Fly|Ride"] = 4593.75}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 632.63, ["Fly"] = 851.71, ["Ride"] = 556.16, ["Fly|Ride"] = 565.14, ["Neon|Fly|Ride"] = 1755.89, ["Mega|Fly|Ride"] = 6671.12}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 9.84, ["Fly"] = 21, ["Ride"] = 57.69, ["Fly|Ride"] = 129.94, ["Neon"] = 71.47, ["Neon|Fly"] = 284.27, ["Neon|Ride"] = 63.92, ["Neon|Fly|Ride"] = 319.39, ["Mega"] = 350.21, ["Mega|Ride"] = 419.99, ["Mega|Fly|Ride"] = 483.29}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 4.8, ["Fly"] = 131.24, ["Ride"] = 25.95, ["Fly|Ride"] = 68.22, ["Neon"] = 32.82, ["Neon|Fly"] = 49.88, ["Neon|Ride"] = 56.8, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 189.63, ["Mega|Ride"] = 264.08, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 106.47, ["Fly"] = 212.94, ["Ride"] = 157.5, ["Fly|Ride"] = 240.61, ["Neon"] = 566.39, ["Neon|Ride"] = 492.19, ["Neon|Fly|Ride"] = 670.71, ["Mega"] = 1586.82, ["Mega|Ride"] = 2492.44, ["Mega|Fly|Ride"] = 2823.02}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 35.78, ["Fly"] = 80.09, ["Ride"] = 39.38, ["Fly|Ride"] = 104.62, ["Neon"] = 257.62, ["Neon|Ride"] = 182.44, ["Neon|Fly|Ride"] = 255.48, ["Mega"] = 1420.02, ["Mega|Ride"] = 1169.88, ["Mega|Fly|Ride"] = 918.74}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 21.31, ["Fly"] = 37.21, ["Ride"] = 26.25, ["Fly|Ride"] = 70.75, ["Neon"] = 207.97, ["Neon|Ride"] = 136.5, ["Neon|Fly|Ride"] = 198.02, ["Mega|Ride"] = 571.49, ["Mega|Fly|Ride"] = 781.92}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 58.55, ["Fly"] = 127.76, ["Ride"] = 78.66, ["Fly|Ride"] = 162.75, ["Neon"] = 341.84, ["Neon|Ride"] = 321.57, ["Neon|Fly|Ride"] = 425.25, ["Mega|Fly|Ride"] = 1263.55}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 66.94}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 387.35, ["Fly"] = 399, ["Ride"] = 331.08, ["Fly|Ride"] = 400.23, ["Neon|Ride"] = 1048.69, ["Neon|Fly|Ride"] = 1181.23, ["Mega|Fly|Ride"] = 5039.27}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 86.46, ["Fly"] = 128.06, ["Ride"] = 118.13, ["Fly|Ride"] = 137.16, ["Neon|Fly"] = 621.69, ["Neon|Ride"] = 573.03, ["Neon|Fly|Ride"] = 642.69, ["Mega"] = 4312.63, ["Mega|Fly|Ride"] = 2467.5}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 3.45, ["Ride"] = 57.5, ["Fly|Ride"] = 131.25, ["Neon"] = 23.93, ["Neon|Ride"] = 56.35, ["Neon|Fly|Ride"] = 202.73, ["Mega"] = 157.5, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 334.79}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 196.88, ["Fly"] = 262.5, ["Ride"] = 225.74, ["Fly|Ride"] = 229.68, ["Neon|Ride"] = 958.16, ["Neon|Fly|Ride"] = 701.32, ["Mega|Fly|Ride"] = 2749.69}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.93, ["Fly"] = 26.11, ["Ride"] = 17.25, ["Fly|Ride"] = 39.38, ["Neon"] = 28.85, ["Neon|Fly"] = 80.12, ["Neon|Ride"] = 57.7, ["Neon|Fly|Ride"] = 110.74, ["Mega"] = 270.39, ["Mega|Ride"] = 321.57, ["Mega|Fly|Ride"] = 422.63}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 90.45, ["Fly"] = 160.16, ["Ride"] = 127.19, ["Fly|Ride"] = 268.61, ["Neon"] = 310.55, ["Neon|Ride"] = 291.38, ["Neon|Fly|Ride"] = 492.93, ["Mega"] = 1709.08, ["Mega|Ride"] = 1420.02, ["Mega|Fly|Ride"] = 1443.75}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 40.2}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 76.13, ["Ride"] = 157.58, ["Fly|Ride"] = 243.95, ["Neon"] = 577.5, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 2128.97, ["Mega|Fly|Ride"] = 1916.09}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 20.57, ["Fly"] = 55.37, ["Ride"] = 40.65, ["Fly|Ride"] = 355.6, ["Neon"] = 213.94, ["Neon|Ride"] = 209.99, ["Neon|Fly|Ride"] = 325.78, ["Mega"] = 2749.94, ["Mega|Ride"] = 956.99, ["Mega|Fly|Ride"] = 952.72}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 39.33, ["Fly"] = 64.55, ["Ride"] = 57.35, ["Fly|Ride"] = 90.02, ["Neon"] = 319.1, ["Neon|Ride"] = 220.49, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1673.88, ["Mega|Ride"] = 1021.92, ["Mega|Fly|Ride"] = 941.99}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 40.95, ["Fly"] = 262.5, ["Ride"] = 60.97, ["Fly|Ride"] = 196.88, ["Neon"] = 236.25, ["Neon|Ride"] = 388.46, ["Neon|Fly|Ride"] = 467.25, ["Mega"] = 1275.74, ["Mega|Ride"] = 1703.19, ["Mega|Fly|Ride"] = 1511.58}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 21.31, ["Ride"] = 34.82, ["Fly|Ride"] = 93.02, ["Neon"] = 210, ["Neon|Ride"] = 212.94, ["Neon|Fly|Ride"] = 173.25, ["Mega"] = 1207.92, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 39.38, ["Fly"] = 143.04, ["Ride"] = 62.34, ["Fly|Ride"] = 178.86, ["Neon"] = 181, ["Neon|Fly"] = 399.32, ["Neon|Ride"] = 168.23, ["Neon|Fly|Ride"] = 262.49, ["Mega|Ride"] = 3193.46, ["Mega|Fly|Ride"] = 1018.5}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 9.11, ["Fly"] = 31.5, ["Ride"] = 19.67, ["Fly|Ride"] = 63.77, ["Neon"] = 39.35, ["Neon|Fly"] = 57.5, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 93.19, ["Mega"] = 174.57, ["Mega|Fly"] = 274.32, ["Mega|Ride"] = 182.44, ["Mega|Fly|Ride"] = 320.25}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 393.75, ["Ride"] = 498.75, ["Fly|Ride"] = 510.57, ["Neon|Ride"] = 1689.18, ["Neon|Fly|Ride"] = 1966.13, ["Mega"] = 10644.82, ["Mega|Fly|Ride"] = 9086.74}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 15.2, ["Ride"] = 32.79, ["Fly|Ride"] = 65.63, ["Neon"] = 219.18, ["Neon|Ride"] = 164.07, ["Mega|Ride"] = 809.02, ["Mega|Fly|Ride"] = 671.66}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 5.25, ["Fly"] = 40.36, ["Ride"] = 20.34, ["Fly|Ride"] = 48.57, ["Neon"] = 52.5, ["Neon|Ride"] = 70.26, ["Neon|Fly|Ride"] = 128.82, ["Mega"] = 355.56, ["Mega|Ride"] = 314.03, ["Mega|Fly|Ride"] = 366.19}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 71.69, ["Fly"] = 100.09, ["Ride"] = 98.23, ["Fly|Ride"] = 95.62, ["Neon"] = 297.94, ["Neon|Ride"] = 283.5, ["Neon|Fly|Ride"] = 395.01, ["Mega"] = 6335.61, ["Mega|Ride"] = 2415.16, ["Mega|Fly|Ride"] = 2100}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 11.81, ["Ride"] = 34.09, ["Fly|Ride"] = 76.27, ["Neon"] = 127.13, ["Neon|Ride"] = 112.4, ["Neon|Fly|Ride"] = 170.52, ["Mega"] = 710.01, ["Mega|Ride"] = 558.37, ["Mega|Fly|Ride"] = 715.35}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 197.98, ["Fly"] = 262.5, ["Ride"] = 225.74, ["Fly|Ride"] = 315, ["Neon"] = 637.71, ["Neon|Ride"] = 797.43, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 3405.29, ["Mega|Ride"] = 2763.52, ["Mega|Fly|Ride"] = 2920.95}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 20.99}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.67, ["Fly"] = 32.81, ["Ride"] = 27.09, ["Fly|Ride"] = 76.16, ["Neon"] = 24.93, ["Neon|Fly"] = 142.68, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 105, ["Mega"] = 212.91, ["Mega|Fly"] = 341.67, ["Mega|Ride"] = 191.16, ["Mega|Fly|Ride"] = 241.65}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 892.48, ["Fly"] = 2625, ["Ride"] = 908.25, ["Fly|Ride"] = 927.94, ["Neon"] = 4258.45, ["Neon|Ride"] = 4826.96, ["Neon|Fly|Ride"] = 4755.61, ["Mega|Ride"] = 53802.94, ["Mega|Fly|Ride"] = 17031.71}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 11.71, ["Fly"] = 45.86, ["Ride"] = 42.6, ["Fly|Ride"] = 91.68, ["Neon"] = 169.21, ["Neon|Ride"] = 157.58, ["Neon|Fly|Ride"] = 181.13, ["Mega"] = 1009.32, ["Mega|Ride"] = 1090.04, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 210, ["Fly"] = 358.55, ["Ride"] = 262.5, ["Fly|Ride"] = 367.5, ["Neon"] = 830.82, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 853.13, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 3899.56}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 35.44}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 12.79, ["Fly"] = 127.76, ["Ride"] = 39.38, ["Fly|Ride"] = 142.68, ["Neon"] = 65.63, ["Neon|Ride"] = 128.62, ["Neon|Fly|Ride"] = 340.7, ["Mega"] = 353.22, ["Mega|Ride"] = 568.01, ["Mega|Fly|Ride"] = 591.86}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 98.44, ["Ride"] = 144.26, ["Fly|Ride"] = 271.49, ["Neon"] = 637.71, ["Neon|Ride"] = 420, ["Neon|Fly|Ride"] = 523.8, ["Mega"] = 2128.97, ["Mega|Fly|Ride"] = 2073.23}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 90.57, ["Fly"] = 157.49, ["Ride"] = 115.71, ["Fly|Ride"] = 217.88, ["Neon"] = 388.4, ["Neon|Fly"] = 568.52, ["Neon|Ride"] = 434.77, ["Neon|Fly|Ride"] = 496.12, ["Mega|Ride"] = 1466.07, ["Mega|Fly|Ride"] = 1382.07}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 33.91}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 45.93, ["Fly"] = 76.7, ["Ride"] = 52.37, ["Fly|Ride"] = 69.54, ["Neon|Ride"] = 367.04, ["Neon|Fly|Ride"] = 324.18, ["Mega"] = 4257.94, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 6.57, ["Fly"] = 98.44, ["Ride"] = 28.76, ["Fly|Ride"] = 204.38, ["Neon"] = 24.94, ["Neon|Fly"] = 223.13, ["Neon|Ride"] = 124.79, ["Neon|Fly|Ride"] = 239.55, ["Mega"] = 164.07, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 319.25, ["Mega|Fly|Ride"] = 381.94}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 459.38, ["Fly"] = 525, ["Ride"] = 420, ["Fly|Ride"] = 498.75, ["Neon|Fly"] = 3832.6, ["Neon|Ride"] = 1995, ["Neon|Fly|Ride"] = 1831.83, ["Mega|Ride"] = 14902.76, ["Mega|Fly|Ride"] = 7481.25}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 110.15, ["Fly"] = 157.58, ["Ride"] = 131.25, ["Fly|Ride"] = 193.78, ["Neon"] = 420, ["Neon|Ride"] = 484.32, ["Neon|Fly|Ride"] = 710, ["Mega|Ride"] = 2554.77, ["Mega|Fly|Ride"] = 2593.1}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3976.33, ["Ride"] = 3885, ["Fly|Ride"] = 3937.5, ["Neon|Fly|Ride"] = 13485.41}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 55.65, ["Fly"] = 121.37, ["Ride"] = 65.63, ["Fly|Ride"] = 139.79, ["Neon"] = 441.83, ["Neon|Ride"] = 305.55, ["Neon|Fly|Ride"] = 292.69, ["Mega"] = 1913.96, ["Mega|Ride"] = 1817.08, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 73.5, ["Ride"] = 70.88, ["Fly|Ride"] = 142.43, ["Neon"] = 575.75, ["Neon|Ride"] = 427.88, ["Neon|Fly|Ride"] = 420.53, ["Mega"] = 6245.33, ["Mega|Ride"] = 2388.75, ["Mega|Fly|Ride"] = 2167.38}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 30.07, ["Fly"] = 47.25, ["Ride"] = 44.63, ["Fly|Ride"] = 91.76, ["Neon"] = 151.71, ["Neon|Fly"] = 284.27, ["Neon|Ride"] = 139.88, ["Neon|Fly|Ride"] = 182.44, ["Mega"] = 994.24, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 577.44}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 4.27}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 53.34, ["Fly"] = 393.75, ["Ride"] = 37.66, ["Fly|Ride"] = 95.62, ["Neon|Ride"] = 284.27, ["Neon|Fly|Ride"] = 284.27, ["Mega|Ride"] = 1275.74, ["Mega|Fly|Ride"] = 1434.76}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 31.5}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 182.96, ["Ride"] = 233.89, ["Fly|Ride"] = 282.19, ["Neon|Ride"] = 1105.08, ["Neon|Fly|Ride"] = 1132.76}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 635.23, ["Ride"] = 641.82, ["Fly|Ride"] = 715.13, ["Neon"] = 2625, ["Neon|Fly|Ride"] = 3586.59, ["Mega|Fly|Ride"] = 10219.04}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 6.39}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 25.98, ["Fly"] = 31.4, ["Ride"] = 38.55, ["Fly|Ride"] = 78.02, ["Neon"] = 227.84, ["Neon|Fly"] = 323.01, ["Neon|Ride"] = 177.84, ["Neon|Fly|Ride"] = 211.3, ["Mega"] = 2128.97, ["Mega|Ride"] = 1160.15, ["Mega|Fly|Ride"] = 761.24}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 21.15}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5250, ["Fly"] = 6246.07, ["Ride"] = 5650.32, ["Fly|Ride"] = 5053.13, ["Neon|Ride"] = 17536.03, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 43042.36}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 12.47, ["Fly"] = 37.27, ["Ride"] = 23.45, ["Fly|Ride"] = 56.43, ["Neon"] = 72.19, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 197.51, ["Mega"] = 425.81, ["Mega|Ride"] = 490.88, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 12.29, ["Fly"] = 139.48, ["Ride"] = 30.19, ["Neon"] = 113.3, ["Neon|Ride"] = 122.07, ["Neon|Fly|Ride"] = 105, ["Mega"] = 710.01, ["Mega|Ride"] = 842.02, ["Mega|Fly|Ride"] = 994.24}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 71.75, ["Ride"] = 59.06, ["Fly|Ride"] = 91.58, ["Neon|Ride"] = 394.98, ["Neon|Fly|Ride"] = 480.96, ["Mega"] = 4257.94, ["Mega|Fly|Ride"] = 1753.99}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 9.18, ["Fly"] = 71.35, ["Ride"] = 26.17, ["Fly|Ride"] = 65.63, ["Neon"] = 73.33, ["Neon|Ride"] = 127.76, ["Neon|Fly|Ride"] = 105, ["Mega"] = 1420.02, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 813.75}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1680, ["Fly"] = 1902.48, ["Ride"] = 1640.62, ["Fly|Ride"] = 1662.94, ["Neon|Fly|Ride"] = 3412.49, ["Mega|Fly|Ride"] = 12468.75}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 27300, ["Fly"] = 34067.48, ["Ride"] = 35437.5, ["Fly|Ride"] = 25440.19, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 63000, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 183748.69}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 20.79, ["Fly"] = 393.75, ["Ride"] = 57.75, ["Fly|Ride"] = 127.76, ["Neon"] = 284.27, ["Neon|Ride"] = 208.69, ["Neon|Fly|Ride"] = 568.45, ["Mega"] = 754.69, ["Mega|Ride"] = 1148.44, ["Mega|Fly|Ride"] = 1353.47}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 3.39, ["Fly"] = 65.63, ["Ride"] = 35.43, ["Fly|Ride"] = 109.53, ["Neon"] = 23.63, ["Neon|Fly"] = 131.24, ["Neon|Ride"] = 58.7, ["Neon|Fly|Ride"] = 174.57, ["Mega"] = 131.25, ["Mega|Fly"] = 298.07, ["Mega|Ride"] = 155.32, ["Mega|Fly|Ride"] = 318.29}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 19.19}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 7.86, ["Ride"] = 42.6, ["Fly|Ride"] = 131.25, ["Neon"] = 56.6, ["Neon|Ride"] = 116.81, ["Neon|Fly|Ride"] = 212.91, ["Mega"] = 310.3, ["Mega|Ride"] = 426.48, ["Mega|Fly|Ride"] = 710.01}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 656.25, ["Fly"] = 892.77, ["Ride"] = 656.25, ["Fly|Ride"] = 735, ["Neon"] = 2767.99, ["Neon|Ride"] = 2754.17, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 10077.45}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 840, ["Fly"] = 853.13, ["Ride"] = 787.5, ["Fly|Ride"] = 1010.18, ["Neon"] = 4116.86, ["Neon|Ride"] = 3270.99, ["Neon|Fly|Ride"] = 3018.75, ["Mega|Fly|Ride"] = 11780.64}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 14.51, ["Fly"] = 119.53, ["Ride"] = 30.01, ["Fly|Ride"] = 87.94, ["Neon"] = 85.29, ["Neon|Ride"] = 100.92, ["Neon|Fly|Ride"] = 161.44, ["Mega"] = 1215.56, ["Mega|Ride"] = 481.69, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 26.25}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 65.51, ["Fly"] = 89.25, ["Ride"] = 57.17, ["Fly|Ride"] = 119.6, ["Neon"] = 568.52, ["Neon|Ride"] = 489.74, ["Neon|Fly|Ride"] = 420, ["Mega"] = 19687.5, ["Mega|Fly|Ride"] = 2123.63}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 80.83, ["Ride"] = 90.03, ["Fly|Ride"] = 212.94, ["Neon"] = 323.07, ["Neon|Ride"] = 386.78, ["Neon|Fly|Ride"] = 505.84, ["Mega"] = 1412, ["Mega|Ride"] = 1703.19, ["Mega|Fly|Ride"] = 1841.26}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 3.81, ["Fly"] = 28.38, ["Ride"] = 19.85, ["Fly|Ride"] = 45.94, ["Neon"] = 45.94, ["Neon|Fly"] = 524.99, ["Neon|Ride"] = 71.35, ["Neon|Fly|Ride"] = 110.92, ["Mega"] = 281.05, ["Mega|Ride"] = 289.55, ["Mega|Fly|Ride"] = 447.09}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 137.82, ["Fly"] = 162.07, ["Ride"] = 153.55, ["Fly|Ride"] = 211.94, ["Neon"] = 958.77, ["Neon|Ride"] = 544.94, ["Neon|Fly|Ride"] = 603.74, ["Mega"] = 5109.53, ["Mega|Fly|Ride"] = 2559.37}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 4.27, ["Ride"] = 48.14, ["Fly|Ride"] = 142.68, ["Neon"] = 34.09, ["Neon|Ride"] = 173.55, ["Neon|Fly|Ride"] = 424.69, ["Mega"] = 204.75, ["Mega|Fly"] = 338.52, ["Mega|Ride"] = 199.07, ["Mega|Fly|Ride"] = 422.63}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 15.75, ["Fly"] = 41.53, ["Ride"] = 26.23, ["Fly|Ride"] = 90.18, ["Neon"] = 120.75, ["Neon|Fly"] = 160.22, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 1050, ["Mega|Ride"] = 823.92, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 26.17, ["Ride"] = 68.22, ["Fly|Ride"] = 156.19, ["Neon"] = 198.02, ["Neon|Ride"] = 223.13, ["Mega"] = 918.75, ["Mega|Ride"] = 1161.57, ["Mega|Fly|Ride"] = 922.92}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 14.6, ["Fly"] = 212.94, ["Ride"] = 26.25, ["Fly|Ride"] = 63.94, ["Neon"] = 103.69, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 319.39, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 5145.53, ["Ride"] = 5248.69, ["Fly|Ride"] = 5643.75, ["Neon"] = 35487.66, ["Neon|Ride"] = 28389.92, ["Neon|Fly|Ride"] = 25974.33}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 223.02, ["Fly"] = 234.94, ["Ride"] = 223.13, ["Fly|Ride"] = 295.96, ["Neon"] = 745.24, ["Neon|Fly|Ride"] = 564.38, ["Mega|Fly|Ride"] = 1968.74}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 42, ["Fly"] = 139.47, ["Ride"] = 99.75, ["Fly|Ride"] = 212.61, ["Neon"] = 157.5, ["Neon|Fly"] = 319.23, ["Neon|Ride"] = 191.7, ["Neon|Fly|Ride"] = 322.88, ["Mega"] = 473.82, ["Mega|Fly"] = 645.65, ["Mega|Ride"] = 515.83, ["Mega|Fly|Ride"] = 603.37}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.63, ["Fly"] = 88.46, ["Ride"] = 19.49, ["Fly|Ride"] = 52.49, ["Neon"] = 23.91, ["Neon|Fly"] = 85.19, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 499.8, ["Mega|Ride"] = 330.75, ["Mega|Fly|Ride"] = 357.5}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 59.07, ["Fly"] = 191.28, ["Ride"] = 91.77, ["Fly|Ride"] = 232.32, ["Neon"] = 209.9, ["Neon|Ride"] = 258.58, ["Neon|Fly|Ride"] = 391.11, ["Mega"] = 563.88, ["Mega|Ride"] = 576.99, ["Mega|Fly|Ride"] = 728.42}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 13965, ["Ride"] = 13415.07, ["Fly|Ride"] = 11156.25, ["Neon|Fly|Ride"] = 24627.91, ["Mega|Fly|Ride"] = 113545.04}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 212.94, ["Ride"] = 315, ["Fly|Ride"] = 459.38, ["Neon|Ride"] = 1420.2, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 7173.74}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 38.98, ["Fly"] = 80.59, ["Ride"] = 71.9, ["Fly|Ride"] = 93.52, ["Neon"] = 404.57, ["Neon|Ride"] = 328.11, ["Neon|Fly|Ride"] = 293.6, ["Mega|Fly|Ride"] = 3087}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 7.87, ["Fly"] = 43.32, ["Ride"] = 26.25, ["Fly|Ride"] = 53.82, ["Neon"] = 65.45, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 157.49, ["Mega"] = 393.75, ["Mega|Ride"] = 425.81, ["Mega|Fly|Ride"] = 1064.49}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 372.74, ["Fly"] = 851.71, ["Ride"] = 433.06, ["Fly|Ride"] = 534.19, ["Neon"] = 1690.62, ["Neon|Ride"] = 1376.76, ["Neon|Fly|Ride"] = 1644.26, ["Mega|Fly|Ride"] = 4967.95}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 7.35, ["Ride"] = 32.81, ["Fly|Ride"] = 194.66, ["Neon"] = 51.19, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 144.37, ["Mega|Fly"] = 263.92, ["Mega|Ride"] = 217.47, ["Mega|Fly|Ride"] = 360.94}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 104.79, ["Fly"] = 164.07, ["Ride"] = 137.71, ["Fly|Ride"] = 190.31, ["Neon"] = 434.78, ["Neon|Fly"] = 525, ["Neon|Ride"] = 488.25, ["Neon|Fly|Ride"] = 465.94, ["Mega|Fly|Ride"] = 2138.39}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 11.82, ["Fly"] = 19.59, ["Ride"] = 16.7, ["Fly|Ride"] = 32.8, ["Neon"] = 160.22, ["Neon|Fly"] = 80.12, ["Neon|Ride"] = 196.86, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 2554.77, ["Mega|Fly|Ride"] = 423.69}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 7.88}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 65.51, ["Ride"] = 85.63, ["Fly|Ride"] = 176.74, ["Neon"] = 359.63, ["Neon|Fly"] = 424.79, ["Neon|Ride"] = 406.87, ["Neon|Fly|Ride"] = 340.7, ["Mega"] = 1642.8, ["Mega|Ride"] = 1845.83, ["Mega|Fly|Ride"] = 1561.61}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 13.13, ["Fly"] = 80.07, ["Ride"] = 30.12, ["Fly|Ride"] = 85.21, ["Neon"] = 98.44, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 196.86, ["Mega"] = 573.77, ["Mega|Ride"] = 568.45, ["Mega|Fly|Ride"] = 576.02}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 26.25}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 51.84, ["Fly"] = 142.65, ["Ride"] = 101.07, ["Fly|Ride"] = 316.32, ["Neon"] = 319.23, ["Neon|Ride"] = 328.12, ["Neon|Fly|Ride"] = 511.87, ["Mega|Fly|Ride"] = 1675.51}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.15, ["Ride"] = 29.23, ["Fly|Ride"] = 136.25, ["Neon"] = 24.35, ["Neon|Ride"] = 112.4, ["Neon|Fly|Ride"] = 255.51, ["Mega"] = 164.07, ["Mega|Ride"] = 213.42, ["Mega|Fly|Ride"] = 421.55}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 11.46, ["Fly"] = 56.44, ["Ride"] = 33.03, ["Fly|Ride"] = 99.81, ["Neon"] = 65.63, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 191.64, ["Mega|Ride"] = 334.69, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 431.81, ["Fly"] = 435.75, ["Ride"] = 446.25, ["Fly|Ride"] = 541.66, ["Neon|Fly|Ride"] = 2748.43, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 36.88, ["Fly"] = 106.47, ["Ride"] = 57.66, ["Fly|Ride"] = 97.12, ["Neon"] = 129.94, ["Neon|Ride"] = 170.36, ["Neon|Fly|Ride"] = 338.56, ["Mega"] = 776.43, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 717.84}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 47.84, ["Fly"] = 142.68, ["Ride"] = 70.88, ["Fly|Ride"] = 140.33, ["Neon"] = 102.38, ["Neon|Ride"] = 236.14, ["Neon|Fly|Ride"] = 318.33, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 19.02, ["Fly"] = 114.3, ["Ride"] = 68.24, ["Fly|Ride"] = 98.44, ["Neon"] = 78.75, ["Neon|Fly"] = 137.82, ["Neon|Ride"] = 143.06, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 437.07, ["Mega|Fly"] = 525, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 583}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 8203.13, ["Ride"] = 8862, ["Fly|Ride"] = 8347.5, ["Neon|Fly|Ride"] = 14311.5, ["Mega|Fly|Ride"] = 38850}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1404.38, ["Fly"] = 1486.83, ["Ride"] = 1299.38, ["Fly|Ride"] = 1292.82, ["Neon|Fly|Ride"] = 4875.26, ["Mega|Fly|Ride"] = 17031.71}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 667.53, ["Ride"] = 617.49, ["Fly|Ride"] = 710.11, ["Neon"] = 2253.58, ["Neon|Fly|Ride"] = 1443.75, ["Mega"] = 21289.64, ["Mega|Fly|Ride"] = 9650.61}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 11.24, ["Fly"] = 23.72, ["Ride"] = 18.77, ["Fly|Ride"] = 38.96, ["Neon"] = 71.35, ["Neon|Ride"] = 90.27, ["Neon|Fly|Ride"] = 125.81, ["Mega|Fly|Ride"] = 572.25}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 4.44, ["Fly"] = 78.74, ["Ride"] = 32.28, ["Fly|Ride"] = 182.06, ["Neon"] = 24.94, ["Neon|Ride"] = 55.44, ["Mega"] = 167.77, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 285.87}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 31.4, ["Fly"] = 39.38, ["Ride"] = 41.9, ["Fly|Ride"] = 100.31, ["Neon"] = 119.57, ["Neon|Ride"] = 142.68, ["Neon|Fly|Ride"] = 160.23, ["Mega|Fly|Ride"] = 666.75}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 2.63, ["Fly"] = 19.09, ["Ride"] = 16.4, ["Fly|Ride"] = 41.06, ["Neon"] = 24.93, ["Neon|Fly"] = 86.63, ["Neon|Ride"] = 44.72, ["Neon|Fly|Ride"] = 97.13, ["Mega"] = 334.26, ["Mega|Ride"] = 632.68, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 325.96, ["Fly"] = 369.5, ["Ride"] = 276.94, ["Fly|Ride"] = 321.57, ["Neon"] = 1594.85, ["Neon|Ride"] = 1332.91, ["Neon|Fly|Ride"] = 1279.69, ["Mega|Fly|Ride"] = 4436.25}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 18.26, ["Fly"] = 59.77, ["Ride"] = 36.21, ["Fly|Ride"] = 78.75, ["Neon"] = 126, ["Neon|Fly"] = 403.22, ["Neon|Ride"] = 141.7, ["Neon|Fly|Ride"] = 191.3, ["Mega"] = 851.6, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 710.75}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 6.37, ["Fly"] = 24.92, ["Ride"] = 19.59, ["Fly|Ride"] = 40.66, ["Neon"] = 83.05, ["Neon|Fly"] = 120.31, ["Neon|Ride"] = 76.67, ["Neon|Fly|Ride"] = 104.2, ["Mega"] = 1575, ["Mega|Ride"] = 602.61, ["Mega|Fly|Ride"] = 423.94}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 633.18, ["Fly"] = 1048.69, ["Ride"] = 525, ["Fly|Ride"] = 637.81, ["Neon|Fly|Ride"] = 3550.49, ["Mega|Fly|Ride"] = 9971.07}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1115.63, ["Ride"] = 1201.91, ["Fly|Ride"] = 1311.19, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 12490.65}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 142.68, ["Fly"] = 187.69, ["Ride"] = 125.64, ["Fly|Ride"] = 76.13, ["Neon"] = 497.19, ["Neon|Ride"] = 585.55, ["Neon|Fly|Ride"] = 425.86, ["Mega|Fly|Ride"] = 2697.41}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 150.94, ["Fly"] = 242.74, ["Ride"] = 201.48, ["Fly|Ride"] = 250.59, ["Neon"] = 629.81, ["Neon|Ride"] = 541.24, ["Neon|Fly|Ride"] = 716.1, ["Mega|Ride"] = 9187.5, ["Mega|Fly|Ride"] = 2937.99}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 24.2, ["Fly"] = 57.5, ["Ride"] = 34.9, ["Fly|Ride"] = 114.35, ["Neon"] = 236.24, ["Neon|Ride"] = 238.13, ["Mega|Ride"] = 1420.02, ["Mega|Fly|Ride"] = 1077.27}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 196.88, ["Ride"] = 315, ["Fly|Ride"] = 425.86, ["Neon"] = 1220.63, ["Neon|Fly"] = 956.44, ["Neon|Fly|Ride"] = 1277.54, ["Mega"] = 5677.96, ["Mega|Fly|Ride"] = 5677.96}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2391.2, ["Ride"] = 1769.15, ["Fly|Ride"] = 1837.49, ["Neon|Fly|Ride"] = 10646.09, ["Mega|Fly|Ride"] = 35073.55}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 57.6, ["Fly"] = 212.94, ["Ride"] = 51.18, ["Fly|Ride"] = 196.88, ["Neon"] = 288.75, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 268.29, ["Mega"] = 1420.02, ["Mega|Ride"] = 1135.82, ["Mega|Fly|Ride"] = 1249.49}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 570.93, ["Fly"] = 851.71, ["Ride"] = 630, ["Fly|Ride"] = 669.38, ["Neon|Ride"] = 1498.88, ["Neon|Fly|Ride"] = 1194.35, ["Mega|Fly|Ride"] = 3451.87}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 45.65, ["Fly"] = 52.5, ["Ride"] = 63.89, ["Fly|Ride"] = 98.44, ["Neon"] = 262.5, ["Neon|Ride"] = 212.94, ["Neon|Fly|Ride"] = 246.88, ["Mega|Fly|Ride"] = 1009.14}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.42, ["Fly"] = 32.82, ["Ride"] = 17.72, ["Fly|Ride"] = 60.38, ["Neon"] = 38.05, ["Neon|Fly"] = 72.6, ["Neon|Ride"] = 49.27, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 170.62, ["Mega|Ride"] = 185.31, ["Mega|Fly|Ride"] = 216.46}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 57.66, ["Ride"] = 127.89, ["Fly|Ride"] = 157.5, ["Neon"] = 262.4, ["Neon|Ride"] = 452.82, ["Neon|Fly|Ride"] = 710.11, ["Mega"] = 1557.34, ["Mega|Ride"] = 1703.19}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 853.13, ["Fly"] = 1082.78, ["Ride"] = 851.82, ["Fly|Ride"] = 840, ["Neon|Ride"] = 3255, ["Neon|Fly|Ride"] = 2821.88, ["Mega|Fly|Ride"] = 12490.65}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 650.99, ["Ride"] = 849.74, ["Fly|Ride"] = 830.41, ["Neon|Fly|Ride"] = 4257.39, ["Mega|Fly|Ride"] = 15469.07}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 14.28, ["Fly"] = 21.77, ["Ride"] = 18.37, ["Fly|Ride"] = 48.24, ["Neon"] = 142.68, ["Neon|Ride"] = 93.01, ["Neon|Fly|Ride"] = 118.12, ["Mega"] = 781.35, ["Mega|Ride"] = 568.45, ["Mega|Fly|Ride"] = 722.52}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 12.9, ["Ride"] = 28.76, ["Fly|Ride"] = 100.09, ["Neon"] = 100.74, ["Neon|Ride"] = 105.37, ["Neon|Fly|Ride"] = 248.07, ["Mega"] = 994.24, ["Mega|Ride"] = 821.8, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 4.47, ["Ride"] = 39.11, ["Fly|Ride"] = 52.5, ["Neon"] = 23.23, ["Neon|Fly"] = 319.23, ["Neon|Ride"] = 68.16, ["Neon|Fly|Ride"] = 224.6, ["Mega"] = 161.67, ["Mega|Fly"] = 542.83, ["Mega|Ride"] = 196.77, ["Mega|Fly|Ride"] = 355.56}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 38.28, ["Fly"] = 47.81, ["Ride"] = 35.33, ["Fly|Ride"] = 90.38, ["Neon"] = 305.55, ["Neon|Ride"] = 220.5, ["Neon|Fly|Ride"] = 223.6, ["Mega|Ride"] = 942.16, ["Mega|Fly|Ride"] = 1008.23}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 71.6, ["Ride"] = 160.13, ["Fly|Ride"] = 355.6, ["Neon"] = 428.35, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 2413.2, ["Mega|Ride"] = 2271.69, ["Mega|Fly|Ride"] = 2171.55}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 15.73, ["Fly"] = 51.19, ["Ride"] = 36.06, ["Fly|Ride"] = 72.87, ["Neon"] = 69.66, ["Neon|Fly"] = 239.12, ["Neon|Ride"] = 98.43, ["Neon|Fly|Ride"] = 172.97, ["Mega"] = 425.39, ["Mega|Ride"] = 362.25, ["Mega|Fly|Ride"] = 502.69}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 32.21, ["Fly"] = 59.07, ["Ride"] = 34.11, ["Fly|Ride"] = 93.08, ["Neon"] = 242.82, ["Neon|Ride"] = 160.13, ["Neon|Fly|Ride"] = 234.92, ["Mega"] = 2100, ["Mega|Fly|Ride"] = 1241.61}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.15, ["Fly"] = 27.46, ["Ride"] = 17.53, ["Fly|Ride"] = 41.99, ["Neon"] = 23.63, ["Neon|Ride"] = 54.31, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 434.74, ["Mega|Ride"] = 478.27, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 7.21, ["Fly"] = 49.88, ["Ride"] = 46.86, ["Fly|Ride"] = 70.88, ["Neon"] = 52.38, ["Neon|Fly"] = 114.19, ["Neon|Ride"] = 68.25, ["Neon|Fly|Ride"] = 235.29, ["Mega"] = 416.06, ["Mega|Ride"] = 355.56, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 31.95, ["Fly"] = 57.38, ["Ride"] = 48.74, ["Fly|Ride"] = 101.4, ["Neon"] = 233.63, ["Neon|Fly"] = 211.3, ["Neon|Ride"] = 214.67, ["Neon|Fly|Ride"] = 241.5, ["Mega|Fly|Ride"] = 1074.91}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1443.74, ["Fly"] = 1410.93, ["Ride"] = 1388.63, ["Fly|Ride"] = 1368.92, ["Neon|Ride"] = 4790.76, ["Neon|Fly|Ride"] = 3863.97, ["Mega|Fly|Ride"] = 12468.75}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 462, ["Fly"] = 524.99, ["Ride"] = 446.25, ["Fly|Ride"] = 479.07, ["Neon|Ride"] = 3052.24, ["Neon|Fly|Ride"] = 2362.5, ["Mega"] = 14902.76, ["Mega|Fly|Ride"] = 8847.6}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 263.82, ["Fly"] = 378.23, ["Ride"] = 353.41, ["Fly|Ride"] = 354.37, ["Neon"] = 1420.2, ["Neon|Ride"] = 1490.46, ["Neon|Fly|Ride"] = 1640.63}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 37.54}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 29.96, ["Ride"] = 42, ["Fly|Ride"] = 98.44, ["Neon"] = 325.5, ["Neon|Fly"] = 425.86, ["Neon|Ride"] = 208.22, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 1703.19, ["Mega|Fly|Ride"] = 1036.54}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 70875, ["Fly"] = 23421.39, ["Ride"] = 35853.16, ["Fly|Ride"] = 18090.19, ["Neon|Fly|Ride"] = 36617.44, ["Mega"] = 212896.26, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 232.46, ["Fly"] = 262.5, ["Ride"] = 244.09, ["Fly|Ride"] = 285.63, ["Neon"] = 721.88, ["Neon|Fly"] = 1075.99, ["Neon|Ride"] = 956.44, ["Neon|Fly|Ride"] = 797.49, ["Mega"] = 3188.74, ["Mega|Fly|Ride"] = 3770.08}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 216.46, ["Fly"] = 525, ["Ride"] = 249.38, ["Fly|Ride"] = 257.27, ["Neon|Fly|Ride"] = 1753.85}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 128.16, ["Fly"] = 144.38, ["Ride"] = 131.25, ["Fly|Ride"] = 164.06, ["Neon"] = 517.12, ["Neon|Ride"] = 524.99, ["Neon|Fly|Ride"] = 616.88, ["Mega|Ride"] = 3550.05, ["Mega|Fly|Ride"] = 3123.21}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 11.55, ["Fly"] = 63.89, ["Ride"] = 30.19, ["Fly|Ride"] = 91.88, ["Neon"] = 95.66, ["Neon|Ride"] = 114.24, ["Neon|Fly|Ride"] = 228.59, ["Mega"] = 714.99, ["Mega|Ride"] = 710.01, ["Mega|Fly|Ride"] = 958.06}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 5085.94, ["Ride"] = 3937.5, ["Fly|Ride"] = 4042.5, ["Neon"] = 21292.17, ["Neon|Fly|Ride"] = 15750}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 27.45, ["Fly"] = 39.38, ["Ride"] = 28.77, ["Fly|Ride"] = 52.5, ["Neon"] = 131.25, ["Neon|Ride"] = 150.59, ["Neon|Fly|Ride"] = 146.81, ["Mega|Ride"] = 1420.02, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 42.6, ["Ride"] = 42.19, ["Fly|Ride"] = 102.38, ["Neon"] = 311.32, ["Neon|Fly"] = 1420.2, ["Neon|Ride"] = 202.79, ["Neon|Fly|Ride"] = 262.48, ["Mega|Fly|Ride"] = 1374.27}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 406.88, ["Fly"] = 563.07, ["Ride"] = 481.69, ["Fly|Ride"] = 570.91, ["Neon"] = 1312.5, ["Neon|Fly"] = 1561.79, ["Neon|Ride"] = 1114.19, ["Neon|Fly|Ride"] = 1246.1, ["Mega|Ride"] = 5428.87, ["Mega|Fly|Ride"] = 5260.75}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 7.88, ["Fly"] = 27.76, ["Ride"] = 19.66, ["Fly|Ride"] = 48.57, ["Neon"] = 123.38, ["Neon|Fly"] = 160.78, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 142.91, ["Mega|Ride"] = 781.35, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 9.43, ["Ride"] = 34.54, ["Fly|Ride"] = 80.09, ["Neon"] = 98.43, ["Neon|Ride"] = 83.71, ["Neon|Fly|Ride"] = 209.08, ["Mega"] = 527.29, ["Mega|Ride"] = 566.74, ["Mega|Fly|Ride"] = 526.94}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 104.99, ["Ride"] = 103.68, ["Fly|Ride"] = 233.17, ["Neon"] = 1010.63, ["Neon|Ride"] = 637.79, ["Neon|Fly|Ride"] = 688.82, ["Mega|Fly|Ride"] = 2710.49}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 15.99, ["Fly"] = 85.32, ["Ride"] = 74.63, ["Fly|Ride"] = 319.37, ["Neon"] = 53.25, ["Neon|Ride"] = 118.12, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 212.91, ["Mega|Fly"] = 738.77, ["Mega|Ride"] = 306.94, ["Mega|Fly|Ride"] = 463.58}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3937.5, ["Ride"] = 4035.93, ["Fly|Ride"] = 4029.38, ["Neon"] = 19687.5, ["Neon|Ride"] = 12337.5, ["Neon|Fly|Ride"] = 10328.07, ["Mega"] = 42579.26, ["Mega|Fly|Ride"] = 37945.69}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 40.69, ["Fly"] = 142.68, ["Ride"] = 65.54, ["Fly|Ride"] = 144.38, ["Neon"] = 215.25, ["Neon|Ride"] = 244.13, ["Neon|Fly|Ride"] = 394.53, ["Mega"] = 851.6, ["Mega|Ride"] = 1753.99, ["Mega|Fly|Ride"] = 782.24}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 7558.73, ["Fly"] = 7558.73, ["Ride"] = 6857.82, ["Fly|Ride"] = 5971.88, ["Neon|Fly|Ride"] = 14437.5, ["Mega|Fly|Ride"] = 46921.88}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.63, ["Fly"] = 17.97, ["Ride"] = 16.3, ["Fly|Ride"] = 36.66, ["Neon"] = 24.67, ["Neon|Fly"] = 59.63, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 242.71, ["Mega|Ride"] = 190.55, ["Mega|Fly|Ride"] = 248.07}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 21.29, ["Fly"] = 28.87, ["Ride"] = 32.48, ["Fly|Ride"] = 57.49, ["Neon"] = 185.26, ["Neon|Fly"] = 235.29, ["Neon|Ride"] = 196.08, ["Neon|Fly|Ride"] = 167.99, ["Mega|Ride"] = 994.24, ["Mega|Fly|Ride"] = 956.5}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.94}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 10.94, ["Ride"] = 24.2, ["Fly|Ride"] = 87.02, ["Neon"] = 284.27, ["Neon|Ride"] = 108.95, ["Neon|Fly|Ride"] = 319.23, ["Mega"] = 930.21, ["Mega|Ride"] = 994.24, ["Mega|Fly|Ride"] = 787.74}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 22.31, ["Fly"] = 190.37, ["Ride"] = 48.39, ["Fly|Ride"] = 96.74, ["Neon"] = 203.44, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 945, ["Mega|Ride"] = 851.6, ["Mega|Fly|Ride"] = 1099.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 12.45, ["Fly"] = 27.36, ["Ride"] = 20.81, ["Fly|Ride"] = 32.82, ["Neon|Fly"] = 1061.43, ["Neon|Ride"] = 118.19, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 2554.77, ["Mega|Fly|Ride"] = 562.07}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8659.53}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2624.99}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 21}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 242.86, ["Ride"] = 319.39, ["Fly|Ride"] = 315, ["Mega|Fly|Ride"] = 4200}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 12.91, ["Fly"] = 142.68, ["Ride"] = 38.07, ["Fly|Ride"] = 140.54, ["Neon"] = 119.57, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 142.68, ["Mega"] = 525, ["Mega|Ride"] = 527.29, ["Mega|Fly|Ride"] = 1179.94}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 11.09}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 5.25, ["Ride"] = 25.99, ["Fly|Ride"] = 85.19, ["Neon|Ride"] = 249.38, ["Mega"] = 1561.61}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2239.13}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 127.07, ["Fly"] = 338.56, ["Ride"] = 131.25, ["Fly|Ride"] = 425.86, ["Neon"] = 969.94, ["Neon|Ride"] = 884.71, ["Neon|Fly|Ride"] = 1561.79, ["Mega|Ride"] = 4116.36, ["Mega|Fly|Ride"] = 3936.45}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 58.04, ["Ride"] = 118.19, ["Fly|Ride"] = 239.04, ["Neon"] = 329.44, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 532.25, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 157.46, ["Fly"] = 196.88, ["Ride"] = 157.49, ["Fly|Ride"] = 229.97, ["Neon"] = 944.98, ["Neon|Ride"] = 787.49, ["Neon|Fly|Ride"] = 840, ["Mega"] = 3946.05, ["Mega|Ride"] = 3670.22, ["Mega|Fly|Ride"] = 3084.38}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 2395.31, ["Fly"] = 3265.18, ["Ride"] = 2428.13, ["Fly|Ride"] = 2600.45, ["Neon"] = 14953.5, ["Neon|Ride"] = 9564.24, ["Neon|Fly|Ride"] = 7875, ["Mega|Fly|Ride"] = 26967.59}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 15.74, ["Fly"] = 105.41, ["Ride"] = 37.44, ["Fly|Ride"] = 100.09, ["Neon"] = 119.57, ["Neon|Fly"] = 160.22, ["Neon|Ride"] = 154.62, ["Neon|Fly|Ride"] = 142.68, ["Mega"] = 956.99, ["Mega|Ride"] = 994.24, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 766.53, ["Fly"] = 2100, ["Ride"] = 994.37, ["Fly|Ride"] = 787.5, ["Neon|Fly|Ride"] = 4145.24}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 39.87}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 16.55, ["Ride"] = 42, ["Fly|Ride"] = 337.03, ["Neon"] = 85.19, ["Neon|Ride"] = 107.36, ["Neon|Fly|Ride"] = 259.77, ["Mega"] = 468.81, ["Mega|Fly"] = 956.5, ["Mega|Ride"] = 509.25, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 6.36, ["Fly"] = 32.28, ["Ride"] = 27.57, ["Fly|Ride"] = 123.12, ["Neon"] = 49.88, ["Neon|Fly"] = 315, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 178.5, ["Mega"] = 447.18, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 569.63}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 60.34}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 18.79, ["Fly"] = 107.83, ["Ride"] = 21.41, ["Fly|Ride"] = 80.07, ["Neon|Ride"] = 191.3, ["Neon|Fly|Ride"] = 254.62, ["Mega|Ride"] = 994.24, ["Mega|Fly|Ride"] = 2128.97}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 24.2, ["Fly"] = 39.38, ["Ride"] = 36.75, ["Fly|Ride"] = 52.41, ["Neon|Fly"] = 235.29, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 213.94, ["Mega"] = 1434.76, ["Mega|Ride"] = 1793.45, ["Mega|Fly|Ride"] = 989.63}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6451.54, ["Fly"] = 10237.5, ["Ride"] = 6692.6, ["Fly|Ride"] = 5118.74, ["Neon|Fly|Ride"] = 9843.75, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 7.74, ["Fly"] = 65.63, ["Ride"] = 26.24, ["Fly|Ride"] = 81.37, ["Neon"] = 56.44, ["Neon|Ride"] = 73.97, ["Neon|Fly|Ride"] = 199.11, ["Mega"] = 510.97, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 326.81}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 19.35}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 81.29, ["Fly"] = 376.88, ["Ride"] = 91.87, ["Fly|Ride"] = 183.74, ["Neon"] = 459.38, ["Neon|Ride"] = 464.87, ["Neon|Fly|Ride"] = 481.42, ["Mega"] = 2879.59, ["Mega|Ride"] = 1764.77, ["Mega|Fly|Ride"] = 2199.95}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 42.93, ["Fly"] = 142.68, ["Ride"] = 64.32, ["Fly|Ride"] = 183.12, ["Neon"] = 275.63, ["Neon|Ride"] = 275.62, ["Neon|Fly|Ride"] = 446.25, ["Mega"] = 2391.25, ["Mega|Ride"] = 2874.12, ["Mega|Fly|Ride"] = 1029}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 19.08, ["Fly"] = 45.43, ["Ride"] = 25.98, ["Fly|Ride"] = 52.5, ["Neon"] = 128.77, ["Neon|Fly"] = 229.97, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 207.61, ["Mega"] = 1016.21, ["Mega|Ride"] = 860.86, ["Mega|Fly|Ride"] = 800.62}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 5.13, ["Fly"] = 69.65, ["Ride"] = 23.62, ["Fly|Ride"] = 98.12, ["Neon"] = 31.48, ["Neon|Ride"] = 51.19, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 162.72, ["Mega|Fly"] = 284.23, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 9.76, ["Ride"] = 28.87, ["Fly|Ride"] = 98.05, ["Neon"] = 100.41, ["Neon|Ride"] = 99.75, ["Neon|Fly|Ride"] = 239.12, ["Mega|Ride"] = 483.29, ["Mega|Fly|Ride"] = 425.81}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 21.18, ["Fly"] = 26.25, ["Ride"] = 25.98, ["Fly|Ride"] = 55.13, ["Neon|Fly"] = 144.38, ["Neon|Ride"] = 128.62, ["Neon|Fly|Ride"] = 124.69, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 199.5}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 28.76, ["Ride"] = 131.24, ["Fly|Ride"] = 212.75, ["Neon"] = 183.74, ["Neon|Ride"] = 255.51, ["Neon|Fly|Ride"] = 352.7, ["Mega"] = 738.77, ["Mega|Fly|Ride"] = 678.57}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 237.43, ["Ride"] = 265.33, ["Neon|Ride"] = 17033.75, ["Neon|Fly|Ride"] = 28389.92}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 52.5, ["Fly"] = 213.24, ["Ride"] = 87.28, ["Fly|Ride"] = 170.63, ["Neon"] = 269.07, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 485.63, ["Mega"] = 984.38, ["Mega|Ride"] = 922.92, ["Mega|Fly|Ride"] = 991.06}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 1154.97, ["Fly"] = 1010.63, ["Ride"] = 1022.42, ["Fly|Ride"] = 1030.32, ["Neon|Fly"] = 4336.2, ["Neon|Ride"] = 3976.33, ["Neon|Fly|Ride"] = 3281.25, ["Mega"] = 15942.43, ["Mega|Fly|Ride"] = 12337.5}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 346.5, ["Fly"] = 638.19, ["Ride"] = 367.5, ["Fly|Ride"] = 433.02, ["Neon"] = 2362.5, ["Neon|Ride"] = 1135.96, ["Neon|Fly|Ride"] = 1994.99, ["Mega"] = 12116.44, ["Mega|Fly|Ride"] = 9186.19}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 53.82}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 3.94}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 10.28, ["Fly"] = 27.09, ["Ride"] = 20.98, ["Fly|Ride"] = 52.41, ["Neon"] = 78.75, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 57.64, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 437.26, ["Mega|Ride"] = 710.01, ["Mega|Fly|Ride"] = 551.41}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 236.77, ["Fly"] = 408.54, ["Ride"] = 280.73, ["Fly|Ride"] = 341.25, ["Neon"] = 1170.02, ["Neon|Ride"] = 954.19, ["Neon|Fly|Ride"] = 847.35, ["Mega|Fly|Ride"] = 2801.43}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 13.99}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 95.83, ["Ride"] = 142.71, ["Fly|Ride"] = 242.82, ["Neon"] = 568.52, ["Neon|Fly"] = 610.32, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 656.23, ["Mega"] = 2292.91, ["Mega|Ride"] = 1968.75, ["Mega|Fly|Ride"] = 2108.97}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 110.97, ["Fly"] = 212.94, ["Ride"] = 131.06, ["Fly|Ride"] = 110.25, ["Neon"] = 425.86, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 851.71, ["Mega|Fly|Ride"] = 2550.52}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 4.98, ["Ride"] = 27.2, ["Fly|Ride"] = 52.5, ["Neon"] = 40.06, ["Neon|Ride"] = 69.62, ["Neon|Fly|Ride"] = 250.2, ["Mega"] = 355.56, ["Mega|Ride"] = 189.74, ["Mega|Fly|Ride"] = 326.81}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 13.89, ["Fly"] = 71.35, ["Ride"] = 28.88, ["Fly|Ride"] = 78.65, ["Neon"] = 175.88, ["Neon|Ride"] = 157.49, ["Neon|Fly|Ride"] = 319.25, ["Mega|Ride"] = 1420.02, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 11.97, ["Fly"] = 102.36, ["Ride"] = 31.1, ["Fly|Ride"] = 128.25, ["Neon"] = 52.5, ["Neon|Ride"] = 92.64, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 424.75, ["Mega|Ride"] = 519.75, ["Mega|Fly|Ride"] = 553.55}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 4.8, ["Fly"] = 98.44, ["Ride"] = 45.04, ["Fly|Ride"] = 137.71, ["Neon"] = 26.17, ["Neon|Ride"] = 65.51, ["Neon|Fly|Ride"] = 168.79, ["Mega"] = 150.94, ["Mega|Fly"] = 271.42, ["Mega|Ride"] = 162.49, ["Mega|Fly|Ride"] = 274.32}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 210, ["Ride"] = 229.69, ["Fly|Ride"] = 375.27, ["Neon"] = 1332.91, ["Neon|Ride"] = 1362.92, ["Neon|Fly|Ride"] = 1381.75, ["Mega|Fly|Ride"] = 5658.8}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 83.05, ["Fly"] = 160.16, ["Ride"] = 131.24, ["Fly|Ride"] = 235.85, ["Neon"] = 429.18, ["Neon|Ride"] = 485.63, ["Neon|Fly|Ride"] = 630, ["Mega"] = 1843.69, ["Mega|Ride"] = 1903.13, ["Mega|Fly|Ride"] = 1903.13}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 61, ["Fly"] = 75.59, ["Ride"] = 70.88, ["Fly|Ride"] = 118.13, ["Neon"] = 262.5, ["Neon|Ride"] = 302.39, ["Neon|Fly|Ride"] = 416.07, ["Mega|Ride"] = 1604.18, ["Mega|Fly|Ride"] = 1887.63}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 12.04, ["Fly"] = 126, ["Ride"] = 36.21, ["Fly|Ride"] = 284.27, ["Neon"] = 131.25, ["Neon|Ride"] = 607.35, ["Neon|Fly|Ride"] = 497.19, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 12.01, ["Fly"] = 75.64, ["Ride"] = 28.87, ["Fly|Ride"] = 90.96, ["Neon"] = 77.44, ["Neon|Fly"] = 142.68, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 113.93, ["Mega"] = 712.14, ["Mega|Fly"] = 525, ["Mega|Ride"] = 478.27, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.13, ["Fly"] = 52.5, ["Ride"] = 21.3, ["Fly|Ride"] = 84.12, ["Neon"] = 24.25, ["Neon|Fly"] = 68.3, ["Neon|Ride"] = 38.58, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 164.07, ["Mega|Fly"] = 212.91, ["Mega|Ride"] = 170.39, ["Mega|Fly|Ride"] = 258.79}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 846.45, ["Fly"] = 1082.73, ["Ride"] = 853.11, ["Fly|Ride"] = 853.13, ["Neon"] = 4258.45, ["Neon|Fly"] = 3245.88, ["Neon|Ride"] = 3188.49, ["Neon|Fly|Ride"] = 2624.99, ["Mega|Fly|Ride"] = 8098.23}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 318.94, ["Fly"] = 738.86, ["Ride"] = 283.5, ["Fly|Ride"] = 478.06, ["Neon"] = 1277.54, ["Neon|Ride"] = 1270.5, ["Neon|Fly|Ride"] = 1181.25, ["Mega"] = 10644.82, ["Mega|Fly|Ride"] = 4970.17}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 91.86, ["Fly"] = 134.15, ["Ride"] = 117.57, ["Fly|Ride"] = 177.14, ["Neon"] = 406.88, ["Neon|Fly"] = 478.23, ["Neon|Ride"] = 367.13, ["Neon|Fly|Ride"] = 424.79, ["Mega"] = 1312.5, ["Mega|Ride"] = 1632.92, ["Mega|Fly|Ride"] = 1677.64}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 183.65, ["Fly"] = 283.5, ["Ride"] = 184.69, ["Fly|Ride"] = 246.99, ["Neon|Ride"] = 1275.65, ["Neon|Fly|Ride"] = 917.44, ["Mega"] = 10644.82, ["Mega|Fly|Ride"] = 3975.85}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 23.39, ["Fly"] = 42.6, ["Ride"] = 23.49, ["Fly|Ride"] = 76.13, ["Neon"] = 169.31, ["Neon|Ride"] = 147.07, ["Neon|Fly|Ride"] = 204.75, ["Mega|Ride"] = 638.71, ["Mega|Fly|Ride"] = 904.82}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 190.3, ["Ride"] = 235.96, ["Fly|Ride"] = 347.82, ["Neon"] = 853.64, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 971.25, ["Mega"] = 4253.45, ["Mega|Fly|Ride"] = 3818.31}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 77.42, ["Fly"] = 125.98, ["Ride"] = 80.05, ["Fly|Ride"] = 106.47, ["Neon|Ride"] = 568.52, ["Neon|Fly|Ride"] = 497.19, ["Mega|Fly|Ride"] = 1417.5}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 2310, ["Ride"] = 2362.5, ["Fly|Ride"] = 2362.5, ["Neon|Ride"] = 8516.88, ["Neon|Fly|Ride"] = 6775.08, ["Mega"] = 51095.12, ["Mega|Fly|Ride"] = 26228.83}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 11.31, ["Fly"] = 78.04, ["Ride"] = 31.88, ["Fly|Ride"] = 103.99, ["Neon"] = 62.83, ["Neon|Fly"] = 235.29, ["Neon|Ride"] = 101.07, ["Neon|Fly|Ride"] = 244.88, ["Mega"] = 288.74, ["Mega|Fly"] = 568.45, ["Mega|Ride"] = 317.07, ["Mega|Fly|Ride"] = 392.44}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 57.5, ["Ride"] = 36.75, ["Fly|Ride"] = 113.93, ["Neon"] = 221.45, ["Neon|Ride"] = 425.86, ["Neon|Fly|Ride"] = 479.04, ["Mega|Ride"] = 931.88, ["Mega|Fly|Ride"] = 1064.49}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 79.68, ["Fly"] = 91.87, ["Ride"] = 82.42, ["Fly|Ride"] = 97.12, ["Neon"] = 525, ["Neon|Ride"] = 455.67, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 1879.83}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 2203.69, ["Fly"] = 1594.28, ["Ride"] = 1069.69, ["Fly|Ride"] = 1113.81, ["Neon|Ride"] = 5101.34, ["Neon|Fly|Ride"] = 4725, ["Mega"] = 34773.42, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 525, ["Fly"] = 561.71, ["Ride"] = 561.71, ["Fly|Ride"] = 534.19, ["Mega|Fly|Ride"] = 11354.83}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 64.29, ["Fly"] = 319.1, ["Ride"] = 107.23, ["Fly|Ride"] = 208.69, ["Neon"] = 444.05, ["Neon|Ride"] = 342.44, ["Neon|Fly|Ride"] = 558.37, ["Mega"] = 1988.47, ["Mega|Ride"] = 2551.47, ["Mega|Fly|Ride"] = 1578.93}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 5.53, ["Fly"] = 32.81, ["Ride"] = 19.68, ["Fly|Ride"] = 68.58, ["Neon"] = 46.47, ["Neon|Ride"] = 74.3, ["Neon|Fly|Ride"] = 130.59, ["Mega"] = 553.88, ["Mega|Ride"] = 773.9}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 32.81, ["Fly"] = 68.25, ["Ride"] = 42.7, ["Fly|Ride"] = 123.52, ["Neon"] = 284.82, ["Neon|Fly"] = 355.6, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 334.69, ["Mega|Ride"] = 1187.82, ["Mega|Fly|Ride"] = 1008.08}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 699.57, ["Fly"] = 1099.51, ["Ride"] = 786.19, ["Fly|Ride"] = 860.63, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 1968.75, ["Mega|Fly|Ride"] = 9723}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 591.51}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 6562.5, ["Ride"] = 5558.91, ["Fly|Ride"] = 5512.5, ["Neon"] = 42000, ["Neon|Ride"] = 30512.75, ["Neon|Fly|Ride"] = 18375, ["Mega|Fly|Ride"] = 106306.57}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 261.19, ["Fly"] = 399.25, ["Ride"] = 284.27, ["Fly|Ride"] = 415.91, ["Neon"] = 1312.5, ["Neon|Ride"] = 1846.05, ["Neon|Fly|Ride"] = 1706.25, ["Mega"] = 6385.84, ["Mega|Ride"] = 6101.63, ["Mega|Fly|Ride"] = 6103.75}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 65.63, ["Fly"] = 284.27, ["Ride"] = 131.15, ["Fly|Ride"] = 336, ["Neon"] = 424.79, ["Neon|Ride"] = 851.71, ["Neon|Fly|Ride"] = 634.53, ["Mega|Fly|Ride"] = 2128.97}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 15.57, ["Fly"] = 96.9, ["Ride"] = 28.86, ["Fly|Ride"] = 85.22, ["Neon"] = 176.96, ["Neon|Fly"] = 1275.65, ["Neon|Ride"] = 126, ["Neon|Fly|Ride"] = 199.68, ["Mega|Ride"] = 620.61, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 11.69, ["Fly"] = 26.24, ["Ride"] = 23.43, ["Fly|Ride"] = 54.31, ["Neon"] = 142.68, ["Neon|Ride"] = 113.93, ["Neon|Fly|Ride"] = 125.6, ["Mega"] = 1312.5, ["Mega|Ride"] = 380.63, ["Mega|Fly|Ride"] = 2128.97}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 15.81, ["Fly"] = 284.27, ["Ride"] = 26.25, ["Fly|Ride"] = 89.92, ["Neon"] = 124.67, ["Neon|Ride"] = 113.18, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 645.75, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 595.06}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 3.15, ["Fly"] = 62.83, ["Ride"] = 20.25, ["Fly|Ride"] = 48.55, ["Neon"] = 31.39, ["Neon|Ride"] = 53.25, ["Neon|Fly|Ride"] = 125.64, ["Mega"] = 661.56, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 319.25}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 30.07, ["Fly"] = 90.57, ["Ride"] = 45.92, ["Fly|Ride"] = 139.13, ["Neon"] = 156.58, ["Neon|Fly"] = 851.71, ["Neon|Ride"] = 229.97, ["Neon|Fly|Ride"] = 451.5, ["Mega"] = 630, ["Mega|Ride"] = 1260}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 485.52, ["Fly"] = 538.13, ["Ride"] = 492.19, ["Fly|Ride"] = 505.32, ["Neon"] = 1916.31, ["Neon|Ride"] = 1874.79, ["Neon|Fly|Ride"] = 1541.33, ["Mega"] = 7875, ["Mega|Fly|Ride"] = 5812.08}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 14.6, ["Fly|Ride"] = 32.82, ["Neon"] = 28.76, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 77.44, ["Mega"] = 170.63, ["Mega|Ride"] = 225.69, ["Mega|Fly|Ride"] = 213.94}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 48.53, ["Fly"] = 110.24, ["Ride"] = 65.63, ["Fly|Ride"] = 131.15, ["Neon"] = 220.5, ["Neon|Fly"] = 333.15, ["Neon|Ride"] = 207.38, ["Neon|Fly|Ride"] = 278.24, ["Mega"] = 524.99, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 610.32}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 809.76, ["Ride"] = 767.82, ["Fly|Ride"] = 792.75, ["Neon|Ride"] = 1988.7, ["Neon|Fly|Ride"] = 1640.62, ["Mega|Fly|Ride"] = 4200}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 31, ["Fly"] = 64.98, ["Ride"] = 44.52, ["Fly|Ride"] = 78.75, ["Neon"] = 262.49, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 163.95, ["Neon|Fly|Ride"] = 249.35, ["Mega"] = 1195.64, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 315, ["Fly"] = 355.6, ["Ride"] = 249.38, ["Fly|Ride"] = 328.13, ["Neon|Ride"] = 1561.79, ["Neon|Fly|Ride"] = 945.68}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 194.25, ["Fly"] = 262.49, ["Ride"] = 203.44, ["Fly|Ride"] = 210, ["Neon"] = 994.37, ["Neon|Ride"] = 892.5, ["Neon|Fly|Ride"] = 723.96, ["Mega"] = 4326, ["Mega|Fly|Ride"] = 4270.67}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 903.62, ["Ride"] = 766.53, ["Fly|Ride"] = 952.84, ["Neon"] = 2873.39, ["Neon|Ride"] = 3761.16, ["Neon|Fly|Ride"] = 3120.38, ["Mega|Fly|Ride"] = 9711.19}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 16.19, ["Fly"] = 61.77, ["Ride"] = 41.53, ["Fly|Ride"] = 111.57, ["Neon"] = 78.75, ["Neon|Fly"] = 286.95, ["Neon|Ride"] = 91.62, ["Neon|Fly|Ride"] = 142.68, ["Mega"] = 354.38, ["Mega|Ride"] = 314.03, ["Mega|Fly|Ride"] = 624.87}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 3832.6, ["Fly"] = 3438.49, ["Ride"] = 3936.19, ["Fly|Ride"] = 3346.88, ["Neon|Fly|Ride"] = 7218.75, ["Mega|Fly|Ride"] = 25898.25}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 115.29, ["Fly"] = 170.36, ["Ride"] = 142.7, ["Fly|Ride"] = 191.67, ["Neon"] = 498.75, ["Neon|Fly"] = 712.69, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 577.5, ["Mega|Ride"] = 2697.41, ["Mega|Fly|Ride"] = 2980.57}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 3.14, ["Fly"] = 19.59, ["Ride"] = 15.65, ["Fly|Ride"] = 39.38, ["Neon"] = 23.46, ["Neon|Fly"] = 65.61, ["Neon|Ride"] = 37.41, ["Neon|Fly|Ride"] = 102.9, ["Mega"] = 160.1, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 245.75, ["Mega|Fly|Ride"] = 233.15}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 4.2, ["Ride"] = 26.24, ["Fly|Ride"] = 57.71, ["Neon"] = 19.78, ["Neon|Fly"] = 117.17, ["Neon|Ride"] = 64.29, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 163.45, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 32.74, ["Fly"] = 42.63, ["Ride"] = 42.6, ["Fly|Ride"] = 56.35, ["Neon"] = 286.84, ["Neon|Ride"] = 310.86, ["Neon|Fly|Ride"] = 253.8, ["Mega|Fly|Ride"] = 1097.5}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 800.61, ["Fly"] = 1242.92, ["Ride"] = 1025.2, ["Fly|Ride"] = 984.38, ["Neon"] = 4684.29, ["Neon|Fly|Ride"] = 4826.96}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 6297.38, ["Ride"] = 8020.77, ["Fly|Ride"] = 6364.32}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 18.05, ["Fly"] = 29.61, ["Ride"] = 23.1, ["Fly|Ride"] = 44.3, ["Neon"] = 452.13, ["Neon|Ride"] = 114.19, ["Neon|Fly|Ride"] = 141.37, ["Mega"] = 2520, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 15.35, ["Fly"] = 57.65, ["Ride"] = 26.25, ["Fly|Ride"] = 80.64, ["Neon"] = 85.13, ["Neon|Ride"] = 78.94, ["Neon|Fly|Ride"] = 169.32, ["Mega"] = 662.17, ["Mega|Ride"] = 479.07, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 87.88, ["Fly"] = 157.5, ["Ride"] = 87.91, ["Fly|Ride"] = 144.38, ["Neon|Ride"] = 448.28, ["Neon|Fly|Ride"] = 496.02, ["Mega|Fly|Ride"] = 1685.63}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 215.25, ["Fly"] = 241.5, ["Ride"] = 221.8, ["Fly|Ride"] = 301.88, ["Neon"] = 956.44, ["Neon|Ride"] = 1181.2, ["Neon|Fly|Ride"] = 984.38, ["Mega"] = 8515.87, ["Mega|Fly"] = 3987.41, ["Mega|Fly|Ride"] = 4465.65}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 5.13, ["Ride"] = 32.71, ["Fly|Ride"] = 93.19, ["Neon"] = 24.4, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 61.77, ["Mega"] = 144.18, ["Mega|Fly"] = 237.39, ["Mega|Ride"] = 191.52, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 177.51, ["Fly"] = 231.71, ["Ride"] = 203.44, ["Fly|Ride"] = 262.49, ["Neon"] = 656.25, ["Neon|Ride"] = 688.67, ["Neon|Fly|Ride"] = 778.24, ["Mega|Fly|Ride"] = 2576.44}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 2.1, ["Fly"] = 25.56, ["Ride"] = 17.07, ["Fly|Ride"] = 59.07, ["Neon"] = 31.5, ["Neon|Fly"] = 71.35, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 108.94, ["Mega"] = 225.75, ["Mega|Ride"] = 219.19, ["Mega|Fly|Ride"] = 284.23}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 190.32, ["Fly"] = 344.94, ["Ride"] = 207.9, ["Fly|Ride"] = 249.59, ["Neon"] = 1277.54, ["Neon|Ride"] = 1195.55, ["Neon|Fly|Ride"] = 1013.25, ["Mega"] = 10644.82, ["Mega|Fly|Ride"] = 4782.49}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 8.59, ["Fly"] = 77.44, ["Ride"] = 28.27, ["Fly|Ride"] = 68.25, ["Neon"] = 73.5, ["Neon|Fly"] = 303.69, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 155.93, ["Mega"] = 568.45, ["Mega|Ride"] = 526.94, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.1, ["Ride"] = 21.07, ["Fly|Ride"] = 51.19, ["Neon"] = 8.37, ["Neon|Fly"] = 170.46, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 195.56, ["Mega"] = 84.67, ["Mega|Ride"] = 122.99, ["Mega|Fly|Ride"] = 170.61}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.88, ["Mega"] = 19.68, ["Mega|Ride"] = 142.65, ["Mega|Fly|Ride"] = 160.23}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 2.1, ["Ride"] = 31.95, ["Fly|Ride"] = 113.93, ["Neon"] = 5.11, ["Neon|Ride"] = 27.91, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 69.29, ["Mega|Fly"] = 159416.91, ["Mega|Ride"] = 76.02, ["Mega|Fly|Ride"] = 211.3}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 58.99, ["Fly"] = 124.69, ["Ride"] = 88.41, ["Fly|Ride"] = 213.93, ["Neon"] = 339.93, ["Neon|Fly"] = 327.97, ["Neon|Ride"] = 294, ["Neon|Fly|Ride"] = 389.82, ["Mega|Fly|Ride"] = 1405.13}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 37.07, ["Ride"] = 16.96, ["Fly|Ride"] = 83.05, ["Neon"] = 7.5, ["Neon|Fly"] = 63.89, ["Neon|Ride"] = 19.68, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 85.86, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 262.47}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 9.72, ["Ride"] = 70.27, ["Neon"] = 82.26, ["Neon|Fly"] = 286.95, ["Neon|Ride"] = 212.63, ["Neon|Fly|Ride"] = 223.12, ["Mega"] = 261.18, ["Mega|Ride"] = 539.7}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 2.1, ["Neon|Ride"] = 55.25, ["Mega"] = 15.75, ["Mega|Fly"] = 142.65, ["Mega|Ride"] = 44.89, ["Mega|Fly|Ride"] = 189.92}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 71.28, ["Ride"] = 15.65, ["Fly|Ride"] = 11.82, ["Neon"] = 2.1, ["Neon|Fly"] = 37.08, ["Neon|Ride"] = 14.31, ["Neon|Fly|Ride"] = 32.8, ["Mega"] = 11.69, ["Mega|Fly"] = 31.66, ["Mega|Ride"] = 21, ["Mega|Fly|Ride"] = 61.05}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.73, ["Fly|Ride"] = 52.5, ["Neon"] = 2.1, ["Neon|Fly"] = 21, ["Neon|Ride"] = 15.43, ["Neon|Fly|Ride"] = 42.84, ["Mega"] = 18.38, ["Mega|Fly"] = 160.23, ["Mega|Ride"] = 34.08, ["Mega|Fly|Ride"] = 64.73}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 59.95, ["Mega"] = 19.69, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 91.86, ["Ride"] = 21, ["Fly|Ride"] = 107.62, ["Neon"] = 5.71, ["Neon|Fly"] = 121.53, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 83.22, ["Mega"] = 33.47, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 38.07, ["Mega|Fly|Ride"] = 97.95}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 82.09, ["Neon|Fly|Ride"] = 425.86, ["Mega"] = 20.98, ["Mega|Fly"] = 129.14, ["Mega|Ride"] = 69.57, ["Mega|Fly|Ride"] = 212.91}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 3.63, ["Fly"] = 77.43, ["Ride"] = 36.36, ["Fly|Ride"] = 158.05, ["Neon"] = 23.63, ["Neon|Fly"] = 108.81, ["Neon|Ride"] = 49.23, ["Neon|Fly|Ride"] = 104.99, ["Mega"] = 116.83, ["Mega|Fly"] = 280.98, ["Mega|Ride"] = 153.49, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 51.98, ["Neon"] = 2.1, ["Neon|Ride"] = 42.71, ["Neon|Fly|Ride"] = 319.23, ["Mega"] = 14.57, ["Mega|Fly"] = 144.27, ["Mega|Ride"] = 72.35, ["Mega|Fly|Ride"] = 196.77}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.1, ["Ride"] = 143.74, ["Fly|Ride"] = 142.68, ["Neon"] = 18.15, ["Mega"] = 135.19, ["Mega|Fly"] = 315, ["Mega|Ride"] = 274.31, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Ride"] = 26.24, ["Neon"] = 16.87, ["Neon|Ride"] = 71.34, ["Mega"] = 131.25, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 568.45}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 3.87, ["Neon|Ride"] = 27.69, ["Neon|Fly|Ride"] = 142.68, ["Mega"] = 20.98, ["Mega|Ride"] = 44.62, ["Mega|Fly|Ride"] = 98.01}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.14, ["Ride"] = 14.32, ["Fly|Ride"] = 26.25, ["Neon"] = 2.1, ["Neon|Fly"] = 28.71, ["Neon|Ride"] = 14.43, ["Neon|Fly|Ride"] = 37.8, ["Mega"] = 11.8, ["Mega|Fly"] = 32.8, ["Mega|Ride"] = 19.68, ["Mega|Fly|Ride"] = 51.19}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.1, ["Fly"] = 72.19, ["Ride"] = 229.68, ["Fly|Ride"] = 118.1, ["Neon"] = 33.16, ["Neon|Ride"] = 140.95, ["Mega"] = 214.1, ["Mega|Ride"] = 191.63}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 31.84, ["Neon"] = 3.81, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 23.63, ["Mega|Ride"] = 48.33, ["Mega|Fly|Ride"] = 115.5}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 2.1, ["Neon"] = 17.14, ["Mega"] = 85.31, ["Mega|Ride"] = 160.75, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.1, ["Fly"] = 78.92, ["Ride"] = 19.69, ["Neon"] = 11.79, ["Neon|Ride"] = 42.6, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 124.69, ["Mega|Ride"] = 165.01, ["Mega|Fly|Ride"] = 191.31}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 14.23, ["Ride"] = 14.9, ["Fly|Ride"] = 31.47, ["Neon"] = 2.1, ["Neon|Fly"] = 15.38, ["Neon|Ride"] = 12.89, ["Neon|Fly|Ride"] = 28.76, ["Mega"] = 12.89, ["Mega|Fly"] = 28.17, ["Mega|Ride"] = 24.5, ["Mega|Fly|Ride"] = 52.47}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 28.76, ["Ride"] = 27.42, ["Fly|Ride"] = 142.68, ["Neon"] = 12.83, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 196.47, ["Mega"] = 129.65, ["Mega|Ride"] = 160.78, ["Mega|Fly|Ride"] = 160.23}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 3.26, ["Fly"] = 21.31, ["Ride"] = 40.57, ["Fly|Ride"] = 59.07, ["Neon"] = 38.98, ["Neon|Ride"] = 69.57, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 232.61, ["Mega|Ride"] = 297.51, ["Mega|Fly|Ride"] = 319.25}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 32.61, ["Ride"] = 14.44, ["Fly|Ride"] = 28.76, ["Neon"] = 2.1, ["Neon|Fly"] = 21.31, ["Neon|Ride"] = 15.58, ["Neon|Fly|Ride"] = 32.18, ["Mega"] = 19.83, ["Mega|Ride"] = 31.5, ["Mega|Fly|Ride"] = 79.19}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.1, ["Fly"] = 177.8, ["Ride"] = 45.9, ["Neon"] = 7.87, ["Neon|Ride"] = 36.21, ["Neon|Fly|Ride"] = 169.29, ["Mega"] = 64.58, ["Mega|Fly"] = 170.33, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 212.91}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 35.43, ["Neon"] = 3.83, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 284.27, ["Mega"] = 26.25, ["Mega|Fly"] = 63.89, ["Mega|Ride"] = 80.07, ["Mega|Fly|Ride"] = 340.65}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 32.28, ["Ride"] = 20.89, ["Neon"] = 2.1, ["Neon|Ride"] = 25.56, ["Neon|Fly|Ride"] = 284.27, ["Mega"] = 11.58, ["Mega|Fly"] = 253.82, ["Mega|Ride"] = 41.06, ["Mega|Fly|Ride"] = 156.18}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 71.35, ["Ride"] = 15.28, ["Fly|Ride"] = 46.56, ["Neon"] = 4.8, ["Neon|Fly"] = 54.31, ["Neon|Ride"] = 17.18, ["Neon|Fly|Ride"] = 60.69, ["Mega"] = 71.75, ["Mega|Ride"] = 73.5, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 23.91, ["Neon"] = 5.24, ["Neon|Ride"] = 68.25, ["Mega"] = 40.84, ["Mega|Fly"] = 319.25, ["Mega|Ride"] = 103.69, ["Mega|Fly|Ride"] = 249.37}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 19.5, ["Ride"] = 15.66, ["Fly|Ride"] = 42.6, ["Neon"] = 3.94, ["Neon|Fly"] = 28.76, ["Neon|Ride"] = 23.57, ["Neon|Fly|Ride"] = 57.5, ["Mega"] = 111.57, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 123.38}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 2.1, ["Ride"] = 38.97, ["Neon"] = 9.11, ["Neon|Fly"] = 188.89, ["Neon|Ride"] = 81.37, ["Neon|Fly|Ride"] = 319.39, ["Mega"] = 102.37, ["Mega|Fly"] = 341.25, ["Mega|Ride"] = 112.41}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Fly"] = 25.77, ["Ride"] = 15.6, ["Fly|Ride"] = 32.8, ["Neon"] = 4.8, ["Neon|Fly"] = 21.31, ["Neon|Ride"] = 32.23, ["Neon|Fly|Ride"] = 85.19, ["Mega"] = 264.01, ["Mega|Fly"] = 420, ["Mega|Ride"] = 142.65, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.1, ["Fly"] = 18.19, ["Ride"] = 17.07, ["Fly|Ride"] = 73.5, ["Neon"] = 4.8, ["Neon|Fly"] = 66.96, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 85.19, ["Mega"] = 170.33, ["Mega|Ride"] = 425.81, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 112.86, ["Neon"] = 98.64, ["Neon|Fly|Ride"] = 2625, ["Mega"] = 224.45, ["Mega|Ride"] = 308.72}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 9.19, ["Ride"] = 56.44, ["Neon"] = 202, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 794.07, ["Mega"] = 636.58, ["Mega|Ride"] = 728.44, ["Mega|Fly|Ride"] = 981.75}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 3.93, ["Ride"] = 28.76, ["Fly|Ride"] = 106.47, ["Neon"] = 44.62, ["Neon|Ride"] = 106.55, ["Mega"] = 160.23, ["Mega|Ride"] = 365.54}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 6.48, ["Ride"] = 32.02, ["Fly|Ride"] = 120.75, ["Neon"] = 47.77, ["Neon|Ride"] = 63, ["Mega"] = 357, ["Mega|Ride"] = 411.97, ["Mega|Fly|Ride"] = 442.98}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Ride"] = 28.76, ["Neon"] = 2.54, ["Neon|Ride"] = 65.02, ["Mega"] = 17.07, ["Mega|Fly"] = 122.42, ["Mega|Ride"] = 78.93, ["Mega|Fly|Ride"] = 232.39}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 43.8}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 6.01, ["Fly"] = 23.63, ["Ride"] = 19.58, ["Fly|Ride"] = 43.32, ["Neon"] = 44.61, ["Neon|Fly"] = 188.48, ["Neon|Ride"] = 47.59, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 271.45, ["Mega|Ride"] = 208.69, ["Mega|Fly|Ride"] = 266.97}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.79, ["Ride"] = 16.96, ["Fly|Ride"] = 64.56, ["Neon"] = 2.1, ["Neon|Fly"] = 52.8, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 105, ["Mega"] = 24.93, ["Mega|Fly"] = 142.65, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 98.43}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 25.56, ["Neon"] = 6.13, ["Neon|Ride"] = 36.74, ["Neon|Fly|Ride"] = 97.96, ["Mega"] = 32.53, ["Mega|Ride"] = 55.11, ["Mega|Fly|Ride"] = 115.96}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 42.6, ["Ride"] = 15.75, ["Fly|Ride"] = 32.78, ["Neon"] = 7.95, ["Neon|Ride"] = 21.27, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 142.86, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 236.33}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 3.92, ["Fly"] = 42.6, ["Ride"] = 31.5, ["Fly|Ride"] = 65.63, ["Neon"] = 47.6, ["Neon|Ride"] = 208.13, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 162.18, ["Mega|Ride"] = 364.07, ["Mega|Fly|Ride"] = 319.36}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Ride"] = 21, ["Neon"] = 2.62, ["Mega"] = 21.2, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 52.4, ["Mega|Fly|Ride"] = 340.65}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 27.57, ["Ride"] = 16.95, ["Fly|Ride"] = 34.09, ["Neon"] = 3.75, ["Neon|Fly"] = 113, ["Neon|Ride"] = 19.68, ["Neon|Fly|Ride"] = 95.66, ["Mega"] = 27.76, ["Mega|Fly"] = 143.16, ["Mega|Ride"] = 45.94, ["Mega|Fly|Ride"] = 112.85}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 14.3, ["Ride"] = 15.63, ["Fly|Ride"] = 42.7, ["Neon"] = 8.53, ["Neon|Fly"] = 53.25, ["Neon|Ride"] = 20.88, ["Neon|Fly|Ride"] = 50.05, ["Mega"] = 65.63, ["Mega|Fly"] = 142.65, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 85.44}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 91.88, ["Ride"] = 37.37, ["Fly|Ride"] = 142.68, ["Neon"] = 4.86, ["Neon|Ride"] = 39.29, ["Neon|Fly|Ride"] = 105, ["Mega"] = 65.54, ["Mega|Ride"] = 89.38, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 3.9, ["Neon|Ride"] = 112.4, ["Neon|Fly|Ride"] = 153982.94, ["Mega"] = 18.26, ["Mega|Fly"] = 106.46, ["Mega|Ride"] = 55.13, ["Mega|Fly|Ride"] = 136.49}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 45.91, ["Ride"] = 19.66, ["Fly|Ride"] = 32.82, ["Neon"] = 2.1, ["Neon|Fly"] = 27.51, ["Neon|Ride"] = 20.39, ["Neon|Fly|Ride"] = 95.94, ["Mega"] = 15.12, ["Mega|Fly"] = 63.89, ["Mega|Ride"] = 35.13, ["Mega|Fly|Ride"] = 87.84}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Fly|Ride"] = 113.93, ["Mega"] = 19.69, ["Mega|Fly"] = 122.42, ["Mega|Ride"] = 157.5}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.5, ["Neon"] = 3.94, ["Neon|Fly|Ride"] = 420, ["Mega"] = 31.95, ["Mega|Ride"] = 193.75, ["Mega|Fly|Ride"] = 217.17}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 15.75, ["Fly|Ride"] = 47.24, ["Neon"] = 6.57, ["Neon|Fly"] = 32.81, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 42.6, ["Mega"] = 34.11, ["Mega|Fly"] = 45.78, ["Mega|Fly|Ride"] = 107.57}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 10.37, ["Ride"] = 78.74, ["Fly|Ride"] = 212.94, ["Neon"] = 68.14, ["Neon|Ride"] = 98.89, ["Mega"] = 406.88, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 710.01}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.1, ["Fly"] = 6562.5, ["Ride"] = 26.23, ["Neon"] = 32.82, ["Neon|Ride"] = 157.5, ["Mega"] = 183.75, ["Mega|Fly|Ride"] = 568.45}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 3.93, ["Ride"] = 32.13, ["Fly|Ride"] = 181, ["Neon"] = 20.26, ["Neon|Ride"] = 71.35, ["Mega"] = 248.71, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 15.64, ["Ride"] = 10.5, ["Fly|Ride"] = 27.69, ["Neon"] = 2.1, ["Neon|Fly"] = 18.26, ["Neon|Ride"] = 13.13, ["Neon|Fly|Ride"] = 23.39, ["Mega"] = 9.17, ["Mega|Fly"] = 19.14, ["Mega|Ride"] = 19.67, ["Mega|Fly|Ride"] = 42.6}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 3.84, ["Fly"] = 118.12, ["Ride"] = 59.79, ["Neon"] = 5.9, ["Neon|Fly"] = 67.79, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 710.11, ["Mega"] = 85.31, ["Mega|Ride"] = 85.32}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Fly"] = 71.35, ["Ride"] = 26.25, ["Neon"] = 2.1, ["Neon|Fly"] = 31.95, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 86.65, ["Mega"] = 12.49, ["Mega|Fly"] = 63.89, ["Mega|Fly|Ride"] = 140.53}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 3.31, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 127.32, ["Mega"] = 13.02, ["Mega|Fly"] = 212.91, ["Mega|Ride"] = 57.5, ["Mega|Fly|Ride"] = 319.25}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 126.29, ["Ride"] = 17.21, ["Fly|Ride"] = 52.5, ["Neon"] = 10.5, ["Neon|Ride"] = 40.6, ["Neon|Fly|Ride"] = 76.13, ["Mega"] = 170.62, ["Mega|Ride"] = 160.13, ["Mega|Fly|Ride"] = 292.04}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 132.43, ["Ride"] = 224.2, ["Fly|Ride"] = 383.27, ["Neon|Fly|Ride"] = 975.2, ["Mega"] = 8515.87, ["Mega|Fly|Ride"] = 3150}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Ride"] = 27.5, ["Neon"] = 4.99, ["Neon|Ride"] = 64.31, ["Mega"] = 68.06, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 2.83, ["Fly"] = 103.68, ["Ride"] = 24.69, ["Fly|Ride"] = 63.67, ["Neon"] = 32.49, ["Neon|Ride"] = 170.84, ["Neon|Fly|Ride"] = 142.68, ["Mega"] = 381.89, ["Mega|Ride"] = 223.6, ["Mega|Fly|Ride"] = 638.48}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 28.76, ["Ride"] = 15.71, ["Fly|Ride"] = 32.8, ["Neon"] = 3.75, ["Neon|Fly"] = 33.03, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 46.93, ["Mega"] = 49.67, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 106.46}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 71.35, ["Ride"] = 19.19, ["Fly|Ride"] = 92.59, ["Neon"] = 8.97, ["Neon|Ride"] = 56.72, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 51.1, ["Mega|Ride"] = 191.31, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 5.92, ["Fly"] = 28.87, ["Ride"] = 15.74, ["Fly|Ride"] = 36.73, ["Neon"] = 26.82, ["Neon|Fly"] = 100.09, ["Neon|Ride"] = 38.33, ["Neon|Fly|Ride"] = 77.97, ["Mega|Ride"] = 284.23, ["Mega|Fly|Ride"] = 294}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 3.61, ["Ride"] = 34.29, ["Fly|Ride"] = 47.81, ["Neon"] = 48.06, ["Neon|Ride"] = 85.19, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 216.56, ["Mega|Ride"] = 390.36, ["Mega|Fly|Ride"] = 387.18}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.1, ["Fly"] = 18.8, ["Ride"] = 14.44, ["Fly|Ride"] = 36.07, ["Neon"] = 18, ["Neon|Fly"] = 70.06, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 63.95, ["Mega"] = 360.87, ["Mega|Ride"] = 284.23, ["Mega|Fly|Ride"] = 249.27}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 44.99, ["Fly"] = 110.74, ["Ride"] = 79.82, ["Fly|Ride"] = 143.34, ["Neon"] = 341.25, ["Neon|Fly"] = 437.07, ["Neon|Ride"] = 402.84, ["Neon|Fly|Ride"] = 435.8, ["Mega|Fly|Ride"] = 1468.59}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 235.67, ["Fly"] = 425.86, ["Ride"] = 246.75, ["Fly|Ride"] = 315, ["Neon|Ride"] = 1116.65, ["Neon|Fly|Ride"] = 965.62, ["Mega"] = 10644.82, ["Mega|Fly|Ride"] = 4964.75}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 59.03, ["Fly"] = 85.2, ["Ride"] = 75.74, ["Fly|Ride"] = 95.29, ["Neon"] = 478.23, ["Neon|Ride"] = 290.07, ["Neon|Fly|Ride"] = 286.79, ["Mega|Ride"] = 1277.39, ["Mega|Fly|Ride"] = 1424.54}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 2.57, ["Fly"] = 287.99, ["Ride"] = 23.39, ["Neon"] = 35.49, ["Neon|Ride"] = 99.75, ["Neon|Fly|Ride"] = 284.27, ["Mega"] = 196.09, ["Mega|Ride"] = 196.75, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 9.85, ["Fly"] = 71.35, ["Ride"] = 31.5, ["Fly|Ride"] = 64.22, ["Neon"] = 85.19, ["Neon|Ride"] = 87.35, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 568.45, ["Mega|Ride"] = 340.53, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 31.49, ["Ride"] = 15.75, ["Fly|Ride"] = 51.17, ["Neon"] = 3.93, ["Neon|Fly"] = 24.5, ["Neon|Ride"] = 24.27, ["Neon|Fly|Ride"] = 39.94, ["Mega"] = 32.81, ["Mega|Fly"] = 147.52, ["Mega|Ride"] = 213.94, ["Mega|Fly|Ride"] = 527.29}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 10.66, ["Fly"] = 39.38, ["Ride"] = 25.56, ["Fly|Ride"] = 66.25, ["Neon"] = 100.44, ["Neon|Fly"] = 284.27, ["Neon|Ride"] = 107.63, ["Neon|Fly|Ride"] = 227.84, ["Mega"] = 398.13, ["Mega|Ride"] = 478.27, ["Mega|Fly|Ride"] = 732.38}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 21.31, ["Ride"] = 15.09, ["Fly|Ride"] = 39.29, ["Neon"] = 10.5, ["Neon|Fly"] = 80.12, ["Neon|Ride"] = 28.6, ["Neon|Fly|Ride"] = 71.35, ["Mega"] = 118.13, ["Mega|Ride"] = 160.23, ["Mega|Fly|Ride"] = 234.44}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 2.1, ["Ride"] = 28.76, ["Fly|Ride"] = 328.13, ["Neon"] = 43.31, ["Neon|Ride"] = 36.21, ["Mega"] = 199.07, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 27.68, ["Ride"] = 19.37, ["Neon"] = 2.1, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 13.12, ["Mega|Fly"] = 30.19, ["Mega|Ride"] = 42.6, ["Mega|Fly|Ride"] = 78.74}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 19.68, ["Fly|Ride"] = 42.6, ["Neon"] = 12.52, ["Neon|Fly"] = 106.47, ["Neon|Ride"] = 35.15, ["Neon|Fly|Ride"] = 147, ["Mega"] = 72.19, ["Mega|Fly|Ride"] = 267.21}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 3.68, ["Fly"] = 26.74, ["Ride"] = 17.38, ["Fly|Ride"] = 62.84, ["Neon"] = 18.38, ["Neon|Ride"] = 47.25, ["Mega"] = 131.18, ["Mega|Ride"] = 266.44, ["Mega|Fly|Ride"] = 248.07}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 105.93, ["Fly"] = 143.07, ["Ride"] = 143.08, ["Fly|Ride"] = 196.01, ["Neon"] = 489.57, ["Neon|Fly"] = 638.43, ["Neon|Ride"] = 437.37, ["Neon|Fly|Ride"] = 531.57, ["Mega"] = 4257.94, ["Mega|Fly|Ride"] = 2255.66}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 7.88, ["Ride"] = 118.13, ["Fly|Ride"] = 127.89, ["Neon"] = 38.97, ["Neon|Ride"] = 98.42, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 280.88, ["Mega|Ride"] = 435.22, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 42.6, ["Ride"] = 18.71, ["Fly|Ride"] = 36.74, ["Neon"] = 22.5, ["Neon|Ride"] = 32.43, ["Neon|Fly|Ride"] = 120.64, ["Mega"] = 246.75, ["Mega|Ride"] = 187.69, ["Mega|Fly|Ride"] = 320.24}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 20.77, ["Ride"] = 53.45, ["Fly|Ride"] = 170.63, ["Neon"] = 144.38, ["Neon|Ride"] = 161.34, ["Neon|Fly|Ride"] = 709.04, ["Mega"] = 638.48, ["Mega|Fly"] = 851.6, ["Mega|Ride"] = 694.71, ["Mega|Fly|Ride"] = 638.48}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 2.1}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 6.56, ["Ride"] = 28.84, ["Fly|Ride"] = 126.7, ["Neon"] = 40.65, ["Neon|Fly"] = 89.25, ["Neon|Ride"] = 142.68, ["Neon|Fly|Ride"] = 326.86, ["Mega"] = 332.13, ["Mega|Ride"] = 589.92, ["Mega|Fly|Ride"] = 885.94}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 24.85, ["Fly"] = 34.17, ["Ride"] = 24.96, ["Fly|Ride"] = 42, ["Neon"] = 400.31, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 135.22, ["Neon|Fly|Ride"] = 163.36, ["Mega"] = 1374.27, ["Mega|Fly|Ride"] = 526.83}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 20.99, ["Fly|Ride"] = 52.49, ["Neon"] = 3.9, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 27.45, ["Neon|Fly|Ride"] = 107.62, ["Mega"] = 29.52, ["Mega|Fly"] = 189, ["Mega|Ride"] = 57.5, ["Mega|Fly|Ride"] = 230}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 3.78, ["Fly"] = 32.53, ["Ride"] = 19.9, ["Fly|Ride"] = 65.54, ["Neon"] = 57.5, ["Neon|Ride"] = 63.89, ["Mega"] = 270.39, ["Mega|Fly"] = 399.35, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 565.25}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 21.38, ["Ride"] = 15.16, ["Fly|Ride"] = 42.6, ["Neon"] = 12.26, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 31.02, ["Neon|Fly|Ride"] = 77.44, ["Mega"] = 138.9, ["Mega|Ride"] = 204.36, ["Mega|Fly|Ride"] = 275.73}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 28.87, ["Fly|Ride"] = 57.58, ["Neon"] = 3.85, ["Neon|Fly"] = 271.87, ["Neon|Ride"] = 32.71, ["Mega"] = 21.95, ["Mega|Ride"] = 57.5, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 20.68, ["Fly"] = 138.91, ["Ride"] = 68.24, ["Fly|Ride"] = 136.5, ["Neon"] = 127.24, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 568.45, ["Mega"] = 727.65, ["Mega|Ride"] = 860.43, ["Mega|Fly|Ride"] = 956.5}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.94, ["Fly"] = 28.76, ["Ride"] = 47.25, ["Fly|Ride"] = 210, ["Neon"] = 95.82, ["Mega|Ride"] = 525}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 6.4, ["Fly"] = 28.84, ["Ride"] = 18.8, ["Fly|Ride"] = 61.15, ["Neon"] = 4.8, ["Neon|Fly"] = 85.19, ["Neon|Ride"] = 26.23, ["Neon|Fly|Ride"] = 71.8, ["Mega"] = 460.04, ["Mega|Fly|Ride"] = 271.42}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 73.98, ["Fly"] = 433.13, ["Ride"] = 393.75, ["Fly|Ride"] = 262.5, ["Neon"] = 406.88, ["Neon|Ride"] = 523.69, ["Mega"] = 4465.65, ["Mega|Ride"] = 2165.63, ["Mega|Fly|Ride"] = 2887.49}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 4.87, ["Fly"] = 45.55, ["Ride"] = 22.91, ["Fly|Ride"] = 57.75, ["Neon"] = 28.88, ["Neon|Ride"] = 57.4, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 184, ["Mega|Ride"] = 212.91, ["Mega|Fly|Ride"] = 322.21}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 73.48, ["Fly"] = 143.06, ["Ride"] = 105, ["Fly|Ride"] = 157.48, ["Neon"] = 216.56, ["Neon|Fly"] = 323.66, ["Neon|Ride"] = 202.73, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1010.63, ["Mega|Ride"] = 1036.88, ["Mega|Fly|Ride"] = 976.5}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 19.69, ["Ride"] = 52.4, ["Fly|Ride"] = 149.04, ["Neon"] = 100.09, ["Neon|Ride"] = 76.11, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 393.74, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 466.26}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 5.91, ["Fly"] = 42.6, ["Ride"] = 25.56, ["Fly|Ride"] = 70.13, ["Neon"] = 118.19, ["Neon|Ride"] = 191.3, ["Neon|Fly|Ride"] = 380.19, ["Mega"] = 314.47, ["Mega|Ride"] = 208.65, ["Mega|Fly|Ride"] = 549.29}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 15.38, ["Ride"] = 45.94, ["Fly|Ride"] = 142.65, ["Neon"] = 26.25, ["Neon|Fly"] = 119.57, ["Neon|Ride"] = 74.42, ["Neon|Fly|Ride"] = 242.82, ["Mega"] = 283.17, ["Mega|Ride"] = 294, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 3.93, ["Ride"] = 30.54, ["Fly|Ride"] = 100.09, ["Neon"] = 32.45, ["Neon|Ride"] = 45.93, ["Neon|Fly|Ride"] = 127.94, ["Mega"] = 276.73, ["Mega|Ride"] = 276.43, ["Mega|Fly|Ride"] = 381.71}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Ride"] = 70.81, ["Neon"] = 2.1, ["Neon|Fly"] = 95.7, ["Neon|Ride"] = 101.15, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 17.82, ["Mega|Ride"] = 142.65, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 2.41, ["Ride"] = 122.01, ["Fly|Ride"] = 91.88, ["Neon"] = 36.75, ["Neon|Ride"] = 189.52, ["Neon|Fly|Ride"] = 202.78, ["Mega"] = 222.16, ["Mega|Ride"] = 504.57, ["Mega|Fly|Ride"] = 522.67}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Fly"] = 126.7, ["Ride"] = 28.53, ["Neon"] = 28.87, ["Neon|Fly"] = 116.94, ["Neon|Ride"] = 71.35, ["Neon|Fly|Ride"] = 185.26, ["Mega"] = 210.67, ["Mega|Ride"] = 283.1, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 3.82, ["Ride"] = 32.8, ["Fly|Ride"] = 119.53, ["Neon"] = 30.89, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 125.63, ["Mega|Ride"] = 284.23, ["Mega|Fly|Ride"] = 519.74}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 525, ["Ride"] = 498.75, ["Fly|Ride"] = 577.5, ["Neon"] = 1809.85, ["Neon|Fly"] = 1811.98, ["Neon|Ride"] = 1850.31, ["Neon|Fly|Ride"] = 1666.88, ["Mega|Fly|Ride"] = 5892.62}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 3.62, ["Fly"] = 45.47, ["Ride"] = 20.42, ["Fly|Ride"] = 56.35, ["Neon"] = 71.35, ["Neon|Ride"] = 57.5, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 196.88, ["Mega|Ride"] = 368.03, ["Mega|Fly|Ride"] = 352.35}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 5.24, ["Fly"] = 66.94, ["Ride"] = 19.68, ["Fly|Ride"] = 51.55, ["Neon"] = 75.31, ["Neon|Fly"] = 315, ["Neon|Ride"] = 73.85, ["Neon|Fly|Ride"] = 166.09, ["Mega"] = 331.86, ["Mega|Ride"] = 478.27, ["Mega|Fly|Ride"] = 442.83}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 2.1, ["Fly"] = 24.93, ["Ride"] = 21.31, ["Fly|Ride"] = 50.78, ["Neon"] = 19.18, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 131.25}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.6, ["Ride"] = 24.39, ["Fly|Ride"] = 89.15, ["Neon"] = 7.23, ["Neon|Ride"] = 30.06, ["Neon|Fly|Ride"] = 100.09, ["Mega"] = 62.35, ["Mega|Fly"] = 284.23, ["Mega|Ride"] = 113.91, ["Mega|Fly|Ride"] = 236.23}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 71.35, ["Ride"] = 17.07, ["Neon"] = 2.5, ["Neon|Ride"] = 24.34, ["Neon|Fly|Ride"] = 113.91, ["Mega"] = 19.69, ["Mega|Fly"] = 199.07, ["Mega|Ride"] = 85.22, ["Mega|Fly|Ride"] = 225.69}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1155}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 7.49, ["Fly"] = 26.25, ["Ride"] = 30.75, ["Fly|Ride"] = 332.17, ["Neon"] = 66.15, ["Neon|Ride"] = 100.09, ["Mega"] = 352.72, ["Mega|Ride"] = 367.06, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 28.55, ["Neon"] = 3.89, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 997.21, ["Mega"] = 37.24, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 182.44}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 3.47, ["Fly"] = 312.35, ["Ride"] = 23.82, ["Neon"] = 20.9, ["Neon|Ride"] = 158.24, ["Neon|Fly|Ride"] = 250.04, ["Mega"] = 249.38, ["Mega|Ride"] = 358.7, ["Mega|Fly|Ride"] = 1064.49}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 416.06, ["Ride"] = 393.75, ["Fly|Ride"] = 525.62, ["Neon|Ride"] = 1464.05, ["Neon|Fly|Ride"] = 1312.49, ["Mega"] = 7983.63, ["Mega|Fly|Ride"] = 6164.82}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 3.88, ["Fly"] = 196.88, ["Ride"] = 42.6, ["Fly|Ride"] = 127.76, ["Neon"] = 42.6, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 191.3, ["Mega"] = 284.23, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Fly"] = 93.28, ["Ride"] = 28.88, ["Fly|Ride"] = 118.1, ["Neon"] = 3.5, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 103.68, ["Mega"] = 32.25, ["Mega|Fly"] = 143.26, ["Mega|Ride"] = 77.95, ["Mega|Fly|Ride"] = 154.49}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Neon"] = 2.16, ["Neon|Ride"] = 143.09, ["Neon|Fly|Ride"] = 198.02, ["Mega"] = 32.82, ["Mega|Ride"] = 170.33, ["Mega|Fly|Ride"] = 209.97}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 13.13, ["Fly"] = 107.89, ["Ride"] = 42.72, ["Fly|Ride"] = 157.58, ["Neon"] = 157.5, ["Neon|Ride"] = 170.36, ["Neon|Fly|Ride"] = 437.07, ["Mega"] = 446.25, ["Mega|Ride"] = 472.5, ["Mega|Fly|Ride"] = 545.74}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 5.52, ["Ride"] = 71.31, ["Neon"] = 75.31, ["Neon|Ride"] = 184.13, ["Neon|Fly|Ride"] = 478.23, ["Mega"] = 478.27, ["Mega|Ride"] = 485.63, ["Mega|Fly|Ride"] = 710.01}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 7.26, ["Ride"] = 32.28, ["Neon"] = 96.94, ["Neon|Ride"] = 189.04, ["Mega"] = 619.55, ["Mega|Fly|Ride"] = 801.94}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 12.87, ["Ride"] = 24.35, ["Fly|Ride"] = 236.25, ["Neon"] = 167.28, ["Neon|Ride"] = 177.5, ["Neon|Fly|Ride"] = 241.5, ["Mega"] = 643.02, ["Mega|Ride"] = 1712.54, ["Mega|Fly|Ride"] = 547.16}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 393.75, ["Ride"] = 422.63, ["Fly|Ride"] = 710.11, ["Neon"] = 1774.5, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 1102.5, ["Mega|Fly|Ride"] = 3346.87}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 3.94, ["Fly"] = 78.75, ["Ride"] = 33.39, ["Fly|Ride"] = 64.4, ["Neon"] = 96.9, ["Neon|Ride"] = 164.05, ["Mega|Fly"] = 590.63, ["Mega|Ride"] = 561.1, ["Mega|Fly|Ride"] = 740.9}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 2.1, ["Ride"] = 42.68, ["Fly|Ride"] = 127.32, ["Neon"] = 38.97, ["Neon|Ride"] = 221.82, ["Mega"] = 105, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 629.99}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 26.99, ["Ride"] = 71.35, ["Fly|Ride"] = 170.63, ["Neon"] = 111.57, ["Neon|Fly"] = 186.33, ["Neon|Ride"] = 175.27, ["Neon|Fly|Ride"] = 261.35, ["Mega"] = 366.89, ["Mega|Ride"] = 362.25, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.1, ["Ride"] = 65.63, ["Fly|Ride"] = 212.94, ["Neon"] = 7.4, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 275.76, ["Mega"] = 39.38, ["Mega|Ride"] = 127.95, ["Mega|Fly|Ride"] = 279.57}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 38.47, ["Ride"] = 79.06, ["Neon"] = 248.07, ["Neon|Ride"] = 284, ["Neon|Fly|Ride"] = 523.8, ["Mega"] = 1614.1, ["Mega|Ride"] = 2073.23, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 76.67, ["Ride"] = 26.25, ["Fly|Ride"] = 262.5, ["Neon"] = 6.57, ["Neon|Fly"] = 185.26, ["Neon|Ride"] = 28.48, ["Neon|Fly|Ride"] = 127.76, ["Mega"] = 60.45, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 182.44}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 28.87, ["Fly|Ride"] = 99.16, ["Neon"] = 4.16, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 48.97, ["Neon|Fly|Ride"] = 103.95, ["Mega"] = 25.89, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 83.57, ["Mega|Fly|Ride"] = 262.4}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Ride"] = 37.95, ["Fly|Ride"] = 181, ["Neon"] = 9.19, ["Neon|Ride"] = 53.55, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 68.58, ["Mega|Ride"] = 84.42, ["Mega|Fly|Ride"] = 314.03}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 47.84, ["Fly"] = 65.61, ["Ride"] = 61.57, ["Fly|Ride"] = 176.9, ["Neon"] = 183.75, ["Neon|Ride"] = 330.29, ["Neon|Fly|Ride"] = 478.23, ["Mega|Ride"] = 1135.82, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 170.63, ["Ride"] = 253.38, ["Fly|Ride"] = 320.25, ["Neon"] = 1703.4, ["Neon|Ride"] = 1422.7, ["Neon|Fly|Ride"] = 1509.38, ["Mega"] = 12773.79, ["Mega|Fly|Ride"] = 4542.16}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 3.09, ["Neon"] = 21.61, ["Neon|Fly"] = 350.44, ["Mega"] = 114.19, ["Mega|Ride"] = 200.24, ["Mega|Fly|Ride"] = 506.96}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.1, ["Ride"] = 20.22, ["Fly|Ride"] = 160.16, ["Neon"] = 8.32, ["Neon|Ride"] = 44.01, ["Neon|Fly|Ride"] = 170.36, ["Mega"] = 36.45, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 91.76, ["Mega|Fly|Ride"] = 196.76}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 4.27, ["Ride"] = 28.76, ["Fly|Ride"] = 97.13, ["Neon"] = 32.81, ["Mega"] = 227.81, ["Mega|Ride"] = 348.04, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 3.68, ["Fly"] = 95.82, ["Ride"] = 34.19, ["Fly|Ride"] = 319.1, ["Neon"] = 19.69, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 139.02, ["Mega"] = 124.69, ["Mega|Fly"] = 118.12, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 337.05}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 93.69, ["Neon"] = 9.02, ["Neon|Ride"] = 142.68, ["Neon|Fly|Ride"] = 142.68, ["Mega"] = 34.93, ["Mega|Ride"] = 90.02, ["Mega|Fly|Ride"] = 398.13}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 40.58, ["Ride"] = 19.04, ["Fly|Ride"] = 52.5, ["Neon"] = 3.9, ["Neon|Fly"] = 80.12, ["Neon|Ride"] = 28.24, ["Neon|Fly|Ride"] = 106.47, ["Mega"] = 39.37, ["Mega|Ride"] = 99.68, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 17.53, ["Fly|Ride"] = 56.44, ["Neon"] = 15.17, ["Neon|Fly"] = 101.15, ["Neon|Ride"] = 39.69, ["Neon|Fly|Ride"] = 106.47, ["Mega"] = 156.15, ["Mega|Ride"] = 141.74, ["Mega|Fly|Ride"] = 728.44}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 23.55, ["Ride"] = 36.15, ["Fly|Ride"] = 78.75, ["Neon"] = 105, ["Neon|Ride"] = 213.6, ["Neon|Fly|Ride"] = 183.44, ["Mega"] = 393.75, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 565.56}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 56.49, ["Ride"] = 89.65, ["Fly|Ride"] = 139.13, ["Neon"] = 423.69, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 345.92, ["Neon|Fly|Ride"] = 464.63, ["Mega"] = 1988.47, ["Mega|Ride"] = 3254.99, ["Mega|Fly|Ride"] = 1515.94}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 19.19, ["Fly|Ride"] = 144.38, ["Neon"] = 3.93, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 28.76, ["Neon|Fly|Ride"] = 142.68, ["Mega"] = 32.92, ["Mega|Fly"] = 672, ["Mega|Ride"] = 92.42, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 14.34, ["Ride"] = 15.74, ["Fly|Ride"] = 42.72, ["Neon"] = 3.63, ["Neon|Fly"] = 28.76, ["Neon|Ride"] = 20.89, ["Neon|Fly|Ride"] = 61.68, ["Mega"] = 40.32, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 68.14, ["Mega|Fly|Ride"] = 126.69}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 2.65, ["Fly"] = 42.6, ["Ride"] = 28.76, ["Fly|Ride"] = 51.98, ["Neon"] = 47.84, ["Neon|Ride"] = 143.49, ["Mega"] = 539.7, ["Mega|Ride"] = 275.62, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 393.74, ["Ride"] = 485.63, ["Fly|Ride"] = 446.25, ["Neon"] = 4258.45, ["Neon|Fly|Ride"] = 1771.88, ["Mega|Fly|Ride"] = 5906.25}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 20.78, ["Fly"] = 100.09, ["Ride"] = 40.47, ["Fly|Ride"] = 88.46, ["Neon"] = 196.86, ["Neon|Ride"] = 191.63, ["Neon|Fly|Ride"] = 214.72, ["Mega"] = 1050, ["Mega|Ride"] = 882.42, ["Mega|Fly|Ride"] = 922.92}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 17.94, ["Fly|Ride"] = 283.6, ["Neon"] = 9.14, ["Neon|Ride"] = 49.21, ["Neon|Fly|Ride"] = 143.07, ["Mega"] = 99.43, ["Mega|Ride"] = 293.79, ["Mega|Fly|Ride"] = 238}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 83.85, ["Ride"] = 57.5, ["Fly|Ride"] = 65.63, ["Neon"] = 50.7, ["Neon|Ride"] = 72.34, ["Mega"] = 169.26, ["Mega|Fly|Ride"] = 318.29}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 28.86, ["Fly"] = 42.6, ["Ride"] = 38.07, ["Fly|Ride"] = 123.52, ["Neon"] = 194.25, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 318.33, ["Mega"] = 2554.77, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1002.75}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 104.99, ["Fly"] = 119.34, ["Ride"] = 115.75, ["Fly|Ride"] = 212.94, ["Neon"] = 352.7, ["Neon|Fly"] = 710.11, ["Neon|Ride"] = 478.23, ["Neon|Fly|Ride"] = 610.32, ["Mega"] = 8515.87, ["Mega|Fly|Ride"] = 2572.5}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 236.69, ["Ride"] = 262.5, ["Fly|Ride"] = 531.25, ["Neon"] = 710.11, ["Neon|Ride"] = 709.54, ["Neon|Fly|Ride"] = 787.5, ["Mega|Fly|Ride"] = 3801.28}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 10.49, ["Ride"] = 53.25, ["Fly|Ride"] = 150.94, ["Neon"] = 59.99, ["Neon|Fly"] = 119.57, ["Neon|Ride"] = 97.71, ["Neon|Fly|Ride"] = 199.11, ["Mega"] = 389.81, ["Mega|Ride"] = 420.29, ["Mega|Fly|Ride"] = 455.61}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 25.56, ["Ride"] = 16.96, ["Fly|Ride"] = 43.32, ["Neon"] = 7.7, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 92.64, ["Mega"] = 93.09, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 187.85}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 15.54, ["Fly|Ride"] = 46.69, ["Neon"] = 30.96, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 97.28, ["Mega"] = 282.02, ["Mega|Ride"] = 243.29, ["Mega|Fly|Ride"] = 341.24}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 341.04, ["Ride"] = 459.38, ["Fly|Ride"] = 744.18, ["Neon"] = 1569.1, ["Neon|Fly|Ride"] = 1912.05, ["Mega"] = 10219.04, ["Mega|Fly|Ride"] = 5118.75}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 33.03, ["Neon"] = 6.71, ["Neon|Ride"] = 139.41, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 28.88, ["Mega|Ride"] = 168.2, ["Mega|Fly|Ride"] = 452.45}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 4.93, ["Ride"] = 17.03, ["Fly|Ride"] = 39.35, ["Neon"] = 22.32, ["Neon|Ride"] = 38.01, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 204.39, ["Mega|Ride"] = 212.91, ["Mega|Fly|Ride"] = 228.38}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 15.08, ["Ride"] = 71.72, ["Neon"] = 89.25, ["Neon|Fly"] = 425.86, ["Neon|Ride"] = 104.98, ["Neon|Fly|Ride"] = 412.02, ["Mega"] = 539.04, ["Mega|Ride"] = 599.64, ["Mega|Fly|Ride"] = 638.34}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 108.94, ["Fly"] = 142.68, ["Ride"] = 71.6, ["Fly|Ride"] = 139.2, ["Neon|Ride"] = 789.06, ["Neon|Fly|Ride"] = 568.32, ["Mega|Fly|Ride"] = 2379.57}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 17.07, ["Fly"] = 24.46, ["Ride"] = 26.42, ["Fly|Ride"] = 53.82, ["Neon"] = 71.35, ["Neon|Ride"] = 91.11, ["Neon|Fly|Ride"] = 142.68, ["Mega"] = 875.44, ["Mega|Ride"] = 507.65, ["Mega|Fly|Ride"] = 576.18}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 21.31, ["Neon"] = 2.48, ["Neon|Ride"] = 142.68, ["Mega"] = 30.19, ["Mega|Ride"] = 127.95, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 16.04, ["Fly|Ride"] = 85.19, ["Neon"] = 2.1, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 25.98, ["Neon|Fly|Ride"] = 84.33, ["Mega"] = 21.17, ["Mega|Fly"] = 97.12, ["Mega|Ride"] = 42.72, ["Mega|Fly|Ride"] = 111.57}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 12.32, ["Ride"] = 57.5, ["Fly|Ride"] = 170.36, ["Neon"] = 30.21, ["Neon|Ride"] = 95.33, ["Neon|Fly|Ride"] = 209.48, ["Mega"] = 160.27, ["Mega|Ride"] = 218.91, ["Mega|Fly|Ride"] = 312.95}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1273.13, ["Ride"] = 1186.83, ["Fly|Ride"] = 1435.88, ["Neon"] = 4376.12, ["Neon|Ride"] = 4684.29, ["Neon|Fly|Ride"] = 4405.36, ["Mega|Fly|Ride"] = 12600}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 413.44, ["Ride"] = 446.25, ["Fly|Ride"] = 577.73, ["Neon"] = 1663.2, ["Neon|Ride"] = 1680, ["Neon|Fly|Ride"] = 1703.4, ["Mega"] = 17031.71, ["Mega|Fly|Ride"] = 7423.7}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 262.5, ["Fly"] = 405.46, ["Ride"] = 328.11, ["Fly|Ride"] = 413.44, ["Neon"] = 746.46, ["Neon|Fly"] = 1116.65, ["Neon|Ride"] = 708.44, ["Neon|Fly|Ride"] = 786.19, ["Mega|Fly|Ride"] = 2916.23}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 148, ["Fly"] = 424.79, ["Ride"] = 279.56, ["Fly|Ride"] = 354.38, ["Neon"] = 708.75, ["Neon|Ride"] = 654.94, ["Neon|Fly|Ride"] = 649.69, ["Mega|Fly|Ride"] = 3080.62}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 15.79, ["Ride"] = 15.63, ["Fly|Ride"] = 39.38, ["Neon"] = 3.93, ["Neon|Ride"] = 28.77, ["Neon|Fly|Ride"] = 102.21, ["Mega"] = 63.94, ["Mega|Fly"] = 113.91, ["Mega|Ride"] = 72.19, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 233.6, ["Fly"] = 1420.2, ["Ride"] = 299.25, ["Fly|Ride"] = 567.69, ["Neon"] = 1277.54, ["Neon|Ride"] = 1365, ["Neon|Fly|Ride"] = 1050, ["Mega"] = 21573.86, ["Mega|Ride"] = 5109.53, ["Mega|Fly|Ride"] = 4593.75}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 3.42, ["Fly"] = 157.5, ["Ride"] = 70.27, ["Fly|Ride"] = 91.87, ["Neon"] = 27.09, ["Neon|Ride"] = 115.69, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 175.87, ["Mega|Ride"] = 288.25, ["Mega|Fly|Ride"] = 414.15}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 18.12, ["Ride"] = 16.53, ["Fly|Ride"] = 38.98, ["Neon"] = 8.75, ["Neon|Ride"] = 44.72, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 104.81, ["Mega|Ride"] = 192.31, ["Mega|Fly|Ride"] = 105.24}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 56.6, ["Neon"] = 2.63, ["Neon|Ride"] = 45.94, ["Mega"] = 33.86, ["Mega|Ride"] = 196.77, ["Mega|Fly|Ride"] = 177.62}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 29.36, ["Ride"] = 57.7, ["Fly|Ride"] = 459.38, ["Neon"] = 199.5, ["Neon|Ride"] = 355.6, ["Mega"] = 1050, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 773.07}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 8038.15, ["Ride"] = 26.31, ["Fly|Ride"] = 68.25, ["Neon"] = 6.36, ["Neon|Ride"] = 61.13, ["Mega"] = 353.42, ["Mega|Ride"] = 297.51, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 22.73, ["Neon"] = 2.1, ["Neon|Ride"] = 55.11, ["Neon|Fly|Ride"] = 143.32, ["Mega"] = 21.96, ["Mega|Ride"] = 70.27, ["Mega|Fly|Ride"] = 168.2}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.1, ["Fly"] = 57.5, ["Ride"] = 31.4, ["Fly|Ride"] = 59.07, ["Neon"] = 21, ["Neon|Fly"] = 113.93, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 162.09, ["Mega"] = 140.44, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 2.1, ["Fly"] = 71.35, ["Ride"] = 24.62, ["Fly|Ride"] = 50.3, ["Neon"] = 36.21, ["Neon|Fly"] = 143.49, ["Neon|Ride"] = 142.68, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 238.83, ["Mega|Ride"] = 251.07, ["Mega|Fly|Ride"] = 1321.69}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 10.5, ["Ride"] = 38.07, ["Neon"] = 92.9, ["Neon|Ride"] = 185.26, ["Neon|Fly|Ride"] = 314.47, ["Mega"] = 425.81, ["Mega|Ride"] = 797.31}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 4.19, ["Fly"] = 6374.7, ["Ride"] = 17.07, ["Neon"] = 50.42, ["Neon|Fly"] = 49.88, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 284.27, ["Mega"] = 328.13, ["Mega|Ride"] = 355.56, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 65.01, ["Ride"] = 18.36, ["Fly|Ride"] = 45.83, ["Neon"] = 3.93, ["Neon|Fly"] = 31.95, ["Neon|Ride"] = 27.45, ["Neon|Fly|Ride"] = 104.35, ["Mega"] = 45.94, ["Mega|Fly|Ride"] = 239.14}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 111.55, ["Fly"] = 227.84, ["Ride"] = 164.03, ["Fly|Ride"] = 241.68, ["Neon"] = 958.16, ["Neon|Ride"] = 897.86, ["Neon|Fly|Ride"] = 839.88, ["Mega"] = 8515.87, ["Mega|Fly|Ride"] = 3975.85}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 19.17, ["Ride"] = 15.64, ["Fly|Ride"] = 29.89, ["Neon"] = 3.82, ["Neon|Fly"] = 35.88, ["Neon|Ride"] = 23.61, ["Neon|Fly|Ride"] = 47.25, ["Mega"] = 37.3, ["Mega|Ride"] = 57.74, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 5.92, ["Ride"] = 40.25, ["Fly|Ride"] = 196.88, ["Neon"] = 54.98, ["Neon|Ride"] = 113.91, ["Neon|Fly|Ride"] = 765.15, ["Mega"] = 313.69, ["Mega|Ride"] = 293.05, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 26.25, ["Ride"] = 309.67, ["Fly|Ride"] = 170.63, ["Neon"] = 157.5, ["Neon|Ride"] = 199.11, ["Neon|Fly|Ride"] = 160.22, ["Mega"] = 786.19, ["Mega|Ride"] = 764.1, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 194.24, ["Fly"] = 303.57, ["Ride"] = 253.34, ["Fly|Ride"] = 293.85, ["Neon"] = 812.4, ["Neon|Fly"] = 797.43, ["Neon|Ride"] = 702.18, ["Neon|Fly|Ride"] = 756, ["Mega|Fly|Ride"] = 3508.55}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 19.57, ["Ride"] = 159.91, ["Fly|Ride"] = 143.42, ["Neon"] = 78.75, ["Neon|Ride"] = 212.94, ["Neon|Fly|Ride"] = 425.86, ["Mega"] = 239.14, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 340.65}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 5.12, ["Fly"] = 95.67, ["Ride"] = 57.75, ["Fly|Ride"] = 641.22, ["Neon"] = 62.99, ["Neon|Fly"] = 160.22, ["Neon|Ride"] = 209.24, ["Neon|Fly|Ride"] = 186.08, ["Mega"] = 1135.82, ["Mega|Ride"] = 851.6, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 908.15, ["Fly"] = 1195.13, ["Ride"] = 948.94, ["Fly|Ride"] = 1035.57, ["Neon|Ride"] = 4790.63, ["Neon|Fly|Ride"] = 4854.63, ["Mega|Ride"] = 14193.81, ["Mega|Fly|Ride"] = 15613.83}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 4.68, ["Fly"] = 23.48, ["Ride"] = 20.9, ["Fly|Ride"] = 61.77, ["Neon"] = 44.63, ["Neon|Fly"] = 67.69, ["Neon|Ride"] = 49.13, ["Neon|Fly|Ride"] = 212.91, ["Mega"] = 219.19, ["Mega|Ride"] = 202.27, ["Mega|Fly|Ride"] = 346.49}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 3.41, ["Fly"] = 78.75, ["Ride"] = 49.87, ["Fly|Ride"] = 135.19, ["Neon"] = 31.49, ["Neon|Ride"] = 92.63, ["Neon|Fly|Ride"] = 190.32, ["Mega"] = 528, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Fly"] = 85.19, ["Ride"] = 24, ["Fly|Ride"] = 55.13, ["Neon"] = 10.83, ["Neon|Ride"] = 46.48, ["Neon|Fly|Ride"] = 85.37, ["Mega"] = 61.77, ["Mega|Ride"] = 360.34, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 11.72, ["Ride"] = 39.29, ["Fly|Ride"] = 94.5, ["Neon"] = 62.36, ["Neon|Fly"] = 143.83, ["Neon|Ride"] = 96.34, ["Neon|Fly|Ride"] = 142.65, ["Mega"] = 437.07, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 2.52, ["Fly"] = 20.6, ["Ride"] = 19.85, ["Fly|Ride"] = 51.91, ["Neon"] = 19.48, ["Neon|Fly"] = 42.74, ["Neon|Ride"] = 30.18, ["Neon|Fly|Ride"] = 114.08, ["Mega"] = 105, ["Mega|Fly"] = 280.98, ["Mega|Ride"] = 126.69, ["Mega|Fly|Ride"] = 192.7}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 4.27, ["Ride"] = 21, ["Fly|Ride"] = 65.63, ["Neon"] = 10.16, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 70.27, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 124.48, ["Mega|Ride"] = 185.24}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 129.94, ["Fly"] = 237.43, ["Ride"] = 170.36, ["Fly|Ride"] = 425.86, ["Neon"] = 921.97, ["Neon|Fly|Ride"] = 710.11}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Fly"] = 32.81, ["Ride"] = 19.69, ["Fly|Ride"] = 109.15, ["Neon"] = 5.09, ["Neon|Ride"] = 48.05, ["Neon|Fly|Ride"] = 91.87, ["Mega"] = 61.68, ["Mega|Ride"] = 127.37, ["Mega|Fly|Ride"] = 266.13}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 3.92, ["Ride"] = 28.76, ["Fly|Ride"] = 88.86, ["Neon"] = 27.69, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 188.26, ["Mega"] = 175.88, ["Mega|Ride"] = 319.25, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 3.6, ["Fly"] = 94.73, ["Ride"] = 19.69, ["Neon"] = 14.3, ["Neon|Ride"] = 19.69, ["Mega"] = 94.38, ["Mega|Ride"] = 120.53, ["Mega|Fly|Ride"] = 459.27}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 69.17, ["Ride"] = 112.76, ["Fly|Ride"] = 314.08, ["Neon"] = 425.48, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 753.2, ["Mega"] = 2554.77, ["Mega|Ride"] = 4257.94, ["Mega|Fly|Ride"] = 1277.07}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 20.56, ["Fly"] = 90.77, ["Ride"] = 42.53, ["Fly|Ride"] = 264.04, ["Neon"] = 179.31, ["Neon|Ride"] = 164.75, ["Neon|Fly|Ride"] = 341.93, ["Mega"] = 642.97, ["Mega|Ride"] = 617.42, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 15.54, ["Fly"] = 57.75, ["Ride"] = 39.35, ["Fly|Ride"] = 97.13, ["Neon"] = 81.38, ["Neon|Ride"] = 100.09, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 441.77, ["Mega|Ride"] = 413.96, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 6.39, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 236.15, ["Mega"] = 110.38, ["Mega|Ride"] = 163.13, ["Mega|Fly|Ride"] = 539.7}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 38.97, ["Fly"] = 78.73, ["Ride"] = 61.46, ["Fly|Ride"] = 99.74, ["Neon"] = 262.49, ["Neon|Fly"] = 245.44, ["Neon|Ride"] = 196.86, ["Neon|Fly|Ride"] = 309.25, ["Mega|Fly|Ride"] = 1011.71}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 19.67, ["Fly|Ride"] = 52.49, ["Neon"] = 4.6, ["Neon|Ride"] = 57.69, ["Neon|Fly|Ride"] = 126.7, ["Mega"] = 60.77, ["Mega|Ride"] = 283.17, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 17.75, ["Fly"] = 112.35, ["Ride"] = 31.82, ["Fly|Ride"] = 86.07, ["Neon"] = 71.55, ["Neon|Ride"] = 64.58, ["Neon|Fly|Ride"] = 210, ["Mega"] = 357.09, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 355.56, ["Mega|Fly|Ride"] = 427.88}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 44.15, ["Fly"] = 203.41, ["Ride"] = 76.13, ["Fly|Ride"] = 131.25, ["Neon"] = 249.27, ["Neon|Fly"] = 425.86, ["Neon|Ride"] = 288.74, ["Neon|Fly|Ride"] = 420.53, ["Mega|Ride"] = 1382.78, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 15.65, ["Ride"] = 13.79, ["Fly|Ride"] = 28.85, ["Neon"] = 2.1, ["Neon|Fly"] = 24.52, ["Neon|Ride"] = 15.81, ["Neon|Fly|Ride"] = 41.97, ["Mega"] = 16.58, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 38.39, ["Mega|Fly|Ride"] = 92.49}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 2.1, ["Ride"] = 22.09, ["Fly|Ride"] = 131.25, ["Neon"] = 21.3, ["Neon|Ride"] = 65.61, ["Neon|Fly|Ride"] = 168, ["Mega"] = 170.63, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 392.43}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 10.4, ["Fly"] = 142.68, ["Ride"] = 46.32, ["Fly|Ride"] = 57.5, ["Neon"] = 110.14, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 212.94, ["Mega"] = 563.34, ["Mega|Ride"] = 446.25, ["Mega|Fly|Ride"] = 651}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 22, ["Neon"] = 2.24, ["Neon|Ride"] = 28.87, ["Neon|Fly|Ride"] = 95.81, ["Mega"] = 20.75, ["Mega|Ride"] = 53.05, ["Mega|Fly|Ride"] = 210.78}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 23, ["Fly"] = 205.83, ["Ride"] = 77.95, ["Fly|Ride"] = 177.92, ["Neon"] = 98.34, ["Neon|Ride"] = 173.36, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 708.95, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 561.73, ["Mega|Fly|Ride"] = 688.73}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 10.07, ["Fly"] = 42.6, ["Ride"] = 26.25, ["Fly|Ride"] = 80.93, ["Neon"] = 376.69, ["Neon|Ride"] = 118.18, ["Neon|Fly|Ride"] = 163.94, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 473.71}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Neon"] = 46.65, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 59.87, ["Neon|Fly|Ride"] = 710.11, ["Mega"] = 232.98, ["Mega|Ride"] = 269.07, ["Mega|Fly|Ride"] = 474.77}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 6.07, ["Fly"] = 72.19, ["Ride"] = 56.44, ["Fly|Ride"] = 229.69, ["Neon"] = 32.82, ["Neon|Ride"] = 65.54, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 213.7, ["Mega|Ride"] = 442.32, ["Mega|Fly|Ride"] = 385.35}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Fly"] = 42.6, ["Ride"] = 19.59, ["Fly|Ride"] = 196.88, ["Neon"] = 4.55, ["Neon|Ride"] = 34.81, ["Mega"] = 53.81, ["Mega|Fly"] = 212.91, ["Mega|Ride"] = 106.32, ["Mega|Fly|Ride"] = 281.05}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 57.38, ["Neon"] = 3.69, ["Mega"] = 31.4, ["Mega|Ride"] = 94.5, ["Mega|Fly|Ride"] = 194.25}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 15.32}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 37.31, ["Fly"] = 100.09, ["Ride"] = 59.28, ["Fly|Ride"] = 79.96, ["Neon"] = 184.57, ["Neon|Ride"] = 212.94, ["Neon|Fly|Ride"] = 315, ["Mega"] = 1854.57, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 853.58}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 27.57, ["Mega"] = 23.09, ["Mega|Ride"] = 121.56, ["Mega|Fly|Ride"] = 319.36}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 420, ["Fly"] = 568.52, ["Ride"] = 551.25, ["Fly|Ride"] = 597.57, ["Neon"] = 2839.32, ["Neon|Ride"] = 2020.64, ["Neon|Fly|Ride"] = 2111.03, ["Mega"] = 17031.71, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 3.71, ["Fly"] = 48.37, ["Ride"] = 33.72, ["Fly|Ride"] = 68.15, ["Neon"] = 35.89, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 113.93, ["Mega"] = 100.47, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 624.87}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 19.01, ["Fly|Ride"] = 91.86, ["Neon"] = 24.81, ["Neon|Ride"] = 62.83, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 142.65, ["Mega|Fly"] = 284.23, ["Mega|Ride"] = 157.57, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 9.08, ["Ride"] = 42.6, ["Fly|Ride"] = 535.18, ["Neon"] = 63.89, ["Neon|Ride"] = 142.68, ["Neon|Fly|Ride"] = 301.88, ["Mega"] = 674.89, ["Mega|Ride"] = 562.07, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 2.1, ["Fly"] = 57.5, ["Ride"] = 38.57, ["Fly|Ride"] = 710.11, ["Neon"] = 29.54, ["Neon|Fly"] = 50.05, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 392.44, ["Mega"] = 278.25, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 6.11, ["Ride"] = 82.69, ["Fly|Ride"] = 157.49, ["Neon"] = 52.5, ["Neon|Ride"] = 143.49, ["Neon|Fly|Ride"] = 273.02, ["Mega"] = 349.17, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 568.45}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 5.76, ["Fly"] = 105, ["Ride"] = 27.86, ["Fly|Ride"] = 91.88, ["Neon"] = 30.96, ["Neon|Ride"] = 79.19, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 227.81, ["Mega|Ride"] = 317.63, ["Mega|Fly|Ride"] = 349.13}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 41.85, ["Ride"] = 13.8, ["Fly|Ride"] = 87.3, ["Neon"] = 2.1, ["Neon|Fly"] = 41.99, ["Neon|Ride"] = 16, ["Neon|Fly|Ride"] = 76.67, ["Mega"] = 15.21, ["Mega|Fly"] = 65.26, ["Mega|Ride"] = 37.67, ["Mega|Fly|Ride"] = 93.26}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 3.96, ["Fly"] = 54.31, ["Ride"] = 38.43, ["Fly|Ride"] = 106.46, ["Neon"] = 18.8, ["Neon|Fly"] = 119.57, ["Neon|Ride"] = 46.48, ["Neon|Fly|Ride"] = 194.88, ["Mega"] = 196.87, ["Mega|Ride"] = 213.84, ["Mega|Fly|Ride"] = 322.55}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 283.5, ["Ride"] = 325.67, ["Fly|Ride"] = 363.57, ["Neon"] = 1312.5, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1253.44, ["Mega|Ride"] = 9278.03, ["Mega|Fly|Ride"] = 4782.49}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 78.73, ["Ride"] = 112.88, ["Fly|Ride"] = 254.45, ["Neon"] = 458.07, ["Neon|Fly"] = 911.32, ["Neon|Ride"] = 420, ["Neon|Fly|Ride"] = 594.99, ["Mega"] = 2271.62, ["Mega|Ride"] = 1489.22, ["Mega|Fly|Ride"] = 1753.99}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 16.1, ["Fly|Ride"] = 35.43, ["Neon"] = 5.71, ["Neon|Fly"] = 55.01, ["Neon|Ride"] = 34.09, ["Neon|Fly|Ride"] = 63.89, ["Mega"] = 88.36, ["Mega|Fly"] = 112.41, ["Mega|Ride"] = 78.91, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 14.43, ["Fly|Ride"] = 34.84, ["Neon"] = 6.53, ["Neon|Fly"] = 40.67, ["Neon|Ride"] = 25.96, ["Neon|Fly|Ride"] = 57.7, ["Mega"] = 67.49, ["Mega|Fly"] = 284.23, ["Mega|Ride"] = 76.32, ["Mega|Fly|Ride"] = 168.7}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.1, ["Fly"] = 100.09, ["Ride"] = 22.32, ["Fly|Ride"] = 98.44, ["Neon"] = 100.29, ["Neon|Fly|Ride"] = 157.5, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 181.13, ["Ride"] = 212.94, ["Fly|Ride"] = 288.75, ["Neon"] = 1171.08, ["Neon|Ride"] = 1050, ["Neon|Fly|Ride"] = 1577.77, ["Mega|Ride"] = 8515.87, ["Mega|Fly|Ride"] = 3806.25}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.1, ["Fly"] = 16.65, ["Ride"] = 14.75, ["Fly|Ride"] = 42.69, ["Neon"] = 14.42, ["Neon|Fly"] = 104.97, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 85.17, ["Mega"] = 255.93, ["Mega|Ride"] = 221.82, ["Mega|Fly|Ride"] = 274.65}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 2.1, ["Ride"] = 75.54, ["Fly|Ride"] = 212.94, ["Neon"] = 20.9, ["Neon|Ride"] = 42.6, ["Neon|Fly|Ride"] = 284.27, ["Mega"] = 196.88, ["Mega|Ride"] = 300.43, ["Mega|Fly|Ride"] = 323.92}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 90.3, ["Neon"] = 3.59, ["Neon|Ride"] = 156.19, ["Mega"] = 90.45, ["Mega|Fly"] = 195.88, ["Mega|Ride"] = 334.79, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 10.5, ["Fly"] = 28.54, ["Ride"] = 21.4, ["Fly|Ride"] = 74.89, ["Neon"] = 149.49, ["Neon|Ride"] = 121.37, ["Neon|Fly|Ride"] = 157.58, ["Mega"] = 448.88, ["Mega|Ride"] = 425.81, ["Mega|Fly|Ride"] = 587.89}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 37.57, ["Fly"] = 102.21, ["Ride"] = 78.71, ["Fly|Ride"] = 163.96, ["Neon"] = 125.9, ["Neon|Fly"] = 156.09, ["Neon|Ride"] = 169.3, ["Neon|Fly|Ride"] = 285.33, ["Mega"] = 496.5, ["Mega|Fly"] = 2235.43, ["Mega|Ride"] = 433.13, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 26.22, ["Fly"] = 63.89, ["Ride"] = 36.28, ["Fly|Ride"] = 78.66, ["Neon"] = 157.58, ["Neon|Fly"] = 286.43, ["Neon|Ride"] = 128.4, ["Neon|Fly|Ride"] = 223.12, ["Mega"] = 851.6, ["Mega|Ride"] = 700.88, ["Mega|Fly|Ride"] = 820.32}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 20.24, ["Ride"] = 14.93, ["Fly|Ride"] = 51.45, ["Neon"] = 2.1, ["Neon|Fly"] = 31.4, ["Neon|Ride"] = 16.7, ["Neon|Fly|Ride"] = 48.2, ["Mega"] = 19.25, ["Mega|Fly"] = 425.81, ["Mega|Ride"] = 35.87, ["Mega|Fly|Ride"] = 94.23}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 200.86, ["Ride"] = 240.53, ["Fly|Ride"] = 272.98, ["Neon"] = 2990.74, ["Neon|Ride"] = 1044.4, ["Neon|Fly|Ride"] = 1044.71, ["Mega|Fly|Ride"] = 3975.85}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 9.69, ["Fly"] = 65.63, ["Ride"] = 24.88, ["Fly|Ride"] = 92.94, ["Neon"] = 107.58, ["Neon|Ride"] = 161.44, ["Neon|Fly|Ride"] = 425.86, ["Mega"] = 430.5, ["Mega|Ride"] = 530.15, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 35.97, ["Ride"] = 18.75, ["Fly|Ride"] = 43.35, ["Neon"] = 3.61, ["Neon|Fly"] = 41.51, ["Neon|Ride"] = 28.76, ["Neon|Fly|Ride"] = 106.47, ["Mega"] = 60.72, ["Mega|Fly"] = 221.43, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 212.91}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 16.14, ["Fly|Ride"] = 76.9, ["Neon"] = 2.1, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 25.56, ["Neon|Fly|Ride"] = 127.94, ["Mega"] = 18.69, ["Mega|Fly"] = 142.65, ["Mega|Ride"] = 45.55, ["Mega|Fly|Ride"] = 111.57}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Ride"] = 19.68, ["Fly|Ride"] = 42.6, ["Neon"] = 3.93, ["Neon|Fly"] = 717.33, ["Neon|Ride"] = 49.88, ["Mega"] = 105, ["Mega|Ride"] = 136.5, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 13.94, ["Fly"] = 28.88, ["Ride"] = 24.93, ["Fly|Ride"] = 70.86, ["Neon"] = 54.78, ["Neon|Fly"] = 270.43, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 355.69, ["Mega|Ride"] = 370.12, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 5.25, ["Ride"] = 42.6, ["Neon"] = 65.63, ["Neon|Ride"] = 149.06, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 235.27, ["Mega|Ride"] = 318.29, ["Mega|Fly|Ride"] = 381.76}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 45.8, ["Neon"] = 2.1, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 100.36, ["Mega"] = 22.54, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 120.56}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 5.25, ["Ride"] = 28.17, ["Fly|Ride"] = 131.25, ["Neon"] = 34.07, ["Neon|Fly"] = 96.5, ["Neon|Ride"] = 45.26, ["Neon|Fly|Ride"] = 284.27, ["Mega"] = 147.98, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 257.28}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Fly"] = 71.35, ["Ride"] = 85.19, ["Neon"] = 3.62, ["Neon|Fly"] = 113.93, ["Neon|Ride"] = 45.45, ["Neon|Fly|Ride"] = 102.37, ["Mega"] = 26.23, ["Mega|Ride"] = 75.33, ["Mega|Fly|Ride"] = 321.26}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 45.93, ["Ride"] = 20.1, ["Fly|Ride"] = 40.65, ["Neon"] = 5.8, ["Neon|Ride"] = 23.29, ["Neon|Fly|Ride"] = 126.88, ["Mega"] = 58.89, ["Mega|Fly"] = 142.65, ["Mega|Ride"] = 80.13, ["Mega|Fly|Ride"] = 210.19}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 656.25, ["Ride"] = 721.88, ["Fly|Ride"] = 761.25, ["Neon|Fly|Ride"] = 3675, ["Mega|Fly|Ride"] = 12753.69}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 15.65, ["Ride"] = 15.65, ["Fly|Ride"] = 34.13, ["Neon"] = 11.82, ["Neon|Fly"] = 42.6, ["Neon|Ride"] = 27, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 190.55, ["Mega|Fly|Ride"] = 372.59}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.1, ["Ride"] = 43.63, ["Neon"] = 12.39, ["Neon|Fly"] = 142.68, ["Neon|Ride"] = 71.34, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 59.07, ["Mega|Fly"] = 189.49, ["Mega|Ride"] = 115.5, ["Mega|Fly|Ride"] = 257.24}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 6.36, ["Fly"] = 42.6, ["Ride"] = 22.32, ["Fly|Ride"] = 61.85, ["Neon"] = 41.42, ["Neon|Fly"] = 191.3, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 485.63, ["Mega|Ride"] = 273.32, ["Mega|Fly|Ride"] = 347.82}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 24.52, ["Ride"] = 15.6, ["Fly|Ride"] = 36.21, ["Neon"] = 5.24, ["Neon|Fly"] = 149.06, ["Neon|Ride"] = 23.93, ["Neon|Fly|Ride"] = 39.37, ["Mega"] = 59.05, ["Mega|Ride"] = 95.81, ["Mega|Fly|Ride"] = 173.25}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 35.83, ["Ride"] = 57.5, ["Fly|Ride"] = 314.08, ["Neon"] = 185.26, ["Neon|Ride"] = 284.27, ["Neon|Fly|Ride"] = 424.79, ["Mega"] = 667.45, ["Mega|Ride"] = 671.71, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Fly"] = 32.7, ["Ride"] = 19.15, ["Fly|Ride"] = 76.13, ["Neon"] = 5.25, ["Neon|Fly"] = 136.31, ["Neon|Ride"] = 29.79, ["Neon|Fly|Ride"] = 119.43, ["Mega"] = 44.63, ["Mega|Ride"] = 132.9, ["Mega|Fly|Ride"] = 229.68}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 24.42, ["Fly|Ride"] = 59.85, ["Neon"] = 11.57, ["Neon|Ride"] = 42.72, ["Neon|Fly|Ride"] = 160.22, ["Mega"] = 69.83, ["Mega|Ride"] = 198.59, ["Mega|Fly|Ride"] = 352.35}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly|Ride"] = 65.83, ["Neon"] = 21.31, ["Mega"] = 97.12, ["Mega|Ride"] = 159.69, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 42, ["Ride"] = 14.76, ["Fly|Ride"] = 57.5, ["Neon"] = 3.61, ["Neon|Fly"] = 71.35, ["Neon|Ride"] = 20.34, ["Neon|Fly|Ride"] = 114.18, ["Mega"] = 36.12, ["Mega|Fly"] = 227.38, ["Mega|Ride"] = 81.51, ["Mega|Fly|Ride"] = 212.91}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 11.21, ["Fly"] = 22.17, ["Ride"] = 17.07, ["Fly|Ride"] = 34.48, ["Neon"] = 109.68, ["Neon|Ride"] = 80.85, ["Neon|Fly|Ride"] = 143.07, ["Mega|Ride"] = 398.13, ["Mega|Fly|Ride"] = 351.25}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 665.22, ["Ride"] = 721.88, ["Fly|Ride"] = 855.75, ["Neon"] = 1935.93, ["Neon|Ride"] = 1893.62, ["Neon|Fly|Ride"] = 2010.03, ["Mega"] = 4654.5, ["Mega|Ride"] = 5947.28, ["Mega|Fly|Ride"] = 5875.96}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 21.31, ["Ride"] = 14.27, ["Fly|Ride"] = 37.67, ["Neon"] = 6.4, ["Neon|Fly"] = 37.8, ["Neon|Ride"] = 19.16, ["Neon|Fly|Ride"] = 42.75, ["Mega"] = 46.65, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 143.07}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 4.88, ["Ride"] = 32.81, ["Fly|Ride"] = 239.04, ["Neon"] = 49.44, ["Neon|Ride"] = 118.46, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 376.85, ["Mega|Ride"] = 392.44, ["Mega|Fly|Ride"] = 393.74}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 47.53, ["Fly"] = 105, ["Ride"] = 74.81, ["Fly|Ride"] = 96.17, ["Neon"] = 284.27, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 424.79, ["Mega"] = 2439.83, ["Mega|Fly|Ride"] = 2611.88}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 28.55, ["Fly"] = 146.86, ["Ride"] = 49.88, ["Fly|Ride"] = 105, ["Neon"] = 212.94, ["Neon|Ride"] = 240.19, ["Neon|Fly|Ride"] = 425.86, ["Mega"] = 1275.74, ["Mega|Ride"] = 910.16, ["Mega|Fly|Ride"] = 1116.73}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 8.23, ["Fly"] = 88.46, ["Ride"] = 26.49, ["Fly|Ride"] = 142.68, ["Neon"] = 55.13, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 273, ["Mega"] = 302.3, ["Mega|Ride"] = 286.96, ["Mega|Fly|Ride"] = 460.69}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 34.13, ["Ride"] = 57.5, ["Fly|Ride"] = 47.81, ["Neon"] = 104.03, ["Neon|Ride"] = 338.52, ["Neon|Fly|Ride"] = 149.22, ["Mega"] = 262.4, ["Mega|Fly"] = 518.93, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 423.26}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 19.24, ["Ride"] = 32.4, ["Neon"] = 120.75, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 525, ["Mega"] = 525, ["Mega|Fly"] = 567, ["Mega|Ride"] = 476.44, ["Mega|Fly|Ride"] = 742.88}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 3.81}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 3.82, ["Ride"] = 24.94, ["Fly|Ride"] = 50.05, ["Neon"] = 28.58, ["Neon|Ride"] = 57.62, ["Neon|Fly|Ride"] = 212.94, ["Mega"] = 210, ["Mega|Fly"] = 453.68, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 306.54}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.52, ["Ride"] = 46.97, ["Neon"] = 10.49, ["Neon|Fly|Ride"] = 212.94, ["Mega"] = 140.73}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 27.55, ["Fly"] = 62.99, ["Ride"] = 28.88, ["Fly|Ride"] = 79.24, ["Neon"] = 203.34, ["Neon|Ride"] = 228.69, ["Neon|Fly|Ride"] = 258.24, ["Mega|Ride"] = 681.19, ["Mega|Fly|Ride"] = 731.29}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 15.54, ["Fly|Ride"] = 39.38, ["Neon"] = 26.16, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 35.52, ["Neon|Fly|Ride"] = 65.62, ["Mega"] = 196.88, ["Mega|Fly"] = 424.75, ["Mega|Ride"] = 177.28, ["Mega|Fly|Ride"] = 233.63}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 3.71, ["Fly"] = 151.18, ["Ride"] = 31.95, ["Fly|Ride"] = 56.27, ["Neon"] = 17.28, ["Neon|Ride"] = 47.67, ["Neon|Fly|Ride"] = 128.02, ["Mega"] = 160.33, ["Mega|Fly"] = 197.4, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 262.47}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Ride"] = 71.35, ["Neon"] = 7.8, ["Mega"] = 36.75, ["Mega|Ride"] = 203.43, ["Mega|Fly|Ride"] = 258.57}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 30.17, ["Ride"] = 52.48, ["Fly|Ride"] = 120.75, ["Neon"] = 284.27, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 425.81, ["Mega"] = 524.99, ["Mega|Ride"] = 14193.81, ["Mega|Fly|Ride"] = 915.47}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 21, ["Fly|Ride"] = 65.62, ["Neon"] = 5.19, ["Neon|Fly"] = 203.44, ["Neon|Ride"] = 85.19, ["Neon|Fly|Ride"] = 105, ["Mega"] = 63.34, ["Mega|Ride"] = 139.94}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 7.86, ["Ride"] = 80.09, ["Fly|Ride"] = 283.2, ["Neon"] = 66.94, ["Neon|Ride"] = 141.87, ["Neon|Fly|Ride"] = 142.68, ["Mega"] = 354.38, ["Mega|Ride"] = 478.27, ["Mega|Fly|Ride"] = 596.64}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 45.9, ["Ride"] = 15.63, ["Fly|Ride"] = 42.36, ["Neon"] = 13.13, ["Neon|Ride"] = 30.09, ["Neon|Fly|Ride"] = 97.46, ["Mega"] = 185.24, ["Mega|Ride"] = 208.04, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 2.15, ["Fly"] = 52.49, ["Ride"] = 24.29, ["Fly|Ride"] = 72.22, ["Neon"] = 40.69, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 398.13, ["Mega|Ride"] = 424.75, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 4.73, ["Ride"] = 80.79, ["Neon"] = 90.8, ["Neon|Ride"] = 77.43, ["Mega"] = 413.86, ["Mega|Ride"] = 366.19, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 42, ["Ride"] = 113.93, ["Neon"] = 236.25, ["Neon|Ride"] = 421.32, ["Neon|Fly|Ride"] = 669.38, ["Mega"] = 1114.53, ["Mega|Ride"] = 1383.84, ["Mega|Fly|Ride"] = 1916.09}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 9.59, ["Ride"] = 81.81, ["Neon"] = 107.61, ["Neon|Ride"] = 183.75, ["Mega"] = 349.13, ["Mega|Ride"] = 558.37, ["Mega|Fly|Ride"] = 667.45}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 8.89, ["Ride"] = 126, ["Neon"] = 63.39, ["Neon|Fly"] = 212.94, ["Neon|Ride"] = 170.63, ["Mega"] = 797.49, ["Mega|Ride"] = 430.43, ["Mega|Fly|Ride"] = 568.45}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 19.15, ["Ride"] = 105, ["Fly|Ride"] = 367.48, ["Neon"] = 108.94, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 653.61, ["Mega|Fly"] = 2128.97, ["Mega|Ride"] = 717.39, ["Mega|Fly|Ride"] = 739.19}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 2.63, ["Neon"] = 17.4, ["Neon|Fly|Ride"] = 142.68, ["Mega"] = 157.57, ["Mega|Fly|Ride"] = 319.25}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 27.69, ["Ride"] = 14.81, ["Fly|Ride"] = 42.6, ["Neon"] = 6.36, ["Neon|Fly"] = 42.6, ["Neon|Ride"] = 22.92, ["Neon|Fly|Ride"] = 93.7, ["Mega"] = 70.7, ["Mega|Ride"] = 89.12, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 2.1, ["Fly"] = 47.81, ["Ride"] = 23.43, ["Fly|Ride"] = 69.56, ["Neon"] = 11.69, ["Neon|Ride"] = 36.21, ["Neon|Fly|Ride"] = 105, ["Mega"] = 83.35, ["Mega|Ride"] = 104.74, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 32.8, ["Ride"] = 19.68, ["Fly|Ride"] = 57.66, ["Neon"] = 3.61, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 107.62, ["Mega"] = 48.56, ["Mega|Fly"] = 122.42, ["Mega|Ride"] = 83.99, ["Mega|Fly|Ride"] = 212.91}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.1, ["Fly"] = 65.62, ["Ride"] = 21.03, ["Fly|Ride"] = 76.67, ["Neon"] = 18.27, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 212.94, ["Mega"] = 285.51, ["Mega|Ride"] = 324.19, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.82, ["Fly"] = 49.6, ["Ride"] = 24.5, ["Fly|Ride"] = 425.86, ["Neon"] = 28.69, ["Neon|Fly"] = 315, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 150.94, ["Mega"] = 302.47, ["Mega|Ride"] = 287.46, ["Mega|Fly|Ride"] = 1064.49}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 3.29, ["Fly"] = 131.25, ["Ride"] = 17.06, ["Fly|Ride"] = 70.88, ["Neon"] = 32.13, ["Neon|Fly"] = 113.93, ["Neon|Ride"] = 29.76, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 253.49, ["Mega|Ride"] = 266.34, ["Mega|Fly|Ride"] = 396.38}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 35.48, ["Ride"] = 23.63, ["Fly|Ride"] = 51.78, ["Neon"] = 21.31, ["Neon|Ride"] = 69.08, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 255.49, ["Mega|Ride"] = 189.34, ["Mega|Fly|Ride"] = 186.18}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 45.61, ["Fly|Ride"] = 91.88, ["Neon"] = 11.46, ["Neon|Fly"] = 437.06, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 160.13, ["Mega"] = 91.25, ["Mega|Fly"] = 210, ["Mega|Ride"] = 132.37, ["Mega|Fly|Ride"] = 248.05}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 19.18, ["Fly"] = 212.94, ["Ride"] = 110.53, ["Fly|Ride"] = 375.26, ["Neon"] = 118.13, ["Neon|Ride"] = 185.07, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 590.62, ["Mega|Ride"] = 602.41, ["Mega|Fly|Ride"] = 623.44}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 43.78, ["Fly"] = 164.07, ["Ride"] = 70.42, ["Fly|Ride"] = 189, ["Neon"] = 235.6, ["Neon|Ride"] = 184.69, ["Neon|Fly|Ride"] = 366.03, ["Mega"] = 1342.11, ["Mega|Ride"] = 886.49, ["Mega|Fly|Ride"] = 1102.49}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 51.18, ["Ride"] = 21.55, ["Fly|Ride"] = 118.12, ["Neon"] = 2.1, ["Neon|Ride"] = 32.8, ["Neon|Fly|Ride"] = 142.68, ["Mega"] = 26.71, ["Mega|Ride"] = 64.71, ["Mega|Fly|Ride"] = 145.59}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 6.54, ["Ride"] = 52.5, ["Neon"] = 117.7, ["Neon|Ride"] = 112.4, ["Mega"] = 686.56, ["Mega|Ride"] = 710.01, ["Mega|Fly|Ride"] = 1118.78}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 47.23, ["Ride"] = 91.91, ["Neon"] = 418.01, ["Neon|Ride"] = 357, ["Neon|Fly|Ride"] = 850.63, ["Mega"] = 1702.13, ["Mega|Ride"] = 1608.45, ["Mega|Fly|Ride"] = 1164.56}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 6.6, ["Fly"] = 190.32, ["Ride"] = 29.5, ["Fly|Ride"] = 133.88, ["Neon"] = 49.88, ["Neon|Fly"] = 127.94, ["Neon|Ride"] = 70.87, ["Neon|Fly|Ride"] = 126, ["Mega"] = 192.94, ["Mega|Ride"] = 242.71, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 5.1, ["Ride"] = 68.85, ["Neon"] = 9.06, ["Neon|Ride"] = 68.23, ["Neon|Fly|Ride"] = 123.37, ["Mega"] = 89.24, ["Mega|Fly"] = 282.18, ["Mega|Ride"] = 140.44, ["Mega|Fly|Ride"] = 568.45}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 25.71, ["Ride"] = 17.16, ["Fly|Ride"] = 45.94, ["Neon"] = 9.85, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 101.15, ["Mega"] = 124.69, ["Mega|Ride"] = 63.53, ["Mega|Fly|Ride"] = 279.57}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 17.64, ["Ride"] = 15.75, ["Fly|Ride"] = 42.6, ["Neon"] = 2.1, ["Neon|Fly"] = 23.89, ["Neon|Ride"] = 17.95, ["Neon|Fly|Ride"] = 45.85, ["Mega"] = 28.88, ["Mega|Ride"] = 69.56, ["Mega|Fly|Ride"] = 87.94}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 15.75, ["Fly|Ride"] = 85.55, ["Neon"] = 3.78, ["Neon|Ride"] = 24.05, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 35.07, ["Mega|Fly"] = 126.58, ["Mega|Ride"] = 63.89, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Neon"] = 2.37, ["Neon|Ride"] = 145.08, ["Mega"] = 31.95, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 328.02}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 4.35, ["Ride"] = 104.99, ["Neon"] = 38.36, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 399.35, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 411.97}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 8.28, ["Ride"] = 30.19, ["Fly|Ride"] = 210.35, ["Neon"] = 53.72, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 227.84, ["Mega"] = 196.88, ["Mega|Ride"] = 351.75, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 6.03, ["Fly"] = 24.5, ["Ride"] = 17.47, ["Fly|Ride"] = 35.43, ["Neon"] = 28.56, ["Neon|Fly"] = 57.4, ["Neon|Ride"] = 35.9, ["Neon|Fly|Ride"] = 83.98, ["Mega"] = 326.81, ["Mega|Ride"] = 264.47, ["Mega|Fly|Ride"] = 360.38}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 53.99, ["Ride"] = 88.54, ["Fly|Ride"] = 262.5, ["Neon"] = 393.75, ["Neon|Ride"] = 424.79, ["Neon|Fly|Ride"] = 710.11, ["Mega"] = 2391.25, ["Mega|Ride"] = 1275.74, ["Mega|Fly|Ride"] = 1276.32}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 17.05, ["Fly"] = 82.69, ["Ride"] = 43.32, ["Fly|Ride"] = 51.19, ["Neon"] = 284.27, ["Neon|Fly|Ride"] = 630, ["Mega"] = 573.91, ["Mega|Ride"] = 879.38, ["Mega|Fly|Ride"] = 1042.79}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 21.11, ["Ride"] = 15.75, ["Fly|Ride"] = 39.99, ["Neon"] = 2.1, ["Neon|Fly"] = 42.6, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 56.44, ["Mega"] = 212.91, ["Mega|Fly"] = 71.34, ["Mega|Ride"] = 93.44, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 21.31, ["Ride"] = 15.27, ["Fly|Ride"] = 32.09, ["Neon"] = 3.93, ["Neon|Fly"] = 28.85, ["Neon|Ride"] = 17.05, ["Neon|Fly|Ride"] = 43.32, ["Mega"] = 39.38, ["Mega|Fly"] = 127.75, ["Mega|Ride"] = 56.27, ["Mega|Fly|Ride"] = 90.96}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 406.88, ["Fly"] = 558.13, ["Ride"] = 441.83, ["Fly|Ride"] = 496.62, ["Neon|Fly|Ride"] = 1903.54, ["Mega|Fly|Ride"] = 6742.43}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 7.91, ["Fly"] = 113.93, ["Ride"] = 26.25, ["Fly|Ride"] = 113.93, ["Neon"] = 39.35, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 403.5, ["Mega|Ride"] = 400.32, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 19, ["Fly|Ride"] = 33.5, ["Neon"] = 2.77, ["Neon|Fly"] = 18.19, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 34.01, ["Mega"] = 42.6, ["Mega|Ride"] = 79.96, ["Mega|Fly|Ride"] = 106.42}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 52.4, ["Ride"] = 98.24, ["Fly|Ride"] = 261.19, ["Neon"] = 207.9, ["Neon|Ride"] = 261.19, ["Neon|Fly|Ride"] = 392.43, ["Mega"] = 737.62, ["Mega|Ride"] = 761.25, ["Mega|Fly|Ride"] = 878.37}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 27.26, ["Ride"] = 15.38, ["Fly|Ride"] = 41.24, ["Neon"] = 9.53, ["Neon|Fly"] = 76.67, ["Neon|Ride"] = 28.41, ["Neon|Fly|Ride"] = 79.93, ["Mega"] = 124.69, ["Mega|Ride"] = 143.07, ["Mega|Fly|Ride"] = 204.37}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 71.35, ["Ride"] = 32.82, ["Fly|Ride"] = 196.88, ["Neon"] = 2.1, ["Neon|Fly"] = 100.09, ["Neon|Ride"] = 37.51, ["Neon|Fly|Ride"] = 75.17, ["Mega"] = 19.21, ["Mega|Ride"] = 57.5, ["Mega|Fly|Ride"] = 209.57}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 30.15, ["Fly"] = 126.7, ["Ride"] = 78.72, ["Fly|Ride"] = 213.56, ["Neon"] = 178.86, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 383.27, ["Mega"] = 752.61, ["Mega|Ride"] = 640.57, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 19.68, ["Fly|Ride"] = 146.99, ["Neon"] = 5.7, ["Neon|Ride"] = 40.6, ["Neon|Fly|Ride"] = 78.8, ["Mega"] = 32.17, ["Mega|Ride"] = 153.92, ["Mega|Fly|Ride"] = 252}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 32.82, ["Ride"] = 85.19, ["Fly|Ride"] = 105, ["Neon"] = 148.32, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 359.63, ["Mega"] = 1753.99, ["Mega|Ride"] = 1703.19, ["Mega|Fly|Ride"] = 1333.83}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 2.1, ["Fly"] = 71.35, ["Ride"] = 131.24, ["Fly|Ride"] = 425.86, ["Neon"] = 23.34, ["Neon|Ride"] = 31.11, ["Neon|Fly|Ride"] = 497.13, ["Mega"] = 170.63, ["Mega|Ride"] = 227.81}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.1, ["Fly"] = 71.35, ["Ride"] = 72.76, ["Fly|Ride"] = 71.35, ["Neon"] = 8.64, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 430.41, ["Mega"] = 100.08, ["Mega|Ride"] = 124.69, ["Mega|Fly|Ride"] = 319.25}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 38.95, ["Fly"] = 85.19, ["Ride"] = 62.32, ["Fly|Ride"] = 532.32, ["Mega|Ride"] = 1703.19, ["Mega|Fly|Ride"] = 1981.01}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 520.62, ["Ride"] = 38.07, ["Neon"] = 4.96, ["Neon|Ride"] = 40.61, ["Neon|Fly|Ride"] = 113.93, ["Mega"] = 32.82, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 127.75, ["Mega|Fly|Ride"] = 227.75}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 22.24, ["Ride"] = 15.49, ["Fly|Ride"] = 102.88, ["Neon"] = 8.22, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 26.23, ["Neon|Fly|Ride"] = 63.89, ["Mega"] = 86.63, ["Mega|Fly"] = 147.07, ["Mega|Ride"] = 120.91, ["Mega|Fly|Ride"] = 219.19}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 10.06, ["Fly"] = 57.91, ["Ride"] = 32.78, ["Fly|Ride"] = 169.31, ["Neon"] = 81.86, ["Neon|Ride"] = 77.43, ["Neon|Fly|Ride"] = 144.27, ["Mega"] = 328.12, ["Mega|Ride"] = 275.62, ["Mega|Fly|Ride"] = 341.24}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 8.52, ["Fly"] = 62.91, ["Ride"] = 23.76, ["Fly|Ride"] = 52.5, ["Neon"] = 72.19, ["Neon|Ride"] = 85.19, ["Neon|Fly|Ride"] = 125.21, ["Mega"] = 428.05, ["Mega|Ride"] = 405.85, ["Mega|Fly|Ride"] = 566.31}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 25.76, ["Fly"] = 28.84, ["Ride"] = 28.08, ["Fly|Ride"] = 53.34, ["Neon"] = 76.58, ["Neon|Ride"] = 82.77, ["Neon|Fly|Ride"] = 140.31, ["Mega"] = 404.88, ["Mega|Ride"] = 323.53, ["Mega|Fly|Ride"] = 568.45}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 60.36, ["Ride"] = 121.93, ["Fly|Ride"] = 259.77, ["Neon"] = 262.49, ["Neon|Ride"] = 275.22, ["Neon|Fly|Ride"] = 423.94, ["Mega"] = 1575, ["Mega|Ride"] = 1554.16, ["Mega|Fly|Ride"] = 1384.04}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 5.27, ["Ride"] = 111.2, ["Neon"] = 26.25, ["Neon|Ride"] = 113.47, ["Neon|Fly|Ride"] = 296.09, ["Mega"] = 239.08, ["Mega|Ride"] = 293.82, ["Mega|Fly|Ride"] = 469.45}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 3.78, ["Ride"] = 27.27, ["Fly|Ride"] = 78.74, ["Neon"] = 15.85, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 261.89, ["Mega|Ride"] = 244.13, ["Mega|Fly|Ride"] = 251.23}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 7.77, ["Fly"] = 135.19, ["Ride"] = 35.87, ["Fly|Ride"] = 115.5, ["Neon"] = 57.63, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 175.09, ["Mega"] = 314.03, ["Mega|Ride"] = 639.19, ["Mega|Fly|Ride"] = 759.94}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 15.65, ["Fly|Ride"] = 38.75, ["Neon"] = 2.1, ["Neon|Fly"] = 21.69, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 28.66, ["Mega"] = 14.1, ["Mega|Ride"] = 26.77, ["Mega|Fly|Ride"] = 95.7}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 47.11, ["Fly"] = 225.71, ["Ride"] = 112.35, ["Fly|Ride"] = 284.27, ["Neon"] = 236.25, ["Neon|Fly"] = 2413.49, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 488.25, ["Mega"] = 1063.43, ["Mega|Ride"] = 944.99, ["Mega|Fly|Ride"] = 879.38}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 15.9, ["Fly|Ride"] = 142.68, ["Neon"] = 5.12, ["Neon|Ride"] = 44.18, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 26.25, ["Mega|Ride"] = 142.65, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 28.76, ["Ride"] = 19.46, ["Fly|Ride"] = 59.07, ["Neon"] = 18.38, ["Neon|Ride"] = 28.76, ["Neon|Fly|Ride"] = 71.35, ["Mega"] = 257.25, ["Mega|Ride"] = 193.1, ["Mega|Fly|Ride"] = 228.38}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 61.6, ["Ride"] = 66.94, ["Fly|Ride"] = 229.87, ["Neon"] = 203.69, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 425.81, ["Mega"] = 940.74, ["Mega|Ride"] = 992.12, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 28.71, ["Neon"] = 2.63, ["Neon|Ride"] = 52.5, ["Mega"] = 64.32, ["Mega|Ride"] = 110.06, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 5.73}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 23, ["Fly|Ride"] = 100.09, ["Neon"] = 7.76, ["Neon|Fly"] = 32.3, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 113.93, ["Mega"] = 42.6, ["Mega|Ride"] = 97.13, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 126.62, ["Ride"] = 180.54, ["Fly|Ride"] = 348.14, ["Neon"] = 710.11, ["Neon|Ride"] = 558.31, ["Neon|Fly|Ride"] = 665.05, ["Mega"] = 6386.9, ["Mega|Ride"] = 3188.74, ["Mega|Fly|Ride"] = 2550.52}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 4.27, ["Ride"] = 36.33, ["Fly|Ride"] = 212.94, ["Neon"] = 20.69, ["Neon|Fly"] = 142.68, ["Neon|Ride"] = 63.89, ["Neon|Fly|Ride"] = 95.66, ["Mega"] = 178.39, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 26.24, ["Neon"] = 3.62, ["Neon|Ride"] = 21.31, ["Mega"] = 32.03, ["Mega|Ride"] = 71.34, ["Mega|Fly|Ride"] = 314.03}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 3.68, ["Fly"] = 39.38, ["Ride"] = 26.74, ["Fly|Ride"] = 49.88, ["Neon"] = 55.28, ["Neon|Ride"] = 89.63, ["Neon|Fly|Ride"] = 153.55, ["Mega"] = 425.81, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 637.64}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 7.85, ["Fly"] = 51.79, ["Ride"] = 21.31, ["Fly|Ride"] = 56.58, ["Neon"] = 72.18, ["Neon|Ride"] = 157.86, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 619.8, ["Mega|Ride"] = 444.8, ["Mega|Fly|Ride"] = 478.27}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 19.29, ["Ride"] = 59.07, ["Neon"] = 145.69, ["Neon|Ride"] = 182.2, ["Neon|Fly|Ride"] = 1575, ["Mega"] = 539.7, ["Mega|Ride"] = 504.86, ["Mega|Fly|Ride"] = 599.8}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 139.5, ["Fly"] = 158.45, ["Ride"] = 181.79, ["Fly|Ride"] = 225.75, ["Neon"] = 565.13, ["Neon|Fly"] = 677.87, ["Neon|Ride"] = 645.6, ["Neon|Fly|Ride"] = 520.73, ["Mega|Ride"] = 2554.77, ["Mega|Fly|Ride"] = 3238.49}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 5.59, ["Fly"] = 19.24, ["Ride"] = 16.1, ["Fly|Ride"] = 41.91, ["Neon"] = 40.85, ["Neon|Fly"] = 155.44, ["Neon|Ride"] = 39.05, ["Neon|Fly|Ride"] = 78.66, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 3.89, ["Fly"] = 131.23, ["Ride"] = 17.05, ["Fly|Ride"] = 131.24, ["Neon"] = 17.07, ["Neon|Fly"] = 42.6, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 143.49, ["Mega|Ride"] = 166.07, ["Mega|Fly|Ride"] = 425.81}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 3.75, ["Fly"] = 41.5, ["Ride"] = 28.25, ["Fly|Ride"] = 127.76, ["Neon"] = 46.3, ["Neon|Fly"] = 128.63, ["Neon|Ride"] = 42.67, ["Neon|Fly|Ride"] = 160.22, ["Mega"] = 420, ["Mega|Ride"] = 429, ["Mega|Fly|Ride"] = 1036.88}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 39.51, ["Fly"] = 100.09, ["Ride"] = 70.6, ["Fly|Ride"] = 134.37, ["Neon"] = 209.9, ["Neon|Ride"] = 199.11, ["Neon|Fly|Ride"] = 255.94, ["Mega"] = 954.19, ["Mega|Ride"] = 925.32, ["Mega|Fly|Ride"] = 1155.63}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 20.78, ["Fly"] = 57.75, ["Ride"] = 63.84, ["Neon"] = 125.9, ["Neon|Ride"] = 191.3, ["Neon|Fly|Ride"] = 469.51, ["Mega"] = 1049.9, ["Mega|Ride"] = 1712.27, ["Mega|Fly|Ride"] = 834.58}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 327.47, ["Ride"] = 568.52, ["Neon|Ride"] = 3188.49}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 17.07, ["Fly"] = 54.85, ["Ride"] = 30.19, ["Fly|Ride"] = 69.55, ["Neon"] = 223.58, ["Neon|Ride"] = 157.58, ["Neon|Fly|Ride"] = 264.23, ["Mega"] = 761.25, ["Mega|Ride"] = 734.9, ["Mega|Fly|Ride"] = 955.91}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 41.62, ["Ride"] = 14.01, ["Fly|Ride"] = 71.35, ["Neon"] = 2.1, ["Neon|Fly"] = 21.6, ["Neon|Ride"] = 18, ["Neon|Fly|Ride"] = 52.82, ["Mega"] = 15.75, ["Mega|Fly"] = 110.73, ["Mega|Ride"] = 40.01, ["Mega|Fly|Ride"] = 113.52}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 2.1, ["Neon"] = 7.23, ["Neon|Ride"] = 42.28, ["Neon|Fly|Ride"] = 142.68, ["Mega"] = 94.11, ["Mega|Ride"] = 164.18, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 26.25, ["Fly|Ride"] = 125.64, ["Neon"] = 13.54, ["Neon|Fly"] = 87.94, ["Neon|Ride"] = 48.55, ["Neon|Fly|Ride"] = 1181.23, ["Mega"] = 133.61, ["Mega|Fly"] = 498.61, ["Mega|Ride"] = 129.93, ["Mega|Fly|Ride"] = 319.36}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 425.24, ["Fly"] = 497.19, ["Ride"] = 418.69, ["Fly|Ride"] = 513.19, ["Neon"] = 1898.49, ["Neon|Ride"] = 2041.93, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 5445.9}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 3.94, ["Fly"] = 37.97, ["Ride"] = 15.75, ["Fly|Ride"] = 43.65, ["Neon"] = 17.1, ["Neon|Ride"] = 28.71, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 183.65, ["Mega|Ride"] = 213.94, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 6.46, ["Fly"] = 21.31, ["Ride"] = 17.73, ["Fly|Ride"] = 42, ["Neon"] = 20.25, ["Neon|Fly"] = 33.07, ["Neon|Ride"] = 59.63, ["Neon|Fly|Ride"] = 108.96, ["Mega"] = 176.97, ["Mega|Ride"] = 288.49, ["Mega|Fly|Ride"] = 276.94}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 3.63, ["Fly"] = 45.71, ["Ride"] = 21, ["Fly|Ride"] = 61.24, ["Neon"] = 13.12, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 41.99, ["Neon|Fly|Ride"] = 107.33, ["Mega"] = 111.56, ["Mega|Ride"] = 284.23, ["Mega|Fly|Ride"] = 236.23}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 24.05, ["Fly"] = 47.81, ["Ride"] = 32.81, ["Fly|Ride"] = 65.63, ["Neon"] = 220.5, ["Neon|Ride"] = 196.85, ["Neon|Fly|Ride"] = 318.33, ["Mega"] = 638.48, ["Mega|Ride"] = 851.6, ["Mega|Fly|Ride"] = 603.58}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 53.25, ["Ride"] = 34.12, ["Fly|Ride"] = 51.85, ["Neon"] = 11.46, ["Neon|Ride"] = 47.84, ["Neon|Fly|Ride"] = 210, ["Mega"] = 163.74, ["Mega|Ride"] = 457.79, ["Mega|Fly|Ride"] = 1021.92}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 8.97, ["Fly"] = 65.6, ["Ride"] = 28.26, ["Fly|Ride"] = 72.18, ["Neon"] = 160.19, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 355.6, ["Mega|Fly|Ride"] = 1066.63}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 15.23, ["Neon"] = 3.81, ["Neon|Ride"] = 34.09, ["Mega"] = 54.29, ["Mega|Ride"] = 120.3, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 3.07, ["Ride"] = 142.68, ["Neon"] = 17.94, ["Mega"] = 186.31, ["Mega|Ride"] = 319.25, ["Mega|Fly|Ride"] = 715.98}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 6.38, ["Ride"] = 57.5, ["Neon"] = 118.13, ["Neon|Ride"] = 284.27, ["Neon|Fly|Ride"] = 178.86, ["Mega"] = 309.79, ["Mega|Ride"] = 556.4, ["Mega|Fly|Ride"] = 463.32}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 7.13, ["Fly"] = 26.01, ["Ride"] = 21.42, ["Fly|Ride"] = 49.37, ["Neon"] = 49.35, ["Neon|Fly"] = 113.93, ["Neon|Ride"] = 52.4, ["Neon|Fly|Ride"] = 104.98, ["Mega"] = 561.95, ["Mega|Ride"] = 296.54, ["Mega|Fly|Ride"] = 374.43}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 363.21, ["Fly"] = 517.96, ["Ride"] = 439.69, ["Fly|Ride"] = 429.19, ["Neon"] = 1642.41, ["Neon|Ride"] = 1743.52, ["Neon|Fly|Ride"] = 1640.63, ["Mega"] = 6798.86}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 15.74, ["Fly|Ride"] = 39.38, ["Neon"] = 15.65, ["Neon|Fly"] = 80.12, ["Neon|Ride"] = 32.28, ["Mega"] = 227.81, ["Mega|Ride"] = 196.77, ["Mega|Fly|Ride"] = 300.13}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 3.92, ["Fly"] = 63.89, ["Ride"] = 51.43, ["Fly|Ride"] = 177.19, ["Neon"] = 57.38, ["Neon|Ride"] = 122.03, ["Neon|Fly|Ride"] = 185.26, ["Mega"] = 389.62, ["Mega|Fly"] = 710.01, ["Mega|Ride"] = 415.8, ["Mega|Fly|Ride"] = 531.19}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 18.16, ["Ride"] = 80.09, ["Fly|Ride"] = 302.99, ["Neon"] = 74.99, ["Neon|Ride"] = 135.14, ["Neon|Fly|Ride"] = 424.79, ["Mega"] = 301.95, ["Mega|Ride"] = 359.63, ["Mega|Fly|Ride"] = 513.24}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 52.5, ["Fly"] = 146.86, ["Ride"] = 71.37, ["Fly|Ride"] = 131.25, ["Neon"] = 321.57, ["Neon|Ride"] = 334.69, ["Neon|Fly|Ride"] = 380.63, ["Mega"] = 2492.09, ["Mega|Ride"] = 1420.02, ["Mega|Fly|Ride"] = 1609.63}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 7.54, ["Fly"] = 106.47, ["Ride"] = 40.67, ["Fly|Ride"] = 131.24, ["Neon"] = 33.76, ["Neon|Ride"] = 122.06, ["Neon|Fly|Ride"] = 227.84, ["Mega"] = 170.33, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 342.51}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 21.31, ["Ride"] = 19.59, ["Fly|Ride"] = 58.46, ["Neon"] = 17.73, ["Neon|Ride"] = 33.53, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 65.62, ["Mega|Ride"] = 174.58, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 5.19, ["Ride"] = 33.03, ["Neon"] = 19.2, ["Neon|Ride"] = 105.84, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 114.02, ["Mega|Fly"] = 241.65, ["Mega|Ride"] = 160.23, ["Mega|Fly|Ride"] = 277.52}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 41.49, ["Fly"] = 137.8, ["Ride"] = 84, ["Fly|Ride"] = 198.02, ["Neon"] = 98.44, ["Neon|Ride"] = 162.72, ["Neon|Fly|Ride"] = 236.24, ["Mega"] = 417.69, ["Mega|Ride"] = 448.88, ["Mega|Fly|Ride"] = 552.75}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.63, ["Ride"] = 131.25, ["Neon"] = 5.25, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 48.99, ["Mega|Fly"] = 185.24, ["Mega|Ride"] = 164.07, ["Mega|Fly|Ride"] = 272.99}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 23.61, ["Ride"] = 212.94, ["Neon"] = 162.75, ["Neon|Ride"] = 401.03, ["Mega"] = 577.5, ["Mega|Fly|Ride"] = 685.54}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 879.38, ["Fly"] = 1004.07, ["Ride"] = 918.75, ["Fly|Ride"] = 1063.13, ["Neon"] = 3385.47, ["Neon|Ride"] = 3402.5, ["Neon|Fly|Ride"] = 3281.25, ["Mega|Fly|Ride"] = 9935.89}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 14.18, ["Fly"] = 108.51, ["Ride"] = 40.15, ["Fly|Ride"] = 173.25, ["Neon"] = 63.95, ["Neon|Fly"] = 711.38, ["Neon|Ride"] = 191.3, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 338.52, ["Mega|Ride"] = 328.27, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.1, ["Fly"] = 49.37, ["Ride"] = 25.76, ["Fly|Ride"] = 90.55, ["Neon"] = 10.84, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 90.97, ["Mega"] = 63, ["Mega|Ride"] = 80.07, ["Mega|Fly|Ride"] = 169.26}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 7.54, ["Ride"] = 59.07, ["Fly|Ride"] = 142.68, ["Neon"] = 57.68, ["Neon|Fly"] = 84.12, ["Neon|Fly|Ride"] = 393.73, ["Mega"] = 266.93, ["Mega|Ride"] = 413.11, ["Mega|Fly|Ride"] = 475.88}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 24.5, ["Fly|Ride"] = 185.79, ["Neon"] = 2.1, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 100.08, ["Mega"] = 11.72, ["Mega|Ride"] = 43.52, ["Mega|Fly|Ride"] = 142.42}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 35.43, ["Ride"] = 98.44, ["Fly|Ride"] = 236.25, ["Neon"] = 223.12, ["Neon|Ride"] = 245.6, ["Neon|Fly|Ride"] = 394.77, ["Mega"] = 1052.18, ["Mega|Ride"] = 763.35, ["Mega|Fly|Ride"] = 918.48}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 6.3, ["Ride"] = 52.5, ["Fly|Ride"] = 278.21, ["Neon"] = 85.58, ["Neon|Ride"] = 328.12, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 418.69, ["Mega|Ride"] = 777.09, ["Mega|Fly|Ride"] = 723.19}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2.1, ["Ride"] = 27.69, ["Neon"] = 7.88, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 212.94, ["Mega"] = 91.55, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 476.9}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 13.06, ["Fly"] = 52.5, ["Ride"] = 35.62, ["Fly|Ride"] = 112.86, ["Neon"] = 51.19, ["Neon|Ride"] = 83.58, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 409.17, ["Mega|Ride"] = 398.13, ["Mega|Fly|Ride"] = 391.13}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 3.92, ["Fly"] = 95.83, ["Ride"] = 26.25, ["Fly|Ride"] = 78.89, ["Neon"] = 26.25, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 144.18, ["Mega"] = 378.71, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 1090.46}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 26.21, ["Ride"] = 91.88, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 864.94, ["Mega"] = 2128.97, ["Mega|Ride"] = 2391.25, ["Mega|Fly|Ride"] = 2111.95}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 2.1, ["Ride"] = 28.76, ["Fly|Ride"] = 184.11, ["Neon"] = 13.91, ["Neon|Ride"] = 85.19, ["Neon|Fly|Ride"] = 170.36, ["Mega"] = 57.63, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 227.75}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 5.83, ["Ride"] = 20.79, ["Fly|Ride"] = 47.81, ["Neon"] = 44.92, ["Neon|Fly"] = 185.26, ["Neon|Ride"] = 60.05, ["Neon|Fly|Ride"] = 91.77, ["Mega"] = 261.15, ["Mega|Ride"] = 351.75, ["Mega|Fly|Ride"] = 710.01}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 111.57, ["Fly"] = 393.75, ["Ride"] = 139.46, ["Fly|Ride"] = 284.27, ["Neon"] = 433.12, ["Neon|Fly"] = 538.13, ["Neon|Ride"] = 459.27, ["Neon|Fly|Ride"] = 650.79, ["Mega|Ride"] = 2122.59, ["Mega|Fly|Ride"] = 1965.46}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 24.93, ["Ride"] = 15.56, ["Fly|Ride"] = 31.48, ["Neon"] = 11.34, ["Neon|Fly"] = 57.32, ["Neon|Ride"] = 27.69, ["Neon|Fly|Ride"] = 54.01, ["Mega"] = 145.69, ["Mega|Ride"] = 142.65, ["Mega|Fly|Ride"] = 204.56}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 13.13, ["Fly"] = 200.81, ["Ride"] = 38.07, ["Fly|Ride"] = 116.94, ["Neon"] = 63.63, ["Neon|Ride"] = 106.12, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 452.82, ["Mega|Ride"] = 498.74, ["Mega|Fly|Ride"] = 597.9}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 18.27, ["Ride"] = 15.09, ["Fly|Ride"] = 52.48, ["Neon"] = 2.1, ["Neon|Fly"] = 28.04, ["Neon|Ride"] = 16.59, ["Neon|Fly|Ride"] = 45.91, ["Mega"] = 13.62, ["Mega|Fly"] = 50.23, ["Mega|Ride"] = 37.57, ["Mega|Fly|Ride"] = 80.06}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 57.5, ["Fly|Ride"] = 39.38, ["Neon"] = 3.46, ["Neon|Ride"] = 42.6, ["Neon|Fly|Ride"] = 127.76, ["Mega"] = 17.06, ["Mega|Fly"] = 118.11, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 169.26}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.1, ["Fly"] = 36.21, ["Ride"] = 18.69, ["Fly|Ride"] = 173.25, ["Neon"] = 9.35, ["Neon|Ride"] = 55.54, ["Neon|Fly|Ride"] = 100.09, ["Mega"] = 89.59, ["Mega|Ride"] = 284.67, ["Mega|Fly|Ride"] = 246.1}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 28.25, ["Ride"] = 59.07, ["Fly|Ride"] = 131.25, ["Neon"] = 128.62, ["Neon|Ride"] = 340.7, ["Neon|Fly|Ride"] = 433.13, ["Mega"] = 506.76, ["Mega|Ride"] = 636.58}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.1, ["Fly"] = 16.94, ["Ride"] = 15.3, ["Fly|Ride"] = 33.48, ["Neon"] = 9.34, ["Neon|Fly"] = 32.96, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 55.78, ["Mega"] = 67.48, ["Mega|Fly"] = 267.23, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 160.23}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 7.39, ["Fly"] = 26.25, ["Ride"] = 31.46, ["Fly|Ride"] = 107.76, ["Neon"] = 23.61, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 48.56, ["Neon|Fly|Ride"] = 119.57, ["Mega"] = 234.84, ["Mega|Fly"] = 433.13, ["Mega|Ride"] = 167.56, ["Mega|Fly|Ride"] = 314.03}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Fly"] = 27.69, ["Ride"] = 18.14, ["Fly|Ride"] = 67.92, ["Neon"] = 9.8, ["Neon|Fly"] = 98.43, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 89.24, ["Mega"] = 47.23, ["Mega|Fly"] = 81, ["Mega|Ride"] = 63.67, ["Mega|Fly|Ride"] = 126.84}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 6.96, ["Fly"] = 160.78, ["Ride"] = 23.63, ["Fly|Ride"] = 217.19, ["Neon"] = 29.87, ["Neon|Ride"] = 57.5, ["Neon|Fly|Ride"] = 284.27, ["Mega"] = 275.36, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 384.41, ["Mega|Fly|Ride"] = 409.5}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 2.6, ["Ride"] = 45.8, ["Neon"] = 50.57, ["Neon|Ride"] = 142.68, ["Mega"] = 357.69, ["Mega|Ride"] = 303.19, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 31.81, ["Ride"] = 15.38, ["Fly|Ride"] = 50.32, ["Neon"] = 27.61, ["Neon|Fly"] = 196.87, ["Neon|Ride"] = 39.45, ["Neon|Fly|Ride"] = 160.22, ["Mega"] = 262.5, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 267.11, ["Mega|Fly|Ride"] = 568.45}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 24.75, ["Ride"] = 17.05, ["Fly|Ride"] = 52.41, ["Neon"] = 11.46, ["Neon|Fly"] = 70.51, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 136.49, ["Mega|Ride"] = 102.37, ["Mega|Fly|Ride"] = 131.24}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 210, ["Fly"] = 393.75, ["Ride"] = 255.94, ["Fly|Ride"] = 392.43, ["Neon"] = 1247.73, ["Neon|Ride"] = 1219.45, ["Neon|Fly|Ride"] = 1174.69, ["Mega"] = 4145.24, ["Mega|Fly|Ride"] = 4495.32}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 4.35, ["Ride"] = 65.63, ["Neon"] = 21, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 425.86, ["Mega"] = 106.77, ["Mega|Ride"] = 638.48, ["Mega|Fly|Ride"] = 355.56}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 2.1, ["Fly"] = 106.47, ["Ride"] = 24.43, ["Fly|Ride"] = 85.19, ["Neon"] = 24.5, ["Neon|Fly"] = 241.68, ["Neon|Ride"] = 59.63, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 227.99, ["Mega|Ride"] = 194.9, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 2.56, ["Fly|Ride"] = 213.24, ["Neon"] = 37.16, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 603.74, ["Mega"] = 603.75, ["Mega|Ride"] = 404.15, ["Mega|Fly|Ride"] = 418.04}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 16.17, ["Ride"] = 15.58, ["Fly|Ride"] = 32.45, ["Neon"] = 2.1, ["Neon|Fly"] = 42.6, ["Neon|Ride"] = 15.99, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 18.38, ["Mega|Fly"] = 78.79, ["Mega|Ride"] = 42.2, ["Mega|Fly|Ride"] = 62.36}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.1, ["Fly"] = 42.37, ["Ride"] = 17.75, ["Fly|Ride"] = 45.43, ["Neon"] = 14.34, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 82.67, ["Mega"] = 132.57, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 213.94}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.1, ["Ride"] = 119.85, ["Neon"] = 8.67, ["Neon|Ride"] = 283.2, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 36.74, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 276.94}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 65.62, ["Fly"] = 93.7, ["Ride"] = 78.74, ["Fly|Ride"] = 183.1, ["Neon"] = 393.75, ["Neon|Fly"] = 472.25, ["Neon|Ride"] = 409.49, ["Neon|Fly|Ride"] = 426.57, ["Mega|Ride"] = 3550.05, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 3.01, ["Fly"] = 71.35, ["Ride"] = 26.24, ["Fly|Ride"] = 141.73, ["Neon"] = 27.84, ["Neon|Ride"] = 66.94, ["Mega"] = 168, ["Mega|Ride"] = 227.2, ["Mega|Fly|Ride"] = 355.56}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 48.99, ["Ride"] = 34.12, ["Neon"] = 6.39, ["Neon|Ride"] = 80.12, ["Neon|Fly|Ride"] = 542.33, ["Mega"] = 66.94, ["Mega|Fly"] = 314.99, ["Mega|Ride"] = 125.9, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 45.41, ["Fly"] = 160.16, ["Ride"] = 77.87, ["Fly|Ride"] = 186.84, ["Neon"] = 115.5, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 433.13, ["Mega|Ride"] = 551.25, ["Mega|Fly|Ride"] = 654.94}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 28.74, ["Ride"] = 13.89, ["Fly|Ride"] = 33.29, ["Neon"] = 2.1, ["Neon|Fly"] = 22.3, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 26.25, ["Mega"] = 20.22, ["Mega|Fly"] = 45.49, ["Mega|Ride"] = 31.5, ["Mega|Fly|Ride"] = 92.63}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 3.68, ["Neon|Ride"] = 31.77, ["Neon|Fly|Ride"] = 285.33, ["Mega"] = 23.81, ["Mega|Ride"] = 78.64, ["Mega|Fly|Ride"] = 181.8}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.63, ["Ride"] = 47.81, ["Neon"] = 4.27, ["Neon|Ride"] = 108.94, ["Neon|Fly|Ride"] = 142.7, ["Mega"] = 59.07, ["Mega|Fly"] = 185.24, ["Mega|Ride"] = 115.8, ["Mega|Fly|Ride"] = 186.15}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 7.74, ["Fly"] = 89.65, ["Ride"] = 51.5, ["Fly|Ride"] = 113.93, ["Neon"] = 19.68, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 157.58, ["Mega"] = 118.02, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 178.9, ["Mega|Fly|Ride"] = 280.88}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 20.5, ["Ride"] = 14.44, ["Fly|Ride"] = 25.56, ["Neon"] = 2.1, ["Neon|Fly"] = 24.5, ["Neon|Ride"] = 27.37, ["Neon|Fly|Ride"] = 48.61, ["Mega"] = 18.25, ["Mega|Ride"] = 66.01, ["Mega|Fly|Ride"] = 78.66}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 18.78, ["Ride"] = 52.49, ["Neon"] = 71.34, ["Neon|Fly"] = 425.86, ["Neon|Ride"] = 202.57, ["Neon|Fly|Ride"] = 1312.5, ["Mega"] = 505.65, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 718.54}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2205, ["Fly"] = 2626.41, ["Ride"] = 2464.88, ["Fly|Ride"] = 2404.98, ["Neon|Fly|Ride"] = 7415.63, ["Mega|Fly|Ride"] = 44175.98}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 20.09, ["Ride"] = 15.86, ["Fly|Ride"] = 36.21, ["Neon"] = 6.36, ["Neon|Fly"] = 58.5, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 57.7, ["Mega"] = 70.86, ["Mega|Fly"] = 425.81, ["Mega|Ride"] = 86.71, ["Mega|Fly|Ride"] = 141.74}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.1, ["Ride"] = 65.63, ["Neon"] = 8.8, ["Mega"] = 107.01, ["Mega|Fly"] = 441, ["Mega|Ride"] = 160.23, ["Mega|Fly|Ride"] = 425.81}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 14.43, ["Fly"] = 142.68, ["Ride"] = 25.65, ["Fly|Ride"] = 131.25, ["Neon"] = 79.25, ["Neon|Ride"] = 99.75, ["Neon|Fly|Ride"] = 301.88, ["Mega"] = 472.5, ["Mega|Ride"] = 420.47, ["Mega|Fly|Ride"] = 459.37}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 25.77, ["Fly"] = 106.47, ["Ride"] = 64.96, ["Neon"] = 142.68, ["Neon|Ride"] = 190.32, ["Mega"] = 500.47, ["Mega|Ride"] = 608.9, ["Mega|Fly|Ride"] = 701.51}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 157.49, ["Fly"] = 1420.2, ["Ride"] = 157.27, ["Fly|Ride"] = 255.49, ["Neon"] = 1194.35, ["Neon|Ride"] = 568.52, ["Neon|Fly|Ride"] = 780.94, ["Mega"] = 6386.9, ["Mega|Fly|Ride"] = 3917.31}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 7.21, ["Ride"] = 65.63, ["Fly|Ride"] = 675.94, ["Neon"] = 18.53, ["Neon|Ride"] = 85.19, ["Mega"] = 144.45, ["Mega|Fly|Ride"] = 411.97}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 36.21, ["Neon"] = 12.91, ["Neon|Ride"] = 114.85, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 245.44, ["Mega|Ride"] = 330.65, ["Mega|Fly|Ride"] = 267.09}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Fly"] = 100.33, ["Ride"] = 28.86, ["Fly|Ride"] = 131.25, ["Neon"] = 7.33, ["Neon|Fly"] = 113.93, ["Neon|Ride"] = 24.93, ["Neon|Fly|Ride"] = 210.8, ["Mega"] = 60.38, ["Mega|Ride"] = 112.41, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 13.39, ["Ride"] = 50.84, ["Fly|Ride"] = 131.25, ["Neon"] = 108.12, ["Neon|Ride"] = 174.57, ["Neon|Fly|Ride"] = 501.45, ["Mega|Ride"] = 475.12, ["Mega|Fly|Ride"] = 586.55}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 27.69, ["Mega"] = 20.25, ["Mega|Fly"] = 119.58, ["Mega|Ride"] = 81, ["Mega|Fly|Ride"] = 134.53}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 89.12, ["Fly"] = 162.09, ["Ride"] = 104.99, ["Fly|Ride"] = 94.5, ["Neon"] = 287.45, ["Neon|Fly"] = 455.67, ["Neon|Ride"] = 403.31, ["Neon|Fly|Ride"] = 373.37, ["Mega"] = 3193.46, ["Mega|Fly|Ride"] = 1849.64}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Fly"] = 28.76, ["Ride"] = 91.83, ["Fly|Ride"] = 51.19, ["Neon"] = 3.68, ["Neon|Ride"] = 142.68, ["Neon|Fly|Ride"] = 212.94, ["Mega"] = 71.75, ["Mega|Ride"] = 284.17, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 37.41, ["Fly"] = 142.68, ["Ride"] = 75.5, ["Fly|Ride"] = 170.62, ["Neon"] = 255.94, ["Neon|Ride"] = 305.55, ["Neon|Fly|Ride"] = 532.88, ["Mega"] = 2625, ["Mega|Ride"] = 1703.19, ["Mega|Fly|Ride"] = 1843.69}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 21.31, ["Fly|Ride"] = 51.96, ["Neon"] = 5.25, ["Neon|Fly"] = 83.7, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 83.99, ["Mega"] = 47.11, ["Mega|Ride"] = 103.69, ["Mega|Fly|Ride"] = 143.75}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Neon"] = 6.57, ["Neon|Ride"] = 98.44, ["Mega"] = 51.19, ["Mega|Ride"] = 159.69, ["Mega|Fly|Ride"] = 535.08}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 5.7, ["Fly"] = 77.43, ["Ride"] = 28.7, ["Fly|Ride"] = 142.68, ["Neon"] = 22.32, ["Neon|Ride"] = 47.84, ["Neon|Fly|Ride"] = 142.68, ["Mega"] = 370.13, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 567}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 328.12, ["Fly"] = 425.86, ["Ride"] = 414.75, ["Fly|Ride"] = 499.38, ["Neon"] = 1005.98, ["Neon|Ride"] = 980.44, ["Neon|Fly|Ride"] = 1076.25, ["Mega"] = 3406.35, ["Mega|Ride"] = 2774.17, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 26.17, ["Fly"] = 79.86, ["Ride"] = 42, ["Fly|Ride"] = 135.6, ["Neon"] = 160.16, ["Neon|Ride"] = 235.29, ["Neon|Fly|Ride"] = 255.84, ["Mega|Ride"] = 1128.37, ["Mega|Fly|Ride"] = 1703.19}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 47.38, ["Ride"] = 16.11, ["Fly|Ride"] = 111.57, ["Neon"] = 13.23, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 28.8, ["Neon|Fly|Ride"] = 98.34, ["Mega"] = 129.84, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 314.9}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 24.5, ["Fly"] = 97.99, ["Ride"] = 59.07, ["Fly|Ride"] = 170.63, ["Neon"] = 62.37, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 308.44, ["Mega|Fly"] = 425.81, ["Mega|Ride"] = 453.16, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 6.23, ["Ride"] = 27.69, ["Neon"] = 101.36, ["Neon|Ride"] = 122.06, ["Neon|Fly|Ride"] = 355.6, ["Mega"] = 236.25, ["Mega|Ride"] = 249.37, ["Mega|Fly|Ride"] = 425.81}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.54, ["Neon"] = 21, ["Mega"] = 91.88, ["Mega|Ride"] = 286.64, ["Mega|Fly|Ride"] = 411.97}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.1, ["Fly"] = 71.35, ["Ride"] = 15.83, ["Fly|Ride"] = 65.51, ["Neon"] = 39.38, ["Neon|Fly"] = 79.86, ["Neon|Ride"] = 50.16, ["Neon|Fly|Ride"] = 212.14, ["Mega"] = 160.23, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 84, ["Ride"] = 97.13, ["Fly|Ride"] = 225.75, ["Neon"] = 795.29, ["Neon|Ride"] = 523.68, ["Neon|Fly|Ride"] = 568.52, ["Mega"] = 2887.5, ["Mega|Ride"] = 2625, ["Mega|Fly|Ride"] = 3188.74}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 22.3, ["Ride"] = 38.98, ["Fly|Ride"] = 131.25, ["Neon"] = 157.38, ["Neon|Ride"] = 189, ["Neon|Fly|Ride"] = 284.27, ["Mega"] = 1010.23, ["Mega|Ride"] = 731.32, ["Mega|Fly|Ride"] = 731.07}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2034.38, ["Fly"] = 2058.97, ["Ride"] = 2060.63, ["Fly|Ride"] = 2040.94, ["Neon"] = 11356.19, ["Neon|Fly|Ride"] = 7019.25, ["Mega|Fly|Ride"] = 22967.44}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 3.9, ["Fly"] = 65625, ["Ride"] = 57.66, ["Fly|Ride"] = 196.87, ["Neon"] = 14.23, ["Mega"] = 115.31, ["Mega|Fly"] = 786.19, ["Mega|Ride"] = 187.84, ["Mega|Fly|Ride"] = 459.37}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 6.44, ["Ride"] = 41.99, ["Fly|Ride"] = 131.25, ["Neon"] = 19.69, ["Neon|Ride"] = 83.34, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 154.7, ["Mega|Fly"] = 270.39, ["Mega|Ride"] = 143.09, ["Mega|Fly|Ride"] = 197.68}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 826.87, ["Fly"] = 1476.63, ["Ride"] = 824.15, ["Fly|Ride"] = 874.12, ["Neon"] = 2778.57, ["Neon|Ride"] = 2556.74, ["Neon|Fly|Ride"] = 2494.93, ["Mega|Fly|Ride"] = 13768.02}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 25.8, ["Ride"] = 50.68, ["Fly|Ride"] = 173.35, ["Neon"] = 212.94, ["Neon|Ride"] = 180.35, ["Neon|Fly|Ride"] = 369.44, ["Mega"] = 845.66, ["Mega|Ride"] = 722.79, ["Mega|Fly|Ride"] = 835.42}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 2.1, ["Ride"] = 21, ["Fly|Ride"] = 127.98, ["Neon"] = 7.77, ["Neon|Ride"] = 42.6, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 142.65, ["Mega|Ride"] = 322.02, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 142.68, ["Neon"] = 5.2, ["Neon|Ride"] = 27.36, ["Neon|Fly|Ride"] = 104.35, ["Mega"] = 22.87, ["Mega|Ride"] = 61.31, ["Mega|Fly|Ride"] = 157.4}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 98.43, ["Ride"] = 130.69, ["Fly|Ride"] = 170.63, ["Neon"] = 459.38, ["Neon|Ride"] = 433.13, ["Neon|Fly|Ride"] = 634.1, ["Mega"] = 2391.25, ["Mega|Fly|Ride"] = 2128.97}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 2.52, ["Ride"] = 33.67, ["Fly|Ride"] = 74.03, ["Neon"] = 10.49, ["Neon|Ride"] = 47.84, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 109.28, ["Mega|Ride"] = 122.06, ["Mega|Fly|Ride"] = 263.82}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 66.94, ["Fly"] = 113.93, ["Ride"] = 126, ["Fly|Ride"] = 241.68, ["Neon"] = 425.86, ["Neon|Ride"] = 568.52, ["Mega|Fly|Ride"] = 1721.71}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 7.22, ["Fly"] = 105, ["Fly|Ride"] = 127.76, ["Neon"] = 39.16, ["Neon|Fly|Ride"] = 269.06, ["Mega"] = 328.02, ["Mega|Ride"] = 196.88}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 234.81, ["Ride"] = 283.5, ["Fly|Ride"] = 321.57, ["Neon"] = 1137.32, ["Neon|Fly"] = 1036.54, ["Neon|Ride"] = 1064.63, ["Neon|Fly|Ride"] = 879.16, ["Mega|Fly|Ride"] = 3899.56}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 3.94, ["Fly"] = 91.88, ["Ride"] = 20.79, ["Fly|Ride"] = 36.22, ["Neon"] = 20.69, ["Neon|Ride"] = 55.12, ["Neon|Fly|Ride"] = 113.96, ["Mega"] = 319.25, ["Mega|Ride"] = 227.3, ["Mega|Fly|Ride"] = 265.4}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 18.06, ["Ride"] = 15.08, ["Fly|Ride"] = 33.38, ["Neon"] = 3.56, ["Neon|Fly"] = 28.76, ["Neon|Ride"] = 23.62, ["Neon|Fly|Ride"] = 55.13, ["Mega"] = 40.69, ["Mega|Ride"] = 68.25, ["Mega|Fly|Ride"] = 124.71}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 1269.73, ["Ride"] = 1050, ["Fly|Ride"] = 1254.2, ["Neon|Ride"] = 7807.85, ["Neon|Fly|Ride"] = 6600.59, ["Mega"] = 23912.42, ["Mega|Fly|Ride"] = 28487.82}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 8.9, ["Fly"] = 995.78, ["Ride"] = 72.19, ["Neon"] = 87.94, ["Neon|Ride"] = 160.22, ["Mega"] = 252.1, ["Mega|Ride"] = 314.03, ["Mega|Fly|Ride"] = 564.27}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 7.75, ["Fly"] = 39.38, ["Ride"] = 34.34, ["Fly|Ride"] = 124.77, ["Neon"] = 23.61, ["Neon|Fly"] = 101.15, ["Neon|Ride"] = 43.63, ["Neon|Fly|Ride"] = 105, ["Mega"] = 140.84, ["Mega|Ride"] = 264.01, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 34.13, ["Fly"] = 39.37, ["Ride"] = 36.37, ["Fly|Ride"] = 70.6, ["Neon"] = 208.78, ["Neon|Ride"] = 209.9, ["Neon|Fly|Ride"] = 212.62, ["Mega"] = 2554.77, ["Mega|Ride"] = 1116.73, ["Mega|Fly|Ride"] = 799.32}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 13, ["Fly"] = 70.27, ["Ride"] = 28.44, ["Fly|Ride"] = 78.75, ["Neon"] = 58.46, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 129.84, ["Mega"] = 367.5, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 430.29}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 51.19, ["Ride"] = 108.6, ["Fly|Ride"] = 497.19, ["Neon"] = 209.9, ["Neon|Fly"] = 318.33, ["Neon|Ride"] = 276.82, ["Neon|Fly|Ride"] = 412.02, ["Mega"] = 1021.92, ["Mega|Ride"] = 922.92, ["Mega|Fly|Ride"] = 969.75}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 116.61, ["Fly|Ride"] = 284.27, ["Neon"] = 2.63, ["Neon|Fly"] = 57.5, ["Neon|Ride"] = 112.4, ["Neon|Fly|Ride"] = 106.77, ["Mega"] = 16.05, ["Mega|Fly"] = 72.19, ["Mega|Ride"] = 142.65, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 75.59, ["Fly"] = 128.63, ["Ride"] = 118.19, ["Fly|Ride"] = 177.17, ["Neon"] = 425.86, ["Neon|Fly"] = 558.33, ["Neon|Ride"] = 319.3, ["Neon|Fly|Ride"] = 484.4, ["Mega"] = 3406.35, ["Mega|Fly|Ride"] = 1715.15}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.1, ["Fly"] = 107.62, ["Ride"] = 19.44, ["Fly|Ride"] = 66.67, ["Neon"] = 142.68, ["Neon|Ride"] = 95.95, ["Mega"] = 773.07, ["Mega|Ride"] = 433.79, ["Mega|Fly|Ride"] = 490.88}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 28.76, ["Ride"] = 18.27, ["Fly|Ride"] = 38.16, ["Neon"] = 19.22, ["Neon|Fly"] = 80.12, ["Neon|Ride"] = 83.05, ["Neon|Fly|Ride"] = 122.85, ["Mega"] = 104.04, ["Mega|Ride"] = 275.07, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 3.94, ["Ride"] = 126, ["Neon"] = 15.99, ["Neon|Fly"] = 140.54, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 202.29, ["Mega|Fly|Ride"] = 478.27}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 55.99, ["Ride"] = 196.88, ["Fly|Ride"] = 353.77, ["Neon"] = 366.19, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 727.13, ["Mega"] = 1490.29, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1483.13}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 3.51, ["Fly|Ride"] = 425.86, ["Neon"] = 18.8, ["Neon|Ride"] = 59.07, ["Mega"] = 126.88, ["Mega|Ride"] = 160.23, ["Mega|Fly|Ride"] = 281.54}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Fly"] = 21.31, ["Ride"] = 37.04, ["Neon"] = 2.1, ["Neon|Ride"] = 117.17, ["Neon|Fly|Ride"] = 71.35, ["Mega"] = 16.93, ["Mega|Ride"] = 196.24, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 102.92, ["Ride"] = 32.82, ["Fly|Ride"] = 142.86, ["Neon"] = 3.83, ["Neon|Fly"] = 86.2, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 131.23, ["Mega"] = 19.41, ["Mega|Ride"] = 45.94, ["Mega|Fly|Ride"] = 137.17}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 15.99, ["Fly|Ride"] = 52.41, ["Neon"] = 5.28, ["Neon|Ride"] = 24.69, ["Neon|Fly|Ride"] = 48.2, ["Mega"] = 61.69, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 181.55}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 113.93, ["Neon"] = 24.35, ["Neon|Ride"] = 65.63, ["Mega"] = 118.1, ["Mega|Ride"] = 106.3, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 38.07, ["Ride"] = 14.17, ["Fly|Ride"] = 36.74, ["Neon"] = 10.07, ["Neon|Fly"] = 212.94, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 100.09, ["Mega"] = 170.63, ["Mega|Ride"] = 142.9, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 53.81, ["Ride"] = 102.37, ["Fly|Ride"] = 284.27, ["Neon"] = 216.57, ["Neon|Ride"] = 383.27, ["Neon|Fly|Ride"] = 1064.63, ["Mega"] = 741.3, ["Mega|Ride"] = 756.97, ["Mega|Fly|Ride"] = 1116.73}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 16.69, ["Ride"] = 17.07, ["Fly|Ride"] = 42.6, ["Neon"] = 2.63, ["Neon|Fly"] = 20.41, ["Neon|Ride"] = 20.25, ["Neon|Fly|Ride"] = 42.6, ["Mega"] = 51.19, ["Mega|Ride"] = 131.08, ["Mega|Fly|Ride"] = 95.82}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 6.55, ["Fly"] = 30.89, ["Ride"] = 23.84, ["Fly|Ride"] = 68.17, ["Neon"] = 20.76, ["Neon|Fly"] = 91.76, ["Neon|Ride"] = 49.91, ["Neon|Fly|Ride"] = 98.41, ["Mega"] = 301.88, ["Mega|Fly"] = 332.13, ["Mega|Ride"] = 327.92, ["Mega|Fly|Ride"] = 312.36}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 17.43, ["Fly"] = 63.16, ["Ride"] = 38.18, ["Fly|Ride"] = 105, ["Neon"] = 72.18, ["Neon|Fly"] = 147, ["Neon|Ride"] = 115.5, ["Neon|Fly|Ride"] = 210, ["Mega"] = 787.5, ["Mega|Ride"] = 781.35, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 3.6, ["Fly"] = 196.88, ["Neon"] = 74.8, ["Neon|Ride"] = 103.69, ["Mega"] = 472.03, ["Mega|Ride"] = 412.13, ["Mega|Fly|Ride"] = 539.7}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 19.28, ["Ride"] = 15.99, ["Fly|Ride"] = 42, ["Neon"] = 3.94, ["Neon|Fly"] = 28.11, ["Neon|Ride"] = 21.2, ["Neon|Fly|Ride"] = 64.32, ["Mega"] = 40.46, ["Mega|Ride"] = 60.17, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 6.46, ["Fly"] = 39.37, ["Ride"] = 38.07, ["Fly|Ride"] = 57.23, ["Neon"] = 44.54, ["Neon|Ride"] = 127.76, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 241.65, ["Mega|Fly"] = 735, ["Mega|Ride"] = 301.87, ["Mega|Fly|Ride"] = 526.94}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 992.25, ["Fly"] = 1300.29, ["Ride"] = 980.44, ["Fly|Ride"] = 1023.75, ["Neon"] = 3121.44, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2218.12, ["Mega|Fly|Ride"] = 7199.06}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 161.25, ["Ride"] = 223.13, ["Fly|Ride"] = 634.53, ["Neon"] = 656.25, ["Neon|Ride"] = 853.13, ["Neon|Fly|Ride"] = 971.25, ["Mega"] = 3192.39, ["Mega|Ride"] = 3550.05, ["Mega|Fly|Ride"] = 2559.38}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Fly|Ride"] = 392.44, ["Neon"] = 7.05, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 254.45, ["Mega"] = 78.21, ["Mega|Fly|Ride"] = 1135.82}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 65.61, ["Ride"] = 143.89, ["Fly|Ride"] = 315, ["Neon"] = 477.56, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 754.69, ["Mega"] = 1967.44, ["Mega|Ride"] = 1968.75, ["Mega|Fly|Ride"] = 1890}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 2.1, ["Ride"] = 20.64, ["Fly|Ride"] = 98.44, ["Neon"] = 15.1, ["Neon|Fly"] = 56.21, ["Neon|Ride"] = 54.3, ["Neon|Fly|Ride"] = 284.23, ["Mega"] = 118.13, ["Mega|Ride"] = 170.33, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 225.08, ["Fly"] = 425.86, ["Ride"] = 274.32, ["Fly|Ride"] = 363.42, ["Neon"] = 1171.08, ["Neon|Ride"] = 1378.69, ["Neon|Fly|Ride"] = 1463.35, ["Mega|Fly|Ride"] = 4942.7}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 77.18, ["Ride"] = 41.53, ["Fly|Ride"] = 218.34, ["Neon"] = 23.9, ["Neon|Ride"] = 54.37, ["Mega"] = 241.35, ["Mega|Fly"] = 356.62, ["Mega|Ride"] = 425.81}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Fly"] = 28.76, ["Ride"] = 19.18, ["Neon"] = 43.64, ["Mega"] = 164.07, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 17.99, ["Ride"] = 28.76, ["Fly|Ride"] = 151.79, ["Neon"] = 122.07, ["Neon|Fly"] = 425.86, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 286.95, ["Mega"] = 532.25, ["Mega|Ride"] = 590.81, ["Mega|Fly|Ride"] = 893.15}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 49.74, ["Neon"] = 28.76, ["Neon|Ride"] = 196.87, ["Mega"] = 239.14, ["Mega|Ride"] = 254.61, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 15.65, ["Ride"] = 14.37, ["Fly|Ride"] = 32.47, ["Neon"] = 2.1, ["Neon|Fly"] = 28.76, ["Neon|Ride"] = 26.23, ["Neon|Fly|Ride"] = 35.44, ["Mega"] = 23.43, ["Mega|Ride"] = 40.57, ["Mega|Fly|Ride"] = 85.41}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4725, ["Ride"] = 4461.19, ["Fly|Ride"] = 5250, ["Neon"] = 31938.25, ["Neon|Fly|Ride"] = 21150.57, ["Mega|Fly|Ride"] = 52500}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 5.24, ["Fly"] = 85.19, ["Ride"] = 41.99, ["Neon"] = 78.66, ["Neon|Ride"] = 106.32, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 185.26, ["Mega|Ride"] = 213.45, ["Mega|Fly|Ride"] = 411.97}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 24.95, ["Ride"] = 20.34, ["Fly|Ride"] = 46.86, ["Neon"] = 11.33, ["Neon|Fly"] = 42.6, ["Neon|Ride"] = 30.18, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 131.25, ["Mega|Ride"] = 126.83, ["Mega|Fly|Ride"] = 198.33}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 427.88, ["Fly"] = 547.77, ["Ride"] = 459.38, ["Fly|Ride"] = 544.4, ["Neon"] = 2099.99, ["Neon|Ride"] = 1292.82, ["Neon|Fly|Ride"] = 1358.49, ["Mega|Fly|Ride"] = 4873.32}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 3.44, ["Ride"] = 41.15, ["Neon"] = 13.85, ["Neon|Ride"] = 291.38, ["Mega"] = 143.88, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 693}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 2.1, ["Fly"] = 4257.39, ["Ride"] = 36.21, ["Neon"] = 31.95, ["Neon|Fly"] = 118.19, ["Neon|Ride"] = 64.58, ["Neon|Fly|Ride"] = 305.55, ["Mega"] = 424.75, ["Mega|Ride"] = 284.67, ["Mega|Fly|Ride"] = 497.13}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 50.96, ["Ride"] = 23.63, ["Fly|Ride"] = 65.62, ["Neon"] = 5.15, ["Neon|Fly"] = 124.69, ["Neon|Ride"] = 28.75, ["Neon|Fly|Ride"] = 91.74, ["Mega"] = 39.03, ["Mega|Ride"] = 55.52, ["Mega|Fly|Ride"] = 130.95}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 611.02, ["Ride"] = 611.1, ["Fly|Ride"] = 654.92, ["Neon|Ride"] = 2126.27, ["Neon|Fly|Ride"] = 2135.44, ["Mega|Fly|Ride"] = 9225.88}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 8.44, ["Fly"] = 210, ["Ride"] = 65.54, ["Neon"] = 32.46, ["Neon|Fly"] = 113.93, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 194.91, ["Mega|Ride"] = 229.04, ["Mega|Fly|Ride"] = 424.01}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 3.77, ["Fly"] = 236.25, ["Ride"] = 45.21, ["Fly|Ride"] = 76.67, ["Neon"] = 23.63, ["Neon|Ride"] = 60.1, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 157.38, ["Mega|Fly"] = 797.49, ["Mega|Ride"] = 162.75, ["Mega|Fly|Ride"] = 272.88}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 34.13, ["Ride"] = 14.99, ["Fly|Ride"] = 43.31, ["Neon"] = 18, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 32.18, ["Neon|Fly|Ride"] = 82.58, ["Mega"] = 284.23, ["Mega|Ride"] = 153.3, ["Mega|Fly|Ride"] = 194.25}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 19.67, ["Fly"] = 26.25, ["Ride"] = 38.07, ["Fly|Ride"] = 58.53, ["Neon"] = 117.59, ["Mega"] = 850.54, ["Mega|Ride"] = 472.49, ["Mega|Fly|Ride"] = 549.29}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Ride"] = 43.31, ["Neon"] = 3.94, ["Neon|Ride"] = 140.54, ["Neon|Fly|Ride"] = 106.47, ["Mega"] = 28.22, ["Mega|Fly"] = 127.75, ["Mega|Ride"] = 64.68, ["Mega|Fly|Ride"] = 206.53}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 590.63, ["Fly"] = 683.49, ["Ride"] = 576.06, ["Fly|Ride"] = 630, ["Neon"] = 2589.57, ["Neon|Fly|Ride"] = 2100, ["Mega|Ride"] = 9325.86, ["Mega|Fly|Ride"] = 7861.88}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 95.62, ["Neon"] = 17.94, ["Neon|Ride"] = 85.19, ["Neon|Fly|Ride"] = 445.03, ["Mega"] = 70.88, ["Mega|Ride"] = 306.38, ["Mega|Fly|Ride"] = 324.03}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 52.4, ["Neon"] = 3.68, ["Neon|Fly"] = 241.68, ["Neon|Ride"] = 215.21, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 41.96, ["Mega|Ride"] = 136.32, ["Mega|Fly|Ride"] = 284.23}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 59.77, ["Neon"] = 3.52, ["Neon|Ride"] = 56.15, ["Neon|Fly|Ride"] = 142.65, ["Mega"] = 35.44, ["Mega|Fly"] = 157.57, ["Mega|Ride"] = 124.76, ["Mega|Fly|Ride"] = 170.33}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 13.13, ["Neon|Ride"] = 48.18, ["Mega"] = 212.91, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 24.01, ["Fly"] = 72.19, ["Ride"] = 41.36, ["Fly|Ride"] = 210.33, ["Neon"] = 131.25, ["Neon|Fly"] = 212.94, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 511.88, ["Mega|Ride"] = 437.06, ["Mega|Fly|Ride"] = 556.36}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 11.46, ["Fly"] = 64.55, ["Ride"] = 78.75, ["Fly|Ride"] = 143.18, ["Neon"] = 77.97, ["Neon|Ride"] = 126.68, ["Neon|Fly|Ride"] = 281.74, ["Mega"] = 479.55, ["Mega|Ride"] = 423.69, ["Mega|Fly|Ride"] = 550.04}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.63, ["Fly"] = 32.7, ["Ride"] = 14.33, ["Fly|Ride"] = 33.86, ["Neon"] = 28.87, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 88.37, ["Mega"] = 298.6, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 319.36}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 7.74, ["Ride"] = 56.6, ["Fly|Ride"] = 134.15, ["Neon"] = 38.05, ["Neon|Ride"] = 142.68}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Ride"] = 26.16, ["Fly|Ride"] = 100.09, ["Neon"] = 7.19, ["Neon|Ride"] = 50.05, ["Neon|Fly|Ride"] = 121.37, ["Mega"] = 69.56, ["Mega|Ride"] = 115.5, ["Mega|Fly|Ride"] = 255.49}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 21, ["Fly"] = 112.35, ["Ride"] = 30.18, ["Fly|Ride"] = 57.5, ["Neon"] = 109.15, ["Neon|Ride"] = 142.68, ["Neon|Fly|Ride"] = 319.23, ["Mega"] = 787.5, ["Mega|Fly|Ride"] = 749.44}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 29.53, ["Fly"] = 874.13, ["Neon"] = 98.44, ["Mega"] = 332.06, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 499.42}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 36.02, ["Fly"] = 114.75, ["Ride"] = 59.06, ["Fly|Ride"] = 124.08, ["Neon"] = 324.83, ["Neon|Ride"] = 304.5, ["Neon|Fly|Ride"] = 415.8, ["Mega|Ride"] = 1753.99, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 32.81, ["Fly"] = 85.52, ["Ride"] = 52.49, ["Fly|Ride"] = 210, ["Neon"] = 118.13, ["Neon|Ride"] = 142.92, ["Neon|Fly|Ride"] = 291.38, ["Mega"] = 590.63, ["Mega|Ride"] = 638.71, ["Mega|Fly|Ride"] = 632}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 19.69, ["Ride"] = 57.5, ["Neon"] = 114.27, ["Neon|Ride"] = 223.12, ["Mega"] = 1050, ["Mega|Ride"] = 797.49, ["Mega|Fly|Ride"] = 803.7}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 17.07, ["Fly"] = 81.73, ["Ride"] = 62.89, ["Fly|Ride"] = 193.78, ["Neon"] = 137.81, ["Neon|Fly"] = 255.51, ["Neon|Ride"] = 214.3, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 585.3, ["Mega|Ride"] = 601.17, ["Mega|Fly|Ride"] = 659.99}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 17.95, ["Ride"] = 15.51, ["Fly|Ride"] = 32.74, ["Neon"] = 3.62, ["Neon|Fly"] = 27.64, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 54.31, ["Mega"] = 41.91, ["Mega|Fly"] = 319.25, ["Mega|Ride"] = 57.7, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 866.24}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 64.95, ["Fly"] = 478.06, ["Ride"] = 110.4, ["Fly|Ride"] = 314.08, ["Neon"] = 379.32, ["Neon|Ride"] = 458.07, ["Neon|Fly|Ride"] = 505.7, ["Mega"] = 1561.61, ["Mega|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 1351.88}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 79.76, ["Neon"] = 3.34, ["Neon|Fly"] = 100.09, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 298.54, ["Mega"] = 25.86, ["Mega|Ride"] = 84.96, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 23.63, ["Ride"] = 80.07, ["Fly|Ride"] = 142.68, ["Neon"] = 84, ["Neon|Ride"] = 133.76, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 591.93, ["Mega|Ride"] = 510.46, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 2.51, ["Neon|Fly|Ride"] = 113.93, ["Mega"] = 25.61, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Ride"] = 74.82, ["Neon"] = 3.71, ["Mega"] = 20.78, ["Mega|Ride"] = 150.67, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 87.92, ["Fly"] = 223.13, ["Ride"] = 141.03, ["Fly|Ride"] = 334.14, ["Neon"] = 433.13, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 668.59, ["Mega|Ride"] = 2697.41, ["Mega|Fly|Ride"] = 2098.69}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 90.57, ["Ride"] = 21.53, ["Fly|Ride"] = 95.62, ["Neon"] = 7.8, ["Neon|Fly"] = 42.6, ["Neon|Ride"] = 32.25, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 91.25, ["Mega|Ride"] = 116.93, ["Mega|Fly|Ride"] = 284.23}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 38.07, ["Fly|Ride"] = 55.13, ["Neon"] = 5.15, ["Neon|Fly"] = 42.6, ["Neon|Ride"] = 51.19, ["Neon|Fly|Ride"] = 419.9, ["Mega"] = 32.76, ["Mega|Ride"] = 128.26, ["Mega|Fly|Ride"] = 217.87}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 6.39, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 236.15, ["Mega"] = 110.38, ["Mega|Ride"] = 163.13, ["Mega|Fly|Ride"] = 539.7}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 90.3, ["Neon"] = 3.59, ["Neon|Ride"] = 156.19, ["Mega"] = 90.45, ["Mega|Fly"] = 195.88, ["Mega|Ride"] = 334.79, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 71.6, ["Ride"] = 160.13, ["Fly|Ride"] = 355.6, ["Neon"] = 428.35, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 2413.2, ["Mega|Ride"] = 2271.69, ["Mega|Fly|Ride"] = 2171.55}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 4.73, ["Ride"] = 80.79, ["Neon"] = 90.8, ["Neon|Ride"] = 77.43, ["Mega"] = 413.86, ["Mega|Ride"] = 366.19, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 393.75, ["Ride"] = 422.63, ["Fly|Ride"] = 710.11, ["Neon"] = 1774.5, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 1102.5, ["Mega|Fly|Ride"] = 3346.87}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 94.5}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 50.93}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 15.75}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 10.5}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 143.09}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 116.8}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 14.16}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 7.33}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 110.97}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 14.86}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 35.15}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 18.36}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 6.16}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 839.99}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 5.03}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 6.17}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 7.88}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 3.94}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 15.33}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 590.63}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 619.64}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 5.62}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1403.62}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 52.39}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 6.57}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 34.29}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 17.07}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 45.45}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 52.14}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 17.07}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 15.33}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 19.48}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 4.46}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 18.64}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 3.94}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.24}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 20.99}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 14.34}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 6.11}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 3052.24}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 44.7}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 311.84}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 6.36}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 13.01}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 45.94}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 213.86}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 7.63}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 12.92}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 144.38}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 24.94}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 7.22}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 25.1}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 11.31}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 99.75}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 27.57}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 7.34}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 19.68}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 6.46}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 7.88}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 26.25}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 78.75}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 236.24}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 5.24}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 7.64}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 18.38}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 24.94}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 61.69}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 19.5}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 23792.29}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 72.19}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 57.74}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 37.7}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 26.17}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 44.63}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 24.94}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 31.97}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 85.89}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 81.38}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 18.38}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 85.31}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 393.75}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 65.58}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 41.48}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 214.27}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 8.68}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 6.24}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 4.28}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 5.79}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 25.99}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 117.39}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.1}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 2.1}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 3.92}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 11.8}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 183.75}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 1136.38}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 8.31}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 589.11}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 6.34}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.1}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 231}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 27.53}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 99.59}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 15.94}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 29.16}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 60.39}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 14.21}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 8.53}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 7.75}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 3.28}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 3.68}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 5.54}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 32.68}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 2.1}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 2.1}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 3.5}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 16.27}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 146.98}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 51.54}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.63}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.1}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 212.94}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 15.73}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 9.19}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 7.58}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 26.25}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 7.76}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 3.67}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 8.93}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 3.93}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 5.97}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 27.77}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 12.44}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 5.75}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 2.1}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 5.78}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 6.36}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 11.78}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 2.27}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 5.39}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 3.4}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 3.19}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 6.3}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 9381.75}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 11.97}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 3.42}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 4.03}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 52.5}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 4.28}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 7.55}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 3.94}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 5.25}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 40.17}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 6.45}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 3.41}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 2.47}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 3.12}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4116.86}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 6.35}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 34.55}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.3}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 3.24}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 59.22}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 5.25}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 105}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 15.22}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.1}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 4.8}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 10.4}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 24.94}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.15}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 6.36}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 3.94}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 5.04}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 3.94}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 19.17}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 5.39}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 11.71}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 122.12}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 79.71}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 9.1}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1214.06}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 52.49}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 5.25}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 26.17}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 24.65}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 4.98}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 7.87}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 13.9}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 26.24}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 12.58}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 2.1}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 3.38}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 10.47}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 3.13}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 20.89}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 22.32}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 2.63}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 7.88}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 58.75}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 3.94}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 136.5}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 91.86}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 10.75}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 2.52}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 21.95}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.63}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 212.16}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 5.25}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 6.07}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 4.9}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 79.79}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 162.62}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 10.17}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1199.27}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.56}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 196.88}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 6.09}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 5.2}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 59.31}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 6.34}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 3.53}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 106.47}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 17.05}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 17.35}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 5.53}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 45.94}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 5.66}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 49.86}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.52}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 4.27}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 36.64}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 129.45}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 83.15}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 8.05}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 57.61}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 62.89}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 48.56}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 131.25}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 59.42}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 6.57}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 127.93}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.63}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.63}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 31.49}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 57.41}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 61.69}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 7.86}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 3.27}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 8.66}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 13.01}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 75.27}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 57.66}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 14.59}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 32.71}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 23.38}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 12.48}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 78.74}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 47.14}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 22.32}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1994.98}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 6.41}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 6.4}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 19.68}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 319.24}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 15.75}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 7.87}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 6.36}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 7.55}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 6.56}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 318.93}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 57.5}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 40.66}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 4.72}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 55.85}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 194.91}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 77.41}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 918.75}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 150.94}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 7.88}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 1727.25}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 551.24}},
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