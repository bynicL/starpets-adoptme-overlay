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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 823.39, ["Ride"] = 1049.99, ["Fly|Ride"] = 1232.76, ["Neon|Fly|Ride"] = 4200, ["Mega|Fly|Ride"] = 20032.14}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 513.19, ["Ride"] = 562.02, ["Fly|Ride"] = 616.48, ["Neon|Fly|Ride"] = 2415.16, ["Mega"] = 11623.23, ["Mega|Fly|Ride"] = 6780.11}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 4672.5, ["Ride"] = 5117.44, ["Fly|Ride"] = 4689.57, ["Neon|Fly|Ride"] = 20945.1, ["Mega|Fly|Ride"] = 68486.22}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 171.14, ["Ride"] = 201.06, ["Fly|Ride"] = 275.63, ["Neon"] = 890.68, ["Neon|Ride"] = 821.85, ["Neon|Fly|Ride"] = 821.85, ["Mega"] = 4109.17, ["Mega|Fly|Ride"] = 3937.49}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 632.62, ["Fly"] = 821.94, ["Ride"] = 555.19, ["Fly|Ride"] = 580.84, ["Neon|Fly|Ride"] = 1719.19, ["Mega|Fly|Ride"] = 6529.46}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 9.75, ["Ride"] = 29.25, ["Fly|Ride"] = 155.76, ["Neon"] = 39.37, ["Neon|Ride"] = 120.74, ["Neon|Fly|Ride"] = 404.25, ["Mega"] = 324.84, ["Mega|Ride"] = 262.49, ["Mega|Fly|Ride"] = 303.07}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 3.84, ["Fly"] = 31.5, ["Ride"] = 23.42, ["Fly|Ride"] = 68.11, ["Neon"] = 24.75, ["Neon|Fly"] = 77.89, ["Neon|Ride"] = 50.95, ["Neon|Fly|Ride"] = 108.59, ["Mega|Ride"] = 213.94, ["Mega|Fly|Ride"] = 276.24}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 104.99, ["Fly"] = 205.5, ["Ride"] = 152.27, ["Fly|Ride"] = 240.19, ["Neon"] = 459.38, ["Neon|Ride"] = 493.5, ["Neon|Fly|Ride"] = 685.21, ["Mega|Ride"] = 1781.34, ["Mega|Fly|Ride"] = 2682.26}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 31.17, ["Fly"] = 105, ["Ride"] = 48.56, ["Fly|Ride"] = 124.4, ["Neon"] = 287.66, ["Neon|Ride"] = 200.7, ["Neon|Fly|Ride"] = 334.69, ["Mega"] = 2100, ["Mega|Fly|Ride"] = 1232.76}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 22.87, ["Fly"] = 69.47, ["Ride"] = 31.29, ["Fly|Ride"] = 66.85, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 310.36, ["Mega|Fly|Ride"] = 1019.82}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 57.07, ["Fly"] = 140.34, ["Ride"] = 88.39, ["Fly|Ride"] = 169.33, ["Neon"] = 434.73, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 438.38, ["Mega|Fly|Ride"] = 1228.65}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 60.6}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 301.88, ["Fly"] = 399, ["Ride"] = 306.09, ["Fly|Ride"] = 353.98, ["Neon|Ride"] = 1023.75, ["Neon|Fly|Ride"] = 1049.99, ["Mega|Fly|Ride"] = 4860.11}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 124.68, ["Fly"] = 179.64, ["Ride"] = 114.48, ["Fly|Ride"] = 137.69, ["Neon|Fly"] = 674.16, ["Neon|Ride"] = 581.18, ["Neon|Fly|Ride"] = 682.14, ["Mega|Fly|Ride"] = 2983.7}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.55, ["Ride"] = 55.04, ["Fly|Ride"] = 131.24, ["Neon"] = 20.26, ["Neon|Fly"] = 96.58, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 129.94, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 310.25, ["Mega|Fly|Ride"] = 303.11}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 189.94, ["Fly"] = 204.45, ["Ride"] = 189.95, ["Fly|Ride"] = 208.06, ["Neon"] = 775.28, ["Neon|Fly|Ride"] = 616.88, ["Mega"] = 3561.63, ["Mega|Fly|Ride"] = 2730}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 2.61, ["Fly"] = 32.92, ["Ride"] = 18.27, ["Fly|Ride"] = 41.58, ["Neon"] = 24.08, ["Neon|Ride"] = 60.38, ["Neon|Fly|Ride"] = 108.96, ["Mega"] = 205.48, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 410.93}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 96.96, ["Fly"] = 466.39, ["Ride"] = 111.57, ["Fly|Ride"] = 197.86, ["Neon"] = 328.75, ["Neon|Fly"] = 464.94, ["Neon|Ride"] = 410.84, ["Neon|Fly|Ride"] = 523.69, ["Mega"] = 1703.79, ["Mega|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 1207.5}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 37.76}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 50.97, ["Ride"] = 100.07, ["Fly|Ride"] = 171.57, ["Neon"] = 577.5, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 1370.41}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 14.17, ["Fly"] = 393.75, ["Ride"] = 31.82, ["Fly|Ride"] = 369.85, ["Neon"] = 159.17, ["Neon|Ride"] = 209.99, ["Neon|Fly|Ride"] = 367.5, ["Mega|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 1643.67}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 41.19, ["Fly"] = 157.49, ["Ride"] = 49.56, ["Fly|Ride"] = 88.38, ["Neon"] = 671.86, ["Neon|Ride"] = 309.74, ["Neon|Fly|Ride"] = 275.31, ["Mega"] = 1627.27, ["Mega|Ride"] = 1370.41, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 43.32, ["Fly"] = 65.63, ["Ride"] = 157.5, ["Fly|Ride"] = 137.68, ["Neon"] = 210, ["Neon|Ride"] = 356.04, ["Neon|Fly|Ride"] = 410.93, ["Mega"] = 2047.5, ["Mega|Ride"] = 1093.05, ["Mega|Fly|Ride"] = 1255.36}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 20.79, ["Ride"] = 44.63, ["Fly|Ride"] = 84, ["Neon"] = 120.75, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 292.92, ["Mega"] = 819.79, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 959.51}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 37.74, ["Fly"] = 136.75, ["Ride"] = 57.72, ["Fly|Ride"] = 123.31, ["Neon"] = 157.5, ["Neon|Ride"] = 262.49, ["Neon|Fly|Ride"] = 322.88, ["Mega|Ride"] = 1124.82, ["Mega|Fly|Ride"] = 943.69}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 3.67, ["Fly"] = 24.15, ["Ride"] = 19.69, ["Fly|Ride"] = 48.2, ["Neon"] = 36.74, ["Neon|Fly"] = 101.04, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 90.86, ["Mega"] = 145.39, ["Mega|Fly"] = 301.88, ["Mega|Ride"] = 182.42, ["Mega|Fly|Ride"] = 267.75}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 292.32, ["Ride"] = 479.82, ["Fly|Ride"] = 478.46, ["Neon|Ride"] = 1781.34, ["Neon|Fly|Ride"] = 1964.82, ["Mega|Fly|Ride"] = 6848.94}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 12.5, ["Ride"] = 32.22, ["Fly|Ride"] = 106.25, ["Neon"] = 204.27, ["Neon|Fly|Ride"] = 274.31, ["Mega|Fly|Ride"] = 671.66}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 6.12, ["Fly"] = 26.25, ["Ride"] = 19.29, ["Fly|Ride"] = 42, ["Neon"] = 72.28, ["Neon|Ride"] = 58.9, ["Neon|Fly|Ride"] = 119.24, ["Mega"] = 410.93, ["Mega|Ride"] = 446.25}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 75.51, ["Fly"] = 102.38, ["Ride"] = 94.33, ["Fly|Ride"] = 113.17, ["Neon"] = 410.93, ["Neon|Fly"] = 376.72, ["Neon|Ride"] = 385.75, ["Neon|Fly|Ride"] = 433.13, ["Mega"] = 3698.25, ["Mega|Ride"] = 7874.99, ["Mega|Fly|Ride"] = 2077.09}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 14.41, ["Ride"] = 27.76, ["Fly|Ride"] = 118.13, ["Neon"] = 96.58, ["Neon|Ride"] = 96.58, ["Neon|Fly|Ride"] = 192.12, ["Mega"] = 548.59, ["Mega|Ride"] = 780.75, ["Mega|Fly|Ride"] = 548.59}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 206.05, ["Fly"] = 347.28, ["Ride"] = 236.25, ["Fly|Ride"] = 292.46, ["Neon"] = 656.25, ["Neon|Ride"] = 825.57, ["Neon|Fly|Ride"] = 997.5, ["Mega"] = 6163.75, ["Mega|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 3012.02}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 23.63}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 4.19, ["Fly"] = 31.39, ["Ride"] = 17.56, ["Fly|Ride"] = 66.28, ["Neon"] = 14.44, ["Neon|Fly"] = 5136.45, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 140.7, ["Mega"] = 126.96, ["Mega|Fly"] = 211.54, ["Mega|Ride"] = 182.44, ["Mega|Fly|Ride"] = 647.07}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 746.28, ["Fly"] = 2625, ["Ride"] = 868.44, ["Fly|Ride"] = 1054.99, ["Neon"] = 3890.36, ["Neon|Ride"] = 6027.11, ["Neon|Fly|Ride"] = 4068.75, ["Mega|Ride"] = 52304.53, ["Mega|Fly|Ride"] = 17083.5}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 12.34, ["Fly"] = 68.85, ["Ride"] = 20.23, ["Fly|Ride"] = 91.49, ["Neon"] = 137.68, ["Neon|Ride"] = 116.24, ["Neon|Fly|Ride"] = 227.05, ["Mega"] = 787.5, ["Mega|Ride"] = 959.51, ["Mega|Fly|Ride"] = 820.31}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 196.88, ["Ride"] = 193.39, ["Fly|Ride"] = 301.88, ["Neon"] = 1781.34, ["Neon|Ride"] = 810.06, ["Neon|Fly|Ride"] = 958.13, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 3150}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 44.35}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 15.39, ["Fly"] = 127.73, ["Ride"] = 52.41, ["Fly|Ride"] = 137.69, ["Neon"] = 104.89, ["Neon|Ride"] = 206.07, ["Neon|Fly|Ride"] = 274.31, ["Mega"] = 684.53, ["Mega|Ride"] = 1083.8, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.63}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 124.61, ["Ride"] = 136.14, ["Neon|Ride"] = 446.92, ["Neon|Fly|Ride"] = 620.7, ["Mega|Fly|Ride"] = 2723.17}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 132.5, ["Fly"] = 157.49, ["Ride"] = 150.19, ["Fly|Ride"] = 274.31, ["Neon"] = 315, ["Neon|Ride"] = 410.93, ["Neon|Fly|Ride"] = 523.69, ["Mega|Fly|Ride"] = 1211.78}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 29.89}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 65.62, ["Fly"] = 60.12, ["Ride"] = 58.8, ["Fly|Ride"] = 108.92, ["Neon|Ride"] = 409.9, ["Neon|Fly|Ride"] = 380.93, ["Mega"] = 4109.17, ["Mega|Fly|Ride"] = 1859.73}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 6.43, ["Ride"] = 55.5, ["Fly|Ride"] = 157.49, ["Neon"] = 137.68, ["Neon|Ride"] = 125.63, ["Neon|Fly|Ride"] = 231.16, ["Mega"] = 237.32, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 323.6, ["Mega|Fly|Ride"] = 410.93}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 437.33, ["Fly"] = 590.63, ["Ride"] = 411.5, ["Fly|Ride"] = 509.15, ["Neon|Ride"] = 1798.13, ["Neon|Fly|Ride"] = 1647.54, ["Mega|Fly|Ride"] = 7067.76}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 91.87, ["Fly"] = 150.02, ["Ride"] = 117.8, ["Fly|Ride"] = 174.41, ["Neon"] = 459.38, ["Neon|Ride"] = 754.04, ["Neon|Fly|Ride"] = 420, ["Mega|Ride"] = 2464.48, ["Mega|Fly|Ride"] = 2328.88}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3281.25, ["Ride"] = 3596.25, ["Fly|Ride"] = 3674.99}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 38.98, ["Fly"] = 111.57, ["Ride"] = 51.1, ["Fly|Ride"] = 128.43, ["Neon|Ride"] = 302.23, ["Neon|Fly|Ride"] = 616.39, ["Mega"] = 1314.94, ["Mega|Ride"] = 1753.6, ["Mega|Fly|Ride"] = 1226.6}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 63, ["Ride"] = 99.75, ["Fly|Ride"] = 111.57, ["Neon"] = 575.75, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 525, ["Mega"] = 6163.75, ["Mega|Ride"] = 2603.16, ["Mega|Fly|Ride"] = 3287.82}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 30.38, ["Fly"] = 55.13, ["Ride"] = 43.97, ["Fly|Ride"] = 78.72, ["Neon"] = 131.25, ["Neon|Ride"] = 137.38, ["Neon|Fly|Ride"] = 196.19, ["Mega"] = 2625, ["Mega|Ride"] = 548.59, ["Mega|Fly|Ride"] = 656.04}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 8.24}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 78.66, ["Ride"] = 74, ["Fly|Ride"] = 65.63, ["Neon|Ride"] = 525, ["Mega|Fly|Ride"] = 1859.73}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 39.14}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 155.47, ["Ride"] = 236.25, ["Fly|Ride"] = 301.88, ["Neon|Ride"] = 1068.39}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 984.37, ["Ride"] = 943.69, ["Fly|Ride"] = 1038.51, ["Neon"] = 2887.5, ["Neon|Ride"] = 3014.07, ["Neon|Fly|Ride"] = 3141.39, ["Mega|Fly|Ride"] = 11358.25}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 5.97}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 22.91, ["Fly"] = 30.19, ["Ride"] = 43.21, ["Fly|Ride"] = 64.32, ["Neon"] = 164.07, ["Neon|Ride"] = 134.48, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 892.5, ["Mega|Fly|Ride"] = 895.33}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 15.37}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 6302.18, ["Ride"] = 6472.74, ["Fly|Ride"] = 5053.01, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 40604.59}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 11.46, ["Fly"] = 52.41, ["Ride"] = 24.28, ["Fly|Ride"] = 52.5, ["Neon"] = 95.81, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 219.18, ["Mega"] = 693, ["Mega|Ride"] = 1507.04, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 14.44, ["Fly"] = 139.89, ["Ride"] = 32.89, ["Fly|Ride"] = 310.4, ["Neon"] = 71.91, ["Neon|Ride"] = 122.07, ["Neon|Fly|Ride"] = 192.12, ["Mega"] = 727.13, ["Mega|Ride"] = 651.45, ["Mega|Fly|Ride"] = 1024.23}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 70.87, ["Fly"] = 52.5, ["Ride"] = 68.85, ["Fly|Ride"] = 131.25, ["Neon|Ride"] = 381.14, ["Neon|Fly|Ride"] = 476.14, ["Mega"] = 4109.17}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 11.46, ["Fly"] = 150.93, ["Ride"] = 25.67, ["Fly|Ride"] = 78.75, ["Neon"] = 68.85, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 501.38, ["Mega|Ride"] = 343.13, ["Mega|Fly|Ride"] = 813.75}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1706.22, ["Fly"] = 2274.71, ["Ride"] = 1689.19, ["Fly|Ride"] = 1771.77, ["Neon|Ride"] = 4273.54, ["Neon|Fly|Ride"] = 3542.34, ["Mega|Fly|Ride"] = 12468.75}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 26248.69, ["Fly"] = 32877.32, ["Ride"] = 30139.26, ["Fly|Ride"] = 25084.89, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 71225.99, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 183750}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 16.33, ["Fly"] = 393.74, ["Ride"] = 45.94, ["Fly|Ride"] = 124.4, ["Neon"] = 274.31, ["Neon|Ride"] = 274.31, ["Neon|Fly|Ride"] = 410.93, ["Mega"] = 1080.72, ["Mega|Ride"] = 1141.88, ["Mega|Fly|Ride"] = 817.74}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 2.5, ["Fly"] = 72.15, ["Ride"] = 31.68, ["Fly|Ride"] = 105, ["Neon"] = 19.68, ["Neon|Fly"] = 155.76, ["Neon|Ride"] = 55.5, ["Neon|Fly|Ride"] = 118.15, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 449.97}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 15.33}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 6.07, ["Ride"] = 36.74, ["Fly|Ride"] = 131.25, ["Neon"] = 59.07, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 497.48, ["Mega"] = 293.53, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 548.59}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 764.49, ["Ride"] = 757.32, ["Fly|Ride"] = 788.05, ["Neon|Fly|Ride"] = 2393.18, ["Mega|Fly|Ride"] = 8662.5}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 918.75, ["Fly"] = 918.75, ["Ride"] = 851.5, ["Fly|Ride"] = 983.07, ["Neon|Ride"] = 3182.55, ["Neon|Fly|Ride"] = 3109.21, ["Mega|Fly|Ride"] = 10551.19}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 12.5, ["Fly"] = 116.27, ["Ride"] = 34.91, ["Fly|Ride"] = 52.5, ["Neon"] = 72.19, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 273.28, ["Mega"] = 1204.13, ["Mega|Ride"] = 685.21, ["Mega|Fly|Ride"] = 1096.13}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 22.23}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 59.75, ["Fly"] = 96.59, ["Ride"] = 77.24, ["Fly|Ride"] = 123.31, ["Neon"] = 462.3, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 455.34, ["Mega|Ride"] = 2011.45, ["Mega|Fly|Ride"] = 1664.25}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 90.43, ["Ride"] = 118.13, ["Fly|Ride"] = 228.38, ["Neon"] = 450.19, ["Neon|Ride"] = 308.25, ["Neon|Fly|Ride"] = 476.68, ["Mega"] = 1336.91, ["Mega|Ride"] = 1919, ["Mega|Fly|Ride"] = 1859.73}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 3.12, ["Fly"] = 35.43, ["Ride"] = 19.09, ["Fly|Ride"] = 48.86, ["Neon"] = 41.58, ["Neon|Fly"] = 524.98, ["Neon|Ride"] = 55.13, ["Neon|Fly|Ride"] = 217.38, ["Mega"] = 315.39, ["Mega|Ride"] = 308.2, ["Mega|Fly|Ride"] = 685.21}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 135.19, ["Fly"] = 158.82, ["Ride"] = 137.45, ["Fly|Ride"] = 196.88, ["Neon"] = 498.75, ["Neon|Ride"] = 518.43, ["Neon|Fly|Ride"] = 519.65, ["Mega|Fly|Ride"] = 1787.91}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 4.96, ["Ride"] = 39.66, ["Fly|Ride"] = 123.31, ["Neon"] = 47.25, ["Neon|Ride"] = 85.32, ["Mega|Ride"] = 474.62}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 15.65, ["Fly"] = 41.43, ["Ride"] = 30.38, ["Fly|Ride"] = 76.05, ["Neon"] = 90.72, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 195.2, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 20.48, ["Ride"] = 55.5, ["Fly|Ride"] = 156.19, ["Neon"] = 244.51, ["Neon|Ride"] = 274.31, ["Mega"] = 918.74, ["Mega|Ride"] = 1161.57, ["Mega|Fly|Ride"] = 1114.31}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 12.54, ["Fly"] = 178.76, ["Ride"] = 26.25, ["Fly|Ride"] = 67.38, ["Neon"] = 91.87, ["Neon|Ride"] = 114.59, ["Neon|Fly|Ride"] = 204.45, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 7149.19, ["Ride"] = 6555.94, ["Fly|Ride"] = 5491.5, ["Neon"] = 34243.63, ["Neon|Ride"] = 23625, ["Neon|Fly|Ride"] = 24381.67, ["Mega|Fly|Ride"] = 92985.82}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 224.41, ["Fly"] = 315, ["Ride"] = 250.68, ["Fly|Ride"] = 249.38, ["Neon|Ride"] = 697.41, ["Neon|Fly|Ride"] = 566.19, ["Mega|Fly|Ride"] = 2054.59}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 43.2, ["Fly"] = 120.57, ["Ride"] = 78.66, ["Fly|Ride"] = 162.6, ["Neon"] = 137.32, ["Neon|Fly"] = 242.03, ["Neon|Ride"] = 157.4, ["Neon|Fly|Ride"] = 261.59, ["Mega"] = 393.75, ["Mega|Ride"] = 401.12, ["Mega|Fly|Ride"] = 500.06}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.05, ["Fly"] = 86.04, ["Ride"] = 32.89, ["Fly|Ride"] = 52.5, ["Neon"] = 20.84, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 186.98, ["Mega"] = 341.25, ["Mega|Ride"] = 187.69}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 50.65, ["Fly"] = 5269.48, ["Ride"] = 89.06, ["Fly|Ride"] = 197.64, ["Neon"] = 184.41, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 316.68, ["Mega"] = 488.06, ["Mega|Ride"] = 548.59, ["Mega|Fly|Ride"] = 605.94}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 16485, ["Ride"] = 12009.38, ["Fly|Ride"] = 11681.15, ["Neon|Fly|Ride"] = 22837.5}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 236.25, ["Ride"] = 301.71, ["Fly|Ride"] = 381.19, ["Neon"] = 1515.69, ["Neon|Ride"] = 1370.41, ["Neon|Fly|Ride"] = 1164.96, ["Mega"] = 6163.75, ["Mega|Fly|Ride"] = 5883.29}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 70.21, ["Fly"] = 78.77, ["Ride"] = 69.57, ["Fly|Ride"] = 117.05, ["Neon"] = 390.38, ["Neon|Ride"] = 281.31, ["Neon|Fly|Ride"] = 320.25, ["Mega|Fly|Ride"] = 3426.03}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 8.38, ["Fly"] = 27.39, ["Ride"] = 20.56, ["Fly|Ride"] = 72.12, ["Neon"] = 67.46, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 360.94, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 379.33, ["Ride"] = 418.68, ["Fly|Ride"] = 485, ["Neon"] = 1643.67, ["Neon|Ride"] = 1565.61, ["Neon|Fly|Ride"] = 1575, ["Mega|Fly|Ride"] = 4331.25}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 6.02, ["Fly"] = 35.09, ["Ride"] = 37.7, ["Fly|Ride"] = 104.9, ["Neon"] = 25.91, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 178.77, ["Mega|Fly"] = 278.37, ["Mega|Ride"] = 210.08, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 100.32, ["Fly"] = 211.59, ["Ride"] = 144.38, ["Fly|Ride"] = 177.69, ["Neon"] = 485.63, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 557.82, ["Mega|Fly|Ride"] = 2624.99}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 10.5, ["Fly"] = 18.15, ["Ride"] = 18.38, ["Fly|Ride"] = 31.44, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 2465.51}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 6.86}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 45.47, ["Ride"] = 80.68, ["Fly|Ride"] = 410.99, ["Neon"] = 421.32, ["Neon|Ride"] = 524.99, ["Neon|Fly|Ride"] = 3081.88, ["Mega|Ride"] = 1232.76, ["Mega|Fly|Ride"] = 1514.92}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 14.44, ["Fly"] = 101.73, ["Ride"] = 31.5, ["Fly|Ride"] = 92.26, ["Neon"] = 98.44, ["Neon|Ride"] = 160.41, ["Neon|Fly|Ride"] = 238.9, ["Mega|Fly|Ride"] = 803.36}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 26.25}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 49.01, ["Fly"] = 210, ["Ride"] = 91.88, ["Fly|Ride"] = 249.38, ["Neon"] = 217.38, ["Neon|Ride"] = 333.61, ["Neon|Fly|Ride"] = 512.63, ["Mega"] = 1540.95, ["Mega|Ride"] = 1503.96, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 4.7, ["Ride"] = 29.24, ["Neon"] = 20.98, ["Neon|Ride"] = 101.14, ["Neon|Fly|Ride"] = 274.31, ["Mega|Ride"] = 263.86, ["Mega|Fly|Ride"] = 358.98}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 10.48, ["Fly"] = 52.5, ["Ride"] = 27.57, ["Fly|Ride"] = 77.9, ["Neon|Ride"] = 164.07, ["Neon|Fly|Ride"] = 205.48, ["Mega|Ride"] = 624.6, ["Mega|Fly|Ride"] = 590.28}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 438.38, ["Ride"] = 480.77, ["Fly|Ride"] = 385.88, ["Neon|Fly|Ride"] = 2739.79, ["Mega|Fly|Ride"] = 12398.51}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 32.62, ["Ride"] = 54.02, ["Fly|Ride"] = 105, ["Neon"] = 234.99, ["Neon|Ride"] = 259.88, ["Neon|Fly|Ride"] = 315.39, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 1370.41}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 40.07, ["Fly"] = 119.89, ["Ride"] = 66.27, ["Fly|Ride"] = 202.29, ["Neon"] = 274.31, ["Neon|Ride"] = 410.93, ["Neon|Fly|Ride"] = 435.59, ["Mega|Fly|Ride"] = 919.44}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 19.69, ["Fly"] = 77.35, ["Ride"] = 62.88, ["Fly|Ride"] = 117.11, ["Neon"] = 92.54, ["Neon|Fly"] = 257.86, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 418.69, ["Mega"] = 410.93, ["Mega|Ride"] = 410.93, ["Mega|Fly|Ride"] = 597.9}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Ride"] = 13330.03, ["Fly|Ride"] = 8137.5, ["Neon|Fly|Ride"] = 16929.94, ["Mega|Fly|Ride"] = 38850}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1557.94, ["Fly"] = 1663.82, ["Ride"] = 1433.91, ["Fly|Ride"] = 1494.77, ["Neon|Fly|Ride"] = 3995.92, ["Mega|Fly|Ride"] = 14437.5}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 651.39, ["Ride"] = 560.39, ["Fly|Ride"] = 614.64, ["Neon"] = 2552.44, ["Neon|Fly|Ride"] = 2328.88, ["Mega|Fly|Ride"] = 6848.94}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 10.39, ["Fly"] = 20.69, ["Ride"] = 17.2, ["Fly|Ride"] = 52.4, ["Neon"] = 101.07, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 154.71, ["Mega|Fly|Ride"] = 548.59}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 3.78, ["Fly"] = 78.74, ["Ride"] = 28.82, ["Neon"] = 24.94, ["Neon|Ride"] = 55.04, ["Mega"] = 145.72, ["Mega|Ride"] = 172.05, ["Mega|Fly|Ride"] = 257.27}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 35.89, ["Fly"] = 76.13, ["Ride"] = 45.07, ["Fly|Ride"] = 95.71, ["Neon"] = 267.1, ["Neon|Ride"] = 164.07, ["Neon|Fly|Ride"] = 183.75, ["Mega|Fly|Ride"] = 553.25}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 2.63, ["Fly"] = 27.01, ["Ride"] = 16.57, ["Fly|Ride"] = 33.54, ["Neon"] = 31.48, ["Neon|Fly"] = 76.92, ["Neon|Ride"] = 43.64, ["Neon|Fly|Ride"] = 91.77, ["Mega"] = 184.93, ["Mega|Ride"] = 263.86}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 301.76, ["Fly"] = 369.49, ["Ride"] = 332.07, ["Fly|Ride"] = 348.77, ["Neon|Fly|Ride"] = 1131.73}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 16.36, ["Fly"] = 55.6, ["Ride"] = 39, ["Fly|Ride"] = 89.15, ["Neon"] = 188.01, ["Neon|Fly"] = 410.93, ["Neon|Ride"] = 164.38, ["Neon|Fly|Ride"] = 233.21, ["Mega|Ride"] = 787.4, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 10.31, ["Fly"] = 20.99, ["Ride"] = 19.68, ["Fly|Ride"] = 43.17, ["Neon"] = 111.6, ["Neon|Fly"] = 132.53, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 1575, ["Mega|Ride"] = 618.19, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 685.3, ["Fly"] = 787.5, ["Ride"] = 520.15, ["Fly|Ride"] = 528.11, ["Neon|Fly|Ride"] = 2054.59, ["Mega|Fly|Ride"] = 8766.9}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1228.49, ["Ride"] = 1265.25, ["Fly|Ride"] = 1181.25, ["Neon"] = 4794.37, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 13782.3}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 86.51, ["Fly"] = 133.59, ["Ride"] = 103.69, ["Fly|Ride"] = 99.64, ["Neon"] = 971.25, ["Neon|Ride"] = 585.46, ["Neon|Fly|Ride"] = 498.75, ["Mega|Fly|Ride"] = 3099.93}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 171.18, ["Fly"] = 157.49, ["Ride"] = 171.45, ["Fly|Ride"] = 230.4, ["Neon"] = 833.15, ["Neon|Ride"] = 672.89, ["Neon|Fly|Ride"] = 628.38, ["Mega|Ride"] = 3014.07, ["Mega|Fly|Ride"] = 2792.56}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 25.86, ["Ride"] = 47.25, ["Neon"] = 384.22, ["Neon|Ride"] = 272.98, ["Mega|Ride"] = 862.94, ["Mega|Fly|Ride"] = 903}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 155.93, ["Ride"] = 315, ["Fly|Ride"] = 548.66, ["Neon|Fly|Ride"] = 1301.82, ["Mega|Fly|Ride"] = 3836.94}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2233.62, ["Ride"] = 2480.72, ["Fly|Ride"] = 3149.99, ["Neon|Fly|Ride"] = 10272.89, ["Mega|Fly|Ride"] = 27895.76}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 56.47, ["Fly"] = 205.5, ["Ride"] = 51.83, ["Fly|Ride"] = 196.88, ["Neon"] = 511.88, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 343.87, ["Mega|Ride"] = 1096.13, ["Mega|Fly|Ride"] = 1394.8}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 643.01, ["Ride"] = 606.4, ["Fly|Ride"] = 689.07, ["Neon|Ride"] = 1643.67, ["Neon|Fly|Ride"] = 1292.68, ["Mega|Fly|Ride"] = 3359.54}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 39.37, ["Fly"] = 54.81, ["Ride"] = 46.2, ["Fly|Ride"] = 82.45, ["Neon|Ride"] = 266.09, ["Neon|Fly|Ride"] = 219.86, ["Mega|Fly|Ride"] = 1181.24}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.1, ["Fly"] = 37.45, ["Ride"] = 20.57, ["Fly|Ride"] = 41.11, ["Neon"] = 15.65, ["Neon|Fly"] = 85.26, ["Neon|Ride"] = 38.5, ["Neon|Fly|Ride"] = 94.69, ["Mega|Fly"] = 248.99, ["Mega|Ride"] = 182.1, ["Mega|Fly|Ride"] = 295.4}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 50.14, ["Ride"] = 123.31, ["Fly|Ride"] = 253.32, ["Neon"] = 339.02, ["Neon|Ride"] = 309.23, ["Neon|Fly|Ride"] = 685.21, ["Mega"] = 1501.91, ["Mega|Fly|Ride"] = 1429.16}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 826.87, ["Fly"] = 984.38, ["Ride"] = 780.53, ["Fly|Ride"] = 888.02, ["Neon|Ride"] = 2598.75, ["Neon|Fly|Ride"] = 2572.49, ["Mega|Fly|Ride"] = 8821.34}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 714.65, ["Ride"] = 820.92, ["Fly|Ride"] = 953.45, ["Neon|Fly|Ride"] = 4099.92, ["Mega|Fly|Ride"] = 14928.56}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 13.02, ["Fly"] = 26.25, ["Ride"] = 18.5, ["Fly|Ride"] = 38.67, ["Neon"] = 118.13, ["Neon|Ride"] = 109.27, ["Neon|Fly|Ride"] = 163.79, ["Mega|Ride"] = 685.21, ["Mega|Fly|Ride"] = 671.86}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 7.54, ["Ride"] = 26.25, ["Fly|Ride"] = 59.07, ["Neon"] = 118.13, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 465.94, ["Mega|Ride"] = 410.93, ["Mega|Fly|Ride"] = 534.2}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 3.33, ["Ride"] = 22.32, ["Fly|Ride"] = 111.57, ["Neon"] = 19.04, ["Neon|Fly"] = 310.36, ["Neon|Ride"] = 54.46, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 132.5, ["Mega|Fly"] = 527.71, ["Mega|Ride"] = 273.95, ["Mega|Fly|Ride"] = 334.69}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 40.78, ["Fly"] = 40.69, ["Ride"] = 46.95, ["Fly|Ride"] = 90.57, ["Neon"] = 249.38, ["Neon|Ride"] = 203.41, ["Neon|Fly|Ride"] = 207.96, ["Mega|Fly|Ride"] = 972.46}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 51.75, ["Ride"] = 133.84, ["Fly|Ride"] = 1027.3, ["Neon"] = 424.07, ["Neon|Ride"] = 548.59, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1779.27, ["Mega|Ride"] = 1540.95, ["Mega|Fly|Ride"] = 1507.04}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 9, ["Fly"] = 43.3, ["Ride"] = 34.99, ["Fly|Ride"] = 78.75, ["Neon"] = 105, ["Neon|Ride"] = 118.02, ["Neon|Fly|Ride"] = 156.19, ["Mega"] = 452.03, ["Mega|Ride"] = 352.96, ["Mega|Fly|Ride"] = 463.32}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 35.35, ["Ride"] = 35.43, ["Fly|Ride"] = 84.34, ["Neon"] = 322.59, ["Neon|Ride"] = 218.67, ["Neon|Fly|Ride"] = 196.76, ["Mega"] = 2100, ["Mega|Ride"] = 959.51, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.92, ["Fly"] = 13.13, ["Ride"] = 13.98, ["Fly|Ride"] = 45.11, ["Neon"] = 26.17, ["Neon|Ride"] = 45.93, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 732.38, ["Mega|Ride"] = 464.94, ["Mega|Fly|Ride"] = 513.65}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 6.36, ["Fly"] = 43.64, ["Ride"] = 34.74, ["Fly|Ride"] = 31507.77, ["Neon"] = 31.07, ["Neon|Fly"] = 115.54, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 162.32, ["Mega"] = 287.66, ["Mega|Ride"] = 306.48, ["Mega|Fly|Ride"] = 548.59}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 48.65, ["Fly"] = 65.62, ["Ride"] = 51.78, ["Fly|Ride"] = 93.19, ["Neon"] = 403.34, ["Neon|Ride"] = 205.48, ["Neon|Fly|Ride"] = 223.97, ["Mega|Fly|Ride"] = 1073.21}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1543.49, ["Fly"] = 1543.5, ["Ride"] = 1414.88, ["Fly|Ride"] = 1426.08, ["Neon|Fly|Ride"] = 3858.74, ["Mega|Fly|Ride"] = 13480.61}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 461.99, ["Fly"] = 479.75, ["Ride"] = 459.38, ["Fly|Ride"] = 450.35, ["Neon|Fly|Ride"] = 3240.08, ["Mega|Fly|Ride"] = 9588.72}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 281.75, ["Ride"] = 331.35, ["Fly|Ride"] = 487.31, ["Neon"] = 853.13, ["Neon|Fly|Ride"] = 1713.54, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 36.63}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 25.89, ["Ride"] = 41.1, ["Fly|Ride"] = 98.43, ["Neon|Ride"] = 287.66, ["Neon|Fly|Ride"] = 314.09, ["Mega|Ride"] = 1493.68, ["Mega|Fly|Ride"] = 1038.19}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 71234.87, ["Fly"] = 65625, ["Ride"] = 34874.11, ["Fly|Ride"] = 16316.2, ["Neon|Fly|Ride"] = 38062.5, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 293.73, ["Fly"] = 611.63, ["Ride"] = 301.88, ["Fly|Ride"] = 305, ["Neon"] = 1368.36, ["Neon|Fly"] = 1240.21, ["Neon|Ride"] = 1068.04, ["Neon|Fly|Ride"] = 1026.51, ["Mega"] = 6163.75, ["Mega|Ride"] = 4108.14, ["Mega|Fly|Ride"] = 3871.88}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 274.34, ["Fly"] = 525, ["Ride"] = 137.69, ["Fly|Ride"] = 203.44}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 205.5, ["Fly"] = 262.5, ["Ride"] = 172.07, ["Fly|Ride"] = 216.46, ["Neon|Ride"] = 685.21, ["Neon|Fly|Ride"] = 637.88, ["Mega|Fly|Ride"] = 5136.45}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 15.1, ["Fly"] = 94.5, ["Ride"] = 30.17, ["Fly|Ride"] = 110.38, ["Neon"] = 393.75, ["Neon|Ride"] = 135.61, ["Neon|Fly|Ride"] = 274.31, ["Mega"] = 695.08, ["Mega|Ride"] = 548.59}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 5275.29, ["Ride"] = 5131.95, ["Fly|Ride"] = 4041.19, ["Neon"] = 26709.5, ["Neon|Fly|Ride"] = 27120.41}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 26.25, ["Fly"] = 137.69, ["Ride"] = 30.4, ["Fly|Ride"] = 51.1, ["Neon"] = 205.48, ["Neon|Ride"] = 343.88, ["Neon|Fly|Ride"] = 265.02, ["Mega|Fly|Ride"] = 780.75}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 32.81, ["Ride"] = 55.33, ["Fly|Ride"] = 77.9, ["Neon"] = 398.61, ["Neon|Ride"] = 486.94, ["Neon|Fly|Ride"] = 359.63, ["Mega|Fly|Ride"] = 1372.86}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 522.16, ["Fly"] = 920.07, ["Ride"] = 812.44, ["Fly|Ride"] = 708.58, ["Neon"] = 2258.17, ["Neon|Ride"] = 1968.75, ["Neon|Fly|Ride"] = 1955.63, ["Mega|Fly|Ride"] = 7153.13}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 14.16, ["Fly"] = 21.27, ["Ride"] = 23.4, ["Fly|Ride"] = 38.07, ["Neon"] = 115.49, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 137.68, ["Mega|Fly|Ride"] = 613.18}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 10.64, ["Fly"] = 274.34, ["Ride"] = 22.32, ["Fly|Ride"] = 80, ["Neon"] = 106.85, ["Neon|Ride"] = 116.24, ["Neon|Fly|Ride"] = 129.94, ["Mega|Fly|Ride"] = 548.59}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 97.12, ["Ride"] = 119.19, ["Fly|Ride"] = 262.5, ["Neon"] = 1010.63, ["Neon|Ride"] = 530.25, ["Neon|Fly|Ride"] = 603.03, ["Mega|Ride"] = 2724.39, ["Mega|Fly|Ride"] = 2726.43}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 15.14, ["Fly"] = 151.59, ["Ride"] = 63.32, ["Fly|Ride"] = 154.61, ["Neon"] = 71.57, ["Neon|Ride"] = 137.68, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 298.46, ["Mega|Fly"] = 715.79, ["Mega|Ride"] = 276.29, ["Mega|Fly|Ride"] = 396.96}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3930.83, ["Ride"] = 3883.64, ["Fly|Ride"] = 4160.61, ["Neon|Ride"] = 11812.5, ["Neon|Fly|Ride"] = 9841.13, ["Mega"] = 61637.28, ["Mega|Fly|Ride"] = 35334.63}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 34.26, ["Ride"] = 64.01, ["Fly|Ride"] = 190.66, ["Neon"] = 888.57, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 410.93, ["Mega|Ride"] = 1019.08, ["Mega|Fly|Ride"] = 1438.21}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 7271.25, ["Ride"] = 6857.82, ["Fly|Ride"] = 6613.41, ["Neon|Ride"] = 18902.12, ["Neon|Fly|Ride"] = 17587.5, ["Mega|Fly|Ride"] = 63540.7}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.61, ["Fly"] = 20.01, ["Ride"] = 11.66, ["Fly|Ride"] = 26.59, ["Neon"] = 17.07, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 62.99, ["Neon|Fly|Ride"] = 87.94, ["Mega"] = 449.84, ["Mega|Fly|Ride"] = 340.06}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 18.51, ["Fly"] = 28.71, ["Ride"] = 38.06, ["Fly|Ride"] = 41.86, ["Neon"] = 137.68, ["Neon|Fly"] = 227.05, ["Neon|Ride"] = 548.59, ["Neon|Fly|Ride"] = 161.43, ["Mega|Ride"] = 985.04, ["Mega|Fly|Ride"] = 786.19}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.82}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 10.31, ["Ride"] = 32.61, ["Fly|Ride"] = 85.32, ["Neon"] = 102.75, ["Neon|Ride"] = 157.67, ["Neon|Fly|Ride"] = 205.48, ["Mega"] = 1050, ["Mega|Ride"] = 959.51, ["Mega|Fly|Ride"] = 1231.8}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 25.01, ["Fly"] = 190.37, ["Ride"] = 41.19, ["Fly|Ride"] = 99.75, ["Neon"] = 207.53, ["Neon|Ride"] = 192.12, ["Neon|Fly|Ride"] = 317.05, ["Mega"] = 945, ["Mega|Fly|Ride"] = 1099.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 12.5, ["Fly"] = 18.47, ["Ride"] = 17.74, ["Fly|Ride"] = 36.84, ["Neon|Fly"] = 109.94, ["Neon|Ride"] = 114.05, ["Neon|Fly|Ride"] = 179.55, ["Mega"] = 2465.51, ["Mega|Ride"] = 580.02, ["Mega|Fly|Ride"] = 517.77}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8322.08}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2624.97}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 20.5}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 203.44, ["Ride"] = 246.6, ["Fly|Ride"] = 223.12, ["Neon|Fly|Ride"] = 685.21, ["Mega|Fly|Ride"] = 5114.23}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 12.92, ["Fly"] = 129.47, ["Ride"] = 48.3, ["Fly|Ride"] = 139.13, ["Neon"] = 152.06, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 265.13, ["Mega|Ride"] = 929.87, ["Mega|Fly|Ride"] = 957.45}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 14.01}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 6.24, ["Ride"] = 29.92, ["Fly|Ride"] = 82.21, ["Neon"] = 105, ["Neon|Ride"] = 96.58, ["Mega|Fly|Ride"] = 821.85}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 3051.63}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 181.58, ["Fly"] = 410.99, ["Ride"] = 215.25, ["Fly|Ride"] = 328.13, ["Neon"] = 754.04, ["Neon|Ride"] = 774.38, ["Mega|Ride"] = 3150.71, ["Mega|Fly|Ride"] = 3426.03}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 73.07, ["Ride"] = 101.24, ["Fly|Ride"] = 164.4, ["Neon"] = 548.59, ["Neon|Ride"] = 502.51, ["Neon|Fly|Ride"] = 1435.35, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 166.09, ["Fly"] = 265.49, ["Ride"] = 192.14, ["Fly|Ride"] = 262.5, ["Neon"] = 761.25, ["Neon|Ride"] = 1053.08, ["Neon|Fly|Ride"] = 959.51, ["Mega|Fly|Ride"] = 4777.5}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1811.25, ["Fly"] = 3151.1, ["Ride"] = 2099.05, ["Fly|Ride"] = 2034.44, ["Neon"] = 8136.28, ["Neon|Fly|Ride"] = 6431.24, ["Mega|Fly|Ride"] = 17718.75}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 15.66, ["Fly"] = 96.59, ["Ride"] = 56.8, ["Fly|Ride"] = 69.02, ["Neon"] = 127.3, ["Neon|Ride"] = 202.26, ["Neon|Fly|Ride"] = 192.12, ["Mega"] = 923.54, ["Mega|Ride"] = 1007.75, ["Mega|Fly|Ride"] = 685.21}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 782.25, ["Fly"] = 2100, ["Ride"] = 727.65, ["Fly|Ride"] = 945.24, ["Neon|Fly|Ride"] = 4108.14, ["Mega|Fly|Ride"] = 18597.17}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 40.65}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 16, ["Ride"] = 39.38, ["Fly|Ride"] = 647.98, ["Neon"] = 81.38, ["Neon|Ride"] = 137.68, ["Neon|Fly|Ride"] = 303.07, ["Mega"] = 480.38, ["Mega|Ride"] = 514.56, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 8.86, ["Fly"] = 163.89, ["Ride"] = 20.56, ["Fly|Ride"] = 96.77, ["Neon"] = 39.11, ["Neon|Ride"] = 64.73, ["Neon|Fly|Ride"] = 210, ["Mega"] = 918.75, ["Mega|Ride"] = 356.49, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 57.39}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 18.62, ["Ride"] = 31.5, ["Fly|Ride"] = 80.15, ["Neon"] = 93, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 183.75, ["Mega|Ride"] = 821.85, ["Mega|Fly|Ride"] = 1849.14}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 21.61, ["Fly"] = 55.5, ["Ride"] = 45.93, ["Fly|Ride"] = 52.41, ["Neon"] = 233.21, ["Neon|Ride"] = 294.84, ["Neon|Fly|Ride"] = 326.7, ["Mega"] = 959.51, ["Mega|Ride"] = 1743.5, ["Mega|Fly|Ride"] = 959.51}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6300, ["Fly"] = 10959.46, ["Ride"] = 6793.49, ["Fly|Ride"] = 5222.44, ["Neon|Fly|Ride"] = 11779.92, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 7.88, ["Fly"] = 65.62, ["Ride"] = 26.73, ["Fly|Ride"] = 131.25, ["Neon"] = 81.24, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 158.22, ["Mega"] = 410.93, ["Mega|Ride"] = 410.93, ["Mega|Fly|Ride"] = 695.37}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 20.34}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 88.41, ["Fly"] = 363.72, ["Ride"] = 135.19, ["Fly|Ride"] = 232.21, ["Neon"] = 479.76, ["Neon|Ride"] = 534.68, ["Neon|Fly|Ride"] = 657.48, ["Mega"] = 2879.59, ["Mega|Fly|Ride"] = 1919}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 43.31, ["Fly"] = 139.51, ["Ride"] = 73.63, ["Fly|Ride"] = 152.25, ["Neon"] = 255.93, ["Neon|Ride"] = 265.13, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 2324.66, ["Mega|Ride"] = 2773.7, ["Mega|Fly|Ride"] = 1777.22}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 22.99, ["Fly"] = 70.46, ["Ride"] = 23.94, ["Fly|Ride"] = 68.16, ["Neon|Fly"] = 233.21, ["Neon|Ride"] = 109.28, ["Neon|Fly|Ride"] = 188.39, ["Mega"] = 1016.21, ["Mega|Ride"] = 853.16, ["Mega|Fly|Ride"] = 721.87}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 4.05, ["Fly"] = 65.54, ["Ride"] = 26.71, ["Fly|Ride"] = 65.45, ["Neon"] = 29.3, ["Neon|Ride"] = 45, ["Neon|Fly|Ride"] = 128.4, ["Mega|Fly"] = 254.63, ["Mega|Ride"] = 194.49, ["Mega|Fly|Ride"] = 289.95}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 11.97, ["Fly"] = 38.19, ["Ride"] = 25.05, ["Fly|Ride"] = 72.77, ["Neon"] = 85.32, ["Neon|Ride"] = 122.26, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 720.66, ["Mega|Ride"] = 426.57, ["Mega|Fly|Ride"] = 479.76}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 19.38, ["Fly"] = 28.88, ["Ride"] = 24.82, ["Fly|Ride"] = 44.58, ["Neon|Ride"] = 164.38, ["Neon|Fly|Ride"] = 137.68, ["Mega|Fly|Ride"] = 726.31}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 178.5}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 28.54, ["Ride"] = 94.5, ["Fly|Ride"] = 279.59, ["Neon"] = 195.2, ["Neon|Fly|Ride"] = 562.97, ["Mega"] = 821.85, ["Mega|Fly|Ride"] = 786.19}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 286.67, ["Ride"] = 443.63, ["Fly|Ride"] = 1550.75}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 44.62, ["Fly"] = 212.3, ["Ride"] = 93.05, ["Fly|Ride"] = 131.25, ["Neon"] = 346.29, ["Neon|Ride"] = 295.32, ["Neon|Fly|Ride"] = 411.34, ["Mega"] = 908.24, ["Mega|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 1232.76}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 918.73, ["Fly"] = 1334.47, ["Ride"] = 944.9, ["Fly|Ride"] = 1030.32, ["Neon|Fly"] = 4021.65, ["Neon|Ride"] = 3281.25, ["Neon|Fly|Ride"] = 3010.03, ["Mega|Fly|Ride"] = 9588.72}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 392.44, ["Fly"] = 685.3, ["Ride"] = 391.15, ["Fly|Ride"] = 413.38, ["Neon"] = 2876.42, ["Neon|Ride"] = 2054.59, ["Neon|Fly|Ride"] = 2123.58, ["Mega|Fly|Ride"] = 7479.94}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 55.71}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 3.49}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 8.23, ["Fly"] = 78.75, ["Ride"] = 19.74, ["Fly|Ride"] = 51.19, ["Neon"] = 59.07, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 96.58, ["Neon|Fly|Ride"] = 157.48, ["Mega"] = 437.26, ["Mega|Ride"] = 685.21, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 253.01, ["Fly"] = 392.03, ["Ride"] = 261.15, ["Fly|Ride"] = 333.67, ["Neon"] = 1093.05, ["Neon|Ride"] = 984.38, ["Neon|Fly|Ride"] = 917.44, ["Mega|Fly|Ride"] = 3164.05}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 15.62}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 118.79, ["Ride"] = 137.69, ["Fly|Ride"] = 343.17, ["Neon"] = 688.3, ["Neon|Ride"] = 519.75, ["Neon|Fly|Ride"] = 918.75, ["Mega"] = 9861.97, ["Mega|Ride"] = 2711.03, ["Mega|Fly|Ride"] = 2870.26}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 123.54, ["Fly"] = 138.72, ["Ride"] = 104.13, ["Fly|Ride"] = 137.69, ["Neon"] = 685.21, ["Neon|Ride"] = 1005.38, ["Neon|Fly|Ride"] = 913.5, ["Mega|Ride"] = 3426.03}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 3.94, ["Ride"] = 28.12, ["Fly|Ride"] = 167.49, ["Neon"] = 30.85, ["Neon|Ride"] = 98.64, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 160.12, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 819.79}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 12.39, ["Fly"] = 63.03, ["Ride"] = 26.25, ["Fly|Ride"] = 73.24, ["Neon"] = 177.19, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 393.75, ["Mega|Ride"] = 800.27, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 12.12, ["Fly"] = 102.34, ["Ride"] = 68.85, ["Fly|Ride"] = 82.37, ["Neon"] = 105, ["Neon|Ride"] = 131.51, ["Neon|Fly|Ride"] = 255.94, ["Mega"] = 498.75, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 726.31}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 3.87, ["Fly"] = 123.38, ["Ride"] = 39.38, ["Fly|Ride"] = 152.81, ["Neon"] = 19.69, ["Neon|Fly"] = 232.47, ["Neon|Ride"] = 63.3, ["Neon|Fly|Ride"] = 163.46, ["Mega|Ride"] = 177.18, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 255.73, ["Ride"] = 239.21, ["Fly|Ride"] = 354.38, ["Neon"] = 1616.96, ["Neon|Ride"] = 1394.8, ["Neon|Fly|Ride"] = 1299.38, ["Mega|Fly|Ride"] = 5205.29}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 127.93, ["Fly"] = 548.66, ["Ride"] = 140.81, ["Fly|Ride"] = 241.48, ["Neon"] = 959.51, ["Neon|Ride"] = 753.8, ["Neon|Fly|Ride"] = 761.25, ["Mega|Ride"] = 3287.33, ["Mega|Fly|Ride"] = 2463.45}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 70.87, ["Fly"] = 167.45, ["Ride"] = 69.2, ["Fly|Ride"] = 175.7, ["Neon|Ride"] = 508.52, ["Neon|Fly|Ride"] = 416.06, ["Mega"] = 1781.34, ["Mega|Ride"] = 1849.14, ["Mega|Fly|Ride"] = 1801.11}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 10.68, ["Ride"] = 68.85, ["Fly|Ride"] = 274.31, ["Neon"] = 343.13, ["Neon|Ride"] = 590.47, ["Neon|Fly|Ride"] = 479.76, ["Mega|Ride"] = 616.39, ["Mega|Fly|Ride"] = 654.94}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 11.82, ["Fly"] = 57.88, ["Ride"] = 35, ["Fly|Ride"] = 75.9, ["Neon"] = 77.39, ["Neon|Ride"] = 123.3, ["Neon|Fly|Ride"] = 195.2, ["Mega"] = 328.13, ["Mega|Fly"] = 525, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 520.86}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.09, ["Fly"] = 52.45, ["Ride"] = 17.85, ["Fly|Ride"] = 98.44, ["Neon"] = 18.36, ["Neon|Fly"] = 64.92, ["Neon|Ride"] = 35.17, ["Neon|Fly|Ride"] = 118.09, ["Mega"] = 119.74, ["Mega|Ride"] = 141.74, ["Mega|Fly|Ride"] = 240.16}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 932.15, ["Fly"] = 1082.72, ["Ride"] = 868.88, ["Fly|Ride"] = 901.38, ["Neon|Fly"] = 3410.27, ["Neon|Ride"] = 3133.25, ["Neon|Fly|Ride"] = 2611.88, ["Mega|Fly|Ride"] = 10100.31}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["Ride"] = 713.04, ["Fly|Ride"] = 446.25, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1614.9, ["Mega"] = 10272.89, ["Mega|Fly|Ride"] = 6144.05}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 81.6, ["Fly"] = 137.69, ["Ride"] = 93.01, ["Fly|Ride"] = 143.98, ["Neon"] = 339.94, ["Neon|Ride"] = 304.27, ["Neon|Fly|Ride"] = 343.13, ["Mega|Fly|Ride"] = 1916.94}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 598.5, ["Ride"] = 184.25, ["Fly|Ride"] = 274.32, ["Neon|Fly|Ride"] = 1232.76, ["Mega"] = 10272.89, ["Mega|Fly|Ride"] = 5479.58}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 16.37, ["Fly"] = 52.5, ["Ride"] = 27.72, ["Fly|Ride"] = 65.62, ["Neon"] = 157.5, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 236.25, ["Mega|Ride"] = 508.52, ["Mega|Fly|Ride"] = 774.13}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 188.37, ["Ride"] = 288.9, ["Fly|Ride"] = 472.4, ["Neon"] = 821.85, ["Neon|Ride"] = 942.38, ["Neon|Fly|Ride"] = 708.75, ["Mega"] = 4088.9, ["Mega|Ride"] = 4520.08, ["Mega|Fly|Ride"] = 3818.31}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 53.82, ["Fly"] = 125.98, ["Ride"] = 71.63, ["Fly|Ride"] = 110.25, ["Neon|Ride"] = 585.83, ["Neon|Fly|Ride"] = 548.59, ["Mega|Fly|Ride"] = 1732.5}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1870.32, ["Ride"] = 1837.49, ["Fly|Ride"] = 1851.47, ["Neon|Ride"] = 10849.13, ["Neon|Fly|Ride"] = 6572.61, ["Mega"] = 49309.83, ["Mega|Fly|Ride"] = 22147.31}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 12.89, ["Fly"] = 82.83, ["Ride"] = 41.11, ["Fly|Ride"] = 87.44, ["Neon"] = 51.9, ["Neon|Fly"] = 186.98, ["Neon|Ride"] = 76.22, ["Neon|Fly|Ride"] = 136.55, ["Mega"] = 257.53, ["Mega|Ride"] = 316.7, ["Mega|Fly|Ride"] = 446.24}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 51.66, ["Fly"] = 78.75, ["Ride"] = 81.18, ["Fly|Ride"] = 125.9, ["Neon"] = 160.13, ["Neon|Ride"] = 363.67, ["Mega"] = 1627.27, ["Mega|Fly|Ride"] = 1232.76}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 78.66, ["Fly"] = 78.7, ["Ride"] = 77.3, ["Fly|Ride"] = 78.75, ["Neon"] = 525, ["Neon|Ride"] = 479.76, ["Neon|Fly|Ride"] = 380.62, ["Mega|Fly|Ride"] = 1842.37}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 3426.45, ["Fly"] = 1550.74, ["Ride"] = 1069.68, ["Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 479.07, ["Ride"] = 677.08, ["Fly|Ride"] = 656.25, ["Neon|Fly|Ride"] = 3099.93}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 81.96, ["Fly"] = 202.29, ["Ride"] = 107.25, ["Fly|Ride"] = 196.88, ["Neon"] = 408.19, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 620.7, ["Mega"] = 4109.17, ["Mega|Ride"] = 4109.17, ["Mega|Fly|Ride"] = 2028.91}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 5.93, ["Ride"] = 21.75, ["Fly|Ride"] = 137.69, ["Neon"] = 45.94, ["Neon|Ride"] = 94.85, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 762.72}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 37.57, ["Fly"] = 68.25, ["Ride"] = 49.51, ["Fly|Ride"] = 104.66, ["Neon"] = 262.5, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 303.07, ["Mega"] = 853.13, ["Mega|Fly|Ride"] = 1036.88}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 757.32, ["Ride"] = 784.88, ["Fly|Ride"] = 860.98, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2139.38, ["Mega|Fly|Ride"] = 9723}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 621.78}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 4921.87, ["Ride"] = 6137.79, ["Fly|Ride"] = 5512.5, ["Neon"] = 42000, ["Neon|Ride"] = 29443.11, ["Neon|Fly|Ride"] = 19861.59, ["Mega|Fly|Ride"] = 87662.6}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 313.38, ["Fly"] = 410.99, ["Ride"] = 393.75, ["Neon"] = 1643.67, ["Neon|Fly|Ride"] = 2054.59, ["Mega"] = 6162.72, ["Mega|Fly|Ride"] = 6163.75}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 85.31, ["Fly"] = 274.34, ["Ride"] = 122.07, ["Fly|Ride"] = 336, ["Neon"] = 620.7, ["Neon|Ride"] = 1643.67, ["Neon|Fly|Ride"] = 1639.57, ["Mega|Fly|Ride"] = 2111.09}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 10.39, ["Fly"] = 41.11, ["Ride"] = 24.86, ["Fly|Ride"] = 85.32, ["Neon"] = 112.17, ["Neon|Fly"] = 1240.21, ["Neon|Ride"] = 82.21, ["Neon|Fly|Ride"] = 240.4, ["Mega|Ride"] = 821.85, ["Mega|Fly|Ride"] = 685.21}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 13.12, ["Fly"] = 26.23, ["Ride"] = 20.18, ["Fly|Ride"] = 39.21, ["Neon"] = 205.48, ["Neon|Ride"] = 310.36, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 2177.87}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 16.09, ["Ride"] = 27.56, ["Fly|Ride"] = 140.44, ["Neon"] = 102.38, ["Neon|Ride"] = 141.75, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 670.69, ["Mega|Ride"] = 616.39, ["Mega|Fly|Ride"] = 654.94}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 3.94, ["Ride"] = 22.32, ["Fly|Ride"] = 39.38, ["Neon"] = 31.38, ["Neon|Ride"] = 55.5, ["Neon|Fly|Ride"] = 129.45, ["Mega"] = 274.31, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 310.36}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 23.51, ["Fly"] = 90.57, ["Ride"] = 34.13, ["Fly|Ride"] = 139.13, ["Neon"] = 178.77, ["Neon|Fly"] = 821.85, ["Neon|Ride"] = 249.37, ["Neon|Fly|Ride"] = 408.19, ["Mega"] = 630, ["Mega|Ride"] = 685.21, ["Mega|Fly|Ride"] = 825.96}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 392.44, ["Fly"] = 538.12, ["Ride"] = 406.88, ["Fly|Ride"] = 488.74, ["Neon"] = 1561.49, ["Neon|Ride"] = 1370.41, ["Neon|Fly|Ride"] = 1351.88, ["Mega"] = 7875, ["Mega|Fly|Ride"] = 11623.23}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.63, ["Fly"] = 18.38, ["Ride"] = 14.61, ["Fly|Ride"] = 23.27, ["Neon"] = 19.16, ["Neon|Ride"] = 33.01, ["Neon|Fly|Ride"] = 104.79, ["Mega"] = 821.85, ["Mega|Ride"] = 310.36, ["Mega|Fly|Ride"] = 248.75}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 48.57, ["Fly"] = 78.75, ["Ride"] = 73.63, ["Fly|Ride"] = 123.33, ["Neon"] = 205.48, ["Neon|Fly"] = 315.39, ["Neon|Ride"] = 215.45, ["Neon|Fly|Ride"] = 245.57, ["Mega"] = 575.05, ["Mega|Ride"] = 577.5, ["Mega|Fly|Ride"] = 590.46}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 771.75, ["Ride"] = 768.94, ["Fly|Ride"] = 813.75, ["Neon|Ride"] = 1603.88, ["Neon|Fly|Ride"] = 1561.88, ["Mega|Fly|Ride"] = 3934.82}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 34.76, ["Fly"] = 165.37, ["Ride"] = 47.25, ["Fly|Ride"] = 78.66, ["Neon|Ride"] = 205.48, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 1575, ["Mega|Fly|Ride"] = 795.34}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 315, ["Fly"] = 380.63, ["Ride"] = 238.25, ["Fly|Ride"] = 304.28, ["Neon|Ride"] = 1394.8, ["Neon|Fly|Ride"] = 1120.71}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 168.92, ["Fly"] = 269.19, ["Ride"] = 194.15, ["Fly|Ride"] = 199.49, ["Neon"] = 633.63, ["Neon|Ride"] = 801.29, ["Neon|Fly|Ride"] = 656.25, ["Mega|Fly|Ride"] = 3473.01}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 795.23, ["Ride"] = 687.08, ["Fly|Ride"] = 786.19, ["Neon|Ride"] = 3426.03, ["Neon|Fly|Ride"] = 2986.34, ["Mega|Fly|Ride"] = 7611.19}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 20.25, ["Ride"] = 43.32, ["Fly|Ride"] = 110.25, ["Neon"] = 84.26, ["Neon|Fly"] = 278.98, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 269.67, ["Mega"] = 354.38, ["Mega|Ride"] = 388.33, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 4084.48, ["Ride"] = 3936.19, ["Fly|Ride"] = 3465, ["Neon"] = 13697.87, ["Neon|Fly|Ride"] = 6979.41, ["Mega|Fly|Ride"] = 24448.45}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 123.69, ["Fly"] = 166.28, ["Ride"] = 115.86, ["Fly|Ride"] = 200.15, ["Neon"] = 550.97, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 593.25, ["Mega|Fly|Ride"] = 2300.11}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.16, ["Fly"] = 27.32, ["Ride"] = 19.68, ["Fly|Ride"] = 38.07, ["Neon"] = 14.44, ["Neon|Fly"] = 65.62, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 121.46, ["Mega|Fly"] = 452.82, ["Mega|Ride"] = 155.76, ["Mega|Fly|Ride"] = 244.13}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.72, ["Ride"] = 15.75, ["Fly|Ride"] = 57.7, ["Neon"] = 20.46, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 266.44, ["Mega"] = 161.44, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 343.13}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 25.46, ["Ride"] = 38.75, ["Fly|Ride"] = 56.34, ["Neon|Fly|Ride"] = 342.9, ["Mega|Fly|Ride"] = 1092.6}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 985.56, ["Ride"] = 1228.81, ["Fly|Ride"] = 1312.5}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 6164.51, ["Fly|Ride"] = 6164.51}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 19.95, ["Fly"] = 25.91, ["Ride"] = 23, ["Fly|Ride"] = 43.65, ["Neon"] = 452.12, ["Neon|Ride"] = 274.31, ["Neon|Fly|Ride"] = 142.61, ["Mega"] = 2465.51, ["Mega|Ride"] = 959.51, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 15.42, ["Fly"] = 41.09, ["Ride"] = 20.56, ["Fly|Ride"] = 61.58, ["Neon"] = 89.24, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 109.28, ["Neon|Fly|Ride"] = 179.21, ["Mega"] = 655.54, ["Mega|Ride"] = 775.28, ["Mega|Fly|Ride"] = 524.16}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 71.45, ["Fly"] = 157.49, ["Ride"] = 72.18, ["Fly|Ride"] = 113.29, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 441.57, ["Mega|Fly|Ride"] = 1435.61}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 258.57, ["Ride"] = 224.44, ["Fly|Ride"] = 268.53, ["Neon|Ride"] = 977.79, ["Neon|Fly|Ride"] = 1102.5, ["Mega"] = 10272.89, ["Mega|Fly|Ride"] = 5479.58}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.49, ["Ride"] = 30.34, ["Fly|Ride"] = 86.56, ["Neon"] = 23, ["Neon|Fly"] = 68.85, ["Neon|Ride"] = 101.72, ["Mega"] = 137.94, ["Mega|Ride"] = 191.02}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 145.41, ["Ride"] = 175.77, ["Fly|Ride"] = 262.8, ["Neon"] = 739.67, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 644.07, ["Mega|Fly|Ride"] = 3603.22}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 3.46, ["Fly"] = 41.67, ["Ride"] = 16.66, ["Fly|Ride"] = 47.86, ["Neon"] = 20.57, ["Neon|Fly"] = 123.3, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 108.94, ["Mega"] = 210, ["Mega|Ride"] = 223.12, ["Mega|Fly|Ride"] = 245.42}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 174.57, ["Fly"] = 274.34, ["Ride"] = 274.33, ["Fly|Ride"] = 246.6, ["Neon|Fly|Ride"] = 879.38, ["Mega"] = 10272.89, ["Mega|Fly|Ride"] = 4109.17}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 10.5, ["Fly"] = 84.46, ["Ride"] = 27.09, ["Fly|Ride"] = 68.25, ["Neon"] = 73.5, ["Neon|Fly"] = 295.24, ["Neon|Ride"] = 152.06, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 478.73, ["Mega|Ride"] = 616.39, ["Mega|Fly|Ride"] = 449.5}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.21, ["Ride"] = 23.31, ["Fly|Ride"] = 65.54, ["Neon"] = 6.56, ["Neon|Fly"] = 170.45, ["Neon|Ride"] = 31.77, ["Neon|Fly|Ride"] = 177.08, ["Mega"] = 52.5, ["Mega|Ride"] = 114.19, ["Mega|Fly|Ride"] = 195.57}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.62, ["Mega|Ride"] = 147.94}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 2.26, ["Fly"] = 52.49, ["Ride"] = 25.14, ["Fly|Ride"] = 108.17, ["Neon"] = 5.8, ["Neon|Ride"] = 38.62, ["Neon|Fly|Ride"] = 131.22, ["Mega"] = 73.5, ["Mega|Fly"] = 154977.14, ["Mega|Ride"] = 79.71, ["Mega|Fly|Ride"] = 201.51}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 71.87, ["Fly"] = 525, ["Ride"] = 95.97, ["Fly|Ride"] = 149.93, ["Neon"] = 236.8, ["Neon|Fly"] = 282.19, ["Neon|Ride"] = 292.69, ["Neon|Fly|Ride"] = 308.21, ["Mega|Fly|Ride"] = 1172.76}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 33.72, ["Ride"] = 10.5, ["Fly|Ride"] = 108.92, ["Neon"] = 8.02, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 129.94, ["Mega|Ride"] = 165.37, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 11.99, ["Ride"] = 162.64, ["Neon"] = 78.75, ["Neon|Ride"] = 259.88, ["Mega"] = 459.38}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.05, ["Neon"] = 2.1, ["Neon|Ride"] = 51.71, ["Neon|Fly|Ride"] = 274.31, ["Mega|Ride"] = 40.49, ["Mega|Fly|Ride"] = 322.12}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.05, ["Fly"] = 15.75, ["Ride"] = 15.44, ["Fly|Ride"] = 33.45, ["Neon"] = 2.1, ["Neon|Fly"] = 18.38, ["Neon|Ride"] = 14.13, ["Neon|Fly|Ride"] = 55.5, ["Mega|Fly"] = 31.38, ["Mega|Ride"] = 13.13, ["Mega|Fly|Ride"] = 69.93}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 18.15, ["Ride"] = 12.6, ["Fly|Ride"] = 81.38, ["Neon"] = 2.63, ["Neon|Fly"] = 39.16, ["Neon|Ride"] = 13.62, ["Neon|Fly|Ride"] = 39.34, ["Mega"] = 31.38, ["Mega|Ride"] = 32.82}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Neon"] = 2.62, ["Neon|Fly"] = 105, ["Neon|Ride"] = 63.03, ["Mega|Ride"] = 77.89}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 91.84, ["Ride"] = 13.13, ["Fly|Ride"] = 107.63, ["Neon"] = 6.57, ["Neon|Fly"] = 167.96, ["Neon|Ride"] = 19.68, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 23.63, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 137.68, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.05, ["Neon"] = 3.83, ["Neon|Fly|Ride"] = 205.48, ["Mega|Ride"] = 70.03, ["Mega|Fly|Ride"] = 205.48}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 2.1, ["Fly"] = 68.85, ["Ride"] = 19.68, ["Fly|Ride"] = 71.94, ["Neon"] = 8.3, ["Neon|Fly"] = 68.85, ["Neon|Ride"] = 32.79, ["Neon|Fly|Ride"] = 115.7, ["Mega"] = 107.63, ["Mega|Fly"] = 139.5, ["Mega|Ride"] = 124.64, ["Mega|Fly|Ride"] = 189.6}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.05, ["Ride"] = 50.94, ["Neon"] = 2.1, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 258.44, ["Mega|Fly"] = 144.38, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.63, ["Fly|Ride"] = 524.99, ["Neon"] = 16.1, ["Mega"] = 188.41, ["Mega|Fly"] = 315, ["Mega|Ride"] = 712.48}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.05, ["Ride"] = 27.57, ["Neon"] = 16.7, ["Mega"] = 103.94, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 548.59}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.05, ["Ride"] = 24.94, ["Neon"] = 3.6, ["Neon|Ride"] = 26.72, ["Neon|Fly|Ride"] = 137.68, ["Mega"] = 19.69, ["Mega|Ride"] = 43.32, ["Mega|Fly|Ride"] = 131.15}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.05, ["Fly"] = 19.69, ["Ride"] = 11.78, ["Fly|Ride"] = 32.82, ["Neon"] = 2.1, ["Neon|Fly"] = 16.56, ["Neon|Ride"] = 13.1, ["Neon|Fly|Ride"] = 31.05, ["Mega|Fly"] = 39.04, ["Mega|Ride"] = 18.38, ["Mega|Fly|Ride"] = 49.26}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.1, ["Fly"] = 72.19, ["Ride"] = 229.68, ["Fly|Ride"] = 104.98, ["Neon"] = 34.92, ["Neon|Ride"] = 140.94, ["Mega"] = 179.82, ["Mega|Ride"] = 240.19}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.05, ["Fly"] = 26.25, ["Ride"] = 21, ["Neon"] = 2.44, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 105, ["Mega"] = 26.21, ["Mega|Ride"] = 34.13, ["Mega|Fly|Ride"] = 126.99}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 2.23, ["Neon"] = 11.42, ["Neon|Fly|Ride"] = 137.68, ["Mega"] = 109.28, ["Mega|Ride"] = 164.38, ["Mega|Fly|Ride"] = 238.87}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.51, ["Fly"] = 91.88, ["Ride"] = 34.53, ["Fly|Ride"] = 187, ["Neon"] = 65.63, ["Neon|Ride"] = 55.5, ["Neon|Fly|Ride"] = 105, ["Mega"] = 210, ["Mega|Ride"] = 143.06, ["Mega|Fly|Ride"] = 196.77}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.05, ["Fly"] = 11.12, ["Ride"] = 10.91, ["Fly|Ride"] = 18.8, ["Neon"] = 2.1, ["Neon|Fly"] = 15.62, ["Neon|Ride"] = 11.71, ["Neon|Fly|Ride"] = 24.71, ["Mega|Fly"] = 37.05, ["Mega|Ride"] = 14.44, ["Mega|Fly|Ride"] = 39.29}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.05, ["Fly"] = 27.76, ["Ride"] = 27.2, ["Fly|Ride"] = 131.25, ["Neon"] = 18.51, ["Neon|Ride"] = 109.94, ["Neon|Fly|Ride"] = 196.47, ["Mega"] = 91.88, ["Mega|Ride"] = 155.76, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 3.1, ["Fly"] = 112.03, ["Ride"] = 21.99, ["Fly|Ride"] = 59.06, ["Neon"] = 60.37, ["Neon|Ride"] = 67.48, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 236.24, ["Mega|Ride"] = 288.46, ["Mega|Fly|Ride"] = 410.17}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 15.43, ["Ride"] = 12.33, ["Fly|Ride"] = 36.66, ["Neon"] = 2.1, ["Neon|Fly"] = 23.62, ["Neon|Ride"] = 13.13, ["Neon|Fly|Ride"] = 34.49, ["Mega"] = 20.97, ["Mega|Ride"] = 25.78, ["Mega|Fly|Ride"] = 98.42}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 3.94, ["Fly"] = 171.6, ["Ride"] = 30.23, ["Neon"] = 7.07, ["Neon|Ride"] = 27.76, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 85.22, ["Mega|Fly"] = 164.38, ["Mega|Ride"] = 116.82, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 35.35, ["Neon"] = 5.18, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 137.68, ["Mega"] = 30.38, ["Mega|Fly"] = 137.68, ["Mega|Ride"] = 137.68, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.05, ["Fly"] = 32.66, ["Ride"] = 17.99, ["Neon"] = 2.05, ["Neon|Fly"] = 41.11, ["Neon|Ride"] = 34.12, ["Neon|Fly|Ride"] = 154.39, ["Mega"] = 12.24, ["Mega|Ride"] = 41.66, ["Mega|Fly|Ride"] = 164.38}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 91.88, ["Ride"] = 14.95, ["Fly|Ride"] = 42.02, ["Neon"] = 5.15, ["Neon|Ride"] = 22.58, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 65.44, ["Mega|Ride"] = 40.69}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 52.73, ["Neon"] = 5.72, ["Neon|Ride"] = 52.5, ["Mega"] = 35, ["Mega|Ride"] = 132.63, ["Mega|Fly|Ride"] = 306.14}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 19.95, ["Ride"] = 14.44, ["Fly|Ride"] = 72.19, ["Neon"] = 7.3, ["Neon|Ride"] = 25.14, ["Neon|Fly|Ride"] = 84, ["Mega"] = 76.74, ["Mega|Ride"] = 90.56, ["Mega|Fly|Ride"] = 308.2}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 7.88, ["Fly"] = 41.58, ["Ride"] = 36.26, ["Neon"] = 30.49, ["Neon|Fly"] = 188.89, ["Neon|Fly|Ride"] = 315.55, ["Mega"] = 98.18, ["Mega|Ride"] = 168.38, ["Mega|Fly|Ride"] = 821.85}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Ride"] = 15.01, ["Fly|Ride"] = 57.69, ["Neon"] = 9.71, ["Neon|Fly"] = 55.5, ["Neon|Ride"] = 32.45, ["Neon|Fly|Ride"] = 137.44, ["Mega"] = 315, ["Mega|Fly"] = 420}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 9.09, ["Fly"] = 21.26, ["Ride"] = 16.96, ["Fly|Ride"] = 27.57, ["Neon"] = 18.38, ["Neon|Fly"] = 84, ["Neon|Ride"] = 46.51, ["Neon|Fly|Ride"] = 65.5, ["Mega"] = 192.12, ["Mega|Fly"] = 192.12, ["Mega|Ride"] = 410.93, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 110.93, ["Fly|Ride"] = 72.19, ["Neon"] = 55.04, ["Mega"] = 215.92, ["Mega|Ride"] = 236.24}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 10.39, ["Ride"] = 56.44, ["Neon"] = 262.4, ["Neon|Ride"] = 232.47, ["Mega|Ride"] = 685.21}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 2.17, ["Ride"] = 39.38, ["Neon"] = 26.25, ["Neon|Ride"] = 125.71, ["Mega"] = 254.78, ["Mega|Ride"] = 306.48}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 5.18, ["Ride"] = 30.19, ["Fly|Ride"] = 120.75, ["Neon"] = 33.1, ["Neon|Ride"] = 64.57, ["Neon|Fly|Ride"] = 178.77, ["Mega"] = 464.94, ["Mega|Ride"] = 308.2, ["Mega|Fly|Ride"] = 290.35}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.89, ["Neon|Ride"] = 64.99, ["Mega"] = 16.7, ["Mega|Fly"] = 123.3, ["Mega|Ride"] = 123.3, ["Mega|Fly|Ride"] = 123.6}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 36.66}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 3.61, ["Fly"] = 19.69, ["Ride"] = 16.21, ["Fly|Ride"] = 35.19, ["Neon"] = 45.93, ["Neon|Fly"] = 188.48, ["Neon|Ride"] = 40.68, ["Neon|Fly|Ride"] = 78.62, ["Mega"] = 374.32, ["Mega|Ride"] = 208.68, ["Mega|Fly|Ride"] = 229.11}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 19.69, ["Fly|Ride"] = 37.01, ["Neon"] = 2.24, ["Neon|Fly"] = 31.39, ["Neon|Ride"] = 26.72, ["Neon|Fly|Ride"] = 153.45, ["Mega"] = 30.83, ["Mega|Fly"] = 137.68, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 90.96}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 47.28, ["Neon"] = 4.75, ["Neon|Ride"] = 33, ["Mega"] = 38.07, ["Mega|Ride"] = 69.93, ["Mega|Fly|Ride"] = 133.88}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 51.47, ["Ride"] = 16.46, ["Fly|Ride"] = 55.65, ["Neon"] = 3.94, ["Neon|Ride"] = 22.61, ["Neon|Fly|Ride"] = 116.24, ["Mega"] = 122.51, ["Mega|Ride"] = 155.76, ["Mega|Fly|Ride"] = 164.96}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 6.86, ["Ride"] = 36.66, ["Fly|Ride"] = 57.75, ["Neon"] = 28.87, ["Neon|Ride"] = 49.32, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 343.13, ["Mega|Ride"] = 275.45}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Fly"] = 82.21, ["Ride"] = 31.82, ["Neon"] = 2.51, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 60.38, ["Mega|Fly|Ride"] = 328.75}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.05, ["Fly"] = 27.57, ["Ride"] = 16.05, ["Fly|Ride"] = 32.82, ["Neon"] = 2.82, ["Neon|Fly"] = 109.1, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 25.51, ["Mega|Fly"] = 143.15, ["Mega|Ride"] = 45.94, ["Mega|Fly|Ride"] = 155.76}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 27.83, ["Ride"] = 13.13, ["Fly|Ride"] = 31.5, ["Neon"] = 3.82, ["Neon|Fly"] = 68.85, ["Neon|Ride"] = 18.15, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 47.95, ["Mega|Fly"] = 137.68, ["Mega|Ride"] = 56.44, ["Mega|Fly|Ride"] = 159.25}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.05, ["Fly"] = 27.76, ["Ride"] = 46.78, ["Fly|Ride"] = 118.13, ["Neon"] = 4.73, ["Neon|Ride"] = 27.29, ["Neon|Fly|Ride"] = 111.66, ["Mega"] = 29.7, ["Mega|Ride"] = 79.47, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 2.88, ["Neon|Ride"] = 164.38, ["Neon|Fly|Ride"] = 149706, ["Mega|Fly"] = 106.45, ["Mega|Ride"] = 80.07, ["Mega|Fly|Ride"] = 410.5}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.05, ["Fly"] = 45.87, ["Ride"] = 20.9, ["Fly|Ride"] = 45.94, ["Neon"] = 3.73, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 83.7, ["Mega"] = 17.61, ["Mega|Fly"] = 45.94, ["Mega|Ride"] = 40.61, ["Mega|Fly|Ride"] = 116.1}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.05, ["Neon"] = 2.1, ["Neon|Ride"] = 36.66, ["Mega|Ride"] = 167.25, ["Mega|Fly|Ride"] = 161.24}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.63, ["Neon"] = 6.24, ["Neon|Ride"] = 295.24, ["Neon|Fly|Ride"] = 420, ["Mega"] = 24.94, ["Mega|Ride"] = 155.76}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 10.5, ["Ride"] = 12.5, ["Fly|Ride"] = 41.11, ["Neon"] = 3.9, ["Neon|Fly"] = 32.81, ["Neon|Ride"] = 17, ["Neon|Fly|Ride"] = 136.5, ["Mega"] = 123.3, ["Mega|Fly"] = 82.21, ["Mega|Ride"] = 47.85, ["Mega|Fly|Ride"] = 65.63}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 11.82, ["Ride"] = 41.11, ["Neon"] = 513.65, ["Mega"] = 494.82, ["Mega|Ride"] = 665.44, ["Mega|Fly|Ride"] = 685.21}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 3.82, ["Fly"] = 6562.5, ["Ride"] = 82.21, ["Neon"] = 41.99, ["Mega"] = 105}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 6.2, ["Ride"] = 30.19, ["Fly|Ride"] = 410.93, ["Neon"] = 41.19, ["Neon|Fly|Ride"] = 260.95, ["Mega"] = 397.95, ["Mega|Ride"] = 351.35, ["Mega|Fly|Ride"] = 367.4}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.05, ["Fly"] = 12.95, ["Ride"] = 10.5, ["Fly|Ride"] = 22.82, ["Neon"] = 2.1, ["Neon|Fly"] = 13.02, ["Neon|Ride"] = 10.5, ["Neon|Fly|Ride"] = 20.94, ["Mega"] = 14.33, ["Mega|Fly"] = 22.81, ["Mega|Ride"] = 15.74, ["Mega|Fly|Ride"] = 39.38}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 5.25, ["Fly"] = 118.12, ["Ride"] = 65.63, ["Neon"] = 10.28, ["Neon|Fly"] = 67.76, ["Neon|Ride"] = 31.86, ["Neon|Fly|Ride"] = 685.21, ["Mega"] = 85.31, ["Mega|Ride"] = 118.02}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.05, ["Ride"] = 31.01, ["Neon"] = 2.1, ["Neon|Fly"] = 30.83, ["Neon|Ride"] = 22.14, ["Neon|Fly|Ride"] = 68.85, ["Mega"] = 13.82, ["Mega|Ride"] = 71.9, ["Mega|Fly|Ride"] = 130.48}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.05, ["Neon"] = 2.51, ["Neon|Fly"] = 60.89, ["Neon|Ride"] = 127.31, ["Mega"] = 18.2, ["Mega|Ride"] = 110.97, ["Mega|Fly|Ride"] = 165.01}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 41.49, ["Ride"] = 14.3, ["Fly|Ride"] = 44.63, ["Neon"] = 9.52, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 102.75, ["Mega"] = 208.95, ["Mega|Ride"] = 390.38, ["Mega|Fly|Ride"] = 381.25}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 178.35, ["Ride"] = 204.47, ["Fly|Ride"] = 236.25, ["Neon"] = 525, ["Neon|Ride"] = 757.32, ["Mega"] = 8218.31, ["Mega|Fly|Ride"] = 3558.54}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Ride"] = 17.46, ["Neon"] = 6.27, ["Neon|Ride"] = 82.21, ["Mega"] = 91.87, ["Mega|Ride"] = 163.36, ["Mega|Fly|Ride"] = 624.88}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 2.1, ["Fly"] = 64.97, ["Ride"] = 25.58, ["Fly|Ride"] = 56.72, ["Neon"] = 24.93, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 164.38, ["Mega"] = 360.94, ["Mega|Ride"] = 564.37, ["Mega|Fly|Ride"] = 406.82}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.05, ["Fly"] = 14.96, ["Ride"] = 11.9, ["Fly|Ride"] = 32.45, ["Neon"] = 7.11, ["Neon|Fly"] = 27.76, ["Neon|Ride"] = 29.34, ["Neon|Fly|Ride"] = 55.5, ["Mega"] = 49.68, ["Mega|Ride"] = 81.38, ["Mega|Fly|Ride"] = 433.12}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 51.19, ["Ride"] = 19.68, ["Fly|Ride"] = 92.56, ["Neon"] = 6.24, ["Neon|Ride"] = 69.21, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 69.57, ["Mega|Ride"] = 168.49}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 2.1, ["Fly"] = 23.05, ["Ride"] = 14.96, ["Fly|Ride"] = 52.48, ["Neon"] = 34.13, ["Neon|Fly"] = 98.85, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 135.97, ["Mega|Ride"] = 270.19, ["Mega|Fly|Ride"] = 219.86}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 3.93, ["Ride"] = 41.11, ["Fly|Ride"] = 248.62, ["Neon"] = 54.94, ["Neon|Fly|Ride"] = 610.22, ["Mega"] = 348.27, ["Mega|Ride"] = 335.55, ["Mega|Fly|Ride"] = 1027.3}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.19, ["Fly"] = 22.3, ["Ride"] = 14.17, ["Fly|Ride"] = 31.29, ["Neon"] = 19.48, ["Neon|Fly"] = 76.04, ["Neon|Ride"] = 28.29, ["Neon|Fly|Ride"] = 72.18, ["Mega"] = 138.97, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 66.44, ["Ride"] = 77.97, ["Fly|Ride"] = 148.31, ["Neon"] = 459.38, ["Neon|Fly"] = 437.07, ["Neon|Ride"] = 321.13, ["Neon|Fly|Ride"] = 406.88, ["Mega|Fly|Ride"] = 1417.5}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 223.11, ["Fly"] = 328.79, ["Ride"] = 224.93, ["Fly|Ride"] = 315, ["Neon|Ride"] = 2568.23, ["Neon|Fly|Ride"] = 973.88, ["Mega"] = 10272.89, ["Mega|Fly|Ride"] = 4657.73}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 56.43, ["Fly"] = 138.2, ["Ride"] = 67.83, ["Fly|Ride"] = 106.76, ["Neon"] = 697.41, ["Neon|Ride"] = 328.12, ["Neon|Fly|Ride"] = 343.13, ["Mega|Fly|Ride"] = 1232.95}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 2.57, ["Fly"] = 287.88, ["Ride"] = 32.82, ["Fly|Ride"] = 137.68, ["Neon"] = 26.17, ["Neon|Ride"] = 99.98, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 309.72, ["Mega|Ride"] = 392.44, ["Mega|Fly|Ride"] = 414.1}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 9.38, ["Fly"] = 68.85, ["Ride"] = 32.87, ["Fly|Ride"] = 59.04, ["Neon"] = 81.2, ["Neon|Ride"] = 126.26, ["Neon|Fly|Ride"] = 274.31, ["Mega"] = 312.36, ["Mega|Ride"] = 383.34, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.05, ["Fly"] = 18.69, ["Ride"] = 12.5, ["Fly|Ride"] = 44.51, ["Neon"] = 3.86, ["Neon|Ride"] = 19.92, ["Neon|Fly|Ride"] = 57.98, ["Mega"] = 49.7, ["Mega|Fly"] = 52.5, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 84.46}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 5.76, ["Fly"] = 72.12, ["Ride"] = 19.69, ["Fly|Ride"] = 81.38, ["Neon"] = 109.1, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 144.41, ["Mega"] = 413.44, ["Mega|Ride"] = 817.74, ["Mega|Fly|Ride"] = 732.38}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.05, ["Fly"] = 41.89, ["Ride"] = 14.44, ["Fly|Ride"] = 1312.5, ["Neon"] = 11.69, ["Neon|Fly"] = 96.58, ["Neon|Ride"] = 29.87, ["Neon|Fly|Ride"] = 92.59, ["Mega"] = 190.64, ["Mega|Ride"] = 211.18, ["Mega|Fly|Ride"] = 171.52}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 2.1, ["Ride"] = 15.65, ["Fly|Ride"] = 328.13, ["Neon"] = 19.68, ["Neon|Ride"] = 65.54, ["Mega"] = 207.38, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 369.85}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.05, ["Fly"] = 34.35, ["Ride"] = 131.25, ["Neon"] = 2.1, ["Neon|Ride"] = 19.65, ["Neon|Fly|Ride"] = 57.73, ["Mega"] = 15.65, ["Mega|Ride"] = 41.11, ["Mega|Fly|Ride"] = 209218.08}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 3.56, ["Fly"] = 18.1, ["Ride"] = 18.26, ["Fly|Ride"] = 41.11, ["Neon"] = 14.23, ["Neon|Fly"] = 36.75, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 147, ["Mega"] = 84, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 123.3}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 3.05, ["Fly"] = 24.94, ["Ride"] = 19.68, ["Fly|Ride"] = 61.01, ["Neon"] = 78.75, ["Neon|Ride"] = 47.25, ["Mega"] = 260.95, ["Mega|Ride"] = 195.2, ["Mega|Fly|Ride"] = 278.25}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 152.56, ["Fly"] = 410.99, ["Ride"] = 131.25, ["Fly|Ride"] = 229.69, ["Neon"] = 1050, ["Neon|Ride"] = 487.67, ["Neon|Fly|Ride"] = 542.29, ["Mega"] = 4109.17, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 5.65, ["Ride"] = 31.86, ["Fly|Ride"] = 124.4, ["Neon"] = 41.66, ["Neon|Ride"] = 85.31, ["Neon|Fly|Ride"] = 376.56, ["Mega"] = 417.38, ["Mega|Ride"] = 537.68, ["Mega|Fly|Ride"] = 393.74}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 34.04, ["Ride"] = 15.3, ["Fly|Ride"] = 45.35, ["Neon"] = 18.38, ["Neon|Ride"] = 26.81, ["Neon|Fly|Ride"] = 120.74, ["Mega"] = 310.25, ["Mega|Ride"] = 244.83, ["Mega|Fly|Ride"] = 308.44}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 19.37, ["Ride"] = 41.32, ["Fly|Ride"] = 170.63, ["Neon"] = 84.96, ["Neon|Ride"] = 215.25, ["Neon|Fly|Ride"] = 513.14, ["Mega"] = 551.25, ["Mega|Fly"] = 821.85, ["Mega|Ride"] = 563.07, ["Mega|Fly|Ride"] = 613.72}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 3.94}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 2.1, ["Ride"] = 28.5, ["Fly|Ride"] = 115.12, ["Neon"] = 40.3, ["Neon|Ride"] = 274.31, ["Neon|Fly|Ride"] = 343.13, ["Mega"] = 565.02, ["Mega|Ride"] = 565.69, ["Mega|Fly|Ride"] = 897.87}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 23.24, ["Fly"] = 31.96, ["Ride"] = 29.84, ["Fly|Ride"] = 58.97, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 155.76, ["Neon|Fly|Ride"] = 168.87, ["Mega"] = 2054.59, ["Mega|Fly|Ride"] = 670.73}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.05, ["Fly"] = 26.25, ["Ride"] = 18.66, ["Neon"] = 2.1, ["Neon|Fly"] = 65.62, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 106.26, ["Mega|Fly"] = 274.31, ["Mega|Ride"] = 61.67, ["Mega|Fly|Ride"] = 227.75}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 6.19, ["Fly"] = 27.77, ["Ride"] = 23.64, ["Fly|Ride"] = 61.65, ["Neon"] = 13.13, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 232.47, ["Mega"] = 233.21, ["Mega|Fly"] = 388.23, ["Mega|Ride"] = 203.41, ["Mega|Fly|Ride"] = 363.67}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 19.53, ["Fly|Ride"] = 40.69, ["Neon"] = 8.6, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 34.9, ["Neon|Fly|Ride"] = 64.37, ["Mega"] = 182.88, ["Mega|Ride"] = 138.21, ["Mega|Fly|Ride"] = 231.53}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.05, ["Ride"] = 26.25, ["Fly|Ride"] = 206.07, ["Neon"] = 3.78, ["Neon|Ride"] = 23.15, ["Neon|Fly|Ride"] = 205.48, ["Mega"] = 24.86, ["Mega|Ride"] = 53.29, ["Mega|Fly|Ride"] = 310.36}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 29.8, ["Ride"] = 87.94, ["Fly|Ride"] = 178.78, ["Neon"] = 170.63, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 576.19, ["Mega"] = 799.99, ["Mega|Ride"] = 956.42, ["Mega|Fly|Ride"] = 934.33}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.34, ["Ride"] = 65.63, ["Fly|Ride"] = 210, ["Neon"] = 92.25, ["Neon|Ride"] = 137.68, ["Mega|Ride"] = 524.99}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 3.97, ["Fly"] = 210, ["Ride"] = 18.17, ["Fly|Ride"] = 67.77, ["Neon"] = 17.9, ["Neon|Fly"] = 315, ["Neon|Ride"] = 38.72, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 173.92, ["Mega|Ride"] = 179.43, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 61.79, ["Fly"] = 433.12, ["Ride"] = 393.73, ["Fly|Ride"] = 262.45, ["Neon"] = 328.13, ["Neon|Ride"] = 534.2, ["Mega|Ride"] = 2165.63, ["Mega|Fly|Ride"] = 1788.22}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 4.56, ["Fly"] = 32.69, ["Ride"] = 19.69, ["Fly|Ride"] = 94.5, ["Neon"] = 31.06, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 52.92, ["Neon|Fly|Ride"] = 205.48, ["Mega"] = 509.24, ["Mega|Ride"] = 278.98, ["Mega|Fly|Ride"] = 638.72}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 63, ["Fly"] = 152.07, ["Ride"] = 84, ["Fly|Ride"] = 154.11, ["Neon"] = 262.5, ["Neon|Ride"] = 219.69, ["Neon|Fly|Ride"] = 349.25, ["Mega"] = 1096.13, ["Mega|Ride"] = 1101.53, ["Mega|Fly|Ride"] = 1020.17}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 16.82, ["Ride"] = 52.49, ["Fly|Ride"] = 202.29, ["Neon"] = 71.36, ["Neon|Ride"] = 108.59, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 590.63, ["Mega|Ride"] = 313.94, ["Mega|Fly|Ride"] = 439.04}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 3.13, ["Fly"] = 104.13, ["Ride"] = 27.74, ["Fly|Ride"] = 61.66, ["Neon"] = 136.83, ["Neon|Ride"] = 90.09, ["Neon|Fly|Ride"] = 369.64, ["Mega"] = 416.96, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 13.5, ["Ride"] = 38.66, ["Neon"] = 64.34, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 274.31, ["Mega"] = 283.82, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 392.44}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 5.36, ["Ride"] = 19.48, ["Fly|Ride"] = 65.19, ["Neon"] = 31.16, ["Neon|Ride"] = 56.59, ["Neon|Fly|Ride"] = 141.16, ["Mega"] = 236.25, ["Mega|Ride"] = 318.48, ["Mega|Fly|Ride"] = 411.98}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.05, ["Neon"] = 2.1, ["Neon|Ride"] = 91.6, ["Mega|Ride"] = 123.3, ["Mega|Fly|Ride"] = 405.79}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 3.29, ["Ride"] = 27.57, ["Neon"] = 22.46, ["Neon|Fly"] = 123.3, ["Neon|Ride"] = 157.49, ["Neon|Fly|Ride"] = 202.78, ["Mega"] = 179.07, ["Mega|Ride"] = 205.48, ["Mega|Fly|Ride"] = 467.27}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Fly"] = 68.85, ["Neon"] = 25.73, ["Mega"] = 347.17, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 3.14, ["Ride"] = 32.79, ["Fly|Ride"] = 116.24, ["Neon"] = 20.56, ["Neon|Ride"] = 82.95, ["Mega"] = 123.44, ["Mega|Ride"] = 274.31, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 569.04, ["Ride"] = 616.88, ["Fly|Ride"] = 678, ["Neon|Ride"] = 1802.07, ["Neon|Fly|Ride"] = 1713.54, ["Mega|Fly|Ride"] = 5880}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 6.66, ["Ride"] = 19.18, ["Fly|Ride"] = 62.78, ["Neon"] = 40.07, ["Neon|Ride"] = 96.58, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 155.76, ["Mega|Ride"] = 355.69, ["Mega|Fly|Ride"] = 466.4}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 5.44, ["Fly"] = 524.69, ["Ride"] = 31.13, ["Fly|Ride"] = 51.35, ["Neon"] = 39.35, ["Neon|Fly"] = 315, ["Neon|Ride"] = 88.36, ["Neon|Fly|Ride"] = 156.4, ["Mega"] = 330.75, ["Mega|Ride"] = 381.14, ["Mega|Fly|Ride"] = 381.14}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 2.1, ["Fly"] = 15.43, ["Ride"] = 26.55, ["Fly|Ride"] = 308.23, ["Neon"] = 13.12, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 263.86, ["Mega|Ride"] = 274.31}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.05, ["Fly"] = 65.58, ["Ride"] = 21, ["Fly|Ride"] = 90.57, ["Neon"] = 7.42, ["Neon|Ride"] = 29.8, ["Neon|Fly|Ride"] = 128.13, ["Mega|Fly"] = 211.78, ["Mega|Ride"] = 112.88, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.05, ["Fly"] = 68.85, ["Ride"] = 19.69, ["Neon"] = 2.1, ["Neon|Ride"] = 23.6, ["Neon|Fly|Ride"] = 118.12, ["Mega|Ride"] = 62.91, ["Mega|Fly|Ride"] = 217.81}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1050}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 6.7, ["Ride"] = 39.37, ["Fly|Ride"] = 52.5, ["Neon"] = 65.63, ["Neon|Ride"] = 104.79, ["Mega"] = 548.59, ["Mega|Ride"] = 548.59, ["Mega|Fly|Ride"] = 846.5}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.05, ["Ride"] = 25.58, ["Neon"] = 4.09, ["Neon|Ride"] = 73.98, ["Neon|Fly|Ride"] = 982.1, ["Mega"] = 39.16, ["Mega|Ride"] = 141.85, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.1, ["Fly"] = 41.11, ["Ride"] = 96.95, ["Fly|Ride"] = 410.99, ["Neon"] = 15.75, ["Neon|Ride"] = 137.68, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 183.74, ["Mega|Ride"] = 364.98, ["Mega|Fly|Ride"] = 1027.3}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 420, ["Ride"] = 433.06, ["Fly|Ride"] = 543.38, ["Neon|Ride"] = 2103.8, ["Neon|Fly|Ride"] = 1653.75, ["Mega"] = 8524.49, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 3.94, ["Fly"] = 196.88, ["Ride"] = 59.07, ["Fly|Ride"] = 410.93, ["Neon"] = 68.85, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 185.99, ["Mega"] = 299.99, ["Mega|Ride"] = 464.94, ["Mega|Fly|Ride"] = 667.19}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.05, ["Fly"] = 19.49, ["Ride"] = 24.94, ["Fly|Ride"] = 118.13, ["Neon"] = 3.4, ["Neon|Ride"] = 32, ["Neon|Fly|Ride"] = 108.91, ["Mega|Ride"] = 70.1, ["Mega|Fly|Ride"] = 175.3}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.05, ["Neon"] = 3.5, ["Neon|Ride"] = 28.28, ["Mega|Ride"] = 134.78, ["Mega|Fly|Ride"] = 374.07}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 15.06, ["Fly"] = 107.63, ["Ride"] = 69.02, ["Neon"] = 127.45, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 466.4, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 595.88}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 7.92, ["Ride"] = 71.31, ["Neon"] = 96.48, ["Neon|Ride"] = 155.76, ["Neon|Fly|Ride"] = 821.85, ["Mega"] = 393.75, ["Mega|Ride"] = 478.42, ["Mega|Fly|Ride"] = 554.75}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 6.46, ["Ride"] = 31.39, ["Fly|Ride"] = 131.25, ["Neon"] = 310.36, ["Neon|Ride"] = 175.53, ["Mega"] = 635.81, ["Mega|Ride"] = 1055.03, ["Mega|Fly|Ride"] = 1232.76}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 11.23, ["Ride"] = 23.15, ["Fly|Ride"] = 262.5, ["Neon"] = 167.37, ["Neon|Ride"] = 182.44, ["Neon|Fly|Ride"] = 199.31, ["Mega"] = 610.32, ["Mega|Ride"] = 649.04, ["Mega|Fly|Ride"] = 665.44}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 347.82, ["Ride"] = 478.79, ["Fly|Ride"] = 748.64, ["Neon"] = 918.75, ["Neon|Ride"] = 959.51, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Ride"] = 3561.63, ["Mega|Fly|Ride"] = 3698.25}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 5.2, ["Fly"] = 19.69, ["Ride"] = 19.69, ["Fly|Ride"] = 236.25, ["Neon"] = 64.32, ["Neon|Ride"] = 204.45, ["Neon|Fly|Ride"] = 207.34, ["Mega|Ride"] = 548.59, ["Mega|Fly|Ride"] = 848.55}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 3.63, ["Ride"] = 20.93, ["Neon"] = 41.11, ["Neon|Ride"] = 52.5, ["Mega"] = 217.81, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 1027.3}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 17.63, ["Ride"] = 70.86, ["Fly|Ride"] = 256.92, ["Neon"] = 79.71, ["Neon|Ride"] = 124.47, ["Neon|Fly|Ride"] = 260.78, ["Mega|Fly"] = 685.21, ["Mega|Ride"] = 314.99, ["Mega|Fly|Ride"] = 334.69}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.63, ["Ride"] = 78.1, ["Fly|Ride"] = 137.69, ["Neon"] = 6.47, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 236.3, ["Mega"] = 39.29, ["Mega|Ride"] = 65.62, ["Mega|Fly|Ride"] = 295.32}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 37.94, ["Ride"] = 72.93, ["Neon"] = 318.48, ["Neon|Ride"] = 406.88, ["Mega"] = 1627.27, ["Mega|Ride"] = 1370.41, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 581.25, ["Ride"] = 25.19, ["Neon"] = 6.57, ["Neon|Fly"] = 178.77, ["Neon|Ride"] = 96.58, ["Neon|Fly|Ride"] = 112.01, ["Mega|Ride"] = 98.17, ["Mega|Fly|Ride"] = 200.79}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 89.4, ["Ride"] = 30.19, ["Fly|Ride"] = 155.93, ["Neon"] = 4.85, ["Neon|Fly"] = 49.38, ["Neon|Ride"] = 46.76, ["Neon|Fly|Ride"] = 137.68, ["Mega|Fly"] = 112.88, ["Mega|Ride"] = 73.41, ["Mega|Fly|Ride"] = 170.36}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.05, ["Ride"] = 37.97, ["Fly|Ride"] = 262.4, ["Neon"] = 13.82, ["Neon|Ride"] = 59.53, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 81.81, ["Mega|Fly"] = 459.38, ["Mega|Ride"] = 120.65, ["Mega|Fly|Ride"] = 1507.04}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 47.25, ["Fly"] = 93.01, ["Ride"] = 60.25, ["Neon"] = 288.46, ["Neon|Ride"] = 300.38, ["Neon|Fly|Ride"] = 412.56, ["Mega|Fly|Ride"] = 1037.58}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 157.5, ["Ride"] = 274.34, ["Fly|Ride"] = 409.96, ["Neon"] = 1427.95, ["Neon|Ride"] = 1134.45, ["Neon|Fly|Ride"] = 1278.57, ["Mega"] = 3937.5, ["Mega|Fly|Ride"] = 4365.9}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 5.25, ["Neon"] = 24.23, ["Neon|Fly"] = 350.44, ["Neon|Ride"] = 54.65, ["Mega|Fly"] = 227.05, ["Mega|Ride"] = 311.36}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 8.14, ["Neon|Ride"] = 45.85, ["Neon|Fly|Ride"] = 139.13, ["Mega"] = 56.44, ["Mega|Fly"] = 210, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 241.5}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 2.96, ["Fly"] = 155.57, ["Ride"] = 27.56, ["Neon"] = 32.8, ["Neon|Ride"] = 68.85, ["Mega"] = 132.76, ["Mega|Ride"] = 348.23}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 69.29, ["Ride"] = 33.14, ["Neon"] = 6.45, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 152.06, ["Mega"] = 122.99, ["Mega|Ride"] = 130.36, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 90.77, ["Neon"] = 7.87, ["Neon|Fly|Ride"] = 188.01, ["Mega"] = 33.33, ["Mega|Fly"] = 140.3, ["Mega|Fly|Ride"] = 271.21}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 23.64, ["Ride"] = 16.89, ["Fly|Ride"] = 49.88, ["Neon"] = 4.08, ["Neon|Fly"] = 77.89, ["Neon|Ride"] = 27.76, ["Neon|Fly|Ride"] = 410.93, ["Mega|Ride"] = 95.72, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.33, ["Fly"] = 137.61, ["Ride"] = 18.51, ["Fly|Ride"] = 61.65, ["Neon"] = 17.67, ["Neon|Fly"] = 64.97, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 93, ["Mega"] = 156.15, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 436.96}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 27.62, ["Ride"] = 31.05, ["Fly|Ride"] = 78.73, ["Neon"] = 137.68, ["Neon|Fly|Ride"] = 155.76, ["Mega"] = 508.52, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 532.65}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 62.78, ["Ride"] = 77.86, ["Fly|Ride"] = 124.52, ["Neon"] = 406.82, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 456.53, ["Mega"] = 3346.14, ["Mega|Ride"] = 1643.67, ["Mega|Fly|Ride"] = 1502.82}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 17.87, ["Fly|Ride"] = 131.25, ["Neon"] = 3.78, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 128.47, ["Mega"] = 35.38, ["Mega|Fly"] = 672, ["Mega|Ride"] = 78.75}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.05, ["Fly"] = 12.35, ["Ride"] = 13.73, ["Fly|Ride"] = 39.36, ["Neon"] = 5.15, ["Neon|Fly"] = 28.37, ["Neon|Ride"] = 23.75, ["Neon|Fly|Ride"] = 61.68, ["Mega"] = 61.69, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 65.62, ["Mega|Fly|Ride"] = 129.94}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 3.81, ["Ride"] = 73.48, ["Neon"] = 35.65, ["Neon|Ride"] = 124.68, ["Neon|Fly|Ride"] = 274.31, ["Mega"] = 527.63, ["Mega|Ride"] = 479.76, ["Mega|Fly|Ride"] = 620.7}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 388.63, ["Fly"] = 518.44, ["Ride"] = 472.5, ["Fly|Ride"] = 525, ["Mega|Fly|Ride"] = 6163.75}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 15.65, ["Fly"] = 101.33, ["Ride"] = 43.47, ["Fly|Ride"] = 99.38, ["Neon"] = 231.52, ["Neon|Ride"] = 210.74, ["Neon|Fly|Ride"] = 305.8, ["Mega|Ride"] = 1132.11, ["Mega|Fly|Ride"] = 914.76}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.05, ["Ride"] = 25.85, ["Fly|Ride"] = 281.29, ["Neon"] = 8.27, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 108.91, ["Mega"] = 82.69, ["Mega|Ride"] = 126.99, ["Mega|Fly|Ride"] = 282.52}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 91.88, ["Ride"] = 65.61, ["Fly|Ride"] = 142.94, ["Neon"] = 11.87, ["Mega"] = 328.13}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 31.35, ["Fly"] = 167.6, ["Ride"] = 44.6, ["Fly|Ride"] = 89.4, ["Neon"] = 194.25, ["Neon|Ride"] = 464.94, ["Neon|Fly|Ride"] = 264.99, ["Mega"] = 2465.51, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1191.67}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 77.58, ["Ride"] = 107.85, ["Fly|Ride"] = 410.93, ["Neon"] = 434.43, ["Neon|Ride"] = 548.59, ["Neon|Fly|Ride"] = 610.22, ["Mega"] = 8218.31, ["Mega|Fly|Ride"] = 2192.25}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 174.12, ["Ride"] = 248.69, ["Fly|Ride"] = 821.94, ["Neon"] = 1050, ["Neon|Ride"] = 1365, ["Neon|Fly|Ride"] = 1232.76, ["Mega|Fly|Ride"] = 3411.64}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 6.57, ["Fly"] = 51.19, ["Ride"] = 53.82, ["Fly|Ride"] = 150.94, ["Neon"] = 76.13, ["Neon|Ride"] = 95.82, ["Neon|Fly|Ride"] = 232.47, ["Mega"] = 388.23, ["Mega|Ride"] = 321.79, ["Mega|Fly|Ride"] = 380.37}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 17.3, ["Ride"] = 13.79, ["Fly|Ride"] = 41.91, ["Neon"] = 4.99, ["Neon|Ride"] = 21.54, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 84.28, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 170.24}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 4.27, ["Fly"] = 38.63, ["Ride"] = 15.65, ["Fly|Ride"] = 48.92, ["Neon"] = 31.11, ["Neon|Fly"] = 105, ["Neon|Ride"] = 47.69, ["Neon|Fly|Ride"] = 90.57, ["Mega|Ride"] = 420.77, ["Mega|Fly|Ride"] = 291.08}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 334.69, ["Fly"] = 479.82, ["Ride"] = 326.29, ["Fly|Ride"] = 420, ["Neon"] = 1575, ["Neon|Ride"] = 2150.35, ["Mega"] = 9861.97, ["Mega|Fly|Ride"] = 5687.07}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Neon"] = 5.97, ["Neon|Fly|Ride"] = 118125, ["Mega|Ride"] = 170.99, ["Mega|Fly|Ride"] = 447.99}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 3.89, ["Fly"] = 10.49, ["Ride"] = 13.13, ["Fly|Ride"] = 51.19, ["Neon"] = 20.84, ["Neon|Ride"] = 37.7, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 223.97, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 152.06, ["Mega|Fly|Ride"] = 410.93}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 13.06, ["Ride"] = 46.18, ["Neon"] = 104.81, ["Neon|Ride"] = 236.04, ["Neon|Fly|Ride"] = 295.24, ["Mega"] = 493.19, ["Mega|Ride"] = 649.67, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 108.14, ["Fly"] = 157.5, ["Ride"] = 102, ["Fly|Ride"] = 155.79, ["Neon"] = 635.91, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 586.34, ["Mega|Fly|Ride"] = 2378.25}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 18.27, ["Fly"] = 42.95, ["Ride"] = 22.75, ["Fly|Ride"] = 54.65, ["Neon"] = 104.24, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 152.59, ["Mega"] = 685.21, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 445.11}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.05, ["Ride"] = 20.65, ["Neon"] = 2.52, ["Neon|Ride"] = 137.68, ["Mega"] = 22.87, ["Mega|Ride"] = 274.31}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Fly"] = 39.37, ["Ride"] = 15.54, ["Fly|Ride"] = 70.17, ["Neon"] = 2.63, ["Neon|Ride"] = 19.73, ["Neon|Fly|Ride"] = 74.46, ["Mega|Fly"] = 87.64, ["Mega|Ride"] = 37.49, ["Mega|Fly|Ride"] = 112.27}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 8.81, ["Ride"] = 52.41, ["Fly|Ride"] = 126.87, ["Neon"] = 26.91, ["Neon|Fly"] = 144.38, ["Neon|Ride"] = 64.22, ["Neon|Fly|Ride"] = 181.22, ["Mega|Fly"] = 291.77, ["Mega|Ride"] = 186.35, ["Mega|Fly|Ride"] = 279.68}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1168.12, ["Fly"] = 1604.23, ["Ride"] = 1298.08, ["Fly|Ride"] = 1157.63, ["Neon"] = 4200, ["Neon|Ride"] = 3701.25, ["Neon|Fly|Ride"] = 3701.25, ["Mega|Fly|Ride"] = 12399.18}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 443.63, ["Fly"] = 918.75, ["Ride"] = 449.91, ["Fly|Ride"] = 509.15, ["Neon"] = 2412.09, ["Neon|Ride"] = 2562.07, ["Neon|Fly|Ride"] = 2362.5, ["Mega"] = 16436.62, ["Mega|Fly|Ride"] = 9314.44}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 273.66, ["Fly"] = 409.96, ["Ride"] = 385.21, ["Fly|Ride"] = 406.88, ["Neon"] = 871.76, ["Neon|Ride"] = 721.77, ["Neon|Fly|Ride"] = 774.38, ["Mega|Fly|Ride"] = 2916.23}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 235.31, ["Fly"] = 548.66, ["Ride"] = 313.67, ["Fly|Ride"] = 459.38, ["Neon"] = 2054.59, ["Neon|Fly"] = 2054.59, ["Neon|Ride"] = 890.68, ["Neon|Fly|Ride"] = 1240.21}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 64.31, ["Ride"] = 15.63, ["Fly|Ride"] = 37.68, ["Neon"] = 6.4, ["Neon|Ride"] = 27.91, ["Neon|Fly|Ride"] = 105, ["Mega"] = 57.66, ["Mega|Ride"] = 139.13, ["Mega|Fly|Ride"] = 200.82}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 269.53, ["Fly"] = 1370.58, ["Ride"] = 479.82, ["Fly|Ride"] = 754.15, ["Neon"] = 1706.24, ["Neon|Ride"] = 1109.58, ["Neon|Fly|Ride"] = 1101.6, ["Mega|Ride"] = 6574.65, ["Mega|Fly|Ride"] = 4331.25}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 3.4, ["Fly"] = 157.5, ["Ride"] = 110.27, ["Fly|Ride"] = 112.54, ["Neon"] = 16.95, ["Neon|Ride"] = 68.85, ["Mega"] = 98.34, ["Mega|Ride"] = 202.34, ["Mega|Fly|Ride"] = 498.74}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 39.37, ["Ride"] = 15.05, ["Fly|Ride"] = 31.97, ["Neon"] = 7.85, ["Neon|Ride"] = 27.72, ["Neon|Fly|Ride"] = 137.68, ["Mega"] = 104.9, ["Mega|Ride"] = 192.93}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.05, ["Fly"] = 54.35, ["Neon"] = 2.1, ["Neon|Ride"] = 39.37, ["Mega"] = 29.47, ["Mega|Ride"] = 196.77}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 31.66, ["Fly|Ride"] = 459.37, ["Neon"] = 244.13, ["Neon|Ride"] = 351.29, ["Mega"] = 1050, ["Mega|Ride"] = 488.25, ["Mega|Fly|Ride"] = 773.07}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.52, ["Fly"] = 41.11, ["Ride"] = 26.71, ["Fly|Ride"] = 68.24, ["Neon"] = 32.82, ["Mega|Ride"] = 423.1, ["Mega|Fly|Ride"] = 410.93}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.13, ["Neon"] = 2.1, ["Neon|Ride"] = 40.32, ["Neon|Fly|Ride"] = 86.64, ["Mega"] = 21.63, ["Mega|Ride"] = 155.76, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.1, ["Fly"] = 34.13, ["Ride"] = 16.3, ["Fly|Ride"] = 78.65, ["Neon"] = 10.24, ["Neon|Fly"] = 96.58, ["Neon|Ride"] = 44.01, ["Neon|Fly|Ride"] = 75.47, ["Mega"] = 76.57, ["Mega|Fly"] = 278.98, ["Mega|Ride"] = 128.63, ["Mega|Fly|Ride"] = 194.9}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 4.2, ["Fly"] = 91.88, ["Ride"] = 19.23, ["Fly|Ride"] = 51.98, ["Neon"] = 27.57, ["Neon|Fly"] = 137.68, ["Neon|Ride"] = 137.68, ["Neon|Fly|Ride"] = 131.23, ["Mega"] = 237.57, ["Mega|Ride"] = 300.51, ["Mega|Fly|Ride"] = 326.7}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 8.21, ["Ride"] = 39.38, ["Neon"] = 65.63, ["Mega"] = 504.47, ["Mega|Ride"] = 413.44, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.1, ["Fly"] = 6200.62, ["Ride"] = 27.76, ["Fly|Ride"] = 42.83, ["Neon"] = 49.88, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 314.97, ["Neon|Fly|Ride"] = 697.41, ["Mega"] = 439.69, ["Mega|Ride"] = 479.76, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 64.05, ["Ride"] = 18.16, ["Fly|Ride"] = 45.94, ["Neon"] = 3.84, ["Neon|Fly"] = 82.48, ["Neon|Ride"] = 24.66, ["Neon|Fly|Ride"] = 55.5, ["Mega"] = 59.6, ["Mega|Ride"] = 175.53, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 154.88, ["Ride"] = 178.5, ["Fly|Ride"] = 262.49, ["Neon|Ride"] = 821.85, ["Neon|Fly|Ride"] = 1036.87, ["Mega"] = 8218.31, ["Mega|Ride"] = 4109.17, ["Mega|Fly|Ride"] = 4657.73}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.05, ["Fly"] = 18.33, ["Ride"] = 13.53, ["Fly|Ride"] = 41.11, ["Neon"] = 2.62, ["Neon|Ride"] = 19.81, ["Neon|Fly|Ride"] = 55.12, ["Mega"] = 40.07, ["Mega|Ride"] = 44.63, ["Mega|Fly|Ride"] = 137.68}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 5.78, ["Fly"] = 137.69, ["Ride"] = 68.85, ["Fly|Ride"] = 183.75, ["Neon"] = 110.97, ["Neon|Ride"] = 133.84, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 312.38, ["Mega|Fly"] = 775.28, ["Mega|Ride"] = 331.73, ["Mega|Fly|Ride"] = 1027.3}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 30.38, ["Ride"] = 93.01, ["Fly|Ride"] = 170.63, ["Neon"] = 189.58, ["Neon|Ride"] = 274.31, ["Mega"] = 959.51, ["Mega|Ride"] = 815.69, ["Mega|Fly|Ride"] = 1156.53}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 174.12, ["Ride"] = 217.32, ["Fly|Ride"] = 248.75, ["Neon"] = 708.74, ["Neon|Ride"] = 811.57, ["Neon|Fly|Ride"] = 837.3}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 16.3, ["Fly|Ride"] = 137.68, ["Neon"] = 91.87, ["Mega"] = 284.57, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 695.63}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 7.2, ["Ride"] = 102.34, ["Fly|Ride"] = 178.77, ["Neon"] = 1438.21, ["Neon|Ride"] = 199.5, ["Neon|Fly|Ride"] = 217.38, ["Mega"] = 771.75, ["Mega|Ride"] = 1643.67, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 1181.25, ["Ride"] = 1168.13, ["Fly|Ride"] = 1251.04, ["Neon"] = 4657.73, ["Neon|Ride"] = 4790.63, ["Neon|Fly|Ride"] = 4622.82, ["Mega|Fly|Ride"] = 18034.06}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 8.7, ["Fly"] = 19.68, ["Ride"] = 19.55, ["Fly|Ride"] = 52.5, ["Neon"] = 15.75, ["Neon|Fly"] = 92.99, ["Neon|Ride"] = 91.87, ["Neon|Fly|Ride"] = 205.48, ["Mega"] = 232.47, ["Mega|Fly|Ride"] = 347.82}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 4.41, ["Fly"] = 51.19, ["Ride"] = 19.69, ["Fly|Ride"] = 135.19, ["Neon"] = 32.97, ["Mega"] = 244.62, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 248.36}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.05, ["Fly"] = 81.18, ["Ride"] = 15.42, ["Fly|Ride"] = 89.4, ["Neon"] = 9.19, ["Neon|Ride"] = 47.15, ["Mega"] = 105, ["Mega|Ride"] = 238.21, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 13.11, ["Ride"] = 30.18, ["Fly|Ride"] = 81.09, ["Neon"] = 66.94, ["Neon|Ride"] = 90.03, ["Neon|Fly|Ride"] = 141.54, ["Mega"] = 437.07, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 591.95}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 3.56, ["Fly"] = 20.45, ["Ride"] = 18.38, ["Fly|Ride"] = 51.19, ["Neon"] = 16.96, ["Neon|Fly"] = 42.73, ["Neon|Ride"] = 31.86, ["Neon|Fly|Ride"] = 93.19, ["Mega|Fly"] = 280.98, ["Mega|Ride"] = 124.38, ["Mega|Fly|Ride"] = 410.93}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.83, ["Ride"] = 102.76, ["Neon"] = 12.32, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 56.25, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 123.3, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 341.08}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 175.88, ["Ride"] = 412.55, ["Fly|Ride"] = 343.13, ["Neon|Ride"] = 1232.76, ["Neon|Fly|Ride"] = 984.38}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 22.7, ["Fly|Ride"] = 106.86, ["Neon"] = 7.07, ["Neon|Ride"] = 31.01, ["Neon|Fly|Ride"] = 119.84, ["Mega"] = 77.89, ["Mega|Fly"] = 410.93, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 266.09}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 2.63, ["Ride"] = 81.79, ["Fly|Ride"] = 88.86, ["Neon"] = 31.5, ["Neon|Ride"] = 188.27, ["Mega"] = 124.69, ["Mega|Ride"] = 237.57}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 2.1, ["Fly"] = 96.59, ["Ride"] = 26.25, ["Neon"] = 14.44, ["Neon|Ride"] = 52.5, ["Mega"] = 86.3, ["Mega|Ride"] = 111.28, ["Mega|Fly|Ride"] = 482.39}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 176.35, ["Ride"] = 208.18, ["Fly|Ride"] = 821.94, ["Neon|Ride"] = 1458.09, ["Neon|Fly|Ride"] = 1162.33, ["Mega|Ride"] = 4930.99, ["Mega|Fly|Ride"] = 3018.75}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 25.64, ["Ride"] = 57.54, ["Fly|Ride"] = 225.8, ["Neon"] = 149.5, ["Neon|Fly|Ride"] = 374.07, ["Mega"] = 498.75, ["Mega|Fly|Ride"] = 859.69}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 16.49, ["Fly"] = 74.42, ["Ride"] = 30.96, ["Fly|Ride"] = 90.57, ["Neon"] = 88.05, ["Neon|Ride"] = 108.39, ["Neon|Fly|Ride"] = 192.12, ["Mega"] = 548.03, ["Mega|Ride"] = 412.13, ["Mega|Fly|Ride"] = 540.11}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.05, ["Neon"] = 4.03, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 210, ["Mega"] = 52.5, ["Mega|Ride"] = 275.33}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 43.79, ["Fly"] = 79.15, ["Ride"] = 105, ["Fly|Ride"] = 149.69, ["Neon"] = 262.48, ["Neon|Fly"] = 258.79, ["Neon|Ride"] = 355.46, ["Neon|Fly|Ride"] = 304.78, ["Mega|Fly|Ride"] = 1119.76}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 19.45, ["Fly|Ride"] = 40.08, ["Neon"] = 5, ["Neon|Ride"] = 55.5, ["Neon|Fly|Ride"] = 122.26, ["Mega"] = 56.44, ["Mega|Fly|Ride"] = 410.93}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 18.09, ["Fly"] = 137.69, ["Ride"] = 28.6, ["Neon"] = 66.2, ["Neon|Ride"] = 143.57, ["Neon|Fly|Ride"] = 246.57, ["Mega"] = 389.82, ["Mega|Ride"] = 588.41, ["Mega|Fly|Ride"] = 392.89}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 37.67, ["Fly"] = 78.75, ["Ride"] = 75.48, ["Fly|Ride"] = 192.14, ["Neon"] = 271.21, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 356.85, ["Mega|Ride"] = 1919, ["Mega|Fly|Ride"] = 1174.05}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.05, ["Fly"] = 15.65, ["Ride"] = 13.85, ["Fly|Ride"] = 31.19, ["Neon"] = 2.1, ["Neon|Fly"] = 23.64, ["Neon|Ride"] = 15.43, ["Neon|Fly|Ride"] = 32.22, ["Mega"] = 16.94, ["Mega|Fly"] = 118.56, ["Mega|Ride"] = 28.77, ["Mega|Fly|Ride"] = 80.99}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 2.1, ["Ride"] = 52.49, ["Fly|Ride"] = 129.45, ["Neon"] = 15.53, ["Neon|Ride"] = 60.62, ["Neon|Fly|Ride"] = 410.93, ["Mega"] = 226.99, ["Mega|Ride"] = 272, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 14.43, ["Ride"] = 48.64, ["Neon|Ride"] = 548.59, ["Mega"] = 536.82, ["Mega|Ride"] = 410.93, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.05, ["Ride"] = 26.73, ["Neon"] = 2.1, ["Neon|Ride"] = 28.86, ["Mega"] = 15.72, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 153.64}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 14.21, ["Fly"] = 187.6, ["Ride"] = 82.21, ["Fly|Ride"] = 164.06, ["Neon"] = 107.52, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 388.23, ["Mega"] = 525.98, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 419.79, ["Mega|Fly|Ride"] = 556.69}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 11.82, ["Fly"] = 103.69, ["Ride"] = 28.88, ["Fly|Ride"] = 98.44, ["Neon"] = 388.52, ["Neon|Ride"] = 64.97, ["Neon|Fly|Ride"] = 172.05, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 3.72, ["Ride"] = 18.12, ["Neon"] = 30.49, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 77.43, ["Neon|Fly|Ride"] = 130.19, ["Mega"] = 231, ["Mega|Ride"] = 235.01, ["Mega|Fly|Ride"] = 405.79}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 7.28, ["Fly"] = 2054.84, ["Ride"] = 78.05, ["Fly|Ride"] = 216.57, ["Neon"] = 69.57, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 6198.69, ["Mega"] = 466.4, ["Mega|Ride"] = 442.32, ["Mega|Fly|Ride"] = 923.54}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.52, ["Ride"] = 15.9, ["Fly|Ride"] = 196.88, ["Neon"] = 6.39, ["Neon|Ride"] = 32.43, ["Mega"] = 68.25, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 152.06, ["Mega|Fly|Ride"] = 274.31}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.05}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.05, ["Ride"] = 55.53, ["Neon"] = 2.57, ["Mega|Ride"] = 137.68, ["Mega|Fly|Ride"] = 260.27}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 15.65}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 34.04, ["Fly"] = 78.75, ["Ride"] = 37.8, ["Fly|Ride"] = 83.61, ["Neon"] = 183.75, ["Neon|Ride"] = 271.8, ["Neon|Fly|Ride"] = 313.68, ["Mega"] = 1643.67, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 889.88}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.05, ["Ride"] = 26.25, ["Neon"] = 3.56, ["Neon|Ride"] = 110.82, ["Mega|Ride"] = 119.7, ["Mega|Fly|Ride"] = 308.2}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 446.24, ["Fly"] = 498.75, ["Ride"] = 603.1, ["Fly|Ride"] = 641.82, ["Neon"] = 2050.48, ["Neon|Fly|Ride"] = 2273.82, ["Mega"] = 16436.62, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 2.05, ["Fly"] = 26.24, ["Ride"] = 24.19, ["Fly|Ride"] = 66.26, ["Neon"] = 30.98, ["Mega"] = 88.6, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 548.59}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 3.32, ["Fly"] = 52.49, ["Ride"] = 19.58, ["Fly|Ride"] = 69.33, ["Neon"] = 18.62, ["Neon|Ride"] = 38.97, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 118.13, ["Mega|Ride"] = 137.68, ["Mega|Fly|Ride"] = 227.26}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 11.46, ["Fly"] = 77.07, ["Ride"] = 50.3, ["Fly|Ride"] = 106.32, ["Neon"] = 102.77, ["Neon|Ride"] = 167.47, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 821.85, ["Mega|Ride"] = 493.12, ["Mega|Fly|Ride"] = 548.59}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 2.1, ["Ride"] = 27.76, ["Fly|Ride"] = 721.88, ["Neon"] = 29.81, ["Neon|Ride"] = 118.12, ["Mega"] = 261.19}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 9.34, ["Fly"] = 138.11, ["Ride"] = 137.69, ["Fly|Ride"] = 173.23, ["Neon"] = 117.39, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 369.85, ["Mega"] = 397.58, ["Mega|Ride"] = 617.54, ["Mega|Fly|Ride"] = 489.04}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 5.6, ["Ride"] = 40.86, ["Fly|Ride"] = 133.88, ["Neon"] = 32.66, ["Neon|Ride"] = 76.04, ["Neon|Fly|Ride"] = 204.75, ["Mega"] = 548.59, ["Mega|Fly"] = 548.59, ["Mega|Ride"] = 310.36, ["Mega|Fly|Ride"] = 359.51}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.05, ["Fly"] = 46.51, ["Ride"] = 11.4, ["Fly|Ride"] = 68.85, ["Neon"] = 2.1, ["Neon|Fly"] = 58.57, ["Neon|Ride"] = 15.38, ["Neon|Fly|Ride"] = 123.3, ["Mega"] = 9.19, ["Mega|Ride"] = 24.94, ["Mega|Fly|Ride"] = 149.94}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 4.19, ["Ride"] = 32.7, ["Fly|Ride"] = 102.76, ["Neon"] = 40.32, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 219.86, ["Mega"] = 183.75, ["Mega|Ride"] = 217.88, ["Mega|Fly|Ride"] = 714.67}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 294.84, ["Fly"] = 397.63, ["Ride"] = 298.86, ["Fly|Ride"] = 393.75, ["Neon"] = 1240.21, ["Neon|Ride"] = 1404.38, ["Neon|Fly|Ride"] = 1394.8, ["Mega|Ride"] = 5033.73, ["Mega|Fly|Ride"] = 5054.26}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 84.96, ["Ride"] = 137.69, ["Fly|Ride"] = 7534.06, ["Neon"] = 534.2, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 585.38, ["Mega"] = 1986.79, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1518.57}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.05, ["Fly"] = 12.33, ["Ride"] = 15.32, ["Fly|Ride"] = 41.11, ["Neon"] = 135.61, ["Neon|Fly"] = 68.85, ["Neon|Ride"] = 31.39, ["Neon|Fly|Ride"] = 63.31, ["Mega|Fly"] = 204.45, ["Mega|Ride"] = 77.06, ["Mega|Fly|Ride"] = 256.6}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 13.13, ["Fly|Ride"] = 32.47, ["Neon"] = 6.09, ["Neon|Fly"] = 70.77, ["Neon|Ride"] = 22.81, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 61.27, ["Mega|Fly"] = 344.03, ["Mega|Ride"] = 116.82, ["Mega|Fly|Ride"] = 181.75}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.1, ["Ride"] = 22.32, ["Fly|Ride"] = 98.44, ["Neon"] = 45.85, ["Mega"] = 205.48, ["Mega|Ride"] = 410.93, ["Mega|Fly|Ride"] = 274.31}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 239, ["Fly"] = 420, ["Ride"] = 250.78, ["Fly|Ride"] = 375.38, ["Neon"] = 1370.41, ["Neon|Ride"] = 1024.23, ["Neon|Fly|Ride"] = 2028.91, ["Mega|Ride"] = 8218.31, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.1, ["Fly"] = 12.71, ["Ride"] = 15.72, ["Fly|Ride"] = 31.5, ["Neon"] = 17.06, ["Neon|Fly"] = 104.97, ["Neon|Ride"] = 39.24, ["Neon|Fly|Ride"] = 137.68, ["Mega"] = 232.47, ["Mega|Ride"] = 310.36, ["Mega|Fly|Ride"] = 359.57}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 3.59, ["Ride"] = 93.6, ["Fly|Ride"] = 205.5, ["Neon"] = 56.56, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 274.31, ["Mega"] = 299.25, ["Mega|Ride"] = 288.64, ["Mega|Fly|Ride"] = 394.5}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.05, ["Ride"] = 27.85, ["Neon"] = 5.29, ["Neon|Ride"] = 155.6, ["Mega"] = 65.54, ["Mega|Ride"] = 205.48}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 11.87, ["Fly"] = 41.11, ["Ride"] = 19.35, ["Fly|Ride"] = 74.81, ["Neon"] = 80.75, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 137.68, ["Mega"] = 586.6, ["Mega|Ride"] = 438.38, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 36.35, ["Ride"] = 85.32, ["Fly|Ride"] = 210, ["Neon"] = 146.57, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 335.71, ["Mega"] = 465.94, ["Mega|Fly"] = 2157.31, ["Mega|Ride"] = 489.5, ["Mega|Fly|Ride"] = 569.24}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 18.38, ["Ride"] = 45.94, ["Fly|Ride"] = 91.88, ["Neon"] = 105, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 209.58, ["Neon|Fly|Ride"] = 305.62, ["Mega"] = 685.21, ["Mega|Ride"] = 821.85, ["Mega|Fly|Ride"] = 866.25}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.05, ["Fly"] = 20.5, ["Ride"] = 11.82, ["Fly|Ride"] = 42.33, ["Neon"] = 2.1, ["Neon|Fly"] = 17.46, ["Neon|Ride"] = 14.9, ["Neon|Fly|Ride"] = 47.15, ["Mega"] = 17.05, ["Mega|Fly"] = 410.93, ["Mega|Ride"] = 40.36, ["Mega|Fly|Ride"] = 81.38}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 246.95, ["Ride"] = 309.38, ["Fly|Ride"] = 328.02, ["Neon"] = 955.13, ["Neon|Fly|Ride"] = 842.82}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 8.76, ["Fly"] = 101.18, ["Ride"] = 42.37, ["Fly|Ride"] = 105, ["Neon"] = 130.48, ["Neon|Ride"] = 185.99, ["Neon|Fly|Ride"] = 328.12, ["Mega|Fly|Ride"] = 775.28}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 30.68, ["Ride"] = 16.86, ["Fly|Ride"] = 42.09, ["Neon"] = 5.91, ["Neon|Fly"] = 35.33, ["Neon|Ride"] = 20.56, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 59.07, ["Mega|Fly"] = 274.31, ["Mega|Ride"] = 69.33, ["Mega|Fly|Ride"] = 291.76}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.05, ["Fly"] = 30.83, ["Ride"] = 15.65, ["Fly|Ride"] = 42.83, ["Neon"] = 2.1, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 24.93, ["Neon|Fly|Ride"] = 124.38, ["Mega|Fly"] = 137.68, ["Mega|Ride"] = 45.4, ["Mega|Fly|Ride"] = 177.85}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 3.68, ["Ride"] = 11.82, ["Fly|Ride"] = 69.29, ["Neon"] = 8.03, ["Neon|Fly"] = 697.41, ["Neon|Ride"] = 69.76, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 127.91, ["Mega|Ride"] = 194.09, ["Mega|Fly|Ride"] = 371.96}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 9.18, ["Fly"] = 27.76, ["Ride"] = 22.61, ["Fly|Ride"] = 53.89, ["Neon"] = 51.45, ["Neon|Fly"] = 260.95, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 115.5, ["Mega"] = 426.35, ["Mega|Ride"] = 315.39, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 7.24, ["Ride"] = 55.12, ["Neon"] = 45.48, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 275.63, ["Mega|Ride"] = 274.31, ["Mega|Fly|Ride"] = 408.89}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.05, ["Fly|Ride"] = 274.31, ["Neon"] = 3.5, ["Neon|Ride"] = 31.39, ["Neon|Fly|Ride"] = 100.64, ["Mega|Ride"] = 70.79, ["Mega|Fly|Ride"] = 168.39}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 7.08, ["Ride"] = 24.75, ["Fly|Ride"] = 131.25, ["Neon"] = 28.46, ["Neon|Fly"] = 88.35, ["Neon|Ride"] = 77.96, ["Neon|Fly|Ride"] = 104.79, ["Mega"] = 207.2, ["Mega|Ride"] = 155.76, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.05, ["Ride"] = 207.9, ["Neon"] = 2.9, ["Neon|Ride"] = 45.78, ["Neon|Fly|Ride"] = 102.3, ["Mega"] = 19.59, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 129.94}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.05, ["Fly"] = 41.04, ["Ride"] = 16.69, ["Fly|Ride"] = 39.38, ["Neon"] = 4.76, ["Neon|Ride"] = 20.88, ["Neon|Fly|Ride"] = 95.47, ["Mega"] = 46.66, ["Mega|Fly"] = 137.68, ["Mega|Ride"] = 86.35, ["Mega|Fly|Ride"] = 272.9}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 656.12, ["Ride"] = 702.19, ["Fly|Ride"] = 787.5, ["Neon|Ride"] = 3564.86, ["Neon|Fly|Ride"] = 3361.31, ["Mega|Fly|Ride"] = 12832.39}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.05, ["Fly"] = 24.94, ["Ride"] = 13.54, ["Fly|Ride"] = 31.54, ["Neon"] = 11.46, ["Neon|Fly"] = 137.68, ["Neon|Ride"] = 40.07, ["Neon|Fly|Ride"] = 71.93, ["Mega|Fly|Ride"] = 343.13}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.1, ["Ride"] = 26.16, ["Fly|Ride"] = 274.34, ["Neon"] = 7.69, ["Neon|Ride"] = 88.54, ["Neon|Fly|Ride"] = 393.75, ["Mega|Ride"] = 129.22, ["Mega|Fly|Ride"] = 240.66}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 7.01, ["Fly"] = 46.51, ["Ride"] = 17.52, ["Fly|Ride"] = 44.63, ["Neon"] = 44.68, ["Neon|Fly"] = 189.38, ["Neon|Ride"] = 57.98, ["Neon|Fly|Ride"] = 97.12, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 306.88}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.05, ["Fly"] = 20.11, ["Ride"] = 14.6, ["Fly|Ride"] = 32.81, ["Neon"] = 7.76, ["Neon|Fly"] = 137.13, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 69.23, ["Mega"] = 65.01, ["Mega|Ride"] = 99.75, ["Mega|Fly|Ride"] = 144.26}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 25.88, ["Ride"] = 71.47, ["Fly|Ride"] = 273.3, ["Neon"] = 220.4, ["Neon|Ride"] = 262.7, ["Mega"] = 918.75, ["Mega|Fly|Ride"] = 1164.96}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 19.47, ["Fly|Ride"] = 64.16, ["Neon"] = 8.24, ["Neon|Fly"] = 141.75, ["Neon|Ride"] = 31.39, ["Neon|Fly|Ride"] = 141.79, ["Mega"] = 40.5, ["Mega|Ride"] = 112.94, ["Mega|Fly|Ride"] = 263.86}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 124.4, ["Ride"] = 19.36, ["Fly|Ride"] = 53.44, ["Neon"] = 8.71, ["Neon|Ride"] = 41.89, ["Neon|Fly|Ride"] = 155.76, ["Mega"] = 114.19, ["Mega|Ride"] = 198.58, ["Mega|Fly|Ride"] = 472.57}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.45, ["Fly"] = 26.25, ["Fly|Ride"] = 59.07, ["Neon"] = 15.43, ["Mega"] = 91.84, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.02, ["Fly"] = 42, ["Ride"] = 15.65, ["Fly|Ride"] = 49.83, ["Neon"] = 4.96, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 24.26, ["Neon|Fly|Ride"] = 32.24, ["Mega|Fly"] = 287.66, ["Mega|Ride"] = 58.97, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 11.03, ["Fly"] = 18.8, ["Ride"] = 19.69, ["Fly|Ride"] = 32.82, ["Neon"] = 310.36, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 98.43, ["Mega"] = 821.85, ["Mega|Ride"] = 410.93, ["Mega|Fly|Ride"] = 408.89}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 787.33, ["Ride"] = 779.66, ["Fly|Ride"] = 892.5, ["Neon"] = 1712.63, ["Neon|Ride"] = 1836.19, ["Neon|Fly|Ride"] = 2163, ["Mega"] = 8218.31, ["Mega|Fly|Ride"] = 7743.75}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.05, ["Fly"] = 18.17, ["Ride"] = 15.2, ["Fly|Ride"] = 32.96, ["Neon"] = 4.49, ["Neon|Ride"] = 16.31, ["Neon|Fly|Ride"] = 53.81, ["Mega"] = 26.25, ["Mega|Ride"] = 56.97, ["Mega|Fly|Ride"] = 125.91}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 6.06, ["Ride"] = 36.73, ["Fly|Ride"] = 201.92, ["Neon"] = 39.32, ["Neon|Ride"] = 112.5, ["Neon|Fly|Ride"] = 209.99, ["Mega"] = 366.18, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 479.76}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 52.49, ["Fly"] = 52.5, ["Ride"] = 59.05, ["Fly|Ride"] = 91.88, ["Neon|Ride"] = 389.82, ["Neon|Fly|Ride"] = 500.3, ["Mega"] = 3150.71, ["Mega|Fly|Ride"] = 1301.58}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 24.94, ["Ride"] = 31.4, ["Fly|Ride"] = 104.89, ["Neon"] = 183.75, ["Neon|Ride"] = 205.48, ["Neon|Fly|Ride"] = 685.21, ["Mega"] = 956.42, ["Mega|Ride"] = 896.44, ["Mega|Fly|Ride"] = 785.75}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 6.57, ["Ride"] = 26.22, ["Fly|Ride"] = 139.71, ["Neon"] = 58.49, ["Neon|Ride"] = 75.57, ["Neon|Fly|Ride"] = 121.42, ["Mega"] = 285.87, ["Mega|Fly|Ride"] = 460.68}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 22.1, ["Ride"] = 65.01, ["Neon"] = 129.03, ["Neon|Ride"] = 356.85, ["Mega"] = 382.6, ["Mega|Fly"] = 504.47, ["Mega|Ride"] = 342.9, ["Mega|Fly|Ride"] = 508.6}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 16.88, ["Fly"] = 126.89, ["Neon"] = 310.36, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 525, ["Mega"] = 924, ["Mega|Ride"] = 728.44, ["Mega|Fly|Ride"] = 563.07}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 9.18}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 3.6, ["Fly"] = 131248.69, ["Ride"] = 16.78, ["Fly|Ride"] = 58.8, ["Neon"] = 31.11, ["Neon|Ride"] = 62.87, ["Neon|Fly|Ride"] = 178.77, ["Mega"] = 189.55, ["Mega|Fly"] = 463.87, ["Mega|Ride"] = 213.69, ["Mega|Fly|Ride"] = 274.31}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.17, ["Ride"] = 46.85, ["Neon"] = 11.46, ["Mega"] = 137.68}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 31.5, ["Fly"] = 59.07, ["Ride"] = 44.13, ["Fly|Ride"] = 65.63, ["Neon"] = 272, ["Neon|Ride"] = 189, ["Neon|Fly|Ride"] = 929.87, ["Mega|Ride"] = 1643.67, ["Mega|Fly|Ride"] = 788.82}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.72, ["Fly"] = 17.3, ["Ride"] = 13.33, ["Fly|Ride"] = 36.52, ["Neon"] = 24.94, ["Neon|Fly"] = 68.85, ["Neon|Ride"] = 31.34, ["Neon|Fly|Ride"] = 77.81, ["Mega"] = 116.82, ["Mega|Ride"] = 195.57, ["Mega|Fly|Ride"] = 186.76}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 4.73, ["Fly"] = 145.91, ["Ride"] = 27.03, ["Fly|Ride"] = 685.3, ["Neon"] = 20.53, ["Neon|Ride"] = 42.26, ["Neon|Fly|Ride"] = 118.01, ["Mega"] = 129.94, ["Mega|Ride"] = 159, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.05, ["Neon"] = 5.2, ["Mega"] = 42.4, ["Mega|Ride"] = 196.38}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 27.57, ["Ride"] = 65.63, ["Fly|Ride"] = 89.24, ["Neon"] = 118.13, ["Neon|Ride"] = 155.76, ["Neon|Fly|Ride"] = 303.07, ["Mega|Ride"] = 13697.87, ["Mega|Fly|Ride"] = 871.5}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.05, ["Ride"] = 38.56, ["Fly|Ride"] = 65.63, ["Neon"] = 4.72, ["Neon|Fly"] = 291.38, ["Neon|Ride"] = 66.27, ["Mega"] = 72.1, ["Mega|Ride"] = 118.12, ["Mega|Fly|Ride"] = 462.2}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 10.28, ["Fly"] = 52.5, ["Ride"] = 76.34, ["Fly|Ride"] = 273.3, ["Neon"] = 104.63, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 399, ["Mega|Ride"] = 874.12, ["Mega|Fly|Ride"] = 548.59}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.63, ["Fly"] = 45.88, ["Ride"] = 13.42, ["Fly|Ride"] = 40.63, ["Neon"] = 18.59, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 65.63, ["Mega|Ride"] = 208.04, ["Mega|Fly|Ride"] = 248.75}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 2.1, ["Fly"] = 52.49, ["Ride"] = 19.3, ["Fly|Ride"] = 71.36, ["Neon"] = 26.25, ["Neon|Ride"] = 410.93, ["Mega|Ride"] = 397.58, ["Mega|Fly|Ride"] = 410.17}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 6.45, ["Ride"] = 69.77, ["Neon"] = 59.6, ["Neon|Ride"] = 157.55, ["Mega"] = 464.94, ["Mega|Ride"] = 890.68, ["Mega|Fly|Ride"] = 545.74}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 39.37, ["Fly"] = 76.67, ["Ride"] = 102.76, ["Neon"] = 233.63, ["Neon|Fly|Ride"] = 548.59, ["Mega|Fly|Ride"] = 1640.63}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 14.88, ["Ride"] = 137.69, ["Neon"] = 99.02, ["Neon|Ride"] = 262.5, ["Mega"] = 410.93, ["Mega|Fly|Ride"] = 547.98}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 7.88, ["Ride"] = 105, ["Neon"] = 162.74, ["Neon|Fly"] = 205.48, ["Mega|Ride"] = 1027.3}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 16.59, ["Ride"] = 105, ["Fly|Ride"] = 367.46, ["Neon"] = 107.63, ["Neon|Fly|Ride"] = 328.13, ["Mega|Fly"] = 2054.59, ["Mega|Ride"] = 775.28, ["Mega|Fly|Ride"] = 1091.82}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 2.49, ["Neon"] = 13.07, ["Mega"] = 131.25, ["Mega|Fly|Ride"] = 310.36}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.39, ["Fly"] = 128.62, ["Ride"] = 13.91, ["Fly|Ride"] = 63, ["Neon"] = 3.05, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 25.26, ["Neon|Fly|Ride"] = 93.19, ["Mega"] = 52.41, ["Mega|Ride"] = 119.45, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 4.61, ["Fly"] = 50.3, ["Ride"] = 274.34, ["Fly|Ride"] = 77.9, ["Neon"] = 14.46, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 41.11, ["Neon|Fly|Ride"] = 163.96, ["Mega|Ride"] = 160.93, ["Mega|Fly|Ride"] = 236.3}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 20.56, ["Ride"] = 15.45, ["Fly|Ride"] = 27.46, ["Neon"] = 5.67, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 69.76, ["Mega"] = 45.94, ["Mega|Ride"] = 76.56, ["Mega|Fly|Ride"] = 274.31}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 3.43, ["Fly"] = 59.07, ["Ride"] = 26.25, ["Fly|Ride"] = 118.13, ["Neon"] = 24.67, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 254.78, ["Mega"] = 246.57, ["Mega|Ride"] = 324.63, ["Mega|Fly|Ride"] = 464.94}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.77, ["Fly"] = 65.63, ["Ride"] = 19.69, ["Fly|Ride"] = 103.69, ["Neon"] = 25.89, ["Neon|Fly"] = 464.94, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 302.45, ["Mega|Ride"] = 287.47, ["Mega|Fly|Ride"] = 1232.76}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 2.45, ["Fly"] = 131.25, ["Ride"] = 24.65, ["Fly|Ride"] = 50.93, ["Neon"] = 17.45, ["Neon|Fly"] = 111.55, ["Neon|Ride"] = 42.34, ["Neon|Fly|Ride"] = 126, ["Mega"] = 228.26, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 394.42}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.63, ["Fly"] = 35.49, ["Ride"] = 15.64, ["Fly|Ride"] = 49.7, ["Neon"] = 17.73, ["Neon|Fly"] = 82.21, ["Neon|Ride"] = 67.39, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 252.82, ["Mega|Ride"] = 347.17, ["Mega|Fly|Ride"] = 246.57}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 2.88, ["Fly"] = 57.75, ["Ride"] = 43.18, ["Fly|Ride"] = 131.25, ["Neon"] = 14.11, ["Neon|Fly"] = 418.76, ["Neon|Ride"] = 94.5, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 65.63, ["Mega|Fly"] = 176.5, ["Mega|Ride"] = 129.05, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 17.71, ["Fly"] = 205.5, ["Ride"] = 103.94, ["Fly|Ride"] = 286.67, ["Neon"] = 103.95, ["Neon|Fly"] = 433.13, ["Neon|Ride"] = 218.64, ["Neon|Fly|Ride"] = 418.46, ["Mega|Ride"] = 548.59, ["Mega|Fly|Ride"] = 669.38}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 48.79, ["Ride"] = 66.94, ["Fly|Ride"] = 478.95, ["Neon"] = 252.87, ["Neon|Ride"] = 226.35, ["Neon|Fly|Ride"] = 434.73, ["Mega"] = 1507.04, ["Mega|Ride"] = 1061.82, ["Mega|Fly|Ride"] = 1221.93}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.05, ["Fly"] = 50.96, ["Ride"] = 19.51, ["Fly|Ride"] = 64.75, ["Neon"] = 2.1, ["Neon|Ride"] = 40.85, ["Mega"] = 25.01, ["Mega|Ride"] = 71.14, ["Mega|Fly|Ride"] = 148.32}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 63.84, ["Mega|Fly|Ride"] = 977.99}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 39.37, ["Ride"] = 97.13, ["Neon"] = 354.27, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 820.82, ["Mega"] = 1683.73, ["Mega|Ride"] = 1232.76, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 5.5, ["Fly"] = 190.32, ["Ride"] = 53.4, ["Fly|Ride"] = 126, ["Neon"] = 36.62, ["Neon|Ride"] = 60.45, ["Mega"] = 179.8, ["Mega|Ride"] = 242.82, ["Mega|Fly|Ride"] = 383.92}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Fly|Ride"] = 138.11, ["Neon"] = 6.35, ["Neon|Ride"] = 67.44, ["Mega|Fly"] = 341.25, ["Mega|Ride"] = 111.37, ["Mega|Fly|Ride"] = 337.22}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 26.78, ["Ride"] = 16.92, ["Fly|Ride"] = 37.69, ["Neon"] = 11.7, ["Neon|Ride"] = 34.94, ["Neon|Fly|Ride"] = 68.25, ["Mega"] = 169.32, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 211.32, ["Mega|Fly|Ride"] = 225.75}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.05, ["Fly"] = 16.75, ["Ride"] = 13.94, ["Fly|Ride"] = 40.74, ["Neon"] = 2.49, ["Neon|Ride"] = 24.93, ["Neon|Fly|Ride"] = 36.74, ["Mega"] = 40.7, ["Mega|Ride"] = 69.55, ["Mega|Fly|Ride"] = 199.12}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 15.66, ["Fly|Ride"] = 52.41, ["Neon"] = 3.68, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 85.29, ["Mega|Ride"] = 137.68, ["Mega|Fly|Ride"] = 173.25}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.05, ["Ride"] = 52.49, ["Neon"] = 2.1, ["Neon|Ride"] = 145.08, ["Mega"] = 23.96, ["Mega|Fly|Ride"] = 312.31}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 6.23, ["Ride"] = 104.98, ["Neon"] = 32.82, ["Neon|Ride"] = 57.75, ["Neon|Fly|Ride"] = 616.39, ["Mega"] = 232.47, ["Mega|Ride"] = 269.48, ["Mega|Fly|Ride"] = 308.44}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 5.67, ["Ride"] = 157.5, ["Fly|Ride"] = 205.48, ["Neon"] = 49.11, ["Neon|Ride"] = 202.26, ["Neon|Fly|Ride"] = 180.83, ["Mega"] = 308.2, ["Mega|Ride"] = 333.61, ["Mega|Fly|Ride"] = 466.4}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 5.16, ["Fly"] = 25.79, ["Ride"] = 15.41, ["Fly|Ride"] = 41.91, ["Neon"] = 26.25, ["Neon|Ride"] = 37.78, ["Neon|Fly|Ride"] = 82.35, ["Mega|Ride"] = 272, ["Mega|Fly|Ride"] = 356.77}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 70.96, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 446.15}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 24.43, ["Fly"] = 82.67, ["Ride"] = 65.63, ["Neon"] = 105, ["Neon|Fly|Ride"] = 630, ["Mega"] = 639.85, ["Mega|Ride"] = 827.54, ["Mega|Fly|Ride"] = 1020.48}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.05, ["Fly"] = 18.38, ["Ride"] = 13.82, ["Fly|Ride"] = 32.81, ["Neon"] = 2.6, ["Neon|Fly"] = 41.11, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 61.65, ["Mega|Ride"] = 94.01, ["Mega|Fly|Ride"] = 188.97}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.05, ["Fly"] = 15.12, ["Ride"] = 13.13, ["Fly|Ride"] = 27.09, ["Neon"] = 3.86, ["Neon|Fly"] = 26.72, ["Neon|Ride"] = 17.4, ["Neon|Fly|Ride"] = 47.99, ["Mega"] = 36.83, ["Mega|Fly"] = 82.21, ["Mega|Ride"] = 56.32, ["Mega|Fly|Ride"] = 102.37}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 420.33, ["Ride"] = 534.18, ["Fly|Ride"] = 551.25, ["Neon|Fly|Ride"] = 1884.09}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 6.12, ["Ride"] = 55.6, ["Fly|Ride"] = 535.41, ["Neon"] = 37.4, ["Neon|Ride"] = 274.31, ["Neon|Fly|Ride"] = 159.92, ["Mega"] = 356.49, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.05, ["Fly"] = 15.75, ["Ride"] = 15.27, ["Fly|Ride"] = 26.17, ["Neon"] = 2.63, ["Neon|Fly"] = 26.72, ["Neon|Ride"] = 15.39, ["Neon|Fly|Ride"] = 44.63, ["Mega"] = 137.68, ["Mega|Ride"] = 74.01, ["Mega|Fly|Ride"] = 105.44}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 53.27, ["Ride"] = 138.21, ["Fly|Ride"] = 513.73, ["Neon"] = 255.75, ["Neon|Ride"] = 263.82, ["Neon|Fly|Ride"] = 449.97, ["Mega"] = 719.25, ["Mega|Ride"] = 917.44, ["Mega|Fly|Ride"] = 939.74}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 16.68, ["Fly|Ride"] = 35.07, ["Neon"] = 13.13, ["Neon|Fly"] = 52.52, ["Neon|Ride"] = 29.77, ["Neon|Fly|Ride"] = 66.94, ["Mega"] = 91.59, ["Mega|Ride"] = 102.27, ["Mega|Fly|Ride"] = 152.67}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.05, ["Fly"] = 21, ["Ride"] = 42.95, ["Neon"] = 3.14, ["Neon|Ride"] = 32.45, ["Neon|Fly|Ride"] = 98.44, ["Mega|Ride"] = 61.7, ["Mega|Fly|Ride"] = 190.87}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 36.18, ["Fly"] = 108.03, ["Ride"] = 105.83, ["Fly|Ride"] = 194.76, ["Neon"] = 220.5, ["Neon|Ride"] = 191.26, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 787.5, ["Mega|Ride"] = 708.75, ["Mega|Fly|Ride"] = 821.85}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.05, ["Ride"] = 18.27, ["Fly|Ride"] = 32.82, ["Neon"] = 6.75, ["Neon|Ride"] = 39.99, ["Neon|Fly|Ride"] = 63, ["Mega"] = 47.77, ["Mega|Ride"] = 189, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 27.67, ["Ride"] = 69.43, ["Fly|Ride"] = 137.69, ["Neon"] = 328.75, ["Neon|Ride"] = 273.28, ["Neon|Fly|Ride"] = 359.63, ["Mega"] = 1623.13, ["Mega|Ride"] = 1643.67, ["Mega|Fly|Ride"] = 1499.86}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 2.1, ["Ride"] = 183.74, ["Neon"] = 19.46, ["Neon|Ride"] = 46.51, ["Neon|Fly|Ride"] = 152.06, ["Mega"] = 150.94, ["Mega|Ride"] = 131.25}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.1, ["Fly"] = 68.85, ["Ride"] = 72, ["Fly|Ride"] = 65.77, ["Neon"] = 6.89, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 251.07, ["Mega|Ride"] = 728.44, ["Mega|Fly|Ride"] = 548.59}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 35.95, ["Ride"] = 104.99, ["Fly|Ride"] = 513.65, ["Neon|Ride"] = 700.88, ["Mega|Ride"] = 2598.75, ["Mega|Fly|Ride"] = 1575.87}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 267.92, ["Ride"] = 20.94, ["Fly|Ride"] = 908.98, ["Neon"] = 5.08, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 152.28, ["Mega"] = 40.62, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 78.45, ["Mega|Fly|Ride"] = 179.96}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.05, ["Fly"] = 10.59, ["Ride"] = 12.16, ["Fly|Ride"] = 101.82, ["Neon"] = 11, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 196.88, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 7.25, ["Fly"] = 58.49, ["Ride"] = 31.5, ["Fly|Ride"] = 75.78, ["Neon"] = 81.78, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 429.35, ["Mega|Ride"] = 397.58, ["Mega|Fly|Ride"] = 465.93}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 8.06, ["Fly"] = 57.11, ["Ride"] = 22.53, ["Fly|Ride"] = 69.57, ["Neon"] = 70.7, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 898.71, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 485.01}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 19.68, ["Fly"] = 51.18, ["Ride"] = 32.87, ["Fly|Ride"] = 62.77, ["Neon"] = 56.03, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 155.76, ["Mega"] = 548.03, ["Mega|Ride"] = 298.86, ["Mega|Fly|Ride"] = 341.28}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 60.72, ["Ride"] = 100.7, ["Fly|Ride"] = 231, ["Neon"] = 330.75, ["Neon|Ride"] = 398.73, ["Neon|Fly|Ride"] = 656.25, ["Mega|Ride"] = 1379.66, ["Mega|Fly|Ride"] = 1299.38}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 3.3, ["Fly"] = 137.69, ["Ride"] = 55.13, ["Neon"] = 23.63, ["Neon|Ride"] = 116.1, ["Neon|Fly|Ride"] = 305.82, ["Mega"] = 223.12, ["Mega|Fly|Ride"] = 382.17}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 3.89, ["Ride"] = 27.08, ["Fly|Ride"] = 78.74, ["Neon"] = 123.3, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 123.3, ["Mega"] = 205.48, ["Mega|Ride"] = 205.48, ["Mega|Fly|Ride"] = 246.62}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 8.71, ["Fly"] = 274.34, ["Ride"] = 24.02, ["Fly|Ride"] = 108.73, ["Neon"] = 39.37, ["Neon|Ride"] = 174.09, ["Mega"] = 453.05, ["Mega|Ride"] = 616.39, ["Mega|Fly|Ride"] = 725.28}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.05, ["Fly"] = 15.75, ["Ride"] = 12.5, ["Fly|Ride"] = 30.23, ["Neon"] = 2.05, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 13.11, ["Neon|Fly|Ride"] = 37.68, ["Mega"] = 10.4, ["Mega|Ride"] = 26.97, ["Mega|Fly|Ride"] = 93.82}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 47.95, ["Ride"] = 78.75, ["Fly|Ride"] = 274.31, ["Neon"] = 410.93, ["Neon|Fly"] = 2328.88, ["Neon|Ride"] = 291.06, ["Neon|Fly|Ride"] = 488.24, ["Mega"] = 3081.88, ["Mega|Ride"] = 945, ["Mega|Fly|Ride"] = 866.25}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 20.56, ["Fly|Ride"] = 34.94, ["Neon"] = 4.96, ["Neon|Ride"] = 27.44, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 259.86, ["Mega|Ride"] = 78.66, ["Mega|Fly|Ride"] = 397.58}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 27.76, ["Ride"] = 15.74, ["Fly|Ride"] = 51.7, ["Neon"] = 26.17, ["Neon|Ride"] = 35.97, ["Neon|Fly|Ride"] = 119.18, ["Mega|Ride"] = 134.87, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 96.59, ["Fly"] = 105, ["Ride"] = 131.15, ["Fly|Ride"] = 258.56, ["Neon"] = 406.88, ["Neon|Ride"] = 534.2, ["Neon|Fly|Ride"] = 921.48, ["Mega"] = 1370.41, ["Mega|Ride"] = 1643.67, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.05, ["Ride"] = 39.38, ["Neon"] = 5.59, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 96.58, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 234.94}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 4.3}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 32.02, ["Fly|Ride"] = 291.8, ["Neon"] = 5.86, ["Neon|Ride"] = 41.27, ["Neon|Fly|Ride"] = 262.5, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.05}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 145.68, ["Ride"] = 189, ["Fly|Ride"] = 295.28, ["Neon"] = 671.86, ["Neon|Ride"] = 672.89, ["Neon|Fly|Ride"] = 917.44, ["Mega|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 2835}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 2.63, ["Ride"] = 41.11, ["Neon"] = 13.13, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 124.69, ["Mega"] = 183.54, ["Mega|Ride"] = 202.85, ["Mega|Fly|Ride"] = 361.62}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 82.26, ["Neon"] = 3.71, ["Neon|Ride"] = 19.4, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 32.8, ["Mega|Ride"] = 100.69, ["Mega|Fly|Ride"] = 137.68}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 5.52, ["Ride"] = 18.69, ["Neon"] = 48.07, ["Neon|Ride"] = 109.94, ["Neon|Fly|Ride"] = 155.76, ["Mega"] = 410.93, ["Mega|Ride"] = 548.59, ["Mega|Fly|Ride"] = 614.76}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 5.25, ["Fly"] = 26.25, ["Ride"] = 20.99, ["Fly|Ride"] = 55.76, ["Neon"] = 130.72, ["Neon|Ride"] = 131.14, ["Neon|Fly|Ride"] = 305.82, ["Mega"] = 597.19, ["Mega|Ride"] = 548.59, ["Mega|Fly|Ride"] = 481.69}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 15.33, ["Ride"] = 60.98, ["Neon"] = 137.68, ["Neon|Ride"] = 168.04, ["Neon|Fly|Ride"] = 1575, ["Mega"] = 560.44, ["Mega|Ride"] = 819.79, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 127.99, ["Fly"] = 275.29, ["Ride"] = 203.12, ["Fly|Ride"] = 215.56, ["Neon"] = 591.94, ["Neon|Ride"] = 590, ["Neon|Fly|Ride"] = 617.4, ["Mega|Fly|Ride"] = 2357.38}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 44.35, ["Fly"] = 205.5, ["Ride"] = 52.4, ["Fly|Ride"] = 82.94, ["Neon"] = 410.93, ["Neon|Ride"] = 288.75, ["Neon|Fly|Ride"] = 301.86}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 3.03, ["Fly"] = 131.23, ["Ride"] = 19.68, ["Fly|Ride"] = 65.63, ["Neon"] = 15.61, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 135.11, ["Mega|Ride"] = 138.04, ["Mega|Fly|Ride"] = 310.36}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 3.56, ["Fly"] = 232.52, ["Ride"] = 31.97, ["Fly|Ride"] = 393.75, ["Neon"] = 144.37, ["Neon|Ride"] = 80.07, ["Mega"] = 379.31, ["Mega|Ride"] = 431.82, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 44.01, ["Fly"] = 139.51, ["Ride"] = 71.58, ["Neon"] = 310.36, ["Neon|Ride"] = 275.44, ["Neon|Fly|Ride"] = 469.6, ["Mega|Ride"] = 1150.57, ["Mega|Fly|Ride"] = 1181.24}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 11.12, ["Ride"] = 67.39, ["Neon"] = 104.99, ["Neon|Ride"] = 548.59, ["Neon|Fly|Ride"] = 453.05, ["Mega"] = 673.92, ["Mega|Ride"] = 479.76}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 327.39, ["Ride"] = 459.38, ["Neon|Ride"] = 3099.93, ["Neon|Fly|Ride"] = 1376.82}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 23.29, ["Ride"] = 26.25, ["Fly|Ride"] = 75.51, ["Neon"] = 224.26, ["Neon|Ride"] = 137.68, ["Neon|Fly|Ride"] = 291.38, ["Mega"] = 1034.25, ["Mega|Ride"] = 922.62, ["Mega|Fly|Ride"] = 1043.74}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.05, ["Fly"] = 38.21, ["Ride"] = 13.69, ["Fly|Ride"] = 119.13, ["Neon"] = 3.93, ["Neon|Ride"] = 14.3, ["Neon|Fly|Ride"] = 73.98, ["Mega"] = 16.96, ["Mega|Fly"] = 108.91, ["Mega|Ride"] = 34.86, ["Mega|Fly|Ride"] = 96.22}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 9.19, ["Neon"] = 18.69, ["Neon|Ride"] = 69.57, ["Neon|Fly|Ride"] = 258.89, ["Mega"] = 152.06, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 409.9}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 2.1, ["Ride"] = 36.27, ["Fly|Ride"] = 60.52, ["Neon"] = 12.48, ["Neon|Fly|Ride"] = 959.51, ["Mega"] = 107.63, ["Mega|Fly"] = 498.61, ["Mega|Ride"] = 273.28, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 393.74, ["Fly"] = 498.6, ["Ride"] = 458.07, ["Fly|Ride"] = 525, ["Neon"] = 1424.39, ["Neon|Ride"] = 1370.41, ["Neon|Fly|Ride"] = 1465.95, ["Mega|Fly|Ride"] = 5026.88}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 13.82, ["Fly|Ride"] = 41.99, ["Neon"] = 39.27, ["Neon|Ride"] = 70.18, ["Neon|Fly|Ride"] = 87.43, ["Mega"] = 168, ["Mega|Ride"] = 273.28, ["Mega|Fly|Ride"] = 464.94}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 5.34, ["Fly"] = 22.08, ["Ride"] = 16.26, ["Fly|Ride"] = 32.82, ["Neon"] = 26.78, ["Neon|Fly"] = 157.5, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 685.21, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 5.24, ["Fly"] = 44.19, ["Ride"] = 28.88, ["Fly|Ride"] = 55.5, ["Neon"] = 10.63, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 54.94, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 169.32, ["Mega|Ride"] = 202.26, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 61.89, ["Fly"] = 41.91, ["Ride"] = 40.2, ["Fly|Ride"] = 96.59, ["Neon"] = 140.44, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 307.17, ["Mega"] = 821.85, ["Mega|Ride"] = 820.82, ["Mega|Fly|Ride"] = 660.19}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.22, ["Fly"] = 39.37, ["Ride"] = 27.61, ["Fly|Ride"] = 50.3, ["Neon"] = 6.91, ["Neon|Ride"] = 114.19, ["Neon|Fly|Ride"] = 210, ["Mega"] = 162.08, ["Mega|Ride"] = 457.79, ["Mega|Fly|Ride"] = 761.92}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 6.06, ["Fly"] = 65.63, ["Ride"] = 24.61, ["Fly|Ride"] = 91.88, ["Neon"] = 129.84, ["Neon|Ride"] = 209.99, ["Mega|Ride"] = 739.67, ["Mega|Fly|Ride"] = 548.59}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 19.57, ["Neon"] = 4.72, ["Neon|Ride"] = 28.87, ["Mega"] = 53.34, ["Mega|Ride"] = 109.28, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 6.39, ["Ride"] = 262.5, ["Neon"] = 84, ["Mega"] = 369.85}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 10.75, ["Neon"] = 77.87, ["Neon|Ride"] = 464.94, ["Neon|Fly|Ride"] = 410.93, ["Mega"] = 274.31, ["Mega|Ride"] = 541.4, ["Mega|Fly|Ride"] = 509.25}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 9.64, ["Fly"] = 28.69, ["Ride"] = 22.57, ["Fly|Ride"] = 48.15, ["Neon"] = 52.39, ["Neon|Fly"] = 68.85, ["Neon|Ride"] = 48.2, ["Neon|Fly|Ride"] = 92.53, ["Mega"] = 577.35, ["Mega|Ride"] = 410.93, ["Mega|Fly|Ride"] = 520.86}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 320.09, ["Fly"] = 365.03, ["Ride"] = 334.59, ["Fly|Ride"] = 429.66, ["Neon"] = 1137.22, ["Neon|Ride"] = 1303.12, ["Neon|Fly|Ride"] = 1470}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.05, ["Ride"] = 15.62, ["Fly|Ride"] = 39.38, ["Neon"] = 13.02, ["Neon|Fly"] = 77.89, ["Neon|Ride"] = 32.28, ["Neon|Fly|Ride"] = 145.04, ["Mega"] = 212.72, ["Mega|Ride"] = 196.77}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 2.59, ["Fly"] = 109.95, ["Ride"] = 45.93, ["Fly|Ride"] = 110.34, ["Neon"] = 42.94, ["Neon|Ride"] = 146.47, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 196.88, ["Mega|Fly"] = 685.21, ["Mega|Ride"] = 389.81}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 23.45, ["Ride"] = 77.11, ["Fly|Ride"] = 229.69, ["Neon"] = 155.76, ["Neon|Ride"] = 132.48, ["Neon|Fly|Ride"] = 403.34, ["Mega"] = 352.8, ["Mega|Ride"] = 399.33, ["Mega|Fly|Ride"] = 446.36}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 122.35, ["Ride"] = 274.34, ["Fly|Ride"] = 443.58, ["Neon"] = 1370.41, ["Neon|Ride"] = 425.15, ["Neon|Fly|Ride"] = 929.87, ["Mega|Ride"] = 6323.05, ["Mega|Fly|Ride"] = 3081.88}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 10.5, ["Fly"] = 121.71, ["Ride"] = 82.21, ["Fly|Ride"] = 120.33, ["Neon"] = 121.7, ["Neon|Ride"] = 120.21, ["Neon|Fly|Ride"] = 160.13, ["Mega|Ride"] = 237.98, ["Mega|Fly|Ride"] = 414.75}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.63, ["Fly"] = 28.87, ["Ride"] = 17.07, ["Fly|Ride"] = 52.5, ["Neon"] = 12.47, ["Neon|Ride"] = 33.53, ["Neon|Fly|Ride"] = 68.85, ["Mega"] = 32.82, ["Mega|Ride"] = 141.82, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 3.55, ["Ride"] = 30.18, ["Neon"] = 26.25, ["Neon|Ride"] = 92.47, ["Neon|Fly|Ride"] = 172.81, ["Mega"] = 167.62, ["Mega|Ride"] = 158.28}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 44.84, ["Fly"] = 196.88, ["Ride"] = 144.37, ["Fly|Ride"] = 216.57, ["Neon"] = 210, ["Neon|Ride"] = 207.58, ["Neon|Fly|Ride"] = 313.69, ["Mega"] = 378.15, ["Mega|Ride"] = 443.5, ["Mega|Fly|Ride"] = 808.49}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 3.05, ["Ride"] = 131.24, ["Neon"] = 7.88, ["Neon|Ride"] = 204.22, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 150.94, ["Mega|Fly|Ride"] = 397.58}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 29.81, ["Neon"] = 118.13, ["Neon|Ride"] = 401.03, ["Mega"] = 464.36, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 1023.75, ["Fly"] = 2054.84, ["Ride"] = 914.38, ["Fly|Ride"] = 982.87, ["Neon"] = 3283.23, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2887.89, ["Mega|Fly|Ride"] = 14831.25}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 15.05, ["Fly"] = 81.47, ["Ride"] = 81.38, ["Fly|Ride"] = 191.63, ["Neon"] = 126.37, ["Neon|Fly"] = 274.31, ["Neon|Ride"] = 157.5, ["Mega"] = 339.52, ["Mega|Fly|Ride"] = 654.94}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 3.54, ["Fly"] = 26.25, ["Ride"] = 21.68, ["Fly|Ride"] = 65.63, ["Neon"] = 9.19, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 92.67, ["Mega"] = 82.43, ["Mega|Ride"] = 155.76, ["Mega|Fly|Ride"] = 203.43}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 9.59, ["Ride"] = 47.25, ["Fly|Ride"] = 137.68, ["Neon"] = 208.56, ["Mega"] = 261.17, ["Mega|Ride"] = 421.92, ["Mega|Fly|Ride"] = 924}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.05, ["Ride"] = 18.98, ["Fly|Ride"] = 59.6, ["Neon"] = 3.68, ["Neon|Ride"] = 20.53, ["Neon|Fly|Ride"] = 68.25, ["Mega|Fly"] = 123.3, ["Mega|Ride"] = 37.34, ["Mega|Fly|Ride"] = 141.77}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 49.96, ["Ride"] = 107.25, ["Fly|Ride"] = 228.69, ["Neon"] = 260.64, ["Neon|Ride"] = 296.28, ["Mega"] = 1096.13, ["Mega|Ride"] = 914.76, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 6.23, ["Ride"] = 44.19, ["Fly|Ride"] = 156.24, ["Neon"] = 60.75, ["Neon|Ride"] = 223.12, ["Mega"] = 669.38, ["Mega|Ride"] = 545.51, ["Mega|Fly|Ride"] = 548.59}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2.1, ["Ride"] = 27.76, ["Neon"] = 13.02, ["Neon|Ride"] = 46.51, ["Mega"] = 91.88, ["Mega|Ride"] = 157.49}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 28.45, ["Fly"] = 68.85, ["Ride"] = 35.44, ["Fly|Ride"] = 113.7, ["Neon"] = 226.1, ["Neon|Ride"] = 82.69, ["Neon|Fly|Ride"] = 154.87, ["Mega"] = 687.95, ["Mega|Ride"] = 453.05, ["Mega|Fly|Ride"] = 774.38}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 7.25, ["Ride"] = 30.21, ["Neon"] = 43.67, ["Neon|Ride"] = 136.83, ["Neon|Fly|Ride"] = 315, ["Mega"] = 479.76, ["Mega|Ride"] = 518.22, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 40.34, ["Ride"] = 84, ["Neon"] = 388.23, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 774.38, ["Mega"] = 2054.59, ["Mega|Ride"] = 1643.67, ["Mega|Fly|Ride"] = 1630.32}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 3.77, ["Ride"] = 48.06, ["Fly|Ride"] = 1967.44, ["Neon"] = 20.35, ["Neon|Ride"] = 88.26, ["Neon|Fly|Ride"] = 169.32, ["Mega|Ride"] = 266.09, ["Mega|Fly|Ride"] = 226.96}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 4.02, ["Ride"] = 19.69, ["Fly|Ride"] = 78.75, ["Neon"] = 63, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 123.3, ["Mega"] = 350.44, ["Mega|Ride"] = 381.94, ["Mega|Fly|Ride"] = 545.51}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 115.16, ["Fly"] = 382.05, ["Ride"] = 158.31, ["Fly|Ride"] = 275.63, ["Neon"] = 644.13, ["Neon|Ride"] = 496.84, ["Neon|Fly|Ride"] = 643.13, ["Mega"] = 2327.07, ["Mega|Ride"] = 2563.33, ["Mega|Fly|Ride"] = 1874.22}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.51, ["Fly"] = 36.75, ["Ride"] = 15.24, ["Fly|Ride"] = 48.3, ["Neon"] = 11.82, ["Neon|Fly"] = 57.53, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 68.25, ["Mega"] = 124.69, ["Mega|Ride"] = 232.47, ["Mega|Fly|Ride"] = 557.93}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 13.77, ["Fly"] = 193.47, ["Ride"] = 34.25, ["Fly|Ride"] = 116.81, ["Neon"] = 80.28, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 178.5, ["Mega"] = 408.54, ["Mega|Ride"] = 451.81, ["Mega|Fly|Ride"] = 389.82}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.05, ["Fly"] = 18.89, ["Ride"] = 14.67, ["Fly|Ride"] = 69.87, ["Neon"] = 2.1, ["Neon|Fly"] = 26.17, ["Neon|Ride"] = 14.13, ["Neon|Fly|Ride"] = 39.38, ["Mega|Ride"] = 27.62, ["Mega|Fly|Ride"] = 74.97}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.05, ["Fly|Ride"] = 39.38, ["Neon"] = 2.4, ["Neon|Ride"] = 41.11, ["Mega"] = 17.72, ["Mega|Fly"] = 104.98, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 159.25}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.1, ["Fly"] = 34.94, ["Ride"] = 18.27, ["Fly|Ride"] = 94.92, ["Neon"] = 15.02, ["Neon|Ride"] = 64.98, ["Mega"] = 78.68, ["Mega|Ride"] = 260.95, ["Mega|Fly|Ride"] = 242.82}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 26.24, ["Ride"] = 52.49, ["Fly|Ride"] = 131.25, ["Neon"] = 117.5, ["Neon|Ride"] = 348.71, ["Neon|Fly|Ride"] = 433.13, ["Mega"] = 423.01, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 959.51}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.49, ["Fly"] = 13.02, ["Ride"] = 12.64, ["Fly|Ride"] = 31.4, ["Neon"] = 12.18, ["Neon|Fly"] = 25.83, ["Neon|Ride"] = 23.28, ["Neon|Fly|Ride"] = 54.51, ["Mega"] = 104.9, ["Mega|Fly"] = 170.61, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 178.77}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 4.81, ["Fly"] = 38.75, ["Ride"] = 11.08, ["Fly|Ride"] = 66.91, ["Neon"] = 16.75, ["Neon|Fly"] = 47.25, ["Neon|Ride"] = 31.18, ["Neon|Fly|Ride"] = 111.06, ["Mega"] = 233.52, ["Mega|Fly"] = 433.13, ["Mega|Ride"] = 170.35, ["Mega|Fly|Ride"] = 252.9}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Fly"] = 22.23, ["Ride"] = 16.65, ["Fly|Ride"] = 82.21, ["Neon"] = 8.86, ["Neon|Fly"] = 98.42, ["Neon|Ride"] = 24.19, ["Neon|Fly|Ride"] = 89.22, ["Mega"] = 129.74, ["Mega|Fly"] = 220.5, ["Mega|Ride"] = 88.36, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 6.57, ["Fly"] = 169.32, ["Ride"] = 23.35, ["Fly|Ride"] = 131.25, ["Neon"] = 30.18, ["Neon|Ride"] = 89.78, ["Neon|Fly|Ride"] = 274.31, ["Mega"] = 260.95, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 4.11, ["Ride"] = 137.74, ["Neon"] = 50.18, ["Neon|Ride"] = 262.5, ["Mega"] = 393.75, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 2.57, ["Fly"] = 42.21, ["Ride"] = 15.43, ["Fly|Ride"] = 44.45, ["Neon"] = 25.45, ["Neon|Fly"] = 196.76, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 111.63, ["Mega"] = 249.38, ["Mega|Ride"] = 303.07, ["Mega|Fly|Ride"] = 384.22}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 21.27, ["Ride"] = 15.75, ["Fly|Ride"] = 34.83, ["Neon"] = 15.21, ["Neon|Fly"] = 46.51, ["Neon|Ride"] = 31.43, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 131.25, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 232.32}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 203.44, ["Fly"] = 393.75, ["Ride"] = 310.4, ["Fly|Ride"] = 465.01, ["Neon"] = 1191.67, ["Neon|Ride"] = 1359.93, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 3937.5}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 6.78, ["Ride"] = 106.23, ["Neon"] = 109.4, ["Mega"] = 118.13, ["Mega|Ride"] = 420.6, ["Mega|Fly|Ride"] = 479.76}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 2.82, ["Fly"] = 102.76, ["Ride"] = 15.75, ["Fly|Ride"] = 79.07, ["Neon"] = 21.25, ["Neon|Ride"] = 55.5, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 204.25, ["Mega|Ride"] = 320.53, ["Mega|Fly|Ride"] = 274.31}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 4.87, ["Neon"] = 36.63, ["Neon|Ride"] = 217.81, ["Neon|Fly|Ride"] = 616.39, ["Mega"] = 603.74, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 549.29}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.05, ["Fly"] = 15.41, ["Ride"] = 11.31, ["Fly|Ride"] = 26.04, ["Neon"] = 2.1, ["Neon|Fly"] = 28.87, ["Neon|Ride"] = 15.54, ["Neon|Fly|Ride"] = 40.49, ["Mega"] = 18.16, ["Mega|Fly"] = 162.75, ["Mega|Ride"] = 42, ["Mega|Fly|Ride"] = 98.43}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.86, ["Fly"] = 32.7, ["Ride"] = 26.25, ["Fly|Ride"] = 109.95, ["Neon"] = 7.77, ["Neon|Ride"] = 22.91, ["Neon|Fly|Ride"] = 96.76, ["Mega"] = 97.35, ["Mega|Ride"] = 140.43, ["Mega|Fly|Ride"] = 171.94}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 3.82, ["Ride"] = 144.38, ["Neon"] = 10.4, ["Neon|Ride"] = 274.31, ["Neon|Fly|Ride"] = 393.75, ["Mega|Ride"] = 410.93, ["Mega|Fly|Ride"] = 328.12}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 77.33, ["Fly"] = 162.75, ["Ride"] = 95.82, ["Fly|Ride"] = 158.82, ["Neon"] = 620.7, ["Neon|Ride"] = 372.9, ["Neon|Fly|Ride"] = 395.58, ["Mega"] = 2054.59, ["Mega|Ride"] = 3426.03, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 6.07, ["Fly"] = 96.59, ["Ride"] = 26.24, ["Fly|Ride"] = 262.49, ["Neon"] = 13.02, ["Neon|Ride"] = 360.6, ["Neon|Fly|Ride"] = 328.75, ["Mega"] = 211.54, ["Mega|Ride"] = 263.86, ["Mega|Fly|Ride"] = 541.4}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 20.99, ["Ride"] = 55.5, ["Neon"] = 23, ["Neon|Ride"] = 62.77, ["Neon|Fly|Ride"] = 521.91, ["Mega"] = 52.5, ["Mega|Fly"] = 314.99, ["Mega|Fly|Ride"] = 915.92}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 52.5, ["Fly"] = 210, ["Ride"] = 68.85, ["Fly|Ride"] = 205.5, ["Neon"] = 196.88, ["Neon|Ride"] = 164.38, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 636.57, ["Mega|Ride"] = 589.32, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.05, ["Fly"] = 10.5, ["Ride"] = 12.47, ["Fly|Ride"] = 25.91, ["Neon"] = 2.1, ["Neon|Fly"] = 16.86, ["Neon|Ride"] = 17.5, ["Neon|Fly|Ride"] = 33.06, ["Mega"] = 18.37, ["Mega|Fly"] = 49.87, ["Mega|Ride"] = 26.25, ["Mega|Fly|Ride"] = 112.76}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.05, ["Neon"] = 3.68, ["Neon|Fly"] = 31.86, ["Neon|Ride"] = 548.59, ["Neon|Fly|Ride"] = 209.34, ["Mega|Ride"] = 101.72, ["Mega|Fly|Ride"] = 131.15}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.63, ["Ride"] = 107.63, ["Neon"] = 9.84, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 136.83, ["Neon|Fly|Ride"] = 180.83, ["Mega|Fly"] = 178.77, ["Mega|Ride"] = 123.8, ["Mega|Fly|Ride"] = 182.56}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 6.39, ["Fly"] = 77.17, ["Ride"] = 34.55, ["Fly|Ride"] = 206.07, ["Neon"] = 22.86, ["Neon|Fly"] = 91.55, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 141.45, ["Mega|Fly"] = 219.86, ["Mega|Ride"] = 181.92, ["Mega|Fly|Ride"] = 254.63}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.05, ["Fly"] = 11.82, ["Ride"] = 11.46, ["Fly|Ride"] = 26.81, ["Neon"] = 2.1, ["Neon|Fly"] = 25.66, ["Neon|Ride"] = 24.76, ["Neon|Fly|Ride"] = 44.63, ["Mega"] = 17.75, ["Mega|Ride"] = 51.89, ["Mega|Fly|Ride"] = 118.12}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 20.56, ["Fly"] = 131.25, ["Ride"] = 123.31, ["Neon"] = 128.64, ["Neon|Ride"] = 183.74, ["Mega"] = 528.04, ["Mega|Ride"] = 438.38}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2610.56, ["Ride"] = 2493.74, ["Fly|Ride"] = 2260.69, ["Neon|Fly|Ride"] = 9688.21, ["Mega|Fly|Ride"] = 35954.06}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.05, ["Fly"] = 19.69, ["Ride"] = 17.07, ["Fly|Ride"] = 40.08, ["Neon"] = 6.98, ["Neon|Fly"] = 56.83, ["Neon|Ride"] = 20.55, ["Neon|Fly|Ride"] = 55.27, ["Mega"] = 68.73, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 132.65}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 3.04, ["Neon"] = 5.13, ["Mega"] = 111.57, ["Mega|Fly"] = 441, ["Mega|Ride"] = 116.24, ["Mega|Fly|Ride"] = 232.47}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 17.07, ["Fly"] = 109.95, ["Ride"] = 30.03, ["Fly|Ride"] = 67.82, ["Neon"] = 76.82, ["Neon|Ride"] = 310.36, ["Neon|Fly|Ride"] = 220.5, ["Mega"] = 459.38, ["Mega|Ride"] = 399}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 35.17, ["Ride"] = 43.29, ["Neon"] = 187.68, ["Mega"] = 1232.76, ["Mega|Ride"] = 754.04, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 144.38, ["Fly"] = 1370.58, ["Ride"] = 197.78, ["Fly|Ride"] = 230.98, ["Neon"] = 1312.5, ["Neon|Ride"] = 700.41, ["Neon|Fly|Ride"] = 800.83, ["Mega"] = 6163.75, ["Mega|Fly|Ride"] = 2789.59}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 6.23, ["Ride"] = 28.88, ["Fly|Ride"] = 675.94, ["Neon"] = 15.75, ["Neon|Ride"] = 155.76, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 129.94, ["Mega|Ride"] = 303.07, ["Mega|Fly|Ride"] = 582.75}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.5, ["Fly|Ride"] = 68.85, ["Neon"] = 18.37, ["Neon|Ride"] = 114.85, ["Mega"] = 140.43, ["Mega|Ride"] = 333.38, ["Mega|Fly|Ride"] = 826.42}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Ride"] = 28.55, ["Fly|Ride"] = 131.25, ["Neon"] = 6.27, ["Neon|Ride"] = 59.6, ["Mega"] = 137.68, ["Mega|Ride"] = 110.84, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 11.1, ["Ride"] = 100.7, ["Neon"] = 180.83, ["Neon|Ride"] = 1165.83, ["Mega"] = 374.07, ["Mega|Ride"] = 455.11, ["Mega|Fly|Ride"] = 809.17}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.05, ["Ride"] = 41.11, ["Neon"] = 2.1, ["Neon|Ride"] = 28.29, ["Mega"] = 17.45, ["Mega|Fly"] = 116.24, ["Mega|Ride"] = 155.76, ["Mega|Fly|Ride"] = 274.31}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 89.25, ["Fly"] = 205.5, ["Ride"] = 87.94, ["Fly|Ride"] = 308.23, ["Neon"] = 509.55, ["Neon|Ride"] = 401.06, ["Neon|Fly|Ride"] = 512.6, ["Mega"] = 2054.59, ["Mega|Fly|Ride"] = 1836.19}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.05, ["Ride"] = 91.84, ["Neon"] = 9.96, ["Neon|Ride"] = 141.79, ["Neon|Fly|Ride"] = 205.48, ["Mega"] = 69.76, ["Mega|Ride"] = 386.54}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 43.39, ["Fly"] = 205.5, ["Ride"] = 81.27, ["Fly|Ride"] = 131.15, ["Neon"] = 295.32, ["Neon|Ride"] = 377.03, ["Neon|Fly|Ride"] = 381.14, ["Mega"] = 2625, ["Mega|Fly|Ride"] = 2480.41}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.05, ["Ride"] = 31.86, ["Fly|Ride"] = 50.7, ["Neon"] = 4.47, ["Neon|Fly"] = 87.44, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 112.52, ["Mega"] = 54.57, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 177.14}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 3.83, ["Neon"] = 9.31, ["Neon|Ride"] = 98.44, ["Mega|Ride"] = 152.25, ["Mega|Fly|Ride"] = 410.93}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 5.92, ["Fly"] = 77.43, ["Ride"] = 32.82, ["Fly|Ride"] = 205.48, ["Neon"] = 66.78, ["Neon|Ride"] = 102.75, ["Mega"] = 232.89, ["Mega|Fly|Ride"] = 548.59}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 340.78, ["Ride"] = 369.62, ["Fly|Ride"] = 519.75, ["Neon"] = 1049.99, ["Neon|Ride"] = 1443.75, ["Neon|Fly|Ride"] = 1058.52, ["Mega"] = 3970.81, ["Mega|Ride"] = 4725, ["Mega|Fly|Ride"] = 4974.38}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 30.86, ["Fly"] = 82.21, ["Ride"] = 65.77, ["Fly|Ride"] = 83.75, ["Neon"] = 190.2, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 287.66, ["Mega|Fly|Ride"] = 1995}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 47.38, ["Ride"] = 16.51, ["Fly|Ride"] = 57.75, ["Neon"] = 4.87, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 53.81, ["Neon|Fly|Ride"] = 105, ["Mega"] = 91.84, ["Mega|Ride"] = 103.69, ["Mega|Fly|Ride"] = 229.69}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 12.22, ["Fly"] = 111.46, ["Ride"] = 42.99, ["Fly|Ride"] = 98.43, ["Neon"] = 52.5, ["Neon|Fly"] = 464.94, ["Neon|Ride"] = 115.49, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 307.13, ["Mega|Fly"] = 956.61, ["Mega|Ride"] = 293.04, ["Mega|Fly|Ride"] = 358.77}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 7, ["Fly"] = 35.56, ["Ride"] = 20.69, ["Fly|Ride"] = 82.21, ["Neon"] = 137.68, ["Neon|Ride"] = 91.87, ["Neon|Fly|Ride"] = 263.86, ["Mega"] = 1096.13, ["Mega|Ride"] = 513.65, ["Mega|Fly|Ride"] = 548.59}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.78, ["Neon"] = 12.81, ["Mega"] = 65.63, ["Mega|Ride"] = 131.25}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 5.03, ["Fly"] = 39.38, ["Ride"] = 17.52, ["Fly|Ride"] = 57.66, ["Neon"] = 32.82, ["Neon|Ride"] = 32.79, ["Neon|Fly|Ride"] = 269.16, ["Mega"] = 542.81, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 103.69, ["Ride"] = 117.5, ["Fly|Ride"] = 224.43, ["Neon"] = 767.4, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 568.5, ["Mega|Fly|Ride"] = 2916.48}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 26.25, ["Ride"] = 77.26, ["Fly|Ride"] = 85.32, ["Neon"] = 129.94, ["Neon|Ride"] = 205.48, ["Neon|Fly|Ride"] = 389.73, ["Mega"] = 682.5, ["Mega|Ride"] = 891.7, ["Mega|Fly|Ride"] = 665.44}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2231.25, ["Fly"] = 3562.07, ["Ride"] = 2122.32, ["Fly|Ride"] = 1919.21, ["Neon"] = 10958.1, ["Neon|Fly|Ride"] = 6424.69, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 2.24, ["Fly"] = 65625, ["Ride"] = 115.12, ["Fly|Ride"] = 196.87, ["Neon"] = 13, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 95.7, ["Mega|Fly"] = 786.19, ["Mega|Ride"] = 161.03, ["Mega|Fly|Ride"] = 449.84}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 3.62, ["Ride"] = 31.49, ["Fly|Ride"] = 127.41, ["Neon"] = 35.85, ["Neon|Ride"] = 118.57, ["Neon|Fly|Ride"] = 232.32, ["Mega"] = 262.29, ["Mega|Ride"] = 193.55, ["Mega|Fly|Ride"] = 1027.3}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 1047.81, ["Ride"] = 996.19, ["Fly|Ride"] = 986.99, ["Neon"] = 2778.57, ["Neon|Ride"] = 2611.87, ["Neon|Fly|Ride"] = 3110.63, ["Mega|Fly|Ride"] = 11933.59}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 20.53, ["Ride"] = 52.49, ["Fly|Ride"] = 173.35, ["Neon"] = 182.27, ["Neon|Ride"] = 205.48, ["Neon|Fly|Ride"] = 367.31, ["Mega"] = 840, ["Mega|Ride"] = 614.63, ["Mega|Fly|Ride"] = 1642.65}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 2.52, ["Ride"] = 23.46, ["Fly|Ride"] = 128.14, ["Neon"] = 15.39, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 202.79, ["Mega|Ride"] = 268.98, ["Mega|Fly|Ride"] = 548.59}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 111.45, ["Ride"] = 137.69, ["Neon"] = 2.41, ["Neon|Ride"] = 55.23, ["Neon|Fly|Ride"] = 78.08, ["Mega"] = 19.48, ["Mega|Ride"] = 250.67, ["Mega|Fly|Ride"] = 274.31}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 85.23, ["Ride"] = 129.94, ["Fly|Ride"] = 170.63, ["Neon"] = 410.93, ["Neon|Fly|Ride"] = 603.75, ["Mega"] = 8218.31, ["Mega|Fly|Ride"] = 5333.91}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.05}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 2.41, ["Ride"] = 36.26, ["Fly|Ride"] = 73.11, ["Neon"] = 12.39, ["Neon|Ride"] = 52.02, ["Neon|Fly|Ride"] = 274.31, ["Mega"] = 133.81, ["Mega|Ride"] = 262.49, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 75.51, ["Ride"] = 102.38, ["Neon"] = 603.03, ["Neon|Ride"] = 409.9, ["Neon|Fly|Ride"] = 504.41, ["Mega|Fly|Ride"] = 1744.35}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 3.05, ["Fly"] = 105, ["Fly|Ride"] = 109.95, ["Neon"] = 26.2, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 161.47, ["Mega|Ride"] = 164.07, ["Mega|Fly|Ride"] = 395.07}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 269.05, ["Ride"] = 249.68, ["Fly|Ride"] = 281.15, ["Neon"] = 1498.88, ["Neon|Ride"] = 853.13, ["Neon|Fly|Ride"] = 817.18, ["Mega|Fly|Ride"] = 3899.56}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 2.1, ["Fly"] = 87.94, ["Ride"] = 19.41, ["Fly|Ride"] = 103.76, ["Neon"] = 57.54, ["Neon|Fly"] = 155.76, ["Neon|Ride"] = 56.16, ["Neon|Fly|Ride"] = 100.05, ["Mega"] = 183.75, ["Mega|Ride"] = 274.31, ["Mega|Fly|Ride"] = 390.32}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.05, ["Fly"] = 20.9, ["Ride"] = 12.01, ["Fly|Ride"] = 29.29, ["Neon"] = 5.13, ["Neon|Fly"] = 31.39, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 51.96, ["Mega"] = 46.82, ["Mega|Fly"] = 136.14, ["Mega|Ride"] = 115.48, ["Mega|Fly|Ride"] = 177.19}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 1181.25, ["Ride"] = 1050, ["Fly|Ride"] = 1254.19, ["Neon|Ride"] = 7534.14, ["Neon|Fly|Ride"] = 5890.48, ["Mega"] = 22781.54}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 5.08, ["Fly"] = 959.62, ["Ride"] = 72.19, ["Neon"] = 42.77, ["Neon|Ride"] = 311.75, ["Mega"] = 305.82, ["Mega|Ride"] = 410.93, ["Mega|Fly|Ride"] = 589.32}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 6.25, ["Fly"] = 49.33, ["Ride"] = 32.89, ["Fly|Ride"] = 79.49, ["Neon"] = 25.46, ["Neon|Fly"] = 155.76, ["Neon|Ride"] = 57.06, ["Neon|Fly|Ride"] = 117.66, ["Mega"] = 203.41, ["Mega|Ride"] = 200.45, ["Mega|Fly|Ride"] = 293.05}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 23.56, ["Fly"] = 32.71, ["Ride"] = 32.83, ["Fly|Ride"] = 66.81, ["Neon"] = 274.31, ["Neon|Ride"] = 196.74, ["Neon|Fly|Ride"] = 189.63, ["Mega"] = 2054.59, ["Mega|Fly|Ride"] = 761.25}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 11.17, ["Fly"] = 82.21, ["Ride"] = 24.94, ["Fly|Ride"] = 98.32, ["Neon"] = 74.72, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 77.89, ["Neon|Fly|Ride"] = 179.79, ["Mega"] = 367.5, ["Mega|Fly"] = 367.5, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 493.12}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 39.26, ["Ride"] = 71.75, ["Fly|Ride"] = 400.71, ["Neon"] = 127.34, ["Neon|Ride"] = 378, ["Mega|Ride"] = 654.94, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.05, ["Ride"] = 15.75, ["Fly|Ride"] = 77.89, ["Neon"] = 2.1, ["Neon|Fly"] = 55.5, ["Neon|Ride"] = 109.28, ["Neon|Fly|Ride"] = 105.16, ["Mega"] = 16.7, ["Mega|Ride"] = 79.26, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 70.72, ["Fly"] = 116.82, ["Ride"] = 71.32, ["Fly|Ride"] = 140.3, ["Neon"] = 446.23, ["Neon|Fly"] = 663.58, ["Neon|Ride"] = 393.74, ["Neon|Fly|Ride"] = 420.5, ["Mega"] = 3287.33, ["Mega|Ride"] = 1690.94, ["Mega|Fly|Ride"] = 1438.21}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.1, ["Fly"] = 91.4, ["Ride"] = 23.63, ["Fly|Ride"] = 109.94, ["Neon"] = 59.07, ["Neon|Ride"] = 78.72, ["Mega"] = 773.06, ["Mega|Ride"] = 386.54}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 20.95, ["Ride"] = 15.65, ["Fly|Ride"] = 36.26, ["Neon"] = 15.75, ["Neon|Fly"] = 77.89, ["Neon|Ride"] = 55.5, ["Neon|Fly|Ride"] = 122.85, ["Mega|Ride"] = 270.19, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 3.72, ["Ride"] = 125.99, ["Neon"] = 15.75, ["Neon|Fly"] = 135.61, ["Neon|Fly|Ride"] = 183.9, ["Mega"] = 328.75, ["Mega|Fly|Ride"] = 464.94}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 45.84, ["Ride"] = 154.12, ["Fly|Ride"] = 262.5, ["Neon"] = 210, ["Neon|Ride"] = 248.07, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1757.7, ["Mega|Ride"] = 1096.13, ["Mega|Fly|Ride"] = 1198.34}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 3.72, ["Neon"] = 23.62, ["Neon|Ride"] = 77.06, ["Mega"] = 122.05}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.05, ["Ride"] = 39.38, ["Neon"] = 2.1, ["Neon|Ride"] = 52.5, ["Mega"] = 17.07, ["Mega|Ride"] = 40.28, ["Mega|Fly|Ride"] = 412.13}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.05, ["Fly"] = 102.94, ["Ride"] = 26.25, ["Fly|Ride"] = 39.01, ["Neon"] = 2.1, ["Neon|Ride"] = 32.89, ["Neon|Fly|Ride"] = 164.38, ["Mega|Ride"] = 42.17, ["Mega|Fly|Ride"] = 132.2}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.05, ["Fly"] = 30.83, ["Ride"] = 15.89, ["Fly|Ride"] = 55.95, ["Neon"] = 5.16, ["Neon|Ride"] = 26.81, ["Neon|Fly|Ride"] = 65.62, ["Mega"] = 63, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.05, ["Ride"] = 28.88, ["Fly|Ride"] = 65.63, ["Neon"] = 39.37, ["Mega"] = 118.09, ["Mega|Ride"] = 106.3, ["Mega|Fly|Ride"] = 278.98}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 38.04, ["Ride"] = 15.4, ["Fly|Ride"] = 31.92, ["Neon"] = 14.58, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 201.36, ["Mega|Ride"] = 274.31, ["Mega|Fly|Ride"] = 451.49}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 54.64, ["Ride"] = 91.51, ["Fly|Ride"] = 219.86, ["Neon"] = 144.38, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 1027.3, ["Mega"] = 821.85, ["Mega|Ride"] = 971.25, ["Mega|Fly|Ride"] = 1076.61}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.05, ["Fly"] = 15.53, ["Ride"] = 14.44, ["Fly|Ride"] = 35.35, ["Neon"] = 2.1, ["Neon|Fly"] = 27.76, ["Neon|Ride"] = 16.95, ["Neon|Fly|Ride"] = 42, ["Mega"] = 31.49, ["Mega|Ride"] = 28.47, ["Mega|Fly|Ride"] = 72.1}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 5.25, ["Fly"] = 80.15, ["Ride"] = 34.13, ["Fly|Ride"] = 66.27, ["Neon"] = 24.94, ["Neon|Fly"] = 82.91, ["Neon|Ride"] = 48.56, ["Neon|Fly|Ride"] = 118.15, ["Mega"] = 381.14, ["Mega|Ride"] = 278.11, ["Mega|Fly|Ride"] = 261.4}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 13.55, ["Fly"] = 39.81, ["Ride"] = 27.57, ["Fly|Ride"] = 83.88, ["Neon"] = 114.18, ["Neon|Fly"] = 174.49, ["Neon|Ride"] = 141.75, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 525, ["Mega|Ride"] = 590.52, ["Mega|Fly|Ride"] = 612.28}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 5.16, ["Fly"] = 196.88, ["Neon"] = 52.08, ["Mega"] = 366.19, ["Mega|Ride"] = 397.58, ["Mega|Fly|Ride"] = 410.93}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.05, ["Fly"] = 27.84, ["Ride"] = 14.39, ["Fly|Ride"] = 44.18, ["Neon"] = 3.82, ["Neon|Fly"] = 24.67, ["Neon|Ride"] = 19.59, ["Neon|Fly|Ride"] = 66.21, ["Mega"] = 44.63, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 140.35, ["Mega|Fly|Ride"] = 114.05}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 3.44, ["Fly"] = 76.05, ["Ride"] = 38.07, ["Neon"] = 19.59, ["Neon|Fly"] = 109.94, ["Neon|Ride"] = 109.94, ["Mega"] = 240.19, ["Mega|Fly"] = 735, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 384.22}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 958.25, ["Ride"] = 1023.75, ["Fly|Ride"] = 1089.38, ["Neon"] = 2808.62, ["Neon|Ride"] = 2231.25, ["Neon|Fly|Ride"] = 2067.19, ["Mega|Fly|Ride"] = 6929.9}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 104.7, ["Ride"] = 124.4, ["Fly|Ride"] = 341.25, ["Neon"] = 536.23, ["Neon|Ride"] = 510.48, ["Neon|Fly|Ride"] = 682.14, ["Mega"] = 6163.75, ["Mega|Ride"] = 2603.16, ["Mega|Fly|Ride"] = 2062.53}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.19, ["Fly"] = 55.5, ["Neon"] = 6.03, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 205.48, ["Mega"] = 89.25, ["Mega|Fly|Ride"] = 1096.13}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 70.88, ["Ride"] = 103.95, ["Fly|Ride"] = 227.07, ["Neon"] = 328.13, ["Neon|Ride"] = 360.94, ["Neon|Fly|Ride"] = 551.25, ["Mega"] = 1575, ["Mega|Ride"] = 1706.25, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 2.1, ["Ride"] = 19.13, ["Fly|Ride"] = 89.39, ["Neon"] = 17.2, ["Neon|Fly"] = 54.65, ["Neon|Ride"] = 47.31, ["Neon|Fly|Ride"] = 274.31, ["Mega"] = 274.02, ["Mega|Ride"] = 306.9, ["Mega|Fly|Ride"] = 397.58}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 278.53, ["Fly"] = 410.99, ["Ride"] = 328.13, ["Fly|Ride"] = 378, ["Neon|Ride"] = 1219.4, ["Neon|Fly|Ride"] = 1260.5, ["Mega|Fly|Ride"] = 4383.45}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 76.4, ["Ride"] = 52.41, ["Fly|Ride"] = 210.96, ["Neon"] = 31.39, ["Neon|Ride"] = 54.37, ["Mega"] = 410.93, ["Mega|Fly"] = 320.53, ["Mega|Ride"] = 620.7}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Neon"] = 27.72, ["Mega"] = 328.75, ["Mega|Ride"] = 352.37}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 23.4, ["Ride"] = 274.34, ["Fly|Ride"] = 196.88, ["Neon"] = 152.06, ["Neon|Ride"] = 124.59, ["Mega"] = 956.42, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.52, ["Ride"] = 49.66, ["Neon"] = 24.94, ["Neon|Ride"] = 141.91, ["Mega"] = 240.4, ["Mega|Ride"] = 253.3, ["Mega|Fly|Ride"] = 454.49}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.05, ["Fly"] = 15.11, ["Ride"] = 12.18, ["Fly|Ride"] = 39.35, ["Neon"] = 2.1, ["Neon|Fly"] = 23.63, ["Neon|Ride"] = 15.64, ["Neon|Fly|Ride"] = 37.54, ["Mega"] = 164.38, ["Mega|Ride"] = 32.05, ["Mega|Fly|Ride"] = 76.13}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4593.75, ["Ride"] = 5118.75, ["Fly|Ride"] = 4516.2, ["Neon"] = 30818.65, ["Neon|Fly|Ride"] = 18414.38, ["Mega|Fly|Ride"] = 128410.99}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 7.03, ["Ride"] = 55.82, ["Neon"] = 52.5, ["Neon|Ride"] = 106.32, ["Mega"] = 310.36, ["Mega|Ride"] = 302.57, ["Mega|Fly|Ride"] = 410.93}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.05, ["Fly"] = 24.69, ["Ride"] = 16.48, ["Fly|Ride"] = 45.94, ["Neon"] = 9.09, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 78.66, ["Mega"] = 144.38, ["Mega|Ride"] = 172.59, ["Mega|Fly|Ride"] = 242.18}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 503.42, ["Fly"] = 547.77, ["Ride"] = 532.61, ["Fly|Ride"] = 556.33, ["Neon"] = 2099.99, ["Neon|Ride"] = 1550.55, ["Neon|Fly|Ride"] = 1573.82, ["Mega|Fly|Ride"] = 5876.1}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 3.94, ["Ride"] = 32.62, ["Neon"] = 19.04, ["Neon|Ride"] = 145.69, ["Mega"] = 140.51, ["Mega|Fly|Ride"] = 685.21}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 3.4, ["Fly"] = 4109.67, ["Ride"] = 46.51, ["Neon"] = 23.12, ["Neon|Ride"] = 62.77, ["Neon|Fly|Ride"] = 279.44, ["Mega"] = 408.89, ["Mega|Ride"] = 401.62, ["Mega|Fly|Ride"] = 274.31}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.05, ["Fly"] = 52.47, ["Ride"] = 18.53, ["Neon"] = 3.59, ["Neon|Fly"] = 124.69, ["Neon|Ride"] = 23, ["Neon|Fly|Ride"] = 91.75, ["Mega"] = 39.26, ["Mega|Ride"] = 75.99, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 909.57, ["Ride"] = 821.94, ["Fly|Ride"] = 821.94, ["Neon|Ride"] = 3281.25, ["Neon|Fly|Ride"] = 2455.63}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 6.48, ["Ride"] = 55.5, ["Fly|Ride"] = 410.99, ["Neon"] = 34.65, ["Neon|Ride"] = 67.73, ["Neon|Fly|Ride"] = 81.43, ["Mega|Ride"] = 219.86, ["Mega|Fly|Ride"] = 345.06}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 3.54, ["Fly"] = 236.25, ["Ride"] = 28.25, ["Neon"] = 23.84, ["Neon|Ride"] = 54.64, ["Neon|Fly|Ride"] = 216.58, ["Mega"] = 198.93, ["Mega|Fly"] = 775.28, ["Mega|Ride"] = 224.87, ["Mega|Fly|Ride"] = 265.13}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 34.1, ["Ride"] = 15.44, ["Neon"] = 9.19, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 30.75, ["Neon|Fly|Ride"] = 74.81, ["Mega"] = 274.31, ["Mega|Ride"] = 195.57, ["Mega|Fly|Ride"] = 205.48}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 14.22, ["Ride"] = 34.12, ["Fly|Ride"] = 48.57, ["Neon"] = 118.13, ["Neon|Fly|Ride"] = 308.2, ["Mega"] = 557.82, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 737.61}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.05, ["Fly|Ride"] = 410.99, ["Neon"] = 2.1, ["Neon|Ride"] = 45.23, ["Neon|Fly|Ride"] = 157.5, ["Mega|Ride"] = 104.89, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 525, ["Fly"] = 659.61, ["Ride"] = 538.12, ["Fly|Ride"] = 685.3, ["Neon"] = 2589.57, ["Neon|Fly|Ride"] = 2367.46, ["Mega|Fly|Ride"] = 7861.88}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.63, ["Fly"] = 102.76, ["Ride"] = 72.19, ["Fly|Ride"] = 310.36, ["Neon"] = 12.38, ["Neon|Ride"] = 74.61, ["Mega|Ride"] = 156.54}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.05, ["Ride"] = 27.46, ["Neon"] = 4.51, ["Neon|Fly"] = 233.21, ["Neon|Ride"] = 209.24, ["Neon|Fly|Ride"] = 131.25, ["Mega|Ride"] = 137.68, ["Mega|Fly|Ride"] = 347.24}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.05, ["Ride"] = 48.93, ["Neon"] = 3.91, ["Neon|Ride"] = 44.01, ["Neon|Fly|Ride"] = 137.68, ["Mega"] = 100.69, ["Mega|Fly"] = 152.06, ["Mega|Ride"] = 97.13, ["Mega|Fly|Ride"] = 145.68}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 3.94, ["Ride"] = 131.25, ["Neon"] = 15.43, ["Mega"] = 205.48, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 26.7, ["Fly"] = 98.44, ["Ride"] = 42, ["Fly|Ride"] = 137.69, ["Neon"] = 129.55, ["Neon|Ride"] = 137.22, ["Neon|Fly|Ride"] = 273.28, ["Mega"] = 581.18, ["Mega|Ride"] = 443.5, ["Mega|Fly|Ride"] = 631.19}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 16.05, ["Ride"] = 57.24, ["Fly|Ride"] = 137.69, ["Neon"] = 84, ["Neon|Ride"] = 140.34, ["Neon|Fly|Ride"] = 246.57, ["Mega"] = 477.23, ["Mega|Fly"] = 548.59, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 572.24}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly"] = 19.58, ["Ride"] = 13.22, ["Fly|Ride"] = 31.49, ["Neon"] = 23.93, ["Neon|Ride"] = 36.21, ["Neon|Fly|Ride"] = 70.88, ["Mega"] = 299.92, ["Mega|Ride"] = 274.31, ["Mega|Fly|Ride"] = 235.14}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 8.97, ["Ride"] = 65.63, ["Fly|Ride"] = 119.18, ["Neon"] = 113.02, ["Neon|Ride"] = 135.61, ["Mega|Ride"] = 308.2}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Fly"] = 157.5, ["Ride"] = 20.63, ["Fly|Ride"] = 111.55, ["Neon"] = 11.82, ["Neon|Ride"] = 25.99, ["Neon|Fly|Ride"] = 152.37, ["Mega"] = 78.75, ["Mega|Ride"] = 115.49, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 17.06, ["Ride"] = 19.69, ["Fly|Ride"] = 77.42, ["Neon"] = 410.93, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 189.67, ["Mega"] = 923.54}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 28.88, ["Fly"] = 874.13, ["Neon"] = 260.95, ["Mega"] = 409.9, ["Mega|Ride"] = 435.59, ["Mega|Fly|Ride"] = 622.79}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 43.32, ["Fly"] = 115.39, ["Ride"] = 77.16, ["Fly|Ride"] = 137.69, ["Neon"] = 210, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 418.97, ["Mega|Ride"] = 1643.54, ["Mega|Fly|Ride"] = 1639.57}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 39.37, ["Fly"] = 291.38, ["Ride"] = 76.56, ["Fly|Ride"] = 200.36, ["Neon"] = 131.25, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 575.37, ["Mega"] = 755.53, ["Mega|Ride"] = 715, ["Mega|Fly|Ride"] = 619.88}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 15.43, ["Ride"] = 56.44, ["Fly|Ride"] = 205.48, ["Neon"] = 152.06, ["Neon|Ride"] = 284.82, ["Mega"] = 1050, ["Mega|Ride"] = 775.28, ["Mega|Fly|Ride"] = 821.85}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 9.19, ["Fly"] = 428.28, ["Ride"] = 57.18, ["Fly|Ride"] = 118.13, ["Neon"] = 124.69, ["Neon|Fly"] = 420, ["Neon|Ride"] = 134.58, ["Neon|Fly|Ride"] = 259.88, ["Mega"] = 531.74, ["Mega|Ride"] = 522.52, ["Mega|Fly|Ride"] = 584.87}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.05, ["Fly"] = 17.91, ["Ride"] = 15.09, ["Fly|Ride"] = 32.06, ["Neon"] = 6.09, ["Neon|Fly"] = 26.75, ["Neon|Ride"] = 13.13, ["Neon|Fly|Ride"] = 48.4, ["Mega"] = 65.63, ["Mega|Fly"] = 155.76, ["Mega|Ride"] = 77.89, ["Mega|Fly|Ride"] = 395.73}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1890}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 59.06, ["Ride"] = 103.69, ["Fly|Ride"] = 410.99, ["Neon"] = 312.45, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 1507.04, ["Mega|Ride"] = 1095.1, ["Mega|Fly|Ride"] = 1177.29}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 79.71, ["Neon"] = 3.94, ["Neon|Ride"] = 43.18, ["Neon|Fly|Ride"] = 287.66, ["Mega|Ride"] = 84.93}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 28.18, ["Ride"] = 52.5, ["Fly|Ride"] = 137.69, ["Neon"] = 130.48, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 667.79, ["Mega|Ride"] = 599.24, ["Mega|Fly|Ride"] = 556.67}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.05, ["Neon"] = 2.1, ["Mega"] = 23.57}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.05, ["Neon"] = 2.52, ["Mega"] = 21.17, ["Mega|Ride"] = 139.5}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 109.29, ["Fly"] = 349.34, ["Ride"] = 118.13, ["Fly|Ride"] = 271.69, ["Neon"] = 582.75, ["Neon|Ride"] = 588, ["Neon|Fly|Ride"] = 766.38, ["Mega|Ride"] = 2534.34, ["Mega|Fly|Ride"] = 1643.67}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.05, ["Fly"] = 65.62, ["Ride"] = 18.75, ["Fly|Ride"] = 93.01, ["Neon"] = 6.39, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 99.74, ["Mega"] = 90.15, ["Mega|Ride"] = 109.81, ["Mega|Fly|Ride"] = 281.71}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 64.13, ["Fly|Ride"] = 86.63, ["Neon"] = 2.15, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 137.68, ["Mega"] = 32.82, ["Mega|Ride"] = 123.3}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.05, ["Neon"] = 4.03, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 210, ["Mega"] = 52.5, ["Mega|Ride"] = 275.33}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.05, ["Ride"] = 27.85, ["Neon"] = 5.29, ["Neon|Ride"] = 155.6, ["Mega"] = 65.54, ["Mega|Ride"] = 205.48}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 51.75, ["Ride"] = 133.84, ["Fly|Ride"] = 1027.3, ["Neon"] = 424.07, ["Neon|Ride"] = 548.59, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1779.27, ["Mega|Ride"] = 1540.95, ["Mega|Fly|Ride"] = 1507.04}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 6.45, ["Ride"] = 69.77, ["Neon"] = 59.6, ["Neon|Ride"] = 157.55, ["Mega"] = 464.94, ["Mega|Ride"] = 890.68, ["Mega|Fly|Ride"] = 545.74}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.05}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.05}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 347.82, ["Ride"] = 478.79, ["Fly|Ride"] = 748.64, ["Neon"] = 918.75, ["Neon|Ride"] = 959.51, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Ride"] = 3561.63, ["Mega|Fly|Ride"] = 3698.25}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.05}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 86.62}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 45.94}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 25.66}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 15.75}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 122.66}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 72.19}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 10.81}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 5.5}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 236.25}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 25.71}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.05}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 29.75}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 6.36}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 5.35}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 577.49}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 9.03}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 4.77}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 3.61}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 5.8}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 6.46}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 450.02}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.63}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 584.21}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 10.07}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1038.98}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.63}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 5.92}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.63}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 21.25}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.45}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 24.42}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 30.19}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 45.69}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 18.41}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 12.79}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 17.32}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 6.22}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 18.05}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 3.81}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 16.49}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 131.72}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 19.38}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 5.01}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 1968.75}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 32.48}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 271.63}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 2.9}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 3.93}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 8.96}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 6.57}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 46.4}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 185.43}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 8.29}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 6.55}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 1181.25}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 27.18}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 5.93}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 24.5}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 3.94}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 5.08}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 215.78}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 18.37}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 8.13}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.59}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 20.68}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 7.62}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 3.61}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 24.17}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 78.56}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 210}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 3.55}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 5.44}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 97.95}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 24.57}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 73.57}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 19.85}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.63}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22142.7}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 311.33}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 74.7}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 41.89}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 31.62}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 37.01}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 31.15}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 31.17}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 79.33}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 108.92}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 60.9}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 52.5}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 109.49}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 40.64}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 6883.7}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 6.02}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 7.86}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.51}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 5.25}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 28.7}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 109.01}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.1}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 3.28}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 3.93}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 3.5}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 8.38}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 755.54}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 9.8}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 583.74}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 11.46}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.63}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.6}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.63}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 604.5}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 28.58}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 115.31}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 18.4}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 44.37}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 11.79}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 3.94}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 7.88}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.1}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 15.73}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 2.46}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 28.48}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 3.46}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 6.18}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 8.65}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 19.07}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 230.9}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 48.3}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 3.33}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 1047.96}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 7.49}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 4.87}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 7.88}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 21.66}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 10.87}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 6.57}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 10.46}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 7.88}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 5.55}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 24.31}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 19.59}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 4.16}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 2.87}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 4.46}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 7.48}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 6.55}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.05}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.05}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 3.71}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 2.61}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.62}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 3.5}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.05}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 6.41}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.05}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 7808.38}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 8.24}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 15.65}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 8.69}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 6.23}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 9.11}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.05}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 8.87}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 2.46}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 3.56}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.63}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.05}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 30.17}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.05}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 6.49}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 3.61}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 2.2}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 2.35}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 6.18}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.05}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4301.15}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 7.28}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 27.2}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 6.36}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 2.44}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 58.05}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 3.92}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 104.9}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.05}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 10.02}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 3.05}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.05}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 2.1}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.05}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 7.07}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 23.09}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.9}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.45}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 15.33}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.05}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.05}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 2.46}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.62}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.05}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 4.76}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.43}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 24.68}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 3.5}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 8.56}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 78.66}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.51}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 61.73}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 4.2}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 2.43}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1023.54}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 27.36}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.62}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 5.01}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.05}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 3.97}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 15.43}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.63}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 5.24}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.51}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 3.92}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 10.4}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 8.9}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 12.5}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.33}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.43}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 3.49}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 2.3}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 11.46}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 6.28}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.14}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 18.4}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 2.63}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 11.82}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 17.64}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 45.75}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 3.94}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 24.5}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 61.67}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 4.99}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 6.18}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 68.85}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 26.4}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.14}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 3.71}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 2.14}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 3.93}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 3.03}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 3.13}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 74.42}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 142.95}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 3.75}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1013.8}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 3.71}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 160.23}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 2.62}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.63}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.63}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 196.88}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 63}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.43}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 2.24}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 3.47}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.63}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 31.5}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 15.21}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 7.39}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 7.88}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.63}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 3.61}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 3.94}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 67.18}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 2.17}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 60.38}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.2}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 10.13}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 3.34}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 20.79}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 132.57}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 3.94}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 74.07}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 3.94}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 3.4}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.63}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 4.34}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 55.13}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 50.09}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 64.43}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 167.35}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 3.13}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 137.69}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 115.89}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.51}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.14}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 3.56}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 5.86}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 22.91}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 62.72}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 3.72}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 51.35}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 2.14}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 46.34}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 13.44}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 55.44}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 22.91}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 20.26}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 44.63}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 4.34}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 4.58}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 31.86}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 3.93}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 10.38}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 46.6}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.62}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 36.85}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 25.1}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1783.42}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 9.16}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 8.25}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 37.05}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 377.08}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 17.94}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 8.25}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 9.19}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 5.92}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 7.55}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 275.51}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 48.47}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 42}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 7.45}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 6.18}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 73.84}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 146.57}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 62.99}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 1155}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 155.09}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 12.35}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 2361.19}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 551.24}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 2.51}},
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