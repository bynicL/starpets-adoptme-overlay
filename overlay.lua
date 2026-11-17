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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 1010.63, ["Fly"] = 1126.46, ["Ride"] = 1050, ["Fly|Ride"] = 1025.07, ["Neon"] = 6561.91, ["Neon|Ride"] = 4926.38, ["Neon|Fly|Ride"] = 4221.26, ["Mega|Fly|Ride"] = 21174.57}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 393.75, ["Fly"] = 538.42, ["Ride"] = 478.59, ["Fly|Ride"] = 411.79, ["Neon|Fly|Ride"] = 2072.44, ["Mega"] = 9852.75, ["Mega|Fly|Ride"] = 8444.61}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 4593.75, ["Ride"] = 4723.69, ["Fly|Ride"] = 4749.94, ["Neon"] = 26034.72, ["Neon|Fly|Ride"] = 21464.07, ["Mega|Fly|Ride"] = 60238.5}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 141.75, ["Ride"] = 157.5, ["Fly|Ride"] = 281.93, ["Neon"] = 1406.13, ["Neon|Ride"] = 821.63, ["Neon|Fly|Ride"] = 985.92, ["Mega"] = 3520.35, ["Mega|Fly|Ride"] = 3124.77}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 525, ["Ride"] = 498.74, ["Fly|Ride"] = 523.69, ["Neon|Ride"] = 1849.38, ["Neon|Fly|Ride"] = 1443.75, ["Mega"] = 11138.77, ["Mega|Fly|Ride"] = 6331.36}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 10.4, ["Ride"] = 46.91, ["Fly|Ride"] = 141.49, ["Neon"] = 42.2, ["Neon|Ride"] = 140.61, ["Neon|Fly|Ride"] = 281.86, ["Mega"] = 262.5, ["Mega|Ride"] = 467.34, ["Mega|Fly|Ride"] = 414.75}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 5.16, ["Fly"] = 31.66, ["Ride"] = 25.98, ["Fly|Ride"] = 61.45, ["Neon"] = 23.21, ["Neon|Fly"] = 62.29, ["Neon|Ride"] = 49.23, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 111.57, ["Mega|Fly"] = 329.36, ["Mega|Ride"] = 149.63, ["Mega|Fly|Ride"] = 239.63}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 99.49, ["Fly"] = 112.97, ["Ride"] = 131.25, ["Fly|Ride"] = 265.04, ["Neon"] = 576.29, ["Neon|Ride"] = 418.02, ["Neon|Fly|Ride"] = 704.08, ["Mega"] = 1874.63, ["Mega|Fly|Ride"] = 1722.72}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 31.49, ["Fly"] = 157.4, ["Ride"] = 42, ["Fly|Ride"] = 78.56, ["Neon"] = 211.03, ["Neon|Ride"] = 190.02, ["Neon|Fly|Ride"] = 261.19, ["Mega"] = 2100, ["Mega|Ride"] = 1055.59, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 21.1, ["Fly"] = 74.76, ["Ride"] = 43.19, ["Fly|Ride"] = 63, ["Neon"] = 281.81, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 204.75, ["Mega|Ride"] = 612.25, ["Mega|Fly|Ride"] = 827}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 61.25, ["Ride"] = 68.25, ["Fly|Ride"] = 131.25, ["Neon"] = 262.5, ["Neon|Ride"] = 205.86, ["Neon|Fly|Ride"] = 194.78, ["Mega|Fly|Ride"] = 1210.13}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 74.82}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 393.75, ["Ride"] = 326.82, ["Fly|Ride"] = 302.09, ["Neon|Fly|Ride"] = 871.82, ["Mega|Fly|Ride"] = 5040.38}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 123.38, ["Fly"] = 175.88, ["Ride"] = 139.13, ["Fly|Ride"] = 150.93, ["Neon|Fly|Ride"] = 542.57, ["Mega|Fly|Ride"] = 3097.06}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 3.29, ["Ride"] = 33.79, ["Fly|Ride"] = 63.37, ["Neon"] = 18.37, ["Neon|Fly"] = 62.29, ["Neon|Ride"] = 70.74, ["Mega"] = 126, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 129.94, ["Fly"] = 183.7, ["Ride"] = 125.32, ["Fly|Ride"] = 146.6, ["Neon"] = 704, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 394.9, ["Mega|Fly|Ride"] = 1837.38}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.28, ["Fly"] = 23.23, ["Ride"] = 19.69, ["Fly|Ride"] = 45.94, ["Neon"] = 27.45, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 105, ["Mega"] = 262.5, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 23.63, ["Fly"] = 141.48, ["Ride"] = 43.52, ["Fly|Ride"] = 119.17, ["Neon"] = 130.51, ["Neon|Ride"] = 194.86, ["Neon|Fly|Ride"] = 312.46, ["Mega"] = 826.55, ["Mega|Ride"] = 756.96, ["Mega|Fly|Ride"] = 756}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 53.69}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 64.32, ["Ride"] = 118.13, ["Neon"] = 280.88, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 2362.5, ["Mega"] = 3097.06, ["Mega|Fly|Ride"] = 3124.77}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 18.38, ["Fly"] = 393.75, ["Ride"] = 32.71, ["Fly|Ride"] = 84.49, ["Neon"] = 154.07, ["Neon|Ride"] = 360.94, ["Neon|Fly|Ride"] = 268.13, ["Mega"] = 2694.78, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 1688.94}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 39.38, ["Fly"] = 69.69, ["Ride"] = 50.69, ["Fly|Ride"] = 91.88, ["Neon"] = 238.88, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 252.19, ["Mega"] = 1681.32, ["Mega|Fly|Ride"] = 940.8}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 52.8, ["Ride"] = 155.76, ["Fly|Ride"] = 139.39, ["Neon"] = 182.44, ["Neon|Ride"] = 223.12, ["Neon|Fly|Ride"] = 315.63, ["Mega"] = 1688.94, ["Mega|Ride"] = 1252.98, ["Mega|Fly|Ride"] = 1265.65}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 36, ["Ride"] = 50.7, ["Fly|Ride"] = 179.5, ["Neon"] = 172.06, ["Neon|Ride"] = 211.95, ["Neon|Fly|Ride"] = 168.91, ["Mega"] = 1207.92, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 985.92}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 43.32, ["Fly"] = 45.94, ["Ride"] = 78.15, ["Fly|Ride"] = 131.25, ["Neon"] = 233.27, ["Neon|Ride"] = 309.68, ["Neon|Fly|Ride"] = 468.66, ["Mega|Ride"] = 1028.14, ["Mega|Fly|Ride"] = 1237.16}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 6.33, ["Fly"] = 31.49, ["Ride"] = 21.13, ["Fly|Ride"] = 45.93, ["Neon"] = 31.49, ["Neon|Fly"] = 70.79, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 81.32, ["Mega"] = 127.32, ["Mega|Fly"] = 227.31, ["Mega|Ride"] = 139.08, ["Mega|Fly|Ride"] = 122.56}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 316.76, ["Fly"] = 294, ["Ride"] = 281.6, ["Fly|Ride"] = 362.25, ["Neon"] = 1050, ["Neon|Ride"] = 1477.82, ["Neon|Fly|Ride"] = 1666.88, ["Mega|Fly|Ride"] = 5936.7}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 14.01, ["Ride"] = 36.75, ["Fly|Ride"] = 137.52, ["Neon"] = 239.6, ["Mega"] = 830.75, ["Mega|Fly|Ride"] = 563.7}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 6.34, ["Fly"] = 38.03, ["Ride"] = 24.93, ["Fly|Ride"] = 53.82, ["Neon"] = 57.75, ["Neon|Fly"] = 92.89, ["Neon|Ride"] = 63.35, ["Neon|Fly|Ride"] = 104.99, ["Mega"] = 374.94, ["Mega|Fly|Ride"] = 371.44}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 100.16, ["Fly"] = 140.48, ["Ride"] = 112.97, ["Fly|Ride"] = 141.49, ["Neon"] = 394.75, ["Neon|Ride"] = 447.58, ["Neon|Fly|Ride"] = 446.25, ["Mega"] = 6208.52, ["Mega|Fly"] = 1466.91, ["Mega|Ride"] = 1474.02, ["Mega|Fly|Ride"] = 1376.49}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 15.74, ["Ride"] = 28.88, ["Fly|Ride"] = 59.04, ["Neon"] = 99.23, ["Neon|Ride"] = 141.47, ["Neon|Fly|Ride"] = 207.38, ["Mega"] = 702.99, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 627.03}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 187.69, ["Fly"] = 248.1, ["Ride"] = 280.87, ["Fly|Ride"] = 328.13, ["Neon"] = 761.25, ["Neon|Ride"] = 754.56, ["Neon|Fly|Ride"] = 773.07, ["Mega"] = 6333.47, ["Mega|Fly|Ride"] = 3124.77}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 44.29}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 5.16, ["Fly"] = 36.33, ["Ride"] = 27.57, ["Fly|Ride"] = 115.5, ["Neon"] = 21, ["Neon|Fly"] = 84.45, ["Neon|Ride"] = 58.98, ["Neon|Fly|Ride"] = 105.68, ["Mega"] = 131.25, ["Mega|Fly"] = 203.88, ["Mega|Ride"] = 168.91, ["Mega|Fly|Ride"] = 538.13}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 418.95, ["Ride"] = 430.52, ["Fly|Ride"] = 494.75, ["Neon"] = 4503.61, ["Neon|Ride"] = 3060.12, ["Neon|Fly|Ride"] = 3376.22, ["Mega"] = 12244.68, ["Mega|Ride"] = 52723.69, ["Mega|Fly|Ride"] = 12242.57}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 6.35, ["Fly"] = 39.87, ["Ride"] = 26.25, ["Fly|Ride"] = 90.81, ["Neon"] = 103.39, ["Neon|Ride"] = 139.86, ["Neon|Fly|Ride"] = 139.35, ["Mega"] = 511.88, ["Mega|Ride"] = 597.47, ["Mega|Fly|Ride"] = 535.2}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 60.54, ["Ride"] = 118.13, ["Fly|Ride"] = 228.38, ["Neon"] = 667.06, ["Neon|Ride"] = 563.7, ["Neon|Fly|Ride"] = 685.13, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 2322.91}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 32.82}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 19.63, ["Ride"] = 55.13, ["Fly|Ride"] = 140.69, ["Neon"] = 130.04, ["Neon|Ride"] = 141.47, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 563.7, ["Mega|Ride"] = 723.19}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.61}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 157.5, ["Fly"] = 168.93, ["Ride"] = 352.66, ["Fly|Ride"] = 354.06, ["Neon|Ride"] = 451.8, ["Neon|Fly|Ride"] = 633.35, ["Mega|Fly|Ride"] = 2214.61}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 59.59, ["Ride"] = 180.51, ["Fly|Ride"] = 194.82, ["Neon"] = 936.26, ["Neon|Ride"] = 420, ["Neon|Fly|Ride"] = 412.22, ["Mega"] = 1312.5, ["Mega|Ride"] = 1830.39, ["Mega|Fly|Ride"] = 963.82}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 61.69}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 60.38, ["Fly"] = 78.75, ["Ride"] = 64.3, ["Fly|Ride"] = 73.5, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 311.07, ["Mega"] = 4221.26, ["Mega|Fly|Ride"] = 998.96}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 7.03, ["Ride"] = 38.03, ["Fly|Ride"] = 159.45, ["Neon"] = 38.07, ["Neon|Ride"] = 141.47, ["Neon|Fly|Ride"] = 211.13, ["Mega"] = 141.56, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 263.91, ["Mega|Fly|Ride"] = 345.18}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 286.53, ["Fly"] = 393.75, ["Ride"] = 205.33, ["Fly|Ride"] = 406.27, ["Neon"] = 1348.88, ["Neon|Ride"] = 1548.54, ["Neon|Fly|Ride"] = 1245.14, ["Mega|Fly|Ride"] = 4533.72}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 70.75, ["Fly"] = 92.92, ["Ride"] = 78.75, ["Fly|Ride"] = 129.88, ["Neon"] = 354.38, ["Neon|Ride"] = 356.81, ["Neon|Fly|Ride"] = 262.5, ["Mega|Ride"] = 1886.33, ["Mega|Fly|Ride"] = 1797.67}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3520.79, ["Ride"] = 3732.38, ["Fly|Ride"] = 3017.43, ["Neon|Fly|Ride"] = 13721.44}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 39.38, ["Fly"] = 225.93, ["Ride"] = 43.32, ["Fly|Ride"] = 111.39, ["Neon|Ride"] = 229.69, ["Neon|Fly|Ride"] = 687.77, ["Mega"] = 1900.04, ["Mega|Ride"] = 1900.04, ["Mega|Fly|Ride"] = 2026.71}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 90.81, ["Ride"] = 56.99, ["Fly|Ride"] = 140.69, ["Neon"] = 401.08, ["Neon|Ride"] = 406.58, ["Neon|Fly|Ride"] = 563.7, ["Mega"] = 6333.47, ["Mega|Fly|Ride"] = 1565.44}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 40.69, ["Fly"] = 76.13, ["Ride"] = 62.99, ["Fly|Ride"] = 127.32, ["Neon"] = 131.25, ["Neon|Fly"] = 280.76, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 203.43, ["Mega"] = 2625, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 580.13}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 10.5}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 70.75, ["Ride"] = 65.63, ["Fly|Ride"] = 117.12, ["Neon"] = 353.59, ["Neon|Ride"] = 468.66, ["Neon|Fly|Ride"] = 501.41, ["Mega|Fly|Ride"] = 1718.81}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 41.97}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 200.97, ["Ride"] = 261.19, ["Fly|Ride"] = 337.88, ["Neon|Fly|Ride"] = 1464.1}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 761.25, ["Ride"] = 408.77, ["Fly|Ride"] = 761.25, ["Neon|Ride"] = 3236.41, ["Neon|Fly|Ride"] = 2559.38, ["Mega|Fly|Ride"] = 11812.5}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 3.93}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 18.73, ["Fly"] = 52.42, ["Ride"] = 51.19, ["Fly|Ride"] = 70.88, ["Neon"] = 183.75, ["Neon|Ride"] = 177.19, ["Neon|Fly|Ride"] = 204.75, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 658.51}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 11.82}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5139.75, ["Fly|Ride"] = 5145, ["Neon|Fly|Ride"] = 9495.94, ["Mega|Fly|Ride"] = 40534.08}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 6.91, ["Fly"] = 42.26, ["Ride"] = 27.57, ["Fly|Ride"] = 45.41, ["Neon"] = 91.84, ["Neon|Fly"] = 281.81, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 393.75, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 334.7}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 15.74, ["Fly"] = 94.39, ["Ride"] = 31.49, ["Fly|Ride"] = 116.07, ["Neon"] = 141.44, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 231, ["Mega"] = 844.48, ["Mega|Ride"] = 515.15, ["Mega|Fly|Ride"] = 657.64}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 84.42, ["Fly"] = 139.21, ["Ride"] = 94.5, ["Fly|Ride"] = 108.77, ["Neon"] = 1407.98, ["Neon|Fly|Ride"] = 420, ["Mega"] = 4222.31, ["Mega|Fly|Ride"] = 4363.76}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 7.88, ["Ride"] = 34.13, ["Fly|Ride"] = 139.65, ["Neon"] = 53.82, ["Neon|Ride"] = 76.02, ["Neon|Fly|Ride"] = 715.88, ["Mega"] = 502.47, ["Mega|Ride"] = 417.03, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 2126.25, ["Fly"] = 3097.45, ["Ride"] = 1903.13, ["Fly|Ride"] = 1968.74, ["Neon|Fly|Ride"] = 4020.18, ["Mega|Fly|Ride"] = 14119.41}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 34168.32, ["Ride"] = 35195.07, ["Fly|Ride"] = 23625, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 61687.5, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 197041}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 30.19, ["Fly"] = 393.75, ["Ride"] = 55.12, ["Fly|Ride"] = 90.81, ["Neon"] = 135.12, ["Neon|Ride"] = 178.38, ["Neon|Fly|Ride"] = 281.86, ["Mega"] = 393.75, ["Mega|Ride"] = 675.59, ["Mega|Fly|Ride"] = 698.25}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 2.63, ["Ride"] = 28.33, ["Fly|Ride"] = 63.37, ["Neon"] = 9.48, ["Neon|Fly"] = 130.08, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 111.32, ["Mega"] = 105, ["Mega|Ride"] = 194.51, ["Mega|Fly|Ride"] = 138.99}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 23.62}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 5.69, ["Ride"] = 38.07, ["Fly|Ride"] = 111.57, ["Neon"] = 67.57, ["Neon|Ride"] = 93.66, ["Neon|Fly|Ride"] = 463.32, ["Mega"] = 393.72, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 408.52}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 780.27, ["Ride"] = 656.25, ["Fly|Ride"] = 520.16, ["Neon"] = 2969.28, ["Neon|Ride"] = 2968.95, ["Neon|Fly|Ride"] = 2491.13, ["Mega|Fly|Ride"] = 10931.87}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 887.87, ["Fly"] = 1076.25, ["Ride"] = 781.12, ["Fly|Ride"] = 812.34, ["Neon|Fly|Ride"] = 3071.25, ["Mega|Fly|Ride"] = 11082.49}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 36.98, ["Fly"] = 117.23, ["Ride"] = 43.31, ["Fly|Ride"] = 126.71, ["Neon"] = 185.58, ["Neon|Ride"] = 225.91, ["Neon|Fly|Ride"] = 281.86, ["Mega|Fly|Ride"] = 736.8}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 31.47}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 78.07, ["Fly"] = 106.32, ["Ride"] = 73.48, ["Fly|Ride"] = 126, ["Neon"] = 468.72, ["Neon|Ride"] = 408.52, ["Neon|Fly|Ride"] = 412.13, ["Mega|Ride"] = 1687.88, ["Mega|Fly|Ride"] = 1598.63}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 67.71, ["Ride"] = 93.8, ["Fly|Ride"] = 183.73, ["Neon"] = 450.19, ["Neon|Ride"] = 518.22, ["Neon|Fly|Ride"] = 511.88, ["Mega"] = 2127.22, ["Mega|Fly|Ride"] = 2188.64}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 3.68, ["Fly"] = 32.78, ["Ride"] = 21.11, ["Fly|Ride"] = 52.03, ["Neon"] = 32.73, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 77.37, ["Neon|Fly|Ride"] = 105, ["Mega"] = 197.42, ["Mega|Ride"] = 281.86, ["Mega|Fly|Ride"] = 371.44}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 49.69, ["Fly"] = 89.25, ["Ride"] = 45.4, ["Fly|Ride"] = 90.8, ["Neon"] = 422.2, ["Neon|Ride"] = 362.25, ["Neon|Fly|Ride"] = 300.55, ["Mega|Fly|Ride"] = 982.94}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 3.49, ["Fly"] = 42.25, ["Ride"] = 36.75, ["Fly|Ride"] = 73.92, ["Neon"] = 26.25, ["Neon|Fly"] = 268.1, ["Neon|Ride"] = 104.47, ["Mega"] = 120.45, ["Mega|Fly"] = 985.92, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 392.44}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 15.75, ["Fly"] = 65.63, ["Ride"] = 31.8, ["Fly|Ride"] = 117.25, ["Neon"] = 133.01, ["Neon|Ride"] = 164.07, ["Neon|Fly|Ride"] = 196.34, ["Mega|Fly|Ride"] = 738.91}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 28.48, ["Ride"] = 44.63, ["Fly|Ride"] = 281.93, ["Neon"] = 179.23, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 704.08, ["Mega"] = 704.08, ["Mega|Ride"] = 2111.17, ["Mega|Fly|Ride"] = 703.29}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 16.22, ["Fly"] = 44.84, ["Ride"] = 42, ["Fly|Ride"] = 65.63, ["Neon"] = 103.69, ["Neon|Fly"] = 422.2, ["Neon|Ride"] = 100.29, ["Neon|Fly|Ride"] = 249.38, ["Mega|Ride"] = 942.43, ["Mega|Fly|Ride"] = 927.87}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6118.87, ["Ride"] = 5906.25, ["Fly|Ride"] = 4593.75, ["Neon"] = 30961.54, ["Neon|Fly|Ride"] = 24937.5}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 248.06, ["Fly"] = 253.11, ["Ride"] = 205.48, ["Fly|Ride"] = 280.88, ["Neon|Ride"] = 817.03, ["Neon|Fly|Ride"] = 524.99, ["Mega|Fly|Ride"] = 2510.18}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 31.49, ["Fly"] = 77.54, ["Ride"] = 59.07, ["Fly|Ride"] = 105, ["Neon"] = 73.5, ["Neon|Fly"] = 241.5, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 186.68, ["Mega"] = 285.72, ["Mega|Ride"] = 313.84, ["Mega|Fly|Ride"] = 413.44}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 3.41, ["Fly"] = 41.04, ["Ride"] = 26.17, ["Fly|Ride"] = 99.26, ["Neon"] = 14.2, ["Neon|Ride"] = 57.02, ["Mega"] = 170.63}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 18.93, ["Fly"] = 130.11, ["Ride"] = 37.84, ["Fly|Ride"] = 146.19, ["Neon"] = 114.19, ["Neon|Fly"] = 263.87, ["Neon|Ride"] = 164.07, ["Neon|Fly|Ride"] = 312.85, ["Mega"] = 449.7, ["Mega|Ride"] = 275.98, ["Mega|Fly|Ride"] = 531.25}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 18571.88, ["Ride"] = 17539.47, ["Fly|Ride"] = 12219.38, ["Neon|Fly|Ride"] = 23625, ["Mega|Fly|Ride"] = 105557.48}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 118.13, ["Ride"] = 108.76, ["Fly|Ride"] = 280.86, ["Neon"] = 842.26, ["Neon|Ride"] = 661.86, ["Neon|Fly|Ride"] = 937.32}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 42, ["Fly"] = 436.41, ["Ride"] = 44.63, ["Fly|Ride"] = 105, ["Neon|Fly"] = 468.72, ["Neon|Ride"] = 288.75, ["Neon|Fly|Ride"] = 288.75, ["Mega|Fly|Ride"] = 1779.72}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 8.95, ["Ride"] = 26.25, ["Fly|Ride"] = 52.41, ["Neon"] = 65.63, ["Neon|Ride"] = 78.73, ["Neon|Fly|Ride"] = 160.47, ["Mega"] = 479.25, ["Mega|Ride"] = 492.19, ["Mega|Fly|Ride"] = 395.85}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 367.49, ["Fly"] = 844.58, ["Ride"] = 283.92, ["Fly|Ride"] = 419.98, ["Neon"] = 1548.36, ["Neon|Ride"] = 1501.04, ["Neon|Fly|Ride"] = 1443.75, ["Mega"] = 5276.83, ["Mega|Fly|Ride"] = 4935}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 7.62, ["Ride"] = 31.5, ["Fly|Ride"] = 211.18, ["Neon"] = 27.57, ["Neon|Ride"] = 95.82, ["Neon|Fly|Ride"] = 238.58, ["Mega"] = 126.69, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 285.02}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 79.79, ["Fly"] = 210.1, ["Ride"] = 161.44, ["Fly|Ride"] = 119.63, ["Neon"] = 648.06, ["Neon|Ride"] = 424.82, ["Neon|Fly|Ride"] = 383.56, ["Mega"] = 2252.61, ["Mega|Ride"] = 3448.58, ["Mega|Fly|Ride"] = 1836.19}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 11.82, ["Fly"] = 22.31, ["Ride"] = 19.67, ["Fly|Ride"] = 39.29, ["Neon|Ride"] = 102.99, ["Neon|Fly|Ride"] = 75.78, ["Mega"] = 2533.39, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 10.58}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 48.23, ["Ride"] = 72.19, ["Fly|Ride"] = 525, ["Neon"] = 183.66, ["Neon|Fly"] = 1688.73, ["Neon|Ride"] = 358.92, ["Neon|Fly|Ride"] = 408.52, ["Mega"] = 1125.26, ["Mega|Ride"] = 1405.98, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 13.13, ["Fly"] = 99.25, ["Ride"] = 40.69, ["Fly|Ride"] = 93.19, ["Neon"] = 84.45, ["Neon|Ride"] = 106.32, ["Neon|Fly|Ride"] = 205.86, ["Mega"] = 475.02, ["Mega|Ride"] = 501.48, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 10.02}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 31.69, ["Fly"] = 210, ["Ride"] = 74.99, ["Fly|Ride"] = 91.88, ["Neon"] = 144.38, ["Neon|Ride"] = 187.91, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1548.54, ["Mega|Ride"] = 1562.98, ["Mega|Fly|Ride"] = 734.99}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.83, ["Ride"] = 32.74, ["Fly|Ride"] = 118.13, ["Neon"] = 19.17, ["Neon|Ride"] = 138.29, ["Neon|Fly|Ride"] = 281.86, ["Mega"] = 96.7, ["Mega|Ride"] = 337.8, ["Mega|Fly|Ride"] = 424.14}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 12.9, ["Fly"] = 42, ["Ride"] = 35.9, ["Fly|Ride"] = 91.88, ["Neon"] = 141.44, ["Neon|Ride"] = 112.49, ["Neon|Fly|Ride"] = 131.25, ["Mega|Fly|Ride"] = 805.88}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 393.75, ["Fly"] = 437.75, ["Ride"] = 301.88, ["Fly|Ride"] = 468.95, ["Neon|Fly"] = 1371.04, ["Neon|Fly|Ride"] = 1830.39, ["Mega|Fly|Ride"] = 8866.83}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 42, ["Ride"] = 70.45, ["Fly|Ride"] = 131.25, ["Neon"] = 215.07, ["Neon|Ride"] = 204.8, ["Neon|Fly|Ride"] = 211.13, ["Mega"] = 704.96, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 985.92}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 61.69, ["Fly"] = 84.48, ["Ride"] = 96.09, ["Fly|Ride"] = 126.71, ["Neon"] = 203.1, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 281.86, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 827.58}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 30.19, ["Fly"] = 96.12, ["Ride"] = 32.17, ["Fly|Ride"] = 107.61, ["Neon"] = 59.57, ["Neon|Ride"] = 90.79, ["Neon|Fly|Ride"] = 359.71, ["Mega"] = 307.18, ["Mega|Ride"] = 359.71, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 11251.35, ["Ride"] = 11254.39, ["Fly|Ride"] = 7767.64, ["Neon|Fly|Ride"] = 16478.44, ["Mega|Fly|Ride"] = 39372.9}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1706.25, ["Fly"] = 2578.45, ["Ride"] = 1706.25, ["Fly|Ride"] = 2029.13, ["Neon|Ride"] = 5623.87, ["Neon|Fly|Ride"] = 4364.07, ["Mega|Fly|Ride"] = 21525}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 378, ["Ride"] = 422.29, ["Fly|Ride"] = 393.75, ["Neon"] = 2110.91, ["Neon|Ride"] = 1674.51, ["Neon|Fly|Ride"] = 1425.04, ["Mega|Fly|Ride"] = 6474.91}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 14.15, ["Fly"] = 40.14, ["Ride"] = 20.08, ["Fly|Ride"] = 45.41, ["Neon"] = 65.63, ["Neon|Ride"] = 103.41, ["Neon|Fly|Ride"] = 105, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 7.05, ["Ride"] = 57.03, ["Fly|Ride"] = 111.57, ["Neon"] = 24.94, ["Neon|Ride"] = 48.55, ["Mega"] = 79.47, ["Mega|Ride"] = 231.99, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 34.81, ["Fly"] = 45.94, ["Ride"] = 45.94, ["Fly|Ride"] = 91.88, ["Neon|Ride"] = 141.47, ["Neon|Fly|Ride"] = 157.47, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.93, ["Fly"] = 31.5, ["Ride"] = 19.95, ["Fly|Ride"] = 39.38, ["Neon"] = 31.49, ["Neon|Fly"] = 281.81, ["Neon|Ride"] = 42.24, ["Neon|Fly|Ride"] = 66.94, ["Mega"] = 360.94, ["Mega|Ride"] = 277.62, ["Mega|Fly|Ride"] = 217.22}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 328.13, ["Fly"] = 320.24, ["Ride"] = 312.95, ["Fly|Ride"] = 360.77, ["Neon"] = 1688.73, ["Neon|Ride"] = 1337.42, ["Neon|Fly|Ride"] = 1378.6, ["Mega|Fly|Ride"] = 5053.05}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 27.41, ["Fly"] = 45.76, ["Ride"] = 38.03, ["Fly|Ride"] = 70.75, ["Neon"] = 183.66, ["Neon|Fly"] = 281.81, ["Neon|Ride"] = 147.79, ["Neon|Fly|Ride"] = 178.5, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 11.81, ["Fly"] = 28.25, ["Ride"] = 27.41, ["Fly|Ride"] = 42, ["Neon"] = 63.34, ["Neon|Fly"] = 126.67, ["Neon|Ride"] = 110.15, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 527.81, ["Mega|Ride"] = 581.64, ["Mega|Fly|Ride"] = 451.5}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 446.25, ["Fly"] = 787.5, ["Ride"] = 459.38, ["Fly|Ride"] = 429.74, ["Mega|Fly|Ride"] = 7036.47}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1100.93, ["Ride"] = 890.82, ["Fly|Ride"] = 924.93, ["Neon"] = 4939.51, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 17808.9}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 83.43, ["Fly"] = 109.8, ["Ride"] = 87.02, ["Fly|Ride"] = 111.57, ["Neon"] = 502.42, ["Neon|Ride"] = 414.75, ["Neon|Fly|Ride"] = 525, ["Mega|Fly|Ride"] = 1834.88}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 164.07, ["Fly"] = 200.82, ["Ride"] = 155.11, ["Fly|Ride"] = 224.44, ["Neon"] = 704, ["Neon|Ride"] = 629.5, ["Neon|Fly|Ride"] = 615.56, ["Mega|Ride"] = 2955.62, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 24.93, ["Ride"] = 32.82, ["Neon"] = 276.54, ["Neon|Fly"] = 422.2, ["Neon|Ride"] = 272.99, ["Neon|Fly|Ride"] = 262.5, ["Mega|Ride"] = 937.32, ["Mega|Fly|Ride"] = 860.01}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 149.94, ["Ride"] = 211.18, ["Fly|Ride"] = 597.19, ["Neon"] = 1548.36, ["Neon|Ride"] = 1337.42, ["Neon|Fly|Ride"] = 997.5, ["Mega|Fly|Ride"] = 3139.29}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 1837.4, ["Fly"] = 2111.42, ["Ride"] = 2295.12, ["Fly|Ride"] = 2067.34, ["Mega|Fly|Ride"] = 48556.46}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 46.91, ["Ride"] = 51.19, ["Fly|Ride"] = 196.88, ["Neon"] = 290.27, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 352.57, ["Mega"] = 2104.82, ["Mega|Ride"] = 2322.29, ["Mega|Fly|Ride"] = 1797.31}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 573.56, ["Fly"] = 675.94, ["Ride"] = 438.32, ["Fly|Ride"] = 640.49, ["Neon|Ride"] = 1266.57, ["Neon|Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 2795.63}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 49.61, ["Fly"] = 83.23, ["Ride"] = 64.32, ["Fly|Ride"] = 100.17, ["Neon"] = 268.1, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 312.85, ["Mega|Fly|Ride"] = 989.73}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.83, ["Fly"] = 28.52, ["Ride"] = 23.46, ["Fly|Ride"] = 39.38, ["Neon"] = 24.94, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 36.94, ["Neon|Fly|Ride"] = 74.82, ["Mega"] = 130.99, ["Mega|Fly"] = 349.41, ["Mega|Ride"] = 77.12, ["Mega|Fly|Ride"] = 133.88}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 53.82, ["Ride"] = 52.49, ["Fly|Ride"] = 105.59, ["Neon"] = 1407.98, ["Neon|Ride"] = 774.8, ["Neon|Fly|Ride"] = 312.85, ["Mega|Ride"] = 1408.15, ["Mega|Fly|Ride"] = 955.47}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 573.57, ["Fly"] = 625.87, ["Ride"] = 564.38, ["Fly|Ride"] = 614.25, ["Neon"] = 1971.59, ["Neon|Ride"] = 1771.88, ["Neon|Fly|Ride"] = 1968.75, ["Mega|Fly|Ride"] = 5250}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 283.7, ["Ride"] = 568.95, ["Fly|Ride"] = 719.82, ["Neon"] = 281312.47, ["Neon|Ride"] = 4068.75, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 8702.93}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 19.84, ["Fly"] = 42.16, ["Ride"] = 23.63, ["Fly|Ride"] = 42, ["Neon"] = 211.11, ["Neon|Ride"] = 112.49, ["Neon|Fly|Ride"] = 124.82, ["Mega|Fly|Ride"] = 625.21}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 10.5, ["Ride"] = 27.47, ["Fly|Ride"] = 78.15, ["Neon"] = 131.2, ["Neon|Ride"] = 78.12, ["Neon|Fly|Ride"] = 83.42, ["Mega"] = 1686.83, ["Mega|Ride"] = 439.78, ["Mega|Fly|Ride"] = 479.25}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 3.92, ["Ride"] = 31.67, ["Fly|Ride"] = 84.49, ["Neon"] = 17.07, ["Neon|Fly"] = 112.96, ["Neon|Ride"] = 45.93, ["Neon|Fly|Ride"] = 141.47, ["Mega"] = 117.25, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 261.79}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 39.35, ["Fly"] = 45.92, ["Ride"] = 43.32, ["Fly|Ride"] = 99.65, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 195.2, ["Mega|Fly|Ride"] = 792.65}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 32.17, ["Ride"] = 91.88, ["Fly|Ride"] = 211.18, ["Neon"] = 335.65, ["Neon|Ride"] = 345.18, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 1148.48, ["Mega|Ride"] = 1548.54, ["Mega|Fly|Ride"] = 1358.55}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 18.27, ["Fly"] = 57.14, ["Ride"] = 36.75, ["Fly|Ride"] = 78.15, ["Neon"] = 109.78, ["Neon|Ride"] = 93.14, ["Neon|Fly|Ride"] = 166.8, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 477.15}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 30.19, ["Fly"] = 99.25, ["Ride"] = 39.38, ["Fly|Ride"] = 74.82, ["Neon"] = 350.42, ["Neon|Ride"] = 196.18, ["Neon|Fly|Ride"] = 216.93, ["Mega"] = 2100, ["Mega|Ride"] = 1218.52, ["Mega|Fly|Ride"] = 1167.48}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.71, ["Fly"] = 31.49, ["Ride"] = 15.85, ["Fly|Ride"] = 42.25, ["Neon"] = 26.25, ["Neon|Ride"] = 40.15, ["Neon|Fly|Ride"] = 94.37, ["Mega"] = 177.19, ["Mega|Ride"] = 209.02, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 6.2, ["Fly"] = 57.03, ["Ride"] = 30.19, ["Fly|Ride"] = 1854.64, ["Neon"] = 28.87, ["Neon|Fly"] = 157.03, ["Neon|Ride"] = 41.19, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 196.34, ["Mega|Fly"] = 479.25, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 387.41}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 32.79, ["Fly"] = 60.38, ["Ride"] = 65.63, ["Fly|Ride"] = 78.56, ["Neon"] = 420.09, ["Neon|Fly"] = 266.01, ["Neon|Ride"] = 234.33, ["Neon|Fly|Ride"] = 221.53, ["Mega|Fly|Ride"] = 918.64}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1890, ["Fly"] = 3097.45, ["Ride"] = 1735.17, ["Fly|Ride"] = 1863.75, ["Neon|Fly|Ride"] = 4198.69, ["Mega|Fly|Ride"] = 14962.5}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 580.72, ["Fly"] = 666.17, ["Ride"] = 577.56, ["Fly|Ride"] = 558.65, ["Neon"] = 3125.12, ["Neon|Ride"] = 2512.29, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 8726.46}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 242.82, ["Fly"] = 337.84, ["Ride"] = 284.06, ["Fly|Ride"] = 354.63, ["Neon"] = 1321.44, ["Neon|Ride"] = 1425.04, ["Neon|Fly|Ride"] = 1548.54, ["Mega|Fly|Ride"] = 6193.07}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 43.3}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 36.98, ["Fly"] = 65.63, ["Ride"] = 56.3, ["Fly|Ride"] = 95.82, ["Neon"] = 337.76, ["Neon|Ride"] = 247.36, ["Neon|Fly|Ride"] = 316.68, ["Mega"] = 1160.09, ["Mega|Ride"] = 1548.54, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 33782.51, ["Fly"] = 23625, ["Ride"] = 34781.25, ["Fly|Ride"] = 15356.15, ["Neon|Fly|Ride"] = 36749.9, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 262.5, ["Fly"] = 192.91, ["Ride"] = 281.89, ["Fly|Ride"] = 385.85, ["Neon"] = 983.69, ["Neon|Fly"] = 1103.82, ["Neon|Ride"] = 645.74, ["Neon|Fly|Ride"] = 517.16, ["Mega"] = 3280.59, ["Mega|Ride"] = 6561.18, ["Mega|Fly|Ride"] = 2624.99}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 225.96, ["Fly"] = 525, ["Ride"] = 249.38, ["Fly|Ride"] = 154.88, ["Neon|Fly|Ride"] = 844.48, ["Mega|Fly|Ride"] = 4081.93}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 118.13, ["Fly"] = 157.07, ["Ride"] = 109.52, ["Fly|Ride"] = 200.82, ["Neon|Ride"] = 738.91, ["Neon|Fly|Ride"] = 518.31, ["Mega"] = 14075.06, ["Mega|Fly|Ride"] = 1506.31}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 17.07, ["Ride"] = 30.19, ["Fly|Ride"] = 98.44, ["Neon"] = 104.48, ["Neon|Ride"] = 135.19, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 1181.25, ["Mega|Fly|Ride"] = 563.7}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 3937.4, ["Ride"] = 4462.5, ["Fly|Ride"] = 3268.31, ["Neon|Fly|Ride"] = 17626.88, ["Mega|Fly|Ride"] = 70372.02}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 22.31, ["Fly"] = 45.94, ["Ride"] = 32.82, ["Fly|Ride"] = 56.44, ["Neon"] = 333.94, ["Neon|Ride"] = 202.69, ["Neon|Fly|Ride"] = 141.47, ["Mega|Fly|Ride"] = 633.29}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 44.61, ["Fly"] = 141.48, ["Ride"] = 48.57, ["Fly|Ride"] = 51.08, ["Neon"] = 234.38, ["Neon|Fly"] = 1407.98, ["Neon|Ride"] = 281.86, ["Neon|Fly|Ride"] = 288.24, ["Mega|Fly|Ride"] = 899.37}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 352.96, ["Ride"] = 363.49, ["Fly|Ride"] = 407.39, ["Neon"] = 1597.25, ["Neon|Ride"] = 882.93, ["Neon|Fly|Ride"] = 879.75, ["Mega"] = 4462.5, ["Mega|Fly|Ride"] = 4329.94}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 15.74, ["Fly"] = 23.66, ["Ride"] = 24.94, ["Fly|Ride"] = 44.63, ["Neon"] = 98.44, ["Neon|Ride"] = 105.57, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 704.08, ["Mega|Ride"] = 563.7, ["Mega|Fly|Ride"] = 485.63}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 15.86, ["Fly"] = 42.25, ["Ride"] = 70.74, ["Fly|Ride"] = 468.49, ["Neon"] = 62.29, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 134.08}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 78.54, ["Ride"] = 123.89, ["Fly|Ride"] = 141.49, ["Neon"] = 745.25, ["Neon|Ride"] = 635.82, ["Neon|Fly|Ride"] = 738.91, ["Mega|Ride"] = 2903.91, ["Mega|Fly|Ride"] = 2193.18}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 26.25, ["Ride"] = 57.03, ["Fly|Ride"] = 141.49, ["Neon"] = 90.57, ["Neon|Ride"] = 132.56, ["Neon|Fly|Ride"] = 187.47, ["Mega"] = 261.18, ["Mega|Fly"] = 708.75, ["Mega|Ride"] = 308.34, ["Mega|Fly|Ride"] = 227.79}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3189.38, ["Fly"] = 3905.06, ["Ride"] = 3279.94, ["Fly|Ride"] = 3215.63, ["Neon"] = 8400, ["Neon|Ride"] = 17944.79, ["Neon|Fly|Ride"] = 8491.88, ["Mega"] = 63334.49, ["Mega|Fly|Ride"] = 34468.88}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 31.68, ["Fly"] = 115.5, ["Ride"] = 141.48, ["Fly|Ride"] = 141.49, ["Neon"] = 168, ["Neon|Ride"] = 190.02, ["Neon|Fly|Ride"] = 365.25, ["Mega|Fly|Ride"] = 886.7}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 5906.25, ["Ride"] = 8438.52, ["Fly|Ride"] = 5985, ["Neon|Fly|Ride"] = 17062.5, ["Mega|Fly|Ride"] = 60518.24}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.56, ["Fly"] = 21, ["Ride"] = 20.08, ["Fly|Ride"] = 34.92, ["Neon"] = 21.13, ["Neon|Fly"] = 91.8, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 76.13, ["Mega"] = 164.07, ["Mega|Fly|Ride"] = 311.41}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 20.08, ["Fly"] = 35.44, ["Ride"] = 15.85, ["Fly|Ride"] = 69.19, ["Neon"] = 141.44, ["Neon|Ride"] = 559.37, ["Neon|Fly|Ride"] = 352.57, ["Mega|Fly|Ride"] = 927.94}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 2.63}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 15.1, ["Ride"] = 32.82, ["Fly|Ride"] = 126.52, ["Neon"] = 111.89, ["Neon|Ride"] = 127.24, ["Neon|Fly|Ride"] = 215.36, ["Mega|Ride"] = 983.81, ["Mega|Fly|Ride"] = 860.01}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 27.57, ["Fly"] = 84.48, ["Ride"] = 45.94, ["Fly|Ride"] = 141.49, ["Neon"] = 181.56, ["Neon|Ride"] = 181.57, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 840, ["Mega|Ride"] = 937.32, ["Mega|Fly|Ride"] = 931.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 16.9, ["Fly"] = 24.29, ["Ride"] = 21.13, ["Fly|Ride"] = 39.38, ["Neon"] = 141.61, ["Neon|Ride"] = 157.02, ["Neon|Fly|Ride"] = 136.5, ["Mega"] = 1127.37, ["Mega|Ride"] = 584.66, ["Mega|Fly|Ride"] = 673.71}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 7306.69}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 3018.75}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 23.63}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 295.62, ["Fly"] = 352.63, ["Ride"] = 324.12, ["Fly|Ride"] = 311.49}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 33.74, ["Fly"] = 133.04, ["Ride"] = 39.38, ["Fly|Ride"] = 105, ["Neon"] = 197.33, ["Neon|Ride"] = 412.13, ["Neon|Fly|Ride"] = 453.44, ["Mega|Ride"] = 937.32, ["Mega|Fly|Ride"] = 781.14}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 8.81}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 6.45, ["Neon|Ride"] = 84.47, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2468.19}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 119.84, ["Ride"] = 204.7, ["Fly|Ride"] = 420.24, ["Neon"] = 918.75, ["Neon|Ride"] = 612.25, ["Mega|Fly|Ride"] = 2482.73}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 141.38, ["Ride"] = 141.49, ["Fly|Ride"] = 281.93, ["Neon"] = 844.38, ["Neon|Ride"] = 704.08, ["Neon|Fly|Ride"] = 950.03, ["Mega"] = 3430.64, ["Mega|Fly|Ride"] = 3375.74}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 157.38, ["Ride"] = 180.7, ["Fly|Ride"] = 190.32, ["Neon"] = 799.32, ["Neon|Ride"] = 840, ["Neon|Fly|Ride"] = 507.56, ["Mega"] = 4644.55, ["Mega|Fly|Ride"] = 2937.38}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1050, ["Fly"] = 2533.71, ["Ride"] = 834.77, ["Fly|Ride"] = 704.68, ["Neon"] = 5347.97, ["Neon|Ride"] = 5623.87, ["Neon|Fly|Ride"] = 4593.75, ["Mega|Fly|Ride"] = 20054.88}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 17.37, ["Fly"] = 82.36, ["Ride"] = 39.38, ["Fly|Ride"] = 86.63, ["Neon"] = 141.44, ["Neon|Ride"] = 295.26, ["Neon|Fly|Ride"] = 437.07, ["Mega"] = 737.86, ["Mega|Fly|Ride"] = 844.48}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 654.94, ["Fly"] = 2100, ["Ride"] = 759.84, ["Fly|Ride"] = 844.68}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 90.57}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 11, ["Fly"] = 393.75, ["Ride"] = 40.09, ["Fly|Ride"] = 98.44, ["Neon"] = 85.32, ["Neon|Ride"] = 105.57, ["Neon|Fly|Ride"] = 156.19, ["Mega"] = 363.57, ["Mega|Ride"] = 446.25, ["Mega|Fly|Ride"] = 632.3}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 10.4, ["Fly"] = 32.82, ["Ride"] = 28.52, ["Fly|Ride"] = 94.5, ["Neon"] = 52.5, ["Neon|Ride"] = 83.61, ["Neon|Fly|Ride"] = 153.49, ["Mega"] = 420.13, ["Mega|Ride"] = 366.31, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 72.19}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 23.46, ["Ride"] = 36.74, ["Fly|Ride"] = 65.54, ["Neon"] = 177.19, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 547.18, ["Mega"] = 818.09, ["Mega|Fly|Ride"] = 704.08}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 28.52, ["Fly"] = 42.25, ["Ride"] = 46.47, ["Fly|Ride"] = 52.5, ["Neon"] = 238.55, ["Neon|Fly"] = 243.74, ["Neon|Ride"] = 141.47, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 985.92, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 5223.75, ["Fly"] = 11261.2, ["Ride"] = 6261.09, ["Fly|Ride"] = 4725, ["Neon|Fly|Ride"] = 10498.69, ["Mega|Fly|Ride"] = 37758}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 11.63, ["Fly"] = 28.52, ["Ride"] = 39.38, ["Fly|Ride"] = 99.22, ["Neon"] = 79.48, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 141.47, ["Mega"] = 524.91, ["Mega|Ride"] = 422.04, ["Mega|Fly|Ride"] = 408.33}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 28.85}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 113, ["Fly"] = 373.73, ["Ride"] = 138.01, ["Fly|Ride"] = 164.73, ["Neon"] = 418.69, ["Neon|Ride"] = 483, ["Neon|Fly|Ride"] = 615.41, ["Mega|Ride"] = 4222.31, ["Mega|Fly|Ride"] = 1924.33}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 77.44, ["Ride"] = 105, ["Fly|Ride"] = 190.07, ["Neon"] = 327.6, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 346.5, ["Mega|Ride"] = 1501.04, ["Mega|Fly|Ride"] = 1505.26}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 24.94, ["Fly"] = 70.74, ["Ride"] = 31.68, ["Fly|Ride"] = 57.03, ["Neon"] = 105.56, ["Neon|Ride"] = 125.99, ["Neon|Fly|Ride"] = 159.13, ["Mega|Fly|Ride"] = 656.22}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 4.72, ["Fly"] = 49.26, ["Ride"] = 42, ["Fly|Ride"] = 99.74, ["Neon"] = 24.86, ["Neon|Fly"] = 183.66, ["Neon|Ride"] = 41.99, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 78.42, ["Mega|Fly"] = 7034.11, ["Mega|Ride"] = 143.07, ["Mega|Fly|Ride"] = 244.13}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 13.01, ["Fly"] = 52.41, ["Ride"] = 31.61, ["Fly|Ride"] = 90.57, ["Neon"] = 70.73, ["Neon|Ride"] = 99.24, ["Neon|Fly|Ride"] = 211.13, ["Mega"] = 349.41, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 492.97}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 19.58, ["Fly"] = 31.68, ["Ride"] = 26.25, ["Fly|Ride"] = 48.59, ["Neon"] = 208.69, ["Neon|Ride"] = 141.75, ["Neon|Fly|Ride"] = 111.57, ["Mega|Fly|Ride"] = 637.88}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 195.14}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 19.02, ["Ride"] = 110.22, ["Neon"] = 129.94, ["Neon|Ride"] = 422.25, ["Mega"] = 966.93, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 1391.27}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 126.71, ["Ride"] = 443.63, ["Fly|Ride"] = 337.88, ["Neon|Ride"] = 820.32, ["Neon|Fly|Ride"] = 763.2}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 48.59, ["Fly"] = 211.99, ["Ride"] = 81.92, ["Fly|Ride"] = 241.89, ["Neon"] = 311.49, ["Neon|Ride"] = 469.35, ["Neon|Fly|Ride"] = 479.25, ["Mega"] = 1183.88, ["Mega|Ride"] = 1097.81, ["Mega|Fly|Ride"] = 564.74}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 706.13, ["Fly"] = 780.94, ["Ride"] = 515.57, ["Fly|Ride"] = 727.13, ["Neon|Ride"] = 2231.25, ["Neon|Fly|Ride"] = 1213.52, ["Mega|Ride"] = 7916.83, ["Mega|Fly|Ride"] = 6429.94}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 262.5, ["Ride"] = 330.75, ["Fly|Ride"] = 383.25, ["Neon"] = 1159.95, ["Neon|Ride"] = 1050, ["Neon|Fly|Ride"] = 1345.32, ["Mega"] = 4221.26, ["Mega|Fly|Ride"] = 4644.55}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 82.69}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 13.13, ["Fly"] = 21.13, ["Ride"] = 24.81, ["Fly|Ride"] = 42.25, ["Neon"] = 77.95, ["Neon|Fly"] = 230.99, ["Neon|Ride"] = 97.5, ["Neon|Fly|Ride"] = 127.32, ["Mega"] = 405.87, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 182.27, ["Fly"] = 458.67, ["Ride"] = 205.05, ["Fly|Ride"] = 433.23, ["Neon"] = 1266.56, ["Neon|Ride"] = 786.19, ["Neon|Fly|Ride"] = 1041.6, ["Mega"] = 4222.31, ["Mega|Fly|Ride"] = 3375.74}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 17.07}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 122.49, ["Fly"] = 590.63, ["Ride"] = 140.74, ["Fly|Ride"] = 123.89, ["Neon"] = 508.78, ["Neon|Fly"] = 1407.98, ["Neon|Ride"] = 321.46, ["Neon|Fly|Ride"] = 567.27, ["Mega"] = 9430.53, ["Mega|Ride"] = 1991.79, ["Mega|Fly|Ride"] = 1004.01}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 147, ["Ride"] = 165.38, ["Fly|Ride"] = 141.49, ["Neon"] = 844.38, ["Neon|Ride"] = 753.69, ["Neon|Fly|Ride"] = 1013.37}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 6.57, ["Ride"] = 35.9, ["Fly|Ride"] = 141.49, ["Neon"] = 39.38, ["Neon|Ride"] = 65.47, ["Neon|Fly|Ride"] = 168.91, ["Mega"] = 222.7, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 392.68}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 17.48, ["Fly"] = 49.88, ["Ride"] = 33.8, ["Fly|Ride"] = 52.5, ["Neon"] = 134.06, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 239.63, ["Mega|Ride"] = 695.64, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 21, ["Fly"] = 126.7, ["Ride"] = 45.94, ["Fly|Ride"] = 117.25, ["Neon"] = 156.19, ["Neon|Ride"] = 127.32, ["Neon|Fly|Ride"] = 211.13, ["Mega"] = 466.57, ["Mega|Ride"] = 468.66, ["Mega|Fly|Ride"] = 570.02}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 6.34, ["Fly"] = 337.84, ["Ride"] = 39.38, ["Fly|Ride"] = 140.62, ["Neon"] = 23.47, ["Neon|Fly"] = 65.45, ["Neon|Ride"] = 63.37, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 108.68, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 218.5, ["Fly"] = 918.75, ["Ride"] = 271.42, ["Fly|Ride"] = 370.61, ["Neon|Ride"] = 1214.07, ["Neon|Fly|Ride"] = 1336.37, ["Mega|Fly|Ride"] = 4359.54}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 48.61, ["Fly"] = 168.83, ["Ride"] = 70, ["Fly|Ride"] = 131.07, ["Neon"] = 338.43, ["Neon|Ride"] = 459.37, ["Neon|Fly|Ride"] = 296.88, ["Mega"] = 1792.88, ["Mega|Ride"] = 1928.07, ["Mega|Fly|Ride"] = 1569.75}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 64.32, ["Fly"] = 126.7, ["Ride"] = 94.58, ["Fly|Ride"] = 131.24, ["Neon|Ride"] = 365.25, ["Neon|Fly|Ride"] = 460.69, ["Mega|Fly|Ride"] = 1515.94}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 15.85, ["Ride"] = 57.03, ["Fly|Ride"] = 281.93, ["Neon|Ride"] = 595.21, ["Neon|Fly|Ride"] = 491.91, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 21.13, ["Fly"] = 75.62, ["Ride"] = 56.44, ["Fly|Ride"] = 84, ["Neon"] = 76.01, ["Neon|Ride"] = 117.18, ["Neon|Fly|Ride"] = 187.59, ["Mega"] = 468.66, ["Mega|Fly"] = 525, ["Mega|Ride"] = 538.36, ["Mega|Fly|Ride"] = 444.94}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.29, ["Fly"] = 27.57, ["Ride"] = 27.44, ["Fly|Ride"] = 39.38, ["Neon"] = 17.07, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 92.93, ["Mega|Ride"] = 95.31, ["Mega|Fly|Ride"] = 144.03}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 918.75, ["Fly"] = 1125.63, ["Ride"] = 912.19, ["Fly|Ride"] = 985.68, ["Neon"] = 5468.65, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2382.19, ["Mega|Fly|Ride"] = 8400}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 204.85, ["Ride"] = 319.65, ["Fly|Ride"] = 359.45, ["Neon"] = 1700.34, ["Neon|Ride"] = 1405.98, ["Neon|Fly|Ride"] = 1312.5, ["Mega"] = 10555.76, ["Mega|Fly|Ride"] = 5048.84}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 91.88, ["Fly"] = 118.13, ["Ride"] = 109.83, ["Fly|Ride"] = 194.25, ["Neon"] = 386.31, ["Neon|Ride"] = 401.13, ["Neon|Fly|Ride"] = 372.75, ["Mega|Ride"] = 1830.39, ["Mega|Fly|Ride"] = 1604.49}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 242.82, ["Ride"] = 206.16, ["Fly|Ride"] = 214.47, ["Neon|Ride"] = 1062.7, ["Neon|Fly|Ride"] = 1036.88, ["Mega"] = 10555.76, ["Mega|Fly|Ride"] = 3937.5}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 17.59, ["Fly"] = 52.5, ["Ride"] = 35, ["Fly|Ride"] = 75.26, ["Neon"] = 157.49, ["Neon|Ride"] = 135.13, ["Neon|Fly|Ride"] = 230.13, ["Mega|Ride"] = 781.5, ["Mega|Fly|Ride"] = 618.87}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 373.63, ["Ride"] = 254.63, ["Fly|Ride"] = 493.1, ["Neon"] = 1584.98, ["Neon|Ride"] = 1957.06, ["Neon|Fly|Ride"] = 1688.94, ["Mega"] = 5250, ["Mega|Fly|Ride"] = 6052.68}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 105.59, ["Fly"] = 126, ["Ride"] = 141.48, ["Fly|Ride"] = 140.69, ["Neon"] = 422.2, ["Neon|Ride"] = 486.25, ["Neon|Fly|Ride"] = 633.35, ["Mega|Fly|Ride"] = 1397.82}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1307.25, ["Ride"] = 1050, ["Fly|Ride"] = 1199.3, ["Neon|Ride"] = 4433.43, ["Neon|Fly|Ride"] = 4331.25, ["Mega"] = 50667.61, ["Mega|Fly|Ride"] = 24630.8}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 13.13, ["Fly"] = 45.94, ["Ride"] = 39.38, ["Fly|Ride"] = 86.63, ["Neon"] = 50.72, ["Neon|Fly"] = 154.11, ["Neon|Ride"] = 82.69, ["Neon|Fly|Ride"] = 156.85, ["Mega"] = 176.28, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 203.67}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 70.75, ["Ride"] = 83.97, ["Fly|Ride"] = 204.01, ["Neon"] = 264.93, ["Neon|Ride"] = 316.32, ["Neon|Fly|Ride"] = 295.32, ["Mega|Ride"] = 1126.32, ["Mega|Fly|Ride"] = 983.81}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 78.75, ["Fly"] = 84, ["Ride"] = 78.75, ["Fly|Ride"] = 83.45, ["Neon|Ride"] = 358.32, ["Neon|Fly|Ride"] = 378, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 2814.87, ["Ride"] = 983.07, ["Fly|Ride"] = 825.09, ["Neon|Fly|Ride"] = 3942.59, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 468.49, ["Ride"] = 446.25, ["Fly|Ride"] = 525, ["Neon|Ride"] = 1830.39, ["Neon|Fly|Ride"] = 1982.38, ["Mega|Fly|Ride"] = 14059.65}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 105, ["Fly"] = 312.95, ["Ride"] = 141.39, ["Fly|Ride"] = 234.94, ["Neon"] = 496.84, ["Neon|Ride"] = 456.75, ["Neon|Fly|Ride"] = 690.36, ["Mega"] = 4011.2, ["Mega|Ride"] = 1706.25, ["Mega|Fly|Ride"] = 2033.06}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 11.44, ["Fly"] = 39.38, ["Ride"] = 25.35, ["Fly|Ride"] = 79.52, ["Neon"] = 73.89, ["Neon|Ride"] = 70.74, ["Neon|Fly|Ride"] = 168.91, ["Mega"] = 761.25, ["Mega|Ride"] = 508.59, ["Mega|Fly|Ride"] = 985.92}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 49.65, ["Fly"] = 70.74, ["Ride"] = 48.57, ["Fly|Ride"] = 65.63, ["Neon"] = 250.78, ["Neon|Fly"] = 408.48, ["Neon|Ride"] = 210.79, ["Neon|Fly|Ride"] = 280.81, ["Mega"] = 1830.39, ["Mega|Fly|Ride"] = 1049.99}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 588.52, ["Ride"] = 797.16, ["Fly|Ride"] = 837.73, ["Neon|Ride"] = 2828.44, ["Neon|Fly|Ride"] = 2999.4, ["Mega|Fly|Ride"] = 12138.07}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 774.38}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 4823.44, ["Ride"] = 4608.09, ["Fly|Ride"] = 3551.12, ["Neon|Ride"] = 30253.85, ["Neon|Fly|Ride"] = 21632.97, ["Mega|Fly|Ride"] = 90076.43}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 156.26, ["Fly"] = 169.62, ["Ride"] = 157.11, ["Fly|Ride"] = 408.62, ["Neon"] = 918.75, ["Neon|Ride"] = 903.35, ["Neon|Fly|Ride"] = 918.75, ["Mega"] = 5911.23, ["Mega|Fly|Ride"] = 5630.45}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 63.15, ["Fly"] = 281.89, ["Ride"] = 77.44, ["Fly|Ride"] = 336, ["Neon"] = 441, ["Neon|Ride"] = 469.75, ["Neon|Fly|Ride"] = 985.92, ["Mega|Fly|Ride"] = 2743.44}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 15.74, ["Fly"] = 126.62, ["Ride"] = 32.82, ["Fly|Ride"] = 91.88, ["Neon"] = 141.44, ["Neon|Ride"] = 112.96, ["Neon|Fly|Ride"] = 175.88, ["Mega"] = 420.13, ["Mega|Ride"] = 526.75, ["Mega|Fly|Ride"] = 498.25}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 18.35, ["Fly"] = 30.27, ["Ride"] = 22.31, ["Fly|Ride"] = 45.94, ["Neon|Fly"] = 281.81, ["Neon|Ride"] = 312.85, ["Neon|Fly|Ride"] = 177.18, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 787.47}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 15.65, ["Ride"] = 45.68, ["Fly|Ride"] = 91.14, ["Neon"] = 134.08, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 231, ["Mega|Ride"] = 859.69, ["Mega|Fly|Ride"] = 841.05}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 5.24, ["Fly"] = 57.03, ["Ride"] = 22.32, ["Fly|Ride"] = 63.3, ["Neon"] = 17.59, ["Neon|Fly"] = 348.31, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 134.08, ["Mega|Ride"] = 312.85, ["Mega|Fly|Ride"] = 357}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 26.25, ["Ride"] = 62.3, ["Fly|Ride"] = 167.89, ["Neon"] = 147.82, ["Neon|Fly"] = 844.38, ["Neon|Ride"] = 246.84, ["Neon|Fly|Ride"] = 232.32, ["Mega"] = 675.59, ["Mega|Ride"] = 719.4, ["Mega|Fly|Ride"] = 814.92}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 263.08, ["Fly"] = 331.31, ["Ride"] = 249.67, ["Fly|Ride"] = 299.73, ["Neon"] = 708.75, ["Neon|Fly"] = 802.15, ["Neon|Ride"] = 977.82, ["Neon|Fly|Ride"] = 703.18, ["Mega"] = 6562.5, ["Mega|Fly|Ride"] = 4222.31}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 3.78, ["Fly"] = 16.9, ["Ride"] = 15.85, ["Fly|Ride"] = 35.49, ["Neon"] = 22.31, ["Neon|Ride"] = 31.48, ["Neon|Fly|Ride"] = 57.02, ["Mega"] = 840.25, ["Mega|Ride"] = 743.14, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 42.25, ["Fly"] = 70.74, ["Ride"] = 69.69, ["Fly|Ride"] = 118.13, ["Neon"] = 111.08, ["Neon|Fly"] = 288.75, ["Neon|Ride"] = 98.34, ["Neon|Fly|Ride"] = 134.27, ["Mega"] = 560.44, ["Mega|Ride"] = 547.3, ["Mega|Fly|Ride"] = 675.59}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 748.13, ["Fly"] = 880.47, ["Ride"] = 769.13, ["Fly|Ride"] = 761.24, ["Neon|Ride"] = 1575, ["Neon|Fly|Ride"] = 1443.74, ["Mega|Fly|Ride"] = 4003.13}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 31.17, ["Fly"] = 156.26, ["Ride"] = 40.68, ["Fly|Ride"] = 65.63, ["Neon"] = 158.09, ["Neon|Fly"] = 468.72, ["Neon|Ride"] = 127.32, ["Neon|Fly|Ride"] = 173.87, ["Mega"] = 1575, ["Mega|Ride"] = 1126.32, ["Mega|Fly|Ride"] = 844.07}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 320.25, ["Fly"] = 316.41, ["Ride"] = 237.57, ["Fly|Ride"] = 317.63, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 4504.16}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 68.3, ["Fly"] = 141.48, ["Ride"] = 124.69, ["Fly|Ride"] = 137.81, ["Neon"] = 563.62, ["Neon|Fly"] = 612.18, ["Neon|Ride"] = 625.68, ["Neon|Fly|Ride"] = 524.85, ["Mega"] = 2955.62, ["Mega|Fly|Ride"] = 2209.05}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 492.7, ["Ride"] = 570.93, ["Fly|Ride"] = 510.67, ["Neon"] = 2518.31, ["Neon|Fly|Ride"] = 2413.06, ["Mega"] = 7916.83, ["Mega|Fly|Ride"] = 6561.19}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 21.61, ["Ride"] = 52.5, ["Fly|Ride"] = 99.26, ["Neon"] = 78.21, ["Neon|Fly"] = 281.24, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 211.13, ["Mega"] = 291.33, ["Mega|Ride"] = 510.91, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 3018.75, ["Fly"] = 3977.82, ["Ride"] = 3936.19, ["Fly|Ride"] = 3084.16, ["Neon|Fly|Ride"] = 6300, ["Mega|Fly|Ride"] = 23745.75}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 85.29, ["Fly"] = 117.23, ["Ride"] = 78.75, ["Fly|Ride"] = 135.73, ["Neon"] = 370.49, ["Neon|Ride"] = 446.25, ["Neon|Fly|Ride"] = 404.25, ["Mega"] = 1830.39, ["Mega|Fly|Ride"] = 1688.94}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 3.42, ["Fly"] = 21, ["Ride"] = 22.23, ["Fly|Ride"] = 57.03, ["Neon"] = 19.69, ["Neon|Fly"] = 42.24, ["Neon|Ride"] = 31.69, ["Neon|Fly|Ride"] = 79.2, ["Mega"] = 104.95, ["Mega|Fly"] = 452.82, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.41, ["Ride"] = 28.88, ["Fly|Ride"] = 157.11, ["Neon"] = 21.13, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 62.99, ["Neon|Fly|Ride"] = 84.47, ["Mega"] = 144.38, ["Mega|Ride"] = 179.82, ["Mega|Fly|Ride"] = 278.2}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 59.83, ["Fly"] = 65.47, ["Ride"] = 40.69, ["Fly|Ride"] = 59.07, ["Neon|Ride"] = 253.36, ["Neon|Fly|Ride"] = 380.02, ["Mega|Fly|Ride"] = 1317.37}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 917.44, ["Fly"] = 1302.76, ["Ride"] = 997.5, ["Fly|Ride"] = 1232.44, ["Neon"] = 5038.71, ["Neon|Fly|Ride"] = 5348.62, ["Mega|Fly|Ride"] = 26917.17}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 4644.61, ["Ride"] = 3937.5, ["Fly|Ride"] = 4721.69, ["Neon|Fly|Ride"] = 17062.5}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 19.69, ["Fly"] = 26.25, ["Ride"] = 27.27, ["Fly|Ride"] = 48.56, ["Neon"] = 105, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 133.07, ["Mega"] = 2362.5, ["Mega|Fly|Ride"] = 623.09}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 23.24, ["Fly"] = 32.82, ["Ride"] = 40.11, ["Fly|Ride"] = 92.85, ["Neon"] = 141.44, ["Neon|Ride"] = 105.57, ["Neon|Fly|Ride"] = 175.24, ["Mega"] = 922.09, ["Mega|Ride"] = 538.97, ["Mega|Fly|Ride"] = 484.08}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 30.22, ["Fly"] = 157.5, ["Ride"] = 54.48, ["Fly|Ride"] = 64.32, ["Neon|Ride"] = 273.3, ["Neon|Fly|Ride"] = 178.53, ["Mega|Ride"] = 1156.93, ["Mega|Fly|Ride"] = 868.88}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 170.63, ["Ride"] = 229.69, ["Fly|Ride"] = 236.25, ["Neon|Ride"] = 976.5, ["Neon|Fly|Ride"] = 1125.26, ["Mega"] = 11091.91, ["Mega|Ride"] = 3271.25, ["Mega|Fly|Ride"] = 3517.06}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 6.34, ["Ride"] = 32.82, ["Fly|Ride"] = 105, ["Neon"] = 27.41, ["Neon|Fly"] = 70.95, ["Neon|Ride"] = 92.42, ["Neon|Fly|Ride"] = 211.13, ["Mega"] = 103.69, ["Mega|Ride"] = 198.19, ["Mega|Fly|Ride"] = 358.92}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 180.64, ["Fly"] = 267.23, ["Ride"] = 168.25, ["Fly|Ride"] = 234.53, ["Neon"] = 796.11, ["Neon|Ride"] = 744.19, ["Neon|Fly|Ride"] = 545.48, ["Mega|Fly|Ride"] = 3331.4}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 2.52, ["Fly"] = 24.12, ["Ride"] = 19.02, ["Fly|Ride"] = 42.24, ["Neon"] = 23.21, ["Neon|Fly"] = 121.79, ["Neon|Ride"] = 28.52, ["Neon|Fly|Ride"] = 105, ["Mega"] = 468.66, ["Mega|Ride"] = 422.25, ["Mega|Fly|Ride"] = 736.8}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 248.14, ["Fly"] = 272.39, ["Ride"] = 225.96, ["Fly|Ride"] = 260.28, ["Neon|Ride"] = 944.75, ["Neon|Fly|Ride"] = 937.37, ["Mega"] = 10555.76, ["Mega|Ride"] = 5630.45, ["Mega|Fly|Ride"] = 4221.26}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 15.65, ["Fly"] = 422.29, ["Ride"] = 26.17, ["Fly|Ride"] = 84.48, ["Neon"] = 48.57, ["Neon|Fly"] = 297.65, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 156.23, ["Mega"] = 465.29, ["Mega|Ride"] = 563.7, ["Mega|Fly|Ride"] = 352.57}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 5.25, ["Ride"] = 28.52, ["Neon"] = 14.44, ["Neon|Fly"] = 66.94, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 90.69, ["Mega"] = 73.48, ["Mega|Fly"] = 422.25, ["Mega|Ride"] = 91.77, ["Mega|Fly|Ride"] = 209.25}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.52, ["Neon"] = 3.92, ["Mega"] = 15.54, ["Mega|Ride"] = 155.7}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 2.47, ["Ride"] = 35.86, ["Fly|Ride"] = 141.94, ["Neon"] = 11.61, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 36.37, ["Mega|Fly"] = 156219.1, ["Mega|Ride"] = 78.43, ["Mega|Fly|Ride"] = 213.24}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 65.63, ["Fly"] = 139.37, ["Ride"] = 106.32, ["Fly|Ride"] = 209.08, ["Neon"] = 262.5, ["Neon|Ride"] = 331.47, ["Neon|Fly|Ride"] = 242.79, ["Mega|Fly|Ride"] = 1239.26}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 28.52, ["Ride"] = 18.27, ["Fly|Ride"] = 41.14, ["Neon"] = 4.13, ["Neon|Ride"] = 21.15, ["Neon|Fly|Ride"] = 112.96, ["Mega"] = 86.63, ["Mega|Ride"] = 98.34, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 10.5, ["Ride"] = 91.49, ["Neon"] = 87.94, ["Neon|Ride"] = 315, ["Mega"] = 420, ["Mega|Fly|Ride"] = 581.64}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.56, ["Neon|Ride"] = 41.91, ["Neon|Fly|Ride"] = 278.25, ["Mega"] = 15.85, ["Mega|Ride"] = 45.94, ["Mega|Fly|Ride"] = 141.47}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 21.09, ["Ride"] = 18, ["Fly|Ride"] = 31.86, ["Neon"] = 2.1, ["Neon|Fly"] = 16.9, ["Neon|Ride"] = 15.83, ["Neon|Fly|Ride"] = 35.23, ["Mega"] = 15.47, ["Mega|Fly"] = 27.57, ["Mega|Ride"] = 22.32, ["Mega|Fly|Ride"] = 56.44}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Ride"] = 15.85, ["Fly|Ride"] = 34.04, ["Neon"] = 3.94, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 20.9, ["Neon|Fly|Ride"] = 28.38, ["Mega"] = 40.69, ["Mega|Ride"] = 53.85, ["Mega|Fly|Ride"] = 105.57}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Ride"] = 27.2, ["Fly|Ride"] = 125.73, ["Neon"] = 2.37, ["Neon|Ride"] = 58.59, ["Mega"] = 14.44, ["Mega|Ride"] = 121.12, ["Mega|Fly|Ride"] = 253.36}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.63, ["Fly"] = 42.15, ["Ride"] = 38.03, ["Fly|Ride"] = 107.52, ["Neon"] = 3.98, ["Neon|Fly"] = 135.03, ["Neon|Ride"] = 70.71, ["Neon|Fly|Ride"] = 81.64, ["Mega"] = 28.32, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 91.41, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 3.49, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 99.24, ["Mega"] = 19.69, ["Mega|Ride"] = 95.82}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 2.55, ["Fly"] = 47.16, ["Ride"] = 25.78, ["Fly|Ride"] = 63.37, ["Neon"] = 6.13, ["Neon|Fly"] = 35.52, ["Neon|Ride"] = 15.84, ["Neon|Fly|Ride"] = 63.35, ["Mega"] = 48.72, ["Mega|Fly"] = 139.35, ["Mega|Ride"] = 43.42, ["Mega|Fly|Ride"] = 124.59}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 21.12, ["Neon"] = 2.1, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 312.85, ["Mega"] = 15.74, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.36, ["Ride"] = 52.5, ["Fly|Ride"] = 525, ["Neon"] = 21.92, ["Mega"] = 141.47, ["Mega|Fly"] = 314.99, ["Mega|Ride"] = 281.86}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 3.24, ["Ride"] = 42.25, ["Neon"] = 16.89, ["Mega"] = 139.12}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 70.75, ["Neon"] = 6.14, ["Neon|Ride"] = 37.7, ["Neon|Fly|Ride"] = 76.02, ["Mega"] = 24.94, ["Mega|Ride"] = 174.59, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 30.45, ["Ride"] = 18.4, ["Fly|Ride"] = 30.19, ["Neon"] = 2.1, ["Neon|Fly"] = 27.2, ["Neon|Ride"] = 15.85, ["Neon|Fly|Ride"] = 41.88, ["Mega"] = 15.75, ["Mega|Fly"] = 53.81, ["Mega|Ride"] = 22.78, ["Mega|Fly|Ride"] = 46.36}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.1, ["Fly"] = 72.19, ["Ride"] = 26.25, ["Neon"] = 31.39, ["Neon|Ride"] = 39.38, ["Mega"] = 253.36, ["Mega|Ride"] = 352.57, ["Mega|Fly|Ride"] = 688.25}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 39.9, ["Fly|Ride"] = 78.73, ["Neon"] = 6.24, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 117.17, ["Mega"] = 58.59, ["Mega|Ride"] = 141.47, ["Mega|Fly|Ride"] = 179.24}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 6.56, ["Neon"] = 11.43, ["Neon|Fly|Ride"] = 141.47, ["Mega"] = 85.32, ["Mega|Ride"] = 233.63}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 3.93, ["Fly"] = 31.7, ["Ride"] = 32.71, ["Fly|Ride"] = 192.18, ["Neon"] = 10.56, ["Neon|Fly"] = 46.89, ["Neon|Ride"] = 31.68, ["Neon|Fly|Ride"] = 126.69, ["Mega"] = 210, ["Mega|Ride"] = 85.3, ["Mega|Fly|Ride"] = 281.86}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 39.19, ["Ride"] = 14.11, ["Fly|Ride"] = 39.38, ["Neon"] = 2.1, ["Neon|Fly"] = 20.79, ["Neon|Ride"] = 15.1, ["Neon|Fly|Ride"] = 28.48, ["Mega"] = 18.11, ["Mega|Fly"] = 40.13, ["Mega|Ride"] = 22.32, ["Mega|Fly|Ride"] = 55.12}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 3.36, ["Fly"] = 23.94, ["Ride"] = 19.65, ["Fly|Ride"] = 79.59, ["Neon"] = 12.68, ["Neon|Ride"] = 112.49, ["Neon|Fly|Ride"] = 74.96, ["Mega"] = 128.63, ["Mega|Ride"] = 211.13, ["Mega|Fly|Ride"] = 266.02}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 2.1, ["Fly"] = 41.91, ["Fly|Ride"] = 141.39, ["Neon"] = 77.23, ["Neon|Ride"] = 124.58, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 139.06, ["Mega|Ride"] = 276.94, ["Mega|Fly|Ride"] = 385.23}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 22.28, ["Ride"] = 15.26, ["Fly|Ride"] = 35.9, ["Neon"] = 2.1, ["Neon|Fly"] = 16.9, ["Neon|Ride"] = 15.85, ["Neon|Fly|Ride"] = 52.79, ["Mega"] = 43.32, ["Mega|Fly"] = 156.19, ["Mega|Ride"] = 57.75, ["Mega|Fly|Ride"] = 98.18}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.52, ["Fly"] = 176.32, ["Neon"] = 8.87, ["Neon|Fly"] = 77.53, ["Neon|Ride"] = 36.74, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 40.85, ["Mega|Fly"] = 563.7, ["Mega|Ride"] = 103.69}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.63, ["Ride"] = 28.49, ["Neon"] = 8.43, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 157.29, ["Neon|Fly|Ride"] = 312.85, ["Mega"] = 45.94, ["Mega|Ride"] = 101.95, ["Mega|Fly|Ride"] = 224.44}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 15.85, ["Ride"] = 15.85, ["Neon"] = 2.1, ["Neon|Fly"] = 40.69, ["Neon|Ride"] = 28.52, ["Neon|Fly|Ride"] = 3150, ["Mega"] = 15.7, ["Mega|Ride"] = 63.35, ["Mega|Fly|Ride"] = 117.18}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 88.7, ["Ride"] = 17.05, ["Fly|Ride"] = 59.07, ["Neon"] = 4.25, ["Neon|Fly"] = 46.45, ["Neon|Ride"] = 21.13, ["Neon|Fly|Ride"] = 101.33, ["Mega"] = 220.28, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 269.18}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 31.39, ["Neon"] = 13.13, ["Neon|Fly"] = 57.02, ["Neon|Ride"] = 70.7, ["Mega"] = 59.07}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 32.34, ["Ride"] = 15.63, ["Fly|Ride"] = 124.69, ["Neon"] = 7.4, ["Neon|Fly"] = 70.73, ["Neon|Ride"] = 19.48, ["Neon|Fly|Ride"] = 78.1, ["Mega"] = 49.63, ["Mega|Fly"] = 126.69, ["Mega|Ride"] = 90.46, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 2.1, ["Ride"] = 82.6, ["Neon"] = 87.84, ["Mega|Fly|Ride"] = 844.06}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Ride"] = 15.75, ["Fly|Ride"] = 5392.74, ["Neon"] = 15.27, ["Neon|Fly"] = 59.12, ["Neon|Ride"] = 31.75, ["Neon|Fly|Ride"] = 112.77, ["Mega"] = 144.38, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.47, ["Fly"] = 16.65, ["Ride"] = 29.64, ["Fly|Ride"] = 84.49, ["Neon"] = 23.35, ["Neon|Fly"] = 99.23, ["Neon|Ride"] = 35.9, ["Neon|Fly|Ride"] = 84.62, ["Mega|Ride"] = 203.26, ["Mega|Fly|Ride"] = 194.23}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 79.47, ["Fly|Ride"] = 105.52, ["Neon"] = 33.17, ["Neon|Ride"] = 93.75, ["Mega"] = 146.74, ["Mega|Ride"] = 488.75}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 11.46, ["Ride"] = 131.25, ["Neon"] = 99.23, ["Mega"] = 556.5, ["Mega|Fly|Ride"] = 794.07}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 2.77, ["Ride"] = 38.03, ["Fly|Ride"] = 70.75, ["Neon"] = 42.24, ["Neon|Ride"] = 105, ["Mega"] = 253.36, ["Mega|Ride"] = 367.5}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 8.44, ["Ride"] = 33.76, ["Neon"] = 42, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 99.24, ["Neon|Fly|Ride"] = 141.47, ["Mega"] = 189, ["Mega|Ride"] = 250.67, ["Mega|Fly|Ride"] = 358.92}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.24, ["Neon"] = 2.37, ["Neon|Ride"] = 126.69, ["Mega"] = 21.11, ["Mega|Ride"] = 139.13, ["Mega|Fly|Ride"] = 148.29}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 41.14}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 10.28, ["Fly"] = 26.25, ["Ride"] = 24.94, ["Fly|Ride"] = 66.94, ["Neon"] = 36.75, ["Neon|Ride"] = 40.68, ["Neon|Fly|Ride"] = 106.32, ["Mega"] = 262.5, ["Mega|Ride"] = 324.08, ["Mega|Fly|Ride"] = 822.3}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 18.25, ["Fly|Ride"] = 70.75, ["Neon"] = 3.68, ["Neon|Ride"] = 23.55, ["Neon|Fly|Ride"] = 422.25, ["Mega"] = 33.75, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.56, ["Ride"] = 45.34, ["Fly|Ride"] = 391.58, ["Neon"] = 5.44, ["Neon|Ride"] = 30.18, ["Neon|Fly|Ride"] = 93.75, ["Mega"] = 36.75, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 19.59, ["Fly|Ride"] = 78.15, ["Neon"] = 14.81, ["Neon|Ride"] = 21.13, ["Neon|Fly|Ride"] = 87.28, ["Mega"] = 133.76, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 312.85}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 3.42, ["Ride"] = 31.67, ["Neon"] = 78.12, ["Neon|Ride"] = 125.39, ["Neon|Fly|Ride"] = 157.31, ["Mega"] = 623.44, ["Mega|Fly|Ride"] = 412.75}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Neon"] = 3.46, ["Neon|Ride"] = 51.57, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 9.19, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 51.1, ["Mega|Fly|Ride"] = 141.1}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 16.91, ["Fly|Ride"] = 56.99, ["Neon"] = 4.47, ["Neon|Fly"] = 68.83, ["Neon|Ride"] = 28.52, ["Neon|Fly|Ride"] = 47.25, ["Mega"] = 32.82, ["Mega|Fly"] = 187.47, ["Mega|Ride"] = 57.17, ["Mega|Fly|Ride"] = 147.73}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 28.52, ["Ride"] = 17.07, ["Fly|Ride"] = 48.59, ["Neon"] = 7.86, ["Neon|Fly"] = 70.73, ["Neon|Ride"] = 23.37, ["Neon|Fly|Ride"] = 57.02, ["Mega"] = 190.02, ["Mega|Fly"] = 107.63, ["Mega|Ride"] = 112.96, ["Mega|Fly|Ride"] = 140.61}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 210, ["Ride"] = 20.96, ["Fly|Ride"] = 45.94, ["Neon"] = 3.78, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 82.03, ["Mega"] = 25.14, ["Mega|Ride"] = 30.27, ["Mega|Fly|Ride"] = 102.62}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 4.82, ["Neon|Ride"] = 38.06, ["Neon|Fly|Ride"] = 150905.72, ["Mega"] = 31.49, ["Mega|Fly"] = 104.9, ["Mega|Ride"] = 84.5, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 26.36, ["Ride"] = 19.85, ["Fly|Ride"] = 77.37, ["Neon"] = 7.71, ["Neon|Fly"] = 31.66, ["Neon|Ride"] = 28.52, ["Neon|Fly|Ride"] = 66.85, ["Mega"] = 28.04, ["Mega|Ride"] = 51.19, ["Mega|Fly|Ride"] = 133.59}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Mega"] = 18.38, ["Mega|Ride"] = 235.94}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.63, ["Neon"] = 3.92, ["Neon|Ride"] = 157.02, ["Neon|Fly|Ride"] = 281.86, ["Mega"] = 30.17, ["Mega|Fly"] = 117.17}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 19.69, ["Neon"] = 6.43, ["Neon|Fly"] = 71.8, ["Neon|Ride"] = 22.28, ["Neon|Fly|Ride"] = 87.94, ["Mega"] = 61.69, ["Mega|Ride"] = 60.21, ["Mega|Fly|Ride"] = 131.08}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 6.24, ["Ride"] = 59.07, ["Neon"] = 125.62, ["Neon|Ride"] = 259.88, ["Mega"] = 402.29, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 633.35}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.61, ["Fly"] = 6562.49, ["Ride"] = 68.16, ["Neon"] = 78.12, ["Mega"] = 146.74, ["Mega|Ride"] = 315}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 3.72, ["Ride"] = 31.4, ["Fly|Ride"] = 45.94, ["Neon"] = 28.5, ["Neon|Ride"] = 64.32, ["Mega"] = 119.3, ["Mega|Fly|Ride"] = 338.63}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 15.54, ["Fly|Ride"] = 21, ["Neon"] = 2.1, ["Neon|Fly"] = 19.59, ["Neon|Ride"] = 14.34, ["Neon|Fly|Ride"] = 31.4, ["Mega"] = 18.38, ["Mega|Fly"] = 24.94, ["Mega|Ride"] = 25.33, ["Mega|Fly|Ride"] = 56.43}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Ride"] = 55.13, ["Neon"] = 32.42, ["Neon|Fly"] = 141.44, ["Neon|Ride"] = 31.64, ["Neon|Fly|Ride"] = 105, ["Mega"] = 45.93, ["Mega|Ride"] = 141.47, ["Mega|Fly|Ride"] = 179.47}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 31.66, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 70.79, ["Mega"] = 18.38, ["Mega|Fly"] = 78.44, ["Mega|Ride"] = 101.07, ["Mega|Fly|Ride"] = 103.56}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Fly"] = 60.9, ["Mega"] = 19.69, ["Mega|Fly|Ride"] = 209.79}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.63, ["Ride"] = 18.38, ["Fly|Ride"] = 63.32, ["Neon"] = 16.96, ["Neon|Fly"] = 40.85, ["Neon|Ride"] = 31.21, ["Neon|Fly|Ride"] = 105.5, ["Mega"] = 143.21, ["Mega|Ride"] = 193.87, ["Mega|Fly|Ride"] = 176.79}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 174.57, ["Ride"] = 252, ["Fly|Ride"] = 316.76, ["Neon"] = 1266.56, ["Neon|Ride"] = 1050, ["Neon|Fly|Ride"] = 918.75, ["Mega"] = 8444.61, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Neon"] = 9.19, ["Neon|Fly"] = 57.23, ["Neon|Ride"] = 68.25, ["Mega"] = 65.42, ["Mega|Ride"] = 177.36, ["Mega|Fly|Ride"] = 556.31}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 3.78, ["Fly"] = 103.68, ["Ride"] = 24.3, ["Neon"] = 59.07, ["Neon|Ride"] = 168.91, ["Neon|Fly|Ride"] = 147.79, ["Mega"] = 603.75, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 625.68}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 844.58, ["Ride"] = 13.71, ["Fly|Ride"] = 49.64, ["Neon"] = 5.25, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 63.28, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 134.08}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 24.94, ["Fly|Ride"] = 120.89, ["Neon"] = 11.82, ["Neon|Fly"] = 42.24, ["Neon|Ride"] = 53.82, ["Mega"] = 117.18, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 210.08}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 6.13, ["Fly"] = 23.24, ["Ride"] = 18.38, ["Fly|Ride"] = 31.5, ["Neon"] = 6.57, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 205.86, ["Mega|Ride"] = 267.78, ["Mega|Fly|Ride"] = 197.42}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 3.92, ["Fly|Ride"] = 246.75, ["Neon"] = 73.5, ["Neon|Ride"] = 90.57, ["Neon|Fly|Ride"] = 627.03, ["Mega"] = 183.75, ["Mega|Fly|Ride"] = 380.02}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.63, ["Fly"] = 21.13, ["Ride"] = 19, ["Fly|Ride"] = 39.38, ["Neon"] = 21.21, ["Neon|Fly"] = 78.12, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 68.25, ["Mega|Fly"] = 328.13, ["Mega|Ride"] = 281.51, ["Mega|Fly|Ride"] = 113.38}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 70.65, ["Fly"] = 103.48, ["Ride"] = 97.15, ["Fly|Ride"] = 141.49, ["Neon"] = 422.35, ["Neon|Fly"] = 345.85, ["Neon|Ride"] = 312.37, ["Neon|Fly|Ride"] = 210.55, ["Mega|Fly|Ride"] = 1509.38}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 157.1, ["Fly"] = 322.17, ["Ride"] = 240.19, ["Fly|Ride"] = 234.48, ["Neon|Ride"] = 2638.95, ["Neon|Fly|Ride"] = 1098.46, ["Mega"] = 10555.76, ["Mega|Fly|Ride"] = 10549.43}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 59.07, ["Fly"] = 117.23, ["Ride"] = 85.32, ["Fly|Ride"] = 101.38, ["Neon"] = 422.2, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 327.24, ["Mega|Fly|Ride"] = 798.92}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 11.71, ["Ride"] = 26.24, ["Fly|Ride"] = 84.49, ["Neon"] = 35.17, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 143.57, ["Mega"] = 196.88, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 422.25}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 10.38, ["Fly"] = 68.14, ["Ride"] = 33.79, ["Fly|Ride"] = 78.75, ["Neon"] = 79.25, ["Neon|Ride"] = 141.47, ["Neon|Fly|Ride"] = 197.42, ["Mega"] = 486.25, ["Mega|Ride"] = 331.47, ["Mega|Fly|Ride"] = 672.54}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 25.36, ["Fly|Ride"] = 55.32, ["Neon"] = 7.05, ["Neon|Fly"] = 115.5, ["Neon|Ride"] = 21.13, ["Neon|Fly|Ride"] = 83.16, ["Mega"] = 64.31, ["Mega|Fly"] = 85.32, ["Mega|Ride"] = 100.29, ["Mega|Fly|Ride"] = 211.04}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 7.6, ["Fly"] = 68.49, ["Ride"] = 27.57, ["Fly|Ride"] = 105, ["Neon"] = 41.18, ["Neon|Ride"] = 69.06, ["Neon|Fly|Ride"] = 134.93, ["Mega"] = 703.03, ["Mega|Ride"] = 497.44, ["Mega|Fly|Ride"] = 422.25}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 28.25, ["Ride"] = 19.03, ["Fly|Ride"] = 45.41, ["Neon"] = 19.03, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 28.5, ["Neon|Fly|Ride"] = 97.13, ["Mega"] = 131.25, ["Mega|Ride"] = 141.47, ["Mega|Fly|Ride"] = 175.88}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 2.6, ["Ride"] = 28.52, ["Fly|Ride"] = 328.13, ["Neon"] = 17.07, ["Neon|Ride"] = 56.95, ["Neon|Fly|Ride"] = 157.02, ["Mega"] = 207.37, ["Mega|Ride"] = 168.91, ["Mega|Fly|Ride"] = 240.51}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 28.52, ["Neon"] = 2.1, ["Neon|Ride"] = 23.24, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 15.75, ["Mega|Ride"] = 40.13, ["Mega|Fly|Ride"] = 197.42}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 45.93, ["Ride"] = 20.89, ["Fly|Ride"] = 55.12, ["Neon"] = 13.1, ["Neon|Fly"] = 70.73, ["Neon|Ride"] = 57.02, ["Neon|Fly|Ride"] = 69.57, ["Mega"] = 108.81, ["Mega|Ride"] = 114.83, ["Mega|Fly|Ride"] = 191.94}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 3.94, ["Ride"] = 17.07, ["Fly|Ride"] = 57.03, ["Neon"] = 63.19, ["Neon|Fly"] = 141.44, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 63, ["Mega"] = 268.13, ["Mega|Ride"] = 206.07, ["Mega|Fly|Ride"] = 271.69}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 81.34, ["Fly"] = 211.15, ["Ride"] = 100.79, ["Fly|Ride"] = 231, ["Neon"] = 591.07, ["Neon|Fly"] = 669.17, ["Neon|Ride"] = 498.73, ["Neon|Fly|Ride"] = 595.83, ["Mega|Fly|Ride"] = 1929.38}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 3.82, ["Ride"] = 30.19, ["Fly|Ride"] = 197.46, ["Neon"] = 78.75, ["Neon|Ride"] = 112.96, ["Neon|Fly|Ride"] = 152.25, ["Mega"] = 414.75, ["Mega|Ride"] = 394.8, ["Mega|Fly|Ride"] = 504.42}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.63, ["Fly"] = 31.66, ["Ride"] = 21, ["Fly|Ride"] = 50.74, ["Neon"] = 25.36, ["Neon|Ride"] = 38.03, ["Neon|Fly|Ride"] = 105.42, ["Mega"] = 183.68, ["Mega|Ride"] = 282.93, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 28.88, ["Fly"] = 59.07, ["Ride"] = 85.31, ["Fly|Ride"] = 178.5, ["Neon"] = 83.4, ["Neon|Ride"] = 126.69, ["Neon|Fly|Ride"] = 294.54, ["Mega"] = 464.47, ["Mega|Ride"] = 563.7, ["Mega|Fly|Ride"] = 585.25}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 4.19}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 3.94, ["Ride"] = 25.52, ["Neon"] = 92.89, ["Neon|Ride"] = 46.89, ["Neon|Fly|Ride"] = 633.35, ["Mega"] = 315, ["Mega|Ride"] = 422.25, ["Mega|Fly|Ride"] = 547.86}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 24.39, ["Fly"] = 35.9, ["Ride"] = 33.8, ["Fly|Ride"] = 45.93, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 124.68, ["Neon|Fly|Ride"] = 158.34, ["Mega"] = 2111.17, ["Mega|Fly|Ride"] = 581.64}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Fly"] = 31.68, ["Ride"] = 19.69, ["Neon"] = 3.93, ["Neon|Ride"] = 28.48, ["Neon|Fly|Ride"] = 157.02, ["Mega"] = 34, ["Mega|Ride"] = 90.79, ["Mega|Fly|Ride"] = 158.82}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 5.07, ["Fly"] = 28.09, ["Ride"] = 20.69, ["Fly|Ride"] = 78.15, ["Neon"] = 39.38, ["Neon|Ride"] = 234.33, ["Mega"] = 265.79, ["Mega|Fly"] = 391.35, ["Mega|Ride"] = 179.47, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 15.85, ["Fly|Ride"] = 78.02, ["Neon"] = 23.41, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 22.31, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 118.13, ["Mega|Ride"] = 123.99, ["Mega|Fly|Ride"] = 251.98}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 32.74, ["Neon"] = 3.89, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 195.68, ["Mega"] = 23.23, ["Mega|Ride"] = 62.97, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 31.49, ["Ride"] = 80.16, ["Fly|Ride"] = 281.93, ["Neon"] = 213, ["Neon|Ride"] = 280.81, ["Mega"] = 834.75, ["Mega|Ride"] = 754.69, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 5.25, ["Ride"] = 48.59, ["Fly|Ride"] = 210, ["Neon"] = 46.45, ["Neon|Ride"] = 78.12, ["Neon|Fly|Ride"] = 211.13, ["Mega|Ride"] = 391.63, ["Mega|Fly|Ride"] = 704.08}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 7.58, ["Fly"] = 56.44, ["Ride"] = 52.8, ["Fly|Ride"] = 104.99, ["Neon"] = 70.26, ["Neon|Fly"] = 211.04, ["Neon|Ride"] = 70.68, ["Neon|Fly|Ride"] = 281.44, ["Mega"] = 377.99, ["Mega|Ride"] = 313.85, ["Mega|Fly|Ride"] = 453.44}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 67.59, ["Fly"] = 137.25, ["Ride"] = 103.69, ["Fly|Ride"] = 211.18, ["Neon"] = 426.57, ["Neon|Ride"] = 468.66, ["Mega|Ride"] = 1968.75, ["Mega|Fly|Ride"] = 3042.95}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 25.6, ["Ride"] = 84.34, ["Fly|Ride"] = 141.49, ["Neon"] = 124.69, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 400.32, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 467.25}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 72.17, ["Ride"] = 116.82, ["Fly|Ride"] = 200.16, ["Neon"] = 203.44, ["Neon|Ride"] = 297.94, ["Neon|Fly|Ride"] = 336.1, ["Mega"] = 985.92, ["Mega|Ride"] = 964.82, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 53.81, ["Ride"] = 99.18, ["Fly|Ride"] = 162.75, ["Neon"] = 98.44, ["Neon|Ride"] = 123.9, ["Neon|Fly|Ride"] = 243.86, ["Mega"] = 438.21, ["Mega|Ride"] = 323.54, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 3.78, ["Fly"] = 69.5, ["Ride"] = 25.35, ["Neon"] = 78.75, ["Neon|Ride"] = 194.24, ["Neon|Fly|Ride"] = 126.69, ["Mega"] = 332.76, ["Mega|Ride"] = 1055.59, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 20.78, ["Ride"] = 82.69, ["Fly|Ride"] = 211.18, ["Neon"] = 103.69, ["Neon|Ride"] = 211.13, ["Neon|Fly|Ride"] = 507.94, ["Mega"] = 380.02, ["Mega|Ride"] = 312.96, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 15.85, ["Ride"] = 48.51, ["Fly|Ride"] = 139.02, ["Neon"] = 31.66, ["Neon|Fly"] = 70.73, ["Neon|Ride"] = 126.69, ["Mega"] = 277.62, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 70.7, ["Mega"] = 15.75, ["Mega|Fly"] = 141.47, ["Mega|Ride"] = 70.74, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 2.1, ["Ride"] = 209.6, ["Neon"] = 19.69, ["Neon|Ride"] = 83.83, ["Mega"] = 111.57, ["Mega|Ride"] = 157.02, ["Mega|Fly|Ride"] = 312.5}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 3.93, ["Neon"] = 22.32, ["Neon|Ride"] = 103.69, ["Mega"] = 280.81}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 20.9, ["Ride"] = 31.44, ["Fly|Ride"] = 116.07, ["Neon"] = 27.57, ["Neon|Ride"] = 82.95, ["Neon|Fly|Ride"] = 281.86, ["Mega"] = 123.38, ["Mega|Ride"] = 152.97, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 472.5, ["Fly"] = 633.44, ["Ride"] = 511.86, ["Fly|Ride"] = 602.44, ["Neon"] = 2623.86, ["Neon|Ride"] = 1788.17, ["Neon|Fly|Ride"] = 1574.9, ["Mega|Fly|Ride"] = 4593.75}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 5.25, ["Fly"] = 26.25, ["Ride"] = 25.15, ["Fly|Ride"] = 63.32, ["Neon"] = 35.89, ["Neon|Ride"] = 78.07, ["Neon|Fly|Ride"] = 210, ["Mega"] = 211.13, ["Mega|Ride"] = 283.5}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 5.8, ["Fly"] = 21.12, ["Ride"] = 25.35, ["Fly|Ride"] = 84.49, ["Neon"] = 69.67, ["Neon|Fly"] = 315, ["Neon|Ride"] = 64.32, ["Mega"] = 367.36, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 633.35}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 2.92, ["Fly"] = 28.52, ["Ride"] = 22.29, ["Fly|Ride"] = 113, ["Neon|Ride"] = 157.02, ["Mega"] = 223.13, ["Mega|Ride"] = 354.38, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 30.5, ["Fly|Ride"] = 157.11, ["Neon"] = 11.7, ["Neon|Fly"] = 70.73, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 108.94, ["Mega"] = 82.69, ["Mega|Ride"] = 117.18, ["Mega|Fly|Ride"] = 209.02}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 70.74, ["Ride"] = 17.07, ["Neon"] = 3.83, ["Neon|Fly"] = 46.89, ["Neon|Ride"] = 49.63, ["Neon|Fly|Ride"] = 117.17, ["Mega"] = 21.13, ["Mega|Fly|Ride"] = 211.13}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 997.49}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 5.93, ["Fly"] = 42.25, ["Ride"] = 30.18, ["Neon"] = 36.93, ["Neon|Fly"] = 141.44, ["Neon|Ride"] = 99.24, ["Mega"] = 506.69, ["Mega|Ride"] = 811.53, ["Mega|Fly|Ride"] = 1054.53}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.63, ["Ride"] = 38.07, ["Neon"] = 7.88, ["Neon|Ride"] = 42.24, ["Mega"] = 63.28, ["Mega|Ride"] = 141.47, ["Mega|Fly|Ride"] = 234.33}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.1, ["Fly"] = 42.25, ["Ride"] = 42, ["Fly|Ride"] = 525, ["Neon"] = 11.36, ["Neon|Ride"] = 70.74, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 164.07, ["Mega|Ride"] = 154.88, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 221.13, ["Ride"] = 446.25, ["Fly|Ride"] = 300.62, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1525.39, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 7.23, ["Fly"] = 196.88, ["Ride"] = 72.19, ["Neon"] = 26.25, ["Neon|Ride"] = 131.25, ["Mega"] = 422.82, ["Mega|Fly"] = 316.68, ["Mega|Ride"] = 400.08}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Neon"] = 4.35, ["Neon|Ride"] = 48.51, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 35.43, ["Mega|Fly"] = 189, ["Mega|Ride"] = 62.99, ["Mega|Fly|Ride"] = 157.02}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 3.29, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 268.13, ["Mega"] = 10.41, ["Mega|Ride"] = 148.81, ["Mega|Fly|Ride"] = 192.94}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 9.48, ["Fly"] = 79.2, ["Ride"] = 36.98, ["Fly|Ride"] = 141.49, ["Neon"] = 65.63, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 312.46, ["Mega"] = 328.13, ["Mega|Ride"] = 563.7, ["Mega|Fly|Ride"] = 372.75}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 7.48, ["Ride"] = 141.48, ["Neon"] = 91.84, ["Neon|Ride"] = 704.08, ["Neon|Fly|Ride"] = 125.39, ["Mega"] = 625.68, ["Mega|Ride"] = 561.29, ["Mega|Fly|Ride"] = 1126.32}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 4.24, ["Fly|Ride"] = 99.16, ["Neon"] = 141.91, ["Neon|Ride"] = 210.08, ["Mega"] = 582.75, ["Mega|Ride"] = 413.8, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 12.48, ["Ride"] = 43.32, ["Neon"] = 115.48, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 781.5, ["Mega"] = 656.13, ["Mega|Ride"] = 563.7, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 362.93, ["Ride"] = 341.25, ["Fly|Ride"] = 445.51, ["Neon"] = 1407.98, ["Neon|Ride"] = 1122.09, ["Neon|Fly|Ride"] = 1262.48, ["Mega|Ride"] = 3373.63, ["Mega|Fly|Ride"] = 3148.68}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 4.03, ["Fly"] = 28.3, ["Ride"] = 28.52, ["Fly|Ride"] = 59.07, ["Neon"] = 59.07, ["Neon|Ride"] = 130.07, ["Neon|Fly|Ride"] = 181.49, ["Mega"] = 529.78, ["Mega|Ride"] = 523.04, ["Mega|Fly|Ride"] = 540.47}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 5.77, ["Ride"] = 33.39, ["Fly|Ride"] = 105, ["Neon"] = 31.66, ["Mega"] = 281.86}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 14.44, ["Ride"] = 48.27, ["Fly|Ride"] = 141.49, ["Neon"] = 39.38, ["Neon|Ride"] = 64.31, ["Neon|Fly|Ride"] = 183.68, ["Mega"] = 185.16, ["Mega|Ride"] = 201.9, ["Mega|Fly|Ride"] = 318.94}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.1, ["Ride"] = 42, ["Fly|Ride"] = 108.77, ["Neon"] = 11.82, ["Neon|Fly"] = 35.89, ["Neon|Ride"] = 45.61, ["Mega"] = 34.1, ["Mega|Ride"] = 99.24, ["Mega|Fly|Ride"] = 219.11}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 44.36, ["Ride"] = 69.47, ["Neon"] = 281.93, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 280.81, ["Mega"] = 2533.39, ["Mega|Ride"] = 982.76, ["Mega|Fly|Ride"] = 819.7}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 586.02, ["Ride"] = 31.5, ["Fly|Ride"] = 78.15, ["Neon"] = 10.5, ["Neon|Fly"] = 183.66, ["Neon|Ride"] = 54.9, ["Neon|Fly|Ride"] = 84.47, ["Mega"] = 68.25, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 203.44}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.5, ["Ride"] = 84.48, ["Fly|Ride"] = 80.26, ["Neon"] = 5.16, ["Neon|Fly"] = 70.73, ["Neon|Ride"] = 48.58, ["Neon|Fly|Ride"] = 140.38, ["Mega"] = 26.17, ["Mega|Fly"] = 91.85, ["Mega|Ride"] = 33.1, ["Mega|Fly|Ride"] = 124.11}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 3.78, ["Ride"] = 57.03, ["Fly|Ride"] = 262.5, ["Neon"] = 12.89, ["Neon|Ride"] = 844.48, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 116.82, ["Mega|Ride"] = 141.47, ["Mega|Fly|Ride"] = 408.52}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 58.91, ["Ride"] = 105.52, ["Fly|Ride"] = 110.14, ["Neon"] = 352.54, ["Neon|Ride"] = 451.8, ["Neon|Fly|Ride"] = 692.35, ["Mega|Fly|Ride"] = 1013.37}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 278.25, ["Ride"] = 309.75, ["Fly|Ride"] = 408.62, ["Neon|Ride"] = 1127.43, ["Neon|Fly|Ride"] = 1264.6, ["Mega"] = 7037.54}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 7.76, ["Neon"] = 21.13, ["Mega"] = 85.32, ["Mega|Ride"] = 211.13, ["Mega|Fly|Ride"] = 392.68}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 5.25, ["Neon"] = 19.59, ["Mega"] = 92.04, ["Mega|Ride"] = 422.25, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 3.82, ["Fly"] = 155.57, ["Ride"] = 91.88, ["Neon"] = 39.38, ["Neon|Fly|Ride"] = 157.02, ["Mega|Ride"] = 337.84}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 53.23, ["Ride"] = 28.48, ["Fly|Ride"] = 42.25, ["Neon"] = 5.67, ["Neon|Ride"] = 28.48, ["Neon|Fly|Ride"] = 183.68, ["Mega"] = 51.08, ["Mega|Fly"] = 126.69, ["Mega|Ride"] = 73.5, ["Mega|Fly|Ride"] = 178.5}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 59.07, ["Fly|Ride"] = 281.93, ["Neon"] = 7.67, ["Mega"] = 32.81, ["Mega|Fly"] = 141.47, ["Mega|Ride"] = 205.86}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 18.38, ["Fly|Ride"] = 41.91, ["Neon"] = 4.6, ["Neon|Fly"] = 31.66, ["Neon|Ride"] = 23.24, ["Neon|Fly|Ride"] = 105, ["Mega"] = 39.38, ["Mega|Fly"] = 10978, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 281.86}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.63, ["Fly"] = 65.63, ["Ride"] = 24.94, ["Fly|Ride"] = 45.94, ["Neon"] = 16.96, ["Neon|Fly"] = 46.89, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 91.85, ["Mega"] = 170.63, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 54.92, ["Ride"] = 52.48, ["Neon"] = 93.64, ["Neon|Ride"] = 210.08, ["Mega"] = 367.5, ["Mega|Fly"] = 446.25, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 72.1, ["Ride"] = 99.26, ["Neon"] = 451.75, ["Neon|Ride"] = 393.74, ["Neon|Fly|Ride"] = 471.19, ["Mega"] = 3124.77, ["Mega|Ride"] = 2111.17, ["Mega|Fly|Ride"] = 1599.21}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 23.23, ["Fly|Ride"] = 131.25, ["Neon"] = 5.65, ["Neon|Ride"] = 110.15, ["Neon|Fly|Ride"] = 141.47, ["Mega"] = 39.8, ["Mega|Ride"] = 90.79}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 16.7, ["Ride"] = 18.9, ["Fly|Ride"] = 30.15, ["Neon"] = 3.84, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 24.92, ["Neon|Fly|Ride"] = 63.28, ["Mega"] = 42.24, ["Mega|Fly"] = 131.21, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 108.74}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 8.46, ["Ride"] = 31.67, ["Neon"] = 65.62, ["Neon|Ride"] = 422.25, ["Neon|Fly|Ride"] = 280.81, ["Mega"] = 618.59, ["Mega|Ride"] = 352.4, ["Mega|Fly|Ride"] = 472.38}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 247.08, ["Fly"] = 252, ["Ride"] = 253.41, ["Fly|Ride"] = 281.93, ["Neon|Ride"] = 1266.7, ["Neon|Fly|Ride"] = 1528.49, ["Mega|Fly|Ride"] = 5193.44}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 23.63, ["Fly"] = 209.9, ["Ride"] = 69.69, ["Fly|Ride"] = 113, ["Neon"] = 246.9, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 459.3, ["Mega"] = 969.97, ["Mega|Ride"] = 761.25, ["Mega|Fly|Ride"] = 500.72}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 9.19, ["Neon|Ride"] = 44.35, ["Neon|Fly|Ride"] = 225.91, ["Mega"] = 93.19, ["Mega|Ride"] = 85.11, ["Mega|Fly|Ride"] = 211.13}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.97, ["Fly"] = 211.15, ["Ride"] = 38.06, ["Fly|Ride"] = 142.7, ["Neon"] = 19.56, ["Neon|Ride"] = 201.63, ["Mega"] = 485.58, ["Mega|Ride"] = 438.21}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 26.24, ["Fly"] = 78.14, ["Ride"] = 45.93, ["Fly|Ride"] = 69.57, ["Neon|Ride"] = 31.64, ["Neon|Fly|Ride"] = 211.13, ["Mega"] = 2533.39, ["Mega|Ride"] = 904.32, ["Mega|Fly|Ride"] = 1094.34}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 86.62, ["Ride"] = 131.25, ["Fly|Ride"] = 190.15, ["Neon"] = 426.57, ["Neon|Ride"] = 471.19, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 3097.06, ["Mega|Fly|Ride"] = 2188.64}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 236.25, ["Ride"] = 272.42, ["Fly|Ride"] = 422.35, ["Neon"] = 1126.17, ["Neon|Ride"] = 1365, ["Neon|Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 3191.02}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 11.44, ["Ride"] = 46.9, ["Fly|Ride"] = 215.73, ["Neon"] = 111.57, ["Neon|Ride"] = 253.36, ["Mega"] = 388.5, ["Mega|Ride"] = 468.66, ["Mega|Fly|Ride"] = 565.81}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 28.52, ["Ride"] = 16.93, ["Fly|Ride"] = 42.21, ["Neon"] = 15.85, ["Neon|Fly"] = 70.73, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 70.31, ["Mega"] = 91.5, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 3.94, ["Ride"] = 27.47, ["Fly|Ride"] = 70.75, ["Neon"] = 23.4, ["Neon|Fly"] = 147.78, ["Neon|Ride"] = 38.66, ["Neon|Fly|Ride"] = 89.87, ["Mega"] = 195.57, ["Mega|Ride"] = 221.82, ["Mega|Fly|Ride"] = 266.7}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 183.35, ["Ride"] = 319.26, ["Fly|Ride"] = 359, ["Neon"] = 1337.26, ["Neon|Ride"] = 1250.16, ["Neon|Fly|Ride"] = 1783.93, ["Mega|Fly|Ride"] = 6678.63}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.63, ["Ride"] = 46.48, ["Neon"] = 11.46, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 28.88, ["Mega|Ride"] = 105.57, ["Mega|Fly|Ride"] = 302.3}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 3.68, ["Ride"] = 17.07, ["Fly|Ride"] = 36.91, ["Neon"] = 19.67, ["Neon|Ride"] = 31.87, ["Neon|Fly|Ride"] = 110.25, ["Mega"] = 185.79, ["Mega|Ride"] = 312.85, ["Mega|Fly|Ride"] = 251.24}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 14.18, ["Ride"] = 141.49, ["Neon"] = 91.88, ["Neon|Ride"] = 157.02, ["Neon|Fly|Ride"] = 563.7, ["Mega|Ride"] = 498.74, ["Mega|Fly|Ride"] = 649.2}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 70, ["Fly"] = 280.84, ["Ride"] = 123.33, ["Fly|Ride"] = 157.5, ["Neon|Ride"] = 563.07, ["Neon|Fly|Ride"] = 527.25, ["Mega|Fly|Ride"] = 2106.95}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 21, ["Fly"] = 81.94, ["Ride"] = 35.44, ["Fly|Ride"] = 53.82, ["Neon"] = 57.02, ["Neon|Ride"] = 99.24, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 492.97, ["Mega|Ride"] = 507.66, ["Mega|Fly|Ride"] = 414.75}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 24.61, ["Neon"] = 2.1, ["Neon|Ride"] = 93.75, ["Neon|Fly|Ride"] = 163.63, ["Mega"] = 27.57, ["Mega|Fly|Ride"] = 422.25}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Ride"] = 18.38, ["Fly|Ride"] = 72.19, ["Neon"] = 2.63, ["Neon|Fly"] = 31.66, ["Neon|Ride"] = 27.2, ["Neon|Fly|Ride"] = 69.18, ["Mega"] = 19.63, ["Mega|Fly"] = 139.44, ["Mega|Ride"] = 56.44, ["Mega|Fly|Ride"] = 100.73}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 17.07, ["Fly"] = 126.7, ["Ride"] = 59.06, ["Fly|Ride"] = 94.5, ["Neon"] = 36.35, ["Neon|Fly"] = 266.01, ["Neon|Ride"] = 79.19, ["Neon|Fly|Ride"] = 162.63, ["Mega"] = 143.07, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1246.88, ["Fly"] = 1535.01, ["Ride"] = 1299.38, ["Fly|Ride"] = 1443.75, ["Neon|Ride"] = 7037.54, ["Neon|Fly|Ride"] = 4640.32, ["Mega|Fly|Ride"] = 14437.5}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 631.4, ["Ride"] = 594.57, ["Fly|Ride"] = 643.13, ["Neon|Ride"] = 3097.06, ["Neon|Fly|Ride"] = 2493.75, ["Mega"] = 14059.65, ["Mega|Fly|Ride"] = 7084.87}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 210.13, ["Fly"] = 395.9, ["Ride"] = 366.39, ["Fly|Ride"] = 432.81, ["Neon"] = 735, ["Neon|Ride"] = 796.73, ["Neon|Fly|Ride"] = 529.46, ["Mega"] = 5347.56, ["Mega|Fly|Ride"] = 2425.99}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 174.34, ["Fly"] = 368.03, ["Ride"] = 204.7, ["Fly|Ride"] = 229.24, ["Neon|Ride"] = 853.12, ["Neon|Fly|Ride"] = 501.37, ["Mega|Ride"] = 3675, ["Mega|Fly|Ride"] = 3502.42}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 20.25, ["Ride"] = 19.02, ["Fly|Ride"] = 44.62, ["Neon"] = 5.44, ["Neon|Ride"] = 32.42, ["Neon|Fly|Ride"] = 78.12, ["Mega"] = 65.63, ["Mega|Ride"] = 112.88, ["Mega|Fly|Ride"] = 144.37}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 188.21, ["Fly"] = 590.62, ["Ride"] = 386.42, ["Fly|Ride"] = 346.13, ["Neon"] = 1312.5, ["Neon|Ride"] = 811.02, ["Neon|Fly|Ride"] = 659.45, ["Mega"] = 6333.47, ["Mega|Ride"] = 4506.87, ["Mega|Fly|Ride"] = 3793.13}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 2.61, ["Fly"] = 183.75, ["Ride"] = 27.47, ["Fly|Ride"] = 50.43, ["Neon"] = 5.69, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 112.96, ["Mega"] = 67.96, ["Mega|Ride"] = 106.32, ["Mega|Fly|Ride"] = 272.25}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 20.14, ["Ride"] = 23.63, ["Fly|Ride"] = 49.88, ["Neon"] = 7.87, ["Neon|Ride"] = 61.69, ["Neon|Fly|Ride"] = 63, ["Mega"] = 125.56, ["Mega|Ride"] = 140.94, ["Mega|Fly|Ride"] = 312.85}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Neon"] = 3.93, ["Neon|Fly"] = 78.52, ["Mega"] = 28.52, ["Mega|Fly"] = 70.74, ["Mega|Ride"] = 57.02, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 53.82, ["Ride"] = 65.63, ["Fly|Ride"] = 459.38, ["Neon"] = 244.13, ["Neon|Ride"] = 312.85, ["Mega|Fly|Ride"] = 985.92}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 3.68, ["Fly"] = 65.61, ["Ride"] = 23.56, ["Fly|Ride"] = 43.32, ["Neon"] = 24.29, ["Mega"] = 328.13, ["Mega|Ride"] = 316.68}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.12, ["Neon"] = 3.84, ["Neon|Fly"] = 105.56, ["Neon|Ride"] = 36.28, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 23.12, ["Mega|Fly"] = 337.8, ["Mega|Ride"] = 41.91, ["Mega|Fly|Ride"] = 308.44}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 3.29, ["Fly"] = 31.47, ["Ride"] = 28.52, ["Fly|Ride"] = 62.99, ["Neon"] = 9.08, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 28.52, ["Neon|Fly|Ride"] = 91.85, ["Mega"] = 60.38, ["Mega|Fly"] = 135.93, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 154.77}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 3.56, ["Fly"] = 46.9, ["Ride"] = 42.16, ["Fly|Ride"] = 51.45, ["Neon"] = 103.44, ["Neon|Fly"] = 140.62, ["Neon|Ride"] = 139.23, ["Neon|Fly|Ride"] = 253.23, ["Mega"] = 237.57, ["Mega|Fly|Ride"] = 1019.82}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 13.52, ["Ride"] = 52.39, ["Neon"] = 110.19, ["Mega"] = 352.79, ["Mega|Ride"] = 335.68, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.1, ["Ride"] = 26.17, ["Fly|Ride"] = 87.94, ["Neon"] = 40.69, ["Neon|Ride"] = 63.28, ["Neon|Fly|Ride"] = 702.99, ["Mega"] = 242.82, ["Mega|Ride"] = 468.66, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 19.02, ["Fly|Ride"] = 84, ["Neon"] = 3.15, ["Neon|Ride"] = 35.9, ["Mega"] = 40.69, ["Mega|Ride"] = 57.02, ["Mega|Fly|Ride"] = 316.68}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 131.25, ["Fly"] = 295.62, ["Ride"] = 258.57, ["Fly|Ride"] = 337.88, ["Neon"] = 1171.78, ["Neon|Ride"] = 1370.15, ["Neon|Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 4356.37}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 32.74, ["Ride"] = 16.79, ["Fly|Ride"] = 32.74, ["Neon"] = 4.02, ["Neon|Ride"] = 23.45, ["Neon|Fly|Ride"] = 55.13, ["Mega"] = 53.85, ["Mega|Ride"] = 64.53, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 10.5, ["Ride"] = 98.44, ["Fly|Ride"] = 102.38, ["Neon"] = 56.97, ["Neon|Ride"] = 104.41, ["Mega"] = 324.08, ["Mega|Ride"] = 348.02, ["Mega|Fly|Ride"] = 468.66}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 32.7, ["Ride"] = 133.53, ["Neon"] = 183.75, ["Neon|Ride"] = 231.06, ["Mega"] = 730.48, ["Mega|Ride"] = 738.91, ["Mega|Fly|Ride"] = 871.92}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 178.49, ["Fly"] = 291.38, ["Ride"] = 220.48, ["Fly|Ride"] = 287.44, ["Neon"] = 825.37, ["Neon|Ride"] = 649.69, ["Neon|Fly|Ride"] = 866.25, ["Mega|Ride"] = 2625, ["Mega|Fly|Ride"] = 2845.84}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 19.45, ["Neon"] = 78.75, ["Mega"] = 391.35, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 704.08}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 39.38, ["Ride"] = 261.19, ["Fly|Ride"] = 633.51, ["Neon"] = 231.16, ["Mega"] = 793.8, ["Mega|Fly|Ride"] = 2111.17}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 1181.25, ["Fly"] = 1323.87, ["Ride"] = 649.27, ["Fly|Ride"] = 1181.25, ["Neon|Ride"] = 4221.26, ["Neon|Fly|Ride"] = 3962.34, ["Mega|Fly|Ride"] = 17100.33}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 6.57, ["Fly"] = 28.14, ["Ride"] = 21.61, ["Fly|Ride"] = 63, ["Neon"] = 52.5, ["Neon|Fly"] = 111.57, ["Neon|Ride"] = 55.09, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 211.95, ["Mega|Ride"] = 216.57, ["Mega|Fly|Ride"] = 532.65}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 6.56, ["Fly"] = 39.38, ["Ride"] = 35.44, ["Neon"] = 42, ["Neon|Ride"] = 141.39, ["Neon|Fly|Ride"] = 144.74, ["Mega"] = 212.63, ["Mega|Ride"] = 281.86, ["Mega|Fly|Ride"] = 345.64}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 5.25, ["Fly"] = 191.09, ["Ride"] = 38.06, ["Fly|Ride"] = 91.88, ["Neon"] = 10.02, ["Neon|Ride"] = 78.52, ["Neon|Fly|Ride"] = 312.85, ["Mega"] = 60.06, ["Mega|Ride"] = 291.36, ["Mega|Fly|Ride"] = 844.48}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 14.44, ["Fly"] = 704.18, ["Ride"] = 32.8, ["Fly|Ride"] = 85.32, ["Neon"] = 86.61, ["Neon|Ride"] = 98.98, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 373.05, ["Mega|Ride"] = 215.57, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 2.1, ["Fly"] = 24.24, ["Ride"] = 19.69, ["Fly|Ride"] = 31.4, ["Neon"] = 19.67, ["Neon|Fly"] = 42.21, ["Neon|Ride"] = 34.04, ["Neon|Fly|Ride"] = 84.47, ["Mega|Ride"] = 112.96, ["Mega|Fly|Ride"] = 187.21}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 45.94, ["Neon"] = 11.7, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 42.2, ["Neon|Fly|Ride"] = 844.48, ["Mega"] = 211.13, ["Mega|Ride"] = 257.58, ["Mega|Fly|Ride"] = 367.47}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 229.59, ["Ride"] = 333.38, ["Fly|Ride"] = 542.71, ["Neon|Ride"] = 1548.54, ["Neon|Fly|Ride"] = 1451.44, ["Mega|Fly|Ride"] = 4136.81}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 3.29, ["Ride"] = 28.52, ["Fly|Ride"] = 53.95, ["Neon"] = 10.58, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 41.91, ["Neon|Fly|Ride"] = 135.13, ["Mega"] = 104.87, ["Mega|Ride"] = 239.63, ["Mega|Fly|Ride"] = 234.94}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 2.15, ["Neon"] = 46.41, ["Neon|Ride"] = 313.69, ["Mega"] = 183.68, ["Mega|Ride"] = 985.92}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 2.52, ["Fly"] = 58.16, ["Ride"] = 34.13, ["Neon"] = 19.69, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 207.18, ["Mega"] = 77.04, ["Mega|Fly"] = 422.25, ["Mega|Ride"] = 127.65, ["Mega|Fly|Ride"] = 348.48}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 93.62, ["Fly"] = 354.9, ["Ride"] = 141.05, ["Fly|Ride"] = 380.12, ["Neon"] = 656.25, ["Neon|Ride"] = 527.81, ["Neon|Fly|Ride"] = 860.5, ["Mega|Ride"] = 5066.78, ["Mega|Fly|Ride"] = 946.6}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 26.1, ["Fly"] = 61.62, ["Ride"] = 99.26, ["Fly|Ride"] = 109.82, ["Neon"] = 105, ["Neon|Ride"] = 312.85, ["Neon|Fly|Ride"] = 268.13, ["Mega"] = 687.2, ["Mega|Ride"] = 725.2, ["Mega|Fly|Ride"] = 644.8}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 23, ["Ride"] = 48.57, ["Fly|Ride"] = 1267.02, ["Neon"] = 131.25, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 273.41, ["Mega"] = 429.63, ["Mega|Ride"] = 369.59, ["Mega|Fly|Ride"] = 349.55}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Fly"] = 44.63, ["Neon"] = 3.86, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 35.44, ["Mega"] = 28.38, ["Mega|Ride"] = 71.96, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 75.93, ["Fly"] = 99.86, ["Ride"] = 128.83, ["Fly|Ride"] = 230.35, ["Neon"] = 281.24, ["Neon|Fly"] = 471.78, ["Neon|Ride"] = 422.25, ["Neon|Fly|Ride"] = 228.78, ["Mega|Fly|Ride"] = 1216.03}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 20.08, ["Neon"] = 5.84, ["Neon|Ride"] = 48.58, ["Neon|Fly|Ride"] = 588, ["Mega"] = 57.02, ["Mega|Ride"] = 223.13}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 23.46, ["Fly"] = 141.58, ["Ride"] = 28.49, ["Fly|Ride"] = 124.43, ["Neon"] = 82.26, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 140.44, ["Mega"] = 380.63, ["Mega|Ride"] = 411.26, ["Mega|Fly|Ride"] = 350.44}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 46.9, ["Fly"] = 80.01, ["Ride"] = 85.32, ["Fly|Ride"] = 139.53, ["Neon"] = 129.94, ["Neon|Ride"] = 238.87, ["Neon|Fly|Ride"] = 295.58, ["Mega|Ride"] = 1230.81, ["Mega|Fly|Ride"] = 1134}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 15.85, ["Fly|Ride"] = 36.93, ["Neon"] = 2.1, ["Neon|Fly"] = 28.13, ["Neon|Ride"] = 15.84, ["Neon|Fly|Ride"] = 31.49, ["Mega"] = 19, ["Mega|Fly"] = 55.13, ["Mega|Ride"] = 34.13, ["Mega|Fly|Ride"] = 83.98}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 9.19, ["Ride"] = 32.18, ["Fly|Ride"] = 99.26, ["Neon"] = 18.38, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 144.38, ["Mega|Ride"] = 281.54, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 20.35, ["Ride"] = 56.44, ["Neon"] = 165.38, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 201.52, ["Neon|Fly|Ride"] = 625.68, ["Mega"] = 696.7, ["Mega|Ride"] = 648.14, ["Mega|Fly|Ride"] = 625.68}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 26.76, ["Neon"] = 2.6, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 137.24, ["Mega"] = 28.35, ["Mega|Ride"] = 108.74}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 5.25, ["Fly"] = 210, ["Ride"] = 27.06, ["Fly|Ride"] = 78.56, ["Neon"] = 39.8, ["Neon|Ride"] = 99.24, ["Neon|Fly|Ride"] = 204.8, ["Mega"] = 408.52, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 155.07, ["Mega|Fly|Ride"] = 334.69}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 20.97, ["Fly"] = 42.21, ["Ride"] = 24.28, ["Fly|Ride"] = 63.2, ["Neon"] = 117.03, ["Neon|Ride"] = 64.56, ["Neon|Fly|Ride"] = 281.86, ["Mega|Ride"] = 422.25, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 2.1, ["Ride"] = 83.1, ["Fly|Ride"] = 76.13, ["Neon"] = 30.08, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 28.52, ["Neon|Fly|Ride"] = 200.82, ["Mega"] = 169.32, ["Mega|Ride"] = 162.75, ["Mega|Fly|Ride"] = 293.47}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 16.84, ["Fly"] = 2111.42, ["Ride"] = 150.38, ["Neon"] = 84.51, ["Neon|Ride"] = 421.18, ["Neon|Fly|Ride"] = 422.25, ["Mega"] = 459.12, ["Mega|Ride"] = 548.91, ["Mega|Fly|Ride"] = 623.86}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Ride"] = 125.58, ["Fly|Ride"] = 126.71, ["Neon"] = 5.25, ["Neon|Fly"] = 49.63, ["Neon|Ride"] = 57.02, ["Neon|Fly|Ride"] = 99.08, ["Mega"] = 74.82, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 138.29, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Ride"] = 42.24, ["Mega"] = 21, ["Mega|Ride"] = 138.29, ["Mega|Fly|Ride"] = 234.33}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 42}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 52.5, ["Fly"] = 102.38, ["Ride"] = 52.5, ["Fly|Ride"] = 117.21, ["Neon"] = 1050, ["Neon|Ride"] = 247.02, ["Neon|Fly|Ride"] = 1055.59, ["Mega"] = 1097.81, ["Mega|Ride"] = 983.81, ["Mega|Fly|Ride"] = 889.88}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Ride"] = 81.38, ["Fly|Ride"] = 105, ["Neon"] = 2.63, ["Mega"] = 21.11, ["Mega|Fly"] = 137.82, ["Mega|Ride"] = 99.17, ["Mega|Fly|Ride"] = 116.82}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 551.25, ["Ride"] = 570.93, ["Fly|Ride"] = 626.04, ["Neon"] = 1830.15, ["Neon|Ride"] = 1968.75, ["Neon|Fly|Ride"] = 2393.01, ["Mega"] = 8444.61, ["Mega|Fly|Ride"] = 10555.76}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 2.57, ["Fly"] = 26.17, ["Ride"] = 42.18, ["Fly|Ride"] = 75.91, ["Neon"] = 32.82, ["Neon|Fly"] = 704, ["Neon|Ride"] = 104.52, ["Mega|Ride"] = 141.47, ["Mega|Fly|Ride"] = 563.75}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 3.94, ["Fly"] = 44.39, ["Ride"] = 23.25, ["Fly|Ride"] = 52.5, ["Neon"] = 35.89, ["Neon|Ride"] = 35.38, ["Neon|Fly|Ride"] = 84.38, ["Mega"] = 261.79, ["Mega|Ride"] = 158.05, ["Mega|Fly|Ride"] = 187.69}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 138.33, ["Ride"] = 54.92, ["Fly|Ride"] = 106.32, ["Neon"] = 116.85, ["Neon|Ride"] = 181.13, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 1070.37, ["Mega|Ride"] = 526.75, ["Mega|Fly|Ride"] = 544.69}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 3.82, ["Fly"] = 39.38, ["Ride"] = 44.57, ["Fly|Ride"] = 141.49, ["Neon"] = 40.09, ["Mega"] = 293.47, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 9.55, ["Ride"] = 126.7, ["Fly|Ride"] = 157.5, ["Neon"] = 117.15, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 350.44, ["Mega"] = 363.57, ["Mega|Ride"] = 406.23, ["Mega|Fly|Ride"] = 392.44}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 6.24, ["Fly"] = 97.64, ["Ride"] = 31.67, ["Fly|Ride"] = 787.5, ["Neon"] = 35.89, ["Neon|Ride"] = 91.77, ["Neon|Fly|Ride"] = 284.82, ["Mega"] = 162.63, ["Mega|Fly"] = 487.7, ["Mega|Ride"] = 195.57, ["Mega|Fly|Ride"] = 302.97}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 27.47, ["Ride"] = 15.85, ["Fly|Ride"] = 28.88, ["Neon"] = 2.1, ["Neon|Fly"] = 28.52, ["Neon|Ride"] = 21.13, ["Neon|Fly|Ride"] = 70.7, ["Mega"] = 16.42, ["Mega|Fly"] = 78.52, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 82.69}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 5.39, ["Ride"] = 39.38, ["Fly|Ride"] = 157.94, ["Neon"] = 48.19, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 316.68, ["Mega"] = 167.88, ["Mega|Ride"] = 217.88, ["Mega|Fly|Ride"] = 352.57}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 261.19, ["Ride"] = 311.07, ["Fly|Ride"] = 393.75, ["Neon"] = 1480.5, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1952.83, ["Mega|Fly|Ride"] = 4081.88}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 89.25, ["Ride"] = 149.63, ["Fly|Ride"] = 293.09, ["Neon"] = 379.98, ["Neon|Ride"] = 348.36, ["Neon|Fly|Ride"] = 698.25, ["Mega"] = 4222.31, ["Mega|Ride"] = 1590.77, ["Mega|Fly|Ride"] = 1615.04}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 23.24, ["Ride"] = 22.29, ["Fly|Ride"] = 39.34, ["Neon"] = 19.69, ["Neon|Ride"] = 33.53, ["Neon|Fly|Ride"] = 62.67, ["Mega|Fly"] = 210.08, ["Mega|Ride"] = 91.85, ["Mega|Fly|Ride"] = 141.47}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 15.8, ["Fly|Ride"] = 35.9, ["Neon"] = 5.25, ["Neon|Fly"] = 31.63, ["Neon|Ride"] = 27.44, ["Neon|Fly|Ride"] = 56.99, ["Mega"] = 73.5, ["Mega|Fly"] = 352.57, ["Mega|Ride"] = 72.19, ["Mega|Fly|Ride"] = 152.24}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 4.24, ["Ride"] = 18.97, ["Fly|Ride"] = 98.44, ["Neon"] = 39.38, ["Mega"] = 141.47}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 231, ["Ride"] = 275.63, ["Fly|Ride"] = 325.5, ["Neon|Ride"] = 1094.34, ["Neon|Fly|Ride"] = 1414.88, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.1, ["Fly"] = 20.05, ["Ride"] = 18.38, ["Fly|Ride"] = 46.48, ["Neon"] = 15.85, ["Neon|Fly"] = 157.03, ["Neon|Ride"] = 28.25, ["Neon|Fly|Ride"] = 78.73, ["Mega"] = 286.02, ["Mega|Ride"] = 202.69, ["Mega|Fly|Ride"] = 229.69}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 5.2, ["Fly"] = 140.66, ["Ride"] = 39.87, ["Fly|Ride"] = 211.18, ["Neon"] = 37.51, ["Neon|Ride"] = 21.11, ["Mega"] = 251.35, ["Mega|Ride"] = 236.24, ["Mega|Fly|Ride"] = 416.97}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 19.02, ["Neon"] = 4.24, ["Neon|Ride"] = 30.35, ["Neon|Fly|Ride"] = 141.47, ["Mega"] = 40.69, ["Mega|Ride"] = 95.7, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 14.7, ["Fly"] = 70.74, ["Ride"] = 27.57, ["Fly|Ride"] = 47.01, ["Neon"] = 87.05, ["Neon|Ride"] = 93.75, ["Neon|Fly|Ride"] = 152.02, ["Mega"] = 761.15, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 468.66}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 32.75, ["Ride"] = 97.15, ["Fly|Ride"] = 228.08, ["Neon"] = 90.57, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 185.07, ["Mega"] = 446.25, ["Mega|Fly"] = 2216.72, ["Mega|Ride"] = 264.1, ["Mega|Fly|Ride"] = 317.04}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 22.31, ["Fly"] = 70.74, ["Ride"] = 43.32, ["Fly|Ride"] = 138.33, ["Neon"] = 131.25, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 133.41, ["Neon|Fly|Ride"] = 219.19, ["Mega|Ride"] = 783.12, ["Mega|Fly|Ride"] = 781.5}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 15.91, ["Ride"] = 16.02, ["Fly|Ride"] = 51.44, ["Neon"] = 2.1, ["Neon|Fly"] = 21, ["Neon|Ride"] = 20.07, ["Neon|Fly|Ride"] = 57.02, ["Mega"] = 21.11, ["Mega|Fly"] = 45.94, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 115.5}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 115.64, ["Fly"] = 278.25, ["Ride"] = 236.25, ["Fly|Ride"] = 313.69, ["Neon"] = 1081.54, ["Neon|Ride"] = 927.87, ["Neon|Fly|Ride"] = 927.87, ["Mega"] = 4115.7, ["Mega|Fly|Ride"] = 3800.08}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 13.13, ["Fly"] = 140.39, ["Ride"] = 41.45, ["Neon"] = 105, ["Neon|Ride"] = 188.25, ["Neon|Fly|Ride"] = 210, ["Mega"] = 633.35, ["Mega|Ride"] = 585.83, ["Mega|Fly|Ride"] = 587.35}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Ride"] = 18.38, ["Fly|Ride"] = 39.38, ["Neon"] = 6.36, ["Neon|Ride"] = 31.64, ["Mega"] = 41.19, ["Mega|Ride"] = 99.58, ["Mega|Fly|Ride"] = 297.5}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 25.35, ["Ride"] = 20.15, ["Fly|Ride"] = 70.82, ["Neon"] = 3.15, ["Neon|Fly"] = 46.89, ["Neon|Ride"] = 21.29, ["Neon|Fly|Ride"] = 97.23, ["Mega"] = 16.86, ["Mega|Fly"] = 138.29, ["Mega|Ride"] = 43.32, ["Mega|Fly|Ride"] = 117.17}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 3.67, ["Ride"] = 22.32, ["Fly|Ride"] = 84.49, ["Neon"] = 6.57, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 7037.54, ["Mega"] = 92.93, ["Mega|Ride"] = 174.56, ["Mega|Fly|Ride"] = 352.57}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 12.86, ["Fly"] = 65.63, ["Ride"] = 23.63, ["Fly|Ride"] = 68.25, ["Neon"] = 44.35, ["Neon|Ride"] = 62.91, ["Neon|Fly|Ride"] = 83.21, ["Mega"] = 501.47, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 377.99}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 7.53, ["Ride"] = 31.67, ["Neon"] = 52.79, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 204.8, ["Mega|Ride"] = 298.78, ["Mega|Fly|Ride"] = 308.25}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 60.97, ["Neon"] = 3.7, ["Neon|Ride"] = 31.64, ["Mega"] = 23.51, ["Mega|Ride"] = 82.35, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 9.19, ["Ride"] = 28.52, ["Fly|Ride"] = 84.49, ["Neon"] = 24.94, ["Neon|Fly"] = 102.92, ["Neon|Ride"] = 42.15, ["Neon|Fly|Ride"] = 123.38, ["Mega"] = 141.47, ["Mega|Fly"] = 211.13, ["Mega|Ride"] = 211.13, ["Mega|Fly|Ride"] = 278.65}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 126.7, ["Fly|Ride"] = 99.26, ["Neon"] = 5.55, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 157.02, ["Mega"] = 34.12, ["Mega|Ride"] = 72.19, ["Mega|Fly|Ride"] = 625.68}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 26.54, ["Ride"] = 18.38, ["Fly|Ride"] = 52.5, ["Neon"] = 5.98, ["Neon|Ride"] = 27.45, ["Neon|Fly|Ride"] = 124.69, ["Mega"] = 65.63, ["Mega|Fly"] = 99.24, ["Mega|Ride"] = 69.93, ["Mega|Fly|Ride"] = 141.47}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 745.5, ["Ride"] = 658.76, ["Fly|Ride"] = 1050, ["Neon|Fly|Ride"] = 5619.27, ["Mega|Fly|Ride"] = 15824.9}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 22.19, ["Ride"] = 15.75, ["Fly|Ride"] = 32.79, ["Neon"] = 15.81, ["Neon|Fly"] = 44.61, ["Neon|Ride"] = 57.36, ["Neon|Fly|Ride"] = 62.29, ["Mega"] = 188.96, ["Mega|Ride"] = 211.13, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.9, ["Ride"] = 53.92, ["Fly|Ride"] = 132.57, ["Neon"] = 10.4, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 51.19, ["Mega|Ride"] = 102.46, ["Mega|Fly|Ride"] = 224.05}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 15.65, ["Fly"] = 35.9, ["Ride"] = 27.41, ["Fly|Ride"] = 45.94, ["Neon"] = 44.63, ["Neon|Fly"] = 112.74, ["Neon|Ride"] = 47.16, ["Neon|Fly|Ride"] = 105, ["Mega"] = 328.13, ["Mega|Ride"] = 291.37, ["Mega|Fly|Ride"] = 325.34}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 28.52, ["Ride"] = 16.88, ["Fly|Ride"] = 32.82, ["Neon"] = 11.61, ["Neon|Fly"] = 87.93, ["Neon|Ride"] = 21.95, ["Neon|Fly|Ride"] = 61.95, ["Mega"] = 78.75, ["Mega|Fly"] = 349.84, ["Mega|Ride"] = 99.75, ["Mega|Fly|Ride"] = 188.62}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 46.13, ["Neon"] = 337.76, ["Neon|Ride"] = 341.25, ["Mega"] = 896.44, ["Mega|Ride"] = 872.97, ["Mega|Fly|Ride"] = 985.92}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Fly"] = 33.79, ["Ride"] = 26.25, ["Fly|Ride"] = 704.26, ["Neon"] = 5.25, ["Neon|Ride"] = 35.16, ["Neon|Fly|Ride"] = 206.07, ["Mega"] = 87.63, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 392.11}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 3.82, ["Fly"] = 73.5, ["Ride"] = 22.23, ["Fly|Ride"] = 61.25, ["Neon"] = 13.07, ["Neon|Fly"] = 140.62, ["Neon|Ride"] = 42.24, ["Neon|Fly|Ride"] = 451.8, ["Mega"] = 140.61, ["Mega|Ride"] = 344.13, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly|Ride"] = 65.76, ["Neon"] = 15.72, ["Neon|Fly"] = 63.3, ["Mega"] = 112.96, ["Mega|Fly"] = 281.86}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 21.13, ["Ride"] = 15.83, ["Fly|Ride"] = 84.47, ["Neon"] = 3.83, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 94.4, ["Mega"] = 38.07, ["Mega|Fly"] = 156.19, ["Mega|Ride"] = 63.35, ["Mega|Fly|Ride"] = 127.16}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 17.05, ["Fly"] = 31.66, ["Ride"] = 22.32, ["Fly|Ride"] = 42.25, ["Neon"] = 137.82, ["Neon|Ride"] = 112.96, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 844.48, ["Mega|Ride"] = 522.53, ["Mega|Fly|Ride"] = 438.08}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 720.56, ["Ride"] = 754.69, ["Fly|Ride"] = 835.8, ["Neon"] = 1729.91, ["Neon|Ride"] = 2188.64, ["Neon|Fly|Ride"] = 1955.63, ["Mega|Ride"] = 4725, ["Mega|Fly|Ride"] = 3413.96}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 68.25, ["Ride"] = 18.9, ["Fly|Ride"] = 39.15, ["Neon"] = 2.63, ["Neon|Fly"] = 20.07, ["Neon|Ride"] = 23.42, ["Neon|Fly|Ride"] = 81.38, ["Mega"] = 39.38, ["Mega|Ride"] = 87.57, ["Mega|Fly|Ride"] = 90.77}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 6.5, ["Ride"] = 36.91, ["Fly|Ride"] = 92.18, ["Neon"] = 52.5, ["Neon|Ride"] = 231, ["Neon|Fly|Ride"] = 248.11, ["Mega"] = 321.57, ["Mega|Ride"] = 351.75, ["Mega|Fly|Ride"] = 441}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 52.5, ["Ride"] = 70.93, ["Fly|Ride"] = 111.15, ["Neon|Ride"] = 380.02, ["Neon|Fly|Ride"] = 422.25, ["Mega"] = 2815.23, ["Mega|Fly|Ride"] = 2231.25}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 46.91, ["Fly"] = 141.48, ["Ride"] = 63.35, ["Fly|Ride"] = 84.49, ["Neon"] = 196.88, ["Neon|Ride"] = 177.19, ["Neon|Fly|Ride"] = 268.01, ["Mega"] = 886.26, ["Mega|Ride"] = 890.46, ["Mega|Fly|Ride"] = 927.87}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 15.54, ["Ride"] = 39.38, ["Neon"] = 78.48, ["Neon|Ride"] = 168.91, ["Neon|Fly|Ride"] = 281.86, ["Mega"] = 311.41, ["Mega|Ride"] = 451.8, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 63.32, ["Ride"] = 141.48, ["Neon"] = 80.05, ["Neon|Fly"] = 157.03, ["Neon|Ride"] = 99.24, ["Mega"] = 234.36, ["Mega|Ride"] = 283.5, ["Mega|Fly|Ride"] = 434.91}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 26.25, ["Fly"] = 112.97, ["Ride"] = 315, ["Neon"] = 131.24, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 525, ["Mega"] = 656.25, ["Mega|Ride"] = 617.47, ["Mega|Fly|Ride"] = 840.67}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 21}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 6.83, ["Fly"] = 78.54, ["Ride"] = 26.97, ["Fly|Ride"] = 104.54, ["Neon"] = 101.07, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 78.64, ["Neon|Fly|Ride"] = 154.13, ["Mega"] = 217.47, ["Mega|Ride"] = 216.57, ["Mega|Fly|Ride"] = 401.13}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 3.03, ["Ride"] = 99.25, ["Neon"] = 27.57, ["Mega"] = 239.63, ["Mega|Fly|Ride"] = 950.03}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 80.22, ["Fly"] = 83.89, ["Ride"] = 49.19, ["Fly|Ride"] = 123.85, ["Neon"] = 288.75, ["Neon|Ride"] = 189, ["Neon|Fly|Ride"] = 281.86, ["Mega"] = 925.32, ["Mega|Ride"] = 812.44, ["Mega|Fly|Ride"] = 813.75}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.4, ["Fly"] = 25.35, ["Ride"] = 16.9, ["Fly|Ride"] = 35.9, ["Neon"] = 27.45, ["Neon|Fly"] = 61.15, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 78.2, ["Mega"] = 262.5, ["Mega|Fly"] = 238.58, ["Mega|Ride"] = 213.24, ["Mega|Fly|Ride"] = 147}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 7.55, ["Fly"] = 84.48, ["Ride"] = 31.68, ["Fly|Ride"] = 704.26, ["Neon"] = 23.35, ["Neon|Fly"] = 126.67, ["Neon|Ride"] = 50.66, ["Neon|Fly|Ride"] = 113.91, ["Mega"] = 72.08, ["Mega|Fly"] = 301.45, ["Mega|Ride"] = 170.92, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Ride"] = 142.55, ["Neon"] = 5.25, ["Neon|Ride"] = 200.37, ["Mega"] = 32.68, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 192.13}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 48.57, ["Fly"] = 84.48, ["Ride"] = 59.14, ["Fly|Ride"] = 126.71, ["Neon"] = 176.96, ["Neon|Ride"] = 238.25, ["Neon|Fly|Ride"] = 281.86, ["Mega"] = 844.48, ["Mega|Ride"] = 831.88, ["Mega|Fly|Ride"] = 739.34}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Fly|Ride"] = 141.49, ["Neon"] = 9.39, ["Neon|Fly|Ride"] = 297.61, ["Mega"] = 141.47, ["Mega|Fly|Ride"] = 309.68}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 11.19, ["Ride"] = 141.49, ["Neon"] = 258.97, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 295.58, ["Mega"] = 312.85, ["Mega|Ride"] = 468.66, ["Mega|Fly|Ride"] = 781.5}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 23.51, ["Ride"] = 18.69, ["Fly|Ride"] = 35.44, ["Neon"] = 25.79, ["Neon|Ride"] = 40.27, ["Neon|Fly|Ride"] = 92.87, ["Mega"] = 157.02, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 3.5, ["Fly"] = 52.5, ["Ride"] = 24.94, ["Fly|Ride"] = 49.88, ["Neon"] = 52.5, ["Neon|Fly"] = 84.45, ["Neon|Ride"] = 126.69, ["Mega"] = 281.86, ["Mega|Ride"] = 168.91, ["Mega|Fly|Ride"] = 418.04}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 4.24, ["Ride"] = 139.39, ["Neon"] = 17.07, ["Neon|Ride"] = 110.15, ["Mega"] = 141.47, ["Mega|Ride"] = 557.17, ["Mega|Fly|Ride"] = 420.13}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 45.94, ["Ride"] = 112.09, ["Neon"] = 182.44, ["Neon|Ride"] = 249.38, ["Mega"] = 853.13, ["Mega|Ride"] = 1408.15, ["Mega|Fly|Ride"] = 969.56}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 13.84, ["Ride"] = 281.6, ["Neon"] = 141.44, ["Mega"] = 510.91, ["Mega|Ride"] = 563.07, ["Mega|Fly|Ride"] = 563.7}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 7.76, ["Ride"] = 105, ["Neon"] = 110.02, ["Neon|Ride"] = 393.75, ["Mega"] = 579.97, ["Mega|Ride"] = 556.31, ["Mega|Fly|Ride"] = 1688.94}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 13.12, ["Ride"] = 76.27, ["Fly|Ride"] = 422.03, ["Neon"] = 131.25, ["Neon|Ride"] = 633.35, ["Neon|Fly|Ride"] = 573.57, ["Mega"] = 774.8, ["Mega|Ride"] = 700.91, ["Mega|Fly|Ride"] = 913.47}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 3.72, ["Ride"] = 21.13, ["Neon"] = 42.21, ["Neon|Ride"] = 422.25, ["Mega"] = 281.86, ["Mega|Fly|Ride"] = 312.85}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 17.71, ["Fly|Ride"] = 52.5, ["Neon"] = 5.25, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 25.35, ["Neon|Fly|Ride"] = 137.82, ["Mega"] = 78.53, ["Mega|Fly"] = 211.13, ["Mega|Ride"] = 89.25, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 2.99, ["Ride"] = 49.79, ["Fly|Ride"] = 91.88, ["Neon"] = 26.24, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 157.02, ["Mega"] = 181.57, ["Mega|Ride"] = 172.09, ["Mega|Fly|Ride"] = 447.58}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 32.66, ["Ride"] = 23.62, ["Fly|Ride"] = 55.13, ["Neon"] = 5.65, ["Neon|Ride"] = 23.24, ["Neon|Fly|Ride"] = 84.47, ["Mega"] = 44.45, ["Mega|Fly"] = 117.17, ["Mega|Ride"] = 78.12, ["Mega|Fly|Ride"] = 195.68}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 3.93, ["Ride"] = 56.96, ["Fly|Ride"] = 42.25, ["Neon"] = 35.43, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 197.42, ["Mega"] = 162.75, ["Mega|Ride"] = 154.88, ["Mega|Fly|Ride"] = 468.66}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 5.87, ["Ride"] = 28.53, ["Fly|Ride"] = 99.75, ["Neon"] = 42.24, ["Neon|Ride"] = 97.76, ["Neon|Fly|Ride"] = 211.13, ["Mega"] = 468.66, ["Mega|Ride"] = 416.8, ["Mega|Fly|Ride"] = 374.94}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 4.68, ["Ride"] = 22.14, ["Fly|Ride"] = 70.75, ["Neon"] = 30.19, ["Neon|Fly"] = 105.56, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 105, ["Mega|Ride"] = 252, ["Mega|Fly|Ride"] = 310.12}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.61, ["Ride"] = 25.36, ["Fly|Ride"] = 57.03, ["Neon"] = 21.13, ["Neon|Fly"] = 84.45, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 105.57, ["Mega"] = 141.39, ["Mega|Ride"] = 168.91, ["Mega|Fly|Ride"] = 462.36}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 3.08, ["Fly"] = 301.88, ["Ride"] = 50.7, ["Neon"] = 18.38, ["Neon|Fly"] = 168.99, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 210.97, ["Mega"] = 90.61, ["Mega|Ride"] = 179.27, ["Mega|Fly|Ride"] = 236.04}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 18.12, ["Ride"] = 78.75, ["Fly|Ride"] = 280.86, ["Neon"] = 98.44, ["Neon|Ride"] = 168.91, ["Neon|Fly|Ride"] = 352.57, ["Mega"] = 355.69, ["Mega|Fly"] = 1968.75, ["Mega|Ride"] = 440.9, ["Mega|Fly|Ride"] = 563.7}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 52.5, ["Fly"] = 203.95, ["Ride"] = 97.13, ["Fly|Ride"] = 281.93, ["Neon"] = 249.38, ["Neon|Ride"] = 295.58, ["Neon|Fly|Ride"] = 346.5, ["Mega"] = 918.75, ["Mega|Ride"] = 853.13, ["Mega|Fly|Ride"] = 748.49}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Ride"] = 21.13, ["Fly|Ride"] = 65.54, ["Neon"] = 3.87, ["Neon|Ride"] = 37.95, ["Neon|Fly|Ride"] = 58.35, ["Mega"] = 31.49, ["Mega|Ride"] = 71.14, ["Mega|Fly|Ride"] = 91.88}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 9.48, ["Ride"] = 350.55, ["Neon"] = 262.5, ["Mega"] = 420.13, ["Mega|Fly|Ride"] = 1266.7}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 39.38, ["Ride"] = 117.25, ["Neon"] = 234.1, ["Neon|Ride"] = 341.25, ["Mega"] = 1091.48, ["Mega|Ride"] = 1106.26, ["Mega|Fly|Ride"] = 1262.48}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 7.76, ["Fly"] = 190.32, ["Ride"] = 32.82, ["Fly|Ride"] = 126, ["Neon"] = 62.3, ["Neon|Ride"] = 77.44, ["Mega"] = 125.58, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 393.1}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 2.1, ["Fly"] = 157.5, ["Ride"] = 31.66, ["Fly|Ride"] = 84.53, ["Neon"] = 4.15, ["Neon|Ride"] = 27.46, ["Mega"] = 12.79, ["Mega|Ride"] = 39.67, ["Mega|Fly|Ride"] = 155.73}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 20.05, ["Fly|Ride"] = 48.59, ["Neon"] = 19.69, ["Neon|Fly"] = 422.2, ["Neon|Ride"] = 40.68, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 204.8, ["Mega|Fly"] = 352.41, ["Mega|Ride"] = 111.91, ["Mega|Fly|Ride"] = 231}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 19.08, ["Ride"] = 19.02, ["Neon"] = 3.93, ["Neon|Ride"] = 26.94, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 42.24, ["Mega|Ride"] = 68.08, ["Mega|Fly|Ride"] = 111.57}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 18.36, ["Fly|Ride"] = 65.7, ["Neon"] = 3.72, ["Neon|Ride"] = 31.68, ["Neon|Fly|Ride"] = 71.79, ["Mega"] = 39.38, ["Mega|Fly"] = 168, ["Mega|Ride"] = 56.97, ["Mega|Fly|Ride"] = 178.49}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 2.1, ["Neon|Ride"] = 157.02, ["Neon|Fly|Ride"] = 78.52, ["Mega"] = 18.38, ["Mega|Ride"] = 105.57, ["Mega|Fly|Ride"] = 259.68}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 4.36, ["Ride"] = 157.5, ["Fly|Ride"] = 359, ["Neon"] = 36.75, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 209.02, ["Mega"] = 196.88, ["Mega|Ride"] = 314.57, ["Mega|Fly|Ride"] = 1126.32}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 13.02, ["Ride"] = 34.13, ["Fly|Ride"] = 211.18, ["Neon"] = 82.34, ["Neon|Ride"] = 126.69, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 386.36, ["Mega|Ride"] = 421.08, ["Mega|Fly|Ride"] = 506.69}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 7.35, ["Fly"] = 22.32, ["Ride"] = 20.98, ["Fly|Ride"] = 47.12, ["Neon"] = 63.34, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 86.41, ["Mega|Ride"] = 334.69, ["Mega|Fly|Ride"] = 375.36}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 79.98, ["Ride"] = 91.88, ["Fly|Ride"] = 262.5, ["Neon"] = 538.13, ["Neon|Ride"] = 888.57, ["Mega"] = 3124.77, ["Mega|Fly|Ride"] = 1609.84}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 18.38, ["Fly"] = 72.43, ["Ride"] = 65.63, ["Fly|Ride"] = 113, ["Neon"] = 78.52, ["Mega"] = 625.68, ["Mega|Fly"] = 648.14, ["Mega|Ride"] = 603.75, ["Mega|Fly|Ride"] = 1029.67}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 17.93, ["Ride"] = 19.02, ["Fly|Ride"] = 31.5, ["Neon"] = 4.71, ["Neon|Fly"] = 33.79, ["Neon|Ride"] = 20.9, ["Neon|Fly|Ride"] = 69.57, ["Mega"] = 61.24, ["Mega|Ride"] = 107.68, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 16.88, ["Ride"] = 15.85, ["Fly|Ride"] = 28.5, ["Neon"] = 3.03, ["Neon|Fly"] = 26.17, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 34.13, ["Mega|Ride"] = 45.94, ["Mega|Fly|Ride"] = 72.17}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 318.28, ["Ride"] = 399, ["Fly|Ride"] = 513.01, ["Neon|Fly|Ride"] = 1522.5}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 13.13, ["Fly|Ride"] = 197.46, ["Neon"] = 103.42, ["Neon|Fly|Ride"] = 401.13, ["Mega"] = 408.52, ["Mega|Ride"] = 426.57, ["Mega|Fly|Ride"] = 985.92}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 27.12, ["Ride"] = 17.46, ["Fly|Ride"] = 32.82, ["Neon"] = 5.77, ["Neon|Fly"] = 28.61, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 42.24, ["Mega"] = 42, ["Mega|Ride"] = 73.9, ["Mega|Fly|Ride"] = 89.59}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 71.77, ["Ride"] = 122.04, ["Fly|Ride"] = 315, ["Neon"] = 211.18, ["Neon|Ride"] = 302.71, ["Neon|Fly|Ride"] = 366.19, ["Mega"] = 734.99, ["Mega|Ride"] = 1048.95, ["Mega|Fly|Ride"] = 910.88}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 4.24, ["Ride"] = 21.13, ["Fly|Ride"] = 41.91, ["Neon"] = 6.46, ["Neon|Fly"] = 67.6, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 78.73, ["Mega"] = 104.41, ["Mega|Fly"] = 183.68, ["Mega|Ride"] = 115.27, ["Mega|Fly|Ride"] = 207.83}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 70.74, ["Ride"] = 39.38, ["Fly|Ride"] = 1312.5, ["Neon"] = 3.92, ["Neon|Ride"] = 35.9, ["Neon|Fly|Ride"] = 283.19, ["Mega"] = 17.85, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 63.27, ["Fly"] = 141.48, ["Ride"] = 111.93, ["Fly|Ride"] = 194.29, ["Neon"] = 240.19, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 559.78, ["Mega|Ride"] = 824.85, ["Mega|Fly|Ride"] = 798.04}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.63, ["Ride"] = 17.59, ["Fly|Ride"] = 39.38, ["Neon"] = 7.88, ["Neon|Ride"] = 42, ["Mega"] = 101.21, ["Mega|Ride"] = 129.84, ["Mega|Fly|Ride"] = 160.13}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 36.75, ["Fly"] = 141.48, ["Ride"] = 82.38, ["Fly|Ride"] = 197.46, ["Neon"] = 168.89, ["Neon|Ride"] = 197.42, ["Neon|Fly|Ride"] = 282.92, ["Mega|Ride"] = 1577.04, ["Mega|Fly|Ride"] = 984.38}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 4.98, ["Fly|Ride"] = 211.18, ["Neon"] = 26.25, ["Neon|Ride"] = 422.25, ["Mega"] = 173.24, ["Mega|Ride"] = 844.48, ["Mega|Fly|Ride"] = 547.98}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 3.49, ["Fly"] = 70.74, ["Ride"] = 70.74, ["Fly|Ride"] = 65.63, ["Neon"] = 10.48, ["Neon|Fly"] = 63.34, ["Neon|Ride"] = 57.02, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 77.34, ["Mega|Ride"] = 569.63, ["Mega|Fly|Ride"] = 563.7}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 17, ["Ride"] = 40.85, ["Fly|Ride"] = 118.02, ["Neon|Ride"] = 225.91, ["Mega|Ride"] = 1126.32, ["Mega|Fly|Ride"] = 1042.93}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.63, ["Fly"] = 131.7, ["Ride"] = 65.63, ["Fly|Ride"] = 908.98, ["Neon"] = 5.65, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 31.64, ["Neon|Fly|Ride"] = 156.23, ["Mega"] = 43.63, ["Mega|Fly"] = 158.61, ["Mega|Ride"] = 82.85, ["Mega|Fly|Ride"] = 278.8}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 46.81, ["Ride"] = 19.65, ["Fly|Ride"] = 72.17, ["Neon"] = 6.2, ["Neon|Fly"] = 41.88, ["Neon|Ride"] = 28.52, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 105.57, ["Mega|Ride"] = 66.94, ["Mega|Fly|Ride"] = 281.86}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 15.85, ["Ride"] = 45.94, ["Fly|Ride"] = 187.59, ["Neon"] = 61.23, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 112.96, ["Mega"] = 418.02, ["Mega|Ride"] = 422.25, ["Mega|Fly|Ride"] = 377.99}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 39.38, ["Ride"] = 47.7, ["Fly|Ride"] = 131.25, ["Neon"] = 104.51, ["Neon|Ride"] = 149.03, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 570.93, ["Mega|Ride"] = 664.13, ["Mega|Fly|Ride"] = 417.95}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 30.18, ["Fly"] = 183.7, ["Ride"] = 34.01, ["Fly|Ride"] = 77.44, ["Neon"] = 103.68, ["Neon|Ride"] = 110.25, ["Neon|Fly|Ride"] = 233.29, ["Mega"] = 625.68, ["Mega|Ride"] = 526.75, ["Mega|Fly|Ride"] = 422.63}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 65.63, ["Fly"] = 196.88, ["Ride"] = 111.51, ["Fly|Ride"] = 157.5, ["Neon"] = 295.21, ["Neon|Ride"] = 263.79, ["Neon|Fly|Ride"] = 522.38, ["Mega"] = 1464.1, ["Mega|Ride"] = 1246.88, ["Mega|Fly|Ride"] = 1239}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 4.51, ["Ride"] = 39.87, ["Fly|Ride"] = 288.75, ["Neon"] = 33.78, ["Neon|Ride"] = 141.47, ["Neon|Fly|Ride"] = 305.76, ["Mega"] = 121.12, ["Mega|Ride"] = 280.81, ["Mega|Fly|Ride"] = 328.79}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 6.18, ["Ride"] = 21.11, ["Fly|Ride"] = 69.7, ["Neon"] = 21.13, ["Neon|Ride"] = 70.74, ["Neon|Fly|Ride"] = 211.13, ["Mega"] = 156.23, ["Mega|Ride"] = 173.25}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 26.25, ["Fly"] = 78.75, ["Ride"] = 39.38, ["Fly|Ride"] = 110.22, ["Neon"] = 124.58, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 134.08, ["Mega"] = 380.63, ["Mega|Fly|Ride"] = 479.07}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.74, ["Ride"] = 14.84, ["Fly|Ride"] = 38.03, ["Neon"] = 2.1, ["Neon|Fly"] = 17.07, ["Neon|Ride"] = 15.85, ["Neon|Fly|Ride"] = 40.69, ["Mega"] = 15.85, ["Mega|Fly"] = 70.74, ["Mega|Ride"] = 33.79, ["Mega|Fly|Ride"] = 105.57}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 52.41, ["Fly"] = 125.65, ["Ride"] = 126.71, ["Fly|Ride"] = 303.01, ["Neon"] = 223.13, ["Neon|Fly"] = 2392.72, ["Neon|Ride"] = 291.37, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 3097.06, ["Mega|Ride"] = 807.19, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 19.09, ["Fly|Ride"] = 109.82, ["Neon"] = 5.97, ["Neon|Ride"] = 42.2, ["Mega"] = 94.95, ["Mega|Fly|Ride"] = 211.13}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 28.25, ["Ride"] = 15.74, ["Fly|Ride"] = 70.71, ["Neon"] = 14.34, ["Neon|Fly"] = 141.44, ["Neon|Ride"] = 28.61, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 157.5, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 253.36}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 94.5, ["Ride"] = 122.15, ["Fly|Ride"] = 157.5, ["Neon"] = 275.52, ["Neon|Ride"] = 318.84, ["Neon|Fly|Ride"] = 511.88, ["Mega"] = 839.98, ["Mega|Ride"] = 985.92, ["Mega|Fly|Ride"] = 917.44}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 42.4, ["Neon"] = 7.35, ["Neon|Ride"] = 39.9, ["Mega"] = 59.07, ["Mega|Ride"] = 113.47, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 11.46}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 20413.45, ["Fly|Ride"] = 262.49, ["Neon"] = 7.12, ["Neon|Ride"] = 63.35, ["Neon|Fly|Ride"] = 87.63, ["Mega"] = 45.4, ["Mega|Ride"] = 115.5, ["Mega|Fly|Ride"] = 1034.25}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 124.69, ["Ride"] = 93.8, ["Fly|Ride"] = 422.35, ["Neon"] = 625.73, ["Neon|Ride"] = 612.25, ["Neon|Fly|Ride"] = 523.69, ["Mega|Fly|Ride"] = 2529.18}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 3.41, ["Ride"] = 28.52, ["Neon"] = 23.24, ["Neon|Ride"] = 61.69, ["Mega"] = 170.63, ["Mega|Ride"] = 239.63, ["Mega|Fly|Ride"] = 468.66}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Neon"] = 5.24, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 35.9, ["Mega|Ride"] = 99.24, ["Mega|Fly|Ride"] = 312.9}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 5.07, ["Ride"] = 35.44, ["Neon"] = 51.1, ["Neon|Ride"] = 112.88, ["Neon|Fly|Ride"] = 168.91, ["Mega"] = 392.68, ["Mega|Ride"] = 563.7, ["Mega|Fly|Ride"] = 625.21}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 11.61, ["Fly"] = 74.97, ["Ride"] = 28.52, ["Fly|Ride"] = 157.5, ["Neon"] = 8.46, ["Neon|Ride"] = 90.67, ["Neon|Fly|Ride"] = 280.81, ["Mega"] = 453.48, ["Mega|Ride"] = 392.44, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 16.49, ["Ride"] = 266.48, ["Fly|Ride"] = 280.86, ["Neon"] = 173.08, ["Neon|Ride"] = 268.13, ["Neon|Fly|Ride"] = 386.36, ["Mega"] = 721.88, ["Mega|Ride"] = 379.32, ["Mega|Fly|Ride"] = 444.93}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 152.24, ["Fly"] = 144.27, ["Ride"] = 133.41, ["Fly|Ride"] = 238.64, ["Neon"] = 597.18, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 589.21, ["Mega|Fly|Ride"] = 2159.07}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 5.69, ["Fly"] = 18.38, ["Ride"] = 11.37, ["Fly|Ride"] = 45.94, ["Neon"] = 33.1, ["Neon|Fly"] = 422.2, ["Neon|Ride"] = 45.93, ["Neon|Fly|Ride"] = 55.79, ["Mega|Ride"] = 422.25, ["Mega|Fly|Ride"] = 222.45}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 3.14, ["Fly"] = 131.23, ["Ride"] = 22.29, ["Fly|Ride"] = 131.25, ["Neon"] = 24.47, ["Neon|Ride"] = 42.16, ["Neon|Fly|Ride"] = 251.95, ["Mega"] = 137.82, ["Mega|Fly|Ride"] = 421.18}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 9.19, ["Fly"] = 234.42, ["Ride"] = 55.13, ["Neon"] = 64.22, ["Neon|Ride"] = 133.49, ["Mega"] = 523.58, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 506.69}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 55.12, ["Ride"] = 65.63, ["Fly|Ride"] = 206.96, ["Neon"] = 210.06, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 304.02, ["Mega"] = 957.43, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 532.23}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 21.13, ["Ride"] = 81.85, ["Neon"] = 126.67, ["Neon|Ride"] = 126.62, ["Mega"] = 602.75, ["Mega|Ride"] = 704.08, ["Mega|Fly|Ride"] = 749.47}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 301.87, ["Ride"] = 365.34, ["Neon"] = 2392.72, ["Neon|Ride"] = 1115.63, ["Neon|Fly|Ride"] = 1688.94, ["Mega|Fly|Ride"] = 4103.04}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 30.19, ["Fly"] = 63.35, ["Ride"] = 38.07, ["Fly|Ride"] = 84.49, ["Neon"] = 262.5, ["Neon|Ride"] = 211.95, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1181.25, ["Mega|Ride"] = 800.14, ["Mega|Fly|Ride"] = 441.83}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 17.4, ["Ride"] = 17.07, ["Fly|Ride"] = 95.04, ["Neon"] = 2.1, ["Neon|Ride"] = 15.84, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 18.36, ["Mega|Fly"] = 99.24, ["Mega|Ride"] = 52.79, ["Mega|Fly|Ride"] = 96.31}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 4.7, ["Ride"] = 59.07, ["Neon"] = 10.5, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 126.97, ["Mega"] = 141.47, ["Mega|Fly"] = 124.69, ["Mega|Ride"] = 89.25, ["Mega|Fly|Ride"] = 370.79}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 3.15, ["Fly"] = 52.5, ["Ride"] = 33.84, ["Neon"] = 18.98, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 1181.25, ["Mega"] = 132.56, ["Mega|Fly"] = 239.63, ["Mega|Ride"] = 281.86, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 362.25, ["Fly"] = 625.87, ["Ride"] = 367.4, ["Fly|Ride"] = 515.82, ["Neon"] = 1684.51, ["Neon|Fly"] = 1830.15, ["Neon|Ride"] = 1688.94, ["Neon|Fly|Ride"] = 1971.83, ["Mega|Ride"] = 6333.47, ["Mega|Fly|Ride"] = 5033.44}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.61, ["Fly"] = 70.74, ["Ride"] = 15.81, ["Fly|Ride"] = 56.44, ["Neon"] = 27.57, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 69.65, ["Mega|Ride"] = 223.12, ["Mega|Fly|Ride"] = 685.13}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 5.13, ["Fly"] = 31.65, ["Ride"] = 20.98, ["Fly|Ride"] = 52.75, ["Neon|Ride"] = 57.02, ["Neon|Fly|Ride"] = 141.47, ["Mega"] = 422.25, ["Mega|Ride"] = 704.08, ["Mega|Fly|Ride"] = 211.13}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 6.3, ["Fly"] = 35.9, ["Ride"] = 27.56, ["Fly|Ride"] = 117.25, ["Neon"] = 23.63, ["Neon|Fly"] = 105, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 114.18, ["Mega"] = 134.93, ["Mega|Ride"] = 111.32, ["Mega|Fly|Ride"] = 177.19}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 31.91, ["Fly"] = 210, ["Ride"] = 46.48, ["Fly|Ride"] = 65.63, ["Neon"] = 118.13, ["Neon|Ride"] = 253.36, ["Neon|Fly|Ride"] = 281.86, ["Mega"] = 656.25, ["Mega|Ride"] = 704.08, ["Mega|Fly|Ride"] = 632.3}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.63, ["Fly"] = 63.31, ["Ride"] = 28.48, ["Fly|Ride"] = 70.75, ["Neon"] = 18.12, ["Neon|Ride"] = 114.19, ["Neon|Fly|Ride"] = 210, ["Mega"] = 137.82, ["Mega|Ride"] = 140.61, ["Mega|Fly|Ride"] = 311.41}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 5.4, ["Fly"] = 104.15, ["Ride"] = 19.69, ["Fly|Ride"] = 91.88, ["Neon"] = 153.04, ["Neon|Ride"] = 106.32, ["Mega"] = 704.08, ["Mega|Ride"] = 312.85, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 49.64, ["Neon"] = 5.25, ["Neon|Ride"] = 39.08, ["Mega"] = 38.98, ["Mega|Ride"] = 112.94, ["Mega|Fly|Ride"] = 281.86}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 15.85, ["Ride"] = 69.57, ["Neon"] = 89.25, ["Mega"] = 239.3, ["Mega|Fly|Ride"] = 6333.47}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 9.09, ["Ride"] = 99.26, ["Neon"] = 78.09, ["Mega"] = 262.5, ["Mega|Ride"] = 374.94, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 15.85, ["Fly"] = 32.82, ["Ride"] = 23.63, ["Fly|Ride"] = 55.13, ["Neon"] = 63.34, ["Neon|Fly"] = 70.56, ["Neon|Ride"] = 58.78, ["Neon|Fly|Ride"] = 121.87, ["Mega"] = 408.52, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 377.22}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 98.18, ["Fly"] = 205.24, ["Ride"] = 201.79, ["Fly|Ride"] = 129.04, ["Neon"] = 850.66, ["Neon|Ride"] = 902.53, ["Neon|Fly|Ride"] = 453.02, ["Mega|Fly|Ride"] = 6333.47}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Fly"] = 21.2, ["Ride"] = 14.97, ["Fly|Ride"] = 45.94, ["Neon"] = 84.45, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 141.36, ["Mega"] = 220.5, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 2.1, ["Ride"] = 31.69, ["Fly|Ride"] = 103.72, ["Neon"] = 9.38, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 166.69, ["Mega"] = 183.75, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 425.25}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 43.31, ["Ride"] = 89.25, ["Fly|Ride"] = 566.26, ["Neon"] = 124.69, ["Neon|Ride"] = 211.29, ["Neon|Fly|Ride"] = 469.88, ["Mega"] = 208.01, ["Mega|Ride"] = 378.31, ["Mega|Fly|Ride"] = 476.63}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 40.21, ["Fly"] = 112.86, ["Ride"] = 63.37, ["Fly|Ride"] = 156.29, ["Neon"] = 467.34, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 380.63, ["Mega|Ride"] = 1791.57, ["Mega|Fly|Ride"] = 1452.3}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 42, ["Ride"] = 92.76, ["Fly|Ride"] = 211.18, ["Neon"] = 92.76, ["Neon|Ride"] = 183.68, ["Neon|Fly|Ride"] = 422.25, ["Mega"] = 262.5, ["Mega|Ride"] = 179.58, ["Mega|Fly|Ride"] = 221.24}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.24, ["Fly"] = 26.25, ["Ride"] = 19.69, ["Fly|Ride"] = 58.97, ["Neon"] = 15.85, ["Mega"] = 125.39, ["Mega|Ride"] = 183.68, ["Mega|Fly|Ride"] = 352.57}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 24.22, ["Ride"] = 65.63, ["Fly|Ride"] = 9150.9, ["Neon"] = 72.19, ["Neon|Fly|Ride"] = 307.13, ["Mega"] = 104.95, ["Mega|Ride"] = 156.18, ["Mega|Fly|Ride"] = 294.67}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 87.83, ["Fly"] = 117.2, ["Ride"] = 96.09, ["Fly|Ride"] = 217.87, ["Neon"] = 197.34, ["Neon|Ride"] = 250.68, ["Neon|Fly|Ride"] = 422.25, ["Mega"] = 347.9, ["Mega|Ride"] = 315.93, ["Mega|Fly|Ride"] = 424.55}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.37, ["Ride"] = 72.18, ["Neon"] = 8.97, ["Neon|Fly"] = 38.01, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 150.56, ["Mega"] = 49.88, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 12.69, ["Ride"] = 281.93, ["Neon"] = 85.32, ["Neon|Ride"] = 162.58, ["Mega"] = 317.68, ["Mega|Ride"] = 422.25, ["Mega|Fly|Ride"] = 332.74}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 739.61, ["Fly"] = 2111.42, ["Ride"] = 984.38, ["Fly|Ride"] = 743.74, ["Neon"] = 3350, ["Neon|Ride"] = 3375.74, ["Neon|Fly|Ride"] = 2623.69, ["Mega|Fly|Ride"] = 12468.75}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 36.63, ["Ride"] = 111.56, ["Fly|Ride"] = 223.85, ["Neon"] = 197.14, ["Neon|Ride"] = 531.57, ["Mega"] = 619.64, ["Mega|Ride"] = 509.25, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 26.25, ["Fly"] = 48.55, ["Ride"] = 41.97, ["Fly|Ride"] = 422.04, ["Neon"] = 21, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 31.64, ["Neon|Fly|Ride"] = 110.15, ["Mega"] = 107.63, ["Mega|Fly"] = 112.96, ["Mega|Ride"] = 83.96, ["Mega|Fly|Ride"] = 501.47}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 28.52, ["Ride"] = 131.22, ["Neon"] = 105.52, ["Mega"] = 366.31, ["Mega|Ride"] = 416.8}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 30.63, ["Fly|Ride"] = 36.98, ["Neon"] = 2.1, ["Neon|Ride"] = 28.48, ["Neon|Fly|Ride"] = 93.75, ["Mega"] = 18.38, ["Mega|Fly"] = 125.63, ["Mega|Ride"] = 141.47, ["Mega|Fly|Ride"] = 213.25}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 75.84, ["Ride"] = 148.47, ["Fly|Ride"] = 283.5, ["Neon"] = 298.07, ["Neon|Ride"] = 341.57, ["Neon|Fly|Ride"] = 810.6, ["Mega"] = 1045.59, ["Mega|Ride"] = 1092.12, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 6.15, ["Fly"] = 101.07, ["Ride"] = 94.84, ["Fly|Ride"] = 69.7, ["Neon"] = 34.26, ["Neon|Ride"] = 84.47, ["Mega"] = 350.46, ["Mega|Ride"] = 263.53, ["Mega|Fly|Ride"] = 296.63}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 4.2, ["Ride"] = 27.47, ["Neon"] = 15.65, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 141.47, ["Mega"] = 147, ["Mega|Ride"] = 239.63, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 52.5, ["Ride"] = 59.14, ["Fly|Ride"] = 149.79, ["Neon"] = 100.22, ["Neon|Ride"] = 219.57, ["Neon|Fly|Ride"] = 597.47, ["Mega"] = 535.5, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 675.59}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 27.43, ["Ride"] = 97.13, ["Fly|Ride"] = 122.49, ["Neon"] = 53.95, ["Neon|Ride"] = 101.95, ["Neon|Fly|Ride"] = 315, ["Mega"] = 563.7, ["Mega|Ride"] = 648.14, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 46.82, ["Ride"] = 141.48, ["Neon"] = 774.38, ["Neon|Ride"] = 844.48, ["Neon|Fly|Ride"] = 1312.1, ["Mega"] = 2533.39, ["Mega|Ride"] = 1408.15, ["Mega|Fly|Ride"] = 2097.43}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 11.58, ["Ride"] = 67.91, ["Neon"] = 28.48, ["Neon|Ride"] = 97.13, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 60.38, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 274.46}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 11.63, ["Fly"] = 28.52, ["Ride"] = 32.71, ["Fly|Ride"] = 70.56, ["Neon"] = 84.49, ["Neon|Ride"] = 63.32, ["Neon|Fly|Ride"] = 277.62, ["Mega"] = 354.37, ["Mega|Ride"] = 392.44, ["Mega|Fly|Ride"] = 462.36}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 131.25, ["Ride"] = 156.26, ["Fly|Ride"] = 228.05, ["Neon"] = 473.89, ["Neon|Ride"] = 432.17, ["Neon|Fly|Ride"] = 633.35, ["Mega|Fly"] = 2815.23, ["Mega|Ride"] = 2361.19, ["Mega|Fly|Ride"] = 2181.89}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 3.82, ["Fly"] = 39.37, ["Ride"] = 17.07, ["Fly|Ride"] = 35.9, ["Neon"] = 11.46, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 25.54, ["Neon|Fly|Ride"] = 77.35, ["Mega"] = 131.25, ["Mega|Ride"] = 136.4, ["Mega|Fly|Ride"] = 209.48}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 5.02, ["Fly"] = 87.94, ["Ride"] = 28.51, ["Fly|Ride"] = 92.87, ["Neon"] = 17.04, ["Neon|Fly"] = 281.17, ["Neon|Ride"] = 49.64, ["Neon|Fly|Ride"] = 99.24, ["Mega"] = 220.5, ["Mega|Ride"] = 183.43, ["Mega|Fly|Ride"] = 196.86}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Ride"] = 13.13, ["Fly|Ride"] = 35.95, ["Neon"] = 2.63, ["Neon|Fly"] = 35.83, ["Neon|Ride"] = 16.86, ["Neon|Fly|Ride"] = 48.49, ["Mega"] = 14.95, ["Mega|Ride"] = 31.49, ["Mega|Fly|Ride"] = 96.87}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 31.69, ["Neon"] = 3.94, ["Neon|Fly"] = 42.24, ["Mega"] = 21, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 63.35, ["Mega|Fly|Ride"] = 139.16}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 3.91, ["Fly"] = 132.4, ["Ride"] = 71.8, ["Neon"] = 27.45, ["Neon|Ride"] = 93.75, ["Mega"] = 134.08, ["Mega|Ride"] = 152.3}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 45.39, ["Ride"] = 315, ["Neon"] = 230.1, ["Neon|Ride"] = 452.82, ["Neon|Fly|Ride"] = 630, ["Mega"] = 774.38, ["Mega|Fly|Ride"] = 572.14}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 3.15, ["Fly"] = 24.94, ["Ride"] = 21.1, ["Fly|Ride"] = 35.89, ["Neon"] = 21, ["Neon|Fly"] = 35.89, ["Neon|Ride"] = 26.14, ["Neon|Fly|Ride"] = 56.44, ["Mega"] = 111.57, ["Mega|Fly"] = 164.06, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 155.8}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 3.15, ["Fly"] = 37.09, ["Ride"] = 31.68, ["Fly|Ride"] = 49.88, ["Neon"] = 20.04, ["Neon|Fly"] = 61.67, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 72.1, ["Mega"] = 125.99, ["Mega|Fly"] = 433.13, ["Mega|Ride"] = 122.68, ["Mega|Fly|Ride"] = 188.76}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Fly"] = 25.76, ["Ride"] = 18.06, ["Fly|Ride"] = 85.32, ["Neon"] = 8.86, ["Neon|Fly"] = 98.44, ["Neon|Ride"] = 27.45, ["Neon|Fly|Ride"] = 107.68, ["Mega"] = 103.68, ["Mega|Fly"] = 145.68, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 141.47}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 15.7, ["Fly"] = 280.84, ["Ride"] = 26.17, ["Neon"] = 33.79, ["Neon|Ride"] = 83.42, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 251.24, ["Mega|Fly"] = 292.92, ["Mega|Ride"] = 240.69, ["Mega|Fly|Ride"] = 625.68}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 6.24, ["Fly"] = 154.02, ["Ride"] = 60.38, ["Fly|Ride"] = 131.25, ["Neon"] = 46.89, ["Neon|Ride"] = 99.16, ["Mega"] = 223.13, ["Mega|Ride"] = 421.18}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 3.84, ["Fly"] = 35.44, ["Ride"] = 22.05, ["Fly|Ride"] = 56.99, ["Neon"] = 34, ["Neon|Fly"] = 196.65, ["Neon|Ride"] = 46.99, ["Mega"] = 173.78, ["Mega|Ride"] = 235.94, ["Mega|Fly|Ride"] = 338.63}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Ride"] = 16.86, ["Fly|Ride"] = 52.5, ["Neon"] = 15.21, ["Neon|Fly"] = 84.45, ["Neon|Ride"] = 30.48, ["Neon|Fly|Ride"] = 63.37, ["Mega"] = 223.13, ["Mega|Ride"] = 234.71, ["Mega|Fly|Ride"] = 223.6}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 234.88, ["Fly"] = 393.75, ["Ride"] = 210, ["Fly|Ride"] = 305.82, ["Neon"] = 944.64, ["Neon|Ride"] = 818.85, ["Neon|Fly|Ride"] = 1179.94, ["Mega|Fly|Ride"] = 3155.25}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 5.86, ["Ride"] = 30.49, ["Neon"] = 31.4, ["Neon|Fly|Ride"] = 281.86, ["Mega"] = 123.38, ["Mega|Ride"] = 211.13, ["Mega|Fly|Ride"] = 492.97}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 5.24, ["Ride"] = 24.28, ["Fly|Ride"] = 99.75, ["Neon"] = 28.52, ["Neon|Ride"] = 48.58, ["Neon|Fly|Ride"] = 139.65, ["Mega"] = 167.43, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 1171.65}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 5.18, ["Fly|Ride"] = 157.11, ["Neon"] = 31.66, ["Neon|Fly|Ride"] = 633.35, ["Mega"] = 466.33, ["Mega|Ride"] = 422.25, ["Mega|Fly|Ride"] = 1007.35}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 17.07, ["Fly|Ride"] = 35.86, ["Neon"] = 2.63, ["Neon|Fly"] = 42.24, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 37.85, ["Mega"] = 13.13, ["Mega|Fly"] = 70.74, ["Mega|Ride"] = 34.13, ["Mega|Fly|Ride"] = 67.52}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 4.71, ["Fly"] = 56.25, ["Ride"] = 20.9, ["Fly|Ride"] = 57.03, ["Neon"] = 11.82, ["Neon|Ride"] = 28.49, ["Neon|Fly|Ride"] = 99.49, ["Mega"] = 131.25, ["Mega|Ride"] = 142.96, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 3.82, ["Ride"] = 42.25, ["Neon"] = 6.35, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 62.22, ["Mega|Ride"] = 126.69, ["Mega|Fly|Ride"] = 234.35}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 70.56, ["Fly"] = 185.82, ["Ride"] = 100.64, ["Fly|Ride"] = 150.94, ["Neon"] = 666.01, ["Neon|Ride"] = 328.12, ["Neon|Fly|Ride"] = 455.44, ["Mega|Ride"] = 3520.35, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 6.35, ["Fly"] = 85.32, ["Ride"] = 42, ["Fly|Ride"] = 65.54, ["Neon"] = 24.68, ["Neon|Ride"] = 57.02, ["Neon|Fly|Ride"] = 312.85, ["Mega"] = 215.36, ["Mega|Ride"] = 312.85, ["Mega|Fly|Ride"] = 253.36}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 31.68, ["Ride"] = 52.5, ["Fly|Ride"] = 164.73, ["Neon"] = 12.9, ["Neon|Ride"] = 57.02, ["Neon|Fly|Ride"] = 168.91, ["Mega"] = 67.57, ["Mega|Fly"] = 411.7, ["Mega|Ride"] = 99.24, ["Mega|Fly|Ride"] = 225.91}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 63, ["Fly"] = 124.69, ["Ride"] = 111.92, ["Fly|Ride"] = 211.18, ["Neon"] = 153.57, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 332.07, ["Mega"] = 551.25, ["Mega|Ride"] = 738.94, ["Mega|Fly|Ride"] = 1006.69}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Ride"] = 15.85, ["Fly|Ride"] = 36.98, ["Neon"] = 2.1, ["Neon|Fly"] = 21, ["Neon|Ride"] = 16.9, ["Neon|Fly|Ride"] = 45.71, ["Mega"] = 21.76, ["Mega|Fly"] = 27.45, ["Mega|Ride"] = 26.25, ["Mega|Fly|Ride"] = 39.38}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Fly|Ride"] = 57.03, ["Neon"] = 5.24, ["Neon|Ride"] = 42.24, ["Neon|Fly|Ride"] = 99.24, ["Mega"] = 27.57, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 148.32}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 157.11, ["Neon"] = 10.49, ["Neon|Ride"] = 58.68, ["Neon|Fly|Ride"] = 197.42, ["Mega"] = 61.69, ["Mega|Ride"] = 96.45}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 6.6, ["Fly"] = 112.97, ["Ride"] = 39.38, ["Fly|Ride"] = 113, ["Neon"] = 28.48, ["Neon|Fly"] = 57.02, ["Neon|Ride"] = 57.23, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 105.57, ["Mega|Fly"] = 203.88, ["Mega|Ride"] = 125.94, ["Mega|Fly|Ride"] = 263.82}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 15.74, ["Ride"] = 12.69, ["Fly|Ride"] = 34.13, ["Neon"] = 2.63, ["Neon|Ride"] = 35.18, ["Neon|Fly|Ride"] = 54.6, ["Mega"] = 13.25, ["Mega|Ride"] = 41.15, ["Mega|Fly|Ride"] = 126.69}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 11.42, ["Ride"] = 42.25, ["Fly|Ride"] = 200.48, ["Neon"] = 80.22, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 183.68, ["Mega"] = 253.36, ["Mega|Ride"] = 473.96}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 3172.32, ["Fly"] = 3150, ["Ride"] = 2737.49, ["Fly|Ride"] = 2754.94, ["Neon|Fly|Ride"] = 9355.5}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 73.92, ["Ride"] = 21.13, ["Fly|Ride"] = 40.09, ["Neon"] = 7.48, ["Neon|Fly"] = 68.5, ["Neon|Ride"] = 23.24, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 99.24, ["Mega|Ride"] = 99.24, ["Mega|Fly|Ride"] = 142.38}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 4.71, ["Ride"] = 35.9, ["Neon"] = 12.47, ["Mega"] = 126, ["Mega|Ride"] = 437.07, ["Mega|Fly|Ride"] = 633.35}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 19.43, ["Ride"] = 32.82, ["Fly|Ride"] = 157.5, ["Neon"] = 103.69, ["Neon|Ride"] = 112.88, ["Neon|Fly|Ride"] = 141.47, ["Mega"] = 557.36, ["Mega|Ride"] = 397.69, ["Mega|Fly|Ride"] = 506.69}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 42.25, ["Ride"] = 92.93, ["Neon"] = 131.25, ["Mega"] = 738.91, ["Mega|Ride"] = 725.26, ["Mega|Fly|Ride"] = 728.8}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 138.76, ["Fly"] = 281.72, ["Ride"] = 174.32, ["Fly|Ride"] = 279.57, ["Neon"] = 1312.5, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 625.44, ["Neon|Fly|Ride"] = 717.81, ["Mega"] = 6333.47, ["Mega|Ride"] = 3026.35, ["Mega|Fly|Ride"] = 2362.5}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 5.46, ["Ride"] = 57.03, ["Fly|Ride"] = 675.94, ["Neon"] = 21.13, ["Neon|Fly"] = 70.73, ["Neon|Ride"] = 126.69, ["Neon|Fly|Ride"] = 105.52, ["Mega"] = 223.13, ["Mega|Fly"] = 157.02, ["Mega|Ride"] = 180.52, ["Mega|Fly|Ride"] = 253.09}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Neon"] = 14.43, ["Neon|Fly"] = 99.23, ["Neon|Ride"] = 42.24, ["Mega"] = 157.02, ["Mega|Ride"] = 261.03, ["Mega|Fly|Ride"] = 833.05}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Fly"] = 101.95, ["Ride"] = 34.48, ["Fly|Ride"] = 91.88, ["Neon"] = 9.19, ["Neon|Ride"] = 44.63, ["Mega"] = 71.79, ["Mega|Ride"] = 99.63, ["Mega|Fly|Ride"] = 287.44}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 14.3, ["Neon"] = 105.56, ["Neon|Ride"] = 1548.54, ["Neon|Fly|Ride"] = 211.13, ["Mega"] = 459.38, ["Mega|Ride"] = 421.18, ["Mega|Fly|Ride"] = 399.03}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 70.71, ["Neon"] = 2.5, ["Neon|Ride"] = 32.71, ["Mega"] = 11.82, ["Mega|Ride"] = 133.88, ["Mega|Fly|Ride"] = 281.86}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 82.69, ["Fly"] = 57.03, ["Ride"] = 110.22, ["Fly|Ride"] = 131.06, ["Neon"] = 369.42, ["Neon|Ride"] = 409.5, ["Neon|Fly|Ride"] = 418.69, ["Mega|Ride"] = 1415.61, ["Mega|Fly|Ride"] = 1718.81}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 32.65, ["Neon"] = 6.36, ["Neon|Ride"] = 100.29, ["Mega"] = 93.75, ["Mega|Ride"] = 120.28}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 46.91, ["Fly"] = 219.18, ["Ride"] = 76.13, ["Fly|Ride"] = 149.94, ["Neon"] = 265.92, ["Neon|Ride"] = 364.97, ["Neon|Fly|Ride"] = 421.63, ["Mega"] = 2625, ["Mega|Ride"] = 2815.23, ["Mega|Fly|Ride"] = 1156.32}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 33.79, ["Ride"] = 52.5, ["Fly|Ride"] = 70.7, ["Neon"] = 6.35, ["Neon|Ride"] = 73.82, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 52.5, ["Mega|Ride"] = 69.68, ["Mega|Fly|Ride"] = 209.35}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Ride"] = 2253.16, ["Neon"] = 14.34, ["Neon|Ride"] = 91.88, ["Mega"] = 72.19, ["Mega|Ride"] = 166.49, ["Mega|Fly|Ride"] = 548.91}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 14.33, ["Ride"] = 210, ["Fly|Ride"] = 210.13, ["Neon"] = 63.3, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 690.36, ["Mega"] = 249.13, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 922.59}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 273.55, ["Ride"] = 393.75, ["Fly|Ride"] = 282.09, ["Neon"] = 762.25, ["Neon|Fly"] = 1477.64, ["Neon|Ride"] = 725.63, ["Neon|Fly|Ride"] = 842.39, ["Mega"] = 4103.04, ["Mega|Ride"] = 3806.25, ["Mega|Fly|Ride"] = 3409.88}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 40.69, ["Fly"] = 53.85, ["Ride"] = 52.5, ["Fly|Ride"] = 81.38, ["Neon"] = 105.56, ["Neon|Fly"] = 312.87, ["Neon|Ride"] = 166.53, ["Neon|Fly|Ride"] = 193.18, ["Mega|Ride"] = 695.64, ["Mega|Fly|Ride"] = 905.63}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 32.74, ["Ride"] = 21.13, ["Fly|Ride"] = 72.19, ["Neon"] = 7.3, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 21.11, ["Neon|Fly|Ride"] = 91.77, ["Mega"] = 84.47, ["Mega|Ride"] = 71.19, ["Mega|Fly|Ride"] = 625.68}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 15.65, ["Fly"] = 109.8, ["Ride"] = 45.94, ["Fly|Ride"] = 94.49, ["Neon"] = 17.97, ["Neon|Fly"] = 197.38, ["Neon|Ride"] = 86.63, ["Neon|Fly|Ride"] = 168.91, ["Mega"] = 215.25, ["Mega|Fly"] = 392.68, ["Mega|Ride"] = 234.33, ["Mega|Fly|Ride"] = 181.54}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 7.72, ["Ride"] = 28.48, ["Fly|Ride"] = 70.75, ["Neon"] = 105, ["Neon|Ride"] = 95.02, ["Mega|Ride"] = 468.15, ["Mega|Fly|Ride"] = 527.25}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 6.57, ["Neon"] = 19.02, ["Mega"] = 62.89, ["Mega|Ride"] = 84}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.37, ["Fly"] = 86.63, ["Ride"] = 20.01, ["Fly|Ride"] = 66.42, ["Neon"] = 26.25, ["Neon|Ride"] = 46.47, ["Neon|Fly|Ride"] = 215.36, ["Mega"] = 547.18, ["Mega|Ride"] = 422.25, ["Mega|Fly|Ride"] = 492.97}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 100.26, ["Fly"] = 131.25, ["Ride"] = 141.75, ["Fly|Ride"] = 307.26, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 686.85, ["Mega"] = 2419.39, ["Mega|Ride"] = 2561.89, ["Mega|Fly|Ride"] = 2811.01}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 12.44, ["Fly"] = 78.54, ["Ride"] = 63.24, ["Fly|Ride"] = 144, ["Neon"] = 183.75, ["Neon|Ride"] = 189.68, ["Mega"] = 696.7, ["Mega|Ride"] = 699.86, ["Mega|Fly|Ride"] = 781.5}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2218.13, ["Fly"] = 2349.23, ["Ride"] = 2100, ["Fly|Ride"] = 2415, ["Neon"] = 12665.38, ["Neon|Fly|Ride"] = 7600.16, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 2.51, ["Fly"] = 65625, ["Ride"] = 35.89, ["Fly|Ride"] = 170.63, ["Neon"] = 13.02, ["Neon|Ride"] = 35.9, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 105, ["Mega|Ride"] = 169.32, ["Mega|Fly|Ride"] = 422.6}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 7.55, ["Ride"] = 88.7, ["Neon"] = 42.24, ["Neon|Ride"] = 54.9, ["Mega"] = 182.44, ["Mega|Ride"] = 337.72, ["Mega|Fly|Ride"] = 547.18}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 905.63, ["Fly"] = 1408.33, ["Ride"] = 609.46, ["Fly|Ride"] = 638.19, ["Neon"] = 2598.75, ["Neon|Ride"] = 3150, ["Neon|Fly|Ride"] = 3150, ["Mega|Fly|Ride"] = 16888.15}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 45.94, ["Ride"] = 66.09, ["Fly|Ride"] = 211.18, ["Neon"] = 234.38, ["Neon|Ride"] = 291.72, ["Neon|Fly|Ride"] = 380.02, ["Mega"] = 840, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 752.07}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 2.1, ["Ride"] = 33.76, ["Neon"] = 17.57, ["Neon|Ride"] = 73.9, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 202.65, ["Mega|Ride"] = 349.41, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Neon"] = 3.93, ["Neon|Ride"] = 52.5, ["Mega"] = 26.17, ["Mega|Ride"] = 68.25, ["Mega|Fly|Ride"] = 126.69}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 91.82, ["Ride"] = 125.99, ["Neon"] = 704, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 5250, ["Mega|Fly|Ride"] = 2533.39}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 7.87, ["Ride"] = 141.49, ["Neon"] = 19.69, ["Neon|Ride"] = 98.43, ["Neon|Fly|Ride"] = 129.85, ["Mega"] = 175.24, ["Mega|Ride"] = 183.74}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 109.75, ["Ride"] = 291.38, ["Neon"] = 514.02, ["Neon|Ride"] = 525, ["Mega"] = 2111.17, ["Mega|Fly|Ride"] = 1687.91}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 4.85, ["Fly"] = 105, ["Fly|Ride"] = 91.88, ["Neon"] = 32.81, ["Neon|Fly|Ride"] = 315, ["Mega"] = 223.5}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 145.68, ["Ride"] = 255.92, ["Fly|Ride"] = 347.82, ["Neon"] = 1094.45, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 960.7, ["Mega|Fly|Ride"] = 3908.81}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 3.54, ["Fly"] = 28.5, ["Ride"] = 24.94, ["Fly|Ride"] = 111.93, ["Neon"] = 42.24, ["Neon|Ride"] = 48.57, ["Neon|Fly|Ride"] = 124.51, ["Mega"] = 225.75, ["Mega|Ride"] = 311.07, ["Mega|Fly|Ride"] = 432.64}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 18.15, ["Ride"] = 16.49, ["Fly|Ride"] = 42.25, ["Neon"] = 3.83, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 21.11, ["Neon|Fly|Ride"] = 52.79, ["Mega"] = 39.38, ["Mega|Fly"] = 104.87, ["Mega|Ride"] = 68.25, ["Mega|Fly|Ride"] = 77.55}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 832.13, ["Fly"] = 1112.72, ["Ride"] = 903, ["Fly|Ride"] = 984.38, ["Neon|Ride"] = 7741.6, ["Neon|Fly|Ride"] = 4222.31, ["Mega"] = 28119.3}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 9.18, ["Fly"] = 986.04, ["Ride"] = 42.25, ["Neon"] = 42.3, ["Mega"] = 116.12, ["Mega|Ride"] = 136.16, ["Mega|Fly|Ride"] = 416.97}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 15.85, ["Fly"] = 47.25, ["Ride"] = 52.5, ["Neon"] = 23.42, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 181.61, ["Mega"] = 139.94, ["Mega|Ride"] = 187, ["Mega|Fly|Ride"] = 256.18}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 62.3, ["Fly"] = 44.54, ["Ride"] = 47.23, ["Fly|Ride"] = 79.2, ["Neon|Ride"] = 122.58, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 2111.17, ["Mega|Fly|Ride"] = 738.91}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 24.26, ["Fly"] = 79.2, ["Ride"] = 36.98, ["Fly|Ride"] = 116.82, ["Neon"] = 59.07, ["Neon|Ride"] = 99.24, ["Neon|Fly|Ride"] = 211.13, ["Mega"] = 393.75, ["Mega|Ride"] = 281.86, ["Mega|Fly|Ride"] = 442.31}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 27.39, ["Ride"] = 65.63, ["Fly|Ride"] = 105, ["Neon"] = 117.2, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 703.74, ["Mega|Ride"] = 497.19, ["Mega|Fly|Ride"] = 416.07}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 116.59, ["Fly|Ride"] = 234.48, ["Neon"] = 2.1, ["Neon|Ride"] = 31.68, ["Mega"] = 16.9, ["Mega|Ride"] = 141.47}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 41.99, ["Fly"] = 48.57, ["Ride"] = 41.62, ["Fly|Ride"] = 51.08, ["Neon"] = 270.26, ["Neon|Ride"] = 232.32, ["Neon|Fly|Ride"] = 242.82, ["Mega"] = 3377.85, ["Mega|Fly|Ride"] = 1112.58}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 4.24, ["Fly"] = 89.66, ["Ride"] = 27.56, ["Fly|Ride"] = 112.91, ["Neon"] = 42, ["Neon|Ride"] = 141.07, ["Neon|Fly|Ride"] = 141.47, ["Mega"] = 773.07, ["Mega|Ride"] = 271.69, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.63, ["Fly"] = 26.16, ["Ride"] = 21.11, ["Fly|Ride"] = 53.86, ["Neon"] = 35.85, ["Neon|Ride"] = 42.24, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 1040.82, ["Mega|Ride"] = 281.86, ["Mega|Fly|Ride"] = 203.44}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 2.92, ["Ride"] = 126.71, ["Neon"] = 26.24, ["Neon|Fly|Ride"] = 105.57, ["Mega"] = 262.5, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 468.66}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 10.41, ["Fly"] = 262.13, ["Ride"] = 57.03, ["Neon"] = 89.7, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 228.02, ["Mega|Ride"] = 634.76, ["Mega|Fly|Ride"] = 620.69}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 6.57, ["Neon"] = 23.55, ["Neon|Ride"] = 63.27, ["Mega"] = 104.84, ["Mega|Fly"] = 704.08, ["Mega|Fly|Ride"] = 312.85}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 27.47, ["Neon"] = 2.24, ["Neon|Ride"] = 31.64, ["Mega"] = 27.45, ["Mega|Ride"] = 51.19, ["Mega|Fly|Ride"] = 203.44}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Ride"] = 27.09, ["Neon"] = 2.1, ["Neon|Fly"] = 393.59, ["Neon|Ride"] = 28.54, ["Neon|Fly|Ride"] = 78.52, ["Mega"] = 20.07, ["Mega|Fly"] = 73.86, ["Mega|Ride"] = 48.58, ["Mega|Fly|Ride"] = 82.27}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 25.89, ["Ride"] = 24, ["Fly|Ride"] = 40.05, ["Neon"] = 5.24, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 84.38, ["Mega"] = 105.57, ["Mega|Ride"] = 126.69, ["Mega|Fly|Ride"] = 242.17}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.63, ["Ride"] = 28.58, ["Fly|Ride"] = 57.03, ["Neon"] = 15.83, ["Neon|Ride"] = 70.74, ["Mega"] = 141.47, ["Mega|Ride"] = 147.72, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 3.15, ["Fly"] = 26.22, ["Ride"] = 17.07, ["Fly|Ride"] = 37.99, ["Neon"] = 16.89, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 80.07, ["Mega"] = 297.68, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 363.56}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 68.17, ["Fly|Ride"] = 394.9, ["Neon"] = 203.97, ["Neon|Ride"] = 409.58, ["Mega"] = 1027.08, ["Mega|Fly"] = 944.75, ["Mega|Ride"] = 899.07, ["Mega|Fly|Ride"] = 461.39}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 26.19, ["Ride"] = 21.11, ["Fly|Ride"] = 31.66, ["Neon"] = 3.82, ["Neon|Fly"] = 28.5, ["Neon|Ride"] = 20.9, ["Neon|Fly|Ride"] = 56.85, ["Mega"] = 40.69, ["Mega|Ride"] = 55.11, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 9.86, ["Fly"] = 31.63, ["Ride"] = 46.9, ["Fly|Ride"] = 70.75, ["Neon"] = 51.35, ["Neon|Fly"] = 70.7, ["Neon|Ride"] = 57.73, ["Neon|Fly|Ride"] = 108.52, ["Mega"] = 328.13, ["Mega|Ride"] = 311.33, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 15.72, ["Fly"] = 46.9, ["Ride"] = 27.56, ["Fly|Ride"] = 70.97, ["Neon"] = 65.63, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 116.82, ["Mega"] = 1266.7, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 479.25}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 2.92, ["Fly"] = 140.38, ["Ride"] = 46.86, ["Neon"] = 19.85, ["Neon|Ride"] = 70.74, ["Mega"] = 196.87, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 352.57}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 17.33, ["Fly|Ride"] = 141.49, ["Neon"] = 3.62, ["Neon|Fly"] = 59.07, ["Neon|Ride"] = 22.28, ["Neon|Fly|Ride"] = 64.32, ["Mega"] = 41.2, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 141.47}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 6.46, ["Ride"] = 26.25, ["Fly|Ride"] = 141.39, ["Neon"] = 12.94, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 100.26, ["Neon|Fly|Ride"] = 158.34, ["Mega"] = 116.82, ["Mega|Fly"] = 735, ["Mega|Ride"] = 134.08, ["Mega|Fly|Ride"] = 283.5}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 1050, ["Ride"] = 911.22, ["Fly|Ride"] = 763.45, ["Neon|Ride"] = 2266.69, ["Neon|Fly|Ride"] = 2283.75, ["Mega|Fly|Ride"] = 7434}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 65.63, ["Ride"] = 87.94, ["Neon"] = 260.24, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 302.97, ["Mega"] = 1213.92, ["Mega|Ride"] = 1203.37, ["Mega|Fly|Ride"] = 1168.41}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Fly"] = 73.92, ["Neon"] = 5.25, ["Neon|Ride"] = 74.96, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 65.54, ["Mega|Fly|Ride"] = 157.02}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 16.75, ["Ride"] = 44.46, ["Fly|Ride"] = 156.29, ["Neon"] = 183.41, ["Neon|Ride"] = 225.67, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 1250.16, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 6.57, ["Ride"] = 27.01, ["Fly|Ride"] = 280.86, ["Neon"] = 39.38, ["Neon|Ride"] = 282.09, ["Neon|Fly|Ride"] = 281.86, ["Mega"] = 252, ["Mega|Fly|Ride"] = 1055.59}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 269.05, ["Fly"] = 324.12, ["Ride"] = 290.07, ["Fly|Ride"] = 313.03, ["Neon|Ride"] = 1319.48, ["Neon|Fly|Ride"] = 1048.95, ["Mega|Fly|Ride"] = 4363.76}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.6, ["Fly"] = 102.38, ["Ride"] = 22.32, ["Fly|Ride"] = 129.93, ["Neon"] = 19.69, ["Mega"] = 393.75, ["Mega|Fly"] = 281.86}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Fly|Ride"] = 704.26, ["Neon"] = 57.02, ["Neon|Ride"] = 141.47, ["Mega|Ride"] = 337.8}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 42, ["Ride"] = 121.43, ["Fly|Ride"] = 282.96, ["Neon"] = 131.25, ["Neon|Ride"] = 416.97, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 793.8, ["Mega|Ride"] = 714.67, ["Mega|Fly|Ride"] = 796.97}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 3.56, ["Ride"] = 48.51, ["Neon"] = 21, ["Mega"] = 247.02, ["Mega|Ride"] = 277.62}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 15.91, ["Fly|Ride"] = 32.82, ["Neon"] = 3.93, ["Neon|Fly"] = 31.66, ["Neon|Ride"] = 17.59, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 31.48, ["Mega|Fly"] = 31.64, ["Mega|Ride"] = 41.19, ["Mega|Fly|Ride"] = 89.2}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4199.9, ["Ride"] = 4318.13, ["Fly|Ride"] = 3937.5, ["Neon"] = 17187.48, ["Neon|Fly|Ride"] = 21359.63, ["Mega|Fly|Ride"] = 87261.22}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 7.24, ["Ride"] = 31.67, ["Neon"] = 173.44, ["Neon|Ride"] = 126.69, ["Mega"] = 328.13, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Ride"] = 28.14, ["Fly|Ride"] = 42, ["Neon"] = 16.78, ["Neon|Ride"] = 32.73, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 285.02, ["Mega|Ride"] = 124.35, ["Mega|Fly|Ride"] = 203.99}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 370.72, ["Fly"] = 506.75, ["Ride"] = 444.94, ["Fly|Ride"] = 525, ["Neon"] = 1050, ["Neon|Fly"] = 1455.57, ["Neon|Ride"] = 1594.69, ["Neon|Fly|Ride"] = 1515.87, ["Mega|Fly|Ride"] = 6052.68}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 5.2, ["Ride"] = 52.5, ["Neon"] = 14.44, ["Neon|Ride"] = 158.06, ["Mega"] = 141.47, ["Mega|Fly|Ride"] = 690.38}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 4.97, ["Fly"] = 110.12, ["Ride"] = 32.74, ["Fly|Ride"] = 105.59, ["Neon"] = 91.88, ["Neon|Ride"] = 281.86, ["Neon|Fly|Ride"] = 142.52, ["Mega"] = 386.54, ["Mega|Ride"] = 401.63}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Ride"] = 28.52, ["Fly|Ride"] = 82.55, ["Neon"] = 7.55, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 33.9, ["Neon|Fly|Ride"] = 70.86, ["Mega"] = 39.38, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 141.47}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 627.38, ["Ride"] = 590.63, ["Fly|Ride"] = 689.06, ["Neon|Fly|Ride"] = 1967.44, ["Mega|Fly|Ride"] = 8751.75}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 9.03, ["Ride"] = 55.12, ["Neon"] = 26.17, ["Neon|Ride"] = 108.94, ["Neon|Fly|Ride"] = 648.38, ["Mega"] = 150.94, ["Mega|Ride"] = 252.29, ["Mega|Fly|Ride"] = 213.51}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 12.91, ["Fly"] = 168.93, ["Ride"] = 61.6, ["Fly|Ride"] = 131.25, ["Neon"] = 47.25, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 3907.43, ["Mega"] = 210, ["Mega|Ride"] = 227.67, ["Mega|Fly|Ride"] = 333.58}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 4.24, ["Fly"] = 23.21, ["Ride"] = 22.95, ["Fly|Ride"] = 55.12, ["Neon"] = 17.05, ["Neon|Ride"] = 28.46, ["Neon|Fly|Ride"] = 61.69, ["Mega"] = 183.75, ["Mega|Ride"] = 168.91, ["Mega|Fly|Ride"] = 201.63}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 42.21, ["Ride"] = 54.87, ["Neon"] = 99.23, ["Neon|Ride"] = 126.69, ["Neon|Fly|Ride"] = 312.85, ["Mega"] = 560.53, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 729.94}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Ride"] = 39.37, ["Neon"] = 3.93, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 69.68, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 13.25, ["Mega|Ride"] = 87.55, ["Mega|Fly|Ride"] = 177.19}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 481.03, ["Ride"] = 485.63, ["Fly|Ride"] = 624.01, ["Neon"] = 2084.53, ["Neon|Ride"] = 2092.16, ["Neon|Fly|Ride"] = 2343.28, ["Mega|Ride"] = 9138.78, ["Mega|Fly|Ride"] = 7848.75}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 93.8, ["Neon"] = 5.92, ["Neon|Ride"] = 42.24, ["Neon|Fly|Ride"] = 112.35, ["Mega"] = 65.62, ["Mega|Ride"] = 59.58, ["Mega|Fly|Ride"] = 122.92}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 27.3, ["Neon"] = 3.93, ["Neon|Ride"] = 210.91, ["Mega"] = 36.75, ["Mega|Ride"] = 83.42, ["Mega|Fly|Ride"] = 264.96}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 60.37, ["Neon"] = 5.25, ["Neon|Ride"] = 45.91, ["Mega"] = 41.15, ["Mega|Fly"] = 156.23, ["Mega|Ride"] = 105.57}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 3.71, ["Ride"] = 131.25, ["Neon"] = 17.07, ["Mega"] = 211.13, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 37.51, ["Ride"] = 67.17, ["Fly|Ride"] = 280.86, ["Neon"] = 223.13, ["Neon|Ride"] = 248.4, ["Neon|Fly|Ride"] = 350.46, ["Mega"] = 293.09, ["Mega|Ride"] = 313.71, ["Mega|Fly|Ride"] = 671.35}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 17.59, ["Fly"] = 69.57, ["Ride"] = 61.24, ["Neon"] = 87.28, ["Neon|Ride"] = 131.25, ["Mega"] = 463.1, ["Mega|Fly|Ride"] = 282.84}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 19.67, ["Fly|Ride"] = 36.23, ["Neon"] = 30.38, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 56.97, ["Mega"] = 308.44, ["Mega|Ride"] = 206.91, ["Mega|Fly|Ride"] = 246.48}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 13.13, ["Ride"] = 42.25, ["Neon"] = 180.47, ["Neon|Ride"] = 158.82, ["Neon|Fly|Ride"] = 211.13, ["Mega|Ride"] = 781.5, ["Mega|Fly|Ride"] = 982.76}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 3.92, ["Ride"] = 32.74, ["Fly|Ride"] = 362.25, ["Neon"] = 9.48, ["Neon|Ride"] = 43.73, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 91.48, ["Mega|Ride"] = 183.68, ["Mega|Fly|Ride"] = 243.86}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 17.07, ["Fly"] = 69.57, ["Ride"] = 31.66, ["Fly|Ride"] = 56.44, ["Neon"] = 228.74, ["Neon|Ride"] = 134.08, ["Neon|Fly|Ride"] = 126.69, ["Mega"] = 948.97, ["Mega|Ride"] = 937.32, ["Mega|Fly|Ride"] = 781.5}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 70.75, ["Fly"] = 874.13, ["Neon"] = 131.25, ["Mega"] = 353.07, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 63.37, ["Fly"] = 115.5, ["Ride"] = 94.39, ["Fly|Ride"] = 139.12, ["Neon"] = 287.1, ["Neon|Fly"] = 348.04, ["Neon|Ride"] = 299.25, ["Neon|Fly|Ride"] = 434.89, ["Mega|Ride"] = 1328.65, ["Mega|Fly|Ride"] = 1164.32}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 43.32, ["Fly"] = 141.48, ["Ride"] = 82.29, ["Neon"] = 168.79, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 329.36, ["Mega"] = 672.54, ["Mega|Ride"] = 670.3, ["Mega|Fly|Ride"] = 612.94}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 19.59, ["Ride"] = 79.2, ["Neon"] = 211.04, ["Neon|Ride"] = 39.38, ["Mega"] = 560.38, ["Mega|Ride"] = 1084.09, ["Mega|Fly|Ride"] = 1265.65}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 6.57, ["Fly"] = 52.5, ["Ride"] = 31.61, ["Fly|Ride"] = 97.15, ["Neon"] = 36.84, ["Neon|Fly"] = 168.89, ["Neon|Ride"] = 99.24, ["Neon|Fly|Ride"] = 141.47, ["Mega"] = 457.47, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 28.52, ["Ride"] = 16.89, ["Fly|Ride"] = 42.25, ["Neon"] = 5.16, ["Neon|Fly"] = 24.89, ["Neon|Ride"] = 21.13, ["Neon|Fly|Ride"] = 57.75, ["Mega"] = 42, ["Mega|Fly"] = 704.08, ["Mega|Ride"] = 63, ["Mega|Fly|Ride"] = 185.79}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 969.94}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 21.77, ["Ride"] = 105.59, ["Fly|Ride"] = 126.71, ["Neon"] = 134.06, ["Neon|Ride"] = 139.13, ["Neon|Fly|Ride"] = 421.8, ["Mega"] = 563.7, ["Mega|Ride"] = 547.18, ["Mega|Fly|Ride"] = 504}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 39.87, ["Neon"] = 3.59, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 295.58, ["Mega"] = 19.69, ["Mega|Ride"] = 85.22, ["Mega|Fly|Ride"] = 537.79}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 30.19, ["Ride"] = 65.63, ["Fly|Ride"] = 274.54, ["Neon"] = 210, ["Neon|Ride"] = 311.41, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 630, ["Mega|Ride"] = 821.25, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 105, ["Mega"] = 37.94}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 5.25, ["Neon|Ride"] = 157.02, ["Mega"] = 41, ["Mega|Ride"] = 120.35, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 110.38, ["Ride"] = 168.93, ["Fly|Ride"] = 234.41, ["Neon"] = 563.62, ["Neon|Ride"] = 591.14, ["Neon|Fly|Ride"] = 612.03, ["Mega|Ride"] = 6444.01, ["Mega|Fly|Ride"] = 2034.38}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.63, ["Fly"] = 26.11, ["Ride"] = 24.05, ["Fly|Ride"] = 126.71, ["Neon"] = 13.1, ["Neon|Ride"] = 40.13, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 107.63, ["Mega|Ride"] = 99.24, ["Mega|Fly|Ride"] = 256.6}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 30.97, ["Ride"] = 65.63, ["Fly|Ride"] = 86.63, ["Neon"] = 3.93, ["Neon|Ride"] = 57.02, ["Neon|Fly|Ride"] = 101.35, ["Mega"] = 36.75, ["Mega|Ride"] = 93.19, ["Mega|Fly|Ride"] = 98.44}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Fly"] = 44.63, ["Neon"] = 3.86, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 35.44, ["Mega"] = 28.38, ["Mega|Ride"] = 71.96, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 19.02, ["Neon"] = 4.24, ["Neon|Ride"] = 30.35, ["Neon|Fly|Ride"] = 141.47, ["Mega"] = 40.69, ["Mega|Ride"] = 95.7, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 32.17, ["Ride"] = 91.88, ["Fly|Ride"] = 211.18, ["Neon"] = 335.65, ["Neon|Ride"] = 345.18, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 1148.48, ["Mega|Ride"] = 1548.54, ["Mega|Fly|Ride"] = 1358.55}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 4.24, ["Ride"] = 139.39, ["Neon"] = 17.07, ["Neon|Ride"] = 110.15, ["Mega"] = 141.47, ["Mega|Ride"] = 557.17, ["Mega|Fly|Ride"] = 420.13}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 362.93, ["Ride"] = 341.25, ["Fly|Ride"] = 445.51, ["Neon"] = 1407.98, ["Neon|Ride"] = 1122.09, ["Neon|Fly|Ride"] = 1262.48, ["Mega|Ride"] = 3373.63, ["Mega|Fly|Ride"] = 3148.68}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 70.88}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 41.99}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 15.74}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 19.02}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 36.99}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 39.38}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 10.5}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 14.43}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 216.57}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 22.32}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 42.34}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 7.82}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 3.71}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 262.33}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 5.24}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 6.77}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 4.67}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 8.34}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 33.74}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 470.37}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 661.86}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 99.26}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1114.32}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 115.5}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 10.53}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.63}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 14.41}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.63}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 27.41}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 72.12}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 43.31}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 33.78}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.63}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 8.86}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 23.42}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 3.4}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 13.12}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.49}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.1}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 22.32}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 21}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 6.56}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 1259.99}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 304.76}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 3.92}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 10.39}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 72.07}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 45.74}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 115.48}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 9.93}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 13.21}},
    ["rbxassetid://1265129435"] = {name = "Gold Snowboard", prices = {["default"] = 187.57}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 187.38}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 22.32}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 6.57}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 31.49}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 20.05}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 3.81}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 104.99}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 22.32}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 8.45}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 3.93}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 28.49}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 10.28}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 4.6}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 42}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.24}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 108.94}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 143.26}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 7.77}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 25.31}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 28.88}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 77.18}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 57.75}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.63}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22272.09}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 168.83}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 39.38}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 52.5}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 35.11}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 39.31}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 41.99}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 42}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 78.46}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 48.61}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 35.9}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 31.49}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 31.5}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 40.47}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 40.69}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 9.17}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 9.09}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 3.91}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 6.75}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 28.88}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 24.15}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.1}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 7.88}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.63}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.63}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 6.19}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 8.48}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 656.25}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 7.2}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 577.33}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 33.49}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.63}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.63}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 262.5}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 103.41}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 93.21}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 44.36}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 42.21}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 225.75}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 30.56}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 6.45}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 14.21}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.63}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.1}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 3.94}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 3.87}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 43.32}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 8.46}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 3.94}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 43.32}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 18.38}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 76.43}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.1}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 1054.78}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 7.3}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 10.39}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 6.54}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 21.74}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 39.38}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 11.46}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.61}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 8.46}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 21}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 18.32}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 122.49}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 111.5}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.52}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 12.69}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 6.25}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 7.05}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.63}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 9.34}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 9.17}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 3.54}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 6.57}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 4.54}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 4.67}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.52}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 7701.24}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 48.2}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 3.19}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 4.44}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 99.37}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 6.57}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 3.94}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 3.86}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 6.57}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 15.65}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 704.26}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 35.44}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 3.94}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 9.18}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 3.56}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 3.93}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 3.81}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 3.56}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 3238.25}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 4.55}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 56.42}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 7.45}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 72.19}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 4.34}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 125.35}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.63}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 14.07}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 3.94}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.63}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 10.5}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 50.7}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 30.19}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 3.93}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.67}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.61}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 13.13}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 6.23}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 4.13}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 3.93}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 117}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.63}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 3.61}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 4.99}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 6.35}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 6.33}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 26.17}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.61}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 39.11}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 16.9}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 117.55}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 2.61}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 64.32}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 7.87}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 2.15}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 983.06}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 7.41}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.61}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 2.63}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 4.46}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 27.47}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 3.72}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 3.92}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 5.97}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 18.17}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 6.22}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 15.75}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 19.69}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.63}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 7.88}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 3.94}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 3.93}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 15.75}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 3.5}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.63}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.26}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 12.79}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 19.48}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 6.57}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 131.15}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 11.82}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.37}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 6.51}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 32.75}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.63}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 11.39}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 2.1}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 48.57}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 24.15}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 5.23}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 10.58}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 78.75}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 3.94}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 4.85}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 17.07}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.63}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 7.88}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 5.23}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 7.76}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 10.58}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 13.13}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 78.75}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 5.25}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.49}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 106.2}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 4.71}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1316.44}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.37}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 187.68}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 3}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.63}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.24}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.63}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 10.5}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 59.07}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 9.19}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 3.94}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.63}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 61.15}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 7.54}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.43}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 3.71}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 3.93}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 7.88}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 6.02}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 49.55}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 7.66}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 73.8}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 3.29}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 19.28}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 8.28}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 6.57}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 22.32}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 52.97}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 10.5}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 3.73}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 69.55}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 6.99}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 6.14}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 11.61}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 68.25}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 57.66}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 57.75}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 295.13}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 3.76}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 39.38}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 124.69}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.34}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 2.63}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 11.82}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 61.69}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 3.93}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 23.63}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 6.3}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 9.38}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 7.66}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 24.94}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 3.83}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 3.92}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 6.57}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 157.1}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 66.94}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 7.88}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 6.57}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 46.47}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 7.76}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 7.39}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 52.5}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 4.24}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 65.63}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 27.2}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1427.5}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 32.69}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 15.74}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 31.4}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 237.48}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 14.44}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 21.13}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 14.02}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 9.19}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 4.94}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 169.32}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 45.94}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 62.98}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 15.54}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 70.88}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 103.69}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 98.43}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 984.38}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 197.88}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 7.07}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 1257.52}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 556.49}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 2.63}},
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