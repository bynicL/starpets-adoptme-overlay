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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 1048.69, ["Ride"] = 1049.99, ["Fly|Ride"] = 1423.1, ["Neon"] = 6779.58, ["Neon|Fly|Ride"] = 5690.19}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 433.12, ["Fly"] = 646.84, ["Ride"] = 506.54, ["Fly|Ride"] = 544.69, ["Neon"] = 2106.89, ["Neon|Fly|Ride"] = 1706.25, ["Mega"] = 12081.28, ["Mega|Fly|Ride"] = 7237.63}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 6015.43, ["Ride"] = 5250, ["Fly|Ride"] = 5118.75, ["Neon|Fly|Ride"] = 24604.1, ["Mega|Fly|Ride"] = 70957.34}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 149.63, ["Ride"] = 170.68, ["Fly|Ride"] = 213.38, ["Neon"] = 1053.98, ["Neon|Ride"] = 979.13, ["Neon|Fly|Ride"] = 984.38, ["Mega|Fly|Ride"] = 4495.32}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 548.63, ["Fly"] = 853.34, ["Ride"] = 531.76, ["Fly|Ride"] = 565.11, ["Neon|Fly|Ride"] = 1745.63, ["Mega|Fly|Ride"] = 7450.5}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 8.11, ["Ride"] = 57.69, ["Fly|Ride"] = 129.94, ["Neon"] = 72.19, ["Neon|Ride"] = 59.89, ["Neon|Fly|Ride"] = 404.25, ["Mega"] = 354.38, ["Mega|Ride"] = 356.61, ["Mega|Fly|Ride"] = 425.76}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 3.68, ["Fly"] = 36.66, ["Ride"] = 26.17, ["Fly|Ride"] = 64.05, ["Neon"] = 31.24, ["Neon|Fly"] = 186.46, ["Neon|Ride"] = 56.8, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 185.73, ["Mega|Ride"] = 204.37, ["Mega|Fly|Ride"] = 298.04}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 116.94, ["Fly"] = 213.35, ["Ride"] = 185.07, ["Fly|Ride"] = 235.77, ["Neon"] = 565.59, ["Neon|Ride"] = 492.19, ["Neon|Fly|Ride"] = 672.08, ["Mega"] = 1586.82, ["Mega|Ride"] = 2492.44, ["Mega|Fly|Ride"] = 2774.79}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 34.85, ["Fly"] = 81.17, ["Ride"] = 41.55, ["Fly|Ride"] = 104.55, ["Neon"] = 257.62, ["Neon|Ride"] = 199.5, ["Neon|Fly|Ride"] = 294, ["Mega"] = 1419.86, ["Mega|Ride"] = 1128.41, ["Mega|Fly|Ride"] = 918.73}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 23.62, ["Fly"] = 57.62, ["Ride"] = 27.44, ["Fly|Ride"] = 68.25, ["Neon"] = 210.67, ["Neon|Ride"] = 122.69, ["Neon|Fly|Ride"] = 187.77, ["Mega|Ride"] = 484.71, ["Mega|Fly|Ride"] = 779.13}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 54.48, ["Fly"] = 128.02, ["Ride"] = 72.1, ["Fly|Ride"] = 162.74, ["Neon"] = 341.84, ["Neon|Ride"] = 318.98, ["Neon|Fly|Ride"] = 425.25, ["Mega|Ride"] = 1135.68, ["Mega|Fly|Ride"] = 1277.25}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 70.25}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 334.85, ["Fly"] = 399, ["Ride"] = 326.81, ["Fly|Ride"] = 380.63, ["Neon"] = 1271.62, ["Neon|Ride"] = 1048.69, ["Neon|Fly|Ride"] = 1174.69, ["Mega|Fly|Ride"] = 5107.86}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 114.19, ["Fly"] = 128.06, ["Ride"] = 135.05, ["Fly|Ride"] = 170.52, ["Neon|Fly"] = 629.55, ["Neon|Ride"] = 573.03, ["Neon|Fly|Ride"] = 642.02, ["Mega"] = 4312.63, ["Mega|Fly|Ride"] = 2467.5}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.1, ["Fly"] = 34.13, ["Ride"] = 57.5, ["Fly|Ride"] = 131.25, ["Neon"] = 23.46, ["Neon|Ride"] = 56.35, ["Neon|Fly|Ride"] = 202.73, ["Mega"] = 150.94, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 253.72}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 183.75, ["Fly"] = 262.5, ["Ride"] = 216.56, ["Fly|Ride"] = 196.88, ["Neon|Ride"] = 960.11, ["Neon|Fly|Ride"] = 692.9, ["Mega|Fly|Ride"] = 3149.9}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 2.62, ["Fly"] = 25.85, ["Ride"] = 15.7, ["Fly|Ride"] = 40.56, ["Neon"] = 24.23, ["Neon|Fly"] = 128.03, ["Neon|Ride"] = 53.36, ["Neon|Fly|Ride"] = 109.94, ["Mega"] = 207.57, ["Mega|Ride"] = 322.59, ["Mega|Fly|Ride"] = 422.63}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 83.06, ["Fly"] = 162.32, ["Ride"] = 126, ["Fly|Ride"] = 244.12, ["Neon"] = 275.63, ["Neon|Ride"] = 357, ["Neon|Fly|Ride"] = 482.93, ["Mega"] = 1703.79, ["Mega|Ride"] = 1421.12, ["Mega|Fly|Ride"] = 1394.01}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 40.09}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 76.12, ["Ride"] = 135.14, ["Fly|Ride"] = 242.23, ["Neon"] = 577.5, ["Neon|Fly|Ride"] = 783.02, ["Mega"] = 2128.72, ["Mega|Fly|Ride"] = 1838.16}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 19.68, ["Fly"] = 55.49, ["Ride"] = 32.6, ["Fly|Ride"] = 355.69, ["Neon"] = 321.57, ["Neon|Ride"] = 209.99, ["Neon|Fly|Ride"] = 429.19, ["Mega"] = 2778.7, ["Mega|Ride"] = 709.93, ["Mega|Fly|Ride"] = 709.93}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 38.74, ["Fly"] = 57.5, ["Ride"] = 51.96, ["Fly|Ride"] = 103.67, ["Neon"] = 307.51, ["Neon|Ride"] = 170.7, ["Neon|Fly|Ride"] = 239.72, ["Mega"] = 1691.39, ["Mega|Ride"] = 1021.79, ["Mega|Fly|Ride"] = 941.99}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 39.57, ["Ride"] = 111.56, ["Fly|Ride"] = 196.88, ["Neon"] = 142.96, ["Neon|Ride"] = 384.58, ["Neon|Fly|Ride"] = 467.25, ["Mega"] = 1289.09, ["Mega|Ride"] = 1702.98, ["Mega|Fly|Ride"] = 1468.83}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 37.56, ["Ride"] = 33.42, ["Fly|Ride"] = 83.91, ["Neon"] = 120.75, ["Neon|Ride"] = 212.3, ["Neon|Fly|Ride"] = 254.63, ["Mega"] = 1207.92, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 39.04, ["Fly"] = 138.68, ["Ride"] = 57.74, ["Fly|Ride"] = 179.24, ["Neon"] = 157.9, ["Neon|Fly"] = 235.77, ["Neon|Ride"] = 213.08, ["Neon|Fly|Ride"] = 262.49, ["Mega|Ride"] = 3193.08, ["Mega|Fly|Ride"] = 1010.63}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 3.94, ["Fly"] = 28.34, ["Ride"] = 20.67, ["Fly|Ride"] = 45.94, ["Neon"] = 36.74, ["Neon|Fly"] = 80.07, ["Neon|Ride"] = 54.42, ["Neon|Fly|Ride"] = 91.86, ["Mega"] = 170.63, ["Mega|Fly"] = 24426.34, ["Mega|Ride"] = 182.44, ["Mega|Fly|Ride"] = 249.6}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 393.75, ["Ride"] = 482.03, ["Fly|Ride"] = 391.13, ["Neon|Ride"] = 1689.18, ["Neon|Fly|Ride"] = 1964.82, ["Mega"] = 10643.55, ["Mega|Fly|Ride"] = 9181.79}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 10.31, ["Ride"] = 27.46, ["Fly|Ride"] = 65.63, ["Neon"] = 216.99, ["Neon|Ride"] = 129.94, ["Mega|Ride"] = 808.92, ["Mega|Fly|Ride"] = 671.66}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 5.8, ["Fly"] = 37.67, ["Ride"] = 20.93, ["Fly|Ride"] = 46.65, ["Neon"] = 52.5, ["Neon|Ride"] = 74.83, ["Neon|Fly|Ride"] = 124.72, ["Mega|Ride"] = 315.93, ["Mega|Fly|Ride"] = 534.19}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 84.95, ["Fly"] = 113.88, ["Ride"] = 100.29, ["Fly|Ride"] = 108.94, ["Neon"] = 294.96, ["Neon|Ride"] = 356.32, ["Neon|Fly|Ride"] = 399, ["Mega"] = 6401.89, ["Mega|Ride"] = 2416.26, ["Mega|Fly|Ride"] = 2100}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 11.5, ["Ride"] = 32.34, ["Fly|Ride"] = 75.95, ["Neon"] = 99.38, ["Neon|Ride"] = 106.7, ["Neon|Fly|Ride"] = 131.15, ["Mega"] = 710.01, ["Mega|Ride"] = 724.89}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 204.05, ["Fly"] = 262.5, ["Ride"] = 204.75, ["Fly|Ride"] = 295.32, ["Neon"] = 745.69, ["Neon|Ride"] = 803.25, ["Neon|Fly|Ride"] = 733.81, ["Mega"] = 3263.33, ["Mega|Ride"] = 2763.52, ["Mega|Fly|Ride"] = 2933.6}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 23.36}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.59, ["Fly"] = 32.81, ["Ride"] = 24.94, ["Fly|Ride"] = 55.68, ["Neon"] = 26.16, ["Neon|Fly"] = 142.96, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 105, ["Mega"] = 141.41, ["Mega|Fly"] = 212.89, ["Mega|Ride"] = 138.29, ["Mega|Fly|Ride"] = 288.74}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 826.87, ["Fly"] = 2625, ["Ride"] = 908.25, ["Fly|Ride"] = 938.44, ["Neon"] = 6399.59, ["Neon|Ride"] = 4836.77, ["Neon|Fly|Ride"] = 4769.27, ["Mega|Ride"] = 54365.76, ["Mega|Fly|Ride"] = 17045.44}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 12.5, ["Fly"] = 32.99, ["Ride"] = 40.13, ["Fly|Ride"] = 91.59, ["Neon"] = 157.9, ["Neon|Ride"] = 151.5, ["Neon|Fly|Ride"] = 181.13, ["Mega"] = 1009.32, ["Mega|Ride"] = 1089.92, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 183.75, ["Fly"] = 363.4, ["Ride"] = 256.04, ["Fly|Ride"] = 284.85, ["Neon"] = 830.82, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 1030.31, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 3899.56}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 38.06}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 14.44, ["Fly"] = 127.73, ["Ride"] = 42.69, ["Fly|Ride"] = 142.96, ["Neon"] = 90.81, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 341.38, ["Mega"] = 355.51, ["Mega|Ride"] = 566.19, ["Mega|Fly|Ride"] = 598.03}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 84.46, ["Ride"] = 144.23, ["Fly|Ride"] = 272.05, ["Neon"] = 484.26, ["Neon|Ride"] = 420, ["Neon|Fly|Ride"] = 516.33, ["Mega"] = 2128.72, ["Mega|Ride"] = 2251.96, ["Mega|Fly|Ride"] = 2001.93}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 103.3, ["Fly"] = 157.49, ["Ride"] = 115.5, ["Fly|Ride"] = 262.5, ["Neon"] = 387.09, ["Neon|Fly"] = 569.67, ["Neon|Ride"] = 434.78, ["Neon|Fly|Ride"] = 493.5, ["Mega|Ride"] = 1378.13, ["Mega|Fly|Ride"] = 1240.32}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 41.51}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 56.44, ["Fly"] = 93.49, ["Ride"] = 53.13, ["Fly|Ride"] = 64.2, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 308.44, ["Mega"] = 4257.44, ["Mega|Fly|Ride"] = 1246.77}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 3.94, ["Fly"] = 98.44, ["Ride"] = 26.25, ["Fly|Ride"] = 206.54, ["Neon"] = 37.35, ["Neon|Fly"] = 223.13, ["Neon|Ride"] = 102.92, ["Neon|Fly|Ride"] = 240.03, ["Mega"] = 170.62, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 274.62, ["Mega|Fly|Ride"] = 381.94}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 570.73, ["Fly"] = 617.61, ["Ride"] = 479.01, ["Fly|Ride"] = 528.94, ["Neon|Fly"] = 3840.4, ["Neon|Ride"] = 1846.49, ["Neon|Fly|Ride"] = 1754.88, ["Mega|Ride"] = 14900.99, ["Mega|Fly|Ride"] = 7481.25}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 90.44, ["Fly"] = 157.88, ["Ride"] = 129.6, ["Fly|Ride"] = 168.7, ["Neon"] = 479.07, ["Neon|Ride"] = 556.5, ["Neon|Fly|Ride"] = 525, ["Mega|Ride"] = 2554.47, ["Mega|Fly|Ride"] = 2567.24}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 4039.58, ["Ride"] = 3885, ["Fly|Ride"] = 3907.61, ["Neon|Fly|Ride"] = 14933.79}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 55.09, ["Fly"] = 121.71, ["Ride"] = 57.51, ["Fly|Ride"] = 137.82, ["Neon"] = 442.73, ["Neon|Ride"] = 314.14, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 1913.72, ["Mega|Ride"] = 1269.19, ["Mega|Fly|Ride"] = 1647.19}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 72.19, ["Ride"] = 65.63, ["Fly|Ride"] = 142.43, ["Neon"] = 575.75, ["Neon|Ride"] = 427.88, ["Neon|Fly|Ride"] = 356.32, ["Mega"] = 6244.59, ["Mega|Ride"] = 2388.75, ["Mega|Fly|Ride"] = 1901.87}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 31.55, ["Fly"] = 57.62, ["Ride"] = 39.37, ["Fly|Ride"] = 85.32, ["Neon"] = 130.09, ["Neon|Fly"] = 290.57, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 189.91, ["Mega"] = 2625, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 6.41}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 45.83, ["Fly"] = 393.75, ["Ride"] = 43.63, ["Fly|Ride"] = 81.15, ["Neon|Ride"] = 284.85, ["Neon|Fly|Ride"] = 425.76, ["Mega|Ride"] = 1289.09, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 36.66}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 185.07, ["Ride"] = 233.89, ["Fly|Ride"] = 282.19, ["Neon|Ride"] = 1107.32, ["Neon|Fly|Ride"] = 1109.46, ["Mega|Fly|Ride"] = 4589.51}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 635.23, ["Ride"] = 635.38, ["Fly|Ride"] = 723.19, ["Neon"] = 2625, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 10220.25}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 7.84}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 24.94, ["Fly"] = 47.25, ["Ride"] = 35.34, ["Fly|Ride"] = 70.79, ["Neon"] = 226.41, ["Neon|Ride"] = 142.96, ["Neon|Fly|Ride"] = 220.48, ["Mega"] = 2128.72, ["Mega|Ride"] = 1160.1, ["Mega|Fly|Ride"] = 761.24}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 18.9}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5250, ["Ride"] = 5650.32, ["Fly|Ride"] = 4528.13, ["Neon|Ride"] = 17757.64, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 43492.61}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 8.7, ["Fly"] = 55.11, ["Ride"] = 20.99, ["Fly|Ride"] = 55.86, ["Neon"] = 85.36, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 221.82, ["Mega"] = 462.72, ["Mega|Ride"] = 490.88, ["Mega|Fly|Ride"] = 617.79}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 13.02, ["Fly"] = 139.89, ["Ride"] = 30.18, ["Neon"] = 71.49, ["Neon|Ride"] = 122.07, ["Neon|Fly|Ride"] = 105, ["Mega"] = 744, ["Mega|Ride"] = 841.92, ["Mega|Fly|Ride"] = 994.12}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 48.46, ["Ride"] = 56.44, ["Fly|Ride"] = 91.75, ["Neon|Ride"] = 395.79, ["Neon|Fly|Ride"] = 480.96, ["Mega"] = 4257.44, ["Mega|Fly|Ride"] = 1772.34}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 7.69, ["Fly"] = 71.48, ["Ride"] = 26.16, ["Fly|Ride"] = 61.69, ["Neon"] = 69.39, ["Neon|Ride"] = 128.37, ["Neon|Fly|Ride"] = 162.24, ["Mega"] = 1419.86, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 813.75}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1765.83, ["Fly"] = 1640.63, ["Ride"] = 1640.62, ["Fly|Ride"] = 1679.99, ["Neon|Fly|Ride"] = 3150, ["Mega|Fly|Ride"] = 12468.75}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 27300, ["Fly"] = 34132.7, ["Ride"] = 52500, ["Fly|Ride"] = 27300, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 56895.36, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 183748.69}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 20.9, ["Fly"] = 393.75, ["Ride"] = 55.13, ["Fly|Ride"] = 125.89, ["Neon"] = 284.85, ["Neon|Ride"] = 208.69, ["Neon|Fly|Ride"] = 568.38, ["Mega"] = 994.12, ["Mega|Ride"] = 1141.88, ["Mega|Fly|Ride"] = 1386.94}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 2.1, ["Fly"] = 63, ["Ride"] = 32.82, ["Fly|Ride"] = 158.81, ["Neon"] = 21.35, ["Neon|Fly"] = 57.62, ["Neon|Ride"] = 58.7, ["Neon|Fly|Ride"] = 157.49, ["Mega"] = 129.94, ["Mega|Fly"] = 308.1, ["Mega|Ride"] = 178.5, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 23.45}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 6.04, ["Ride"] = 38.07, ["Fly|Ride"] = 105, ["Neon"] = 58.46, ["Neon|Ride"] = 106.7, ["Neon|Fly|Ride"] = 212.89, ["Mega"] = 425.76, ["Mega|Ride"] = 422.56, ["Mega|Fly|Ride"] = 689.72}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 643.13, ["Fly"] = 807.93, ["Ride"] = 678.4, ["Fly|Ride"] = 778.52, ["Neon"] = 2773.62, ["Neon|Ride"] = 2816.29, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 10085.25}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 787.29, ["Fly"] = 996.26, ["Ride"] = 947.81, ["Fly|Ride"] = 984.38, ["Neon"] = 4125.22, ["Neon|Ride"] = 3270.99, ["Neon|Fly|Ride"] = 3675, ["Mega|Fly|Ride"] = 11765.39}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 12.55, ["Fly"] = 121.14, ["Ride"] = 29.97, ["Fly|Ride"] = 72.18, ["Neon"] = 78.75, ["Neon|Ride"] = 100.91, ["Neon|Fly|Ride"] = 161.21, ["Mega"] = 1209.72, ["Mega|Ride"] = 469.4, ["Mega|Fly|Ride"] = 559.86}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 23.35}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 66.94, ["Fly"] = 89.25, ["Ride"] = 85.29, ["Fly|Ride"] = 114.15, ["Neon"] = 599.28, ["Neon|Ride"] = 490.73, ["Neon|Fly|Ride"] = 420, ["Mega"] = 19687.5, ["Mega|Ride"] = 2084.02, ["Mega|Fly|Ride"] = 2107.88}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 78.74, ["Ride"] = 89.12, ["Fly|Ride"] = 213.38, ["Neon"] = 450.19, ["Neon|Ride"] = 386.78, ["Neon|Fly|Ride"] = 553.77, ["Mega"] = 1411.85, ["Mega|Ride"] = 1702.98, ["Mega|Fly|Ride"] = 1933.02}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 3.93, ["Fly"] = 28.37, ["Ride"] = 15.75, ["Fly|Ride"] = 42.69, ["Neon"] = 42.69, ["Neon|Fly"] = 524.98, ["Neon|Ride"] = 68.3, ["Neon|Fly|Ride"] = 162.24, ["Mega"] = 261.19, ["Mega|Fly|Ride"] = 660.86}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 131.25, ["Fly"] = 154.88, ["Ride"] = 157.48, ["Fly|Ride"] = 199.5, ["Neon"] = 606.71, ["Neon|Ride"] = 550.46, ["Neon|Fly|Ride"] = 551.25, ["Mega"] = 5108.92, ["Mega|Fly|Ride"] = 2493.75}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 3.68, ["Ride"] = 47.55, ["Fly|Ride"] = 113.86, ["Neon"] = 30.96, ["Neon|Fly"] = 170.7, ["Neon|Ride"] = 142.96, ["Neon|Fly|Ride"] = 398.64, ["Mega"] = 191.63, ["Mega|Fly"] = 338.48, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 418.95}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 11.46, ["Fly"] = 39.04, ["Ride"] = 32.72, ["Fly|Ride"] = 81, ["Neon"] = 128.63, ["Neon|Fly"] = 162.24, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 667.37, ["Mega|Ride"] = 823.82, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 36.75, ["Ride"] = 62.91, ["Fly|Ride"] = 156.19, ["Neon"] = 210.67, ["Neon|Ride"] = 223.13, ["Mega"] = 918.75, ["Mega|Ride"] = 1161.57, ["Mega|Fly|Ride"] = 638.64}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 14.99, ["Fly"] = 213.35, ["Ride"] = 36.32, ["Fly|Ride"] = 47.16, ["Neon"] = 91.88, ["Neon|Ride"] = 116.94, ["Neon|Fly|Ride"] = 284.2, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6300, ["Ride"] = 6555.94, ["Fly|Ride"] = 5643.75, ["Neon"] = 35559.87, ["Neon|Ride"] = 28447.69, ["Neon|Fly|Ride"] = 25598.33}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 223.13, ["Fly"] = 195.19, ["Ride"] = 222.99, ["Fly|Ride"] = 282.18, ["Neon"] = 655.02, ["Neon|Ride"] = 726.39, ["Neon|Fly|Ride"] = 558.6, ["Mega|Fly|Ride"] = 1968.73}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 48.47, ["Fly"] = 131.25, ["Ride"] = 94.47, ["Fly|Ride"] = 211.23, ["Neon"] = 142.96, ["Neon|Fly"] = 290.57, ["Neon|Ride"] = 162.31, ["Neon|Fly|Ride"] = 308.44, ["Mega"] = 459.15, ["Mega|Fly"] = 459.38, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 581.53}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 89.65, ["Ride"] = 18.38, ["Fly|Ride"] = 52.49, ["Neon"] = 24.95, ["Neon|Fly"] = 70.42, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 499.8, ["Mega|Ride"] = 330.75, ["Mega|Fly|Ride"] = 356.57}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 62.91, ["Fly"] = 182.41, ["Ride"] = 96.02, ["Fly|Ride"] = 142.96, ["Neon"] = 241.5, ["Neon|Ride"] = 258.58, ["Neon|Fly|Ride"] = 383.25, ["Mega"] = 554.11, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 692.24}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 14384.99, ["Ride"] = 13415.07, ["Fly|Ride"] = 12783.75, ["Neon|Fly|Ride"] = 27562.5, ["Mega|Fly|Ride"] = 113531.52}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 223.13, ["Ride"] = 328, ["Fly|Ride"] = 459.38, ["Neon"] = 1523, ["Neon|Ride"] = 1423.1, ["Neon|Fly|Ride"] = 1575, ["Mega|Fly|Ride"] = 7248.77}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 49.75, ["Fly"] = 80.59, ["Ride"] = 52.4, ["Fly|Ride"] = 95.82, ["Neon"] = 405.39, ["Neon|Ride"] = 328.11, ["Neon|Fly|Ride"] = 287.74, ["Mega|Fly|Ride"] = 3086.65}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 10.18, ["Fly"] = 28.82, ["Ride"] = 19.69, ["Fly|Ride"] = 65.42, ["Neon"] = 67.47, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 155.92, ["Mega"] = 393.75, ["Mega|Ride"] = 398.09, ["Mega|Fly|Ride"] = 636.49}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 367.4, ["Fly"] = 853.34, ["Ride"] = 433, ["Fly|Ride"] = 483.38, ["Neon"] = 1677.45, ["Neon|Ride"] = 1376.75, ["Neon|Fly|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 5108.92}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 3.94, ["Fly"] = 105.61, ["Ride"] = 32.81, ["Fly|Ride"] = 185.27, ["Neon"] = 34.44, ["Neon|Ride"] = 85.41, ["Neon|Fly|Ride"] = 137.81, ["Mega"] = 142.66, ["Mega|Fly"] = 263.92, ["Mega|Ride"] = 212.89, ["Mega|Fly|Ride"] = 532.19}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 101.74, ["Fly"] = 164.07, ["Ride"] = 131.24, ["Fly|Ride"] = 170.63, ["Neon"] = 385.81, ["Neon|Fly"] = 525, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 514.99, ["Mega|Ride"] = 1788.13, ["Mega|Fly|Ride"] = 2128.72}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 12.29, ["Fly"] = 18.15, ["Ride"] = 18.04, ["Fly|Ride"] = 32.7, ["Neon"] = 162.24, ["Neon|Fly"] = 80.64, ["Neon|Ride"] = 196.86, ["Neon|Fly|Ride"] = 78.71, ["Mega"] = 2554.47, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 8.45}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 65.62, ["Fly"] = 142.94, ["Ride"] = 85.22, ["Fly|Ride"] = 213.38, ["Neon"] = 359.63, ["Neon|Fly"] = 425.65, ["Neon|Ride"] = 406.87, ["Neon|Fly|Ride"] = 430.5, ["Mega"] = 1563.34, ["Mega|Ride"] = 1575, ["Mega|Fly|Ride"] = 1845.6}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 14.69, ["Fly"] = 78.94, ["Ride"] = 31.2, ["Fly|Ride"] = 65.44, ["Neon"] = 98.44, ["Neon|Ride"] = 116.94, ["Neon|Fly|Ride"] = 185.63, ["Mega"] = 645.16, ["Mega|Ride"] = 568.38, ["Mega|Fly|Ride"] = 576.19}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 30.98}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 47.25, ["Fly"] = 142.94, ["Ride"] = 101.07, ["Fly|Ride"] = 284.82, ["Neon"] = 284.85, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 426.72, ["Mega|Ride"] = 1611.66, ["Mega|Fly|Ride"] = 1660.41}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.92, ["Ride"] = 29.22, ["Fly|Ride"] = 136.57, ["Neon"] = 23.84, ["Neon|Ride"] = 113.81, ["Neon|Fly|Ride"] = 186.71, ["Mega"] = 144.38, ["Mega|Ride"] = 213.42, ["Mega|Fly|Ride"] = 425.76}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 10.76, ["Fly"] = 56.44, ["Ride"] = 32.02, ["Fly|Ride"] = 85.32, ["Neon"] = 162.24, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 190.97, ["Mega|Ride"] = 425.76, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 431.82, ["Fly"] = 533.34, ["Ride"] = 505.32, ["Fly|Ride"] = 541.66, ["Neon|Fly|Ride"] = 5690.19, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 38.77, ["Fly"] = 106.68, ["Ride"] = 57.65, ["Fly|Ride"] = 89.13, ["Neon"] = 103.69, ["Neon|Ride"] = 213.1, ["Neon|Fly|Ride"] = 290.57, ["Mega"] = 776.43, ["Mega|Ride"] = 437.07, ["Mega|Fly|Ride"] = 723.77}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 49.03, ["Fly"] = 142.54, ["Ride"] = 52.5, ["Fly|Ride"] = 122.69, ["Neon"] = 244.64, ["Neon|Ride"] = 185.63, ["Neon|Fly|Ride"] = 322.88, ["Mega|Fly|Ride"] = 948.35}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 20.22, ["Fly"] = 73.27, ["Ride"] = 71.8, ["Fly|Ride"] = 103.69, ["Neon"] = 98.44, ["Neon|Ride"] = 142.95, ["Neon|Fly|Ride"] = 258.57, ["Mega"] = 433.02, ["Mega|Fly"] = 525, ["Mega|Ride"] = 369.35, ["Mega|Fly|Ride"] = 593.93}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 10500, ["Ride"] = 8862, ["Fly|Ride"] = 8201.81, ["Neon|Fly|Ride"] = 14700, ["Mega|Fly|Ride"] = 38850}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1380.53, ["Fly"] = 1486.7, ["Ride"] = 1246.88, ["Fly|Ride"] = 1397.82, ["Neon|Fly|Ride"] = 4725, ["Mega|Fly|Ride"] = 16320.84}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 668.81, ["Ride"] = 569.6, ["Fly|Ride"] = 597.41, ["Neon"] = 2253.58, ["Neon|Fly|Ride"] = 3200.34, ["Mega"] = 21287.1, ["Mega|Fly|Ride"] = 9551.53}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 10.71, ["Fly"] = 23.21, ["Ride"] = 18.26, ["Fly|Ride"] = 35.43, ["Neon"] = 64.02, ["Neon|Ride"] = 90.27, ["Neon|Fly|Ride"] = 125.81, ["Mega|Fly|Ride"] = 572.25}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 3.87, ["Fly"] = 78.74, ["Ride"] = 32.34, ["Fly|Ride"] = 157.5, ["Neon"] = 28.5, ["Neon|Ride"] = 55.13, ["Mega"] = 160.13, ["Mega|Ride"] = 198.19, ["Mega|Fly|Ride"] = 266.44}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 31.47, ["Fly"] = 45.94, ["Ride"] = 41.67, ["Fly|Ride"] = 98.43, ["Neon"] = 202.55, ["Neon|Ride"] = 150.92, ["Neon|Fly|Ride"] = 183.64, ["Mega|Ride"] = 745.06, ["Mega|Fly|Ride"] = 666.75}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 2.1, ["Fly"] = 22.42, ["Ride"] = 15.65, ["Fly|Ride"] = 37.59, ["Neon"] = 23.63, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 96.15, ["Mega"] = 288.75, ["Mega|Ride"] = 457.86, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 288.25, ["Fly"] = 369.5, ["Ride"] = 279.26, ["Fly|Ride"] = 354.37, ["Neon"] = 1615.01, ["Neon|Ride"] = 1333.48, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 3690.12}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 17.74, ["Fly"] = 60.58, ["Ride"] = 30.96, ["Fly|Ride"] = 85.36, ["Neon"] = 131.25, ["Neon|Fly"] = 426.72, ["Neon|Ride"] = 141.7, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 667.37, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 696.11}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 9.41, ["Fly"] = 21, ["Ride"] = 19.09, ["Fly|Ride"] = 34.12, ["Neon"] = 83.22, ["Neon|Fly"] = 121.63, ["Neon|Ride"] = 70.83, ["Neon|Fly|Ride"] = 104.21, ["Mega"] = 1575, ["Mega|Ride"] = 608.92, ["Mega|Fly|Ride"] = 423.94}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 569.6, ["Fly"] = 1048.69, ["Ride"] = 540.75, ["Fly|Ride"] = 420, ["Neon|Fly|Ride"] = 3557.7, ["Mega|Fly|Ride"] = 9971.07}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1076.15, ["Ride"] = 1181.25, ["Fly|Ride"] = 1296.78, ["Neon"] = 4978.65, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 12489.15}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 142.94, ["Fly"] = 139.74, ["Ride"] = 91.87, ["Fly|Ride"] = 97.13, ["Neon"] = 588.88, ["Neon|Ride"] = 586.74, ["Neon|Fly|Ride"] = 459.38, ["Mega|Fly|Ride"] = 2540.63}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 162.75, ["Fly"] = 212.13, ["Ride"] = 156.45, ["Fly|Ride"] = 248.56, ["Neon"] = 558.21, ["Neon|Ride"] = 774.83, ["Neon|Fly|Ride"] = 648.54, ["Mega|Ride"] = 9187.5, ["Mega|Fly|Ride"] = 2929.5}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 31.4, ["Fly"] = 57.62, ["Ride"] = 34.02, ["Fly|Ride"] = 114.13, ["Neon"] = 236.24, ["Neon|Ride"] = 238.13, ["Mega|Ride"] = 1419.86, ["Mega|Fly|Ride"] = 1077.15}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 242.15, ["Ride"] = 315, ["Fly|Ride"] = 412.85, ["Neon"] = 1220.63, ["Neon|Fly"] = 968.52, ["Neon|Fly|Ride"] = 1138.26, ["Mega"] = 5677.29, ["Mega|Fly|Ride"] = 5677.29}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2422.54, ["Fly"] = 3069.35, ["Ride"] = 1673.44, ["Fly|Ride"] = 1837.48, ["Neon|Fly|Ride"] = 10667.75, ["Mega|Fly|Ride"] = 32217.17}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 45.85, ["Fly"] = 213.35, ["Ride"] = 45.84, ["Fly|Ride"] = 196.88, ["Neon"] = 288.75, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 268.85, ["Mega"] = 1419.86, ["Mega|Ride"] = 1135.68, ["Mega|Fly|Ride"] = 1154.99}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 570.94, ["Fly"] = 590.63, ["Ride"] = 576.18, ["Fly|Ride"] = 646.85, ["Neon|Ride"] = 1498.88, ["Neon|Fly|Ride"] = 1155, ["Mega|Fly|Ride"] = 3222.09}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 45.92, ["Fly"] = 59.06, ["Ride"] = 54.45, ["Fly|Ride"] = 74.04, ["Neon"] = 262.5, ["Neon|Ride"] = 237.29, ["Neon|Fly|Ride"] = 234.94, ["Mega|Fly|Ride"] = 1081.29}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.42, ["Fly"] = 35.35, ["Ride"] = 17.52, ["Fly|Ride"] = 55.04, ["Neon"] = 25.99, ["Neon|Fly"] = 120.75, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 170.62, ["Mega|Fly"] = 249.38, ["Mega|Ride"] = 185.1, ["Mega|Fly|Ride"] = 302.75}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 56.49, ["Ride"] = 128.34, ["Fly|Ride"] = 157.5, ["Neon"] = 262.4, ["Neon|Ride"] = 430.17, ["Neon|Fly|Ride"] = 711.56, ["Mega"] = 1556.1, ["Mega|Ride"] = 1553.97}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 787.5, ["Fly"] = 1092, ["Ride"] = 826.88, ["Fly|Ride"] = 909.03, ["Neon|Ride"] = 3254.99, ["Neon|Fly|Ride"] = 2957.66, ["Mega|Fly|Ride"] = 12404}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 645.75, ["Ride"] = 525, ["Fly|Ride"] = 810.76, ["Neon|Fly|Ride"] = 4257.51, ["Mega|Fly|Ride"] = 15467.22}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 12.78, ["Fly"] = 21, ["Ride"] = 20.28, ["Fly|Ride"] = 45.93, ["Neon"] = 144.38, ["Neon|Ride"] = 96.38, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 781.25, ["Mega|Ride"] = 568.38, ["Mega|Fly|Ride"] = 722.52}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 11.42, ["Ride"] = 27.55, ["Fly|Ride"] = 91.75, ["Neon"] = 165.26, ["Neon|Ride"] = 76.19, ["Neon|Fly|Ride"] = 210, ["Mega"] = 833.44, ["Mega|Ride"] = 693.97, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 5.8, ["Fly"] = 64.72, ["Ride"] = 19.59, ["Fly|Ride"] = 111.57, ["Neon"] = 21.94, ["Neon|Fly"] = 321.61, ["Neon|Ride"] = 69.02, ["Neon|Fly|Ride"] = 204.75, ["Mega"] = 163.03, ["Mega|Fly"] = 548.5, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 355.6}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 28.82, ["Fly"] = 51.18, ["Ride"] = 47.35, ["Fly|Ride"] = 92.98, ["Neon"] = 295.98, ["Neon|Ride"] = 220.5, ["Neon|Fly|Ride"] = 223.13, ["Mega|Ride"] = 952.02, ["Mega|Fly|Ride"] = 956.71}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 71.48, ["Ride"] = 131.24, ["Fly|Ride"] = 356.32, ["Neon"] = 437.07, ["Neon|Ride"] = 568.32, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 2271.35, ["Mega|Ride"] = 2128.72, ["Mega|Fly|Ride"] = 2113.82}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 12.76, ["Fly"] = 49.16, ["Ride"] = 35.22, ["Fly|Ride"] = 87.22, ["Neon"] = 106.32, ["Neon|Fly"] = 114.15, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 151.73, ["Mega"] = 476.85, ["Mega|Ride"] = 362.25, ["Mega|Fly|Ride"] = 461.29}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 28.66, ["Fly"] = 61.88, ["Ride"] = 41.91, ["Fly|Ride"] = 86.94, ["Neon"] = 242.82, ["Neon|Fly"] = 1423.1, ["Neon|Ride"] = 166.52, ["Neon|Fly|Ride"] = 228.38, ["Mega"] = 2100, ["Mega|Ride"] = 1195.86, ["Mega|Fly|Ride"] = 1241.59}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.68, ["Fly"] = 15.94, ["Ride"] = 16.7, ["Fly|Ride"] = 34.16, ["Neon"] = 23.54, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 745.06, ["Mega|Ride"] = 483.27, ["Mega|Fly|Ride"] = 425.76}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 5.8, ["Fly"] = 47.37, ["Ride"] = 41.91, ["Fly|Ride"] = 66.93, ["Neon"] = 39.38, ["Neon|Fly"] = 110.96, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 125.89, ["Mega"] = 416.06, ["Mega|Ride"] = 355.51, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 65.42, ["Fly"] = 56.79, ["Ride"] = 53.81, ["Fly|Ride"] = 97.09, ["Neon"] = 342.42, ["Neon|Fly"] = 211.3, ["Neon|Ride"] = 213.38, ["Neon|Fly|Ride"] = 241.19, ["Mega|Fly|Ride"] = 1074.91}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1384.69, ["Fly"] = 1410.93, ["Ride"] = 1324.87, ["Fly|Ride"] = 1364.99, ["Neon|Fly|Ride"] = 3790.5, ["Mega|Fly|Ride"] = 11550}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 462, ["Fly"] = 524.99, ["Ride"] = 420, ["Fly|Ride"] = 478.96, ["Neon|Ride"] = 2845.1, ["Neon|Fly|Ride"] = 2362.5, ["Mega"] = 14900.99, ["Mega|Fly|Ride"] = 8940.16}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 258.57, ["Fly"] = 378.23, ["Ride"] = 236.25, ["Fly|Ride"] = 454.47, ["Neon"] = 1249.5, ["Neon|Ride"] = 1557.5, ["Neon|Fly|Ride"] = 1640.63}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 40.03}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 24.86, ["Ride"] = 45.34, ["Fly|Ride"] = 97.13, ["Neon"] = 325.5, ["Neon|Ride"] = 207.38, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 1561.43, ["Mega|Fly|Ride"] = 1036.54}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 70875, ["Fly"] = 23466.23, ["Ride"] = 36332.45, ["Fly|Ride"] = 16945.67, ["Neon|Fly|Ride"] = 37800, ["Mega"] = 212870.9, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 223.12, ["Fly"] = 262.5, ["Ride"] = 232.31, ["Fly|Ride"] = 284.85, ["Neon"] = 1039.98, ["Neon|Fly"] = 853.13, ["Neon|Ride"] = 783.02, ["Neon|Fly|Ride"] = 721.88, ["Mega"] = 6386.14, ["Mega|Ride"] = 4256.38, ["Mega|Fly|Ride"] = 3476.66}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 216.46, ["Fly"] = 525, ["Ride"] = 213.42, ["Fly|Ride"] = 257.23, ["Neon|Fly|Ride"] = 1776.03}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 128.16, ["Fly"] = 142.94, ["Ride"] = 150.94, ["Fly|Ride"] = 215.87, ["Neon|Ride"] = 524.99, ["Neon|Fly|Ride"] = 616.88, ["Mega|Fly|Ride"] = 3086.65}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 16.22, ["Fly"] = 65.63, ["Ride"] = 30.97, ["Fly|Ride"] = 52.5, ["Neon"] = 142.96, ["Neon|Ride"] = 106.7, ["Neon|Fly|Ride"] = 711.56, ["Mega"] = 722.48, ["Mega|Ride"] = 709.93, ["Mega|Fly|Ride"] = 931.33}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 4541.25, ["Ride"] = 3937.5, ["Fly|Ride"] = 4003.13, ["Neon"] = 27736.15, ["Neon|Fly|Ride"] = 15750}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 27.14, ["Fly"] = 45.94, ["Ride"] = 28.22, ["Fly|Ride"] = 51.89, ["Neon"] = 131.25, ["Neon|Ride"] = 150.59, ["Neon|Fly|Ride"] = 199.5, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 47.25, ["Ride"] = 41.91, ["Fly|Ride"] = 81.15, ["Neon"] = 314.26, ["Neon|Fly"] = 1423.1, ["Neon|Ride"] = 200.57, ["Neon|Fly|Ride"] = 262.48, ["Mega|Fly|Ride"] = 1374.19}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 406.88, ["Fly"] = 557.43, ["Ride"] = 431.41, ["Fly|Ride"] = 556.5, ["Neon"] = 1299.38, ["Neon|Ride"] = 1181.12, ["Neon|Fly|Ride"] = 1220.1, ["Mega|Fly|Ride"] = 6462.29}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 16.2, ["Fly"] = 22.89, ["Ride"] = 22.22, ["Fly|Ride"] = 45.94, ["Neon"] = 123.38, ["Neon|Fly"] = 161.11, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 141.74, ["Mega|Ride"] = 781.25, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 11.03, ["Ride"] = 26.24, ["Fly|Ride"] = 65.63, ["Neon"] = 98.43, ["Neon|Ride"] = 60.51, ["Neon|Fly|Ride"] = 209.08, ["Mega|Ride"] = 572.66, ["Mega|Fly|Ride"] = 724.89}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 108.94, ["Ride"] = 103.69, ["Fly|Ride"] = 226.17, ["Neon"] = 1010.63, ["Neon|Ride"] = 637.79, ["Neon|Fly|Ride"] = 1135.68, ["Mega|Fly|Ride"] = 2739.19}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 15.49, ["Fly"] = 71.48, ["Ride"] = 65.61, ["Fly|Ride"] = 163.08, ["Neon"] = 45.93, ["Neon|Ride"] = 91.83, ["Neon|Fly|Ride"] = 236.23, ["Mega"] = 210, ["Mega|Fly"] = 423.94, ["Mega|Ride"] = 301.87, ["Mega|Fly|Ride"] = 442.38}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3930.83, ["Fly"] = 6298.59, ["Ride"] = 3883.68, ["Fly|Ride"] = 3936.19, ["Neon"] = 14934.85, ["Neon|Ride"] = 12337.5, ["Neon|Fly|Ride"] = 10328.07, ["Mega"] = 42573.13, ["Mega|Fly|Ride"] = 37945.69}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 34.15, ["Fly"] = 42.69, ["Ride"] = 70.22, ["Fly|Ride"] = 157.5, ["Neon"] = 233.62, ["Neon|Ride"] = 258.56, ["Neon|Fly|Ride"] = 399.52, ["Mega"] = 851.5, ["Mega|Ride"] = 1772.34, ["Mega|Fly|Ride"] = 782.24}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 7875, ["Fly"] = 7679.86, ["Ride"] = 6857.82, ["Fly|Ride"] = 6167.44, ["Neon|Fly|Ride"] = 14437.5, ["Mega|Fly|Ride"] = 46921.88}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 3.6, ["Fly"] = 17.88, ["Ride"] = 15.75, ["Fly|Ride"] = 32.82, ["Neon"] = 24.61, ["Neon|Fly"] = 57.62, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 89.25, ["Mega"] = 233.1, ["Mega|Ride"] = 372.75, ["Mega|Fly|Ride"] = 248.07}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 15.4, ["Fly"] = 21, ["Ride"] = 32.45, ["Fly|Ride"] = 42, ["Neon"] = 142.96, ["Neon|Fly"] = 235.77, ["Neon|Ride"] = 142.96, ["Neon|Fly|Ride"] = 166.32, ["Mega|Ride"] = 991.6, ["Mega|Fly|Ride"] = 935.82}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.84}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 10.67, ["Ride"] = 26.59, ["Fly|Ride"] = 57.66, ["Neon"] = 98.44, ["Neon|Ride"] = 95.57, ["Mega"] = 1049.9, ["Mega|Ride"] = 894.08, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 20.98, ["Fly"] = 190.37, ["Ride"] = 42, ["Fly|Ride"] = 99.74, ["Neon"] = 203.44, ["Neon|Ride"] = 181.6, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 945, ["Mega|Ride"] = 851.5, ["Mega|Fly|Ride"] = 1099.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 14.41, ["Fly"] = 25.64, ["Ride"] = 17.07, ["Fly|Ride"] = 38.42, ["Neon|Fly"] = 1063.59, ["Neon|Ride"] = 118.43, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 2554.47, ["Mega|Fly|Ride"] = 531.57}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8676.11}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2624.99}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 21.86}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 236.04, ["Ride"] = 213.38, ["Fly|Ride"] = 262.49, ["Mega|Fly|Ride"] = 4200}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 12.55, ["Fly"] = 134.25, ["Ride"] = 32.82, ["Fly|Ride"] = 123.77, ["Neon"] = 100.29, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 265.13, ["Mega"] = 525, ["Mega|Ride"] = 532.8, ["Mega|Fly|Ride"] = 1179.94}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 11.16}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 2.63, ["Ride"] = 25.99, ["Fly|Ride"] = 85.36, ["Neon|Ride"] = 249.38, ["Mega"] = 1561.43}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2357.25}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 123.05, ["Fly"] = 339.21, ["Ride"] = 215.25, ["Fly|Ride"] = 426.72, ["Neon"] = 918.75, ["Neon|Ride"] = 852.37, ["Neon|Fly|Ride"] = 1564.98, ["Mega|Ride"] = 4115.87, ["Mega|Fly|Ride"] = 3936.45}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 66.61, ["Ride"] = 91.88, ["Fly|Ride"] = 242.23, ["Neon"] = 664.61, ["Neon|Ride"] = 494.82, ["Neon|Fly|Ride"] = 939.84, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 157.45, ["Fly"] = 196.88, ["Ride"] = 142.94, ["Fly|Ride"] = 230.6, ["Neon"] = 944.98, ["Neon|Ride"] = 787.49, ["Neon|Fly|Ride"] = 840, ["Mega|Ride"] = 3274.16, ["Mega|Fly|Ride"] = 3119.76}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 2388.74, ["Fly"] = 3271.42, ["Ride"] = 2428.13, ["Fly|Ride"] = 2270.63, ["Neon"] = 14983.92, ["Neon|Ride"] = 8474.47, ["Neon|Fly|Ride"] = 5906.25, ["Mega|Fly|Ride"] = 25593.75}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 15.65, ["Fly"] = 71.48, ["Ride"] = 37.37, ["Fly|Ride"] = 100.08, ["Neon"] = 121.07, ["Neon|Fly"] = 162.24, ["Neon|Ride"] = 154.62, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 956.87, ["Mega|Ride"] = 994.12, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 787.5, ["Fly"] = 2100, ["Ride"] = 882.14, ["Fly|Ride"] = 774.38, ["Neon|Fly|Ride"] = 4188.6}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 41.99}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 15.17, ["Ride"] = 52.11, ["Fly|Ride"] = 341.54, ["Neon"] = 94.5, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 106.5, ["Neon|Fly|Ride"] = 256.04, ["Mega"] = 466.19, ["Mega|Fly"] = 966.52, ["Mega|Ride"] = 483.23, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 5.59, ["Fly"] = 48.46, ["Ride"] = 27.45, ["Fly|Ride"] = 105.45, ["Neon"] = 38.07, ["Neon|Fly"] = 315, ["Neon|Ride"] = 61.89, ["Neon|Fly|Ride"] = 178.5, ["Mega"] = 451.85, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 569.63}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 60.2}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 20.91, ["Fly"] = 106.75, ["Ride"] = 21.3, ["Fly|Ride"] = 65.63, ["Neon|Ride"] = 193.72, ["Neon|Fly|Ride"] = 254.62, ["Mega|Ride"] = 994.12, ["Mega|Fly|Ride"] = 2128.72}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 28.82, ["Fly"] = 39.38, ["Ride"] = 34.58, ["Fly|Ride"] = 70.88, ["Neon|Fly"] = 235.77, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 211.82, ["Mega"] = 1449.77, ["Mega|Ride"] = 1812.2, ["Mega|Fly|Ride"] = 989.63}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6562.5, ["Fly"] = 10237.5, ["Ride"] = 6297.64, ["Fly|Ride"] = 5053.13, ["Neon|Fly|Ride"] = 9450, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 7.87, ["Fly"] = 65.62, ["Ride"] = 34.13, ["Fly|Ride"] = 81.37, ["Neon"] = 52.5, ["Neon|Ride"] = 64.84, ["Neon|Fly|Ride"] = 169.63, ["Mega"] = 510.9, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 526.86}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 19.57}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 91.88, ["Fly"] = 377.61, ["Ride"] = 118.13, ["Fly|Ride"] = 140.44, ["Neon"] = 531.57, ["Neon|Ride"] = 407.84, ["Neon|Fly|Ride"] = 596.81, ["Mega"] = 2879.59, ["Mega|Ride"] = 1764.77, ["Mega|Fly|Ride"] = 2114.88}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 52, ["Fly"] = 142.63, ["Ride"] = 74.73, ["Fly|Ride"] = 183.5, ["Neon"] = 291.38, ["Neon|Ride"] = 283.77, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 2416.26, ["Mega|Ride"] = 2873.77, ["Mega|Fly|Ride"] = 1028.99}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 18.38, ["Fly"] = 49.08, ["Ride"] = 26.24, ["Fly|Ride"] = 65, ["Neon"] = 128.77, ["Neon|Fly"] = 230.44, ["Neon|Ride"] = 143.75, ["Neon|Fly|Ride"] = 203.44, ["Mega"] = 1016.21, ["Mega|Ride"] = 869.87, ["Mega|Fly|Ride"] = 784.88}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 4.99, ["Fly"] = 68.95, ["Ride"] = 21.83, ["Fly|Ride"] = 63.96, ["Neon"] = 31.5, ["Neon|Fly"] = 72.19, ["Neon|Ride"] = 71.22, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 160.12, ["Mega|Fly"] = 284.95, ["Mega|Ride"] = 210.3, ["Mega|Fly|Ride"] = 285.05}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 11.22, ["Ride"] = 24.23, ["Fly|Ride"] = 98.06, ["Neon"] = 91.58, ["Neon|Ride"] = 97.17, ["Neon|Fly|Ride"] = 142.64, ["Mega|Ride"] = 383.18, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 20.99, ["Fly"] = 32.72, ["Ride"] = 24.53, ["Fly|Ride"] = 51.19, ["Neon"] = 370.18, ["Neon|Fly"] = 144.38, ["Neon|Ride"] = 128.62, ["Neon|Fly|Ride"] = 142.91, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 207.38}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 17.09, ["Ride"] = 131.23, ["Fly|Ride"] = 157.9, ["Neon"] = 199.5, ["Neon|Ride"] = 221.9, ["Neon|Fly|Ride"] = 426.54, ["Mega"] = 696.11, ["Mega|Fly|Ride"] = 678.57}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 167.27, ["Ride"] = 695.63, ["Neon|Ride"] = 17068.41, ["Neon|Fly|Ride"] = 28447.69}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 45.94, ["Fly"] = 212.94, ["Ride"] = 86.51, ["Fly|Ride"] = 148.31, ["Neon"] = 252, ["Neon|Ride"] = 341.38, ["Neon|Fly|Ride"] = 463, ["Mega"] = 851.9, ["Mega|Ride"] = 1047.46, ["Mega|Fly|Ride"] = 1265.66}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 1010.52, ["Fly"] = 1316.25, ["Ride"] = 1019.81, ["Fly|Ride"] = 1008.58, ["Neon|Fly"] = 4391, ["Neon|Ride"] = 4284.46, ["Neon|Fly|Ride"] = 3274.69, ["Mega|Fly|Ride"] = 12337.5}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 346.5, ["Fly"] = 646.84, ["Ride"] = 377.6, ["Fly|Ride"] = 422.18, ["Neon"] = 2133.56, ["Neon|Ride"] = 1909.69, ["Neon|Fly|Ride"] = 1995, ["Mega"] = 12081.28, ["Mega|Fly|Ride"] = 9186.19}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 55.12}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.62}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 8.81, ["Fly"] = 24, ["Ride"] = 27.65, ["Fly|Ride"] = 36.28, ["Neon"] = 78.75, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 84.29, ["Neon|Fly|Ride"] = 118.12, ["Mega"] = 437.26, ["Mega|Ride"] = 709.93, ["Mega|Fly|Ride"] = 548.16}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 248.97, ["Fly"] = 406.65, ["Ride"] = 280.73, ["Fly|Ride"] = 326.7, ["Neon"] = 1172.39, ["Neon|Ride"] = 954.19, ["Neon|Fly|Ride"] = 840, ["Mega|Fly|Ride"] = 2800.89}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 12.83}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 93.89, ["Fly"] = 170.68, ["Ride"] = 157.9, ["Fly|Ride"] = 234.94, ["Neon"] = 569.67, ["Neon|Fly"] = 610.32, ["Neon|Ride"] = 446.25, ["Neon|Fly|Ride"] = 485.63, ["Mega"] = 2231.43, ["Mega|Ride"] = 1968.75, ["Mega|Fly|Ride"] = 1914.84}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 123.22, ["Fly"] = 213.35, ["Ride"] = 129.55, ["Fly|Ride"] = 143.89, ["Neon"] = 1138.26, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 913.5, ["Mega|Fly|Ride"] = 2554.47}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 3.69, ["Ride"] = 24.75, ["Fly|Ride"] = 52.5, ["Neon"] = 39.37, ["Neon|Ride"] = 57.62, ["Neon|Fly|Ride"] = 242.18, ["Mega"] = 180.18, ["Mega|Ride"] = 189.84, ["Mega|Fly|Ride"] = 483.27}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 9.7, ["Fly"] = 71.54, ["Ride"] = 25.76, ["Fly|Ride"] = 78.64, ["Neon"] = 142.96, ["Neon|Ride"] = 149.37, ["Neon|Fly|Ride"] = 319.48, ["Mega|Ride"] = 1419.86, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 12.39, ["Fly"] = 102.36, ["Ride"] = 28.88, ["Fly|Ride"] = 104.89, ["Neon"] = 85.2, ["Neon|Ride"] = 67.22, ["Neon|Fly|Ride"] = 260.31, ["Mega"] = 423.63, ["Mega|Ride"] = 519.75, ["Mega|Fly|Ride"] = 539.64}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 3.94, ["Fly"] = 98.44, ["Ride"] = 31.73, ["Fly|Ride"] = 135.35, ["Neon"] = 22.19, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 149.03, ["Mega"] = 131.15, ["Mega|Fly"] = 274.25, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 236.25, ["Ride"] = 262.5, ["Fly|Ride"] = 380.3, ["Neon"] = 1593.78, ["Neon|Ride"] = 1377.72, ["Neon|Fly|Ride"] = 1424.07, ["Mega|Fly|Ride"] = 5647.47}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 72.1, ["Fly"] = 149.35, ["Ride"] = 128.03, ["Fly|Ride"] = 241.5, ["Neon"] = 429.17, ["Neon|Ride"] = 485.63, ["Neon|Fly|Ride"] = 569.67, ["Mega"] = 2271.29, ["Mega|Ride"] = 1903.13, ["Mega|Fly|Ride"] = 1893.62}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 61.01, ["Fly"] = 94.5, ["Ride"] = 72.19, ["Fly|Ride"] = 126, ["Neon"] = 380.63, ["Neon|Ride"] = 265.29, ["Neon|Fly|Ride"] = 411.9, ["Mega|Ride"] = 1646.57, ["Mega|Fly|Ride"] = 1800.94}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 11.86, ["Fly"] = 126, ["Ride"] = 28.82, ["Fly|Ride"] = 284.85, ["Neon"] = 170.7, ["Neon|Ride"] = 615.01, ["Neon|Fly|Ride"] = 498.2, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 11.73, ["Fly"] = 75.63, ["Ride"] = 27.57, ["Fly|Ride"] = 67.67, ["Neon"] = 77.43, ["Neon|Ride"] = 68.25, ["Neon|Fly|Ride"] = 157.49, ["Mega"] = 378.99, ["Mega|Fly"] = 525, ["Mega|Ride"] = 383.18, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.46, ["Fly"] = 52.5, ["Ride"] = 19.59, ["Fly|Ride"] = 57.48, ["Neon"] = 23.63, ["Neon|Fly"] = 68.3, ["Neon|Ride"] = 38.06, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 131.25, ["Mega|Ride"] = 170.38, ["Mega|Fly|Ride"] = 235.37}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 787.49, ["Fly"] = 1050.18, ["Ride"] = 846.55, ["Fly|Ride"] = 914.81, ["Neon"] = 4267.11, ["Neon|Fly"] = 3286.89, ["Neon|Ride"] = 8534.21, ["Neon|Fly|Ride"] = 2833.57, ["Mega|Fly|Ride"] = 8098.23}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 318.94, ["Fly"] = 711.46, ["Ride"] = 288.75, ["Fly|Ride"] = 523.21, ["Neon"] = 1210.64, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1273.13, ["Mega"] = 10643.55, ["Mega|Fly|Ride"] = 7096.06}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 89.44, ["Fly"] = 134.42, ["Ride"] = 108.48, ["Fly|Ride"] = 162.65, ["Neon"] = 347.79, ["Neon|Fly"] = 484.26, ["Neon|Ride"] = 326.32, ["Neon|Fly|Ride"] = 320.04, ["Mega"] = 1312.5, ["Mega|Ride"] = 1590.17, ["Mega|Fly|Ride"] = 1638.06}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 206.95, ["Fly"] = 283.5, ["Ride"] = 219.19, ["Fly|Ride"] = 242.18, ["Neon|Ride"] = 1291.77, ["Neon|Fly|Ride"] = 917.44, ["Mega"] = 10643.55, ["Mega|Fly|Ride"] = 4188.24}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 23.63, ["Fly"] = 32.82, ["Ride"] = 24.54, ["Fly|Ride"] = 76.13, ["Neon"] = 169.32, ["Neon|Ride"] = 185.63, ["Neon|Fly|Ride"] = 204.75, ["Mega|Ride"] = 570.08, ["Mega|Fly|Ride"] = 881.3}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 190.29, ["Ride"] = 222.01, ["Fly|Ride"] = 358.32, ["Neon"] = 1537.89, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 971.25, ["Mega"] = 4186.88, ["Mega|Fly|Ride"] = 3796.57}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 96.05, ["Fly"] = 125.98, ["Ride"] = 80.06, ["Fly|Ride"] = 106.46, ["Neon|Ride"] = 569.67, ["Neon|Fly|Ride"] = 426.72, ["Mega|Fly|Ride"] = 1548.75}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 2021.25, ["Ride"] = 2034.38, ["Fly|Ride"] = 2034.38, ["Neon|Ride"] = 11300.09, ["Neon|Fly|Ride"] = 7084.46, ["Mega"] = 51089.04, ["Mega|Fly|Ride"] = 24162.56}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 6.57, ["Fly"] = 78.02, ["Ride"] = 37.34, ["Fly|Ride"] = 99.47, ["Neon"] = 48.45, ["Neon|Fly"] = 235.77, ["Neon|Ride"] = 105.71, ["Neon|Fly|Ride"] = 213.38, ["Mega"] = 288.74, ["Mega|Fly"] = 568.38, ["Mega|Ride"] = 307.13, ["Mega|Fly|Ride"] = 392.34}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 58.97, ["Fly"] = 93.89, ["Ride"] = 83.19, ["Fly|Ride"] = 155.79, ["Neon"] = 196.88, ["Neon|Fly|Ride"] = 638.64, ["Mega|Ride"] = 931.88, ["Mega|Fly|Ride"] = 1064.37}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 79.67, ["Fly"] = 91.87, ["Ride"] = 81.38, ["Fly|Ride"] = 97.54, ["Neon"] = 525, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 1879.82}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 3701.16, ["Fly"] = 1615.84, ["Ride"] = 1069.68, ["Fly|Ride"] = 1050, ["Neon|Ride"] = 5165.81, ["Neon|Fly|Ride"] = 4725, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 525, ["Fly"] = 525, ["Ride"] = 569.22, ["Fly|Ride"] = 534.19, ["Neon|Fly|Ride"] = 3222.09, ["Mega|Fly|Ride"] = 11353.48}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 69.57, ["Fly"] = 170.63, ["Ride"] = 100.62, ["Fly|Ride"] = 208.69, ["Neon"] = 442.98, ["Neon|Ride"] = 342.43, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 1988.23, ["Mega|Ride"] = 2578.15, ["Mega|Fly|Ride"] = 1559.21}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 6.36, ["Ride"] = 21.55, ["Fly|Ride"] = 64.78, ["Neon"] = 42.69, ["Neon|Ride"] = 64.02, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 553.88, ["Mega|Ride"] = 770.61}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 32.8, ["Fly"] = 68.25, ["Ride"] = 42, ["Fly|Ride"] = 123.77, ["Neon"] = 283.77, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 326.78, ["Mega"] = 2271.35, ["Mega|Ride"] = 1187.82, ["Mega|Fly|Ride"] = 994.12}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 728.44, ["Fly"] = 1114.38, ["Ride"] = 746.87, ["Fly|Ride"] = 829.5, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2508.42, ["Mega|Fly|Ride"] = 9723}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 591.41}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 6168.75, ["Ride"] = 6661.97, ["Fly|Ride"] = 5248.69, ["Neon"] = 42000, ["Neon|Ride"] = 30574.84, ["Neon|Fly|Ride"] = 18375, ["Mega|Fly|Ride"] = 106293.91}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 210, ["Fly"] = 400.39, ["Ride"] = 328.13, ["Fly|Ride"] = 421.47, ["Neon"] = 1312.5, ["Neon|Ride"] = 1849.8, ["Neon|Fly|Ride"] = 1706.25, ["Mega"] = 6385.08, ["Mega|Ride"] = 6096.64, ["Mega|Fly|Ride"] = 6103.02}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 74.5, ["Fly"] = 284.81, ["Ride"] = 131.14, ["Fly|Ride"] = 336, ["Neon"] = 425.65, ["Neon|Ride"] = 796.9, ["Neon|Fly|Ride"] = 635.82, ["Mega|Fly|Ride"] = 2158.52}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 15.22, ["Fly"] = 65.62, ["Ride"] = 30.19, ["Fly|Ride"] = 78.75, ["Neon"] = 156.92, ["Neon|Fly"] = 1291.77, ["Neon|Ride"] = 125.99, ["Neon|Fly|Ride"] = 212.89, ["Mega|Ride"] = 568.38, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 10.5, ["Fly"] = 26.24, ["Ride"] = 19.69, ["Fly|Ride"] = 49.12, ["Neon"] = 128.03, ["Neon|Ride"] = 323.26, ["Neon|Fly|Ride"] = 90.83, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 2128.72}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 13.94, ["Fly"] = 284.81, ["Ride"] = 31.4, ["Fly|Ride"] = 89.25, ["Neon"] = 124.67, ["Neon|Ride"] = 126.67, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 645.75, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 654.94}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 6.04, ["Fly"] = 62.94, ["Ride"] = 19.69, ["Fly|Ride"] = 48.57, ["Neon"] = 31.38, ["Neon|Ride"] = 56.91, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 695.67, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 276.74}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 27.53, ["Fly"] = 90.57, ["Ride"] = 39.36, ["Fly|Ride"] = 139.13, ["Neon"] = 203.44, ["Neon|Fly"] = 853.43, ["Neon|Ride"] = 234.94, ["Neon|Fly|Ride"] = 451.5, ["Mega"] = 568.38, ["Mega|Ride"] = 781.25}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 483, ["Fly"] = 538.12, ["Ride"] = 485.63, ["Fly|Ride"] = 543.38, ["Neon"] = 1615.01, ["Neon|Ride"] = 1564.98, ["Neon|Fly|Ride"] = 1476.57, ["Mega"] = 7875, ["Mega|Fly|Ride"] = 5251.54}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.63, ["Fly"] = 21.2, ["Ride"] = 14.44, ["Fly|Ride"] = 28.82, ["Neon"] = 23.94, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 57.66, ["Mega"] = 170.63, ["Mega|Ride"] = 225.77, ["Mega|Fly|Ride"] = 213.53}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 45.6, ["Fly"] = 99, ["Ride"] = 78.64, ["Fly|Ride"] = 145.08, ["Neon"] = 204.75, ["Neon|Fly"] = 333.15, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 524.48, ["Mega|Ride"] = 524.99, ["Mega|Fly|Ride"] = 597.08}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 800.63, ["Ride"] = 761.24, ["Fly|Ride"] = 761.25, ["Neon|Ride"] = 1988.23, ["Neon|Fly|Ride"] = 1634.07, ["Mega|Fly|Ride"] = 4199.99}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 29.96, ["Fly"] = 90.56, ["Ride"] = 44.62, ["Fly|Ride"] = 75.98, ["Neon"] = 256.04, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 163.7, ["Neon|Fly|Ride"] = 249.35, ["Mega"] = 1208.13, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 315, ["Fly"] = 484.52, ["Ride"] = 276.07, ["Fly|Ride"] = 337.21, ["Neon"] = 1564.98, ["Neon|Ride"] = 1849.8, ["Neon|Fly|Ride"] = 1771.88, ["Mega|Fly|Ride"] = 6444.17}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 196.86, ["Fly"] = 232.57, ["Ride"] = 183.74, ["Fly|Ride"] = 236.14, ["Neon"] = 996.38, ["Neon|Ride"] = 892.5, ["Neon|Fly|Ride"] = 859.69, ["Mega"] = 4326, ["Mega|Fly|Ride"] = 3774.21}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 836.85, ["Ride"] = 783.57, ["Fly|Ride"] = 923.94, ["Neon|Ride"] = 3808.68, ["Mega|Fly|Ride"] = 8398.69}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 17.09, ["Fly"] = 85.35, ["Ride"] = 45.87, ["Fly|Ride"] = 110.25, ["Neon"] = 78.74, ["Neon|Fly"] = 290.57, ["Neon|Ride"] = 100.29, ["Neon|Fly|Ride"] = 125.89, ["Mega"] = 354.38, ["Mega|Ride"] = 425.76, ["Mega|Fly|Ride"] = 425.76}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 4084.49, ["Fly"] = 3543.75, ["Ride"] = 3281.25, ["Fly|Ride"] = 3150, ["Neon|Fly|Ride"] = 7218.75, ["Mega|Fly|Ride"] = 25058.25}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 104.98, ["Fly"] = 142.94, ["Ride"] = 114.15, ["Fly|Ride"] = 182.52, ["Neon"] = 479.07, ["Neon|Fly"] = 712.69, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 637.88, ["Mega|Ride"] = 2697.1, ["Mega|Fly|Ride"] = 2838.65}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 16.02, ["Ride"] = 15.22, ["Fly|Ride"] = 38.57, ["Neon"] = 21, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 28.82, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 160.1, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 369.35, ["Mega|Fly|Ride"] = 229.91}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.68, ["Ride"] = 24.54, ["Fly|Ride"] = 57.71, ["Neon"] = 23.57, ["Neon|Fly"] = 118.65, ["Neon|Ride"] = 64.26, ["Neon|Fly|Ride"] = 161.9, ["Mega"] = 161.96, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 361.59}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 30.03, ["Fly"] = 40.47, ["Ride"] = 31.82, ["Fly|Ride"] = 56.21, ["Neon"] = 290.57, ["Neon|Ride"] = 274.82, ["Neon|Fly|Ride"] = 292.31, ["Mega|Fly|Ride"] = 1092.05}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 893.82, ["Fly"] = 1253.67, ["Ride"] = 995.08, ["Fly|Ride"] = 971.24, ["Neon"] = 4410.07, ["Neon|Fly|Ride"] = 4410.07}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 6298.69, ["Fly|Ride"] = 6431.25}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 16.21, ["Fly"] = 28.82, ["Ride"] = 22.31, ["Fly|Ride"] = 32.71, ["Neon"] = 452.13, ["Neon|Ride"] = 126, ["Neon|Fly|Ride"] = 135.19, ["Mega"] = 2520, ["Mega|Fly|Ride"] = 712.23}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 12.99, ["Fly"] = 48.46, ["Ride"] = 28.83, ["Fly|Ride"] = 68.25, ["Neon"] = 71.31, ["Neon|Ride"] = 89.14, ["Neon|Fly|Ride"] = 135.49, ["Mega"] = 662.17, ["Mega|Ride"] = 362.25, ["Mega|Fly|Ride"] = 568.38}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 92.63, ["Fly"] = 157.5, ["Ride"] = 87.94, ["Fly|Ride"] = 142.7, ["Neon|Ride"] = 439.69, ["Neon|Fly|Ride"] = 366.18, ["Mega|Fly|Ride"] = 1639.67}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 216.57, ["Fly"] = 241.5, ["Ride"] = 221.75, ["Fly|Ride"] = 328.13, ["Neon"] = 918.75, ["Neon|Ride"] = 1145.63, ["Neon|Fly|Ride"] = 984.38, ["Mega"] = 8514.85, ["Mega|Fly|Ride"] = 4512.38}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.83, ["Ride"] = 32.71, ["Fly|Ride"] = 57.62, ["Neon"] = 19.39, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 53.36, ["Mega"] = 147.96, ["Mega|Fly"] = 237.37, ["Mega|Ride"] = 191.31, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 185.66, ["Fly"] = 213.35, ["Ride"] = 206.05, ["Fly|Ride"] = 299.85, ["Neon"] = 803.87, ["Neon|Fly"] = 711.56, ["Neon|Ride"] = 726.39, ["Neon|Fly|Ride"] = 774.38, ["Mega|Fly|Ride"] = 2576.44}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 3.19, ["Fly"] = 23.63, ["Ride"] = 15.75, ["Fly|Ride"] = 60.1, ["Neon"] = 28.83, ["Neon|Fly"] = 71.49, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 108.94, ["Mega"] = 225.75, ["Mega|Ride"] = 212.89, ["Mega|Fly|Ride"] = 289.34}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 190.32, ["Fly"] = 344.54, ["Ride"] = 207.9, ["Fly|Ride"] = 236.25, ["Neon"] = 1280.14, ["Neon|Ride"] = 1210.64, ["Neon|Fly|Ride"] = 889.1, ["Mega"] = 10643.55, ["Mega|Fly|Ride"] = 5477.67}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 7.55, ["Fly"] = 77.44, ["Ride"] = 24.54, ["Fly|Ride"] = 68.25, ["Neon"] = 73.5, ["Neon|Fly"] = 307.51, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 568.38, ["Mega|Ride"] = 497.06, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 6.46, ["Ride"] = 20.3, ["Fly|Ride"] = 72.19, ["Neon"] = 11.17, ["Neon|Fly"] = 170.46, ["Neon|Ride"] = 36.28, ["Neon|Fly|Ride"] = 140.83, ["Mega"] = 82.43, ["Mega|Ride"] = 115.03, ["Mega|Fly|Ride"] = 212.89}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.66, ["Mega"] = 18.26, ["Mega|Ride"] = 152.24, ["Mega|Fly|Ride"] = 168.18}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 2.24, ["Ride"] = 34.16, ["Fly|Ride"] = 114.01, ["Neon"] = 6.57, ["Neon|Ride"] = 27.8, ["Neon|Fly|Ride"] = 89.25, ["Mega"] = 81.04, ["Mega|Fly"] = 161084.55, ["Mega|Ride"] = 76, ["Mega|Fly|Ride"] = 246.94}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 61.69, ["Fly"] = 105, ["Ride"] = 102.1, ["Fly|Ride"] = 188.05, ["Neon"] = 336.57, ["Neon|Fly"] = 327.97, ["Neon|Ride"] = 294, ["Neon|Fly|Ride"] = 368.82, ["Mega|Fly|Ride"] = 1348.56}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 35.15, ["Ride"] = 17.06, ["Fly|Ride"] = 78.75, ["Neon"] = 7.48, ["Neon|Fly"] = 42.69, ["Neon|Ride"] = 19.68, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 91.88, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 262.47}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 6.46, ["Ride"] = 114.15, ["Neon"] = 65.63, ["Neon|Fly"] = 242.13, ["Neon|Ride"] = 249.41, ["Mega"] = 261.19, ["Mega|Ride"] = 425.76}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Ride"] = 57.62, ["Neon"] = 2.1, ["Neon|Ride"] = 55.13, ["Mega"] = 13.11, ["Mega|Fly"] = 142.64, ["Mega|Ride"] = 64.83, ["Mega|Fly|Ride"] = 157.16}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 71.28, ["Ride"] = 15.64, ["Fly|Ride"] = 24.68, ["Neon"] = 2.1, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 14.21, ["Neon|Fly|Ride"] = 28.77, ["Mega"] = 11.81, ["Mega|Fly"] = 27.72, ["Mega|Ride"] = 19.69, ["Mega|Fly|Ride"] = 57.48}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 19.68, ["Ride"] = 12.83, ["Fly|Ride"] = 67.22, ["Neon"] = 2.1, ["Neon|Fly"] = 20.99, ["Neon|Ride"] = 13.95, ["Neon|Fly|Ride"] = 42.83, ["Mega"] = 31.95, ["Mega|Fly"] = 161.9, ["Mega|Ride"] = 32.81, ["Mega|Fly|Ride"] = 60.88}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Ride"] = 71.48, ["Neon"] = 2.37, ["Neon|Ride"] = 65.62, ["Mega"] = 19.69, ["Mega|Ride"] = 78.78, ["Mega|Fly|Ride"] = 355.51}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 91.86, ["Ride"] = 31.5, ["Fly|Ride"] = 107.62, ["Neon"] = 3.62, ["Neon|Fly"] = 121.43, ["Neon|Ride"] = 20.88, ["Neon|Fly|Ride"] = 81.55, ["Mega"] = 24.94, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 38.07, ["Mega|Fly|Ride"] = 101.06}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 82.08, ["Neon|Fly|Ride"] = 426.72, ["Mega"] = 17.74, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 72.19, ["Mega|Fly|Ride"] = 212.84}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 3.4, ["Fly"] = 36.75, ["Ride"] = 36.35, ["Fly|Ride"] = 156.45, ["Neon"] = 17.73, ["Neon|Fly"] = 24.23, ["Neon|Ride"] = 38.98, ["Neon|Fly|Ride"] = 104.99, ["Mega"] = 131.22, ["Mega|Fly"] = 289.52, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 203.44}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 22.32, ["Neon"] = 2.1, ["Neon|Ride"] = 16.02, ["Neon|Fly|Ride"] = 321.62, ["Mega"] = 12.95, ["Mega|Fly"] = 144.38, ["Mega|Ride"] = 69.78, ["Mega|Fly|Ride"] = 131.24}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.1, ["Ride"] = 144.03, ["Fly|Ride"] = 142.96, ["Neon"] = 18.14, ["Mega"] = 135.19, ["Mega|Fly"] = 315, ["Mega|Ride"] = 274.31, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Ride"] = 28.82, ["Neon"] = 19.22, ["Neon|Ride"] = 71.49, ["Mega"] = 111.55, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 568.38}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 4.23, ["Neon|Ride"] = 27.67, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 21.05, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 131.24}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.25, ["Ride"] = 14.32, ["Fly|Ride"] = 26.25, ["Neon"] = 2.1, ["Neon|Fly"] = 16.02, ["Neon|Ride"] = 14.32, ["Neon|Fly|Ride"] = 37.7, ["Mega"] = 13.05, ["Mega|Fly"] = 32.76, ["Mega|Ride"] = 19.66, ["Mega|Fly|Ride"] = 49.87}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.1, ["Fly"] = 72.19, ["Ride"] = 229.68, ["Fly|Ride"] = 118.1, ["Neon"] = 31.49, ["Neon|Ride"] = 140.95, ["Mega"] = 191.61, ["Mega|Ride"] = 240.19}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 31.4, ["Neon"] = 6.57, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 105, ["Mega"] = 23.36, ["Mega|Ride"] = 47.98, ["Mega|Fly|Ride"] = 111.55}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 2.1, ["Neon"] = 12.79, ["Mega"] = 82.69, ["Mega|Ride"] = 161.8, ["Mega|Fly|Ride"] = 254.62}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.1, ["Fly"] = 78.92, ["Ride"] = 19.69, ["Fly|Ride"] = 194.16, ["Neon"] = 19.39, ["Neon|Ride"] = 42.69, ["Neon|Fly|Ride"] = 142.96, ["Mega"] = 124.69, ["Mega|Ride"] = 143.07, ["Mega|Fly|Ride"] = 193.32}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 11.71, ["Fly|Ride"] = 28.82, ["Neon"] = 2.1, ["Neon|Fly"] = 15.64, ["Neon|Ride"] = 12.89, ["Neon|Fly|Ride"] = 28.88, ["Mega"] = 12.97, ["Mega|Fly"] = 28.18, ["Mega|Ride"] = 22.05, ["Mega|Fly|Ride"] = 53.24}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 21.38, ["Ride"] = 27.41, ["Fly|Ride"] = 142.96, ["Neon"] = 12.96, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 196.47, ["Mega"] = 129.64, ["Mega|Ride"] = 160.78, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 9.08, ["Fly"] = 16.02, ["Ride"] = 40.57, ["Fly|Ride"] = 52.5, ["Neon"] = 48.57, ["Neon|Ride"] = 68.16, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 228.38, ["Mega|Ride"] = 297.51, ["Mega|Fly|Ride"] = 281.54}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 32.51, ["Ride"] = 14.43, ["Fly|Ride"] = 28.76, ["Neon"] = 2.1, ["Neon|Fly"] = 15.65, ["Neon|Ride"] = 15.54, ["Neon|Fly|Ride"] = 31.91, ["Mega"] = 19.81, ["Mega|Ride"] = 31.5, ["Mega|Fly|Ride"] = 79.19}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 3.84, ["Fly"] = 178.14, ["Ride"] = 31.5, ["Neon"] = 7.09, ["Neon|Ride"] = 35.47, ["Neon|Fly|Ride"] = 169.63, ["Mega"] = 63, ["Mega|Fly"] = 170.31, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 35.44, ["Fly|Ride"] = 131.25, ["Neon"] = 3.4, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 42.69, ["Neon|Fly|Ride"] = 284.95, ["Mega"] = 26.58, ["Mega|Fly"] = 142.64, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 314}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 32.72, ["Ride"] = 15.75, ["Neon"] = 2.1, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 284.85, ["Mega"] = 11.72, ["Mega|Fly"] = 253.82, ["Mega|Ride"] = 40.21, ["Mega|Fly|Ride"] = 156.18}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 71.48, ["Ride"] = 14.85, ["Fly|Ride"] = 46.56, ["Neon"] = 5.25, ["Neon|Fly"] = 54.41, ["Neon|Ride"] = 17.17, ["Neon|Fly|Ride"] = 64.02, ["Mega"] = 71.64, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 57.66, ["Neon"] = 6.57, ["Neon|Ride"] = 68.25, ["Mega"] = 40, ["Mega|Fly"] = 241.64, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 221.82}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 15.12, ["Fly|Ride"] = 50.18, ["Neon"] = 6.45, ["Neon|Fly"] = 81.13, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 57.62, ["Mega"] = 111.57, ["Mega|Ride"] = 90.55, ["Mega|Fly|Ride"] = 111.57}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 3.94, ["Ride"] = 38.98, ["Neon"] = 31.95, ["Neon|Fly"] = 188.89, ["Neon|Ride"] = 25.74, ["Neon|Fly|Ride"] = 179.19, ["Mega"] = 101.07, ["Mega|Fly"] = 341.25, ["Mega|Ride"] = 210}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Fly"] = 25.77, ["Ride"] = 15.6, ["Fly|Ride"] = 32.03, ["Neon"] = 9.5, ["Neon|Fly"] = 28.82, ["Neon|Ride"] = 32.22, ["Neon|Fly|Ride"] = 70.88, ["Mega"] = 263.99, ["Mega|Fly"] = 420, ["Mega|Ride"] = 121.44, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.1, ["Fly"] = 21.1, ["Ride"] = 15.1, ["Fly|Ride"] = 73.47, ["Neon"] = 10.5, ["Neon|Fly"] = 66.59, ["Neon|Ride"] = 32.55, ["Neon|Fly|Ride"] = 108.32, ["Mega"] = 170.31, ["Mega|Fly"] = 161.95, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 113.08, ["Neon"] = 7.88, ["Neon|Fly|Ride"] = 2625, ["Mega"] = 196.58, ["Mega|Ride"] = 315}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 6.13, ["Ride"] = 56.44, ["Neon"] = 202.1, ["Neon|Fly|Ride"] = 794.07, ["Mega|Ride"] = 751.45, ["Mega|Fly|Ride"] = 981.75}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 2.19, ["Ride"] = 41.21, ["Neon"] = 44.61, ["Neon|Ride"] = 106.55, ["Mega"] = 238.88, ["Mega|Ride"] = 364.23, ["Mega|Fly|Ride"] = 321.38}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 3.56, ["Ride"] = 15.94, ["Fly|Ride"] = 120.75, ["Neon"] = 33.08, ["Neon|Ride"] = 71.49, ["Mega"] = 283.14, ["Mega|Ride"] = 326.78, ["Mega|Fly|Ride"] = 395.07}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Ride"] = 28.82, ["Neon"] = 3.93, ["Neon|Ride"] = 65.02, ["Mega"] = 15.64, ["Mega|Fly"] = 122.41, ["Mega|Ride"] = 127.74, ["Mega|Fly|Ride"] = 191.71}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 41.88}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 3.68, ["Fly"] = 23.62, ["Ride"] = 18.4, ["Fly|Ride"] = 36.75, ["Neon"] = 44.61, ["Neon|Fly"] = 188.48, ["Neon|Ride"] = 57.99, ["Neon|Fly|Ride"] = 78.66, ["Mega|Ride"] = 208.68, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.79, ["Ride"] = 15.75, ["Fly|Ride"] = 64.32, ["Neon"] = 2.62, ["Neon|Fly"] = 52.8, ["Neon|Ride"] = 21.35, ["Neon|Fly|Ride"] = 105, ["Mega"] = 16.93, ["Mega|Fly"] = 142.64, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 98.42}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Neon"] = 5.16, ["Neon|Ride"] = 36.37, ["Neon|Fly|Ride"] = 74.43, ["Mega"] = 32.21, ["Mega|Ride"] = 63.88, ["Mega|Fly|Ride"] = 104.99}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 28.82, ["Ride"] = 15.44, ["Fly|Ride"] = 45.73, ["Neon"] = 7.76, ["Neon|Ride"] = 19.18, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 142.72, ["Mega|Ride"] = 118.01, ["Mega|Fly|Ride"] = 234.64}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 3.56, ["Fly"] = 42.69, ["Ride"] = 85.31, ["Fly|Ride"] = 57.75, ["Neon"] = 43.14, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 216.56, ["Mega"] = 163.93, ["Mega|Ride"] = 355.51, ["Mega|Fly|Ride"] = 318.26}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Ride"] = 33.77, ["Neon"] = 3.82, ["Neon|Ride"] = 25.12, ["Mega"] = 20.79, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 53.82, ["Mega|Fly|Ride"] = 127.74}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 27.56, ["Ride"] = 16.69, ["Fly|Ride"] = 34.07, ["Neon"] = 2.1, ["Neon|Fly"] = 112.9, ["Neon|Ride"] = 19.67, ["Neon|Fly|Ride"] = 96.87, ["Mega"] = 26.59, ["Mega|Fly"] = 142.64, ["Mega|Ride"] = 38.75, ["Mega|Fly|Ride"] = 112.84}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 28.65, ["Ride"] = 13.75, ["Fly|Ride"] = 31.5, ["Neon"] = 2.63, ["Neon|Fly"] = 57.62, ["Neon|Ride"] = 18.16, ["Neon|Fly|Ride"] = 34.16, ["Mega"] = 63.88, ["Mega|Fly"] = 142.64, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 118.41}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 91.88, ["Ride"] = 25.99, ["Fly|Ride"] = 142.96, ["Neon"] = 2.1, ["Neon|Ride"] = 39.19, ["Neon|Fly|Ride"] = 71.49, ["Mega"] = 59.59, ["Mega|Ride"] = 85.83, ["Mega|Fly|Ride"] = 248.06}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 28.82, ["Neon|Fly|Ride"] = 155928.86, ["Mega"] = 18.26, ["Mega|Fly"] = 106.45, ["Mega|Ride"] = 55.13, ["Mega|Fly|Ride"] = 136.49}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 45.91, ["Ride"] = 17.21, ["Fly|Ride"] = 142.96, ["Neon"] = 2.41, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 20.37, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 18.55, ["Mega|Fly"] = 63.89, ["Mega|Ride"] = 36.98, ["Mega|Fly|Ride"] = 88.09}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Ride"] = 42.69, ["Neon"] = 2.1, ["Neon|Ride"] = 40.56, ["Neon|Fly|Ride"] = 114.15, ["Mega"] = 18.38, ["Mega|Ride"] = 177.77}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.61, ["Neon|Fly|Ride"] = 420, ["Mega"] = 28.88, ["Mega|Ride"] = 192.18, ["Mega|Fly|Ride"] = 263.99}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 15.74, ["Fly|Ride"] = 52.49, ["Neon"] = 4.29, ["Neon|Fly"] = 32.81, ["Neon|Ride"] = 15.59, ["Neon|Fly|Ride"] = 42.59, ["Mega"] = 26.25, ["Mega|Fly"] = 45.78, ["Mega|Ride"] = 54.3, ["Mega|Fly|Ride"] = 107.55}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 8.58, ["Ride"] = 59.07, ["Fly|Ride"] = 213.38, ["Neon"] = 123.77, ["Neon|Ride"] = 174.57, ["Mega"] = 406.88, ["Mega|Ride"] = 497.44, ["Mega|Fly|Ride"] = 709.93}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.1, ["Fly"] = 6562.5, ["Ride"] = 38.77, ["Neon"] = 32.82, ["Neon|Ride"] = 157.5, ["Mega"] = 195.57, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 2.35, ["Ride"] = 31.95, ["Fly|Ride"] = 180.93, ["Neon"] = 17.97, ["Neon|Ride"] = 71.49, ["Neon|Fly|Ride"] = 426.72, ["Mega"] = 250.08, ["Mega|Ride"] = 455.57, ["Mega|Fly|Ride"] = 377.89}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 17.09, ["Ride"] = 12.06, ["Fly|Ride"] = 27.59, ["Neon"] = 2.1, ["Neon|Fly"] = 15.64, ["Neon|Ride"] = 13.93, ["Neon|Fly|Ride"] = 21.35, ["Mega"] = 13.65, ["Mega|Fly"] = 19.15, ["Mega|Ride"] = 19.16, ["Mega|Fly|Ride"] = 41.22}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 3.94, ["Fly"] = 118.12, ["Ride"] = 59.76, ["Neon"] = 6.57, ["Neon|Fly"] = 67.79, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 711.56, ["Mega"] = 77.41, ["Mega|Ride"] = 65.63}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Fly"] = 71.48, ["Ride"] = 31.5, ["Neon"] = 2.1, ["Neon|Fly"] = 31.95, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 86.65, ["Mega"] = 12.47, ["Mega|Fly"] = 63.88, ["Mega|Ride"] = 71.32, ["Mega|Fly|Ride"] = 127.74}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 127.32, ["Mega"] = 12.97, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 42.69, ["Ride"] = 16.02, ["Fly|Ride"] = 42.69, ["Neon"] = 8.36, ["Neon|Fly"] = 71.17, ["Neon|Ride"] = 37.99, ["Neon|Fly|Ride"] = 75.91, ["Mega"] = 169.31, ["Mega|Fly"] = 193.32, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 292.04}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 155.3, ["Ride"] = 224, ["Fly|Ride"] = 381.92, ["Neon"] = 939.84, ["Neon|Fly|Ride"] = 977.18, ["Mega"] = 8514.85, ["Mega|Ride"] = 3335.71, ["Mega|Fly|Ride"] = 3342.09}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Ride"] = 24.25, ["Neon"] = 8.07, ["Neon|Ride"] = 64.31, ["Mega"] = 68.16, ["Mega|Ride"] = 191.61, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 3.94, ["Fly"] = 103.68, ["Ride"] = 26.25, ["Fly|Ride"] = 62.91, ["Neon"] = 32.45, ["Neon|Ride"] = 170.7, ["Neon|Fly|Ride"] = 142.96, ["Mega"] = 381.82, ["Mega|Ride"] = 531.44, ["Mega|Fly|Ride"] = 643.22}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 28.74, ["Ride"] = 15.6, ["Fly|Ride"] = 30.19, ["Neon"] = 7.88, ["Neon|Fly"] = 34.13, ["Neon|Ride"] = 29.78, ["Neon|Fly|Ride"] = 47.4, ["Mega"] = 46.78, ["Mega|Ride"] = 83.91, ["Mega|Fly|Ride"] = 143.79}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 71.48, ["Ride"] = 18.13, ["Fly|Ride"] = 92.59, ["Neon"] = 8.33, ["Neon|Ride"] = 68.08, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 71.32, ["Mega|Ride"] = 193.32, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 3.62, ["Fly"] = 25.99, ["Ride"] = 15.67, ["Fly|Ride"] = 31.23, ["Neon"] = 21.05, ["Neon|Fly"] = 100.05, ["Neon|Ride"] = 32.1, ["Neon|Fly|Ride"] = 77.96, ["Mega|Ride"] = 279.95, ["Mega|Fly|Ride"] = 293.99}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 3.54, ["Ride"] = 28.82, ["Fly|Ride"] = 118.13, ["Neon"] = 48.06, ["Neon|Ride"] = 85.36, ["Neon|Fly|Ride"] = 465.94, ["Mega"] = 262.49, ["Mega|Ride"] = 342.48, ["Mega|Fly|Ride"] = 387.18}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.1, ["Fly"] = 18.79, ["Ride"] = 14.26, ["Fly|Ride"] = 34.09, ["Neon"] = 25.78, ["Neon|Fly"] = 67.28, ["Neon|Ride"] = 36.24, ["Neon|Fly|Ride"] = 62.91, ["Mega"] = 262.5, ["Mega|Ride"] = 284.2, ["Mega|Fly|Ride"] = 229.68}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 55.02, ["Fly"] = 98.63, ["Ride"] = 79.71, ["Fly|Ride"] = 148.31, ["Neon"] = 341.24, ["Neon|Fly"] = 437.07, ["Neon|Ride"] = 397.69, ["Neon|Fly|Ride"] = 436.07, ["Mega|Fly|Ride"] = 1468.68}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 196.56, ["Fly"] = 426.68, ["Ride"] = 246.75, ["Fly|Ride"] = 308.44, ["Neon"] = 1210.64, ["Neon|Ride"] = 1138.26, ["Neon|Fly|Ride"] = 965.51, ["Mega"] = 10643.55, ["Mega|Fly|Ride"] = 4964.16}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 56.35, ["Fly"] = 85.2, ["Ride"] = 67.45, ["Fly|Ride"] = 114.15, ["Neon"] = 262.5, ["Neon|Ride"] = 290.34, ["Neon|Fly|Ride"] = 286.8, ["Mega|Ride"] = 1135.68, ["Mega|Fly|Ride"] = 1382.61}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 5.25, ["Fly"] = 42.69, ["Ride"] = 23.28, ["Fly|Ride"] = 65.63, ["Neon"] = 26.25, ["Neon|Ride"] = 106.7, ["Neon|Fly|Ride"] = 283.4, ["Mega"] = 262.5, ["Mega|Ride"] = 244.13, ["Mega|Fly|Ride"] = 416.73}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 8.23, ["Fly"] = 71.48, ["Ride"] = 20.99, ["Fly|Ride"] = 93.3, ["Neon"] = 48.57, ["Neon|Ride"] = 59.66, ["Neon|Fly|Ride"] = 212.89, ["Mega"] = 416.07, ["Mega|Ride"] = 298.7, ["Mega|Fly|Ride"] = 400.41}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 31.18, ["Ride"] = 14.69, ["Fly|Ride"] = 44.68, ["Neon"] = 2.1, ["Neon|Fly"] = 21, ["Neon|Ride"] = 15.64, ["Neon|Fly|Ride"] = 39.37, ["Mega"] = 32.82, ["Mega|Fly"] = 147.41, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 527.66}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 6.97, ["Fly"] = 72.12, ["Ride"] = 23.63, ["Fly|Ride"] = 66.25, ["Neon"] = 152.55, ["Neon|Fly"] = 356.32, ["Neon|Ride"] = 113.05, ["Neon|Fly|Ride"] = 211.44, ["Mega"] = 1837.5, ["Mega|Ride"] = 483.27, ["Mega|Fly|Ride"] = 732.38}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 41.91, ["Ride"] = 14.93, ["Fly|Ride"] = 36.01, ["Neon"] = 4.87, ["Neon|Fly"] = 81.13, ["Neon|Ride"] = 27.85, ["Neon|Fly|Ride"] = 64.32, ["Mega"] = 157.5, ["Mega|Ride"] = 183.93, ["Mega|Fly|Ride"] = 204.44}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 2.1, ["Ride"] = 30.95, ["Fly|Ride"] = 328.13, ["Neon"] = 22.32, ["Neon|Ride"] = 36.21, ["Mega"] = 199.05, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 27.68, ["Ride"] = 19.36, ["Neon"] = 2.1, ["Neon|Ride"] = 19.68, ["Neon|Fly|Ride"] = 57.73, ["Mega"] = 15.73, ["Mega|Ride"] = 42.58, ["Mega|Fly|Ride"] = 78.74}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 19.59, ["Ride"] = 14.43, ["Fly|Ride"] = 28.82, ["Neon"] = 15.65, ["Neon|Fly"] = 106.7, ["Neon|Ride"] = 27.85, ["Neon|Fly|Ride"] = 147, ["Mega"] = 78.72, ["Mega|Ride"] = 106.33, ["Mega|Fly|Ride"] = 200.17}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.52, ["Fly"] = 25.72, ["Ride"] = 17.38, ["Fly|Ride"] = 62.79, ["Neon"] = 16.02, ["Neon|Ride"] = 47.25, ["Mega"] = 131.18, ["Mega|Ride"] = 241.62, ["Mega|Fly|Ride"] = 230.99}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 98.44, ["Fly"] = 143.07, ["Ride"] = 143.06, ["Fly|Ride"] = 189.69, ["Neon"] = 489.56, ["Neon|Ride"] = 441.79, ["Neon|Fly|Ride"] = 524.94, ["Mega"] = 4257.44, ["Mega|Fly|Ride"] = 2255.96}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 7.87, ["Ride"] = 72.6, ["Fly|Ride"] = 129.6, ["Neon"] = 78.74, ["Neon|Ride"] = 98.42, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 322.59, ["Mega|Ride"] = 439.77, ["Mega|Fly|Ride"] = 483.23}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 28.82, ["Ride"] = 16.21, ["Fly|Ride"] = 36.74, ["Neon"] = 13.13, ["Neon|Ride"] = 28.77, ["Neon|Fly|Ride"] = 120.64, ["Mega"] = 246.75, ["Mega|Ride"] = 187.68, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 19.68, ["Ride"] = 58.02, ["Fly|Ride"] = 170.63, ["Neon"] = 107.63, ["Neon|Ride"] = 142.99, ["Neon|Fly|Ride"] = 630.38, ["Mega"] = 568.38, ["Mega|Fly"] = 851.5, ["Mega|Ride"] = 687.75, ["Mega|Fly|Ride"] = 645.16}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 7.87}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 15.65, ["Ride"] = 28.84, ["Fly|Ride"] = 126.84, ["Neon"] = 36.74, ["Neon|Fly"] = 89.25, ["Neon|Ride"] = 85.97, ["Neon|Fly|Ride"] = 426.72, ["Mega"] = 425.76, ["Mega|Ride"] = 483.27, ["Mega|Fly|Ride"] = 884.14}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 26.17, ["Fly"] = 36.88, ["Ride"] = 26.17, ["Fly|Ride"] = 47.09, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 113.81, ["Neon|Fly|Ride"] = 170.07, ["Mega"] = 1374.1, ["Mega|Fly|Ride"] = 568.38}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 19.48, ["Fly|Ride"] = 52.5, ["Neon"] = 3.8, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 21.19, ["Neon|Fly|Ride"] = 107.62, ["Mega"] = 29.56, ["Mega|Fly"] = 188.99, ["Mega|Ride"] = 58.95, ["Mega|Fly|Ride"] = 229.22}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 18.27, ["Fly"] = 28.82, ["Ride"] = 19.81, ["Fly|Ride"] = 65.54, ["Neon"] = 57.48, ["Neon|Ride"] = 64.02, ["Mega"] = 284.2, ["Mega|Fly"] = 403.53, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 483.23}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 13.79, ["Fly|Ride"] = 47.97, ["Neon"] = 19.22, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 29.35, ["Neon|Fly|Ride"] = 71.31, ["Mega"] = 182.01, ["Mega|Ride"] = 199.4, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 28.64, ["Fly|Ride"] = 213.38, ["Neon"] = 3.59, ["Neon|Fly"] = 37.35, ["Neon|Ride"] = 32.45, ["Mega"] = 22.2, ["Mega|Ride"] = 62.82, ["Mega|Fly|Ride"] = 125.55}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 24.94, ["Fly"] = 138.91, ["Ride"] = 42, ["Fly|Ride"] = 68.25, ["Neon"] = 105, ["Neon|Ride"] = 209.68, ["Neon|Fly|Ride"] = 568.37, ["Mega"] = 727.13, ["Mega|Ride"] = 994.12, ["Mega|Fly|Ride"] = 866.25}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 2.3, ["Fly"] = 28.82, ["Ride"] = 42, ["Fly|Ride"] = 210, ["Neon"] = 95.81, ["Mega|Ride"] = 525}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 2.84, ["Fly"] = 28.82, ["Ride"] = 14.67, ["Fly|Ride"] = 48.45, ["Neon"] = 17.07, ["Neon|Fly"] = 85.36, ["Neon|Ride"] = 26.16, ["Neon|Fly|Ride"] = 74.82, ["Mega"] = 387.85, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 273.67}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 68.86, ["Fly"] = 433.12, ["Ride"] = 393.75, ["Fly|Ride"] = 262.5, ["Neon"] = 380.63, ["Neon|Ride"] = 360.94, ["Mega"] = 4512.38, ["Mega|Ride"] = 2165.63, ["Mega|Fly|Ride"] = 2625.78}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 5.7, ["Fly"] = 45.05, ["Ride"] = 21.15, ["Fly|Ride"] = 57.66, ["Neon"] = 30.81, ["Neon|Ride"] = 48.37, ["Neon|Fly|Ride"] = 90.3, ["Mega"] = 252, ["Mega|Ride"] = 225.93, ["Mega|Fly|Ride"] = 319.79}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 70.26, ["Fly"] = 143.06, ["Ride"] = 109.87, ["Fly|Ride"] = 135.49, ["Neon"] = 216.56, ["Neon|Fly"] = 324.32, ["Neon|Ride"] = 255.62, ["Neon|Fly|Ride"] = 314.43, ["Mega"] = 956.87, ["Mega|Ride"] = 958.13, ["Mega|Fly|Ride"] = 968.63}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 19.06, ["Ride"] = 42.63, ["Fly|Ride"] = 169.32, ["Neon"] = 81.37, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 196.85, ["Mega"] = 315, ["Mega|Ride"] = 335.88, ["Mega|Fly|Ride"] = 413.44}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 5.18, ["Fly"] = 40.05, ["Ride"] = 28.82, ["Fly|Ride"] = 70.13, ["Neon"] = 105.7, ["Neon|Ride"] = 145.29, ["Neon|Fly|Ride"] = 384.2, ["Mega"] = 161.9, ["Mega|Ride"] = 212.89, ["Mega|Fly|Ride"] = 539.64}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 13.12, ["Fly"] = 70.42, ["Ride"] = 45.48, ["Fly|Ride"] = 131.25, ["Neon"] = 39.37, ["Neon|Ride"] = 74.41, ["Neon|Fly|Ride"] = 438.38, ["Mega"] = 236.91, ["Mega|Ride"] = 340.57, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 6.17, ["Ride"] = 30.09, ["Fly|Ride"] = 72.19, ["Neon"] = 32.44, ["Neon|Ride"] = 57.62, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 276.63, ["Mega|Ride"] = 264.16, ["Mega|Fly|Ride"] = 348.66}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 94.74, ["Neon|Ride"] = 101.19, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 13.13, ["Mega|Ride"] = 142.64, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 2.1, ["Ride"] = 59.07, ["Neon"] = 26.25, ["Neon|Ride"] = 185.63, ["Neon|Fly|Ride"] = 202.79, ["Mega"] = 229.59, ["Mega|Ride"] = 302.04, ["Mega|Fly|Ride"] = 455.57}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Fly"] = 125.88, ["Ride"] = 28.53, ["Neon"] = 28.56, ["Neon|Fly"] = 78.95, ["Neon|Ride"] = 71.49, ["Mega"] = 178.82, ["Mega|Ride"] = 282.92, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 2.1, ["Ride"] = 32.8, ["Fly|Ride"] = 121.12, ["Neon"] = 32.02, ["Neon|Ride"] = 82.95, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 124.69, ["Mega|Ride"] = 284.2, ["Mega|Fly|Ride"] = 519.74}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 505.32, ["Fly"] = 627.45, ["Ride"] = 498.75, ["Fly|Ride"] = 559.85, ["Neon"] = 1813.53, ["Neon|Fly"] = 1815.66, ["Neon|Ride"] = 1854.06, ["Neon|Fly|Ride"] = 1548.75, ["Mega|Fly|Ride"] = 5880}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 7.07, ["Fly"] = 45.47, ["Ride"] = 20.42, ["Fly|Ride"] = 56.35, ["Neon"] = 41.62, ["Neon|Ride"] = 57.72, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 183.75, ["Mega|Ride"] = 368.03, ["Mega|Fly|Ride"] = 352.32}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 5.79, ["Fly"] = 66.94, ["Ride"] = 16.94, ["Fly|Ride"] = 51.55, ["Neon"] = 75.49, ["Neon|Fly"] = 315, ["Neon|Ride"] = 71.65, ["Neon|Fly|Ride"] = 164.3, ["Mega"] = 331.87, ["Mega|Ride"] = 505.59, ["Mega|Fly|Ride"] = 385.31}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 6.32, ["Fly"] = 24.93, ["Ride"] = 20.24, ["Fly|Ride"] = 50.78, ["Neon"] = 13.1, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 131.25}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.59, ["Ride"] = 24.36, ["Fly|Ride"] = 52.5, ["Neon"] = 5.25, ["Neon|Ride"] = 35.59, ["Neon|Fly|Ride"] = 100.29, ["Mega"] = 61.32, ["Mega|Fly"] = 284.2, ["Mega|Ride"] = 105.95, ["Mega|Fly|Ride"] = 226.85}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 71.48, ["Ride"] = 16.95, ["Neon"] = 2.1, ["Neon|Ride"] = 23.6, ["Neon|Fly|Ride"] = 114.09, ["Mega"] = 23.49, ["Mega|Ride"] = 78.66, ["Mega|Fly|Ride"] = 225.98}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1115.52}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 7.49, ["Ride"] = 30.19, ["Fly|Ride"] = 332.06, ["Neon"] = 65.4, ["Neon|Ride"] = 100.08, ["Mega"] = 338.29, ["Mega|Ride"] = 851.5, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 27.98, ["Neon"] = 5.13, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 994, ["Mega"] = 37.14, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 250.04}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 3.59, ["Fly"] = 28.75, ["Ride"] = 64.02, ["Neon"] = 20.69, ["Neon|Fly"] = 142.96, ["Neon|Ride"] = 71.49, ["Neon|Fly|Ride"] = 262.4, ["Mega"] = 216.57, ["Mega|Ride"] = 362.45, ["Mega|Fly|Ride"] = 1064.37}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 409.49, ["Ride"] = 438.26, ["Fly|Ride"] = 498.75, ["Neon|Ride"] = 1284.69, ["Neon|Fly|Ride"] = 1312.49, ["Mega"] = 8860.43, ["Mega|Fly|Ride"] = 6298.69}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 3.56, ["Fly"] = 196.88, ["Ride"] = 21.35, ["Fly|Ride"] = 426.72, ["Neon"] = 31.5, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 193.72, ["Mega"] = 391.7, ["Mega|Ride"] = 483.27, ["Mega|Fly|Ride"] = 741.8}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Fly"] = 94.32, ["Ride"] = 26.25, ["Fly|Ride"] = 118.11, ["Neon"] = 2.63, ["Neon|Ride"] = 37.41, ["Neon|Fly|Ride"] = 57.62, ["Mega"] = 32.1, ["Mega|Fly"] = 142.96, ["Mega|Ride"] = 76.04, ["Mega|Fly|Ride"] = 154.25}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Neon"] = 4.2, ["Neon|Ride"] = 142.63, ["Neon|Fly|Ride"] = 198.43, ["Mega"] = 32.78, ["Mega|Ride"] = 143.08, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 20.89, ["Fly"] = 107.89, ["Ride"] = 42.74, ["Fly|Ride"] = 142.96, ["Neon"] = 68.25, ["Neon|Ride"] = 179.82, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 548.5, ["Mega|Ride"] = 472.5, ["Mega|Fly|Ride"] = 544.69}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 10.29, ["Ride"] = 71.31, ["Neon"] = 104.81, ["Neon|Ride"] = 179.47, ["Neon|Fly|Ride"] = 484.26, ["Mega"] = 403.53, ["Mega|Ride"] = 482.35, ["Mega|Fly|Ride"] = 638.64}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 3.7, ["Ride"] = 32.82, ["Neon"] = 96.94, ["Neon|Ride"] = 183.38, ["Mega"] = 623.74, ["Mega|Ride"] = 1085.66, ["Mega|Fly|Ride"] = 801.94}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 11.04, ["Ride"] = 23.86, ["Fly|Ride"] = 262.5, ["Neon"] = 167.28, ["Neon|Ride"] = 177.5, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 629.9, ["Mega|Ride"] = 568.38, ["Mega|Fly|Ride"] = 546}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 393.65, ["Ride"] = 421.19, ["Fly|Ride"] = 518.36, ["Neon"] = 1752.19, ["Neon|Ride"] = 1423.1, ["Neon|Fly|Ride"] = 1102.5, ["Mega|Fly|Ride"] = 3346.87}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 2.63, ["Fly"] = 78.75, ["Ride"] = 28.87, ["Fly|Ride"] = 64.4, ["Neon"] = 198.17, ["Neon|Ride"] = 164.05, ["Neon|Fly|Ride"] = 142.64, ["Mega|Fly"] = 590.63, ["Mega|Ride"] = 561.1, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 3.76, ["Ride"] = 30.95, ["Fly|Ride"] = 127.32, ["Neon"] = 38.57, ["Neon|Ride"] = 221.82, ["Mega"] = 168.18, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 629.99}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 23.63, ["Ride"] = 84.54, ["Neon"] = 91.77, ["Neon|Ride"] = 173.52, ["Neon|Fly|Ride"] = 260.78, ["Mega"] = 346.03, ["Mega|Fly"] = 709.93, ["Mega|Ride"] = 314.79, ["Mega|Fly|Ride"] = 465.92}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.63, ["Ride"] = 22.32, ["Fly|Ride"] = 213.38, ["Neon"] = 7.39, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 276.31, ["Mega"] = 38.36, ["Mega|Ride"] = 128.29, ["Mega|Fly|Ride"] = 257.59}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 41.46, ["Ride"] = 91.74, ["Neon"] = 328.13, ["Neon|Ride"] = 249.14, ["Neon|Fly|Ride"] = 426.72, ["Mega"] = 1630.99, ["Mega|Ride"] = 2094.91, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 76.82, ["Ride"] = 26.25, ["Fly|Ride"] = 262.5, ["Neon"] = 7.39, ["Neon|Fly"] = 185.63, ["Neon|Ride"] = 48.2, ["Neon|Fly|Ride"] = 108.53, ["Mega"] = 59.07, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 225.75}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 21, ["Fly|Ride"] = 98.21, ["Neon"] = 3.73, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 48.97, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 27.68, ["Mega|Fly"] = 112.88, ["Mega|Ride"] = 68.24, ["Mega|Fly|Ride"] = 261.09}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Ride"] = 37.94, ["Fly|Ride"] = 127.62, ["Neon"] = 6.3, ["Neon|Ride"] = 55.49, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 70.28, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 314}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 45.85, ["Fly"] = 65.61, ["Ride"] = 61.57, ["Fly|Ride"] = 186.71, ["Neon"] = 262.45, ["Neon|Ride"] = 320.46, ["Neon|Fly|Ride"] = 484.26, ["Mega|Ride"] = 1135.68, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 203.44, ["Ride"] = 247.51, ["Fly|Ride"] = 318.94, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1470, ["Mega"] = 9665.03, ["Mega|Fly|Ride"] = 4724.99}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 3.59, ["Ride"] = 100.28, ["Neon"] = 21.8, ["Neon|Fly"] = 350.44, ["Mega"] = 102.38, ["Mega|Ride"] = 189, ["Mega|Fly|Ride"] = 262.4}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.1, ["Ride"] = 19.22, ["Fly|Ride"] = 162.29, ["Neon"] = 8.09, ["Neon|Ride"] = 41.99, ["Neon|Fly|Ride"] = 142.96, ["Mega"] = 38.74, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 91.54, ["Mega|Fly|Ride"] = 196.76}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 2.1, ["Fly"] = 106.45, ["Ride"] = 28.79, ["Fly|Ride"] = 91.88, ["Neon"] = 32.81, ["Mega"] = 212.89, ["Mega|Ride"] = 351.75, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 80.07, ["Ride"] = 31.45, ["Fly|Ride"] = 116.16, ["Neon"] = 18.27, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 139.11, ["Mega"] = 119.68, ["Mega|Fly"] = 118.12, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 347.82}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 59.07, ["Neon"] = 8.47, ["Neon|Fly|Ride"] = 142.96, ["Mega"] = 32.69, ["Mega|Ride"] = 72.19, ["Mega|Fly|Ride"] = 398.09}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 37.34, ["Ride"] = 19.03, ["Fly|Ride"] = 52.49, ["Neon"] = 3.94, ["Neon|Fly"] = 28.82, ["Neon|Ride"] = 28.23, ["Neon|Fly|Ride"] = 101.35, ["Mega"] = 36.2, ["Mega|Ride"] = 99.68, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.52, ["Fly"] = 26.25, ["Ride"] = 17.8, ["Fly|Ride"] = 48.45, ["Neon"] = 14.44, ["Neon|Fly"] = 101.35, ["Neon|Ride"] = 39.68, ["Neon|Fly|Ride"] = 114.15, ["Mega"] = 156.15, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 728.44}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 33.65, ["Ride"] = 34.15, ["Fly|Ride"] = 78.75, ["Neon"] = 105, ["Neon|Ride"] = 187.37, ["Neon|Fly|Ride"] = 805.84, ["Mega"] = 393.75, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 527.68}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 67.2, ["Ride"] = 85.21, ["Fly|Ride"] = 139.13, ["Neon"] = 390.46, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 455.44, ["Mega"] = 1988.23, ["Mega|Ride"] = 1561.43, ["Mega|Fly|Ride"] = 1515.94}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 18.04, ["Fly|Ride"] = 144.38, ["Neon"] = 3.76, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 27.02, ["Neon|Fly|Ride"] = 142.64, ["Mega"] = 32.69, ["Mega|Fly"] = 672, ["Mega|Ride"] = 92.8, ["Mega|Fly|Ride"] = 247.53}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 14.34, ["Ride"] = 15.65, ["Fly|Ride"] = 39.38, ["Neon"] = 3.41, ["Neon|Fly"] = 28.75, ["Neon|Ride"] = 20.88, ["Neon|Fly|Ride"] = 61.69, ["Mega"] = 37.1, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 68.13, ["Mega|Fly|Ride"] = 96.88}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 2.98, ["Fly"] = 42.69, ["Ride"] = 24.25, ["Fly|Ride"] = 51.98, ["Neon"] = 48.37, ["Neon|Ride"] = 137.82, ["Mega"] = 531.13, ["Mega|Ride"] = 274.32, ["Mega|Fly|Ride"] = 369.35}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 393.65, ["Ride"] = 472.5, ["Fly|Ride"] = 446.25, ["Neon"] = 4267.11, ["Neon|Ride"] = 6562.5, ["Neon|Fly|Ride"] = 1771.88, ["Mega|Fly|Ride"] = 5701.5}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 52.41, ["Fly"] = 65.63, ["Ride"] = 42.69, ["Fly|Ride"] = 85.22, ["Neon"] = 215, ["Neon|Ride"] = 181.61, ["Neon|Fly|Ride"] = 183.75, ["Mega|Ride"] = 772.77, ["Mega|Fly|Ride"] = 912.76}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 21.94, ["Fly|Ride"] = 283.1, ["Neon"] = 7.87, ["Neon|Ride"] = 48.47, ["Neon|Fly|Ride"] = 141.63, ["Mega"] = 82.22, ["Mega|Ride"] = 145.85, ["Mega|Fly|Ride"] = 272.99}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 91.88, ["Ride"] = 65.63, ["Fly|Ride"] = 65.63, ["Neon"] = 47.23, ["Neon|Ride"] = 72.34, ["Mega|Fly|Ride"] = 318.26}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 27.2, ["Fly"] = 169.3, ["Ride"] = 37.7, ["Fly|Ride"] = 106.32, ["Neon"] = 194.25, ["Neon|Ride"] = 274.82, ["Neon|Fly|Ride"] = 319.24, ["Mega"] = 2554.47, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1002.75}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 95.82, ["Fly"] = 119.44, ["Ride"] = 114.58, ["Fly|Ride"] = 208.04, ["Neon"] = 323.26, ["Neon|Fly"] = 711.56, ["Neon|Ride"] = 484.26, ["Neon|Fly|Ride"] = 610.32, ["Mega"] = 8514.85, ["Mega|Fly|Ride"] = 2493.75}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 236.25, ["Ride"] = 250.3, ["Fly|Ride"] = 532.33, ["Neon"] = 708.75, ["Neon|Ride"] = 622.58, ["Neon|Fly|Ride"] = 1029.06, ["Mega|Fly|Ride"] = 3399.57}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 26.17, ["Ride"] = 28.82, ["Fly|Ride"] = 142.96, ["Neon"] = 66.15, ["Neon|Fly"] = 121.07, ["Neon|Ride"] = 89.15, ["Neon|Fly|Ride"] = 313.69, ["Mega"] = 389.8, ["Mega|Ride"] = 404.8, ["Mega|Fly|Ride"] = 485.29}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 25.09, ["Ride"] = 15.4, ["Fly|Ride"] = 43.32, ["Neon"] = 7.69, ["Neon|Ride"] = 23.48, ["Neon|Fly|Ride"] = 92.84, ["Mega"] = 93.18, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 187.59}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 2.1, ["Fly"] = 45.11, ["Ride"] = 15.43, ["Fly|Ride"] = 47.25, ["Neon"] = 31.49, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 87.92, ["Mega"] = 282.02, ["Mega|Ride"] = 437.35, ["Mega|Fly|Ride"] = 453.43}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 314.6, ["Ride"] = 328.13, ["Fly|Ride"] = 637.88, ["Neon"] = 1569.1, ["Neon|Ride"] = 1834.87, ["Neon|Fly|Ride"] = 1915.94, ["Mega"] = 10217.82, ["Mega|Fly|Ride"] = 5118.75}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 33.04, ["Neon"] = 3.94, ["Neon|Ride"] = 139.41, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 28.24, ["Mega|Ride"] = 82.69, ["Mega|Fly|Ride"] = 448.25}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 2.97, ["Fly"] = 23.48, ["Ride"] = 16.03, ["Fly|Ride"] = 39.37, ["Neon"] = 22.32, ["Neon|Ride"] = 38.01, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 227.14, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 212.89, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 15.75, ["Ride"] = 48.46, ["Neon"] = 81.38, ["Neon|Ride"] = 99.75, ["Neon|Fly|Ride"] = 369.3, ["Mega"] = 538.13, ["Mega|Ride"] = 573.2, ["Mega|Fly|Ride"] = 638.34}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 108.74, ["Fly"] = 128.02, ["Ride"] = 115.4, ["Fly|Ride"] = 130.97, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 568.32, ["Mega|Fly|Ride"] = 2379.57}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 18.02, ["Fly"] = 33.08, ["Ride"] = 25.94, ["Fly|Ride"] = 49.26, ["Neon"] = 128.03, ["Neon|Ride"] = 89.3, ["Neon|Fly|Ride"] = 141.21, ["Mega"] = 709.93, ["Mega|Ride"] = 472.5, ["Mega|Fly|Ride"] = 548.9}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 21.35, ["Neon"] = 3.15, ["Neon|Ride"] = 142.63, ["Mega"] = 25.99, ["Mega|Ride"] = 127.95, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 15.72, ["Fly|Ride"] = 83.22, ["Neon"] = 2.1, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 21.8, ["Neon|Fly|Ride"] = 83.2, ["Mega"] = 19.43, ["Mega|Fly"] = 97.13, ["Mega|Ride"] = 41.99, ["Mega|Fly|Ride"] = 109.99}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 14.79, ["Ride"] = 42.58, ["Fly|Ride"] = 131.15, ["Neon"] = 32.82, ["Neon|Ride"] = 85.4, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 161.15, ["Mega|Ride"] = 195.57, ["Mega|Fly|Ride"] = 302.01}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1179.93, ["Ride"] = 1282.15, ["Fly|Ride"] = 1371.57, ["Neon"] = 4376.12, ["Neon|Ride"] = 7112.2, ["Neon|Fly|Ride"] = 4410.07, ["Mega|Fly|Ride"] = 12600}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 401.63, ["Ride"] = 439.85, ["Fly|Ride"] = 561.65, ["Neon"] = 1680, ["Neon|Ride"] = 1640.63, ["Neon|Fly|Ride"] = 1749.53, ["Mega"] = 17029.68, ["Mega|Fly|Ride"] = 7222.73}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 286.13, ["Fly"] = 351.75, ["Ride"] = 333.39, ["Fly|Ride"] = 420, ["Neon"] = 590.62, ["Neon|Fly"] = 1130.75, ["Neon|Ride"] = 672.81, ["Neon|Fly|Ride"] = 656.25, ["Mega|Fly|Ride"] = 2916.23}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 223.12, ["Fly"] = 363.4, ["Ride"] = 255.84, ["Fly|Ride"] = 367.5, ["Neon"] = 708.75, ["Neon|Ride"] = 603.74, ["Neon|Fly|Ride"] = 656.23, ["Mega|Fly|Ride"] = 3021.72}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 15.62, ["Ride"] = 15.06, ["Fly|Ride"] = 39.37, ["Neon"] = 3.84, ["Neon|Ride"] = 30.15, ["Neon|Fly|Ride"] = 105, ["Mega"] = 69.54, ["Mega|Fly"] = 112.84, ["Mega|Ride"] = 72.19, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 229.85, ["Fly"] = 1422.92, ["Ride"] = 300.57, ["Fly|Ride"] = 433.13, ["Neon"] = 859.69, ["Neon|Ride"] = 1351.63, ["Neon|Fly|Ride"] = 1018.81, ["Mega"] = 21571.29, ["Mega|Ride"] = 5108.92, ["Mega|Fly|Ride"] = 3975.38}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 3.83, ["Fly"] = 157.5, ["Ride"] = 70.26, ["Fly|Ride"] = 91.87, ["Neon"] = 25.75, ["Neon|Fly"] = 37.55, ["Neon|Ride"] = 112.88, ["Neon|Fly|Ride"] = 255.28, ["Mega"] = 172.53, ["Mega|Ride"] = 288.35, ["Mega|Fly|Ride"] = 370.77}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 18.12, ["Ride"] = 15.88, ["Fly|Ride"] = 38.98, ["Neon"] = 7.87, ["Neon|Ride"] = 42.65, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 104.81, ["Mega|Ride"] = 192.31}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 57.18, ["Neon"] = 2.1, ["Neon|Ride"] = 45.94, ["Mega"] = 28.74, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 177.62}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 28.76, ["Ride"] = 53.36, ["Fly|Ride"] = 459.38, ["Neon"] = 244.13, ["Neon|Ride"] = 355.56, ["Mega"] = 1050, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 773.07}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 8038.15, ["Ride"] = 26.66, ["Fly|Ride"] = 68.25, ["Neon"] = 3.84, ["Mega"] = 356.57, ["Mega|Ride"] = 411.92, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.13, ["Neon"] = 2.1, ["Neon|Ride"] = 50.19, ["Neon|Fly|Ride"] = 118.11, ["Mega"] = 20.07, ["Mega|Ride"] = 70.26, ["Mega|Fly|Ride"] = 157.52}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.43, ["Fly"] = 42.51, ["Ride"] = 30.35, ["Fly|Ride"] = 76.13, ["Neon"] = 15.23, ["Neon|Fly"] = 114.15, ["Neon|Ride"] = 41.58, ["Neon|Fly|Ride"] = 105, ["Mega"] = 137.55, ["Mega|Ride"] = 113.89, ["Mega|Fly|Ride"] = 239.22}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 6.07, ["Fly"] = 57.62, ["Ride"] = 19.23, ["Fly|Ride"] = 50.3, ["Neon"] = 30.19, ["Neon|Fly"] = 145.29, ["Neon|Ride"] = 142.96, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 238.83, ["Mega|Ride"] = 251.07, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 9.93, ["Ride"] = 52.5, ["Neon"] = 92.9, ["Neon|Ride"] = 185.63, ["Neon|Fly|Ride"] = 317.76, ["Mega"] = 427.07, ["Mega|Ride"] = 797.22}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 19.69, ["Neon"] = 49.68, ["Neon|Fly"] = 49.23, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 284.85, ["Mega"] = 328.13, ["Mega|Ride"] = 420.44, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 65.01, ["Ride"] = 15.75, ["Fly|Ride"] = 45.83, ["Neon"] = 3.59, ["Neon|Fly"] = 32.02, ["Neon|Ride"] = 28.54, ["Neon|Fly|Ride"] = 100.29, ["Mega"] = 45.94, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 163.61, ["Fly"] = 260.28, ["Ride"] = 164, ["Fly|Ride"] = 229.69, ["Neon"] = 801.17, ["Neon|Ride"] = 909.21, ["Neon|Fly|Ride"] = 826.76, ["Mega"] = 8514.85, ["Mega|Fly|Ride"] = 3987.17}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 19.06, ["Ride"] = 15.2, ["Fly|Ride"] = 35.44, ["Neon"] = 2.63, ["Neon|Fly"] = 40.56, ["Neon|Ride"] = 21.31, ["Neon|Fly|Ride"] = 47.23, ["Mega"] = 25.99, ["Mega|Ride"] = 53.29, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 10.2, ["Ride"] = 40.15, ["Fly|Ride"] = 196.88, ["Neon"] = 55.59, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 774.83, ["Mega"] = 313.69, ["Mega|Ride"] = 309.75, ["Mega|Fly|Ride"] = 379.32}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 26.12, ["Ride"] = 309.67, ["Fly|Ride"] = 170.63, ["Neon"] = 155.92, ["Neon|Ride"] = 355.69, ["Neon|Fly|Ride"] = 136.4, ["Mega"] = 786.19, ["Mega|Ride"] = 643.19, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 190.32, ["Fly"] = 304.5, ["Ride"] = 246.75, ["Fly|Ride"] = 296.63, ["Neon"] = 804.27, ["Neon|Fly"] = 807.52, ["Neon|Ride"] = 695.63, ["Neon|Fly|Ride"] = 756, ["Mega|Fly|Ride"] = 3511.49}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 14.44, ["Ride"] = 159.91, ["Fly|Ride"] = 145.35, ["Neon"] = 59.07, ["Neon|Ride"] = 213.38, ["Mega"] = 287.44, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 340.61}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 7.02, ["Ride"] = 57.75, ["Fly|Ride"] = 639.08, ["Neon"] = 114.28, ["Neon|Fly"] = 162.24, ["Neon|Ride"] = 211.87, ["Neon|Fly|Ride"] = 163.21, ["Mega"] = 709.93, ["Mega|Ride"] = 851.5, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 905.63, ["Ride"] = 948.82, ["Fly|Ride"] = 1036.88, ["Neon|Ride"] = 4790.63, ["Neon|Fly|Ride"] = 4651.16, ["Mega|Fly|Ride"] = 17028.62}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 6.22, ["Fly"] = 21.31, ["Ride"] = 20.79, ["Fly|Ride"] = 61.89, ["Neon"] = 21.35, ["Neon|Fly"] = 59.94, ["Neon|Ride"] = 55.13, ["Neon|Fly|Ride"] = 212.89, ["Mega"] = 219.19, ["Mega|Fly|Ride"] = 338.48}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 6.32, ["Fly"] = 78.75, ["Ride"] = 36.3, ["Fly|Ride"] = 54.42, ["Neon"] = 40.24, ["Neon|Ride"] = 81.13, ["Neon|Fly|Ride"] = 157.4, ["Mega"] = 527.94, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 210}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Fly"] = 85.35, ["Ride"] = 23.89, ["Fly|Ride"] = 89.63, ["Neon"] = 6.24, ["Neon|Ride"] = 46.38, ["Neon|Fly|Ride"] = 170.62, ["Mega"] = 69.54, ["Mega|Ride"] = 351.25, ["Mega|Fly|Ride"] = 386.61}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 10.28, ["Fly"] = 26.25, ["Ride"] = 38.75, ["Fly|Ride"] = 93.54, ["Neon"] = 66.94, ["Neon|Fly"] = 143.83, ["Neon|Ride"] = 91.65, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 435.75, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 2.1, ["Fly"] = 20.48, ["Ride"] = 15.63, ["Fly|Ride"] = 51.91, ["Neon"] = 17.07, ["Neon|Fly"] = 42.74, ["Neon|Ride"] = 29.77, ["Neon|Fly|Ride"] = 63, ["Mega"] = 101.07, ["Mega|Fly"] = 280.98, ["Mega|Ride"] = 126.68, ["Mega|Fly|Ride"] = 186.27}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 6.45, ["Fly"] = 32.75, ["Ride"] = 19.69, ["Neon"] = 9.18, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 43.31, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 124.48, ["Mega|Ride"] = 201.77, ["Mega|Fly|Ride"] = 483.27}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 213.35, ["Fly"] = 237.87, ["Ride"] = 262.5, ["Fly|Ride"] = 426.72, ["Neon"] = 923.85, ["Neon|Fly|Ride"] = 1183.01, ["Mega|Fly|Ride"] = 3762.51}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Fly"] = 32.8, ["Ride"] = 28.82, ["Fly|Ride"] = 108.94, ["Neon"] = 6.3, ["Neon|Fly"] = 34.17, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 74.52, ["Mega|Fly"] = 425.76, ["Mega|Ride"] = 127.37, ["Mega|Fly|Ride"] = 284.2}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 3.15, ["Ride"] = 83.06, ["Fly|Ride"] = 88.86, ["Neon"] = 27.85, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 188.15, ["Mega"] = 175.88, ["Mega|Ride"] = 321.57, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 3.35, ["Fly"] = 94.73, ["Ride"] = 19.48, ["Neon"] = 10.49, ["Neon|Ride"] = 85.28, ["Mega"] = 94.37, ["Mega|Ride"] = 120.52, ["Mega|Fly|Ride"] = 459.17}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 65.62, ["Ride"] = 104.99, ["Fly|Ride"] = 315, ["Neon"] = 493.85, ["Neon|Ride"] = 392.44, ["Neon|Fly|Ride"] = 646.49, ["Mega"] = 2554.47, ["Mega|Ride"] = 1611.66, ["Mega|Fly|Ride"] = 1277.07}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 23.24, ["Fly"] = 90.76, ["Ride"] = 42.52, ["Fly|Ride"] = 256.04, ["Neon"] = 150.93, ["Neon|Ride"] = 164.3, ["Neon|Fly|Ride"] = 341.93, ["Mega"] = 639.63, ["Mega|Ride"] = 610.96, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 20.46, ["Fly"] = 57.49, ["Ride"] = 32.82, ["Fly|Ride"] = 97.13, ["Neon"] = 70.86, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 242.24, ["Mega"] = 425.96, ["Mega|Ride"] = 392.77, ["Mega|Fly|Ride"] = 459.37}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 6.42, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 236.15, ["Mega"] = 103.69, ["Mega|Ride"] = 163.13, ["Mega|Fly|Ride"] = 483.27}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 41.9, ["Fly"] = 74.78, ["Ride"] = 77.44, ["Fly|Ride"] = 153.63, ["Neon"] = 262.49, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 288.75, ["Neon|Fly|Ride"] = 284.85, ["Mega|Fly|Ride"] = 1011.71}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 19.46, ["Fly|Ride"] = 52.5, ["Neon"] = 5.9, ["Neon|Ride"] = 57.62, ["Neon|Fly|Ride"] = 126.97, ["Mega"] = 60.77, ["Mega|Ride"] = 283.14, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 19.55, ["Fly"] = 113.88, ["Ride"] = 33.78, ["Fly|Ride"] = 87.22, ["Neon"] = 70.11, ["Neon|Ride"] = 79.92, ["Neon|Fly|Ride"] = 210, ["Mega"] = 393.75, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 314, ["Mega|Fly|Ride"] = 424.69}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 35.44, ["Fly"] = 203.34, ["Ride"] = 75.99, ["Fly|Ride"] = 129.94, ["Neon"] = 258.57, ["Neon|Fly"] = 426.72, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 1382.61, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 14.99, ["Ride"] = 13.61, ["Fly|Ride"] = 28.54, ["Neon"] = 2.1, ["Neon|Fly"] = 24.47, ["Neon|Ride"] = 16.01, ["Neon|Fly|Ride"] = 39.37, ["Mega"] = 15.36, ["Mega|Fly"] = 120.83, ["Mega|Ride"] = 36.19, ["Mega|Fly|Ride"] = 93.44}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 2.1, ["Ride"] = 22.09, ["Fly|Ride"] = 131.25, ["Neon"] = 20.58, ["Neon|Ride"] = 65.6, ["Neon|Fly|Ride"] = 426.72, ["Mega"] = 227.07, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 392.43}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 10.06, ["Fly"] = 142.94, ["Ride"] = 44.01, ["Fly|Ride"] = 85.32, ["Neon"] = 110.13, ["Neon|Ride"] = 131.23, ["Neon|Fly|Ride"] = 210, ["Mega"] = 494.25, ["Mega|Ride"] = 444.94, ["Mega|Fly|Ride"] = 651}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 22, ["Neon"] = 2.1, ["Neon|Ride"] = 28.87, ["Neon|Fly|Ride"] = 95.81, ["Mega"] = 19.23, ["Mega|Ride"] = 55.13, ["Mega|Fly|Ride"] = 210.75}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 17.9, ["Fly"] = 203.65, ["Ride"] = 69.62, ["Fly|Ride"] = 131.25, ["Neon"] = 119.43, ["Neon|Ride"] = 232.32, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 653.54, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 544.69, ["Mega|Fly|Ride"] = 653.54}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 15.58, ["Fly"] = 42.61, ["Ride"] = 19.01, ["Fly|Ride"] = 98.44, ["Neon"] = 376.69, ["Neon|Ride"] = 118.18, ["Neon|Fly|Ride"] = 129.94, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 472.49}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 6.46, ["Ride"] = 47.25, ["Neon"] = 40.36, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 37.55, ["Neon|Fly|Ride"] = 709.93, ["Mega"] = 231, ["Mega|Ride"] = 267.41, ["Mega|Fly|Ride"] = 469.88}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 5.03, ["Fly"] = 72.19, ["Ride"] = 42, ["Fly|Ride"] = 196.88, ["Neon"] = 26.25, ["Neon|Ride"] = 88.55, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 213.69, ["Mega|Ride"] = 270.36, ["Mega|Fly|Ride"] = 362.45}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Fly"] = 42.69, ["Ride"] = 19.48, ["Fly|Ride"] = 196.88, ["Neon"] = 6.02, ["Neon|Ride"] = 39.38, ["Mega"] = 53.81, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 106.32, ["Mega|Fly|Ride"] = 281.01}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 58.15, ["Neon"] = 2.63, ["Neon|Ride"] = 48.44, ["Mega"] = 22.3, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 11.46}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 36.65, ["Fly"] = 100.28, ["Ride"] = 66.27, ["Fly|Ride"] = 79.9, ["Neon"] = 184.57, ["Neon|Ride"] = 213.38, ["Neon|Fly|Ride"] = 313.69, ["Mega"] = 1845.6, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 850.54}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.62, ["Neon|Ride"] = 27.45, ["Mega"] = 20.1, ["Mega|Ride"] = 121.36, ["Mega|Fly|Ride"] = 319.32}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 446.15, ["Fly"] = 498.75, ["Ride"] = 561.75, ["Fly|Ride"] = 605.56, ["Neon"] = 2845.1, ["Neon|Ride"] = 2026.88, ["Neon|Fly|Ride"] = 2703.23, ["Mega"] = 17029.68, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 33.72, ["Fly|Ride"] = 67.22, ["Neon"] = 35.39, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 114.15, ["Mega"] = 95.86, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 568.38}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.1, ["Fly"] = 29.12, ["Ride"] = 16.7, ["Fly|Ride"] = 91.88, ["Neon"] = 19.57, ["Neon|Ride"] = 62.95, ["Neon|Fly|Ride"] = 99.65, ["Mega"] = 118.13, ["Mega|Fly"] = 284.2, ["Mega|Ride"] = 153.27, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 7.23, ["Fly"] = 71.48, ["Ride"] = 28.82, ["Fly|Ride"] = 71.49, ["Neon"] = 55.53, ["Neon|Ride"] = 142.96, ["Neon|Fly|Ride"] = 261.19, ["Mega"] = 724.89, ["Mega|Ride"] = 561.75, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 4.03, ["Fly"] = 57.62, ["Ride"] = 38.57, ["Fly|Ride"] = 711.56, ["Neon"] = 28.48, ["Neon|Fly"] = 36.28, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 392.44, ["Mega"] = 275.63, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 9.19, ["Ride"] = 96.03, ["Fly|Ride"] = 149.62, ["Neon"] = 72.55, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 273, ["Mega"] = 292.81, ["Mega|Ride"] = 392.15, ["Mega|Fly|Ride"] = 638.64}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 4.88, ["Fly"] = 105, ["Ride"] = 25.59, ["Fly|Ride"] = 72.19, ["Neon"] = 27.46, ["Neon|Ride"] = 79.19, ["Neon|Fly|Ride"] = 105, ["Mega"] = 227.07, ["Mega|Ride"] = 313.69, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 42.4, ["Ride"] = 13.8, ["Fly|Ride"] = 76.67, ["Neon"] = 2.1, ["Neon|Fly"] = 23.48, ["Neon|Ride"] = 15.88, ["Neon|Fly|Ride"] = 76.65, ["Mega"] = 15.44, ["Mega|Fly"] = 65.25, ["Mega|Ride"] = 35.41, ["Mega|Fly|Ride"] = 91.38}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 3.65, ["Fly"] = 54.42, ["Ride"] = 38.43, ["Fly|Ride"] = 106.32, ["Neon"] = 28.88, ["Neon|Fly"] = 121.07, ["Neon|Ride"] = 27.44, ["Neon|Fly|Ride"] = 196.27, ["Mega"] = 183.75, ["Mega|Ride"] = 209.9, ["Mega|Fly|Ride"] = 276.94}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 326.7, ["Fly"] = 375.51, ["Ride"] = 318.7, ["Fly|Ride"] = 360.94, ["Neon"] = 1312.5, ["Neon|Ride"] = 1246.88, ["Neon|Fly|Ride"] = 1253.44, ["Mega|Ride"] = 9375.09, ["Mega|Fly|Ride"] = 4681.05}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 79.68, ["Ride"] = 111.57, ["Fly|Ride"] = 274.94, ["Neon"] = 356.57, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 585.38, ["Mega"] = 2271.35, ["Mega|Ride"] = 1694.47, ["Mega|Fly|Ride"] = 1442.63}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 16.7, ["Ride"] = 15.54, ["Fly|Ride"] = 34.97, ["Neon"] = 5.24, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 34.16, ["Neon|Fly|Ride"] = 57.62, ["Mega"] = 142.64, ["Mega|Fly"] = 65.25, ["Mega|Ride"] = 78.91, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 22.57, ["Ride"] = 13.78, ["Fly|Ride"] = 34.54, ["Neon"] = 6.24, ["Neon|Fly"] = 42.61, ["Neon|Ride"] = 25.62, ["Neon|Fly|Ride"] = 56.33, ["Mega"] = 65.63, ["Mega|Fly"] = 284.2, ["Mega|Ride"] = 61.69, ["Mega|Fly|Ride"] = 185.21}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.1, ["Fly"] = 100.28, ["Ride"] = 22.31, ["Fly|Ride"] = 98.44, ["Neon"] = 100.06, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 425.76, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 223.13, ["Fly"] = 323.43, ["Ride"] = 215.36, ["Fly|Ride"] = 288.75, ["Neon"] = 1181.25, ["Neon|Ride"] = 1050, ["Neon|Fly|Ride"] = 1580.98, ["Mega|Ride"] = 8514.85, ["Mega|Fly|Ride"] = 3434.82}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 3.94, ["Fly"] = 16.75, ["Ride"] = 14.44, ["Fly|Ride"] = 40.68, ["Neon"] = 13.13, ["Neon|Fly"] = 104.97, ["Neon|Ride"] = 30.87, ["Neon|Fly|Ride"] = 75.7, ["Mega"] = 255.93, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 322.6}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 2.1, ["Ride"] = 75.54, ["Fly|Ride"] = 213.38, ["Neon"] = 28.82, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 284.85, ["Mega"] = 183.75, ["Mega|Ride"] = 300.19, ["Mega|Fly|Ride"] = 455.57}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 88.99, ["Neon"] = 6.45, ["Neon|Ride"] = 43.22, ["Mega"] = 78.65, ["Mega|Fly"] = 195.85, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 10.17, ["Fly"] = 49.03, ["Ride"] = 17.95, ["Fly|Ride"] = 67.1, ["Neon"] = 118.13, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 139.79, ["Mega"] = 460.69, ["Mega|Ride"] = 438.38, ["Mega|Fly|Ride"] = 587.9}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 38.07, ["Fly"] = 97.13, ["Ride"] = 78.74, ["Fly|Ride"] = 297.05, ["Neon"] = 103.58, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 160.76, ["Neon|Fly|Ride"] = 421.39, ["Mega"] = 465.94, ["Mega|Fly"] = 2235.16, ["Mega|Ride"] = 404.25, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 24.86, ["Fly"] = 62.94, ["Ride"] = 43.32, ["Fly|Ride"] = 98.44, ["Neon"] = 153.63, ["Neon|Fly"] = 286.43, ["Neon|Ride"] = 213.51, ["Neon|Fly|Ride"] = 223.13, ["Mega|Ride"] = 700.88, ["Mega|Fly|Ride"] = 820.32}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 18.59, ["Ride"] = 14.95, ["Fly|Ride"] = 29.77, ["Neon"] = 2.1, ["Neon|Fly"] = 31.39, ["Neon|Ride"] = 15.65, ["Neon|Fly|Ride"] = 46.96, ["Mega"] = 17.73, ["Mega|Fly"] = 426.01, ["Mega|Ride"] = 33.43, ["Mega|Fly|Ride"] = 94.23}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 184.95, ["Fly"] = 261.65, ["Ride"] = 231, ["Fly|Ride"] = 272.96, ["Neon"] = 2650.9, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 1058.12, ["Mega|Fly|Ride"] = 3972.19}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 10.68, ["Fly"] = 65.63, ["Ride"] = 41.91, ["Fly|Ride"] = 92.94, ["Neon"] = 91.88, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 430.5, ["Mega|Ride"] = 464.13, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 35.86, ["Ride"] = 18.74, ["Fly|Ride"] = 42.69, ["Neon"] = 5.24, ["Neon|Fly"] = 40.56, ["Neon|Ride"] = 27.75, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 59.21, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 199.05}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 19.59, ["Ride"] = 16.14, ["Fly|Ride"] = 45.94, ["Neon"] = 2.1, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 25.62, ["Neon|Fly|Ride"] = 113.81, ["Mega"] = 19.59, ["Mega|Fly"] = 142.64, ["Mega|Ride"] = 45.45, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 3.63, ["Ride"] = 24.04, ["Fly|Ride"] = 72.19, ["Neon"] = 16.92, ["Neon|Fly"] = 726.39, ["Neon|Ride"] = 49.87, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 103.69, ["Mega|Ride"] = 131.78, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 3.94, ["Fly"] = 38.66, ["Ride"] = 21.66, ["Fly|Ride"] = 70.88, ["Neon"] = 48.27, ["Neon|Fly"] = 270.97, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 93.19, ["Mega"] = 355.69, ["Mega|Ride"] = 370.12, ["Mega|Fly|Ride"] = 354.89}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 6.39, ["Ride"] = 64.97, ["Neon"] = 55.13, ["Neon|Ride"] = 149.37, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 234.94, ["Mega|Ride"] = 314, ["Mega|Fly|Ride"] = 411.92}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 100.36, ["Mega"] = 52.41, ["Mega|Ride"] = 85.31, ["Mega|Fly|Ride"] = 159.67}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 6.19, ["Ride"] = 27.78, ["Fly|Ride"] = 131.25, ["Neon"] = 32.81, ["Neon|Fly"] = 102.8, ["Neon|Ride"] = 46.87, ["Neon|Fly|Ride"] = 285.08, ["Mega"] = 253.33, ["Mega|Ride"] = 212.63, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Fly"] = 71.48, ["Ride"] = 85.36, ["Neon"] = 3.5, ["Neon|Fly"] = 114.15, ["Neon|Ride"] = 45.78, ["Neon|Fly|Ride"] = 102.36, ["Mega"] = 24.19, ["Mega|Ride"] = 105.39, ["Mega|Fly|Ride"] = 142.64}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 45.46, ["Ride"] = 18.8, ["Fly|Ride"] = 40.58, ["Neon"] = 3.83, ["Neon|Ride"] = 21.84, ["Neon|Fly|Ride"] = 107.63, ["Mega"] = 54.74, ["Mega|Fly"] = 142.64, ["Mega|Ride"] = 79.26, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 656.13, ["Ride"] = 685.12, ["Fly|Ride"] = 735, ["Neon"] = 2624.99, ["Neon|Ride"] = 4960.52, ["Neon|Fly|Ride"] = 3674.97, ["Mega|Fly|Ride"] = 12726.44}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 14.96, ["Ride"] = 15.33, ["Fly|Ride"] = 36.33, ["Neon"] = 11.81, ["Neon|Fly"] = 42.58, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 98.44, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.1, ["Ride"] = 43.62, ["Neon"] = 8.54, ["Neon|Fly"] = 142.96, ["Neon|Ride"] = 106.7, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 56.42, ["Mega|Fly"] = 149.03, ["Mega|Ride"] = 249.26, ["Mega|Fly|Ride"] = 257.15}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 3.94, ["Fly"] = 41.2, ["Ride"] = 20.99, ["Fly|Ride"] = 56.43, ["Neon"] = 64.02, ["Neon|Fly"] = 193.27, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 71.49, ["Mega"] = 485.63, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 347.8}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 16.99, ["Ride"] = 14.32, ["Fly|Ride"] = 41.99, ["Neon"] = 3.94, ["Neon|Fly"] = 149.37, ["Neon|Ride"] = 22.52, ["Neon|Fly|Ride"] = 51.97, ["Mega"] = 59.06, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 177.28}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 35.35, ["Ride"] = 57.49, ["Fly|Ride"] = 284.85, ["Neon"] = 169.2, ["Neon|Ride"] = 223.12, ["Neon|Fly|Ride"] = 318.98, ["Mega|Ride"] = 624.8}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 17.61, ["Fly|Ride"] = 76.13, ["Neon"] = 5.2, ["Neon|Fly"] = 138.03, ["Neon|Ride"] = 26.87, ["Neon|Fly|Ride"] = 119.43, ["Mega"] = 43.22, ["Mega|Ride"] = 132.12, ["Mega|Fly|Ride"] = 229.68}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.63, ["Fly"] = 73.41, ["Ride"] = 23.48, ["Fly|Ride"] = 56.86, ["Neon"] = 11.55, ["Neon|Ride"] = 42.63, ["Neon|Fly|Ride"] = 142.96, ["Mega"] = 69.46, ["Mega|Ride"] = 71.32, ["Mega|Fly|Ride"] = 351.75}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly|Ride"] = 78.75, ["Neon"] = 21.29, ["Mega"] = 97.12, ["Mega|Ride"] = 159.67, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 42, ["Ride"] = 14.64, ["Fly|Ride"] = 50.15, ["Neon"] = 2.1, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 20.13, ["Neon|Fly|Ride"] = 112.88, ["Mega"] = 36.74, ["Mega|Fly"] = 229.68, ["Mega|Ride"] = 81.47, ["Mega|Fly|Ride"] = 144.36}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 13.12, ["Fly"] = 21.29, ["Ride"] = 16.72, ["Fly|Ride"] = 39.38, ["Neon"] = 105, ["Neon|Ride"] = 80.85, ["Neon|Fly|Ride"] = 141.63, ["Mega|Ride"] = 314, ["Mega|Fly|Ride"] = 396.12}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 714.56, ["Fly"] = 937.54, ["Ride"] = 748.13, ["Fly|Ride"] = 820.32, ["Neon"] = 1914.41, ["Neon|Ride"] = 1661.63, ["Neon|Fly|Ride"] = 1959.57, ["Mega"] = 4654.13, ["Mega|Ride"] = 5677.29, ["Mega|Fly|Ride"] = 5678.22}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 16.02, ["Ride"] = 14.32, ["Fly|Ride"] = 27.57, ["Neon"] = 2.63, ["Neon|Fly"] = 36.28, ["Neon|Ride"] = 17.53, ["Neon|Fly|Ride"] = 42.69, ["Mega"] = 54.45, ["Mega|Ride"] = 63, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 6.57, ["Ride"] = 23.02, ["Fly|Ride"] = 241.65, ["Neon"] = 48.47, ["Neon|Ride"] = 112.52, ["Neon|Fly|Ride"] = 208.68, ["Mega"] = 403.57, ["Mega|Ride"] = 355.69, ["Mega|Fly|Ride"] = 393.73}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 45.94, ["Fly"] = 104.9, ["Ride"] = 70.95, ["Fly|Ride"] = 105, ["Neon"] = 315, ["Neon|Ride"] = 454.47, ["Neon|Fly|Ride"] = 370.18, ["Mega"] = 1702.98, ["Mega|Fly|Ride"] = 1413.47}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 29.89, ["Ride"] = 61.69, ["Fly|Ride"] = 104.9, ["Neon"] = 187.69, ["Neon|Ride"] = 224.03, ["Mega"] = 1289.25, ["Mega|Ride"] = 896.44, ["Mega|Fly|Ride"] = 816.38}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 9.87, ["Fly"] = 87.23, ["Ride"] = 26.24, ["Fly|Ride"] = 142.96, ["Neon"] = 48.44, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 266.25, ["Mega"] = 305.82, ["Mega|Ride"] = 261.19, ["Mega|Fly|Ride"] = 460.68}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 22.3, ["Ride"] = 53.36, ["Neon"] = 85.32, ["Neon|Ride"] = 328.46, ["Neon|Fly|Ride"] = 146.24, ["Mega"] = 283.88, ["Mega|Fly"] = 524.34, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 16.75, ["Fly"] = 128.02, ["Ride"] = 77.44, ["Neon"] = 120.75, ["Neon|Ride"] = 323.26, ["Neon|Fly|Ride"] = 525, ["Mega"] = 525, ["Mega|Fly"] = 567, ["Mega|Ride"] = 476.44, ["Mega|Fly|Ride"] = 741.57}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 7.88}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 3.49, ["Fly"] = 131248.69, ["Ride"] = 24.92, ["Fly|Ride"] = 72.56, ["Neon"] = 38.76, ["Neon|Ride"] = 50.47, ["Neon|Fly|Ride"] = 213.62, ["Mega"] = 196.88, ["Mega|Fly"] = 481.1, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 287.82}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.1, ["Ride"] = 46.85, ["Neon"] = 10.48, ["Neon|Fly|Ride"] = 213.38, ["Mega"] = 135.19, ["Mega|Fly|Ride"] = 483.27}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 30.85, ["Fly"] = 63, ["Ride"] = 30.19, ["Fly|Ride"] = 80.01, ["Neon"] = 203.23, ["Neon|Ride"] = 169.63, ["Neon|Fly|Ride"] = 236.25, ["Mega|Ride"] = 681.75, ["Mega|Fly|Ride"] = 725.13}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.84, ["Fly"] = 17.07, ["Ride"] = 14.19, ["Fly|Ride"] = 30.19, ["Neon"] = 18.88, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 28.69, ["Neon|Fly|Ride"] = 65.61, ["Mega"] = 198.19, ["Mega|Fly"] = 424.69, ["Mega|Ride"] = 155.5, ["Mega|Fly|Ride"] = 233.63}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 5.81, ["Fly"] = 37.37, ["Ride"] = 28.13, ["Fly|Ride"] = 56.27, ["Neon"] = 17.07, ["Neon|Ride"] = 45.04, ["Neon|Fly|Ride"] = 128.01, ["Mega"] = 152.24, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 143.07, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Ride"] = 71.48, ["Neon"] = 6.22, ["Mega"] = 56.8, ["Mega|Ride"] = 203.43, ["Mega|Fly|Ride"] = 258.57}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 28.25, ["Fly"] = 78.75, ["Ride"] = 49.53, ["Fly|Ride"] = 105, ["Neon"] = 217.64, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 506.06, ["Mega"] = 524.99, ["Mega|Ride"] = 911.1, ["Mega|Fly|Ride"] = 834.15}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 20.99, ["Fly|Ride"] = 65.63, ["Neon"] = 4.56, ["Neon|Fly"] = 203.44, ["Neon|Ride"] = 50.15, ["Mega"] = 55.01, ["Mega|Ride"] = 139.94}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 7.6, ["Ride"] = 81.15, ["Fly|Ride"] = 283.77, ["Neon"] = 59.76, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 320.04, ["Mega"] = 399, ["Mega|Fly|Ride"] = 688.66}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 45.91, ["Ride"] = 14.44, ["Fly|Ride"] = 41.91, ["Neon"] = 16.96, ["Neon|Ride"] = 27.45, ["Neon|Fly|Ride"] = 48.35, ["Mega"] = 194.25, ["Mega|Ride"] = 208.04, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 2.1, ["Fly"] = 52.49, ["Ride"] = 23.02, ["Fly|Ride"] = 68.61, ["Neon"] = 40.69, ["Neon|Ride"] = 36.75, ["Mega"] = 398.09, ["Mega|Ride"] = 424.69, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 4.36, ["Ride"] = 75.99, ["Neon"] = 88.86, ["Neon|Ride"] = 77.43, ["Mega"] = 413.86, ["Mega|Ride"] = 366.19, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 31.5, ["Ride"] = 132.38, ["Neon"] = 270.97, ["Neon|Ride"] = 390.46, ["Neon|Fly|Ride"] = 630, ["Mega"] = 1758.33, ["Mega|Ride"] = 1308.57, ["Mega|Fly|Ride"] = 1063.31}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 11.74, ["Ride"] = 106.7, ["Neon"] = 100.29, ["Neon|Ride"] = 183.75, ["Mega"] = 341.16, ["Mega|Ride"] = 553.48, ["Mega|Fly|Ride"] = 610.96}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 15.75, ["Ride"] = 126, ["Neon"] = 57.75, ["Neon|Fly"] = 213.38, ["Neon|Ride"] = 170.63, ["Mega"] = 805.84, ["Mega|Ride"] = 849.36, ["Mega|Fly|Ride"] = 568.38}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 18.2, ["Ride"] = 69.57, ["Fly|Ride"] = 367.47, ["Neon"] = 107.63, ["Neon|Ride"] = 262.49, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 643.13, ["Mega|Fly"] = 2128.72, ["Mega|Ride"] = 724.89, ["Mega|Fly|Ride"] = 744}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 3.05, ["Neon"] = 14.44, ["Neon|Ride"] = 81.13, ["Neon|Fly|Ride"] = 142.96, ["Mega"] = 185.21, ["Mega|Fly|Ride"] = 322.59}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 27.75, ["Ride"] = 14.44, ["Fly|Ride"] = 42.69, ["Neon"] = 5.95, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 22.56, ["Neon|Fly|Ride"] = 93.19, ["Mega"] = 69.17, ["Mega|Ride"] = 71.31, ["Mega|Fly|Ride"] = 142.64}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 2.1, ["Fly"] = 51.19, ["Ride"] = 22.97, ["Fly|Ride"] = 69.56, ["Neon"] = 11.17, ["Neon|Ride"] = 117.36, ["Neon|Fly|Ride"] = 114.15, ["Mega"] = 77.59, ["Mega|Ride"] = 110.25, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 15.75, ["Fly|Ride"] = 39.37, ["Neon"] = 3.81, ["Neon|Ride"] = 19.28, ["Neon|Fly|Ride"] = 107.62, ["Mega"] = 43.22, ["Mega|Fly"] = 113.9, ["Mega|Ride"] = 83.99, ["Mega|Fly|Ride"] = 199.05}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.19, ["Fly"] = 65.62, ["Ride"] = 23.48, ["Fly|Ride"] = 84, ["Neon"] = 18.17, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 85.36, ["Mega"] = 255.46, ["Mega|Ride"] = 324.19, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.94, ["Fly"] = 49.6, ["Ride"] = 24.39, ["Fly|Ride"] = 53.82, ["Neon"] = 28.69, ["Neon|Fly"] = 315, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 150.94, ["Mega"] = 302.45, ["Mega|Ride"] = 287.46}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 6.3, ["Fly"] = 131.25, ["Ride"] = 21.94, ["Fly|Ride"] = 71.31, ["Neon"] = 19.59, ["Neon|Fly"] = 114.15, ["Neon|Ride"] = 29.75, ["Neon|Fly|Ride"] = 32.71, ["Mega"] = 294, ["Mega|Ride"] = 232.62, ["Mega|Fly|Ride"] = 285.12}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 21.35, ["Fly|Ride"] = 49.88, ["Neon"] = 22.22, ["Neon|Ride"] = 42.29, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 256.25, ["Mega|Ride"] = 166.08, ["Mega|Fly|Ride"] = 186.18}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 44.73, ["Fly|Ride"] = 91.86, ["Neon"] = 9.09, ["Neon|Fly"] = 437.05, ["Neon|Ride"] = 61.39, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 99.75, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 132.11, ["Mega|Fly|Ride"] = 209.25}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 16.27, ["Fly"] = 213.35, ["Ride"] = 106, ["Fly|Ride"] = 375.16, ["Neon"] = 91.88, ["Neon|Ride"] = 275.63, ["Neon|Fly|Ride"] = 378, ["Mega"] = 472.5, ["Mega|Ride"] = 592.1, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 46.09, ["Fly"] = 164.07, ["Ride"] = 82.69, ["Fly|Ride"] = 189, ["Neon"] = 200.49, ["Neon|Ride"] = 184.69, ["Neon|Fly|Ride"] = 350.63, ["Mega"] = 1338.6, ["Mega|Ride"] = 951.23, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 51.08, ["Ride"] = 18.37, ["Fly|Ride"] = 118.12, ["Neon"] = 2.1, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 24.19, ["Mega|Ride"] = 56.59, ["Mega|Fly|Ride"] = 145.47}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 6.19, ["Ride"] = 52.5, ["Neon"] = 117.7, ["Mega"] = 686.56, ["Mega|Ride"] = 681.19, ["Mega|Fly|Ride"] = 1123.98}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 46.99, ["Ride"] = 91.89, ["Neon"] = 343.84, ["Neon|Ride"] = 229.69, ["Neon|Fly|Ride"] = 852.37, ["Mega"] = 1753.01, ["Mega|Ride"] = 1135.68, ["Mega|Fly|Ride"] = 1966.94}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 5.25, ["Fly"] = 190.32, ["Ride"] = 27.57, ["Fly|Ride"] = 114.15, ["Neon"] = 40.67, ["Neon|Fly"] = 129.55, ["Neon|Ride"] = 70.88, ["Neon|Fly|Ride"] = 123.77, ["Mega"] = 187.69, ["Mega|Ride"] = 228.36, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 6.24, ["Ride"] = 68.83, ["Fly|Ride"] = 111.57, ["Neon"] = 12.87, ["Neon|Ride"] = 68.23, ["Neon|Fly|Ride"] = 142.64, ["Mega"] = 104.89, ["Mega|Ride"] = 140.44, ["Mega|Fly|Ride"] = 851.5}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 22.32, ["Ride"] = 16.3, ["Fly|Ride"] = 45.94, ["Neon"] = 12.66, ["Neon|Ride"] = 44.43, ["Neon|Fly|Ride"] = 71.32, ["Mega"] = 170.31, ["Mega|Fly"] = 196.86, ["Mega|Ride"] = 85.16, ["Mega|Fly|Ride"] = 267.75}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 17.63, ["Ride"] = 15.49, ["Fly|Ride"] = 41.91, ["Neon"] = 2.1, ["Neon|Fly"] = 33.46, ["Neon|Ride"] = 26.16, ["Neon|Fly|Ride"] = 53.38, ["Mega"] = 28.87, ["Mega|Ride"] = 69.56, ["Mega|Fly|Ride"] = 150.73}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 15.23, ["Fly|Ride"] = 85.17, ["Neon"] = 3.68, ["Neon|Ride"] = 23.39, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 39.37, ["Mega|Fly"] = 111.02, ["Mega|Ride"] = 55.36, ["Mega|Fly|Ride"] = 183.74}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 2.37, ["Neon|Ride"] = 145.07, ["Mega"] = 28.23, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 328.02}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 4.23, ["Ride"] = 104.99, ["Neon"] = 37.96, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 185.21, ["Mega|Fly|Ride"] = 322.59}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 5.74, ["Ride"] = 28.82, ["Fly|Ride"] = 213.17, ["Neon"] = 53.72, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 142.96, ["Mega"] = 196.88, ["Mega|Ride"] = 351.75, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 5.81, ["Fly"] = 20.79, ["Ride"] = 15.27, ["Fly|Ride"] = 37.97, ["Neon"] = 28.25, ["Neon|Fly"] = 58.12, ["Neon|Ride"] = 32.71, ["Neon|Fly|Ride"] = 83.51, ["Mega"] = 314, ["Mega|Ride"] = 232.01, ["Mega|Fly|Ride"] = 352.69}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 60.29, ["Ride"] = 98.44, ["Fly|Ride"] = 262.5, ["Neon"] = 357.15, ["Neon|Ride"] = 425.65, ["Neon|Fly|Ride"] = 711.56, ["Mega"] = 2416.26, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 16.94, ["Fly"] = 82.69, ["Ride"] = 43.22, ["Fly|Ride"] = 51.19, ["Neon"] = 284.85, ["Neon|Fly|Ride"] = 630, ["Mega"] = 645.16, ["Mega|Ride"] = 879.38, ["Mega|Fly|Ride"] = 709.93}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 15.64, ["Ride"] = 15.75, ["Fly|Ride"] = 38, ["Neon"] = 2.1, ["Neon|Fly"] = 42.69, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 57.62, ["Mega"] = 30.32, ["Mega|Ride"] = 92.51, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 21.2, ["Ride"] = 14.77, ["Fly|Ride"] = 31.27, ["Neon"] = 3.63, ["Neon|Fly"] = 28.73, ["Neon|Ride"] = 18.51, ["Neon|Fly|Ride"] = 43.31, ["Mega"] = 39.38, ["Mega|Fly"] = 122.41, ["Mega|Ride"] = 65.01, ["Mega|Fly|Ride"] = 91.77}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 514.5, ["Fly"] = 565.67, ["Ride"] = 439.69, ["Fly|Ride"] = 426.57, ["Neon|Fly|Ride"] = 1897.82}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 3.04, ["Fly"] = 106.68, ["Ride"] = 57.62, ["Fly|Ride"] = 114.15, ["Neon"] = 39.15, ["Neon|Fly"] = 48.44, ["Neon|Ride"] = 81.13, ["Mega"] = 403.5, ["Mega|Ride"] = 400.32, ["Mega|Fly|Ride"] = 1064.37}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 15.6, ["Ride"] = 19, ["Fly|Ride"] = 32.97, ["Neon"] = 8.33, ["Neon|Fly"] = 18.12, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 32.71, ["Mega|Ride"] = 79.86, ["Mega|Fly|Ride"] = 106.42}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 51.19, ["Ride"] = 98.05, ["Fly|Ride"] = 261.19, ["Neon"] = 227.07, ["Neon|Ride"] = 317.12, ["Neon|Fly|Ride"] = 392.43, ["Mega"] = 735, ["Mega|Ride"] = 761.25, ["Mega|Fly|Ride"] = 878.37}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 26.98, ["Ride"] = 13.79, ["Fly|Ride"] = 45.94, ["Neon"] = 13.01, ["Neon|Fly"] = 75.87, ["Neon|Ride"] = 24.82, ["Neon|Fly|Ride"] = 70.66, ["Mega"] = 118.13, ["Mega|Ride"] = 143.06, ["Mega|Fly|Ride"] = 193.71}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 71.48, ["Ride"] = 32.82, ["Fly|Ride"] = 196.88, ["Neon"] = 2.1, ["Neon|Fly"] = 100.29, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 75.07, ["Mega"] = 18.95, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 208.95}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 31.39, ["Fly"] = 128, ["Ride"] = 78.72, ["Fly|Ride"] = 213.56, ["Neon"] = 174.57, ["Neon|Ride"] = 191.01, ["Neon|Fly|Ride"] = 420, ["Mega"] = 805.84, ["Mega|Ride"] = 624.8, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Fly"] = 18.27, ["Ride"] = 18.27, ["Fly|Ride"] = 146.99, ["Neon"] = 6.71, ["Neon|Ride"] = 40.6, ["Neon|Fly|Ride"] = 78.95, ["Mega"] = 31.5, ["Mega|Ride"] = 152.15, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 31.5, ["Ride"] = 79.7, ["Fly|Ride"] = 121.63, ["Neon"] = 206.97, ["Neon|Ride"] = 246.78, ["Neon|Fly|Ride"] = 288.46, ["Mega"] = 1772.34, ["Mega|Ride"] = 1702.98}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 3.61, ["Fly"] = 71.48, ["Ride"] = 131.24, ["Fly|Ride"] = 426.72, ["Neon"] = 17.06, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 497.06, ["Mega"] = 212.89, ["Mega|Ride"] = 199.05, ["Mega|Fly|Ride"] = 355.51}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.1, ["Fly"] = 71.48, ["Ride"] = 72.02, ["Fly|Ride"] = 71.49, ["Neon"] = 8.11, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 432.36, ["Mega"] = 100.06, ["Mega|Ride"] = 124.69, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 36.11, ["Fly"] = 142.94, ["Ride"] = 59.19, ["Fly|Ride"] = 131.25, ["Mega|Ride"] = 1702.98, ["Mega|Fly|Ride"] = 1978.66}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 461.41, ["Ride"] = 28.73, ["Neon"] = 4.99, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 114.32, ["Mega"] = 41.91, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 118.11, ["Mega|Fly|Ride"] = 227.43}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 21.12, ["Ride"] = 15.49, ["Fly|Ride"] = 102.88, ["Neon"] = 10.49, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 26.22, ["Neon|Fly|Ride"] = 72.65, ["Mega"] = 161.9, ["Mega|Fly"] = 148.62, ["Mega|Fly|Ride"] = 219.19}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 7.48, ["Fly"] = 57.91, ["Ride"] = 32.73, ["Fly|Ride"] = 126.97, ["Neon"] = 79.94, ["Neon|Ride"] = 65.62, ["Neon|Fly|Ride"] = 144.27, ["Mega"] = 328.11, ["Mega|Ride"] = 275.62, ["Mega|Fly|Ride"] = 341.24}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 6.57, ["Fly"] = 52.5, ["Ride"] = 23.75, ["Fly|Ride"] = 76.82, ["Neon"] = 63.95, ["Neon|Ride"] = 83.28, ["Neon|Fly|Ride"] = 144.37, ["Mega"] = 483.27, ["Mega|Ride"] = 355.52, ["Mega|Fly|Ride"] = 562}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 24.69, ["Fly"] = 24.25, ["Ride"] = 26.25, ["Fly|Ride"] = 55, ["Neon"] = 74.28, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 123.77, ["Mega"] = 395.96, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 411.92}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 65.52, ["Ride"] = 92.81, ["Fly|Ride"] = 256.04, ["Neon"] = 346.5, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 565.39, ["Mega|Ride"] = 1509.27, ["Mega|Fly|Ride"] = 1312.49}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 4.93, ["Ride"] = 71.31, ["Neon"] = 55.13, ["Neon|Ride"] = 114.15, ["Neon|Fly|Ride"] = 296.09, ["Mega"] = 236.25, ["Mega|Ride"] = 284.2, ["Mega|Fly|Ride"] = 454.79}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 4.65, ["Ride"] = 27.2, ["Fly|Ride"] = 78.74, ["Neon"] = 15.51, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 262.49, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 246.62}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 6.03, ["Fly"] = 287.55, ["Ride"] = 35.43, ["Fly|Ride"] = 155.36, ["Neon"] = 41.62, ["Neon|Ride"] = 104.9, ["Mega"] = 451.85, ["Mega|Ride"] = 596.06, ["Mega|Fly|Ride"] = 761.25}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.65, ["Ride"] = 15.75, ["Fly|Ride"] = 38.36, ["Neon"] = 2.1, ["Neon|Fly"] = 28.82, ["Neon|Ride"] = 15.53, ["Neon|Fly|Ride"] = 44.63, ["Mega"] = 13.75, ["Mega|Ride"] = 26.76, ["Mega|Fly|Ride"] = 95.79}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 48.47, ["Ride"] = 112.56, ["Fly|Ride"] = 284.85, ["Neon"] = 210, ["Neon|Fly"] = 2418.39, ["Neon|Ride"] = 282.19, ["Neon|Fly|Ride"] = 488.25, ["Mega"] = 1063.31, ["Mega|Ride"] = 944.99, ["Mega|Fly|Ride"] = 879.38}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 15.9, ["Fly|Ride"] = 142.96, ["Neon"] = 4.96, ["Neon|Ride"] = 28.59, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 31.49, ["Mega|Ride"] = 142.64, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 28.82, ["Ride"] = 19.04, ["Fly|Ride"] = 59.06, ["Neon"] = 19.69, ["Neon|Ride"] = 28.25, ["Neon|Fly|Ride"] = 90.03, ["Mega"] = 257.25, ["Mega|Ride"] = 193.1, ["Mega|Fly|Ride"] = 283.14}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 60.38, ["Ride"] = 78.75, ["Fly|Ride"] = 96.9, ["Neon"] = 236.25, ["Neon|Ride"] = 262.49, ["Neon|Fly|Ride"] = 783.02, ["Mega"] = 940.74, ["Mega|Ride"] = 1277.25, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 27.75, ["Neon"] = 5.8, ["Neon|Ride"] = 1423.1, ["Mega"] = 69.63, ["Mega|Ride"] = 108.55, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 5.09}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 24.86, ["Fly|Ride"] = 497.38, ["Neon"] = 6.3, ["Neon|Fly"] = 32.71, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 113.9, ["Mega"] = 39.36, ["Mega|Ride"] = 97.12, ["Mega|Fly|Ride"] = 204.75}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 112.87, ["Ride"] = 162.93, ["Fly|Ride"] = 236.25, ["Neon"] = 836.07, ["Neon|Ride"] = 461.81, ["Neon|Fly|Ride"] = 665.05, ["Mega"] = 3405.94, ["Mega|Ride"] = 3222.09, ["Mega|Fly|Ride"] = 2689.64}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 3.4, ["Ride"] = 36.47, ["Fly|Ride"] = 213.38, ["Neon"] = 20.47, ["Neon|Fly"] = 142.96, ["Neon|Ride"] = 103.58, ["Neon|Fly|Ride"] = 219.43, ["Mega"] = 178.39, ["Mega|Ride"] = 210.67, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 36.28, ["Neon"] = 2.1, ["Neon|Ride"] = 21.09, ["Mega"] = 31.49, ["Mega|Ride"] = 57.48, ["Mega|Fly|Ride"] = 285.06}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 3.04, ["Fly"] = 39.38, ["Ride"] = 23.87, ["Fly|Ride"] = 49.88, ["Neon"] = 53.91, ["Neon|Ride"] = 89.63, ["Neon|Fly|Ride"] = 153.55, ["Mega"] = 425.76, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 635.2}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 9.37, ["Fly"] = 45.85, ["Ride"] = 21.35, ["Fly|Ride"] = 56.58, ["Neon"] = 72.17, ["Neon|Ride"] = 157.65, ["Neon|Fly|Ride"] = 309.1, ["Mega"] = 626.07, ["Mega|Ride"] = 449.44, ["Mega|Fly|Ride"] = 481.69}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 23, ["Ride"] = 58.7, ["Fly|Ride"] = 128.39, ["Neon"] = 137.07, ["Neon|Ride"] = 176.76, ["Neon|Fly|Ride"] = 483.27, ["Mega"] = 561.75, ["Mega|Ride"] = 536.72, ["Mega|Fly|Ride"] = 599.79}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 105, ["Fly"] = 196.77, ["Ride"] = 157.5, ["Fly|Ride"] = 225.64, ["Neon"] = 565.13, ["Neon|Fly"] = 686.45, ["Neon|Ride"] = 590.63, ["Neon|Fly|Ride"] = 542.11, ["Mega|Ride"] = 2554.47, ["Mega|Fly|Ride"] = 2971.69}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 5.25, ["Fly"] = 19.2, ["Ride"] = 18.22, ["Fly|Ride"] = 34.44, ["Neon"] = 38.96, ["Neon|Fly"] = 155.74, ["Neon|Ride"] = 38.75, ["Neon|Fly|Ride"] = 78.56, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 370.13}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.1, ["Fly"] = 131.23, ["Ride"] = 16.93, ["Fly|Ride"] = 131.24, ["Neon"] = 15.75, ["Neon|Ride"] = 32.8, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 142.64, ["Mega|Ride"] = 139.46, ["Mega|Fly|Ride"] = 403.53}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 5.38, ["Fly"] = 41.5, ["Ride"] = 28.03, ["Fly|Ride"] = 127.73, ["Neon"] = 51.1, ["Neon|Ride"] = 75.35, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 420, ["Mega|Ride"] = 483.27, ["Mega|Fly|Ride"] = 943.69}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 42.95, ["Fly"] = 100.28, ["Ride"] = 70.88, ["Fly|Ride"] = 157.99, ["Neon"] = 193.72, ["Neon|Ride"] = 197.11, ["Neon|Fly|Ride"] = 170.31, ["Mega"] = 954.19, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 1031.21}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 18.06, ["Fly"] = 57.75, ["Ride"] = 63.84, ["Neon"] = 111.57, ["Neon|Ride"] = 185.97, ["Neon|Fly|Ride"] = 470.47, ["Mega"] = 1050, ["Mega|Ride"] = 1502.49}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 288.75, ["Ride"] = 484.44, ["Neon|Ride"] = 3228.78}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 34.13, ["Fly"] = 39.62, ["Ride"] = 29.97, ["Fly|Ride"] = 69.56, ["Neon"] = 425.65, ["Neon|Ride"] = 158.04, ["Neon|Fly|Ride"] = 267.57, ["Mega"] = 761.25, ["Mega|Ride"] = 733.59, ["Mega|Fly|Ride"] = 1064.37}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 39.11, ["Ride"] = 13.84, ["Fly|Ride"] = 42.67, ["Neon"] = 2.1, ["Neon|Ride"] = 15.65, ["Neon|Fly|Ride"] = 52.4, ["Mega"] = 20.97, ["Mega|Fly"] = 104.32, ["Mega|Ride"] = 39.04, ["Mega|Fly|Ride"] = 111.57}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 3.77, ["Neon"] = 6.3, ["Neon|Ride"] = 42.28, ["Neon|Fly|Ride"] = 140.83, ["Mega"] = 94.96, ["Mega|Ride"] = 127.74, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 25.99, ["Fly|Ride"] = 144.21, ["Neon"] = 13.54, ["Neon|Fly"] = 87.94, ["Neon|Ride"] = 48.2, ["Neon|Fly|Ride"] = 995.32, ["Mega"] = 125.51, ["Mega|Fly"] = 498.61, ["Mega|Ride"] = 129.93, ["Mega|Fly|Ride"] = 319.32}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 425.24, ["Fly"] = 498.6, ["Ride"] = 418.69, ["Fly|Ride"] = 511.28, ["Neon"] = 1968.75, ["Neon|Ride"] = 3200.34, ["Neon|Fly|Ride"] = 1246.87, ["Mega|Fly|Ride"] = 5321.79}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.1, ["Fly"] = 37.97, ["Ride"] = 15.64, ["Fly|Ride"] = 41.47, ["Neon"] = 22.94, ["Neon|Ride"] = 29.86, ["Neon|Fly|Ride"] = 98.43, ["Mega"] = 183.54, ["Mega|Ride"] = 213.93, ["Mega|Fly|Ride"] = 567.73}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 6.25, ["Fly"] = 20.28, ["Ride"] = 15.63, ["Fly|Ride"] = 39.38, ["Neon"] = 20.28, ["Neon|Fly"] = 33.01, ["Neon|Ride"] = 59.76, ["Neon|Fly|Ride"] = 95.59, ["Mega|Ride"] = 281.01, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 3.28, ["Fly"] = 41.91, ["Ride"] = 21.27, ["Fly|Ride"] = 61.24, ["Neon"] = 13.09, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 107.33, ["Mega"] = 104.74, ["Mega|Ride"] = 284.2, ["Mega|Fly|Ride"] = 236.22}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 26.24, ["Fly"] = 47.84, ["Ride"] = 32.81, ["Fly|Ride"] = 65.63, ["Neon"] = 220.4, ["Neon|Ride"] = 196.85, ["Neon|Fly|Ride"] = 318.98, ["Mega"] = 709.93, ["Mega|Ride"] = 850.44, ["Mega|Fly|Ride"] = 602.44}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 53.34, ["Ride"] = 34.12, ["Fly|Ride"] = 51.85, ["Neon"] = 11.59, ["Neon|Ride"] = 32.71, ["Neon|Fly|Ride"] = 210, ["Mega"] = 163.74, ["Mega|Ride"] = 457.8, ["Mega|Fly|Ride"] = 1011.29}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 6.28, ["Fly"] = 65.61, ["Ride"] = 27.12, ["Fly|Ride"] = 91.88, ["Neon"] = 168.9, ["Neon|Ride"] = 109.89, ["Neon|Fly|Ride"] = 356.32, ["Mega|Ride"] = 781.25}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 19.76, ["Neon"] = 3.81, ["Neon|Ride"] = 142.71, ["Mega"] = 51.1, ["Mega|Ride"] = 120.3, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 8.47, ["Ride"] = 142.94, ["Neon"] = 41.62, ["Mega"] = 367.5, ["Mega|Ride"] = 322.59, ["Mega|Fly|Ride"] = 705.48}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 6.04, ["Ride"] = 71.49, ["Neon"] = 91.72, ["Neon|Ride"] = 284.85, ["Mega"] = 314, ["Mega|Ride"] = 593.15, ["Mega|Fly|Ride"] = 463.32}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 7.35, ["Fly"] = 26, ["Ride"] = 23.48, ["Fly|Ride"] = 48.86, ["Neon"] = 36.16, ["Neon|Fly"] = 114.22, ["Neon|Ride"] = 55.02, ["Neon|Fly|Ride"] = 81.39, ["Mega"] = 326.78, ["Mega|Ride"] = 314.93, ["Mega|Fly|Ride"] = 321.25}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 328.13, ["Fly"] = 557.2, ["Ride"] = 417.65, ["Fly|Ride"] = 422.63, ["Neon"] = 1642.41, ["Neon|Ride"] = 1656.34, ["Neon|Fly|Ride"] = 1575, ["Mega|Fly|Ride"] = 8054.61}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 14.44, ["Fly|Ride"] = 39.38, ["Neon"] = 15.65, ["Neon|Fly"] = 81.13, ["Neon|Ride"] = 32.28, ["Neon|Fly|Ride"] = 158.17, ["Mega"] = 249.09, ["Mega|Ride"] = 196.77, ["Mega|Fly|Ride"] = 303.27}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 7.88, ["Fly"] = 114.14, ["Ride"] = 45.94, ["Fly|Ride"] = 131.25, ["Neon"] = 57.65, ["Neon|Ride"] = 123.35, ["Neon|Fly|Ride"] = 210, ["Mega"] = 384.91, ["Mega|Fly"] = 709.93, ["Mega|Ride"] = 415.8, ["Mega|Fly|Ride"] = 522.61}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 19.49, ["Fly"] = 118.13, ["Ride"] = 71.48, ["Fly|Ride"] = 285.08, ["Neon"] = 85.76, ["Neon|Ride"] = 164.1, ["Neon|Fly|Ride"] = 355.51, ["Mega"] = 340.61, ["Mega|Ride"] = 356.03, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 48.65, ["Fly"] = 146.86, ["Ride"] = 70.07, ["Fly|Ride"] = 145.69, ["Neon"] = 320.25, ["Neon|Ride"] = 327.52, ["Neon|Fly|Ride"] = 380.63, ["Mega"] = 2492.09, ["Mega|Ride"] = 1950.31, ["Mega|Fly|Ride"] = 1412.43}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 9.08, ["Fly"] = 106.76, ["Ride"] = 32.82, ["Fly|Ride"] = 128.63, ["Neon"] = 32.82, ["Neon|Ride"] = 104.81, ["Neon|Fly|Ride"] = 245.44, ["Mega"] = 143.05, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 349.22}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 17.05, ["Ride"] = 19.59, ["Fly|Ride"] = 58.47, ["Neon"] = 13.13, ["Neon|Ride"] = 33.5, ["Neon|Fly|Ride"] = 126.93, ["Mega"] = 65.62, ["Mega|Ride"] = 161.9, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 4.45, ["Ride"] = 28.82, ["Neon"] = 16.02, ["Neon|Ride"] = 105.84, ["Neon|Fly|Ride"] = 157.49, ["Mega"] = 102.19, ["Mega|Ride"] = 150.17, ["Mega|Fly|Ride"] = 289.42}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 41.2, ["Fly"] = 137.8, ["Ride"] = 71.91, ["Fly|Ride"] = 216.57, ["Neon"] = 112.23, ["Neon|Ride"] = 142.96, ["Neon|Fly|Ride"] = 224.6, ["Mega"] = 396.81, ["Mega|Ride"] = 410.82, ["Mega|Fly|Ride"] = 518.44}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.5, ["Ride"] = 131.25, ["Neon"] = 4.99, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 202.02, ["Mega"] = 49.14, ["Mega|Fly"] = 161.9, ["Mega|Ride"] = 164.07}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 16.02, ["Ride"] = 213.35, ["Neon"] = 128.03, ["Neon|Ride"] = 401.03, ["Neon|Fly|Ride"] = 853.43, ["Mega"] = 509.61, ["Mega|Fly|Ride"] = 680.13}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 892.5, ["Fly"] = 1004.07, ["Ride"] = 1018.5, ["Fly|Ride"] = 1152.22, ["Neon"] = 3519.3, ["Neon|Ride"] = 3937.5, ["Neon|Fly|Ride"] = 3281.23, ["Mega|Fly|Ride"] = 10360.45}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 11.81, ["Fly"] = 108.51, ["Ride"] = 40.69, ["Fly|Ride"] = 173.25, ["Neon"] = 63, ["Neon|Fly"] = 710.07, ["Neon|Ride"] = 142.96, ["Neon|Fly|Ride"] = 321.57, ["Mega"] = 337.89, ["Mega|Ride"] = 328.27, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.1, ["Fly"] = 49.37, ["Ride"] = 19.71, ["Fly|Ride"] = 90.55, ["Neon"] = 6.93, ["Neon|Fly"] = 42.69, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 85.44, ["Mega"] = 57.48, ["Mega|Ride"] = 78.74, ["Mega|Fly|Ride"] = 163.93}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 9.18, ["Ride"] = 57.62, ["Fly|Ride"] = 142.96, ["Neon"] = 48.57, ["Neon|Fly"] = 84.29, ["Neon|Fly|Ride"] = 393.73, ["Mega"] = 266.13, ["Mega|Ride"] = 411.5, ["Mega|Fly|Ride"] = 480.85}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Fly|Ride"] = 185.19, ["Neon"] = 2.1, ["Neon|Fly"] = 142.96, ["Neon|Ride"] = 17.06, ["Neon|Fly|Ride"] = 93.17, ["Mega"] = 16.28, ["Mega|Ride"] = 37.9, ["Mega|Fly|Ride"] = 170.31}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 52.9, ["Ride"] = 97.79, ["Fly|Ride"] = 236.24, ["Neon"] = 234.94, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 375.51, ["Mega"] = 1039.53, ["Mega|Ride"] = 867.59, ["Mega|Fly|Ride"] = 913.24}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 10.14, ["Ride"] = 62.91, ["Fly|Ride"] = 278.21, ["Neon"] = 76.13, ["Neon|Ride"] = 328.12, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 483.23, ["Mega|Ride"] = 602.86, ["Mega|Fly|Ride"] = 639.19}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2.1, ["Ride"] = 19.57, ["Neon"] = 6.04, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 212.89, ["Mega"] = 91.55, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 355.51}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 17.09, ["Fly"] = 52.5, ["Ride"] = 31.33, ["Fly|Ride"] = 113.09, ["Neon"] = 50.95, ["Neon|Ride"] = 86.05, ["Neon|Fly|Ride"] = 188.41, ["Mega"] = 409.17, ["Mega|Ride"] = 353.38, ["Mega|Fly|Ride"] = 391.13}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 5.93, ["Fly"] = 33.08, ["Ride"] = 31.49, ["Fly|Ride"] = 45.94, ["Neon"] = 125.89, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 135.72, ["Mega"] = 332.27, ["Mega|Ride"] = 292.38, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 26.17, ["Ride"] = 208.69, ["Neon"] = 165.37, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 721.88, ["Mega"] = 2128.72, ["Mega|Ride"] = 2416.26, ["Mega|Fly|Ride"] = 1700.86}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 4.29, ["Ride"] = 45.94, ["Fly|Ride"] = 184.11, ["Neon"] = 9.85, ["Neon|Ride"] = 70.88, ["Neon|Fly|Ride"] = 161.21, ["Mega"] = 111.56, ["Mega|Ride"] = 123.86, ["Mega|Fly|Ride"] = 227.05}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 9.7, ["Fly"] = 27.75, ["Ride"] = 17.07, ["Fly|Ride"] = 89.25, ["Neon"] = 33.79, ["Neon|Fly"] = 185.63, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 91.49, ["Mega"] = 295.21, ["Mega|Ride"] = 351.75, ["Mega|Fly|Ride"] = 681.19}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 108.72, ["Fly"] = 393.75, ["Ride"] = 154.76, ["Fly|Ride"] = 236.25, ["Neon"] = 446.24, ["Neon|Fly"] = 426.57, ["Neon|Ride"] = 452.23, ["Neon|Fly|Ride"] = 569.67, ["Mega"] = 2660.9, ["Mega|Ride"] = 2791.82, ["Mega|Fly|Ride"] = 1945.79}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 24.92, ["Ride"] = 14.44, ["Fly|Ride"] = 36.75, ["Neon"] = 11.81, ["Neon|Fly"] = 57.32, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 77.44, ["Mega"] = 145.69, ["Mega|Ride"] = 239.49, ["Mega|Fly|Ride"] = 185.21}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 15.22, ["Fly"] = 200.81, ["Ride"] = 30.75, ["Fly|Ride"] = 116.81, ["Neon"] = 95.82, ["Neon|Ride"] = 106.08, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 452.81, ["Mega|Ride"] = 498.74, ["Mega|Fly|Ride"] = 540.7}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 18.27, ["Ride"] = 15.99, ["Fly|Ride"] = 52.5, ["Neon"] = 2.1, ["Neon|Fly"] = 27.72, ["Neon|Ride"] = 16.46, ["Neon|Fly|Ride"] = 41.29, ["Mega"] = 10.5, ["Mega|Fly"] = 50.76, ["Mega|Ride"] = 35.28, ["Mega|Fly|Ride"] = 76.65}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 57.62, ["Fly|Ride"] = 39.38, ["Neon"] = 3.56, ["Neon|Ride"] = 42.69, ["Neon|Fly|Ride"] = 132.29, ["Mega"] = 20.78, ["Mega|Fly"] = 118.11, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 126.68}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.1, ["Fly"] = 36.28, ["Ride"] = 18.69, ["Fly|Ride"] = 133.88, ["Neon"] = 9.44, ["Neon|Ride"] = 55.54, ["Neon|Fly|Ride"] = 85.36, ["Mega"] = 85.32, ["Mega|Ride"] = 270.36, ["Mega|Fly|Ride"] = 246.1}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 32.82, ["Ride"] = 55.49, ["Fly|Ride"] = 131.25, ["Neon"] = 181.73, ["Neon|Ride"] = 341.38, ["Neon|Fly|Ride"] = 433.13, ["Mega"] = 547.32, ["Mega|Ride"] = 636.49}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.1, ["Fly"] = 16.03, ["Ride"] = 14.44, ["Fly|Ride"] = 30.35, ["Neon"] = 9.71, ["Neon|Fly"] = 32.12, ["Neon|Ride"] = 27.2, ["Neon|Fly|Ride"] = 52.41, ["Mega"] = 111.57, ["Mega|Fly"] = 170.63, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 6.32, ["Fly"] = 30.18, ["Ride"] = 25.62, ["Fly|Ride"] = 99.42, ["Neon"] = 30.92, ["Neon|Fly"] = 70.81, ["Neon|Ride"] = 40.05, ["Neon|Fly|Ride"] = 105, ["Mega"] = 230.99, ["Mega|Fly"] = 433.13, ["Mega|Ride"] = 222.21, ["Mega|Fly|Ride"] = 305.23}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Fly"] = 21.95, ["Ride"] = 18.09, ["Fly|Ride"] = 72.56, ["Neon"] = 5.25, ["Neon|Fly"] = 71.49, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 89.24, ["Mega"] = 78.78, ["Mega|Fly"] = 80.96, ["Mega|Ride"] = 58.47, ["Mega|Fly|Ride"] = 126.73}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 11.11, ["Fly"] = 161.07, ["Ride"] = 23.39, ["Fly|Ride"] = 217.2, ["Neon"] = 37.67, ["Neon|Ride"] = 79.8, ["Neon|Fly|Ride"] = 284.85, ["Mega"] = 241.57, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 383.35, ["Mega|Fly|Ride"] = 320.25}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 3.45, ["Fly"] = 42.69, ["Ride"] = 36.75, ["Fly|Ride"] = 128.03, ["Neon"] = 50.56, ["Neon|Fly"] = 78.95, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 259.88, ["Mega"] = 682.5, ["Mega|Ride"] = 483.27, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 3.7, ["Fly"] = 23.55, ["Ride"] = 15.75, ["Fly|Ride"] = 49.61, ["Neon"] = 21, ["Neon|Fly"] = 196.87, ["Neon|Ride"] = 39.04, ["Neon|Fly|Ride"] = 105.39, ["Mega"] = 262.49, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 305.82, ["Mega|Fly|Ride"] = 568.38}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 16.8, ["Ride"] = 15.44, ["Fly|Ride"] = 21.35, ["Neon"] = 11.46, ["Neon|Fly"] = 70.51, ["Neon|Ride"] = 20.28, ["Neon|Fly|Ride"] = 71.49, ["Mega"] = 94.49, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 157.54}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 187.61, ["Fly"] = 393.75, ["Ride"] = 273, ["Fly|Ride"] = 392.44, ["Neon"] = 1217.92, ["Neon|Ride"] = 1138.26, ["Neon|Fly|Ride"] = 1174.69, ["Mega"] = 4188.6, ["Mega|Fly|Ride"] = 4200}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 3.82, ["Ride"] = 65.63, ["Neon"] = 21, ["Neon|Ride"] = 142.96, ["Neon|Fly|Ride"] = 426.72, ["Mega"] = 122.07, ["Mega|Ride"] = 638.67, ["Mega|Fly|Ride"] = 355.51}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 2.1, ["Fly"] = 106.71, ["Ride"] = 22.93, ["Fly|Ride"] = 85.17, ["Neon"] = 23.63, ["Neon|Fly"] = 242.18, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 149.03, ["Mega"] = 225.7, ["Mega|Ride"] = 194.9, ["Mega|Fly|Ride"] = 524.98}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 2.45, ["Fly|Ride"] = 212.89, ["Neon"] = 36.66, ["Neon|Ride"] = 226.17, ["Neon|Fly|Ride"] = 603.74, ["Mega"] = 479.73, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 416.73}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 16.17, ["Ride"] = 15.24, ["Fly|Ride"] = 32.34, ["Neon"] = 2.1, ["Neon|Fly"] = 35.44, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 18.21, ["Mega|Fly"] = 78.78, ["Mega|Ride"] = 42.2, ["Mega|Fly|Ride"] = 65.63}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.1, ["Fly"] = 42, ["Ride"] = 16.87, ["Fly|Ride"] = 57.73, ["Neon"] = 14.44, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 106.58, ["Mega"] = 118.13, ["Mega|Ride"] = 128.63, ["Mega|Fly|Ride"] = 190.21}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.1, ["Ride"] = 142.96, ["Neon"] = 8.55, ["Neon|Ride"] = 142.96, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 43.04, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 255.46}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 72.19, ["Fly"] = 101.77, ["Ride"] = 104.9, ["Fly|Ride"] = 164.07, ["Neon"] = 301.88, ["Neon|Fly"] = 435.85, ["Neon|Ride"] = 409.49, ["Neon|Fly|Ride"] = 425.65, ["Mega|Ride"] = 3549.63, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 2.1, ["Fly"] = 94.5, ["Ride"] = 26.23, ["Fly|Ride"] = 100.29, ["Neon"] = 24.18, ["Neon|Ride"] = 66.94, ["Mega"] = 167.99, ["Mega|Ride"] = 159.25, ["Mega|Fly|Ride"] = 347}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.33, ["Fly"] = 49.08, ["Ride"] = 34.12, ["Neon"] = 6.12, ["Neon|Ride"] = 80.94, ["Neon|Fly|Ride"] = 542.47, ["Mega"] = 66.94, ["Mega|Fly"] = 314.99, ["Mega|Ride"] = 125.9, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 44.48, ["Fly"] = 131.25, ["Ride"] = 77.86, ["Fly|Ride"] = 181.61, ["Neon"] = 136.5, ["Neon|Ride"] = 162.56, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 538.12, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 538.13}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 17.05, ["Ride"] = 13.89, ["Fly|Ride"] = 32.7, ["Neon"] = 2.1, ["Neon|Fly"] = 17.09, ["Neon|Ride"] = 15.65, ["Neon|Fly|Ride"] = 32.82, ["Mega"] = 15.75, ["Mega|Fly"] = 45.49, ["Mega|Ride"] = 30.18, ["Mega|Fly|Ride"] = 92.61}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 26.23, ["Neon"] = 2.1, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 285.32, ["Mega"] = 22.32, ["Mega|Ride"] = 78.63, ["Mega|Fly|Ride"] = 176.07}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 3.42, ["Ride"] = 47.55, ["Neon"] = 7.77, ["Neon|Ride"] = 108.94, ["Neon|Fly|Ride"] = 142.7, ["Mega"] = 62.91, ["Mega|Fly"] = 185.21, ["Mega|Ride"] = 114.75, ["Mega|Fly|Ride"] = 206.51}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 7.77, ["Fly"] = 80.07, ["Ride"] = 50.18, ["Fly|Ride"] = 128.33, ["Neon"] = 19.47, ["Neon|Fly"] = 91.75, ["Neon|Ride"] = 85.36, ["Neon|Fly|Ride"] = 142.96, ["Mega"] = 104.9, ["Mega|Fly"] = 346.68, ["Mega|Ride"] = 170.37, ["Mega|Fly|Ride"] = 278.81}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 20.89, ["Ride"] = 14.21, ["Fly|Ride"] = 24.91, ["Neon"] = 2.1, ["Neon|Fly"] = 24.5, ["Neon|Ride"] = 22.17, ["Neon|Fly|Ride"] = 44.44, ["Mega"] = 16.7, ["Mega|Ride"] = 64.31, ["Mega|Fly|Ride"] = 78.49}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 18.16, ["Fly"] = 131.25, ["Ride"] = 53.27, ["Neon"] = 128.63, ["Neon|Fly"] = 426.72, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 1312.5, ["Mega"] = 505.59, ["Mega|Ride"] = 590.62, ["Mega|Fly|Ride"] = 741.8}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2100, ["Fly"] = 2761.69, ["Ride"] = 2231.24, ["Fly|Ride"] = 2314.78, ["Neon"] = 10667.75, ["Neon|Fly|Ride"] = 9814.34, ["Mega|Fly|Ride"] = 42573.13}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 17.01, ["Ride"] = 14.23, ["Fly|Ride"] = 34.16, ["Neon"] = 3.94, ["Neon|Fly"] = 58.52, ["Neon|Ride"] = 21.35, ["Neon|Fly|Ride"] = 57.54, ["Mega"] = 70.54, ["Mega|Fly"] = 425.76, ["Mega|Ride"] = 83.91, ["Mega|Fly|Ride"] = 140.44}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.1, ["Ride"] = 53.55, ["Neon"] = 8.4, ["Mega"] = 107.01, ["Mega|Fly"] = 441, ["Mega|Ride"] = 161.44, ["Mega|Fly|Ride"] = 355.51}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 15.75, ["Fly"] = 42.69, ["Ride"] = 25.09, ["Fly|Ride"] = 131.25, ["Neon"] = 73.48, ["Neon|Ride"] = 99.75, ["Neon|Fly|Ride"] = 212.63, ["Mega"] = 459.38, ["Mega|Ride"] = 399, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 25.91, ["Fly"] = 91.74, ["Ride"] = 63.95, ["Neon"] = 78.95, ["Neon|Ride"] = 190.32, ["Mega"] = 438.89, ["Mega|Ride"] = 581.16, ["Mega|Fly|Ride"] = 628.25}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 123.27, ["Fly"] = 213.35, ["Ride"] = 156.18, ["Fly|Ride"] = 251.49, ["Neon"] = 1312.5, ["Neon|Ride"] = 714.66, ["Neon|Fly|Ride"] = 715.32, ["Mega"] = 6386.14, ["Mega|Fly|Ride"] = 3800.83}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 6.46, ["Ride"] = 65.54, ["Fly|Ride"] = 675.94, ["Neon"] = 19.68, ["Neon|Ride"] = 57.62, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 144.45, ["Mega|Fly"] = 13125, ["Mega|Ride"] = 225.93, ["Mega|Fly|Ride"] = 361.9}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.36, ["Ride"] = 35.44, ["Neon"] = 13.01, ["Neon|Ride"] = 114.85, ["Mega"] = 245.44, ["Mega|Ride"] = 333.27, ["Mega|Fly|Ride"] = 267.09}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Fly"] = 100.05, ["Ride"] = 26.25, ["Fly|Ride"] = 131.25, ["Neon"] = 6.39, ["Neon|Fly"] = 100.29, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 78.78, ["Mega|Ride"] = 105.83, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 16.02, ["Ride"] = 50.84, ["Fly|Ride"] = 131.25, ["Neon"] = 98.44, ["Neon|Ride"] = 176.76, ["Neon|Fly|Ride"] = 502.46, ["Mega"] = 386.61, ["Mega|Ride"] = 469.4, ["Mega|Fly|Ride"] = 584.73}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 42.69, ["Neon"] = 2.1, ["Neon|Ride"] = 34.16, ["Mega"] = 14.43, ["Mega|Fly"] = 120.83, ["Mega|Ride"] = 79.97, ["Mega|Fly|Ride"] = 134.54}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 65.63, ["Fly"] = 106.71, ["Ride"] = 104.98, ["Fly|Ride"] = 142.96, ["Neon"] = 346.5, ["Neon|Fly"] = 456.59, ["Neon|Ride"] = 409.65, ["Neon|Fly|Ride"] = 317.83, ["Mega"] = 3193.08, ["Mega|Fly|Ride"] = 1702.98}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Fly"] = 28.82, ["Ride"] = 91.83, ["Fly|Ride"] = 51.19, ["Neon"] = 3.46, ["Neon|Ride"] = 142.63, ["Neon|Fly|Ride"] = 213.38, ["Mega"] = 70.88, ["Mega|Ride"] = 281.54, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 32.82, ["Fly"] = 102.42, ["Ride"] = 59.07, ["Fly|Ride"] = 185.4, ["Neon"] = 255.94, ["Neon|Ride"] = 389.84, ["Neon|Fly|Ride"] = 468.44, ["Mega"] = 2625, ["Mega|Fly|Ride"] = 1843.26}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 21.35, ["Fly|Ride"] = 51.64, ["Neon"] = 3.42, ["Neon|Fly"] = 87.45, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 83.98, ["Mega"] = 44.31, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 142.96}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Ride"] = 57.62, ["Fly|Ride"] = 109.89, ["Neon"] = 10.5, ["Neon|Ride"] = 98.44, ["Mega"] = 53.41, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 426.92}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 6.33, ["Fly"] = 77.43, ["Ride"] = 33.08, ["Neon"] = 23.21, ["Neon|Ride"] = 79.97, ["Neon|Fly|Ride"] = 142.96, ["Mega"] = 367.5, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 567}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 321.57, ["Ride"] = 400.32, ["Fly|Ride"] = 472.5, ["Neon"] = 972.3, ["Neon|Ride"] = 980.4, ["Neon|Fly|Ride"] = 1076.25, ["Mega"] = 3263.33, ["Mega|Ride"] = 2361.19, ["Mega|Fly|Ride"] = 2847.42}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 24.46, ["Fly"] = 57.62, ["Ride"] = 44.78, ["Fly|Ride"] = 128.03, ["Neon"] = 196.88, ["Neon|Ride"] = 212.3, ["Neon|Fly|Ride"] = 255.84, ["Mega|Ride"] = 1128.24, ["Mega|Fly|Ride"] = 1702.98}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 45.01, ["Ride"] = 16.11, ["Fly|Ride"] = 111.57, ["Neon"] = 12.99, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 24.54, ["Neon|Fly|Ride"] = 98.34, ["Mega"] = 124.69, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 314.88}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 45.93, ["Fly"] = 39.38, ["Ride"] = 49.87, ["Fly|Ride"] = 131.24, ["Neon"] = 71.45, ["Neon|Fly"] = 162.24, ["Neon|Ride"] = 144.01, ["Neon|Fly|Ride"] = 183.64, ["Mega"] = 282.19, ["Mega|Fly"] = 425.76, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 382.12}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 3.84, ["Ride"] = 30.87, ["Neon"] = 54.47, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 256.04, ["Mega"] = 425.76, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 425.81}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.19, ["Neon"] = 19.58, ["Mega"] = 91.87, ["Mega|Ride"] = 318.26, ["Mega|Fly|Ride"] = 398.09}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.1, ["Fly"] = 71.32, ["Ride"] = 20.96, ["Fly|Ride"] = 65.54, ["Neon"] = 32.82, ["Neon|Ride"] = 50.16, ["Neon|Fly|Ride"] = 212.14, ["Mega"] = 160.13, ["Mega|Ride"] = 486.93, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 98.44, ["Fly"] = 218.05, ["Ride"] = 117.43, ["Fly|Ride"] = 213.38, ["Neon"] = 459.79, ["Neon|Ride"] = 523.68, ["Neon|Fly|Ride"] = 568.52, ["Mega"] = 2887.5, ["Mega|Ride"] = 3544.66, ["Mega|Fly|Ride"] = 3193.08}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 24.93, ["Ride"] = 38.98, ["Fly|Ride"] = 91.88, ["Neon"] = 154.87, ["Neon|Ride"] = 235.77, ["Neon|Fly|Ride"] = 284.85, ["Mega"] = 590.45, ["Mega|Ride"] = 723.77, ["Mega|Fly|Ride"] = 731.07}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 1818.43, ["Fly"] = 2058.97, ["Ride"] = 2034.38, ["Fly|Ride"] = 2034.38, ["Neon"] = 11379.3, ["Neon|Fly|Ride"] = 6300, ["Mega|Fly|Ride"] = 21654.94}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 3.56, ["Fly"] = 65625, ["Ride"] = 18.38, ["Fly|Ride"] = 196.87, ["Neon"] = 12.75, ["Neon|Fly|Ride"] = 638.64, ["Mega"] = 118.13, ["Mega|Fly"] = 786.19, ["Mega|Ride"] = 177.85, ["Mega|Fly|Ride"] = 446.24}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 5.92, ["Ride"] = 36.74, ["Fly|Ride"] = 178.17, ["Neon"] = 29.08, ["Neon|Ride"] = 90.56, ["Mega"] = 137.82, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 820.21, ["Fly"] = 1107.73, ["Ride"] = 822.93, ["Fly|Ride"] = 826.88, ["Neon"] = 2778.57, ["Neon|Ride"] = 2243.53, ["Neon|Fly|Ride"] = 2189.19, ["Mega|Fly|Ride"] = 11437.36}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 27.56, ["Ride"] = 47.24, ["Fly|Ride"] = 173.35, ["Neon"] = 212.91, ["Neon|Ride"] = 180.26, ["Neon|Fly|Ride"] = 356.32, ["Mega"] = 844.56, ["Mega|Ride"] = 672, ["Mega|Fly|Ride"] = 692.91}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 3.56, ["Ride"] = 23.44, ["Fly|Ride"] = 125.89, ["Neon"] = 6.54, ["Neon|Ride"] = 42.6, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 157.5, ["Mega|Ride"] = 318.26, ["Mega|Fly|Ride"] = 255.46}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 142.94, ["Neon"] = 2.1, ["Neon|Ride"] = 49.14, ["Neon|Fly|Ride"] = 104.55, ["Mega"] = 22.18, ["Mega|Ride"] = 78.78, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 77.43, ["Ride"] = 129.94, ["Fly|Ride"] = 170.63, ["Neon"] = 448.06, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 635.82, ["Mega"] = 2416.26, ["Mega|Fly|Ride"] = 2128.72}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 2.1, ["Ride"] = 34.01, ["Fly|Ride"] = 74.03, ["Neon"] = 10.28, ["Neon|Ride"] = 45.87, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 107.62, ["Mega|Ride"] = 122.04, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 73.49, ["Fly"] = 100.28, ["Ride"] = 126, ["Fly|Ride"] = 242.18, ["Neon"] = 492.19, ["Neon|Ride"] = 554.73, ["Mega|Fly|Ride"] = 1745.56}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 6.7, ["Fly"] = 105, ["Fly|Ride"] = 102.89, ["Neon"] = 26.25, ["Neon|Ride"] = 213.38, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 314.9, ["Mega|Ride"] = 196.88}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 223.13, ["Ride"] = 287.45, ["Fly|Ride"] = 320.25, ["Neon"] = 1137.32, ["Neon|Ride"] = 1064.63, ["Neon|Fly|Ride"] = 879.04, ["Mega|Fly|Ride"] = 3899.56}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 3.03, ["Fly"] = 91.88, ["Ride"] = 16.59, ["Fly|Ride"] = 51.18, ["Neon"] = 24.43, ["Neon|Ride"] = 57.66, ["Neon|Fly|Ride"] = 112.77, ["Mega"] = 321.47, ["Mega|Ride"] = 162.9, ["Mega|Fly|Ride"] = 265.79}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 15.54, ["Ride"] = 14.6, ["Fly|Ride"] = 31.4, ["Neon"] = 3.68, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 57.62, ["Mega"] = 41.99, ["Mega|Ride"] = 45.94, ["Mega|Fly|Ride"] = 107.63}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 1278.93, ["Ride"] = 1050, ["Fly|Ride"] = 1254.19, ["Neon|Ride"] = 7823.74, ["Neon|Fly|Ride"] = 6685.49, ["Mega"] = 23679.32, ["Mega|Fly|Ride"] = 28383.15}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 7.76, ["Fly"] = 284.81, ["Ride"] = 72.19, ["Neon"] = 76.04, ["Neon|Ride"] = 128.03, ["Mega"] = 244.59, ["Mega|Ride"] = 284.82, ["Mega|Fly|Ride"] = 564.27}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 4.74, ["Fly"] = 39.38, ["Ride"] = 35.35, ["Fly|Ride"] = 107.63, ["Neon"] = 19.66, ["Neon|Fly"] = 57.62, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 105, ["Mega"] = 118.13, ["Mega|Ride"] = 225.93, ["Mega|Fly|Ride"] = 322.59}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 31.4, ["Fly"] = 33.95, ["Ride"] = 32.42, ["Fly|Ride"] = 69.44, ["Neon"] = 426.72, ["Neon|Fly"] = 213.38, ["Neon|Ride"] = 209.9, ["Neon|Fly|Ride"] = 199.5, ["Mega"] = 2554.47, ["Mega|Ride"] = 1128.41, ["Mega|Fly|Ride"] = 799.32}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 13.55, ["Fly"] = 91.74, ["Ride"] = 28.58, ["Fly|Ride"] = 78.46, ["Neon"] = 57.85, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 98.34, ["Neon|Fly|Ride"] = 228.3, ["Mega"] = 367.4, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 429.26}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 48.09, ["Ride"] = 128.02, ["Fly|Ride"] = 497.37, ["Neon"] = 204.65, ["Neon|Ride"] = 314.71, ["Neon|Fly|Ride"] = 540.87, ["Mega"] = 851.5, ["Mega|Ride"] = 851.5, ["Mega|Fly|Ride"] = 851.5}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 116.61, ["Fly|Ride"] = 284.85, ["Neon"] = 2.63, ["Neon|Fly"] = 57.62, ["Neon|Ride"] = 113.81, ["Neon|Fly|Ride"] = 106.77, ["Mega"] = 16.51, ["Mega|Fly"] = 72.19, ["Mega|Ride"] = 142.64, ["Mega|Fly|Ride"] = 196.87}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 78.49, ["Fly"] = 128.02, ["Ride"] = 90.72, ["Fly|Ride"] = 186.72, ["Neon"] = 348.68, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 378, ["Mega"] = 3405.94, ["Mega|Fly|Ride"] = 1666.77}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.1, ["Fly"] = 107.62, ["Ride"] = 19.43, ["Fly|Ride"] = 66.68, ["Neon"] = 142.96, ["Neon|Ride"] = 95.95, ["Neon|Fly|Ride"] = 170.7, ["Mega"] = 773.07, ["Mega|Ride"] = 432.48, ["Mega|Fly|Ride"] = 425.76}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 16.02, ["Fly|Ride"] = 38.16, ["Neon"] = 20.21, ["Neon|Fly"] = 81.13, ["Neon|Ride"] = 75.75, ["Neon|Fly|Ride"] = 122.85, ["Mega|Ride"] = 275.07, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 2.1, ["Ride"] = 126, ["Neon"] = 16.03, ["Neon|Fly"] = 140.83, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 202.34, ["Mega|Fly|Ride"] = 483.27}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 54.49, ["Ride"] = 193.79, ["Fly|Ride"] = 357, ["Neon"] = 328.13, ["Neon|Ride"] = 368.04, ["Neon|Fly|Ride"] = 426.72, ["Mega"] = 2205, ["Mega|Ride"] = 1462.43, ["Mega|Fly|Ride"] = 1286.25}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 2.52, ["Fly|Ride"] = 426.72, ["Neon"] = 18.47, ["Neon|Ride"] = 59.07, ["Mega"] = 126.88, ["Mega|Ride"] = 212.89, ["Mega|Fly|Ride"] = 281.75}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Fly"] = 21.35, ["Ride"] = 36.66, ["Neon"] = 2.62, ["Neon|Ride"] = 118.65, ["Neon|Fly|Ride"] = 71.49, ["Mega"] = 16.86, ["Mega|Ride"] = 192.32, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 102.92, ["Ride"] = 36.2, ["Fly|Ride"] = 142.72, ["Neon"] = 2.1, ["Neon|Fly"] = 86.2, ["Neon|Ride"] = 21.8, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 19.17, ["Mega|Ride"] = 61.68, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 24.57, ["Ride"] = 16.04, ["Fly|Ride"] = 52.41, ["Neon"] = 5.23, ["Neon|Ride"] = 32.02, ["Neon|Fly|Ride"] = 87.94, ["Mega"] = 61.69, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 179.7}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 113.89, ["Neon"] = 24.35, ["Neon|Ride"] = 65.63, ["Mega"] = 118.1, ["Mega|Ride"] = 106.29, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 38.07, ["Ride"] = 14.42, ["Fly|Ride"] = 30.19, ["Neon"] = 9.97, ["Neon|Fly"] = 213.42, ["Neon|Ride"] = 31.97, ["Neon|Fly|Ride"] = 77.97, ["Mega"] = 170.63, ["Mega|Ride"] = 125.32, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 65.63, ["Ride"] = 101.72, ["Fly|Ride"] = 280.58, ["Neon"] = 217.59, ["Neon|Ride"] = 324.07, ["Neon|Fly|Ride"] = 1066.78, ["Mega"] = 693.48, ["Mega|Ride"] = 850.44, ["Mega|Fly|Ride"] = 1128.1}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 16.69, ["Ride"] = 15.73, ["Fly|Ride"] = 42.69, ["Neon"] = 2.1, ["Neon|Fly"] = 21.35, ["Neon|Ride"] = 14.83, ["Neon|Fly|Ride"] = 42.69, ["Mega"] = 42, ["Mega|Ride"] = 124.5, ["Mega|Fly|Ride"] = 95.82}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 7.35, ["Fly"] = 80.01, ["Ride"] = 23.83, ["Fly|Ride"] = 71.49, ["Neon"] = 31.49, ["Neon|Fly"] = 91.76, ["Neon|Ride"] = 49.87, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 301.87, ["Mega|Fly"] = 332.1, ["Mega|Ride"] = 321.57, ["Mega|Fly|Ride"] = 311.07}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 16.94, ["Fly"] = 53.34, ["Ride"] = 40.13, ["Fly|Ride"] = 103.69, ["Neon"] = 152.55, ["Neon|Fly"] = 142.96, ["Neon|Ride"] = 98.43, ["Neon|Fly|Ride"] = 209.89, ["Mega"] = 787.5, ["Mega|Ride"] = 674.82, ["Mega|Fly|Ride"] = 587.35}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 7.18, ["Fly"] = 196.88, ["Neon"] = 73.5, ["Neon|Ride"] = 103.69, ["Mega"] = 393.75, ["Mega|Ride"] = 448.28, ["Mega|Fly|Ride"] = 357}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 19.38, ["Ride"] = 15.75, ["Fly|Ride"] = 32.7, ["Neon"] = 3.68, ["Neon|Fly"] = 28.1, ["Neon|Ride"] = 15.74, ["Neon|Fly|Ride"] = 65.4, ["Mega"] = 38.07, ["Mega|Ride"] = 46.12, ["Mega|Fly|Ride"] = 112.06}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 5.14, ["Fly"] = 78.81, ["Ride"] = 37.97, ["Fly|Ride"] = 54.36, ["Neon"] = 28.25, ["Neon|Ride"] = 127.76, ["Mega"] = 196.87, ["Mega|Fly"] = 735, ["Mega|Ride"] = 301.87, ["Mega|Fly|Ride"] = 378.92}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 980.44, ["Fly"] = 1373.59, ["Ride"] = 979.12, ["Fly|Ride"] = 1049.99, ["Neon"] = 2941.86, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2218.12, ["Mega|Fly|Ride"] = 7199.06}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 128.63, ["Ride"] = 270.97, ["Fly|Ride"] = 636.41, ["Neon"] = 682.76, ["Neon|Ride"] = 853.13, ["Neon|Fly|Ride"] = 945, ["Mega"] = 3192.02, ["Mega|Ride"] = 3549.63, ["Mega|Fly|Ride"] = 2546.25}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Fly|Ride"] = 392.44, ["Neon"] = 6.09, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 208.04, ["Mega"] = 78.49, ["Mega|Fly|Ride"] = 1135.68}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 84.45, ["Ride"] = 164.07, ["Fly|Ride"] = 262.5, ["Neon"] = 328.13, ["Neon|Fly"] = 446.25, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 708.75, ["Mega"] = 1967.44, ["Mega|Ride"] = 1915.86, ["Mega|Fly|Ride"] = 1826.69}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 3.73, ["Ride"] = 20.67, ["Neon"] = 15.21, ["Neon|Fly"] = 56.91, ["Neon|Ride"] = 52.67, ["Neon|Fly|Ride"] = 284.2, ["Mega"] = 118.12, ["Mega|Ride"] = 477.41, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 249.38, ["Fly"] = 334.94, ["Ride"] = 247.54, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 1194.81, ["Neon|Fly|Ride"] = 1365, ["Mega|Fly|Ride"] = 4934.36}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 77.18, ["Ride"] = 41.62, ["Fly|Ride"] = 216.16, ["Neon"] = 23.9, ["Neon|Fly"] = 50.15, ["Neon|Ride"] = 54.37, ["Mega"] = 241.35, ["Mega|Fly"] = 356.57, ["Mega|Ride"] = 568.38}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Fly"] = 28.82, ["Ride"] = 19.22, ["Neon"] = 43.65, ["Mega"] = 131.25, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 20.9, ["Ride"] = 61.07, ["Fly|Ride"] = 153.82, ["Neon"] = 116.85, ["Neon|Fly"] = 426.72, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 242.13, ["Mega"] = 469.4, ["Mega|Ride"] = 593.72, ["Mega|Fly|Ride"] = 902.48}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 49.74, ["Neon"] = 19.22, ["Neon|Ride"] = 196.87, ["Mega"] = 230.76, ["Mega|Ride"] = 253.32, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 16.25, ["Ride"] = 14.11, ["Fly|Ride"] = 28.82, ["Neon"] = 2.1, ["Neon|Fly"] = 28.82, ["Neon|Ride"] = 26.18, ["Neon|Fly|Ride"] = 35.33, ["Mega"] = 22.89, ["Mega|Ride"] = 36.2, ["Mega|Fly|Ride"] = 65.01}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4593.65, ["Ride"] = 4461.19, ["Fly|Ride"] = 4987.5, ["Neon"] = 32003.24, ["Neon|Fly|Ride"] = 21180.81, ["Mega|Fly|Ride"] = 49875}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 6.04, ["Fly"] = 85.35, ["Ride"] = 56.44, ["Neon"] = 53.72, ["Neon|Ride"] = 106.32, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 178.5, ["Mega|Ride"] = 214.85, ["Mega|Fly|Ride"] = 408.73}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 24.7, ["Ride"] = 17.06, ["Fly|Ride"] = 42, ["Neon"] = 14.07, ["Neon|Fly"] = 37.35, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 102.09, ["Mega"] = 131.25, ["Mega|Ride"] = 177.77, ["Mega|Fly|Ride"] = 183.08}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 426.57, ["Fly"] = 547.77, ["Ride"] = 451.5, ["Fly|Ride"] = 506.73, ["Neon"] = 1607.64, ["Neon|Ride"] = 1292.82, ["Neon|Fly|Ride"] = 1296.01, ["Mega|Fly|Ride"] = 4873.32}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 3.24, ["Ride"] = 33.78, ["Neon"] = 11.82, ["Neon|Ride"] = 291.38, ["Mega"] = 113.9, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 693}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 4.29, ["Fly"] = 4265.54, ["Ride"] = 35.44, ["Neon"] = 32.02, ["Neon|Fly"] = 118.43, ["Neon|Ride"] = 65.4, ["Neon|Fly|Ride"] = 306.18, ["Mega"] = 424.69, ["Mega|Ride"] = 284.67, ["Mega|Fly|Ride"] = 498.1}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 50.95, ["Ride"] = 21.38, ["Fly|Ride"] = 48.29, ["Neon"] = 4.72, ["Neon|Fly"] = 124.69, ["Neon|Ride"] = 28.18, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 44.52, ["Mega|Ride"] = 67.33, ["Mega|Fly|Ride"] = 274.62}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 611.02, ["Fly"] = 755.21, ["Ride"] = 612.9, ["Fly|Ride"] = 654.92, ["Neon|Ride"] = 2126.27, ["Neon|Fly|Ride"] = 2135.44, ["Mega|Fly|Ride"] = 9224.78}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 6.57, ["Fly"] = 300.41, ["Ride"] = 65.01, ["Fly|Ride"] = 136.62, ["Neon"] = 31.5, ["Neon|Ride"] = 104.9, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 183.65, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 3.71, ["Fly"] = 236.15, ["Ride"] = 42.63, ["Fly|Ride"] = 76.56, ["Neon"] = 19.13, ["Neon|Ride"] = 59.06, ["Neon|Fly|Ride"] = 144.37, ["Mega"] = 169.25, ["Mega|Fly"] = 805.84, ["Mega|Ride"] = 181.13, ["Mega|Fly|Ride"] = 270.39}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 34.13, ["Ride"] = 16.02, ["Fly|Ride"] = 43.31, ["Neon"] = 15.59, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 82.47, ["Mega"] = 185.21, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 232.2}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 19.59, ["Ride"] = 34.12, ["Fly|Ride"] = 55.6, ["Neon"] = 117.59, ["Mega"] = 568.38, ["Mega|Ride"] = 472.49, ["Mega|Fly|Ride"] = 549.22}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Ride"] = 42.87, ["Fly|Ride"] = 426.72, ["Neon"] = 2.1, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 45.88, ["Neon|Fly|Ride"] = 106.7, ["Mega"] = 31.48, ["Mega|Fly"] = 142.64, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 185.07}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 551.25, ["Fly"] = 668.81, ["Ride"] = 538.12, ["Fly|Ride"] = 630, ["Neon"] = 2589.57, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Ride"] = 9423.41, ["Mega|Fly|Ride"] = 7861.88}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 72.19, ["Fly|Ride"] = 341.38, ["Neon"] = 13, ["Neon|Ride"] = 86.14, ["Neon|Fly|Ride"] = 445.93, ["Mega"] = 78.75, ["Mega|Ride"] = 224.44, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 34, ["Neon"] = 3.41, ["Neon|Fly"] = 142.96, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 39.1, ["Mega|Fly|Ride"] = 283.49}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 57.62, ["Neon"] = 3.93, ["Neon|Ride"] = 56.14, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 46.97, ["Mega|Fly"] = 157.54, ["Mega|Ride"] = 118.16, ["Mega|Fly|Ride"] = 170.85}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 38.33, ["Neon|Ride"] = 48.18, ["Mega"] = 212.89, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 26.24, ["Fly"] = 64.97, ["Ride"] = 53.07, ["Fly|Ride"] = 144.37, ["Neon"] = 103.94, ["Neon|Fly"] = 213.38, ["Neon|Ride"] = 142.96, ["Neon|Fly|Ride"] = 283.5, ["Mega"] = 511.88, ["Mega|Ride"] = 437.06, ["Mega|Fly|Ride"] = 553.27}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 37.37, ["Ride"] = 73.96, ["Fly|Ride"] = 106.7, ["Neon"] = 78.74, ["Neon|Ride"] = 123.38, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 500.27, ["Mega|Ride"] = 441.13, ["Mega|Fly|Ride"] = 572.25}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly"] = 32.7, ["Ride"] = 14.33, ["Fly|Ride"] = 26.25, ["Neon"] = 28.59, ["Neon|Fly"] = 142.96, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 88.01, ["Mega"] = 246.47, ["Mega|Ride"] = 284.2, ["Mega|Fly|Ride"] = 319.52}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 7.75, ["Ride"] = 105.4, ["Fly|Ride"] = 134.43, ["Neon"] = 38.05, ["Neon|Ride"] = 142.96}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Ride"] = 26.16, ["Fly|Ride"] = 100.12, ["Neon"] = 6.57, ["Neon|Ride"] = 38.76, ["Neon|Fly|Ride"] = 114.15, ["Mega"] = 65.63, ["Mega|Ride"] = 115.5, ["Mega|Fly|Ride"] = 273.05}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 20.22, ["Fly"] = 113.88, ["Ride"] = 26.23, ["Fly|Ride"] = 43.52, ["Neon"] = 110.25, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 195.24, ["Mega"] = 787.5, ["Mega|Fly|Ride"] = 842.99}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 54.42, ["Fly"] = 874.13, ["Neon"] = 78.75, ["Mega"] = 328.13, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 492.85}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 49.79, ["Fly"] = 153.58, ["Ride"] = 80.07, ["Fly|Ride"] = 91.88, ["Neon"] = 324.83, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 415.79, ["Mega|Ride"] = 1708.31, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 37.27, ["Fly"] = 129.63, ["Ride"] = 55.13, ["Fly|Ride"] = 118.13, ["Neon"] = 143.42, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 210, ["Mega"] = 551.25, ["Mega|Ride"] = 709.93, ["Mega|Fly|Ride"] = 632}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 22.24, ["Ride"] = 57.5, ["Neon"] = 104.99, ["Neon|Ride"] = 223.12, ["Mega"] = 1050, ["Mega|Ride"] = 805.84, ["Mega|Fly|Ride"] = 807.19}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 23.24, ["Fly"] = 81.73, ["Ride"] = 62.98, ["Fly|Ride"] = 194.91, ["Neon"] = 137.82, ["Neon|Fly"] = 420, ["Neon|Ride"] = 212.14, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 513.53, ["Mega|Ride"] = 565.55, ["Mega|Fly|Ride"] = 661.33}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 17.95, ["Ride"] = 14.42, ["Fly|Ride"] = 32.74, ["Neon"] = 2.1, ["Neon|Fly"] = 27.36, ["Neon|Ride"] = 34.07, ["Neon|Fly|Ride"] = 54.3, ["Mega"] = 38.41, ["Mega|Fly"] = 322.59, ["Mega|Ride"] = 57.7, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 866.24}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 64.3, ["Fly"] = 484.52, ["Ride"] = 97.44, ["Fly|Ride"] = 262.39, ["Neon"] = 377.9, ["Neon|Ride"] = 458.07, ["Neon|Fly|Ride"] = 525, ["Mega"] = 1417.5, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1311.19}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 79.75, ["Neon"] = 2.63, ["Neon|Fly"] = 100.29, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 298.04, ["Mega"] = 25.95, ["Mega|Ride"] = 84.95, ["Mega|Fly|Ride"] = 152.37}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 21.29, ["Ride"] = 114.14, ["Fly|Ride"] = 142.65, ["Neon"] = 121.07, ["Neon|Ride"] = 128.03, ["Neon|Fly|Ride"] = 498.75, ["Mega"] = 591.93, ["Mega|Ride"] = 496.13, ["Mega|Fly|Ride"] = 721.87}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Fly|Ride"] = 106.7, ["Mega"] = 25.44}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 3.19, ["Mega"] = 22.89, ["Mega|Ride"] = 142.64, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 87.91, ["Fly"] = 223.13, ["Ride"] = 144.37, ["Fly|Ride"] = 328.13, ["Neon"] = 433.13, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 668.32, ["Mega|Ride"] = 2271.35, ["Mega|Fly|Ride"] = 2098.52}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 90.57, ["Ride"] = 21.53, ["Fly|Ride"] = 96.9, ["Neon"] = 6.57, ["Neon|Fly"] = 42.69, ["Neon|Ride"] = 32.24, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 90.19, ["Mega|Ride"] = 116.81, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 38.07, ["Fly|Ride"] = 53.82, ["Neon"] = 5.14, ["Neon|Ride"] = 51.19, ["Neon|Fly|Ride"] = 142.64, ["Mega"] = 31.17, ["Mega|Ride"] = 95.46, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 6.42, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 236.15, ["Mega"] = 103.69, ["Mega|Ride"] = 163.13, ["Mega|Fly|Ride"] = 483.27}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 88.99, ["Neon"] = 6.45, ["Neon|Ride"] = 43.22, ["Mega"] = 78.65, ["Mega|Fly"] = 195.85, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 71.48, ["Ride"] = 131.24, ["Fly|Ride"] = 356.32, ["Neon"] = 437.07, ["Neon|Ride"] = 568.32, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 2271.35, ["Mega|Ride"] = 2128.72, ["Mega|Fly|Ride"] = 2113.82}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 4.36, ["Ride"] = 75.99, ["Neon"] = 88.86, ["Neon|Ride"] = 77.43, ["Mega"] = 413.86, ["Mega|Ride"] = 366.19, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 393.65, ["Ride"] = 421.19, ["Fly|Ride"] = 518.36, ["Neon"] = 1752.19, ["Neon|Ride"] = 1423.1, ["Neon|Fly|Ride"] = 1102.5, ["Mega|Fly|Ride"] = 3346.87}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 91.82}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 49.23}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 15.49}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 15.74}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 143.09}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 41.99}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 13.53}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 3.94}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 161.42}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 13.41}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 33.43}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 8.98}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 9.07}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 839.99}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 4.67}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 11.74}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 4.97}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 3.83}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 13.86}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 577.5}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 589.91}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 6.28}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1312.5}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 100.28}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 9.08}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 34.09}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 16.2}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 34.13}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 50.13}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 16.95}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 13.13}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 19.19}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 12.39}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 3.82}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.15}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 20.98}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 14.13}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 6.12}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 2986.62}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 42.2}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 311.05}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 2.99}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 3.42}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 6.14}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 9.89}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 45.94}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 212.62}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 6.57}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 6.36}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 144.38}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 21.67}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 8.47}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 21}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 16.02}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 3.84}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 106.32}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 21}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 8.48}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 19.59}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 6.28}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 3.94}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 28.88}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 93.18}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 233.63}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 5.03}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 7.22}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 17.97}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 24.85}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 61.67}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 19.49}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 23072.15}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 124.69}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 41.91}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 36.75}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 27.18}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 39.38}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 24.94}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 40.58}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 85.89}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 81.38}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 31.18}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 78.75}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 209.97}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 55.13}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 39.4}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 214.26}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 9.1}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 6.37}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 4.87}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 3.94}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 17.09}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 109.1}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.1}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 3.94}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 5.25}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 6.56}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 11.46}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 270.13}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 1128.23}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 7.07}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 583.86}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 12.9}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.1}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.62}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 231}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 26.15}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 91.88}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 15.94}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 27.19}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 44.51}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 13.92}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 2.1}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 8.93}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 3.82}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 3.57}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 4.94}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 31.5}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 2.1}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 2.1}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 2.1}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 14.28}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 183.75}},
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
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 213.35}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 12.46}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 9.19}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 7.87}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 24.68}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 6.57}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 3.94}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 8.27}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 4.86}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 17.07}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 15.43}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 2.63}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 2.88}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 6.27}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 8.18}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 2.41}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 8.55}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 3.6}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 3.19}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 5.16}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.15}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 9381.75}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 11.46}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 2.43}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 4.6}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 4.29}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.52}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 40.51}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 5.8}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 6.24}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 3.88}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 5.07}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 40.18}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 5.87}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 3.94}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 7.32}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 3.93}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 2.63}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 3.12}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4524.08}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 6.35}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 32.06}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.63}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 2.51}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 45.94}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.15}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 3.56}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 102.38}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 15.75}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 3.8}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.1}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 3.15}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 8.5}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 22.32}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 5.4}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 6.17}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 3.51}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 6.35}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.33}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 3.82}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 15.65}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 4.41}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 10.2}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 104.9}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.68}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 78.56}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 6.27}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 2.29}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1213.94}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 62.85}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 5.25}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 22.91}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 24.33}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 15.87}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 5.24}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 13.12}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 15.75}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 12.01}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 3.92}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 3.5}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 11.82}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 6.56}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 20.88}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 3.3}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 3.56}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 9.19}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 58.86}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 3.92}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 16.69}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 90.57}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 8.73}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 2.63}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 26.23}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 31.49}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 3.94}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 5.45}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 3.71}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 74.72}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 150.94}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 10.16}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1187.82}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.51}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 196.88}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 9.09}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 4.47}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 57.94}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 14.44}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 3.49}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 106.31}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 16.09}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 16.96}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 3.94}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 6.56}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 2.52}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 53.17}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 10.4}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 62.92}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.63}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 6.49}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 5.25}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 31.5}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 137.2}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 3.54}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 81.29}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 3.29}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 6.57}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 54.78}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.35}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 57.26}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 47.95}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 169.16}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 59.07}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 6.14}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 127.93}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 3.47}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 25.91}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 57.43}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 2.63}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 61.69}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 7.55}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 7.26}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 11.82}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 13.11}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 75.24}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 35.44}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 11.68}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 27.75}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 36.75}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 2.52}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 3.9}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 23.63}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 11.15}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 78.73}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 43.05}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 40.69}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1994.99}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 9.48}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 6.36}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 19.66}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 354.38}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 15.18}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 7.45}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 5.9}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 7.33}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 3.73}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 318.83}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 57}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 45.57}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 5.18}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 54.51}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 194.91}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 77.21}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 849.07}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 155.91}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 7.76}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 2362.5}},
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