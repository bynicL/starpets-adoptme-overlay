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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 982.56, ["Ride"] = 853.13, ["Fly|Ride"] = 1050, ["Neon"] = 6495.34, ["Neon|Ride"] = 3014.07, ["Neon|Fly|Ride"] = 3921.75, ["Mega|Fly|Ride"] = 24654.93}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 498.74, ["Fly"] = 551.25, ["Ride"] = 457.72, ["Fly|Ride"] = 569.55, ["Neon|Fly|Ride"] = 2192.25, ["Mega"] = 10272.89}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 5512.5, ["Ride"] = 5197.5, ["Fly|Ride"] = 4395.57, ["Neon|Fly|Ride"] = 19861.59, ["Mega|Fly|Ride"] = 68486.22}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 105, ["Ride"] = 183.75, ["Fly|Ride"] = 231, ["Neon"] = 773.66, ["Neon|Ride"] = 485.63, ["Neon|Fly|Ride"] = 1096.13, ["Mega"] = 4109.17, ["Mega|Fly|Ride"] = 2887.5}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 493.77, ["Fly"] = 821.85, ["Ride"] = 551.25, ["Fly|Ride"] = 570.94, ["Neon|Ride"] = 1785, ["Neon|Fly|Ride"] = 1626.35, ["Mega|Fly|Ride"] = 6805.02}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 9.07, ["Ride"] = 27.57, ["Fly|Ride"] = 152.06, ["Neon"] = 72.19, ["Neon|Ride"] = 109.05, ["Neon|Fly|Ride"] = 274.31, ["Mega"] = 285.27, ["Mega|Ride"] = 262.49, ["Mega|Fly|Ride"] = 303.19}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 3.9, ["Fly"] = 33.67, ["Ride"] = 31.68, ["Fly|Ride"] = 57.17, ["Neon"] = 26.25, ["Neon|Fly"] = 68.85, ["Neon|Ride"] = 53.39, ["Neon|Fly|Ride"] = 101.72, ["Mega"] = 131.03, ["Mega|Fly"] = 271.43, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 269.07}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 139.73, ["Ride"] = 162.32, ["Fly|Ride"] = 233.63, ["Neon"] = 656.25, ["Neon|Ride"] = 594.81, ["Neon|Fly|Ride"] = 463.97, ["Mega"] = 1436.16, ["Mega|Fly|Ride"] = 2637.07}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 31.31, ["Fly"] = 81.61, ["Ride"] = 51.17, ["Fly|Ride"] = 95.82, ["Neon"] = 262.5, ["Neon|Ride"] = 233.21, ["Neon|Fly|Ride"] = 241.42, ["Mega"] = 1370.41, ["Mega|Ride"] = 829.5, ["Mega|Fly|Ride"] = 1284.01}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 19.69, ["Fly"] = 49.38, ["Ride"] = 36.74, ["Fly|Ride"] = 65.63, ["Neon"] = 192.12, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 262.5, ["Mega|Ride"] = 1334.47, ["Mega|Fly|Ride"] = 924.58}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 59.07, ["Fly"] = 206.07, ["Ride"] = 80.75, ["Fly|Ride"] = 137.68, ["Neon"] = 262.5, ["Neon|Fly"] = 408.89, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 343.13}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 59.99}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 363.67, ["Fly"] = 395.01, ["Ride"] = 351.74, ["Fly|Ride"] = 396.38, ["Neon"] = 1370.41, ["Neon|Ride"] = 1260.79, ["Neon|Fly|Ride"] = 1142.19, ["Mega|Fly|Ride"] = 4835.45}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 110.25, ["Fly"] = 122.22, ["Ride"] = 102.65, ["Fly|Ride"] = 140.04, ["Neon|Fly"] = 579.96, ["Neon|Ride"] = 564.38, ["Neon|Fly|Ride"] = 525, ["Mega|Fly|Ride"] = 2628.3}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.63, ["Fly"] = 114.05, ["Ride"] = 51.85, ["Fly|Ride"] = 205.48, ["Neon"] = 20.56, ["Neon|Fly"] = 96.41, ["Neon|Ride"] = 137.68, ["Neon|Fly|Ride"] = 137.68, ["Mega"] = 149.63, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 383.94}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 129.94, ["Fly"] = 144.42, ["Ride"] = 144.38, ["Fly|Ride"] = 220.84, ["Neon"] = 927.91, ["Neon|Fly"] = 685.21, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 525, ["Mega|Fly|Ride"] = 2214.19}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 2.63, ["Fly"] = 26.7, ["Ride"] = 20.99, ["Fly|Ride"] = 39.37, ["Neon"] = 26.25, ["Neon|Ride"] = 90.42, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 334.69, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 332.07}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 89.12, ["Fly"] = 262.5, ["Ride"] = 135.81, ["Fly|Ride"] = 246.57, ["Neon"] = 343.01, ["Neon|Fly"] = 463.97, ["Neon|Ride"] = 288.74, ["Neon|Fly|Ride"] = 426.57, ["Mega"] = 1493.68, ["Mega|Ride"] = 840, ["Mega|Fly|Ride"] = 1102.5}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 30.66}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 43.32, ["Ride"] = 124.69, ["Fly|Ride"] = 255.29, ["Neon"] = 577.5, ["Neon|Fly|Ride"] = 2362.5}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 12.37, ["Fly"] = 393.75, ["Ride"] = 39.44, ["Fly|Ride"] = 223.13, ["Neon"] = 65.63, ["Neon|Ride"] = 164.38, ["Neon|Fly|Ride"] = 246.57, ["Mega"] = 2667.74, ["Mega|Ride"] = 577.35, ["Mega|Fly|Ride"] = 548.59}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 42.82, ["Fly"] = 76.13, ["Ride"] = 52.29, ["Fly|Ride"] = 105, ["Neon"] = 238.92, ["Neon|Ride"] = 190.32, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1623.84, ["Mega|Fly|Ride"] = 826.88}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 31.5, ["Fly"] = 274.31, ["Ride"] = 124.13, ["Fly|Ride"] = 136.5, ["Neon"] = 204.75, ["Neon|Fly"] = 385.09, ["Neon|Ride"] = 294.84, ["Neon|Fly|Ride"] = 328.75, ["Mega"] = 1067.37, ["Mega|Ride"] = 1228.65, ["Mega|Fly|Ride"] = 1005.63}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 27.76, ["Ride"] = 40.07, ["Fly|Ride"] = 131.24, ["Neon"] = 343.13, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 315, ["Mega"] = 768.43, ["Mega|Ride"] = 2052.54, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 39.38, ["Fly"] = 136.75, ["Ride"] = 69.57, ["Fly|Ride"] = 137.82, ["Neon"] = 210, ["Neon|Fly"] = 549.62, ["Neon|Ride"] = 294.62, ["Neon|Fly|Ride"] = 367.38, ["Mega|Ride"] = 1124.82, ["Mega|Fly|Ride"] = 850.53}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 5.96, ["Fly"] = 34.94, ["Ride"] = 22.29, ["Fly|Ride"] = 52.5, ["Neon"] = 27.75, ["Neon|Fly"] = 104.99, ["Neon|Ride"] = 44.51, ["Neon|Fly|Ride"] = 91.87, ["Mega"] = 129.94, ["Mega|Fly"] = 22427.05, ["Mega|Ride"] = 178.5, ["Mega|Fly|Ride"] = 298.6}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 393.75, ["Ride"] = 410.05, ["Fly|Ride"] = 441.23, ["Neon|Ride"] = 1689.18, ["Neon|Fly|Ride"] = 1680, ["Mega|Fly|Ride"] = 7256.79}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 15.75, ["Ride"] = 20.56, ["Fly|Ride"] = 107.34, ["Neon"] = 219.19, ["Neon|Ride"] = 130.48, ["Mega|Fly|Ride"] = 912.26}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 6, ["Fly"] = 38.07, ["Ride"] = 20.65, ["Fly|Ride"] = 44.91, ["Neon"] = 49.64, ["Neon|Fly"] = 90.42, ["Neon|Ride"] = 80.14, ["Neon|Fly|Ride"] = 123.37, ["Mega|Ride"] = 410.93, ["Mega|Fly|Ride"] = 386.45}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 78.25, ["Fly"] = 106.75, ["Ride"] = 94.88, ["Fly|Ride"] = 131.25, ["Neon"] = 343.13, ["Neon|Ride"] = 385.75, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 2050.48, ["Mega|Ride"] = 7290.94, ["Mega|Fly|Ride"] = 1990.83}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 13.13, ["Ride"] = 22.61, ["Fly|Ride"] = 75.22, ["Neon"] = 151.2, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 161.44, ["Mega"] = 695.94, ["Mega|Ride"] = 767.4, ["Mega|Fly|Ride"] = 483}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 182.44, ["Fly"] = 347.24, ["Ride"] = 210, ["Fly|Ride"] = 287.44, ["Neon"] = 695.94, ["Neon|Ride"] = 656.25, ["Mega"] = 6163.75, ["Mega|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 2789.07}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 26.18}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.77, ["Fly"] = 28.73, ["Ride"] = 23.92, ["Fly|Ride"] = 64.32, ["Neon"] = 20.45, ["Neon|Fly"] = 5136.45, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 106.85, ["Mega"] = 157.5, ["Mega|Fly"] = 343.13, ["Mega|Ride"] = 273.28, ["Mega|Fly|Ride"] = 274.32}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 1368.94, ["Fly"] = 2625, ["Ride"] = 1181.25, ["Fly|Ride"] = 1312.5, ["Neon"] = 7158.38, ["Neon|Ride"] = 5906.25, ["Neon|Fly|Ride"] = 7290.94, ["Mega|Ride"] = 52194.5, ["Mega|Fly|Ride"] = 25887.67}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 10.49, ["Fly"] = 65.63, ["Ride"] = 32.8, ["Fly|Ride"] = 131.25, ["Neon"] = 77.06, ["Neon|Ride"] = 118.09, ["Neon|Fly|Ride"] = 217.81, ["Mega"] = 508.52, ["Mega|Ride"] = 659.53, ["Mega|Fly|Ride"] = 820.32}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 150.94, ["Ride"] = 152.25, ["Fly|Ride"] = 262.5, ["Neon"] = 801.29, ["Neon|Ride"] = 764.97, ["Neon|Fly|Ride"] = 959.51, ["Mega|Ride"] = 2917.51, ["Mega|Fly|Ride"] = 2726.43}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 39.38}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 15.6, ["Fly"] = 68.84, ["Ride"] = 52.28, ["Fly|Ride"] = 137.68, ["Neon"] = 81.34, ["Neon|Ride"] = 155.44, ["Neon|Fly|Ride"] = 287.66, ["Mega"] = 670.9, ["Mega|Ride"] = 1083.34, ["Mega|Fly|Ride"] = 727.27}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 116.82, ["Ride"] = 205.48, ["Fly|Ride"] = 196.88, ["Neon"] = 584.07, ["Neon|Ride"] = 795.14, ["Neon|Fly|Ride"] = 697.55, ["Mega|Fly|Ride"] = 2052.54}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 128.92, ["Ride"] = 152.25, ["Fly|Ride"] = 210, ["Neon"] = 389.45, ["Neon|Ride"] = 364.88, ["Neon|Fly|Ride"] = 525, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1781.34}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 45.45}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 50.68, ["Fly"] = 59.16, ["Ride"] = 52.18, ["Fly|Ride"] = 78.75, ["Neon"] = 616.39, ["Neon|Ride"] = 477.89, ["Neon|Fly|Ride"] = 301.46, ["Mega"] = 4109.17, ["Mega|Fly|Ride"] = 1547.44}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 6.18, ["Ride"] = 62.67, ["Fly|Ride"] = 131.25, ["Neon"] = 31.83, ["Neon|Ride"] = 123.65, ["Neon|Fly|Ride"] = 328.75, ["Mega"] = 131.25, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 274.31, ["Mega|Fly|Ride"] = 409.5}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 420, ["Fly"] = 420, ["Ride"] = 393.75, ["Fly|Ride"] = 485.63, ["Neon|Ride"] = 1701.56, ["Neon|Fly|Ride"] = 1480.59, ["Mega|Fly|Ride"] = 6286.88}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 101.07, ["Fly"] = 137.68, ["Ride"] = 104.99, ["Fly|Ride"] = 143.83, ["Neon"] = 446.25, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 531.3, ["Mega|Ride"] = 2452.15, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3711.62, ["Ride"] = 3433.5, ["Fly|Ride"] = 3542.44, ["Neon|Fly|Ride"] = 14381.03}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 41.9, ["Fly"] = 108.91, ["Ride"] = 31.34, ["Fly|Ride"] = 91.88, ["Neon"] = 393.75, ["Neon|Ride"] = 209.9, ["Neon|Fly|Ride"] = 303.07, ["Mega|Ride"] = 1179.34, ["Mega|Fly|Ride"] = 1368.36}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 63.67, ["Ride"] = 68.85, ["Fly|Ride"] = 185.59, ["Neon"] = 578.79, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 446.25, ["Mega"] = 2328.88, ["Mega|Fly|Ride"] = 1299.38}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 38.01, ["Fly"] = 78.75, ["Ride"] = 57.35, ["Fly|Ride"] = 110.97, ["Neon"] = 160.63, ["Neon|Ride"] = 170.55, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 2625, ["Mega|Ride"] = 821.21, ["Mega|Fly|Ride"] = 586.69}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 10.23}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 55.5, ["Ride"] = 47.25, ["Fly|Ride"] = 71.61, ["Neon"] = 328.13, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 542.41, ["Mega|Fly|Ride"] = 1493.63}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 32.42}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 205.48, ["Ride"] = 219.86, ["Fly|Ride"] = 274.31, ["Neon|Ride"] = 1370.41, ["Neon|Fly|Ride"] = 927.91, ["Mega|Fly|Ride"] = 4949.21}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 855.75, ["Ride"] = 938.44, ["Fly|Ride"] = 1081.5, ["Neon|Ride"] = 3557.36, ["Neon|Fly|Ride"] = 3537.64}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 7.77}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 31.19, ["Fly"] = 62.62, ["Ride"] = 38.98, ["Fly|Ride"] = 73.49, ["Neon"] = 178.5, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 183.75, ["Mega|Fly|Ride"] = 866.25}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 11.82}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 6287.02, ["Fly|Ride"] = 4655.32, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 40133.07}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 10.5, ["Fly"] = 74.7, ["Ride"] = 21, ["Fly|Ride"] = 60.38, ["Neon"] = 98.23, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 195.57, ["Mega"] = 634.47, ["Mega|Ride"] = 685.21, ["Mega|Fly|Ride"] = 598.5}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 11.52, ["Fly"] = 41.11, ["Ride"] = 30.83, ["Fly|Ride"] = 109.94, ["Neon"] = 92.52, ["Neon|Ride"] = 132.57, ["Neon|Fly|Ride"] = 244.51, ["Mega"] = 1027.3, ["Mega|Ride"] = 501.33, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 94.53, ["Fly"] = 260.36, ["Ride"] = 65.63, ["Fly|Ride"] = 72.19, ["Neon|Fly|Ride"] = 927.91, ["Mega"] = 4109.17}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 10.5, ["Ride"] = 26.25, ["Fly|Ride"] = 106.85, ["Neon"] = 93.19, ["Neon|Ride"] = 94.77, ["Neon|Fly|Ride"] = 501.37, ["Mega"] = 479.07, ["Mega|Ride"] = 501.42, ["Mega|Fly|Ride"] = 619.39}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1968.64, ["Fly"] = 1837.5, ["Ride"] = 2191.7, ["Fly|Ride"] = 1903.13, ["Neon|Fly|Ride"] = 3806.25, ["Mega|Fly|Ride"] = 13125}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 29400, ["Fly"] = 26250, ["Ride"] = 52500, ["Fly|Ride"] = 24409.88, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 68760.5, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 183750}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 16.96, ["Fly"] = 157.5, ["Ride"] = 52.43, ["Fly|Ride"] = 89.93, ["Neon"] = 247.63, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 274.2, ["Mega"] = 905.05, ["Mega|Ride"] = 603.75, ["Mega|Fly|Ride"] = 826.88}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 3.15, ["Fly"] = 55.5, ["Ride"] = 48.29, ["Fly|Ride"] = 183.75, ["Neon"] = 18.38, ["Neon|Fly"] = 134.39, ["Neon|Ride"] = 57.74, ["Neon|Fly|Ride"] = 137.68, ["Mega"] = 133.45, ["Mega|Ride"] = 192.12, ["Mega|Fly|Ride"] = 246.75}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 23.57}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 7.47, ["Ride"] = 32, ["Fly|Ride"] = 111.57, ["Neon"] = 39.38, ["Neon|Ride"] = 122.26, ["Neon|Fly|Ride"] = 463.21, ["Mega"] = 369.85, ["Mega|Ride"] = 314.99, ["Mega|Fly|Ride"] = 545.35}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 773.07, ["Ride"] = 746.82, ["Fly|Ride"] = 656.25, ["Neon"] = 2939.15, ["Neon|Ride"] = 2899.72, ["Neon|Fly|Ride"] = 2520, ["Mega|Fly|Ride"] = 10826.31}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 787.5, ["Fly"] = 962.07, ["Ride"] = 883.73, ["Fly|Ride"] = 944.99, ["Neon"] = 4109.17, ["Neon|Fly|Ride"] = 3109.31, ["Mega|Fly|Ride"] = 11215.95}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 15.58, ["Fly"] = 52.5, ["Ride"] = 39.38, ["Fly|Ride"] = 96.58, ["Neon"] = 101.07, ["Neon|Ride"] = 137.68, ["Neon|Fly|Ride"] = 220.5, ["Mega"] = 1027.05, ["Mega|Ride"] = 685.13, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 25.98}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 61.72, ["Fly"] = 93.19, ["Ride"] = 87.43, ["Fly|Ride"] = 135.28, ["Neon|Ride"] = 382.17, ["Neon|Fly|Ride"] = 315, ["Mega|Ride"] = 2011.45, ["Mega|Fly|Ride"] = 1598.63}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 61.6, ["Fly"] = 82.21, ["Ride"] = 63.66, ["Fly|Ride"] = 228.38, ["Neon"] = 328.75, ["Neon|Fly"] = 528.04, ["Neon|Ride"] = 390.38, ["Neon|Fly|Ride"] = 491.57, ["Mega"] = 1725.87, ["Mega|Fly|Ride"] = 1715.18}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 4.81, ["Fly"] = 47.28, ["Ride"] = 19.99, ["Fly|Ride"] = 68.85, ["Neon"] = 36.78, ["Neon|Fly"] = 525, ["Neon|Ride"] = 67.81, ["Neon|Fly|Ride"] = 108.94, ["Mega"] = 315, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 102.64, ["Fly"] = 114.19, ["Ride"] = 111.57, ["Fly|Ride"] = 157.5, ["Neon"] = 795.14, ["Neon|Ride"] = 394.37, ["Neon|Fly|Ride"] = 341.25, ["Mega|Fly|Ride"] = 1345.32}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 3.76, ["Ride"] = 31.34, ["Fly|Ride"] = 96.58, ["Neon"] = 45.1, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 207.38, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 17.41, ["Fly"] = 40.28, ["Ride"] = 31.5, ["Fly|Ride"] = 78.75, ["Neon"] = 109.05, ["Neon|Fly"] = 102.75, ["Neon|Ride"] = 109.19, ["Neon|Fly|Ride"] = 175.68, ["Mega"] = 726.31, ["Mega|Fly|Ride"] = 728.44}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 26.24, ["Ride"] = 62.66, ["Fly|Ride"] = 156.19, ["Neon"] = 248.07, ["Neon|Ride"] = 324.63, ["Neon|Fly|Ride"] = 260.95, ["Mega"] = 694.25, ["Mega|Ride"] = 773.66, ["Mega|Fly|Ride"] = 862.94}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 16.47, ["Fly"] = 130.79, ["Ride"] = 34.93, ["Fly|Ride"] = 68.85, ["Neon"] = 91.88, ["Neon|Ride"] = 141.79, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 819.79, ["Mega|Fly|Ride"] = 947.63}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6847.92, ["Fly"] = 6917.77, ["Ride"] = 6258, ["Fly|Ride"] = 6256.68, ["Neon"] = 30818.65, ["Neon|Fly|Ride"] = 27120.41}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 242.82, ["Fly"] = 223.13, ["Ride"] = 233.21, ["Fly|Ride"] = 266.44, ["Neon"] = 773.66, ["Neon|Fly|Ride"] = 616.88, ["Mega|Fly|Ride"] = 2089.5}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 38.83, ["Fly"] = 136.67, ["Ride"] = 64.32, ["Fly|Ride"] = 140.16, ["Neon"] = 90.56, ["Neon|Fly"] = 182.87, ["Neon|Ride"] = 111.56, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 387.9, ["Mega|Ride"] = 354.38, ["Mega|Fly|Ride"] = 478.29}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.63, ["Fly"] = 85.85, ["Ride"] = 23.12, ["Fly|Ride"] = 96.58, ["Neon"] = 22.11, ["Neon|Ride"] = 55.5, ["Neon|Fly|Ride"] = 186.98, ["Mega"] = 127.98, ["Mega|Ride"] = 187.69}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 38.57, ["Fly"] = 5257.74, ["Ride"] = 91.88, ["Fly|Ride"] = 193.59, ["Neon"] = 137.65, ["Neon|Fly"] = 326.7, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 315.39, ["Mega"] = 414.41, ["Mega|Ride"] = 545.51, ["Mega|Fly|Ride"] = 584.73}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 13991.25, ["Ride"] = 12468.75, ["Fly|Ride"] = 12337.5, ["Neon|Fly|Ride"] = 26643.75}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 165.38, ["Ride"] = 222.06, ["Fly|Ride"] = 223.13, ["Neon"] = 1407.4, ["Neon|Ride"] = 1438.21, ["Neon|Fly|Ride"] = 1378.13, ["Mega"] = 4109.17, ["Mega|Fly|Ride"] = 4383.45}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 59.16, ["Fly"] = 119.02, ["Ride"] = 52.49, ["Fly|Ride"] = 123.38, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 381.94, ["Mega|Fly|Ride"] = 2328.88}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 12.34, ["Fly"] = 28.53, ["Ride"] = 23.64, ["Fly|Ride"] = 55.5, ["Neon"] = 76.13, ["Neon|Ride"] = 68.85, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 466.4, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 333.38, ["Fly"] = 821.85, ["Ride"] = 393.74, ["Fly|Ride"] = 472.5, ["Neon"] = 1639.32, ["Neon|Ride"] = 1534.78, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 5011.13}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 5.25, ["Fly"] = 82.21, ["Ride"] = 36.75, ["Fly|Ride"] = 137.68, ["Neon"] = 26.25, ["Neon|Ride"] = 118.15, ["Neon|Fly|Ride"] = 216.91, ["Mega"] = 129.94, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 274.31, ["Fly"] = 309.7, ["Ride"] = 338.12, ["Fly|Ride"] = 315, ["Neon"] = 984.38, ["Neon|Ride"] = 603.03, ["Neon|Fly|Ride"] = 927.91, ["Mega|Fly|Ride"] = 3557.36}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 9.17, ["Fly"] = 15.74, ["Ride"] = 16.21, ["Fly|Ride"] = 35.42, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 2465.51, ["Mega|Fly|Ride"] = 683.82}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 8.73}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 63, ["Ride"] = 86.63, ["Fly|Ride"] = 410.93, ["Neon"] = 409.9, ["Neon|Fly"] = 1643.67, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 3081.75, ["Mega"] = 1130.04, ["Mega|Ride"] = 1232.76, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 14.28, ["Fly"] = 65.63, ["Ride"] = 39.38, ["Fly|Ride"] = 86.52, ["Neon"] = 96.55, ["Neon|Ride"] = 137.68, ["Neon|Fly|Ride"] = 189, ["Mega"] = 512.63, ["Mega|Ride"] = 548.59, ["Mega|Fly|Ride"] = 546}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 19.65}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 37.68, ["Fly"] = 111.57, ["Ride"] = 65.63, ["Fly|Ride"] = 309.7, ["Neon"] = 237.57, ["Neon|Ride"] = 258.54, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 821.85, ["Mega|Ride"] = 919.44, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.94, ["Ride"] = 29.23, ["Fly|Ride"] = 132.54, ["Neon"] = 21.66, ["Neon|Ride"] = 104.41, ["Neon|Fly|Ride"] = 240.4, ["Mega"] = 127.32, ["Mega|Fly|Ride"] = 462.67}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 17.25, ["Fly"] = 45.94, ["Ride"] = 30.83, ["Fly|Ride"] = 77.44, ["Neon|Ride"] = 135.61, ["Neon|Fly|Ride"] = 217.81, ["Mega|Ride"] = 560.91, ["Mega|Fly|Ride"] = 801.29}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 324.84, ["Ride"] = 384.23, ["Fly|Ride"] = 409.89, ["Neon|Fly|Ride"] = 2603.16, ["Mega|Fly|Ride"] = 8629.24}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 39.38, ["Fly"] = 102.75, ["Ride"] = 45.94, ["Fly|Ride"] = 103.67, ["Neon"] = 184.43, ["Neon|Ride"] = 181.12, ["Neon|Fly|Ride"] = 332.91, ["Mega"] = 710.9, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 616.39}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 39.29, ["Fly"] = 92.59, ["Ride"] = 72.19, ["Fly|Ride"] = 137.68, ["Neon"] = 453.05, ["Neon|Ride"] = 233.21, ["Neon|Fly|Ride"] = 236.25, ["Mega|Fly|Ride"] = 1261.52}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 23.39, ["Fly"] = 84.23, ["Ride"] = 63.67, ["Fly|Ride"] = 137.68, ["Neon"] = 110.24, ["Neon|Ride"] = 176.72, ["Neon|Fly|Ride"] = 308.2, ["Mega"] = 393.75, ["Mega|Ride"] = 396.38, ["Mega|Fly|Ride"] = 454.78}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 7218.75, ["Ride"] = 9995.9, ["Fly|Ride"] = 7875, ["Neon|Fly|Ride"] = 15607.97, ["Mega|Fly|Ride"] = 39373.95}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1509.37, ["Ride"] = 1509.38, ["Fly|Ride"] = 1548.65, ["Neon|Fly|Ride"] = 4001.82, ["Mega"] = 21916.17, ["Mega|Fly|Ride"] = 15093.75}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 496.44, ["Ride"] = 505.32, ["Fly|Ride"] = 548.59, ["Neon"] = 3780, ["Neon|Fly|Ride"] = 2233.34, ["Mega|Fly|Ride"] = 6668.13}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 13.12, ["Fly"] = 23.62, ["Ride"] = 22.31, ["Fly|Ride"] = 46.94, ["Neon"] = 82.21, ["Neon|Ride"] = 101.72, ["Neon|Fly|Ride"] = 137.68, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 6.39, ["Fly"] = 78.74, ["Ride"] = 37.94, ["Fly|Ride"] = 123.3, ["Neon"] = 21, ["Neon|Ride"] = 67.81, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 156.85, ["Mega|Ride"] = 173.25, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 37.35, ["Fly"] = 55.5, ["Ride"] = 45.93, ["Fly|Ride"] = 105.98, ["Neon"] = 262.5, ["Neon|Ride"] = 164.07, ["Neon|Fly|Ride"] = 173.25, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.88, ["Fly"] = 23.12, ["Ride"] = 17.06, ["Fly|Ride"] = 39.38, ["Neon"] = 23.71, ["Neon|Fly"] = 91.87, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 359.57, ["Mega|Ride"] = 192.12, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 305.04, ["Fly"] = 320.25, ["Ride"] = 301.88, ["Fly|Ride"] = 374.07, ["Neon"] = 1175.72, ["Neon|Fly|Ride"] = 1210.13, ["Mega|Fly|Ride"] = 3937.5}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 19.69, ["Fly"] = 60.09, ["Ride"] = 35.97, ["Fly|Ride"] = 76.13, ["Neon"] = 204.75, ["Neon|Fly"] = 410.93, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 186.98, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 14.44, ["Fly"] = 26.61, ["Ride"] = 21.17, ["Fly|Ride"] = 43.17, ["Neon"] = 85.29, ["Neon|Fly"] = 132.24, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 1575, ["Mega|Ride"] = 618.19, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 392.44, ["Fly"] = 787.5, ["Ride"] = 433.13, ["Fly|Ride"] = 644.13, ["Neon|Ride"] = 2772.67, ["Neon|Fly|Ride"] = 2319.77, ["Mega|Fly|Ride"] = 8619.19}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1130.46, ["Fly"] = 1391.87, ["Ride"] = 1232.76, ["Fly|Ride"] = 1076.25, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 154651.11}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 100.67, ["Fly"] = 128.63, ["Ride"] = 93.19, ["Fly|Ride"] = 110.24, ["Neon"] = 513.65, ["Neon|Ride"] = 585.46, ["Neon|Fly|Ride"] = 463.97, ["Mega|Ride"] = 2328.88, ["Mega|Fly|Ride"] = 3868.22}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 182.44, ["Fly"] = 164.38, ["Ride"] = 181.27, ["Fly|Ride"] = 246.57, ["Neon"] = 556.49, ["Neon|Ride"] = 665.69, ["Neon|Fly|Ride"] = 606.38, ["Mega|Ride"] = 8603.44, ["Mega|Fly|Ride"] = 2475.19}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 27.57, ["Ride"] = 62.63, ["Fly|Ride"] = 274.31, ["Neon"] = 232.74, ["Neon|Fly"] = 410.93, ["Neon|Ride"] = 272.99, ["Neon|Fly|Ride"] = 385.08, ["Mega|Ride"] = 1855.82, ["Mega|Fly|Ride"] = 754.04}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 128.63, ["Ride"] = 315, ["Fly|Ride"] = 410.93, ["Neon|Fly|Ride"] = 1299.08, ["Mega|Fly|Ride"] = 2739.79}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 1851.61, ["Ride"] = 2475.19, ["Fly|Ride"] = 2199.09, ["Neon|Fly|Ride"] = 8218.31, ["Mega|Fly|Ride"] = 24744.84}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 57.86, ["Ride"] = 65.63, ["Fly|Ride"] = 196.87, ["Neon"] = 511.88, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 343.87, ["Mega"] = 1919, ["Mega|Ride"] = 2260.06, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 617.47, ["Fly"] = 795.14, ["Ride"] = 619.5, ["Fly|Ride"] = 630, ["Neon|Ride"] = 1507.04, ["Neon|Fly|Ride"] = 1153.69, ["Mega|Fly|Ride"] = 3106.58}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 39.38, ["Fly"] = 64.32, ["Ride"] = 52.5, ["Fly|Ride"] = 102.69, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 262.5, ["Mega|Fly|Ride"] = 1181.24}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.15, ["Fly"] = 31.02, ["Ride"] = 22.64, ["Fly|Ride"] = 46.77, ["Neon"] = 27.85, ["Neon|Fly"] = 92.8, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 131.25, ["Mega|Fly"] = 249.26, ["Mega|Ride"] = 205.48, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 51.93, ["Ride"] = 105, ["Fly|Ride"] = 252, ["Neon"] = 262.5, ["Neon|Ride"] = 409.9, ["Neon|Fly|Ride"] = 619.39, ["Mega|Ride"] = 1370.41, ["Mega|Fly|Ride"] = 821.85}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 630, ["Fly"] = 899.07, ["Ride"] = 754.69, ["Fly|Ride"] = 761.25, ["Neon|Ride"] = 2421.84, ["Neon|Fly|Ride"] = 2100, ["Mega|Fly|Ride"] = 7807.41}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 577.5, ["Ride"] = 525, ["Fly|Ride"] = 876.88, ["Neon"] = 5136.45, ["Neon|Fly|Ride"] = 3286.31, ["Mega|Fly|Ride"] = 12327.48}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 14.43, ["Fly"] = 32.82, ["Ride"] = 19.69, ["Fly|Ride"] = 45.22, ["Neon"] = 205.48, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 128.62, ["Mega|Fly|Ride"] = 710.9}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 11.61, ["Ride"] = 23.63, ["Fly|Ride"] = 63.71, ["Neon"] = 72.02, ["Neon|Ride"] = 91.65, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 959.51, ["Mega|Ride"] = 504.41, ["Mega|Fly|Ride"] = 378.67}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 3.92, ["Ride"] = 26.25, ["Fly|Ride"] = 111.56, ["Neon"] = 22.31, ["Neon|Fly"] = 309.7, ["Neon|Ride"] = 52.82, ["Neon|Fly|Ride"] = 155.44, ["Mega"] = 156.89, ["Mega|Ride"] = 238.62, ["Mega|Fly|Ride"] = 302.54}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 41.11, ["Fly"] = 52.5, ["Ride"] = 47.24, ["Fly|Ride"] = 93.56, ["Neon"] = 287.66, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 236.25, ["Mega|Ride"] = 1047.85, ["Mega|Fly|Ride"] = 944.9}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 64.96, ["Ride"] = 69.57, ["Fly|Ride"] = 449.61, ["Neon"] = 415.64, ["Neon|Ride"] = 491.07, ["Neon|Fly|Ride"] = 685.21, ["Mega"] = 1540.95, ["Mega|Ride"] = 1540.95, ["Mega|Fly|Ride"] = 1322.13}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 13.89, ["Fly"] = 48.57, ["Ride"] = 37, ["Fly|Ride"] = 84, ["Neon"] = 65.63, ["Neon|Ride"] = 108.92, ["Neon|Fly|Ride"] = 200.33, ["Mega"] = 340.28, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 463.32}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 34.97, ["Fly"] = 52.5, ["Ride"] = 47.24, ["Fly|Ride"] = 108.94, ["Neon"] = 548.59, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 2100, ["Mega|Ride"] = 959.51, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.93, ["Fly"] = 27.76, ["Ride"] = 19.69, ["Fly|Ride"] = 40.69, ["Neon"] = 26.25, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 80.14, ["Mega"] = 525, ["Mega|Ride"] = 274.31, ["Mega|Fly|Ride"] = 342.18}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 5.18, ["Fly"] = 32.49, ["Ride"] = 27.76, ["Fly|Ride"] = 78.75, ["Neon"] = 25.46, ["Neon|Fly"] = 82.21, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 164.38, ["Mega"] = 416.07, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 648.38}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 42.45, ["Fly"] = 65.62, ["Ride"] = 39.38, ["Fly|Ride"] = 91.13, ["Neon"] = 402.49, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 273, ["Mega|Fly|Ride"] = 919}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1547.28, ["Ride"] = 1593.38, ["Fly|Ride"] = 1639.32, ["Neon|Ride"] = 4630, ["Neon|Fly|Ride"] = 3739.32, ["Mega|Fly|Ride"] = 16393.72}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 462, ["Fly"] = 685.21, ["Ride"] = 483.27, ["Fly|Ride"] = 548.59, ["Neon"] = 3093.41, ["Neon|Ride"] = 2568.23, ["Neon|Fly|Ride"] = 1968.75, ["Mega|Fly|Ride"] = 9586.66}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 223.13, ["Fly"] = 348.27, ["Ride"] = 274.31, ["Fly|Ride"] = 397.58, ["Neon"] = 1507.04, ["Neon|Ride"] = 1411.51, ["Neon|Fly|Ride"] = 1370.42, ["Mega|Fly|Ride"] = 6431.25}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 43.63}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 26.59, ["Ride"] = 40.98, ["Fly|Ride"] = 96.58, ["Neon"] = 328.75, ["Neon|Fly"] = 410.93, ["Neon|Ride"] = 343.13, ["Neon|Fly|Ride"] = 1968.75, ["Mega"] = 905.05, ["Mega|Ride"] = 959.51, ["Mega|Fly|Ride"] = 1038.19}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 41091.52, ["Fly"] = 20998.69, ["Ride"] = 34781.25, ["Fly|Ride"] = 17013.09, ["Neon|Fly|Ride"] = 38062.5, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 356.72, ["Fly"] = 853.69, ["Ride"] = 429.42, ["Fly|Ride"] = 436.01, ["Neon"] = 1115.63, ["Neon|Ride"] = 1207.5, ["Neon|Fly|Ride"] = 1220.63, ["Mega"] = 6027.11, ["Mega|Fly|Ride"] = 3845.62}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 171.93, ["Fly"] = 525, ["Ride"] = 136.49, ["Fly|Ride"] = 171.68, ["Mega|Fly|Ride"] = 4109.17}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 109.94, ["Fly"] = 262.5, ["Ride"] = 122.78, ["Fly|Ride"] = 177.19, ["Neon"] = 512.63, ["Neon|Ride"] = 509.73, ["Neon|Fly|Ride"] = 799.24, ["Mega|Fly|Ride"] = 2464.48}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 17.41, ["Fly"] = 94.5, ["Ride"] = 33.65, ["Fly|Ride"] = 101.51, ["Neon"] = 274.31, ["Neon|Ride"] = 135.19, ["Neon|Fly|Ride"] = 204.45, ["Mega"] = 684.2, ["Mega|Fly|Ride"] = 548.59}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 5103.48, ["Ride"] = 4930.99, ["Fly|Ride"] = 3937.5, ["Neon|Ride"] = 17807.03, ["Neon|Fly|Ride"] = 17121.83}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 21, ["Fly"] = 92.8, ["Ride"] = 39.37, ["Fly|Ride"] = 55.11, ["Neon"] = 333.94, ["Neon|Ride"] = 208.69, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 1096.13, ["Mega|Fly|Ride"] = 859.69}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 44.62, ["Fly"] = 137.68, ["Ride"] = 45.94, ["Fly|Ride"] = 107.62, ["Neon|Ride"] = 381.94, ["Neon|Fly|Ride"] = 431.82, ["Mega"] = 1547.28, ["Mega|Fly|Ride"] = 1349.87}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 656.25, ["Fly"] = 897.77, ["Ride"] = 703.5, ["Fly|Ride"] = 829.5, ["Neon"] = 2021.72, ["Neon|Ride"] = 1863.75, ["Neon|Fly|Ride"] = 1929.38, ["Mega|Ride"] = 6061.02, ["Mega|Fly|Ride"] = 4790.63}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 13.55, ["Fly"] = 27.75, ["Ride"] = 24.94, ["Fly|Ride"] = 52.5, ["Neon"] = 124.67, ["Neon|Ride"] = 105.98, ["Neon|Fly|Ride"] = 137.68, ["Mega"] = 588.08, ["Mega|Ride"] = 582.48, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 14.43, ["Fly"] = 82.21, ["Ride"] = 34.12, ["Fly|Ride"] = 463.97, ["Neon"] = 80.06, ["Neon|Ride"] = 137.68, ["Neon|Fly|Ride"] = 249.38, ["Mega|Ride"] = 520.86}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 97.13, ["Ride"] = 98.44, ["Fly|Ride"] = 196.88, ["Neon"] = 527.71, ["Neon|Ride"] = 525.35, ["Neon|Fly|Ride"] = 695.94, ["Mega|Fly|Ride"] = 2192.25}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 22.09, ["Ride"] = 101.85, ["Fly|Ride"] = 162.32, ["Neon"] = 85.32, ["Neon|Ride"] = 129.42, ["Neon|Fly|Ride"] = 243.85, ["Mega"] = 278.25, ["Mega|Fly"] = 736.54, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 959.51}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3804.21, ["Fly"] = 5032.7, ["Ride"] = 3753.75, ["Fly|Ride"] = 3772.08, ["Neon"] = 12327.48, ["Neon|Ride"] = 11472.77, ["Neon|Fly|Ride"] = 8800.4, ["Mega"] = 43033.1, ["Mega|Fly|Ride"] = 33097.12}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 39.44, ["Ride"] = 64.3, ["Fly|Ride"] = 135.61, ["Neon"] = 303.07, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 205.48, ["Mega|Ride"] = 1026.27, ["Mega|Fly|Ride"] = 1096.13}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 5891.82, ["Fly"] = 7875, ["Ride"] = 7670.77, ["Fly|Ride"] = 6300, ["Neon|Fly|Ride"] = 17500.88, ["Mega|Fly|Ride"] = 64377.06}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.63, ["Fly"] = 20.56, ["Ride"] = 16.55, ["Fly|Ride"] = 34.94, ["Neon"] = 17.07, ["Neon|Fly"] = 62.62, ["Neon|Ride"] = 45.48, ["Neon|Fly|Ride"] = 86.63, ["Mega"] = 448.89, ["Mega|Ride"] = 199.31, ["Mega|Fly|Ride"] = 282.19}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 26.25, ["Fly"] = 28.87, ["Ride"] = 30.82, ["Fly|Ride"] = 57.54, ["Neon"] = 102.75, ["Neon|Ride"] = 163.36, ["Neon|Fly|Ride"] = 178.77, ["Mega|Ride"] = 1365.68, ["Mega|Fly|Ride"] = 927.91}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.68}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 15.25, ["Ride"] = 18.38, ["Fly|Ride"] = 116.03, ["Neon"] = 192.12, ["Neon|Ride"] = 137.68, ["Neon|Fly|Ride"] = 192.94, ["Mega"] = 820.82, ["Mega|Ride"] = 959.51, ["Mega|Fly|Ride"] = 748.13}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 27.75, ["Fly"] = 190.37, ["Ride"] = 44.63, ["Fly|Ride"] = 196.88, ["Neon"] = 182.43, ["Neon|Ride"] = 130.79, ["Neon|Fly|Ride"] = 252.39, ["Mega"] = 840, ["Mega|Fly|Ride"] = 1089.38}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 14.44, ["Fly"] = 26.25, ["Ride"] = 23.15, ["Fly|Ride"] = 41.11, ["Neon|Ride"] = 106.85, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 2465.51, ["Mega|Ride"] = 578.79, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8766.9}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2715.57}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 23.63}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 177.16, ["Fly"] = 174.57, ["Ride"] = 174.57, ["Fly|Ride"] = 183.74, ["Neon|Fly|Ride"] = 1027.3}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 24.94, ["Fly"] = 123.3, ["Ride"] = 49.88, ["Fly|Ride"] = 139.2, ["Neon"] = 122.88, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 265.13, ["Mega|Ride"] = 927.91, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 8.01}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 9.19, ["Ride"] = 29.22, ["Fly|Ride"] = 68.85, ["Neon"] = 49.32, ["Neon|Ride"] = 68.85, ["Neon|Fly|Ride"] = 123.3, ["Mega|Fly|Ride"] = 485.63}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2807.21}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 154.11, ["Fly"] = 281.49, ["Ride"] = 178.5, ["Fly|Ride"] = 408.89, ["Neon"] = 712.95, ["Neon|Ride"] = 918.75, ["Mega|Ride"] = 2876.42, ["Mega|Fly|Ride"] = 3014.07}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 137.82, ["Ride"] = 197.04, ["Fly|Ride"] = 209.2, ["Neon"] = 682.5, ["Neon|Ride"] = 685.13, ["Neon|Fly|Ride"] = 1096.13, ["Mega"] = 2625, ["Mega|Ride"] = 2739.79, ["Mega|Fly|Ride"] = 3093.41}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 164.07, ["Fly"] = 186.38, ["Ride"] = 196.88, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 840, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 4520.08, ["Mega|Fly|Ride"] = 3671.55}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1561.88, ["Fly"] = 2465.51, ["Ride"] = 1532.56, ["Fly|Ride"] = 1617.9, ["Neon"] = 6805.02, ["Neon|Ride"] = 5854.52, ["Neon|Fly|Ride"] = 3937.5, ["Mega|Fly|Ride"] = 34025.01}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 15.63, ["Fly"] = 80.14, ["Ride"] = 39.38, ["Fly|Ride"] = 93.5, ["Neon"] = 135.61, ["Neon|Ride"] = 203.41, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 820.82, ["Mega|Ride"] = 890.68, ["Mega|Fly|Ride"] = 1079.7}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 656.25, ["Fly"] = 2100, ["Ride"] = 616.39, ["Fly|Ride"] = 1050, ["Neon|Fly|Ride"] = 3972.54}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 25.47}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 15.75, ["Ride"] = 48.29, ["Fly|Ride"] = 131.25, ["Neon"] = 98.44, ["Neon|Ride"] = 123.53, ["Neon|Fly|Ride"] = 273.28, ["Mega"] = 419.9, ["Mega|Ride"] = 457.95, ["Mega|Fly|Ride"] = 549.94}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 5.2, ["Fly"] = 48.29, ["Ride"] = 27.76, ["Fly|Ride"] = 94.79, ["Neon"] = 41.11, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 116.82, ["Mega|Ride"] = 344.16, ["Mega|Fly|Ride"] = 619.39}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 54.18}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 27.76, ["Fly"] = 108.92, ["Ride"] = 31.28, ["Fly|Ride"] = 82.21, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 192.12, ["Mega"] = 787.5, ["Mega|Ride"] = 1237.6, ["Mega|Fly|Ride"] = 821.85}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 23.22, ["Fly"] = 76.04, ["Ride"] = 36.75, ["Fly|Ride"] = 60.75, ["Neon|Ride"] = 218.07, ["Neon|Fly|Ride"] = 410.93, ["Mega"] = 936.04, ["Mega|Ride"] = 1739.83, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 5906.25, ["Fly"] = 6369.2, ["Ride"] = 4987.5, ["Fly|Ride"] = 4935, ["Neon|Fly|Ride"] = 10236.49, ["Mega|Fly|Ride"] = 32873.23}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 10.45, ["Fly"] = 41.11, ["Ride"] = 35.35, ["Fly|Ride"] = 78.75, ["Neon"] = 64.97, ["Neon|Ride"] = 77.44, ["Mega"] = 519.65, ["Mega|Ride"] = 511.52, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 21.18}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 90.92, ["Fly"] = 155.44, ["Ride"] = 105, ["Fly|Ride"] = 189, ["Neon"] = 485.63, ["Neon|Ride"] = 517.13, ["Neon|Fly|Ride"] = 459.38, ["Mega|Fly|Ride"] = 1850.37}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 51.97, ["Fly"] = 77.44, ["Ride"] = 92.44, ["Fly|Ride"] = 123.3, ["Neon"] = 343.13, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 463.32, ["Mega"] = 2319.77, ["Mega|Ride"] = 1438.21, ["Mega|Fly|Ride"] = 1415.63}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 21.96, ["Fly"] = 70.45, ["Ride"] = 29.91, ["Fly|Ride"] = 45.94, ["Neon"] = 131.51, ["Neon|Ride"] = 185.59, ["Neon|Fly|Ride"] = 177.19, ["Mega|Ride"] = 726.31, ["Mega|Fly|Ride"] = 656.23}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 5.13, ["Fly"] = 57.8, ["Ride"] = 30.82, ["Fly|Ride"] = 82.69, ["Neon"] = 31.2, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 54.43, ["Neon|Fly|Ride"] = 124.68, ["Mega"] = 157.5, ["Mega|Fly"] = 6848.94, ["Mega|Ride"] = 205.48, ["Mega|Fly|Ride"] = 300.57}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 12.59, ["Ride"] = 30.41, ["Fly|Ride"] = 96.58, ["Neon"] = 93.5, ["Neon|Ride"] = 122.22, ["Neon|Fly|Ride"] = 150.94, ["Mega"] = 479.76, ["Mega|Ride"] = 485.63, ["Mega|Fly|Ride"] = 548.59}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 15.65, ["Fly"] = 27.87, ["Ride"] = 27.55, ["Fly|Ride"] = 52.5, ["Neon"] = 203.41, ["Neon|Fly"] = 101.07, ["Neon|Ride"] = 145.69, ["Neon|Fly|Ride"] = 139.73, ["Mega|Fly|Ride"] = 648.26}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 189}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 20.56, ["Ride"] = 89.39, ["Neon"] = 170.63, ["Mega"] = 1326.24, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 782.25}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 137.68, ["Fly"] = 216.91, ["Ride"] = 387.41, ["Fly|Ride"] = 410.93, ["Neon"] = 1096.13}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 35.97, ["Fly"] = 212, ["Ride"] = 96.58, ["Fly|Ride"] = 200.33, ["Neon"] = 242.82, ["Neon|Ride"] = 274.31, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 1237.6, ["Mega|Ride"] = 1096.13, ["Mega|Fly|Ride"] = 1209.64}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 917.44, ["Fly"] = 1118.37, ["Ride"] = 787.5, ["Fly|Ride"] = 853.13, ["Neon|Ride"] = 2575.42, ["Neon|Fly|Ride"] = 2428.13, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 282.19, ["Fly"] = 463.97, ["Ride"] = 328.13, ["Fly|Ride"] = 374.07, ["Neon"] = 1181.25, ["Neon|Ride"] = 2011.25, ["Neon|Fly|Ride"] = 1916.94, ["Mega|Fly|Ride"] = 6301.4}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 48.63}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.63}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 12.46, ["Fly"] = 27.76, ["Ride"] = 27.57, ["Fly|Ride"] = 42, ["Neon"] = 77.95, ["Neon|Fly"] = 116.26, ["Neon|Ride"] = 96.58, ["Neon|Fly|Ride"] = 155.44, ["Mega"] = 437.26, ["Mega|Ride"] = 684.2, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 285.84, ["Fly"] = 762.36, ["Ride"] = 301.75, ["Fly|Ride"] = 383.34, ["Neon"] = 1024.23, ["Neon|Ride"] = 894.52, ["Neon|Fly|Ride"] = 946.38, ["Mega|Ride"] = 3492.8, ["Mega|Fly|Ride"] = 2756.25}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 16.21}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 131.25, ["Fly"] = 265.06, ["Ride"] = 203.36, ["Fly|Ride"] = 301.88, ["Neon"] = 721.88, ["Neon|Fly"] = 1643.67, ["Neon|Ride"] = 748.13, ["Neon|Fly|Ride"] = 888.32, ["Mega"] = 2310, ["Mega|Ride"] = 11686.45, ["Mega|Fly|Ride"] = 2572.5}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 131.25, ["Ride"] = 131.25, ["Fly|Ride"] = 157.5, ["Neon"] = 671.86, ["Neon|Ride"] = 1005.38, ["Neon|Fly|Ride"] = 924.58}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 4.73, ["Ride"] = 24.67, ["Fly|Ride"] = 167.47, ["Neon"] = 30.18, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 233.21, ["Mega|Ride"] = 356.49, ["Mega|Fly|Ride"] = 654.94}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 15.12, ["Fly"] = 63, ["Ride"] = 27.76, ["Fly|Ride"] = 76.27, ["Neon"] = 211.63, ["Neon|Ride"] = 109.94, ["Neon|Fly|Ride"] = 255.94, ["Mega|Ride"] = 561.75, ["Mega|Fly|Ride"] = 577.31}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 18.19, ["Fly"] = 102.32, ["Ride"] = 45.94, ["Fly|Ride"] = 128.84, ["Neon"] = 137.68, ["Neon|Ride"] = 130.87, ["Neon|Fly|Ride"] = 254.78, ["Mega"] = 461.16, ["Mega|Ride"] = 474.04, ["Mega|Fly|Ride"] = 685.82}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 5.18, ["Fly"] = 123.3, ["Ride"] = 55.5, ["Fly|Ride"] = 162.87, ["Neon"] = 23.22, ["Neon|Fly"] = 231.99, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 147, ["Mega"] = 137.82, ["Mega|Ride"] = 178.77, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 268.44, ["Fly"] = 274.31, ["Ride"] = 282.19, ["Fly|Ride"] = 315, ["Neon"] = 1507.04, ["Neon|Ride"] = 1454.51, ["Neon|Fly|Ride"] = 1404.38, ["Mega|Fly|Ride"] = 5189.87}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 137.68, ["Fly"] = 1050, ["Ride"] = 182.43, ["Fly|Ride"] = 305.68, ["Neon"] = 753.38, ["Neon|Ride"] = 551.25, ["Neon|Fly|Ride"] = 812.44, ["Mega"] = 2625, ["Mega|Ride"] = 3972.54, ["Mega|Fly|Ride"] = 2443.77}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 55.09, ["Fly"] = 167.45, ["Ride"] = 91.56, ["Fly|Ride"] = 108.91, ["Neon"] = 471.54, ["Neon|Ride"] = 405.79, ["Neon|Fly|Ride"] = 453.05, ["Mega|Ride"] = 1697.09, ["Mega|Fly|Ride"] = 1509.67}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 13.13, ["Ride"] = 57.75, ["Fly|Ride"] = 246.57, ["Neon|Ride"] = 589.23, ["Neon|Fly|Ride"] = 479.76, ["Mega|Ride"] = 616.39, ["Mega|Fly|Ride"] = 1641.62}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 15.75, ["Fly"] = 75.63, ["Ride"] = 40.07, ["Fly|Ride"] = 102.38, ["Neon"] = 77.44, ["Neon|Fly"] = 205.48, ["Neon|Ride"] = 90.86, ["Neon|Fly|Ride"] = 192.57, ["Mega"] = 346.5, ["Mega|Fly"] = 525, ["Mega|Ride"] = 341.08, ["Mega|Fly|Ride"] = 448.88}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 2.63, ["Fly"] = 52.45, ["Ride"] = 20.9, ["Fly|Ride"] = 98.44, ["Neon"] = 22.04, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 39.04, ["Neon|Fly|Ride"] = 109.94, ["Mega"] = 129.94, ["Mega|Ride"] = 162.74, ["Mega|Fly|Ride"] = 220.49}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 773.66, ["Fly"] = 1082.72, ["Ride"] = 892.5, ["Fly|Ride"] = 947.79, ["Neon|Fly"] = 3403.1, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 7335.56}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 364.24, ["Ride"] = 412.13, ["Fly|Ride"] = 485.63, ["Neon|Ride"] = 2465.51, ["Neon|Fly|Ride"] = 1922.33, ["Mega"] = 10272.89, ["Mega|Fly|Ride"] = 8218.31}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 88.34, ["Fly"] = 131.25, ["Ride"] = 96.58, ["Fly|Ride"] = 182.87, ["Neon"] = 314.37, ["Neon|Ride"] = 287.66, ["Neon|Fly|Ride"] = 405.79, ["Mega"] = 1577.45, ["Mega|Ride"] = 2134.19, ["Mega|Fly|Ride"] = 1538.9}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 306.14, ["Fly"] = 463.97, ["Ride"] = 258.57, ["Fly|Ride"] = 301.88, ["Neon"] = 1391.87, ["Neon|Fly|Ride"] = 1368.68, ["Mega"] = 10272.89, ["Mega|Fly|Ride"] = 4930.99}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 19.49, ["Fly"] = 137.68, ["Ride"] = 33.13, ["Fly|Ride"] = 65.63, ["Neon"] = 169.32, ["Neon|Ride"] = 185.59, ["Neon|Fly|Ride"] = 229.69, ["Mega|Fly|Ride"] = 773.66}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 218.3, ["Ride"] = 275.63, ["Fly|Ride"] = 545.42, ["Neon"] = 849.58, ["Neon|Ride"] = 942.38, ["Neon|Fly|Ride"] = 912.84, ["Mega"] = 3093.41, ["Mega|Ride"] = 4246.82, ["Mega|Fly|Ride"] = 3800.97}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 60.38, ["Fly"] = 76.13, ["Ride"] = 62.43, ["Fly|Ride"] = 120.91, ["Neon|Ride"] = 493.12, ["Neon|Fly|Ride"] = 445.86, ["Mega|Fly|Ride"] = 1546.13}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1706.25, ["Ride"] = 1509.38, ["Fly|Ride"] = 1575, ["Neon|Ride"] = 10826.31, ["Neon|Fly|Ride"] = 4794.37, ["Mega"] = 49309.83, ["Mega|Fly|Ride"] = 21914.11}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 17.41, ["Fly"] = 63.71, ["Ride"] = 40.69, ["Fly|Ride"] = 90.87, ["Neon"] = 67.71, ["Neon|Fly"] = 184.7, ["Neon|Ride"] = 94.5, ["Neon|Fly|Ride"] = 213.69, ["Mega"] = 310.01, ["Mega|Fly"] = 374.07, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 426.84}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 41.91, ["Fly"] = 119.1, ["Ride"] = 72.19, ["Fly|Ride"] = 161.44, ["Neon"] = 315.39, ["Neon|Ride"] = 278.41, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 817.74, ["Mega|Ride"] = 1005.74, ["Mega|Fly|Ride"] = 821.85}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 85.32, ["Fly"] = 82.29, ["Ride"] = 88.35, ["Fly|Ride"] = 102.38, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 3422.93, ["Fly"] = 1181.25, ["Ride"] = 2316.57, ["Fly|Ride"] = 1286.25, ["Neon|Fly|Ride"] = 4295.17, ["Mega|Fly|Ride"] = 27394.7}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 480.77, ["Fly"] = 819.79, ["Ride"] = 493.12, ["Fly|Ride"] = 616.39, ["Neon"] = 2166.66, ["Neon|Fly|Ride"] = 2707.17, ["Mega|Fly|Ride"] = 13918.55}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 85.32, ["Fly"] = 309.7, ["Ride"] = 152.25, ["Fly|Ride"] = 206.07, ["Neon"] = 444.29, ["Neon|Fly"] = 616.39, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 618.57, ["Mega"] = 4109.17, ["Mega|Ride"] = 2603.16, ["Mega|Fly|Ride"] = 2054.59}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 10.18, ["Ride"] = 26.17, ["Fly|Ride"] = 91.68, ["Neon"] = 82.36, ["Neon|Ride"] = 93.56, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 747.53, ["Mega|Fly|Ride"] = 1162.9}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 39.62, ["Ride"] = 48.29, ["Fly|Ride"] = 122.73, ["Neon"] = 204.75, ["Neon|Fly"] = 410.93, ["Neon|Ride"] = 177.19, ["Neon|Fly|Ride"] = 288.75, ["Mega|Ride"] = 1334.47, ["Mega|Fly|Ride"] = 1010.63}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 641.82, ["Ride"] = 808.5, ["Fly|Ride"] = 785.53, ["Neon"] = 3012.02, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2508.42, ["Mega|Fly|Ride"] = 15068.27}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 727.13}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 5602.85, ["Ride"] = 5315.21, ["Fly|Ride"] = 4344.38, ["Neon"] = 42000, ["Neon|Ride"] = 29443.11, ["Neon|Fly|Ride"] = 21638.8, ["Mega|Fly|Ride"] = 87662.6}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 131.25, ["Fly"] = 402.74, ["Ride"] = 287.66, ["Fly|Ride"] = 367.5, ["Neon"] = 1246.88, ["Neon|Ride"] = 1237.6, ["Neon|Fly|Ride"] = 1951.86, ["Mega"] = 5752.83, ["Mega|Fly|Ride"] = 5890.48}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 78.75, ["Ride"] = 39.38, ["Fly|Ride"] = 336, ["Neon"] = 410.93, ["Neon|Ride"] = 493.12, ["Neon|Fly|Ride"] = 1096.13, ["Mega|Fly|Ride"] = 2099.99}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 17.07, ["Fly"] = 96.55, ["Ride"] = 34.36, ["Fly|Ride"] = 109.94, ["Neon"] = 147, ["Neon|Ride"] = 93.5, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 616.39, ["Mega|Ride"] = 575.3, ["Mega|Fly|Ride"] = 628.69}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 19.22, ["Fly"] = 39.38, ["Ride"] = 26.97, ["Fly|Ride"] = 49.88, ["Neon"] = 200.63, ["Neon|Ride"] = 68.85, ["Neon|Fly|Ride"] = 123.3, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 2177.87}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 14.42, ["Ride"] = 40.06, ["Fly|Ride"] = 91.88, ["Neon"] = 100.69, ["Neon|Ride"] = 155.44, ["Neon|Fly|Ride"] = 181.56, ["Mega"] = 549.94, ["Mega|Ride"] = 479.07, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 3.94, ["Fly"] = 55.5, ["Ride"] = 22.32, ["Fly|Ride"] = 57.75, ["Neon"] = 22.32, ["Neon|Ride"] = 46.5, ["Neon|Fly|Ride"] = 185.59, ["Mega"] = 199.31, ["Mega|Ride"] = 217.81, ["Mega|Fly|Ride"] = 308.2}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 26.25, ["Ride"] = 49.32, ["Fly|Ride"] = 183.75, ["Neon"] = 269.16, ["Neon|Fly"] = 821.85, ["Neon|Ride"] = 155.44, ["Neon|Fly|Ride"] = 360.6, ["Mega"] = 656.45, ["Mega|Ride"] = 1237.69, ["Mega|Fly|Ride"] = 801.29}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 301.88, ["Fly"] = 438.45, ["Ride"] = 341.25, ["Fly|Ride"] = 399.14, ["Neon"] = 1048.69, ["Neon|Fly"] = 1454.66, ["Neon|Ride"] = 1150.57, ["Neon|Fly|Ride"] = 1019.08, ["Mega"] = 7875, ["Mega|Fly"] = 4313.59, ["Mega|Ride"] = 3836.94, ["Mega|Fly|Ride"] = 3609.38}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 3.15, ["Fly"] = 26.25, ["Ride"] = 15.43, ["Fly|Ride"] = 38.07, ["Neon"] = 23.64, ["Neon|Ride"] = 31.34, ["Neon|Fly|Ride"] = 69.35, ["Mega"] = 285.6, ["Mega|Ride"] = 205.48, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 38.07, ["Fly"] = 90.14, ["Ride"] = 77.69, ["Fly|Ride"] = 137.82, ["Neon"] = 157.5, ["Neon|Fly"] = 303.07, ["Neon|Ride"] = 203.43, ["Neon|Fly|Ride"] = 248.07, ["Mega"] = 498.75, ["Mega|Fly"] = 821.85, ["Mega|Ride"] = 564.36, ["Mega|Fly|Ride"] = 597.19}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 756.46, ["Fly"] = 1000.59, ["Ride"] = 735, ["Fly|Ride"] = 812.72, ["Neon|Ride"] = 1458.19, ["Neon|Fly|Ride"] = 1458.19, ["Mega|Fly|Ride"] = 3836.94}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 28.58, ["Fly"] = 91.88, ["Ride"] = 52.49, ["Fly|Ride"] = 85.32, ["Neon"] = 164.38, ["Neon|Ride"] = 148.49, ["Neon|Fly|Ride"] = 287.66, ["Mega"] = 1575, ["Mega|Fly|Ride"] = 748.13}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 341.25, ["Fly"] = 328.75, ["Ride"] = 288.75, ["Fly|Ride"] = 328.13, ["Neon|Fly|Ride"] = 1232.86, ["Mega|Fly|Ride"] = 6848.94}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 180.35, ["Fly"] = 204.37, ["Ride"] = 156.62, ["Fly|Ride"] = 205.42, ["Neon|Ride"] = 712.95, ["Neon|Fly|Ride"] = 616.88, ["Mega"] = 3868.22, ["Mega|Fly|Ride"] = 3018.75}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 590.63, ["Ride"] = 610.32, ["Fly|Ride"] = 735, ["Neon|Ride"] = 2520.98, ["Neon|Fly|Ride"] = 2328.88, ["Mega|Fly|Ride"] = 8012.86}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 27.76, ["Ride"] = 39.5, ["Fly|Ride"] = 92.55, ["Neon"] = 131.25, ["Neon|Fly"] = 278.39, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 137.68, ["Mega"] = 306.14, ["Mega|Ride"] = 309.7, ["Mega|Fly|Ride"] = 364.88}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 3972.54, ["Ride"] = 3340.32, ["Fly|Ride"] = 3173.29, ["Neon|Fly|Ride"] = 6562.5, ["Mega|Fly|Ride"] = 25058.25}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 111.57, ["Fly"] = 131.24, ["Ride"] = 116.82, ["Fly|Ride"] = 171.57, ["Neon"] = 380.63, ["Neon|Ride"] = 431.47, ["Neon|Fly|Ride"] = 419.46, ["Mega|Fly|Ride"] = 2375.1}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.63, ["Fly"] = 26.25, ["Ride"] = 18.02, ["Fly|Ride"] = 41.11, ["Neon"] = 18.51, ["Neon|Fly"] = 82.21, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 135.61, ["Mega"] = 194.88, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 270.14, ["Mega|Fly|Ride"] = 185.59}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.64, ["Ride"] = 26.72, ["Fly|Ride"] = 82.69, ["Neon"] = 24.17, ["Neon|Ride"] = 46.41, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 161.44, ["Mega|Ride"] = 199.48, ["Mega|Fly|Ride"] = 238.56}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 40.48, ["Fly"] = 170.63, ["Ride"] = 37.41, ["Fly|Ride"] = 61.65, ["Neon"] = 271.43, ["Neon|Ride"] = 287.66, ["Neon|Fly|Ride"] = 303.07, ["Mega|Fly|Ride"] = 1128.74}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 1096.13, ["Ride"] = 1349.87, ["Fly|Ride"] = 1096.13}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 6221.24, ["Fly"] = 7041.05, ["Ride"] = 6959.28, ["Fly|Ride"] = 6299.99}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 18.17, ["Fly"] = 35.97, ["Ride"] = 23.67, ["Fly|Ride"] = 53.82, ["Neon"] = 261.86, ["Neon|Ride"] = 137.68, ["Neon|Fly|Ride"] = 171.57, ["Mega"] = 2428.13, ["Mega|Fly|Ride"] = 656.24}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 15.11, ["Fly"] = 48.29, ["Ride"] = 28.88, ["Fly|Ride"] = 78.75, ["Neon"] = 94.4, ["Neon|Ride"] = 90.37, ["Neon|Fly|Ride"] = 196.92, ["Mega"] = 642.48, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 485.63}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 72.01, ["Fly"] = 88.36, ["Ride"] = 62.02, ["Fly|Ride"] = 111.56, ["Neon"] = 328.13, ["Neon|Ride"] = 317.82, ["Neon|Fly|Ride"] = 301.88, ["Mega"] = 2054.59, ["Mega|Ride"] = 1787.49, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 210, ["Fly"] = 309.7, ["Ride"] = 201.78, ["Fly|Ride"] = 288.75, ["Neon|Ride"] = 977.79, ["Neon|Fly|Ride"] = 959.51, ["Mega"] = 10272.89, ["Mega|Fly|Ride"] = 3698.25}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 5.19, ["Ride"] = 31.86, ["Fly|Ride"] = 86.63, ["Neon"] = 21.6, ["Neon|Fly"] = 656.24, ["Neon|Ride"] = 92.47, ["Mega"] = 136.5, ["Mega|Ride"] = 164.07, ["Mega|Fly|Ride"] = 371.17}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 190.32, ["Fly"] = 274.31, ["Ride"] = 216.04, ["Fly|Ride"] = 287.66, ["Neon"] = 922.51, ["Neon|Ride"] = 909.36, ["Neon|Fly|Ride"] = 853.13, ["Mega|Ride"] = 4638.37, ["Mega|Fly|Ride"] = 5443.61}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 3.94, ["Fly"] = 26.25, ["Ride"] = 12.77, ["Fly|Ride"] = 48.27, ["Neon"] = 19.09, ["Neon|Fly"] = 123.03, ["Neon|Ride"] = 31.34, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 256.28, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 225.75, ["Fly"] = 265.06, ["Ride"] = 240.4, ["Fly|Ride"] = 227.05, ["Neon|Ride"] = 1014.98, ["Neon|Fly|Ride"] = 1115.63, ["Mega"] = 10272.89, ["Mega|Ride"] = 4109.17, ["Mega|Fly|Ride"] = 4082.46}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 13.68, ["Fly"] = 70.4, ["Ride"] = 28.91, ["Fly|Ride"] = 61.65, ["Neon"] = 56.56, ["Neon|Fly"] = 294.62, ["Neon|Ride"] = 96.58, ["Neon|Fly|Ride"] = 194.91, ["Mega"] = 513.83, ["Mega|Ride"] = 575.3, ["Mega|Fly|Ride"] = 449.5}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 3.15, ["Ride"] = 20.25, ["Fly|Ride"] = 86.63, ["Neon"] = 9.01, ["Neon|Fly"] = 170.45, ["Neon|Ride"] = 36.66, ["Neon|Fly|Ride"] = 176.77, ["Mega"] = 155.44, ["Mega|Ride"] = 97.93, ["Mega|Fly|Ride"] = 255.94}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.63, ["Neon"] = 6.57, ["Neon|Ride"] = 31.86, ["Mega"] = 22.31, ["Mega|Ride"] = 136.4}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 3.45, ["Fly"] = 52.48, ["Ride"] = 32.89, ["Fly|Ride"] = 206.56, ["Neon"] = 6.19, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 66.93, ["Mega|Fly"] = 154651.11, ["Mega|Ride"] = 95.8, ["Mega|Fly|Ride"] = 159.86}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 65.01, ["Fly"] = 136.83, ["Ride"] = 113.04, ["Fly|Ride"] = 164.07, ["Neon"] = 352.63, ["Neon|Ride"] = 378, ["Neon|Fly|Ride"] = 366.18, ["Mega|Fly|Ride"] = 1013.52}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 33.54, ["Ride"] = 15.65, ["Fly|Ride"] = 88.7, ["Neon"] = 13.13, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 96, ["Mega|Ride"] = 122.75, ["Mega|Fly|Ride"] = 257.24}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 11.6, ["Ride"] = 124.13, ["Neon"] = 74.82, ["Neon|Ride"] = 111.57, ["Mega"] = 443.63, ["Mega|Ride"] = 579.96, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 44.05, ["Neon|Fly|Ride"] = 278.25, ["Mega"] = 15.59, ["Mega|Ride"] = 57.75, ["Mega|Fly|Ride"] = 103.69}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 15.43, ["Ride"] = 17.41, ["Fly|Ride"] = 23.22, ["Neon"] = 2.1, ["Neon|Fly"] = 14.43, ["Neon|Ride"] = 14.12, ["Neon|Fly|Ride"] = 39.04, ["Mega"] = 14.7, ["Mega|Fly"] = 31.5, ["Mega|Ride"] = 26.61, ["Mega|Fly|Ride"] = 74.51}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Ride"] = 15.3, ["Fly|Ride"] = 33.66, ["Neon"] = 3.38, ["Neon|Fly"] = 19.94, ["Neon|Ride"] = 15.43, ["Neon|Fly|Ride"] = 35.44, ["Mega"] = 19.57, ["Mega|Fly"] = 155.32, ["Mega|Ride"] = 36.83, ["Mega|Fly|Ride"] = 95.82}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Ride"] = 33.63, ["Neon"] = 2.1, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 82.21, ["Mega"] = 16.51, ["Mega|Ride"] = 146.08}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 118.12, ["Ride"] = 18.38, ["Fly|Ride"] = 107.62, ["Neon"] = 3.94, ["Neon|Fly"] = 137.85, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 23.45, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 120.75}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Fly|Ride"] = 203.41, ["Mega"] = 23.12, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 410.83}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 3.92, ["Fly"] = 65.01, ["Ride"] = 17.3, ["Fly|Ride"] = 53.43, ["Neon"] = 10.5, ["Neon|Fly"] = 59.06, ["Neon|Ride"] = 23.92, ["Neon|Fly|Ride"] = 74.43, ["Mega"] = 65.63, ["Mega|Fly"] = 277.38, ["Mega|Ride"] = 85.22, ["Mega|Fly|Ride"] = 137.68}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 47.28, ["Neon"] = 2.1, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 157.37, ["Mega"] = 15.74, ["Mega|Fly"] = 98.44, ["Mega|Ride"] = 41.11, ["Mega|Fly|Ride"] = 91.88}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 3.94, ["Fly|Ride"] = 524.99, ["Neon"] = 15.74, ["Mega"] = 137.68, ["Mega|Fly"] = 315, ["Mega|Ride"] = 343.13}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Ride"] = 41.09, ["Neon"] = 6.19, ["Neon|Ride"] = 19.69, ["Mega"] = 103.69, ["Mega|Ride"] = 410.93, ["Mega|Fly|Ride"] = 537.62}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 5.25, ["Neon|Fly"] = 27.76, ["Neon|Ride"] = 26.72, ["Neon|Fly|Ride"] = 137.68, ["Mega"] = 31.83, ["Mega|Ride"] = 58.01, ["Mega|Fly|Ride"] = 131.14}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.68, ["Ride"] = 15.43, ["Fly|Ride"] = 30.1, ["Neon"] = 2.1, ["Neon|Fly"] = 35.44, ["Neon|Ride"] = 14.36, ["Neon|Fly|Ride"] = 30.19, ["Mega"] = 14.18, ["Mega|Fly"] = 36.75, ["Mega|Ride"] = 30.17, ["Mega|Fly|Ride"] = 84}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.1, ["Fly"] = 72.19, ["Ride"] = 229.68, ["Neon"] = 29.92, ["Neon|Ride"] = 140.95, ["Mega"] = 273.28}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 18.33, ["Fly|Ride"] = 82.16, ["Neon"] = 3.55, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 26.24, ["Mega|Fly"] = 78.75, ["Mega|Ride"] = 59.6, ["Mega|Fly|Ride"] = 130.48}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 5.92, ["Neon"] = 10, ["Neon|Fly|Ride"] = 137.68, ["Mega"] = 81.38, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 238.88}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.51, ["Fly"] = 656.24, ["Ride"] = 32.82, ["Fly|Ride"] = 186.98, ["Neon"] = 15.31, ["Neon|Fly|Ride"] = 137.68, ["Mega"] = 223.02, ["Mega|Ride"] = 91.87, ["Mega|Fly|Ride"] = 155.44}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 38.66, ["Ride"] = 14.36, ["Fly|Ride"] = 26.17, ["Neon"] = 2.1, ["Neon|Fly"] = 14.44, ["Neon|Ride"] = 15.43, ["Neon|Fly|Ride"] = 27.76, ["Mega"] = 39.38, ["Mega|Fly"] = 30.83, ["Mega|Ride"] = 27.76, ["Mega|Fly|Ride"] = 52.46}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 19.69, ["Fly|Ride"] = 109.94, ["Neon"] = 18.38, ["Neon|Ride"] = 111.37, ["Neon|Fly|Ride"] = 84, ["Mega"] = 78.75, ["Mega|Ride"] = 154.16, ["Mega|Fly|Ride"] = 274.31}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 3.11, ["Fly"] = 41.11, ["Ride"] = 32.82, ["Fly|Ride"] = 58.46, ["Neon"] = 5.25, ["Neon|Ride"] = 47.99, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 216.66, ["Mega|Ride"] = 282.19, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 15.43, ["Ride"] = 15.75, ["Fly|Ride"] = 26.17, ["Neon"] = 2.1, ["Neon|Fly"] = 22.43, ["Neon|Ride"] = 15.43, ["Neon|Fly|Ride"] = 39.04, ["Mega"] = 17.07, ["Mega|Fly"] = 155.44, ["Mega|Ride"] = 118.15, ["Mega|Fly|Ride"] = 98.44}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.63, ["Fly"] = 171.57, ["Ride"] = 58.56, ["Neon"] = 7.76, ["Neon|Ride"] = 40.68, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 36.66, ["Mega|Fly"] = 164.38, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 262.47}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.63, ["Ride"] = 26.72, ["Fly|Ride"] = 82.21, ["Neon"] = 4.99, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 137.82, ["Mega"] = 35.44, ["Mega|Ride"] = 137.68, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 16.72, ["Neon"] = 2.1, ["Neon|Fly"] = 41.03, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 96.58, ["Mega"] = 13.99, ["Mega|Ride"] = 34.13, ["Mega|Fly|Ride"] = 108.84}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 96.58, ["Ride"] = 19.69, ["Fly|Ride"] = 32.82, ["Neon"] = 11.5, ["Neon|Fly"] = 52.02, ["Neon|Ride"] = 19.07, ["Neon|Fly|Ride"] = 72.77, ["Mega"] = 81.17, ["Mega|Ride"] = 81.38}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 105, ["Neon"] = 3.92, ["Neon|Ride"] = 43.31, ["Mega"] = 40.68, ["Mega|Ride"] = 137.65, ["Mega|Fly|Ride"] = 249.37}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 28.77, ["Ride"] = 17.56, ["Fly|Ride"] = 47.25, ["Neon"] = 7.64, ["Neon|Fly"] = 96.58, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 83.98, ["Mega"] = 91.87, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 121.23}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 2.6, ["Ride"] = 39.38, ["Neon"] = 36.16, ["Mega"] = 129.86, ["Mega|Ride"] = 205.48, ["Mega|Fly|Ride"] = 821.85}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Ride"] = 16.7, ["Fly|Ride"] = 82.1, ["Neon"] = 23.54, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 65.62, ["Mega"] = 170.63, ["Mega|Ride"] = 144.02, ["Mega|Fly|Ride"] = 332.85}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 3.39, ["Fly"] = 22.45, ["Ride"] = 19.53, ["Fly|Ride"] = 36.75, ["Neon"] = 18.33, ["Neon|Fly"] = 42.28, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 76.13, ["Mega"] = 223.13, ["Mega|Fly"] = 40950, ["Mega|Ride"] = 154.88, ["Mega|Fly|Ride"] = 203.76}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 110.93, ["Neon"] = 39.38, ["Mega"] = 152.02, ["Mega|Ride"] = 236.24}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 14.35, ["Ride"] = 76.04, ["Neon"] = 120.1, ["Mega|Ride"] = 890.68, ["Mega|Fly|Ride"] = 794.07}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 4.13, ["Ride"] = 69.22, ["Neon"] = 41.11, ["Neon|Ride"] = 105, ["Mega"] = 201.84, ["Mega|Ride"] = 273.67}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 5.18, ["Ride"] = 45.66, ["Fly|Ride"] = 152.25, ["Neon"] = 51.34, ["Neon|Ride"] = 65.63, ["Mega"] = 315.39, ["Mega|Ride"] = 255.94, ["Mega|Fly|Ride"] = 353.73}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.29, ["Neon|Ride"] = 64.99, ["Mega"] = 20.74, ["Mega|Ride"] = 137.68, ["Mega|Fly|Ride"] = 147.94}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 45.6}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 9.41, ["Fly"] = 21.95, ["Ride"] = 25.51, ["Fly|Ride"] = 41.37, ["Neon"] = 74.46, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 78.6, ["Mega"] = 294, ["Mega|Fly"] = 328.75, ["Mega|Ride"] = 278.39, ["Mega|Fly|Ride"] = 252.94}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 18.54, ["Fly|Ride"] = 69.87, ["Neon"] = 2.88, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 39.04, ["Mega|Fly"] = 137.68, ["Mega|Ride"] = 55.13, ["Mega|Fly|Ride"] = 184.43}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 23.64, ["Neon"] = 4.51, ["Neon|Ride"] = 36.75, ["Mega"] = 51.19, ["Mega|Ride"] = 57.75, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 3.5, ["Fly"] = 45.94, ["Ride"] = 19.53, ["Fly|Ride"] = 55.13, ["Neon"] = 6.89, ["Neon|Ride"] = 26.72, ["Neon|Fly|Ride"] = 114.72, ["Mega"] = 124.69, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 161.65}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 5.25, ["Ride"] = 39.38, ["Fly|Ride"] = 59.6, ["Neon"] = 35.03, ["Neon|Ride"] = 231.99, ["Neon|Fly|Ride"] = 191.63, ["Mega"] = 324.63, ["Mega|Ride"] = 269.96, ["Mega|Fly|Ride"] = 307.17}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Ride"] = 32.81, ["Neon"] = 2.6, ["Neon|Ride"] = 26.25, ["Mega"] = 15.75, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 53.72, ["Mega|Fly|Ride"] = 328.75}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 15.94, ["Fly|Ride"] = 273943.8, ["Neon"] = 6.03, ["Neon|Fly"] = 68.85, ["Neon|Ride"] = 20.79, ["Neon|Fly|Ride"] = 69.57, ["Mega"] = 35.44, ["Mega|Fly"] = 143.16, ["Mega|Ride"] = 45.47, ["Mega|Fly|Ride"] = 104.9}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 15.43, ["Ride"] = 15.75, ["Fly|Ride"] = 34.13, ["Neon"] = 7.65, ["Neon|Fly"] = 68.85, ["Neon|Ride"] = 15.64, ["Neon|Fly|Ride"] = 55.5, ["Mega"] = 47.94, ["Mega|Ride"] = 51.34, ["Mega|Fly|Ride"] = 158.29}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 210, ["Ride"] = 36.75, ["Fly|Ride"] = 118.13, ["Neon"] = 3.77, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 24.93, ["Mega|Fly"] = 102.75, ["Mega|Ride"] = 66.93, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 164.38, ["Neon|Fly|Ride"] = 122.26, ["Mega"] = 81.2, ["Mega|Fly"] = 106.31, ["Mega|Ride"] = 86.63, ["Mega|Fly|Ride"] = 199.31}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 32.43, ["Ride"] = 17.91, ["Fly|Ride"] = 77.06, ["Neon"] = 3.94, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 22.1, ["Neon|Fly|Ride"] = 76.56, ["Mega"] = 32.82, ["Mega|Fly"] = 102.75, ["Mega|Ride"] = 65.76, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 2.63, ["Mega"] = 14.44, ["Mega|Ride"] = 123.79}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.39, ["Neon"] = 6.18, ["Neon|Ride"] = 155.44, ["Mega"] = 23.45, ["Mega|Fly"] = 116, ["Mega|Ride"] = 122.24}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 27.57, ["Ride"] = 16.03, ["Fly|Ride"] = 49.87, ["Neon"] = 6.04, ["Neon|Ride"] = 20.56, ["Neon|Fly|Ride"] = 136.49, ["Mega"] = 55.5, ["Mega|Ride"] = 51.86}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 26.96, ["Fly"] = 55.5, ["Ride"] = 137.54, ["Neon"] = 512.63, ["Neon|Ride"] = 328.13, ["Mega"] = 542.41, ["Mega|Ride"] = 666.75, ["Mega|Fly|Ride"] = 671.51}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 4.55, ["Fly"] = 6562.5, ["Ride"] = 68.25, ["Neon"] = 37.4, ["Neon|Ride"] = 203.41, ["Mega"] = 1564.58, ["Mega|Fly|Ride"] = 410.93}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 4.66, ["Ride"] = 26.24, ["Fly|Ride"] = 410.92, ["Neon"] = 33.74, ["Mega"] = 274.31, ["Mega|Ride"] = 248.24, ["Mega|Fly|Ride"] = 349.65}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 10.5, ["Ride"] = 12.84, ["Fly|Ride"] = 24.29, ["Neon"] = 2.1, ["Neon|Fly"] = 14.14, ["Neon|Ride"] = 14.46, ["Neon|Fly|Ride"] = 32.22, ["Mega"] = 103.85, ["Mega|Fly"] = 32.19, ["Mega|Ride"] = 22.32, ["Mega|Fly|Ride"] = 48.32}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Fly"] = 118.12, ["Ride"] = 55.5, ["Fly|Ride"] = 109.94, ["Neon"] = 17.07, ["Neon|Fly"] = 89.46, ["Neon|Ride"] = 31.86, ["Neon|Fly|Ride"] = 685.21, ["Mega"] = 85.31, ["Mega|Ride"] = 62.66}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Ride"] = 31.4, ["Neon"] = 2.1, ["Neon|Fly"] = 30.83, ["Neon|Ride"] = 20.69, ["Neon|Fly|Ride"] = 84.16, ["Mega"] = 15.32, ["Mega|Fly"] = 81.5, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 102.16}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Ride"] = 91.65, ["Neon"] = 2.62, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 96.58, ["Mega"] = 18.25, ["Mega|Ride"] = 89.25, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 34.08, ["Ride"] = 22.6, ["Fly|Ride"] = 45.92, ["Neon"] = 7.88, ["Neon|Fly"] = 137.68, ["Neon|Ride"] = 37.11, ["Neon|Fly|Ride"] = 88.36, ["Mega"] = 183.65, ["Mega|Ride"] = 184.93, ["Mega|Fly|Ride"] = 324.78}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 203.44, ["Ride"] = 262.5, ["Fly|Ride"] = 210, ["Neon"] = 1050, ["Neon|Ride"] = 822.94, ["Mega"] = 8218.31, ["Mega|Fly|Ride"] = 3389.04}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Neon"] = 9.19, ["Neon|Fly"] = 40.85, ["Neon|Ride"] = 68.25, ["Mega"] = 61.69, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 773.66}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 6.18, ["Fly"] = 103.68, ["Ride"] = 15.75, ["Neon"] = 26.72, ["Neon|Ride"] = 69.61, ["Neon|Fly|Ride"] = 155.14, ["Mega"] = 350.83, ["Mega|Fly|Ride"] = 409.9}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 789.01, ["Ride"] = 15.27, ["Fly|Ride"] = 30.18, ["Neon"] = 6.57, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 30.18, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 49.67, ["Mega|Ride"] = 76.67, ["Mega|Fly|Ride"] = 152.06}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.63, ["Fly"] = 51.19, ["Ride"] = 19.68, ["Fly|Ride"] = 65.63, ["Neon"] = 5.25, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 95.82, ["Mega|Ride"] = 136.5, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 6.49, ["Fly"] = 25.98, ["Ride"] = 16.43, ["Fly|Ride"] = 34.97, ["Neon"] = 22.32, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 74.81, ["Mega|Ride"] = 260.95, ["Mega|Fly|Ride"] = 309.7}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 3.12, ["Ride"] = 26.24, ["Fly|Ride"] = 55.5, ["Neon"] = 45.29, ["Neon|Ride"] = 128.26, ["Neon|Fly|Ride"] = 610.22, ["Mega"] = 278.25, ["Mega|Ride"] = 356.1, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.49, ["Fly"] = 19.69, ["Ride"] = 15.15, ["Fly|Ride"] = 30.75, ["Neon"] = 18.16, ["Neon|Fly"] = 68.16, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 73.32, ["Mega|Fly|Ride"] = 199.68}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 77.97, ["Fly"] = 160.06, ["Ride"] = 99.75, ["Fly|Ride"] = 150.94, ["Neon"] = 443.8, ["Neon|Fly"] = 410.82, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 398.74, ["Mega|Fly|Ride"] = 1644.57}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 205.7, ["Fly"] = 328.75, ["Ride"] = 223.13, ["Fly|Ride"] = 275.63, ["Neon"] = 927.91, ["Neon|Ride"] = 1438.21, ["Neon|Fly|Ride"] = 1083.34, ["Mega"] = 10272.89, ["Mega|Fly|Ride"] = 3959.19}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 59.07, ["Fly"] = 137.64, ["Ride"] = 78.1, ["Fly|Ride"] = 118.12, ["Neon"] = 410.93, ["Neon|Ride"] = 309.65, ["Neon|Fly|Ride"] = 412.13, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 5.25, ["Fly"] = 26.25, ["Ride"] = 23.63, ["Fly|Ride"] = 137.68, ["Neon"] = 40.07, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 140.44, ["Mega"] = 274.31, ["Mega|Ride"] = 374.06, ["Mega|Fly|Ride"] = 394.37}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 10.17, ["Fly"] = 68.83, ["Ride"] = 30.83, ["Fly|Ride"] = 81.14, ["Neon"] = 77.04, ["Neon|Ride"] = 97.09, ["Neon|Fly|Ride"] = 178.77, ["Mega"] = 274.31, ["Mega|Ride"] = 354.38, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 31.49, ["Ride"] = 17.41, ["Fly|Ride"] = 33.65, ["Neon"] = 6.13, ["Neon|Fly"] = 67.3, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 69.57, ["Mega"] = 94.53, ["Mega|Fly"] = 154.88, ["Mega|Ride"] = 100.92, ["Mega|Fly|Ride"] = 178.77}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 6.14, ["Fly"] = 68.85, ["Ride"] = 27.75, ["Fly|Ride"] = 39.37, ["Neon"] = 55.5, ["Neon|Ride"] = 155.44, ["Neon|Fly|Ride"] = 134.93, ["Mega"] = 882.45, ["Mega|Ride"] = 583.51, ["Mega|Fly|Ride"] = 864.94}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 41.11, ["Ride"] = 15.3, ["Fly|Ride"] = 55.5, ["Neon"] = 14.44, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 103.63, ["Mega"] = 131.25, ["Mega|Ride"] = 155.44, ["Mega|Fly|Ride"] = 182.44}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 2.63, ["Ride"] = 19.69, ["Fly|Ride"] = 328.13, ["Neon"] = 29.81, ["Neon|Ride"] = 55.5, ["Neon|Fly|Ride"] = 155.44, ["Mega"] = 207.37, ["Mega|Ride"] = 206.47, ["Mega|Fly|Ride"] = 371.98}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 35.97, ["Neon"] = 2.1, ["Neon|Ride"] = 19.66, ["Neon|Fly|Ride"] = 47.28, ["Mega"] = 14.44, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 410.93}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.63, ["Fly"] = 19.69, ["Ride"] = 17.43, ["Fly|Ride"] = 39.38, ["Neon"] = 13, ["Neon|Fly"] = 102.75, ["Neon|Ride"] = 34.94, ["Neon|Fly|Ride"] = 147, ["Mega"] = 84, ["Mega|Ride"] = 106.89, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.39, ["Fly"] = 15.75, ["Ride"] = 17.07, ["Fly|Ride"] = 45.94, ["Neon"] = 24.94, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 109.94, ["Mega"] = 283.5, ["Mega|Ride"] = 199.31, ["Mega|Fly|Ride"] = 221.55}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 185.07, ["Fly"] = 273.28, ["Ride"] = 202.13, ["Fly|Ride"] = 242.81, ["Neon"] = 700.88, ["Neon|Ride"] = 641.3, ["Neon|Fly|Ride"] = 771.75, ["Mega|Fly|Ride"] = 5249.99}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 6.49, ["Ride"] = 30.19, ["Fly|Ride"] = 204.45, ["Neon"] = 52.54, ["Neon|Ride"] = 160.13, ["Neon|Fly|Ride"] = 376.56, ["Mega"] = 314.37, ["Mega|Ride"] = 548.59, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.37, ["Fly"] = 15.43, ["Ride"] = 17.07, ["Fly|Ride"] = 34.94, ["Neon"] = 39.38, ["Neon|Ride"] = 34.94, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 274.31, ["Mega|Ride"] = 221.82, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 21, ["Ride"] = 41.11, ["Fly|Ride"] = 170.63, ["Neon"] = 119.23, ["Neon|Ride"] = 148.31, ["Neon|Fly|Ride"] = 543.1, ["Mega"] = 453.14, ["Mega|Fly"] = 821.85, ["Mega|Ride"] = 469.88, ["Mega|Fly|Ride"] = 707.55}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 5.25}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 3.29, ["Ride"] = 25.54, ["Neon"] = 41.11, ["Neon|Ride"] = 274.31, ["Neon|Fly|Ride"] = 616.39, ["Mega"] = 821.85, ["Mega|Ride"] = 293.66, ["Mega|Fly|Ride"] = 819.79}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 27.91, ["Fly"] = 77.66, ["Ride"] = 26.25, ["Fly|Ride"] = 46.39, ["Neon"] = 178.77, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 219.85, ["Mega"] = 2054.59, ["Mega|Fly|Ride"] = 1367.34}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Fly|Ride"] = 78.75, ["Neon"] = 3.94, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 105, ["Mega"] = 35.35, ["Mega|Ride"] = 62.63, ["Mega|Fly|Ride"] = 162.75}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 11.1, ["Fly"] = 27.6, ["Ride"] = 26.7, ["Fly|Ride"] = 61.65, ["Neon"] = 32.81, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 34.84, ["Mega"] = 231.48, ["Mega|Fly"] = 387.41, ["Mega|Ride"] = 147, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 44.19, ["Ride"] = 17.26, ["Fly|Ride"] = 45.65, ["Neon"] = 15.18, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 29.85, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 135.07, ["Mega|Ride"] = 137.82, ["Mega|Fly|Ride"] = 201.91}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 35.97, ["Fly|Ride"] = 82.21, ["Neon"] = 3.7, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 30.83, ["Neon|Fly|Ride"] = 124.13, ["Mega"] = 28.88, ["Mega|Ride"] = 82.36, ["Mega|Fly|Ride"] = 137.68}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 31.5, ["Ride"] = 104.79, ["Neon"] = 253.32, ["Neon|Fly"] = 223.13, ["Neon|Ride"] = 733.69, ["Neon|Fly|Ride"] = 346.82, ["Mega"] = 923.54, ["Mega|Ride"] = 881.52}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.84, ["Ride"] = 52.5, ["Neon"] = 80.07, ["Neon|Ride"] = 101.72, ["Mega|Ride"] = 524.99}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 5.02, ["Fly"] = 87.49, ["Ride"] = 23.22, ["Fly|Ride"] = 69.57, ["Neon"] = 91.14, ["Neon|Fly"] = 463.97, ["Neon|Ride"] = 102.75, ["Neon|Fly|Ride"] = 123.3, ["Mega"] = 372.43, ["Mega|Ride"] = 320.25, ["Mega|Fly|Ride"] = 341.83}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 52.38, ["Fly"] = 433.13, ["Ride"] = 137.68, ["Fly|Ride"] = 262.44, ["Neon"] = 409.9, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 685.21, ["Mega"] = 1602.58, ["Mega|Ride"] = 2034.38, ["Mega|Fly|Ride"] = 1333.44}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 11.88, ["Fly"] = 39.38, ["Ride"] = 27.57, ["Fly|Ride"] = 60.62, ["Neon"] = 44.56, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 67.58, ["Neon|Fly|Ride"] = 105, ["Mega"] = 215.25, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 368.02}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 65.63, ["Fly"] = 143.07, ["Ride"] = 108.49, ["Neon"] = 183.75, ["Neon|Fly"] = 498.75, ["Neon|Ride"] = 209.99, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 998.68, ["Mega|Ride"] = 1068.39, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 25.99, ["Ride"] = 55.5, ["Fly|Ride"] = 143.83, ["Neon"] = 71.07, ["Neon|Ride"] = 131.58, ["Neon|Fly|Ride"] = 274.31, ["Mega"] = 385.09, ["Mega|Ride"] = 297.55, ["Mega|Fly|Ride"] = 441.29}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 8.9, ["Fly"] = 233.65, ["Ride"] = 27.76, ["Fly|Ride"] = 41.11, ["Neon"] = 47.28, ["Neon|Ride"] = 65.54, ["Neon|Fly|Ride"] = 368.85, ["Mega"] = 416.96, ["Mega|Ride"] = 1027.3, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 14.31, ["Ride"] = 76.04, ["Fly|Ride"] = 153.21, ["Neon"] = 88.35, ["Neon|Ride"] = 129.66, ["Neon|Fly|Ride"] = 274.31, ["Mega"] = 255.2, ["Mega|Fly"] = 496.19, ["Mega|Ride"] = 314.37, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 7.87, ["Ride"] = 40.85, ["Fly|Ride"] = 135.61, ["Neon"] = 43.26, ["Neon|Ride"] = 97.44, ["Neon|Fly|Ride"] = 137.68, ["Mega"] = 411.89, ["Mega|Ride"] = 306.39, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.24, ["Neon|Fly"] = 53.43, ["Neon|Ride"] = 56.35, ["Mega"] = 18.32, ["Mega|Fly"] = 137.68, ["Mega|Ride"] = 68.85, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 3.8, ["Ride"] = 27.46, ["Neon"] = 18.75, ["Neon|Fly"] = 123.3, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 202.78, ["Mega"] = 95.82, ["Mega|Ride"] = 160.23, ["Mega|Fly|Ride"] = 463.97}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Neon"] = 23.62, ["Neon|Ride"] = 420, ["Neon|Fly|Ride"] = 55.5, ["Mega"] = 183.27, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 4.2, ["Ride"] = 32.79, ["Fly|Ride"] = 114.84, ["Neon"] = 17.75, ["Neon|Ride"] = 82.21, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 199.31, ["Mega|Ride"] = 212.27, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 542.96, ["Ride"] = 590.63, ["Fly|Ride"] = 616.88, ["Neon"] = 1703.26, ["Neon|Ride"] = 1483.31, ["Neon|Fly|Ride"] = 1628.71, ["Mega|Fly|Ride"] = 5878.95}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 7.7, ["Fly"] = 27.75, ["Ride"] = 23.22, ["Fly|Ride"] = 59.6, ["Neon"] = 26.25, ["Neon|Ride"] = 96.58, ["Neon|Fly|Ride"] = 210, ["Mega|Ride"] = 369.85, ["Mega|Fly|Ride"] = 482.52}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 6.02, ["Fly"] = 39.38, ["Ride"] = 26.25, ["Fly|Ride"] = 60.38, ["Neon"] = 76.12, ["Neon|Ride"] = 54.51, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 273.28, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 328.12}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 2.89, ["Ride"] = 17.07, ["Fly|Ride"] = 308.2, ["Neon|Ride"] = 101.72, ["Mega"] = 252.88, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 64.97, ["Ride"] = 24.35, ["Fly|Ride"] = 90.57, ["Neon"] = 7.8, ["Neon|Ride"] = 37.13, ["Neon|Fly|Ride"] = 91.61, ["Mega"] = 68.25, ["Mega|Ride"] = 98.44, ["Mega|Fly|Ride"] = 205.48}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 68.85, ["Ride"] = 17.07, ["Neon"] = 3.94, ["Neon|Ride"] = 24.05, ["Neon|Fly|Ride"] = 72.96, ["Mega"] = 23.09, ["Mega|Ride"] = 77.43, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1107.74}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 6.85, ["Ride"] = 18.38, ["Fly|Ride"] = 68.82, ["Neon"] = 76.04, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 178.77, ["Mega|Ride"] = 548.59, ["Mega|Fly|Ride"] = 846.5}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 23.78, ["Neon"] = 5.24, ["Neon|Ride"] = 40.69, ["Mega"] = 39.37, ["Mega|Ride"] = 154.11, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 3.94, ["Fly"] = 27.57, ["Ride"] = 58.49, ["Fly|Ride"] = 39.38, ["Neon"] = 7.83, ["Neon|Fly"] = 123.3, ["Neon|Ride"] = 109.94, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 144.38, ["Mega|Ride"] = 241.5, ["Mega|Fly|Ride"] = 309.7}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 452.82, ["Ride"] = 469.26, ["Fly|Ride"] = 479.76, ["Neon|Ride"] = 1638.54, ["Neon|Fly|Ride"] = 1242.32, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 5.6, ["Fly"] = 196.88, ["Fly|Ride"] = 410.93, ["Neon"] = 96.55, ["Neon|Ride"] = 73.5, ["Mega"] = 468.46, ["Mega|Ride"] = 440.77}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Fly"] = 74.08, ["Ride"] = 29.29, ["Fly|Ride"] = 141.79, ["Neon"] = 5.15, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 109.94, ["Mega"] = 40.68, ["Mega|Fly"] = 189, ["Mega|Ride"] = 91.87, ["Mega|Fly|Ride"] = 207.38}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Ride"] = 821.85, ["Neon"] = 3.94, ["Neon|Ride"] = 109.86, ["Neon|Fly|Ride"] = 260.95, ["Mega"] = 26.25, ["Mega|Ride"] = 113.67, ["Mega|Fly|Ride"] = 218.67}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 16.89, ["Fly"] = 107.63, ["Ride"] = 52.5, ["Fly|Ride"] = 183.75, ["Neon"] = 76.97, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 328.75, ["Mega"] = 578.79, ["Mega|Ride"] = 410.93, ["Mega|Fly|Ride"] = 584.01}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 7.87, ["Neon"] = 109.03, ["Neon|Ride"] = 123.3, ["Neon|Fly|Ride"] = 199.5, ["Mega"] = 393.75, ["Mega|Ride"] = 479.73, ["Mega|Fly|Ride"] = 1096.13}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 5.24, ["Ride"] = 39.38, ["Fly|Ride"] = 137.68, ["Neon"] = 27.76, ["Neon|Ride"] = 155.44, ["Mega"] = 634.47, ["Mega|Ride"] = 959.51, ["Mega|Fly|Ride"] = 1232.76}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 13.54, ["Ride"] = 65.63, ["Neon"] = 162.32, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 184.93, ["Mega"] = 459.38, ["Mega|Ride"] = 613.6, ["Mega|Fly|Ride"] = 665.44}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 325.49, ["Ride"] = 410.93, ["Fly|Ride"] = 616.88, ["Neon"] = 1641.62, ["Neon|Ride"] = 1222.53, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Ride"] = 4108.14, ["Mega|Fly|Ride"] = 3836.44}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 8.24, ["Fly"] = 69.65, ["Ride"] = 23.63, ["Fly|Ride"] = 96.58, ["Neon"] = 106.01, ["Neon|Ride"] = 137.68, ["Neon|Fly|Ride"] = 137.68, ["Mega"] = 684.2, ["Mega|Ride"] = 544.04, ["Mega|Fly|Ride"] = 846.5}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 4.03, ["Fly|Ride"] = 78.75, ["Neon"] = 32.82, ["Neon|Ride"] = 221.82, ["Mega"] = 126.37, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 773.66}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 13.13, ["Ride"] = 77.44, ["Fly|Ride"] = 253.64, ["Neon"] = 42, ["Neon|Ride"] = 114.05, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 272.18, ["Mega|Fly"] = 548.59, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 333.93}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.1, ["Fly"] = 40.61, ["Ride"] = 52.5, ["Fly|Ride"] = 137.68, ["Neon"] = 6.35, ["Neon|Ride"] = 152.77, ["Neon|Fly|Ride"] = 137.68, ["Mega"] = 44.62, ["Mega|Fly"] = 105, ["Mega|Ride"] = 82.21, ["Mega|Fly|Ride"] = 260.95}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 44.34, ["Ride"] = 91.88, ["Fly|Ride"] = 157.5, ["Neon"] = 299.99, ["Neon|Ride"] = 349.29, ["Neon|Fly|Ride"] = 462.3, ["Mega"] = 1781.34, ["Mega|Ride"] = 1232.76, ["Mega|Fly|Ride"] = 1025.29}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 56.44, ["Ride"] = 28.52, ["Neon"] = 9.19, ["Neon|Fly"] = 156.97, ["Neon|Ride"] = 35.97, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 90.47, ["Mega|Ride"] = 103.78, ["Mega|Fly|Ride"] = 185.07}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.37, ["Fly"] = 19.59, ["Ride"] = 27.57, ["Fly|Ride"] = 148.25, ["Neon"] = 6.49, ["Neon|Fly"] = 68.45, ["Neon|Ride"] = 51.19, ["Neon|Fly|Ride"] = 131.51, ["Mega"] = 35.18, ["Mega|Ride"] = 73.5, ["Mega|Fly|Ride"] = 183.54}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Fly"] = 1519.88, ["Ride"] = 27.57, ["Fly|Ride"] = 123.3, ["Neon"] = 13.69, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 116.82, ["Mega|Fly"] = 459.38, ["Mega|Ride"] = 110.25, ["Mega|Fly|Ride"] = 270.38}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 123.26, ["Ride"] = 105.37, ["Neon"] = 437.07, ["Neon|Ride"] = 509.25, ["Neon|Fly|Ride"] = 615.37, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 275.63, ["Ride"] = 275.63, ["Fly|Ride"] = 410.93, ["Neon"] = 1427.95, ["Neon|Ride"] = 1127.75, ["Neon|Fly|Ride"] = 1036.88, ["Mega"] = 6163.75, ["Mega|Fly|Ride"] = 5171.38}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 6.39, ["Fly|Ride"] = 184.25, ["Neon"] = 51.06, ["Neon|Ride"] = 152.02, ["Mega"] = 91.88, ["Mega|Ride"] = 187.71, ["Mega|Fly|Ride"] = 509.55}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.63, ["Ride"] = 32.82, ["Neon"] = 17.52, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 82.21, ["Mega"] = 54.56, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 335.93}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 2.1, ["Fly"] = 30.17, ["Ride"] = 20.56, ["Fly|Ride"] = 174.65, ["Neon"] = 36.75, ["Mega"] = 347.17, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 346.5}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.41, ["Fly"] = 15.43, ["Ride"] = 38.75, ["Fly|Ride"] = 133.88, ["Neon"] = 6.23, ["Neon|Ride"] = 31.34, ["Neon|Fly|Ride"] = 137.68, ["Mega"] = 68.82, ["Mega|Ride"] = 100.92, ["Mega|Fly|Ride"] = 236.23}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 27.76, ["Neon"] = 8.93, ["Mega"] = 52.41, ["Mega|Fly|Ride"] = 271.21}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 65.54, ["Ride"] = 15.75, ["Fly|Ride"] = 41.99, ["Neon"] = 6.08, ["Neon|Ride"] = 23.62, ["Neon|Fly|Ride"] = 97.61, ["Mega"] = 43.31, ["Mega|Ride"] = 73.5, ["Mega|Fly|Ride"] = 142.8}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 90.42, ["Ride"] = 20.46, ["Fly|Ride"] = 53.94, ["Neon"] = 8.75, ["Neon|Fly"] = 87.01, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 63.37, ["Mega"] = 123.3, ["Mega|Ride"] = 231.16, ["Mega|Fly|Ride"] = 437.07}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 27.28, ["Ride"] = 52.42, ["Fly|Ride"] = 77.16, ["Neon"] = 274.31, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 287.65, ["Mega"] = 574.27, ["Mega|Ride"] = 410.93, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 63, ["Fly"] = 582.75, ["Ride"] = 78.74, ["Fly|Ride"] = 123.34, ["Neon"] = 409.9, ["Neon|Ride"] = 389.82, ["Mega"] = 1470, ["Mega|Ride"] = 1370.41, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Fly"] = 34.8, ["Ride"] = 18.57, ["Fly|Ride"] = 131.25, ["Neon"] = 3.94, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 26.72, ["Neon|Fly|Ride"] = 137.68, ["Mega"] = 38.75, ["Mega|Fly"] = 672, ["Mega|Ride"] = 61.65, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 16.46, ["Ride"] = 15.73, ["Fly|Ride"] = 36.75, ["Neon"] = 5.2, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 20.56, ["Neon|Fly|Ride"] = 55.5, ["Mega"] = 51.82, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 42, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 2.1, ["Ride"] = 73.48, ["Fly|Ride"] = 131.25, ["Neon"] = 246.57, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 273.28, ["Mega"] = 260.95, ["Mega|Ride"] = 410.93, ["Mega|Fly|Ride"] = 636.57}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 376.82, ["Fly"] = 393.75, ["Ride"] = 541.4, ["Fly|Ride"] = 498.75, ["Neon|Ride"] = 1781.34, ["Neon|Fly|Ride"] = 1115.63, ["Mega|Fly|Ride"] = 5906.25}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 26.07, ["Fly"] = 92.94, ["Ride"] = 61.69, ["Fly|Ride"] = 108.64, ["Neon"] = 275.63, ["Neon|Ride"] = 227.07, ["Neon|Fly|Ride"] = 301.88, ["Mega|Ride"] = 1232.76, ["Mega|Fly|Ride"] = 984.38}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Fly|Ride"] = 131.25, ["Neon"] = 11.31, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 98.44, ["Mega|Ride"] = 126.99, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.62, ["Fly"] = 205.48, ["Ride"] = 65.63, ["Fly|Ride"] = 195.2, ["Neon"] = 131.15}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 30.81, ["Fly"] = 45.94, ["Ride"] = 43.26, ["Fly|Ride"] = 82.21, ["Neon"] = 118.13, ["Neon|Ride"] = 289.08, ["Neon|Fly|Ride"] = 527.63, ["Mega"] = 2465.51, ["Mega|Fly|Ride"] = 1237.6}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 106.4, ["Ride"] = 98.44, ["Fly|Ride"] = 130.48, ["Neon"] = 498.75, ["Neon|Ride"] = 470.51, ["Neon|Fly|Ride"] = 478.73, ["Mega"] = 8218.31, ["Mega|Fly|Ride"] = 1869.68}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 233.3, ["Fly"] = 307.17, ["Ride"] = 254.78, ["Fly|Ride"] = 410.93, ["Neon"] = 820.82, ["Neon|Ride"] = 654.94, ["Neon|Fly|Ride"] = 1096.13, ["Mega|Fly|Ride"] = 3287.33}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 12.13, ["Ride"] = 61.69, ["Fly|Ride"] = 150.94, ["Neon"] = 73.5, ["Neon|Ride"] = 119.17, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 421.32, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 418.24}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 27.76, ["Ride"] = 14.49, ["Fly|Ride"] = 40.62, ["Neon"] = 7.56, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 21.62, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 91.23, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 165.38}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 4.7, ["Fly"] = 19.69, ["Ride"] = 18.48, ["Fly|Ride"] = 55.5, ["Neon"] = 27.93, ["Neon|Fly"] = 143.83, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 109.91, ["Mega"] = 314.37, ["Mega|Ride"] = 274.23, ["Mega|Fly|Ride"] = 343.13}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 328.13, ["Fly"] = 479.76, ["Ride"] = 326.82, ["Fly|Ride"] = 410.93, ["Neon"] = 1312.5, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1643.67, ["Mega|Fly|Ride"] = 5722.85}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 19.53, ["Neon"] = 9.3, ["Neon|Ride"] = 55.5, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 43.37, ["Mega|Ride"] = 233.21}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 3.97, ["Ride"] = 18.57, ["Fly|Ride"] = 45.85, ["Neon"] = 27.76, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 97.61, ["Mega"] = 178.77, ["Mega|Fly"] = 204.9, ["Mega|Ride"] = 185.59, ["Mega|Fly|Ride"] = 246.57}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 15.64, ["Ride"] = 117.12, ["Neon"] = 91.88, ["Neon|Fly"] = 410.93, ["Neon|Ride"] = 142.14, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 469.85, ["Mega|Ride"] = 545.51, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 127.32, ["Fly"] = 137.68, ["Ride"] = 124.13, ["Fly|Ride"] = 124.69, ["Neon|Ride"] = 695.94, ["Neon|Fly|Ride"] = 649.69, ["Mega|Fly|Ride"] = 2010.75}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 25.51, ["Fly"] = 48.29, ["Ride"] = 27.55, ["Fly|Ride"] = 61.68, ["Neon"] = 85.32, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 171.57, ["Mega"] = 616.39, ["Mega|Ride"] = 507.66, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 41.2, ["Neon"] = 2.1, ["Neon|Ride"] = 138.67, ["Neon|Fly|Ride"] = 685.21, ["Mega"] = 21, ["Mega|Ride"] = 273, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Ride"] = 15.75, ["Fly|Ride"] = 52.5, ["Neon"] = 2.63, ["Neon|Ride"] = 20.46, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 24.93, ["Mega|Fly"] = 97.12, ["Mega|Ride"] = 51.19, ["Mega|Fly|Ride"] = 122.26}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 10.31, ["Fly"] = 410.93, ["Ride"] = 52.5, ["Fly|Ride"] = 164.38, ["Neon"] = 35.86, ["Neon|Fly"] = 222.71, ["Neon|Ride"] = 84.17, ["Neon|Fly|Ride"] = 174.57, ["Mega"] = 150.93, ["Mega|Fly"] = 274.31, ["Mega|Ride"] = 182.44, ["Mega|Fly|Ride"] = 307.13}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1155, ["Ride"] = 1312.5, ["Fly|Ride"] = 1291.5, ["Neon"] = 4200, ["Neon|Fly|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 11025}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 418.69, ["Ride"] = 472.5, ["Fly|Ride"] = 619.39, ["Neon"] = 1903.11, ["Neon|Ride"] = 1443.75, ["Neon|Fly|Ride"] = 1857.69, ["Mega"] = 16436.62, ["Mega|Fly|Ride"] = 7086.19}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 288.75, ["Ride"] = 370.09, ["Fly|Ride"] = 446.25, ["Neon"] = 735, ["Neon|Fly"] = 1237.6, ["Neon|Ride"] = 636.69, ["Neon|Fly|Ride"] = 721.88, ["Mega|Fly|Ride"] = 2694.6}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 313.69, ["Fly"] = 413.12, ["Ride"] = 359.77, ["Fly|Ride"] = 433.12, ["Neon"] = 1289.8, ["Neon|Fly"] = 1370.41, ["Neon|Ride"] = 968.63, ["Neon|Fly|Ride"] = 918.75, ["Mega|Fly|Ride"] = 4613.57}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 23.63, ["Ride"] = 18.27, ["Fly|Ride"] = 38.71, ["Neon"] = 5.79, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 82.21, ["Mega"] = 64.03, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 453.04, ["Ride"] = 443.62, ["Fly|Ride"] = 682.5, ["Neon"] = 1680, ["Neon|Ride"] = 1509.37, ["Neon|Fly|Ride"] = 1918.45, ["Mega|Ride"] = 5722.85, ["Mega|Fly|Ride"] = 5588.46}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 2.59, ["Fly"] = 157.5, ["Ride"] = 112.53, ["Neon"] = 10.17, ["Neon|Ride"] = 64.73, ["Neon|Fly|Ride"] = 155.36, ["Mega"] = 65.63, ["Mega|Ride"] = 78.66, ["Mega|Fly|Ride"] = 271.21}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 20.55, ["Fly|Ride"] = 39.38, ["Neon"] = 7.88, ["Neon|Ride"] = 48.29, ["Neon|Fly|Ride"] = 103.92, ["Mega"] = 105, ["Mega|Ride"] = 192.93}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Neon"] = 4.2, ["Neon|Ride"] = 39.37, ["Mega"] = 23.63, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 157.5, ["Ride"] = 65.63, ["Fly|Ride"] = 459.38, ["Neon"] = 210, ["Neon|Ride"] = 445.86, ["Mega|Ride"] = 927.91}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 8038.15, ["Ride"] = 21, ["Fly|Ride"] = 60.44, ["Neon"] = 26.25, ["Neon|Ride"] = 23.22, ["Mega"] = 328.13, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Neon"] = 3.94, ["Neon|Fly"] = 118.02, ["Neon|Ride"] = 35.11, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 39.38, ["Mega|Fly"] = 685.21, ["Mega|Ride"] = 155.3, ["Mega|Fly|Ride"] = 113.99}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.63, ["Fly"] = 36.01, ["Ride"] = 23, ["Fly|Ride"] = 61.85, ["Neon"] = 13.29, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 24.67, ["Neon|Fly|Ride"] = 82.43, ["Mega"] = 77.97, ["Mega|Fly"] = 171.57, ["Mega|Ride"] = 115.5, ["Mega|Fly|Ride"] = 183.74}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 3.94, ["Fly"] = 55.5, ["Ride"] = 22.61, ["Fly|Ride"] = 51.45, ["Neon"] = 23.63, ["Neon|Fly"] = 41.11, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 245.55, ["Mega"] = 237.57, ["Mega|Ride"] = 300.51, ["Mega|Fly|Ride"] = 309.7}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 12.18, ["Ride"] = 53.82, ["Neon"] = 56.44, ["Neon|Ride"] = 68.85, ["Neon|Fly|Ride"] = 263.3, ["Mega"] = 369.85, ["Mega|Ride"] = 439.69, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 3.94, ["Fly"] = 6186.8, ["Ride"] = 41.11, ["Neon"] = 25.99, ["Neon|Ride"] = 137.45, ["Neon|Fly|Ride"] = 274.31, ["Mega|Ride"] = 714, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 18.38, ["Fly|Ride"] = 45.94, ["Neon"] = 4.73, ["Neon|Fly"] = 27.76, ["Neon|Ride"] = 24.97, ["Mega"] = 41.99, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 188.99, ["Fly"] = 223.13, ["Ride"] = 224.68, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 1026.27, ["Neon|Fly|Ride"] = 721.88, ["Mega"] = 8218.31, ["Mega|Fly|Ride"] = 4198.58}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 15.12, ["Ride"] = 15.75, ["Fly|Ride"] = 31.85, ["Neon"] = 3.36, ["Neon|Fly"] = 27.76, ["Neon|Ride"] = 21.55, ["Neon|Fly|Ride"] = 45.85, ["Mega"] = 27.74, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 19.35, ["Fly"] = 137.68, ["Ride"] = 69.46, ["Fly|Ride"] = 183.73, ["Neon"] = 83.99, ["Neon|Ride"] = 100.66, ["Mega"] = 459.25, ["Mega|Ride"] = 433.8, ["Mega|Fly|Ride"] = 520.86}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 26.25, ["Fly"] = 210, ["Ride"] = 93.17, ["Fly|Ride"] = 167.23, ["Neon"] = 255.94, ["Neon|Ride"] = 273.28, ["Mega"] = 821.85, ["Mega|Ride"] = 849.58}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 196.77, ["Fly"] = 304.5, ["Ride"] = 233.63, ["Fly|Ride"] = 354.38, ["Neon"] = 708.73, ["Neon|Fly"] = 1159.9, ["Neon|Ride"] = 870.13, ["Neon|Fly|Ride"] = 740.25, ["Mega|Fly|Ride"] = 2782.5}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 15.43, ["Ride"] = 37.43, ["Fly|Ride"] = 139.2, ["Neon"] = 116.1, ["Neon|Ride"] = 274.31, ["Mega"] = 287.44, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 1232.76}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 15.43, ["Fly|Ride"] = 616.39, ["Neon"] = 1438.21, ["Neon|Ride"] = 199.5, ["Mega"] = 463.68, ["Mega|Ride"] = 1643.67, ["Mega|Fly|Ride"] = 928.69}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 1135.41, ["Fly"] = 1441.31, ["Ride"] = 1115.63, ["Fly|Ride"] = 1164.18, ["Neon|Ride"] = 4790.63, ["Neon|Fly|Ride"] = 4415.25, ["Mega|Fly|Ride"] = 16983.14}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 5.1, ["Fly"] = 27.85, ["Ride"] = 16.46, ["Fly|Ride"] = 42, ["Neon"] = 44.19, ["Neon|Fly"] = 79.1, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 205.48, ["Mega"] = 270.19, ["Mega|Ride"] = 227.05, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 5.2, ["Fly"] = 65.63, ["Ride"] = 41.11, ["Neon"] = 30.24, ["Neon|Ride"] = 105, ["Mega"] = 342.18, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 238.88, ["Mega|Fly|Ride"] = 270.19}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 22.32, ["Fly|Ride"] = 69.57, ["Neon"] = 15.41, ["Neon|Ride"] = 33.74, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 90.55, ["Mega|Ride"] = 136.89, ["Mega|Fly|Ride"] = 548.45}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 20.56, ["Fly"] = 55.5, ["Ride"] = 37.24, ["Fly|Ride"] = 72.92, ["Neon"] = 76.13, ["Neon|Ride"] = 82.17, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 328.13, ["Mega|Ride"] = 350.36, ["Mega|Fly|Ride"] = 453.58}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 3.77, ["Fly"] = 20.99, ["Ride"] = 20.9, ["Fly|Ride"] = 51.19, ["Neon"] = 17.07, ["Neon|Ride"] = 31.28, ["Neon|Fly|Ride"] = 62.62, ["Mega"] = 147.94, ["Mega|Ride"] = 152.06, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Ride"] = 35.97, ["Neon"] = 9.72, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 56.25, ["Neon|Fly|Ride"] = 410.93, ["Mega"] = 104.99, ["Mega|Fly"] = 205.48, ["Mega|Ride"] = 192.12, ["Mega|Fly|Ride"] = 320.53}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 675.94, ["Ride"] = 417.58, ["Fly|Ride"] = 548.59, ["Neon|Ride"] = 1315.32, ["Neon|Fly|Ride"] = 1338.51}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.62, ["Fly"] = 25.46, ["Ride"] = 16.96, ["Fly|Ride"] = 48.57, ["Neon"] = 9.22, ["Neon|Fly"] = 82.21, ["Neon|Ride"] = 39.04, ["Neon|Fly|Ride"] = 119.84, ["Mega"] = 105, ["Mega|Ride"] = 110.25, ["Mega|Fly|Ride"] = 223.97}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 5.06, ["Ride"] = 27.76, ["Fly|Ride"] = 88.86, ["Neon"] = 77.42, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 188.27, ["Mega|Ride"] = 233.21, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 3.08, ["Fly"] = 90.34, ["Ride"] = 26.17, ["Neon"] = 11.71, ["Neon|Ride"] = 83.16, ["Mega"] = 84.94, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 355.46}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 305.71, ["Ride"] = 325.78, ["Fly|Ride"] = 773.66, ["Neon"] = 821.85, ["Neon|Ride"] = 629.99, ["Neon|Fly|Ride"] = 1143.65, ["Mega"] = 4639.52, ["Mega|Ride"] = 4383.45, ["Mega|Fly|Ride"] = 3018.75}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 24.86, ["Fly"] = 54.8, ["Ride"] = 105, ["Fly|Ride"] = 105, ["Neon"] = 122.24, ["Neon|Ride"] = 178.77, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 721.18, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 17.89, ["Ride"] = 42.34, ["Fly|Ride"] = 137.68, ["Neon"] = 78.75, ["Neon|Ride"] = 123.3, ["Neon|Fly|Ride"] = 257.25, ["Mega"] = 506.13, ["Mega|Ride"] = 476.44, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Ride"] = 44.18, ["Mega"] = 34.02, ["Mega|Ride"] = 183.74}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 61.03, ["Fly"] = 86.59, ["Ride"] = 92.47, ["Fly|Ride"] = 157.5, ["Neon"] = 262.48, ["Neon|Fly"] = 303.14, ["Neon|Ride"] = 251.18, ["Neon|Fly|Ride"] = 328.1, ["Mega|Fly|Ride"] = 1139.09}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 18.83, ["Neon"] = 5.25, ["Neon|Ride"] = 55.5, ["Neon|Fly|Ride"] = 588, ["Mega"] = 46.94, ["Mega|Fly|Ride"] = 409.9}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 18.59, ["Fly"] = 124.13, ["Ride"] = 27.76, ["Fly|Ride"] = 68.39, ["Neon"] = 52.5, ["Neon|Ride"] = 109.05, ["Neon|Fly|Ride"] = 246.57, ["Mega"] = 382.05, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 406.82, ["Mega|Fly|Ride"] = 410.93}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 39.5, ["Fly"] = 110.06, ["Ride"] = 79.95, ["Fly|Ride"] = 101.72, ["Neon"] = 182.49, ["Neon|Ride"] = 262.49, ["Neon|Fly|Ride"] = 355.69, ["Mega|Ride"] = 1299.38, ["Mega|Fly|Ride"] = 1123.35}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 15.43, ["Fly|Ride"] = 33.65, ["Neon"] = 2.1, ["Neon|Fly"] = 20.56, ["Neon|Ride"] = 16.46, ["Neon|Fly|Ride"] = 55.5, ["Mega"] = 16.46, ["Mega|Fly"] = 116, ["Mega|Ride"] = 31.5, ["Mega|Fly|Ride"] = 89.27}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 3.82, ["Fly"] = 32.82, ["Ride"] = 35, ["Fly|Ride"] = 131.25, ["Neon"] = 13.9, ["Neon|Ride"] = 58.57, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 150.94, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 418.04}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 15.06, ["Ride"] = 61.63, ["Fly|Ride"] = 144.38, ["Neon"] = 111.44, ["Neon|Ride"] = 204.45, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 545.51, ["Mega|Ride"] = 519.75, ["Mega|Fly|Ride"] = 754.04}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 26.78, ["Neon"] = 2.63, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 95.8, ["Mega"] = 23.63, ["Mega|Ride"] = 51.38, ["Mega|Fly|Ride"] = 205.48}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 18.47, ["Ride"] = 45.94, ["Fly|Ride"] = 124.13, ["Neon"] = 84.71, ["Neon|Ride"] = 137.45, ["Neon|Fly|Ride"] = 185.59, ["Mega"] = 548.59, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 441.98}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 96.45, ["Fly"] = 27.75, ["Ride"] = 27.66, ["Fly|Ride"] = 45.94, ["Neon"] = 212.7, ["Neon|Ride"] = 118.32, ["Mega"] = 431.47, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 433.8}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 3.54, ["Ride"] = 52.5, ["Fly|Ride"] = 76.02, ["Neon"] = 25.99, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 68.98, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 170.63, ["Mega|Ride"] = 227.53, ["Mega|Fly|Ride"] = 309.7}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 13.08, ["Fly"] = 2054.59, ["Ride"] = 42, ["Neon"] = 84, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 6185.65, ["Mega"] = 295.32, ["Mega|Ride"] = 508.52, ["Mega|Fly|Ride"] = 548.59}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Fly"] = 41.11, ["Ride"] = 20.56, ["Fly|Ride"] = 196.87, ["Neon"] = 9.19, ["Neon|Fly"] = 55.5, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 102.14, ["Mega"] = 65.63, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 124.13}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 55.53, ["Neon"] = 2.63, ["Neon|Ride"] = 44.09, ["Mega"] = 30.19, ["Mega|Ride"] = 161.44, ["Mega|Fly|Ride"] = 216.09}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 27.47}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 40.68, ["Fly"] = 102.38, ["Ride"] = 68.85, ["Fly|Ride"] = 205.48, ["Neon"] = 131.25, ["Neon|Ride"] = 204.53, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1224.55, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 862.71}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Mega"] = 22.31, ["Mega|Ride"] = 164.38, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 388.5, ["Ride"] = 446.25, ["Fly|Ride"] = 641.82, ["Neon"] = 2625, ["Neon|Fly|Ride"] = 3080.85, ["Mega"] = 16436.62}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 6.55, ["Fly"] = 25.99, ["Ride"] = 39.38, ["Fly|Ride"] = 66.26, ["Neon"] = 13.13, ["Neon|Ride"] = 274.31, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 68.85, ["Mega|Fly"] = 141.79, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 205.48}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.63, ["Fly"] = 72.96, ["Ride"] = 21.67, ["Fly|Ride"] = 63, ["Neon"] = 18.37, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 99.65, ["Mega"] = 162.32, ["Mega|Ride"] = 175.88, ["Mega|Fly|Ride"] = 388.33}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 23.63, ["Fly"] = 77.06, ["Ride"] = 72.19, ["Fly|Ride"] = 106.32, ["Neon"] = 68.25, ["Neon|Ride"] = 179.8, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 754.04, ["Mega|Ride"] = 437.07, ["Mega|Fly|Ride"] = 570.15}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 3.93, ["Fly"] = 131.25, ["Ride"] = 32.16, ["Fly|Ride"] = 721.88, ["Mega"] = 255.94}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 9.55, ["Ride"] = 104.9, ["Fly|Ride"] = 157.49, ["Neon"] = 52.5, ["Neon|Ride"] = 91.77, ["Neon|Fly|Ride"] = 359, ["Mega"] = 378.35, ["Mega|Ride"] = 400.98, ["Mega|Fly|Ride"] = 487.97}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 5.25, ["Fly"] = 104.99, ["Ride"] = 35.44, ["Fly|Ride"] = 184.93, ["Neon"] = 34.13, ["Neon|Ride"] = 100.66, ["Neon|Fly|Ride"] = 137.68, ["Mega"] = 216.47, ["Mega|Fly"] = 478.73, ["Mega|Ride"] = 287.66, ["Mega|Fly|Ride"] = 308.44}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 26.17, ["Ride"] = 15.31, ["Fly|Ride"] = 66.94, ["Neon"] = 2.1, ["Neon|Fly"] = 41.99, ["Neon|Ride"] = 15.16, ["Neon|Fly|Ride"] = 76.97, ["Mega"] = 15.6, ["Mega|Fly"] = 61.65, ["Mega|Ride"] = 35.39, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 8.65, ["Fly"] = 274.31, ["Ride"] = 27.57, ["Fly|Ride"] = 102.75, ["Neon"] = 23.22, ["Neon|Fly"] = 116, ["Neon|Ride"] = 68.85, ["Neon|Fly|Ride"] = 110.2, ["Mega"] = 194.25, ["Mega|Fly"] = 204.45, ["Mega|Ride"] = 168, ["Mega|Fly|Ride"] = 410.93}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 285.86, ["Fly"] = 295.86, ["Ride"] = 328.12, ["Fly|Ride"] = 393.75, ["Neon"] = 1450.55, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1046.06, ["Mega|Fly|Ride"] = 4200.6}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 98.6, ["Ride"] = 137.28, ["Fly|Ride"] = 294.62, ["Neon"] = 315, ["Neon|Ride"] = 355.46, ["Neon|Fly|Ride"] = 685.21, ["Mega"] = 4109.17, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1507.04}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 16.46, ["Ride"] = 22.05, ["Fly|Ride"] = 39.43, ["Neon"] = 15.41, ["Neon|Fly"] = 68.85, ["Neon|Ride"] = 32.89, ["Neon|Fly|Ride"] = 62.56, ["Mega"] = 137.68, ["Mega|Fly"] = 204.45, ["Mega|Ride"] = 123.3, ["Mega|Fly|Ride"] = 205.83}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 20.79, ["Ride"] = 14.65, ["Fly|Ride"] = 31.64, ["Neon"] = 5.25, ["Neon|Fly"] = 39.14, ["Neon|Ride"] = 23.45, ["Neon|Fly|Ride"] = 49.87, ["Mega"] = 84, ["Mega|Fly"] = 105, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.1, ["Ride"] = 22.32, ["Fly|Ride"] = 98.44, ["Neon"] = 37.97, ["Mega"] = 137.68, ["Mega|Ride"] = 205.48, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 236.25, ["Fly"] = 420, ["Ride"] = 293.53, ["Fly|Ride"] = 371.62, ["Neon|Ride"] = 1231.73, ["Neon|Fly|Ride"] = 1232.76, ["Mega|Ride"] = 8218.31, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 3.83, ["Fly"] = 48.29, ["Ride"] = 16.94, ["Fly|Ride"] = 43.17, ["Neon"] = 27.76, ["Neon|Fly"] = 77.44, ["Neon|Ride"] = 22.6, ["Neon|Fly|Ride"] = 137.68, ["Mega"] = 224.44, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 5.25, ["Fly"] = 155.44, ["Ride"] = 68.85, ["Fly|Ride"] = 205.48, ["Neon"] = 34.94, ["Neon|Ride"] = 139.13, ["Mega"] = 205.48, ["Mega|Ride"] = 261.18, ["Mega|Fly|Ride"] = 298.86}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 4.93, ["Neon|Ride"] = 137.71, ["Mega"] = 55.13, ["Mega|Ride"] = 96.56, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 18.51, ["Fly"] = 35.97, ["Ride"] = 26.72, ["Fly|Ride"] = 57.23, ["Neon"] = 78.66, ["Neon|Ride"] = 96.58, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 728.44, ["Mega|Ride"] = 354.38, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 53.27, ["Fly"] = 155.44, ["Ride"] = 91.88, ["Fly|Ride"] = 131.25, ["Neon"] = 131.25, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 197.84, ["Neon|Fly|Ride"] = 259.88, ["Mega"] = 419.99, ["Mega|Fly"] = 2157.31, ["Mega|Ride"] = 441, ["Mega|Fly|Ride"] = 618.19}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 24.68, ["Fly"] = 68.25, ["Ride"] = 46.4, ["Fly|Ride"] = 99.92, ["Neon"] = 157.4, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 195.41, ["Mega|Ride"] = 739.67, ["Mega|Fly|Ride"] = 821.85}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 19.05, ["Ride"] = 14.88, ["Fly|Ride"] = 32.89, ["Neon"] = 2.1, ["Neon|Fly"] = 27.76, ["Neon|Ride"] = 15.42, ["Neon|Fly|Ride"] = 36.75, ["Mega"] = 18.36, ["Mega|Fly"] = 412.51, ["Mega|Ride"] = 39.25, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 210, ["Ride"] = 273.28, ["Fly|Ride"] = 298.49, ["Neon"] = 959.51, ["Neon|Ride"] = 890.33, ["Neon|Fly|Ride"] = 989.21, ["Mega|Fly|Ride"] = 4314.62}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 5.25, ["Fly"] = 101.18, ["Ride"] = 60.33, ["Fly|Ride"] = 105, ["Neon"] = 102.64, ["Neon|Ride"] = 199.52, ["Neon|Fly|Ride"] = 328.12, ["Mega"] = 408.89, ["Mega|Ride"] = 446.25, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 19.53, ["Ride"] = 15.6, ["Fly|Ride"] = 39.38, ["Neon"] = 10.48, ["Neon|Ride"] = 25.66, ["Neon|Fly|Ride"] = 108.91, ["Mega"] = 59.14, ["Mega|Fly"] = 274.31, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 147.94}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 34.94, ["Ride"] = 18.51, ["Fly|Ride"] = 55.5, ["Neon"] = 3.43, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 24.93, ["Neon|Fly|Ride"] = 102.64, ["Mega"] = 26.7, ["Mega|Fly"] = 137.68, ["Mega|Ride"] = 45.94, ["Mega|Fly|Ride"] = 155.44}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.63, ["Ride"] = 28.88, ["Fly|Ride"] = 69.28, ["Neon"] = 12.22, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 155.44, ["Mega"] = 124.67, ["Mega|Ride"] = 128.63, ["Mega|Fly|Ride"] = 369.85}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 14.58, ["Fly"] = 38.74, ["Ride"] = 26.45, ["Fly|Ride"] = 81.17, ["Neon"] = 46.39, ["Neon|Fly"] = 260.95, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 123.38, ["Mega"] = 365.21, ["Mega|Ride"] = 309.7, ["Mega|Fly|Ride"] = 371.49}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 5.25, ["Fly"] = 55.5, ["Ride"] = 39.38, ["Fly|Ride"] = 72.19, ["Neon"] = 48.29, ["Neon|Ride"] = 135.61, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 267.1, ["Mega|Ride"] = 343.13, ["Mega|Fly|Ride"] = 410.93}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Fly|Ride"] = 273.28, ["Neon"] = 3.88, ["Neon|Ride"] = 27.76, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 18.37, ["Mega|Ride"] = 68.16, ["Mega|Fly|Ride"] = 127.31}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 8.91, ["Ride"] = 27.57, ["Fly|Ride"] = 65.63, ["Neon"] = 31.4, ["Neon|Fly"] = 102.92, ["Neon|Ride"] = 64.31, ["Neon|Fly|Ride"] = 135.33, ["Mega"] = 157.5, ["Mega|Ride"] = 212.62, ["Mega|Fly|Ride"] = 279.57}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 111.99, ["Neon"] = 3.94, ["Neon|Fly"] = 96.58, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 102.3, ["Mega"] = 24.93, ["Mega|Ride"] = 91.35, ["Mega|Fly|Ride"] = 309.7}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 38.83, ["Ride"] = 22.29, ["Fly|Ride"] = 61.56, ["Neon"] = 7.88, ["Neon|Ride"] = 22.5, ["Neon|Fly|Ride"] = 87.33, ["Mega"] = 47.13, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 202.13}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 630, ["Ride"] = 682.5, ["Fly|Ride"] = 787.5, ["Neon|Ride"] = 3150, ["Neon|Fly|Ride"] = 3192.25, ["Mega|Fly|Ride"] = 12738.38}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 15.43, ["Fly|Ride"] = 34.13, ["Neon"] = 46.55, ["Neon|Fly"] = 32.89, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 46.41, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 162.4, ["Neon"] = 11.82, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 137.68, ["Mega"] = 45.94, ["Mega|Ride"] = 100.69, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 8.71, ["Fly"] = 31.34, ["Ride"] = 22.32, ["Fly|Ride"] = 46.31, ["Neon"] = 47.25, ["Neon|Fly"] = 123.3, ["Neon|Ride"] = 54.53, ["Neon|Fly|Ride"] = 105.84, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 373.42}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 15.6, ["Fly|Ride"] = 31.5, ["Neon"] = 8.28, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 24.27, ["Neon|Fly|Ride"] = 47.25, ["Mega"] = 70.88, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 172.38}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 44.63, ["Ride"] = 72.19, ["Fly|Ride"] = 205.48, ["Neon"] = 255.94, ["Neon|Ride"] = 257.44, ["Mega"] = 896.56, ["Mega|Ride"] = 1370.41}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 9.86, ["Neon|Fly"] = 132.24, ["Neon|Ride"] = 27.76, ["Neon|Fly|Ride"] = 104.52, ["Mega"] = 60.38, ["Mega|Ride"] = 119.44, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 3.84, ["Fly"] = 73.5, ["Ride"] = 22.32, ["Fly|Ride"] = 57.54, ["Neon"] = 40.43, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 118.13, ["Mega|Ride"] = 224.94, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Neon"] = 5.25, ["Neon|Fly"] = 62.66, ["Mega"] = 93.5, ["Mega|Fly"] = 410.93, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 17.07, ["Fly|Ride"] = 88.36, ["Neon"] = 5.2, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 23.46, ["Neon|Fly|Ride"] = 65.01, ["Mega"] = 44.62, ["Mega|Fly"] = 211.63, ["Mega|Ride"] = 68.1, ["Mega|Fly|Ride"] = 171.57}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 15.1, ["Fly"] = 26.25, ["Ride"] = 20.88, ["Fly|Ride"] = 40.98, ["Neon"] = 137.65, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 95.19, ["Mega"] = 821.85, ["Mega|Ride"] = 508.52, ["Mega|Fly|Ride"] = 456.37}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 813.1, ["Ride"] = 774.38, ["Fly|Ride"] = 955.5, ["Neon"] = 1983.19, ["Neon|Ride"] = 1951.81, ["Neon|Fly|Ride"] = 1890, ["Mega"] = 7805.35, ["Mega|Fly|Ride"] = 6195}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 20.56, ["Ride"] = 18.51, ["Fly|Ride"] = 47.24, ["Neon"] = 3.94, ["Neon|Ride"] = 18.56, ["Neon|Fly|Ride"] = 60.38, ["Mega"] = 57.74, ["Mega|Ride"] = 56.41, ["Mega|Fly|Ride"] = 142.72}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 5.25, ["Ride"] = 27.76, ["Fly|Ride"] = 52.5, ["Neon"] = 48.28, ["Neon|Fly"] = 137.68, ["Neon|Ride"] = 46.41, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 287.05, ["Mega|Ride"] = 351.21}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 55.13, ["Ride"] = 62.34, ["Fly|Ride"] = 105, ["Neon"] = 295.32, ["Neon|Ride"] = 372.09, ["Neon|Fly|Ride"] = 431.47, ["Mega"] = 3150.32, ["Mega|Fly|Ride"] = 1613.89}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 34.94, ["Fly"] = 124.13, ["Ride"] = 56.44, ["Fly|Ride"] = 102.79, ["Neon"] = 105, ["Neon|Ride"] = 137.68, ["Mega"] = 1919, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 729.39}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 15.43, ["Ride"] = 26.25, ["Fly|Ride"] = 123.59, ["Neon"] = 123.38, ["Neon|Ride"] = 134.98, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 300.57, ["Mega|Ride"] = 393.46, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 20.3, ["Ride"] = 92.8, ["Neon"] = 78.75, ["Neon|Ride"] = 205.48, ["Mega"] = 314.35, ["Mega|Fly"] = 503.41, ["Mega|Ride"] = 354.95, ["Mega|Fly|Ride"] = 453.05}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 20.88, ["Ride"] = 77.95, ["Neon"] = 195.2, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 485.63, ["Mega"] = 525, ["Mega|Ride"] = 685.21, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 6.34}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 6.08, ["Fly"] = 26.72, ["Ride"] = 27.76, ["Fly|Ride"] = 78.75, ["Neon"] = 34.12, ["Neon|Ride"] = 39.04, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 196.88, ["Mega|Fly"] = 454.63, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 328.75}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 3.81, ["Neon"] = 14.59, ["Mega"] = 342.18, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 68.85, ["Fly"] = 410.74, ["Ride"] = 65.63, ["Fly|Ride"] = 91.88, ["Neon"] = 248.24, ["Neon|Ride"] = 242.82, ["Neon|Fly|Ride"] = 219.86, ["Mega|Ride"] = 910.88, ["Mega|Fly|Ride"] = 1233.75}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.64, ["Fly"] = 24.67, ["Ride"] = 14.6, ["Fly|Ride"] = 39.38, ["Neon"] = 23, ["Neon|Fly"] = 41.11, ["Neon|Ride"] = 30.18, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 244.51, ["Mega|Fly"] = 409.9, ["Mega|Ride"] = 178.1, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 6.13, ["Ride"] = 26.25, ["Fly|Ride"] = 76.56, ["Neon"] = 26.25, ["Neon|Ride"] = 49.32, ["Neon|Fly|Ride"] = 136.23, ["Mega"] = 116.94, ["Mega|Ride"] = 177.31, ["Mega|Fly|Ride"] = 274.31}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 6.57, ["Neon|Ride"] = 45.94, ["Mega"] = 42, ["Mega|Ride"] = 137.68, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 36.75, ["Fly"] = 58.7, ["Ride"] = 61.65, ["Fly|Ride"] = 120.74, ["Neon"] = 153.57, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 205.48, ["Mega"] = 1096.13, ["Mega|Ride"] = 861.91, ["Mega|Fly|Ride"] = 741.57}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 27.75, ["Neon"] = 8.24, ["Neon|Fly"] = 291.38, ["Neon|Ride"] = 84.26, ["Mega"] = 99.75, ["Mega|Ride"] = 92.01, ["Mega|Fly|Ride"] = 309.68}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 6.49, ["Ride"] = 68.85, ["Fly|Ride"] = 271.21, ["Neon"] = 117.12, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 385.91, ["Mega"] = 374.07, ["Mega|Ride"] = 591.73, ["Mega|Fly|Ride"] = 630.77}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 23.55, ["Ride"] = 15.64, ["Fly|Ride"] = 52.41, ["Neon"] = 17.31, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 157.5, ["Mega|Ride"] = 261.85, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 3.78, ["Fly"] = 52.49, ["Ride"] = 17.41, ["Fly|Ride"] = 52.5, ["Neon"] = 157.5, ["Neon|Ride"] = 410.93, ["Mega"] = 231.99, ["Mega|Ride"] = 388.33, ["Mega|Fly|Ride"] = 410.17}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 3.59, ["Ride"] = 62.66, ["Fly|Ride"] = 131.25, ["Neon"] = 24.93, ["Neon|Ride"] = 153.25, ["Mega"] = 364.58, ["Mega|Ride"] = 840.67}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 34.13, ["Ride"] = 123.3, ["Fly|Ride"] = 137.68, ["Neon"] = 156.07, ["Neon|Ride"] = 192.93, ["Neon|Fly|Ride"] = 367.5, ["Mega|Ride"] = 1630.32, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 17.46, ["Ride"] = 85.73, ["Neon"] = 131.25, ["Neon|Ride"] = 178.77, ["Neon|Fly|Ride"] = 143.83, ["Mega"] = 411.7, ["Mega|Ride"] = 328.75, ["Mega|Fly|Ride"] = 498.1}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 7.6, ["Ride"] = 41.11, ["Neon"] = 38.85, ["Neon|Ride"] = 105, ["Mega"] = 821.85, ["Mega|Ride"] = 821.85, ["Mega|Fly|Ride"] = 1643.67}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 14.86, ["Ride"] = 45.94, ["Fly|Ride"] = 367.46, ["Neon"] = 103.9, ["Neon|Ride"] = 274.31, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 739.67, ["Mega|Ride"] = 792.74, ["Mega|Fly|Ride"] = 1083.34}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 3.94, ["Neon"] = 104.99, ["Neon|Ride"] = 274.31, ["Mega"] = 303.07, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 309.7}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 17.67, ["Fly|Ride"] = 38.07, ["Neon"] = 3.8, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 34.38, ["Neon|Fly|Ride"] = 76.13, ["Mega"] = 68.25, ["Mega|Ride"] = 89.39, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 5.11, ["Ride"] = 55.13, ["Fly|Ride"] = 72.19, ["Neon"] = 28.18, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 109.94, ["Mega"] = 114.12, ["Mega|Fly|Ride"] = 397.58}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 29.71, ["Ride"] = 18.37, ["Fly|Ride"] = 55.95, ["Neon"] = 6.57, ["Neon|Ride"] = 30.18, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 46.69, ["Mega|Ride"] = 73.58, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 27.76, ["Fly|Ride"] = 68.85, ["Neon"] = 16.46, ["Neon|Ride"] = 96.58, ["Neon|Fly|Ride"] = 137.68, ["Mega"] = 249.38, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 463.97}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.61, ["Ride"] = 34.94, ["Fly|Ride"] = 103.69, ["Neon"] = 41.11, ["Neon|Fly"] = 463.97, ["Neon|Ride"] = 69.61, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 302.45, ["Mega|Ride"] = 410.93, ["Mega|Fly|Ride"] = 1027.3}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 3.9, ["Fly"] = 131.25, ["Ride"] = 26.43, ["Fly|Ride"] = 60.62, ["Neon"] = 33.78, ["Neon|Fly"] = 111.54, ["Neon|Ride"] = 41.1, ["Neon|Fly|Ride"] = 110.25, ["Mega"] = 243.58, ["Mega|Ride"] = 257.24, ["Mega|Fly|Ride"] = 303.07}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 3.15, ["Fly"] = 34.78, ["Ride"] = 18.38, ["Fly|Ride"] = 51.68, ["Neon"] = 17.06, ["Neon|Fly"] = 82.21, ["Neon|Ride"] = 48.29, ["Neon|Fly|Ride"] = 100.92, ["Mega"] = 168, ["Mega|Ride"] = 227.05, ["Mega|Fly|Ride"] = 479.76}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 6.39, ["Fly"] = 57.75, ["Ride"] = 43.29, ["Neon"] = 19.69, ["Neon|Fly"] = 170.55, ["Neon|Ride"] = 44.44, ["Neon|Fly|Ride"] = 185.59, ["Mega"] = 77.69, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 294.84}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 4.13, ["Fly"] = 137.68, ["Ride"] = 105, ["Fly|Ride"] = 192.12, ["Neon"] = 86.63, ["Neon|Ride"] = 178.77, ["Neon|Fly|Ride"] = 410.93, ["Mega"] = 406.88, ["Mega|Fly"] = 667.75, ["Mega|Ride"] = 535.31, ["Mega|Fly|Ride"] = 666.75}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 59.07, ["Ride"] = 97.13, ["Fly|Ride"] = 189.04, ["Neon"] = 262.49, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 274.31, ["Mega"] = 1050, ["Mega|Ride"] = 1191.56, ["Mega|Fly|Ride"] = 1207.5}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 50.96, ["Ride"] = 19.56, ["Fly|Ride"] = 45.22, ["Neon"] = 3.56, ["Neon|Ride"] = 41.11, ["Neon|Fly|Ride"] = 104.41, ["Mega"] = 30.38, ["Mega|Ride"] = 42, ["Mega|Fly|Ride"] = 130.99}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 34.81, ["Mega"] = 913.27, ["Mega|Ride"] = 820.82, ["Mega|Fly|Ride"] = 1232.76}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 53.75, ["Fly"] = 105, ["Ride"] = 81.38, ["Neon"] = 304.49, ["Neon|Ride"] = 246.57, ["Mega"] = 1674.5, ["Mega|Ride"] = 1210.16, ["Mega|Fly|Ride"] = 997.5}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 11.82, ["Fly"] = 190.32, ["Ride"] = 31.02, ["Fly|Ride"] = 91.88, ["Neon"] = 39.38, ["Neon|Ride"] = 65.54, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 274.31, ["Mega|Ride"] = 170.55, ["Mega|Fly|Ride"] = 326.82}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 2.1, ["Ride"] = 110.44, ["Fly|Ride"] = 137.68, ["Neon"] = 7.56, ["Neon|Ride"] = 47.25, ["Mega"] = 59.7, ["Mega|Fly"] = 341.25, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 138.95}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.63, ["Fly"] = 21, ["Ride"] = 17.31, ["Fly|Ride"] = 60.62, ["Neon"] = 12.5, ["Neon|Ride"] = 34.12, ["Neon|Fly|Ride"] = 100.69, ["Mega"] = 201.84, ["Mega|Fly"] = 343.13, ["Mega|Ride"] = 155.44}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 16.74, ["Ride"] = 13.93, ["Fly|Ride"] = 43.17, ["Neon"] = 2.63, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 57.54, ["Mega"] = 27.03, ["Mega|Ride"] = 69.56}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 17.28, ["Fly|Ride"] = 74.27, ["Neon"] = 4.13, ["Neon|Ride"] = 24.92, ["Neon|Fly|Ride"] = 89.39, ["Mega"] = 41.99, ["Mega|Fly"] = 168, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 134.58}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Fly|Ride"] = 155.44, ["Neon"] = 2.5, ["Neon|Ride"] = 123.3, ["Mega"] = 14.44, ["Mega|Fly|Ride"] = 302.93}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 5.25, ["Ride"] = 44.19, ["Neon"] = 37, ["Neon|Ride"] = 83.53, ["Neon|Fly|Ride"] = 616.39, ["Mega"] = 137.68, ["Mega|Ride"] = 231, ["Mega|Fly|Ride"] = 247.72}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 13.99, ["Ride"] = 31.86, ["Fly|Ride"] = 189.96, ["Neon"] = 58.9, ["Neon|Ride"] = 96.58, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 408.89, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 6.45, ["Fly"] = 24.75, ["Ride"] = 19.59, ["Fly|Ride"] = 46.1, ["Neon"] = 37.4, ["Neon|Fly"] = 65.54, ["Neon|Ride"] = 39.3, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 483.87, ["Mega|Ride"] = 315.39, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 66.94, ["Ride"] = 191.09, ["Fly|Ride"] = 262.5, ["Neon"] = 216.91, ["Neon|Ride"] = 597.19, ["Mega|Fly|Ride"] = 1771.88}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 26.25, ["Fly"] = 71.73, ["Ride"] = 31.5, ["Fly|Ride"] = 123.3, ["Neon"] = 62.66, ["Neon|Fly|Ride"] = 630, ["Mega"] = 619.39, ["Mega|Ride"] = 827.54, ["Mega|Fly|Ride"] = 820.98}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 16.37, ["Fly|Ride"] = 38.75, ["Neon"] = 2.63, ["Neon|Fly"] = 27.76, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 51.19, ["Mega"] = 39.04, ["Mega|Ride"] = 48.57, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 15.43, ["Ride"] = 14.82, ["Fly|Ride"] = 30.9, ["Neon"] = 3.94, ["Neon|Fly"] = 26.17, ["Neon|Ride"] = 20.45, ["Neon|Fly|Ride"] = 32.82, ["Mega"] = 44.17, ["Mega|Fly"] = 82.21, ["Mega|Ride"] = 56.44, ["Mega|Fly|Ride"] = 101.07}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 446.24, ["Ride"] = 479.63, ["Fly|Ride"] = 495.73, ["Neon|Fly|Ride"] = 1485.71}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 8.9, ["Ride"] = 68.85, ["Neon"] = 75.73, ["Neon|Ride"] = 109.87, ["Mega"] = 315, ["Mega|Ride"] = 387.41, ["Mega|Fly|Ride"] = 1232.76}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 18.51, ["Ride"] = 13.71, ["Fly|Ride"] = 35.97, ["Neon"] = 5.09, ["Neon|Fly"] = 68.85, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 45.46, ["Mega"] = 46.39, ["Mega|Ride"] = 74.82, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 155.44, ["Ride"] = 155.44, ["Fly|Ride"] = 328.13, ["Neon"] = 236.24, ["Neon|Ride"] = 309.7, ["Neon|Fly|Ride"] = 1130.04, ["Mega"] = 737.62, ["Mega|Ride"] = 682.5, ["Mega|Fly|Ride"] = 934.5}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 30.83, ["Ride"] = 18.37, ["Fly|Ride"] = 48.56, ["Neon"] = 12.64, ["Neon|Fly"] = 41.49, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 65.62, ["Mega"] = 83.91, ["Mega|Fly"] = 178.77, ["Mega|Ride"] = 95.81, ["Mega|Fly|Ride"] = 196.46}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 68.85, ["Ride"] = 34.13, ["Neon"] = 3.42, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 105, ["Mega"] = 20.46, ["Mega|Fly"] = 266.09, ["Mega|Ride"] = 65.23, ["Mega|Fly|Ride"] = 208.58}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 49.88, ["Fly"] = 177.45, ["Ride"] = 86.61, ["Fly|Ride"] = 124.69, ["Neon"] = 157.5, ["Neon|Ride"] = 191.26, ["Neon|Fly|Ride"] = 419.89, ["Mega"] = 721.87, ["Mega|Ride"] = 617.47, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Ride"] = 15.75, ["Fly|Ride"] = 52.5, ["Neon"] = 5.25, ["Neon|Ride"] = 40.45, ["Mega"] = 40.6, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 164.38}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 33.89, ["Ride"] = 78.75, ["Fly|Ride"] = 131.25, ["Neon"] = 312.31, ["Neon|Ride"] = 246.36, ["Neon|Fly|Ride"] = 359.63, ["Mega"] = 1623.13, ["Mega|Ride"] = 1643.67, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 5.14, ["Ride"] = 55.8, ["Fly|Ride"] = 156.16, ["Neon"] = 21.36, ["Neon|Ride"] = 274.31, ["Mega"] = 144.38, ["Mega|Ride"] = 201.84, ["Mega|Fly|Ride"] = 517.78}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.1, ["Fly"] = 68.85, ["Ride"] = 19.69, ["Fly|Ride"] = 65.76, ["Neon"] = 10.28, ["Neon|Fly"] = 82.21, ["Neon|Ride"] = 51.38, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 109.94, ["Mega|Ride"] = 137.68, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 34.1, ["Ride"] = 55.46, ["Fly|Ride"] = 393.75, ["Neon"] = 315, ["Neon|Ride"] = 204.45, ["Neon|Fly|Ride"] = 322.59, ["Mega"] = 2052.54, ["Mega|Ride"] = 2598.75, ["Mega|Fly|Ride"] = 1121.81}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 228, ["Ride"] = 33.65, ["Fly|Ride"] = 59.07, ["Neon"] = 6.37, ["Neon|Ride"] = 34.94, ["Neon|Fly|Ride"] = 151.96, ["Mega"] = 43.32, ["Mega|Fly"] = 244.63, ["Mega|Ride"] = 102.75, ["Mega|Fly|Ride"] = 203.62}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 32.89, ["Ride"] = 15.43, ["Fly|Ride"] = 102.88, ["Neon"] = 7.88, ["Neon|Fly"] = 41.01, ["Neon|Ride"] = 18.51, ["Neon|Fly|Ride"] = 96.58, ["Mega|Fly|Ride"] = 205.78}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 9.43, ["Fly"] = 45.22, ["Ride"] = 34.94, ["Fly|Ride"] = 81.17, ["Neon"] = 69.56, ["Neon|Ride"] = 89.66, ["Neon|Fly|Ride"] = 137.68, ["Mega"] = 429.19, ["Mega|Ride"] = 410.83, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 19.39, ["Ride"] = 28.71, ["Neon"] = 124.13, ["Neon|Fly|Ride"] = 1232.76, ["Mega"] = 926.66, ["Mega|Ride"] = 820.82, ["Mega|Fly|Ride"] = 821.85}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 32.89, ["Fly"] = 51.18, ["Ride"] = 19.69, ["Fly|Ride"] = 73.96, ["Neon"] = 72.19, ["Neon|Ride"] = 137.68, ["Neon|Fly|Ride"] = 205.47, ["Mega"] = 537.12, ["Mega|Ride"] = 262.49, ["Mega|Fly|Ride"] = 360.94}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 49.62, ["Fly"] = 223.13, ["Ride"] = 135.61, ["Fly|Ride"] = 236.25, ["Neon"] = 299.24, ["Neon|Ride"] = 283.5, ["Neon|Fly|Ride"] = 410.93, ["Mega|Ride"] = 1456.71, ["Mega|Fly|Ride"] = 1371.87}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 3.6, ["Ride"] = 44.01, ["Neon"] = 36.75, ["Neon|Ride"] = 77.73, ["Neon|Fly|Ride"] = 305.82, ["Mega"] = 201.39, ["Mega|Ride"] = 298.95, ["Mega|Fly|Ride"] = 334.91}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 5.25, ["Ride"] = 26.25, ["Fly|Ride"] = 78.74, ["Neon"] = 18.37, ["Neon|Ride"] = 46.41, ["Mega"] = 154.11, ["Mega|Ride"] = 274.31, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 12.9, ["Fly"] = 52.49, ["Ride"] = 26.72, ["Fly|Ride"] = 92.8, ["Neon"] = 91.77, ["Neon|Ride"] = 65.63, ["Mega"] = 430.5, ["Mega|Ride"] = 639.19, ["Mega|Fly|Ride"] = 464.36}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.65, ["Ride"] = 15.43, ["Fly|Ride"] = 30.83, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 15.42, ["Neon|Fly|Ride"] = 59.16, ["Mega"] = 15.1, ["Mega|Ride"] = 65.54, ["Mega|Fly|Ride"] = 93.19}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 62.55, ["Fly"] = 164.07, ["Ride"] = 137.68, ["Neon"] = 216.57, ["Neon|Fly"] = 2328.88, ["Neon|Ride"] = 224.44, ["Neon|Fly|Ride"] = 410.93, ["Mega"] = 1391.87, ["Mega|Ride"] = 1404.32, ["Mega|Fly|Ride"] = 966.74}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 18.75, ["Fly|Ride"] = 106.85, ["Neon"] = 3.62, ["Neon|Ride"] = 45.93, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 26.25, ["Mega|Ride"] = 64.73, ["Mega|Fly|Ride"] = 306.66}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 27.76, ["Ride"] = 15.75, ["Fly|Ride"] = 59.07, ["Neon"] = 11.81, ["Neon|Fly"] = 137.68, ["Neon|Ride"] = 31.86, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 257.25, ["Mega|Ride"] = 122.07, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 59.07, ["Ride"] = 118.54, ["Fly|Ride"] = 223.13, ["Neon"] = 397.58, ["Neon|Ride"] = 381.75, ["Neon|Fly|Ride"] = 509.55, ["Mega"] = 1181.25, ["Mega|Ride"] = 1706.25, ["Mega|Fly|Ride"] = 1227.19}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 22.61, ["Neon"] = 7.62, ["Neon|Ride"] = 26.25, ["Mega"] = 63.56, ["Mega|Ride"] = 82.21, ["Mega|Fly|Ride"] = 232.98}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 7.88}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 39.29, ["Fly|Ride"] = 56.44, ["Neon"] = 4.66, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 39.38, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 235.36}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 103.69, ["Ride"] = 163.36, ["Fly|Ride"] = 294.62, ["Neon"] = 619.39, ["Neon|Ride"] = 680.86, ["Neon|Fly|Ride"] = 735, ["Mega"] = 3557.36, ["Mega|Ride"] = 2465.51, ["Mega|Fly|Ride"] = 2463.45}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 3.92, ["Ride"] = 36.82, ["Neon"] = 19.43, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 193.15, ["Mega"] = 145.69, ["Mega|Ride"] = 202.85, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 15.43, ["Neon"] = 3.94, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 27.75, ["Mega|Ride"] = 99.65, ["Mega|Fly|Ride"] = 122.07}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 6.8, ["Ride"] = 24.67, ["Neon"] = 49.32, ["Neon|Ride"] = 109.9, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 548.65, ["Mega|Fly|Ride"] = 573.24}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 7.88, ["Fly"] = 24.2, ["Ride"] = 26.71, ["Fly|Ride"] = 55.5, ["Neon"] = 79.42, ["Neon|Ride"] = 102.38, ["Neon|Fly|Ride"] = 164.38, ["Mega"] = 406.82, ["Mega|Ride"] = 380.63, ["Mega|Fly|Ride"] = 460.24}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 20.79, ["Ride"] = 52.4, ["Neon"] = 142.67, ["Neon|Ride"] = 195.57, ["Neon|Fly|Ride"] = 1574.99, ["Mega"] = 656.25, ["Mega|Ride"] = 446.25, ["Mega|Fly|Ride"] = 754.87}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 137.82, ["Fly"] = 247.57, ["Ride"] = 170.63, ["Fly|Ride"] = 214.47, ["Neon"] = 478.75, ["Neon|Ride"] = 498.74, ["Neon|Fly|Ride"] = 654.84, ["Mega|Fly|Ride"] = 2229.94}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 30.87, ["Fly"] = 36, ["Ride"] = 30.17, ["Fly|Ride"] = 52.5, ["Neon"] = 157.5, ["Neon|Fly"] = 6163.75, ["Neon|Ride"] = 91.86, ["Neon|Fly|Ride"] = 200.55, ["Mega|Ride"] = 712.95, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 3.94, ["Fly"] = 131.23, ["Ride"] = 30.74, ["Fly|Ride"] = 90.42, ["Neon"] = 22.05, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 117.12, ["Mega"] = 99.75, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 6.29, ["Fly"] = 231.99, ["Ride"] = 32.82, ["Neon"] = 85.32, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 380.63, ["Mega|Ride"] = 433.13}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 45.85, ["Ride"] = 88.36, ["Fly|Ride"] = 137.68, ["Neon"] = 220.49, ["Neon|Ride"] = 193.27, ["Neon|Fly|Ride"] = 341.16, ["Mega"] = 1540.95, ["Mega|Ride"] = 1026.27, ["Mega|Fly|Ride"] = 1078.67}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 21.03, ["Ride"] = 105, ["Neon"] = 155.44, ["Neon|Ride"] = 155.44, ["Neon|Fly|Ride"] = 453.05, ["Mega"] = 660.19, ["Mega|Ride"] = 739.67, ["Mega|Fly|Ride"] = 773.66}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 288.75, ["Ride"] = 410.93, ["Neon"] = 1300.56, ["Neon|Ride"] = 1370.41, ["Mega"] = 4621.79, ["Mega|Fly|Ride"] = 4610.48}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 98.73, ["Ride"] = 36.98, ["Fly|Ride"] = 125.34, ["Neon"] = 170.63, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 315, ["Mega"] = 1034.25, ["Mega|Ride"] = 900.38, ["Mega|Fly|Ride"] = 1027.3}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.21, ["Fly|Ride"] = 78.66, ["Neon"] = 2.63, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 64.28, ["Mega"] = 20.89, ["Mega|Fly"] = 102.75, ["Mega|Ride"] = 40.53, ["Mega|Fly|Ride"] = 107.63}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 3.94, ["Neon"] = 13.38, ["Neon|Ride"] = 40.46, ["Neon|Fly|Ride"] = 246.57, ["Mega"] = 162.67, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 405.79}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 3.76, ["Ride"] = 41.11, ["Fly|Ride"] = 144.16, ["Neon"] = 18.37, ["Neon|Fly"] = 87.94, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 174.57, ["Mega"] = 116.9, ["Mega|Fly"] = 142.68, ["Mega|Ride"] = 192.12, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 341.25, ["Fly"] = 619.39, ["Ride"] = 413.44, ["Fly|Ride"] = 574.16, ["Neon"] = 1489.58, ["Neon|Ride"] = 1676.55, ["Neon|Fly|Ride"] = 1371.57, ["Mega|Ride"] = 5753.01, ["Mega|Fly|Ride"] = 5033.44}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.1, ["Fly"] = 38.07, ["Ride"] = 16.95, ["Fly|Ride"] = 68.24, ["Neon"] = 20.56, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 80.14, ["Mega"] = 168, ["Mega|Ride"] = 275.18, ["Mega|Fly|Ride"] = 195.57}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 5.71, ["Fly"] = 22.32, ["Ride"] = 17.06, ["Fly|Ride"] = 39.38, ["Neon"] = 31.34, ["Neon|Fly"] = 156.45, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 685.21, ["Mega|Fly|Ride"] = 286.13}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 3.52, ["Fly"] = 41.11, ["Ride"] = 27.56, ["Fly|Ride"] = 96.58, ["Neon"] = 15.74, ["Neon|Fly"] = 151.96, ["Neon|Ride"] = 41.11, ["Neon|Fly|Ride"] = 137.68, ["Mega"] = 109.94, ["Mega|Ride"] = 190.32, ["Mega|Fly|Ride"] = 246.57}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 55.5, ["Fly"] = 137.65, ["Ride"] = 52.5, ["Fly|Ride"] = 65.63, ["Neon"] = 139.06, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 210, ["Mega|Ride"] = 1623.84, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.63, ["Fly"] = 31.43, ["Ride"] = 40.69, ["Fly|Ride"] = 69.87, ["Neon"] = 10.5, ["Neon|Ride"] = 114.19, ["Mega"] = 158.86, ["Mega|Ride"] = 410.93, ["Mega|Fly|Ride"] = 755.35}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 6.48, ["Fly"] = 787.5, ["Ride"] = 25.35, ["Fly|Ride"] = 85.31, ["Neon"] = 123.38, ["Neon|Ride"] = 155.42, ["Mega"] = 671.86, ["Mega|Fly|Ride"] = 718.09}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 19.17, ["Fly|Ride"] = 41.18, ["Neon"] = 5.25, ["Neon|Ride"] = 28.66, ["Mega"] = 39.38, ["Mega|Ride"] = 137.68, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 10.27, ["Ride"] = 134.58, ["Neon"] = 89.39, ["Neon|Ride"] = 204.39, ["Mega"] = 155.93, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 13.13, ["Ride"] = 78.08, ["Neon"] = 139.06, ["Neon|Ride"] = 101.72, ["Neon|Fly|Ride"] = 410.93, ["Mega"] = 328.13, ["Mega|Ride"] = 342.18, ["Mega|Fly|Ride"] = 493.12}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 11.69, ["Fly"] = 34.94, ["Ride"] = 26.25, ["Fly|Ride"] = 59.41, ["Neon"] = 59.07, ["Neon|Fly"] = 90.57, ["Neon|Ride"] = 59.06, ["Neon|Fly|Ride"] = 127.32, ["Mega"] = 577.35, ["Mega|Ride"] = 411.9, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 242.82, ["Fly"] = 397.58, ["Ride"] = 247.96, ["Fly|Ride"] = 393.74, ["Neon"] = 1391.87, ["Neon|Ride"] = 1068.39, ["Neon|Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 4725.54}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 15.63, ["Fly|Ride"] = 56.8, ["Neon"] = 9.87, ["Neon|Fly"] = 77.73, ["Neon|Ride"] = 27.76, ["Neon|Fly|Ride"] = 145.04, ["Mega"] = 219.86, ["Mega|Ride"] = 155.44, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 3.68, ["Fly"] = 27.86, ["Ride"] = 45.94, ["Fly|Ride"] = 110.34, ["Neon"] = 17.41, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 282.92, ["Mega|Ride"] = 269.15, ["Mega|Fly|Ride"] = 410.93}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 33.89, ["Ride"] = 117.12, ["Neon"] = 112.66, ["Neon|Ride"] = 192.12, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 393.74, ["Mega|Ride"] = 363.32, ["Mega|Fly|Ride"] = 517.79}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 139.13, ["Fly"] = 393.75, ["Ride"] = 150.45, ["Fly|Ride"] = 223.13, ["Neon"] = 1096.13, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 773.66, ["Mega"] = 2319.77, ["Mega|Ride"] = 1794.19, ["Mega|Fly|Ride"] = 2235.19}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 25.99, ["Fly"] = 117.12, ["Ride"] = 68.85, ["Fly|Ride"] = 89.39, ["Neon"] = 94.5, ["Neon|Ride"] = 133.88, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 287.66, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 449.39}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Ride"] = 14.97, ["Fly|Ride"] = 58.47, ["Neon"] = 5.25, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 51.06, ["Mega|Ride"] = 193.72, ["Mega|Fly|Ride"] = 192.94}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 11.68, ["Ride"] = 48.57, ["Neon"] = 34.1, ["Neon|Ride"] = 101.07, ["Mega"] = 201.84, ["Mega|Ride"] = 442.97, ["Mega|Fly|Ride"] = 410.93}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 58.46, ["Fly"] = 190.32, ["Ride"] = 92.8, ["Fly|Ride"] = 216.57, ["Neon"] = 144.38, ["Neon|Ride"] = 213.94, ["Neon|Fly|Ride"] = 306.41, ["Mega"] = 393.75, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 557.82}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.1, ["Neon"] = 9.19, ["Neon|Ride"] = 205.48, ["Neon|Fly|Ride"] = 179.8, ["Mega"] = 57.75, ["Mega|Fly"] = 116.82, ["Mega|Ride"] = 124.69, ["Mega|Fly|Ride"] = 143.07}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 11.82, ["Ride"] = 364.7, ["Neon"] = 105, ["Neon|Ride"] = 401.03, ["Mega"] = 328.13, ["Mega|Fly|Ride"] = 754.04}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 943.59, ["Fly"] = 1219.04, ["Ride"] = 971.28, ["Fly|Ride"] = 1102.5, ["Neon|Ride"] = 3868.22, ["Neon|Fly|Ride"] = 2618.43, ["Mega|Fly|Ride"] = 12876.04}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 24.94, ["Fly"] = 116, ["Ride"] = 108.91, ["Fly|Ride"] = 187.69, ["Neon"] = 164.38, ["Neon|Fly"] = 892.5, ["Neon|Ride"] = 205.48, ["Neon|Fly|Ride"] = 309.7, ["Mega"] = 381.86, ["Mega|Ride"] = 569.51, ["Mega|Fly|Ride"] = 685.21}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 3.94, ["Fly"] = 49.25, ["Ride"] = 27.76, ["Fly|Ride"] = 80.88, ["Neon"] = 13.11, ["Neon|Ride"] = 31.86, ["Neon|Fly|Ride"] = 113.69, ["Mega"] = 78.66, ["Mega|Ride"] = 92.8, ["Mega|Fly|Ride"] = 155.91}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 11.43, ["Ride"] = 131.22, ["Fly|Ride"] = 137.68, ["Neon"] = 102.75, ["Mega|Ride"] = 318.94, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 23.64, ["Fly|Ride"] = 52.5, ["Neon"] = 2.62, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 17.06, ["Mega|Fly"] = 123.3, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 126.39}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 60.8, ["Ride"] = 118.15, ["Fly|Ride"] = 255.94, ["Neon"] = 286.12, ["Neon|Ride"] = 340.98, ["Neon|Fly|Ride"] = 474.62, ["Mega"] = 1100.15, ["Mega|Ride"] = 1137.77, ["Mega|Fly|Ride"] = 1170.75}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 5.25, ["Ride"] = 24.94, ["Fly|Ride"] = 68.85, ["Neon"] = 19.84, ["Neon|Ride"] = 78.75, ["Mega"] = 462.81, ["Mega|Ride"] = 382.17, ["Mega|Fly|Ride"] = 410.93}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2.1, ["Fly"] = 97.69, ["Ride"] = 24.67, ["Neon"] = 11.2, ["Neon|Ride"] = 55.5, ["Neon|Fly|Ride"] = 96.58, ["Mega"] = 97.13, ["Mega|Ride"] = 157.49, ["Mega|Fly|Ride"] = 369.85}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 51.97, ["Ride"] = 74.81, ["Fly|Ride"] = 185.59, ["Neon"] = 188.41, ["Neon|Fly"] = 274.31, ["Neon|Ride"] = 137.68, ["Neon|Fly|Ride"] = 616.39, ["Mega"] = 496.44, ["Mega|Ride"] = 493.12, ["Mega|Fly|Ride"] = 672.74}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 13.13, ["Ride"] = 84.5, ["Fly|Ride"] = 92.8, ["Neon"] = 82.2, ["Neon|Ride"] = 174.6, ["Mega"] = 328.13, ["Mega|Ride"] = 504.14, ["Mega|Fly|Ride"] = 603.16}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 40.68, ["Neon"] = 309.7, ["Neon|Ride"] = 590.63, ["Neon|Fly|Ride"] = 431.47, ["Mega"] = 1505.64, ["Mega|Ride"] = 1643.67, ["Mega|Fly|Ride"] = 1579.03}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 8.89, ["Ride"] = 42, ["Neon"] = 22.87, ["Neon|Ride"] = 122.96, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 99.75, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 276.18}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 7.35, ["Ride"] = 18.38, ["Fly|Ride"] = 52.49, ["Neon"] = 44.18, ["Neon|Ride"] = 91.65, ["Neon|Fly|Ride"] = 143.07, ["Mega"] = 399, ["Mega|Ride"] = 328.29, ["Mega|Fly|Ride"] = 410.93}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 127.84, ["Ride"] = 137.65, ["Fly|Ride"] = 259.51, ["Neon"] = 608.16, ["Neon|Ride"] = 572.25, ["Neon|Fly|Ride"] = 584.07, ["Mega"] = 3141.47, ["Mega|Ride"] = 2335.15, ["Mega|Fly|Ride"] = 1889.99}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.31, ["Fly"] = 21.95, ["Ride"] = 17.07, ["Fly|Ride"] = 105000, ["Neon"] = 11.34, ["Neon|Fly"] = 64.31, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 145.59, ["Mega|Ride"] = 148.39, ["Mega|Fly|Ride"] = 199.67}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 7.35, ["Fly"] = 40.69, ["Ride"] = 31.34, ["Fly|Ride"] = 78.75, ["Neon"] = 49.9, ["Neon|Fly"] = 309.7, ["Neon|Ride"] = 69.86, ["Neon|Fly|Ride"] = 137.68, ["Mega"] = 387.41, ["Mega|Ride"] = 321.57, ["Mega|Fly|Ride"] = 314.37}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 16.96, ["Ride"] = 14.43, ["Fly|Ride"] = 40.85, ["Neon"] = 2.1, ["Neon|Fly"] = 24.09, ["Neon|Ride"] = 14.11, ["Neon|Fly|Ride"] = 44.28, ["Mega"] = 14.44, ["Mega|Fly"] = 48.74, ["Mega|Ride"] = 27.57, ["Mega|Fly|Ride"] = 80.06}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 53.43, ["Neon"] = 3.94, ["Neon|Ride"] = 39.04, ["Mega"] = 23.63, ["Mega|Fly"] = 118.12, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 158.22}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.63, ["Fly"] = 128.83, ["Ride"] = 19.69, ["Fly|Ride"] = 46.78, ["Neon"] = 26.25, ["Neon|Ride"] = 23.22, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 155.44, ["Mega|Fly|Ride"] = 232.98}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 59.07, ["Ride"] = 196.88, ["Neon"] = 307.17, ["Neon|Ride"] = 410.93, ["Neon|Fly|Ride"] = 630, ["Mega"] = 414.21, ["Mega|Ride"] = 392.44, ["Mega|Fly|Ride"] = 665.69}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.1, ["Fly"] = 20.56, ["Ride"] = 16.21, ["Fly|Ride"] = 39.04, ["Neon"] = 15.42, ["Neon|Fly"] = 35.97, ["Neon|Ride"] = 27.62, ["Neon|Fly|Ride"] = 69.05, ["Mega"] = 109.05, ["Mega|Fly"] = 170.6, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 170.39}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 4.68, ["Fly"] = 34.11, ["Ride"] = 23.28, ["Fly|Ride"] = 53.99, ["Neon"] = 20.9, ["Neon|Fly"] = 61.65, ["Neon|Ride"] = 34.94, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 169.31, ["Mega|Fly"] = 433.13, ["Mega|Ride"] = 168, ["Mega|Fly|Ride"] = 215.24}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 3.15, ["Fly"] = 19.69, ["Ride"] = 16.46, ["Fly|Ride"] = 49.88, ["Neon"] = 9.07, ["Neon|Fly"] = 98.44, ["Neon|Ride"] = 20.99, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 45.94, ["Mega|Fly"] = 97.13, ["Mega|Ride"] = 131.51, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 11.58, ["Fly"] = 27.76, ["Ride"] = 45.93, ["Fly|Ride"] = 52.5, ["Neon"] = 51.38, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 274.31, ["Mega"] = 213.48, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 260.88, ["Mega|Fly|Ride"] = 630.77}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 6.49, ["Fly"] = 170.55, ["Ride"] = 68.85, ["Fly|Ride"] = 220.34, ["Neon"] = 209.99, ["Neon|Ride"] = 252.03, ["Neon|Fly|Ride"] = 343.13, ["Mega"] = 387.41, ["Mega|Fly|Ride"] = 685.21}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 3.15, ["Fly"] = 123.3, ["Ride"] = 18.51, ["Fly|Ride"] = 61.65, ["Neon"] = 31.34, ["Neon|Fly"] = 196.66, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 105, ["Mega"] = 309.7, ["Mega|Ride"] = 227.05, ["Mega|Fly|Ride"] = 416.73}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 20.79, ["Ride"] = 15.42, ["Fly|Ride"] = 41.11, ["Neon"] = 10.37, ["Neon|Fly"] = 67.64, ["Neon|Ride"] = 31.4, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 78.75, ["Mega|Ride"] = 135.61, ["Mega|Fly|Ride"] = 203.41}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 189, ["Fly"] = 393.75, ["Ride"] = 223.13, ["Fly|Ride"] = 196.88, ["Neon"] = 937.13, ["Neon|Ride"] = 1391.87, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 2887.5}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 3.15, ["Ride"] = 61.76, ["Neon"] = 42.94, ["Neon|Fly|Ride"] = 274.31, ["Mega"] = 118.13, ["Mega|Ride"] = 410.93, ["Mega|Fly|Ride"] = 472.49}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 3.94, ["Fly"] = 23.63, ["Ride"] = 20.69, ["Fly|Ride"] = 76.04, ["Neon"] = 22.65, ["Neon|Fly"] = 205.48, ["Neon|Ride"] = 82.21, ["Neon|Fly|Ride"] = 201.8, ["Mega"] = 197.51, ["Mega|Ride"] = 274.31, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 6.18, ["Ride"] = 24.67, ["Neon"] = 52.5, ["Neon|Ride"] = 213.44, ["Neon|Fly|Ride"] = 616.39, ["Mega"] = 461.77, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 547.98}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 15.32, ["Ride"] = 14.44, ["Fly|Ride"] = 35.97, ["Neon"] = 2.1, ["Neon|Fly"] = 20.56, ["Neon|Ride"] = 15.43, ["Neon|Fly|Ride"] = 41.11, ["Mega"] = 17.75, ["Mega|Fly"] = 162.75, ["Mega|Ride"] = 31.34, ["Mega|Fly|Ride"] = 96.46}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.48, ["Fly"] = 41.11, ["Ride"] = 16.7, ["Fly|Ride"] = 61.68, ["Neon"] = 9.08, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 94.7, ["Mega"] = 103.81, ["Mega|Ride"] = 134.35, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 3.15, ["Ride"] = 60.62, ["Fly|Ride"] = 97.61, ["Neon"] = 26.25, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 59.06, ["Mega|Ride"] = 195.57, ["Mega|Fly|Ride"] = 274.31}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 74.45, ["Fly"] = 105, ["Ride"] = 98.8, ["Fly|Ride"] = 133.53, ["Neon"] = 511.52, ["Neon|Ride"] = 427.14, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 2054.59, ["Mega|Ride"] = 3426.03, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 3.94, ["Fly"] = 85.32, ["Ride"] = 45.26, ["Fly|Ride"] = 65.63, ["Neon"] = 22.32, ["Neon|Ride"] = 54.53, ["Neon|Fly|Ride"] = 92.79, ["Mega"] = 211.54, ["Mega|Ride"] = 322.59, ["Mega|Fly|Ride"] = 410.93}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 20.99, ["Ride"] = 55.04, ["Fly|Ride"] = 118.13, ["Neon"] = 10.28, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 519.53, ["Mega"] = 52.49, ["Mega|Fly"] = 313.69, ["Mega|Ride"] = 122.26, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 39.37, ["Fly"] = 210, ["Ride"] = 89.25, ["Fly|Ride"] = 220.38, ["Neon"] = 131.25, ["Neon|Ride"] = 170.62, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 548.59, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 616.39}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 14.2, ["Ride"] = 15.32, ["Fly|Ride"] = 35.97, ["Neon"] = 2.1, ["Neon|Fly"] = 15.43, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 36.75, ["Mega"] = 18.38, ["Mega|Fly"] = 48.87, ["Mega|Ride"] = 35.97, ["Mega|Fly|Ride"] = 82.21}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Neon"] = 3.9, ["Neon|Ride"] = 548.59, ["Neon|Fly|Ride"] = 89.99, ["Mega"] = 20.56, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 204.63}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 6.08, ["Ride"] = 26.17, ["Neon"] = 7.88, ["Neon|Ride"] = 57.75, ["Neon|Fly|Ride"] = 180.83, ["Mega"] = 64.32, ["Mega|Fly"] = 178.77, ["Mega|Ride"] = 107.63, ["Mega|Fly|Ride"] = 548.59}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 7.91, ["Fly"] = 89.39, ["Ride"] = 137.68, ["Fly|Ride"] = 111.56, ["Neon"] = 39.38, ["Neon|Fly"] = 136.5, ["Neon|Ride"] = 68.45, ["Neon|Fly|Ride"] = 222.74, ["Mega"] = 102.27, ["Mega|Fly"] = 220.5, ["Mega|Ride"] = 195.57, ["Mega|Fly|Ride"] = 249.37}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 13.89, ["Fly|Ride"] = 35.97, ["Neon"] = 2.1, ["Neon|Fly"] = 20.9, ["Neon|Ride"] = 27.76, ["Neon|Fly|Ride"] = 44.19, ["Mega"] = 21.81, ["Mega|Fly"] = 39.38, ["Mega|Ride"] = 32.82, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 11.81, ["Fly"] = 72.19, ["Ride"] = 41.11, ["Neon"] = 78.75, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 205.48, ["Mega"] = 496.44, ["Mega|Ride"] = 438.38, ["Mega|Fly|Ride"] = 684.2}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2572.5, ["Ride"] = 2762.82, ["Fly|Ride"] = 2607.56, ["Neon|Fly|Ride"] = 9560.98, ["Mega|Fly|Ride"] = 35887.29}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 146.16, ["Ride"] = 15.42, ["Fly|Ride"] = 42.34, ["Neon"] = 9.82, ["Neon|Fly"] = 55.5, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 55.49, ["Mega"] = 81.38, ["Mega|Fly"] = 152.06, ["Mega|Ride"] = 110.25, ["Mega|Fly|Ride"] = 169.32}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 3.82, ["Neon"] = 22.61, ["Mega"] = 126, ["Mega|Fly"] = 441, ["Mega|Ride"] = 437.07, ["Mega|Fly|Ride"] = 616.39}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 15.43, ["Fly"] = 41.11, ["Ride"] = 32.81, ["Fly|Ride"] = 186.98, ["Neon"] = 92.8, ["Neon|Ride"] = 105.57, ["Neon|Fly|Ride"] = 135.61, ["Mega"] = 393.65, ["Mega|Ride"] = 392.55, ["Mega|Fly|Ride"] = 462}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 35.62, ["Ride"] = 98.44, ["Neon"] = 137.67, ["Neon|Ride"] = 216.91, ["Mega"] = 540.75, ["Mega|Ride"] = 812.6, ["Mega|Fly|Ride"] = 804.97}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 153.08, ["Fly"] = 1370.41, ["Ride"] = 183.75, ["Fly|Ride"] = 236.25, ["Neon"] = 685.21, ["Neon|Ride"] = 718.09, ["Neon|Fly|Ride"] = 765.54, ["Mega"] = 6163.75, ["Mega|Ride"] = 3477.33, ["Mega|Fly|Ride"] = 3150}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 7.58, ["Fly"] = 27.76, ["Ride"] = 28.88, ["Fly|Ride"] = 675.94, ["Neon"] = 13.13, ["Neon|Ride"] = 128.7, ["Mega"] = 192.12, ["Mega|Fly"] = 13125, ["Mega|Ride"] = 137.68, ["Mega|Fly|Ride"] = 309.7}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 68.85, ["Neon"] = 16.46, ["Neon|Fly"] = 96.58, ["Neon|Fly|Ride"] = 513.65, ["Mega"] = 114.76, ["Mega|Ride"] = 320.25, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Fly"] = 101.99, ["Ride"] = 52.4, ["Fly|Ride"] = 196.88, ["Neon"] = 8.78, ["Neon|Ride"] = 46.23, ["Mega"] = 78.73, ["Mega|Ride"] = 112.53, ["Mega|Fly|Ride"] = 315.39}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 11.49, ["Ride"] = 39.38, ["Neon"] = 39.38, ["Neon|Ride"] = 1165.82, ["Mega"] = 374.06, ["Mega|Ride"] = 603.03, ["Mega|Fly|Ride"] = 685.21}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 89.67, ["Mega"] = 16.94, ["Mega|Ride"] = 154.88, ["Mega|Fly|Ride"] = 410.93}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 83.88, ["Fly"] = 137.68, ["Ride"] = 78.75, ["Fly|Ride"] = 155.44, ["Neon"] = 410.93, ["Neon|Ride"] = 410.93, ["Neon|Fly|Ride"] = 410.93, ["Mega"] = 1365, ["Mega|Fly|Ride"] = 1724.14}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.5, ["Ride"] = 91.81, ["Neon"] = 9.9, ["Neon|Ride"] = 137.68, ["Mega"] = 63, ["Mega|Ride"] = 152.06, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 40.84, ["Fly"] = 216.91, ["Ride"] = 74.81, ["Fly|Ride"] = 131.23, ["Neon"] = 288.75, ["Neon|Ride"] = 328.02, ["Neon|Fly|Ride"] = 408.89, ["Mega"] = 2625, ["Mega|Ride"] = 1849.14, ["Mega|Fly|Ride"] = 1620.94}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 19.53, ["Fly|Ride"] = 50.28, ["Neon"] = 6.18, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 58.47, ["Neon|Fly|Ride"] = 83.98, ["Mega"] = 43.84, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 164.99}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Neon"] = 8.94, ["Neon|Ride"] = 39.38, ["Mega"] = 69.01, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 356.1}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 11.46, ["Ride"] = 45.39, ["Fly|Ride"] = 204.45, ["Neon"] = 43.75, ["Neon|Ride"] = 86.31, ["Neon|Fly|Ride"] = 205.48, ["Mega"] = 231.99, ["Mega|Ride"] = 307.13, ["Mega|Fly|Ride"] = 905.63}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 356.03, ["Fly"] = 548.59, ["Ride"] = 458.07, ["Fly|Ride"] = 543.36, ["Neon"] = 1220.62, ["Neon|Ride"] = 1781.34, ["Neon|Fly|Ride"] = 1246.53, ["Mega|Ride"] = 3674.99, ["Mega|Fly|Ride"] = 4357.5}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 34.23, ["Ride"] = 56.13, ["Fly|Ride"] = 77.38, ["Neon"] = 205.48, ["Neon|Ride"] = 219.86, ["Neon|Fly|Ride"] = 275.63, ["Mega|Ride"] = 1212.22, ["Mega|Fly|Ride"] = 1055.03}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 42.75, ["Ride"] = 19.68, ["Fly|Ride"] = 34.13, ["Neon"] = 10.4, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 53.82, ["Neon|Fly|Ride"] = 68.85, ["Mega"] = 49.88, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 183.74}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 14.42, ["Fly"] = 45.94, ["Ride"] = 45.94, ["Fly|Ride"] = 105, ["Neon"] = 40.69, ["Neon|Fly"] = 105, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 238.88, ["Mega|Fly"] = 954.6, ["Mega|Ride"] = 244.13, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 6.13, ["Ride"] = 23.12, ["Fly|Ride"] = 91.88, ["Neon"] = 138.7, ["Neon|Ride"] = 37, ["Neon|Fly|Ride"] = 137.68, ["Mega"] = 410.93, ["Mega|Ride"] = 682.26, ["Mega|Fly|Ride"] = 396.55}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.93, ["Ride"] = 22.61, ["Neon"] = 13.13, ["Mega"] = 72.19, ["Mega|Ride"] = 122.07, ["Mega|Fly|Ride"] = 371.17}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 3.81, ["Fly"] = 52.5, ["Ride"] = 18.38, ["Fly|Ride"] = 57.64, ["Neon"] = 13.13, ["Neon|Ride"] = 32.79, ["Neon|Fly|Ride"] = 209.58, ["Mega"] = 541.68, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 956.42}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 106.4, ["Ride"] = 127.32, ["Fly|Ride"] = 182.52, ["Neon|Ride"] = 708.64, ["Neon|Fly|Ride"] = 853.13, ["Mega|Fly|Ride"] = 3426.03}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 30.19, ["Fly"] = 95.82, ["Ride"] = 94.49, ["Fly|Ride"] = 137.68, ["Neon"] = 192.94, ["Neon|Ride"] = 192.14, ["Mega"] = 821.85, ["Mega|Ride"] = 667.75, ["Mega|Fly|Ride"] = 685.79}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2216.81, ["Fly"] = 2349.37, ["Ride"] = 2229.94, ["Fly|Ride"] = 2384.82, ["Neon"] = 7534.14, ["Neon|Fly|Ride"] = 6954.94, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 2.1, ["Fly"] = 65625, ["Ride"] = 110.25, ["Fly|Ride"] = 170.63, ["Neon"] = 10.5, ["Neon|Ride"] = 135.55, ["Neon|Fly|Ride"] = 192.12, ["Mega"] = 118.13, ["Mega|Fly"] = 786.19, ["Mega|Ride"] = 164.07, ["Mega|Fly|Ride"] = 574.27}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 8.7, ["Ride"] = 45.94, ["Neon"] = 38.07, ["Neon|Ride"] = 96.58, ["Neon|Fly|Ride"] = 232.32, ["Mega"] = 217.88, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 520.72}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 853.13, ["Fly"] = 1424.85, ["Ride"] = 892.5, ["Fly|Ride"] = 984.37, ["Neon"] = 2598.75, ["Neon|Ride"] = 2493.75, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 11608.37}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 38.67, ["Ride"] = 56.44, ["Fly|Ride"] = 134.58, ["Neon"] = 156.19, ["Neon|Ride"] = 291.72, ["Neon|Fly|Ride"] = 369.85, ["Mega"] = 771.5, ["Mega|Ride"] = 773.66, ["Mega|Fly|Ride"] = 834.75}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 3.94, ["Ride"] = 22.89, ["Fly|Ride"] = 128.09, ["Neon"] = 11.62, ["Neon|Ride"] = 41.11, ["Neon|Fly|Ride"] = 328.12, ["Mega"] = 196.88, ["Mega|Ride"] = 123.3, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 137.45, ["Neon"] = 3.9, ["Neon|Ride"] = 40.57, ["Neon|Fly|Ride"] = 77.73, ["Mega"] = 82.21, ["Mega|Ride"] = 106.32, ["Mega|Fly|Ride"] = 274.31}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 81.81, ["Ride"] = 127.32, ["Fly|Ride"] = 309.7, ["Neon"] = 409.9, ["Neon|Ride"] = 433.8, ["Neon|Fly|Ride"] = 420, ["Mega"] = 2739.79, ["Mega|Fly|Ride"] = 2296.88}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 4.99, ["Fly|Ride"] = 72.19, ["Neon"] = 21, ["Neon|Ride"] = 61.65, ["Mega"] = 139.72, ["Mega|Ride"] = 191.09, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 78.63, ["Ride"] = 133.71, ["Neon"] = 385.88, ["Neon|Ride"] = 463.32, ["Neon|Fly|Ride"] = 494.32, ["Mega"] = 2328.88, ["Mega|Fly|Ride"] = 2048.43}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 4.66, ["Fly"] = 105, ["Fly|Ride"] = 109.94, ["Neon"] = 39.38, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 203.44, ["Mega|Ride"] = 309.02, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 257.25, ["Ride"] = 306.28, ["Fly|Ride"] = 333.17, ["Neon"] = 1114.1, ["Neon|Ride"] = 836.06, ["Neon|Fly|Ride"] = 879, ["Mega|Fly|Ride"] = 4231.42}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 4.58, ["Fly"] = 87.93, ["Ride"] = 22.05, ["Fly|Ride"] = 39.38, ["Neon"] = 178.19, ["Neon|Ride"] = 64.89, ["Neon|Fly|Ride"] = 111.57, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 20.9, ["Ride"] = 15.42, ["Fly|Ride"] = 39.38, ["Neon"] = 6.46, ["Neon|Fly"] = 30.91, ["Neon|Ride"] = 22.31, ["Neon|Fly|Ride"] = 43.15, ["Mega"] = 54.17, ["Mega|Fly"] = 118.15, ["Mega|Ride"] = 60.62, ["Mega|Fly|Ride"] = 143.55}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 892.4, ["Ride"] = 1050, ["Fly|Ride"] = 853.13, ["Neon|Ride"] = 7534.14, ["Neon|Fly|Ride"] = 4725.54, ["Mega"] = 26025.33, ["Mega|Fly|Ride"] = 27394.7}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 10.39, ["Fly"] = 959.51, ["Ride"] = 210, ["Neon"] = 61.65, ["Neon|Ride"] = 129.4, ["Mega"] = 236.24, ["Mega|Ride"] = 286.63, ["Mega|Fly|Ride"] = 343.13}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 9.2, ["Fly"] = 46.09, ["Ride"] = 30.09, ["Fly|Ride"] = 97.13, ["Neon"] = 29.93, ["Neon|Fly"] = 92.8, ["Neon|Ride"] = 60.38, ["Neon|Fly|Ride"] = 136.5, ["Mega"] = 177.6, ["Mega|Ride"] = 186.34, ["Mega|Fly|Ride"] = 295.32}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 51.28, ["Fly"] = 40.58, ["Ride"] = 41.96, ["Fly|Ride"] = 63.27, ["Neon"] = 274.31, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 2054.59, ["Mega|Fly|Ride"] = 861}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 14.88, ["Fly"] = 77.06, ["Ride"] = 31.86, ["Fly|Ride"] = 87.94, ["Neon"] = 65.63, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 76.15, ["Neon|Fly|Ride"] = 145.69, ["Mega"] = 367.5, ["Mega|Fly"] = 367.5, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 435.59}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 29.84, ["Ride"] = 209.99, ["Fly|Ride"] = 135.19, ["Neon"] = 98.64, ["Neon|Ride"] = 273, ["Neon|Fly|Ride"] = 274.31, ["Mega"] = 483.87, ["Mega|Ride"] = 573.24, ["Mega|Fly|Ride"] = 616.39}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 116.61, ["Fly|Ride"] = 231.99, ["Neon"] = 2.63, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 309.7, ["Mega"] = 17.07, ["Mega|Fly"] = 57.75, ["Mega|Ride"] = 64.13, ["Mega|Fly|Ride"] = 97.13}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 51.18, ["Fly"] = 68.25, ["Ride"] = 78.75, ["Fly|Ride"] = 111.57, ["Neon"] = 959.51, ["Neon|Fly"] = 323.61, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 309.7, ["Mega"] = 3287.33, ["Mega|Fly|Ride"] = 956.82}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.1, ["Fly"] = 27.76, ["Ride"] = 18.54, ["Fly|Ride"] = 69.92, ["Neon"] = 30.19, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 82.21, ["Mega"] = 773.07, ["Mega|Ride"] = 309.7, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 24.67, ["Ride"] = 20.56, ["Fly|Ride"] = 38.05, ["Neon"] = 12.72, ["Neon|Ride"] = 27.76, ["Neon|Fly|Ride"] = 122.85, ["Mega|Ride"] = 265.9, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 5.18, ["Ride"] = 171.57, ["Neon"] = 20.14, ["Neon|Fly"] = 52.5, ["Neon|Fly|Ride"] = 183.9, ["Mega"] = 246.57, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 25.48, ["Ride"] = 88.1, ["Fly|Ride"] = 183.75, ["Neon"] = 195.57, ["Neon|Ride"] = 243.6, ["Neon|Fly|Ride"] = 328.75, ["Mega"] = 726.31, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 735}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 7.88, ["Ride"] = 131.25, ["Neon"] = 22.93, ["Neon|Ride"] = 77.06, ["Neon|Fly|Ride"] = 124.13, ["Mega"] = 91.24, ["Mega|Ride"] = 109.94, ["Mega|Fly|Ride"] = 309.7}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 33.78, ["Neon"] = 2.61, ["Neon|Ride"] = 20.6, ["Mega"] = 15.75, ["Mega|Ride"] = 53.43, ["Mega|Fly|Ride"] = 205.48}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 68.85, ["Ride"] = 25.1, ["Fly|Ride"] = 81.06, ["Neon"] = 2.57, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 55.5, ["Mega"] = 19.68, ["Mega|Ride"] = 38.67, ["Mega|Fly|Ride"] = 104.9}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 20, ["Ride"] = 15.85, ["Fly|Ride"] = 40.25, ["Neon"] = 7.87, ["Neon|Fly"] = 123.3, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 61.69, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 139.13}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 27.75, ["Fly|Ride"] = 109.94, ["Neon"] = 34.94, ["Mega"] = 105, ["Mega|Ride"] = 106.3, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 38.05, ["Ride"] = 15.72, ["Fly|Ride"] = 35.44, ["Neon"] = 14.43, ["Neon|Ride"] = 31.34, ["Neon|Fly|Ride"] = 77.58, ["Mega"] = 307.79, ["Mega|Ride"] = 274.31, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 69.93, ["Ride"] = 150.94, ["Neon"] = 173.24, ["Neon|Ride"] = 231.27, ["Neon|Fly|Ride"] = 1027.3, ["Mega"] = 1232.76, ["Mega|Ride"] = 883.31, ["Mega|Fly|Ride"] = 926.76}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 15.14, ["Ride"] = 15.43, ["Fly|Ride"] = 35.32, ["Neon"] = 2.62, ["Neon|Fly"] = 24.67, ["Neon|Ride"] = 23.64, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 39.04, ["Mega|Ride"] = 42.73, ["Mega|Fly|Ride"] = 103.95}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 10.38, ["Fly"] = 61.02, ["Ride"] = 37.13, ["Fly|Ride"] = 79.71, ["Neon"] = 685.21, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 62.51, ["Neon|Fly|Ride"] = 114.19, ["Mega"] = 262.5, ["Mega|Ride"] = 216.56, ["Mega|Fly|Ride"] = 299.24}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 14.31, ["Fly"] = 51.48, ["Ride"] = 28.5, ["Fly|Ride"] = 74.25, ["Neon"] = 109.26, ["Neon|Ride"] = 96.58, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 1160.85, ["Mega|Ride"] = 524.99, ["Mega|Fly|Ride"] = 560.9}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 2.63, ["Fly"] = 196.88, ["Neon"] = 60.62, ["Mega"] = 131.25, ["Mega|Ride"] = 246.88, ["Mega|Fly|Ride"] = 405.79}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 27.76, ["Ride"] = 15.43, ["Fly|Ride"] = 35.96, ["Neon"] = 4.13, ["Neon|Fly"] = 40.09, ["Neon|Ride"] = 23.64, ["Neon|Fly|Ride"] = 45.82, ["Mega"] = 72.19, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 64.42, ["Mega|Fly|Ride"] = 131.15}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 3.77, ["Fly"] = 68.85, ["Ride"] = 27.76, ["Neon"] = 15.42, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 96.53, ["Neon|Fly|Ride"] = 205.48, ["Mega"] = 136.5, ["Mega|Fly"] = 735, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 376}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 944.99, ["Fly"] = 1232.76, ["Ride"] = 958.13, ["Fly|Ride"] = 1056.57, ["Neon"] = 2296.88, ["Neon|Ride"] = 2191.86, ["Neon|Fly|Ride"] = 2331, ["Mega|Fly|Ride"] = 5906.15}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 80.76, ["Ride"] = 124.69, ["Fly|Ride"] = 155.44, ["Neon"] = 384.21, ["Neon|Ride"] = 458.07, ["Neon|Fly|Ride"] = 589.68, ["Mega"] = 2783.72, ["Mega|Ride"] = 1919, ["Mega|Fly|Ride"] = 1701.56}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Neon"] = 4.66, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 205.48, ["Mega"] = 72.1, ["Mega|Ride"] = 102.75, ["Mega|Fly|Ride"] = 205.48}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 45.93, ["Fly"] = 152.06, ["Ride"] = 78.75, ["Fly|Ride"] = 190.32, ["Neon"] = 262.49, ["Neon|Ride"] = 326.12, ["Neon|Fly|Ride"] = 384.22, ["Mega"] = 1023.75, ["Mega|Ride"] = 1162.62, ["Mega|Fly|Ride"] = 1102.5}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 5.25, ["Ride"] = 20.34, ["Fly|Ride"] = 65.63, ["Neon"] = 61.65, ["Neon|Ride"] = 49.45, ["Neon|Fly|Ride"] = 273.28, ["Mega"] = 268.55, ["Mega|Ride"] = 345.18, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 242.82, ["Fly"] = 301.88, ["Ride"] = 274.32, ["Fly|Ride"] = 335.93, ["Neon|Ride"] = 1327.27, ["Neon|Fly|Ride"] = 1386.86, ["Mega|Fly|Ride"] = 4175.57}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 75.64, ["Ride"] = 26.25, ["Fly|Ride"] = 202.64, ["Neon"] = 24.66, ["Neon|Ride"] = 54.37, ["Mega"] = 123.3, ["Mega|Fly"] = 320.53}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Ride"] = 26.17, ["Neon"] = 32.82, ["Mega"] = 328.75, ["Mega|Ride"] = 326.7}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 63, ["Ride"] = 96.55, ["Fly|Ride"] = 525, ["Neon"] = 548.59, ["Neon|Ride"] = 175.88, ["Mega"] = 542, ["Mega|Ride"] = 472.5, ["Mega|Fly|Ride"] = 966}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 49.54, ["Neon"] = 20.56, ["Mega"] = 78.75, ["Mega|Ride"] = 250.74, ["Mega|Fly|Ride"] = 453.52}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 14.43, ["Fly|Ride"] = 32.48, ["Neon"] = 3.68, ["Neon|Fly"] = 17.07, ["Neon|Ride"] = 137.62, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 24.43, ["Mega|Ride"] = 48.29, ["Mega|Fly|Ride"] = 152.06}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4134.38, ["Ride"] = 4446.75, ["Fly|Ride"] = 4200, ["Neon"] = 30818.65, ["Neon|Fly|Ride"] = 21641.89, ["Mega|Fly|Ride"] = 84922.82}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 10.27, ["Fly"] = 39.38, ["Ride"] = 56.43, ["Neon"] = 78.63, ["Neon|Ride"] = 106.32, ["Mega"] = 274.31, ["Mega|Ride"] = 213.29, ["Mega|Fly|Ride"] = 320.53}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 20.09, ["Ride"] = 21.92, ["Fly|Ride"] = 55.5, ["Neon"] = 16.94, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 79.54, ["Mega"] = 137.82, ["Mega|Ride"] = 154.88, ["Mega|Fly|Ride"] = 189.11}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 468.45, ["Fly"] = 541.68, ["Ride"] = 500.07, ["Fly|Ride"] = 567.42, ["Neon"] = 1372.81, ["Neon|Ride"] = 1547.11, ["Neon|Fly|Ride"] = 1286.25, ["Mega|Fly|Ride"] = 5078.07}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 11.71, ["Ride"] = 25.39, ["Neon"] = 17.06, ["Neon|Ride"] = 145.69, ["Mega"] = 187.85, ["Mega|Ride"] = 619.39, ["Mega|Fly|Ride"] = 685.21}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 7.88, ["Fly"] = 137.68, ["Ride"] = 46.35, ["Neon"] = 131.25, ["Neon|Ride"] = 274.31, ["Neon|Fly|Ride"] = 274.31, ["Mega"] = 408.89, ["Mega|Ride"] = 356.1, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 52.45, ["Ride"] = 26.61, ["Neon"] = 3.94, ["Neon|Fly"] = 124.68, ["Neon|Ride"] = 22.61, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 44.63, ["Mega|Ride"] = 74.71, ["Mega|Fly|Ride"] = 255.94}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 712.95, ["Fly"] = 808.49, ["Ride"] = 656.25, ["Fly|Ride"] = 730.57, ["Neon"] = 2362.5, ["Neon|Ride"] = 2017.24, ["Neon|Fly|Ride"] = 1968.75, ["Mega|Fly|Ride"] = 9588.72}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 6.5, ["Ride"] = 61.65, ["Neon"] = 23.5, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 179.15, ["Mega"] = 146.24, ["Mega|Ride"] = 179.8, ["Mega|Fly|Ride"] = 294.67}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 10.29, ["Fly"] = 236.15, ["Ride"] = 63.25, ["Neon"] = 39.48, ["Neon|Fly"] = 164.38, ["Neon|Ride"] = 68.85, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 183.75, ["Mega|Ride"] = 242.5, ["Mega|Fly|Ride"] = 291.38}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 34.11, ["Ride"] = 19.84, ["Fly|Ride"] = 47.25, ["Neon"] = 13.98, ["Neon|Fly"] = 96.58, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 70.88, ["Mega"] = 131.25, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 17.99, ["Ride"] = 46.39, ["Fly|Ride"] = 155.44, ["Neon"] = 117.59, ["Neon|Fly"] = 170.63, ["Neon|Ride"] = 137.68, ["Mega"] = 541.68, ["Mega|Fly|Ride"] = 616.39}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Fly|Ride"] = 205.48, ["Neon"] = 5.2, ["Neon|Fly"] = 137.68, ["Neon|Ride"] = 39.13, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 43.32, ["Mega|Fly"] = 109.94, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 481.37}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 520.86, ["Ride"] = 546.56, ["Fly|Ride"] = 696.52, ["Neon"] = 2876.42, ["Neon|Ride"] = 2707.17, ["Neon|Fly|Ride"] = 2711.37, ["Mega|Ride"] = 9047.06, ["Mega|Fly|Ride"] = 7861.88}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 49.88, ["Fly|Ride"] = 178.63, ["Neon"] = 9.09, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 65.62, ["Mega|Ride"] = 152.8, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 41.21, ["Neon"] = 5.16, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 53.43, ["Mega|Fly"] = 100.69, ["Mega|Ride"] = 137.68, ["Mega|Fly|Ride"] = 254.78}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 24.45, ["Neon"] = 5.12, ["Neon|Ride"] = 41.31, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 44.62, ["Mega|Fly"] = 152.06, ["Mega|Ride"] = 78.74, ["Mega|Fly|Ride"] = 192.12}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 5.25, ["Ride"] = 131.25, ["Neon"] = 18.48, ["Neon|Ride"] = 39.44, ["Mega"] = 224.99}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 36.05, ["Fly"] = 98.44, ["Ride"] = 129.94, ["Fly|Ride"] = 262.77, ["Neon"] = 153.67, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 215.25, ["Mega"] = 632.71, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 670.89}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 16.94, ["Ride"] = 53.82, ["Fly|Ride"] = 116.6, ["Neon"] = 103.69, ["Neon|Ride"] = 129.62, ["Neon|Fly|Ride"] = 301.77, ["Mega"] = 463.97, ["Mega|Ride"] = 385.88, ["Mega|Fly|Ride"] = 560.79}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly"] = 27.76, ["Ride"] = 16.44, ["Fly|Ride"] = 38.07, ["Neon"] = 27.85, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 77.44, ["Mega"] = 299.92, ["Mega|Ride"] = 347.24, ["Mega|Fly|Ride"] = 199.86}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 6.57, ["Ride"] = 64.32, ["Neon"] = 92.47, ["Neon|Ride"] = 137.68, ["Mega"] = 262.5, ["Mega|Ride"] = 773.66, ["Mega|Fly|Ride"] = 959.51}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Fly"] = 157.5, ["Ride"] = 24.93, ["Fly|Ride"] = 44.63, ["Neon"] = 14.44, ["Neon|Ride"] = 31.34, ["Neon|Fly|Ride"] = 206.47, ["Mega"] = 84, ["Mega|Fly"] = 147.94, ["Mega|Ride"] = 152.06, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 20.99, ["Fly"] = 62.66, ["Ride"] = 23.13, ["Fly|Ride"] = 155.43, ["Neon"] = 228.74, ["Neon|Ride"] = 175.93, ["Neon|Fly|Ride"] = 238.23, ["Mega"] = 923.54, ["Mega|Ride"] = 927.91, ["Mega|Fly|Ride"] = 623.58}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 34.13, ["Fly"] = 874.13, ["Neon"] = 106.32, ["Mega"] = 328.13, ["Mega|Fly|Ride"] = 849.58}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 64.32, ["Fly"] = 78.75, ["Ride"] = 70.88, ["Fly|Ride"] = 181.65, ["Neon"] = 262.5, ["Neon|Ride"] = 240.38, ["Neon|Fly|Ride"] = 367.5, ["Mega|Ride"] = 1438.21, ["Mega|Fly|Ride"] = 1194.38}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 58.57, ["Fly"] = 92.79, ["Ride"] = 78.75, ["Fly|Ride"] = 198.19, ["Neon"] = 129.94, ["Neon|Ride"] = 137.68, ["Neon|Fly|Ride"] = 356.1, ["Mega"] = 576.35, ["Mega|Ride"] = 616.88, ["Mega|Fly|Ride"] = 620.82}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 22.67, ["Ride"] = 26.25, ["Fly|Ride"] = 137.68, ["Neon"] = 127.32, ["Neon|Ride"] = 274.31, ["Mega"] = 821.85, ["Mega|Fly|Ride"] = 959.51}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 11.82, ["Fly"] = 428.26, ["Ride"] = 46.07, ["Fly|Ride"] = 185.07, ["Neon"] = 86.16, ["Neon|Ride"] = 120.74, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 457.47, ["Mega|Ride"] = 366.19, ["Mega|Fly|Ride"] = 501.55}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 15.43, ["Ride"] = 15.41, ["Fly|Ride"] = 32.89, ["Neon"] = 5.2, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 20.56, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 44.61, ["Mega|Fly"] = 205.48, ["Mega|Ride"] = 57.75, ["Mega|Fly|Ride"] = 202.79}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1890}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 36.63, ["Ride"] = 91.88, ["Fly|Ride"] = 131.25, ["Neon"] = 210, ["Neon|Ride"] = 245.55, ["Neon|Fly|Ride"] = 303.07, ["Mega"] = 684.2, ["Mega|Ride"] = 602.44, ["Mega|Fly|Ride"] = 753.56}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 55.5, ["Neon"] = 3.94, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 287.66, ["Mega"] = 26.25, ["Mega|Ride"] = 65.66, ["Mega|Fly|Ride"] = 137.68}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 31.5, ["Ride"] = 68.85, ["Neon"] = 128.37, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 525, ["Mega|Ride"] = 718.09, ["Mega|Fly|Ride"] = 795.14}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 3.68, ["Neon|Ride"] = 105, ["Mega"] = 22.23}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Mega"] = 24.23, ["Mega|Ride"] = 106.81, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 99.73, ["Ride"] = 122.06, ["Fly|Ride"] = 246.57, ["Neon"] = 498.74, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 671.86, ["Mega|Ride"] = 2041.24, ["Mega|Fly|Ride"] = 2187.93}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.63, ["Fly"] = 26.25, ["Ride"] = 17.07, ["Fly|Ride"] = 92.67, ["Neon"] = 8.13, ["Neon|Ride"] = 23.64, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 90.56, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 205.48}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 38.07, ["Fly|Ride"] = 86.63, ["Neon"] = 3.84, ["Neon|Fly"] = 61.65, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 102.75, ["Mega"] = 32.03, ["Mega|Ride"] = 122.26, ["Mega|Fly|Ride"] = 220.5}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Ride"] = 44.18, ["Mega"] = 34.02, ["Mega|Ride"] = 183.74}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 4.93, ["Neon|Ride"] = 137.71, ["Mega"] = 55.13, ["Mega|Ride"] = 96.56, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 64.96, ["Ride"] = 69.57, ["Fly|Ride"] = 449.61, ["Neon"] = 415.64, ["Neon|Ride"] = 491.07, ["Neon|Fly|Ride"] = 685.21, ["Mega"] = 1540.95, ["Mega|Ride"] = 1540.95, ["Mega|Fly|Ride"] = 1322.13}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 3.59, ["Ride"] = 62.66, ["Fly|Ride"] = 131.25, ["Neon"] = 24.93, ["Neon|Ride"] = 153.25, ["Mega"] = 364.58, ["Mega|Ride"] = 840.67}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 325.49, ["Ride"] = 410.93, ["Fly|Ride"] = 616.88, ["Neon"] = 1641.62, ["Neon|Ride"] = 1222.53, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Ride"] = 4108.14, ["Mega|Fly|Ride"] = 3836.44}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 78.75}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 39.38}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 22.32}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 31.4}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 58.58}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 48.57}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 13.61}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 7.45}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 245.43}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 12.34}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 28.88}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 4.99}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 3.94}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 205.48}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 7.88}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 17.07}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 3.94}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 5.2}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 10.5}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 510.57}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.63}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 10.5}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1704.94}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.63}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 32.66}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 7.88}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 20.25}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.63}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.58}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 31.5}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 26.17}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 51.19}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 19.69}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 8.37}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 14.02}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 3.1}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 11.82}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.63}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 13.63}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 7.88}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 5.25}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.52}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 1836.01}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 44.1}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 308.44}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 2.12}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.63}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 7.76}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 5.9}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 34.54}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 195.46}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 5.25}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 7.48}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 131.25}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 21}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 5.25}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.63}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 18.56}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 13.13}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 3.84}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 157.5}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 25.98}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 9.75}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.63}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 25.4}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.63}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 6.17}},
    ["rbxassetid://1265129203"] = {name = "Ice Snowboard", prices = {["default"] = 1953}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 3.9}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 27.57}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.63}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 92.99}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 190.31}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 4.66}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 8.61}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 21}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 24.94}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 72.19}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 15.75}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22037.68}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 548.59}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 36.75}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 81.38}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 40.69}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 274.31}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 91.88}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 32.81}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 68.14}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 63.56}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 45.94}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 52.49}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 42}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 39.36}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 177.38}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 274.31}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 2.63}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 7.06}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 5.94}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 5.25}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 23.63}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 73.15}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.15}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 5.25}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.63}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 4.89}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 6.57}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 263}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 745.49}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 7.77}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 577.48}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 19.69}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.38}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.1}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 603.16}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 43.64}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 115.39}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 32.82}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 49.26}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 65.63}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 22.32}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 3.94}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 14.44}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 3.81}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 4.6}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 10.5}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 31.5}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 3.94}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 2.63}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 5.25}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 16.7}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 117.93}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 84}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.63}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.63}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 1048.69}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 5.25}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 4.66}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 5.25}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 16.21}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 30.19}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 6.57}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 7.88}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 13.13}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 11.8}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 61.09}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 27.47}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 7.88}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 36.66}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 6.9}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 3.89}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 3.94}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 6}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 137.61}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 2.79}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 3.94}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.63}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 3.28}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.41}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 3.71}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 5847.19}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.49}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 14.44}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 2.37}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 8.07}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 4.45}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 6.98}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 9.09}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 3.94}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 3.29}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 9.19}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 95.7}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.5}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 5.25}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 2.43}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 11.12}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 3.93}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 4.13}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 5.25}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4058.57}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 5.25}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 44.54}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 4.32}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 3.94}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 37.41}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 3.67}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 8.03}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 91.87}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.63}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 2.14}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 3.94}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 7.65}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 3.77}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 5.25}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 19.47}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 3.93}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.24}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.54}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.61}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.63}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 9.19}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 10.5}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 2.93}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.37}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 3.94}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.63}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 3.61}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 14.7}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.63}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 2625}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 7.39}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 84.74}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.48}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 39.38}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 3.82}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 3.71}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 971.25}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 31.5}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.63}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 4.72}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 10.5}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 23.63}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 10.16}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 68.25}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 3.35}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 5.15}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 11.09}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 12.59}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 18.38}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 4.97}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 3.94}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 13.01}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 3.94}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.63}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 13.13}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 5.02}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 7.3}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 11.62}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 51.35}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 7.56}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 6.98}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.63}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 14.44}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 39.9}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 18.15}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 3.69}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 3.94}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 81.38}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.63}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 26.25}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.63}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.63}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.63}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 3.94}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 2.12}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 7.88}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 2.15}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 5.25}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 118.02}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.52}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.43}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 131.14}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1082.82}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 212.63}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 2.63}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.63}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 22.32}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 63}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 15.75}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 3.94}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 39.38}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 9.19}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 6.57}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 77.73}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 15.75}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 6.13}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 56.44}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 5.25}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 70.88}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 3.76}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.37}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 28.88}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 115.5}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 4.7}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 2.63}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 69.57}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 3.94}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 3.39}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 3.94}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 192.55}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.63}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 52.5}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 685.21}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 3.68}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 137.68}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 131.39}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.91}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 3.9}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 14.44}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 59.75}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 3.94}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 41.99}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 3.94}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 73.49}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 15.75}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 13.49}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 23.63}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 6.08}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 21}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 15.75}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 71.81}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 5.25}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 5.16}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 129.55}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 3.67}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 7.88}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 45.82}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 4.13}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 67.39}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 137.78}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1758.75}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 6.57}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 6.57}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 35.44}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 361.72}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 24.76}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 9.19}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 41.01}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 9.07}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 5.25}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 273}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 32.02}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 38.07}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 3.94}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.17}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 73.5}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 128.88}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 65.63}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 1155}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 191.63}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 7.88}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 2054.59}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 418.69}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 4.13}},
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