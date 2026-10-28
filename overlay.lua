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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 813.75, ["Ride"] = 916.13, ["Fly|Ride"] = 1147.57, ["Neon"] = 9187.5, ["Neon|Fly|Ride"] = 3937.5}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 459.38, ["Fly"] = 606.64, ["Ride"] = 494.78, ["Fly|Ride"] = 547.15, ["Neon|Ride"] = 2100, ["Neon|Fly|Ride"] = 2165.63, ["Mega"] = 10251.13, ["Mega|Fly|Ride"] = 9529.42}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 4593.75, ["Ride"] = 4593.75, ["Fly|Ride"] = 4658.07, ["Neon|Ride"] = 20655.08, ["Neon|Fly|Ride"] = 16922.87, ["Mega|Fly|Ride"] = 68341.16}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 157.5, ["Ride"] = 183.1, ["Fly|Ride"] = 396.54, ["Neon"] = 768.57, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 1094.63, ["Mega"] = 4100.46, ["Mega|Fly|Ride"] = 3403.32}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 590.63, ["Fly"] = 822.55, ["Ride"] = 551.25, ["Fly|Ride"] = 599.82, ["Neon|Fly|Ride"] = 1519.88, ["Mega|Fly|Ride"] = 6300}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 7.87, ["Ride"] = 27.68, ["Fly|Ride"] = 151.66, ["Neon"] = 56.44, ["Neon|Fly"] = 273.58, ["Neon|Ride"] = 108.47, ["Neon|Fly|Ride"] = 273.93, ["Mega"] = 285.27, ["Mega|Ride"] = 262.49, ["Mega|Fly|Ride"] = 573.05}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 4.65, ["Fly"] = 36.75, ["Ride"] = 35.23, ["Fly|Ride"] = 59.77, ["Neon"] = 29.7, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 109.78, ["Mega"] = 162.65, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 291.06}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 102.92, ["Ride"] = 147.72, ["Fly|Ride"] = 232.6, ["Neon"] = 521.07, ["Neon|Ride"] = 664.79, ["Neon|Fly|Ride"] = 669.38, ["Mega|Ride"] = 2597.64, ["Mega|Fly|Ride"] = 2651.98}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 36.85, ["Fly"] = 80.98, ["Ride"] = 52.79, ["Fly|Ride"] = 107.63, ["Neon"] = 252, ["Neon|Ride"] = 260.58, ["Neon|Fly|Ride"] = 233.63, ["Mega"] = 2100, ["Mega|Ride"] = 1383.26, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 25.8, ["Fly"] = 55, ["Ride"] = 35.6, ["Fly|Ride"] = 58.86, ["Neon"] = 273.58, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 273.93, ["Mega|Ride"] = 1331.64, ["Mega|Fly|Ride"] = 1019.82}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 58.44, ["Fly"] = 206.07, ["Ride"] = 84.6, ["Fly|Ride"] = 166.46, ["Neon"] = 488.58, ["Neon|Fly"] = 396.54, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 301.88, ["Mega|Fly|Ride"] = 1537.69}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 68.25}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 328.13, ["Fly"] = 395.01, ["Ride"] = 340.96, ["Fly|Ride"] = 359.92, ["Neon"] = 1413.84, ["Neon|Ride"] = 1231.05, ["Neon|Fly|Ride"] = 1155, ["Mega|Fly|Ride"] = 4818.05}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 116.94, ["Fly"] = 154.98, ["Ride"] = 123.78, ["Fly|Ride"] = 171.12, ["Neon|Fly"] = 683.42, ["Neon|Fly|Ride"] = 507.83, ["Mega|Fly|Ride"] = 2732.97}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.1, ["Fly"] = 114.14, ["Ride"] = 52.5, ["Fly|Ride"] = 131.23, ["Neon"] = 21, ["Neon|Fly"] = 96.41, ["Neon|Ride"] = 137.48, ["Neon|Fly|Ride"] = 189, ["Mega"] = 131.25, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 204.02, ["Mega|Fly|Ride"] = 381.55}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 185.09, ["Fly"] = 200.67, ["Ride"] = 150.94, ["Fly|Ride"] = 227.06, ["Neon"] = 921.83, ["Neon|Ride"] = 684.28, ["Neon|Fly|Ride"] = 616.1, ["Mega|Fly|Ride"] = 2229.94}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 2.63, ["Fly"] = 22.04, ["Ride"] = 18.52, ["Fly|Ride"] = 40.6, ["Neon"] = 24.78, ["Neon|Ride"] = 90.19, ["Neon|Fly|Ride"] = 273.93, ["Mega"] = 207.38, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 295.32}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 91.88, ["Fly"] = 262.5, ["Ride"] = 150.56, ["Fly|Ride"] = 246.18, ["Neon"] = 288.75, ["Neon|Fly"] = 301.88, ["Neon|Ride"] = 373.75, ["Neon|Fly|Ride"] = 428.82, ["Mega"] = 1510.62, ["Mega|Ride"] = 1307.97, ["Mega|Fly|Ride"] = 1132.68}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 37.38}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 52.5, ["Ride"] = 220.05, ["Fly|Ride"] = 294.67, ["Neon"] = 577.5, ["Neon|Fly|Ride"] = 2362.5, ["Mega"] = 1093.81, ["Mega|Fly|Ride"] = 1831.9}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 18, ["Fly"] = 393.75, ["Ride"] = 28.88, ["Fly|Ride"] = 109.65, ["Neon"] = 204.93, ["Neon|Ride"] = 193.61, ["Neon|Fly|Ride"] = 265.72, ["Mega|Ride"] = 577.16, ["Mega|Fly|Ride"] = 1640.19}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 45.47, ["Fly"] = 123.78, ["Ride"] = 57.05, ["Fly|Ride"] = 105.69, ["Neon"] = 241.34, ["Neon|Ride"] = 233.63, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 1613.8, ["Mega|Fly|Ride"] = 826.88}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 55.86, ["Fly"] = 72.89, ["Fly|Ride"] = 137.31, ["Neon"] = 191.31, ["Neon|Fly"] = 382.57, ["Neon|Ride"] = 186.17, ["Neon|Fly|Ride"] = 351.63, ["Mega"] = 1156.35, ["Mega|Ride"] = 1226.05, ["Mega|Fly|Ride"] = 1214.07}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 29.47, ["Ride"] = 41.1, ["Fly|Ride"] = 137.17, ["Neon"] = 342.23, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 290.75, ["Mega"] = 818.06, ["Mega|Ride"] = 2048.2, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 41.43, ["Fly"] = 115.67, ["Ride"] = 62.77, ["Fly|Ride"] = 122.97, ["Neon"] = 227.07, ["Neon|Fly"] = 548.18, ["Neon|Ride"] = 180.09, ["Neon|Fly|Ride"] = 230.76, ["Mega|Ride"] = 1124.82, ["Mega|Fly|Ride"] = 885.44}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 5.7, ["Fly"] = 31.25, ["Ride"] = 23.36, ["Fly|Ride"] = 57.08, ["Neon"] = 30.97, ["Neon|Fly"] = 105, ["Neon|Ride"] = 45.92, ["Neon|Fly|Ride"] = 93.06, ["Mega"] = 131.25, ["Mega|Fly"] = 26157.81, ["Mega|Ride"] = 181.13, ["Mega|Fly|Ride"] = 255.92}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 339.9, ["Ride"] = 420, ["Fly|Ride"] = 454.88, ["Neon"] = 1844.3, ["Neon|Ride"] = 1949.19, ["Neon|Fly|Ride"] = 1680, ["Mega|Fly|Ride"] = 7224.02}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 14.2, ["Ride"] = 31.26, ["Fly|Ride"] = 107.34, ["Neon"] = 219.18, ["Neon|Ride"] = 176.46, ["Neon|Fly|Ride"] = 418.58, ["Mega"] = 511.54, ["Mega|Ride"] = 779.1, ["Mega|Fly|Ride"] = 671.66}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 2.63, ["Fly"] = 34.54, ["Ride"] = 20.28, ["Fly|Ride"] = 48.54, ["Neon"] = 54.41, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 119.33, ["Mega|Ride"] = 268.11, ["Mega|Fly|Ride"] = 417.77}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 52.5, ["Fly"] = 91.88, ["Ride"] = 85.62, ["Fly|Ride"] = 131.22, ["Neon"] = 355.55, ["Neon|Fly"] = 376.72, ["Neon|Ride"] = 385.75, ["Neon|Fly|Ride"] = 404.25, ["Mega"] = 3007.7, ["Mega|Ride"] = 9987.68, ["Mega|Fly|Ride"] = 1552.03}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 11.1, ["Ride"] = 23.15, ["Fly|Ride"] = 75.22, ["Neon"] = 154.43, ["Neon|Ride"] = 109.78, ["Neon|Fly|Ride"] = 160.79, ["Mega"] = 479.16, ["Mega|Ride"] = 782.18}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 190.04, ["Fly"] = 347.54, ["Ride"] = 253.26, ["Fly|Ride"] = 291.38, ["Neon"] = 922.16, ["Neon|Ride"] = 735, ["Neon|Fly|Ride"] = 840, ["Mega"] = 6150.68, ["Mega|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 2930.83}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 26.25}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.94, ["Fly"] = 26.91, ["Ride"] = 23.63, ["Fly|Ride"] = 50.39, ["Neon"] = 25.36, ["Neon|Fly"] = 131.37, ["Neon|Ride"] = 53.09, ["Neon|Fly|Ride"] = 87.94, ["Mega"] = 234.94, ["Mega|Fly"] = 501.48, ["Mega|Ride"] = 273.73, ["Mega|Fly|Ride"] = 302.43}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 866.25, ["Fly"] = 2625, ["Ride"] = 823.18, ["Fly|Ride"] = 1064.53, ["Neon"] = 4200, ["Neon|Ride"] = 4200, ["Neon|Fly|Ride"] = 4003.13, ["Mega|Ride"] = 51871.67, ["Mega|Fly|Ride"] = 14962.5}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 7.07, ["Fly"] = 68.91, ["Ride"] = 27.78, ["Fly|Ride"] = 85.32, ["Neon"] = 91.55, ["Neon|Ride"] = 118.09, ["Neon|Fly|Ride"] = 226.73, ["Mega"] = 533.07, ["Mega|Ride"] = 695.04, ["Mega|Fly|Ride"] = 820.31}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 155.93, ["Ride"] = 216.85, ["Fly|Ride"] = 210, ["Neon"] = 867.85, ["Neon|Ride"] = 708.75, ["Neon|Fly|Ride"] = 787.5, ["Mega|Ride"] = 2459.88, ["Mega|Fly|Ride"] = 3007.7}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 45.94}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 21.98, ["Fly"] = 68.84, ["Ride"] = 52.29, ["Fly|Ride"] = 137.31, ["Neon"] = 82.41, ["Neon|Ride"] = 200.76, ["Neon|Fly|Ride"] = 164.16, ["Mega"] = 670.9, ["Mega|Ride"] = 1101.19, ["Mega|Fly|Ride"] = 722.76}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 115.19, ["Ride"] = 127.32, ["Fly|Ride"] = 233.71, ["Neon"] = 584.07, ["Neon|Ride"] = 460.92, ["Neon|Fly|Ride"] = 584.77, ["Mega|Fly|Ride"] = 2231.25}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 110.44, ["Ride"] = 199.48, ["Fly|Ride"] = 272.85, ["Neon"] = 389.44, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 590.62, ["Mega"] = 1537.69, ["Mega|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 2058}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 32.39}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 52.41, ["Fly"] = 61.35, ["Ride"] = 55.06, ["Fly|Ride"] = 82.61, ["Neon|Ride"] = 475.35, ["Neon|Fly|Ride"] = 326.82, ["Mega"] = 4100.46, ["Mega|Fly|Ride"] = 1262.21}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 7.76, ["Fly"] = 55.54, ["Ride"] = 41.08, ["Fly|Ride"] = 131.25, ["Neon"] = 32.82, ["Neon|Fly"] = 223.13, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 230.84, ["Mega"] = 166.07, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 321.29, ["Mega|Fly|Ride"] = 408.08}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 446.25, ["Fly"] = 590.63, ["Ride"] = 393.75, ["Fly|Ride"] = 484.32, ["Neon|Ride"] = 1731.7, ["Neon|Fly|Ride"] = 1506.74, ["Mega|Fly|Ride"] = 6298.95}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 82.69, ["Fly"] = 161.95, ["Ride"] = 108.32, ["Fly|Ride"] = 171.94, ["Neon"] = 446.25, ["Neon|Fly"] = 819.7, ["Neon|Ride"] = 547.84, ["Neon|Fly|Ride"] = 439.09, ["Mega|Ride"] = 2459.26, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3510.24, ["Ride"] = 3412.5, ["Fly|Ride"] = 3675, ["Neon|Fly|Ride"] = 14361.32}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 39.36, ["Fly"] = 110.12, ["Ride"] = 52.5, ["Fly|Ride"] = 128.41, ["Neon"] = 393.75, ["Neon|Ride"] = 582.64, ["Neon|Fly|Ride"] = 342.66, ["Mega|Ride"] = 1176.83, ["Mega|Fly|Ride"] = 1216.82}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 69.41, ["Ride"] = 68.66, ["Fly|Ride"] = 172.86, ["Neon"] = 410.42, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 2733.99, ["Mega|Ride"] = 2597.64, ["Mega|Fly|Ride"] = 2766.5}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 30.35, ["Fly"] = 63.25, ["Ride"] = 57, ["Fly|Ride"] = 136.56, ["Neon"] = 230.47, ["Neon|Fly"] = 194.7, ["Neon|Ride"] = 163.96, ["Neon|Fly|Ride"] = 194.22, ["Mega"] = 957.47, ["Mega|Ride"] = 683.76, ["Mega|Fly|Ride"] = 597.41}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 6.3}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 46.35, ["Fly"] = 393.75, ["Ride"] = 59.09, ["Fly|Ride"] = 63.63, ["Neon"] = 358.62, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 406.88, ["Mega|Fly|Ride"] = 1093.81}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 37.68}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 195.24, ["Ride"] = 221.82, ["Fly|Ride"] = 313.55, ["Neon|Ride"] = 1384.49, ["Neon|Fly|Ride"] = 1368.54, ["Mega|Fly|Ride"] = 4918.6}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 1015.87, ["Ride"] = 1034.25, ["Fly|Ride"] = 1043.44, ["Neon"] = 2625, ["Neon|Ride"] = 3847.7, ["Neon|Fly|Ride"] = 3018.74, ["Mega|Fly|Ride"] = 13326.48}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 6.56}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 26.13, ["Fly"] = 68.3, ["Ride"] = 42.78, ["Fly|Ride"] = 62.15, ["Neon"] = 160.78, ["Neon|Ride"] = 148.46, ["Neon|Fly|Ride"] = 190.31, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 920.57}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 14.44}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 6292.5, ["Fly|Ride"] = 4704, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 39960.8}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 10.35, ["Fly"] = 52.41, ["Ride"] = 24.8, ["Fly|Ride"] = 54.57, ["Neon"] = 131.17, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 219.19, ["Mega"] = 656.1, ["Mega|Ride"] = 547.43, ["Mega|Fly|Ride"] = 616.87}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 13.02, ["Fly"] = 41.13, ["Ride"] = 41.01, ["Fly|Ride"] = 114.1, ["Neon"] = 65.63, ["Neon|Ride"] = 132.6, ["Neon|Fly|Ride"] = 245.2, ["Mega"] = 1025.93, ["Mega|Ride"] = 642.76, ["Mega|Fly|Ride"] = 1022.05}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 94.61, ["Fly"] = 271.07, ["Ride"] = 72.19, ["Fly|Ride"] = 105, ["Neon|Ride"] = 380.61, ["Neon|Fly|Ride"] = 471.37, ["Mega"] = 4100.46}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 10.29, ["Fly"] = 150.93, ["Ride"] = 26.25, ["Fly|Ride"] = 138.34, ["Neon"] = 74.87, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 151.85, ["Mega"] = 1367.51, ["Mega|Ride"] = 501.48, ["Mega|Fly|Ride"] = 813.75}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1968.65, ["Fly"] = 2122.32, ["Ride"] = 1949.07, ["Fly|Ride"] = 1685.1, ["Neon|Fly|Ride"] = 3429.57, ["Mega|Fly|Ride"] = 13125}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 29400, ["Ride"] = 28688.81, ["Fly|Ride"] = 23448.11, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 68392.35, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 183750}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 17.07, ["Fly"] = 393.74, ["Ride"] = 52.45, ["Fly|Ride"] = 124.68, ["Neon"] = 204.93, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 307.78, ["Mega"] = 957.47, ["Mega|Ride"] = 752.46, ["Mega|Fly|Ride"] = 821.63}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 2.1, ["Fly"] = 76.46, ["Ride"] = 28.88, ["Fly|Ride"] = 136.5, ["Neon"] = 19.58, ["Neon|Fly"] = 55.35, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 118.02, ["Mega|Ride"] = 205.2, ["Mega|Fly|Ride"] = 274.32}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 21}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 6.49, ["Ride"] = 38.74, ["Fly|Ride"] = 125.24, ["Neon"] = 64.56, ["Neon|Ride"] = 125.32, ["Neon|Fly|Ride"] = 463.39, ["Mega"] = 3112.32, ["Mega|Ride"] = 328.12, ["Mega|Fly|Ride"] = 545.57}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 643.13, ["Ride"] = 735, ["Fly|Ride"] = 787.5, ["Neon|Fly|Ride"] = 2805.88, ["Mega|Fly|Ride"] = 8469.57}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 951.81, ["Fly"] = 1076.25, ["Ride"] = 1012.32, ["Fly|Ride"] = 1032.94, ["Neon|Fly|Ride"] = 3109.31, ["Mega|Fly|Ride"] = 11343.9}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 15.36, ["Fly"] = 115.67, ["Ride"] = 36.75, ["Fly|Ride"] = 86.63, ["Neon"] = 140.44, ["Neon|Ride"] = 119.9, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1204.13, ["Mega|Ride"] = 685.13, ["Mega|Fly|Ride"] = 649.69}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 26.25}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 62.79, ["Fly"] = 92.55, ["Ride"] = 71.94, ["Fly|Ride"] = 109.65, ["Neon"] = 409.86, ["Neon|Ride"] = 369.33, ["Neon|Fly|Ride"] = 391.91, ["Mega|Ride"] = 2007.18, ["Mega|Fly|Ride"] = 1664.25}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 57.29, ["Ride"] = 77.23, ["Fly|Ride"] = 228.38, ["Neon"] = 342.23, ["Neon|Ride"] = 287.28, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 2065.84, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 3.93, ["Fly"] = 44.63, ["Ride"] = 20.01, ["Fly|Ride"] = 51.33, ["Neon"] = 55.77, ["Neon|Fly"] = 524.98, ["Neon|Ride"] = 68.09, ["Neon|Fly|Ride"] = 132.54, ["Mega"] = 288.75, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 109.15, ["Fly"] = 143.96, ["Ride"] = 137.45, ["Fly|Ride"] = 200.74, ["Neon|Ride"] = 450.22, ["Neon|Fly|Ride"] = 406.88, ["Mega|Fly|Ride"] = 1491.09}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 2.63, ["Ride"] = 46.28, ["Fly|Ride"] = 110.12, ["Neon"] = 43.04, ["Neon|Ride"] = 127.32, ["Neon|Fly|Ride"] = 478.07, ["Mega"] = 242.82, ["Mega|Ride"] = 239.89, ["Mega|Fly|Ride"] = 519.74}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 17.36, ["Fly"] = 41.22, ["Ride"] = 26.75, ["Fly|Ride"] = 87.59, ["Neon"] = 84, ["Neon|Ride"] = 109.19, ["Neon|Fly|Ride"] = 162.1, ["Mega|Fly|Ride"] = 752.46}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 25.99, ["Ride"] = 55.54, ["Fly|Ride"] = 156.19, ["Neon"] = 261.29, ["Neon|Ride"] = 328.3, ["Neon|Fly|Ride"] = 273.93, ["Mega"] = 694.25, ["Mega|Ride"] = 768.88, ["Mega|Fly|Ride"] = 861.11}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 16.7, ["Fly"] = 145.58, ["Ride"] = 28.88, ["Fly|Ride"] = 52.5, ["Neon"] = 91.88, ["Neon|Ride"] = 108.47, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 820.11, ["Mega|Ride"] = 922.61, ["Mega|Fly|Ride"] = 947.63}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 7170.29, ["Ride"] = 7141.32, ["Fly|Ride"] = 6685.88, ["Neon"] = 30738.01, ["Neon|Fly|Ride"] = 27206.34}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 234.23, ["Fly"] = 274.54, ["Ride"] = 256.69, ["Fly|Ride"] = 268.97, ["Neon|Fly|Ride"] = 560.44, ["Mega|Fly|Ride"] = 2098.69}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 41.14, ["Fly"] = 150.94, ["Ride"] = 69.15, ["Fly|Ride"] = 104.99, ["Neon"] = 90.57, ["Neon|Fly"] = 203.9, ["Neon|Ride"] = 126, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 380.63, ["Mega|Ride"] = 408.34, ["Mega|Fly|Ride"] = 511.55}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 3.28, ["Fly"] = 85.61, ["Ride"] = 23.58, ["Fly|Ride"] = 104.87, ["Neon"] = 22.96, ["Neon|Fly"] = 31.78, ["Neon|Ride"] = 55.41, ["Neon|Fly|Ride"] = 186.73, ["Mega"] = 129.94, ["Mega|Ride"] = 187.69}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 52.49, ["Fly"] = 5243.06, ["Ride"] = 88.11, ["Fly|Ride"] = 191.91, ["Neon"] = 199.11, ["Neon|Fly"] = 331.98, ["Neon|Ride"] = 226.91, ["Neon|Fly|Ride"] = 328.06, ["Mega"] = 441.79, ["Mega|Ride"] = 461.09, ["Mega|Fly|Ride"] = 578.2}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 14385, ["Ride"] = 13387.5, ["Fly|Ride"] = 12599.9, ["Neon|Fly|Ride"] = 27562.5}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 169.32, ["Ride"] = 223.13, ["Fly|Ride"] = 371.43, ["Neon"] = 1489.79, ["Neon|Ride"] = 1436.25, ["Neon|Fly|Ride"] = 1436.25, ["Mega|Fly|Ride"] = 5098.92}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 62.99, ["Fly"] = 118.83, ["Ride"] = 74.75, ["Fly|Ride"] = 101.46, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 407.84, ["Mega|Fly|Ride"] = 2560.74}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 10.23, ["Fly"] = 43.96, ["Ride"] = 24.94, ["Fly|Ride"] = 55.55, ["Neon"] = 85.32, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 112.22, ["Mega"] = 302.43, ["Mega|Ride"] = 342.41, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 328.02, ["Ride"] = 413.34, ["Fly|Ride"] = 495.96, ["Neon"] = 1639.37, ["Neon|Ride"] = 1575, ["Neon|Fly|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 5011.13}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 3.94, ["Fly"] = 101.53, ["Ride"] = 34.79, ["Fly|Ride"] = 85.22, ["Neon"] = 26, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 272.9, ["Mega"] = 129.93, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 266.54}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 133.88, ["Fly"] = 205.65, ["Ride"] = 162.21, ["Fly|Ride"] = 232.6, ["Neon"] = 547.15, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 525, ["Mega|Fly|Ride"] = 2540.03}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 11.53, ["Fly"] = 15.44, ["Ride"] = 18.04, ["Fly|Ride"] = 31.98, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 874.13}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 7.67}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 74.72, ["Ride"] = 86.63, ["Fly|Ride"] = 279.57, ["Neon"] = 421.32, ["Neon|Fly"] = 547.15, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 367.5, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1521.58}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 13.99, ["Fly"] = 101.8, ["Ride"] = 36.39, ["Fly|Ride"] = 92.21, ["Neon"] = 102.47, ["Neon|Ride"] = 87.28, ["Neon|Fly|Ride"] = 245.44, ["Mega"] = 1023.07, ["Mega|Ride"] = 669.38, ["Mega|Fly|Ride"] = 669.38}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 23.12}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 36.74, ["Fly"] = 131.25, ["Ride"] = 65.63, ["Fly|Ride"] = 249.38, ["Neon"] = 208.69, ["Neon|Ride"] = 258.54, ["Neon|Fly|Ride"] = 344.03, ["Mega"] = 1093.81, ["Mega|Ride"] = 955.42, ["Mega|Fly|Ride"] = 1093.81}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.94, ["Ride"] = 29.23, ["Fly|Ride"] = 131.37, ["Neon"] = 23.61, ["Neon|Ride"] = 103.85, ["Neon|Fly|Ride"] = 266.75, ["Mega"] = 122.07, ["Mega|Fly|Ride"] = 412.79}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 14.21, ["Fly"] = 47.25, ["Ride"] = 35.87, ["Fly|Ride"] = 92.19, ["Neon|Ride"] = 137.48, ["Neon|Fly|Ride"] = 171.86, ["Mega|Ride"] = 582.28, ["Mega|Fly|Ride"] = 590.28}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 535.47, ["Ride"] = 452.61, ["Fly|Ride"] = 523.69, ["Neon|Fly|Ride"] = 2728.85, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 36.75, ["Fly"] = 102.83, ["Ride"] = 55.11, ["Fly|Ride"] = 65.63, ["Neon"] = 232.6, ["Neon|Ride"] = 180.07, ["Neon|Fly|Ride"] = 302.65, ["Mega"] = 1011.9, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 887.76}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 51.95, ["Fly"] = 117.49, ["Ride"] = 66.09, ["Fly|Ride"] = 131.25, ["Neon"] = 204.93, ["Neon|Ride"] = 315.99, ["Neon|Fly|Ride"] = 328.12, ["Mega|Ride"] = 717.6, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 28.5, ["Fly"] = 76.35, ["Ride"] = 71.76, ["Fly|Ride"] = 116.09, ["Neon"] = 143.46, ["Neon|Ride"] = 187.76, ["Neon|Fly|Ride"] = 237.87, ["Mega"] = 414.74, ["Mega|Ride"] = 342.41, ["Mega|Fly|Ride"] = 605.51}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 8400, ["Ride"] = 13263.17, ["Fly|Ride"] = 7980, ["Neon|Fly|Ride"] = 14171.05, ["Mega|Fly|Ride"] = 39373.95}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1509.38, ["Ride"] = 1575, ["Fly|Ride"] = 1509.38, ["Neon|Fly|Ride"] = 4515, ["Mega|Fly|Ride"] = 15356.25}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 518.44, ["Ride"] = 519.75, ["Fly|Ride"] = 525, ["Neon"] = 2263.7, ["Neon|Fly|Ride"] = 2359.53, ["Mega|Fly|Ride"] = 6695.01}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 11.46, ["Fly"] = 23.63, ["Ride"] = 20.28, ["Fly|Ride"] = 41.01, ["Neon"] = 110.25, ["Neon|Ride"] = 94.4, ["Neon|Fly|Ride"] = 124.55, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 4.65, ["Fly"] = 78.74, ["Ride"] = 32.18, ["Fly|Ride"] = 81.99, ["Neon"] = 23.87, ["Neon|Ride"] = 76.33, ["Neon|Fly|Ride"] = 227.07, ["Mega"] = 133.85, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 30.19, ["Fly"] = 60.72, ["Ride"] = 43.32, ["Fly|Ride"] = 65.62, ["Neon"] = 518.54, ["Neon|Ride"] = 195.57, ["Neon|Fly|Ride"] = 164.22, ["Mega|Fly|Ride"] = 511.67}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 2.1, ["Fly"] = 26.75, ["Ride"] = 15.75, ["Fly|Ride"] = 42, ["Neon"] = 27.81, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 86.63, ["Mega"] = 262.5, ["Mega|Ride"] = 206.07, ["Mega|Fly|Ride"] = 287.04}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 315, ["Fly"] = 320.25, ["Ride"] = 262.5, ["Fly|Ride"] = 375.12, ["Neon|Ride"] = 1340.84, ["Neon|Fly|Ride"] = 1169.44, ["Mega|Fly|Ride"] = 4200}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 18.38, ["Fly"] = 82.26, ["Ride"] = 31.49, ["Fly|Ride"] = 76.48, ["Neon"] = 187.52, ["Neon|Fly"] = 407.52, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 820.11, ["Mega|Ride"] = 524.9, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 11.34, ["Fly"] = 20.99, ["Ride"] = 20.4, ["Fly|Ride"] = 43.83, ["Neon"] = 80.67, ["Neon|Fly"] = 131.37, ["Neon|Ride"] = 80.56, ["Neon|Fly|Ride"] = 106.6, ["Mega"] = 1575, ["Mega|Ride"] = 618.19, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 462.61, ["Fly"] = 787.5, ["Ride"] = 446.24, ["Fly|Ride"] = 818.67, ["Neon|Ride"] = 2872.48, ["Mega|Fly|Ride"] = 8619.21}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1154.74, ["Fly"] = 1387.81, ["Ride"] = 1154.99, ["Fly|Ride"] = 1286.25, ["Neon"] = 4781.82, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 13782.3}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 92.54, ["Fly"] = 129.56, ["Ride"] = 90.96, ["Fly|Ride"] = 123.44, ["Neon"] = 971.25, ["Neon|Ride"] = 585.46, ["Neon|Fly|Ride"] = 328.13, ["Mega|Fly|Ride"] = 3018.75}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 158.37, ["Fly"] = 157.5, ["Ride"] = 155.01, ["Fly|Ride"] = 262.79, ["Neon"] = 577.5, ["Neon|Fly"] = 683.42, ["Neon|Ride"] = 692.26, ["Neon|Fly|Ride"] = 638.24, ["Mega|Fly|Ride"] = 2305.42}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 25.35, ["Ride"] = 61.64, ["Fly|Ride"] = 118.58, ["Neon"] = 239.88, ["Neon|Ride"] = 272.99, ["Neon|Fly|Ride"] = 385.12, ["Mega|Ride"] = 2050.23, ["Mega|Fly|Ride"] = 820.11}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 137.92, ["Ride"] = 273, ["Fly|Ride"] = 128.63, ["Neon|Fly|Ride"] = 1292.19, ["Mega|Fly|Ride"] = 3280.37}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2211, ["Fly"] = 2330.91, ["Ride"] = 2483.25, ["Fly|Ride"] = 2322.78, ["Neon|Fly|Ride"] = 10258.81, ["Mega|Fly|Ride"] = 24591.8}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 65.87, ["Ride"] = 68.91, ["Fly|Ride"] = 196.88, ["Neon"] = 348.38, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 343.87, ["Mega|Ride"] = 2255.26, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 584.07, ["Fly"] = 616.88, ["Ride"] = 590.63, ["Fly|Ride"] = 662.67, ["Neon|Ride"] = 1504.98, ["Neon|Fly|Ride"] = 1179.94, ["Mega|Fly|Ride"] = 3137.46}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 44.63, ["Fly"] = 60.38, ["Ride"] = 57.65, ["Fly|Ride"] = 101.46, ["Neon|Ride"] = 357.67, ["Neon|Fly|Ride"] = 267.75, ["Mega|Fly|Ride"] = 1093.81}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.29, ["Fly"] = 39.38, ["Ride"] = 19.36, ["Fly|Ride"] = 55.13, ["Neon"] = 24.93, ["Neon|Fly"] = 154.43, ["Neon|Ride"] = 44.4, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 144.31, ["Mega|Fly"] = 249.26, ["Mega|Ride"] = 158.82, ["Mega|Fly|Ride"] = 273.73}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 49.92, ["Ride"] = 123.05, ["Fly|Ride"] = 252, ["Neon"] = 259.88, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 684.28, ["Mega"] = 1498.53, ["Mega|Ride"] = 1367.51, ["Mega|Fly|Ride"] = 1235.68}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 826.77, ["Fly"] = 1011.95, ["Ride"] = 818.47, ["Fly|Ride"] = 826.88, ["Neon|Ride"] = 1968.75, ["Neon|Fly|Ride"] = 2301.16, ["Mega|Fly|Ride"] = 9158.37}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 623.7, ["Ride"] = 681.19, ["Fly|Ride"] = 765.39, ["Neon|Fly|Ride"] = 2887.5}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 14.44, ["Fly"] = 26.25, ["Ride"] = 23.14, ["Fly|Ride"] = 52.6, ["Neon"] = 184.45, ["Neon|Ride"] = 171.94, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 786.19, ["Mega|Ride"] = 683.76, ["Mega|Fly|Ride"] = 681.29}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 10.5, ["Ride"] = 23.55, ["Fly|Ride"] = 45.94, ["Neon"] = 72.02, ["Neon|Ride"] = 77.32, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 504.37, ["Mega|Ride"] = 506.64, ["Mega|Fly|Ride"] = 447.99}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 4.93, ["Ride"] = 24.92, ["Fly|Ride"] = 111.46, ["Neon"] = 22.08, ["Neon|Fly"] = 309.32, ["Neon|Ride"] = 53.37, ["Neon|Fly|Ride"] = 151.85, ["Mega"] = 141.63, ["Mega|Fly"] = 523.34, ["Mega|Ride"] = 238.25, ["Mega|Fly|Ride"] = 302.43}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 47.98, ["Fly"] = 106.95, ["Ride"] = 52.49, ["Fly|Ride"] = 110.25, ["Neon"] = 229.69, ["Neon|Ride"] = 216.56, ["Neon|Fly|Ride"] = 262.5, ["Mega|Fly|Ride"] = 952.91}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 63.95, ["Ride"] = 116.94, ["Fly|Ride"] = 449.61, ["Neon"] = 415.63, ["Neon|Ride"] = 507.83, ["Neon|Fly|Ride"] = 684.28, ["Mega"] = 1230.15, ["Mega|Ride"] = 1537.69, ["Mega|Fly|Ride"] = 1365.47}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 11.82, ["Fly"] = 55.48, ["Ride"] = 34.04, ["Fly|Ride"] = 73.52, ["Neon"] = 72.19, ["Neon|Ride"] = 108.94, ["Neon|Fly|Ride"] = 173.25, ["Mega"] = 340.28, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 463.32}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 32.8, ["Fly"] = 136.5, ["Ride"] = 52.41, ["Fly|Ride"] = 84, ["Neon"] = 547.15, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 269.07, ["Mega"] = 2100, ["Mega|Ride"] = 957.47, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 2.1, ["Fly"] = 27.78, ["Ride"] = 18.02, ["Fly|Ride"] = 40.58, ["Neon"] = 28.14, ["Neon|Ride"] = 41.43, ["Neon|Fly|Ride"] = 91.71, ["Mega"] = 525, ["Mega|Ride"] = 273.73, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 6.13, ["Fly"] = 35.38, ["Ride"] = 28.58, ["Fly|Ride"] = 85.14, ["Neon"] = 25.97, ["Neon|Fly"] = 138.34, ["Neon|Ride"] = 73.42, ["Neon|Fly|Ride"] = 162.1, ["Mega"] = 293.25, ["Mega|Ride"] = 302.3, ["Mega|Fly|Ride"] = 378}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 52.5, ["Fly"] = 65.62, ["Ride"] = 59.11, ["Fly|Ride"] = 97.47, ["Neon"] = 399.84, ["Neon|Ride"] = 220.35, ["Neon|Fly|Ride"] = 205.04, ["Mega|Fly|Ride"] = 1018.98}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1600.9, ["Fly"] = 1575, ["Ride"] = 1389.84, ["Fly|Ride"] = 1501.56, ["Neon|Fly"] = 4666.67, ["Neon|Fly|Ride"] = 3846.95, ["Mega|Fly|Ride"] = 13064.77}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 485.63, ["Fly"] = 479.75, ["Ride"] = 459.38, ["Fly|Ride"] = 604.36, ["Neon|Ride"] = 3009.95, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 9566.36}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 284.83, ["Fly"] = 295.86, ["Ride"] = 280.67, ["Fly|Ride"] = 433.13, ["Neon|Fly|Ride"] = 1489.6, ["Mega|Fly|Ride"] = 6825}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 35.32}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 29.93, ["Ride"] = 43.3, ["Fly|Ride"] = 96.33, ["Neon"] = 327.26, ["Neon|Fly"] = 409.86, ["Neon|Ride"] = 350.86, ["Neon|Fly|Ride"] = 314.96, ["Mega"] = 1229.94, ["Mega|Ride"] = 957.47, ["Mega|Fly|Ride"] = 1038.19}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 41127.36, ["Fly"] = 65625, ["Ride"] = 34781.25, ["Fly|Ride"] = 17970.75, ["Neon|Fly|Ride"] = 38062.5, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 343.44, ["Fly"] = 360.94, ["Ride"] = 322.25, ["Fly|Ride"] = 380.63, ["Neon"] = 1364.78, ["Neon|Ride"] = 1141.88, ["Neon|Fly|Ride"] = 1312.5, ["Mega"] = 6150.68, ["Mega|Ride"] = 4099.44, ["Mega|Fly|Ride"] = 3858.74}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 143.93, ["Fly"] = 525, ["Ride"] = 137.67, ["Fly|Ride"] = 196.88, ["Mega|Fly|Ride"] = 4100.46}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 122.07, ["Fly"] = 262.49, ["Ride"] = 122.8, ["Fly|Ride"] = 196.77, ["Neon|Ride"] = 507.83, ["Neon|Fly|Ride"] = 547.43, ["Mega"] = 7518.18, ["Mega|Fly|Ride"] = 1640.19}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 15.75, ["Fly"] = 94.5, ["Ride"] = 34.02, ["Fly|Ride"] = 107.85, ["Neon"] = 392.44, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 205.19, ["Mega"] = 683.76, ["Mega|Ride"] = 599.43, ["Mega|Fly|Ride"] = 613.04}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 4879.77, ["Ride"] = 4935.39, ["Fly|Ride"] = 4067.44, ["Neon"] = 20355.75, ["Neon|Fly|Ride"] = 27357.16, ["Mega|Fly|Ride"] = 61478.31}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 30.19, ["Fly"] = 31.4, ["Ride"] = 38.95, ["Fly|Ride"] = 54.56, ["Neon"] = 227.48, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 210, ["Mega|Ride"] = 1367.51, ["Mega|Fly|Ride"] = 859.69}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 35.32, ["Fly"] = 137.8, ["Ride"] = 42, ["Fly|Ride"] = 90.33, ["Neon"] = 342.23, ["Neon|Ride"] = 266.75, ["Neon|Fly|Ride"] = 262.5, ["Mega|Fly|Ride"] = 1372.88}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 754.69, ["Fly"] = 918.75, ["Ride"] = 787.5, ["Fly|Ride"] = 840, ["Neon"] = 2362.49, ["Neon|Ride"] = 2231.24, ["Neon|Fly|Ride"] = 2362.49, ["Mega"] = 9007.67, ["Mega|Fly|Ride"] = 7846.13}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 13.83, ["Fly"] = 33.9, ["Ride"] = 26.17, ["Fly|Ride"] = 41.31, ["Neon"] = 131.25, ["Neon|Fly"] = 154.43, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 154.62, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 12.84, ["Fly"] = 96.67, ["Ride"] = 30.89, ["Fly|Ride"] = 460.92, ["Neon"] = 68.66, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 128.64, ["Mega|Ride"] = 519.74, ["Mega|Fly|Ride"] = 547.43}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 86.84, ["Ride"] = 115.5, ["Fly|Ride"] = 292.69, ["Neon"] = 531.78, ["Neon|Ride"] = 525.35, ["Neon|Fly|Ride"] = 748.35, ["Mega|Fly|Ride"] = 2392.62}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 20.9, ["Ride"] = 61.69, ["Fly|Ride"] = 135.26, ["Neon"] = 96.8, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 273.93, ["Mega"] = 275.63, ["Mega|Fly"] = 731.98, ["Mega|Ride"] = 297.47, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 4063, ["Ride"] = 4112.75, ["Fly|Ride"] = 3411.19, ["Neon"] = 13934.58, ["Neon|Ride"] = 11627.34, ["Neon|Fly|Ride"] = 9318.75, ["Mega"] = 61506.73, ["Mega|Fly|Ride"] = 32531.94}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 39.38, ["Ride"] = 64.79, ["Fly|Ride"] = 108.32, ["Neon"] = 220.43, ["Neon|Ride"] = 177.19, ["Neon|Fly|Ride"] = 410.37, ["Mega|Ride"] = 1024.1, ["Mega|Fly|Ride"] = 1230.15}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 7271.25, ["Ride"] = 7814.21, ["Fly|Ride"] = 6692.44, ["Neon|Fly|Ride"] = 17086.05, ["Mega|Fly|Ride"] = 67625.69}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.1, ["Fly"] = 20.9, ["Ride"] = 16.41, ["Fly|Ride"] = 44.07, ["Neon"] = 22.32, ["Neon|Fly"] = 62.62, ["Neon|Ride"] = 45.48, ["Neon|Fly|Ride"] = 86.63, ["Mega"] = 164.04, ["Mega|Ride"] = 191.71, ["Mega|Fly|Ride"] = 361.97}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 26.25, ["Fly"] = 26.16, ["Ride"] = 26.25, ["Fly|Ride"] = 47.15, ["Neon"] = 137.31, ["Neon|Ride"] = 190.83, ["Neon|Fly|Ride"] = 138.01, ["Mega|Ride"] = 957.47, ["Mega|Fly|Ride"] = 935.82}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.59}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 11.82, ["Fly"] = 39.38, ["Ride"] = 39.25, ["Fly|Ride"] = 115.5, ["Neon"] = 183.75, ["Neon|Ride"] = 157.68, ["Mega"] = 768.88, ["Mega|Ride"] = 957.47, ["Mega|Fly|Ride"] = 748.89}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 30.97, ["Fly"] = 190.37, ["Ride"] = 39.38, ["Fly|Ride"] = 149.61, ["Neon"] = 191.62, ["Neon|Ride"] = 124.53, ["Neon|Fly|Ride"] = 294.39, ["Mega"] = 840, ["Mega|Fly|Ride"] = 1099.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 11.17, ["Fly"] = 23.3, ["Ride"] = 22.86, ["Fly|Ride"] = 36.81, ["Neon"] = 81.99, ["Neon|Ride"] = 113.89, ["Neon|Fly|Ride"] = 175.18, ["Mega"] = 728.44, ["Mega|Ride"] = 575.22, ["Mega|Fly|Ride"] = 507.41}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8328.31}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2624.96}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 20.1}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 131.25, ["Ride"] = 196.87, ["Fly|Ride"] = 183.74, ["Neon|Fly|Ride"] = 1025.89}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 17.96, ["Fly"] = 123.39, ["Ride"] = 43.82, ["Fly|Ride"] = 105, ["Neon"] = 179.32, ["Neon|Ride"] = 108.84, ["Neon|Fly|Ride"] = 204.17, ["Mega"] = 404.94, ["Mega|Ride"] = 922.18, ["Mega|Fly|Ride"] = 949.28}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 14.4}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 6.57, ["Ride"] = 29.22, ["Fly|Ride"] = 62.23, ["Neon"] = 52.5, ["Neon|Ride"] = 96.46, ["Mega|Fly|Ride"] = 820.11}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 3045}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 150.84, ["Fly"] = 411.28, ["Ride"] = 217.98, ["Fly|Ride"] = 183.75, ["Neon"] = 701.37, ["Neon|Ride"] = 846.83, ["Neon|Fly|Ride"] = 943.83, ["Mega|Ride"] = 3144.04, ["Mega|Fly|Ride"] = 3007.7}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 96.67, ["Ride"] = 109.15, ["Fly|Ride"] = 211.32, ["Neon"] = 607.35, ["Neon|Ride"] = 682.4, ["Neon|Fly|Ride"] = 1435.35, ["Mega|Ride"] = 3280.37, ["Mega|Fly|Ride"] = 3074.28}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 157.5, ["Fly"] = 186.62, ["Ride"] = 207.37, ["Fly|Ride"] = 239.57, ["Neon"] = 897.75, ["Neon|Ride"] = 842.63, ["Neon|Fly|Ride"] = 984.38, ["Mega|Fly|Ride"] = 3172.93}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1852.72, ["Fly"] = 2467.65, ["Ride"] = 1378.13, ["Fly|Ride"] = 1312.5, ["Neon"] = 6585.2, ["Neon|Ride"] = 6428.19, ["Neon|Fly|Ride"] = 5248.69, ["Mega|Fly|Ride"] = 33814.57}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 18.22, ["Fly"] = 96.67, ["Ride"] = 39.19, ["Fly|Ride"] = 93.26, ["Neon"] = 155.91, ["Neon|Fly"] = 115.24, ["Neon|Ride"] = 203.14, ["Neon|Fly|Ride"] = 219.56, ["Mega"] = 922.18, ["Mega|Ride"] = 891.85, ["Mega|Fly|Ride"] = 1084.58}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 796.73, ["Fly"] = 2100, ["Ride"] = 678.43, ["Fly|Ride"] = 881.18, ["Neon|Ride"] = 2615.51, ["Neon|Fly|Ride"] = 3996.44}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 37.7}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 15.67, ["Ride"] = 48.47, ["Fly|Ride"] = 137.31, ["Neon"] = 99.75, ["Neon|Ride"] = 123.13, ["Neon|Fly|Ride"] = 272.9, ["Mega"] = 464.52, ["Mega|Ride"] = 457.95, ["Mega|Fly|Ride"] = 615.08}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 7.66, ["Fly"] = 48.35, ["Ride"] = 26.19, ["Fly|Ride"] = 44.18, ["Neon"] = 52.5, ["Neon|Ride"] = 78.62, ["Neon|Fly|Ride"] = 109.78, ["Mega"] = 918.75, ["Mega|Ride"] = 307.55, ["Mega|Fly|Ride"] = 353.9}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 58.28}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 30.09, ["Fly"] = 108.92, ["Ride"] = 34.72, ["Fly|Ride"] = 55.35, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 918.75, ["Mega|Ride"] = 820.11, ["Mega|Fly|Ride"] = 1387.72}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 26.25, ["Fly"] = 65.63, ["Ride"] = 32.82, ["Fly|Ride"] = 54.71, ["Neon|Ride"] = 410.37, ["Neon|Fly|Ride"] = 410.37, ["Mega"] = 820.11, ["Mega|Ride"] = 1729.06, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6300, ["Fly"] = 10967.64, ["Ride"] = 4987.5, ["Fly|Ride"] = 4725, ["Neon|Fly|Ride"] = 10500, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 9.55, ["Fly"] = 47.31, ["Ride"] = 35.35, ["Fly|Ride"] = 104.53, ["Neon"] = 77.6, ["Neon|Ride"] = 78.6, ["Neon|Fly|Ride"] = 163.13, ["Mega"] = 516.43, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 24.51}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 131.25, ["Fly"] = 364, ["Ride"] = 134.89, ["Fly|Ride"] = 170.63, ["Neon"] = 485.63, ["Neon|Ride"] = 507.83, ["Neon|Fly|Ride"] = 704.8, ["Mega"] = 2879.59, ["Mega|Fly|Ride"] = 1850.37}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 59.07, ["Fly"] = 92.55, ["Ride"] = 92.55, ["Fly|Ride"] = 178.29, ["Neon"] = 259.88, ["Neon|Ride"] = 273, ["Neon|Fly|Ride"] = 712.58, ["Mega"] = 2305.42, ["Mega|Ride"] = 2767.82, ["Mega|Fly|Ride"] = 1626.86}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 25.88, ["Fly"] = 70.46, ["Ride"] = 29.33, ["Fly|Ride"] = 69.65, ["Neon"] = 200.84, ["Neon|Ride"] = 115.4, ["Neon|Fly|Ride"] = 192.56, ["Mega"] = 1016.21, ["Mega|Ride"] = 814.97, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 3.94, ["Fly"] = 59.64, ["Ride"] = 27.56, ["Fly|Ride"] = 59.07, ["Neon"] = 34.12, ["Neon|Ride"] = 56.06, ["Neon|Fly|Ride"] = 154.62, ["Mega"] = 157.5, ["Mega|Fly"] = 918.75, ["Mega|Ride"] = 222.21, ["Mega|Fly|Ride"] = 314.94}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 11.21, ["Fly"] = 137.8, ["Ride"] = 26.62, ["Fly|Ride"] = 64.32, ["Neon"] = 102.47, ["Neon|Ride"] = 108.47, ["Neon|Fly|Ride"] = 160.13, ["Mega"] = 714.7, ["Mega|Ride"] = 507.45, ["Mega|Fly|Ride"] = 547.43}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 19.3, ["Fly"] = 26.25, ["Ride"] = 23.29, ["Fly|Ride"] = 50.73, ["Neon"] = 202.89, ["Neon|Ride"] = 145.69, ["Neon|Fly|Ride"] = 141.69, ["Mega|Fly|Ride"] = 582.75}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 210}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 24.69, ["Ride"] = 129.94, ["Neon"] = 131.25, ["Neon|Ride"] = 205.19, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 547.43, ["Mega|Fly|Ride"] = 782.25}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 220.92, ["Fly"] = 462.68, ["Ride"] = 443.63, ["Fly|Ride"] = 1537.13, ["Neon"] = 1229.53}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 36.66, ["Fly"] = 212.01, ["Ride"] = 91.88, ["Fly|Ride"] = 178.29, ["Neon"] = 219.19, ["Neon|Ride"] = 409.86, ["Neon|Fly|Ride"] = 480.88, ["Mega"] = 905.62, ["Mega|Ride"] = 2137.13, ["Mega|Fly|Ride"] = 1182.01}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 984.38, ["Fly"] = 1152.97, ["Ride"] = 918.75, ["Fly|Ride"] = 1015.63, ["Neon|Fly"] = 3986.83, ["Neon|Ride"] = 3118.69, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 11733.75}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 355.06, ["Fly"] = 462.68, ["Ride"] = 378, ["Fly|Ride"] = 393.75, ["Neon"] = 2834.27, ["Neon|Ride"] = 2049.21, ["Neon|Fly|Ride"] = 1916.36, ["Mega"] = 8098.4, ["Mega|Fly|Ride"] = 6298.69}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 60.67}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.5}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 9.49, ["Fly"] = 55.38, ["Ride"] = 23.66, ["Fly|Ride"] = 51.19, ["Neon"] = 78.75, ["Neon|Fly"] = 163.95, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 166.69, ["Mega"] = 437.26, ["Mega|Ride"] = 683.76, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 262.29, ["Fly"] = 411.28, ["Ride"] = 339.05, ["Fly|Ride"] = 426.24, ["Neon"] = 1079.95, ["Neon|Ride"] = 883.58, ["Neon|Fly|Ride"] = 1073.09, ["Mega|Ride"] = 3280.37, ["Mega|Fly|Ride"] = 2756.25}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 13.13}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 164.52, ["Ride"] = 209.9, ["Fly|Ride"] = 321.57, ["Neon"] = 674.14, ["Neon|Fly"] = 1709.05, ["Neon|Ride"] = 684.28, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 9841.09, ["Mega|Ride"] = 11661.69, ["Mega|Fly|Ride"] = 2569.96}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 129.57, ["Ride"] = 128.63, ["Fly|Ride"] = 172.86, ["Neon"] = 670.1, ["Neon|Ride"] = 1005.38, ["Neon|Fly|Ride"] = 913.5, ["Mega|Fly|Ride"] = 2406.98}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 4.55, ["Ride"] = 30.75, ["Fly|Ride"] = 167.03, ["Neon"] = 39.23, ["Neon|Ride"] = 85.31, ["Neon|Fly|Ride"] = 191.62, ["Mega"] = 264.75, ["Mega|Ride"] = 492.07, ["Mega|Fly|Ride"] = 809.86}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 12.99, ["Fly"] = 63, ["Ride"] = 29.3, ["Fly|Ride"] = 69.57, ["Neon"] = 177.19, ["Neon|Ride"] = 109.78, ["Neon|Fly|Ride"] = 131.25, ["Mega|Ride"] = 797.55, ["Mega|Fly|Ride"] = 581.25}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 23.69, ["Fly"] = 102.31, ["Ride"] = 44.61, ["Fly|Ride"] = 109.65, ["Neon"] = 68.66, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 255.94, ["Mega"] = 464.5, ["Mega|Ride"] = 493.97, ["Mega|Fly|Ride"] = 685.82}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 9.28, ["Fly"] = 94.5, ["Ride"] = 52.5, ["Fly|Ride"] = 170.6, ["Neon"] = 20.51, ["Neon|Fly"] = 208.81, ["Neon|Ride"] = 64.79, ["Neon|Fly|Ride"] = 155.29, ["Mega"] = 151.1, ["Mega|Fly"] = 306.52, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 252.29}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 268.95, ["Ride"] = 280.27, ["Fly|Ride"] = 368.88, ["Neon"] = 1608.64, ["Neon|Ride"] = 1231.07, ["Neon|Fly|Ride"] = 1286.38, ["Mega|Fly|Ride"] = 5194.25}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 135.73, ["Fly"] = 549.06, ["Ride"] = 203.44, ["Fly|Ride"] = 342.23, ["Neon"] = 843.27, ["Neon|Ride"] = 616.14, ["Neon|Fly|Ride"] = 1231.05, ["Mega"] = 9841.09, ["Mega|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 3444.39}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 75.51, ["Fly"] = 167.45, ["Ride"] = 101.73, ["Fly|Ride"] = 184.38, ["Neon"] = 354.38, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 479.1, ["Mega|Fly|Ride"] = 1439.28}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 13.13, ["Ride"] = 55.35, ["Fly|Ride"] = 273.58, ["Neon|Ride"] = 586.1, ["Neon|Fly|Ride"] = 479.1, ["Mega|Ride"] = 408.5, ["Mega|Fly|Ride"] = 1640.19}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 13.55, ["Fly"] = 75.63, ["Ride"] = 39.27, ["Fly|Ride"] = 96.33, ["Neon"] = 77.39, ["Neon|Fly"] = 204.93, ["Neon|Ride"] = 102.55, ["Neon|Fly|Ride"] = 192.57, ["Mega"] = 318.17, ["Mega|Fly"] = 525, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 450.21}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.94, ["Fly"] = 47.31, ["Ride"] = 19.69, ["Fly|Ride"] = 81.99, ["Neon"] = 21, ["Neon|Ride"] = 41.05, ["Neon|Fly|Ride"] = 130.3, ["Mega"] = 131.25, ["Mega|Ride"] = 158.52, ["Mega|Fly|Ride"] = 242.82}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 958.13, ["Fly"] = 1082.72, ["Ride"] = 943.69, ["Fly|Ride"] = 951.37, ["Neon"] = 3018.94, ["Neon|Ride"] = 2852.62, ["Neon|Fly|Ride"] = 2413.69, ["Mega|Fly|Ride"] = 8083.06}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 393.75, ["Ride"] = 453.1, ["Fly|Ride"] = 524.61, ["Neon"] = 1382.73, ["Neon|Ride"] = 1290.48, ["Neon|Fly|Ride"] = 1916.36, ["Mega"] = 10251.13, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 82.43, ["Ride"] = 103.69, ["Fly|Ride"] = 198.79, ["Neon"] = 339.94, ["Neon|Ride"] = 301.46, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 1567.7, ["Mega|Fly|Ride"] = 1576.31}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 262.5, ["Fly"] = 356.79, ["Ride"] = 237.38, ["Fly|Ride"] = 273.58, ["Neon|Ride"] = 1384.49, ["Neon|Fly|Ride"] = 1053.59, ["Mega"] = 10251.13, ["Mega|Fly|Ride"] = 5118.75}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 26.25, ["Fly"] = 137.8, ["Ride"] = 32.13, ["Fly|Ride"] = 69.76, ["Neon"] = 131.25, ["Neon|Ride"] = 212.3, ["Neon|Fly|Ride"] = 229.69, ["Mega|Fly|Ride"] = 615.56}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 220.89, ["Ride"] = 280.74, ["Fly|Ride"] = 489.57, ["Neon"] = 1419.05, ["Neon|Ride"] = 942.38, ["Neon|Fly|Ride"] = 1010.63, ["Mega"] = 4080.25, ["Mega|Ride"] = 4237.83, ["Mega|Fly|Ride"] = 3818.31}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 57.75, ["Fly"] = 76.13, ["Ride"] = 62.31, ["Fly|Ride"] = 130.6, ["Neon|Ride"] = 512.95, ["Neon|Fly|Ride"] = 547.84, ["Mega|Fly|Ride"] = 1233.75}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1659.5, ["Ride"] = 1679.34, ["Fly|Ride"] = 1735.69, ["Neon|Ride"] = 10768.89, ["Neon|Fly|Ride"] = 5402.31, ["Mega"] = 49205.39, ["Mega|Fly|Ride"] = 23236.23}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 13.53, ["Fly"] = 102.83, ["Ride"] = 60.64, ["Fly|Ride"] = 98.37, ["Neon"] = 61.57, ["Neon|Fly"] = 185.77, ["Neon|Ride"] = 98.02, ["Neon|Fly|Ride"] = 261.92, ["Mega"] = 310.01, ["Mega|Fly"] = 561.75, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 389.82}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 49.49, ["Fly"] = 119.1, ["Ride"] = 74.04, ["Fly|Ride"] = 157.5, ["Neon"] = 223.13, ["Neon|Ride"] = 102.6, ["Neon|Fly|Ride"] = 304.5, ["Mega"] = 880.59, ["Mega|Ride"] = 1003.59, ["Mega|Fly|Ride"] = 957.47}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 82.19, ["Fly"] = 91.76, ["Ride"] = 91.88, ["Fly|Ride"] = 86.63, ["Neon|Ride"] = 465.76, ["Neon|Fly|Ride"] = 354.38, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 1371.61, ["Ride"] = 2313.29, ["Fly|Ride"] = 1170.75, ["Neon|Fly|Ride"] = 7386.35, ["Mega|Fly|Ride"] = 20595.37}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 540.1, ["Fly"] = 820.51, ["Ride"] = 670.1, ["Fly|Ride"] = 666.02, ["Neon"] = 2458.94, ["Neon|Fly|Ride"] = 2692.8, ["Mega|Fly|Ride"] = 16907.87}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 85.2, ["Fly"] = 157.5, ["Ride"] = 185.09, ["Fly|Ride"] = 203.13, ["Neon"] = 444.29, ["Neon|Fly"] = 614.77, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 574.51, ["Mega"] = 4100.46, ["Mega|Ride"] = 2590.47, ["Mega|Fly|Ride"] = 2152.76}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 7.5, ["Ride"] = 22.68, ["Fly|Ride"] = 91.68, ["Neon"] = 87.94, ["Neon|Fly"] = 137.31, ["Neon|Ride"] = 100.01, ["Neon|Fly|Ride"] = 180.56, ["Mega|Ride"] = 747.53, ["Mega|Fly|Ride"] = 1367.51}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 32.82, ["Fly"] = 101.8, ["Ride"] = 48.43, ["Fly|Ride"] = 106.02, ["Neon"] = 196.88, ["Neon|Fly"] = 409.86, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 288.75, ["Mega|Ride"] = 1189.14, ["Mega|Fly|Ride"] = 950.3}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 721.88, ["Ride"] = 874.13, ["Fly|Ride"] = 918.75, ["Neon"] = 3004.14, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2690.63, ["Mega|Fly|Ride"] = 9723}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 918.75}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 5895.62, ["Ride"] = 4987.5, ["Fly|Ride"] = 5118.75, ["Neon"] = 42000, ["Neon|Ride"] = 29402.76, ["Neon|Fly|Ride"] = 23937.9, ["Mega|Fly|Ride"] = 87476.92}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 254.63, ["Fly"] = 406.82, ["Ride"] = 292.69, ["Fly|Ride"] = 367.5, ["Neon"] = 1639.37, ["Neon|Fly|Ride"] = 2051.77, ["Mega"] = 6150.68, ["Mega|Fly|Ride"] = 6148.54}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 83.5, ["Fly"] = 274.54, ["Ride"] = 100.95, ["Fly|Ride"] = 336, ["Neon"] = 409.86, ["Neon|Ride"] = 512.95, ["Neon|Fly|Ride"] = 1641.43, ["Mega|Fly|Ride"] = 2868.81}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 18.38, ["Fly"] = 96.67, ["Ride"] = 26.25, ["Fly|Ride"] = 71.73, ["Neon"] = 123.31, ["Neon|Fly"] = 1229.47, ["Neon|Ride"] = 104.9, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 655.07, ["Mega|Ride"] = 715.54, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 11.81, ["Fly"] = 27.78, ["Ride"] = 27.54, ["Fly|Ride"] = 44.34, ["Neon"] = 204.93, ["Neon|Fly"] = 273.58, ["Neon|Ride"] = 308.05, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 2173.25}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 16.35, ["Fly"] = 274.54, ["Ride"] = 31.5, ["Fly|Ride"] = 140.44, ["Neon"] = 154.88, ["Neon|Ride"] = 143.07, ["Neon|Fly|Ride"] = 147.75, ["Mega"] = 670.69, ["Mega|Ride"] = 521.07, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 4.05, ["Fly"] = 21, ["Ride"] = 21.93, ["Fly|Ride"] = 52.5, ["Neon"] = 22.91, ["Neon|Fly"] = 338.14, ["Neon|Ride"] = 49.19, ["Neon|Fly|Ride"] = 524.99, ["Mega"] = 273.73, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 307.79}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 24.88, ["Ride"] = 43.31, ["Fly|Ride"] = 96.33, ["Neon"] = 178.29, ["Neon|Fly"] = 819.7, ["Neon|Ride"] = 221.61, ["Neon|Fly|Ride"] = 328.06, ["Mega"] = 764.74, ["Mega|Ride"] = 656.1, ["Mega|Fly|Ride"] = 957.47}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 360.51, ["Fly"] = 386.34, ["Ride"] = 328.13, ["Fly|Ride"] = 411.65, ["Neon"] = 1246.88, ["Neon|Fly"] = 1450.84, ["Neon|Ride"] = 1217.74, ["Neon|Fly|Ride"] = 1239, ["Mega"] = 7875, ["Mega|Fly"] = 4824.19, ["Mega|Ride"] = 4510.5, ["Mega|Fly|Ride"] = 4812.91}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.1, ["Fly"] = 15.64, ["Ride"] = 15.47, ["Fly|Ride"] = 27.68, ["Neon"] = 19.67, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 69.23, ["Mega"] = 131.25, ["Mega|Ride"] = 538.33, ["Mega|Fly|Ride"] = 243.77}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 41.13, ["Fly"] = 95.24, ["Ride"] = 74.74, ["Fly|Ride"] = 126, ["Neon"] = 155.82, ["Neon|Fly"] = 289.27, ["Neon|Ride"] = 200.07, ["Neon|Fly|Ride"] = 270.67, ["Mega"] = 577.5, ["Mega|Fly"] = 820.11, ["Mega|Ride"] = 572.24, ["Mega|Fly|Ride"] = 590.56}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 800.63, ["Fly"] = 971.59, ["Ride"] = 784.6, ["Fly|Ride"] = 809.45, ["Neon|Ride"] = 1603.88, ["Neon|Fly|Ride"] = 1443.74, ["Mega|Fly|Ride"] = 3780}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 30.95, ["Fly"] = 91.88, ["Ride"] = 47.44, ["Fly|Ride"] = 75.41, ["Neon"] = 204.93, ["Neon|Ride"] = 178.52, ["Neon|Fly|Ride"] = 228.38, ["Mega"] = 1575, ["Mega|Fly|Ride"] = 748.13}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 315, ["Fly"] = 324.84, ["Ride"] = 288.65, ["Fly|Ride"] = 353.05, ["Neon|Fly|Ride"] = 1232.86, ["Mega|Fly|Ride"] = 13832.45}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 150.94, ["Fly"] = 240.59, ["Ride"] = 183.75, ["Fly|Ride"] = 198.38, ["Neon"] = 627.29, ["Neon|Ride"] = 769.55, ["Neon|Fly|Ride"] = 684.28, ["Mega|Fly|Ride"] = 3280.37}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 713.1, ["Ride"] = 656.25, ["Fly|Ride"] = 851.34, ["Neon|Ride"] = 2598.75, ["Neon|Fly|Ride"] = 2941.21, ["Mega|Fly|Ride"] = 5906.25}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 22.47, ["Ride"] = 39.98, ["Fly|Ride"] = 108.9, ["Neon"] = 78.08, ["Neon|Fly"] = 276.56, ["Neon|Ride"] = 99.24, ["Neon|Fly|Ride"] = 137.38, ["Mega"] = 272.7, ["Mega|Ride"] = 352.74, ["Mega|Fly|Ride"] = 511.54}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 3176.25, ["Fly"] = 3590.9, ["Ride"] = 3936.19, ["Fly|Ride"] = 3022.98, ["Neon"] = 13662.03, ["Neon|Fly|Ride"] = 6286.85, ["Mega|Fly|Ride"] = 25058.25}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 91.88, ["Fly"] = 131.25, ["Ride"] = 137.8, ["Fly|Ride"] = 173.86, ["Neon"] = 545.1, ["Neon|Ride"] = 547.84, ["Neon|Fly|Ride"] = 520.14, ["Mega|Fly|Ride"] = 2231.25}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 20.57, ["Ride"] = 18.12, ["Fly|Ride"] = 45.48, ["Neon"] = 21, ["Neon|Fly"] = 63.51, ["Neon|Ride"] = 41.91, ["Neon|Fly|Ride"] = 90.57, ["Mega"] = 143.25, ["Mega|Fly"] = 446.25, ["Mega|Ride"] = 158.9, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 2.1, ["Ride"] = 27.68, ["Fly|Ride"] = 57.63, ["Neon"] = 24.94, ["Neon|Ride"] = 53.36, ["Neon|Fly|Ride"] = 266.44, ["Mega"] = 164.7, ["Mega|Ride"] = 199.48, ["Mega|Fly|Ride"] = 278.35}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 71.99, ["Fly"] = 152.19, ["Ride"] = 49.38, ["Fly|Ride"] = 51.97, ["Neon|Ride"] = 376.5, ["Neon|Fly|Ride"] = 302.65, ["Mega|Fly|Ride"] = 1093.81}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 1028.2, ["Ride"] = 1375.81, ["Fly|Ride"] = 1234.93, ["Neon"] = 4371.98}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 5775, ["Ride"] = 7017.33, ["Fly|Ride"] = 6299.99}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 30.09, ["Fly"] = 35.43, ["Ride"] = 27.57, ["Fly|Ride"] = 43.32, ["Neon"] = 547.15, ["Neon|Ride"] = 273.93, ["Neon|Fly|Ride"] = 180.44, ["Mega"] = 2428.13, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 14.43, ["Fly"] = 31.5, ["Ride"] = 26.25, ["Fly|Ride"] = 85.32, ["Neon"] = 65.63, ["Neon|Ride"] = 87.59, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 642.48, ["Mega|Ride"] = 612.1, ["Mega|Fly|Ride"] = 500}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 69.56, ["Fly"] = 157.49, ["Ride"] = 62.92, ["Fly|Ride"] = 116.71, ["Neon"] = 459.38, ["Neon|Ride"] = 410.37, ["Neon|Fly|Ride"] = 308.05, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 227.43, ["Fly"] = 295.1, ["Ride"] = 236.25, ["Fly|Ride"] = 284.82, ["Neon|Ride"] = 977.79, ["Neon|Fly|Ride"] = 1082.82, ["Mega"] = 10251.13, ["Mega|Fly|Ride"] = 3688.67}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.84, ["Ride"] = 32.7, ["Fly|Ride"] = 86.52, ["Neon"] = 23.58, ["Neon|Fly"] = 656.24, ["Neon|Ride"] = 68.25, ["Mega"] = 133.88, ["Mega|Ride"] = 164.04, ["Mega|Fly|Ride"] = 286.01}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 196.88, ["Fly"] = 261.18, ["Ride"] = 224.69, ["Fly|Ride"] = 259.88, ["Neon"] = 721.88, ["Neon|Ride"] = 946.08, ["Neon|Fly|Ride"] = 958.18, ["Mega|Fly|Ride"] = 3382.04}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 2.63, ["Fly"] = 40.11, ["Ride"] = 14.43, ["Fly|Ride"] = 40.69, ["Neon"] = 22.72, ["Neon|Fly"] = 123.03, ["Neon|Ride"] = 32.62, ["Neon|Fly|Ride"] = 106.63, ["Mega"] = 414.16, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 210, ["Fly"] = 268.82, ["Ride"] = 249.38, ["Fly|Ride"] = 261.29, ["Neon|Fly|Ride"] = 1107.59, ["Mega"] = 10251.13, ["Mega|Ride"] = 4100.46, ["Mega|Fly|Ride"] = 4073.82}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 13.13, ["Fly"] = 36.01, ["Ride"] = 26.79, ["Fly|Ride"] = 52.5, ["Neon"] = 61.42, ["Neon|Fly"] = 292.69, ["Neon|Ride"] = 97.48, ["Neon|Fly|Ride"] = 194.91, ["Mega|Ride"] = 615.08, ["Mega|Fly|Ride"] = 449.5}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.1, ["Fly"] = 68.91, ["Ride"] = 22.93, ["Fly|Ride"] = 59.07, ["Neon"] = 9.19, ["Neon|Fly"] = 170.45, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 176.78, ["Mega"] = 76.67, ["Mega|Ride"] = 99.74, ["Mega|Fly|Ride"] = 185.71}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.63, ["Neon"] = 3.84, ["Neon|Ride"] = 41.05, ["Mega"] = 22.98, ["Mega|Ride"] = 137.08, ["Mega|Fly|Ride"] = 410.06}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 2.1, ["Fly"] = 52.48, ["Ride"] = 22.56, ["Fly|Ride"] = 213.13, ["Neon"] = 6.03, ["Neon|Ride"] = 40.16, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 68.16, ["Mega|Fly"] = 153694.61, ["Mega|Ride"] = 138.26, ["Mega|Fly|Ride"] = 158.45}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 67.55, ["Fly"] = 138.81, ["Ride"] = 114.97, ["Fly|Ride"] = 213.94, ["Neon"] = 308.61, ["Neon|Ride"] = 373.44, ["Neon|Fly|Ride"] = 340.8, ["Mega|Ride"] = 1312.17, ["Mega|Fly|Ride"] = 1085.82}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 33.59, ["Ride"] = 15.65, ["Fly|Ride"] = 103.47, ["Neon"] = 4.32, ["Neon|Ride"] = 30.79, ["Neon|Fly|Ride"] = 72.7, ["Mega"] = 129.94, ["Mega|Ride"] = 137.45, ["Mega|Fly|Ride"] = 257.24}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 11.73, ["Neon"] = 71.92, ["Neon|Ride"] = 210, ["Mega|Ride"] = 539.22}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 45.18, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 15.89, ["Mega|Ride"] = 55.58, ["Mega|Fly|Ride"] = 206.63}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 41.13, ["Ride"] = 14.6, ["Fly|Ride"] = 33.44, ["Neon"] = 2.1, ["Neon|Fly"] = 12.69, ["Neon|Ride"] = 12.13, ["Neon|Fly|Ride"] = 31.08, ["Mega"] = 13.77, ["Mega|Fly"] = 39.99, ["Mega|Ride"] = 19.28, ["Mega|Fly|Ride"] = 48.17}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 52.45, ["Ride"] = 12.45, ["Fly|Ride"] = 39.16, ["Neon"] = 2.63, ["Neon|Fly"] = 39.26, ["Neon|Ride"] = 15.61, ["Neon|Fly|Ride"] = 45.31, ["Mega"] = 28.77, ["Mega|Fly"] = 154.47, ["Mega|Ride"] = 33.43, ["Mega|Fly|Ride"] = 108.81}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Fly|Ride"] = 103.03, ["Neon"] = 2.1, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 102.6, ["Mega"] = 16.21, ["Mega|Ride"] = 120.62, ["Mega|Fly|Ride"] = 275.57}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 118.13, ["Ride"] = 19.68, ["Fly|Ride"] = 107.63, ["Neon"] = 3.94, ["Neon|Fly"] = 167.95, ["Neon|Ride"] = 20.99, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 26.17, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 57.43, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly|Ride"] = 205.19, ["Mega"] = 18.6, ["Mega|Ride"] = 99.65}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 2.52, ["Fly"] = 68.91, ["Ride"] = 19.69, ["Fly|Ride"] = 70.12, ["Neon"] = 7.77, ["Neon|Fly"] = 68.16, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 70.21, ["Mega"] = 98.24, ["Mega|Fly"] = 155.3, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 167.9}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 47.31, ["Neon"] = 2.1, ["Neon|Ride"] = 78.66, ["Neon|Fly|Ride"] = 157.38, ["Mega"] = 13.32, ["Mega|Ride"] = 28.88, ["Mega|Fly|Ride"] = 184.54}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.1, ["Fly|Ride"] = 524.99, ["Neon"] = 15.74, ["Mega"] = 137.38, ["Mega|Fly"] = 314.99, ["Mega|Ride"] = 342.41, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Neon"] = 11.64, ["Mega"] = 105, ["Mega|Ride"] = 102.53, ["Mega|Fly|Ride"] = 537.62}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 24.94, ["Neon"] = 3.84, ["Neon|Ride"] = 26.66, ["Neon|Fly|Ride"] = 137.48, ["Mega"] = 19.59, ["Mega|Ride"] = 49.26}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.68, ["Ride"] = 15.45, ["Fly|Ride"] = 20.51, ["Neon"] = 2.1, ["Neon|Fly"] = 27.68, ["Neon|Ride"] = 12.88, ["Neon|Fly|Ride"] = 30.82, ["Mega"] = 11.71, ["Mega|Fly"] = 39.25, ["Mega|Ride"] = 18.38, ["Mega|Fly|Ride"] = 59.96}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.1, ["Fly"] = 72.19, ["Ride"] = 218.19, ["Fly|Ride"] = 104.98, ["Neon"] = 34.91, ["Neon|Ride"] = 41.05, ["Mega"] = 260.39, ["Mega|Ride"] = 236.15}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 18.27, ["Neon"] = 4.11, ["Neon|Ride"] = 25.76, ["Neon|Fly|Ride"] = 105, ["Mega"] = 28.66, ["Mega|Fly"] = 78.75, ["Mega|Ride"] = 71.77, ["Mega|Fly|Ride"] = 159.09}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 2.1, ["Neon"] = 9.91, ["Neon|Fly|Ride"] = 137.38, ["Mega"] = 82.08, ["Mega|Ride"] = 150.5, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.1, ["Fly"] = 262.49, ["Ride"] = 32.82, ["Fly|Ride"] = 43.32, ["Neon"] = 12.99, ["Neon|Fly"] = 102.47, ["Neon|Fly|Ride"] = 105, ["Mega"] = 131.25, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 166.69}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 12.6, ["Ride"] = 11.95, ["Fly|Ride"] = 26.17, ["Neon"] = 2.1, ["Neon|Fly"] = 14.24, ["Neon|Ride"] = 11.96, ["Neon|Fly|Ride"] = 27.58, ["Mega"] = 14.44, ["Mega|Fly"] = 28.25, ["Mega|Ride"] = 22.57, ["Mega|Fly|Ride"] = 46.78}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 27.46, ["Ride"] = 20.51, ["Fly|Ride"] = 137.31, ["Neon"] = 11.46, ["Neon|Ride"] = 110.77, ["Neon|Fly|Ride"] = 108.75, ["Mega"] = 78.75, ["Mega|Ride"] = 154.04, ["Mega|Fly|Ride"] = 275.57}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 21.77, ["Fly|Ride"] = 59.06, ["Neon"] = 54.52, ["Neon|Ride"] = 67.1, ["Neon|Fly|Ride"] = 248.07, ["Mega"] = 203.44, ["Mega|Ride"] = 282.72, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 15.44, ["Ride"] = 12.99, ["Fly|Ride"] = 26.17, ["Neon"] = 3.94, ["Neon|Fly"] = 23.62, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 45.04, ["Mega|Fly"] = 1312.5, ["Mega|Ride"] = 117.9, ["Mega|Fly|Ride"] = 98.14}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.1, ["Fly"] = 171.73, ["Ride"] = 28.72, ["Neon"] = 3.81, ["Neon|Ride"] = 43.31, ["Neon|Fly|Ride"] = 97.06, ["Mega"] = 71.8, ["Mega|Fly"] = 164.04, ["Mega|Ride"] = 109.7, ["Mega|Fly|Ride"] = 358.81}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 26.66, ["Fly|Ride"] = 52.5, ["Neon"] = 5.2, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 137.48, ["Mega"] = 39.38, ["Mega|Ride"] = 137.38, ["Mega|Fly|Ride"] = 302.43}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 16.72, ["Neon"] = 2.1, ["Neon|Fly"] = 41.01, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 100.96, ["Mega"] = 19.49, ["Mega|Ride"] = 40.69, ["Mega|Fly|Ride"] = 135.85}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 96.67, ["Ride"] = 22.57, ["Fly|Ride"] = 41.91, ["Neon"] = 2.63, ["Neon|Fly"] = 55.35, ["Neon|Ride"] = 20.53, ["Neon|Fly|Ride"] = 75.48, ["Mega"] = 77.24, ["Mega|Ride"] = 81.38, ["Mega|Fly|Ride"] = 198.89}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 68.16, ["Fly|Ride"] = 43.32, ["Neon"] = 3.82, ["Neon|Ride"] = 43.32, ["Mega"] = 38.93, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 24.94, ["Ride"] = 14.89, ["Fly|Ride"] = 44.88, ["Neon"] = 3.84, ["Neon|Fly"] = 79.97, ["Neon|Ride"] = 19.84, ["Neon|Fly|Ride"] = 83.99, ["Mega"] = 91.88, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 7.6, ["Ride"] = 67.99, ["Neon"] = 36.66, ["Mega"] = 133.88, ["Mega|Fly"] = 380.63, ["Mega|Ride"] = 205.98, ["Mega|Fly|Ride"] = 820.11}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Fly"] = 68.91, ["Ride"] = 16.7, ["Fly|Ride"] = 137.91, ["Neon"] = 18.56, ["Neon|Fly"] = 103.72, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 302.43, ["Mega|Fly"] = 420, ["Mega|Ride"] = 145.48, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 4.13, ["Fly"] = 22.62, ["Ride"] = 19.55, ["Fly|Ride"] = 39, ["Neon"] = 19.48, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 28.14, ["Neon|Fly|Ride"] = 77.44, ["Mega"] = 274.53, ["Mega|Fly"] = 409.04, ["Mega|Ride"] = 410.82, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 3.42, ["Fly"] = 110.93, ["Fly|Ride"] = 137.82, ["Neon"] = 30.98, ["Mega"] = 177.28, ["Mega|Ride"] = 236.24}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 12.12, ["Ride"] = 131.25, ["Neon"] = 110.15, ["Neon|Ride"] = 230.76, ["Mega|Fly|Ride"] = 794.07}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 4.55, ["Ride"] = 64.79, ["Neon"] = 39.1, ["Neon|Ride"] = 125.71, ["Mega"] = 253.32, ["Mega|Ride"] = 213.24}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 5.03, ["Ride"] = 30.19, ["Fly|Ride"] = 120.75, ["Neon"] = 47.65, ["Neon|Ride"] = 157.4, ["Neon|Fly|Ride"] = 191.86, ["Mega"] = 245.02, ["Mega|Ride"] = 248.06, ["Mega|Fly|Ride"] = 355.04}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 64.98, ["Mega"] = 22.32, ["Mega|Ride"] = 137.38, ["Mega|Fly|Ride"] = 148.32}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 40}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 3.93, ["Fly"] = 22.91, ["Ride"] = 20.04, ["Fly|Ride"] = 45.94, ["Neon"] = 34.04, ["Neon|Ride"] = 40.47, ["Neon|Fly|Ride"] = 100.38, ["Mega"] = 305.49, ["Mega|Fly"] = 328.06, ["Mega|Ride"] = 344.43, ["Mega|Fly|Ride"] = 253.62}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 19.56, ["Neon"] = 2.1, ["Neon|Ride"] = 26.6, ["Mega"] = 27.24, ["Mega|Fly"] = 137.38, ["Mega|Ride"] = 55.37, ["Mega|Fly|Ride"] = 129.94}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 23.6, ["Fly|Ride"] = 273.58, ["Neon"] = 3.94, ["Neon|Ride"] = 35.32, ["Neon|Fly|Ride"] = 404.88, ["Mega"] = 39.29, ["Mega|Ride"] = 71.63, ["Mega|Fly|Ride"] = 133.88}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 48.35, ["Ride"] = 15.68, ["Fly|Ride"] = 55.13, ["Neon"] = 6.43, ["Neon|Ride"] = 50.17, ["Neon|Fly|Ride"] = 117.06, ["Mega"] = 141.75, ["Mega|Ride"] = 157.49, ["Mega|Fly|Ride"] = 161.65}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 4.11, ["Ride"] = 36.66, ["Fly|Ride"] = 58.42, ["Neon"] = 34.94, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 212.02, ["Mega"] = 325.42, ["Mega|Ride"] = 269.96, ["Mega|Fly|Ride"] = 410.06}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Fly"] = 19.55, ["Ride"] = 32.81, ["Neon"] = 3.76, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 14.23, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 47.46, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 20.9, ["Ride"] = 16.05, ["Fly|Ride"] = 273227.01, ["Neon"] = 3.81, ["Neon|Fly"] = 68.66, ["Neon|Ride"] = 27.71, ["Neon|Fly|Ride"] = 69.23, ["Mega"] = 26.63, ["Mega|Ride"] = 47.94, ["Mega|Fly|Ride"] = 124.58}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 27.46, ["Ride"] = 14.69, ["Fly|Ride"] = 34.13, ["Neon"] = 8.29, ["Neon|Fly"] = 68.66, ["Neon|Ride"] = 15.65, ["Neon|Fly|Ride"] = 52.49, ["Mega"] = 37.09, ["Mega|Fly"] = 137.38, ["Mega|Ride"] = 51.19, ["Mega|Fly|Ride"] = 200.59}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 210, ["Ride"] = 32.16, ["Fly|Ride"] = 146.35, ["Neon"] = 3.94, ["Neon|Ride"] = 33.12, ["Neon|Fly|Ride"] = 158.45, ["Mega"] = 23.07, ["Mega|Fly"] = 123.36, ["Mega|Ride"] = 72.1, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 3.84, ["Neon|Ride"] = 164.16, ["Neon|Fly|Ride"] = 122.1, ["Mega"] = 18.27, ["Mega|Fly"] = 106.45, ["Mega|Ride"] = 86.46, ["Mega|Fly|Ride"] = 144.75}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 32.45, ["Ride"] = 18.38, ["Fly|Ride"] = 76.85, ["Neon"] = 2.52, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 22.37, ["Neon|Fly|Ride"] = 65, ["Mega"] = 18.8, ["Mega|Fly"] = 61.52, ["Mega|Ride"] = 38.07, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Ride"] = 48.35, ["Neon"] = 2.1, ["Neon|Ride"] = 68.75, ["Mega"] = 27.81, ["Mega|Ride"] = 211.19}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.63, ["Neon"] = 2.43, ["Neon|Ride"] = 154.62, ["Neon|Fly|Ride"] = 420, ["Mega"] = 21, ["Mega|Ride"] = 154.47}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 27.57, ["Ride"] = 22.56, ["Fly|Ride"] = 57.39, ["Neon"] = 3.93, ["Neon|Fly"] = 55.35, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 40.4, ["Mega"] = 44.13, ["Mega|Ride"] = 55.12, ["Mega|Fly|Ride"] = 89.7}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 11.76, ["Ride"] = 138.29, ["Neon"] = 95.81, ["Mega"] = 315, ["Mega|Ride"] = 429.19, ["Mega|Fly|Ride"] = 545.37}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.58, ["Fly"] = 6562.5, ["Ride"] = 56.24, ["Neon"] = 54.76, ["Neon|Ride"] = 203.14, ["Mega"] = 1561.26, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 2.1, ["Ride"] = 26.24, ["Fly|Ride"] = 409.86, ["Neon"] = 32.05, ["Mega"] = 295.25, ["Mega|Ride"] = 340.07, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 11.15, ["Ride"] = 15.38, ["Fly|Ride"] = 24.24, ["Neon"] = 2.1, ["Neon|Fly"] = 11.61, ["Neon|Ride"] = 12.26, ["Neon|Fly|Ride"] = 28.59, ["Mega"] = 103.85, ["Mega|Fly"] = 22.32, ["Mega|Ride"] = 21.69, ["Mega|Fly|Ride"] = 48.57}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Fly"] = 118.12, ["Ride"] = 57.39, ["Fly|Ride"] = 109.65, ["Neon"] = 3.94, ["Neon|Fly"] = 89.87, ["Neon|Ride"] = 31.82, ["Neon|Fly|Ride"] = 684.28, ["Mega"] = 51.66, ["Mega|Ride"] = 113.8}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Fly"] = 68.91, ["Ride"] = 31.4, ["Neon"] = 2.1, ["Neon|Fly"] = 30.78, ["Neon|Ride"] = 20.69, ["Neon|Fly|Ride"] = 55.6, ["Mega"] = 15.39, ["Mega|Fly"] = 83.16, ["Mega|Ride"] = 71.6, ["Mega|Fly|Ride"] = 130.92}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 3.29, ["Neon|Ride"] = 102.6, ["Mega"] = 27.57, ["Mega|Ride"] = 101.5, ["Mega|Fly|Ride"] = 151.73}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 3.15, ["Fly"] = 35.14, ["Ride"] = 22.62, ["Fly|Ride"] = 45.93, ["Neon"] = 10.5, ["Neon|Fly"] = 65.6, ["Neon|Ride"] = 36.05, ["Neon|Fly|Ride"] = 92.35, ["Mega"] = 208.85, ["Mega|Ride"] = 204.02, ["Mega|Fly|Ride"] = 342.41}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 173.44, ["Ride"] = 171.73, ["Fly|Ride"] = 819.7, ["Neon"] = 1012.32, ["Neon|Ride"] = 757.32, ["Mega"] = 8200.91, ["Mega|Fly|Ride"] = 3404.41}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Neon"] = 7.35, ["Neon|Ride"] = 82.08, ["Mega"] = 69.64, ["Mega|Ride"] = 108.38, ["Mega|Fly|Ride"] = 820.11}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 3.73, ["Fly"] = 63.03, ["Ride"] = 25.57, ["Neon"] = 30.01, ["Neon|Ride"] = 92.31, ["Neon|Fly|Ride"] = 164.16, ["Mega"] = 350.83, ["Mega|Ride"] = 511.54, ["Mega|Fly|Ride"] = 400}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 27.78, ["Ride"] = 13.7, ["Fly|Ride"] = 31.24, ["Neon"] = 6.36, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 29.76, ["Neon|Fly|Ride"] = 55.41, ["Mega"] = 49.67, ["Mega|Ride"] = 79.75, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 51.19, ["Ride"] = 19.68, ["Fly|Ride"] = 92.56, ["Neon"] = 6.02, ["Neon|Fly"] = 547.15, ["Neon|Ride"] = 78.47, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 96.87, ["Mega|Ride"] = 152.25, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 3.56, ["Fly"] = 23.4, ["Ride"] = 17.07, ["Fly|Ride"] = 35.44, ["Neon"] = 26.17, ["Neon|Fly"] = 98.85, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 74.8, ["Mega|Ride"] = 266.54, ["Mega|Fly|Ride"] = 410.06}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 6.96, ["Ride"] = 34.12, ["Fly|Ride"] = 249.58, ["Neon"] = 52.41, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 609.38, ["Mega"] = 337.03, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.1, ["Fly"] = 19.65, ["Ride"] = 14.76, ["Fly|Ride"] = 36.75, ["Neon"] = 18.38, ["Neon|Fly"] = 68.16, ["Neon|Ride"] = 53.36, ["Neon|Fly|Ride"] = 75.28, ["Mega"] = 157.5, ["Mega|Ride"] = 232.72, ["Mega|Fly|Ride"] = 218.22}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 65.29, ["Fly"] = 168.63, ["Ride"] = 86.85, ["Fly|Ride"] = 162.74, ["Neon"] = 346.32, ["Neon|Fly"] = 437.07, ["Neon|Ride"] = 384.95, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 2050.23}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 205.7, ["Fly"] = 329.03, ["Ride"] = 205.65, ["Fly|Ride"] = 273, ["Neon|Ride"] = 958.18, ["Neon|Fly|Ride"] = 1238.9, ["Mega"] = 10251.13, ["Mega|Fly|Ride"] = 3964.12}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 52.41, ["Fly"] = 100.63, ["Ride"] = 77.51, ["Fly|Ride"] = 111.78, ["Neon"] = 685.4, ["Neon|Ride"] = 328.11, ["Neon|Fly|Ride"] = 371.49, ["Mega|Ride"] = 1229.12, ["Mega|Fly|Ride"] = 1048.53}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 7.83, ["Fly"] = 96.67, ["Ride"] = 24.69, ["Fly|Ride"] = 138.01, ["Neon"] = 22.57, ["Neon|Ride"] = 69.57, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 158.82, ["Mega|Ride"] = 375.38, ["Mega|Fly|Ride"] = 262.65}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 11.79, ["Fly"] = 68.91, ["Ride"] = 36.75, ["Fly|Ride"] = 89.25, ["Neon"] = 72.09, ["Neon|Ride"] = 82.4, ["Mega"] = 353.07, ["Mega|Ride"] = 364.53, ["Mega|Fly|Ride"] = 396.65}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 31.49, ["Ride"] = 18.59, ["Fly|Ride"] = 35.44, ["Neon"] = 5.24, ["Neon|Fly"] = 25.36, ["Neon|Ride"] = 21.95, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 114.6, ["Mega|Fly"] = 154.88, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 455.64}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 6.57, ["Fly"] = 27.78, ["Ride"] = 25.36, ["Fly|Ride"] = 296.83, ["Neon"] = 91.12, ["Neon|Fly"] = 342.23, ["Neon|Ride"] = 159.23, ["Neon|Fly|Ride"] = 134.93, ["Mega"] = 1837.5, ["Mega|Ride"] = 616.88, ["Mega|Fly|Ride"] = 864.94}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 41.13, ["Ride"] = 14.69, ["Fly|Ride"] = 52.5, ["Neon"] = 15.63, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 27.71, ["Neon|Fly|Ride"] = 98.54, ["Mega"] = 187.69, ["Mega|Fly"] = 86.46, ["Mega|Ride"] = 200.79, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 2.5, ["Ride"] = 26.62, ["Fly|Ride"] = 328.13, ["Neon"] = 29.98, ["Neon|Ride"] = 55.41, ["Neon|Fly|Ride"] = 137.48, ["Mega"] = 207.38, ["Mega|Ride"] = 231.95, ["Mega|Fly|Ride"] = 421.87}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 15.44, ["Ride"] = 36.01, ["Neon"] = 2.1, ["Neon|Ride"] = 19.65, ["Neon|Fly|Ride"] = 47.31, ["Mega"] = 14.44, ["Mega|Fly"] = 41.02, ["Mega|Ride"] = 41.02, ["Mega|Fly|Ride"] = 207486.66}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 17.48, ["Ride"] = 18.05, ["Fly|Ride"] = 39.29, ["Neon"] = 12.18, ["Neon|Fly"] = 102.47, ["Neon|Ride"] = 31.16, ["Neon|Fly|Ride"] = 98, ["Mega"] = 77.47, ["Mega|Ride"] = 96.84, ["Mega|Fly|Ride"] = 206.73}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 3.84, ["Fly"] = 24.93, ["Ride"] = 18.52, ["Fly|Ride"] = 45.94, ["Neon"] = 27.68, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 119.02, ["Mega"] = 283.5, ["Mega|Ride"] = 191.71, ["Mega|Fly|Ride"] = 272.99}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 131.25, ["Fly"] = 274.54, ["Ride"] = 190.32, ["Fly|Ride"] = 265.38, ["Neon"] = 685.21, ["Neon|Ride"] = 494.34, ["Neon|Fly|Ride"] = 613.39, ["Mega|Fly|Ride"] = 3554.08}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 12.46, ["Ride"] = 30.86, ["Fly|Ride"] = 206.07, ["Neon"] = 43.32, ["Neon|Ride"] = 160.13, ["Neon|Fly|Ride"] = 376.56, ["Mega"] = 342.41, ["Mega|Ride"] = 296.63, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 18.41, ["Ride"] = 15.01, ["Fly|Ride"] = 43.32, ["Neon"] = 21.92, ["Neon|Ride"] = 49.26, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 308.44, ["Mega|Ride"] = 207.38, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 19.97, ["Ride"] = 41.32, ["Fly|Ride"] = 170.63, ["Neon"] = 89.16, ["Neon|Ride"] = 80.07, ["Neon|Fly|Ride"] = 464.03, ["Mega"] = 467.02, ["Mega|Fly"] = 820.11, ["Mega|Ride"] = 469.88, ["Mega|Fly|Ride"] = 682.75}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 5.1}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 5.15, ["Ride"] = 28.49, ["Neon"] = 24.71, ["Neon|Ride"] = 273.93, ["Neon|Fly|Ride"] = 615.55, ["Mega"] = 384.43, ["Mega|Ride"] = 304.5, ["Mega|Fly|Ride"] = 818.06}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 25.45, ["Fly"] = 35.49, ["Ride"] = 35.44, ["Fly|Ride"] = 57.78, ["Neon"] = 178.29, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 159.38, ["Neon|Fly|Ride"] = 135.97, ["Mega"] = 1777.56, ["Mega|Fly|Ride"] = 1777.56}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 20.56, ["Fly|Ride"] = 102.47, ["Neon"] = 6.09, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 106.25, ["Mega"] = 33.8, ["Mega|Fly"] = 273.73, ["Mega|Ride"] = 88.18, ["Mega|Fly|Ride"] = 225.25}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 3.83, ["Fly"] = 27.81, ["Ride"] = 23.66, ["Fly|Ride"] = 61.49, ["Neon"] = 45.45, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 230.76, ["Mega"] = 231.48, ["Mega|Fly"] = 385.02, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 302.43}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 17.36, ["Fly|Ride"] = 45.65, ["Neon"] = 15.28, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 31.41, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 144.38, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 209.9}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 34.35, ["Fly|Ride"] = 204.93, ["Neon"] = 2.78, ["Neon|Ride"] = 22.43, ["Neon|Fly|Ride"] = 410.37, ["Mega"] = 31.12, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 304.5}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 31.5, ["Fly"] = 51.45, ["Ride"] = 86.63, ["Neon"] = 252.07, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 581.63, ["Mega"] = 791.99, ["Mega|Ride"] = 957.47, ["Mega|Fly|Ride"] = 833.44}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 2.92, ["Ride"] = 26.25, ["Fly|Ride"] = 210, ["Neon"] = 72.19, ["Mega|Ride"] = 524.99, ["Mega|Fly|Ride"] = 461.09}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 31.4, ["Fly"] = 96.67, ["Ride"] = 27.57, ["Fly|Ride"] = 64.78, ["Neon"] = 76.85, ["Neon|Fly"] = 315, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 131.23, ["Mega"] = 213.94, ["Mega|Fly|Ride"] = 335.35}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 72.19, ["Fly"] = 433.12, ["Ride"] = 179.19, ["Fly|Ride"] = 262.44, ["Neon"] = 547.15, ["Neon|Ride"] = 410.37, ["Mega|Ride"] = 2034.38, ["Mega|Fly|Ride"] = 1836.19}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 9.45, ["Fly"] = 45.94, ["Ride"] = 30.27, ["Fly|Ride"] = 55.35, ["Neon"] = 39.38, ["Neon|Ride"] = 82.08, ["Neon|Fly|Ride"] = 129.27, ["Mega"] = 262.08, ["Mega|Ride"] = 261.19, ["Mega|Fly|Ride"] = 285.81}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 76.11, ["Fly"] = 145.69, ["Ride"] = 94.85, ["Fly|Ride"] = 185.35, ["Neon"] = 217.95, ["Neon|Fly"] = 525, ["Neon|Ride"] = 223.12, ["Neon|Fly|Ride"] = 405.23, ["Mega"] = 1065.11, ["Mega|Ride"] = 1064.09, ["Mega|Fly|Ride"] = 912.84}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 25.2, ["Ride"] = 57.18, ["Fly|Ride"] = 131.25, ["Neon"] = 102.19, ["Neon|Ride"] = 137.48, ["Neon|Fly|Ride"] = 244.76, ["Mega"] = 470.54, ["Mega|Ride"] = 305.81, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 3.92, ["Ride"] = 27.57, ["Fly|Ride"] = 46.37, ["Neon"] = 123.2, ["Neon|Ride"] = 77.32, ["Neon|Fly|Ride"] = 246.69, ["Mega"] = 416.96, ["Mega|Ride"] = 1025.13, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 17.07, ["Ride"] = 108.99, ["Fly|Ride"] = 156.33, ["Neon"] = 88.13, ["Neon|Ride"] = 106.6, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 205.04, ["Mega|Ride"] = 257.17, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 8.69, ["Ride"] = 40.11, ["Fly|Ride"] = 137.31, ["Neon"] = 41.01, ["Neon|Ride"] = 69.57, ["Neon|Fly|Ride"] = 154.62, ["Mega"] = 221.82, ["Mega|Ride"] = 342.41, ["Mega|Fly|Ride"] = 332.01}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 57.1, ["Neon|Fly|Ride"] = 89.19, ["Mega"] = 17.07, ["Mega|Ride"] = 102.53, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 5.16, ["Ride"] = 27.71, ["Neon"] = 19.48, ["Neon|Fly"] = 122.97, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 202.78, ["Mega"] = 96.08, ["Mega|Ride"] = 191.71, ["Mega|Fly|Ride"] = 396.74}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.51, ["Neon"] = 23.63, ["Mega"] = 196.23, ["Mega|Ride"] = 137.38, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 3.7, ["Ride"] = 32.79, ["Fly|Ride"] = 115.24, ["Neon"] = 18.84, ["Neon|Ride"] = 82.08, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 198.89, ["Mega|Ride"] = 205.04, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 564.37, ["Ride"] = 544.69, ["Fly|Ride"] = 652.03, ["Neon"] = 1776.68, ["Neon|Ride"] = 1764.53, ["Neon|Fly|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 5880}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 6.03, ["Fly"] = 27.78, ["Ride"] = 23.58, ["Fly|Ride"] = 62.23, ["Neon"] = 32.81, ["Neon|Ride"] = 94.4, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 154.47, ["Mega|Ride"] = 353.9, ["Mega|Fly|Ride"] = 479.54}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 8.91, ["Fly"] = 524.48, ["Ride"] = 23.58, ["Fly|Ride"] = 51.35, ["Neon"] = 53, ["Neon|Fly"] = 315, ["Neon|Ride"] = 86.19, ["Neon|Fly|Ride"] = 154.84, ["Mega"] = 302.43, ["Mega|Ride"] = 323.65, ["Mega|Fly|Ride"] = 341.24}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 3.92, ["Fly"] = 96.67, ["Ride"] = 16.44, ["Fly|Ride"] = 61.69, ["Neon|Ride"] = 196.88, ["Mega"] = 259.37, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 24.35, ["Fly|Ride"] = 90.57, ["Neon"] = 9.19, ["Neon|Ride"] = 31.13, ["Neon|Fly|Ride"] = 115.4, ["Mega"] = 66.36, ["Mega|Fly"] = 211.78, ["Mega|Ride"] = 121.48, ["Mega|Fly|Ride"] = 231.7}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 68.91, ["Ride"] = 19.69, ["Neon"] = 3.71, ["Neon|Ride"] = 24.04, ["Neon|Fly|Ride"] = 87.35, ["Mega"] = 24.97, ["Mega|Fly"] = 191.71, ["Mega|Ride"] = 154.47, ["Mega|Fly|Ride"] = 154.88}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1107.75}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 6.46, ["Ride"] = 35.93, ["Fly|Ride"] = 323.64, ["Neon"] = 59.07, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 191.86, ["Mega"] = 396.74, ["Mega|Ride"] = 364.26, ["Mega|Fly|Ride"] = 410.06}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 23.76, ["Neon"] = 6.56, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 982.1, ["Mega"] = 40.85, ["Mega|Ride"] = 153.79, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.1, ["Fly"] = 27.57, ["Ride"] = 58.97, ["Fly|Ride"] = 99.75, ["Neon"] = 11.46, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 137.48, ["Neon|Fly|Ride"] = 684.28, ["Mega"] = 183.73, ["Mega|Ride"] = 271.69, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 465.94, ["Ride"] = 431.44, ["Fly|Ride"] = 556.07, ["Neon|Ride"] = 1436.25, ["Neon|Fly|Ride"] = 1347.76, ["Mega|Fly|Ride"] = 8006.25}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 2.67, ["Fly"] = 196.88, ["Ride"] = 59.07, ["Fly|Ride"] = 409.86, ["Neon"] = 56.35, ["Neon|Ride"] = 71.36, ["Neon|Fly|Ride"] = 186.63, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 547.43}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Fly"] = 76.36, ["Ride"] = 34.85, ["Fly|Ride"] = 161.9, ["Neon"] = 6.57, ["Neon|Ride"] = 31.8, ["Neon|Fly|Ride"] = 145.69, ["Mega"] = 43.64, ["Mega|Fly"] = 189, ["Mega|Ride"] = 95.69, ["Mega|Fly|Ride"] = 244.38}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Neon"] = 3.89, ["Neon|Ride"] = 113.32, ["Neon|Fly|Ride"] = 410.37, ["Mega"] = 27.46, ["Mega|Ride"] = 117.16, ["Mega|Fly|Ride"] = 164.04}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 13.65, ["Fly"] = 107.63, ["Ride"] = 68.83, ["Fly|Ride"] = 85.29, ["Neon"] = 102.8, ["Neon|Ride"] = 57.88, ["Neon|Fly|Ride"] = 342.66, ["Mega"] = 575.22, ["Mega|Ride"] = 400.84, ["Mega|Fly|Ride"] = 584.01}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 7.71, ["Ride"] = 41.13, ["Fly|Ride"] = 105, ["Neon"] = 108.32, ["Neon|Ride"] = 123.13, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 420.32, ["Mega|Ride"] = 479.73, ["Mega|Fly|Ride"] = 1260}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 4.59, ["Ride"] = 39.34, ["Fly|Ride"] = 409.86, ["Neon"] = 307.67, ["Neon|Ride"] = 154.62, ["Mega"] = 630.54, ["Mega|Ride"] = 683.76, ["Mega|Fly|Ride"] = 1229.94}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 13.55, ["Ride"] = 22.67, ["Neon"] = 273.58, ["Neon|Ride"] = 177.51, ["Neon|Fly|Ride"] = 199.29, ["Mega"] = 547.43, ["Mega|Ride"] = 615.08, ["Mega|Fly|Ride"] = 665.44}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 325.49, ["Ride"] = 315, ["Fly|Ride"] = 614.77, ["Neon"] = 2868.9, ["Neon|Ride"] = 2051.77, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 3854.44}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 3.77, ["Fly"] = 69.65, ["Ride"] = 22.64, ["Fly|Ride"] = 137.31, ["Neon"] = 109.28, ["Neon|Ride"] = 137.48, ["Neon|Fly|Ride"] = 176.47, ["Mega|Ride"] = 342.41, ["Mega|Fly|Ride"] = 846.76}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 3.84, ["Ride"] = 69.98, ["Neon"] = 27.68, ["Neon|Ride"] = 221.82, ["Mega"] = 131.25, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 787.49}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 20.68, ["Ride"] = 70.23, ["Fly|Ride"] = 254.67, ["Neon"] = 68.25, ["Neon|Ride"] = 130.16, ["Neon|Fly|Ride"] = 288.81, ["Mega"] = 272.25, ["Mega|Fly"] = 683.76, ["Mega|Ride"] = 275.61, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.1, ["Fly"] = 41.13, ["Ride"] = 52.5, ["Fly|Ride"] = 137.31, ["Neon"] = 6.45, ["Neon|Ride"] = 41.05, ["Neon|Fly|Ride"] = 204.17, ["Mega"] = 44.63, ["Mega|Fly"] = 105, ["Mega|Ride"] = 96.83, ["Mega|Fly|Ride"] = 303.19}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 43.4, ["Ride"] = 91.88, ["Neon"] = 200.51, ["Neon|Ride"] = 260.58, ["Neon|Fly|Ride"] = 654.18, ["Mega"] = 1367.51, ["Mega|Ride"] = 1339.84, ["Mega|Fly|Ride"] = 984.38}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 578.33, ["Ride"] = 27.43, ["Neon"] = 8.21, ["Neon|Fly"] = 178.29, ["Neon|Ride"] = 63.62, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 68.25, ["Mega|Ride"] = 107.23, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 35.85, ["Ride"] = 27.57, ["Fly|Ride"] = 32.82, ["Neon"] = 6.42, ["Neon|Fly"] = 49.39, ["Neon|Ride"] = 38.82, ["Neon|Fly|Ride"] = 124.62, ["Mega"] = 41.1, ["Mega|Fly"] = 112.88, ["Mega|Ride"] = 73.41, ["Mega|Fly|Ride"] = 178.38}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Fly"] = 91.88, ["Ride"] = 31.13, ["Fly|Ride"] = 122.16, ["Neon"] = 15.1, ["Neon|Ride"] = 55.41, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 77.42, ["Mega|Fly"] = 459.38, ["Mega|Ride"] = 108.94, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 102.83, ["Fly"] = 92.55, ["Ride"] = 78.75, ["Fly|Ride"] = 192.45, ["Neon"] = 291.38, ["Neon|Ride"] = 282.76, ["Neon|Fly|Ride"] = 412.56, ["Mega|Ride"] = 1025.13, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 271.69, ["Ride"] = 280.51, ["Fly|Ride"] = 413.44, ["Neon"] = 1424.2, ["Neon|Ride"] = 1127.75, ["Neon|Fly|Ride"] = 1039.5, ["Mega"] = 6150.68, ["Mega|Fly|Ride"] = 5226.37}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 6.15, ["Ride"] = 71.72, ["Neon"] = 28.54, ["Neon|Ride"] = 143.08, ["Mega"] = 96.73, ["Mega|Ride"] = 184.97, ["Mega|Fly|Ride"] = 578.19}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.63, ["Fly"] = 68.91, ["Ride"] = 28.46, ["Fly|Ride"] = 154.43, ["Neon"] = 15.38, ["Neon|Ride"] = 43.12, ["Neon|Fly|Ride"] = 178.52, ["Mega"] = 61.69, ["Mega|Fly"] = 210, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 342.41}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 6.28, ["Fly"] = 30.09, ["Ride"] = 27.56, ["Fly|Ride"] = 174.2, ["Neon"] = 32.81, ["Mega"] = 373.42, ["Mega|Ride"] = 341.29}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 60.74, ["Ride"] = 34.89, ["Neon"] = 7.67, ["Neon|Ride"] = 25.73, ["Neon|Fly|Ride"] = 137.48, ["Mega"] = 86.96, ["Mega|Fly"] = 145.59, ["Mega|Ride"] = 111.57, ["Mega|Fly|Ride"] = 236.24}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 67.65, ["Neon"] = 9.71, ["Mega"] = 38.66, ["Mega|Ride"] = 205.04, ["Mega|Fly|Ride"] = 270.64}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 65.54, ["Ride"] = 16.71, ["Fly|Ride"] = 41.99, ["Neon"] = 6.15, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 97.48, ["Mega"] = 38.33, ["Mega|Ride"] = 99.15, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 137.8, ["Ride"] = 24.94, ["Fly|Ride"] = 56.82, ["Neon"] = 10.21, ["Neon|Fly"] = 63.03, ["Neon|Ride"] = 39, ["Neon|Fly|Ride"] = 85.31, ["Mega"] = 92.23, ["Mega|Ride"] = 231.7, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 27.64, ["Ride"] = 52.45, ["Fly|Ride"] = 77.15, ["Neon"] = 192.13, ["Neon|Ride"] = 211.35, ["Mega"] = 573.05, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 63, ["Fly"] = 582.75, ["Ride"] = 82.61, ["Fly|Ride"] = 110.56, ["Neon"] = 409.86, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 439.09, ["Mega"] = 1470, ["Mega|Ride"] = 3254.99, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 17.85, ["Fly|Ride"] = 131.25, ["Neon"] = 5.66, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 137.48, ["Mega"] = 39.38, ["Mega|Fly"] = 672, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 15.44, ["Ride"] = 15.74, ["Fly|Ride"] = 39.37, ["Neon"] = 5.25, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 20.61, ["Neon|Fly|Ride"] = 55.41, ["Mega"] = 61.01, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 89.19, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 5.76, ["Fly"] = 34.98, ["Ride"] = 73.48, ["Fly|Ride"] = 131.25, ["Neon|Ride"] = 62.31, ["Neon|Fly|Ride"] = 272.9, ["Mega"] = 527.63, ["Mega|Ride"] = 461.09, ["Mega|Fly|Ride"] = 636.57}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 393.75, ["Fly"] = 413.44, ["Ride"] = 576.68, ["Fly|Ride"] = 492.19, ["Neon"] = 4098.41, ["Neon|Ride"] = 1778.88, ["Mega|Fly|Ride"] = 7175.8}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 44.01, ["Fly"] = 95.81, ["Ride"] = 43.08, ["Fly|Ride"] = 91.47, ["Neon"] = 170.43, ["Neon|Ride"] = 137.48, ["Neon|Fly|Ride"] = 305.79, ["Mega|Ride"] = 922.61, ["Mega|Fly|Ride"] = 984.38}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 36.01, ["Fly|Ride"] = 281.29, ["Neon"] = 9.1, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 82.02, ["Mega|Ride"] = 133.88, ["Mega|Fly|Ride"] = 272.99}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.26, ["Fly"] = 205.65, ["Ride"] = 65.61, ["Fly|Ride"] = 142.7, ["Neon"] = 23.67, ["Neon|Ride"] = 68.75, ["Mega|Ride"] = 273.73}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 19.69, ["Fly"] = 76.11, ["Ride"] = 43.3, ["Fly|Ride"] = 81.99, ["Neon|Ride"] = 298.86, ["Neon|Fly|Ride"] = 363.18, ["Mega"] = 2460.28, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1285.5}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 75.74, ["Fly"] = 117.24, ["Ride"] = 98.75, ["Fly|Ride"] = 157.81, ["Neon"] = 430.1, ["Neon|Ride"] = 469.87, ["Neon|Fly|Ride"] = 476.02, ["Mega"] = 8200.91, ["Mega|Fly|Ride"] = 1867.77}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 261.38, ["Ride"] = 237.21, ["Fly|Ride"] = 480.38, ["Neon"] = 712.69, ["Neon|Ride"] = 1365, ["Neon|Fly|Ride"] = 1256.73, ["Mega"] = 4354.69, ["Mega|Fly|Ride"] = 4304.46}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 12.13, ["Fly"] = 51.19, ["Ride"] = 61.69, ["Fly|Ride"] = 150.94, ["Neon"] = 75.95, ["Neon|Ride"] = 108.71, ["Neon|Fly|Ride"] = 184.45, ["Mega"] = 379.29, ["Mega|Ride"] = 349.69, ["Mega|Fly|Ride"] = 418.24}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 18.59, ["Ride"] = 15.62, ["Fly|Ride"] = 41.9, ["Neon"] = 8.97, ["Neon|Ride"] = 19.92, ["Neon|Fly|Ride"] = 91.11, ["Mega"] = 85.32, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 165.38}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 3.89, ["Fly"] = 34.83, ["Ride"] = 19.46, ["Fly|Ride"] = 41.1, ["Neon"] = 31, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 81.03, ["Mega"] = 375.2, ["Mega|Ride"] = 302.43, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 328.13, ["Fly"] = 480.17, ["Ride"] = 357.56, ["Fly|Ride"] = 451.87, ["Neon"] = 2038.97, ["Neon|Ride"] = 2150.35, ["Neon|Fly|Ride"] = 1781.07, ["Mega|Fly|Ride"] = 4594.95}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 60.47, ["Neon"] = 10.5, ["Neon|Ride"] = 59.52, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 71.47, ["Mega|Ride"] = 183.74}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 3.7, ["Ride"] = 18.38, ["Fly|Ride"] = 45.85, ["Neon"] = 49.87, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 154.47, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 192.31, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 12.9, ["Ride"] = 116.22, ["Neon"] = 112.88, ["Neon|Fly"] = 409.86, ["Neon|Ride"] = 236.23, ["Neon|Fly|Ride"] = 431.51, ["Mega"] = 464.6, ["Mega|Ride"] = 549.94, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 110.44, ["Fly"] = 209.76, ["Ride"] = 111.57, ["Fly|Ride"] = 163.95, ["Neon|Ride"] = 561.17, ["Neon|Fly|Ride"] = 611.02, ["Mega|Fly|Ride"] = 2378.25}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 25.45, ["Fly"] = 43.2, ["Ride"] = 27.18, ["Fly|Ride"] = 55.35, ["Neon"] = 85.32, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 205.19, ["Mega"] = 629.43, ["Mega|Ride"] = 507.66, ["Mega|Fly|Ride"] = 448.98}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 25.47, ["Neon"] = 2.1, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 684.28, ["Mega"] = 22.32, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Fly"] = 39.26, ["Ride"] = 15.75, ["Fly|Ride"] = 72.19, ["Neon"] = 3.84, ["Neon|Ride"] = 20.53, ["Neon|Fly|Ride"] = 69.67, ["Mega"] = 27.57, ["Mega|Fly"] = 71.36, ["Mega|Ride"] = 44.08, ["Mega|Fly|Ride"] = 115.69}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 11.58, ["Fly"] = 411.28, ["Ride"] = 64.96, ["Fly|Ride"] = 137.31, ["Neon"] = 29.78, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 80.74, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 151.66, ["Mega|Ride"] = 188.98, ["Mega|Fly|Ride"] = 353.69}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1314.63, ["Fly"] = 1526.77, ["Ride"] = 1207.5, ["Fly|Ride"] = 1286.25, ["Neon"] = 4200, ["Neon|Ride"] = 3609.38, ["Neon|Fly|Ride"] = 3609.38, ["Mega|Fly|Ride"] = 11517.19}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 489.56, ["Fly"] = 616.92, ["Ride"] = 509.84, ["Fly|Ride"] = 546, ["Neon"] = 1776.68, ["Neon|Ride"] = 1928.07, ["Neon|Fly|Ride"] = 2038.44, ["Mega"] = 16401.81, ["Mega|Fly|Ride"] = 9301.66}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 301.88, ["Ride"] = 327.28, ["Fly|Ride"] = 409.86, ["Neon"] = 675.94, ["Neon|Fly"] = 1229.47, ["Neon|Ride"] = 753.02, ["Neon|Fly|Ride"] = 786.19, ["Mega|Fly|Ride"] = 2915.64}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 287.42, ["Fly"] = 411.28, ["Ride"] = 360.21, ["Fly|Ride"] = 481.58, ["Neon"] = 1000.13, ["Neon|Fly"] = 1076.23, ["Neon|Ride"] = 1066.93, ["Neon|Fly|Ride"] = 1639.32, ["Mega|Fly|Ride"] = 4607.89}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Ride"] = 16.57, ["Fly|Ride"] = 38.06, ["Neon"] = 5.64, ["Neon|Ride"] = 48.57, ["Neon|Fly|Ride"] = 105, ["Mega"] = 75.88, ["Mega|Ride"] = 112.88, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 392.22, ["Fly"] = 1371.61, ["Ride"] = 462.68, ["Fly|Ride"] = 564.38, ["Neon"] = 1680, ["Neon|Ride"] = 1509.38, ["Neon|Fly|Ride"] = 1378.13, ["Mega|Ride"] = 6560.73, ["Mega|Fly|Ride"] = 4462.5}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 2.1, ["Fly"] = 157.5, ["Ride"] = 27.68, ["Fly|Ride"] = 62.56, ["Neon"] = 12.37, ["Neon|Ride"] = 123.13, ["Neon|Fly|Ride"] = 205.19, ["Mega"] = 81.1, ["Mega|Ride"] = 181.55, ["Mega|Fly|Ride"] = 365.79}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 19.43, ["Ride"] = 18.52, ["Fly|Ride"] = 38.98, ["Neon"] = 7.77, ["Neon|Ride"] = 52.27, ["Neon|Fly|Ride"] = 109.78, ["Mega"] = 104.81, ["Mega|Ride"] = 192.93}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Neon"] = 2.52, ["Neon|Ride"] = 39.37, ["Mega"] = 23.39, ["Mega|Ride"] = 196.77}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 65.37, ["Ride"] = 108.99, ["Fly|Ride"] = 459.38, ["Neon"] = 191.62, ["Neon|Ride"] = 351.29, ["Mega|Ride"] = 922.18, ["Mega|Fly|Ride"] = 773.07}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 7710.38, ["Ride"] = 22.32, ["Fly|Ride"] = 62.31, ["Neon"] = 27.68, ["Neon|Ride"] = 77.22, ["Mega"] = 410.06, ["Mega|Ride"] = 307.55, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.13, ["Neon"] = 3.84, ["Neon|Fly"] = 118.55, ["Neon|Ride"] = 37.32, ["Neon|Fly|Ride"] = 117.06, ["Mega"] = 19.69, ["Mega|Fly"] = 102.53, ["Mega|Ride"] = 90.19, ["Mega|Fly|Ride"] = 121.52}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.1, ["Fly"] = 35.9, ["Ride"] = 20.57, ["Fly|Ride"] = 66.89, ["Neon"] = 14.36, ["Neon|Fly"] = 96.33, ["Neon|Ride"] = 36.94, ["Neon|Fly|Ride"] = 82.69, ["Mega"] = 99.65, ["Mega|Fly"] = 171.21, ["Mega|Ride"] = 117.76, ["Mega|Fly|Ride"] = 153.85}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 3.59, ["Fly"] = 91.77, ["Ride"] = 27.67, ["Fly|Ride"] = 51.45, ["Neon"] = 17.07, ["Neon|Fly"] = 109.65, ["Neon|Ride"] = 137.48, ["Neon|Fly|Ride"] = 245.2, ["Mega"] = 237.57, ["Mega|Ride"] = 300.51, ["Mega|Fly|Ride"] = 307.79}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 10.18, ["Fly"] = 190.32, ["Ride"] = 60.67, ["Neon"] = 52.05, ["Neon|Fly|Ride"] = 261.68, ["Mega"] = 410.06, ["Mega|Ride"] = 413.44, ["Mega|Fly|Ride"] = 410.06}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.1, ["Fly"] = 6169.52, ["Ride"] = 26.77, ["Neon"] = 36.02, ["Neon|Fly|Ride"] = 273.93, ["Mega"] = 439.03, ["Mega|Ride"] = 714, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 18.16, ["Fly|Ride"] = 45.94, ["Neon"] = 5.65, ["Neon|Fly"] = 82.48, ["Neon|Ride"] = 23.73, ["Neon|Fly|Ride"] = 41.05, ["Mega"] = 41.99, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 142.73, ["Fly"] = 227.25, ["Ride"] = 205.65, ["Fly|Ride"] = 257.23, ["Neon|Ride"] = 955.11, ["Neon|Fly|Ride"] = 1025.89, ["Mega"] = 8200.91, ["Mega|Ride"] = 4100.46, ["Mega|Fly|Ride"] = 4087.13}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 15.23, ["Ride"] = 15.46, ["Fly|Ride"] = 34.44, ["Neon"] = 3.84, ["Neon|Fly"] = 27.71, ["Neon|Ride"] = 24.29, ["Neon|Fly|Ride"] = 45.85, ["Mega"] = 39.25, ["Mega|Ride"] = 81, ["Mega|Fly|Ride"] = 122.75}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 7.27, ["Fly"] = 137.8, ["Ride"] = 55.54, ["Fly|Ride"] = 183.74, ["Neon"] = 135.27, ["Neon|Ride"] = 177.7, ["Mega"] = 360.94, ["Mega|Ride"] = 281.88, ["Mega|Fly|Ride"] = 1025.13}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 33.17, ["Ride"] = 93.19, ["Fly|Ride"] = 102.92, ["Neon"] = 155.56, ["Neon|Ride"] = 273.58, ["Mega"] = 786.19, ["Mega|Ride"] = 806.91, ["Mega|Fly|Ride"] = 1023.07}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 181.11, ["Ride"] = 216.79, ["Fly|Ride"] = 333.38, ["Neon"] = 708.73, ["Neon|Fly"] = 1152.27, ["Neon|Fly|Ride"] = 840.12, ["Mega|Ride"] = 3278.33, ["Mega|Fly|Ride"] = 3249.61}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 15.65, ["Fly"] = 168.88, ["Ride"] = 38.58, ["Fly|Ride"] = 138.29, ["Neon"] = 123.31, ["Neon|Ride"] = 145.34, ["Mega"] = 281.71, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 1230.15}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 13.51, ["Ride"] = 137.8, ["Fly|Ride"] = 614.77, ["Neon"] = 96.95, ["Neon|Fly"] = 154.43, ["Neon|Ride"] = 199.5, ["Mega"] = 478.75, ["Mega|Ride"] = 615.08, ["Mega|Fly|Ride"] = 905.63}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 984.38, ["Ride"] = 1074.62, ["Fly|Ride"] = 1149.75, ["Neon"] = 4609.06, ["Neon|Ride"] = 4790.63, ["Neon|Fly|Ride"] = 4614.92, ["Mega|Fly|Ride"] = 16907.87}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 6.5, ["Fly"] = 30.09, ["Ride"] = 19.56, ["Fly|Ride"] = 52.5, ["Neon"] = 40.5, ["Neon|Fly"] = 84.06, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 200.07, ["Mega"] = 230.55, ["Mega|Ride"] = 232.72, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 4.34, ["Ride"] = 35.96, ["Fly|Ride"] = 135.19, ["Neon"] = 31.19, ["Neon|Ride"] = 91.17, ["Mega"] = 219.39, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 240.85, ["Mega|Fly|Ride"] = 478.75}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Fly"] = 81.24, ["Ride"] = 22.64, ["Fly|Ride"] = 69.57, ["Neon"] = 14.52, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 36.93, ["Mega"] = 91.88, ["Mega|Ride"] = 173.14, ["Mega|Fly|Ride"] = 707.44}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 14.05, ["Ride"] = 64.32, ["Fly|Ride"] = 137.31, ["Neon"] = 77.4, ["Neon|Ride"] = 79.43, ["Neon|Fly|Ride"] = 173.91, ["Mega"] = 342.57, ["Mega|Ride"] = 334.69, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 2.52, ["Fly"] = 20.57, ["Ride"] = 18.47, ["Fly|Ride"] = 39.2, ["Neon"] = 19.64, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 34.9, ["Neon|Fly|Ride"] = 92.31, ["Mega"] = 129.15, ["Mega|Ride"] = 157.88, ["Mega|Fly|Ride"] = 269.75}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Ride"] = 21.97, ["Neon"] = 11.82, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 56.25, ["Neon|Fly|Ride"] = 205.19, ["Mega"] = 111.57, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 326}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 229.69, ["Fly"] = 261.18, ["Ride"] = 229.69, ["Fly|Ride"] = 389.37, ["Neon|Fly|Ride"] = 984.38}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Fly"] = 32.7, ["Ride"] = 22.7, ["Fly|Ride"] = 72.19, ["Neon"] = 10.07, ["Neon|Ride"] = 32.71, ["Neon|Fly|Ride"] = 119.84, ["Mega"] = 82.69, ["Mega|Fly"] = 410.06, ["Mega|Ride"] = 114.03, ["Mega|Fly|Ride"] = 243.99}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 4.65, ["Ride"] = 81.79, ["Fly|Ride"] = 88.87, ["Neon"] = 38.95, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 137.48, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 2.79, ["Fly"] = 92.17, ["Ride"] = 26.17, ["Neon"] = 12.71, ["Neon|Ride"] = 93.37, ["Mega"] = 83.99, ["Mega|Fly"] = 137.38, ["Mega|Ride"] = 205.04, ["Mega|Fly|Ride"] = 408.01}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 202.02, ["Ride"] = 315, ["Fly|Ride"] = 1036.23, ["Neon"] = 787.5, ["Neon|Fly"] = 1024.61, ["Neon|Ride"] = 820.73, ["Neon|Fly|Ride"] = 1094.63, ["Mega"] = 3075.36, ["Mega|Ride"] = 3074.28, ["Mega|Fly|Ride"] = 2875.69}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 36.48, ["Fly"] = 60.67, ["Ride"] = 148.08, ["Fly|Ride"] = 157.81, ["Neon"] = 124.68, ["Neon|Fly|Ride"] = 393.75, ["Mega|Ride"] = 708.75, ["Mega|Fly|Ride"] = 765.77}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 17.74, ["Ride"] = 40.4, ["Fly|Ride"] = 89.25, ["Neon"] = 78, ["Neon|Ride"] = 138.46, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 506.13, ["Mega|Ride"] = 547.43, ["Mega|Fly|Ride"] = 588.42}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 81.99, ["Neon"] = 2.1, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 47.59, ["Mega"] = 36.29, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 223.5}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 102.09, ["Fly"] = 5725.55, ["Ride"] = 101.36, ["Fly|Ride"] = 191.62, ["Neon"] = 262.48, ["Neon|Fly"] = 409.86, ["Neon|Ride"] = 291.38, ["Neon|Fly|Ride"] = 354.38, ["Mega|Fly|Ride"] = 1076.25}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 19.03, ["Neon"] = 5.16, ["Neon|Ride"] = 55.35, ["Neon|Fly|Ride"] = 122.1, ["Mega"] = 52.41, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 24.69, ["Fly"] = 97.18, ["Ride"] = 34.13, ["Fly|Ride"] = 79.77, ["Neon"] = 65.63, ["Neon|Ride"] = 122.31, ["Neon|Fly|Ride"] = 246.23, ["Mega"] = 273.73, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 365.44}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 64.97, ["Fly"] = 110.06, ["Ride"] = 79.95, ["Fly|Ride"] = 137.31, ["Neon"] = 246.65, ["Neon|Ride"] = 308.05, ["Neon|Fly|Ride"] = 311.07, ["Mega|Ride"] = 3418.77, ["Mega|Fly|Ride"] = 1157.75}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 14.69, ["Fly|Ride"] = 30.54, ["Neon"] = 2.1, ["Neon|Fly"] = 23.96, ["Neon|Ride"] = 14.77, ["Neon|Fly|Ride"] = 31.5, ["Mega"] = 15.38, ["Mega|Fly"] = 115.29, ["Mega|Ride"] = 31.26, ["Mega|Fly|Ride"] = 87.94}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 3.63, ["Fly"] = 32.82, ["Ride"] = 44.01, ["Fly|Ride"] = 131.25, ["Neon"] = 14.34, ["Neon|Ride"] = 59.52, ["Neon|Fly|Ride"] = 136.5, ["Mega"] = 128.63, ["Mega|Ride"] = 258.57, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 15.12, ["Ride"] = 64.79, ["Fly|Ride"] = 108.32, ["Neon"] = 77.22, ["Neon|Ride"] = 178.52, ["Neon|Fly|Ride"] = 273.93, ["Mega"] = 586.69, ["Mega|Ride"] = 492.19, ["Mega|Fly|Ride"] = 809.86}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 26.66, ["Neon"] = 2.1, ["Neon|Ride"] = 28.87, ["Neon|Fly|Ride"] = 95.8, ["Mega"] = 19.73, ["Mega|Ride"] = 81, ["Mega|Fly|Ride"] = 212.82}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 13.55, ["Fly"] = 176.59, ["Ride"] = 57.9, ["Fly|Ride"] = 99.75, ["Neon"] = 65.63, ["Neon|Ride"] = 137.48, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 553.31, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 391.02, ["Mega|Fly|Ride"] = 462}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 18.38, ["Fly"] = 103.69, ["Ride"] = 26.5, ["Fly|Ride"] = 45.94, ["Neon"] = 223.37, ["Neon|Ride"] = 118.78, ["Mega|Fly|Ride"] = 410.06}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 8.27, ["Ride"] = 52.5, ["Neon"] = 26.17, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 68.75, ["Neon|Fly|Ride"] = 684.28, ["Mega"] = 210, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 385.02}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 10.11, ["Fly"] = 2056.38, ["Ride"] = 85.32, ["Fly|Ride"] = 196.83, ["Neon"] = 45.94, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 6152.84, ["Mega"] = 274.96, ["Mega|Ride"] = 581.44, ["Mega|Fly|Ride"] = 786.19}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Fly"] = 41.13, ["Ride"] = 18.56, ["Fly|Ride"] = 196.88, ["Neon"] = 7.8, ["Neon|Fly"] = 55.35, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 102.6, ["Mega"] = 68.06, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 138.26, ["Mega|Fly|Ride"] = 273.73}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 91.91, ["Mega"] = 30.13, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 266.54}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 30.87}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 40.99, ["Fly"] = 78.75, ["Ride"] = 70.88, ["Neon"] = 1050, ["Neon|Ride"] = 202.49, ["Neon|Fly|Ride"] = 313.68, ["Mega"] = 1221.95, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 889.88}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Mega"] = 18.43, ["Mega|Ride"] = 119.7, ["Mega|Fly|Ride"] = 307.55}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 393.75, ["Fly"] = 561.4, ["Ride"] = 446.25, ["Fly|Ride"] = 641.82, ["Neon"] = 3020.54, ["Neon|Fly|Ride"] = 2251.08, ["Mega"] = 16401.81, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 5.16, ["Fly"] = 25.81, ["Ride"] = 22.74, ["Fly|Ride"] = 66.26, ["Neon"] = 25.37, ["Neon|Ride"] = 273.93, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 80.9, ["Mega|Fly"] = 147.62, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 547.43}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.1, ["Fly"] = 95.55, ["Ride"] = 19.59, ["Fly|Ride"] = 64.22, ["Neon"] = 16.89, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 123.46, ["Mega"] = 162.75, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 411.9}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 11.46, ["Fly"] = 77.14, ["Ride"] = 64.79, ["Fly|Ride"] = 106.32, ["Neon"] = 89.15, ["Neon|Ride"] = 177.7, ["Neon|Fly|Ride"] = 282.19, ["Mega"] = 779.1, ["Mega|Ride"] = 521.7, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 3.35, ["Fly"] = 315.67, ["Ride"] = 32.48, ["Fly|Ride"] = 683.42, ["Mega"] = 258.57}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 11.46, ["Fly"] = 139.53, ["Ride"] = 105, ["Fly|Ride"] = 157.5, ["Neon"] = 52.5, ["Neon|Ride"] = 205.19, ["Neon|Fly|Ride"] = 368.31, ["Mega"] = 347.28, ["Mega|Ride"] = 400.98, ["Mega|Fly|Ride"] = 522.82}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 7.88, ["Fly"] = 105, ["Ride"] = 32.82, ["Fly|Ride"] = 133.88, ["Neon"] = 46.78, ["Neon|Ride"] = 101.57, ["Neon|Fly|Ride"] = 137.48, ["Mega"] = 205.04, ["Mega|Fly"] = 547.43, ["Mega|Ride"] = 321.57, ["Mega|Fly|Ride"] = 342.41}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 12.13, ["Fly|Ride"] = 66.85, ["Neon"] = 2.1, ["Neon|Fly"] = 41.99, ["Neon|Ride"] = 15.38, ["Neon|Fly|Ride"] = 126.95, ["Mega"] = 13.92, ["Mega|Ride"] = 24.94, ["Mega|Fly|Ride"] = 107}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 7.88, ["Fly"] = 274.54, ["Ride"] = 27.68, ["Fly|Ride"] = 48.18, ["Neon"] = 28.65, ["Neon|Fly"] = 115.24, ["Neon|Ride"] = 93.37, ["Neon|Fly|Ride"] = 82.08, ["Mega"] = 196.86, ["Mega|Ride"] = 217.88, ["Mega|Fly|Ride"] = 517.79}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 301.88, ["Ride"] = 301.96, ["Fly|Ride"] = 421.32, ["Neon"] = 1442.66, ["Neon|Ride"] = 1368.54, ["Neon|Fly|Ride"] = 1233.75, ["Mega|Fly|Ride"] = 4235.78}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 88.35, ["Ride"] = 274.54, ["Fly|Ride"] = 215.25, ["Neon"] = 315, ["Neon|Ride"] = 514.5, ["Neon|Fly|Ride"] = 531.34, ["Mega"] = 4100.46, ["Mega|Ride"] = 1312.17, ["Mega|Fly|Ride"] = 1701}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 13.12, ["Ride"] = 15.75, ["Fly|Ride"] = 27.93, ["Neon"] = 11.37, ["Neon|Fly"] = 68.25, ["Neon|Ride"] = 31.16, ["Neon|Fly|Ride"] = 62.56, ["Mega"] = 151.73, ["Mega|Fly"] = 204.02, ["Mega|Ride"] = 123.03, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 18.45, ["Ride"] = 15.44, ["Fly|Ride"] = 31.13, ["Neon"] = 6.56, ["Neon|Fly"] = 58.78, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 59.11, ["Mega"] = 68.25, ["Mega|Fly"] = 344.02, ["Mega|Ride"] = 103.25, ["Mega|Fly|Ride"] = 171.42}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.93, ["Fly"] = 96.67, ["Ride"] = 22.32, ["Fly|Ride"] = 98.44, ["Neon"] = 39.29, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 137.38, ["Mega|Ride"] = 409.04, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 274.1, ["Fly"] = 420, ["Ride"] = 266.44, ["Fly|Ride"] = 393.75, ["Neon|Ride"] = 1024.61, ["Neon|Fly|Ride"] = 1422.91, ["Mega|Ride"] = 8200.91, ["Mega|Fly|Ride"] = 3404.41}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.1, ["Fly"] = 48.44, ["Ride"] = 16.27, ["Fly|Ride"] = 35.04, ["Neon"] = 19.48, ["Neon|Fly"] = 104.97, ["Neon|Ride"] = 40.45, ["Neon|Fly|Ride"] = 108.94, ["Mega"] = 196.88, ["Mega|Fly"] = 123.03, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 3.63, ["Fly"] = 155.01, ["Ride"] = 82.51, ["Fly|Ride"] = 204.93, ["Neon"] = 39.38, ["Neon|Ride"] = 130.3, ["Neon|Fly|Ride"] = 272.9, ["Mega"] = 236.25, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 321.59}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 27.57, ["Neon"] = 5.09, ["Neon|Ride"] = 137.62, ["Mega"] = 58.97, ["Mega|Ride"] = 200.71}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 13.7, ["Ride"] = 18.17, ["Fly|Ride"] = 59.07, ["Neon"] = 79.38, ["Neon|Ride"] = 108.07, ["Neon|Fly|Ride"] = 171.34, ["Mega"] = 768.88, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 616.65}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 44.18, ["Fly"] = 137.8, ["Ride"] = 114.09, ["Fly|Ride"] = 209.99, ["Neon"] = 91.87, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 212.93, ["Neon|Fly|Ride"] = 425.75, ["Mega"] = 472.5, ["Mega|Fly"] = 2152.76, ["Mega|Ride"] = 478.75, ["Mega|Fly|Ride"] = 583.72}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 25.38, ["Ride"] = 45.85, ["Fly|Ride"] = 105, ["Neon"] = 206.38, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 188.99, ["Neon|Fly|Ride"] = 201.39, ["Mega"] = 820.11, ["Mega|Ride"] = 820.11, ["Mega|Fly|Ride"] = 866.25}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 19.48, ["Ride"] = 14.9, ["Fly|Ride"] = 32.97, ["Neon"] = 2.1, ["Neon|Fly"] = 23.62, ["Neon|Ride"] = 18.11, ["Neon|Fly|Ride"] = 60.54, ["Mega"] = 20.04, ["Mega|Fly"] = 412.51, ["Mega|Ride"] = 57.66, ["Mega|Fly|Ride"] = 115.5}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 271.43, ["Ride"] = 307.02, ["Fly|Ride"] = 297.94, ["Neon"] = 3226.35, ["Neon|Ride"] = 1436.25, ["Neon|Fly|Ride"] = 1072.77}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 10.74, ["Fly"] = 82.26, ["Fly|Ride"] = 105, ["Neon"] = 91.77, ["Neon|Ride"] = 154.92, ["Neon|Fly|Ride"] = 328.12, ["Mega|Ride"] = 525}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 32.3, ["Ride"] = 15.6, ["Fly|Ride"] = 44.07, ["Neon"] = 6.57, ["Neon|Fly"] = 33.57, ["Neon|Ride"] = 27.35, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 58.8, ["Mega|Fly"] = 273.73, ["Mega|Ride"] = 54.69, ["Mega|Fly|Ride"] = 138.34}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 30.86, ["Ride"] = 19.46, ["Fly|Ride"] = 35.44, ["Neon"] = 3.45, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 24.93, ["Neon|Fly|Ride"] = 110.39, ["Mega"] = 26.98, ["Mega|Fly"] = 137.38, ["Mega|Ride"] = 46.27, ["Mega|Fly|Ride"] = 151.73}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Ride"] = 28.73, ["Fly|Ride"] = 69.29, ["Neon"] = 9.38, ["Neon|Ride"] = 34.55, ["Neon|Fly|Ride"] = 6834.43, ["Mega"] = 129.94, ["Mega|Ride"] = 127.34, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 11.66, ["Fly"] = 38.74, ["Ride"] = 24.07, ["Fly|Ride"] = 70.5, ["Neon"] = 51.98, ["Neon|Fly"] = 260.26, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 116.96, ["Mega"] = 341.21, ["Mega|Ride"] = 315.15, ["Mega|Fly|Ride"] = 354.37}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 6.19, ["Ride"] = 55.08, ["Fly|Ride"] = 72.19, ["Neon"] = 59.07, ["Neon|Ride"] = 71.84, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 216.57, ["Mega|Ride"] = 342.41, ["Mega|Fly|Ride"] = 410.06}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 273.58, ["Neon"] = 3.56, ["Neon|Ride"] = 31.82, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 18.06, ["Mega|Ride"] = 66.61, ["Mega|Fly|Ride"] = 120.75}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 12.91, ["Fly"] = 96.67, ["Ride"] = 26.25, ["Fly|Ride"] = 118.13, ["Neon"] = 26.25, ["Neon|Fly"] = 107.72, ["Neon|Ride"] = 66.29, ["Neon|Fly|Ride"] = 135.33, ["Mega"] = 181.79, ["Mega|Ride"] = 212.62, ["Mega|Fly|Ride"] = 299.35}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Fly"] = 68.91, ["Ride"] = 115.42, ["Neon"] = 3.94, ["Neon|Fly"] = 109.65, ["Neon|Ride"] = 53.82, ["Neon|Fly|Ride"] = 102.3, ["Mega"] = 25.4, ["Mega|Ride"] = 91.35, ["Mega|Fly|Ride"] = 150.29}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 38.06, ["Ride"] = 15.59, ["Fly|Ride"] = 42, ["Neon"] = 4.49, ["Neon|Ride"] = 22.23, ["Neon|Fly|Ride"] = 90.02, ["Mega"] = 50.12, ["Mega|Ride"] = 85.22, ["Mega|Fly|Ride"] = 196.77}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 636.57, ["Ride"] = 686.76, ["Fly|Ride"] = 817.3, ["Neon|Ride"] = 3150, ["Neon|Fly|Ride"] = 3248.44, ["Mega|Fly|Ride"] = 12684.75}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 17.56, ["Ride"] = 15.44, ["Fly|Ride"] = 35.44, ["Neon"] = 46.11, ["Neon|Fly"] = 122.75, ["Neon|Ride"] = 27.88, ["Neon|Fly|Ride"] = 32.82, ["Mega"] = 183.51, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.1, ["Ride"] = 36.75, ["Fly|Ride"] = 81.26, ["Neon"] = 15.38, ["Neon|Fly"] = 614.77, ["Neon|Ride"] = 87.74, ["Neon|Fly|Ride"] = 393.74, ["Mega"] = 65.63, ["Mega|Fly"] = 315, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 303.78}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 8.99, ["Fly"] = 40.69, ["Ride"] = 20.9, ["Fly|Ride"] = 52.5, ["Neon"] = 52.41, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 53.91, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 547.43, ["Mega|Ride"] = 309.74, ["Mega|Fly|Ride"] = 371.78}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 15.44, ["Ride"] = 15.48, ["Fly|Ride"] = 33.39, ["Neon"] = 6.3, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 25.78, ["Neon|Fly|Ride"] = 60.41, ["Mega"] = 65.62, ["Mega|Ride"] = 88.14, ["Mega|Fly|Ride"] = 155.33}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 30.17, ["Ride"] = 83.99, ["Fly|Ride"] = 272.55, ["Neon"] = 255.84, ["Neon|Ride"] = 257.44, ["Mega"] = 892.49, ["Mega|Ride"] = 789.35, ["Mega|Fly|Ride"] = 1148.14}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Fly"] = 137.8, ["Ride"] = 18.57, ["Fly|Ride"] = 63.74, ["Neon"] = 6.55, ["Neon|Fly"] = 131.37, ["Neon|Ride"] = 36.66, ["Neon|Fly|Ride"] = 119.43, ["Mega"] = 63.59, ["Mega|Ride"] = 114.74, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 68.91, ["Ride"] = 22.97, ["Fly|Ride"] = 60.8, ["Neon"] = 12.27, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 273.93, ["Mega"] = 236.25, ["Mega|Ride"] = 198.58, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Fly|Ride"] = 59.07, ["Neon"] = 14.44, ["Mega"] = 93.5, ["Mega|Fly"] = 273.73, ["Mega|Ride"] = 170.62, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 15.65, ["Fly|Ride"] = 49.83, ["Neon"] = 5.2, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 23.47, ["Neon|Fly|Ride"] = 84.96, ["Mega"] = 44.63, ["Mega|Fly"] = 250.63, ["Mega|Ride"] = 55.37, ["Mega|Fly|Ride"] = 155.07}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 13.21, ["Fly"] = 17.75, ["Ride"] = 20.25, ["Fly|Ride"] = 41.06, ["Neon"] = 308.73, ["Neon|Ride"] = 68.25, ["Neon|Fly|Ride"] = 98.43, ["Mega"] = 820.11, ["Mega|Fly|Ride"] = 495.14}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 807.08, ["Ride"] = 866.25, ["Fly|Ride"] = 918.75, ["Neon"] = 1706.25, ["Neon|Ride"] = 1745.63, ["Neon|Fly|Ride"] = 1952.99, ["Mega|Ride"] = 6196.77, ["Mega|Fly|Ride"] = 7743.75}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 16.05, ["Ride"] = 16.32, ["Fly|Ride"] = 32.42, ["Neon"] = 3.57, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 19.62, ["Neon|Fly|Ride"] = 57.81, ["Mega"] = 44.63, ["Mega|Ride"] = 73.91, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 7.2, ["Ride"] = 27.57, ["Fly|Ride"] = 115.24, ["Neon"] = 45.94, ["Neon|Fly"] = 151.66, ["Neon|Ride"] = 112.51, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 298.86, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 478.75}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 58.7, ["Ride"] = 76.67, ["Fly|Ride"] = 104.64, ["Neon"] = 302.27, ["Neon|Ride"] = 383.5, ["Neon|Fly|Ride"] = 529.36, ["Mega"] = 3150.32, ["Mega|Fly|Ride"] = 1283.46}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 27.78, ["Fly"] = 137.8, ["Ride"] = 39.38, ["Fly|Ride"] = 102.79, ["Neon"] = 105, ["Neon|Ride"] = 168.05, ["Mega"] = 760.65, ["Mega|Ride"] = 669.38, ["Mega|Fly|Ride"] = 816.38}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 10.5, ["Ride"] = 26.23, ["Fly|Ride"] = 123.59, ["Neon"] = 55.13, ["Neon|Ride"] = 110.07, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 396.74, ["Mega|Ride"] = 483.87, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 21, ["Ride"] = 76.11, ["Neon"] = 107.62, ["Neon|Ride"] = 135.43, ["Mega"] = 244.52, ["Mega|Fly"] = 500.29, ["Mega|Ride"] = 340.35, ["Mega|Fly|Ride"] = 478.75}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 23.66, ["Fly"] = 126.89, ["Ride"] = 88.13, ["Neon"] = 267.33, ["Neon|Ride"] = 302.65, ["Neon|Fly|Ride"] = 485.63, ["Mega"] = 924, ["Mega|Ride"] = 629.43, ["Mega|Fly|Ride"] = 557.81}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 6.48}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 6.45, ["Fly"] = 131248.69, ["Ride"] = 26.75, ["Fly|Ride"] = 84, ["Neon"] = 37.97, ["Neon|Ride"] = 77.22, ["Neon|Fly|Ride"] = 273.73, ["Mega"] = 162.85, ["Mega|Fly"] = 454.63, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 396.74}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.52, ["Ride"] = 131.25, ["Neon"] = 26.25, ["Mega"] = 861.09}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 39.89, ["Fly"] = 412.55, ["Ride"] = 61.7, ["Fly|Ride"] = 94.5, ["Neon"] = 368.74, ["Neon|Ride"] = 240.08, ["Neon|Fly|Ride"] = 245.97, ["Mega|Ride"] = 892.21, ["Mega|Fly|Ride"] = 888.79}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.92, ["Fly"] = 18.38, ["Ride"] = 13.32, ["Fly|Ride"] = 39.38, ["Neon"] = 26.17, ["Neon|Fly"] = 93.26, ["Neon|Ride"] = 35.02, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 273.73, ["Mega|Ride"] = 190.68, ["Mega|Fly|Ride"] = 190.32}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 6.96, ["Fly"] = 82.26, ["Ride"] = 31.25, ["Fly|Ride"] = 104.53, ["Neon"] = 26.64, ["Neon|Ride"] = 54.81, ["Neon|Fly|Ride"] = 123.6, ["Mega"] = 126.06, ["Mega|Ride"] = 176.17, ["Mega|Fly|Ride"] = 231.99}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 5.53, ["Mega"] = 42, ["Mega|Ride"] = 96.88, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 31.27, ["Fly"] = 60.52, ["Ride"] = 68.66, ["Fly|Ride"] = 120.75, ["Neon"] = 151.66, ["Neon|Ride"] = 148.05, ["Neon|Fly|Ride"] = 410.37, ["Mega"] = 1093.81, ["Mega|Ride"] = 779.1, ["Mega|Fly|Ride"] = 773.07}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 27.68, ["Fly|Ride"] = 65.54, ["Neon"] = 8.21, ["Neon|Fly"] = 291.38, ["Neon|Ride"] = 66.06, ["Mega"] = 105, ["Mega|Ride"] = 137.52, ["Mega|Fly|Ride"] = 309.68}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 15.44, ["Fly"] = 55.54, ["Ride"] = 72.76, ["Fly|Ride"] = 270.52, ["Neon"] = 81.99, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 355.72, ["Mega|Ride"] = 748.13, ["Mega|Fly|Ride"] = 642.76}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 45.77, ["Ride"] = 15.74, ["Fly|Ride"] = 36.77, ["Neon"] = 24.61, ["Neon|Ride"] = 27.2, ["Neon|Fly|Ride"] = 60.5, ["Mega"] = 170.63, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 4.81, ["Fly"] = 52.49, ["Ride"] = 17.57, ["Fly|Ride"] = 65.63, ["Neon"] = 77.22, ["Neon|Ride"] = 410.37, ["Mega"] = 376.23, ["Mega|Ride"] = 387.51, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 6.56, ["Ride"] = 59.91, ["Fly|Ride"] = 131.25, ["Neon"] = 46.87, ["Neon|Ride"] = 153.25, ["Mega"] = 375.85, ["Mega|Ride"] = 847.23}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 34.13, ["Ride"] = 125.5, ["Neon"] = 260.44, ["Neon|Ride"] = 208.69, ["Neon|Fly|Ride"] = 434.99, ["Mega"] = 1640.19, ["Mega|Ride"] = 1626.86, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 15.54, ["Ride"] = 119.01, ["Neon"] = 107.63, ["Neon|Ride"] = 410.37, ["Neon|Fly|Ride"] = 143.53, ["Mega"] = 411.9, ["Mega|Ride"] = 328.06, ["Mega|Fly|Ride"] = 498.1}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 5.15, ["Ride"] = 105, ["Neon"] = 64.32, ["Neon|Ride"] = 91.88, ["Mega"] = 388.54, ["Mega|Ride"] = 970.79, ["Mega|Fly|Ride"] = 1640.19}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 28.87, ["Ride"] = 105, ["Fly|Ride"] = 367.46, ["Neon"] = 170.55, ["Neon|Ride"] = 615.55, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 820.11, ["Mega|Ride"] = 614.06, ["Mega|Fly|Ride"] = 1162.49}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 2.56, ["Neon"] = 32.81, ["Neon|Ride"] = 273.93, ["Mega"] = 118.13, ["Mega|Fly|Ride"] = 307.79}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 27.78, ["Ride"] = 17.71, ["Fly|Ride"] = 39.38, ["Neon"] = 5.13, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 40.6, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 68.7, ["Mega|Ride"] = 93.19, ["Mega|Fly|Ride"] = 170.97}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 3.8, ["Ride"] = 28.88, ["Fly|Ride"] = 77.89, ["Neon"] = 14.46, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 96.74, ["Mega"] = 108.93, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 29.86, ["Ride"] = 23.63, ["Fly|Ride"] = 55.95, ["Neon"] = 6.57, ["Neon|Fly"] = 31.13, ["Neon|Ride"] = 25.74, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 47.16, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 188.73}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.63, ["Fly"] = 39.38, ["Ride"] = 19.69, ["Fly|Ride"] = 68.66, ["Neon"] = 17.3, ["Neon|Ride"] = 97.48, ["Neon|Fly|Ride"] = 137.48, ["Mega"] = 250.59, ["Mega|Ride"] = 179.82, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.46, ["Fly"] = 65.63, ["Ride"] = 22.32, ["Fly|Ride"] = 103.69, ["Neon"] = 28.87, ["Neon|Fly"] = 460.92, ["Neon|Ride"] = 82.08, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 302.45, ["Mega|Ride"] = 302.43, ["Mega|Fly|Ride"] = 1025.13}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 6.48, ["Fly"] = 131.25, ["Ride"] = 26.62, ["Fly|Ride"] = 60.4, ["Neon"] = 21, ["Neon|Fly"] = 111.54, ["Neon|Ride"] = 31.8, ["Neon|Fly|Ride"] = 85.54, ["Mega"] = 143.75, ["Mega|Ride"] = 254.67, ["Mega|Fly|Ride"] = 380.07}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 35.14, ["Ride"] = 17.97, ["Fly|Ride"] = 51.69, ["Neon"] = 22.32, ["Neon|Fly"] = 81.99, ["Neon|Ride"] = 54.12, ["Neon|Fly|Ride"] = 123.13, ["Mega"] = 170.63, ["Mega|Ride"] = 226.56}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 3.97, ["Fly"] = 65.63, ["Ride"] = 42.75, ["Neon"] = 15.83, ["Neon|Fly"] = 122.97, ["Neon|Ride"] = 130.01, ["Neon|Fly|Ride"] = 191.86, ["Mega"] = 106.52, ["Mega|Ride"] = 124.69, ["Mega|Fly|Ride"] = 410.06}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 10.29, ["Fly"] = 205.65, ["Ride"] = 96.5, ["Fly|Ride"] = 242.82, ["Neon"] = 105, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 465.42, ["Mega|Fly"] = 683.76, ["Mega|Ride"] = 518.61, ["Mega|Fly|Ride"] = 713.52}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 51.92, ["Ride"] = 104.53, ["Fly|Ride"] = 211.32, ["Neon"] = 285.91, ["Neon|Ride"] = 278.25, ["Neon|Fly|Ride"] = 470.74, ["Mega"] = 1076.25, ["Mega|Ride"] = 1080.48, ["Mega|Fly|Ride"] = 1148.09}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 50.96, ["Ride"] = 22.56, ["Fly|Ride"] = 52.27, ["Neon"] = 2.1, ["Neon|Ride"] = 38.45, ["Mega"] = 26.65, ["Mega|Ride"] = 68.72, ["Mega|Fly|Ride"] = 165.27}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 13.21, ["Mega|Fly|Ride"] = 1230.15}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 47.16, ["Fly"] = 105, ["Ride"] = 68.25, ["Neon"] = 307.39, ["Neon|Ride"] = 273.93, ["Mega"] = 683.76, ["Mega|Ride"] = 1093.81, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 5.04, ["Fly"] = 190.32, ["Ride"] = 31.2, ["Fly|Ride"] = 126, ["Neon"] = 46.87, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 192.93, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 369.06}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 4.65, ["Ride"] = 89.48, ["Fly|Ride"] = 137.7, ["Neon"] = 7.88, ["Neon|Ride"] = 40.69, ["Mega"] = 60.38, ["Mega|Fly"] = 341.25, ["Mega|Ride"] = 95.94, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 30.86, ["Ride"] = 18.38, ["Fly|Ride"] = 54.16, ["Neon"] = 11.82, ["Neon|Ride"] = 27.81, ["Neon|Fly|Ride"] = 111.93, ["Mega"] = 215.3, ["Mega|Fly"] = 342.41, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 219.18}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 16.64, ["Ride"] = 13.13, ["Fly|Ride"] = 27.46, ["Neon"] = 2.63, ["Neon|Fly"] = 26.52, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 57.46, ["Mega"] = 28.88, ["Mega|Ride"] = 69.55, ["Mega|Fly|Ride"] = 147}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 14.69, ["Fly|Ride"] = 76.56, ["Neon"] = 5.23, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 102.6, ["Mega"] = 44.46, ["Mega|Fly"] = 168, ["Mega|Ride"] = 68.7, ["Mega|Fly|Ride"] = 157.95}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 56.44, ["Fly|Ride"] = 154.43, ["Neon"] = 2.1, ["Neon|Ride"] = 47.21, ["Mega"] = 21.7, ["Mega|Ride"] = 547.43, ["Mega|Fly|Ride"] = 304.5}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 6.86, ["Ride"] = 44.23, ["Neon"] = 30.19, ["Neon|Ride"] = 34.9, ["Neon|Fly|Ride"] = 615.55, ["Mega"] = 213.94, ["Mega|Ride"] = 269.07, ["Mega|Fly|Ride"] = 181.63}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 9.59, ["Ride"] = 26.79, ["Fly|Ride"] = 188.98, ["Neon"] = 52.85, ["Neon|Ride"] = 102.6, ["Neon|Fly|Ride"] = 288.75, ["Mega|Ride"] = 547.43, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 7.62, ["Fly"] = 21.95, ["Ride"] = 23.96, ["Fly|Ride"] = 45.33, ["Neon"] = 30.19, ["Neon|Fly"] = 68.92, ["Neon|Ride"] = 46.11, ["Neon|Fly|Ride"] = 91.83, ["Mega|Ride"] = 342.87, ["Mega|Fly|Ride"] = 349.88}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 83.28, ["Ride"] = 261.29, ["Fly|Ride"] = 262.5, ["Neon"] = 538.13, ["Neon|Ride"] = 597.19, ["Mega|Fly|Ride"] = 1771.88}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 27.75, ["Fly"] = 81.83, ["Ride"] = 65.63, ["Fly|Ride"] = 137.31, ["Neon"] = 216.57, ["Neon|Fly|Ride"] = 630, ["Mega"] = 873.77, ["Mega|Ride"] = 827.54, ["Mega|Fly|Ride"] = 820.98}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 15.44, ["Ride"] = 15.38, ["Fly|Ride"] = 39.98, ["Neon"] = 3.94, ["Neon|Fly"] = 41.01, ["Neon|Ride"] = 20.53, ["Neon|Fly|Ride"] = 53.82, ["Mega"] = 32.16, ["Mega|Ride"] = 94.65, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 15.73, ["Fly|Ride"] = 31.55, ["Neon"] = 5.23, ["Neon|Fly"] = 22.32, ["Neon|Ride"] = 20.46, ["Neon|Fly|Ride"] = 38.98, ["Mega"] = 44.63, ["Mega|Fly"] = 82.02, ["Mega|Ride"] = 56.44, ["Mega|Fly|Ride"] = 99.65}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 493.77, ["Ride"] = 530.01, ["Fly|Ride"] = 546.18, ["Neon|Fly|Ride"] = 1764.53}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 6.76, ["Ride"] = 90.2, ["Neon"] = 38.8, ["Neon|Ride"] = 116.96, ["Mega"] = 643.12, ["Mega|Fly|Ride"] = 943.69}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 48.35, ["Ride"] = 15.27, ["Fly|Ride"] = 27.68, ["Neon"] = 2.63, ["Neon|Fly"] = 26.7, ["Neon|Ride"] = 18.27, ["Neon|Fly|Ride"] = 54.79, ["Mega"] = 39.38, ["Mega|Ride"] = 74.81, ["Mega|Fly|Ride"] = 104.37}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 60.44, ["Ride"] = 137.31, ["Fly|Ride"] = 328.13, ["Neon"] = 255.05, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 507.66, ["Mega"] = 917.49, ["Mega|Ride"] = 888.79, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 24.73, ["Ride"] = 18.37, ["Fly|Ride"] = 42, ["Neon"] = 13.13, ["Neon|Fly"] = 42.95, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 84.96, ["Mega|Fly"] = 246.04, ["Mega|Ride"] = 122.07, ["Mega|Fly|Ride"] = 192.52}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 68.91, ["Ride"] = 39.19, ["Fly|Ride"] = 30.19, ["Neon"] = 2.1, ["Neon|Ride"] = 31.82, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 27.69, ["Mega|Fly"] = 273.73, ["Mega|Ride"] = 69.47, ["Mega|Fly|Ride"] = 208.95}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 42, ["Fly"] = 167.06, ["Ride"] = 100.77, ["Fly|Ride"] = 111.57, ["Neon"] = 169.32, ["Neon|Ride"] = 191.26, ["Neon|Fly|Ride"] = 380.63, ["Mega"] = 721.88, ["Mega|Ride"] = 617.47, ["Mega|Fly|Ride"] = 795.38}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Ride"] = 15.44, ["Fly|Ride"] = 52.5, ["Neon"] = 6.18, ["Neon|Ride"] = 39.99, ["Mega"] = 110.15, ["Mega|Ride"] = 174.45, ["Mega|Fly|Ride"] = 223.12}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 32.82, ["Ride"] = 96.67, ["Fly|Ride"] = 137.31, ["Neon"] = 306.37, ["Neon|Ride"] = 253.91, ["Neon|Fly|Ride"] = 359.63, ["Mega"] = 1619.69, ["Mega|Ride"] = 1640.19, ["Mega|Fly|Ride"] = 1155}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 2.1, ["Ride"] = 55.54, ["Fly|Ride"] = 155.75, ["Neon"] = 21.77, ["Neon|Ride"] = 273.93, ["Neon|Fly|Ride"] = 479.1, ["Mega"] = 104.98, ["Mega|Ride"] = 464.63, ["Mega|Fly|Ride"] = 517.79}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 3.29, ["Fly"] = 68.91, ["Ride"] = 26.25, ["Fly|Ride"] = 65.59, ["Neon"] = 10.26, ["Neon|Ride"] = 51.31, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 118.93, ["Mega|Ride"] = 137.38, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 39.38, ["Ride"] = 98.37, ["Fly|Ride"] = 393.75, ["Neon"] = 326.82, ["Neon|Ride"] = 700.88, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 2048.2, ["Mega|Ride"] = 2766.5, ["Mega|Fly|Ride"] = 1230.15}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.63, ["Fly"] = 242.23, ["Ride"] = 28.88, ["Fly|Ride"] = 908.98, ["Neon"] = 6.08, ["Neon|Ride"] = 36.94, ["Neon|Fly|Ride"] = 151.15, ["Mega"] = 45.94, ["Mega|Fly"] = 249.61, ["Mega|Ride"] = 154.47, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 15.65, ["Ride"] = 17.36, ["Fly|Ride"] = 102.88, ["Neon"] = 11.82, ["Neon|Fly"] = 47.77, ["Neon|Ride"] = 16.49, ["Neon|Fly|Ride"] = 115.39, ["Mega|Fly|Ride"] = 205.78}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 9.08, ["Fly"] = 48.35, ["Ride"] = 26.25, ["Fly|Ride"] = 77.22, ["Neon"] = 81.79, ["Neon|Ride"] = 94.5, ["Neon|Fly|Ride"] = 131.33, ["Mega"] = 430.5, ["Mega|Ride"] = 462.54, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 14.32, ["Ride"] = 39.35, ["Fly|Ride"] = 137.31, ["Neon"] = 91.75, ["Neon|Ride"] = 103.59, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 1052.81, ["Mega|Ride"] = 1845.21, ["Mega|Fly|Ride"] = 617.87}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 18.27, ["Fly"] = 39.38, ["Ride"] = 28.88, ["Fly|Ride"] = 73.79, ["Neon"] = 81.38, ["Neon|Ride"] = 86.19, ["Neon|Fly|Ride"] = 137.48, ["Mega"] = 537.12, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 338.27}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 59.07, ["Ride"] = 94.5, ["Fly|Ride"] = 210, ["Neon"] = 294, ["Neon|Ride"] = 490.39, ["Neon|Fly|Ride"] = 715.32, ["Mega"] = 1640.19, ["Mega|Ride"] = 1435.18, ["Mega|Fly|Ride"] = 1260}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 7.76, ["Ride"] = 45.51, ["Fly|Ride"] = 307.39, ["Neon"] = 20.75, ["Neon|Ride"] = 104.65, ["Mega"] = 213.94, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 307.55}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 6.2, ["Ride"] = 26.46, ["Fly|Ride"] = 78.74, ["Neon"] = 18.37, ["Neon|Ride"] = 72.85, ["Neon|Fly|Ride"] = 137.38, ["Mega"] = 185.07, ["Mega|Ride"] = 191.63, ["Mega|Fly|Ride"] = 396.74}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 7.61, ["Fly"] = 52.5, ["Ride"] = 40.11, ["Fly|Ride"] = 109.65, ["Neon"] = 46.11, ["Neon|Ride"] = 392.43, ["Neon|Fly|Ride"] = 154.62, ["Mega"] = 433.13, ["Mega|Ride"] = 311.66, ["Mega|Fly|Ride"] = 494.82}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 11.46, ["Fly|Ride"] = 26.25, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 53.36, ["Mega"] = 13.95, ["Mega|Ride"] = 23.29, ["Mega|Fly|Ride"] = 91.94}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 60.8, ["Fly"] = 137.8, ["Ride"] = 96.33, ["Neon"] = 183.75, ["Neon|Fly"] = 2322.78, ["Neon|Ride"] = 225.11, ["Neon|Fly|Ride"] = 488.24, ["Mega"] = 1076.64, ["Mega|Ride"] = 1497.21, ["Mega|Fly|Ride"] = 984.38}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 19.45, ["Fly|Ride"] = 112.22, ["Neon"] = 6.03, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 46.34, ["Mega|Ride"] = 51.26, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 27.78, ["Ride"] = 15.6, ["Fly|Ride"] = 45.93, ["Neon"] = 18.38, ["Neon|Fly"] = 137.31, ["Neon|Ride"] = 31.16, ["Neon|Fly|Ride"] = 94.4, ["Mega"] = 260.39, ["Mega|Ride"] = 123.24, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 84.2, ["Ride"] = 123.44, ["Fly|Ride"] = 223.13, ["Neon"] = 334.69, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 684.28, ["Mega"] = 1247.4, ["Mega|Ride"] = 1291.04, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 23.58, ["Neon"] = 7.79, ["Neon|Ride"] = 35.87, ["Mega"] = 65.52, ["Mega|Ride"] = 103.26, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 12.47}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 20.57, ["Fly|Ride"] = 291, ["Neon"] = 7.86, ["Neon|Ride"] = 42.83, ["Neon|Fly|Ride"] = 116.25, ["Mega"] = 49.26, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 194.81}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 108.95, ["Ride"] = 202.89, ["Fly|Ride"] = 262.5, ["Neon"] = 642.44, ["Neon|Ride"] = 671.97, ["Neon|Fly|Ride"] = 774.38, ["Mega"] = 3535.35, ["Mega|Ride"] = 2231.25, ["Mega|Fly|Ride"] = 2835}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 4.65, ["Ride"] = 40.85, ["Neon"] = 27.57, ["Neon|Ride"] = 55.79, ["Neon|Fly|Ride"] = 154.62, ["Mega"] = 160.02, ["Mega|Ride"] = 202.85, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 20.9, ["Neon"] = 4.6, ["Neon|Ride"] = 20.4, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 45.42, ["Mega|Ride"] = 100.08, ["Mega|Fly|Ride"] = 127.91}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 5.25, ["Ride"] = 26.5, ["Neon"] = 32.82, ["Neon|Ride"] = 108.47, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 548.65, ["Mega|Fly|Ride"] = 614.75}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 11.02, ["Fly"] = 25.47, ["Ride"] = 20.86, ["Fly|Ride"] = 54.16, ["Neon"] = 84.14, ["Neon|Ride"] = 117.8, ["Neon|Fly|Ride"] = 178.52, ["Mega"] = 597.19, ["Mega|Ride"] = 427.34, ["Mega|Fly|Ride"] = 465.42}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 20.28, ["Ride"] = 70.68, ["Fly|Ride"] = 105.54, ["Neon"] = 147.78, ["Neon|Ride"] = 155.8, ["Neon|Fly|Ride"] = 318.44, ["Mega"] = 525, ["Mega|Ride"] = 558.25, ["Mega|Fly|Ride"] = 771.1}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 144.38, ["Fly"] = 183.74, ["Ride"] = 168.92, ["Fly|Ride"] = 229.69, ["Neon"] = 590.76, ["Neon|Ride"] = 531.57, ["Neon|Fly|Ride"] = 611.63, ["Mega|Fly|Ride"] = 2428.13}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 19.68, ["Fly"] = 38.07, ["Ride"] = 27.41, ["Fly|Ride"] = 51.98, ["Neon"] = 133.47, ["Neon|Fly"] = 203.9, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 144.38, ["Mega|Ride"] = 676.58, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.1, ["Fly"] = 118.13, ["Ride"] = 20.57, ["Fly|Ride"] = 65.62, ["Neon"] = 13.13, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 130.39, ["Mega|Ride"] = 202.99, ["Mega|Fly|Ride"] = 249.6}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 13.65, ["Fly"] = 231.34, ["Ride"] = 27.57, ["Fly|Ride"] = 116.83, ["Neon"] = 38.07, ["Neon|Fly"] = 137.31, ["Neon|Ride"] = 68.75, ["Neon|Fly|Ride"] = 190.83, ["Mega"] = 376.82, ["Mega|Ride"] = 433.13, ["Mega|Fly|Ride"] = 393.74}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 43.05, ["Fly"] = 142.93, ["Ride"] = 85.36, ["Fly|Ride"] = 178.29, ["Neon"] = 209.12, ["Neon|Ride"] = 244.89, ["Neon|Fly|Ride"] = 380.52, ["Mega"] = 1174.8, ["Mega|Ride"] = 1076.39, ["Mega|Fly|Ride"] = 1057.71}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 17.07, ["Ride"] = 121.31, ["Neon"] = 196.88, ["Neon|Ride"] = 219.56, ["Neon|Fly|Ride"] = 452.43, ["Mega"] = 682.5, ["Mega|Ride"] = 820.11, ["Mega|Fly|Ride"] = 811.91}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 327.39, ["Ride"] = 412.13, ["Neon|Ride"] = 1968.75, ["Mega|Fly|Ride"] = 5906.25}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 35.44, ["Ride"] = 74.13, ["Fly|Ride"] = 69.57, ["Neon"] = 228.51, ["Neon|Ride"] = 224.79, ["Neon|Fly|Ride"] = 274.98, ["Mega"] = 1189.14, ["Mega|Ride"] = 900.46, ["Mega|Fly|Ride"] = 872.38}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 37.06, ["Ride"] = 15.39, ["Fly|Ride"] = 102.47, ["Neon"] = 2.1, ["Neon|Ride"] = 13.13, ["Neon|Fly|Ride"] = 64.34, ["Mega"] = 21.73, ["Mega|Fly"] = 102.74, ["Mega|Ride"] = 102.69, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 15.09, ["Neon|Ride"] = 69.21, ["Neon|Fly|Ride"] = 259.89, ["Mega|Ride"] = 215.57, ["Mega|Fly|Ride"] = 410.06}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 8.25, ["Fly"] = 26.75, ["Fly|Ride"] = 144.17, ["Neon"] = 18.22, ["Neon|Ride"] = 81.05, ["Neon|Fly|Ride"] = 958.18, ["Mega"] = 125.16, ["Mega|Fly"] = 533.07, ["Mega|Ride"] = 259.11, ["Mega|Fly|Ride"] = 334.69}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 393.75, ["Ride"] = 458.07, ["Fly|Ride"] = 615.33, ["Neon"] = 1382.73, ["Neon|Ride"] = 1231.07, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 4856.25}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 3.88, ["Fly"] = 57.01, ["Ride"] = 16.75, ["Fly|Ride"] = 52.5, ["Neon"] = 29.73, ["Neon|Ride"] = 41.54, ["Neon|Fly|Ride"] = 82.08, ["Mega"] = 168, ["Mega|Ride"] = 259.88, ["Mega|Fly|Ride"] = 410.92}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 6.6, ["Fly"] = 17, ["Ride"] = 17.07, ["Fly|Ride"] = 43.04, ["Neon"] = 39.38, ["Neon|Fly"] = 156.45, ["Neon|Ride"] = 51.31, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 683.76, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 5.2, ["Fly"] = 41.13, ["Ride"] = 27.56, ["Neon"] = 18.59, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 110.77, ["Mega"] = 77.44, ["Mega|Ride"] = 137.38, ["Mega|Fly|Ride"] = 302.43}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 36.66, ["Fly"] = 46.28, ["Ride"] = 40.2, ["Fly|Ride"] = 81.99, ["Neon"] = 137.31, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 210, ["Mega"] = 922.61, ["Mega|Ride"] = 820.11, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 39.37, ["Ride"] = 26.88, ["Fly|Ride"] = 68, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 210, ["Mega"] = 158.86, ["Mega|Ride"] = 425.43, ["Mega|Fly|Ride"] = 985.04}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 6.96, ["Fly"] = 787.5, ["Ride"] = 23.63, ["Fly|Ride"] = 85.63, ["Neon"] = 138.01, ["Neon|Ride"] = 164.34, ["Neon|Fly|Ride"] = 273.93, ["Mega|Fly|Ride"] = 826.88}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 19.17, ["Neon"] = 3.82, ["Neon|Ride"] = 20.53, ["Mega"] = 50.3, ["Mega|Ride"] = 137.38, ["Mega|Fly|Ride"] = 232.72}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 6.57, ["Ride"] = 137.31, ["Neon"] = 94.5, ["Mega"] = 164.04, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 19.49, ["Ride"] = 39.38, ["Neon"] = 63.84, ["Neon|Ride"] = 102.6, ["Neon|Fly|Ride"] = 380.63, ["Mega"] = 820.11, ["Mega|Ride"] = 340.07, ["Mega|Fly|Ride"] = 544.35}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 9.38, ["Fly"] = 55.54, ["Ride"] = 29.87, ["Fly|Ride"] = 45.48, ["Neon"] = 51.15, ["Neon|Fly"] = 115.24, ["Neon|Ride"] = 55.13, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 574.08, ["Mega|Ride"] = 393.65, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 262.39, ["Fly"] = 410.5, ["Ride"] = 301.87, ["Fly|Ride"] = 389.81, ["Neon"] = 1461.1, ["Neon|Ride"] = 1229.82, ["Neon|Fly|Ride"] = 1231.07, ["Mega|Fly|Ride"] = 5057.92}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 15.63, ["Neon"] = 10.29, ["Neon|Fly"] = 77.22, ["Neon|Ride"] = 58.49, ["Neon|Fly|Ride"] = 158.17, ["Mega"] = 219.39, ["Mega|Ride"] = 154.47, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 3.4, ["Fly"] = 27.81, ["Ride"] = 27.78, ["Fly|Ride"] = 80.27, ["Neon"] = 37.38, ["Neon|Ride"] = 108.47, ["Neon|Fly|Ride"] = 260.58, ["Mega"] = 282.92, ["Mega|Ride"] = 269.15}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 131.25, ["Fly"] = 117.24, ["Ride"] = 273.58, ["Fly|Ride"] = 200.51, ["Neon"] = 100.43, ["Neon|Ride"] = 205.19, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 328.12, ["Mega|Ride"] = 325.03, ["Mega|Fly|Ride"] = 513.57}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 116.83, ["Ride"] = 161.99, ["Fly|Ride"] = 348.38, ["Neon"] = 1093.26, ["Neon|Ride"] = 1076.23, ["Neon|Fly|Ride"] = 1168.13, ["Mega"] = 3074.28, ["Mega|Ride"] = 1792.88, ["Mega|Fly|Ride"] = 2815.26}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 32.71, ["Fly"] = 102.38, ["Ride"] = 81.99, ["Neon"] = 104.3, ["Neon|Ride"] = 307.78, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 236.25, ["Mega|Ride"] = 249.27, ["Mega|Fly|Ride"] = 473.62}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Ride"] = 16.59, ["Fly|Ride"] = 51.79, ["Neon"] = 9.19, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 39.38, ["Mega|Ride"] = 192.52, ["Mega|Fly|Ride"] = 192.94}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 8.48, ["Ride"] = 37.7, ["Fly|Ride"] = 80.96, ["Neon"] = 55.13, ["Neon|Ride"] = 94.25, ["Neon|Fly|Ride"] = 171.08, ["Mega"] = 160.79, ["Mega|Ride"] = 189.78, ["Mega|Fly|Ride"] = 545.37}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 60.96, ["Fly"] = 196.88, ["Ride"] = 111.57, ["Fly|Ride"] = 216.57, ["Neon"] = 141.26, ["Neon|Ride"] = 196.55, ["Neon|Fly|Ride"] = 350.51, ["Mega"] = 463.1, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 547.43}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.63, ["Ride"] = 75.84, ["Neon"] = 7.79, ["Neon|Ride"] = 205.19, ["Neon|Fly|Ride"] = 190.3, ["Mega"] = 65.62, ["Mega|Fly"] = 239.89, ["Mega|Ride"] = 167.26, ["Mega|Fly|Ride"] = 153.57}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 10.29, ["Fly|Ride"] = 272.55, ["Neon"] = 110.79, ["Neon|Ride"] = 401.03, ["Mega"] = 477.72, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 810.88}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 961.54, ["Fly"] = 1253.81, ["Ride"] = 1088.84, ["Fly|Ride"] = 1146.3, ["Neon"] = 3464.87, ["Neon|Ride"] = 2872.48, ["Neon|Fly|Ride"] = 2723.44, ["Mega|Fly|Ride"] = 14214.21}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 22.93, ["Fly"] = 115.9, ["Ride"] = 119.47, ["Fly|Ride"] = 191.63, ["Neon"] = 122.49, ["Neon|Fly"] = 892.5, ["Neon|Ride"] = 191.86, ["Mega"] = 957.47, ["Mega|Ride"] = 576.36, ["Mega|Fly|Ride"] = 649.69}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.1, ["Fly"] = 49.25, ["Ride"] = 26.24, ["Fly|Ride"] = 41.22, ["Neon"] = 15.16, ["Neon|Fly"] = 79.83, ["Neon|Ride"] = 30.86, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 78.66, ["Mega|Ride"] = 107.6, ["Mega|Fly|Ride"] = 176.5}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 7.88, ["Ride"] = 131.22, ["Fly|Ride"] = 137.31, ["Neon"] = 122.97, ["Mega"] = 257.29, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 17.54, ["Fly|Ride"] = 65.63, ["Neon"] = 2.1, ["Neon|Ride"] = 19.19, ["Neon|Fly|Ride"] = 91.87, ["Mega"] = 19.69, ["Mega|Fly"] = 123.03, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 149.68}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 67.48, ["Ride"] = 109.08, ["Fly|Ride"] = 236.25, ["Neon"] = 339.94, ["Neon|Ride"] = 276.46, ["Mega"] = 1030.53, ["Mega|Ride"] = 976.81, ["Mega|Fly|Ride"] = 1515.13}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 8.27, ["Ride"] = 23.63, ["Fly|Ride"] = 101.07, ["Neon"] = 47.16, ["Neon|Ride"] = 97.13, ["Neon|Fly|Ride"] = 108.47, ["Mega"] = 396.74, ["Mega|Ride"] = 460.29, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2.1, ["Fly"] = 97.01, ["Ride"] = 26.75, ["Fly|Ride"] = 46.11, ["Neon"] = 8.99, ["Neon|Ride"] = 47.22, ["Mega"] = 145.15, ["Mega|Ride"] = 258.03}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 83.85, ["Ride"] = 54.38, ["Fly|Ride"] = 196.88, ["Neon"] = 262.5, ["Neon|Ride"] = 117.99, ["Neon|Fly|Ride"] = 190.32, ["Mega"] = 547.43, ["Mega|Ride"] = 1025.13, ["Mega|Fly|Ride"] = 768.88}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 11.7, ["Ride"] = 30.86, ["Fly|Ride"] = 86.08, ["Neon"] = 203.44, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 315, ["Mega"] = 575.22, ["Mega|Ride"] = 500.27, ["Mega|Fly|Ride"] = 452.08}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 64.67, ["Ride"] = 84, ["Neon"] = 384.87, ["Neon|Ride"] = 623.44, ["Neon|Fly|Ride"] = 917.44, ["Mega"] = 1867.7, ["Mega|Ride"] = 1640.19, ["Mega|Fly|Ride"] = 1578.68}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 3.92, ["Neon"] = 24.22, ["Neon|Ride"] = 84.36, ["Neon|Fly|Ride"] = 169.32, ["Mega"] = 132.24, ["Mega|Ride"] = 126.82, ["Mega|Fly|Ride"] = 287.34}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 7.48, ["Ride"] = 22.32, ["Fly|Ride"] = 78.74, ["Neon"] = 45.48, ["Neon|Ride"] = 65.76, ["Neon|Fly|Ride"] = 126.34, ["Mega"] = 399, ["Mega|Ride"] = 366.53, ["Mega|Fly|Ride"] = 396.74}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 114.19, ["Fly"] = 514.11, ["Ride"] = 157.5, ["Fly|Ride"] = 258.85, ["Neon"] = 542.22, ["Neon|Ride"] = 523.69, ["Neon|Fly|Ride"] = 589.91, ["Mega"] = 3134.81, ["Mega|Ride"] = 2335.15, ["Mega|Fly|Ride"] = 1825.69}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 25.35, ["Ride"] = 18.38, ["Fly|Ride"] = 40.93, ["Neon"] = 11.46, ["Neon|Fly"] = 64.97, ["Neon|Ride"] = 24.76, ["Neon|Fly|Ride"] = 61.26, ["Mega"] = 65.54, ["Mega|Fly"] = 123.36, ["Mega|Ride"] = 155.3, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 7.07, ["Fly"] = 91.02, ["Ride"] = 24.44, ["Fly|Ride"] = 91.88, ["Neon"] = 69.44, ["Neon|Fly"] = 230.47, ["Neon|Ride"] = 92.31, ["Neon|Fly|Ride"] = 178.5, ["Mega"] = 377.37, ["Mega|Ride"] = 329.53, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 12.38, ["Fly|Ride"] = 43.31, ["Neon"] = 2.1, ["Neon|Fly"] = 24.35, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 45.03, ["Mega"] = 14.8, ["Mega|Fly"] = 48.43, ["Mega|Ride"] = 45.92, ["Mega|Fly|Ride"] = 77.44}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 131.14, ["Neon"] = 3.54, ["Neon|Ride"] = 39, ["Mega"] = 22.74, ["Mega|Fly"] = 118.12, ["Mega|Ride"] = 59.91, ["Mega|Fly|Ride"] = 109.7}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.1, ["Fly"] = 34.98, ["Ride"] = 18.38, ["Fly|Ride"] = 85.78, ["Neon"] = 14.97, ["Neon|Ride"] = 58.85, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 109.7, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 39.34, ["Ride"] = 315, ["Neon"] = 117.74, ["Neon|Ride"] = 409.86, ["Neon|Fly|Ride"] = 630, ["Mega"] = 414.21, ["Mega|Ride"] = 392.44, ["Mega|Fly|Ride"] = 663.27}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 16.58, ["Fly|Ride"] = 34.85, ["Neon"] = 12.31, ["Neon|Fly"] = 31.13, ["Neon|Ride"] = 24.93, ["Neon|Fly|Ride"] = 60.38, ["Mega"] = 108.38, ["Mega|Fly"] = 170.6, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 180.38}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 5.82, ["Fly"] = 30.96, ["Ride"] = 23.15, ["Fly|Ride"] = 55.13, ["Neon"] = 24.83, ["Neon|Fly"] = 64.97, ["Neon|Ride"] = 31.06, ["Neon|Fly|Ride"] = 78.66, ["Mega"] = 182.44, ["Mega|Fly"] = 410.06, ["Mega|Ride"] = 155.93, ["Mega|Fly|Ride"] = 220.5}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.26, ["Fly"] = 22.23, ["Ride"] = 18.09, ["Fly|Ride"] = 76.36, ["Neon"] = 11.74, ["Neon|Fly"] = 85.29, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 60.38, ["Mega|Fly"] = 101.5, ["Mega|Ride"] = 115.5, ["Mega|Fly|Ride"] = 128.81}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 8.48, ["Fly"] = 36.01, ["Ride"] = 32.95, ["Neon"] = 35.44, ["Neon|Ride"] = 80.04, ["Neon|Fly|Ride"] = 273.93, ["Mega"] = 220.23, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 410.06}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 6.4, ["Fly"] = 170.69, ["Ride"] = 122.72, ["Fly|Ride"] = 180.35, ["Neon"] = 123.38, ["Neon|Ride"] = 259.76, ["Mega"] = 547.43, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 5.25, ["Fly"] = 41.88, ["Ride"] = 26.75, ["Fly|Ride"] = 68.66, ["Neon"] = 24.31, ["Neon|Fly"] = 196.67, ["Neon|Ride"] = 60.77, ["Neon|Fly|Ride"] = 106.32, ["Mega"] = 328.06, ["Mega|Ride"] = 230.55, ["Mega|Fly|Ride"] = 418.28}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 20.9, ["Ride"] = 15.75, ["Fly|Ride"] = 34.94, ["Neon"] = 11.64, ["Neon|Fly"] = 68.33, ["Neon|Ride"] = 31.26, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 131.25, ["Mega|Ride"] = 137.38, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 181.81, ["Fly"] = 385.91, ["Ride"] = 308.46, ["Fly|Ride"] = 392.43, ["Neon"] = 1120.93, ["Neon|Ride"] = 1231.07, ["Neon|Fly|Ride"] = 1025.89, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 7.88, ["Ride"] = 61.76, ["Neon"] = 42.94, ["Neon|Ride"] = 55.41, ["Neon|Fly|Ride"] = 410.37, ["Mega"] = 119.62, ["Mega|Ride"] = 410.06, ["Mega|Fly|Ride"] = 472.49}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 3.94, ["Fly"] = 26.25, ["Ride"] = 21.63, ["Fly|Ride"] = 79.07, ["Neon"] = 23.15, ["Neon|Fly"] = 219.28, ["Neon|Ride"] = 46.16, ["Neon|Fly|Ride"] = 200.59, ["Mega"] = 201.1, ["Mega|Ride"] = 276.66, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 14.42, ["Ride"] = 34.85, ["Neon"] = 27.57, ["Neon|Ride"] = 213.44, ["Neon|Fly|Ride"] = 615.55, ["Mega"] = 461.77, ["Mega|Ride"] = 328.06, ["Mega|Fly|Ride"] = 547.98}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 13.13, ["Fly|Ride"] = 30.75, ["Neon"] = 2.63, ["Neon|Fly"] = 23.63, ["Neon|Ride"] = 15.38, ["Neon|Fly|Ride"] = 44.63, ["Mega"] = 15.44, ["Mega|Fly"] = 162.75, ["Mega|Ride"] = 41.02, ["Mega|Fly|Ride"] = 96.46}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.1, ["Fly"] = 24.92, ["Ride"] = 17.07, ["Fly|Ride"] = 59.07, ["Neon"] = 6.57, ["Neon|Ride"] = 28.98, ["Neon|Fly|Ride"] = 94.81, ["Mega"] = 101.04, ["Mega|Ride"] = 143.59, ["Mega|Fly|Ride"] = 202.13}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.63, ["Ride"] = 68.91, ["Neon"] = 16.41, ["Neon|Ride"] = 273.93, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 63.59, ["Mega|Ride"] = 204.02, ["Mega|Fly|Ride"] = 308.95}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 75.51, ["Fly"] = 123.39, ["Ride"] = 108.63, ["Fly|Ride"] = 135.27, ["Neon"] = 615.33, ["Neon|Ride"] = 459.61, ["Neon|Fly|Ride"] = 415.8, ["Mega"] = 2050.23, ["Mega|Ride"] = 3418.77, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 5.4, ["Fly"] = 91.88, ["Ride"] = 30.09, ["Fly|Ride"] = 262.48, ["Neon"] = 22.09, ["Neon|Ride"] = 92.7, ["Neon|Fly|Ride"] = 92.31, ["Mega"] = 209.42, ["Mega|Ride"] = 355.72, ["Mega|Fly|Ride"] = 409.04}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 20.99, ["Ride"] = 47.39, ["Fly|Ride"] = 117.85, ["Neon"] = 15.75, ["Neon|Ride"] = 177.06, ["Neon|Fly|Ride"] = 519.53, ["Mega"] = 52.5, ["Mega|Fly"] = 313.69, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 205.04}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 54.51, ["Fly"] = 210, ["Ride"] = 88.36, ["Fly|Ride"] = 204.93, ["Neon"] = 118.13, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 302.65, ["Mega"] = 568.32, ["Mega|Ride"] = 614.25, ["Mega|Fly|Ride"] = 711.44}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 14.44, ["Ride"] = 6.46, ["Fly|Ride"] = 25.72, ["Neon"] = 2.1, ["Neon|Fly"] = 18.46, ["Neon|Ride"] = 15.67, ["Neon|Fly|Ride"] = 34.13, ["Mega"] = 17.07, ["Mega|Fly"] = 49.38, ["Mega|Ride"] = 52.29, ["Mega|Fly|Ride"] = 112.88}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Neon"] = 4.6, ["Neon|Ride"] = 27.25, ["Neon|Fly|Ride"] = 123.83, ["Mega"] = 86.63, ["Mega|Ride"] = 96.8, ["Mega|Fly|Ride"] = 135.19}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 3.94, ["Ride"] = 107.63, ["Neon"] = 10.26, ["Neon|Ride"] = 90.96, ["Neon|Fly|Ride"] = 181.25, ["Mega"] = 64.32, ["Mega|Fly"] = 178.38, ["Mega|Ride"] = 116.05, ["Mega|Fly|Ride"] = 198.94}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 11.15, ["Fly"] = 68.25, ["Ride"] = 36.01, ["Fly|Ride"] = 130.14, ["Neon"] = 21.15, ["Neon|Fly"] = 137.31, ["Neon|Ride"] = 71.47, ["Neon|Fly|Ride"] = 230.76, ["Mega"] = 104.63, ["Mega|Fly"] = 330.84, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 288.73}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 15.44, ["Ride"] = 14.81, ["Fly|Ride"] = 31.5, ["Neon"] = 2.63, ["Neon|Fly"] = 25.67, ["Neon|Ride"] = 48.24, ["Neon|Fly|Ride"] = 44, ["Mega"] = 14.44, ["Mega|Ride"] = 32.71, ["Mega|Fly|Ride"] = 118.12}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 15.44, ["Fly"] = 72.19, ["Ride"] = 116.83, ["Neon"] = 99.67, ["Neon|Fly"] = 409.86, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 958.18, ["Mega"] = 387.51, ["Mega|Ride"] = 438.38, ["Mega|Fly|Ride"] = 676.58}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2774.06, ["Ride"] = 2613.66, ["Fly|Ride"] = 2559.38, ["Neon"] = 10246.01, ["Neon|Fly|Ride"] = 10943.07, ["Mega|Fly|Ride"] = 34443.77}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 19.2, ["Ride"] = 15.44, ["Fly|Ride"] = 135.18, ["Neon"] = 9.13, ["Neon|Fly"] = 62.23, ["Neon|Ride"] = 23.64, ["Neon|Fly|Ride"] = 45.03, ["Mega"] = 81.38, ["Mega|Fly"] = 456.19, ["Mega|Ride"] = 113.22, ["Mega|Fly|Ride"] = 172.79}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.1, ["Neon"] = 9.19, ["Neon|Fly|Ride"] = 47.25, ["Mega"] = 187.04, ["Mega|Fly"] = 441, ["Mega|Ride"] = 137.38, ["Mega|Fly|Ride"] = 191.71}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 18.38, ["Ride"] = 33.5, ["Fly|Ride"] = 105, ["Neon"] = 105, ["Neon|Ride"] = 293.06, ["Neon|Fly|Ride"] = 275.62, ["Mega"] = 393.75, ["Mega|Ride"] = 397.69, ["Mega|Fly|Ride"] = 533.07}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 31.7, ["Ride"] = 58.63, ["Neon"] = 155.07, ["Neon|Ride"] = 205.19, ["Neon|Fly|Ride"] = 205.19, ["Mega"] = 550.68, ["Mega|Ride"] = 765.77, ["Mega|Fly|Ride"] = 806.91}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 169.98, ["Fly"] = 1371.61, ["Ride"] = 197.75, ["Fly|Ride"] = 372.98, ["Neon"] = 778.72, ["Neon|Ride"] = 693.39, ["Neon|Fly|Ride"] = 787.65, ["Mega"] = 6150.68, ["Mega|Fly|Ride"] = 3378.38}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 8.25, ["Ride"] = 28.88, ["Fly|Ride"] = 675.94, ["Neon"] = 19.28, ["Neon|Ride"] = 132.83, ["Mega"] = 106.32, ["Mega|Fly"] = 13125, ["Mega|Ride"] = 163.03, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 55.54, ["Neon"] = 13.13, ["Neon|Fly"] = 102.47, ["Neon|Ride"] = 273.93, ["Neon|Fly|Ride"] = 512.95, ["Mega"] = 118.29, ["Mega|Ride"] = 320.25, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Fly"] = 101.99, ["Ride"] = 40.42, ["Fly|Ride"] = 131.25, ["Neon"] = 7.88, ["Neon|Ride"] = 56.44, ["Mega"] = 77.44, ["Mega|Ride"] = 96.29, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 15.36, ["Ride"] = 102.83, ["Neon"] = 135.19, ["Neon|Ride"] = 1165.83, ["Neon|Fly|Ride"] = 483.2, ["Mega|Ride"] = 602.78, ["Mega|Fly|Ride"] = 715.54}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 41.13, ["Neon"] = 2.1, ["Neon|Ride"] = 82.08, ["Mega"] = 17.07, ["Mega|Fly"] = 115.29, ["Mega|Ride"] = 154.47, ["Mega|Fly|Ride"] = 272.7}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 96.77, ["Fly"] = 137.8, ["Ride"] = 110.03, ["Fly|Ride"] = 168.05, ["Neon"] = 408.83, ["Neon|Ride"] = 452.43, ["Neon|Fly|Ride"] = 464.97, ["Mega"] = 1050, ["Mega|Fly|Ride"] = 1717.07}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Fly"] = 96.67, ["Ride"] = 91.82, ["Neon"] = 10.29, ["Neon|Ride"] = 68.75, ["Neon|Fly|Ride"] = 205.19, ["Mega"] = 76.91, ["Mega|Ride"] = 202.99, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 45.36, ["Fly"] = 205.65, ["Ride"] = 85.49, ["Fly|Ride"] = 196.88, ["Neon"] = 262.5, ["Neon|Ride"] = 260.58, ["Neon|Fly|Ride"] = 630, ["Mega"] = 2625, ["Mega|Ride"] = 1894.43, ["Mega|Fly|Ride"] = 1546.13}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 19.5, ["Fly|Ride"] = 50.81, ["Neon"] = 4.64, ["Neon|Fly"] = 87.44, ["Neon|Ride"] = 68.75, ["Neon|Fly|Ride"] = 83.98, ["Mega"] = 46.92, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 166.82}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Neon"] = 12.29, ["Neon|Ride"] = 105, ["Mega"] = 61.23, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 605.49}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 12.71, ["Ride"] = 36.65, ["Neon"] = 51.24, ["Neon|Ride"] = 94.4, ["Neon|Fly|Ride"] = 205.19, ["Mega"] = 231.18, ["Mega|Ride"] = 344.45, ["Mega|Fly|Ride"] = 912.95}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 420, ["Ride"] = 379.32, ["Fly|Ride"] = 525, ["Neon"] = 1080.19, ["Neon|Ride"] = 1207.37, ["Neon|Fly|Ride"] = 1246.88, ["Mega|Ride"] = 4725, ["Mega|Fly|Ride"] = 4192.13}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 35.35, ["Ride"] = 47.48, ["Fly|Ride"] = 96.5, ["Neon"] = 204.93, ["Neon|Ride"] = 243.41, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 1209.65, ["Mega|Fly|Ride"] = 1093.81}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 49.88, ["Ride"] = 17.74, ["Fly|Ride"] = 91.88, ["Neon"] = 7.62, ["Neon|Fly"] = 133.21, ["Neon|Ride"] = 19.62, ["Neon|Fly|Ride"] = 89.25, ["Mega"] = 51.98, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 18.51, ["Fly"] = 82.26, ["Ride"] = 52.5, ["Fly|Ride"] = 131.25, ["Neon"] = 53.29, ["Neon|Fly"] = 105, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 174.12, ["Mega"] = 257.25, ["Mega|Fly"] = 948.69, ["Mega|Ride"] = 254.63, ["Mega|Fly|Ride"] = 360.94}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 7.88, ["Ride"] = 20.68, ["Fly|Ride"] = 261.29, ["Neon"] = 137.31, ["Neon|Ride"] = 75.93, ["Neon|Fly|Ride"] = 308.05, ["Mega"] = 1093.81, ["Mega|Ride"] = 514.5, ["Mega|Fly|Ride"] = 408.71}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.72, ["Neon"] = 17.3, ["Mega"] = 70.72, ["Mega|Ride"] = 122.06}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.1, ["Fly"] = 86.62, ["Ride"] = 20.16, ["Fly|Ride"] = 57.63, ["Neon"] = 24.94, ["Neon|Ride"] = 32.79, ["Neon|Fly|Ride"] = 210.08, ["Mega"] = 137.38, ["Mega|Ride"] = 482.07, ["Mega|Fly|Ride"] = 1640.19}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 110.44, ["Ride"] = 131.25, ["Fly|Ride"] = 220.89, ["Neon"] = 615.33, ["Neon|Ride"] = 616.88, ["Neon|Fly|Ride"] = 692.26, ["Mega|Fly|Ride"] = 2569.96}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 22.17, ["Ride"] = 102.83, ["Fly|Ride"] = 137.31, ["Neon"] = 192.94, ["Neon|Ride"] = 192.15, ["Neon|Fly|Ride"] = 273.93, ["Mega"] = 682.5, ["Mega|Ride"] = 716.57, ["Mega|Fly|Ride"] = 673.98}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2216.71, ["Fly"] = 2330.91, ["Ride"] = 2229.94, ["Fly|Ride"] = 2098.69, ["Neon"] = 10929.42, ["Neon|Fly|Ride"] = 5848.5, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 2.1, ["Fly"] = 65625, ["Ride"] = 107.63, ["Fly|Ride"] = 196.87, ["Neon"] = 9.08, ["Neon|Ride"] = 137.48, ["Neon|Fly|Ride"] = 105, ["Mega"] = 104.89, ["Mega|Fly"] = 786.19, ["Mega|Ride"] = 184.42, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 7.5, ["Ride"] = 51.24, ["Fly|Ride"] = 137.31, ["Neon"] = 31.5, ["Neon|Ride"] = 104.78, ["Neon|Fly|Ride"] = 232.32, ["Mega"] = 185.41, ["Mega|Ride"] = 297.71, ["Mega|Fly|Ride"] = 596.64}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 1025.09, ["Fly"] = 1154.34, ["Ride"] = 918.75, ["Fly|Ride"] = 945, ["Neon"] = 2623.69, ["Neon|Ride"] = 2923.56, ["Neon|Fly|Ride"] = 2624.99, ["Mega|Fly|Ride"] = 9383.07}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 29.98, ["Fly"] = 68.91, ["Ride"] = 64.56, ["Fly|Ride"] = 173.35, ["Neon"] = 209.04, ["Neon|Ride"] = 291.72, ["Mega"] = 840, ["Mega|Ride"] = 804.56, ["Mega|Fly|Ride"] = 820.11}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 2.1, ["Ride"] = 22.91, ["Fly|Ride"] = 128.15, ["Neon"] = 24.92, ["Neon|Ride"] = 41.05, ["Neon|Fly|Ride"] = 328.12, ["Mega"] = 196.88, ["Mega|Ride"] = 123.97, ["Mega|Fly|Ride"] = 511.54}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 52.41, ["Ride"] = 137.8, ["Neon"] = 3.94, ["Neon|Fly"] = 41.01, ["Neon|Ride"] = 54.85, ["Neon|Fly|Ride"] = 77.32, ["Mega"] = 24.62, ["Mega|Ride"] = 250.15, ["Mega|Fly|Ride"] = 246.04}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 84.06, ["Ride"] = 127.32, ["Fly|Ride"] = 204.93, ["Neon"] = 459.38, ["Neon|Fly|Ride"] = 545.74, ["Mega"] = 8200.91, ["Mega|Fly|Ride"] = 2323.94}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 2.86, ["Neon"] = 15.75, ["Neon|Ride"] = 123.13, ["Neon|Fly|Ride"] = 115.39, ["Mega"] = 174.07, ["Mega|Ride"] = 323.95, ["Mega|Fly|Ride"] = 163.96}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 72.35, ["Ride"] = 136.5, ["Neon"] = 380.63, ["Neon|Ride"] = 461.5, ["Neon|Fly|Ride"] = 494.32}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 2.37, ["Fly"] = 105, ["Fly|Ride"] = 109.65, ["Neon"] = 39.19, ["Neon|Ride"] = 77.32, ["Neon|Fly|Ride"] = 196.87, ["Mega"] = 137.38, ["Mega|Ride"] = 309.02, ["Mega|Fly|Ride"] = 178.38}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 248.07, ["Fly"] = 393.75, ["Ride"] = 268.32, ["Fly|Ride"] = 366.62, ["Neon"] = 1410.28, ["Neon|Ride"] = 836.06, ["Neon|Fly|Ride"] = 879.38, ["Mega|Fly|Ride"] = 3899.56}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 3.19, ["Fly"] = 87.72, ["Ride"] = 20.51, ["Fly|Ride"] = 55.35, ["Neon"] = 78.1, ["Neon|Ride"] = 65.5, ["Neon|Fly|Ride"] = 114.18, ["Mega|Ride"] = 272.12, ["Mega|Fly|Ride"] = 352.95}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 26.2, ["Ride"] = 15.74, ["Fly|Ride"] = 39.38, ["Neon"] = 6.57, ["Neon|Fly"] = 30.75, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 45.7, ["Mega|Fly"] = 110.87, ["Mega|Ride"] = 81.38, ["Mega|Fly|Ride"] = 137.68}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 915.81, ["Ride"] = 1050, ["Fly|Ride"] = 1114.32, ["Neon|Ride"] = 7523.82, ["Neon|Fly|Ride"] = 5472.06, ["Mega"] = 25970.21}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 6.46, ["Fly"] = 960.33, ["Ride"] = 72.19, ["Neon"] = 57.1, ["Neon|Ride"] = 129.4, ["Mega"] = 246.04, ["Mega|Ride"] = 376.23, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 7.79, ["Fly"] = 46.1, ["Ride"] = 35.25, ["Fly|Ride"] = 95.82, ["Neon"] = 30.17, ["Neon|Fly"] = 123.31, ["Neon|Ride"] = 58.49, ["Neon|Fly|Ride"] = 137.48, ["Mega"] = 181.13, ["Mega|Fly"] = 226.56, ["Mega|Ride"] = 190.21, ["Mega|Fly|Ride"] = 262.22}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 33.5, ["Fly"] = 40.85, ["Ride"] = 32.82, ["Fly|Ride"] = 66.26, ["Neon"] = 219.28, ["Neon|Ride"] = 246.75, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 2050.23, ["Mega|Ride"] = 1230.15, ["Mega|Fly|Ride"] = 739.12}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 13.53, ["Fly"] = 59.07, ["Ride"] = 27.43, ["Fly|Ride"] = 89.25, ["Neon"] = 68.16, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 73.5, ["Neon|Fly|Ride"] = 177.18, ["Mega"] = 367.49, ["Mega|Fly"] = 367.5, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 31.5, ["Ride"] = 209.99, ["Fly|Ride"] = 399.6, ["Neon"] = 108.33, ["Neon|Ride"] = 539.96, ["Mega"] = 461.09, ["Mega|Ride"] = 572.02, ["Mega|Fly|Ride"] = 880.41}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 65.63, ["Fly|Ride"] = 230.47, ["Neon"] = 2.1, ["Neon|Fly"] = 55.6, ["Neon|Ride"] = 108.71, ["Neon|Fly|Ride"] = 308.05, ["Mega"] = 18.27, ["Mega|Ride"] = 74.72, ["Mega|Fly|Ride"] = 96.81}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 50.67, ["Fly"] = 110.18, ["Ride"] = 75.95, ["Fly|Ride"] = 137.31, ["Neon"] = 336.48, ["Neon|Fly"] = 380.26, ["Neon|Ride"] = 314.96, ["Neon|Fly|Ride"] = 371.67, ["Mega"] = 3280.37, ["Mega|Fly|Ride"] = 1187.57}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.1, ["Fly"] = 102.27, ["Ride"] = 22.09, ["Fly|Ride"] = 81.58, ["Neon"] = 32.81, ["Neon|Ride"] = 78.72, ["Mega"] = 773.07, ["Mega|Ride"] = 341.54, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 19.59, ["Ride"] = 16.47, ["Fly|Ride"] = 38.07, ["Neon"] = 14.85, ["Neon|Ride"] = 52.33, ["Neon|Fly|Ride"] = 122.84, ["Mega|Ride"] = 268.58, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 8.23, ["Ride"] = 171.73, ["Neon"] = 20.14, ["Neon|Fly|Ride"] = 184.33, ["Mega"] = 260.39}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 31.39, ["Ride"] = 88.1, ["Fly|Ride"] = 137.31, ["Neon"] = 260.26, ["Neon|Ride"] = 245.91, ["Neon|Fly|Ride"] = 273.93, ["Mega"] = 1012.82, ["Mega|Ride"] = 1010.63, ["Mega|Fly|Ride"] = 922.18}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 7.9, ["Fly|Ride"] = 409.86, ["Neon"] = 20.9, ["Neon|Ride"] = 76.95, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 96.06, ["Mega|Ride"] = 109.7, ["Mega|Fly|Ride"] = 307.79}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 33.78, ["Neon"] = 2.63, ["Neon|Ride"] = 20.6, ["Mega"] = 15.65, ["Mega|Ride"] = 55.6, ["Mega|Fly|Ride"] = 341.16}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 68.91, ["Ride"] = 25.24, ["Fly|Ride"] = 133.49, ["Neon"] = 2.1, ["Neon|Ride"] = 32.84, ["Neon|Fly|Ride"] = 118.12, ["Mega"] = 23.69, ["Mega|Ride"] = 32.82, ["Mega|Fly|Ride"] = 109.7}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 23.35, ["Ride"] = 15.38, ["Fly|Ride"] = 38.66, ["Neon"] = 5.34, ["Neon|Fly"] = 122.97, ["Neon|Ride"] = 19.97, ["Neon|Fly|Ride"] = 75.93, ["Mega"] = 98.42, ["Mega|Ride"] = 58.49, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 65.63, ["Neon"] = 21.84, ["Neon|Ride"] = 1312.5, ["Mega"] = 118.09, ["Mega|Ride"] = 106.3, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 15.41, ["Fly|Ride"] = 32.82, ["Neon"] = 14.34, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 229.04, ["Mega|Ride"] = 273.73, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 57.07, ["Ride"] = 155.23, ["Fly|Ride"] = 358.62, ["Neon"] = 196.88, ["Neon|Ride"] = 231.27, ["Neon|Fly|Ride"] = 1025.89, ["Mega"] = 1537.73, ["Mega|Ride"] = 883.31, ["Mega|Fly|Ride"] = 1061.01}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 16.14, ["Ride"] = 14.69, ["Fly|Ride"] = 32.82, ["Neon"] = 4.11, ["Neon|Fly"] = 26.66, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 47.25, ["Mega"] = 28.77, ["Mega|Ride"] = 88.56, ["Mega|Fly|Ride"] = 127.05}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 8.6, ["Fly"] = 75.28, ["Ride"] = 33.48, ["Fly|Ride"] = 94.28, ["Neon"] = 35.44, ["Neon|Fly"] = 87.18, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 96.46, ["Mega"] = 310.43, ["Mega|Ride"] = 238.88, ["Mega|Fly|Ride"] = 296.26}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 15.32, ["Fly"] = 39.38, ["Ride"] = 26.25, ["Fly|Ride"] = 65.62, ["Neon"] = 109.05, ["Neon|Ride"] = 142.67, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 787.5, ["Mega|Ride"] = 459.27, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 2.1, ["Fly"] = 196.88, ["Neon"] = 45.94, ["Neon|Ride"] = 41.01, ["Mega"] = 288.75, ["Mega|Ride"] = 259.88, ["Mega|Fly|Ride"] = 409.04}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 19.68, ["Ride"] = 16.47, ["Fly|Ride"] = 38.95, ["Neon"] = 4.2, ["Neon|Fly"] = 39.98, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 41.91, ["Mega|Fly"] = 168.13, ["Mega|Ride"] = 59.42, ["Mega|Fly|Ride"] = 121.96}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 30.75, ["Neon"] = 11.26, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 96.53, ["Mega"] = 136.5, ["Mega|Fly"] = 735, ["Mega|Ride"] = 155.81, ["Mega|Fly|Ride"] = 396.74}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 931.88, ["Fly"] = 1233.83, ["Ride"] = 945, ["Fly|Ride"] = 1049.99, ["Neon|Ride"] = 2191.86, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 6920.22}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 81.38, ["Ride"] = 137.82, ["Fly|Ride"] = 183.75, ["Neon"] = 413.44, ["Neon|Ride"] = 458.07, ["Neon|Fly|Ride"] = 602.2, ["Mega"] = 3074.33, ["Mega|Ride"] = 2460.28, ["Mega|Fly|Ride"] = 1675.05}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Neon"] = 5.81, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 205.19, ["Mega"] = 72.92, ["Mega|Fly|Ride"] = 205.04}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 57.93, ["Ride"] = 95.81, ["Fly|Ride"] = 129.94, ["Neon"] = 301.88, ["Neon|Ride"] = 274.76, ["Neon|Fly|Ride"] = 410.37, ["Mega"] = 1050, ["Mega|Ride"] = 1306.01, ["Mega|Fly|Ride"] = 1162.49}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 4.88, ["Ride"] = 26.37, ["Fly|Ride"] = 89.16, ["Neon"] = 19.69, ["Neon|Fly"] = 54.16, ["Neon|Ride"] = 47.31, ["Neon|Fly|Ride"] = 273.73, ["Mega"] = 268.55, ["Mega|Ride"] = 305.92, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 294.08, ["Fly"] = 411.28, ["Ride"] = 334.69, ["Fly|Ride"] = 451.87, ["Neon|Ride"] = 1522.5, ["Neon|Fly|Ride"] = 1736.55, ["Mega|Fly|Ride"] = 4541.67}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 75.64, ["Ride"] = 40.11, ["Fly|Ride"] = 200.62, ["Neon"] = 24.68, ["Neon|Ride"] = 54.37, ["Mega"] = 164.04, ["Mega|Fly"] = 319.86, ["Mega|Ride"] = 184.45, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 22.56, ["Neon|Ride"] = 137.48, ["Mega"] = 328.06}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 65.54, ["Ride"] = 78.62, ["Fly|Ride"] = 196.88, ["Neon"] = 196.88, ["Neon|Fly"] = 409.86, ["Neon|Ride"] = 190.83, ["Neon|Fly|Ride"] = 273.93, ["Mega"] = 542, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 957.47}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 49.54, ["Fly|Ride"] = 273.58, ["Neon"] = 20.51, ["Mega"] = 196.88, ["Mega|Ride"] = 250.74, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 12.69, ["Ride"] = 15.38, ["Fly|Ride"] = 20.57, ["Neon"] = 3.86, ["Neon|Fly"] = 31.29, ["Neon|Ride"] = 30.75, ["Neon|Fly|Ride"] = 30.19, ["Mega"] = 27.56, ["Mega|Ride"] = 38.56, ["Mega|Fly|Ride"] = 76.13}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4331.25, ["Ride"] = 4396.88, ["Fly|Ride"] = 4436.25, ["Neon"] = 30738.01, ["Neon|Fly|Ride"] = 21748.67, ["Mega|Fly|Ride"] = 84742.95}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 11.46, ["Fly"] = 39.38, ["Ride"] = 54.51, ["Neon"] = 52.39, ["Neon|Ride"] = 106.32, ["Mega|Ride"] = 224.86, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 23.45, ["Ride"] = 15.44, ["Fly|Ride"] = 40.04, ["Neon"] = 13.26, ["Neon|Fly"] = 45.9, ["Neon|Ride"] = 31.16, ["Neon|Fly|Ride"] = 71.64, ["Mega"] = 131.25, ["Mega|Ride"] = 154.47, ["Mega|Fly|Ride"] = 194.91}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 495.13, ["Fly"] = 547.77, ["Ride"] = 544.69, ["Fly|Ride"] = 573.79, ["Neon"] = 1366.83, ["Neon|Ride"] = 1639.37, ["Neon|Fly|Ride"] = 1641.43, ["Mega|Fly|Ride"] = 5467.96}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 2.63, ["Ride"] = 26.25, ["Neon"] = 17.07, ["Neon|Ride"] = 145.69, ["Mega"] = 139.08, ["Mega|Fly|Ride"] = 683.76}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 7.97, ["Fly"] = 4112.75, ["Ride"] = 46.11, ["Neon"] = 27.68, ["Neon|Ride"] = 273.93, ["Neon|Fly|Ride"] = 273.93, ["Mega"] = 408.01, ["Mega|Ride"] = 401.63, ["Mega|Fly|Ride"] = 491.54}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 52.45, ["Ride"] = 27.66, ["Neon"] = 2.52, ["Neon|Fly"] = 124.68, ["Neon|Ride"] = 22.39, ["Neon|Fly|Ride"] = 91.75, ["Mega"] = 44.63, ["Mega|Ride"] = 76.13, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 511.88, ["Fly"] = 870.89, ["Ride"] = 727.13, ["Fly|Ride"] = 656.25, ["Neon"] = 2362.5, ["Neon|Ride"] = 2557.37, ["Neon|Fly|Ride"] = 1680}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 6.57, ["Fly"] = 56.44, ["Ride"] = 78.74, ["Neon"] = 31.5, ["Neon|Ride"] = 61.57, ["Neon|Fly|Ride"] = 178.52, ["Mega"] = 156.19, ["Mega|Ride"] = 202.77, ["Mega|Fly|Ride"] = 377.22}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 4.87, ["Fly"] = 52.5, ["Ride"] = 52.5, ["Fly|Ride"] = 118.13, ["Neon"] = 24.73, ["Neon|Ride"] = 64.64, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 203.43, ["Mega|Ride"] = 191.63, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 34.11, ["Ride"] = 18.2, ["Fly|Ride"] = 52.5, ["Neon"] = 14.99, ["Neon|Fly"] = 41.01, ["Neon|Ride"] = 28.49, ["Neon|Fly|Ride"] = 68.75, ["Mega"] = 273.73, ["Mega|Fly"] = 547.43, ["Mega|Ride"] = 195.57, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 22.32, ["Ride"] = 46.11, ["Fly|Ride"] = 154.43, ["Neon"] = 92.21, ["Neon|Fly"] = 170.63, ["Neon|Ride"] = 137.48, ["Mega"] = 547.43, ["Mega|Fly|Ride"] = 738.09}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Fly|Ride"] = 409.86, ["Neon"] = 5.04, ["Neon|Fly"] = 68.66, ["Neon|Ride"] = 39.15, ["Neon|Fly|Ride"] = 183.65, ["Mega"] = 46.77, ["Mega|Ride"] = 116.62, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 528.5, ["Ride"] = 558.89, ["Fly|Ride"] = 695.72, ["Neon"] = 2589.57, ["Neon|Fly|Ride"] = 2343.78, ["Mega|Fly|Ride"] = 7861.88}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 61.66, ["Fly|Ride"] = 307.67, ["Neon"] = 15.37, ["Neon|Ride"] = 90.29, ["Neon|Fly|Ride"] = 498.75, ["Mega"] = 80.07, ["Mega|Ride"] = 167.26, ["Mega|Fly|Ride"] = 276.94}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 41.13, ["Neon"] = 6.17, ["Neon|Fly"] = 137.31, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 45.94, ["Mega|Ride"] = 137.38, ["Mega|Fly|Ride"] = 266.54}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 25.2, ["Neon"] = 5.25, ["Neon|Ride"] = 41.31, ["Neon|Fly|Ride"] = 137.48, ["Mega"] = 52.63, ["Mega|Fly"] = 151.73, ["Mega|Ride"] = 80.07, ["Mega|Fly|Ride"] = 147}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 3.03, ["Ride"] = 21.84, ["Neon"] = 18.46, ["Mega"] = 200.59}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 31.5, ["Fly"] = 66.94, ["Ride"] = 57.85, ["Fly|Ride"] = 294.62, ["Neon"] = 128.64, ["Neon|Ride"] = 184.67, ["Neon|Fly|Ride"] = 273.93, ["Mega"] = 615.08, ["Mega|Ride"] = 548.63, ["Mega|Fly|Ride"] = 683.76}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 17.42, ["Ride"] = 55.31, ["Fly|Ride"] = 137.31, ["Neon"] = 78.37, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 301.77, ["Mega"] = 464.2, ["Mega|Ride"] = 385.9, ["Mega|Fly|Ride"] = 626.36}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 3.73, ["Fly"] = 19.16, ["Ride"] = 13.42, ["Fly|Ride"] = 43.26, ["Neon"] = 19.69, ["Neon|Ride"] = 32.48, ["Neon|Fly|Ride"] = 74.44, ["Mega"] = 299.92, ["Mega|Ride"] = 136.54, ["Mega|Fly|Ride"] = 217.33}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 8.6, ["Ride"] = 64.32, ["Fly|Ride"] = 123.31, ["Neon"] = 137.31, ["Neon|Ride"] = 131.25, ["Mega"] = 307.79, ["Mega|Ride"] = 712.47, ["Mega|Fly|Ride"] = 957.47}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 25.45, ["Fly|Ride"] = 72.76, ["Neon"] = 14.31, ["Neon|Ride"] = 33.47, ["Neon|Fly|Ride"] = 547.84, ["Mega"] = 86.63, ["Mega|Ride"] = 152.25, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 13.02, ["Fly"] = 23.15, ["Ride"] = 23.62, ["Fly|Ride"] = 68.66, ["Neon"] = 228.74, ["Neon|Ride"] = 184.67, ["Neon|Fly|Ride"] = 197.3, ["Mega"] = 921.59, ["Mega|Ride"] = 922.18, ["Mega|Fly|Ride"] = 876.48}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 55.5, ["Fly"] = 874.13, ["Neon"] = 273.58, ["Mega|Fly|Ride"] = 957.47}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 45.05, ["Fly"] = 115.38, ["Ride"] = 70.59, ["Fly|Ride"] = 121.19, ["Neon"] = 259.88, ["Neon|Ride"] = 275.63, ["Neon|Fly|Ride"] = 361.23, ["Mega|Ride"] = 1629.94, ["Mega|Fly|Ride"] = 1499.75}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 41.99, ["Fly"] = 291.38, ["Ride"] = 88.41, ["Fly|Ride"] = 656.25, ["Neon"] = 129.94, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 388.82, ["Mega"] = 543.56, ["Mega|Ride"] = 656.1, ["Mega|Fly|Ride"] = 620.82}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 17.98, ["Ride"] = 55.35, ["Fly|Ride"] = 137.31, ["Neon"] = 78.75, ["Neon|Ride"] = 274.26, ["Mega"] = 410.06, ["Mega|Ride"] = 752.46, ["Mega|Fly|Ride"] = 1230.15}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 18.08, ["Fly"] = 428.28, ["Ride"] = 46.1, ["Fly|Ride"] = 131.25, ["Neon"] = 86.16, ["Neon|Fly"] = 420, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 231.55, ["Mega"] = 457.47, ["Mega|Ride"] = 353.9, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 17.74, ["Ride"] = 15.25, ["Fly|Ride"] = 34.85, ["Neon"] = 5.25, ["Neon|Fly"] = 25.15, ["Neon|Ride"] = 27.35, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 44.61, ["Mega|Fly"] = 154.47, ["Mega|Ride"] = 57.74, ["Mega|Fly|Ride"] = 202.79}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1253.91}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 52.41, ["Fly"] = 231.34, ["Ride"] = 127.32, ["Fly|Ride"] = 262.5, ["Neon"] = 288.46, ["Neon|Ride"] = 258.68, ["Neon|Fly|Ride"] = 328.3, ["Mega"] = 786.28, ["Mega|Ride"] = 752.46, ["Mega|Fly|Ride"] = 851.07}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 55.54, ["Neon"] = 3.18, ["Neon|Fly"] = 96.33, ["Neon|Ride"] = 43.18, ["Neon|Fly|Ride"] = 287.26, ["Mega"] = 29.79, ["Mega|Ride"] = 79.97, ["Mega|Fly|Ride"] = 151.73}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 31.98, ["Ride"] = 64.79, ["Neon"] = 128.37, ["Neon|Ride"] = 137.48, ["Neon|Fly|Ride"] = 544.69, ["Mega|Ride"] = 803.7, ["Mega|Fly|Ride"] = 799.99}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 3.82, ["Mega"] = 35.04}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 39.38, ["Mega"] = 77.24, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 97.35, ["Ride"] = 129.47, ["Fly|Ride"] = 670.1, ["Neon"] = 428.7, ["Neon|Ride"] = 514.5, ["Neon|Fly|Ride"] = 684.28, ["Mega|Ride"] = 6339.88, ["Mega|Fly|Ride"] = 3844.28}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 65.62, ["Ride"] = 19.69, ["Fly|Ride"] = 92.69, ["Neon"] = 8.23, ["Neon|Ride"] = 26.16, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 90.57, ["Mega|Ride"] = 107.62, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 39.34, ["Ride"] = 68.66, ["Fly|Ride"] = 52.49, ["Neon"] = 3.94, ["Neon|Fly"] = 61.49, ["Neon|Ride"] = 34.9, ["Neon|Fly|Ride"] = 122.1, ["Mega"] = 39.99, ["Mega|Ride"] = 123.27, ["Mega|Fly|Ride"] = 220.5}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 81.99, ["Neon"] = 2.1, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 47.59, ["Mega"] = 36.29, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 223.5}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 27.57, ["Neon"] = 5.09, ["Neon|Ride"] = 137.62, ["Mega"] = 58.97, ["Mega|Ride"] = 200.71}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 63.95, ["Ride"] = 116.94, ["Fly|Ride"] = 449.61, ["Neon"] = 415.63, ["Neon|Ride"] = 507.83, ["Neon|Fly|Ride"] = 684.28, ["Mega"] = 1230.15, ["Mega|Ride"] = 1537.69, ["Mega|Fly|Ride"] = 1365.47}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 6.56, ["Ride"] = 59.91, ["Fly|Ride"] = 131.25, ["Neon"] = 46.87, ["Neon|Ride"] = 153.25, ["Mega"] = 375.85, ["Mega|Ride"] = 847.23}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 325.49, ["Ride"] = 315, ["Fly|Ride"] = 614.77, ["Neon"] = 2868.9, ["Neon|Ride"] = 2051.77, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 3854.44}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 85.32}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 47.19}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 23.47}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 35.6}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 115.96}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 57.44}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 20.9}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 5.24}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 196.87}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 41.13}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 31.73}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 6.4}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 4.81}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 205.09}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 4.99}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 5.25}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 8.67}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 6.5}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 9.19}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 518.44}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 787.5}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 14.33}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1038.98}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 36.2}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 7.88}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 18.89}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 31.18}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 22.32}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 49.65}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 18.57}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 9.85}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 14.23}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 3.94}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 17.25}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 3.97}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 15.09}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 6.57}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 4.45}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 1864.7}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 44.94}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 331.83}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.37}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 9.1}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 6.24}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 39.26}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 203.6}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 6.13}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 7.88}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 1371.61}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 26.23}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 3.61}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 18.09}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 8.71}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 5.24}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 215.71}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 26.15}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 7.45}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 27.86}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 7.43}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 6.19}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 26.25}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 93.26}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 183.75}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 3.53}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 13.9}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 28.88}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 26.17}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 87.94}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 16.95}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22028.96}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 164.07}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 39.38}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 134.42}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 49.38}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 26.25}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 92.55}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 36.66}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 75.51}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 66.85}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 55.54}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 32.81}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 76.21}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 38.07}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 53.75}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 411.59}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 6.12}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 10.29}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 11.67}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 6.36}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 28.58}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 89.07}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.1}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 3.14}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 6.57}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 10.4}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 636.76}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 8.26}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 577.4}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 24.86}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.63}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 601.39}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 39.38}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 68.81}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 27.78}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 52.5}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 138.21}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 18.52}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 3.82}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 15.44}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.1}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 4.97}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 2.37}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 24.93}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 2.1}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 3.28}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 3.05}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 15.54}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 187.28}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 70.35}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.1}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 1048.69}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 4.76}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 15.65}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 7.3}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 20.79}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 90.57}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 5.07}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 6.46}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 12.16}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 20.6}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 80.07}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 19.48}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 11.05}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 4.13}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 4.55}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 6.86}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 4.76}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 3.81}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.37}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 3.39}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.63}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 6.65}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 6554.05}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.5}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 11.34}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 3.83}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 10.36}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 5.65}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 26.24}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 3.94}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 7.88}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 5.22}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 9.19}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 108.99}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 12.39}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 3.94}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 3.68}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 3.67}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 99.64}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 6.39}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.12}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4279.05}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 5.16}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 38.74}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 5.71}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 8.07}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 51.01}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 3.93}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 2.4}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 91.88}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.63}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 2.14}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 3.68}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.1}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 2.63}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 7.35}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 18.38}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 3.67}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.53}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.26}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 10.4}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 3.14}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 5.03}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 5.51}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 11.32}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.37}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 22.57}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.62}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 8.94}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 90.46}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.49}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 42}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 3.94}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 3.94}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1040.82}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 15.74}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 4.73}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 13.48}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 68.91}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 5.25}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 5.25}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 14.98}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 3.94}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 14.44}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 14.44}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.63}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.21}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 2.1}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 15.75}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 3.73}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.62}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 23.46}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 3.94}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 9.18}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 37.26}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.63}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 8.43}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 17.57}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 49.26}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 18.16}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 4.86}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 3.42}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 51.18}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 28.67}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.63}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 5.98}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 2.12}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 7.18}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 6.18}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 7.09}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 314.9}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 144.37}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1199.63}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 3.33}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 213.82}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 13.13}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 59.07}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.5}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 2.37}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 7.88}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 32.81}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 11.34}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 8.79}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 3}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 3.29}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 68.98}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 52.49}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 3.59}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 63}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 5.25}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 3.71}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.63}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 28.88}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.52}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 26.17}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 129.05}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 3.77}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 75.11}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 135.95}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 47.17}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 91.88}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 224.34}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 2.5}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 74.66}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 7.12}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 135.54}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.91}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 26.69}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 55.55}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 3.93}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 42.75}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 6.17}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 7.77}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 28.67}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 28.88}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 36.37}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 8.13}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 36.74}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 16.7}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 94.61}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 3.93}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 28.88}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 3.83}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 9.18}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 33.6}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 52.49}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 20.74}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1782.38}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 8.71}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 7.04}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 30.18}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 374.28}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 23.62}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 10.37}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 44.23}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 3.94}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 7.77}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 259.77}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 32.61}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 45.05}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.92}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 60.38}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 125.48}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 58.79}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 1050}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 118.13}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 6.29}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 2159.2}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 524.99}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 3.94}},
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