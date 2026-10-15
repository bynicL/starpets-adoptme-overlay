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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 1139.2, ["Ride"] = 1049.99, ["Fly|Ride"] = 1419.69, ["Neon"] = 6756.82, ["Neon|Ride"] = 6825, ["Neon|Fly|Ride"] = 12603.94, ["Mega|Fly|Ride"] = 21284.54}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 406.87, ["Fly"] = 393.75, ["Ride"] = 500.35, ["Fly|Ride"] = 544.69, ["Neon|Fly|Ride"] = 1706.25, ["Mega|Fly|Ride"] = 7372.98}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 6562.5, ["Ride"] = 5250, ["Fly|Ride"] = 4723.63, ["Neon|Fly|Ride"] = 28379.75, ["Mega|Fly|Ride"] = 70948.81}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 142.63, ["Ride"] = 170.63, ["Fly|Ride"] = 309.75, ["Neon"] = 1051.47, ["Neon|Ride"] = 979.1, ["Neon|Fly|Ride"] = 1134.48, ["Mega|Fly|Ride"] = 4560.94}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 610.88, ["Fly"] = 851.4, ["Ride"] = 555.19, ["Fly|Ride"] = 525, ["Neon|Fly|Ride"] = 1745.63, ["Mega|Fly|Ride"] = 6953.67}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 9.01, ["Ride"] = 57.69, ["Fly|Ride"] = 129.94, ["Neon"] = 72.19, ["Neon|Fly"] = 284.16, ["Neon|Ride"] = 54.46, ["Neon|Fly|Ride"] = 319.29, ["Mega"] = 354.38, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 425.71}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 3.49, ["Fly"] = 46.39, ["Ride"] = 25.2, ["Fly|Ride"] = 67.44, ["Neon"] = 31.5, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 188.97, ["Mega|Ride"] = 235.2, ["Mega|Fly|Ride"] = 303.19}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 106.47, ["Fly"] = 212.86, ["Ride"] = 185.07, ["Fly|Ride"] = 240.53, ["Neon"] = 566.19, ["Neon|Ride"] = 492.19, ["Neon|Fly|Ride"] = 670.47, ["Mega"] = 1586.82, ["Mega|Ride"] = 2492.44, ["Mega|Fly|Ride"] = 2818.09}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 35.21, ["Fly"] = 78.77, ["Ride"] = 36.26, ["Fly|Ride"] = 103.57, ["Neon"] = 257.62, ["Neon|Ride"] = 242.82, ["Neon|Fly|Ride"] = 238.88, ["Mega"] = 1419.69, ["Mega|Ride"] = 1164.28, ["Mega|Fly|Ride"] = 918.74}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 21, ["Fly"] = 37.21, ["Ride"] = 28.75, ["Fly|Ride"] = 42, ["Neon"] = 118.13, ["Neon|Ride"] = 136.5, ["Neon|Fly|Ride"] = 197.97, ["Mega|Ride"] = 568.29, ["Mega|Fly|Ride"] = 781.92}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 55.01, ["Fly"] = 127.73, ["Ride"] = 72.19, ["Fly|Ride"] = 162.75, ["Neon"] = 341.84, ["Neon|Ride"] = 321.57, ["Neon|Fly|Ride"] = 425.25, ["Mega|Fly|Ride"] = 1277.09}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 66.85}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 387.26, ["Fly"] = 399, ["Ride"] = 327.76, ["Fly|Ride"] = 398.99, ["Neon|Ride"] = 1048.69, ["Neon|Fly|Ride"] = 1181.23, ["Mega|Fly|Ride"] = 4966.76}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 114.19, ["Fly"] = 178.6, ["Ride"] = 118.13, ["Fly|Ride"] = 142.91, ["Neon|Fly"] = 627.44, ["Neon|Ride"] = 573.03, ["Neon|Fly|Ride"] = 564.38, ["Mega"] = 4312.63, ["Mega|Fly|Ride"] = 2467.5}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 3.84, ["Ride"] = 57.48, ["Fly|Ride"] = 131.25, ["Neon"] = 21, ["Neon|Ride"] = 56.35, ["Neon|Fly|Ride"] = 202.73, ["Mega"] = 156.19, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 337.92}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 196.88, ["Fly"] = 262.5, ["Ride"] = 225.75, ["Fly|Ride"] = 229.67, ["Neon|Ride"] = 957.83, ["Neon|Fly|Ride"] = 701.32, ["Mega|Fly|Ride"] = 3335.31}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.75, ["Fly"] = 26.11, ["Ride"] = 16.22, ["Fly|Ride"] = 39.38, ["Neon"] = 28.85, ["Neon|Fly"] = 80.88, ["Neon|Ride"] = 53.23, ["Neon|Fly|Ride"] = 110.71, ["Mega"] = 211.79, ["Mega|Ride"] = 320.25, ["Mega|Fly|Ride"] = 422.63}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 89.52, ["Fly"] = 161.7, ["Ride"] = 127.18, ["Fly|Ride"] = 257.17, ["Neon"] = 301.88, ["Neon|Ride"] = 291.38, ["Neon|Fly|Ride"] = 486.94, ["Mega"] = 1702.78, ["Mega|Ride"] = 1419.69, ["Mega|Fly|Ride"] = 1443.75}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 39.69}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 68.25, ["Ride"] = 153.26, ["Fly|Ride"] = 276.72, ["Neon"] = 459.38, ["Neon|Fly|Ride"] = 787.5, ["Mega|Fly|Ride"] = 1841.14}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 19.69, ["Fly"] = 55.36, ["Ride"] = 32.59, ["Fly|Ride"] = 383.14, ["Neon"] = 212.86, ["Neon|Ride"] = 209.99, ["Neon|Fly|Ride"] = 325.67, ["Mega"] = 2775.67, ["Mega|Ride"] = 956.76, ["Mega|Fly|Ride"] = 952.5}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 39.15, ["Fly"] = 57.5, ["Ride"] = 57.21, ["Fly|Ride"] = 90.02, ["Neon"] = 306.49, ["Neon|Ride"] = 220.49, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1689.54, ["Mega|Ride"] = 1021.68, ["Mega|Fly|Ride"] = 941.99}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 40.09, ["Fly"] = 262.5, ["Ride"] = 111.57, ["Fly|Ride"] = 196.88, ["Neon"] = 236.25, ["Neon|Ride"] = 384.58, ["Neon|Fly|Ride"] = 467.25, ["Mega"] = 1287.67, ["Mega|Ride"] = 1334.55, ["Mega|Fly|Ride"] = 1504.83}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 20.24, ["Ride"] = 35.18, ["Fly|Ride"] = 92.53, ["Neon"] = 120.65, ["Neon|Ride"] = 212.86, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 1207.92, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 39.38, ["Fly"] = 138.36, ["Ride"] = 62.34, ["Fly|Ride"] = 178.81, ["Neon"] = 325.5, ["Neon|Ride"] = 169.31, ["Neon|Fly|Ride"] = 262.49, ["Mega|Ride"] = 3192.7, ["Mega|Fly|Ride"] = 1018.5}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 8.59, ["Fly"] = 17.05, ["Ride"] = 19.59, ["Fly|Ride"] = 61.57, ["Neon"] = 45.93, ["Neon|Fly"] = 57.47, ["Neon|Ride"] = 41.99, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 174.57, ["Mega|Fly"] = 274.32, ["Mega|Ride"] = 182.43, ["Mega|Fly|Ride"] = 298.86}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 393.75, ["Ride"] = 498.75, ["Fly|Ride"] = 510.57, ["Neon|Ride"] = 1689.18, ["Neon|Fly|Ride"] = 1966.13, ["Mega"] = 10642.28, ["Mega|Fly|Ride"] = 9171.72}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 13.46, ["Ride"] = 32.79, ["Fly|Ride"] = 65.63, ["Neon"] = 219.18, ["Neon|Ride"] = 129.94, ["Mega|Ride"] = 744.98, ["Mega|Fly|Ride"] = 671.66}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 6.85, ["Fly"] = 38.07, ["Ride"] = 15.75, ["Fly|Ride"] = 41.57, ["Neon"] = 52.49, ["Neon|Ride"] = 74.59, ["Neon|Fly|Ride"] = 128.82, ["Mega"] = 284.16, ["Mega|Ride"] = 315.93, ["Mega|Fly|Ride"] = 364.88}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 78.75, ["Fly"] = 118.07, ["Ride"] = 78.75, ["Fly|Ride"] = 126.31, ["Neon"] = 294.96, ["Neon|Ride"] = 283.5, ["Neon|Fly|Ride"] = 398.99, ["Mega"] = 6394.87, ["Mega|Ride"] = 2430.51, ["Mega|Fly|Ride"] = 2100}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 11.79, ["Ride"] = 34.07, ["Fly|Ride"] = 75.55, ["Neon"] = 123.34, ["Neon|Ride"] = 112.88, ["Neon|Fly|Ride"] = 157.4, ["Mega"] = 709.85, ["Mega|Ride"] = 563.6}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 197.98, ["Fly"] = 262.5, ["Ride"] = 224.44, ["Fly|Ride"] = 315, ["Neon"] = 633.24, ["Neon|Ride"] = 804.96, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 3404.47, ["Mega|Fly|Ride"] = 2873.42}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 20.99}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.84, ["Fly"] = 32.6, ["Ride"] = 26.77, ["Fly|Ride"] = 73.75, ["Neon"] = 26.17, ["Neon|Fly"] = 142.63, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 105, ["Mega"] = 174.57, ["Mega|Fly"] = 284.16, ["Mega|Ride"] = 169.31, ["Mega|Fly|Ride"] = 199.03}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 889.88, ["Fly"] = 2625, ["Ride"] = 908.25, ["Fly|Ride"] = 941.07, ["Neon"] = 4256.91, ["Neon|Ride"] = 4825.22, ["Neon|Fly|Ride"] = 4753.91, ["Mega|Ride"] = 54306.16, ["Mega|Fly|Ride"] = 16931.25}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 11.46, ["Fly"] = 41.25, ["Ride"] = 42.49, ["Fly|Ride"] = 91.59, ["Neon"] = 170.29, ["Neon|Ride"] = 151.14, ["Neon|Fly|Ride"] = 181.13, ["Mega"] = 1009.32, ["Mega|Ride"] = 1089.78, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 209.99, ["Fly"] = 362, ["Ride"] = 262.5, ["Fly|Ride"] = 367.5, ["Neon"] = 830.82, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 1030.31, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 3899.56}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 38.07}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 14.49, ["Fly"] = 127.73, ["Ride"] = 26.25, ["Fly|Ride"] = 142.63, ["Neon"] = 65.63, ["Neon|Ride"] = 128.62, ["Neon|Fly|Ride"] = 340.57, ["Mega"] = 355.46, ["Mega|Ride"] = 566.19, ["Mega|Fly|Ride"] = 597.38}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 110.65, ["Ride"] = 144.24, ["Fly|Ride"] = 271.4, ["Neon"] = 637.48, ["Neon|Ride"] = 420, ["Neon|Fly|Ride"] = 523.62, ["Mega"] = 2128.47, ["Mega|Ride"] = 2097.61, ["Mega|Fly|Ride"] = 2092.6}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 102.26, ["Fly"] = 157.49, ["Ride"] = 115.71, ["Fly|Ride"] = 217.88, ["Neon"] = 388.4, ["Neon|Fly"] = 568.31, ["Neon|Ride"] = 434.77, ["Neon|Fly|Ride"] = 496.12, ["Mega|Ride"] = 1378.13, ["Mega|Fly|Ride"] = 1241.63}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 33.39}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 79.84, ["Fly"] = 69.29, ["Ride"] = 52.37, ["Fly|Ride"] = 66.76, ["Neon|Ride"] = 361.85, ["Neon|Fly|Ride"] = 324.18, ["Mega"] = 4256.91, ["Mega|Fly|Ride"] = 1350.21}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 5.9, ["Fly"] = 98.44, ["Ride"] = 28.74, ["Fly|Ride"] = 206.34, ["Neon"] = 33.28, ["Neon|Fly"] = 223.13, ["Neon|Ride"] = 124.79, ["Neon|Fly|Ride"] = 239.47, ["Mega"] = 170.63, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 318.22, ["Mega|Fly|Ride"] = 381.94}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 577.4, ["Fly"] = 700.87, ["Ride"] = 413.44, ["Fly|Ride"] = 450.12, ["Neon|Fly"] = 3831.22, ["Neon|Ride"] = 1966.7, ["Neon|Fly|Ride"] = 1771.88, ["Mega|Ride"] = 14899.18, ["Mega|Fly|Ride"] = 7481.25}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 90.57, ["Fly"] = 157.52, ["Ride"] = 91.77, ["Fly|Ride"] = 176.68, ["Neon"] = 420, ["Neon|Ride"] = 556.5, ["Neon|Fly|Ride"] = 656.25, ["Mega|Ride"] = 2554.16, ["Mega|Fly|Ride"] = 2582.89}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3974.91, ["Ride"] = 3885, ["Fly|Ride"] = 3937.5, ["Neon|Fly|Ride"] = 14898.12}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 54.56, ["Fly"] = 121.34, ["Ride"] = 52.5, ["Fly|Ride"] = 139.79, ["Neon"] = 441.67, ["Neon|Ride"] = 297.94, ["Neon|Fly|Ride"] = 292.69, ["Mega"] = 1913.5, ["Mega|Ride"] = 1443.75, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 73.5, ["Ride"] = 65.63, ["Fly|Ride"] = 142.43, ["Neon"] = 575.75, ["Neon|Ride"] = 427.88, ["Neon|Fly|Ride"] = 383.14, ["Mega"] = 6243.84, ["Mega|Ride"] = 2388.75, ["Mega|Fly|Ride"] = 2102.99}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 31.64, ["Fly"] = 47.23, ["Ride"] = 37.7, ["Fly|Ride"] = 90.57, ["Neon"] = 170.63, ["Neon|Fly"] = 284.16, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 203.94, ["Mega"] = 994, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 577.44}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 6.57}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 53.33, ["Fly"] = 393.75, ["Ride"] = 27.64, ["Fly|Ride"] = 96.15, ["Neon|Ride"] = 284.16, ["Neon|Fly|Ride"] = 568.31, ["Mega|Ride"] = 1287.67, ["Mega|Fly|Ride"] = 1448.18}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 28.14}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 157.5, ["Ride"] = 233.89, ["Fly|Ride"] = 282.19, ["Neon|Ride"] = 1104.68, ["Neon|Fly|Ride"] = 1132.36, ["Mega|Fly|Ride"] = 4588.96}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 635.23, ["Ride"] = 641.82, ["Fly|Ride"] = 715.32, ["Neon"] = 2625, ["Neon|Fly|Ride"] = 3620.43, ["Mega|Fly|Ride"] = 10216.6}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 4.83}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 26.17, ["Fly"] = 53.1, ["Ride"] = 36.22, ["Fly|Ride"] = 71.32, ["Neon"] = 227.76, ["Neon|Fly"] = 323.01, ["Neon|Ride"] = 177.84, ["Neon|Fly|Ride"] = 190.77, ["Mega"] = 2128.47, ["Mega|Ride"] = 1155.32, ["Mega|Fly|Ride"] = 735}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 19.14}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5250, ["Ride"] = 5650.32, ["Fly|Ride"] = 4921.87, ["Neon|Ride"] = 17701.41, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 43444.93}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 10.49, ["Fly"] = 55.13, ["Ride"] = 22.5, ["Fly|Ride"] = 56.42, ["Neon"] = 72.19, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 195.42, ["Mega"] = 462.21, ["Mega|Ride"] = 490.88, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 12.49, ["Fly"] = 139.42, ["Ride"] = 30.19, ["Neon"] = 99.95, ["Neon|Ride"] = 122.07, ["Neon|Fly|Ride"] = 105, ["Mega"] = 743.92, ["Mega|Ride"] = 841.82, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 70.6, ["Ride"] = 58.95, ["Fly|Ride"] = 85.15, ["Neon|Ride"] = 394.84, ["Neon|Fly|Ride"] = 480.96, ["Mega"] = 4256.91, ["Mega|Fly|Ride"] = 1770.4}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 9.17, ["Fly"] = 71.32, ["Ride"] = 26.17, ["Fly|Ride"] = 65.63, ["Neon"] = 73.33, ["Neon|Ride"] = 128.37, ["Neon|Fly|Ride"] = 161.73, ["Mega"] = 1419.69, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 813.75}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1783.69, ["Fly"] = 1640.63, ["Ride"] = 1851.94, ["Fly|Ride"] = 1661.9, ["Neon|Fly|Ride"] = 3412.49, ["Mega|Fly|Ride"] = 12468.75}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 27300, ["Fly"] = 34055.26, ["Ride"] = 35437.5, ["Fly|Ride"] = 25428.38, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 63000, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 183748.69}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 19.95, ["Fly"] = 393.75, ["Ride"] = 55.13, ["Fly|Ride"] = 127.73, ["Neon"] = 284.16, ["Neon|Ride"] = 208.69, ["Neon|Fly|Ride"] = 568.31, ["Mega"] = 994, ["Mega|Ride"] = 1141.88, ["Mega|Fly|Ride"] = 1366.12}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 2.1, ["Fly"] = 63, ["Ride"] = 45.48, ["Fly|Ride"] = 71.32, ["Neon"] = 21.95, ["Neon|Fly"] = 131.24, ["Neon|Ride"] = 58.7, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 136.4, ["Mega|Fly"] = 298.08, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 322.88}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 23}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 7.37, ["Ride"] = 40.37, ["Fly|Ride"] = 124.68, ["Neon"] = 56.6, ["Neon|Ride"] = 116.8, ["Neon|Fly|Ride"] = 212.86, ["Mega"] = 382.08, ["Mega|Ride"] = 425.71, ["Mega|Fly|Ride"] = 724.1}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 656.15, ["Fly"] = 901.39, ["Ride"] = 689.07, ["Fly|Ride"] = 656.25, ["Neon"] = 2767.01, ["Neon|Ride"] = 2809.57, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 10073.99}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 839.79, ["Fly"] = 1064.24, ["Ride"] = 957.5, ["Fly|Ride"] = 1010.18, ["Neon"] = 4115.37, ["Neon|Ride"] = 3270.99, ["Neon|Fly|Ride"] = 3180.38, ["Mega|Fly|Ride"] = 11770.36}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 11.46, ["Fly"] = 120.67, ["Ride"] = 26.25, ["Fly|Ride"] = 84, ["Neon"] = 85.3, ["Neon|Ride"] = 108.56, ["Neon|Fly|Ride"] = 161.44, ["Mega"] = 1209.72, ["Mega|Ride"] = 481.69, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 22.91}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 66.94, ["Fly"] = 89.25, ["Ride"] = 65.05, ["Fly|Ride"] = 105, ["Neon"] = 513.02, ["Neon|Ride"] = 489.56, ["Neon|Fly|Ride"] = 420, ["Mega"] = 19687.5, ["Mega|Fly|Ride"] = 2105.06}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 78.75, ["Ride"] = 89.13, ["Fly|Ride"] = 212.86, ["Neon"] = 320.15, ["Neon|Ride"] = 386.78, ["Neon|Fly|Ride"] = 500.78, ["Mega"] = 1411.67, ["Mega|Ride"] = 1702.78, ["Mega|Fly|Ride"] = 1858.49}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 4.68, ["Fly"] = 28.38, ["Ride"] = 19.58, ["Fly|Ride"] = 45.94, ["Neon"] = 34.08, ["Neon|Fly"] = 524.98, ["Neon|Ride"] = 68.13, ["Neon|Fly|Ride"] = 110.92, ["Mega"] = 283.1, ["Mega|Ride"] = 289.48, ["Mega|Fly|Ride"] = 553.42}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 146.9, ["Fly"] = 162.07, ["Ride"] = 157.4, ["Fly|Ride"] = 209.9, ["Neon"] = 922.69, ["Neon|Ride"] = 550.46, ["Neon|Fly|Ride"] = 551.25, ["Mega"] = 5108.31, ["Mega|Fly|Ride"] = 2559.37}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 3.93, ["Ride"] = 44.54, ["Fly|Ride"] = 142.63, ["Neon"] = 34.08, ["Neon|Fly"] = 170.29, ["Neon|Ride"] = 211.78, ["Neon|Fly|Ride"] = 424.69, ["Mega"] = 198.35, ["Mega|Fly"] = 338.44, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 422.63}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 15.81, ["Fly"] = 40.26, ["Ride"] = 26.25, ["Fly|Ride"] = 80.85, ["Neon"] = 128.63, ["Neon|Fly"] = 161.69, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 667.29, ["Mega|Ride"] = 823.73, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 26.17, ["Ride"] = 68.22, ["Fly|Ride"] = 156.19, ["Neon"] = 161.69, ["Neon|Ride"] = 223.13, ["Mega"] = 918.75, ["Mega|Ride"] = 1161.57, ["Mega|Fly|Ride"] = 922.69}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 15.3, ["Fly"] = 212.86, ["Ride"] = 24.7, ["Fly|Ride"] = 63.88, ["Neon"] = 103.69, ["Neon|Ride"] = 125.58, ["Neon|Fly|Ride"] = 317.63, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 4989.6, ["Ride"] = 5248.69, ["Fly|Ride"] = 5643.75, ["Neon"] = 35474.95, ["Neon|Ride"] = 28379.75, ["Neon|Fly|Ride"] = 25962.89}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 210, ["Fly"] = 234.94, ["Ride"] = 223.01, ["Fly|Ride"] = 288.74, ["Neon"] = 744.98, ["Neon|Ride"] = 724.1, ["Neon|Fly|Ride"] = 564.37, ["Mega|Fly|Ride"] = 1968.74}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 47.16, ["Fly"] = 139.12, ["Ride"] = 78.75, ["Fly|Ride"] = 185.19, ["Neon"] = 157.4, ["Neon|Fly"] = 322.17, ["Neon|Ride"] = 185.94, ["Neon|Fly|Ride"] = 301.88, ["Mega"] = 471.19, ["Mega|Fly"] = 511.88, ["Mega|Ride"] = 496.67, ["Mega|Fly|Ride"] = 597.19}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 3.29, ["Fly"] = 89.31, ["Ride"] = 27.68, ["Fly|Ride"] = 52.49, ["Neon"] = 24.14, ["Neon|Fly"] = 85.15, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 499.8, ["Mega|Ride"] = 330.75, ["Mega|Fly|Ride"] = 360.85}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 59.07, ["Fly"] = 191.28, ["Ride"] = 120.74, ["Fly|Ride"] = 229.59, ["Neon"] = 209.9, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 391.12, ["Mega"] = 563.07, ["Mega|Ride"] = 563.07, ["Mega|Fly|Ride"] = 707.26}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 13965, ["Ride"] = 13415.07, ["Fly|Ride"] = 11808.57, ["Neon|Fly|Ride"] = 27562.5, ["Mega|Fly|Ride"] = 113517.87}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 212.63, ["Ride"] = 315, ["Fly|Ride"] = 459.38, ["Neon|Ride"] = 1419.69, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 7240.84}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 50.3, ["Fly"] = 80.59, ["Ride"] = 69.57, ["Fly|Ride"] = 93.52, ["Neon"] = 404.42, ["Neon|Ride"] = 328.11, ["Neon|Fly|Ride"] = 290.66, ["Mega|Fly|Ride"] = 3086.27}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 7.67, ["Ride"] = 25.75, ["Fly|Ride"] = 53.27, ["Neon"] = 67.47, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 393.75, ["Mega|Ride"] = 425.71, ["Mega|Fly|Ride"] = 1064.24}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 367.4, ["Fly"] = 851.4, ["Ride"] = 361.98, ["Fly|Ride"] = 528.94, ["Neon"] = 1688.94, ["Neon|Ride"] = 1376.76, ["Neon|Fly|Ride"] = 1702.78, ["Mega|Fly|Ride"] = 5214.74}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 6.96, ["Ride"] = 26.25, ["Fly|Ride"] = 191.01, ["Neon"] = 31.39, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 144.12, ["Mega|Fly"] = 255.43, ["Mega|Ride"] = 216.57, ["Mega|Fly|Ride"] = 340.57}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 104.14, ["Fly"] = 164.07, ["Ride"] = 137.62, ["Fly|Ride"] = 190.31, ["Neon"] = 406.88, ["Neon|Fly"] = 525, ["Neon|Ride"] = 488.25, ["Neon|Fly|Ride"] = 465.94, ["Mega|Fly|Ride"] = 2412.62}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 11.82, ["Fly"] = 18.27, ["Ride"] = 17.07, ["Fly|Ride"] = 32.45, ["Neon"] = 161.69, ["Neon|Fly"] = 80.85, ["Neon|Ride"] = 196.86, ["Neon|Fly|Ride"] = 78.72, ["Mega"] = 2554.16, ["Mega|Fly|Ride"] = 423.56}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 8.28}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 65.51, ["Ride"] = 85.53, ["Fly|Ride"] = 176.68, ["Neon"] = 359.63, ["Neon|Fly"] = 424.64, ["Neon|Ride"] = 406.87, ["Neon|Fly|Ride"] = 355.46, ["Mega"] = 1561.62, ["Mega|Ride"] = 1845.38, ["Mega|Fly|Ride"] = 1529.04}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 11.67, ["Fly"] = 80.07, ["Ride"] = 30.12, ["Fly|Ride"] = 77.97, ["Neon"] = 98.44, ["Neon|Ride"] = 132.57, ["Neon|Fly|Ride"] = 196.85, ["Mega"] = 644.45, ["Mega|Ride"] = 568.31, ["Mega|Fly|Ride"] = 576.02}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 26.17}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 51.75, ["Fly"] = 142.63, ["Ride"] = 99.75, ["Fly|Ride"] = 316.32, ["Neon"] = 299.24, ["Neon|Ride"] = 328.12, ["Neon|Fly|Ride"] = 511.87, ["Mega|Fly|Ride"] = 1672.98}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.49, ["Ride"] = 29.22, ["Fly|Ride"] = 136.57, ["Neon"] = 24.94, ["Neon|Ride"] = 113.46, ["Neon|Fly|Ride"] = 186.25, ["Mega"] = 164.07, ["Mega|Ride"] = 213.42, ["Mega|Fly|Ride"] = 421.45}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 10.99, ["Fly"] = 56.44, ["Ride"] = 31.84, ["Fly|Ride"] = 100.16, ["Neon"] = 65.63, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 191.58, ["Mega|Ride"] = 638.55, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 431.82, ["Fly"] = 532.13, ["Ride"] = 393.75, ["Fly|Ride"] = 541.66, ["Neon|Fly|Ride"] = 5676.6, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 39.62, ["Fly"] = 106.44, ["Ride"] = 57.65, ["Fly|Ride"] = 97.12, ["Neon"] = 129.94, ["Neon|Ride"] = 215.25, ["Neon|Fly|Ride"] = 337.92, ["Mega"] = 776.43, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 717.94}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 42.6, ["Fly"] = 142.54, ["Ride"] = 70.88, ["Fly|Ride"] = 126.67, ["Neon"] = 482.65, ["Neon|Ride"] = 236.14, ["Neon|Fly|Ride"] = 322.88, ["Mega|Ride"] = 810.95, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 17.55, ["Fly"] = 114.3, ["Ride"] = 71.81, ["Fly|Ride"] = 104.99, ["Neon"] = 85.31, ["Neon|Fly"] = 137.82, ["Neon|Ride"] = 143.07, ["Neon|Fly|Ride"] = 269.07, ["Mega"] = 411.88, ["Mega|Fly"] = 525, ["Mega|Ride"] = 411.88, ["Mega|Fly|Ride"] = 588.83}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 7796.25, ["Ride"] = 8862, ["Fly|Ride"] = 8347.5, ["Neon|Fly|Ride"] = 14311.5, ["Mega|Fly|Ride"] = 38850}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1437.19, ["Fly"] = 1486.83, ["Ride"] = 1286.25, ["Fly|Ride"] = 1278.58, ["Neon|Fly|Ride"] = 4830, ["Mega|Fly|Ride"] = 17027.64}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 667.29, ["Ride"] = 664.83, ["Fly|Ride"] = 709.85, ["Neon"] = 2253.58, ["Neon|Fly|Ride"] = 1443.75, ["Mega"] = 21284.54, ["Mega|Fly|Ride"] = 9585.51}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 11.24, ["Fly"] = 23.46, ["Ride"] = 18.37, ["Fly|Ride"] = 38.07, ["Neon"] = 63.88, ["Neon|Ride"] = 90.57, ["Neon|Fly|Ride"] = 125.81, ["Mega|Fly|Ride"] = 572.25}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 5.16, ["Fly"] = 78.74, ["Ride"] = 32.59, ["Fly|Ride"] = 182, ["Neon"] = 25.46, ["Neon|Ride"] = 55.55, ["Mega"] = 158.82, ["Mega|Ride"] = 200.82, ["Mega|Fly|Ride"] = 286.13}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 32.64, ["Fly"] = 46.2, ["Ride"] = 41.78, ["Fly|Ride"] = 94.28, ["Neon"] = 542.97, ["Neon|Ride"] = 150.94, ["Neon|Fly|Ride"] = 181.12, ["Mega|Ride"] = 709.85, ["Mega|Fly|Ride"] = 666.75}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 2.41, ["Fly"] = 16.87, ["Ride"] = 16.34, ["Fly|Ride"] = 37.49, ["Neon"] = 22.32, ["Neon|Fly"] = 86.63, ["Neon|Ride"] = 44.82, ["Neon|Fly|Ride"] = 97.13, ["Mega"] = 393.75, ["Mega|Ride"] = 560.42, ["Mega|Fly|Ride"] = 356.02}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 315, ["Fly"] = 369.5, ["Ride"] = 276.94, ["Fly|Ride"] = 328.13, ["Neon"] = 1277.09, ["Neon|Ride"] = 1332.42, ["Neon|Fly|Ride"] = 1279.69, ["Mega|Fly|Ride"] = 4436.25}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 22.75, ["Fly"] = 60.35, ["Ride"] = 32.71, ["Fly|Ride"] = 78.75, ["Neon"] = 126, ["Neon|Fly"] = 425.71, ["Neon|Ride"] = 141.7, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 851.4, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 721.77}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 5.85, ["Fly"] = 21, ["Ride"] = 19.48, ["Fly|Ride"] = 33.77, ["Neon"] = 83.03, ["Neon|Fly"] = 120.27, ["Neon|Ride"] = 76.63, ["Neon|Fly|Ride"] = 104.2, ["Mega"] = 1575, ["Mega|Ride"] = 608.24, ["Mega|Fly|Ride"] = 423.94}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 497, ["Ride"] = 590.63, ["Fly|Ride"] = 637.81, ["Neon|Fly|Ride"] = 3549.21, ["Mega|Fly|Ride"] = 9971.07}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1115.52, ["Ride"] = 1164.28, ["Fly|Ride"] = 1316.41, ["Neon"] = 4966.76, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 12487.64}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 100.05, ["Fly"] = 187.69, ["Ride"] = 106.36, ["Fly|Ride"] = 77.43, ["Neon"] = 497, ["Neon|Ride"] = 585.35, ["Neon|Fly|Ride"] = 480.64, ["Mega|Fly|Ride"] = 2694.64}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 150.94, ["Fly"] = 242.74, ["Ride"] = 201.48, ["Fly|Ride"] = 250.59, ["Neon"] = 611.09, ["Neon|Ride"] = 541.24, ["Neon|Fly|Ride"] = 683.44, ["Mega|Ride"] = 9187.5, ["Mega|Fly|Ride"] = 2929.5}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 23.7, ["Fly"] = 57.48, ["Ride"] = 34.35, ["Fly|Ride"] = 113.8, ["Neon"] = 236.24, ["Neon|Ride"] = 238.13, ["Mega|Ride"] = 1419.69, ["Mega|Fly|Ride"] = 1077.01}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 196.88, ["Ride"] = 315, ["Fly|Ride"] = 411.88, ["Neon"] = 1220.63, ["Neon|Fly|Ride"] = 1277.09, ["Mega"] = 5676.6, ["Mega|Fly|Ride"] = 5676.6}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2413.31, ["Ride"] = 1769.15, ["Fly|Ride"] = 1837.49, ["Neon|Fly|Ride"] = 10642.28, ["Mega|Fly|Ride"] = 35401.59}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 43.32, ["Fly"] = 212.86, ["Ride"] = 51.18, ["Fly|Ride"] = 157.5, ["Neon"] = 288.75, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 268.2, ["Mega"] = 1419.69, ["Mega|Ride"] = 1135.54, ["Mega|Fly|Ride"] = 1249.49}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 569.63, ["Fly"] = 851.4, ["Ride"] = 590.63, ["Fly|Ride"] = 624.65, ["Neon|Ride"] = 1498.88, ["Neon|Fly|Ride"] = 1194.31, ["Mega|Fly|Ride"] = 3451.86}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 36.9, ["Fly"] = 70.88, ["Ride"] = 62.79, ["Fly|Ride"] = 68.25, ["Neon"] = 262.5, ["Neon|Ride"] = 236.55, ["Neon|Fly|Ride"] = 244.39, ["Mega|Fly|Ride"] = 1008.9}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 2.87, ["Fly"] = 34.5, ["Ride"] = 15.75, ["Fly|Ride"] = 59.36, ["Neon"] = 37.66, ["Neon|Fly"] = 120.75, ["Neon|Ride"] = 47.97, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 170.62, ["Mega|Fly"] = 249.38, ["Mega|Ride"] = 185.2, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 57.47, ["Ride"] = 128.35, ["Fly|Ride"] = 157.5, ["Neon"] = 262.4, ["Neon|Ride"] = 482.73, ["Neon|Fly|Ride"] = 709.85, ["Mega"] = 1555.91, ["Mega|Ride"] = 1702.78}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 851.61, ["Fly"] = 1093.24, ["Ride"] = 851.82, ["Fly|Ride"] = 918.23, ["Neon|Ride"] = 3255, ["Neon|Fly|Ride"] = 2756.25, ["Mega|Fly|Ride"] = 12468.75}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 650.99, ["Ride"] = 579.17, ["Fly|Ride"] = 709.85, ["Neon|Fly|Ride"] = 4255.85, ["Mega|Fly|Ride"] = 15465.36}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 7.88, ["Fly"] = 19.69, ["Ride"] = 22.31, ["Fly|Ride"] = 45.21, ["Neon"] = 142.63, ["Neon|Ride"] = 82.36, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 781.15, ["Mega|Ride"] = 568.31, ["Mega|Fly|Ride"] = 722.52}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 11.46, ["Ride"] = 27.57, ["Fly|Ride"] = 92.6, ["Neon"] = 89.02, ["Neon|Ride"] = 93.32, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 994, ["Mega|Ride"] = 708.79, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 3.72, ["Ride"] = 32.71, ["Fly|Ride"] = 113.7, ["Neon"] = 20.9, ["Neon|Fly"] = 319.81, ["Neon|Ride"] = 67.06, ["Neon|Fly|Ride"] = 223.51, ["Mega"] = 162.1, ["Mega|Fly"] = 268.2, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 355.46}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 38.29, ["Fly"] = 49.93, ["Ride"] = 49.26, ["Fly|Ride"] = 78.75, ["Neon"] = 305.45, ["Neon|Ride"] = 220.5, ["Neon|Fly|Ride"] = 216.2, ["Mega|Ride"] = 950.98, ["Mega|Fly|Ride"] = 984.9}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 71.31, ["Ride"] = 131.25, ["Fly|Ride"] = 355.46, ["Neon"] = 437.07, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 2271.07, ["Mega|Ride"] = 2172.27, ["Mega|Fly|Ride"] = 2128.47}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 12.79, ["Fly"] = 50.68, ["Ride"] = 35.43, ["Fly|Ride"] = 78.64, ["Neon"] = 67.57, ["Neon|Fly"] = 240.42, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 167.82, ["Mega"] = 476.79, ["Mega|Ride"] = 362.25, ["Mega|Fly|Ride"] = 469.34}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 32.01, ["Fly"] = 59.07, ["Ride"] = 31.5, ["Fly|Ride"] = 93.07, ["Neon"] = 262.5, ["Neon|Ride"] = 166.64, ["Neon|Fly|Ride"] = 234.92, ["Mega"] = 2100, ["Mega|Fly|Ride"] = 1241.59}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 2.82, ["Fly"] = 27.2, ["Ride"] = 17.42, ["Fly|Ride"] = 36.2, ["Neon"] = 23.63, ["Neon|Ride"] = 50.04, ["Neon|Fly|Ride"] = 111.46, ["Mega"] = 434.74, ["Mega|Ride"] = 482.73, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 4.9, ["Fly"] = 49.87, ["Ride"] = 41.91, ["Fly|Ride"] = 70.88, ["Neon"] = 38.98, ["Neon|Fly"] = 114.19, ["Neon|Ride"] = 81.89, ["Neon|Fly|Ride"] = 127.73, ["Mega"] = 416.07, ["Mega|Ride"] = 355.46, ["Mega|Fly|Ride"] = 469.34}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 45.85, ["Fly"] = 56.8, ["Ride"] = 33.01, ["Fly|Ride"] = 96.06, ["Neon"] = 233.63, ["Neon|Fly"] = 211.3, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 241.4, ["Mega|Fly|Ride"] = 1074.91}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1403.07, ["Fly"] = 1410.93, ["Ride"] = 1351.88, ["Fly|Ride"] = 1365, ["Neon|Ride"] = 4894.39, ["Neon|Fly|Ride"] = 3412.5, ["Mega|Fly|Ride"] = 12468.75}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 462, ["Fly"] = 524.99, ["Ride"] = 446.25, ["Fly|Ride"] = 478.96, ["Neon|Ride"] = 3051.16, ["Neon|Fly|Ride"] = 2362.5, ["Mega"] = 14899.18, ["Mega|Fly|Ride"] = 8930.37}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 261.19, ["Fly"] = 378.23, ["Ride"] = 326.73, ["Fly|Ride"] = 347.82, ["Neon"] = 1277.09, ["Neon|Ride"] = 1489.93, ["Neon|Fly|Ride"] = 1553.78}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 35.22}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 28.77, ["Ride"] = 42, ["Fly|Ride"] = 98.44, ["Neon"] = 325.5, ["Neon|Fly"] = 425.71, ["Neon|Ride"] = 207.55, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 1702.78, ["Mega|Fly|Ride"] = 1036.54}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 70875, ["Fly"] = 23413, ["Ride"] = 36197.15, ["Fly|Ride"] = 17569.56, ["Neon|Fly|Ride"] = 38062.5, ["Mega"] = 212845.31, ["Mega|Fly|Ride"] = 88499.73}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 223.02, ["Fly"] = 262.5, ["Ride"] = 223.13, ["Fly|Ride"] = 291.38, ["Neon"] = 656.25, ["Neon|Fly"] = 853.13, ["Neon|Ride"] = 937.6, ["Neon|Fly|Ride"] = 797.7, ["Mega"] = 6385.38, ["Mega|Ride"] = 4255.85, ["Mega|Fly|Ride"] = 3539.17}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 216.46, ["Fly"] = 525, ["Ride"] = 249.38, ["Fly|Ride"] = 257.27, ["Neon|Fly|Ride"] = 1770.4}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 128.16, ["Fly"] = 144.38, ["Ride"] = 131.25, ["Fly|Ride"] = 210, ["Neon"] = 511.94, ["Neon|Ride"] = 524.99, ["Neon|Fly|Ride"] = 616.88, ["Mega|Fly|Ride"] = 3122.46}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 13.12, ["Fly"] = 65.63, ["Ride"] = 30.19, ["Fly|Ride"] = 91.88, ["Neon"] = 85.68, ["Neon|Ride"] = 113.89, ["Neon|Fly|Ride"] = 236.27, ["Mega"] = 721.68, ["Mega|Ride"] = 709.85, ["Mega|Fly|Ride"] = 947.17}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 5085.94, ["Ride"] = 3937.5, ["Fly|Ride"] = 4041.19, ["Neon"] = 21284.54, ["Neon|Fly|Ride"] = 15750}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 27.44, ["Fly"] = 42, ["Ride"] = 28.84, ["Fly|Ride"] = 51.97, ["Neon"] = 131.25, ["Neon|Ride"] = 150.59, ["Neon|Fly|Ride"] = 146.9, ["Mega|Ride"] = 1419.69, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 47.25, ["Ride"] = 39.29, ["Fly|Ride"] = 100.05, ["Neon"] = 311.32, ["Neon|Fly"] = 1419.69, ["Neon|Ride"] = 202.79, ["Neon|Fly|Ride"] = 262.48, ["Mega|Fly|Ride"] = 1373.93}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 393.75, ["Fly"] = 539.58, ["Ride"] = 459.38, ["Fly|Ride"] = 551.25, ["Neon"] = 1311.19, ["Neon|Fly"] = 1561.24, ["Neon|Ride"] = 1181.12, ["Neon|Fly|Ride"] = 1207.9, ["Mega|Ride"] = 5321.15, ["Mega|Fly|Ride"] = 5309.96}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 13.13, ["Fly"] = 15.75, ["Ride"] = 23.72, ["Fly|Ride"] = 38.11, ["Neon"] = 123.38, ["Neon|Fly"] = 160.72, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 131.25, ["Mega|Ride"] = 781.15, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 8.99, ["Ride"] = 34.53, ["Fly|Ride"] = 80.16, ["Neon"] = 98.43, ["Neon|Ride"] = 74.11, ["Neon|Fly|Ride"] = 209.08, ["Mega"] = 532.22, ["Mega|Ride"] = 572.03, ["Mega|Fly|Ride"] = 526.81}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 104.99, ["Ride"] = 103.68, ["Fly|Ride"] = 233.08, ["Neon"] = 1010.63, ["Neon|Ride"] = 637.79, ["Neon|Fly|Ride"] = 688.57, ["Mega|Fly|Ride"] = 2735.84}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 14.33, ["Fly"] = 98.42, ["Ride"] = 51.97, ["Fly|Ride"] = 308.34, ["Neon"] = 50.58, ["Neon|Ride"] = 117.57, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 212.86, ["Mega|Fly"] = 423.94, ["Mega|Ride"] = 305.17, ["Mega|Fly|Ride"] = 446.24}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3937.4, ["Ride"] = 4034.63, ["Fly|Ride"] = 4029.38, ["Neon"] = 19687.5, ["Neon|Ride"] = 12337.5, ["Neon|Fly|Ride"] = 10171.88, ["Mega"] = 42569.07, ["Mega|Fly|Ride"] = 37945.69}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 39.38, ["Fly"] = 140.49, ["Ride"] = 70.22, ["Fly|Ride"] = 144.38, ["Neon"] = 164.07, ["Neon|Ride"] = 244.13, ["Neon|Fly|Ride"] = 398.26, ["Mega"] = 851.4, ["Mega|Ride"] = 1770.4, ["Mega|Fly|Ride"] = 782.24}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 7520.9, ["Fly"] = 7556.03, ["Ride"] = 6857.82, ["Fly|Ride"] = 5844.57, ["Neon|Fly|Ride"] = 14437.5, ["Mega|Fly|Ride"] = 46921.88}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.41, ["Fly"] = 16.96, ["Ride"] = 14.44, ["Fly|Ride"] = 33.01, ["Neon"] = 24.67, ["Neon|Fly"] = 59.61, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 233.08, ["Mega|Ride"] = 372.75, ["Mega|Fly|Ride"] = 248.07}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 20.06, ["Fly"] = 26.25, ["Ride"] = 32.47, ["Fly|Ride"] = 57.48, ["Neon"] = 185.19, ["Neon|Fly"] = 235.2, ["Neon|Ride"] = 197.93, ["Neon|Fly|Ride"] = 168, ["Mega|Ride"] = 991.6, ["Mega|Fly|Ride"] = 965.46}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.81}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 11.71, ["Ride"] = 26.56, ["Fly|Ride"] = 116.03, ["Neon"] = 284.16, ["Neon|Ride"] = 105.71, ["Neon|Fly|Ride"] = 322.23, ["Mega"] = 1049.9, ["Mega|Ride"] = 994, ["Mega|Fly|Ride"] = 787.54}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 21.73, ["Fly"] = 190.37, ["Ride"] = 39.38, ["Fly|Ride"] = 93.83, ["Neon"] = 203.44, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 945, ["Mega|Ride"] = 851.4, ["Mega|Fly|Ride"] = 1099.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 12.34, ["Fly"] = 27.36, ["Ride"] = 19.59, ["Fly|Ride"] = 39.38, ["Neon|Fly"] = 1061.05, ["Neon|Ride"] = 118.14, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 2554.16, ["Mega|Fly|Ride"] = 553.42}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8656.44}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2624.99}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 19.09}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 242.82, ["Ride"] = 317.16, ["Fly|Ride"] = 315, ["Mega|Fly|Ride"] = 4200}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 12.13, ["Fly"] = 135.18, ["Ride"] = 35.44, ["Fly|Ride"] = 140.49, ["Neon"] = 113.43, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 142.63, ["Mega"] = 525, ["Mega|Ride"] = 532.22, ["Mega|Fly|Ride"] = 492.76}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 9.92}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 5.97, ["Ride"] = 25.99, ["Fly|Ride"] = 85.15, ["Neon|Ride"] = 249.38, ["Mega"] = 1561.24}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2239.13}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 93.24, ["Fly"] = 338.44, ["Ride"] = 131.25, ["Fly|Ride"] = 425.71, ["Neon"] = 945, ["Neon|Ride"] = 893.05, ["Neon|Fly|Ride"] = 1561.24, ["Mega|Ride"] = 4115.37, ["Mega|Fly|Ride"] = 3936.45}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 52.5, ["Ride"] = 93.18, ["Fly|Ride"] = 241.33, ["Neon"] = 329.44, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 532.13, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 157.46, ["Fly"] = 196.88, ["Ride"] = 157.49, ["Fly|Ride"] = 212.86, ["Neon"] = 944.98, ["Neon|Ride"] = 787.49, ["Neon|Fly|Ride"] = 840, ["Mega|Ride"] = 3264, ["Mega|Fly|Ride"] = 3255.08}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 2388.75, ["Fly"] = 3264, ["Ride"] = 2428.13, ["Fly|Ride"] = 2562.87, ["Neon"] = 14948.13, ["Neon|Ride"] = 9654.44, ["Neon|Fly|Ride"] = 7612.5, ["Mega|Fly|Ride"] = 26961.13}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 15.73, ["Fly"] = 105.37, ["Ride"] = 37.09, ["Fly|Ride"] = 100.09, ["Neon"] = 120.67, ["Neon|Fly"] = 161.69, ["Neon|Ride"] = 154.48, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 956.76, ["Mega|Ride"] = 994, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 744.98, ["Fly"] = 2100, ["Ride"] = 994, ["Fly|Ride"] = 787.5, ["Neon|Fly|Ride"] = 4183.99}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 42}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 15.64, ["Ride"] = 45.69, ["Fly|Ride"] = 340.27, ["Neon"] = 94.5, ["Neon|Ride"] = 106.44, ["Neon|Fly|Ride"] = 255.43, ["Mega"] = 473.34, ["Mega|Fly"] = 965.46, ["Mega|Ride"] = 509.25, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 5.79, ["Fly"] = 32.6, ["Ride"] = 27.57, ["Fly|Ride"] = 76.13, ["Neon"] = 47.25, ["Neon|Fly"] = 315, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 178.5, ["Mega"] = 451.36, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 568.31}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 60.22}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 15.74, ["Fly"] = 106.75, ["Ride"] = 20.56, ["Fly|Ride"] = 78.74, ["Neon|Ride"] = 193.1, ["Neon|Fly|Ride"] = 254.62, ["Mega|Ride"] = 994, ["Mega|Fly|Ride"] = 2128.47}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 38.25, ["Fly"] = 39.38, ["Ride"] = 28.88, ["Fly|Ride"] = 52.41, ["Neon|Fly"] = 235.2, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 1448.18, ["Mega|Ride"] = 1810.23, ["Mega|Fly|Ride"] = 989.63}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6449.23, ["Fly"] = 10237.5, ["Ride"] = 6435.86, ["Fly|Ride"] = 5118.74, ["Neon|Fly|Ride"] = 9843.75, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 7.35, ["Fly"] = 85.15, ["Ride"] = 26.17, ["Fly|Ride"] = 81.37, ["Neon"] = 55.88, ["Neon|Ride"] = 71.75, ["Neon|Fly|Ride"] = 199.03, ["Mega"] = 510.84, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 535.5}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 19.36}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 80.47, ["Fly"] = 376.74, ["Ride"] = 131.15, ["Fly|Ride"] = 183.75, ["Neon"] = 531.57, ["Neon|Ride"] = 451.01, ["Neon|Fly|Ride"] = 481.42, ["Mega"] = 2879.59, ["Mega|Ride"] = 1764.77, ["Mega|Fly|Ride"] = 2169.98}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 46.92, ["Fly"] = 142.63, ["Ride"] = 64.32, ["Fly|Ride"] = 131.25, ["Neon"] = 291.38, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 446.25, ["Mega"] = 2413.62, ["Mega|Ride"] = 2873.42, ["Mega|Fly|Ride"] = 1029}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 19.47, ["Fly"] = 71.32, ["Ride"] = 21, ["Fly|Ride"] = 65.35, ["Neon"] = 128.77, ["Neon|Fly"] = 229.89, ["Neon|Ride"] = 143.63, ["Neon|Fly|Ride"] = 199.03, ["Mega"] = 1016.21, ["Mega|Ride"] = 868.91, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 5.19, ["Fly"] = 68.95, ["Ride"] = 21, ["Fly|Ride"] = 63.88, ["Neon"] = 31.47, ["Neon|Ride"] = 41.14, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 162.75, ["Mega|Fly"] = 284.12, ["Mega|Ride"] = 199.38, ["Mega|Fly|Ride"] = 309.45}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 9.08, ["Fly"] = 48.98, ["Ride"] = 28.58, ["Fly|Ride"] = 98.05, ["Neon"] = 97.93, ["Neon|Ride"] = 99.75, ["Neon|Fly|Ride"] = 235.2, ["Mega|Ride"] = 476.79, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 20.68, ["Fly"] = 26.25, ["Ride"] = 25.35, ["Fly|Ride"] = 42, ["Neon|Fly"] = 144.38, ["Neon|Ride"] = 128.62, ["Neon|Fly|Ride"] = 124.69, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 197.5}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 25.56, ["Ride"] = 131.24, ["Fly|Ride"] = 284.16, ["Neon"] = 183.74, ["Neon|Ride"] = 255.43, ["Neon|Fly|Ride"] = 356.02, ["Mega"] = 709.85, ["Mega|Fly|Ride"] = 678.57}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 218.97, ["Ride"] = 1419.69, ["Neon|Ride"] = 17027.64, ["Neon|Fly|Ride"] = 28379.75}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 49.88, ["Fly"] = 211.1, ["Ride"] = 86.63, ["Fly|Ride"] = 170.63, ["Neon"] = 269.07, ["Neon|Ride"] = 342.25, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 851.4, ["Mega|Ride"] = 922.69, ["Mega|Fly|Ride"] = 1088.72}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 1154.9, ["Fly"] = 1377.13, ["Ride"] = 1022.42, ["Fly|Ride"] = 1019.82, ["Neon|Fly"] = 4376.26, ["Neon|Ride"] = 3902.53, ["Neon|Fly|Ride"] = 3281.25, ["Mega"] = 16091.53, ["Mega|Fly|Ride"] = 12337.5}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 346.5, ["Fly"] = 644.37, ["Ride"] = 380.63, ["Fly|Ride"] = 433.02, ["Neon"] = 2362.5, ["Neon|Ride"] = 1909.69, ["Neon|Fly|Ride"] = 1994.99, ["Mega"] = 12229.76, ["Mega|Fly|Ride"] = 9186.19}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 55.12}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.96}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 10.16, ["Fly"] = 26.17, ["Ride"] = 20.99, ["Fly|Ride"] = 42, ["Neon"] = 78.75, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 51.02, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 560.86, ["Mega|Ride"] = 709.85, ["Mega|Fly|Ride"] = 551.29}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 236.77, ["Fly"] = 406.65, ["Ride"] = 279.57, ["Fly|Ride"] = 315, ["Neon"] = 1169.61, ["Neon|Ride"] = 916.27, ["Neon|Fly|Ride"] = 822.06, ["Mega|Fly|Ride"] = 2768.8}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 13.33}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 93.59, ["Ride"] = 172.24, ["Fly|Ride"] = 236.25, ["Neon"] = 565.11, ["Neon|Fly"] = 610.32, ["Neon|Ride"] = 411.65, ["Neon|Fly|Ride"] = 656.23, ["Mega"] = 2231.43, ["Mega|Ride"] = 1968.75, ["Mega|Fly|Ride"] = 1985.29}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 129.83, ["Fly"] = 212.86, ["Ride"] = 131.06, ["Fly|Ride"] = 143.89, ["Neon"] = 1135.54, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 851.4, ["Mega|Fly|Ride"] = 2554.16}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 4.87, ["Ride"] = 23.63, ["Fly|Ride"] = 52.5, ["Neon"] = 31.95, ["Neon|Ride"] = 71.32, ["Neon|Fly|Ride"] = 250.1, ["Mega"] = 355.46, ["Mega|Ride"] = 189.84, ["Mega|Fly|Ride"] = 241.38}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 12.92, ["Fly"] = 71.32, ["Ride"] = 27.14, ["Fly|Ride"] = 78.65, ["Neon"] = 175.88, ["Neon|Ride"] = 157.49, ["Neon|Fly|Ride"] = 322.23, ["Mega|Ride"] = 1419.69, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 9.86, ["Fly"] = 102.36, ["Ride"] = 30.19, ["Fly|Ride"] = 104.9, ["Neon"] = 95.82, ["Neon|Ride"] = 85.15, ["Neon|Fly|Ride"] = 259.68, ["Mega"] = 423.57, ["Mega|Ride"] = 519.75, ["Mega|Fly|Ride"] = 553.42}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 4.57, ["Fly"] = 98.44, ["Ride"] = 31.75, ["Fly|Ride"] = 137.62, ["Neon"] = 24.82, ["Neon|Ride"] = 65.41, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 144.37, ["Mega|Fly"] = 241.38, ["Mega|Ride"] = 175.88, ["Mega|Fly|Ride"] = 274.31}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 242.81, ["Ride"] = 290.05, ["Fly|Ride"] = 378.88, ["Neon"] = 1332.42, ["Neon|Ride"] = 1375.78, ["Neon|Fly|Ride"] = 1424.07, ["Mega|Fly|Ride"] = 5655.32}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 78.75, ["Ride"] = 131.25, ["Fly|Ride"] = 242.82, ["Neon"] = 429.19, ["Neon|Ride"] = 485.63, ["Neon|Fly|Ride"] = 630, ["Mega"] = 1843.26, ["Mega|Ride"] = 1903.13, ["Mega|Fly|Ride"] = 1903.13}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 47.25, ["Fly"] = 75.57, ["Ride"] = 70.88, ["Fly|Ride"] = 118.13, ["Neon"] = 262.5, ["Neon|Ride"] = 293.4, ["Neon|Fly|Ride"] = 416.07, ["Mega|Ride"] = 1770.4, ["Mega|Fly|Ride"] = 1798.56}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 11.82, ["Fly"] = 126, ["Ride"] = 36.2, ["Fly|Ride"] = 284.16, ["Neon"] = 131.25, ["Neon|Ride"] = 613.07, ["Neon|Fly|Ride"] = 497, ["Mega"] = 656.25, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 13.75, ["Fly"] = 75.63, ["Ride"] = 27.57, ["Fly|Ride"] = 85.15, ["Neon"] = 77.44, ["Neon|Ride"] = 121.34, ["Neon|Fly|Ride"] = 157.49, ["Mega"] = 709.85, ["Mega|Fly"] = 525, ["Mega|Ride"] = 421.45, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.29, ["Fly"] = 52.5, ["Ride"] = 20.89, ["Fly|Ride"] = 57.48, ["Neon"] = 20.79, ["Neon|Fly"] = 48.27, ["Neon|Ride"] = 36.92, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 164.06, ["Mega|Fly"] = 212.86, ["Mega|Ride"] = 170.39, ["Mega|Fly|Ride"] = 257.66}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 829.5, ["Fly"] = 1082.73, ["Ride"] = 846.45, ["Fly|Ride"] = 905.63, ["Neon"] = 4256.91, ["Neon|Fly"] = 3275.86, ["Neon|Ride"] = 3218.57, ["Neon|Fly|Ride"] = 2624.99, ["Mega|Fly|Ride"] = 8098.23}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 318.22, ["Fly"] = 738.59, ["Ride"] = 294, ["Fly|Ride"] = 482.65, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1273.13, ["Mega"] = 10642.28, ["Mega|Fly|Ride"] = 8513.82}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 91.86, ["Fly"] = 134.1, ["Ride"] = 112.82, ["Fly|Ride"] = 174.92, ["Neon"] = 406.88, ["Neon|Fly"] = 482.65, ["Neon|Ride"] = 332.96, ["Neon|Fly|Ride"] = 424.64, ["Mega"] = 1312.5, ["Mega|Ride"] = 1632.53, ["Mega|Fly|Ride"] = 1671.91}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 178.5, ["Fly"] = 283.5, ["Ride"] = 183.87, ["Fly|Ride"] = 237.36, ["Neon|Ride"] = 1287.67, ["Neon|Fly|Ride"] = 917.44, ["Mega"] = 10642.28, ["Mega|Fly|Ride"] = 4512.34}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 22.23, ["Fly"] = 41.52, ["Ride"] = 23.49, ["Fly|Ride"] = 76.13, ["Neon"] = 142.63, ["Neon|Ride"] = 148.44, ["Neon|Fly|Ride"] = 204.75, ["Mega|Ride"] = 638.54, ["Mega|Fly|Ride"] = 851.4}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 168, ["Ride"] = 222.01, ["Fly|Ride"] = 358.32, ["Neon"] = 853.64, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 971.25, ["Mega"] = 4198.69, ["Mega|Fly|Ride"] = 3817.4}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 77.42, ["Fly"] = 125.98, ["Ride"] = 80.05, ["Fly|Ride"] = 106.44, ["Neon|Ride"] = 568.31, ["Neon|Fly|Ride"] = 497, ["Mega|Fly|Ride"] = 1417.5}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 2310, ["Ride"] = 2256.19, ["Fly|Ride"] = 2231.25, ["Neon|Ride"] = 8513.82, ["Neon|Fly|Ride"] = 6356.25, ["Mega"] = 51082.88, ["Mega|Fly|Ride"] = 25556.35}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 10.87, ["Fly"] = 78.04, ["Ride"] = 40.43, ["Fly|Ride"] = 85.15, ["Neon"] = 59.61, ["Neon|Fly"] = 235.2, ["Neon|Ride"] = 99.75, ["Neon|Fly|Ride"] = 237.3, ["Mega"] = 288.73, ["Mega|Fly"] = 568.31, ["Mega|Ride"] = 317.06, ["Mega|Fly|Ride"] = 392.44}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 48.2, ["Fly"] = 93.66, ["Ride"] = 81.68, ["Fly|Ride"] = 113.89, ["Neon"] = 223.13, ["Neon|Ride"] = 425.71, ["Neon|Fly|Ride"] = 478.92, ["Mega|Ride"] = 931.88, ["Mega|Fly|Ride"] = 1064.24}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 79.68, ["Fly"] = 91.87, ["Ride"] = 52.5, ["Fly|Ride"] = 104.9, ["Neon"] = 525, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 1879.83}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 3700.82, ["Fly"] = 1609.7, ["Ride"] = 1069.69, ["Fly|Ride"] = 1112.27, ["Neon|Ride"] = 5149.45, ["Neon|Fly|Ride"] = 4725, ["Mega"] = 34765.11, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 525, ["Fly"] = 563.53, ["Ride"] = 567.1, ["Fly|Ride"] = 534.19, ["Mega|Fly|Ride"] = 11352.11}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 62.74, ["Fly"] = 322.2, ["Ride"] = 104.31, ["Fly|Ride"] = 208.69, ["Neon"] = 444.05, ["Neon|Ride"] = 342.43, ["Neon|Fly|Ride"] = 555.09, ["Mega"] = 1987.99, ["Mega|Ride"] = 2575.33, ["Mega|Fly|Ride"] = 1563.33}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 5.29, ["Fly"] = 41.04, ["Ride"] = 22.32, ["Fly|Ride"] = 65.63, ["Neon"] = 44.62, ["Neon|Ride"] = 72.08, ["Neon|Fly|Ride"] = 130.57, ["Mega"] = 553.88, ["Mega|Ride"] = 770.52}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 32.81, ["Fly"] = 68.25, ["Ride"] = 42, ["Fly|Ride"] = 123.46, ["Neon"] = 284.82, ["Neon|Fly"] = 355.46, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 334.69, ["Mega|Ride"] = 1187.82, ["Mega|Fly|Ride"] = 1049.99}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 708.63, ["Fly"] = 1110.14, ["Ride"] = 786.18, ["Fly|Ride"] = 853.13, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2508.42, ["Mega|Fly|Ride"] = 9723}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 591.3}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 6168.75, ["Ride"] = 5024.79, ["Fly|Ride"] = 5512.5, ["Neon"] = 42000, ["Neon|Ride"] = 30501.81, ["Neon|Fly|Ride"] = 18375, ["Mega|Fly|Ride"] = 106281.13}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 223.13, ["Fly"] = 399.1, ["Ride"] = 341.25, ["Fly|Ride"] = 419.91, ["Neon"] = 1312.5, ["Neon|Ride"] = 1845.38, ["Neon|Fly|Ride"] = 1706.25, ["Mega"] = 6384.32, ["Mega|Ride"] = 6100.17, ["Mega|Fly|Ride"] = 6102.29}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 62.34, ["Fly"] = 284.16, ["Ride"] = 131.14, ["Fly|Ride"] = 336, ["Neon"] = 424.64, ["Neon|Ride"] = 851.4, ["Neon|Fly|Ride"] = 634.3, ["Mega|Fly|Ride"] = 2128.47}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 14.78, ["Fly"] = 96.87, ["Ride"] = 28.54, ["Fly|Ride"] = 85.22, ["Neon"] = 156.92, ["Neon|Fly"] = 1287.42, ["Neon|Ride"] = 126, ["Neon|Fly|Ride"] = 214.68, ["Mega|Ride"] = 620.46, ["Mega|Fly|Ride"] = 836.5}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 10.65, ["Fly"] = 26.24, ["Ride"] = 22.17, ["Fly|Ride"] = 54.29, ["Neon"] = 127.73, ["Neon|Ride"] = 71.32, ["Neon|Fly|Ride"] = 111.22, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 2128.47}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 14.18, ["Fly"] = 284.16, ["Ride"] = 30.43, ["Fly|Ride"] = 89.92, ["Neon"] = 124.67, ["Neon|Ride"] = 113.18, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 645.75, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 644.45}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 3.61, ["Fly"] = 62.79, ["Ride"] = 19.69, ["Fly|Ride"] = 48.55, ["Neon"] = 31.38, ["Neon|Ride"] = 56.74, ["Neon|Fly|Ride"] = 125.58, ["Mega"] = 695.67, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 322.23}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 26.27, ["Fly"] = 90.57, ["Ride"] = 45.92, ["Fly|Ride"] = 139.13, ["Neon"] = 156.58, ["Neon|Fly"] = 851.4, ["Neon|Ride"] = 229.89, ["Neon|Fly|Ride"] = 451.5, ["Mega"] = 630, ["Mega|Ride"] = 781.15}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 485.52, ["Fly"] = 538.13, ["Ride"] = 485.63, ["Fly|Ride"] = 492.19, ["Neon"] = 1915.62, ["Neon|Ride"] = 1874.12, ["Neon|Fly|Ride"] = 1501.15, ["Mega"] = 7875, ["Mega|Fly|Ride"] = 5805.37}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 3.34, ["Fly"] = 21.3, ["Ride"] = 14.44, ["Fly|Ride"] = 33.01, ["Neon"] = 26.56, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 63.88, ["Mega"] = 170.63, ["Mega|Ride"] = 225.63, ["Mega|Fly|Ride"] = 213.92}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 45.7, ["Fly"] = 110.24, ["Ride"] = 70.79, ["Fly|Ride"] = 124.69, ["Neon"] = 196.67, ["Neon|Fly"] = 333.15, ["Neon|Ride"] = 207.38, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 524.79, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 603.65}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 730.79, ["Ride"] = 748.13, ["Fly|Ride"] = 791.44, ["Neon|Ride"] = 1988.23, ["Neon|Fly|Ride"] = 1640.62, ["Mega|Fly|Ride"] = 4199.99}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 20.9, ["Fly"] = 71.32, ["Ride"] = 44.51, ["Fly|Ride"] = 78.74, ["Neon"] = 262.49, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 163.95, ["Neon|Fly|Ride"] = 249.35, ["Mega"] = 1206.82, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 236.25, ["Fly"] = 288.75, ["Ride"] = 254.63, ["Fly|Ride"] = 328.02, ["Neon|Fly|Ride"] = 1771.88, ["Mega|Fly|Ride"] = 6437.1}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 196.88, ["Fly"] = 278.84, ["Ride"] = 170.63, ["Fly|Ride"] = 236.24, ["Neon"] = 994, ["Neon|Ride"] = 892.5, ["Neon|Fly|Ride"] = 918.75, ["Mega"] = 4326, ["Mega|Fly|Ride"] = 3762.06}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 846.19, ["Ride"] = 770.44, ["Fly|Ride"] = 937.6, ["Neon"] = 2872.36, ["Neon|Ride"] = 3796.62, ["Neon|Fly|Ride"] = 3405.54, ["Mega|Fly|Ride"] = 9711.19}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 16.19, ["Fly"] = 85.15, ["Ride"] = 45.87, ["Fly|Ride"] = 111.57, ["Neon"] = 78.75, ["Neon|Fly"] = 289.59, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 127.73, ["Mega"] = 354.38, ["Mega|Ride"] = 327.78, ["Mega|Fly|Ride"] = 624.72}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 4084.49, ["Fly"] = 3438.49, ["Ride"] = 3281.25, ["Fly|Ride"] = 3346.88, ["Neon|Fly|Ride"] = 7218.75, ["Mega|Fly|Ride"] = 25753.23}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 108.94, ["Fly"] = 170.29, ["Ride"] = 131.15, ["Fly|Ride"] = 188.67, ["Neon"] = 498.75, ["Neon|Fly"] = 712.69, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 577.5, ["Mega|Ride"] = 2696.77, ["Mega|Fly|Ride"] = 2979.85}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.41, ["Fly"] = 19.59, ["Ride"] = 15.49, ["Fly|Ride"] = 39.38, ["Neon"] = 20.99, ["Neon|Fly"] = 65.61, ["Neon|Ride"] = 37.41, ["Neon|Fly|Ride"] = 101.88, ["Mega"] = 160.1, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 369.3, ["Mega|Fly|Ride"] = 233.08}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 4.19, ["Ride"] = 24.5, ["Fly|Ride"] = 57.71, ["Neon"] = 26.4, ["Neon|Fly"] = 118.29, ["Neon|Ride"] = 64.28, ["Neon|Fly|Ride"] = 284.16, ["Mega"] = 167.34, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 32.74, ["Fly"] = 42.62, ["Ride"] = 32.82, ["Fly|Ride"] = 53.51, ["Neon"] = 289.59, ["Neon|Ride"] = 313.78, ["Neon|Fly|Ride"] = 291.61, ["Mega|Fly|Ride"] = 1100.43}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 708.79, ["Fly"] = 1248.91, ["Ride"] = 1025.2, ["Fly|Ride"] = 984.38, ["Neon"] = 4541.07, ["Neon|Fly|Ride"] = 4678.36}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 6298.69, ["Ride"] = 8017.9, ["Fly|Ride"] = 6365.63}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 17.06, ["Fly"] = 39.38, ["Ride"] = 20.9, ["Fly|Ride"] = 40.51, ["Neon"] = 452.13, ["Neon|Ride"] = 126, ["Neon|Fly|Ride"] = 141.28, ["Mega"] = 2520, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 14.05, ["Fly"] = 48.98, ["Ride"] = 28.47, ["Fly|Ride"] = 68.25, ["Neon"] = 84.96, ["Neon|Ride"] = 82.2, ["Neon|Fly|Ride"] = 169.31, ["Mega"] = 662.17, ["Mega|Ride"] = 413.44, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 87.88, ["Fly"] = 157.5, ["Ride"] = 78.75, ["Fly|Ride"] = 142.93, ["Neon|Ride"] = 446.24, ["Neon|Fly|Ride"] = 496.13, ["Mega|Fly|Ride"] = 1698.58}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 220.5, ["Fly"] = 241.5, ["Ride"] = 221.8, ["Fly|Ride"] = 301.88, ["Neon"] = 965.27, ["Neon|Ride"] = 1144.06, ["Neon|Fly|Ride"] = 984.38, ["Mega"] = 8513.82, ["Mega|Fly"] = 4024.71, ["Mega|Fly|Ride"] = 4507.42}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.63, ["Ride"] = 32.71, ["Fly|Ride"] = 93.19, ["Neon"] = 23.16, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 69.57, ["Mega"] = 160.13, ["Mega|Fly"] = 237.35, ["Mega|Ride"] = 191.52, ["Mega|Fly|Ride"] = 236.24}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 181.13, ["Fly"] = 231.71, ["Ride"] = 203.44, ["Fly|Ride"] = 262.49, ["Neon"] = 709.85, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 781.34, ["Mega|Fly|Ride"] = 2576.44}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 3.19, ["Fly"] = 21.19, ["Ride"] = 15.75, ["Fly|Ride"] = 59.07, ["Neon"] = 30.64, ["Neon|Fly"] = 71.32, ["Neon|Ride"] = 36.2, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 225.75, ["Mega|Ride"] = 219.19, ["Mega|Fly|Ride"] = 284.16}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 190.32, ["Fly"] = 344.82, ["Ride"] = 207.9, ["Fly|Ride"] = 247.09, ["Neon"] = 1277.09, ["Neon|Ride"] = 1206.82, ["Neon|Fly|Ride"] = 983.15, ["Mega"] = 10642.28, ["Mega|Fly|Ride"] = 5471.66}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 8.12, ["Fly"] = 85.15, ["Ride"] = 24.5, ["Fly|Ride"] = 68.25, ["Neon"] = 73.5, ["Neon|Fly"] = 306.49, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 568.31, ["Mega|Ride"] = 526.81, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.1, ["Ride"] = 21.08, ["Fly|Ride"] = 92.6, ["Neon"] = 8.08, ["Neon|Fly"] = 170.46, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 142.63, ["Mega"] = 84, ["Mega|Ride"] = 120.84, ["Mega|Fly|Ride"] = 221.38}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.77, ["Mega"] = 18.27, ["Mega|Ride"] = 142.63, ["Mega|Fly|Ride"] = 122.4}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 2.1, ["Ride"] = 31.95, ["Fly|Ride"] = 85.52, ["Neon"] = 4.99, ["Neon|Ride"] = 27.91, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 69.23, ["Mega|Fly"] = 160907.93, ["Mega|Ride"] = 76.02, ["Mega|Fly|Ride"] = 211.3}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 57.74, ["Fly"] = 124.69, ["Ride"] = 57.75, ["Fly|Ride"] = 191.58, ["Neon"] = 337.85, ["Neon|Fly"] = 327.97, ["Neon|Ride"] = 294, ["Neon|Fly|Ride"] = 389.82, ["Mega|Fly|Ride"] = 1416.51}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 35, ["Ride"] = 16.96, ["Fly|Ride"] = 83.03, ["Neon"] = 7.49, ["Neon|Fly"] = 63.88, ["Neon|Ride"] = 19.68, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 85.39, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 262.47}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 5.07, ["Ride"] = 31.5, ["Neon"] = 82.26, ["Neon|Fly"] = 288.5, ["Neon|Ride"] = 299.25, ["Neon|Fly|Ride"] = 223.12, ["Mega"] = 261.18, ["Mega|Ride"] = 539.58}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 2.1, ["Neon|Ride"] = 55.25, ["Mega"] = 12.39, ["Mega|Fly"] = 73.5, ["Mega|Ride"] = 41.99, ["Mega|Fly|Ride"] = 160.55}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 71.28, ["Ride"] = 15.64, ["Fly|Ride"] = 24.93, ["Neon"] = 2.1, ["Neon|Fly"] = 37.08, ["Neon|Ride"] = 14.21, ["Neon|Fly|Ride"] = 32.8, ["Mega"] = 10.75, ["Mega|Fly"] = 30.71, ["Mega|Ride"] = 20.9, ["Mega|Fly|Ride"] = 57.66}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 19.68, ["Ride"] = 15.73, ["Fly|Ride"] = 52.5, ["Neon"] = 2.1, ["Neon|Fly"] = 20.99, ["Neon|Ride"] = 14.86, ["Neon|Fly|Ride"] = 42.75, ["Mega"] = 18.19, ["Mega|Fly"] = 161.73, ["Mega|Ride"] = 34.08, ["Mega|Fly|Ride"] = 62.78}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Neon"] = 2.52, ["Neon|Ride"] = 65.62, ["Mega"] = 19.18, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 91.86, ["Ride"] = 21, ["Fly|Ride"] = 107.62, ["Neon"] = 3.94, ["Neon|Fly"] = 121.34, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 82.38, ["Mega"] = 33.47, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 38.07, ["Mega|Fly|Ride"] = 101.07}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 82.08, ["Neon|Fly|Ride"] = 425.71, ["Mega"] = 20.25, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 69.57, ["Mega|Fly|Ride"] = 212.86}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 2.86, ["Fly"] = 77.43, ["Ride"] = 36.36, ["Fly|Ride"] = 156.47, ["Neon"] = 19.58, ["Neon|Fly"] = 96.54, ["Neon|Ride"] = 46.69, ["Neon|Fly|Ride"] = 104.99, ["Mega"] = 116.83, ["Mega|Fly"] = 296.93, ["Mega|Ride"] = 151.94, ["Mega|Fly|Ride"] = 262.4}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 2.1, ["Neon|Ride"] = 42.58, ["Neon|Fly|Ride"] = 322.23, ["Mega"] = 13.79, ["Mega|Fly"] = 144.27, ["Mega|Ride"] = 70.7, ["Mega|Fly|Ride"] = 196.77}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.1, ["Ride"] = 15.99, ["Fly|Ride"] = 142.63, ["Neon"] = 18.15, ["Mega"] = 135.19, ["Mega|Fly"] = 315, ["Mega|Ride"] = 274.31, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Ride"] = 28.74, ["Neon"] = 17.06, ["Mega"] = 119.79, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 568.31}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 3.83, ["Neon|Ride"] = 27.67, ["Neon|Fly|Ride"] = 142.63, ["Mega"] = 20.81, ["Mega|Ride"] = 31.5, ["Mega|Fly|Ride"] = 98.01}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.31, ["Ride"] = 14.32, ["Fly|Ride"] = 26.25, ["Neon"] = 2.1, ["Neon|Fly"] = 15.99, ["Neon|Ride"] = 14.05, ["Neon|Fly|Ride"] = 37.79, ["Mega"] = 11.08, ["Mega|Fly"] = 32.78, ["Mega|Ride"] = 13.13, ["Mega|Fly|Ride"] = 49.88}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.1, ["Fly"] = 72.19, ["Ride"] = 229.68, ["Fly|Ride"] = 118.1, ["Neon"] = 33.15, ["Neon|Ride"] = 140.95, ["Mega"] = 212.79, ["Mega|Ride"] = 191.58}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 31.4, ["Neon"] = 3.5, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 105, ["Mega"] = 23.41, ["Mega|Ride"] = 48.09, ["Mega|Fly|Ride"] = 115.5}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 2.1, ["Neon"] = 13.02, ["Mega"] = 84, ["Mega|Ride"] = 160.72, ["Mega|Fly|Ride"] = 254.37}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.1, ["Fly"] = 78.92, ["Ride"] = 19.69, ["Neon"] = 10.21, ["Neon|Ride"] = 42.58, ["Neon|Fly|Ride"] = 142.63, ["Mega"] = 124.69, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 193.1}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 14.23, ["Ride"] = 14.34, ["Fly|Ride"] = 31.47, ["Neon"] = 2.1, ["Neon|Fly"] = 15.64, ["Neon|Ride"] = 13.02, ["Neon|Fly|Ride"] = 30.91, ["Mega"] = 11.95, ["Mega|Fly"] = 26.25, ["Mega|Ride"] = 21.65, ["Mega|Fly|Ride"] = 52.47}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 28.74, ["Ride"] = 27.42, ["Fly|Ride"] = 142.63, ["Neon"] = 12.83, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 196.47, ["Mega"] = 129.65, ["Mega|Ride"] = 160.78, ["Mega|Fly|Ride"] = 161.73}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 9.09, ["Fly"] = 21.3, ["Ride"] = 40.46, ["Fly|Ride"] = 52.5, ["Neon"] = 55.04, ["Neon|Ride"] = 68.86, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 223.23, ["Mega|Ride"] = 297.51, ["Mega|Fly|Ride"] = 322.23}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 32.61, ["Ride"] = 14.44, ["Fly|Ride"] = 28.74, ["Neon"] = 2.1, ["Neon|Fly"] = 15.99, ["Neon|Ride"] = 15.59, ["Neon|Fly|Ride"] = 32.19, ["Mega"] = 19.82, ["Mega|Ride"] = 31.5, ["Mega|Fly|Ride"] = 71.32}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.1, ["Fly"] = 177.74, ["Ride"] = 31.5, ["Neon"] = 7.53, ["Neon|Ride"] = 35.85, ["Neon|Fly|Ride"] = 169.23, ["Mega"] = 64.94, ["Mega|Fly"] = 170.29, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 35.43, ["Neon"] = 3.71, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 284.1, ["Mega"] = 26.25, ["Mega|Fly"] = 142.63, ["Mega|Ride"] = 78.77, ["Mega|Fly|Ride"] = 313.95}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 32.6, ["Ride"] = 15.75, ["Neon"] = 2.1, ["Neon|Ride"] = 21.3, ["Neon|Fly|Ride"] = 284.16, ["Mega"] = 11.46, ["Mega|Fly"] = 253.82, ["Mega|Ride"] = 41.05, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 91.88, ["Ride"] = 15.18, ["Fly|Ride"] = 46.56, ["Neon"] = 7.76, ["Neon|Fly"] = 54.29, ["Neon|Ride"] = 17.18, ["Neon|Fly|Ride"] = 60.48, ["Mega"] = 71.65, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 187.31}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 27.6, ["Neon"] = 5.19, ["Neon|Ride"] = 68.25, ["Mega"] = 40.42, ["Mega|Fly"] = 322.23, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 249.37}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 19.5, ["Ride"] = 15.66, ["Fly|Ride"] = 42.58, ["Neon"] = 11.46, ["Neon|Fly"] = 31.95, ["Neon|Ride"] = 21.3, ["Neon|Fly|Ride"] = 57.47, ["Mega"] = 111.57, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 123.38}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 2.1, ["Ride"] = 38.57, ["Fly|Ride"] = 50.04, ["Neon"] = 31.07, ["Neon|Fly"] = 188.89, ["Neon|Fly|Ride"] = 319.29, ["Mega"] = 101.07, ["Mega|Fly"] = 341.25, ["Mega|Ride"] = 210}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Fly"] = 25.77, ["Ride"] = 15.6, ["Fly|Ride"] = 32.8, ["Neon"] = 10.19, ["Neon|Fly"] = 28.74, ["Neon|Ride"] = 32.23, ["Neon|Fly|Ride"] = 85.2, ["Mega"] = 199.03, ["Mega|Fly"] = 420, ["Mega|Ride"] = 121.44, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.1, ["Fly"] = 18.19, ["Ride"] = 17.07, ["Fly|Ride"] = 73.5, ["Neon"] = 11.46, ["Neon|Fly"] = 66.29, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 108.32, ["Mega"] = 170.29, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 112.83, ["Neon"] = 7.88, ["Neon|Fly|Ride"] = 2625, ["Mega"] = 217.77, ["Mega|Ride"] = 308.64}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 7.87, ["Ride"] = 51.9, ["Neon"] = 202.1, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 794.07, ["Mega"] = 636.42, ["Mega|Ride"] = 751.36, ["Mega|Fly|Ride"] = 981.75}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 3.76, ["Ride"] = 28.74, ["Fly|Ride"] = 106.44, ["Neon"] = 44.61, ["Neon|Ride"] = 106.55, ["Mega"] = 161.73, ["Mega|Ride"] = 365.54, ["Mega|Fly|Ride"] = 322.23}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 3.78, ["Ride"] = 31.95, ["Fly|Ride"] = 120.75, ["Neon"] = 47.25, ["Neon|Ride"] = 63, ["Mega"] = 283.1, ["Mega|Ride"] = 411.88, ["Mega|Fly|Ride"] = 397.69}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Ride"] = 28.74, ["Neon"] = 2.54, ["Neon|Ride"] = 65.02, ["Mega"] = 16.95, ["Mega|Fly"] = 122.4, ["Mega|Ride"] = 42.58, ["Mega|Fly|Ride"] = 191.58}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 41.9}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 4.67, ["Fly"] = 21.3, ["Ride"] = 15.75, ["Fly|Ride"] = 43.32, ["Neon"] = 42, ["Neon|Fly"] = 188.48, ["Neon|Ride"] = 47.58, ["Neon|Fly|Ride"] = 94.31, ["Mega|Fly"] = 291.61, ["Mega|Ride"] = 208.68, ["Mega|Fly|Ride"] = 291.61}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.79, ["Ride"] = 16.96, ["Fly|Ride"] = 64.56, ["Neon"] = 2.1, ["Neon|Fly"] = 52.8, ["Neon|Ride"] = 21.3, ["Neon|Fly|Ride"] = 105, ["Mega"] = 17.46, ["Mega|Fly"] = 142.63, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 98.43}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 5.94, ["Neon|Ride"] = 36.74, ["Neon|Fly|Ride"] = 72.18, ["Mega"] = 32.21, ["Mega|Ride"] = 55.11, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 42.58, ["Ride"] = 15.6, ["Fly|Ride"] = 32.78, ["Neon"] = 7.76, ["Neon|Ride"] = 19.18, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 142.63, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 236.27}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 3.56, ["Fly"] = 42.58, ["Ride"] = 44.71, ["Fly|Ride"] = 57.75, ["Neon"] = 45.84, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 170.22, ["Mega|Ride"] = 363.99, ["Mega|Fly|Ride"] = 319.29}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Ride"] = 21, ["Neon"] = 3.82, ["Mega"] = 20.19, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 52.4, ["Mega|Fly|Ride"] = 340.57}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 27.56, ["Ride"] = 16.7, ["Fly|Ride"] = 34.28, ["Neon"] = 3.66, ["Neon|Fly"] = 112.83, ["Neon|Ride"] = 19.68, ["Neon|Fly|Ride"] = 96.56, ["Mega"] = 27.76, ["Mega|Fly"] = 142.63, ["Mega|Ride"] = 39.26, ["Mega|Fly|Ride"] = 112.84}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 28.65, ["Ride"] = 15.43, ["Fly|Ride"] = 42.58, ["Neon"] = 11.71, ["Neon|Fly"] = 53.23, ["Neon|Ride"] = 18.16, ["Neon|Fly|Ride"] = 36.19, ["Mega"] = 65.63, ["Mega|Fly"] = 142.63, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 85.44}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 91.88, ["Ride"] = 37.26, ["Fly|Ride"] = 142.54, ["Neon"] = 4.5, ["Neon|Ride"] = 39.19, ["Neon|Fly|Ride"] = 105, ["Mega"] = 63.56, ["Mega|Ride"] = 79.15, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 3.78, ["Neon|Ride"] = 113.46, ["Neon|Fly|Ride"] = 155435.07, ["Mega"] = 17.75, ["Mega|Fly"] = 106.44, ["Mega|Ride"] = 55.13, ["Mega|Fly|Ride"] = 136.49}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 45.91, ["Ride"] = 17.43, ["Fly|Ride"] = 142.63, ["Neon"] = 2.1, ["Neon|Fly"] = 27.77, ["Neon|Ride"] = 20.39, ["Neon|Fly|Ride"] = 95.8, ["Mega"] = 16.96, ["Mega|Fly"] = 63.88, ["Mega|Ride"] = 35.13, ["Mega|Fly|Ride"] = 87.83}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 40.46, ["Neon|Fly|Ride"] = 113.89, ["Mega"] = 19.18, ["Mega|Ride"] = 425.71}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.63, ["Neon"] = 3.81, ["Neon|Fly|Ride"] = 420, ["Mega"] = 31.27, ["Mega|Ride"] = 191.58, ["Mega|Fly|Ride"] = 263.94}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 15.74, ["Fly|Ride"] = 52.5, ["Neon"] = 6.35, ["Neon|Fly"] = 32.81, ["Neon|Ride"] = 15.6, ["Neon|Fly|Ride"] = 42.58, ["Mega"] = 28.74, ["Mega|Fly"] = 45.77, ["Mega|Fly|Ride"] = 106.44}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 8.93, ["Ride"] = 78.74, ["Fly|Ride"] = 212.86, ["Neon"] = 61.72, ["Neon|Ride"] = 98.89, ["Mega"] = 406.88, ["Mega|Ride"] = 539.58, ["Mega|Fly|Ride"] = 709.85}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.1, ["Fly"] = 6562.5, ["Ride"] = 36.2, ["Neon"] = 32.82, ["Neon|Ride"] = 157.5, ["Mega"] = 183.75, ["Mega|Fly|Ride"] = 568.31}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 2.71, ["Ride"] = 31.95, ["Fly|Ride"] = 180.93, ["Neon"] = 19.69, ["Neon|Ride"] = 79.67, ["Mega"] = 250.08, ["Mega|Fly|Ride"] = 380.52}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 12.78, ["Ride"] = 12.51, ["Fly|Ride"] = 23.63, ["Neon"] = 2.1, ["Neon|Fly"] = 16.75, ["Neon|Ride"] = 10.5, ["Neon|Fly|Ride"] = 21.3, ["Mega"] = 14.49, ["Mega|Fly"] = 19.15, ["Mega|Ride"] = 18.97, ["Mega|Fly|Ride"] = 42.58}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 3.84, ["Fly"] = 118.12, ["Ride"] = 59.61, ["Neon"] = 5.62, ["Neon|Fly"] = 67.79, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 709.85, ["Mega"] = 85.31, ["Mega|Ride"] = 85.32}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Fly"] = 71.32, ["Ride"] = 26.25, ["Neon"] = 2.1, ["Neon|Fly"] = 31.95, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 86.65, ["Mega"] = 12.01, ["Mega|Fly"] = 63.88, ["Mega|Ride"] = 71.32, ["Mega|Fly|Ride"] = 138.36}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 3.39, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 127.32, ["Mega"] = 13.01, ["Mega|Fly"] = 212.86, ["Mega|Fly|Ride"] = 161.73}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 126.29, ["Ride"] = 16.59, ["Fly|Ride"] = 43.22, ["Neon"] = 9.78, ["Neon|Fly"] = 68.19, ["Neon|Ride"] = 40.25, ["Neon|Fly|Ride"] = 76.11, ["Mega"] = 169.32, ["Mega|Ride"] = 160.13, ["Mega|Fly|Ride"] = 292.04}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 128.38, ["Ride"] = 224.11, ["Fly|Ride"] = 383.14, ["Neon"] = 752.42, ["Neon|Fly|Ride"] = 974.85, ["Mega"] = 8513.82, ["Mega|Fly|Ride"] = 3360.84}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Ride"] = 24.5, ["Neon"] = 4.99, ["Neon|Ride"] = 64.31, ["Mega"] = 68.06, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 2.83, ["Fly"] = 103.68, ["Ride"] = 26.25, ["Fly|Ride"] = 62.91, ["Neon"] = 32.49, ["Neon|Ride"] = 170.29, ["Neon|Fly|Ride"] = 142.63, ["Mega"] = 381.89, ["Mega|Ride"] = 531.06, ["Mega|Fly|Ride"] = 644.45}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 28.74, ["Ride"] = 15.71, ["Fly|Ride"] = 32.55, ["Neon"] = 3.7, ["Neon|Fly"] = 33.01, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 46.46, ["Mega"] = 49.67, ["Mega|Ride"] = 83.91, ["Mega|Fly|Ride"] = 126.67}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 77.24, ["Ride"] = 19.19, ["Fly|Ride"] = 92.59, ["Neon"] = 8.87, ["Neon|Ride"] = 50.22, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 51.1, ["Mega|Ride"] = 193.1, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 3.92, ["Fly"] = 26.25, ["Ride"] = 15.59, ["Fly|Ride"] = 31.5, ["Neon"] = 26.65, ["Neon|Fly"] = 100.05, ["Neon|Ride"] = 35.65, ["Neon|Fly|Ride"] = 77.97, ["Mega|Ride"] = 279.9, ["Mega|Fly|Ride"] = 294}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 2.41, ["Ride"] = 34.29, ["Fly|Ride"] = 257.56, ["Neon"] = 48.06, ["Neon|Ride"] = 85.15, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 216.56, ["Mega|Ride"] = 378.75, ["Mega|Fly|Ride"] = 387.18}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.82, ["Fly"] = 17.04, ["Ride"] = 14.2, ["Fly|Ride"] = 31.4, ["Neon"] = 27.37, ["Neon|Fly"] = 69.36, ["Neon|Ride"] = 25.98, ["Neon|Fly|Ride"] = 63.63, ["Mega"] = 262.5, ["Mega|Ride"] = 284.16, ["Mega|Fly|Ride"] = 242.82}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 54.94, ["Fly"] = 106.44, ["Ride"] = 74.82, ["Fly|Ride"] = 143.34, ["Neon"] = 341.24, ["Neon|Fly"] = 437.07, ["Neon|Ride"] = 402.72, ["Neon|Fly|Ride"] = 437.18, ["Mega|Fly|Ride"] = 1468.69}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 213.78, ["Fly"] = 425.71, ["Ride"] = 246.75, ["Fly|Ride"] = 228.57, ["Neon|Ride"] = 1277.09, ["Neon|Fly|Ride"] = 965.51, ["Mega"] = 10642.28, ["Mega|Fly|Ride"] = 4963.58}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 55.13, ["Fly"] = 135.18, ["Ride"] = 64.73, ["Fly|Ride"] = 84.96, ["Neon"] = 262.5, ["Neon|Ride"] = 290.07, ["Neon|Fly|Ride"] = 286.8, ["Mega|Ride"] = 1277.09, ["Mega|Fly|Ride"] = 1413.2}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 2.25, ["Fly"] = 287.99, ["Ride"] = 23.29, ["Neon"] = 28.88, ["Neon|Ride"] = 99.75, ["Neon|Fly|Ride"] = 284.1, ["Mega"] = 262.5, ["Mega|Ride"] = 196.75, ["Mega|Fly|Ride"] = 416.73}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 8.77, ["Fly"] = 71.32, ["Ride"] = 31.47, ["Fly|Ride"] = 63.57, ["Neon"] = 82.69, ["Neon|Ride"] = 63.95, ["Neon|Fly|Ride"] = 196.87, ["Mega"] = 416.07, ["Mega|Ride"] = 330.39, ["Mega|Fly|Ride"] = 407.72}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 31.49, ["Ride"] = 10.5, ["Fly|Ride"] = 47.16, ["Neon"] = 3.21, ["Neon|Fly"] = 24.5, ["Neon|Ride"] = 21.73, ["Neon|Fly|Ride"] = 35.34, ["Mega"] = 32.81, ["Mega|Fly"] = 147.24, ["Mega|Ride"] = 212.63, ["Mega|Fly|Ride"] = 532.22}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 10.4, ["Fly"] = 39.38, ["Ride"] = 24.48, ["Fly|Ride"] = 66.25, ["Neon"] = 100.44, ["Neon|Fly"] = 284.16, ["Neon|Ride"] = 113.05, ["Neon|Fly|Ride"] = 212.86, ["Mega"] = 1837.5, ["Mega|Ride"] = 482.73, ["Mega|Fly|Ride"] = 732.38}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 41.91, ["Ride"] = 15.09, ["Fly|Ride"] = 36.11, ["Neon"] = 9.52, ["Neon|Fly"] = 22.32, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 70.88, ["Mega|Ride"] = 284.16, ["Mega|Fly|Ride"] = 226.21}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 2.1, ["Ride"] = 28.74, ["Fly|Ride"] = 328.13, ["Neon"] = 43.31, ["Neon|Ride"] = 36.2, ["Mega"] = 199.03, ["Mega|Ride"] = 171.94, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 27.68, ["Ride"] = 19.37, ["Neon"] = 2.1, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 15.75, ["Mega|Fly"] = 30.19, ["Mega|Ride"] = 42.58, ["Mega|Fly|Ride"] = 78.74}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 19.59, ["Ride"] = 18.86, ["Fly|Ride"] = 31.95, ["Neon"] = 11.41, ["Neon|Fly"] = 106.44, ["Neon|Ride"] = 28.74, ["Neon|Fly|Ride"] = 147, ["Mega"] = 72.19, ["Mega|Fly|Ride"] = 267.14}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.52, ["Fly"] = 25.99, ["Ride"] = 17.38, ["Fly|Ride"] = 62.79, ["Neon"] = 18.38, ["Neon|Ride"] = 47.25, ["Mega"] = 131.18, ["Mega|Ride"] = 266.44, ["Mega|Fly|Ride"] = 248.07}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 96.66, ["Fly"] = 143.07, ["Ride"] = 143.06, ["Fly|Ride"] = 196.53, ["Neon"] = 328.12, ["Neon|Fly"] = 644.32, ["Neon|Ride"] = 437.07, ["Neon|Fly|Ride"] = 530.25, ["Mega"] = 4256.91, ["Mega|Fly|Ride"] = 2256.07}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 7.61, ["Ride"] = 89.31, ["Fly|Ride"] = 129.11, ["Neon"] = 38.57, ["Neon|Ride"] = 98.42, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 326.82, ["Mega|Ride"] = 439.28, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 42.49, ["Ride"] = 16.43, ["Fly|Ride"] = 31.5, ["Neon"] = 18.38, ["Neon|Ride"] = 32.42, ["Neon|Fly|Ride"] = 120.64, ["Mega"] = 246.75, ["Mega|Ride"] = 187.68, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 19.69, ["Ride"] = 53.13, ["Fly|Ride"] = 170.63, ["Neon"] = 137.16, ["Neon|Ride"] = 161.34, ["Neon|Fly|Ride"] = 708.79, ["Mega"] = 504.46, ["Mega|Fly"] = 851.4, ["Mega|Ride"] = 692.72, ["Mega|Fly|Ride"] = 644.45}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 2.1}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 2.7, ["Ride"] = 28.84, ["Fly|Ride"] = 126.67, ["Neon"] = 36.75, ["Neon|Fly"] = 89.25, ["Neon|Ride"] = 159.66, ["Neon|Fly|Ride"] = 326.73, ["Mega"] = 837.75, ["Mega|Ride"] = 582.15, ["Mega|Fly|Ride"] = 885.81}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 29.19, ["Fly"] = 35.7, ["Ride"] = 28.44, ["Fly|Ride"] = 42, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 162.65, ["Neon|Fly|Ride"] = 158.29, ["Mega"] = 1373.93, ["Mega|Fly|Ride"] = 709.85}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 52.49, ["Neon"] = 3.9, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 27.44, ["Neon|Fly|Ride"] = 107.62, ["Mega"] = 27.17, ["Mega|Fly"] = 188.99, ["Mega|Ride"] = 71.9, ["Mega|Fly|Ride"] = 229.53}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 9.09, ["Fly"] = 32.53, ["Ride"] = 19.81, ["Fly|Ride"] = 65.54, ["Neon"] = 63.88, ["Neon|Ride"] = 63.88, ["Mega"] = 284.16, ["Mega|Fly"] = 403.09, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 497}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 28.97, ["Ride"] = 14.44, ["Fly|Ride"] = 28.74, ["Neon"] = 17.07, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 30.6, ["Neon|Fly|Ride"] = 77.44, ["Mega"] = 142.63, ["Mega|Ride"] = 202.02, ["Mega|Fly|Ride"] = 275.73}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 28.76, ["Neon"] = 3.75, ["Neon|Fly"] = 270.34, ["Neon|Ride"] = 32.71, ["Mega"] = 18.27, ["Mega|Ride"] = 60.38, ["Mega|Fly|Ride"] = 140.04}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 19.59, ["Fly"] = 147.23, ["Ride"] = 67.45, ["Fly|Ride"] = 105, ["Neon"] = 117.89, ["Neon|Ride"] = 209.9, ["Neon|Fly|Ride"] = 568.31, ["Mega"] = 897.88, ["Mega|Ride"] = 860.43, ["Mega|Fly|Ride"] = 965.46}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.82, ["Fly"] = 28.74, ["Ride"] = 42, ["Fly|Ride"] = 210, ["Neon"] = 95.82, ["Mega|Ride"] = 525}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 3.73, ["Fly"] = 19.69, ["Ride"] = 15.74, ["Fly|Ride"] = 61.15, ["Neon"] = 20.35, ["Neon|Fly"] = 85.15, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 57.75, ["Mega"] = 460.04, ["Mega|Fly|Ride"] = 273.96}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 73.98, ["Fly"] = 433.12, ["Ride"] = 393.75, ["Fly|Ride"] = 262.5, ["Neon"] = 393.75, ["Neon|Ride"] = 393.75, ["Mega"] = 4507.42, ["Mega|Ride"] = 2165.63, ["Mega|Fly|Ride"] = 2837.25}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 5.57, ["Fly"] = 45.45, ["Ride"] = 21.19, ["Fly|Ride"] = 57.74, ["Neon"] = 28.66, ["Neon|Ride"] = 57.94, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 206.05, ["Mega|Ride"] = 212.86, ["Mega|Fly|Ride"] = 319.79}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 70.88, ["Fly"] = 143.06, ["Ride"] = 114.35, ["Fly|Ride"] = 156.19, ["Neon"] = 216.56, ["Neon|Fly"] = 323.53, ["Neon|Ride"] = 225.65, ["Neon|Fly|Ride"] = 314.64, ["Mega"] = 1010.63, ["Mega|Ride"] = 1036.88, ["Mega|Fly|Ride"] = 976.5}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 19.58, ["Ride"] = 31.4, ["Fly|Ride"] = 149, ["Neon"] = 78.75, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 196.87, ["Mega"] = 354.38, ["Mega|Fly"] = 425.71, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 436.41}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 5.18, ["Fly"] = 42.58, ["Ride"] = 15.99, ["Fly|Ride"] = 70.13, ["Neon"] = 118.14, ["Neon|Ride"] = 191.67, ["Neon|Fly|Ride"] = 383.78, ["Mega"] = 317.4, ["Mega|Ride"] = 212.86, ["Mega|Fly|Ride"] = 548.09}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 10.5, ["Ride"] = 42.95, ["Fly|Ride"] = 142.63, ["Neon"] = 39.15, ["Neon|Fly"] = 120.7, ["Neon|Ride"] = 74.42, ["Neon|Fly|Ride"] = 438.38, ["Mega"] = 249.38, ["Mega|Ride"] = 340.57, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 5.39, ["Ride"] = 30.35, ["Fly|Ride"] = 78.75, ["Neon"] = 32.45, ["Neon|Ride"] = 39.9, ["Neon|Fly|Ride"] = 129.14, ["Mega"] = 276.63, ["Mega|Ride"] = 273.97, ["Mega|Fly|Ride"] = 364.05}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Ride"] = 70.81, ["Neon"] = 2.1, ["Neon|Fly"] = 94.74, ["Neon|Ride"] = 101.11, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 17.1, ["Mega|Ride"] = 142.63, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 2.4, ["Ride"] = 71.31, ["Fly|Ride"] = 65.63, ["Neon"] = 36.17, ["Neon|Ride"] = 189.39, ["Neon|Fly|Ride"] = 202.78, ["Mega"] = 233.52, ["Mega|Ride"] = 425.71, ["Mega|Fly|Ride"] = 516.53}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Fly"] = 126.67, ["Ride"] = 28.53, ["Neon"] = 28.56, ["Neon|Fly"] = 116.94, ["Neon|Ride"] = 71.32, ["Neon|Fly|Ride"] = 185.19, ["Mega"] = 210.67, ["Mega|Ride"] = 283.03, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 3.45, ["Ride"] = 32.79, ["Fly|Ride"] = 120.67, ["Neon"] = 30.87, ["Neon|Ride"] = 85.15, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 125.58, ["Mega|Ride"] = 284.16, ["Mega|Fly|Ride"] = 519.74}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 520.45, ["Ride"] = 506.63, ["Fly|Ride"] = 560.17, ["Neon"] = 1809.2, ["Neon|Fly"] = 1811.33, ["Neon|Ride"] = 1849.64, ["Neon|Fly|Ride"] = 1665.18, ["Mega|Fly|Ride"] = 5892.62}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 3.94, ["Fly"] = 57.48, ["Ride"] = 20.42, ["Fly|Ride"] = 53.52, ["Neon"] = 71.32, ["Neon|Ride"] = 57.72, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 196.88, ["Mega|Ride"] = 368.03, ["Mega|Fly|Ride"] = 352.27}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 4.5, ["Fly"] = 66.94, ["Ride"] = 19.58, ["Fly|Ride"] = 51.54, ["Neon"] = 75.49, ["Neon|Fly"] = 315, ["Neon|Ride"] = 73.11, ["Neon|Fly|Ride"] = 166.04, ["Mega"] = 331.86, ["Mega|Ride"] = 482.73, ["Mega|Fly|Ride"] = 421.45}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 2.1, ["Fly"] = 24.93, ["Ride"] = 21.3, ["Fly|Ride"] = 50.79, ["Neon"] = 17.07, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 131.25}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.6, ["Ride"] = 24.39, ["Fly|Ride"] = 89.15, ["Neon"] = 7.38, ["Neon|Ride"] = 30.06, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 61.59, ["Mega|Fly"] = 284.16, ["Mega|Ride"] = 112.77, ["Mega|Fly|Ride"] = 236.23}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 71.32, ["Ride"] = 17.07, ["Neon"] = 2.1, ["Neon|Ride"] = 24.09, ["Neon|Fly|Ride"] = 114.09, ["Mega"] = 23.62, ["Mega|Ride"] = 78.66, ["Mega|Fly|Ride"] = 225.62}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1102.5}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 6.24, ["Fly"] = 23.63, ["Ride"] = 30.43, ["Fly|Ride"] = 332.06, ["Neon"] = 65.54, ["Neon|Ride"] = 100.08, ["Mega"] = 356.02, ["Mega|Ride"] = 370.51, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 28.26, ["Neon"] = 5.24, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 994, ["Mega"] = 37.14, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 208.04}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 3.5, ["Fly"] = 312.35, ["Ride"] = 50.23, ["Neon"] = 20.9, ["Neon|Ride"] = 71.31, ["Neon|Fly|Ride"] = 249.8, ["Mega"] = 246.75, ["Mega|Ride"] = 362.06, ["Mega|Fly|Ride"] = 1064.24}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 416.06, ["Ride"] = 381.94, ["Fly|Ride"] = 524.99, ["Neon|Ride"] = 1420.55, ["Neon|Fly|Ride"] = 1312.49, ["Mega|Fly|Ride"] = 6298.69}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 3.72, ["Fly"] = 196.88, ["Ride"] = 42.58, ["Fly|Ride"] = 127.73, ["Neon"] = 41.52, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 193.1, ["Mega"] = 284.27, ["Mega|Ride"] = 305.45, ["Mega|Fly|Ride"] = 756.68}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Ride"] = 28.74, ["Fly|Ride"] = 118.1, ["Neon"] = 6.13, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 103.68, ["Mega"] = 32.24, ["Mega|Fly"] = 142.54, ["Mega|Ride"] = 76, ["Mega|Fly|Ride"] = 154.16}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Neon"] = 2.17, ["Neon|Ride"] = 142.63, ["Neon|Fly|Ride"] = 197.97, ["Mega"] = 31.83, ["Mega|Ride"] = 142.63, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 22.91, ["Fly"] = 107.89, ["Ride"] = 42.49, ["Fly|Ride"] = 142.63, ["Neon"] = 157.49, ["Neon|Ride"] = 179.82, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 446.25, ["Mega|Ride"] = 472.5, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 5.3, ["Ride"] = 71.31, ["Neon"] = 71.74, ["Neon|Ride"] = 183.12, ["Neon|Fly|Ride"] = 482.73, ["Mega"] = 482.73, ["Mega|Ride"] = 482.35, ["Mega|Fly|Ride"] = 702.4}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 40.69, ["Ride"] = 32.4, ["Neon"] = 95.82, ["Neon|Ride"] = 187.11, ["Mega"] = 619.4, ["Mega|Ride"] = 1092.98, ["Mega|Fly|Ride"] = 801.94}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 11.05, ["Ride"] = 24.1, ["Fly|Ride"] = 262.5, ["Neon"] = 167.28, ["Neon|Ride"] = 177.5, ["Neon|Fly|Ride"] = 241.5, ["Mega"] = 643.02, ["Mega|Ride"] = 568.31, ["Mega|Fly|Ride"] = 546}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 393.65, ["Ride"] = 421.19, ["Fly|Ride"] = 566.19, ["Neon"] = 1770.06, ["Neon|Ride"] = 1419.69, ["Neon|Fly|Ride"] = 1102.5, ["Mega|Fly|Ride"] = 3346.87}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 3.92, ["Fly"] = 78.75, ["Ride"] = 28.88, ["Fly|Ride"] = 64.4, ["Neon"] = 198.19, ["Neon|Ride"] = 164.05, ["Neon|Fly|Ride"] = 200.09, ["Mega|Fly"] = 590.63, ["Mega|Ride"] = 561.1, ["Mega|Fly|Ride"] = 740.72}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 2.1, ["Ride"] = 42.68, ["Fly|Ride"] = 127.32, ["Neon"] = 38.57, ["Neon|Ride"] = 221.82, ["Mega"] = 168.16, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 629.99}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 25.65, ["Ride"] = 92.53, ["Fly|Ride"] = 170.63, ["Neon"] = 97.13, ["Neon|Ride"] = 173.41, ["Neon|Fly|Ride"] = 260.78, ["Mega"] = 359.52, ["Mega|Ride"] = 360.94, ["Mega|Fly|Ride"] = 465.92}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Fly|Ride"] = 212.86, ["Neon"] = 7.4, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 275.65, ["Mega"] = 38.07, ["Mega|Ride"] = 128.3, ["Mega|Fly|Ride"] = 279.57}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 38.37, ["Ride"] = 79.06, ["Neon"] = 328.13, ["Neon|Ride"] = 275.55, ["Neon|Fly|Ride"] = 523.62, ["Mega"] = 1629.21, ["Mega|Ride"] = 2092.6, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 76.63, ["Ride"] = 26.25, ["Fly|Ride"] = 262.5, ["Neon"] = 5.25, ["Neon|Fly"] = 185.19, ["Neon|Ride"] = 28.48, ["Neon|Fly|Ride"] = 127.73, ["Mega"] = 60.38, ["Mega|Ride"] = 91.51, ["Mega|Fly|Ride"] = 225.75}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 27.57, ["Ride"] = 15.75, ["Fly|Ride"] = 98.22, ["Neon"] = 3.93, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 48.97, ["Neon|Fly|Ride"] = 103.95, ["Mega"] = 25.68, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 83.08, ["Mega|Fly|Ride"] = 261.75}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Ride"] = 37.94, ["Fly|Ride"] = 131.07, ["Neon"] = 6.46, ["Neon|Ride"] = 53.55, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 66.53, ["Mega|Ride"] = 139.42, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 46.78, ["Fly"] = 85.15, ["Ride"] = 61.57, ["Fly|Ride"] = 144.8, ["Neon"] = 183.75, ["Neon|Ride"] = 326.99, ["Neon|Fly|Ride"] = 482.73, ["Mega|Ride"] = 1135.54, ["Mega|Fly|Ride"] = 1114.26}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 197.29, ["Ride"] = 196.88, ["Fly|Ride"] = 318.94, ["Neon"] = 1702.78, ["Neon|Ride"] = 1436.11, ["Neon|Fly|Ride"] = 1496.25, ["Mega"] = 12770.73, ["Mega|Fly|Ride"] = 4725}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 3.94, ["Ride"] = 100.05, ["Neon"] = 19.85, ["Neon|Fly"] = 350.44, ["Mega"] = 89.25, ["Mega|Ride"] = 194.01, ["Mega|Fly|Ride"] = 347.85}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.1, ["Ride"] = 20.1, ["Fly|Ride"] = 161.69, ["Neon"] = 8.23, ["Neon|Ride"] = 43.89, ["Neon|Fly|Ride"] = 170.29, ["Mega"] = 36.37, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 91.54, ["Mega|Fly|Ride"] = 196.67}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 2.1, ["Ride"] = 28.74, ["Fly|Ride"] = 95.82, ["Neon"] = 32.81, ["Mega"] = 221.38, ["Mega|Ride"] = 351.75, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 3.55, ["Fly"] = 94.85, ["Ride"] = 32.45, ["Fly|Ride"] = 378.88, ["Neon"] = 18.96, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 139.01, ["Mega"] = 120.91, ["Mega|Fly"] = 118.12, ["Mega|Ride"] = 113.89, ["Mega|Fly|Ride"] = 347.82}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 93.66, ["Neon"] = 7.77, ["Neon|Ride"] = 71.32, ["Neon|Fly|Ride"] = 142.63, ["Mega"] = 39.29, ["Mega|Ride"] = 85.52, ["Mega|Fly|Ride"] = 398.04}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 33.01, ["Ride"] = 19.04, ["Fly|Ride"] = 52.5, ["Neon"] = 3.81, ["Neon|Fly"] = 80.88, ["Neon|Ride"] = 28.24, ["Neon|Fly|Ride"] = 126.67, ["Mega"] = 39.37, ["Mega|Ride"] = 99.68, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 28.74, ["Ride"] = 17.8, ["Fly|Ride"] = 56.44, ["Neon"] = 6.43, ["Neon|Fly"] = 101.11, ["Neon|Ride"] = 39.8, ["Neon|Fly|Ride"] = 106.44, ["Mega"] = 156.15, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 728.34}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 21.75, ["Ride"] = 36.05, ["Fly|Ride"] = 78.75, ["Neon"] = 105, ["Neon|Ride"] = 207.23, ["Neon|Fly|Ride"] = 799.66, ["Mega"] = 393.75, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 565.11}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 56.39, ["Ride"] = 88.75, ["Fly|Ride"] = 139.13, ["Neon"] = 423.57, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 367.49, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 1987.99, ["Mega|Ride"] = 1845.38, ["Mega|Fly|Ride"] = 1515.94}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 19.19, ["Fly|Ride"] = 144.38, ["Neon"] = 3.84, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 27.87, ["Neon|Fly|Ride"] = 142.63, ["Mega"] = 32.69, ["Mega|Fly"] = 672, ["Mega|Ride"] = 92.42, ["Mega|Fly|Ride"] = 249.04}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 14.34, ["Ride"] = 15.74, ["Fly|Ride"] = 42.49, ["Neon"] = 3.31, ["Neon|Fly"] = 28.74, ["Neon|Ride"] = 20.89, ["Neon|Fly|Ride"] = 61.68, ["Mega"] = 39.97, ["Mega|Fly"] = 131.21, ["Mega|Ride"] = 68.13, ["Mega|Fly|Ride"] = 96.87}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 3.89, ["Fly"] = 42.58, ["Ride"] = 28.74, ["Fly|Ride"] = 51.98, ["Neon"] = 48.27, ["Neon|Ride"] = 144.84, ["Mega"] = 539.58, ["Mega|Ride"] = 275.62, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 393.65, ["Ride"] = 472.5, ["Fly|Ride"] = 446.25, ["Neon"] = 4256.91, ["Neon|Fly|Ride"] = 1771.88, ["Mega|Fly|Ride"] = 5701.5}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 26.17, ["Fly"] = 91.88, ["Ride"] = 31.5, ["Fly|Ride"] = 61.73, ["Neon"] = 196.86, ["Neon|Ride"] = 191.63, ["Neon|Fly|Ride"] = 259.88, ["Mega"] = 1050, ["Mega|Ride"] = 854.52, ["Mega|Fly|Ride"] = 909.93}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 22.32, ["Fly|Ride"] = 283.1, ["Neon"] = 9.14, ["Neon|Ride"] = 49.21, ["Neon|Fly|Ride"] = 141.63, ["Mega"] = 82.85, ["Mega|Ride"] = 163.9, ["Mega|Fly|Ride"] = 272.99}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 83.85, ["Ride"] = 57.48, ["Fly|Ride"] = 65.63, ["Neon"] = 50.59, ["Neon|Ride"] = 72.34, ["Mega|Fly|Ride"] = 318.22}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 36.21, ["Fly"] = 169.31, ["Ride"] = 37.97, ["Fly|Ride"] = 109.16, ["Neon"] = 194.25, ["Neon|Ride"] = 273.96, ["Neon|Fly|Ride"] = 318.22, ["Mega"] = 2554.16, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1002.75}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 95.82, ["Fly"] = 119.44, ["Ride"] = 114.58, ["Fly|Ride"] = 212.86, ["Neon"] = 355.95, ["Neon|Fly"] = 709.85, ["Neon|Ride"] = 482.73, ["Neon|Fly|Ride"] = 610.32, ["Mega"] = 8513.82, ["Mega|Fly|Ride"] = 2572.5}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 234.94, ["Ride"] = 263.48, ["Fly|Ride"] = 497, ["Neon"] = 709.85, ["Neon|Ride"] = 688.46, ["Neon|Fly|Ride"] = 984.38, ["Mega|Fly|Ride"] = 3544.95}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 8.66, ["Ride"] = 52.7, ["Fly|Ride"] = 150.94, ["Neon"] = 60.09, ["Neon|Fly"] = 120.67, ["Neon|Ride"] = 94.78, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 389.82, ["Mega|Ride"] = 408.71, ["Mega|Fly|Ride"] = 459.77}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 25.45, ["Ride"] = 14.34, ["Fly|Ride"] = 43.32, ["Neon"] = 7.7, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 92.6, ["Mega"] = 93.09, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 187.84}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 4.14, ["Ride"] = 15.31, ["Fly|Ride"] = 46.69, ["Neon"] = 30.87, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 94.38, ["Mega"] = 282.02, ["Mega|Ride"] = 340.57, ["Mega|Fly|Ride"] = 341.24}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 325.19, ["Ride"] = 324.84, ["Fly|Ride"] = 723.96, ["Neon"] = 1569.1, ["Neon|Fly|Ride"] = 1911.36, ["Mega"] = 10216.6, ["Mega|Fly|Ride"] = 5118.75}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 33.01, ["Neon"] = 3.05, ["Neon|Ride"] = 139.41, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 28.25, ["Mega|Ride"] = 106.44, ["Mega|Fly|Ride"] = 448.25}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 4.47, ["Ride"] = 17.01, ["Fly|Ride"] = 39.38, ["Neon"] = 22.32, ["Neon|Ride"] = 33.01, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 204.35, ["Mega|Ride"] = 212.86, ["Mega|Fly|Ride"] = 228.37}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 13.1, ["Ride"] = 72.41, ["Fly|Ride"] = 142.63, ["Neon"] = 85.32, ["Neon|Fly"] = 425.71, ["Neon|Ride"] = 99.75, ["Neon|Fly|Ride"] = 369.34, ["Mega"] = 550.5, ["Mega|Ride"] = 585.9, ["Mega|Fly|Ride"] = 638.34}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 108.84, ["Fly"] = 142.63, ["Ride"] = 118.01, ["Fly|Ride"] = 135.02, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 568.31, ["Mega|Fly|Ride"] = 2379.57}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 17.01, ["Fly"] = 24.46, ["Ride"] = 26.14, ["Fly|Ride"] = 48.51, ["Neon"] = 131.81, ["Neon|Ride"] = 89.3, ["Neon|Fly|Ride"] = 142.64, ["Mega"] = 709.85, ["Mega|Ride"] = 472.5, ["Mega|Fly|Ride"] = 576.18}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 21.3, ["Neon"] = 2.39, ["Neon|Ride"] = 142.63, ["Mega"] = 26.16, ["Mega|Ride"] = 127.95, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 15.99, ["Fly|Ride"] = 85.15, ["Neon"] = 2.1, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 83.3, ["Mega"] = 20.9, ["Mega|Fly"] = 97.12, ["Mega|Ride"] = 31.5, ["Mega|Fly|Ride"] = 111.56}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 10.39, ["Ride"] = 56.42, ["Fly|Ride"] = 170.22, ["Neon"] = 36.3, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 173.04, ["Mega|Ride"] = 218.15, ["Mega|Fly|Ride"] = 311.75}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1181.25, ["Ride"] = 1198.83, ["Fly|Ride"] = 1345.82, ["Neon"] = 4376.12, ["Neon|Ride"] = 4682.61, ["Neon|Fly|Ride"] = 4403.79, ["Mega|Fly|Ride"] = 12600}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 410.82, ["Ride"] = 446.25, ["Fly|Ride"] = 564.27, ["Neon"] = 1680, ["Neon|Ride"] = 1680, ["Neon|Fly|Ride"] = 1753.5, ["Mega"] = 17027.64, ["Mega|Fly|Ride"] = 7379.37}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 261.75, ["Fly"] = 415.98, ["Ride"] = 304.49, ["Fly|Ride"] = 418.59, ["Neon"] = 746.46, ["Neon|Fly"] = 1126.96, ["Neon|Ride"] = 708.44, ["Neon|Fly|Ride"] = 735, ["Mega|Fly|Ride"] = 2916.23}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 225.74, ["Fly"] = 424.64, ["Ride"] = 275.63, ["Fly|Ride"] = 354.27, ["Neon"] = 708.75, ["Neon|Ride"] = 654.93, ["Neon|Fly|Ride"] = 630.29, ["Mega|Fly|Ride"] = 3079.89}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 15.62, ["Ride"] = 15.16, ["Fly|Ride"] = 39.38, ["Neon"] = 3.93, ["Neon|Ride"] = 30.45, ["Neon|Fly|Ride"] = 102.18, ["Mega"] = 63.94, ["Mega|Fly"] = 113.89, ["Mega|Ride"] = 72.19, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 229.57, ["Fly"] = 1419.69, ["Ride"] = 295.32, ["Fly|Ride"] = 458.07, ["Neon"] = 1277.09, ["Neon|Ride"] = 1365, ["Neon|Fly|Ride"] = 1039.5, ["Mega"] = 21568.68, ["Mega|Ride"] = 5108.31, ["Mega|Fly|Ride"] = 4593.75}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 6.27, ["Fly"] = 157.5, ["Ride"] = 70.27, ["Fly|Ride"] = 91.87, ["Neon"] = 26.17, ["Neon|Ride"] = 115.4, ["Neon|Fly|Ride"] = 255.29, ["Mega"] = 172.54, ["Mega|Ride"] = 287.84, ["Mega|Fly|Ride"] = 411.81}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 18.12, ["Ride"] = 15.88, ["Fly|Ride"] = 38.98, ["Neon"] = 7.88, ["Neon|Ride"] = 44.72, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 104.81, ["Mega|Ride"] = 192.94, ["Mega|Fly|Ride"] = 106.21}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 56.03, ["Neon"] = 2.52, ["Neon|Ride"] = 45.94, ["Mega"] = 28.05, ["Mega|Ride"] = 196.47, ["Mega|Fly|Ride"] = 177.62}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 28.88, ["Ride"] = 57.7, ["Fly|Ride"] = 459.38, ["Neon"] = 244.13, ["Neon|Ride"] = 355.46, ["Mega"] = 1050, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 773.07}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Ride"] = 26.56, ["Fly|Ride"] = 68.25, ["Neon"] = 6.15, ["Neon|Ride"] = 61.13, ["Mega"] = 353.34, ["Mega|Ride"] = 411.88, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.13, ["Neon"] = 2.1, ["Neon|Ride"] = 55.11, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 21.92, ["Mega|Ride"] = 70.26, ["Mega|Fly|Ride"] = 161.73}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.4, ["Fly"] = 42.58, ["Ride"] = 31.37, ["Fly|Ride"] = 59.07, ["Neon"] = 18.69, ["Neon|Fly"] = 113.89, ["Neon|Ride"] = 44.89, ["Neon|Fly|Ride"] = 160.22, ["Mega"] = 140.44, ["Mega|Ride"] = 113.89, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 2.1, ["Fly"] = 57.48, ["Ride"] = 24.5, ["Fly|Ride"] = 52.5, ["Neon"] = 36.2, ["Neon|Fly"] = 144.8, ["Neon|Ride"] = 142.63, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 238.83, ["Mega|Ride"] = 300.53, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 10.38, ["Ride"] = 52.5, ["Neon"] = 92.9, ["Neon|Ride"] = 185.19, ["Neon|Fly|Ride"] = 317.4, ["Mega"] = 425.71, ["Mega|Ride"] = 797.11}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 3.94, ["Fly"] = 6436.32, ["Ride"] = 16.96, ["Neon"] = 49.69, ["Neon|Fly"] = 49.88, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 284.16, ["Mega"] = 328.13, ["Mega|Ride"] = 355.46, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 65.01, ["Ride"] = 18.36, ["Fly|Ride"] = 45.83, ["Neon"] = 3.94, ["Neon|Fly"] = 31.95, ["Neon|Ride"] = 27.2, ["Neon|Fly|Ride"] = 104.31, ["Mega"] = 45.94, ["Mega|Fly|Ride"] = 227}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 163.61, ["Fly"] = 227.76, ["Ride"] = 164.01, ["Fly|Ride"] = 241.67, ["Neon"] = 957.83, ["Neon|Ride"] = 906.32, ["Neon|Fly|Ride"] = 839.88, ["Mega"] = 8513.82, ["Mega|Fly|Ride"] = 3975.2}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 19.17, ["Ride"] = 15.44, ["Fly|Ride"] = 29.89, ["Neon"] = 2.63, ["Neon|Fly"] = 36.21, ["Neon|Ride"] = 21.55, ["Neon|Fly|Ride"] = 47.24, ["Mega"] = 21, ["Mega|Ride"] = 57.74, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 5.81, ["Ride"] = 40.15, ["Fly|Ride"] = 196.88, ["Neon"] = 55.59, ["Neon|Ride"] = 113.89, ["Neon|Fly|Ride"] = 772.37, ["Mega"] = 313.69, ["Mega|Ride"] = 321.72, ["Mega|Fly|Ride"] = 379.32}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 26.16, ["Ride"] = 309.67, ["Fly|Ride"] = 170.63, ["Neon"] = 157.49, ["Neon|Ride"] = 199.03, ["Neon|Fly|Ride"] = 183.65, ["Mega"] = 786.19, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 194.24, ["Fly"] = 306.51, ["Ride"] = 252.91, ["Fly|Ride"] = 289.45, ["Neon"] = 812.4, ["Neon|Fly"] = 804.8, ["Neon|Ride"] = 695.63, ["Neon|Fly|Ride"] = 756, ["Mega|Fly|Ride"] = 3507.7}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 14.97, ["Ride"] = 159.91, ["Fly|Ride"] = 144.8, ["Neon"] = 78.75, ["Neon|Ride"] = 212.86, ["Neon|Fly|Ride"] = 425.71, ["Mega"] = 242.82, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 340.57}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 6.32, ["Fly"] = 96.55, ["Ride"] = 57.75, ["Fly|Ride"] = 638.55, ["Neon"] = 118.57, ["Neon|Fly"] = 161.69, ["Neon|Ride"] = 211.2, ["Neon|Fly|Ride"] = 180.52, ["Mega"] = 1135.54, ["Mega|Ride"] = 851.4, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 908.04, ["Fly"] = 1206.66, ["Ride"] = 931.87, ["Fly|Ride"] = 1035.57, ["Neon|Ride"] = 4790.63, ["Neon|Fly|Ride"] = 4834.79, ["Mega|Ride"] = 14190.42, ["Mega|Fly|Ride"] = 15610.08}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 3.89, ["Fly"] = 21.3, ["Ride"] = 20.79, ["Fly|Ride"] = 61.73, ["Neon"] = 21.3, ["Neon|Fly"] = 65.66, ["Neon|Ride"] = 49.13, ["Neon|Fly|Ride"] = 212.86, ["Mega"] = 219.19, ["Mega|Ride"] = 212.86, ["Mega|Fly|Ride"] = 346.49}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 3.69, ["Fly"] = 78.75, ["Ride"] = 49.87, ["Fly|Ride"] = 135.19, ["Neon"] = 40.46, ["Neon|Ride"] = 96.21, ["Neon|Fly|Ride"] = 161.73, ["Mega"] = 527.87, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Fly"] = 85.15, ["Ride"] = 23.89, ["Fly|Ride"] = 55.13, ["Neon"] = 10.71, ["Neon|Ride"] = 46.48, ["Mega"] = 57.48, ["Mega|Ride"] = 360.34, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 10.73, ["Ride"] = 39.29, ["Fly|Ride"] = 94.49, ["Neon"] = 61.69, ["Neon|Fly"] = 143.83, ["Neon|Ride"] = 91.87, ["Neon|Fly|Ride"] = 142.64, ["Mega"] = 435.75, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 2.16, ["Fly"] = 20.6, ["Ride"] = 15.88, ["Fly|Ride"] = 51.91, ["Neon"] = 19.47, ["Neon|Fly"] = 42.74, ["Neon|Ride"] = 30.18, ["Neon|Fly|Ride"] = 109.83, ["Mega"] = 105, ["Mega|Fly"] = 280.98, ["Mega|Ride"] = 126.67, ["Mega|Fly|Ride"] = 192.7}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Ride"] = 21.4, ["Fly|Ride"] = 65.63, ["Neon"] = 9.64, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 124.48, ["Mega|Ride"] = 227.06}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 240.19, ["Fly"] = 237.35, ["Ride"] = 170.29, ["Fly|Ride"] = 425.71, ["Neon"] = 921.63, ["Neon|Fly|Ride"] = 1413.3}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Fly"] = 32.81, ["Ride"] = 19.69, ["Fly|Ride"] = 108.06, ["Neon"] = 6.45, ["Neon|Ride"] = 47.99, ["Neon|Fly|Ride"] = 87.27, ["Mega"] = 59.82, ["Mega|Ride"] = 139.42, ["Mega|Fly|Ride"] = 270.34}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 3.92, ["Ride"] = 28.74, ["Fly|Ride"] = 88.86, ["Neon"] = 27.68, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 188.15, ["Mega"] = 175.88, ["Mega|Ride"] = 322.23, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 2.63, ["Fly"] = 94.73, ["Ride"] = 19.59, ["Neon"] = 13.55, ["Neon|Ride"] = 62.79, ["Mega"] = 94.38, ["Mega|Ride"] = 120.53, ["Mega|Fly|Ride"] = 459.27}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 69.57, ["Ride"] = 111.64, ["Fly|Ride"] = 315, ["Neon"] = 447.57, ["Neon|Ride"] = 392.44, ["Neon|Fly|Ride"] = 760.3, ["Mega"] = 2554.16, ["Mega|Ride"] = 1609.9, ["Mega|Fly|Ride"] = 1277.07}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 19.28, ["Fly"] = 90.77, ["Ride"] = 42.53, ["Fly|Ride"] = 263.94, ["Neon"] = 179.31, ["Neon|Ride"] = 163.96, ["Neon|Fly|Ride"] = 341.93, ["Mega"] = 642.81, ["Mega|Ride"] = 610.88, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 16.37, ["Fly"] = 57.47, ["Ride"] = 35.44, ["Fly|Ride"] = 97.13, ["Neon"] = 80.56, ["Neon|Ride"] = 142.63, ["Neon|Fly|Ride"] = 241.6, ["Mega"] = 425.71, ["Mega|Ride"] = 413.44, ["Mega|Fly|Ride"] = 446.99}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 63.12, ["Neon"] = 6.27, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 236.15, ["Mega"] = 106.98, ["Mega|Ride"] = 163.13, ["Mega|Fly|Ride"] = 510.84}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 26.25, ["Fly"] = 74.79, ["Ride"] = 80.31, ["Fly|Ride"] = 120.75, ["Neon"] = 262.49, ["Neon|Fly"] = 233.17, ["Neon|Ride"] = 196.86, ["Neon|Fly|Ride"] = 309.24, ["Mega|Fly|Ride"] = 1011.71}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 19.46, ["Fly|Ride"] = 52.49, ["Neon"] = 4.46, ["Neon|Ride"] = 57.48, ["Neon|Fly|Ride"] = 126.67, ["Mega"] = 60.67, ["Mega|Ride"] = 283.1, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 18.38, ["Fly"] = 113.45, ["Ride"] = 31.49, ["Fly|Ride"] = 78.75, ["Neon"] = 70.83, ["Neon|Ride"] = 79.67, ["Neon|Fly|Ride"] = 210, ["Mega"] = 393.75, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 322.23, ["Mega|Fly|Ride"] = 425.71}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 36.66, ["Fly"] = 203.34, ["Ride"] = 76.12, ["Fly|Ride"] = 131.25, ["Neon"] = 249.38, ["Neon|Fly"] = 425.71, ["Neon|Ride"] = 262.49, ["Neon|Fly|Ride"] = 404.17, ["Mega|Ride"] = 1382.45, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 15.65, ["Ride"] = 13.55, ["Fly|Ride"] = 28.85, ["Neon"] = 2.1, ["Neon|Fly"] = 24.4, ["Neon|Ride"] = 15.98, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 15.65, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 36.2, ["Mega|Fly|Ride"] = 92.49}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 2.1, ["Ride"] = 22.32, ["Fly|Ride"] = 131.25, ["Neon"] = 20.79, ["Neon|Ride"] = 65.61, ["Neon|Fly|Ride"] = 425.71, ["Mega"] = 170.63, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 392.43}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 10.4, ["Fly"] = 142.63, ["Ride"] = 45.46, ["Fly|Ride"] = 85.32, ["Neon"] = 108.94, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 212.86, ["Mega"] = 546.59, ["Mega|Ride"] = 446.25, ["Mega|Fly|Ride"] = 651}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 22, ["Neon"] = 2.1, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 95.81, ["Mega"] = 20.77, ["Mega|Ride"] = 71.32, ["Mega|Fly|Ride"] = 210.73}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 20.69, ["Fly"] = 203.65, ["Ride"] = 74.04, ["Fly|Ride"] = 177.81, ["Neon"] = 135.11, ["Neon|Ride"] = 173.36, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 653.45, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 550.07, ["Mega|Fly|Ride"] = 675.8}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 9.96, ["Fly"] = 42.58, ["Ride"] = 19.6, ["Fly|Ride"] = 80.9, ["Neon"] = 376.69, ["Neon|Ride"] = 118.18, ["Neon|Fly|Ride"] = 163.9, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 473.59}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Neon"] = 40.77, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 59.26, ["Neon|Fly|Ride"] = 709.85, ["Mega"] = 231, ["Mega|Ride"] = 269.07, ["Mega|Fly|Ride"] = 473.59}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 5.39, ["Fly"] = 72.19, ["Ride"] = 52.41, ["Fly|Ride"] = 229.69, ["Neon"] = 32.82, ["Neon|Ride"] = 65.54, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 263.26, ["Mega|Ride"] = 442.32, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Fly"] = 42.58, ["Ride"] = 19.59, ["Fly|Ride"] = 196.88, ["Neon"] = 6.29, ["Neon|Ride"] = 34.92, ["Mega"] = 52.5, ["Mega|Fly"] = 212.86, ["Mega|Ride"] = 106.32, ["Mega|Fly|Ride"] = 142.63}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 55.36, ["Neon"] = 3.44, ["Neon|Fly|Ride"] = 145.29, ["Mega"] = 30.08, ["Mega|Ride"] = 94.5, ["Mega|Fly|Ride"] = 194.25}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 14.49}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 37.31, ["Fly"] = 100.05, ["Ride"] = 66.27, ["Fly|Ride"] = 79.84, ["Neon"] = 184.57, ["Neon|Ride"] = 212.86, ["Neon|Fly|Ride"] = 315, ["Mega"] = 1845.38, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 850.54}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 27.57, ["Mega"] = 21.65, ["Mega|Ride"] = 121.34, ["Mega|Fly|Ride"] = 319.29}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 420, ["Fly"] = 498.75, ["Ride"] = 551.25, ["Fly|Ride"] = 603.3, ["Neon"] = 2838.31, ["Neon|Ride"] = 2019.91, ["Neon|Fly|Ride"] = 2696.77, ["Mega"] = 17027.64, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 3.76, ["Fly"] = 39.38, ["Ride"] = 33.72, ["Fly|Ride"] = 68.13, ["Neon"] = 35.49, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 113.89, ["Mega"] = 95.86, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 624.72}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.1, ["Fly"] = 29.12, ["Ride"] = 16.87, ["Fly|Ride"] = 91.86, ["Neon"] = 19.49, ["Neon|Ride"] = 62.79, ["Neon|Fly|Ride"] = 99.65, ["Mega"] = 143.07, ["Mega|Fly"] = 284.16, ["Mega|Ride"] = 157.52, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 8.1, ["Ride"] = 42.17, ["Fly|Ride"] = 532.13, ["Neon"] = 55.36, ["Neon|Ride"] = 142.63, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 674.73, ["Mega|Ride"] = 561.75, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 2.1, ["Fly"] = 57.48, ["Ride"] = 38.57, ["Fly|Ride"] = 709.85, ["Neon"] = 29.09, ["Neon|Fly"] = 50.04, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 392.44, ["Mega"] = 278.25, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 5.75, ["Ride"] = 82.69, ["Fly|Ride"] = 157.49, ["Neon"] = 74.85, ["Neon|Ride"] = 144.84, ["Neon|Fly|Ride"] = 273.02, ["Mega"] = 337.52, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 1064.24}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 4.97, ["Fly"] = 105, ["Ride"] = 27.97, ["Fly|Ride"] = 78.75, ["Neon"] = 30.09, ["Neon|Ride"] = 79.19, ["Neon|Fly|Ride"] = 105, ["Mega"] = 227.07, ["Mega|Ride"] = 314.45, ["Mega|Fly|Ride"] = 349.13}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 42.25, ["Ride"] = 13.38, ["Fly|Ride"] = 76.63, ["Neon"] = 2.1, ["Neon|Fly"] = 41.99, ["Neon|Ride"] = 15.89, ["Neon|Fly|Ride"] = 76.63, ["Mega"] = 15.29, ["Mega|Fly"] = 65.01, ["Mega|Ride"] = 37.22, ["Mega|Fly|Ride"] = 92.3}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 3.87, ["Fly"] = 54.29, ["Ride"] = 38.43, ["Fly|Ride"] = 106.44, ["Neon"] = 20.47, ["Neon|Fly"] = 120.7, ["Neon|Ride"] = 45.08, ["Neon|Fly|Ride"] = 196.09, ["Mega"] = 196.87, ["Mega|Ride"] = 209.9, ["Mega|Fly|Ride"] = 322.23}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 283.5, ["Ride"] = 322.4, ["Fly|Ride"] = 363.57, ["Neon"] = 1312.5, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1253.44, ["Mega|Ride"] = 9364.81, ["Mega|Fly|Ride"] = 4230.21}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 78.66, ["Ride"] = 112.88, ["Fly|Ride"] = 273.91, ["Neon"] = 458.06, ["Neon|Fly"] = 911, ["Neon|Ride"] = 420, ["Neon|Fly|Ride"] = 586.41, ["Mega"] = 2271.07, ["Mega|Ride"] = 1488.87, ["Mega|Fly|Ride"] = 1518.57}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 16.95, ["Ride"] = 15.65, ["Fly|Ride"] = 35.43, ["Neon"] = 5.16, ["Neon|Fly"] = 48.71, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 63.88, ["Mega"] = 88.35, ["Mega|Fly"] = 65.18, ["Mega|Ride"] = 78.91, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 14.26, ["Fly|Ride"] = 28.88, ["Neon"] = 6.46, ["Neon|Fly"] = 41.04, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 57.7, ["Mega"] = 70.88, ["Mega|Fly"] = 284.16, ["Mega|Ride"] = 76.32, ["Mega|Fly|Ride"] = 168}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.1, ["Fly"] = 100.05, ["Ride"] = 22.32, ["Fly|Ride"] = 98.44, ["Neon"] = 100.05, ["Neon|Fly|Ride"] = 157.5, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 223.13, ["Ride"] = 210.78, ["Fly|Ride"] = 288.75, ["Neon"] = 1181.25, ["Neon|Ride"] = 1050, ["Neon|Fly|Ride"] = 1577.2, ["Mega|Ride"] = 8513.82, ["Mega|Fly|Ride"] = 3615.94}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.1, ["Fly"] = 15.7, ["Ride"] = 14.75, ["Fly|Ride"] = 42.67, ["Neon"] = 17.16, ["Neon|Fly"] = 104.97, ["Neon|Ride"] = 31.83, ["Neon|Fly|Ride"] = 85.14, ["Mega"] = 255.93, ["Mega|Ride"] = 221.82, ["Mega|Fly|Ride"] = 274.52}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 2.1, ["Ride"] = 75.54, ["Fly|Ride"] = 212.86, ["Neon"] = 36.2, ["Neon|Ride"] = 42.72, ["Neon|Fly|Ride"] = 284.16, ["Mega"] = 196.88, ["Mega|Ride"] = 300.2, ["Mega|Fly|Ride"] = 286.92}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 90.3, ["Neon"] = 3.68, ["Neon|Ride"] = 156.09, ["Mega"] = 90.45, ["Mega|Fly"] = 195.83, ["Mega|Ride"] = 337.92, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 9.64, ["Fly"] = 49.53, ["Ride"] = 19.09, ["Fly|Ride"] = 74.46, ["Neon"] = 157.52, ["Neon|Ride"] = 121.33, ["Neon|Fly|Ride"] = 207.38, ["Mega"] = 460.69, ["Mega|Ride"] = 421.45, ["Mega|Fly|Ride"] = 587.89}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 33.5, ["Ride"] = 78.66, ["Fly|Ride"] = 296.93, ["Neon"] = 125.89, ["Neon|Fly"] = 156.09, ["Neon|Ride"] = 169.29, ["Neon|Fly|Ride"] = 302.75, ["Mega"] = 431.82, ["Mega|Fly"] = 2234.89, ["Mega|Ride"] = 418.69, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 22.71, ["Fly"] = 63.88, ["Ride"] = 40.85, ["Fly|Ride"] = 78.66, ["Neon"] = 157.52, ["Neon|Fly"] = 286.43, ["Neon|Ride"] = 128.4, ["Neon|Fly|Ride"] = 223.12, ["Mega"] = 851.4, ["Mega|Ride"] = 700.88, ["Mega|Fly|Ride"] = 820.32}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 19.59, ["Ride"] = 14.91, ["Fly|Ride"] = 29.22, ["Neon"] = 2.1, ["Neon|Fly"] = 31.39, ["Neon|Ride"] = 15.87, ["Neon|Fly|Ride"] = 47.16, ["Mega"] = 18.15, ["Mega|Fly"] = 425.71, ["Mega|Ride"] = 35.37, ["Mega|Fly|Ride"] = 94.23}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 131.15, ["Fly"] = 270.34, ["Ride"] = 240.5, ["Fly|Ride"] = 272.96, ["Neon"] = 2901.9, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 1054.76, ["Mega|Fly|Ride"] = 3971.7}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 7.87, ["Fly"] = 65.63, ["Ride"] = 24.63, ["Fly|Ride"] = 92.94, ["Neon"] = 107.63, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 430.5, ["Mega|Ride"] = 513.26, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 35.86, ["Ride"] = 18.75, ["Fly|Ride"] = 43.35, ["Neon"] = 3.82, ["Neon|Fly"] = 41.09, ["Neon|Ride"] = 18.12, ["Neon|Fly|Ride"] = 106.44, ["Mega"] = 60.87, ["Mega|Fly"] = 221.38, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 212.86}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 16.05, ["Fly|Ride"] = 65.63, ["Neon"] = 2.1, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 25.56, ["Neon|Fly|Ride"] = 129.14, ["Mega"] = 18.69, ["Mega|Fly"] = 142.63, ["Mega|Ride"] = 45.45, ["Mega|Fly|Ride"] = 98.44}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Ride"] = 28.86, ["Fly|Ride"] = 42.58, ["Neon"] = 14.33, ["Neon|Fly"] = 723.96, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 103.69, ["Mega|Ride"] = 131.78, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 10.31, ["Fly"] = 28.88, ["Ride"] = 23.59, ["Fly|Ride"] = 63.88, ["Neon"] = 50.03, ["Neon|Fly"] = 270.34, ["Neon|Ride"] = 56.45, ["Neon|Fly|Ride"] = 71.32, ["Mega"] = 355.69, ["Mega|Ride"] = 370.12, ["Mega|Fly|Ride"] = 374.07}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 3.52, ["Ride"] = 65.63, ["Neon"] = 64.97, ["Neon|Ride"] = 149, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 235.2, ["Mega|Ride"] = 318.22, ["Mega|Fly|Ride"] = 381.76}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 57.41, ["Neon"] = 2.98, ["Neon|Ride"] = 24.86, ["Neon|Fly|Ride"] = 100.36, ["Mega"] = 78.66, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 157.52}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 5, ["Ride"] = 27.78, ["Fly|Ride"] = 131.25, ["Neon"] = 33.72, ["Neon|Fly"] = 95.85, ["Neon|Ride"] = 45.26, ["Neon|Fly|Ride"] = 285.09, ["Mega"] = 147.94, ["Mega|Ride"] = 224.44, ["Mega|Fly|Ride"] = 257.28}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Fly"] = 71.32, ["Ride"] = 85.15, ["Neon"] = 3.61, ["Neon|Fly"] = 113.89, ["Neon|Ride"] = 45.87, ["Neon|Fly|Ride"] = 102.37, ["Mega"] = 24.94, ["Mega|Ride"] = 66.7, ["Mega|Fly|Ride"] = 142.63}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 45.47, ["Ride"] = 19.4, ["Fly|Ride"] = 41.04, ["Neon"] = 4.82, ["Neon|Ride"] = 22.66, ["Neon|Fly|Ride"] = 107.63, ["Mega"] = 57.02, ["Mega|Fly"] = 142.63, ["Mega|Ride"] = 80.07, ["Mega|Fly|Ride"] = 219.24}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 656.15, ["Ride"] = 702.19, ["Fly|Ride"] = 748.13, ["Neon|Fly|Ride"] = 3674.99, ["Mega|Fly|Ride"] = 12775.7}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 15.28, ["Ride"] = 15.54, ["Fly|Ride"] = 28.74, ["Neon"] = 11.82, ["Neon|Fly"] = 42.58, ["Neon|Ride"] = 27, ["Neon|Fly|Ride"] = 98.44, ["Mega|Fly|Ride"] = 372.5}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.1, ["Ride"] = 43.63, ["Neon"] = 11.45, ["Neon|Fly"] = 142.63, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 57.66, ["Mega|Ride"] = 115.49, ["Mega|Fly|Ride"] = 257.23}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 7.23, ["Fly"] = 22.92, ["Ride"] = 22.32, ["Fly|Ride"] = 57.48, ["Neon"] = 41.36, ["Neon|Fly"] = 193.07, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 109.83, ["Mega"] = 485.63, ["Mega|Ride"] = 265.18, ["Mega|Fly|Ride"] = 347.82}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 16.94, ["Ride"] = 13.13, ["Fly|Ride"] = 30.19, ["Neon"] = 5.25, ["Neon|Fly"] = 149, ["Neon|Ride"] = 23.98, ["Neon|Fly|Ride"] = 72.13, ["Mega"] = 59.06, ["Mega|Ride"] = 95.8, ["Mega|Fly|Ride"] = 178.57}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 35.59, ["Ride"] = 57.48, ["Fly|Ride"] = 313.95, ["Neon"] = 196.87, ["Neon|Ride"] = 306.54, ["Neon|Fly|Ride"] = 424.64, ["Mega"] = 667.29, ["Mega|Ride"] = 680.06}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Fly"] = 32.7, ["Ride"] = 18.37, ["Fly|Ride"] = 76.13, ["Neon"] = 7.22, ["Neon|Fly"] = 137.57, ["Neon|Ride"] = 28.3, ["Neon|Fly|Ride"] = 119.43, ["Mega"] = 44.43, ["Mega|Ride"] = 132.9, ["Mega|Fly|Ride"] = 229.68}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 24.4, ["Fly|Ride"] = 59.85, ["Neon"] = 11.55, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 161.73, ["Mega"] = 69.47, ["Mega|Ride"] = 198.59, ["Mega|Fly|Ride"] = 352.27}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly|Ride"] = 78.75, ["Neon"] = 21.3, ["Mega"] = 97.12, ["Mega|Ride"] = 159.66, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 42, ["Ride"] = 14.65, ["Fly|Ride"] = 57.48, ["Neon"] = 3.28, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 20.24, ["Neon|Fly|Ride"] = 113.7, ["Mega"] = 36.11, ["Mega|Fly"] = 229.68, ["Mega|Ride"] = 81.5, ["Mega|Fly|Ride"] = 212.86}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 9.08, ["Fly"] = 21.19, ["Ride"] = 17.01, ["Fly|Ride"] = 37.38, ["Neon"] = 109.62, ["Neon|Ride"] = 80.85, ["Neon|Fly|Ride"] = 143.07, ["Mega|Ride"] = 355.46, ["Mega|Fly|Ride"] = 344.24}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 699.45, ["Fly"] = 933.96, ["Ride"] = 746.82, ["Fly|Ride"] = 860.7, ["Neon"] = 1935.93, ["Neon|Ride"] = 1837.36, ["Neon|Fly|Ride"] = 2000.73, ["Mega"] = 4654.5, ["Mega|Ride"] = 5945.85, ["Mega|Fly|Ride"] = 5775}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 15.99, ["Ride"] = 13.13, ["Fly|Ride"] = 31.4, ["Neon"] = 3.92, ["Neon|Fly"] = 33.46, ["Neon|Ride"] = 18.3, ["Neon|Fly|Ride"] = 42.75, ["Mega"] = 48.28, ["Mega|Ride"] = 70.88, ["Mega|Fly|Ride"] = 142.63}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 4.9, ["Ride"] = 32.81, ["Fly|Ride"] = 241.33, ["Neon"] = 32.59, ["Neon|Ride"] = 118.46, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 403.09, ["Mega|Ride"] = 355.46, ["Mega|Fly|Ride"] = 393.74}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 47.52, ["Fly"] = 104.9, ["Ride"] = 74.8, ["Fly|Ride"] = 105, ["Neon"] = 315, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 424.64, ["Mega|Fly|Ride"] = 2128.47}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 31.4, ["Fly"] = 146.86, ["Ride"] = 60.38, ["Fly|Ride"] = 104.9, ["Neon"] = 187.69, ["Neon|Ride"] = 161.3, ["Mega"] = 1287.67, ["Mega|Ride"] = 921.63, ["Mega|Fly|Ride"] = 1120.02}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 7.46, ["Fly"] = 89.31, ["Ride"] = 26.49, ["Fly|Ride"] = 142.63, ["Neon"] = 61.73, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 273, ["Mega"] = 305.82, ["Mega|Ride"] = 261.19, ["Mega|Fly|Ride"] = 460.69}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 28.62, ["Ride"] = 57.48, ["Fly|Ride"] = 48.27, ["Neon"] = 103.59, ["Neon|Ride"] = 335.13, ["Neon|Fly|Ride"] = 149.22, ["Mega"] = 283.03, ["Mega|Fly"] = 523.77, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 427.22}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 18.09, ["Ride"] = 31.95, ["Neon"] = 105, ["Neon|Ride"] = 322.23, ["Neon|Fly|Ride"] = 525, ["Mega"] = 525, ["Mega|Fly"] = 567, ["Mega|Ride"] = 476.44, ["Mega|Fly|Ride"] = 741.57}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 3.6}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 3.94, ["Ride"] = 24.93, ["Fly|Ride"] = 78.75, ["Neon"] = 28.58, ["Neon|Ride"] = 55.89, ["Neon|Fly|Ride"] = 212.86, ["Mega"] = 210, ["Mega|Fly"] = 481.04, ["Mega|Ride"] = 207.93, ["Mega|Fly|Ride"] = 306.54}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.49, ["Ride"] = 46.86, ["Neon"] = 10.49, ["Neon|Fly|Ride"] = 212.86, ["Mega"] = 140.49}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 25.88, ["Fly"] = 62.99, ["Ride"] = 30.86, ["Fly|Ride"] = 79.23, ["Neon"] = 203.34, ["Neon|Ride"] = 228.69, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 794.99, ["Mega|Ride"] = 681.76, ["Mega|Fly|Ride"] = 739.98}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.94, ["Fly"] = 18.08, ["Ride"] = 14.34, ["Fly|Ride"] = 39.38, ["Neon"] = 21.3, ["Neon|Fly"] = 52.49, ["Neon|Ride"] = 32.16, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 196.88, ["Mega|Fly"] = 424.64, ["Mega|Ride"] = 171.99, ["Mega|Fly|Ride"] = 233.63}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 4.66, ["Fly"] = 151.14, ["Ride"] = 31.75, ["Fly|Ride"] = 56.27, ["Neon"] = 16.7, ["Neon|Ride"] = 46.68, ["Neon|Fly|Ride"] = 127.94, ["Mega"] = 161.15, ["Mega|Fly"] = 197.4, ["Mega|Ride"] = 143.07, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Ride"] = 71.32, ["Neon"] = 7.25, ["Mega"] = 40.07, ["Mega|Ride"] = 203.43, ["Mega|Fly|Ride"] = 258.57}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 28.66, ["Ride"] = 50.04, ["Fly|Ride"] = 120.73, ["Neon"] = 217.11, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 425.71, ["Mega"] = 524.99, ["Mega|Ride"] = 14190.42, ["Mega|Fly|Ride"] = 871.5}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 21, ["Fly|Ride"] = 65.62, ["Neon"] = 5.03, ["Neon|Fly"] = 203.44, ["Neon|Ride"] = 85.15, ["Mega"] = 61.23, ["Mega|Ride"] = 139.94}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 10.31, ["Ride"] = 80.85, ["Fly|Ride"] = 283.1, ["Neon"] = 42.58, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 142.63, ["Mega"] = 399, ["Mega|Ride"] = 482.73, ["Mega|Fly|Ride"] = 689.63}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 45.9, ["Ride"] = 12.57, ["Fly|Ride"] = 42.26, ["Neon"] = 12.92, ["Neon|Ride"] = 30.09, ["Neon|Fly|Ride"] = 97.46, ["Mega"] = 194.25, ["Mega|Ride"] = 208.04, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 2.1, ["Fly"] = 52.49, ["Ride"] = 23.94, ["Fly|Ride"] = 72.22, ["Neon"] = 40.69, ["Neon|Ride"] = 36.75, ["Mega"] = 398.04, ["Mega|Ride"] = 424.64, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 2.87, ["Ride"] = 78.36, ["Neon"] = 89.15, ["Neon|Ride"] = 77.43, ["Mega"] = 413.86, ["Mega|Ride"] = 366.19, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 38.15, ["Ride"] = 145.69, ["Fly|Ride"] = 258.22, ["Neon"] = 200.09, ["Neon|Ride"] = 421.32, ["Neon|Fly|Ride"] = 630, ["Mega"] = 1038.7, ["Mega|Ride"] = 1383.52, ["Mega|Fly|Ride"] = 1595.29}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 14.12, ["Ride"] = 99.95, ["Neon"] = 107.61, ["Neon|Ride"] = 183.75, ["Mega"] = 349.02, ["Mega|Ride"] = 563.6, ["Mega|Fly|Ride"] = 659.84}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 7.77, ["Ride"] = 126, ["Neon"] = 57.75, ["Neon|Fly"] = 212.86, ["Neon|Ride"] = 170.63, ["Mega"] = 804.96, ["Mega|Ride"] = 434.46, ["Mega|Fly|Ride"] = 568.31}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 19.59, ["Ride"] = 72.19, ["Fly|Ride"] = 367.48, ["Neon"] = 108.94, ["Neon|Ride"] = 262.49, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 653.45, ["Mega|Fly"] = 2128.47, ["Mega|Ride"] = 724.1, ["Mega|Fly|Ride"] = 743.92}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 2.63, ["Neon"] = 17.22, ["Neon|Fly|Ride"] = 142.63, ["Mega"] = 157.52, ["Mega|Fly|Ride"] = 322.23}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 27.68, ["Ride"] = 14.64, ["Fly|Ride"] = 42.58, ["Neon"] = 6.36, ["Neon|Fly"] = 42.58, ["Neon|Ride"] = 22.57, ["Neon|Fly|Ride"] = 93.69, ["Mega"] = 69.17, ["Mega|Ride"] = 71.32, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 2.1, ["Fly"] = 48.28, ["Ride"] = 23.44, ["Fly|Ride"] = 69.56, ["Neon"] = 11.67, ["Neon|Ride"] = 117.08, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 79.99, ["Mega|Ride"] = 104.74, ["Mega|Fly|Ride"] = 301.87}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 32.8, ["Ride"] = 18.38, ["Fly|Ride"] = 57.38, ["Neon"] = 5.98, ["Neon|Ride"] = 19.38, ["Neon|Fly|Ride"] = 96.56, ["Mega"] = 48.45, ["Mega|Fly"] = 122.4, ["Mega|Ride"] = 83.99, ["Mega|Fly|Ride"] = 219.24}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 21.04, ["Fly|Ride"] = 76.63, ["Neon"] = 18.69, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 212.86, ["Mega"] = 284.16, ["Mega|Ride"] = 324.19, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.71, ["Fly"] = 49.6, ["Ride"] = 24.39, ["Fly|Ride"] = 425.71, ["Neon"] = 28.69, ["Neon|Fly"] = 315, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 150.94, ["Mega"] = 302.26, ["Mega|Ride"] = 287.46, ["Mega|Fly|Ride"] = 1064.24}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 3.42, ["Fly"] = 131.25, ["Ride"] = 22.32, ["Fly|Ride"] = 96.54, ["Neon"] = 28.65, ["Neon|Fly"] = 113.89, ["Neon|Ride"] = 29.76, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 259.88, ["Mega|Ride"] = 257.28, ["Mega|Fly|Ride"] = 394.84}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 35.49, ["Ride"] = 23.63, ["Fly|Ride"] = 49.88, ["Neon"] = 21.3, ["Neon|Ride"] = 42.58, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 255.43, ["Mega|Ride"] = 183.7, ["Mega|Fly|Ride"] = 186.18}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 44.84, ["Fly|Ride"] = 91.86, ["Neon"] = 9.65, ["Neon|Fly"] = 437.06, ["Neon|Ride"] = 63.3, ["Neon|Fly|Ride"] = 158.52, ["Mega"] = 90.2, ["Mega|Fly"] = 210, ["Mega|Ride"] = 132.46, ["Mega|Fly|Ride"] = 245.56}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 15.57, ["Fly"] = 212.86, ["Ride"] = 107.76, ["Fly|Ride"] = 375.16, ["Neon"] = 118.13, ["Neon|Ride"] = 194.25, ["Neon|Fly|Ride"] = 380.63, ["Mega"] = 523.69, ["Mega|Ride"] = 603.79, ["Mega|Fly|Ride"] = 623.44}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 43.35, ["Fly"] = 164.07, ["Ride"] = 83.54, ["Fly|Ride"] = 189, ["Neon"] = 212.83, ["Neon|Ride"] = 184.69, ["Neon|Fly|Ride"] = 351.32, ["Mega"] = 1334.46, ["Mega|Ride"] = 842.77, ["Mega|Fly|Ride"] = 1102.49}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 51.08, ["Ride"] = 21.55, ["Fly|Ride"] = 118.12, ["Neon"] = 2.1, ["Neon|Ride"] = 32.8, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 24.94, ["Mega|Ride"] = 64.66, ["Mega|Fly|Ride"] = 145.59}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 6.54, ["Ride"] = 52.5, ["Neon"] = 117.7, ["Neon|Ride"] = 113.46, ["Mega"] = 686.56, ["Mega|Ride"] = 709.85, ["Mega|Fly|Ride"] = 1118.52}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 44.77, ["Ride"] = 91.9, ["Neon"] = 401.49, ["Neon|Ride"] = 357, ["Neon|Fly|Ride"] = 850.33, ["Mega"] = 1701.72, ["Mega|Ride"] = 1608.06, ["Mega|Fly|Ride"] = 1415.44}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 6.13, ["Ride"] = 28.64, ["Fly|Ride"] = 133.88, ["Neon"] = 49.87, ["Neon|Fly"] = 129.14, ["Neon|Ride"] = 70.87, ["Neon|Fly|Ride"] = 126, ["Mega"] = 192.94, ["Mega|Ride"] = 242.71, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 3.83, ["Ride"] = 68.85, ["Neon"] = 8.66, ["Neon|Ride"] = 68.23, ["Neon|Fly|Ride"] = 170.29, ["Mega"] = 104.48, ["Mega|Fly"] = 305.45, ["Mega|Ride"] = 140.44, ["Mega|Fly|Ride"] = 289.66}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 25.7, ["Ride"] = 10.5, ["Fly|Ride"] = 45.94, ["Neon"] = 7.96, ["Neon|Ride"] = 26.23, ["Neon|Fly|Ride"] = 102.18, ["Mega"] = 124.69, ["Mega|Ride"] = 63.41, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 17.64, ["Ride"] = 15.6, ["Fly|Ride"] = 42.2, ["Neon"] = 2.1, ["Neon|Fly"] = 21.14, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 53.38, ["Mega"] = 28.87, ["Mega|Ride"] = 69.56, ["Mega|Fly|Ride"] = 87.94}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 15.75, ["Fly|Ride"] = 85.17, ["Neon"] = 3.59, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 34.72, ["Mega|Fly"] = 122.8, ["Mega|Ride"] = 62.79, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Neon"] = 2.24, ["Neon|Ride"] = 145.08, ["Mega"] = 28.86, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 328.02}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 4.25, ["Ride"] = 104.99, ["Neon"] = 37.97, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 227.76, ["Mega|Ride"] = 162.09, ["Mega|Fly|Ride"] = 411.88}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 6.85, ["Ride"] = 24.94, ["Fly|Ride"] = 212.38, ["Neon"] = 53.72, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 227.76, ["Mega"] = 196.88, ["Mega|Ride"] = 351.75, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 5.25, ["Fly"] = 21, ["Ride"] = 17.28, ["Fly|Ride"] = 35.33, ["Neon"] = 28.25, ["Neon|Fly"] = 57.93, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 83.62, ["Mega"] = 313.95, ["Mega|Ride"] = 256.6, ["Mega|Fly|Ride"] = 360.26}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 52.36, ["Ride"] = 88.54, ["Fly|Ride"] = 262.5, ["Neon"] = 393.75, ["Neon|Ride"] = 424.64, ["Neon|Fly|Ride"] = 709.85, ["Mega"] = 2413.62, ["Mega|Ride"] = 1287.67, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 16.94, ["Fly"] = 82.69, ["Ride"] = 43.22, ["Fly|Ride"] = 51.19, ["Neon"] = 284.16, ["Neon|Fly|Ride"] = 630, ["Mega"] = 482.73, ["Mega|Ride"] = 879.38, ["Mega|Fly|Ride"] = 1042.79}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 15.89, ["Ride"] = 11.72, ["Fly|Ride"] = 39.18, ["Neon"] = 2.1, ["Neon|Fly"] = 42.58, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 56.44, ["Mega"] = 157.5, ["Mega|Fly"] = 71.32, ["Mega|Ride"] = 94.01, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 21.3, ["Ride"] = 13.29, ["Fly|Ride"] = 30.07, ["Neon"] = 3.88, ["Neon|Fly"] = 28.74, ["Neon|Ride"] = 13.29, ["Neon|Fly|Ride"] = 43.32, ["Mega"] = 39.38, ["Mega|Fly"] = 127.73, ["Mega|Ride"] = 62.79, ["Mega|Fly|Ride"] = 90.96}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 328.13, ["Fly"] = 563.53, ["Ride"] = 446.25, ["Fly|Ride"] = 452.82, ["Neon|Fly|Ride"] = 1902.85, ["Mega|Fly|Ride"] = 6740.83}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 4.77, ["Fly"] = 52.5, ["Ride"] = 42.58, ["Fly|Ride"] = 113.89, ["Neon"] = 39.25, ["Neon|Ride"] = 113.89, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 403.5, ["Mega|Ride"] = 388.31, ["Mega|Fly|Ride"] = 497}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 15.59, ["Ride"] = 19, ["Fly|Ride"] = 33.29, ["Neon"] = 3.02, ["Neon|Fly"] = 18.12, ["Neon|Ride"] = 17.06, ["Neon|Fly|Ride"] = 33.91, ["Mega|Ride"] = 79.84, ["Mega|Fly|Ride"] = 106.32}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 51.87, ["Ride"] = 98.24, ["Fly|Ride"] = 261.19, ["Neon"] = 205.83, ["Neon|Ride"] = 261.19, ["Neon|Fly|Ride"] = 392.43, ["Mega"] = 737.62, ["Mega|Ride"] = 761.25, ["Mega|Fly|Ride"] = 878.37}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 21.3, ["Ride"] = 14.9, ["Fly|Ride"] = 40.68, ["Neon"] = 9.39, ["Neon|Fly"] = 76.63, ["Neon|Ride"] = 26.99, ["Neon|Fly|Ride"] = 75.15, ["Mega"] = 124.69, ["Mega|Ride"] = 143.07, ["Mega|Fly|Ride"] = 204.15}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Fly|Ride"] = 196.88, ["Neon"] = 4.27, ["Neon|Fly"] = 100.05, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 75.17, ["Mega"] = 18.52, ["Mega|Ride"] = 72.1, ["Mega|Fly|Ride"] = 209.46}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 29.74, ["Fly"] = 126.95, ["Ride"] = 78.72, ["Fly|Ride"] = 213.55, ["Neon"] = 177.74, ["Neon|Ride"] = 155.93, ["Neon|Fly|Ride"] = 423.57, ["Mega"] = 752.42, ["Mega|Ride"] = 724.1, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 18.27, ["Fly|Ride"] = 146.99, ["Neon"] = 5.69, ["Neon|Ride"] = 40.46, ["Neon|Fly|Ride"] = 78.77, ["Mega"] = 32.16, ["Mega|Ride"] = 152.15, ["Mega|Fly|Ride"] = 251.99}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 31.49, ["Ride"] = 79.84, ["Fly|Ride"] = 105, ["Neon"] = 148.32, ["Neon|Ride"] = 249.27, ["Neon|Fly|Ride"] = 288.46, ["Mega"] = 1770.4, ["Mega|Ride"] = 1702.78}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 2.1, ["Ride"] = 131.24, ["Fly|Ride"] = 425.71, ["Neon"] = 23.09, ["Neon|Ride"] = 31.39, ["Neon|Fly|Ride"] = 497, ["Mega"] = 170.63, ["Mega|Ride"] = 227.76}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.1, ["Fly"] = 71.32, ["Ride"] = 72.76, ["Fly|Ride"] = 71.32, ["Neon"] = 8.37, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 432.36, ["Mega"] = 100.05, ["Mega|Ride"] = 124.69, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 36.18, ["Fly"] = 142.63, ["Ride"] = 62.32, ["Fly|Ride"] = 532.13, ["Mega|Ride"] = 1702.78, ["Mega|Fly|Ride"] = 1980.54}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 505.15, ["Ride"] = 28.73, ["Neon"] = 4.96, ["Neon|Ride"] = 40.72, ["Neon|Fly|Ride"] = 114.32, ["Mega"] = 44.01, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 100.71, ["Mega|Fly|Ride"] = 227.64}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 22.24, ["Ride"] = 10.66, ["Fly|Ride"] = 102.88, ["Neon"] = 8.22, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 26.23, ["Neon|Fly|Ride"] = 63.88, ["Mega"] = 86.63, ["Mega|Fly"] = 148.44, ["Mega|Ride"] = 97.16, ["Mega|Fly|Ride"] = 219.19}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 9.24, ["Fly"] = 57.91, ["Ride"] = 21.3, ["Fly|Ride"] = 169.23, ["Neon"] = 79.94, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 144.27, ["Mega"] = 328.12, ["Mega|Ride"] = 275.62, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 6.6, ["Fly"] = 31.4, ["Ride"] = 22.07, ["Fly|Ride"] = 49.87, ["Neon"] = 72.07, ["Neon|Ride"] = 85.2, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 744.98, ["Mega|Ride"] = 393.79, ["Mega|Fly|Ride"] = 566.19}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 21.3, ["Fly"] = 28.65, ["Ride"] = 28.08, ["Fly|Ride"] = 53.34, ["Neon"] = 75.81, ["Neon|Ride"] = 80.29, ["Neon|Fly|Ride"] = 138.9, ["Mega"] = 553.42, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 446.99}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 59.05, ["Ride"] = 121.34, ["Fly|Ride"] = 259.77, ["Neon"] = 262.49, ["Neon|Ride"] = 275.63, ["Neon|Fly|Ride"] = 423.94, ["Mega"] = 1575, ["Mega|Ride"] = 1553.78, ["Mega|Fly|Ride"] = 1378.13}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 3.83, ["Ride"] = 110.71, ["Neon"] = 25.81, ["Neon|Ride"] = 113.46, ["Neon|Fly|Ride"] = 296.09, ["Mega"] = 239.08, ["Mega|Ride"] = 291.61, ["Mega|Fly|Ride"] = 461.89}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 3.73, ["Ride"] = 27.27, ["Fly|Ride"] = 78.74, ["Neon"] = 15.68, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 261.82, ["Mega|Ride"] = 244.13, ["Mega|Fly|Ride"] = 212.86}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 7.07, ["Fly"] = 135.19, ["Ride"] = 35.44, ["Fly|Ride"] = 158.52, ["Neon"] = 76.13, ["Neon|Ride"] = 65.63, ["Mega"] = 313.95, ["Mega|Ride"] = 638.55, ["Mega|Fly|Ride"] = 759.94}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.65, ["Ride"] = 15.65, ["Fly|Ride"] = 38.26, ["Neon"] = 2.1, ["Neon|Fly"] = 21.69, ["Neon|Ride"] = 15.65, ["Neon|Fly|Ride"] = 44.63, ["Mega"] = 13.55, ["Mega|Ride"] = 26.76, ["Mega|Fly|Ride"] = 95.7}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 46.02, ["Fly"] = 225.63, ["Ride"] = 112.56, ["Fly|Ride"] = 284.16, ["Neon"] = 234.94, ["Neon|Fly"] = 2412.62, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 488.25, ["Mega"] = 1063.18, ["Mega|Ride"] = 944.99, ["Mega|Fly|Ride"] = 879.38}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 15.65, ["Fly|Ride"] = 142.63, ["Neon"] = 5.06, ["Neon|Ride"] = 43.73, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 31.5, ["Mega|Ride"] = 142.63, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 28.74, ["Ride"] = 19.16, ["Fly|Ride"] = 59.07, ["Neon"] = 18.27, ["Neon|Ride"] = 28.55, ["Neon|Fly|Ride"] = 80.88, ["Mega"] = 257.25, ["Mega|Ride"] = 193.1, ["Mega|Fly|Ride"] = 283.1}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 52.5, ["Ride"] = 78.66, ["Fly|Ride"] = 229.86, ["Neon"] = 203.68, ["Neon|Ride"] = 262.5, ["Mega"] = 941.07, ["Mega|Ride"] = 1765.32, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 28.42, ["Neon"] = 6.45, ["Neon|Ride"] = 1419.69, ["Mega"] = 63, ["Mega|Ride"] = 110.06, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 3.7}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 21, ["Fly|Ride"] = 355.85, ["Neon"] = 7.07, ["Neon|Fly"] = 32.59, ["Neon|Ride"] = 41.52, ["Neon|Fly|Ride"] = 113.88, ["Mega"] = 46.69, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 126, ["Ride"] = 171.51, ["Fly|Ride"] = 355.46, ["Neon"] = 709.85, ["Neon|Ride"] = 541.71, ["Neon|Fly|Ride"] = 665.05, ["Mega"] = 3405.54, ["Mega|Ride"] = 3218.57, ["Mega|Fly|Ride"] = 2549.9}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 3.63, ["Ride"] = 36.33, ["Fly|Ride"] = 212.86, ["Neon"] = 20.48, ["Neon|Fly"] = 142.63, ["Neon|Ride"] = 103.47, ["Neon|Fly|Ride"] = 219.43, ["Mega"] = 169.46, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 99.56, ["Neon"] = 3.41, ["Neon|Ride"] = 21.09, ["Mega"] = 31.4, ["Mega|Ride"] = 57.48, ["Mega|Fly|Ride"] = 313.85}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 3.68, ["Ride"] = 25.93, ["Fly|Ride"] = 49.88, ["Neon"] = 54.34, ["Neon|Ride"] = 89.63, ["Neon|Fly|Ride"] = 153.55, ["Mega"] = 425.71, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 637.42}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 7.45, ["Fly"] = 50.24, ["Ride"] = 21.3, ["Fly|Ride"] = 56.73, ["Neon"] = 72.18, ["Neon|Ride"] = 157.76, ["Neon|Fly|Ride"] = 309.1, ["Mega"] = 626.07, ["Mega|Ride"] = 448.94, ["Mega|Fly|Ride"] = 482.73}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 18.04, ["Ride"] = 58.95, ["Fly|Ride"] = 91.88, ["Neon"] = 141.31, ["Neon|Ride"] = 180.36, ["Neon|Fly|Ride"] = 1575, ["Mega"] = 539.58, ["Mega|Ride"] = 489.65, ["Mega|Fly|Ride"] = 599.81}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 120.94, ["Fly"] = 196.77, ["Ride"] = 181.54, ["Fly|Ride"] = 183.75, ["Neon"] = 555.43, ["Neon|Fly"] = 684.14, ["Neon|Ride"] = 651.69, ["Neon|Fly|Ride"] = 542.12, ["Mega|Ride"] = 2554.16, ["Mega|Fly|Ride"] = 3238.49}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 8.52, ["Fly"] = 19.18, ["Ride"] = 16.7, ["Fly|Ride"] = 34.89, ["Neon"] = 39.38, ["Neon|Fly"] = 155.74, ["Neon|Ride"] = 39.05, ["Neon|Fly|Ride"] = 78.56, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.88, ["Fly"] = 131.23, ["Ride"] = 16.94, ["Fly|Ride"] = 131.24, ["Neon"] = 15.65, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 143.7, ["Mega|Ride"] = 166.04, ["Mega|Fly|Ride"] = 421.45}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 4.66, ["Fly"] = 41.5, ["Ride"] = 28.04, ["Fly|Ride"] = 127.73, ["Neon"] = 113.89, ["Neon|Fly"] = 128.63, ["Neon|Ride"] = 41.81, ["Neon|Fly|Ride"] = 160.72, ["Mega"] = 420, ["Mega|Ride"] = 428.9, ["Mega|Fly|Ride"] = 971.25}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 42.84, ["Fly"] = 100.05, ["Ride"] = 70.6, ["Fly|Ride"] = 168.16, ["Neon"] = 210, ["Neon|Ride"] = 195.14, ["Neon|Fly|Ride"] = 261.19, ["Mega"] = 954.19, ["Mega|Ride"] = 925.32, ["Mega|Fly|Ride"] = 1120.24}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 19.65, ["Fly"] = 57.75, ["Ride"] = 63.88, ["Neon"] = 111.57, ["Neon|Ride"] = 189.83, ["Neon|Fly|Ride"] = 469.34, ["Mega"] = 1050, ["Mega|Ride"] = 1661.4, ["Mega|Fly|Ride"] = 836.73}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 327.47, ["Ride"] = 568.31, ["Neon|Ride"] = 3218.57}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 13.01, ["Fly"] = 49.54, ["Ride"] = 26.24, ["Fly|Ride"] = 57.48, ["Neon"] = 248.07, ["Neon|Ride"] = 158.04, ["Neon|Fly|Ride"] = 266.73, ["Mega"] = 761.25, ["Mega|Ride"] = 734.9, ["Mega|Fly|Ride"] = 994}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 41.1, ["Ride"] = 13.34, ["Fly|Ride"] = 43.31, ["Neon"] = 2.1, ["Neon|Fly"] = 21.6, ["Neon|Ride"] = 16.55, ["Neon|Fly|Ride"] = 52.41, ["Mega"] = 21.95, ["Mega|Fly"] = 110.71, ["Mega|Ride"] = 39.26, ["Mega|Fly|Ride"] = 112.88}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 5.25, ["Neon"] = 7.21, ["Neon|Ride"] = 42.28, ["Neon|Fly|Ride"] = 142.63, ["Mega"] = 94.96, ["Mega|Ride"] = 164.17, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 25.99, ["Fly|Ride"] = 125.58, ["Neon"] = 12.5, ["Neon|Fly"] = 87.94, ["Neon|Ride"] = 48.44, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 129.6, ["Mega|Fly"] = 497, ["Mega|Ride"] = 129.93, ["Mega|Fly|Ride"] = 319.29}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 393.73, ["Fly"] = 497, ["Ride"] = 428.93, ["Fly|Ride"] = 510.97, ["Neon"] = 1898.49, ["Neon|Ride"] = 2092.6, ["Neon|Fly|Ride"] = 1246.88, ["Mega|Fly|Ride"] = 5435.01}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.1, ["Fly"] = 37.97, ["Ride"] = 15.74, ["Fly|Ride"] = 43.65, ["Neon"] = 16.93, ["Neon|Ride"] = 28.71, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 183.54, ["Mega|Ride"] = 213.94, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 5.1, ["Fly"] = 21.3, ["Ride"] = 15.89, ["Fly|Ride"] = 39.38, ["Neon"] = 19.08, ["Neon|Fly"] = 33.01, ["Neon|Ride"] = 59.61, ["Neon|Fly|Ride"] = 105.72, ["Mega"] = 129.14, ["Mega|Ride"] = 284.16, ["Mega|Fly|Ride"] = 276.94}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 3.62, ["Fly"] = 41.91, ["Ride"] = 21.48, ["Fly|Ride"] = 61.24, ["Neon"] = 13, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 100.05, ["Mega"] = 110.25, ["Mega|Ride"] = 284.16, ["Mega|Fly|Ride"] = 236.22}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 24.05, ["Fly"] = 47.84, ["Ride"] = 32.81, ["Fly|Ride"] = 65.63, ["Neon"] = 220.4, ["Neon|Ride"] = 196.85, ["Neon|Fly|Ride"] = 318.22, ["Mega"] = 709.85, ["Mega|Ride"] = 850.33, ["Mega|Fly|Ride"] = 602.44}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 53.23, ["Ride"] = 34.12, ["Fly|Ride"] = 51.85, ["Neon"] = 11.47, ["Neon|Ride"] = 32.6, ["Neon|Fly|Ride"] = 210, ["Mega"] = 163.74, ["Mega|Ride"] = 457.8, ["Mega|Fly|Ride"] = 1011.29}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 7.07, ["Fly"] = 65.6, ["Ride"] = 28.55, ["Fly|Ride"] = 72.17, ["Neon"] = 160.19, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 355.46, ["Mega|Fly|Ride"] = 1066.36}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 14.91, ["Neon"] = 3.83, ["Neon|Ride"] = 142.63, ["Mega"] = 51.1, ["Mega|Ride"] = 120.27, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 2.78, ["Ride"] = 142.63, ["Neon"] = 48.56, ["Mega"] = 367.5, ["Mega|Ride"] = 322.23, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 5.93, ["Ride"] = 76.63, ["Neon"] = 93.66, ["Neon|Ride"] = 284.16, ["Neon|Fly|Ride"] = 178.81, ["Mega"] = 297.99, ["Mega|Ride"] = 553.25, ["Mega|Fly|Ride"] = 463.32}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 5.15, ["Fly"] = 26.01, ["Ride"] = 20.6, ["Fly|Ride"] = 48.86, ["Neon"] = 36.2, ["Neon|Fly"] = 113.89, ["Neon|Ride"] = 52.4, ["Neon|Fly|Ride"] = 103.93, ["Mega"] = 567.2, ["Mega|Ride"] = 313.95, ["Mega|Fly|Ride"] = 363.29}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 334.69, ["Fly"] = 515.06, ["Ride"] = 429.85, ["Fly|Ride"] = 429.09, ["Neon"] = 1642.41, ["Neon|Ride"] = 1743.52, ["Neon|Fly|Ride"] = 1860.28}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 15.65, ["Fly|Ride"] = 39.38, ["Neon"] = 15.65, ["Neon|Fly"] = 80.85, ["Neon|Ride"] = 32.28, ["Neon|Fly|Ride"] = 158.17, ["Mega"] = 227.76, ["Mega|Ride"] = 196.77, ["Mega|Fly|Ride"] = 302.92}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 3.52, ["Ride"] = 51.43, ["Fly|Ride"] = 164.07, ["Neon"] = 39.38, ["Neon|Ride"] = 122.03, ["Neon|Fly|Ride"] = 185.19, ["Mega"] = 389.62, ["Mega|Fly"] = 709.85, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 531.06}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 16.1, ["Fly"] = 118.13, ["Ride"] = 79.24, ["Fly|Ride"] = 293.9, ["Neon"] = 88.05, ["Neon|Ride"] = 123.44, ["Neon|Fly|Ride"] = 424.64, ["Mega"] = 303.74, ["Mega|Ride"] = 357, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 49.26, ["Fly"] = 146.86, ["Ride"] = 65.63, ["Fly|Ride"] = 91.88, ["Neon"] = 320.25, ["Neon|Ride"] = 334.69, ["Neon|Fly|Ride"] = 380.63, ["Mega"] = 2492.09, ["Mega|Ride"] = 1348.39, ["Mega|Fly|Ride"] = 1561.82}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 7.48, ["Fly"] = 106.45, ["Ride"] = 37.16, ["Fly|Ride"] = 131.24, ["Neon"] = 32.82, ["Neon|Ride"] = 89.15, ["Neon|Fly|Ride"] = 227.76, ["Mega"] = 168, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 346.49}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 17.05, ["Ride"] = 19.59, ["Fly|Ride"] = 58.46, ["Neon"] = 17.46, ["Neon|Ride"] = 33.5, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 65.62, ["Mega|Ride"] = 176.21, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 3.74, ["Ride"] = 32.82, ["Neon"] = 19.09, ["Neon|Ride"] = 105.84, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 112.48, ["Mega|Ride"] = 284.16, ["Mega|Fly|Ride"] = 285.48}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 40.24, ["Fly"] = 137.8, ["Ride"] = 81.38, ["Fly|Ride"] = 131.25, ["Neon"] = 101.07, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 233.88, ["Mega"] = 417.71, ["Mega|Ride"] = 432.64, ["Mega|Fly|Ride"] = 540.75}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.63, ["Ride"] = 131.25, ["Neon"] = 6.24, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 236.24, ["Mega"] = 49.17, ["Mega|Fly"] = 199.03, ["Mega|Ride"] = 159.83, ["Mega|Fly|Ride"] = 272.99}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 19.57, ["Ride"] = 65.63, ["Neon"] = 157.52, ["Neon|Ride"] = 401.03, ["Neon|Fly|Ride"] = 851.4, ["Mega"] = 572.25, ["Mega|Fly|Ride"] = 680.06}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 892.4, ["Fly"] = 1004.07, ["Ride"] = 918.75, ["Fly|Ride"] = 1063.13, ["Neon"] = 3384.26, ["Neon|Ride"] = 3401.28, ["Neon|Fly|Ride"] = 3281.25, ["Mega|Fly|Ride"] = 10075.05}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 10.21, ["Fly"] = 108.51, ["Ride"] = 36.2, ["Fly|Ride"] = 173.25, ["Neon"] = 64.22, ["Neon|Fly"] = 708.79, ["Neon|Ride"] = 193.1, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 337.92, ["Mega|Ride"] = 328.27, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.1, ["Fly"] = 49.37, ["Ride"] = 19.71, ["Fly|Ride"] = 90.55, ["Neon"] = 9.76, ["Neon|Ride"] = 29.64, ["Neon|Fly|Ride"] = 89.35, ["Mega"] = 70.7, ["Mega|Ride"] = 80.06, ["Mega|Fly|Ride"] = 193.1}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 7.38, ["Ride"] = 58.97, ["Fly|Ride"] = 142.63, ["Neon"] = 57.68, ["Neon|Fly"] = 84.09, ["Neon|Ride"] = 28.74, ["Neon|Fly|Ride"] = 393.73, ["Mega"] = 266.07, ["Mega|Ride"] = 411.75, ["Mega|Fly|Ride"] = 273.96}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 24.5, ["Fly|Ride"] = 185.19, ["Neon"] = 2.1, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 100.05, ["Mega"] = 16.59, ["Mega|Ride"] = 42.19, ["Mega|Fly|Ride"] = 142.42}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 42.33, ["Fly"] = 111.46, ["Ride"] = 98.33, ["Fly|Ride"] = 229.69, ["Neon"] = 223.12, ["Neon|Ride"] = 243.14, ["Neon|Fly|Ride"] = 393.67, ["Mega"] = 1052.19, ["Mega|Ride"] = 763.35, ["Mega|Fly|Ride"] = 913.24}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 10.28, ["Ride"] = 52.5, ["Fly|Ride"] = 278.21, ["Neon"] = 84.96, ["Neon|Ride"] = 328.12, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 418.69, ["Mega|Ride"] = 774.78, ["Mega|Fly|Ride"] = 709.85}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2.1, ["Ride"] = 19.68, ["Neon"] = 7.8, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 212.86, ["Mega"] = 91.55, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 476.79}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 9.86, ["Fly"] = 52.5, ["Ride"] = 35.62, ["Fly|Ride"] = 112.83, ["Neon"] = 51.08, ["Neon|Ride"] = 86.16, ["Neon|Fly|Ride"] = 255.43, ["Mega"] = 409.17, ["Mega|Ride"] = 383.14, ["Mega|Fly|Ride"] = 391.13}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 5.5, ["Fly"] = 95.8, ["Ride"] = 26.25, ["Fly|Ride"] = 73.5, ["Neon"] = 68.8, ["Neon|Ride"] = 64.31, ["Neon|Fly|Ride"] = 144.18, ["Mega"] = 367.44, ["Mega|Ride"] = 217.24, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 22.32, ["Ride"] = 91.88, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 735, ["Mega"] = 2128.47, ["Mega|Ride"] = 2413.62, ["Mega|Fly|Ride"] = 1841.14}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 3.73, ["Fly|Ride"] = 184.11, ["Neon"] = 13.8, ["Neon|Ride"] = 84.96, ["Neon|Fly|Ride"] = 170.26, ["Mega"] = 85.22, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 227.06}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 6.07, ["Fly"] = 27.68, ["Ride"] = 16.94, ["Fly|Ride"] = 48.27, ["Neon"] = 33.73, ["Neon|Fly"] = 185.19, ["Neon|Ride"] = 60.06, ["Neon|Fly|Ride"] = 91.77, ["Mega"] = 280.51, ["Mega|Ride"] = 351.75, ["Mega|Fly|Ride"] = 681.13}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 104.9, ["Fly"] = 393.75, ["Ride"] = 160.3, ["Fly|Ride"] = 236.25, ["Neon"] = 433.13, ["Neon|Fly"] = 538.13, ["Neon|Ride"] = 457.7, ["Neon|Fly|Ride"] = 646, ["Mega|Ride"] = 2292.94, ["Mega|Fly|Ride"] = 1965.46}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 24.93, ["Ride"] = 14.44, ["Fly|Ride"] = 31.47, ["Neon"] = 10.9, ["Neon|Fly"] = 57.32, ["Neon|Ride"] = 27.46, ["Neon|Fly|Ride"] = 53.99, ["Mega"] = 145.69, ["Mega|Ride"] = 239.49, ["Mega|Fly|Ride"] = 206.46}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 12.22, ["Fly"] = 200.81, ["Ride"] = 26.25, ["Fly|Ride"] = 91.88, ["Neon"] = 69.01, ["Neon|Ride"] = 106.1, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 452.82, ["Mega|Ride"] = 498.74, ["Mega|Fly|Ride"] = 566.19}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 18.27, ["Ride"] = 11.9, ["Fly|Ride"] = 52.48, ["Neon"] = 2.1, ["Neon|Fly"] = 27.83, ["Neon|Ride"] = 16.59, ["Neon|Fly|Ride"] = 44.42, ["Mega"] = 12.98, ["Mega|Fly"] = 50.7, ["Mega|Ride"] = 35.27, ["Mega|Fly|Ride"] = 78.78}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 57.48, ["Fly|Ride"] = 39.38, ["Neon"] = 2.1, ["Neon|Ride"] = 42.58, ["Neon|Fly|Ride"] = 127.73, ["Mega"] = 19.68, ["Mega|Fly"] = 118.11, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 169.25}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.1, ["Fly"] = 36.2, ["Ride"] = 18.5, ["Fly|Ride"] = 173.25, ["Neon"] = 9.45, ["Neon|Ride"] = 55.54, ["Neon|Fly|Ride"] = 100.05, ["Mega"] = 85.32, ["Mega|Ride"] = 283.1, ["Mega|Fly|Ride"] = 246.1}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 28.52, ["Ride"] = 59.07, ["Fly|Ride"] = 131.25, ["Neon"] = 128.61, ["Neon|Ride"] = 340.57, ["Neon|Fly|Ride"] = 433.13, ["Mega"] = 497, ["Mega|Ride"] = 636.42}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.1, ["Fly"] = 16.76, ["Ride"] = 14.33, ["Fly|Ride"] = 33.49, ["Neon"] = 9.24, ["Neon|Fly"] = 32.95, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 52.41, ["Mega"] = 98.06, ["Mega|Fly"] = 170.63, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 160.3}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 3.4, ["Fly"] = 25.99, ["Ride"] = 31.5, ["Fly|Ride"] = 104.81, ["Neon"] = 23.58, ["Neon|Fly"] = 71.9, ["Neon|Ride"] = 42.58, ["Neon|Fly|Ride"] = 89.82, ["Mega"] = 233.52, ["Mega|Fly"] = 433.13, ["Mega|Ride"] = 170.85, ["Mega|Fly|Ride"] = 313.16}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Fly"] = 27.68, ["Ride"] = 18.11, ["Fly|Ride"] = 67.92, ["Neon"] = 9.16, ["Neon|Fly"] = 98.43, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 89.24, ["Mega"] = 54.33, ["Mega|Fly"] = 80.88, ["Mega|Ride"] = 58.47, ["Mega|Fly|Ride"] = 126.74}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 6.46, ["Ride"] = 23.39, ["Fly|Ride"] = 217.19, ["Neon"] = 38.06, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 284.16, ["Mega"] = 267.16, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 383.14, ["Mega|Fly|Ride"] = 398.04}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 3.68, ["Ride"] = 157.5, ["Fly|Ride"] = 104, ["Neon"] = 50.56, ["Neon|Ride"] = 144.38, ["Mega"] = 356.53, ["Mega|Ride"] = 303.19, ["Mega|Fly|Ride"] = 994}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 30.85, ["Ride"] = 15.75, ["Fly|Ride"] = 49.71, ["Neon"] = 26.16, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 39.45, ["Neon|Fly|Ride"] = 161.21, ["Mega"] = 262.5, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 259.17, ["Mega|Fly|Ride"] = 568.31}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 24.75, ["Ride"] = 14.85, ["Fly|Ride"] = 52.41, ["Neon"] = 10.8, ["Neon|Fly"] = 70.51, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 136.49, ["Mega|Ride"] = 102.37, ["Mega|Fly|Ride"] = 91.88}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 204.75, ["Fly"] = 393.75, ["Ride"] = 262.5, ["Fly|Ride"] = 392.43, ["Neon"] = 1247.29, ["Neon|Ride"] = 1230.96, ["Neon|Fly|Ride"] = 1174.69, ["Mega"] = 4183.99, ["Mega|Fly|Ride"] = 4507.42}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 3.83, ["Ride"] = 65.63, ["Neon"] = 21, ["Neon|Ride"] = 142.63, ["Neon|Fly|Ride"] = 425.71, ["Mega"] = 106.44, ["Mega|Ride"] = 638.67, ["Mega|Fly|Ride"] = 355.46}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 2.1, ["Fly"] = 106.36, ["Ride"] = 24.18, ["Fly|Ride"] = 85.15, ["Neon"] = 24.24, ["Neon|Fly"] = 241.6, ["Neon|Ride"] = 59.61, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 227.75, ["Mega|Ride"] = 194.9, ["Mega|Fly|Ride"] = 524.98}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 2.56, ["Fly|Ride"] = 212.89, ["Neon"] = 37.06, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 603.74, ["Mega"] = 479.73, ["Mega|Ride"] = 401.89, ["Mega|Fly|Ride"] = 572.03}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.42, ["Fly|Ride"] = 32.34, ["Neon"] = 2.63, ["Neon|Fly"] = 42.58, ["Neon|Ride"] = 17.05, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 18.21, ["Mega|Fly"] = 78.77, ["Mega|Ride"] = 41.91, ["Mega|Fly|Ride"] = 72.19}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.1, ["Fly"] = 42.54, ["Ride"] = 17.74, ["Fly|Ride"] = 45.87, ["Neon"] = 13.94, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 82.67, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 213.84}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.1, ["Ride"] = 119.85, ["Neon"] = 8.56, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 44.35, ["Mega|Ride"] = 129.83, ["Mega|Fly|Ride"] = 255.43}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 72.17, ["Fly"] = 93.19, ["Ride"] = 78.74, ["Fly|Ride"] = 170.63, ["Neon"] = 393.75, ["Neon|Fly"] = 476.61, ["Neon|Ride"] = 409.49, ["Neon|Fly|Ride"] = 425.71, ["Mega|Ride"] = 3549.21, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 2.88, ["Fly"] = 71.32, ["Ride"] = 26.24, ["Fly|Ride"] = 141.73, ["Neon"] = 27.57, ["Neon|Ride"] = 66.94, ["Mega"] = 168, ["Mega|Ride"] = 220.43, ["Mega|Fly|Ride"] = 355.46}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 48.98, ["Ride"] = 34.12, ["Neon"] = 5.97, ["Neon|Ride"] = 80.88, ["Neon|Fly|Ride"] = 537.86, ["Mega"] = 66.94, ["Mega|Fly"] = 314.99, ["Mega|Ride"] = 125.9, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 44.58, ["Fly"] = 161.7, ["Ride"] = 68.25, ["Fly|Ride"] = 185.08, ["Neon"] = 136.5, ["Neon|Ride"] = 162.56, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 538.12, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 28.74, ["Ride"] = 13.73, ["Fly|Ride"] = 33.18, ["Neon"] = 2.1, ["Neon|Fly"] = 16.94, ["Neon|Ride"] = 15.58, ["Neon|Fly|Ride"] = 28.74, ["Mega"] = 19.59, ["Mega|Fly"] = 45.49, ["Mega|Ride"] = 31.5, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 33.38, ["Neon"] = 3.68, ["Neon|Ride"] = 30.09, ["Neon|Fly|Ride"] = 285.33, ["Mega"] = 22.2, ["Mega|Ride"] = 78.63, ["Mega|Fly|Ride"] = 180.89}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.52, ["Ride"] = 47.85, ["Neon"] = 6.46, ["Neon|Ride"] = 108.94, ["Neon|Fly|Ride"] = 142.63, ["Mega"] = 59.05, ["Mega|Fly"] = 185.19, ["Mega|Ride"] = 114.75, ["Mega|Fly|Ride"] = 170.29}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 7.12, ["Fly"] = 89.31, ["Ride"] = 48.47, ["Fly|Ride"] = 128.35, ["Neon"] = 19.68, ["Neon|Fly"] = 135.18, ["Neon|Ride"] = 80.88, ["Neon|Fly|Ride"] = 157.81, ["Mega"] = 100.05, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 179.45, ["Mega|Fly|Ride"] = 278.81}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 20.89, ["Ride"] = 14.22, ["Fly|Ride"] = 21.3, ["Neon"] = 2.1, ["Neon|Fly"] = 24.5, ["Neon|Ride"] = 27.37, ["Neon|Fly|Ride"] = 44.54, ["Mega"] = 17.07, ["Mega|Ride"] = 63.88, ["Mega|Fly|Ride"] = 78.66}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 18.58, ["Ride"] = 52.49, ["Neon"] = 71.33, ["Neon|Fly"] = 425.71, ["Neon|Ride"] = 202.57, ["Neon|Fly|Ride"] = 1312.5, ["Mega"] = 505.52, ["Mega|Ride"] = 590.62, ["Mega|Fly|Ride"] = 718.36}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2554.16, ["Fly"] = 2751.19, ["Ride"] = 2425.5, ["Fly|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 7415.63, ["Mega|Fly|Ride"] = 44165.42}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 17.04, ["Ride"] = 15.39, ["Fly|Ride"] = 36.2, ["Neon"] = 6.34, ["Neon|Fly"] = 34.13, ["Neon|Ride"] = 20.79, ["Neon|Fly|Ride"] = 50.04, ["Mega"] = 70.75, ["Mega|Fly"] = 425.71, ["Mega|Ride"] = 89.4, ["Mega|Fly|Ride"] = 141.74}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.1, ["Neon"] = 8.71, ["Mega"] = 107.01, ["Mega|Fly"] = 441, ["Mega|Ride"] = 161.73, ["Mega|Fly|Ride"] = 425.71}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 10.18, ["Fly"] = 142.63, ["Ride"] = 25.37, ["Fly|Ride"] = 120.67, ["Neon"] = 79.25, ["Neon|Ride"] = 99.75, ["Neon|Fly|Ride"] = 212.86, ["Mega"] = 472.5, ["Mega|Ride"] = 399, ["Mega|Fly|Ride"] = 439.69}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 25.46, ["Fly"] = 106.44, ["Ride"] = 64.2, ["Neon"] = 187.69, ["Neon|Ride"] = 190.32, ["Mega"] = 485.59, ["Mega|Ride"] = 603.43, ["Mega|Fly|Ride"] = 701.34}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 136.13, ["Fly"] = 212.86, ["Ride"] = 157.26, ["Fly|Ride"] = 249.64, ["Neon"] = 1312.5, ["Neon|Ride"] = 709.85, ["Neon|Fly|Ride"] = 780.94, ["Mega"] = 6385.38, ["Mega|Fly|Ride"] = 3895.1}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 7.21, ["Ride"] = 65.54, ["Fly|Ride"] = 675.94, ["Neon"] = 19.69, ["Neon|Ride"] = 85.15, ["Mega"] = 144.45, ["Mega|Fly|Ride"] = 383.14}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 36.2, ["Neon"] = 12.91, ["Neon|Ride"] = 114.85, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 245.44, ["Mega|Ride"] = 333.27, ["Mega|Fly|Ride"] = 267.09}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Fly"] = 100.05, ["Ride"] = 28.86, ["Fly|Ride"] = 131.25, ["Neon"] = 7.3, ["Neon|Fly"] = 106.44, ["Neon|Ride"] = 24.93, ["Neon|Fly|Ride"] = 210.73, ["Mega"] = 63, ["Mega|Ride"] = 106.44, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 13.06, ["Ride"] = 50.74, ["Fly|Ride"] = 131.25, ["Neon"] = 98.44, ["Neon|Ride"] = 176.21, ["Neon|Fly|Ride"] = 501.26, ["Mega"] = 386.19, ["Mega|Ride"] = 475.12, ["Mega|Fly|Ride"] = 584.73}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 48.28, ["Mega"] = 20.14, ["Mega|Fly"] = 120.7, ["Mega|Ride"] = 79.97, ["Mega|Fly|Ride"] = 134.54}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 89.12, ["Fly"] = 142.63, ["Ride"] = 104.98, ["Fly|Ride"] = 94.5, ["Neon"] = 346.5, ["Neon|Fly"] = 455.51, ["Neon|Ride"] = 411.88, ["Neon|Fly|Ride"] = 358.63, ["Mega"] = 3192.7, ["Mega|Fly|Ride"] = 1866.94}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Fly"] = 28.74, ["Ride"] = 91.83, ["Fly|Ride"] = 51.19, ["Neon"] = 3.36, ["Neon|Ride"] = 142.63, ["Neon|Fly|Ride"] = 212.86, ["Mega"] = 70.88, ["Mega|Ride"] = 283.1, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 35.53, ["Fly"] = 225.66, ["Ride"] = 74.46, ["Fly|Ride"] = 279.9, ["Neon"] = 255.94, ["Neon|Ride"] = 294, ["Neon|Fly|Ride"] = 451.36, ["Mega"] = 2625, ["Mega|Ride"] = 1702.78, ["Mega|Fly|Ride"] = 1843.26}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 21.19, ["Fly|Ride"] = 51.65, ["Neon"] = 5.04, ["Neon|Fly"] = 84.48, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 83.99, ["Mega"] = 45.69, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 143.66}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Neon"] = 9.11, ["Neon|Ride"] = 98.44, ["Mega"] = 49.62, ["Mega|Ride"] = 287.36, ["Mega|Fly|Ride"] = 425.71}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 5.23, ["Fly"] = 77.43, ["Ride"] = 28.71, ["Fly|Ride"] = 142.63, ["Neon"] = 22.97, ["Neon|Ride"] = 72.45, ["Neon|Fly|Ride"] = 142.63, ["Mega"] = 370.51, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 566.19}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 262.5, ["Ride"] = 413.85, ["Fly|Ride"] = 492.19, ["Neon"] = 1001.83, ["Neon|Ride"] = 980.42, ["Neon|Fly|Ride"] = 1076.25, ["Mega"] = 3264, ["Mega|Ride"] = 2691.75, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 18.8, ["Fly"] = 57.48, ["Ride"] = 31.5, ["Fly|Ride"] = 131.25, ["Neon"] = 183.75, ["Neon|Ride"] = 232.02, ["Neon|Fly|Ride"] = 255.84, ["Mega|Ride"] = 1128.09, ["Mega|Fly|Ride"] = 1702.78}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 47.38, ["Ride"] = 16.1, ["Fly|Ride"] = 111.57, ["Neon"] = 13.12, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 28.8, ["Neon|Fly|Ride"] = 105, ["Mega"] = 128.55, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 314.9}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 14.44, ["Fly"] = 78.66, ["Ride"] = 52.41, ["Fly|Ride"] = 170.63, ["Neon"] = 68.25, ["Neon|Fly"] = 161.69, ["Neon|Ride"] = 145.58, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 287.44, ["Mega|Fly"] = 425.71, ["Mega|Ride"] = 283.5, ["Mega|Fly|Ride"] = 322.23}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 5.91, ["Ride"] = 31.83, ["Neon"] = 91.88, ["Neon|Ride"] = 122.06, ["Neon|Fly|Ride"] = 255.43, ["Mega"] = 1135.54, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 425.71}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.5, ["Ride"] = 15.99, ["Neon"] = 20.9, ["Mega"] = 91.88, ["Mega|Ride"] = 330.68, ["Mega|Fly|Ride"] = 411.88}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.1, ["Fly"] = 71.32, ["Ride"] = 14.38, ["Fly|Ride"] = 65.51, ["Neon"] = 38.98, ["Neon|Fly"] = 79.84, ["Neon|Ride"] = 50.16, ["Mega"] = 160.13, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 84.33, ["Fly"] = 225.66, ["Ride"] = 105, ["Fly|Ride"] = 161.69, ["Neon"] = 794.99, ["Neon|Ride"] = 523.68, ["Neon|Fly|Ride"] = 568.31, ["Mega"] = 2887.5, ["Mega|Ride"] = 2625, ["Mega|Fly|Ride"] = 3218.57}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 23.4, ["Ride"] = 38.98, ["Fly|Ride"] = 91.88, ["Neon"] = 154.88, ["Neon|Ride"] = 235.2, ["Neon|Fly|Ride"] = 284.16, ["Mega"] = 709.85, ["Mega|Ride"] = 731.14, ["Mega|Fly|Ride"] = 731.07}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 1780.94, ["Fly"] = 2058.97, ["Ride"] = 2034.38, ["Fly|Ride"] = 2040.93, ["Neon"] = 11352.11, ["Neon|Fly|Ride"] = 7019.25, ["Mega|Fly|Ride"] = 22311.19}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 3.76, ["Fly"] = 65625, ["Ride"] = 18.38, ["Fly|Ride"] = 196.87, ["Neon"] = 13.32, ["Mega"] = 115.31, ["Mega|Fly"] = 786.19, ["Mega|Ride"] = 186.84, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 4.73, ["Ride"] = 40.69, ["Fly|Ride"] = 131.25, ["Neon"] = 30.24, ["Neon|Ride"] = 83.34, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 145.68, ["Mega|Fly"] = 270.34, ["Mega|Ride"] = 225.63, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 826.87, ["Fly"] = 1476.09, ["Ride"] = 822.94, ["Fly|Ride"] = 866.15, ["Neon"] = 2778.57, ["Neon|Ride"] = 2480.8, ["Neon|Fly|Ride"] = 2420.7, ["Mega|Fly|Ride"] = 11424.82}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 24.86, ["Ride"] = 50.68, ["Fly|Ride"] = 173.35, ["Neon"] = 212.86, ["Neon|Ride"] = 226.31, ["Neon|Fly|Ride"] = 369.3, ["Mega"] = 840.96, ["Mega|Ride"] = 705.6, ["Mega|Fly|Ride"] = 787.54}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 2.1, ["Ride"] = 23.42, ["Fly|Ride"] = 127.98, ["Neon"] = 6.65, ["Neon|Ride"] = 42.58, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 157.5, ["Mega|Ride"] = 322.23, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 142.63, ["Neon"] = 5.19, ["Neon|Ride"] = 49.26, ["Neon|Fly|Ride"] = 104.31, ["Mega"] = 22.2, ["Mega|Ride"] = 61.31, ["Mega|Fly|Ride"] = 157.4}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 78.69, ["Ride"] = 130.69, ["Fly|Ride"] = 170.63, ["Neon"] = 459.38, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 634.3, ["Mega"] = 2413.62, ["Mega|Fly|Ride"] = 2128.47}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 2.1, ["Ride"] = 33.67, ["Fly|Ride"] = 73.64, ["Neon"] = 10.17, ["Neon|Ride"] = 47.96, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 109.28, ["Mega|Ride"] = 122.05, ["Mega|Fly|Ride"] = 263.82}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 65.63, ["Fly"] = 106.44, ["Ride"] = 126, ["Fly|Ride"] = 241.6, ["Neon"] = 425.71, ["Neon|Ride"] = 560.86, ["Mega|Fly|Ride"] = 1740.22}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 7.02, ["Fly"] = 105, ["Fly|Ride"] = 127.73, ["Neon"] = 35.35, ["Neon|Fly|Ride"] = 142.63, ["Mega"] = 328.02, ["Mega|Ride"] = 196.88}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 229.69, ["Ride"] = 287.68, ["Fly|Ride"] = 308.44, ["Neon"] = 1137.32, ["Neon|Ride"] = 1064.24, ["Neon|Fly|Ride"] = 879.16, ["Mega|Fly|Ride"] = 3899.56}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 2.63, ["Fly"] = 91.88, ["Ride"] = 17.05, ["Fly|Ride"] = 32.59, ["Neon"] = 20.68, ["Neon|Ride"] = 57.75, ["Neon|Fly|Ride"] = 112.88, ["Mega"] = 322.23, ["Mega|Ride"] = 220.42, ["Mega|Fly|Ride"] = 267.75}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 17.97, ["Ride"] = 15.07, ["Fly|Ride"] = 33.28, ["Neon"] = 3.56, ["Neon|Fly"] = 37.96, ["Neon|Ride"] = 23.62, ["Neon|Fly|Ride"] = 57.47, ["Mega"] = 42.2, ["Mega|Ride"] = 68.25, ["Mega|Fly|Ride"] = 115.49}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 1273.21, ["Ride"] = 1050, ["Fly|Ride"] = 1254.2, ["Neon|Ride"] = 7805.04, ["Neon|Fly|Ride"] = 6598.23, ["Mega"] = 24136.07, ["Mega|Fly|Ride"] = 28379.75}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 7.97, ["Fly"] = 284.16, ["Ride"] = 72.19, ["Neon"] = 78.75, ["Neon|Ride"] = 129.14, ["Mega"] = 244.59, ["Mega|Ride"] = 284.16, ["Mega|Fly|Ride"] = 564.27}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 5.81, ["Fly"] = 39.38, ["Ride"] = 31.5, ["Fly|Ride"] = 123.52, ["Neon"] = 20.14, ["Neon|Fly"] = 284.16, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 102.38, ["Mega"] = 140.6, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 303.19}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 31.4, ["Fly"] = 35.42, ["Ride"] = 26.25, ["Fly|Ride"] = 56.6, ["Neon"] = 425.71, ["Neon|Ride"] = 209.99, ["Neon|Fly|Ride"] = 212.62, ["Mega"] = 2554.16, ["Mega|Ride"] = 1127.18, ["Mega|Fly|Ride"] = 799.32}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 12.69, ["Fly"] = 70.25, ["Ride"] = 31.5, ["Fly|Ride"] = 78.75, ["Neon"] = 58.46, ["Neon|Ride"] = 80.99, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 367.5, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 429.8}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 49.38, ["Ride"] = 87.94, ["Fly|Ride"] = 497, ["Neon"] = 208.59, ["Neon|Fly"] = 318.22, ["Neon|Ride"] = 266.07, ["Neon|Fly|Ride"] = 411.88, ["Mega"] = 1021.68, ["Mega|Ride"] = 919.51, ["Mega|Fly|Ride"] = 952.5}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 116.61, ["Fly|Ride"] = 284.16, ["Neon"] = 3.63, ["Neon|Fly"] = 57.48, ["Neon|Ride"] = 113.46, ["Neon|Fly|Ride"] = 106.44, ["Mega"] = 15.88, ["Mega|Fly"] = 72.19, ["Mega|Ride"] = 142.63, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 76.06, ["Fly"] = 120.67, ["Ride"] = 85.15, ["Fly|Ride"] = 177.18, ["Neon"] = 425.87, ["Neon|Fly"] = 563.49, ["Neon|Ride"] = 322.53, ["Neon|Fly|Ride"] = 470, ["Mega"] = 3405.54, ["Mega|Fly|Ride"] = 1715.04}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.1, ["Fly"] = 107.62, ["Ride"] = 19.44, ["Fly|Ride"] = 66.68, ["Neon"] = 142.63, ["Neon|Ride"] = 95.95, ["Neon|Fly|Ride"] = 170.29, ["Mega"] = 773.07, ["Mega|Ride"] = 434.46, ["Mega|Fly|Ride"] = 490.88}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 28.74, ["Ride"] = 15.89, ["Fly|Ride"] = 38.16, ["Neon"] = 20.22, ["Neon|Fly"] = 80.85, ["Neon|Ride"] = 83.03, ["Neon|Fly|Ride"] = 122.85, ["Mega"] = 72408.2, ["Mega|Ride"] = 275.07, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 3.84, ["Ride"] = 126, ["Neon"] = 15.99, ["Neon|Fly"] = 140.49, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 202.21, ["Mega|Fly|Ride"] = 482.73}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 55.44, ["Ride"] = 196.77, ["Fly|Ride"] = 357.16, ["Neon"] = 366.19, ["Neon|Ride"] = 360.94, ["Neon|Fly|Ride"] = 727.13, ["Mega"] = 1825.17, ["Mega|Ride"] = 1488.87, ["Mega|Fly|Ride"] = 1378.13}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 3.41, ["Fly|Ride"] = 425.71, ["Neon"] = 18.59, ["Neon|Ride"] = 59.07, ["Mega"] = 126.88, ["Mega|Ride"] = 227.76, ["Mega|Fly|Ride"] = 279.86}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Fly"] = 21.3, ["Ride"] = 36.66, ["Neon"] = 2.1, ["Neon|Ride"] = 118.29, ["Neon|Fly|Ride"] = 71.32, ["Mega"] = 16.7, ["Mega|Ride"] = 194.28, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 102.92, ["Ride"] = 32.82, ["Fly|Ride"] = 142.63, ["Neon"] = 3.94, ["Neon|Fly"] = 86.2, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 19.39, ["Mega|Ride"] = 61.73, ["Mega|Fly|Ride"] = 137.17}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 24.5, ["Ride"] = 15.94, ["Fly|Ride"] = 52.41, ["Neon"] = 5.25, ["Neon|Ride"] = 24.69, ["Neon|Fly|Ride"] = 51.1, ["Mega"] = 61.69, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 179.7}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 113.89, ["Neon"] = 24.34, ["Neon|Ride"] = 65.63, ["Mega"] = 118.1, ["Mega|Ride"] = 106.3, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 38.07, ["Ride"] = 14.01, ["Fly|Ride"] = 35.64, ["Neon"] = 10.07, ["Neon|Fly"] = 212.79, ["Neon|Ride"] = 30.8, ["Neon|Fly|Ride"] = 99.05, ["Mega"] = 170.63, ["Mega|Ride"] = 138.64, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 53.81, ["Ride"] = 102.37, ["Fly|Ride"] = 284.16, ["Neon"] = 216.57, ["Neon|Ride"] = 324.07, ["Neon|Fly|Ride"] = 1064.24, ["Mega"] = 748.23, ["Mega|Ride"] = 850.33, ["Mega|Fly|Ride"] = 1064.24}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 16.69, ["Ride"] = 15.74, ["Fly|Ride"] = 43.19, ["Neon"] = 2.1, ["Neon|Fly"] = 17.05, ["Neon|Ride"] = 17.05, ["Neon|Fly|Ride"] = 50.04, ["Mega"] = 51.19, ["Mega|Ride"] = 131.08, ["Mega|Fly|Ride"] = 95.82}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 7.71, ["Fly"] = 27.68, ["Ride"] = 23.84, ["Fly|Ride"] = 75.31, ["Neon"] = 32.82, ["Neon|Fly"] = 91.76, ["Neon|Ride"] = 49.79, ["Neon|Fly|Ride"] = 98.31, ["Mega"] = 301.88, ["Mega|Fly"] = 332.06, ["Mega|Ride"] = 321.57, ["Mega|Fly|Ride"] = 311.07}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 14.01, ["Fly"] = 57.48, ["Ride"] = 39.38, ["Fly|Ride"] = 104.99, ["Neon"] = 142.63, ["Neon|Fly"] = 147, ["Neon|Ride"] = 115.5, ["Neon|Fly|Ride"] = 209.9, ["Mega"] = 787.5, ["Mega|Ride"] = 781.15, ["Mega|Fly|Ride"] = 584.73}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 3.47, ["Fly"] = 196.88, ["Neon"] = 74.8, ["Neon|Ride"] = 103.69, ["Mega"] = 420, ["Mega|Ride"] = 448.28, ["Mega|Fly|Ride"] = 539.58}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 19.28, ["Ride"] = 15.75, ["Fly|Ride"] = 38.33, ["Neon"] = 3.89, ["Neon|Fly"] = 28.1, ["Neon|Ride"] = 20.9, ["Neon|Fly|Ride"] = 64.32, ["Mega"] = 41.36, ["Mega|Ride"] = 48.57, ["Mega|Fly|Ride"] = 114.18}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 6.46, ["Fly"] = 39.37, ["Ride"] = 37.97, ["Fly|Ride"] = 57.23, ["Neon"] = 39.11, ["Neon|Ride"] = 127.73, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 196.88, ["Mega|Fly"] = 735, ["Mega|Ride"] = 301.87, ["Mega|Fly|Ride"] = 441.67}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 895.51, ["Fly"] = 1312.85, ["Ride"] = 979.12, ["Fly|Ride"] = 1026.31, ["Neon"] = 3073.51, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2218.11, ["Mega|Fly|Ride"] = 7199.06}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 142.63, ["Ride"] = 223.13, ["Fly|Ride"] = 636.41, ["Neon"] = 735.4, ["Neon|Ride"] = 853.13, ["Neon|Fly|Ride"] = 952.5, ["Mega"] = 3191.63, ["Mega|Ride"] = 3549.21, ["Mega|Fly|Ride"] = 2546.25}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Fly|Ride"] = 392.44, ["Neon"] = 6.37, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 254.37, ["Mega"] = 78.1, ["Mega|Fly|Ride"] = 1135.54}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 84.95, ["Ride"] = 170.29, ["Fly|Ride"] = 241.6, ["Neon"] = 461.27, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 744.98, ["Mega"] = 1967.44, ["Mega|Ride"] = 1915.62, ["Mega|Fly|Ride"] = 1861.59}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 2.1, ["Ride"] = 15.75, ["Fly|Ride"] = 98.44, ["Neon"] = 13.86, ["Neon|Fly"] = 56.74, ["Neon|Ride"] = 53.75, ["Neon|Fly|Ride"] = 284.16, ["Mega"] = 118.12, ["Mega|Ride"] = 170.29, ["Mega|Fly|Ride"] = 284.16}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 249.38, ["Fly"] = 425.71, ["Ride"] = 260.58, ["Fly|Ride"] = 354.38, ["Neon"] = 1170.67, ["Neon|Ride"] = 1372.87, ["Neon|Fly|Ride"] = 1467.51, ["Mega|Fly|Ride"] = 4966.76}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 77.18, ["Ride"] = 41.52, ["Fly|Ride"] = 216.16, ["Neon"] = 23.9, ["Neon|Ride"] = 54.37, ["Mega"] = 241.38, ["Mega|Fly"] = 356.53, ["Mega|Ride"] = 313.95}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Fly"] = 28.74, ["Ride"] = 19.18, ["Neon"] = 43.65, ["Mega"] = 164.07, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 17.75, ["Ride"] = 67.06, ["Fly|Ride"] = 153.25, ["Neon"] = 118.13, ["Neon|Fly"] = 425.71, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 241.38, ["Mega"] = 532.13, ["Mega|Ride"] = 590.66, ["Mega|Fly|Ride"] = 901.49}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 49.74, ["Neon"] = 31.85, ["Neon|Ride"] = 196.87, ["Mega"] = 241.38, ["Mega|Ride"] = 254.6, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 14.34, ["Ride"] = 14.32, ["Fly|Ride"] = 32.15, ["Neon"] = 2.1, ["Neon|Fly"] = 28.74, ["Neon|Ride"] = 19.68, ["Neon|Fly|Ride"] = 35.33, ["Mega"] = 23.42, ["Mega|Ride"] = 40.46, ["Mega|Fly|Ride"] = 65.18}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4724.9, ["Ride"] = 4461.19, ["Fly|Ride"] = 5250, ["Neon"] = 31926.81, ["Neon|Fly|Ride"] = 21135.56, ["Mega|Fly|Ride"] = 52500}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 7.54, ["Fly"] = 85.15, ["Ride"] = 41.91, ["Neon"] = 78.63, ["Neon|Ride"] = 106.32, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 178.5, ["Mega|Ride"] = 214.85, ["Mega|Fly|Ride"] = 411.88}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 24.7, ["Ride"] = 19.08, ["Fly|Ride"] = 42.58, ["Neon"] = 11.34, ["Neon|Fly"] = 42.58, ["Neon|Ride"] = 36.31, ["Neon|Fly|Ride"] = 91.87, ["Mega"] = 131.25, ["Mega|Ride"] = 123.05, ["Mega|Fly|Ride"] = 195.83}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 406.48, ["Fly"] = 547.77, ["Ride"] = 459.38, ["Fly|Ride"] = 538.12, ["Neon"] = 1611.25, ["Neon|Ride"] = 1292.82, ["Neon|Fly|Ride"] = 1339.8, ["Mega|Fly|Ride"] = 4873.32}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 3.35, ["Ride"] = 40.73, ["Neon"] = 13.85, ["Neon|Ride"] = 291.38, ["Mega"] = 143.88, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 693}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 2.1, ["Fly"] = 4255.85, ["Ride"] = 36.2, ["Neon"] = 31.95, ["Neon|Fly"] = 118.14, ["Neon|Ride"] = 65.18, ["Neon|Fly|Ride"] = 305.45, ["Mega"] = 424.64, ["Mega|Ride"] = 284.67, ["Mega|Fly|Ride"] = 497}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 50.96, ["Ride"] = 15.75, ["Fly|Ride"] = 48.27, ["Neon"] = 4.92, ["Neon|Fly"] = 124.69, ["Neon|Ride"] = 28.74, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 44.63, ["Mega|Ride"] = 68.41, ["Mega|Fly|Ride"] = 127.73}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 611.02, ["Ride"] = 612.92, ["Fly|Ride"] = 654.92, ["Neon|Ride"] = 2126.27, ["Neon|Fly|Ride"] = 2135.44, ["Mega|Fly|Ride"] = 9223.67}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 5.16, ["Fly"] = 210, ["Ride"] = 65.24, ["Fly|Ride"] = 140.85, ["Neon"] = 27.36, ["Neon|Fly"] = 113.89, ["Neon|Ride"] = 85.2, ["Neon|Fly|Ride"] = 141.74, ["Mega"] = 189, ["Mega|Ride"] = 209.99, ["Mega|Fly|Ride"] = 448.18}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 2.83, ["Fly"] = 236.25, ["Ride"] = 45.21, ["Fly|Ride"] = 76.67, ["Neon"] = 19.38, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 144.37, ["Mega"] = 157.38, ["Mega|Fly"] = 804.96, ["Mega|Ride"] = 156.94, ["Mega|Fly|Ride"] = 270.39}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 34.13, ["Ride"] = 16.52, ["Fly|Ride"] = 43.31, ["Neon"] = 17.74, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 32.17, ["Neon|Fly|Ride"] = 82.58, ["Mega"] = 284.19, ["Mega|Ride"] = 153.26, ["Mega|Fly|Ride"] = 194.25}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 17.75, ["Fly"] = 26.25, ["Ride"] = 34.13, ["Fly|Ride"] = 58.53, ["Neon"] = 117.59, ["Mega"] = 568.31, ["Mega|Ride"] = 472.49, ["Mega|Fly|Ride"] = 549.15}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Ride"] = 42.87, ["Neon"] = 3.21, ["Neon|Ride"] = 140.49, ["Neon|Fly|Ride"] = 106.44, ["Mega"] = 30.09, ["Mega|Fly"] = 127.73, ["Mega|Ride"] = 64.22, ["Mega|Fly|Ride"] = 170.29}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 590.63, ["Fly"] = 683.25, ["Ride"] = 576.06, ["Fly|Ride"] = 630, ["Neon"] = 2589.57, ["Neon|Fly|Ride"] = 2100, ["Mega|Ride"] = 9413.08, ["Mega|Fly|Ride"] = 7861.88}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 80.18, ["Neon"] = 12.5, ["Neon|Ride"] = 85.15, ["Neon|Fly|Ride"] = 444.87, ["Mega"] = 78.75, ["Mega|Ride"] = 263.94}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 34.08, ["Neon"] = 3.56, ["Neon|Fly"] = 142.63, ["Neon|Ride"] = 76.63, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 41.96, ["Mega|Ride"] = 133.97, ["Mega|Fly|Ride"] = 284.16}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 59.77, ["Neon"] = 3.73, ["Neon|Ride"] = 56.15, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 36.75, ["Mega|Fly"] = 157.52, ["Mega|Ride"] = 122.4, ["Mega|Fly|Ride"] = 170.29}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 20.24, ["Neon|Ride"] = 48.18, ["Mega"] = 212.86, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 23.51, ["Fly"] = 65.63, ["Ride"] = 41.91, ["Fly|Ride"] = 144.37, ["Neon"] = 120.15, ["Neon|Fly"] = 212.86, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 283.5, ["Mega"] = 511.88, ["Mega|Ride"] = 437.06, ["Mega|Fly|Ride"] = 556.36}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 11.1, ["Ride"] = 75.48, ["Fly|Ride"] = 142.63, ["Neon"] = 65.62, ["Neon|Ride"] = 127.63, ["Neon|Fly|Ride"] = 280.88, ["Mega"] = 479.47, ["Mega|Ride"] = 441.13, ["Mega|Fly|Ride"] = 548.46}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly"] = 32.7, ["Ride"] = 14.43, ["Fly|Ride"] = 33.5, ["Neon"] = 28.74, ["Neon|Fly"] = 142.63, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 42.58, ["Mega"] = 298.6, ["Mega|Ride"] = 284.16, ["Mega|Fly|Ride"] = 319.29}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 7.64, ["Ride"] = 56.03, ["Fly|Ride"] = 134.1, ["Neon"] = 38.05, ["Neon|Ride"] = 142.63}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Ride"] = 26.16, ["Fly|Ride"] = 100.05, ["Neon"] = 6.36, ["Neon|Ride"] = 38.63, ["Neon|Fly|Ride"] = 113.89, ["Mega"] = 69.56, ["Mega|Ride"] = 115.5, ["Mega|Fly|Ride"] = 272.75}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 21.36, ["Fly"] = 113.45, ["Ride"] = 28.74, ["Fly|Ride"] = 36.2, ["Neon"] = 109.15, ["Neon|Ride"] = 142.63, ["Neon|Fly|Ride"] = 199.03, ["Mega"] = 787.5, ["Mega|Fly|Ride"] = 749.44}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 29.23, ["Fly"] = 874.13, ["Neon"] = 98.44, ["Mega"] = 332.06, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 497}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 36.92, ["Fly"] = 153.58, ["Ride"] = 57.28, ["Fly|Ride"] = 123.37, ["Neon"] = 322.17, ["Neon|Ride"] = 313.69, ["Neon|Fly|Ride"] = 415.8, ["Mega|Ride"] = 1706.43, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 35.43, ["Fly"] = 85.15, ["Ride"] = 60.38, ["Fly|Ride"] = 170.29, ["Neon"] = 150.94, ["Neon|Ride"] = 144.37, ["Neon|Fly|Ride"] = 210, ["Mega"] = 551.25, ["Mega|Ride"] = 723.69, ["Mega|Fly|Ride"] = 632}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 15.65, ["Ride"] = 57.5, ["Neon"] = 105, ["Neon|Ride"] = 223.12, ["Mega"] = 1050, ["Mega|Ride"] = 804.96, ["Mega|Fly|Ride"] = 806.71}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 16.05, ["Fly"] = 81.73, ["Ride"] = 63, ["Fly|Ride"] = 194.33, ["Neon"] = 136.5, ["Neon|Fly"] = 255.43, ["Neon|Ride"] = 212.15, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 567.9, ["Mega|Ride"] = 588.23, ["Mega|Fly|Ride"] = 651.52}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 17.95, ["Ride"] = 14.44, ["Fly|Ride"] = 32.74, ["Neon"] = 3.61, ["Neon|Fly"] = 27.36, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 54.29, ["Mega"] = 39.26, ["Mega|Fly"] = 322.23, ["Mega|Ride"] = 57.7, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 866.24}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 64.19, ["Fly"] = 482.67, ["Ride"] = 109.29, ["Fly|Ride"] = 262.4, ["Neon"] = 378, ["Neon|Ride"] = 458.07, ["Neon|Fly|Ride"] = 525, ["Mega"] = 1419.69, ["Mega|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 1351.88}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 79.76, ["Neon"] = 3.33, ["Neon|Fly"] = 100.05, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 297.99, ["Mega"] = 24.83, ["Mega|Ride"] = 84.96, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 22.31, ["Ride"] = 113.89, ["Fly|Ride"] = 142.63, ["Neon"] = 156.19, ["Neon|Ride"] = 133.66, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 591.94, ["Mega|Ride"] = 510.46, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 2.51, ["Neon|Fly|Ride"] = 113.89, ["Mega"] = 26.17}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 3.29, ["Mega"] = 19.69, ["Mega|Ride"] = 152.07, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 86.41, ["Fly"] = 223.13, ["Ride"] = 141.94, ["Fly|Ride"] = 364.4, ["Neon"] = 433.13, ["Neon|Ride"] = 454.78, ["Neon|Fly|Ride"] = 668.4, ["Mega|Ride"] = 2681.86, ["Mega|Fly|Ride"] = 2098.53}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 90.57, ["Ride"] = 21.53, ["Fly|Ride"] = 96.54, ["Neon"] = 7.79, ["Neon|Fly"] = 42.58, ["Neon|Ride"] = 32.25, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 90.2, ["Mega|Ride"] = 116.82, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 38.07, ["Fly|Ride"] = 55.13, ["Neon"] = 3.55, ["Neon|Fly"] = 42.58, ["Neon|Ride"] = 10.66, ["Neon|Fly|Ride"] = 419.9, ["Mega"] = 31.5, ["Mega|Ride"] = 127.73, ["Mega|Fly|Ride"] = 217.87}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 63.12, ["Neon"] = 6.27, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 236.15, ["Mega"] = 106.98, ["Mega|Ride"] = 163.13, ["Mega|Fly|Ride"] = 510.84}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 90.3, ["Neon"] = 3.68, ["Neon|Ride"] = 156.09, ["Mega"] = 90.45, ["Mega|Fly"] = 195.83, ["Mega|Ride"] = 337.92, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 71.31, ["Ride"] = 131.25, ["Fly|Ride"] = 355.46, ["Neon"] = 437.07, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 2271.07, ["Mega|Ride"] = 2172.27, ["Mega|Fly|Ride"] = 2128.47}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 2.87, ["Ride"] = 78.36, ["Neon"] = 89.15, ["Neon|Ride"] = 77.43, ["Mega"] = 413.86, ["Mega|Ride"] = 366.19, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 393.65, ["Ride"] = 421.19, ["Fly|Ride"] = 566.19, ["Neon"] = 1770.06, ["Neon|Ride"] = 1419.69, ["Neon|Fly|Ride"] = 1102.5, ["Mega|Fly|Ride"] = 3346.87}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 82.04}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 43.32}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 15.65}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 10.19}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 142.63}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 116.79}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 13.83}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 5.71}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 116.82}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 14.13}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 31.85}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 12.04}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 5.67}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 839.99}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 4.82}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 5.84}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 6.76}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 3.83}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 15.12}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 590.63}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 591.94}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 8.21}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1366.42}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 52.31}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 5.25}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 34.13}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 17.07}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 37.77}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 51.19}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 16.96}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 12.85}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 19.38}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 3.94}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 15.02}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 6.08}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.15}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 20.98}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 14.23}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 5.78}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 3051.16}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 43.22}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 311.84}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 6.14}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 12.29}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 45.94}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 212.63}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 7.4}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 9.27}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 144.38}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 22.24}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 7.23}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 20.79}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 11.46}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 105}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 24.5}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 5.9}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 21.95}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 6.36}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 3.73}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 28.77}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 78.75}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 236.24}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 7.54}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 18.38}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 24.86}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 61.07}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 19.5}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 24012.42}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 118.13}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 45.85}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 37.59}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 26.17}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 39.38}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 24.94}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 42.58}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 85.89}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 81.38}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 18.71}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 85.31}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 262.5}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 65.47}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 41.48}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 214.27}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 8.68}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 6.14}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 5.7}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 24.4}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 113.21}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.1}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 2.23}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 5.71}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 11.46}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 270.13}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 1121.71}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 7.88}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 584.07}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 10.26}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.1}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 231}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 27.41}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 91.88}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 10.5}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 28.58}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 44.63}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 14.06}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 2.1}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 7.88}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 3.93}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 2.1}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 5.52}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 32.68}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 2.1}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 2.1}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 3.41}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 10.31}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 145.69}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 51.54}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.52}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.1}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 212.86}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 15.23}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 9.19}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 7.19}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 26.17}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 7.76}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 6.57}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 3.61}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 5.84}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 27.49}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 19.57}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 5.75}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 2.52}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 4.61}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 6.36}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 8.29}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 2.18}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 3.19}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 3.84}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 3.19}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 6.29}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 9364.15}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 11.32}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 2.52}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 4.07}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 4.27}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.52}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 52.49}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 5.8}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 7.44}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 3.94}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 5.07}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 40.17}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 6.45}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 3.3}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 5.11}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 2.63}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 3.12}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4115.37}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 6.35}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 33.86}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.3}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 3.72}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 59.22}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 4.88}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 105}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 15.11}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.1}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 4.02}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 10.31}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 21.41}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.15}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 6.03}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 3.93}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 5.16}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 6.56}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 3.93}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 17.05}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 4.71}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 7.88}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 117.85}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 79.71}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 9.1}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1213.95}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 52.49}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 5.25}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 24.15}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 24.53}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 4.98}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 7.25}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 7.76}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 13.78}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 26.24}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 11.86}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 3.92}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 3.19}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 10.75}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 3.12}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 20.89}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 13.29}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 2.94}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 7.87}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 58.7}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 3.93}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 131.25}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 90.57}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 9.19}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 4.03}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 21.18}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.63}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 205.78}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 5.46}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 5.57}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 2.63}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 3.74}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 71.91}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 157.5}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 10.05}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1201.18}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.51}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 196.88}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 9.48}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 4.94}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 58.99}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 6.23}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 3.54}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 64.96}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 16.09}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 17.26}},
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
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 51.35}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 65.73}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 49.87}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.24}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 4.6}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 34.44}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 136.5}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 82.6}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 8.05}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 55.78}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.24}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 60.48}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 48.56}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 98.91}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 2.63}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 62.29}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 6.35}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 127.93}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.63}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.3}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 29.6}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 54.53}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 47.25}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 7.85}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 2.62}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 8.22}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 13.12}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 75.16}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 57.65}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 6.23}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 14.24}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 32.29}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 23.14}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 12.29}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 78.73}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 47.14}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 26.24}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1994.99}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 6.4}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 6.46}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 19.68}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 322.2}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 17.19}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 8.99}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 6.16}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 7.55}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 5.98}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 318.93}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 57.1}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 43.22}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 4.56}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 55.04}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 194.91}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 77.41}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 918.75}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 135.48}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 8.13}},
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