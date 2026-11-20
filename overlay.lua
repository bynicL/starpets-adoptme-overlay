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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 1261.49, ["Ride"] = 1158.76, ["Fly|Ride"] = 1025.07, ["Neon|Fly|Ride"] = 3849.69}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 459.38, ["Ride"] = 418.69, ["Fly|Ride"] = 838.94, ["Neon|Fly|Ride"] = 2939.5, ["Mega|Fly|Ride"] = 8380.68}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 4725, ["Ride"] = 4921.88, ["Fly|Ride"] = 4987.5, ["Neon"] = 25889.49, ["Neon|Fly|Ride"] = 19820.52, ["Mega|Fly|Ride"] = 55990.85}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 115.5, ["Ride"] = 187.69, ["Fly|Ride"] = 271.95, ["Neon"] = 1190.22, ["Neon|Ride"] = 1128.75, ["Neon|Fly|Ride"] = 733.69, ["Mega"] = 3501.15, ["Mega|Fly|Ride"] = 3100.44}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 525, ["Ride"] = 620.03, ["Fly|Ride"] = 590.63, ["Neon|Fly|Ride"] = 2100, ["Mega"] = 11052.05, ["Mega|Fly|Ride"] = 6337.78}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 10.53, ["Ride"] = 46.47, ["Fly|Ride"] = 140.66, ["Neon"] = 45.94, ["Neon|Ride"] = 141.56, ["Neon|Fly|Ride"] = 310.41, ["Mega"] = 280.88, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 409.5}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 4.99, ["Fly"] = 37.87, ["Ride"] = 28.7, ["Fly|Ride"] = 62.71, ["Neon"] = 23.25, ["Neon|Fly"] = 108.11, ["Neon|Ride"] = 48.24, ["Neon|Fly|Ride"] = 91.87, ["Mega"] = 182.68, ["Mega|Ride"] = 188.98, ["Mega|Fly|Ride"] = 268.76}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 105.13, ["Ride"] = 131.25, ["Fly|Ride"] = 251.91, ["Neon"] = 589.32, ["Neon|Fly|Ride"] = 700.24, ["Mega"] = 1860.04, ["Mega|Fly|Ride"] = 1694.42}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 36.09, ["Ride"] = 52.45, ["Fly|Ride"] = 92.9, ["Neon"] = 375.38, ["Neon|Ride"] = 224.44, ["Neon|Fly|Ride"] = 296.63, ["Mega"] = 2100, ["Mega|Ride"] = 1255.53, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 28.4, ["Fly"] = 94.5, ["Ride"] = 39.87, ["Fly|Ride"] = 66.94, ["Neon"] = 280.25, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 182.68, ["Mega|Fly|Ride"] = 620.8}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 46.57, ["Ride"] = 54.63, ["Fly|Ride"] = 141.75, ["Neon"] = 266.6, ["Neon|Ride"] = 217.88, ["Neon|Fly|Ride"] = 276.7, ["Mega|Fly|Ride"] = 1077.57}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 64.32}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 450.42, ["Fly"] = 354.38, ["Ride"] = 374.07, ["Fly|Ride"] = 380.63, ["Neon"] = 1570.15, ["Neon|Ride"] = 1667.08, ["Neon|Fly|Ride"] = 1311.19, ["Mega|Fly|Ride"] = 4493.23}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 143.07, ["Ride"] = 127.32, ["Fly|Ride"] = 162.75, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 577.5, ["Mega|Fly|Ride"] = 2660.25}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 3.29, ["Ride"] = 32.82, ["Fly|Ride"] = 65.63, ["Neon"] = 21, ["Neon|Fly"] = 61.94, ["Neon|Ride"] = 131.25, ["Mega|Ride"] = 189, ["Mega|Fly|Ride"] = 280.32}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 144.38, ["Fly"] = 152.25, ["Ride"] = 152.25, ["Fly|Ride"] = 158.36, ["Neon"] = 1119.89, ["Neon|Fly|Ride"] = 484.71, ["Mega|Fly|Ride"] = 1836.19}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.93, ["Fly"] = 27.29, ["Ride"] = 22.44, ["Fly|Ride"] = 45.94, ["Neon"] = 27.57, ["Neon|Ride"] = 69.3, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 787.5, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 46.57, ["Fly"] = 140.44, ["Ride"] = 91.88, ["Fly|Ride"] = 105, ["Neon"] = 178.99, ["Neon|Ride"] = 164.07, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 980.55, ["Mega|Ride"] = 728.59, ["Mega|Fly|Ride"] = 791.58}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 57.75}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 64.32, ["Ride"] = 83.91, ["Neon"] = 629.74, ["Mega"] = 3080.17, ["Mega|Fly|Ride"] = 3100.44}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 15.78, ["Fly"] = 393.75, ["Ride"] = 32.02, ["Fly|Ride"] = 131.25, ["Neon"] = 140.66, ["Neon|Ride"] = 360.94, ["Neon|Fly|Ride"] = 260.37, ["Mega"] = 465.02, ["Mega|Ride"] = 603.37, ["Mega|Fly|Ride"] = 1679.71}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 28.88, ["Fly"] = 99.75, ["Ride"] = 51.19, ["Fly|Ride"] = 134.25, ["Neon"] = 532.14, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 257.25, ["Mega"] = 1681.32, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 57.75, ["Fly"] = 99.75, ["Ride"] = 155.76, ["Fly|Ride"] = 196.88, ["Neon"] = 224.62, ["Neon|Ride"] = 419.63, ["Neon|Fly|Ride"] = 314.96, ["Mega"] = 1679.71, ["Mega|Ride"] = 1255.59, ["Mega|Fly|Ride"] = 1241.94}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 36.82, ["Ride"] = 45.94, ["Fly|Ride"] = 141.1, ["Neon|Ride"] = 232.52, ["Neon|Fly|Ride"] = 408.19, ["Mega"] = 1207.92, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 980.55}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 43.32, ["Fly"] = 648.22, ["Ride"] = 73.5, ["Fly|Ride"] = 135.19, ["Neon"] = 280.25, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 465.02, ["Mega|Ride"] = 1023.65, ["Mega|Fly|Ride"] = 1119.12}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 7.88, ["Fly"] = 25.25, ["Ride"] = 21.19, ["Fly|Ride"] = 42, ["Neon"] = 37.56, ["Neon|Fly"] = 77.68, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 89.77, ["Mega"] = 141.75, ["Mega|Fly"] = 249.38, ["Mega|Ride"] = 155.39, ["Mega|Fly|Ride"] = 279.27}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 390.02, ["Ride"] = 341.25, ["Fly|Ride"] = 328.13, ["Neon|Ride"] = 1469.75, ["Neon|Fly|Ride"] = 1820.4, ["Mega"] = 10498.16, ["Mega|Fly|Ride"] = 5890.48}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 13.52, ["Ride"] = 39.87, ["Neon"] = 238.26, ["Neon|Ride"] = 304.5, ["Mega"] = 826.22, ["Mega|Fly|Ride"] = 788.42}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 6.33, ["Fly"] = 37.7, ["Ride"] = 26.25, ["Fly|Ride"] = 46.13, ["Neon"] = 52.5, ["Neon|Fly"] = 89.25, ["Neon|Ride"] = 61.09, ["Neon|Fly|Ride"] = 118.02, ["Mega"] = 419.94, ["Mega|Fly|Ride"] = 371.44}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 105, ["Fly"] = 128.97, ["Ride"] = 135.19, ["Fly|Ride"] = 140.66, ["Neon"] = 372.61, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 427.29, ["Mega"] = 6160.19, ["Mega|Ride"] = 7290.94, ["Mega|Fly|Ride"] = 1495.55}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 9.33, ["Ride"] = 31.37, ["Fly|Ride"] = 62.93, ["Neon"] = 70.33, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 207.38, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 629.9}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 182.93, ["Fly"] = 357.31, ["Ride"] = 249.6, ["Fly|Ride"] = 419.84, ["Neon"] = 700.07, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 818.88, ["Mega"] = 6298.91, ["Mega|Fly|Ride"] = 2939.5}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 35.44}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.93, ["Fly"] = 31.44, ["Ride"] = 37.77, ["Fly|Ride"] = 115.5, ["Neon"] = 17.45, ["Neon|Fly"] = 65.09, ["Neon|Ride"] = 48.84, ["Neon|Fly|Ride"] = 310.41, ["Mega"] = 131.25, ["Mega|Ride"] = 167.98, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 669.38, ["Ride"] = 882, ["Fly|Ride"] = 901.59, ["Neon"] = 3079.42, ["Neon|Ride"] = 3043.43, ["Neon|Fly|Ride"] = 3080.17, ["Mega"] = 30847.38, ["Mega|Ride"] = 52313.22, ["Mega|Fly|Ride"] = 11195.24}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 11.81, ["Ride"] = 26.25, ["Fly|Ride"] = 91.08, ["Neon"] = 63.09, ["Neon|Fly"] = 140.66, ["Neon|Ride"] = 139.86, ["Neon|Fly|Ride"] = 125.98, ["Mega"] = 787.5, ["Mega|Ride"] = 606.81, ["Mega|Fly|Ride"] = 820.32}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 140.87, ["Ride"] = 144.38, ["Fly|Ride"] = 266.6, ["Neon"] = 628.7, ["Neon|Ride"] = 514.5, ["Neon|Fly|Ride"] = 910.21, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 2788.89}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 46.27}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 24.09, ["Fly|Ride"] = 262.5, ["Neon"] = 167.95, ["Neon|Ride"] = 250.91, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 692.9, ["Mega|Ride"] = 723.19, ["Mega|Fly|Ride"] = 775.42}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 185.06, ["Ride"] = 209.13, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 686.59, ["Mega|Fly|Ride"] = 1946.37}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 131.24, ["Ride"] = 168.16, ["Fly|Ride"] = 262.5, ["Neon"] = 419.63, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 574.26, ["Mega|Fly|Ride"] = 1705.43}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 55.13}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 60.38, ["Fly"] = 93.49, ["Ride"] = 57.75, ["Fly|Ride"] = 78.52, ["Neon|Ride"] = 392.65, ["Neon|Fly|Ride"] = 360.94, ["Mega"] = 4199.27, ["Mega|Fly|Ride"] = 1257.69}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 9.33, ["Ride"] = 145.69, ["Fly|Ride"] = 158.49, ["Neon"] = 37.8, ["Neon|Ride"] = 155.39, ["Neon|Fly|Ride"] = 182.44, ["Mega"] = 205.78, ["Mega|Fly"] = 267.75, ["Mega|Fly|Ride"] = 343.3}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 339.56, ["Fly"] = 578.19, ["Ride"] = 346.5, ["Fly|Ride"] = 426.44, ["Neon|Ride"] = 1400.46, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 6975.11}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 73.5, ["Fly"] = 94.5, ["Ride"] = 85.32, ["Fly|Ride"] = 129.11, ["Neon"] = 364.91, ["Neon|Ride"] = 419.94, ["Neon|Fly|Ride"] = 301.88, ["Mega|Ride"] = 1876.03, ["Mega|Fly|Ride"] = 1561.88}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3140.02, ["Ride"] = 3734.63, ["Fly|Ride"] = 3543.75, ["Neon|Fly|Ride"] = 13646.56}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 41.02, ["Fly"] = 224.98, ["Ride"] = 56.44, ["Fly|Ride"] = 110.32, ["Neon"] = 980.31, ["Neon|Ride"] = 408.19, ["Neon|Fly|Ride"] = 263.82, ["Mega"] = 1889.69, ["Mega|Ride"] = 1889.69, ["Mega|Fly|Ride"] = 1674.47}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 130.37, ["Ride"] = 92.9, ["Fly|Ride"] = 155.23, ["Neon"] = 393.75, ["Neon|Ride"] = 342.96, ["Neon|Fly|Ride"] = 560.62, ["Mega"] = 6298.91, ["Mega|Fly|Ride"] = 1506.5}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 32.82, ["Fly"] = 77.99, ["Ride"] = 43.32, ["Fly|Ride"] = 139.65, ["Neon"] = 196.29, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 220.48, ["Mega"] = 2598.75, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 658.25}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 12.63}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 63, ["Ride"] = 65.63, ["Fly|Ride"] = 140.48, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 504, ["Mega|Fly|Ride"] = 1792.05}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 40.69}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 227.07, ["Ride"] = 234.94, ["Fly|Ride"] = 336.72, ["Neon|Fly|Ride"] = 1456.11}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 761.25, ["Ride"] = 761.15, ["Fly|Ride"] = 735, ["Neon|Fly|Ride"] = 2493.75, ["Mega|Ride"] = 11757.95, ["Mega|Fly|Ride"] = 11812.5}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 5.13}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 31.5, ["Fly"] = 66.35, ["Ride"] = 39.38, ["Fly|Ride"] = 75.58, ["Neon"] = 319.08, ["Neon|Ride"] = 167.9, ["Neon|Fly|Ride"] = 196.88, ["Mega|Fly|Ride"] = 777.45}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 9.19}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5118.75, ["Fly|Ride"] = 4777.5, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 41695.98}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 10.5, ["Ride"] = 26.25, ["Fly|Ride"] = 58.3, ["Neon"] = 91.88, ["Neon|Ride"] = 100.8, ["Neon|Fly|Ride"] = 140.44, ["Mega"] = 620.8, ["Mega|Ride"] = 1514.63, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 14.97, ["Fly"] = 84.11, ["Ride"] = 31.49, ["Fly|Ride"] = 114.96, ["Neon"] = 140.66, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 700.24, ["Mega|Ride"] = 516.53, ["Mega|Fly|Ride"] = 625.7}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 79.91, ["Ride"] = 103.69, ["Fly|Ride"] = 140.66, ["Neon|Fly|Ride"] = 1550.79, ["Mega"] = 4199.27, ["Mega|Fly|Ride"] = 4339.95}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 10.53, ["Ride"] = 41.96, ["Fly|Ride"] = 139.65, ["Neon"] = 56.69, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 140.69, ["Mega"] = 365.35, ["Mega|Ride"] = 557.46, ["Mega|Fly|Ride"] = 620.8}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1837.5, ["Fly"] = 2625, ["Ride"] = 3463.99, ["Fly|Ride"] = 2341.5, ["Neon|Fly|Ride"] = 4434.94, ["Mega|Fly|Ride"] = 13298.02}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 32658.35, ["Ride"] = 24937.5, ["Fly|Ride"] = 24543.65, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 69988.03, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 195965.82}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 22.32, ["Fly"] = 393.75, ["Ride"] = 109.15, ["Fly|Ride"] = 90.28, ["Neon"] = 236.25, ["Neon|Ride"] = 178.38, ["Neon|Fly|Ride"] = 419.94, ["Mega"] = 1470, ["Mega|Ride"] = 1259.79, ["Mega|Fly|Ride"] = 602.61}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 3.94, ["Fly"] = 60.85, ["Ride"] = 39.38, ["Neon"] = 18.9, ["Neon|Fly"] = 99.75, ["Neon|Ride"] = 49.37, ["Neon|Fly|Ride"] = 119.44, ["Mega"] = 140.69, ["Mega|Fly"] = 182.68, ["Mega|Ride"] = 274.37, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 22.32}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 7.88, ["Ride"] = 50.47, ["Fly|Ride"] = 111.57, ["Neon"] = 70.33, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 463.32, ["Mega"] = 309.71, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 438.84}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 915.95, ["Ride"] = 698.25, ["Fly|Ride"] = 980.31, ["Mega|Fly|Ride"] = 10850.95}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 1032.94, ["Fly"] = 1076.25, ["Ride"] = 1042.13, ["Fly|Ride"] = 1048.69, ["Neon"] = 2869.51, ["Neon|Fly|Ride"] = 3858.08, ["Mega|Fly|Ride"] = 10918.09}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 36.74, ["Fly"] = 393.75, ["Ride"] = 53.62, ["Fly|Ride"] = 126, ["Neon"] = 208.88, ["Neon|Ride"] = 153.29, ["Neon|Fly|Ride"] = 209.98, ["Mega|Fly|Ride"] = 739.09}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 32.82}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 56.32, ["Fly"] = 129.2, ["Ride"] = 88.11, ["Fly|Ride"] = 132.38, ["Neon|Ride"] = 465.02, ["Neon|Fly|Ride"] = 410.82, ["Mega|Fly|Ride"] = 1519.09}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 105.13, ["Ride"] = 118.13, ["Fly|Ride"] = 182.48, ["Neon"] = 450.19, ["Neon|Ride"] = 620.79, ["Neon|Fly|Ride"] = 15500.75, ["Mega"] = 2115.62, ["Mega|Fly|Ride"] = 2166.84}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 6.3, ["Fly"] = 48.57, ["Ride"] = 17.43, ["Fly|Ride"] = 65.63, ["Neon"] = 30.45, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 700.24, ["Mega|Fly|Ride"] = 371.44}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 82.01, ["Fly"] = 78.73, ["Ride"] = 78.43, ["Fly|Ride"] = 118.13, ["Neon|Ride"] = 356.9, ["Neon|Fly|Ride"] = 308.44, ["Mega|Fly|Ride"] = 1217.79}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 3.61, ["Ride"] = 43.63, ["Fly|Ride"] = 98.67, ["Neon"] = 24.15, ["Neon|Fly"] = 266.6, ["Neon|Ride"] = 105.67, ["Mega"] = 129.94, ["Mega|Fly"] = 1120.18, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 392.44}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 20, ["Fly"] = 118.8, ["Ride"] = 32.82, ["Fly|Ride"] = 62.71, ["Neon"] = 140.66, ["Neon|Ride"] = 118.58, ["Neon|Fly|Ride"] = 286.79, ["Mega"] = 1050, ["Mega|Fly|Ride"] = 728.59}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 52.5, ["Ride"] = 92.9, ["Fly|Ride"] = 272.9, ["Neon"] = 209.92, ["Neon|Ride"] = 344.11, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 560.62, ["Mega|Ride"] = 2099.65, ["Mega|Fly|Ride"] = 770.58}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 15.74, ["Fly"] = 44.84, ["Ride"] = 49.3, ["Fly|Ride"] = 56.44, ["Neon"] = 134.81, ["Neon|Ride"] = 172.07, ["Neon|Fly|Ride"] = 249.38, ["Mega|Fly|Ride"] = 1022.54}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 5579.44, ["Ride"] = 5906.25, ["Fly|Ride"] = 5263.13, ["Neon"] = 34921.69, ["Neon|Fly|Ride"] = 25593.75, ["Mega|Fly|Ride"] = 99982.31}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 246.75, ["Fly"] = 262.82, ["Ride"] = 249.38, ["Fly|Ride"] = 282.19, ["Neon|Ride"] = 671.9, ["Neon|Fly|Ride"] = 547.03, ["Mega|Fly|Ride"] = 2309.61}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 34.13, ["Fly"] = 107.09, ["Ride"] = 57.75, ["Fly|Ride"] = 140.54, ["Neon"] = 56.73, ["Neon|Fly"] = 241.5, ["Neon|Ride"] = 102.18, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 285.72, ["Mega|Fly"] = 512.33, ["Mega|Ride"] = 371.65, ["Mega|Fly|Ride"] = 438.22}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 3.42, ["Ride"] = 32.82, ["Fly|Ride"] = 175.14, ["Neon"] = 26.25, ["Neon|Ride"] = 186.01, ["Mega"] = 170.63}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 31.49, ["Fly"] = 155.97, ["Ride"] = 52.5, ["Fly|Ride"] = 160.13, ["Neon"] = 176.4, ["Neon|Ride"] = 216.57, ["Neon|Fly|Ride"] = 310.41, ["Mega"] = 479.07, ["Mega|Ride"] = 419.94, ["Mega|Fly|Ride"] = 560.62}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 18571.88, ["Ride"] = 15481.67, ["Fly|Ride"] = 11812.49, ["Neon|Fly|Ride"] = 23625}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 164.07, ["Ride"] = 157.5, ["Fly|Ride"] = 262.5, ["Neon"] = 838.62, ["Neon|Fly|Ride"] = 930.02}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 52.57, ["Fly"] = 459.38, ["Ride"] = 53.43, ["Fly|Ride"] = 90.57, ["Neon|Fly"] = 464.86, ["Neon|Ride"] = 266.67, ["Neon|Fly|Ride"] = 266.67, ["Mega|Fly|Ride"] = 1595.73}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 12.81, ["Ride"] = 26.25, ["Fly|Ride"] = 72.19, ["Neon"] = 65.63, ["Neon|Ride"] = 102.32, ["Neon|Fly|Ride"] = 280.32, ["Mega"] = 2519.56, ["Mega|Ride"] = 492.19, ["Mega|Fly|Ride"] = 734.88}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 433.13, ["Ride"] = 461.99, ["Fly|Ride"] = 590.63, ["Neon"] = 1442.12, ["Neon|Ride"] = 1582.88, ["Neon|Fly|Ride"] = 1365, ["Mega"] = 5231.94, ["Mega|Fly|Ride"] = 5610.94}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 7.62, ["Ride"] = 48.25, ["Fly|Ride"] = 92.98, ["Neon"] = 31.39, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 140.69, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 294}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 157.5, ["Ride"] = 136.5, ["Fly|Ride"] = 209.75, ["Neon"] = 560.48, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 2240.32, ["Mega|Fly|Ride"] = 1704.94}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 10.39, ["Fly"] = 22.44, ["Ride"] = 23.24, ["Fly|Ride"] = 39.38, ["Neon|Fly"] = 104.96, ["Neon|Ride"] = 102.32, ["Neon|Fly|Ride"] = 77.44, ["Mega"] = 2519.56, ["Mega|Fly|Ride"] = 573.21}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 15.74}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 70.24, ["Ride"] = 167.81, ["Fly|Ride"] = 525, ["Neon"] = 209.92, ["Neon|Fly"] = 1679.3, ["Neon|Ride"] = 377.94, ["Neon|Fly|Ride"] = 405.99, ["Mega"] = 1120.18, ["Mega|Ride"] = 2319.19, ["Mega|Fly|Ride"] = 1534.54}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 17.47, ["Ride"] = 31.42, ["Fly|Ride"] = 83.98, ["Neon"] = 97.13, ["Neon|Ride"] = 126, ["Neon|Fly|Ride"] = 224.67, ["Mega|Ride"] = 532.27, ["Mega|Fly|Ride"] = 721.87}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 15.74}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 33.65, ["Fly"] = 210, ["Ride"] = 78.75, ["Fly|Ride"] = 209.92, ["Neon"] = 133.88, ["Neon|Ride"] = 98.69, ["Neon|Fly|Ride"] = 257.51, ["Mega"] = 1540.09, ["Mega|Ride"] = 703.5, ["Mega|Fly|Ride"] = 728.43}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 5.92, ["Neon"] = 19.69, ["Neon|Ride"] = 137.54, ["Neon|Fly|Ride"] = 321.57, ["Mega"] = 146.98, ["Mega|Ride"] = 335.96, ["Mega|Fly|Ride"] = 420.67}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 15.74, ["Fly"] = 42, ["Ride"] = 30.19, ["Fly|Ride"] = 91.88, ["Neon"] = 140.66, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 620.8, ["Mega|Fly|Ride"] = 763.88}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 393.75, ["Fly"] = 437.75, ["Ride"] = 367.5, ["Fly|Ride"] = 393.75, ["Neon|Fly"] = 1363.4, ["Neon|Fly|Ride"] = 1778.4, ["Mega|Fly|Ride"] = 8678.83}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 91.48, ["Ride"] = 77.62, ["Neon"] = 253.32, ["Neon|Ride"] = 205.78, ["Neon|Fly|Ride"] = 266.67, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 995.76}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 52.38, ["Ride"] = 85.94, ["Fly|Ride"] = 140.66, ["Neon"] = 155.35, ["Neon|Ride"] = 177.19, ["Neon|Fly|Ride"] = 630, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1393.11}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 105.13, ["Fly"] = 84.11, ["Ride"] = 46.47, ["Fly|Ride"] = 105, ["Neon"] = 62.99, ["Neon|Ride"] = 124.41, ["Neon|Fly|Ride"] = 378.99, ["Mega"] = 313.91, ["Mega|Ride"] = 1005.38, ["Mega|Fly|Ride"] = 1004.07}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Ride"] = 13313.95, ["Fly|Ride"] = 7966.77, ["Neon|Fly|Ride"] = 16406.25, ["Mega|Fly|Ride"] = 39372.9}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 2387.35, ["Fly"] = 2638.41, ["Ride"] = 2475.41, ["Fly|Ride"] = 1903.13, ["Neon"] = 4593.75, ["Neon|Fly|Ride"] = 5578.13, ["Mega|Fly|Ride"] = 19596.91}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 419.46, ["Ride"] = 367.5, ["Fly|Ride"] = 630, ["Neon"] = 2099.12, ["Neon|Ride"] = 3149.46, ["Neon|Fly|Ride"] = 1417.26, ["Mega"] = 16797.05, ["Mega|Fly|Ride"] = 6439.58}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 13.77, ["Fly"] = 30.19, ["Ride"] = 26.25, ["Fly|Ride"] = 51.19, ["Neon"] = 65.63, ["Neon|Ride"] = 98.69, ["Neon|Fly|Ride"] = 112.34, ["Mega|Fly|Ride"] = 515.48}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 4.77, ["Ride"] = 61.69, ["Fly|Ride"] = 153.57, ["Neon"] = 28.35, ["Neon|Ride"] = 78.75, ["Mega"] = 137.82, ["Mega|Ride"] = 291.9}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 39.59, ["Fly"] = 53.82, ["Ride"] = 49.3, ["Fly|Ride"] = 95.82, ["Neon|Ride"] = 154.72, ["Neon|Fly|Ride"] = 157.5, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.94, ["Fly"] = 30.5, ["Ride"] = 19.99, ["Fly|Ride"] = 31.39, ["Neon"] = 20.98, ["Neon|Fly"] = 280.25, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 79.71, ["Mega"] = 472.5, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 295.32, ["Fly"] = 380.62, ["Ride"] = 325.5, ["Fly|Ride"] = 413.44, ["Neon|Ride"] = 1395.01, ["Neon|Fly|Ride"] = 1338.53, ["Mega|Fly|Ride"] = 4508.97}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 32.82, ["Fly"] = 65.63, ["Ride"] = 44.14, ["Fly|Ride"] = 88.34, ["Neon"] = 118.13, ["Neon|Fly"] = 465.02, ["Neon|Ride"] = 156.96, ["Neon|Fly|Ride"] = 236.25, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 1396.5}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 10.5, ["Fly"] = 33.5, ["Ride"] = 27.27, ["Fly|Ride"] = 53.5, ["Neon"] = 62.76, ["Neon|Fly"] = 136.5, ["Neon|Ride"] = 109.29, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 524.92, ["Mega|Ride"] = 618.19, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 287.43, ["Fly"] = 787.5, ["Ride"] = 620.03, ["Fly|Ride"] = 682.22, ["Mega|Fly|Ride"] = 8119.29}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1299.38, ["Ride"] = 1109.07, ["Fly|Ride"] = 1470, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 17051.79}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 106.32, ["Fly"] = 116.4, ["Ride"] = 88.52, ["Fly|Ride"] = 104.93, ["Neon|Ride"] = 416.06, ["Neon|Fly|Ride"] = 525, ["Mega|Fly|Ride"] = 2099.99}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 196.88, ["Fly"] = 189.19, ["Ride"] = 210, ["Fly|Ride"] = 281, ["Neon"] = 1085.42, ["Neon|Ride"] = 629.5, ["Neon|Fly|Ride"] = 652.31, ["Mega|Ride"] = 7290.94, ["Mega|Fly|Ride"] = 3584.09}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 27.96, ["Ride"] = 42, ["Neon"] = 275.01, ["Neon|Ride"] = 272.99, ["Neon|Fly|Ride"] = 208.93, ["Mega|Ride"] = 930.02, ["Mega|Fly|Ride"] = 1040.46}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 146.14, ["Ride"] = 209.75, ["Fly|Ride"] = 597.19, ["Neon"] = 1539.71, ["Neon|Ride"] = 1259.79, ["Neon|Fly|Ride"] = 1679.71, ["Mega|Fly|Ride"] = 3006.68}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 1837.49, ["Fly"] = 2028.88, ["Ride"] = 2102.46, ["Fly|Ride"] = 1848.3, ["Mega|Fly|Ride"] = 34720.88}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 39.38, ["Ride"] = 51.19, ["Fly|Ride"] = 266.6, ["Neon"] = 288.64, ["Neon|Fly|Ride"] = 309.71, ["Mega"] = 1961.08, ["Mega|Ride"] = 2309.61, ["Mega|Fly|Ride"] = 1965.27}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 656.25, ["Fly"] = 675.94, ["Ride"] = 601.13, ["Fly|Ride"] = 643.13, ["Neon|Ride"] = 1246.88, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 2756.25}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 58.89, ["Fly"] = 140.16, ["Ride"] = 86.01, ["Fly|Ride"] = 131.25, ["Neon"] = 209.92, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 262.5, ["Mega|Fly|Ride"] = 989.73}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.82, ["Fly"] = 31.44, ["Ride"] = 23.24, ["Fly|Ride"] = 57.75, ["Neon"] = 19.67, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 6300, ["Mega|Ride"] = 157.49, ["Mega|Fly|Ride"] = 215.24}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 41.94, ["Ride"] = 67.13, ["Fly|Ride"] = 253.32, ["Neon"] = 1259.48, ["Neon|Ride"] = 1679.71, ["Neon|Fly|Ride"] = 310.4, ["Mega"] = 1395.03, ["Mega|Ride"] = 1120.18, ["Mega|Fly|Ride"] = 6999.13}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 616.03, ["Fly"] = 659.13, ["Ride"] = 551.25, ["Fly|Ride"] = 693, ["Neon"] = 1819.95, ["Neon|Ride"] = 1876.03, ["Neon|Fly|Ride"] = 1804.69, ["Mega|Fly|Ride"] = 7125.57}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 561.37, ["Ride"] = 549.52, ["Fly|Ride"] = 713.54, ["Neon"] = 8396.48, ["Neon|Ride"] = 4068.75, ["Neon|Fly|Ride"] = 3149.46, ["Mega|Fly|Ride"] = 12597.8}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 15.63, ["Fly"] = 42.07, ["Ride"] = 22.13, ["Fly|Ride"] = 40.69, ["Neon|Ride"] = 155.79, ["Neon|Fly|Ride"] = 125.98, ["Mega|Fly|Ride"] = 655.44}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 6.56, ["Ride"] = 23.63, ["Fly|Ride"] = 77.44, ["Neon"] = 69.75, ["Neon|Ride"] = 77.9, ["Neon|Fly|Ride"] = 105, ["Mega"] = 1968.75, ["Mega|Ride"] = 3304.88, ["Mega|Fly|Ride"] = 620.8}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 5.86, ["Ride"] = 28.4, ["Fly|Ride"] = 111.57, ["Neon"] = 16.8, ["Neon|Fly"] = 310.3, ["Neon|Ride"] = 46.51, ["Mega"] = 154.88, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 252}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 43.22, ["Fly"] = 59.07, ["Ride"] = 54.71, ["Fly|Ride"] = 108.93, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 253.44, ["Mega|Fly|Ride"] = 763.24}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 45.87, ["Ride"] = 86.63, ["Fly|Ride"] = 1049.56, ["Neon"] = 333.78, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1115.97, ["Mega|Ride"] = 1540.09, ["Mega|Fly|Ride"] = 1540.09}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 19.69, ["Fly"] = 57.14, ["Ride"] = 36.75, ["Fly|Ride"] = 105, ["Neon"] = 98.67, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 153.04, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 590.5}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 40.69, ["Fly"] = 98.83, ["Ride"] = 49.3, ["Fly|Ride"] = 87.94, ["Neon|Ride"] = 269.07, ["Neon|Fly|Ride"] = 231, ["Mega"] = 2100, ["Mega|Ride"] = 1120.18, ["Mega|Fly|Ride"] = 1120.18}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.93, ["Fly"] = 38.07, ["Ride"] = 24.94, ["Fly|Ride"] = 53.48, ["Neon"] = 36.75, ["Neon|Ride"] = 59.78, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 177.19, ["Mega|Ride"] = 182.68, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 4.23, ["Ride"] = 34.8, ["Fly|Ride"] = 1838.46, ["Neon"] = 27.41, ["Neon|Fly"] = 155.79, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 139.51, ["Mega"] = 232.52, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 46.57, ["Fly"] = 70.44, ["Ride"] = 61.88, ["Fly|Ride"] = 122.07, ["Neon"] = 560.48, ["Neon|Ride"] = 232.52, ["Neon|Fly|Ride"] = 216.57, ["Mega|Fly|Ride"] = 787.4}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 3142.34, ["Fly"] = 4906.07, ["Ride"] = 2516.8, ["Fly|Ride"] = 2100, ["Neon|Fly|Ride"] = 4997.43, ["Mega|Fly|Ride"] = 14962.5}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 561.37, ["Fly"] = 701.18, ["Ride"] = 535.5, ["Fly|Ride"] = 699.02, ["Neon"] = 1958.49, ["Neon|Ride"] = 2498.58, ["Neon|Fly|Ride"] = 1837.5, ["Mega|Fly|Ride"] = 8482.51}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 248.07, ["Fly"] = 322.74, ["Ride"] = 380.63, ["Fly|Ride"] = 343.88, ["Neon"] = 1245.85, ["Neon|Ride"] = 1519.4, ["Neon|Fly|Ride"] = 1469.75, ["Mega|Fly|Ride"] = 6074.24}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 54.6}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 43.31, ["Fly"] = 65.63, ["Ride"] = 54.71, ["Fly|Ride"] = 90.57, ["Neon|Ride"] = 226.77, ["Neon|Fly|Ride"] = 314.96, ["Mega"] = 1153.77, ["Mega|Ride"] = 1540.09, ["Mega|Fly|Ride"] = 1469.75}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 33639.15, ["Fly"] = 20744.84, ["Ride"] = 34781.25, ["Fly|Ride"] = 17062.4, ["Neon|Fly|Ride"] = 36749.9, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 304.5, ["Fly"] = 363.74, ["Ride"] = 298.6, ["Fly|Ride"] = 435.58, ["Neon"] = 939.38, ["Neon|Fly"] = 1094.71, ["Neon|Ride"] = 943.81, ["Neon|Fly|Ride"] = 833.44, ["Mega"] = 6298.91, ["Mega|Ride"] = 6510.1, ["Mega|Fly|Ride"] = 2290.32}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 155.59, ["Ride"] = 350.27, ["Fly|Ride"] = 257.25, ["Neon|Fly|Ride"] = 839.86, ["Mega|Fly|Ride"] = 4059.65}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 105, ["Ride"] = 123.76, ["Fly|Ride"] = 206.07, ["Neon|Ride"] = 560.62, ["Neon|Fly|Ride"] = 620.8, ["Mega"] = 13998.25, ["Mega|Ride"] = 1469.75, ["Mega|Fly|Ride"] = 1393.11}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 18.95, ["Fly"] = 94.5, ["Ride"] = 40.69, ["Fly|Ride"] = 95.52, ["Neon"] = 140.66, ["Neon|Ride"] = 135.19, ["Neon|Fly|Ride"] = 291.38}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 3937.4, ["Ride"] = 3839.07, ["Fly|Ride"] = 4493.88, ["Neon|Fly|Ride"] = 16275}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 27.96, ["Fly"] = 45.94, ["Ride"] = 34.13, ["Fly|Ride"] = 65.63, ["Neon"] = 144.38, ["Neon|Ride"] = 201.28, ["Neon|Fly|Ride"] = 183.73, ["Mega|Fly|Ride"] = 632.63}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 45.4, ["Fly"] = 116.4, ["Ride"] = 48.57, ["Fly|Ride"] = 104.85, ["Neon"] = 185.95, ["Neon|Ride"] = 280.32, ["Neon|Fly|Ride"] = 290.64, ["Mega|Fly|Ride"] = 860.86}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 610.32, ["Ride"] = 656.25, ["Fly|Ride"] = 639.19, ["Neon"] = 1563.19, ["Neon|Ride"] = 1246.88, ["Neon|Fly|Ride"] = 1195.69, ["Mega"] = 5248.04, ["Mega|Fly|Ride"] = 4159.32}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 13.12, ["Fly"] = 25.25, ["Ride"] = 28.04, ["Fly|Ride"] = 53.5, ["Neon"] = 134.35, ["Neon|Ride"] = 103.61, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 700.24, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 15.74, ["Fly"] = 42.07, ["Ride"] = 140.44, ["Fly|Ride"] = 56.64, ["Neon"] = 118.13, ["Neon|Ride"] = 118.13}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 104.08, ["Ride"] = 123.38, ["Fly|Ride"] = 245.44, ["Neon"] = 506.96, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 809.82, ["Mega|Ride"] = 2494.37, ["Mega|Fly|Ride"] = 2473.38}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 25.2, ["Ride"] = 81.81, ["Fly|Ride"] = 155.35, ["Neon"] = 91.88, ["Neon|Ride"] = 136.5, ["Neon|Fly|Ride"] = 209.98, ["Mega"] = 272.96, ["Mega|Fly"] = 654.94, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 452.48}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 4193.44, ["Ride"] = 3255, ["Fly|Ride"] = 3209.06, ["Neon"] = 12396.2, ["Neon|Ride"] = 17051.51, ["Neon|Fly|Ride"] = 8235.94, ["Mega"] = 62988.91, ["Mega|Fly|Ride"] = 38751.32}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 40.69, ["Ride"] = 167.81, ["Fly|Ride"] = 102.87, ["Neon"] = 280.25, ["Neon|Ride"] = 272.04, ["Neon|Fly|Ride"] = 328.13, ["Mega|Fly|Ride"] = 868.22}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 6868.71, ["Ride"] = 11885.56, ["Fly|Ride"] = 5906.25, ["Neon|Fly|Ride"] = 17062.5, ["Mega|Fly|Ride"] = 82305.51}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 3.89, ["Fly"] = 45.4, ["Ride"] = 20.98, ["Fly|Ride"] = 38.07, ["Neon"] = 23.63, ["Neon|Fly"] = 90.57, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 93.19, ["Mega"] = 131.25, ["Mega|Fly|Ride"] = 236.22}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 23.63, ["Fly"] = 35.44, ["Ride"] = 25.96, ["Fly|Ride"] = 84, ["Neon"] = 140.66, ["Neon|Ride"] = 280.32, ["Neon|Fly|Ride"] = 262.5, ["Mega|Ride"] = 1410.29, ["Mega|Fly|Ride"] = 927.71}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 2.97}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 11.65, ["Ride"] = 30.19, ["Fly|Ride"] = 140.54, ["Neon"] = 112.32, ["Neon|Ride"] = 140.69, ["Neon|Fly|Ride"] = 231.35, ["Mega|Ride"] = 770.58, ["Mega|Fly|Ride"] = 853.3}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 36.82, ["Ride"] = 71.32, ["Fly|Ride"] = 209.92, ["Neon"] = 182.43, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 840, ["Mega|Ride"] = 930.02, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 11.58, ["Fly"] = 37.87, ["Ride"] = 23.24, ["Fly|Ride"] = 39.38, ["Neon"] = 280.25, ["Neon|Ride"] = 174.57, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 2519.56, ["Mega|Fly|Ride"] = 945}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 9543.36}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2859.34}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 27.57}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 577.5, ["Fly"] = 561.37, ["Fly|Ride"] = 1049.56, ["Mega|Fly|Ride"] = 5599.73}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 31.44, ["Fly"] = 132.47, ["Ride"] = 62.93, ["Fly|Ride"] = 105, ["Neon"] = 156.13, ["Neon|Ride"] = 406.88, ["Mega"] = 805.22, ["Mega|Ride"] = 930.02, ["Mega|Fly|Ride"] = 761.25}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 8.43}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 7.88, ["Ride"] = 26.25, ["Neon"] = 78.72, ["Neon|Ride"] = 84, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2572.5}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 140.87, ["Ride"] = 144.38, ["Fly|Ride"] = 464.44, ["Neon"] = 680.13, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 525, ["Mega|Fly|Ride"] = 2273.92}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 103.68, ["Ride"] = 208.7, ["Fly|Ride"] = 280.01, ["Neon"] = 839.66, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 945, ["Mega|Fly|Ride"] = 2660.25}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 189, ["Fly"] = 210.26, ["Ride"] = 174.33, ["Fly|Ride"] = 221.29, ["Neon"] = 960.36, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 944.86, ["Mega"] = 6159.28, ["Mega|Fly|Ride"] = 2821.88}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1102.49, ["Fly"] = 2522.94, ["Ride"] = 1231.14, ["Fly|Ride"] = 1115.63, ["Neon|Fly|Ride"] = 4593.75, ["Mega|Fly|Ride"] = 20996.31}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 16.84, ["Fly"] = 101.56, ["Ride"] = 46.27, ["Fly|Ride"] = 86.63, ["Neon"] = 140.66, ["Neon|Ride"] = 313.91, ["Neon|Fly|Ride"] = 437.07, ["Mega"] = 733.83, ["Mega|Fly|Ride"] = 930.02}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 686.44, ["Fly"] = 2100, ["Ride"] = 759.84, ["Fly|Ride"] = 1149.75, ["Neon|Fly|Ride"] = 5249.08}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 65.19}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 20, ["Fly"] = 393.75, ["Ride"] = 39.8, ["Fly|Ride"] = 98.44, ["Neon"] = 82.93, ["Neon|Ride"] = 140.69, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 350.44, ["Mega|Ride"] = 458.07, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 10.5, ["Fly"] = 32.82, ["Ride"] = 28.3, ["Fly|Ride"] = 94.5, ["Neon"] = 83.98, ["Neon|Ride"] = 115.5, ["Neon|Fly|Ride"] = 85.32, ["Mega|Ride"] = 476.63, ["Mega|Fly|Ride"] = 619.5}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 70.88}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 49.42, ["Ride"] = 35.43, ["Fly|Ride"] = 61.88, ["Neon"] = 177.19, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 542.92, ["Mega|Fly|Ride"] = 682.39}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 103.03, ["Fly"] = 48.37, ["Ride"] = 46.47, ["Fly|Ride"] = 65.63, ["Neon"] = 209.92, ["Neon|Fly"] = 241.74, ["Neon|Ride"] = 141.74, ["Neon|Fly|Ride"] = 274.32, ["Mega"] = 980.55, ["Mega|Fly|Ride"] = 917.44}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 5223.75, ["Fly"] = 11213.41, ["Ride"] = 6152.52, ["Fly|Ride"] = 5091.19, ["Neon|Ride"] = 12177.86, ["Neon|Fly|Ride"] = 10078.69, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 13.13, ["Ride"] = 35.66, ["Fly|Ride"] = 131.25, ["Neon"] = 77.88, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 209.98, ["Mega"] = 532.27, ["Mega|Ride"] = 388.29, ["Mega|Fly|Ride"] = 405.15}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 28.88}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 118.13, ["Fly"] = 372.15, ["Ride"] = 196.88, ["Fly|Ride"] = 314.88, ["Neon"] = 418.69, ["Neon|Ride"] = 556.5, ["Neon|Fly|Ride"] = 587.92, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 72.19, ["Ride"] = 155.59, ["Fly|Ride"] = 310.43, ["Neon"] = 327.6, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 288.75, ["Mega|Ride"] = 1367.92, ["Mega|Fly|Ride"] = 1442.46}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 21, ["Fly"] = 70.86, ["Ride"] = 35.75, ["Fly|Ride"] = 65.63, ["Neon"] = 182.64, ["Neon|Ride"] = 132.29, ["Neon|Fly|Ride"] = 194.15, ["Mega|Fly|Ride"] = 616.87}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 6.29, ["Fly"] = 79.71, ["Ride"] = 27.27, ["Fly|Ride"] = 101.11, ["Neon"] = 31.39, ["Neon|Fly"] = 182.68, ["Neon|Ride"] = 66.15, ["Neon|Fly|Ride"] = 178.92, ["Mega"] = 191.08, ["Mega|Fly"] = 7034.11, ["Mega|Ride"] = 237.41, ["Mega|Fly|Ride"] = 243.9}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 13.12, ["Fly"] = 34.13, ["Ride"] = 30.42, ["Fly|Ride"] = 91.88, ["Neon"] = 70.33, ["Neon|Ride"] = 86.62, ["Neon|Fly|Ride"] = 209.27, ["Mega"] = 347.5, ["Mega|Ride"] = 512.69, ["Mega|Fly|Ride"] = 538.13}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 19.46, ["Fly"] = 36.09, ["Ride"] = 28.32, ["Fly|Ride"] = 56.64, ["Neon"] = 140.66, ["Neon|Fly"] = 209.92, ["Neon|Ride"] = 188.98, ["Neon|Fly|Ride"] = 150.97, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 236.24}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 21, ["Ride"] = 109.15, ["Neon"] = 155.35, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 497.57, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 1351.13}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 328.13, ["Ride"] = 443.63, ["Neon|Fly|Ride"] = 759.03}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 51.19, ["Ride"] = 78.75, ["Fly|Ride"] = 280.01, ["Neon"] = 328.13, ["Neon|Ride"] = 335.48, ["Neon|Fly|Ride"] = 446.25, ["Mega"] = 1183.88, ["Mega|Ride"] = 5249.99, ["Mega|Fly|Ride"] = 1338.75}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 656.25, ["Fly"] = 780.94, ["Ride"] = 606.38, ["Fly|Ride"] = 656.25, ["Neon|Ride"] = 2100, ["Neon|Fly|Ride"] = 1909.69, ["Mega|Ride"] = 7873.62, ["Mega|Fly|Ride"] = 6429.94}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 301.88, ["Ride"] = 301.88, ["Fly|Ride"] = 367.05, ["Neon"] = 1153.48, ["Neon|Ride"] = 2099.65, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 4116.34}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 94.63}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.63}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 13.12, ["Fly"] = 20.93, ["Ride"] = 24.94, ["Fly|Ride"] = 56.64, ["Neon"] = 80.07, ["Neon|Fly"] = 230.99, ["Neon|Ride"] = 124.41, ["Neon|Fly|Ride"] = 105, ["Mega|Fly|Ride"] = 405.57}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 303.18, ["Fly"] = 981.85, ["Ride"] = 345.19, ["Fly|Ride"] = 399, ["Neon"] = 1007.6, ["Neon|Ride"] = 1023.75, ["Neon|Fly|Ride"] = 1048.69, ["Mega"] = 4199.27, ["Mega|Fly|Ride"] = 3300.64}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 14.43}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 108.29, ["Fly"] = 590.63, ["Ride"] = 140.54, ["Fly|Ride"] = 248.49, ["Neon"] = 538.13, ["Neon|Fly"] = 1400.13, ["Neon|Ride"] = 566.92, ["Neon|Fly|Ride"] = 643.13, ["Mega"] = 9238.39, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 156.19, ["Ride"] = 162.75, ["Fly|Ride"] = 291.38, ["Neon"] = 839.66, ["Neon|Ride"] = 997.5, ["Neon|Fly|Ride"] = 1007.84}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 6.3, ["Ride"] = 39.38, ["Fly|Ride"] = 104.88, ["Neon"] = 59.07, ["Neon|Ride"] = 86.04, ["Neon|Fly|Ride"] = 167.98, ["Mega"] = 240.19, ["Mega|Ride"] = 203.68, ["Mega|Fly|Ride"] = 409.22}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 15.75, ["Fly"] = 48.35, ["Ride"] = 49.88, ["Fly|Ride"] = 76.13, ["Neon"] = 138.8, ["Neon|Ride"] = 77.9, ["Neon|Fly|Ride"] = 261.19, ["Mega|Fly|Ride"] = 572.25}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 23.29, ["Fly"] = 131.25, ["Ride"] = 48.57, ["Fly|Ride"] = 140.54, ["Neon"] = 140.66, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 270.38, ["Mega|Ride"] = 465.02, ["Mega|Fly|Ride"] = 560.62}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 6.57, ["Fly"] = 715.32, ["Ride"] = 36.71, ["Fly|Ride"] = 139.47, ["Neon"] = 26.25, ["Neon|Ride"] = 73.5, ["Neon|Fly|Ride"] = 146.98, ["Mega"] = 140.69, ["Mega|Fly"] = 189, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 281.03, ["Fly"] = 325.89, ["Ride"] = 393.75, ["Fly|Ride"] = 421.32, ["Neon"] = 1259.48, ["Neon|Ride"] = 1395.01, ["Neon|Fly|Ride"] = 1378.13, ["Mega|Fly|Ride"] = 4294.81}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 105, ["Fly"] = 1050, ["Ride"] = 178.5, ["Fly|Ride"] = 218.32, ["Neon"] = 628.7, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 525, ["Mega"] = 1792.88, ["Mega|Ride"] = 1928.07, ["Mega|Fly|Ride"] = 2152.14}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 82.01, ["Ride"] = 76.13, ["Fly|Ride"] = 141.75, ["Neon|Ride"] = 354.38, ["Neon|Fly|Ride"] = 476.63, ["Mega|Fly|Ride"] = 1557.94}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 15.78, ["Ride"] = 68.25, ["Fly|Ride"] = 280.25, ["Neon|Ride"] = 590.57, ["Neon|Fly|Ride"] = 490.28, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 17.99, ["Fly"] = 84.11, ["Ride"] = 60.84, ["Fly|Ride"] = 91.88, ["Neon"] = 91.88, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 172.07, ["Mega"] = 897.61, ["Mega|Ride"] = 449.33, ["Mega|Fly|Ride"] = 444.94}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.94, ["Fly"] = 140.87, ["Ride"] = 27.57, ["Fly|Ride"] = 77.81, ["Neon"] = 23.1, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 266.13, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 214.18}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 984.38, ["Ride"] = 1002.73, ["Fly|Ride"] = 971.25, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2408.44, ["Mega|Fly|Ride"] = 7993.13}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 328.13, ["Ride"] = 321.57, ["Fly|Ride"] = 366.19, ["Neon|Ride"] = 1378.13, ["Neon|Fly|Ride"] = 1378.13, ["Mega"] = 10498.16, ["Mega|Fly|Ride"] = 4134.38}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 98.83, ["Ride"] = 146.83, ["Fly|Ride"] = 167.81, ["Neon"] = 393.75, ["Neon|Ride"] = 360.94, ["Neon|Fly|Ride"] = 372.75, ["Mega|Ride"] = 1679.71, ["Mega|Fly|Ride"] = 1540.09}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 208.16, ["Ride"] = 210, ["Fly|Ride"] = 229.69, ["Neon|Ride"] = 980.55, ["Neon|Fly|Ride"] = 1036.88, ["Mega"] = 10498.16, ["Mega|Fly|Ride"] = 3051.83}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 26.78, ["Ride"] = 36.09, ["Fly|Ride"] = 74.53, ["Neon"] = 155.7, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 309.25, ["Mega"] = 629.9, ["Mega|Ride"] = 775.42, ["Mega|Fly|Ride"] = 619.12}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 341.25, ["Neon"] = 1400.13, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1378.13, ["Mega"] = 5250, ["Mega|Fly|Ride"] = 5172.45}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 132.47, ["Fly"] = 126, ["Ride"] = 140.54, ["Fly|Ride"] = 155.74, ["Neon|Ride"] = 465.02, ["Neon|Fly|Ride"] = 632.14, ["Mega|Fly|Ride"] = 2015.83}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1312.5, ["Ride"] = 1548.88, ["Fly|Ride"] = 1704.83, ["Neon|Ride"] = 4409.25, ["Neon|Fly|Ride"] = 4331.25, ["Mega"] = 50391.13}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 10.5, ["Fly"] = 42.07, ["Ride"] = 31.5, ["Fly|Ride"] = 82.69, ["Neon"] = 58.79, ["Neon|Fly"] = 167.35, ["Neon|Ride"] = 94.5, ["Neon|Fly|Ride"] = 158.54, ["Mega"] = 305.79, ["Mega|Ride"] = 458.07, ["Mega|Fly|Ride"] = 280.32}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 116.7, ["Ride"] = 83.98, ["Fly|Ride"] = 315, ["Neon"] = 263.45, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 305.82, ["Mega|Ride"] = 1120.18, ["Mega|Fly|Ride"] = 972.15}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 78.64, ["Fly"] = 77.44, ["Ride"] = 85.32, ["Fly|Ride"] = 94.61, ["Neon|Ride"] = 392.65, ["Neon|Fly|Ride"] = 372.02, ["Mega|Fly|Ride"] = 1443.75}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 2522.94, ["Ride"] = 962.07, ["Fly|Ride"] = 1049.56, ["Neon|Fly|Ride"] = 4199.99, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 525, ["Ride"] = 420, ["Fly|Ride"] = 587.27, ["Neon|Ride"] = 1820.4, ["Neon|Fly|Ride"] = 1971.57}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 105, ["Ride"] = 157.5, ["Neon"] = 492.76, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 525, ["Mega"] = 3989.31, ["Mega|Ride"] = 1704.94, ["Mega|Fly|Ride"] = 1927.48}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 7.88, ["Fly"] = 131.25, ["Ride"] = 24.94, ["Fly|Ride"] = 72.19, ["Neon"] = 91.88, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 155.79, ["Mega"] = 560.62, ["Mega|Ride"] = 508.59, ["Mega|Fly|Ride"] = 1049.84}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 33.66, ["Ride"] = 54.69, ["Fly|Ride"] = 135.85, ["Neon"] = 249.38, ["Neon|Fly"] = 406.2, ["Neon|Ride"] = 215.24, ["Neon|Fly|Ride"] = 386.19, ["Mega"] = 1820.4, ["Mega|Fly|Ride"] = 1049.99}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 885.94, ["Ride"] = 787.5, ["Fly|Ride"] = 892.5, ["Neon|Ride"] = 2828.44, ["Neon|Fly|Ride"] = 3254.44, ["Mega|Fly|Ride"] = 12596.75}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 771.75}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 4593.75, ["Ride"] = 5039.04, ["Fly|Ride"] = 4410, ["Neon|Ride"] = 30088.76, ["Neon|Fly|Ride"] = 17178.13, ["Mega|Fly|Ride"] = 89584.93}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 179.24, ["Fly"] = 408.19, ["Ride"] = 393.75, ["Fly|Ride"] = 406.2, ["Neon"] = 918.75, ["Neon|Ride"] = 700.24, ["Neon|Fly|Ride"] = 918.75, ["Mega"] = 5878.98, ["Mega|Fly|Ride"] = 6298.91}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 77.44, ["Ride"] = 122.07, ["Fly|Ride"] = 336, ["Neon"] = 441, ["Neon|Ride"] = 503.92, ["Neon|Fly|Ride"] = 498.75}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 15.74, ["Fly"] = 131.25, ["Ride"] = 35.66, ["Fly|Ride"] = 91.88, ["Neon"] = 92.98, ["Neon|Ride"] = 98.69, ["Neon|Fly|Ride"] = 175.33, ["Mega"] = 418.89, ["Mega|Ride"] = 523.87, ["Mega|Fly|Ride"] = 620.8}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 18.88, ["Fly"] = 30.27, ["Ride"] = 30.19, ["Fly|Ride"] = 61.94, ["Neon|Fly|Ride"] = 263.91, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 560.62}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 23.29, ["Ride"] = 45.94, ["Fly|Ride"] = 98.67, ["Neon"] = 94.47, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 189, ["Mega|Ride"] = 539.42, ["Mega|Fly|Ride"] = 797.88}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 6.57, ["Fly"] = 28.4, ["Ride"] = 22.32, ["Fly|Ride"] = 69.21, ["Neon"] = 35.44, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 310.4, ["Mega|Ride"] = 310.41, ["Mega|Fly|Ride"] = 357}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 35.44, ["Fly|Ride"] = 166.9, ["Neon"] = 139.65, ["Neon|Ride"] = 310.4, ["Neon|Fly|Ride"] = 377.94, ["Mega"] = 692.9, ["Mega|Ride"] = 1355.82, ["Mega|Fly|Ride"] = 793.68}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 273.34, ["Fly"] = 168.21, ["Ride"] = 270.38, ["Fly|Ride"] = 335.88, ["Neon"] = 472.5, ["Neon|Ride"] = 980.55, ["Neon|Fly|Ride"] = 869.27, ["Mega"] = 6562.5, ["Mega|Ride"] = 4199.27, ["Mega|Fly|Ride"] = 3543.75}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 3.67, ["Fly"] = 16.83, ["Ride"] = 17.07, ["Fly|Ride"] = 40.91, ["Neon"] = 22.31, ["Neon|Fly"] = 93.01, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 80.07, ["Mega"] = 839.86, ["Mega|Ride"] = 739.09, ["Mega|Fly|Ride"] = 267.75}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 39.59, ["Fly"] = 244.42, ["Ride"] = 69.57, ["Fly|Ride"] = 105, ["Neon"] = 196.29, ["Neon|Fly"] = 288.75, ["Neon|Ride"] = 175.88, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 518.44, ["Mega|Ride"] = 524.99, ["Mega|Fly|Ride"] = 589.32}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 761.25, ["Ride"] = 758.63, ["Fly|Ride"] = 833.44, ["Neon|Fly|Ride"] = 1732.5, ["Mega|Fly|Ride"] = 4068.75}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 24.94, ["Fly"] = 155.97, ["Ride"] = 34.92, ["Fly|Ride"] = 85.32, ["Neon|Fly"] = 464.86, ["Neon|Ride"] = 176.13, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 1575, ["Mega|Fly|Ride"] = 1085.81}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 301.61, ["Fly"] = 316.32, ["Ride"] = 236.25, ["Fly|Ride"] = 301.88, ["Neon"] = 1400.13, ["Neon|Fly"] = 1480.26, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 4465.93}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 99.74, ["Fly"] = 157.5, ["Ride"] = 129.94, ["Fly|Ride"] = 154.88, ["Neon|Fly"] = 490.28, ["Neon|Ride"] = 558.02, ["Neon|Fly|Ride"] = 560.62, ["Mega"] = 2939.5, ["Mega|Fly|Ride"] = 2148.99}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 769.52, ["Ride"] = 656.25, ["Fly|Ride"] = 782.99, ["Neon"] = 2491.68, ["Neon|Fly|Ride"] = 2519.56, ["Mega|Fly|Ride"] = 5773.69}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 31.44, ["Ride"] = 52.5, ["Fly|Ride"] = 98.59, ["Neon"] = 72.19, ["Neon|Fly"] = 278.92, ["Neon|Ride"] = 109.29, ["Neon|Fly|Ride"] = 211.32, ["Mega"] = 449.91, ["Mega|Ride"] = 392.65, ["Mega|Fly|Ride"] = 482.92}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 3784.43, ["Fly"] = 3784.43, ["Ride"] = 3712.29, ["Fly|Ride"] = 2887.5, ["Neon"] = 13959.15, ["Neon|Fly|Ride"] = 6300, ["Mega|Fly|Ride"] = 23745.75}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 91.88, ["Fly"] = 129.2, ["Ride"] = 102.38, ["Fly|Ride"] = 146.83, ["Neon"] = 550.97, ["Neon|Ride"] = 415.74, ["Neon|Fly|Ride"] = 493.43, ["Mega|Fly|Ride"] = 1705.43}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 3.93, ["Fly"] = 51.22, ["Ride"] = 18.38, ["Fly|Ride"] = 56.69, ["Neon"] = 19.43, ["Neon|Fly"] = 44.63, ["Neon|Ride"] = 31.4, ["Neon|Fly|Ride"] = 105, ["Mega"] = 173.75, ["Mega|Fly"] = 452.82, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.54, ["Ride"] = 28.88, ["Neon"] = 23.1, ["Neon|Ride"] = 103.48, ["Neon|Fly|Ride"] = 266.44, ["Mega"] = 147, ["Mega|Ride"] = 222.57, ["Mega|Fly|Ride"] = 309.71}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 126.16, ["Fly"] = 82.86, ["Ride"] = 40.69, ["Fly|Ride"] = 52.5, ["Neon|Ride"] = 700.24, ["Neon|Fly|Ride"] = 538.13, ["Mega|Fly|Ride"] = 1280.79}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 1023.91, ["Ride"] = 1174.69, ["Fly|Ride"] = 1286.25, ["Neon"] = 5247.8, ["Neon|Fly|Ride"] = 5250, ["Mega|Fly|Ride"] = 25195.57}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 4934.22, ["Ride"] = 5348.2, ["Fly|Ride"] = 13125}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 30.19, ["Fly"] = 35.75, ["Ride"] = 28.96, ["Fly|Ride"] = 43.32, ["Neon|Ride"] = 280.32, ["Neon|Fly|Ride"] = 127.12, ["Mega"] = 2519.56, ["Mega|Fly|Ride"] = 620.8}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 18.36, ["Fly"] = 47.25, ["Ride"] = 36.79, ["Fly|Ride"] = 78.75, ["Neon"] = 94.5, ["Neon|Ride"] = 91.35, ["Neon|Fly|Ride"] = 206.07, ["Mega"] = 930.02, ["Mega|Ride"] = 775.42, ["Mega|Fly|Ride"] = 538.13}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 38.06, ["Fly"] = 157.5, ["Ride"] = 39.38, ["Fly|Ride"] = 64.32, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 242.82, ["Mega|Fly|Ride"] = 866.25}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 200.82, ["Ride"] = 209.01, ["Fly|Ride"] = 255.89, ["Neon|Fly|Ride"] = 1120.34, ["Mega|Fly|Ride"] = 5249.08}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.66, ["Fly|Ride"] = 131.25, ["Neon"] = 16.8, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 92.42, ["Neon|Fly|Ride"] = 155.79, ["Mega"] = 203.68, ["Mega|Ride"] = 240.19, ["Mega|Fly|Ride"] = 343.3}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 189.24, ["Fly"] = 264.2, ["Ride"] = 223.13, ["Fly|Ride"] = 262.5, ["Neon"] = 838.62, ["Neon|Ride"] = 980.55, ["Neon|Fly|Ride"] = 733.69, ["Mega|Fly|Ride"] = 3275.44}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 3.42, ["Fly"] = 36.09, ["Ride"] = 19.95, ["Fly|Ride"] = 39.84, ["Neon"] = 19.83, ["Neon|Fly|Ride"] = 105, ["Mega"] = 465.02, ["Mega|Ride"] = 419.94, ["Mega|Fly|Ride"] = 734.88}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 258.57, ["Fly"] = 271.23, ["Ride"] = 229.67, ["Fly|Ride"] = 275.63, ["Neon|Ride"] = 1120.18, ["Neon|Fly|Ride"] = 897.61, ["Mega"] = 10498.16, ["Mega|Ride"] = 4199.27, ["Mega|Fly|Ride"] = 4198.22}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 21, ["Fly"] = 420.51, ["Ride"] = 32.6, ["Fly|Ride"] = 84.48, ["Neon"] = 41.99, ["Neon|Fly"] = 295.19, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 419.94, ["Mega"] = 462.99, ["Mega|Ride"] = 620.8, ["Mega|Fly|Ride"] = 368.5}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 3.68, ["Ride"] = 27.27, ["Neon"] = 24.94, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 151.14, ["Neon|Fly|Ride"] = 163.8, ["Mega"] = 76.13, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 213.94}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.63, ["Neon"] = 6.32, ["Mega"] = 28.37}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 3.92, ["Ride"] = 40.91, ["Fly|Ride"] = 218.32, ["Neon"] = 13.97, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 157.5, ["Mega|Fly"] = 155002.89, ["Mega|Ride"] = 162.42, ["Mega|Fly|Ride"] = 279.36}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 59.06, ["Fly"] = 78.75, ["Ride"] = 78.75, ["Fly|Ride"] = 196.88, ["Neon"] = 280.25, ["Neon|Ride"] = 325.52, ["Neon|Fly|Ride"] = 395.26, ["Mega|Ride"] = 1311.19, ["Mega|Fly|Ride"] = 2099.65}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.63, ["Fly"] = 46.27, ["Ride"] = 17.22, ["Fly|Ride"] = 140.66, ["Neon"] = 8.4, ["Neon|Ride"] = 39.8, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 129.94, ["Mega|Ride"] = 136.49}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 14.88, ["Fly|Ride"] = 155.35, ["Neon"] = 167.95, ["Neon|Ride"] = 315, ["Mega"] = 393.75, ["Mega|Ride"] = 709.69}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 95.54, ["Neon|Fly|Ride"] = 280.32, ["Mega"] = 23.1, ["Mega|Ride"] = 45.94, ["Mega|Fly|Ride"] = 322.3}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 20.96, ["Ride"] = 17.07, ["Fly|Ride"] = 31.86, ["Neon"] = 2.1, ["Neon|Fly"] = 16.86, ["Neon|Ride"] = 17.43, ["Neon|Fly|Ride"] = 77.17, ["Mega"] = 11.82, ["Mega|Fly"] = 27.57, ["Mega|Ride"] = 21, ["Mega|Fly|Ride"] = 39.38}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 10.5, ["Ride"] = 140.06, ["Fly|Ride"] = 49.88, ["Neon"] = 3.9, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 140.48, ["Mega"] = 18.62, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 98.44}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Ride"] = 27.19, ["Fly|Ride"] = 125.73, ["Neon"] = 2.62, ["Mega"] = 19.69, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.63, ["Fly"] = 41.62, ["Ride"] = 18.38, ["Fly|Ride"] = 107.52, ["Neon"] = 3.77, ["Neon|Fly"] = 135.05, ["Neon|Ride"] = 70.14, ["Mega"] = 23.62, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 190.32}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.63, ["Neon"] = 15.75, ["Neon|Fly|Ride"] = 140.69, ["Mega"] = 19.67, ["Mega|Ride"] = 78.75}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 2.1, ["Fly"] = 47.16, ["Ride"] = 19.95, ["Fly|Ride"] = 56.69, ["Neon"] = 7.65, ["Neon|Fly"] = 70.33, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 105, ["Mega"] = 59.07, ["Mega|Fly"] = 105, ["Mega|Ride"] = 83.98, ["Mega|Fly|Ride"] = 181.43}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 310.28, ["Mega"] = 17.05, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 3.93, ["Fly|Ride"] = 525, ["Neon|Ride"] = 70.35, ["Mega"] = 140.69, ["Mega|Ride"] = 157.5}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 23.28, ["Neon"] = 21.86, ["Mega"] = 314.96}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.63, ["Neon"] = 6.3, ["Neon|Ride"] = 36.95, ["Neon|Fly|Ride"] = 75.59, ["Mega"] = 32.57, ["Mega|Ride"] = 173.22}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 30.27, ["Ride"] = 18.69, ["Neon"] = 2.1, ["Neon|Fly"] = 27.2, ["Neon|Ride"] = 15.44, ["Neon|Fly|Ride"] = 41.88, ["Mega"] = 21, ["Mega|Ride"] = 31.49, ["Mega|Fly|Ride"] = 46.51}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.63, ["Fly"] = 72.19, ["Ride"] = 42, ["Neon|Ride"] = 39.38, ["Mega"] = 196.88, ["Mega|Ride"] = 350.65}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.63, ["Ride"] = 42, ["Fly|Ride"] = 78.73, ["Neon"] = 3.94, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 32.82, ["Mega|Ride"] = 66.94, ["Mega|Fly|Ride"] = 160.13}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 4.7, ["Neon"] = 18.9, ["Neon|Fly|Ride"] = 140.69, ["Mega"] = 78.75, ["Mega|Ride"] = 233.63}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.1, ["Fly"] = 31.7, ["Ride"] = 32.71, ["Fly|Ride"] = 190.86, ["Neon|Fly"] = 91.83, ["Neon|Ride"] = 32.57, ["Mega"] = 210, ["Mega|Ride"] = 85.3, ["Mega|Fly|Ride"] = 280.32}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 39.29, ["Ride"] = 20, ["Fly|Ride"] = 26.23, ["Neon"] = 2.1, ["Neon|Fly"] = 20.93, ["Neon|Ride"] = 16.82, ["Neon|Fly|Ride"] = 62.78, ["Mega"] = 14.44, ["Mega|Ride"] = 21, ["Mega|Fly|Ride"] = 53.69}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 4.93, ["Fly"] = 26.25, ["Ride"] = 19.65, ["Fly|Ride"] = 79.45, ["Neon"] = 54.34, ["Neon|Ride"] = 111.62, ["Mega"] = 112.34, ["Mega|Ride"] = 167.98, ["Mega|Fly|Ride"] = 209.98}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 2.86, ["Ride"] = 39.38, ["Neon"] = 79.77, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 335.96, ["Mega|Ride"] = 276.94}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 22.13, ["Ride"] = 14.05, ["Fly|Ride"] = 35.7, ["Neon"] = 2.63, ["Neon|Fly"] = 23.63, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 37.22, ["Mega"] = 17.46, ["Mega|Fly|Ride"] = 91.88}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 6.57, ["Neon"] = 6.34, ["Neon|Fly"] = 77.53, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 105, ["Mega"] = 59.96, ["Mega|Ride"] = 118.13}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.63, ["Ride"] = 28.49, ["Neon"] = 10.49, ["Neon|Fly"] = 155.35, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 310.4, ["Mega"] = 39.84, ["Mega|Ride"] = 107.1, ["Mega|Fly|Ride"] = 280.32}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 50, ["Neon|Fly|Ride"] = 84, ["Mega"] = 16.82, ["Mega|Ride"] = 72.1}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Ride"] = 17.07, ["Fly|Ride"] = 41.96, ["Neon"] = 9.29, ["Neon|Fly"] = 46.19, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 94.5, ["Mega|Ride"] = 140.69}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.63, ["Ride"] = 41.95, ["Neon"] = 15.75, ["Neon|Ride"] = 70.35, ["Mega"] = 93.19, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.63, ["Fly"] = 32.82, ["Ride"] = 17.26, ["Fly|Ride"] = 108.94, ["Neon"] = 11.64, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 102.38, ["Mega"] = 89.2, ["Mega|Ride"] = 90.56, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["Ride"] = 80.99, ["Mega|Fly|Ride"] = 844.06}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Fly"] = 21.05, ["Ride"] = 20.93, ["Fly|Ride"] = 5345.71, ["Neon"] = 11.81, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 112.88, ["Mega"] = 315, ["Mega|Fly|Ride"] = 560.62}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.61, ["Fly"] = 149.1, ["Fly|Ride"] = 141.75, ["Neon"] = 15.75, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 78.73, ["Mega|Ride"] = 136.5, ["Mega|Fly|Ride"] = 241.44}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 3.93, ["Fly"] = 79.47, ["Fly|Ride"] = 104.61, ["Neon"] = 21, ["Mega"] = 315}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 105, ["Neon"] = 98.67, ["Mega"] = 656.25}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 3.93, ["Ride"] = 262.5, ["Fly|Ride"] = 70.33, ["Neon"] = 41.99, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 140.69, ["Mega"] = 251.06}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 7.88, ["Ride"] = 124.25, ["Fly|Ride"] = 110.25, ["Neon"] = 35.44, ["Neon|Ride"] = 157.5, ["Mega"] = 189, ["Mega|Ride"] = 231.67, ["Mega|Fly|Ride"] = 209.98}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 125.98, ["Mega"] = 20.93, ["Mega|Ride"] = 139.13, ["Mega|Fly|Ride"] = 148.32}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 48.57}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 3.93, ["Fly"] = 26.25, ["Ride"] = 24.82, ["Fly|Ride"] = 73.23, ["Neon"] = 45.94, ["Neon|Ride"] = 45.56, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 210, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 270.38}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 18.36, ["Fly|Ride"] = 70.88, ["Neon"] = 6.45, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 449.9, ["Mega"] = 30.3, ["Mega|Ride"] = 94.5, ["Mega|Fly|Ride"] = 267.72}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.63, ["Ride"] = 164.07, ["Neon"] = 6.3, ["Neon|Ride"] = 30.19, ["Mega"] = 40.95, ["Mega|Ride"] = 78.72, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 4.2, ["Fly"] = 45.94, ["Ride"] = 23, ["Neon"] = 27.29, ["Neon|Ride"] = 57.75, ["Neon|Fly|Ride"] = 87.28, ["Mega"] = 133.76, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 310.41}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 7.49, ["Fly"] = 65.63, ["Ride"] = 44.06, ["Neon"] = 75.58, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 191.52, ["Mega"] = 419.94}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 51.17, ["Mega"] = 16.82, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 47.25, ["Mega|Fly|Ride"] = 188.43}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.63, ["Ride"] = 17.43, ["Fly|Ride"] = 56.99, ["Neon"] = 6.56, ["Neon|Fly"] = 30.19, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 99.74, ["Mega"] = 280.32, ["Mega|Fly"] = 109.19, ["Mega|Ride"] = 155.79, ["Mega|Fly|Ride"] = 146.98}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 20.99, ["Fly|Ride"] = 40.69, ["Neon"] = 7.88, ["Neon|Fly"] = 104.96, ["Neon|Ride"] = 23.37, ["Neon|Fly|Ride"] = 140.69, ["Mega"] = 188.98, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 140.69}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.63, ["Fly"] = 210, ["Ride"] = 21, ["Fly|Ride"] = 69.75, ["Neon"] = 4.59, ["Neon|Ride"] = 1458.19, ["Neon|Fly|Ride"] = 82.03, ["Mega"] = 24.94, ["Mega|Ride"] = 42, ["Mega|Fly|Ride"] = 102.38}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.63, ["Neon"] = 3.82, ["Neon|Ride"] = 38.06, ["Neon|Fly|Ride"] = 125.98, ["Mega"] = 65.62, ["Mega|Fly"] = 105, ["Mega|Ride"] = 66.94, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 26.36, ["Ride"] = 27.88, ["Neon"] = 4.66, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 28.37, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 23.26, ["Mega|Fly"] = 25.22, ["Mega|Ride"] = 48.3, ["Mega|Fly|Ride"] = 133.34}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Neon"] = 3.29, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 125.98, ["Mega"] = 22.32}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 8.42, ["Neon|Ride"] = 77.9, ["Neon|Fly|Ride"] = 420, ["Mega"] = 20.9}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 17457.37, ["Ride"] = 24.13, ["Neon"] = 8.39, ["Neon|Ride"] = 26.76, ["Neon|Fly|Ride"] = 86.63, ["Mega"] = 61.95, ["Mega|Ride"] = 61.95, ["Mega|Fly|Ride"] = 124.67}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 9.19, ["Ride"] = 59.07, ["Neon"] = 125.96, ["Mega"] = 398.35, ["Mega|Ride"] = 644.6, ["Mega|Fly|Ride"] = 641.46}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 3.78, ["Fly"] = 6562.5, ["Ride"] = 68.13, ["Neon"] = 40.69, ["Neon|Fly|Ride"] = 110.25, ["Mega"] = 419.94, ["Mega|Ride"] = 313.04}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 3.68, ["Ride"] = 42, ["Fly|Ride"] = 419.48, ["Neon"] = 92.98, ["Neon|Ride"] = 280.32, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 196.33, ["Mega|Fly|Ride"] = 560.62}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 16.68, ["Ride"] = 13.13, ["Fly|Ride"] = 39.38, ["Neon"] = 2.63, ["Neon|Fly"] = 13.13, ["Neon|Ride"] = 15.77, ["Neon|Fly|Ride"] = 32.57, ["Mega"] = 17.46, ["Mega|Fly"] = 27.32, ["Mega|Ride"] = 23.26, ["Mega|Fly|Ride"] = 55.13}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 8.38, ["Ride"] = 55.13, ["Neon"] = 16.22, ["Neon|Fly"] = 140.66, ["Neon|Ride"] = 31.4, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 54.53}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Ride"] = 41.96, ["Neon"] = 2.1, ["Neon|Fly"] = 31.39, ["Neon|Ride"] = 31.52, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 18.38, ["Mega|Fly"] = 78.44, ["Mega|Ride"] = 36.75, ["Mega|Fly|Ride"] = 129.93}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 3.92, ["Neon|Fly"] = 60.9, ["Mega"] = 20.93, ["Mega|Fly|Ride"] = 280.32}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 52.57, ["Ride"] = 24.13, ["Fly|Ride"] = 39.38, ["Neon"] = 13.65, ["Neon|Ride"] = 41.11, ["Neon|Fly|Ride"] = 102.95, ["Mega"] = 140.69, ["Mega|Ride"] = 180.58, ["Mega|Fly|Ride"] = 411.55}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 245.44, ["Ride"] = 252, ["Fly|Ride"] = 329.44, ["Neon"] = 1539.71, ["Neon|Ride"] = 1050, ["Neon|Fly|Ride"] = 1229.36, ["Mega"] = 8398.53, ["Mega|Fly|Ride"] = 4650.08}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.63, ["Neon"] = 8.46, ["Neon|Ride"] = 68.25, ["Mega"] = 91.88, ["Mega|Ride"] = 176.39, ["Mega|Fly|Ride"] = 553.27}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 9.33, ["Fly"] = 103.68, ["Ride"] = 31.82, ["Neon"] = 62.99, ["Neon|Ride"] = 167.98, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 419.94, ["Mega|Ride"] = 700.24, ["Mega|Fly|Ride"] = 1049.84}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 841, ["Ride"] = 18.38, ["Fly|Ride"] = 33.08, ["Neon"] = 7.88, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 61.69, ["Mega"] = 49.88, ["Mega|Ride"] = 78.75}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Ride"] = 24.94, ["Fly|Ride"] = 121.67, ["Neon"] = 10.5, ["Neon|Fly"] = 41.99, ["Neon|Ride"] = 53.57, ["Mega|Ride"] = 136.49}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 3.84, ["Fly"] = 32.71, ["Ride"] = 21.04, ["Fly|Ride"] = 46.16, ["Neon"] = 28.88, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 204.73, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 128.63}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 6.27, ["Ride"] = 145.69, ["Fly|Ride"] = 246.75, ["Neon"] = 78.75, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 623.61, ["Mega"] = 268.76, ["Mega|Fly|Ride"] = 512.54}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.1, ["Fly"] = 23.63, ["Ride"] = 17.07, ["Fly|Ride"] = 34.13, ["Neon"] = 20.98, ["Neon|Fly"] = 70.32, ["Neon|Ride"] = 32.57, ["Neon|Fly|Ride"] = 66.94, ["Mega"] = 196.88, ["Mega|Ride"] = 419.94, ["Mega|Fly|Ride"] = 419.94}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 79.87, ["Fly"] = 118.13, ["Ride"] = 138.44, ["Fly|Ride"] = 160.13, ["Neon"] = 523.95, ["Neon|Fly"] = 394.42, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 451.5, ["Mega|Fly|Ride"] = 1311.19}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 183.75, ["Fly"] = 388.73, ["Ride"] = 231, ["Fly|Ride"] = 310.3, ["Neon|Ride"] = 1120.18, ["Neon|Fly|Ride"] = 1049.84, ["Mega"] = 10498.16, ["Mega|Fly|Ride"] = 5319.43}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 69.84, ["Fly"] = 116.4, ["Ride"] = 72.19, ["Fly|Ride"] = 116.82, ["Neon"] = 419.84, ["Neon|Ride"] = 328.12, ["Neon|Fly|Ride"] = 375.38, ["Mega|Fly|Ride"] = 1273.13}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 4.23, ["Ride"] = 279.36, ["Neon"] = 32.82, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 155.39, ["Mega"] = 586.87, ["Mega|Ride"] = 202.29, ["Mega|Fly|Ride"] = 393.1}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 15.78, ["Ride"] = 41.96, ["Fly|Ride"] = 78.75, ["Neon"] = 83.98, ["Neon|Ride"] = 140.69, ["Neon|Fly|Ride"] = 209.98, ["Mega"] = 419.94, ["Mega|Ride"] = 404.25, ["Mega|Fly|Ride"] = 620.8}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 15.78, ["Ride"] = 17.07, ["Fly|Ride"] = 39.38, ["Neon"] = 7.88, ["Neon|Fly"] = 51.18, ["Neon|Ride"] = 17.46, ["Neon|Fly|Ride"] = 87.15, ["Mega"] = 56.84, ["Mega|Fly"] = 118.6, ["Mega|Ride"] = 100.8, ["Mega|Fly|Ride"] = 209.98}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 6.98, ["Fly"] = 95.68, ["Ride"] = 26.25, ["Fly|Ride"] = 104.88, ["Neon"] = 41.11, ["Neon|Ride"] = 140.69, ["Neon|Fly|Ride"] = 407.4, ["Mega"] = 699.19, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 419.94}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 3.94, ["Fly"] = 28.88, ["Ride"] = 17.43, ["Fly|Ride"] = 38.07, ["Neon"] = 25.22, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 124.41, ["Mega"] = 131.25, ["Mega|Ride"] = 232.52}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 4.22, ["Ride"] = 26.25, ["Fly|Ride"] = 328.13, ["Neon"] = 77.88, ["Neon|Ride"] = 56.7, ["Mega"] = 187.37, ["Mega|Fly|Ride"] = 314.96}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 28.4, ["Neon"] = 2.1, ["Neon|Ride"] = 23.1, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 19.95, ["Mega|Ride"] = 49.37, ["Mega|Fly|Ride"] = 209252.86}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 45.93, ["Ride"] = 41.96, ["Fly|Ride"] = 54.58, ["Neon"] = 13.09, ["Neon|Fly"] = 70.33, ["Neon|Ride"] = 67.2, ["Neon|Fly|Ride"] = 69.57, ["Mega"] = 125.98, ["Mega|Fly|Ride"] = 192.29}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 3.94, ["Ride"] = 18.37, ["Neon"] = 70.33, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 560.62, ["Mega"] = 182.68, ["Mega|Fly|Ride"] = 271.69}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 131.25, ["Fly"] = 262.5, ["Ride"] = 157.5, ["Fly|Ride"] = 261.19, ["Neon"] = 700.07, ["Neon|Fly"] = 665.44, ["Neon|Ride"] = 598.7, ["Neon|Fly|Ride"] = 656.24, ["Mega"] = 1961.08, ["Mega|Fly|Ride"] = 1929.38}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 12.52, ["Ride"] = 36.75, ["Fly|Ride"] = 204.68, ["Neon"] = 52.5, ["Neon|Ride"] = 291.38, ["Neon|Fly|Ride"] = 152.25, ["Mega"] = 414.75, ["Mega|Ride"] = 453.53, ["Mega|Fly|Ride"] = 419.94}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 50.74, ["Neon"] = 24.36, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 124.41, ["Mega"] = 136.5, ["Mega|Ride"] = 254.61, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 34.12, ["Ride"] = 98.59, ["Fly|Ride"] = 177.19, ["Neon"] = 90.57, ["Neon|Ride"] = 157.49, ["Neon|Fly|Ride"] = 294.54, ["Mega"] = 532.27, ["Mega|Ride"] = 490.28, ["Mega|Fly|Ride"] = 577.41}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 4.67}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 17.89, ["Ride"] = 27.57, ["Neon"] = 91.83, ["Neon|Fly|Ride"] = 629.9, ["Mega"] = 419.94, ["Mega|Ride"] = 839.86, ["Mega|Fly|Ride"] = 532.27}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 31.5, ["Fly"] = 56.79, ["Ride"] = 44.88, ["Fly|Ride"] = 63, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 140.69, ["Neon|Fly|Ride"] = 175.07, ["Mega"] = 2099.65, ["Mega|Fly|Ride"] = 620.8}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Neon"] = 6.32, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 56.7, ["Mega|Ride"] = 77.7, ["Mega|Fly|Ride"] = 266.67}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 11.53, ["Fly"] = 34.13, ["Ride"] = 70.27, ["Fly|Ride"] = 112.54, ["Neon"] = 39.38, ["Neon|Ride"] = 232.52, ["Mega"] = 263.17, ["Mega|Fly"] = 388.29, ["Mega|Ride"] = 161.68, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Ride"] = 31.44, ["Fly|Ride"] = 61.73, ["Neon"] = 19.69, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 116.82, ["Mega|Fly"] = 140.69, ["Mega|Ride"] = 120.75, ["Mega|Fly|Ride"] = 251.98}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Neon"] = 3.78, ["Neon|Ride"] = 42, ["Mega"] = 23.26, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 205.06}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 31.5, ["Ride"] = 131.25, ["Neon"] = 221.82, ["Neon|Ride"] = 239.37, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 960.6, ["Mega|Ride"] = 774.38, ["Mega|Fly|Ride"] = 980.55}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 4.99, ["Ride"] = 48.49, ["Fly|Ride"] = 210, ["Neon"] = 69.57, ["Neon|Ride"] = 119.69, ["Mega|Ride"] = 335.96}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 10.5, ["Fly"] = 92.11, ["Ride"] = 62.71, ["Fly|Ride"] = 103.95, ["Neon"] = 63.08, ["Neon|Fly"] = 314.99, ["Neon|Ride"] = 128.09, ["Neon|Fly|Ride"] = 498.75, ["Mega"] = 313.69, ["Mega|Ride"] = 333.47, ["Mega|Fly|Ride"] = 403.41}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 70.44, ["Fly"] = 433.13, ["Ride"] = 105, ["Fly|Ride"] = 350.27, ["Neon"] = 426.57, ["Neon|Ride"] = 493.43, ["Mega|Fly|Ride"] = 3021.89}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 26.25, ["Ride"] = 50.35, ["Fly|Ride"] = 262.4, ["Neon"] = 105, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 280.32, ["Mega"] = 354.38, ["Mega|Ride"] = 462.66, ["Mega|Fly|Ride"] = 467.25}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 68.25, ["Ride"] = 103.69, ["Fly|Ride"] = 202.21, ["Neon"] = 160.13, ["Neon|Ride"] = 309.71, ["Neon|Fly|Ride"] = 353.73, ["Mega"] = 952.2, ["Mega|Ride"] = 1005.74, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 44.63, ["Ride"] = 73.5, ["Fly|Ride"] = 184.73, ["Neon"] = 111.71, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 277.16, ["Mega"] = 462.7, ["Mega|Ride"] = 386.35, ["Mega|Fly|Ride"] = 538.79}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 16.93, ["Ride"] = 27.27, ["Neon"] = 39.38, ["Neon|Ride"] = 93.35, ["Neon|Fly|Ride"] = 125.37, ["Mega"] = 626.61, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 27.96, ["Ride"] = 140.54, ["Fly|Ride"] = 131.25, ["Neon"] = 124.36, ["Neon|Ride"] = 226.71, ["Neon|Fly|Ride"] = 318.94, ["Mega"] = 280.32, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 615.57}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 15.65, ["Ride"] = 34.13, ["Fly|Ride"] = 98.67, ["Neon"] = 32.55, ["Neon|Fly"] = 112.32, ["Neon|Ride"] = 94.5, ["Neon|Fly|Ride"] = 280.32, ["Mega"] = 264.57, ["Mega|Ride"] = 273, ["Mega|Fly|Ride"] = 465.02}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 26.25, ["Mega"] = 15.75, ["Mega|Fly"] = 140.69, ["Mega|Ride"] = 66.94, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 4.67, ["Ride"] = 104.88, ["Neon"] = 15.75, ["Neon|Ride"] = 83.83, ["Mega"] = 105, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 420.4}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Neon"] = 22.32, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 364.3, ["Mega"] = 336}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 6.56, ["Ride"] = 31.44, ["Fly|Ride"] = 116.23, ["Neon"] = 27.57, ["Neon|Ride"] = 82.95, ["Neon|Fly|Ride"] = 279.27, ["Mega"] = 123.38, ["Mega|Fly|Ride"] = 515.17}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 525, ["Ride"] = 593.25, ["Fly|Ride"] = 714.15, ["Neon|Ride"] = 2099.65, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 5878.95}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 20.86, ["Fly"] = 235.78, ["Ride"] = 31.54, ["Fly|Ride"] = 72.07, ["Neon|Ride"] = 77.9, ["Neon|Fly|Ride"] = 124.41, ["Mega|Ride"] = 419.94}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 13.13, ["Fly"] = 31.5, ["Ride"] = 43.32, ["Neon"] = 49.98, ["Neon|Fly"] = 315, ["Neon|Ride"] = 75.59, ["Mega"] = 465.02, ["Mega|Ride"] = 560.62, ["Mega|Fly|Ride"] = 620.8}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 4.2, ["Fly"] = 28.4, ["Ride"] = 23.23, ["Fly|Ride"] = 314.88, ["Neon|Ride"] = 155.79, ["Mega"] = 223.13, ["Mega|Ride"] = 354.38}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 27.56, ["Fly|Ride"] = 941.48, ["Neon"] = 8.61, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 28.37, ["Neon|Fly|Ride"] = 112.35, ["Mega"] = 78.75, ["Mega|Ride"] = 107.63, ["Mega|Fly|Ride"] = 233.63}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 58.14, ["Neon|Fly|Ride"] = 116.27, ["Mega"] = 28.37, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 209.98}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1120.62}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 6.56, ["Fly"] = 65.63, ["Ride"] = 40.69, ["Fly|Ride"] = 155.74, ["Neon"] = 232421.3, ["Neon|Fly"] = 140.66, ["Neon|Ride"] = 140.69, ["Mega"] = 455.63, ["Mega|Ride"] = 602.61, ["Mega|Fly|Ride"] = 1022.54}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.63, ["Ride"] = 45.36, ["Neon"] = 13.13, ["Neon|Ride"] = 60.09, ["Mega"] = 86.04, ["Mega|Ride"] = 90.29, ["Mega|Fly|Ride"] = 232.52}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 3.18, ["Fly"] = 98.83, ["Ride"] = 28.88, ["Fly|Ride"] = 525, ["Neon"] = 10.5, ["Neon|Ride"] = 70.35, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 183.75, ["Mega|Ride"] = 154.88, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 417.38, ["Ride"] = 453.97, ["Fly|Ride"] = 519.75, ["Neon|Ride"] = 1574.73, ["Neon|Fly|Ride"] = 1860.04, ["Mega|Fly|Ride"] = 8119.29}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 46.57, ["Fly"] = 196.88, ["Ride"] = 72.19, ["Neon"] = 49.88, ["Mega"] = 328.13}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 3.89, ["Neon"] = 10.49, ["Neon|Ride"] = 49.29, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 61.95, ["Mega|Fly"] = 189, ["Mega|Ride"] = 94.5, ["Mega|Fly|Ride"] = 155.39}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 3.94, ["Neon|Ride"] = 59.07, ["Mega"] = 21, ["Mega|Ride"] = 124.41, ["Mega|Fly|Ride"] = 209.98}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 15.54, ["Ride"] = 36.71, ["Neon"] = 79.04, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 310.76, ["Mega"] = 328.13, ["Mega|Ride"] = 280.32, ["Mega|Fly|Ride"] = 372.75}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 3505.84, ["Neon|Fly|Ride"] = 839.86, ["Mega"] = 629.9, ["Mega|Ride"] = 561.29, ["Mega|Fly|Ride"] = 1070.35}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 8.43, ["Neon"] = 280.25, ["Mega"] = 419.94, ["Mega|Fly|Ride"] = 1239}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 19.69, ["Ride"] = 65.03, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 775.41, ["Mega|Ride"] = 523.87, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 374.73, ["Ride"] = 367.5, ["Fly|Ride"] = 436.63, ["Neon"] = 1400.13, ["Neon|Ride"] = 1120.18, ["Neon|Fly|Ride"] = 1207.31, ["Mega|Ride"] = 3215.6, ["Mega|Fly|Ride"] = 3150}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 6.3, ["Ride"] = 31.37, ["Fly|Ride"] = 64.32, ["Neon"] = 59.07, ["Neon|Ride"] = 209.98, ["Neon|Fly|Ride"] = 237.27, ["Mega"] = 529.78, ["Mega|Ride"] = 521.73, ["Mega|Fly|Ride"] = 775.42}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 9.33, ["Ride"] = 91.88, ["Neon"] = 35.7, ["Mega"] = 1259.79, ["Mega|Fly|Ride"] = 1259.79}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 12.83, ["Ride"] = 40.69, ["Fly|Ride"] = 161.64, ["Neon"] = 39.89, ["Neon|Ride"] = 88.36, ["Mega"] = 185.16, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 356.96}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.63, ["Ride"] = 59.79, ["Fly|Ride"] = 108.03, ["Neon"] = 11.82, ["Neon|Ride"] = 45.61, ["Mega"] = 39.38, ["Mega|Ride"] = 103.95, ["Mega|Fly|Ride"] = 179.05}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 45.93, ["Ride"] = 72.19, ["Neon"] = 164.07, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 377.94, ["Mega"] = 2493.75, ["Mega|Ride"] = 2779.93, ["Mega|Fly|Ride"] = 1082.38}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 581.93, ["Ride"] = 31.55, ["Fly|Ride"] = 80.07, ["Neon"] = 12.62, ["Neon|Fly"] = 182.64, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 84.1, ["Mega|Ride"] = 120.75, ["Mega|Fly|Ride"] = 209.98}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.5, ["Ride"] = 31.37, ["Fly|Ride"] = 148.25, ["Neon"] = 8.4, ["Neon|Ride"] = 44.19, ["Neon|Fly|Ride"] = 112.25, ["Mega"] = 42, ["Mega|Ride"] = 60.38, ["Mega|Fly|Ride"] = 141.75}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Ride"] = 167.73, ["Fly|Ride"] = 262.5, ["Neon"] = 17.46, ["Neon|Fly|Ride"] = 140.69, ["Mega"] = 120.91, ["Mega|Ride"] = 167.98, ["Mega|Fly|Ride"] = 311.07}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 58.95, ["Fly"] = 81.38, ["Ride"] = 97.13, ["Fly|Ride"] = 155.59, ["Neon"] = 485.63, ["Neon|Ride"] = 350.65, ["Neon|Fly|Ride"] = 692.35, ["Mega|Fly|Ride"] = 980.55}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 297.94, ["Ride"] = 309.75, ["Fly|Ride"] = 418.38, ["Neon"] = 980.31, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 1432.22, ["Mega"] = 12597.8, ["Mega|Fly|Ride"] = 5711.02}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 3.78, ["Neon"] = 31.4, ["Mega"] = 122.07, ["Mega|Ride"] = 188.98, ["Mega|Fly|Ride"] = 497.57}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 7.87, ["Neon"] = 27.96, ["Mega"] = 70.35, ["Mega|Ride"] = 278.24, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 4.2, ["Fly"] = 155.57, ["Neon"] = 41.99, ["Mega"] = 495.48}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 53.23, ["Ride"] = 21, ["Neon"] = 5.25, ["Neon|Ride"] = 23.26, ["Neon|Fly|Ride"] = 182.68, ["Mega"] = 56.7, ["Mega|Fly"] = 125.98, ["Mega|Ride"] = 139.51, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 69.22, ["Neon"] = 10.5, ["Mega"] = 34.9, ["Mega|Ride"] = 206.07}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 20.98, ["Fly|Ride"] = 59.07, ["Neon"] = 3.94, ["Neon|Fly"] = 59.07, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 105, ["Mega"] = 45.94, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 280.32}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 27.88, ["Fly|Ride"] = 54.64, ["Neon"] = 17.07, ["Neon|Fly"] = 98.67, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 90.29, ["Mega"] = 139.51, ["Mega|Ride"] = 237.27, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 52.5, ["Ride"] = 56.64, ["Neon"] = 119.64, ["Mega"] = 367.5, ["Mega|Fly"] = 446.25, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 728.91}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 61.04, ["Fly"] = 582.75, ["Ride"] = 101.07, ["Neon"] = 445.11, ["Neon|Ride"] = 414.69, ["Mega"] = 3100.44, ["Mega|Ride"] = 1818.3, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 23.63, ["Fly|Ride"] = 131.25, ["Neon"] = 4.66, ["Neon|Ride"] = 109.29, ["Neon|Fly|Ride"] = 359.63, ["Mega"] = 56.25, ["Mega|Ride"] = 98.69, ["Mega|Fly|Ride"] = 342.97}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 16.77, ["Ride"] = 19.69, ["Fly|Ride"] = 53.43, ["Neon"] = 3.93, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 69.3, ["Mega"] = 38.07, ["Mega|Fly"] = 157.5, ["Mega|Ride"] = 56.7, ["Mega|Fly|Ride"] = 125.98}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 2.1, ["Ride"] = 41.96, ["Neon"] = 125.96, ["Neon|Ride"] = 138.59, ["Neon|Fly|Ride"] = 275.06, ["Mega"] = 616.26, ["Mega|Fly|Ride"] = 471.19}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 369, ["Ride"] = 419.48, ["Fly|Ride"] = 280.01, ["Neon|Ride"] = 1049.84, ["Mega|Fly|Ride"] = 5599.73}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 35.44, ["Fly"] = 209.9, ["Ride"] = 72.19, ["Fly|Ride"] = 224.96, ["Neon"] = 246.41, ["Neon|Ride"] = 462.69, ["Neon|Fly|Ride"] = 455.72, ["Mega"] = 1159.24, ["Mega|Ride"] = 1029.89, ["Mega|Fly|Ride"] = 945}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 31.5, ["Fly|Ride"] = 60.26, ["Neon"] = 15.75, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 155.39, ["Mega"] = 140.69, ["Mega|Ride"] = 140.69, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 4.12, ["Fly"] = 210.26, ["Ride"] = 65.63, ["Neon"] = 19.65, ["Neon|Ride"] = 200.52, ["Mega|Ride"] = 434.8}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 28.4, ["Fly"] = 77.81, ["Ride"] = 101.03, ["Fly|Ride"] = 69.57, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 2519.56, ["Mega|Ride"] = 904.32, ["Mega|Fly|Ride"] = 1085.53}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 86.21, ["Ride"] = 238.06, ["Fly|Ride"] = 190.32, ["Neon"] = 524.78, ["Neon|Ride"] = 469.88, ["Neon|Fly|Ride"] = 610.32, ["Mega"] = 3080.17, ["Mega|Fly|Ride"] = 6298.91}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 210, ["Fly"] = 500.39, ["Ride"] = 292.59, ["Fly|Ride"] = 398.85, ["Neon"] = 1029.63, ["Neon|Ride"] = 1364.77, ["Neon|Fly|Ride"] = 918.75, ["Mega|Fly|Ride"] = 3152.61}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 77.44, ["Ride"] = 65.63, ["Fly|Ride"] = 78.75, ["Neon"] = 111.57, ["Neon|Ride"] = 162.73, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 388.5, ["Mega|Ride"] = 490.28, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Ride"] = 17.07, ["Fly|Ride"] = 47.25, ["Neon"] = 9.31, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 70.35, ["Mega"] = 112.34, ["Mega|Ride"] = 140.69, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 3.93, ["Ride"] = 27.27, ["Fly|Ride"] = 70.27, ["Neon"] = 39.89, ["Neon|Ride"] = 46.98, ["Neon|Fly|Ride"] = 109.29, ["Mega"] = 194.25, ["Mega|Ride"] = 225.75, ["Mega|Fly|Ride"] = 259.34}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 296.63, ["Ride"] = 393.75, ["Fly|Ride"] = 489.11, ["Neon"] = 1259.48, ["Neon|Ride"] = 1540.09}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.41, ["Ride"] = 46.16, ["Neon"] = 11.87, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 28.88, ["Mega|Ride"] = 149.08, ["Mega|Fly|Ride"] = 279.01}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 3.93, ["Ride"] = 24.13, ["Fly|Ride"] = 39.38, ["Neon"] = 24.15, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 110.25, ["Mega"] = 131.25, ["Mega|Ride"] = 224.67, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 23.14, ["Ride"] = 140.54, ["Neon"] = 140.66, ["Neon|Ride"] = 291.38, ["Neon|Fly|Ride"] = 537.52, ["Mega"] = 560.62, ["Mega|Ride"] = 561.75, ["Mega|Fly|Ride"] = 615.21}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 111.45, ["Fly"] = 296.79, ["Ride"] = 118.13, ["Fly|Ride"] = 155.59, ["Neon|Ride"] = 700.24, ["Neon|Fly|Ride"] = 529.12, ["Mega|Fly|Ride"] = 1800.45}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 24.2, ["Fly"] = 81.48, ["Ride"] = 32.47, ["Fly|Ride"] = 54.86, ["Neon"] = 69.75, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 700.24, ["Mega|Ride"] = 587.92, ["Mega|Fly|Ride"] = 414.75}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 59.06, ["Neon"] = 3.94, ["Neon|Ride"] = 70.35, ["Neon|Fly|Ride"] = 178.27, ["Mega"] = 27.57, ["Mega|Ride"] = 309.71, ["Mega|Fly|Ride"] = 419.94}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Ride"] = 24.13, ["Fly|Ride"] = 83.91, ["Neon"] = 3.94, ["Neon|Fly"] = 31.39, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 69.18, ["Mega"] = 22.32, ["Mega|Ride"] = 52.38, ["Mega|Fly|Ride"] = 195.28}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 10.49, ["Ride"] = 68.34, ["Fly|Ride"] = 165.38, ["Neon"] = 30.23, ["Neon|Fly"] = 263.82, ["Neon|Ride"] = 98.69, ["Neon|Fly|Ride"] = 161.68, ["Mega"] = 147, ["Mega|Ride"] = 196.33, ["Mega|Fly|Ride"] = 280.32}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1433.25, ["Ride"] = 1246.88, ["Fly|Ride"] = 1443.75, ["Neon"] = 6717.19, ["Neon|Fly|Ride"] = 4416.57, ["Mega|Fly|Ride"] = 14768.81}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 539.44, ["Ride"] = 564.38, ["Neon|Ride"] = 2925.85, ["Neon|Fly|Ride"] = 2502.94, ["Mega"] = 16797.05, ["Mega|Fly|Ride"] = 7084.87}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 299.25, ["Fly"] = 328.13, ["Ride"] = 371.56, ["Fly|Ride"] = 417.37, ["Neon"] = 656.25, ["Neon|Ride"] = 1116.66, ["Neon|Fly|Ride"] = 838.69, ["Mega"] = 5319.43, ["Mega|Fly|Ride"] = 2559.38}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 315, ["Fly"] = 420.51, ["Ride"] = 393.75, ["Fly|Ride"] = 459.38, ["Neon"] = 945, ["Neon|Ride"] = 918.74, ["Neon|Fly|Ride"] = 1091.82, ["Mega|Ride"] = 3675, ["Mega|Fly|Ride"] = 2987.79}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.61, ["Fly"] = 20.25, ["Ride"] = 22.32, ["Fly|Ride"] = 49.98, ["Neon"] = 9.19, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 83.69, ["Mega|Ride"] = 112.88, ["Mega|Fly|Ride"] = 186.01}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 388.5, ["Fly"] = 590.62, ["Ride"] = 354.38, ["Fly|Ride"] = 561.75, ["Neon"] = 1022.3, ["Neon|Ride"] = 1022.54, ["Neon|Fly|Ride"] = 1246.88, ["Mega"] = 21836.16, ["Mega|Ride"] = 9518.69, ["Mega|Fly|Ride"] = 3859.13}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 3.94, ["Fly"] = 183.75, ["Ride"] = 27.27, ["Neon"] = 9.31, ["Neon|Ride"] = 53.59, ["Neon|Fly|Ride"] = 112.72, ["Mega"] = 94.49, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 196.33}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 31.5, ["Fly|Ride"] = 49.88, ["Neon"] = 11.53, ["Neon|Ride"] = 61.69, ["Neon|Fly|Ride"] = 84.09, ["Mega"] = 125.27, ["Mega|Ride"] = 140.44, ["Mega|Fly|Ride"] = 207.38}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Neon"] = 5.39, ["Mega"] = 23.63, ["Mega|Ride"] = 31.4, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 78.75, ["Ride"] = 65.63, ["Fly|Ride"] = 459.38, ["Neon"] = 273, ["Neon|Ride"] = 310.4, ["Mega"] = 2099.65, ["Mega|Ride"] = 930.02, ["Mega|Fly|Ride"] = 980.55}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 3.93, ["Fly"] = 65.62, ["Ride"] = 31.37, ["Fly|Ride"] = 68.25, ["Neon"] = 23.1, ["Mega"] = 328.13, ["Mega|Ride"] = 317.06}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.12, ["Neon"] = 3.82, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 23.1, ["Mega|Fly"] = 155.79, ["Mega|Ride"] = 93.01, ["Mega|Fly|Ride"] = 140.44}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.63, ["Ride"] = 21, ["Fly|Ride"] = 49.88, ["Neon"] = 6.56, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 29.92, ["Neon|Fly|Ride"] = 95.54, ["Mega"] = 63, ["Mega|Fly"] = 232.52, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 8.43, ["Ride"] = 54.26, ["Fly|Ride"] = 55.26, ["Neon"] = 101.11, ["Neon|Fly"] = 44.18, ["Neon|Ride"] = 139.1, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 237.57, ["Mega|Fly|Ride"] = 1019.82}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 15.78, ["Ride"] = 27.57, ["Neon"] = 39.38, ["Mega"] = 419.94, ["Mega|Ride"] = 333.86, ["Mega|Fly|Ride"] = 519.67}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 3.91, ["Ride"] = 26.25, ["Fly|Ride"] = 87.94, ["Neon"] = 39.38, ["Neon|Ride"] = 155.79, ["Neon|Fly|Ride"] = 697.51, ["Mega"] = 280.32, ["Mega|Ride"] = 465.02, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Ride"] = 20.91, ["Fly|Ride"] = 84, ["Neon"] = 3.93, ["Neon|Ride"] = 28.37, ["Mega"] = 40.69, ["Mega|Ride"] = 140.69, ["Mega|Fly|Ride"] = 314.96}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 210, ["Ride"] = 258.57, ["Fly|Ride"] = 406.88, ["Neon|Ride"] = 1375.63, ["Neon|Fly|Ride"] = 1330.13, ["Mega"] = 8398.53, ["Mega|Fly|Ride"] = 4185.07}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 35.75, ["Ride"] = 17.73, ["Fly|Ride"] = 131.25, ["Neon"] = 6.57, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 77.9, ["Mega"] = 53.49, ["Mega|Ride"] = 72.17, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 6.3, ["Ride"] = 98.44, ["Fly|Ride"] = 94.5, ["Neon"] = 43.32, ["Neon|Ride"] = 104.41, ["Mega"] = 315, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 350.65}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 40.69, ["Ride"] = 196.12, ["Fly|Ride"] = 136.45, ["Neon"] = 167.95, ["Neon|Ride"] = 209.98, ["Mega"] = 761.24, ["Mega|Ride"] = 1021.86, ["Mega|Fly|Ride"] = 860.86}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 175.88, ["Fly"] = 291.38, ["Ride"] = 272.66, ["Fly|Ride"] = 427.19, ["Neon"] = 775.69, ["Neon|Ride"] = 834.75, ["Neon|Fly|Ride"] = 866.25, ["Mega|Fly|Ride"] = 3463.36}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 20.96, ["Neon"] = 104.96, ["Mega"] = 383.92, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 700.24}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 19.69, ["Ride"] = 131.24, ["Fly|Ride"] = 629.74, ["Neon"] = 185.95, ["Neon|Ride"] = 313.91, ["Neon|Fly|Ride"] = 839.86, ["Mega"] = 932.25, ["Mega|Fly|Ride"] = 2099.65}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 1232.04, ["Fly"] = 1441.13, ["Ride"] = 1245.57, ["Fly|Ride"] = 1433.54, ["Neon|Ride"] = 4759.88, ["Neon|Fly|Ride"] = 4315.5, ["Mega|Fly|Ride"] = 15656.79}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 11.82, ["Fly"] = 43.32, ["Ride"] = 22.19, ["Fly|Ride"] = 62.35, ["Neon"] = 101.07, ["Neon|Fly"] = 111.57, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 105, ["Mega"] = 249.36, ["Mega|Ride"] = 253.44, ["Mega|Fly|Ride"] = 527.24}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 11.54, ["Fly"] = 13876.15, ["Ride"] = 35.44, ["Neon"] = 41.99, ["Neon|Ride"] = 140.69, ["Neon|Fly|Ride"] = 144.74, ["Mega"] = 212.63, ["Mega|Ride"] = 217.88, ["Mega|Fly|Ride"] = 464.98}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 3.93, ["Ride"] = 26.25, ["Fly|Ride"] = 942.38, ["Neon"] = 28.35, ["Neon|Ride"] = 1049.84, ["Neon|Fly|Ride"] = 310.4, ["Mega"] = 141.75, ["Mega|Ride"] = 254.06}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 20.67, ["Fly"] = 42.07, ["Ride"] = 41.96, ["Fly|Ride"] = 85.32, ["Neon"] = 71.8, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 224.67, ["Mega"] = 380.63, ["Mega|Ride"] = 431.82, ["Mega|Fly|Ride"] = 577.41}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 3.67, ["Fly"] = 31.55, ["Ride"] = 19.69, ["Fly|Ride"] = 45.34, ["Neon"] = 18.38, ["Neon|Ride"] = 34.04, ["Neon|Fly|Ride"] = 84, ["Mega|Ride"] = 147.66, ["Mega|Fly|Ride"] = 221.64}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 5.25, ["Ride"] = 45.94, ["Neon"] = 17.45, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 155.79, ["Mega"] = 207.88, ["Mega|Ride"] = 140.58, ["Mega|Fly|Ride"] = 350.65}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 194.25, ["Ride"] = 333.38, ["Fly|Ride"] = 539.02, ["Neon|Ride"] = 1693.13, ["Neon|Fly|Ride"] = 2099.65, ["Mega|Fly|Ride"] = 3877}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 3.29, ["Ride"] = 140.54, ["Fly|Ride"] = 66.13, ["Neon"] = 13.13, ["Neon|Fly"] = 92.98, ["Neon|Ride"] = 41.91, ["Neon|Fly|Ride"] = 105, ["Mega"] = 131.2, ["Mega|Ride"] = 147.79, ["Mega|Fly|Ride"] = 232.32}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 3.84, ["Neon"] = 46.19, ["Neon|Ride"] = 313.69, ["Mega"] = 258.57}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 3.94, ["Fly"] = 58.09, ["Ride"] = 39.5, ["Neon"] = 19.28, ["Neon|Ride"] = 28.37, ["Neon|Fly|Ride"] = 203.03, ["Mega"] = 105, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 347.17}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 131.25, ["Fly"] = 354.9, ["Ride"] = 303.19, ["Fly|Ride"] = 315, ["Neon"] = 523.69, ["Neon|Ride"] = 665.6, ["Neon|Fly|Ride"] = 700.24, ["Mega"] = 3569.4, ["Mega|Fly|Ride"] = 2049.26}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 39.35, ["Ride"] = 56.79, ["Fly|Ride"] = 109.16, ["Neon"] = 140.66, ["Neon|Fly|Ride"] = 266.67, ["Mega"] = 700.24, ["Mega|Ride"] = 696.05, ["Mega|Fly|Ride"] = 628.85}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 18.95, ["Ride"] = 87.09, ["Neon"] = 124.36, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 343.3, ["Mega"] = 679.24, ["Mega|Ride"] = 741.34, ["Mega|Fly|Ride"] = 571.12}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 3.91, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 35.44, ["Mega"] = 35.44, ["Mega|Ride"] = 74.8, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 72.17, ["Fly"] = 99.75, ["Ride"] = 157.49, ["Fly|Ride"] = 131.25, ["Neon"] = 309.64, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 385.97, ["Mega|Fly|Ride"] = 950.25}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 18.83, ["Neon"] = 4.6, ["Neon|Fly"] = 31.39, ["Neon|Fly|Ride"] = 588, ["Mega"] = 45.94}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 20.55, ["Fly"] = 140.87, ["Ride"] = 35.66, ["Fly|Ride"] = 206.22, ["Neon"] = 73.48, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 124.95, ["Mega"] = 415.74, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 350.44}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 47.25, ["Ride"] = 77.81, ["Fly|Ride"] = 157.5, ["Neon"] = 140.66, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 311.07, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 17.2, ["Fly|Ride"] = 36.75, ["Neon"] = 2.63, ["Neon|Fly"] = 41.99, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 63, ["Mega"] = 21, ["Mega|Fly"] = 55.13, ["Mega|Ride"] = 45.09, ["Mega|Fly|Ride"] = 103.95}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 7, ["Ride"] = 41.96, ["Fly|Ride"] = 1346.59, ["Neon"] = 39.38, ["Neon|Ride"] = 101.15, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 164.07, ["Mega|Ride"] = 280.23, ["Mega|Fly|Ride"] = 519.1}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 27.96, ["Ride"] = 52.5, ["Neon"] = 281.25, ["Neon|Ride"] = 173.65, ["Neon|Fly|Ride"] = 620.79, ["Mega"] = 560.62, ["Mega|Ride"] = 627.8, ["Mega|Fly|Ride"] = 620.46}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 17.07, ["Neon"] = 2.63, ["Neon|Ride"] = 26.25, ["Mega"] = 30.19, ["Mega|Fly|Ride"] = 307.79}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 3.94, ["Fly"] = 210, ["Ride"] = 87.09, ["Fly|Ride"] = 98.44, ["Neon"] = 47.87, ["Neon|Ride"] = 140.69, ["Neon|Fly|Ride"] = 182.68, ["Mega"] = 218.37, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 376.13}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 27.35, ["Ride"] = 31.37, ["Fly|Ride"] = 62.76, ["Neon|Ride"] = 103.04, ["Mega|Ride"] = 438.84, ["Mega|Fly|Ride"] = 476.63}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 6.3, ["Ride"] = 52.6, ["Neon"] = 32.82, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 200.82, ["Mega"] = 169.32, ["Mega|Ride"] = 191.63, ["Mega|Fly|Ride"] = 288.71}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 14.54, ["Fly"] = 2102.46, ["Neon"] = 84, ["Neon|Ride"] = 334.69, ["Neon|Fly|Ride"] = 6199.71, ["Mega"] = 560.62, ["Mega|Ride"] = 540.67, ["Mega|Fly|Ride"] = 770.58}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.63, ["Ride"] = 84.11, ["Fly|Ride"] = 196.88, ["Neon"] = 7.88, ["Neon|Ride"] = 56.62, ["Neon|Fly|Ride"] = 99.08, ["Mega"] = 74.82, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 155.39}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 28.32, ["Neon"] = 7.88, ["Mega"] = 26.25, ["Mega|Ride"] = 137.54, ["Mega|Fly|Ride"] = 155.79}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 42.07}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 52.54, ["Fly"] = 98.83, ["Ride"] = 52.5, ["Fly|Ride"] = 116.41, ["Neon"] = 419.84, ["Neon|Ride"] = 245.67, ["Neon|Fly|Ride"] = 1049.84, ["Mega"] = 1091.82, ["Mega|Ride"] = 978.45, ["Mega|Fly|Ride"] = 839.86}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 140.62, ["Neon"] = 2.63, ["Mega"] = 18.36, ["Mega|Ride"] = 99.74, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 609.73, ["Ride"] = 699.48, ["Fly|Ride"] = 656.25, ["Neon"] = 2625, ["Neon|Ride"] = 1837.5, ["Mega"] = 16797.05, ["Mega|Fly|Ride"] = 10498.16}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 2.63, ["Fly"] = 49.88, ["Ride"] = 40.94, ["Fly|Ride"] = 62.76, ["Neon"] = 39.64, ["Mega|Ride"] = 280.32, ["Mega|Fly|Ride"] = 560.62}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 4.2, ["Ride"] = 22.44, ["Fly|Ride"] = 48.29, ["Neon"] = 21, ["Neon|Ride"] = 35.48, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 229.93, ["Mega|Ride"] = 1162.53, ["Mega|Fly|Ride"] = 322.3}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 26.93, ["Ride"] = 58.07, ["Fly|Ride"] = 106.32, ["Neon"] = 112.32, ["Mega"] = 1064.53, ["Mega|Ride"] = 963.75, ["Mega|Fly|Ride"] = 545.92}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 3.61, ["Fly"] = 39.38, ["Ride"] = 44.14, ["Fly|Ride"] = 393.75, ["Neon"] = 40.09}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 24.94, ["Ride"] = 84.11, ["Fly|Ride"] = 157.5, ["Neon"] = 152.25, ["Neon|Ride"] = 107.1, ["Neon|Fly|Ride"] = 350.44, ["Mega"] = 363.57, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 392.44}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 5.24, ["Fly"] = 105, ["Ride"] = 35.05, ["Neon"] = 26.25, ["Neon|Ride"] = 92.39, ["Neon|Fly|Ride"] = 284.82, ["Mega"] = 209.98, ["Mega|Fly"] = 485.03, ["Mega|Ride"] = 195.57, ["Mega|Fly|Ride"] = 289.76}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 46.57, ["Ride"] = 15.78, ["Fly|Ride"] = 28.35, ["Neon"] = 2.1, ["Neon|Fly"] = 41.99, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 66.61, ["Mega"] = 18.38, ["Mega|Fly"] = 77.9, ["Mega|Ride"] = 37.8, ["Mega|Fly|Ride"] = 77.44}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 9.19, ["Ride"] = 39.38, ["Fly|Ride"] = 157.94, ["Neon"] = 32.47, ["Neon|Fly"] = 388.29, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 295.3, ["Mega"] = 140.69, ["Mega|Ride"] = 217.88, ["Mega|Fly|Ride"] = 280.32}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 291.36, ["Ride"] = 312.38, ["Fly|Ride"] = 377.53, ["Neon"] = 1480.5, ["Neon|Ride"] = 977.4, ["Neon|Fly|Ride"] = 1889.69, ["Mega|Fly|Ride"] = 4081.88}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 93.19, ["Ride"] = 166.69, ["Fly|Ride"] = 7696.43, ["Neon|Ride"] = 866.25, ["Neon|Fly|Ride"] = 698.25, ["Mega"] = 4199.27, ["Mega|Ride"] = 1524.34}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 24.94, ["Fly|Ride"] = 38.06, ["Neon"] = 19.66, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 65.63, ["Mega|Fly"] = 208.93, ["Mega|Ride"] = 91.34, ["Mega|Fly|Ride"] = 155.39}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 28.4, ["Ride"] = 15.96, ["Fly|Ride"] = 38.07, ["Neon"] = 10.49, ["Neon|Fly"] = 19.69, ["Neon|Ride"] = 25.24, ["Neon|Fly|Ride"] = 60.9, ["Mega"] = 39.38, ["Mega|Ride"] = 112.34, ["Mega|Fly|Ride"] = 167.98}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 3.94, ["Ride"] = 22.31, ["Fly|Ride"] = 98.44, ["Neon"] = 39.38, ["Mega"] = 140.69}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 275.63, ["Ride"] = 273, ["Fly|Ride"] = 305.82, ["Neon|Ride"] = 1085.78, ["Neon|Fly|Ride"] = 1398.36, ["Mega|Ride"] = 8398.53, ["Mega|Fly|Ride"] = 4899.5}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.63, ["Fly"] = 28.4, ["Ride"] = 20.98, ["Fly|Ride"] = 52.5, ["Neon"] = 28.35, ["Neon|Fly"] = 155.74, ["Neon|Ride"] = 31.4, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 266.67, ["Mega|Ride"] = 140.69, ["Mega|Fly|Ride"] = 300.83}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 4.2, ["Fly"] = 124.53, ["Ride"] = 39.5, ["Fly|Ride"] = 209.75, ["Neon"] = 31.39, ["Neon|Ride"] = 32.82, ["Mega"] = 251.35, ["Mega|Ride"] = 218.37, ["Mega|Fly|Ride"] = 397.59}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 91.88, ["Neon"] = 5.25, ["Neon|Ride"] = 155.99, ["Neon|Fly|Ride"] = 140.69, ["Mega"] = 56.7, ["Mega|Ride"] = 95.7, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 30.27, ["Ride"] = 22.32, ["Fly|Ride"] = 105, ["Neon"] = 87.05, ["Neon|Ride"] = 275.63, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 741.57, ["Mega|Ride"] = 501.37, ["Mega|Fly|Ride"] = 419.94}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 55.13, ["Ride"] = 103.69, ["Fly|Ride"] = 216.57, ["Neon"] = 105, ["Neon|Fly"] = 464.86, ["Neon|Ride"] = 193.18, ["Neon|Fly|Ride"] = 315, ["Mega"] = 458.07, ["Mega|Fly"] = 2204.63, ["Mega|Ride"] = 700.24, ["Mega|Fly|Ride"] = 622.13}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 23.29, ["Fly"] = 155.97, ["Ride"] = 43.32, ["Fly|Ride"] = 78.75, ["Neon"] = 138.56, ["Neon|Ride"] = 161.68, ["Neon|Fly|Ride"] = 236.25, ["Mega|Ride"] = 700.24, ["Mega|Fly|Ride"] = 2063.49}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 15.91, ["Ride"] = 72, ["Fly|Ride"] = 51.45, ["Neon"] = 2.1, ["Neon|Fly"] = 15.75, ["Neon|Ride"] = 20.98, ["Neon|Fly|Ride"] = 51.17, ["Mega"] = 19.69, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 115.5}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 190.32, ["Ride"] = 174.57, ["Fly|Ride"] = 348.47, ["Neon"] = 1119.89, ["Neon|Ride"] = 910.21, ["Neon|Fly|Ride"] = 1321.69, ["Mega"] = 3673.32, ["Mega|Fly|Ride"] = 3639.72}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 13.12, ["Fly"] = 140.39, ["Ride"] = 44.63, ["Neon"] = 78.75, ["Neon|Ride"] = 98.44, ["Mega"] = 776.88, ["Mega|Fly|Ride"] = 560.62}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.63, ["Ride"] = 28.32, ["Fly|Ride"] = 39.38, ["Neon"] = 6.57, ["Neon|Ride"] = 31.4, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 61.95, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Ride"] = 28.32, ["Fly|Ride"] = 39.38, ["Neon"] = 2.1, ["Neon|Ride"] = 23.98, ["Neon|Fly|Ride"] = 140.69, ["Mega"] = 22.09, ["Mega|Fly"] = 137.54, ["Mega|Ride"] = 35.44, ["Mega|Fly|Ride"] = 109.29}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 3.68, ["Ride"] = 26.25, ["Fly|Ride"] = 78.72, ["Neon"] = 11.53, ["Neon|Fly|Ride"] = 6999.13, ["Mega"] = 91.88, ["Mega|Ride"] = 137.82, ["Mega|Fly|Ride"] = 209.98}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 17.47, ["Fly"] = 65.63, ["Ride"] = 28.88, ["Fly|Ride"] = 65.63, ["Neon"] = 62.76, ["Neon|Ride"] = 73.5, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 310.41, ["Mega|Ride"] = 351.09, ["Mega|Fly|Ride"] = 700.24}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 10.5, ["Ride"] = 31.37, ["Neon"] = 83.98, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 210, ["Mega|Ride"] = 208.93, ["Mega|Fly|Ride"] = 465.02}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 60.4, ["Fly|Ride"] = 62.93, ["Neon"] = 3.7, ["Neon|Ride"] = 46.11, ["Neon|Fly|Ride"] = 93.19, ["Mega"] = 23.1, ["Mega|Ride"] = 52.49, ["Mega|Fly|Ride"] = 213.67}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 12.83, ["Ride"] = 92.9, ["Fly|Ride"] = 131.25, ["Neon"] = 24.94, ["Neon|Fly"] = 102.92, ["Neon|Ride"] = 132.55, ["Neon|Fly|Ride"] = 144.88, ["Mega"] = 140.69, ["Mega|Ride"] = 256.17, ["Mega|Fly|Ride"] = 232.03}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.63, ["Ride"] = 210, ["Neon"] = 4.67, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 155.79, ["Mega"] = 34.13, ["Mega|Ride"] = 98.69, ["Mega|Fly|Ride"] = 620.8}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 26.54, ["Ride"] = 17.43, ["Fly|Ride"] = 54.58, ["Neon"] = 5.98, ["Neon|Ride"] = 30.47, ["Mega"] = 62.78, ["Mega|Ride"] = 83.91, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 976.5, ["Ride"] = 1048.69, ["Fly|Ride"] = 1400.13, ["Neon|Fly|Ride"] = 4889, ["Mega|Fly|Ride"] = 15398.71}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 20.98, ["Fly|Ride"] = 56.69, ["Neon|Fly"] = 72.19, ["Neon|Ride"] = 191.08, ["Neon|Fly|Ride"] = 61.95, ["Mega"] = 187.93, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.61, ["Ride"] = 73.61, ["Neon"] = 6.56, ["Neon|Ride"] = 140.69, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 63, ["Mega|Ride"] = 173.97, ["Mega|Fly|Ride"] = 261.65}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 13.12, ["Ride"] = 27.57, ["Fly|Ride"] = 46.69, ["Neon"] = 39.38, ["Neon|Ride"] = 45.83, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 340.2, ["Mega|Fly|Ride"] = 353.07}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 39.38, ["Fly|Ride"] = 37.31, ["Neon"] = 7.88, ["Neon|Fly"] = 89.24, ["Neon|Ride"] = 23.35, ["Neon|Fly|Ride"] = 63, ["Mega"] = 142.33, ["Mega|Ride"] = 137.54, ["Mega|Fly|Ride"] = 174.09}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 48.57, ["Neon"] = 471.28, ["Neon|Ride"] = 338.63, ["Mega"] = 770.58, ["Mega|Ride"] = 868.22, ["Mega|Fly|Ride"] = 980.55}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 30.19, ["Neon"] = 7.69, ["Neon|Ride"] = 23.26, ["Mega"] = 87.21, ["Mega|Ride"] = 136.49, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 3.92, ["Fly"] = 73.5, ["Ride"] = 21, ["Fly|Ride"] = 65.63, ["Neon"] = 13.13, ["Neon|Fly"] = 146.95, ["Neon|Ride"] = 80.07, ["Neon|Fly|Ride"] = 140.69, ["Mega"] = 310.41, ["Mega|Ride"] = 419.94, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.63, ["Fly|Ride"] = 65.76, ["Neon"] = 16.83, ["Mega"] = 112.23, ["Mega|Fly"] = 280.32}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 2593.49, ["Ride"] = 23.07, ["Fly|Ride"] = 98.44, ["Neon"] = 6.3, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 93.35, ["Mega"] = 56.7, ["Mega|Fly"] = 419.94, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 162.77}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 27.34, ["Fly"] = 65.63, ["Ride"] = 23.24, ["Fly|Ride"] = 47.25, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 839.86, ["Mega|Ride"] = 519.67, ["Mega|Fly|Ride"] = 476.63}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 787.5, ["Ride"] = 899.54, ["Fly|Ride"] = 951.97, ["Neon"] = 2100, ["Neon|Ride"] = 2133.24, ["Neon|Fly|Ride"] = 2099.65, ["Mega"] = 6999.13, ["Mega|Ride"] = 4856.25, ["Mega|Fly|Ride"] = 4961.25}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 14.44, ["Ride"] = 19.69, ["Fly|Ride"] = 49.98, ["Neon"] = 4.66, ["Neon|Fly"] = 37.8, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 36.75, ["Mega|Fly"] = 112.34, ["Mega|Ride"] = 72.19, ["Mega|Fly|Ride"] = 188.34}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 4.2, ["Ride"] = 32.87, ["Fly|Ride"] = 77.97, ["Neon"] = 56.69, ["Neon|Ride"] = 231, ["Mega"] = 278.25, ["Mega|Ride"] = 280.32, ["Mega|Fly|Ride"] = 441}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 62.85, ["Ride"] = 85.32, ["Fly|Ride"] = 254.28, ["Neon|Ride"] = 545.92, ["Neon|Fly|Ride"] = 1240.32, ["Mega"] = 2799.87, ["Mega|Fly|Ride"] = 2231.25}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 72.19, ["Ride"] = 70.27, ["Fly|Ride"] = 301.88, ["Neon"] = 105, ["Neon|Ride"] = 140.69, ["Mega"] = 839.86, ["Mega|Ride"] = 770.58, ["Mega|Fly|Ride"] = 1006.1}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 15.74, ["Ride"] = 39.38, ["Neon"] = 112.32, ["Neon|Ride"] = 392.44, ["Neon|Fly|Ride"] = 209.98, ["Mega"] = 410.5, ["Mega|Ride"] = 440.94}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 61.69, ["Neon"] = 80.05, ["Neon|Ride"] = 356.9, ["Mega"] = 399.67, ["Mega|Ride"] = 336, ["Mega|Fly|Ride"] = 432.48}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 42.07, ["Ride"] = 315, ["Neon"] = 225.62, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 525, ["Mega"] = 836.73, ["Mega|Ride"] = 778.28, ["Mega|Fly|Ride"] = 836.73}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 14.44}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 6.3, ["Ride"] = 31.49, ["Fly|Ride"] = 105, ["Neon"] = 48.29, ["Neon|Ride"] = 70.86, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 231.35, ["Mega|Ride"] = 216.57, ["Mega|Fly|Ride"] = 543.5}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 5.25, ["Ride"] = 60.84, ["Neon"] = 39.12, ["Mega"] = 868.42}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 77.8, ["Fly"] = 419.46, ["Ride"] = 78.75, ["Fly|Ride"] = 157.5, ["Neon"] = 351.6, ["Neon|Ride"] = 224.67, ["Neon|Fly|Ride"] = 227.07, ["Mega|Ride"] = 700.24, ["Mega|Fly|Ride"] = 867.17}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.91, ["Fly"] = 23.63, ["Ride"] = 17.07, ["Fly|Ride"] = 44.06, ["Neon"] = 23.19, ["Neon|Fly"] = 60.82, ["Neon|Ride"] = 45.32, ["Neon|Fly|Ride"] = 84, ["Mega"] = 310.41, ["Mega|Ride"] = 209.99, ["Mega|Fly|Ride"] = 241.5}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 6.56, ["Ride"] = 52.45, ["Fly|Ride"] = 100.77, ["Neon"] = 21, ["Neon|Ride"] = 60.47, ["Neon|Fly|Ride"] = 102.38, ["Mega"] = 357, ["Mega|Fly"] = 301.45, ["Mega|Ride"] = 226.77, ["Mega|Fly|Ride"] = 266.67}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 4.22, ["Neon|Ride"] = 198.8, ["Mega"] = 63, ["Mega|Ride"] = 95.54}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 65.18, ["Ride"] = 85.94, ["Fly|Ride"] = 356.46, ["Neon"] = 408.18, ["Neon|Ride"] = 208.93, ["Neon|Fly|Ride"] = 280.32, ["Mega"] = 1085.81, ["Mega|Ride"] = 826.22, ["Mega|Fly|Ride"] = 872.42}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Neon"] = 15.83, ["Neon|Fly"] = 145.69, ["Mega"] = 140.69}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 13.12, ["Ride"] = 276.94, ["Neon"] = 107.06, ["Neon|Ride"] = 125.98, ["Neon|Fly|Ride"] = 293.96, ["Mega"] = 321.26, ["Mega|Ride"] = 419.94, ["Mega|Fly|Ride"] = 969}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 23.24, ["Ride"] = 18.38, ["Fly|Ride"] = 56.69, ["Neon"] = 24.15, ["Neon|Ride"] = 40.27, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 209.98, ["Mega|Ride"] = 196.23, ["Mega|Fly|Ride"] = 352.42}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 3.62, ["Fly"] = 52.5, ["Ride"] = 24.94, ["Fly|Ride"] = 49.88, ["Neon"] = 52.5, ["Neon|Ride"] = 125.98, ["Mega"] = 310.41, ["Mega|Ride"] = 419.94, ["Mega|Fly|Ride"] = 418.04}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 4.17, ["Ride"] = 139.47, ["Neon"] = 32.82, ["Neon|Ride"] = 111.57, ["Mega"] = 140.22, ["Mega|Ride"] = 547.98}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 35.7, ["Fly"] = 144.38, ["Ride"] = 143.07, ["Neon"] = 190.32, ["Neon|Ride"] = 283.5, ["Mega"] = 892.5, ["Mega|Ride"] = 1259.79, ["Mega|Fly|Ride"] = 931.88}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 33.77, ["Ride"] = 251.69, ["Neon"] = 182.6, ["Mega"] = 420.34, ["Mega|Ride"] = 775.42, ["Mega|Fly|Ride"] = 482.92}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 19.69, ["Ride"] = 105, ["Neon"] = 187.69, ["Neon|Ride"] = 393.75, ["Mega"] = 575.46, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 1679.71}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 18.38, ["Ride"] = 105, ["Fly|Ride"] = 422.03, ["Neon"] = 91.88, ["Neon|Fly|Ride"] = 573.57, ["Mega|Ride"] = 1085.81, ["Mega|Fly|Ride"] = 700.24}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 2.61, ["Neon"] = 42.21, ["Mega"] = 839.86, ["Mega|Fly|Ride"] = 310.41}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.63, ["Fly"] = 26.25, ["Ride"] = 17.43, ["Fly|Ride"] = 50.39, ["Neon"] = 6.56, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 137.82, ["Mega"] = 93.01, ["Mega|Ride"] = 89.25, ["Mega|Fly|Ride"] = 258.56}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 9.19, ["Ride"] = 45.55, ["Fly|Ride"] = 99.95, ["Neon"] = 35.44, ["Neon|Ride"] = 89.25, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 174.4, ["Mega|Ride"] = 489.23}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 32.6, ["Ride"] = 20.98, ["Fly|Ride"] = 53.82, ["Neon"] = 6.19, ["Neon|Ride"] = 30.47, ["Neon|Fly|Ride"] = 82.95, ["Mega"] = 52.5, ["Mega|Fly"] = 116.27, ["Mega|Ride"] = 71.4, ["Mega|Fly|Ride"] = 194.15}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 3.94, ["Ride"] = 32.82, ["Neon"] = 15.75, ["Neon|Ride"] = 109.29, ["Neon|Fly|Ride"] = 260.37, ["Mega"] = 249.38, ["Mega|Ride"] = 154.88, ["Mega|Fly|Ride"] = 465.02}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.94, ["Ride"] = 28.32, ["Fly|Ride"] = 99.75, ["Neon|Ride"] = 112.34, ["Neon|Fly|Ride"] = 315, ["Mega"] = 392.65, ["Mega|Ride"] = 419.94, ["Mega|Fly|Ride"] = 978.45}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 4.96, ["Ride"] = 22.42, ["Fly|Ride"] = 66.94, ["Neon"] = 27.57, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 101.07, ["Mega"] = 302.36, ["Mega|Ride"] = 418.51, ["Mega|Fly|Ride"] = 335.07}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 3.93, ["Ride"] = 23.29, ["Fly|Ride"] = 67.13, ["Neon"] = 32.55, ["Neon|Ride"] = 82.56, ["Neon|Fly|Ride"] = 109.29, ["Mega"] = 167.99, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 455.63}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 11.58, ["Fly"] = 301.88, ["Ride"] = 349.5, ["Neon"] = 24.93, ["Neon|Fly"] = 437.07, ["Neon|Ride"] = 140.43, ["Neon|Fly|Ride"] = 105, ["Mega"] = 124.95, ["Mega|Ride"] = 140.69, ["Mega|Fly|Ride"] = 322.3}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 7.88, ["Ride"] = 85.32, ["Fly|Ride"] = 210, ["Neon"] = 70.33, ["Neon|Ride"] = 162.73, ["Neon|Fly|Ride"] = 375.51, ["Mega"] = 367.5, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 777}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 59.06, ["Ride"] = 103.69, ["Fly|Ride"] = 291.38, ["Neon"] = 236.25, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 310.4, ["Mega"] = 2519.56, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1073.63}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Ride"] = 20.98, ["Fly|Ride"] = 65.63, ["Neon"] = 3.46, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 58.35, ["Mega"] = 37.8, ["Mega|Ride"] = 70.88, ["Mega|Fly|Ride"] = 119.69}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 15.07, ["Ride"] = 262.5, ["Neon"] = 223.13, ["Mega"] = 416.73, ["Mega|Fly|Ride"] = 1259.79}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 45.75, ["Ride"] = 116.12, ["Neon"] = 208.88, ["Neon|Ride"] = 700.24, ["Mega|Fly|Ride"] = 1120.18}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 9.19, ["Fly"] = 190.32, ["Ride"] = 77.81, ["Fly|Ride"] = 126, ["Neon"] = 63, ["Neon|Ride"] = 59.06, ["Neon|Fly|Ride"] = 167.98, ["Mega"] = 123.06, ["Mega|Ride"] = 209.98, ["Mega|Fly|Ride"] = 419.35}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 2.1, ["Fly"] = 157.5, ["Ride"] = 62.87, ["Fly|Ride"] = 83.98, ["Neon"] = 5.25, ["Neon|Ride"] = 27.56, ["Mega"] = 21, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 201.57}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 20.96, ["Fly|Ride"] = 45.94, ["Neon"] = 15.74, ["Neon|Ride"] = 53.44, ["Neon|Fly|Ride"] = 125.98, ["Mega|Ride"] = 155.79, ["Mega|Fly|Ride"] = 231}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 19.69, ["Neon"] = 2.63, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 3100.44, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 23.24, ["Fly|Ride"] = 65.7, ["Neon"] = 3.93, ["Neon|Ride"] = 31.52, ["Neon|Fly|Ride"] = 83.97, ["Mega"] = 40.69, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 147}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 28.25, ["Neon"] = 2.63, ["Neon|Ride"] = 155.79, ["Mega"] = 21, ["Mega|Ride"] = 95.54, ["Mega|Fly|Ride"] = 258.27}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["Ride"] = 157.5, ["Neon"] = 34.54, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 629.9, ["Mega"] = 208.93, ["Mega|Ride"] = 310.76, ["Mega|Fly|Ride"] = 587.35}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 6.56, ["Ride"] = 41.96, ["Neon"] = 124.43, ["Neon|Ride"] = 98.69, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 280.32, ["Mega|Ride"] = 418.89, ["Mega|Fly|Ride"] = 503.92}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 7.88, ["Fly"] = 28.4, ["Ride"] = 22.32, ["Fly|Ride"] = 70.27, ["Neon"] = 46.5, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 35.72, ["Neon|Fly|Ride"] = 103.69, ["Mega|Ride"] = 310.76, ["Mega|Fly|Ride"] = 410.5}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 79.99, ["Ride"] = 91.88, ["Fly|Ride"] = 262.5, ["Neon"] = 309.64, ["Neon|Ride"] = 888.57}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 28.4, ["Ride"] = 65.63, ["Neon"] = 155.74, ["Mega"] = 616.22, ["Mega|Fly"] = 644.6, ["Mega|Ride"] = 603.75, ["Mega|Fly|Ride"] = 700.24}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 20, ["Ride"] = 22.32, ["Fly|Ride"] = 52.45, ["Neon"] = 3.94, ["Neon|Fly"] = 36.04, ["Neon|Ride"] = 28.37, ["Neon|Fly|Ride"] = 143, ["Mega"] = 53.57, ["Mega|Ride"] = 107.63, ["Mega|Fly|Ride"] = 248.79}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 30.19, ["Ride"] = 17.07, ["Fly|Ride"] = 28.35, ["Neon"] = 3.94, ["Neon|Fly"] = 19.69, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 56.43, ["Mega"] = 48.3, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 149.08}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 359.63, ["Fly"] = 349.16, ["Ride"] = 399, ["Fly|Ride"] = 565.72, ["Neon|Fly|Ride"] = 1522.5}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 14.43, ["Neon"] = 115.54, ["Mega"] = 406.23, ["Mega|Ride"] = 482.92, ["Mega|Fly|Ride"] = 839.86}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 28.4, ["Ride"] = 15.96, ["Fly|Ride"] = 32.82, ["Neon"] = 5.25, ["Neon|Ride"] = 22.16, ["Neon|Fly|Ride"] = 45.35, ["Mega"] = 42, ["Mega|Ride"] = 72.1, ["Mega|Fly|Ride"] = 108.14}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 90.42, ["Ride"] = 124.81, ["Fly|Ride"] = 315, ["Neon"] = 270.8, ["Neon|Ride"] = 288.75, ["Neon|Fly|Ride"] = 493.43, ["Mega"] = 737.63, ["Mega|Ride"] = 813.75, ["Mega|Fly|Ride"] = 910.88}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 17.43, ["Fly|Ride"] = 44.62, ["Neon"] = 12.62, ["Neon|Fly"] = 91.33, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 89.25, ["Mega"] = 116.54, ["Mega|Fly"] = 182.68, ["Mega|Ride"] = 161.7, ["Mega|Fly|Ride"] = 222.57}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 98.59, ["Neon"] = 3.28, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 283.4, ["Mega"] = 13.13, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 64.97, ["Ride"] = 131.25, ["Fly|Ride"] = 195.24, ["Neon"] = 210, ["Neon|Ride"] = 281.34, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 881.86, ["Mega|Ride"] = 1101.28, ["Mega|Fly|Ride"] = 826.88}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.63, ["Ride"] = 19.94, ["Fly|Ride"] = 39.38, ["Neon"] = 21, ["Neon|Ride"] = 140.69, ["Mega"] = 98.69, ["Mega|Ride"] = 129.84, ["Mega|Fly|Ride"] = 145.68}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 42, ["Ride"] = 97.13, ["Neon"] = 280.25, ["Neon|Ride"] = 196.33, ["Neon|Fly|Ride"] = 260.37, ["Mega|Ride"] = 1679.71, ["Mega|Fly|Ride"] = 1154.82}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 4.17, ["Ride"] = 54.6, ["Neon"] = 92.98, ["Neon|Ride"] = 419.94, ["Mega"] = 170.63, ["Mega|Ride"] = 822.94, ["Mega|Fly|Ride"] = 544.04}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 3.93, ["Ride"] = 103.35, ["Neon"] = 12.62, ["Neon|Fly"] = 62.99, ["Neon|Ride"] = 171.94, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 133.34, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 560.62}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 24.68, ["Ride"] = 48.66, ["Fly|Ride"] = 142.76, ["Neon|Ride"] = 210, ["Mega"] = 1259.79, ["Mega|Ride"] = 2611.88}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 3.94, ["Fly"] = 131.62, ["Ride"] = 89.25, ["Neon"] = 4.66, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 155.39, ["Mega"] = 49.37, ["Mega|Fly"] = 158.61, ["Mega|Ride"] = 98.69, ["Mega|Fly|Ride"] = 308.99}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.63, ["Fly"] = 46.73, ["Ride"] = 23.62, ["Fly|Ride"] = 72.19, ["Neon"] = 6.57, ["Neon|Fly"] = 41.88, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 105.59, ["Mega|Fly|Ride"] = 277.6}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 11.82, ["Ride"] = 53.9, ["Fly|Ride"] = 185.95, ["Neon"] = 111.57, ["Neon|Ride"] = 120.75, ["Mega"] = 1049.84, ["Mega|Ride"] = 616.26, ["Mega|Fly|Ride"] = 377.99}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 28.4, ["Ride"] = 57.75, ["Fly|Ride"] = 131.25, ["Neon"] = 105, ["Neon|Ride"] = 202.13, ["Neon|Fly|Ride"] = 460.37, ["Mega"] = 557.82, ["Mega|Ride"] = 608.9, ["Mega|Fly|Ride"] = 623.44}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 23.33, ["Fly"] = 182.94, ["Ride"] = 30.19, ["Fly|Ride"] = 79.72, ["Neon"] = 103.69, ["Neon|Ride"] = 140.69, ["Neon|Fly|Ride"] = 222.89, ["Mega"] = 620.8, ["Mega|Ride"] = 523.87, ["Mega|Fly|Ride"] = 690.56}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 68.25, ["Fly"] = 196.88, ["Ride"] = 150.96, ["Fly|Ride"] = 313.99, ["Neon"] = 288.75, ["Neon|Ride"] = 313.69, ["Neon|Fly|Ride"] = 420, ["Mega"] = 1253.49, ["Mega|Ride"] = 1291.28, ["Mega|Fly|Ride"] = 1293.38}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 3.67, ["Ride"] = 39.5, ["Fly|Ride"] = 262.5, ["Neon"] = 24.15, ["Neon|Ride"] = 519.67, ["Neon|Fly|Ride"] = 314.96, ["Mega"] = 162.44, ["Mega|Ride"] = 279.01, ["Mega|Fly|Ride"] = 328.79}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 5.92, ["Ride"] = 28.32, ["Fly|Ride"] = 70.27, ["Neon"] = 24.12, ["Neon|Ride"] = 70.35, ["Neon|Fly|Ride"] = 209.98, ["Mega"] = 224.67, ["Mega|Ride"] = 233.24, ["Mega|Fly|Ride"] = 232.03}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 26.25, ["Fly"] = 105, ["Ride"] = 62.93, ["Fly|Ride"] = 109.26, ["Neon"] = 78.75, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 159.75, ["Mega"] = 374.07, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 15.74, ["Fly|Ride"] = 98.59, ["Neon"] = 2.1, ["Neon|Fly"] = 19.69, ["Neon|Ride"] = 18.9, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 21, ["Mega|Fly"] = 70.35, ["Mega|Ride"] = 56.7, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 63, ["Fly"] = 220.5, ["Ride"] = 123.38, ["Neon"] = 305.82, ["Neon|Fly"] = 2379.37, ["Neon|Ride"] = 279.27, ["Mega"] = 2939.5, ["Mega|Fly"] = 959.55, ["Mega|Ride"] = 1035.14, ["Mega|Fly|Ride"] = 958.13}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 23.24, ["Fly|Ride"] = 89.25, ["Neon"] = 3.93, ["Neon|Ride"] = 42.2, ["Mega"] = 84, ["Mega|Fly|Ride"] = 435.69}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 28.4, ["Ride"] = 20.11, ["Fly|Ride"] = 132.3, ["Neon"] = 41.99, ["Neon|Ride"] = 20.93, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 152.25, ["Mega|Ride"] = 419.94, ["Mega|Fly|Ride"] = 281.54}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 87.94, ["Fly"] = 210.26, ["Ride"] = 131.25, ["Fly|Ride"] = 167.81, ["Neon"] = 333.55, ["Neon|Ride"] = 326.82, ["Neon|Fly|Ride"] = 620.79, ["Mega"] = 1002.75, ["Mega|Ride"] = 905.63, ["Mega|Fly|Ride"] = 1010.63}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.63, ["Ride"] = 42.4, ["Neon"] = 11.57, ["Neon|Ride"] = 1400.46, ["Mega"] = 51.19, ["Mega|Ride"] = 96.96, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 31.43}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 20235.17, ["Fly|Ride"] = 105, ["Neon"] = 6.57, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 45.15, ["Mega|Ride"] = 115.5, ["Mega|Fly|Ride"] = 222.57}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 152.25, ["Ride"] = 182.44, ["Fly|Ride"] = 449.75, ["Neon"] = 833.44, ["Neon|Ride"] = 557.46, ["Neon|Fly|Ride"] = 735, ["Mega|Fly|Ride"] = 2481.77}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 5.25, ["Ride"] = 42, ["Neon"] = 49.34, ["Neon|Ride"] = 61.69, ["Mega"] = 280.32, ["Mega|Ride"] = 418.51, ["Mega|Fly|Ride"] = 627.8}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 210.26, ["Neon"] = 3.93, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 45.42}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 5.25, ["Ride"] = 30.85, ["Neon"] = 65.63, ["Neon|Ride"] = 112.88, ["Neon|Fly|Ride"] = 155.79, ["Mega"] = 853.13, ["Mega|Ride"] = 629.9, ["Mega|Fly|Ride"] = 620.8}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 11.81, ["Fly"] = 74.66, ["Ride"] = 26.25, ["Neon"] = 52.5, ["Neon|Ride"] = 73.49, ["Neon|Fly|Ride"] = 437.07, ["Mega"] = 350.07, ["Mega|Ride"] = 392.44, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 31.44, ["Ride"] = 70.27, ["Fly|Ride"] = 175.29, ["Neon"] = 193.14, ["Neon|Ride"] = 202.29, ["Neon|Fly|Ride"] = 384.25, ["Mega"] = 621.51, ["Mega|Fly|Ride"] = 557.46}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 140.86, ["Fly"] = 115.5, ["Ride"] = 165.38, ["Fly|Ride"] = 336.72, ["Neon"] = 775.14, ["Neon|Ride"] = 554.31, ["Neon|Fly|Ride"] = 560.62, ["Mega|Fly|Ride"] = 2159.07}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 10.49, ["Fly"] = 23.63, ["Ride"] = 23.24, ["Fly|Ride"] = 41.13, ["Neon"] = 36.75, ["Neon|Ride"] = 48.57, ["Neon|Fly|Ride"] = 91.88, ["Mega|Fly|Ride"] = 277.16}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 3.93, ["Fly"] = 131.23, ["Ride"] = 43.98, ["Fly|Ride"] = 131.25, ["Neon"] = 39.38, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 263.52, ["Mega"] = 188.98, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 465.02}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 10.5, ["Fly"] = 232.78, ["Ride"] = 77.81, ["Fly|Ride"] = 209.92, ["Neon"] = 95.82, ["Neon|Ride"] = 138.35, ["Mega"] = 560.62, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 503.62}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 43.72, ["Ride"] = 65.63, ["Fly|Ride"] = 95.52, ["Neon"] = 196.29, ["Neon|Ride"] = 228.88, ["Neon|Fly|Ride"] = 302.36, ["Mega"] = 952.2, ["Mega|Fly"] = 980.55, ["Mega|Ride"] = 910.21, ["Mega|Fly|Ride"] = 749.12}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 24.19, ["Ride"] = 80.07, ["Neon"] = 131.25, ["Mega"] = 683.44, ["Mega|Ride"] = 700.24, ["Mega|Fly|Ride"] = 733.83}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 262.5, ["Ride"] = 310.76, ["Neon"] = 2379.37, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1469.75, ["Mega|Ride"] = 3937.5, ["Mega|Fly|Ride"] = 4119.25}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 35.44, ["Ride"] = 48.57, ["Fly|Ride"] = 75.51, ["Neon|Ride"] = 186.35, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1195.69, ["Mega|Ride"] = 755.88, ["Mega|Fly|Ride"] = 750.75}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 17.4, ["Ride"] = 17.07, ["Neon"] = 2.63, ["Neon|Ride"] = 23.1, ["Neon|Fly|Ride"] = 55.13, ["Mega"] = 21, ["Mega|Fly"] = 98.69, ["Mega|Ride"] = 56.7, ["Mega|Fly|Ride"] = 136.18}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 2.63, ["Ride"] = 59.07, ["Neon"] = 15.74, ["Neon|Ride"] = 39.38, ["Mega"] = 393.75, ["Mega|Ride"] = 262.47, ["Mega|Fly|Ride"] = 491.54}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 3.93, ["Ride"] = 39.37, ["Neon"] = 18.9, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 1181.25, ["Mega"] = 131.25, ["Mega|Fly"] = 224.67, ["Mega|Ride"] = 186.88, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 393.75, ["Ride"] = 410.04, ["Fly|Ride"] = 490.16, ["Neon"] = 1388.59, ["Neon|Ride"] = 1394.16, ["Neon|Fly|Ride"] = 1311.19, ["Mega|Fly|Ride"] = 4917.93}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.63, ["Ride"] = 18.38, ["Fly|Ride"] = 56.44, ["Neon"] = 70.33, ["Neon|Ride"] = 31.52, ["Neon|Fly|Ride"] = 67.61, ["Mega|Ride"] = 167.98, ["Mega|Fly|Ride"] = 839.86}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 17.46, ["Fly"] = 31.77, ["Ride"] = 26.25, ["Fly|Ride"] = 59.07, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 208.93, ["Mega"] = 419.94, ["Mega|Ride"] = 700.24, ["Mega|Fly|Ride"] = 209.98}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 6.23, ["Ride"] = 28.32, ["Neon"] = 19.69, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 123.38, ["Mega"] = 155.39, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 1860.04}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 56.89, ["Fly"] = 210, ["Ride"] = 161.44, ["Fly|Ride"] = 90.28, ["Neon"] = 118.13, ["Neon|Ride"] = 251.96, ["Mega"] = 459.38, ["Mega|Ride"] = 838.83, ["Mega|Fly|Ride"] = 629.9}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.63, ["Fly"] = 62.74, ["Ride"] = 62.91, ["Neon|Ride"] = 109.29, ["Neon|Fly|Ride"] = 210, ["Mega|Ride"] = 139.51, ["Mega|Fly|Ride"] = 624.1}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 9.3, ["Fly"] = 104.15, ["Ride"] = 24.94, ["Fly|Ride"] = 91.88, ["Neon"] = 310.3, ["Mega"] = 700.24, ["Mega|Ride"] = 560.62, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 35.66, ["Neon"] = 6.29, ["Neon|Ride"] = 40.85, ["Mega"] = 93.01, ["Mega|Ride"] = 112.34, ["Mega|Fly|Ride"] = 310.41}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 14.44, ["Ride"] = 69.57, ["Neon"] = 89.25, ["Mega"] = 315, ["Mega|Fly|Ride"] = 6298.91}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 918.75, ["Ride"] = 77.81, ["Neon"] = 178.5, ["Neon|Ride"] = 73.25, ["Neon|Fly|Ride"] = 280.32, ["Mega"] = 419.94, ["Mega|Ride"] = 280.32, ["Mega|Fly|Ride"] = 1049.84}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 9.19, ["Fly"] = 32.82, ["Ride"] = 28.96, ["Fly|Ride"] = 53.82, ["Neon"] = 49.88, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 58.79, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 590.01, ["Mega|Ride"] = 369.7, ["Mega|Fly|Ride"] = 417.9}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 199.5, ["Ride"] = 216.57, ["Fly|Ride"] = 236.25, ["Neon"] = 1575, ["Neon|Ride"] = 3570, ["Neon|Fly|Ride"] = 1429.32, ["Mega|Fly|Ride"] = 3164.16}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.24, ["Ride"] = 19.57, ["Fly|Ride"] = 65.03, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 110.92, ["Mega"] = 220.5, ["Mega|Fly|Ride"] = 414.69}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 3.54, ["Ride"] = 34.13, ["Fly|Ride"] = 103.66, ["Neon"] = 21, ["Neon|Ride"] = 155.79, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 137.82, ["Mega|Ride"] = 159.59, ["Mega|Fly|Ride"] = 410.82}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 54.68, ["Ride"] = 78.75, ["Fly|Ride"] = 524.78, ["Neon"] = 82.69, ["Neon|Ride"] = 238.32, ["Neon|Fly|Ride"] = 629.9, ["Mega"] = 419.94, ["Mega|Ride"] = 420.35, ["Mega|Fly|Ride"] = 471.19}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 62.98, ["Ride"] = 105.13, ["Fly|Ride"] = 231.27, ["Neon"] = 463.32, ["Neon|Ride"] = 462.99, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 1908.58, ["Mega|Fly|Ride"] = 1379.47}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 36.26, ["Ride"] = 119.57, ["Fly|Ride"] = 223.13, ["Neon"] = 95.52, ["Neon|Ride"] = 175.33, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 228.38, ["Mega|Fly"] = 392.44, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 437.73}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.63, ["Fly"] = 26.25, ["Ride"] = 19.69, ["Fly|Ride"] = 58.59, ["Neon"] = 15.75, ["Mega"] = 124.41, ["Mega|Fly|Ride"] = 350.65}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 26.25, ["Ride"] = 65.63, ["Neon"] = 50.39, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 140.69, ["Mega"] = 186.88, ["Mega|Ride"] = 322.3, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 72.19, ["Fly"] = 99.75, ["Ride"] = 139.13, ["Fly|Ride"] = 290.55, ["Neon"] = 157.5, ["Neon|Ride"] = 274.37, ["Neon|Fly|Ride"] = 419.32, ["Mega"] = 532.27, ["Mega|Ride"] = 536.82, ["Mega|Fly|Ride"] = 712.69}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 3.94, ["Ride"] = 72.19, ["Neon"] = 11.57, ["Neon|Ride"] = 104.76, ["Neon|Fly|Ride"] = 157.49, ["Mega"] = 50.42, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 10.53, ["Neon"] = 77.44, ["Neon|Ride"] = 655.1, ["Mega"] = 393.75, ["Mega|Ride"] = 419.94, ["Mega|Fly|Ride"] = 629.9}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 1076.25, ["Fly"] = 1348.74, ["Ride"] = 1050, ["Fly|Ride"] = 1050, ["Neon"] = 3331.32, ["Neon|Fly|Ride"] = 3359.42, ["Mega"] = 12597.8, ["Mega|Fly|Ride"] = 11812.5}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 35.43, ["Ride"] = 525, ["Neon"] = 167.95, ["Neon|Ride"] = 531.57, ["Neon|Fly|Ride"] = 419.94, ["Mega"] = 775.69, ["Mega|Ride"] = 700.24, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 7.76, ["Fly"] = 47.32, ["Ride"] = 28.4, ["Fly|Ride"] = 419.84, ["Neon"] = 20.78, ["Neon|Fly"] = 49.34, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 98.55, ["Mega"] = 84, ["Mega|Ride"] = 173.25, ["Mega|Fly|Ride"] = 245.67}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 62.86, ["Ride"] = 131.22, ["Neon"] = 78.75, ["Mega"] = 392.65, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 775.42}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Fly|Ride"] = 419.84, ["Neon"] = 2.62, ["Neon|Ride"] = 36.88, ["Neon|Fly|Ride"] = 84, ["Mega"] = 18.38, ["Mega|Ride"] = 63, ["Mega|Fly|Ride"] = 140.69}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 84, ["Ride"] = 149, ["Fly|Ride"] = 333.55, ["Neon"] = 335.88, ["Neon|Ride"] = 353.07, ["Neon|Fly|Ride"] = 420, ["Mega"] = 1120.18, ["Mega|Ride"] = 1394.16, ["Mega|Fly|Ride"] = 1204.16}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 9.19, ["Fly"] = 101.07, ["Ride"] = 84, ["Fly|Ride"] = 812.77, ["Neon"] = 28.35, ["Neon|Ride"] = 84, ["Mega"] = 348.55, ["Mega|Ride"] = 262.47, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 3.29, ["Ride"] = 27.33, ["Neon"] = 12.47, ["Neon|Ride"] = 45.94, ["Mega"] = 147, ["Mega|Ride"] = 248.79, ["Mega|Fly|Ride"] = 378.99}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 70.32, ["Fly"] = 126, ["Ride"] = 78.75, ["Fly|Ride"] = 183.75, ["Neon"] = 160.13, ["Neon|Fly"] = 280.25, ["Neon|Ride"] = 490.28, ["Neon|Fly|Ride"] = 406.3, ["Mega"] = 418.69, ["Mega|Ride"] = 435.69, ["Mega|Fly|Ride"] = 484.32}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 15.75, ["Fly|Ride"] = 121.75, ["Neon"] = 107.63, ["Neon|Fly"] = 185.95, ["Neon|Ride"] = 246.72, ["Neon|Fly|Ride"] = 315, ["Mega"] = 980.55, ["Mega|Ride"] = 560.62, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 104.99, ["Ride"] = 280.01, ["Neon"] = 761.25, ["Neon|Ride"] = 933.19, ["Neon|Fly|Ride"] = 924.67, ["Mega"] = 1798.13, ["Mega|Ride"] = 1820.4, ["Mega|Fly|Ride"] = 1799.4}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 11.53, ["Neon"] = 26.25, ["Neon|Ride"] = 96.59, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 190.32, ["Mega|Ride"] = 155.79, ["Mega|Fly|Ride"] = 251.96}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 8.4, ["Ride"] = 31.47, ["Fly|Ride"] = 47.25, ["Neon"] = 72.19, ["Neon|Ride"] = 99.74, ["Neon|Fly|Ride"] = 280.88, ["Mega"] = 354.38, ["Mega|Ride"] = 392.44, ["Mega|Fly|Ride"] = 465.02}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 154.88, ["Ride"] = 183.75, ["Fly|Ride"] = 262.5, ["Neon"] = 569.62, ["Neon|Ride"] = 602.61, ["Neon|Fly|Ride"] = 700.24, ["Mega|Ride"] = 2415, ["Mega|Fly|Ride"] = 2086.88}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.61, ["Fly"] = 39.38, ["Ride"] = 18.38, ["Fly|Ride"] = 56.69, ["Neon"] = 17.5, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 77.44, ["Mega"] = 118.13, ["Mega|Ride"] = 232.52, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 10.49, ["Fly"] = 87.94, ["Ride"] = 30.96, ["Fly|Ride"] = 84, ["Neon"] = 26.25, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 138.59, ["Mega"] = 220.5, ["Mega|Ride"] = 262.47, ["Mega|Fly|Ride"] = 302.36}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 18.89, ["Fly|Ride"] = 47.16, ["Neon"] = 2.1, ["Neon|Ride"] = 23.1, ["Neon|Fly|Ride"] = 48.07, ["Mega"] = 23.1, ["Mega|Ride"] = 35.44, ["Mega|Fly|Ride"] = 96.87}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 31.47, ["Neon"] = 3.94, ["Mega"] = 23, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 138.8}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.63, ["Fly"] = 131.83, ["Ride"] = 71.32, ["Neon"] = 22.32, ["Neon|Ride"] = 66.29, ["Mega"] = 266.67, ["Mega|Ride"] = 207.88}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 103.69, ["Ride"] = 315, ["Neon"] = 226.59, ["Neon|Ride"] = 452.82, ["Neon|Fly|Ride"] = 630, ["Mega"] = 774.38, ["Mega|Ride"] = 560.62}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 3.73, ["Fly"] = 21.05, ["Ride"] = 18.98, ["Fly|Ride"] = 42, ["Neon"] = 42, ["Neon|Fly"] = 49.34, ["Neon|Ride"] = 26.13, ["Neon|Fly|Ride"] = 65.1, ["Mega|Fly"] = 238.32, ["Mega|Ride"] = 120.75, ["Mega|Fly|Ride"] = 314.96}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 3.93, ["Fly"] = 28.4, ["Ride"] = 28.88, ["Fly|Ride"] = 49.88, ["Neon"] = 15.73, ["Neon|Fly"] = 52.49, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 84, ["Mega"] = 131.25, ["Mega|Fly"] = 280.32, ["Mega|Ride"] = 131.14, ["Mega|Fly|Ride"] = 237.27}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 115.71, ["Neon"] = 15.73, ["Neon|Fly"] = 98.44, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 140.69, ["Mega"] = 51.18, ["Mega|Fly"] = 125.98, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 15.78, ["Ride"] = 26.17, ["Neon"] = 31.54, ["Neon|Fly|Ride"] = 267.75, ["Mega"] = 309.71, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 620.8}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 6.56, ["Fly"] = 153.83, ["Neon"] = 62.99, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 209.98, ["Mega"] = 310.41, ["Mega|Ride"] = 417.84, ["Mega|Fly|Ride"] = 1259.79}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 3.51, ["Fly"] = 35.44, ["Ride"] = 23.24, ["Fly|Ride"] = 67.13, ["Neon"] = 26.24, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 105, ["Mega"] = 173.78, ["Mega|Ride"] = 279.95, ["Mega|Fly|Ride"] = 410.5}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 3.93, ["Fly"] = 26.25, ["Ride"] = 17.07, ["Fly|Ride"] = 41.96, ["Neon"] = 139.47, ["Neon|Ride"] = 25.59, ["Neon|Fly|Ride"] = 70.35, ["Mega"] = 111.29, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 223.91}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 220.5, ["Fly"] = 393.75, ["Ride"] = 210, ["Neon"] = 924, ["Neon|Ride"] = 930.01, ["Neon|Fly|Ride"] = 980.55, ["Mega|Fly|Ride"] = 3653.37}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 5.25, ["Ride"] = 39.38, ["Neon"] = 30.19, ["Neon|Fly|Ride"] = 280.32, ["Mega"] = 155.39, ["Mega|Ride"] = 140.69, ["Mega|Fly|Ride"] = 980.55}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 3.84, ["Fly"] = 65.63, ["Ride"] = 24.14, ["Fly|Ride"] = 105, ["Neon|Ride"] = 48.3, ["Neon|Fly|Ride"] = 139.65, ["Mega"] = 203.44, ["Mega|Ride"] = 459.38}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 7.87, ["Neon"] = 40.68, ["Neon|Fly|Ride"] = 629.9, ["Mega"] = 418.51, ["Mega|Ride"] = 410.5, ["Mega|Fly|Ride"] = 1007.35}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 17.07, ["Fly|Ride"] = 33.79, ["Neon"] = 2.63, ["Neon|Fly"] = 21, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 35.44, ["Mega"] = 25.22, ["Mega|Ride"] = 31.4, ["Mega|Fly|Ride"] = 73.5}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 3.68, ["Fly"] = 56.47, ["Ride"] = 24.13, ["Fly|Ride"] = 56.44, ["Neon"] = 17.45, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 131.25, ["Mega|Ride"] = 143.07, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 4.2, ["Ride"] = 28.32, ["Neon"] = 12.74, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 52.5, ["Mega|Ride"] = 140.69, ["Mega|Fly|Ride"] = 450.19}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 82.69, ["Ride"] = 83.91, ["Fly|Ride"] = 139.13, ["Neon|Ride"] = 420, ["Neon|Fly|Ride"] = 494.82, ["Mega|Ride"] = 3501.15, ["Mega|Fly|Ride"] = 1624.08}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 6.17, ["Fly"] = 85.32, ["Ride"] = 66.08, ["Fly|Ride"] = 65.54, ["Neon"] = 21, ["Neon|Ride"] = 70.12, ["Neon|Fly|Ride"] = 310.41, ["Mega"] = 280.32, ["Mega|Fly|Ride"] = 309.25}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.52, ["Ride"] = 56.64, ["Fly|Ride"] = 155.23, ["Neon"] = 8.42, ["Neon|Ride"] = 125.98, ["Neon|Fly|Ride"] = 167.98, ["Mega"] = 69.77, ["Mega|Ride"] = 94.49, ["Mega|Fly|Ride"] = 916.08}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 57.75, ["Fly"] = 124.69, ["Ride"] = 98.59, ["Fly|Ride"] = 217.33, ["Neon"] = 210, ["Neon|Ride"] = 280.32, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 671.9, ["Mega|Ride"] = 521.07, ["Mega|Fly|Ride"] = 755.88}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Ride"] = 17.07, ["Fly|Ride"] = 58.74, ["Neon"] = 2.63, ["Neon|Fly"] = 21, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 93.71, ["Mega"] = 13.97, ["Mega|Fly"] = 48.84, ["Mega|Ride"] = 36.75, ["Mega|Fly|Ride"] = 82.95}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Neon"] = 4.66, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 140.69, ["Mega"] = 26.25, ["Mega|Ride"] = 73.5}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 3.94, ["Neon"] = 11.82, ["Neon|Ride"] = 56.49, ["Neon|Fly|Ride"] = 192.94, ["Mega"] = 73.5, ["Mega|Ride"] = 175.85, ["Mega|Fly|Ride"] = 314.96}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 10.5, ["Fly"] = 133.52, ["Ride"] = 59.07, ["Fly|Ride"] = 120.53, ["Neon"] = 21, ["Neon|Fly"] = 87.13, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 465.45, ["Mega|Ride"] = 186.88, ["Mega|Fly|Ride"] = 266.67}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 15.74, ["Fly|Ride"] = 34.13, ["Neon"] = 2.1, ["Neon|Fly"] = 25.22, ["Neon|Ride"] = 35.18, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 26.25, ["Mega|Ride"] = 56.7, ["Mega|Fly|Ride"] = 103.69}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 15.74, ["Ride"] = 42, ["Neon"] = 60.44, ["Neon|Fly|Ride"] = 189.67, ["Mega"] = 238.32, ["Mega|Ride"] = 449.33, ["Mega|Fly|Ride"] = 283.5}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 3784.43, ["Fly"] = 3150, ["Ride"] = 4194.67, ["Fly|Ride"] = 3638.03, ["Neon|Fly|Ride"] = 12718}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Ride"] = 18.38, ["Fly|Ride"] = 60.84, ["Neon"] = 14.13, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 66.94, ["Mega"] = 105, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 1049.84}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 4.66, ["Neon"] = 27.3, ["Mega"] = 126, ["Mega|Ride"] = 419.94, ["Mega|Fly|Ride"] = 629.9}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 24.94, ["Ride"] = 32.52, ["Fly|Ride"] = 157.5, ["Neon"] = 93.19, ["Neon|Ride"] = 140.69, ["Neon|Fly|Ride"] = 280.32, ["Mega|Ride"] = 479.07, ["Mega|Fly|Ride"] = 418.89}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 59.07, ["Ride"] = 65.63, ["Fly|Ride"] = 105, ["Neon"] = 277.1, ["Mega"] = 1259.79, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 728.8}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 126, ["Fly"] = 1402.35, ["Ride"] = 140.54, ["Fly|Ride"] = 279.57, ["Neon"] = 1679.3, ["Neon|Ride"] = 774.38, ["Neon|Fly|Ride"] = 1140.59, ["Mega"] = 6298.91, ["Mega|Ride"] = 3009.84, ["Mega|Fly|Ride"] = 3501.15}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 13.02, ["Ride"] = 39.38, ["Fly|Ride"] = 675.94, ["Neon"] = 39.89, ["Neon|Ride"] = 139.51, ["Neon|Fly|Ride"] = 140.69, ["Mega"] = 224.67, ["Mega|Ride"] = 224.67, ["Mega|Fly|Ride"] = 253.32}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.63, ["Ride"] = 62.93, ["Neon"] = 36.72, ["Neon|Fly"] = 96.57, ["Neon|Ride"] = 34.13, ["Mega"] = 133.34, ["Mega|Fly|Ride"] = 825.57}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 3.81, ["Fly"] = 101.94, ["Ride"] = 70.27, ["Fly|Ride"] = 118.13, ["Neon"] = 10.49, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 251.96, ["Mega"] = 65.63, ["Mega|Ride"] = 137.2, ["Mega|Fly|Ride"] = 287.44}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 13.13, ["Neon|Ride"] = 209.98, ["Mega"] = 525, ["Mega|Fly|Ride"] = 335.96}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 70.44, ["Neon"] = 2.1, ["Neon|Ride"] = 32.82, ["Mega"] = 18.36, ["Mega|Ride"] = 133.88, ["Mega|Fly|Ride"] = 290.64}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 97.13, ["Ride"] = 105.13, ["Fly|Ride"] = 130.59, ["Neon"] = 464.86, ["Neon|Ride"] = 409.5, ["Neon|Fly|Ride"] = 459.84, ["Mega|Ride"] = 1679.71, ["Mega|Fly|Ride"] = 1705.43}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.63, ["Ride"] = 32.52, ["Neon"] = 10.31, ["Mega|Ride"] = 112.88}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 42, ["Fly"] = 217.65, ["Ride"] = 92.97, ["Fly|Ride"] = 116.82, ["Neon"] = 278.92, ["Neon|Ride"] = 365.4, ["Neon|Fly|Ride"] = 419.94, ["Mega"] = 2625, ["Mega|Ride"] = 2799.87, ["Mega|Fly|Ride"] = 1330.13}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 33.8, ["Ride"] = 52.5, ["Fly|Ride"] = 70.33, ["Neon"] = 6.32, ["Neon|Ride"] = 91.85, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 49.88, ["Mega|Fly|Ride"] = 211.98}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 3.28, ["Neon"] = 14.34, ["Neon|Ride"] = 151.14, ["Mega"] = 78.75, ["Mega|Ride"] = 210.63, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 13.13, ["Ride"] = 126.04, ["Neon"] = 63, ["Neon|Fly"] = 291.38, ["Neon|Ride"] = 131.25, ["Mega"] = 232.03, ["Mega|Ride"] = 310.41, ["Mega|Fly|Ride"] = 1567.09}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 399, ["Ride"] = 633.07, ["Fly|Ride"] = 616.63, ["Neon"] = 1179.94, ["Neon|Ride"] = 1260, ["Neon|Fly|Ride"] = 1958.18, ["Mega"] = 4041.8, ["Mega|Ride"] = 3412.5, ["Mega|Fly|Ride"] = 3409.88}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 34.12, ["Ride"] = 56.44, ["Fly|Ride"] = 77.81, ["Neon"] = 181.12, ["Neon|Fly"] = 310.3, ["Neon|Ride"] = 208.69, ["Neon|Fly|Ride"] = 210, ["Mega|Fly|Ride"] = 1548.75}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 34.13, ["Ride"] = 31.49, ["Fly|Ride"] = 91.88, ["Neon"] = 7.25, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 91.77, ["Mega"] = 111.57, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 279.01}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 14.7, ["Fly"] = 109.61, ["Ride"] = 40.95, ["Fly|Ride"] = 91.88, ["Neon"] = 41.99, ["Neon|Fly"] = 124.36, ["Neon|Ride"] = 82.95, ["Neon|Fly|Ride"] = 176.19, ["Mega"] = 196.33, ["Mega|Fly"] = 956.76, ["Mega|Ride"] = 232.03, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 5.12, ["Ride"] = 35.44, ["Neon"] = 83.98, ["Neon|Ride"] = 96.59, ["Mega"] = 470.33, ["Mega|Ride"] = 465.02, ["Mega|Fly|Ride"] = 523.15}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 6.57, ["Neon"] = 18.35, ["Mega"] = 70.35, ["Mega|Ride"] = 139.12}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.63, ["Fly"] = 86.63, ["Ride"] = 21, ["Fly|Ride"] = 59.07, ["Neon"] = 26.24, ["Neon|Ride"] = 3219.8, ["Neon|Fly|Ride"] = 280.32, ["Mega"] = 542.92, ["Mega|Ride"] = 486.94}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 105, ["Ride"] = 139.34, ["Fly|Ride"] = 355.81, ["Neon"] = 565.72, ["Neon|Ride"] = 725.42, ["Neon|Fly|Ride"] = 767.44, ["Mega|Ride"] = 2547.92, ["Mega|Fly|Ride"] = 2674.95}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 65.63, ["Ride"] = 78.75, ["Fly|Ride"] = 144, ["Neon"] = 192.94, ["Neon|Ride"] = 280.32, ["Mega"] = 629.9, ["Mega|Ride"] = 670.85, ["Mega|Fly|Ride"] = 728.59}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2552.82, ["Fly"] = 2349.23, ["Ride"] = 2942.16, ["Fly|Ride"] = 2926.88, ["Neon"] = 12594.71, ["Neon|Fly|Ride"] = 8834.99, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 3.93, ["Fly"] = 65625, ["Ride"] = 22.1, ["Fly|Ride"] = 170.63, ["Neon"] = 12.48, ["Neon|Ride"] = 42, ["Mega"] = 97.13, ["Mega|Ride"] = 169.32}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 11.81, ["Ride"] = 77.81, ["Fly|Ride"] = 195.57, ["Neon"] = 73.48, ["Neon|Ride"] = 112.34, ["Neon|Fly|Ride"] = 210, ["Mega"] = 161.68, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 557.81}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 1050, ["Fly"] = 1364.51, ["Ride"] = 1257.38, ["Fly|Ride"] = 2099.12, ["Neon"] = 4041.86, ["Neon|Ride"] = 4042.85, ["Neon|Fly|Ride"] = 3806.25, ["Mega|Ride"] = 14697.42, ["Mega|Fly|Ride"] = 14531.46}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 52.5, ["Ride"] = 49.88, ["Fly|Ride"] = 262.5, ["Neon"] = 182.41, ["Mega"] = 838.83, ["Mega|Ride"] = 1889.69, ["Mega|Fly|Ride"] = 752.07}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 6.22, ["Ride"] = 104.08, ["Neon"] = 21, ["Neon|Ride"] = 73.5, ["Neon|Fly|Ride"] = 105, ["Mega"] = 192.29, ["Mega|Fly|Ride"] = 276.11}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 111.19, ["Neon"] = 3.93, ["Neon|Ride"] = 52.5, ["Mega"] = 29.69, ["Mega|Ride"] = 68.25, ["Mega|Fly|Ride"] = 125.98}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 87.94, ["Fly"] = 155.59, ["Ride"] = 126, ["Neon"] = 700.07, ["Neon|Ride"] = 700.24, ["Mega"] = 8398.53, ["Mega|Fly|Ride"] = 2519.56}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 36.8, ["Neon"] = 36.75, ["Neon|Ride"] = 252, ["Mega|Ride"] = 419.94, ["Mega|Fly|Ride"] = 419.94}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 168, ["Neon"] = 620.58, ["Mega"] = 2099.65}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 4.23, ["Fly"] = 105, ["Fly|Ride"] = 91.88, ["Neon"] = 32.82, ["Neon|Fly|Ride"] = 315, ["Mega"] = 223.42}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 236.25, ["Ride"] = 255.94, ["Fly|Ride"] = 328.13, ["Neon"] = 881.64, ["Neon|Ride"] = 980.55, ["Neon|Fly|Ride"] = 1023.75, ["Mega|Fly|Ride"] = 3849.69}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 3.94, ["Fly"] = 28.28, ["Ride"] = 28.32, ["Fly|Ride"] = 67.24, ["Neon"] = 56.69, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 146.98, ["Mega"] = 241.5, ["Mega|Ride"] = 310.41, ["Mega|Fly|Ride"] = 433.16}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 26.78, ["Ride"] = 25.56, ["Fly|Ride"] = 43.63, ["Neon"] = 3.93, ["Neon|Fly"] = 39.14, ["Neon|Ride"] = 23.1, ["Neon|Fly|Ride"] = 60.9, ["Mega"] = 57.74, ["Mega|Ride"] = 81.9, ["Mega|Fly|Ride"] = 91.88}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 748.13, ["Fly"] = 1108, ["Ride"] = 903, ["Fly|Ride"] = 787.5, ["Neon|Ride"] = 7699.36, ["Neon|Fly|Ride"] = 4199.27}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 15.68, ["Fly"] = 980.19, ["Ride"] = 210, ["Neon"] = 65.63, ["Mega"] = 164.07, ["Mega|Fly|Ride"] = 291.38}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 12.83, ["Fly"] = 46.57, ["Ride"] = 46.16, ["Fly|Ride"] = 109.26, ["Neon"] = 39.38, ["Neon|Ride"] = 70.88, ["Neon|Fly|Ride"] = 192.99, ["Mega"] = 157.5, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 381.76}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 37.94, ["Fly"] = 44.44, ["Ride"] = 38.7, ["Fly|Ride"] = 77.81, ["Neon|Ride"] = 185.94, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 2099.65, ["Mega|Fly|Ride"] = 911.43}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 24.94, ["Fly"] = 78.86, ["Ride"] = 41.96, ["Fly|Ride"] = 109.16, ["Neon"] = 78.75, ["Neon|Ride"] = 82.95, ["Neon|Fly|Ride"] = 186.01, ["Mega|Ride"] = 303.19, ["Mega|Fly|Ride"] = 442.31}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 27.57, ["Ride"] = 65.63, ["Fly|Ride"] = 636.57, ["Neon"] = 141.71, ["Neon|Ride"] = 262.5, ["Mega"] = 700.24, ["Mega|Ride"] = 494.48, ["Mega|Fly|Ride"] = 612.94}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 116.59, ["Fly|Ride"] = 232.22, ["Neon"] = 2.63, ["Neon|Ride"] = 78.75, ["Mega"] = 30.19, ["Mega|Ride"] = 140.69}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 36.09, ["Fly"] = 48.57, ["Ride"] = 40.69, ["Fly|Ride"] = 77.42, ["Neon"] = 278.97, ["Neon|Fly"] = 310.21, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 3359.42, ["Mega|Fly|Ride"] = 1089.72}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.1, ["Fly"] = 140.87, ["Ride"] = 27.56, ["Fly|Ride"] = 127.32, ["Mega"] = 700.24, ["Mega|Ride"] = 271.69}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 25.25, ["Ride"] = 18.38, ["Fly|Ride"] = 97.13, ["Neon|Ride"] = 42.06, ["Mega"] = 1037.23, ["Mega|Ride"] = 280.32, ["Mega|Fly|Ride"] = 202.13}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 4.66, ["Neon"] = 105, ["Neon|Fly|Ride"] = 105, ["Mega"] = 262.5}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 22.1, ["Fly"] = 262.5, ["Ride"] = 46.16, ["Fly|Ride"] = 131.25, ["Neon"] = 116.81, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 226.77, ["Mega"] = 1120.18, ["Mega|Ride"] = 735, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 7.76, ["Neon"] = 18.38, ["Neon|Ride"] = 63, ["Mega"] = 118.12, ["Mega|Fly|Ride"] = 310.41}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 27.27, ["Neon"] = 2.63, ["Neon|Ride"] = 91.88, ["Mega"] = 17.07, ["Mega|Ride"] = 73.49, ["Mega|Fly|Ride"] = 201.48}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Ride"] = 26.17, ["Neon"] = 2.1, ["Neon|Fly"] = 393.65, ["Neon|Ride"] = 26.25, ["Mega"] = 19.69, ["Mega|Fly"] = 73.86, ["Mega|Ride"] = 112.34, ["Mega|Fly|Ride"] = 114.19}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 36.75, ["Ride"] = 23.63, ["Fly|Ride"] = 40.05, ["Neon"] = 9.3, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 83.71, ["Mega"] = 96.59, ["Mega|Ride"] = 124.41, ["Mega|Fly|Ride"] = 246.1}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.63, ["Ride"] = 27.28, ["Fly|Ride"] = 49.3, ["Neon"] = 91.88, ["Mega"] = 140.69, ["Mega|Ride"] = 146.88}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 3.93, ["Fly"] = 39.97, ["Ride"] = 17.43, ["Fly|Ride"] = 39.38, ["Neon"] = 17.45, ["Neon|Ride"] = 31.4, ["Neon|Fly|Ride"] = 80.07, ["Mega"] = 223.13, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 360.28}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 94.5, ["Ride"] = 167.81, ["Fly|Ride"] = 392.56, ["Neon|Fly|Ride"] = 1049.84, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 826.22}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 26.3, ["Ride"] = 20.98, ["Fly|Ride"] = 31.5, ["Neon"] = 3.94, ["Neon|Fly"] = 72.19, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 53.82, ["Mega"] = 36.75, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 146.98}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 9.18, ["Fly"] = 32.47, ["Ride"] = 32.82, ["Fly|Ride"] = 64.32, ["Neon"] = 39.38, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 158.89, ["Mega"] = 310.41, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 9.87, ["Fly"] = 37.26, ["Ride"] = 33.57, ["Fly|Ride"] = 49.94, ["Neon"] = 88.18, ["Neon|Ride"] = 82.56, ["Neon|Fly|Ride"] = 123.89, ["Mega"] = 1259.79, ["Mega|Ride"] = 770.58}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 2.88, ["Fly"] = 140.38, ["Ride"] = 46.47, ["Neon"] = 27.9, ["Neon|Ride"] = 70.35, ["Mega"] = 280.32, ["Mega|Ride"] = 245.67}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 56.69, ["Neon"] = 3.93, ["Neon|Fly"] = 81.38, ["Neon|Ride"] = 23.1, ["Neon|Fly|Ride"] = 70.35, ["Mega"] = 36.75, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 61.57, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 3.89, ["Ride"] = 28.32, ["Neon"] = 15.74, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 99.74, ["Mega"] = 98.69, ["Mega|Fly"] = 735, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 382.15}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 1019.82, ["Ride"] = 1047.38, ["Fly|Ride"] = 1207.49, ["Neon"] = 2718.12, ["Neon|Ride"] = 2228.63, ["Neon|Fly|Ride"] = 2278.5, ["Mega|Fly|Ride"] = 7434}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 72.19, ["Ride"] = 112.5, ["Fly|Ride"] = 131.25, ["Neon"] = 209.92, ["Neon|Ride"] = 270.86, ["Neon|Fly|Ride"] = 918.75, ["Mega"] = 2812.69, ["Mega|Ride"] = 1259.79, ["Mega|Fly|Ride"] = 1224.11}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Fly"] = 63.09, ["Neon"] = 28.35, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 315, ["Mega"] = 52.5, ["Mega|Ride"] = 393.75}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 39.97, ["Ride"] = 56.62, ["Fly|Ride"] = 262.5, ["Neon"] = 221.82, ["Neon|Ride"] = 237.16, ["Neon|Fly|Ride"] = 313.91, ["Mega"] = 1240.41, ["Mega|Ride"] = 991.04, ["Mega|Fly|Ride"] = 1240.41}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 10.5, ["Ride"] = 114.96, ["Neon"] = 60.38, ["Neon|Ride"] = 131.25, ["Mega"] = 434.8, ["Mega|Fly|Ride"] = 1049.84}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 275.63, ["Fly"] = 931.08, ["Ride"] = 327.2, ["Fly|Ride"] = 556.5, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 1110.38, ["Mega|Fly|Ride"] = 6697.95}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 102.38, ["Ride"] = 22.32, ["Fly|Ride"] = 129.93, ["Neon"] = 25.22, ["Neon|Ride"] = 73.5, ["Mega"] = 402.09, ["Mega|Fly"] = 280.32}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.63, ["Neon"] = 83.98, ["Neon|Ride"] = 140.69, ["Mega"] = 112.34, ["Mega|Ride"] = 280.32}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 52.5, ["Ride"] = 1312.5, ["Fly|Ride"] = 282.96, ["Neon"] = 140.59, ["Neon|Ride"] = 280.32, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 700.24, ["Mega|Ride"] = 503.92, ["Mega|Fly|Ride"] = 793.42}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.61, ["Ride"] = 70.75, ["Fly|Ride"] = 140.54, ["Neon"] = 23.63, ["Mega"] = 222.57, ["Mega|Ride"] = 276.11, ["Mega|Fly|Ride"] = 419.94}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 16.79, ["Fly|Ride"] = 32.82, ["Neon"] = 6.57, ["Neon|Fly"] = 31.39, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 64.84, ["Mega"] = 37.94, ["Mega|Fly"] = 45.35, ["Mega|Ride"] = 40.69, ["Mega|Fly|Ride"] = 89.25}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4906.07, ["Ride"] = 5347.15, ["Fly|Ride"] = 4062.19, ["Neon"] = 25189.42, ["Neon|Fly|Ride"] = 25895.8, ["Mega|Fly|Ride"] = 86785.08}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 11.82, ["Ride"] = 50.47, ["Neon"] = 280.25, ["Mega"] = 262.5, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 3.93, ["Ride"] = 19.69, ["Fly|Ride"] = 57.75, ["Neon"] = 15.75, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 95.54, ["Mega"] = 283.47, ["Mega|Ride"] = 124.35, ["Mega|Fly|Ride"] = 205.78}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 472.5, ["Fly"] = 840, ["Ride"] = 525, ["Fly|Ride"] = 560.48, ["Neon"] = 1679.3, ["Neon|Ride"] = 1679.71, ["Neon|Fly|Ride"] = 1385.77, ["Mega|Fly|Ride"] = 6431.06}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 5.2, ["Ride"] = 52.5, ["Neon"] = 35.7, ["Neon|Ride"] = 209.98, ["Mega"] = 280.32, ["Mega|Fly|Ride"] = 686.59}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 4.19, ["Fly"] = 104.74, ["Ride"] = 77.81, ["Neon"] = 65.62, ["Neon|Ride"] = 280.32, ["Neon|Fly|Ride"] = 13998.25, ["Mega"] = 280.32, ["Mega|Ride"] = 401.63}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Ride"] = 30.42, ["Fly|Ride"] = 36.71, ["Neon"] = 10.5, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 101.07, ["Mega"] = 42, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 155.39}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 618.19, ["Ride"] = 731.98, ["Fly|Ride"] = 742.05, ["Neon|Fly|Ride"] = 2492.44, ["Mega|Fly|Ride"] = 8751.75}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 6.57, ["Ride"] = 36.01, ["Neon"] = 27.57, ["Neon|Ride"] = 155.79, ["Neon|Fly|Ride"] = 190.66, ["Mega"] = 196.33, ["Mega|Ride"] = 213.94, ["Mega|Fly|Ride"] = 304.45}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 7.86, ["Fly"] = 46.57, ["Ride"] = 30.19, ["Neon"] = 35.43, ["Neon|Ride"] = 116.54, ["Neon|Fly|Ride"] = 3877, ["Mega"] = 373.31, ["Mega|Ride"] = 227.67, ["Mega|Fly|Ride"] = 360.4}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 4.2, ["Fly"] = 23.04, ["Ride"] = 19.57, ["Fly|Ride"] = 51.19, ["Neon"] = 17.16, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 86.63, ["Mega"] = 104.81, ["Mega|Ride"] = 158.82, ["Mega|Fly|Ride"] = 269.14}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 39.97, ["Ride"] = 62.71, ["Neon"] = 70.33, ["Neon|Ride"] = 139.51, ["Mega"] = 557.46, ["Mega|Ride"] = 619.41, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.63, ["Neon"] = 4.22, ["Neon|Fly|Ride"] = 2034.38, ["Mega"] = 47.25, ["Mega|Ride"] = 101.15, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 418.69, ["Ride"] = 501.38, ["Fly|Ride"] = 587.77, ["Neon"] = 2072.89, ["Neon|Ride"] = 2080.75, ["Neon|Fly|Ride"] = 2292.81, ["Mega|Fly|Ride"] = 9924.97}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 62.04, ["Neon"] = 6.32, ["Neon|Ride"] = 48.57, ["Neon|Fly|Ride"] = 140.69, ["Mega"] = 45.94, ["Mega|Ride"] = 132.29, ["Mega|Fly|Ride"] = 260.37}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 6.32, ["Neon|Ride"] = 203.68, ["Mega"] = 28.88, ["Mega|Ride"] = 82.95, ["Mega|Fly|Ride"] = 263.52}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Neon"] = 4.47, ["Neon|Ride"] = 45.92, ["Mega"] = 38.07, ["Mega|Fly"] = 155.39, ["Mega|Ride"] = 91.34}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 3.94, ["Ride"] = 124.69, ["Neon"] = 15.75, ["Mega"] = 229.93}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 54.71, ["Ride"] = 98.59, ["Fly|Ride"] = 156.19, ["Neon"] = 216.57, ["Neon|Ride"] = 224.67, ["Neon|Fly|Ride"] = 340.6, ["Mega"] = 591.94, ["Mega|Ride"] = 607.51, ["Mega|Fly|Ride"] = 720.57}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 26.25, ["Ride"] = 82.69, ["Fly|Ride"] = 276.94, ["Neon"] = 115.31, ["Neon|Ride"] = 125.98, ["Neon|Fly|Ride"] = 280.32, ["Mega"] = 472.43, ["Mega|Ride"] = 418.89, ["Mega|Fly|Ride"] = 1166.55}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 18.98, ["Fly|Ride"] = 32.81, ["Neon"] = 17.45, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 68.25, ["Mega"] = 307.79, ["Mega|Fly|Ride"] = 260.37}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 12.69, ["Ride"] = 52.5, ["Neon"] = 172.01, ["Neon|Ride"] = 158.82, ["Mega|Fly|Ride"] = 529.12}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Ride"] = 92.53, ["Fly|Ride"] = 362.25, ["Neon"] = 12.62, ["Neon|Ride"] = 44.63, ["Mega"] = 121.79, ["Mega|Ride"] = 155.39, ["Mega|Fly|Ride"] = 232.03}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 28.4, ["Ride"] = 42, ["Fly|Ride"] = 56.44, ["Neon|Ride"] = 224.67, ["Neon|Fly|Ride"] = 209.98, ["Mega"] = 1050, ["Mega|Ride"] = 930.02, ["Mega|Fly|Ride"] = 695.63}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 65.19, ["Fly"] = 874.13, ["Mega|Ride"] = 625.7}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 52.38, ["Fly"] = 115.5, ["Ride"] = 71.32, ["Fly|Ride"] = 131.25, ["Neon"] = 288.75, ["Neon|Ride"] = 309.71, ["Neon|Fly|Ride"] = 444.15, ["Mega|Ride"] = 1643.81, ["Mega|Fly|Ride"] = 1316.44}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 52.5, ["Fly"] = 291.38, ["Ride"] = 77.44, ["Neon"] = 167.95, ["Neon|Ride"] = 408.19, ["Neon|Fly|Ride"] = 364.88, ["Mega"] = 692.9, ["Mega|Ride"] = 686.59, ["Mega|Fly|Ride"] = 897.47}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 46.57, ["Ride"] = 77.81, ["Neon"] = 157.5, ["Neon|Ride"] = 223.13, ["Mega"] = 839.86, ["Mega|Fly|Ride"] = 1259.79}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 9.18, ["Fly"] = 52.5, ["Ride"] = 31.49, ["Fly|Ride"] = 3937.5, ["Neon"] = 39.38, ["Neon|Fly"] = 167.95, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 493.43, ["Mega|Ride"] = 345.19, ["Mega|Fly|Ride"] = 797.88}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 28.4, ["Ride"] = 17.07, ["Fly|Ride"] = 39.38, ["Neon"] = 5.25, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 21.11, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 51.17, ["Mega|Ride"] = 63, ["Mega|Fly|Ride"] = 186.38}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 978.7}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 24.94, ["Ride"] = 75.51, ["Fly|Ride"] = 262.5, ["Neon"] = 133.3, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 418.51, ["Mega"] = 560.62, ["Mega|Ride"] = 595.22, ["Mega|Fly|Ride"] = 628.85}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 31.44, ["Neon"] = 3.92, ["Neon|Ride"] = 36.74, ["Neon|Fly|Ride"] = 293.96, ["Mega"] = 31.4, ["Mega|Ride"] = 112.34, ["Mega|Fly|Ride"] = 310.41}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 27.57, ["Neon"] = 315, ["Neon|Ride"] = 523.87, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 711.38, ["Mega|Ride"] = 816.78, ["Mega|Fly|Ride"] = 763.88}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 5.25, ["Mega"] = 31.89}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.63, ["Neon"] = 3.93, ["Neon|Ride"] = 87.21, ["Mega"] = 26.25, ["Mega|Ride"] = 199.5}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 147, ["Ride"] = 162.57, ["Fly|Ride"] = 238.26, ["Neon"] = 597.19, ["Neon|Ride"] = 590.63, ["Neon|Fly|Ride"] = 629.9, ["Mega|Ride"] = 2240.32, ["Mega|Fly|Ride"] = 2588.85}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 4.2, ["Fly"] = 65.63, ["Ride"] = 22.88, ["Fly|Ride"] = 88.11, ["Neon"] = 11.82, ["Neon|Fly"] = 62.99, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 63, ["Mega"] = 107.63, ["Mega|Ride"] = 112.34, ["Mega|Fly|Ride"] = 560.62}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 36.16, ["Fly|Ride"] = 86.63, ["Neon"] = 6.57, ["Neon|Ride"] = 56.7, ["Neon|Fly|Ride"] = 419.99, ["Mega"] = 51.19, ["Mega|Ride"] = 155.79}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 3.91, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 35.44, ["Mega"] = 35.44, ["Mega|Ride"] = 74.8, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 91.88, ["Neon"] = 5.25, ["Neon|Ride"] = 155.99, ["Neon|Fly|Ride"] = 140.69, ["Mega"] = 56.7, ["Mega|Ride"] = 95.7, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 45.87, ["Ride"] = 86.63, ["Fly|Ride"] = 1049.56, ["Neon"] = 333.78, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1115.97, ["Mega|Ride"] = 1540.09, ["Mega|Fly|Ride"] = 1540.09}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 4.17, ["Ride"] = 139.47, ["Neon"] = 32.82, ["Neon|Ride"] = 111.57, ["Mega"] = 140.22, ["Mega|Ride"] = 547.98}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 374.73, ["Ride"] = 367.5, ["Fly|Ride"] = 436.63, ["Neon"] = 1400.13, ["Neon|Ride"] = 1120.18, ["Neon|Fly|Ride"] = 1207.31, ["Mega|Ride"] = 3215.6, ["Mega|Fly|Ride"] = 3150}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 70.75}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 43.32}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 15.72}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 20.87}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 35.44}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 39.37}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 9.43}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 14.42}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 213.94}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 22.3}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 39.59}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 10.5}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 7.88}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 262.16}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 7.88}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 7.88}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 8.43}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 10.49}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 57.64}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 465.94}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.63}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 806.31}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 11.81}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1111.69}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.63}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 115.5}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 14.44}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.37}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 10.49}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.63}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 3.73}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 39.38}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 103.03}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 51.18}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 19.59}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.63}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 9.17}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 13.13}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 5.25}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 11.82}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 4.67}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 28.4}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 17.05}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 6.3}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.63}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 1259.99}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 116.7}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 301.88}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 12.78}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 4.2}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 9.8}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 53.42}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 118.13}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 15.78}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 13.11}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.63}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 780.14}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 18.34}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 11.54}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.63}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 26.25}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 11.29}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 4.66}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 101.07}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 19.67}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 11.82}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 18.32}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 4.67}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 11.58}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 6.33}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 22.31}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.24}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 108.94}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 152.25}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 6.56}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 23.29}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.63}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 22.32}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 27.57}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 75.58}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 52.48}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.63}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 168}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 155.97}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 45.94}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 41.74}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 280.69}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 31.5}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 39.37}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 76.13}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 155.97}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 36.75}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 45.4}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 26.13}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 44.88}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 40.69}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 354.38}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 9.08}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 15.75}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.63}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 6.45}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 26.14}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 43.26}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 3.94}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 6.56}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.63}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.63}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 6.18}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 4.86}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 656.25}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 8.55}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 668.05}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 27.55}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.63}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.63}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 378.46}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.63}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 35.44}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 38.06}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 42}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 135.19}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 28.88}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 3.94}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 12.65}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.63}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.1}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 3.93}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 3.94}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 40.95}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.63}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 3.93}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 2.63}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 20.88}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 14.39}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 137.82}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.61}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.63}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 177.19}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 15.78}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 10.13}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 10.53}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 19.64}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 164.07}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 28.03}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 3.67}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 15.61}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 17.07}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 124.69}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 38.04}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 6.57}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 5.25}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 4.23}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 3.59}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 8.39}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 11.58}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 3.94}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 61.7}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.35}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.63}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 4.45}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.63}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 4.19}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.63}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 7884.19}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 7}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 24.94}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 2.35}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 2.63}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 37.95}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 11.65}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 14.44}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 12.63}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 22.03}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 15.72}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 131.25}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.37}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 15.72}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 3.94}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 6.56}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 3.54}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 2.63}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 32.6}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4346.9}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 4.65}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 3.23}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 43.05}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.63}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 7.88}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 74.82}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 9.19}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 279.3}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.63}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 105}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 4.2}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.63}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 3.93}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 35.44}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 23.02}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.63}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.63}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 10.5}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.63}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 5.24}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 7}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 9.19}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.63}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.16}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 4.99}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 3.92}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 36.49}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 6.57}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 11.82}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 118.13}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 2.24}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 44.44}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 7.34}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 983.06}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 21}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 4.65}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 3.68}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 3.94}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.63}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 22.2}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 4.99}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 3.94}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 14.44}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 18.06}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 5.25}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 63.09}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 15.78}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.61}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 3.71}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 11.54}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 3.72}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 15.33}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 3.5}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.63}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 4.19}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 12.78}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 5.86}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 4.87}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 127.02}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.63}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.37}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 5.25}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 45.94}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.63}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 6.57}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 2.1}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 26.23}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 24.04}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 3.94}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 3.93}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 111.45}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 3.94}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 8.43}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 9.19}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 3.94}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 8.45}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 3.92}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 6.57}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 10.53}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 21.04}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 65.63}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 6.56}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 3.18}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 108.93}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 4.67}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1316.44}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 4.66}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 170.71}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 6.24}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 3.93}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.63}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.63}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.37}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 43.31}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 8.4}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.24}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 3.94}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 56.88}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 7.49}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 3.56}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 4.66}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.63}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 6.57}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.63}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 6.56}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 5.01}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 49.29}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 5.25}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 67.33}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 6.33}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 5.16}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 52.5}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 4.23}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 42}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 128.63}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 3.42}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 2.61}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.24}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 70.88}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 4.23}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 3.93}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.63}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 15.78}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 64.99}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 53.7}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 100.93}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 328.13}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 3.67}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 58.89}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 105.13}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 2.61}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 8.38}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 23.62}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 77.64}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 3.93}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 23.62}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 962.5}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 6.76}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 28.4}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.63}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 24.93}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 3.77}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 2.37}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 32.81}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.63}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 22.31}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 77.44}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 39.12}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 3.93}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 3.92}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 52.47}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 52.45}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 22.32}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1892.22}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 30.65}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 11.53}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 48.37}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 212.63}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 15.75}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 6.56}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 14.01}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 53.55}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 4.98}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 243.97}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 53.82}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 9.97}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 6.57}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 65.81}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 280.69}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 91.88}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 918.75}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 191.63}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 8.8}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 1188.65}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 393.75}},
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